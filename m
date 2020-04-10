Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 910901A46D7
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 15:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgDJNdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 09:33:39 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:6130
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726942AbgDJNdh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 09:33:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YovpcFmK+jDED1+e8G3SuGO/x0Ar4eLUBT3w7a5k0W0JIZl35wGdx2Wws9et4T5gVYtBorguFMcxFT6BtOJoYNan70BZD7awEqmnaaPcc56sP7q8zK9srlY99vZb6XyMzBASQxrcTe7NIrqUuXzj6kUzs/8Os4RX78ciHdJbF/7Gll0fKJ9YyBJoJQgZaxNajrSDADpCab7uuMZK/TtSwtdrC3ochSfcc5O8e3ZS3j2YDhe8dzOKqpl5Bu+y4UDiw2TWBWMRepIles2Wsl0ugOvfhe888DsDD+NR6cwrLcubu2VPNBjJqfEqwRXXrLEzd2q2b3VxmTvgxmL9nSpioQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ytj3KOj2uc2Jm0eD6M5bgseZ83ZtTsywRSkzRnUx7fA=;
 b=M34BdCQlRoSF5JHJ5ZCO3d9ADLOTvsBi0Vm7fpxgOJ8sFvZemdX5pIJtI1ZRrfsrME+yAtyzPtvziSjFHCg5S0YP402R58W/0KIiEPKFT8ZCn3YYsoJAwNDlP7lce76HN1fcWckPAmO7biGmecUpaD1KgbiCjcEpR0rT4eGI8poJdHTofFETsJkqiGmGaXxkTKboyUMOKkV1qv7QpwrwaK7HdEEaejseSW3Svu3IIrfdPIzBL7XbyOtwjJlBB6RJZ2ZMAVZ3GNRtb67aCV5BLguT8Gt0smO09KzwWq7adwQMrWm1fPbJoFmLClgOOPS3n89Ldjgg6QKU2kJ01U+E0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ytj3KOj2uc2Jm0eD6M5bgseZ83ZtTsywRSkzRnUx7fA=;
 b=k8+c/z0o1Hs1brlqC5GGCUwP2tGD9aXpZbhQe4xttVTZyhsPTFrJALh30FDTOi/nKLeJq3XDd1I568tALzk7n3avoGR67Qm/zL5bSCsXB16QZcXAW2N6jJDuG8IaRm6rtBWJRrbWAG48f352CJctXlL11gEmJuilauD5dKqNR4c=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4398.namprd11.prod.outlook.com (2603:10b6:208:18b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Fri, 10 Apr
 2020 13:33:27 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1%6]) with mapi id 15.20.2878.021; Fri, 10 Apr 2020
 13:33:27 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 15/19] staging: wfx: introduce wfx_join_ibss() and wfx_leave_ibss()
Date:   Fri, 10 Apr 2020 15:32:35 +0200
Message-Id: <20200410133239.438347-16-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by DM5PR15CA0056.namprd15.prod.outlook.com (2603:10b6:3:ae::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 13:33:25 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8496dd1-fdda-4a50-8650-08d7dd53c02c
X-MS-TrafficTypeDiagnostic: MN2PR11MB4398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB43985F1F69D884A24224E05393DE0@MN2PR11MB4398.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(346002)(396003)(136003)(39850400004)(376002)(107886003)(81156014)(54906003)(8676002)(86362001)(1076003)(6666004)(8936002)(4326008)(52116002)(7696005)(316002)(66556008)(66946007)(186003)(478600001)(2906002)(6486002)(2616005)(66476007)(16526019)(5660300002)(36756003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hQPcOTnZhT4LOIS94SrGr7jvuWLmURWyjDY4jpMO8O2vVpJlflPrkK2UJQmGSMLcpMo3KMOUenZohQPHDmXaZSkq5hXroR9Rml+q+gjDQg+QQq9Y0gix/6Om6FKnUuDBQ+3ZCY1Nvv/KZUOkAeDrMALlJ8GBoEmG1Wo4KB6GySwOJJS4GAFz7kvMLj8tmKI0gvTfEpwogVttZeIC1JtfDAmkJOIvxcXF5uDp6MrCUSJ/PfNE/BIANf3k/x+3sD22NcfPwV26oz0fVjcXUQAzTuhDviRPvVDTsYMioBxPZ8ic14RUwnBC5fkiz6YHD5dz0695Akxk9LkT4jqOmAN7oiWXlXLBa+wsW8kJEgL81ou9H4QN/9FyXmWvu6waBNp5ec07A1PQT5pDxH9I4INounhQNIw0aZuRmzZ21gzlJgZH4AKbeCTTwf9KqVtISFTD
X-MS-Exchange-AntiSpam-MessageData: n+1S+o2lwdYyil3Ipv1JhpxHi90znPTozGfUU3o/6+Re7WgUHXwN3YpP1ukTUxUbiifzw5KD/EP945J9H6tVpYVtBLvIIStRBDnKHXA0oebpXU6wv1i1QmqnqAZQT5yfNfZIl28nZhfDVPxqTrllTiD87BU/eFpNQdlPuvHxS2fgPt+fMF2YiXd3TfInwCtOHbDfa9WSgP9uBFfQwkz+9Q==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8496dd1-fdda-4a50-8650-08d7dd53c02c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 13:33:27.5260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cHzcjHlQCMsxMWVA+paQK5mO/Oz3T0Jx+yQT9QgCvgRYGqPc7pMuxY4k0vAzjrJB12nzDDgIYExlXkqULJkbdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4398
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ3Vy
cmVudGx5LCBJQlNTIG5ldHdvcmtzIGFyZSBzdGFydGVkIGJ5IHRoZSBtZWFuIG9mCndmeF9ic3Nf
aW5mb19jaGFuZ2VkKCkuIEl0IGVhc2llciB0byB1c2UgdXNlIGNhbGxiYWNrcyBwcm92aWRlZCBi
eQptYWM4MDIxMS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91
aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyB8ICAyICsr
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICB8IDE5ICsrKysrKysrKysrKysrKysrLS0KIGRy
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmggIHwgIDIgKysKIDMgZmlsZXMgY2hhbmdlZCwgMjEgaW5z
ZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L21haW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jCmluZGV4IGI0NTlmYWM5Mjhm
ZC4uYjhhMDFiYTBkMzgxIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwor
KysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwpAQCAtMTMzLDYgKzEzMyw4IEBAIHN0YXRp
YyBjb25zdCBzdHJ1Y3QgaWVlZTgwMjExX29wcyB3Znhfb3BzID0gewogCS5yZW1vdmVfaW50ZXJm
YWNlCT0gd2Z4X3JlbW92ZV9pbnRlcmZhY2UsCiAJLmNvbmZpZyAgICAgICAgICAgICAgICAgPSB3
ZnhfY29uZmlnLAogCS50eAkJCT0gd2Z4X3R4LAorCS5qb2luX2lic3MJCT0gd2Z4X2pvaW5faWJz
cywKKwkubGVhdmVfaWJzcwkJPSB3ZnhfbGVhdmVfaWJzcywKIAkuY29uZl90eAkJPSB3ZnhfY29u
Zl90eCwKIAkuaHdfc2NhbgkJPSB3ZnhfaHdfc2NhbiwKIAkuY2FuY2VsX2h3X3NjYW4JCT0gd2Z4
X2NhbmNlbF9od19zY2FuLApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBi
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggOGFhMzczZjVkZWFlLi4yMWVjZWFmYzlh
OTUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYwpAQCAtNjQ4LDYgKzY0OCwyMiBAQCBzdGF0aWMgdm9pZCB3Znhfam9p
bl9maW5hbGl6ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAl9CiB9CiAKK2ludCB3Znhfam9pbl9p
YnNzKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQor
eworCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gKHN0cnVjdCB3ZnhfdmlmICopdmlmLT5kcnZfcHJp
djsKKworCXdmeF91cGxvYWRfYXBfdGVtcGxhdGVzKHd2aWYpOworCXdmeF9kb19qb2luKHd2aWYp
OworCXJldHVybiAwOworfQorCit2b2lkIHdmeF9sZWF2ZV9pYnNzKHN0cnVjdCBpZWVlODAyMTFf
aHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQoreworCXN0cnVjdCB3ZnhfdmlmICp3
dmlmID0gKHN0cnVjdCB3ZnhfdmlmICopdmlmLT5kcnZfcHJpdjsKKworCXdmeF9kb191bmpvaW4o
d3ZpZik7Cit9CisKIHZvaWQgd2Z4X2VuYWJsZV9iZWFjb24oc3RydWN0IHdmeF92aWYgKnd2aWYs
IGJvb2wgZW5hYmxlKQogewogCS8vIERyaXZlciBoYXMgQ29udGVudCBBZnRlciBEVElNIEJlYWNv
biBpbiBxdWV1ZS4gRHJpdmVyIGlzIHdhaXRpbmcgZm9yCkBAIC02ODgsOCArNzA0LDcgQEAgdm9p
ZCB3ZnhfYnNzX2luZm9fY2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAlpZiAoY2hh
bmdlZCAmIEJTU19DSEFOR0VEX0JBU0lDX1JBVEVTIHx8CiAJICAgIGNoYW5nZWQgJiBCU1NfQ0hB
TkdFRF9CRUFDT05fSU5UIHx8CiAJICAgIGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9CU1NJRCkgewot
CQlpZiAodmlmLT50eXBlID09IE5MODAyMTFfSUZUWVBFX1NUQVRJT04gfHwKLQkJICAgIHZpZi0+
dHlwZSA9PSBOTDgwMjExX0lGVFlQRV9BREhPQykKKwkJaWYgKHZpZi0+dHlwZSA9PSBOTDgwMjEx
X0lGVFlQRV9TVEFUSU9OKQogCQkJd2Z4X2RvX2pvaW4od3ZpZik7CiAJfQogCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaApp
bmRleCA2YTRiOTFhNDdmNWIuLjMwMDJkODlkYzg3MSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oCkBAIC01Niw2ICs1
Niw4IEBAIGludCB3ZnhfYWRkX2ludGVyZmFjZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3Ry
dWN0IGllZWU4MDIxMV92aWYgKnZpZik7CiB2b2lkIHdmeF9yZW1vdmVfaW50ZXJmYWNlKHN0cnVj
dCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKTsKIGludCB3Znhf
c3RhcnRfYXAoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2
aWYpOwogdm9pZCB3Znhfc3RvcF9hcChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGll
ZWU4MDIxMV92aWYgKnZpZik7CitpbnQgd2Z4X2pvaW5faWJzcyhzdHJ1Y3QgaWVlZTgwMjExX2h3
ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZik7Cit2b2lkIHdmeF9sZWF2ZV9pYnNzKHN0
cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKTsKIGludCB3
ZnhfY29uZl90eChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYg
KnZpZiwKIAkJdTE2IHF1ZXVlLCBjb25zdCBzdHJ1Y3QgaWVlZTgwMjExX3R4X3F1ZXVlX3BhcmFt
cyAqcGFyYW1zKTsKIHZvaWQgd2Z4X2Jzc19pbmZvX2NoYW5nZWQoc3RydWN0IGllZWU4MDIxMV9o
dyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCi0tIAoyLjI1LjEKCg==
