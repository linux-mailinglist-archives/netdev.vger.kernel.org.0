Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B9B2514BA
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 10:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbgHYI7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 04:59:02 -0400
Received: from mail-bn8nam11on2079.outbound.protection.outlook.com ([40.107.236.79]:20448
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728033AbgHYI7B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 04:59:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UFSQVmTRjNq9WIa7CbjmsdUXnqVPnI6EPaksGiR/I/jAKOAriAJoTe7MyolFEKOb8dmrbymp/qZiNejCxozrlYgSaNXj3LjKHP7ocs0IzvwYOlMUUzYK+rdRTiVZusCT26kwP3WWo1PdjM3eLJKd7ck5dR0JfhMBhPg4Jzo6z8Bgdj5zyYT+AaJ8D/nwkNVCamZQbgR5Dv4GFfBELTUxxHHAWhS9V1SpAz0DKGP7OqcxyE4gQQwTVogTNPxpWvO5iSHnnPnw6N/+e1sEoZ6C78g8Z11mwQ+3fXvJokzd0ZacFBc4uTRG3axoMrQNhSJo39HFkXIroSkEVSkC5gYtaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HulzlNPJ0vKnS1DE7gqTcXMUbsJBNAI5ANqEA6+6cIk=;
 b=JydQ2SDLMqTSE0de6Wt2u/ATEuITEIvWYDGec88YgkGj35w1bYssk3fSmEvTZzGiEJ0JmjLjFUOOKfZajWGu1c0iTogB/tChzXhhch6KaS9WXC5dZWqrQHVQCGxptE6wo4Ei3C+Zh4FNFQOGRuiynzRqbwbjR8JVWaSU3RG8zZ0iW04Iyn1epnIl81HwXZA+ekJfI7cpMBvzsdlRBhQLgHlHrpYpGuXsGErzVqORtbFOYLOHrNUKxyHFCW+IY04/P90iBSLAEF1ZiXgbRdbL6Mo/dPnPBrvR85H0gOaeTWUzMOv4UWuDwhqWTKopFLLodVa8/DOHFLeUZkiStBh07w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HulzlNPJ0vKnS1DE7gqTcXMUbsJBNAI5ANqEA6+6cIk=;
 b=XhaglZ1b1LnajPC67+tFTxcTu00bl0N7NvUJfH1r5IZ8jCBTAQCLu5QI59Nt9yvCDo8x4TAPTzECucCdyb1Zeb8B4Vk21Ag7DrpOWGjXbdfVIk6xHBRcYGlyJiVD5UaAlpMQXo1xr4SiWCF1sv+aEYtgPON2AnYwqUT8K4VqJzI=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3501.namprd11.prod.outlook.com (2603:10b6:805:d4::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Tue, 25 Aug
 2020 08:58:55 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 08:58:55 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 01/12] staging: wfx: fix BA when device is AP and MFP is enabled
Date:   Tue, 25 Aug 2020 10:58:17 +0200
Message-Id: <20200825085828.399505-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P192CA0002.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::7) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by PR3P192CA0002.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Tue, 25 Aug 2020 08:58:53 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fa8b919-00df-4385-9d65-08d848d51878
X-MS-TrafficTypeDiagnostic: SN6PR11MB3501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3501F65D4C7F10EB46D22BD393570@SN6PR11MB3501.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XWFS3VFJRNLi4sYpO2lOw4akxNPDR9r1ovaOWlH1Z+JQt/4HNv5g3i1qy4QEYb4EIbgzgov7Jf4rR2E+zfdWxRsEDGY57JrqaYAvxvUwwVIricTVTpzbDJ9gN5wi1B6xsVoehRsLhhU3E8Yhuhzi3aZmWacbQWbbDHNbX/r3oOhxSCjgC0UM5hCZlKwn1fJbCnlkN7ZCdE397bohtz9IqpzClCTHeniTnUqzWTUF35BFYnpG3OnTBTdQOcTVjfxInSXgLvCjRSIGPHSilaay6lWj7SRhAZsnscEdklhUW8NTyvVlAk/RFoZUt03kZCMqjlK723jAuGzItJNAXP3oCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(396003)(346002)(376002)(366004)(316002)(5660300002)(478600001)(107886003)(1076003)(8936002)(83380400001)(16576012)(956004)(66556008)(66476007)(26005)(2616005)(186003)(8676002)(86362001)(66946007)(6486002)(54906003)(6666004)(36756003)(4326008)(66574015)(2906002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5Brjpm2Z62h7oN4411l5CZwDuKYWFQPeYTgB0Q0GLH+lVpkhwNyOOfJs6zLtks8FWrPS81tfUr1e9q+uLWD0Pz4r06A1L2EnRkTBfKZD6sh05xtYdegLBkiIIHxFA6fEG04U5c18DGNMxaDzrvXuqIhgS+/y9rvNFdGQdOBasAzDxSfn/WJ4qOMHUjFtdirRiromcJGNKs0kqObLuf+QHvFny1PvWT69JTfru7od5/1PDkWNmGFvAIN0ooRoxiaDcrdHeYYGoPm2tRspii4rAhL5D2WdK4PEaqAZZaVSF5JUAz58FefIdVbquF7XyANAt1yXTh+LkUXnlSxshXnOviMz8flkHuk4SoKcbej5bmJt4S6hx3/BC3N0To3nyCZt1UFRo+Y/Up5zy1mEQW/o9K6okLVfzg0Vt8LKIoHDh7AMqjj4l5B8vm6T3B19YmkGlE/Vjna4zgkf68Pzw7JRmuaVgyeZobKL//p7kcZwQNeUsRQ5MGzcCJRXzb6ZH95bfZr29XmBBqQHoBXeHjKNRi8Wtxu4hmQccxBDVWnFZcWJnvDLVpZRm4VjnG2BeZK1mLHEo6PZEImut69vx8KU+RlHaxDcN0IBnO9TTZxH/O4qQ/PpST+HcyLQqMFfe8PurcrMJTv3Zrcd/1FDwbUuMw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fa8b919-00df-4385-9d65-08d848d51878
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 08:58:55.1095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BhS5+tsNR1gDOZ9E43xmaUrbT4vEWReR9ZAt6pNDVkbO9kvghjBB1JeMujzViIP5AuHYWipy00YpomUyFyK+lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3501
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHByb3RlY3Rpb24gb2YgdGhlIG1hbmFnZW1lbnQgZnJhbWVzIGlzIG1haW5seSBkb25lIGJ5IG1h
YzgwMjExLgpIb3dldmVyLCBmcmFtZXMgZm9yIHRoZSBtYW5hZ2VtZW50IG9mIHRoZSBCbG9ja0Fj
ayBzZXNzaW9ucyBhcmUgZGlyZWN0bHkKc2VudCBieSB0aGUgZGV2aWNlLiBUaGVzZSBmcmFtZXMg
aGF2ZSB0byBiZSBwcm90ZWN0ZWQgaWYgTUZQIGlzIGluIHVzZS4KU28gdGhlIGRyaXZlciBoYXMg
dG8gcGFzcyB0aGUgTUZQIGNvbmZpZ3VyYXRpb24gdG8gdGhlIGRldmljZS4KClVudGlsIG5vdywg
dGhlIEJsb2NrQWNrIG1hbmFnZW1lbnQgZnJhbWVzIHdlcmUgY29tcGxldGVseSB1bnByb3RlY3Rl
ZAp3aGF0ZXZlciB0aGUgc3RhdHVzIG9mIHRoZSBNRlAgbmVnb3RpYXRpb24uIFNvLCBzb21lIGRl
dmljZXMgZHJvcHBlZAp0aGVzZSBmcmFtZXMuCgpUaGUgZGV2aWNlIGhhcyB0d28ga25vYnMgdG8g
Y29udHJvbCB0aGUgTUZQLiBPbmUgZ2xvYmFsIGFuZCBvbmUgcGVyCnN0YXRpb24uIE5vcm1hbGx5
LCB0aGUgZHJpdmVyIHNob3VsZCBhbHdheXMgZW5hYmxlIGdsb2JhbCBNRlAuIFRoZW4gaXQKc2hv
dWxkIGVuYWJsZSBNRlAgb24gZXZlcnkgc3RhdGlvbiB3aXRoIHdoaWNoIE1GUCB3YXMgc3VjY2Vz
c2Z1bGx5Cm5lZ290aWF0ZWQuIFVuZm9ydHVuYXRlbHksIHRoZSBvbGRlciBmaXJtd2FyZXMgb25s
eSBwcm92aWRlIHRoZQpnbG9iYWwgY29udHJvbC4KClNvLCB0aGlzIHBhdGNoIGVuYWJsZSBnbG9i
YWwgTUZQIGFzIGl0IGlzIGV4cG9zZWQgaW4gdGhlIGJlYWNvbi4gVGhlbiBpdAptYXJrcyBldmVy
eSBzdGF0aW9uIHdpdGggd2hpY2ggdGhlIE1GUCBpcyBlZmZlY3RpdmUuCgpUaHVzLCB0aGUgc3Vw
cG9ydCBmb3IgdGhlIG9sZCBmaXJtd2FyZXMgaXMgbm90IHNvIGJhZC4gSXQgbWF5IG9ubHkKZW5j
b3VudGVyIHNvbWUgZGlmZmljdWx0aWVzIHRvIG5lZ290aWF0ZSBCQSBzZXNzaW9ucyB3aGVuIHRo
ZSBsb2NhbApkZXZpY2UgKHRoZSBBUCkgaXMgTUZQIGNhcGFibGUgKGllZWU4MDIxMXc9MSkgYnV0
IHRoZSBzdGF0aW9uIGlzIG5vdC4KVGhlIG9ubHkgc29sdXRpb24gZm9yIHRoaXMgY2FzZSBpcyB0
byB1cGdyYWRlIHRoZSBmaXJtd2FyZS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVy
IDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCnYyOgogIC0gQ2hlY2sgdGhhdCBwdHIg
ZG9lcyBub3QgcG9pbnQgb3V0IG9mIGJvdW5kcyBvZiBza2IuCgogZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYyB8IDI4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKy0KIDEgZmlsZSBjaGFuZ2Vk
LCAyNyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggYWQ2MzMz
MmY2OTBjLi5jMzFlMzAyZDA1YzkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtNDM0LDcgKzQzNCw3IEBAIGlu
dCB3Znhfc3RhX2FkZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92
aWYgKnZpZiwKIAl3dmlmLT5saW5rX2lkX21hcCB8PSBCSVQoc3RhX3ByaXYtPmxpbmtfaWQpOwog
CVdBUk5fT04oIXN0YV9wcml2LT5saW5rX2lkKTsKIAlXQVJOX09OKHN0YV9wcml2LT5saW5rX2lk
ID49IEhJRl9MSU5LX0lEX01BWCk7Ci0JaGlmX21hcF9saW5rKHd2aWYsIHN0YS0+YWRkciwgMCwg
c3RhX3ByaXYtPmxpbmtfaWQpOworCWhpZl9tYXBfbGluayh3dmlmLCBzdGEtPmFkZHIsIHN0YS0+
bWZwID8gMiA6IDAsIHN0YV9wcml2LT5saW5rX2lkKTsKIAogCXJldHVybiAwOwogfQpAQCAtNDc0
LDYgKzQ3NCwzMSBAQCBzdGF0aWMgaW50IHdmeF91cGxvYWRfYXBfdGVtcGxhdGVzKHN0cnVjdCB3
ZnhfdmlmICp3dmlmKQogCXJldHVybiAwOwogfQogCitzdGF0aWMgdm9pZCB3Znhfc2V0X21mcF9h
cChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKK3sKKwlzdHJ1Y3Qgc2tfYnVmZiAqc2tiID0gaWVlZTgw
MjExX2JlYWNvbl9nZXQod3ZpZi0+d2Rldi0+aHcsIHd2aWYtPnZpZik7CisJY29uc3QgaW50IGll
b2Zmc2V0ID0gb2Zmc2V0b2Yoc3RydWN0IGllZWU4MDIxMV9tZ210LCB1LmJlYWNvbi52YXJpYWJs
ZSk7CisJY29uc3QgdTE2ICpwdHIgPSAodTE2ICopY2ZnODAyMTFfZmluZF9pZShXTEFOX0VJRF9S
U04sCisJCQkJCQkgc2tiLT5kYXRhICsgaWVvZmZzZXQsCisJCQkJCQkgc2tiLT5sZW4gLSBpZW9m
ZnNldCk7CisJY29uc3QgaW50IHBhaXJ3aXNlX2NpcGhlcl9zdWl0ZV9jb3VudF9vZmZzZXQgPSA4
IC8gc2l6ZW9mKHUxNik7CisJY29uc3QgaW50IHBhaXJ3aXNlX2NpcGhlcl9zdWl0ZV9zaXplID0g
NCAvIHNpemVvZih1MTYpOworCWNvbnN0IGludCBha21fc3VpdGVfc2l6ZSA9IDQgLyBzaXplb2Yo
dTE2KTsKKworCWlmIChwdHIpIHsKKwkJcHRyICs9IHBhaXJ3aXNlX2NpcGhlcl9zdWl0ZV9jb3Vu
dF9vZmZzZXQ7CisJCWlmIChXQVJOX09OKHB0ciA+ICh1MTYgKilza2JfdGFpbF9wb2ludGVyKHNr
YikpKQorCQkJcmV0dXJuOworCQlwdHIgKz0gMSArIHBhaXJ3aXNlX2NpcGhlcl9zdWl0ZV9zaXpl
ICogKnB0cjsKKwkJaWYgKFdBUk5fT04ocHRyID4gKHUxNiAqKXNrYl90YWlsX3BvaW50ZXIoc2ti
KSkpCisJCQlyZXR1cm47CisJCXB0ciArPSAxICsgYWttX3N1aXRlX3NpemUgKiAqcHRyOworCQlp
ZiAoV0FSTl9PTihwdHIgPiAodTE2ICopc2tiX3RhaWxfcG9pbnRlcihza2IpKSkKKwkJCXJldHVy
bjsKKwkJaGlmX3NldF9tZnAod3ZpZiwgKnB0ciAmIEJJVCg3KSwgKnB0ciAmIEJJVCg2KSk7CisJ
fQorfQorCiBpbnQgd2Z4X3N0YXJ0X2FwKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3Qg
aWVlZTgwMjExX3ZpZiAqdmlmKQogewogCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gKHN0cnVjdCB3
ZnhfdmlmICopdmlmLT5kcnZfcHJpdjsKQEAgLTQ4OCw2ICs1MTMsNyBAQCBpbnQgd2Z4X3N0YXJ0
X2FwKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQog
CXJldCA9IGhpZl9zdGFydCh3dmlmLCAmdmlmLT5ic3NfY29uZiwgd3ZpZi0+Y2hhbm5lbCk7CiAJ
aWYgKHJldCA+IDApCiAJCXJldHVybiAtRUlPOworCXdmeF9zZXRfbWZwX2FwKHd2aWYpOwogCXJl
dHVybiByZXQ7CiB9CiAKLS0gCjIuMjguMAoK
