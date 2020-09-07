Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B3E25F7AD
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgIGKRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:17:37 -0400
Received: from mail-mw2nam10on2056.outbound.protection.outlook.com ([40.107.94.56]:42336
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728806AbgIGKRT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:17:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uw1pMNzlBu2QL7wTGJaCAMax9X7hdzs57V752HzoQmabbJ1qcgupbBrux0QsQWP7fIMgPGU6K69CgJGlzPNdCbbtSQtwjWPvhGWthYOJmIhYNCPRlg3UznTyjxMMx6VUPPSq494WA1VycMco5y2NscnrLqCycevOHe2Q1Y4IXvh4/tKrJL0mS8L4zBvzb3iLeFNfNfdB+vCYHl6OjRdaR5ocabIscUzKd2zerfwW7KZiQu6HUpOmrNoftcWvREkn19M7OhQPIeJCuKqPiEL/uD0C45XUuSO3zwDp06iTT0D1m/I4LQJBwL8mP8ZPeKY7pjN+wDB5kIxtVCNCbPzlVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NecxHB2RpeFlsqBvTeTcPZGkodCW88C3fdLKLL79wzY=;
 b=hJ73E6KiEQn7z+knFp2KL5QU+MF0+jFqIxZYboZVGL8O5uMLtDGD8NA+tb4vDpARXUtQ3yZTf8872O61gGPNJASNZRUgVEFGsv7Gw6HIYO+WQH6CetMbPT9vcpLl4bk10a8h6BoN5P7vNvIp4dwPkXG9EuWA+zqAqcfkbnIpoq6BPkJej5oFdi3r8pgaujLLjKPE7S2rgm9h2EIsjqsmaNlXlE/gpvdAbScAhhx1lbDx/u1eUy1r/7PTqtgx1cF92xsFpA3WIGZyWcWcQ34TZgkJB0ov/8aJvkqtDYb2kmZw3+jW7i4LItSnUb4kxHqDMNRpJcR0VkftsMLhaDUUZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NecxHB2RpeFlsqBvTeTcPZGkodCW88C3fdLKLL79wzY=;
 b=a0+5vfE+j/bNsAx9RvsasTEPOoeINefhj3//PXYerBRpec92umCBTCsvEYA9yaJV/QTC3kDm23DnpyOG7cCe0q3iSoGArg+R33jRuoM2Snmn7elcQXRRCIMlyWJTFD7UGzL2pgpfuriJMCbncI2mBBsxTA5yV9LYb328IbeRKJk=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2720.namprd11.prod.outlook.com (2603:10b6:805:56::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 10:16:25 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:16:25 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 25/31] staging: wfx: drop struct hif_ie_tlv
Date:   Mon,  7 Sep 2020 12:15:15 +0200
Message-Id: <20200907101521.66082-26-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:16:24 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8b4a15c-2b9a-42fd-a41f-08d8531713e5
X-MS-TrafficTypeDiagnostic: SN6PR11MB2720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB27204A13626BF61CFB81E20D93280@SN6PR11MB2720.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q6PiOWsGSxnAm1ojXGKd4jGR3QdwAX0Ig6aiqFNS442+Jf2KamtsJKuCa+e2sIG2rq0SPswIPxwwkhT8XKVcUrGkKiws8fqD+SUd2PrUiUFo8NQJCiS8wLlwgtQ8t5kIzPxyri0YG2p+rMa7kXmNjDgOcZrX+pE44mUr40NWOlh7G0HK3MSbwr3KCAvw2iDKXh2BTfdiEU/G9OarnK9q3yzBK0A84oU2mxcif5Laq+JZh9wu4XUdiEqJsSVenhlCnmUFp5RSZAod84ydJTUvT7Hn9WfiHBtfgcajE7NwZ8AGtfZEAH7w6G+DrWn+i3wp5pkgtY/tujlMuQ+ihzTdug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39850400004)(136003)(346002)(396003)(66946007)(66556008)(66476007)(54906003)(26005)(186003)(16526019)(66574015)(83380400001)(107886003)(6486002)(8676002)(956004)(2616005)(2906002)(316002)(86362001)(8936002)(478600001)(4326008)(7696005)(36756003)(52116002)(6666004)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XAxB7ub2JwSlDRjpeiiZBPug0xrsfZ8rkZP9KYNYyKiwAU1Y7CO6sPVXp5C71xXPtgwgLDA2mO/VaPF4m872ScOU399lGS26k2BqT3kDHqJZMTPXwHf/fNfmroI4Gj4yWc0ty523HB1cODi4TC4+b0NmbT7NX427DQqPWGiKj/t5Sv6QN/ISz95F81kb91wpBUCVXP6LY7LM2Da/2oUEQWKYYHOafpOIaO3e9sXHrNwQ7o57cRkrC3UdohKYdhkpYFMaCdYmOiFb1wb0X8BWENohQiYYFA1NLNvJtrTZkuDoSHV+W+ofc3vT0NjcRBNAN7BpJ44UYMpQQclZMHu5Xdv7cEKSRZUkB/q0wyU9w15ZOhhGrHPM828XZ43XTO8UVyDYldprWLsi/RfDuLk0zFikA++Mzw5Q2KfVG13GiP3QIeijEdniRILzpKmfghlpCctqc0j30vfUt+yOeIaAZWC0eCvNu1eeiKlAtMaHnpVKunAHepnODdwHTFea3/Goj4rVs5wGuJbl/is9yqzJLti2nv77wgb71yZRvhwoIJKFB6NPGOtY0618hgL4gTY2sUnikex9qIeMEBNopnpmKmtqkKDONNKzKSUP2epEoLI79M6gAuZphFyU4ual8uT19s0A75Aef5DkXXaMh4bNaw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8b4a15c-2b9a-42fd-a41f-08d8531713e5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:16:25.7724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1+POA2mnYOiKtJEuSRBtnnxaKim2sjDY/aqS74m70L13PYSeaK4e3MAQR67LMgpILENOmI63XoXDwh848JOE8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2720
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhp
cyBzdHJ1Y3QgaGlmX2llX3RsdiBpcyBkZWZpbml0aXZlbHkgYW4gSW5mb3JtYXRpb24gRWxlbWVu
dCAoSUUpLiBUaGlzCnN0cnVjdCBpcyBkZWZpbmVkIGJ5IDgwMi4xMSBzcGVjaWZpY2F0aW9uIGFu
ZCBhbHJlYWR5IGV4aXN0cyBpbgptYWM4MDIxMS4gUmV1c2UgdGhpcyBkZWZpbml0aW9uIGluc3Rl
YWQgb2Ygc3RydWN0IGhpZl9pZV90bHYuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxl
ciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9o
aWZfYXBpX2NtZC5oIHwgMTAgKysrLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9u
cygrKSwgNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hp
Zl9hcGlfY21kLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKaW5kZXggYzE4
ZTc2MjQ4NWE5Li5lZjU0ODM2MDlkY2IgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX2FwaV9jbWQuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKQEAg
LTgsNiArOCw4IEBACiAjaWZuZGVmIFdGWF9ISUZfQVBJX0NNRF9ICiAjZGVmaW5lIFdGWF9ISUZf
QVBJX0NNRF9ICiAKKyNpbmNsdWRlIDxsaW51eC9pZWVlODAyMTEuaD4KKwogI2luY2x1ZGUgImhp
Zl9hcGlfZ2VuZXJhbC5oIgogCiAjZGVmaW5lIEhJRl9BUElfU1NJRF9TSVpFICAgICAgICAgICAg
ICAgICAgICAgIEFQSV9TU0lEX1NJWkUKQEAgLTkzLDEyICs5NSw2IEBAIHN0cnVjdCBoaWZfY25m
X3dyaXRlX21pYiB7CiAJX19sZTMyIHN0YXR1czsKIH0gX19wYWNrZWQ7CiAKLXN0cnVjdCBoaWZf
aWVfdGx2IHsKLQl1OCAgICAgdHlwZTsKLQl1OCAgICAgbGVuZ3RoOwotCXU4ICAgICBkYXRhW107
Ci19IF9fcGFja2VkOwotCiBzdHJ1Y3QgaGlmX3JlcV91cGRhdGVfaWUgewogCXU4ICAgICBiZWFj
b246MTsKIAl1OCAgICAgcHJvYmVfcmVzcDoxOwpAQCAtMTA2LDcgKzEwMiw3IEBAIHN0cnVjdCBo
aWZfcmVxX3VwZGF0ZV9pZSB7CiAJdTggICAgIHJlc2VydmVkMTo1OwogCXU4ICAgICByZXNlcnZl
ZDI7CiAJX19sZTE2IG51bV9pZXM7Ci0Jc3RydWN0IGhpZl9pZV90bHYgaWVbXTsKKwlzdHJ1Y3Qg
ZWxlbWVudCBpZVtdOwogfSBfX3BhY2tlZDsKIAogc3RydWN0IGhpZl9jbmZfdXBkYXRlX2llIHsK
LS0gCjIuMjguMAoK
