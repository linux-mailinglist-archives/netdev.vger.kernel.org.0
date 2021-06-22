Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1783B00F7
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 12:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhFVKM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 06:12:27 -0400
Received: from mail-eopbgr60061.outbound.protection.outlook.com ([40.107.6.61]:30542
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229612AbhFVKMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 06:12:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SveuHAzDdk92u3SPsiME3sCf7jsJaiXaAuGd3Yo6sQv/QPd8gHO52saQUVcIVbDg3elke4ZMxnugOFE3hi9lGnJOnUqi5q7CbZ/FNXkE8ahKPxtroUzBtzEVfdHqxrBBZHe6XKmmi/i5oSbN/Q/CsXpoLuG/gOlop8egjYEAl0FGjETSspEhW0k30sgvMeoGDwH6WKc/lH30ZWI8c6V+76/lmeYFGIXstV3One6smg0tS0ORIk9+yt/8DbIVvSyYPAJ2WiGbD24FcrLSz9/UuO9VfJWTIG2JqcU36brDAnL6wnmDDDuA1F70v0FPqu9snLiN+S1G+NTgQzC27z6eAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e0yM1/9gHtjJkVf9yEpis6DdEpIfMn4rpN9afX4reW8=;
 b=M7tEpJ06qCp4d5JnHRrxQrGhZSWs+TvmMY3A9td301F0TzpJDZP+95FaB/EXS3n506jY+X/fg+NtdTtc0Rf3mLfwg2tq6WLVmO7Qabq5pWGLIX+JvhPns/S65+dzceCTgWoeZCGcIaMRhSDjZkL5N+SjYdRfec5RkJL6yZhGZbr6690wn5CIW4UQe90ZFG+ONp0tUPNxtdO5wPh1tI4NCzOjxW7/wrNSg2IMX52ih42D3bAos9MVqA3144iIUMF4S45BXNLqC0qOu81DLY/2Kp4BEds8oaRQH5Y2xlm12Ot/ltQu0g1zMt6nfafpAhuDfBjEWnabG/SCcqj7VzJ+hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e0yM1/9gHtjJkVf9yEpis6DdEpIfMn4rpN9afX4reW8=;
 b=rQRYD/bfXU48suYZQRmBJhznj7QLq7qFWcMjbcAthKAZRvOVldGHEYV5vrOR322S2V4Fsj1rxWjyFZoI+sa236ram2kl6KNMk1lfpZcl/NcB6uu7I8vQ45K2tYFoZrf7shfakJES707eVigWk4nSrvUaZOgTDMA2GGVjSUN7pHg=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DB8PR04MB7195.eurprd04.prod.outlook.com (2603:10a6:10:12d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Tue, 22 Jun
 2021 10:10:06 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd%7]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 10:10:06 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mptcp@lists.linux.dev" <mptcp@lists.linux.dev>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: RE: [net-next, v3, 05/10] ethtool: add a new command for getting PHC
 virtual clocks
Thread-Topic: [net-next, v3, 05/10] ethtool: add a new command for getting PHC
 virtual clocks
Thread-Index: AQHXYcnzlGPfNAMo8ESiD/s4IvxeJasVe3GAgApd0XA=
Date:   Tue, 22 Jun 2021 10:10:05 +0000
Message-ID: <DB7PR04MB5017C6E0D6223B4D9B80EA1DF8099@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210615094517.48752-1-yangbo.lu@nxp.com>
        <20210615094517.48752-6-yangbo.lu@nxp.com>
 <20210615124911.15e64ce9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210615124911.15e64ce9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37bac1bb-48f4-4dcc-90dc-08d93565e8b3
x-ms-traffictypediagnostic: DB8PR04MB7195:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB7195C5A21AF7F9E95EE81E39F8099@DB8PR04MB7195.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0QGyGGmkWfknNFohItGJDvqY/pthsXAL5aHwGMGpkGnGN5ExvKF9/cg+vcsB/hdPogaumEarMXnjQNkdH4l5Dgtrx1oAyAK7gzRCaEgfjKtguy331TcHEfrAKPjeDptUVGY3NpRwDsuB6/qT48AETQ93G8V3dddebkVvcNaeQ2FTNwdCKOkvvnUqBqcFnYyhEf9hsDDm3rX90eVCz7DoKIrRyrLmzgHhSLGMm/68rAYBuhfwqah/hhrQjob4HGpLHjyT0jrNKzDuwWADng4IUEDjnQoOKXaip6iT5dlObHh/M7mYWXzyRQVyh8cJ3zSxeKuk66Ri73S6VGE5/IxA3l1weslAPcbhBMKXuClrS+ERq/0N3d8URXFMoq7WxDKFZlxnQLIGsglG+Ov7xDkCWmCi4jbhE/8ELhmw7+A6DMQI/Y07g8UFKJvMUYussTaYNgMSKbcrXV2kBaHqaXn2hcxuXwDeiZAG6XMPcRQppIdU8rqu1+ON1+GTFcVs4L/Rqie/uvEP3hc4xMb4spzs4sPcU1VjvPf+C/CPZOK4J+UUDXWfmlgcQ/4eUbWLg1vl09qJATBIJH/REj7D32th+6zgl6dBiU1ik2uBZJaVBhEKNBT4Wo5VPSBO5OzebHkedCr2VwKDKZxcupqWZ0NCejxf8uVqOX/3ywIUSnHsR+c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(7696005)(9686003)(55016002)(6506007)(53546011)(26005)(186003)(83380400001)(122000001)(38100700002)(71200400001)(52536014)(478600001)(2906002)(66446008)(5660300002)(4326008)(86362001)(64756008)(66556008)(66476007)(66946007)(76116006)(6916009)(54906003)(33656002)(8676002)(8936002)(7416002)(316002)(134885004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?c1JlSFl6eHlRencyN2xnaFZUZTYwS3NZcXhtTVZObitUaCtWTXZkYlhkc3RC?=
 =?gb2312?B?NC9aWGVYOS8vdzVrTEFVa09KM0VKaFlrRVl5aC85WDdubnJDcXJmOG1iWG81?=
 =?gb2312?B?eXdwUkliYXFjYUVVa2t6b0FndTBxTVdleVV4d1ZPOGVnSlZZTlZSMGhPR1p0?=
 =?gb2312?B?TkNKbU0zWXFlNEU1ZjFpSDVnV3BFR3Q5S1RIVTBtenZYWk1tSE9DTG9lT1dN?=
 =?gb2312?B?NXVXNzI5S0Y4U3JQLzhaTjNaTkdydVBhNmQ0Tk1qTjdJa29DaThSU3FVVzlD?=
 =?gb2312?B?TnFCQllkWmZBSVJKYVRneitkNU5TSEF6cWVHcXV1WGhiK1I5NkQ2cTluenZY?=
 =?gb2312?B?RUVnUm9WclFxYTl0YUtHYW5ETm8ydVhuZHZkYitudUpQT29jNVQ3ejVxNito?=
 =?gb2312?B?cVBHUnJPRk9mWTg0aW54MDJRSmNvK045NU1aRDhPQTRIVncwRjJWWlFvanZD?=
 =?gb2312?B?NVhRdjZVOEJnamxEK0dlNDRTWGJnQXFFRktWUTYwaGhtbEdEVmY4bUE4T3py?=
 =?gb2312?B?VDhiVHNJeUdQNWI2eHRrdzhHc0xvWklDWVU4K292eGFZQTZQWWZvTy9lVHcy?=
 =?gb2312?B?SXRvT0FtUHdqL1p1MHFBWTdKM3VUekZtUStuZzRZRkRTdjVESGMwbUdVVCtn?=
 =?gb2312?B?L1M0M2F1bGJ4SytYMG92TmZ2UkFXa2dUWndWdWJ2NktpY0ZUNEpCY3hBaW4r?=
 =?gb2312?B?T3lnN3hOajQxZzJSU3MrcnVlQlNEUlZ1czBjSEk2TjNoSnZtQWxSUDJDWVhP?=
 =?gb2312?B?cWhzeFdGRW9zSTQ0alBFbVhnMGFCV0tHWWRLSVpCc0JSL2F3SnNwTmlNT3gw?=
 =?gb2312?B?WlJnVmRLTjg4bksvODR5VTIwcnZSMWZSZjc5UURpRUdPZ3dGU25ENjhBYkd2?=
 =?gb2312?B?c3pheDh1OE9INTBWSHI0cXBtQTJ0ZFJQVTBlQWFQS2ZTTmFzcXdMQ0JNTXFN?=
 =?gb2312?B?VzNkM1o5R2Vxc3BlVWlYWFovdXo1bVVFUEZvTFB6VUhwemVtVmtoblVkZlNs?=
 =?gb2312?B?b0hmaGpjQVZCRi9rZXAzOHkxaVQxQnFwRzl0T3JZR0x0d0Y1blVxYnRTUVRn?=
 =?gb2312?B?UnNQS0FGZG84TTBsZm1PQlhFSmxTMm1EemJ4WFBieDJoTUd0UzB0VSs5YUxS?=
 =?gb2312?B?SFF5UWdrRmZGNCtEd2pZaUV6aGJ0c1FueEYvdXRIZzhmSXNRVHNiQ0FWdi9V?=
 =?gb2312?B?Q3VMb2JVWDJsNW1mRU80T3AxblhhaGM4SkI1UGN3aHRMemVKUW5Xd2k1c3h0?=
 =?gb2312?B?c1l3Ti9QZzI2Y2xkVjByd2dCM0tKY0x0d3NxRGthZ0ttbkR0ZWFmNXdtbHM1?=
 =?gb2312?B?WUpYR2JZdytyckxaTFptVjdlTnJ4WTFITlpETnRDeG8ybDdUSkFjTHlIdUow?=
 =?gb2312?B?K05UZk1NLy9VSm1xZlpRYUNodlB1U05obHJTQ2srNWVhbmFQR0NLVDQ0cFpZ?=
 =?gb2312?B?SytZOW9xTjlpSC9jekwrTDNWb0wxcnRQUHlNd0hjcHYycXkxYzU2bUZoNklq?=
 =?gb2312?B?VXdWVlVrQU1LR1JsNDBwRE9zUVB6WkRaN0NmNmwvdjZkdmdDcGVNQ29wUEps?=
 =?gb2312?B?YjJZRFJFeXZnVzhDNTEyeEkyRzFPeVcvbU1jOUIvb3daVzRjRXIzQklxTVFF?=
 =?gb2312?B?RzVyRmpreDQwbXZkamNYamozUzhXekVBa1hQS3MyRGl4RVp3UFNRdTcwK2pk?=
 =?gb2312?B?WmZSc3JiMkd1TVNmaVJqR2QyZGRjYkdIa2NxTG5MOGlKQm1aajhDM0ZPSWNm?=
 =?gb2312?Q?jyF0ISimrlWHm87FLh83iOvrnvlB9hPDEse5FuE?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37bac1bb-48f4-4dcc-90dc-08d93565e8b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2021 10:10:06.0037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DrDxXzRrPpt1opPmJJwjZ7TQfvkPYAzbz9iXZumEcxzVRTKu858ZUEcgXiK6eGoF8Q83UfAASVAQvUN4PeTynw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7195
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrdWIsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIg
S2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogMjAyMcTqNtTCMTbI1SAzOjQ5DQo+
IFRvOiBZLmIuIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5l
bC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtzZWxmdGVzdEB2
Z2VyLmtlcm5lbC5vcmc7IG1wdGNwQGxpc3RzLmxpbnV4LmRldjsgUmljaGFyZCBDb2NocmFuDQo+
IDxyaWNoYXJkY29jaHJhbkBnbWFpbC5jb20+OyBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZl
bWxvZnQubmV0PjsgTWF0DQo+IE1hcnRpbmVhdSA8bWF0aGV3LmoubWFydGluZWF1QGxpbnV4Lmlu
dGVsLmNvbT47IE1hdHRoaWV1IEJhZXJ0cw0KPiA8bWF0dGhpZXUuYmFlcnRzQHRlc3NhcmVzLm5l
dD47IFNodWFoIEtoYW4gPHNodWFoQGtlcm5lbC5vcmc+OyBNaWNoYWwNCj4gS3ViZWNlayA8bWt1
YmVjZWtAc3VzZS5jej47IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPjsN
Cj4gQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPjsgUnVpIFNvdXNhIDxydWkuc291c2FAbnhw
LmNvbT47IFNlYmFzdGllbg0KPiBMYXZlemUgPHNlYmFzdGllbi5sYXZlemVAbnhwLmNvbT4NCj4g
U3ViamVjdDogUmU6IFtuZXQtbmV4dCwgdjMsIDA1LzEwXSBldGh0b29sOiBhZGQgYSBuZXcgY29t
bWFuZCBmb3IgZ2V0dGluZyBQSEMNCj4gdmlydHVhbCBjbG9ja3MNCj4gDQo+IE9uIFR1ZSwgMTUg
SnVuIDIwMjEgMTc6NDU6MTIgKzA4MDAgWWFuZ2JvIEx1IHdyb3RlOg0KPiA+IEFkZCBhbiBpbnRl
cmZhY2UgZm9yIGdldHRpbmcgUEhDIChQVFAgSGFyZHdhcmUgQ2xvY2spIHZpcnR1YWwgY2xvY2tz
LA0KPiA+IHdoaWNoIGFyZSBiYXNlZCBvbiBQSEMgcGh5c2ljYWwgY2xvY2sgcHJvdmlkaW5nIGhh
cmR3YXJlIHRpbWVzdGFtcCB0bw0KPiA+IG5ldHdvcmsgcGFja2V0cy4NCj4gPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IFlhbmdibyBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQo+IA0KPiA+IGRpZmYgLS1n
aXQgYS9pbmNsdWRlL3VhcGkvbGludXgvZXRodG9vbC5oDQo+ID4gYi9pbmNsdWRlL3VhcGkvbGlu
dXgvZXRodG9vbC5oIGluZGV4IGNmZWY2YjA4MTY5YS4uMGZiMDRmOTQ1NzY3IDEwMDY0NA0KPiA+
IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9ldGh0b29sLmgNCj4gPiArKysgYi9pbmNsdWRlL3Vh
cGkvbGludXgvZXRodG9vbC5oDQo+ID4gQEAgLTE3LDYgKzE3LDcgQEANCj4gPiAgI2luY2x1ZGUg
PGxpbnV4L2NvbnN0Lmg+DQo+ID4gICNpbmNsdWRlIDxsaW51eC90eXBlcy5oPg0KPiA+ICAjaW5j
bHVkZSA8bGludXgvaWZfZXRoZXIuaD4NCj4gPiArI2luY2x1ZGUgPGxpbnV4L3B0cF9jbG9jay5o
Pg0KPiA+DQo+ID4gICNpZm5kZWYgX19LRVJORUxfXw0KPiA+ICAjaW5jbHVkZSA8bGltaXRzLmg+
IC8qIGZvciBJTlRfTUFYICovIEBAIC0xMzQxLDYgKzEzNDIsMTggQEAgc3RydWN0DQo+ID4gZXRo
dG9vbF90c19pbmZvIHsNCj4gPiAgCV9fdTMyCXJ4X3Jlc2VydmVkWzNdOw0KPiA+ICB9Ow0KPiA+
DQo+ID4gKy8qKg0KPiA+ICsgKiBzdHJ1Y3QgZXRodG9vbF9waGNfdmNsb2NrcyAtIGhvbGRzIGEg
ZGV2aWNlJ3MgUFRQIHZpcnR1YWwgY2xvY2tzDQo+ID4gKyAqIEBjbWQ6IGNvbW1hbmQgbnVtYmVy
ID0gJUVUSFRPT0xfR0VUX1BIQ19WQ0xPQ0tTDQo+ID4gKyAqIEBudW06IG51bWJlciBvZiBQVFAg
dmNsb2Nrcw0KPiA+ICsgKiBAaW5kZXg6IGFsbCBpbmRleCB2YWx1ZXMgb2YgUFRQIHZjbG9ja3Mg
ICovIHN0cnVjdA0KPiA+ICtldGh0b29sX3BoY192Y2xvY2tzIHsNCj4gPiArCV9fdTMyCWNtZDsN
Cj4gPiArCV9fdTgJbnVtOw0KPiA+ICsJX19zMzIJaW5kZXhbUFRQX01BWF9WQ0xPQ0tTXTsNCj4g
PiArfTsNCj4gPiArDQo+ID4gIC8qDQo+ID4gICAqICVFVEhUT09MX1NGRUFUVVJFUyBjaGFuZ2Vz
IGZlYXR1cmVzIHByZXNlbnQgaW4gZmVhdHVyZXNbXS52YWxpZCB0bw0KPiB0aGUNCj4gPiAgICog
dmFsdWVzIG9mIGNvcnJlc3BvbmRpbmcgYml0cyBpbiBmZWF0dXJlc1tdLnJlcXVlc3RlZC4gQml0
cyBpbg0KPiA+IC5yZXF1ZXN0ZWQgQEAgLTE1NTIsNiArMTU2NSw3IEBAIGVudW0gZXRodG9vbF9m
ZWNfY29uZmlnX2JpdHMgew0KPiA+ICAjZGVmaW5lIEVUSFRPT0xfUEhZX1NUVU5BQkxFCTB4MDAw
MDAwNGYgLyogU2V0IFBIWSB0dW5hYmxlDQo+IGNvbmZpZ3VyYXRpb24gKi8NCj4gPiAgI2RlZmlu
ZSBFVEhUT09MX0dGRUNQQVJBTQkweDAwMDAwMDUwIC8qIEdldCBGRUMgc2V0dGluZ3MgKi8NCj4g
PiAgI2RlZmluZSBFVEhUT09MX1NGRUNQQVJBTQkweDAwMDAwMDUxIC8qIFNldCBGRUMgc2V0dGlu
Z3MgKi8NCj4gPiArI2RlZmluZSBFVEhUT09MX0dFVF9QSENfVkNMT0NLUwkweDAwMDAwMDUyIC8q
IEdldCBQSEMgdmlydHVhbA0KPiBjbG9ja3MgaW5mbyAqLw0KPiANCj4gV2UgZG9uJ3QgYWRkIG5l
dyBJT0NUTCBjb21tYW5kcywgb25seSBuZXRsaW5rIEFQSSBpcyBnb2luZyB0byBiZSBleHRlbmRl
ZC4NCj4gUGxlYXNlIHJlbW92ZSB0aGUgSU9DVEwgaW50ZXJmYWNlICYgdUFQSS4NCg0KV2lsbCBy
ZW1vdmUuIFRoYW5rcy4NCg0KPiANCj4gPiAgLyogY29tcGF0aWJpbGl0eSB3aXRoIG9sZGVyIGNv
ZGUgKi8NCj4gPiAgI2RlZmluZSBTUEFSQ19FVEhfR1NFVAkJRVRIVE9PTF9HU0VUDQo+IA0KPiA+
ICsvKiBQSEMgVkNMT0NLUyAqLw0KPiA+ICsNCj4gPiArZW51bSB7DQo+ID4gKwlFVEhUT09MX0Ff
UEhDX1ZDTE9DS1NfVU5TUEVDLA0KPiA+ICsJRVRIVE9PTF9BX1BIQ19WQ0xPQ0tTX0hFQURFUiwJ
CQkvKiBuZXN0IC0gX0FfSEVBREVSXyoNCj4gKi8NCj4gPiArCUVUSFRPT0xfQV9QSENfVkNMT0NL
U19OVU0sCQkJLyogdTggKi8NCj4gDQo+IHUzMiwgbm8gbmVlZCB0byBsaW1pdCB5b3Vyc2VsZiwg
dGhlIG5ldGxpbmsgYXR0cmlidXRlIGlzIHJvdW5kZWQgdXAgdG8gNEINCj4gYW55d2F5Lg0KDQpH
ZXQgaXQuIFdpbGwgdXNlIHUzMi4NCg0KPiANCj4gPiArCUVUSFRPT0xfQV9QSENfVkNMT0NLU19J
TkRFWCwJCQkvKiBzMzIgKi8NCj4gDQo+IFRoaXMgaXMgYW4gYXJyYXksIEFGQUlDVCwgbm90IGEg
c2luZ2xlIHMzMi4NCg0KV2lsbCBmaXguIFRoYW5rcy4NCg0KPiANCj4gPiArDQo+ID4gKwkvKiBh
ZGQgbmV3IGNvbnN0YW50cyBhYm92ZSBoZXJlICovDQo+ID4gKwlfX0VUSFRPT0xfQV9QSENfVkNM
T0NLU19DTlQsDQo+ID4gKwlFVEhUT09MX0FfUEhDX1ZDTE9DS1NfTUFYID0gKF9fRVRIVE9PTF9B
X1BIQ19WQ0xPQ0tTX0NOVCAtDQo+IDEpIH07DQo+ID4gKw0KPiA+ICAvKiBDQUJMRSBURVNUICov
DQo+ID4NCj4gPiAgZW51bSB7DQo+IA0KPiA+ICtzdGF0aWMgaW50IHBoY192Y2xvY2tzX2ZpbGxf
cmVwbHkoc3RydWN0IHNrX2J1ZmYgKnNrYiwNCj4gPiArCQkJCSAgY29uc3Qgc3RydWN0IGV0aG5s
X3JlcV9pbmZvICpyZXFfYmFzZSwNCj4gPiArCQkJCSAgY29uc3Qgc3RydWN0IGV0aG5sX3JlcGx5
X2RhdGEgKnJlcGx5X2Jhc2UpIHsNCj4gPiArCWNvbnN0IHN0cnVjdCBwaGNfdmNsb2Nrc19yZXBs
eV9kYXRhICpkYXRhID0NCj4gPiArCQlQSENfVkNMT0NLU19SRVBEQVRBKHJlcGx5X2Jhc2UpOw0K
PiA+ICsJY29uc3Qgc3RydWN0IGV0aHRvb2xfcGhjX3ZjbG9ja3MgKnBoY192Y2xvY2tzID0gJmRh
dGEtPnBoY192Y2xvY2tzOw0KPiA+ICsNCj4gPiArCWlmIChwaGNfdmNsb2Nrcy0+bnVtIDw9IDAp
DQo+ID4gKwkJcmV0dXJuIDA7DQo+ID4gKw0KPiA+ICsJaWYgKG5sYV9wdXRfdTMyKHNrYiwgRVRI
VE9PTF9BX1BIQ19WQ0xPQ0tTX05VTSwgcGhjX3ZjbG9ja3MtPm51bSkNCj4gfHwNCj4gPiArCSAg
ICBubGFfcHV0KHNrYiwgRVRIVE9PTF9BX1BIQ19WQ0xPQ0tTX0lOREVYLA0KPiA+ICsJCSAgICBz
aXplb2YocGhjX3ZjbG9ja3MtPmluZGV4KSwgcGhjX3ZjbG9ja3MtPmluZGV4KSkNCj4gDQo+IExv
b2tzIGxpa2UgeW91J2xsIHJlcG9ydCB0aGUgd2hvbGUgYXJyYXksIHdoeSBub3QganVzdCBudW0/
DQoNCldpbGwgcmVwb3J0IGp1c3QgbnVtLiBUaGFua3MuDQoNCj4gDQo+ID4gKwkJcmV0dXJuIC1F
TVNHU0laRTsNCj4gPiArDQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4gPiArY29u
c3Qgc3RydWN0IGV0aG5sX3JlcXVlc3Rfb3BzIGV0aG5sX3BoY192Y2xvY2tzX3JlcXVlc3Rfb3Bz
ID0gew0KPiA+ICsJLnJlcXVlc3RfY21kCQk9IEVUSFRPT0xfTVNHX1BIQ19WQ0xPQ0tTX0dFVCwN
Cj4gPiArCS5yZXBseV9jbWQJCT0gRVRIVE9PTF9NU0dfUEhDX1ZDTE9DS1NfR0VUX1JFUExZLA0K
PiA+ICsJLmhkcl9hdHRyCQk9IEVUSFRPT0xfQV9QSENfVkNMT0NLU19IRUFERVIsDQo+ID4gKwku
cmVxX2luZm9fc2l6ZQkJPSBzaXplb2Yoc3RydWN0IHBoY192Y2xvY2tzX3JlcV9pbmZvKSwNCj4g
PiArCS5yZXBseV9kYXRhX3NpemUJPSBzaXplb2Yoc3RydWN0IHBoY192Y2xvY2tzX3JlcGx5X2Rh
dGEpLA0KPiA+ICsNCj4gPiArCS5wcmVwYXJlX2RhdGEJCT0gcGhjX3ZjbG9ja3NfcHJlcGFyZV9k
YXRhLA0KPiA+ICsJLnJlcGx5X3NpemUJCT0gcGhjX3ZjbG9ja3NfcmVwbHlfc2l6ZSwNCj4gPiAr
CS5maWxsX3JlcGx5CQk9IHBoY192Y2xvY2tzX2ZpbGxfcmVwbHksDQo+ID4gK307DQoNCg==
