Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C90E24C2BC
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 17:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbgHTP7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 11:59:50 -0400
Received: from mail-bn7nam10on2087.outbound.protection.outlook.com ([40.107.92.87]:47585
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728475AbgHTP7d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 11:59:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hyCCWfLnACE2aMgG5f0Simgf1INKdp+Cz2CMgiNQb8Vx5CIEFf0/++0jci0HXiM89qRUswrWWx91MgZdeEjDdXiTvyTAmVvpY8vMOL33COHE7i4juIbWR3a/vKEP5O2UFD3CwWtSWUSXFzeBcQBjMkw7GK+iCN7pAQq+jVCL7EYbbvGDAKBMN2d/sR74nnqU2yAjclLKM/7BEJuEV75DdIBUv+JUgyzcW9qPnMUpTcMnjaH82bT1DY7tpQ+aR1h/Uq08tHucO1/tIboqEgw/0ETEChrSGc5dFEWlsj/QKpK4IJ21XkXxbJ49zMpeBDKDO4wF6Rx3A+F4svqLz0isqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+vcLlWaLMlEF7GyLv2510d2MIxwweKs9ZMtIGYivEU=;
 b=FhQBjbaldU2Y5JHDA5Zxo6Bz9vVwzq1WRewbao3a9nxAape/A2cu7kJVgZQK/jWHe7f7doAQAOMomLVLk/9IRY3jgC0xbgHsy6huVf7xCJGbOl41bOoBCvNk0Ff5EkCWX+7nYEhcGPG6IbmGX4V/GRy3jD8Y8rb6+lLqcUbMm55UCdtxZFYEQOZ37PDiBUUhdLlDmUkalyIaQdEfYrCxIWAi4GFmq96hNV5FAS3oXoEygVoQb0n7pDNzrRrBJ2yTif5fn7u7bWFfGgogGV7fFR5wobbvpcMx68sqSDWzwCNm0FHLBRCrOqmdycntlXJQ/0a/01QsRHqNeTMKZE866Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+vcLlWaLMlEF7GyLv2510d2MIxwweKs9ZMtIGYivEU=;
 b=TLwMqfHyuCSKB/URfmOuSnas/dlZrIX2goDzEpX/ROtoubBUBrfgiGn2L9k+XQ9eF2rEaoOsnH/CxNidCFTVry8tXCFmyDdJBBePY378VyDsmfhJg7KbEYUFO7Xk3A/sy2eMTyJ9oQTpQoP8pNZ+B/jnU1JhKa45ddqp7p18Vlo=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4541.namprd11.prod.outlook.com (2603:10b6:806:94::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 15:59:25 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 15:59:25 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 02/12] staging: wfx: improve usage of hif_map_link()
Date:   Thu, 20 Aug 2020 17:58:48 +0200
Message-Id: <20200820155858.351292-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820155858.351292-1-Jerome.Pouiller@silabs.com>
References: <20200820155858.351292-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0122.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::14) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by PR0P264CA0122.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 15:59:24 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2db31cc8-cec4-48b1-355e-08d8452202ee
X-MS-TrafficTypeDiagnostic: SA0PR11MB4541:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4541F49FF5F76F21B4A71BC1935A0@SA0PR11MB4541.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IGrU4W4uExZlqSwxDuzL0GFdD67uPZ/aOuV1iydKill5/0PEY2xVP8YP2ufJD6zs0jXa5Ywlw4jVMKhLRab0q2jWAZCGBv/sovVALGdxAX9xyj3wYojtRCbWEij6EwY8y/jacLMe+EHbIkY/636I2yWTBZzrDjZahG4bZW+5TcGzptgwjuPyi8LLSe/XnXtQM5ZSRJSb8NuaWnd9rXqIBGh9Au3elzAC0Xn4gNuW0gtJMB3Vkzc9dps37GfMlyXnWKtrSXAsabMlVU/a2sDtf/0zlfoms31anOCGRXibyQSiQc9gLEG+5nBlkdYD4N9XVU0TtdXs4S2et1y0v7nAc2+KxIPmI3Nl+0PYx6OlJpvlmPgv5w0CePBtKeV3e0lL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39850400004)(366004)(346002)(136003)(186003)(6666004)(2906002)(8676002)(316002)(16576012)(54906003)(956004)(26005)(66574015)(8936002)(2616005)(110011004)(52116002)(83380400001)(107886003)(1076003)(5660300002)(478600001)(36756003)(4326008)(66476007)(66556008)(66946007)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JXjtdR2szKhe9Sass+XD7+pcovkQZ23kt7D1TU9FqeZvRZRARr5pxwqASJz6XQ2JRE8hO2ZtIGpB38C2IpmH7c158Q6REV/gdWYi4TonzOXpK0SxKGVB0krjr8zZQ6pLO3Cs0ucmCQA1U1ZzmgHUexEf93f53yvKvErflRACEDsOlrlmGTeSA8pBIZ/QM06irONsKBve1v+UlGioCbHjk9jaMmb+juYTuKn5wW9XOqx3oktKYS27JvpADpLAMMe/n2c6d5u2ovysiAz3H2FM4SE1yoJDqnpEJHwaATu7Gho+Ad7LRdsqld9Qbv0bWYSmsCBxFjf6sJKMHne2DdawbkM+1yMi8hWCpwSm9Ottk95WWPwYQ9d66UIHZLNwfbVGKQzCcDkxDK4aLoa2bmPA6vFOhsrOxxfLU5x8FMWhneMUuAy88ophBA+T/61b46TxhhdsiIYkok5ymp54UIcURx278yx59/XXXXouh3ng9WWHTFfSZfCwICnyo2AChoCvrnlR/+ZUSi7jFbaALLlyqvj70HZ7J4RNWdPcZ7lEWvCch0skUdxUtLSzMO8RKEgntEaH1szrFnPKLAsVbjz8X3tbyv8B0A00f32eFQ53tugitpQlYosccW4k5TGq6citbJ/NUjs0SeQRV3ljnQ9XyQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2db31cc8-cec4-48b1-355e-08d8452202ee
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 15:59:25.4724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S2g9K8M8cxOyM5yjqPdjT/YJMD2MprV0et7vmqQXSohblWfq9YzP5+E9eHN9KsvIgJcKTHpMpquobxONX0ESfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4541
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVW50
aWwgbm93LCBoaWZfbWFwX2xpbmsoKSBnZXQgYXMgYXJndW1lbnQgdGhlIHJhdyB2YWx1ZSBmb3IK
bWFwX2xpbmtfZmxhZ3Mgd2hlbiBtYXBfbGlua19mbGFncyBpcyBkZWZpbmVkIGFzIGEgYml0Zmll
bGQuIEl0IHdhcwplcnJvciBwcm9uZS4KCk5vdyBoaWZfbWFwX2xpbmsoKSB0YWtlcyBleHBsaWNp
dCB2YWx1ZSBmb3IgZXZlcnkgZmxhZ3Mgb2YgdGhlCnN0cnVjdCBtYXBfbGlua19mbGFncy4KClNp
Z25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNv
bT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jIHwgNSArKystLQogZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfdHguaCB8IDMgKystCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAg
IHwgNCArKy0tCiAzIGZpbGVzIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfdHguYwppbmRleCAzYjVmNGRjYzQ2OWMuLjZiODllNTVmMDNmNCAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYworKysgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eC5jCkBAIC00OTksNyArNDk5LDcgQEAgaW50IGhpZl9iZWFjb25fdHJhbnNt
aXQoc3RydWN0IHdmeF92aWYgKnd2aWYsIGJvb2wgZW5hYmxlKQogCXJldHVybiByZXQ7CiB9CiAK
LWludCBoaWZfbWFwX2xpbmsoc3RydWN0IHdmeF92aWYgKnd2aWYsIHU4ICptYWNfYWRkciwgaW50
IGZsYWdzLCBpbnQgc3RhX2lkKQoraW50IGhpZl9tYXBfbGluayhzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwgYm9vbCB1bm1hcCwgdTggKm1hY19hZGRyLCBpbnQgc3RhX2lkLCBib29sIG1mcCkKIHsKIAlp
bnQgcmV0OwogCXN0cnVjdCBoaWZfbXNnICpoaWY7CkBAIC01MDksNyArNTA5LDggQEAgaW50IGhp
Zl9tYXBfbGluayhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgdTggKm1hY19hZGRyLCBpbnQgZmxhZ3Ms
IGludCBzdGFfaWQpCiAJCXJldHVybiAtRU5PTUVNOwogCWlmIChtYWNfYWRkcikKIAkJZXRoZXJf
YWRkcl9jb3B5KGJvZHktPm1hY19hZGRyLCBtYWNfYWRkcik7Ci0JYm9keS0+bWFwX2xpbmtfZmxh
Z3MgPSAqKHN0cnVjdCBoaWZfbWFwX2xpbmtfZmxhZ3MgKikmZmxhZ3M7CisJYm9keS0+bWFwX2xp
bmtfZmxhZ3MubWZwYyA9IG1mcCA/IDEgOiAwOworCWJvZHktPm1hcF9saW5rX2ZsYWdzLm1hcF9k
aXJlY3Rpb24gPSB1bm1hcCA/IDEgOiAwOwogCWJvZHktPnBlZXJfc3RhX2lkID0gc3RhX2lkOwog
CXdmeF9maWxsX2hlYWRlcihoaWYsIHd2aWYtPmlkLCBISUZfUkVRX0lEX01BUF9MSU5LLCBzaXpl
b2YoKmJvZHkpKTsKIAlyZXQgPSB3ZnhfY21kX3NlbmQod3ZpZi0+d2RldiwgaGlmLCBOVUxMLCAw
LCBmYWxzZSk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5oIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaAppbmRleCBlMWRhMjhhZWY3MDYuLmIzNzFiMzc3N2Ez
MSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaAorKysgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl90eC5oCkBAIC01NSw3ICs1NSw4IEBAIGludCBoaWZfc2V0X2VkY2Ff
cXVldWVfcGFyYW1zKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCB1MTYgcXVldWUsCiBpbnQgaGlmX3N0
YXJ0KHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1Y3QgaWVlZTgwMjExX2Jzc19jb25m
ICpjb25mLAogCSAgICAgIGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAqY2hhbm5lbCk7
CiBpbnQgaGlmX2JlYWNvbl90cmFuc21pdChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBlbmFi
bGUpOwotaW50IGhpZl9tYXBfbGluayhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgdTggKm1hY19hZGRy
LCBpbnQgZmxhZ3MsIGludCBzdGFfaWQpOworaW50IGhpZl9tYXBfbGluayhzdHJ1Y3Qgd2Z4X3Zp
ZiAqd3ZpZiwKKwkJIGJvb2wgdW5tYXAsIHU4ICptYWNfYWRkciwgaW50IHN0YV9pZCwgYm9vbCBt
ZnApOwogaW50IGhpZl91cGRhdGVfaWVfYmVhY29uKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25z
dCB1OCAqaWVzLCBzaXplX3QgaWVzX2xlbik7CiBpbnQgaGlmX3NsX3NldF9tYWNfa2V5KHN0cnVj
dCB3ZnhfZGV2ICp3ZGV2LAogCQkgICAgICAgY29uc3QgdTggKnNsa19rZXksIGludCBkZXN0aW5h
dGlvbik7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYwppbmRleCA5YzFjODIyM2E0OWYuLmQyZTljZjY1MWM4MSAxMDA2NDQK
LS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jCkBAIC00MzQsNyArNDM0LDcgQEAgaW50IHdmeF9zdGFfYWRkKHN0cnVjdCBpZWVlODAy
MTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLAogCXd2aWYtPmxpbmtfaWRfbWFw
IHw9IEJJVChzdGFfcHJpdi0+bGlua19pZCk7CiAJV0FSTl9PTighc3RhX3ByaXYtPmxpbmtfaWQp
OwogCVdBUk5fT04oc3RhX3ByaXYtPmxpbmtfaWQgPj0gSElGX0xJTktfSURfTUFYKTsKLQloaWZf
bWFwX2xpbmsod3ZpZiwgc3RhLT5hZGRyLCBzdGEtPm1mcCA/IDIgOiAwLCBzdGFfcHJpdi0+bGlu
a19pZCk7CisJaGlmX21hcF9saW5rKHd2aWYsIGZhbHNlLCBzdGEtPmFkZHIsIHN0YV9wcml2LT5s
aW5rX2lkLCBzdGEtPm1mcCk7CiAKIAlyZXR1cm4gMDsKIH0KQEAgLTQ0OSw3ICs0NDksNyBAQCBp
bnQgd2Z4X3N0YV9yZW1vdmUoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAy
MTFfdmlmICp2aWYsCiAJaWYgKCFzdGFfcHJpdi0+bGlua19pZCkKIAkJcmV0dXJuIDA7CiAJLy8g
RklYTUUgYWRkIGEgbXV0ZXg/Ci0JaGlmX21hcF9saW5rKHd2aWYsIHN0YS0+YWRkciwgMSwgc3Rh
X3ByaXYtPmxpbmtfaWQpOworCWhpZl9tYXBfbGluayh3dmlmLCB0cnVlLCBzdGEtPmFkZHIsIHN0
YV9wcml2LT5saW5rX2lkLCBmYWxzZSk7CiAJd3ZpZi0+bGlua19pZF9tYXAgJj0gfkJJVChzdGFf
cHJpdi0+bGlua19pZCk7CiAJcmV0dXJuIDA7CiB9Ci0tIAoyLjI4LjAKCg==
