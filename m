Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B626B22A650
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 06:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgGWD7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 23:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbgGWD7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 23:59:53 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C3EC0619E4
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 20:59:52 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id E38F88066C;
        Thu, 23 Jul 2020 15:59:50 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1595476790;
        bh=XTn/PmVayzyMMzE1OUNCKIJxHT8Ny5azmHylgrBJrGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=D/B6xvzoDNIZmOxdcPBk2zO56d5e+ZxfscGGMi3k8+7DBxDR595VZdj3WnBemoJCE
         OaMv0L9gCpJGiNgrOdKwPgpbs/hHN5LCoHNVH+zdjPPCyoWLnfPr9vki2pH3SvtS+E
         ZovY/JHqFmaGGzOMlBh8uaz6nc/JpZPhSWgQ0GLF3OcRUMqU2xEifScNvFbKcSJ23N
         BIAN+6lP0eZL0ilUU6gkJn35wJPcHfmc1cy61M7xGC0+xgghNIOg2pia6wrr0eBJOn
         /t6QW1HP56de8BRaM6l3rfPqqkCE0EcxlgL8TrY/mHvv53Hs4LB2px74UEZfPlkd/7
         1YzFEH3uVaM5Q==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f190b370000>; Thu, 23 Jul 2020 15:59:51 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id 7AD6113EEA1;
        Thu, 23 Jul 2020 15:59:49 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id A9586280079; Thu, 23 Jul 2020 15:59:50 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 1/4] net: dsa: mv88e6xxx: MV88E6097 does not support jumbo configuration
Date:   Thu, 23 Jul 2020 15:59:39 +1200
Message-Id: <20200723035942.23988-2-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723035942.23988-1-chris.packham@alliedtelesis.co.nz>
References: <20200723035942.23988-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MV88E6097 chip does not support configuring jumbo frames. Prior to
commit 5f4366660d65 only the 6352, 6351, 6165 and 6320 chips configured
jumbo mode. The refactor accidentally added the function for the 6097.
Remove the erroneous function pointer assignment.

Fixes: 5f4366660d65 ("net: dsa: mv88e6xxx: Refactor setting of jumbo fram=
es")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
index 7627ea61e0ea..fbfa4087eb7b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3469,7 +3469,6 @@ static const struct mv88e6xxx_ops mv88e6097_ops =3D=
 {
 	.port_set_frame_mode =3D mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods =3D mv88e6352_port_set_egress_floods,
 	.port_set_ether_type =3D mv88e6351_port_set_ether_type,
-	.port_set_jumbo_size =3D mv88e6165_port_set_jumbo_size,
 	.port_egress_rate_limiting =3D mv88e6095_port_egress_rate_limiting,
 	.port_pause_limit =3D mv88e6097_port_pause_limit,
 	.port_disable_learn_limit =3D mv88e6xxx_port_disable_learn_limit,
--=20
2.27.0

