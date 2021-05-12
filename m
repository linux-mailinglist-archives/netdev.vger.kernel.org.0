Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8930937BC25
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 13:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhELL7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 07:59:44 -0400
Received: from mail-eopbgr150058.outbound.protection.outlook.com ([40.107.15.58]:39139
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230326AbhELL7l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 07:59:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JU+/zWiUfCnspfgxvooeZwrnmmfelV1I4vC/6+wZPAMDnLpxgDYNk6wwbnsNSAWVu0LKszWUvb6fR8UUvXL1hyC1w6pvJSDNEedIs8fee2PkFFVfzH8Yh3aqHT/lEY20PUf+kXk+VXv8503cRYmKphRWFcVNDaB/jl3r8spO7c6J4aUCI39TLdx8LgUmIOTXHVjstDsf35ealOTs0jZeYrKt3PRKE7VDbRyMvLz8h0h/7hotnp4yN1S2uUr91N/RfEfJq/fAf6SgxisppJ0QbSrMHZNnt518gv6o6Fn3yAZdOjZyugsroSZiR47vGTIjBcfqOhLAEIFrfy+uMlAHaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxyWganpzDN3t7FwL9xlkXLNXjAiCVB7UQp62yT0lGk=;
 b=i9CiJM6PrycJsrPV4xlEKRoshFysD8wzVIC39/EjQfDPtMTeVK3mz55VDu4yZ8Wjp5jocQNcKNB6RqNLr7/YPfwOBb2QemyCnLIWAXN5nlS7qSIHpFuiPv/R5lmYLYG9tmlhtLcP8DW9HuDz3PjzegJOHxE/MZnpS4GH3taNmcDYLC0cH+RxtxXpByP6fV7CJMNNJKHWD6CRS7NrvDAg/Sb1ojWtxMnFxFu+TToz0yz3GWzjW/h0lMoC5q+E+QU1ggAjYZ4H5q0As9MzC+RSMXQTzZ/Nf9QBaDVv09CXai/t2Syse5uPkwgS/ZnTgxDz1vko7TtIby51zy8C+76bcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gxyWganpzDN3t7FwL9xlkXLNXjAiCVB7UQp62yT0lGk=;
 b=nhobbHPBFRzIhPpqmgcqQ/FMN/BNRO/fN9mnY2jPvyGvhfcf4QYBB2B7cUozR96CwZGr8yczPRKFENNmu8ahwyglerlvcDu9KMKt4N3j1gJKCHtCjE84nItpTVQlanSv5zCLWSOA7n8mDiRxDZxNQx9l2Sly49xq2FSFWzIYMjw=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3206.eurprd04.prod.outlook.com (2603:10a6:6:d::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.26; Wed, 12 May 2021 11:58:30 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4129.025; Wed, 12 May 2021
 11:58:30 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: i.MX8MM Ethernet TX Bandwidth Fluctuations
Thread-Topic: i.MX8MM Ethernet TX Bandwidth Fluctuations
Thread-Index: AQHXQoZ/tVGcom8wzE+eoQ5m9ZEBXqrfxlLQ
Date:   Wed, 12 May 2021 11:58:30 +0000
Message-ID: <DB8PR04MB67957305FEAC4E966D929883E6529@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de>
In-Reply-To: <421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kontron.de; dkim=none (message not signed)
 header.d=none;kontron.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67366959-5ad6-44b1-b50f-08d9153d42cc
x-ms-traffictypediagnostic: DB6PR04MB3206:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR04MB32067E3B960B73478D710618E6529@DB6PR04MB3206.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sq5SOr0PNH46U5MBZmlj6TIA3RCPL5EwkGyqocSBYL0j9GvTHXebPvFI7vbd5CMXjjyL28I0WGPlVmy4jTqraEkDjb2FvPhcwXeRV8mcU2l6nlkf40SaLwXtkBMK3P3XPL8xJZY/CB/LFLbMwtcm0RWLQ+sf1hpZTR2PzdRreBb1bnSspVVq3mfSoLFFViXFCbjwd21lguadyDhrxmoNhs9QaeiWlIn9OCh/Y7+L1JLSFbu7NZW6G6rlXaKg5aMy+VdpZy9vVWwt5rdgDWuhaElTc/CIX7m9prVgXDVl64k2Ue33SohKqPouj4pd2hNhcKmoqELRW4waR38GLMypVWSs2PrLWX0Nlo4OsFxjj48gdPeOnT/WvfITGanPszo52m1RhYlf/49o+OnAF9Peor5FavlRE3rNhWM0QsW+AGif0A4woLpMPUWxvpzDsXVuMVC5AjUpo2Ga1TXI6djzGLY4OVCqCQUZYdlfPC+oezjd3Jhcch+9MCO7dNvGQq4xpS3gPPLowz4olW76f4Uvybuehbc4mZ1VJiXg5FCOhg9rOpey6LjVrseeFu52Dn94mb/vsAzFa6qybaJUIwj2PY1gldqgYI8Kpv21hMC+1O1YYKHqmSsHYSFLrcEXkCehxbjgrqdV3+epVE3YzvP15oak2tpPgY5rMIfZQ1em/T+DXAahgoxvdoTw8wkrdSnc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(6506007)(53546011)(8936002)(478600001)(2906002)(5660300002)(86362001)(83380400001)(7696005)(76116006)(316002)(110136005)(52536014)(8676002)(66446008)(186003)(66556008)(33656002)(122000001)(9686003)(38100700002)(71200400001)(966005)(66946007)(66476007)(26005)(55016002)(45080400002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?RWZ1R25CZm5iU205cGtMdkwzanVuOGdPMkJ1MUxZYXVrR1RaMlQvd2VZcHU4?=
 =?gb2312?B?M2lZMDJNL0F4S3RHemxUaXlYVk9PcU1yYXFUdUFMUzhHVkFCeFliMkswVURG?=
 =?gb2312?B?SFhrTE5iZCtCS05ZWnB3aklweTB3Z2FDU3hQR2s1SUFhNHJFUmVzQS9nZk1v?=
 =?gb2312?B?Z2k5MVVwbm40ZWdCRXpwTXR0ZDFvd1hTdEVnRGU0T2lNZXhJeUhvUUxsNjhi?=
 =?gb2312?B?Qk1DbmpWeloyWDZDTDlrZ2x1VkZ0a0xJYTE1RXRad0Z2UXY1aEdoL1BST2tR?=
 =?gb2312?B?eGJFZHVucUtmU2xlSWFjUUJNQ3QrMUd1Mm85VXhCMDlhemNoOU5LUi9PTUNt?=
 =?gb2312?B?OHozaWhlMDZIekU5bU9pWlpDTElpMzVUM3hNVjRDVDFyMzh6U1JySjRiZmFX?=
 =?gb2312?B?elcwU0w5Zy9laVdQeVRETHB3UEQ3aHU1Q2tZM0lzMGNWWENYdnJyMmdLSE9D?=
 =?gb2312?B?Unh2bFFsaXlOTFVTbU56aU12SjdHamtZUlhpQVE4QTRLRDdNTy9WQXhFeklY?=
 =?gb2312?B?N29iVUZHZ1dWdjJLckdrRFNDWXpiNkU5V2s3aDdhemdxVzZoY1RGZTNKV0ZU?=
 =?gb2312?B?WG1jT2VCdk9qa2F3WnduUHZrMjA4TmlRa1hXQjYrYTZ3YjI4T2NWQkowaklp?=
 =?gb2312?B?V0FGNDkzTVdXTDhUa05hUUYwcmNIWEdFR1NESjMrY0NrRUtWcDI2UVJDNXpv?=
 =?gb2312?B?RmtFZStNdlFnTTV0Wlc4aFV0SzkyMW1SNEE3L3dLd2tiRXBpOUpSR3EvdmxT?=
 =?gb2312?B?MUhsRmtkNjUrQzNqYS9iWmU4bVljUklEWWt5NHNlTDJIczBCTGtzeGEreENU?=
 =?gb2312?B?eWFxK1lJZHJLMGI4eEhhbUQ0bUwyWFNQaCtwSGd3T09mVHordWtubGlnekth?=
 =?gb2312?B?aVdDTFdKY3FySnpTaEp0cHR1V3hyS0dJeU1iSWxpRTlPZUlMcXpHUzVVTFFW?=
 =?gb2312?B?T01iVk9EaldnY1JnbjBEZEdKVmJnbk8zME9IWnkzN2Y4V3ViTEdLOEdLM0Vq?=
 =?gb2312?B?WnZ3OSsrSEpPL2hZM2ZmcUtjMU5IdEZPMk14bXhlZXZhNHpKTnNITjlFYzV0?=
 =?gb2312?B?VUo1NWpPcnFnTGdOMzlqKzdjMjZ2cEJBMm5tTFkvUE50MDhZMWM3cm1JZXk4?=
 =?gb2312?B?ajRtZm5hUzVzS1gxLzRQQ0JJVHk3TnF4WWxIWjBsVThHMk9mcTNhaGpyb25V?=
 =?gb2312?B?Tk1Lc3RtQzExaEJnSnk3RGQxeGI0aTI0cU13QnFDbDVySGJpNGVJMy9Nd244?=
 =?gb2312?B?eURDR3d5VG8rTXFraDF0MkIrTmpoWUdHQndmeTlHR1NtSUx4OGd5dURKQ1d3?=
 =?gb2312?B?YVNFenRKVG9ZSFFYU0ZsMTJ2UUs4TXQ1U1VlbzVjbEVic1grUG9hZDdmRS9Z?=
 =?gb2312?B?aTNiNm1VMDhmY1FyZWluTzBoZi9XWC9hZkUyL1g2dzBBZkNXZERhNHFGa05L?=
 =?gb2312?B?TXBVaHBtNGFXWGxkUXVOOTExL3o4Q2RYajBFY1IraXNYNXpiN1RiL25wb2ZB?=
 =?gb2312?B?VFFGbCtHRHB5Sld3VzRSVGJ1dEtwNTVBZDlZVlFRY1NrcG0vNzkwUU92VERI?=
 =?gb2312?B?a0dtMzQ0eW00bkNSa2Qvb0JySGNRREpxRG9CRWdGNEE1QmJTUEdsdUttbVNv?=
 =?gb2312?B?aW5ZWFpzbUpnY1Q1VEVsQU1Uc25ENnZuRkprOWFEKzdzUGhsa2ttSkNtVXBo?=
 =?gb2312?B?M1RsK1lkUHp1UG9yclNCWDQwSWVGTktLMmF3cDRzbWdObFQzbXh3TVlubXRD?=
 =?gb2312?Q?9Ox3/t/PGAHMMYxs+7+1D3DmAwrlUfSKph81TMs?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67366959-5ad6-44b1-b50f-08d9153d42cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2021 11:58:30.6640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2hbDGqT797T6ZOYpQQUBZ4OAekN6gKvdkiZA9JWnLAPdEH/HpmEVB9jd8impY8uM3vybhktv5mUzkMqhANtyvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3206
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBGcmllZGVyLA0KDQpTb3JyeSwgSSBtaXNzZWQgdGhpcyBtYWlsIGJlZm9yZSwgSSBjYW4g
cmVwcm9kdWNlIHRoaXMgaXNzdWUgYXQgbXkgc2lkZSwgSSB3aWxsIHRyeSBteSBiZXN0IHRvIGxv
b2sgaW50byB0aGlzIGlzc3VlLg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg0KPiAt
LS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBGcmllZGVyIFNjaHJlbXBmIDxmcmll
ZGVyLnNjaHJlbXBmQGtvbnRyb24uZGU+DQo+IFNlbnQ6IDIwMjHE6jXUwjbI1SAyMjo0Ng0KPiBU
bzogZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7DQo+IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBTdWJqZWN0OiBp
Lk1YOE1NIEV0aGVybmV0IFRYIEJhbmR3aWR0aCBGbHVjdHVhdGlvbnMNCj4gDQo+IEhpLA0KPiAN
Cj4gd2Ugb2JzZXJ2ZWQgc29tZSB3ZWlyZCBwaGVub21lbm9uIHdpdGggdGhlIEV0aGVybmV0IG9u
IG91ciBpLk1YOE0tTWluaQ0KPiBib2FyZHMuIEl0IGhhcHBlbnMgcXVpdGUgb2Z0ZW4gdGhhdCB0
aGUgbWVhc3VyZWQgYmFuZHdpZHRoIGluIFRYIGRpcmVjdGlvbg0KPiBkcm9wcyBmcm9tIGl0cyBl
eHBlY3RlZC9ub21pbmFsIHZhbHVlIHRvIHNvbWV0aGluZyBsaWtlIDUwJSAoZm9yIDEwME0pIG9y
IH42NyUNCj4gKGZvciAxRykgY29ubmVjdGlvbnMuDQo+IA0KPiBTbyBmYXIgd2UgcmVwcm9kdWNl
ZCB0aGlzIHdpdGggdHdvIGRpZmZlcmVudCBoYXJkd2FyZSBkZXNpZ25zIHVzaW5nIHR3bw0KPiBk
aWZmZXJlbnQgUEhZcyAoUkdNSUkgVlNDODUzMSBhbmQgUk1JSSBLU1o4MDgxKSwgdHdvIGRpZmZl
cmVudCBrZXJuZWwNCj4gdmVyc2lvbnMgKHY1LjQgYW5kIHY1LjEwKSBhbmQgbGluayBzcGVlZHMg
b2YgMTAwTSBhbmQgMUcuDQo+IA0KPiBUbyBtZWFzdXJlIHRoZSB0aHJvdWdocHV0IHdlIHNpbXBs
eSBydW4gaXBlcmYzIG9uIHRoZSB0YXJnZXQgKHdpdGggYSBzaG9ydA0KPiBwMnAgY29ubmVjdGlv
biB0byB0aGUgaG9zdCBQQykgbGlrZSB0aGlzOg0KPiANCj4gCWlwZXJmMyAtYyAxOTIuMTY4LjEu
MTAgLS1iaWRpcg0KPiANCj4gQnV0IGV2ZW4gc29tZXRoaW5nIG1vcmUgc2ltcGxlIGxpa2UgdGhp
cyBjYW4gYmUgdXNlZCB0byBnZXQgdGhlIGluZm8gKHdpdGggJ25jIC1sDQo+IC1wIDExMjIgPiAv
ZGV2L251bGwnIHJ1bm5pbmcgb24gdGhlIGhvc3QpOg0KPiANCj4gCWRkIGlmPS9kZXYvemVybyBi
cz0xME0gY291bnQ9MSB8IG5jIDE5Mi4xNjguMS4xMCAxMTIyDQo+IA0KPiBUaGUgcmVzdWx0cyBm
bHVjdHVhdGUgYmV0d2VlbiBlYWNoIHRlc3QgcnVuIGFuZCBhcmUgc29tZXRpbWVzICdnb29kJyAo
ZS5nLg0KPiB+OTAgTUJpdC9zIGZvciAxMDBNIGxpbmspIGFuZCBzb21ldGltZXMgJ2JhZCcgKGUu
Zy4gfjQ1IE1CaXQvcyBmb3IgMTAwTSBsaW5rKS4NCj4gVGhlcmUgaXMgbm90aGluZyBlbHNlIHJ1
bm5pbmcgb24gdGhlIHN5c3RlbSBpbiBwYXJhbGxlbC4gU29tZSBtb3JlIGluZm8gaXMgYWxzbw0K
PiBhdmFpbGFibGUgaW4gdGhpcyBwb3N0OiBbMV0uDQo+IA0KPiBJZiB0aGVyZSdzIGFueW9uZSBh
cm91bmQgd2hvIGhhcyBhbiBpZGVhIG9uIHdoYXQgbWlnaHQgYmUgdGhlIHJlYXNvbiBmb3IgdGhp
cywNCj4gcGxlYXNlIGxldCBtZSBrbm93IQ0KPiBPciBtYXliZSBzb21lb25lIHdvdWxkIGJlIHdp
bGxpbmcgdG8gZG8gYSBxdWljayB0ZXN0IG9uIGhpcyBvd24gaGFyZHdhcmUuDQo+IFRoYXQgd291
bGQgYWxzbyBiZSBoaWdobHkgYXBwcmVjaWF0ZWQhDQo+IA0KPiBUaGFua3MgYW5kIGJlc3QgcmVn
YXJkcw0KPiBGcmllZGVyDQo+IA0KPiBbMV06DQo+IGh0dHBzOi8vZXVyMDEuc2FmZWxpbmtzLnBy
b3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRmNvbW11DQo+IG5pdHkubnhw
LmNvbSUyRnQ1JTJGaS1NWC1Qcm9jZXNzb3JzJTJGaS1NWDhNTS1FdGhlcm5ldC1UWC1CYW5kd2lk
dGgtDQo+IEZsdWN0dWF0aW9ucyUyRm0tcCUyRjEyNDI0NjclMjNNMTcwNTYzJmFtcDtkYXRhPTA0
JTdDMDElN0NxaWFuZw0KPiBxaW5nLnpoYW5nJTQwbnhwLmNvbSU3QzVkNDg2NmQ0NTY1ZTRjYmMz
NmEwMDhkOTEwOWRhMGZmJTdDNjg2ZWExZA0KPiAzYmMyYjRjNmZhOTJjZDk5YzVjMzAxNjM1JTdD
MCU3QzAlN0M2Mzc1NTkwOTE0NjM3OTI5MzIlN0NVbmtubw0KPiB3biU3Q1RXRnBiR1pzYjNkOGV5
SldJam9pTUM0d0xqQXdNREFpTENKUUlqb2lWMmx1TXpJaUxDSkJUaUk2SWsxaGENCj4gV3dpTENK
WFZDSTZNbjAlM0QlN0MxMDAwJmFtcDtzZGF0YT15Z2NUaFFPTEl6cDBsemhYYWNSTGpTam5qbTFG
RWoNCj4gWVN4YWtYd1p0eGRlOCUzRCZhbXA7cmVzZXJ2ZWQ9MA0K
