Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477511D5C67
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgEOW22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:28:28 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:22179
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726204AbgEOW21 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:28:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=emmrb2RpcWeWRsiIknHFYLSZGxOnAS6sP6LK3KI6J/d9IUerJxYzGbSEKThSA435BCTB+FwRegYEsrSN+OzG/3IUcI9mmeWqF0e2p2BcMwN85LY1bTnqCHE2dTygeOPz5T2MDRspH8hYNx8jSucFXcfHlAhGG6tYz27jqaXEBMeU148mDAOUL5JbnffDEvSnutjfwF/oG6LsS/vC88DUxbDuPQV4F9TB4mT9WjCtUNy7wDdR/nN2aoNQaELsN2pwM7mlm9tzdnn8edB2hjEboEhYD0JQWA2MC+s8a4tZXSV2BtiQZNvZki8I7vVQmhlwpuFU8mGXNc1y2/9NY0ALxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iygPpbyVy5KSCtOj/ZULvyOLN+nGnOZXPUqaRrhuFf0=;
 b=dIwlfzYXdu5chkaxWMB5HK9guCQdQsriWIQ/pZucC0hBcwNCzVd4GuSnZewzprKYChGjmfDqgaVoUpEFEm5A/i7Hubdkhq8T4C+a5gCv6EM03C8Q/EeYqWR/diW8Z4DkUyDnxSU01Zw5PWzqUQi2wycZkRN18gtgQRFyZU2mBX1Z/h8N8+pnCllXcyrUX3rX5VEw17wAWOjwQ6jLKZhYO529uRjcY5E6Ymn2N3cus4BcPTbFenQGFwHpP93zW/k8hwTOiCkEp2bojwOw5c8h9EPA1eZs8UAMWPo7gajAlnRrLWTWhFJh3YY9ZmaTtukYM85x+gYx257frnJnjfo1PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iygPpbyVy5KSCtOj/ZULvyOLN+nGnOZXPUqaRrhuFf0=;
 b=br+Lhmvc957kgG1+4d8+sTm9t201cnAy7oAq7r+PrOXN/o/Yqx+8+KYCkDA9FwM2/opecXH+FgE4LBlcHOA50wLYwe+qiItbj8rPo4k+INkinc0ag6hWTRyT+n8WCtv3gV3p4CNToTc7NTCQm3+O6P+rgVstRV4+yJ5Lf/eCKII=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1SPR01MB0347.eurprd05.prod.outlook.com (2603:10a6:803:7d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Fri, 15 May
 2020 22:28:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 22:28:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "tangbin@cmss.chinamobile.com" <tangbin@cmss.chinamobile.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5e: Use IS_ERR() to check and simplify code
Thread-Topic: [PATCH] net/mlx5e: Use IS_ERR() to check and simplify code
Thread-Index: AQHWJGWeb+Hs5eOqF0yXGTqAJqqX6aidEJIAgAi92wCAA/kNAA==
Date:   Fri, 15 May 2020 22:28:22 +0000
Message-ID: <295e31680acd83c4f66b9f928f1cab7e77e97529.camel@mellanox.com>
References: <20200507115010.10380-1-tangbin@cmss.chinamobile.com>
         <20200507.131834.1517984934609648952.davem@davemloft.net>
         <febc1254-ad7f-f564-6607-9ac89f1fcf40@cmss.chinamobile.com>
In-Reply-To: <febc1254-ad7f-f564-6607-9ac89f1fcf40@cmss.chinamobile.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: cmss.chinamobile.com; dkim=none (message not signed)
 header.d=none;cmss.chinamobile.com; dmarc=none action=none
 header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f5ef7f00-ff81-4cd9-cb6e-08d7f91f46e4
x-ms-traffictypediagnostic: VI1SPR01MB0347:
x-microsoft-antispam-prvs: <VI1SPR01MB0347ED75D37A3606644B6375BEBD0@VI1SPR01MB0347.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 04041A2886
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W6n9A9bDIvByCajTZdE7OYvOmEDPnQMCUf1ZJPG4H7cpx/uJuKHHlNBO/Im6I8sDsik4maxcI7MberYVoyuPboP+XiZ2LMWP9oJjI32bHN2i3Xe7abqdYldbGBjtLd8T+5QH6/vOiC6j+eiwuWXdGryvAxelGWIcs7GY3ZtZKhZ9SsIEai4KvO9Vu8SMJNABp4mBI92RU6egMzgJzijT/W4xajcPQwpEyTyrP53KyhEYWfVsohWU/KPovOP39OaquAFDKf6B5OOOxm+DMg+MTzy3JjOb43Rw3UPJbBQhOrE27xtKgrJPrSx1kpfDfpwQD/1M/troOEM0rOJ/gpQ2sLTCp3Zd5Zq1hsTHuoV0Xnq0+0gzU/FfN5H4hlk61VEJOMcmLKEImUbNfqe4BEqElizml9ZRjd1wUwrf/LLA7cYT4tOqYqkw2mQHc7SlINvW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(8936002)(8676002)(6486002)(26005)(71200400001)(53546011)(6506007)(4326008)(186003)(54906003)(6512007)(110136005)(2906002)(316002)(66556008)(66946007)(64756008)(66446008)(86362001)(66476007)(2616005)(76116006)(5660300002)(91956017)(36756003)(478600001)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: nHpCqXug2SjKfSQNqNNYBanUen33o1ErwslSUzZSIxJa1iwvDBS7xQ2swjavXwRoawCE87dok2NDxs1vRLJhJTJf3Qr21NAdwSzODPIjwJA/04ENNMies6UHha5vIp813CzIaBkIwOrAp1FKlrx9kYV7nnClLguALZCPk9l7iQoQ2Ho1FcvDHjti2ubrC2uj/fiSFZ7978sTly/vAKOHLkry1OFcIPXYt/aMSRlNmMMWzlvz6jpRQ4LNkTZhkbRpl6BZA790GfqTUcEpSJuyq0NetV/cVFB/KHNgjG32Urns57ZJ3XIs8EfvUCACqTMIeKl3ZSbkO7PFUeGsngMVxWYO8pTgLmwPPOf+GzN+AjVW0voFAsmuYK22gyFbDZEmVLFL6V89wqOkVIkGIEUvsiW/uFMlnw9lCQ++mKR/8BfIols/go4Ki+FHJ0Xv3HLAUH9TW9loGVBAH23k+z3vs/nKph0ex3s0+hLX9g/s2oE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0B1DD2365CC6F4280CD45470743F585@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5ef7f00-ff81-4cd9-cb6e-08d7f91f46e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2020 22:28:22.2707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oFn3lXH9ropb/HjL9lTCp65dI0oQAPxSRtpzHmGgEnQRv9mvVTqPbrWXsIR071qf7vTujUMAxiR8fJ4wGuV0Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0347
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA1LTEzIGF0IDE3OjQ4ICswODAwLCBUYW5nIEJpbiB3cm90ZToNCj4gSGkg
RGF2aWQ6DQo+IA0KPiBPbiAyMDIwLzUvOCA0OjE4LCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+ID4g
RnJvbTogVGFuZyBCaW4gPHRhbmdiaW5AY21zcy5jaGluYW1vYmlsZS5jb20+DQo+ID4gRGF0ZTog
VGh1LCAgNyBNYXkgMjAyMCAxOTo1MDoxMCArMDgwMA0KPiA+IA0KPiA+ID4gVXNlIElTX0VSUigp
IGFuZCBQVFJfRVJSKCkgaW5zdGVhZCBvZiBQVFJfWlJSX09SX1pFUk8oKQ0KICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBeXl5eXl5eIHR5cG8NCj4gPiA+IHRvIHNp
bXBsaWZ5IGNvZGUsIGF2b2lkIHJlZHVuZGFudCBqdWRnZW1lbnRzLg0KPiA+ID4gDQo+ID4gPiBT
aWduZWQtb2ZmLWJ5OiBaaGFuZyBTaGVuZ2p1IDx6aGFuZ3NoZW5nanVAY21zcy5jaGluYW1vYmls
ZS5jb20+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBUYW5nIEJpbiA8dGFuZ2JpbkBjbXNzLmNoaW5h
bW9iaWxlLmNvbT4NCj4gPiBTYWVlZCwgcGxlYXNlIHBpY2sgdGhpcyB1cC4NCj4gDQo+IERvZXMg
dGhpcyBtZWFuIHRoZSBwYXRjaCBoYXMgYmVlbiByZWNlaXZlZCBhbmQgSSBqdXN0IGhhdmUgdG8g
d2FpdD8NCj4gDQoNCm5vLCBtbHg1IHBhdGNoZXMgbm9ybWFsbHkgZ28gdG8gbmV0LW5leHQtbWx4
NSBicmFuY2ggYW5kIHVzdWFsbHkNCnB1bGxlZCBpbnRvIG5ldC1uZXh0IG9uY2UgYSB3ZWVrIHdo
ZW4gaSBzZW5kIG15IHB1bGwgcmVxdWVzdHMuDQoNCmkgd2lsbCByZXBseSB3aXRoICJhcHBsaWVk
IiB3aGVuIGkgYXBwbHkgdGhpcyBwYXRjaCwNCmJ1dCBmb3Igbm93IHBsZWFzZSBmaXggdGhlIHR5
cG8uDQoNClRoYW5rcywNClNhZWVkDQoNCg==
