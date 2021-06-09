Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5391D3A0A46
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 04:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbhFICxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 22:53:09 -0400
Received: from mail-eopbgr80073.outbound.protection.outlook.com ([40.107.8.73]:26099
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232690AbhFICxI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 22:53:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A49Rll7EMr0s9EoMwIhvAL560ysoPsRdqL7INOqtQtP0xE3XibFJiiN4CrV10BAH6jwo4Tm8RBe+oksSUUM3HGc8wZkD+IFDZqjKRCNT1IWsmg3AK6+P8v/gqvtaaGCwD5FMZALcxpXGMlVhGoYiiKlLhK4OX57v59L38uvwZ5xo+z+WXL6iqVFmr9i7sI7xIeBsBLiTktzuwUa2s+Q2ZxyHdQygvDQlSKa4YCAlhXxugFlHSWqMaf4cQL6cDpCcPwrSD6hwNor+RAYOQCbrp60XZx4uFsd2qWpw2Yp35fYeEQ9jab7z0CFKabysbS2PI1lNFSwyEB6UilJfv0OjVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hh3uURxvdJsT4pgQxk+u2v3LPuI5YTrlYzc1pmC2bco=;
 b=KQWInTb2NmTI4rAiQtVBnHOQ6mVMVKwVpT28cLVZjtF6lzE0rJDeGoWRlEykPNIUbuM0PymjBxkSEEh3mls2YkAvGEHXadmVD/9u8GmwLJJNWzATIm1+xGUv8+kBSQ+hmul28+7b7SiBAHksnUgxatdfvxOgwh3qJTEWx8mfNKuCEEMOhNslQbP9LZYEIrHf+lN4Ua34KCPJIsD0ticVrLW/NDtVe3ksVsbdT70g4Ts6Bnfs6We7AGWH7BWCejJ1F5PYKgYZOJ78c19iWVDcMlgLmo2SlNbGA9naN1AXi7XWVVVfbw0clwKwcfENZGPdDQ320ZKE0uh8fTY7Hu0BbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hh3uURxvdJsT4pgQxk+u2v3LPuI5YTrlYzc1pmC2bco=;
 b=NRyEUHPjYGLywvTcpz5IPo+E1hIWMk9VuFB2/Xsp4f5j8JLQIkD0aOK6diRSIkIyZmNbzkXfMarx0vt5yx1XhKpQ65EZmxnB6t8EWex7jnUgL3FzMUPXUUDh61qKbkYoYI1YGsseTNciTMQpHnttoPXRHxImWzBDTVCKng/pmao=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6796.eurprd04.prod.outlook.com (2603:10a6:10:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 02:51:12 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4219.020; Wed, 9 Jun 2021
 02:51:11 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V3 net-next 3/4] net: phy: realtek: add dt property to
 enable ALDPS mode
Thread-Topic: [PATCH V3 net-next 3/4] net: phy: realtek: add dt property to
 enable ALDPS mode
Thread-Index: AQHXXBSh0nhwyLkWNESDxO+tqgeOSKsJ324AgAAFxMCAAQf8gIAACx4g
Date:   Wed, 9 Jun 2021 02:51:11 +0000
Message-ID: <DB8PR04MB67955F0424EAEBF362D34B30E6369@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
        <20210608031535.3651-4-qiangqing.zhang@nxp.com>
        <20210608175104.7ce18d1d@xhacker.debian>
        <DB8PR04MB6795D312FDECF820164B0DE6E6379@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210609095633.1bce2c22@xhacker.debian>
In-Reply-To: <20210609095633.1bce2c22@xhacker.debian>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: synaptics.com; dkim=none (message not signed)
 header.d=none;synaptics.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5045491-2577-4fe1-f9f9-08d92af170e0
x-ms-traffictypediagnostic: DB8PR04MB6796:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB67963656064AC7EC98CDA2F3E6369@DB8PR04MB6796.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JJpNuRJ2EqBZYSKwBnC+egJroUeQfSEfxF560Tv9c7Q9AmTmHNLQfqtqAI+XKOHJ9E7+/6YG1v8BKT9mWqIocTJS6iG2bQ8vxcwIBeo8lKu5v/dDHC0p0nIMYysnczBWK2bsLP73ezIXnh05RDh4p/Tu9rvVpAGk3NXiOxYJs22WdxvU03RZ/bhIr9sV8GfuEjobeGX/Uj7gv5OqiTxdhirrm3QHqXIGR5HEKJfJRpARR2/ifSujkCT6iJaLDLtkQKp9IJgcVW77a64i4UMqHf5SvK3gYhtTjWV6I8oBpzJ8uv4od/peH9EN+r0xhmWofv/7GmUr8bsLFo4DnMcjvlNqDj5fRgq89z356P7Ho8PTR9ezrJ9V9G4LIFup4DAIJTpoEw9HwKqTzRPhtnBhbJVMPHa7ucKDiaCW84iMjiPVAndraKthYpP3E4Z0bld5sOwGdCz+hcCapwnnzKWnWL5HqJG5wO7gpX62gpizSWAuPLlqrHUEtaALY2VQaVTpgEpljQ35Z+1C8DlCq3w4Z26ztUMvMdEP/KVdzBDgfavcmCugaq9upXYDL1lqdnmqzZ4AV1WS73fI+SqUDcggz9fmMC+jxjvkXj/Gb8ISsOo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(366004)(136003)(376002)(316002)(38100700002)(66446008)(4326008)(33656002)(478600001)(54906003)(76116006)(66946007)(66476007)(64756008)(66556008)(186003)(55016002)(5660300002)(6916009)(83380400001)(86362001)(8936002)(52536014)(53546011)(7696005)(7416002)(2906002)(26005)(71200400001)(122000001)(9686003)(6506007)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZFBOUGpLb20vNnd0Z1lhTlcrUDZoRmlpZWFiSDVYc29PRmtrRDJXd2RUT29Z?=
 =?utf-8?B?MTJRQjZDUXdhMkltMDdmWWhVUHhGcGFLLzBFUUFFUmFlRlY0TzRNZm5BTVhq?=
 =?utf-8?B?WUVnako2amcvWGdKay9BSzhMRlFMNnJtYVFqemRRelNPTHJtek15elBxZjZG?=
 =?utf-8?B?a2pFWjM2TGhiR2MwZTlPcktuM2VSNHZSR3hkK1RHd1pPZHl6b3ZJdHBESlB2?=
 =?utf-8?B?aVR2eFVXT2FINUZSYWo1VWNscFdOTzNiRVFtV1lDZE1ZdjkwMnVIV2NtclBh?=
 =?utf-8?B?VmE4Qk50Tk9SSFZmVStiZnV1azJiajZaZEJsczdLdm1TOFZ0NGZPb1BESUQ2?=
 =?utf-8?B?TVovQzM3SEJIbnVOM21DN2o5UWFDcS9ZbTZyVE9mNWFFL1UyK1YrK2wyU1Js?=
 =?utf-8?B?SjlPd1dycEtteHpZUk15ODFCSVVDWDBMQXpPZk1QNlI0ZS9LZlg5R3Fzcndt?=
 =?utf-8?B?NU9uTjRHZDdjUGFCQmpOL3Z2VTVVUlFINEZheENOWTVacWxCdTl4MGNCMUpU?=
 =?utf-8?B?MThEYklZUEFxY3ROMmhoRnRhYXdMOWNYNmF6dklQc3A1MCtnVk9ncFFWUnN2?=
 =?utf-8?B?a2RRRzBpZ2UvM0Z3Mm9YeU8wQUVmUGJYSDFzeURtTG9hUU5YYzR6WWFBbGFn?=
 =?utf-8?B?MFo2M280MzBDMDJZWEw5Wm85SUFBNGczeWFIRzF5N1BpaWt3QWtKZ1Z6RjBN?=
 =?utf-8?B?T3dDS05VQU11eVpJQVlUQmp6eTVWVFREOWIvMG1mZlpGY24wUndMZmIyYU02?=
 =?utf-8?B?WGd5NVpXbG1oM1lBN2lJbzIrOHcyZWlCTGg1MUZGdWUrR0VZbGc2c3FOQy9U?=
 =?utf-8?B?ZjUxQ00vTHNhNUR2dVQzTmc0aVh6T2N5aTViRkZJcG9KdjVvZmJLUzhQVk96?=
 =?utf-8?B?bGFiL0FGNDl1Q2F6dzcvVWJ1SnNvbmcwVEMrY2tZWHVXdXJra0RCMFJRcHFp?=
 =?utf-8?B?RktVTzBleWpZNnoxMnl2WFN5SGxGeFFOMTUvZ1hWaVBXdVVwTytMbU1LclB1?=
 =?utf-8?B?NlhRaTRxanRPMndBMTNtM3FxbzhEdXR1cWVoWVZXL3VrNXNaTWpFNzBOb1RL?=
 =?utf-8?B?SW4rYnA1K2QvbXpQUi82WVpCSUN6QUorcGdma1RuTDlqYVBNOElKUlZVT0RB?=
 =?utf-8?B?RzMzY0p3YVVPR3hFWlQveUpUbi90NCt4eTdpNCs5SEFJalhkRWx0R0hndG10?=
 =?utf-8?B?VmZSQzhDc3dWd2NoV29GL0tCUzVDWk5HTHhLa3BXdDZNZnpidW1Eamcra3l1?=
 =?utf-8?B?VklXclRwYWU4SDcwbE9IekQ2UFlhYlVNM3RIdU0yYU9NMU1sazVNRkw5WTBi?=
 =?utf-8?B?WkJLL2p0WVFTZHdmcGIyL3ZRa29hYSsvenBZMmVHb2ZCblNrc2hKWDgxcHF1?=
 =?utf-8?B?emswY2czYTRYVVJCK2pPb3dKeGFpNDE3WGhkKzQzYTgxZU5OQ3V0NjFRMkJy?=
 =?utf-8?B?NHU0UzZKNWlSdnhSY213UzBwdHZuMmtPMGRQMTdkT2xwbXAwanMyZit6UEp2?=
 =?utf-8?B?Q1pWei93YnFNYVhqcFBuY3paK3NpU0VRUWFnVmg2SFVhK1ZyQVdYS2FJb3FH?=
 =?utf-8?B?UUo2TGJFSzN4amd4SXA0WmhEeWZLdDNzSTc3eU93aU4wU2c2KzNUc1dQUG1X?=
 =?utf-8?B?TDNKOW41Q3ZIT1FLazlzc3VFVS83d0hDSzdoVXF4SjVkUDV2Rmg0R1RMR0pZ?=
 =?utf-8?B?eE1LT0xqMnBjOTdaSUVRaHl2WHhWK0xQdlk1ejIvTFZoQVlrbTlleVp2d2tB?=
 =?utf-8?Q?0NCygOo7P3XwS7bkf2ngI9qGwX87rZSMf3nXze1?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5045491-2577-4fe1-f9f9-08d92af170e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2021 02:51:11.7140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jSsB5jRqeDFVF070IG5rzM8aHdhFh4eoeWjcfnQwdV1w+MA7J/vJ/a2ICPjuCk16h7uGQs8Q2ETF9yW4GaaqXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6796
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBKaXNoZW5nLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpp
c2hlbmcgWmhhbmcgPEppc2hlbmcuWmhhbmdAc3luYXB0aWNzLmNvbT4NCj4gU2VudDogMjAyMeW5
tDbmnIg55pelIDk6NTcNCj4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5j
b20+DQo+IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IHJvYmgrZHRA
a2VybmVsLm9yZzsNCj4gYW5kcmV3QGx1bm4uY2g7IGhrYWxsd2VpdDFAZ21haWwuY29tOyBsaW51
eEBhcm1saW51eC5vcmcudWs7DQo+IGYuZmFpbmVsbGlAZ21haWwuY29tOyBkbC1saW51eC1pbXgg
PGxpbnV4LWlteEBueHAuY29tPjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgZGV2aWNldHJl
ZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3Vi
amVjdDogUmU6IFtQQVRDSCBWMyBuZXQtbmV4dCAzLzRdIG5ldDogcGh5OiByZWFsdGVrOiBhZGQg
ZHQgcHJvcGVydHkgdG8NCj4gZW5hYmxlIEFMRFBTIG1vZGUNCj4gDQo+IE9uIFR1ZSwgOCBKdW4g
MjAyMSAxMDoxNDo0MCArMDAwMA0KPiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAu
Y29tPiB3cm90ZToNCj4gDQo+IA0KPiA+DQo+ID4NCj4gPiBIaSBKaXNoZW5nLA0KPiANCj4gSGks
DQo+IA0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTog
SmlzaGVuZyBaaGFuZyA8SmlzaGVuZy5aaGFuZ0BzeW5hcHRpY3MuY29tPg0KPiA+ID4gU2VudDog
MjAyMeW5tDbmnIg45pelIDE3OjUxDQo+ID4gPiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3Fpbmcu
emhhbmdAbnhwLmNvbT4NCj4gPiA+IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5l
bC5vcmc7IHJvYmgrZHRAa2VybmVsLm9yZzsNCj4gPiA+IGFuZHJld0BsdW5uLmNoOyBoa2FsbHdl
aXQxQGdtYWlsLmNvbTsgbGludXhAYXJtbGludXgub3JnLnVrOw0KPiA+ID4gZi5mYWluZWxsaUBn
bWFpbC5jb207IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+Ow0KPiA+ID4gbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7DQo+ID4gPiBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+ID4gPiBTdWJqZWN0OiBSZTogW1BBVENIIFYzIG5l
dC1uZXh0IDMvNF0gbmV0OiBwaHk6IHJlYWx0ZWs6IGFkZCBkdA0KPiA+ID4gcHJvcGVydHkgdG8g
ZW5hYmxlIEFMRFBTIG1vZGUNCj4gPiA+DQo+ID4gPiBPbiBUdWUsICA4IEp1biAyMDIxIDExOjE1
OjM0ICswODAwDQo+ID4gPiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPiB3
cm90ZToNCj4gPiA+DQo+ID4gPg0KPiA+ID4gPg0KPiA+ID4gPg0KPiA+ID4gPiBJZiBlbmFibGUg
QWR2YW5jZSBMaW5rIERvd24gUG93ZXIgU2F2aW5nIChBTERQUykgbW9kZSwgaXQgd2lsbA0KPiA+
ID4gPiBjaGFuZ2UgY3J5c3RhbC9jbG9jayBiZWhhdmlvciwgd2hpY2ggY2F1c2UgUlhDIGNsb2Nr
IHN0b3AgZm9yDQo+ID4gPiA+IGRvemVucyB0byBodW5kcmVkcyBvZiBtaWxpc2Vjb25kcy4gVGhp
cyBpcyBjb21maXJtZWQgYnkgUmVhbHRlaw0KPiA+ID4gPiBlbmdpbmVlci4gRm9yIHNvbWUgTUFD
cywgaXQgbmVlZHMgUlhDIGNsb2NrIHRvIHN1cHBvcnQgUlggbG9naWMsDQo+ID4gPiA+IGFmdGVy
IHRoaXMgcGF0Y2gsIFBIWSBjYW4gZ2VuZXJhdGUgY29udGludW91cyBSWEMgY2xvY2sgZHVyaW5n
DQo+IGF1dG8tbmVnb3RpYXRpb24uDQo+ID4gPiA+DQo+ID4gPiA+IEFMRFBTIGRlZmF1bHQgaXMg
ZGlzYWJsZWQgYWZ0ZXIgaGFyZHdhcmUgcmVzZXQsIGl0J3MgbW9yZQ0KPiA+ID4gPiByZWFzb25h
YmxlIHRvIGFkZCBhIHByb3BlcnR5IHRvIGVuYWJsZSB0aGlzIGZlYXR1cmUsIHNpbmNlIEFMRFBT
DQo+ID4gPiA+IHdvdWxkIGludHJvZHVjZSBzaWRlDQo+ID4gPiBlZmZlY3QuDQo+ID4gPiA+IFRo
aXMgcGF0Y2ggYWRkcyBkdCBwcm9wZXJ0eSAicmVhbHRlayxhbGRwcy1lbmFibGUiIHRvIGVuYWJs
ZSBBTERQUw0KPiA+ID4gPiBtb2RlIHBlciB1c2VycycgcmVxdWlyZW1lbnQuDQo+ID4gPiA+DQo+
ID4gPiA+IEppc2hlbmcgWmhhbmcgZW5hYmxlcyB0aGlzIGZlYXR1cmUsIGNoYW5nZXMgdGhlIGRl
ZmF1bHQgYmVoYXZpb3IuDQo+ID4gPiA+IFNpbmNlIG1pbmUgcGF0Y2ggYnJlYWtzIHRoZSBydWxl
IHRoYXQgbmV3IGltcGxlbWVudGF0aW9uIHNob3VsZA0KPiA+ID4gPiBub3QgYnJlYWsgZXhpc3Rp
bmcgZGVzaWduLCBzbyBDYydlZCBsZXQgaGltIGtub3cgdG8gc2VlIGlmIGl0IGNhbiBiZQ0KPiBh
Y2NlcHRlZC4NCj4gPiA+ID4NCj4gPiA+ID4gQ2M6IEppc2hlbmcgWmhhbmcgPEppc2hlbmcuWmhh
bmdAc3luYXB0aWNzLmNvbT4NCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogSm9ha2ltIFpoYW5nIDxx
aWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gPiA+ID4gLS0tDQo+ID4gPiA+ICBkcml2ZXJzL25l
dC9waHkvcmVhbHRlay5jIHwgMjAgKysrKysrKysrKysrKysrKystLS0NCj4gPiA+ID4gIDEgZmls
ZSBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiA+ID4gPg0KPiA+
ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcGh5L3JlYWx0ZWsuYyBiL2RyaXZlcnMvbmV0
L3BoeS9yZWFsdGVrLmMNCj4gPiA+ID4gaW5kZXggY2EyNThmMmE5NjEzLi43OWRjNTViYjQwOTEg
MTAwNjQ0DQo+ID4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9yZWFsdGVrLmMNCj4gPiA+ID4g
KysrIGIvZHJpdmVycy9uZXQvcGh5L3JlYWx0ZWsuYw0KPiA+ID4gPiBAQCAtNzYsNiArNzYsNyBA
QCBNT0RVTEVfQVVUSE9SKCJKb2huc29uIExldW5nIik7DQo+ID4gPiA+IE1PRFVMRV9MSUNFTlNF
KCJHUEwiKTsNCj4gPiA+ID4NCj4gPiA+ID4gIHN0cnVjdCBydGw4MjF4X3ByaXYgew0KPiA+ID4g
PiArICAgICAgIHUxNiBwaHljcjE7DQo+ID4gPiA+ICAgICAgICAgdTE2IHBoeWNyMjsNCj4gPiA+
ID4gIH07DQo+ID4gPiA+DQo+ID4gPiA+IEBAIC05OCw2ICs5OSwxNCBAQCBzdGF0aWMgaW50IHJ0
bDgyMXhfcHJvYmUoc3RydWN0IHBoeV9kZXZpY2UNCj4gKnBoeWRldikNCj4gPiA+ID4gICAgICAg
ICBpZiAoIXByaXYpDQo+ID4gPiA+ICAgICAgICAgICAgICAgICByZXR1cm4gLUVOT01FTTsNCj4g
PiA+ID4NCj4gPiA+ID4gKyAgICAgICBwcml2LT5waHljcjEgPSBwaHlfcmVhZF9wYWdlZChwaHlk
ZXYsIDB4YTQzLA0KPiA+ID4gUlRMODIxMUZfUEhZQ1IxKTsNCj4gPiA+ID4gKyAgICAgICBpZiAo
cHJpdi0+cGh5Y3IxIDwgMCkNCj4gPiA+ID4gKyAgICAgICAgICAgICAgIHJldHVybiBwcml2LT5w
aHljcjE7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyAgICAgICBwcml2LT5waHljcjEgJj0gKFJUTDgy
MTFGX0FMRFBTX1BMTF9PRkYgfA0KPiA+ID4gPiArIFJUTDgyMTFGX0FMRFBTX0VOQUJMRSB8IFJU
TDgyMTFGX0FMRFBTX1hUQUxfT0ZGKTsNCj4gDQo+IEkgYmVsaWV2ZSB5b3VyIGludGVudGlvbiBp
cw0KPiANCj4gcHJpdi0+cGh5Y3IxICY9IH4oUlRMODIxMUZfQUxEUFNfUExMX09GRiB8IFJUTDgy
MTFGX0FMRFBTX0VOQUJMRSB8DQo+IHByaXYtPlJUTDgyMTFGX0FMRFBTX1hUQUxfT0ZGKTsNCj4g
SG93ZXZlciwgdGhpcyBpcyBub3QgbmVjZXNzYXJ5LiBTZWUgYmVsb3cuDQoNCk5vLCBtaW5lIGlu
dGVudGlvbiBpcyB0byByZWFkIGJhY2sgdGhpcyB0aHJlZSBiaXRzIHdoYXQgdGhlIHJlZ2lzdGVy
IGNvbnRhaW5lZC4NCg0KPiA+ID4NCj4gPiA+IHByaXYtPnBoeWNyMSBpcyAwIGJ5IGRlZmF1bHQs
IHNvIGFib3ZlIDUgTG9DcyBjYW4gYmUgcmVtb3ZlZA0KPiA+DQo+ID4gVGhlIGludGVudGlvbiBv
ZiB0aGlzIGlzIHRvIHRha2UgYm9vdGxvYWRlciBpbnRvIGFjY291bnQuIFN1Y2ggYXMgdWJvb3QN
Cj4gY29uZmlndXJlIHRoZSBQSFkgYmVmb3JlLg0KPiANCj4gVGhlIGxhc3QgcGFyYW0gInNldCIg
b2YgcGh5X21vZGlmeV9wYWdlZF9jaGFuZ2VkKCkgbWVhbnMgKmJpdCBtYXNrIG9mIGJpdHMNCj4g
dG8gc2V0KiBJZiB3ZSBkb24ndCB3YW50IHRvIGVuYWJsZSBBTERQUywgMCBpcyBlbm91Z2guDQo+
IA0KPiBFdmVuIGlmIHVib290IGNvbmZpZ3VyZWQgdGhlIFBIWSBiZWZvcmUgbGludXgsIEkgYmVs
aWV2ZQ0KPiBwaHlfbW9kaWZ5X3BhZ2VkX2NoYW5nZWQoKSBjYW4gY2xlYXIgQUxEUFMgYml0cyB3
L28gYWJvdmUgNSBMb0NzLg0KDQpUaGUgbG9naWMgaXM6DQoxKSByZWFkIGJhY2sgdGhlc2UgdGhy
ZWUgYml0cyBmcm9tIHRoZSByZWdpc3Rlci4NCjIpIGlmIGxpbnV4IHNldCAicmVhbHRlayxhbGRw
cy1lbmFibGUiLCBhc3NlcnQgdGhlc2UgdGhyZWUgYml0OyBpZiBub3QsIGtlZXAgdGhlc2UgdGhy
ZWUgYml0cyByZWFkIGJlZm9yZS4NCjMpIGNhbGwgcGh5X21vZGlmeV9wYWdlZF9jaGFuZ2VkKCkg
dG8gY29uZmlndXJlLCAibWFzayIgcGFyYW1ldGVyIHRvIGNsZWFyIHRoZXNlIHRocmVlIGJpdHMg
Zmlyc3QsICJzZXQiIHBhcmFtZXRlciB0byBhc3NlcnQgdGhlc2UgdGhyZWUgYml0cyBwZXIgdGhl
IHJlc3VsdCBvZiBzdGVwIDIuDQoNClNvLCBpZiBzdGVwIDEgcmVhZCBiYWNrIHRoZSB2YWx1ZSBp
cyB0aGF0IHRoZXNlIHRocmVlIGJpdHMgYXJlIGFzc2VydGVkLCB0aGVuIGluIHN0ZXAgMywgaXQg
d2lsbCBmaXJzdCBjbGVhciB0aGVzZSB0aHJlZSBiaXRzIGFuZCBhc3NlcnQgdGhlc2UgdGhyZWUg
Yml0cyBhZ2Fpbi4gVGhlIHJlc3VsdCBpcyBBTERQUyBpcyBlbmFibGVkIGV2ZW4gd2l0aG91dCAi
IHJlYWx0ZWssYWxkcHMtZW5hYmxlICIgaW4gRFQuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBa
aGFuZw0KPiBUaGFua3MNCj4gDQo+ID4NCj4gPiBCZXN0IFJlZ2FyZHMsDQo+ID4gSm9ha2ltIFpo
YW5nDQo+ID4gPiA+ICsgICAgICAgaWYgKG9mX3Byb3BlcnR5X3JlYWRfYm9vbChkZXYtPm9mX25v
ZGUsDQo+ICJyZWFsdGVrLGFsZHBzLWVuYWJsZSIpKQ0KPiA+ID4gPiArICAgICAgICAgICAgICAg
cHJpdi0+cGh5Y3IxIHw9IFJUTDgyMTFGX0FMRFBTX1BMTF9PRkYgfA0KPiA+ID4gPiArIFJUTDgy
MTFGX0FMRFBTX0VOQUJMRSB8IFJUTDgyMTFGX0FMRFBTX1hUQUxfT0ZGOw0KPiA+ID4gPiArDQo+
ID4gPiA+ICAgICAgICAgcHJpdi0+cGh5Y3IyID0gcGh5X3JlYWRfcGFnZWQocGh5ZGV2LCAweGE0
MywNCj4gPiA+IFJUTDgyMTFGX1BIWUNSMik7DQo+ID4gPiA+ICAgICAgICAgaWYgKHByaXYtPnBo
eWNyMiA8IDApDQo+ID4gPiA+ICAgICAgICAgICAgICAgICByZXR1cm4gcHJpdi0+cGh5Y3IyOyBA
QCAtMzI0LDExICszMzMsMTYgQEAgc3RhdGljDQo+ID4gPiA+IGludCBydGw4MjExZl9jb25maWdf
aW5pdChzdHJ1Y3QgcGh5X2RldmljZQ0KPiA+ID4gKnBoeWRldikNCj4gPiA+ID4gICAgICAgICBz
dHJ1Y3QgcnRsODIxeF9wcml2ICpwcml2ID0gcGh5ZGV2LT5wcml2Ow0KPiA+ID4gPiAgICAgICAg
IHN0cnVjdCBkZXZpY2UgKmRldiA9ICZwaHlkZXYtPm1kaW8uZGV2Ow0KPiA+ID4gPiAgICAgICAg
IHUxNiB2YWxfdHhkbHksIHZhbF9yeGRseTsNCj4gPiA+ID4gLSAgICAgICB1MTYgdmFsOw0KPiA+
ID4gPiAgICAgICAgIGludCByZXQ7DQo+ID4gPiA+DQo+ID4gPiA+IC0gICAgICAgdmFsID0gUlRM
ODIxMUZfQUxEUFNfRU5BQkxFIHwgUlRMODIxMUZfQUxEUFNfUExMX09GRiB8DQo+ID4gPiBSVEw4
MjExRl9BTERQU19YVEFMX09GRjsNCj4gPiA+ID4gLSAgICAgICBwaHlfbW9kaWZ5X3BhZ2VkX2No
YW5nZWQocGh5ZGV2LCAweGE0MywgUlRMODIxMUZfUEhZQ1IxLA0KPiB2YWwsDQo+ID4gPiB2YWwp
Ow0KPiA+ID4gPiArICAgICAgIHJldCA9IHBoeV9tb2RpZnlfcGFnZWRfY2hhbmdlZChwaHlkZXYs
IDB4YTQzLA0KPiA+ID4gUlRMODIxMUZfUEhZQ1IxLA0KPiA+ID4gPiArDQo+IFJUTDgyMTFGX0FM
RFBTX1BMTF9PRkYgfA0KPiA+ID4gUlRMODIxMUZfQUxEUFNfRU5BQkxFIHwgUlRMODIxMUZfQUxE
UFNfWFRBTF9PRkYsDQo+ID4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHByaXYtPnBoeWNyMSk7DQo+ID4gPiA+ICsgICAgICAgaWYgKHJldCA8IDApIHsNCj4gPiA+
ID4gKyAgICAgICAgICAgICAgIGRldl9lcnIoZGV2LCAiYWxkcHMgbW9kZSAgY29uZmlndXJhdGlv
bg0KPiBmYWlsZWQ6ICVwZVxuIiwNCj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgRVJS
X1BUUihyZXQpKTsNCj4gPiA+ID4gKyAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+ID4gPiA+
ICsgICAgICAgfQ0KPiA+ID4gPg0KPiA+ID4gPiAgICAgICAgIHN3aXRjaCAocGh5ZGV2LT5pbnRl
cmZhY2UpIHsNCj4gPiA+ID4gICAgICAgICBjYXNlIFBIWV9JTlRFUkZBQ0VfTU9ERV9SR01JSToN
Cj4gPiA+ID4gLS0NCj4gPiA+ID4gMi4xNy4xDQo+ID4gPiA+DQo+ID4NCg0K
