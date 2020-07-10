Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931FE21AD03
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 04:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGJCSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 22:18:07 -0400
Received: from mail-eopbgr40048.outbound.protection.outlook.com ([40.107.4.48]:58113
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726323AbgGJCSG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 22:18:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kFHGSeaO7Yjol0WIwXAq1zDS+/5BERTKZQrdlGY1edHnbx7hUvVZbwCdMY2XRtkzJSqXkVkNiglYSGV6GUoiT6MknZG1AHWZjvC88zvhDzDYM5HPai+OTbfyti0FXB2TGPyPpKbF7tKEgNLr0jEDYhTicFeGQwVOj5XtXwagxjrUQm5V78YauOLjB7Xb4Jo9O90y5ZumKC9m0HiCjcdfLnuxdfQdgJ4I2e9qV55oh7yfWe/zAtcOWdh/dHMwuUzc+eOO3FWxyyFYnOjjT2qb3GhOlxnUdtC8uXzHyPsGrNPFvu/6JCY/VyOnTQED9cVLYAzU7TR3ettQlfG/FkGUbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qH61H2FwD8HZDII+52BeE056D+3I+HzORwXlw6Iq+OQ=;
 b=Ql0q4ufc5RK3NE76sMf9kndAuKjLcXHeeVC6weDRK48RuF1eJkZZZzgwiG0a5fi3duzJsZgF4dt9VRnCygD1dnkU2V9z/SkHGqo+5T5zr0JtII7YKLB6RnVTwXN1ct23KL9cl+Ci/4zUNYqmYVbYwEaFiVdRpdJSNC0hi33n/9T8p8xnX184xSfM9/igvMbQ+E+idlZ8vCx/PbHTbyDCMfNGlqs5ehAAOPvj8CBDGvx7ZbYuztJlLD494uZh3zKVmO91zU1njoj5IL/3Gwd0IWUzU7y85ulmT7fRrXdFvqWbfFwy9U6ij/AD/Hnad6jXDHd2QRplhd29VA1++SIOMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qH61H2FwD8HZDII+52BeE056D+3I+HzORwXlw6Iq+OQ=;
 b=BY1z9JQswwf9Tn9VEHkekBGeW+iARYFUni0g1pq0TQXItx+CIorMjaFZszFP+Ug0JeGJwxnPhpKiZTk7po8jhi9rCMoCKVl9ovpt+QvDJ0TUuoVJWzNN8AamzT3opcFVhNaV9BTVX8sxpDXXfIQtdFpCKtevv4GOgxSetEfjD1Q=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6496.eurprd05.prod.outlook.com (2603:10a6:803:f3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 02:18:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 02:18:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        Aya Levin <ayal@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
Thread-Topic: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
Thread-Index: AQHWSZftaIEAvWsK9UqUrJlFGGGeOajmuBIAgACd/gCAAAqXAIAApF4AgAAwHoCAAAQ5AIASXnCAgAByOICs2vsVANMoY1YAgAACqgCAATB9AIAADGSAgAAYYQCAAG0fAA==
Date:   Fri, 10 Jul 2020 02:18:02 +0000
Message-ID: <64f58446adb2536f87ea13cc5f0a88cd77d5cd5b.camel@mellanox.com>
References: <0506f0aa-f35e-09c7-5ba0-b74cd9eb1384@mellanox.com>
         <20200708231630.GA472767@bjorn-Precision-5520>
         <20200708232602.GO23676@nvidia.com>
         <20200709173550.skza6igm72xrkw4w@bsd-mbp.dhcp.thefacebook.com>
         <20200709182011.GQ23676@nvidia.com>
         <20200709124726.24315b6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200709124726.24315b6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 02dca5da-1702-475a-4307-08d82477796f
x-ms-traffictypediagnostic: VI1PR05MB6496:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6496BFF3255FF2B3E2D128B7BE650@VI1PR05MB6496.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xI20d3kd8s0W8YNWo8xvGLt/D5R0Jqd1GppiUWlrsgXAp9CL24Rg7GOfoWza1+MwK6cu0cBv69XyKwu4SAzZX2lr/lBXq+X0kDoG2Q4bF74+mNaKbbEk1A6voqs4L4or3508xF1PI4mF6tLbx0EeGclFsfXXoc8JtdT6ZKiN8WZ/38USlGzKRgb3EKKDsCjOHnELexdFFJ5SB2FC8oqbv4E6FDFLhoDpZ0V3ur6kySCVhjKWmajfGBTrandHE2ww48YlcFBF3kB9K8Wvv00Gl6a43dmYxbseaMUUXsLfbtKtDRDmumXdlypatt/uzL5gOivd1PQBRsme5IZkAGZt4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(366004)(346002)(136003)(36756003)(2616005)(316002)(5660300002)(76116006)(86362001)(91956017)(66446008)(64756008)(66556008)(66476007)(71200400001)(66946007)(6486002)(2906002)(26005)(8676002)(186003)(6512007)(6506007)(4326008)(478600001)(83380400001)(110136005)(54906003)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: BqxcyPajEl2jsLhTaWF7o7z0u/6Xj09ixXh/fClcpSWM/Mu6XH4EAFqPSJZJ6JQ0vL2ZCcsYMG8tbkW6wH52kSXutu2ECu6jvrBPvbI2S8We/LRtz2biz7ebj/amJr+Icfy8MwFm+neKqvEPWBC+ejOc/1mJ+mTO2rNpAmztK9w5O5GuPLGnrn2baHwS30ueQTL9SKKjJZa9AhvKsEnvltW+MSS7FUqS2QkcBmjZUMFmLkEdvus6ddfEtsKpkTE0ZnULzAmMvHKktz8Rjb+x+yoO4rO+vgTDV0g6f1a49xAXll6lipKUWHmZhENxDe5aYpcmCLxhVvJ877prXwiIyv1osBVGXpiR/VZKNBMXUmNaltqz+7KtaOKXl9SfbxVek4jfQ5d6m7+sN+atwyZfwUVJpJHWXAgnuDoBzkxkLhyVnDFbLGyaACO4jaitD4WDTRSwvLzcJd6DD/dqqOuFiQafvzcOZGAmeyuQ/OG8bT4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <43C23A9436952F4F81E755ECFBFF908C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02dca5da-1702-475a-4307-08d82477796f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2020 02:18:02.8968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7D5xgtkaGvNA0/PIIqwGmBALxYx2MSEQHXNqwsVamCi4aWPj3RohLBekvo7DygSN0Fwu9dXzkPZzcsYhiuS5gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6496
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA3LTA5IGF0IDEyOjQ3IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCA5IEp1bCAyMDIwIDE1OjIwOjExIC0wMzAwIEphc29uIEd1bnRob3JwZSB3cm90
ZToNCj4gPiA+ICAgICAyKSBoYXZpbmcgdGhlIGRyaXZlciBzZXQgUk8gb24gdGhlIHRyYW5zYWN0
aW9ucyBpdCBpbml0aWF0ZXMsDQo+ID4gPiB3aGljaA0KPiA+ID4gICAgICAgIGFyZSBob25vcmVk
IGlmZiB0aGUgUENJIGJpdCBpcyBzZXQuDQo+ID4gPiANCj4gPiA+IEl0IHNlZW1zIHRoYXQgaW4g
YWRkaXRpb24gdG8gdGhlIFBDSSBjb3JlIGNoYW5nZXMsIHRoZXJlIHN0aWxsIGlzDQo+ID4gPiBh
IG5lZWQNCj4gPiA+IGZvciBkcml2ZXIgY29udHJvbHM/ICBVbmxlc3MgdGhlIGRyaXZlciBhbHdh
eXMgZW5hYmxlcyBSTyBpZiBpdCdzDQo+ID4gPiBjYXBhYmxlPyAgDQo+ID4gDQo+ID4gSSB0aGlu
ayB0aGUgUENJIHNwZWMgaW1hZ2luZWQgdGhhdCB3aGVuIHRoZSBjb25maWcgc3BhY2UgUk8gYml0
IHdhcw0KPiA+IGVuYWJsZWQgdGhlIFBDSSBkZXZpY2Ugd291bGQganVzdCBzdGFydCB1c2luZyBS
TyBwYWNrZXRzLCBpbiBhbg0KPiA+IGFwcHJvcHJpYXRlIGFuZCBkZXZpY2Ugc3BlY2lmaWMgd2F5
Lg0KPiA+IA0KPiA+IFNvIHRoZSBmaW5lIGdyYWluZWQgY29udHJvbCBpbiAjMiBpcyBzb21ldGhp
bmcgZG9uZSBleHRyYSBieSBzb21lDQo+ID4gZGV2aWNlcy4NCj4gPiANCj4gPiBJTUhPIGlmIHRo
ZSBkcml2ZXIga25vd3MgaXQgaXMgZnVuY3Rpb25hbGx5IGNvcnJlY3Qgd2l0aCBSTyB0aGVuIGl0
DQo+ID4gc2hvdWxkIGVuYWJsZSBpdCBmdWxseSBvbiB0aGUgZGV2aWNlIHdoZW4gdGhlIGNvbmZp
ZyBzcGFjZSBiaXQgaXMNCj4gPiBzZXQuDQo+ID4gDQo+ID4gSSdtIG5vdCBzdXJlIHRoZXJlIGlz
IGEgcmVhc29uIHRvIGFsbG93IHVzZXJzIHRvIGZpbmVseSB0dW5lIFJPLCBhdA0KPiA+IGxlYXN0
IEkgaGF2ZW4ndCBoZWFyZCBvZiBjYXNlcyB3aGVyZSBSTyBpcyBhIGRlZ3JlZGF0aW9uIGRlcGVu
ZGluZw0KPiA+IG9uDQo+ID4gd29ya2xvYWQuDQo+ID4gDQo+ID4gSWYgc29tZSBwbGF0Zm9ybSBk
b2Vzbid0IHdvcmsgd2hlbiBSTyBpcyB0dXJuZWQgb24gdGhlbiBpdCBzaG91bGQNCj4gPiBiZQ0K
PiA+IGdsb2JhbGx5IGJsYWNrIGxpc3RlZCBsaWtlIGlzIGFscmVhZHkgZG9uZSBpbiBzb21lIGNh
c2VzLg0KPiA+IA0KPiA+IElmIHRoZSBkZXZpY2VzIGhhcyBidWdzIGFuZCB1c2VzIFJPIHdyb25n
LCBvciB0aGUgZHJpdmVyIGhhcyBidWdzDQo+ID4gYW5kDQo+ID4gaXMgb25seSBzdGFibGUgd2l0
aCAhUk8gYW5kIEludGVsLCB0aGVuIHRoZSBkcml2ZXIgc2hvdWxkbid0IHR1cm4NCj4gPiBpdA0K
PiA+IG9uIGF0IGFsbC4NCj4gPiANCj4gPiBJbiBhbGwgb2YgdGhlc2UgY2FzZXMgaXQgaXMgbm90
IGEgdXNlciB0dW5hYmxlLg0KPiA+IA0KPiA+IERldmVsb3BtZW50IGFuZCB0ZXN0aW5nIHJlYXNv
bnMsIGxpa2UgJ2lzIG15IGNyYXNoIGZyb20gYSBSTyBidWc/Jw0KPiA+IHRvDQo+ID4gdHVuZSBz
aG91bGQgYmUgbWV0IGJ5IHRoZSBkZXZpY2UgZ2xvYmFsIHNldHBjaSwgSSB0aGluay4NCj4gDQo+
ICsxDQoNCkJlIGNhcmVmdWwgdGhvdWdoIHRvIGxvYWQgZHJpdmVyIHdpdGggUk8gb24gYW5kIHRo
ZW4gc2V0cGNpIFJPIG9mZi4uIA0Kbm90IHN1cmUgd2hhdCB0aGUgc2lkZSBlZmZlY3RzIGFyZSwg
dW5zdGFibGUgZHJpdmVyIG1heWJlID8NCkFuZCBub3Qgc3VyZSB3aGF0IHNob3VsZCBiZSB0aGUg
cHJvY2VkdXJlIHRoZW4gPyByZWxvYWQgZHJpdmVyID8gRlcNCndpbGwgZ2V0IGEgbm90aWZpY2F0
aW9uIGZyb20gUENJID8gDQoNCg==
