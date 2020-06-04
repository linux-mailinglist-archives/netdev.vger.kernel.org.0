Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D201EDC76
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 06:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgFDEoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 00:44:06 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:52879
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725950AbgFDEoF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 00:44:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BoS1rZUNaY0e+6yflDrL40WseDLaE0+Ivevu2e9Fgw/ETqAuX62ZHCwV4hdLTcEMR4OYd0bPVCNkIJEvr+wAQiZosKR+ZzTzKQEzRbAaClw9pQVy1IGYoXHBByfaNw06O/Of0pi4bIu/vWoCH7r8HcF+b67vyX9AaGYNYWvvXLAr4xlOD3+NuSPnEBe/2qjJ0sf+FoJbBd1e32YcctzrdeBVDOqZh61RNcvCz8daBelFW2BFK9+8fYjaB45Oje2gE3Cl8O/kC0UJMqcG6NkhqIwWWB/ywuMcgOE0YbaKKyFC0elssutM837vlzCn1ydJDNsjNO+7QbbiGZ3DdOYpBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qd39OPv9YEfg+IVHzvzz4hVYByMsurNoetdNH9r5BlQ=;
 b=jYgRlZosdqrpwZWj384RwG+S2KaBy7cQMHPYyN1ZHPPAta2KuJssxQvEdT33fuf5cuTCFc497bU7xW/vz1iXWlgZO6xcIcYRUasZ0QO4nZU87ckTlCuIDP8WpC6WllYqqJHxC9E2wljGpPWuVx2eT+QGXt6WesqpfwGSIK4WjxmEmtP1INLt/fYj1GnCrxD3mJzIA1xT43gFZBVr2L1Zb5yEVhz9W2HhnnyLtzUwB3C7QyzfanIaQtGHq8G8c4PnBS2wJlvIr/3T4xYgQTajVVh5xOmYLmf5hL2eyv7eZ4Yt4IQvbbJbMdXecrPW64vw+9G9rm0yVW/gp64Dj3mf9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qd39OPv9YEfg+IVHzvzz4hVYByMsurNoetdNH9r5BlQ=;
 b=PuWDtqQJjlCB/wEUlAFmx+H9yI+f1QGxVkLuNdg+S4SFzKjTvFIz3/4CKzREozuizMt9SuAaCzDjOhCeMEVXWvOvwHEWeuFibEWIk1BcrMFqenv9ALreget94SeVKZK+s+x14QqIVsFC+s675ZGwC8i9j+f5t/ofq94+8VV1ldA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6688.eurprd05.prod.outlook.com (2603:10a6:800:131::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Thu, 4 Jun
 2020 04:44:01 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.024; Thu, 4 Jun 2020
 04:44:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "natechancellor@gmail.com" <natechancellor@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        Vu Pham <vuhuong@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net/mlx5: Don't fail driver on failure to create
 debugfs
Thread-Topic: [PATCH net] net/mlx5: Don't fail driver on failure to create
 debugfs
Thread-Index: AQHWONlf0HczwSm0LU6J7Vve55nvl6jFtfwAgAGDlACAAKpCAA==
Date:   Thu, 4 Jun 2020 04:44:00 +0000
Message-ID: <cf22654ba1e726c3f3d1acf7eff2bc167de810c7.camel@mellanox.com>
References: <20200602122837.161519-1-leon@kernel.org>
         <20200602192724.GA672@Ryzen-9-3900X.localdomain>
         <20200603183436.GA2565136@ubuntu-n2-xlarge-x86>
In-Reply-To: <20200603183436.GA2565136@ubuntu-n2-xlarge-x86>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 852d27b9-1bcf-4608-751d-08d80841e6d1
x-ms-traffictypediagnostic: VI1PR05MB6688:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB66886EBC19996C4D7B1893D3BE890@VI1PR05MB6688.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:214;
x-forefront-prvs: 04244E0DC5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sWA/bILKNrugs1lNoUt8QZIXT0KVlrz8M6v0m3H2yHp6lgr4W5k+Hj73l8xyAu3j9+Jwc4nBK2KgjkHdGPlFJa+Hnj2HjDDHcPRwtKq9rGd6evnjbDhhS0oqawsBE8nHjWjyEIi8D4GjWTzuQk6waZLa0o27nbhBNt4aNpmjc3ydftnYku3cskMq+oR15/NfSTzQOzkKl7QNutkLxaFo4WBzYj3f89N54/XFDWaQiZ3FJU+WeqwNUInZY7rHngTknER3lQkTvcmu9lCZh1SweBnd4/IX8R3GNZcyoqdrBD3IUTA8C6LT+lEAtl1KMWtbylaYeI2uVx/2LGamTqI+5XneN4U8tZtZNd5L09HaiLKazS2LYEBOKDs2vL8rBUNHv1eJIv7RaU2/i37crP2csA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(66476007)(64756008)(91956017)(6512007)(186003)(26005)(110136005)(4326008)(6506007)(2616005)(316002)(66446008)(66556008)(54906003)(66946007)(86362001)(5660300002)(478600001)(76116006)(6486002)(2906002)(8936002)(36756003)(8676002)(966005)(71200400001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: X484vt02thxq2Sh1gOhQScxb2iJLe4C8/W4xklHPpo/CPRNLEuOhvO4TQGxI/PRMnALiE5KewmHTuXTvZBSd9Jq2579oKk3PwpILtaA9BH5kTmjkDcDZQmd41Ja9v2dgVW+khK2w0EMZ80IWNX6TP8DtB/zfewq70/Nh3rZJWL8CPpw0FiE3ZUjWr7dDd6+QAquQ7xIsrC04zOeopVkvHGqFfTsmQY7EvqUcI9TAJLWnfZmkAV4R2IE6d39fueoJWUt8gtYjys5FCEoYI6EO2WLco3t7K9DzyResPTSBjBDESQgXmvjoduUtxYOShNb1eYWLcMtXEK+3/4itj3oYhCDE9R2HGDfQCG5dn9/dXUe7plZx7h7G7J0jR9JEgObD79cC7ARWV4nAI3mZr/cimGMmTKychqL0uUWMn+9ih5lTZVeDL2Igxqwd+dIStzO2rfiWV9bFmPQ7mZJx1EkFnx56Nwng4FzXdjrkZ7AOu3I=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4FE1866C8E28294ABCC6F46494F72228@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 852d27b9-1bcf-4608-751d-08d80841e6d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2020 04:44:01.0158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aZJMAaQ9JHJDoOk7hLA6c6luT7eoxiuXa9iHFz1ChQ0r1u7vZQizjMJ9kMSVUAngIX91I3HeSGBamTobVxLl2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6688
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA2LTAzIGF0IDExOjM0IC0wNzAwLCBOYXRoYW4gQ2hhbmNlbGxvciB3cm90
ZToNCj4gT24gVHVlLCBKdW4gMDIsIDIwMjAgYXQgMTI6Mjc6MjRQTSAtMDcwMCwgTmF0aGFuIENo
YW5jZWxsb3Igd3JvdGU6DQo+ID4gT24gVHVlLCBKdW4gMDIsIDIwMjAgYXQgMDM6Mjg6MzdQTSAr
MDMwMCwgTGVvbiBSb21hbm92c2t5IHdyb3RlOg0KPiA+ID4gRnJvbTogTGVvbiBSb21hbm92c2t5
IDxsZW9ucm9AbWVsbGFub3guY29tPg0KPiA+ID4gDQo+ID4gPiBDbGFuZyB3YXJuczoNCj4gPiA+
IA0KPiA+ID4gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4uYzox
Mjc4OjY6IHdhcm5pbmc6DQo+ID4gPiB2YXJpYWJsZQ0KPiA+ID4gJ2VycicgaXMgdXNlZCB1bmlu
aXRpYWxpemVkIHdoZW5ldmVyICdpZicgY29uZGl0aW9uIGlzIHRydWUNCj4gPiA+IFstV3NvbWV0
aW1lcy11bmluaXRpYWxpemVkXQ0KPiA+ID4gICAgICAgICBpZiAoIXByaXYtPmRiZ19yb290KSB7
DQo+ID4gPiAgICAgICAgICAgICBefn5+fn5+fn5+fn5+fn4NCj4gPiA+IGRyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLmM6MTMwMzo5OiBub3RlOg0KPiA+ID4gdW5p
bml0aWFsaXplZCB1c2Ugb2NjdXJzIGhlcmUNCj4gPiA+ICAgICAgICAgcmV0dXJuIGVycjsNCj4g
PiA+ICAgICAgICAgICAgICAgIF5+fg0KPiA+ID4gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL21haW4uYzoxMjc4OjI6IG5vdGU6DQo+ID4gPiByZW1vdmUgdGhlDQo+ID4g
PiAnaWYnIGlmIGl0cyBjb25kaXRpb24gaXMgYWx3YXlzIGZhbHNlDQo+ID4gPiAgICAgICAgIGlm
ICghcHJpdi0+ZGJnX3Jvb3QpIHsNCj4gPiA+ICAgICAgICAgXn5+fn5+fn5+fn5+fn5+fn5+fn5+
fg0KPiA+ID4gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4uYzox
MjU5Ojk6IG5vdGU6DQo+ID4gPiBpbml0aWFsaXplDQo+ID4gPiB0aGUgdmFyaWFibGUgJ2Vycicg
dG8gc2lsZW5jZSB0aGlzIHdhcm5pbmcNCj4gPiA+ICAgICAgICAgaW50IGVycjsNCj4gPiA+ICAg
ICAgICAgICAgICAgIF4NCj4gPiA+ICAgICAgICAgICAgICAgICA9IDANCj4gPiA+IDEgd2Fybmlu
ZyBnZW5lcmF0ZWQuDQo+ID4gPiANCj4gPiA+IFRoZSBjaGVjayBvZiByZXR1cm5lZCB2YWx1ZSBv
ZiBkZWJ1Z2ZzX2NyZWF0ZV9kaXIoKSBpcyB3cm9uZw0KPiA+ID4gYmVjYXVzZQ0KPiA+ID4gYnkg
dGhlIGRlc2lnbiBkZWJ1Z2ZzIGZhaWx1cmVzIHNob3VsZCBuZXZlciBmYWlsIHRoZSBkcml2ZXIg
YW5kDQo+ID4gPiB0aGUNCj4gPiA+IGNoZWNrIGl0c2VsZiB3YXMgd3JvbmcgdG9vLiBUaGUga2Vy
bmVsIGNvbXBpbGVkIHdpdGhvdXQNCj4gPiA+IENPTkZJR19ERUJVR19GUw0KPiA+ID4gd2lsbCBy
ZXR1cm4gRVJSX1BUUigtRU5PREVWKSBhbmQgbm90IE5VTEwgYXMgZXhwZWN0ZWQuDQo+ID4gPiAN
Cj4gPiA+IEZpeGVzOiAxMWYzYjg0ZDcwNjggKCJuZXQvbWx4NTogU3BsaXQgbWRldiBpbml0IGFu
ZCBwY2kgaW5pdCIpDQo+ID4gPiBMaW5rOiBodHRwczovL2dpdGh1Yi5jb20vQ2xhbmdCdWlsdExp
bnV4L2xpbnV4L2lzc3Vlcy8xMDQyDQo+ID4gPiBSZXBvcnRlZC1ieTogTmF0aGFuIENoYW5jZWxs
b3IgPG5hdGVjaGFuY2VsbG9yQGdtYWlsLmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IExlb24g
Um9tYW5vdnNreSA8bGVvbnJvQG1lbGxhbm94LmNvbT4NCj4gPiANCj4gPiBUaGFua3MhIFRoYXQn
cyB3aGF0IEkgZmlndXJlZCBpdCBzaG91bGQgYmUuDQo+ID4gDQo+ID4gUmV2aWV3ZWQtYnk6IE5h
dGhhbiBDaGFuY2VsbG9yIDxuYXRlY2hhbmNlbGxvckBnbWFpbC5jb20+DQo+ID4gDQo+ID4gPiAt
LS0NCj4gPiA+IE9yaWdpbmFsIGRpc2N1c3Npb246DQo+ID4gPiBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9sa21sLzIwMjAwNTMwMDU1NDQ3LjEwMjgwMDQtMS1uYXRlY2hhbmNlbGxvckBnbWFpbC5j
b20NCj4gPiA+IC0tLQ0KPiA+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9tYWluLmMgfCA1IC0tLS0tDQo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDUgZGVsZXRpb25z
KC0pDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvbWFpbi5jDQo+ID4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9tYWluLmMNCj4gPiA+IGluZGV4IGRmNDZiMWZjZTNhNy4uMTEwZThkMjc3
ZDE1IDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL21haW4uYw0KPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL21haW4uYw0KPiA+ID4gQEAgLTEyNzUsMTEgKzEyNzUsNiBAQCBzdGF0aWMgaW50
IG1seDVfbWRldl9pbml0KHN0cnVjdA0KPiA+ID4gbWx4NV9jb3JlX2RldiAqZGV2LCBpbnQgcHJv
ZmlsZV9pZHgpDQo+ID4gPiANCj4gPiA+ICAJcHJpdi0+ZGJnX3Jvb3QgPSBkZWJ1Z2ZzX2NyZWF0
ZV9kaXIoZGV2X25hbWUoZGV2LT5kZXZpY2UpLA0KPiA+ID4gIAkJCQkJICAgIG1seDVfZGVidWdm
c19yb290KTsNCj4gPiA+IC0JaWYgKCFwcml2LT5kYmdfcm9vdCkgew0KPiA+ID4gLQkJZGV2X2Vy
cihkZXYtPmRldmljZSwgIm1seDVfY29yZTogZXJyb3IsIENhbm5vdCBjcmVhdGUNCj4gPiA+IGRl
YnVnZnMgZGlyLCBhYm9ydGluZ1xuIik7DQo+ID4gPiAtCQlnb3RvIGVycl9kYmdfcm9vdDsNCj4g
DQo+IEFjdHVhbGx5LCB0aGlzIHJlbW92ZXMgdGhlIG9ubHkgdXNlIG9mIGVycl9kYmdfcm9vdCwg
c28gdGhhdCBzaG91bGQNCj4gYmUNCj4gcmVtb3ZlZCBhdCB0aGUgc2FtZSB0aW1lLg0KPiANCg0K
Rml4ZWQgdGhpcyB1cCBhbmQgYXBwbGllZCB0byBuZXQtbmV4dC1tbHg1LCANClRoYW5rcyENCg0K
