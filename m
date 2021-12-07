Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A47146BF98
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbhLGPlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:41:15 -0500
Received: from mail-eopbgr30073.outbound.protection.outlook.com ([40.107.3.73]:48865
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231250AbhLGPlO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 10:41:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOh9q1QM8XFcND1CF2Wwes2JWVsFaJctjKByY4Uirm5q0vQGbsxKquXmwE5sMZybiZRBKfBITMcO946V7PzoOyoI0q7qSqgj+hEz+yVOQttR59n0a8V8DMn+cPr6m7D4OZe64HWYElC3XOwAhN5o9NdOkU2m2n0S81u8UPIiTXo/12IwQvY9T09Qiw2sOhAa53PkYUn9tAOCmKzGMP7U4CuwdiNa8M8+uJkbMsBdB1P/kXHlP1MMyB/CpD86Y7WDudUKgAuNc7zqKlGgBVY+h81uQmttg/H9S1HhZ8xx/R+xf0Nje0cFk9WTII8tBAMENHf1Ys7kjsIJKQWyZHSo1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L8QGkKRJxgzuFF7Yfvh8czkCxVZu1EV0qNUMeuNZbRc=;
 b=b3qqbCTpL2ukvLJE2C95Mo+/deXw7pVYEw2Hi4YN6C9wf0JXsZ0hGB8ZdH9L3vXrASlH6ZQU0acnAD/yZkkDQYs5Ashetba2APmhIhP6LDMSep8TdCGi1hLmYk15hBBz4KtOmFdxSgj16/dpMuHsNuqORHUsWL+8EcJjkUsriwlFIC06JFRWukJlh4u6bK4YtCJNNc6K2I7SA2tdboZjDVj5nfv9wJVLxrp+MwDVOx2kAu9qCsC2dzijsZ9q2fee0xlV298mSYHKhOVL1HPE6m/jzYXSaZ2JKCxE0BULfF7235uOwS2itFGq3jia2I27ypmizAz3N9Dk9wE9zwK7EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8QGkKRJxgzuFF7Yfvh8czkCxVZu1EV0qNUMeuNZbRc=;
 b=er10gvTLe4ZeGn6TWI0yTFJPBaNMW4Zla+aLcKI+35GQtLsRvfgFwbxvHnvyOS9bsRO0UYIYdOWqfi/Ut+3iFeUQMQ2EcMdQlVb968aE8bDxXSGEvE+qjKvMt/06enr/xbilMWWDmpD96dGwqXks9in6vRqGuEOYXsYQnrH6f3M=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6640.eurprd04.prod.outlook.com (2603:10a6:803:122::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 15:37:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 15:37:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v5 4/4] net: ocelot: add FDMA support
Thread-Topic: [PATCH net-next v5 4/4] net: ocelot: add FDMA support
Thread-Index: AQHX60pT2N9heOAMh0yw/W+Yi1Q3QKwnDKEAgAAXlQCAAAIQgIAAAg4AgAAB0oA=
Date:   Tue, 7 Dec 2021 15:37:40 +0000
Message-ID: <20211207153739.jkjsudra34fztya6@skbuf>
References: <20211207090853.308328-1-clement.leger@bootlin.com>
 <20211207090853.308328-5-clement.leger@bootlin.com>
 <20211207135200.qvjaw6vkazfcmuvk@skbuf> <20211207161624.39565296@fixe.home>
 <20211207152347.hnlhja52qeolq7pt@skbuf> <20211207163108.3a264f81@fixe.home>
In-Reply-To: <20211207163108.3a264f81@fixe.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 123fb59a-8b15-4b42-7cf9-08d9b99780e3
x-ms-traffictypediagnostic: VE1PR04MB6640:EE_
x-microsoft-antispam-prvs: <VE1PR04MB66404C6E324B0DA7615B9D7CE06E9@VE1PR04MB6640.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: srRa8wt1vxz9vuf+YFoBVi/11poFthrtU+VIwAcmhSTnJ9MSVTDcsvyCHG61g4Jsz8i3E7ew2hyuD1tNyqw7W/4VFV54BKsvsKRq6orrdFOKL2g0JTfggPYwM3B08CZiqwUYdB39gAh/Ab81257qGvudlRTjAQRFAznmvjqxSt0glRv442aTozMEA1Lpf8FvjaK7hAT3emu4rXcp+TlXQV96KnOAMcQ3wCYmbqLeVh9Cpjkugp6FOvLyhdV6F0CdSsqR3JmacsOH2EpaAiQCQT+k37d4WPjUdgSTzamBXN+TrJf6a55v9R+A5ZTtms3zxTfkMdJk6WbY7KUpdPbXU5fzPEpNXOK748QPZWkWVdgdICQtkXqUd2mBR4FhvtvoeYp1s1qaeyXzHufXLhTSmMdqkeVkjh8u5maaqRelF8fek6DOWYS171SfPYQs4e5fOOfSCuDZmwHc/+FoY4I32HtT2mJENy4+6aVpy6Rmw1nclEkOnrab1f3xksUqLN+c4o25NGMIPtBixqfYMCS2udj+2PXF+S46+QxMJRHOPFvEtiZ9G9Bwh0AFxMZRc+RWowssQ0z8n2UKOw9Oldy+EMVCazciQWs9hYEVs0AbgQf9orxQlczWhJCejmeyCxKkRbV9rZyzZjolf92afjVfFeUIkhEGow6ZgN4MYstEze7amsOhz7Q23XBCTtUyjCoDK8iUsTOLaJKpZwRY+Wb8nw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(38070700005)(2906002)(1076003)(54906003)(76116006)(71200400001)(316002)(8936002)(66556008)(66946007)(64756008)(66574015)(66476007)(86362001)(6916009)(8676002)(66446008)(83380400001)(508600001)(44832011)(91956017)(186003)(6506007)(26005)(6486002)(5660300002)(6512007)(122000001)(33716001)(4326008)(9686003)(7416002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VXYzU0o3ZUZqM2w0UlNuZVUreThlUVFyNGN5MHpTUEN3RDV2UnJGVnM4Z29U?=
 =?utf-8?B?S05MMFJ6b1dsU0NCM3prN0xoRVM2dTlmYzZQU2ZEbW8wdnVvVlMxT1MxNll3?=
 =?utf-8?B?NnJ2U2JiREUxSkpSdDQwYkhJdFNMYTEvWklURElPeU1ZYngyZVFmcVRkOHhr?=
 =?utf-8?B?RXFOVzFyeW9kTTRQOUFrZ0Q4bEZrYUtSQjhGM2pjaEd5WVpybWx1NU0xTW1i?=
 =?utf-8?B?bittOHNETXhCMjlRTm5xRWpKY3RIa0w1TWJUc1lxbDNqeThqTThwUCt4Ynl3?=
 =?utf-8?B?d0pnMFljaXlEQ09vc0VJWEVZUzZnYXdtb3JtZzhDM2lPNkhmVCs4Z1hhV3dj?=
 =?utf-8?B?UnZ0bFdacDZuQUNxd1d6ZnNuN0QraEZFSVNHU0s3Mm1RdlgrZ041bkpIa0sr?=
 =?utf-8?B?MFlkNm1zb01XQ1J1UUxsd1BORXQwbW9tbjVTc091SEtzSDRUK0c4V2F3M3I0?=
 =?utf-8?B?MitUUG9zSDJGMjBXcW80czdDUSt0YUc2SFNWUTd4N2dhNGJxaFE4UmpzanJ1?=
 =?utf-8?B?YWVFa0NQZ0ZxcHVaemlSMUZsK1ZvV1NITFJMRDIxbU9XdllLQUZBbkFiZEhj?=
 =?utf-8?B?cVFleG9KT1M4K2Q2c285TTc1dTlCVmZ6Wm96ZjJicVQyNUVRb0J4VTVvOXY2?=
 =?utf-8?B?WU5lMjgzRWJBYnJkdHZWUGdoVlpPNE83SnlkUjN6Q0tvMzVtT3laWVZmcTRk?=
 =?utf-8?B?UitKdVlBUWh2NHErVTZYRTU2VHdGK1VhNGI4bzREZndtSmxIM2hXRERuQXVl?=
 =?utf-8?B?TytBQmJmM3Jud21RWDVjamQ2QmNRQy9Cd3VhOHY3NDJXUWV1cklwSndIM2J3?=
 =?utf-8?B?NDlHVG5sVWJBVjNiaVppTVhmYVVuN214aWlmaUJkdlIxUGN4T0s4eXZxbXEv?=
 =?utf-8?B?TGZRTCtCT1U3eklob1o3VnNSTzFBVThOZnNiNFc0eHRKbTJDZ0doazdiVUFD?=
 =?utf-8?B?K0pwRHJ1ZDlWK3BWL2ozQnN2NHIyaXNHU2ZRNDZ3YlIwRzhwdDZvdnRIZU9L?=
 =?utf-8?B?aGxnYkpKQzE3dmxaSnZQQnVHcmJPZWpaWFhKbEcrMWc2V0VZQWtxWDR2dlhv?=
 =?utf-8?B?RkVEOHFKUmJGL21iQ0VsZXFqT3FPK0tRT2pubU1zUzduc3lQNlEvV1crYldP?=
 =?utf-8?B?cUVDSlhDajBvVTBlSHpibXh3TTZVeFJEQ0pEK1lBUjkzVVl3TU5KZUFxZldq?=
 =?utf-8?B?S2l0QmR1cjFBRENiTWZjMEM2UDM4ZFpvdHRoYkYxNGgzb3pEWEIzSEx1SytG?=
 =?utf-8?B?cG1tTWFDclBSUmRabm1KbU5iaTZKTEc1N09pWXQwZndiaEpmQWkxNkRFYWp3?=
 =?utf-8?B?ZzhOVlhBd2M5emtXbTlWL0VwT0ZrWnh4eUI2aG9vSUptQkMvS2dNbWJrbzFR?=
 =?utf-8?B?UlovSnI4anc4UU16b0tmZ1I0T3Bwd1RJTTZWbXJBdXY0bWlXOG5OV1hVZWZE?=
 =?utf-8?B?cHV0dnhyVThCVnBVWE9jcDJ2T1VqdzRieThFWUQ4N2tEb1V2RXZBaTdSbjQy?=
 =?utf-8?B?LzhYMVhlUm5uM3MxSWhOWC9TODVJVmw3ZWFuQXR3Ymx5TVVMZ0ZlMnVjMitM?=
 =?utf-8?B?dFh2MWIwMUFnazg3RXJxcjFRZnpUa1cyRlgrUTVlRDBUemVpejhwUSsxbFJo?=
 =?utf-8?B?RzhSUGhXQlA4TnNNT0VOSGxpUjlMOXRZa0NTUUpLaER5WnhnYmdJUTlFdkdr?=
 =?utf-8?B?VU5Vb09oM3FzQXBDTmNSeXBwdjgybHBXdGFHSDAyQU8wVEo3by9sOGVPYmJl?=
 =?utf-8?B?V1dVaWJHSG0zbktMN0JPZFpwRUZSL3dDNXFvOGhPYVZ2WlE5VHNNdzV2UUhy?=
 =?utf-8?B?S2dCT3VJdEl2L3JsVE5CYlhDd0Z4WGptZFRXc3ZiZTJaWGkxMTY0OFcvZldV?=
 =?utf-8?B?bmZnZ0tUakEzdnA1RWVMMVlHMXo3eVJvV1MwOFErSko2eWZYVWlsVWhGcnAv?=
 =?utf-8?B?QWtuVnBrYmlPSTRyTEZ6R3RDMkJqSldiSUkrenRxU0hNZUlxUzFBWWZ5SGxn?=
 =?utf-8?B?Y3dqRmhiOEJtSmJLK3NKZGpsdU0zbW1KL2huSTVjajhoR0UwUWwwMjVwbkk2?=
 =?utf-8?B?U2R2OXEyaUZsMWdCR214NUNEcEZWUS9ZWkNnQ2hBdWpOT3JaeFJpcGVnVWNl?=
 =?utf-8?B?VGc0dmhhYW8zRS9vdGNkM3drSFZWbTNTYkQ4bERRNUEvZUxNS1lVVG9va1Yr?=
 =?utf-8?Q?oLACOibYJLgvY47PHeBhxMM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A261937BE5AF9748B2A822D19C494E13@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 123fb59a-8b15-4b42-7cf9-08d9b99780e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 15:37:40.2603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kbdjs2hGSgUF0aUWhj/MxD6k4plIYPRWYz8g3u96d4R/JNv8RF8g1mQqJtiaHlYQ6Ohl7jIJx7sVcWZR4BT1Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6640
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBEZWMgMDcsIDIwMjEgYXQgMDQ6MzE6MDhQTSArMDEwMCwgQ2zDqW1lbnQgTMOpZ2Vy
IHdyb3RlOg0KPiBMZSBUdWUsIDcgRGVjIDIwMjEgMTU6MjM6NDggKzAwMDAsDQo+IFZsYWRpbWly
IE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+IGEgw6ljcml0IDoNCj4gDQo+ID4gT24g
VHVlLCBEZWMgMDcsIDIwMjEgYXQgMDQ6MTY6MjRQTSArMDEwMCwgQ2zDqW1lbnQgTMOpZ2VyIHdy
b3RlOg0KPiA+ID4gTGUgVHVlLCA3IERlYyAyMDIxIDEzOjUyOjAxICswMDAwLA0KPiA+ID4gVmxh
ZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT4gYSDDqWNyaXQgOg0KPiA+ID4g
ICANCj4gPiA+ID4gT24gVHVlLCBEZWMgMDcsIDIwMjEgYXQgMTA6MDg6NTNBTSArMDEwMCwgQ2zD
qW1lbnQgTMOpZ2VyIHdyb3RlOiAgDQo+ID4gPiA+ID4gRXRoZXJuZXQgZnJhbWVzIGNhbiBiZSBl
eHRyYWN0ZWQgb3IgaW5qZWN0ZWQgYXV0b25vbW91c2x5IHRvIG9yIGZyb20NCj4gPiA+ID4gPiB0
aGUgZGV2aWNl4oCZcyBERFIzL0REUjNMIG1lbW9yeSBhbmQvb3IgUENJZSBtZW1vcnkgc3BhY2Uu
IExpbmtlZCBsaXN0DQo+ID4gPiA+ID4gZGF0YSBzdHJ1Y3R1cmVzIGluIG1lbW9yeSBhcmUgdXNl
ZCBmb3IgaW5qZWN0aW5nIG9yIGV4dHJhY3RpbmcgRXRoZXJuZXQNCj4gPiA+ID4gPiBmcmFtZXMu
IFRoZSBGRE1BIGdlbmVyYXRlcyBpbnRlcnJ1cHRzIHdoZW4gZnJhbWUgZXh0cmFjdGlvbiBvcg0K
PiA+ID4gPiA+IGluamVjdGlvbiBpcyBkb25lIGFuZCB3aGVuIHRoZSBsaW5rZWQgbGlzdHMgbmVl
ZCB1cGRhdGluZy4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IFRoZSBGRE1BIGlzIHNoYXJlZCBiZXR3
ZWVuIGFsbCB0aGUgZXRoZXJuZXQgcG9ydHMgb2YgdGhlIHN3aXRjaCBhbmQNCj4gPiA+ID4gPiB1
c2VzIGEgbGlua2VkIGxpc3Qgb2YgZGVzY3JpcHRvcnMgKERDQikgdG8gaW5qZWN0IGFuZCBleHRy
YWN0IHBhY2tldHMuDQo+ID4gPiA+ID4gQmVmb3JlIGFkZGluZyBkZXNjcmlwdG9ycywgdGhlIEZE
TUEgY2hhbm5lbHMgbXVzdCBiZSBzdG9wcGVkLiBJdCB3b3VsZA0KPiA+ID4gPiA+IGJlIGluZWZm
aWNpZW50IHRvIGRvIHRoYXQgZWFjaCB0aW1lIGEgZGVzY3JpcHRvciB3b3VsZCBiZSBhZGRlZCBz
byB0aGUNCj4gPiA+ID4gPiBjaGFubmVscyBhcmUgcmVzdGFydGVkIG9ubHkgb25jZSB0aGV5IHN0
b3BwZWQuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBCb3RoIGNoYW5uZWxzIHVzZXMgcmluZy1saWtl
IHN0cnVjdHVyZSB0byBmZWVkIHRoZSBEQ0JzIHRvIHRoZSBGRE1BLg0KPiA+ID4gPiA+IGhlYWQg
YW5kIHRhaWwgYXJlIG5ldmVyIHRvdWNoZWQgYnkgaGFyZHdhcmUgYW5kIGFyZSBjb21wbGV0ZWx5
IGhhbmRsZWQNCj4gPiA+ID4gPiBieSB0aGUgZHJpdmVyLiBPbiB0b3Agb2YgdGhhdCwgcGFnZSBy
ZWN5Y2xpbmcgaGFzIGJlZW4gYWRkZWQgYW5kIGlzDQo+ID4gPiA+ID4gbW9zdGx5IHRha2VuIGZy
b20gZ2lhbmZhciBkcml2ZXIuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBDby1kZXZlbG9wZWQtYnk6
IEFsZXhhbmRyZSBCZWxsb25pIDxhbGV4YW5kcmUuYmVsbG9uaUBib290bGluLmNvbT4NCj4gPiA+
ID4gPiBTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kcmUgQmVsbG9uaSA8YWxleGFuZHJlLmJlbGxvbmlA
Ym9vdGxpbi5jb20+DQo+ID4gPiA+ID4gU2lnbmVkLW9mZi1ieTogQ2zDqW1lbnQgTMOpZ2VyIDxj
bGVtZW50LmxlZ2VyQGJvb3RsaW4uY29tPg0KPiA+ID4gPiA+IC0tLSAgICANCj4gPiA+ID4gICAN
Cj4gPiA+ID4gPiArc3RhdGljIHZvaWQgb2NlbG90X2ZkbWFfc2VuZF9za2Ioc3RydWN0IG9jZWxv
dCAqb2NlbG90LA0KPiA+ID4gPiA+ICsJCQkJIHN0cnVjdCBvY2Vsb3RfZmRtYSAqZmRtYSwgc3Ry
dWN0IHNrX2J1ZmYgKnNrYikNCj4gPiA+ID4gPiArew0KPiA+ID4gPiA+ICsJc3RydWN0IG9jZWxv
dF9mZG1hX3R4X3JpbmcgKnR4X3JpbmcgPSAmZmRtYS0+dHhfcmluZzsNCj4gPiA+ID4gPiArCXN0
cnVjdCBvY2Vsb3RfZmRtYV90eF9idWYgKnR4X2J1ZjsNCj4gPiA+ID4gPiArCXN0cnVjdCBvY2Vs
b3RfZmRtYV9kY2IgKmRjYjsNCj4gPiA+ID4gPiArCWRtYV9hZGRyX3QgZG1hOw0KPiA+ID4gPiA+
ICsJdTE2IG5leHRfaWR4Ow0KPiA+ID4gPiA+ICsNCj4gPiA+ID4gPiArCWRjYiA9ICZ0eF9yaW5n
LT5kY2JzW3R4X3JpbmctPm5leHRfdG9fdXNlXTsNCj4gPiA+ID4gPiArCXR4X2J1ZiA9ICZ0eF9y
aW5nLT5idWZzW3R4X3JpbmctPm5leHRfdG9fdXNlXTsNCj4gPiA+ID4gPiArCWlmICghb2NlbG90
X2ZkbWFfdHhfZGNiX3NldF9za2Iob2NlbG90LCB0eF9idWYsIGRjYiwgc2tiKSkgew0KPiA+ID4g
PiA+ICsJCWRldl9rZnJlZV9za2JfYW55KHNrYik7DQo+ID4gPiA+ID4gKwkJcmV0dXJuOw0KPiA+
ID4gPiA+ICsJfQ0KPiA+ID4gPiA+ICsNCj4gPiA+ID4gPiArCW5leHRfaWR4ID0gb2NlbG90X2Zk
bWFfaWR4X25leHQodHhfcmluZy0+bmV4dF90b191c2UsDQo+ID4gPiA+ID4gKwkJCQkJT0NFTE9U
X0ZETUFfVFhfUklOR19TSVpFKTsNCj4gPiA+ID4gPiArCS8qIElmIHRoZSBGRE1BIFRYIGNoYW4g
aXMgZW1wdHksIHRoZW4gZW5xdWV1ZSB0aGUgRENCIGRpcmVjdGx5ICovDQo+ID4gPiA+ID4gKwlp
ZiAob2NlbG90X2ZkbWFfdHhfcmluZ19lbXB0eShmZG1hKSkgew0KPiA+ID4gPiA+ICsJCWRtYSA9
IG9jZWxvdF9mZG1hX2lkeF9kbWEodHhfcmluZy0+ZGNic19kbWEsIHR4X3JpbmctPm5leHRfdG9f
dXNlKTsNCj4gPiA+ID4gPiArCQlvY2Vsb3RfZmRtYV9hY3RpdmF0ZV9jaGFuKG9jZWxvdCwgZG1h
LCBNU0NDX0ZETUFfSU5KX0NIQU4pOw0KPiA+ID4gPiA+ICsJfSBlbHNlIHsNCj4gPiA+ID4gPiAr
CQkvKiBDaGFpbiB0aGUgRENCcyAqLw0KPiA+ID4gPiA+ICsJCWRjYi0+bGxwID0gb2NlbG90X2Zk
bWFfaWR4X2RtYSh0eF9yaW5nLT5kY2JzX2RtYSwgbmV4dF9pZHgpOw0KPiA+ID4gPiA+ICsJfQ0K
PiA+ID4gPiA+ICsJc2tiX3R4X3RpbWVzdGFtcChza2IpOw0KPiA+ID4gPiA+ICsNCj4gPiA+ID4g
PiArCXR4X3JpbmctPm5leHRfdG9fdXNlID0gbmV4dF9pZHg7ICAgIA0KPiA+ID4gPiANCj4gPiA+
ID4gWW91J3ZlIGRlY2lkZWQgYWdhaW5zdCBtb3ZpbmcgdGhlc2UgYmVmb3JlIG9jZWxvdF9mZG1h
X2FjdGl2YXRlX2NoYW4/DQo+ID4gPiA+IFRoZSBza2IgbWF5IGJlIGZyZWVkIGJ5IG9jZWxvdF9m
ZG1hX3R4X2NsZWFudXAoKSBiZWZvcmUNCj4gPiA+ID4gc2tiX3R4X3RpbWVzdGFtcCgpIGhhcyBh
IGNoYW5jZSB0byBydW4sIGlzIHRoaXMgbm90IHRydWU/ICANCj4gPiA+IA0KPiA+ID4gU2luY2Ug
dHhfcmluZy0+bmV4dF90b191c2UgaXMgdXBkYXRlZCBhZnRlciBjYWxsaW5nIHNrYl90eF90aW1l
c3RhbXAsDQo+ID4gPiBmZG1hX3R4X2NsZWFudXAgd2lsbCBub3QgZnJlZSBpdC4gSG93ZXZlciwg
SSdtIG5vdCBzdXJlIGlmIHRoZQ0KPiA+ID4gdGltZXN0YW1waW5nIHNob3VsZCBiZSBkb25lIGJl
Zm9yZSBiZWluZyBzZW50IGJ5IHRoZSBoYXJkd2FyZSAoaWUsIGRvZXMNCj4gPiA+IHRoZSB0aW1l
c3RhbXBpbmcgZnVuY3Rpb24gbW9kaWZpZXMgdGhlIFNLQiBpbnBsYWNlKS4gSWYgbm90LCB0aGVu
IHRoZQ0KPiA+ID4gY3VycmVudCBjb2RlIGlzIG9rLiBCeSBsb29raW5nIGF0IG9jZWxvdF9wb3J0
X2luamVjdF9mcmFtZSwgdGhlDQo+ID4gPiB0aW1lc3RhbXBpbmcgaXMgZG9uZSBhZnRlciBzZW5k
aW5nIHRoZSBmcmFtZS4gIA0KPiA+IA0KPiA+IEl0IGxvb2tzIGxpa2Ugd2UgbWF5IG5lZWQgUmlj
aGFyZCBmb3IgYW4gZXhwZXJ0IG9waW5vbi4NCj4gPiBEb2N1bWVudGF0aW9uL25ldHdvcmtpbmcv
dGltZXN0YW1waW5nLnJzdCBvbmx5IHNheXM6DQo+ID4gDQo+ID4gfCBEcml2ZXIgc2hvdWxkIGNh
bGwgc2tiX3R4X3RpbWVzdGFtcCgpIGFzIGNsb3NlIHRvIHBhc3Npbmcgc2tfYnVmZiB0byBoYXJk
d2FyZQ0KPiA+IHwgYXMgcG9zc2libGUuDQo+ID4gDQo+ID4gbm90IHdoZXRoZXIgaXQgbXVzdCBi
ZSBkb25lIGJlZm9yZSBvciBpdCBjYW4gYmUgZG9uZSBhZnRlciB0b287DQo+ID4gYnV0IG15IGlu
dHVpdGlvbiBzYXlzIHRoYXQgaXMgYWxzbyBuZWVkcyB0byBiZSBzdHJpY3RseSBfYmVmb3JlXyB0
aGUNCj4gPiBoYXJkd2FyZSB4bWl0LCBvdGhlcndpc2UgaXQgYWxzbyByYWNlcyB3aXRoIHRoZSBo
YXJkd2FyZSBUWCB0aW1lc3RhbXBpbmcNCj4gPiBwYXRoIGFuZCB0aGF0IG1heSBsZWFkIHRvIGlz
c3VlcyBvZiBpdHMgb3duICh0aGUgbG9naWMgd2hldGhlciB0bw0KPiA+IGRlbGl2ZXIgYSBzb2Z0
d2FyZSBhbmQvb3IgYSBoYXJkd2FyZSB0aW1lc3RhbXAgdG8gdGhlIHNvY2tldCBpcyBub3QNCj4g
PiB0cml2aWFsIGF0IGFsbCkuDQo+IA0KPiBPaywgSSB3aWxsIG1vdmUgaXQgYmVmb3JlIHNlbmRp
bmcgc2luY2UgaXQgc2luY2UgaXQgaXMgY2xlYW5lciBhbnl3YXkuDQo+IEFuZCBwcm9iYWJseSBz
dWJtaXQgYSBmaXggZm9yIHRoZSByZWdpc3Rlci1iYXNlZCBpbmplY3Rpb24gcGF0aCBsYXRlci4N
Cg0KTGV0IG1lIGdpdmUgeW91IGEgc3Ryb25nZXIgYXJndW1lbnQuIElmIFBIWSB0aW1lc3RhbXBp
bmcgaXMgaW4gdXNlLCBpdA0KaG9va3MgaW50byBza2JfdHhfdGltZXN0YW1wKCkuIElmIHRoZSBQ
SFkgbmVlZHMgdG8gYXJtIHdoYXRldmVyIHJlZ2lzdGVyDQpvciBjbG9uZSB0aGUgc2tiIG9yIHdo
YXRldmVyLCB0aGlzIG11c3QgYmUgZG9uZSBzdHJpY3RseSBiZWZvcmUgc2VuZGluZw0KdGhlIHBh
Y2tldCwgb3RoZXJ3aXNlIHRoZSBQSFkgZHJpdmVyIG1heSBtaXNzIHRoZSBUWCB0aW1lc3RhbXBp
bmcNCmludGVycnVwdCBmb3IgdGhlIHBhY2tldCB0aGF0IGp1c3Qgd2VudCBieS4=
