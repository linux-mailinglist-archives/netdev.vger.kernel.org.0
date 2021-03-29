Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40CE34CCC8
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 11:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbhC2JOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 05:14:43 -0400
Received: from mail-vi1eur05on2073.outbound.protection.outlook.com ([40.107.21.73]:19937
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235241AbhC2JMU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 05:12:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZrFls8GIempGudjrdkgT0SnSPeq7AmUAmEUb77qnpQDk9QVfc1FGBYpVecfn3cZp9kSZ7SLXYPU1+6DU5Gq1tJ90m2LN6dWWSSYwwncczHy5SfIHok+QnluqBjgK7axcnphniV1ooLzH27vdZMP009r1qzLbsEFkcrUL1dJhOS4UXvisXPx3JsPWXoLVUTY+sLte14zlgtFV2qQEOELGJLxQJ2nn6cjwmnqjTFIcW+5WBn94llsTLjdI6W0Wn99XbTQK7TLHF0rYTDfhOVwPbH40t0neFcxNZjw7dJ3IONySc4uDNB+vqxGRs7HHJXZIahij68P3MFtZegeiimtbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nsn0ZeLbeaC10k19QHu5GFGoVzcttxRiUgobYsMuugE=;
 b=T0zz0dEZHnGZZCuD3xsStuA3465xsokGdUHszUiMFBeaSjKoNgxZHxEAHTsXFrDUHYqJ0YNZxY1BqNAxDy4NebF2mHRYL72Ggxz27Lb+nM0W3eZjRKvzVQZlSWdrWtvYdZDPDzrRBooVtQJdrS2rFU4ztA1g/rP6aByqz+w7k98bQKj5u9k0QV9efzg4/gLszyFZ4G7YLeQfUJBzb0AhUGnbQ6PYrrVfR9gICHZHwCzZq10bB8Min/EF65aEcMb/mMfSRH0fLTouk3DhQNc7wCDO933q4I7+WLFU1p1DAg4SrZL9teXna9plUYHfqNDi7yFDyxfR7HPZJTLlGJH0Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nsn0ZeLbeaC10k19QHu5GFGoVzcttxRiUgobYsMuugE=;
 b=l40K1l6mZlJkECK/0nKVO4HxPiGY12kLq0Bg1D9IcyeiYCem8RzWDmk6BXCqLcGqv+EgHjigXPGdC3A8tcjp/rWpxv+ErnCbhop+Q/fkF/1sZ6kKaljZWNqxZUn4wFikRm5qa21GblILobzm6f5HFTkPhjryptm6tZwtQlTdmgo=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3208.eurprd04.prod.outlook.com (2603:10a6:6:3::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.30; Mon, 29 Mar 2021 09:12:19 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 09:12:19 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: FEC unbind/bind feature
Thread-Topic: FEC unbind/bind feature
Thread-Index: AdchTA4mhHE+X6FhQBmQJxJLMagesAAKJ/aAACgNBSAAAM4PMAAJDS6AAI9NeiA=
Date:   Mon, 29 Mar 2021 09:12:18 +0000
Message-ID: <DB8PR04MB67958AEAE20C973F9C2B7985E67E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <DB8PR04MB6795E5896375A9A9FED55A84E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YFyF0dEgjN562aT8@lunn.ch>
 <DB8PR04MB679514359C626505E956981BE6619@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <DB8PR04MB67952CC10ADC4A656963D871E6619@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YF3UvaMpaXcFxU5y@lunn.ch>
In-Reply-To: <YF3UvaMpaXcFxU5y@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 740798f9-aed0-4766-6d5d-08d8f292c104
x-ms-traffictypediagnostic: DB6PR04MB3208:
x-microsoft-antispam-prvs: <DB6PR04MB3208FB67D3BD44C2D169E1EFE67E9@DB6PR04MB3208.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RmAmR+XpoZV1UVpP6N2ucGsM76J+NYoo2ya+6ZbTK5LUAiS1XXlG6oRpkXuyhcUr/XDJQCMxvhB8Pe97g/AGJ/w2xiIihbMBiV9tLEiTw/R7LgOukuxSNSwXn277J/zJhWjZAWmXuMlS4B16x+UK9osPQihmSPzQ2mhA01lQx38MygYcjNdcxODhmD5qw8pARe/0FzerTQIT86TcZlLPMmV61NMxsLnjN/eG+V4OA/wwECmsV70yoxmKnDgyO28IQgvau5ZGvbfGFOjaxURyi+c3C4Hc6Mer8OSKuub86YvGDgr8ux6Dk6q499c0XOO21jdFCX8uLtGYo8U/Mmmw6DAOiNPgjcOM1nrgd7/jNf2PtY2Oj7s7kiyeNOoOuU/Bg6E+UBKlDEZloC1H8BWqWYgs1I2iNhECMdLWwVOY8JdWNnbN10ZymS+W8Px3Ji1KAvnO1TGLEO+y1QLFHsOE4pWXAGKn5jdypsR0dPaOnVtVJLl2u1KCEuwxUvkDu5X1PB5X8v8Pp+oETEUQbytzeAqxi4hQknfotOX3dLEafkX86kC4PlH69JAK75WxZnfb5toAWrFpGeBFultuUjpPSsdcZN6r00SnY2HU8U1gGdHt0m5nyIuLsbxELh0jWyxMD/fU/z1a79uUTtlorjBsZVhAaHBrUIwJ6Hbi+B8Pmck=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(3480700007)(38100700001)(7696005)(316002)(2906002)(66946007)(71200400001)(53546011)(6506007)(86362001)(54906003)(478600001)(76116006)(52536014)(66446008)(64756008)(5660300002)(66556008)(66476007)(6916009)(186003)(8676002)(9686003)(4326008)(26005)(83380400001)(8936002)(33656002)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UndHcEtnWWdiRG01T3h5SVFVNGJOeDl3cVVaY2JwZnFnU3BsZFdQZjVJYVhq?=
 =?utf-8?B?QzFZOGRxemJjWFZGbVdJUkpXN005YmpsejVqS3pHMW9JcE9QTm80NVdoSGhv?=
 =?utf-8?B?UE1OazVYc2hVaVh1Q1pnRTFHZUR4ZGwwUnlFd3h4VGt1WXJ6YUlab3k0V29Y?=
 =?utf-8?B?a1BTMjhDZkV2SzVzZ1lNeWZuQmlRd0VsK3d6UHlwblQ2R0dWYmhYMnV1RG1N?=
 =?utf-8?B?NG11TjNBOUc3WkhwcnRaalBjUEx5dHo2RTRlUnFhUG1renRTM0tjZUlQNHdu?=
 =?utf-8?B?REZRMkZMdUx2QXV6S1E5SGJxT0tLcytKQ2I4SlBpVDdERlFrWTVnNnVEUGMr?=
 =?utf-8?B?emtISWdmME5pY0FPbFc2WGdLVzRMZDh1czBnR2NZRDNtcXBkSUJDOSt1ZU1y?=
 =?utf-8?B?REwyank0V0U3TkNQTk1lc3NhRU5sb1NvUWY1bHNuelNLQ24xMElGTkJ6MDBE?=
 =?utf-8?B?WE1pOTNyTTk5UDg2b0JRZGExS3djMFhjYXRETGNadmhHYzlPNVE3ZzczVGVD?=
 =?utf-8?B?TDkrK1h2dVpSajkvcUFjUWhpMk92aWV6UUluWWVISENlSURIaEdSYlhheFNX?=
 =?utf-8?B?OVprYUgwcEt4T0hQZXBoVC9WQmd1RUxtUGxOTDRSSGhtZjNFTU5HWWIrdFVN?=
 =?utf-8?B?WWRuZTljS1p5ajFKL1VVa1ZjVmZWS05TQjRUdDJvRU5hNVlTZ1BtMVlLdjVK?=
 =?utf-8?B?N2NFUFJiYk9ZWitrMmFnSE81OWZxQ3RsNXFreTA2Z1lZdHJadS9ZVXZnWjhz?=
 =?utf-8?B?emExSDRobllNUUg4TWRDa0NSV3JjQXFRUXhpQUhUalNiN0FPeGszcWl4TUJI?=
 =?utf-8?B?WGZkbDlQQ2tLNlQrTkhzamVtZ1RwZk9mdmF3SFh5VU92SmhXVnc1NUNxOEZh?=
 =?utf-8?B?bTNSQTROQmVvMlVxaEhOenpaU20zeFI3NVNGbGRESzBicnhMeFNYSmwzRU9a?=
 =?utf-8?B?MXBvemcxSjhXK2t2V3FQVitpV3o1ODVnSG5PVEgyMGdCRk8vemlTUitYVjV2?=
 =?utf-8?B?MFdnT0tCQ1lJNFE5UUN5VUZkdUpXbW96TFMrODBlUWFpQ3RGY2xsR0ZtL1cv?=
 =?utf-8?B?cDZhYWcrTTFJY0R0a0JhRFFaVW5aM0xJM2dwWkRPQ2h5MkJOZmRBNjUzbjNy?=
 =?utf-8?B?QmVHNUtzVWM2TVFQdmdyUytiM1I3WWRpYkdLSkp2aUcvbk52UERPNkNaaGZW?=
 =?utf-8?B?eFBjOEUxOGtpQ2ZabnNpYXFXZTVnUVNrZ0dXTkZDc1gzYkZ4UzFXbFJnNmJV?=
 =?utf-8?B?VmszQzZ3R3AvYjdDVUV1UTFva2s3R1BFZkNMQjNPUlVsc0gvMkx3TDBnRk5l?=
 =?utf-8?B?RFJSNCtvZFRzM1RDZzRHWkZXQ1FWd0FWYjFQSytYTTBlNkdRQUNhV29LdWtQ?=
 =?utf-8?B?SWtiYUNKdkxYUnFZek5GdDA5dExOak9jVEprSklTWHFPOXdSRW9DRXRCRHRa?=
 =?utf-8?B?WUd1d1ZPNHV2NkZJRVhHOVFaNmlyN2orRmNwbks3S2JIQkE5V3J2QzJjeXBz?=
 =?utf-8?B?aDhOMWVsUjVpYld5UVRjOE9VbWJYZSs5Yk95eXBKSHJKK2tsRG1VWUh2aHdC?=
 =?utf-8?B?NWVTa29sRnNNTjdpWDE3WFVNTEFlTXlpbFRDNDNGWjlHOG1Pb3BndDFMTlJs?=
 =?utf-8?B?cjQzM3BwbnZDZFZzbG5nK2oweXBlbkNNbXNOQnMzRmRDWC82V0lpbDNzcEZS?=
 =?utf-8?B?ZjdUeDBFbDhIeVltcXc2SGVIQ29PaWp6T0F1ZlZ6NWFjemdvOE9rRlFVQ0gw?=
 =?utf-8?Q?HWoCgy25Nook5CWTPJ+rYDqtvEnrHamzI/xjr5H?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 740798f9-aed0-4766-6d5d-08d8f292c104
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2021 09:12:18.9727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cdIQaitg74Y10ZZy9MJqzMOcxrLWAbzM8mcow3vcroSlroikePtJ2YWNVMBnPxY5rG0rfszH6wBnT1yJcBYxjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3208
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFuZHJldyBMdW5uIDxhbmRy
ZXdAbHVubi5jaD4NCj4gU2VudDogMjAyMeW5tDPmnIgyNuaXpSAyMDozNA0KPiBUbzogSm9ha2lt
IFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IEZsb3JpYW4gRmFpbmVsbGkg
PGYuZmFpbmVsbGlAZ21haWwuY29tPjsgaGthbGx3ZWl0MUBnbWFpbC5jb207DQo+IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IEZFQyB1bmJpbmQvYmluZCBmZWF0dXJlDQo+
IA0KPiA+IE9uZSBtb3JlIGFkZCwgeWVzLCBJIGFtIGxvb2tpbmcgdGhlIGRyaXZlcnMvbmV0L21k
aW8sIGl0IGlzIGJldHRlciB0bw0KPiBpbXBsZW1lbnQgc3RhbmRhbG9uZSBNRElPIGRyaXZlciB3
aGVuIHdyaXRpbmcgdGhlIE1BQyBkcml2ZXIgYXQgdGhlDQo+IGJlZ2lubmluZy4NCj4gPiBOb3cg
aWYgSSBhYnN0cmFjdCBNRElPIGRyaXZlciBmcm9tIEZFQyBkcml2ZXIsIGR0IGJpbmRpbmdzIHdv
dWxkIGNoYW5nZSwgaXQNCj4gd2lsbCBicmVhayBhbGwgZXhpc3RpbmcgaW1wbGVtZW50YXRpb25z
IGluIHRoZSBrZXJuZWwgYmFzZWQgb24gRkVDIGRyaXZlciwgbGV0DQo+IHRoZW0gY2FuJ3Qgd29y
ay4NCj4gPiBIb3cgdG8gY29tcGF0aWJsZSB0aGUgbGVnYWN5IGR0IGJpbmRpbmdzPyBJIGhhdmUg
bm8gaWRlYSBub3cuIEF0IHRoZSBzYW1lDQo+IHRpbWUsIEkgYWxzbyBmZWVsIHRoYXQgaXQgc2Vl
bXMgbm90IG5lY2Vzc2FyeSB0byByZXdyaXRlIGl0Lg0KPiANCj4gSSBoYXZlIGEgcmVhc29uYWJs
ZSB1bmRlcnN0YW5kaW5nIG9mIHRoZSBGRUMgTURJTyBkcml2ZXIuIEkgaGF2ZSBicm9rZW4gaXQg
YQ0KPiBmZXcgdGltZXMgOi0pDQo+IA0KPiBJdCBpcyBnb2luZyB0byBiZSBoYXJkIHRvIG1ha2Ug
aXQgYW4gaW5kZXBlbmRlbnQgZHJpdmVyLCBiZWNhdXNlIGl0IG5lZWRzIGFjY2Vzcw0KPiB0byB0
aGUgaW50ZXJydXB0IGZsYWdzIGFuZCB0aGUgY2xvY2tzIGZvciBwb3dlciBzYXZpbmcuIEZyb20g
YSBoYXJkd2FyZQ0KPiBwZXJzcGVjdGl2ZSwgaXQgaXMgbm90IGFuIGluZGVwZW5kZW50IGhhcmR3
YXJlIGJsb2NrLCBpdCBpcyBpbnRlZ3JhdGVkIGludG8gdGhlDQo+IE1BQy4NCg0KQWdyZWUg8J+Y
ig0KDQpGb3IgYW5vdGhlciBjdXJpb3NpdHksIGR1YWwgRkVDIGluc3RhbmNlcyBzaGFyZSBvbmUg
TURJTyBidXMsIHdlIGNhbiBzdWNjZXNzZnVsbHkgdW5iaW5kIHRoZW0gb25lIGJ5IG9uZS4gQnV0
IGlmIHVzZXJzIGZpcnN0IHVuYmluZCBGRUMgd2hpY2ggYXR0YWNoZWQgTURJTyBidXMsIGtlcm5l
bCB3b3VsZCBoYXZlIGEgZHVtcCBvciBjcmFzaCwgaXQgc2VlbXMgbm90IGdvb2QuDQpTbyBJIGxv
b2sgYXQgdGhlIGNvZGUsIHdhbnQgdG8gZmluZCBhIHdheSB0byByZWplY3QgdW5iaW5kIHRoaXMg
RkVDIGZpcnN0LCB0aGVuIHByaW50IGEgbG9nLCBzb21ldGhpbmcgbGlrZSAib3RoZXIgRkVDIGlu
c3RhbmNlcyBkZXBlbmQgb24gTURJTyBidXMgb2YgdGhpcyBGRUMsIHNvIGNhbid0IHVuYmluZCBp
dCBub3ciLiBJdCBzZWVtcyBubyB3YXkgdG8gZG8gdGhpcyBhdCBGRUMgZHJpdmVyIHJlbW92ZSBw
YXRoIChmZWNfZHJ2X3JlbW92ZSkuIElmIHlvdSBoYXZlIHNvbWUgaWRlYSwgaGFwcHkgc2hhcmUg
d2l0aCBtZS4gVGhhbmtzLg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gWERQIHBy
b2JhYmx5IGlzIHlvdXIgZWFzaWVyIHBhdGguDQo+IA0KPiAgICAgQW5kcmV3DQo=
