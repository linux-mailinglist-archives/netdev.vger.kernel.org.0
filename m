Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F673293CA2
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 15:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407184AbgJTNBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 09:01:16 -0400
Received: from mail-bn7nam10on2070.outbound.protection.outlook.com ([40.107.92.70]:55456
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406935AbgJTM7b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 08:59:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBKrxSNFByEuXlR4jVMkNk+iBR6/jGqwzdG7CBRuN4PfvynaFuRxstTirL3RQeo/+oXj6VRP69c/Ct5dile2hJ6U8oCE9Lf2X+TxEyekUg3fcpeuGjXklgaDmmourReb6bqQc/cWL8RuRLojCKoaDrmyd/Jeqf0O1bqVVTqOKND4Uvwag1rmH7cpzhf8AX4U5jb8m/B3aZ4P+2FhVH52iUsBH3EMqHsDSrS7DN6XxDk47muBYDSyNoM0KyyCuchRcLGbRyWTDLM+RAosAxFHpkUdy0M7KHccm3+YVHIq2u8b2l+4xq3XGPkq88sISsdddAd+LokFTV/AuqxYgvcL8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edc12fpY37LlQK8Q6v4oXf+Qq4aIaiABOQkqEIdKP7k=;
 b=PzTeEfyyDMVZ9iZJH4K7JjBTI41Bgx8qV8H7qtyO1D9nv9YgBjWawIJiIgYiO7x7UDdWzbAxdGKpsOmWSRKspIMjMYlzBIBJnD0VrehVsVWP64XZR8ljTwk01HzZ13sGyeW6xjqXqtQVo965umZXz+S+9/XqhB+k3TIlNcJUGSIhgGQ0LnSXzCcu8SFB2OcgAA1n9/zG8/gK9eH0eygeofue/4ZpTc5RgH8kG+enO6NBl3HQSykj8rRGONgxbTA66fSmvuHhT7MDzqii+7OYy6Huzo2QJ0itwqRSoWKAX3nRiiqWSBn+ctoIw044AF4tuYZpBd1ygVz5APEfVe9lBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edc12fpY37LlQK8Q6v4oXf+Qq4aIaiABOQkqEIdKP7k=;
 b=O1LJv+gYWViv67UrGW9esi+OKxZ0up9LXHBePOxXVl52oe0y1a//NImUp/zkAjFxngcvbCdxQkkf0EOG6gvfYf36T/9kDs6SzCHIbGQ+BpJmSqFW+fSn1ynzc3V+ugOxf3zXXxr0sIp2evC+cklydUog8D6OxBBkMFMbpTCycWY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3040.namprd11.prod.outlook.com (2603:10b6:805:db::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Tue, 20 Oct
 2020 12:59:19 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 12:59:19 +0000
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
Subject: [PATCH v2 16/24] wfx: add data_rx.c/data_rx.h
Date:   Tue, 20 Oct 2020 14:58:09 +0200
Message-Id: <20201020125817.1632995-17-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (37.71.187.125) by PR3P192CA0026.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 12:59:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12f95308-7941-4fcb-f079-08d874f7f527
X-MS-TrafficTypeDiagnostic: SN6PR11MB3040:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3040C00E9556F83483E6C1DE931F0@SN6PR11MB3040.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KcRdqoqU/0iaI68W2msOF8BaReA07LU8fcpgyMokzstvlmxbmfKIpV0z7fFHtoK4cnM4DKmS2F05ATSdDid9yO83RNv2bRgVoR9A8828UItvWM/iv7YSzOZO3AvejWB36gBxFEsn2lzPXxNmFPW0IqyTuLlY2Jwx8hSDwgeBVikWreVIqjZ4gaZGt212p6IIRw2pHZB7onOiAmL6iyDx7ogOsSW7S5q9kWHViEgkyWaiqBlWJP7r5TG/PExM7VjJSQF9gY9I7KHXni+ir4UDNYWLgBPICMN6XBuqTFWRd4cgtjNfs95ZAczgTFwiA2+Y/ks3jmaBt5tx6HUe45UVrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(136003)(366004)(39840400004)(4326008)(5660300002)(54906003)(478600001)(83380400001)(86362001)(316002)(1076003)(2906002)(186003)(6486002)(16526019)(7696005)(66556008)(7416002)(36756003)(26005)(8676002)(66476007)(52116002)(66946007)(107886003)(956004)(2616005)(6666004)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: feuMRTDd/sILu7mqCxcs8u0jHWg2zyhSJ4YJJEZ+fa1B5vxnp90M68olorI4FTnTpS9ZTANJPOt6A40OXN5DqITX1PMRW/5eOufibhCSYvRCE5aIjiRoQdAoxSMhOr/omKfLm4G1FKC51w+QY27OcWrDkWXGk+ttYxLV7P0wZuAToEn4ta5XHnwAoYpizAHgiHQwAzH8iAUx2GtAARsNSebjaNo2ko4fwZaw96wxpo47f/bcoLVwnUsmnDO9NQJ308/aIleDn5ySYd3k6qSUgDiMAJ827XBnuijtwHTDrPQxjICxrLyqVO73Z2+hfUpeFEEgnHiKz8i2WLObHwen1E4/ZVOrFhjZLPSCvR7XILHBaTzg6J1lJNAxm5KU4e1meUTXveA0/RjQrQXSJkXWE+9Y/ke7jNkgjokxtvvs1Mt+xof96Mfz9aq+PfNsAmdwRt53dpl5GRn0EVJqXmVU2GN1MX1byDpivm9zM6wRlfqb/EYBjrFunniL+Ehv8rwQEvR8q5yV4e7qjSociz/tNBy9ki4aaP6HssoiY4FqPa4ZCwzlIw5468ZIUaMAo15L3cn0J1P5yzCz1Qksfc8aQWvwKmR1nDi4bEd+8XDz2rDT/aVo4uJ0ECgrNR4hyoDAiYFVM6UyfDrR4DRB5TLu1w==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12f95308-7941-4fcb-f079-08d874f7f527
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 12:59:19.6711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hMeY4tFNvoaziDbf6IIPCT5qSdObHyNZy6zo2S+CvOGXVv/J/grBdSLIXCx2bu+NFUpd6lzUOuteaYqlfmy4Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5jIHwgOTMgKysr
KysrKysrKysrKysrKysrKysrKysKIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0
YV9yeC5oIHwgMTggKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgMTExIGluc2VydGlvbnMoKykKIGNy
ZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcngu
YwogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0
YV9yeC5oCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9kYXRh
X3J4LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcnguYwpuZXcgZmls
ZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLjM4NWYyZDQyYTBlMgotLS0gL2Rldi9u
dWxsCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5jCkBAIC0w
LDAgKzEsOTMgQEAKKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkKKy8q
CisgKiBEYXRhcGF0aCBpbXBsZW1lbnRhdGlvbi4KKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTct
MjAyMCwgU2lsaWNvbiBMYWJvcmF0b3JpZXMsIEluYy4KKyAqIENvcHlyaWdodCAoYykgMjAxMCwg
U1QtRXJpY3Nzb24KKyAqLworI2luY2x1ZGUgPGxpbnV4L2V0aGVyZGV2aWNlLmg+CisjaW5jbHVk
ZSA8bmV0L21hYzgwMjExLmg+CisKKyNpbmNsdWRlICJkYXRhX3J4LmgiCisjaW5jbHVkZSAid2Z4
LmgiCisjaW5jbHVkZSAiYmguaCIKKyNpbmNsdWRlICJzdGEuaCIKKworc3RhdGljIHZvaWQgd2Z4
X3J4X2hhbmRsZV9iYShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IGllZWU4MDIxMV9tZ210
ICptZ210KQoreworCWludCBwYXJhbXMsIHRpZDsKKworCWlmICh3ZnhfYXBpX29sZGVyX3RoYW4o
d3ZpZi0+d2RldiwgMywgNikpCisJCXJldHVybjsKKworCXN3aXRjaCAobWdtdC0+dS5hY3Rpb24u
dS5hZGRiYV9yZXEuYWN0aW9uX2NvZGUpIHsKKwljYXNlIFdMQU5fQUNUSU9OX0FEREJBX1JFUToK
KwkJcGFyYW1zID0gbGUxNl90b19jcHUobWdtdC0+dS5hY3Rpb24udS5hZGRiYV9yZXEuY2FwYWIp
OworCQl0aWQgPSAocGFyYW1zICYgSUVFRTgwMjExX0FEREJBX1BBUkFNX1RJRF9NQVNLKSA+PiAy
OworCQlpZWVlODAyMTFfc3RhcnRfcnhfYmFfc2Vzc2lvbl9vZmZsKHd2aWYtPnZpZiwgbWdtdC0+
c2EsIHRpZCk7CisJCWJyZWFrOworCWNhc2UgV0xBTl9BQ1RJT05fREVMQkE6CisJCXBhcmFtcyA9
IGxlMTZfdG9fY3B1KG1nbXQtPnUuYWN0aW9uLnUuZGVsYmEucGFyYW1zKTsKKwkJdGlkID0gKHBh
cmFtcyAmICBJRUVFODAyMTFfREVMQkFfUEFSQU1fVElEX01BU0spID4+IDEyOworCQlpZWVlODAy
MTFfc3RvcF9yeF9iYV9zZXNzaW9uX29mZmwod3ZpZi0+dmlmLCBtZ210LT5zYSwgdGlkKTsKKwkJ
YnJlYWs7CisJfQorfQorCit2b2lkIHdmeF9yeF9jYihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKKwkg
ICAgICAgY29uc3Qgc3RydWN0IGhpZl9pbmRfcnggKmFyZywgc3RydWN0IHNrX2J1ZmYgKnNrYikK
K3sKKwlzdHJ1Y3QgaWVlZTgwMjExX3J4X3N0YXR1cyAqaGRyID0gSUVFRTgwMjExX1NLQl9SWENC
KHNrYik7CisJc3RydWN0IGllZWU4MDIxMV9oZHIgKmZyYW1lID0gKHN0cnVjdCBpZWVlODAyMTFf
aGRyICopc2tiLT5kYXRhOworCXN0cnVjdCBpZWVlODAyMTFfbWdtdCAqbWdtdCA9IChzdHJ1Y3Qg
aWVlZTgwMjExX21nbXQgKilza2ItPmRhdGE7CisKKwltZW1zZXQoaGRyLCAwLCBzaXplb2YoKmhk
cikpOworCisJaWYgKGFyZy0+c3RhdHVzID09IEhJRl9TVEFUVVNfUlhfRkFJTF9NSUMpCisJCWhk
ci0+ZmxhZyB8PSBSWF9GTEFHX01NSUNfRVJST1IgfCBSWF9GTEFHX0lWX1NUUklQUEVEOworCWVs
c2UgaWYgKGFyZy0+c3RhdHVzKQorCQlnb3RvIGRyb3A7CisKKwlpZiAoc2tiLT5sZW4gPCBzaXpl
b2Yoc3RydWN0IGllZWU4MDIxMV9wc3BvbGwpKSB7CisJCWRldl93YXJuKHd2aWYtPndkZXYtPmRl
diwgIm1hbGZvcm1lZCBTRFUgcmVjZWl2ZWRcbiIpOworCQlnb3RvIGRyb3A7CisJfQorCisJaGRy
LT5iYW5kID0gTkw4MDIxMV9CQU5EXzJHSFo7CisJaGRyLT5mcmVxID0gaWVlZTgwMjExX2NoYW5u
ZWxfdG9fZnJlcXVlbmN5KGFyZy0+Y2hhbm5lbF9udW1iZXIsCisJCQkJCQkgICBoZHItPmJhbmQp
OworCisJaWYgKGFyZy0+cnhlZF9yYXRlID49IDE0KSB7CisJCWhkci0+ZW5jb2RpbmcgPSBSWF9F
TkNfSFQ7CisJCWhkci0+cmF0ZV9pZHggPSBhcmctPnJ4ZWRfcmF0ZSAtIDE0OworCX0gZWxzZSBp
ZiAoYXJnLT5yeGVkX3JhdGUgPj0gNCkgeworCQloZHItPnJhdGVfaWR4ID0gYXJnLT5yeGVkX3Jh
dGUgLSAyOworCX0gZWxzZSB7CisJCWhkci0+cmF0ZV9pZHggPSBhcmctPnJ4ZWRfcmF0ZTsKKwl9
CisKKwlpZiAoIWFyZy0+cmNwaV9yc3NpKSB7CisJCWhkci0+ZmxhZyB8PSBSWF9GTEFHX05PX1NJ
R05BTF9WQUw7CisJCWRldl9pbmZvKHd2aWYtPndkZXYtPmRldiwgInJlY2VpdmVkIGZyYW1lIHdp
dGhvdXQgUlNTSSBkYXRhXG4iKTsKKwl9CisJaGRyLT5zaWduYWwgPSBhcmctPnJjcGlfcnNzaSAv
IDIgLSAxMTA7CisJaGRyLT5hbnRlbm5hID0gMDsKKworCWlmIChhcmctPmVuY3J5cCkKKwkJaGRy
LT5mbGFnIHw9IFJYX0ZMQUdfREVDUllQVEVEOworCisJLy8gQmxvY2sgYWNrIG5lZ290aWF0aW9u
IGlzIG9mZmxvYWRlZCBieSB0aGUgZmlybXdhcmUuIEhvd2V2ZXIsCisJLy8gcmUtb3JkZXJpbmcg
bXVzdCBiZSBkb25lIGJ5IHRoZSBtYWM4MDIxMS4KKwlpZiAoaWVlZTgwMjExX2lzX2FjdGlvbihm
cmFtZS0+ZnJhbWVfY29udHJvbCkgJiYKKwkgICAgbWdtdC0+dS5hY3Rpb24uY2F0ZWdvcnkgPT0g
V0xBTl9DQVRFR09SWV9CQUNLICYmCisJICAgIHNrYi0+bGVuID4gSUVFRTgwMjExX01JTl9BQ1RJ
T05fU0laRSkgeworCQl3ZnhfcnhfaGFuZGxlX2JhKHd2aWYsIG1nbXQpOworCQlnb3RvIGRyb3A7
CisJfQorCisJaWVlZTgwMjExX3J4X2lycXNhZmUod3ZpZi0+d2Rldi0+aHcsIHNrYik7CisJcmV0
dXJuOworCitkcm9wOgorCWRldl9rZnJlZV9za2Ioc2tiKTsKK30KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5oIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3Mvc2lsYWJzL3dmeC9kYXRhX3J4LmgKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAw
MDAwMDAwLi40YzBkYTM3ZjIwODQKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL25ldC93aXJl
bGVzcy9zaWxhYnMvd2Z4L2RhdGFfcnguaApAQCAtMCwwICsxLDE4IEBACisvKiBTUERYLUxpY2Vu
c2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5ICovCisvKgorICogRGF0YXBhdGggaW1wbGVtZW50
YXRpb24uCisgKgorICogQ29weXJpZ2h0IChjKSAyMDE3LTIwMjAsIFNpbGljb24gTGFib3JhdG9y
aWVzLCBJbmMuCisgKiBDb3B5cmlnaHQgKGMpIDIwMTAsIFNULUVyaWNzc29uCisgKi8KKyNpZm5k
ZWYgV0ZYX0RBVEFfUlhfSAorI2RlZmluZSBXRlhfREFUQV9SWF9ICisKK3N0cnVjdCB3Znhfdmlm
Oworc3RydWN0IHNrX2J1ZmY7CitzdHJ1Y3QgaGlmX2luZF9yeDsKKwordm9pZCB3ZnhfcnhfY2Io
c3RydWN0IHdmeF92aWYgKnd2aWYsCisJICAgICAgIGNvbnN0IHN0cnVjdCBoaWZfaW5kX3J4ICph
cmcsIHN0cnVjdCBza19idWZmICpza2IpOworCisjZW5kaWYgLyogV0ZYX0RBVEFfUlhfSCAqLwot
LSAKMi4yOC4wCgo=
