Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 335731439DD
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 10:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgAUJxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 04:53:41 -0500
Received: from mail-db8eur05on2071.outbound.protection.outlook.com ([40.107.20.71]:6035
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728682AbgAUJxk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 04:53:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lB58Nrmu1v6DJyVmscI5ku4OYrAupBYiV769nNaQ3OWSULXXEkhrQ+uisicZmN5iEu+3sA1jQVS7KgpyBHmEtJ3O+UTSjQqNTwkRlKmN4q/Q8MWYZf+XEdzC2pFPrg/5jFS+lGhRPi+SXegqGrLI15dvqmo3EYokP6WxvAS1iBVRuLEU8vgHzR7SQM2zW1hdV+hhP4h0CO0AY9YFX34TPWg9kCQ7TvnR6ES5ked1xLYDCPVgiP+UqwnHinUrrSI42xlvyzY5wxsST5aHRSQmcer3Ct648Bipy2MV6KT0ooLzG6gBUElC355RpSFE3qFKwOQ34LAW1zbhm8pMPR1yNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzYSJwpWcUmTH/QyAN9MayQQCwg9qbayPihyVqbK6rU=;
 b=Jje14zPQ6E15im3//YZ9u1PNvNtYY5WlDfrNmrZ3BUgmJCioIxQSf3ci+7CHds5FukNaKRpvkH0aVPcC5h1jJQwVafxFKklYFUMrS9WbC9S0q8OiaZ0gcG49FuttEy1XQKkLo0c5KXnJXR2zlIAVqrce9LMoLjZXW6aodisI/grVHpVTpO0TJd8X9M0SmPSdYOI6lec2FeO/AefwuhpUz8ZSGRvFFmDRTGM9ntj6zArPWfdULnS+7rTMHQC9ABTJB/7+4Ll33Zmdgf0athZXCCdv3zVvs+2m0lJl5fjQSlZDLrkicyqsf5wpeGEcJeT0UChYJ+ltSL9anwPrxlwKAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzYSJwpWcUmTH/QyAN9MayQQCwg9qbayPihyVqbK6rU=;
 b=tLn6eFspxUtdg3gY2ir/jgkUNpfmIkLByOl31V0TrQ5iA8NTYDLiNsq+L95fAEKyvJX6wwfQmQyXqNrJODtozteah8YD0IX7gqo6O+JhsyzCSeuuknS4kxivYwIO9BLGJ/+yxigLNl9jRrOWSpdixktMoHl2Mfde1rzJ5a5WLRY=
Received: from AM4PR05MB3396.eurprd05.prod.outlook.com (10.171.187.33) by
 AM4PR05MB3379.eurprd05.prod.outlook.com (10.171.187.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.22; Tue, 21 Jan 2020 09:53:37 +0000
Received: from AM4PR05MB3396.eurprd05.prod.outlook.com
 ([fe80::4ddd:bf4e:72d0:a720]) by AM4PR05MB3396.eurprd05.prod.outlook.com
 ([fe80::4ddd:bf4e:72d0:a720%2]) with mapi id 15.20.2644.026; Tue, 21 Jan 2020
 09:53:37 +0000
Received: from [10.223.0.122] (193.47.165.251) by AM0PR04CA0033.eurprd04.prod.outlook.com (2603:10a6:208:122::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Tue, 21 Jan 2020 09:53:36 +0000
From:   Roi Dayan <roid@mellanox.com>
To:     Or Gerlitz <gerlitz.or@gmail.com>
CC:     "xiangxia.m.yue@gmail.com" <xiangxia.m.yue@gmail.com>,
        "saeedm@dev.mellanox.co.il" <saeedm@dev.mellanox.co.il>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net/mlx5e: Don't allow forwarding between
 uplink
Thread-Topic: [PATCH net-next v2] net/mlx5e: Don't allow forwarding between
 uplink
Thread-Index: AQHVzm+0iTkXevcup0KpUu205nAhlaf04IAAgAACwYCAAAEpAA==
Date:   Tue, 21 Jan 2020 09:53:36 +0000
Message-ID: <7d007a9e-5c00-e4e4-4908-0922427986f5@mellanox.com>
References: <1579400705-22118-1-git-send-email-xiangxia.m.yue@gmail.com>
 <73d77bc7-6a1b-44de-a45f-967bbda68894@mellanox.com>
 <CAJ3xEMiiYaJ0QorDyKqpo6cpfhQ1k9HV3z=4=5FpB_q9h4ffOA@mail.gmail.com>
In-Reply-To: <CAJ3xEMiiYaJ0QorDyKqpo6cpfhQ1k9HV3z=4=5FpB_q9h4ffOA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
x-clientproxiedby: AM0PR04CA0033.eurprd04.prod.outlook.com
 (2603:10a6:208:122::46) To AM4PR05MB3396.eurprd05.prod.outlook.com
 (2603:10a6:205:5::33)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cbd6fdd0-2b7e-4fbe-be9b-08d79e57c8ff
x-ms-traffictypediagnostic: AM4PR05MB3379:|AM4PR05MB3379:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB33792278CD3BC183FCEB9205B50D0@AM4PR05MB3379.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(346002)(39860400002)(136003)(199004)(189003)(53546011)(54906003)(52116002)(4326008)(31686004)(66946007)(16576012)(26005)(66556008)(81166006)(6916009)(64756008)(66476007)(16526019)(186003)(81156014)(8676002)(6486002)(2906002)(5660300002)(66446008)(31696002)(36756003)(316002)(8936002)(2616005)(478600001)(71200400001)(956004)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3379;H:AM4PR05MB3396.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cnswuUjAivoGlWTqvohMckH7kWt2R9dx9cdL8NHgY2l9db8CMZtPxxnZ1e79g3vjAaRLXBbncpedVxb0dJmAKn2EVmFAfzx8zOPenfSq6UnmWcazzW5fPlo3+mhkkcp+1G8CQqQV8eJXZRuGFVv/DNUDFcONZVHNSjPdKj1xHlQW03R3mFJLeXNOe6pssDjVA/T2zjMVInpOhroCEgmy3eDm8Mk58QavNWPxtaBJjA+GqyTBuKvpkIFAS1gvWIf6XelWh3KBNmLB+bDJjMdH5l8tbe7oFv1YPByN6xyaT0D1Y79vvHFBEUygOWUwE1SDl1ICp9PnLFmYzy+IcCJl/aL12C+5yAtYYKPJljEtZoqxIGSqbZsLqs3AKI7tMxrO9nxJwqZ0gUfLM46VcMx+FwBwyprqYYwz1BDA1wwjYdRAmqkYRcxhcQxgvzqmoTT+
Content-Type: text/plain; charset="utf-8"
Content-ID: <0BE429D4CDAE8847970CF03CC6CD8B56@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbd6fdd0-2b7e-4fbe-be9b-08d79e57c8ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 09:53:36.9150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UdOXavv+MU8IQ62rHYsmTIFPtqiVVm6W0/t592BI1CZQQxd7HeHSVURWc9Tfh38SGE9C5lxRHfRzPmE8uZoXaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3379
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIwMjAtMDEtMjEgMTE6NDkgQU0sIE9yIEdlcmxpdHogd3JvdGU6DQo+IE9uIFR1ZSwg
SmFuIDIxLCAyMDIwIGF0IDExOjM5IEFNIFJvaSBEYXlhbiA8cm9pZEBtZWxsYW5veC5jb20+IHdy
b3RlOg0KPj4gT24gMjAyMC0wMS0xOSA0OjI1IEFNLCB4aWFuZ3hpYS5tLnl1ZUBnbWFpbC5jb20g
d3JvdGU6DQo+IA0KPj4gSSBub3RpY2VkIHlvdSBzdGlsbCBtb2RpZmllZCBtbHg1ZV9pc192YWxp
ZF9lc3dpdGNoX2Z3ZF9kZXYoKSB3aGljaA0KPj4gaXMgY2FsbGVkIGZyb20gcGFyc2UgdGMgYWN0
aW9ucyBhbmQgYWxzbyBmcm9tIHJlc29sdmluZyByb3V0ZSBmb3IgdnhsYW4gcnVsZXMuDQo+Pg0K
Pj4gSSB0ZXN0ZWQgdGhlIHBhdGNoIGZvciBub3JtYWwsIGxhZyBhbmQgZWNtcCBtb2Rlcy4NCj4+
IGVjbXAgdnhsYW4gZW5jYXAgcnVsZSBicmVha3Mgbm93IGFzIG5vdCBzdXBwb3J0ZWQuDQo+PiB0
aGUgYnJlYWsgaXMgaW4gZ2V0X3JvdXRlX2FuZF9vdXRfZGV2cygpIGF0IHRoaXMgcGFydA0KPj4N
Cj4+IGVsc2UgaWYgKG1seDVlX2Vzd2l0Y2hfcmVwKGRldikgJiYNCj4+ICAgICAgICAgICAgICAg
ICAgbWx4NWVfaXNfdmFsaWRfZXN3aXRjaF9md2RfZGV2KHByaXYsIGRldikpDQo+Pg0KPj4gc2lu
Y2UgZWNtcCBpcyBsaWtlIGxhZyB3ZSBmYWlsIG9uIHRoZSBzYW1lIHNjZW5hcmlvIGhlcmUgdGhh
dA0KPj4gd2UgdGVzdCB1cGxpbmsgcHJpdiBidXQgbm90IGlucHV0IHZwb3J0Lg0KPiANCj4gR3V5
cywNCj4gDQo+IEkgdGhvdWdodCB3ZSBhZ3JlZWQgdG8gaG9sZCBvbiB3aXRoIGJsb2NraW5nIHRo
aXMgaW4gdGhlIGRyaXZlciAtDQo+IHNob3VsZCAxc3Qgc2VlIHRoYXQgdGhlIEZXIGlzIGZpeGVk
Lg0KPiANCg0KdGhlIGludGVybmFsIHRpY2tldCBpcyBlbm91Z2ggZm9yIHRyYWNraW5nLg0KYXMg
bG9uZyBhcyBmdyBpcyBub3QgZml4ZWQgd2UgaGF2ZSBhbiBpc3N1ZSB0aGUgcnVsZSBpcyBub3Qg
d29ya2luZw0KcHJvcGVybHkgc28gdGhpcyBmaXggaXMgYWN0dWFsbHkgbW9yZSBuZWVkZWQgbm93
IGFzIHdlIGFkZCBhIHJ1bGUNCnRvIGZ3IHRoYXQgYWN0dWFsbHkgYmxvY2tzIHJlcXVlc3RlZCB0
cmFmZmljLg0K
