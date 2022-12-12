Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E135E649CF1
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbiLLKpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbiLLKnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:43:41 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2092.outbound.protection.outlook.com [40.107.22.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9D5E0D;
        Mon, 12 Dec 2022 02:38:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HraT1NON6DQob1hMBIab6UOQPcc37kPfsAWJZCCUQkxLv5lnu1E1Jl5f/RZN5Hc8+mkCFbv9Dl9O0VygJGQLo3rYDtCjNxTgC4ZoqVgh6nS6q53ug9vShPmVOXLsavmpFzZNxoqu3Zhih8kZ5JMNGI7LN4yJgtNypXWk7nHwTB9eylU+t6wRuPjb1UyxlxRlSftqBaH4GrcFvKoPork8MWKF75F344/F9n83wwnVVX+SmF1EgXv5gXouBqtgnGkwOFRBwLdIBqPWaBuLR8UuzkMF2LiT7OrDz/flPDTTz6QQqy85qNCabBMD3v9ZCbeswlw+Kr53Z03PriceDJ7bNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2eqcn6yvHRys4VTuiElC6N9u6j3d6Rn/W/uTx4NXZRA=;
 b=ReS/HGuf+vavLebBRxlg19cNpV40i7uCkXtshXSA3Tc9VK3IwL5rNsNoh0uvyvuZpL6SbqjgdeGdkweYjahSuMh6hZAsfMK2cS4+9BYEjlYAK0bLWlvKy1KUkbG0BvArzYGkzYIuCO7k5yUZnqUBIl+J6PLEP2u7L0ICdQ5uZQoyEFXjSPXswJSQORiH4LpbhSPqb/8P6rGczSOmfTlaPBB65KfFI/Ak/JC+KraPWpnhnBR2Uh/W2mqKATN2eSEJd3T5Zzoc9Pb5+9YaA1yhcwxEoU6MJXfK1F4nU4LY3aRCbc34nXX8uvUvPKEZix+lq0B1DcfsL5BlIBWho8FhOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2eqcn6yvHRys4VTuiElC6N9u6j3d6Rn/W/uTx4NXZRA=;
 b=V4fqmMURH4283blLy0j7Vo/7Jp1fm9khuW+uP35+1IO32XiHLR4lW7vQskUpi4zRUvdqbw3+Xt7mxVLpQersmJJENaH22smLTJhwcRdmsYxr+mfmJDbC4HthUOyjEd2Iq54i6nhopafWUONUXJE37JQ+DY1QELdNrRY3jTVnItI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AS8P189MB2558.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:631::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.8; Mon, 12 Dec
 2022 10:38:29 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%3]) with mapi id 15.20.5924.009; Mon, 12 Dec 2022
 10:38:29 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH] netfilter: conntrack: document sctp timeouts
Date:   Mon, 12 Dec 2022 11:07:05 +0100
Message-Id: <20221212100705.12073-1-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0091.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:8::25) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AS8P189MB2558:EE_
X-MS-Office365-Filtering-Correlation-Id: 725cf8ef-fba2-4b41-1f82-08dadc2d0206
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ikWEv4fQkdfvdGSw0v8TonqmkLS0+pLoc1Ry6nt3GjxZiPtqadrwceSDlRHGEgSZAJ1k42LVv2wknElLihOlDmcF8WYVPk+UQZRl3dJ6HHcixs1LS8ER5tKXNpQh1igaj9BPYb+v+tcRNtLv7PaNVvfKUEv4pAkBgTpt2WCjsdzCcmj9L3BmmKOZcsL8rpVkYorJ3mnsqxkkCbW2tDOAgWra9PwluGz3VGCNxWcwcGSdfhqHPXSp7IziTu1+i/GTqoTiWgZSdFvECzlC5jYf63fbNyJr/wJQ1/NSFuVFn6ugmiC99NKs6U+EpQAqs3byoWOPP00IcLh5h2Lxr7X2uzixbt8jo3o5+phFYYRLxBjaFeBjWQj87OvCuPpIB54vTUhkutDA1Mpr6Ww+CHeRGNI6SOcpcLMArGvRH4Z/J5xgJxnMpfpcc365fllWvVDt7Tiujibi01yqb3IHQsIY3xYyKciYl7upfmCrSWJNMmnjLtaUXh/jGLRKA1Lyy6qiCz92ttdT5OPUhLfQ8KvU+FipQVkHouGBILrg+LqNWcfAYp2+e/43agw14XFIEa26OsYzMzWkM0E+Bji5F+ndOLb7Xtn+wNs5gpcFs4pj6bfIrqxLptgkwxJgD3uAW2Gp7bd3Ik2vajjeLwqArSHF8MYGjjPtWaCdbgYtaQq2ETzeC2aS2tNIKvhPPDBIf2dFNkwUL1qOeCu4S5V8iRaOGLEGaKLfU/WE8M354+0yyA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(376002)(39830400003)(396003)(346002)(136003)(451199015)(38100700002)(2906002)(83380400001)(86362001)(1076003)(186003)(6666004)(6512007)(6506007)(26005)(8936002)(41300700001)(44832011)(5660300002)(36756003)(2616005)(4326008)(8676002)(316002)(478600001)(6486002)(66476007)(66946007)(66556008)(450100002)(70586007)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uvfLi3NEQM9zflNuxBTAWNZT7gaAU4GHLtho7kywSPHufdSu2vkc0U0D9N/G?=
 =?us-ascii?Q?Pjcw5y5ohhjUK3Q5LSrqyWKyKASejWgemEGP1jgHCSyosSrjd9diuOSMxyDm?=
 =?us-ascii?Q?I/wZcRQy8y7P8Z4vyen7zVLHBaAlYFc7ryvoGVtne6SwAdc2vkzGa8VZORS/?=
 =?us-ascii?Q?MYiY1piBJp7fCo+AQtHRlg/XMgHOpM5XqMR0YbncEQ0BwbGh3JbydS3Bkgl9?=
 =?us-ascii?Q?k/lxHwXr+0a+araL/71TxcAmMQgn4R00oFrDZUnLa1rgjSnkveB0mFc7138k?=
 =?us-ascii?Q?f0JMyE4LAluvPSOsB13xwZE3xEAYkSVwSV9fUKQjgVnjKwfIjLXuZX27iTX5?=
 =?us-ascii?Q?bqwR+rm6Y8zpnJESCFh2xmpaNe0NoSwm0M/ZZXUuRV5P9qEDAQ115C4gstQH?=
 =?us-ascii?Q?cVAk2NYR6stCzfoZ5fTjbNfffEhq9+IIXX5rv6bvBrvinEvutT1kf5ZmRiXw?=
 =?us-ascii?Q?8wQjf0BGtmmLiRSf4/sP0GXRctsFlJ+vbheXqYyB3C/fo7dQOsm3187Pn9Fz?=
 =?us-ascii?Q?DJ1Tgd73z6hOenh5WGsUyz26xGeY/EoCGeR4K3DZt9lyevGozlzxZQ0/m8X1?=
 =?us-ascii?Q?+pb+IOHoOqMmr9Si0nm6I7/rxGcfGBktmZOGzSovyqhnxFcbkDvExKzw3M3g?=
 =?us-ascii?Q?LpN17yfz3Lld56EdfINydmQmz3xnlCrFRwbMchIocbWCEmXr6ZmcZJDZ3W1t?=
 =?us-ascii?Q?65hV9PyiDz+++fN+ZIuLKXCGWyDV6ONvJgOJ+JLMj59Ac0wgRXSVCNL7Bl3M?=
 =?us-ascii?Q?qhOmgDuXt/h4CLlxZ69uoqCNN1GKD6jj0lJr08CEWjkO5p7FVxWOfc/HfvD5?=
 =?us-ascii?Q?lI2rhHpGh0e+M7IXyKM9mTSOGuBFBnsU33HvghN55qC0UlUWlsVNcsDCxmfh?=
 =?us-ascii?Q?RJcvSFXBNrKeM1Tew4loUGFimt086CdKMiMF3aYsrxxH8rizCHp3JFWWtPqe?=
 =?us-ascii?Q?5Pcn3yhtoQ1CHox394qHXwDlzDB8LrRnZTVSvmnNTX863ka4/ex2+MegtvpA?=
 =?us-ascii?Q?z6XMIfkzQjLeE+mCElwIx3jbHP3Ym58ou2UgHJWNDeUeQfXALlbQzF9BoV0K?=
 =?us-ascii?Q?zHMrfMrXVr+50CgIHc9ONdLbkiCE0w3o4+3VbPkp8X6zh68EdJ6C+VITxOVI?=
 =?us-ascii?Q?APuGWk3w3+Ua0X/NjAA1duFyBScubiQ/T6LS+ypzWqiIwpX3ptnaSSI5C7S6?=
 =?us-ascii?Q?xHh+/dmZZmD1NrPxvvA3tkPxZhkcUPEgvNS8sVme+n+7OdpVSUVSdEogBULq?=
 =?us-ascii?Q?LzZ11n7nqFttX9xQBQ5HgqcY4D3o1weTChfuKysIOG3jlYQ+7HHrTjgUkWPP?=
 =?us-ascii?Q?liS+3b+Eah06nTTk4IJ2qjbEy8hKBmzWRbb72On+nmG0ab+yuIA7nq91HEvC?=
 =?us-ascii?Q?+oJNfkk8Lhs9Uefdh+rUr4odY/8XGdpMh6M25VFFyb3XAkGpk96+q1eyAhzC?=
 =?us-ascii?Q?ZpfwmSRuz0CB2f5Z/UYYj5Lo6aAa42y/LiYOJ7fuSIM2WrXfS37V9vfMIGMF?=
 =?us-ascii?Q?HOGWMWvAGdpsiIgLbZK6hlRa2JM0SKYNQwwGaUZblMV4sgzwnIZxFd9Ml+Fx?=
 =?us-ascii?Q?WW8bVaSBzab1AUe1Zg0no749EWTRXr2JcOrY1n9XEgNqEShiqxMZIuuTl74v?=
 =?us-ascii?Q?0g=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 725cf8ef-fba2-4b41-1f82-08dadc2d0206
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 10:38:29.3658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XIrcsxzjI8Dv1COhOKMSCskYHMbsl4DYVPKlAVUmg87EdoTHzJaVOMibMOz1g/8ax6mgrudtFRRG3CG6EkytdAPBirFp78O2Xsr4OdV7HfA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P189MB2558
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---
 .../networking/nf_conntrack-sysctl.rst        | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 1120d71f28d7..49db1d11d7c4 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -163,6 +163,39 @@ nf_conntrack_timestamp - BOOLEAN
 
 	Enable connection tracking flow timestamping.
 
+nf_conntrack_sctp_timeout_closed - INTEGER (seconds)
+	default 10
+
+nf_conntrack_sctp_timeout_cookie_wait - INTEGER (seconds)
+	default 3
+
+nf_conntrack_sctp_timeout_cookie_echoed - INTEGER (seconds)
+	default 3
+
+nf_conntrack_sctp_timeout_established - INTEGER (seconds)
+	default 432000 (5 days)
+
+nf_conntrack_sctp_timeout_shutdown_sent - INTEGER (seconds)
+	default 0.3
+
+nf_conntrack_sctp_timeout_shutdown_recd - INTEGER (seconds)
+	default 0.3
+
+nf_conntrack_sctp_timeout_shutdown_ack_sent - INTEGER (seconds)
+	default 3
+
+nf_conntrack_sctp_timeout_heartbeat_sent - INTEGER (seconds)
+	default 30
+
+	This timeout is used to setup conntrack entry on secondary paths.
+	Default is set to hb_interval.
+
+nf_conntrack_sctp_timeout_heartbeat_acked - INTEGER (seconds)
+	default 210
+
+	This timeout is used to setup conntrack entry on secondary paths.
+	Default is set to (hb_interval * path_max_retrans + rto_max)
+
 nf_conntrack_udp_timeout - INTEGER (seconds)
 	default 30
 
-- 
2.34.1

