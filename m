Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEECD293C77
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 15:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407072AbgJTM75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 08:59:57 -0400
Received: from mail-dm6nam12on2042.outbound.protection.outlook.com ([40.107.243.42]:21473
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2407002AbgJTM7o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 08:59:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ao8V/ru3BjjpPfUiLebwFNhHrqhU/rGWhVCOVlFWO8hY7q/SNbi7+RCOnyXHPYMejZgoNOLEoms+8HWi8PVu6d9bWbghqfIFDYHL9wOtwDKe7PxOWA6CiHLLrjH5RY0rUY8FtYL6eykOtAWWY9xrJj+GB9aFbp6RhU5z3oVBInb5CVEP/Mhc2e5SojbwBFELJ25g2PH+UR+c24IZT0DcUDifxhYfUQdWj+plrD8x8KP4hA4u2quvkV/bZ0w4FzgjFoWHZ7aKLjEnnPa9a0CCXbCtPQyyTBmVpyYTpsxhm9FEGhAMEBLGFCNw0m2VO2ZclfzPGW3ZwXIIDZ7ZuobsCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QuVX0j6UUCxn+TQOVvQezP9wB7BmuFOYP4LzEze7XgQ=;
 b=VTYZ/V0zbCBVVw2uHBlXFUH4LlV+opglvOkr7ms9nrokILmmcZ7phQGkTaQbwqcHr1EFh1w6l30HfWAFHu5cwj8D2M2MZZz9Xvk8/qNBlIghwHan9mMgabZKy6QjN0vhVDyXPiSTCoYmApd05BRHM4YKEy6pGXOFOeD4b1tbV3J8vM/hvTscTj/40uVcYoCdFxUir/UCmUq0glW10KH71B5JI+GBMZY8FQ+ED2TE2kMkOH8VGcRhUFEjN91LIdCG+D69dntkk6CloHWQlhBfOYdJofGJLeh9CiYHxoG5Kg1F6BnREtVYpaTIpPrOEzVSSmEXEZsCD4Rd8IQkAGaZeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QuVX0j6UUCxn+TQOVvQezP9wB7BmuFOYP4LzEze7XgQ=;
 b=ZYHmmSOwCOKcJXVxLNep7SroCUG3wUmXqof56fZjwYNL9zQA6hwo5FU97AyxJR4oZOlfp7yah8lB2NsrwwQ/EH0B6QZfOK+trTHKawka7Ie8qcao87aNP2JC/lHo49LyPi7VhgJord9+TTD7JbuaSIkYc5rY7b5Dik0D93YbfsY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2656.namprd11.prod.outlook.com (2603:10b6:805:58::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Tue, 20 Oct
 2020 12:59:38 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 12:59:38 +0000
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
Subject: [PATCH v2 24/24] wfx: get out from the staging area
Date:   Tue, 20 Oct 2020 14:58:17 +0200
Message-Id: <20201020125817.1632995-25-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201020125817.1632995-1-Jerome.Pouiller@silabs.com>
References: <20201020125817.1632995-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [37.71.187.125]
X-ClientProxiedBy: PR3P192CA0026.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::31) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR3P192CA0026.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 12:59:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a44a8d9-af32-49ed-9a8f-08d874f800bf
X-MS-TrafficTypeDiagnostic: SN6PR11MB2656:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB265603B62F6CF7410D97B303931F0@SN6PR11MB2656.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vUu05fel1l2HPBYB9VxXYx+QNU8TmAIH6TCIKX69JciBv03EcObhPNU5MrXuETRkn+9soWo/Ybrwht2pL2eSYPrXivTlllT32UldbaUbKeoM19pZUzzJCk8GJH6Zqe2Afygn3Z84C8o36Y0b06srBSkEI3RB61VHG9Znqu00w1EaznJMorMfXeFSJ1X75dw0/boft1Ci8eClGfCuLEh/TzJLk/eSwoWwTmsWdvKxFiF4zKtbgz7Aefaqh+YS01WNfsXaqo3cTAXCdo8IsirLeaMhWUgdqfMD8mJc3GCbGfHKW8VzWNZsiZko79FnKKbV7eWMXFWy5ia6cAYi/t9yDFhvOMlKS+nt+/b4ISXvTLTdzZTn5iBTp2YpuNc05Q5k6CH5TqdAqyvmEC4/DQ51eA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(346002)(376002)(39840400004)(186003)(316002)(4326008)(107886003)(8676002)(86362001)(26005)(2906002)(7696005)(478600001)(16526019)(956004)(6486002)(966005)(52116002)(36756003)(8936002)(2616005)(54906003)(5660300002)(1076003)(7416002)(66574015)(6666004)(66556008)(66476007)(66946007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MDETUYgLqhVJgYZI2HpVbleYSYkLRACTjKAeCqUuBZxojetiz3b6xDK/FHhJ6u1wFuAnT61utqYdhcADrYrQcb5jUruGFYOAayATX4GiW4UHlpeFl0qQTSfAgvy8eqZQXQJvtHnxmRFapGtY9UT+X302EWgi7IJuY7Ta1F5bt+zDZO/cz+zGiJHJuGG75WK4qmgB/HpRFYCCkSrmL/i9ZAZib4UgCX9sP6HSFQqLov53LEYKgHwf5JjWe9MGaZMl+Y8WdOlDv6a/yfvXYbr8/0bY0AffQ/+6737zd7OM89xl7prtSNJ1NbyYQVaeTt1mZmGN9Z7gLQm0hAVjCcAmMCj3PEovLFN1BGFqJZSeXP0bOLojMlWl0oFY77nSWr4K0mwCuwWcQRGRftZ5GuTWDm79AADjE39VKHiUMU+PPvSkOagn3e4pbjPLYpU7cYtt1IJwKkOPpHeDa+NYhCrmv6nu1sP2622qCq1W9lTH/l2pMzYZjmrAKpowJWQ0JG/Ktmx0EkgNZOo/M9kv2v4U2IbInM2Osnpby6Tkczb54ADzjrK0YZcnbYs0nvuaoM3sS2eWgt2N0IsJsssJfElyuI6W4FLRU+h4pOQgn62FiduBARo6olnba8bQz11/pATW9iS4x7kqj/GCDYAmxJxdBQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a44a8d9-af32-49ed-9a8f-08d874f800bf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 12:59:38.7522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gfTChqdfADM3FvvJE+BpHxzE6aBe5gFORAT8UbgI0AtkFICf/QLEmL1txIQxDQm0MBoYkCLKkx3vRiKaLbYaig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2656
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
TlRBSU5FUlMgYi9NQUlOVEFJTkVSUwppbmRleCBiMTU4ZWM0YTVlNDIuLmJjNWRhZTgyMzU3NiAx
MDA2NDQKLS0tIGEvTUFJTlRBSU5FUlMKKysrIGIvTUFJTlRBSU5FUlMKQEAgLTE1OTU2LDcgKzE1
OTU2LDggQEAgRjoJZHJpdmVycy9wbGF0Zm9ybS94ODYvdG91Y2hzY3JlZW5fZG1pLmMKIFNJTElD
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
cml2ZXJzL3N0YWdpbmcvS2NvbmZpZyBiL2RyaXZlcnMvc3RhZ2luZy9LY29uZmlnCmluZGV4IDJk
MDMxMDQ0OGViYS4uMmQzMjZiMTYyNzJlIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvS2Nv
bmZpZworKysgYi9kcml2ZXJzL3N0YWdpbmcvS2NvbmZpZwpAQCAtMTE0LDggKzExNCw2IEBAIHNv
dXJjZSAiZHJpdmVycy9zdGFnaW5nL2twYzIwMDAvS2NvbmZpZyIKIAogc291cmNlICJkcml2ZXJz
L3N0YWdpbmcvcWxnZS9LY29uZmlnIgogCi1zb3VyY2UgImRyaXZlcnMvc3RhZ2luZy93ZngvS2Nv
bmZpZyIKLQogc291cmNlICJkcml2ZXJzL3N0YWdpbmcvaGlrZXk5eHgvS2NvbmZpZyIKIAogZW5k
aWYgIyBTVEFHSU5HCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvTWFrZWZpbGUgYi9kcml2
ZXJzL3N0YWdpbmcvTWFrZWZpbGUKaW5kZXggNzU3YTg5MmFiNWI5Li45ZGUyNjA4MDJkYjUgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy9NYWtlZmlsZQorKysgYi9kcml2ZXJzL3N0YWdpbmcv
TWFrZWZpbGUKQEAgLTQ3LDUgKzQ3LDQgQEAgb2JqLSQoQ09ORklHX1hJTF9BWElTX0ZJRk8pCSs9
IGF4aXMtZmlmby8KIG9iai0kKENPTkZJR19GSUVMREJVU19ERVYpICAgICArPSBmaWVsZGJ1cy8K
IG9iai0kKENPTkZJR19LUEMyMDAwKQkJKz0ga3BjMjAwMC8KIG9iai0kKENPTkZJR19RTEdFKQkJ
Kz0gcWxnZS8KLW9iai0kKENPTkZJR19XRlgpCQkrPSB3ZngvCiBvYmoteQkJCQkrPSBoaWtleTl4
eC8KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvVE9ETyBiL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvVE9ETwpkZWxldGVkIGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMWI0YmMyYWY5NGI2Li4w
MDAwMDAwMDAwMDAKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9UT0RPCisrKyAvZGV2L251bGwK
QEAgLTEsNiArMCwwIEBACi1UaGlzIGlzIGEgbGlzdCBvZiB0aGluZ3MgdGhhdCBuZWVkIHRvIGJl
IGRvbmUgdG8gZ2V0IHRoaXMgZHJpdmVyIG91dCBvZiB0aGUKLXN0YWdpbmcgZGlyZWN0b3J5Lgot
Ci0gIC0gQXMgc3VnZ2VzdGVkIGJ5IEZlbGl4LCByYXRlIGNvbnRyb2wgY291bGQgYmUgaW1wcm92
ZWQgZm9sbG93aW5nIHRoaXMgaWRlYToKLSAgICAgICAgaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
bGttbC8zMDk5NTU5Lmd2M1E3NUtuTjFAcGMtNDIvCi0KLS0gCjIuMjguMAoK
