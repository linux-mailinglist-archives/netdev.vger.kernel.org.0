Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5822A687B
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731300AbgKDPy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:54:27 -0500
Received: from mail-dm6nam11on2049.outbound.protection.outlook.com ([40.107.223.49]:54240
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731266AbgKDPyP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 10:54:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UvWD87n1MVPYCX6+xsct9j516n3xQVHnXClT5uwG3vhu/wG4ghdOH6zMoBA4CC/8gm7nFFqn4pJWj0YtjzQakWSbOZW/Hq3uzX2JozjF5nWIobCKJj/ykc+oRoqYUS+Wgh3EBA5EqPuLmyrvBDHm+Pgq5IfV1qjOaFOAxk3DUtd9pnxyThJ6tiv6LBx1t5fv84abU9T0X7II+s4DrxKkYQdnlL53jT3p7e9CMBmEWPUSuWsPLs+ylHJ9RA4E7tV/BRdUI7AlXfgQ0J1X0/IbrtCpp9eLb8J4YaTMkd/IrGBlokibaNUURN30W+kd+Ti55GLYZYq0Pvb2HjOyyuSGKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QHkeHzcJ6PVGT+kLjG4uoiPAi3jxgyaFA7pQqVd8RkQ=;
 b=nF5TPsZIaby6ivBlou+wZMQ8LoIHpuXfYsNszBHSGHntHfRew99BgTe51W6E92zotpWTwTi+GBce5SdSYntoN89U0cKL5jCYd4LXVoi+8q3M6utkrvpdKo2c7WVQRzUcT6ZZreQhGMClQxVs5AmpLbbNTyL8yIAp0r5gVA7hq8LuGVpMqCqjCZtoIdhBYqaVdyaqpySYHwLtZCAhWXj/YcqO0Ov+k/CoaRYzB4nWPapsp98FzjUvMKBfZO/p9kVW+CYuz65ABIujXvBliTiJANTzkIL8XUxMCioFmSEndLHrS7RNt7S0JGki6PHIkd0bN89xitvjpEiiLgqdqolEBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QHkeHzcJ6PVGT+kLjG4uoiPAi3jxgyaFA7pQqVd8RkQ=;
 b=eueQG5OwkveQix5ZJoUnTugYh7U3RxqAF0+58Us6AKGMvdehzpnC7yc3qJwAVxi36s+r185EEQYYcU2cAJ5GfdNaDQCxZK6XXdRE9vF9eQineAX8F3TdJ6jUJ53X/l7B4QSIr0J0hl86pYxz38ljEZtFadEeD1XA9jJH63W1eQY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.32; Wed, 4 Nov
 2020 15:53:16 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 15:53:16 +0000
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
Subject: [PATCH v3 24/24] wfx: get out from the staging area
Date:   Wed,  4 Nov 2020 16:52:07 +0100
Message-Id: <20201104155207.128076-25-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SN6PR01CA0032.prod.exchangelabs.com (2603:10b6:805:b6::45)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR01CA0032.prod.exchangelabs.com (2603:10b6:805:b6::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Wed, 4 Nov 2020 15:53:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e731604c-1baa-45be-e81e-08d880d9be57
X-MS-TrafficTypeDiagnostic: SN6PR11MB2718:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB27189C25BDCC64DD5471AA6493EF0@SN6PR11MB2718.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xTDyyUfo+WXsbLt3d58yNdlesSOF2CXdUvGmgmk2n01yMZL0qyHlvwjk5ghIIdVKStlhuyn1UilxOpezechhT0r5VsFGhPS2ryRQFmczyoPJdKCJ0evv1OsRTM+kLEboVXQYvG+SaEF1pIhFuQiQpJUvokqVK4OIIbhem+J4kUwVD76gqH/NawOPMe2iXWfTkEjKUZuLDyZsDV3kc5MgVU/zvEZJhsubNyV/Swan0oUoCVqAcbjTflqEEsPt4Cj6NfDGL7QROPXpPxHalu4FSP3n9ypcURxskjeRJekgZ/rltbuSRtG2vgzJZx7y3Z1J6ugugKXxDtYHCVbSEahmgORFdFscpeABq7Vthfw+sCtqsqX1g+nvsrj4HPbly+Nj5m9Ywhyn+LinoFB4GVyoxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39850400004)(136003)(396003)(8936002)(966005)(478600001)(186003)(16526019)(956004)(2616005)(6486002)(8676002)(66574015)(66476007)(66556008)(66946007)(316002)(7696005)(6666004)(83380400001)(26005)(54906003)(107886003)(36756003)(52116002)(7416002)(4326008)(5660300002)(86362001)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fI2rH/vACQ3E8y8ZinqfCULlwm3NqXKJ7L1viKzReUUOru50ZKJ7a7ZSymKZLMBjVP1N+oQNBwhFqJzQdNXAHrypGmlXDY0Mr7s8gsF4ydmEtYcv5qBP5c9yf7I+5ZvAxemRE5xQ5xGppbMv2xTJVFjRG9OrIp1UZb7l3vyjIFa5vT5ejqzUsR/mD094WeFxEQSJ9FvlT2rj1PQg2ch3UOgxJwFxKPab98hm1iqHRRO2ktvj5k29yPq07qg9R8oJbAuShRBG1vm1gaxtAmRoeIjQJDIYP/6UeFW0iCSkySMhM131XiInoW3gGufQxZQMDSzgo43qTMVTSI1ON9Au9l7hkrW1ZtWUAaaB8GN1I6XQ6vbixm4hdLc7RLk0melTFvp8OHpyAoY6vW5alsYpMu71rHhoGDhwWy14MjJKTKTDmy1QH4+ug9DCx0dcrAf1eNJ+lF19fcyUFoKZ6seKR6x6vSbssxBlqIB8y4+DP9VKfqjSPmR9lI/09/8DIR0mLhBBd/K5eZKrADPp3MfmzzY7iiwz8i3eUE5R/SfMHWL1qT2pzHPaAYcUqZJlG2xemRcVS466kKqRnKTDnfFwze5fBd4yMW1gE3M3IW5ODuUkzXkAXgSbkPidDkCMMdaTfguYLivcN3JkzDgrKWpqOQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e731604c-1baa-45be-e81e-08d880d9be57
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2020 15:53:16.5084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dbT+TmTyU67nq44d+ZoK7rNpWVaPbKCKM+CikG7Zy4Ppbvc6A9+3nYqT+erI3rbMtaTWtf2j3aDMN2VU+y5gxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2718
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
TlRBSU5FUlMgYi9NQUlOVEFJTkVSUwppbmRleCA2ZDRiODBkZTE0MDYuLjRiZjljNDE3MGQzMyAx
MDA2NDQKLS0tIGEvTUFJTlRBSU5FUlMKKysrIGIvTUFJTlRBSU5FUlMKQEAgLTE1OTQ2LDcgKzE1
OTQ2LDggQEAgRjoJZHJpdmVycy9wbGF0Zm9ybS94ODYvdG91Y2hzY3JlZW5fZG1pLmMKIFNJTElD
T04gTEFCUyBXSVJFTEVTUyBEUklWRVJTIChmb3IgV0Z4eHggc2VyaWVzKQogTToJSsOpcsO0bWUg
UG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgogUzoJU3VwcG9ydGVkCi1GOglk
cml2ZXJzL3N0YWdpbmcvd2Z4LworRjoJRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdz
L25ldC93aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwKK0Y6CWRyaXZlcnMvbmV0L3dpcmVsZXNzL3Np
bGFicy93ZngvCiAKIFNJTElDT04gTU9USU9OIFNNNzEyIEZSQU1FIEJVRkZFUiBEUklWRVIKIE06
CVN1ZGlwIE11a2hlcmplZSA8c3VkaXBtLm11a2hlcmplZUBnbWFpbC5jb20+CmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9LY29uZmlnIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvS2Nv
bmZpZwppbmRleCAxNzBhNjRlNjc3MDkuLjY5ZWE4MzI3OTkwNyAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvS2NvbmZpZworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9LY29uZmln
CkBAIC00NCw2ICs0NCw3IEBAIHNvdXJjZSAiZHJpdmVycy9uZXQvd2lyZWxlc3MvbWljcm9jaGlw
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
cml2ZXJzL3N0YWdpbmcvS2NvbmZpZyBiL2RyaXZlcnMvc3RhZ2luZy9LY29uZmlnCmluZGV4IDQ0
M2NhM2YzY2RmMC4uNDM2MzYzYWZmZWE5IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvS2Nv
bmZpZworKysgYi9kcml2ZXJzL3N0YWdpbmcvS2NvbmZpZwpAQCAtMTE2LDggKzExNiw2IEBAIHNv
dXJjZSAiZHJpdmVycy9zdGFnaW5nL3FsZ2UvS2NvbmZpZyIKIAogc291cmNlICJkcml2ZXJzL3N0
YWdpbmcvd2ltYXgvS2NvbmZpZyIKIAotc291cmNlICJkcml2ZXJzL3N0YWdpbmcvd2Z4L0tjb25m
aWciCi0KIHNvdXJjZSAiZHJpdmVycy9zdGFnaW5nL2hpa2V5OXh4L0tjb25maWciCiAKIGVuZGlm
ICMgU1RBR0lORwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL01ha2VmaWxlIGIvZHJpdmVy
cy9zdGFnaW5nL01ha2VmaWxlCmluZGV4IGRjNDUxMjhlZjUyNS4uY2JmZDA1MjQ3NTVhIDEwMDY0
NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvTWFrZWZpbGUKKysrIGIvZHJpdmVycy9zdGFnaW5nL01h
a2VmaWxlCkBAIC00OCw1ICs0OCw0IEBAIG9iai0kKENPTkZJR19GSUVMREJVU19ERVYpICAgICAr
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
Z3YzUTc1S25OMUBwYy00Mi8KLQotLSAKMi4yOC4wCgo=
