Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDF12514D6
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgHYJAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:00:08 -0400
Received: from mail-bn8nam11on2079.outbound.protection.outlook.com ([40.107.236.79]:20448
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729698AbgHYI7w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 04:59:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eNmZyHti2awJ+PjzQxAtPTTIfO7sAVKwaBpcNzj2Ijiecmr9Xwsu+UwE88Jl4hVCCUK3rR8FjLP9Z1py9piA6xEuI9OKN0roTYKlbCBJNIZcyRFjVskZ5Sh08Xq7Kzrc9PXHDBgm1AVOVQLg/OWPzu9jL6bKA0jl86LQl5Di/M186XYJ5D9LsURT340m8uJH6Ml1fq/DDIdt2jc17Zvw/dG2kswbyO1GQtxXBUUu4U2z5XiW25cw95UQav0bQ1x3KcLCvFbfNxBtTAQsqCqpjydEF1Q7W9y6PnrQHbWbguX4uDU539PEQL1bgtMcuQbX+3CPT534z2JfTqB6tqK4hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnx1LDN0uuuMoQM1TsWcaSizN1CAv69/PathJt1c3xk=;
 b=RaWMdu4U3iswcJ73dFLC64Yi9LuoBJE9j2iilKI/4VEXZ89+FnVD8LIs3J0iwmoeRRdTewQNTk/koVDFF4yakfOAYrSTsD/UH06W9I/b79lcl6EV81r30SOQ/8DqW3R8wMKo6Sa/ouqKPvLCAgiaGgoy6gbaQwpDbjYyB+zAITBju6hPukxqNCHThSRUEJRmt4D3antA2e7K1IHa7LI2DrS8niXw7WcrVQd+KQJTk++jLyN4VfxtYsif+gRUaYIvayY7qNkiq1AU3JcUI0AU4PolS/Y1veKnGf2E90pTAdCAOB7yjd5WWLu0k0XRt61j4DYSmaZOVFiNxeI8FZQvqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnx1LDN0uuuMoQM1TsWcaSizN1CAv69/PathJt1c3xk=;
 b=i6F8LNj57OsC6J/OakfmsQF1ibeUlh0I0c/sDXdMHHwdBlMiYWu2SNrZ9y7CAOf7LG9nFKhCP/XfrSJmPeO6sx2mDg+hsd3dlG/SJG7dLBfej8NIjHPHssSJYVq4Q181ncYuZUhkoYBP5ehx1++j8LXgta8ODz5yAehuTfBl7m0=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3501.namprd11.prod.outlook.com (2603:10b6:805:d4::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Tue, 25 Aug
 2020 08:59:14 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 08:59:13 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 12/12] staging: wfx: add workaround for 'timeout while wake up chip'
Date:   Tue, 25 Aug 2020 10:58:28 +0200
Message-Id: <20200825085828.399505-12-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200825085828.399505-1-Jerome.Pouiller@silabs.com>
References: <20200825085828.399505-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P192CA0002.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::7) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by PR3P192CA0002.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Tue, 25 Aug 2020 08:59:12 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba1e38ea-2b63-42b1-221e-08d848d523a5
X-MS-TrafficTypeDiagnostic: SN6PR11MB3501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3501FFD4064F33C7CCADA1EF93570@SN6PR11MB3501.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NDtufFFnrsC2nvuLCjdQZBRtM5Aft7Q5C61avkj29Wyj5j3xwrtoJiz+K+6UyGu07O3KKGKdimPdYF4iBxfREmHhplnb/MCuRQGfk9jpC2PNteSh87Kd0aiUBpHdiVWlfvwv6W5u6cOPaPxeYRo8MpdPVsd9z4NvPDtgFHSaNu2VlXtQkcmJFaA40hF6wReQpGISbLpeVqsyhCW2rJRtP41eX1VJtt1vhoBFnD+TjCnxUngBKEWNRnlKu6kjmr5g279tDp7lfM49CBpMMaugDIo+G0k04R1YfwyaOAcgu2FskejVMGlbDs4rhLCsO+No/cWHm/pKlS78enOS29ETCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39840400004)(396003)(346002)(376002)(366004)(316002)(5660300002)(478600001)(107886003)(1076003)(8936002)(83380400001)(16576012)(956004)(66556008)(66476007)(26005)(2616005)(186003)(8676002)(86362001)(66946007)(6486002)(54906003)(6666004)(36756003)(4326008)(66574015)(2906002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: f13mqyYVwoQjkqKO41tGA5hckam2pEE7ev+Iv9Hfyen6aNsC1fLIm0DBQaL5LwiE+wCZtM50LaPaab95HL4D7eT6ukCf2djvvsRx6zRU/ONuHbJSErg4ixZVdTjvGdNgITNjD5/NeD7QwZG0DE/Bpn2ofoq3E6GbaKwMwFgHonwKNmrJoDmUNZVBh1VzNvmKgk5qkzO2W3zuR9JFjdrH41EqNyfetZTzPMoOPzulhPekNBCtf91KzX0FVRpTQPc3+gxPrwoW0V1CgP2i/+D/fs7B6RVlNMi3XvGhOTQxap+MmFNrqjHJGVvY6AiSoSY+AR2ezNvapRPuTUzuXR26LifqPvhUlRQTQt6jlJuK6zhNPpQTTibFtmjI/ATvsbNrGbQsR9AAUlpa6nC32XIYCNFBzY1TPqAN7ZnShpU4A5WEh5NcRJKgneJ45hE3g6mKAXdcd5pFPwYCrTh3z2qglm7E2DiPushyZMdkdRC8TnlUi63Yh1ocY3QKJ5n60/8q6LYabohk88ggl5+fnvhWyaJWeFk153CeVuNCL3jumkrxzO95+3QJdr1/0xjNtYr3vpDBOg69KJBgaOT0qLeXS078lChuste+Mz7XkD6Jz1okoU4a/kOVS/aYDVpWZf5CMa248VMlpTCokQ88+I3Plg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba1e38ea-2b63-42b1-221e-08d848d523a5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 08:59:13.8102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NZBmieBIdOohjB5kZQvBpvFzvAzZMnlJLbv2+1Ml3felXp7EyZ+Qj3vrijhfb7eMys6QXDKWm51DS9ChJjgqwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3501
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGhvc3QgYW5kIHRoZSBkZXZpY2UgY2FuIGJlIGNvbm5lY3RlZCB3aXRoIGEgY2FsbGVkIFdha2Ut
VXAgR1BJTy4KV2hlbiB0aGUgaG9zdCBmYWxsIGRvd24gdGhpcyBHUElPLCBpdCBhbGxvd3MgdGhl
IGRldmljZSB0byBlbnRlciBpbiBkZWVwCnNsZWVwIGFuZCBubyBjb21tdW5pY2F0aW9uIHdpdGgg
dGhlIGRldmljZSBpcyBubyBtb3JlIHBvc3NpYmxlICh0aGUKZGV2aWNlIHdha2VzIHVwIGF1dG9t
YXRpY2FsbHkgb24gRFRJTSBhbmQgZmV0Y2ggZGF0YSBpZiBuZWNlc3NhcnkpLgoKU28sIGJlZm9y
ZSB0byBjb21tdW5pY2F0ZSB3aXRoIHRoZSBkZXZpY2UsIHRoZSBkcml2ZXIgaGF2ZSB0byByYWlz
ZSB0aGUKV2FrZS11cCBHUElPIGFuZCB0aGVuIHdhaXQgZm9yIGFuIElSUSBmcm9tIHRoZSBkZXZp
Y2UuCgpVbmZvcnR1bmF0ZWx5LCBvbGQgZmlybXdhcmVzIGhhdmUgYSByYWNlIGluIHNsZWVwL3dh
a2UtdXAgcHJvY2VzcyBhbmQKdGhlIGRldmljZSBtYXkgbmV2ZXIgd2FrZSB1cC4gSW4gdGhpcyBj
YXNlLCB0aGUgSVJRIGlzIG5vdCBzZW50IGFuZApkcml2ZXIgY29tcGxhaW5zIHdpdGggInRpbWVv
dXQgd2hpbGUgd2FrZSB1cCBjaGlwIi4gVGhlbiwgdGhlIGRyaXZlcgp0cmllcyBhbnl3YXkgdG8g
YWNjZXNzIHRoZSBidXMgYW5kIGFuIG90aGVyIGVycm9yIGlzIHJhaXNlZCBieSB0aGUgYnVzLgoK
Rm9ydHVuYXRlbHksIHdoZW4gdGhlIGJ1ZyBvY2N1cnMsIGl0IGlzIHBvc3NpYmxlIHRvIGZhbGwg
ZG93biB0aGUgSVJRCmFuZCB0aGUgZGV2aWNlIHdpbGwgZXZlbnR1YWxseSBmaW5pc2ggdGhlIHNs
ZWVwIHByb2Nlc3MuIFRoZW4gdGhlIGRyaXZlcgpjYW4gd2FrZSBpdCB1cCBub3JtYWxseS4KClRo
ZSBwYXRjaCBpbXBsZW1lbnRzIHRoYXQgd29ya2Fyb3VuZCBhbmQgYWRkIGEgcmV0cnkgbGltaXQg
aW4gY2FzZQpzb21ldGhpbmcgZ29lcyB2ZXJ5IHdyb25nLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0
bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3Rh
Z2luZy93ZngvYmguYyB8IDIzICsrKysrKysrKysrKysrKysrKystLS0tCiAxIGZpbGUgY2hhbmdl
ZCwgMTkgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2JoLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmMKaW5kZXggMDczMDRh
ODBjMjliLi5mMDdiY2VlNTBlM2YgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvYmgu
YworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmMKQEAgLTE4LDI1ICsxOCw0MCBAQAogCiBz
dGF0aWMgdm9pZCBkZXZpY2Vfd2FrZXVwKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogeworCWludCBt
YXhfcmV0cnkgPSAzOworCiAJaWYgKCF3ZGV2LT5wZGF0YS5ncGlvX3dha2V1cCkKIAkJcmV0dXJu
OwogCWlmIChncGlvZF9nZXRfdmFsdWVfY2Fuc2xlZXAod2Rldi0+cGRhdGEuZ3Bpb193YWtldXAp
KQogCQlyZXR1cm47CiAKLQlncGlvZF9zZXRfdmFsdWVfY2Fuc2xlZXAod2Rldi0+cGRhdGEuZ3Bp
b193YWtldXAsIDEpOwogCWlmICh3ZnhfYXBpX29sZGVyX3RoYW4od2RldiwgMSwgNCkpIHsKKwkJ
Z3Bpb2Rfc2V0X3ZhbHVlX2NhbnNsZWVwKHdkZXYtPnBkYXRhLmdwaW9fd2FrZXVwLCAxKTsKIAkJ
aWYgKCFjb21wbGV0aW9uX2RvbmUoJndkZXYtPmhpZi5jdHJsX3JlYWR5KSkKIAkJCXVzbGVlcF9y
YW5nZSgyMDAwLCAyNTAwKTsKLQl9IGVsc2UgeworCQlyZXR1cm47CisJfQorCWZvciAoOzspIHsK
KwkJZ3Bpb2Rfc2V0X3ZhbHVlX2NhbnNsZWVwKHdkZXYtPnBkYXRhLmdwaW9fd2FrZXVwLCAxKTsK
IAkJLy8gY29tcGxldGlvbi5oIGRvZXMgbm90IHByb3ZpZGUgYW55IGZ1bmN0aW9uIHRvIHdhaXQK
IAkJLy8gY29tcGxldGlvbiB3aXRob3V0IGNvbnN1bWUgaXQgKGEga2luZCBvZgogCQkvLyB3YWl0
X2Zvcl9jb21wbGV0aW9uX2RvbmVfdGltZW91dCgpKS4gU28gd2UgaGF2ZSB0byBlbXVsYXRlCiAJ
CS8vIGl0LgogCQlpZiAod2FpdF9mb3JfY29tcGxldGlvbl90aW1lb3V0KCZ3ZGV2LT5oaWYuY3Ry
bF9yZWFkeSwKLQkJCQkJCW1zZWNzX3RvX2ppZmZpZXMoMikpKQorCQkJCQkJbXNlY3NfdG9famlm
ZmllcygyKSkpIHsKIAkJCWNvbXBsZXRlKCZ3ZGV2LT5oaWYuY3RybF9yZWFkeSk7Ci0JCWVsc2UK
KwkJCXJldHVybjsKKwkJfSBlbHNlIGlmIChtYXhfcmV0cnktLSA+IDApIHsKKwkJCS8vIE9sZGVy
IGZpcm13YXJlcyBoYXZlIGEgcmFjZSBpbiBzbGVlcC93YWtlLXVwIHByb2Nlc3MuCisJCQkvLyBS
ZWRvIHRoZSBwcm9jZXNzIGlzIHN1ZmZpY2llbnQgdG8gdW5mcmVlemUgdGhlCisJCQkvLyBjaGlw
LgogCQkJZGV2X2Vycih3ZGV2LT5kZXYsICJ0aW1lb3V0IHdoaWxlIHdha2UgdXAgY2hpcFxuIik7
CisJCQlncGlvZF9zZXRfdmFsdWVfY2Fuc2xlZXAod2Rldi0+cGRhdGEuZ3Bpb193YWtldXAsIDAp
OworCQkJdXNsZWVwX3JhbmdlKDIwMDAsIDI1MDApOworCQl9IGVsc2UgeworCQkJZGV2X2Vycih3
ZGV2LT5kZXYsICJtYXggd2FrZS11cCByZXRyaWVzIHJlYWNoZWRcbiIpOworCQkJcmV0dXJuOwor
CQl9CiAJfQogfQogCi0tIAoyLjI4LjAKCg==
