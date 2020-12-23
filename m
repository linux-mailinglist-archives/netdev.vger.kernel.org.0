Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDA92E1EAE
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 16:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbgLWPlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 10:41:53 -0500
Received: from mail-bn8nam08on2089.outbound.protection.outlook.com ([40.107.100.89]:24001
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729218AbgLWPlo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 10:41:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jb5unaxYpVJoAWIDZujqMCUXh3/I2LFFCbO7/0uBvS+MuMgRgqCVJrwc/9v6YlD/stsUOXvMqu0wQaoPcuTossBEsjsGFVCnpCS37Smbq9MbSpl3EfM3ubh7Lxc8yhFPqNvovwMg6WMctZE6e+aFdMTti7RU+ONM1YGdaxJfAfNteWZ7pq/Ilbdp73lqzvOavVGT/uTUGeCYt+11JJd+fDRc8QPYN9LRQLAGiMXpjnHSCsK/OyMei+d1we9hnsXz6AfhMBuOnAXA0CHXLtHL9YTjyNuoGEV2wugs/Sisnz3sGiCS5ZRy3pPIuHH2Q0SiJL02c/BkkGutVr08dxnf+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMPoZ8e8XcnIpeJ5w6rBJi1gpq16UR6xeMDyqo5yyuA=;
 b=FLfAIbBLX6ZXWtBDX5l3VxndShU4uzj+W0/54QP6nG6nE4vUgUmZHnlU885PhyU0NfxS88RUPO4rdawQOsXiHjZR8rT3NNkGlUzWXkzC2yBAhVzvl+JdY7z8zs8wsURfoaQHz9OO3jk9QRgkCezSJ5i89ViPjUp7sTWvw+ajLpf3QqmAwRxcZIRKmHLGD9M4p8sQoHqnHG1boV6yZJnkIZBR5jgYlXCypHI3foNJ9AzkbIqrINvN+Jf90+s5F2VuTfHmRm7UH49seirfcaL9fGr+gO5klINWh6zXjTqjQZl6wFLemEF1Ik4mY0MkNpc2KyBDAGGoLV5nNvQnTtAnpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMPoZ8e8XcnIpeJ5w6rBJi1gpq16UR6xeMDyqo5yyuA=;
 b=SfCBQH0y6DU5XRZ2NRhZmaUw94G3dvXuRbXov0RqSBZNayfi3jzK5Hg79BgtXQM/hU9hjYF6FYE9VeHMyv9SQatWdppXua2KM0PiwroOCdpZ5WH2uVFwjPl8C3FPz2zrVq5ftFaxnv7sKAQIcHkNORCf2zkeoKYtx/AcL1ZDDIM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4543.namprd11.prod.outlook.com (2603:10b6:806:99::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29; Wed, 23 Dec
 2020 15:40:37 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca%5]) with mapi id 15.20.3700.026; Wed, 23 Dec 2020
 15:40:37 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v4 24/24] wfx: get out from the staging area
Date:   Wed, 23 Dec 2020 16:39:25 +0100
Message-Id: <20201223153925.73742-25-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223153925.73742-1-Jerome.Pouiller@silabs.com>
References: <20201223153925.73742-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SA0PR12CA0024.namprd12.prod.outlook.com
 (2603:10b6:806:6f::29) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SA0PR12CA0024.namprd12.prod.outlook.com (2603:10b6:806:6f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Wed, 23 Dec 2020 15:40:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 430d5c5b-077e-4346-c645-08d8a759186b
X-MS-TrafficTypeDiagnostic: SA0PR11MB4543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4543ABE0810977A8D738955193DE0@SA0PR11MB4543.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lEnB6cH22SG9rW9K8WZ1YwHj76dUKtge4mctfLhOkyOv0l1vE2ntNE2IH+1O5+VTqoZ2Los/Otzc3e9TDIcx3c2bYrHr0NRIGJ2yeAlDsCYCYFrt8yyllGnEuIXPubcJKjTZnCUrsbr5T+vxSfSypHScrCLQQ1IyI716oTY6PNmwxVP3UpS4RsAqF65nzWSvxNLZtBa0QuiQsmBYd1JTHJmPSDeM+BST/rNCfEoFiX4hbJVLuRYg5RXEl8IUISz19asv+CpqyMChnklwxggDgXSPHJJrn+R8EDWWRWgl/LYz5hEmd+h5eSjrDK59X3xoaYKuERHDsZ2bNlTlydZdI8zmD0L2mHAevEMnHhZLocEJgmibNs6ODDT7MB/ev0PCju5G/C1NaTsGdN6d4vh5VpHmy2hj+vPUV4dOEONZuuMqZKoS2WZuL4gRnx1QzTJiNIXAsmrVm2MDpO/RoMt83A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39850400004)(5660300002)(956004)(2616005)(66476007)(66556008)(86362001)(36756003)(107886003)(66574015)(66946007)(6486002)(4326008)(83380400001)(966005)(6666004)(8676002)(186003)(52116002)(16526019)(7416002)(478600001)(26005)(1076003)(316002)(7696005)(54906003)(8936002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UndJWGNlZkVtNEtnWUx6ckVudnhjSXZKNDJobVlNZ2RNaTVGNjNOR2NKeDZr?=
 =?utf-8?B?MDhHckI4Si9CeHV6eHVCcW1naVFyUC9RRGdCalc1bEZkcWQvWjB3M1puSng4?=
 =?utf-8?B?WWxFR0hRbGlDK3BCNHdMSnhXdDFjUTJkSVdQN2d2djUvMHo1eHR1dXVJYW5m?=
 =?utf-8?B?clduWjlyU2x2Sk1tcUg2WHh1Tnc2a3d5MG10UTViTFdnSmhFZmVtNzhRUVA1?=
 =?utf-8?B?QnFlcFRzOTNIOGZWRUpUdFREdndOREdXd0x6VlpHeWdLS0xjOEVxUlE3Q1FU?=
 =?utf-8?B?WVNsTUgrSldXWXliZjYrTk52SFpLTUNzRjdCT2tOSkUreGZuYlpNVkVBQkFP?=
 =?utf-8?B?alRBT2pCdmR3Y2k5Ukp5Qkp6azdFSWlsYXhTeDcvNlpCYlhLSmFEM1Nzc3kv?=
 =?utf-8?B?S2FHdXBtVFp2bDZ2bVlmM0N2LzZzT3NGdWdzckxQWVVqTVJrYzd0WHB6S21S?=
 =?utf-8?B?ZWtEaUVsbmg4SlQvRERxRlhXTTBRWXpvK3Nrc2dYYTJ4U3c5d3JrU3RZbjhE?=
 =?utf-8?B?dFFHQTc2RWZuSzFFMEc3T2x3elJ0aXFNeStRM05EWXZxM1MwLzRQQUdvdWwr?=
 =?utf-8?B?aDF5bHJTL284ei8zSmQ0N3VJcERCd01rOWJ1THRIRnZFWlNMcSszM29reDJn?=
 =?utf-8?B?UXJUcDBWeVFtMG0yUXRZdzB6V3BybElmc0VPN3h4ZjNBSXo3ZnZxa2dMSkRP?=
 =?utf-8?B?QUt2V1Z6dFJnOUtYYlVwUi9rSTIzTnNjdXZNd24vajJ0Y09OZ1lXSkJoN1gv?=
 =?utf-8?B?ZHRtcXRMZmdlSm90RW9NNDRjZDBObEdnc1lXSUpYMXBnTjNsNDBQaHNQZ1RH?=
 =?utf-8?B?dDZjTmJFWUNzMUF6d0RtZTNmWGVqTmdrbFczVVFRbEwwcUgyclNoNmhXMmYz?=
 =?utf-8?B?RkRHKzhSU1BycHkwamVuYVR2alBhZUpORk5GSFR5RFBDd3Z0QUtTOE4yRTYr?=
 =?utf-8?B?UGErTjRJcnhjaHc4TXlyR2Nhc0E4bVpTMVlXNEhYMVNuNW5CWTYvRzZ5SlBj?=
 =?utf-8?B?dUtyR2xPWWU2dkJHR0J3d1RLZDgyUUg4Y0FjNnRhWTZKQ2pIdDMvTmJVSXVz?=
 =?utf-8?B?Z1BDTWJrNXpVVWNPWGhkNnBTUHgxc096aDNsUXV5R016eFRIUW51WEMzSUNz?=
 =?utf-8?B?c2o1S2d5Umh3M0dJQWlXeGlGci9QN0xNeDF2dU9KUlA2a3VMRDYxbXE1OGZU?=
 =?utf-8?B?M1pTb1MvN1dEdDlDd3ZaVTZwMFFEeU5IcGIrdlJoczIvbWZkTFE2cjlaNUFn?=
 =?utf-8?B?L2p5NlVoWlBGeGY0TFdBc0FUWnFJL3FuUVJib0lsUk1oYzJtTUJkc00vd1VQ?=
 =?utf-8?Q?QgGpCZqZygmXKpFbNj/fiClIBGmccMVj3S?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2020 15:40:37.5030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-Network-Message-Id: 430d5c5b-077e-4346-c645-08d8a759186b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BCuniCxFEaI+KwV6lGfuqtoUUpOhIlQylogLJOSsj1MeMhKCGMbvztlEZnpn1pdWWXRX3Wkr5Wa8r2hEV4TpIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4543
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHdmeCBkcml2ZXIgaXMgbm93IG1hdHVyZSBlbm91Z2ggdG8gbGVhdmUgdGhlIHN0YWdpbmcgYXJl
YS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2ls
YWJzLmNvbT4KLS0tCiBNQUlOVEFJTkVSUyAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMyAr
Ky0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL0tjb25maWcgICAgICAgICB8ICAxICsKIGRyaXZlcnMv
bmV0L3dpcmVsZXNzL01ha2VmaWxlICAgICAgICB8ICAxICsKIGRyaXZlcnMvbmV0L3dpcmVsZXNz
L3NpbGFicy9LY29uZmlnICB8IDE4ICsrKysrKysrKysrKysrKysrKwogZHJpdmVycy9uZXQvd2ly
ZWxlc3Mvc2lsYWJzL01ha2VmaWxlIHwgIDMgKysrCiBkcml2ZXJzL3N0YWdpbmcvS2NvbmZpZyAg
ICAgICAgICAgICAgfCAgMiAtLQogZHJpdmVycy9zdGFnaW5nL01ha2VmaWxlICAgICAgICAgICAg
IHwgIDEgLQogZHJpdmVycy9zdGFnaW5nL3dmeC9UT0RPICAgICAgICAgICAgIHwgIDYgLS0tLS0t
CiA4IGZpbGVzIGNoYW5nZWQsIDI1IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQogY3Jl
YXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy9LY29uZmlnCiBjcmVh
dGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL01ha2VmaWxlCiBkZWxl
dGUgbW9kZSAxMDA2NDQgZHJpdmVycy9zdGFnaW5nL3dmeC9UT0RPCgpkaWZmIC0tZ2l0IGEvTUFJ
TlRBSU5FUlMgYi9NQUlOVEFJTkVSUwppbmRleCA5ZDc3ODRhNWNiODguLjM1ODEwMjE5YmFkMCAx
MDA2NDQKLS0tIGEvTUFJTlRBSU5FUlMKKysrIGIvTUFJTlRBSU5FUlMKQEAgLTE2MjE5LDcgKzE2
MjE5LDggQEAgRjoJZHJpdmVycy9wbGF0Zm9ybS94ODYvdG91Y2hzY3JlZW5fZG1pLmMKIFNJTElD
T04gTEFCUyBXSVJFTEVTUyBEUklWRVJTIChmb3IgV0Z4eHggc2VyaWVzKQogTToJSsOpcsO0bWUg
UG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgogUzoJU3VwcG9ydGVkCi1GOglk
cml2ZXJzL3N0YWdpbmcvd2Z4LworRjoJRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdz
L25ldC93aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwKK0Y6CWRyaXZlcnMvbmV0L3dpcmVsZXNzL3Np
bGFicy93ZngvCiAKIFNJTElDT04gTU9USU9OIFNNNzEyIEZSQU1FIEJVRkZFUiBEUklWRVIKIE06
CVN1ZGlwIE11a2hlcmplZSA8c3VkaXBtLm11a2hlcmplZUBnbWFpbC5jb20+CmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9LY29uZmlnIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvS2Nv
bmZpZwppbmRleCA3YWRkMjAwMmZmNGMuLmU3OGZmN2FmNjUxNyAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvS2NvbmZpZworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9LY29uZmln
CkBAIC0zMSw2ICszMSw3IEBAIHNvdXJjZSAiZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlw
L0tjb25maWciCiBzb3VyY2UgImRyaXZlcnMvbmV0L3dpcmVsZXNzL3JhbGluay9LY29uZmlnIgog
c291cmNlICJkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL0tjb25maWciCiBzb3VyY2UgImRy
aXZlcnMvbmV0L3dpcmVsZXNzL3JzaS9LY29uZmlnIgorc291cmNlICJkcml2ZXJzL25ldC93aXJl
bGVzcy9zaWxhYnMvS2NvbmZpZyIKIHNvdXJjZSAiZHJpdmVycy9uZXQvd2lyZWxlc3Mvc3QvS2Nv
bmZpZyIKIHNvdXJjZSAiZHJpdmVycy9uZXQvd2lyZWxlc3MvdGkvS2NvbmZpZyIKIHNvdXJjZSAi
ZHJpdmVycy9uZXQvd2lyZWxlc3MvenlkYXMvS2NvbmZpZyIKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL01ha2VmaWxlIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvTWFrZWZpbGUKaW5k
ZXggODBiMzI0NDk5Nzg2Li43Njg4NWU1ZjBlYTcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL01ha2VmaWxlCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL01ha2VmaWxlCkBAIC0x
Niw2ICsxNiw3IEBAIG9iai0kKENPTkZJR19XTEFOX1ZFTkRPUl9NSUNST0NISVApICs9IG1pY3Jv
Y2hpcC8KIG9iai0kKENPTkZJR19XTEFOX1ZFTkRPUl9SQUxJTkspICs9IHJhbGluay8KIG9iai0k
KENPTkZJR19XTEFOX1ZFTkRPUl9SRUFMVEVLKSArPSByZWFsdGVrLwogb2JqLSQoQ09ORklHX1dM
QU5fVkVORE9SX1JTSSkgKz0gcnNpLworb2JqLSQoQ09ORklHX1dMQU5fVkVORE9SX1NJTEFCUykg
Kz0gc2lsYWJzLwogb2JqLSQoQ09ORklHX1dMQU5fVkVORE9SX1NUKSArPSBzdC8KIG9iai0kKENP
TkZJR19XTEFOX1ZFTkRPUl9USSkgKz0gdGkvCiBvYmotJChDT05GSUdfV0xBTl9WRU5ET1JfWllE
QVMpICs9IHp5ZGFzLwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL0tj
b25maWcgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvS2NvbmZpZwpuZXcgZmlsZSBtb2Rl
IDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLjYyNjJhNzk5YmYzNgotLS0gL2Rldi9udWxsCisr
KyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy9LY29uZmlnCkBAIC0wLDAgKzEsMTggQEAK
KyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAKKworY29uZmlnIFdMQU5fVkVORE9S
X1NJTEFCUworCWJvb2wgIlNpbGljb24gTGFib3JhdG9yaWVzIGRldmljZXMiCisJZGVmYXVsdCB5
CisJaGVscAorCSAgSWYgeW91IGhhdmUgYSB3aXJlbGVzcyBjYXJkIGJlbG9uZ2luZyB0byB0aGlz
IGNsYXNzLCBzYXkgWS4KKworCSAgTm90ZSB0aGF0IHRoZSBhbnN3ZXIgdG8gdGhpcyBxdWVzdGlv
biBkb2Vzbid0IGRpcmVjdGx5IGFmZmVjdCB0aGUKKwkgIGtlcm5lbDogc2F5aW5nIE4gd2lsbCBq
dXN0IGNhdXNlIHRoZSBjb25maWd1cmF0b3IgdG8gc2tpcCBhbGwgdGhlCisJICBxdWVzdGlvbnMg
YWJvdXQgdGhlc2UgY2FyZHMuIElmIHlvdSBzYXkgWSwgeW91IHdpbGwgYmUgYXNrZWQgZm9yCisJ
ICB5b3VyIHNwZWNpZmljIGNhcmQgaW4gdGhlIGZvbGxvd2luZyBxdWVzdGlvbnMuCisKK2lmIFdM
QU5fVkVORE9SX1NJTEFCUworCitzb3VyY2UgImRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93
ZngvS2NvbmZpZyIKKworZW5kaWYgIyBXTEFOX1ZFTkRPUl9TSUxBQlMKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy9NYWtlZmlsZSBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L3NpbGFicy9NYWtlZmlsZQpuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAu
LmMyMjYzZWUyMTAwNgotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3Np
bGFicy9NYWtlZmlsZQpAQCAtMCwwICsxLDMgQEAKKyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6
IEdQTC0yLjAKKworb2JqLSQoQ09ORklHX1dGWCkgICAgICArPSB3ZngvCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvS2NvbmZpZyBiL2RyaXZlcnMvc3RhZ2luZy9LY29uZmlnCmluZGV4IGIy
MmY3M2Q3YmZjNC4uYjA3ZGUzOWI5ZjBhIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvS2Nv
bmZpZworKysgYi9kcml2ZXJzL3N0YWdpbmcvS2NvbmZpZwpAQCAtMTEwLDggKzExMCw2IEBAIHNv
dXJjZSAiZHJpdmVycy9zdGFnaW5nL3FsZ2UvS2NvbmZpZyIKIAogc291cmNlICJkcml2ZXJzL3N0
YWdpbmcvd2ltYXgvS2NvbmZpZyIKIAotc291cmNlICJkcml2ZXJzL3N0YWdpbmcvd2Z4L0tjb25m
aWciCi0KIHNvdXJjZSAiZHJpdmVycy9zdGFnaW5nL2hpa2V5OXh4L0tjb25maWciCiAKIGVuZGlm
ICMgU1RBR0lORwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL01ha2VmaWxlIGIvZHJpdmVy
cy9zdGFnaW5nL01ha2VmaWxlCmluZGV4IDIyNDUwNTllNjljNy4uYzZhOTkyZDFlZGQ1IDEwMDY0
NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvTWFrZWZpbGUKKysrIGIvZHJpdmVycy9zdGFnaW5nL01h
a2VmaWxlCkBAIC00NSw1ICs0NSw0IEBAIG9iai0kKENPTkZJR19GSUVMREJVU19ERVYpICAgICAr
PSBmaWVsZGJ1cy8KIG9iai0kKENPTkZJR19LUEMyMDAwKQkJKz0ga3BjMjAwMC8KIG9iai0kKENP
TkZJR19RTEdFKQkJKz0gcWxnZS8KIG9iai0kKENPTkZJR19XSU1BWCkJCSs9IHdpbWF4Lwotb2Jq
LSQoQ09ORklHX1dGWCkJCSs9IHdmeC8KIG9iai15CQkJCSs9IGhpa2V5OXh4LwpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9UT0RPIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9UT0RPCmRl
bGV0ZWQgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAxYjRiYzJhZjk0YjYuLjAwMDAwMDAwMDAwMAot
LS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L1RPRE8KKysrIC9kZXYvbnVsbApAQCAtMSw2ICswLDAg
QEAKLVRoaXMgaXMgYSBsaXN0IG9mIHRoaW5ncyB0aGF0IG5lZWQgdG8gYmUgZG9uZSB0byBnZXQg
dGhpcyBkcml2ZXIgb3V0IG9mIHRoZQotc3RhZ2luZyBkaXJlY3RvcnkuCi0KLSAgLSBBcyBzdWdn
ZXN0ZWQgYnkgRmVsaXgsIHJhdGUgY29udHJvbCBjb3VsZCBiZSBpbXByb3ZlZCBmb2xsb3dpbmcg
dGhpcyBpZGVhOgotICAgICAgICBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzMwOTk1NTku
Z3YzUTc1S25OMUBwYy00Mi8KLQotLSAKMi4yOS4yCgo=
