Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7797A12321A
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbfLQQUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:20:13 -0500
Received: from mail-eopbgr680046.outbound.protection.outlook.com ([40.107.68.46]:59543
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728562AbfLQQO5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:14:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWB9QzKMG/zSrCUV7QyrSEBmcOqM6sgoIyO5pOXOPMUQmi/RM75HCe277ytuiICk+9iXuI4kz38gDXg8L6gPPTCh3r4cJmRj+Dr6hx1lULJjV51S2WWm3OJDMrCHByvgeC2DCLXb19YX7chdU+i2H/WymSnOrAxOoXKmGeFo7CNafXi4tYzpF9gb7BNg0d+WvwO2Nr1s2wt+FFfgYsJupjZtON72n9D6whtd+gcLPVV7OE/qcIlTgomEQJa3+8WkfDs7Vtullmb8st47dQd2cWl3gcWUGuSQWeHtbYxXLIyLbVI57ERNLzXo7Y9GKmVzg8FGes46jbpcTkhKdZK6eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AcvybTTVTamf+RrwBqacwKQHYq24pZRweh1D95BxTnI=;
 b=CuiH1QG3FJC1hAwQHV6WQJrtJyX568lcwkkKW/W6I6ROWu88yaEwKieBQFzc9QyH5gZsmgstjv9O4rLaxleUNOpdx1/Jda09Q3E8MkczO1k7o5/vuJ1V3ZnfHLa9r/i/pfhU3nBjYVTXtwQM9KI26tkFCl4Q6tSp3wsGfCdHArP5+VVn8AxtSxExj3/z6G3nkPWbe5pw4VecSreeSaSJl/8bX3YlhS7AhZ18wzNoeod8A1NH5mLmVDALrH/OGCscvtoUGAV/+ScfKmIdNZ19oBflEb3QL9BDZOsbQ9+NYBpKLw87NWEft0yzY64lzaiyggKJPweJdzGu5vItDDe/kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AcvybTTVTamf+RrwBqacwKQHYq24pZRweh1D95BxTnI=;
 b=M0TTB5GFMxGo3HeUzhE/qCs1XSMVBnNr8vvBi2gfGOXDnaELoZp6IYTlUflyuYEuT9/VHb58g2gZNTjbSOa0uWaYy/qRrEnAEuD11X7x0j2wdIGjjl9x31JZbJtsX/NdEaqw2jttmOweFZQhgIA4Q5vYckqZFJTa6EeEM9ivtKo=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3791.namprd11.prod.outlook.com (20.178.254.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 16:14:40 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:14:40 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 10/55] staging: wfx: fix wrong error message
Thread-Topic: [PATCH v2 10/55] staging: wfx: fix wrong error message
Thread-Index: AQHVtPUVrSiFmMNkWEC934NjM6UjPg==
Date:   Tue, 17 Dec 2019 16:14:40 +0000
Message-ID: <20191217161318.31402-11-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 855e5d70-dae4-4309-139d-08d7830c3803
x-ms-traffictypediagnostic: MN2PR11MB3791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB37913BC5DFC1788466C1BB1593500@MN2PR11MB3791.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(366004)(346002)(136003)(39860400002)(189003)(199004)(2906002)(52116002)(107886003)(2616005)(86362001)(478600001)(6486002)(4326008)(64756008)(66556008)(66476007)(81156014)(66946007)(6506007)(1076003)(316002)(66446008)(8936002)(71200400001)(81166006)(5660300002)(36756003)(26005)(186003)(8676002)(85202003)(4744005)(66574012)(85182001)(110136005)(54906003)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3791;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4BP7tOTjFvLKsUa+7LIi49gJYzWELZz3io50aek02iIp8sGJvtFRb0SrKpzGdeA/mE8rKN0Wc49R3PVH+/fCtakOllOSpuu+UlypBcJ9iwRT2V/97+oNEdhyNmY2XrwMH0YQgMYk8qYYXzpl7QLLIz7f+eiaFFJQE6aRKt8wT+tGMGIlrRZUgkj3ZzPo+gjx2Dh+mqO60lGLzkR+me4q2OMFnvjuqvfnnDZ98wHmYaVZ+wxuS160MbIrItt/yn8TtRu0PcouLanwXFD8s7h+L/WDe7+HIKvgkUsYZnnLRilMGV6Q9lvMwwOnTPf56lHlyAMtwY8ydO4bi3Mm2OZz35z7FhdY4ip9a6AUZj3O2ZlSH1rTWiwMgaSeYHi684JmKMrJmw9bref+dhtD7QYi252wtZbvCWvWTsea2Fe74RsHlIIUwbb4Yd4CjNQmU1rU
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E6896790DE8A14084D0645F1203DF86@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 855e5d70-dae4-4309-139d-08d7830c3803
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:14:40.0405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n6h8fKh6NyE4CIAlE/xI8hqpgx/GW7r4OCsD8lxet8lWTy9QC8tb2G1wA/19XhIo/W4JLuJOEhwcP/Fwa0EPCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRyaXZlciBjaGVja3MgdGhhdCB0aGUgbnVtYmVyIG9mIHJldHJpZXMgbWFkZSBieSB0aGUgZGV2
aWNlIGlzCmNvaGVyZW50IHdpdGggdGhlIHJhdGUgcG9saWN5LiBIb3dldmVyLCB0aGlzIGNoZWNr
IG1ha2Ugc2Vuc2Ugb25seSBpZgp0aGUgZGV2aWNlIGhhcyByZXR1cm5lZCBSRVRSWV9FWENFRURF
RC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2ls
YWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyB8IDQgKysrLQogMSBm
aWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRh
X3R4LmMKaW5kZXggNzM4YTZjYTVlZGFkLi4zMmUyNjliZWNkNzUgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90
eC5jCkBAIC03NDgsNyArNzQ4LDkgQEAgdm9pZCB3ZnhfdHhfY29uZmlybV9jYihzdHJ1Y3Qgd2Z4
X3ZpZiAqd3ZpZiwgc3RydWN0IGhpZl9jbmZfdHggKmFyZykKIAkJcmF0ZSA9ICZ0eF9pbmZvLT5z
dGF0dXMucmF0ZXNbaV07CiAJCWlmIChyYXRlLT5pZHggPCAwKQogCQkJYnJlYWs7Ci0JCWlmICh0
eF9jb3VudCA8IHJhdGUtPmNvdW50ICYmIGFyZy0+c3RhdHVzICYmIGFyZy0+YWNrX2ZhaWx1cmVz
KQorCQlpZiAodHhfY291bnQgPCByYXRlLT5jb3VudCAmJgorCQkgICAgYXJnLT5zdGF0dXMgPT0g
SElGX1NUQVRVU19SRVRSWV9FWENFRURFRCAmJgorCQkgICAgYXJnLT5hY2tfZmFpbHVyZXMpCiAJ
CQlkZXZfZGJnKHd2aWYtPndkZXYtPmRldiwgImFsbCByZXRyaWVzIHdlcmUgbm90IGNvbnN1bWVk
OiAlZCAhPSAlZFxuIiwKIAkJCQlyYXRlLT5jb3VudCwgdHhfY291bnQpOwogCQlpZiAodHhfY291
bnQgPD0gcmF0ZS0+Y291bnQgJiYgdHhfY291bnQgJiYKLS0gCjIuMjQuMAoK
