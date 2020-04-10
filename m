Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C09111A46CE
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 15:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgDJNdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 09:33:19 -0400
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:31903
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726736AbgDJNdK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 09:33:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwQDGfMX4PsUqgJbqstIquk6jnhTzUV9dqaaPW6sxPau8hzzt4+nyOxt5YcFacfR4OwhpO+3u4HXqbfvohfhv4ui9YXMTRQ1eu1Y4ux2fRYlpEUhrR9tJNHo2iYsD9dz24w5DFIGqsdcZwA2IC5sntIz1jb5udDnGSiLwboK4mcOLaukxFmHBZ8ZzaxGX821Bf0va/WZ3H6x5dAz1A8prB9UxbmntmP3uW3u9rBffHtt1vZRL3gkOnataIgTlX93oAxQcQIxXWQSOPEsp4d06mIK0nEx8zgCqDQqVZMqPNP61KUONqLRBjJKuMORJU5IZP0OHOUrkR6wE2Ovdx+JWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTWwGJH09pN8XlCnBCa0KrZ764zg9F0XkewSiHFKMqk=;
 b=M9uQ382M+U+mpmCls03w6GbOszoqD98oC1wvtkEmNu7Wq+6iXE7TZdsuOyi9+zA0AjTSMViLkGbIu8qo1+0xsub0hGPgqQooET4cTnZe0+J4xriopqR8lp31p4Ba68Sq5pP/lwV/fQ6Iq+xhIWuMz2NR2IvTJi1yyCno3Gxvp+D4JlLG73kb391ppri3mMs2mATnv/t7/7nLHnU1n79CJvqSiwM1ljjShrL7MjLVO1MhhKVlZBvBLfofiz3xquYYol+sz3ehdj9ZEr9eP7uhtq+mtpPymmDFg+BJjcG14kHsRXLJlYxD2BMSZ1zHiXEt9rwDsQGJgWZyieCyox0h4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTWwGJH09pN8XlCnBCa0KrZ764zg9F0XkewSiHFKMqk=;
 b=Y3Q+dqX/YyBK1sEaX/xp8ZXnn9YW9CqXUSACSivxhMtVfq5gNalJsOvNx529npiSeK64lIRf4QBoMSa0ZN1m/7M59R2VAFGLqM3w6kKbgZeD+vocoyS2ptEekVmcGnpUlxsOl8q3YEhBd9fb+u4iavjfxkjtgc28FG7Fo/TactA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4398.namprd11.prod.outlook.com (2603:10b6:208:18b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Fri, 10 Apr
 2020 13:33:07 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1%6]) with mapi id 15.20.2878.021; Fri, 10 Apr 2020
 13:33:06 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 04/19] staging: wfx: implement start_ap/stop_ap
Date:   Fri, 10 Apr 2020 15:32:24 +0200
Message-Id: <20200410133239.438347-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200410133239.438347-1-Jerome.Pouiller@silabs.com>
References: <20200410133239.438347-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR15CA0056.namprd15.prod.outlook.com
 (2603:10b6:3:ae::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by DM5PR15CA0056.namprd15.prod.outlook.com (2603:10b6:3:ae::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 13:33:04 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 482c5beb-2b49-4029-1907-08d7dd53b3cf
X-MS-TrafficTypeDiagnostic: MN2PR11MB4398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4398B02CEFF468016E1A080393DE0@MN2PR11MB4398.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:873;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(346002)(396003)(136003)(39850400004)(376002)(107886003)(81156014)(54906003)(8676002)(86362001)(1076003)(6666004)(8936002)(4326008)(52116002)(66574012)(7696005)(316002)(66556008)(66946007)(186003)(478600001)(2906002)(6486002)(2616005)(66476007)(16526019)(5660300002)(36756003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s3K9QEfDdYRK+o4WItPcxLdt2marRT15Hp3SzLTXJ/l5Mo7wLTZ39p1wxUXhxUhcHoPDkxSMpphVUXFe+qdXU2I6N2kHyzMw/vxUezPO5DIzlyinhbVruE1Eb6kGZXFBpBF5r0PEeJNCPVpwUWuEutOsztNdFWxCbBfXP50tS1AoLaJjuV2LRnbv434h3Hpk4iaxvAsbXVmBuYpBgpzgeyPbPlk/XURr+9VHycL0wgmGKFCA3WWb98yxwa4Boy0pRen7T9qWM4HuAtnFEyWcqhilS2hsrCIqkmKopzupOMCKmStwMFqHnp6zRhXV/OFW/iyCW3h5IGrrs2e7wsfbmG5sUTFGemNz+T66OcQmmFRuIcAwqRjcPHBqpb91tkp+/3/N1Mr4lsYuyRYkqmatX+9Q0Em5JLfk3kZ+h127GSqeYawkq5K2fcltQgE3TCR8
X-MS-Exchange-AntiSpam-MessageData: lO1oduP9R8FxYxxH1cT0Bp+sXvjcEUsSUlvZTHikajZ++0tq/XSardirj8Jxy6q3VtAL7AYleyxHPJn9bohFIYc+ntH983qLJ36R7JyGbDyy8dg/YPp3x1ZA90u+iTzus1Q/16/iMbrzmVsvKHTaIlBLy+n+1L67yQ+xTgf3YGPo2tkjW9vY0qg6xfzUORRLfG/iXxcPcT7YB5L7JSOCrQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 482c5beb-2b49-4029-1907-08d7dd53b3cf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 13:33:06.8000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QjOiiiYJ4nMeq+6U2/Ku/oE3wvJtamBhE/uTy4hH/xiZ+GFec1WcIgPd7NWQxQcd22sx4nXTFdum9lLw1+ZyaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4398
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ3Vy
cmVudGx5LCB3ZnhfYnNzX2luZm9fY2hhbmdlZCgpIGNoZWNrIGludGVyZmFjZSBzdGF0dXMgY2hh
bmdlcyBhbmQKZ3Vlc3Mgd2hlbiB0aGUgcGF0dGVybiBtYXRjaCB3aXRoIGFuIEFQIHN0YXJ0IGFu
ZCBBUCBzdG9wICh0aHJvdWdoCndmeF91cGRhdGVfYmVhY29uaW5nKCkpLiBJdCBpcyBmYXIgZWFz
aWVyIHRvIHJlbHkgb24gc3RhcnRfYXAgYW5kCnN0b3BfYXAgY2FsbGJhY2tzIHByb3ZpZGVkIGJ5
IG1hYzgwMjExLgoKd2Z4X2Jzc19pbmZvX2NoYW5nZWQoKSBrZWVwcyBvbmx5IHRoZSByZXNwb25z
aWJpbGl0eSBvZiB1cGRhdGluZyB0aGUKZnJhbWUgdGVtcGxhdGVzLgoKU2lnbmVkLW9mZi1ieTog
SsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZl
cnMvc3RhZ2luZy93ZngvbWFpbi5jIHwgIDIgKysKIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMg
IHwgNzEgKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmggIHwgIDIgKysKIDMgZmlsZXMgY2hhbmdlZCwgMzAgaW5zZXJ0aW9ucygr
KSwgNDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWlu
LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwppbmRleCAxZTlmNmRhNzUwMjQuLmI0NTlm
YWM5MjhmZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKKysrIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9tYWluLmMKQEAgLTEzNiw2ICsxMzYsOCBAQCBzdGF0aWMgY29uc3Qg
c3RydWN0IGllZWU4MDIxMV9vcHMgd2Z4X29wcyA9IHsKIAkuY29uZl90eAkJPSB3ZnhfY29uZl90
eCwKIAkuaHdfc2NhbgkJPSB3ZnhfaHdfc2NhbiwKIAkuY2FuY2VsX2h3X3NjYW4JCT0gd2Z4X2Nh
bmNlbF9od19zY2FuLAorCS5zdGFydF9hcAkJPSB3Znhfc3RhcnRfYXAsCisJLnN0b3BfYXAJCT0g
d2Z4X3N0b3BfYXAsCiAJLnN0YV9hZGQJCT0gd2Z4X3N0YV9hZGQsCiAJLnN0YV9yZW1vdmUJCT0g
d2Z4X3N0YV9yZW1vdmUsCiAJLnNldF90aW0JCT0gd2Z4X3NldF90aW0sCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRl
eCAzNmU1NWUzMmRhMmIuLjkyYmYzMTdiNTdiYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC01NzUsNDAgKzU3
NSw2IEBAIGludCB3Znhfc3RhX3JlbW92ZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0
IGllZWU4MDIxMV92aWYgKnZpZiwKIAlyZXR1cm4gMDsKIH0KIAotc3RhdGljIGludCB3Znhfc3Rh
cnRfYXAoc3RydWN0IHdmeF92aWYgKnd2aWYpCi17Ci0JaW50IHJldDsKLQotCXd2aWYtPmJlYWNv
bl9pbnQgPSB3dmlmLT52aWYtPmJzc19jb25mLmJlYWNvbl9pbnQ7Ci0JcmV0ID0gaGlmX3N0YXJ0
KHd2aWYsICZ3dmlmLT52aWYtPmJzc19jb25mLCB3dmlmLT5jaGFubmVsKTsKLQlpZiAocmV0KQot
CQlyZXR1cm4gcmV0OwotCXJldCA9IHdmeF91cGxvYWRfa2V5cyh3dmlmKTsKLQlpZiAocmV0KQot
CQlyZXR1cm4gcmV0OwotCWlmICh3dmlmX2NvdW50KHd2aWYtPndkZXYpIDw9IDEpCi0JCWhpZl9z
ZXRfYmxvY2tfYWNrX3BvbGljeSh3dmlmLCAweEZGLCAweEZGKTsKLQl3dmlmLT5zdGF0ZSA9IFdG
WF9TVEFURV9BUDsKLQl3ZnhfdXBkYXRlX2ZpbHRlcmluZyh3dmlmKTsKLQlyZXR1cm4gMDsKLX0K
LQotc3RhdGljIGludCB3ZnhfdXBkYXRlX2JlYWNvbmluZyhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikK
LXsKLQlpZiAod3ZpZi0+dmlmLT50eXBlICE9IE5MODAyMTFfSUZUWVBFX0FQKQotCQlyZXR1cm4g
MDsKLQlpZiAod3ZpZi0+c3RhdGUgPT0gV0ZYX1NUQVRFX0FQICYmCi0JICAgIHd2aWYtPmJlYWNv
bl9pbnQgPT0gd3ZpZi0+dmlmLT5ic3NfY29uZi5iZWFjb25faW50KQotCQlyZXR1cm4gMDsKLQl3
ZnhfdHhfbG9ja19mbHVzaCh3dmlmLT53ZGV2KTsKLQloaWZfcmVzZXQod3ZpZiwgZmFsc2UpOwot
CXdmeF90eF9wb2xpY3lfaW5pdCh3dmlmKTsKLQl3dmlmLT5zdGF0ZSA9IFdGWF9TVEFURV9QQVNT
SVZFOwotCXdmeF9zdGFydF9hcCh3dmlmKTsKLQl3ZnhfdHhfdW5sb2NrKHd2aWYtPndkZXYpOwot
CXJldHVybiAwOwotfQotCiBzdGF0aWMgaW50IHdmeF91cGxvYWRfYXBfdGVtcGxhdGVzKHN0cnVj
dCB3ZnhfdmlmICp3dmlmKQogewogCXN0cnVjdCBza19idWZmICpza2I7CkBAIC02MzQsNiArNjAw
LDMwIEBAIHN0YXRpYyBpbnQgd2Z4X3VwbG9hZF9hcF90ZW1wbGF0ZXMoc3RydWN0IHdmeF92aWYg
Knd2aWYpCiAJcmV0dXJuIDA7CiB9CiAKK2ludCB3Znhfc3RhcnRfYXAoc3RydWN0IGllZWU4MDIx
MV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYpCit7CisJc3RydWN0IHdmeF92aWYg
Knd2aWYgPSAoc3RydWN0IHdmeF92aWYgKil2aWYtPmRydl9wcml2OworCisJaGlmX3N0YXJ0KHd2
aWYsICZ2aWYtPmJzc19jb25mLCB3dmlmLT5jaGFubmVsKTsKKwl3ZnhfdXBsb2FkX2tleXMod3Zp
Zik7CisJaWYgKHd2aWZfY291bnQod3ZpZi0+d2RldikgPD0gMSkKKwkJaGlmX3NldF9ibG9ja19h
Y2tfcG9saWN5KHd2aWYsIDB4RkYsIDB4RkYpOworCXd2aWYtPnN0YXRlID0gV0ZYX1NUQVRFX0FQ
OworCXdmeF91cGRhdGVfZmlsdGVyaW5nKHd2aWYpOworCXdmeF91cGxvYWRfYXBfdGVtcGxhdGVz
KHd2aWYpOworCXdmeF9md2RfcHJvYmVfcmVxKHd2aWYsIGZhbHNlKTsKKwlyZXR1cm4gMDsKK30K
Kwordm9pZCB3Znhfc3RvcF9hcChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4
MDIxMV92aWYgKnZpZikKK3sKKwlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiA9IChzdHJ1Y3Qgd2Z4X3Zp
ZiAqKXZpZi0+ZHJ2X3ByaXY7CisKKwloaWZfcmVzZXQod3ZpZiwgZmFsc2UpOworCXdmeF90eF9w
b2xpY3lfaW5pdCh3dmlmKTsKKwl3dmlmLT5zdGF0ZSA9IFdGWF9TVEFURV9QQVNTSVZFOworfQor
CiBzdGF0aWMgdm9pZCB3Znhfam9pbl9maW5hbGl6ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAkJ
CSAgICAgIHN0cnVjdCBpZWVlODAyMTFfYnNzX2NvbmYgKmluZm8pCiB7CkBAIC03MDksMTYgKzY5
OSw5IEBAIHZvaWQgd2Z4X2Jzc19pbmZvX2NoYW5nZWQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcs
CiAJCX0KIAl9CiAKLQlpZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VEX0JFQUNPTiB8fAotCSAgICBj
aGFuZ2VkICYgQlNTX0NIQU5HRURfQVBfUFJPQkVfUkVTUCB8fAotCSAgICBjaGFuZ2VkICYgQlNT
X0NIQU5HRURfQlNTSUQgfHwKLQkgICAgY2hhbmdlZCAmIEJTU19DSEFOR0VEX1NTSUQgfHwKLQkg
ICAgY2hhbmdlZCAmIEJTU19DSEFOR0VEX0lCU1MpIHsKLQkJd3ZpZi0+YmVhY29uX2ludCA9IGlu
Zm8tPmJlYWNvbl9pbnQ7Ci0JCXdmeF91cGRhdGVfYmVhY29uaW5nKHd2aWYpOworCWlmIChjaGFu
Z2VkICYgQlNTX0NIQU5HRURfQVBfUFJPQkVfUkVTUCB8fAorCSAgICBjaGFuZ2VkICYgQlNTX0NI
QU5HRURfQkVBQ09OKQogCQl3ZnhfdXBsb2FkX2FwX3RlbXBsYXRlcyh3dmlmKTsKLQkJd2Z4X2Z3
ZF9wcm9iZV9yZXEod3ZpZiwgZmFsc2UpOwotCX0KIAogCWlmIChjaGFuZ2VkICYgQlNTX0NIQU5H
RURfQkVBQ09OX0VOQUJMRUQgJiYKIAkgICAgd3ZpZi0+c3RhdGUgIT0gV0ZYX1NUQVRFX0lCU1Mp
CkBAIC03NDIsOCArNzI1LDYgQEAgdm9pZCB3ZnhfYnNzX2luZm9fY2hhbmdlZChzdHJ1Y3QgaWVl
ZTgwMjExX2h3ICpodywKIAkJaWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9CRUFDT05fSU5UKSB7
CiAJCQlpZiAoaW5mby0+aWJzc19qb2luZWQpCiAJCQkJZG9fam9pbiA9IHRydWU7Ci0JCQllbHNl
IGlmICh3dmlmLT5zdGF0ZSA9PSBXRlhfU1RBVEVfQVApCi0JCQkJd2Z4X3VwZGF0ZV9iZWFjb25p
bmcod3ZpZik7CiAJCX0KIAogCQlpZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VEX0JTU0lEKQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmgKaW5kZXggYTBjNTE1M2U1MjcyLi42YTRiOTFhNDdmNWIgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvc3RhZ2luZy93Zngvc3RhLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaApAQCAt
NTQsNiArNTQsOCBAQCB2b2lkIHdmeF9jb25maWd1cmVfZmlsdGVyKHN0cnVjdCBpZWVlODAyMTFf
aHcgKmh3LCB1bnNpZ25lZCBpbnQgY2hhbmdlZF9mbGFncywKIAogaW50IHdmeF9hZGRfaW50ZXJm
YWNlKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKTsK
IHZvaWQgd2Z4X3JlbW92ZV9pbnRlcmZhY2Uoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVj
dCBpZWVlODAyMTFfdmlmICp2aWYpOworaW50IHdmeF9zdGFydF9hcChzdHJ1Y3QgaWVlZTgwMjEx
X2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZik7Cit2b2lkIHdmeF9zdG9wX2FwKHN0
cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKTsKIGludCB3
ZnhfY29uZl90eChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYg
KnZpZiwKIAkJdTE2IHF1ZXVlLCBjb25zdCBzdHJ1Y3QgaWVlZTgwMjExX3R4X3F1ZXVlX3BhcmFt
cyAqcGFyYW1zKTsKIHZvaWQgd2Z4X2Jzc19pbmZvX2NoYW5nZWQoc3RydWN0IGllZWU4MDIxMV9o
dyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCi0tIAoyLjI1LjEKCg==
