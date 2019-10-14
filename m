Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7A0D6193
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 13:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730989AbfJNLoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 07:44:00 -0400
Received: from mail-eopbgr710061.outbound.protection.outlook.com ([40.107.71.61]:38750
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730178AbfJNLoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 07:44:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1TM7tnkwgrvPyQF9esN1EyTBnewBBPOvF5JOLXLsWsPxJJRxT8c4uM31EhQSFZd95kBuvCxJ5pS9orbve6oCEVgMb1bSJ40PgeRUzxQl/4pfaI3qWoa9EoKmk1wzxz4RkWZpQcOnghSpXhCFBuJMr/z2pTfB0sLzl2hfpcN1rYIV2CpcGuyGm50R1nPXUuk0eAYYJmMZxl39EVDq35bQkcErckPV6toGa5F5ZD5Pq6H2xvmPAg5lDh3t7IPuq9ryC04YjxewZZaY5islhfOiCmRGsREvKrip4oqRlVgBCZSiRzhT4xUHGxVHNKYYUI6ZNFrmoPFj9ChgvDZaYoDJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLu2NMFwl8aKHj4m+GxB3SDz3+HUmanvCjby54VrZQw=;
 b=iSBleUX7cfSUMu9XYL1R9o7aYVjLLXziRRSDi8SfZiKRVF+zbQzOy8/Ybfzo/rhN3Ljea3KI6f4xI5FiY/oGboy7B8TjcJKyXBomGOAodvOmkzfBM747hxWTBovfjcBru/glr4TRQx7d5rzh0SmtUiI6slqoPCUb/5dMHLPFhPHUAAd3LD0MU9jk7Q3rj3YAJkPgAlKprE6+nibf7xWqHzQPRMUShlBS4lXNUew5hZGBrf9IjbsiUIFo+j2QOuJQLS1sGNc8Y7fFcwTC3t5CqmqhRggijhUT7M3AmFGt7WQr6H1NYLAbmcGXt56Lis2+25suVxnJMC1go37fABzqjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLu2NMFwl8aKHj4m+GxB3SDz3+HUmanvCjby54VrZQw=;
 b=wk5bwquaUyA/G2NUZ//C/MZeNQiOy3k4+zqQ+Y1lD5LOQ+zolD17AdguUqD/5vCOzNf5krrpRB08VDkNMF++G5eZcs9yFNTXs5or5qzN/D6Y6fTUiIQD+tSSYTvZAoHXd4qlW7rh5AlZaj3t9ZQMbC2JXFTc/83FHEfGsSzXb+M=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3828.namprd11.prod.outlook.com (20.178.220.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Mon, 14 Oct 2019 11:43:56 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.023; Mon, 14 Oct 2019
 11:43:56 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: Re: [PATCH v2 net-next 03/12] net: aquantia: add basic ptp_clock
 callbacks
Thread-Topic: [PATCH v2 net-next 03/12] net: aquantia: add basic ptp_clock
 callbacks
Thread-Index: AQHVfccQHd4mih+JiEeyq5u+CEXVpw==
Date:   Mon, 14 Oct 2019 11:43:56 +0000
Message-ID: <3afdfb86-7b81-a435-5853-8b238d922977@aquantia.com>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
 <df637c9a87f6fd0107ad536d0c87be45e69feaa0.1570531332.git.igor.russkikh@aquantia.com>
 <20191012190242.GK3165@localhost>
In-Reply-To: <20191012190242.GK3165@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BY5PR16CA0004.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::17) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d44bf251-7b46-4ccc-ec91-08d7509bcb9d
x-ms-traffictypediagnostic: BN8PR11MB3828:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB38287385A47F02415BB41D8C98900@BN8PR11MB3828.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 01901B3451
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(376002)(346002)(366004)(396003)(136003)(199004)(189003)(99286004)(31696002)(52116002)(25786009)(5660300002)(1411001)(6506007)(8936002)(81166006)(81156014)(8676002)(31686004)(76176011)(186003)(66066001)(102836004)(14454004)(71190400001)(71200400001)(54906003)(386003)(26005)(86362001)(4744005)(316002)(508600001)(7736002)(6116002)(305945005)(3846002)(476003)(2906002)(44832011)(2616005)(6916009)(11346002)(486006)(446003)(256004)(36756003)(4326008)(66446008)(64756008)(66556008)(66476007)(66946007)(14444005)(6436002)(6486002)(6246003)(107886003)(6512007)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3828;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z+0Mx/pPA1LW4NvpmNLLAMgdhXVb9aPXRQSJ6IibE1BxVn1htSG/05IQK/H8o1nZPvwvWuRQptRJMhZWpMwqXvA2G45KihwG2fmux7OO3oSAjuVPHQsBqI4seehELwBPoKrSR/RRvUCkJDjQUejBoHoOKvKCzDmY8WZaVhGTJ/li+S6IALGHjQBf1kZao6fe55yJkFW1vp/ghXFdDljQLbpIYwFNEJ5xpLwTVkMArjnR6j6B3V1FiVoxkeTUsFuJfZ1eozONfrDYtwuyAddWZiqERILzWJFfUOu5bkbhUMqaUfAdYsTVtfIwHtH5NBG4CoexSqVwXrJGwt0WFcAM6fmOh6SnJ1ZKvNAGK5pzj1XMElrFQXT8kphSPmMU8wT0nfyyvDTiCdVobV+SKjbt6JDibRkEGNVdgCcVh1vDhnE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C07CB7E02159249B28EDB3F609F51C0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d44bf251-7b46-4ccc-ec91-08d7509bcb9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2019 11:43:56.5280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ItgMEyFdB4WcvVNgncR9pwQyDO+Sh7MgPoyJ8SfxTkX7cXniv9Bm8RzS3lHgHTvQgohWSia13IaL/KNrov7anQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3828
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUmljaGFyZCwNCg0KVGhhbmtzIGZvciB5b3VyIHJldmlldywgd2lsbCB1cGRhdGUgdGhlIHBh
dGNoc2V0IGFmdGVyIHRoZSBjb21tZW50cy4NCg0KDQo+PiArew0KPj4gKwlzdHJ1Y3QgYXFfcHRw
X3MgKmFxX3B0cCA9IGNvbnRhaW5lcl9vZihwdHAsIHN0cnVjdCBhcV9wdHBfcywgcHRwX2luZm8p
Ow0KPj4gKwlzdHJ1Y3QgYXFfbmljX3MgKmFxX25pYyA9IGFxX3B0cC0+YXFfbmljOw0KPj4gKw0K
Pj4gKwltdXRleF9sb2NrKCZhcV9uaWMtPmZ3cmVxX211dGV4KTsNCj4gDQo+IEhlcmUgeW91IHVz
ZSBhIGRpZmZlcmVudCBsb2NrIHRoYW4uLi4NCj4gDQoNCj4+ICsNCj4+ICsJc3Bpbl9sb2NrX2ly
cXNhdmUoJmFxX3B0cC0+cHRwX2xvY2ssIGZsYWdzKTsNCj4gDQo+IC4uLiBoZXJlLiAgSXMgaXQg
c2FmZSB0byBjb25jdXJyZW50bHkgc2V0IHRoZSB0aW1lIGFuZCB0aGUgZnJlcXVlbmN5Pw0KDQoN
ClllcywgaXRzIHNhZmUuIFRoZSBwdXJwb3NlIG9mIHRoZSBsb2NrcyBpcyBkaWZmZXJlbnQsIG11
dGV4IHNlY3VyZXMgRlcgYWNjZXNzZXMuDQpUaGV5IGNvdWxkIHRha2UgdGltZSBhbmQgc2hvdWxk
IGJlIHNlcmlhbGl6ZWQuDQoNCldvcmtpbmcgd2l0aCBwdHAgY2xvY2sgaG93ZXZlciBkb2VzIG5v
dCB1c2UgRlcsIGJ1dCBzcGlubG9jayBpcyB1c2VkIHRvIHNlY3VyZQ0KcG9zc2libGUgY29uY3Vy
cmVudCBhY2Nlc3MgYW5kIG1hdGggb3ZlciA2NGJpdCB2YXJpYWJsZSBhcV9wdHAtPnB0cF9jbG9j
a19vZmZzZXQNCg0KUmVnYXJkcywNCiAgSWdvcg0K
