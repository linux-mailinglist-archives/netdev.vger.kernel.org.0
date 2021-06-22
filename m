Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C658A3B00FB
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 12:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhFVKMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 06:12:53 -0400
Received: from mail-eopbgr60080.outbound.protection.outlook.com ([40.107.6.80]:9038
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229702AbhFVKMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 06:12:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/YD03yJaxfwYctq8YmWcOjAFIRbJZf69VtSjt++O2i5IC0t2J0XbT0xO3T7d9rtMz1UnTIBp6sa0PJBA9toGlEdQ5dS+1mH4tf3xHxw21nOlxPEh9sIrXN1qP4+Q2Qa/vfGHIvumtCxjEKb2DDmGhgUo6xq7N56qvzUj7tJVCIkyLvC8r10WgpHcbogVoG5aaeyH3kKqN68l/hUxI7WicNdz8QXpjqwqRjumsSHWX/ATMnAtw87vXVsjnOSbbA184mcpmnC6iiG5GZszL0cBhQfiSAEtqu5wEsaAPtykals9lGpI90oyDOgtYiTPjuugEQ7zRqtaAGJcAAoIl9Beg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IrRGPdBx+FzZg65Z39wxh5Vne67QY7b39kgV0CdNZko=;
 b=W/5hC8WzO/scchJ8RfgFMfcOBUaBHcliV+UOMNRAq7/lSxG7yVg1yPPsDiwJzMVfRueWnVxx5qXij/s4afXdaDsUCKQfPnRxu9EjvXhefPQ3U8MV6ukMYiwWO15sLGYGyAcJ7jmZOk2fJeLqRgJSpwRYJdFqb74u26dHmtqruX5iiog0qDZxZbSemvF2BA1jVCsv936s04ZHIx376fneu9hoX6kVSPalkLTJl4uadRHySOMEiO6+vS0MW55yVRVyqvZpnwTkAJypq28H4Y/usGAWEgktkzEObOe7BBTXc7jnbSPDOZJRVR/+wm265+YL5Hs4Kz8pW4T2ZACF1VnPWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IrRGPdBx+FzZg65Z39wxh5Vne67QY7b39kgV0CdNZko=;
 b=g03Ry9SJimd5e/6QJStCzi0I8F2s7cAfwaYhRvlAJZRHW9EjvtiiOlAALqN5nZuRUlEvc/swcpzNF9xnMgp3jIpnN0rtaBSid0I8TKwcUf0+ZHLguPJaOjaz8aj02HTuPsdwQinsBvkoBpchtC2hXaAOGAS0LeiFbxUI/VVLAkI=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DB8PR04MB7195.eurprd04.prod.outlook.com (2603:10a6:10:12d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Tue, 22 Jun
 2021 10:10:34 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd%7]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 10:10:34 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mptcp@lists.linux.dev" <mptcp@lists.linux.dev>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: RE: [net-next, v3, 05/10] ethtool: add a new command for getting PHC
 virtual clocks
Thread-Topic: [net-next, v3, 05/10] ethtool: add a new command for getting PHC
 virtual clocks
Thread-Index: AQHXYcnzlGPfNAMo8ESiD/s4IvxeJasVt6qAgAoiVKA=
Date:   Tue, 22 Jun 2021 10:10:34 +0000
Message-ID: <DB7PR04MB5017A7D02D5F7EB988CF69EAF8099@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210615094517.48752-1-yangbo.lu@nxp.com>
 <20210615094517.48752-6-yangbo.lu@nxp.com>
 <20210615232443.itunrkhaiy7h5gty@lion.mk-sys.cz>
In-Reply-To: <20210615232443.itunrkhaiy7h5gty@lion.mk-sys.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a899c177-1efd-419b-6594-08d93565f987
x-ms-traffictypediagnostic: DB8PR04MB7195:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB71954C147DBFF7B4FB843311F8099@DB8PR04MB7195.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BzB3rHnlM/dVQeHvNozmskJe8IAfjKw/he3O+zCYP4hFo3nnbW7W9LzpKTpaxOR0oRAFnHZO2RMNuGwk93lg9VD1LmrtLb5crUmm38F5emW19FZgiIpYvYTChvRR1cBe6uaW3LjvRdQcms86IVvNbjok4ez6XQk01jjF1Kpofc8rhxeDtZckC/+A+bXO2+Ae+Jy023IGR4d7NJeruy2+/pLVnYy/t+wFuZYwMHc5SzlOYAPgcWXrcR4CemBnteQpNPrlEsBrl1e/i9w45acphIalulJKbPZLDUu8EysqyjZbllWy1vsE7tuFG7GZoW6POu/wUPVikhpEkKunA6+Vw2ulsVT0FsxjOOJSh8dW/2uCPSk1JGZc+Wyl6JLq/ejCLtE/B2FNvtsnz8HSAuLRKTgyr4/nHXNzipPHUBDM5+dkeeADgLEjMAEb3QLjxHTfOxTRJfw856/Zist9T+mu/fvrQ9YTKjAfbI68O1asJVwNRPNQxHwBCuM1jDK0DaXNvUfUBa3mIXRSpG/fr94ybvobK3r68LXPx0FvCDiZIYj3cZIkM7EKJVd3NZgMTMEAESPZB2VxyxhpaxtevvaxHdtFSkCBYNmDKZ+5e4I6/wo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(7696005)(9686003)(55016002)(6506007)(53546011)(26005)(186003)(83380400001)(122000001)(38100700002)(71200400001)(52536014)(478600001)(2906002)(66446008)(5660300002)(4326008)(86362001)(64756008)(66556008)(66476007)(66946007)(76116006)(6916009)(54906003)(33656002)(8676002)(8936002)(7416002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?NWFIZW9MTm92am1qbjA5ZkwzblNNVjVIdURSVEpXQW81U0xxeDNSS3dVTEYr?=
 =?gb2312?B?KzJyUlVrVkJyYWRFRllkVXNRZVJHcCtvYjRHbU16MVZzOGZOWFM5QUU3VXox?=
 =?gb2312?B?K2VMSW5NdzlTREZWRXpBNmFOUXpLZWpYNGxDR0RtUm1GYlhPZkgrcVp5ZEVh?=
 =?gb2312?B?TngrRU1hVUdJMFR1SjU0dHlCSnNiUDN5bUtDbGt6ckIxKzVaUU9sblUzMnRj?=
 =?gb2312?B?aS9McGdxOG1WaExyMHpCdmluMDRFZkY4cHYwL21KN05NUHFBcThyR0NLdFhQ?=
 =?gb2312?B?SUFkVDJtRnNMZlAxV010ZTVSQVFVZ1FFK1cyZHU4ODk3bTJhR0ZXT0JJRzJz?=
 =?gb2312?B?OUw3QVVlZnJMeG93WUV4UnNSd2JUUnVjL1NjNnZTbjBqVGNLY1lWb2E0ZDI0?=
 =?gb2312?B?NmdrVU9aYkIvVU5vdGd6Y0JmMVJBVUxkcVQzS0xWaHNxTkw5Rk9pK3hQTnJN?=
 =?gb2312?B?YmFzTmVESEk1b3cyWHFHdmFLVHdHMk9FNU1DMnNEOE83TGpJWVFsV0ZKRkpk?=
 =?gb2312?B?ckY2OWVhbVZsMjN4eTV1L1FjUTVhVUt4M0Y1N0Znb1BGcThWK1lQVGcweWhs?=
 =?gb2312?B?Mk9xUGVSRTJBQ1pBMmxydmxDdnhyTEVJM3hybGp6SzV0QkZUbkprQXpzQzZX?=
 =?gb2312?B?UlpoZHV2MU1SRXU5NW9sdjdWelRtR0l5ZVdRMFVPWngwMnZpcnJqTHdlU2l1?=
 =?gb2312?B?REhkNkVWdHU3a3hQbTF3Qjc2ZnpncXd4SVJxejIvLzdsbysycGYxV000M1kz?=
 =?gb2312?B?dk04bTBXQS9FclVPdzMyMjRvcitsNE42Zm1hc3B2ZmsvSzFrYmtSYWt1MmFv?=
 =?gb2312?B?eFFJQmRpVlU3NVZRQ3RTT2J5bHVoK0ZlcWtqMkw5blNNSmJvOWRadzE3Ly9p?=
 =?gb2312?B?VDducFVLVUtyamtzalh0eVg2ekRsOEtGYVMxMVUyWmlud0pOWXE0N3hXdWRI?=
 =?gb2312?B?aDBJVEtHZC9MbndZSW50UHBadGdnYklYZTRHUmFkbHMrYVdyOFB3T0pReUwy?=
 =?gb2312?B?Y21ZL094cysyekoyWktwWHlBYUNJVUVlYzBLY3IyM2k4MERiOFR2OUdSNEdz?=
 =?gb2312?B?OFkwbzVsT2hRdGRLUFRwRFpkamlFa1RoRTRzV3lqUTBUd2NMSzIrQnFmTFZr?=
 =?gb2312?B?UVk1TThBZ3EvazdZcVRrVGdwN1NubkNLbjhnVUhhQTNqRk02YmM0QlVsL3Rt?=
 =?gb2312?B?QWtMVzUxUDBtSlZ4c1FSUXJMOCs1dlVOU3BQV3VyTU1LV2NacTY1YU1FOUND?=
 =?gb2312?B?TlQyKzFreU8yQ1JrYjB6aHpoMWl0aStqem1DcTdJOEE3eHB6U3ZZbXpLYVJz?=
 =?gb2312?B?SnkvVVRUNGF3bVpYb2dKMVVoWk0xdjJnY0dDSnI5ZFd4Wk1mdFJwRFdPUGRh?=
 =?gb2312?B?cUtmajNIZjJrcFhKNU54QWFHVnNXN1ZGaytWK0VOMzhMZXVtc2w3WllTQ1Mr?=
 =?gb2312?B?TVl0d3ZEWEJlUjBwejVGdWZvdmx6WVJYQjV5dDlDK3Evc3Azc2Zua1FvVHBO?=
 =?gb2312?B?TVkxSVJYTEtGMnQrZnkxT3ltcHFYOHFuaS9WTDVucnFtQ1VFRVVKWS9HRUl1?=
 =?gb2312?B?SWZ2SUhVQW1Zank4WlRXUkUrQTd3WGs3cllqNmhOZkNTS1J1NmlFeVV2S0M5?=
 =?gb2312?B?am1vT3FMcFBQL01sTzA5Tys5VFgweHdWanJabGUwZk0zOVZkZGFCL3l2anZG?=
 =?gb2312?B?ejdtVENRa1d4UTdIM201a3hPUENDaVozL1JQZmFCREhMUUoyRTZmYmpVZE01?=
 =?gb2312?Q?2S5MG5nxeclOYUtbCLT/WY+fryOb/0Gd5E1nMDC?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a899c177-1efd-419b-6594-08d93565f987
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2021 10:10:34.2495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HZV/ps18v6Prf9zU6S4d9pryJ6KIsABRM+PuXQBSszwp1U23J7MbhP8kHyQyy+Tdu89HHg95kzbBGkLeotgeVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7195
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWljaGFsLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1pY2hh
bCBLdWJlY2VrIDxta3ViZWNla0BzdXNlLmN6Pg0KPiBTZW50OiAyMDIxxOo21MIxNsjVIDc6MjUN
Cj4gVG86IFkuYi4gTHUgPHlhbmdiby5sdUBueHAuY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgta3NlbGZ0ZXN0
QHZnZXIua2VybmVsLm9yZzsgbXB0Y3BAbGlzdHMubGludXguZGV2OyBSaWNoYXJkIENvY2hyYW4N
Cj4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT47IERhdmlkIFMgLiBNaWxsZXIgPGRhdmVtQGRh
dmVtbG9mdC5uZXQ+Ow0KPiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgTWF0IE1h
cnRpbmVhdQ0KPiA8bWF0aGV3LmoubWFydGluZWF1QGxpbnV4LmludGVsLmNvbT47IE1hdHRoaWV1
IEJhZXJ0cw0KPiA8bWF0dGhpZXUuYmFlcnRzQHRlc3NhcmVzLm5ldD47IFNodWFoIEtoYW4gPHNo
dWFoQGtlcm5lbC5vcmc+OyBGbG9yaWFuDQo+IEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNv
bT47IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IFJ1aSBTb3VzYQ0KPiA8cnVpLnNvdXNh
QG54cC5jb20+OyBTZWJhc3RpZW4gTGF2ZXplIDxzZWJhc3RpZW4ubGF2ZXplQG54cC5jb20+DQo+
IFN1YmplY3Q6IFJlOiBbbmV0LW5leHQsIHYzLCAwNS8xMF0gZXRodG9vbDogYWRkIGEgbmV3IGNv
bW1hbmQgZm9yIGdldHRpbmcgUEhDDQo+IHZpcnR1YWwgY2xvY2tzDQo+IA0KPiBPbiBUdWUsIEp1
biAxNSwgMjAyMSBhdCAwNTo0NToxMlBNICswODAwLCBZYW5nYm8gTHUgd3JvdGU6DQo+ID4gQWRk
IGFuIGludGVyZmFjZSBmb3IgZ2V0dGluZyBQSEMgKFBUUCBIYXJkd2FyZSBDbG9jaykgdmlydHVh
bCBjbG9ja3MsDQo+ID4gd2hpY2ggYXJlIGJhc2VkIG9uIFBIQyBwaHlzaWNhbCBjbG9jayBwcm92
aWRpbmcgaGFyZHdhcmUgdGltZXN0YW1wIHRvDQo+ID4gbmV0d29yayBwYWNrZXRzLg0KPiA+DQo+
ID4gU2lnbmVkLW9mZi1ieTogWWFuZ2JvIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gPiAtLS0N
Cj4gPiBDaGFuZ2VzIGZvciB2MzoNCj4gPiAJLSBBZGRlZCB0aGlzIHBhdGNoLg0KPiA+IC0tLQ0K
PiA+ICBpbmNsdWRlL2xpbnV4L2V0aHRvb2wuaCAgICAgICAgICAgICAgfCAgMiArDQo+ID4gIGlu
Y2x1ZGUvdWFwaS9saW51eC9ldGh0b29sLmggICAgICAgICB8IDE0ICsrKysrDQo+ID4gIGluY2x1
ZGUvdWFwaS9saW51eC9ldGh0b29sX25ldGxpbmsuaCB8IDE1ICsrKysrDQo+ID4gIG5ldC9ldGh0
b29sL01ha2VmaWxlICAgICAgICAgICAgICAgICB8ICAyICstDQo+ID4gIG5ldC9ldGh0b29sL2Nv
bW1vbi5jICAgICAgICAgICAgICAgICB8IDIzICsrKysrKysrDQo+ID4gIG5ldC9ldGh0b29sL2Nv
bW1vbi5oICAgICAgICAgICAgICAgICB8ICAyICsNCj4gPiAgbmV0L2V0aHRvb2wvaW9jdGwuYyAg
ICAgICAgICAgICAgICAgIHwgMjcgKysrKysrKysrDQo+ID4gIG5ldC9ldGh0b29sL25ldGxpbmsu
YyAgICAgICAgICAgICAgICB8IDEwICsrKysNCj4gPiAgbmV0L2V0aHRvb2wvbmV0bGluay5oICAg
ICAgICAgICAgICAgIHwgIDIgKw0KPiA+ICBuZXQvZXRodG9vbC9waGNfdmNsb2Nrcy5jICAgICAg
ICAgICAgfCA4Ng0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIDEwIGZpbGVz
IGNoYW5nZWQsIDE4MiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pICBjcmVhdGUgbW9kZQ0K
PiA+IDEwMDY0NCBuZXQvZXRodG9vbC9waGNfdmNsb2Nrcy5jDQo+IA0KPiBXaGVuIHVwZGF0aW5n
IHRoZSBldGh0b29sIG5ldGxpbmsgQVBJLCBwbGVhc2UgdXBkYXRlIGFsc28gaXRzIGRvY3VtZW50
YXRpb24NCj4gaW4gRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL2V0aHRvb2wtbmV0bGluay5yc3QN
Cg0KV2lsbCB1cGRhdGUgZG9jLiBUaGFuayB5b3UuDQoNCj4gDQo+IE1pY2hhbA0K
