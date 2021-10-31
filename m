Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79FD440E94
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 14:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhJaNQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 09:16:07 -0400
Received: from mail-eopbgr110110.outbound.protection.outlook.com ([40.107.11.110]:6069
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229626AbhJaNQG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Oct 2021 09:16:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOcPAwhjdZmZTCocLQGS7RmLrrL7f9T4os6usaaiZZhERlHpLjqQNmbQNCRNk4brv7DVIUen35K9vEYF678edm+aEHZJrQlANvyX4ggc0CWk4BcYtSuBqXe2FwJV+fNaMaG1SHSWOCRrp5OnwmVb36k71BDEIH+n3NwjVwVbJ6gGohMsJoeTrlBGGu14dXdyu4XJrOdv/Vvma/uPw3/+363fYCSVfbKHRVFeY02ky2gcjJGsdm0ioXTnc3RU2QEZ+dzpUyS/yFi89DfAWVLB99EkhKvDIFbW+3nP/j2QIKUXXOZjSgRqGQXVBBu0sVJ719oecsNIb8H5YVrcojeTvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47QOp4OCwurkL1kJ4wbU8D/xrWkyWJVBeDH53wf9KdQ=;
 b=LwroSFS0xQNSF7BM5bv69lJHhw4MbN8GnfTf7PAi4Ossdt3OMst6nlHotJRWA3Mt2e8Vi9F8+f2CKgwaKyG/ywLBPeLR9N4xwdJBzT3MEJXFpHwJeHPAZRlVBKTMOw8ecaPShAiPjdKvLN/gx70jfV8rztNDQIpmgXHD5kexBSfNBE358EJqtAtC1zTLzZDcP1bUin2OR1/hXYX9fesFzyZcrln02+FAM3HFKSrbPebXkhxofdmaSo0Xxd3ppxOtMOqv1xBjCDlCuXMd5yxq3d9kbmQunipgEDLCrl/qt39HRxPyFJ35IAicBsxk3uC/cazmx1UTQ+j6jzH9ZyN8Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47QOp4OCwurkL1kJ4wbU8D/xrWkyWJVBeDH53wf9KdQ=;
 b=ErSdgicCLi4s8NwptnUUvq6UiPPOQjI7eJW6tLGLUM7lJTBswbWLyusOtNDSdVc6P8w5nQRx6CJH24s77hzyvtuPbWotU/fe67hY7CO1Mg8e7SW/dForkTZ5fvUkBLrNNoi4hPafcycB0VbdIFGQkF37gnfZhNrZsmiT6PJ6gLk=
Authentication-Results: purelifi.com; dkim=none (message not signed)
 header.d=none;purelifi.com; dmarc=none action=none header.from=purelifi.com;
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:bb::9) by
 CWXP265MB3349.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:d8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Sun, 31 Oct 2021 13:13:33 +0000
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f424:5607:7815:ac8e]) by CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f424:5607:7815:ac8e%6]) with mapi id 15.20.4649.019; Sun, 31 Oct 2021
 13:13:33 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        Srinivasan Raju <srini.raju@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: [PATCH 1/2] nl80211: Add LC placeholder band definition to nl80211_band
Date:   Sun, 31 Oct 2021 13:10:33 +0000
Message-Id: <20211031131122.275386-2-srini.raju@purelifi.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211031131122.275386-1-srini.raju@purelifi.com>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
 <20211031131122.275386-1-srini.raju@purelifi.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0383.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::35) To CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:bb::9)
MIME-Version: 1.0
Received: from localhost.localdomain (82.34.80.192) by LO2P265CA0383.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a3::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Sun, 31 Oct 2021 13:13:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ea552f4-32e1-461d-8ed5-08d99c703dc3
X-MS-TrafficTypeDiagnostic: CWXP265MB3349:
X-Microsoft-Antispam-PRVS: <CWXP265MB3349755D035AFE8B04F149D6E0899@CWXP265MB3349.GBRP265.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z5SX9mTLV0dvVVwgiAeHCrD7oQTZI3QxGpyHQnEQCIS2rtYnAwgh/m+MC+EPoMDtN6E3l99iNphBVC/JBhz6ZcLaOEdmF+6NugYzG9zEwtX1lZlXBgEVQv7OOAbmQ88V6rHcmuvpx5ovc6LCKzZ1JEPBww2pK9QsAyDKW5LmXnXCThjB4Tr22vpeuf3DIslwnjSwCwLQ0DXrF4UJaP5H7yPvFkjJKUtrfmSQhe0g8s5eUwC3A23OehCN6Jm6gkr25eRhK5jXspaZH/QYRvWJwQ0EU5f51WlMscCtc8EPzknRjPYAHkW0pEFvSTabgt60KOF9QmeQX7gSn5GHJd+yoxiFZrp0zJpib8mv2oRnH9o99U8m43Y7+xmPe0dlWZ26IcB6y1JsuZXXi8FAprbxmAo0G7uSK3SXdnmZoSjCwoz1lm7JF92WmR7F7whJ040Z2eK3UmciZdkvnLMtv4GUBxEKbJkc0RceAMS2ES9tjQSeEkAIq4JafE2FiMd4ynbP8qorpepBvhoZT49wxyjguNjz4G77Ser9maJrODHeCuoYG5aaVd0aN0EXPfvKFY8fNEBNvqApmnAvl2xX2PAGlY8QWpThMUTGqRSKdXXI5kZJ0Y0vzIja+7bTTiyl3vVeK49rX4IkYge3XpQbquNf7GikbLI9p+I+P9HWxObONev5N/rjPzxBWBKMjuIGFpPYLsVDv2wpbNyDMpGAbKC1qSWImtdgjZnudimwFfKHqHM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(52116002)(66556008)(66476007)(86362001)(66946007)(4326008)(2906002)(316002)(38100700002)(54906003)(38350700002)(8936002)(109986005)(6512007)(5660300002)(26005)(186003)(6486002)(1076003)(8676002)(508600001)(2616005)(36756003)(6506007)(956004)(266003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+BkbhKeWU/7cchsKJScYcyPzUx70b7eXma2ZfOvt+z2C95ekzpERIR3fbn20?=
 =?us-ascii?Q?GV1tTv4CbNbqjgbDOU5pRiflsG7MtD4PVdSeGJ5gSWjm0uUn2FzjDOAAztSY?=
 =?us-ascii?Q?fCnYo3KH+vOmp1g58ne7s6CF06XFaZVaNqUDjXgiSuJRaydUHy9fYibN2J9F?=
 =?us-ascii?Q?Kwze/mJjvYR/lsxntUVl4xsxAXsra7r04IfJC6fIDbXyIjwVSsq8f8U7V46a?=
 =?us-ascii?Q?sqqKWry1b3oytch8QhHO4o9DX/H/GB5kj2u74hItGzOvIciS5/JH94GYtj2b?=
 =?us-ascii?Q?fMIXx90JnswEZwGfb7Q8o5wOQ1kyQM5cslA/8BQiy19PQ55sWDnR2ylMNsHC?=
 =?us-ascii?Q?1zX6OlT6+3wURy+sZt/sqnHBZCspMB5IPEGITB/xMkkwM7p/JiTTq9s7b7zi?=
 =?us-ascii?Q?U0Lh0skt0/mBnS0WF73Q4cQDRjwl62cYOO0jkxjptFMIuQo0uQpJ0GBSivUD?=
 =?us-ascii?Q?eZOC5tAfkTXwulFsTctOD4R+lj9Z+bQvcdLdbxdaG7ghE9PP8rQNooubmwKc?=
 =?us-ascii?Q?1S8TkioWXzIlFEuNf0yJ//2p13r0EmpE7CG0N9TEOvMpuQGiaSEGovLk00cb?=
 =?us-ascii?Q?Dq5rOpFH0GGMCrCvzWOO6O3POSlhzLYn+FZHoxum/OC8XsuculfmU9c1wYQb?=
 =?us-ascii?Q?EmGnTknl0AIbU6DHt+5MH7Hy8iHJbVFabEgG5umREIv+7CV5WUJInI6h1xWH?=
 =?us-ascii?Q?qiR3PTdqDngqEW8u0RpwVTRFcoOpCI+lqgZQkpBUEj4DhEueFcx6aos1TfkA?=
 =?us-ascii?Q?kvfctbB0ZlhESbDdhQePxaOcyM8nzJucKqD2uKRc7tkCiNVKg5anUmHmlI0t?=
 =?us-ascii?Q?kyRIOffwyjEVjGxueNkUicZovMlZ5kXXKT3pkpMImDEwwzPYRslyQXiAh8Ae?=
 =?us-ascii?Q?kbiu/y0oNaWMv0WzZzyQ9kNuUDSDWB6qnGc6ZvuZ6X6cW5E2fj7WGcfOU4Xe?=
 =?us-ascii?Q?dv0/PQkbmhCudVwcYcVHVpb4KYrGXdHo7Ki8oPjYr9Zg/EpQI0FPCMLnoW8J?=
 =?us-ascii?Q?Wj7GruWtL45+Fmp4MbQsNCuW5AvgVOt8pKGy2XS/6eFJNqx45OT4Ft/8Ek97?=
 =?us-ascii?Q?N2Ywuvul5L1/2lFvIWHxmdUJTIeT+U5R6dAAUhWPKAwfYyuAaEL2wWx1iO3V?=
 =?us-ascii?Q?/hlzH2p/3sAOjwRwCiTV8asT/WniiaF/IBNuqlztKhPB3+p4M3SOS25VLuqq?=
 =?us-ascii?Q?EvMAgTqwlj4g4vZKQMbDgiUCseJAvYTf+jOj5058FJFqLy10TnAhkLP4PAhN?=
 =?us-ascii?Q?uBBEyYyoViMIQ8drH1J4yDVAmkOJlLu/OvoG5/B97D49fpmlB8FCfqdDVbbk?=
 =?us-ascii?Q?ZIxjwaav4rfmgAsl3wl8o0ChmbZUAWR5Ta20lSHGWOlZmVF/SRCFR9L9nYNg?=
 =?us-ascii?Q?AFWZByPeiTRhMTsK+969M1epVDXzu3ntRWB7Foh4KpiZ5fETDoXBcwKJ4RNr?=
 =?us-ascii?Q?RWRdfREkeVQsvGfNypBnyhgM4JFMhDkgifKbgnBIG82xkt5EMfQM6Vv+yKKl?=
 =?us-ascii?Q?JqBGCWD+WPSpS4iDaKmgEL7U89UgOjdC9KZSMIDS8tp5hM/NMf4JvSV3LBir?=
 =?us-ascii?Q?vdET1Nrb+6Ere/fhDhgvTs4WUIsmGjEXKXUK+xDCnzG0bTNdXOQ+Xsddv18r?=
 =?us-ascii?Q?uj9+7QOOwh0YA/7Ol8AVOFA=3D?=
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ea552f4-32e1-461d-8ed5-08d99c703dc3
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2021 13:13:33.7237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 569I3w8GVne+zKZboC1/lOb9UayCoLog4OQcFgRERLXnKmDGlOSf2RDmQpLlBZ0ioKaK2yQpBgY0M1QV79UXAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB3349
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define LC band which is a draft under IEEE 802.11 bb
Current NL80211_BAND_LC is a placeholder band
The band will be redefined as IEEE 802.11 bb progresses

Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>
---
 include/uapi/linux/nl80211.h | 2 ++
 net/mac80211/mlme.c          | 1 +
 net/mac80211/sta_info.c      | 1 +
 net/mac80211/tx.c            | 3 ++-
 net/wireless/nl80211.c       | 1 +
 net/wireless/util.c          | 2 ++
 6 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c2efea98e060..cb06fb604a60 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4929,6 +4929,7 @@ enum nl80211_txrate_gi {
  * @NL80211_BAND_60GHZ: around 60 GHz band (58.32 - 69.12 GHz)
  * @NL80211_BAND_6GHZ: around 6 GHz band (5.9 - 7.2 GHz)
  * @NL80211_BAND_S1GHZ: around 900MHz, supported by S1G PHYs
+ * @NL80211_BAND_LC: light communication band (placeholder)
  * @NUM_NL80211_BANDS: number of bands, avoid using this in userspace
  *	since newer kernel versions may support more bands
  */
@@ -4938,6 +4939,7 @@ enum nl80211_band {
 	NL80211_BAND_60GHZ,
 	NL80211_BAND_6GHZ,
 	NL80211_BAND_S1GHZ,
+	NL80211_BAND_LC,
 
 	NUM_NL80211_BANDS,
 };
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c0ea3b1aa9e1..c577d03ab128 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1490,6 +1490,7 @@ ieee80211_find_80211h_pwr_constr(struct ieee80211_sub_if_data *sdata,
 		fallthrough;
 	case NL80211_BAND_2GHZ:
 	case NL80211_BAND_60GHZ:
+	case NL80211_BAND_LC:
 		chan_increment = 1;
 		break;
 	case NL80211_BAND_5GHZ:
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 2b5acb37587f..36524101d11f 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -444,6 +444,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 
 		switch (i) {
 		case NL80211_BAND_2GHZ:
+		case NL80211_BAND_LC:
 			/*
 			 * We use both here, even if we cannot really know for
 			 * sure the station will support both, but the only use
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2d1193ed3eb5..d311937f2add 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -146,7 +146,8 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 			rate = DIV_ROUND_UP(r->bitrate, 1 << shift);
 
 		switch (sband->band) {
-		case NL80211_BAND_2GHZ: {
+		case NL80211_BAND_2GHZ:
+		case NL80211_BAND_LC: {
 			u32 flag;
 			if (tx->sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
 				flag = IEEE80211_RATE_MANDATORY_G;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bf7cd4752547..cf1434049abb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -853,6 +853,7 @@ nl80211_match_band_rssi_policy[NUM_NL80211_BANDS] = {
 	[NL80211_BAND_5GHZ] = { .type = NLA_S32 },
 	[NL80211_BAND_6GHZ] = { .type = NLA_S32 },
 	[NL80211_BAND_60GHZ] = { .type = NLA_S32 },
+	[NL80211_BAND_LC]    = { .type = NLA_S32 },
 };
 
 static const struct nla_policy
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 18dba3d7c638..2991f711491a 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -80,6 +80,7 @@ u32 ieee80211_channel_to_freq_khz(int chan, enum nl80211_band band)
 		return 0; /* not supported */
 	switch (band) {
 	case NL80211_BAND_2GHZ:
+	case NL80211_BAND_LC:
 		if (chan == 14)
 			return MHZ_TO_KHZ(2484);
 		else if (chan < 14)
@@ -209,6 +210,7 @@ static void set_mandatory_flags_band(struct ieee80211_supported_band *sband)
 		WARN_ON(want);
 		break;
 	case NL80211_BAND_2GHZ:
+	case NL80211_BAND_LC:
 		want = 7;
 		for (i = 0; i < sband->n_bitrates; i++) {
 			switch (sband->bitrates[i].bitrate) {
-- 
2.25.1

