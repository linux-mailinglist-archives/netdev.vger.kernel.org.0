Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFB01075A3
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 17:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfKVQTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 11:19:43 -0500
Received: from mail-eopbgr130047.outbound.protection.outlook.com ([40.107.13.47]:39301
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726836AbfKVQTm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 11:19:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tdaj4aybRHbsQBmFy5TBLPN+O23MyZRqbASIbnsJg/qwq3y4KSWdjosEt0XaVVTNM0wgWyzKyDCuSo6/tVcIdTzzrYVfiJgCM16xB6jDhujhUmoJ3uA6G8QatCbfaKtFecPwRmb0c5gsFPTBG1t+j+p788LHoZBoRTUAQCAEg0LfPYB3oExrASSUsoPLt3Ljsz7nCj5EtuIPWOU+GelCL5JLjDYdAzhUCo0h7I4kPRu5m+9yfSHmi674+cRP6z+F0Muaq6y7ARLp+05Gn8hbmuzVGx1qPfhgv74YPXLhvN8MwC+xRYskZTmXD+/otET7FgHnkXG9W8nOYBNGEb7XQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXMFUNkwU+hc4yCgoIF+gMxp8bIghWPv9U40lXPHFGg=;
 b=BE+WYurEoUseUPAZo0YH2UFVRcMmeoA/1+k0qh35CdPeSUsekvKf0+25I4i+SiJO0/uzWcvl/S9Cf4dQSLHcZjXLIYY/1/uRFWAg3ZX7d6bESZvmRz2TySSdShOkU6YXTu8kb/AuGld1+SrKGkCP4k8O+2VH0dEuna7Gm+PHb7l5REWJRxHwTCuCihMovYvOyO2mbBZBP3lDLkVLopLS1RQriX13RqvVq8y3R3GoK6bf6iXf/LvG6Zm+zmuDYcMX8LWtKx7vcg0INDWGNcfLk1AtPY1GTW0pwOsChgNlYnnFYzXR40T2BX3stXzP9ZVFIqtc6lurrQ2o7WYCSyBPaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXMFUNkwU+hc4yCgoIF+gMxp8bIghWPv9U40lXPHFGg=;
 b=p1ger8rTfTh5s7i/rE4XheYyekFDO4WWeQChdQZlj8S0rtVcc7knkxAnWgnbmFmcYx5rc1mva6YuDNbQyza5UpRFkVcLu3TCIhOzjkOmzfODBxYCdi4lcD3Y1mkJJ71yKKhtvDeegd++EenYhPRc+6sgFqjqFjSMyVGF4H7TIyA=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4689.eurprd05.prod.outlook.com (52.133.55.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 16:19:37 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2451.032; Fri, 22 Nov 2019
 16:19:37 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>,
        Martin Habets <mhabets@solarflare.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Kiran Patil <kiran.patil@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVnATItanP+SK9PEuJkGaYy2/dTKeM1NrAgAURC4CAA92vAIABLrcAgABwUWA=
Date:   Fri, 22 Nov 2019 16:19:37 +0000
Message-ID: <AM0PR05MB48660C6FDCC2397045A03139D1490@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
 <30b968cf-0e11-a2c6-5b9f-5518df11dfb7@solarflare.com>
 <22dd6ae3-03f4-1432-2935-8df5e9a449de@redhat.com>
In-Reply-To: <22dd6ae3-03f4-1432-2935-8df5e9a449de@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c75672ae-eb6d-4b49-2c31-08d76f67c526
x-ms-traffictypediagnostic: AM0PR05MB4689:
x-microsoft-antispam-prvs: <AM0PR05MB4689837FA2BEFBFF031BB85AD1490@AM0PR05MB4689.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(189003)(199004)(2501003)(102836004)(71190400001)(6436002)(71200400001)(33656002)(256004)(86362001)(81156014)(81166006)(8676002)(478600001)(54906003)(2906002)(76176011)(25786009)(3846002)(14454004)(66556008)(66446008)(76116006)(186003)(66476007)(7736002)(305945005)(6116002)(2201001)(4326008)(6246003)(229853002)(74316002)(110136005)(52536014)(8936002)(7416002)(6506007)(446003)(53546011)(66066001)(316002)(7696005)(55016002)(26005)(9686003)(11346002)(99286004)(5660300002)(66946007)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4689;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mfqOkTiK6cGDwhqjUa53T4lhx5pXcBXkkOezeLVb7aRcFprtXwi3hE01ocR2a7hx/IyvDyz2wf5griX8Q84o+k+RiMSwTnLd/bHM8bFlaqO1PU69eInqbFTL0kIaTJaGCQ7G8i5zSAY71SG4WgLZEuJmHEg4Ytn2C1m2HZCcYOWxN28sYF1NtEQqshdDCzT+lEIG3yDuBVJrSjl74oEoiagR4RqBLPiYK5QfBvm71EGe2zHMbgutzg0ATjknPgfhjBrjYsgEzTyOerE7EssuJz7N/igJ4nTNGmnL9B5lfTaAipDg5ZqziPh4WO3VwbSa56NNxL4p+ezbUeQB9oUzeSCB/9yrDLlLA9lp0/Y63hct3c+dPEsnPbquF5K+whcqikxyeqkZUVDp7JW0+JraWFNIr3Ij96bG/Qwa7embwI46RKHBVlQvX1mVanfmxddX
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c75672ae-eb6d-4b49-2c31-08d76f67c526
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 16:19:37.4773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V+6JE0x6+VIDRRE/VFAeSyn968R8iLYauOjRPAk5ngm0KnFqdyQ2y855tFOcWUoqJD6T8eQWkJV1b7UKxYZq2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4689
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4NCj4gU2VudDogRnJp
ZGF5LCBOb3ZlbWJlciAyMiwgMjAxOSAzOjE0IEFNDQo+IA0KPiBPbiAyMDE5LzExLzIxIOS4i+WN
iDExOjEwLCBNYXJ0aW4gSGFiZXRzIHdyb3RlOg0KPiA+IE9uIDE5LzExLzIwMTkgMDQ6MDgsIEph
c29uIFdhbmcgd3JvdGU6DQo+ID4+IE9uIDIwMTkvMTEvMTYg5LiK5Y2INzoyNSwgUGFyYXYgUGFu
ZGl0IHdyb3RlOg0KPiA+Pj4gSGkgSmVmZiwNCj4gPj4+DQo+ID4+Pj4gRnJvbTogSmVmZiBLaXJz
aGVyIDxqZWZmcmV5LnQua2lyc2hlckBpbnRlbC5jb20+DQo+ID4+Pj4gU2VudDogRnJpZGF5LCBO
b3ZlbWJlciAxNSwgMjAxOSA0OjM0IFBNDQo+ID4+Pj4NCj4gPj4+PiBGcm9tOiBEYXZlIEVydG1h
biA8ZGF2aWQubS5lcnRtYW5AaW50ZWwuY29tPg0KPiA+Pj4+DQo+ID4+Pj4gVGhpcyBpcyB0aGUg
aW5pdGlhbCBpbXBsZW1lbnRhdGlvbiBvZiB0aGUgVmlydHVhbCBCdXMsDQo+ID4+Pj4gdmlydGJ1
c19kZXZpY2UgYW5kIHZpcnRidXNfZHJpdmVyLsKgIFRoZSB2aXJ0dWFsIGJ1cyBpcyBhIHNvZnR3
YXJlDQo+ID4+Pj4gYmFzZWQgYnVzIGludGVuZGVkIHRvIHN1cHBvcnQgbGlnaHR3ZWlnaHQgZGV2
aWNlcyBhbmQgZHJpdmVycyBhbmQNCj4gPj4+PiBwcm92aWRlIG1hdGNoaW5nIGJldHdlZW4gdGhl
bSBhbmQgcHJvYmluZyBvZiB0aGUgcmVnaXN0ZXJlZCBkcml2ZXJzLg0KPiA+Pj4+DQo+ID4+Pj4g
VGhlIHByaW1hcnkgcHVycG9zZSBvZiB0aGUgdmlydWFsIGJ1cyBpcyB0byBwcm92aWRlIG1hdGNo
aW5nDQo+ID4+Pj4gc2VydmljZXMgYW5kIHRvIHBhc3MgdGhlIGRhdGEgcG9pbnRlciBjb250YWlu
ZWQgaW4gdGhlDQo+ID4+Pj4gdmlydGJ1c19kZXZpY2UgdG8gdGhlIHZpcnRidXNfZHJpdmVyIGR1
cmluZyBpdHMgcHJvYmUgY2FsbC7CoCBUaGlzDQo+ID4+Pj4gd2lsbCBhbGxvdyB0d28gc2VwYXJh
dGUga2VybmVsIG9iamVjdHMgdG8gbWF0Y2ggdXAgYW5kIHN0YXJ0DQo+IGNvbW11bmljYXRpb24u
DQo+ID4+Pj4NCj4gPj4+IEl0IGlzIGZ1bmRhbWVudGFsIHRvIGtub3cgdGhhdCByZG1hIGRldmlj
ZSBjcmVhdGVkIGJ5IHZpcnRidXNfZHJpdmVyIHdpbGwNCj4gYmUgYW5jaG9yZWQgdG8gd2hpY2gg
YnVzIGZvciBhbiBub24gYWJ1c2l2ZSB1c2UuDQo+ID4+PiB2aXJ0YnVzIG9yIHBhcmVudCBwY2kg
YnVzPw0KPiA+Pj4gSSBhc2tlZCB0aGlzIHF1ZXN0aW9uIGluIHYxIHZlcnNpb24gb2YgdGhpcyBw
YXRjaC4NCj4gPj4+DQo+ID4+PiBBbHNvIHNpbmNlIGl0IHNheXMgLSAndG8gc3VwcG9ydCBsaWdo
dHdlaWdodCBkZXZpY2VzJywgZG9jdW1lbnRpbmcgdGhhdA0KPiBpbmZvcm1hdGlvbiBpcyBjcml0
aWNhbCB0byBhdm9pZCBhbWJpZ3VpdHkuDQo+ID4+Pg0KPiA+Pj4gU2luY2UgZm9yIGEgd2hpbGUg
SSBhbSB3b3JraW5nIG9uIHRoZSBzdWJidXMvc3ViZGV2X2J1cy94YnVzL21kZXYgWzFdDQo+IHdo
YXRldmVyIHdlIHdhbnQgdG8gY2FsbCBpdCwgaXQgb3ZlcmxhcHMgd2l0aCB5b3VyIGNvbW1lbnQg
YWJvdXQgJ3RvIHN1cHBvcnQNCj4gbGlnaHR3ZWlnaHQgZGV2aWNlcycuDQo+ID4+PiBIZW5jZSBs
ZXQncyBtYWtlIHRoaW5ncyBjcnlzdGFsIGNsZWFyIHdlYXRoZXIgdGhlIHB1cnBvc2UgaXMgJ29u
bHkNCj4gbWF0Y2hpbmcgc2VydmljZScgb3IgYWxzbyAnbGlnaHR3ZWlnaHQgZGV2aWNlcycuDQo+
ID4+PiBJZiB0aGlzIGlzIG9ubHkgbWF0Y2hpbmcgc2VydmljZSwgbGV0cyBwbGVhc2UgcmVtb3Zl
IGxpZ2h0d2VpZ2h0IGRldmljZXMNCj4gcGFydC4uDQo+ID4+DQo+ID4+IFllcywgaWYgaXQncyBt
YXRjaGluZyArIGxpZ2h0d2VpZ2h0IGRldmljZSwgaXRzIGZ1bmN0aW9uIGlzIGFsbW9zdCBhIGR1
cGxpY2F0aW9uDQo+IG9mIG1kZXYuIEFuZCBJJ20gd29ya2luZyBvbiBleHRlbmRpbmcgbWRldlsx
XSB0byBiZSBhIGdlbmVyaWMgbW9kdWxlIHRvDQo+IHN1cHBvcnQgYW55IHR5cGVzIG9mIHZpcnR1
YWwgZGV2aWNlcyBhIHdoaWxlLiBUaGUgYWR2YW50YWdlIG9mIG1kZXYgaXM6DQo+ID4+DQo+ID4+
IDEpIHJlYWR5IGZvciB0aGUgdXNlcnNwYWNlIGRyaXZlciAoVkZJTyBiYXNlZCkNCj4gPj4gMikg
aGF2ZSBhIHN5c2ZzL0dVSUQgYmFzZWQgbWFuYWdlbWVudCBpbnRlcmZhY2UNCj4gPiBJbiBteSB2
aWV3IHRoaXMgdmlydHVhbC1idXMgaXMgbW9yZSBnZW5lcmljIGFuZCBtb3JlIGZsZXhpYmxlIHRo
YW4gbWRldi4NCj4gDQo+IA0KPiBFdmVuIGFmdGVyIHRoZSBzZXJpZXMgWzFdIGhlcmU/DQo+IA0K
PiANCj4gPiBXaGF0IGZvciB5b3UgYXJlIHRoZSBhZHZhbnRhZ2VzIG9mIG1kZXYgdG8gbWUgYXJl
IHNvbWUgb2YgaXQncw0KPiBkaXNhZHZhbnRhZ2VzLg0KPiA+DQo+ID4gVGhlIHdheSBJIHNlZSBp
dCB3ZSBjYW4gcHJvdmlkZSByZG1hIHN1cHBvcnQgaW4gdGhlIGRyaXZlciB1c2luZyB2aXJ0dWFs
LWJ1cy4NCj4gDQpUaGlzIGlzIGZpbmUsIGJlY2F1c2UgaXQgaXMgb25seSB1c2VkIGZvciBtYXRj
aGluZyBzZXJ2aWNlLg0KDQo+IA0KPiBZZXMsIGJ1dCBzaW5jZSBpdCBkb2VzIG1hdGNoaW5nIG9u
bHksIHlvdSBjYW4gZG8gZXZlcnl0aGluZyB5b3Ugd2FudC4NCj4gQnV0IGl0IGxvb2tzIHRvIG1l
IEdyZWcgZG9lcyBub3Qgd2FudCBhIGJ1cyB0byBiZSBhbiBBUEkgbXVsdGlwbGV4ZXIuIFNvIGlm
IGENCj4gZGVkaWNhdGVkIGJ1cyBpcyBkZXNpcmVkLCBpdCB3b24ndCBiZSBtdWNoIG9mIGNvZGUg
dG8gaGF2ZSBhIGJ1cyBvbiB5b3VyIG93bi4NCj4gDQpSaWdodC4gdmlydGJ1cyBzaG91bGRuJ3Qg
YmUgYSBtdWx0aXBsZXhlci4NCk90aGVyd2lzZSBtZGV2IGNhbiBiZSBpbXByb3ZlZCAoYWJ1c2Vk
KSBleGFjdGx5IHRoZSB3YXkgdmlydGJ1cyBtaWdodC4gV2hlcmUgJ21kZXYgbSBzdGFuZHMgZm9y
IG11bHRpcGxleGVyIHRvbycuIDotKQ0KTm8sIHdlIHNob3VsZG7igJl0IGRvIHRoYXQuDQoNCkxp
c3RlbmluZyB0byBHcmVnIGFuZCBKYXNvbiBHLCBJIGFncmVlIHRoYXQgdmlydGJ1cyBzaG91bGRu
J3QgYmUgYSBtdWx0aXBsZXhlci4NClRoZXJlIGFyZSBmZXcgYmFzaWMgZGlmZmVyZW5jZXMgYmV0
d2VlbiBzdWJmdW5jdGlvbnMgYW5kIG1hdGNoaW5nIHNlcnZpY2UgZGV2aWNlIG9iamVjdC4NClN1
YmZ1bmN0aW9ucyBvdmVyIHBlcmlvZCBvZiB0aW1lIHdpbGwgaGF2ZSBzZXZlcmFsIGF0dHJpYnV0
ZXMsIGZldyB0aGF0IEkgdGhpbmsgb2YgcmlnaHQgYXdheSBhcmU6DQoxLiBCQVIgcmVzb3VyY2Ug
aW5mbywgd3JpdGUgY29tYmluZSBpbmZvDQoyLiBpcnEgdmVjdG9ycyBkZXRhaWxzDQozLiB1bmlx
dWUgaWQgYXNzaWduZWQgYnkgdXNlciAod2hpbGUgdmlydGJ1cyB3aWxsIG5vdCBhc3NpZ24gc3Vj
aCB1c2VyIGlkIGFzIHRoZXkgYXJlIGF1dG8gY3JlYXRlZCBmb3IgbWF0Y2hpbmcgc2VydmljZSBm
b3IgUEYvVkYpDQo0LiByZG1hIGRldmljZSBjcmVhdGVkIGJ5IG1hdGNoZWQgZHJpdmVyIHJlc2lk
ZXMgb24gcGNpIGJ1cyBvciBwYXJlbnQgZGV2aWNlDQpXaGlsZSByZG1hIGFuZCBuZXRkZXYgY3Jl
YXRlZCBvbiBvdmVyIHN1YmZ1bmN0aW9ucyBhcmUgbGlua2VkIHRvIHRoZWlyIG93biAnc3RydWN0
IGRldmljZScuDQoNCkR1ZSB0byB0aGF0IHN5c2ZzIHZpZXcgZm9yIHRoZXNlIHR3byBkaWZmZXJl
bnQgdHlwZXMgb2YgZGV2aWNlcyBpcyBiaXQgZGlmZmVyZW50Lg0KUHV0dGluZyBib3RoIG9uIHNh
bWUgYnVzIGp1c3QgZG9lc24ndCBhcHBlYXIgcmlnaHQgd2l0aCBhYm92ZSBmdW5kYW1lbnRhbCBk
aWZmZXJlbmNlcyBvZiBjb3JlIGxheWVyLg0KDQo+IA0KPiA+IEF0IHRoZSBtb21lbnQgd2Ugd291
bGQgbmVlZCBzZXBhcmF0ZSBtZGV2IHN1cHBvcnQgaW4gdGhlIGRyaXZlciBmb3INCj4gPiB2ZHBh
LCBidXQgSSBob3BlIGF0IHNvbWUgcG9pbnQgbWRldiB3b3VsZCBiZWNvbWUgYSBsYXllciBvbiB0
b3Agb2YgdmlydHVhbC0NCj4gYnVzLg0KDQpIb3cgaXMgaXQgb3B0aW1hbCB0byBjcmVhdGUgbXVs
dGlwbGUgJ3N0cnVjdCBkZXZpY2UnIGZvciBzaW5nbGUgcHVycG9zZT8NCkVzcGVjaWFsbHkgd2hl
biBvbmUgd2FudHMgdG8gY3JlYXRlIGh1bmRyZWRzIG9mIHN1Y2ggZGV2aWNlcyB0byBiZWdpbiB3
aXRoLg0KVXNlciBmYWNpbmcgdG9vbCBzaG91bGQgYmUgYWJsZSB0byBzZWxlY3QgZGV2aWNlIHR5
cGUgYW5kIHBsYWNlIHRoZSBkZXZpY2Ugb24gcmlnaHQgYnVzLg0K
