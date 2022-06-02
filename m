Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE70C53B395
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 08:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiFBGbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 02:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbiFBGbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 02:31:20 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150103.outbound.protection.outlook.com [40.107.15.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0392121482B
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 23:31:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TYkMnZQghlfXHkTWhA4Jra2wCUlOkhsod7v0dKp09Bf+3sqmF87f0dcwM6xe0QSmri8iBP+fgdbeTYIK8o3r75vUWFVtHrp3f6/tTYbD+pvgTDjlCbTm+M7wGCaRYMlPihOp8UYuXEC+cFGhbOeazgyl9YnE4sPI1gvMy1Gd/rSN2hH4fhXt+aXJzgp/IV/kkxE9l/iUkC9gYK+xYPRDwWURCOBS5GQoHtFQ++5PR8p1p13ym2TmYbW/fEhJBXfCsn6FKF0TFmq0tBnxBcGa6fEiOq5o+uV/4B9VIuRJqCxeSsVmz6QyqAITJvqrfAh6CPZ2UZG/MD0n7xPghUVmBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2+Ov8bteOR/NfrVil0rEwIItpFbX5kRrFnT5jKLcoq0=;
 b=EVWSSJoRY35a5ncY0NzUiZPltygBaumv6o2d+4eazdnpMKMx56lJhdP/30w0CxnMPYbFTzMrLSSBX8MR7X6P8Q3IHNic4zlhkMqi6Eeqzw4sNlrRNN6Nf80310zH///RCjOb3s3GFCwd90eHdnUwpP/S8fOUReg1fj3MYzJtsFIZsSmRO47dtGG3sQ983fSYw8+cO/FaJ8yLbbTY38EABrjFNGFnSYkAqD82GzImByAs2JXPD5hq9FH+BGOxOk9To6/+85jeknFAC0V8JkFH22cp8SmR1jsxxEr9r6hufZ3dxl8Z0vM6jjwY7MEayH5L5Vk8Iffy78JOUtDaJiz2aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2+Ov8bteOR/NfrVil0rEwIItpFbX5kRrFnT5jKLcoq0=;
 b=on5YZiHX1LZ/tIZDifShA83rGeGNgZxd2e4D8M8fY2i8XyP62fHHhEiRkr0l8upnW7KtoBK+CeiEriKrlFMBliyXyJooIA/ecg5aILvixnnfI7H/KaU3FFj1tVlxns8qBsNIBypua2WzhquY+VC1T1G8zS6tQA0dwKPE+Sno2CY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
Received: from DB9PR05MB7641.eurprd05.prod.outlook.com (2603:10a6:10:21f::6)
 by HE1PR0502MB3769.eurprd05.prod.outlook.com (2603:10a6:7:8a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Thu, 2 Jun
 2022 06:31:09 +0000
Received: from DB9PR05MB7641.eurprd05.prod.outlook.com
 ([fe80::84e0:5f1b:9fe2:34f8]) by DB9PR05MB7641.eurprd05.prod.outlook.com
 ([fe80::84e0:5f1b:9fe2:34f8%2]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 06:31:09 +0000
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tung.q.nguyen@dektech.com.au, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Cc:     syzbot+e820fdc8ce362f2dea51@syzkaller.appspotmail.com
Subject: [net v3] tipc: check attribute length for bearer name
Date:   Thu,  2 Jun 2022 13:30:53 +0700
Message-Id: <20220602063053.5892-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0188.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::32) To DB9PR05MB7641.eurprd05.prod.outlook.com
 (2603:10a6:10:21f::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8378e8f1-42eb-4ff6-f9d0-08da44617af1
X-MS-TrafficTypeDiagnostic: HE1PR0502MB3769:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0502MB376918CF29B6D5205E0C7A55F1DE9@HE1PR0502MB3769.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X2FvBynyAb/+AgkTevNYJCHNRAUNcUw1Heco/leSWA+qGz53uxGy9+sZso9AScaR2HejjzHYKAjOeAr/3QnfxHd5yPCD2WD5m2mznWf3X8ZoVjCWVWtT0Gl5aOAzbuuhHeuyJGwwSGCftzSocTg9a6javEkUMebnX90Q7dl+vDbwid4AqNRHmoIucHQecvRey0+5n1G0B6RR7SVUILllO2nVNQ9ZMkpP8JCTAn4UonPP5LcFOn7u3piMwKBirZpCoqDFa/MyETnyf8hz49lz7F0VqRHL10mkYZayTecbcYym4GqBgHhq2DM9jivB2q3u63Z3lEJZz7V60dqXr1CIZ1nYFLVnrJ22wo4cXKFqJXcqiraOscmxtdc8ns8jCg4Q0IEukDGpjIGh7ECHG8LHDSUYyEuJLTqJM6U3xZshmYDTGWqz+RhTnb+FM5c0PIiqQk7L7OGLvAu12cmYLuqj9m4SkDR+rRlEiCIkAkHjaa224kBQejxJ9mCu3pXq/N9/sPIiWRkXb0FnatjOsLQ6zo93OTN6Xzkdv1fMtJwb9vZdk7P6nfnSEd8eCaqEjX6nE7WU1eXGv+2vOdb9OUe5aFOEDAqaN7UDqG0TQSIvl8Vlg7NclqF+jaxt6oAhBYv5zxCRK93IeYBtGXqYCd+ruPGDeHfpSvZNcLbcMTCYK3Q3yuBN7lMN7y0UUx2UQwUdyiZWRnutweR8CoIoUGhTTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB7641.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(39840400004)(396003)(376002)(136003)(346002)(36756003)(8936002)(26005)(86362001)(5660300002)(83380400001)(4326008)(316002)(55236004)(6512007)(6506007)(508600001)(41300700001)(38100700002)(52116002)(66556008)(66476007)(66946007)(2906002)(8676002)(2616005)(1076003)(186003)(38350700002)(6666004)(103116003)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4e0KxmcKhaqOZMvHraXk0Bs0OMa4kKrpjXUlikEi3ua1MQkaf9oiwjpFcHqm?=
 =?us-ascii?Q?Rzhj6fOHTRe5u0H+3naoSpUu55JvWXQw6F161BXuWdonZISESpxjFjru/zUy?=
 =?us-ascii?Q?kcLwJA8nQK3jgrHuPz2R8cM6I885d3meuoAQaYIDmXu4ZTJ1Bc2+smZniahP?=
 =?us-ascii?Q?gi0LrfF/XdoAYf4Jwi4O3CLhfCL3tHXcoS5jIUhIBHiN6jro5C9/eCiKk75t?=
 =?us-ascii?Q?WSo66YqhX4dwxOWcaxh0yo4Th9QQvvQvo/IsS5EcRhWKtwH2mR/c//kg1HGn?=
 =?us-ascii?Q?2PSLfOys3kyjyHB/WG24V+g/bIT2zlt+NgfUGDQNHrl6dTpXVF6DwEJZPx3R?=
 =?us-ascii?Q?SNgO7kn0yjqxZPsxjuHSS1Uczq7Xj04KQRHQ3kEySfbvShIxI6MqTlBPynjU?=
 =?us-ascii?Q?bVWJPOKt13oAZIPgcIEAEVE5zWIFIz9knG2KsXUJoaDIh/MpNSfQZxRAFQQm?=
 =?us-ascii?Q?x4G1BIAQ9/mqlsurnuNUsahqZzfjR87DqdO5NqEiKDSvxYWPgwDhfy7Uhbbm?=
 =?us-ascii?Q?zoCx5dLUmdGdAX3u89wOz9vnE7LmPZsUMUpbzXRr7BvbkD8JrSyrxpyyVlDD?=
 =?us-ascii?Q?RA5rF4qH9UnLIRRy4PoVsjlOcQTdyWGMTC9qsSC8aBH1eH7BdrQDSogfPcJj?=
 =?us-ascii?Q?sspZTvg/39vCO4gUTEgbsJJpljQiI/VqLPUxJ8o9IsS3nMG/NsWyHjuns0f/?=
 =?us-ascii?Q?B5B0iwYmc3w17TRonsV3hSjyiwE0iOW6UyRoBu3XBUFe3izcT4IkbgM7XB+1?=
 =?us-ascii?Q?bq0eBIERELdj4p2vBDiJ8qrusJokSNArBZDw4PXna9dHxmM4UsAhPuEWwm4p?=
 =?us-ascii?Q?Z5zpNl+k+dZwoz34qlfFreQni28SuLKKYdjKMskvCo0GRVqnlG3cOPth8wjn?=
 =?us-ascii?Q?795MGzC8PNmG/ZQX3/9KAq0Yp0q2LxI2TrCNOpTpFkNz/MtYk+/Kg36QG38E?=
 =?us-ascii?Q?S4IWqqhQtZiBh5v2IxdIiFwAYSWSPtBQK/VoMN0P+WQbecMb7Nhn+8tyaJta?=
 =?us-ascii?Q?FeHX6JEX4HtVjnXiYMouI1FesQAbLOnH6D+NrOZq0sAEkb3pqDqycUdLqAT2?=
 =?us-ascii?Q?7J8Zk7XEp+nmPlsDGMmazCmRxmgtIbTAcTVhP0RRiYSrVM5Nmv2SrRaCxsia?=
 =?us-ascii?Q?Xbx7Txeip2crp45vyQ/y7qiWnZSx1aS6Bt69IbnDPBkYdlcf9B3ibOGFMx8h?=
 =?us-ascii?Q?EX1otu1gdUiBm3v6Tn9M+yxKvsSqThWlBA80EHZri8alylphnj6IZ8OdrQdQ?=
 =?us-ascii?Q?Gy5wfjFM2svu2gFTZYAYmg+oVqFBQYPY/08ybxJ5gXcKPTArHxVhyIA9lPB4?=
 =?us-ascii?Q?Im12W6XDdbaAgXXR/0jzNzdj8LQ8PnaJ0+OEkw83YXrLhzXirVu0QVCQB8Xh?=
 =?us-ascii?Q?C3TSMCKvlL4DD4S1lluyftK+7he8A5WhWIHlHUTJlxd2I4UVppFsUXEzn1cI?=
 =?us-ascii?Q?bFJtoQN50aeNLbAiPSaINFeLo9KzT7W2Kh4P2XIq5WouraTOmpzB34DhtWsA?=
 =?us-ascii?Q?2lvOaq+di3fRqNM0CkJCKaWUeWOkNYPjAqlTjfCyT8jEZdu57lH5et9gZYUF?=
 =?us-ascii?Q?FFM0UIIXgsfFSzWGLLgkl5RyQ21MUCyXqpSRSA8Ud/8fUbnbTqn9mZS6X3sa?=
 =?us-ascii?Q?iROavHRGg0FBoZ4kU8gnPUwT8TSca/wuReKq+AmtYtYSwhnHxkailuaXnA5c?=
 =?us-ascii?Q?FVObElBSmmhig0u0xrnFdHwJqleh2vOCCc5VZZ7MLxcin8zbfPDDbxHg/TJF?=
 =?us-ascii?Q?+zVKI6io5JFT5vsF5NJy/9mQtpn4bEc=3D?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 8378e8f1-42eb-4ff6-f9d0-08da44617af1
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB7641.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 06:31:09.4978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kD1IfFPM/nwmvQk3ze3dhKm1ZABnI2Ct5izkHzpSelu2zy2+f9qE5RpvcYM4W50WwEwR1NUaT6GpHYQy56HJ51VBu+I37C7MSmkDCKwsHKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB3769
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

Reported-by: syzbot+e820fdc8ce362f2dea51@syzkaller.appspotmail.com
Fixes: cb30a63384bc ("tipc: refactor function tipc_enable_bearer()")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
v3: add Fixes tag in commit message.
v2: remove unnecessary sanity check as Jakub's comment.
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

