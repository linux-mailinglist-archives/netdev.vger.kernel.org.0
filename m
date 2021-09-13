Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D3B408BDD
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240332AbhIMNGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:06:37 -0400
Received: from mail-dm6nam10on2073.outbound.protection.outlook.com ([40.107.93.73]:38187
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239407AbhIMNFe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:05:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjg/uT50Iuat96GPpHZOSvIbScmksuZ5Dif5nWZU1VUOrAdPhuJednKzghBvNwXYP5NcWXPMl1P9/8uh44jmJyDUXC43dV/cFS/9YLtYtQZ9wg3r07Hm/S8FsyZZ0eboE4cTAo6vihwPZWSh5tDjXJR6uDKXix5jy6H1Dsx+FCHiyif9rBW7msy7yx0tEDQ/adeEuxe/l8CYFlbRSIlfJmu3xdW7YV0HCl9YMFSN153zLIXjhu/YV8apBPJZgqZIkh/jeKmED7HebLmqfH9TASosi8YoA04kCdCtWzQ8PSbmhPGUj4TqqCkSmI8JPMfzYzurQDiFydBcfcalaP1vUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=E/S/HshNlV98QsA4x8RNmUx1uBUgniC0pQCXSc86G7U=;
 b=M82md4Bs0P4RAa7kz6+1d/31plZ3waTPYPQljM0t+s9lsLRkJiEEeJCTyeiipu+OtPoKFVSvWmM4LmEfy76rAHn7q+2Ej67pb+d9gBo4Tp4yQpem8O17j1sR4vnC7lZPasSwOywo48ih1lq5J1fHNA3lSw07kk9/LBg1Uxuhn2bBvYr2QkS+odnsP0PagNsH5qGbs/8emB9t/URo2Qsuu7NfQfDIyGjSnt5LvFFB8qbDwsBmf/QJaOZfYALboRoU67tiGXrfHpL75FSOLeC9xyr6nLLwLPKl45JBVKEYSzPHlTZnloWE+LTp31sk217bi0KM4hUmI3AZS430TkuLDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/S/HshNlV98QsA4x8RNmUx1uBUgniC0pQCXSc86G7U=;
 b=cISOXSPgOfSVQOmYnRFYCBJoasJ67orPOVzwx7s5dGlaBbM7Pa+lZj3U8FtYYmeDS29dBVB0xMJ+3wzSMkfikk9GgKcpbsIiCq1ShyCGSOLrGJ0Z7LnbEoxdwUqpq1scIRWwo/ejyTxy+cbALrrKCIHAw6Uxpx0aqcx77xNqBZM=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3502.namprd11.prod.outlook.com (2603:10b6:805:da::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:03:14 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:03:14 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 30/32] staging: wfx: explain the purpose of wfx_send_pds()
Date:   Mon, 13 Sep 2021 15:02:01 +0200
Message-Id: <20210913130203.1903622-31-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:03:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89ce0699-15fd-4f1f-ebc0-08d976b6d877
X-MS-TrafficTypeDiagnostic: SN6PR11MB3502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3502195D5B565333B6DC325F93D99@SN6PR11MB3502.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sehRm7WLFrPUDhR9iSH6tDX9ks9+sKnih/yrhPOtYZN1WUg+rr3roNmABc580anyk3lgZ0hSPzbxk6MrYfnV8DT+kz2NvNMRUIyffAMnnzRpW0CNCjbjyAlNYWqCAKPEBOCMPUAaFmjc2E2d9x350TQphAwq18x/QYr0sZoFCsJ9YpPe8HhNkR9pngCK8LCnJNH2652WPsAatUeBFvBErQ8H6tAAZdpxuIrUh5Mh4qVnoaQI7Kt9xVLLhrPAwsB0HLeTd607H4bAHBC0V3LgkNOJ7zT0RIs13tWP614c+UUKugPmUzwCRTm7l1oGhAmMJIjZz2x1zFSnGXkwEcu01I5SLOPZTbMGS6blX2rChabRGKi2Gw5Hfru6FGIF9II+Eoj6g/ChsRttj8elymHebRPUbaCK57qr6Ios9m1GSgRW/DSS1+wMqIS5A1/CDX0xOpx0bnY8lv/xNdIgifTlPbFnrS1RNi0DzAV/YJk/406eGTbFT3lqyFAKEZvdpYOkwLo3L9bqFb3fXuEQ1nbItsAqVfClBUcpL9RE/dinLhCqkWVqwmJKsCIh5sz8Pa5gzzFXyVwa1XiMXP03wPNnIaQZjjkXOR1WI7yebGXkuT5sM8X5Do88kzN4oaUvDkqzKXhsGKix/xzLwO50EUCQMhWCRZqJEb1gvvhCyGbVhy3us9OyYFRzsqE7qTs3ciBIhdl7l4Fn90KQz6nsRzETdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(136003)(396003)(376002)(346002)(366004)(6666004)(316002)(66476007)(8676002)(186003)(7696005)(52116002)(66946007)(26005)(4326008)(66556008)(2906002)(54906003)(107886003)(6486002)(2616005)(478600001)(1076003)(36756003)(5660300002)(66574015)(956004)(8936002)(86362001)(38100700002)(38350700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rm9DZWM4bEpNMGZjYldPUGhhMVZqK0s1aXo2RHM2dG55ZjFsRkRhRDJ0TzhK?=
 =?utf-8?B?OUxtVWhlR2tJSnpiNzlJZDJZcENsUk9YUTJqZkNrMTlNOXRnc3c1UTMvWkNI?=
 =?utf-8?B?aUxiM2QySGUrZlg3UzFPeHhYOE1kdlk3MWVCN09zTVF1UGE5NW9qVWxicjB5?=
 =?utf-8?B?NFNNL04vSWdXUlhsUUJYZEU2RjBkcks2WFEwRmtLK2ZmL2hTdEdreDljYWRa?=
 =?utf-8?B?NnY3a2djMHVzSHVMcTlhc1YxTmN3Z3VLM1NNWi9kUTAwVEFJMmhXN0dqSzA3?=
 =?utf-8?B?bFYzR0J5dkt5U0U5c1RVcEJhSGpmOW9kME9JamkzYVZsa3NsbCtGZHh6WkFI?=
 =?utf-8?B?bFdJOHIycmRIY1dGZmVQV0I2T2w1RjFaNEpqNno2QzJ4M2ZkY2NHc3RUV1RZ?=
 =?utf-8?B?R2hsUlFvczA0YTV6Rk9VY0hsRVo4L1YxTUVPTjQxWUNVYU1wNXoyQVErU3Zk?=
 =?utf-8?B?dFdNTUZqZWdvSlJSTDJ5WVVMampzTTMwMk54WDc2bGZDbzdMa09WQXBvMTNF?=
 =?utf-8?B?cmhjS2dGOUtSb3J5SGh2QUJmd1ZBbCtsUkFjV29yV3U3MERkMjZ4dk5IaTdl?=
 =?utf-8?B?TnEySDhEYm51RUNIZE85NFdiSFJRNHhkWWl0ZFNGc040cHpRcHVaU3cyT1RE?=
 =?utf-8?B?dUFtRVhkRzJuQkhpazlTNGN4SlMwT0x3Wm01UGxIWmVGSzdDekF6OWZJaHFV?=
 =?utf-8?B?ZE9KdGR3R2puZ1Z0MzgyTWFUS0hHcFVxbHBjbHhxTU5UdkpJSGFSVXpueHFB?=
 =?utf-8?B?bFM5VUFYN3VrVVdLMlJwRFpWTlJEdzRid1QraHorQVZnbmhjbk5ScFVCSzFL?=
 =?utf-8?B?QitaL0o4dUlGZUNYcjVRVHVUUEQwYjhDeUFDUWljcUU4VmlVTGNGZGRpVjdV?=
 =?utf-8?B?TGRuZEZCVGZxQlVBUHNCKzJKQ2JQTFI0VjMvYnQrcDJtUTVHWnpHeU92RnRx?=
 =?utf-8?B?QjhXd0VIQ3JESCtTYmQyQTkwbThHR0ZoQjNOTStXeE5la3hTUUwxME91YkhM?=
 =?utf-8?B?MjYxLzB0SktZaFZTWTRGQVg1TWVuNlJNeTJsMW9RbHVmK3dLRU5GK3ZYUVNJ?=
 =?utf-8?B?SCtiQ0RITzVVMHdyUitudjZiM3dtcFNmM3lTWitReVpSbkhJcFE5VFJ1RGFX?=
 =?utf-8?B?Z2R4d0VRYTNRdjRZRTdTQ3h1T2xVUW50NWRxVzJpck5ubkJwQS9ZS1E3dkFF?=
 =?utf-8?B?b1Zxb1RaNmd2dEV3Ry9HQmQwaDFPd2w0TXNSMWVFNzJWVVdDY21JcVF1R0RZ?=
 =?utf-8?B?dDhnTlJRNm1GbmQwYUxIWk1vd1JaMGQ4ZVVZaG54cXhuc1dtVThqbVRHNldV?=
 =?utf-8?B?WGNJYTJ6OVUxQnkwMUdncUt2dW1wUTk4YlRrVnlwclJ6VFVZRE5aZ2xHc1di?=
 =?utf-8?B?Z0xkdTJmTm43dlg3Q08ya0hkejh4eFU0UFVoaDgyenJ6NFh5eDF2VUR3MDdO?=
 =?utf-8?B?bWJWQ2xEdERmZ0VYVFQ5OElyL3BWVTJzSVZYakJETmhHN0N3ZmpONUxTekVj?=
 =?utf-8?B?b1AvV3hZa2FrL0g5Z3Q3QzFJdEJHRHVxa1g1Ukljdk9BNWFmU21xRk1IRkVG?=
 =?utf-8?B?Q0gzYytPU3AzVzFEYzJyeTU5eFpPZVI5Tm5pOVU0TjhTNjh2bzVMemFyaGlp?=
 =?utf-8?B?ZWtLRnpHMi9mSXQreXhXaG82QWZwVHNnelNEcFM1SEF6a2JuOUlXNzBtV3Rz?=
 =?utf-8?B?cXk1WC9xSGl0TDRVRGNtdThpS09zTmFmeENHeUpzZThxQjFKUEpKSmtrUzlG?=
 =?utf-8?Q?O9Ij8mbkXRky/3ecvFzpt8K6oGSByMdU8D619zh?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89ce0699-15fd-4f1f-ebc0-08d976b6d877
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:03:13.8698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9F6XgrK+zMixYTf5KR+4yGvipRLv700n8KZWx2TnufZIfFiY6WB5Eud3yfOx24//CLSgTIGQob+PTBViwAtrHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKT24g
Zmlyc3QgbG9vaywgdGhlIGdvYWwgb2Ygd2Z4X3NlbmRfcGRzKCkgaXMgbm90IG9idmlvdXMuIEEg
c21hbGwKZXhwbGFuYXRpb24gaXMgd2VsY29tZWQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQ
b3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9tYWluLmMgfCAxNSArKysrKysrKysrKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNl
cnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9tYWluLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwppbmRleCBlNWU4NTJkZGY5YzMu
Ljg1OGQ3NzhjYzU4OSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKKysr
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
