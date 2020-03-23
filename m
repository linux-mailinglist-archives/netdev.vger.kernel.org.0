Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7BC318F967
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 17:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbgCWQMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 12:12:39 -0400
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:18336
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727302AbgCWQMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 12:12:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZeBa57tnRCVNZXzLPWFEVS/TgvtBZp6YhwpSPK4iGHJu7e88hw40qiPpuo3iBdabNWNJsZeTnsE+uvajxgJbZZYQrGBDNpGVrtN2to03pVc0GkHDiSh+WjlekcRhQONC8t34WbfnniW2VukalSE5NN6bKCm9TwbvM1mmrYpJzAo5zF6sne3wCcJ20g9YBDU3nf7lS+Vn+WPdOdQwoHQvE8/F1dY0PbAiqGiSntJemUw1wc0YK+iNLSU+qSt77GN21Wi/emJRY/hOOs+HPxF75O2JCRew8yyBGo2mRIVdow1ExgbQNV3zV0KoAt4Wxa+PwHD3NSZAzHwBFlWLpNtEpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8z9jYqHWtlkzAW0ya7qsUqKYOyiVeDY8BUyyB2FsDA=;
 b=VvWeV12i/seX6t/j4fj9igG1ZVk4RV0kW+Fg9iEem1W/JGqpxEhAtJJKVthHnrZ9RROBuqcju57p2GuOX84jY7GK9YYQ45LbDbGZWtqYAen3At7527TLfWBTJMB+hphaFC1uiyg91DxE2DjxZz+v7glWwUX7AtcxK7XxDcj2milGHaZ5PP0MLczHQe9Pzg5FvJU1uJv4k3bM2FUUyGpDPPOIK0vySHUDpUHFNDwOS/0BCwXBXUHjMem9WsxXDjSb9SFOj+2o8mSHfQjRpwkW1DcMV6q9tNH6NvHvFsUc2ezFE2PfGrXhvB7JVTcBAzZ3enGeFAyiHNSdJNOa/EFxXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8z9jYqHWtlkzAW0ya7qsUqKYOyiVeDY8BUyyB2FsDA=;
 b=BG274A63awNgoZBYW8aKO+uHPOZQ3k6yJUEGK1QjQS30OM9N7y51ze8M8D2KJRchuTnZzi+N8J5xS1cW3g3e++lkB+mlJdtuyIUYcBig4xiuq13S8Ys+IC0jIQPTFIVBhvGcc+K1ErDNq5SZeRQqB2adQ4gcVkKeiGbcfqsQYbk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB4713.eurprd05.prod.outlook.com (20.176.165.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Mon, 23 Mar 2020 16:12:35 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 16:12:35 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next v2 1/2] uapi: pkt_sched: Update headers for RED nodrop
Date:   Mon, 23 Mar 2020 18:12:20 +0200
Message-Id: <04ba935cbc2a05ead635c449bf63d2f8688643b2.1584979543.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1584979543.git.petrm@mellanox.com>
References: <cover.1584979543.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P189CA0041.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::16) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P189CA0041.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Mon, 23 Mar 2020 16:12:34 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c0a79577-0444-49ae-4e3a-08d7cf44ffc7
X-MS-TrafficTypeDiagnostic: HE1PR05MB4713:|HE1PR05MB4713:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB47131D2A2812A5AB9F687031DBF00@HE1PR05MB4713.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(199004)(52116002)(6666004)(6486002)(81156014)(86362001)(6916009)(81166006)(8676002)(8936002)(66556008)(186003)(66476007)(66946007)(16526019)(26005)(6506007)(5660300002)(15650500001)(54906003)(956004)(6512007)(2906002)(2616005)(316002)(36756003)(4326008)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB4713;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GItewR2pE0GnhHikeW/3C+zTqJ0tVkNeUqiJboQi9AAFlbJ899Q2q2QSjxIUAC0EABStSF58zS4NuWAl/Ofp7uCDRupWWOsbH5PoT7Y92NvZAnCfuhjF0RGNf6AyZdmD4yTY3+8pLorjLFLbSOMUjd4MOPD/SBQnCzokpqRzzoHUrXU7AEzbb5W5aT3gKRk/SZKiPETD3/EgH7L3kwG7wt1LuwrWqXfO5g+Cfq+0jnA6A0M9UeaYAveGQMULgpb+DyFDz9tTUrUdQuoQRwMz8yLqx7SLDLGH+zjccd3u7+Q7VGzwgg2r9vgo35nhA3oQeqI97xHMZ5TtkhBLfNP+FWVrmPRBhu2CZj4jsJwDJl07dEfPqg7GAgS36nzjapmvhT5JMwURYkxVpbEOkl8s+1qweVZKxbYidmhXOTDxpESd9hDAnazuXmO09qv3oAJO
X-MS-Exchange-AntiSpam-MessageData: x24gaYuQ3/2zr4W+HgYXlqUyhstvfytRwu7Wb6/xo075feLJpOK7GDT6erZ+Y2IpiuUfOoLOKxbA7eEB4pWAd7I17HzExUMiP8Kf3H+LgNkynMD0X0Z58yMbzm79ISD6YDsietHkIGjcFL8wEqOtOA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0a79577-0444-49ae-4e3a-08d7cf44ffc7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2020 16:12:35.5110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GFfmR/idBywDLa/bGCLAwyTXZF8W3Tbr7bCgmW2HahouMYfbFls23LDryPVi3r9Hg61Lz5XSbOzIfa6mrgyGJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4713
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the new defines and a comment.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 include/uapi/linux/pkt_sched.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index bbe791b2..ea39287d 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -256,6 +256,7 @@ enum {
 	TCA_RED_PARMS,
 	TCA_RED_STAB,
 	TCA_RED_MAX_P,
+	TCA_RED_FLAGS,		/* bitfield32 */
 	__TCA_RED_MAX,
 };
 
@@ -268,12 +269,28 @@ struct tc_red_qopt {
 	unsigned char   Wlog;		/* log(W)		*/
 	unsigned char   Plog;		/* log(P_max/(qth_max-qth_min))	*/
 	unsigned char   Scell_log;	/* cell size for idle damping */
+
+	/* This field can be used for flags that a RED-like qdisc has
+	 * historically supported. E.g. when configuring RED, it can be used for
+	 * ECN, HARDDROP and ADAPTATIVE. For SFQ it can be used for ECN,
+	 * HARDDROP. Etc. Because this field has not been validated, and is
+	 * copied back on dump, any bits besides those to which a given qdisc
+	 * has assigned a historical meaning need to be considered for free use
+	 * by userspace tools.
+	 *
+	 * Any further flags need to be passed differently, e.g. through an
+	 * attribute (such as TCA_RED_FLAGS above). Such attribute should allow
+	 * passing both recent and historic flags in one value.
+	 */
 	unsigned char	flags;
 #define TC_RED_ECN		1
 #define TC_RED_HARDDROP		2
 #define TC_RED_ADAPTATIVE	4
+#define TC_RED_NODROP		8
 };
 
+#define TC_RED_HISTORIC_FLAGS (TC_RED_ECN | TC_RED_HARDDROP | TC_RED_ADAPTATIVE)
+
 struct tc_red_xstats {
 	__u32           early;          /* Early drops */
 	__u32           pdrop;          /* Drops due to queue limits */
-- 
2.20.1

