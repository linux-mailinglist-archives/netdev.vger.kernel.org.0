Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40FA442A26
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 10:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhKBJRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 05:17:00 -0400
Received: from mail-eopbgr1320101.outbound.protection.outlook.com ([40.107.132.101]:31908
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229577AbhKBJQw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 05:16:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxcZYuyLbRTGN7xDqeaNQy0evpozKjONgPZBI0GLTc6noSr2YIuLCneI6Ec8eySuPxeVh8tK+NKbhmHORzhJtfdgQX317CXlg8fHY3qbuLwAhVQkbY3mCeHlyrhYirJiQ4SDFcgryOzTq9w3kQsxjW1Q4WJUd0ITZqdAx3+WlwfgnCqPi0pXBifyfisPn8EslgyfAxgWhNJPBBV6RmsEOSUdlGRcTQw3rsmAEFJACAVT6RbCR9Dlq6v8P7o/96YEgw9lfApxio+V230TwSysi0LB/nsWDoGrP70YAOiR4D6Yf+qzLfOxVTsCLHJ9XjPjDPQ9jIl67R//O2veMvfaIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qYLD7k7Y+hPxwQi3/mW+nUUQ34K2rw+XEXmFd2DCowU=;
 b=EkCXVUNCMJGab8EYxEkX//FBpRD6+5SJ2LmffB1yjwb+tDPYjfAT0CP1nMHRKD2BrmCY+qlGusbvDAad4vwZNnu0QsScQNSnW52XzKV+gs7nDRfphC5vID038bjo2ykie+MuRKZRd+sAwff8yMJT4fpWqkBZGd0MYD7xt2WqWWGos6ROXLzuh1dW3Ln2vwtku1WGzhtELfyn/TOdwQz4a0ivDDvw1XVki7ilBk1BdwZUGdxTKklMJuUbNPj9l3muiQw9EaEsnfXwBI79/AGc/DFZe8I3MQepn73R4qeiEgCj5DzlKVbJdXiRK/QxdlMkKl5x7QfP7o45Bt+i1yo9KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qYLD7k7Y+hPxwQi3/mW+nUUQ34K2rw+XEXmFd2DCowU=;
 b=NYJocV58oHGBVe50NCi2rKsIByYPiPWA0kbsbjBaICgWCB156kFdYChJ8pfLUnvpCw+gqud8JePslB1ZhXLWO6JN2fSLgiAdJmmeKQ7r7f/M2zLHEheKtftH79SpVC3pLV74lXvtsG1nkReco2z2TAQzdsUzbDIhYoIR1U/ncpg=
Authentication-Results: netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 SG2PR06MB2459.apcprd06.prod.outlook.com (2603:1096:4:66::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Tue, 2 Nov 2021 09:14:11 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0%6]) with mapi id 15.20.4649.019; Tue, 2 Nov 2021
 09:14:11 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     jiabing.wan@qq.com, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] netfilter: nft_payload: Remove duplicated include in nft_payload.c
Date:   Tue,  2 Nov 2021 05:13:55 -0400
Message-Id: <20211102091355.21577-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0205.apcprd02.prod.outlook.com
 (2603:1096:201:20::17) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
Received: from localhost.localdomain (218.213.202.190) by HK2PR02CA0205.apcprd02.prod.outlook.com (2603:1096:201:20::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Tue, 2 Nov 2021 09:14:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db303546-ca65-4396-bbcd-08d99de121a3
X-MS-TrafficTypeDiagnostic: SG2PR06MB2459:
X-Microsoft-Antispam-PRVS: <SG2PR06MB2459D31D248358FE2819F216AB8B9@SG2PR06MB2459.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gXHCtJWHoBAES3EqSodmTcZT7VMUYAKfhO+krVMMXG25dfv0AIhhJYVW8RQqivgdvDfZ/NWBzw+BCOdvUkmNFZO1gDxyBQHCrWuKYOQbGzAhevZ1i4nrP5A7Bt9CyJPU4/PMIPtKtZGxr6JgkPruEHXnLrf9ftUWAWsOY9AUQUA00KJz4IdRI8UTy5DVEvtfx8KdwEZRZihjo1SQ8lni3xYLnL4AAUfoJAg2fTtL9TZzpcEwcw29NXcEvO9710rEbrmIzb/ARM5hyinjkWxQVuW8VUjiKj/F3U4IPr3F7hNmDydt3B5hGLl84MEMnq8Y3LZhMNA5CJo4ewXK1X01kfhxjpbAxYKOscb7Ck74V4SrKofjQgjr96xymDFzaLP1m8qxQA9zkeeXslyJi4HKQNRsMHzu8yOIl7ykqh88Ymg9wu9NIya9FJ1SlFOQf40SaTw672MeMc/BAmmKn7tVTNEYwShQBcXCFbWxqCL34of+U7bmq8KkwjN6H1vatx6SCe1fjSF1FiYbO+CzWDQYplSOi9c5I3fAYwK9WtuVoHG86HZQr3FHMyvRbp1mUdVbwVVt9e06E9/CYtaBFRNT4Nl1TDfuhW87hBDLvp0v/ra6hs8MGM1RFOn7eVNY8QXajB3XRVzMRFCQzyQyrf46iAvZL7jbm9eejxlZ5uP0JqFekjHtdRKCoq/s/f6qOH+5G7JQ4vco8+Ex9EE+17zDcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(5660300002)(110136005)(36756003)(1076003)(7416002)(52116002)(6666004)(4744005)(4326008)(83380400001)(38350700002)(38100700002)(107886003)(508600001)(2616005)(6512007)(316002)(186003)(6486002)(26005)(2906002)(66476007)(66556008)(8676002)(66946007)(956004)(6506007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a4Yru7TQKqO8hp4IjDuLunGbL4RGoAmdLYgWiTRV0DnfOS9fy90X0MVz1Zco?=
 =?us-ascii?Q?vF5tAc4KTihci6o2w0dINR2xqx/4E9/lDkG3+vEHDBsK2IV5/rdSoFLCYehm?=
 =?us-ascii?Q?TrUrlBvspKGx7KGllLYEyHhLpnR3gmjyfnduampZYcsShVEtwwwS3/JRYme9?=
 =?us-ascii?Q?sTu9C4urh+J5y7vav7yWK/HM8rfDlw6SK9YC2g+4Bdq7ry208QIziJfNnFMS?=
 =?us-ascii?Q?/rTh61wIX7uDjGZYqnh9UIi5OAyxR3b2MklaX0BBcnEC3tLyEq0qHIo1N2C1?=
 =?us-ascii?Q?Ok/qgRyTvP10dsqUKvhFI2LVWrT5xP3T5VjmP9DCECCgT0LR0zuoLQm4qCYK?=
 =?us-ascii?Q?dfOTr6pG1yGHWIqgjF4DQIye7QBfuuh1DQNYPDpGqDaM+g8FCIIc3Aj8SgXD?=
 =?us-ascii?Q?AAEPXdz75tUpA7X+eeo9EFmi2KbdwmqS4OzRR300Qk05/FBq4/FNu4jAc6rr?=
 =?us-ascii?Q?QnGyup0FLtYlMKO0YGlxnL2Em5D6B3YZ4eC/maw8qXL1oS8DxQQ9g2gaZt5x?=
 =?us-ascii?Q?W/FFQI+B5kyToE9nSvb52FTryc7YLULIfu/jO/sTMjmEQwFD/QIR7WMsFoal?=
 =?us-ascii?Q?D1YYIcnpEUcLVZeVcy3tC8QCPESigWSoKmSS3EGOOSIw43jKsnctRNHKgVYW?=
 =?us-ascii?Q?3ihLJAfieVnSTbM0pR/4+z7Mdp1BPULCwjHU6QyXttyqA550o93huB2psNbn?=
 =?us-ascii?Q?VfNfcbZB+HLOvwTO0aYlZajwelKwY28pbdr1/4PfeMC7u/fV8WOUULbu7L5s?=
 =?us-ascii?Q?akrXmD5jfD6OBc1KiZ42zajtbAhOoVmkYC05n0HDDgZzMg54EQ1b+WiLVZJ/?=
 =?us-ascii?Q?llBgGkvI7ZnjWlLTCAbJXArwx5mKbGP1FdupA88WwP5bb2eKQKTu58DJZMxK?=
 =?us-ascii?Q?TGY/kU24hJ8g786Ut2uZEQ9uwV5eEFbRWNTXxxJ/mzEv2YK4iX+ipFibemhg?=
 =?us-ascii?Q?JhZHCdbmOkRy3cu56TOzcx0DnU4RrwxZCxwWqu0o2bq4wBqroeNqFxGNiHUl?=
 =?us-ascii?Q?URtHgA+SOXfTMv+IZoZyBltIYJSurzcFtSioOIjzRD22rmokIO3ucn7LPADq?=
 =?us-ascii?Q?KYKYMuRF6JfnlUNGQpWWGaaxBLllCaM0k8TyM7LQcoO5zcAyr1XbJdWIpiHV?=
 =?us-ascii?Q?5lpuxGYfCbjUrJZ50/dOkW/HzAJRQO48oMzHhgTewULHsBVT6NXlajZepWbh?=
 =?us-ascii?Q?CAvEfTrJZURPYsDhdYNnrIfsWT0BuEwA5RLn7tvsCzIJ3JvuaBCIoIk3nWtr?=
 =?us-ascii?Q?9EZNHMxjByHSSaHy0Jj86+b9UFkTmr9RSNm0tnaApVxUSr1yBXX8uBRLZqPz?=
 =?us-ascii?Q?qD+7KmMKagtjNz7GGfIb5e+kvlQgK0vfuQebFaqLv7AF/WFS4Fwndy7foxaf?=
 =?us-ascii?Q?jREF13IikcCnTzLRChJ7VmmprBcdH6g6BxfGOtWNBf3MJSMAR5iOmSlpWGSr?=
 =?us-ascii?Q?0a5eG6ybqK/MUVh5kFp/MtfuKIdxkEOFVfyyfOrMItDhC+HDR+r8/YErV5l5?=
 =?us-ascii?Q?UKLm8ohyH9JGZU4UxzzC61J5OMYBakQFXQERTMzck+5pndXf2EOcD6Sg6X7/?=
 =?us-ascii?Q?QiIJqvQM3hO68YnAZYcurnu4eBdyHSBgVbMB2A4mD94vfax0EWNQ26vQlnkL?=
 =?us-ascii?Q?GEna+UjaSeb7vV8BDJPZ7fo=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db303546-ca65-4396-bbcd-08d99de121a3
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 09:14:11.0405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zjXQw6FW/FdCulYFkvU/hPAA3BvVDQzLA4yB1Kq31rw8J7fDQeg9plzL1LF26a3LV7kzku9JVjpAWj18XGm7xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB2459
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following checkincludes.pl warning:
./net/netfilter/nft_payload.c: linux/ip.h is included more than once.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 net/netfilter/nft_payload.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index cbfe4e4a4ad7..bd689938a2e0 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -22,7 +22,6 @@
 #include <linux/icmpv6.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
-#include <linux/ip.h>
 #include <net/sctp/checksum.h>
 
 static bool nft_payload_rebuild_vlan_hdr(const struct sk_buff *skb, int mac_off,
-- 
2.20.1

