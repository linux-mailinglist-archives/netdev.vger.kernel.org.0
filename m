Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D10E6DA963
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 09:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbjDGHYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 03:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDGHYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 03:24:12 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2119.outbound.protection.outlook.com [40.107.237.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCBA19B;
        Fri,  7 Apr 2023 00:24:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XgFLtm4mAmPI4FcGYzPpzFltSPdiYEtC5ZUITEU0nwcQbbk6s3lvPhxcZQjIEYT9KUiokCsaXmu9q0CZ8wCaBSVHm1NyQIBKRXM/ppVnhsLzCuH3Z4/neG/uiLYwOd39HnS9Z/P/p1Rm9PErb/aeRF4lu9DDZOd2Qsi8KBAixpSNQk872WcSnfFb8nuduMZ+WL3B8RzCM4SsoUP86XRof80WTnQoGvgqUTpm2wxLUNEiml3ilLPCjbIRiSmR/Rbc9PtPsCpMZGT1Mo0MovV94oeElzNWYs4gTKKK5/jGsO3CO5BcbfbXjwP/Qvczin6pYhBYmIdTuGG4jgv+zGSh5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZpKNFVZ67rPqnOlqfPmeGvVr1zz3RyqavGAa8uQlpWU=;
 b=AMzDn7929E/gmhHMhBbWUpSh690vN0xTeucRC1iZOszsVJNAkjc1/eF/+TLkbXg3uyWYYe+mTIEx54UVSjbbD2cEqOBRmUYRDvzRqrLTXWV98Osdv6YHFCuC9QtKS8aSdePg/ZBgVOnmRDzC/+XozmmWA33tI6WYRdSAOXA+nSCvlELvi6u+v10mqSN6F8UCZkchV9llpWekFfkJoT2X9asvUY8HW9JyCLOlEKG3sdCBjK2M42o0KEvIvEQ29sYQq88wxEWcgfeERXbcmxZnEHfSVjYoOrqz5YuhMmKszFQpg/t7lAiIwg1jXtSfA7qn9/bJEOLwyl7V6FthjDRNzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpKNFVZ67rPqnOlqfPmeGvVr1zz3RyqavGAa8uQlpWU=;
 b=icVzAquPC0eq4QowAPTWdrccN1qoVy+GomRN8r6iHZPtw/OCFxwEEsT1r4ZCbm2TLLXUl9r1jqRd/MHRu/dnwmYElkuiFwLZ7cWPt2FO+kjbc6XOxoA5KgTmLlioU1+UgkT5qszeiDJ0BkLTcG7MhFc9s3XbD1CAY2LZjhKl7Eg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB4520.namprd13.prod.outlook.com (2603:10b6:a03:1d3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Fri, 7 Apr
 2023 07:24:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.034; Fri, 7 Apr 2023
 07:24:05 +0000
Date:   Fri, 7 Apr 2023 09:23:47 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] wifi: mt76: Replace zero-length array with
 flexible-array member
Message-ID: <ZC/FA/t1mzrRydD7@corigine.com>
References: <ZC7X7KCb+JEkPe5D@work>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZC7X7KCb+JEkPe5D@work>
X-ClientProxiedBy: AS4P251CA0014.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB4520:EE_
X-MS-Office365-Filtering-Correlation-Id: f43416fa-f832-463d-440f-08db373911e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ATQy5kSoIUzdRmcwpv3oL5kS+yvQLFZTQvWw4RgnYc8B3ifp5vLfOfXvBjz4+edzWQQFr9jxiYGROra0jUzpJ9ea6tOwc2bLFqICaR79YoZrj5U2gSGqDa8rGSizSNHdGslib9UWJwZ2Itn5p1MjgIvtO/a1RMlICV9M0NoRbtDDJmScUkaPLTnMOZyxWO+D2cdkIUyJFGtLvMiHDZnXjns4CSXbFTAmXgzcRDczpnZEC6ITuIQ3UynsXUWPToEfKl4KyO3FAHmqmyRNcb7Dt57xLWN20zp1+6gWxeHM8UPiOimDUY7kh8tLkoWh+yh7RYpmkOwv3XXSVLUIr0AXwwvd8TsOnC2Q+zGYjpKxQmo3JnP4KIes1plBdwzC4YPkpkX9kVGsfhOXqe0EkwD0gspd8c50BI8sewkfgwV0q/YCAw0QuP/mjcJn+rZpS9tgCe1HGP+3NUQr1robA6F+2fRvBYfXkvBGIXLVcTauAqwVsUI7dUYn38x7nL5S9kWy96ZTlWK4uW9UYkPELMYqqofCs53ShlT8vDMz0kr441yzZJoycFjH9asFfVYLFohjD6XJ/aUYlBybjhHwk5lPZM1J4gvVZoJO6PZ25vVAy4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(39830400003)(136003)(396003)(376002)(451199021)(86362001)(36756003)(41300700001)(316002)(54906003)(66556008)(66476007)(8676002)(66946007)(4326008)(478600001)(966005)(6486002)(6916009)(8936002)(5660300002)(7416002)(2906002)(44832011)(38100700002)(186003)(6666004)(6512007)(6506007)(2616005)(83380400001)(2004002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lMz3WUMPKrUaz9US9r0hMTXFePxMDP6nXYQx2o/nDDAB4/Zu8n3/r/rNZcUN?=
 =?us-ascii?Q?ufq27P02EEdOqI0sTpoPA9qsJzMCTLsRRlyuAACt10wV6xABsJFle+eKgb4U?=
 =?us-ascii?Q?9yWKUXn3gkKTTFsAdlHQ7iOClllmQkxx84+qhIOFDVA33jT5pdZf12oDaVjW?=
 =?us-ascii?Q?GfeNuDeGlYwlvp66Xpg5F8fJdmdw8KMH0XPigGCUj9F7n9KlKw0V2exmj5zV?=
 =?us-ascii?Q?GnbSvzCfPMEIUvXSvPDrtCoXvpdolzDzJqCT6cxZb2KDHiraHnp+mt0oCp6q?=
 =?us-ascii?Q?2QfNPonTdrGpoQTCbJjoqaD3OGecXTI96WIgvpSGlFHwy2xqrQ/MNbbf5Swx?=
 =?us-ascii?Q?eRQXbkUTHgYu2aIkqeb1hDrXdzl5L7Pnm/qPpD4Owuolurh8XsiNrQ4P/xDJ?=
 =?us-ascii?Q?96Cg34CQh7hifssseqWWP7z1+6oA3mv5qYpNBp8+7rXQL9V25w6fk0fuw/yh?=
 =?us-ascii?Q?bicPIbxb9L8DW3X72M72ph/6DfWmV5kkZmGrUvcZXljzfPY1ABkUkD9QhBRa?=
 =?us-ascii?Q?EbGcN0wj3YIGZTtP5BKxrLworTrxWQVyAPdlK7GBc60qs1tfdN0nHRLbwpqE?=
 =?us-ascii?Q?/rYN+OjsnLDMCg8bCD3p18bCVJgyKACet+IBLrIJdSZ4XE7SGXccIZhni+4m?=
 =?us-ascii?Q?K3waa3ZpQlD7aOaabIrOtKIRoxn92lqR3gjkp9oWBbesxCIU5uBcPLygn+XM?=
 =?us-ascii?Q?XGZ5HAn0yVgG1F1KQQlOhYepX5lhIzXl6RpVIYzCIUi+7C+qXrI6Fzw2qa88?=
 =?us-ascii?Q?QESR/gBqGyGNMOHFMnRBOflbUFNbpLDQo8zT+FXZdm2GKqPjr0rsn0WcAhoV?=
 =?us-ascii?Q?CmggFIXjoMBfagHSMDsdayBf1RI3c0/mG0JzyMAdFZRSVlAuzhLP18RYEvpY?=
 =?us-ascii?Q?3dCx9SRmIj4XtjU5hIzqFW/baGE7u2HLtC3xeZvDVp5zMcSE+IDhhG5gtCTB?=
 =?us-ascii?Q?JboWmcEETpw0vUb9Y4dM/rTdP6eclAl6Vzv+BOStmUvovs6Vtp7fffg0tqeq?=
 =?us-ascii?Q?0mLOlOWuSNcnncBPOvu2a78b51o12iK5yrB99U8IT5aEM4ouUq9o7VBRS1++?=
 =?us-ascii?Q?gRJa2rWXfdpF+XhMtuGfAhQC8c2Pmw46/FJPOFnKJ/UiAxmPjbITEynrnUi9?=
 =?us-ascii?Q?WYluvdzCA84MKHZlAOn5oOW6Lcw8bi++RT0O/2ZqE8dkZECQpwbDsVIaWc28?=
 =?us-ascii?Q?hITtWeED0TKNctFG/cvFTaZIH+LtH+3ydY7UA1+S9xJ3ThYSI/poda3EFayi?=
 =?us-ascii?Q?r/XSEwmNjJTtYQ4269gFP69FGRIu5oLgSrpUft3mfMzmWUXzH9PW+CI182Am?=
 =?us-ascii?Q?Uh8zRxgzVtwwib43mI7dcneucXp2keenZ8Yvs/YPn/CSsi/l5l9aPqXILyHm?=
 =?us-ascii?Q?YT/eGtB3ZvOP+x3cBYy3wfM+bb/ZPoEsVOgCw9PLmP6BG0PJHL0FXmwCSX19?=
 =?us-ascii?Q?rkEKlmXueqR3ArNNJ7+ckMsU4RetXA0ijpyxOl3T4fJOcKyuUe64YvUbjpow?=
 =?us-ascii?Q?DPxszoWXXvoT23wLFfTFn/DmbKq8TLimdTDBq7uezWa2hpebmntEyUz8HKb9?=
 =?us-ascii?Q?5htWNVLj9+ivhU5U882tIP8OrzmRS0xJWTYhmv22Q1tl4P3iWrxOha+MacXw?=
 =?us-ascii?Q?4aUCMvteS1LFeIt1Lr2pEHvXpPNjbhx0F/mslqcYLodnxWAvG2jmJqWe3lzN?=
 =?us-ascii?Q?K03FOA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f43416fa-f832-463d-440f-08db373911e2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 07:24:05.8287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Td8jryrds3Mn11sGGg5vUefVCkk7h9XbZaG/MeJARijr1kw8DydIkF1xxHVqsCBEFQfQk/1YJ54HmwQ4+E3uPeSm7sqCwdgdg9ImO7IGe8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB4520
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 08:32:12AM -0600, Gustavo A. R. Silva wrote:
> Zero-length arrays are deprecated [1] and have to be replaced by C99
> flexible-array members.
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE routines
> on memcpy() and help to make progress towards globally enabling
> -fstrict-flex-arrays=3 [2]
> 
> Link: https://github.com/KSPP/linux/issues/78 [1]
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [2]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
> index a5e6ee4daf92..9bf4b4199ee3 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
> @@ -127,7 +127,7 @@ struct mt76_connac2_mcu_rxd {
>  	u8 rsv1[2];
>  	u8 s2d_index;
>  
> -	u8 tlv[0];
> +	u8 tlv[];
>  };
>  
>  struct mt76_connac2_patch_hdr {

Curiously -fstrict-flex-arrays=3 didn't flag this one in my environment,
Ubuntu Lunar.

 gcc-13 --version
 gcc-13 (Ubuntu 13-20230320-1ubuntu1) 13.0.1 20230320 (experimental) [master r13-6759-g5194ad1958c]
 Copyright (C) 2023 Free Software Foundation, Inc.
 This is free software; see the source for copying conditions.  There is NO
 warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

I did, however, notice some other problems reported by gcc-13 with
-fstrict-flex-arrays=3 in drivers/net/wireless/mediatek/mt76
when run against net-next wireless. I've listed them in diff format below.

Are these on your radar too?

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h b/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h
index 35268b0890ad..d09bb4eed1ec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h
@@ -24,7 +24,7 @@ struct mt7921_asar_dyn {
 	u8 names[4];
 	u8 enable;
 	u8 nr_tbl;
-	struct mt7921_asar_dyn_limit tbl[0];
+	struct mt7921_asar_dyn_limit tbl[];
 } __packed;
 
 struct mt7921_asar_dyn_limit_v2 {
@@ -37,7 +37,7 @@ struct mt7921_asar_dyn_v2 {
 	u8 enable;
 	u8 rsvd;
 	u8 nr_tbl;
-	struct mt7921_asar_dyn_limit_v2 tbl[0];
+	struct mt7921_asar_dyn_limit_v2 tbl[];
 } __packed;
 
 struct mt7921_asar_geo_band {
@@ -55,7 +55,7 @@ struct mt7921_asar_geo {
 	u8 names[4];
 	u8 version;
 	u8 nr_tbl;
-	struct mt7921_asar_geo_limit tbl[0];
+	struct mt7921_asar_geo_limit tbl[];
 } __packed;
 
 struct mt7921_asar_geo_limit_v2 {
@@ -69,7 +69,7 @@ struct mt7921_asar_geo_v2 {
 	u8 version;
 	u8 rsvd;
 	u8 nr_tbl;
-	struct mt7921_asar_geo_limit_v2 tbl[0];
+	struct mt7921_asar_geo_limit_v2 tbl[];
 } __packed;
 
 struct mt7921_asar_cl {
@@ -85,7 +85,7 @@ struct mt7921_asar_fg {
 	u8 rsvd;
 	u8 nr_flag;
 	u8 rsvd1;
-	u8 flag[0];
+	u8 flag[];
 } __packed;
 
 struct mt7921_acpi_sar {
