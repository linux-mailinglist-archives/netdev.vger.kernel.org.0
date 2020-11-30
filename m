Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74842C88BB
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 16:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbgK3P5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 10:57:37 -0500
Received: from mail-eopbgr700136.outbound.protection.outlook.com ([40.107.70.136]:1632
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725870AbgK3P5h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 10:57:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WPf9weFotELKvbMgMsv5WJ6/Htz0mCV989gGLk/l64mmcZQQl44tSffsjGTGASCaXS5YW8YbRy+xu0KvTXX8toihoXRuGES32hPyN6+zMSiHkaZnU5dXx70SpLThfPsZSvb+NXbkQ9hywuwBSgMXhMyAWvGhOxYT/ui/aLVu701V7bIKDqSkvcVUgc4LzsFfBAJjPcIe4stcwk6MvELdQZ+oRTWnCONLOd3EIckV/8IJRp8+A9USoN1BKMTumCgG5tgYtNHilz86gXfXp4NaFKaD6WQLo8GceOVxl9TW9e9aBfD/Do9r1v6EZjzJ2UDcQ4tHOglNKOqv10epwPrqwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jeLsALwQgvEyxOzVuPwUlPdaTCgMcVP4PQnU3pZctw0=;
 b=nBabAl9tUBL/m4fcMbFSGAmvyQYOnIqgg3dcDRWMpNjJZHQUr0dSTT+/fK/8/lkpMusfcxdypfsGtFp4xQHw1YF7m3WIWGAeUYcgkbnq2he9vHf6blNWZQPqAkmXy9TpKzAWSnRpeQTBSRDNX0l8jtd9xEPttig6SRoxYds3Pc5EJa0A9Kz/G3qkkaUkVbkMY4Bpji5HpYESRK6eJ62q+C+ZH2PJODVmK6VIlWwKQirD92nCT61DWrWF/jmR9lcvp1R6iE05bE9cOav5pH/TYgMJMto8tHmlQ4/HbUqxeJZwZYmalKUhx8CT8h5ey0rgVt3sr7eWZ0d5KvY2yI8Bsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purdue.edu; dmarc=pass action=none header.from=purdue.edu;
 dkim=pass header.d=purdue.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purdue0.onmicrosoft.com; s=selector2-purdue0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jeLsALwQgvEyxOzVuPwUlPdaTCgMcVP4PQnU3pZctw0=;
 b=QNehwz6CFO33aQfaGYhDA3I/2yp39+4UOqcXyF0VODS1NubeNCZH7w34ekmcPXjpVRPC5j3XyfZcM9roAzayVJYqRxnGFpOeLIUYCwiMEen7qWoQTz6jWv8zqDRR35YQF7sj3bSshLWJk1nKf6xSsBUiCGUHgJZCeb215+tWwgE=
Received: from CH2PR22MB2056.namprd22.prod.outlook.com (2603:10b6:610:5d::11)
 by CH2PR22MB1957.namprd22.prod.outlook.com (2603:10b6:610:5d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Mon, 30 Nov
 2020 15:56:54 +0000
Received: from CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::1922:c660:f2f4:50fa]) by CH2PR22MB2056.namprd22.prod.outlook.com
 ([fe80::1922:c660:f2f4:50fa%7]) with mapi id 15.20.3611.031; Mon, 30 Nov 2020
 15:56:54 +0000
From:   "Gong, Sishuai" <sishuai@purdue.edu>
To:     Florian Westphal <fw@strlen.de>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [Race] data race between eth_heder_cache_update() and
 neigh_hh_output()
Thread-Topic: [Race] data race between eth_heder_cache_update() and
 neigh_hh_output()
Thread-Index: AQHWxy8RhjTAj8mKmkOtUuryqF2+yKng05UAgAAA5Yk=
Date:   Mon, 30 Nov 2020 15:56:53 +0000
Message-ID: <27D0DF9D-9764-4A0B-9196-88FEAFB21E61@purdue.edu>
References: <8B318E86-EED9-4EFE-A921-678532F36BBD@purdue.edu>,<20201130155342.GK2730@breakpoint.cc>
In-Reply-To: <20201130155342.GK2730@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=purdue.edu;
x-originating-ip: [66.253.158.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe17bb63-232d-4476-f566-08d895488ee7
x-ms-traffictypediagnostic: CH2PR22MB1957:
x-microsoft-antispam-prvs: <CH2PR22MB19578C2810FA571C7B1170D1DFF50@CH2PR22MB1957.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sx1eDvuomlGpO0MkSTGgVWxM8nyONw3xCrxPFlMVvcohRrnuekpVvBMq0HmkR0c3rsOIxJKtlHfcLEXXjTSfsOGJWnK8utYdra+VwHJZSoiHsi5eqItM0gbnNCcdKJxthD325hORJsQr+LmlG46qrSiUHbdaGnn0FMP9W8u/2FoLWEGg5/SqT2gMvuT0Wn6BDPz6itoQNIA4aAej9/BuJ3Et9DZt8UGUvfnOnV2AlpOiJJaRMLaKdNbLvQHtomV3dYdlSHmcbXE8XZWrRDV2GELPUw87r24fRmrxkEziPRDV/LU/7Xfzk80S4cmkWy0D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR22MB2056.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(346002)(396003)(76116006)(66556008)(66446008)(33656002)(64756008)(36756003)(8676002)(316002)(26005)(786003)(66946007)(75432002)(66476007)(8936002)(54906003)(4326008)(6486002)(2616005)(5660300002)(2906002)(6512007)(6916009)(478600001)(86362001)(6506007)(53546011)(71200400001)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?SFc0V0NyUkpzT0JwMnZydzE3Q2ZDNCtsbzZaa2tRTlh2b3VtVE5VZ0EvODY2?=
 =?utf-8?B?TmovZ1dlSkFIajhXa01hdUM4WUNEM0JkRFU3SEs3V0pqeHg2R1YzdC9OUWo5?=
 =?utf-8?B?NDQ4OEpXUGFMUUk1RTQ5WnVZSlc3TzhxZ0VlcXcrdWFwSmcyZE1FeDZVT1cx?=
 =?utf-8?B?cnBqSVNzWlY3Yk4yL25MUjFSN2hwV3BRK2h5RzRneE1NQmRheHp3RzZtVkRF?=
 =?utf-8?B?ZVhBWVovMG1uMTY2NEdzMHFZQkdBWDFPOXk0YnBYM1Vhd1NySkpOcVJ5cStV?=
 =?utf-8?B?L0NhazQvQ0RzWUU0SlZHSko3azRRaTMzRVQ1eGtEQ0k2dHMvbmRsUmlIa0NJ?=
 =?utf-8?B?RXVqS1h5WDZPektzOTJPcEhXZklkZDNPYzlRYi8yb1BqSDFKUlRDOUtzL0Fo?=
 =?utf-8?B?WTV5VFBWWFhsODZqaFFzb3dSUWhQK1VRS2QrWnhVckRXc0JjTzRJb1BsamhT?=
 =?utf-8?B?cnk4OHZTR2JSZHd2RDZPNDNLVTVSdHRHSHpPR0sxVTFjakltNGtNWS92ZnRx?=
 =?utf-8?B?M3NjNmJEb0pobkpCM285cHZocjZhdWZTWEhJZHR0UytNaXZ6N1U1TVpmc1FQ?=
 =?utf-8?B?NnFFMDZLdGVMSW4zRUkvcGVacG55ZGhjSkFITmE1SmRZNUhzb1I2czBXbEts?=
 =?utf-8?B?SW51MHNCT0ZvTG00bFE0NHZtNS9ieGpJbmtYY2dWRTBjb3psU1pLS2JORmFu?=
 =?utf-8?B?Z21TZ3ZEV2RyTnowMmtNbzRIcXA0OUx6bGFIVkRQNDBwWEZka2xqT2t5b2R2?=
 =?utf-8?B?SG4xaVNoOHhWTGRUUUIvc2pRTEtKV0JTR1JtVkZLOUJyRDdRc3dlWDlXR0I1?=
 =?utf-8?B?ZTEwTlkwaTF6NXNmSXZMRU10aGJ1U0FHa2tqNW5VdHlIQVdXWnRnRXh4Ujgw?=
 =?utf-8?B?UitWK0llV29WeGo2cUtLaFhKSUUxbjd6WGpkNVlXQm45ZlR0VWhnTEdUaGI3?=
 =?utf-8?B?bGk3dnU5cmZIZ0RwdDcwcGt1MXdtQmdNNmVrdTJOM2lyU214WlQ3T2Uwdkla?=
 =?utf-8?B?NERSbVZKMUtwYjliVTZleklINW9EMTc4ZmtQSHRFeVRQTFNzTTZOOGU4M3BS?=
 =?utf-8?B?NlUrYk1rWTEzdTVZVUsrb2dqSEtNMEpxZWV4ZjVMaTdDQWtBNW9EVHRWUWFx?=
 =?utf-8?B?c05kdDB3WjVvQmNKaUhXUzhoemlmQ0ErZDdsMU9FWkJYZ25sZy80YjNBTWpt?=
 =?utf-8?B?NlZFMVNCS2lVNlFYUnNwVzM1QjNIUDFuTjF0V2FxcU5JbDRvVVRaaGJlU0xi?=
 =?utf-8?B?N1JjeVdTT1FUWks1V3MvREJYOE9xM3hLWDRnNXZpekFxSlNKb1ppWlVXQWg3?=
 =?utf-8?Q?D7QXmVzR1Iw0ns3DgznhGOnFJPFg7OuSR9?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: purdue.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR22MB2056.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe17bb63-232d-4476-f566-08d895488ee7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 15:56:53.9968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4130bd39-7c53-419c-b1e5-8758d6d63f21
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U9+MqxfkMtnQZx3QPM84XkCzukEIA+7gXZekktkCxzcAq8X5s0d8RG7jxoboIsNOGRtsHjfxTZbuYLFNVJOTsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR22MB1957
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNClRoYW5rcyBmb3IgY2xhcmlmeWluZyBvdXIgY29uZnVzaW9uIGFuZCB3ZSBhcmUgc29y
cnkgaWYgd2UgY2F1c2VkIGFueSB0cm91YmxlLg0KDQo+IE9uIE5vdiAzMCwgMjAyMCwgYXQgMTA6
NTMgQU0sIEZsb3JpYW4gV2VzdHBoYWwgPGZ3QHN0cmxlbi5kZT4gd3JvdGU6DQo+IA0KPiDvu79H
b25nLCBTaXNodWFpIDxzaXNodWFpQHB1cmR1ZS5lZHU+IHdyb3RlOg0KPj4gSGksDQo+PiANCj4+
IFdlIGZvdW5kIGEgZGF0YSByYWNlIGluIGxpbnV4IGtlcm5lbCA1LjMuMTEgdGhhdCB3ZSBhcmUg
YWJsZSB0byByZXByb2R1Y2UgaW4geDg2IHVuZGVyIHNwZWNpZmljIGludGVybGVhdmluZ3MuIFdl
IGFyZSBub3Qgc3VyZSBhYm91dCB0aGUgY29uc2VxdWVuY2Ugb2YgdGhpcyByYWNlIG5vdyBidXQg
aXQgc2VlbXMgdGhhdCB0aGUgdHdvIG1lbWNweSgpIGNhbiBsZWFkIHRvIHNvbWUgaW5jb25zaXN0
ZW5jeS4gV2UgYWxzbyBub3RpY2VkIHRoYXQgYm90aCB0aGUgd3JpdGVyIGFuZCByZWFkZXIgYXJl
IHByb3RlY3RlZCBieSBsb2NrcywgYnV0IHRoZSB3cml0ZXIgaXMgcHJvdGVjdGVkIHVzaW5nIHNl
cWxvY2sgd2hpbGUgdGhlIHJlYWRlciBpcyBwcm90ZWN0ZWQgYnkgcmN1bG9jay4NCj4gDQo+IEFG
QUlDUyByZWFkZXIgdXNlcyBzYW1lIHNlcWxvY2sgYXMgdGhlIHdyaXRlci4NCj4gDQo+PiAtLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4+IFdyaXRlIHNpdGUNCj4+
IA0KPj4gL3RtcC90bXAuQjd6YjdvZDJ6RS01LjMuMTEvZXh0cmFjdC9saW51eC01LjMuMTEvbmV0
L2V0aGVybmV0L2V0aC5jOjI2NA0KPj4gICAgICAgIDI1MiAgLyoqDQo+PiAgICAgICAgMjUzICAg
KiBldGhfaGVhZGVyX2NhY2hlX3VwZGF0ZSAtIHVwZGF0ZSBjYWNoZSBlbnRyeQ0KPj4gICAgICAg
IDI1NCAgICogQGhoOiBkZXN0aW5hdGlvbiBjYWNoZSBlbnRyeQ0KPj4gICAgICAgIDI1NSAgICog
QGRldjogbmV0d29yayBkZXZpY2UNCj4+ICAgICAgICAyNTYgICAqIEBoYWRkcjogbmV3IGhhcmR3
YXJlIGFkZHJlc3MNCj4+ICAgICAgICAyNTcgICAqDQo+PiAgICAgICAgMjU4ICAgKiBDYWxsZWQg
YnkgQWRkcmVzcyBSZXNvbHV0aW9uIG1vZHVsZSB0byBub3RpZnkgY2hhbmdlcyBpbiBhZGRyZXNz
Lg0KPj4gICAgICAgIDI1OSAgICovDQo+PiAgICAgICAgMjYwICB2b2lkIGV0aF9oZWFkZXJfY2Fj
aGVfdXBkYXRlKHN0cnVjdCBoaF9jYWNoZSAqaGgsDQo+PiAgICAgICAgMjYxICAgICAgICAgICAg
ICAgICAgIGNvbnN0IHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQo+PiAgICAgICAgMjYyICAgICAg
ICAgICAgICAgICAgIGNvbnN0IHVuc2lnbmVkIGNoYXIgKmhhZGRyKQ0KPj4gICAgICAgIDI2MyAg
ew0KPj4gPT0+ICAgIDI2NCAgICAgIG1lbWNweSgoKHU4ICopIGhoLT5oaF9kYXRhKSArIEhIX0RB
VEFfT0ZGKHNpemVvZihzdHJ1Y3QgZXRoaGRyKSksDQo+PiAgICAgICAgMjY1ICAgICAgICAgICAg
IGhhZGRyLCBFVEhfQUxFTik7DQo+IA0KPiBUaGlzIGlzIGNhbGxlZCB1bmRlciB3cml0ZV9zZXFs
b2NrX2JoKGhoLT5oaF9sb2NrKQ0KPiANCj4+IC90bXAvdG1wLkI3emI3b2QyekUtNS4zLjExL2V4
dHJhY3QvbGludXgtNS4zLjExL2luY2x1ZGUvbmV0L25laWdoYm91ci5oOjQ4MQ0KPj4gICAgICAg
IDQ2MyAgc3RhdGljIGlubGluZSBpbnQgbmVpZ2hfaGhfb3V0cHV0KGNvbnN0IHN0cnVjdCBoaF9j
YWNoZSAqaGgsIHN0cnVjdCBza19idWZmICpza2IpDQo+PiAgICAgICAgNDY0ICB7DQo+PiAgICAg
ICAgNDY1ICAgICAgdW5zaWduZWQgaW50IGhoX2FsZW4gPSAwOw0KPj4gICAgICAgIDQ2NiAgICAg
IHVuc2lnbmVkIGludCBzZXE7DQo+PiAgICAgICAgNDY3ICAgICAgdW5zaWduZWQgaW50IGhoX2xl
bjsNCj4+ICAgICAgICA0NjgNCj4+ICAgICAgICA0NjkgICAgICBkbyB7DQo+PiAgICAgICAgNDcw
ICAgICAgICAgIHNlcSA9IHJlYWRfc2VxYmVnaW4oJmhoLT5oaF9sb2NrKTsgDQo+IA0KPiBUaGlz
IHNhbXBsZXMgdGhlIHNlcWNvdW50Lg0KPiANCj4+ICAgICAgICA0NzEgICAgICAgICAgaGhfbGVu
ID0gaGgtPmhoX2xlbjsNCj4+ICAgICAgICA0NzIgICAgICAgICAgaWYgKGxpa2VseShoaF9sZW4g
PD0gSEhfREFUQV9NT0QpKSB7DQo+PiAgICAgICAgNDczICAgICAgICAgICAgICBoaF9hbGVuID0g
SEhfREFUQV9NT0Q7DQo+PiAgICAgICAgNDc0DQo+PiAgICAgICAgNDc1ICAgICAgICAgICAgICAv
KiBza2JfcHVzaCgpIHdvdWxkIHByb2NlZWQgc2lsZW50bHkgaWYgd2UgaGF2ZSByb29tIGZvcg0K
Pj4gICAgICAgIDQ3NiAgICAgICAgICAgICAgICogdGhlIHVuYWxpZ25lZCBzaXplIGJ1dCBub3Qg
Zm9yIHRoZSBhbGlnbmVkIHNpemU6DQo+PiAgICAgICAgNDc3ICAgICAgICAgICAgICAgKiBjaGVj
ayBoZWFkcm9vbSBleHBsaWNpdGx5Lg0KPj4gICAgICAgIDQ3OCAgICAgICAgICAgICAgICovDQo+
PiAgICAgICAgNDc5ICAgICAgICAgICAgICBpZiAobGlrZWx5KHNrYl9oZWFkcm9vbShza2IpID49
IEhIX0RBVEFfTU9EKSkgew0KPj4gICAgICAgIDQ4MCAgICAgICAgICAgICAgICAgIC8qIHRoaXMg
aXMgaW5saW5lZCBieSBnY2MgKi8NCj4+ID09PiAgICA0ODEgICAgICAgICAgICAgICAgICBtZW1j
cHkoc2tiLT5kYXRhIC0gSEhfREFUQV9NT0QsIGhoLT5oaF9kYXRhLA0KPj4gICAgICAgIDQ4MiAg
ICAgICAgICAgICAgICAgICAgICAgICBISF9EQVRBX01PRCk7DQo+IA0KPiBbLi5dDQo+IA0KPj4g
ICAgICAgIDQ5MiAgICAgIH0gd2hpbGUgKHJlYWRfc2VxcmV0cnkoJmhoLT5oaF9sb2NrLCBzZXEp
KTsNCj4gDQo+IC4uLiBzbyB0aGlzIHJldHJpZXMgdW5sZXNzIHNlcWNvdW50IHdhcyBzdGFibGUu
DQo=
