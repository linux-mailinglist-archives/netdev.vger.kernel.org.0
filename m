Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F1F1AAD30
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415307AbgDOQNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:13:22 -0400
Received: from mail-bn8nam12on2054.outbound.protection.outlook.com ([40.107.237.54]:6138
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1415283AbgDOQNK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 12:13:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q1E0cEk98TzceWzFUJar17EXYgo4v9EbquiufJxHRByZ0osB3pAcUwCghW1MJN8DMrngE/VIQwtmGE8Pz/ckZ/0TsTPELLjqBNW3hqVKzdvIqA56+Y2LH311DpUfCleUY2fceiHIOUY2by2vVhw5yxkcIIpxGDjSoWWlexljNDn9w5F+zpqwfrCD5CK+FbTQVED5ianxxVGXvfrz72nqyXO8fE/Oi98IFsQajHaL9/AwWAMCJR3uRlkdZD9Ztu+74Tpk/UwTKftSALuJmtvd8FnR8mLLfscpon+2H2EX0bhtVyG5nUxMjoXOWGs0X8JQ6JR+JQYnZx54d/ygQIL02Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsbkUgcUeGdRTqhef3y/aDNfj8Oubyo7xIeAbS3xLSs=;
 b=gKHAiZHoB/GcZpWsN+2tX44eLmkSjoDmfFnw4eXI6cZcmTlbRIrNX2koJ1zj/NvE2kbxgB2NHy0NU62de9f9f9CPRx31bywGF3JUIgUOv1fOUTsM/S3G+DcVw64swz2WXC0a5GcdVl/LLPzZQmtvevfqCXiqwvQE08Chrqp4nnvbg+aMToP5VfQPx1At1RlYoMUzfgP2PV6opIevr/jjBIlxxHGd38SL3uUVWMd1CZsUlYd9zSSQJ5XcwxVgLN+9KWmNGkBnSYT0yGGvFJuTV+wjpy58fVHEllXNmlawsDJDQnI/bLj/kM3HdDB3I0XLQaJN9wp5ErEUwveYMGzqAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsbkUgcUeGdRTqhef3y/aDNfj8Oubyo7xIeAbS3xLSs=;
 b=fjb8QMtCVfcXDuPVp9HwY8uzuOdRar+D8R+jtFcs+/RVDeL7ORC6RszMJUW/beqLEjOoRdotaijoWs8tM5tgonJt+Gx+D8qT1aSD6n1gtGTDNMeekfZSBBIRjhvbfcO0r1NfVAhoY6FRvPAaoI0Igx9bVx06oJ7fL9cJvcZMMTU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1327.namprd11.prod.outlook.com (2603:10b6:300:2a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Wed, 15 Apr
 2020 16:13:01 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.024; Wed, 15 Apr
 2020 16:13:01 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 19/20] staging: wfx: drop useless attribute 'filter_mcast'
Date:   Wed, 15 Apr 2020 18:11:46 +0200
Message-Id: <20200415161147.69738-20-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
References: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1PR01CA0027.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::40) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0027.eurprd01.prod.exchangelabs.com (2603:10a6:102::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Wed, 15 Apr 2020 16:12:59 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 653e8c42-c6e2-409e-9708-08d7e157de7c
X-MS-TrafficTypeDiagnostic: MWHPR11MB1327:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1327C6DF0C94170BA4DB128793DB0@MWHPR11MB1327.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(39850400004)(136003)(346002)(366004)(376002)(396003)(4326008)(81156014)(107886003)(52116002)(54906003)(8676002)(478600001)(8936002)(6506007)(5660300002)(6512007)(36756003)(8886007)(86362001)(316002)(6486002)(1076003)(2616005)(186003)(2906002)(66574012)(6666004)(66556008)(16526019)(66946007)(66476007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IbMqQ+lEiGZsEiHsxPBYsdJbSNhq+8Ai4xGEydt9Yxmnd9cP940JKzIdAaIopnmY/Oj1Wy4ngom47tzl+Sk3IAi8KMCGuhfDr9tQJrI8FwlYNLXjPl8bVn7wvlrvamdRJSb01QSwmJpo/DTknxM2l1i80Wlp1y5NJS5pNnUry4ckorMW3CLtOBdnfsCjOI7uSvAKtE+1hjGkK9FMcJaTYqBE3vV/Y/awJXP2wRRULg/YVX0Na/pFPRt4/QcybBloSEd4RpSoZgQ9zN2jb//TwUPR2ftQiIXRdjCT/gbYygMrvV+KdV+Vesua6piQFzJnhFiHLvmc5vnIuzuxMjw+3yGuH2K3VX0KdiMxhPfoQYKsUBd5NBbxtj6glHNtkBrABNCudInB3gK1wWmMM1uyC7oawQAqMnFk0SJb0e+yJiSCjciK3xKNEXT7WlLuv3vJ
X-MS-Exchange-AntiSpam-MessageData: /TQTZLruHrb9A2XwDLiNWnFTYum4zpLO/3Dvma4q3otY/Y2LMEI1yQ3HvB+wKknQOWZj/bYGMzWgZ/Sc02Nzcm4V2A2fpH/o+6d5R1IyH+cc6wcZxFo1oGQKgTCmJWwF1qi8Wp08pd9IuZUFNbE0yKOSILJk8oHzJTyCx4bupyhtaEDL/gGXlg7pyT9h8ej+U1b9ORmS3SpkCBkGhmXTmg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 653e8c42-c6e2-409e-9708-08d7e157de7c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 16:13:00.9674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d7ntAbVaNDycO62Q4VYLi1ljJqyQxGoAkPs4siUtoaPLFiLabIVlP4KQR0HgUCxFG6a9IZlJ9QEf9FrmiUDwYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1327
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ3Vy
cmVudGx5LCB3ZnhfdXBkYXRlX2ZpbHRlcmluZygpIGFwcGx5IHRoZSB2YWx1ZSBvZiB3dmlmLT5m
aWx0ZXJfbWNhc3QKdG8gdGhlIGhhcmR3YXJlLiBCdXQgYW4gYXR0ZW50aXZlIHJlYWRlciB3aWxs
IG5vdGUgdGhhdAp3ZnhfdXBkYXRlX2ZpbHRlcmluZygpIGlzIGFsd2F5cyBjYWxsZWQgYWZ0ZXIg
c2V0IHd2aWYtPmZpbHRlcl9tY2FzdC4KVGh1cywgaXQgbm90IG5lY2Vzc2FyeSB0byBzdG9yZSBm
aWx0ZXJfbWNhc3QgaW4gdGhlIHN0cnVjdCB3ZnhfdmlmLiBXZQpjYW4ganVzdCBwYXNzIGl0IGFz
IHBhcmFtZXRlci4KCkFsc28gcmVuYW1lIHdmeF91cGRhdGVfZmlsdGVyaW5nKCkgaW4gd2Z4X2Zp
bHRlcl9tY2FzdCgpIHRvIHJlZmxlY3QgdGhpcwpjaGFuZ2UuCgpTaWduZWQtb2ZmLWJ5OiBKw6ly
w7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYyB8IDE0ICsrKysrKystLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L3dmeC5oIHwgIDEgLQogMiBmaWxlcyBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDggZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMKaW5kZXggNjlhNTgyM2FmMjg0Li5jNzNkYmIzYTBkZTggMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYwpAQCAtMTQ0LDcgKzE0NCw3IEBAIHN0YXRpYyB2b2lkIHdmeF9maWx0ZXJfYmVhY29u
KHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBib29sIGZpbHRlcl9iZWFjb24pCiAJfQogfQogCi12b2lk
IHdmeF91cGRhdGVfZmlsdGVyaW5nKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQorc3RhdGljIHZvaWQg
d2Z4X2ZpbHRlcl9tY2FzdChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBmaWx0ZXJfbWNhc3Qp
CiB7CiAJaW50IGk7CiAKQEAgLTE1Miw3ICsxNTIsNyBAQCB2b2lkIHdmeF91cGRhdGVfZmlsdGVy
aW5nKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogCWhpZl9zZXRfZGF0YV9maWx0ZXJpbmcod3ZpZiwg
ZmFsc2UsIHRydWUpOwogCXJldHVybjsKIAotCWlmICghd3ZpZi0+ZmlsdGVyX21jYXN0KSB7CisJ
aWYgKCFmaWx0ZXJfbWNhc3QpIHsKIAkJaGlmX3NldF9kYXRhX2ZpbHRlcmluZyh3dmlmLCBmYWxz
ZSwgdHJ1ZSk7CiAJCXJldHVybjsKIAl9CkBAIC0xOTgsNyArMTk4LDcgQEAgdm9pZCB3ZnhfY29u
ZmlndXJlX2ZpbHRlcihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIHsKIAlzdHJ1Y3Qgd2Z4X3Zp
ZiAqd3ZpZiA9IE5VTEw7CiAJc3RydWN0IHdmeF9kZXYgKndkZXYgPSBody0+cHJpdjsKLQlib29s
IGZpbHRlcl9ic3NpZCwgZmlsdGVyX3ByYnJlcSwgZmlsdGVyX2JlYWNvbjsKKwlib29sIGZpbHRl
cl9ic3NpZCwgZmlsdGVyX3ByYnJlcSwgZmlsdGVyX2JlYWNvbiwgZmlsdGVyX21jYXN0OwogCiAJ
Ly8gTm90ZXM6CiAJLy8gICAtIFByb2JlIHJlc3BvbnNlcyAoRklGX0JDTl9QUkJSRVNQX1BST01J
U0MpIGFyZSBuZXZlciBmaWx0ZXJlZApAQCAtMjIzLDE0ICsyMjMsMTQgQEAgdm9pZCB3ZnhfY29u
ZmlndXJlX2ZpbHRlcihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAkJd2Z4X2ZpbHRlcl9iZWFj
b24od3ZpZiwgZmlsdGVyX2JlYWNvbik7CiAKIAkJaWYgKCp0b3RhbF9mbGFncyAmIEZJRl9BTExN
VUxUSSkgewotCQkJd3ZpZi0+ZmlsdGVyX21jYXN0ID0gZmFsc2U7CisJCQlmaWx0ZXJfbWNhc3Qg
PSBmYWxzZTsKIAkJfSBlbHNlIGlmICghd3ZpZi0+ZmlsdGVyX21jYXN0X2NvdW50KSB7CiAJCQlk
ZXZfZGJnKHdkZXYtPmRldiwgImRpc2FibGluZyB1bmNvbmZpZ3VyZWQgbXVsdGljYXN0IGZpbHRl
ciIpOwotCQkJd3ZpZi0+ZmlsdGVyX21jYXN0ID0gZmFsc2U7CisJCQlmaWx0ZXJfbWNhc3QgPSBm
YWxzZTsKIAkJfSBlbHNlIHsKLQkJCXd2aWYtPmZpbHRlcl9tY2FzdCA9IHRydWU7CisJCQlmaWx0
ZXJfbWNhc3QgPSB0cnVlOwogCQl9Ci0JCXdmeF91cGRhdGVfZmlsdGVyaW5nKHd2aWYpOworCQl3
ZnhfZmlsdGVyX21jYXN0KHd2aWYsIGZpbHRlcl9tY2FzdCk7CiAKIAkJaWYgKCp0b3RhbF9mbGFn
cyAmIEZJRl9PVEhFUl9CU1MpCiAJCQlmaWx0ZXJfYnNzaWQgPSBmYWxzZTsKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCmlu
ZGV4IGMzMGU2OTg0YWVjMS4uYjVkMmQwZjA3NzQwIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3dmeC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKQEAgLTg5LDcgKzg5
LDYgQEAgc3RydWN0IHdmeF92aWYgewogCiAJaW50CQkJZmlsdGVyX21jYXN0X2NvdW50OwogCXU4
CQkJZmlsdGVyX21jYXN0X2FkZHJbOF1bRVRIX0FMRU5dOwotCWJvb2wJCQlmaWx0ZXJfbWNhc3Q7
CiAKIAl1bnNpZ25lZCBsb25nCQl1YXBzZF9tYXNrOwogCXN0cnVjdCBoaWZfcmVxX3NldF9ic3Nf
cGFyYW1zIGJzc19wYXJhbXM7Ci0tIAoyLjI1LjEKCg==
