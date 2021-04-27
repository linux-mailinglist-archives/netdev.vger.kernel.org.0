Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBD136BE7C
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 06:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234598AbhD0E1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 00:27:00 -0400
Received: from mail-eopbgr60063.outbound.protection.outlook.com ([40.107.6.63]:13382
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229490AbhD0E06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 00:26:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nhxgsli9XPD8iXximDjYpBhivoljojV9x7mF+OazaeEZkuU1lXFoLOQfPhmowu8Yz2Es5eTGARE9sr6UQLK5lii7AlD3RfrH5Ylhoa++TamU14hcCFj4iPNkQ8D4Bl58HN6wVrHE/3FEJ+uKKXpminjRsKMlK2SnJQnDZssg2Jw7Nug69FNfy1sHuZAJtrLCZDlKfW4X55veKR/Z+AzI6TM0g983I8rUhdNFNK0vVzagHipR2no/kNU9sUKlhw5BJJMgDbK3Zu2kq4JU+uBlvb+UerREukOMDOai9DZfsMp0fX8DoDEMFs05iJOtgXVSvaQ/8Sb8JOrek8qcQ/r/QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovT400nv41ogr3fIKMtRAnYRg1OuGroPXVQSbhq45HE=;
 b=mLnf6DXe1mSezvEcpWmMDF7dNHlElmaDFW3u/6Ohk8jgzchUQlmVQT3j9D8RIxseyYEiQTcBaRuER2DAODgkMTJ4DKX+ja16Z/BwcU2CBUTUx2LN/lGHXGtrMXxTMq71fM05xjvLvDCnc+3B8ZsfrJRmOxOI/dkTfcf8cB19VRnZLDhVOr9WN6O0v78GiqqJwlxC5sbv/sCk/J+3ycP50r+ubNfDzb83TU/P97Q5gDWYERcu74bRQAXerf8su4L+LAxRrHM9y2KxYUdLBI6cGl+BLROlL94Y51KTyH5L+4cvcZZyBDmhFIJsGkEcwdtldNDQARreTup7+DlE5jGkwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovT400nv41ogr3fIKMtRAnYRg1OuGroPXVQSbhq45HE=;
 b=GK64Wq5fasYIbYagPwFUcMzjocuC5jHZNUffHU1blolpVy1YDQ81qRmd0yzrga1uviz4ntaNwb+q24HSiqRlRRlw62S6sV0al8kQW9zHvvz3NKwGndlqDsW3OCFiF23U497ZsNVIUOWzDC5BRicUh3GRZd4mHyIsnnl4IJE6p+8=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM6PR0402MB3384.eurprd04.prod.outlook.com (2603:10a6:209:6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Tue, 27 Apr
 2021 04:26:14 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777%3]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 04:26:13 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
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
Subject: RE: [net-next, v2, 3/7] net: dsa: free skb->cb usage in core driver
Thread-Topic: [net-next, v2, 3/7] net: dsa: free skb->cb usage in core driver
Thread-Index: AQHXOn8Jr4d6SG7MRkyMg7TxAYZcc6rGzfgAgAD346A=
Date:   Tue, 27 Apr 2021 04:26:13 +0000
Message-ID: <AM7PR04MB688558223DE6163913985B3DF8419@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20210426093802.38652-1-yangbo.lu@nxp.com>
 <20210426093802.38652-4-yangbo.lu@nxp.com>
 <20210426133846.GA22518@hoboy.vegasvil.org>
In-Reply-To: <20210426133846.GA22518@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d2a1a9e-38c3-4d7e-fdda-08d9093497d3
x-ms-traffictypediagnostic: AM6PR0402MB3384:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0402MB33846D0E9526ED033EDF2BC5F8419@AM6PR0402MB3384.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6WozTNFzM4Ad1LUHx2uJoRoNr+EIJpIwxS4wkwTtNAeXehnMbUvwnzu6qIGnvyj1w6Hwz2uNCKP3oHUUj7KRUDELpyL5SChS0Lxp0PySZ68fMouhFgo56etIdqszsSy1W3qeGjb1NU6PQMKi7HyXuWJuAG+lXKrY3y5dI1Sy1MGR3YO/qjwQnqp3z/sFxU2wVT97nMM5Czt92AKOk666s9kOBPtZPje6oENy/yrcLkkvOGK9iHtSasMzLPoWp6ok5ycxAwovvNInPdfUGnKTY1aOXlmE6Brv1S2hRC+ELtiSCfenAA731U3wxiOwCGEARGT30IVaGjrKegUdnVSN2JXwo5Dzc/LcQMrCps1Mh3t73VRnBTk5b5l1LwZFMrFOiiZUP0jGNA9chb/M3kFAmrlEAY5vCOZWQBbrK4LjauunKtG5NykEPoqs1tQDOmZL4n614ozq+LI77I0dBlWXY0gdivTXAd57GS+2zPsGKmC1fckZQKQLzPVKH1mFmRAZvetHQGMI1+xW9G/GH71DxDExrfqWVwbEIYIcOf4ckFHU90Ge9Kk8RzQVRAtfENR7HicuZHG2bqtY1V4Slipur3K+5o91/USEOnRhUUYSBR4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(4744005)(83380400001)(6916009)(2906002)(498600001)(55016002)(53546011)(54906003)(7416002)(7696005)(86362001)(5660300002)(66446008)(9686003)(66476007)(76116006)(64756008)(33656002)(6506007)(8676002)(122000001)(8936002)(38100700002)(186003)(71200400001)(52536014)(66556008)(66946007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?TDFDSFI4MkJoV1R6L0VKTnc3R2pKaHltbGVYeTltZ25ncUpuQzRlVlhWRGtY?=
 =?gb2312?B?YzU4TjVkRGxxM05XZENvWVRtMGJsNFN2VFlHTzFBeldmNjloZ0hiL3IyV2Q4?=
 =?gb2312?B?ZU1JU3hOeldJRmJuRkhRYTZIcUVGR1JrM2kwMk1nOWNZZFlYR0NmTUphZWNr?=
 =?gb2312?B?Z3d4L2hITFlYbDZkWU9lK2lOTEJndkR3MW80UEwyMjhHaFZscHV5UWxMRDJK?=
 =?gb2312?B?NTJnUVlLQW9UekRDYWs2NENQYTlHcnQzRGZjeEs0ME5zTkJuNFpndU9HbGlS?=
 =?gb2312?B?VEZUdjZsZURQeDlkbTRSUFFKMkVMaVFsR3VvUGVEMmsxelIvNXVNVlFMTWpX?=
 =?gb2312?B?K05JVUxFby9tRUZ6TnRsQVBNa2lvZllZL1QyOVZmUHYrSjVTR2JKU21TWHJV?=
 =?gb2312?B?ZktrbGUwNTA1cDB3Y2kvQkRNSU1QSGdHdGhXT3ZQTUdnTDB1eUY1bUdXdldP?=
 =?gb2312?B?NUVVc2lWMkZSQWYvK3R3dlF5TWs3cm15MUdCSEpPVmhtSjBSYWFjSExPT2h3?=
 =?gb2312?B?NWZJb3c3QUJNMndmWDZXN0RNRzZUYTMzaWZBeUZvZ0ZQdXBnM25KSUJIQW5G?=
 =?gb2312?B?aS9YanU5QnVWSVNvakhySmszcXpzd2o3Q0lSUHBTZXJ3ZEdzTlRRTmhyTGVE?=
 =?gb2312?B?VDk0bHJvNVlMbFN1NDExQlZxOGcrTWdQNnQ3WlZ4VlBuTkwyZkUwRXR1NXY2?=
 =?gb2312?B?Sm9OclVWUm1SWElmbUVYeXFHY2tvenRVREU0Wmd0Y0ZBS0VsQTVKR2YyaFNI?=
 =?gb2312?B?dGFGTHdpb1dJTjdyUXRqK3dvL05ueUEva1M2SyswQzU5K0ZlNWRqS1ZjTTB6?=
 =?gb2312?B?VHdpQXhMK3dCMDlNZFRZUDlGaGhVR0F5OGF6anpJd2lnbXlVVy9FOXJQb09n?=
 =?gb2312?B?VFhiK29IQVBZMWFaZ2R2NTREUTBGMS9GWUp4Q1dUQzU5QUtvRDlVT3lpZEwv?=
 =?gb2312?B?MHh0dU9hVmNJTWtudWVHVXN0bHZqM1pPSEpjNmdwMGQzNE9CemR6M2pWM3NZ?=
 =?gb2312?B?ODVqbVVzUDVGTUlnOXdPWnBtejBpR0hqRTdkN0V5ZlFFbDFRQ2hQeTg5U2pv?=
 =?gb2312?B?bzM0UjBkSnZ0TDFZcXZsdXExRmJ6cUJvcUFtSFc3QzFXSnBNYjFra1pHcDN0?=
 =?gb2312?B?RzZzRWhYc2J5aVgwcEdHc0FZUDhQc1huVVRmVS9IY0pnSzFVOW94M3B4bHRr?=
 =?gb2312?B?VzdkemhZeERPQlRwaXVBSkRyWkZBbEhITTVRLzN6NW5tYjlaRzRkNkxqem85?=
 =?gb2312?B?TVRtU1lLTFVpVU1sbkt0QWk1REJPZzFTbFRIMHlsb2NHb2daRWFjbFF5YmFj?=
 =?gb2312?B?eXBnS1ZYZy9pTjNOaHlDOGpveklhSHR1UG4yRWVBd2ViZmtxcUtGaCtkTUV6?=
 =?gb2312?B?Z0R6L0lwVmx2czRONXdhd2Jzclkrc2tPdFV3NGgyVitVbWRwYk5aN1h3S1pU?=
 =?gb2312?B?NE4xY0dsMUt3REN2MTE5NzJCOXlGVjB3bjJLb3RuSTFUeGRzOHFhS2pjcWw1?=
 =?gb2312?B?bHB1b2RaYWg0aTdZUHhoTlpwZ3VISkdBRTRsS1I2ZkV2WnBvWkdYRE54Q0Z5?=
 =?gb2312?B?S3IycEZETkdwQm9peFA4VVJ6NTVaT3BsR3JJTDVWUllWbUpocnhvSlRXUVM5?=
 =?gb2312?B?aStRZXdvdDV2TENQdDhPb2VJMVk4VEU3NldJMllRMkhkald4WXc0SzBsdE1V?=
 =?gb2312?B?cUxOdG9wTktsaUtrc0pLSDU5dnFqMzlXZUN2VjhXNkVXTy85OEtOdjdwV09h?=
 =?gb2312?Q?RWY4cT61HBOZHHID2RIX6iOGEfwajbsHsfVPxHR?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6885.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d2a1a9e-38c3-4d7e-fdda-08d9093497d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2021 04:26:13.8653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zRbgnNUSj+1KaBEcVwrC79rLkXdJU0B3B6YEf2K3hwiQc1TsDSzYQsYXK6xa6TVPDg7pVDkNmCew4gtdZuf5pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3384
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUmljaGFyZCBDb2NocmFu
IDxyaWNoYXJkY29jaHJhbkBnbWFpbC5jb20+DQo+IFNlbnQ6IDIwMjHE6jTUwjI2yNUgMjE6MzkN
Cj4gVG86IFkuYi4gTHUgPHlhbmdiby5sdUBueHAuY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsgVmxhZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT47DQo+IERh
dmlkIFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3Vi
YUBrZXJuZWwub3JnPjsNCj4gSm9uYXRoYW4gQ29yYmV0IDxjb3JiZXRAbHduLm5ldD47IEt1cnQg
S2FuemVuYmFjaCA8a3VydEBsaW51dHJvbml4LmRlPjsNCj4gQW5kcmV3IEx1bm4gPGFuZHJld0Bs
dW5uLmNoPjsgVml2aWVuIERpZGVsb3QgPHZpdmllbi5kaWRlbG90QGdtYWlsLmNvbT47DQo+IEZs
b3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPjsgQ2xhdWRpdSBNYW5vaWwNCj4g
PGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBBbGV4YW5kcmUgQmVsbG9uaQ0KPiA8YWxleGFuZHJl
LmJlbGxvbmlAYm9vdGxpbi5jb20+OyBVTkdMaW51eERyaXZlckBtaWNyb2NoaXAuY29tOw0KPiBs
aW51eC1kb2NAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+
IFN1YmplY3Q6IFJlOiBbbmV0LW5leHQsIHYyLCAzLzddIG5ldDogZHNhOiBmcmVlIHNrYi0+Y2Ig
dXNhZ2UgaW4gY29yZSBkcml2ZXINCj4gDQo+IE9uIE1vbiwgQXByIDI2LCAyMDIxIGF0IDA1OjM3
OjU4UE0gKzA4MDAsIFlhbmdibyBMdSB3cm90ZToNCj4gPiBAQCAtNjI0LDcgKzYyMyw3IEBAIHN0
YXRpYyBuZXRkZXZfdHhfdCBkc2Ffc2xhdmVfeG1pdChzdHJ1Y3Qgc2tfYnVmZg0KPiAqc2tiLCBz
dHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KPiA+DQo+ID4gIAlkZXZfc3dfbmV0c3RhdHNfdHhfYWRk
KGRldiwgMSwgc2tiLT5sZW4pOw0KPiA+DQo+ID4gLQlEU0FfU0tCX0NCKHNrYiktPmNsb25lID0g
TlVMTDsNCj4gPiArCW1lbXNldChza2ItPmNiLCAwLCA0OCk7DQo+IA0KPiBSZXBsYWNlIGhhcmQg
Y29kZWQgNDggd2l0aCBzaXplb2YoKSBwbGVhc2UuDQoNCkZpeGVkIGluIHYzLg0KVGhhbmsgeW91
IQ0KDQo+IA0KPiBUaGFua3MsDQo+IFJpY2hhcmQNCg==
