Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8200431409
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 12:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhJRKFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 06:05:12 -0400
Received: from mail-eopbgr100121.outbound.protection.outlook.com ([40.107.10.121]:7141
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231166AbhJRKFK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 06:05:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLMOEHIn+fom6OS/u9nCreRDMqEq53LBYpBI6Q62lrLe0xX4Nod4VwLHTtJhUori4l9BuyUCicp4mIUDzyIO/zztVki/Kq32J6HzPx57QPEe+xANNkeduOKCn4/NyEIcOUot5XQbuXJhfNRujRPy0bFYagEojoehQGstAa7HpJ8uWQxWf/ylWOQiEvIAU+4DkQeMuenCYtPvJPhQMLE+ZbSmoAoBj848HGs25HdgTEKVJgP9ft7iEIF59SKL94anWwR71Qodpl4VuJkr4+Q1THd17hyV3b3dZy0M87EedoBW2xw4D7W3xi5S2hS8nN9anrwI/Px11iX8vtLIK5XeuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47QOp4OCwurkL1kJ4wbU8D/xrWkyWJVBeDH53wf9KdQ=;
 b=VU30tk9hF2hW4BEInBaX0zoMjPdqumFmK4oFzjZpR+nN3mld5uPC1JU2ono12VdQQiVTdPw47ZDQKTxWZRUN1+cJV9UkdJlY/OVN+nRXljqrKNfltOdyAFQ9FfnvF5iz5mS5m7E8NWMqqzLyagtWrF9Ps80EGr8LvuuuI5fJJZHZ8NGBFdy0gwuNJ7wH7j5JDF0LmFpqjqeoD+QaXQJ4NuGTB91kDA7/jWw1/NWFnA50/JRhPne/ALVttaMTkc8G85fyGCb9olMGkP09EbOcRZjYeBdYsR5/lxaP5D8ziV/0FPcfHqRjmD4EflUwsINnmQrUGCFpHa2exzTooWKNDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47QOp4OCwurkL1kJ4wbU8D/xrWkyWJVBeDH53wf9KdQ=;
 b=phrMSC6i9j63X5+iK2tdFAd/xO6WiTAJKEZKCEtq/SRjbiCSS8FIPS6S2jtYR67MArgwfp9x2rYCmFqGGusGRAwKDNxJMdFP4ExwJbRXqC9M8RtoEJ0rNxcHwa9nDijNjOeT4rtoapUHw9Rh7hHcMxLN5jAqhz3ll71S//v2zxs=
Authentication-Results: purelifi.com; dkim=none (message not signed)
 header.d=none;purelifi.com; dmarc=none action=none header.from=purelifi.com;
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:bb::9) by
 CWLP265MB2244.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:61::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.17; Mon, 18 Oct 2021 10:02:57 +0000
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f424:5607:7815:ac8e]) by CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f424:5607:7815:ac8e%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 10:02:57 +0000
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
Subject: [PATCH v20 1/2] nl80211: Add LC placeholder band definition to nl80211_band
Date:   Mon, 18 Oct 2021 11:00:54 +0100
Message-Id: <20211018100143.7565-2-srini.raju@purelifi.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211018100143.7565-1-srini.raju@purelifi.com>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
 <20211018100143.7565-1-srini.raju@purelifi.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0046.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::34) To CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:bb::9)
MIME-Version: 1.0
Received: from localhost.localdomain (82.34.80.192) by LO2P265CA0046.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:61::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Mon, 18 Oct 2021 10:02:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 397c5273-f685-409d-281f-08d9921e7610
X-MS-TrafficTypeDiagnostic: CWLP265MB2244:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CWLP265MB224448BCB7AAD33E385BA735E0BC9@CWLP265MB2244.GBRP265.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j9TJhOBu3RuBCIVWc0cKc2uMCglcd09pXcuYeITCmomRnWdPwE4ELD06Tnea9Ris3CTpwEccZyPYYFcs0oMsIzVe2GTQnXCa0SC/F9x/6a9BmE7OMHcYz+y+C7xIK/1e7FKlWtWEZavOpvtMW333h/PqQrA0/0juGn8tQic27tBsWpyLN4iEkOB1PO4+AebJgv1n1bJnmSNJlUCO+3BMrhv7g28GrIZ3/qF+6e3xtP5HIatFdzZwWmCICCZ+hP5HuZ3BlxASa7b2W33UsEP2mUvtI0eZTHk1Z4iSuzYXW70F3UEBLTOVnkvvxoZxX/y6+fEHEw04rxcUxi2aAGysDsvgSkFQAQjFJsBTyhbTDUPaC02Mi5TxrmkJeFjYq5JLkBXKb18aXvjKt8QdxjrLXja6mkc4hclsjuU6wkcxpUUZfpc/g/as70WnvQtEdarlQ/JNF2KQGaToXNMIAxMm8n02KwN4htsS/cNjsTwhxiYX4EEebZ5bfWzIPCD9Y3+zvbrpj/cdPJGX0BTOMmLZpa0vlKMlaNze1ZdbUpqwZPnvG7qgAfAzrGWmKDYhZT6/p6cX7lGr3bT++Yl1S5Gi37y0h4ew5B/IFPw9NrhOvxfKIQGNOjKLPS/OyTYLegCeMYXBXAHGPDxoObF2T7Wm9e9Qg0ndR6eTHOlt0mbdKnol6q8jIMiu6rxUAjLTQHqlKkT0mDLWeZGAOiCSszyfHibmdDxiybJwEaRz2tyL9m4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(508600001)(6506007)(26005)(66476007)(38350700002)(52116002)(6486002)(5660300002)(1076003)(109986005)(186003)(6666004)(83380400001)(86362001)(54906003)(2616005)(38100700002)(6512007)(66556008)(956004)(4326008)(2906002)(66946007)(316002)(8936002)(36756003)(266003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HPuLjtbokgNozkpGAhBIR0LaRRfcbXSP2gXb/qMdUE7tpRtQGXVbUdorVqdY?=
 =?us-ascii?Q?fBIyO/QmWB3uLZzxrxKzTIj1U14/yeUfIqO8CLME9nd/YrYhoEbpMrOioLBb?=
 =?us-ascii?Q?kmm3ycsTmsVkgQ2fhGTBTvx00m5Sg9w9zLSA0diW4rYicO4xkNCR9zi/Aw6d?=
 =?us-ascii?Q?fdtvB1YGnEYhEFCk6Q6a7UowQk64fCvU8ySF9EsAENv1GW7UqLKKHxjqtmdI?=
 =?us-ascii?Q?WkvOdv7yUt7NozfJyBI//yRIFOHUFPZLMXAfEYhz5/WRSY7ujKFM6oMxmPDr?=
 =?us-ascii?Q?gnPnwU96lFxUJTQ5HLKHygjEGQ4yCnh+wwkVt0DJn/MJYu6jgwZ1Jv4HZMFz?=
 =?us-ascii?Q?pagckE55QOgkHORRLq1P2s0VSXDLZioCxnPl1VUpwMpmOlJoIOL64a/uruil?=
 =?us-ascii?Q?dj7MUQ6xP+OAIlM+Ri5K8SXAbmD97VZXOGImSHGNfKQJUlgQjh5eIP51wb+6?=
 =?us-ascii?Q?0mvssN/sIKD7Baru6PkFvzW0TIJyyy8n0B7L6JPKavXY2YC5Cgs8qU7Xj9ku?=
 =?us-ascii?Q?7bRwoAPn4VqbPO6Npah2j6pdLH15LBfNwdaD+KvFXUSSymMUSIK85WjA0Xxv?=
 =?us-ascii?Q?dSgtY6eIfVTMDzygtnifFJpGJf8mmNEenFWyYNN1L23kP+wRJjTYPt0f8IT0?=
 =?us-ascii?Q?F/am2Ma3x8LL0okXgE/F0eEbsAfdotqr+xnYGhhsLnV9ezZ0UfTlFzoPB43X?=
 =?us-ascii?Q?TGfilYdr9v6aLONbZORT7j9uPahffQazwM0jGu51P8xhApeq/zI1n9b3t+Qo?=
 =?us-ascii?Q?e3iCELxtmMlLK4z1lS2W/nt/VHQbyDq2aLwbBQu1IUGmWh6bE0ahX1JaUvte?=
 =?us-ascii?Q?Nej33Q8dff9AFFm9mWNZ9hV6vfXGAWiMY8xKEhokJL41l8e0BIE0N7CoMkcr?=
 =?us-ascii?Q?V4SEkSIW91CRalgem6FXwOo1jc5Wi6LOFh7gR9sA27eZR/hNCyB9lyFfOURt?=
 =?us-ascii?Q?TzWUEgKxMmCvF1C9/8KY4ht9FPPFjnyUtIeTGuozbEYKNDoDXxno22nm8BI5?=
 =?us-ascii?Q?wCCma6z/XvCEpPm8+7swOuUcpNrlofJNIf5ply2LihtGyt49ldr5+XnBwi96?=
 =?us-ascii?Q?Y4kX5CjCztyFnU3CwjLqPwHa23QQPGja51Qrz1f8C3nW/FZFCAgYI/GVyvuy?=
 =?us-ascii?Q?J2/2xeln+S+YWJ0ElLEG8o5XRIS3uJhJ0kZxtqo4CTm5vwpgeYXEiJo9QfkD?=
 =?us-ascii?Q?0cNn4oxY0bOA9vc51AOKh467xyGPjVmniOWg7Uh9L0+mcTm6X+X7XvnA5njD?=
 =?us-ascii?Q?oPBlUp7acyO/LMkIsbO+Er54zjk8uDEM94+SOGQvMtWt8Dvs/Bf1/RNeT+7p?=
 =?us-ascii?Q?psXA96qsJAyfgdZ5PVO/ViP1?=
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 397c5273-f685-409d-281f-08d9921e7610
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 10:02:57.8215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eQMPyPgsvy0hFsBG3c6A87M5hiYs6v4oSZ9gAickMeZu9FpakCvZ0dtSqo8w62ylVzxd/rTJqtO8gXaaf2LhYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB2244
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

