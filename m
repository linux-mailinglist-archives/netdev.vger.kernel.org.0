Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F57A408BFB
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238660AbhIMNH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:07:56 -0400
Received: from mail-mw2nam12on2088.outbound.protection.outlook.com ([40.107.244.88]:10209
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239312AbhIMNFZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:05:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YRgG63c4iowjpuW3/KzFK6NxYP1uWrKHTVUrwvKv55uYq9CPZchwuBcF6Op2SqWvMcmGy01KMNVULjBKYKYZVPK6Ykm43Z67g0yt1DYFgu20oRisVReBM6zxNNmjrVQrm8Xp3nbPZNSwCSr2Q9A8kvNS/8+RKfpDb6d/mjWH47OTNUgPRsDW0xU/T5cmfhS9+GUGeP283nhxdXcKzwQb9fkLtztenSWTmuYkkng/KJtL4YKEMjR179HESMq3RF3Uu5aFso6UYfu5awsDD1ZKZuBZ0K+Ha9TfaoesZOaH1ECAW01JPCwUBXZhw0Rv4kO+GnM2SN01/eTczMPiyk3qzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=dzwEfQZKRI3oV247NU8V2xMOFhCemH5anBJ8Bdc6bfM=;
 b=av5L6wwirrnktUofTSQT1xvOUCikxDKCWDIz/TObtEPACtF6H7v9cIR+PeQm2OU/KU8vui17Qmutng0W6gA7GpQlcpOJ47wnLM+zJs/IJBHhaBsCPV4nPS1nAQ0UlMNbm+Iyj0C8HaO76UVaDuGLeYUmxJpZpXMhfcM7kgNDfTQ8WkMIuzfI9CQ0hsR8fKb/xsoXlaPZl+vh+/pr4VCM6PDo3uBV03DP/IcGOOWUej0084Z2IJhBSfuazhaigissTz9RtT77O/pCAJtAtMlyTKVuYPL6nx+pxvQ+uJ5tBUSflz5NCPZeTxnR13BSxLPh+LEuo+o19c41r/sAvWwyqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dzwEfQZKRI3oV247NU8V2xMOFhCemH5anBJ8Bdc6bfM=;
 b=HPd1nMwgkSIuWFbg6cmi/JlLxohbBM2dR+ma5GRx32u5nIh3OXbx7bRzipIndBl/QUHgDG6GeZZ86TbrpHzokfyDkVkirs1KhC3ZV8crwDCiJD3m2pUjsgSsOul0hQUmr8unW+khdHc3xtmOaKsXhdkZy5AcoRBmhRuzJBrXIX0=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4860.namprd11.prod.outlook.com (2603:10b6:806:11b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:02:47 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:47 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 16/32] staging: wfx: declare variables at beginning of functions
Date:   Mon, 13 Sep 2021 15:01:47 +0200
Message-Id: <20210913130203.1903622-17-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bc80ad9-17d1-488b-a9ac-08d976b6c858
X-MS-TrafficTypeDiagnostic: SA2PR11MB4860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB4860B77DAA5350AA0016ABE193D99@SA2PR11MB4860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vr6dfzs8y+LxmxbbULt0S3j73It0G8MOJW8qHC751shYzO5YONksOs5R5yHr6lPXS0wo5S2mg025OQnX1DTseA0vUpIzec1c/NQ6MHgMW2/YGdNfZ9wURVYkggUY/7Oez9wtSkJsMA4NCSjkfn/88vwzDOdh3pWb67fwU3M42wV2C6W1CfuM2Q/hI7LfpRsbDdrmv4PBDmP8LPfZVZ/MfXfANyNaaE3zsiymuhGfkCRi0pc15VjoEo0Cixtkqt0F0l0SS2MivGk4cYfG74hGBUcFw6Fl0syUMTuuQ7K3WL/JIdpc7G0qZsFmuGbwMP+jcP6PwE0OR90h5MSGpv4NnZ2LDo3xmIS9pKS/zK8aIGAJ6ZYM0XR6hX8dlm5cFrpqpCzR493h8mGJpEJc3Eqh6qDUg835Q4FrDRMueXbYV8UR5rKiK9pjSat/NzJLjAg46m7ug51mqYpoNS2bx6aoYacq2q89i1XQUaiRNPjUuV720JOvVpQ8+BHdyYrgHgVYexauibgiR+2OkMJuvkfgcdUSj7ao8LxzFFBAs6Vmjp2MnBq2OHTYjQ8tFUVVyIuPhz6FbgGkPlHV8VJ/6/tyWyeiAY+JgPrkxOtLm9o+YeumjTP0U4z72OSPGMDE1S3kBOVg2E2aFoOE55ziKya1Kd2B3gOc6CJu2M4H5quyMUo3uT6UBvBJ1Vo9gkZ0e17PKqcugvbKIrUB1j2G8nubig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(66946007)(2616005)(26005)(36756003)(38100700002)(38350700002)(316002)(4326008)(107886003)(7696005)(54906003)(5660300002)(52116002)(66556008)(1076003)(66476007)(6486002)(508600001)(8936002)(83380400001)(86362001)(2906002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmkvbUw0Nkxua1VBbmNMcDFHMm9EaktUQm5XZDk2cEtpbTNyUy9kMCtuQ0dL?=
 =?utf-8?B?QnNGSEp3SVU5ZDBjV0xJa3FIbSt6WjdueHgxRGNlNzlUdzZ1dDU4VG5IMWIz?=
 =?utf-8?B?QVUxcXc1NElCS0E0cWZYb3FlcDNUdndMUTFnOGxtRURpZlhkM0x6Qjd6SkdY?=
 =?utf-8?B?eVdJTXdxbXJOaFNGdE9Lb2FuVERPUjVFOU1XVFV0blpFMjgvbkVpME1ISTBt?=
 =?utf-8?B?enhlb2doa2doVzdOUHhtdDZ1aE9PVFB6cjRJOVVCQThjS0VaTGZOL2ZxdGwv?=
 =?utf-8?B?dG5LYVNQSzdDdWErN0FtdFVKUGlEQTdwT1RLNHZCalZKWU1sYk5vcEFDaU5k?=
 =?utf-8?B?VTlwZUFVWHR0YlMyOVRxeVdmSGJrcHJ3SWZxUWpxTzA5dUlJZWRHUHZDNDl5?=
 =?utf-8?B?ZTgwck5RUkVLTkpDT3dxbGNKcDgyTHU4QTY2Vmkrd1VweGlGMHBpNldtOGF0?=
 =?utf-8?B?SGZqZWR6K0duRkx6eGh0TGhqNjE3MC9GTEFzanViSjVGc0NBdDNtQXYzSmpO?=
 =?utf-8?B?Y1ZBVFMvaTkvUlNTVndiSmtOWVROOVdnajFtQVFzdHpSZ296TUhUYmlod2pR?=
 =?utf-8?B?S290dlZzd3RobXl4Snc3Z1V0Q0V2VGlUNG55b3ZkNjh1OFFVbTRidE8vV3oz?=
 =?utf-8?B?aW1yaElWU0IxUXkzbklFY3A4bWl0eUF5MXFnV3lYclA5aW1pN0xZczQ0WE1L?=
 =?utf-8?B?WTQ2VlJEYUt6YkJvekpibVlPVWpoQlBxT0hUalo3RnZDcGVIenNRbGdwS085?=
 =?utf-8?B?UmcrZ3hacGN2TlpnOVl6bkhmdzdZUXN0aitpd2dmc2JtZTBPaVQzWnJWcHQr?=
 =?utf-8?B?ZHE2V1dDVWpWellEVG9QdUUzRmEyMEFPYnJ4SGNuai9ZUWJ0ZUQ5WlJFRm5O?=
 =?utf-8?B?ZlQ4M0tWbDRrL3BEUkplR01KMHRPT3JWRlI1MUtxVWw1VU45enNJU3FHZDNZ?=
 =?utf-8?B?Vkg3bGVoeFU1cXFreEpXUm52Uk5xRElXSXJybkdJSjA2NmV2Q2R0Vi9tWXJJ?=
 =?utf-8?B?Qzg1ZWVYOC95OFEwaU9tL3p5a1h4R3FqRU5zUlBwU1o4TXhYZjNPdkJHcVJW?=
 =?utf-8?B?UkNzQUdjMEtsazlvT2JlN21meEFDTnhpRmtxQjUyOEo5NFRDS0VrclFkeE1E?=
 =?utf-8?B?ZzRWZXZDYmJGdEhCRTVCbHZiNlR0NlFxWmw4SW15S3l4WkgzbDQrSU9GNmwz?=
 =?utf-8?B?YWhFTThIMEFrVDFDcFRRRFo1MXJXQ0Q3NTZKTXNhTHh1NDRuNUdRU0dZclli?=
 =?utf-8?B?WGgvTnRaWXg1enZjaVh3Y3VNRkR6TUY1YzZlVU52SmtKYTgxRklabXZWTmor?=
 =?utf-8?B?OENCa0toMVA3WEJ0aEZkTm5KbFBUcDVhQVpWbTVaemJZR0RScHRBWHFDaGUy?=
 =?utf-8?B?YzF2Rk14RC9hZlllZzhjZmxlWGxYMjU0QU9XeWVzQk9OOWZMM3ZWbWp6elA0?=
 =?utf-8?B?cG9ldVU3T2dXYnFHbm11QmZ4bG9ZUnpRaUxrcFAvTmN4Qm1WRUpKTDhtMmxD?=
 =?utf-8?B?ektOK0xteFFEUXdseUtjNGxIam1ZamZxNEozcjFIQ0Naaks0bTFvNk1iendQ?=
 =?utf-8?B?eTlSeGlZYnRmM2wvZEhLRFlRM1pqMFlDWlU1bWg2Mm9lVDJOQ2xtbUd6a1hH?=
 =?utf-8?B?ejBzMUVHNTZndHp2Zm95aHk4V2JpMElGUjdIalRMQWxPeTB6UFlaYXdKR2dp?=
 =?utf-8?B?cHR2cFU5dXFqQWhaWXlYWmpremt3dmR0Mm1rZ2U1cXRNRWRGYTFWakEvQ3ZF?=
 =?utf-8?Q?piq9o7FN49IcQd8wKSnscis5jwn9FsBjzjj9uwO?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc80ad9-17d1-488b-a9ac-08d976b6c858
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:46.8424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IY+0GqnpkmfzLF+NxEvNB/Ssyn/49hpwQAR1BuQ/F9LcnE0kxf/ILvKYfpYlC8quY9Yxa3I87ktURH/acn1DjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4860
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
