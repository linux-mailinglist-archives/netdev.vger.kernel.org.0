Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B1330989F
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 23:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbhA3WMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 17:12:19 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:6350 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbhA3WMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 17:12:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612044735; x=1643580735;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ty3iyb7ysdUdXREqGt3lEO8MZE9V17oRppxSu6bkFZw=;
  b=fyJnco6PU51/eX2JMRpZjqHNLZ5KzlYf4xYxvDWRky/LrlLSXYQGixho
   qE9AA3LsO7Thnp6djzKjWB3+mlzSBhJvVkjG4iRhlsAcmPuq3v3cZWBg5
   mF8wg78uEyhYx2EBF6RbcmdoNHOnqNN3wDdexORergkbeuOfj1pH8X0o3
   sykd1bQeCDC4GwzBKAZIG/LQEYh59CZpjcxt5dbDHbn7HwgmDaNEYWdWT
   +LWU2KL7sMfpfUCoXewgQzRrujAxSoE5GwLeCqIMIJR0q0osrhq3AmXqv
   nxonD8xe36Z0js0emRJto84Tz2iF4dssO4v9hwY83tJMv8ZV7V0SAV7dR
   A==;
IronPort-SDR: 441x/FiSBig6a+y+qgZLaR6rlRcbX80t/kYG5u+yG0fXKC5uPghxpRlj8ETQOIE2PLDPqLe8Sv
 +BAq/LDliNcu552EgbTe1B1ITo3EJYD3JdVJkymMPaagQm11aaCjbg9/aE45GCHuuVFtPu/cxl
 eneJyGax1LIClrTt5BzWVDcFjxBPjjrcCG4PrmOL4yNy1ftPkiE/Zbr+LrHl2yRkCFUsDwfm25
 t53+L5pT8aLtbgTOoautHRa18/vGR3B8/z01LA6j2hHc5BGZyVoaR9f9INREBfCF/+skwKui5f
 Qck=
X-IronPort-AV: E=Sophos;i="5.79,389,1602572400"; 
   d="scan'208";a="113150232"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jan 2021 15:10:58 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 30 Jan 2021 15:10:58 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Sat, 30 Jan 2021 15:10:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffVGAQ+v99F3WMkhCMqQk0EMipyJm2KBWFVwEoEjdolaldp71IixbdBwO1pIYRBRmQJMg3UI3w4k/wZpOd7NJ2nVQaYkfbAcU+UBtTvkAJoCabSnvhhIKJAIRqL1Tohy4M3Phl4+Xuc1WVbmIZoxyITbmaxc1ttZeotZgkf7bLEk3Ra1fXOE3z/qV9ELZPmDDPT3ERmyuY5xAPOUYTpHvXt77IX/sRa7hM75I6aKV9/RxCMdzUF8/f6pi+aG39bpY1+7cndPuSCOl6B3dpHLgycLonJG7c5epS91vBt43dJzj9FC9Pp0mXgdVL3eLvN/0d2/vQQsQrjGn6GN74EWRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ty3iyb7ysdUdXREqGt3lEO8MZE9V17oRppxSu6bkFZw=;
 b=X9ImSQ2uoHF17dZituzu15pm2m8yMm67Sr9v07NrZBSlzIUN71zHybXJD99m3Ds3oXVdHV7b32DrHn86607SEhOhGRwB/23ivv+8RMJFcbNosWr55YLq+lq674TX+zSI2s2AZL6k/Nn2MAMOrDLrAv6TebTiMrcigumtRrXVAmnouQmgvTSzZlZ41eBMe3tmMHuI58YWKYfq0qgthC2IhBmKc12IWL+OUoU7+v4FY9AlQauZOD3F+tt/7xRq4k8VFacA3/QgGmJrsap531ym2yfLdBSQHP4ig91sgEsfiO+AlPwstadrNv8eL6L9dVR/W78nu11eUHA6oe34LCLOHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ty3iyb7ysdUdXREqGt3lEO8MZE9V17oRppxSu6bkFZw=;
 b=qKI8fZhrX35AT/NDcPyUlMt7aUP6L+k8WebdLD6JmOE49rQ6EZfr4fQkbiH6gwYjeZAgeysSdRt53hdIMyYZ+L8vryXBok9f2hTrauwvo/cFKBMJQJ9Mj5XDCKWcRZiPN2/LFHjTO2E6lAWU0w7nVM2noNt86RhNPAIohJpvYlw=
Received: from MN2PR11MB3662.namprd11.prod.outlook.com (2603:10b6:208:ee::11)
 by MN2PR11MB3872.namprd11.prod.outlook.com (2603:10b6:208:13f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Sat, 30 Jan
 2021 22:10:53 +0000
Received: from MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::20a8:8a27:a512:d584]) by MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::20a8:8a27:a512:d584%2]) with mapi id 15.20.3805.021; Sat, 30 Jan 2021
 22:10:52 +0000
From:   <Bryan.Whitehead@microchip.com>
To:     <thesven73@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <rtgbnm@gmail.com>, <sbauer@blackbox.su>,
        <tharvey@gateworks.com>, <anders@ronningen.priv.no>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v1 1/6] lan743x: boost performance on cpu archs
 w/o dma cache snooping
Thread-Topic: [PATCH net-next v1 1/6] lan743x: boost performance on cpu archs
 w/o dma cache snooping
Thread-Index: AQHW9nhZ9Oyfuu5RykWLFArUFkjuH6pAvJmw
Date:   Sat, 30 Jan 2021 22:10:52 +0000
Message-ID: <MN2PR11MB3662C6C13B2D549E339D7DD1FAB89@MN2PR11MB3662.namprd11.prod.outlook.com>
References: <20210129195240.31871-1-TheSven73@gmail.com>
 <20210129195240.31871-2-TheSven73@gmail.com>
In-Reply-To: <20210129195240.31871-2-TheSven73@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c69df01-720d-479f-5a41-08d8c56be8ca
x-ms-traffictypediagnostic: MN2PR11MB3872:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB38721F5033C936B812C5FDE3FAB89@MN2PR11MB3872.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dQf9CAlxKoHyVgxWCkaivPKdGm9aVNfAyH6LQParKtWC1XPCgMK+1S60iGcao5NKjUzaaev5IksTJESGhBghucaGP8NaWT0WwBY4Am0uc0mBxR5zlPzVAi+47yxrVRwSgM6F/94pn85D+zASpe+Xt2sJ3FyLgLloF6NaKAtIUyLSnx9qQnxT/w97OZFnZvgR8gPNuTQ3UXPQFBlpEd+UcgAhegVQJRfHXE0l7Kf0IqFMhogXpVyHS6z6D8w2hUmkS6MQK0xRtKmwsHfli2Y2Kj+Xay9iY7+UuSiLwb1YobKL0y3ppw5qDOJXcLc13DjGICtXHy9NBKDWFRTdCklpFRIJxxV6xRkDB4wEVJd+VtyqBGGKBBz/gSCnUaaoXA2psS61cGTjNtUij+qNjBBl+SjBq4H+oM+JRjCescFEvhIsEuMcFcbngD/teCq/gf+iG8JLHbbzr4MRZG9BWswL0cH9yhB3r2PNiqQ/BRzjeUujhNwBm8wBz9fsRUtk3+TBq/x7Lln9od9UShmyfj3uUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3662.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39850400004)(366004)(396003)(376002)(6506007)(26005)(8676002)(186003)(83380400001)(86362001)(4326008)(2906002)(7696005)(7416002)(33656002)(478600001)(110136005)(76116006)(55016002)(8936002)(66556008)(64756008)(66446008)(52536014)(66946007)(5660300002)(9686003)(66476007)(71200400001)(54906003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Ny8yVzRZQ3AydU1GNURyOHNLdEk5dHkrRTMwcFV2bjR3TUsrUFREcEpOL09X?=
 =?utf-8?B?RU9nYlo3UTlUR2dxWmRPVEtOTm9PY0ZpdGhKL1FmeDJaRU5IZVN6VVNERnJW?=
 =?utf-8?B?cnBGbWxWNXoydS8wR05yclJTVndrb2VkUkoreXVxV1FTUTZETWNEckV4MDh2?=
 =?utf-8?B?RFo0ZS9Xak5pL0o5dVRac04vMmJ0N3FWNE5hdVNncDZjQVh3NmtTbnJuMkhG?=
 =?utf-8?B?L25xU1JHbW16TDA1c2NoSVdSTTVXMnVXWnM2WTljcnpOTlhhc3IrRWlDb0lj?=
 =?utf-8?B?VjQ0WWFKMFl4MUlsdkVpR21Qc1hYZG1vem5vNE5vVnluZ0gxUjlyMGJOUXNM?=
 =?utf-8?B?S2FibngvTWUzNmsxdkhXdVN3N1hRekQwU05Ec29ESXZDOTZXNC94blZjRGtX?=
 =?utf-8?B?MHdKMnllRU1KdTgydGFMYjNKdVdSTnhDUklTM1Y2MVc3cWlGNU1nMFZuMUFN?=
 =?utf-8?B?dytqM2RuZTl1S1UzTDBaQlplMnB3cVJ3dXhuamlnOVBOT2psdWJBdG9BMjFE?=
 =?utf-8?B?ZWdyOUVNZ1ZRa1RyUnhzN1Z5VEJGalNTTms2eE0vSTlQY1ZSbG90RTgyQjRB?=
 =?utf-8?B?WVZwOUVRWHZvY1E3eTYvZlRCOS9IQkg4QmlZSlRucUNsNlRrK2toTloxM2dP?=
 =?utf-8?B?eWIvQUZMNGVjU1VGTUJTYVlxdG9JWjN6MW9JL2N1bDNCcDZsYVNFVnA4N1Bx?=
 =?utf-8?B?OUhxZ3JYWUJoQzV3c0J2OTUvdFNLYTVJMEI3UlRSNERLbnZsMStWRDdaM0tT?=
 =?utf-8?B?KysyQkVwTjJUdDd3Mkd4b1ZMQmRjMWg2dlorcCtXNU1DY1ArWml4aUVqTzFM?=
 =?utf-8?B?aTZnQitvT3I0NzdTTXZyYnF0b2l2TXpaY1cxaWFvOVlhRElpNTZlTFB5a2FZ?=
 =?utf-8?B?ZkpQUkxsY1FNMndZUXJtUUd5ZnQ2ZFFFWU5pcWRPTVFEZ3QzSWk1QWN6b2tZ?=
 =?utf-8?B?cnZrcy9XMCtKZWlYWHY1RElyY1k2UklJT1FvWW9weVFZNVhMcmlabUhDK3Ay?=
 =?utf-8?B?NU5YVVBKS0NiVVZUM0k0RFZUVWpZQlB0aUpVLzBMMVpSUDM1VStsYzl0bWVm?=
 =?utf-8?B?OTltZ3JPZngyTkczWlhhd2llTG55Ym0zTldhQytBWEFvNllHTjBabWVWWUhP?=
 =?utf-8?B?d0o2WWp4YTNqY0lJQTZUVjU0OUlhRlBOZzZic044dzVCaXNESXJxVkFkdGRj?=
 =?utf-8?B?akJpTDBnV1NSaGxBMDJRZnc0YXZCYzdmOGhtTWl0YVRmNWF3c0wrVjVqOHk0?=
 =?utf-8?B?bldOQm8zZ3NMZG5TVGczTW1ra2x0KzAxckM0b3BNR2tNci81ODg4WnMyNkJ5?=
 =?utf-8?B?amlGMHJBMnUyQ2dvY3JpQlFwMWh0KzJQbmp3TGxldHQ0dXgvUUFtUGhOZXRN?=
 =?utf-8?B?cHRzTHZYSks3OTAvQlpScnIvNmhpYUQ2aDNXdlAwRHpwTG5uTkhOQjhJRGRC?=
 =?utf-8?Q?ZDGnYdSq?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3662.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c69df01-720d-479f-5a41-08d8c56be8ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2021 22:10:52.8034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TAaIZwR0QpS1xBup8iXpM03/Wz29E47H3vYMr+4/wzf0EI6lwLpRmbjOrzewzB6c+M4s7LtwPjZxAwicFCPc8fmR4dTzmsFsYPGng+PgdEU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3872
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U3Zlbiwgc2VlIGJlbG93IGNvbW1lbnRzDQoNCj4gQEAgLTIxNDgsMTEgKzIxNDksMTggQEAgc3Rh
dGljIGludCBsYW43NDN4X3J4X3Byb2Nlc3NfcGFja2V0KHN0cnVjdA0KPiBsYW43NDN4X3J4ICpy
eCkNCj4gICAgICAgICAgICAgICAgICAgICAgICAgZGVzY3JpcHRvciA9ICZyeC0+cmluZ19jcHVf
cHRyW2ZpcnN0X2luZGV4XTsNCj4gDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIC8qIHVubWFw
IGZyb20gZG1hICovDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHBhY2tldF9sZW5ndGggPSBS
WF9ERVNDX0RBVEEwX0ZSQU1FX0xFTkdUSF9HRVRfDQo+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAoZGVzY3JpcHRvci0+ZGF0YTApOw0KSXQgYXBwZWFycyB5b3UgbW92
ZWQgdGhpcyBwYWNrZXRfbGVuZ3RoIGFzc2lnbm1lbnQgZnJvbSBqdXN0IGJlbG93IHRoZSBmb2xs
b3dpbmcgaWYgYmxvY2ssIGhvd2V2ZXIgIHlvdSBsZWZ0IG91dCB0aGUgbGUzMl90b19jcHUuU2Vl
IG5leHQgY29tbWVudA0KDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChidWZmZXJfaW5m
by0+ZG1hX3B0cikgew0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRtYV91bm1h
cF9zaW5nbGUoJnJ4LT5hZGFwdGVyLT5wZGV2LT5kZXYsDQo+IC0gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBidWZmZXJfaW5mby0+ZG1hX3B0ciwNCj4gLSAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJ1ZmZlcl9pbmZv
LT5idWZmZXJfbGVuZ3RoLA0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgRE1BX0ZST01fREVWSUNFKTsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBkbWFfc3luY19zaW5nbGVfZm9yX2NwdSgmcngtPmFkYXB0ZXItPnBkZXYtPmRldiwN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBidWZmZXJfaW5mby0+ZG1hX3B0ciwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBwYWNrZXRfbGVuZ3RoLA0KPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIERNQV9GUk9NX0RFVklD
RSk7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZG1hX3VubWFwX3NpbmdsZV9h
dHRycygmcngtPmFkYXB0ZXItPnBkZXYtPmRldiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJ1ZmZlcl9pbmZvLT5kbWFfcHRyLA0KPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYnVm
ZmVyX2luZm8tPmJ1ZmZlcl9sZW5ndGgsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBETUFfRlJPTV9ERVZJQ0UsDQo+ICsNCj4gKyBETUFf
QVRUUl9TS0lQX0NQVV9TWU5DKTsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBi
dWZmZXJfaW5mby0+ZG1hX3B0ciA9IDA7DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgYnVmZmVyX2luZm8tPmJ1ZmZlcl9sZW5ndGggPSAwOw0KPiAgICAgICAgICAgICAgICAgICAg
ICAgICB9DQpKdXN0IGJlbG93IGhlcmUgaXMgdGhlIGZvbGxvd2luZyBsaW5lDQoJCXBhY2tldF9s
ZW5ndGggPSBSWF9ERVNDX0RBVEEwX0ZSQU1FX0xFTkdUSF9HRVRfDQoJCQkJKGxlMzJfdG9fY3B1
KGRlc2NyaXB0b3ItPmRhdGEwKSk7DQpUaGlzIGxpbmUgd2FzIG1vdmVkIGFib3ZlIHRoZSBwcmV2
aW91cyBpZiBibG9jaywgYnV0IHRoZSBsZTMyX3RvX2NwdSB3YXMgcmVtb3ZlZC4gSXMgdGhhdCBp
bnRlbnRpb25hbD8NCkFsc28gSSBkb24ndCBzZWUgYW55IG1lbnRpb24gb2YgdGhpcyBwYWNrZXRf
bGVuZ3RoIGFzc2lnbm1lbnQgKGFmdGVyIHRoZSBpZiBibG9jaykgYmVpbmcgcmVtb3ZlZC4NClNp
bmNlIHBhY2tldF9sZW5ndGggYWxyZWFkeSBjb250YWlucyB0aGlzIHZhbHVlLCBpdCBzZWVtcyB1
bm5lY2Vzc2FyeSB0byBrZWVwIHRoaXMgYXNzaWdubWVudC4NCg0KPiBAQCAtMjE2Nyw4ICsyMTc1
LDggQEAgc3RhdGljIGludCBsYW43NDN4X3J4X3Byb2Nlc3NfcGFja2V0KHN0cnVjdA0KPiBsYW43
NDN4X3J4ICpyeCkNCj4gICAgICAgICAgICAgICAgICAgICAgICAgaW50IGluZGV4ID0gZmlyc3Rf
aW5kZXg7DQo+IA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAvKiBtdWx0aSBidWZmZXIgcGFj
a2V0IG5vdCBzdXBwb3J0ZWQgKi8NCj4gLSAgICAgICAgICAgICAgICAgICAgICAgLyogdGhpcyBz
aG91bGQgbm90IGhhcHBlbiBzaW5jZQ0KPiAtICAgICAgICAgICAgICAgICAgICAgICAgKiBidWZm
ZXJzIGFyZSBhbGxvY2F0ZWQgdG8gYmUgYXQgbGVhc3QganVtYm8gc2l6ZQ0KPiArICAgICAgICAg
ICAgICAgICAgICAgICAvKiB0aGlzIHNob3VsZCBub3QgaGFwcGVuIHNpbmNlIGJ1ZmZlcnMgYXJl
IGFsbG9jYXRlZA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgKiB0byBiZSBhdCBsZWFzdCB0
aGUgbXR1IHNpemUgY29uZmlndXJlZCBpbiB0aGUgbWFjLg0KPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgKi8NCj4gDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIC8qIGNsZWFuIHVwIGJ1ZmZl
cnMgKi8gQEAgLTI2MjgsNiArMjYzNiw5IEBAIHN0YXRpYyBpbnQNCj4gbGFuNzQzeF9uZXRkZXZf
Y2hhbmdlX210dShzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2LCBpbnQgbmV3X210dSkNCj4gICAg
ICAgICBzdHJ1Y3QgbGFuNzQzeF9hZGFwdGVyICphZGFwdGVyID0gbmV0ZGV2X3ByaXYobmV0ZGV2
KTsNCj4gICAgICAgICBpbnQgcmV0ID0gMDsNCj4gDQo+ICsgICAgICAgaWYgKG5ldGlmX3J1bm5p
bmcobmV0ZGV2KSkNCj4gKyAgICAgICAgICAgICAgIHJldHVybiAtRUJVU1k7DQo+ICsNCj4gICAg
ICAgICByZXQgPSBsYW43NDN4X21hY19zZXRfbXR1KGFkYXB0ZXIsIG5ld19tdHUpOw0KPiAgICAg
ICAgIGlmICghcmV0KQ0KPiAgICAgICAgICAgICAgICAgbmV0ZGV2LT5tdHUgPSBuZXdfbXR1Ow0K
PiAtLQ0KPiAyLjE3LjENCg0K
