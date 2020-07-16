Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88491222EA9
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgGPXJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728031AbgGPXJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 19:09:23 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0612.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3976FC08E6DC
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 16:07:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KwoHrZcvJYDTsPJdn9W4GsHDThi8YnqNeQ3t3BH9lLjDaMBSsASs2KJG13XnzoSqaidc6xkgCRKZT6oy6fVd3Ga578JcqiKktNnqkM+9BVUM35fkScVTTvjm/ZUpduQgAt2sZxRRXMN+eF4WoZLSV1+U/lE9D6u6nmLqBkDvAGkhyhYrrIa9ca3QmQfEYPHBJvEx1PGV+suG9a5jdG3yokItRbEKEbWM90Oh5dk5w0zCTmLMiNDf0Eale8K3Gq8C5H4TcCsaB7NJS3byneLgxPvwR55+HXNlKQuC2UKkgC87toUotVpbVT/2bAwonMwOMg3APigtKdfGIH4TvKZcRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYhIgkm3FKQc8kxM1KqVMvzGulw12ELkkvAMGnss1as=;
 b=ZzVbhdTxgHQ7lizekARLJK8GV8sFXBTlqV9rrigipM0qXXdirN+Lj0CrUHDqmbXfQPgAtbPyb98KXpOKXtYt6tCuA7HtPFn/vpuLe5pqRZoSGV3CX+gzyfHL79UmnWrY+BIcC4HNjWzDLH2/kXgevKWTl/KR7ko5jdNga5S8pQ7+bLtZLTgM+RQ6op2NEzWj/2T0SGAE5MefiB5px27C4zwtLJQuLQHwk12wsiO2bMtkv581BCzauDiFqsX5yu+wP6CL8yS75z9hmCjCewPO3ZChmzB3VZebcNdkYf9D1lymqAvki68efJIrRb+A7QdU90HnSuG2wjrNmXMQqT7e6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYhIgkm3FKQc8kxM1KqVMvzGulw12ELkkvAMGnss1as=;
 b=Nn+iNYGQaY8o3fs6YEnVwNs1JBWPxBLNNLxi6qCFeHdN/I3tKJTqYpjt4i3+rxdrC9wuG2ggb+mf8W0ZgW6B0ILhUzEjgWjtOUo4UWDUNlvsoU3FnycXqkNq3J6dluMk4TRvNMctmFksJBMm6yCa85D9UbsLln/PdPLqDJ3rEVo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6014.eurprd05.prod.outlook.com (2603:10a6:803:ed::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Thu, 16 Jul
 2020 23:07:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Thu, 16 Jul 2020
 23:07:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: Re: [net-next 12/15] net/mlx5e: XDP, Avoid indirect call in TX flow
Thread-Topic: [net-next 12/15] net/mlx5e: XDP, Avoid indirect call in TX flow
Thread-Index: AQHWW7jWOrwCkzU3x0eOOAUc34bUT6kKyNaAgAALWwA=
Date:   Thu, 16 Jul 2020 23:07:06 +0000
Message-ID: <bebe16b8ddc64d75c62ae49c03624ea3ef1cb677.camel@mellanox.com>
References: <20200716213321.29468-1-saeedm@mellanox.com>
         <20200716213321.29468-13-saeedm@mellanox.com>
         <20200716152625.01651110@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200716152625.01651110@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 29b4ae0f-5c48-4799-98f8-08d829dcf587
x-ms-traffictypediagnostic: VI1PR05MB6014:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB60149188DBBA4CD68603849ABE7F0@VI1PR05MB6014.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:215;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nB2c1RYawm4zVOlJRqVsAd1V3SMCDewLnVqowtmzhqp0U04MyNf1Lf2/nPFiUxJlZi+hrK3QTI/u2sl0DZz2vU4/IMUIT5x5EY8kOq0U0NLbAOykc0zYLdfaW7AHPAFk2NJ0punov0b4asLzGYCkBgW9q/5/qG4hHyt+lHc2laku/PSb7PEnirzw0KzTnLJTREeXehgHlDH9U84laeuGh57Dv4ul5Pc3BIsEd18/GP0j/25gCHVSSmcR+pYzeGlqkgM/3tJ/rnZFMlSiCiXOXUXSWYCrDBB0bzE3Xi1DuwSFMPaUUERnlEJSb78Qfz28805G/NZ7xGlH9Gvc7P7RxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(107886003)(4326008)(2906002)(76116006)(316002)(186003)(26005)(6506007)(6486002)(2616005)(8936002)(91956017)(6916009)(36756003)(5660300002)(64756008)(54906003)(66476007)(83380400001)(71200400001)(6512007)(478600001)(66556008)(66946007)(86362001)(66446008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: t2p8JeJLzTyqr5PmbdrMN+dytz64SivvKScPDR3wHWu7L0bD3HuckC+Tar0bVTw/jWku9VR/okrIGDaApTxkmIrTcuqyYJduLXlRoDBBD96PR82MyraE3KTd31ZJ0gsuPQnhWEhA9uhC6YlZ8CUh5cfhyIi5QBLQbNypggVVJPNtdcZ7k7vlbg8Bq0qIk/QOUfNXmCSfFXNl8a93tHh05kPN+OqsJDJHXQE3Q/IzEwozC+XvmtJm3w2PJuROXJ1lyfsUt3c9KkJXqMbh+clm+kpbYVkFDwKdV3nggt/kfokpm5HzjwCJGaUx7+u/zWVnNUkMikgNEszJ1AyxIpz6eK7mG93Mjs4Z3S0QetJXEHF1+VPwLGpbkYkhNV7EapPIy9j1Gw4Qotw3G2Hi0vWQk87cArd4jKAUOca9yOR5Zq/EA6w5T/cKrGaB8S0y6Kml9DZiZQdL7Z7YKFlSYg0GttnpJxg0lGup2KKNwKrGqAg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <908958F031ADF041A217350E50143408@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29b4ae0f-5c48-4799-98f8-08d829dcf587
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2020 23:07:06.0324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GKJkcxEoBcnGZ1/35wgan8Gcpm6DCK7pBwJDHTyyP+8n/2RhwH615gRtgHC/pUDVDOOuJLNNDOGiJ3dv0thl3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6014
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA3LTE2IGF0IDE1OjI2IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAxNiBKdWwgMjAyMCAxNDozMzoxOCAtMDcwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBGcm9tOiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBtZWxsYW5veC5jb20+DQo+ID4gDQo+
ID4gVXNlIElORElSRUNUX0NBTExfMigpIGhlbHBlciB0byBhdm9pZCB0aGUgY29zdCBvZiB0aGUg
aW5kaXJlY3QgY2FsbA0KPiA+IHdoZW4vaWYgQ09ORklHX1JFVFBPTElORT15Lg0KPiA+IA0KPiA+
IFNpZ25lZC1vZmYtYnk6IFRhcmlxIFRvdWthbiA8dGFyaXF0QG1lbGxhbm94LmNvbT4NCj4gPiBS
ZXZpZXdlZC1ieTogTWF4aW0gTWlraXR5YW5za2l5IDxtYXhpbW1pQG1lbGxhbm94LmNvbT4NCj4g
PiBTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCj4g
DQo+IEFyZSB0aGVzZSBleHBlY3RlZD8NCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbi94ZHAuYzoyNTE6Mjk6IHdhcm5pbmc6DQo+IHN5bWJvbCAnbWx4NWVf
eG1pdF94ZHBfZnJhbWVfY2hlY2tfbXB3cWUnIHdhcyBub3QgZGVjbGFyZWQuIFNob3VsZCBpdA0K
PiBiZSBzdGF0aWM/DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bi94ZHAuYzozMDY6Mjk6IHdhcm5pbmc6DQo+IHN5bWJvbCAnbWx4NWVfeG1pdF94ZHBfZnJhbWVf
Y2hlY2snIHdhcyBub3QgZGVjbGFyZWQuIFNob3VsZCBpdCBiZQ0KPiBzdGF0aWM/DQo+IGRyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94ZHAuYzoyNTE6Mjk6IHdhcm5p
bmc6IG5vDQo+IHByZXZpb3VzIHByb3RvdHlwZSBmb3Ig4oCYbWx4NWVfeG1pdF94ZHBfZnJhbWVf
Y2hlY2tfbXB3cWXigJkgWy1XbWlzc2luZy0NCj4gcHJvdG90eXBlc10NCj4gICAyNTEgfCBJTkRJ
UkVDVF9DQUxMQUJMRV9TQ09QRSBpbnQNCj4gbWx4NWVfeG1pdF94ZHBfZnJhbWVfY2hlY2tfbXB3
cWUoc3RydWN0IG1seDVlX3hkcHNxICpzcSkNCj4gICAgICAgfCAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgXn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4NCj4gZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hkcC5jOjMwNjoyOTogd2FybmluZzogbm8N
Cj4gcHJldmlvdXMgcHJvdG90eXBlIGZvciDigJhtbHg1ZV94bWl0X3hkcF9mcmFtZV9jaGVja+KA
mSBbLVdtaXNzaW5nLQ0KPiBwcm90b3R5cGVzXQ0KPiAgIDMwNiB8IElORElSRUNUX0NBTExBQkxF
X1NDT1BFIGludCBtbHg1ZV94bWl0X3hkcF9mcmFtZV9jaGVjayhzdHJ1Y3QNCj4gbWx4NWVfeGRw
c3EgKnNxKQ0KPiAgICAgICB8ICAgICAgICAgDQoNCk5vLCBtaXNzaW5nIElORElSRUNUX0NBTExB
QkxFX0RFQ0xBUkUoKSBJIGd1ZXNzLCB3aWxsIGZpeCB0aGlzIHVwLg0KDQpUaGFua3MgZm9yZSB0
aGUgcmVwb3J0Lg0KDQo=
