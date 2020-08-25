Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13E72514CF
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbgHYI7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 04:59:50 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:53959
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729510AbgHYI7X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 04:59:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m5o5QBMnm939ZwuZQ/nH8PTj/d77oFx6ip9IjgU67eOW20uFBaosOY8jhMttZhks3Zv0mYMz3W3RhArIcoH7rrXxQVO7JvfjTr9b1i0juZhAWJlBgZrgBXCZ356CQxOcLsG6KWdRaLxRN3ndu3QEsjX+bi8F+An+P5W09JaBGFcfHbgBvVbqmzpRflbe59dRyTI+YuC+xQDHd1nSOgoUxcCWaDfDqYS8GiACpJK0MI4zTN/uxaIeBcHhMhOJZBv+yIUP5eGOc8ZJy56QdXtIawMEeifA5rN7h/0aaGkHzbO9+KudOP6CIEbeskCkps/20AxWOslmL7zT1lCHwRH9gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQXvApKjr0cY61ggIb8gLuomgp6b/xpqnIfJVhA+1WE=;
 b=Z7kgomi7mgNHeIUBzx2BIchj45ZqLGq7CmE77f57o3IzX9viDiPDUICQjueF2zNw2qJKjvUa9pZOFSprM+agsTqPmDtxi6o4fFL5UoxyrFra0eMe09P3kn/e8AY7gP8/evuPvaeHXCdPbxkpTZye1brccZJPG4XSGywiciTH4lHsnMfJi0Zg12+R93xbrbUUVpoy3rOxxSK0FsutvsjwhD5geryCzN2kj109vWshHDezRv92+2c48VyRvhlrzlLkvr98PV0xKVLxv56mE1hzUyANaWRoytT85tgo63kp67r2qmzz7RDNrR/Sup3E2qljkLf3OYL/xt0Nb2ZarxdB9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQXvApKjr0cY61ggIb8gLuomgp6b/xpqnIfJVhA+1WE=;
 b=NrvyEtqyMu/TY4pjZCWW/9iNKrXBnxVQX3XY6ehSZc4e7gd0a00eg4NXv0l4Q5yT3wal1epIqOLKxGzcjiDILr8fJp5x/XO0I743qg64XD/glzBoiekTphGfMnyfHMOgKu8XuHr7KcSsxohpnXLzMHUA3DcB+z+7paVYi1B7Jqs=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3501.namprd11.prod.outlook.com (2603:10b6:805:d4::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Tue, 25 Aug
 2020 08:59:03 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 08:59:03 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 06/12] staging: wfx: drop useless field from struct wfx_tx_priv
Date:   Tue, 25 Aug 2020 10:58:22 +0200
Message-Id: <20200825085828.399505-6-Jerome.Pouiller@silabs.com>
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
Received: from 255.255.255.255 (255.255.255.255) by PR3P192CA0002.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Tue, 25 Aug 2020 08:59:01 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4145f010-3c68-44e4-6a55-08d848d51d69
X-MS-TrafficTypeDiagnostic: SN6PR11MB3501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3501E65124123FE784F02EF393570@SN6PR11MB3501.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nkXgDtQLlxPEupNHJ+gf4JQpCFo+m4Dioxz6hmaI/wGmLKsikYN7QzFG5FEXVay/TIEZJ3/GS5Og24LEKhX2Wt+4UpgwmOf23kHPYhcpfPrNKgvfhAIUmm0MMlXEHqvUhrwFjXL5fWDKGVDqNCravrAGGvdMUk8GHwwqEkEfo/1kRG8ALaxBlEZbi4c9w/q5Lu9p+NEU966fmh74ToMwH5hhCJ2laAPwYacvoZfqz09V/THzKeLRepTCIa1PIsyOIcetWaUQmvM2G0ThEzNu9ISTEthaxLKqobTyNZGhT2aZa2Ioz7H7MsGPpqfxcSYuECN57xgMedRzHdu6xqsbOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(396003)(346002)(376002)(366004)(316002)(5660300002)(478600001)(107886003)(1076003)(8936002)(83380400001)(16576012)(956004)(66556008)(66476007)(26005)(2616005)(186003)(8676002)(86362001)(66946007)(6486002)(54906003)(6666004)(36756003)(4326008)(66574015)(2906002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dKTEuBi84kABNH/nw3hWQnpQ2vcUqM39dg6KlyM4MZd+SBfnzMdC6lLArOXtskKv5kvuKjaNXgbvlKuDOxx+XiVC/P147uAgMyHHH+/OVT24m7WAqVzLDNyGdBV/7ud8K7bcxETxeVr8LtlahCrXB5W67fkWezjZHYjys7CDwIkVEa0HSBDk5zIeexIdoxDt9gcyRJ0Z2j0ZA+euteVG8Pr229TaYVR/2r0fMsI+Qnq3OtpzyJ4B1cQAjwBd5/C3zKNnOZKkEV5on7XD1+iNYRv64SHXT+7ilQxmS0hngFzrV7mVgdBwEYfIsECuZFyq6gKwOdMX+tDT9/voBEBw6uv0Mvv1NWMD8XJ8N+8dUyrUVZWcBI9bFULmixphkJQVIEIVqP3fciBok6QaGx9zH8otjwfcCTEQSXpDfQwseJgMQjWUaNZX11buI9T9FywWuo4t3/bnpkNlvSx8555Z8bI+X1DjtnLxMCEIh+tBrMp7h2Ftxq7IMID8WYCoSKAivPt/h+JGA2MtmNC4v3V0hovpE+aEd5cHE6dLHXs57vhPpKVAw/uFmg1qpJhulczlF8zYCZKsgkCuW4DiT4suiEpvSuMTQhV2wUvzbUXUS3osLIHb1bUa0b3vxOaWBD1gx2pWtxjFOlBv/pYD6vl/2w==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4145f010-3c68-44e4-6a55-08d848d51d69
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 08:59:03.3545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9J+wo7m+6w4v87i4l2BjIZFKTrBDiRkfppf7NR7M9LeHfXmqN46HRrLLf+7mU/d+3DRRwEhNHsKPTgWVjWkPKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3501
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRldmljZSBuZWVkIHRvIHJlY2VpdmUgYSBza2Igd2l0aCBuZWNlc3Nhcnkgc3BhY2UgZm9yIHRo
ZSBJQ1YuIFNvLAp0aGUgZHJpdmVyIGFkZHMgdGhpcyBzcGFjZSBiZWZvcmUgdG8gc2VuZCB0aGUg
ZnJhbWUuCgpDdXJyZW50bHksIG9uY2UgdGhlIGZyYW1lIGlzIHNlbnQsIHRoZSBkcml2ZXIgcmVz
dG9yZSB0aGUgb3JpZ2luYWwKY29udGVudCBvZiB0aGUgc2tiLiBIb3dldmVyLCB0aGlzIHN0ZXAg
aXMgdXNlbGVzcy4gTWFjODAyMTEgZG9uJ3QgZG8gaXQKd2hlbiBzb2Z0d2FyZSBlbmNyeXB0aW9u
IGlzIGVuYWJsZWQuCgpPbmNlIHdlIGhhdmUgcmVtb3ZlZCB0aGlzIHN0ZXAsIGl0IGFwcGVhcnMg
dGhhdCBpdCBpcyBubyBtb3JlIG5lY2Vzc2FyeQp0byBrZWVwIGh3X2tleSBpbiB0eF9wcml2LiBU
aGVuLCBpdCBpcyBwb3NzaWJsZSB0byBzaW1wbGlmeSBhIGJ1bmNoIG9mCmNvZGUgaW4gdGhlIFR4
IHBhdGguCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVy
QHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgfCAxNiArKysr
LS0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaCB8ICAzICstLQogMiBm
aWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDE0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9k
YXRhX3R4LmMKaW5kZXggZDE2YjUxNmFkN2NmLi40ODU5MDdiMGZhYTIgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0
YV90eC5jCkBAIC0zMzYsNyArMzM2LDYgQEAgc3RhdGljIGludCB3ZnhfdHhfaW5uZXIoc3RydWN0
IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBpZWVlODAyMTFfc3RhICpzdGEsCiB7CiAJc3RydWN0IGhp
Zl9tc2cgKmhpZl9tc2c7CiAJc3RydWN0IGhpZl9yZXFfdHggKnJlcTsKLQlzdHJ1Y3Qgd2Z4X3R4
X3ByaXYgKnR4X3ByaXY7CiAJc3RydWN0IGllZWU4MDIxMV90eF9pbmZvICp0eF9pbmZvID0gSUVF
RTgwMjExX1NLQl9DQihza2IpOwogCXN0cnVjdCBpZWVlODAyMTFfa2V5X2NvbmYgKmh3X2tleSA9
IHR4X2luZm8tPmNvbnRyb2wuaHdfa2V5OwogCXN0cnVjdCBpZWVlODAyMTFfaGRyICpoZHIgPSAo
c3RydWN0IGllZWU4MDIxMV9oZHIgKilza2ItPmRhdGE7CkBAIC0zNTAsMTQgKzM0OSwxMSBAQCBz
dGF0aWMgaW50IHdmeF90eF9pbm5lcihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IGllZWU4
MDIxMV9zdGEgKnN0YSwKIAogCS8vIEZyb20gbm93IHR4X2luZm8tPmNvbnRyb2wgaXMgdW51c2Fi
bGUKIAltZW1zZXQodHhfaW5mby0+cmF0ZV9kcml2ZXJfZGF0YSwgMCwgc2l6ZW9mKHN0cnVjdCB3
ZnhfdHhfcHJpdikpOwotCS8vIEZpbGwgdHhfcHJpdgotCXR4X3ByaXYgPSAoc3RydWN0IHdmeF90
eF9wcml2ICopdHhfaW5mby0+cmF0ZV9kcml2ZXJfZGF0YTsKLQl0eF9wcml2LT5od19rZXkgPSBo
d19rZXk7CiAKIAkvLyBGaWxsIGhpZl9tc2cKIAlXQVJOKHNrYl9oZWFkcm9vbShza2IpIDwgd21z
Z19sZW4sICJub3QgZW5vdWdoIHNwYWNlIGluIHNrYiIpOwogCVdBUk4ob2Zmc2V0ICYgMSwgImF0
dGVtcHQgdG8gdHJhbnNtaXQgYW4gdW5hbGlnbmVkIGZyYW1lIik7Ci0Jc2tiX3B1dChza2IsIHdm
eF90eF9nZXRfaWN2X2xlbih0eF9wcml2LT5od19rZXkpKTsKKwlza2JfcHV0KHNrYiwgd2Z4X3R4
X2dldF9pY3ZfbGVuKGh3X2tleSkpOwogCXNrYl9wdXNoKHNrYiwgd21zZ19sZW4pOwogCW1lbXNl
dChza2ItPmRhdGEsIDAsIHdtc2dfbGVuKTsKIAloaWZfbXNnID0gKHN0cnVjdCBoaWZfbXNnICop
c2tiLT5kYXRhOwpAQCAtNDg5LDcgKzQ4NSw2IEBAIHN0YXRpYyB2b2lkIHdmeF90eF9maWxsX3Jh
dGVzKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAogdm9pZCB3ZnhfdHhfY29uZmlybV9jYihzdHJ1Y3Qg
d2Z4X2RldiAqd2RldiwgY29uc3Qgc3RydWN0IGhpZl9jbmZfdHggKmFyZykKIHsKIAlzdHJ1Y3Qg
aWVlZTgwMjExX3R4X2luZm8gKnR4X2luZm87Ci0JY29uc3Qgc3RydWN0IHdmeF90eF9wcml2ICp0
eF9wcml2OwogCXN0cnVjdCB3ZnhfdmlmICp3dmlmOwogCXN0cnVjdCBza19idWZmICpza2I7CiAK
QEAgLTQ5OSwxOCArNDk0LDE1IEBAIHZvaWQgd2Z4X3R4X2NvbmZpcm1fY2Ioc3RydWN0IHdmeF9k
ZXYgKndkZXYsIGNvbnN0IHN0cnVjdCBoaWZfY25mX3R4ICphcmcpCiAJCQkgYXJnLT5wYWNrZXRf
aWQpOwogCQlyZXR1cm47CiAJfQorCXR4X2luZm8gPSBJRUVFODAyMTFfU0tCX0NCKHNrYik7CiAJ
d3ZpZiA9IHdkZXZfdG9fd3ZpZih3ZGV2LCAoKHN0cnVjdCBoaWZfbXNnICopc2tiLT5kYXRhKS0+
aW50ZXJmYWNlKTsKIAlXQVJOX09OKCF3dmlmKTsKIAlpZiAoIXd2aWYpCiAJCXJldHVybjsKLQl0
eF9pbmZvID0gSUVFRTgwMjExX1NLQl9DQihza2IpOwotCXR4X3ByaXYgPSB3Znhfc2tiX3R4X3By
aXYoc2tiKTsKKworCS8vIE5vdGUgdGhhdCB3ZnhfcGVuZGluZ19nZXRfcGt0X3VzX2RlbGF5KCkg
Z2V0IGRhdGEgZnJvbSB0eF9pbmZvCiAJX3RyYWNlX3R4X3N0YXRzKGFyZywgc2tiLCB3ZnhfcGVu
ZGluZ19nZXRfcGt0X3VzX2RlbGF5KHdkZXYsIHNrYikpOwotCi0JLy8gWW91IGNhbiB0b3VjaCB0
byB0eF9wcml2LCBidXQgZG9uJ3QgdG91Y2ggdG8gdHhfaW5mby0+c3RhdHVzLgogCXdmeF90eF9m
aWxsX3JhdGVzKHdkZXYsIHR4X2luZm8sIGFyZyk7Ci0Jc2tiX3RyaW0oc2tiLCBza2ItPmxlbiAt
IHdmeF90eF9nZXRfaWN2X2xlbih0eF9wcml2LT5od19rZXkpKTsKLQogCS8vIEZyb20gbm93LCB5
b3UgY2FuIHRvdWNoIHRvIHR4X2luZm8tPnN0YXR1cywgYnV0IGRvIG5vdCB0b3VjaCB0bwogCS8v
IHR4X3ByaXYgYW55bW9yZQogCS8vIEZJWE1FOiB1c2UgaWVlZTgwMjExX3R4X2luZm9fY2xlYXJf
c3RhdHVzKCkKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5oIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmgKaW5kZXggY2ZmN2I5ZmY5OWE5Li44N2UxYjliNjJk
YmIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5oCisrKyBiL2RyaXZl
cnMvc3RhZ2luZy93ZngvZGF0YV90eC5oCkBAIC0zNSw4ICszNSw3IEBAIHN0cnVjdCB0eF9wb2xp
Y3lfY2FjaGUgewogCiBzdHJ1Y3Qgd2Z4X3R4X3ByaXYgewogCWt0aW1lX3QgeG1pdF90aW1lc3Rh
bXA7Ci0Jc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqaHdfa2V5OwotfSBfX3BhY2tlZDsKK307
CiAKIHZvaWQgd2Z4X3R4X3BvbGljeV9pbml0KHN0cnVjdCB3ZnhfdmlmICp3dmlmKTsKIHZvaWQg
d2Z4X3R4X3BvbGljeV91cGxvYWRfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspOwotLSAK
Mi4yOC4wCgo=
