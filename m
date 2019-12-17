Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC31123213
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbfLQQUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:20:01 -0500
Received: from mail-eopbgr680046.outbound.protection.outlook.com ([40.107.68.46]:59543
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728691AbfLQQPA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2lpbdChKi5V3pLe00JTs1LC/7A7HrMGPA8Xqk596SoqPZWb4X6g9u8y39wnydWCU1AYEBTuix3GJd5hSU3glqZJtkfy7Rq3+s4MOaqjbNXy4+qXlJjdbGpSHDoILDLwUxUt8wjpmulWW/aEfvEfGrRbZ3QGM8psb+aPYcq/jUIKlngUvp0Ig2l1syz5jEBaFRuuZje+njgY7apbKuOUPuQeBgPiTFQq042lMRpmOj+s3JvV99tz4kffx5CompfgHddw/1z/GExeBuU9ZeooXZKMR0xKBkrHLlJnHJv0Nrsiu4euRiAJOdgkm9iUg/0q6j25F1iVuFw4r/eIThv6Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bwq83apa9UPPWMtYIC+2a1EAwrox1NuZQYWnXXSmpAU=;
 b=lMl2LGf/EVYdCs6Mo0ziHZinTJDK0FqjZv9HT/HAj70s+ENT+EjaiM2p7Bi6LtDtiwbh4JqOq+b9X7dNnpWC83nFluqZT4dT30YPyaxqAWz33hJ/rl1vq2lfaEkCSSrgth3TuZhIqJGkc9TQrJ5fGh6ai6UUczrz79YjJ4ieffSyFeSrOdzcmxagOH/oUlZj7+ynzS5hEZA4UllaHZF2UMUp1ngVBTqXvmZ99mSEXvipbgIiPWlGm/KfOfrUlj/uBVJ4cWjYqlrF1oyxk4qhQtZJaa1Q0STQvwGRfluQjNKI0ZkJ/qgtDbEfzXG9LGXmDRH4B9OzC02nnzFzM0F/eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bwq83apa9UPPWMtYIC+2a1EAwrox1NuZQYWnXXSmpAU=;
 b=fTbl3sVNcSHPDSbZ0tr4p5Mp0/QfSyrVp04krztMwk+IPC+MSFXp3cSaDd0fwR0Ne2rpu2rUlus6LUS6x2uozmcCKoXmp7gdJqW574BNo3YWr3F5F9AsEKP/vf+Rk1YdQtS/SaOS0EMIV/XrGt5PCNEuK0M9TlVNehOYFugePYM=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3791.namprd11.prod.outlook.com (20.178.254.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 16:14:54 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:14:54 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 18/55] staging: wfx: remove useless include
Thread-Topic: [PATCH v2 18/55] staging: wfx: remove useless include
Thread-Index: AQHVtPUeSWhPDyYxVUuXgmw6OA5hQQ==
Date:   Tue, 17 Dec 2019 16:14:54 +0000
Message-ID: <20191217161318.31402-19-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: f87eb744-2832-4929-e303-08d7830c4075
x-ms-traffictypediagnostic: MN2PR11MB3791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB37915F8A19645A7C42EE616B93500@MN2PR11MB3791.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:639;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(366004)(346002)(136003)(39860400002)(189003)(199004)(2906002)(52116002)(107886003)(2616005)(86362001)(478600001)(6486002)(4326008)(64756008)(66556008)(66476007)(81156014)(66946007)(6506007)(1076003)(316002)(66446008)(8936002)(71200400001)(81166006)(5660300002)(36756003)(26005)(186003)(8676002)(85202003)(4744005)(66574012)(85182001)(110136005)(54906003)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3791;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7v5hNCDZSz3Rt29QEJkGb70AMufuzdFtsnHyBBxlnc7rR8XNEnLTD7eNnk/eHssdIsGLkFRUZd9KA0ZL6qHzy7HIdG2+5DjpOaTkpXUOKsX1hophEYzWvnMwSeIhnccemq3dJYFkCvTHyZHkfMGcKIIIK5/9HyKo6yxlhLw/qQzSJ6vjLHHPEDMTceOYB/VBN2wO6nJmglzffpTq7LKIwr43rsjSPTIBZWeV8RSchI5dGW9IK3qGd0TlhFzW2Rn4hcwCBQxIGnxf5ioFvBH7ssj+m9V8wUS40zk/0VK0aAeeboyN32x6EbjRR5kzWAsr83bWZE95IAK82lHS8CvlFgLAX97eKNd6Y4f63KIXA7iEitD1EscFEgRUVHmP9+DOo2GX3tWFGPlUzv5A3Xb7dUUxd+iZ1/ALcmzkV1g36YMLFAbyIS+GC2OJzGYDf0He
Content-Type: text/plain; charset="utf-8"
Content-ID: <C90AE3F18663304695AB605FE606F419@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f87eb744-2832-4929-e303-08d7830c4075
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:14:54.3186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q5a2ydmrc8zzEawC1pf+PrZ7Q+FwhpRnse+Qw4UaNZHz1Az8IHCOIaBlBtLPUM8c0qru4UvanOlIQM0dhnO/cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKaGlm
X3R4LmMgZG9lcyBub3QgdXNlIGFueSBzdHJ1Y3Qgc2tiLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0
bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3Rh
Z2luZy93ZngvaGlmX3R4LmMgfCAxIC0KIDEgZmlsZSBjaGFuZ2VkLCAxIGRlbGV0aW9uKC0pCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYyBiL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3R4LmMKaW5kZXggY2I3Y2RkY2I5ODE1Li5lOGMyYmQxZWZiYWMgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfdHguYwpAQCAtNiw3ICs2LDYgQEAKICAqIENvcHlyaWdodCAoYykgMjAxNy0yMDE5LCBT
aWxpY29uIExhYm9yYXRvcmllcywgSW5jLgogICogQ29weXJpZ2h0IChjKSAyMDEwLCBTVC1Fcmlj
c3NvbgogICovCi0jaW5jbHVkZSA8bGludXgvc2tidWZmLmg+CiAjaW5jbHVkZSA8bGludXgvZXRo
ZXJkZXZpY2UuaD4KIAogI2luY2x1ZGUgImhpZl90eC5oIgotLSAKMi4yNC4wCgo=
