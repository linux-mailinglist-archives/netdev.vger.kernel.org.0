Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065A736BE3A
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 06:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhD0EOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 00:14:21 -0400
Received: from mail-db8eur05on2047.outbound.protection.outlook.com ([40.107.20.47]:22753
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229526AbhD0EOU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 00:14:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erLlCDmbEObEBX5L08U8gtYTonzIfOBisGYfDtgpZYQGuPNApWzRqZ6htSGRhHnHqSVUOdGaKoYj0Zacb0OA47dOG9dKJeV2KvMBf7Jl9Lw5uL2Boyjmh8/Jj9UTwumL6PbyDRkGFP1egQe+K3qetyXl9Zvrl/4HxCSJtr3BxaFflqZRxXEoAJ6Y0X0RzSb/4uWLRk3Us9LNN+RTnbaJpcl6Wamh8GzOUlDMwZy6tqHUgKq67K1q7U8yDGU8YAW9YBBsN0tTw2pHtda6DbFqVTqfoZ5OXFD7d9250/NKmF3+TaSku9TfVAZxqUWJFnDD47j5Z0AweoGBpu3Jc+Theg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=isfOKK35SWabvE7FzXNZnSala3Mk2ZDnIJAu949g898=;
 b=j1PRdxorLKCUseXTIyK0mshMOFA7OUoGqfDBLxMqdIVLU/4R5UkU/elIGwC410ltTrW3Xblw5LhMfCK8OV/DwIdQ9FMY5GWIKL2RuRIzU61y1vmrPX34SHFjqKgoL8u8BqCPHK3446mOpBjQg1c5H6TwmtsYN9JR/i2n39JoTdBrR7CqOq9Q4z8MOy+iOd3EyX1Cx9JHupvRFtv0V3x5Pq7e4d0KoWzVSYRjEs1D4JP6M+C74xomyasF1CKeL1VbF34TgX8K1PZz2eeiNtV0cUiIgyQMDxMdQp7wu4cGOeg2Lnf8vNRBdMGeBiMhEAlG7HThBYnKkxMezUoLDUu+qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=isfOKK35SWabvE7FzXNZnSala3Mk2ZDnIJAu949g898=;
 b=FtUWwTENm24eXOSs/phde+W4u4CmZjt0aYrH5Z5/BHON66marxDxCpEaq0ovD0S/GvJG1K2DJgpvZz/XmyddDsNV8HcgGMTrhoh1KwIvLcxJJwnaWqGAyuNN3xSsp3ta2n0PSgPmARGik99wFN3op6lNJZJDJcXTLbd5pln2yEQ=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM6PR04MB5191.eurprd04.prod.outlook.com (2603:10a6:20b:1::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Tue, 27 Apr
 2021 04:13:36 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777%3]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 04:13:36 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [net-next, v2, 3/7] net: dsa: free skb->cb usage in core driver
Thread-Topic: [net-next, v2, 3/7] net: dsa: free skb->cb usage in core driver
Thread-Index: AQHXOn8Jr4d6SG7MRkyMg7TxAYZcc6rHG5mAgACmd8A=
Date:   Tue, 27 Apr 2021 04:13:36 +0000
Message-ID: <AM7PR04MB6885CBAB63363CA93E50A207F8419@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20210426093802.38652-1-yangbo.lu@nxp.com>
 <20210426093802.38652-4-yangbo.lu@nxp.com>
 <20210426181637.2rneohfxkrvwctf2@skbuf>
In-Reply-To: <20210426181637.2rneohfxkrvwctf2@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b594d9bb-baa4-41ac-d766-08d90932d431
x-ms-traffictypediagnostic: AM6PR04MB5191:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB5191D97CBC4F516BB2C8ED76F8419@AM6PR04MB5191.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b6/V2WeMMjff78djcD+/LhTkE/7JHTQBe82D60MxNrMh5PdzJ0c6RIEibwzUx7JHlOQBtQZOrnO0R0v7bsKy4S7V3fB8ZQr38zVQRw79O5PTlrItzpvqYkf0rCRwbvkvw5SkvsdbMwqHWW782XVYkeSk92GO/ylesG+rtZjXTTjI5fvDHBpFGN9ubzYAewarXbwe8atnvxPV3kK3IvBSZIujYHhYRH7Ypi2JnEztazcxoAXusCesPfJLXe/g4+LwCxfwg4t8GHaqIYaiVdykjqSOwjsi4SFgffpX0bPN0EgwXRSzETa9KTQY/q07xEJc2OxhARF9+FwbXqv7neq2yTUxHQ0S8MU6BwlyOs804OAhMhraLXWolPdYSJ8nd5aSyqYw4Rm367YgM/NuxgdTr+SS0l4GAFHYPVQBJmKbkfL9JVaAumc0lb+/5DCqsW/aevKFhgL9gThU5AW6kcwWn3IWUQYlgPiuQQ7t6ow7xHBJq3bRzxzyM9dqaewdE3ScCnWnzsU4YvoTmSHh0YODLVL2i1BUDqdEpNx/zj4Mo7WPIUSACzsU1UeuxPSYgCWw6TQF3n2g7dxhzu5rHMBKUiVrzqhqRwW20IqzYYeV3Hs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(66476007)(64756008)(66556008)(83380400001)(26005)(66946007)(76116006)(33656002)(54906003)(4326008)(86362001)(110136005)(122000001)(38100700002)(8936002)(55016002)(2906002)(186003)(5660300002)(8676002)(7416002)(52536014)(6506007)(498600001)(71200400001)(7696005)(53546011)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?U1NReFY1UGpCVER6WFNaMEt1dkMrdHViT3JqYm1EbHdQc254TVhudUhwKytq?=
 =?utf-8?B?MFI2UTRtY2JPTnlrb1Nnc0lnb0FOMDNKd1l0MExwZGVEcUpLWStRSEdQbFZO?=
 =?utf-8?B?ZThDbWk1cjI3aDFDUHZlZVdBcnp0ekZPNVdibWpnRVlWNmFrMXE2dlkrTG4v?=
 =?utf-8?B?S0JBVm5yQ3duUTM2Z3g1bnF1U1pwMHZwNHNqVi8xQ2tMeEgvN0ltQ1MvRW4y?=
 =?utf-8?B?Y2hkbndOVVc5MURWM0JIeGZ0MzFxMk5vTGxLZW8wYjc3STdSeEhWMGdNL283?=
 =?utf-8?B?Q0hkeHowdnBhL3pGLzU3L3N2dzJaNU5rZ0tsSzJ6MkNSaTZreHpKajFtSEk0?=
 =?utf-8?B?Y3dzNFU1THkvRmpTb0VJakI0dk5tTElpcXd3Ykh1ajJvN3RQZGhPUm15dnhq?=
 =?utf-8?B?Z014RE50V2FMdFBVeTJsZGhUUHpvRlc3TmNTOVZnLzhiS3hNblZJV1hKK1hN?=
 =?utf-8?B?NER5SnNrcDZKUWZUaENrSVNWK2RrUnl1VGtFTWZBMWh3akx0VFBveWx3YVRG?=
 =?utf-8?B?L2Rid29yTG5JY3o3cW5Gc1JkSG1ndVRvTVF1OE9jamRLbG9FbTFVTUxrVEJ5?=
 =?utf-8?B?a05Cb2pzMHNZVEhUOUJjNlYrT3ZHVS94SEwveVdtc0JPV09KS3g5MWNRbDVY?=
 =?utf-8?B?aHlidzlBNmVMeTZld2FvanlDcDdmUDNDMmk5emtRN1Rxc01TWXlDVDNlZng4?=
 =?utf-8?B?aXJVTlo4OWZINXo1MGh1Z2RwY2w0Y1QrazNEMnJKVEJ4cUk3c3NDMkc4MmNq?=
 =?utf-8?B?QlZiWC9yVFFmSmlxMVdaTGRxNGZTWkpDQnhNUUVOWU9Kb3psWmQ3K3BFcHA0?=
 =?utf-8?B?dEV4SUxKS3ZBQzJRQlFBbkdCNDhEZjhkcUNQazdNVTdDQytDTUFYN3hmdnRk?=
 =?utf-8?B?S1NpODFDTTBDbEVHRlUvcGlFdzMxMkNkRGVVaEE2WmZyR050YUE2L0ZiVkZp?=
 =?utf-8?B?WjgxSEp6cEcwRHlqczE2VGRZVU03TmhxaFFjS0ptNGh5bEVQVXBNR1RHSllV?=
 =?utf-8?B?alpyWFpoWnd4eEVWd2dWanVJZjcxa2hZTG4xNUlPcFVVeE43ME1XVGxTUUh6?=
 =?utf-8?B?WXloc1Y4QnpXZUo4ZGN3NXEwMHlLVXFtVWUzb25SaGhpTUFOZHovb2M5dTRi?=
 =?utf-8?B?d25ncTdpTTVNRy95V2FvM0pIOUdoYU1iYnc3ZUc2bkNuZmpzOG9LY3hZaFQ5?=
 =?utf-8?B?a0l5QWFtRFc1R21IdTRjdHpTZ09mamhtRFhhNGdhMi9nMTNHUTVWNDhmd1Zz?=
 =?utf-8?B?dDU1bjJxWFIvK2xYdmZrT3h3UUVEdGlsOHNMck5raHhBOGYyTWpBamptUXdT?=
 =?utf-8?B?Z3l2azN0YkJnVUxWMC9wd2kzbDhIcXlBUnhkQmR1bVFhdklJVWlUdWxRdGIr?=
 =?utf-8?B?dXZMY3Q4YkJhTXdZUU9YRVVVVUI0YW4wVkEyMm5PemVJRjFpZlpkYlV0WSsw?=
 =?utf-8?B?eEFVd3Znc25UejJoVlFWL1RtdmdFeG42MnhNSitoNTlhMUc2S002dzhCdGNF?=
 =?utf-8?B?MHhuTFpqeFBpU2s1MmptVFFQRDBtQktwL3NPTktXUHRRdTZsUDNBU0lQc0Zk?=
 =?utf-8?B?dldmcGk0OUZncm1oNjhPdTZOSnliczJjQW52UEpmOG8rc3FPSU9sSWpIZlhW?=
 =?utf-8?B?aVhUR3hwV24xMHVVaUg2ZFFlZCtJOXhYcU4wZnU4dWNFSzB3Snc5VVZOSFgx?=
 =?utf-8?B?UlV5bm93WWxVc3F5c3J2OW1nSFc3RTU2VndMeGlPRFh3eGYzL1p0L3VId2FF?=
 =?utf-8?Q?Tp2O/AwId55F/43jouuef0YIcSBF1AaStqLHKaV?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6885.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b594d9bb-baa4-41ac-d766-08d90932d431
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2021 04:13:36.2109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ndYHGsVNL2piyLZY4apNu/7PYAVIQPom71dUTovwSLYgNL+cTtmoU8ClbLWwMNE/4yevPi7ylpUSOfv0azLD/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5191
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVmxhZGltaXIgT2x0ZWFu
IDxvbHRlYW52QGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMeW5tDTmnIgyN+aXpSAyOjE3DQo+IFRv
OiBZLmIuIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IFJpY2hhcmQgQ29jaHJhbiA8cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPjsNCj4gVmxhZGlt
aXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT47IERhdmlkIFMgLiBNaWxsZXINCj4g
PGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsg
Sm9uYXRoYW4gQ29yYmV0DQo+IDxjb3JiZXRAbHduLm5ldD47IEt1cnQgS2FuemVuYmFjaCA8a3Vy
dEBsaW51dHJvbml4LmRlPjsgQW5kcmV3IEx1bm4NCj4gPGFuZHJld0BsdW5uLmNoPjsgVml2aWVu
IERpZGVsb3QgPHZpdmllbi5kaWRlbG90QGdtYWlsLmNvbT47IEZsb3JpYW4NCj4gRmFpbmVsbGkg
PGYuZmFpbmVsbGlAZ21haWwuY29tPjsgQ2xhdWRpdSBNYW5vaWwgPGNsYXVkaXUubWFub2lsQG54
cC5jb20+Ow0KPiBBbGV4YW5kcmUgQmVsbG9uaSA8YWxleGFuZHJlLmJlbGxvbmlAYm9vdGxpbi5j
b20+Ow0KPiBVTkdMaW51eERyaXZlckBtaWNyb2NoaXAuY29tOyBsaW51eC1kb2NAdmdlci5rZXJu
ZWwub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBb
bmV0LW5leHQsIHYyLCAzLzddIG5ldDogZHNhOiBmcmVlIHNrYi0+Y2IgdXNhZ2UgaW4gY29yZSBk
cml2ZXINCj4gDQo+IE9uIE1vbiwgQXByIDI2LCAyMDIxIGF0IDA1OjM3OjU4UE0gKzA4MDAsIFlh
bmdibyBMdSB3cm90ZToNCj4gPiBGcmVlIHNrYi0+Y2IgdXNhZ2UgaW4gY29yZSBkcml2ZXIgYW5k
IGxldCBkZXZpY2UgZHJpdmVycyBkZWNpZGUgdG8gdXNlDQo+ID4gb3Igbm90LiBUaGUgcmVhc29u
IGhhdmluZyBhIERTQV9TS0JfQ0Ioc2tiKS0+Y2xvbmUgd2FzIGJlY2F1c2UNCj4gPiBkc2Ffc2ti
X3R4X3RpbWVzdGFtcCgpIHdoaWNoIG1heSBzZXQgdGhlIGNsb25lIHBvaW50ZXIgd2FzIGNhbGxl
ZA0KPiA+IGJlZm9yZSBwLT54bWl0KCkgd2hpY2ggd291bGQgdXNlIHRoZSBjbG9uZSBpZiBhbnks
IGFuZCB0aGUgZGV2aWNlDQo+ID4gZHJpdmVyIGhhcyBubyB3YXkgdG8gaW5pdGlhbGl6ZSB0aGUg
Y2xvbmUgcG9pbnRlci4NCj4gPg0KPiA+IEFsdGhvdWdoIGZvciBub3cgcHV0dGluZyBtZW1zZXQo
c2tiLT5jYiwgMCwgNDgpIGF0IGJlZ2lubmluZyBvZg0KPiA+IGRzYV9zbGF2ZV94bWl0KCkgYnkg
dGhpcyBwYXRjaCBpcyBub3QgdmVyeSBnb29kLCB0aGVyZSBpcyBzdGlsbCB3YXkgdG8NCj4gPiBp
bXByb3ZlIHRoaXMuIE90aGVyd2lzZSwgc29tZSBvdGhlciBuZXcgZmVhdHVyZXMsIGxpa2Ugb25l
LXN0ZXANCj4gPiB0aW1lc3RhbXAgd2hpY2ggbmVlZHMgYSBmbGFnIG9mIHNrYiBtYXJrZWQgaW4g
ZHNhX3NrYl90eF90aW1lc3RhbXAoKSwNCj4gPiBhbmQgaGFuZGxlcyBhcyBvbmUtc3RlcCB0aW1l
c3RhbXAgaW4gcC0+eG1pdCgpIHdpbGwgZmFjZSBzYW1lDQo+ID4gc2l0dWF0aW9uLg0KPiA+DQo+
ID4gU2lnbmVkLW9mZi1ieTogWWFuZ2JvIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gPiAtLS0N
Cj4gPiBDaGFuZ2VzIGZvciB2MjoNCj4gPiAJLSBBZGRlZCB0aGlzIHBhdGNoLg0KPiA+IC0tLQ0K
PiA+ICBkcml2ZXJzL25ldC9kc2Evb2NlbG90L2ZlbGl4LmMgICAgICAgICB8ICAxICsNCj4gPiAg
ZHJpdmVycy9uZXQvZHNhL3NqYTExMDUvc2phMTEwNV9tYWluLmMgfCAgMiArLQ0KPiA+IGRyaXZl
cnMvbmV0L2RzYS9zamExMTA1L3NqYTExMDVfcHRwLmMgIHwgIDQgKysrLQ0KPiA+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9tc2NjL29jZWxvdC5jICAgICB8ICA2ICsrKy0tLQ0KPiA+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9tc2NjL29jZWxvdF9uZXQuYyB8ICAyICstDQo+ID4gIGluY2x1ZGUvbGlu
dXgvZHNhL3NqYTExMDUuaCAgICAgICAgICAgIHwgIDMgKystDQo+ID4gIGluY2x1ZGUvbmV0L2Rz
YS5oICAgICAgICAgICAgICAgICAgICAgIHwgMTQgLS0tLS0tLS0tLS0tLS0NCj4gPiAgaW5jbHVk
ZS9zb2MvbXNjYy9vY2Vsb3QuaCAgICAgICAgICAgICAgfCAgOCArKysrKysrKw0KPiA+ICBuZXQv
ZHNhL3NsYXZlLmMgICAgICAgICAgICAgICAgICAgICAgICB8ICAzICstLQ0KPiA+ICBuZXQvZHNh
L3RhZ19vY2Vsb3QuYyAgICAgICAgICAgICAgICAgICB8ICA4ICsrKystLS0tDQo+ID4gIG5ldC9k
c2EvdGFnX29jZWxvdF84MDIxcS5jICAgICAgICAgICAgIHwgIDggKysrKy0tLS0NCj4gPiAgMTEg
ZmlsZXMgY2hhbmdlZCwgMjggaW5zZXJ0aW9ucygrKSwgMzEgZGVsZXRpb25zKC0pDQo+ID4NCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL29jZWxvdC9mZWxpeC5jDQo+ID4gYi9kcml2
ZXJzL25ldC9kc2Evb2NlbG90L2ZlbGl4LmMgaW5kZXggZDY3OWYwMjNkYzAwLi44OTgwZDU2ZWU3
OTMNCj4gPiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9kc2Evb2NlbG90L2ZlbGl4LmMN
Cj4gPiArKysgYi9kcml2ZXJzL25ldC9kc2Evb2NlbG90L2ZlbGl4LmMNCj4gPiBAQCAtMTQwMyw2
ICsxNDAzLDcgQEAgc3RhdGljIGJvb2wgZmVsaXhfdHh0c3RhbXAoc3RydWN0IGRzYV9zd2l0Y2gN
Cj4gPiAqZHMsIGludCBwb3J0LA0KPiA+DQo+ID4gIAlpZiAob2NlbG90LT5wdHAgJiYgb2NlbG90
X3BvcnQtPnB0cF9jbWQgPT0NCj4gSUZIX1JFV19PUF9UV09fU1RFUF9QVFApIHsNCj4gPiAgCQlv
Y2Vsb3RfcG9ydF9hZGRfdHh0c3RhbXBfc2tiKG9jZWxvdCwgcG9ydCwgY2xvbmUpOw0KPiA+ICsJ
CU9DRUxPVF9TS0JfQ0Ioc2tiKS0+Y2xvbmUgPSBjbG9uZTsNCj4gPiAgCQlyZXR1cm4gdHJ1ZTsN
Cj4gPiAgCX0NCj4gPg0KPiANCj4gVWgtb2gsIHRoaXMgcGF0Y2ggZmFpbHMgdG8gYnVpbGQ6DQo+
IA0KPiBJbiBmaWxlIGluY2x1ZGVkIGZyb20gLi9pbmNsdWRlL3NvYy9tc2NjL29jZWxvdF92Y2Fw
Lmg6OTowLA0KPiAgICAgICAgICAgICAgICAgIGZyb20gZHJpdmVycy9uZXQvZHNhL29jZWxvdC9m
ZWxpeC5jOjk6DQo+IGRyaXZlcnMvbmV0L2RzYS9vY2Vsb3QvZmVsaXguYzogSW4gZnVuY3Rpb24g
4oCYZmVsaXhfdHh0c3RhbXDigJk6DQo+IGRyaXZlcnMvbmV0L2RzYS9vY2Vsb3QvZmVsaXguYzox
NDA2OjE3OiBlcnJvcjog4oCYc2ti4oCZIHVuZGVjbGFyZWQgKGZpcnN0IHVzZSBpbg0KPiB0aGlz
IGZ1bmN0aW9uKQ0KPiAgICBPQ0VMT1RfU0tCX0NCKHNrYiktPmNsb25lID0gY2xvbmU7DQo+ICAg
ICAgICAgICAgICAgICAgXg0KPiAuL2luY2x1ZGUvc29jL21zY2Mvb2NlbG90Lmg6Njk4OjI5OiBu
b3RlOiBpbiBkZWZpbml0aW9uIG9mIG1hY3JvDQo+IOKAmE9DRUxPVF9TS0JfQ0LigJkNCj4gICAo
KHN0cnVjdCBvY2Vsb3Rfc2tiX2NiICopKChza2IpLT5jYikpDQo+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgXn5+DQo+IGRyaXZlcnMvbmV0L2RzYS9vY2Vsb3QvZmVsaXguYzoxNDA2OjE3
OiBub3RlOiBlYWNoIHVuZGVjbGFyZWQgaWRlbnRpZmllciBpcw0KPiByZXBvcnRlZCBvbmx5IG9u
Y2UgZm9yIGVhY2ggZnVuY3Rpb24gaXQgYXBwZWFycyBpbg0KPiAgICBPQ0VMT1RfU0tCX0NCKHNr
YiktPmNsb25lID0gY2xvbmU7DQo+ICAgICAgICAgICAgICAgICAgXg0KPiAuL2luY2x1ZGUvc29j
L21zY2Mvb2NlbG90Lmg6Njk4OjI5OiBub3RlOiBpbiBkZWZpbml0aW9uIG9mIG1hY3JvDQo+IOKA
mE9DRUxPVF9TS0JfQ0LigJkNCj4gICAoKHN0cnVjdCBvY2Vsb3Rfc2tiX2NiICopKChza2IpLT5j
YikpDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXn5+DQo+IA0KPiBJdCBkZXBlbmRz
IG9uIGNoYW5nZXMgbWFkZSBpbiBwYXRjaCAzLg0KDQpPaC4uIFRoYXQncyBhIHNlcXVlbmNlIHBy
b2JsZW0uDQpJIHN3aXRjaGVkIHBhdGNoICMzIGFuZCBwYXRjaCAjNCB3aXRoIHJlYmFzaW5nIHRv
IGZpeCB1cCBpbiB2MyB2ZXJzaW9uLg0KVGhhbmtzLg0K
