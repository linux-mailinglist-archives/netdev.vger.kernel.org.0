Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FBD3050E9
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239008AbhA0EaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:30:22 -0500
Received: from mail-db8eur05on2042.outbound.protection.outlook.com ([40.107.20.42]:8672
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405359AbhA0Bpc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 20:45:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTmCuoeZpdYWoj3Th3uYJNXA4KaBV/i6NKabrqrcNyiw+1ev3tECHT9aSjnHHc2RtIhqcQNXSMwFUb7WuGAwPI0+cznnP7IWzREij9IQAVKDcaj6RKy+MzzoiWPhhlJHnJFsB0swYP42a87NdW2Ya1beVS2f+L+jXrnUQymtsAu0Lzxo0mqPFdbPUI8Selnq5eUIyfsX6AXzgBVFocI7gqn+mybS1NkMKyZAlZEv9SevADOybwsHTLDZHAyv9hSKxG2MwxB+yBlZV21XcriMi+TZTqhEoKbY+3zgcHNjVOWS3OJiF37zNLFIHKlMTdseOrB84r1wubHfaIrxch0cLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzPmWimbwZJNswzNAUVmdtzf4z9fuhuMI36LbwTiUFs=;
 b=BLcwux6Ns6yo2QpwfpXqadBPQWQpdAut7zFyTWrUCc9ei7dchKLr0q5+Snhmrk+LBRkkUefCbBWnren5+n9setrOELAiZu8ywyR44ESJ+K3be6k10TOawK4m3YrD9Z5S409THMQJ+zcQpsyqGw98p1TJnsVzG2l1cSJvtyIbw2Lluib0+Hkwx2Nwu3qhQdE7NXaMwFeBtAuUyf6p4jgnAVnX3fhV2SMe3RTYIVgs0Nh8fTcn0iOJi7oMwBBWSBs4AGT0s747sK0KFGHzY45k3aZDF86GiyOoX1bfs9/SF8Q6e7nrqI0/GhjVkLJ7aO5/kZvNxsr2kbzr4MAUqEk0gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzPmWimbwZJNswzNAUVmdtzf4z9fuhuMI36LbwTiUFs=;
 b=ETb4RtQOt1jYU8KFcfBa0uSLhJtQaKKL6Kisat+fMUun+Gsg5t1KzU7S3E7A/yRySpJbnu3XOuYuMUC2X2OGPpdeL3zui0qKGuos5XVPkaTSmPDF6CkunjcJRjUfOGJbpuIsSJUKQPUB6j0Zi/BgFe66wkVHUE4QELot/d3birs=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3705.eurprd04.prod.outlook.com (2603:10a6:8:c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Wed, 27 Jan
 2021 01:44:43 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920%3]) with mapi id 15.20.3805.017; Wed, 27 Jan 2021
 01:44:42 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: RE: [PATCH V3 2/6] net: stmmac: stop each tx channel independently
Thread-Topic: [PATCH V3 2/6] net: stmmac: stop each tx channel independently
Thread-Index: AQHW89q6VA/6h2wcPU6sWoCffWx2wKo6iOeAgAAnhKA=
Date:   Wed, 27 Jan 2021 01:44:42 +0000
Message-ID: <DB8PR04MB6795C4AFFBC2CC1FB189F1FBE6BB0@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210126115854.2530-1-qiangqing.zhang@nxp.com>
 <20210126115854.2530-3-qiangqing.zhang@nxp.com>
 <CAF=yD-JEU2oSy11y47TvgTr-XHRNq7ar=j=5w+14EUSyLj7xHA@mail.gmail.com>
In-Reply-To: <CAF=yD-JEU2oSy11y47TvgTr-XHRNq7ar=j=5w+14EUSyLj7xHA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6abef254-004b-42ae-abf5-08d8c2651e5b
x-ms-traffictypediagnostic: DB3PR0402MB3705:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB3PR0402MB370507D03F99D23A04C887DAE6BB0@DB3PR0402MB3705.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x2mb0xe7eEWBtyrarjEPGWhF7s2adX6dlmZyOlBvuDO4jVRT7DeoUp36btaOa9xG7JO2f/S1VcFUR2Dgkdw/2aFtxt6K0UOYTAliLjsQdW/XjI0YIV+1P4ncF8dngLqMN++X/dhUdzST44OHqTdFTS2DwX8JOazWE2lGWm0rvFReFdRA7yDa9h40n8aBujWbKZMKrSTmWBeIU9teN8Lg70ZM8cBJ+HPcH0nhKstq7gATHLKExWqcptu0lVLBNgHIBYHZ/9LWpNjdCZvV4K9hY7Y24v3jAd6xGjWW+qAibA/LWwY6j35lSUovGSRYOYz3WPAgYWhBpNpROCB7E++1g10pNALe0inE+OGEhbQKwQKS7pWMsticH9oX5AR2+YrdgaOZU62F0iH7asLEGqS5mtwZjbccMA1YZVBpmpHRGEVwrKrSur7csty0VxEuI16FPopRZ8eC/KWW9Qr7HeXP9J0WuA8WoAmrojSbsB3ihch4O4/NXUHES2Bp9JnYsRcnZ2IDoUZyIdM26fhqOH5Zxg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(366004)(39860400002)(66476007)(83380400001)(54906003)(66556008)(8936002)(6916009)(66946007)(9686003)(186003)(52536014)(76116006)(86362001)(6506007)(66446008)(478600001)(53546011)(7696005)(8676002)(64756008)(33656002)(316002)(55016002)(4326008)(71200400001)(26005)(5660300002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WDlNNkdSRENGQ0cyRmpNLzVvYStEUUZNTTVPa1Fzdm5CNWl2R1I1U3Zxckd2?=
 =?utf-8?B?MDBwMlNON2hEWmUzS0dia2UzQUhwTkpwMUR6Y25sUU50TGRycWU1NnhaSW9G?=
 =?utf-8?B?MGZHZE1TWXcvaUx6R3loc05oWGpEQ3U3eFRRMUw0dVdXaXNSMDQvd3ZySXZL?=
 =?utf-8?B?L0cxWG5vdHRxWWFWaFFMaGNxdU8yRjE2c1lxN1Nma01oQ01keDR5RlRGVHVS?=
 =?utf-8?B?VHZFdnlhV2xKTyt0ai9OTFNweFNSUWhCRmRFRGVPMmlnODlFU0RZQSs0cXZS?=
 =?utf-8?B?V0hJS1JLVkpvUXRkenZlc0tLaVlaWHR1TzJra00zWld4aVQzWGcyRzluWkRL?=
 =?utf-8?B?WGVodk9xSGg2RXhuNmhidTVZNklpUiswOXVHRXZ2QVkvMGd6U0VxTUtQUU5N?=
 =?utf-8?B?b0F1c2hlQVFidUxyU2REYTN3aGZnMFZob2JWL1kxR05XQXlXclI0SVVrbDVF?=
 =?utf-8?B?akxmMHl4ZDhWQ0dTU2ZOaFVrZ1g5ZHhqSll4dk5QdXZ4L01yMUxreEZNVExu?=
 =?utf-8?B?dkh4UXVwRlRSKys3cEY4c1Z0cmxnUFJUVGtjNjlIWGNPM1Z4SWlzTUVJNFM4?=
 =?utf-8?B?c2pMeENXaWltcnFrSzJNVnc4YU1YYWlrNXhFeTc3S0NETnZ6a0ZxOXBiVi9a?=
 =?utf-8?B?N0tzSDBBcWpXZWgxVThCM0FaUnAyTlVyQU93WkcyRDVyUk0rSVl2OEZNNjZr?=
 =?utf-8?B?cG9lTlJsWnVPQWRRV3hPYUlXeDR5cUd4QUNpWUVQZHJQOFBWRzExSEtkcTVz?=
 =?utf-8?B?bmZYL04vc2hzZmcvNG9Dc2xLTE9wME5VL3JwZWRJL0Y3TEtiUEVpN21hOWxT?=
 =?utf-8?B?RTBJTXVHNmtQcFhlbUNPZ2Vma3F2NWovcE1TMGVyZUZjK00xK1pGZFduUGRR?=
 =?utf-8?B?cHJWL2JtL3B6WXhKK01mMUtvSnRkbzI0R1EwZVJZYXhsRCtqL3kzUFZ3QU92?=
 =?utf-8?B?eUZpa2tLR29MdXlYWmx6M09oczV3MmdNdHVNR3V6S2VCM3ZLODJyMkNGSmZX?=
 =?utf-8?B?VFpLZzhrZmNSRUpyU0JtRm0yY1dNQzh4dW9KQWFoT2pNQ3FUc1RST3l5c1hk?=
 =?utf-8?B?VDIzSkY3UTA3R2FPUWhSZFgyVlFSL2w5U3lPc2dxWFVSUS9nUEdVUGs2VWNJ?=
 =?utf-8?B?ZmV5dytoTytHdzZZMzEzZzZwbi9rTys4Q0ZhZ0JpR2NxREFGaldMd0JjV1d0?=
 =?utf-8?B?QzBrNngvN0FKcXgyZzREWjZlQmNqdEFaN3NDd0ZwL0Z0dTJQMWxHbjlENGhV?=
 =?utf-8?B?amVKRnZ0S202b0NmTVoyeE1CNmxpYWhOTEIwaHF4RThMVG5YaEJlZURaSUxu?=
 =?utf-8?B?bThIQVZGblJYc0Q3dStGOXhMU3ZGUHFWeEdQWUxmaVJrQTZYaTBLYVRtQkV1?=
 =?utf-8?B?S29aaEtPeEV4Ym5KQnVNcVBrK2U4RW51bzBlTTVOM2xNZlNQUmQrcUNWMlE2?=
 =?utf-8?Q?bEYYgjiQ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6abef254-004b-42ae-abf5-08d8c2651e5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 01:44:42.8988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aFkYgHeZ4NXNhgBxR42AecA3YeNJFb41YFAq067qQm40hP/wR7rqUfxcN+/hzBQ0+8RDOwaEfbY1NMuuNlEuMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3705
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFdpbGxlbSBkZSBCcnVpam4g
PHdpbGxlbWRlYnJ1aWpuLmtlcm5lbEBnbWFpbC5jb20+DQo+IFNlbnQ6IDIwMjHlubQx5pyIMjfm
l6UgNzoxMA0KPiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4g
Q2M6IEdpdXNlcHBlIENhdmFsbGFybyA8cGVwcGUuY2F2YWxsYXJvQHN0LmNvbT47IEFsZXhhbmRy
ZSBUb3JndWUNCj4gPGFsZXhhbmRyZS50b3JndWVAc3QuY29tPjsgSm9zZSBBYnJldSA8am9hYnJl
dUBzeW5vcHN5cy5jb20+OyBEYXZpZA0KPiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBK
YWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgTmV0d29yaw0KPiBEZXZlbG9wbWVudCA8
bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+
Ow0KPiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+OyBGbG9yaWFuIEZhaW5lbGxpIDxmLmZh
aW5lbGxpQGdtYWlsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBWMyAyLzZdIG5ldDogc3Rt
bWFjOiBzdG9wIGVhY2ggdHggY2hhbm5lbCBpbmRlcGVuZGVudGx5DQo+IA0KPiBPbiBUdWUsIEph
biAyNiwgMjAyMSBhdCA3OjAzIEFNIEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5j
b20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gSWYgY2xlYXIgR01BQ19DT05GSUdfVEUgYml0LCBpdCB3
b3VsZCBzdG9wIGFsbCB0eCBjaGFubmVscywgYnV0IHVzZXJzDQo+ID4gbWF5IG9ubHkgd2FudCB0
byBzdG9wIHNlY2lmaWMgdHggY2hhbm5lbC4NCj4gDQo+IHNlY2lmaWMgLT4gc3BlY2lmaWMNCg0K
VGhhbmtzLiBXaWxsIGNvcnJlY3QgaXQuDQoNCj4gPg0KPiA+IEZpeGVzOiA0ODg2M2NlNTk0MGYg
KCJzdG1tYWM6IGFkZCBETUEgc3VwcG9ydCBmb3IgR01BQyA0Lnh4IikNCj4gPiBTaWduZWQtb2Zm
LWJ5OiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiA+IC0tLQ0KPiA+
ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9kd21hYzRfbGliLmMgfCA0IC0t
LS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDQgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWM0X2xpYi5jDQo+
ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9kd21hYzRfbGliLmMNCj4g
PiBpbmRleCAwYjRlZTJkYmI2OTEuLjcxZTUwNzUxZWYyZCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9kd21hYzRfbGliLmMNCj4gPiArKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9kd21hYzRfbGliLmMNCj4gPiBAQCAt
NTMsMTAgKzUzLDYgQEAgdm9pZCBkd21hYzRfZG1hX3N0b3BfdHgodm9pZCBfX2lvbWVtICppb2Fk
ZHIsDQo+IHUzMg0KPiA+IGNoYW4pDQo+ID4NCj4gPiAgICAgICAgIHZhbHVlICY9IH5ETUFfQ09O
VFJPTF9TVDsNCj4gPiAgICAgICAgIHdyaXRlbCh2YWx1ZSwgaW9hZGRyICsgRE1BX0NIQU5fVFhf
Q09OVFJPTChjaGFuKSk7DQo+ID4gLQ0KPiA+IC0gICAgICAgdmFsdWUgPSByZWFkbChpb2FkZHIg
KyBHTUFDX0NPTkZJRyk7DQo+ID4gLSAgICAgICB2YWx1ZSAmPSB+R01BQ19DT05GSUdfVEU7DQo+
ID4gLSAgICAgICB3cml0ZWwodmFsdWUsIGlvYWRkciArIEdNQUNfQ09ORklHKTsNCj4gDQo+IElz
IGl0IHNhZmUgdG8gcGFydGlhbGx5IHVud2luZCB0aGUgYWN0aW9ucyBvZiBkd21hYzRfZG1hX3N0
YXJ0X3R4DQo+IA0KPiBBbmQgd291bGQgdGhlIHNhbWUgcmVhc29uaW5nIGFwcGx5IHRvIGR3bWFj
NF8oZG1hX3N0YXJ0fHN0b3ApX3J4Pw0KDQpTb3JyeSwgSSBhbSBub3QgcXVpdGUgdW5kZXJzdGFu
ZCB3aGF0IHlvdSBtZWFucy4NCg0KV2hhdCB0aGlzIHBhdGNoIGRpZCBpcyB0byBhbGlnbiB0byBk
d21hYzRfKGRtYV9zdGFydHxzdG9wKV9yeC4NCg0KZHdtYWM0X2RtYV9zdGFydF9yeDogYXNzZXJ0
IERNQV9DT05UUk9MX1NSIGJpdCBmb3IgZWFjaCBjaGFubmVsLCBhbmQgYXNzZXJ0IEdNQUNfQ09O
RklHX1JFIGJpdCB3aGljaCB0YXJnZXRzIGFsbCBjaGFubmVscy4NCmR3bWFjNF9kbWFfc3RvcF9y
eDogb25seSBuZWVkIGNsZWFyIERNQV9DT05UUk9MX1NSIGJpdCBmb3IgZWFjaCBjaGFubmVsLg0K
DQpBZnRlciB0aGlzIHBhdGNoIGFwcGxpZWQ6DQpkd21hYzRfZG1hX3N0YXJ0X3R4OiBhc3NlcnQg
RE1BX0NPTlRST0xfU1QgYml0IGZvciBlYWNoIGNoYW5uZWwsIGFuZCBhc3NlcnQgR01BQ19DT05G
SUdfVEUgYml0IHdoaWNoIHRhcmdldHMgYWxsIGNoYW5uZWxzLg0KZHdtYWM0X2RtYV9zdG9wX3R4
OiBvbmx5IG5lZWQgY2xlYXIgRE1BX0NPTlRST0xfU1QgYml0IGZvciBlYWNoIGNoYW5uZWwuDQoN
CllvdSBjYW4gcmVmZXIgdG8gZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdt
YWM0X2xpYi5jLCB0aGlzIGlzIHRoZSBjb3JyZWN0IHNlcXVlbmNlLiANCg0KVGhhbmtzLg0KDQpC
ZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg==
