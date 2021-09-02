Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445E43FEC1C
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 12:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240533AbhIBK1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 06:27:18 -0400
Received: from mail-eopbgr130045.outbound.protection.outlook.com ([40.107.13.45]:39935
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233719AbhIBK1O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 06:27:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jcBaeWREYymA3MuVFlTmk7bnmO/Kft9A7b4OLECiqXVfYKg0OvcaVFaFryprbU2rG0KSaNoaMvND7/t6O9mxxvRspFVc8DbrnCW+B9VugVb1qRhAkkSitp3fo1wRYvsf6wjQa0jstN8B68tq7bVhHxgsCctQmXrOPEqbfS364oDKRFB26Qo5QpXH+5cnKFKQas1PBV/2/hqKE7RLveXDO3RjMX3IDQZalzoR1h7r9z2C2UovPh6uuXcmGvdZzgEEjPB8ZLUhX4XZb5+hfqgrBkSfCcLr6z2fIjyFfnCYG8Z6hAsIeqAX2w1g4UGAnsbXkbtcJaP9B69dvCr9QEgN7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=THX2q5tS/Q35HEjz1f5JordcguI6B1dn5Bop2ojshiY=;
 b=bq/DizZgcclpbgHt0/8PcnmGnG2olfxfgTMxDEoxslWZ0xM8SaRec7EvoNv1Mg3Ndq7h2I+k0iSmFYpjqvQd/GcuOq//Dh8vRURekRaytuFlN4a4r69GMpSaQR5YUoWwU5fnboIesgAbyr0LIEvOCt6OBjygP2JAp13Wk+y28ewWWfkITKV5AsLtvav+jPSidpXqAFysJ42LtvEozd4h818adIDbx75j49Ayg83aHiauUH8x7q9tPnR8JXL9CRBNuX3OIy2EM/ctV3iwdh9sc3Rmt5ecCoBYJAsw+8kx8W1emsqAuUEKNXp7PM9QV1mIHdxSL8tNqG5mkfp/ILkv+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THX2q5tS/Q35HEjz1f5JordcguI6B1dn5Bop2ojshiY=;
 b=I81oKo8Xb/4+ZnttUoJ7o65/5Khip7XxJkTPHlN/MG8DW7/UHfgY5Qp6G52q4k+NEY9+b0tUrYUsIr6KcD8VFqVXHaRWu7/YrTZCjML/d1S6w7kDQbwAASwL2G1/9qZ85R1DTSX3kMDBvzLtxACC9jOPy92OvsfekkYUP5YriYk=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5308.eurprd04.prod.outlook.com (2603:10a6:10:1d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.20; Thu, 2 Sep
 2021 10:26:13 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f%9]) with mapi id 15.20.4457.024; Thu, 2 Sep 2021
 10:26:13 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Thread-Topic: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Thread-Index: AQHXnxAXiWCMYvQkY0qCXzBIAPLPn6uO53WAgAAPWNCAAAsFgIAACEPggAAhioCAAQx9sIAAM98AgAAW9HA=
Date:   Thu, 2 Sep 2021 10:26:13 +0000
Message-ID: <DB8PR04MB67954F4650408025E6D4EE2AE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210901090228.11308-1-qiangqing.zhang@nxp.com>
 <20210901092149.fmap4ac7jxf754ao@skbuf>
 <DB8PR04MB6795CCAE06AA7CEB5CCEC521E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210901105611.y27yymlyi5e4hys5@skbuf>
 <DB8PR04MB67956C22F601DA8B7DC147D5E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210901132547.GB22278@shell.armlinux.org.uk>
 <DB8PR04MB6795BB2A13AED5F6E56D08A0E6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210902083224.GC22278@shell.armlinux.org.uk>
In-Reply-To: <20210902083224.GC22278@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db824b4a-c113-448a-81c5-08d96dfc172d
x-ms-traffictypediagnostic: DB7PR04MB5308:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB530861D8B62112FFCC579632E6CE9@DB7PR04MB5308.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TnAm5DO3jlsMQygtwBJGQ3fUqGLtQYxn6y3wDxsJEjGs4GvbQX025a500LHSMbOG7mJJrTqCWXVDHV3wX994yVLcdqiUad2m+S8+pC9ZvOUUFBOEg+VPWwnK7TqzeWorCKh8qx+yOn4qNOdYxR/hbo5ARVI8T6Tg/XUVwzL+x3IFPncjLhW2XTm3QtG7wtPAkRPfz9g6LAXuRw4/L937xrWTxOBPdrcAdbBAl2tUjqFNp3oQF9b9DHBepew0K1UWmRp3DrnwpbmGibdHUp+5wyfNuyeT9PvzFGPCO5QBGKG46YXb6upyzZ2yoJROfGLWaTf2hEe9jG0zmNIgLXpAVOPbpmwwB2Yl2L/uw8AbdUV4VdgWgAEGE64A3z6N4rWytX0JueJHz0kfqZZDGDpQuUw4WneGoLl482jfnc9y1WArD6zaYvfd+WoIJ+HSXNkPnUK7dafv8gv/hazqtzvXsJrxINW6xpNtrPXPiqefKpDWxehBQUX/LqEI2Bypn4j9yYFGxC/J+AAj8pn8xHjPaeaRQsvpSB9jaArD2dQYwglJb+iwC19AIZMErwdovjpzbr8q43G4eo2ceMlPxjdbs3FspFNt93AwrcwSlsbO8XbQwln7/GQYLgOsVbdfsZLCm6JbmxeHAt7aFfWZLia9lZZkwmz4GISIAYvm/QG8adahtDp9anDvDg91OawT0m3904oeBdVdlSCclqvOl8XD0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(7696005)(5660300002)(83380400001)(8936002)(122000001)(9686003)(6916009)(316002)(508600001)(7416002)(186003)(38100700002)(52536014)(4326008)(71200400001)(38070700005)(33656002)(86362001)(2906002)(66446008)(26005)(64756008)(8676002)(6506007)(55016002)(66556008)(53546011)(66476007)(76116006)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?bi85amxLWktpM2VCZmRDTGwrZmxIM2NoNTQzM2dKbFk0KzdIODNhbmJYaXp2?=
 =?gb2312?B?WXRWWjZmK29kUGdoTStsVFBsYi9pUUFNejJOUWsvUTNKQ1dTUncyUmE3VU1z?=
 =?gb2312?B?ZVZVQmxRbW9adkM2RUwyeXI5eVpsZlRxeDJzellRY3d4aGRiYk9WVENQc3Uv?=
 =?gb2312?B?N0JRaHhTUmlRK2ExVW1ydDdNU0lpZlh6M1dkdmtVeWs1eW1aenB2L2dpUm45?=
 =?gb2312?B?QzRXdkFSbFptZnBtZFo3K2pEL24vVmtXajJMd0liTE0rTXhwcDduV04vQ25N?=
 =?gb2312?B?RmpoZ3FSblJPZVhjeVFPVVcxelFvMGM3N0daQkpiV3ZaVTM5Ynl1UlQ4VlBn?=
 =?gb2312?B?ZVJPbFZyWjQ4dUZqaGFVWCs5M2hyR0YrcHR2QTkwZXZZRHBaL3lqb3g0Ymhv?=
 =?gb2312?B?eUlSZXRzamhoQ1RoM21Ka0p1enN6azB3VXVjMTZvMFlaMXlnUlhIc2xEYWZi?=
 =?gb2312?B?SVhaTEZ0djBnUmM4NXR3a1YwNEFhN0ZhRTN5eitxUVcxaVkxd0JZZVZ6M0Nx?=
 =?gb2312?B?d3RUQzYyVG45Wm1pSTl3UlBrU1RkZCtBSW53T29mckhLMFVwQVhSZnYyOGpH?=
 =?gb2312?B?M3NmbDExSkdMQ3NBNDVGTGJkbEZQSnFTVGJFYzRVRjVLc0ZKMTAzam1ucHl1?=
 =?gb2312?B?MDlMS2Q1aU1ORkk1NzgxQmd4ZjdId2thWEw5cTBhMWFkUUUrNHBLTHJJTTRo?=
 =?gb2312?B?UXJXNXBSYU1qZ0luQ3lJdE9Wc1hIei9QemlPazVza2pWd2RrczhxSzVUQVJG?=
 =?gb2312?B?VDU1bisrV2pTY2RjUXpFKzBhNUdNRXh1S1dpbHhmcmN1ZlV0L256bTMwaGEv?=
 =?gb2312?B?V1g1Z0NFdlRpVTFMV3JrT28xT05ldmRSaXVKSWcrVU9jOGRJUU1sVlR1ei80?=
 =?gb2312?B?NE5KYjFORWYwdTVNc1ozeXRqYXB0UHFvRWt1S3lhNTRDczhUQmc1QzRTQk9j?=
 =?gb2312?B?U3ovNmlVcS9CUXBTL0UxYWN1ekVQMDhGL091dUJ4T24wV05hSC92QWlQYnhC?=
 =?gb2312?B?bll4eUJJVHRoeTJjQndsZXlDVzdZQ1E5bUx5YmFTZ2lOVXdJWDZ5NlkzZytl?=
 =?gb2312?B?My9ONUpablFkMWZoMGhCK3czZVYrZ1kzdVB3UkZWN25jRGdMRDJjNW1OdVFW?=
 =?gb2312?B?OVozZFhBVTdEcTBxc256MUppNXNldFQ5Sm9zbEVyUEE1T05YNi9YancxdHZq?=
 =?gb2312?B?Q25SRnVxcUFPWHN4WjBsVDRoK3B0dEhGaDRzam50MDVKZ3M4VmN1Z0xwaStr?=
 =?gb2312?B?ekJjdE5ubFMwMkc5aXJjZU84OWZtOU1ZVDRuVlVhOCtDOFhmTGp1S0k2Tnht?=
 =?gb2312?B?OXlSKzNwanN2MjMzZHU2LzIyQm9Ua1pSd0NWdmN6L2hTN095VDdHM2l2dk1Z?=
 =?gb2312?B?bVBZeVluWVZhbmxRdFh0MUZ6VkV5by82aEdLM0UxZjFKb3kxcThHVWVUYTBH?=
 =?gb2312?B?QmN4TTZrdXNPbGFnb3hqMnhhVlNKaWptdTdtRDJvdkNOcFEvKzlmTnlWOHE3?=
 =?gb2312?B?Nm02RDZpOHF4OFpVNEt4NWdOQW02WWFjb0RJdGQzTG1jbXUyakEwOUVrdGtK?=
 =?gb2312?B?UzU0MDZyaXFxVUxEUTk3V3VNOXVuQzZIWmpJSFpHTTVWbWs2bCtENkhKNHVl?=
 =?gb2312?B?NldrQ29hUVMrWFVSdVZsbE04cWlielM5Y09ydlJsb3BtemxITFRWem5Ha2xB?=
 =?gb2312?B?WFpBd0JCRHJxL0xPRXBDbXN4NGRVZEwzc3F6amtteEx6UjFETE5oVWhqMlVm?=
 =?gb2312?Q?S4Llwlazu0Q21LcetRCWpGCQSxULlBLPAQfFYgq?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db824b4a-c113-448a-81c5-08d96dfc172d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 10:26:13.6505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hHX98e6XTl53SG0dGKtLmrTdFoFO5qN99q8Rh79XRmNvgKVUL7og3JvlysFpDczsTMHUgbfbLFD/F/b+N8c3aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5308
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBSdXNzZWxsLA0KDQpUaGFua3MgYSBsb3QhDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdl
LS0tLS0NCj4gRnJvbTogUnVzc2VsbCBLaW5nIDxsaW51eEBhcm1saW51eC5vcmcudWs+DQo+IFNl
bnQ6IDIwMjHE6jnUwjLI1SAxNjozMg0KPiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3Fpbmcuemhh
bmdAbnhwLmNvbT4NCj4gQ2M6IFZsYWRpbWlyIE9sdGVhbiA8b2x0ZWFudkBnbWFpbC5jb20+OyBw
ZXBwZS5jYXZhbGxhcm9Ac3QuY29tOw0KPiBhbGV4YW5kcmUudG9yZ3VlQGZvc3Muc3QuY29tOyBq
b2FicmV1QHN5bm9wc3lzLmNvbTsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwu
b3JnOyBtY29xdWVsaW4uc3RtMzJAZ21haWwuY29tOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
OyBhbmRyZXdAbHVubi5jaDsgZi5mYWluZWxsaUBnbWFpbC5jb207DQo+IGhrYWxsd2VpdDFAZ21h
aWwuY29tOyBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIXSBuZXQ6IHN0bW1hYzogZml4IE1BQyBub3Qgd29ya2luZyB3aGVuIHN5c3RlbSByZXN1
bWUNCj4gYmFjayB3aXRoIFdvTCBlbmFibGVkDQo+IA0KPiBPbiBUaHUsIFNlcCAwMiwgMjAyMSBh
dCAwNzoyODo0NEFNICswMDAwLCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+ID4NCj4gPiBIaSBSdXNz
ZWxsLA0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTog
UnVzc2VsbCBLaW5nIDxsaW51eEBhcm1saW51eC5vcmcudWs+DQo+ID4gPiBTZW50OiAyMDIxxOo5
1MIxyNUgMjE6MjYNCj4gPiA+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAu
Y29tPg0KPiA+ID4gQ2M6IFZsYWRpbWlyIE9sdGVhbiA8b2x0ZWFudkBnbWFpbC5jb20+OyBwZXBw
ZS5jYXZhbGxhcm9Ac3QuY29tOw0KPiA+ID4gYWxleGFuZHJlLnRvcmd1ZUBmb3NzLnN0LmNvbTsg
am9hYnJldUBzeW5vcHN5cy5jb207DQo+ID4gPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtl
cm5lbC5vcmc7IG1jb3F1ZWxpbi5zdG0zMkBnbWFpbC5jb207DQo+ID4gPiBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBhbmRyZXdAbHVubi5jaDsgZi5mYWluZWxsaUBnbWFpbC5jb207DQo+ID4gPiBo
a2FsbHdlaXQxQGdtYWlsLmNvbTsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT4NCj4g
PiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIG5ldDogc3RtbWFjOiBmaXggTUFDIG5vdCB3b3JraW5n
IHdoZW4gc3lzdGVtDQo+ID4gPiByZXN1bWUgYmFjayB3aXRoIFdvTCBlbmFibGVkDQo+ID4gPg0K
PiA+ID4gVGhpcyBtZWFucyB5b3UgbmVlZCB0byBoYXZlIHRoZSBwaHkgPC0+IG1hYyBsaW5rIHVw
IGR1cmluZyBzdXNwZW5kLA0KPiA+ID4gYW5kIGluIHRoYXQgY2FzZSwgeWVzLCB5b3UgZG8gbm90
IHdhbnQgdG8gY2FsbA0KPiA+ID4gcGh5bGlua19zdG9wKCkgb3IgcGh5bGlua19zdGFydCgpLg0K
PiA+DQo+ID4gSSBoYXZlIGEgcXVlc3Rpb24gaGVyZSwgd2h5IG5lZWQgdG8gaGF2ZSB0aGUgcGh5
PC0+bWFjIGxpbmsgdXAgZHVyaW5nDQo+IHN1c3BlbmQ/DQo+IA0KPiBZb3UgbmVlZCB0aGUgbGlu
ayB1cCBiZWNhdXNlIEkgdGhpbmsgZnJvbSByZWFkaW5nIHRoZSBjb2RlLCBpdCBpcyBfbm90XyB0
aGUgUEhZDQo+IHRoYXQgaXMgdHJpZ2dlcmluZyB0aGUgd2FrZXVwIGluIHRoZSBjb25maWd1cmF0
aW9uIHlvdSBhcmUgdXNpbmcsIGJ1dCB0aGUgTUFDLg0KPiANCj4gSWYgdGhlIGxpbmsgaXMgZG93
biwgdGhlIFBIWSBjYW4ndCBwYXNzIHRoZSByZWNlaXZlZCBwYWNrZXQgdG8gdGhlIE1BQywgYW5k
IHRoZQ0KPiBNQUMgY2FuJ3QgcmVjb2duaXNlIHRoZSBtYWdpYyBwYWNrZXQuDQoNClBlciBteSB1
bmRlcnN0YW5kaW5nLCBpZiB1c2UgUEhZLWJhc2VkIHdha2V1cCwgUEhZIHNob3VsZCBiZSBhY3Rp
dmUsIGFuZCBNQUMgY2FuIGJlDQp0b3RhbGx5IHN1c3BlbmRlZC4gV2hlbiBQSFkgcmVjZWl2ZSB0
aGUgbWFnaWMgcGFja2V0cywgaXQgd2lsbCBnZW5lcmF0ZSBhIHNpZ25hbCB2aWEgd2FrZXVwDQpQ
SU4gKFBIWSBzZWVtcyBhbGwgaGF2ZSBzdWNoIFBJTikgdG8gaW5mb3JtIFNvQywgd2UgY2FuIHVz
ZSB0aGlzIHRvIHdha2UgdXAgdGhlIHN5c3RlbS4NClBsZWFzZSBjb3JyZWN0IG1lIGlmIEkgbWlz
dW5kZXJzdGFuZC4NCg0KPiBGRUMgZG9lc24ndCBoYXZlIHRoaXMuIEZFQyByZWxpZXMgcHVyZWx5
IG9uIHRoZSBQSFkgZGV0ZWN0aW5nIHRoZSBtYWdpYyBwYWNrZXQsDQo+IHdoaWNoIGlzIG11Y2gg
bW9yZSBwb3dlciBlZmZpY2llbnQsIGJlY2F1c2UgaXQgbWVhbnMgdGhlIE1BQyBkb2Vzbid0IG5l
ZWQNCj4gdG8gYmUgcG93ZXJlZCB1cCBhbmQgb3BlcmF0aW9uYWwgd2hpbGUgdGhlIHJlc3Qgb2Yg
dGhlIHN5c3RlbSBpcyBzdXNwZW5kZWQuDQoNCkFGQUlLLCBGRUMgYWxzbyB1c2UgdGhlIE1BQy1i
YXNlZCB3YWtldXAsIHdoZW4gZW5hYmxlIEZFQyBXb0wgZmVhdHVyZSwgaXQgd2lsbA0Ka2VlcCBN
QUMgcmVjZWl2ZSBsb2dpYyBhY3RpdmUsIFBIWSBwYXNzIHRoZSByZWNlaXZlZCBwYWNrZXRzIHRv
IE1BQywgaWYgTUFDIGRldGVjdHMNCnRoZSBtYWdpYyBwYWNrZXRzLCBpdCB3aWxsIGdlbmVyYXRl
IGFuIGludGVycnVwdCB0byB3YWtlIHVwIHRoZSBzeXN0ZW0uDQoNCkJlbG93IGlzIHRoZSBibG9j
ayBndWlkZSBkZXNjcmlwdGlvbjoNClRvIHB1dCB0aGUgTUFDIGluIFNsZWVwIG1vZGUsIHNldCBF
TkVUbl9FQ1JbU0xFRVBdLiBBdCB0aGUgc2FtZSB0aW1lDQpFTkVUbl9FQ1JbTUFHSUNFTl0gc2hv
dWxkIGFsc28gYmUgc2V0IHRvIGVuYWJsZSBtYWdpYyBwYWNrZXQgZGV0ZWN0aW9uLg0KSW4gYWRk
aXRpb24sIHdoZW4gdGhlIHByb2Nlc3NvciBpcyBpbiBTdG9wIG1vZGUsIFNsZWVwIG1vZGUgaXMg
ZW50ZXJlZCwgd2l0aG91dCBhZmZlY3RpbmcNCnRoZSBFTkVUbl9FQ1IgcmVnaXN0ZXIgYml0cy4N
CldoZW4gdGhlIGNvcmUgaXMgaW4gU2xlZXAgbW9kZToNCj8gVGhlIE1BQyB0cmFuc21pdCBsb2dp
YyBpcyBkaXNhYmxlZC4NCj8gVGhlIGNvcmUgRklGTyByZWNlaXZlL3RyYW5zbWl0IGZ1bmN0aW9u
cyBhcmUgZGlzYWJsZWQuDQo/IFRoZSBNQUMgcmVjZWl2ZSBsb2dpYyBpcyBrZXB0IGluIE5vcm1h
bCBtb2RlLCBidXQgaXQgaWdub3JlcyBhbGwgdHJhZmZpYyBmcm9tIHRoZQ0KbGluZSBleGNlcHQg
bWFnaWMgcGFja2V0cy4gVGhleSBhcmUgZGV0ZWN0ZWQgc28gdGhhdCBhIHJlbW90ZSBhZ2VudCBj
YW4gd2FrZSB0aGUNCm5vZGUuDQoNClNvIEZFQyBpcyBNQUMtYmFzZWQgd2FrZXVwLCByaWdodD8N
Cg0KPiA+IEFzIHlvdSBkZXNjcmliZWQgaW4gcGFzdCB0aHJlYWQsIHBoeWxpbmtfc3RvcCgpIGFu
ZCBwaHlsaW5rX3N0YXJ0KCkNCj4gPiBhbHNvIG5lZWQgdG8gYmUgY2FsbGVkIGV2ZW4gd2l0aCBX
b0wgYWN0aXZlLg0KPiANCj4gVGhhdCB3YXMgd2l0aCB0aGUgYXNzdW1wdGlvbiB0aGF0IHRoZSBQ
SFkgd2FzIGRldGVjdGluZyB0aGUgbWFnaWMgcGFja2V0LiBJdA0KPiBpc24ndCBmb3Igc3RtbWFj
IC0gc3RtbWFjIGNhbiBiZSBjb25maWd1cmVkIHRvIGJ5cGFzcyB0aGUgY29uZmlndXJhdGlvbiBv
ZiB0aGUNCj4gUEhZIGZvciB0aGlzIGFuZCB1c2VzIHRoZSBNQUMgdG8gZGV0ZWN0IHRoaXMgaW5z
dGVhZC4gSWYgdGhlIE1BQyBpcyBkb2luZyB0aGUNCj4gZGV0ZWN0aW5nIGZvciBXb0wsIHRoZW4g
eW91IG5lZWQgbmV0d29yayBjb25uZWN0aXZpdHkgdG8gYmUgZnVuY3Rpb25hbCBmcm9tDQo+IHRo
ZSBuZXR3b3JrIGNhYmxlIHRocm91Z2ggdGhlIFBIWSBhbmQgdXAgdG8gdGhlIE1BQy4NCg0KWWVz
LCB3ZSBjb25maWd1cmUgTUFDIGRldGVjdGluZyB0aGUgV29MLCBJIHRoaW5rLCBhcyBsb25nIGFz
IFBIWSBpcyBhY3RpdmUsIGl0IGNhbiByZWNlaXZlDQp0aGUgcGFja2V0cyB0aGVuIHBhc3MgdG8g
TUFDLCBNQUMgaWdub3JlIGFsbCB0cmFmZmljIGZyb20gdGhlIGxpbmUgZXhjZXB0IG1hZ2ljIHBh
Y2tldHMuDQpTbyBTVE1NQUMgc2hvdWxkIHdvcmsgdGhlIHNhbWUgYXMgRkVDIGRvLg0KDQo+IFNv
LCBicmluZ2luZyB0aGUgbGluayBkb3duIGF0IHN1c3BlbmQgaW4gdGhpcyBjYXNlIF93aWxsXyBi
cmVhayBXb0wuIFRoZSBQSFkNCj4gaXNuJ3QgdGhlIGRldmljZSBkZXRlY3RpbmcgdGhlIG1hZ2lj
IHBhY2tldCwgaXQgaXMgdGhlIE1BQywgYW5kIHRoZSBNQUMgbXVzdA0KPiBiZSBhYmxlIHRvIHNl
ZSB0aGUgbmV0d29yayB0cmFmZmljLg0KDQpJIGFtIG5vdCBzdXJlIGlmIGl0IGlzIHRoZSBkaWZm
ZXJlbmNlIGZvciBwaHlsaW5rIGFuZCBwaHlsaWIsIG1heSBwaHlsaW5rIGhhcyBzdWNoIHJlcXVp
cmVtZW50Pw0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg0K
