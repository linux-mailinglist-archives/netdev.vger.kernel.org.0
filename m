Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1E221427FD
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 11:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgATKPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 05:15:04 -0500
Received: from us-smtp-delivery-148.mimecast.com ([216.205.24.148]:56519 "EHLO
        us-smtp-delivery-148.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726125AbgATKPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 05:15:04 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jan 2020 05:15:02 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
        s=mimecast20161209; t=1579515302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wlos3rAsXN193iECbc8qqvhKryDR23iLKovG9vfozMM=;
        b=VgRxRJa36pUEhcnfGDi/e8mIpdu9K78SeN8VHm8fkMvWddmdjGA3xtTcwtGohTo6Don7o0
        xpjG+IGkHdq8QSDY+rf1GaX/IArm2jvK8fA3iUz3fV+qBGLPZziefJ1hN4VKOx0Ko8MJ/a
        29wVw0ImbcdfyWEySbB12Se6fHXvjRo=
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-Q_bXO3i3NRaxtuK7sdiJ5w-1; Mon, 20 Jan 2020 05:08:14 -0500
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com (52.132.97.155) by
 CY4PR0401MB3506.namprd04.prod.outlook.com (52.132.99.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Mon, 20 Jan 2020 10:08:12 +0000
Received: from CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::e579:27d9:6df1:f8bc]) by CY4PR0401MB3652.namprd04.prod.outlook.com
 ([fe80::e579:27d9:6df1:f8bc%6]) with mapi id 15.20.2644.024; Mon, 20 Jan 2020
 10:08:11 +0000
From:   "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Ayush Sawal <ayush.sawal@asicdesigners.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "manojmalviya@chelsio.com" <manojmalviya@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Advertise maximum number of sg supported by driver in single
 request
Thread-Topic: Advertise maximum number of sg supported by driver in single
 request
Thread-Index: AQHVy2lkQCcqMIYHKUy1nboikoXhwqfs7mr5gAF35ACAAAWfgIAABfwAgABBewCAABXtAIAAFo2AgARzsQCAAAEvEA==
Date:   Mon, 20 Jan 2020 10:08:10 +0000
Message-ID: <CY4PR0401MB3652AFEC71B080F072B840AFC3320@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <20200115060234.4mm6fsmsrryzpymi@gondor.apana.org.au>
 <9fd07805-8e2e-8c3f-6e5e-026ad2102c5a@chelsio.com>
 <c8d64068-a87b-36dd-910d-fb98e09c7e4b@asicdesigners.com>
 <20200117062300.qfngm2degxvjskkt@gondor.apana.org.au>
 <20d97886-e442-ed47-5685-ff5cd9fcbf1c@asicdesigners.com>
 <20200117070431.GE23018@gauss3.secunet.de>
 <318fd818-0135-8387-6695-6f9ba2a6f28e@asicdesigners.com>
 <20200117121722.GG26283@gauss3.secunet.de>
 <179f6f7e-f361-798b-a1c6-30926d8e8bf5@asicdesigners.com>
 <25436226c7e4453baf5038f3395e8eb4@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <25436226c7e4453baf5038f3395e8eb4@MN2PR20MB2973.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [31.149.181.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0468b9e8-bb56-44a0-d6cb-08d79d90a809
x-ms-traffictypediagnostic: CY4PR0401MB3506:
x-microsoft-antispam-prvs: <CY4PR0401MB35065D9AD4D3C0CB0D3D0AD0C3320@CY4PR0401MB3506.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(366004)(39840400004)(136003)(199004)(189003)(66476007)(66556008)(64756008)(66446008)(33656002)(66946007)(55016002)(86362001)(76116006)(316002)(110136005)(8936002)(53546011)(6506007)(7696005)(54906003)(186003)(81156014)(2906002)(8676002)(81166006)(4326008)(52536014)(5660300002)(71200400001)(9686003)(26005)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR0401MB3506;H:CY4PR0401MB3652.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y58yctwNb4azwmS6te5Vzq1FPaO2lr+aR9kgkYa4QCDyC2tYnmban30PhJKjUlDztZVQO3nskuhAH9WP8PuzXrNgyxGgrSoEEwxUqm/MDncii2KlXf8wzSR7jafSNtHICxv/xY8FD8mduusUs8fz3cYBsDIJKF3NfqWrG1ie2M8xdZrsI83CKhClIfTv10iSHCKKaPXT8xdS/68SeyGP93NdLmHe4D7ISgDLAUbw+lZR4uKb3f3FPBBpjsl6yLehZRG1RdpTNOGmgBq+VLctY4QfuUfK5WCmjkPplxTw5LPn6R9G51okKrC9Z7AcFpUvamEWiahUvURr2mABsi479EVgiFRlsGx2eDWiHpJGVpi8i80uLFaZY9ROJ1bAhpoa6IE420/A5w2dahimJftdjgZKafbMlJtXQRuLtDYL1spR8RnKP2gFEDWJzvVZA3hk
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0468b9e8-bb56-44a0-d6cb-08d79d90a809
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 10:08:10.9746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 90RM151Jyx0ZwKG5PbjpKetXc4J1dfOmK6O82saNaUsZS36dndCdXnHsnG/tiKFpBLTNZnLnwne6CSk6Z+p6fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3506
X-MC-Unique: Q_bXO3i3NRaxtuK7sdiJ5w-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: rambus.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U3RlZmZlbiwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBsaW51eC1j
cnlwdG8tb3duZXJAdmdlci5rZXJuZWwub3JnIDxsaW51eC1jcnlwdG8tb3duZXJAdmdlci5rZXJu
ZWwub3JnPiBPbiBCZWhhbGYgT2YgU3RlZmZlbiBLbGFzc2VydA0KPiBTZW50OiBNb25kYXksIEph
bnVhcnkgMjAsIDIwMjAgMTA6MzcgQU0NCj4gVG86IEF5dXNoIFNhd2FsIDxheXVzaC5zYXdhbEBh
c2ljZGVzaWduZXJzLmNvbT4NCj4gQ2M6IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5h
Lm9yZy5hdT47IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc7IG1hbm9qbWFsdml5YUBjaGVs
c2lvLmNvbTsgQXl1c2ggU2F3YWwNCj4gPGF5dXNoLnNhd2FsQGNoZWxzaW8uY29tPjsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogQWR2ZXJ0aXNlIG1heGltdW0gbnVtYmVy
IG9mIHNnIHN1cHBvcnRlZCBieSBkcml2ZXIgaW4gc2luZ2xlIHJlcXVlc3QNCj4NCj4gPDw8IEV4
dGVybmFsIEVtYWlsID4+Pg0KPiBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBv
dXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0
dGFjaG1lbnRzIHVubGVzcyB5b3UgcmVjb2duaXplIHRoZQ0KPiBzZW5kZXIvc2VuZGVyIGFkZHJl
c3MgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCj4NCj4NCj4gT24gRnJpLCBKYW4gMTcs
IDIwMjAgYXQgMDc6MDg6MDVQTSArMDUzMCwgQXl1c2ggU2F3YWwgd3JvdGU6DQo+ID4gSGkgc3Rl
ZmZlbiwNCj4gPg0KPiA+IE9uIDEvMTcvMjAyMCA1OjQ3IFBNLCBTdGVmZmVuIEtsYXNzZXJ0IHdy
b3RlOg0KPiA+ID4gT24gRnJpLCBKYW4gMTcsIDIwMjAgYXQgMDQ6Mjg6NTRQTSArMDUzMCwgQXl1
c2ggU2F3YWwgd3JvdGU6DQo+ID4gPiA+IEhpIHN0ZWZmZW4sDQo+ID4gPiA+DQo+ID4gPiA+IE9u
IDEvMTcvMjAyMCAxMjozNCBQTSwgU3RlZmZlbiBLbGFzc2VydCB3cm90ZToNCj4gPiA+ID4gPiBP
biBGcmksIEphbiAxNywgMjAyMCBhdCAxMjoxMzowN1BNICswNTMwLCBBeXVzaCBTYXdhbCB3cm90
ZToNCj4gPiA+ID4gPiA+IEhpIEhlcmJlcnQsDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gT24g
MS8xNy8yMDIwIDExOjUzIEFNLCBIZXJiZXJ0IFh1IHdyb3RlOg0KPiA+ID4gPiA+ID4gPiBPbiBU
aHUsIEphbiAxNiwgMjAyMCBhdCAwMToyNzoyNFBNICswNTMwLCBBeXVzaCBTYXdhbCB3cm90ZToN
Cj4gPiA+ID4gPiA+ID4gPiBUaGUgbWF4IGRhdGEgbGltaXQgaXMgMTUgc2dzIHdoZXJlIGVhY2gg
c2cgY29udGFpbnMgZGF0YSBvZiBtdHUgc2l6ZSAuDQo+ID4gPiA+ID4gPiA+ID4gd2UgYXJlIHJ1
bm5pbmcgYSBuZXRwZXJmIHVkcCBzdHJlYW0gdGVzdCBvdmVyIGlwc2VjIHR1bm5lbCAuVGhlIGlw
c2VjIHR1bm5lbA0KPiA+ID4gPiA+ID4gPiA+IGlzIGVzdGFibGlzaGVkIGJldHdlZW4gdHdvIGhv
c3RzIHdoaWNoIGFyZSBkaXJlY3RseSBjb25uZWN0ZWQNCj4gPiA+ID4gPiA+ID4gQXJlIHlvdSBh
Y3R1YWxseSBnZXR0aW5nIDE1LWVsZW1lbnQgU0cgbGlzdHMgZnJvbSBJUHNlYz8gV2hhdCBpcw0K
PiA+ID4gPiA+ID4gPiBnZW5lcmF0aW5nIGFuIHNrYiB3aXRoIDE1LWVsZW1lbnQgU0cgbGlzdHM/
DQo+ID4gPiA+ID4gPiB3ZSBoYXZlIGVzdGFibGlzaGVkIHRoZSBpcHNlYyB0dW5uZWwgaW4gdHJh
bnNwb3J0IG1vZGUgdXNpbmcgaXAgeGZybS4NCj4gPiA+ID4gPiA+IGFuZCBydW5uaW5nIHRyYWZm
aWMgdXNpbmcgbmV0c2VydmVyIGFuZCBuZXRwZXJmLg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+
IEluIHNlcnZlciBzaWRlIHdlIGFyZSBydW5uaW5nDQo+ID4gPiA+ID4gPiBuZXRzZXJ2ZXIgLTQN
Cj4gPiA+ID4gPiA+IEluIGNsaWVudCBzaWRlIHdlIGFyZSBydW5uaW5nDQo+ID4gPiA+ID4gPiAi
bmV0cGVyZiAtSCA8c2VydmVyaXA+IC1wIDxwb3J0PiAtdCBVRFBfU1RSRUFNICAtQ2MgLS0gLW0g
MjFrIg0KPiA+ID4gPiA+ID4gd2hlcmUgdGhlIHBhY2tldCBzaXplIGlzIDIxayAsd2hpY2ggaXMg
dGhlbiBmcmFnbWVudGVkIGludG8gMTUgaXAgZnJhZ21lbnRzDQo+ID4gPiA+ID4gPiBlYWNoIG9m
IG10dSBzaXplLg0KPiA+ID4gPiA+IEknbSBsYWNraW5nIGEgYml0IG9mIGNvbnRleHQgaGVyZSwg
YnV0IHRoaXMgc2hvdWxkIGdlbmVyYXRlIDE1IElQDQo+ID4gPiA+ID4gcGFja2V0cyB0aGF0IGFy
ZSBlbmNyeXB0ZWQgb25lIGJ5IG9uZS4NCj4gPiA+ID4gVGhpcyBpcyB3aGF0IGkgb2JzZXJ2ZWQg
LHBsZWFzZSBjb3JyZWN0IG1lIGlmIGkgYW0gd3JvbmcuDQo+ID4gPiA+IFRoZSBwYWNrZXQgd2hl
biByZWFjaGVzIGVzcF9vdXRwdXQoKSxpcyBpbiBzb2NrZXQgYnVmZmVyIGFuZCBiYXNlZCBvbiB0
aGUNCj4gPiA+ID4gbnVtYmVyIG9mIGZyYWdzICxzZyBpcyBpbml0aWFsaXplZCAgdXNpbmcNCj4g
PiA+ID4gc2dfaW5pdF90YWJsZShzZyxmcmFncyksd2hlcmUgZnJhZ3MgYXJlIDE1IGluIG91ciBj
YXNlLg0KPiA+ID4gVGhlIHBhY2tldCBzaG91bGQgYmUgSVAgZnJhZ21lbnRlZCBiZWZvcmUgaXQg
ZW50ZXJzIGVzcF9vdXRwdXQoKQ0KPiA+ID4gdW5sZXNzIHRoaXMgaXMgYSBVRFAgR1NPIHBhY2tl
dC4gV2hhdCBraW5kIG9mIGRldmljZSBkbyB5b3UgdXNlDQo+ID4gPiBoZXJlPyBJcyBpdCBhIGNy
eXB0byBhY2NlbGVyYXRvciBvciBhIE5JQyB0aGF0IGNhbiBkbyBFU1Agb2ZmbG9hZHM/DQo+ID4N
Cj4gPiBXZSBoYXZlIGRldmljZSB3aGljaCB3b3JrcyBhcyBhIGNyeXB0byBhY2NlbGVyYXRvciAu
IEl0IGp1c3QgZW5jcnlwdHMgdGhlDQo+ID4gcGFja2V0cyBhbmQgc2VuZCBpdCBiYWNrIHRvIGtl
cm5lbC4NCj4NCj4gSSBqdXN0IGRpZCBhIHRlc3QgYW5kIEkgc2VlIHRoZSBzYW1lIGJlaGF2aW91
ci4gU2VlbXMgbGlrZSBJIHdhcw0KPiBtaXN0YWtlbiwgd2UgYWN0dWFsbHkgZnJhZ21lbnQgdGhl
IEVTUCBwYWNrZXRzLiBUaGUgb25seSBjYXNlDQo+IHdoZXJlIHdlIGRvIHByZS1lbmNhcCBmcmFn
bWVudGF0aW9uIGlzIElQdjYgdHVubmVsIG1vZGUuIEJ1dCBJDQo+IHdvbmRlciBpZiBpdCB3b3Vs
ZCBtYWtlIHNlbnNlIHRvIGF2b2lkIHRvIGhhdmUgRVNQIGZyYWdtZW50cyBvbg0KPiB0aGUgd2ly
ZS4NCj4NCldlbGwsIGZvciBvbmUgdGhpbmcsIEkgZG9uJ3Qga25vdyBvZiBhbnkgSFcgSVBzZWMg
YWNjZWxlcmF0b3IgdGhhdCBjYW4NCmhhbmRsZSBmcmFnbWVudGVkIElQc2VjIHBhY2tldHMgZGly
ZWN0bHkuIE5vbmUgb2Ygb3VyIGhhcmR3YXJlLCB0aGF0IHdlJ3ZlDQpiZWVuIGRldmVsb3Bpbmcg
Zm9yIG92ZXIgMiBkZWNhZGVzIG5vdywgY2FuIGRvIHRoYXQuIEFsbCBmcmFnbWVudHMgd291bGQg
YmUNCmRlZmVycmVkIHRvIHRoZSBzbG93cGF0aCBmb3IgcmVhc3NlbWJseSwga2lsbGluZyBwZXJm
b3JtYW5jZS4NClNvIGZyb20gdGhhdCBwZXJzcGVjdGl2ZSB5b3UnZCB3YW50IHRvIGF2b2lkIHN5
c3RlbWF0aWMgcG9zdC1lbmNhcHN1bGF0aW9uDQpmcmFnbWVudGF0aW9uIHdoZW5ldmVyIHBvc3Np
YmxlLg0KUHJvcGVyIHBhdGggTVRVIGRpc2NvdmVyeSwgYWNjb3VudGluZyBmb3IgdGhlIGFkZGVk
IElQc2VjIGhlYWRlcnMsIHNob3VsZA0Kbm9ybWFsbHkgcHJldmVudCB0aGlzIGZyb20gYmVpbmcg
bmVjZXNzYXJ5Lg0KDQpIYXZpbmcgc2FpZCBhbGwgdGhhdCwgaXQncyBub3QgcG9zc2libGUgdG8g
ZW5jYXBzdWxhdGUgSVB2NCBmcmFnbWVudHMgaW4gdHJhbnNwb3J0DQptb2RlLiBTbyBpZiBQTVRV
IGRpc2NvdmVyeSBkb2VzIG5vdCBwcm9wZXJseSBhdm9pZCB0aGF0IHNpdHVhdGlvbiwgdGhlbiB5
b3UNCmhhdmUgbm8gY2hvaWNlIGJ1dCB0byBmcmFnbWVudCBfYWZ0ZXJfIEVTUC4gQnV0IF9vbmx5
XyBmb3IgdGhhdCBzcGVjaWZpYyBjYXNlLg0KDQpSZWdhcmRzLA0KUGFzY2FsIHZhbiBMZWV1d2Vu
DQpTaWxpY29uIElQIEFyY2hpdGVjdCBNdWx0aS1Qcm90b2NvbCBFbmdpbmVzLCBSYW1idXMgU2Vj
dXJpdHkNClJhbWJ1cyBST1RXIEhvbGRpbmcgQlYNCiszMS03MyA2NTgxOTUzDQoNCk5vdGU6IFRo
ZSBJbnNpZGUgU2VjdXJlL1ZlcmltYXRyaXggU2lsaWNvbiBJUCB0ZWFtIHdhcyByZWNlbnRseSBh
Y3F1aXJlZCBieSBSYW1idXMuDQpQbGVhc2UgYmUgc28ga2luZCB0byB1cGRhdGUgeW91ciBlLW1h
aWwgYWRkcmVzcyBib29rIHdpdGggbXkgbmV3IGUtbWFpbCBhZGRyZXNzLg0KDQoNCioqIFRoaXMg
bWVzc2FnZSBhbmQgYW55IGF0dGFjaG1lbnRzIGFyZSBmb3IgdGhlIHNvbGUgdXNlIG9mIHRoZSBp
bnRlbmRlZCByZWNpcGllbnQocykuIEl0IG1heSBjb250YWluIGluZm9ybWF0aW9uIHRoYXQgaXMg
Y29uZmlkZW50aWFsIGFuZCBwcml2aWxlZ2VkLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQg
cmVjaXBpZW50IG9mIHRoaXMgbWVzc2FnZSwgeW91IGFyZSBwcm9oaWJpdGVkIGZyb20gcHJpbnRp
bmcsIGNvcHlpbmcsIGZvcndhcmRpbmcgb3Igc2F2aW5nIGl0LiBQbGVhc2UgZGVsZXRlIHRoZSBt
ZXNzYWdlIGFuZCBhdHRhY2htZW50cyBhbmQgbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHku
ICoqDQoNClJhbWJ1cyBJbmMuPGh0dHA6Ly93d3cucmFtYnVzLmNvbT4NCg==

