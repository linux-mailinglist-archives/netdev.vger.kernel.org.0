Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB8A5A1A3D
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243779AbiHYUYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243223AbiHYUYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:24:42 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05hn2236.outbound.protection.outlook.com [52.100.20.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE6AC04FB;
        Thu, 25 Aug 2022 13:24:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QKJad7kdD7HKYzO7FW/x0LHhibT7tgzAF+X4hmADlLFMO3JMqEYZhaMFjqf9yeYB27Kzd4O+wrOfhyQQmP60jX9oxNHKymvFsfU/pEfAGp6/5dxbYNLG8Ls+3XBxoOsp8+VGXebcYW8JR3DxxSAnK8kIR4OwJt4ry2peC9HkHPdnsvqflvqRvzSB21imhDSwoHYSKTSSv48OtRvuOrbxznuHR/QD5AntIJHGhKPoog021fvHV8hi4k+WR1dfQL2hYFV9zLuHtRS4GnEV0i2LlZ+iuNlaVSt7VJTHvbCdNfrGPivRBPEJU4ljJYMdoSryVfNtWbXy5FWS/2Hp6lihWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ax4Z8QmwAQ8cwH4bLDHV692v4k+bXZnEjQJP2AR4WEY=;
 b=hTwEaqOMm+LyIf91fXQxnD/2QognaKnxn2a1zc/cTY6sbZfzyO4fsT1DsIZn281kV4TzqH7bAYl4aNDybl6QoodF9XDpKfkopuMipHQWtXaxMUpUY2w8U9eXO53Q+jxHmfQbUEGdwHT42T8C8hL/QNmG8JmzKwM0dqsLrBXq3B/Z79JWz8ARTHHy7V01NKqk4g+cIP+L1imBoseB9IL2nlhH597lwDyVbnghZfQZnuCwZYm4UoVgMaiIjcCq6xJW5vr0Q1qHC5lFkIXQY07IyTD1cjot5bB0NVFPLoQOUhvyV5rZslDTTRdzhrg9AR/ClrT8jxN9zxe+ZHhtxt+zig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ax4Z8QmwAQ8cwH4bLDHV692v4k+bXZnEjQJP2AR4WEY=;
 b=kRrEboi55HcFlw1lTpA3iftxhJibgWLJ7EuHr7Y9q6NFME6rwzPhgdvNGI4OpjZMZWXz3670vTmoLOg6nf4niVHtkr+2HtNcgNq4zNKxOmuMujgU5wh8UAvxfzs1UHSnXjLc6YK2UfVQntQ2uZ04akNDTjes38A7VE492qCoIB0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by AS8P190MB1621.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Thu, 25 Aug
 2022 20:24:31 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5%4]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 20:24:31 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v4 5/9] net: marvell: prestera: Add length macros for prestera_ip_addr
Date:   Thu, 25 Aug 2022 23:24:11 +0300
Message-Id: <20220825202415.16312-6-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220825202415.16312-1-yevhen.orlov@plvision.eu>
References: <20220825202415.16312-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0092.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::13) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af5b86f7-5841-4a26-04d1-08da86d7d158
X-MS-TrafficTypeDiagnostic: AS8P190MB1621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:OSPM;SFS:(13230016)(4636009)(39830400003)(376002)(34036004)(346002)(366004)(396003)(136003)(6916009)(41300700001)(26005)(4326008)(66556008)(8676002)(86362001)(508600001)(54906003)(2616005)(2906002)(8936002)(52116002)(6666004)(5660300002)(44832011)(36756003)(1076003)(6486002)(6512007)(186003)(66574015)(107886003)(7416002)(41320700001)(6506007)(316002)(66946007)(38100700002)(66476007)(38350700002)(59833002);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?YaMQJIKSJdXpoGxfNaxIZzSmxEHvd7LoJCzy/1BP6XQrmd1OrBGpb5VThUVf?=
 =?us-ascii?Q?3pzcuJ1QfmAsamiv/pcC2pF1/JCp7OiYm4jt1RCHUfSP6UVDcgU9csuHKt7w?=
 =?us-ascii?Q?lWsLToTW1BEPw3t6fVKsPxOL6wPr4YpC9xrV9/SgpjVS94qOqJ3t+apypU1g?=
 =?us-ascii?Q?+61cxLMhijq4h9tlSHHp4zUbrAoCqheXtbrxCdRuip9qkGxHO7aogRYZNR+c?=
 =?us-ascii?Q?/16/rC68nYxFH+yYuKrU+efaKefIxfLshKi1s6PBQ1BSeMtKAkRLqPKweWa+?=
 =?us-ascii?Q?+RbHrXWuPPD4N0lNG4rEbjQRB/lYoNGtFMXHkxbPP8KuG1EFt9j2dG5F+l7E?=
 =?us-ascii?Q?i3BHfz/a9B/nCiqzsH915fVFGgS3PtTj2beTzqZlNAXAgjlIQSeMsEyeFWOe?=
 =?us-ascii?Q?FJErNdCcMNcqqTo60BSfY0WCduWzEFTbLGlYeW3YSMRKNnKs7nG2L4FgVgiJ?=
 =?us-ascii?Q?qjz3nkVvDsJMax3so4zBBxQ8a1nIyfxXmMtTWP1e/Y9GwvfmcAclW/kNH99S?=
 =?us-ascii?Q?YnqCwisWWClpscN6stVs0e0W0Dor44OiflQCAC1mOv9ypHF0OFQPUDum2JNc?=
 =?us-ascii?Q?4yC+atatr1BZPacD//inWi9YNSWH43tB7AXqK1pthrexk7Nojtu7jvC5VYRT?=
 =?us-ascii?Q?9VcK457AKNY5LslxmUMSSL5E11kG/i0O96evnoezdqx1OG+HMHGO+KeciZwy?=
 =?us-ascii?Q?6L5qGPY38hAknxfK5a2Uihxn74LDpSVZvs3JbOmt2Y7XqkDgPI5VKFEYeLsD?=
 =?us-ascii?Q?hVaZpjU78MyWp2FmzC61Lmqc/KgBnR1bl0FVwW6fRa08eqqSBlu0QMsuQQhg?=
 =?us-ascii?Q?6NTMPojIZPsR1E8pdaxjgk21NuRKFE/bkXB5Z949OABKF5tNozZnGhFLQ6Vn?=
 =?us-ascii?Q?VRK0uhFIYDgYPIq/xrX951ZO5KM4UQ6u2ReQtdNjlMhTOBwrG8Qh19fOAzxC?=
 =?us-ascii?Q?b0c+57nCRaVaXDo0BcNAlTudQFGMEo2BsuIJnGBOwWettmSioC2wRnQZQHdn?=
 =?us-ascii?Q?aInRnHXDqEZ/cT1YYjdYIlXD+R05Jq6aIzjXSQCp2jt6jiJr14wXqUA1Pme2?=
 =?us-ascii?Q?trezEv9E0sOYlH5TRr3/hjRMReivfqv6Hocg7SNHmVxobc4wljGAdfJhhNHp?=
 =?us-ascii?Q?JolQvMTaUCHWPlOaKxYKYZLRBfhIY58MbzEbtPjIfSXR6ftf5EVue7o=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D8lPhH+hhH6GUOGhBcfTNTMJR2uQ80sP50Tw7L+fZebiASkdmcJU4gIU78tN?=
 =?us-ascii?Q?+/nx9GMPEwxo3d7EkDp/qBLmFPX3yFBY6c29r/fP7lb3KrmiN298COj7jIsq?=
 =?us-ascii?Q?SDS2ib7WXRllDsL0GWdvlle6dlXwWSa6Wv/IDZB2+FVPr5qQe2EHqz3+Gv5k?=
 =?us-ascii?Q?tZwK1FHkgQV09EpN1YS+uCTwJFItDYFnGF4DrAdA/elkDSnAVyd0YXlcoaHj?=
 =?us-ascii?Q?GacB20ouvqi4MgY8YgS8yJoqRiGZJQYgYwdLp7Lt+nlt2ZjLEIOq4450exrf?=
 =?us-ascii?Q?zKJK74MEkKZkBhWFqzTnTtaEljfgsD0BntA7T05K3uF+yIhF3C6gIbq7hfl0?=
 =?us-ascii?Q?fFI9hrJOXaO1BzbInSHMQO+Er/MviMKmuA4DEnGDXwP3YPpaTyHCktAPWPBl?=
 =?us-ascii?Q?zLYD7ZSIryK+GyAQBHExZcKjlYzs7mwnEirZQg5WQFCr/hIJoGSzSV+IRvZZ?=
 =?us-ascii?Q?/RkTFsROgWzsUiraeUflayukC0FXXg1CZzdH2X1JbSfcDJOwrUtZgxxnFPwo?=
 =?us-ascii?Q?PrWKMn9iGQNEaiHGu/TAxRC6sqApc8VtYT1PZLgVZuEQr+Yc/yycHleKs45N?=
 =?us-ascii?Q?DjM2hesynpLGMmnYvGp0YF+/S02L6Mwi0oA3zLDWRc0RRotKuT7ZagDw4YLV?=
 =?us-ascii?Q?nmngDEaTlw+5+C4xPx2BP/ZdFpvX7cJRFIvTo/BMz3Rjs1DUKUqjWX79y8gZ?=
 =?us-ascii?Q?bkLmIpYGqLRerMDypJ17daPnY8pDn9TIFcngagYslNCZ2DJk0ZKaLangiq46?=
 =?us-ascii?Q?+E7cMtrERcxi4IvWdACI7rEU6t9gVR+pSvwRNu+gki1etO7bDlcQWV3RRPXH?=
 =?us-ascii?Q?fznfZRy2SvOGcX2+t6U6fzYo/Gg5JnBrusDwZXXPB7jKvtnmVG9gElgDQlb9?=
 =?us-ascii?Q?AtnOhSK7RwU+0hD8LJcDcE5ygachaV6yloEowXUjriQlp9e63yxjXIgPrNee?=
 =?us-ascii?Q?7A3/JFhI/rU2pd8RwwJlUPiEOgHEP0xGEpAW3nwD39pnD18sLRnrMMx+YxQf?=
 =?us-ascii?Q?EwAZbeqqv4LFCOLikjICXtMXbWXr5hre93QpGYHUPIUcnaoNka4ATU5v1S7g?=
 =?us-ascii?Q?bFpAbpiHWCZi2bJvBytkgicve7foD0pYEuKNmimq8CZJScpC8UQGyHXRSUcH?=
 =?us-ascii?Q?D0d/qmVDC65ohVkm6NRXERjEInNk9eTDJOlY15g6aesuWiQZ5aqyCrQHsTAr?=
 =?us-ascii?Q?devmI16cykoGab1Cwc05PAh1Ah9Ew5ZXvaV5xB4JR66ehCYSj1J2KnNqmVHp?=
 =?us-ascii?Q?cMOHFh5gi5cyT+D62WWUhqjOIJDQqGMmbqp4QMCgSlVEHk0PJtbqwgx14g0w?=
 =?us-ascii?Q?vvKqQwp5JztBLs2XXykVbRgA8AUHNTGfToLUZzlQBKSzdto0s3Y6K/23i7x8?=
 =?us-ascii?Q?J3YS6PH8bSTzzAyBzQnaL/pRKREZFVG0MzscZEbpdzPouJ0GBmvHKDFL1Z3n?=
 =?us-ascii?Q?UeltbEk6rTPoQ1zlwrZESJv7pucUDoBgBgipcKB9I9rqs53hFAH4DpkLVVSb?=
 =?us-ascii?Q?h0DbgOAfSrzYnaWFWu2e7t7ifgXZhEeql3TJubTJwS6XYLXoOmhoG472DJwX?=
 =?us-ascii?Q?GUyCSud4/JMFlAD4cZj/f9VwnCr632E0Kpoqth9VfTo0NhjH4+h03mtIOULI?=
 =?us-ascii?Q?9Q=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: af5b86f7-5841-4a26-04d1-08da86d7d158
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 20:24:31.5424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oBRUtY4qHcaBPn7ZljqyafgDj/b7knCD3LnRMNByyKg/QXEl8pBkupsTfjff4Zs9S2ib5cmcQ82YcE02XPJGjOfGii40WqIwPaoilXlp1po=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1621
X-Spam-Status: No, score=-0.7 required=5.0 tests=AXB_X_FF_SEZ_S,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add macros to determine IP address length (internal driver types).
This will be used in next patches for nexthops logic.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_router_hw.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
index 43bad23f38ec..9ca97919c863 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
@@ -31,6 +31,8 @@ struct prestera_ip_addr {
 		PRESTERA_IPV4 = 0,
 		PRESTERA_IPV6
 	} v;
+#define PRESTERA_IP_ADDR_PLEN(V) ((V) == PRESTERA_IPV4 ? 32 : \
+				  /* (V) == PRESTERA_IPV6 ? */ 128 /* : 0 */)
 };
 
 struct prestera_nh_neigh_key {
-- 
2.17.1

