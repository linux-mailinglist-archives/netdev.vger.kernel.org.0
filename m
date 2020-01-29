Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0691A14C7D4
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 10:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgA2JJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 04:09:49 -0500
Received: from mail-eopbgr60070.outbound.protection.outlook.com ([40.107.6.70]:35584
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725899AbgA2JJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 04:09:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXG2nIUIKgK35w6sW9+i9n7QaQ/F1jMoGcof+mddHgiOBK39/TORveUCsq53/57dN5bGiPhgtFH8AYJoCmXUS6Lcivx+TGlOddSchWVGghT9FeYOTA3mcX2X/81hS5FsHLaNbeCHoWbIWK67dqg9QFfyh/c2RKZPRTxhd3u8muzCo5FZgXojRHaVH0GWrAl07mIfX32WvaqMV3LVi2jEGEQjNcoG8ALFB2i5OIz58UJuPqJs/WtqGO7JGYfudSlwXBz4zjak9OEivn2nH/OfLYS+pxL7WNI19VZJWlQoGEVhoGiZQbkVcJm7ksTvS51anVQ5do44/CtCNJWIQyJ0Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vATnlmz3y9BrMQW42U7BEEIRTROKLuSlprNmnHDWHag=;
 b=UobMTfnbFvS0W0xbb8T5D51yP2UnXguZJbDLtmrxZodVtz+MOoTYjyCwfA8zAPGmSGJfcq8aX5NtlORr9iyU7IGiaoElkPwJFCnher2c/+kvI8+x1+fOz78LQx32hz0pL5EXU3vf9d+kT5pTCMBGChKZc5wNIVYp+iLW064csnJZe4yOapcPyo5rPcuWz+bImyApPqeYdxSdJwowtrzUnVlf4QkbXomJIeDMEO0NhuZdAftYD2RCOmm/h7bBQLCqDJAG7aciADcv+Mb71L3jM0RNkPSUgS//ecfYsvRPBCUrsdkceMkZVzrNiy/rJV2hvjEvhIUomHFLkibori0F0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vATnlmz3y9BrMQW42U7BEEIRTROKLuSlprNmnHDWHag=;
 b=cw/Vlg3HSwRAnnR/iSDzp/1WvuTLbjOaQu70IgHC3QMYKI+mzGacb4j7ThA9sBwLDXV+yCBk6JbN7YUcO57wTL2WCGiJDqX5O9RlIJpzjqliRvBwVjQr2jFHrIy4FCx0+oQx68h1eZx/fq4yxXQlgLioX1/svrmQG9ZxOi/umi4=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB6731.eurprd04.prod.outlook.com (20.179.248.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.24; Wed, 29 Jan 2020 09:09:44 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3%6]) with mapi id 15.20.2665.027; Wed, 29 Jan 2020
 09:09:44 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>
CC:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "ykaukab@suse.de" <ykaukab@suse.de>
Subject: RE: [PATCH v2 2/2] dpaa_eth: support all modes with rate adapting
 PHYs
Thread-Topic: [PATCH v2 2/2] dpaa_eth: support all modes with rate adapting
 PHYs
Thread-Index: AQHV1SOT4TVxn3QCwU2UHzdlmVFpwqf+o0+AgAAJP4CAAYv9gIABC37w
Date:   Wed, 29 Jan 2020 09:09:44 +0000
Message-ID: <DB8PR04MB698504E07E288BB5BD79BD38EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1580137671-22081-3-git-send-email-madalin.bucur@oss.nxp.com>
 <CA+h21hqzR72v9=dWGk1zBptNHNst+kajh6SHHSUMp02fAq5m5g@mail.gmail.com>
 <20200127160413.GI13647@lunn.ch>
 <CA+h21hoZVDFANhzP5BOkZ+HxLMg9=pcdmLbaavg-1CpDEq=CHg@mail.gmail.com>
In-Reply-To: <CA+h21hoZVDFANhzP5BOkZ+HxLMg9=pcdmLbaavg-1CpDEq=CHg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 11da133e-458a-4b90-5966-08d7a49afb74
x-ms-traffictypediagnostic: DB8PR04MB6731:|DB8PR04MB6731:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB67316D46C061214A1CB4A369AD050@DB8PR04MB6731.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02973C87BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(189003)(199004)(76116006)(66446008)(64756008)(66556008)(66946007)(66476007)(478600001)(33656002)(2906002)(53546011)(26005)(186003)(81166006)(4326008)(81156014)(6506007)(9686003)(8676002)(5660300002)(71200400001)(7696005)(8936002)(55016002)(110136005)(52536014)(54906003)(86362001)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6731;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HAfM4CET1ePmorj7VbL+A3KdVY3gySisyV8kOhPK48b5QfYwfvbNbqZPf+R4JxCtWQ0Aw3ymMpYxuuH64stT6Ih2A2AOdm/PkW9EQ3wfLymXmJ9dcDLdBKR3kDGjPCM83zNm4rAqwlT2R3whB1AQ7/vN60zvhHQ8Rx0oW1g3reLrzY5qT4+iW8zpgR4h4FmlFQVXQE7Pm/I0zupQFkqagYQUrSz5t3ytx13sTImzF7aWl4IvovjzSYn905N2wo/OuSfy7+0eemJPFHym/9B93Xe7fklNCECz1icvZ1HaV6ciFHm0HVaYwV7A2FOPdciUcS1byX/CdAJGfav06hJQWFVB1M8SAput8jYrKpMPHCobB3fmLZ76p47jVMR/HdLaI72/hPfnO2zhqfx7ymYh4PsW2v1BThbMIkcyFpD3v8GV9h+BaSKLIQoO9zUUJkXc
x-ms-exchange-antispam-messagedata: zx41ea/eC3xuILl69nhcuUNlFLSSlSlJTIzOlob/DH1Ah+b+3WyKEk6xN61Q2puqq9FNBIR0PML8+XYAXYpJmHjEz4ROPvwNLxA1NJsEgbwyjFZgW4iKgLxbfG9v7q84EJdloGBlHmfO2enaupI0YQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11da133e-458a-4b90-5966-08d7a49afb74
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2020 09:09:44.6122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ErO6cC/J4/lhjho40PBTn4U668X6owxrjEhVTYfap8VCbzA0nck+sqDQUOOTycVugAk62WfASHPIQ3mjQ6YIaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6731
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBWbGFkaW1pciBPbHRlYW4gPG9s
dGVhbnZAZ21haWwuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBKYW51YXJ5IDI4LCAyMDIwIDU6NDIg
UE0NCj4gVG86IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gQ2M6IE1hZGFsaW4gQnVj
dXIgKE9TUykgPG1hZGFsaW4uYnVjdXJAb3NzLm54cC5jb20+OyBEYXZpZCBTLiBNaWxsZXINCj4g
PGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWls
LmNvbT47IEhlaW5lcg0KPiBLYWxsd2VpdCA8aGthbGx3ZWl0MUBnbWFpbC5jb20+OyBuZXRkZXYg
PG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+Ow0KPiB5a2F1a2FiQHN1c2UuZGUNCj4gU3ViamVjdDog
UmU6IFtQQVRDSCB2MiAyLzJdIGRwYWFfZXRoOiBzdXBwb3J0IGFsbCBtb2RlcyB3aXRoIHJhdGUN
Cj4gYWRhcHRpbmcgUEhZcw0KPiANCj4gSGkgQW5kcmV3LA0KPiANCj4gT24gTW9uLCAyNyBKYW4g
MjAyMCBhdCAxODowNCwgQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPiB3cm90ZToNCj4gPg0K
PiA+ID4gSXMgdGhpcyBzdWZmaWNpZW50Pw0KPiA+ID4gSSBzdXBwb3NlIHRoaXMgd29ya3MgYmVj
YXVzZSB5b3UgaGF2ZSBmbG93IGNvbnRyb2wgZW5hYmxlZCBieQ0KPiBkZWZhdWx0Pw0KPiA+ID4g
V2hhdCB3b3VsZCBoYXBwZW4gaWYgdGhlIHVzZXIgd291bGQgZGlzYWJsZSBmbG93IGNvbnRyb2wg
d2l0aA0KPiBldGh0b29sPw0KPiA+DQo+ID4gSXQgd2lsbCBzdGlsbCB3b3JrLiBOZXR3b3JrIHBy
b3RvY29scyBleHBlY3QgcGFja2V0cyB0byBiZSBkcm9wcGVkLA0KPiA+IHRoZXJlIGFyZSBib3R0
bGVuZWNrcyBvbiB0aGUgbmV0d29yaywgYW5kIHRob3NlIGJvdHRsZW5lY2tzIGNoYW5nZQ0KPiA+
IGR5bmFtaWNhbGx5LiBUQ1Agd2lsbCBzdGlsbCBiZSBhYmxlIHRvIGRldGVybWluZSBob3cgbXVj
aCB0cmFmZmljIGl0DQo+ID4gY2FuIHNlbmQgd2l0aG91dCB0b28gbXVjaCBwYWNrZXQgbG9zcywg
aW5kZXBlbmRlbnQgb2YgaWYgdGhlDQo+ID4gYm90dGxlbmVjayBpcyBoZXJlIGJldHdlZW4gdGhl
IE1BQyBhbmQgdGhlIFBIWSwgb3IgbGF0ZXIgd2hlbiBpdCBoaXRzDQo+ID4gYW4gUkZDIDExNDkg
bGluay4NCj4gDQo+IEZvbGxvd2luZyB0aGlzIGxvZ2ljLCB0aGlzIHBhdGNoIGlzbid0IG5lZWRl
ZCBhdCBhbGwsIHJpZ2h0PyBUaGUgUEhZDQo+IHdpbGwgZHJvcCBmcmFtZXMgdGhhdCBpdCBjYW4n
dCBob2xkIGluIGl0cyBzbWFsbCBGSUZPcyB3aGVuIGFkYXB0aW5nIGENCj4gbGluayBzcGVlZCB0
byBhbm90aGVyLCBhbmQgaGlnaGVyLWxldmVsIHByb3RvY29scyB3aWxsIGNvcGUuIEFuZCBmbG93
DQo+IGNvbnRyb2wgYXQgbGFyZ2UgaXNuJ3QgbmVlZGVkLg0KDQpJJ20gYWZyYWlkIHlvdSBtaXNz
ZWQgdGhlIHBhdGNoIGRlc2NyaXB0aW9uIHRoYXQgZXhwbGFpbnMgdGhlcmUgd2lsbCBiZQ0Kbm8g
bGluayB3aXRoIGEgMUcgcGFydG5lciB3aXRob3V0IHRoaXMgY2hhbmdlOg0KDQo8PCBBZnRlciB0
aGlzDQpjb21taXQsIHRoZSBtb2RlcyByZW1vdmVkIGJ5IHRoZSBkcGFhX2V0aCBkcml2ZXIgd2Vy
ZSBubyBsb25nZXINCmFkdmVydGlzZWQgdGh1cyBhdXRvbmVnb3RpYXRpb24gd2l0aCAxRyBsaW5r
IHBhcnRuZXJzIGZhaWxlZC4+Pg0KDQo+IFdoYXQgSSB3YXMgdHJ5aW5nIHRvIHNlZSBNYWRhbGlu
J3Mgb3BpbmlvbiBvbiB3YXMgd2hldGhlciBpbiBmYWN0IHdlDQo+IHdhbnQgdG8ga2VlcCB0aGUg
UlggZmxvdyBjb250cm9sIGFzICdmaXhlZCBvbicgaWYgdGhlIE1BQyBzdXBwb3J0cyBpdA0KPiBh
bmQgdGhlIFBIWSBuZWVkcyBpdCwgX2FzIGEgZnVuY3Rpb24gb2YgdGhlIGN1cnJlbnQgcGh5X21v
ZGUgYW5kIG1heWJlDQo+IGxpbmsgc3BlZWRfICh0aGUgdW5kZXJsaW5lZCBwYXJ0IGlzIGltcG9y
dGFudCBJTU8pLg0KDQpUaGF0J3MgYSBzZXBhcmF0ZSBjb25jZXJuLCBieSBkZWZhdWx0IGFsbCBp
cyBmaW5lLCBzaG91bGQgdGhlIHVzZXIgd2FudCB0bw0Kc2hvb3QgaGltc2VsZiBpbiB0aGUgZm9v
dCwgd2UgbWF5IG5lZWQgdG8gYWxsb3cgaGltIHRvIGRvIGl0Lg0KDQo+ID4NCj4gPiAgICAgQW5k
cmV3DQo+ID4NCj4gDQo+IFRoYW5rcywNCj4gLVZsYWRpbWlyDQo=
