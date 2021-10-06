Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F5D4247BF
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 22:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhJFUO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 16:14:26 -0400
Received: from mail-eopbgr1410135.outbound.protection.outlook.com ([40.107.141.135]:5384
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229677AbhJFUOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 16:14:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KaKL70uQJg5TrIsRf4/Y8Ua90pFM1s/tjQyQnNbBwbWkIF0TejfsoVPOAVQ4Chj80an/cmQ9pO4YjnJ1SzLPdHtWCSf9GuXOyXQe/gzIuFK/RWv/FESlfCu18Rc3GhKprqfhAgWPBOoXn+qgweFinFlr+Wv5sjUk6U8Ic1n6emepTmwHwhDGEIYgGA2FHKzmi03W8m56lL0MdUPT+rGifSQ8f9ucH+5Te8ejsVJbv/U69CDj9+lK/8sK3qziThtJ6PS4AU1STUXyTZoCrScgCpIDL6LNP/yAy63Eofhqk8nkkkq177QRvzf2tps4O8rXru0VDXnG9F0zWTlSNNvriQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZGI0N8VzvyXBuvj6Zm9+NuhkZBBMbrhihFRvJwuuw1w=;
 b=htO5aamPgIyDjYUIfzHHv0rayesFGFbutgsbQ90VLnGl5hFsTCqkwzKn/OhOb+9juDAAou0vR0Gw+DB/+cKwxjEwozibq/klE33zVeezyI8SDGXsYg513BaoSv+w4IHGv2mVcrBg8ulAcj8WLXGkDMdrYSW5aFaPc7WDbZleeh0rmwzQqtFCDcubtyrUk9J0f41pHUBWpl7w180YTlmta9/HyQKC72/mz9PnbofyS1xg3iFcL1svi86hB616AUM12Dlmf9hx2zWhqAgaesJ50h4wbFMgJ/NhE75oXEDVttdTYnjS3/q7e9ryLW1/rXQV5j54hPM/qSjMCgYZVgvtSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGI0N8VzvyXBuvj6Zm9+NuhkZBBMbrhihFRvJwuuw1w=;
 b=SWtZKyoebpCtKkY5QIn3PPOzbTFYiZ/9GGfdwKiaXLQvARbaF4ZmU1C9e77jjlrrddtQWQ8Z35oiBwaP8BfUf/jpdqvAz5eYtsaJCtEbCt0zpWJrRsp4DgMoru0ZQHvivoZkWxyCDFm/OxvOZRmnBTBguheCJms8/ULBh14v/lo=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB2914.jpnprd01.prod.outlook.com (2603:1096:603:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Wed, 6 Oct
 2021 20:12:23 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.018; Wed, 6 Oct 2021
 20:12:23 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH 03/10] ravb: Add nc_queue to struct ravb_hw_info
Thread-Topic: [PATCH 03/10] ravb: Add nc_queue to struct ravb_hw_info
Thread-Index: AQHXttX5ODlVZmq7uEmXI4BQLB83BavACvsAgADNqeCABY9BAIAABQEQ
Date:   Wed, 6 Oct 2021 20:12:22 +0000
Message-ID: <OS0PR01MB5922BA0B28513B4208A802D786B09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-4-biju.das.jz@bp.renesas.com>
 <334a8156-0645-b29c-137b-1e76d524efb9@omp.ru>
 <OS0PR01MB59222DB9D710A944235FD1D586AD9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <757eb986-d3cc-322a-64e8-3b23a3dd07d3@gmail.com>
In-Reply-To: <757eb986-d3cc-322a-64e8-3b23a3dd07d3@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9085dbeb-77f7-4b17-d774-08d989059bc8
x-ms-traffictypediagnostic: OSAPR01MB2914:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB2914F6D9DCB7DDE3637935FD86B09@OSAPR01MB2914.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:826;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f05RAE0MRw5gVtjInMyfiOoTgP16JhxrrLEQHZ/kIWDqBcEsVPNJTb+0Zn4zj8H95nE6U31pFba6K4OiGBxfiLY+OEjMT6tjpixiGlMJy/EULjLLq75OoW3GJDi477Pc8wlqayW7YcBVYPpGHBjdDWHDETAdlFVPrbJJ+y/BkRvVHWcjUQyo8eLY+lZI7RY7v9WRf5eo2ju7wjqild/+DMrazTC7j4vo9xQ5poh10yuDOL8vLFoLOVm05Qcs6G/sdpCsFXcv0w6d9ibooxTpYcKAJ9qb8fFX2NeK/UZhYJ+Frpykf0MG5J3lIg1dbKPU6nOcJA+9+8lvq+HtdrQcdUQJvL29579XFSMiU/1R35RdwqGZIgiyb9GgfuZw7k3ruvDmltUi6FiwGgIxqzmUgUEVs+I4a5ofLxT093MvxmwfZtrmG5pEVCUNtGMNVd64gOQqFG/3GsfMQeeajxAUC4encPqWJ2uhZr3mh8InrKqnfueXBcyrrgvszZA68uQCcei20eDwoRyKF+wB78y2qD7mxH3Rj+iWSAPexL8yV67SWl2lx0cwq6AnkU9v3GYp83SXyyThBbTG9+tdi/qFJA0kBrZ443fQoAbFpnSAePy4Bnt12K1zxSLIR8hsEhJA8VR+5XapVVMZyy8r9Ei+/W9UPNyxlIHJlM2qAWB9QVpKxNKwdUycpuK086ODZOY2WlQrbkVw5Oi9paxkIz7PkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(110136005)(7416002)(54906003)(38100700002)(107886003)(122000001)(9686003)(508600001)(38070700005)(86362001)(33656002)(2906002)(55016002)(26005)(186003)(8676002)(52536014)(5660300002)(316002)(53546011)(71200400001)(6506007)(4326008)(66946007)(76116006)(83380400001)(7696005)(66476007)(66556008)(66446008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1RHUXVqeW1qUTNKbXpEZlJWcTdqRFdPYi95NDlCR3p3SDcwMnZDZFhoWWdw?=
 =?utf-8?B?dUZNY1FvUnNwQitDMUVyajNnS1dGakNGTFlMYmwxeEFKdWVRR0xXdDVsV3hG?=
 =?utf-8?B?aGtucHFRSnVYRUxNYlVCelBOaXNUQzRaSHdoSGxRUGdSYjRqTGNtWUwxVkVs?=
 =?utf-8?B?U0RlbGtJcmZtc2FPSzJDdFVuV1g2TUw2UjgvTS9yNlZ5UDltVCtaNFROZGFK?=
 =?utf-8?B?SFVlKzg2RUY4V3hpT1ByeCtoTFhmTm9xeXlPTzh4TGVrZUtOWDU3R0NEN0tE?=
 =?utf-8?B?Q3ByWVVUMXFXTDBRcWxyQVJjOXUvSEZwdGQ3NnAvRFNhaGt6VEw0NU9NZDhF?=
 =?utf-8?B?R2RQZVlybmxkaVZXTEVXbnY5WENwaEQrTWNTOUpiSHRweDhhK2xHZk1RNGds?=
 =?utf-8?B?c2hFVVJqWFhkL0p4TXZtYVZ5Q29FZ0FmRllqM2pLVUM2Ui93MVdodUp3R3dB?=
 =?utf-8?B?aXFUVzNpYWtadlFxbFNBLzdvcFhnaWJIL1VZU0JQbWs4QnNmdjNuWkJ0TC9v?=
 =?utf-8?B?b01GbmhMQTArdHcyTWRtQUdHSFFINE5EdjBBM1cra2Izd1hEdnlHZVAxYmdz?=
 =?utf-8?B?cHVKVHpxZkQ2WmFWd2pLNDIybUxRWFBKZU1ENVlBakxPQldCNjFUMHpwa3h3?=
 =?utf-8?B?OHNZZUZsQzBkUzF6QUtrT21JYnVtYzdsVk5IQTdRdGE5NkIrUHR5YXlUVWNK?=
 =?utf-8?B?UENqNmRGWktxQ3IrVkwwNk5OcVM5WTIrZmlYdnZOdWVNU1RxMnNERlNHUTZi?=
 =?utf-8?B?RGxvM3lVeUEzbVUzSUx3Wm11S2w5MlZlZXlndVRzWGk3ME5kQ1labGVoak5v?=
 =?utf-8?B?amhqb09LT1k5Z3FFV0NtVGx1c0RydUVVdHNLMGZrdGZTVE9ia3BnSkFJZEc0?=
 =?utf-8?B?T214Unl3N0FUSHJOdm81YzBRcGdnNjJWSWt5WG9waDQ3bTlUQ2QxeGkwZXM0?=
 =?utf-8?B?RjFBcHc2K1NXaGNMT0l3cjl0a1NwTnp1b3RXVHg5SkZvdWZqRW9YRkpNOS9k?=
 =?utf-8?B?clZLQitpWlN0U1ZOTXZIVmhNOG1nNnhNSURVTFFCUGtva0ZsMlBXRjdteG1o?=
 =?utf-8?B?V3hyUEJjK1FIelliS24zemk1aXArRDVOdVZzcWQ1NzRiTXlvV0R6bTN3R1Av?=
 =?utf-8?B?SjFoaDZxV2srY3ZoVHR2U1oyOFB6ZXZsTnBWdHdqVlRWbEpabTNzbkc1d0xD?=
 =?utf-8?B?NjJsUm5qY0IzK0Z6Rmx4SkgwM05ndHNKUkxTUjEzWVM4QXBJakJxa0paZzhP?=
 =?utf-8?B?cG9QQ2FRSWxhRStCcEFESlMrcGs0SUFsSXI0MEEzNnQvWnZqMEE5Vnl5UnU1?=
 =?utf-8?B?M0lNM2NmckVPR1ZQdWNta3dFSzd1bzAxY2pnUmFLdjZYdEd2aTl4bW9LR01K?=
 =?utf-8?B?eXZycWZPdURuWHhsaFJ0eDlja1E3MGI3MnNsU29wcjZBVzJWd056V2V2RTM4?=
 =?utf-8?B?dTlSSWo3dnhxM3pTRXNpbEZtY2pscEQraERRRTlxQjlKNUh1MU1UL0ZBb1Ur?=
 =?utf-8?B?OFdId0hpaG8yUVlBSEMvMVhXMmhRR1EvejFFbjJsNncxU1B6SEZNdEk1ZjBQ?=
 =?utf-8?B?ZlhFSXBZcFRBNGNRRmVQdlh6YVllVGQ2aUdRR25qUGV4Rk1NbE93MzZScTJt?=
 =?utf-8?B?QjlhYWlRaDN6eGRSdmVhTEZYeGMzTmx3YndxMVJud25vb0pQQkRVN21YQXVF?=
 =?utf-8?B?MW1PM2lRUHlsRmg2NDVyL1NlZTE5R2hrWFlNeTJLQS9ST0pVNGx2RnloeEoz?=
 =?utf-8?Q?g/IB6duj3dGKllgV8s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9085dbeb-77f7-4b17-d774-08d989059bc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2021 20:12:22.6160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B6boBlfqg7v5qrZg7qn/a7BL6HarYKobUkVazC+i6TLJ8RViWpQR1c+2P2tv+bDAFE+YdckV2W3wGprbSzgoLheQ08uAETEB+Q0OnJ4eO48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2914
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlcmdl
aSBTaHR5bHlvdiA8c2VyZ2VpLnNodHlseW92QGdtYWlsLmNvbT4NCj4gU2VudDogMDYgT2N0b2Jl
ciAyMDIxIDIwOjQ2DQo+IFRvOiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+
OyBTZXJnZXkgU2h0eWx5b3YNCj4gPHMuc2h0eWx5b3ZAb21wLnJ1PjsgRGF2aWQgUy4gTWlsbGVy
IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kNCj4gPGt1YmFAa2VybmVsLm9y
Zz4NCj4gQ2M6IEdlZXJ0IFV5dHRlcmhvZXZlbiA8Z2VlcnQrcmVuZXNhc0BnbGlkZXIuYmU+OyBT
ZXJnZXkgU2h0eWx5b3YNCj4gPHMuc2h0eWx5b3ZAb21wcnVzc2lhLnJ1PjsgQWRhbSBGb3JkIDxh
Zm9yZDE3M0BnbWFpbC5jb20+OyBBbmRyZXcgTHVubg0KPiA8YW5kcmV3QGx1bm4uY2g+OyBZdXVz
dWtlIEFzaGl6dWthIDxhc2hpZHVrYUBmdWppdHN1LmNvbT47IFlvc2hpaGlybw0KPiBTaGltb2Rh
IDx5b3NoaWhpcm8uc2hpbW9kYS51aEByZW5lc2FzLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IGxpbnV4LQ0KPiByZW5lc2FzLXNvY0B2Z2VyLmtlcm5lbC5vcmc7IENocmlzIFBhdGVyc29u
IDxDaHJpcy5QYXRlcnNvbjJAcmVuZXNhcy5jb20+Ow0KPiBCaWp1IERhcyA8YmlqdS5kYXNAYnAu
cmVuZXNhcy5jb20+OyBQcmFiaGFrYXIgTWFoYWRldiBMYWQNCj4gPHByYWJoYWthci5tYWhhZGV2
LWxhZC5yakBicC5yZW5lc2FzLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCAwMy8xMF0gcmF2
YjogQWRkIG5jX3F1ZXVlIHRvIHN0cnVjdCByYXZiX2h3X2luZm8NCj4gDQo+IE9uIDEwLzMvMjEg
OTo1OCBBTSwgQmlqdSBEYXMgd3JvdGU6DQo+IA0KPiA+Pj4gUi1DYXIgc3VwcG9ydHMgbmV0d29y
ayBjb250cm9sIHF1ZXVlIHdoZXJlYXMgUlovRzJMIGRvZXMgbm90IHN1cHBvcnQNCj4gPj4+IGl0
LiBBZGQgbmNfcXVldWUgdG8gc3RydWN0IHJhdmJfaHdfaW5mbywgc28gdGhhdCBOQyBxdWV1ZSBp
cyBoYW5kbGVkDQo+ID4+PiBvbmx5IGJ5IFItQ2FyLg0KPiA+Pj4NCj4gPj4+IFRoaXMgcGF0Y2gg
YWxzbyByZW5hbWVzIHJhdmJfcmNhcl9kbWFjX2luaXQgdG8gcmF2Yl9kbWFjX2luaXRfcmNhcg0K
PiA+Pj4gdG8gYmUgY29uc2lzdGVudCB3aXRoIHRoZSBuYW1pbmcgY29udmVudGlvbiB1c2VkIGlu
IHNoX2V0aCBkcml2ZXIuDQo+ID4+Pg0KPiA+Pj4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJp
anUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+Pj4gUmV2aWV3ZWQtYnk6IExhZCBQcmFiaGFr
YXIgPHByYWJoYWthci5tYWhhZGV2LWxhZC5yakBicC5yZW5lc2FzLmNvbT4NCj4gPj4NCj4gPj4g
UmV2aWV3ZWQtYnk6IFNlcmdleSBTaHR5bHlvdiA8cy5zaHR5bHlvdkBvbXAucnU+DQo+ID4+DQo+
ID4+ICAgIE9uZSBsaXR0bGUgbml0IGJlbG93Og0KPiA+Pg0KPiA+Pj4gLS0tDQo+ID4+PiBSRkMt
PnYxOg0KPiA+Pj4gICogSGFuZGxlZCBOQyBxdWV1ZSBvbmx5IGZvciBSLUNhci4NCj4gPj4+IC0t
LQ0KPiA+Pj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAgICAgfCAgIDMg
Ky0NCj4gPj4+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jIHwgMTQw
DQo+ID4+PiArKysrKysrKysrKysrKystLS0tLS0tLQ0KPiA+Pj4gIDIgZmlsZXMgY2hhbmdlZCwg
OTQgaW5zZXJ0aW9ucygrKSwgNDkgZGVsZXRpb25zKC0pDQo+ID4+Pg0KPiA+Pj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4+PiBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4+PiBpbmRleCBhMzNmYmNiNGFhYzMuLmM5
MWU5M2U1NTkwZiAxMDA2NDQNCj4gPj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcmF2Yi5oDQo+ID4+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIu
aA0KPiA+Pj4gQEAgLTk4Niw3ICs5ODYsNyBAQCBzdHJ1Y3QgcmF2Yl9od19pbmZvIHsNCj4gPj4+
ICAJYm9vbCAoKnJlY2VpdmUpKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LCBpbnQgKnF1b3RhLCBp
bnQgcSk7DQo+ID4+PiAgCXZvaWQgKCpzZXRfcmF0ZSkoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYp
Ow0KPiA+Pj4gIAlpbnQgKCpzZXRfZmVhdHVyZSkoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIG5l
dGRldl9mZWF0dXJlc190DQo+ID4+IGZlYXR1cmVzKTsNCj4gPj4+IC0Jdm9pZCAoKmRtYWNfaW5p
dCkoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpOw0KPiA+Pj4gKwlpbnQgKCpkbWFjX2luaXQpKHN0
cnVjdCBuZXRfZGV2aWNlICpuZGV2KTsNCj4gPj4+ICAJdm9pZCAoKmVtYWNfaW5pdCkoc3RydWN0
IG5ldF9kZXZpY2UgKm5kZXYpOw0KPiA+Pj4gIAljb25zdCBjaGFyICgqZ3N0cmluZ3Nfc3RhdHMp
W0VUSF9HU1RSSU5HX0xFTl07DQo+ID4+PiAgCXNpemVfdCBnc3RyaW5nc19zaXplOw0KPiA+Pj4g
QEAgLTEwMDIsNiArMTAwMiw3IEBAIHN0cnVjdCByYXZiX2h3X2luZm8gew0KPiA+Pj4gIAl1bnNp
Z25lZCBtdWx0aV9pcnFzOjE7CQkvKiBBVkItRE1BQyBhbmQgRS1NQUMgaGFzIG11bHRpcGxlDQo+
ID4+IGlycXMgKi8NCj4gPj4+ICAJdW5zaWduZWQgZ3B0cDoxOwkJLyogQVZCLURNQUMgaGFzIGdQ
VFAgc3VwcG9ydCAqLw0KPiA+Pj4gIAl1bnNpZ25lZCBjY2NfZ2FjOjE7CQkvKiBBVkItRE1BQyBo
YXMgZ1BUUCBzdXBwb3J0IGFjdGl2ZSBpbg0KPiA+PiBjb25maWcgbW9kZSAqLw0KPiA+Pj4gKwl1
bnNpZ25lZCBuY19xdWV1ZToxOwkJLyogQVZCLURNQUMgaGFzIE5DIHF1ZXVlICovDQo+ID4+DQo+
ID4+ICAgIFJhdGhlciAicXVldWVzIiBhcyB0aGVyZSBhcmUgUlggYW5kIFRYIE5DIHF1ZXVlcywg
bm8/DQo+ID4NCj4gPiBJdCBoYXMgTkMgcXVldWUgb24gYm90aCBSWCBhbmQgVFguDQo+ID4NCj4g
PiBJZiBuZWVkZWQsIEkgY2FuIHNlbmQgYSBmb2xsb3cgdXAgcGF0Y2ggYXMgUkZDIHdpdGggdGhl
IGZvbGxvd2luZw0KPiBjaGFuZ2VzLg0KPiA+DQo+ID4gdW5zaWduZWQgbmNfcXVldWU6MTsJCS8q
IEFWQi1ETUFDIGhhcyBOQyBxdWV1ZSBvbiBib3RoIFJYIGFuZCBUWA0KPiAqLw0KPiA+DQo+ID4g
b3INCj4gPg0KPiA+IHVuc2lnbmVkIG5jX3F1ZXVlczoxOwkJLyogQVZCLURNQUMgaGFzIFJYIGFu
ZCBUWCBOQyBxdWV1ZXMgKi8NCj4gPg0KPiA+IHBsZWFzZSBsZXQgbWUga25vdy4NCj4gDQo+ICAg
IFllcywgcGxlYXNlIGRvIGl0Lg0KDQpPSyBJIHdpbGwgZ28gd2l0aCBiZWxvdywgYXMgUlggaGFz
IHNpbmdsZSBOQyBxdWV1ZSBhbmQgVFggaGFzIHNpbmdsZSBOQyBxdWV1ZS4NCg0KdW5zaWduZWQg
bmNfcXVldWU6MTsJCS8qIEFWQi1ETUFDIGhhcyBOQyBxdWV1ZSBvbiBib3RoIFJYIGFuZCBUWCAq
Lw0KDQpDaGVlcnMsDQpCaWp1DQoNCj4gDQo+ID4gUmVnYXJkcywNCj4gPiBCaWp1DQo+IA0KPiBN
TlIsIFNlcmdleQ0KDQo=
