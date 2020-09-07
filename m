Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1591F25F85E
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbgIGKcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:32:09 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:35584
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728627AbgIGKQN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:16:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QalXUgkeheFY/kKy7NhlpbsVIv1T9wwcrWsrQ3JKvj+0iPoVgyjobt2ClMG2xC15SjagXnaInMrPrs4Wrplp+xwFe45D8MGkw4kkuIeZgjFAUcIHbBrNQNhPl4iEPNJDE88p7UXaxusgnGpkfXO1UlFMj6UAiSnN9jrmTJqnEGGMfhaUmQXMHJHEuqPx7N1fnNWOS065fGNDmc0mMR0sIfSSgP6vg1Ffi31eWoJRUc6A4oY7KwXFNYyUvoUAIETrX/D3kQ5XVGr3RxxdkO0YYljDN8ttz3ftFjEimosCytmkkolkcBKeneW/oESxpXd4RU2FUKgPVuIXcGWDFoiW1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivdj5JFN/2y+dp5HHokI+ALLktiWtShEARWHGyHRUJE=;
 b=cdx8SilGU6f99uLhgwHLIOGGwDVheVRK1KXSoHZiJcXvptM9Pprj2FWUl3rg6vxXnQONi5qX3/Fu27LFPb/8DgGk3yBpOSj7HlqP7n5VqyddBOctewl7uYcwL0P4Z2V5BnlLMjAZPNnK7u53Gw7biPen3ojpPtosyivL6iATnVfXDqdfeZeg3kVU0gSYc4Lk2vJ05IRi5cXqINrviWgAiSXEbkBepvRpjLWdkLzr26/Jaiy24A54x7wXv5Xm15L/zGrHEBxB+KCx9GvJt3CiUU8Cs1DGFvMQZtJ7PLRu4qwmvz1ITy382VEVbyTmfEXg8cjKY7u8TQRC29ZKaRvlHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivdj5JFN/2y+dp5HHokI+ALLktiWtShEARWHGyHRUJE=;
 b=VWkF5Ci0Ct+nxa4bIzRPQoFJQid+HgMOGqvoOUFy5MziFW55RkU9qcA5yHheekwIw27yyQH+ivid9Z/1vuVU+oIztPaPD0XuH/d7hR/xDZvdMh7KVZO2UEtYi+3eoCGdRz/b3GSxTM9aoZ383VGHf0kK7DkRPslpxpDpyTOq2no=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2606.namprd11.prod.outlook.com (2603:10b6:805:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Mon, 7 Sep
 2020 10:15:55 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:15:55 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 07/31] staging: wfx: drop useless function
Date:   Mon,  7 Sep 2020 12:14:57 +0200
Message-Id: <20200907101521.66082-8-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
References: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::25) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:15:54 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71b25936-36b4-44f4-995d-08d8531701f3
X-MS-TrafficTypeDiagnostic: SN6PR11MB2606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB26066D975814492E18D4EBB093280@SN6PR11MB2606.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DnNwxLIBeKCmV/TqJWM5Y+MXlyC7gUaAkni9WZ5TUAMU/qrjLQkAa7rwV35UfTQD+0bwkInQ/SrV3S2nEuHVUqU/EpVr3i3CB+pEMYBcjiDDBXUARFgANs6HBRHsuagufpwYmMoO35NjRrD1kA4aOZVjmz4RaF7jyx4AcSRwY4BFneWNByxGKN+40b5xSVjzVaz7K6XTTUxGwR+iSEEMQ2IazhGYNAEJi+NmVUAQtvAIBfwBk1LgpRxdkzAADUjMTP64uPfpDCzP9IL/Ka3LwcK/dMRwKvvb9gOsRbwr5eUWsJCcIK3U/KZMsvKiHQhbr0Lzy54hjZeJJS+K4xbgMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(136003)(39850400004)(66946007)(4326008)(5660300002)(2616005)(66476007)(316002)(956004)(478600001)(54906003)(52116002)(2906002)(66556008)(1076003)(36756003)(8676002)(86362001)(6486002)(8936002)(7696005)(66574015)(83380400001)(26005)(107886003)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Ow4cDwfewEE8RoCWJOdaaZlTquk6ygP6dBNl5t28OJPQA66CmzfSfUsMptBgV8dCOiJ3Gvp9M/+q18s1lNoHB5/9ogcRUjXf3ZZ9JnHuGQdFWuvCtw6XPQwvTeiN0gYC/SOF1kiTpbrjj/oPuKpVWgh2AClRJJg2W79gq7MO6awX2/pQL6a4/s73FNtUKE1L5DLRGuDNe6fm8X0SaGJSOmRvKw34QId1Dwn48NBly2y2jHMEqguM/4rSEhQwNtelOG6hZ6feC/ZNYrUsnLUZh/18UaSsRUuejsa6DHc+mHv/Cyb7w8TYWLSZ2MslQN0GTO4CsML4msiD22YrsUfRjIc2ENJnI3Zxsl0dIx/Lv9+nyDNqGaSoQDPFlwoN/8Dv+H1wEVXwY6spoleQ+XkNKe1BuOm7wTdc56md4WL6GBK3EOGcYIUroaonAWhup/DG52H/8Ss71ckTZDet5trA7xh4XS+WLVF+aKwb9qd0weD8YLLwj0F7qR7T2myW6z/ux0ARmmRNbw2+H4vVZf/fBgSIIjF0CAl9DVAI03+4FddamRtLyhEdJGOl7D6swaiRq7pgco/+CsEZuRP9595PsIjfKF1nI91kjtzRhQk/VdLktC5hj+EXGa2DUaiUsAEvZByKA/6AyIf0RdulFQB+SA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71b25936-36b4-44f4-995d-08d8531701f3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:15:55.6699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S4NQiWqLdTPn06hn01UOHMe7u86Nbo1e95244ONwwOh0Tfcoov5rE4eJhyfXfOsZAd0YPtVBUcj418gf8K/Eng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2lu
Y2UgdGhlIGNvZGUgZm9yIG11bHRpY2FzdCBmaWx0ZXJpbmcgaGFzIGJlZW4gZHJvcHBlZCwgdGhl
IGZ1bmN0aW9uCmhpZl9zZXRfZGF0YV9maWx0ZXJpbmcoKSBpcyBvbmx5IGNhbGxlZCB0byBkaXNh
YmxlIG11bHRpY2FzdCBmaWx0ZXJpbmcuCkluIGZhY3QsIHRoZSBtdWx0aWNhc3QgZmlsdGVyaW5n
IGlzIGFscmVhZHkgZGlzYWJsZWQgYnkgZGVmYXVsdC4gU28sCnRoaXMgZnVuY3Rpb24gaXMgdXNl
bGVzcyBhbmQgY2FuIGJlIGRyb3BwZWQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxl
ciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9o
aWZfYXBpX21pYi5oIHwgIDggLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21p
Yi5jICB8IDExIC0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaCAg
fCAgMSAtCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgICAgICAgfCAgMiAtLQogNCBmaWxl
cyBjaGFuZ2VkLCAyMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2hpZl9hcGlfbWliLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfbWliLmgKaW5k
ZXggZDBlMGE5ZTI5YWZhLi43Mzg3M2QyOTQ1NmQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX2FwaV9taWIuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfbWli
LmgKQEAgLTgyLDE0ICs4Miw2IEBAIHN0cnVjdCBoaWZfbWliX2dsX3NldF9tdWx0aV9tc2cgewog
CXU4ICAgICByZXNlcnZlZDJbM107CiB9IF9fcGFja2VkOwogCi1zdHJ1Y3QgaGlmX21pYl9zZXRf
ZGF0YV9maWx0ZXJpbmcgewotCXU4ICAgICBpbnZlcnRfbWF0Y2hpbmc6MTsKLQl1OCAgICAgcmVz
ZXJ2ZWQxOjc7Ci0JdTggICAgIGVuYWJsZToxOwotCXU4ICAgICByZXNlcnZlZDI6NzsKLQl1OCAg
ICAgcmVzZXJ2ZWQzWzJdOwotfSBfX3BhY2tlZDsKLQogZW51bSBoaWZfYXJwX25zX2ZyYW1lX3Ry
ZWF0bWVudCB7CiAJSElGX0FSUF9OU19GSUxURVJJTkdfRElTQUJMRSA9IDB4MCwKIAlISUZfQVJQ
X05TX0ZJTFRFUklOR19FTkFCTEUgID0gMHgxLApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfdHhfbWliLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuYwppbmRl
eCA3ZjI0ZTlmNzdjMjIuLjJlYjJhMjA4OTBjNyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfdHhfbWliLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMK
QEAgLTIyOCwxNyArMjI4LDYgQEAgaW50IGhpZl9zZXRfdHhfcmF0ZV9yZXRyeV9wb2xpY3koc3Ry
dWN0IHdmeF92aWYgKnd2aWYsCiAJcmV0dXJuIHJldDsKIH0KIAotaW50IGhpZl9zZXRfZGF0YV9m
aWx0ZXJpbmcoc3RydWN0IHdmeF92aWYgKnd2aWYsIGJvb2wgZW5hYmxlLCBib29sIGludmVydCkK
LXsKLQlzdHJ1Y3QgaGlmX21pYl9zZXRfZGF0YV9maWx0ZXJpbmcgdmFsID0gewotCQkuZW5hYmxl
ID0gZW5hYmxlLAotCQkuaW52ZXJ0X21hdGNoaW5nID0gaW52ZXJ0LAotCX07Ci0KLQlyZXR1cm4g
aGlmX3dyaXRlX21pYih3dmlmLT53ZGV2LCB3dmlmLT5pZCwKLQkJCSAgICAgSElGX01JQl9JRF9T
RVRfREFUQV9GSUxURVJJTkcsICZ2YWwsIHNpemVvZih2YWwpKTsKLX0KLQogaW50IGhpZl9rZWVw
X2FsaXZlX3BlcmlvZChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgaW50IHBlcmlvZCkKIHsKIAlzdHJ1
Y3QgaGlmX21pYl9rZWVwX2FsaXZlX3BlcmlvZCBhcmcgPSB7CmRpZmYgLS1naXQgYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21p
Yi5oCmluZGV4IGQ0Y2FjNjMxNjRiYS4uNmMyNTAxNTE3M2NkIDEwMDY0NAotLS0gYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90
eF9taWIuaApAQCAtMzcsNyArMzcsNiBAQCBpbnQgaGlmX3NldF9hc3NvY2lhdGlvbl9tb2RlKHN0
cnVjdCB3ZnhfdmlmICp3dmlmLCBpbnQgYW1wZHVfZGVuc2l0eSwKIAkJCSAgICAgYm9vbCBncmVl
bmZpZWxkLCBib29sIHNob3J0X3ByZWFtYmxlKTsKIGludCBoaWZfc2V0X3R4X3JhdGVfcmV0cnlf
cG9saWN5KHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCQkJCSBpbnQgcG9saWN5X2luZGV4LCB1OCAq
cmF0ZXMpOwotaW50IGhpZl9zZXRfZGF0YV9maWx0ZXJpbmcoc3RydWN0IHdmeF92aWYgKnd2aWYs
IGJvb2wgZW5hYmxlLCBib29sIGludmVydCk7CiBpbnQgaGlmX2tlZXBfYWxpdmVfcGVyaW9kKHN0
cnVjdCB3ZnhfdmlmICp3dmlmLCBpbnQgcGVyaW9kKTsKIGludCBoaWZfc2V0X2FycF9pcHY0X2Zp
bHRlcihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgaW50IGlkeCwgX19iZTMyICphZGRyKTsKIGludCBo
aWZfdXNlX211bHRpX3R4X2NvbmYoc3RydWN0IHdmeF9kZXYgKndkZXYsIGJvb2wgZW5hYmxlKTsK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jCmluZGV4IDg3MDBkMmZjNmE3Ny4uMGQyN2NhMjdlNDhjIDEwMDY0NAotLS0gYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMK
QEAgLTEyMCw4ICsxMjAsNiBAQCB2b2lkIHdmeF9jb25maWd1cmVfZmlsdGVyKHN0cnVjdCBpZWVl
ODAyMTFfaHcgKmh3LCB1bnNpZ25lZCBpbnQgY2hhbmdlZF9mbGFncywKIAkJCWZpbHRlcl9iZWFj
b24gPSB0cnVlOwogCQl3ZnhfZmlsdGVyX2JlYWNvbih3dmlmLCBmaWx0ZXJfYmVhY29uKTsKIAot
CQloaWZfc2V0X2RhdGFfZmlsdGVyaW5nKHd2aWYsIGZhbHNlLCB0cnVlKTsKLQogCQlpZiAoKnRv
dGFsX2ZsYWdzICYgRklGX09USEVSX0JTUykKIAkJCWZpbHRlcl9ic3NpZCA9IGZhbHNlOwogCQll
bHNlCi0tIAoyLjI4LjAKCg==
