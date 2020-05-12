Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304491CF85A
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730588AbgELPEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:04:47 -0400
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:45896
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726055AbgELPEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 11:04:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vf/tPX7GGR1Kex8J6fktffhE8mGBUJd+6sdcuzYuJTixlRPIGMa+6FdvI5+jp78KQGWVAgoHu+cycEa0YCcWXe05h3tG2N7mprag/V0i3nRsoq6m15QsC7tzbQmZ6u+Qgzc/uxAlJjQ6iMK5lS1T/iIy2btR3r0T4ps2tekqvPe0LZFr8yJXkKsffS/aAT0O440AqJxXVGk3Ez9mlvtkT3dLpeAjh6CRpqXmTdi4CbF/Hm9bBwsirNsbZ7EFGlxlla/5fepwU2K3Rd4oBpm09yn9JFq6QR7xAtSfSnmpa/Eag2OWaHAg+ml24P1PUocXQVqHIehxHN0uDi4A2UtOlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPxBtvqIwHnq/ZQoTtQPNlMQH3kPLlBXxz1s9sW4W/0=;
 b=MYIo/K1wbQN3wGXMunR5QYn1abqsRHwwWTMQYdi+D4rqEZiyOI5bIeywPvmq9j5mpmp51HWJoLIcwz7Ui7xy0q9OxDUQAEG7y56sVpt+spqMeo/JvCi7RGqTa+530MGI5g3NmymlkPutKvateOs1o61/xfaYlsBtCslxRtr7FZR930WTUuNy9uNICSbTq/wd1zxto9yplzJlHU31P3/ZDpy02FYuNkcB+38l8G0oqLDBOQ3CzPc5y6N63uRlYB394d3++fxQbIchK2sWc1rFFsXiL59WKMTvwkN1aLJejqoXhOgWxO7y9DG7CH+Qn6c1TW9xuO6/Cv2zvKua3qovIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPxBtvqIwHnq/ZQoTtQPNlMQH3kPLlBXxz1s9sW4W/0=;
 b=k5rGYxww8M6aCZLzK4Jdde3JXDLHOjmbRNYF5hQcTX+ncslGV/5siphoxFqoLSBUbZwrH4u4s5eobt2L2ymQS2dKhI9KzuPgM8cqKEDuUpraVLRqm62HPlD87u71ZycGzMBTXz+iyl5f7at+H//uZKuoJNBnm3epC1IivofuBsI=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1741.namprd11.prod.outlook.com (2603:10b6:300:10d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 15:04:38 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 15:04:38 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 04/17] staging: wfx: fix wrong bytes order
Date:   Tue, 12 May 2020 17:04:01 +0200
Message-Id: <20200512150414.267198-5-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
References: <20200512150414.267198-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR1101CA0003.namprd11.prod.outlook.com
 (2603:10b6:4:4c::13) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by DM5PR1101CA0003.namprd11.prod.outlook.com (2603:10b6:4:4c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 15:04:36 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9666882-58e7-4a94-921e-08d7f685ca0a
X-MS-TrafficTypeDiagnostic: MWHPR11MB1741:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1741BBAE358E2E941BDF296C93BE0@MWHPR11MB1741.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c051FrqUjQOXwMiHEp9ZMlSCkxOayoAUlfqsNgaWbdb5iwzy1OtEI3Mgo2ZTxkxb3Qb+wSQ3rh4/3LZLRM4VrW0EoWiGgRHHlKlEeYeNPA9dUVp2yjYNbkakMsW0evUCfedtd/mRI8p+FaoSWhYcdn8p3cFREtSecbA5dDTs+Yn40tv1GHvwlVOQ84JVC1sUmn+QpWzEvTHFq/tdUxf2+M0DorZFHhgt+XZvHIA7+ivDp2V/gy9iUF2dBUxYueocKu+SNRDnYZ69wigxn67AXgPP+P5iH0uQtZ/TNv5VD2hjBzTjD/LQWbgCYC/ZyxlKfY/+G6uzaivwJqxg2FT2VievSuCfdrie+BTCFDR+7CXOCjtP4hvdc5mEBV8v8ZhR2v1PBPlF6+yfFJSOs+bL/fThY598yqIKfZg3MxcXzS9DSnwovAVsmrL56sX6k0kNtWt4uVq79UiZc592tAJ3jf5HwOeCHMLaA/pUspeDXTBhmYIlJmyHF6EzEkcrdNnnjWLdxBvACgQ7eCrqbV2q0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(39860400002)(346002)(136003)(33430700001)(54906003)(107886003)(4744005)(478600001)(8676002)(5660300002)(316002)(1076003)(956004)(8936002)(2616005)(186003)(2906002)(7696005)(86362001)(4326008)(52116002)(6666004)(6486002)(66476007)(66574014)(26005)(66946007)(66556008)(33440700001)(16526019)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9pssZ5870fsn3O9xYJv9DnkuE5L2kR+DF+Owt6fJZyF4ROORMEL/+gG5XcsvfeVN3AGpT8dyaTwBfTmmsyozGsv0TswGRTPZqV12AhRjRqM06lIUk/lSWO6tsCPuK69cUKAhYeanm1shwZAk9FUPg4U0epRTE2x3xkuCGbbRLQKRllqTo86yzlICrKXZhg95WooW9ADDXZlvRp5iFd12rc/vZgau/QRt8RKWZo6Ircvfw6xk3f27+0oa6vYj6aPIOYdMLhROe4Vjc5i9O1t+U/AYUJY2aC0+hxxStTWlrPywKb4yPIipCpUhtOd6h6u/S5BMX9zz82K0M0TFzfjw3PXPEXOzO6a7KwGf4f26PGbx/UjAkClh3BN9XsrOUkC//lRbrC+w6W83v95AQuXhGtswEElpWTFHY3tJZ107JIgMN3jkkFsb6MkjTbjbBFbz9O2sGutHjRonnQkihTZ39TxATPt25Q8nFBfNSpfWoN4=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9666882-58e7-4a94-921e-08d7f685ca0a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 15:04:37.9117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F4JyeNt7PofbLdFfmM0lc17xpDM2M4nAQnfNFWZNgVQU112T6LW5TZrkIMKZPSGNoB9MAH6lY/721F66uZg0NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1741
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkIHdha2V1cF9wZXJpb2RfbWF4IGZyb20gc3RydWN0IGhpZl9taWJfYmVhY29uX3dha2Vf
dXBfcGVyaW9kIGlzCmEgdTguIFNvLCBhc3NpZ25pbmcgaXQgYSBfX2xlMTYgcHJvZHVjZXMgYSBu
YXN0eSBidWcgb24gYmlnLWVuZGlhbgphcmNoaXRlY3R1cmVzLgoKU2lnbmVkLW9mZi1ieTogSsOp
csO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMv
c3RhZ2luZy93ZngvaGlmX3R4X21pYi5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9o
aWZfdHhfbWliLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuYwppbmRleCA2NTM4
MWIyMjQzN2UuLjU2N2M2MWQxZmUyZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9o
aWZfdHhfbWliLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMKQEAgLTMy
LDcgKzMyLDcgQEAgaW50IGhpZl9zZXRfYmVhY29uX3dha2V1cF9wZXJpb2Qoc3RydWN0IHdmeF92
aWYgKnd2aWYsCiAJc3RydWN0IGhpZl9taWJfYmVhY29uX3dha2VfdXBfcGVyaW9kIHZhbCA9IHsK
IAkJLndha2V1cF9wZXJpb2RfbWluID0gZHRpbV9pbnRlcnZhbCwKIAkJLnJlY2VpdmVfZHRpbSA9
IDAsCi0JCS53YWtldXBfcGVyaW9kX21heCA9IGNwdV90b19sZTE2KGxpc3Rlbl9pbnRlcnZhbCks
CisJCS53YWtldXBfcGVyaW9kX21heCA9IGxpc3Rlbl9pbnRlcnZhbCwKIAl9OwogCiAJaWYgKGR0
aW1faW50ZXJ2YWwgPiAweEZGIHx8IGxpc3Rlbl9pbnRlcnZhbCA+IDB4RkZGRikKLS0gCjIuMjYu
MgoK
