Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986FA322654
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 08:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhBWHTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 02:19:07 -0500
Received: from mail-eopbgr70084.outbound.protection.outlook.com ([40.107.7.84]:58342
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231864AbhBWHS1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 02:18:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rivsf3gCunJ+XXElfz0yA5dgnPyjZW25EP76+URARRePBQqAFO2g6GkbCtPkAERIqtBw7SsIMa8dK14wgjahmu2VnFj0isIhsOutQaIhIjbwV9WMb01EI7zy7v+yJztstOjDeiaJEZava4mW2RxrvwzovDWXxXsbXFUmAkzjOO57mDHzUNhVoKCo2Eqni5lugP7iLzBr2vWtyDk9t7fUfuwHx16fzdcJgqhINMv7ygSYRQEJvqA9YM7uK3ZmpQX76HCd9Qb4aDjskh8dEJr1qQrZzvsH/eaNEGpiFd8hfiSBk0e/c7ujGJbM0j0G8Enoo46WSio2WgfjU5ptrSwuZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=viI6JxouH7Qj3i2/MvyRs0JA4R84O7zN9IAclVxI3h8=;
 b=EdYGZ3fqyMeJO2/k+x4k1OFZ74vPXWlWEEY1lV8QncIDBl2qA6i+hewgAW6Ywch0C+LZL0nw4tui//43CZMwxqgAQ0mdR9wxZDi7Szi01HbxNhn/T4GBNgeTD63ZzDGDnF8xpCaGCI9nVVdvoqC1u5Xo4hZleLdWTxN9YhhwS2F0msMJ2Rmjy08y0JfZFy5KmsfvcAsqp94mSzxY7yjRRpEWvkTi9OlAC6F6xRoWL97qaU4+QUk7I5Arqq9QaL5o+nKEzyA2yD0fg7qrSzdyrdZt+Og7/+45gKJVHOGHQqxGFUdgwZykw8iCbUnNEPv0cpZSx411EbHyWRtu9HLpXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=viI6JxouH7Qj3i2/MvyRs0JA4R84O7zN9IAclVxI3h8=;
 b=c0JKKF0G9sIXQ/eCLFlcuOE3Ccb+8iaaCfM0g3I41+znn1i0n9tHaps+RIQyn3/Jv3UtnQUZ9W8/BFYZT/lFj9u1b9/oEKc4jzuAazw+XTrcOSzyXRNRUyUPswYgJ2W9KOa+Bl8612zhtBj8nXBdj08Qqxq71lM9lnheQD2QzhY=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7994.eurprd04.prod.outlook.com (2603:10a6:10:1ea::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Tue, 23 Feb
 2021 07:16:52 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Tue, 23 Feb 2021
 07:16:52 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V4 net 5/5] net: stmmac: re-init rx buffers when mac
 resume back
Thread-Topic: [PATCH V4 net 5/5] net: stmmac: re-init rx buffers when mac
 resume back
Thread-Index: AQHW+ufw6MNhK2q+g0+ufguVFACpL6pLmiyAgBUoM+CAA+71gIAAv3Jg
Date:   Tue, 23 Feb 2021 07:16:52 +0000
Message-ID: <DB8PR04MB679598EB6F86026DAB6FCE16E6809@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210204112144.24163-1-qiangqing.zhang@nxp.com>
        <20210204112144.24163-6-qiangqing.zhang@nxp.com>
        <20210206123815.213b27ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DB8PR04MB67953DBABBB9B1B85759AE58E6839@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210222114737.740469eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210222114737.740469eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 64508784-6e31-4e14-bc46-08d8d7cafea0
x-ms-traffictypediagnostic: DBBPR04MB7994:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB799494B06701698325D6104CE6809@DBBPR04MB7994.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x3SZ3r4hkHHJ0BFG75bc4x5uNa+L4frBUSPirxdUkU2N80Iy/1C020fW0S1G6wO4G6FF7nlP83TXGtgKad5Q+3pmpVGD1dk5OR6JcbkfJQwJShvliKblPtNBp0ygHkJ1tDKCQFZmViF0HZX7ONz32jkKUPb/p9UQ7h0dtfdYcd2Eo1xutPRYNjbuq0X16iGkuT4haA/J7T9+vXp1fE05U/gy4loCbjwPO669q3jgRxw9gZwxt6/n9Ld5XjxbHfuDcRgWBnDXYTVGEETU1u7LccNJN3Hcetka9LNGuGirQ6bFf/lBKT6eQcEMdzBtGTUfPol3g7GkSZWNmNRworkIN2pepivdDiFKrP2Tuv5sz/2j2fAzZMpmb2EDqPTpn0TTPKB6eIZ8JIUg2DtKPHBJwmSZSMO7I4ja2C/TvSDYndOcJpmehtS9qBuYrzqrJ17NBEdLEed5vlt06P2KtSkslwiL4ahAXGUj1hXOc94pl0i29L9JNpu1PPLzBYx5wA87BRPkw3F4HWS5KC18yqqLcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(396003)(376002)(366004)(316002)(8936002)(53546011)(7696005)(5660300002)(55016002)(33656002)(2906002)(478600001)(86362001)(186003)(6506007)(9686003)(54906003)(71200400001)(6916009)(66476007)(52536014)(64756008)(76116006)(83380400001)(66556008)(66446008)(4326008)(8676002)(66946007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?T3hreXF1MXpXVEpYS0JwN3pHdGh4MnlObU81UXlsOXFWRDBqSVBqbVVPQ09S?=
 =?gb2312?B?ZlpkYmx4enlaUjZzRnNNaFUyWHdObE03K1dzV0Izai9SeXpPUCtRaUtDL3Z4?=
 =?gb2312?B?YmVZREpqdU4rVVNNRURyTkkxSWtTQjM0eGJkRXQ1V0UzcG9ZUlhKNWlGQ0hz?=
 =?gb2312?B?SHcyRUtYTE5mWHkzbnRET2h4QXBEdGpTM09QdDNoYitiZUM4V2orRXRkTi9G?=
 =?gb2312?B?Q3I1TmVQQVM4OXhYK1Ziajl6OHZKbU52UEFWYi9GQU1ZZFQ5UVBFUVhnbWVp?=
 =?gb2312?B?b084QWJrRk54SWhNbU5LYllnY3dma1NjVXFTR3MvZEg4N00zSCthYno1VDc0?=
 =?gb2312?B?SzlsZ1RSYVdUM3R5R1RxNTVtc1pGeFlTNWNKZVYzSms2aHkzVm15bk5UdVB0?=
 =?gb2312?B?QkFxcTZsZWVQMWptYkUzdzF3eVIyVDdId3N1ejYxNG5FLzRjWTk4UmpxbmZm?=
 =?gb2312?B?TFI1ZnlWQkFqUysxQ3U0ZXY5ayt5UXpPSWxTWHVxc1ZHWStzM3ZWZFFnRWh3?=
 =?gb2312?B?dGt4OHZ4NXY1cFpuQktSR3JoQS96c0N2My9aZVlxb0pYTUpmQ0lHRldjSG9B?=
 =?gb2312?B?ZlRFK1pnbmZBOS9BeDRpbjdFRVNDM2ZlYnU0VkVtOFVwc2NZOGhtTUdhVkFC?=
 =?gb2312?B?UHVoK3crdC8vc2VvemZSNUZYaG1TK1l1czVIYWV4KzZnQ2h5cTFrUmd4V0Vl?=
 =?gb2312?B?Z2ZEOXBSTGFlelR5MU5LdHg0VVBib3BwOUZhdWV0cUdRNlIraHZPREtlVzMv?=
 =?gb2312?B?YWxBeUpoM3pJUExvUHBIWTVieWRMNEJqU2VXaUpHcndxZDNVNlhoV0NuQnVG?=
 =?gb2312?B?MnZvRXdZYVBUYnErNWdrYjZINUtlWEZMRTRGSkdKNFNIS3BIK08xZjZZWko0?=
 =?gb2312?B?UmQ3a1JEeU8rQUppNkZrOUxFOExUaTA0YkM4YlpPY3A3dXFMM3luWCt5NEJy?=
 =?gb2312?B?Y09pdHJCTVg2YS81ajV0MUt5NkZUUE1jZGsvM08rb2dwYWVNU3FHN3kyT0Y0?=
 =?gb2312?B?alJSOXdLMWtkSXFla2VqaXp4RjVVbG9tRkR5TFRvNkZRUllZeUhSdmRjeXlj?=
 =?gb2312?B?ZTFQWjlTVnRIK1l4ZTZsTG5wS0FtUHFDdmIvK1lwK2VtYXVLQ085THczMGl3?=
 =?gb2312?B?eVAvSjErZFZSRWRuUlgzVmt5eWJPWkM0YThwajViYmdJQmNkY3ZCeldKcFVr?=
 =?gb2312?B?VFgwQVBuaUg1VEV2MmNDS3hCNmwrZFRweHJtSXNGKzJ0cm5sOGVkOGkzOXk1?=
 =?gb2312?B?OXNhaWtTL0g2YjEzTldWcUhkRzk3NWxvVEZacktmMVpHWCsyNEJQbmVTTElo?=
 =?gb2312?B?SlNud1BhQk0zdWJsREx5cmR1SUtwZ3NSbnRUbWthdk9xYk0xWWNaRUVjRmFK?=
 =?gb2312?B?RGdoMHNSQloxZXErWTQ4bDg4Rk1MWUkyYnhjNGRHUVJ0UTAwR3JHa1dwWklX?=
 =?gb2312?B?WityWDFSdjFpQ0pzaWVlc1Z5YTVKZmZVc2lUcjRjMmgrWEpQYVA3NzQ1ZTZv?=
 =?gb2312?B?dE54ek51SlFwR3N2QXVKWGNQdnBUVFVVNmhmaGVlYTJGcllrakhvK2wza3VY?=
 =?gb2312?B?NUlXS3lJUXJpMkdlT1R0REdBejhsSVQ1a3FtUGdKclE0akFwUzByejB3aytD?=
 =?gb2312?B?VUhub2lLMGFpYXZHSGVQMFRnNmM4eVlia2Z2MXl4L05DQTRFdUp6czNYRm4v?=
 =?gb2312?B?eXJXRS9hSUZDcWVIZ21DakthQW1vaElYN091OTBJU1p1WHU3UVdMQXVPdnht?=
 =?gb2312?Q?8DZoVslpJznZLqqlTeaV2BheWlDi16L54M1qVq2?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64508784-6e31-4e14-bc46-08d8d7cafea0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 07:16:52.7251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FFVAT0A5clwF4j28mdLwp0FnJF9ebfdIGaG4BDb5I8QxMHK4Mm3g2nw5eF/KQGHkOBbBM0MPlBG5FkJQIhi/fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7994
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IDIwMjHE6jLUwjIzyNUgMzo0OA0KPiBUbzogSm9ha2lt
IFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IHBlcHBlLmNhdmFsbGFyb0Bz
dC5jb207IGFsZXhhbmRyZS50b3JndWVAc3QuY29tOw0KPiBqb2FicmV1QHN5bm9wc3lzLmNvbTsg
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gZGwtbGludXgt
aW14IDxsaW51eC1pbXhAbnhwLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBWNCBuZXQgNS81
XSBuZXQ6IHN0bW1hYzogcmUtaW5pdCByeCBidWZmZXJzIHdoZW4gbWFjDQo+IHJlc3VtZSBiYWNr
DQo+IA0KPiBPbiBTYXQsIDIwIEZlYiAyMDIxIDA3OjUyOjQ2ICswMDAwIEpvYWtpbSBaaGFuZyB3
cm90ZToNCj4gPiA+IEknbSBub3Qgc3VyZSB3aHkgeW91IHJlY3ljbGUgYW5kIHJlYWxsb2NhdGUg
ZXZlcnkgYnVmZmVyLiBJc24ndCBpdA0KPiA+ID4gZW5vdWdoIHRvIHJlaW5pdGlhbGl6ZSB0aGUg
ZGVzY3JpcHRvcnMgd2l0aCB0aGUgYnVmZmVycyB3aGljaCBhcmUgYWxyZWFkeQ0KPiBhbGxvY2F0
ZWQ/DQo+ID4NCj4gPiBBcyBJIGtub3csIHRoZSByZWNlaXZlIGJ1ZmZlciBhZGRyZXNzIGlzIG5v
dCBmaXhlZCBhZnRlciBhbGxvY2F0ZWQsIGl0DQo+ID4gd2lsbCByZWN5Y2xlIGFuZCByZS1hbGxv
Y2F0ZSBpbiBzdG1tYWNfcngoKSwgd2hlcmUgdG8gaGFuZGxlIHRoZQ0KPiA+IHJlY2VpdmUgYnVm
ZmVycy4NCj4gDQo+IE5vdCBzdXJlIHdoYXQgeW91IG1lYW4gYnkgdGhhdC4gVGhlIGRyaXZlciBt
dXN0IGtub3cgdGhlIGFkZHJlc3NlcyBvZiB0aGUNCj4gbWVtb3J5IGl0IGFsbG9jYXRlZCBhbmQg
aGFuZGVkIG92ZXIgdG8gdGhlIGRldmljZS4NCg0KV2hhdCBJIG1lYW4gaXMgdGhhdCwgaW4gc3Rt
bWFjIGRyaXZlciwgaXQgY3JlYXRlcyBhIHBhZ2UgcG9vbCBmb3IgcnggcGF0Y2gsIGl0IHdpbGwg
YWx3YXlzIHJlY3ljbGUgYW5kIHJlLWFsbG9jYXRlIHBhZ2VzIHRvIGZpbGwgZGVzY3JpcHRvcnMn
IGRtYSBhZGRyZXNzLg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gPiBJdCBzaG91
bGQgYmUgZW5vdWdoIHRvIHJlLWluaXRpYWxpemUgdGhlIGRlc2NyaXB0b3JzIHdpdGggdGhlIGJ1
ZmZlcnMNCj4gPiBpZiBpdCBpcyBwb3NzaWJsZS4gQ291bGQgeW91IHBvaW50IG1lIGhvdyB0byBk
byBpdD8NCg0K
