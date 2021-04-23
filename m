Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DF2368AF9
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236141AbhDWCSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 22:18:14 -0400
Received: from mail-eopbgr10081.outbound.protection.outlook.com ([40.107.1.81]:65024
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230367AbhDWCSN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 22:18:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MU6y3Nqfe1iaSH8nv0kJXkGP/fEn8pDqQaujrFodMszPw0eibFaELO7uG3kNo9Qz2SasRb1+7H5rSdedBJeItaBQAX0kruGK4RbmMVGntUClzSWZzQRDrnyKRbxdAzOoya+gHd+QJeaVsEHjPw/Jwi93L/hJOPYalrxGyJQ4vnWAhJcdjhcWB+koj8AhJgeYoAQZwjckHm+hEoqz6Tmoh9AQSKpqCOg386Wdkvyz+r6/IduyHRDk3yDsEdvtAwGxxk50XlxzGT7xC7gFbydjWf+Y77mbM6OUiGY4MDwD00wtbXphOlrc4qWpHB1Kh53nwhR2sMPEp5ajxzpSvC59xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A3VXkzsFPpYEWaESyTKc0rGa/a9gTHouAiLZ8WHKgVA=;
 b=FpARrLeay9nUjRtyShYtKzH5JN+DoF3D6d1cjQl6A3JS5zeVIrMG5teAR8t3NthtyTMUpy+jaeo6AlAZ0qFoi3JHBbSbz+IAEqx/c87rEhDychSNG+WooQwyqlM08wC9cr0un2Wkyw/Q/vgYsFH3AVNViDCaMevhnDcf1j5DiVwN0s5WrizM2XNuek3uxjnDch1xQ0FDdaCP8GIXpqnRNOuAh6C00VTInZ1lbK0UNm1soZlPAo86SZx8i/Y1TlaJ6YzsuTS6mTKqTDGZSV2NkEE8bWnEtOdH9feTDL1ZCOvZpvyJwA58jFAu7XJbcPe9XnrOcJT9ETDUijJn59bBGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A3VXkzsFPpYEWaESyTKc0rGa/a9gTHouAiLZ8WHKgVA=;
 b=ou3kqMwOkr3jE8uW7C8VJiqAZrrzd59DUBVjnGnEThmuxNPwh4A3p8tldU+WhY/73AQQA4lBg1TYoYTmqlFiMTEfEiAkSkPtJ2gYHmKu3Uwsf0fDorz6PYzHYLQnN44R74Fwd/bU2GIeZcimdfkhaT3w8jt61MS1x37nXrSAY8Q=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4522.eurprd04.prod.outlook.com (2603:10a6:5:35::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 02:17:35 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%7]) with mapi id 15.20.4065.021; Fri, 23 Apr 2021
 02:17:35 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
Thread-Topic: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
Thread-Index: AQHXNRN2zsKOwhYLU0OtzigMEkddiqrAv9eAgACbzwA=
Date:   Fri, 23 Apr 2021 02:17:35 +0000
Message-ID: <DB8PR04MB67954FB9F464CBC2563195E0E6459@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
 <1b2dd47e-184a-2dea-f62d-5417192f2710@gmail.com>
In-Reply-To: <1b2dd47e-184a-2dea-f62d-5417192f2710@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f19ac48e-1510-4c65-b55e-08d905fdf56d
x-ms-traffictypediagnostic: DB7PR04MB4522:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4522A9D8E9266C3A5C801712E6459@DB7PR04MB4522.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5HXVCalW75NeY5AEkRnhb4DeKyCQ0oQ5gBz10yOHNeesKDxKM3mRCSyh6kx0wvIOYg53Nqfe7/uGHChqKEx9mpaQH1Y6NF9Sw+CetTLVdwwWt+4HCJQdNM9GuVrLg7yAuqB2Ya0FF6CQze0gXa9YvINZwp2hN8mUn/lVkbYgKxVpu311tlcHITWk2n2F1lJ5RlcKalyHp4K1EGhWYDWeFA4bqmeqket0jwUTzr96v9Mm60PIwF5n7xAsVIar9hbGWjk6maWpUx+sftsToXyGrafxIMGwq0D5676r+1M1DsIywqdUSOt1JoTumGRUwMVCHq7AHzce8TdGGrZ0G7TdR2TD14WCmeSSt1YYYHLm2D4WcNwCDTlG47yyKyuUFa8gV9Z7pZ4XIRTCXuJC+9i/ZtOmcL8JqLp32gxYyA6kFiU6wPsqbMdDUJCyvwS1JPiSWXqbjiWOp2uW9wKam3MbfFkzxuc1uqfjcTXmESH6vfoIYFMeppr7h+ofSTOemtajh8Q9xv19OBbz7fz4u0HWjsih/0edsJXrIbOwFLzbdauyZ9avgXXn2IrLEhBKv+BG2/GHtMQUxIYVYps6IVR3A8mIh1ZPY6Si95HRCoq04f0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(52536014)(478600001)(5660300002)(83380400001)(7696005)(7416002)(2906002)(6506007)(38100700002)(53546011)(4326008)(122000001)(8676002)(186003)(66946007)(64756008)(66476007)(76116006)(26005)(66556008)(66446008)(8936002)(71200400001)(110136005)(86362001)(54906003)(9686003)(55016002)(33656002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?a082c1RSS2xMaXI3M2prTTcxc25NZFFDUlJ3dzBHR21vUVFWYm5aYVJUd0RM?=
 =?utf-8?B?UTkveXErZ0hCOTdkRG1sb3Ftc3FpOTJPQ0RmNXdHK241ZldVQ1Vwc0JkRnk1?=
 =?utf-8?B?b0I0dnBBZEJySngvc0VrbUo1dnZlZ1dTSWdhamVtSFRYRXUydnhCMVpYNHha?=
 =?utf-8?B?Wm5EckFMdmlnMHY4eXlQcDdtbm9iWnJmbGJSVldUZlZKWXEzME5SWG03TUkr?=
 =?utf-8?B?WmdZZ2h0ZzZNeWZyUFMrZ2tjcUtCa25KSUVQZU1vZDUrWVpiNDVlb25hMUVT?=
 =?utf-8?B?NW5zRy92QzRSSU1kdHViMjIxVm5Tbi9oVFJoclJwNzZieG9ZSGJmUm1mWmtw?=
 =?utf-8?B?dFM1SlQxTjJCWGZ5SFpJNGZlVjlYNHBhbGt0T0dxMzE3WWxaWkdaWVNrY0VN?=
 =?utf-8?B?MWhDeVZmaXNxU1BMa3NEZDBpMUI4RnMxVDZwNGdzS3JDYkZISEY0Z2dyMlho?=
 =?utf-8?B?cXo1bGpuNXJqVjFydWIwRGFLUVlYazBsZlNVejZVcUcwMFFaWEZSSDFsTEZX?=
 =?utf-8?B?enJmMWVJekplMU5JYllISGtPOStPR3FTZWRESUlEWkg3Ynd4Wmg4S0NBbEcy?=
 =?utf-8?B?TTAzckdtRTk4OHpZRG9id2xFUGpyaXhTQ0ZBSGlwU0NtQnkxb0FpU3p0NG4v?=
 =?utf-8?B?UTRtczhrYTNHbm5BNXRJQW5mdmFEbzBIVVJRZng2K3RhMFFidFg2ZXovbktU?=
 =?utf-8?B?eG9Ea0crYWhZRzRDaWJlbFIzVDZvMnRQdDVXRWx1VW9kNkVxSm5iUW9sSEVa?=
 =?utf-8?B?ajg5RDhSR3ZLOG5IY0xzM2JZdXpkMEVodHd3NXBGcEtiN1YzZGh3eG1JZzI5?=
 =?utf-8?B?RjkzVUZWd1UvV1grcXk5ZW1DTWpKYnZFSXZEa2dQZ3dPUUI0VVlRZlY3ZmUx?=
 =?utf-8?B?NkYxS1pVd1lERVpvWVRIa1dPOTZjVFdXcnFCRzlvbW94VTVpcm9sOHVYRWds?=
 =?utf-8?B?TU11Qm9qZEFEWGZmYVB1Q1BBLzJDWDRxeVVHWlFhc056L2ZXdmdweE51dWdn?=
 =?utf-8?B?R1BOMVNXdUN1WElPK055TWlYaGxhcHNsMnNzZW1Ddk40c0hsNkFIeXF5TWJJ?=
 =?utf-8?B?cGx2NHJDYnFwQ2F4dE9jM3JGSG5FdTZLS3VONmFwNEh2NUtvZGZ0ckVqQjU0?=
 =?utf-8?B?eFE2OEpnaXdYbTNxZjFJV2JhYzc0Wll0N3FTRXJUc1NoSkNHK1N4ZWtWZzNl?=
 =?utf-8?B?elNTVGZYUXN2dkdzZ01yOTNNSlBzS093SDA0UHMvSlJ4cEtVSEVyZndzQTNF?=
 =?utf-8?B?VkZnb3NVc3VzOG9Ed25BT0dIUFJLUVd2bnppNS9lbDRSZ0Z4VWR1dGJuTXZJ?=
 =?utf-8?B?cklkc1NITHdxQlFsenAyZFpOU3p6MUhYL1M0M3ZFdDdQcW9QSHcrMEpKdmQv?=
 =?utf-8?B?SmtVMFFaVWg3L1h4UVNTVTBVMHk0UlpYMDM0ZVRGNnRmOXZlbDFuMHZJY0xM?=
 =?utf-8?B?UzdKOTlZd09KVlE1eXBoUHlUWVlqbjVRTXd4a2VnQnMybWNTZzFiWUJGUmll?=
 =?utf-8?B?R0xKc0xyakFVNVZCSE1kL1BwT21lME1ET1UwTzE1cndrZzlRMU84U0VBelQr?=
 =?utf-8?B?dmtrNTB6ZHNxcjhuS1NPYnFJanNIOXBPVjcyZnV1aG9NYVlBVll4SXZwSnNJ?=
 =?utf-8?B?KzFRQ0lsMUtOVWlpcWk4dk02anRBYUQzWmVZQjZMdm0xSnMzWFRTajFzMGtu?=
 =?utf-8?B?R2p5SU82dUp0N3cxb21wZUdJZzZ0VDI5ZWhzL0JsTWw5R3N5NnpaSERHb2FV?=
 =?utf-8?Q?rmEBXWTaRj73efpECvKMwmJqPdTUnejZ0GdLg4O?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f19ac48e-1510-4c65-b55e-08d905fdf56d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2021 02:17:35.1053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lnmIrthW89rQoDMY/KH9RZUeZCw1ohWDaUPiCBuDRvYDdc8Dv2O9DKsPZr/VJbTEpl+YmyB6i6Jh9g/+NNoyew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4522
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBGbG9yaWFuLA0KDQpUaGFua3MgZm9yIHlvdXIgY29tbWVudHMuDQoNCj4gLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBn
bWFpbC5jb20+DQo+IFNlbnQ6IDIwMjHlubQ05pyIMjPml6UgMDozMg0KPiBUbzogSm9ha2ltIFpo
YW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IHBlcHBlLmNhdmFsbGFyb0BzdC5jb207DQo+
IGFsZXhhbmRyZS50b3JndWVAZm9zcy5zdC5jb207IGpvYWJyZXVAc3lub3BzeXMuY29tOw0KPiBk
YXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IG1jb3F1ZWxpbi5zdG0zMkBnbWFp
bC5jb207DQo+IGFuZHJld0BsdW5uLmNoDQo+IENjOiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBu
eHAuY29tPjsgam9uYXRoYW5oQG52aWRpYS5jb207DQo+IHRyZWRpbmdAbnZpZGlhLmNvbTsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1JGQyBuZXQtbmV4dF0gbmV0OiBz
dG1tYWM6IHNob3VsZCBub3QgbW9kaWZ5IFJYIGRlc2NyaXB0b3Igd2hlbg0KPiBTVE1NQUMgcmVz
dW1lDQo+IA0KPiANCj4gDQo+IE9uIDQvMTkvMjAyMSA0OjU5IEFNLCBKb2FraW0gWmhhbmcgd3Jv
dGU6DQo+ID4gV2hlbiBzeXN0ZW0gcmVzdW1lIGJhY2ssIFNUTU1BQyB3aWxsIGNsZWFyIFJYIGRl
c2NyaXB0b3JzOg0KPiA+IHN0bW1hY19yZXN1bWUoKQ0KPiA+IAktPnN0bW1hY19jbGVhcl9kZXNj
cmlwdG9ycygpDQo+ID4gCQktPnN0bW1hY19jbGVhcl9yeF9kZXNjcmlwdG9ycygpDQo+ID4gCQkJ
LT5zdG1tYWNfaW5pdF9yeF9kZXNjKCkNCj4gPiAJCQkJLT5kd21hYzRfc2V0X3J4X293bmVyKCkN
Cj4gPiAJCQkJLy9wLT5kZXMzIHw9IGNwdV90b19sZTMyKFJERVMzX09XTiB8DQo+IFJERVMzX0JV
RkZFUjFfVkFMSURfQUREUik7IEl0DQo+ID4gb25seSBhc3NldHMgT1dOIGFuZCBCVUYxViBiaXRz
IGluIGRlc2MzIGZpZWxkLCBkb2Vzbid0IGNsZWFyIGRlc2MwLzEvMiBmaWVsZHMuDQo+ID4NCj4g
PiBMZXQncyB0YWtlIGEgY2FzZSBpbnRvIGFjY291bnQsIHdoZW4gc3lzdGVtIHN1c3BlbmQsIGl0
IGlzIHBvc3NpYmxlDQo+ID4gdGhhdCB0aGVyZSBhcmUgcGFja2V0cyBoYXZlIG5vdCByZWNlaXZl
ZCB5ZXQsIHNvIHRoZSBSWCBkZXNjcmlwdG9ycw0KPiA+IGFyZSB3cm90ZSBiYWNrIGJ5IERNQSwg
ZS5nLg0KPiA+IDAwOCBbMHgwMDAwMDAwMGM0MzEwMDgwXTogMHgwIDB4NDAgMHgwIDB4MzQwMTAw
NDANCj4gPg0KPiA+IFdoZW4gc3lzdGVtIHJlc3VtZSBiYWNrLCBhZnRlciBhYm92ZSBwcm9jZXNz
LCBpdCBiZWNhbWUgYSBicm9rZW4NCj4gPiBkZXNjcmlwdG9yOg0KPiA+IDAwOCBbMHgwMDAwMDAw
MGM0MzEwMDgwXTogMHgwIDB4NDAgMHgwIDB4YjUwMTAwNDANCj4gPg0KPiA+IFRoZSBpc3N1ZSBp
cyB0aGF0IGl0IG9ubHkgY2hhbmdlcyB0aGUgb3duZXIgb2YgdGhpcyBkZXNjcmlwdG9yLCBidXQg
ZG8NCj4gPiBub3RoaW5nIGFib3V0IGRlc2MwLzEvMiBmaWVsZHMuIFRoZSBkZXNjcmlwdG9yIG9m
IFNUTU1BQyBhIGJpdA0KPiA+IHNwZWNpYWwsIGFwcGxpY2F0b24gcHJlcGFyZXMgUlggZGVzY3Jp
cHRvcnMgZm9yIERNQSwgYWZ0ZXIgRE1BIHJlY2V2aWUNCj4gPiB0aGUgcGFja2V0cywgaXQgd2ls
bCB3cml0ZSBiYWNrIHRoZSBkZXNjcmlwdG9ycywgc28gdGhlIHNhbWUgZmllbGQgb2YNCj4gPiBh
IGRlc2NyaXB0b3IgaGF2ZSBkaWZmZXJlbnQgbWVhbmluZ3MgdG8gYXBwbGljYXRpb24gYW5kIERN
QS4gSXQgc2hvdWxkDQo+ID4gYmUgYSBzb2Z0d2FyZSBidWcgdGhlcmUsIGFuZCBtYXkgbm90IGVh
c3kgdG8gcmVwcm9kdWNlLCBidXQgdGhlcmUgaXMgYQ0KPiA+IGNlcnRhaW4gcHJvYmFiaWxpdHkg
dGhhdCBpdCB3aWxsIG9jY3VyLg0KPiA+DQo+ID4gQ29tbWl0IDljNjNmYWFhOTMxZSAoIm5ldDog
c3RtbWFjOiByZS1pbml0IHJ4IGJ1ZmZlcnMgd2hlbiBtYWMgcmVzdW1lDQo+ID4gYmFjayIpIHRy
aWVkIHRvIHJlLWluaXQgZGVzYzAvZGVzYzEgKGJ1ZmZlciBhZGRyZXNzIGZpZWxkcykgdG8gZml4
DQo+ID4gdGhpcyBpc3N1ZSwgYnV0IGl0IGlzIG5vdCBhIHByb3BlciBzb2x1dGlvbiwgYW5kIG1h
ZGUgcmVncmVzc2lvbiBvbiBKZXRzb24gVFgyDQo+IGJvYXJkcy4NCj4gPg0KPiA+IEl0IGlzIHVu
cmVhc29uYWJsZSB0byBtb2RpZnkgUlggZGVzY3JpcHRvcnMgb3V0c2lkZSBvZg0KPiA+IHN0bW1h
Y19yeF9yZWZpbGwoKSBmdW5jdGlvbiwgd2hlcmUgaXQgd2lsbCBjbGVhciBhbGwgZGVzYzAvZGVz
YzEvZGVzYzIvZGVzYzMNCj4gZmllbGRzIHRvZ2V0aGVyLg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBy
ZW1vdmVzIFJYIGRlc2NyaXB0b3JzIG1vZGlmaWNhdGlvbiB3aGVuIFNUTU1BQyByZXN1bWUuDQo+
IA0KPiBZb3VyIHBhdGNoIG1ha2VzIHNlbnNlIHRvIG1lLCBob3dldmVyIHRoZSBleHBsYW5hdGlv
biBzZWVtcyB0byBoaWdobGlnaHQNCj4gdGhhdCB5b3UgbWF5IGhhdmUgYSBmZXcgY2FzZXMgdG8g
Y29uc2lkZXIgd2hpbGUgeW91IHN1c3BlbmQuDQo+IA0KPiBVc3VhbGx5IHlvdSB3aWxsIHR1cm4g
b2ZmIHRoZSBSWCBETUEgc3VjaCB0aGF0IERNQSBpbnRvIERSQU0gc3RvcHMgdGhlcmUsDQo+IHRo
aXMgbWF5IG5vdCBhbiBlbnRpcmVseSBhdG9taWMgb3BlcmF0aW9uIGFzIHRoZSBNQUMgbWF5IGhh
dmUgdG8gd2FpdCBmb3IgYQ0KPiBjZXJ0YWluIHBhY2tldCBib3VuZGFyeSB0byBiZSBjcm9zc2Vk
LCB0aGF0IGNvdWxkIGxlYXZlIHlvdSB3aXRoIGRlc2NyaXB0b3JzIGluDQo+IDMgc3RhdGVzIEkg
YmVsaWV2ZToNCj4gDQo+IC0gZGVzY3JpcHRvciBpcyByZWFkeSBmb3IgUlggRE1BIHRvIHByb2Nl
c3MgYW5kIGlzIG93bmVkIGJ5IFJYIERNQSwgbm8gbmVlZA0KPiB0byBkbyBhbnl0aGluZw0KQWdy
ZWUuDQoNCj4gLSBkZXNjcmlwdG9yIGhhcyBiZWVuIGZ1bGx5IGNvbnN1bWVkIGJ5IHRoZSBDUFUg
YW5kIGlzIG93bmVkIGJ5IHRoZSBDUFUsIENQVQ0KPiBzaG91bGQgYmUgcHV0dGluZyB0aGUgZGVz
Y3JpcHRvciBiYWNrIG9uIHRoZSByaW5nIGFuZCByZWxpbnF1aXNoIG93bmVyc2hpcA0KWWVzLCBh
dCB0aGlzIGNhc2UsIGFmdGVyIHN0bW1hYyByZXN1bWUsIHRoaXMgZGVzY3JpcHRvciB3b3VsZCBo
YXZlIGNoYW5jZSB0byBiZSByZWZpbGxlZCBpbiBzdG1tYWNfcnhfcmVmaWxsKCkgZnVuY3Rpb24u
DQoNCj4gLSBkZXNjcmlwdG9yIGhhcyBiZWVuIHdyaXR0ZW4gdG8gRFJBTSBidXQgbm90IHByb2Nl
c3NlZCBieSBDUFUsIGFuZCBpdCBzaG91bGQNCj4gYmUgcHV0IGJhY2sgb24gdGhlIHJpbmcgZm9y
IFJYIERNQSB0byB1c2UgaXQNClRoaXMgY2FzZSBpcyBkZXNjcmlwdG9yIGlzIG93bmVkIGJ5IENQ
VSBhbmQgcnggYnVmZmVyIGhhdmUgbm90IGJlZW4gY29uc3VtZWQgeWV0LCBJIHRoaW5rIGl0IHN0
aWxsIGhhcyBjaGFuY2UgdG8gYmUgcmVjZWl2ZWQgZnJvbSBzdG1tYWNfcngoKSBhZnRlciBzdG1t
YWMgcmVzdW1lLg0KDQo+IA0KPiBPdXQgb2Ygc3VzcGVuZCwgZG9uJ3QgeW91IG5lZWQgdG8gZGVh
bCB3aXRoIGRlc2NyaXB0b3JzIGluIGNhc2VzIDIgYW5kIDMNCj4gc29tZWhvdz8gRG9lcyB0aGUg
RE1BIHNraXAgb3ZlciBkZXNjcmlwdG9ycyB0aGF0IGFyZSBzdGlsbCBtYXJrZWQgYXMgb3duZWQN
Cj4gYnkgdGhlIENQVSBvciBkb2VzIGl0IHN0b3Avc3RhbGw/DQpZZXMsIEFGQUlLLCBETUEgd291
bGQgc2tpcCBvdmVyIGRlc2NyaXB0b3JzIHRoYXQgYXJlIG93bmVkIGJ5IENQVSwgb25seSB1c2Ug
dGhlIGRlc2NyaXB0b3JzIHRoYXQgb3duZWQgYnkgRE1BLiBUaGlzIGlzIG15IHVuZGVyc3RhbmRp
bmcuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiAtLQ0KPiBGbG9yaWFuDQo=
