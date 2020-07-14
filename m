Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7407F220132
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 01:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgGNX64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 19:58:56 -0400
Received: from mail-am6eur05on2063.outbound.protection.outlook.com ([40.107.22.63]:63681
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726472AbgGNX64 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 19:58:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ft1TURcGOnhGCuFwrUMyk/sKhgFUUwIjhigLBW57ZmQrdTzNsXOqwjWHe3jVU/lymZDkrcRPMfuxmndzisz8vbpIqj1hlfNwoMIqiyHraBThsR9lGk+Q/meFbFtf4ZXSgZXsuiUIB+yLbW7LqaUqatWvbRk0X2fIGTSUsmkW3rVGI1KyG8hNWHrc0Kp2DDypuaV/o1QBcGm7sGHZF8WiRIiXxpXo9GR9NCwAeO9xDeTeTcS3kBTu6j8uYLVdmPhXkWBEU+NTU0jLV6sAp9zVFl9ta5Dv1Bwqzi5Aqo4opcMm+wciXN9jSsMIms+/9PHTVEfEaSsA3iLGC1swRQ991Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9gw6pI58Jt4KFv4Putj2XMYI+EDccz00B+NdquRSek=;
 b=GL4zvHQ0DKcijHbzK7siwZkFGwBa9QYOL2+9z+OJ1TcDaRG3Q3sMKkD9yLSWGgVf6jciZg016TKO1g8qxSDkW5CIBMcXQv9YP7NnWW/PSfmxqL1GlMSJ8NaaqCe4kpear7TRWyB4jPrR56e7jJci27BlQZd4zh+JlmbWfpayeWJv13hkFl+k5DCpBr28/cxXQFnKxaaWjR4Wx/lPrszOT5HqfX2+2RmDwU1VmQQxF2CEIe7fh6bAKnvBFOu3m61LdXGhiiCI3vFq6CWJbtxsQs62o4GDrxxvNY1XD01RzFAso5obVwFghHuUPWPXd5t+ekFo+/ad78dIfpbpi3HcDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9gw6pI58Jt4KFv4Putj2XMYI+EDccz00B+NdquRSek=;
 b=IGu0Nh0QncynXoAIkwKvpXNqkH1UKwaGGuMLS5zkpjoNtTS04t/hBN4dgIPGzKs140VoKlXoAlDD7HKwCUL/ej9arwDa+TIkiP4ArtEqGj+pYLX/RvZVWWPIwp/KKj5fBqE14ZjMMT5nolaK0PcVm5pRejon2OS4k4ImFvUYUoA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB3710.eurprd05.prod.outlook.com (2603:10a6:803:8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Tue, 14 Jul
 2020 23:58:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.026; Tue, 14 Jul 2020
 23:58:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>
CC:     "mhocko@suse.cz" <mhocko@suse.cz>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: mmotm 2020-07-09-21-00 uploaded
 (drivers/net/ethernet/mellanox/mlx5/core/en_main.c)
Thread-Topic: mmotm 2020-07-09-21-00 uploaded
 (drivers/net/ethernet/mellanox/mlx5/core/en_main.c)
Thread-Index: AQHWVuE5eC6cD8zlkk+XUVfIMaXhFKkE5yIAgAAERYCAAtxDgA==
Date:   Tue, 14 Jul 2020 23:58:50 +0000
Message-ID: <9135e6e8dc3ca6268c0a1223fea1e6202a23195b.camel@mellanox.com>
References: <20200710040047.md-jEb0TK%akpm@linux-foundation.org>
         <8a6f8902-c36c-b46c-8e6f-05ae612d25ea@infradead.org>
         <20200713140238.72649525@canb.auug.org.au>
         <55d10a82-6e23-2905-0764-234d53b11cb6@infradead.org>
In-Reply-To: <55d10a82-6e23-2905-0764-234d53b11cb6@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none
 header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1e12198e-a717-494f-c2ac-08d82851dae0
x-ms-traffictypediagnostic: VI1PR0502MB3710:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0502MB37101F942276808597C1FC02BE610@VI1PR0502MB3710.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UiHz1wgR4BSylbOxCWL2Ua39NBlXlE/KFF5CfkZe+WBORAieqqaF6YkN41O1ROrcGvr0tHYSqtF6/PrUiSXZdmj98osbBSPVMoLkGbY+TRnsV/klOQdw6+WMN0zRhOboIyq96HHPG2yuKoi86/5BaHJcnGWdC74pfWJgJgOnCljJa4hfwgNmH2SHEKbDv3f3eZBUIwmryU5syxCrJvaYNMp/AEvMReHm529bDyCi2Fv5czrObNHusFc+C6XdKO7OC4URany2xAu0KRSHeeCaPggP89VckQlXdunFKe9mNuvGYe5ypSZNPp18j7VGzijsDOtmMkX+PczL2JCuwDQ8CA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(346002)(39850400004)(376002)(366004)(6512007)(53546011)(8936002)(2906002)(6486002)(6506007)(54906003)(110136005)(86362001)(8676002)(36756003)(316002)(2616005)(66446008)(26005)(66946007)(66476007)(5660300002)(76116006)(478600001)(7416002)(91956017)(66556008)(71200400001)(4326008)(64756008)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Oq4EiRQXktE8QUp6Yp9AlPkpl6DrnL8FQK15i1dADy9SMDU2CZDmHc2JA00UaxJjZNT1EXx0bI6/YWCBvDVKrcMdtfXWKYvIlCbi0n8EQKfe+Gl3CQo8A5wfq3z9sQYC+XMPNbak+GzUZIZ6qzWD3fWdvtI8pEGK9zbtsx5hDfqEqvBPjFLajQsIdk8jaSdYFkoY4sL8gy0JxGtD7MfxaZZ4bq0OP1FJx0rZ0KUrj4dl42bFuco6riJNC1OCdc5CrV0NzGY9DZfuAuVvZqcRj9ozLKwNeqc4vYO293X8Zd+HT6gyrtic3Dnu7BMlLjIXkytjV9A2cruBs7eSgENCIg2U2w64ZO4IrR7+tshjWiAaSoCjYEfd0t/nAsksi7xZDAlpFZtP+uPvN9p3BvHOebcT4ov68aNKgo3EH09vyS0oDPNnQ1RRrZdTbvlVV9NfTWo/gV3AkizTV6Cq1iNEC6Y0HOqiXiYeb54+bzCqSo8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C1585AF7901C447B0A6CFF8D1BFE406@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e12198e-a717-494f-c2ac-08d82851dae0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2020 23:58:50.1450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m7NtTU50FFDdfI2KAbszX7igy2w0O7n3ogXZa08tLuNrAVitB924zZFWAYi8Vk5tQAq53I0SmA2YQ5g1UTA5EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3710
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTA3LTEyIGF0IDIxOjE3IC0wNzAwLCBSYW5keSBEdW5sYXAgd3JvdGU6DQo+
IE9uIDcvMTIvMjAgOTowMiBQTSwgU3RlcGhlbiBSb3Rod2VsbCB3cm90ZToNCj4gPiBIaSBSYW5k
eSwNCj4gPiANCj4gPiBPbiBGcmksIDEwIEp1bCAyMDIwIDEwOjQwOjI5IC0wNzAwIFJhbmR5IER1
bmxhcCA8DQo+ID4gcmR1bmxhcEBpbmZyYWRlYWQub3JnPiB3cm90ZToNCj4gPiA+IG9uIGkzODY6
DQo+ID4gPiANCj4gPiA+IEluIGZpbGUgaW5jbHVkZWQgZnJvbQ0KPiA+ID4gLi4vZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYzo0OTowOg0KPiA+ID4gLi4v
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL2VuX2FjY2Vs
Lmg6DQo+ID4gPiBJbiBmdW5jdGlvbiDigJhtbHg1ZV9hY2NlbF9za19nZXRfcnhx4oCZOg0KPiA+
ID4gLi4vZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL2Vu
X2FjY2VsLmg6MTUNCj4gPiA+IDM6MTI6IGVycm9yOiBpbXBsaWNpdCBkZWNsYXJhdGlvbiBvZiBm
dW5jdGlvbiDigJhza19yeF9xdWV1ZV9nZXTigJk7DQo+ID4gPiBkaWQgeW91IG1lYW4g4oCYc2tf
cnhfcXVldWVfc2V04oCZPyBbLVdlcnJvcj1pbXBsaWNpdC1mdW5jdGlvbi0NCj4gPiA+IGRlY2xh
cmF0aW9uXQ0KPiA+ID4gICBpbnQgcnhxID0gc2tfcnhfcXVldWVfZ2V0KHNrKTsNCj4gPiA+ICAg
ICAgICAgICAgIF5+fn5+fn5+fn5+fn5+fg0KPiA+ID4gICAgICAgICAgICAgc2tfcnhfcXVldWVf
c2V0DQo+ID4gDQo+ID4gQ2F1c2VkIGJ5IGNvbW1pdA0KPiA+IA0KPiA+ICAgMTE4MmYzNjU5MzU3
ICgibmV0L21seDVlOiBrVExTLCBBZGQga1RMUyBSWCBIVyBvZmZsb2FkIHN1cHBvcnQiKQ0KPiA+
IA0KPiA+IGZyb20gdGhlIG5ldC1uZXh0IHRyZWUuICBQcmVzdW1hYmx5IENPTkZJR19YUFMgaXMg
bm90IHNldC4NCj4gDQo+IFllcywgdGhhdCdzIGNvcnJlY3QuDQo+IA0KDQpUaGFua3MgZm9yIHRo
ZSByZXBvcnQsIHdlIHdpbGwgaGFuZGxlIGFuZCBzdWJtaXQgYSBwYXRjaCB0byBuZXQtbmV4dC4N
Cg==
