Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0C14A9A10
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 14:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353092AbiBDNgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 08:36:51 -0500
Received: from mail.savoirfairelinux.com ([208.88.110.44]:54368 "EHLO
        mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiBDNgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 08:36:50 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id EF2D99C0222;
        Fri,  4 Feb 2022 08:36:48 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id FIS6siOK1rkg; Fri,  4 Feb 2022 08:36:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 951C79C0215;
        Fri,  4 Feb 2022 08:36:48 -0500 (EST)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id rpqlslm6-PnL; Fri,  4 Feb 2022 08:36:48 -0500 (EST)
Received: from localhost.localdomain (85-170-128-172.rev.numericable.fr [85.170.128.172])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id AF8359C0214;
        Fri,  4 Feb 2022 08:36:47 -0500 (EST)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk
Subject: [PATCH 0/2] net: phy: micrel: add Microchip KSZ 9897 Switch PHY support
Date:   Fri,  4 Feb 2022 14:36:33 +0100
Message-Id: <20220204133635.296974-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
I've recently used a KSZ9897 DSA switch that was connected to an i.MX6 CP=
U
through SPI for the DSA control, and RMII as the data cpu-port. The SPI/D=
SA was
well supported in drivers/net/dsa/microchip/ksz9477.c, but the RMII conne=
ction
was not working. I would like to upstream the patch I developped to add s=
upport
for the KSZ9897 RMII bus. This is required for the cpu-port capability of
the DSA switch and have a complete support of this DSA switch.

Since PHY_ID_KSZ9897 and PHY_ID_KSZ8081 are very close, I had to modify t=
he mask
used for the latter. I don't have this one, so it would be very appreciat=
ed if
someone could test this patch with the KSZ8081 or KSZ8091. In particular,=
 I'd
like to know the exact phy_id used by those models to check that the new =
mask is
valid, and that they don't collide with the KSZ9897. The phy_ids cannot b=
e found
in the datasheet, so I couldn't verify that myself.

My definition of the struct phy_driver was copied from the similar
PHY_ID_KSZ8873MLL and proved to work on a 5.4 kernel. However, my patch m=
ay not
support the Gigabit Ethernet but works reliably otherwise.

The second patch fixes an issue with the KSZ9477 declaration I noticed. I
couldn't find PHY_ID_KSZ9477, or an equivalent mask in the MODULE_DEVICE_=
TABLE
declaration. I fear the driver is not initialized properly with this PHY.=
 I
don't have this model either so it would be great if someone could test t=
his.


