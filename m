Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C0A4870D6
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 04:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345623AbiAGDC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 22:02:28 -0500
Received: from mail-eopbgr60129.outbound.protection.outlook.com ([40.107.6.129]:59310
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345620AbiAGDC2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 22:02:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nf7X9pymNciAbUJCRf1V2bYSuAwnn0URXzC9BMKWeleT5rnZtev3VB1YSL+aDE4XFTcZonvwW4PCPW9lFLNLkbN3fDnUYjtLi0tuVjhZfmB24PaVHqYIVUX5nu29QyXbBpcb+AuqzXlIHxpKVD/dl6eTt4fot1/3uS62E5K+zDql9+lq9GlwbrpKc8bK7RtI4yPvpzmM/EsTkURe/Os5QmgNuPWF/bAcIHFO0crz6JjuilDkUFA+3Ir82AruEnRQxvoTNQaT8xJDiEfVvUOXqJ4t56Xg19eE1BXY1/QGiVTlqtQJuLN689E1a+5IPSPJo5VtHKlADBLpNtf4Soa+9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eKVE2rF2FR3RAHYLPnigvRJXvnAjiEMupUPyTWBuNN4=;
 b=HKFW6KYbCKpJC96TwDuVWXfkZ/wzc3kFq/IH6FtUS/EiYSS5CVfNWAxQrPLToKjyQi8nuoZkC8vxFDyVJNMCuyLDOmHGSalGtm4+mkqDZ6xGYxktwIujJXO9d8pVvKzhG+RqABhDRCZwGPPjaA6NlT2BwzcOjEp3dfvN0m/0a5nHd7W4pvIIcfxBs9mO5JANdr1cWLGJU63EPkW1rMAa69gtQyfZkxWzALj9jpoaxuCVNfRRK7VgbRPU6Cqf3FHZXR3Bi1qH4MkJNuU/VFyKbiYMByAZd2bjHzOb7ifPXpboBDejiVSt3LBkts342XvGlIcnEvcRymafatRgEARqTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eKVE2rF2FR3RAHYLPnigvRJXvnAjiEMupUPyTWBuNN4=;
 b=Wwbi+/PGo7W4p6QmekT2dB1MfkaUWH/5Yjf0WqIGtbS+8PBK7lIYEWBbgyt1uIuUCrKyfJgOqwXZ6tSOg6nPg+W8ezJ2gOrhhq/r27v8EhFFleuAPBRaD+V7r4Dst84A+hKTTf3/Wn5OFie6VE7AO3EiwGX8R3UXpiVbMjLJf8Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1316.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:26f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 03:02:26 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%8]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 03:02:26 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        idosch@idosch.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 1/6] net: marvell: prestera: add virtual router ABI
Date:   Fri,  7 Jan 2022 05:01:31 +0200
Message-Id: <20220107030139.8486-2-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220107030139.8486-1-yevhen.orlov@plvision.eu>
References: <20220107030139.8486-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::10) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc844544-878b-4cd2-099a-08d9d18a2256
X-MS-TrafficTypeDiagnostic: AM9P190MB1316:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB131664F6F19F5E883D13A065934D9@AM9P190MB1316.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IQOT78PK47jlcfsqX2CzwvktD/ddx1nwjl/GxcdZDOKZ+fItd1ONj3NY5shajlMow7m8dDhLoIZrffjWN3eX36EQHzTQEonM8Rws6m423vhMSYQswez9zYo+hnSdc5wpTA0R2N4a6jKJU2So1hK7ZABG0J7dOKY75MGCUxi5t7qDXUvgDtjEZp0qkoiJgkQ6f1+X87zT9C6j/dqNvy4Dh8ox8eAF8LfIY+LZOZPYfXKVIC5PYTphQE7wItXGnIPF8d1N5IXaJ60eVEzOKw5LGZszn5qm16YkrUmGfEfThsNoO4FuhcFttqa/PdUXSnN1hKDkKc9cz//ni8VM2N2GEr3szmEbobWr4eL5/q6DKa7DSrmQ2hkhEsMm34uEDmO2YRz9jTHZOQJqaUddWzUmVN00RKmxjrdksHnUt2XZx/H3stdNSeRe3yclnz8q+Vp6fcWDlKkx3EKUVY0LEr9synnmDrLIy5RXfUPZXrTKelqg6XcPN5sgFPLec+KrklFUL4ADhmczDi5Th1Gv1KH5M/JK1VZ4LwpStvlrBcwvK+vcS3a9OZWbSdFgzBDZ8/+8J/ULMuq1IF3p6vPYznqLeSDe4715jvJ2fCy+eA4YFE6Oxki6+B0hExVibP9OVI0dPQneMLX3ghi0LAz0ujhUb+Cormcd4ZF5pJYxc5RmqcBPV27TRNfWJbQjgH86Mr4DpyCy8JBCG0qqVeVSJ5Ua0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(396003)(39830400003)(38350700002)(38100700002)(52116002)(508600001)(316002)(66946007)(66476007)(66556008)(2616005)(6512007)(186003)(6506007)(26005)(4326008)(44832011)(2906002)(5660300002)(6486002)(6666004)(8676002)(36756003)(8936002)(54906003)(86362001)(66574015)(83380400001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZjprdgXfh0gxnqQqJB9wlo1n8k/S8FHWn7HPVfxkbJB9IPSXTU5xL3myI06O?=
 =?us-ascii?Q?WpOuf07vS53DLm2uI0LZUYWTfMAkgR4P2ky7HsfQi/QjbMS6HYE+CS9WKGfj?=
 =?us-ascii?Q?Z1I61N8Hxl3ALvG26XaO3j44bc0Ev52HrdPoUh7RlCpYI+CJHem4ynjvTF+r?=
 =?us-ascii?Q?6S9z/mDY3VIcXrmP3gixGG7V1M2rrqfIfK1QHO3opZ4lNceP5FgNRmfyn86O?=
 =?us-ascii?Q?ny9xoK8HIy7KJ7jm0Zv01PrGqzstGUHU6rq9Y/63P0MtwOkbvWO9LTY1DJ02?=
 =?us-ascii?Q?F4NN+GEFS6eq6lHj6XiOxYaFKw2wGV/Pzd1qVl1qEXKnvO7xc5jHbki5jDjy?=
 =?us-ascii?Q?QdBpV0MKBTyd4s/LJ1uv203WSVuUde06TEUfp5Bc2iMDfTROSDfJuaVy1l/E?=
 =?us-ascii?Q?2I/w9qDfXX3FJlup1P5vb7TPX14xp0Hz9Ec9bvgAnQCyow3S89bCfxx6ns+G?=
 =?us-ascii?Q?iKNxjtkKpcE8aNnudBPuA90do5m2HqJjyWh3Vb+2exuynMksG67YiGi4xlm5?=
 =?us-ascii?Q?ctzf8uR7f7R205uKAmDTzHS0HYVCSH5DIJJHew7aW0JNZDz5/ebUv413GPJw?=
 =?us-ascii?Q?eqI2C5g5pEvdhsMPEmwm64ru59zEqX/z/WiPuvyX2PgIzqMNsvIUfpebuq2J?=
 =?us-ascii?Q?PH+5Za3T3nLXzWNTHqoMwWdorjKOHnbErusYDhiiEvK+wnvCR1nbKIZ/yAd1?=
 =?us-ascii?Q?5RV+JvsaTZUChDdPDGGn305AAYUzPHa59C2ucofxLOZNtnsE4lsxKqT9a+jf?=
 =?us-ascii?Q?s19ckv1i8hhCYLV98hAcfwQ6LqIqYUkRN+5v7xDmZWRw9MzaIHPzQZGUCeWi?=
 =?us-ascii?Q?YLRfkSUUYj14oC97Mbb1cALf5U8F8oA18Z751EttAOaU7Xt819RioyBcLna9?=
 =?us-ascii?Q?Q+kXnLNjdVX+Ly0eX2iPqzkSjKFfJY+LU+S/4zkpyAXxGwN2kEyv24rXBy6F?=
 =?us-ascii?Q?4QZkDkalhqFoXbJ6M7xldlJ5I266heQIiIz9ljG6RNLqRwBLlz+eLEjgjZSU?=
 =?us-ascii?Q?RxL/j6oZ3dtCcaiK89Y0lasn8Nmy5XI3LrbePoRc2hF0O/kJUBJc4gv4RrMi?=
 =?us-ascii?Q?WzpUhpTApHKCVQR5JAPCgXawx6nUqIVH9JLgeSBpAFW8lKqg23MLmSwW+K/d?=
 =?us-ascii?Q?8E57+Z0LUJjDbrmtJa5GYxhBOGeFUc14FPTocoKo5Yt3zCOhkLlM22OQC2YA?=
 =?us-ascii?Q?J/A8ywt3h0Txi7yXhHxtcaynKJKJZJHWvUOTGePKdfYvCBlP+oYR1if2tRyi?=
 =?us-ascii?Q?ZaeOq6cy85WYd/BiqmiJK9QmQkjm5nIwlE+HaoV6quBG8msaPi/SJ359eYRM?=
 =?us-ascii?Q?t1PQwuoiX8veeCfXuwMNHW89js+nvGWSZYB3fZfMM1jPV7ehcuh7fxvPiu5H?=
 =?us-ascii?Q?ulfn1DCWAqyxikicHWEm7wW12LRfPXZd3UTuhRMoppFhW9fSeKBjltrYPPiV?=
 =?us-ascii?Q?Knw1cxZ/3TKhTqqe00iWZWClroCqzokK1eFSVApnQIPaB6VXIvlCzj0SdVHp?=
 =?us-ascii?Q?qZ5T04UmqWv5TJ2QYPma58ncMYULRnYIrMLEpmk2aGxyPUN55mh/4SDmMbAR?=
 =?us-ascii?Q?fQRYuy/wf6kdBKkFJO4dS39z8hoEdy3Ff6zA6WtRJ0/OPVRy2BxtMn7eGyKg?=
 =?us-ascii?Q?mOqSBZwe0wXN3nd7kcXSy5K4BZCsn+5vAPpXmX1/olWKnBVE8er6ywUwEiBc?=
 =?us-ascii?Q?9s1YWw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: cc844544-878b-4cd2-099a-08d9d18a2256
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 03:02:26.2797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RS7sJ666b2qOwzYlWmldOPtGvhaDUiE1LHDO7CQ22+5BD4OR/pGBhGSNxWAl+oItrRDcRK0DI2UUIZ6ISrSj3Ume9g9yFk+RXq893cEpNwI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1316
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add functions and structures to allocate virtual router.
prestera_hw_vr_create() returns index of allocated VR so that we can move
forward and also add another objects (e.g. router interface),
which has link to VR.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>

Change-Id: I45818f08c3ee0a1516415edb6507dfde6bb84732
---
 .../ethernet/marvell/prestera/prestera_hw.c   | 42 +++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  4 ++
 2 files changed, 46 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 6282c9822e2b..9dbd3d99175e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -53,6 +53,9 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_VTCAM_IFACE_BIND = 0x560,
 	PRESTERA_CMD_TYPE_VTCAM_IFACE_UNBIND = 0x561,
 
+	PRESTERA_CMD_TYPE_ROUTER_VR_CREATE = 0x630,
+	PRESTERA_CMD_TYPE_ROUTER_VR_DELETE = 0x631,
+
 	PRESTERA_CMD_TYPE_RXTX_INIT = 0x800,
 
 	PRESTERA_CMD_TYPE_LAG_MEMBER_ADD = 0x900,
@@ -480,6 +483,18 @@ struct prestera_msg_rxtx_resp {
 	__le32 map_addr;
 };
 
+struct prestera_msg_vr_req {
+	struct prestera_msg_cmd cmd;
+	__le16 vr_id;
+	u8 __pad[2];
+};
+
+struct prestera_msg_vr_resp {
+	struct prestera_msg_ret ret;
+	__le16 vr_id;
+	u8 __pad[2];
+};
+
 struct prestera_msg_lag_req {
 	struct prestera_msg_cmd cmd;
 	__le32 port;
@@ -549,6 +564,7 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_acl_action) != 32);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_req) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_stats) != 16);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_req) != 8);
 
 	/* check responses */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_common_resp) != 8);
@@ -561,6 +577,7 @@ static void prestera_hw_build_tests(void)
 	BUILD_BUG_ON(sizeof(struct prestera_msg_rxtx_resp) != 12);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_vtcam_resp) != 16);
 	BUILD_BUG_ON(sizeof(struct prestera_msg_counter_resp) != 24);
+	BUILD_BUG_ON(sizeof(struct prestera_msg_vr_resp) != 12);
 
 	/* check events */
 	BUILD_BUG_ON(sizeof(struct prestera_msg_event_port) != 20);
@@ -1752,6 +1769,31 @@ int prestera_hw_bridge_port_delete(struct prestera_port *port, u16 bridge_id)
 			    &req.cmd, sizeof(req));
 }
 
+int prestera_hw_vr_create(struct prestera_switch *sw, u16 *vr_id)
+{
+	struct prestera_msg_vr_resp resp;
+	struct prestera_msg_vr_req req;
+	int err;
+
+	err = prestera_cmd_ret(sw, PRESTERA_CMD_TYPE_ROUTER_VR_CREATE,
+			       &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
+	if (err)
+		return err;
+
+	*vr_id = __le16_to_cpu(resp.vr_id);
+	return err;
+}
+
+int prestera_hw_vr_delete(struct prestera_switch *sw, u16 vr_id)
+{
+	struct prestera_msg_vr_req req = {
+		.vr_id = __cpu_to_le16(vr_id),
+	};
+
+	return prestera_cmd(sw, PRESTERA_CMD_TYPE_ROUTER_VR_DELETE, &req.cmd,
+			    sizeof(req));
+}
+
 int prestera_hw_rxtx_init(struct prestera_switch *sw,
 			  struct prestera_rxtx_params *params)
 {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 0496e454e148..6d9fafad451d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -238,6 +238,10 @@ int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id);
 int prestera_hw_span_unbind(const struct prestera_port *port);
 int prestera_hw_span_release(struct prestera_switch *sw, u8 span_id);
 
+/* Virtual Router API */
+int prestera_hw_vr_create(struct prestera_switch *sw, u16 *vr_id);
+int prestera_hw_vr_delete(struct prestera_switch *sw, u16 vr_id);
+
 /* Event handlers */
 int prestera_hw_event_handler_register(struct prestera_switch *sw,
 				       enum prestera_event_type type,
-- 
2.17.1

