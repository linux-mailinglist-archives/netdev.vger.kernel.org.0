Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57925189BD5
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 13:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgCRMTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 08:19:05 -0400
Received: from mail-db8eur05on2080.outbound.protection.outlook.com ([40.107.20.80]:33625
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726726AbgCRMTE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 08:19:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgnwlESazGWRzybyhwJvjRalCLhebZ5/zKnJeovHrnaTFHGaaLar8NyPNbi+H1w6jEhlpqQhRvPrmDDutruOHFTISZVgd5q4OeuKkHluDIf4EjGAXggxB8n19J6jhTp+q6FWAGwKvATXAjQ7fXvbg3c6wZLxHrbph4ntJ+lm0JDQtllW84wAWGtwBn66dNa/zcLSpIuJKcVrEUNnVe970xTkF6BPBLCUtoJeFmS39rZqpYupqKXzEYA+OktuXq9mEokXCvbIdETHcFcTIC6OJsMnqkm+DtVhC3nGrA/GZ9+V1rhnndJ5xYLg/EMkqlrJb6VPqooc2RulQrvpaluAXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8z9jYqHWtlkzAW0ya7qsUqKYOyiVeDY8BUyyB2FsDA=;
 b=PrLPteczVvd4jX31lYxZtLVAY+w2t7hWFuIiZXEAAaaqU76Z41d1i3x2In7AqkxAjS24X2EfXaOGauhKyFny8HqGkOCpOmPRSnlIMNNEXVwfi3zSZRyht8LngA3eV4uUkPz0TzdACM15QUeO/gHCD34QWAV+1VrCvOT6ErtMGsH9AopMeRcyRUVBC4omazUc371qBVCbjK0pyOpQHsBL2qEXU5ETm7hGV7ytfWwacWLI7JlLEzWwzJSR+12dgyBUcZyehLgpwXWXzcYjW4gEPXBnmOBo9UzLFHXGx6ZYlJqeU9YlMLdPVcYiCk6c0LJgrcxbDnNyhiQD0zrnGm0CQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8z9jYqHWtlkzAW0ya7qsUqKYOyiVeDY8BUyyB2FsDA=;
 b=ah7SwbKLSntuX+obtRurqfACiMsGv9axWfLhBChetMsE1zWwpEuWK7+MM3kT3+g/tqaMHUfnxAhlI5Hm84edQ8A6Yw8lRqkR11AP1Tp+NcqcVfJFy20FStSyjk4ZM6YqTYHNzcxojiM9CcgFGrFQqQBgbYpYlG4OM1capId4dSc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from DB6PR05MB4743.eurprd05.prod.outlook.com (10.168.18.154) by
 DB6PR05MB4584.eurprd05.prod.outlook.com (10.168.24.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Wed, 18 Mar 2020 12:19:00 +0000
Received: from DB6PR05MB4743.eurprd05.prod.outlook.com
 ([fe80::1861:6b92:8d4d:651]) by DB6PR05MB4743.eurprd05.prod.outlook.com
 ([fe80::1861:6b92:8d4d:651%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 12:19:00 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next 1/2] uapi: pkt_sched: Update headers for RED nodrop
Date:   Wed, 18 Mar 2020 14:18:27 +0200
Message-Id: <b5808f1050a2ffea6814e23106e8e98b41c2d294.1584533829.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1584533829.git.petrm@mellanox.com>
References: <cover.1584533829.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2P264CA0048.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::36) To DB6PR05MB4743.eurprd05.prod.outlook.com
 (2603:10a6:6:47::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR2P264CA0048.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101:1::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Wed, 18 Mar 2020 12:19:00 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ba0e72c0-cc58-43d7-ffd2-08d7cb368a56
X-MS-TrafficTypeDiagnostic: DB6PR05MB4584:|DB6PR05MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR05MB4584989413DAD86CC36E0F28DBF70@DB6PR05MB4584.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(199004)(6486002)(956004)(6916009)(2616005)(316002)(66946007)(54906003)(26005)(478600001)(4326008)(16526019)(186003)(6666004)(6512007)(2906002)(8676002)(66476007)(6506007)(66556008)(5660300002)(15650500001)(86362001)(81166006)(81156014)(52116002)(36756003)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR05MB4584;H:DB6PR05MB4743.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nGBfh1ntqY1Ud86Oo0MflK0jTQ/TY25oqn0GYYpNGrpdiSkJOLlBNk1Mjg8e/njiCJrz+lbbrODg4XIS4+mKln6eBRKv8JYBuBJIyQzBIdVv0T/lRViV8NT0/0FF+ezSxIiho0I4dhTq+Q/flcTdpXzkLZ19/euHbAMYHRkU6DmfTjJc9E+qYzJtKYYuTzCTDmq7Op2W6lvexQIEt5CJMk8MJ9u2LjmASSNvDcGBWmsrLpEH3a8Aj4A2Wjziku0vwBm2Q81akh0TLn/laKvdjfW3lXOgac5C3ZUZy98uftZ6XLnL7smWDD/Iljn1vBYhcT+tVphmYELlMWPDAyOozkur6fAVXCOQbjAVxqGRVZPzYm8lHsjDJE5sk2ddFz+b36i8P2d2gYsaC/IcatZZnSxq/wdjBALjwZZGzWNK+wM+ug34GjzSfS5ZYhE/Ac0X
X-MS-Exchange-AntiSpam-MessageData: NQHIn7xGCOP9DPEllgE+7DdC96nQo+2oD5XPIEl+sOm5C9rMdtgVSTlI/cUe30YtaZ7Yxh07k3OhyLb8uAXqLH8t/s4JE+GQ9RlonPTfEwNZXKhWvVNPCVwdT7PXvbFOEdZjc0VDKs0G5LxPmOvgCg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba0e72c0-cc58-43d7-ffd2-08d7cb368a56
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 12:19:00.7753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GM/NeGXPRd/sCRuVRO7lCn/CHR5NDsdcaUn1U73j0YKR9ulxxjj4bnijWV56leLWWRLH0aP3gPz0WxDBZqR8ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR05MB4584
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

