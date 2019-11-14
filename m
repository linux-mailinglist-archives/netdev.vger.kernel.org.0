Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 554C0FD1C0
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 00:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfKNX5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 18:57:52 -0500
Received: from mail-eopbgr10083.outbound.protection.outlook.com ([40.107.1.83]:35651
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726767AbfKNX5w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 18:57:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmNKiZW8AsaMIFt3stvkqLPaKAu0fFLno7oBUxcV/lXfqJJNjpa91znq3MjmnS5x1qkfA8fje5wS5kuuMJBtTeLAl+/4MZD1oPdgADV6HjQiKJIQRYCreU2cAtlnO8nMr8keFWqxaQAzZDow38JhSsk+Vv/lySFkg6OYIzW5D8SrKbrhLAHKUqqwyjECx2B7OCxfyKJWyPLFPbyEYm2F08Rc+fZ40I07AegBbeQzb2lan2C4n8cOBTioy1odPJ0SSTMBysiLjz+pDBM78mK1Qb1bQKGN7qJaHeRREgD5y7asxRhct5lIymQ9OXlYZ6xF0UWHBVydyb38wa0tQXmlNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xQduZoRTP7D/Y5A3GFHlLEKrAIQFgGiIQUKdawLQa8=;
 b=HVvZ7wPxUp8c7hj/sdN1u5R3Hpu1zT/8pZmX3X391mCFqelnKQgLhMIrIp1fJWgkRogGCff5xATyslsgZO9ORoJCHCK6iryv1BCYOd/4wMjckCfQY6U/uq1+EVPccnH3qZHh+6PMQFzCZXqKu2JUHZyn1B/dP+q8riIvFa6Y/dpbEU0PfHd0fUBwpc6ST10Ces4D40bOsPPY8fDo1FV7hXP/5pyDmxri/vXvZHx82sNwq0LZiK9rdYrFVmAkB1vVXkbf6i/w4uLATJBgDyUi4LwsuNRHW3f0RslQZfxdtMyI+B0cet7+p6teVel09p3lGCv1AZaeF9Opl21x7/THXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xQduZoRTP7D/Y5A3GFHlLEKrAIQFgGiIQUKdawLQa8=;
 b=dgDTQKulBpWqeew3n/RTbzyxZtA5/kwuEQeoaGZBGduQWEQbMCvBttjKIpQ7DMPoJi/6ifudQDEgTxEK8CRT7RwFlrAn7edlza4oRpCaTAJTbg/8H8xIyfgtCPxnFCnjbPqWsS5DRMr5NlJ8rH3w8xHD8dnl3ITQBZxdz3UL8hU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3215.eurprd05.prod.outlook.com (10.175.245.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.23; Thu, 14 Nov 2019 23:57:42 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.028; Thu, 14 Nov 2019
 23:57:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "christopher.s.hall@intel.com" <christopher.s.hall@intel.com>,
        Eugenia Emantayev <eugenia@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        Feras Daoud <ferasda@mellanox.com>,
        "stefan.sorensen@spectralink.com" <stefan.sorensen@spectralink.com>,
        "aaron.f.brown@intel.com" <aaron.f.brown@intel.com>,
        "brandon.streiff@ni.com" <brandon.streiff@ni.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>
Subject: Re: [PATCH net 02/13] net: reject PTP periodic output requests with
 unsupported flags
Thread-Topic: [PATCH net 02/13] net: reject PTP periodic output requests with
 unsupported flags
Thread-Index: AQHVmxustEEKnQ2rokKSH/LypN6cMKeLWF+A
Date:   Thu, 14 Nov 2019 23:57:42 +0000
Message-ID: <7275436b02f9551807f68784d4f4ebaf0adbc35e.camel@mellanox.com>
References: <20191114184507.18937-3-richardcochran@gmail.com>
In-Reply-To: <20191114184507.18937-3-richardcochran@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b2731854-e0a6-4d6c-788f-08d7695e6ff4
x-ms-traffictypediagnostic: VI1PR05MB3215:|VI1PR05MB3215:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB32152ED590DB57DE3DB78AA1BE710@VI1PR05MB3215.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(189003)(199004)(26005)(14454004)(2616005)(6512007)(118296001)(4001150100001)(446003)(76176011)(66476007)(66556008)(66066001)(6506007)(66446008)(64756008)(76116006)(91956017)(6486002)(66946007)(5660300002)(476003)(186003)(229853002)(11346002)(6436002)(102836004)(14444005)(99286004)(6116002)(3846002)(25786009)(2501003)(71190400001)(486006)(256004)(8936002)(36756003)(54906003)(71200400001)(478600001)(58126008)(7736002)(8676002)(7416002)(86362001)(4326008)(305945005)(6246003)(2906002)(81156014)(81166006)(110136005)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3215;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y0GSu3mlmHDF/7VX5hvVIv+ntPu6tNm/oEdaXP1TODeDz1wsR4vYFo3knlWt14rd1O7DwdkMsDhqLabmow8979Nodrccy65D9uHO/sUDYgkA6OiYq6JhEPL+jZFnP99u1X+giFJXLX5mJPFhHh0dyXioeCPOFDTYkwTLHJCQ1Mhwhi8WXYibtVw1HBvNF87OiaRUulwQ5bvG/b7+iRpqdnZ1txk8rCc/fCbD0rbj5FC8YipZUVcVkDQFyBvUgJYiDNUAso0J5wUeznntJIzez0JEnMn17P8DeOjqiKw6SrbZ6tn26Jv+//qYGdtQn7lfs50qMXg56bZEXdvvzP44wjAzb3KCh70UbCJhrV305J2rEA9qC6confcDu+YNu9wZfmjUUBH9Kkj9Mnubp+olDgOEGyMyOuPzjX7McF1Cb3xKQ6gLjY6gDpz+/2v5Ph9K
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B23B2DF41ECF34EAE34EFCC857BF7C3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2731854-e0a6-4d6c-788f-08d7695e6ff4
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 23:57:42.0740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dJVfepjE67U7l6pMTeLRZbqGODI6QbW/kagNWr3i39XU8OhyTznJf+gSVlGpGwDaDV6ZhmyvUuGBxvfPXoVWug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTExLTE0IGF0IDEwOjQ0IC0wODAwLCBSaWNoYXJkIENvY2hyYW4gd3JvdGU6
DQo+IEZyb206IEphY29iIEtlbGxlciA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPg0KPiANCj4g
Q29tbWl0IDgyM2ViMmEzYzRjNyAoIlBUUDogYWRkIHN1cHBvcnQgZm9yIG9uZS1zaG90IG91dHB1
dCIpDQo+IGludHJvZHVjZWQNCj4gYSBuZXcgZmxhZyBmb3IgdGhlIFBUUCBwZXJpb2RpYyBvdXRw
dXQgcmVxdWVzdCBpb2N0bC4gVGhpcyBmbGFnIGlzDQo+IG5vdA0KPiBjdXJyZW50bHkgc3VwcG9y
dGVkIGJ5IGFueSBkcml2ZXIuDQo+IA0KPiBGaXggYWxsIGRyaXZlcnMgd2hpY2ggaW1wbGVtZW50
IHRoZSBwZXJpb2RpYyBvdXRwdXQgcmVxdWVzdCBpb2N0bCB0bw0KPiBleHBsaWNpdGx5IHJlamVj
dCBhbnkgcmVxdWVzdCB3aXRoIGZsYWdzIHRoZXkgZG8gbm90IHVuZGVyc3RhbmQuIFRoaXMNCj4g
ZW5zdXJlcyB0aGF0IHRoZSBkcml2ZXIgZG9lcyBub3QgYWNjaWRlbnRhbGx5IG1pc2ludGVycHJl
dCB0aGUNCj4gUFRQX1BFUk9VVF9PTkVfU0hPVCBmbGFnLCBvciBhbnkgbmV3IGZsYWcgaW50cm9k
dWNlZCBpbiB0aGUgZnV0dXJlLg0KPiANCj4gVGhpcyBpcyBpbXBvcnRhbnQgZm9yIGZvcndhcmQg
Y29tcGF0aWJpbGl0eTogaWYgYSBuZXcgZmxhZyBpcw0KPiBpbnRyb2R1Y2VkLCB0aGUgZHJpdmVy
IHNob3VsZCByZWplY3QgcmVxdWVzdHMgdG8gZW5hYmxlIHRoZSBmbGFnDQo+IHVudGlsDQo+IHRo
ZSBkcml2ZXIgaGFzIGFjdHVhbGx5IGJlZW4gbW9kaWZpZWQgdG8gc3VwcG9ydCB0aGUgZmxhZyBp
bg0KPiBxdWVzdGlvbi4NCg0KTEdUTSwganVzdCB0aGVyZSBtaWdodCBiZSBhIHByb2JsZW0gd2l0
aCBvbGQgdG9vbHMgdGhhdCBkaWRuJ3QgY2xlYXINCnRoZSBmbGFncyB1cG9uIHJlcXVlc3QgYW5k
IGV4cGVjdGVkIFBUUCBwZXJpb2RpYyAuLiB0aGV5IHdpbGwgc3RvcCB0bw0Kd29yayB3aXRoIG5l
dyBrZXJuZWwsIGFtIGkgYW0gbm90IHN1cmUgaWYgc3VjaCB0b29scyBkbyBleGlzdC4NCg0KQnV0
IHRoZSBmYWN0IG5vdyB0aGF0IHdlIGhhdmUgUFRQX1BFUk9VVF9PTkVfU0hPVCwgd2UgbmVlZCB0
byB0cnVzdA0KYm90aCBkcml2ZXIgYW5kIHRvb2xzIHRvIGRvIHRoZSByaWdodCB0aGluZy4NCg0K
V2hhdCBhcmUgdGhlIHRvb2xzIHRvIHRlc3QgUFRQX1BFUk9VVF9PTkVfU0hPVCA/IHRvIHN1cHBv
cnQgdGhpcyBpbg0KbWx4NSBpdCBpcyBqdXN0IGEgbWF0dGVyIG9mIGEgZmxpcHBpbmcgYSBiaXQu
DQoNClJldmlld2VkLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCg0K
PiANCj4gQ2M6IEZlbGlwZSBCYWxiaSA8ZmVsaXBlLmJhbGJpQGxpbnV4LmludGVsLmNvbT4NCj4g
Q2M6IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4gQ2M6IENocmlzdG9w
aGVyIEhhbGwgPGNocmlzdG9waGVyLnMuaGFsbEBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IEphY29iIEtlbGxlciA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5
OiBSaWNoYXJkIENvY2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gVGVzdGVkLWJ5
OiBBYXJvbiBCcm93biA8YWFyb24uZi5icm93bkBpbnRlbC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vdGczLmMgICAgICAgICAgICAgICAgIHwgNCArKysrDQo+
ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2IvaWdiX3B0cC5jICAgICAgICAgICAgfCA0
ICsrKysNCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvY2xv
Y2suYyB8IDQgKysrKw0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9jaGlwL2xhbjc0M3hf
cHRwLmMgICAgICAgIHwgNCArKysrDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jh
dmJfcHRwLmMgICAgICAgICAgICAgfCA0ICsrKysNCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3N0
bWljcm8vc3RtbWFjL3N0bW1hY19wdHAuYyAgICB8IDQgKysrKw0KPiAgZHJpdmVycy9uZXQvcGh5
L2RwODM2NDAuYyAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgMyArKysNCj4gIDcgZmlsZXMg
Y2hhbmdlZCwgMjcgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2Jyb2FkY29tL3RnMy5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRj
b20vdGczLmMNCj4gaW5kZXggNzdmMzUxMWI5N2RlLi5jYTNhYTEyNTBkZDEgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL3RnMy5jDQo+ICsrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2Jyb2FkY29tL3RnMy5jDQo+IEBAIC02MjgwLDYgKzYyODAsMTAgQEAgc3Rh
dGljIGludCB0ZzNfcHRwX2VuYWJsZShzdHJ1Y3QNCj4gcHRwX2Nsb2NrX2luZm8gKnB0cCwNCj4g
IA0KPiAgCXN3aXRjaCAocnEtPnR5cGUpIHsNCj4gIAljYXNlIFBUUF9DTEtfUkVRX1BFUk9VVDoN
Cj4gKwkJLyogUmVqZWN0IHJlcXVlc3RzIHdpdGggdW5zdXBwb3J0ZWQgZmxhZ3MgKi8NCj4gKwkJ
aWYgKHJxLT5wZXJvdXQuZmxhZ3MpDQo+ICsJCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+ICsNCj4g
IAkJaWYgKHJxLT5wZXJvdXQuaW5kZXggIT0gMCkNCj4gIAkJCXJldHVybiAtRUlOVkFMOw0KPiAg
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2IvaWdiX3B0cC5j
DQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdiL2lnYl9wdHAuYw0KPiBpbmRleCBm
ZDMwNzFmNTViZDMuLjQ5OTc5NjMxNDlmNiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvaW50ZWwvaWdiL2lnYl9wdHAuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9p
bnRlbC9pZ2IvaWdiX3B0cC5jDQo+IEBAIC01NTEsNiArNTUxLDEwIEBAIHN0YXRpYyBpbnQgaWdi
X3B0cF9mZWF0dXJlX2VuYWJsZV9pMjEwKHN0cnVjdA0KPiBwdHBfY2xvY2tfaW5mbyAqcHRwLA0K
PiAgCQlyZXR1cm4gMDsNCj4gIA0KPiAgCWNhc2UgUFRQX0NMS19SRVFfUEVST1VUOg0KPiArCQkv
KiBSZWplY3QgcmVxdWVzdHMgd2l0aCB1bnN1cHBvcnRlZCBmbGFncyAqLw0KPiArCQlpZiAocnEt
PnBlcm91dC5mbGFncykNCj4gKwkJCXJldHVybiAtRU9QTk9UU1VQUDsNCj4gKw0KPiAgCQlpZiAo
b24pIHsNCj4gIAkJCXBpbiA9IHB0cF9maW5kX3BpbihpZ2ItPnB0cF9jbG9jaywNCj4gUFRQX1BG
X1BFUk9VVCwNCj4gIAkJCQkJICAgcnEtPnBlcm91dC5pbmRleCk7DQo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2Nsb2NrLmMNCj4gYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2Nsb2NrLmMNCj4gaW5k
ZXggMDA1OWIyOTBlMDk1Li5jZmY2YjYwZGUzMDQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvY2xvY2suYw0KPiArKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2Nsb2NrLmMNCj4gQEAgLTI5MCw2
ICsyOTAsMTAgQEAgc3RhdGljIGludCBtbHg1X3Blcm91dF9jb25maWd1cmUoc3RydWN0DQo+IHB0
cF9jbG9ja19pbmZvICpwdHAsDQo+ICAJaWYgKCFNTFg1X1BQU19DQVAobWRldikpDQo+ICAJCXJl
dHVybiAtRU9QTk9UU1VQUDsNCj4gIA0KPiArCS8qIFJlamVjdCByZXF1ZXN0cyB3aXRoIHVuc3Vw
cG9ydGVkIGZsYWdzICovDQo+ICsJaWYgKHJxLT5wZXJvdXQuZmxhZ3MpDQo+ICsJCXJldHVybiAt
RU9QTk9UU1VQUDsNCj4gKw0KPiAgCWlmIChycS0+cGVyb3V0LmluZGV4ID49IGNsb2NrLT5wdHBf
aW5mby5uX3BpbnMpDQo+ICAJCXJldHVybiAtRUlOVkFMOw0KPiAgDQo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9taWNyb2NoaXAvbGFuNzQzeF9wdHAuYw0KPiBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21pY3JvY2hpcC9sYW43NDN4X3B0cC5jDQo+IGluZGV4IDU3YjI2YzJhY2Y4
Ny4uZThmZTlhOTBmZTRmIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9taWNy
b2NoaXAvbGFuNzQzeF9wdHAuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9taWNyb2No
aXAvbGFuNzQzeF9wdHAuYw0KPiBAQCAtNDI5LDYgKzQyOSwxMCBAQCBzdGF0aWMgaW50IGxhbjc0
M3hfcHRwX3Blcm91dChzdHJ1Y3QNCj4gbGFuNzQzeF9hZGFwdGVyICphZGFwdGVyLCBpbnQgb24s
DQo+ICAJaW50IHB1bHNlX3dpZHRoID0gMDsNCj4gIAlpbnQgcGVyb3V0X2JpdCA9IDA7DQo+ICAN
Cj4gKwkvKiBSZWplY3QgcmVxdWVzdHMgd2l0aCB1bnN1cHBvcnRlZCBmbGFncyAqLw0KPiArCWlm
IChwZXJvdXQtPmZsYWdzKQ0KPiArCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+ICsNCj4gIAlpZiAo
IW9uKSB7DQo+ICAJCWxhbjc0M3hfcHRwX3Blcm91dF9vZmYoYWRhcHRlcik7DQo+ICAJCXJldHVy
biAwOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX3B0
cC5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX3B0cC5jDQo+IGluZGV4
IDlhNDI1ODA2OTNjYi4uNjM4ZjFmYzIxNjZmIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9yZW5lc2FzL3JhdmJfcHRwLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVuZXNhcy9yYXZiX3B0cC5jDQo+IEBAIC0yMTEsNiArMjExLDEwIEBAIHN0YXRpYyBpbnQgcmF2
Yl9wdHBfcGVyb3V0KHN0cnVjdCBwdHBfY2xvY2tfaW5mbw0KPiAqcHRwLA0KPiAgCXVuc2lnbmVk
IGxvbmcgZmxhZ3M7DQo+ICAJaW50IGVycm9yID0gMDsNCj4gIA0KPiArCS8qIFJlamVjdCByZXF1
ZXN0cyB3aXRoIHVuc3VwcG9ydGVkIGZsYWdzICovDQo+ICsJaWYgKHJlcS0+ZmxhZ3MpDQo+ICsJ
CXJldHVybiAtRU9QTk9UU1VQUDsNCj4gKw0KPiAgCWlmIChyZXEtPmluZGV4KQ0KPiAgCQlyZXR1
cm4gLUVJTlZBTDsNCj4gIA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3Rt
aWNyby9zdG1tYWMvc3RtbWFjX3B0cC5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNy
by9zdG1tYWMvc3RtbWFjX3B0cC5jDQo+IGluZGV4IGRmNjM4YjE4YjcyYy4uMDk4OWUyYmI2ZWUz
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1t
YWNfcHRwLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3Rt
bWFjX3B0cC5jDQo+IEBAIC0xNDAsNiArMTQwLDEwIEBAIHN0YXRpYyBpbnQgc3RtbWFjX2VuYWJs
ZShzdHJ1Y3QgcHRwX2Nsb2NrX2luZm8NCj4gKnB0cCwNCj4gIA0KPiAgCXN3aXRjaCAocnEtPnR5
cGUpIHsNCj4gIAljYXNlIFBUUF9DTEtfUkVRX1BFUk9VVDoNCj4gKwkJLyogUmVqZWN0IHJlcXVl
c3RzIHdpdGggdW5zdXBwb3J0ZWQgZmxhZ3MgKi8NCj4gKwkJaWYgKHJxLT5wZXJvdXQuZmxhZ3Mp
DQo+ICsJCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+ICsNCj4gIAkJY2ZnID0gJnByaXYtPnBwc1ty
cS0+cGVyb3V0LmluZGV4XTsNCj4gIA0KPiAgCQljZmctPnN0YXJ0LnR2X3NlYyA9IHJxLT5wZXJv
dXQuc3RhcnQuc2VjOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcGh5L2RwODM2NDAuYyBi
L2RyaXZlcnMvbmV0L3BoeS9kcDgzNjQwLmMNCj4gaW5kZXggNjU4MDA5NDE2MWE5Li4wNGFkNzc3
NTg5MjAgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9kcDgzNjQwLmMNCj4gKysrIGIv
ZHJpdmVycy9uZXQvcGh5L2RwODM2NDAuYw0KPiBAQCAtNDkxLDYgKzQ5MSw5IEBAIHN0YXRpYyBp
bnQgcHRwX2RwODM2NDBfZW5hYmxlKHN0cnVjdA0KPiBwdHBfY2xvY2tfaW5mbyAqcHRwLA0KPiAg
CQlyZXR1cm4gMDsNCj4gIA0KPiAgCWNhc2UgUFRQX0NMS19SRVFfUEVST1VUOg0KPiArCQkvKiBS
ZWplY3QgcmVxdWVzdHMgd2l0aCB1bnN1cHBvcnRlZCBmbGFncyAqLw0KPiArCQlpZiAocnEtPnBl
cm91dC5mbGFncykNCj4gKwkJCXJldHVybiAtRU9QTk9UU1VQUDsNCj4gIAkJaWYgKHJxLT5wZXJv
dXQuaW5kZXggPj0gTl9QRVJfT1VUKQ0KPiAgCQkJcmV0dXJuIC1FSU5WQUw7DQo+ICAJCXJldHVy
biBwZXJpb2RpY19vdXRwdXQoY2xvY2ssIHJxLCBvbiwgcnEtDQo+ID5wZXJvdXQuaW5kZXgpOw0K
