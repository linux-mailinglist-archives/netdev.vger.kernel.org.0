Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0132F19BF
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 16:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732625AbhAKPdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 10:33:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:56748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729871AbhAKPdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 10:33:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F3C922795;
        Mon, 11 Jan 2021 15:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610379157;
        bh=5b00I49SQeSeQ1irJIjVV/jPcdzaMd0WfUJdXSf4GUs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SZmlS63uOGmQQ9tlzQKnSi55tx1tu6dsWsXqWEpwIldadW5HQRLfhV7w515pTxp3f
         uydJHj5/ncyzqxdXQ7k+8HVPL9aZcCFQgwgfDKlexfnAtLFppMIwLl/1NzQ5h0EZu5
         6H6uhsPzZtTWtld+WdyRrBFRuhJX/8E8tvQqNz7R7kun8PTHmGzceozy82SmH88tnU
         L8QDNOX+EodvcrI7S4x2RJm2e3jssCOBT1uLHR/6jL2wBjRGViGAG0iKKRmElg+AfK
         XaTlG/5rdBAqfn/X1k23TowT4f8xKTYojc4kIobVXI9DeL/YJnrqOBEb+C2r+9j2Wj
         3oeTePzdkL8Hg==
Date:   Mon, 11 Jan 2021 16:32:32 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] net: sfp: add mode quirk for GPON module
 Ubiquiti U-Fiber Instant
Message-ID: <20210111163232.18e7edcb@kernel.org>
In-Reply-To: <20210111113909.31702-3-pali@kernel.org>
References: <20201230154755.14746-1-pali@kernel.org>
        <20210111113909.31702-1-pali@kernel.org>
        <20210111113909.31702-3-pali@kernel.org>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 12:39:09 +0100
Pali Roh=C3=A1r <pali@kernel.org> wrote:

> SFP GPON module Ubiquiti U-Fiber Instant has in its EEPROM stored nonsense
> information. It claims that support all transceiver types including 10G
> Ethernet which is not truth. So clear all claimed modes and set only one
> mode which module supports: 1000baseX_Full.

The Ubiquiti U-Fiber Instant SFP GPON module has nonsensical
information stored in int EEPROM. It claims to support all transceiver
types including 10G Ethernet. Clear all claimed modes and set only
1000baseX_Full, which is the only one supported.

> Also this module have set SFF phys_id in its EEPROM. Kernel SFP subsustem
> currently does not allow to use SFP modules detected as SFF. Therefore add
> and exception for this module so it can be detected as supported.

This module has also phys_id set to SFF, and the SFP subsystem
currently does not allow to use SFP modules detected as SFFs. Add
exception for this module so it can be detected as supported.

> This change finally allows to detect and use SFP GPON module Ubiquiti
> U-Fiber Instant on Linux system.
>
> Original EEPROM content is as follows (where XX is serial number):
>=20
> 00: 02 04 0b ff ff ff ff ff ff ff ff 03 0c 00 14 c8    ???........??.??
> 10: 00 00 00 00 55 42 4e 54 20 20 20 20 20 20 20 20    ....UBNT
> 20: 20 20 20 20 00 18 e8 29 55 46 2d 49 4e 53 54 41        .??)UF-INSTA
> 30: 4e 54 20 20 20 20 20 20 34 20 20 20 05 1e 00 36    NT      4   ??.6
> 40: 00 06 00 00 55 42 4e 54 XX XX XX XX XX XX XX XX    .?..UBNTXXXXXXXX
> 50: 20 20 20 20 31 34 30 31 32 33 20 20 60 80 02 41        140123  `??A
