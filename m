Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7B7365190
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 06:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhDTEmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 00:42:06 -0400
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:64139
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229507AbhDTEmF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 00:42:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DV4KikpvFZRf+VYR9bp9RpAj5GwNfOOzCcOw3b4zjfmiML0UETKqCwoARqqZKYDE7oqPdw+wmJrrgFWCDvm1izH9vkQEeT4RTsBTfmDUnf/hnPQcKTKrt978HAzlFhSzReHAPoRD9z1usGR24zeeF5vxl6dkVXqP10d16iPGv+JAZQ+UnwAEuUOqBYton2qTxSKaoHEfZiA1JrrmzRbiJTdoBRqTvF4LO/aySnZLNayB+B52bzRE+b5bGnIc2tGDrzvmg1ja9X1hIBUV2nJag65LQmzsKW1nZ7pIyTLv2OoP03laVGxiqBEvYB2WWIvIZV0ZZjIrkZYyPnFZFTzUZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+M9uySCk+KyGwiDzJ/Ztn/u5IiYgYhfjUWf156FUiik=;
 b=gX2KRP5Zeiek1927cqzEXjUHj4CmQ04h7jHn7jonhVuZG9AC71dkiRCc1Rs7s+0PzkqTXsnldZFmi5M02+GN9Fi77J6xThNOxkWDGFP1HXzmGeVfUbbMp/GkzfbKojZUtvh51kV6rxeCj3VWD8WYe+GUBG+hJnIc2kIKNJnzN1awIstkV2ejSNNk2kQcY0ExItCZFQtmoTat2gng7iJJebL4+ZcW5ODhnBRObeNkXxaAaCOnao9tKafe1BZ/sYrwl8zU1WxEHGaNW2/VAxvFTagGbMDJaQzzfJUKVnOODsbTV0GEwM6geAabqOJfzzGefLeIOYauWhfQlCJ+oHoOZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+M9uySCk+KyGwiDzJ/Ztn/u5IiYgYhfjUWf156FUiik=;
 b=sCz4zSrjU96ChUmvtW3LK+M6JpqKIu3Oj3vdYS9qiimRte0bAgBLXItrfJF9VQYJEUR1PUIeb9SF5HqQybcvwMXD1KGbnROAlYMYySQFVp2A+Cc7qqCp0zLbYB9Yfh5cxKntLriT4G5IWQJRWgd3rDwnpRorAKfRajo2hJXMtOs=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM7PR04MB6904.eurprd04.prod.outlook.com (2603:10a6:20b:106::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Tue, 20 Apr
 2021 04:41:32 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777%3]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 04:41:32 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: RE: [net-next] enetc: fix locking for one-step timestamping packet
 transfer
Thread-Topic: [net-next] enetc: fix locking for one-step timestamping packet
 transfer
Thread-Index: AQHXMBbxUAh74ZmQ7kaFEfOTMU7Q+qq83dfA
Date:   Tue, 20 Apr 2021 04:41:32 +0000
Message-ID: <AM7PR04MB68858E23D828E7C24581EE3AF8489@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20210413034817.8924-1-yangbo.lu@nxp.com>
In-Reply-To: <20210413034817.8924-1-yangbo.lu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bece01ba-a8bf-4b89-1bb0-08d903b692b1
x-ms-traffictypediagnostic: AM7PR04MB6904:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB6904327140E882199F825075F8489@AM7PR04MB6904.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5497a14iVNjhBkYHb9YkX4V9Vq8GnuJM8yEyIBI5Mz4u+Kg9eLp1JLM9ltteGD9XbwYGaO+GNmKrx2xD75+IxXV/lNpOVYn5eN7v6id6NlxikazRvxIIb4wcOnLxuySPZSoYVRWUNKeTVkjZDlTc1yoFjFjVwfg6Ri/HgqV+k4FJqtSOV9GewS3Qhah+xBfSkhTBmgRqgVnRV1mSaixV57hQL4fmT9oiJKRR60wfiQRdcXTh90RDfbZg6t3knSJYJ+/YamR8DtcYR9vk5G1oUGmVorHe8+KFei4LkRDpnHnjI/WKfedyxe4Dv2eF5Gppr1bjsr6LuPgQUPp/EMaaDuCwb1RrOrKkuskKCkIikhxsbwdgz86Nu8gTAPOLUojijd/3d7wtS0UumlAmxn0lI7no5jqQbOXsVUig/hQmo10UOn1UWUIGGAPub8FXPJj1h9bfu+et/f2DdWHdSDigYmJ9hJTGFFgf0yltARMrVNKlptHwpkMPh3urgstQoh+wQb4nX235fVgHRQXY1aoG1kQoqZXmnA+LdJ1qfnr2JEJXONxHWAgAuT7dxkyGNZmlJO0A7XnL3AB4NipMkX4y3HLSlJZ8jtERS1wf3VTs+U4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(64756008)(66476007)(71200400001)(66446008)(66556008)(478600001)(5660300002)(38100700002)(66946007)(6916009)(122000001)(76116006)(7696005)(6506007)(9686003)(4326008)(8936002)(52536014)(8676002)(53546011)(2906002)(26005)(83380400001)(33656002)(86362001)(186003)(54906003)(316002)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?RnBGU0dqT1hOWDJ3UzVTaXJoWjVVVmU4WjZ4b0RZT0Z4ZWExLzlmRE1PeVN6?=
 =?gb2312?B?dlM4MWV4eUpTS050bFU3WVlkMHhjR3ZqZHh6akhjaVhNNlJlMnMzbjhFdG5Z?=
 =?gb2312?B?NmFYcDNqMUVkRDV0TVFyaEkzKzFTK2h6QzAvVG5ERkRhUHFacDk3MEpsZm0w?=
 =?gb2312?B?Q0wvYkluZDJOL0xZQWI4czFPekQrSG0rakNLU0JUZ3Vla3FwUkFWZXgya2M0?=
 =?gb2312?B?bTczdktsZUhDSWZES285NHhDWnRCenZLWmtOSnRlUkZGbHl4ZzZMT2hMU1N1?=
 =?gb2312?B?UnJBZ0JRd2NjeW5JblJUcEpqajlGKzY4T0xkUlpkajhYalhiSmNCcmNWZVMv?=
 =?gb2312?B?Q1hFYmFOellkR1AvVitrWFlseHpjYzgrNnh2UVdsTWRsVVM4RGkyNTdaRVUy?=
 =?gb2312?B?VC9pWXRCbXFHMC9xMlQ1S3Q2NktpQk5HL2tKQUc0bmxRUThLRmwzdlJCREk0?=
 =?gb2312?B?bVFvZS85dTI2QkpucGdSN0huZG5LQ0ZnMHhyR0dlSERlMTBrZjFGNkxJUjRI?=
 =?gb2312?B?dmkvYzhIWVlBaFRxRVpzdVkrenk0MG0vempiRHhmSWk3VysvZUVFa0FpcVNl?=
 =?gb2312?B?LzhNWTRkVnZvOGlEL25rQ1FSZVBXQkV5UTUrTzVhTldOTzg2aDBJdi9IRUxT?=
 =?gb2312?B?c3RoNHhUKzIzZVFkWVJXZi9KMU9abzFjREMzdjgwSEtDd2g3Ylpnb3lPK0xH?=
 =?gb2312?B?RUdlRnhDVnNURVJSWDJzU1FqZGlPcUM1V3lXTnkrZ09SZFg5OGR5clBFWTY1?=
 =?gb2312?B?V3o4T254MGlzblkrTy9hcEpSczc0aDlabzdqME5JUjFxOWR3MFRFbXhTUy9D?=
 =?gb2312?B?cDYwbnNpak1iTG1LRmZXTSswWit1N0hOejk4K1l4T0NGeFRYUDNVTGFqK3Rx?=
 =?gb2312?B?Z0xWK2lmRGdkNzNuM3lRY2M4MThESnRwbitVVFc1TThqdGc3NFMwZmdHdmkx?=
 =?gb2312?B?elZ2a3BnUlNJdmVnTkU1NW5YdjcvVVhyOXNTY0EvekM0M2syVTdiZVQrSW9k?=
 =?gb2312?B?K3F5dFU5TUpUUEg1YnNZU0tJbGNUMXVUMjBVVWtRWllOZzlXaWhhNzlBTlJF?=
 =?gb2312?B?bkwrTE4zWENyMzY0RWZ4b29kWGdxSzl0Zk04eElDbEhFdTRkTkdxaEpqMXJt?=
 =?gb2312?B?djZvNkRySXF5RWJ0dzB3UHJSeFBjMDNnQVlXTUhCenplMWZkSHJ4UE9JYTV2?=
 =?gb2312?B?SkdYeGRzZkQ5K3BKbzJ1ekhtOS9IMllaSEdMdFM3SFo2R0dJTHJ6cTBra3hC?=
 =?gb2312?B?OEJQcStpamsrUXFUVlRzanc2ZGdFVzBmZyszQjZHQ0I0NXpSSy9UTTc4NTRn?=
 =?gb2312?B?Uzc4eU1tMGhveUwzOUp1Yk1tMnIwMkdIMjdWRGxNWkNMYnI2bjBLSGgxcjk5?=
 =?gb2312?B?NXBTK0djTWNKRXVWY1prSFo3NStwK2p0UTNIcnNIaVJYT2xLc1Y1V0JLRzM0?=
 =?gb2312?B?ZDZVaG5VZzdzMm11SFh4UU9kMEVIR1dPNDVGNERpOWtiVUNPOFdWUFdvQlpm?=
 =?gb2312?B?Uk1CdWE2ZFFJakIwSWxVQUFQYWpxMkd3UzdqNjQvVFN2SWowNkFzY2lqZ2c0?=
 =?gb2312?B?cWxPaWdudDhJbjdLUUU5Yk4vMzdYaTU4UklIekcxenRDbS8rNVBtdE1YTERV?=
 =?gb2312?B?bnNIT1NhUFZlSnlwQnFTSlFldldwVkdtRkxWRUwycW1xM3NKWDBnWlFnQ2ZN?=
 =?gb2312?B?RFZWNld2L21XUCtZcmlmVTdtenB5eGh6cWF0U2V1RWVXUWovOFVub0o1cDN1?=
 =?gb2312?Q?BhWKilcIv4F4sPYwUBSVIIEDQwNOrmab+L8dEYB?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6885.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bece01ba-a8bf-4b89-1bb0-08d903b692b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 04:41:32.8313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MejGVrn49HSjj5FrUZe+PXOlf4Cpqb3EFeTr7JDRjMa2WkZRPl+4vQX/pq/n9rD/Qfi5V7bfERDVfyJY9B5smQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6904
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCkkgdGhpbmsgdGhpcyBwYXRjaCB3YXMgcmV2aWV3ZWQgYW5kIG5vIG9iamVjdGlvbiBu
b3csIHJpZ2h0PyAoSSBzZWUgc3RhdHVzIGlzICIgQ2hhbmdlcyBSZXF1ZXN0ZWQgIi4pDQpUaGFu
a3MuDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogWWFuZ2JvIEx1IDx5
YW5nYm8ubHVAbnhwLmNvbT4NCj4gU2VudDogMjAyMcTqNNTCMTPI1SAxMTo0OA0KPiBUbzogbmV0
ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBDYzogWS5iLiBMdSA8eWFuZ2JvLmx1QG54cC5jb20+OyBE
YXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsNCj4gUmljaGFyZCBDb2NocmFu
IDxyaWNoYXJkY29jaHJhbkBnbWFpbC5jb20+OyBDbGF1ZGl1IE1hbm9pbA0KPiA8Y2xhdWRpdS5t
YW5vaWxAbnhwLmNvbT47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBWbGFkaW1p
cg0KPiBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPjsgUnVzc2VsbCBLaW5nIDxsaW51
eEBhcm1saW51eC5vcmcudWs+DQo+IFN1YmplY3Q6IFtuZXQtbmV4dF0gZW5ldGM6IGZpeCBsb2Nr
aW5nIGZvciBvbmUtc3RlcCB0aW1lc3RhbXBpbmcgcGFja2V0IHRyYW5zZmVyDQo+IA0KPiBUaGUg
cHJldmlvdXMgcGF0Y2ggdG8gc3VwcG9ydCBQVFAgU3luYyBwYWNrZXQgb25lLXN0ZXAgdGltZXN0
YW1waW5nDQo+IGRlc2NyaWJlZCBvbmUtc3RlcCB0aW1lc3RhbXBpbmcgcGFja2V0IGhhbmRsaW5n
IGxvZ2ljIGFzIGJlbG93IGluIGNvbW1pdA0KPiBtZXNzYWdlOg0KPiANCj4gLSBUcmFzbWl0IHBh
Y2tldCBpbW1lZGlhdGVseSBpZiBubyBvdGhlciBvbmUgaW4gdHJhbnNmZXIsIG9yIHF1ZXVlIHRv
DQo+ICAgc2tiIHF1ZXVlIGlmIHRoZXJlIGlzIGFscmVhZHkgb25lIGluIHRyYW5zZmVyLg0KPiAg
IFRoZSB0ZXN0X2FuZF9zZXRfYml0X2xvY2soKSBpcyB1c2VkIGhlcmUgdG8gbG9jayBhbmQgY2hl
Y2sgc3RhdGUuDQo+IC0gU3RhcnQgYSB3b3JrIHdoZW4gY29tcGxldGUgdHJhbnNmZXIgb24gaGFy
ZHdhcmUsIHRvIHJlbGVhc2UgdGhlIGJpdA0KPiAgIGxvY2sgYW5kIHRvIHNlbmQgb25lIHNrYiBp
biBza2IgcXVldWUgaWYgaGFzLg0KPiANCj4gVGhlcmUgd2FzIG5vdCBwcm9ibGVtIG9mIHRoZSBk
ZXNjcmlwdGlvbiwgYnV0IHRoZXJlIHdhcyBhIG1pc3Rha2UgaW4NCj4gaW1wbGVtZW50YXRpb24u
IFRoZSBsb2NraW5nL3Rlc3RfYW5kX3NldF9iaXRfbG9jaygpIHNob3VsZCBiZSBwdXQgaW4NCj4g
ZW5ldGNfc3RhcnRfeG1pdCgpIHdoaWNoIG1heSBiZSBjYWxsZWQgYnkgd29ya2VyLCByYXRoZXIg
dGhhbiBpbiBlbmV0Y194bWl0KCkuDQo+IE90aGVyd2lzZSwgdGhlIHdvcmtlciBjYWxsaW5nIGVu
ZXRjX3N0YXJ0X3htaXQoKSBhZnRlciBiaXQgbG9jayByZWxlYXNlZCBpcyBub3QNCj4gYWJsZSB0
byBsb2NrIGFnYWluIGZvciB0cmFuc2Zlci4NCj4gDQo+IEZpeGVzOiA3Mjk0MzgwYzUyMTEgKCJl
bmV0Yzogc3VwcG9ydCBQVFAgU3luYyBwYWNrZXQgb25lLXN0ZXANCj4gdGltZXN0YW1waW5nIikN
Cj4gU2lnbmVkLW9mZi1ieTogWWFuZ2JvIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NClsuLi5dDQoN
Cg==
