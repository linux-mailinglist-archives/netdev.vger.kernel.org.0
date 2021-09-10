Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D761406F2B
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbhIJQLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:11:49 -0400
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:8641
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229629AbhIJQJt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:09:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ga4zDLewJ4yneXwyYasFU9I09KHx5NY7gx7RGX0u2CbZlBDmieFVU6gZevvoorBUak4mElMQMb/8884eAuN8fZFHGfKrgtbIlsfE4qfldzyZPhwkUQzl4+eoK8ehYDHymWhfz9uDCC8FmR+Vu5lDzkjEvmcFBDb+OYshWpMjiTn1lMhOrdguA2dXi92tUo8bYXru1ZFv7mOC1+HS9HhywXG3eJUsBd/rndyryLbSYpxw6O4cCGLxR9V/OlvtMBq7l+T2Qcr9qflrgCRy47+Dj+qiFYH9drnid1Sh4di2Xx4JM6Crtw+lw/TZjFxv51h3hOkq53KEnY9McQwq3pgS/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=dzwEfQZKRI3oV247NU8V2xMOFhCemH5anBJ8Bdc6bfM=;
 b=F6hWnlSh3wgafy/iPuft07GSKf3JEhUqBl18T2ZdP0g34UQs1261DiRE68Viu/Xqlbn4eC59MJgqQuBcLuT6v9Usg+tLfj7zHji4S52rhAyP7QC+0O2CX7u6vxJ5G7rSgIywIpRTyLN3dvrRh29HBxNJ7AfrnfdfJwVcPVgY3IiijOpgmnquxmpYvDcSbtABAnYIhydXvcb9wEPhoLpQZBKZ7Li4UbgPHhv71l2HSYEW5e5sTSBimKymCREKm22UBm9zKzyDUStoos85yZ19pDIjwDM8Wl0IQENgMZhXLCJy21lB5f+tqKXdHJ/KkTJO8oA6gYPFxRnFyHUJtQqEdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dzwEfQZKRI3oV247NU8V2xMOFhCemH5anBJ8Bdc6bfM=;
 b=Ds/to1ajkKS+0mJJTzfzCfZH3Fy8Op86R9pT9La03nY6Zjth1vmFbPTiAqpV6Hsrrc/eHPOYt63k8SCppoPbvc19sUY68FwlbhH0ImkPP2RiMuUrhP2V3Bk8HvcvaVZBizTuGfvC1BAGjBqfsK1dyoFLZiCTh6mTDKZQ2WKq76s=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3118.namprd11.prod.outlook.com (2603:10b6:805:dc::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 10 Sep
 2021 16:06:03 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:06:03 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 16/31] staging: wfx: declare variables at beginning of functions
Date:   Fri, 10 Sep 2021 18:04:49 +0200
Message-Id: <20210910160504.1794332-17-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:06:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00fd91c0-192a-4e39-9589-08d97474e386
X-MS-TrafficTypeDiagnostic: SN6PR11MB3118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3118B5E6451AB2FFB830A3BF93D69@SN6PR11MB3118.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cFT1rwuZ8ngpnPpHFcwAUZ487NKAQ12L2WzNqBuV7v/VWMZLqh0W0TXVDXzNdgUqPtFZkp+tTP0fGukzPvPAFO/WMMWzSXKpEHsdHyOht6Z/DaZG3zGygwqW9nThcFPgTMjrUQbn99ydot607eGtWG8mnF01qHdvShAgF5AhaUNLaId/fn8I3mrj48DUu7qs8mn7ltaz6jWn7m0b9fjy25CAsXLKqHIISkthHTDXsFOd+UsBD2S3o24WC0yzRn2HFm2KfAU+ikGZeOiuZkIknkipOu33UBRGHRNCwJ1K+K95wKSER9KE7SrWVNCYT/zValApPeS49PgrlJSx+ieHkA8FT1vbXIDwM5+o24DztBXxMbe4z4LLTKgvC8oS3Ysd60KDsmJ5BXMH1vF3dVCxA3j8yl130Q2iI+rrQPu9vvpCBwiN5uH1MYO6576YJUVLRRFrqGUgQLNsFiFt68F29L84v4lOU4GvIZklswdEldMztJuMymz06V9LLsGcJ26x4i64NeZJ0d54uqkhlYaBVgQbZSdoFAg8jHbKWxVOVWLLVfJ8imz5lHVNgsbniwAfckh6ZV5Gxxduy3oIpKx4N00CvWXBmseeXC4MZ4FJhWUAjHsCgpcfWhOcjLwsELHQJu4zvvvlp2W6LdH0XIYcdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39850400004)(396003)(4326008)(66476007)(107886003)(36756003)(186003)(316002)(6486002)(66556008)(8676002)(6666004)(86362001)(2906002)(54906003)(38100700002)(83380400001)(8936002)(5660300002)(66946007)(1076003)(2616005)(52116002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmNlbUJoZGNFWS9DdDhScGduNFhwVnl5bHVLQVlGclRTS21zbHhmYkxIOHJR?=
 =?utf-8?B?bHZyWnR2cG1VYzhvVW1zQm1nM3Q1TkRON0tBWlovT1VUVHdadm1RVkdMTFBD?=
 =?utf-8?B?cHJkN2F1TmVKbGJzTGNoRkJ1bEoxUm9zcUJ2aEd6TnVDR3AvcjE2cTcxNVoz?=
 =?utf-8?B?ekVRUmQ4YVVRbUNsSkN2VXFmanZpMmgwaFFiVFNUTVNQamZ3MHJnQVJGeUQw?=
 =?utf-8?B?SXZib0gwTDZ1MmhGWVg3dFFDT0xmTlYxV2lHaEVkUG54d3F0MThuNnN4bzhO?=
 =?utf-8?B?SDJ0YStVdEcyRUMvbGV3UTIvRmx1bDVXS2NjSnZOSTdmcU5OdEY0NUl2bGJk?=
 =?utf-8?B?d01mWWNZZ21xZFFwMzd0SzlaQS95T2dZRTR2NnMrTlFIZHFKK25Sa2ozYkJB?=
 =?utf-8?B?QXdDYzRxNnUySjBPVWFJeG1GWktDWXJQSVdxT3dCK2NyR3ArQk51Z1FsZzRJ?=
 =?utf-8?B?UEVuOEpmenZrM3B0emt6TVAzRGhVaGNQdkRGbHBXVjJoTWt6eU9zU2YxM3J1?=
 =?utf-8?B?eU14Ny9FR2xpNXRjVlNaOVhlSU02bGdXYW5hVEFEREpXOEFzZ1c2YVkzOS9w?=
 =?utf-8?B?UXpSMENHcGN5RElIWDBiMG1ZeGJkL25MY0hqcmVXTC9xaDJnQXRUZjZSK2hS?=
 =?utf-8?B?d01pRnptNXFxZUtXQjh2eFJDYnROYmFrc2pOTlVzTkhOYUVqT0NDQXRGdnBI?=
 =?utf-8?B?ZjRZM1BsRG1TcklKbFozVUx0OXo3NUVxM25hK2dkQUVhQm51L05oZCtYbGlD?=
 =?utf-8?B?bjdUOVhGZzE1QWlqR3BCejJIMnN5VXBVRy9CRkgrYitGSXMzMDMxRWdwUUZ2?=
 =?utf-8?B?Ri9XTSt6Z2FjWGhHVEdUY0JiYURNT1owNW80MFhMc04vNTRUbnIvZ3BxR04v?=
 =?utf-8?B?a2k1dVFnSStSODVmSlNaa3BPM2RyZ0RGQnM5T25uYzM4dGJwV29rYzJqdkF1?=
 =?utf-8?B?L1dmOEY2VWU5RlVTTVZmNmtWVlhJOUU4OVFtd0h0cXIzcXFnRi9PUVB6bnN3?=
 =?utf-8?B?UU0rZU04bFNwWUNiS0UycFk3RkdOeUVuUU1tT3l6WXZPRndGblV1L3JWdkVR?=
 =?utf-8?B?UHFnMDJjREZPRUgyQjdEQTdGR2hYcXgwRXlCR0J5MzBNY0pYMVNhcTR0dXFH?=
 =?utf-8?B?cXJXS1ErK29EYllMKy9IbWovT2F6UjE1dnQxSUx1NHZjZjkyK0NUTjlnUG9s?=
 =?utf-8?B?akNRY21NRDlrd1lhb2hJVit1ekJBT0YwZmNHK1B4UlFIR3g2QnZ0WE4zbVVO?=
 =?utf-8?B?U0xMSW42UUZpeitxYm1zdEF6cTF3a3Zralo5MFpVSWFXNnIyRXdDZGpVdnFJ?=
 =?utf-8?B?UXJoUXpSL2E1OXo1eXpYQ0dDNWFpYzZPZHRuVHlnTzU4UFNmT21GUzUvVVVZ?=
 =?utf-8?B?WXpJcUVSTmZzTng5VWIwNFpYNHk1YWY3cTgvYzUxaGNqN3ZIVEdMZ0NxQW5i?=
 =?utf-8?B?SEVZL3pYSmt6a0ZMNzRyYk1DOVRTclBHTk9DNFppeDhJQVJxelo4OVdMNmdC?=
 =?utf-8?B?eGZuc1ZjelRlR3ptdmg5OHQ0RHFEQ3Uyc1pwYnczSlVyQkI5QlJtU21nWC92?=
 =?utf-8?B?dlNFcGJ5TjRPekNvVWpiaTNHMmJ4V0x4TmVqSGtEbE5JWGE3QXRiSFBReWl4?=
 =?utf-8?B?UTRWbmMzU0xuYVNLaldtdmR5N3kvaTNhZXRIUTdBN2dQY3dpcE1qQWxjZ21l?=
 =?utf-8?B?Y1VtSHdqOVR6TitWZElHcFJsK0NCbTdocUUxU3NuQmhrd3BYYzY2RHY5RHhw?=
 =?utf-8?B?c1pHaDJhZFgxMms4Z0NEQndGdlVuUHFGV3dyRjBlUENZZmRmbHV0YzV0dnFh?=
 =?utf-8?B?eWErSkVtZDU2WFJHclV1OFF5YS9ycVlFY3hFcnRCamhHUU5ITU4zN0NsRS9Y?=
 =?utf-8?Q?qBgKwvF+J/I4N?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00fd91c0-192a-4e39-9589-08d97474e386
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:06:03.4700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wmnr0bXXNhBOGZWEfdONLTk8SjSXkD1S4cQdSwIPYPkGD6H3DDcMuo3Q8toa4O2RdTfRq89gz1Q0PdCEUVwyew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRm9y
IGJldHRlciBjb2RlLCB3ZSBwcmVmZXIgdG8gZGVjbGFyZSBhbGwgdGhlIGxvY2FsIHZhcmlhYmxl
cyBhdApiZWdpbm5pbmcgb2YgdGhlIGZ1bmN0aW9ucy4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1l
IFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L2RhdGFfdHguYyB8IDggKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlv
bnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9k
YXRhX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwppbmRleCBjYWVhZjgzNjE0
N2YuLjAwYzMwNWYxOTJiYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4
LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKQEAgLTEwOCw2ICsxMDgsNyBA
QCBzdGF0aWMgaW50IHdmeF90eF9wb2xpY3lfZ2V0KHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCWlu
dCBpZHg7CiAJc3RydWN0IHR4X3BvbGljeV9jYWNoZSAqY2FjaGUgPSAmd3ZpZi0+dHhfcG9saWN5
X2NhY2hlOwogCXN0cnVjdCB0eF9wb2xpY3kgd2FudGVkOworCXN0cnVjdCB0eF9wb2xpY3kgKmVu
dHJ5OwogCiAJd2Z4X3R4X3BvbGljeV9idWlsZCh3dmlmLCAmd2FudGVkLCByYXRlcyk7CiAKQEAg
LTEyMSwxMSArMTIyLDEwIEBAIHN0YXRpYyBpbnQgd2Z4X3R4X3BvbGljeV9nZXQoc3RydWN0IHdm
eF92aWYgKnd2aWYsCiAJaWYgKGlkeCA+PSAwKSB7CiAJCSpyZW5ldyA9IGZhbHNlOwogCX0gZWxz
ZSB7Ci0JCXN0cnVjdCB0eF9wb2xpY3kgKmVudHJ5OwotCQkqcmVuZXcgPSB0cnVlOwotCQkvKiBJ
ZiBwb2xpY3kgaXMgbm90IGZvdW5kIGNyZWF0ZSBhIG5ldyBvbmUKLQkJICogdXNpbmcgdGhlIG9s
ZGVzdCBlbnRyeSBpbiAiZnJlZSIgbGlzdAorCQkvKiBJZiBwb2xpY3kgaXMgbm90IGZvdW5kIGNy
ZWF0ZSBhIG5ldyBvbmUgdXNpbmcgdGhlIG9sZGVzdAorCQkgKiBlbnRyeSBpbiAiZnJlZSIgbGlz
dAogCQkgKi8KKwkJKnJlbmV3ID0gdHJ1ZTsKIAkJZW50cnkgPSBsaXN0X2VudHJ5KGNhY2hlLT5m
cmVlLnByZXYsIHN0cnVjdCB0eF9wb2xpY3ksIGxpbmspOwogCQltZW1jcHkoZW50cnktPnJhdGVz
LCB3YW50ZWQucmF0ZXMsIHNpemVvZihlbnRyeS0+cmF0ZXMpKTsKIAkJZW50cnktPnVwbG9hZGVk
ID0gZmFsc2U7Ci0tIAoyLjMzLjAKCg==
