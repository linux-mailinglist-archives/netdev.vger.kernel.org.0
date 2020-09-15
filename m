Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B54E26A3B2
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 12:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgIOKzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 06:55:14 -0400
Received: from mail-eopbgr80111.outbound.protection.outlook.com ([40.107.8.111]:56738
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726291AbgIOKyl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 06:54:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkzFMiak8tzZSSTlEnYST1c9AFzBQVvVnWFNX6WqKzqN32ouRwYAsq1Ah7klnq+/0YXbbFaZi1fdYmL1as5zATCzU4HkF1tbjUVTQQogC0OZHuxtp24DqnfAS8M7JxZxjmYbzfH8wzYRUeTBJfy1GXt/+KYOSUbAdQ+hITDCNuYCQrsWc/KBnJk5/2djuZn3jWKVf17xsSqtrlDG1gxIg39X7iv1ih9SZ41OQuwtAn/r/0Ki3YNdoq4ZmTjMExEyay9kKJ2BIe86vgJ3Z0FuTxB8+QdX1+qapvudYH/+qCh4Q5hnE+umvNUDOqtXSs5Iw3Qk5r5NNn/GBIRVz8vh0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZMHcPMKJaEpPGaTC0B5+Hh5H9l6Pcz5GSflZC9wb4Q=;
 b=j/oykAZ2mBqS+g6vTEwNbJ0CufBvPJPXdNml0gasBwe7BWg8AYnffR1K1n39+AfNl9mPXRp+buYnF1EHNAGleSCdri9d/68TsBPOPOJKCLelLamnWEk12e4lQlw8w2hv2zH9GvaUth6CS4SEZY3RExPZjvmI4mLX9IkeNz+chiPxwt22tTynz1NC51lBpjKihshd6+MABwNy/NlCuOOesbdrgkHNY40ZYJhq8b/xdvMfQdYgDV+ibEnCDMlYocBzmlkkPZXLm4bWKrGVpMAvJBpyXcms3pXPG1k7JGdL9icmFka/Lo6HO2zLciqjDQNe3uKMPS0qYqK2VrXj+Sfb8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZMHcPMKJaEpPGaTC0B5+Hh5H9l6Pcz5GSflZC9wb4Q=;
 b=BLqMwp+CmlN575wv3mpuKZkPibsitDwEeiHUbXfkxHekc94w8DsXi8j0O+EiuammE0rVKHg8ibFiZM5GktwtC4PkAZICQxyGONgEe08KNoMb6RayiZDD5En/p8TadSNhx6JrOrd/+sIMWt2vEiVx6xT9vXBHpaMec6lhFNLySEc=
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com (2603:10a6:20b:1db::9)
 by AM0PR05MB6643.eurprd05.prod.outlook.com (2603:10a6:20b:156::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 10:54:36 +0000
Received: from AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902]) by AM8PR05MB7332.eurprd05.prod.outlook.com
 ([fe80::64de:d33d:e82:b902%7]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 10:54:36 +0000
From:   Tuong Tong Lien <tuong.t.lien@dektech.com.au>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "maloy@donjonn.com" <maloy@donjonn.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>
Subject: RE: [net] tipc: fix using smp_processor_id() in preemptible
Thread-Topic: [net] tipc: fix using smp_processor_id() in preemptible
Thread-Index: AQHWfoc+himFBG6tQEGws4qIktdqQalR4IkAgAACUeCAABe0AIAAAmDQgAAv7QCAAYkt0IAAEM4AgAA+DjCAAO5sgIAUqugw
Date:   Tue, 15 Sep 2020 10:54:35 +0000
Message-ID: <AM8PR05MB73321BFCEC3FF0CECC2DE390E2200@AM8PR05MB7332.eurprd05.prod.outlook.com>
References: <20200829193755.9429-1-tuong.t.lien@dektech.com.au>
 <f81eafce-e1d1-bb18-cb70-cfdf45bb2ed0@gmail.com>
 <AM8PR05MB733222C45D3F0CC19E909BB0E2510@AM8PR05MB7332.eurprd05.prod.outlook.com>
 <0ed21ba7-2b3b-9d4f-563e-10d329ebeecb@gmail.com>
 <AM8PR05MB7332E91A67120D78823353F6E2510@AM8PR05MB7332.eurprd05.prod.outlook.com>
 <3f858962-4e38-0b72-4341-1304ec03cd7a@gmail.com>
 <AM8PR05MB7332BE4B6E0381D2894E057AE22E0@AM8PR05MB7332.eurprd05.prod.outlook.com>
 <338d5df9-fe4e-7acf-1480-99984dfeab34@gmail.com>
 <AM8PR05MB7332020CE2FB9E0B416D70BAE22E0@AM8PR05MB7332.eurprd05.prod.outlook.com>
 <2b31e772-3229-3c67-1faf-9ae88849ce77@gmail.com>
In-Reply-To: <2b31e772-3229-3c67-1faf-9ae88849ce77@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=dektech.com.au;
x-originating-ip: [123.20.195.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e99b69b-64e3-4cfd-f90a-08d85965bc66
x-ms-traffictypediagnostic: AM0PR05MB6643:
x-microsoft-antispam-prvs: <AM0PR05MB6643BB9CD57FA7FA2C605021E2200@AM0PR05MB6643.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eOB5A/vMNJuV5sW3jfQzLyVJP9X0wcgxrXFtjQZLyKVWgTaCf7eaZrPeZI+NNdIqNBUvB3gHqhCcycLmdEXrhowwVhpv2R7s0/LSo0hQoIMVKOZ9U5EeVM2cL12pZTo0VFwHWyM8eDu/vm/ddphi9n0RKl+4erLMP6nKd13CMmrzUeBFYdkx+66JnIQgilohx0O+7hN8kR+MZLhJ8g9wJwLf3tW1zh1H4ShTBGbO2e8l1Wez3sLHRuCw+QloWAfloan8wp8jPL/hZaLiTGO/yRDY+TtHp4SEWhYYSvyqxa2aYxBAeURRTApjvwcQDOPzFge9OnkJAi3eX9dUYmjtOESDbSZnQ21QMKHavSWlKGS5ki7yIlTwR89zVwT8TR1R
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7332.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(39850400004)(346002)(136003)(55236004)(6506007)(478600001)(86362001)(316002)(8936002)(53546011)(4326008)(76116006)(66556008)(110136005)(64756008)(66446008)(66476007)(83380400001)(66946007)(186003)(26005)(71200400001)(8676002)(2906002)(33656002)(52536014)(9686003)(7696005)(5660300002)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Xd1O4G5lUDUxwv6MKjn3DcfhvghaYEMoKpl1pCYQJs1wrIgL7BvYJ40a9dNGDqn+CkkF4C9jxKJvGmfqkOIooEfNm9Gvk6MFl277TUjVdzgxLAJNi2UAPBk7/ZMskaDQ8lKNctgFM/P/vgPuCxHgvF+Sh2m57W7Y5qyAgy6t9xe1IAC/uIjmC4lPfgJNCjgUMc8k4n4LeQST01ibsFjLoU4x0H2COvlFpWTDpaV1vsTyi4huaBBT0d+YgXV4dt8BFKboCBXwXxyXMWngMdIad5pXXcTMxBJDupbHSZOcdSaF0ftDtxNxpTQAcjnXR3OyY+Z91VcXb87xTgRdY4a3QGyp8p6H4/EQX+PuG5+v5d+6AUbTzYuZjxmOafIlXGfzwZEPlBKQjY+LDUvUqjeeCzqYllC8GrNk2F0L1G3p9s8FAJ5LR8gN6NrVLLK66uOfTdb4KLPVp3tzUgaXau27BjbKKA2lbcGCmn7Mkq5m3462G2MUFkFCvApuBneDQ8/zbXWedKNRQLcdkxi/TcUuDYdZUM2vWi01c7sdJtAyVcfS4dSOKDGHTklU/kZoCGeclS5cfPabsYQAcWG77l8o/eVB71tAnhQK8rPGL2cw2JjPBycf5d4MS5snNax0+dorIn6NX0wghqoRKponM2xNxQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7332.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e99b69b-64e3-4cfd-f90a-08d85965bc66
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2020 10:54:35.9443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zYpZOG5snasQDlMCLpz2ajfss5owA+7Kwz5ZLwrUQ22YOtfFZjnseRoRQZLs1YrKUpWtKkI+zyb9LcxDOFrIWMQDSa+FJI67jVzeDJxmwgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6643
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJpYyBEdW1hemV0IDxl
cmljLmR1bWF6ZXRAZ21haWwuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIFNlcHRlbWJlciAyLCAy
MDIwIDI6MTEgUE0NCj4gVG86IFR1b25nIFRvbmcgTGllbiA8dHVvbmcudC5saWVuQGRla3RlY2gu
Y29tLmF1PjsgRXJpYyBEdW1hemV0IDxlcmljLmR1bWF6ZXRAZ21haWwuY29tPjsgZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldDsNCj4gam1hbG95QHJlZGhhdC5jb207IG1hbG95QGRvbmpvbm4uY29tOyB5aW5n
Lnh1ZUB3aW5kcml2ZXIuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiB0aXBjLWRp
c2N1c3Npb25AbGlzdHMuc291cmNlZm9yZ2UubmV0DQo+IFN1YmplY3Q6IFJlOiBbbmV0XSB0aXBj
OiBmaXggdXNpbmcgc21wX3Byb2Nlc3Nvcl9pZCgpIGluIHByZWVtcHRpYmxlDQo+IA0KPiANCj4g
DQo+IE9uIDkvMS8yMCAxMDo1MiBBTSwgVHVvbmcgVG9uZyBMaWVuIHdyb3RlOg0KPiANCj4gPiBP
aywgSSd2ZSBnb3QgeW91ciBjb25jZXJuIG5vdy4gQWN0dWFsbHkgd2hlbiB3cml0aW5nIHRoaXMg
Y29kZSwgSSBoYWQgdGhlIHNhbWUgdGhvdWdodCBhcyB5b3UsIGJ1dCBkZWNpZGVkIHRvIHJlbGF4
IGl0IGJlY2F1c2Ugb2YgdGhlDQo+IGZvbGxvd2luZyByZWFzb25zOg0KPiA+IDEuIEkgZG9uJ3Qg
d2FudCB0byB1c2UgYW55IGxvY2tpbmcgbWV0aG9kcyBoZXJlIHRoYXQgY2FuIGxlYWQgdG8gY29t
cGV0aXRpb24gKHRodXMgYWZmZWN0IG92ZXJhbGwgcGVyZm9ybWFuY2UuLi4pOw0KPiA+IDIuIFRo
ZSBsaXN0IGlzIG5vdCBhbiB1c3VhbCBsaXN0IGJ1dCBhIGZpeGVkICJyaW5nIiBvZiBwZXJzaXN0
ZW50IGVsZW1lbnRzIChubyBvbmUgd2lsbCBpbnNlcnQvcmVtb3ZlIGFueSBlbGVtZW50IGFmdGVy
IGl0IGlzIGNyZWF0ZWQpOw0KPiA+IDMuIEl0IGRvZXMgX25vdF8gbWF0dGVyIGF0IGFsbCBpZiB0
aGUgZnVuY3Rpb24gY2FsbHMgd2lsbCByZXN1bHQgaW4gdGhlIHNhbWUgZWxlbWVudCwgb3Igb25l
IGNhbGwgcG9pbnRzIHRvIHRoZSAxc3QgZWxlbWVudCB3aGlsZSBhbm90aGVyDQo+IGF0IHRoZSBz
YW1lIHRpbWUgcG9pbnRzIHRvIHRoZSAzcmQgb25lLCBldGMuIGFzIGxvbmcgYXMgaXQgcmV0dXJu
cyBhbiBlbGVtZW50IGluIHRoZSBsaXN0LiBBbHNvLCB0aGUgcGVyLWNwdSBwb2ludGVyIGlzIF9u
b3RfIHJlcXVpcmVkIHRvDQo+IGV4YWN0bHkgcG9pbnQgdG8gdGhlIG5leHQgZWxlbWVudCwgYnV0
IG5lZWRzIHRvIGJlIG1vdmVkIG9uIHRoaXMgb3IgbmV4dCB0aW1lLi4uLCBzbyBqdXN0IHJlbGF4
aW5nIQ0KPiA+IDQuIElzbid0IGEgIndyaXRlIiB0byB0aGUgcGVyLWNwdSB2YXJpYWJsZSBhdG9t
aWM/DQo+ID4NCj4gDQo+IEkgdGhpbmsgSSB3aWxsIGdpdmUgdXAsIHRoaXMgY29kZSBpcyBjbGVh
cmx5IHJhY3ksIGFuZCB3aWxsIGNvbnNpZGVyIFRJUEMgYXMgYnJva2VuLg0KPiANCj4gWW91ciBw
YXRjaCBvbmx5IHNpbGVuY2VkIHN5emJvdCByZXBvcnQsIGJ1dCB0aGUgYnVnIGlzIHN0aWxsIHRo
ZXJlLg0KSGkgRXJpYywNClNvcnJ5IGJ1dCBjb3VsZCB5b3UgcGxlYXNlIHRlbGwgbWUgd2h5IHlv
dSB0aGluayBpdCBpcyAicmFjeSIuLi4gYW5kIHRoZSBidWcgaXMgc3RpbGwgdGhlcmUuLi4/IFRo
YW5rcyENCkkgYWdyZWVkIHdlIGNvdWxkIG1ha2UgaXQgaW4gc29tZSBicmlnaHRlciB3YXlzLCBi
dXQgZm9yIG5vdyBieSBkaXNhYmxpbmcgcHJlZW1wdGlvbiBwcmlvciB0byB0aGUgcGVyLWNwdSB2
YXJpYWJsZSBhY2Nlc3MgaXMgZmluZSBlbm91Z2g/IEFsc28gbGV0cyBzYXkgZXZlbiBpbiBjYXNl
IHRoZSBjb2RlIGlzIGludGVycnVwdGVkIGJ5IEJIIG9yIGludGVycnVwdHMuLi4sIHdlIHNob3Vs
ZCBoYXZlIG5vIGlzc3VlLg0KDQpCUi9UdW9uZw0KPiANCg0K
