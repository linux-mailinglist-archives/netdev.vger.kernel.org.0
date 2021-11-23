Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACB745A2A6
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbhKWMeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:34:10 -0500
Received: from mail-dm6nam10on2076.outbound.protection.outlook.com ([40.107.93.76]:17066
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234978AbhKWMeK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 07:34:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYH0F9fdhIxsz2M4K3Ekzap3xuxC9CtQwqaLlpEfrluSsX5RkDiToWWkPqLaLJ8zHdU3Y8sSLnwlHPp+xrM4iWb19ppOUF//oy12TA71ES7kaDFGE2lCE+8jnhyTpTz0S304w6A/I5o96aD/mEWz4mTOnvIW1MMnlTJOHlZ9TNjdn45YK0kyCsbj7j3RCQcs0NV2i+WyTlMtN0ee2aWuSH3qxo4LpDJXLf8DGyUfYu5lYUAOhbq2bkuLvBisBDFyh+ue9A2d1MNCoBqWrOCASbbY6zAXJxxzuol1UchjIDKPc6WfAqtygf1i0EiZbt1g9nW1lIQT6ez2SqMYoTbZQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W29QBuxvZZGgEA6Stxvp4sG55WPQzYtZE2u24fVB20Q=;
 b=dHVmoFdZzOz5Cns5DFo9kbV1sNroehlIi2I+AYhl1inq0fIt/g7QJFfuLNRxKAOhEfDrr8fYzGTa5DfkYjsKy7OLLX43N+N1Itrizh6LLKFscvb6uYGXYYAQphGvMxoGKIp+J+V4WQiU/B6V63cCt3w4RxuzjfMauAG44l/V5V9iL/D8f6N4H+zSqGtKHRojvVFBvLRKsjjV4fejDJVWdCnxCdVRiXO7hVlJRQpBM8LgOSAxEVwdZbgO+yiQygLMHIkpxCA11VDevbhGBK0U2Y/IIldhIcer2XYWnqSSj4xzsYznp1bxEgxmwvzh/Aa8bpdLFzCk7AjeZyXk/7AB3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W29QBuxvZZGgEA6Stxvp4sG55WPQzYtZE2u24fVB20Q=;
 b=j1Zy/UTleJIYynuIq2pjxBGgTyy1Yo98qLDZGzAmnFAoPyPr8TSHzGEq7Tvl62nUw5Xuas9nEX8iGUlxfAY3MVdci/vNNyVdQzbjI7YTEcamdiOqskY7KrHWd0lyanRRQQqISC8MKmmO91M7v9JnRDQlz/Ut0Hcrp9wBCoss5kOrhcxJ50HnQBy/m3Rg8+comB8FA7MtAgyxCRJyBRzBe46vgQ9zON2geKEjHgvBZ9nvqwgOj0tX/a0Iq6RJPrQn4a1XYRloA/4R/u7SyJ5yN8zRL2RKXgdvk8vUSUvcCJ2zKWhoHjWmatyKif+31JYrTr+Zwarx1/ORedXxWxkBSw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5590.namprd12.prod.outlook.com (2603:10b6:510:12b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Tue, 23 Nov
 2021 12:31:00 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::5515:f45e:56f5:b35a]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::5515:f45e:56f5:b35a%3]) with mapi id 15.20.4713.022; Tue, 23 Nov 2021
 12:31:00 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "patchwork-bot+netdevbpf@kernel.org" 
        <patchwork-bot+netdevbpf@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "mustafa.ismail@intel.com" <mustafa.ismail@intel.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next 0/3][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-11-22
Thread-Topic: [PATCH net-next 0/3][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-11-22
Thread-Index: AQHX3+Ww2KPsxQ/l0kOXchZpgORhdKwRCSEAgAAA21A=
Date:   Tue, 23 Nov 2021 12:31:00 +0000
Message-ID: <PH0PR12MB5481FAA21D5280DDCC5891A9DC609@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211122211119.279885-1-anthony.l.nguyen@intel.com>
 <163767001205.10565.2852083634552212032.git-patchwork-notify@kernel.org>
In-Reply-To: <163767001205.10565.2852083634552212032.git-patchwork-notify@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b48ccab-c991-4ec5-f49a-08d9ae7d1b51
x-ms-traffictypediagnostic: PH0PR12MB5590:
x-microsoft-antispam-prvs: <PH0PR12MB559029AD5787915702743DF1DC609@PH0PR12MB5590.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f8yQSUUBYeWVfljeCwVLrGWUMIWbjCh1HttmhUBfk1B62WBTHCF8ugzvx8ymg9AvQTQlLWseFiatXyt+Nzvd3NpT7zlR+/qF606n2Xezb9T3L0j0ApvbuHwqf1KSGmDtxCEFCqDvIMk39+wKbK8PfK2uarjVMTM67vIYRsgsMLnEvo1lEO+vmXQDecopY5C5uSphHf80qwM2D7L/mLc3Tq1MLqK1vHQtOH6LZv29KxBDUGNpiDVIKSQNJ+OojsvA0e3M3qC4aGMG7mKk/ASnOzsZ0YSL66op5BbiPPxw7EEk2IN36wcM4Asq0FyJb89W81vvttHBFTW1CicgJMEZghk3o8W1xyiwSori2fk4eyHm0ZRvwdGyGqfbex+1+pok46iVxDgFtSD1Ewg45wqf44WbEGMMDHVV8wHW7O+y6UonLtJT7RFVSqdSFZD5vX67StReald/PbuTw5X84kc/j6uA8Rb2syGfD5FFbA7aiQ2lvyrfMzmfQcHZGqda7abj48xUb0PCN0zmzGAcvnmhEhtW+xiD9Vb9y+Mp97Plvm7RM1mSXZbm+MtiVjCJTaEBZmoaQDGmmgjLAP63VAlxLCsZJgSvxCIXWali7NMWcWT8y00wrikIqplHDtO0BY83chsAyz50nKhHkokXjXxBC7i3Ux+F2gLOhu/8LDWiH1lvG4J0GBqAstmGHm4FEPvSqb53+XQIM9KLaWVMjM6r/dgQ4/V7NlFZGmm/fc/0EtnaL2kijwX+pFGPtCMSEVxqyU+BnCFxuwQ7PY/94pi2wPOBKwrlV4JHRJn6CA867Ys=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(110136005)(4744005)(76116006)(52536014)(33656002)(5660300002)(9686003)(316002)(66946007)(66476007)(2906002)(66556008)(107886003)(66446008)(64756008)(122000001)(508600001)(26005)(8936002)(966005)(38100700002)(55016003)(38070700005)(6506007)(8676002)(86362001)(7696005)(55236004)(71200400001)(4326008)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d0RYT3g2Q0lGaXlVS05ab00zZUhqbzkwVjdkejg0NzdOTE5hMjErd2ZaakFp?=
 =?utf-8?B?cDJ3NU0wUHJ0cHhLQ3pNVHkvWXhTNG8wV0Z2U1ZiWTI0YUNZY1RpeGh1eE5v?=
 =?utf-8?B?a1Z4dERYUjN3UDI2elM0L05reHI1MWpwR24xdnNvbEFZaXROL0ErNVRaRUJC?=
 =?utf-8?B?eXcxZi9TUWlRLzFjd2V2TEptc0pZd0ZWZ0VFVUFzK3EzMFArdDdXTE92Snhx?=
 =?utf-8?B?UUtyYkEwcTFrVkRmTlVDOXJwTjFSb1hWK3B5d2FZYXlYazYzODNoVDZ6RVpB?=
 =?utf-8?B?RlkwQ2lMYzZYNXZVK1lEeFZkdUU0TzYzQnY1dlZtRUJ1MUxXR09XRHFsempn?=
 =?utf-8?B?Q3FzUGlMWStSMi9XcExUVVZLTVl0VlFqdUExcjVNYVNxbFV3Y092QUZrNGY5?=
 =?utf-8?B?MVMxNDVGc3hKd0hPaXMvUHpnM0QwMVU5aEhsbXdvMkZuc3oxd3l5cHVUbkZX?=
 =?utf-8?B?SnNLL0VDR3hBYlNlUXQycjY0VnRzWGlVSHJiNkdVaHRwNkR5ekVBS3dhbm9U?=
 =?utf-8?B?ZEkyTVloMGlzb2hqS2lRcEdxSjMySDlwcVpydTVyTjdoUDdLM21lTWYzUE1P?=
 =?utf-8?B?M2plSmw0OC9OZ09vRWM3VjgvanFmZm83YUZUbFZjNUZOd3RrbXJ2MDdTQmNv?=
 =?utf-8?B?RWNkd1RrdHNVQmV2TjhzVlVFMGF6V1pBS0FRRE0vaWM3UHlWNU04b3B3OXdh?=
 =?utf-8?B?a1hCSUpCRjRKTXFjWm5DTHk5YjJMRTVSVnFvK3Vhbm1tNDJMcVFRSGEwR1pL?=
 =?utf-8?B?OGVxaGNKcUJtTVc1c3RJNk9OQWllTThkQ1RId3FjY1Q0WUNWTEpwMUxUNDJO?=
 =?utf-8?B?WUVEd0pqYzlQK2RyditveFhMSVhsNGg4emw5VWtPZUFtYlFlaENxWGJoUFdk?=
 =?utf-8?B?bTM0N2J4eXRhWDF3Y01VakRBNXVJRGw4bXpIV0VJci9UMS9aV21jNnkzcUpP?=
 =?utf-8?B?aStNdEJIQ3FzUDdlZzlHL1c2bDFBTG5EQmVTdS8wRkQySjJReEpQT2cxRFZW?=
 =?utf-8?B?T09peHVlVGRNb3VKZzFWMjBjYXFnYjJya1VFbm1JUkZMZjA0RTF5bHA4MlVD?=
 =?utf-8?B?OFRPQXRnaVJOWDVURXNSRlVyMGJpaWt6SzdHOEVVb0YzNWFaWTBJeTk2OGY1?=
 =?utf-8?B?Wk5lRTNIMFpybjNZWFZRMUlYazRIRDczRklHdXU3N1QxWjRhT1JYNXRxSmIr?=
 =?utf-8?B?N3M4V0pYNXM3dUQ3UHhwSHFhMXR6N0ZKNUtOeVF3T1dmc2dOdiszeW10dU5K?=
 =?utf-8?B?YUkyRUYzcTltT0ttcXdOeTkzanhXRUhkcmFWWmNreXVsOGs0aUF3TUY3cXdS?=
 =?utf-8?B?NDhxZmxnUllNYk9oQU5yejY0ZVdzcDZoeC9KbTcyekZVamZwdnQyVzMwQ1VS?=
 =?utf-8?B?OFMzVzlEeHIrYnRZTm9IbXhGWGJSdGQ5T1lFNG1PdVZKQVZxWEJTZldpcFdx?=
 =?utf-8?B?T21uQTJYRmYwSk1weHZyZWRFa2dZRjdWREJDYm1Tek9nTndXVzNhVTN0ZXBP?=
 =?utf-8?B?SkVnWjdJK3pmcmZWcVpkaTBXa1U4THZ2QXBqRjBoQkpvSlBaNmtnaDdmbC8y?=
 =?utf-8?B?RDU5T2lqZTZIaTM1ZXZ3enFCNzBjOFJOMUNwMXNJeG15ekFIYmtwNjN0THNu?=
 =?utf-8?B?TXZMQzBvVVE3RWUwRldOK2pzNHk4NE5BUDljOGRnbE5oVXA3TTVHRkxhSTJM?=
 =?utf-8?B?K2Yxdzc4c2ZxTGxULzl2Y0FOdHZ4dTJwSHRFQkFOZE9ZU1lrNWIrZ3YxaitD?=
 =?utf-8?B?M0NOemNaRDRJWGpQcXlJL3JjTnl1bzVDRXZkTXMwNkpPaU5HTFdvNDVWMWNs?=
 =?utf-8?B?TVZDOFVJRnozRkVuaUlkSWlPMHhNcDZwa1QyTlZtTWNwUzRzeUNiYkJJeWxE?=
 =?utf-8?B?RThEM1pqN0szamtwVUJ1dXhKb3R0RWVuU3MvTEkwd2wwMkN4NHFqdituTnNQ?=
 =?utf-8?B?UWY3R1V6dWNvQ2tuNmwrSDV4QUFlS1cvcmJmempTMXMxQnZJeGw2UVZYelJl?=
 =?utf-8?B?anJ3WnRZb1NHM3ZISU1acXBoWktNNkZ1NHAydFR6cWFHLzNIdmVQbUNrWGRJ?=
 =?utf-8?B?TXZQWjQwT2w1VGFKUDZ4bElPUjNtcXFsd3g0cFlPYUJ1WnpEbnpFRitUamJH?=
 =?utf-8?B?NUFyOCtQQjBWOEFTVmdwbG5QWGtIS3p5ZE4wNHBHNWlOZHVjSXJFRlJFWDV6?=
 =?utf-8?Q?XOeuDb40FAaSW2uNn+RLiVw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b48ccab-c991-4ec5-f49a-08d9ae7d1b51
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 12:31:00.1589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AKA3GKjrUSefYe11qiSmKs0iwOnaIqZwLeq2sQhCrRY+oh8IgATTw5UTnRQDCEgCj7YVKCAqrxlSo8g2tLkYHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5590
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gcGF0Y2h3b3JrLWJvdCwNCg0KPiBGcm9tOiBwYXRjaHdvcmstYm90K25ldGRldmJwZkBr
ZXJuZWwub3JnIDxwYXRjaHdvcmstDQo+IGJvdCtuZXRkZXZicGZAa2VybmVsLm9yZz4NCj4gDQo+
IEhlbGxvOg0KPiANCj4gVGhpcyBzZXJpZXMgd2FzIGFwcGxpZWQgdG8gbmV0ZGV2L25ldC1uZXh0
LmdpdCAobWFzdGVyKSBieSBUb255IE5ndXllbg0KPiA8YW50aG9ueS5sLm5ndXllbkBpbnRlbC5j
b20+Og0KPiANCj4gT24gTW9uLCAyMiBOb3YgMjAyMSAxMzoxMToxNiAtMDgwMCB5b3Ugd3JvdGU6
DQo+ID4gU2hpcmF6IFNhbGVlbSBzYXlzOg0KPiA+DQo+ID4gQ3VycmVudGx5IEU4MDAgZGV2aWNl
cyBjb21lIHVwIGFzIFJvQ0V2MiBkZXZpY2VzIGJ5IGRlZmF1bHQuDQo+ID4NCj4gPiBUaGlzIHNl
cmllcyBhZGQgc3VwcG9ydHMgZm9yIHVzZXJzIHRvIGNvbmZpZ3VyZSBpV0FSUCBvciBSb0NFdjIN
Cj4gPiBmdW5jdGlvbmFsaXR5IHBlciBQQ0kgZnVuY3Rpb24uIGRldmxpbmsgcGFyYW1ldGVycyBp
cyB1c2VkIHRvIHJlYWxpemUNCj4gPiB0aGlzIGFuZCBpcyBrZXllZCBvZmYgc2ltaWxhciB3b3Jr
IGluIFsxXS4NCj4gPg0KPiA+IFsuLi5dDQo+IA0KPiBIZXJlIGlzIHRoZSBzdW1tYXJ5IHdpdGgg
bGlua3M6DQo+ICAgLSBbbmV0LW5leHQsMS8zXSBkZXZsaW5rOiBBZGQgJ2VuYWJsZV9pd2FycCcg
Z2VuZXJpYyBkZXZpY2UgcGFyYW0NCj4gICAgIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvbmV0ZGV2
L25ldC1uZXh0L2MvMzI1ZTBkMGFhNjgzDQo+ICAgLSBbbmV0LW5leHQsMi8zXSBuZXQvaWNlOiBB
ZGQgc3VwcG9ydCBmb3IgZW5hYmxlX2l3YXJwIGFuZCBlbmFibGVfcm9jZQ0KPiBkZXZsaW5rIHBh
cmFtDQoNCkFib3ZlIHBhdGNoIGhhcyBhIGJ1ZyBhbmQgcmV2aWV3IGNvbW1lbnRzIHByb3ZpZGVk
Lg0K
