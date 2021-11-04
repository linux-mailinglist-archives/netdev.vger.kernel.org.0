Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702A744539D
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 14:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhKDNPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 09:15:44 -0400
Received: from mail-eopbgr80133.outbound.protection.outlook.com ([40.107.8.133]:32321
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231160AbhKDNPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 09:15:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AdZz5KKqhbBbKVwhOHGWrnv1H9hJ0L4NBWwOGFa1Awix9sPLajbNI4ebSBwATjNcZpXISoEJ5ZfwXFNpSORfo0wL614Dga1bvAXOPs2YeZX8fPYWxlGObcjXN8eDrRSOpvejo9bqTfOBboGbX+cQ439Y4E5XjXtvuetWsutKpA7j0Pvl4IJ6sObYGEq/NWnGaAzQz616U7HmjmnSjDu1tNGwUqQrt+eUXUMhjuzS5zoP7fwj4vrtmEoIiQNaizzsldy21gX3Ihl1+t8tmx9DvqGAh1C6zfJggjmgtb7vhmzPFbaUcFWI1x0MFd9sp2zSqkxPD7efzp1QEIFbDVBDMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7G6/4aQWLIhC2HX8WNr2KM487eRjwe34faUeSwmGKxc=;
 b=Ei+COEAgwkndjc2GQVctKennJ9FZcLfBWqN+WGDzKlJquMd8DY+u2cM7IYNKtgATRV+hnWd0TY+iJPJ5wBXa/t4BodtAEJTm5WIOoHpzLZHPymOLExFTl2AqKf5YbBNGnZTJzwXmY8E5OengYhbjjqAZrGRB2Q1qePfdR9vdN6TMDp9xisZFUlF6nFC12RpzuXsKIc4rC2WyrR/fnrtA8kaX38qX7Chy3pbS2ewmeSD2oSeCB2Wz4dkIq/wa9X3G3gbOJJbfa/YeHIJDbqHNg0dEGXwVnnmUVhucJzt+Dt86apR+XnjOqp/IkF5/fT1ngsS2b7FrceAhUX5FdEm7Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7G6/4aQWLIhC2HX8WNr2KM487eRjwe34faUeSwmGKxc=;
 b=AnGIZihWyDzlYlPVeBs+uaFdte4aVssNT9Xi4aNPqEgHFPcIGFqdc4NvNHokDk+xuCCzRH9FFUYtiMhjiAhDJFhM5VmDy7md+77xu0EJbWorZF8eR8KpN/cFpWn0CJvSMjrb16TypbrQDPlKgdaKE+YrOjSljJkq1HuIp+lIh8o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0367.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:38::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 4 Nov
 2021 13:13:03 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f%5]) with mapi id 15.20.4649.019; Thu, 4 Nov 2021
 13:13:03 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: marvell: prestera: fix patchwork build problems
Date:   Thu,  4 Nov 2021 15:12:52 +0200
Message-Id: <1636031573-20006-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0037.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::19) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by FR0P281CA0037.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:48::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4669.5 via Frontend Transport; Thu, 4 Nov 2021 13:13:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dfa48ab-5b2f-46f0-9fd0-08d99f94d573
X-MS-TrafficTypeDiagnostic: VI1P190MB0367:
X-Microsoft-Antispam-PRVS: <VI1P190MB036726676EB1F41B9D00764C8F8D9@VI1P190MB0367.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9lobP4lW0muyQEzjQJzgAzbXA9NfAVnCDVvPdkhr3ObrV3Zg/vwVLYy7DBJ9seln3U2wa2XnMD2Y7k6JgtFpMOx2/CGwkKM0dYmLZy/G4SODIRIT/BdV9tj3DJc5KJcWXuSigeQQI1n7LH5Idm/DCiXwLMaiBdOSeAK9QUNqU1BzIg0jk0xTI1kwnvKXpeQ12KJqvMQGK/Z0VjoLnD7tOn6Yz7Wk6ipIK+ovEjnCmSeurI6T4H7xYQnoY6BB/lZjz/I0DgqGKu6F+5ERDNPcpBpGab2iMVv+apF5h2/IlklhTdcq4jbCDeQgNoA8JeqCxOr/2Vr0o3UXoiml9bqkV601gmVRPwK8XgYU/w43l9nzkQkcxWC6CHPbX+cbjyIz/swBEgmxx2m35Xdf8mLcqSNhGuocbEuINQmuRvqjXPLuCbFFDcjO9UoIWiQESb+7Pn17zw9dqY65zBZYQ76ekREzMA6zfQUBpExejsDDC3QGUygOooQIke1EwthjMQVh5QsPt/adUcSRVars41a45Z+u70B5YpZ6uwhTELgZy7/u+UvyXq/7wEKJ2uBoP9tW4RN04Ccy30NW0Nt9Z/iE76t5aIleB77zr2ggGMLqaoQKyW0lPq2Ixg2xvKkgsOB8kW88jkowcid+ukwDsGjohrN8/ZCVa7wZzcystggfKNTXfMoQhYiep9+tge99A1rehuRASBcZ67U6xVr9Uejd6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(136003)(366004)(39830400003)(44832011)(8936002)(5660300002)(956004)(6506007)(2616005)(54906003)(83380400001)(2906002)(316002)(6666004)(38100700002)(8676002)(86362001)(38350700002)(186003)(6512007)(26005)(6916009)(4326008)(66476007)(508600001)(36756003)(66946007)(66556008)(52116002)(6486002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NeuHlzzuSB6q8pXX6J0hd2eAKP184O+u24nv6HlPUiv4ZF9j0ReBbIt4Ce7K?=
 =?us-ascii?Q?NkyjErgAeqMba2XZpgTF1HfQPMlnTC4RsbMEezqtVSGXpPF2dqnpGrOuRy/i?=
 =?us-ascii?Q?RISWVs0pgQnyuTpCu0N4cCcXlk/rzrCIwymsjTRhNAMKql8WNHYJ6lE6e+1M?=
 =?us-ascii?Q?+NCGK7SUf9ck9fnoZ8toFFT8qDRlwSsN4PY9MjFK3BzB3ocUxx6sI5nZerd+?=
 =?us-ascii?Q?CSYFSS8rm3MKZR841YNPsgxw2O62xerKvCGipXGttSxkD1iPh2x5TwcIKpKS?=
 =?us-ascii?Q?vm9QS7TMPMXj3gQmt2k51lP6j8gxA17ecXSwoSNFzR0LB0clkZ1u3X5vPaAa?=
 =?us-ascii?Q?zxk8iZtWt9CJIm1byfdrP/+RH2E0ImGU3ZDpVyp/q8ClNyAg8W9v71pLig4d?=
 =?us-ascii?Q?z3xAWl7y31tWybHENmI6Xa/2O5PG7E6WDAVe/OleKdit8F0bCH0GY0e15YDa?=
 =?us-ascii?Q?H96u2Jngy09HDxl3OjyanvJzKLNo2p/8HEb9A+B7deF+M4MVqG/OCr/oSwsD?=
 =?us-ascii?Q?MbUGkRGxkVJrx2PDv2ftQZft0ekEjRVVAhPEsfRyVQMSSVdLrgIWjaUv5T9Q?=
 =?us-ascii?Q?nnK+fyxsoVGPSEOA64bl2BuuGhvKwQ5x4BtS+p3kGxDkV1vFP3BORtJJg48R?=
 =?us-ascii?Q?e0a80b+VQQX0O1M44yUL2OJiefNapRsH5JLOxh6+RGdckdq38wie3+LxAhm2?=
 =?us-ascii?Q?WyE1qZMSmUBTIQJx2iDKB5BRdah0wfyIKmEQQp3+59WpITWiSpl1QzSZcoYZ?=
 =?us-ascii?Q?s/4FoTKh0JhL+g5/QmElrjpIRYzx7rmdilVsGxXPZKPU3v7w+qUEytfrIGse?=
 =?us-ascii?Q?hnkfr7E2Y4DXuA5tXTVgL8bSb532p/O6sQuyc57IwiZQ0JPqYk7TGpzeJCWj?=
 =?us-ascii?Q?zRiCRZczEjvDRQOEOoe7X6+cJqOfdBfvDnv84UskMcXtxqYkweHc6zYUQbbC?=
 =?us-ascii?Q?7s0AKfgWdk/xB0UCAOrJnOJ0hXrJ9lgVSsZsoRVknuvlcoZU5gu7+2KLlSu3?=
 =?us-ascii?Q?A64Pw8+cPdQtNu4jg+BazVc8TDLyxfC09TZfBlgzzBM1WtkWbdblS0pRYmdF?=
 =?us-ascii?Q?7ZetIpq7W33UJEPYDfrtRKGSf7kPIQU3kY/N8zdSddgWc00uvZjofE21QG7S?=
 =?us-ascii?Q?Y9JAtri8KpOaegnEJSOyRZPOVLwITw3C2gujwUN+qjp97e+4/cyTVKQ5VH+0?=
 =?us-ascii?Q?FRnYR0wYSWUQWBYJ9mESFQaHLXPZwabvGmA6lllSL2g4+P++DaSJDVbrnL1p?=
 =?us-ascii?Q?W88erH9Bt7hk7rDFY4K32ejWGCQpPcT3qBZs60+45gw6Xqq2sxDe1XbR0QQo?=
 =?us-ascii?Q?r7qU6cSjGltNUhU3S/3vb0fyMH0DNpyQEAAOHTd2fy+HOWdQpZn2sYYNTIbH?=
 =?us-ascii?Q?Hs0zMI6pag3yNMJBkMfJavMVN/i/toB4p+K8FNscrlWR2d5DL/S8+6fpjU7l?=
 =?us-ascii?Q?Z18WJID5j0zBeD27yaEZBAq2uBFS/OCbl0h5QmyrmZYig4RnubD8QDhe8TSL?=
 =?us-ascii?Q?RUbhMVx6ByGfHA5/TMcFQSgyG4kiyuPxwQgIe0yrpORIygRDgnvXEZ+BUKRI?=
 =?us-ascii?Q?tTvkgIKipyMrNRTYBGpF9VGfzrcaaf4fBfyNzLA1MWmzjOLgxXIvo3XGXt90?=
 =?us-ascii?Q?E+2ZhmUVdc0QEDJA8/aTMPjWuPTw3tDJeuJhQ3acU8T8qaFXAlngunUTRr8H?=
 =?us-ascii?Q?FXpenA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dfa48ab-5b2f-46f0-9fd0-08d99f94d573
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 13:13:03.6160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wS97s4qfTNiRVmHVqItMVeNWRkPmRQs14jZB5hV9HSAk/hLkwvBDCJLLIESu0QDOLSvSOzBqJvM2Gt62tkltm5F4MfhBorPHpbh4RfTdB8o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0367
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

fix the remaining build issues reported by patchwork
in firmware v4.0 support commit which has been already
merged.

Fix patchwork issues:
 - source inline
 - checkpatch

Fixes: bb5dbf2cc64d ("net: marvell: prestera: add firmware v4.0 support")
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_ethtool.c | 3 ++-
 drivers/net/ethernet/marvell/prestera/prestera_hw.c      | 3 ++-
 drivers/net/ethernet/marvell/prestera/prestera_main.c    | 6 ++++--
 drivers/net/ethernet/marvell/prestera/prestera_pci.c     | 3 ++-
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
index 6011454dba71..40d5b89573bb 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
@@ -499,7 +499,8 @@ static void prestera_port_mdix_get(struct ethtool_link_ksettings *ecmd,
 {
 	struct prestera_port_phy_state *state = &port->state_phy;
 
-	if (prestera_hw_port_phy_mode_get(port, &state->mdix, NULL, NULL, NULL)) {
+	if (prestera_hw_port_phy_mode_get(port,
+					  &state->mdix, NULL, NULL, NULL)) {
 		netdev_warn(port->dev, "MDIX params get failed");
 		state->mdix = ETH_TP_MDI_INVALID;
 	}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index f581ab84e38d..78168aff12ff 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -1360,7 +1360,8 @@ int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed)
 int prestera_hw_port_autoneg_restart(struct prestera_port *port)
 {
 	struct prestera_msg_port_attr_req req = {
-		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_PHY_AUTONEG_RESTART),
+		.attr =
+		    __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_PHY_AUTONEG_RESTART),
 		.port = __cpu_to_le32(port->hw_id),
 		.dev = __cpu_to_le32(port->dev_id),
 	};
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 625b40149fac..4369a3ffad45 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -405,7 +405,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 
 	err = prestera_port_cfg_mac_write(port, &cfg_mac);
 	if (err) {
-		dev_err(prestera_dev(sw), "Failed to set port(%u) mac mode\n", id);
+		dev_err(prestera_dev(sw),
+			"Failed to set port(%u) mac mode\n", id);
 		goto err_port_init;
 	}
 
@@ -418,7 +419,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 						    false, 0, 0,
 						    port->cfg_phy.mdix);
 		if (err) {
-			dev_err(prestera_dev(sw), "Failed to set port(%u) phy mode\n", id);
+			dev_err(prestera_dev(sw),
+				"Failed to set port(%u) phy mode\n", id);
 			goto err_port_init;
 		}
 	}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index 5d4d410b07c8..461259b3655a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -411,7 +411,8 @@ static int prestera_fw_cmd_send(struct prestera_fw *fw, int qid,
 		goto cmd_exit;
 	}
 
-	memcpy_fromio(out_msg, prestera_fw_cmdq_buf(fw, qid) + in_size, ret_size);
+	memcpy_fromio(out_msg,
+		      prestera_fw_cmdq_buf(fw, qid) + in_size, ret_size);
 
 cmd_exit:
 	prestera_fw_write(fw, PRESTERA_CMDQ_REQ_CTL_REG(qid),
-- 
2.7.4

