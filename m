Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7225C3CB0AA
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 04:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhGPCHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 22:07:54 -0400
Received: from mail-eopbgr80057.outbound.protection.outlook.com ([40.107.8.57]:41385
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230417AbhGPCHw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 22:07:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKfl0mOHrdOlYnl9dkxOkSPWOgw7UNFkJEmab4yljtNqtegVqHXSTMVEqQ4jMuYkUkyXY6PFKUM+XPtWiyMsUrd4e2f5Z036MHW6AJIKd2Z4VLOGObsrdGHa9wcAekc5biOyujuY9abFb1oGupVG7LhnlHd135IsgvWFVpu+CfZ3Ju9R6zS1SSut6uaQmZOhTevvMAzT8oa6l8JVVp+jxsnfA2Y3oqNjeDUs3dIMO5ZDAbl3X1cZlvV1Ywi4+FW4wZ0//aQDAm9X2IKUOUl87QYFjjb4C/PB6X9wulQn+TNzCrc4kNGtWGuU/yAEE7WSwI2kjpjFMvWcOXyg168/Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v38iohFalf6O7gFh0H1z3SXp/ptOkx9jVLOaFhxNhhM=;
 b=cqqrFsSu1Bqwytz9d/b5mPe4vmsaVLl5HeWkKPLbarsidClIoelN0iohAhgHEATHaverRe/AZKHlNpCK+Drhh3bqoKd/7Znc17H1HG6Nle2hvQwwlZDZ5W6vdZMxytPlky5DlZm8wFDNlkoLMwqTkbZVb716EjfBySAtFLDrSkE24tlK0kSRA3lsi6Sqp1xRggnUF+q2qYRpHLrmAz81O6fGE7FQWQvF39utz0n7DvYVBTLCK7sIoM9Ab86a8dKquWRwe9Y6H8dRLFpa8WTrzbyqj19pYP428ljwn7WaBcZk+p2QQvQFXXhpWEDMUi55KFwBTpTp/06WWQ1n9o4+sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v38iohFalf6O7gFh0H1z3SXp/ptOkx9jVLOaFhxNhhM=;
 b=AI4QMv7/+JCeuFTyzzdjbOL6QLEJlKkdXnSdxycpbXeGzTP9x9cbHxxtFcrxa5v37lG6rAyDsItYp3XXFS6pDemM8E+vNfZXMBGHg7eDzj3zMqF89O5Kb3+qghrVnSOjzf5iShuZpOcNjHMXJq4+H7ObmlzBEE8wTcPHuHeP1c8=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5129.eurprd04.prod.outlook.com (2603:10a6:10:1f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.25; Fri, 16 Jul
 2021 02:04:56 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4331.021; Fri, 16 Jul 2021
 02:04:56 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Dong Aisheng <dongas86@gmail.com>
CC:     Aisheng Dong <aisheng.dong@nxp.com>,
        devicetree <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/7] dt-bindings: can: flexcan: fix imx8mp compatbile
Thread-Topic: [PATCH 1/7] dt-bindings: can: flexcan: fix imx8mp compatbile
Thread-Index: AQHXeVMe6xPSccZQPEq2Cy9PpYaNf6tDwFGAgAAaOQCAAAEH4IAABOAAgAAIGwCAAAjEgIAA5tYQ
Date:   Fri, 16 Jul 2021 02:04:56 +0000
Message-ID: <DB8PR04MB67956BA87EE91F3298329175E6119@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210715082536.1882077-1-aisheng.dong@nxp.com>
 <20210715082536.1882077-2-aisheng.dong@nxp.com>
 <20210715091207.gkd73vh3w67ccm4q@pengutronix.de>
 <CAA+hA=QDJhf_LnBZCiKE-FbUNciX4bmgmrvft8Y-vkB9Lguj=w@mail.gmail.com>
 <DB8PR04MB6795ACFCCB64354C8E810EE8E6129@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210715110706.ysktvpzzaqaiimpl@pengutronix.de>
 <CAA+hA=RBysrM5qXC=gve5n8-Rm7w_Nvsf+qurYJTkWQWPmGobw@mail.gmail.com>
 <20210715120729.6ify4gh7vcenkxxm@pengutronix.de>
In-Reply-To: <20210715120729.6ify4gh7vcenkxxm@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb76271a-f366-4184-0f45-08d947fe1be1
x-ms-traffictypediagnostic: DB7PR04MB5129:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB512969C3434C7180C624AF53E6119@DB7PR04MB5129.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y0NOxwTS8dfz1aSWZctPRB2vBuWs8W0YdzKdgGSJPZvzomGvkfQR7jBfSJLYSCwBozaafJFYaErN7X7benvNCk9pOFMviCezHQ2JusS6nLT/Cj3AekFUVBb7BURI0c+NqkHwqXudJtA5Wv269zJve9wqyuM0oMPGz/SoavU9BfWhF6UtcVpxm7V9YqF9e9fC7ehlk55v5q1o4en/6+Qc2ce5QkyLD8A6PGUA7jF8Xs8a1kmXap3D4RPFcB54nTMI+q1ztmhNOrjmtMQh61yMg4xP2ymRqtaQup4InNv+LdktjaK6X9E8LT5XJq0VsXAGXms9oAdAY8Sf4Ck10/MsuYL4gPmzBxGbXa1gwQrqr3/EmIIZhXD5Zjz6EDnBqUEEWE7gM7Tt64uFtXpq3xAOcBcIUjji4dGDhoTo5nMyLAWImSJXICPlc3H4Dczto1+KHi0jiXqwOhohDYlb1KkyJu1l3GycEKOFflJfX05Zoy2TWsWpclAOCt4kABOKRHIYWexWgidK93JYHbqOvhoAV1Spm+cCIXAOzXGJrYOU2GSPPX5n6IkB0WVRNnDCLtBRXKkXyr7Tmaz0YiWWNOZnVNZphZfxug23OtUfovUYvozxzKmPJpohkSLuw0FMSiop3B4gq8uMeCAg/CNI4anOK+Dxp+h69xeLTE8UXNvNLmGafVEXZRVNOw9IF886l0R/1F3kNFdXAf1sokvh3ON48zj2mGiaZg3jnr/1Rx+mTtfEliBRSGpLubFbQ4qRDfJSiQOjbe84dmF+uH7a++stEHflTgD2NdiHDQlXTTuFwYlt6f0b+7bPXC+0erobFUVu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(376002)(396003)(366004)(136003)(2906002)(86362001)(54906003)(8936002)(33656002)(110136005)(316002)(71200400001)(478600001)(76116006)(9686003)(966005)(55016002)(8676002)(53546011)(52536014)(6506007)(83380400001)(5660300002)(7696005)(66446008)(66946007)(66476007)(66556008)(64756008)(26005)(186003)(4326008)(38100700002)(122000001)(32563001)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SURiS2N4dmtESW1VTXhqN1Bic3FUcEdEblhESUtsWlZTbU9NOFY1QjFXTTVk?=
 =?utf-8?B?bnQrczdNTHlIVGc1Y2o3bGhYQzhmaXBGb0s4UmUrZ3dhRDZocjhObjlkZzB1?=
 =?utf-8?B?bzJCT3JOV2ZtTEhDeEZpa2NXL3YxaTJWK1o5VjBvZXVNUU9rOEVZdWFUVllr?=
 =?utf-8?B?UDVISk4vUjBzMUVaRlhjUThwcTlmSzVnSnRTYzVJS0xHdVhvcW5mU0s1WWZt?=
 =?utf-8?B?MTBndTcxRWdhbDlZdCt6MkNjWFNhTHlVZVMzMGVFRXNWL3lpUTB3THdUUStr?=
 =?utf-8?B?c2E5bkdNOVgrVWcvRnVaTU5tazVxQXZDZDAza2pjWGVnR3RuVldCOXFlR3Q0?=
 =?utf-8?B?UjFpbDZCcU9ROXNLYzBJRFcxWllCckZNODcwd3BxeThNSURwUlJ1RVNTZUl6?=
 =?utf-8?B?cCs2TVFlTEQxdzl6Wng0bzQvcTU2UVoycEJ0RDY5MUdKaXVQejdLWXZ3eWlS?=
 =?utf-8?B?aFRwT0dxalRsTjVIWHE4NXgwVjFHbWFyeVBnVUJMQ2NzNU1MdU52d1hCemVC?=
 =?utf-8?B?ZTFjWks3endlUTFGMVZoR3JZVDBqV1NjdEgwazJGVU12ak95RGh6ejFlbHZM?=
 =?utf-8?B?cy9WMXNwRXFHTVpkVVFEZFRFM2d3TWdyQ2pVUXhiRUNXbWFmU2UxZk5OdkdR?=
 =?utf-8?B?VlF1eFZycERPZnJETzBHVzFNNEJiUkxka2ZEOGlMSG5xOGVMTVEva0tkdlp4?=
 =?utf-8?B?TzlCUnN2dVhhWEx0ckNIak14U1kvZ1BmLzY0TVhMS3NqWWdCT0M2QXkwc0VW?=
 =?utf-8?B?ejd0SktMZU5mN3c3RmxadFIxQXhFaVJHNnVtWStVSHdwLzljSUNYdUp0SEgw?=
 =?utf-8?B?K1FKSU5CWjlvbjVLSFZsVGFGb2ZCUk9WOUlaWm11aGg4ZnZqYURzSE5QL0xH?=
 =?utf-8?B?dXhkRE9LdE1pK1k4cEw2V2FRRmZwaUQ4ZmxEZGNvWnFSN0oxRWVDWTU2RGpI?=
 =?utf-8?B?TC9HRlJ6cVJBNXM2S2grbngwLzZrZTY3d1RVVXlzWjFRdGpTY0RmbUNSM2NZ?=
 =?utf-8?B?RDZ0am1YVWhodnF2eTJJNUxVSEJibUJyZjNZWXluK283Q2JLZDIxeVcwejVV?=
 =?utf-8?B?d0JibTRSWWUxMDQrUTVFNjdvd0FlVjdyTXFPMFRXZkozWmR3Y3Zub1hLVVdq?=
 =?utf-8?B?WVFXSm40L0ZNREU0M2tvRGpRMHNuTXJMVmNBWi8wdUQ5UzVibzNFdUtHQXhx?=
 =?utf-8?B?eHYyNzEwaURZQ24yb1UwRU56dU11YUZsRU0rYXZBTGNxdjVEc2psYVdmanpD?=
 =?utf-8?B?aHo0U3M3R1BhVzdMaWJaWTNMc0gvYzFyRGIxSk00K2tUQ09XR0w4ZzlXTThY?=
 =?utf-8?B?VGMzMnNqamV4eVpabXU1eFU4TGhhbHJESzY0azZpNlYzMWU5QzQxaW5OdHFT?=
 =?utf-8?B?eFoxQlkxRUM3K0l0L3lhL0xHTlZvMHVVWTdMcS9nVlJLRlFQVWlKSEtGMGZk?=
 =?utf-8?B?eHU2YzgwSFRzTjM3bVd1TldLT3dIbGJ2VTlVUGY1ZnJBQ0w1Yjk0Y2d6SkJT?=
 =?utf-8?B?NHNVWEVzeDlJQlRPYUtkUVlkTVM4STltWkJ6d0hZQ1ArV1cxa1U1M2tDRkZh?=
 =?utf-8?B?NXo3SXpWOVR3RHkzaENQc1dMRjVMeWVlMGswSzVvWCswUWJrUlcydTVJNW5p?=
 =?utf-8?B?a3pmRk1WOU4yOUZOL3gvU0dmS0hWN00rTVhzU3RoMDJBMGJGVmEyS016WkNH?=
 =?utf-8?B?aUZkNXZ4MTBjM2RGbG9lNlF4dW1oVWtWaEF4Skw3MnUwK3F4cnE3LzJwNmQw?=
 =?utf-8?Q?ZXw1MghBCVus8NKCl6t0W4nZEEG5BoP9R48Ixzm?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb76271a-f366-4184-0f45-08d947fe1be1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2021 02:04:56.3271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8NqueKPx04Wch/HmR87UjbBkOVl6WlLr5cMyYtmuxxiPZ+B3F5mhgWsm5klT0rSmBnad0A85d2dw5mYeLTET7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBNYWMsIEFpc2hlbmcsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJv
bTogTWFyYyBLbGVpbmUtQnVkZGUgPG1rbEBwZW5ndXRyb25peC5kZT4NCj4gU2VudDogMjAyMeW5
tDfmnIgxNeaXpSAyMDowNw0KPiBUbzogRG9uZyBBaXNoZW5nIDxkb25nYXM4NkBnbWFpbC5jb20+
DQo+IENjOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgQWlzaGVuZyBE
b25nDQo+IDxhaXNoZW5nLmRvbmdAbnhwLmNvbT47IGRldmljZXRyZWUgPGRldmljZXRyZWVAdmdl
ci5rZXJuZWwub3JnPjsNCj4gbW9kZXJhdGVkIGxpc3Q6QVJNL0ZSRUVTQ0FMRSBJTVggLyBNWEMg
QVJNIEFSQ0hJVEVDVFVSRQ0KPiA8bGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3Jn
PjsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47DQo+IFNhc2NoYSBIYXVlciA8a2Vy
bmVsQHBlbmd1dHJvbml4LmRlPjsgUm9iIEhlcnJpbmcgPHJvYmgrZHRAa2VybmVsLm9yZz47DQo+
IFNoYXduIEd1byA8c2hhd25ndW9Aa2VybmVsLm9yZz47IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5v
cmc7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCAxLzdd
IGR0LWJpbmRpbmdzOiBjYW46IGZsZXhjYW46IGZpeCBpbXg4bXAgY29tcGF0YmlsZQ0KPiANCj4g
T24gMTUuMDcuMjAyMSAxOTozNjowNiwgRG9uZyBBaXNoZW5nIHdyb3RlOg0KPiA+IFRoZW4gc2hv
dWxkIGl0IGJlICJmc2wsaW14OG1wLWZsZXhjYW4iLCAiZnNsLGlteDhxeHAtZmxleGNhbiIgcmF0
aGVyDQo+ID4gdGhhbiBvbmx5IGRyb3AgImZzbCxpbXg2cS1mbGV4Y2FuIj8NCj4gDQo+IFRoZSBk
cml2ZXIgaGFzIGNvbXBhdGlibGVzIGZvciB0aGUgOHFtLCBub3QgZm9yIHRoZSA4cXhwOg0KPiAN
Cj4gfAl7IC5jb21wYXRpYmxlID0gImZzbCxpbXg4cW0tZmxleGNhbiIsIC5kYXRhID0NCj4gJmZz
bF9pbXg4cW1fZGV2dHlwZV9kYXRhLCB9LA0KPiB8CXsgLmNvbXBhdGlibGUgPSAiZnNsLGlteDht
cC1mbGV4Y2FuIiwgLmRhdGEgPQ0KPiB8JmZzbF9pbXg4bXBfZGV2dHlwZV9kYXRhLCB9LA0KDQpB
RkFJSywgd2UgZmlyc3QgZGVzaWduIHRoZSBpLk1YOFFNIEZsZXhDQU4gYW5kIGxhdGVyIGkuTVg4
UVhQIHJldXNlcyBJUCBmcm9tIGkuTVg4UU0sIHNvIHRoZXJlIGlzIG5vIGRpZmZlcmVuY2UgZm9y
IHRoZW0uDQoNCklNSE8sIElQIGRlc2lnbiBpcyBhbHdheXMgYmFja3dhcmRzIGNvbXBhdGlibGUs
IHRoZW4gd2UgbmVlZCBsaXN0IGVhY2ggYXMgZmFsbGJhY2sgY29tcGF0aWJsZSBzdHJpbmc/IEkg
dGhpbmsgaXQncyB1bm5lY2Vzc2FyeS4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+
IE1hcmMNCj4gDQo+IC0tDQo+IFBlbmd1dHJvbml4IGUuSy4gICAgICAgICAgICAgICAgIHwgTWFy
YyBLbGVpbmUtQnVkZGUgICAgICAgICAgIHwNCj4gRW1iZWRkZWQgTGludXggICAgICAgICAgICAg
ICAgICAgfCBodHRwczovL3d3dy5wZW5ndXRyb25peC5kZSAgfA0KPiBWZXJ0cmV0dW5nIFdlc3Qv
RG9ydG11bmQgICAgICAgICB8IFBob25lOiArNDktMjMxLTI4MjYtOTI0ICAgICB8DQo+IEFtdHNn
ZXJpY2h0IEhpbGRlc2hlaW0sIEhSQSAyNjg2IHwgRmF4OiAgICs0OS01MTIxLTIwNjkxNy01NTU1
IHwNCg==
