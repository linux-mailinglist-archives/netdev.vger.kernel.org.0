Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7AF25F7D0
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgIGKUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:20:11 -0400
Received: from mail-mw2nam10on2078.outbound.protection.outlook.com ([40.107.94.78]:7488
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728550AbgIGKRT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:17:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NXYBech5Xs6XFc62nwXjYRD5beZ2XWVn13OFhFcQ1RWCHyP5aIcOWfl3do3qZozWsphcxejeEEN+DYulP42CyF+KOjBsbnoMf6ZNaPZ6oT/+S5dsmASRJLcrd1wTKbf0KwDOS+OgCY5ybgyrDsD8fI2aBDLR/sl2vqptzibB/o/LUcVBN90rsBtAw6Bi+xh6tnX+d+G3Dd6rxMpY/b5aYYMNKlPTM7lSoS4xxoxUpVe0X5GrgO9Hqap8uXi/TgvBwLzmJvTphYfhud0FVLsvirZrcXGTfR59FSSu/hoNQMSqUy8CBbGu0kgeVfrUcW79/cTUE1trg7WTSj3N/LEMkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzLeOEwzJocxUt4EbhtFEkvS1ODweV/cY4EpplLa4pI=;
 b=WLQEqyklU8VSPRuMogB6Ne5CnVLbKQwJMAFtjPP9DYpPOfpHLaRmJH9EmwJPCtYebdUfGnRPdhrkBbA/rXQCsKGB1nZUc80Sv/1Fc3jGJ8dCXV87p6cxLkCQQN/GowubdkXDgxarp0q/w0c92xno3XJsC8HsWhxI5/Z8RZabOMvYmGF6CnMDze1ofHyOBuNZU4eRn0tsQW2UqmRWMufOuAJUCBJQfAcyJcZFPpm3cqp8RKWSn0c9j71VM1bGHYsWyMzoGxBIUDO8GDL6hy16sAVG0Ex2laGpCsAk0SjRYs9q5WA8QPlAHuKvLc0syd1+aiHMGaaWTxgXFY304FEw5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzLeOEwzJocxUt4EbhtFEkvS1ODweV/cY4EpplLa4pI=;
 b=ak96eV1ddwqp+hptPTavtcrDvF7a4uZDvCHTfQYI+BWgwUjEV/HHL4rOut9Yh43NtMSyxzd7PP66X/8g9HBkWMa3LDE6zkC0TikE9xZ60d/tlVzusbePveH3LcKG1CYZMPWT4HsMA9Bbd2UO6y4uY0Cvt/3ovRBmUO1ipTM2QsI=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2720.namprd11.prod.outlook.com (2603:10b6:805:56::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 10:16:24 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:16:24 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 24/31] staging: wfx: drop useless union hif_indication_data
Date:   Mon,  7 Sep 2020 12:15:14 +0200
Message-Id: <20200907101521.66082-25-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:16:22 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b451f160-d4fb-4625-c320-08d8531712ec
X-MS-TrafficTypeDiagnostic: SN6PR11MB2720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2720934399BF27AA96A8F3BA93280@SN6PR11MB2720.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nqOEpwU2bj+txpVj5+vjTE+UgyjoZFEdj2irJJiPEsr4bHIPKGDp4Mm8SDEnl6HTsdCqVjGLPRPOaaHx2fWdjLytRvXrnxZ21/EkLcwWCCxFkgqE6Ft4hzdmPlDXEV3IwF07EOJLkNe8RNL/biwQgWxAuWJbs5SlG4uhObnyarqCAKd1oqyieEJ6sdKc1hFmIGrjDqpyBKozBX4D49d7KkQDh1qZf32msZk+fXbPf4JcnvtfIlTTy+XJ2LB1t/vhVdjXh7+qe2v1PQGR/Ys8QISXB6jgzYgtcMZ84yiad/BeAkZRzGVDK4bF/aKsLy+I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39850400004)(136003)(346002)(396003)(66946007)(66556008)(66476007)(54906003)(26005)(186003)(16526019)(66574015)(83380400001)(107886003)(6486002)(8676002)(956004)(2616005)(2906002)(316002)(86362001)(8936002)(478600001)(4326008)(7696005)(36756003)(52116002)(6666004)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Y+ba5gDUJfkR/RKa2pywr8TxMJsHP5sOkIhnrzFvxOuYAs1oBquyYNQWNM7qXa6cPf3nYKISqvbIFQZctD6nK83x98EUhb5Vp0RCXjad2wGg+JDJSv+xtxOJ1IzauOgU8g1Gs+zY1zuvqlRKuyc//Lxahg/kn+yCunuKEKpsMuLQKVo+tOrZVyvWPwRijYo4xgCda10UwWxiiOGVyv0akrqVC7xsGhG5CRo4MXvBbzfubpfg1WWKetRXj/IEHXoQtpELt2sPsvgi1zp93Ii6+cFyLnLBUu8uOT18x7I3VKj0RVzgTcgM2e5fkrHdr29EWJGqNjg3y8w2qCmtOAYk11wpUXfX/GvCRggUK8iumWDCRw575XEb2n3VhSIILO5kvHS5in/A7il0RyjfhJZ2mKZZvGwxaBr1kuISWrKVbF02fbhPeQrn4HSmApYXFZq/R8ya924bx2aEAVXiYxyQHHdl2q3zQ4SRGAPeosExiXBYmxsCZx8hnqjH5lfNkgXogiDVbwTn9IpJv3Ra98aiLDu8oR7sVt2f6HvFX8Cicn7MUGMBD0sysDi3mHMAP0pDqZewqephVAutg2nb9H2xn79P/2FM6AgpDA2arpsvvEIF4N6ffipcMCWEQzeMoZ617Fj/vpjlxtYWDUYUCCJ2FQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b451f160-d4fb-4625-c320-08d8531712ec
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:16:24.1633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vv0J4JwdTSx7d9mC6cbF49XXrcLx6NyP3y0rCJpCZrZacwx5GlOTkQ7prF43wyeOd3toiD67XTu4SJMjKnYoOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2720
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHVuaW9uIGhpZl9pbmRpY2F0aW9uX2RhdGEgaXMgbmV2ZXIgdXNlZCBpbiB0aGUgZHJpdmVyLiBT
bywgaXQgaXMgbm90Cm5lY2Vzc2FyeSB0byBkZWNsYXJlIGl0IHNlcGFyYXRlbHkgZnJvbSBoaWZf
aW5kX2dlbmVyaWMuCgpJbiBhZGQsIGRyb3AgcHJlZml4ICdpbmRpY2F0aW9uXycgZnJvbSB0aGUg
bmFtZXMgJ2luZGljYXRpb25fdHlwZScgYW5kCidpbmRpY2F0aW9uX2RhdGEnIHNpbmNlIGl0IGlz
IHJlZHVuZGFudCB3aXRoIHRoZSBuYW1lIG9mIHRoZSBzdHJ1Y3QuCgpTaWduZWQtb2ZmLWJ5OiBK
w6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfYXBpX2dlbmVyYWwuaCB8IDEzICsrKysrLS0tLS0tLS0KIGRyaXZl
cnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgICAgICAgICAgfCAxMSArKysrKy0tLS0tLQogMiBmaWxl
cyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfZ2VuZXJhbC5oIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfYXBpX2dlbmVyYWwuaAppbmRleCA0MDU4MDE2ZWM2NjQuLmRhNjNiYTZmNTE0OCAx
MDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2dlbmVyYWwuaAorKysgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfZ2VuZXJhbC5oCkBAIC0yMjEsMTUgKzIyMSwxMiBA
QCBzdHJ1Y3QgaGlmX3R4X3Bvd2VyX2xvb3BfaW5mbyB7CiAJdTggICAgIHJlc2VydmVkOwogfSBf
X3BhY2tlZDsKIAotdW5pb24gaGlmX2luZGljYXRpb25fZGF0YSB7Ci0Jc3RydWN0IGhpZl9yeF9z
dGF0cyByeF9zdGF0czsKLQlzdHJ1Y3QgaGlmX3R4X3Bvd2VyX2xvb3BfaW5mbyB0eF9wb3dlcl9s
b29wX2luZm87Ci0JdTggICAgIHJhd19kYXRhWzFdOwotfTsKLQogc3RydWN0IGhpZl9pbmRfZ2Vu
ZXJpYyB7Ci0JX19sZTMyIGluZGljYXRpb25fdHlwZTsKLQl1bmlvbiBoaWZfaW5kaWNhdGlvbl9k
YXRhIGluZGljYXRpb25fZGF0YTsKKwlfX2xlMzIgdHlwZTsKKwl1bmlvbiB7CisJCXN0cnVjdCBo
aWZfcnhfc3RhdHMgcnhfc3RhdHM7CisJCXN0cnVjdCBoaWZfdHhfcG93ZXJfbG9vcF9pbmZvIHR4
X3Bvd2VyX2xvb3BfaW5mbzsKKwl9IGRhdGE7CiB9IF9fcGFja2VkOwogCiBlbnVtIGhpZl9lcnJv
ciB7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfcnguYwppbmRleCA3OTgxNjdhYTRjN2YuLjY5NTBiM2U5ZDdjZiAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYworKysgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl9yeC5jCkBAIC0yMjUsMjkgKzIyNSwyOCBAQCBzdGF0aWMgaW50IGhpZl9nZW5l
cmljX2luZGljYXRpb24oc3RydWN0IHdmeF9kZXYgKndkZXYsCiAJCQkJICBjb25zdCBzdHJ1Y3Qg
aGlmX21zZyAqaGlmLCBjb25zdCB2b2lkICpidWYpCiB7CiAJY29uc3Qgc3RydWN0IGhpZl9pbmRf
Z2VuZXJpYyAqYm9keSA9IGJ1ZjsKLQlpbnQgdHlwZSA9IGxlMzJfdG9fY3B1KGJvZHktPmluZGlj
YXRpb25fdHlwZSk7CisJaW50IHR5cGUgPSBsZTMyX3RvX2NwdShib2R5LT50eXBlKTsKIAogCXN3
aXRjaCAodHlwZSkgewogCWNhc2UgSElGX0dFTkVSSUNfSU5ESUNBVElPTl9UWVBFX1JBVzoKIAkJ
cmV0dXJuIDA7CiAJY2FzZSBISUZfR0VORVJJQ19JTkRJQ0FUSU9OX1RZUEVfU1RSSU5HOgotCQlk
ZXZfaW5mbyh3ZGV2LT5kZXYsICJmaXJtd2FyZSBzYXlzOiAlc1xuIiwKLQkJCSAoY2hhciAqKWJv
ZHktPmluZGljYXRpb25fZGF0YS5yYXdfZGF0YSk7CisJCWRldl9pbmZvKHdkZXYtPmRldiwgImZp
cm13YXJlIHNheXM6ICVzXG4iLCAoY2hhciAqKSZib2R5LT5kYXRhKTsKIAkJcmV0dXJuIDA7CiAJ
Y2FzZSBISUZfR0VORVJJQ19JTkRJQ0FUSU9OX1RZUEVfUlhfU1RBVFM6CiAJCW11dGV4X2xvY2so
JndkZXYtPnJ4X3N0YXRzX2xvY2spOwogCQkvLyBPbGRlciBmaXJtd2FyZSBzZW5kIGEgZ2VuZXJp
YyBpbmRpY2F0aW9uIGJlc2lkZSBSeFN0YXRzCiAJCWlmICghd2Z4X2FwaV9vbGRlcl90aGFuKHdk
ZXYsIDEsIDQpKQogCQkJZGV2X2luZm8od2Rldi0+ZGV2LCAiUnggdGVzdCBvbmdvaW5nLiBUZW1w
ZXJhdHVyZTogJWTCsENcbiIsCi0JCQkJIGJvZHktPmluZGljYXRpb25fZGF0YS5yeF9zdGF0cy5j
dXJyZW50X3RlbXApOwotCQltZW1jcHkoJndkZXYtPnJ4X3N0YXRzLCAmYm9keS0+aW5kaWNhdGlv
bl9kYXRhLnJ4X3N0YXRzLAorCQkJCSBib2R5LT5kYXRhLnJ4X3N0YXRzLmN1cnJlbnRfdGVtcCk7
CisJCW1lbWNweSgmd2Rldi0+cnhfc3RhdHMsICZib2R5LT5kYXRhLnJ4X3N0YXRzLAogCQkgICAg
ICAgc2l6ZW9mKHdkZXYtPnJ4X3N0YXRzKSk7CiAJCW11dGV4X3VubG9jaygmd2Rldi0+cnhfc3Rh
dHNfbG9jayk7CiAJCXJldHVybiAwOwogCWNhc2UgSElGX0dFTkVSSUNfSU5ESUNBVElPTl9UWVBF
X1RYX1BPV0VSX0xPT1BfSU5GTzoKIAkJbXV0ZXhfbG9jaygmd2Rldi0+dHhfcG93ZXJfbG9vcF9p
bmZvX2xvY2spOwogCQltZW1jcHkoJndkZXYtPnR4X3Bvd2VyX2xvb3BfaW5mbywKLQkJICAgICAg
ICZib2R5LT5pbmRpY2F0aW9uX2RhdGEudHhfcG93ZXJfbG9vcF9pbmZvLAorCQkgICAgICAgJmJv
ZHktPmRhdGEudHhfcG93ZXJfbG9vcF9pbmZvLAogCQkgICAgICAgc2l6ZW9mKHdkZXYtPnR4X3Bv
d2VyX2xvb3BfaW5mbykpOwogCQltdXRleF91bmxvY2soJndkZXYtPnR4X3Bvd2VyX2xvb3BfaW5m
b19sb2NrKTsKIAkJcmV0dXJuIDA7Ci0tIAoyLjI4LjAKCg==
