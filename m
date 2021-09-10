Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F081406EFA
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbhIJQJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:09:30 -0400
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:5600
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231389AbhIJQIV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:08:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbTQ8UdV5bYKJANB+ZTpyUrqusP3AQSdqoHa1Sl0k8DlNlyrhODKNvn4adYp889LdybV97on3H6WQ52Niv/BP14YMQ47ZFt9lX3G+Z8Jt7qJpyYSEhAOYm9FwOW6Yf56ThsBijGEnGG4c1KLwKYOUY+pnr2VmHqNBgEs+BQM+6eA/1Zhh6OsTzbnuRWED341fGzSpVAManhjie2FZNdomn1iDV1iUwxT3Kwdcp/NW+97ns3VydkdeWEpSIyQus7PBN3pNi2Z8Ee2ZoFKS9i6qZeCi0oYT/wYyT3asNLT9BIccMpIiCmG+ETHgjVSyO6Y97M77Fk+sTreqh0vGIE6sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=xsUUtMkFWtWrY3otxSBJQqe+VKNKELAgz0g8V67SD4c=;
 b=NNchf6pc76pAtdlcr14a303E4YMwHvS9p1f2ZdGyGomceQk9bind3703nR0fzMi9Ail27d3kp2dKsYT9CiRJCf4ApnYxGj282kjgCtwHLgBt+wSws+o63wY59Qf2nPilvhXvIKN1tMnpbKBpBeBCfmk8gF3mcBExc4pgDfXDjtBUbGSZcqFCjcoD+J+ocw7o5HjFgdLCBmmxuPwdneAALN5DXvnjvRnlyMlYb/KjGbHCZlRkqPymna77ThRMQDOHI2HNf5IX/lT5Loit7fSInIjmLqEm8rvcKUD+ewJEcYSYeXDoo3c7sesjkw1dIWO0VklZjoMGIcxUyMzHLNIriw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsUUtMkFWtWrY3otxSBJQqe+VKNKELAgz0g8V67SD4c=;
 b=mQCwt8HYOfq77gxUaG8nv86p3yuLZRWc7V5u6iG8ZQ3/IRSJlY4Jzv28fg7sDNRyyYBD8HKqsfEWyLKwrjGLUTU99xRWRRNooENJaeQomEbFHaOKoKm/c1gwrjGEYXIcLjUyMW914Gv300L66v+kwDVXUZSHHudF5dOV+eyCTNs=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5099.namprd11.prod.outlook.com (2603:10b6:806:f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Fri, 10 Sep
 2021 16:07:00 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:07:00 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 30/31] staging: wfx: explain the purpose of wfx_send_pds()
Date:   Fri, 10 Sep 2021 18:05:03 +0200
Message-Id: <20210910160504.1794332-31-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:06:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58f66a6e-a142-4705-7c30-08d97474f331
X-MS-TrafficTypeDiagnostic: SA2PR11MB5099:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB509967683C3120C64D85F0A693D69@SA2PR11MB5099.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uzInxpSqy4hP95NE1rzU7UCqGCIfvwRfYXss2BbiN5alG6zDmaHjTQYJD8y1eZePoSfGMqfX55C5t35mmR7XrXWgBD0SB3HLdF9jDqgcdCcQTjNioRGanYfVzdV+I6Svag4cXCnRxpnFufaoNrpAXyRTqyhbUStcoNm4843opyrabL1eIHgqkpQeCv21FImwTn5hA1gEAmlMp12cj00EbYSZHjkL0UbimqENy8gyuNfI3C3ax2qJNBQHwwSMeUlVG/1GiWoz/9uQAIWjbnAbylgDgZTVayo6hhvjGfRJaa03uY/Ao5rIbJkokZmXkDpTSjyJyyoHmBCgp3FOgL2tMXiWVcJOsZt6IhL9yOcBUyrehIg3b7CdQPAUSiGDREdhEHtvRz+ebUbrTN4dTHHS1Fp4vX/BJZ0Ut7fJG/FIU9MN9X8CbbbN6SQs758yyfj2wp0FDt9OA8OnxiYskAK+MH4QkDYKHFwQwNPNSfAN/RribBUVSZ4Uf6b8P9bK+rn6rxdIgsqFV2dTqTtRaRj04JWd5vnkWIQBUh9IuHZZ17uXhIjt/HpF60mR6IzkFVPTOwBMoPNq5jS2E4pujh2/cwwJcq2JN4P5aO+sDruzGw1mrTDvTaO+p57d2pVcIZ+WWD189CZDsN66MsDMqbk2og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39850400004)(396003)(136003)(346002)(83380400001)(316002)(66556008)(2906002)(6666004)(6486002)(86362001)(66946007)(54906003)(36756003)(1076003)(5660300002)(38100700002)(186003)(8936002)(66574015)(2616005)(4326008)(8676002)(66476007)(478600001)(52116002)(7696005)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZzJiOEkzbXU2VnNXUTl4dFIvdzM4QmZFV2dGMmFVNWZCV091azlnc2N2ck5I?=
 =?utf-8?B?SDViOHZ1ZHRtempuanFya1pMTFZOZmliYkt4UUpXQTZJMU9Tbk5JM3NlK2pa?=
 =?utf-8?B?Tll4OUxUQmxWVCtvYkpETFpOZUpLRWhMZlR2SzhUNzRIWGlhL0ZWMDFCN3JK?=
 =?utf-8?B?UVlmZ21xOGY0cTQ1MXYyRkt1d2VzdTdRLzBFaWVRMVl5Qm5aWUhlR1ZxT0lL?=
 =?utf-8?B?dHluOHR3V3l4WVh0cXBJVXJnTjFKbzNGamR5WGJGazY3bXJmaTFMNnNXK1Q3?=
 =?utf-8?B?cGJ4bEtJL2JYZitWL0Z5UE15QUZDRUsyZ1NhY3UrNnF3NnBwdFlSR2ZNQXJD?=
 =?utf-8?B?SWcvN0xGYjlSK3VFVDZBcXlaUmNpQW5YZVVSYUpOd1E1bCs3Y21ldHJLMXAv?=
 =?utf-8?B?Uk94c1BtOSt6RHI2a1JBSWEwTFFKd3JwNVlDWDRoOE9kV0Nqd01CYmtOOFFE?=
 =?utf-8?B?djk5aXJYWnJUNFlBNjBOZ09nY256OUlIT1p6Q2R2MDR5OUgzV2hNdkdkYm45?=
 =?utf-8?B?NmM2MUFSeGFBcUM4UXFBVnl0Ylk3M2xid1A4ZGltQVdYUTZCSXN3Uld4aEZm?=
 =?utf-8?B?UEVOc0x0V3NCajZMa211VkFoNXpBb1NFaWlTa2krYVR3OTdFY2xpTjZWVkVj?=
 =?utf-8?B?bjRJMFU5VXRhQzJLZlF4Nmd6cVBRcWdicEtnbi9wV1NkWGMyeGZIUHBRbTlj?=
 =?utf-8?B?N3Y4Ym11YmhzNDNwL3Q2ZEtSUjRtTk9BdS92eER2aS9YQyt2Yzl5Qmx2cEkv?=
 =?utf-8?B?bjJwbWxDSWtJalMwMnpkM3QzQjJ3djh6WnJsUkFOU3FFREVnYmRLbWJRVTF4?=
 =?utf-8?B?VHJqZ2RuZENwSVcvMmxxbXJFaU03VkdnNGpIYS9HRkswQlZRRTFNcGRqVFdY?=
 =?utf-8?B?TmloRmpwTGxmbjNTc3VBanhmNHk5SXNWUldMZlFqRzh6d2g2OHhnL3ZYRTlh?=
 =?utf-8?B?NU9oSnF4VHo0Z0hZS2l2SmVUaHVDcnpZeFVod3J3UWY2T0g0dVNTbERsdTZv?=
 =?utf-8?B?YU1OQ2EwMTdMMEptTVYrdE5ZRm41KzhYbVJEMGhZaTJ6Um9YSzRFa3lkUTEr?=
 =?utf-8?B?MTNvRmtVcGdzRml1a1dEMkd2WHdkVGxnMWFWWHdTUGZQZFBxbTF3czZhMjB2?=
 =?utf-8?B?aGRYajd6RGExL2pEdSt6VG9mUU5hOUg0c1Bjam9jdHVMVVRPL2Z0dGtkMThG?=
 =?utf-8?B?c0puOWdvYmlIYWhrOGF4L292UmcrK1o1dmNiUjdvT3djSExmS3krWTdrR2ox?=
 =?utf-8?B?Z3pYMmtLNkh0bWwvVnA5NHBhMTRIVVpYSks5bHJhbG1UcVBLNFYvVVRPNjJM?=
 =?utf-8?B?bE1MekRHQVo5YXEzT0g4cnFlZGl2S2prcDFrRHFONHQzV1Z1QS9td2t5ZEpB?=
 =?utf-8?B?akZoMUVhWlZBU3VKb0d1cFhoSXhjeENvWHJ6S2tSaXV1MmE4VzUyN1RRYy9X?=
 =?utf-8?B?TlhaMTRLMEFmbjAvNSttRUc3blBWZ1JZcm0yd2puVHFpVjQwak04YnlPaUVK?=
 =?utf-8?B?dzBWeVV5QTJ6SEhvVmxZdjVGdWlYd2tWeGp6aWU4NUNLajlIYkVvNExIcTNK?=
 =?utf-8?B?aTZiS0FYM1RWYW96ZDNOMmFJRXlnaERrSHkrS2VPVnRUeElPdDgySTFLT3Qw?=
 =?utf-8?B?TUFzNEkrbFhhWDV0YmJyR0ZldFZoSWM5VnFjNTU2NHloWFl0ZHVtTWRoaG5Y?=
 =?utf-8?B?NkpIVkIvQTZuYkRDMlNjaXBYTVFTTE8xWlo4dzFPSHo0bEVxOGZSQlk3OUM1?=
 =?utf-8?B?eGxRREVxWVBEaldHSnRDQjdpbHl3a29RZ25ySzRBQThpaFd0Z3dQeHJlQlJn?=
 =?utf-8?B?QTkxRHFpNXRDazRhWmkzNnRZTUNrN1JQOWFUNkxoZmlhL1JYWVl2WWkwYWRu?=
 =?utf-8?Q?HLVJsZufduvt7?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58f66a6e-a142-4705-7c30-08d97474f331
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:06:29.7998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PaurAW7MHoFdlTyNGOCyjgxNI+jl8qpJ5qUz4Wziq8myRpmohg5m9KV1wJxLsDpaskALia/xxc0FBvtHtGbMYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5099
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKT24g
Zmlyc3QgbG9vaywgdGhlIGdvYWwgb2Ygd2Z4X3NlbmRfcGRzKCkgaXMgbm90IG9idmlvdXMuIEEg
c21hbGwKZXhwbGFuYXRpb24gaXMgd2VsY29tZWQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQ
b3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9tYWluLmMgfCAxNSArKysrKysrKysrKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNl
cnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9tYWluLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwppbmRleCA4MzI5MjU0NGIxMGEu
LjQzODZlOTk1N2VlNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKKysr
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKQEAgLTE2Myw3ICsxNjMsMjAgQEAgYm9vbCB3
ZnhfYXBpX29sZGVyX3RoYW4oc3RydWN0IHdmeF9kZXYgKndkZXYsIGludCBtYWpvciwgaW50IG1p
bm9yKQogCXJldHVybiBmYWxzZTsKIH0KIAotLyogTk9URTogd2Z4X3NlbmRfcGRzKCkgZGVzdHJv
eSBidWYgKi8KKy8qIFRoZSBkZXZpY2UgbmVlZHMgZGF0YSBhYm91dCB0aGUgYW50ZW5uYSBjb25m
aWd1cmF0aW9uLiBUaGlzIGluZm9ybWF0aW9uIGluCisgKiBwcm92aWRlZCBieSBQRFMgKFBsYXRm
b3JtIERhdGEgU2V0LCB0aGlzIGlzIHRoZSB3b3JkaW5nIHVzZWQgaW4gV0YyMDAKKyAqIGRvY3Vt
ZW50YXRpb24pIGZpbGVzLiBGb3IgaGFyZHdhcmUgaW50ZWdyYXRvcnMsIHRoZSBmdWxsIHByb2Nl
c3MgdG8gY3JlYXRlCisgKiBQRFMgZmlsZXMgaXMgZGVzY3JpYmVkIGhlcmU6CisgKiAgIGh0dHBz
OmdpdGh1Yi5jb20vU2lsaWNvbkxhYnMvd2Z4LWZpcm13YXJlL2Jsb2IvbWFzdGVyL1BEUy9SRUFE
TUUubWQKKyAqCisgKiBTbyB0aGlzIGZ1bmN0aW9uIGFpbXMgdG8gc2VuZCBQRFMgdG8gdGhlIGRl
dmljZS4gSG93ZXZlciwgdGhlIFBEUyBmaWxlIGlzCisgKiBvZnRlbiBiaWdnZXIgdGhhbiBSeCBi
dWZmZXJzIG9mIHRoZSBjaGlwLCBzbyBpdCBoYXMgdG8gYmUgc2VudCBpbiBtdWx0aXBsZQorICog
cGFydHMuCisgKgorICogSW4gYWRkLCB0aGUgUERTIGRhdGEgY2Fubm90IGJlIHNwbGl0IGFueXdo
ZXJlLiBUaGUgUERTIGZpbGVzIGNvbnRhaW5zIHRyZWUKKyAqIHN0cnVjdHVyZXMuIEJyYWNlcyBh
cmUgdXNlZCB0byBlbnRlci9sZWF2ZSBhIGxldmVsIG9mIHRoZSB0cmVlIChpbiBhIEpTT04KKyAq
IGZhc2hpb24pLiBQRFMgZmlsZXMgY2FuIG9ubHkgYmVlbiBzcGxpdCBiZXR3ZWVuIHJvb3Qgbm9k
ZXMuCisgKi8KIGludCB3Znhfc2VuZF9wZHMoc3RydWN0IHdmeF9kZXYgKndkZXYsIHU4ICpidWYs
IHNpemVfdCBsZW4pCiB7CiAJaW50IHJldDsKLS0gCjIuMzMuMAoK
