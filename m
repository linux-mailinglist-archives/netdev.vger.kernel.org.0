Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBA33FEA17
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 09:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243628AbhIBHgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 03:36:06 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:59804
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243607AbhIBHgD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 03:36:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5KnyRyPcGTWaZ0M5fDHgoRp0s2vlBqftmV3yyoeadT0PWuvJHy5d+05wUAjf2HhF6vfVLIZriefz7I+lR/hCkUdjM2EnZWfk7PKgPPtDoxkFct1Q85YajlW+uLy3FNYWTyT1jaAGDyE1GSWUcafd4Q+LsvEpCGM8Bncn+C3cGyFomDLMaRfzzsn8cp5vM+DHedhGVXPTb6HD/ANxkFd8hr1y5P33ebJyGjPBT4jjit9wNUY+4o56E+kvQVQepyl9kdhN40n04nPctlF+vEKOoANXLXUpJhESFd/F+66KqsR/QjCWm5c0L6Yn7S2SR6bPSSH7FZWhycH4N1aQpexHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=k/w3e83WNbm807fYnUj/7+0ZRH76TmYdO2eEm4KHM7M=;
 b=lKN4Jr1dSsQtgTC5uy8B1iGupSJI1p6z83GWQvjFaF4ZlBJT/FvCoB6k5n3yg6C3b2PgJLXgvLKusnzZBoU87iyTRJpz5n8f2vetvHlrh4hWGC3Wu2w+MnuKqpZHZ4jHzO+P8ojnagFWdKoOGhYkW/wbv2dEc6nKbdwh9SraSfLeB2f39eT6NYT3nn0VHFoZrTPHZLirnZ3KIpeiZxEz4CTnJYIVhUI3Pc1kY1Y/Xet/9lc0P7gGKzghI2D2J7IqXwbQ1xrUjs/AgIA1n9MQHEmk4JJ3If7l0r9LnGvF8sBG2Te6S7njM0GPrRA4qoIs5fYL2GFk7nZmWy5fLz2j7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k/w3e83WNbm807fYnUj/7+0ZRH76TmYdO2eEm4KHM7M=;
 b=CQD2CNSP+GnewZN8jSztIVaKpDSaCMPDNlazR7wXW50zSJ8bVvOY+zD2qyS7ZjEZbBtD/OD8St4kZfs+k30TjWmKrrrLNzXStJizkPn4NQDncYLMxV4Y66FPTO1o3G13AttSNppS3mfkg2LQpMFBnUT91O+xF3wuxfLqvwW+UeU=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7480.eurprd04.prod.outlook.com (2603:10a6:10:1a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Thu, 2 Sep
 2021 07:35:00 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f%9]) with mapi id 15.20.4457.024; Thu, 2 Sep 2021
 07:35:00 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Thread-Topic: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Thread-Index: AQHXnxAXiWCMYvQkY0qCXzBIAPLPn6uO5SQAgAAMK0CAAF/nAIAA8fnA
Date:   Thu, 2 Sep 2021 07:35:00 +0000
Message-ID: <DB8PR04MB679538A84C8FE245F16B200AE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210901090228.11308-1-qiangqing.zhang@nxp.com>
 <20210901091332.GZ22278@shell.armlinux.org.uk>
 <DB8PR04MB67959C4B1D1AFEC5AEEB73F3E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <ce36eb26-a304-9dd8-3bee-4117929a5546@gmail.com>
In-Reply-To: <ce36eb26-a304-9dd8-3bee-4117929a5546@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d02c3cd-7220-43f3-cc0b-08d96de42bcd
x-ms-traffictypediagnostic: DBAPR04MB7480:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB748019E5FA4242A8750668B5E6CE9@DBAPR04MB7480.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bwBUaWDImZYkLuqB+IQhvLO4FpcYE9Mki1iqxi+NFVVc+chMU36FLFJpifAw04iwuItZC9W/i1Yx5V8/DRrPS2xZCsBCswOh75BoGnBV/5h1CcdxR4UIhHRJ34xiVRxrGlcJtT5B/xBliurQw6mmBsqFikG/hocCyTIYeGwS+jlYdWUT8ygxb2sQgQ/kbbqqGnJz5IWw0UiPPo7h/g0h8BCGQGfGvFEMxCxp1AKeMFRlQDW+GTX7ZBeUzXxKFzM0BkuY8NK3jj9PwbDM91/SPwy5GKQgCsA5lwwky7uqK85royrDiY20G4OpIDX+bifljexVuCKyYTKnORpI/fNcycvCDK+vIVtpon2L5ZDhSWrr2VfpEuO0udXqxMVQen1tShBjE2J3xSOKx972JWcCqx39DTUXshp5T9yBcMQaoGKPLDtZ+KuzQBHG4jhiROjU1p1jKOZL8lULS5uu8wviaQncDlG+qU0Thm8oFa0AlhtwHwGZqluexsAF6eW+r7IIT6u9ZkCgUhZHX5a8jSX4I76V76IaUTRSEWIpPeEiwOKAbwBYmrdV0EYgcX0k6oNo1uvmTmy5vbQUvptD3XoEcUsJHYze4oeXhaGF972GxVXOPYcNdl1EC0GvxWX+O8Ur4joQFGeu9ySXRiUGGR1SCi4D9HsHtsMQb99Psl2vWXDqWCtQw+tWTcszBB9tCQ7nanYgi5NJ0b4bpuitZyab88L4n5c8rpb5Ku89e7IUDZXHq0dVxwRPTs/bH2GC9+8GNJX6aRB2iKu8NNJY8X5kmtJiqLcTXsiW0tLYlgDdtUo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(26005)(316002)(5660300002)(52536014)(54906003)(71200400001)(55016002)(9686003)(186003)(66446008)(64756008)(66556008)(110136005)(7696005)(966005)(66476007)(4326008)(7416002)(66946007)(6506007)(2906002)(76116006)(8676002)(8936002)(478600001)(45080400002)(53546011)(33656002)(38100700002)(86362001)(122000001)(38070700005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?am9BdjRYdFBZMjErMHBNTU5yNTJWcUJmbzVmcjNqNzhPQWhCQ0dXQUVvWTFj?=
 =?gb2312?B?ZWF5bFdDWE1WUEF6ZW41eDN0SVNIV1ZOcWNPSVBxR2l3WlpPUlZodmpweEdz?=
 =?gb2312?B?YW5oMSs5YTMwZnRqQVBTQ1ZWNlplNnhiTUhZblQxcWNGb0NRdThsTHVVZEln?=
 =?gb2312?B?UHRhcE90cTlxbkp6VlVYM0NNSW9lR3czU0pkQTI2c2ZkZjQvamIzOVQwVjJs?=
 =?gb2312?B?bENhc1k1b2Y1dE05SGZLYWFoS1llU3ZLREUvTXg2Tk5OZEVWMDlBQzlhMUFh?=
 =?gb2312?B?dy91eEI0NU9zWWNEMHc3dVB3bnRKeFFJRFlFallNZEFjMXFqRy9YN3M3R2xx?=
 =?gb2312?B?T3V3M0lsSStlZ2hBZklYUkl6UUNRS1d3UXJWaWc1Z2dtYzVMQlFsRDFRdGxo?=
 =?gb2312?B?d29QVTNrRzAyakZMYXdTcEpOSUFwendyS1hlbW5hRDlGcTgzdmJBZDl6andh?=
 =?gb2312?B?Y1VCaTNyc3NpM2VZenNnMGxKc3pBMnY1MitEU2JoMW1hYTVub3JxcktrSFVa?=
 =?gb2312?B?Uk1wZVdoRXBEOTdsUmRrWlkydzRVeE8waDFwd0FERVAzN2tWNGk4bTN2N084?=
 =?gb2312?B?TzBiSWlwcGZvdVhVUHRrMVlrZjlJWnlVaHpvMG11L0xtVzFSWW5yb0Y3Vld4?=
 =?gb2312?B?SXBMazJtbFV2VmxqZmRkUytmYktJemR3dnhlMEM0UnlTSXFXTWVMb1d1Y2NL?=
 =?gb2312?B?c1RyNEE0OEk0aGQ0QmdvYzIvVzFZYjJJVkVsakpMZVVxZlJrelM0UXZXOWZ4?=
 =?gb2312?B?eFVoNndGaUFrZUZ5UTV4SForazJkWjM3K0RaV1pxTVRvVXI3S2FOODJWTE9L?=
 =?gb2312?B?aTUzL3E5OVR4dEZqMWU4dkR4ci9ReVBwRVVFcFFQc3k1KzVBU1JobjRmSjdD?=
 =?gb2312?B?a3BleXptY1hMZEFVQ0xlTHZ0MHFvNktGaWpicVNKenBWMTZ3VTZyMGRJczFI?=
 =?gb2312?B?Mmxwa2xvNlRESVJXK25ZajQ4d3Q2K1JYdDlSQk9PUUhPeHI4YzcyQjM0RWpS?=
 =?gb2312?B?TFJ3QTE0emtLR2pXMkptem5GTnhFMUNIek50NjcvL2wxNTkvRk1kckd5YmlH?=
 =?gb2312?B?cmRTVU0vRkViZ1pSQXY0aFRJcVJJTkNoR1d5RkRjcW5yYVBDTzZCUjA3cWc2?=
 =?gb2312?B?a2sydC9JOVN0NUY1emtNUUZxRVUvL0lHdm91Y0FxdlFPL3VYcDRYUXRWQms3?=
 =?gb2312?B?L2hZT21mdTBxZ2JzV3JyUE9pMDlBSFdZazAyclN6am5ldnBHaytOQThyNGxz?=
 =?gb2312?B?YU9kL0JpVytEQ29ramhXTWVGUHdMektOOE5HdUw5OFgzdThBMEZiMjF4elk4?=
 =?gb2312?B?NW5MQkg2eWFiNko1YjlXYnVzRjhUQ3NQbFhVbG53S1IwcHdRWEloQlRHQlhy?=
 =?gb2312?B?a2FvZE5admxmSm00RHZFNjFlaWwxLzZ2NGxxY2VCQ2JEU0QzY2NQdGI5V2Fq?=
 =?gb2312?B?c2laK2ZLNzVWWE55bXVTcGhGZENQTkRvUEJtTHNwVER5Qjh4eStZK0tkVjRl?=
 =?gb2312?B?RGhyMVJnTmwyL3ZYNmQzTStXYXhNOFN1VDNxaHQ5VjBlcXUvaHBHdXVhaHNC?=
 =?gb2312?B?NFc3WHc3T0U5RzVvVEpMMXhLTzN5VnV5VHc5TTRXbFp0MmZLVGt4MjlCaUtl?=
 =?gb2312?B?ODhDOTZDcXlaZnFnRWFIOEkxUVdhaUM3bHFLSTR4d2Y2c2JTTFVLSGYzU2lS?=
 =?gb2312?B?WDlkNXdRbVd6NnBEWGJVQ09nRXJadFBpQTA0ZGZlUGF1ckhwWGpJSW5vdXVC?=
 =?gb2312?Q?+hgIwEJp4JYVUEnB2GAh7JKO6bdTsvQ2XbCAoXG?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d02c3cd-7220-43f3-cc0b-08d96de42bcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 07:35:00.2552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CEEtDEOt7Z5Z56ReaaVB2fXtjtF6yRTWsxm9PIXPcnZ43J/risjSVLWNxoWi83Hgh1VKM52TOv18CNqp4zu8Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7480
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBIZWluZXIsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGVp
bmVyIEthbGx3ZWl0IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqOdTCMcjV
IDIzOjQwDQo+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgUnVz
c2VsbCBLaW5nDQo+IDxsaW51eEBhcm1saW51eC5vcmcudWs+DQo+IENjOiBwZXBwZS5jYXZhbGxh
cm9Ac3QuY29tOyBhbGV4YW5kcmUudG9yZ3VlQGZvc3Muc3QuY29tOw0KPiBqb2FicmV1QHN5bm9w
c3lzLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOw0KPiBtY29xdWVs
aW4uc3RtMzJAZ21haWwuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBhbmRyZXdAbHVubi5j
aDsNCj4gZi5mYWluZWxsaUBnbWFpbC5jb207IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5j
b20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIG5ldDogc3RtbWFjOiBmaXggTUFDIG5vdCB3b3Jr
aW5nIHdoZW4gc3lzdGVtIHJlc3VtZQ0KPiBiYWNrIHdpdGggV29MIGVuYWJsZWQNCj4gDQo+IE9u
IDAxLjA5LjIwMjEgMTI6MjEsIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPg0KPiA+IEhpIFJ1c3Nl
bGwsDQo+ID4NCj4gPj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPj4gRnJvbTogUnVz
c2VsbCBLaW5nIDxsaW51eEBhcm1saW51eC5vcmcudWs+DQo+ID4+IFNlbnQ6IDIwMjHE6jnUwjHI
1SAxNzoxNA0KPiA+PiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4N
Cj4gPj4gQ2M6IHBlcHBlLmNhdmFsbGFyb0BzdC5jb207IGFsZXhhbmRyZS50b3JndWVAZm9zcy5z
dC5jb207DQo+ID4+IGpvYWJyZXVAc3lub3BzeXMuY29tOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBr
dWJhQGtlcm5lbC5vcmc7DQo+ID4+IG1jb3F1ZWxpbi5zdG0zMkBnbWFpbC5jb207IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7IGFuZHJld0BsdW5uLmNoOw0KPiA+PiBmLmZhaW5lbGxpQGdtYWlsLmNv
bTsgaGthbGx3ZWl0MUBnbWFpbC5jb207IGRsLWxpbnV4LWlteA0KPiA+PiA8bGludXgtaW14QG54
cC5jb20+DQo+ID4+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIG5ldDogc3RtbWFjOiBmaXggTUFDIG5v
dCB3b3JraW5nIHdoZW4gc3lzdGVtDQo+ID4+IHJlc3VtZSBiYWNrIHdpdGggV29MIGVuYWJsZWQN
Cj4gPj4NCj4gPj4gT24gV2VkLCBTZXAgMDEsIDIwMjEgYXQgMDU6MDI6MjhQTSArMDgwMCwgSm9h
a2ltIFpoYW5nIHdyb3RlOg0KPiA+Pj4gV2UgY2FuIHJlcHJvZHVjZSB0aGlzIGlzc3VlIHdpdGgg
YmVsb3cgc3RlcHM6DQo+ID4+PiAxKSBlbmFibGUgV29MIG9uIHRoZSBob3N0DQo+ID4+PiAyKSBo
b3N0IHN5c3RlbSBzdXNwZW5kZWQNCj4gPj4+IDMpIHJlbW90ZSBjbGllbnQgc2VuZCBvdXQgd2Fr
ZXVwIHBhY2tldHMgV2UgY2FuIHNlZSB0aGF0IGhvc3Qgc3lzdGVtDQo+ID4+PiByZXN1bWUgYmFj
aywgYnV0IGNhbid0IHdvcmssIHN1Y2ggYXMgcGluZyBmYWlsZWQuDQo+ID4+Pg0KPiA+Pj4gQWZ0
ZXIgYSBiaXQgZGlnZ2luZywgdGhpcyBpc3N1ZSBpcyBpbnRyb2R1Y2VkIGJ5IHRoZSBjb21taXQN
Cj4gPj4+IDQ2ZjY5ZGVkOTg4ZA0KPiA+Pj4gKCJuZXQ6IHN0bW1hYzogVXNlIHJlc29sdmVkIGxp
bmsgY29uZmlnIGluIG1hY19saW5rX3VwKCkiKSwgd2hpY2gNCj4gPj4+IHVzZSB0aGUgZmluYWxp
c2VkIGxpbmsgcGFyYW1ldGVycyBpbiBtYWNfbGlua191cCgpIHJhdGhlciB0aGFuIHRoZQ0KPiA+
Pj4gcGFyYW1ldGVycyBpbiBtYWNfY29uZmlnKCkuDQo+ID4+Pg0KPiA+Pj4gVGhlcmUgYXJlIHR3
byBzY2VuYXJpb3MgZm9yIE1BQyBzdXNwZW5kL3Jlc3VtZToNCj4gPj4+DQo+ID4+PiAxKSBNQUMg
c3VzcGVuZCB3aXRoIFdvTCBkaXNhYmxlZCwgc3RtbWFjX3N1c3BlbmQoKSBjYWxsDQo+ID4+PiBw
aHlsaW5rX21hY19jaGFuZ2UoKSB0byBub3RpZnkgcGh5bGluayBtYWNoaW5lIHRoYXQgYSBjaGFu
Z2UgaW4gTUFDDQo+ID4+PiBzdGF0ZSwgdGhlbiAubWFjX2xpbmtfZG93biBjYWxsYmFjayB3b3Vs
ZCBiZSBpbnZva2VkLiBGdXJ0aGVyLCBpdA0KPiA+Pj4gd2lsbCBjYWxsIHBoeWxpbmtfc3RvcCgp
IHRvIHN0b3AgdGhlIHBoeWxpbmsgaW5zdGFuY2UuIFdoZW4gTUFDDQo+ID4+PiByZXN1bWUgYmFj
aywgZmlyc3RseSBwaHlsaW5rX3N0YXJ0KCkgaXMgY2FsbGVkIHRvIHN0YXJ0IHRoZSBwaHlsaW5r
DQo+ID4+PiBpbnN0YW5jZSwgdGhlbiBjYWxsIHBoeWxpbmtfbWFjX2NoYW5nZSgpIHdoaWNoIHdp
bGwgZmluYWxseSB0cmlnZ2VyDQo+ID4+PiBwaHlsaW5rIG1hY2hpbmUgdG8gaW52b2tlIC5tYWNf
Y29uZmlnIGFuZCAubWFjX2xpbmtfdXAgY2FsbGJhY2suIEFsbA0KPiA+Pj4gaXMgZmluZSBzaW5j
ZSBjb25maWd1cmF0aW9uIGluIHRoZXNlIHR3byBjYWxsYmFja3Mgd2lsbCBiZSBpbml0aWFsaXpl
ZC4NCj4gPj4+DQo+ID4+PiAyKSBNQUMgc3VzcGVuZCB3aXRoIFdvTCBlbmFibGVkLCBwaHlsaW5r
X21hY19jaGFuZ2UoKSB3aWxsIHB1dCBsaW5rDQo+ID4+PiBkb3duLCBidXQgdGhlcmUgaXMgbm8g
cGh5bGlua19zdG9wKCkgdG8gc3RvcCB0aGUgcGh5bGluayBpbnN0YW5jZSwNCj4gPj4+IHNvIGl0
IHdpbGwgbGluayB1cCBhZ2FpbiwgdGhhdCBtZWFucyAubWFjX2NvbmZpZyBhbmQgLm1hY19saW5r
X3VwDQo+ID4+PiB3b3VsZCBiZSBpbnZva2VkIGJlZm9yZSBzeXN0ZW0gc3VzcGVuZGVkLiBBZnRl
ciBzeXN0ZW0gcmVzdW1lIGJhY2ssDQo+ID4+PiBpdCB3aWxsIGRvIERNQSBpbml0aWFsaXphdGlv
biBhbmQgU1cgcmVzZXQgd2hpY2ggbGV0IE1BQyBsb3N0IHRoZQ0KPiA+Pj4gaGFyZHdhcmUgc2V0
dGluZyAoaS5lIE1BQ19Db25maWd1cmF0aW9uIHJlZ2lzdGVyKG9mZnNldCAweDApIGlzDQo+ID4+
PiByZXNldCkuIFNpbmNlIGxpbmsgaXMgdXAgYmVmb3JlIHN5c3RlbSBzdXNwZW5kZWQsIHNvIC5t
YWNfbGlua191cA0KPiA+Pj4gd291bGQgbm90IGJlIGludm9rZWQgYWZ0ZXIgc3lzdGVtIHJlc3Vt
ZSBiYWNrLCBsZWFkIHRvIHRoZXJlIGlzIG5vDQo+ID4+PiBjaGFuY2UgdG8gaW5pdGlhbGl6ZSB0
aGUgY29uZmlndXJhdGlvbiBpbiAubWFjX2xpbmtfdXAgY2FsbGJhY2ssIGFzDQo+ID4+PiBhIHJl
c3VsdCwgTUFDIGNhbid0IHdvcmsgYW55IGxvbmdlci4NCj4gPj4+DQo+ID4+PiBBYm92ZSBkZXNj
cmlwdGlvbiBpcyB3aGF0IEkgZm91bmQgd2hlbiBkZWJ1ZyB0aGlzIGlzc3VlLCB0aGlzIHBhdGNo
DQo+ID4+PiBpcyBqdXN0IHJldmVydCBicm9rZW4gcGF0Y2ggdG8gd29ya2Fyb3VuZCBpdCwgYXQg
bGVhc3QgbWFrZSBNQUMgd29yaw0KPiA+Pj4gd2hlbiBzeXN0ZW0gcmVzdW1lIGJhY2sgd2l0aCBX
b0wgZW5hYmxlZC4NCj4gPj4+DQo+ID4+PiBTYWlkIHRoaXMgaXMgYSB3b3JrYXJvdW5kLCBzaW5j
ZSBpdCBoYXMgbm90IHJlc29sdmUgdGhlIGlzc3VlIGNvbXBsZXRlbHkuDQo+ID4+PiBJIGp1c3Qg
bW92ZSB0aGUgc3BlZWQvZHVwbGV4L3BhdXNlIGV0YyBpbnRvIC5tYWNfY29uZmlnIGNhbGxiYWNr
LA0KPiA+Pj4gdGhlcmUgYXJlIG90aGVyIGNvbmZpZ3VyYXRpb25zIGluIC5tYWNfbGlua191cCBj
YWxsYmFjayB3aGljaCBhbHNvDQo+ID4+PiBuZWVkIHRvIGJlIGluaXRpYWxpemVkIHRvIHdvcmsg
Zm9yIHNwZWNpZmljIGZ1bmN0aW9ucy4NCj4gPj4NCj4gPj4gTkFLLiBQbGVhc2UgcmVhZCB0aGUg
cGh5bGluayBkb2N1bWVudGF0aW9uLiBzcGVlZC9kdXBsZXgvcGF1c2UgaXMNCj4gPj4gdW5kZWZp
bmVkIGluIC5tYWNfY29uZmlnLg0KPiA+DQo+ID4gU3BlZWQvZHVwbGV4L3BhdXNlIGFsc28gdGhl
IGZpZWxkIG9mICIgc3RydWN0IHBoeWxpbmtfbGlua19zdGF0ZSIsIHNvDQo+ID4gdGhlc2UgY2Fu
IGJlIHJlZmVyZWQgaW4gLm1hY19jb25maWcsIHBsZWFzZSBzZWUgdGhlIGxpbmsgd2hpY2ggc3Rt
bWFjIGRpZA0KPiBiZWZvcmU6DQo+ID4gaHR0cHM6Ly9ldXIwMS5zYWZlbGlua3MucHJvdGVjdGlv
bi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJGZWxpeA0KPiA+DQo+IGlyLmJvb3RsaW4u
Y29tJTJGbGludXglMkZ2NS40LjE0MyUyRnNvdXJjZSUyRmRyaXZlcnMlMkZuZXQlMkZldGhlcm5l
dCUNCj4gPg0KPiAyRnN0bWljcm8lMkZzdG1tYWMlMkZzdG1tYWNfbWFpbi5jJTIzTDg1MiZhbXA7
ZGF0YT0wNCU3QzAxJTdDcQ0KPiBpYW5ncWluZw0KPiA+IC56aGFuZyU0MG54cC5jb20lN0M4M2Zk
YTE3OWJmMWQ0MWZjYTQyMDA4ZDk2ZDVlZDNjMyU3QzY4NmVhMWQzYg0KPiBjMmI0YzZmDQo+ID4N
Cj4gYTkyY2Q5OWM1YzMwMTYzNSU3QzAlN0MwJTdDNjM3NjYxMDc2MzE2MTkyOTA2JTdDVW5rbm93
biU3Q1RXDQo+IEZwYkdac2IzZDgNCj4gPg0KPiBleUpXSWpvaU1DNHdMakF3TURBaUxDSlFJam9p
VjJsdU16SWlMQ0pCVGlJNklrMWhhV3dpTENKWFZDSTZNbjAlM0QNCj4gJTdDMQ0KPiA+DQo+IDAw
MCZhbXA7c2RhdGE9ek0lMkZ3MVIlMkJIa1kwNjdwZzh3bTIlMkZTMHpzTG9CTlFRMlRtZFhXSmF0
DQo+IFB0ZXMlM0QmYW1wDQo+ID4gO3Jlc2VydmVkPTANCj4gPg0KPiA+DQo+ID4+IEkgdGhpbmsg
dGhlIHByb2JsZW0gaGVyZSBpcyB0aGF0IHlvdSdyZSBub3QgY2FsbGluZyBwaHlsaW5rX3N0b3Ao
KQ0KPiA+PiB3aGVuIFdvTCBpcyBlbmFibGVkLCB3aGljaCBtZWFucyBwaHlsaW5rIHdpbGwgY29u
dGludWUgdG8gbWFpbnRhaW4NCj4gPj4gdGhlIHN0YXRlIGFzIHBlciB0aGUgaGFyZHdhcmUgc3Rh
dGUsIGFuZCBwaHlsaWIgd2lsbCBjb250aW51ZSB0byBydW4NCj4gPj4gaXRzIHN0YXRlIG1hY2hp
bmUgcmVwb3J0aW5nIHRoZSBsaW5rIHN0YXRlIHRvIHBoeWxpbmsuDQo+ID4NCj4gPiBZZXMsIEkg
YWxzbyB0cmllZCBkbyBiZWxvdyBjb2RlIGNoYW5nZSwgYnV0IHRoZSBob3N0IHdvdWxkIG5vdCBi
ZQ0KPiA+IHdha2V1cCwgcGh5bGlua19zdG9wKCkgd291bGQgY2FsbCBwaHlfc3RvcCgpLCBwaHls
aWIgd291bGQgY2FsbA0KPiA+IHBoeV9zdXNwZW5kKCkgZmluYWxseSwgaXQgd2lsbCBub3Qgc3Vz
cGVuZCBwaHkgaWYgaXQgZGV0ZWN0IFdvTCBlbmFibGVkLCBzbyBub3cNCj4gSSBkb24ndCBrbm93
IHdoeSBzeXN0ZW0gY2FuJ3QgYmUgd2FrZXVwIHdpdGggdGhpcyBjb2RlIGNoYW5nZS4NCj4gPg0K
PiBGb2xsb3ctdXAgcXVlc3Rpb24gd291bGQgYmUgd2hldGhlciBsaW5rIGJyZWFrcyBhY2NpZGVu
dGFsbHkgb24gc3VzcGVuZCwgb3INCj4gd2hldGhlciBzb21ldGhpbmcgZmFpbHMgb24gcmVzdW1l
LldoZW4gc3VzcGVuZGluZywgZG9lcyB0aGUgbGluayBicmVhayBhbmQNCj4gbGluayBMRURzIGdv
IG9mZj8NCg0KTm8sIHRoZSBMRURzIGlzIG5vcm1hbC4NCg0KPiBEZXBlbmRpbmcgb24gTEVEIGNv
bmZpZ3VyYXRpb24geW91IG1heSBhbHNvIHNlZSB3aGV0aGVyIGxpbmsgc3BlZWQgaXMNCj4gcmVk
dWNlZCBvbiBzdXNwZW5kLg0KPiBzdHJ1Y3QgbmV0X2RldmljZSBoYXMgYSBtZW1iZXIgd29sX2Vu
YWJsZWQsIGRvZXMgaXQgbWFrZSBhIGRpZmZlcmVuY2UgaWYgc2V0DQo+IGl0Pw0KDQpJIGhhdmUg
YSB0cnksIHRoZXJlIGlzIG5vIGhlbHAuIEhhdmUgbm90IGNsZWFyIHdoeSBwaHlsaW5rX3N0b3Ao
KSB3aWxsIGJyZWFrIFdvTCBmdW5jdGlvbiwNCmxlYWQgaXQgY2FuJ3QgYmUgd2FrZWQgdXAgdmlh
IG1hZ2ljIHBhY2tldHMuDQoNClRoYW5rcy4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5n
DQo=
