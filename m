Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C41D5142D9C
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 15:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgATOdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 09:33:05 -0500
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:21216
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726626AbgATOdF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 09:33:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ou9kHeTzkkOmpRFitMbWysf+oTaoNXFLrVw9uLO0EgUitZ0mHep9sgOlPW59/tz93u7X3d7q9E6939WmLh2VoxL3dXJVVKSiGa9wrmYMhxruaFHyWjZJE040jpvbObj1J8TJ/TDBGbZnvBnCg4GmlagVflvEW/H4h1oAVJFvrJvFtHE/w3xzm5rNNCDhzEv9cADQ4qVlgpbXjlC8QciWtHVeLOOzOFljQmoSMRSU9J4XwKqmqaeG8Fhoo8pF2AiLV3SOBgBEib5zJVkyWyrR2PC6ER8LVmOYU0u5e5JnylGoK9JgO4Tt1+XMAQ4rcqV/jOe/4ilvN+2KtrQ1ixQdcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HSRMYB264xql+1gygPffMDermrw8b2DCsztzjX+NsoU=;
 b=SFAt540gumtXNPv0xrLP2gFHKhrAru1mvwh5ZGZpNT2kywWL9ANYlx0M2YyNaO0Oa7wWYMSxvfDUch4PrCh2P0FcRoOz/h1U/hp5OlatXwNKC1keBL2YKPCaUXouHZafwkeSXVsWp8Aq5J4b4rliiWqfU4e+YFVJ9u8yPIb1kD+nM16cL9YpLl3kvSHYt3MPACmYPQi6Z6fgAhzuJJLur+XySmdAno/tQM4Lt7nzxIKQBFe0jbRik6tTJyu3rq8JKXJQHC1dOtR4Yyj5Oh4RW/MwhiCYo1cpd7FK/mXnmz7rGlxWFE3dqJsffka/dzi/GiG9lY/uVtdRedsgq6WKpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HSRMYB264xql+1gygPffMDermrw8b2DCsztzjX+NsoU=;
 b=YZvTG9kds6c0naaKy0YiDU3yw5+3m+j0faHiOa9G23hnKibEgqKvAppBuXzZrTrM6TRrRa15KICiXEfnL8flUUh2VuUgHRtWTsI2axuJ/kjAXJb2FSmINaLQ+i7n5u+ZwcH5H1eoFWPgfAMhtspNXrzEmZOFET06BtiFAosfMWY=
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB6278.eurprd05.prod.outlook.com (20.179.4.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Mon, 20 Jan 2020 14:33:01 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::b826:4acc:6d53:6eea]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::b826:4acc:6d53:6eea%6]) with mapi id 15.20.2644.026; Mon, 20 Jan 2020
 14:33:01 +0000
Received: from [10.223.6.3] (193.47.165.251) by AM4PR0501CA0044.eurprd05.prod.outlook.com (2603:10a6:200:68::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Mon, 20 Jan 2020 14:33:00 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Chen Wandun <chenwandun@huawei.com>, Oz Shlomo <ozsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH next] net/mlx5: make the symbol 'ESW_POOLS' static
Thread-Topic: [PATCH next] net/mlx5: make the symbol 'ESW_POOLS' static
Thread-Index: AQHVz4z4MbwU/ZZ3F0K3BG09U5KYx6fznesA
Date:   Mon, 20 Jan 2020 14:33:01 +0000
Message-ID: <846abf8c-8c81-a054-9f89-4ad56b104d99@mellanox.com>
References: <20200120124153.32354-1-chenwandun@huawei.com>
In-Reply-To: <20200120124153.32354-1-chenwandun@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR0501CA0044.eurprd05.prod.outlook.com
 (2603:10a6:200:68::12) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 27ff6410-d8e5-4736-3582-08d79db5a719
x-ms-traffictypediagnostic: AM6PR05MB6278:|AM6PR05MB6278:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB6278AB3613C84D6C7D38D519CF320@AM6PR05MB6278.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1107;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(189003)(199004)(16526019)(478600001)(52116002)(5660300002)(316002)(186003)(16576012)(110136005)(71200400001)(2906002)(36756003)(31686004)(6486002)(26005)(66446008)(956004)(2616005)(53546011)(86362001)(8676002)(81156014)(66556008)(8936002)(64756008)(66946007)(66476007)(81166006)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6278;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y0LWz+GgaOsGrO1nLw0H5C7WJTvYGa0H1R49gvZKfC+KvwDbo+LrV1M6ahycH8JqAFLoX81kkqANg/h+jV5kxi3c1DgzW/W5aYqBuPvJ56ZziMa/Z5HCGCpbWFeStk/SEwJZmKkOUFy/YZfD8s6+ie8caVcMNEq9buw02N5bttUH4mxypwCw7j5LiA7rdqdLEr64UAnRtdEhqGLrVfEDHQOaMk+GHWGXiKL6kaoBJqfMet3dztqp2NnKJUeWt3VzBqQWiqi5RfEtwXyhkpMrtFpwlRCynBvsrF9tiR9naJevec7t23RZQb8JrNVpNdtjr6+OOZGesGxPddYSmoge1/AWh26ZxmoM03pTnLw/cSFonl/EQqbaDcU/h0dGla9h0XGSK4pmWPRyYThkWJcMi00Xqzs40Dgau2SGXNtobdraMy9WvxOtF/dfXZlwL3it
Content-Type: text/plain; charset="utf-8"
Content-ID: <45700E2169234948A2BBC279D349EBAD@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27ff6410-d8e5-4736-3582-08d79db5a719
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 14:33:01.5922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /c5Q6bWf+k1UHxK/RRT0N7o53g3s3U1HGrzgLw9qeJ6OijbnTNPIZl9cDKvaTSJivJmiaJSXMhaU02xY86eGbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6278
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzIwLzIwMjAgMjo0MSBQTSwgQ2hlbiBXYW5kdW4gd3JvdGU6DQo+IEZpeCB0aGUgZm9s
bG93aW5nIHNwYXJzZSB3YXJuaW5nOg0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fkc19jaGFpbnMuYzozNToyMDogd2FybmluZzogc3ltYm9s
ICdFU1dfUE9PTFMnIHdhcyBub3QgZGVjbGFyZWQuIFNob3VsZCBpdCBiZSBzdGF0aWM/DQo+DQo+
IEZpeGVzOiAzOWFjMjM3Y2UwMDkgKCJuZXQvbWx4NTogRS1Td2l0Y2gsIFJlZmFjdG9yIGNoYWlu
cyBhbmQgcHJpb3JpdGllcyIpDQo+IFNpZ25lZC1vZmYtYnk6IENoZW4gV2FuZHVuIDxjaGVud2Fu
ZHVuQGh1YXdlaS5jb20+DQo+IC0tLQ0KPiAgIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZXN3aXRjaF9vZmZsb2Fkc19jaGFpbnMuYyB8IDggKysrKy0tLS0NCj4gICAxIGZpbGUgY2hh
bmdlZCwgNCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2ZmbG9hZHNf
Y2hhaW5zLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRj
aF9vZmZsb2Fkc19jaGFpbnMuYw0KPiBpbmRleCAzYTYwZWI1MzYwYmQuLmM1YTQ0NmUyOTVhYSAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vz
d2l0Y2hfb2ZmbG9hZHNfY2hhaW5zLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2ZmbG9hZHNfY2hhaW5zLmMNCj4gQEAgLTMyLDEwICsz
MiwxMCBAQA0KPiAgICAqIHBvb2xzLg0KPiAgICAqLw0KPiAgICNkZWZpbmUgRVNXX1NJWkUgKDE2
ICogMTAyNCAqIDEwMjQpDQo+IC1jb25zdCB1bnNpZ25lZCBpbnQgRVNXX1BPT0xTW10gPSB7IDQg
KiAxMDI0ICogMTAyNCwNCj4gLQkJCQkgICAxICogMTAyNCAqIDEwMjQsDQo+IC0JCQkJICAgNjQg
KiAxMDI0LA0KPiAtCQkJCSAgIDQgKiAxMDI0LCB9Ow0KPiArc3RhdGljIGNvbnN0IHVuc2lnbmVk
IGludCBFU1dfUE9PTFNbXSA9IHsgNCAqIDEwMjQgKiAxMDI0LA0KPiArCQkJCQkgIDEgKiAxMDI0
ICogMTAyNCwNCj4gKwkJCQkJICA2NCAqIDEwMjQsDQo+ICsJCQkJCSAgNCAqIDEwMjQsIH07DQo+
ICAgDQo+ICAgc3RydWN0IG1seDVfZXN3X2NoYWluc19wcml2IHsNCj4gICAJc3RydWN0IHJoYXNo
dGFibGUgY2hhaW5zX2h0Ow0KDQpBY2tlZC1ieTogUGF1bCBCbGFrZXkgPHBhdWxiQG1lbGxhbm94
LmNvbT4NCg0K
