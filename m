Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537BA36D7A4
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 14:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239579AbhD1Mr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 08:47:58 -0400
Received: from fallback16.mail.ru ([94.100.177.128]:57110 "EHLO
        fallback16.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbhD1Mr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 08:47:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail3;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From; bh=gLYz5gHaoIp4IpXUrmnHijJwgArMMHY7C/f7d2ceA6M=;
        b=BEt4sZE/NqWa+jQS4Ne9CaQ8TRUMu9u0ydVnzbZB6OsiIbdAlwP6COWuSZtNMbd5TrxOw7AlEkeyITz64XiG2OJUzNuiAScFAj3eqftkafw/AnAA++YRhHn9uLjvbIwnmHgpzqUGqGczzHIWanvmXEvqT472Id5uLh1+/aowTlk=;
Received: from [10.161.64.55] (port=36220 helo=smtp47.i.mail.ru)
        by fallback16.i with esmtp (envelope-from <fido_max@inbox.ru>)
        id 1lbjax-0004Al-Nf; Wed, 28 Apr 2021 15:47:11 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail3;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=gLYz5gHaoIp4IpXUrmnHijJwgArMMHY7C/f7d2ceA6M=;
        b=Z1yo6IAUb0BuMjJbfWUyafLC2Ffqbjb5kMdNnf8SrYb9VV6AcFLfq8OErpzOLZM7ruZdtXsv8CxymkZB5OvtCuy/lIpDwRM6NKl4wax6DUsu+vJNTuwB3H1FG4IzD7nkJ8HUvmaW1ttMUloyJcPhpje1Tf3AxyD3iNuPPGy7zYM=;
Received: by smtp47.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1lbjas-0001qw-VW; Wed, 28 Apr 2021 15:47:07 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH 1/1] net: phy: marvell: enable downshift by default
Date:   Wed, 28 Apr 2021 15:48:53 +0300
Message-Id: <20210428124853.926179-1-fido_max@inbox.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9ECFD8CE5F059401075B5680518B3518A9E26A0D900A5ED66182A05F538085040DB9CEA102B2DC1C5B1AD7809002235A197D16355BEEE201104472D036561BDBE
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7D9C4478D0B876341EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F79006377F69ABDCCC31D2058638F802B75D45FF914D58D5BE9E6BC1A93B80C6DEB9DEE97C6FB206A91F05B277D3C22D1058CA8C340FD9ACAC4C21FF262F3407DF4BB9EED2E47CDBA5A96583C09775C1D3CA48CFCA5A41EBD8A3A0199FA2833FD35BB23D2EF20D2F80756B5F868A13BD56FB6657A471835C12D1D977725E5C173C3A84C3CA5A41EBD8A3A0199FA2833FD35BB23DF004C90652538430302FCEF25BFAB3454AD6D5ED66289B5278DA827A17800CE77B089FF177BE8049D8FC6C240DEA7642DBF02ECDB25306B2B78CF848AE20165D0A6AB1C7CE11FEE3E3786DD2C77EBDAA6E0066C2D8992A16C4224003CC836476EA7A3FFF5B025636E2021AF6380DFAD1A18204E546F3947CB11811A4A51E3B096D1867E19FE1407959CC434672EE6371089D37D7C0E48F6C8AA50765F79006371F24DFF1B2961425731C566533BA786AA5CC5B56E945C8DA
X-B7AD71C0: AC4F5C86D027EB782CDD5689AFBDA7A2AD77751E876CB595E8F7B195E1C978310F0397125DB500A98AB617A7AECA58CD
X-C1DE0DAB: C20DE7B7AB408E4181F030C43753B8186998911F362727C414F749A5E30D975C8E0B2E50BE5001AC3EA6CF763F66ACD3C3835E5344AD85C69C2B6934AE262D3EE7EAB7254005DCEDCF20510D834BC2AB1E0A4E2319210D9B64D260DF9561598F01A9E91200F654B01098AAFFB0A1231D8E8E86DC7131B365E7726E8460B7C23C
X-C8649E89: 4E36BF7865823D7055A7F0CF078B5EC49A30900B95165D3435BBF0AC4E3A921C8627F27DB43A9F87990D6D062C5CD24925928A173369CC722056E7338647E35A1D7E09C32AA3244CE5118052ED524936417A8436E720FF58E646F07CC2D4F3D8AD832FF50B3043B1
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojoCaqxM2e5sp7XG6Mee/jwQ==
X-Mailru-Sender: 11C2EC085EDE56FA9C10FA2967F5AB244A181CDD56F4BF7584568C1D6E51A17394D52C0D0BAFAA61EE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
X-7564579A: 646B95376F6C166E
X-77F55803: 6242723A09DB00B45562A35114C4D62A7E062EA9D3FBA00F6D3CB64FEC57215E049FFFDB7839CE9E0088CAACE7D2CDB9DE82184089C85DBC995439242212D7590642F0878C11E30F
X-C1DE0DAB: C20DE7B7AB408E4181F030C43753B8186998911F362727C414F749A5E30D975C8E0B2E50BE5001ACAB5B8B63EF75CF7DCEFD6A4911D1AAE39C2B6934AE262D3EE7EAB7254005DCED575580CBCF75F56B699F904B3F4130E343918A1A30D5E7FCCB5012B2E24CD356
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5xhPKz0ZEsZ5k6NOOPWz5QAiZSCXKGQRq3/7KxbCLSB2ESzQkaOXqCBFZPLWFrEGlV1shfWe2EVcxl5toh0c/aCGOghz/frdRhzMe95NxDFdNaNcGJj3xzOsgM3ruBIdFw==
X-Mailru-MI: 800
X-Mras: Ok
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable downshift for all supported PHYs by default like 88E1116R does.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
---
 drivers/net/phy/marvell.c | 62 +++++++++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 0b2cccb0d865..e6721c1c26c2 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1088,6 +1088,38 @@ static int m88e1011_set_tunable(struct phy_device *phydev,
 	}
 }
 
+static int m88e1112_config_init(struct phy_device *phydev)
+{
+	int err;
+
+	err = m88e1011_set_downshift(phydev, 3);
+	if (err < 0)
+		return err;
+
+	return m88e1111_config_init(phydev);
+}
+
+static int m88e1111gbe_config_init(struct phy_device *phydev)
+{
+	int err;
+
+	err = m88e1111_set_downshift(phydev, 3);
+	if (err < 0)
+		return err;
+
+	return m88e1111_config_init(phydev);
+}
+
+static int marvell_1011gbe_config_init(struct phy_device *phydev)
+{
+	int err;
+
+	err = m88e1011_set_downshift(phydev, 3);
+	if (err < 0)
+		return err;
+
+	return marvell_config_init(phydev);
+}
 static int m88e1116r_config_init(struct phy_device *phydev)
 {
 	int err;
@@ -1168,6 +1200,9 @@ static int m88e1510_config_init(struct phy_device *phydev)
 		if (err < 0)
 			return err;
 	}
+	err = m88e1011_set_downshift(phydev, 3);
+	if (err < 0)
+		return err;
 
 	return m88e1318_config_init(phydev);
 }
@@ -1320,6 +1355,9 @@ static int m88e1145_config_init(struct phy_device *phydev)
 		if (err < 0)
 			return err;
 	}
+	err = m88e1111_set_downshift(phydev, 3);
+	if (err < 0)
+		return err;
 
 	err = marvell_of_reg_init(phydev);
 	if (err < 0)
@@ -2698,7 +2736,7 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E1112",
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
-		.config_init = m88e1111_config_init,
+		.config_init = m88e1112_config_init,
 		.config_aneg = marvell_config_aneg,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
@@ -2718,7 +2756,7 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E1111",
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
-		.config_init = m88e1111_config_init,
+		.config_init = m88e1111gbe_config_init,
 		.config_aneg = m88e1111_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -2739,7 +2777,7 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E1111 (Finisar)",
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
-		.config_init = m88e1111_config_init,
+		.config_init = m88e1111gbe_config_init,
 		.config_aneg = m88e1111_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -2779,7 +2817,7 @@ static struct phy_driver marvell_drivers[] = {
 		.driver_data = DEF_MARVELL_HWMON_OPS(m88e1121_hwmon_ops),
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
-		.config_init = marvell_config_init,
+		.config_init = marvell_1011gbe_config_init,
 		.config_aneg = m88e1121_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -2859,7 +2897,7 @@ static struct phy_driver marvell_drivers[] = {
 		.name = "Marvell 88E1240",
 		/* PHY_GBIT_FEATURES */
 		.probe = marvell_probe,
-		.config_init = m88e1111_config_init,
+		.config_init = m88e1112_config_init,
 		.config_aneg = marvell_config_aneg,
 		.config_intr = marvell_config_intr,
 		.handle_interrupt = marvell_handle_interrupt,
@@ -2929,7 +2967,7 @@ static struct phy_driver marvell_drivers[] = {
 		/* PHY_GBIT_FEATURES */
 		.flags = PHY_POLL_CABLE_TEST,
 		.probe = marvell_probe,
-		.config_init = marvell_config_init,
+		.config_init = marvell_1011gbe_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -2955,7 +2993,7 @@ static struct phy_driver marvell_drivers[] = {
 		.probe = marvell_probe,
 		/* PHY_GBIT_FEATURES */
 		.flags = PHY_POLL_CABLE_TEST,
-		.config_init = marvell_config_init,
+		.config_init = marvell_1011gbe_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -3000,7 +3038,7 @@ static struct phy_driver marvell_drivers[] = {
 		/* PHY_GBIT_FEATURES */
 		.flags = PHY_POLL_CABLE_TEST,
 		.probe = marvell_probe,
-		.config_init = marvell_config_init,
+		.config_init = marvell_1011gbe_config_init,
 		.config_aneg = m88e6390_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -3026,7 +3064,7 @@ static struct phy_driver marvell_drivers[] = {
 		/* PHY_GBIT_FEATURES */
 		.flags = PHY_POLL_CABLE_TEST,
 		.probe = marvell_probe,
-		.config_init = marvell_config_init,
+		.config_init = marvell_1011gbe_config_init,
 		.config_aneg = m88e6390_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -3052,7 +3090,7 @@ static struct phy_driver marvell_drivers[] = {
 		/* PHY_GBIT_FEATURES */
 		.flags = PHY_POLL_CABLE_TEST,
 		.probe = marvell_probe,
-		.config_init = marvell_config_init,
+		.config_init = marvell_1011gbe_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -3077,7 +3115,7 @@ static struct phy_driver marvell_drivers[] = {
 		.driver_data = DEF_MARVELL_HWMON_OPS(m88e1510_hwmon_ops),
 		.probe = marvell_probe,
 		/* PHY_GBIT_FEATURES */
-		.config_init = marvell_config_init,
+		.config_init = marvell_1011gbe_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
@@ -3099,7 +3137,7 @@ static struct phy_driver marvell_drivers[] = {
 		.driver_data = DEF_MARVELL_HWMON_OPS(m88e1510_hwmon_ops),
 		.probe = marvell_probe,
 		.features = PHY_GBIT_FIBRE_FEATURES,
-		.config_init = marvell_config_init,
+		.config_init = marvell_1011gbe_config_init,
 		.config_aneg = m88e1510_config_aneg,
 		.read_status = marvell_read_status,
 		.config_intr = marvell_config_intr,
-- 
2.30.2

