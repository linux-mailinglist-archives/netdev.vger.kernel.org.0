Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D32A293F61
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 17:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408622AbgJTPPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 11:15:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408610AbgJTPPq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 11:15:46 -0400
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF52E2222D;
        Tue, 20 Oct 2020 15:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603206945;
        bh=Kk3kTHYNw886Gm3sRDZNzSaMqbQpyJr3dHuuESCvyM4=;
        h=Date:From:To:Cc:Subject:From;
        b=U5p8CK5ngA4y7YyB0I1iwmUEeDnPDzqXrGrO7OnFn4ZzK1VOzGcR+luz6SyO0QSB7
         C5/dtEwN7MknrPn2cJXV4bMX0tMt5n3Qxf79TyMEVC5Knvg39hrw2Ek5r0Lafr7inZ
         t9S2Yw8wePio04QZgpaBzc/sZ8cetni+g1rTN9hA=
Date:   Tue, 20 Oct 2020 17:15:39 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org
Subject: russell's net-queue question
Message-ID: <20201020171539.27c33230@kernel.org>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Russell,

I think the following commits in your net-queue should be still made better:

7f79709b7a15 ("net: phy: pass supported PHY interface types to phylib")
eba49a289d09 ("net: phy: marvell10g: select host interface configuration")

http://git.arm.linux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=eba49a289d0959eab3dfbc0320334eb5a855ca68
http://git.arm.linux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=eba49a289d0959eab3dfbc0320334eb5a855ca68

The first one adds filling of the phydev->host_interfaces bitmap into
the phylink_sfp_connect_phy function. It should also fill this bitmap
in functions phylink_connect_phy and phylink_of_phy_connect (direct
copy of pl->config->supported_interfaces).
The reason is that phy devices may want to know what interfaces are
supported by host even if no SFP is used (Marvell 88X3310 is an exmaple
of this).

The second patch (adding mactype selection to marvell10g) can get rid
of the rate matching code, and also
should update the mv3310_update_interface code accordignly.

Should I sent you these patches updated or should I create new patches
on top of yours?

Marek
