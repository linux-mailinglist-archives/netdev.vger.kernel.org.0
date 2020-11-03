Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65E92A4420
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 12:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgKCLYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 06:24:12 -0500
Received: from mail-db8eur05on2058.outbound.protection.outlook.com ([40.107.20.58]:51937
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726058AbgKCLYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 06:24:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bz58UUPIya9u/HoOdJu3M3lkTJCGaoT8YtQ0xP9xPr2/DhRIs1bDC5DM6nEPeK4LS99LOF5tFZ/1SJMx2Lby13xZNZQVbakcHmu51PuFFDOnVcDJt+9jAeZaC1G2NeEtCDK6NtgaIEFpCxIlFYiv/5vwrKtO+ioXBEcXSindUYNg3PDBm88IGnXqiQDhGzp9+TvlRd1ep8t40oGGWXIVi0ha5QM28kkzYqaIIVLkwmBoNIg1iIy+Y7ZCr0UOaqumu2NQDsoYS2KgKn3qcuB6hUrjaoT+hMy5mlQjViXgdA/f6yBIpW+O05Wrgo8Xan02Sr8WdTue35M6xa9u5LKz+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJyq/LI1zruSWZmMVq+BkTxf3PH3N24jAX4gIeT9Iw8=;
 b=PXXKZx8WnnYrB9uj6U2sO+thfdLzPjF9zzRVKp0zNSCezBfcO96C1w4NUNGx7eMFQEQT7/mGDU+sAtQXcAJNR1x4bRjtGxyQKos+ZSwKK7wJ/WQHQH/oomzJ+BCro3daI/41Tzmn1M79xoLT5te6DqfXvXbFhqXtpkXXx/U6ev9A1WG1KzqgQq9JWFZxD0/dfLexKmD/zpWiVidgfNBHCzgUWYLhLynmleu4wV/MBAR9SUiRY4BkXbBUSdxPJam44C7bgjkDlfrivaCq6RscWmLJ9LuHvdmWyuRFGh0T2kNlBUG3ikA0WxhJeITvqTkKF3Y3mHoW/7R3wKCwm6YuXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJyq/LI1zruSWZmMVq+BkTxf3PH3N24jAX4gIeT9Iw8=;
 b=IPr1crPh1a0+rpdCkLWdf09O7YLID6Ll79yfX9+LPXOPNVJQireev2CwIrvtXyqUGHBMPfHuG2SW8D5khYgr26oug8WP9d6+dIF40hpwB6w1HtGB8FjtunY/v/YRRy/YVGmVjNtrtUCk9sGDejLBVYfUbIvwNvkrEvzas4qCKJc=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR04MB6760.eurprd04.prod.outlook.com (2603:10a6:20b:f4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 3 Nov
 2020 11:24:09 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7824:9405:cb7:4f71]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7824:9405:cb7:4f71%4]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 11:24:09 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Leo Li <leoyang.li@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [PATCH v2 net-next 0/3] fsl/qbman: in_interrupt() cleanup.
Thread-Topic: [PATCH v2 net-next 0/3] fsl/qbman: in_interrupt() cleanup.
Thread-Index: AQHWsKX76degwACBYEuHMOPwcsAwfKm2RhUQ
Date:   Tue, 3 Nov 2020 11:24:09 +0000
Message-ID: <AM6PR04MB39766CA27E3265225A7658B4EC110@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20201101232257.3028508-1-bigeasy@linutronix.de>
In-Reply-To: <20201101232257.3028508-1-bigeasy@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.76.227.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5ba82ef1-5b4c-488a-2614-08d87feafb90
x-ms-traffictypediagnostic: AM6PR04MB6760:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB6760DED3393D09457CB183FDEC110@AM6PR04MB6760.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cgw/ePXZpdTDh4nuaf/jA26X/2YaSA78yzyHY78ua92vQgsF06Y9pBOFkOXJsQ2SCD/822dpNyswXCL+uMwyFfUK0T7A+OPVzgfT09C2E6zbTQtxBVTAhQffyT+tb6dQq0jHmufGrgG4Et+WXoU7xbLogDFcylCiicE7trHxazciUToDfM8vJjdP5TObKGRZQl17idvpWYK9sWbriaMOpxeYYihlKideIvn+yLMVBCAzyEcfAXNRWZSS6wEMjiq6ddF4lgmHNHffgUrfUSsmt2WP062euFjYeBfXaysh0j6KEOFMSVjmvbUp7EuU5lt34Gx/Cj9K9tGcd2u9IbrSucd8m04sUsw06yDTm05giWB8EJg3syLAAyLydssRf9tMbq0KgMLY3OFJuazHoVc5UQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(66446008)(66556008)(6506007)(9686003)(53546011)(52536014)(4326008)(71200400001)(76116006)(8676002)(66946007)(64756008)(66476007)(86362001)(55016002)(83380400001)(5660300002)(966005)(7696005)(54906003)(44832011)(110136005)(316002)(186003)(26005)(33656002)(8936002)(2906002)(478600001)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: hMYDS5p4fg1CXQGKo3hhRunaEaIsFpk/FKV7i1p03NR+dRjdPNyqGwE6Xu4+koZ+z+lJVpnpYQH3Lm+cHBAuNJgiXHWw9FFpF5rjB0HFaIxWhYp50mOAmPDtMKrBSd3IBw+yrfYX44sMJWcgyjxt1O0ZZ5lrKC8taZpfrhV+ktDYp67cpsf7dmChSVW/h+ZSKty1HrCDNP9jTsxAV5fwFQ8W6vpt1PRry9YGkZHSuTeEX5nYh/gzDhmCzBBz9aZt9uhPI7weCxv68S4mh7lSzMi7DD0EQDwz7+1SLX61gQZAZKvs0Hal+agamXSjJNzzyiINQ/Hch3Vv1Y55A9As8kEFYSKAEWiFcB1G55jH/kr+TPqd84mNLRRiUJUagrqGWd8NcXGVA1D+WM1WoKGh8dJeevzv23A4qehe3qxiOAGH29aQhIMfyZl9BrqqLh5/F+//WWYRXd4jGZbN7n7V2GSuGJ3LUsU3AYZcANOZ5DHq++sC9u3WamfDYbEGnqXYYJXz+DqycGOOH8UCtIl8z9XVmNml5XDlhoAX3HWpdOJeKcNa+siwcB5MUxHR+KYhYHhQwj3OuPqpFSRGQGhj3uD17n7S3bCwsbGk3iKqC9RSgrvwVp0vuzxrt3lsdAucstexFgQyvq2qJhjcKrCyqA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ba82ef1-5b4c-488a-2614-08d87feafb90
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 11:24:09.1748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iRcFb2ffL4dNi9hMjdkMTPMdNKp2CvwZ/Kdonn5UaenN+X5IZ+KXhcgaQTuHuMNsseijyzEcgG5IMUXkhup4cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6760
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTZWJhc3RpYW4gQW5kcnplaiBT
aWV3aW9yIDxiaWdlYXN5QGxpbnV0cm9uaXguZGU+DQo+IFNlbnQ6IDAyIE5vdmVtYmVyIDIwMjAg
MDE6MjMNCj4gVG86IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IEhvcmlhIEdlYW50YSA8
aG9yaWEuZ2VhbnRhQG54cC5jb20+OyBBeW1lbiBTZ2hhaWVyDQo+IDxheW1lbi5zZ2hhaWVyQG54
cC5jb20+OyBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+OyBEYXZpZCBT
Lg0KPiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBNYWRhbGluIEJ1Y3VyIDxtYWRhbGlu
LmJ1Y3VyQG54cC5jb20+OyBKYWt1Yg0KPiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgTGVv
IExpIDxsZW95YW5nLmxpQG54cC5jb20+OyBUaG9tYXMgR2xlaXhuZXINCj4gPHRnbHhAbGludXRy
b25peC5kZT47IFNlYmFzdGlhbiBBbmRyemVqIFNpZXdpb3IgPGJpZ2Vhc3lAbGludXRyb25peC5k
ZT4NCj4gU3ViamVjdDogW1BBVENIIHYyIG5ldC1uZXh0IDAvM10gZnNsL3FibWFuOiBpbl9pbnRl
cnJ1cHQoKSBjbGVhbnVwLg0KPiANCj4gVGhpcyBpcyB0aGUgaW5faW50ZXJydXB0KCkgY2xlYW4g
Zm9yIEZTTCBEUEFBIGZyYW1ld29yayBhbmQgdGhlIHR3bw0KPiB1c2Vycy4NCj4gDQo+IFRoZSBg
bmFwaScgcGFyYW1ldGVyIGhhcyBiZWVuIHJlbmFtZWQgdG8gYHNjaGVkX25hcGknLCB0aGUgb3Ro
ZXIgcGFydHMNCj4gYXJlIHNhbWUgYXMgaW4gdGhlIHByZXZpb3VzIHBvc3QgWzBdLg0KPiANCj4g
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtYXJtLWtlcm5lbC8yMDIwMTAyNzIyNTQ1NC4z
NDkyMzUxLTEtYmlnZWFzeUBsaW51dHJvbml4LmRlLw0KPiANCj4gU2ViYXN0aWFuDQoNCkZvciB0
aGUgc2VyaWVzLA0KDQpSZXZpZXdlZC1ieTogTWFkYWxpbiBCdWN1ciA8bWFkYWxpbi5idWN1ckBv
c3MubnhwLmNvbT4NCg==
