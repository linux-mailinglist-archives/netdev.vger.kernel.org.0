Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E5253B2D4
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 06:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiFBE6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 00:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiFBE6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 00:58:19 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2132.outbound.protection.outlook.com [40.107.21.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196805BE49
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 21:58:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hoh/VaylkJsYWhTbWFepoB55g9+2Ohyyo5nUbaOS1pkVH3CBdRpQhOX9ias/T//rf/st+rI2uOta2nJqXB6P2ujnLyPuBWC1tR7Ec8UmphFQ0HkR+N+2yki4ELF2MaVc8+8oDSQIypLbwLf6tUjxa9ezkGtkXxPwtxgwTJjirVpXN0Kfh5ySv6hVHaMOgYDkpUygeVgdGTXnI5NYuAxeu6OBNueeTh7gQerQWYEhLmYpL8yq9p8WB5zKvk6y//BrY7MS5TUODXmyEUC/zQaaMe4OjO1DoXdgBrECi6J9WVhx7KneLj4Fe9baCzPvX8Ho7Vt7zF3I0O+W5qMnwDsgfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fmej1GbGMURoy/JjCZLGNeoZpATdgjpPLkN112735g0=;
 b=eAfgwFP3ZBteLYtSWF9VrKsyodvs/tg/fj2bkSDtFxfSUfNgVI5bIXDDANmLL9HpOMMyzWF9kIUI0U5PsqiofaScOR+Y/RSmvIZUTxGpGvgCtWf0PXzyf8j04KShmTjmJeFJ26Oc3NaZfYaBnz7N39e074OSaoivTz6LG2CJMa745VwNgt43pV6pcpe91etVajrzK3cGZP9Wd+u0yAviAWWUc3MZICu2LbWUktvOyJC1yWzxovJ/GHNQ6Iyw5UQk69/YDh9ZiBkwoJWv4hfHCHwV+sOLDGb2DZA95wGWN94yXnBLGvUJl9a6wZv6kkNRN0ZEbfIrCFE8Z+ecIW7XMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmej1GbGMURoy/JjCZLGNeoZpATdgjpPLkN112735g0=;
 b=toW6NS/Ve6sWZBwHLtAB+Ql6Rm8csyIPWsX+UYmddRDK1kA25cb8qBpuWtQj0dn7Ky0JFD9BMT6mhKoEeiptkH2pYr9WkEMJDqnRB0Q4FMK3fFqXI0HjhQLDt/SO5Mk9ql9FXzN8d3+7aM6G0KLdp6iaqooLaSQjx0yKdjutaGc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
Received: from DB9PR05MB7641.eurprd05.prod.outlook.com (2603:10a6:10:21f::6)
 by VI1PR05MB7039.eurprd05.prod.outlook.com (2603:10a6:800:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 04:58:12 +0000
Received: from DB9PR05MB7641.eurprd05.prod.outlook.com
 ([fe80::84e0:5f1b:9fe2:34f8]) by DB9PR05MB7641.eurprd05.prod.outlook.com
 ([fe80::84e0:5f1b:9fe2:34f8%2]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 04:58:12 +0000
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tung.q.nguyen@dektech.com.au, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Cc:     syzbot+e820fdc8ce362f2dea51@syzkaller.appspotmail.com
Subject: [net v3] tipc: check attribute length for bearer name
Date:   Thu,  2 Jun 2022 11:57:57 +0700
Message-Id: <20220602045757.3943-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR06CA0017.apcprd06.prod.outlook.com
 (2603:1096:202:2e::29) To DB9PR05MB7641.eurprd05.prod.outlook.com
 (2603:10a6:10:21f::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5ac16d9-d083-48ab-72a5-08da44547e85
X-MS-TrafficTypeDiagnostic: VI1PR05MB7039:EE_
X-Microsoft-Antispam-PRVS: <VI1PR05MB7039A657CAF403BA23BA6158F1DE9@VI1PR05MB7039.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BvDDmoqnhoU3v3CIvuGgwb2Eq54BlLr4MFhoblyG826qnKqGUCOIh41h/YdqGRwHbqZLjNzOnJ+bw7BXWjl+ZChkiO+y/rwkFg3PKJPJIAmUpvnOdfPqf+ceb8N963USEbSCL35WoLqUw2qFQQsNRdA+3JLwdNflLkEHN9r6vLW2M7zXhcgfazJtfRYSNZSXpJwm/wCGvgLkzw0oytGdSDEn3iwJGQ+pd/+jWB61Ur8K0bA/Ea86sRk1be3llU72YlI63uJRf1PXOCMv7fjd8qC1OQmjKgKc+Y7uFRI8wKB1QPJzlPlKY6yutBgo3+IDH89gZiQHQ+o4Y04Ujx0WHgMAd3c6fIntGdJMDUKZ/1bHHcRGcVSCkoLpuMQuqx0N/GEDjKQsrf8D8vhuhU1suSQkQ6VGM9Yrc/dBZ9MamDT20eOpj7HKCY6rgk3d2OOY/ZQt5KEIi+Af5Oqz88XgZmfRjng2v36f5XQubVm201Rm1Xmo2dvOCZ/7GDaFr5ccLUGH2Vz91Bfw6/VQThkcL+VSkUOYEghOlif3sjcm8c33zmx3Q4HgRuQq0rfKUja0sY7/XO0op28KhQIscaB3p79i1mCakOiC1aOe8F6YgYb7TBzxgr6Hd4GTW0XcJ0dZ9JvPct0xwZ5Q86ZUAYpbHJj9piKQqBBki7k8VeMuGpK9qbn59iG4N41pbdaIYiNf4Wq5OzWLgoBA7fZj6OyL8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB7641.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(346002)(376002)(39840400004)(366004)(136003)(41300700001)(1076003)(508600001)(86362001)(2616005)(316002)(186003)(66476007)(66556008)(66946007)(38100700002)(5660300002)(4326008)(83380400001)(8676002)(2906002)(8936002)(38350700002)(6666004)(6486002)(36756003)(26005)(6506007)(55236004)(6512007)(103116003)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RN11UWxfAcr30g2eRvcY4xfKbRzD1AR+jWerJMOHE6qr8zv9n0jRhnUawy4T?=
 =?us-ascii?Q?g6kfj1BfLd1gpJQG/xNg2cCZGA5wYsmHCPa186Zeb3uzJGJLTqQIs9+tfrm/?=
 =?us-ascii?Q?kOyqE6G/sFTioPnOzZuCFrthS36bIp1Gsniv6ksCoZWq1dkhoymoNb+RKJaS?=
 =?us-ascii?Q?Qkc2wQrAm39lu8WWKbpXfYl163Gsmg3IGXqG6Os/r/avFH8O0aOnZAaKRbLY?=
 =?us-ascii?Q?gW0PQKpTqwKVDXboTks9Aqozj6Nlm64FtV+uOkrNz05Ba8jU05nSpVr2cKih?=
 =?us-ascii?Q?a1Ljz2jtwJmjqv8cELeljqB3XBY20PLcqEq6P+ymP2UaC1MQ/69I0wIhbpwj?=
 =?us-ascii?Q?vzPs8xMJ57vU4v6wtBOPoVYyFsU+rBQ7/zWb00ccrG17TbL2xsZqI1+3gtkc?=
 =?us-ascii?Q?vYrN8eRUj6RKobK5R9rL9MohrExUq2VAt6AqKlu5o5xJqoQfTo13oaZj99kJ?=
 =?us-ascii?Q?w/xJ+DrTPkESf61dsuRTo29C+S/ajBi/AeeR7hJGYiB/NVlldcYV74kDcib0?=
 =?us-ascii?Q?VEWY756oP37M+4nvO/k2yoHUlcy+Ytv9QjPVQ1R2clbTpJFVJlhc0K5yzCJh?=
 =?us-ascii?Q?+fLiXXufCx9hCZwbnXVyyBrutIS1zIzAQEmtM5qmKv8WrxHQjqYJNzegXfK5?=
 =?us-ascii?Q?AKhZhUUWdp9zldaDXcu6x1uZaVGv07AHQS77L17tVJJS/0XIi5ZZqJYUnsPN?=
 =?us-ascii?Q?mFwc1xJpzebYAzIQ0/+FdG2cQis8VEtl7YQlzqXzi1TCd+ezOOMRq1OF3bWw?=
 =?us-ascii?Q?zLoAmZ669s0CqgmrAegR5M7pSLuUAv6KWSXbG/+FDnGW83M2vYOgcV1qrJZk?=
 =?us-ascii?Q?oEuVa49Q4ei4BJiU/bkymg339/qi9NYs3d+4CDi2yHo3xSPcwo1YdswsgNit?=
 =?us-ascii?Q?0fSJbhaB13+PEAtv+jR1auFToa/vE2d5e/NImlXjBINIEWnjMqYPwD5+Dl18?=
 =?us-ascii?Q?mZxxuyVfSB5F7rs4gN+yIABo8Q7Q9txQLnRMKd3Vt2XO6cO02p7Mj4nD9jBu?=
 =?us-ascii?Q?M5/N+7x0U40+jKev6sSNuNFlNzxZENWJzwm60uWFOLJECp4BiY0zOJvpeYGV?=
 =?us-ascii?Q?hbBA9WhAqgnBRW0+pePueQydSsm1geUaeA5RwrpGdEqxdXeODuF2NCjYU6OY?=
 =?us-ascii?Q?XOQgfVRaho/wGzg+wI1NJMNm3B482ZjP8E4qSNsnMA1XXVYee0lOnf73hD7c?=
 =?us-ascii?Q?g+55O3gqtJcCalReqd0Hg2bUGc0V7jKvUeVjuAJZOdWXlLWH4iWg4mBnlYcY?=
 =?us-ascii?Q?NoNjnAXO2DWXiwrAVwfPoTb6LF7avUnc20RB6orOX2xCPksmckGgjCv9YncD?=
 =?us-ascii?Q?msdRVwuZaoZjazaJthgvFWuQVFp2LewoR2Xbt3ngTP+FROJjCFb1ezIM0QdX?=
 =?us-ascii?Q?hIamg0orxgdbkYbhawH5xBMj7MiU1icHeJDm0hbxDjGY+iZpLYmAbYfN51Pn?=
 =?us-ascii?Q?9I7ARljbCX/CFNT96hQlTriTWZA/sLiEoQc/xRQwJb8ROIT9FPHbxXyUZlSM?=
 =?us-ascii?Q?Fp6oyLUyXhlK/wt0IMxvolkY0U3XXtYKrX6/r5+DbJqZiAB5mG/7Emjpdf6a?=
 =?us-ascii?Q?8xmcJUO//4FcAF6OQBGTGjQ/d21xbzRMgxC9MC3toS1kbEpcA0ndqp7jr8+m?=
 =?us-ascii?Q?7KOyjre1Wi0/Q6/Wg8/RTVxdIb5oDTaSAuJmiQk2FtHf3EYNjraufGZhKbh9?=
 =?us-ascii?Q?uGWf5dZwSpOPzhkw1g2Vfo1t5hQoQRz/CXmifskThJXUVypzrGTIqaAdT7HL?=
 =?us-ascii?Q?xUws2LPUggVmtZUaJekJq6zWIFU/uIE=3D?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: c5ac16d9-d083-48ab-72a5-08da44547e85
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB7641.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 04:58:12.0399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4SVy+AhIdeWXqJei7UVPbf08SrnqRRewfRxvFjh/mWdoEX99S9Pk3Cb4INV34ouCQ5YEQdJUIS8o3S45ZUY4vsb/xenCpok/YbRmtq9V5dg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7039
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported uninit-value:
=====================================================
BUG: KMSAN: uninit-value in string_nocheck lib/vsprintf.c:644 [inline]
BUG: KMSAN: uninit-value in string+0x4f9/0x6f0 lib/vsprintf.c:725
 string_nocheck lib/vsprintf.c:644 [inline]
 string+0x4f9/0x6f0 lib/vsprintf.c:725
 vsnprintf+0x2222/0x3650 lib/vsprintf.c:2806
 vprintk_store+0x537/0x2150 kernel/printk/printk.c:2158
 vprintk_emit+0x28b/0xab0 kernel/printk/printk.c:2256
 vprintk_default+0x86/0xa0 kernel/printk/printk.c:2283
 vprintk+0x15f/0x180 kernel/printk/printk_safe.c:50
 _printk+0x18d/0x1cf kernel/printk/printk.c:2293
 tipc_enable_bearer net/tipc/bearer.c:371 [inline]
 __tipc_nl_bearer_enable+0x2022/0x22a0 net/tipc/bearer.c:1033
 tipc_nl_bearer_enable+0x6c/0xb0 net/tipc/bearer.c:1042
 genl_family_rcv_msg_doit net/netlink/genetlink.c:731 [inline]

- Do sanity check the attribute length for TIPC_NLA_BEARER_NAME.
- Do not use 'illegal name' in printing message.

v3: add Fixes tag in commit message.
v2: remove unnecessary sanity check as Jakub's comment.

Reported-by: syzbot+e820fdc8ce362f2dea51@syzkaller.appspotmail.com
Fixes: cb30a63384bc ("tipc: refactor function tipc_enable_bearer()")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/bearer.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 6d39ca05f249..932c87b98eca 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -259,9 +259,8 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 	u32 i;
 
 	if (!bearer_name_validate(name, &b_names)) {
-		errstr = "illegal name";
 		NL_SET_ERR_MSG(extack, "Illegal name");
-		goto rejected;
+		return res;
 	}
 
 	if (prio > TIPC_MAX_LINK_PRI && prio != TIPC_MEDIA_LINK_PRI) {
-- 
2.30.2

