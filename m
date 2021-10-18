Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38CD4315DF
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 12:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbhJRKXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 06:23:50 -0400
Received: from mail-vi1eur05on2088.outbound.protection.outlook.com ([40.107.21.88]:11808
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231206AbhJRKXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 06:23:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHZGW5VRLueSuIC1egOOA9TSZF0PFygRZ8gnmEk21+FcVNZUxc+L7AIxUEGKn1Y+JbHLV1TiAVYHQ79bbD+YOYnF1BcijfbvsFsumjMXmnK7mhzVMj4dHxS3ae5GFi8JFVGXkr7Y80FXQey2qnI4lwWmsXvEXuiDgLuIr/SBZ8dQpB6a3fVnQU0lX5ExwBYmLTHQcfNyQcQG04bnTtL86dwFDfLhs9iBrM0Ot2Gv2d42AXSL9vjXfcbiIm4YDzcN2RNxU0GavsBwDttpOuYMr8rSeAdcNFYAmSyRUK2OfSFuvZOVyfMH7rihjpHEYRHF4L+nkmgHi3sAWIwG3fUD4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//R3RmS1xAEF2XRUUdbhkqqJOYBFsYpfd7wwqz5ZzZY=;
 b=bWha2MFVD3OpQk4PxPpvpC7ns+DlE7DWvaMfQXHZaYoPrcO34XpkTYG6IBG3kzZEwpF56XDlcYDAQhHpWpDVkbqRqYrmkFv50QyW62ag21rYsvh3PvW0wewb2XRl7ZGzKlLW6XxJKHvJJrJacCT/5hir5RJ/d2uJsXV3O2F1yv3L9rUBY9dkRyWH029T0AmyMyF5cFzLNtT3RjiwEP/q1HAT5T5mwV1j8ZLb5u8Vjwlghhdr8zGZgczTc/VDhVRI7cVJ4eFHTuXl3oMp6+ODH1ZukwyhHFTXmQzE78yNJVS+LQt5Mbi/da26EA1QJ/GMOVmhFDj82hiPfQn8ypFt+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//R3RmS1xAEF2XRUUdbhkqqJOYBFsYpfd7wwqz5ZzZY=;
 b=fw53VsdL2iQJbdHDsTT0OP0X9TBgaEp+LOzoC5y+AnLatqBYEMwNrEEhsSp2GE3SCHI+ay6qEjT0eZUVKyskE+MKcBOJtbZ386Y2mXfsj7mkINhPqKbUIB3rxNkiJT1jdRRB6hdHb8v1WwHB0WeNENOHNL1eGcvEKXdHCGhzCoQ=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6252.eurprd04.prod.outlook.com (2603:10a6:10:c8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Mon, 18 Oct
 2021 10:20:58 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f%9]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 10:20:57 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: fec: defer probe if PHY on external MDIO bus is not
 available
Thread-Topic: [PATCH] net: fec: defer probe if PHY on external MDIO bus is not
 available
Thread-Index: AQHXwO79XdKKlusz3kKNkqRXQm/YkqvYBKNg
Date:   Mon, 18 Oct 2021 10:20:57 +0000
Message-ID: <DB8PR04MB679504F7E61252F3FC62FBFEE6BC9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20211014113043.3518-1-matthias.schiffer@ew.tq-group.com>
In-Reply-To: <20211014113043.3518-1-matthias.schiffer@ew.tq-group.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: ew.tq-group.com; dkim=none (message not signed)
 header.d=none;ew.tq-group.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8bf6ac09-7e58-48e5-c199-08d99220f9f3
x-ms-traffictypediagnostic: DBBPR04MB6252:
x-microsoft-antispam-prvs: <DBBPR04MB6252D78568B37602DF5D22E5E6BC9@DBBPR04MB6252.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F20P175q/bHcJdgJmdSOUVwsdLMXqr1DXrq7wmfM7SOG2u5C6x4LleXZofhmWSi/EvStgIqpNnvPd0E12YJ2TnEEuz5vyyBLgxtUrb2ptUwl/eaQxsquaJPRCvhM26pQntxshu2ptToa3+RQAWTIb1K1cKNDWvHO1b1EtJdlS1X9mZXqStP3mxhmoLKZqQcLecnW9Fu3WV5HvWCyArlf67A/LRIr8COsBDI581u3jNz+0mOlSuB0JhncgRx95SCJqOvmOB5n8kbkDGLN25KHjncmRGQvHB1P9xiWvuYsFch736u78rTAdC77zogCVCvjc7PiVpA+tynQsIJWJMWLs5FeZBJdaYW9Pc6hqnC01AX8aezRQRmOJsB91xBZLUuDAhK5TTKr9BXbapdYU37temkBZerCXJZpbdj6YjwrEZnmqSUZKBsQzNrYeGtN471D0OU6ssRpXjia+G2UfAAxjM0ggHbDd4J+kduSKKJr8MBpAqYk5q7qiKBpvrzS4rU+BKvTLyu63Sh6+yVNmwI14SruO6f7yOVO+bs8f1tWszmc5G3G109A8Nt5pUF7zyKVY0ew+C70AUW3a7EhKUGP23dpiu5hpz7mRfOXMYgxyHSkEIzeuvasLw9+VddrMTK3rkKLQ3ZWlndHdx/992ZMxDaeSUuJwGyMs9amwqg7uUSDgvP/pAufcibdMyH8OZ6D7f7BDjgYtjOs+z8vzhCPJOl+etfKNW/nHCXDgjS3gLpUmCahL3s/MGrd02qajdAGX3TFsBNz2jQ37YAHxQW7KgJiuEeNct8nCQunra6xtFQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(76116006)(55016002)(966005)(9686003)(186003)(54906003)(8936002)(26005)(33656002)(83380400001)(71200400001)(38100700002)(38070700005)(53546011)(8676002)(2906002)(110136005)(86362001)(122000001)(4326008)(6506007)(66446008)(64756008)(508600001)(66476007)(66556008)(66946007)(52536014)(5660300002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?bnByZ3VuNkdsdHQrSDVjRkNKYnRiWjNyN0x0akhLT1QxU0s2ZGdWdEVqOE1a?=
 =?gb2312?B?R0JuWHdmelVoTExzL1BTZ1RZM3V0SGdTNkVkRnM5UURDN2FoaFNNR2l6SFJT?=
 =?gb2312?B?TUNlUGIwMTlERy95UEpRcFJNcCtnZkFTWVgyeEs0NkpaV1Nnc1ZvU0pUZDM5?=
 =?gb2312?B?WEtmYkk1R3lFVCtFd2VuSWhsUm5kbGFjYUEzc1hid2Vid0w5NGlEeXV6SUxw?=
 =?gb2312?B?Y1V1MkFIbWE3RGxScDg3eEg3S0thLytwbTBGb08zZXl6TkNtaUVVaHpvYXpF?=
 =?gb2312?B?UjN2amp0Z0dHK1ZPdER4WWo2clJZR0lZcWRwVFo1UmJWUVcwOVRNaTRIN0Ev?=
 =?gb2312?B?YWM4elJOd3lrbEN2QnMwSk9OVVZtNWMxWTcwdUg0Y2lsbjVIMTE3UUxTNklU?=
 =?gb2312?B?aSttUWpyUkZ4Y3JsNkc0bGd3QUtyVzNxMmVDbXdoOTNQWmlaQVBtaU9aNTNj?=
 =?gb2312?B?N2J0d3hLUDNvQldDQTd4bXppeXIxaW1jMldlRktjZkMvK1lCQk44cUFiM2Vw?=
 =?gb2312?B?Y1h6VVk0OVlwbkdTWkNVbVNXRGRzeEViSFBlakFLeTBWRFRsdEZKWDlaMkx1?=
 =?gb2312?B?Um94MmdROFNJSSt1d0tPbUJvSXdrRzFEWGZOTEloN0tKMDZkc1B4ckx4b2oz?=
 =?gb2312?B?Q29ici9XN3hibU1pNkpzcldBQUpJZ3hQQ21wU2lhVVFQbGFVdHZxbFdUdGFz?=
 =?gb2312?B?MDhMMVp0UDJhd052Rk1VOWY4eCtPZEZYNWpaWFlPSmpaN1l3YXZseUZPODVt?=
 =?gb2312?B?b0ZIamMzc3gxM2tjdkJ5SldkOEtlSjBSbksrK0QzV05ONzY4QUVFbHFobHk2?=
 =?gb2312?B?OU13QmV3eWozUkxHNWw1SG9hMmszeEtEd29CSGdBZjF0dnBKSnJGb2NkVDRM?=
 =?gb2312?B?eXpOZFdGQzRFVjFZQTYvb29QN1czaGFiUHZ0T1hLelZtNVRLRUdwOGFQOHlW?=
 =?gb2312?B?S0FWRU1hR3E0U21odnJwV1FXRWpmQnFQWHB2OVBpVXEvRnh2YURDcDhOVWdm?=
 =?gb2312?B?MGVOdmNOSGhNbWVxaEhxQjJLRE9yUW5aR0toeEFwSnpBK3NMdnkxYTV6cmQ2?=
 =?gb2312?B?Ymx2a0F5S21YZmhMWWdUWUZCcUR5Z1d6K2dYQm82ZGk5eWdxaTJCVit5WmxH?=
 =?gb2312?B?NytEeGRZQWZrbmh2ZW13TlpXNnJueVNXQXBvYWZ6UWJtYkNKQkhNWU00TWI5?=
 =?gb2312?B?OWJKaVlGK0NpTSttdGVTekI5YWpuMUlsV2VQeWYrMWFUdGMwemdqREE5QUZm?=
 =?gb2312?B?TnQ2WTZJQVF4WE1zRFpSNVVpekVpazF0N0EvWnArQlNSRklBeXNPMlZzOWx3?=
 =?gb2312?B?NStWU21hSHhxTnhSeGc0eTY1d2VXUFcxczZMQ29pRWIzVGtsTkNRMk5RRFVW?=
 =?gb2312?B?NFRNNjU5TnlqMURZY25LdHBON1ZtdlBHZWhPdEV6Zkl3cHdNaFhxdkZPVVc5?=
 =?gb2312?B?K3JuT1o3akRYSHl4QTNFOXVrYW9oU3JZNG9lT0xpQ1E0a01aR091VVBVWFFu?=
 =?gb2312?B?ck5FYy9WS0s2dGZ5OU1pZ0NlOGg3TE10dTBCTm1oamNuLytyaVR3YlhIQ1BX?=
 =?gb2312?B?bmNSVnlLRWtKUFFybWJPQzZGS1grc1BQUlptOFFHbnRjcFZiWVFCWUpKekFH?=
 =?gb2312?B?dDdScjNzZGVPeW02Zit1QXRsdHY3ZTJOaGQzTldBZ0g1MW1Mbml0WUNYNTEv?=
 =?gb2312?B?TmVpV3E5eVNBUDVzdEtYMUJIcE1abXFwYkRlYURJUndoM2cxQkxtOXhQYmZZ?=
 =?gb2312?Q?BI159xB4VdeuU78G5SFpFHEn/FIa684JA4/33UD?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bf6ac09-7e58-48e5-c199-08d99220f9f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2021 10:20:57.9148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AKPs8zQI2cKuqIjTM3Wr3vFQ8MeVIMovy+NwbJGlSHjCHp2jJLGicUJ/sMEDcExOWAn2fPUIxr8C09HqMfVMVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBNYXR0aGlhcywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBN
YXR0aGlhcyBTY2hpZmZlciA8bWF0dGhpYXMuc2NoaWZmZXJAZXcudHEtZ3JvdXAuY29tPg0KPiBT
ZW50OiAyMDIxxOoxMNTCMTTI1SAxOTozMQ0KPiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3Fpbmcu
emhhbmdAbnhwLmNvbT47IERhdmlkIFMuIE1pbGxlcg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47
IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+DQo+IENjOiBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBNYXR0aGlhcyBTY2hpZmZlcg0K
PiA8bWF0dGhpYXMuc2NoaWZmZXJAZXcudHEtZ3JvdXAuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0hd
IG5ldDogZmVjOiBkZWZlciBwcm9iZSBpZiBQSFkgb24gZXh0ZXJuYWwgTURJTyBidXMgaXMgbm90
DQo+IGF2YWlsYWJsZQ0KPiANCj4gT24gc29tZSBTb0NzIGxpa2UgaS5NWDZVTCBpdCBpcyBjb21t
b24gdG8gdXNlIHRoZSBzYW1lIE1ESU8gYnVzIGZvciBQSFlzDQo+IG9uIGJvdGggRXRoZXJuZXQg
Y29udHJvbGxlcnMuIEN1cnJlbnRseSBkZXZpY2UgdHJlZXMgZm9yIHN1Y2ggc2V0dXBzIGhhdmUg
dG8NCj4gbWFrZSBhc3N1bXB0aW9ucyByZWdhcmRpbmcgdGhlIHByb2JlIG9yZGVyIG9mIHRoZSBj
b250cm9sbGVyczoNCj4gDQo+IEZvciBleGFtcGxlIGluIGlteDZ1bC0xNHgxNC1ldmsuZHRzaSwg
dGhlIE1ESU8gYnVzIG9mIGZlYzIgaXMgdXNlZCBmb3IgdGhlDQo+IFBIWXMgb2YgYm90aCBmZWMx
IGFuZCBmZWMyLiBUaGUgcmVhc29uIGlzIHRoYXQgZmVjMiBoYXMgYSBsb3dlciBhZGRyZXNzIHRo
YW4NCj4gZmVjMSBhbmQgaXMgdGh1cyBsb2FkZWQgZmlyc3QsIHNvIHRoZSBidXMgaXMgYWxyZWFk
eSBhdmFpbGFibGUgd2hlbiBmZWMxIGlzDQo+IHByb2JlZC4NCg0KSXQncyBub3QgY29ycmVjdCwg
SSB0aGluaywgd2UgaGF2ZSBib2FyZCBkZXNpZ25lZCB0byB1c2UgZmVjMSh3aGljaCBpcyBsb3dl
ciBhZGRyZXNzKSB0byBjb250cm9sbGVyIE1ESU8gaW50ZXJmYWNlLCBzdWNoIGFzLA0KaHR0cHM6
Ly9zb3VyY2UuY29kZWF1cm9yYS5vcmcvZXh0ZXJuYWwvaW14L2xpbnV4LWlteC90cmVlL2FyY2gv
YXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDhxbS1tZWsuZHRzP2g9bGYtNS4xMC55I245NDgN
CnRoYXQgbWVhbnMgb3VyIGRyaXZlciBjYW4gaGFuZGxlIHRoZXNlIGNhc2VzLCBub3QgcmVsYXRl
ZCB0byB0aGUgb3JkZXIuDQoNCj4gQmVzaWRlcyBiZWluZyBjb25mdXNpbmcsIHRoaXMgbGltaXRh
dGlvbiBhbHNvIG1ha2VzIGl0IGltcG9zc2libGUgdG8gdXNlIHRoZQ0KPiBzYW1lIGRldmljZSB0
cmVlIGZvciB2YXJpYW50cyBvZiB0aGUgaS5NWDZVTCB3aXRoIG9uZSBFdGhlcm5ldCBjb250cm9s
bGVyDQo+ICh3aGljaCBoYXZlIHRvIHVzZSB0aGUgTURJTyBvZiBmZWMxLCBhcyBmZWMyIGRvZXMg
bm90IGV4aXN0KSBhbmQgdmFyaWFudHMgd2l0aA0KPiB0d28gY29udHJvbGxlcnMgKHdoaWNoIGhh
dmUgdG8gdXNlIGZlYzIgYmVjYXVzZSBvZiB0aGUgbG9hZCBvcmRlcikuDQoNCkdlbmVyYWxseSBz
cGVha2luZywgeW91IHNob3VsZCBvbmx5IGluY2x1ZGUgaW14NnVsLmR0c2kgZm9yIHlvdXIgYm9h
cmQgZGVzaWduIHRvIGNvdmVyIFNvQyBkZWZpbml0aW9uLA0KYW5kIGlteDZ1bC0xNHgxNC1ldmsu
ZHRzaS8gaW14NnVsLTE0eDE0LWV2ay5kdHMgaXMgZm9yIG91ciAxNHgxNCBFVksgYm9hcmQuIFNv
IGRvIHdlIHJlYWxseSBuZWVkIHRoaXMNCmRlZmVyIHByb2JlPw0KDQo+IA0KPiBUbyBmaXggdGhp
cywgZGVmZXIgdGhlIHByb2JlIG9mIHRoZSBFdGhlcm5ldCBjb250cm9sbGVyIHdoZW4gdGhlIFBI
WSBpcyBub3Qgb24NCj4gb3VyIG93biBNRElPIGJ1cyBhbmQgbm90IGF2YWlsYWJsZS4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IE1hdHRoaWFzIFNjaGlmZmVyIDxtYXR0aGlhcy5zY2hpZmZlckBldy50
cS1ncm91cC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2Zl
Y19tYWluLmMgfCAyMyArKysrKysrKysrKysrKysrKysrKysrLQ0KPiAgMSBmaWxlIGNoYW5nZWQs
IDIyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQo+IGluZGV4IDQ3YTZmYzcwMmFjNy4uZGMwNzBk
ZDIxNmU4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVj
X21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4u
Yw0KPiBAQCAtMzgyMCw3ICszODIwLDI4IEBAIGZlY19wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2
aWNlICpwZGV2KQ0KPiAgCQlnb3RvIGZhaWxlZF9zdG9wX21vZGU7DQo+IA0KPiAgCXBoeV9ub2Rl
ID0gb2ZfcGFyc2VfcGhhbmRsZShucCwgInBoeS1oYW5kbGUiLCAwKTsNCj4gLQlpZiAoIXBoeV9u
b2RlICYmIG9mX3BoeV9pc19maXhlZF9saW5rKG5wKSkgew0KPiArCWlmIChwaHlfbm9kZSkgew0K
PiArCQlzdHJ1Y3QgZGV2aWNlX25vZGUgKm1kaW9fcGFyZW50ID0NCj4gKwkJCW9mX2dldF9uZXh0
X3BhcmVudChvZl9nZXRfcGFyZW50KHBoeV9ub2RlKSk7DQo+ICsNCj4gKwkJcmV0ID0gMDsNCj4g
Kw0KPiArCQkvKiBTa2lwIFBIWSBhdmFpbGFiaWxpdHkgY2hlY2sgZm9yIG91ciBvd24gTURJTyBi
dXMgdG8gYXZvaWQNCj4gKwkJICogY3ljbGljIGRlcGVuZGVuY3kNCj4gKwkJICovDQo+ICsJCWlm
IChtZGlvX3BhcmVudCAhPSBucCkgew0KPiArCQkJc3RydWN0IHBoeV9kZXZpY2UgKnBoeSA9IG9m
X3BoeV9maW5kX2RldmljZShwaHlfbm9kZSk7DQo+ICsNCj4gKwkJCWlmIChwaHkpDQo+ICsJCQkJ
cHV0X2RldmljZSgmcGh5LT5tZGlvLmRldik7DQo+ICsJCQllbHNlDQo+ICsJCQkJcmV0ID0gLUVQ
Uk9CRV9ERUZFUjsNCj4gKwkJfQ0KPiArDQo+ICsJCW9mX25vZGVfcHV0KG1kaW9fcGFyZW50KTsN
Cj4gKwkJaWYgKHJldCkNCj4gKwkJCWdvdG8gZmFpbGVkX3BoeTsNCj4gKwl9IGVsc2UgaWYgKG9m
X3BoeV9pc19maXhlZF9saW5rKG5wKSkgew0KPiAgCQlyZXQgPSBvZl9waHlfcmVnaXN0ZXJfZml4
ZWRfbGluayhucCk7DQo+ICAJCWlmIChyZXQgPCAwKSB7DQo+ICAJCQlkZXZfZXJyKCZwZGV2LT5k
ZXYsDQo+IC0tDQo+IDIuMTcuMQ0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg==
