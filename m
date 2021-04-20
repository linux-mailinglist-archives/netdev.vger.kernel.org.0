Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37E936535D
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 09:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhDTHkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 03:40:15 -0400
Received: from mail-eopbgr00051.outbound.protection.outlook.com ([40.107.0.51]:36481
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229471AbhDTHkO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 03:40:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iol8rE+QpLTex/WIjgOUEkHWKfgEJY+ejJDjidVbklL66Jpo+ZgaI0dKry36xXekGKtOasA5EqH7dKD0pENZko/IBBXMy5lxlkkzsC0XAxPkXMkZd/yL/Y6PxEurgzgVo25EiruYJjIe/2MbInnpzeIRn2vzp2pO+sZPaaj2nYbzzmTtcY39wkHLcDWoK8b3kHkofWRTWtwQmDqn7hIWODv6e6s5UuMX9MGpbsLVKf2hCUVd0t0sjMIIDQEiqZsCIFcvCPn544XESeGU+gtjIMkZSS/CDJIKY7lpV7CG1ADhcYNAiQTGDhf+gLiDBK4Oi+tYV0LsYJdrDRdAX7v54A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PsTkWgL7GkapjDV8/qX+Lbknb1sSybtpM0pMUevpZY=;
 b=LNg8kqcl0Jx6OXY8uO5FE4riSlkP/XJ++mLVNCkaQWay8xK1HBGmFCV6GPA9N31I5wIWu/EVzh+4qjBoMSsMAErh1BfilJf2tjBUsNX1NsGkZW4SWFrsPxpzPm1BZMHbcyEUUTXMA0335SM+/GHktUn5764T8rJCyAvHoicOJf3IE8Lu470iqHm59mSE0UuWGBId8tSMm2kscernCC1l946dpLgWm7I9vUiK1HXJgToQWMdFvbfORDmrSZa7Ql8yWEdYwpRsI0kA/s1QImk2hnmLcVxy65iAjVSLuMkZDRmcUYFUg5XloWMu5Xp1guEq7Fln1+eF+4OcnRI/OnpCFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PsTkWgL7GkapjDV8/qX+Lbknb1sSybtpM0pMUevpZY=;
 b=ggjS8qjrLEckhtk6meDbgwQ9lXM13fKO35FYoeAqJnRYd2PgQn9ngYQCSi9fd3GGXiemW0i9Ymx1SXN3wCxYdsiUcl7X55/VUUnIog4FU68wAq0wHfNddL5JvZoq98MBzVKYsD5DZ74GtVNtG9FRDALjdsZsQltXlLiJpWpPH7k=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM6PR04MB4184.eurprd04.prod.outlook.com (2603:10a6:209:4e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 20 Apr
 2021 07:39:41 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777%3]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 07:39:40 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [net-next 1/3] net: dsa: optimize tx timestamp request handling
Thread-Topic: [net-next 1/3] net: dsa: optimize tx timestamp request handling
Thread-Index: AQHXMrxTcFa/yb7c402hVeJWcQQ266q6Ai0AgABiiwCAAqVdcA==
Date:   Tue, 20 Apr 2021 07:39:40 +0000
Message-ID: <AM7PR04MB68859C0C52833BF98C5BF55EF8489@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20210416123655.42783-1-yangbo.lu@nxp.com>
 <20210416123655.42783-2-yangbo.lu@nxp.com>
 <20210418091842.slmcybvjfkvkatiq@skbuf>
 <20210418151124.GC24506@hoboy.vegasvil.org>
In-Reply-To: <20210418151124.GC24506@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff66dd03-e202-4eb0-bd38-08d903cf7533
x-ms-traffictypediagnostic: AM6PR04MB4184:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB41845360CA8ABD7EFF32C4D2F8489@AM6PR04MB4184.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DBYaKDuB6f6+HQW2fj8u95IoZGXfq0H8q3QZLpQ82K5gAxd+Z227j8r4EGYmS0oAXPFjwHMv4zN/oRtEE5GVyVeLvTyl3vtC5btB0EjJBh2CdL9h0EAL1a49Td2XoOLg+XVYLKeGqsSpSwSt1BINph75uT1jMqAgfC3XfUUXpwAGQlYIwMt8EJDxXMAf2O77FpF69syQ4Eb9XTKXAsYf4gEMHVTvL60apsK1Jl/zRvaMbVwpxtMTC+z0r5R/B7mJsm0U56ooEDsteu+BXRz6ARX2lsMgiSWTcIC/4FgvCJ9P+nTKy4YYns/C0lNERuSrCp7dEbUuFNTaw7eDo68tcG9xe+eFENkKqck4E8GCn9xwIU5hWqdZaYPvgIAFVTTZN1zAKtnV9UFZuxmGXuWau6LLlXEX9redgQUKytgb5sOVf9YDdWClYEz71SpEayH53GswM1to6p5nEfo+ejpDeN3VmRaGpz2q9y/HAmVLNhkc1Mcs5+gbZ5Lz0NXzyu2C0e6YUeSxigAe3haWE2oMiaXaGF+RiDcVYVBduquDJEvk4hpsY8WF1l1hCTAq1UMe/NTrgtj46IkqNCvxfKi+gr09XBoWMgfHyWQA4SsjHu0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(6506007)(71200400001)(7696005)(66476007)(4326008)(122000001)(9686003)(38100700002)(2906002)(52536014)(86362001)(5660300002)(76116006)(7416002)(55016002)(53546011)(8676002)(66556008)(186003)(26005)(498600001)(64756008)(54906003)(66446008)(110136005)(83380400001)(8936002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?QW85bDFLdWc4OWk4eG9JNWN2YnlUNXd4Rkw4SVZVL3lZUGlpczVHbmhxb2VU?=
 =?gb2312?B?QnNwQXFsZHhEL3VKZzByR3JhR3Z1K1gzMU4xUlJSZ0cwSUxJZWtkcGFGREI2?=
 =?gb2312?B?SnFEU2xlZ3huNFpCQVc3dzkvYUFOQzNEVGVLOHZpcktxYk1EMFlrNkN6cDg5?=
 =?gb2312?B?MkNMS3dmT3dIUlJ3VEowWE4xdTVLbEtzY0h4M2VMQWFtNFpoVVE3ODZVc3VJ?=
 =?gb2312?B?KzJ6bWFxbUowL0JaVmRwTEpYTmw2a3RBcW5mczJCamQ3clF0VncweW1LdEZL?=
 =?gb2312?B?eFF0MCtrdjVmako4Nm9yV016QUxScE95Q1ZTWlNMaXNSSldiTUZuSEs4Ykl3?=
 =?gb2312?B?S3hKdGZFL1R1eGx6VWFqcnZXTGdJenRpYjRpWFFqRWd1bGI0U1Zrby9rMnBO?=
 =?gb2312?B?M2x6a093eGIwd2VYMVc2SjBXNDJRSUF4N0NaazdlNFRvUEpWWGRSWk1iR25M?=
 =?gb2312?B?WEtEMEpzZTRpNGNsN1BZQkk2R2QxSDdxNXVEYlA4UllkbmFIeDA5U0tsQ3JJ?=
 =?gb2312?B?em9aZEdCenRkY09UVkFYZTVrUm5renpOaGlFVW4wTThUQ011blNPQmlLOG0z?=
 =?gb2312?B?MkUwb2UzeSttNC81ZlNmTytzSlB6ZW9UQVV4TE1Id0YxZUowTmdSQ1FOZGhE?=
 =?gb2312?B?RmpoR3hIVDBRcElaOUFUTFc4RDV1OGJqamZvQ0JFOW1yZllyU0p4QlVjZEJQ?=
 =?gb2312?B?aGNaVFQ3c3gvYjJlRkRHcWdtMm1RanJoMXYrdVp6RGFwRU1sM0FvMGJ0SU9K?=
 =?gb2312?B?OWRkajFRbXpIY3FTUzNyTGZKQlM5SlFQOGM0U1kyQmRmbkMvN1NuUWFOdzBD?=
 =?gb2312?B?R29XNlF4NUFqQW9wMU9hYnpPL25MK1BENFlZQzZZUVpLYmpGMUdiSWtOVkFQ?=
 =?gb2312?B?ZEs2T212d1JIYmFOeU01bUk1d2JxVW9DLzJlLzhIWUo2SEtYSzJrcTBWRWZl?=
 =?gb2312?B?VXVXeTlqZHJpQ3BJRmtDaDJLcUZJT1F1OTNiajI2dTBjanhNOUhHcEZmRG1r?=
 =?gb2312?B?YmQvTmpCWW9icmZwWFJwRXcyMHg0TStUaFhKYm9ZcjRNYTZNVWp4WWFsZFZN?=
 =?gb2312?B?OXBPTzNPNjk3eEJ5RkFkejNvVWkyK0FOc0xQSGVDTlFLdGlPRUJITWJZanRB?=
 =?gb2312?B?WWVTQ0dmMmVvVnM0UUxybk5oK216MUs1dFJGcDlocWMvSGtpU2FDK3NreXYr?=
 =?gb2312?B?OFlRTCt0MElEL1dNOURxYWt5V3VTRTBQYnFhcnVIRzNPNWJLTmNUZi8ra3JY?=
 =?gb2312?B?elJWNC9wL3NlUlhKM2FMZ2pybngvZDcxdEhpZ1paQUtzTWYrQm1NVHQvUTln?=
 =?gb2312?B?RWN6MWgraTZ6TDVOYmxjQTN6ZEw5TE9UZmVJNzZMTkVzNFRPQlBJTjlxbHFX?=
 =?gb2312?B?UkNuUjA2RTZVM2dDdG5HZlVyTU9xZzVkN2pqTlhoMG8yRDVSTFYzWlE0NlFS?=
 =?gb2312?B?R2I0bWVNZ3A2QmE3TDBraHZkK1NxOUFWZVJ4TElHcWp4aWkvWXlTQVUwVjBk?=
 =?gb2312?B?eE5Hbi8yOGErcmMzV29iSGQzSklhMVpzd2xLdVNBUWdYZUgwc2Uxc3libXdM?=
 =?gb2312?B?cmg3M0RMVi9paFdsWUIxUnozc0thblRRVVFjUU1zWXp0TEEyd2VMaHRkWGZH?=
 =?gb2312?B?U1pVL0RSMWhFcDI1c2p0eUlFVDVEWjZCbzdYRVVpdUQ4cy96MW9pcWdqMCtu?=
 =?gb2312?B?T2pTaExJSzV6S2YzWEp4WUJDaEdSMGtQVFRwaHRub0hvNEw2WURaNFN0aXlG?=
 =?gb2312?Q?g3CrF/HJnLCVZL4dWqTSDbeMl9ajNEkSx+5MMDt?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6885.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff66dd03-e202-4eb0-bd38-08d903cf7533
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 07:39:40.7889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xYmquIM5KaFoQOE2I9gzCF5gZc8LzJuX+7NW8ib4VU+6NTnPfCs1HZxHwwu7oaWa9U+cm+MMZQtQTVShjdNzSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4184
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNoYXJkIENvY2hyYW4gPHJp
Y2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqNNTCMTjI1SAyMzoxMQ0KPiBU
bzogVmxhZGltaXIgT2x0ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT4NCj4gQ2M6IFkuYi4gTHUgPHlh
bmdiby5sdUBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgVmxhZGltaXIgT2x0ZWFu
DQo+IDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT47IERhdmlkIFMgLiBNaWxsZXIgPGRhdmVtQGRh
dmVtbG9mdC5uZXQ+OyBKYWt1Yg0KPiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgSm9uYXRo
YW4gQ29yYmV0IDxjb3JiZXRAbHduLm5ldD47IEt1cnQNCj4gS2FuemVuYmFjaCA8a3VydEBsaW51
dHJvbml4LmRlPjsgQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPjsgVml2aWVuDQo+IERpZGVs
b3QgPHZpdmllbi5kaWRlbG90QGdtYWlsLmNvbT47IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVs
bGlAZ21haWwuY29tPjsNCj4gQ2xhdWRpdSBNYW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5jb20+
OyBBbGV4YW5kcmUgQmVsbG9uaQ0KPiA8YWxleGFuZHJlLmJlbGxvbmlAYm9vdGxpbi5jb20+OyBV
TkdMaW51eERyaXZlckBtaWNyb2NoaXAuY29tOw0KPiBsaW51eC1kb2NAdmdlci5rZXJuZWwub3Jn
OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbbmV0LW5leHQg
MS8zXSBuZXQ6IGRzYTogb3B0aW1pemUgdHggdGltZXN0YW1wIHJlcXVlc3QgaGFuZGxpbmcNCj4g
DQo+IE9uIFN1biwgQXByIDE4LCAyMDIxIGF0IDEyOjE4OjQyUE0gKzAzMDAsIFZsYWRpbWlyIE9s
dGVhbiB3cm90ZToNCj4gPg0KPiA+IEhvdyBhYm91dCBub3QgcGFzc2luZyAiY2xvbmUiIGJhY2sg
dG8gRFNBIGFzIGFuIGFyZ3VtZW50IGJ5IHJlZmVyZW5jZSwNCj4gPiBidXQgaW5zdGVhZCByZXF1
aXJlIHRoZSBkcml2ZXIgdG8gcG9wdWxhdGUgRFNBX1NLQl9DQihza2IpLT5jbG9uZSBpZg0KPiA+
IGl0IG5lZWRzIHRvIGRvIHNvPw0KPiA+DQo+ID4gQWxzbywgaG93IGFib3V0IGNoYW5naW5nIHRo
ZSByZXR1cm4gdHlwZSB0byB2b2lkPyBSZXR1cm5pbmcgdHJ1ZSBvcg0KPiA+IGZhbHNlIG1ha2Vz
IG5vIGRpZmZlcmVuY2UuDQoNClRoYW5rIHlvdS4gVGhhdCdzIGdvb2QgaWRlYS4NCkFuZCBob3cg
YWJvdXQgbGV0dGluZyBkcml2ZXIgc3RvcmUgdGhlIHNrYiBjbG9uZSBwb2ludGVyLCBvciBub3Q/
IEkgY29waWVkIG15IGNvbW1lbnRzIGluIHBhdGNoICMzIGhlcmUsDQoNCiIgQ2FuIHdlIHRvdGFs
bHkgZHJvcCBkc2Ffc2tiX2NiIGluIGRzYSBjb3JlPyBUaGUgb25seSB1c2FnZSBvZiBpdCBpcyBo
b2xkaW5nIGEgc2tiIGNsb25lIHBvaW50ZXIsIGZvciBvbmx5IGZlbGl4IGFuZCBzamExMTA1Lg0K
QWN0dWFsbHkgd2UgY2FuIG1vdmUgc3VjaCBwb2ludGVyIGluIDxkZXZpY2U+X3NrYl9jYiwgaW5z
dGVhZCBvZiByZXNlcnZpbmcgdGhlIHNwYWNlIG9mIHNrYiBmb3IgYW55IGRyaXZlcnMuIg0KDQo+
IA0KPiArMQ0KPiANCj4gVGhhbmtzLA0KPiBSaWNoYXJkDQo=
