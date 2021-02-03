Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545A730E04A
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 17:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhBCQ5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 11:57:18 -0500
Received: from mail-eopbgr60107.outbound.protection.outlook.com ([40.107.6.107]:21313
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230070AbhBCQ4x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 11:56:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjcTkBqlMcA0jwdpEnqh3OLDCdjDZUHwd/vANFNFAvzZYOeFY+pJsHeyFFSlD4c/piL53peatpZ9szculDjcIeuOyhaATsynKGHKbJrMNAES2EFLEX8VFhFMt/OL7Gy9bUFnphYReR9GZ91bnwX1cnL3MUvUIKlYeZnRpt6orNEmovsGcORAMv8aUezKByrGwO7cDeK6yM8pTxp28UVYyzt5TCEjYL4kiXytVYDNrbpCK61y5hnjZ78WtZvibSeRJP3mFryS4vYuu2TyGV0fry/kVThlRtYw6pzJJ705+JKVYLox/pvaXostXTXT6NniNIVUKVSeKTSsJ8SJKFP+9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0S9Hkz7cQJM0ta0QTcwlL9tSkCOPqJNCWO45uI5aBfs=;
 b=cD6kNEQuwaKSUAs4GmHvOX+xEeRdTTnC9TqxnOnBGd41SHJT46SXBhgOm2Vhx2Q1+dGL0fN5BabmkbtKpuKBDp4XKEnt0PGqRxJD2C6etccwuaj+gMtDW4HE/42LuH+ixF1kICaU6WqdmojMaChOaYeJ6PtzHN3sGyCIE0y6dgUBGYWxCsJcjr2kabOLcmjesUJ7v6Xg4YFtEf6RVhbLMCQjhi23mRzijhmAgAHCmH0r/wwOSDi1e46Licy9HWCfgDHiF0yyQK0SszES3oMP6cX/il3+GFdDhXfiULk8ByYUwNtM5vR7vkl1stwhTronGO+XWZELyCAwh5/sl1TSjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0S9Hkz7cQJM0ta0QTcwlL9tSkCOPqJNCWO45uI5aBfs=;
 b=ly0mH1Juxg1I7HtX64/gjscoqO1oOcJv/xVUAPiC6nISD/nSfl4zrnIEFP6x9uYB4XK0HYyX5w1l1Dir9hD940JzRch5wwGARb91v/g1ARrVjaQ9RfP0pgdJVSW1UzyVEQtQyJepDG0+7bf2k4dJtcAOzz3u/hYCK6XLwPk7qXk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.16; Wed, 3 Feb 2021 16:55:55 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f%5]) with mapi id 15.20.3805.023; Wed, 3 Feb 2021
 16:55:54 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        netdev@vger.kernel.org
Cc:     Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/7] net: marvell: prestera: disable events interrupt while handling
Date:   Wed,  3 Feb 2021 18:54:53 +0200
Message-Id: <20210203165458.28717-3-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210203165458.28717-1-vadym.kochan@plvision.eu>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0145.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::30) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0145.eurprd04.prod.outlook.com (2603:10a6:20b:127::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 16:55:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9294346-1713-4dad-73bf-08d8c8649209
X-MS-TrafficTypeDiagnostic: HE1P190MB0539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB05394A103EB5FE78C01E5D4195B49@HE1P190MB0539.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xNYK4e8BndsQu7s/X7gBzVVOS1DV+qYFTRe6XApmiHhJg/IK74pnTIL/qa3HZsrpo3aktKfvRTU1k4v35GnWWe+dY/llNA25kjczwaLoVXvJFRaPsZM6o5cQKfndOL+sLX+rKn8YXBV+qeR1Ub/IfbKbCX00OWPVFIvl+3dmetV9uJ6wHfqZrsoqktWjAjBvwQ64qfB1IEQOCHNGpJ+ZRXplSY8QeUJS+aHLU1U47CIQYC8yYO5VeZSM+EU5lmiSlWDStTJS5JME6bcgOuhWo7g3AqOm3ln/GSAuen9+bvhqJ42ZIj0ummsV/wi8+fYBW9cAuHgmG36Hai/pMZaScvCMuLDIREGB5a2ZIyEupEMGFBoyDUQktOxueArr21WnkbDr78DSu4KeACpgVoIkiu4P36/EvERKdPKpCyCiI4ZBaZlnVvJjNBS2EDgU7MKwetVxcA7bB9rW2SHfr2piOZ8sIN4KGTDY624nIN247gAiFyQpRE+RABfwNuluWVo/feX8GvXGEgTBQWe1v3D/Kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(376002)(136003)(346002)(478600001)(6486002)(110136005)(54906003)(8676002)(66556008)(44832011)(5660300002)(956004)(4326008)(6506007)(16526019)(36756003)(86362001)(186003)(26005)(6512007)(52116002)(2906002)(316002)(2616005)(66946007)(8936002)(1076003)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?veTjTVJO/tg2zNpnxxs5SVVH3rste3q6GAx2cpman2OCHnTHS/PSX+3z4/tv?=
 =?us-ascii?Q?wFB8jQeNuVqcEft3Ax38HTd+RLNwHM04oqaX9UzL+scwQ8ueu2aftqBYcblB?=
 =?us-ascii?Q?Z+qBIGQAvttfQMwoawaemURDzsH/+Ypq46zkm4dLbHi93qAqnkwuq1yCPX2s?=
 =?us-ascii?Q?yx052Xp+Etv0GIrvqAku2vBckoR01rPlbzX+A9jlMzETl2mkYqQpJWsYWSC/?=
 =?us-ascii?Q?bNaKRhOoLdQ9AvJayhlxle5Hfwieu+aqoJQaVhjMwvVbfswEd7nbQXWkRzls?=
 =?us-ascii?Q?+BEg/Ec88hkt91pKkbzPjPbPNLZTBdfjCzwkNu5/9t8EM8l7U33KmPDXSaQf?=
 =?us-ascii?Q?xSCjcQAHQmo6oIneC0B4vh7ydWuvsECpPpxj7Y2B4hX6WE/45SuitE5TWWJN?=
 =?us-ascii?Q?/hNFE0yhx66zjVKJpCGJhAZ6SkXiT0eufzenl/cnwRggjH7KCriToRIM2d5s?=
 =?us-ascii?Q?d6fhMZ8msnIaQCSdldZOwcycxv2Nup3U0lrZpnvJWV7vQthA/Ynj+KxdcJiQ?=
 =?us-ascii?Q?OST5nzwbIMB8VRo/pydiTv4DvdgnlGGNod36UwNaqiznM4XbYjDbuSakl2gl?=
 =?us-ascii?Q?OGI/EQcd095UQipyGjmkzmddWpoxQEjPH9iW9iqqbY5PSaEJltm0VmgO5wHY?=
 =?us-ascii?Q?1Hi2pIuL9iu27IhTrDXzeqB94hcIcklBSIbTr+XQ8b/m24SfoR20L0z+Y5M4?=
 =?us-ascii?Q?dzw8LSlJ067KvEnCJsa7Tsx0eYZ2XjcOfIHlMMynn4+tLWPfcGtmaEx96v8H?=
 =?us-ascii?Q?jOW4u1pP88+Q/hnh5apbTxLP7AgpCbj3Ju1ep1eEesVkdaHbPaR+MOtyaEm5?=
 =?us-ascii?Q?IIKoGjQudcBLKeeRZBRhab7ZYw+pWtq1rkJ9cG43gBrJItmeQ12xlzt/a6og?=
 =?us-ascii?Q?Nn9reeW1NjaN+e1+QM96415JH8Hi+IomDhlpDG5EiiyJUYWdtzTkV3OKVbAS?=
 =?us-ascii?Q?WSNnBussjgDJBXVvY6HF9kjjIFXYRzEwEZXg/UGfUS0XMFRlSKW61FXaiMXk?=
 =?us-ascii?Q?ov5rY+FcR8Nk6qBkR3+kkgpRteT6VNWX/9H6G3NAEuxAGhmfrsvOBQsKrPJ2?=
 =?us-ascii?Q?J8bC0dbktWZyymulsVwfiyn2lOVKM13nAzZZG4tGBSWrGOYcokrcYTWt/90D?=
 =?us-ascii?Q?KcI3+/o9X72EtN71/3RHkuVxGTbiB8gBPM4HXno23byWGoZRPy+L6ji/s1yK?=
 =?us-ascii?Q?B0jVPtfsqXVoO/iQ7gFBWN0BmtN5tR7llMwMR1HTpFO1aZr9Qjml1mWQ3d1y?=
 =?us-ascii?Q?2E2I03dum1lWbx9D9xiX7NHGyo3W4SWp/s/dfKIgcqPYMtj39C4FM0tZmu+s?=
 =?us-ascii?Q?bzjx6S8ZI3ceh7qkxnOWUDdQ?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: c9294346-1713-4dad-73bf-08d8c8649209
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 16:55:54.8411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SzlNEmmFEsmT9Y8b7GJemDbXQaC2iSuzvHsg1r5I0e0me/vjJJt/RMvmcXSRGCrK1cg0uLWyFKqeoZe91aVqMyoaDOTPv2R6fVlgEK4qtC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0539
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are change in firmware which requires that receiver will
disable event interrupts before handling them and enable them
after finish with handling. Events still may come into the queue
but without receiver interruption.

Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 .../ethernet/marvell/prestera/prestera_pci.c  | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index b8a87d249647..f7b27ef02624 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
 /* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
 
+#include <linux/bitfield.h>
 #include <linux/circ_buf.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
@@ -144,6 +145,11 @@ struct prestera_fw_regs {
 /* PRESTERA_CMD_RCV_CTL_REG flags */
 #define PRESTERA_CMD_F_REPL_SENT	BIT(0)
 
+#define PRESTERA_FW_EVT_CTL_STATUS_MASK	GENMASK(1, 0)
+
+#define PRESTERA_FW_EVT_CTL_STATUS_ON	0
+#define PRESTERA_FW_EVT_CTL_STATUS_OFF	1
+
 #define PRESTERA_EVTQ_REG_OFFSET(q, f)			\
 	(PRESTERA_FW_REG_OFFSET(evtq_list) +		\
 	 (q) * sizeof(struct prestera_fw_evtq_regs) +	\
@@ -260,6 +266,15 @@ static u8 prestera_fw_evtq_pick(struct prestera_fw *fw)
 	return PRESTERA_EVT_QNUM_MAX;
 }
 
+static void prestera_fw_evt_ctl_status_set(struct prestera_fw *fw, u32 val)
+{
+	u32 status = prestera_fw_read(fw, PRESTERA_FW_STATUS_REG);
+
+	u32p_replace_bits(&status, val, PRESTERA_FW_EVT_CTL_STATUS_MASK);
+
+	prestera_fw_write(fw, PRESTERA_FW_STATUS_REG, status);
+}
+
 static void prestera_fw_evt_work_fn(struct work_struct *work)
 {
 	struct prestera_fw *fw;
@@ -269,6 +284,8 @@ static void prestera_fw_evt_work_fn(struct work_struct *work)
 	fw = container_of(work, struct prestera_fw, evt_work);
 	msg = fw->evt_msg;
 
+	prestera_fw_evt_ctl_status_set(fw, PRESTERA_FW_EVT_CTL_STATUS_OFF);
+
 	while ((qid = prestera_fw_evtq_pick(fw)) < PRESTERA_EVT_QNUM_MAX) {
 		u32 idx;
 		u32 len;
@@ -288,6 +305,8 @@ static void prestera_fw_evt_work_fn(struct work_struct *work)
 		if (fw->dev.recv_msg)
 			fw->dev.recv_msg(&fw->dev, msg, len);
 	}
+
+	prestera_fw_evt_ctl_status_set(fw, PRESTERA_FW_EVT_CTL_STATUS_ON);
 }
 
 static int prestera_fw_wait_reg32(struct prestera_fw *fw, u32 reg, u32 cmp,
-- 
2.17.1

