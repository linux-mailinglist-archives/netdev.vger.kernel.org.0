Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BB442A4EB
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 14:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbhJLMyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 08:54:17 -0400
Received: from mail-eopbgr110100.outbound.protection.outlook.com ([40.107.11.100]:55392
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236489AbhJLMyP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 08:54:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TV83dizDdwG7JLZ+8+qHBPr+gA1tyXydBcR0KJOtLqA4K8OU+aIao5K2iufaf8uuRfg7/CUn7BBofn/0LL/mOSTb56x/8kO8k0rDswpOktosgj+bFs+TwM0KBUA9PiN2ByaSpxZmto5jnxTancOuZFWfmtSvCxOWGcA+SJWa8OPrAGd+JKhSRl5JnTj1y+V1VSp4oT6i/eUKdX6DlacV1eyZy23DNjqmRMxHjU6rOpRH4jpNiNJsOYLELJevXlUShSb2y0HOCgnCaJ8DmC/RfPdN7yDlkyyieDmr6ttW+XF+qk8I0KAM6QsaVM6dk+FNVxUEZyps/8D0Ri1rac3VNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47QOp4OCwurkL1kJ4wbU8D/xrWkyWJVBeDH53wf9KdQ=;
 b=d6wu7seO9OpE1doO+BBtunSaXM1gP37LgF7UQfbDtVyXM2YTQHug4u6dIdkhL7eWoqRph/Ol1ata7euT70etPc6z1/aJSEFPERb9ekpZff/hkHvmslAKye2QGzOmSOfleCoJxTn1tDYsjdzgyhrdads1/G+eDhZshxDXelRKSEvFbI9vbJhjnO0xX+AN0haU0weZ+CGKF3DnefMLUnM+ZM5TJCn0mr7jUGWzgOMHrVDcjBfeZbkYvqAaDcghNNPHyRD0zwyXJuxfLJetExyh7cew/2xgCpjJhCylo4gToMHofBHKGQS9+TiAwqnUOm0mINKZIirAZRbVjrv9yvfRsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47QOp4OCwurkL1kJ4wbU8D/xrWkyWJVBeDH53wf9KdQ=;
 b=iaaynrvMle97sbqIveCjuLodx0RmOlcXj2RdSCCyfa6ropTcinRpnmNAlIP515Dfe+aqrZSoVD7vDTFEmqwAEnps7byxrXKL0mhoefAqSPVp+6EgrKa8PrfmNlG/KiPGsVd0B99zdsSrHtcccvD2+nbHxZ3QxbCBdgsQY/R0OC0=
Authentication-Results: purelifi.com; dkim=none (message not signed)
 header.d=none;purelifi.com; dmarc=none action=none header.from=purelifi.com;
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:bb::9) by
 CWLP265MB2708.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:a5::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Tue, 12 Oct 2021 12:52:08 +0000
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::cdf1:580c:afc2:6dd8]) by CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::cdf1:580c:afc2:6dd8%7]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 12:52:08 +0000
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
Subject: [PATCH 1/2] [v19 1/2] nl80211: Add LC placeholder band definition to enum nl80211_band
Date:   Tue, 12 Oct 2021 13:50:11 +0100
Message-Id: <20211012125102.138297-2-srini.raju@purelifi.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012125102.138297-1-srini.raju@purelifi.com>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
 <20211012125102.138297-1-srini.raju@purelifi.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0475.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::31) To CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:bb::9)
MIME-Version: 1.0
Received: from localhost.localdomain (46.226.5.242) by LO2P265CA0475.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Tue, 12 Oct 2021 12:52:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1570a16-2046-4535-e3d0-08d98d7f1995
X-MS-TrafficTypeDiagnostic: CWLP265MB2708:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CWLP265MB27085ABDD6A84D87C306133EE0B69@CWLP265MB2708.GBRP265.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hOYJHxoWMKoMQDQe6HMVDJGPvr5VGTvyhs/LhhlwgYnbEy0HndLT0+o/px2+5uZnoGK4dNPM8X7QVGfC9LWYWJk0o05F4bXtWsEnyQWbX7xc+AjF8/d+YnyU5NgefYxAIt0/ZwDutXqv7Ixtuz+qu38qHQdnUZHdbAEWQdrrBHnKHz7T5+hOXhzb6dTeBEPLYKBfYY8Ek48XHpWCqePsF/G3bVphMl1GgSP10NgUl6Eb4OQ7+kA8Ga5D4SH4hLxvSjOmlpWlcpgBT3QAH8nnEZwYR7PMISTahmGHd+9u5dED3+4FnoZthkAAr1WQvvRVouJ20HQyXjcnZNGDPHTuHRMMHWzv3Cg8oYVKKk7Z9zKcDviISbBp/AobP2neFv/Motk9DpEOmLOp2W8WasjNX7xsTUwcpjCs3TDpZ1un3GexSdG0dHpml0fYkabi/Np2ruaxK1wNKNTFPnCucoNUUvAZT+0u/HfZwZzOIsqeTLpg1wKNR05ao5xyqu+8Q4ur2O18NVehmbSRsoNQbEtou8n5/vqeJrqH7Ja/SRN17dxovU3rVbo1CVJPnF8zA40klE0F24NXkJcWE0SYHLPx8pb3BZINZaZgoGYxvloLnihfe2glNHHWCo7/vL3Hvg/Vy1YXHIZozAg9NuCIxce+rpi2YiQAqhqZ5qobTdpI4yQ+dpSm0bMhwso4gOiPW4vCeFMD/hwkBee+Ef7SXVC3ihIFNI7wajcS1CzxPsg74ho=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(52116002)(26005)(186003)(8676002)(109986005)(8936002)(66476007)(6486002)(66946007)(66556008)(508600001)(1076003)(2616005)(4326008)(6512007)(83380400001)(2906002)(54906003)(38100700002)(956004)(6666004)(36756003)(86362001)(316002)(5660300002)(38350700002)(266003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qMExr7QSmFODCLwnLdCXsSy53ItoGnseQsRVv8f3wtt7MIyYqZ8bdv4qcLm2?=
 =?us-ascii?Q?T92PZckAWVhdhfUptO5e/VJ/cLha0qJUop1WoL6MtCc8NV8dsFq+KYR98rT0?=
 =?us-ascii?Q?kfZBq8F3RzaQmmC3TghKr1XChoFQduYJYHvtC0XuNoTvkMKioauGbFiNStwX?=
 =?us-ascii?Q?yQ2TfwHR2THy5W4D3WMOZ2LNAZQkoz0KgmiGyMIt5mXIdu8TqsA0foqzQ/UP?=
 =?us-ascii?Q?gTqVld4nZ2HAXVFrtxEpcEdTIov8DRYYY8BqZ9BT2AkTNcBBfjHD14zDKbKb?=
 =?us-ascii?Q?pQt8mqgFvQrmKP/txAzK6GFO2ilMIJ8AQEGbVbVofiNjHK5Go6rRPahH/W3C?=
 =?us-ascii?Q?EcI6/nwOyo+2yGDcCRhzpqC5KeqnUdOxgmb95y1x22UFCSJ7fXY4qSOFAMK+?=
 =?us-ascii?Q?RZYwSOfHE+T35svSjCBiINVJBHDjicRTo5gi4S/MzctjnwsWC6IcTja3qPpy?=
 =?us-ascii?Q?WmLJ7kNMd28W/7NysR3eEBClVhqOsQRFZGfAL5eC/nfY76U/fPVYaq80PleX?=
 =?us-ascii?Q?glLmH/BvAjsxFvgMEBO+MnAJt9Caf/2KAwdIWtaL7GrkKcXVmOvC8bNYRBTN?=
 =?us-ascii?Q?25+aXZ62uwKq/WVBZoIpQ1oN/qQAH4L7jOeJ7OmaTzML7q6WHesSbUQRdSb9?=
 =?us-ascii?Q?R+pT71LyJbmbJg+/Rpilj755jRK5YxT8bqSIPfUy2pNzDm9Jw6p5Jn4U9Qyu?=
 =?us-ascii?Q?b6f0nKMIUmyWIvJ9FEB/aqAZAwvLgFcVusSpqUkoaiSVaA+oe0Gxe5jw91eq?=
 =?us-ascii?Q?hclsJCbLSAh9yWGXqRJqyXM4FBulOmXrLDXPa/Qx1oR89NQC1TViArlUnenE?=
 =?us-ascii?Q?gI1tJOw2tozrx+fHBRVRJbG1RpwWpFg2Yu995VqkkEQn3eCuYY1VSyTDemjX?=
 =?us-ascii?Q?lTRwp3fIqgPEUu1p+NOHZ4tX7nL2NGD+VsaEG3OUv9D0VlGOqvccvsUwYvC+?=
 =?us-ascii?Q?R8vh32PRFDkd/lnJSwaPKN8zdLAACKW6JERCiK9IDQuNE5Lx/NiynyUZAwoU?=
 =?us-ascii?Q?G9g3E89/VnVqbZemgCRYudigTUgNyPrf7vLys8WQd2FHDhIjz3UpL3W/VqL5?=
 =?us-ascii?Q?SujkFlINbZcihPhSRg3ZwwIPaBOAP51VfDqS0YT9HCxf1n+jS/7a6Zol7XQk?=
 =?us-ascii?Q?B03bNZnVXsy4REerm3avCtZ9IFxoJWS0Z2WPP9yNP9dGcw5aoMC+iWn10GcF?=
 =?us-ascii?Q?J5EyXJwy4IyyevNrJCBhtBvS3dRwLtPNcNSMMMdtq8OcbEFdOy9SjbIrte8g?=
 =?us-ascii?Q?080tpm797igXWLYeAObCIdKK3GH3gZbFWiuFJZPCsUXT+gJ3O3W6o2bI55ch?=
 =?us-ascii?Q?ZOUeAd8hjZsBd7EKSbpG4470?=
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1570a16-2046-4535-e3d0-08d98d7f1995
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 12:52:08.0397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: glwiqWAlAfkeGp1/SJrIRIgycGqq1BWaSDMKbFr4BGBVYW+VDCQavz50ZbPwfe2Zsd8oLuShPKLve/+67idDyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB2708
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

