Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DDD25F819
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgIGKQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:16:20 -0400
Received: from mail-eopbgr770058.outbound.protection.outlook.com ([40.107.77.58]:18596
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728524AbgIGKPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:15:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bMey+gz+G8ZFnBVhWNhZPlGPyUVOaGQTRZt6n3fXhPOT69NgyD++kkoC4APsrpwujhtkuGNCeKcA2CwOf5Wc7RR0nrzbDGHZexFvUWPlwSnVbZjVX2s2sm1muSU1xRhptapgSNxmIaj15B0GGX1jhBHj0oMXYgrTuxQMUEC5Pg8HP5ecmKJRZBgigNshRWM1gdymp0gRzqEo3ernkj2W6W4bQkAvB1Mr6jiwUCvsE/3u816nk3ulXSVu4o1DxbeaL/s2WpkWGw8nmX7QMhIWjBa3gqYYWH8Nv/UbJxCG+AwQuzE1fKxFDk/9W9Ql2tD9HjpPAFMugRgYDA0/s5pj6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lG4N+ZCAjhIEwblMAIWNjkT8FzQkA7YkgRQ+/QD2z+4=;
 b=FZHlJ6c7AOEnkYKMw3ptikBgVEZsJCRQIqkBLFxxF5t4JxvPBCGfCArG8dqGDJDLVVuXRGFvtf72zDYPcfZimOyKqNhhVrnc37uzf8bU0YhtGAO7bYdfOzYLeBMqtQ6qTuAY2FOPI8RVRTFOuW9SZVQQa1/K+YnZADLNjK4uoNzwIYK7PUTSIZPnJtyPKou4Xxzs5Rvpqgka5L5yiKtcON0AN4BaVU5PND4Y8txEh4rtx1k8KjSlYppjuIRVD+3QiI36ZhFoN53AuGcc2fE74b5xboEpQjWmqi4iaDUd5T1NEq4TxDUmIiCBRi23g1lO5tOaXpOw0swwXc/FFH3pSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lG4N+ZCAjhIEwblMAIWNjkT8FzQkA7YkgRQ+/QD2z+4=;
 b=QrHGsC2VLp8ZB0UAKbs1D4yC6wGALM20WGgl9/AevuZaihJVMKS/ZCrcflmbrE/Ez13YaR5TRN/Kt1sjtsvSr8B2t5sq7I51V2DvSHlz+nZd3RUH2ozH7XELQ9TkwRkQOOxccW3dUGOUJzp8YIaHO9WtWo3HUZ1Vmuk7ceY1Vow=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2606.namprd11.prod.outlook.com (2603:10b6:805:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Mon, 7 Sep
 2020 10:15:47 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:15:47 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 02/31] staging: wfx: relocate wfx_join() beside wfx_join_finalize()
Date:   Mon,  7 Sep 2020 12:14:52 +0200
Message-Id: <20200907101521.66082-3-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:15:45 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c15e049d-bc57-4eeb-ec28-08d85316fd02
X-MS-TrafficTypeDiagnostic: SN6PR11MB2606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2606C88659FB8F76D5473D0693280@SN6PR11MB2606.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 72Sp/MfNuas5b9iCu9GJuwog1/vwLVFaKRnjuD83BpG55fHZEB3TBlyRBHynw4VYsgWuP5qGn8YoIXgLyFXblWPSYRc0+Da68RQmJ0a2Mqpma7LgIC//o0oNbLT9aSO2+GKJ+NElZCgT7sSnaGxrUJ3BdZoHsdsfvQg/c+/O6LJZn8tdJewQKr1zPg7F7cwGvgDBPn7uhv8xFLDhVJrZen1zak+DswRd9VJGsrTwbqd62E4To6dOmduc6bZrqLYRoXykih0MbthQgiKs6MA9nHXNpuyCN7ry6wH/CxY5y5l9A8I/rPx9MsZMigTb3tSxMldo586vUX+intQxEdv1mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(136003)(39850400004)(66946007)(4326008)(5660300002)(2616005)(66476007)(316002)(956004)(478600001)(6666004)(54906003)(52116002)(2906002)(66556008)(1076003)(36756003)(8676002)(86362001)(6486002)(8936002)(7696005)(66574015)(83380400001)(26005)(107886003)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TeESUgAIkp5iGygOXN28BV80Ya34fLYjcvoLFvNMImDv0dfvjtRgugTprPfMpX11wyrsNHb50Ej13QPv9WV3tgKL9l3oS71XCtHMBWInEWNZlo6r9LByHD9C0EER2v7naKBwl+9ZFPQxe2EsDVWuRnO1GLLUay7t80w/bLXw/AFNokuLryEGcEUNrRX743P379TzsPGLWygXfFUkZAZQXlIMJx+tUT9iNgtZQQXHxAt+Fyy+U6pd4+zbNFU9HXMhfQjzgiX5Tn7BypM0EKwIowQJ2KgU0nvm3KjvfkOIUWJTR2InY2M3ObzgeTm+VjpRs5bHVh6ziXTRJPpTySgXLluuJ5VE04e2ptTUbWXicHMvJ2VtIqcumCERML82MOzIvoAQiqLD40PZhrcmip/OFmJ2ZPltCZ2epgbNy8/yekmLDP+2i0ivi/cM26Gwisw6ScoBgZ1XUVXo1XBDChVLjhuUv0JpHSqzw5nDAtp0c8xsyF6dGjjOWiIhMJyPCAdWjOZ2UpFpEbwNke/O05vWcRumdHCYDi3tl12IB3/te0bWqEgRlXaG97U63T2Rdgix2LJi8EneL98tGiT6bMtVuJD2xqm2chyfb/eHkV3/fjaYAnd5v7pIR6ye2RtdfXJlR770OxDtyACTsuTdubmgjw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c15e049d-bc57-4eeb-ec28-08d85316fd02
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:15:47.3947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x91OlafsgrT/214h86THXYGfFvPzhEcg0p7kdFfha23OUjzbVchuI2QoGL8KpyOarAwYRgxjjOeIR6U9tDjx6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X2pvaW4oKSBhbmQgd2Z4X2pvaW5fZmluYWxpemUoKSBhcmUgdGhlIHR3byBoYWx2ZXMgb2YgdGhl
IGFzc29jaWF0aW9uCnByb2Nlc3MuIEdyb3VwIHRoZW0uCgpJbiBhZGRpdGlvbiwgZm9yIGJldHRl
ciB1bmlmb3JtaXR5IG9mIHRoZSBjb2RlLCByZW5hbWUgd2Z4X2RvX2pvaW4oKSBpbgp3Znhfam9p
bigpLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBz
aWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCAxMDAgKysrKysrKysr
KysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA1MCBpbnNlcnRp
b25zKCspLCA1MCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCA1MDI5Njc4NzQzNzMuLmIy
YTI5YjJhYzIwYyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC0zNDAsNTQgKzM0MCw2IEBAIHZvaWQgd2Z4X3Jl
c2V0KHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogCQl3ZnhfdXBkYXRlX3BtKHd2aWYpOwogfQogCi1z
dGF0aWMgdm9pZCB3ZnhfZG9fam9pbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKLXsKLQlpbnQgcmV0
OwotCXN0cnVjdCBpZWVlODAyMTFfYnNzX2NvbmYgKmNvbmYgPSAmd3ZpZi0+dmlmLT5ic3NfY29u
ZjsKLQlzdHJ1Y3QgY2ZnODAyMTFfYnNzICpic3MgPSBOVUxMOwotCXU4IHNzaWRbSUVFRTgwMjEx
X01BWF9TU0lEX0xFTl07Ci0JY29uc3QgdTggKnNzaWRpZSA9IE5VTEw7Ci0JaW50IHNzaWRsZW4g
PSAwOwotCi0Jd2Z4X3R4X2xvY2tfZmx1c2god3ZpZi0+d2Rldik7Ci0KLQlic3MgPSBjZmc4MDIx
MV9nZXRfYnNzKHd2aWYtPndkZXYtPmh3LT53aXBoeSwgd3ZpZi0+Y2hhbm5lbCwKLQkJCSAgICAg
ICBjb25mLT5ic3NpZCwgTlVMTCwgMCwKLQkJCSAgICAgICBJRUVFODAyMTFfQlNTX1RZUEVfQU5Z
LCBJRUVFODAyMTFfUFJJVkFDWV9BTlkpOwotCWlmICghYnNzICYmICFjb25mLT5pYnNzX2pvaW5l
ZCkgewotCQl3ZnhfdHhfdW5sb2NrKHd2aWYtPndkZXYpOwotCQlyZXR1cm47Ci0JfQotCi0JcmN1
X3JlYWRfbG9jaygpOyAvLyBwcm90ZWN0IHNzaWRpZQotCWlmIChic3MpCi0JCXNzaWRpZSA9IGll
ZWU4MDIxMV9ic3NfZ2V0X2llKGJzcywgV0xBTl9FSURfU1NJRCk7Ci0JaWYgKHNzaWRpZSkgewot
CQlzc2lkbGVuID0gc3NpZGllWzFdOwotCQlpZiAoc3NpZGxlbiA+IElFRUU4MDIxMV9NQVhfU1NJ
RF9MRU4pCi0JCQlzc2lkbGVuID0gSUVFRTgwMjExX01BWF9TU0lEX0xFTjsKLQkJbWVtY3B5KHNz
aWQsICZzc2lkaWVbMl0sIHNzaWRsZW4pOwotCX0KLQlyY3VfcmVhZF91bmxvY2soKTsKLQotCWNm
ZzgwMjExX3B1dF9ic3Mod3ZpZi0+d2Rldi0+aHctPndpcGh5LCBic3MpOwotCi0Jd3ZpZi0+am9p
bl9pbl9wcm9ncmVzcyA9IHRydWU7Ci0JcmV0ID0gaGlmX2pvaW4od3ZpZiwgY29uZiwgd3ZpZi0+
Y2hhbm5lbCwgc3NpZCwgc3NpZGxlbik7Ci0JaWYgKHJldCkgewotCQlpZWVlODAyMTFfY29ubmVj
dGlvbl9sb3NzKHd2aWYtPnZpZik7Ci0JCXdmeF9yZXNldCh3dmlmKTsKLQl9IGVsc2UgewotCQkv
KiBEdWUgdG8gYmVhY29uIGZpbHRlcmluZyBpdCBpcyBwb3NzaWJsZSB0aGF0IHRoZQotCQkgKiBB
UCdzIGJlYWNvbiBpcyBub3Qga25vd24gZm9yIHRoZSBtYWM4MDIxMSBzdGFjay4KLQkJICogRGlz
YWJsZSBmaWx0ZXJpbmcgdGVtcG9yYXJ5IHRvIG1ha2Ugc3VyZSB0aGUgc3RhY2sKLQkJICogcmVj
ZWl2ZXMgYXQgbGVhc3Qgb25lCi0JCSAqLwotCQl3ZnhfZmlsdGVyX2JlYWNvbih3dmlmLCBmYWxz
ZSk7Ci0JfQotCXdmeF90eF91bmxvY2sod3ZpZi0+d2Rldik7Ci19Ci0KIGludCB3Znhfc3RhX2Fk
ZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAkJ
c3RydWN0IGllZWU4MDIxMV9zdGEgKnN0YSkKIHsKQEAgLTQ5Niw2ICs0NDgsNTQgQEAgdm9pZCB3
Znhfc3RvcF9hcChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYg
KnZpZikKIAl3ZnhfcmVzZXQod3ZpZik7CiB9CiAKK3N0YXRpYyB2b2lkIHdmeF9qb2luKHN0cnVj
dCB3ZnhfdmlmICp3dmlmKQoreworCWludCByZXQ7CisJc3RydWN0IGllZWU4MDIxMV9ic3NfY29u
ZiAqY29uZiA9ICZ3dmlmLT52aWYtPmJzc19jb25mOworCXN0cnVjdCBjZmc4MDIxMV9ic3MgKmJz
cyA9IE5VTEw7CisJdTggc3NpZFtJRUVFODAyMTFfTUFYX1NTSURfTEVOXTsKKwljb25zdCB1OCAq
c3NpZGllID0gTlVMTDsKKwlpbnQgc3NpZGxlbiA9IDA7CisKKwl3ZnhfdHhfbG9ja19mbHVzaCh3
dmlmLT53ZGV2KTsKKworCWJzcyA9IGNmZzgwMjExX2dldF9ic3Mod3ZpZi0+d2Rldi0+aHctPndp
cGh5LCB3dmlmLT5jaGFubmVsLAorCQkJICAgICAgIGNvbmYtPmJzc2lkLCBOVUxMLCAwLAorCQkJ
ICAgICAgIElFRUU4MDIxMV9CU1NfVFlQRV9BTlksIElFRUU4MDIxMV9QUklWQUNZX0FOWSk7CisJ
aWYgKCFic3MgJiYgIWNvbmYtPmlic3Nfam9pbmVkKSB7CisJCXdmeF90eF91bmxvY2sod3ZpZi0+
d2Rldik7CisJCXJldHVybjsKKwl9CisKKwlyY3VfcmVhZF9sb2NrKCk7IC8vIHByb3RlY3Qgc3Np
ZGllCisJaWYgKGJzcykKKwkJc3NpZGllID0gaWVlZTgwMjExX2Jzc19nZXRfaWUoYnNzLCBXTEFO
X0VJRF9TU0lEKTsKKwlpZiAoc3NpZGllKSB7CisJCXNzaWRsZW4gPSBzc2lkaWVbMV07CisJCWlm
IChzc2lkbGVuID4gSUVFRTgwMjExX01BWF9TU0lEX0xFTikKKwkJCXNzaWRsZW4gPSBJRUVFODAy
MTFfTUFYX1NTSURfTEVOOworCQltZW1jcHkoc3NpZCwgJnNzaWRpZVsyXSwgc3NpZGxlbik7CisJ
fQorCXJjdV9yZWFkX3VubG9jaygpOworCisJY2ZnODAyMTFfcHV0X2Jzcyh3dmlmLT53ZGV2LT5o
dy0+d2lwaHksIGJzcyk7CisKKwl3dmlmLT5qb2luX2luX3Byb2dyZXNzID0gdHJ1ZTsKKwlyZXQg
PSBoaWZfam9pbih3dmlmLCBjb25mLCB3dmlmLT5jaGFubmVsLCBzc2lkLCBzc2lkbGVuKTsKKwlp
ZiAocmV0KSB7CisJCWllZWU4MDIxMV9jb25uZWN0aW9uX2xvc3Mod3ZpZi0+dmlmKTsKKwkJd2Z4
X3Jlc2V0KHd2aWYpOworCX0gZWxzZSB7CisJCS8qIER1ZSB0byBiZWFjb24gZmlsdGVyaW5nIGl0
IGlzIHBvc3NpYmxlIHRoYXQgdGhlCisJCSAqIEFQJ3MgYmVhY29uIGlzIG5vdCBrbm93biBmb3Ig
dGhlIG1hYzgwMjExIHN0YWNrLgorCQkgKiBEaXNhYmxlIGZpbHRlcmluZyB0ZW1wb3JhcnkgdG8g
bWFrZSBzdXJlIHRoZSBzdGFjaworCQkgKiByZWNlaXZlcyBhdCBsZWFzdCBvbmUKKwkJICovCisJ
CXdmeF9maWx0ZXJfYmVhY29uKHd2aWYsIGZhbHNlKTsKKwl9CisJd2Z4X3R4X3VubG9jayh3dmlm
LT53ZGV2KTsKK30KKwogc3RhdGljIHZvaWQgd2Z4X2pvaW5fZmluYWxpemUoc3RydWN0IHdmeF92
aWYgKnd2aWYsCiAJCQkgICAgICBzdHJ1Y3QgaWVlZTgwMjExX2Jzc19jb25mICppbmZvKQogewpA
QCAtNTE0LDcgKzUxNCw3IEBAIGludCB3Znhfam9pbl9pYnNzKHN0cnVjdCBpZWVlODAyMTFfaHcg
Kmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQogCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0g
KHN0cnVjdCB3ZnhfdmlmICopdmlmLT5kcnZfcHJpdjsKIAogCXdmeF91cGxvYWRfYXBfdGVtcGxh
dGVzKHd2aWYpOwotCXdmeF9kb19qb2luKHd2aWYpOworCXdmeF9qb2luKHd2aWYpOwogCXJldHVy
biAwOwogfQogCkBAIC01NTEsNyArNTUxLDcgQEAgdm9pZCB3ZnhfYnNzX2luZm9fY2hhbmdlZChz
dHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAkgICAg
Y2hhbmdlZCAmIEJTU19DSEFOR0VEX0JFQUNPTl9JTlQgfHwKIAkgICAgY2hhbmdlZCAmIEJTU19D
SEFOR0VEX0JTU0lEKSB7CiAJCWlmICh2aWYtPnR5cGUgPT0gTkw4MDIxMV9JRlRZUEVfU1RBVElP
TikKLQkJCXdmeF9kb19qb2luKHd2aWYpOworCQkJd2Z4X2pvaW4od3ZpZik7CiAJfQogCiAJaWYg
KGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9BU1NPQykgewotLSAKMi4yOC4wCgo=
