Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D26D1E284D
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbgEZRSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:18:48 -0400
Received: from mail-bn8nam11on2083.outbound.protection.outlook.com ([40.107.236.83]:48578
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729597AbgEZRSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:18:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHcNDapIfL7pY5cswImPBCqr7KmKing4sj3MvGkFOfQNA1E15kAo13FfGjZgNnD/5BRBn3sHzg4BBNeNQthdQ32Foxd8tXFoSYO94wfvXoZ3l6W0vaQqoFqU316pXfxFWu7ht/D2YKMwb6xDMrrCe3PvNj7hF9vUBuBmhk32mlVaG7M2+OQWcF3fLKTCKw3OCNHkq0k7rqZlVxnrYpkt08kYF+Obzc1rH8IC2VLyaoCaVyHCrxtcm1iIfwXmU3oVoErwSJQ5NSDVUpWDYjyDg9h/6cGvIxgUDHMQivDV47YZvfJ2c4wEwRASsQIrWJ87GLA9JV3hFcO+hl9U+ALxrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1CZJt2AGW/b/5DPxtwNsVYH8u7aWDDxha8wH4ZgAfcE=;
 b=d0AAadWpf6RbkwZ/XTu9/APIil0Z+EUdoc8WAUMfSnRpnbe78w9bdNtpwTkWtmcEaubvLIT4ae1s1qUsNjUQ0P0QR0P+xtoGTA3jdNv34hj/h3FtLV6CUATxkuO3MwyM8t/ehlRCdhyMVG+gCGIDJQSO1vA2486UcbXzvM2QXidRD3Qwr+oSGAxKD+jxcyK9tuw2PnVG2R2c8dZNbI6goNcLWGw3LY2yQpDQT8S1Y0nvzG3/YBKpWomYSmaqTVFX1gbNHk7myfHOU7mNkzoqiGwrRlRsY04z8cZnsZt4y101Wg/gDMeL02eGtTFZCpb7Yw3Nk/DPfk0H3iE8YWz3yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1CZJt2AGW/b/5DPxtwNsVYH8u7aWDDxha8wH4ZgAfcE=;
 b=IdoQF/KgoBE/v/xYr+zYAbP+g5xt20g9O60hJs54G2RLBHWQSFQ1W2cMsBkJNiHouI3QiMxz+J0h+juuQxZVpvPKx6K6XnnzO49EqUYp1NxMkzzE450nSI/rI4AN1lny+Yn59F6zhLnw9LWD+MAMpYXa2PU2nxrydO8qz2vjwnc=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2750.namprd11.prod.outlook.com (2603:10b6:805:54::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.25; Tue, 26 May
 2020 17:18:42 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 17:18:42 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>, kbuild test robot <lkp@intel.com>
Subject: [PATCH 01/10] staging: wfx: drop unused variable
Date:   Tue, 26 May 2020 19:18:12 +0200
Message-Id: <20200526171821.934581-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526171821.934581-1-Jerome.Pouiller@silabs.com>
References: <20200526171821.934581-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1PR01CA0007.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::20) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0007.eurprd01.prod.exchangelabs.com (2603:10a6:102::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Tue, 26 May 2020 17:18:40 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3499145d-abfa-464d-1b75-08d80198d6aa
X-MS-TrafficTypeDiagnostic: SN6PR11MB2750:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2750D9C8F62AEDB7201864E393B00@SN6PR11MB2750.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:480;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JCcoyUnV5sbzS5jL00Qv7cXnTMDOVzAGsttksPC2OPigPJvCuSTr860imHCs1dolT5ybDr7ghpohHTeEqdKfTCeVvQUbJprv+hcXEWeJCBsOVu59aFG8JiJcycvz+HgpJH6DpVj0nSQgHP8HszyWGAsO8/XxpGEhmYv7gA+gZ2jhIQhL/W8kvYQg9zExwsEuUVHDk0YpDIRFEh5uSNtMgBqmyXtqeLi1uCW0OzNwIYa326YJta306YYMxK26V17Vj6jh2gpXOcMSoI81MEYjUGnWq3xDAaMwhCSEWFcpVWmXGv8z95NaILl4gNP5419h8/8pX2pYeoxgjJJSSjn4PA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(366004)(39860400002)(136003)(346002)(4326008)(6512007)(316002)(8676002)(8936002)(2616005)(6486002)(2906002)(1076003)(86362001)(6666004)(186003)(16526019)(5660300002)(66574014)(36756003)(54906003)(66556008)(478600001)(8886007)(6506007)(66946007)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1NyQAGHDjAppSytKdK5AmyBQPMMy7NH38A2Tr93ZwoCb7c1PDlcVfpMGae1WqAELkx0PEZYLQsuVU+w7rUh4yIt1DFpvEmGo9TDMZZg3T8F6scWtFkH1ExJwHJyOg9t62ZeG7p5lmDgQKDa1X4TNKd2GPENRbE2HgLG7LT6KG5UB/XZ1J+VZ3wgwB6pZvrC7Y1GQZ4Y8wVtMIumjnKBJ/kYt0pGO1vgMnIHLPZ+EiOSgLjPx0pey4GX+eaMH1jpo3fF60uikJ3Oxhev2K+Z0B9QoO5mH8s7HUAWZw2exXs+tbeOZgJqWvuxlJ+SaRlZ0oaELDpDpp5xOVkDc8k56NB02GQtoe3Vc2NYMe6utZxxY6wREVxFYdX8/8PqURFV9zkGsYZC0A7rzVxCuGodKc39YiTELV1pPNnOI/5GoX5vLabTvrTwlgv1Uls3VSnDO55KKKRL2yqUufKVHoXKCwOhPf795bQLwjhCM7C/9l4rTW07Xj/Z+Ey0LFf3qUYNIVT6GQsVyQYFvUwzvFX5SAmrwisl3CYyBOhNDnC584tA=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3499145d-abfa-464d-1b75-08d80198d6aa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 17:18:42.2593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xaD2WmsY4gswMVMQNHPtNIplcxRUqWdijS3s+VurMNEID5aEcuvhIU1s5h6uThGVnGrLsFI92I6zA+uje+21Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2750
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2lu
Y2UgdGhlIGNvbW1pdCAzZjg0YWRmZTFkN2FlICgic3RhZ2luZzogd2Z4OiByZW1vdmUgaGFjayBh
Ym91dCB0eF9yYXRlCnBvbGljaWVzIiksIHRoZSB2YXJpYWJsZSAiY291bnQiIGlzIG5vIG1vcmUg
dXNlZCBpbiB3ZnhfdHhfcG9saWN5X2J1aWxkKCkuCgpOb3RpY2UgdGhhdCB0aGVyZSB3ZXJlIHR3
byBpbnN0YW5jZXMgb2YgdGhlIHZhcmlhYmxlICJjb3VudCIgaW4Kd2Z4X3R4X3BvbGljeV9idWls
ZCgpLiBUaGlzIHBhdGNoIGFsc28gc29sdmVzIHRoaXMgY29zbWV0aWMgaXNzdWUuCgpSZXBvcnRl
ZC1ieToga2J1aWxkIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+CkZpeGVzOiAzZjg0YWRmZTFk
N2FlICgic3RhZ2luZzogd2Z4OiByZW1vdmUgaGFjayBhYm91dCB0eF9yYXRlIHBvbGljaWVzIikK
U2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMu
Y29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIHwgNSAtLS0tLQogMSBmaWxl
IGNoYW5nZWQsIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9kYXRhX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwppbmRleCBhODJmMDBm
OGYxN2JkLi5hOWVkZGQ2ZGIyYjVkIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2Rh
dGFfdHguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwpAQCAtNDMsMTUgKzQz
LDEwIEBAIHN0YXRpYyB2b2lkIHdmeF90eF9wb2xpY3lfYnVpbGQoc3RydWN0IHdmeF92aWYgKnd2
aWYsIHN0cnVjdCB0eF9wb2xpY3kgKnBvbGljeSwKIAkJCQlzdHJ1Y3QgaWVlZTgwMjExX3R4X3Jh
dGUgKnJhdGVzKQogewogCWludCBpOwotCXNpemVfdCBjb3VudDsKIAlzdHJ1Y3Qgd2Z4X2RldiAq
d2RldiA9IHd2aWYtPndkZXY7CiAKIAlXQVJOKHJhdGVzWzBdLmlkeCA8IDAsICJpbnZhbGlkIHJh
dGUgcG9saWN5Iik7CiAJbWVtc2V0KHBvbGljeSwgMCwgc2l6ZW9mKCpwb2xpY3kpKTsKLQlmb3Ig
KGkgPSAxOyBpIDwgSUVFRTgwMjExX1RYX01BWF9SQVRFUzsgaSsrKQotCQlpZiAocmF0ZXNbaV0u
aWR4IDwgMCkKLQkJCWJyZWFrOwotCWNvdW50ID0gaTsKIAlmb3IgKGkgPSAwOyBpIDwgSUVFRTgw
MjExX1RYX01BWF9SQVRFUzsgKytpKSB7CiAJCWludCByYXRlaWQ7CiAJCXU4IGNvdW50OwotLSAK
Mi4yNi4yCgo=
