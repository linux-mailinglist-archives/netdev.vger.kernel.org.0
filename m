Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6409B2A6890
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730960AbgKDPwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:52:47 -0500
Received: from mail-eopbgr750080.outbound.protection.outlook.com ([40.107.75.80]:6126
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730902AbgKDPwn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 10:52:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dz5xtnQY7duxWoJQ3f0MemnwJi0TF6D9BsfUE7tkuSji52AKzSQyyNlOD8QTEhKL/I1XkiLrXB79I9RsKr8vU+EQiulTmh4or62Q49/eNOCtZps2atSI16EpcfDpRFrLlDTM8A9REG4MyRnPN/YbybBTfuRrwOXxH0777z88ZC+RbvlOu2suiUxlxeC06D0zZDvRIuMGsdKIPxjwHrPGvoia3Gsvx8pbVTLNFvulsSrY2KLFYww7ofGbH2uPUr9gIh54AKrCi4+4i5FSAnAKsO2u5ICnlwIXHLUmZMWX+nHaKQDItzDi1YgGu2mVk7Mi44fSAK5rCBZt1y8p+7x2EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqZzTE5IDNzLeiEeh0gtmEhR+vjHmPP5GDL6eBo8e3g=;
 b=dKojzDNmS0h61w+Sx7dL0+bbNr2lgYe/Jer942106yocaeubV5qf915GYUgT3aaxSOHiuSXx2Ak1lGvSSBKEqYXmBMBe+Pw5lqa5ACt5kgPqsIgRDZYyj4DZ2U+IqsuORbN3IgDh8ZVgbGEXYq6gC7LQDRGRgRr62EhrXc51oQ3q8Jd5hTKQfxWRcLnQavcI/UnG8CONBVlET1C2SPfzh9tIe9++jwZ8hj8lIsfsYpJ+h6N0GGqxADYg7LtkD81wUIb6J9iJMtIQORuUQ1NPr4pw3v0ho2bYmfrabgncfyHqjW5wOFwsdh6dAFGFWAyob3aMJK8rieZfWT1bzmkiSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqZzTE5IDNzLeiEeh0gtmEhR+vjHmPP5GDL6eBo8e3g=;
 b=k5xTDQqQKRzTqf09CUZOo3tWiXzFWmVv6HrsphD7lX++WnWD3mFvwzdZuNC4NN1t0PDt+0DnyqxgeypD2Wx7+hCMgm4OEXAAS1qtwkfheGAfD6KC5viMdS0/+3BLMsvlpX4hYHPV5OD+v9vaJyYNYMlIIqrvD+pldHGOUoy/Scc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.32; Wed, 4 Nov
 2020 15:52:30 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 15:52:30 +0000
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
Subject: [PATCH v3 04/24] wfx: add wfx.h
Date:   Wed,  4 Nov 2020 16:51:47 +0100
Message-Id: <20201104155207.128076-5-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR01CA0032.prod.exchangelabs.com (2603:10b6:805:b6::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Wed, 4 Nov 2020 15:52:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ccbe006-9698-4641-046a-08d880d9a319
X-MS-TrafficTypeDiagnostic: SN6PR11MB2718:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB27187C7E81521D3A1079A9B793EF0@SN6PR11MB2718.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0EqOFdNV57tC2chAktkH9xgxrYlhl8KA45kkMdwIDrttojIp8rLKcFCcL54+caEDoYFWOXUm3mCVcQXpSnPL+x5GVN9cQyQ6xRSzuDKz2Li3ilA3xM2lcrWPMXVam7MbXidaSYw3ILc0Mxr0TBGmRxnlqJ1Y7OrAu7YZ5T1LYTRxFvSBvyDGuhhc0BBRb+DnNirflXq7UtKd7nRuIP2lY5k/jVJC8zHIqUw4Xm6CFrkHGoS9+1q4Gu/C12w08LqD8Mi5fNVYkgt+x+2KQcyjt6sINxttYXQjqgGoT/hbW+26o7kPr3M4mwn8di6s8kzz1i0gxG1v5RXq3PHzinsTAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39850400004)(136003)(396003)(8936002)(478600001)(186003)(16526019)(956004)(2616005)(6486002)(8676002)(66574015)(66476007)(66556008)(66946007)(316002)(7696005)(6666004)(83380400001)(26005)(54906003)(107886003)(36756003)(52116002)(7416002)(4326008)(5660300002)(86362001)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: niaEZNHaAlb2+hWr39boGlhA8GhTpmKp1eZwKeASDWhIKduNexhAM7oc8udrNcw8NQp75obtbT2prpDsNprYimWW/BXUnhTm+ZtZ4mXcZ50D5zUiO6IDa+V19wG+KRo2Avrs7ArNFJwoyIj2FjN8+HjH2WfJ0mw/jWcA8PvNLJLGoowCoDVYccbK2icsSjbNH88VuAzrn4DM3NSrBWqH9U6yUi+W2gtfrus3pUUm9/w5Zq4k3tLC2EJekEOjU3Gwh7ufT3gEDX7x+R5NSWZx9Bs/Qw5p+qetU7sCg71Q4dOnA8EJU33yQL4YTEWtDv2aJVFLbcziBaZ+xrW6pUUffxupuW6J6NGjsMy25HR9IL1A2LV7zI2HZ7Q5u/OR9/pT5tAbBLWkNnmZFIQC3WYDoKk+6DGSW8lS5xX2Y+wPFm1/FxWYQU7kB1HmzO6k0RiA0noQzBUuBlm+yS7R05p4DZF273qor3O+vn71fBUHTlHwiLjYHNeaILMpX8P33MSwGlLia32d04t68zTGBHmboIZHZkSYy2iW2TDMVnjgd1uT5t7mtsKUIrPC/96q6HJ6PKrszPD8uFYCQyW1kIq22l2rIEa/LzSqD24WK376wAirwRfFzKe3SgHp8AlxvD6DMvQM9vdljpZzjxOTRZ+8OQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ccbe006-9698-4641-046a-08d880d9a319
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2020 15:52:30.7628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JHwR/jmY+tDIlLU2x8pUVvtwEW8B6v2EgDq20KNvgfiUSfRva5Cb6i/yBdJY9hDjItlMOJLoeuba/q0RsbVOyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2718
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
bmRleCAwMDAwMDAwMDAwMDAuLjk0ODk4NjgwY2NkZQotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZl
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
MiAvLyBzZWUgc3RydWN0IGllZWU4MDIxMV90eF9xdWV1ZV9wYXJhbXMKKyNkZWZpbmUgVVNFQ19Q
RVJfVFUgMTAyNAorCitzdHJ1Y3QgaHdidXNfb3BzOworCitzdHJ1Y3Qgd2Z4X2RldiB7CisJc3Ry
dWN0IHdmeF9wbGF0Zm9ybV9kYXRhIHBkYXRhOworCXN0cnVjdCBkZXZpY2UJCSpkZXY7CisJc3Ry
dWN0IGllZWU4MDIxMV9odwkqaHc7CisJc3RydWN0IGllZWU4MDIxMV92aWYJKnZpZlsyXTsKKwlz
dHJ1Y3QgbWFjX2FkZHJlc3MJYWRkcmVzc2VzWzJdOworCWNvbnN0IHN0cnVjdCBod2J1c19vcHMJ
Kmh3YnVzX29wczsKKwl2b2lkCQkJKmh3YnVzX3ByaXY7CisKKwl1OAkJCWtleXNldDsKKwlzdHJ1
Y3QgY29tcGxldGlvbglmaXJtd2FyZV9yZWFkeTsKKwlzdHJ1Y3QgaGlmX2luZF9zdGFydHVwCWh3
X2NhcHM7CisJc3RydWN0IHdmeF9oaWYJCWhpZjsKKwlzdHJ1Y3QgZGVsYXllZF93b3JrCWNvb2xp
bmdfdGltZW91dF93b3JrOworCWJvb2wJCQlwb2xsX2lycTsKKwlib29sCQkJY2hpcF9mcm96ZW47
CisJc3RydWN0IG11dGV4CQljb25mX211dGV4OworCisJc3RydWN0IHdmeF9oaWZfY21kCWhpZl9j
bWQ7CisJc3RydWN0IHNrX2J1ZmZfaGVhZAl0eF9wZW5kaW5nOworCXdhaXRfcXVldWVfaGVhZF90
CXR4X2RlcXVldWU7CisJYXRvbWljX3QJCXR4X2xvY2s7CisKKwlhdG9taWNfdAkJcGFja2V0X2lk
OworCXUzMgkJCWtleV9tYXA7CisKKwlzdHJ1Y3QgaGlmX3J4X3N0YXRzCXJ4X3N0YXRzOworCXN0
cnVjdCBtdXRleAkJcnhfc3RhdHNfbG9jazsKKwlzdHJ1Y3QgaGlmX3R4X3Bvd2VyX2xvb3BfaW5m
byB0eF9wb3dlcl9sb29wX2luZm87CisJc3RydWN0IG11dGV4CQl0eF9wb3dlcl9sb29wX2luZm9f
bG9jazsKKwlpbnQJCQlmb3JjZV9wc190aW1lb3V0OworfTsKKworc3RydWN0IHdmeF92aWYgewor
CXN0cnVjdCB3ZnhfZGV2CQkqd2RldjsKKwlzdHJ1Y3QgaWVlZTgwMjExX3ZpZgkqdmlmOworCXN0
cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAqY2hhbm5lbDsKKwlpbnQJCQlpZDsKKworCXUzMgkJCWxp
bmtfaWRfbWFwOworCisJYm9vbAkJCWFmdGVyX2R0aW1fdHhfYWxsb3dlZDsKKwlib29sCQkJam9p
bl9pbl9wcm9ncmVzczsKKworCXN0cnVjdCBkZWxheWVkX3dvcmsJYmVhY29uX2xvc3Nfd29yazsK
KworCXN0cnVjdCB3ZnhfcXVldWUJdHhfcXVldWVbNF07CisJc3RydWN0IHR4X3BvbGljeV9jYWNo
ZQl0eF9wb2xpY3lfY2FjaGU7CisJc3RydWN0IHdvcmtfc3RydWN0CXR4X3BvbGljeV91cGxvYWRf
d29yazsKKworCXN0cnVjdCB3b3JrX3N0cnVjdAl1cGRhdGVfdGltX3dvcms7CisKKwl1bnNpZ25l
ZCBsb25nCQl1YXBzZF9tYXNrOworCisJLyogYXZvaWQgc29tZSBvcGVyYXRpb25zIGluIHBhcmFs
bGVsIHdpdGggc2NhbiAqLworCXN0cnVjdCBtdXRleAkJc2Nhbl9sb2NrOworCXN0cnVjdCB3b3Jr
X3N0cnVjdAlzY2FuX3dvcms7CisJc3RydWN0IGNvbXBsZXRpb24Jc2Nhbl9jb21wbGV0ZTsKKwli
b29sCQkJc2Nhbl9hYm9ydDsKKwlzdHJ1Y3QgaWVlZTgwMjExX3NjYW5fcmVxdWVzdCAqc2Nhbl9y
ZXE7CisKKwlzdHJ1Y3QgY29tcGxldGlvbglzZXRfcG1fbW9kZV9jb21wbGV0ZTsKK307CisKK3N0
YXRpYyBpbmxpbmUgc3RydWN0IHdmeF92aWYgKndkZXZfdG9fd3ZpZihzdHJ1Y3Qgd2Z4X2RldiAq
d2RldiwgaW50IHZpZl9pZCkKK3sKKwlpZiAodmlmX2lkID49IEFSUkFZX1NJWkUod2Rldi0+dmlm
KSkgeworCQlkZXZfZGJnKHdkZXYtPmRldiwgInJlcXVlc3Rpbmcgbm9uLWV4aXN0ZW50IHZpZjog
JWRcbiIsIHZpZl9pZCk7CisJCXJldHVybiBOVUxMOworCX0KKwl2aWZfaWQgPSBhcnJheV9pbmRl
eF9ub3NwZWModmlmX2lkLCBBUlJBWV9TSVpFKHdkZXYtPnZpZikpOworCWlmICghd2Rldi0+dmlm
W3ZpZl9pZF0pIHsKKwkJZGV2X2RiZyh3ZGV2LT5kZXYsICJyZXF1ZXN0aW5nIG5vbi1hbGxvY2F0
ZWQgdmlmOiAlZFxuIiwKKwkJCXZpZl9pZCk7CisJCXJldHVybiBOVUxMOworCX0KKwlyZXR1cm4g
KHN0cnVjdCB3ZnhfdmlmICopIHdkZXYtPnZpZlt2aWZfaWRdLT5kcnZfcHJpdjsKK30KKworc3Rh
dGljIGlubGluZSBzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZl9pdGVyYXRlKHN0cnVjdCB3ZnhfZGV2ICp3
ZGV2LAorCQkJCQkgICBzdHJ1Y3Qgd2Z4X3ZpZiAqY3VyKQoreworCWludCBpOworCWludCBtYXJr
ID0gMDsKKwlzdHJ1Y3Qgd2Z4X3ZpZiAqdG1wOworCisJaWYgKCFjdXIpCisJCW1hcmsgPSAxOwor
CWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKHdkZXYtPnZpZik7IGkrKykgeworCQl0bXAgPSB3
ZGV2X3RvX3d2aWYod2RldiwgaSk7CisJCWlmIChtYXJrICYmIHRtcCkKKwkJCXJldHVybiB0bXA7
CisJCWlmICh0bXAgPT0gY3VyKQorCQkJbWFyayA9IDE7CisJfQorCXJldHVybiBOVUxMOworfQor
CitzdGF0aWMgaW5saW5lIGludCB3dmlmX2NvdW50KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQorewor
CWludCBpOworCWludCByZXQgPSAwOworCXN0cnVjdCB3ZnhfdmlmICp3dmlmOworCisJZm9yIChp
ID0gMDsgaSA8IEFSUkFZX1NJWkUod2Rldi0+dmlmKTsgaSsrKSB7CisJCXd2aWYgPSB3ZGV2X3Rv
X3d2aWYod2RldiwgaSk7CisJCWlmICh3dmlmKQorCQkJcmV0Kys7CisJfQorCXJldHVybiByZXQ7
Cit9CisKK3N0YXRpYyBpbmxpbmUgdm9pZCBtZW1yZXZlcnNlKHU4ICpzcmMsIHU4IGxlbmd0aCkK
K3sKKwl1OCAqbG8gPSBzcmM7CisJdTggKmhpID0gc3JjICsgbGVuZ3RoIC0gMTsKKwl1OCBzd2Fw
OworCisJd2hpbGUgKGxvIDwgaGkpIHsKKwkJc3dhcCA9ICpsbzsKKwkJKmxvKysgPSAqaGk7CisJ
CSpoaS0tID0gc3dhcDsKKwl9Cit9CisKK3N0YXRpYyBpbmxpbmUgaW50IG1lbXpjbXAodm9pZCAq
c3JjLCB1bnNpZ25lZCBpbnQgc2l6ZSkKK3sKKwl1OCAqYnVmID0gc3JjOworCisJaWYgKCFzaXpl
KQorCQlyZXR1cm4gMDsKKwlpZiAoKmJ1ZikKKwkJcmV0dXJuIDE7CisJcmV0dXJuIG1lbWNtcChi
dWYsIGJ1ZiArIDEsIHNpemUgLSAxKTsKK30KKworI2VuZGlmIC8qIFdGWF9IICovCi0tIAoyLjI4
LjAKCg==
