Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDAA41D4881
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgEOIeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:34:12 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:55808
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727853AbgEOIeK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 04:34:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NSfMXlm+XHr6iBmbFfwq+qyJ3zF5vUoLIHEkT2tSFKNVmbeH/8BYBycHk8PZXRj/zRjpNKZa8TQhf1GMM03zi50OyqIIHUmH8d8YzJ/yQwoU1fJxBW4UPAWMd6E0XQIsJb3NKkc8fzcmNsSrxaUGZd1iYo4YoB1QOcuPO9wvEmpiKIptGPxtC8aWlYJLYE/mr0d6vpC34fQuQZIDhhNXFtAOYyJGJUS/sy7YmIBqOUNntRZhxahNb2K3o/XnDfgccgP4Hp8hF7b72LLZLOmCWnMnw2rvG2HKT+mQ1Sk+m2bXjdGyKrrtuL7WRfisRrYi/2sCwsmvAio0GFVJqumBJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRGzSAKxWDeKco+3lbUM824AhIj80UEP/NKfp2lWdm4=;
 b=BRCE+N5L79vZl5CRZbcu8orQ73h5gb3Pfk9ZA/yujsIw8IsPK0KxSRbsvQggg9wlXpoQSaA8T90ok4oPPRaDSpGCrNuScSveFs1q0IcFMzDM/RVKRnDM5WPMojormI2EJyzLpYZnzwSmrmjnGDzOVksO/5qo18hzztxrMLpDSCJbL5Jsy9iBSgVkIgW/141nArfFVIaZtTIfaPrs36ASFZqPq+Uw6UbSkHcgR8QISuFoU55UIXYyqQt2y0c0oQcjttkno26oE1nhFTHy/k+JNmwZWKEnLYxVeg35qiFc4JZGmVWTMCIOvSAFZGIWKtVTQrI2/j/D3oQHq0Xd0SjOyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRGzSAKxWDeKco+3lbUM824AhIj80UEP/NKfp2lWdm4=;
 b=OXn1dTlK3W+hOtqQ1x5hzK6LlfHaYt7rzNdq2zmtA/PQB4G3uXGXjWzkMk6WCi0tw91aOKGkFA8bpEPPM31zFdP5TI8zCWDwRksc7wa3jUDz1HsN+LFuw5AWp4Rd9x4fjLI2duQs8Du7k13DEPtdgyY/6HTAcXsDNExALWCOK0c=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1310.namprd11.prod.outlook.com (2603:10b6:300:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Fri, 15 May
 2020 08:33:58 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 08:33:58 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 05/19] staging: wfx: fix coherency of hif_scan() prototype
Date:   Fri, 15 May 2020 10:33:11 +0200
Message-Id: <20200515083325.378539-6-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
References: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::16) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (82.67.86.106) by PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Fri, 15 May 2020 08:33:56 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f408363-c6a3-47d4-0518-08d7f8aab5ed
X-MS-TrafficTypeDiagnostic: MWHPR11MB1310:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB13105D35F358C19C7D43BC1893BD0@MWHPR11MB1310.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uhDt7bKbqQFpQLDTfRV0T9/JMYa9czxGdItWY3j34w0SfCMA23zSHs58BtzHwELPtT6iYuVnRJBdGidqiMgHWrf8Yh6+fSCzbFWCWsuuuKAz2MtFzM44OQga0tk14/bThABYk4TzCj8crJpqfsVVhbTd3DjT6YF6VbCQJ+jMVKZOJrE/yqUYQ2wTmqJiUM5g0ahU2nqHXjctL8MMZkw1PvGzXTSgDCj+kmIdH8kr77TandDOtdppk3YsgF6TQ0d/Jmgyth+9mo4x7J4GeSbcxBO+aAOGkrktrFhmoyRovoxFMEiFN/mgo42miiB745bNCAWx30nbyTCPRyZ4ZUDTkBngr3xgcXvVnvZ+0rY4op5Kjbi2dvtGlCWh6/C1rginKRgkleOveTbNq3SyfXBueOpevj/ltHfXSh0n8ie1vzVTupyshldUzx1eVR2+TSPV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(366004)(39850400004)(396003)(8886007)(66556008)(186003)(6512007)(66946007)(6506007)(36756003)(316002)(66476007)(26005)(52116002)(16526019)(6666004)(54906003)(2906002)(2616005)(478600001)(66574014)(107886003)(956004)(8936002)(86362001)(8676002)(6486002)(5660300002)(4326008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: b3nfpVl0OMkTslIA80A1d61DuTeknEQTnnypTlZswfUFoPhOGZ8v0NheP4c2dMebDDQzgEv00x2rTavrA+ZnAb83JHJrwWHfm8ViP1bVefBfz8s5KL4Qi6jp36isBZrOM51WNVz5E03AjDdlYN8+janh46lU0UJPwWey7tVxxMtbizcA7Ig/akx8+Dd/TYLw8gGeS/CMHnAFDR2zRbCDJTFsYugrhk4RUSUBux9yJboxHb0H636QrDPXESDl1MNs8GBEDl8YHDJaWBQwp3Kxnf3EsTWs9HWc9nL92guOd5vFNnYbs0w6IS2jsQEMIIFRNSUixR7y7N3ftulgljjHbLurMp7TwRp43rr297AH/nkmWdqfjcGIz9j3AezLX/A/EOLA5F2nSdqjQxoYiTFnT2h1vo9XexaOyJlRULi2yAfxL8Kjyji9WFvfwCpnMyzXbgqq+uKEiARh7TjakO96JDkYZ1BSR0TjAbiTFvzz8fM=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f408363-c6a3-47d4-0518-08d7f8aab5ed
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 08:33:57.8142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wus/aBxObzoCubdhe5csx7JmUqZySVwHAZPfnayKB0g7V7y2LMse4jDiT8P+OWUcPles4FP8taKWnHyyCsgyRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1310
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZ1bmN0aW9uIGhpZl9zY2FuKCkgcmV0dXJuIHRoZSB0aW1lb3V0IGZvciB0aGUgY29tcGxldGlv
biBvZiB0aGUKc2NhbiByZXF1ZXN0LiBJdCBpcyB0aGUgb25seSBmdW5jdGlvbiBmcm9tIGhpZl90
eC5jIHRoYXQgcmV0dXJuIGFub3RoZXIKdGhpbmcgdGhhbiBqdXN0IGFuIGVycm9yIGNvZGUuIFRo
aXMgYmVoYXZpb3IgaXMgbm90IGNvaGVyZW50IHdpdGggdGhlCnJlc3Qgb2YgZmlsZS4gV29yc2Us
IGlmIHZhbHVlIHJldHVybmVkIGlzIHBvc2l0aXZlLCB0aGUgY2FsbGVyIGNhbid0Cm1ha2Ugc2F5
IGlmIGl0IGlzIGEgdGltZW91dCBvciB0aGUgdmFsdWUgcmV0dXJuZWQgYnkgdGhlIGhhcmR3YXJl
LgoKVW5pZm9ybWl6ZSBBUEkgd2l0aCBvdGhlciBISUYgZnVuY3Rpb25zLCBvbmx5IHJldHVybiB0
aGUgZXJyb3IgY29kZSBhbmQKcGFzcyB0aW1lb3V0IHdpdGggcGFyYW1ldGVycy4KClNpZ25lZC1v
ZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0t
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jIHwgNiArKysrLS0KIGRyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3R4LmggfCAyICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyAgIHwgNiAr
KystLS0KIDMgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eC5jCmluZGV4IDg5M2I2N2YyZjc5Mi4uNmRiNDE1ODdjYzdhIDEwMDY0NAot
LS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX3R4LmMKQEAgLTI0MCw3ICsyNDAsNyBAQCBpbnQgaGlmX3dyaXRlX21pYihzdHJ1Y3Qg
d2Z4X2RldiAqd2RldiwgaW50IHZpZl9pZCwgdTE2IG1pYl9pZCwKIH0KIAogaW50IGhpZl9zY2Fu
KHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3QgY2ZnODAyMTFfc2Nhbl9yZXF1ZXN0ICpyZXEs
Ci0JICAgICBpbnQgY2hhbl9zdGFydF9pZHgsIGludCBjaGFuX251bSkKKwkgICAgIGludCBjaGFu
X3N0YXJ0X2lkeCwgaW50IGNoYW5fbnVtLCBpbnQgKnRpbWVvdXQpCiB7CiAJaW50IHJldCwgaTsK
IAlzdHJ1Y3QgaGlmX21zZyAqaGlmOwpAQCAtMjg5LDExICsyODksMTMgQEAgaW50IGhpZl9zY2Fu
KHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3QgY2ZnODAyMTFfc2Nhbl9yZXF1ZXN0ICpyZXEs
CiAJdG1vX2NoYW5fZmcgPSA1MTIgKiBVU0VDX1BFUl9UVSArIGJvZHktPnByb2JlX2RlbGF5Owog
CXRtb19jaGFuX2ZnICo9IGJvZHktPm51bV9vZl9wcm9iZV9yZXF1ZXN0czsKIAl0bW8gPSBjaGFu
X251bSAqIG1heCh0bW9fY2hhbl9iZywgdG1vX2NoYW5fZmcpICsgNTEyICogVVNFQ19QRVJfVFU7
CisJaWYgKCp0aW1lb3V0KQorCQkqdGltZW91dCA9IHVzZWNzX3RvX2ppZmZpZXModG1vKTsKIAog
CXdmeF9maWxsX2hlYWRlcihoaWYsIHd2aWYtPmlkLCBISUZfUkVRX0lEX1NUQVJUX1NDQU4sIGJ1
Zl9sZW4pOwogCXJldCA9IHdmeF9jbWRfc2VuZCh3dmlmLT53ZGV2LCBoaWYsIE5VTEwsIDAsIGZh
bHNlKTsKIAlrZnJlZShoaWYpOwotCXJldHVybiByZXQgPyByZXQgOiB1c2Vjc190b19qaWZmaWVz
KHRtbyk7CisJcmV0dXJuIHJldDsKIH0KIAogaW50IGhpZl9zdG9wX3NjYW4oc3RydWN0IHdmeF92
aWYgKnd2aWYpCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5oIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaAppbmRleCBlOWVjYTkzMzAxNzguLmUxZGEyOGFlZjcw
NiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaAorKysgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl90eC5oCkBAIC00Miw3ICs0Miw3IEBAIGludCBoaWZfcmVhZF9taWIo
c3RydWN0IHdmeF9kZXYgKndkZXYsIGludCB2aWZfaWQsIHUxNiBtaWJfaWQsCiBpbnQgaGlmX3dy
aXRlX21pYihzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgaW50IHZpZl9pZCwgdTE2IG1pYl9pZCwKIAkJ
ICB2b2lkICpidWYsIHNpemVfdCBidWZfc2l6ZSk7CiBpbnQgaGlmX3NjYW4oc3RydWN0IHdmeF92
aWYgKnd2aWYsIHN0cnVjdCBjZmc4MDIxMV9zY2FuX3JlcXVlc3QgKnJlcTgwMjExLAotCSAgICAg
aW50IGNoYW5fc3RhcnQsIGludCBjaGFuX251bSk7CisJICAgICBpbnQgY2hhbl9zdGFydCwgaW50
IGNoYW5fbnVtLCBpbnQgKnRpbWVvdXQpOwogaW50IGhpZl9zdG9wX3NjYW4oc3RydWN0IHdmeF92
aWYgKnd2aWYpOwogaW50IGhpZl9qb2luKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1
Y3QgaWVlZTgwMjExX2Jzc19jb25mICpjb25mLAogCSAgICAgc3RydWN0IGllZWU4MDIxMV9jaGFu
bmVsICpjaGFubmVsLCBjb25zdCB1OCAqc3NpZCwgaW50IHNzaWRsZW4pOwpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYwpp
bmRleCBlZmYxYmU5ZmIyOGYuLmJmN2RkYzc1YzdkYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9zY2FuLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKQEAgLTU2LDEw
ICs1NiwxMCBAQCBzdGF0aWMgaW50IHNlbmRfc2Nhbl9yZXEoc3RydWN0IHdmeF92aWYgKnd2aWYs
CiAJd2Z4X3R4X2xvY2tfZmx1c2god3ZpZi0+d2Rldik7CiAJd3ZpZi0+c2Nhbl9hYm9ydCA9IGZh
bHNlOwogCXJlaW5pdF9jb21wbGV0aW9uKCZ3dmlmLT5zY2FuX2NvbXBsZXRlKTsKLQl0aW1lb3V0
ID0gaGlmX3NjYW4od3ZpZiwgcmVxLCBzdGFydF9pZHgsIGkgLSBzdGFydF9pZHgpOwotCWlmICh0
aW1lb3V0IDwgMCkgeworCXJldCA9IGhpZl9zY2FuKHd2aWYsIHJlcSwgc3RhcnRfaWR4LCBpIC0g
c3RhcnRfaWR4LCAmdGltZW91dCk7CisJaWYgKHJldCkgewogCQl3ZnhfdHhfdW5sb2NrKHd2aWYt
PndkZXYpOwotCQlyZXR1cm4gdGltZW91dDsKKwkJcmV0dXJuIC1FSU87CiAJfQogCXJldCA9IHdh
aXRfZm9yX2NvbXBsZXRpb25fdGltZW91dCgmd3ZpZi0+c2Nhbl9jb21wbGV0ZSwgdGltZW91dCk7
CiAJaWYgKHJlcS0+Y2hhbm5lbHNbc3RhcnRfaWR4XS0+bWF4X3Bvd2VyICE9IHd2aWYtPnZpZi0+
YnNzX2NvbmYudHhwb3dlcikKLS0gCjIuMjYuMgoK
