Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBF4212934
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgGBQV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:21:26 -0400
Received: from mail.nic.cz ([217.31.204.67]:50828 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgGBQVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 12:21:25 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 7B1FC1409F6;
        Thu,  2 Jul 2020 18:21:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1593706880; bh=LzEvF+loEnLr2A5MKwBODv9gmgsJyPA/g3qIPGTKNCA=;
        h=Date:From:To;
        b=QfW6jajp52TTQ/nnTP3a6NvaL6/IArH2vzgbir6cbigAVVXnnGh8Gi+HccSd6zV7W
         P9GlIp3C5bcjtC6rTPms/ErryIgZMLW9+X4rUsNl3t/C58gt/QemrJv/CdQcCTSzOE
         xpHw135h66bVkq5ChPcRxX9mM1cnoKH/ebIZvgR4=
Date:   Thu, 2 Jul 2020 18:21:20 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org
Subject: 2500base-x capable sfp copper module?
Message-ID: <20200702182120.6d11bf70@dellmb.labs.office.nic.cz>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

We are trying to find a copper SFP module capable of 2.5G speeds for
Turris Omnia (2500base-x is max for SERDES on Omnia).

We have tried MikroTik S+RJ10, which is a 10G capable copper SFP
module. But this module does not export access (via I2C) to its internal
PHY (which should be Marvell 88X3310).
Without access to the PHY it seems that the host side of the SFP is
configured at 10G and we are unable to change it to 2500base-x.

We have another module, Rollball RTSFP-10G, which contains the same
PHY, but this is visible on the I2C bus at address 0x56.
For some reason I am unable to access registers of the PHY via clause
45 protocol. The code in drivers/net/phy/mdio-i2c.c always returns
0xffff when reading via clause 45.
When accessing via clause 22, the registers are visible, but we are
unable to change to 2500base-x with these registers.

Do you think this is a problem of how the SFP module is
wired/programmed?

Do you know of 2500base-x capable copper SFP module which would work?
Maybe one based on the same Marvell PHY, but such that the clause 45
register access works?

Thank you.

Marek
