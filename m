Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00C6B5DC6
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 09:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbfIRHIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 03:08:00 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:46592
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725834AbfIRHIA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 03:08:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RDNj3UA/zv1XX++Caf10tdwJm2UZVkayJjHHRxdfNWz4dFej7n/hxRy8Kv5nWao2dDJl/e+rYBys8sRfHo/mEF5QivDjpo/TWrykkl5AjRrMnWc657LfOgM9frk8zbzVvWz9xOcewyehnAX66PcbplbuR3SZsGjbK34cFii/2nZHlqge/LZC9rXf4DOXZ/yTmHC2xRJi+gM4jCtJ1Kkq2XLHhTBV+vVvcfcuchRStovsry0Sc/9RtL2dMbEAPn7gFRN4+eZnX1olcbFY1NU6HRSiMMPETBQMW2gvIHUvywyyYGaJh15v+bPuSIFgTMPfv6MGSHFEjNL9jmwGtrxqnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDY52+yFOhGH2DJc7GfkMMUBjjkj6tNWxQiNOSPFND0=;
 b=be14zGLQyJcQzY/c0iYf+8C7Jd0AZvPkes6RJKvIv9yGN2zCkyBDCeDwsDGJlc3d8nuN4LcKx/tOq/mXtI4xHnXAPrMFErx7T0FcXoSHaUOeOIHiujWQhVMzLRynFOlAc7EHghxpgTpzY6saYwtNdBLt/fGGVVV+E1XxEhHGGLSGCOP4kAUNe3RDeT4dpKBM14irrCZckSGmLfwuSTrhOXSWCpK3d21B9YM4rWwIMYLPFeI/RtWYPWF7PZpOIBXulNcM61RlOHPRgxUpnPqfK2MNUpAQSOCPKTeXmh2Yd3GwKX2EPtcfATh2/EnR4XDdY+RrXP4xykXi8En3gJf33Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDY52+yFOhGH2DJc7GfkMMUBjjkj6tNWxQiNOSPFND0=;
 b=qakgGVVl/Z1DLkuIir3ZJbDxXg6pdrh3Lmr2j9JhUKnb8ExSmeDmydRvm4B5Uih+uBSBJ8hlPtsGRJa2EEEi3e9sHEigN7fYZDS2uVU8trwTdTXnyp5QsV6Sl1EJ+uCJT2kow02nXrPoliM374AIpcQCZAUX1Gvf2sn9ntgfNF0=
Received: from DBBPR05MB6299.eurprd05.prod.outlook.com (20.179.44.85) by
 DBBPR05MB6444.eurprd05.prod.outlook.com (20.179.44.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.15; Wed, 18 Sep 2019 07:07:56 +0000
Received: from DBBPR05MB6299.eurprd05.prod.outlook.com
 ([fe80::9084:6136:31bf:9811]) by DBBPR05MB6299.eurprd05.prod.outlook.com
 ([fe80::9084:6136:31bf:9811%3]) with mapi id 15.20.2284.009; Wed, 18 Sep 2019
 07:07:56 +0000
From:   Aya Levin <ayal@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@mellanox.com>
CC:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH iproute2 4/4] devlink: Fix devlink health set command
Thread-Topic: [PATCH iproute2 4/4] devlink: Fix devlink health set command
Thread-Index: AQHVY+eMfukqZgiJxU+Ik+hqGe/hKacwEAmAgAEHugA=
Date:   Wed, 18 Sep 2019 07:07:55 +0000
Message-ID: <3052d758-4c3c-7b07-7fa2-e46c45210719@mellanox.com>
References: <1567687387-12993-1-git-send-email-tariqt@mellanox.com>
 <1567687387-12993-5-git-send-email-tariqt@mellanox.com>
 <20190917172357.5c70c3b9@xps13.home>
In-Reply-To: <20190917172357.5c70c3b9@xps13.home>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR10CA0005.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::15) To DBBPR05MB6299.eurprd05.prod.outlook.com
 (2603:10a6:10:d1::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ayal@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f0da4bd-6a3e-4540-6ed9-08d73c06ee11
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DBBPR05MB6444;
x-ms-traffictypediagnostic: DBBPR05MB6444:|DBBPR05MB6444:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR05MB644490C578E7DB296EDF25B8B08E0@DBBPR05MB6444.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 01644DCF4A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(189003)(199004)(14454004)(2616005)(476003)(8676002)(316002)(6506007)(54906003)(486006)(102836004)(110136005)(26005)(81166006)(478600001)(6116002)(81156014)(66066001)(186003)(2906002)(386003)(99286004)(11346002)(71190400001)(53546011)(71200400001)(3846002)(52116002)(107886003)(6486002)(6246003)(86362001)(256004)(36756003)(4744005)(31696002)(25786009)(76176011)(6636002)(5660300002)(7736002)(305945005)(66476007)(66446008)(64756008)(66556008)(6436002)(446003)(8936002)(6512007)(31686004)(229853002)(4326008)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6444;H:DBBPR05MB6299.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GZUPMIfp6xagXr6MJSMU5Z+EhBxBVlj72JORcusXaF0La+DgDyCYDyafb8ZGgFtSiTUknCDzU9pUS5Yhs0ULEFYqc4zyEKHZlV7mLhWj7pHiUV0wfxLiErOByUZCj696/IuMo+0RlIk01ciAFZCy9SvnMofApqFh5TCFhlEzjJZqxGAQs6nVXZr9iNwam0biU1inO4l7naRJYSFpY38l0mxY+MHEtIJVz7+CN1LP5X01wNOKCjqUQDfAapbabzAzwpJ4Etm+3UNcDUnrOV3GU+ZI3/EFTSU8Xmgy7KrDuXtyy6LuhQumQNKjE+KWWF2kXPTx8ivG6UX6R8sDN97wjw9H+cLvODwHNpURRTiQ7SP8gu2W24KQ7J205mmItHhp/Z4jFBCWUY56yNF4nYjUViW0mCjc7HKwxNtU3bB882c=
Content-Type: text/plain; charset="utf-8"
Content-ID: <35E0F488C4AF4C418934EC113F2B061E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f0da4bd-6a3e-4540-6ed9-08d73c06ee11
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2019 07:07:56.0053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fhgdm3zDqaiH5SeG7a8gSI6WUp6/yuj7lQ6BtN3d6FJ1g/t96rEglVdr8xAlHMta1uzl5g3mO4Zv9SUglQo7tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6444
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMTcvMjAxOSA2OjIzIFBNLCBTdGVwaGVuIEhlbW1pbmdlciB3cm90ZToNCj4gT24g
VGh1LCAgNSBTZXAgMjAxOSAxNTo0MzowNyArMDMwMA0KPiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBt
ZWxsYW5veC5jb20+IHdyb3RlOg0KPiANCj4+IEZyb206IEF5YSBMZXZpbiA8YXlhbEBtZWxsYW5v
eC5jb20+DQo+Pg0KPj4gUHJpb3IgdG8gdGhpcyBwYXRjaCBib3RoIHRoZSByZXBvcnRlcidzIG5h
bWUgYW5kIHRoZSBncmFjZSBwZXJpb2QNCj4+IGF0dHJpYnV0ZXMgc2hhcmVkIHRoZSBzYW1lIGJp
dC4gVGhpcyBjYXVzZWQgemVyb2luZyBncmFjZSBwZXJpb2Qgd2hlbg0KPj4gc2V0dGluZyBhdXRv
IHJlY292ZXJ5LiBMZXQgZWFjaCBwYXJhbWV0ZXIgaGFzIGl0cyBvd24gYml0Lg0KPj4NCj4+IEZp
eGVzOiBiMThkODkxOTViMTYgKCJkZXZsaW5rOiBBZGQgZGV2bGluayBoZWFsdGggc2V0IGNvbW1h
bmQiKQ0KPj4gU2lnbmVkLW9mZi1ieTogQXlhIExldmluIDxheWFsQG1lbGxhbm94LmNvbT4NCj4+
IEFja2VkLWJ5OiBKaXJpIFBpcmtvIDxqaXJpQG1lbGxhbm94LmNvbT4NCj4+IFNpZ25lZC1vZmYt
Ynk6IFRhcmlxIFRvdWthbiA8dGFyaXF0QG1lbGxhbm94LmNvbT4NCj4gDQo+IERvZXMgbm90IGFw
cGx5IHRvIGN1cnJlbnQgaXByb3V0ZTIuDQpUaGlzIHBhdGNoIGlzIHJlZHVuZGFudCBkdWUgdG8g
cGF0Y2ggZnJvbSBBbmRyZWEgQ2xhdWRpIA0KNGZiOThmMDg5NTZmZjQ4MTAzNTRkNzVhZmE5YjA0
Y2I2ZjgwMTFiYw0KUGxlYXNlIHJlamVjdCBpdC4NCk90aGVyIHBhdGNoZXMgdGhhdCB3ZXJlIHN1
Ym1pdHRlZCB3aXRoLCBhcmUgdmFsaWQuDQo+IA0K
