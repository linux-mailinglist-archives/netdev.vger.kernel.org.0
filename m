Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D446163B59
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgBSDdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:33:21 -0500
Received: from mail-eopbgr60083.outbound.protection.outlook.com ([40.107.6.83]:51560
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726446AbgBSDdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:33:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+gbAtjPTXlnK66ayBUTiK9tYc47vYQS8/LlO+RjAIxrDxgAYnf7unDH5AhKpMmYmQSqb6qiJ5xqA2p5+CPqmuTYeiG0rX9j7g/jt9IYkp1iPPh4DDUvTlkKGtfHRJrha9vhTX9M30Nj9R+gVR+LWoPvBcMDB6rPzwZHOVwPUX6D3uKr4yofJOxzeDdJmgLz0vMNa9fvGer79cVTRBfmjaoCePT7oQxIpcpy+HIj/Ee/tQ9Im/MZWPqV7TZSse58/X5ZBuQ5jLdBxpNkZaKHxWdDdA/zoE7ocyB2/5aiI9wpUta+UGKdYID/ht7XakXErAX0vM49YiIE544/ihs/tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mrPv+sGnrjaACQFiTR4yTigFZSFQnNuor7YcAu1iAs=;
 b=A2DJ9BaV/rBs3TJW9ZWGGyKpEVmuHpPxDX+LL4br9+nNqNM6sc89/FQWMUFCWvMkPxqz/Kgj96Msw+SRwNpzWdwPw+1DobRqJdW/CMOJnIHetDoimq09q1awCFYDdPUrhzRMFwUsj5SFM7BcSvHOoD7AzUYApYL24P0wl9DOQAh+ao+tf2Jy83h7xeHaIgwN93SqAp3uqEBIFoqq0nrf7XXzQ43E+6R1N5tlEsiQoLYGMBENEBLofy+o0PlffUFY4+aPlfC8YFRK9ShwEr4X0ooTCdRo7hy6t+2ddOVxEGM/rejKYbuYL9REWtI4IKA/z+C50tA3L2v/6XPfvGjdjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mrPv+sGnrjaACQFiTR4yTigFZSFQnNuor7YcAu1iAs=;
 b=b9vy0uLGPlrl04Blpy7INr4fs1FW+qTwb3emAiqsAd3u4ewiWb4MQfxAJjDrQs1IDAPw1rw/0Iah+sZg137KMFum2jd4lVtZkOjFckZNJzdpjpjcPC18hzqRMsDMLQnQsoaJGaYUS2LTETscXSgIKj7Joyl1cwHQ9drwKIs1euY=
Received: from VI1PR04MB5135.eurprd04.prod.outlook.com (20.177.52.139) by
 VI1PR04MB3071.eurprd04.prod.outlook.com (10.170.225.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Wed, 19 Feb 2020 03:33:14 +0000
Received: from VI1PR04MB5135.eurprd04.prod.outlook.com
 ([fe80::ed73:9d46:d34:5e19]) by VI1PR04MB5135.eurprd04.prod.outlook.com
 ([fe80::ed73:9d46:d34:5e19%6]) with mapi id 15.20.2729.032; Wed, 19 Feb 2020
 03:33:14 +0000
From:   "Pankaj Bansal (OSS)" <pankaj.bansal@oss.nxp.com>
To:     Robin Murphy <robin.murphy@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC:     Hanjun Guo <guohanjun@huawei.com>, Marc Zyngier <maz@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Calvin Johnson <calvin.johnson@nxp.com>,
        "stuyoder@gmail.com" <stuyoder@gmail.com>,
        "nleeder@codeaurora.org" <nleeder@codeaurora.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Will Deacon <will@kernel.org>,
        "jon@solid-run.com" <jon@solid-run.com>,
        Russell King <linux@armlinux.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andy Wang <Andy.Wang@arm.com>, Varun Sethi <V.Sethi@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Paul Yang <Paul.Yang@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: RE: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Thread-Topic: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Thread-Index: AQHV5lZ7Xi36FCZsh0O+fGt3c05hNagg5R2wgAAiuoCAAAf0gIAAzAKA
Date:   Wed, 19 Feb 2020 03:33:14 +0000
Message-ID: <VI1PR04MB51357487F1AD6987B3641356B0100@VI1PR04MB5135.eurprd04.prod.outlook.com>
References: <VI1PR04MB5135D7D8597D33DB76DA05BDB0110@VI1PR04MB5135.eurprd04.prod.outlook.com>
 <615c6807-c018-92c9-b66a-8afdda183699@huawei.com>
 <VI1PR04MB513558BF77192255CBE12102B0110@VI1PR04MB5135.eurprd04.prod.outlook.com>
 <20200218144653.GA4286@e121166-lin.cambridge.arm.com>
 <2762bb26-967d-3410-d250-a63d8d755d76@arm.com>
In-Reply-To: <2762bb26-967d-3410-d250-a63d8d755d76@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pankaj.bansal@oss.nxp.com; 
x-originating-ip: [49.36.133.139]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 63ffd350-140b-4393-c015-08d7b4ec73e8
x-ms-traffictypediagnostic: VI1PR04MB3071:|VI1PR04MB3071:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB3071DE26A534E0F7313ADC67B0100@VI1PR04MB3071.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(199004)(189003)(9686003)(966005)(55016002)(7696005)(71200400001)(2906002)(478600001)(86362001)(52536014)(66476007)(316002)(4326008)(110136005)(7416002)(33656002)(8676002)(8936002)(54906003)(26005)(76116006)(66946007)(66556008)(81156014)(53546011)(5660300002)(66446008)(6506007)(64756008)(81166006)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB3071;H:VI1PR04MB5135.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: spGuswZD3WwO2Yx248+S4MvsblKdWKBq4TDvkdiRayNbH06gRgu/lpPg7NYVR58QycR6ra9c2P7UMLOXoc2orZUAs8qrYs/X4fsYcxdBSWI1oZVDKBHCW0FozTi1okrinjmFo+4uliF1glY2kG6D+Ym6Wlh1i8RLPB0KPxun1h5aznaAx11KivHvNkicS9Rl70YxM9HMGBRHCvefb5NouHevE+ekGc9zW3QyCZVwUDgtz3N+jXHpags/Zk5K4OWVloMHah1kUFVmhhwCOgqIp96fqFMHw/78hLS6ToCI1PTKFJhddARg7rfrh6p0E6VM4I0hLQdCZTk7uk/ekVhi4wiF4rzub65HDwt/Krsm+mskRqInCBCIvWp9i15RFeV6ibqhbUTP0yxMd8rKnoUKsV8slmedVp7XZT0NOfPYOYzJ2Z8LFF5WUtNq7K8L1vIj7uRDLMoAyvmjJrpMPH1ldbwLbzwFLuZyyvGWj9hunLVNZovAOBXy//yuZFw1h+YEZEILTs9BNPwM43bFKDUdWw==
x-ms-exchange-antispam-messagedata: feS4RcDvJvoruNhCRlnb2jJEs6B85LEDk5sYrtBNUw/6eWgUqIrob1n/tfqgnHTUJG0JtqKIVWtztyIOfrmOiBOUIfoHO/oYNb1xK2+0xa10ivSjqlrCZ1VadINyXCbs8rO0XOh+yKq7EJJjn7g7/A==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63ffd350-140b-4393-c015-08d7b4ec73e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:33:14.5150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0o03Sb9w+ZD7GGMUePcp8kEkt/XbzU6E4ZNcVB4g3N01khmv3585+jJRT72cdHXQAQpETn5kB7otz24XxusWREsXLVVp3Z10m1zxghAATL+8ZF72+6WTU94eQf9X3e5v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3071
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gT24gMTgvMDIvMjAyMCAyOjQ2IHBtLCBMb3JlbnpvIFBpZXJhbGlzaSB3cm90ZToNCj4g
PiBPbiBUdWUsIEZlYiAxOCwgMjAyMCBhdCAxMjo0ODozOVBNICswMDAwLCBQYW5rYWogQmFuc2Fs
IChPU1MpIHdyb3RlOg0KPiA+DQo+ID4gWy4uLl0NCj4gPg0KPiA+Pj4+IEluIERUIGNhc2UsIHdl
IGNyZWF0ZSB0aGUgZG9tYWluIERPTUFJTl9CVVNfRlNMX01DX01TSSBmb3IgTUMgYnVzDQo+IGFu
ZA0KPiA+Pj4gaXQncyBjaGlsZHJlbi4NCj4gPj4+PiBBbmQgdGhlbiB3aGVuIE1DIGNoaWxkIGRl
dmljZSBpcyBjcmVhdGVkLCB3ZSBzZWFyY2ggdGhlICJtc2ktcGFyZW50Ig0KPiA+Pj4gcHJvcGVy
dHkgZnJvbSB0aGUgTUMNCj4gPj4+PiBEVCBub2RlIGFuZCBnZXQgdGhlIElUUyBhc3NvY2lhdGVk
IHdpdGggTUMgYnVzLiBUaGVuIHdlIHNlYXJjaA0KPiA+Pj4gRE9NQUlOX0JVU19GU0xfTUNfTVNJ
DQo+ID4+Pj4gb24gdGhhdCBJVFMuIE9uY2Ugd2UgZmluZCB0aGUgZG9tYWluLCB3ZSBjYW4gY2Fs
bCBtc2lfZG9tYWluX2FsbG9jX2lycXMNCj4gZm9yDQo+ID4+PiB0aGF0IGRvbWFpbi4NCj4gPj4+
Pg0KPiA+Pj4+IFRoaXMgaXMgZXhhY3RseSB3aGF0IHdlIHRyaWVkIHRvIGRvIGluaXRpYWxseSB3
aXRoIEFDUEkuIEJ1dCB0aGUgc2VhcmNoaW5nDQo+ID4+PiBET01BSU5fQlVTX0ZTTF9NQ19NU0kN
Cj4gPj4+PiBhc3NvY2lhdGVkIHRvIGFuIElUUywgaXMgc29tZXRoaW5nIHRoYXQgaXMgcGFydCBv
ZiBkcml2ZXJzL2FjcGkvYXJtNjQvaW9ydC5jLg0KPiA+Pj4+IChzaW1pbGFyIHRvIERPTUFJTl9C
VVNfUExBVEZPUk1fTVNJIGFuZCBET01BSU5fQlVTX1BDSV9NU0kpDQo+ID4+Pg0KPiA+Pj4gQ2Fu
IHlvdSBoYXZlIGEgbG9vayBhdCBtYmlnZW4gZHJpdmVyIChkcml2ZXJzL2lycWNoaXAvaXJxLW1i
aWdlbi5jKSB0byBzZWUgaWYNCj4gPj4+IGl0IGhlbHBzIHlvdT8NCj4gPj4+DQo+ID4+PiBtYmln
ZW4gaXMgYW4gaXJxIGNvbnZlcnRlciB0byBjb252ZXJ0IGRldmljZSdzIHdpcmVkIGludGVycnVw
dHMgaW50byBNU0kNCj4gPj4+IChjb25uZWN0aW5nIHRvIElUUyksIHdoaWNoIHdpbGwgYWxsb2Mg
YSBidW5jaCBvZiBNU0lzIGZyb20gSVRTIHBsYXRmb3JtIE1TSQ0KPiA+Pj4gZG9tYWluIGF0IHRo
ZSBzZXR1cC4NCj4gPj4NCj4gPj4gVW5mb3J0dW5hdGVseSB0aGlzIGlzIG5vdCB0aGUgc2FtZSBj
YXNlIGFzIG91cnMuIEFzIEkgc2VlIEhpc2lsaWNvbiBJT1JUIHRhYmxlDQo+ID4+IElzIHVzaW5n
IHNpbmdsZSBpZCBtYXBwaW5nIHdpdGggbmFtZWQgY29tcG9uZW50cy4NCj4gPj4NCj4gPj4gaHR0
cHM6Ly9naXRodWIuY29tL3RpYW5vY29yZS9lZGsyLQ0KPiBwbGF0Zm9ybXMvYmxvYi9tYXN0ZXIv
U2lsaWNvbi9IaXNpbGljb24vSGkxNjE2L0QwNUFjcGlUYWJsZXMvRDA1SW9ydC5hc2wjTDMwDQo+
IDANCj4gPj4NCj4gPj4gd2hpbGUgd2UgYXJlIG5vdDoNCj4gPj4NCj4gPj4gaHR0cHM6Ly9zb3Vy
Y2UuY29kZWF1cm9yYS5vcmcvZXh0ZXJuYWwvcW9yaXEvcW9yaXEtY29tcG9uZW50cy9lZGsyLQ0K
PiBwbGF0Zm9ybXMvdHJlZS9QbGF0Zm9ybS9OWFAvTFgyMTYwYVJkYlBrZy9BY3BpVGFibGVzL0lv
cnQuYXNsYz9oPUxYMjE2MF8NCj4gVUVGSV9BQ1BJX0VBUjEjbjI5MA0KPiA+Pg0KPiA+PiBUaGlz
IGlzIGJlY2F1c2UgYXMgSSBzYWlkLCB3ZSBhcmUgdHJ5aW5nIHRvIHJlcHJlc2VudCBhIGJ1cyBp
biBJT1JUDQo+ID4+IHZpYSBuYW1lZCBjb21wb25lbnRzIGFuZCBub3QgaW5kaXZpZHVhbCBkZXZp
Y2VzIGNvbm5lY3RlZCB0byB0aGF0IGJ1cy4NCj4gPg0KPiA+IEkgaGFkIGEgdGhvcm91Z2ggbG9v
ayBpbnRvIHRoaXMgYW5kIHN0cmljdGx5IHNwZWFraW5nIHRoZXJlIGlzIG5vDQo+ID4gKm1hcHBp
bmcqIHJlcXVpcmVtZW50IGF0IGFsbCwgYWxsIHlvdSBuZWVkIHRvIGtub3cgaXMgd2hhdCBJVFMg
dGhlIEZTTA0KPiA+IE1DIGJ1cyBpcyBtYXBwaW5nIE1TSXMgdG8uIFdoaWNoIGJyaW5ncyBtZSB0
byB0aGUgbmV4dCBxdWVzdGlvbiAod2hpY2gNCj4gPiBpcyBvcnRob2dvbmFsIHRvIGhvdyB0byBt
b2RlbCBGU0wgTUMgaW4gSU9SVCwgdGhhdCBoYXMgdG8gYmUgZGlzY3Vzc2VkDQo+ID4gYnV0IEkg
d2FudCB0byBoYXZlIGEgZnVsbCBwaWN0dXJlIGluIG1pbmQgZmlyc3QpLg0KPiA+DQo+ID4gV2hl
biB5b3UgcHJvYmUgdGhlIEZTTCBNQyBhcyBhIHBsYXRmb3JtIGRldmljZSwgdGhlIEFDUEkgY29y
ZSwNCj4gPiB0aHJvdWdoIElPUlQgKGlmIHlvdSBhZGQgdGhlIDE6MSBtYXBwaW5nIGFzIGFuIGFy
cmF5IG9mIHNpbmdsZQ0KPiA+IG1hcHBpbmdzKSBhbHJlYWR5IGxpbmsgdGhlIHBsYXRmb3JtIGRl
dmljZSB0byBJVFMgcGxhdGZvcm0NCj4gPiBkZXZpY2UgTVNJIGRvbWFpbiAoYWNwaV9jb25maWd1
cmVfcG1zaV9kb21haW4oKSkuDQo+ID4NCj4gPiBUaGUgYXNzb2NpYXRlZCBmd25vZGUgaXMgdGhl
ICpzYW1lKiAoSUlVQykgYXMgZm9yIHRoZQ0KPiA+IERPTUFJTl9CVVNfRlNMX01DX01TSSBhbmQg
SVRTIERPTUFJTl9CVVNfTkVYVVMsIHNvIGluIHByYWN0aWNlDQo+ID4geW91IGRvbid0IG5lZWQg
SU9SVCBjb2RlIHRvIHJldHJpZXZlIHRoZSBET01BSU5fQlVTX0ZTTF9NQ19NU0kNCj4gPiBkb21h
aW4sIHRoZSBmd25vZGUgaXMgdGhlIHNhbWUgYXMgdGhlIG9uZSBpbiB0aGUgRlNMIE1DIHBsYXRm
b3JtDQo+ID4gZGV2aWNlIElSUSBkb21haW4tPmZ3bm9kZSBwb2ludGVyIGFuZCB5b3UgY2FuIHVz
ZSBpdCB0bw0KPiA+IHJldHJpZXZlIHRoZSBET01BSU5fQlVTX0ZTTF9NQ19NU0kgZG9tYWluIHRo
cm91Z2ggaXQuDQo+ID4NCj4gPiBJcyBteSByZWFkaW5nIGNvcnJlY3QgPw0KPiA+DQo+ID4gT3Zl
cmFsbCwgRE9NQUlOX0JVU19GU0xfTUNfTVNJIGlzIGp1c3QgYW4gTVNJIGxheWVyIHRvIG92ZXJy
aWRlIHRoZQ0KPiA+IHByb3ZpZGUgdGhlIE1TSSBkb21haW4gLT5wcmVwYXJlIGhvb2sgKGllIHRv
IHN0YXNoIHRoZSBNQyBkZXZpY2UgaWQpLCBubw0KPiA+IG1vcmUgKGllIGl0c19mc2xfbWNfbXNp
X3ByZXBhcmUoKSkuDQo+ID4NCj4gPiBUaGF0J3MgaXQgZm9yIHRoZSBNU0kgbGF5ZXIgLSBJIG5l
ZWQgdG8gZmlndXJlIG91dCB3aGV0aGVyIHdlICp3YW50KiB0bw0KPiA+IGV4dGVuZCBJT1JUIChh
bmQvb3IgQUNQSSkgdG8gZGVmaW5lZCBiaW5kaW5ncyBmb3IgImFkZGl0aW9uYWwgYnVzc2VzIiwN
Cj4gPiB3aGF0IEkgd3JpdGUgYWJvdmUgaXMgYSBzdW1tYXJ5IG9mIG15IHVuZGVyc3RhbmRpbmcs
IEkgaGF2ZSBub3QgbWFkZSBteQ0KPiA+IG1pbmQgdXAgeWV0Lg0KPiANCj4gSSdtIHJlYWxseSBu
b3Qgc3VyZSB3ZSdkIG5lZWQgdG8gZ28gbmVhciBhbnkgYmluZGluZ3MgLSB0aGUgSU9SVCBzcGVj
DQo+ICpjYW4qIHJlYXNvbmFibHkgZGVzY3JpYmUgImdpYW50IGJsYWNrIGJveCBvZiBEUEFBMiBz
dHVmZiIgYXMgYSBzaW5nbGUNCj4gbmFtZWQgY29tcG9uZW50LCBhbmQgdGhhdCdzIGFyZ3VhYmx5
IHRoZSBtb3N0IGFjY3VyYXRlIGFic3RyYWN0aW9uDQo+IGFscmVhZHksIGV2ZW4gd2hlbiBpdCBj
b21lcyB0byB0aGUgbmFtZXNwYWNlIGRldmljZS4gVGhpcyBpc24ndCBhIGJ1cyBpbg0KPiBhbnkg
dHJhZGl0aW9uYWwgc2Vuc2UsIGl0J3MgYSBzZXQgb2YgYWNjZWxlcmF0b3IgY29tcG9uZW50cyB3
aXRoIGFuDQo+IGludGVyZmFjZSB0byBkeW5hbWljYWxseSBjb25maWd1cmUgdGhlbSBpbnRvIGN1
c3RvbSBwaXBlbGluZXMsIGFuZCB0aGUNCj4gZXhwZWN0ZWQgdXNlLWNhc2Ugc2VlbXMgdG8gYmUg
Zm9yIHVzZXJzcGFjZSB0byBmcmVlbHkgcmVjb25maWd1cmUNCj4gd2hhdGV2ZXIgdmlydHVhbCBu
ZXR3b3JrIGFkYXB0ZXJzIGl0IHdhbnRzIGF0IGFueSBnaXZlbiB0aW1lLiBUaHVzIEkNCj4gZG9u
J3Qgc2VlIHRoYXQgaXQncyBsb2dpY2FsIG9yIGV2ZW4gcHJhY3RpY2FsIGZvciBmaXJtd2FyZSBp
dHNlbGYgdG8gYmUNCj4gaW52b2x2ZWQgYmV5b25kIGRlc2NyaWJpbmcgImhlcmUncyB5b3VyIHRv
b2xib3giLCBhbmQgaW4gcGFydGljdWxhciwNCj4gYmFzaW5nIGFueSBkZWNpc2lvbnMgb24gdGhl
IHBhcnRpY3VsYXIgd2F5IHRoYXQgRFBBQTIgaGFzIGJlZW4NCj4gc2hvZWhvcm5lZCBpbnRvIHRo
ZSBMaW51eCBkcml2ZXIgbW9kZWwgd291bGQgYWxtb3N0IGNlcnRhaW5seSBiZSBhIHN0ZXANCj4g
aW4gdGhlIHdyb25nIGRpcmVjdGlvbi4NCj4gDQo+IElNTyB0aGUgc2NvcGUgb2YgdGhpcyBpc3N1
ZSBiZWxvbmdzIGVudGlyZWx5IHdpdGhpbiB0aGUNCj4gaW1wbGVtZW50YXRpb24ocykgb2YgTGlu
dXgncyBvd24gYWJzdHJhY3Rpb24gbGF5ZXJzLg0KDQpJIGFncmVlLiBJIHRoaW5rIGZpcnN0IHdl
IG91Z2h0IHRvIGdldCB0aGUgY29uc2Vuc3VzIG9uIGhvdyB0byByZXByZXNlbnQgdGhlIE1DDQpi
dXMgaW4gSU9SVCB0YWJsZS4gQW5kIGl0IHNob3VsZCBub3QgYmUgYmFzZWQgb24gdGhlIGZhY3Qg
dGhhdCAidGhhdCdzIGhvdyB3ZSBoYXZlDQpoYW5kbGVkIElPUlQgaW4gbGludXgiLiBPbmNlIHRo
aXMgaXMgZG9uZSwgdGhlbiB3ZSBjYW4gbW92ZSBmb3J3YXJkIG9uIGhvdyB0bw0KaGFuZGxlIHRo
YXQgaW4gbGludXguDQoNCj4gDQo+IFJvYmluLg0KPiANCj4gPiBBcyBmb3IgdGhlIElPTU1VIGNv
ZGUsIGl0IHNlZW1zIGxpa2UgdGhlIG9ubHkgdGhpbmcgbmVlZGVkIGkNCj4gPiBleHRlbmRpbmcg
bmFtZWQgY29tcG9uZW50cyBjb25maWd1cmF0aW9uIHRvIGNoaWxkIGRldmljZXMsDQo+ID4gaGll
cmFyY2hpY2FsbHkuDQo+ID4NCj4gPiBBcyBNYXJjIGFscmVhZHkgbWVudGlvbmVkLCBJT01NVSBh
bmQgSVJRIGNvZGUgbXVzdCBiZSBzZXBhcmF0ZSBmb3INCj4gPiBmdXR1cmUgcG9zdGluZ3MgYnV0
IGZpcnN0IHdlIG5lZWQgdG8gZmluZCBhIHN1aXRhYmxlIGFuc3dlciB0bw0KPiA+IHRoZSBwcm9i
bGVtIGF0IGhhbmQuDQo+ID4NCj4gPiBMb3JlbnpvDQo+ID4NCg==
