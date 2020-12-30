Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48DC52E7B8F
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 18:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgL3R2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 12:28:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:36522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbgL3R2M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 12:28:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4D152222A;
        Wed, 30 Dec 2020 17:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609349251;
        bh=MV5Cg6rH7kPJN6lJ4j65bhqgB9V/LCFS14p7G0G9Pwk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IBzbV7OtsDfHEDy5juE9sFynq9SYn0y7+MolwCRam/y4u38bAkMm78y/dgyXqIGsw
         UDjcluCyPPe66CvUmJr7zliVYCBgrN6dudHLc3/k1sramZb4F/FIVi9QsOnqzLjYef
         anPX5MplWnjrUPk3LEilX3RlcFy9TEoTCH0Y0IbJfhb+kXUwYPQsO5oA9DKb2aYYsK
         v5v2gtliqOH/tYxsKE3icAYQgTLy7NRdIfOlYNwS6rN9fl+57Eb5KrZc0viJB9UD2V
         uAxzQ5x1eomQF8iNPi//+CmLGbRLCZzo2ULDRCANa4QgpHkaROnVnoPlTuzmVYF1U7
         iYyzb3mAFYv3g==
Date:   Wed, 30 Dec 2020 18:27:07 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] net: sfp: allow to use also SFP modules which are
 detected as SFF
Message-ID: <20201230182707.4a8b13d0@kernel.org>
In-Reply-To: <20201230170652.of3m226tidtunslm@pali>
References: <20201230154755.14746-1-pali@kernel.org>
        <20201230154755.14746-3-pali@kernel.org>
        <20201230161151.GS1551@shell.armlinux.org.uk>
        <20201230170652.of3m226tidtunslm@pali>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Dec 2020 18:06:52 +0100
Pali Roh=C3=A1r <pali@kernel.org> wrote:

> 	if (!sfp->type->module_supported(&id) &&
> 	    (memcmp(id.base.vendor_name, "UBNT            ", 16) ||
> 	     memcmp(id.base.vendor_pn, "UF-INSTANT      ", 16)))

I would rather add a quirk member (bitfield) to the sfp structure and do
something like this

if (!sfp->type->module_supported(&id) &&
    !(sfp->quirks & SFP_QUIRK_BAD_PHYS_ID))

or maybe put this check into the module_supported method.

Marek
