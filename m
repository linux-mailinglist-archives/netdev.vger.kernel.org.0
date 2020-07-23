Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B1722BA27
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgGWXVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbgGWXV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 19:21:28 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C414FC0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 16:21:27 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 37C97891B2;
        Fri, 24 Jul 2020 11:21:24 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1595546484;
        bh=gMxO8i9clW2OX4l94MGgERIuhi2kgyZuM5WdocG61W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=xcEWeqzCPiZuZY6t1JYpYgT6lHKDkwVJXRE7idSVm0XXwjwWMm/TGOZmmyDA6hNVd
         cb6NkNYn1rcdmFbkN1eP7A7B5TEDV47Qea2I0uiYZ6/naJ5fhQ+jm/KHgvmVgIgbtJ
         S8U6IIwO5lE/TICz0l3Dc2iRYZA4d2HMHa+bYjAoqDEUj6IlKZfXh+AnfVeq7lbEEe
         fT6l0OX+7aQzZpqfZeXomKGrHroVrNKdOwdOZh3nIGJ/q5zaRA7BLnKvvqtHnIME4h
         KyL0AeUOWXVQL8S7KXITV6vndrBgPt9wytNI820/ItrmsmhwQSKO1A+2IX8vwu7Ejw
         G0Odv4J6uWAkw==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f1a1b720002>; Fri, 24 Jul 2020 11:21:22 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id E782B13EEB7;
        Fri, 24 Jul 2020 11:21:23 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 1D87A280079; Fri, 24 Jul 2020 11:21:24 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v2 1/3] net: dsa: mv88e6xxx: MV88E6097 does not support jumbo configuration
Date:   Fri, 24 Jul 2020 11:21:20 +1200
Message-Id: <20200723232122.5384-2-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723232122.5384-1-chris.packham@alliedtelesis.co.nz>
References: <20200723232122.5384-1-chris.packham@alliedtelesis.co.nz>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v2:
- Add review from Andrew

 drivers/net/dsa/mv88e6xxx/chip.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
index 6f019955ae42..4ddb6f3035c9 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3494,7 +3494,6 @@ static const struct mv88e6xxx_ops mv88e6097_ops =3D=
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

