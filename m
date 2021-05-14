Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9801B3803B7
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 08:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbhENGmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 02:42:42 -0400
Received: from mail-eopbgr60062.outbound.protection.outlook.com ([40.107.6.62]:4280
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232525AbhENGml (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 02:42:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgOHtPp2MovE/OqvSanqgLoYeje0rJZvDUBAlcs0TOSHj6R4FH/7oCrC9NVTh9FqC1DIU9+vq4b0gRpZpL2qKUmM392Bm5TUxhd038c4U7t0W2fDn7zmz+J7x6IqBRCCx4bXGsA/so7800L8xCIMDL/liQGKT3Vz6jgafI+qdw58mEbyLUvU02Up0RET2hsNa80Hui7O4Tmr4NXoZN7KssMtMTwQ4pgcwCgh+SsuE4dcNf4QK2y3vAZSAyCaVqyV2adVUHbbzu1OwEvAu/OSqUsFddZXMWuL2wLQdEHJtygO5/AfQ+8nOQfJwnlvbT/uCQcvCnkqCn6k6Q3qbsTm8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LH1jiNcxJu6D0cVMy5IggCCBQ3QbWaE4eQjM7OlATu0=;
 b=R1UUqapKJy/KeAzgOUapKsLDGhro/txGUBkM0S72dxJHUjpqCF0ahFDGcYSL5YQBMiS+3S7wovXGiExgwUEEvZGCGmEBTP2+QxZwXErQKsA8y/rxHwyMQToL6OJPlbjfu5Q4siuZL98rxM1i2ZodpAjUVoDFh21OjhJ8hdfL02k80zoO0rxYIPxmSM+mEdVN8XoFmzq5GCoOkzXhkMr6+mXneZY4R4mJPdhtkOmWWlw6kM0hjlAbR6OmtvyLGAfiBAEGN6VHywaKlEYj8EEOUpayiJPO0qWFx5RZXs4nOJhoahLR95fqJebAyhAwQkYYfuBuQXc6lsw3gJnYHKaYUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LH1jiNcxJu6D0cVMy5IggCCBQ3QbWaE4eQjM7OlATu0=;
 b=Z1xB6tKSxkRrr5/ayzyB4JHWgQhWLopELiFtNy0mu9LTMR00iOoQEPzr2QD+tmpC+a3+NE6yJKMWq5Q5dyL7BA9hBd5Ewy7sr9K8oyI2TKQw2F3WPrjjKJXg2OmkgQBRAF41owQCAyJm6TNakkAGbhufolENFPFPEZvAf8UAbwI=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DB8PR04MB5931.eurprd04.prod.outlook.com (2603:10a6:10:ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 06:41:28 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::854e:3ceb:76a4:21fc]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::854e:3ceb:76a4:21fc%6]) with mapi id 15.20.4129.028; Fri, 14 May 2021
 06:41:28 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [net-next 0/6] ptp: support virtual clocks for multiple domains
Thread-Topic: [net-next 0/6] ptp: support virtual clocks for multiple domains
Thread-Index: AQHXQx2n9odSkzWl/E2JdNuSb7aRparZ90oAgAIIfCCAAV+UAIAAqM9QgABsJgCAAq33AA==
Date:   Fri, 14 May 2021 06:41:28 +0000
Message-ID: <DB7PR04MB5017D35C76AAEDEE0319DA12F8509@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210507085756.20427-1-yangbo.lu@nxp.com>
 <20210508191718.GC13867@hoboy.vegasvil.org>
 <DB7PR04MB50172689502A71C4F2D08890F8549@DB7PR04MB5017.eurprd04.prod.outlook.com>
 <20210510231832.GA28585@hoboy.vegasvil.org>
 <DB7PR04MB501793F21441B465A45E0699F8539@DB7PR04MB5017.eurprd04.prod.outlook.com>
 <20210511154948.GB23757@hoboy.vegasvil.org>
In-Reply-To: <20210511154948.GB23757@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43bee243-e8e9-4e9f-6aa0-08d916a34daa
x-ms-traffictypediagnostic: DB8PR04MB5931:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB5931EFA2F1C503ADDB9DE399F8509@DB8PR04MB5931.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ISl9hp64NyvXvgePEYHpYSBk1R7V8+BSYBiT7+zehNLc0NVUVotLQ8Gk0xJWXPAlAg3OJvDCzHDk5Jr+enuvfLwappe8J0vh+T0GVxethYEjilgs70msoZQF/oZC9Fq2N4KYjEhydCWtv4lXcAKGeYZLF2WwHLSogCmHbcuHBBEOP0p5BWQ8XwuGOEok+FG30rtxXffw17WHVMIxJTMxlPA3rCRohr8eAuNDRmNXpfBai+siKo3skN7+HXvvkyhXRPGufl0GzwGddc3Ik43auSixAjrKZkOOkj9hyckDYd9GWcBkk2l75b8NXo7p0xN1zeo81sneVT+/jab1YB7n+YL5sUh/VCl6VuUqSPnkHrmAZ2BL+PMBjfnhFMcxBpmLycumNudNBEQSqEIHyg6sDEqcsVmX97uerXLqYxf4GFu69EnA+QqT70SuzrrRSNdKXAhc5VDZjzkuyU6XgRv35uA4EFSnmD6PJERGuee8wV5zTb9lbhTmXdsAuJS2DfCE5tcrsxNmrSDRtVm7lZqSWbn2l8r0iPijDc1rWJcua7PlJgzYa4C5D5W8qk86J4+nP+rlgdwgwbT+byieajc82zQ0oJ7LDwSpYKqDHDOhbCE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(9686003)(55016002)(33656002)(83380400001)(4326008)(71200400001)(6916009)(478600001)(2906002)(53546011)(38100700002)(122000001)(316002)(186003)(66476007)(64756008)(8936002)(8676002)(26005)(54906003)(5660300002)(6506007)(86362001)(66946007)(66446008)(76116006)(52536014)(7696005)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?b3EweGJuM2YwSU1xd3g0ekFMSTNhZkFKQW0weUhwREEzQVlnKzNERXY1UDBH?=
 =?gb2312?B?KzM3YzJ0Y3BBdXVPN1Z5R3hqeEFaMFFnTldya2JkSkMxVnR0eGtVVG9TWUM4?=
 =?gb2312?B?U2JybitURWVUYUQ3S3NTVWl1cFFmRE1LL1JzQzZiQWxkZWpRbnE2SkdZWUpj?=
 =?gb2312?B?VFV3WW1EL1lzdnphUFdQYXEvcjk3TjY5T1pqTVFSM1hsa1htS3RsWmhwS0li?=
 =?gb2312?B?eVAycWlTbDZ0dXRLYVJBRFZ2TkJVYks2dFQxaWppcTRrWlkyRjRVWDNiVmRk?=
 =?gb2312?B?ZFF1U1FVZ1YxZlZDZUNUbSs4YThWSWk4R1hvYmN0bnJ2MGQ1dHlFMCtKbWpI?=
 =?gb2312?B?ekFrVEdaaEM2VEM5M2hPWGhBVExER2JjNjNWWEZWWGNmREVzVkdhSzVYS2lX?=
 =?gb2312?B?WG1HUy9IUGljZmVMcytlRktkV084UVlCWUN1RGs0VU10Y0ttSFFTM3RXb29k?=
 =?gb2312?B?aWsyNE5iQUtHZlFmUEMrWHFYaS8wazNLTE8zaXk2UUI4Uk1icE56Njc1Rmly?=
 =?gb2312?B?aE9nNG9EVUJSYy9GMHlqZkhURzFma1I2aWQ1MFdnajJ3dmt0bCtOSWxHNEk5?=
 =?gb2312?B?ZWFndTRRa2tMVXBWMGNkS05xazZ3MUdsTGNpb1VKYWhGck4zbGU4QXBWZThI?=
 =?gb2312?B?MHFnazJlaEtEY2lCVTlMeFRjT0FZZDdLM1FyVjd0TnE4QUM2am1RdDZiTjBF?=
 =?gb2312?B?RUhta1dGNnJGTHlTZ3hpVFdnM21OaU11aEJ2VXEvQVNxemlBaGxCSU9ySmNo?=
 =?gb2312?B?c0tpS2UxcjhJQW0waFQyTVVrY1I2OEZxbzVqVTA3OEc3QnhGZGR5cEFyOXVN?=
 =?gb2312?B?dS9JdCtoR0xweEpxSVh3bnZMeUJyZnFHR0lJbWZHd29sTDV3Kyt4ek83S05w?=
 =?gb2312?B?cjRCVG1ZSjNTdTBpSUVyYkpTU0cvZXdNNks5dHRtUVZBdVpkM29SZ2F5VXBs?=
 =?gb2312?B?UHR4ZjJkNkdrcnRCU0VrRHRHVEQ2TGtEYXdNYWxNT0VHQzVycVJCMkxqVjds?=
 =?gb2312?B?UkpzN0pxa29PeUdkb2xmZlE3b2FERTJtTytYZS82SWVGRGpuT0lmaTNJSGNP?=
 =?gb2312?B?OVhUeHZ1NXMwTDVqc1FCRU9qMlhjdE10ay9XODhpdFlQcWpRVFhzaE9ONWI5?=
 =?gb2312?B?cFQ5bXNoaUNDV0ptejVGVm9CYUdGRGduSGVNRm5QUXhVVzR1YzZLQmQrTlJV?=
 =?gb2312?B?TVdhTE94WDBQSmRrUCtVZzhwTFJpYzhJTm45TTluK0sxK3VzeGlGcC9udlds?=
 =?gb2312?B?TjVJUVloWnhDKzFtS1RyWE5XWk91SWZnV0FtRHROSEErZE1zanloaTNoZGs1?=
 =?gb2312?B?Tm9taU4wTS9TRTZYZ3RZSnJsZWhQaUZsQ1F5S2FaOWplRzRSVWozVElmcmJr?=
 =?gb2312?B?Z3hJOGt2Vk1OOW5PbFp1VU8xQ3plcitzTHp5Vm01WFh1VGxQZ254VEFrWEgy?=
 =?gb2312?B?Z0JMR0ZEQS9saXJWWkhkZEtXZGd3Z2I0UlpTcmVHOTduQTdvd2tMSzJqNXJz?=
 =?gb2312?B?cHl3NW1wMVA0bDlSZDRSVzg0TnErVUdSRFRnTTZBUFM4c0haQTdJcXhkT0F3?=
 =?gb2312?B?dWhVTjAwM3M2MEh5U1YvWVdqbHhhdHdtNjdyQjc2UmZnUWdyblJDOWN4MWhl?=
 =?gb2312?B?bkpVektWUDdvQm1aZVA4VFNQK0dESHo0elhsSXZYak40d0JxYWNpMG5ydG1P?=
 =?gb2312?B?V2tGS1ltb3NXMkhDN3R6T01VZzNnVndUakxlOW52NmxYZ1FOL2E5V0FTMits?=
 =?gb2312?Q?hOnHOTYSwbUoPih6E2VdZwU0JEa9+qS852rJSr+?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43bee243-e8e9-4e9f-6aa0-08d916a34daa
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 06:41:28.6531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q5NkbRdAU1zAsCzRHj3cTDgQR+zwx/4WWksc2CYCdMcfKhF5S8cefPNfpEvc50caMyAsbtcjAc8Ucct8MNTTrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5931
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUmljaGFyZCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNo
YXJkIENvY2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqNdTC
MTHI1SAyMzo1MA0KPiBUbzogWS5iLiBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQo+IENjOiBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnOyBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0
PjsgQ2xhdWRpdQ0KPiBNYW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBKYWt1YiBLaWNp
bnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW25ldC1uZXh0IDAvNl0gcHRw
OiBzdXBwb3J0IHZpcnR1YWwgY2xvY2tzIGZvciBtdWx0aXBsZSBkb21haW5zDQo+IA0KPiBPbiBU
dWUsIE1heSAxMSwgMjAyMSBhdCAxMDo0MDoxNUFNICswMDAwLCBZLmIuIEx1IHdyb3RlOg0KPiA+
IFdoYXQgSSB0aG91Z2h0IHdhcyBpbiBjb2RlIHdyaXRpbmcgcmVnaXN0ZXJzIHRvIGFkanVzdCBw
aHlzaWNhbCBjbG9jaw0KPiBmcmVxdWVuY3ksIGFuZCBpbW1lZGlhdGVseSBhZGp1c3Rpbmcgdmly
dHVhbCBjbG9ja3MgaW4gb3Bwb3NpdGUgZGlyZWN0aW9uLg0KPiA+IE1ha2UgdGhlIG9wZXJhdGlv
bnMgYXRvbWljIGJ5IGxvY2tpbmcuIEFzc3VtZSB0aGUgY29kZSBleGVjdXRpb24gaGFzIGENCj4g
REVMQVksIGFuZCB0aGUgZnJlcXVlbmN5IGFkanVzdGVkIGlzIFBQTS4NCj4gPiBUaGVuIHRoZSB0
aW1lIGVycm9yIGFmZmVjdGluZyBvbiB2aXJ0dWFsIGNsb2NrIHdpbGwgYmUgREVMQVkgKiBQUE0u
IEknbSBub3QNCj4gc3VyZSB3aGF0IHRoZSBERUxBWSB2YWx1ZSB3aWxsIGJlIG9uIG90aGVyIHBs
YXRmb3Jtcy4NCj4gPiBKdXN0IGZvciBleGFtcGxlLCBmb3IgMXVzIGRlbGF5LCAxMDAwcHBtIGFk
anVzdG1lbnQgd2lsbCBoYXZlIDFucyB0aW1lDQo+IGVycm9yLg0KPiA+DQo+ID4gQnV0IGluZGVl
ZCwgdGhpcyBhcHByb2FjaCBtYXkgYmUgbm90IGZlYXNpYmxlIGFzIHlvdSBzYWlkLiBFc3BlY2lh
bGx5IGl0IGlzDQo+IGFkanVzdGluZyBjbG9jayBpbiBtYXggZnJlcXVlbmN5LCBhbmQgdGhlcmUg
YXJlIG1hbnkgdmlydHVhbCBjbG9ja3MuDQo+ID4gVGhlIHRpbWUgZXJyb3IgbWF5IGJlIGxhcmdl
IGVub3VnaCB0byBjYXVzZSBpc3N1ZXMuIChJJ20gbm90IHN1cmUNCj4gPiB3aGV0aGVyIEkgdW5k
ZXJzdGFuZCB5b3UgY29ycmVjdGx5LCBzb3JyeS4pDQo+IA0KPiBZb3UgdW5kZXJzdGFuZCBjb3Jy
ZWN0bHkuDQo+IA0KPiA+IFNvLCBhIHF1ZXN0aW9uIGlzLCBmb3IgaGFyZHdhcmUgd2hpY2ggc3Vw
cG9ydHMgb25seSBvbmUgUFRQIGNsb2NrLCBjYW4NCj4gbXVsdGlwbGUgZG9tYWlucyBiZSBzdXBw
b3J0ZWQgd2hlcmUgcGh5c2ljYWwgY2xvY2sgYWxzbyBwYXJ0aWNpcGF0ZXMgaW4NCj4gc3luY2hy
b25pemF0aW9uIG9mIGEgZG9tYWluPw0KPiA+IChCZWNhdXNlIHNvbWV0aW1lIHRoZSBwaHlzaWNh
bCBjbG9jayBpcyByZXF1aXJlZCB0byBiZSBzeW5jaHJvbml6ZWQNCj4gPiBmb3IgVFNOIHVzaW5n
LCBvciBvdGhlciB1c2FnZXMuKSBEbyB5b3UgdGhpbmsgaXQncyBwb3NzaWJsZT8NCj4gDQo+IE5v
LCBpdCB3b24ndCB3b3JrLiAgWW91IGNhbid0IGFkanVzdCBib3RoIHRoZSBwaHlzaWNhbCBjbG9j
ayBhbmQgdGhlDQo+IHRpbWVjb3VudGVycyBhdCB0aGUgc2FtZSB0aW1lLiAgVGhlIGNvZGUgd291
bGQgYmUgYW4gYXdmdWwgaGFjaywgYW5kIGl0DQo+IHdvdWxkIG5vdCB3b3JrIGluIGFsbCByZWFs
IHdvcmxkIGNpcmN1bXN0YW5jZXMuICBJZiB0aGUga2VybmVsIG9mZmVycyBhIG5ldw0KPiB0aW1l
IHNlcnZpY2UsIHRoZW4gaXQgaGFzIHRvIHdvcmsgYWx3YXlzLg0KPiANCj4gU28sIGdldHRpbmcg
YmFjayB0byBteSB1c2VyIHNwYWNlIGlkZWEsIGl0IF93b3VsZF8gd29yayB0byBsZXQgdGhlIGFw
cGxpY2F0aW9uDQo+IHN0YWNrIGNvbnRyb2wgdGhlIEhXIGNsb2NrIGFzIGJlZm9yZSwgYnV0IHRv
IHRyYWNrIHRoZSBvdGhlciBkb21haW5zDQo+IG51bWVyaWNhbGx5LiAgVGhlbiwgdGhlIG90aGVy
IGFwcGxpY2F0aW9ucyBjb3VsZCB1c2UgdGhlIFRJTUVfU1RBVFVTX05QDQo+IG1hbmFnZW1lbnQg
bWVzc2FnZSAoZGVzaWduZWQgZm9yIHVzZSB3aXRoIGdQVFAgYW5kDQo+IGZyZWVfcnVubmluZykg
dG8gZ2V0IHRoZSBjdXJyZW50IHRpbWUgaW4gdGhlIG90aGVyIGRvbWFpbnMuDQo+IA0KPiBTbyB0
YWtlIHlvdXIgcGljay4gIFlvdSBjYW4ndCBoYXZlIGl0IGJvdGggd2F5cywgSSdtIGFmcmFpZC4N
Cj4gDQoNCkkgZ2l2ZSB1cCBzdXBwb3J0aW5nIHBoeXNpY2FsIGNsb2NrIGFuZCB0aGUgdGltZWNv
dW50ZXJzIGFkanVzdGluZyBhdCB0aGUgc2FtZSB0aW1lLCBidXQgSSBtYXkgY29udGludWUgdG8g
c3VwcG9ydCB2aXJ0dWFsIGNsb2NrIHBlciB5b3VyIHN1Z2dlc3Rpb24uDQogDQpHZXR0aW5nIGJh
Y2sgdG8geW91ciB1c2VyIHNwYWNlIGlkZWEsIEknZCBsaWtlIHRvIHVuZGVyc3RhbmQgZnVydGhl
ciB0byBzZWUgaWYgSSBjYW4gbWFrZSBzb21lIGNvbnRyaWJ1dGlvbi4NCkFjdHVhbGx5IEkgY2Fu
J3QgdGhpbmsgb3V0IGhvdyB0byB0cmFjayAodGhlcmUgaXMgbm90IHRpbWVjb3VuZXIgbGlrZSBp
biBrZXJuZWwpIGluIGEgZWFzeSB3YXksIGFuZCBJIGhhdmUgc29tZSBjb25jZXJucyB0b28uDQoN
CkkgYXNzdW1lIHdlIGhhdmUgYSB3YXkgZm9yIHBoeXNpY2FsIGNsb2NrIGRvbWFpbiB0byB0cmFj
ayBwaGFzZSBhbmQgZnJlcXVlbmN5IG9mZnNldCBmb3IgZWFjaCBvZiBvdGhlciBkb21haW5zLg0K
QXJlIHRoZSBwaGFzZSBhbmQgZnJlcXVlbmN5IG9mZnNldCBlbm91Z2ggdG8gY29udmVydCB0aW1l
c3RhbXA/DQoNClN0aWxsIHRoZSBrZXkgcHJvYmxlbSBpcyBoaWRpbmcgcGh5c2ljYWwgY2xvY2sg
Y2hhbmdlcyBmb3IgdGhlIHZpcnR1YWwuDQpUaGVyZSBpcyBhbm90aGVyIHJlYXNvbiB0aGF0IEkg
aW5pdGlhbGx5IGdhdmUgd29ya2Fyb3VuZCBvZiBubyBzdGVwcGluZyBvbiBwaHlzaWNhbCBjbG9j
ay4NCkJlY2F1c2UgdGltZXN0YW1waW5nIGlzIGFzeW5jaHJvbm91cyB3aXRoIHBoeXNpY2FsIGNs
b2NrIHBoYXNlIGNoYW5naW5nLg0KV2hlbiBhIHRpbWVzdGFtcCBpcyBjYXB0dXJlZCBhbmQgcGh5
c2ljYWwgY2xvY2sgdGltZSBoYXMgYSBzbWFsbCBjaGFuZ2UsIHdlIGhhdmUgbm8gaWRlYSBpZiB0
aW1lc3RhbXBpbmcgaGFwcGVuZWQgYmVmb3JlIG9yIGFmdGVyIGNsb2NrIGNoYW5naW5nIGR1cmlu
ZyBjb252ZXJzaW9uLg0KDQpGaW5hbGx5IGdQVFAgc3RhbmRhcmQgZG9lcyB1c2UgbWFuYWdlbWVu
dCBtZXNzYWdlcy4gSSB0aGluayBpdCBkb2VzbqGvdCBtYXR0ZXIgb25seSBpZiBpdCBpbXBsZW1l
bnRzIHRoZSBmdW5jdGlvbiB3ZSBuZWVkLg0KTWF5YmUgSSBoYXZlbid0IGdvdCB5b3VyIHBvaW50
Li4uDQoNClRoYW5rcyBhIGxvdC4NCg==
