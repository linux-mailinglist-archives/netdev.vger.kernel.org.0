Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011082EA073
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 00:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbhADXKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 18:10:09 -0500
Received: from us-smtp-delivery-181.mimecast.com ([63.128.21.181]:40533 "EHLO
        us-smtp-delivery-181.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727141AbhADXKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 18:10:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rbbn.com; s=mimecast20180816;
        t=1609801721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xl5Z6fBU1FN6XHoRCwGpUmGZ8Kb8jXDq7wpcpYrdIRs=;
        b=Imva3xYiR9qN+BVrxPSDg/Ejw0RlUvBiHMsjqYfvDaI2rgy8z04UpQNzB5A3MrUIKLp44m
        aCIltaL/6cKEqp02llY63lInome+QCHdaH0oWkgPhZ4eg59dViTU273UbDAciEQnthZwAp
        v33WbSWgS4rjx/pKaYA7oSvSPgGj4x8=
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-jM1OJwmtP1m5l7xTvm2Enw-1; Mon, 04 Jan 2021 18:08:40 -0500
Received: from MN2PR03MB4752.namprd03.prod.outlook.com (2603:10b6:208:af::30)
 by MN2PR03MB5374.namprd03.prod.outlook.com (2603:10b6:208:1e3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.22; Mon, 4 Jan
 2021 23:08:38 +0000
Received: from MN2PR03MB4752.namprd03.prod.outlook.com
 ([fe80::e888:49b:bdd7:75df]) by MN2PR03MB4752.namprd03.prod.outlook.com
 ([fe80::e888:49b:bdd7:75df%7]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 23:08:38 +0000
From:   "Finer, Howard" <hfiner@rbbn.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
CC:     "andy@greyhouse.net" <andy@greyhouse.net>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: bonding driver issue when configured for active/backup and using
 ARP monitoring
Thread-Topic: bonding driver issue when configured for active/backup and using
 ARP monitoring
Thread-Index: AdbHQ00ZgN9FZpM9RKmwxP/JkIcJoADOsOqABhwSyFA=
Date:   Mon, 4 Jan 2021 23:08:38 +0000
Message-ID: <MN2PR03MB47524C92E45EB4C1B70D595CB7D20@MN2PR03MB4752.namprd03.prod.outlook.com>
References: <MN2PR03MB47526B686EF6E0F8D81A9397B7F50@MN2PR03MB4752.namprd03.prod.outlook.com>
 <14769.1607114585@famine>
In-Reply-To: <14769.1607114585@famine>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [208.45.178.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04b463a7-bb2a-4fcd-e94a-08d8b105ab62
x-ms-traffictypediagnostic: MN2PR03MB5374:
x-microsoft-antispam-prvs: <MN2PR03MB53746F2BA8EAF08007297466B7D20@MN2PR03MB5374.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 4bN6oHpf9NJHXenzEhpHWisDDuiIajdy3PhKkasCaLRqbAskctc4kicG3GaGbiXIj9dH8QGGNE1QM8yxQ2Wem/fpKPgidjRyZ+yf/ywoT2MG7yi8ODSpZqzd8ysWB66MnUVzkHsgZ5AJxZ5W5ilcz82qntmJuIKSs4XwUn0mnqxn7FUZANO42P8+xBLSwCESLYamgWSLdEx4NBiwRAzds/rD5rnsYHOxm83HtbGpAz+V/Q7TfiXWcTY9V+RLVb3993snhr9YeASKrsTYbs7V+JJvoLl4myZiNVr1kTsbd/N2EVJNBmNuI9ZQMnbUGZ8OOy02A5FgsqPx0GfyvkNJzulB2DWGyMhWfPiOr+JkEGJm8qPraDzn+gTFpSoXnIbVjlAPjjar6WGaEmYJEcdMvelb5qrY2C63YZ4ggyBzhjPwdAyDWKLUPWzoRpRXAiiQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR03MB4752.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(346002)(39860400002)(396003)(26005)(55016002)(9686003)(8676002)(66946007)(6916009)(66476007)(66556008)(76116006)(64756008)(71200400001)(66446008)(4326008)(316002)(33656002)(2906002)(186003)(54906003)(7696005)(83380400001)(52536014)(53546011)(478600001)(8936002)(5660300002)(86362001)(6506007)(554084002);DIR:OUT;SFP:1101
x-ms-exchange-antispam-messagedata: =?utf-8?B?MGVmZXRpMFpLU1h4TlBiWEo3MEVDK0IrcjA3YStIeXp2cnUyUTJxYkQyd1hq?=
 =?utf-8?B?QVBJVFVuVkl5T3BWa2Rjc3VzWkRIWnA1d3AzSG5nUmc2MnhkaXBIMEk1RUg0?=
 =?utf-8?B?cmlibkZZdU1hVW5hc25obTlKbW1JSWs5OTNBYUk5T2dlZGhoMWVwK09hYkRL?=
 =?utf-8?B?V3NVbitRUDdKUFE2OUxkSW5BcFZ5WmpaSVlzTDhnWFNOMGZtb1N6KzUraUl6?=
 =?utf-8?B?UGVIcjVIMDcrOVBGQW54cEZtUVc5aVRyOWJPTi9BY1g4UlF3L214MlVaSjlN?=
 =?utf-8?B?R2p5cTcrY1FVSnB1NGFZSGh6WHAyOVJQZ1N5YVBlQlZaaDN5SnBkYW15VGoz?=
 =?utf-8?B?U1VzZnlMelJzZXZWWmN0dVRMQWJ2ZDlZZHJIMHovOTU1d0hnbDNmMGFUM1lK?=
 =?utf-8?B?cmJGcC9oV1NGZVFMYTAyUThvaUN4MzczK1hlMXE2QytUbCt3b01GTnl0SDNm?=
 =?utf-8?B?VHhGSkxTQktQQlFydzJoQkU5SjE1V1h5aFFXdVZzRnkwTHlEWnE0Z1JRdFpS?=
 =?utf-8?B?VzcrRmlydGZZTTdQODN4NjdLdEdSSkVnVTJYSEUvVDBqUWZxVlVUemxJdzA0?=
 =?utf-8?B?cVRCVlpmekxXTUFHdCtlUy9zQnJxRlN2VW1pQTNCMDhYQXBteHVybk1FVFJu?=
 =?utf-8?B?VTVhSXUrNmZ4NE9DOHprZ0FqQ1g2RzhEVmg3QTNjTm5nUk1icXplZ0tZQnpZ?=
 =?utf-8?B?UlpjMTJEYkREdWtod0xab3hFZnFsL1drRmlxZForQnpyR25MdTlwRm93MG83?=
 =?utf-8?B?RHl2L1YrN3ZxNXNJUGNaVkdqNVFKQ05ZaWg3SkhleWNjSmVZbHEyb3RMVXdv?=
 =?utf-8?B?RTU2MmR1ZFkwTFU5TkRmL1E2U3grRjZKSFBYa0pZbGNPczc4bDNBSEpIcDFl?=
 =?utf-8?B?bmMySDNJNzExU2dRWXhYTFBRaG8veUl0eDVLY0lKRnl0bTNxalppRUV4Y0ZS?=
 =?utf-8?B?N09CZ3VkQjJrRFZ3WTdDbjRrbUNWTUcycUlQUWNDVU1JY1hWQ1cxYlBLblMv?=
 =?utf-8?B?azZmQm8wNWZuRlJkWFpYcFllNTR4T29kN1U2NWorRTBHYUZhZHhISlhjamN1?=
 =?utf-8?B?and1bnJwUG5Fck01KzlJdTY5RWp3bEprUkVpaVg0a2tvUFk0V3lDV1NVVUNs?=
 =?utf-8?B?dHBrSm9HUnRLT2UzcFhJaC9kanpBT2JTNFBwNHBkdVNJUFMrakZWV1JQZzZs?=
 =?utf-8?B?Z2N1eWx6RzI0T1Z3ZkZCMVo0b2d6VXBMbkpiMEx3WG8xdjhXLzUyVExsYzhI?=
 =?utf-8?B?YmU3aG9IdzlaelVLSWtIVUpXMlZFMnhQblBMTWtFdXFZTjFDWVN3anhUUjJx?=
 =?utf-8?Q?KM4MY+663kCH0=3D?=
x-ms-exchange-transport-forked: True
x-mc-unique: jM1OJwmtP1m5l7xTvm2Enw-1
x-originatororg: rbbn.com
x-ms-exchange-crosstenant-authas: Internal
x-ms-exchange-crosstenant-authsource: MN2PR03MB4752.namprd03.prod.outlook.com
x-ms-exchange-crosstenant-network-message-id: 04b463a7-bb2a-4fcd-e94a-08d8b105ab62
x-ms-exchange-crosstenant-originalarrivaltime: 04 Jan 2021 23:08:38.0494 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 29a671dc-ed7e-4a54-b1e5-8da1eb495dc3
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: iKhn5Dq1s71sa46ycx1nb22gEFXTpINwerh6r3yAROOEML0nBZ7eAns3qw0QU15w
x-ms-exchange-transport-crosstenantheadersstamped: MN2PR03MB5374
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA81A106 smtp.mailfrom=hfiner@rbbn.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: rbbn.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UGxlYXNlIGFkdmlzZSBpZiB0aGVyZSBpcyBhbnkgdXBkYXRlIGhlcmUsIGFuZCBpZiBub3QgaG93
IHdlIGNhbiBnbyBhYm91dCBnZXR0aW5nIGFuIHVwZGF0ZSB0byB0aGUgZHJpdmVyIHRvIHJlY3Rp
ZnkgdGhlIGlzc3VlLg0KDQpUaGFua3MsDQpIb3dhcmQNCg0KDQpGcm9tOiBKYXkgVm9zYnVyZ2gg
PGpheS52b3NidXJnaEBjYW5vbmljYWwuY29tPg0KU2VudDogRnJpZGF5LCBEZWNlbWJlciA0LCAy
MDIwIDM6NDMgUE0NClRvOiBGaW5lciwgSG93YXJkIDxoZmluZXJAcmJibi5jb20+DQpDYzogYW5k
eUBncmV5aG91c2UubmV0OyB2ZmFsaWNvQGdtYWlsLmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
Zw0KU3ViamVjdDogUmU6IGJvbmRpbmcgZHJpdmVyIGlzc3VlIHdoZW4gY29uZmlndXJlZCBmb3Ig
YWN0aXZlL2JhY2t1cCBhbmQgdXNpbmcgQVJQIG1vbml0b3JpbmcNCg0KX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXw0KTk9USUNFOiBUaGlzIGVtYWlsIHdhcyByZWNlaXZl
ZCBmcm9tIGFuIEVYVEVSTkFMIHNlbmRlcg0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXw0KDQpGaW5lciwgSG93YXJkIDxtYWlsdG86aGZpbmVyQHJiYm4uY29tPiB3cm90
ZToNCg0KPldlIHVzZSB0aGUgYm9uZGluZyBkcml2ZXIgaW4gYW4gYWN0aXZlLWJhY2t1cCBjb25m
aWd1cmF0aW9uIHdpdGggQVJQDQo+bW9uaXRvcmluZy4gV2UgYWxzbyB1c2UgdGhlIFRJUEMgcHJv
dG9jb2wgd2hpY2ggd2UgcnVuIG92ZXIgdGhlIGJvbmQNCj5kZXZpY2UuIFdlIGFyZSBjb25zaXN0
ZW50bHkgc2VlaW5nIGFuIGlzc3VlIGluIGJvdGggdGhlIDMuMTYgYW5kIDQuMTkNCj5rZXJuZWxz
IHdoZXJlYnkgd2hlbiB0aGUgYm9uZCBzbGF2ZSBpcyBzd2l0Y2hlZCBUSVBDIGlzIGJlaW5nIG5v
dGlmaWVkIG9mDQo+dGhlIGNoYW5nZSByYXRoZXIgdGhhbiBpdCBoYXBwZW5pbmcgc2lsZW50bHku
IFRoZSBwcm9ibGVtIHRoYXQgd2Ugc2VlIGlzDQo+dGhhdCB3aGVuIHRoZSBhY3RpdmUgc2xhdmUg
ZmFpbHMsIGEgTkVUREVWX0NIQU5HRSBldmVudCBpcyBiZWluZyBzZW50IHRvDQo+dGhlIFRJUEMg
ZHJpdmVyIHRvIG5vdGlmeSBpdCB0aGF0IHRoZSBsaW5rIGlzIGRvd24uIFRoaXMgY2F1c2VzIHRo
ZSBUSVBDDQo+ZHJpdmVyIHRvIHJlc2V0IGl0cyBiZWFyZXJzIGFuZCB0aGVyZWZvcmUgYnJlYWsg
Y29tbXVuaWNhdGlvbiBiZXR3ZWVuIHRoZQ0KPm5vZGVzIHRoYXQgYXJlIGNsdXN0ZXJlZC4NCj5X
aXRoIHNvbWUgYWRkaXRpb25hbCBpbnN0cnVtZW50YXRpb24gaW4gdGhlZSBkcml2ZXIsIEkgc2Vl
IHRoaXMgaW4NCj4vdmFyL2xvZy9zeXNsb2c6DQo+PDY+IDEgMjAyMC0xMS0yMFQxODoxNDoxOS4x
NTk1MjQrMDE6MDAgTEFCTkJTNUIga2VybmVsIC0gLSAtDQo+WzY1ODE4LjM3ODI4N10gYm9uZDA6
IGxpbmsgc3RhdHVzIGRlZmluaXRlbHkgZG93biBmb3IgaW50ZXJmYWNlIGV0aDAsDQo+ZGlzYWJs
aW5nIGl0DQo+PDY+IDEgMjAyMC0xMS0yMFQxODoxNDoxOS4xNTk1MzYrMDE6MDAgTEFCTkJTNUIg
a2VybmVsIC0gLSAtDQo+WzY1ODE4LjM3ODI5Nl0gYm9uZDA6IG5vdyBydW5uaW5nIHdpdGhvdXQg
YW55IGFjdGl2ZSBpbnRlcmZhY2UhDQo+PDY+IDEgMjAyMC0xMS0yMFQxODoxNDoxOS4xNTk1Mzcr
MDE6MDAgTEFCTkJTNUIga2VybmVsIC0gLSAtDQo+WzY1ODE4LjM3ODMwNF0gYm9uZDA6IGJvbmRf
YWN0aXZlYmFja3VwX2FycF9tb246IG5vdGlmeV9ydG5sLCBzbGF2ZSBzdGF0ZQ0KPm5vdGlmeS9z
bGF2ZSBsaW5rIG5vdGlmeQ0KPjw2PiAxIDIwMjAtMTEtMjBUMTg6MTQ6MTkuMTU5NTM4KzAxOjAw
IExBQk5CUzVCIGtlcm5lbCAtIC0gLQ0KPls2NTgxOC4zNzg4MzVdIG5ldGRldiBjaGFuZ2UgYmVh
cmVyIDxldGg6Ym9uZDA+DQo+PDY+IDEgMjAyMC0xMS0yMFQxODoxNDoxOS4yNjM1MjMrMDE6MDAg
TEFCTkJTNUIga2VybmVsIC0gLSAtDQo+WzY1ODE4LjQ4MjM4NF0gYm9uZDA6IGxpbmsgc3RhdHVz
IGRlZmluaXRlbHkgdXAgZm9yIGludGVyZmFjZSBldGgxDQo+PDY+IDEgMjAyMC0xMS0yMFQxODox
NDoxOS4yNjM1MzQrMDE6MDAgTEFCTkJTNUIga2VybmVsIC0gLSAtDQo+WzY1ODE4LjQ4MjM4N10g
Ym9uZDA6IG1ha2luZyBpbnRlcmZhY2UgZXRoMSB0aGUgbmV3IGFjdGl2ZSBvbmUNCj48Nj4gMSAy
MDIwLTExLTIwVDE4OjE0OjE5LjI2MzUzNiswMTowMCBMQUJOQlM1QiBrZXJuZWwgLSAtIC0NCj5b
NjU4MTguNDgyNjMzXSBib25kMDogZmlyc3QgYWN0aXZlIGludGVyZmFjZSB1cCENCj48Nj4gMSAy
MDIwLTExLTIwVDE4OjE0OjE5LjI2MzUzNyswMTowMCBMQUJOQlM1QiBrZXJuZWwgLSAtIC0NCj5b
NjU4MTguNDgyNjcxXSBuZXRkZXYgY2hhbmdlIGJlYXJlciA8ZXRoOmJvbmQwPg0KPjw2PiAxIDIw
MjAtMTEtMjBUMTg6MTQ6MTkuMzY3NTIzKzAxOjAwIExBQk5CUzVCIGtlcm5lbCAtIC0gLQ0KPls2
NTgxOC41ODYyMjhdIGJvbmQwOiBib25kX2FjdGl2ZWJhY2t1cF9hcnBfbW9uOiBjYWxsX25ldGRl
dmljZV9ub3RpZmllcnMNCj5ORVRERVZfTk9USUZZX1BFRVJTDQo+DQo+VGhlcmUgaXMgbm8gaXNz
dWUgd2hlbiB1c2luZyBNSUkgbW9uaXRvcmluZyBpbnN0ZWFkIG9mIEFSUCBtb25pdG9yaW5nDQo+
c2luY2Ugd2hlbiB0aGUgc2xhdmUgaXMgZGV0ZWN0ZWQgYXMgZG93biwgaXQgaW1tZWRpYXRlbHkg
c3dpdGNoZXMgdG8gdGhlDQo+YmFja3VwIGFzIGl0IHNlZXMgdGhhdCBzbGF2ZSBhcyBiZWluZyB1
cCBhbmQgcmVhZHkuIEJ1dCB3aGVuIHVzaW5nIEFSUA0KPm1vbml0b3JpbmcsIG9ubHkgb25lIG9m
IHRoZSBzbGF2ZXMgaXMgJ3VwJy4gU28gd2hlbiB0aGUgYWN0aXZlIHNsYXZlIGdvZXMNCj5kb3du
LCB0aGUgYm9uZGluZyBkcml2ZXIgd2lsbCBzZWUgbm8gYWN0aXZlIHNsYXZlcyB1bnRpbCBpdCBi
cmluZ3MgdXAgdGhlDQo+YmFja3VwIHNsYXZlIG9uIHRoZSBuZXh0IGNhbGwgdG8gYm9uZF9hY3Rp
dmViYWNrdXBfYXJwX21vbi4gQnJpbmdpbmcgdXANCj50aGF0IGJhY2t1cCBzbGF2ZSBoYXMgdG8g
YmUgYXR0ZW1wdGVkIHByaW9yIHRvIG5vdGlmeWluZyBhbnkgcGVlcnMgb2YgYQ0KPmNoYW5nZSBv
ciBlbHNlIHRoZXkgd2lsbCBzZWUgdGhlIG91dGFnZS4gSW4gdGhpcyBjYXNlIGl0IHNlZW1zIHRo
ZQ0KPnNob3VsZF9ub3RpZnlfcnRubCBmbGFnIGhhcyB0byBiZSBzZXQgdG8gZmFsc2UuIEhvd2V2
ZXIsIEkgYWxzbyBxdWVzdGlvbg0KPmlmIHRoZSBzd2l0Y2ggdG8gdGhlIGJhY2t1cCBzbGF2ZSBz
aG91bGQgYWN0dWFsbHkgb2NjdXIgaW1tZWRpYXRlbHkgbGlrZQ0KPml0IGRvZXMgZm9yIE1JSSBh
bmQgdGhhdCB0aGUgYmFja3VwIHNob3VsZCBiZSBpbW1lZGlhdGVseSAnYnJvdWdodA0KPnVwL3N3
aXRjaGVkIHRvJyB3aXRob3V0IGhhdmluZyB0byB3YWl0IGZvciB0aGUgbmV4dCBpdGVyYXRpb24u
DQoNCkkgc2VlIHdoYXQgeW91J3JlIGRlc2NyaWJpbmc7IEknbSB3YXRjaGluZyAiaXAgbW9uaXRv
ciIgd2hpbGUNCmRvaW5nIGZhaWxvdmVycyBhbmQgY29tcGFyaW5nIHRoZSBiZWhhdmlvciBvZiB0
aGUgbWlpbW9uIHZzIHRoZSBBUlANCm1vbml0b3IuIFRoZSBib25kIGRldmljZSBpdHNlbGYgZ29l
cyBkb3duIGR1cmluZyB0aGUgY291cnNlIG9mIGFuIEFSUA0KZmFpbG92ZXIsIHdoaWNoIGRvZXNu
J3QgaGFwcGVuIGR1cmluZyB0aGUgbWlpbW9uIGZhaWxvdmVyLg0KDQpUaGlzIGRvZXMgY2F1c2Ug
c29tZSBjaHVybiBvZiBldmVuIHRoZSBJUHY0IG11bHRpY2FzdCBhZGRyZXNzZXMNCmFuZCBzdWNo
LCBzbyBpdCB3b3VsZCBiZSBpZGVhbCBpZiB0aGUgYmFja3VwIGludGVyZmFjZXMgY291bGQgYmUg
a2VwdA0KdHJhY2sgb2YgYW5kIHN3aXRjaGVkIHRvIGltbWVkaWF0ZWx5IGFzIHlvdSBzdWdnZXN0
Lg0KDQpJIGRvbid0IHRoaW5rIGl0J3Mgc2ltcGx5IGEgbWF0dGVyIG9mIG5vdCBkb2luZyBhIG5v
dGlmaWNhdGlvbiwNCmhvd2V2ZXIuIEkgaGF2ZW4ndCBpbnN0cnVtZW50ZWQgaXQgY29tcGxldGVs
eSB5ZXQgdG8gc2VlIHRoZSBjb21wbGV0ZQ0KYmVoYXZpb3IsIGJ1dCB0aGUgYmFja3VwIGludGVy
ZmFjZSBoYXMgdG8gYmUgaW4gYSBib25kaW5nLWludGVybmFsIGRvd24NCnN0YXRlLCBvdGhlcndp
c2UgdGhlIGJvbmRfYWJfYXJwX2NvbW1pdCBjYWxsIHRvIGJvbmRfc2VsZWN0X2FjdGl2ZV9zbGF2
ZQ0Kd291bGQgc2VsZWN0IGEgbmV3IGFjdGl2ZSBzbGF2ZSwgYW5kIHRoZSBib25kIGl0c2VsZiB3
b3VsZCBub3QgZ28NCk5PLUNBUlJJRVIgKHdoaWNoIGlzIGxpa2VseSB3aGVyZSB0aGUgTkVUREVW
X0NIQU5HRSBldmVudCBjb21lcyBmcm9tLA0KdmlhIGxpbmt3YXRjaCBkb2luZyBuZXRkZXZfc3Rh
dGVfY2hhbmdlKS4NCg0KWy4uLl0NCg0KPkFzIGl0IGN1cnJlbnRseSBiZWhhdmVzIHRoZXJlIGlz
IG5vIHdheSB0byBydW4gVElQQyBvdmVyIGFuIGFjdGl2ZS1iYWNrdXANCj5BUlAtbW9uaXRvcmVk
IGJvbmQgZGV2aWNlLiBJIHN1c3BlY3QgdGhlcmUgYXJlIG90aGVyIHNpdHVhdGlvbnMvdXNlcyB0
aGF0DQo+d291bGQgbGlrZXdpc2UgaGF2ZSBhbiBpc3N1ZSB3aXRoIHRoZSAnZXJyb25lb3VzJyBO
RVRERVZfQ0hBTkdFIGJlaW5nDQo+aXNzdWVkLiBTaW5jZSBUSVBDIChhbmQgb3RoZXJzKSBoYXZl
IG5vIGlkZWEgd2hhdCB0aGUgZGV2IGlzLCBpdCBpcyBub3QNCj5wb3NzaWJsZSB0byBpZ25vcmUg
dGhlIGV2ZW50IG5vciBzaG91bGQgaXQgYmUgaWdub3JlZC4gSXQgdGhlcmVmb3JlIHNlZW1zDQo+
dGhlIGV2ZW50IHNob3VsZG4ndCBiZSBzZW50IGZvciB0aGlzIHNpdHVhdGlvbi4gUGxlYXNlIGNv
bmZpcm0gdGhlDQo+YW5hbHlzaXMgYWJvdmUgYW5kIHByb3ZpZGUgYSBwYXRoIGZvcndhcmQgc2lu
Y2UgYXMgY3VycmVudGx5IGltcGxlbWVudGVkDQo+dGhlIGZ1bmN0aW9uYWxpdHkgaXMgYnJva2Vu
Lg0KDQpBcyBJIHNhaWQgYWJvdmUsIEkgZG9uJ3QgdGhpbmsgaXQncyBqdXN0IGFib3V0IG5vdGlm
aWNhdGlvbnMuDQoNCi1KDQoNCi0tLQ0KLUpheSBWb3NidXJnaCwgbWFpbHRvOmpheS52b3NidXJn
aEBjYW5vbmljYWwuY29tDQo=

