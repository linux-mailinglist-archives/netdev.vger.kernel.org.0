Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD47D2E1E5D
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 16:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbgLWPkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 10:40:42 -0500
Received: from mail-bn8nam08on2089.outbound.protection.outlook.com ([40.107.100.89]:24001
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727207AbgLWPkl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 10:40:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apuCMTC0OzNzdiEGILbS+ab6q1Z2MUfuuPQTzHllr/zfy0TYwRWMWMl4BndJ+EMeKdFOcBDnQJxWFf9LKtMuPT2ePvwHF/m8MJVpSyHEuebs4dYSnMVxRQHVRIXa5JZJW+xIKs+l8sCPQmLrW8g0k+eE2Tdmcz+8jkhsMBGAWlqlidKOq8ggC7vKSQuSuxWfYePXv9e0yswt2XRKvevdKrVP1swa3N/vi8z6RD7hZLpKux34BekUKtb1EH1NbH3TRbHTcLE77sVfkbViLrF6+PWL8fvXrkM2VyY7ZoWpKyJAgzeyiKoVzJYN0ZKnWaPcVnJUkXfwezNrlebUbQvTnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlJLsY164WWvmoTBLBUBuep23vf/XWqb2IwXXhLjjfg=;
 b=ABmJh3Nf34ZQGFcVYKR7h45MHcJ6TRQ/cBP1M1cTOOeyr8+SS0XOJtZlRP8xlhQ664kEAH//DUiil86gW1k2wiA4tzoojGmZKe4PBp7qSq6YpXNcDtJstBycKnDRpFfbTICSBN/94fWemzH1I+ny7L4rpaJ+Cn1W334hwmRMuQ7z0Pj2XlmEkoAK2iPYFIuL/MwZ92Hu7Ti0h7a+dzOXZJGYv7QoYhjjdmPpkw2CaXdikpsyOGdRQ7yd0XmiN9nmgPq93wQbAPSMMkg/kPR2ssXDoo1hKnjTvaKNRXH1S+0LdLUTFCH8rXY8toQoFjm/WPVzs2xZTWs2k2lARtJfyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlJLsY164WWvmoTBLBUBuep23vf/XWqb2IwXXhLjjfg=;
 b=D1T+wuG6GOHyRlMuYB3WxqPUM0jRSMTsmVQ9DZASBR7oHpNWWiuv9229DlJrszy8dRrl5pgM3BK+gD/k33yfY+wirJK3hMjdLOe39JxGzof2nrOx+uIB0N4d86x5nomGrfF695n8faB9tnqYZNVsvD53GNjBSeE9HDj44NYyh+g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4543.namprd11.prod.outlook.com (2603:10b6:806:99::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29; Wed, 23 Dec
 2020 15:39:52 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca%5]) with mapi id 15.20.3700.026; Wed, 23 Dec 2020
 15:39:52 +0000
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
Subject: [PATCH v4 04/24] wfx: add wfx.h
Date:   Wed, 23 Dec 2020 16:39:05 +0100
Message-Id: <20201223153925.73742-5-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (82.67.86.106) by SA0PR12CA0024.namprd12.prod.outlook.com (2603:10b6:806:6f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Wed, 23 Dec 2020 15:39:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7476314c-d4cf-424c-64ec-08d8a758fd54
X-MS-TrafficTypeDiagnostic: SA0PR11MB4543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB454309B9DCC136988AA3792693DE0@SA0PR11MB4543.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tYMUtQAKt0m4TGrhW5+dMoGIvKUT7yscVBxyQiB3qhAXU7eq/uO2SNMu+u1um+faLxN38VeXoRtLX3elzacUBwzydzks266yh5uNB7OUvTdIgzxznZl0ckg9hsZb6NyuzwHtD8HXaaVOzVvvz7mxQVMR6X0ncH8iauprjiS2mioPslZj2OXnAco+S7cI/7nGcFcOypiGIBpUwWXRNR+OtJi/+qhTqZ1+62zEdRymKDWXX6oU6Zp/I3RZZ1FU4gllAY/dXDNLp1J46XnB20ozsfTU8egKmtZMrtez1RxnqSVJvUBzKALczGFFb4zLWLp2JO54KrkTWplKAMiqfbEz0rXxKY4pkBl9Dhrh3jAsIxb+Hx6MiDMpQr6rF/OYnO7v9SZIXTS8Cireah/xBV4AGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(346002)(396003)(39850400004)(5660300002)(956004)(2616005)(66476007)(66556008)(86362001)(36756003)(107886003)(66574015)(66946007)(6486002)(4326008)(83380400001)(6666004)(8676002)(186003)(52116002)(16526019)(7416002)(478600001)(26005)(1076003)(316002)(7696005)(54906003)(8936002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SUFWdjlpdU5KQXQyOTgxTnBhM0hJSHpCemJUV1pjdVZZQ0R5NzBrNmpiSmpy?=
 =?utf-8?B?RThLc0JiSXpFVkI3K3NIa0Z5RlYwWDd3T1JGczFXakY0MUdzN3lxd280K0l3?=
 =?utf-8?B?bXNZQnJPbUwxNk92SG1PZ09WYTh2T0dCeWZDRnUvT2x0ZmVqVHN3Rk1wbjgz?=
 =?utf-8?B?UTNuM1lXcEYySUVhMVhaTURvd2VHQVZ6Qm5PcVlRTGEyTi9aWHltd2cxYVo3?=
 =?utf-8?B?ZkZFR3NIR3NkdXY5Y0x6YW9IYkxlNXhQQVhCbUlOZ2RLalROTzFQL0lCNWhW?=
 =?utf-8?B?NzdreWxpNVVuckpQRERVWTlXNitYaXVPMGJVWHVhRnlKMDVDUWF2UTl1ak5y?=
 =?utf-8?B?R0p6RVBkcnVXb3lnZHA3ODhhOW4vZ0llWjY5NlA0RldEK1FIY00rQXlkTXU2?=
 =?utf-8?B?S3lJUHFSeGUrQVkrWjhvUStscFI1TXh5eW5Uc25VdlVqN1FhKzEvMUsrTGlC?=
 =?utf-8?B?UTZlbnVaVzNCQVJKQkpwdVRyV1FPZmlhYWdoRXljUUZoOFV2c09zSDJGdDRT?=
 =?utf-8?B?eWdwUkJQdGNDT1VqbDBCOWhrZEFCWUk3TEZ6UGxaUk1oc1pvWjBEbjllYWhT?=
 =?utf-8?B?NjJOOENmUjlmVUZKTEh3VWgvRWVlRGh6MHBIQ3RJRVh6TjJ4QTZlc2FVUE82?=
 =?utf-8?B?WUpONnpjUkMvUFpmMHY4bnVpZVF5MW9oNzZiQ3FWTXk1d1h6TXNHUGVrU0tG?=
 =?utf-8?B?b25wQmJoVFhhN3VUYkJwcXlNMjFkOWgxWThocWttY1E0QVpUbHhBVU1nTFhy?=
 =?utf-8?B?SEgzdkwxcmlwLzJnaTFWeDNGbEhsb2xYT0lyUmNnb3Q4R0RzcUR4ckIyWTNn?=
 =?utf-8?B?MWtudGZtQnJhVlcxc3NremdITXJHLzNyV2IxWEVhTWRReG1hY3VBNXJTTHpU?=
 =?utf-8?B?MC9uL0Nlc00reFY1aXB2RU9DTzY5RWc4Ynd4Sjg2anB2MHZHUlVZRkFKQll0?=
 =?utf-8?B?Z0R5Nk9US3JZUXRmeGNUdkV0M09qVzVObzZyNFUwYzlSV04rNWhPbDBVMUxS?=
 =?utf-8?B?MENYVHZYNmdKSnZDWS9qR0p2bENkdlFPUjVSWE1JdVRYQjVvOGkzVENPeDNr?=
 =?utf-8?B?M0plY3QwdVZxQ0xtZ3BEZGk3UHZ4d3NmaGREbVlqU3JKQ2dHakNnMm8xVW5v?=
 =?utf-8?B?RTRFQkEwN0o3dzhoelRUVTdoMVNSSWZac0dLVmEyampEblhPZ21UaWlxczk5?=
 =?utf-8?B?OVJYay9xeHZJb1VzVSt1Q0tlUmJEd0doZW1nTVNDa05kVExlZExTQlJzK0dh?=
 =?utf-8?B?ODNBQmw1N3dsRWpuYWtETzRmcDIwSnZDdEptMEFNT0dtWDBibWo2UGx0TWVB?=
 =?utf-8?Q?9A77RtCHhWRTLtkQVbpKamZlylhmIV3mHx?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2020 15:39:52.0773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-Network-Message-Id: 7476314c-d4cf-424c-64ec-08d8a758fd54
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WuyXglvkJUGYdX/tOTlCr80iELYixsINm7+rRlyGRH8zwtRjOBzBC1IKjzwdsNTAH19uSBnhqDIxXqLbGAmb+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4543
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmggfCAxNjYgKysrKysr
KysrKysrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxNjYgaW5zZXJ0aW9ucygrKQog
Y3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmgK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L3dmeC5oIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC93ZnguaApuZXcgZmlsZSBtb2RlIDEwMDY0NApp
bmRleCAwMDAwMDAwMDAwMDAuLmJhMThiYmZhY2QyYgotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3NpbGFicy93Zngvd2Z4LmgKQEAgLTAsMCArMSwxNjYgQEAKKy8qIFNQ
RFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkgKi8KKy8qCisgKiBDb21tb24gcHJp
dmF0ZSBkYXRhIGZvciBTaWxpY29uIExhYnMgV0Z4IGNoaXBzLgorICoKKyAqIENvcHlyaWdodCAo
YykgMjAxNy0yMDIwLCBTaWxpY29uIExhYm9yYXRvcmllcywgSW5jLgorICogQ29weXJpZ2h0IChj
KSAyMDEwLCBTVC1Fcmljc3NvbgorICogQ29weXJpZ2h0IChjKSAyMDA2LCBNaWNoYWVsIFd1IDxm
bGFtaW5naWNlQHNvdXJtaWxrLm5ldD4KKyAqIENvcHlyaWdodCAyMDA0LTIwMDYgSmVhbi1CYXB0
aXN0ZSBOb3RlIDxqYm5vdGVAZ21haWwuY29tPiwgZXQgYWwuCisgKi8KKyNpZm5kZWYgV0ZYX0gK
KyNkZWZpbmUgV0ZYX0gKKworI2luY2x1ZGUgPGxpbnV4L2NvbXBsZXRpb24uaD4KKyNpbmNsdWRl
IDxsaW51eC93b3JrcXVldWUuaD4KKyNpbmNsdWRlIDxsaW51eC9tdXRleC5oPgorI2luY2x1ZGUg
PGxpbnV4L25vc3BlYy5oPgorI2luY2x1ZGUgPG5ldC9tYWM4MDIxMS5oPgorCisjaW5jbHVkZSAi
YmguaCIKKyNpbmNsdWRlICJkYXRhX3R4LmgiCisjaW5jbHVkZSAibWFpbi5oIgorI2luY2x1ZGUg
InF1ZXVlLmgiCisjaW5jbHVkZSAiaGlmX3R4LmgiCisKKyNkZWZpbmUgVVNFQ19QRVJfVFhPUCAz
MiAvKiBzZWUgc3RydWN0IGllZWU4MDIxMV90eF9xdWV1ZV9wYXJhbXMgKi8KKyNkZWZpbmUgVVNF
Q19QRVJfVFUgMTAyNAorCitzdHJ1Y3QgaHdidXNfb3BzOworCitzdHJ1Y3Qgd2Z4X2RldiB7CisJ
c3RydWN0IHdmeF9wbGF0Zm9ybV9kYXRhIHBkYXRhOworCXN0cnVjdCBkZXZpY2UJCSpkZXY7CisJ
c3RydWN0IGllZWU4MDIxMV9odwkqaHc7CisJc3RydWN0IGllZWU4MDIxMV92aWYJKnZpZlsyXTsK
KwlzdHJ1Y3QgbWFjX2FkZHJlc3MJYWRkcmVzc2VzWzJdOworCWNvbnN0IHN0cnVjdCBod2J1c19v
cHMJKmh3YnVzX29wczsKKwl2b2lkCQkJKmh3YnVzX3ByaXY7CisKKwl1OAkJCWtleXNldDsKKwlz
dHJ1Y3QgY29tcGxldGlvbglmaXJtd2FyZV9yZWFkeTsKKwlzdHJ1Y3QgaGlmX2luZF9zdGFydHVw
CWh3X2NhcHM7CisJc3RydWN0IHdmeF9oaWYJCWhpZjsKKwlzdHJ1Y3QgZGVsYXllZF93b3JrCWNv
b2xpbmdfdGltZW91dF93b3JrOworCWJvb2wJCQlwb2xsX2lycTsKKwlib29sCQkJY2hpcF9mcm96
ZW47CisJc3RydWN0IG11dGV4CQljb25mX211dGV4OworCisJc3RydWN0IHdmeF9oaWZfY21kCWhp
Zl9jbWQ7CisJc3RydWN0IHNrX2J1ZmZfaGVhZAl0eF9wZW5kaW5nOworCXdhaXRfcXVldWVfaGVh
ZF90CXR4X2RlcXVldWU7CisJYXRvbWljX3QJCXR4X2xvY2s7CisKKwlhdG9taWNfdAkJcGFja2V0
X2lkOworCXUzMgkJCWtleV9tYXA7CisKKwlzdHJ1Y3QgaGlmX3J4X3N0YXRzCXJ4X3N0YXRzOwor
CXN0cnVjdCBtdXRleAkJcnhfc3RhdHNfbG9jazsKKwlzdHJ1Y3QgaGlmX3R4X3Bvd2VyX2xvb3Bf
aW5mbyB0eF9wb3dlcl9sb29wX2luZm87CisJc3RydWN0IG11dGV4CQl0eF9wb3dlcl9sb29wX2lu
Zm9fbG9jazsKKwlpbnQJCQlmb3JjZV9wc190aW1lb3V0OworfTsKKworc3RydWN0IHdmeF92aWYg
eworCXN0cnVjdCB3ZnhfZGV2CQkqd2RldjsKKwlzdHJ1Y3QgaWVlZTgwMjExX3ZpZgkqdmlmOwor
CXN0cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAqY2hhbm5lbDsKKwlpbnQJCQlpZDsKKworCXUzMgkJ
CWxpbmtfaWRfbWFwOworCisJYm9vbAkJCWFmdGVyX2R0aW1fdHhfYWxsb3dlZDsKKwlib29sCQkJ
am9pbl9pbl9wcm9ncmVzczsKKworCXN0cnVjdCBkZWxheWVkX3dvcmsJYmVhY29uX2xvc3Nfd29y
azsKKworCXN0cnVjdCB3ZnhfcXVldWUJdHhfcXVldWVbNF07CisJc3RydWN0IHR4X3BvbGljeV9j
YWNoZQl0eF9wb2xpY3lfY2FjaGU7CisJc3RydWN0IHdvcmtfc3RydWN0CXR4X3BvbGljeV91cGxv
YWRfd29yazsKKworCXN0cnVjdCB3b3JrX3N0cnVjdAl1cGRhdGVfdGltX3dvcms7CisKKwl1bnNp
Z25lZCBsb25nCQl1YXBzZF9tYXNrOworCisJLyogYXZvaWQgc29tZSBvcGVyYXRpb25zIGluIHBh
cmFsbGVsIHdpdGggc2NhbiAqLworCXN0cnVjdCBtdXRleAkJc2Nhbl9sb2NrOworCXN0cnVjdCB3
b3JrX3N0cnVjdAlzY2FuX3dvcms7CisJc3RydWN0IGNvbXBsZXRpb24Jc2Nhbl9jb21wbGV0ZTsK
Kwlib29sCQkJc2Nhbl9hYm9ydDsKKwlzdHJ1Y3QgaWVlZTgwMjExX3NjYW5fcmVxdWVzdCAqc2Nh
bl9yZXE7CisKKwlzdHJ1Y3QgY29tcGxldGlvbglzZXRfcG1fbW9kZV9jb21wbGV0ZTsKK307CisK
K3N0YXRpYyBpbmxpbmUgc3RydWN0IHdmeF92aWYgKndkZXZfdG9fd3ZpZihzdHJ1Y3Qgd2Z4X2Rl
diAqd2RldiwgaW50IHZpZl9pZCkKK3sKKwlpZiAodmlmX2lkID49IEFSUkFZX1NJWkUod2Rldi0+
dmlmKSkgeworCQlkZXZfZGJnKHdkZXYtPmRldiwgInJlcXVlc3Rpbmcgbm9uLWV4aXN0ZW50IHZp
ZjogJWRcbiIsIHZpZl9pZCk7CisJCXJldHVybiBOVUxMOworCX0KKwl2aWZfaWQgPSBhcnJheV9p
bmRleF9ub3NwZWModmlmX2lkLCBBUlJBWV9TSVpFKHdkZXYtPnZpZikpOworCWlmICghd2Rldi0+
dmlmW3ZpZl9pZF0pIHsKKwkJZGV2X2RiZyh3ZGV2LT5kZXYsICJyZXF1ZXN0aW5nIG5vbi1hbGxv
Y2F0ZWQgdmlmOiAlZFxuIiwKKwkJCXZpZl9pZCk7CisJCXJldHVybiBOVUxMOworCX0KKwlyZXR1
cm4gKHN0cnVjdCB3ZnhfdmlmICopIHdkZXYtPnZpZlt2aWZfaWRdLT5kcnZfcHJpdjsKK30KKwor
c3RhdGljIGlubGluZSBzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZl9pdGVyYXRlKHN0cnVjdCB3ZnhfZGV2
ICp3ZGV2LAorCQkJCQkgICBzdHJ1Y3Qgd2Z4X3ZpZiAqY3VyKQoreworCWludCBpOworCWludCBt
YXJrID0gMDsKKwlzdHJ1Y3Qgd2Z4X3ZpZiAqdG1wOworCisJaWYgKCFjdXIpCisJCW1hcmsgPSAx
OworCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKHdkZXYtPnZpZik7IGkrKykgeworCQl0bXAg
PSB3ZGV2X3RvX3d2aWYod2RldiwgaSk7CisJCWlmIChtYXJrICYmIHRtcCkKKwkJCXJldHVybiB0
bXA7CisJCWlmICh0bXAgPT0gY3VyKQorCQkJbWFyayA9IDE7CisJfQorCXJldHVybiBOVUxMOwor
fQorCitzdGF0aWMgaW5saW5lIGludCB3dmlmX2NvdW50KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQor
eworCWludCBpOworCWludCByZXQgPSAwOworCXN0cnVjdCB3ZnhfdmlmICp3dmlmOworCisJZm9y
IChpID0gMDsgaSA8IEFSUkFZX1NJWkUod2Rldi0+dmlmKTsgaSsrKSB7CisJCXd2aWYgPSB3ZGV2
X3RvX3d2aWYod2RldiwgaSk7CisJCWlmICh3dmlmKQorCQkJcmV0Kys7CisJfQorCXJldHVybiBy
ZXQ7Cit9CisKK3N0YXRpYyBpbmxpbmUgdm9pZCBtZW1yZXZlcnNlKHU4ICpzcmMsIHU4IGxlbmd0
aCkKK3sKKwl1OCAqbG8gPSBzcmM7CisJdTggKmhpID0gc3JjICsgbGVuZ3RoIC0gMTsKKwl1OCBz
d2FwOworCisJd2hpbGUgKGxvIDwgaGkpIHsKKwkJc3dhcCA9ICpsbzsKKwkJKmxvKysgPSAqaGk7
CisJCSpoaS0tID0gc3dhcDsKKwl9Cit9CisKK3N0YXRpYyBpbmxpbmUgaW50IG1lbXpjbXAodm9p
ZCAqc3JjLCB1bnNpZ25lZCBpbnQgc2l6ZSkKK3sKKwl1OCAqYnVmID0gc3JjOworCisJaWYgKCFz
aXplKQorCQlyZXR1cm4gMDsKKwlpZiAoKmJ1ZikKKwkJcmV0dXJuIDE7CisJcmV0dXJuIG1lbWNt
cChidWYsIGJ1ZiArIDEsIHNpemUgLSAxKTsKK30KKworI2VuZGlmCi0tIAoyLjI5LjIKCg==
