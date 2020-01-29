Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF5914C925
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 11:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgA2K6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 05:58:40 -0500
Received: from mail-eopbgr70088.outbound.protection.outlook.com ([40.107.7.88]:61134
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726069AbgA2K6j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 05:58:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SApNiEMC1pg5MHI/zzq6b46pItE6wsT8XzPIvsh3vCwJmr7TJJ1kFKD0P+ir3kn8v/QuIL+1h2oon1E3uBkFGQ76Bzr/tcsIJ4MQ0M9SaVFxMUj1qgEI/Z2DkEkvEQGEaqWU3vrD1V0Gyg+iORJeSMakwuBokerN/B3KHNNUxNFZ2WgrTa84jJtuM1G8SUcEYemY+Boj3SXeUuq18dhifNFuYH0OaKMBckg3oGDfW51Ysfr+v/mcU5Afe34kQCSWWX2+dT8LWHkgbBCYPYClAzaTJ2rAQpFHRDtcZ4SF4SNl1tPi/9F5z2Nh29GVCH+VvozDz3bDv6MNMnuYfcHFoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9EQuK5C8nwXZGuKS1/i3cpmoe+Fe39KLswSMatNDc/8=;
 b=Oa+ixRAgOBzq8N9fDGlIcSAcEpIcCFBNgeY9Qjsy8HVxothzrNLvDif0S/UsUEo4T9uYH+9dNKFD/sIEfhjDL1egEBWIgJv2M1g6xnsl0IfPGWM8OE1MUzonvzRO0LwMsQ80XSQ+K0za1BtgG/96+tJsarrkT1h3I8Q1HOyH06GyNOaoW7doqF4uVepJFOl9MbydmyncpbHCBmdID1LmH1EMOVBoGhB6HcRSazMc4Cb6yNx8gqCYA2k9xBIjC+58kd7z0kXL1c5xTMCyVhxDMh2D2soDGRPjyy8AmFCR38mL/feWyfhWa9jV3fZKit0dEdS1GFYJybleqRO5ozrl8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9EQuK5C8nwXZGuKS1/i3cpmoe+Fe39KLswSMatNDc/8=;
 b=OyhnkzunWdkk47u0MWqsh5K6HWFB49WtahfiTPcTgOpZCu5nzZMK/JpQEC7nXr0XGJZPCohax0PlHiaBE7qUiZaltNfQ7r8JMyZ1OoSKKywcmMUQQw1OuFoV9tFrwcjVUshGS2YpkyvV9AKLRWmw39ibdZO+kNtTg6PueRryVl4=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB6652.eurprd04.prod.outlook.com (20.179.250.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Wed, 29 Jan 2020 10:58:20 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3%6]) with mapi id 15.20.2665.027; Wed, 29 Jan 2020
 10:58:20 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "ykaukab@suse.de" <ykaukab@suse.de>
Subject: RE: [PATCH v2 2/2] dpaa_eth: support all modes with rate adapting
 PHYs
Thread-Topic: [PATCH v2 2/2] dpaa_eth: support all modes with rate adapting
 PHYs
Thread-Index: AQHV1SOT4TVxn3QCwU2UHzdlmVFpwqf+o0+AgAAJP4CAAYv9gIABC37wgAAs2gCAAAlyQA==
Date:   Wed, 29 Jan 2020 10:58:20 +0000
Message-ID: <DB8PR04MB6985DE7A9C1FA9BD9D61355EEC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1580137671-22081-3-git-send-email-madalin.bucur@oss.nxp.com>
 <CA+h21hqzR72v9=dWGk1zBptNHNst+kajh6SHHSUMp02fAq5m5g@mail.gmail.com>
 <20200127160413.GI13647@lunn.ch>
 <CA+h21hoZVDFANhzP5BOkZ+HxLMg9=pcdmLbaavg-1CpDEq=CHg@mail.gmail.com>
 <DB8PR04MB698504E07E288BB5BD79BD38EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <CA+h21hpQ48x8mm5JNOH5ijZg-EnFxXAd8RoX4eizhr96BycKPA@mail.gmail.com>
In-Reply-To: <CA+h21hpQ48x8mm5JNOH5ijZg-EnFxXAd8RoX4eizhr96BycKPA@mail.gmail.com>
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
x-ms-office365-filtering-correlation-id: 66aa966b-0062-43b4-32ca-08d7a4aa2765
x-ms-traffictypediagnostic: DB8PR04MB6652:|DB8PR04MB6652:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6652A857A894668B7D004211AD050@DB8PR04MB6652.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02973C87BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(189003)(199004)(7696005)(52536014)(6506007)(53546011)(4326008)(478600001)(5660300002)(64756008)(71200400001)(86362001)(81156014)(81166006)(66476007)(186003)(33656002)(8936002)(66946007)(66556008)(2906002)(66446008)(316002)(110136005)(26005)(54906003)(55016002)(8676002)(76116006)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6652;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8fvKNZV4AMsGZwu2KCSUKeGzZQldgTw4mUPNO8m/B/OFoTkmZ33Hej67r8lgd8is7wmimNo3Ns/Daa9D1eVS5sWWO0hY4hzGgzc/ALn9cubPfGRjvINInb2ziuKNlF7mBmNlnKGs70TVroXjKIjwE2+Ey1ymsZh3k6CZkjRw4xeuXpw4g5Mjly3plMAoxy+ol98YGR6e3gmHDwdfSXj8nZmk3fDTb8EFf+N736hrz/aFNJFUeUQXBTsEn3U7CAUDNKEJ7GzbIXOSRyUSUSzYVzwwVMVghmqiAMg0jwDlFkxMOSRUP/LRdHB+8YYLPw2bCf2zFY7+v2O0EtKDAmbcYyHhzedV1dbJGrf4ghJ+K3EQYq20f9ZG1fhzKB7TUVc39BZ7CqL/qKo8I6kaL9RobVCzBw8Lhi8nQ86mwUZerpILHvgHDPxHlrtWNll23n/d
x-ms-exchange-antispam-messagedata: eb3kkBP9Ja5MBqky6Qxhc3KnxVobGGN8yQFqM9nUdt47gm4bBiLF/yuY5133rdgO5jK5JwurshrNDchEqH57V3RwmYqqoZxMr9KxkdqTUdsmJwKUL8Iot+iz/PXCYFd7aKvmv+Vr1Ts53PvnYK0fsg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66aa966b-0062-43b4-32ca-08d7a4aa2765
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2020 10:58:20.7737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8yqB7RnQ226fSEQUAtN7h8D1ha3e/gpuQMPd3VM6A4O806Ri9ILVV6PIKLvQLOL+2EEwUJkD5yKtRuhdB0yhmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6652
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBWbGFkaW1pciBPbHRlYW4gPG9s
dGVhbnZAZ21haWwuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIEphbnVhcnkgMjksIDIwMjAgMTI6
MTkgUE0NCj4gVG86IE1hZGFsaW4gQnVjdXIgKE9TUykgPG1hZGFsaW4uYnVjdXJAb3NzLm54cC5j
b20+DQo+IENjOiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+OyBEYXZpZCBTLiBNaWxsZXIg
PGRhdmVtQGRhdmVtbG9mdC5uZXQ+Ow0KPiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdt
YWlsLmNvbT47IEhlaW5lciBLYWxsd2VpdA0KPiA8aGthbGx3ZWl0MUBnbWFpbC5jb20+OyBuZXRk
ZXYgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyB5a2F1a2FiQHN1c2UuZGUNCj4gU3ViamVjdDog
UmU6IFtQQVRDSCB2MiAyLzJdIGRwYWFfZXRoOiBzdXBwb3J0IGFsbCBtb2RlcyB3aXRoIHJhdGUN
Cj4gYWRhcHRpbmcgUEhZcw0KPiANCj4gSGkgTWFkYWxpbiwNCj4gDQo+IE9uIFdlZCwgMjkgSmFu
IDIwMjAgYXQgMTE6MDksIE1hZGFsaW4gQnVjdXIgKE9TUykNCj4gPG1hZGFsaW4uYnVjdXJAb3Nz
Lm54cC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
PiA+ID4gRnJvbTogVmxhZGltaXIgT2x0ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT4NCj4gPiA+IFNl
bnQ6IFR1ZXNkYXksIEphbnVhcnkgMjgsIDIwMjAgNTo0MiBQTQ0KPiA+ID4gVG86IEFuZHJldyBM
dW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gPiA+IENjOiBNYWRhbGluIEJ1Y3VyIChPU1MpIDxtYWRh
bGluLmJ1Y3VyQG9zcy5ueHAuY29tPjsgRGF2aWQgUy4gTWlsbGVyDQo+ID4gPiA8ZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldD47IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPjsNCj4g
SGVpbmVyDQo+ID4gPiBLYWxsd2VpdCA8aGthbGx3ZWl0MUBnbWFpbC5jb20+OyBuZXRkZXYgPG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc+Ow0KPiA+ID4geWthdWthYkBzdXNlLmRlDQo+ID4gPiBTdWJq
ZWN0OiBSZTogW1BBVENIIHYyIDIvMl0gZHBhYV9ldGg6IHN1cHBvcnQgYWxsIG1vZGVzIHdpdGgg
cmF0ZQ0KPiA+ID4gYWRhcHRpbmcgUEhZcw0KPiA+ID4NCj4gPiA+IEhpIEFuZHJldywNCj4gPiA+
DQo+ID4gPiBPbiBNb24sIDI3IEphbiAyMDIwIGF0IDE4OjA0LCBBbmRyZXcgTHVubiA8YW5kcmV3
QGx1bm4uY2g+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPiA+IElzIHRoaXMgc3VmZmljaWVudD8N
Cj4gPiA+ID4gPiBJIHN1cHBvc2UgdGhpcyB3b3JrcyBiZWNhdXNlIHlvdSBoYXZlIGZsb3cgY29u
dHJvbCBlbmFibGVkIGJ5DQo+ID4gPiBkZWZhdWx0Pw0KPiA+ID4gPiA+IFdoYXQgd291bGQgaGFw
cGVuIGlmIHRoZSB1c2VyIHdvdWxkIGRpc2FibGUgZmxvdyBjb250cm9sIHdpdGgNCj4gPiA+IGV0
aHRvb2w/DQo+ID4gPiA+DQo+ID4gPiA+IEl0IHdpbGwgc3RpbGwgd29yay4gTmV0d29yayBwcm90
b2NvbHMgZXhwZWN0IHBhY2tldHMgdG8gYmUgZHJvcHBlZCwNCj4gPiA+ID4gdGhlcmUgYXJlIGJv
dHRsZW5lY2tzIG9uIHRoZSBuZXR3b3JrLCBhbmQgdGhvc2UgYm90dGxlbmVja3MgY2hhbmdlDQo+
ID4gPiA+IGR5bmFtaWNhbGx5LiBUQ1Agd2lsbCBzdGlsbCBiZSBhYmxlIHRvIGRldGVybWluZSBo
b3cgbXVjaCB0cmFmZmljDQo+IGl0DQo+ID4gPiA+IGNhbiBzZW5kIHdpdGhvdXQgdG9vIG11Y2gg
cGFja2V0IGxvc3MsIGluZGVwZW5kZW50IG9mIGlmIHRoZQ0KPiA+ID4gPiBib3R0bGVuZWNrIGlz
IGhlcmUgYmV0d2VlbiB0aGUgTUFDIGFuZCB0aGUgUEhZLCBvciBsYXRlciB3aGVuIGl0DQo+IGhp
dHMNCj4gPiA+ID4gYW4gUkZDIDExNDkgbGluay4NCj4gPiA+DQo+ID4gPiBGb2xsb3dpbmcgdGhp
cyBsb2dpYywgdGhpcyBwYXRjaCBpc24ndCBuZWVkZWQgYXQgYWxsLCByaWdodD8gVGhlIFBIWQ0K
PiA+ID4gd2lsbCBkcm9wIGZyYW1lcyB0aGF0IGl0IGNhbid0IGhvbGQgaW4gaXRzIHNtYWxsIEZJ
Rk9zIHdoZW4gYWRhcHRpbmcNCj4gYQ0KPiA+ID4gbGluayBzcGVlZCB0byBhbm90aGVyLCBhbmQg
aGlnaGVyLWxldmVsIHByb3RvY29scyB3aWxsIGNvcGUuIEFuZCBmbG93DQo+ID4gPiBjb250cm9s
IGF0IGxhcmdlIGlzbid0IG5lZWRlZC4NCj4gPg0KPiA+IEknbSBhZnJhaWQgeW91IG1pc3NlZCB0
aGUgcGF0Y2ggZGVzY3JpcHRpb24gdGhhdCBleHBsYWlucyB0aGVyZSB3aWxsIGJlDQo+ID4gbm8g
bGluayB3aXRoIGEgMUcgcGFydG5lciB3aXRob3V0IHRoaXMgY2hhbmdlOg0KPiA+DQo+IA0KPiBT
byB3aHkgbm90IGp1c3QgcmVtb3ZlIHRoYXQgbGlua21vZGVfYW5kKCkgYXQgYWxsLCB0aGVuPw0K
PiBXaGF0IGlzIGl0IHRyeWluZyB0byBhY2NvbXBsaXNoLCBhbnl3YXk/IEF2b2lkaW5nIHRoZSB1
c2VyIGZyb20NCj4gc2hvb3RpbmcgdGhlbXNlbHZlcyBpbiB0aGUgZm9vdCBtYXliZT8NCg0KSWYg
eW91IHdvdWxkIHRha2UgdGhlIHRpbWUgdG8gcmVhZCB0aGUgcGF0Y2ggc2V0LCBJIHRoaW5rIGl0
IHdvdWxkIGJlIGNsZWFyDQp0aGF0IG5vLCBJIGRvIG5vdCBpbnRlbmQgdG8gcmVtb3ZlIHRoYXQg
YWx0b2dldGhlciwgYnV0IG9ubHkgd2hlbiB0aGUgUEhZDQpjYW4gbWFrZSB0aGUgZGlmZmVyZW50
IG1vZGVzIHdvcmsgYnkgcGVyZm9ybWluZyByYXRlIGFkYXB0YXRpb24uDQoNCj4gPiA8PCBBZnRl
ciB0aGlzDQo+ID4gY29tbWl0LCB0aGUgbW9kZXMgcmVtb3ZlZCBieSB0aGUgZHBhYV9ldGggZHJp
dmVyIHdlcmUgbm8gbG9uZ2VyDQo+ID4gYWR2ZXJ0aXNlZCB0aHVzIGF1dG9uZWdvdGlhdGlvbiB3
aXRoIDFHIGxpbmsgcGFydG5lcnMgZmFpbGVkLj4+DQo+ID4NCj4gPiA+IFdoYXQgSSB3YXMgdHJ5
aW5nIHRvIHNlZSBNYWRhbGluJ3Mgb3BpbmlvbiBvbiB3YXMgd2hldGhlciBpbiBmYWN0IHdlDQo+
ID4gPiB3YW50IHRvIGtlZXAgdGhlIFJYIGZsb3cgY29udHJvbCBhcyAnZml4ZWQgb24nIGlmIHRo
ZSBNQUMgc3VwcG9ydHMgaXQNCj4gPiA+IGFuZCB0aGUgUEhZIG5lZWRzIGl0LCBfYXMgYSBmdW5j
dGlvbiBvZiB0aGUgY3VycmVudCBwaHlfbW9kZSBhbmQNCj4gbWF5YmUNCj4gPiA+IGxpbmsgc3Bl
ZWRfICh0aGUgdW5kZXJsaW5lZCBwYXJ0IGlzIGltcG9ydGFudCBJTU8pLg0KPiA+DQo+ID4gVGhh
dCdzIGEgc2VwYXJhdGUgY29uY2VybiwgYnkgZGVmYXVsdCBhbGwgaXMgZmluZSwgc2hvdWxkIHRo
ZSB1c2VyIHdhbnQNCj4gdG8NCj4gPiBzaG9vdCBoaW1zZWxmIGluIHRoZSBmb290LCB3ZSBtYXkg
bmVlZCB0byBhbGxvdyBoaW0gdG8gZG8gaXQuDQo+ID4+ID4gPg0KPiA+ID4gPiAgICAgQW5kcmV3
DQo+ID4gPiA+DQo+ID4gPg0KPiA+ID4gVGhhbmtzLA0KPiA+ID4gLVZsYWRpbWlyDQo+IA0KPiAt
VmxhZGltaXINCg==
