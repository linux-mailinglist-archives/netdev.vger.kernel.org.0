Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2919836F536
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 06:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhD3E4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 00:56:39 -0400
Received: from smtp50.i.mail.ru ([94.100.177.110]:33850 "EHLO smtp50.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230181AbhD3E4i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 00:56:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail3;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=NdccvJJR0TFl7HtI/NnK/dBjWki6SRcDk7Qhse+6rYE=;
        b=L5jFQ+Y52Vyg2bByKzSEjdLMPcGkcAhbPaPgdL7uactxv990NwYyfoJdMmjyebOuSRE7EnJCaYV0vqLjZsdmL7u71p6rjPFfmTAK8iEVaVivICnEpN7eJDaphI07E3RcVao3lGSigYgAVRUVIhnnHuT8bhJgsIUUuOETHrVywpY=;
Received: by smtp50.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1lcLBs-0000Ih-R7; Fri, 30 Apr 2021 07:55:49 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH v2 1/1] net: phy: marvell: enable downshift by default
Date:   Fri, 30 Apr 2021 07:57:33 +0300
Message-Id: <20210430045733.6410-1-fido_max@inbox.ru>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp50.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD95978C26455E69BE0B2C7F7C3B0039F139F0EF8E3717E163C182A05F5380850405D699DA7DA45B78F0F405285C2DC53166E5C3A7542B20DD8C3B8085D9E1BD58B
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE7CE4525FFB91B9BBCEA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F7900637531CC3E3F637A59A8638F802B75D45FF914D58D5BE9E6BC1A93B80C6DEB9DEE97C6FB206A91F05B2FB7EA12E302782173C7829C7B2085A7028451B159A507268D2E47CDBA5A96583C09775C1D3CA48CFCA5A41EBD8A3A0199FA2833FD35BB23D2EF20D2F80756B5F868A13BD56FB6657A471835C12D1D977725E5C173C3A84C3CA5A41EBD8A3A0199FA2833FD35BB23DF004C90652538430302FCEF25BFAB3454AD6D5ED66289B5278DA827A17800CE73177526CD55AFC117B076A6E789B0E97A8DF7F3B2552694A1E7802607F20496D49FD398EE364050F140C956E756FBB7A500AC0B2F9B62304B3661434B16C20AC78D18283394535A9E827F84554CEF5019E625A9149C048EE9ECD01F8117BC8BEE2021AF6380DFAD18AA50765F790063735872C767BF85DA227C277FBC8AE2E8B2303E78B907142AC75ECD9A6C639B01B4E70A05D1297E1BBCB5012B2E24CD356
X-B7AD71C0: AC4F5C86D027EB782CDD5689AFBDA7A24209795067102C07E8F7B195E1C97831E62296FB38E73CF2AC1B55117025DB7A
X-C1DE0DAB: 8BD88D57C5CADBC8B2710865C38675100920FC4EF0AE1D47A3B1A56EE2B804F6B226C914C9968946695E9D90444CEC264DCC8C77FBA9901322D2CEDE4E95CF1BDBE8DEE28BC9005C095FFBCAB1CFE8AAD6CF32B5F8F9D404031118DB7BCC4EBD59B0A2F49AC04002589120F7DAE46353205367B2BCC23E5BF4EE136C8E373FB4BDAD6C7F3747799A
X-C8649E89: 4E36BF7865823D7055A7F0CF078B5EC49A30900B95165D349A949488F6BF46DDA1DD6696E3D118A633C2FFE8938BF83B2CE046A259DEBAD972C421ED5425A27A1D7E09C32AA3244C9C02812023710040C8CD295CBEDBEB68F94338140B71B8EEAD832FF50B3043B1
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojVCmWsvwT1Hba81e+UJFYRA==
X-Mailru-Sender: 11C2EC085EDE56FA9C10FA2967F5AB244C665F6C7CFA2A6715DB827A191C3BBD4EAB46A6D34EF626EE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A number of PHYs support the PHY tunable to set and get
downshift. However, only 88E1116R enables downshift by default. Extend
this default enabled to all the PHYs that support the downshift
tunable.

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
---

Changes v1 -> v2:
 - Expand commit message

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

