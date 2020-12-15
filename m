Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055682DA6E0
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgLODdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:33:11 -0500
Received: from mail-vi1eur05on2105.outbound.protection.outlook.com ([40.107.21.105]:32480
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725878AbgLODcx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 22:32:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2Oj4ZKL32Zm7nW5HuEzt1rNIVoEn8kWcS62o4fRoBp8VoEtshmG539OLAjG1IN8zCU2WIIMFNuZ4AR4NEj8WgRNTJR5wjR7bwqb7PIsx9nPeT4vjQPkdtC9lXGjdxbsDa7EMjw9pVfBI5otKI/cmls8aZElxr32TT8BXFzED1+vYVxfYhdErMHQsNRIO9mOLrcoVGIDyw4mMzZXv/6NcYiSa/k9uhC4A6yisbkEl6egwD2ozon9P1vfOM0uigigABjR90KuBvwzIAtdlI80ujwmZ1ZKrnS8VDsFDuQ9/yF1IyGtWF/at9hfUTKcaJIKVuHPgbP2C5zqU3gnGFy+oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFYKJ12/pusig60sFY4Iq9ArkSuWZtuliFWfJp/4+aQ=;
 b=HVHEQH5TPIZ5THobCtuCvViOESg1Ob9k0X2BPWx6n0L2NCJUVsrlAvYeVoY/Ztl5fwdn6n+FIZyRmqFJ1JHrZCYrOtM35sCq34OYlaiJ5vmz6oidyhprRW3ROVuxJAR0Vome87qLvKt9yUL6pg6Aa6VzgpBTTm9BllxFqgCb1GetOoKCrdf5BC0KCbtKHZK1HpkBVPOUqv33IfGR62qJ+0+HNO5TEc+7I9EsnytUEmckvLuHPPeCNdud2f6tpijDbbmyXQwvEV+AggZ48C/o2JHI43VagLUWGQ5aTqCV5GM9JfLu/+NNE+ELcrXiZa5kF7ip+hEMbvRYlEDSa/n7FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFYKJ12/pusig60sFY4Iq9ArkSuWZtuliFWfJp/4+aQ=;
 b=weAr5Ad99igj4UxknqITk8qREz8nPF+lln4fDSOTCpf6FUiRwZ4a+v7mFDbfLSbsug2oxW+5bRMjFoq2XsU6qCcykBP0SH1hWJTUQvA4fcjThSh8j1pPDRL+7dyrYE8qVKp5XeEaBi6rmSBG+W3a2I62i5vj1Y6wvoswB6dvosE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR05MB6720.eurprd05.prod.outlook.com (2603:10a6:800:139::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.24; Tue, 15 Dec
 2020 03:32:05 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::9854:ed43:372d:2883]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::9854:ed43:372d:2883%6]) with mapi id 15.20.3654.024; Tue, 15 Dec 2020
 03:32:05 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org
Cc:     Hoang Le <hoang.h.le@dektech.com.au>
Subject: [net-next] tipc: do sanity check payload of a netlink message
Date:   Tue, 15 Dec 2020 10:31:51 +0700
Message-Id: <20201215033151.76139-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [14.161.14.188]
X-ClientProxiedBy: SG2PR01CA0139.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::19) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by SG2PR01CA0139.apcprd01.prod.exchangelabs.com (2603:1096:4:8f::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 03:32:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 893587a4-2bb0-40e1-9fce-08d8a0a9fe78
X-MS-TrafficTypeDiagnostic: VI1PR05MB6720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6720E6386CE128553C633246F1C60@VI1PR05MB6720.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XMtNWxPthAhfIB0i65giebIziGp4kuozru7dkHdYY+XfZ+pmqwKxE1PYgh1RQbHhyaHp6MQg9XZ+G47NxfHWgepjI821AsLVfcPN7EMi1mFPLfyHqegsQQwlh1mTZ40+Rs1TAtF2hwAllvgIWFJYNWrfRgFQ4VxspQA9hQwIpSc/5VVB7aYngnUuFTbHPOrhob4L7VPaXCtYL4NIYS2C75FE2q1F61T66sq3Np1mAsTy8NrG6UZWBjTPKWPu7vO9f5Im5zBIA1OTakUGGGHSQDuVCXnhcmJ5YcAZujqd2m4kn1xOPk8Tr+s5aLmZpu/9Uz93QqTBGh+otUOhsR/Dcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(376002)(346002)(136003)(366004)(396003)(83380400001)(6666004)(2906002)(66556008)(107886003)(103116003)(4326008)(956004)(55016002)(86362001)(16526019)(2616005)(478600001)(316002)(8936002)(8676002)(36756003)(1076003)(66946007)(52116002)(66476007)(26005)(5660300002)(7696005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hd9Y0hIVVU/0+ecxUtVXdUugBxU+n5mL92XIJZwyn7xzKFTjsBv6ClrZ5uS4?=
 =?us-ascii?Q?F6uta2GjZANfm6ZuzRsb1NThdYc84gr89my67RWfslu/v7E/0lpsHXK+HV9M?=
 =?us-ascii?Q?gV6UzqVuyQW74Xfsd3WcYnGNJoT63ODMHvkupH+I7om92Xi4kN8qZHL9M8kY?=
 =?us-ascii?Q?WJB51giKDTDKlc68p0wgee3p+ezCtznSITGWglmIHcnzkqeIkoh3NuWKcGMP?=
 =?us-ascii?Q?oP9FNcWjMRkb6GD3Ow3I7pMsy6LNuKhJ6F+SkTap0A6MuJdzMGXUpw5hbBl+?=
 =?us-ascii?Q?DDiplzlNE7Ri460mD3MefMbrP9uHoTuoEByOXydW2fyjPgwdoYZ/E+M6z5yh?=
 =?us-ascii?Q?tyEUzVHwJqG4TZDuGSZlngjZ/mYDvsoW/X52LSyFIKRap2CQmeDFpIGKPjs+?=
 =?us-ascii?Q?LI2La2vqlF90noA3lUd1WgUZFWjvWxxpukPtDL5kn2ZHc7apjPj0zXi/py/M?=
 =?us-ascii?Q?jLGIMwCklRdlTZOe2JPB8CNzCFp8fueBg6yNjkXApGUVo9dS9Jj5ZfbEC+lK?=
 =?us-ascii?Q?Bkr4owzPPNiilJP95A2LuDmgYfhhN892XeGjLtvC1cmGANdgMh/M5g3KcFKJ?=
 =?us-ascii?Q?z7a5dQhv5wvD2pT4bNwTAR0xGmBoK8apV/0InAzOw4L01uHAsuRah/BeSaf5?=
 =?us-ascii?Q?KzZedQGOAU04BL8cMuYvUVWwNNHXia5vEnDfpW0dkW3l6TpNrTKOBuscvYGW?=
 =?us-ascii?Q?qWI2pRy7TXQuOqK2kBsx2bE4QIz1BRXqUoSrXMSj8GdR+JTEEkamUPjbgGFD?=
 =?us-ascii?Q?Yj34A3RmDyzWTmA4vHGKbqh4pqAO06sFdGuu31qt0unnRYqL9AQDhaR3OLSD?=
 =?us-ascii?Q?Q3Klws2/oXnoS9znBa7yxhk8M7wApaqIMzEpCmWCpGBDu1aaoyONpyZhkHC/?=
 =?us-ascii?Q?QUHVymQVCSKGMjndgGsAnetYY+sFlFNczliXDiJj5wyYCexJsPh2aVzHrFAj?=
 =?us-ascii?Q?N4Q+ZbR38wqVIb8RKt5wpop3ikfhbKb17fkeWRp8vavOAKB711/lW18Oick9?=
 =?us-ascii?Q?Fj+d?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 03:32:05.1600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-Network-Message-Id: 893587a4-2bb0-40e1-9fce-08d8a0a9fe78
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W7WaCcMV9VJS1cGfT+U49TLCbBggvRWpyddlBxWxVh4MeLrS/VWM1gF80FWJqJGMWWMrdqtqSC/oa+0reny/rSv5KHIILg5FWQ3G6FeUF/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6720
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

When we initialize nlmsghdr with no payload inside tipc_nl_compat_dumpit()
the parsing function returns -EINVAL. We fix it by making the parsing call
conditional.

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/netlink_compat.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 82f154989418..5a1ce64039f7 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -213,12 +213,14 @@ static int __tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 	}
 
 	info.attrs = attrbuf;
-	err = nlmsg_parse_deprecated(cb.nlh, GENL_HDRLEN, attrbuf,
-				     tipc_genl_family.maxattr,
-				     tipc_genl_family.policy, NULL);
-	if (err)
-		goto err_out;
 
+	if (nlmsg_len(cb.nlh) > 0) {
+		err = nlmsg_parse_deprecated(cb.nlh, GENL_HDRLEN, attrbuf,
+					     tipc_genl_family.maxattr,
+					     tipc_genl_family.policy, NULL);
+		if (err)
+			goto err_out;
+	}
 	do {
 		int rem;
 
-- 
2.25.1

