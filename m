Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639A24C3496
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 19:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbiBXSWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 13:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiBXSWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 13:22:11 -0500
Received: from GBR01-CWL-obe.outbound.protection.outlook.com (mail-cwlgbr01on2096.outbound.protection.outlook.com [40.107.11.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE3539163;
        Thu, 24 Feb 2022 10:21:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MaGIEAffd2tefu1etzr/XnYy7SeyP/AKwj/z9T4OvdGcb0w/4+7yyD34pxImoBeyKZpzD+mS9qpIZzWBhoVGhql6JmnAPp10TgyDxrD+TtYT8XkYc3Vrz2R7Q31gETt63CDAAq4Z9QjT1IS03p76cAk6aIJRvTKWuh/KTuWbFHSsIf2N2l0bg1gdZKlFQ4+b20H4OW2IE7x4ZDw7ydnafH7sOjykT/ksc7nGKfVIgGoyJ8+lQbM5SElDGukPu7g9xUbHh1jQUJCc3Nwf70N3ftdQ9u4Wo1xB0gbG5NZCU+qLVyMLx+BndgZAXLBbiB2CpZewsA7sOEFVSC+yOpYLIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47QOp4OCwurkL1kJ4wbU8D/xrWkyWJVBeDH53wf9KdQ=;
 b=EsjnzxhIaBKzfhLJ3PMNL/FEU9ByCA6XO21YDFrsm/h5bYjyTItu0DqKAKFyU9QX5PAgvPP6VMo8pEOvA2If0PtRO09TCcUmCrJS6IA+udHmEy2rk2QzG6L91fs+ddkyBwzpuDjLxlt+iMJBFRPakoO4bBVLuAYV0Xdc0nv9WvOMz7iYTNlUJGwGHMgvQJITjqFpyPVo7SpUSZFtkLSfLBBeK9CPl0sYv69Bbr8N/UAfHGL1XX/80jwdj1NN3Xd8oBYJVlYltU0Z9WOgjaud+xeM5xRro1rhj/GQG/FsU9LlfvzPzlH4IlxqvFe0n6qGtkt2ZSi8MNa7trsKAoMEPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47QOp4OCwurkL1kJ4wbU8D/xrWkyWJVBeDH53wf9KdQ=;
 b=EEv0UY1PhoKjl7hWvhDqZsZe6+19yUaPJmfKDIO3g4uh61ejey0mdDq+BGgGnzsUj5Q76LirzpinL3JImCMguOqTSXpI4C2oXL8uMTzCkCUdFae3ZAFpQaH4XWlem1SwOckKcui/V084Wy/IVUVsdgqdYZ1eor5n9g6C1eoJjNg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=purelifi.com;
Received: from LO0P265MB3226.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:15b::5)
 by LO2P265MB4631.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:227::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 18:21:39 +0000
Received: from LO0P265MB3226.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f9ee:fbdb:b1e3:1a75]) by LO0P265MB3226.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f9ee:fbdb:b1e3:1a75%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 18:21:38 +0000
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
Subject: [PATCH v22 1/2] nl80211: Add LC placeholder band definition to nl80211_band
Date:   Thu, 24 Feb 2022 18:20:06 +0000
Message-Id: <20220224182042.132466-2-srini.raju@purelifi.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220224182042.132466-1-srini.raju@purelifi.com>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
 <20220224182042.132466-1-srini.raju@purelifi.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0229.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::18) To LO0P265MB3226.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:15b::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60cd26f0-93c0-4faa-a566-08d9f7c27faf
X-MS-TrafficTypeDiagnostic: LO2P265MB4631:EE_
X-Microsoft-Antispam-PRVS: <LO2P265MB4631463799E784736657B190E03D9@LO2P265MB4631.GBRP265.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SDIdN4tSy4bPVPgvhZdFaH0CTKZo0fO9NB09Bclvxcug0R8lk9/f7b/t9IkwE8uESpNtWdf1OiVRKFfPxLMNKC1ZtHS4O6rpw3Sdm+yyS+nUca7bQ2vIEq+rYNuJ7m8DrMhCPVkBRjO4laJyxV9VWQ4zyAXsQ+coqbmL/1nYMcxa33ttO66kzOT8vWVPgXgVgpMSpMkuvO+RZNnrFyflPxU5tR71Cl5oSu7Ef3fU4QDGck7L3PCGe8fcvQQk1arffoZ7oaFqmoPJ7rdS7pRHcbVgZtImiqTrhHIuAo6quIh7OhWYRYT8jpVFPHZJVkVTdd+Gsoqdj2r4VLIzCWHhTLzTAlTO22V4iHLaL85bLEPVYjPAAcopgnSA/rBYd4w6gNHXMV/5u5g/vnRV2PXXlGRyTz8EnXm9E290Qh/yCrKhGEOTpA6pGhwQJThpu0IrX37y3fDB5ASLrCGGJXJafARZDofemtpQz6FqJZ3SUz5xbyTf6//mANtLicMYRq6BSRcGYDuAbang6/mKrVTfSjkEQlFVfZK/Ijhnm/4jO74h/7CNDEX2EP3I/AAf+O99lW88BanP6gmeuZQkzbOiZYMollvnouBZOHJgeZaG+z9v4H+kexHAVGFXv2jmLuXph4hdDPLyjtecncCJwORAJaWcm2HIJtXmFs0QOuk0eED0C9DjBgR7sQOi4Wmh+IR7da6sd7vAGY4SIPfbTpjdTN30p9F83cNITdyizolullQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO0P265MB3226.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(36756003)(5660300002)(66556008)(6666004)(8936002)(86362001)(52116002)(2616005)(54906003)(66476007)(4326008)(6506007)(8676002)(316002)(6512007)(1076003)(2906002)(186003)(83380400001)(508600001)(109986005)(26005)(38100700002)(38350700002)(6486002)(266003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u/Z3PG8ts8jT0JwX59fcqff9u9ksVcG6BJ/XTKjdkr6q4qKbvCQwPxhebGxH?=
 =?us-ascii?Q?NLlr9HHP5bq160Ugxza7EahYQf4ALI7SJe5aIw+wYwpt6qnY1MPoiRKULvTv?=
 =?us-ascii?Q?7dyd5/lWtBMPxYOO8Bdgn8o66DkrLYNiirBnZk7BpGvevgpp+1hQpYoHkrJt?=
 =?us-ascii?Q?odO/0Fsxhtb4LZbvKepssYh9gEy7HgbRMfRf1XmYL2t6pCWnUEaJw9h5NXZk?=
 =?us-ascii?Q?0ohQEleKtd1LpL01qpmmPYBy1LdFUnCC57le7Xs2B2B8QFKhY+AuSy/AbfPG?=
 =?us-ascii?Q?exHmyP2h7Js+MEhjAYbMN/J9XP885e0Yn8AWXjrJyoZ2Q2ywholF1TLF2+Rp?=
 =?us-ascii?Q?BHAhQvTrAXLv514c+F4HjYt3tWsHIkWzZw/dJrBbtCWrLd7CmbfA6ikwb7i0?=
 =?us-ascii?Q?6ftrDMnL3vOfVSQh/AUAQiqDBfPGKNFyJSN/+fRhb2KjfZprcrXNBYnb2mn6?=
 =?us-ascii?Q?4B1z349D9xfpFqWM5xnf0+o9IFTErvKv48fM5um70A1rcNmwPktDhlo4jcnp?=
 =?us-ascii?Q?NaGs4YmzBKARnPYjbLY7onFh6Kj6wLdR+gO7k+0Ii4KjMFRhrzIRyQDmCpe4?=
 =?us-ascii?Q?HoUxO9BP+Hg+3RMo65An6qtMqpw0o6YuL+7JJEmirxBAoRbCLCyjsDFJa99N?=
 =?us-ascii?Q?g9IfqbkCA4snFYP8Uup3njlMMbGSrB9veblwZmocwPPOfruCk7xvkXOs2dSA?=
 =?us-ascii?Q?0+wU0pH+Yed6XDlUQytEf1p7xQWo/lgUbSDJ9gfofTG81oZKjegRtySIUDlu?=
 =?us-ascii?Q?mPypA2M8IoGyX0F6Kx7H7pFJN7PsV2UUqWNyMsBSphGz8NA09znrOaqqm9/R?=
 =?us-ascii?Q?LyOMJPdI81ogqup4DpAFGTaeYBd79mPtN/AOCKy63v8SOkPJRtGzZZ0teOSE?=
 =?us-ascii?Q?bu1ItdMtVdCxu3pFucxci6PQGFt3Qyc77SgDN/TP9/Mz2ACowZgWSYuyY/PR?=
 =?us-ascii?Q?zKYMbF9hMhmefnI6pkHlhzK42nrJM1EqObTWmYqfD30U+waBScqT0faz5t1g?=
 =?us-ascii?Q?tYeArIE0ViGJQnC/83R2NUEcPvYifu6ijAPz4U1m0f87SiS8+6FtVEGGJ2/h?=
 =?us-ascii?Q?frZOMyPkEm7RlOThLqr/uCRoukRofpmdL0xSdfIixgoNIJIBxzBlyYWulLSN?=
 =?us-ascii?Q?aIcLGKVW4j5yT/ObOMb/kXU0amA3atjzywFQRbbTZkbLfJBr+3dJPgN9YiJ1?=
 =?us-ascii?Q?YMqJswVeXUnVQa5+pO6H6rWSrJc7l30WZQ6zg+D3hWMCRgUDqI78ejpIh2Nu?=
 =?us-ascii?Q?c4ZkDWl1dt6lLoV1pSr7+nsJZM+eYOORBBs/ypD9YQ3M8MthW5vNDcMJ2b24?=
 =?us-ascii?Q?0fKcijYc6QKwvLuRqBesOMNRt1wi8zmB+0IpTy6PJman03JEWzcjHtilIOJY?=
 =?us-ascii?Q?gr0t7tt/013j/CYCVBAXaJwESRZUpYPoyDESkBSgR+cMhZOHjupyXKH7zWTH?=
 =?us-ascii?Q?XqfYrUUm6rWzhQsO57/2uFwEXQz895by7q05YtDF0k2kf1RUfYze2MlEY7jj?=
 =?us-ascii?Q?FgZdMkO0ohqIY/gZA8t+hDC73ixhX+0zqd8rQ1tweVgpXGN1OCU7CDRfC0Tq?=
 =?us-ascii?Q?peCoqsFGrorjUMQWqNawyhjDfDV+rwOlKQnAP+gBXbUSw+HZUUoH7C2Hsg+s?=
 =?us-ascii?Q?6k9PxjXgn4MRCQaCAiXq0Vg=3D?=
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60cd26f0-93c0-4faa-a566-08d9f7c27faf
X-MS-Exchange-CrossTenant-AuthSource: LO0P265MB3226.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 18:21:38.8506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KdygIc4cmGPY7VspnBeDRO7f2mQsOg4QXgcy+Xvukqxj815C+vKI71U/Z7itWC5FnhrUspjDee2J00HjWR+50Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO2P265MB4631
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

