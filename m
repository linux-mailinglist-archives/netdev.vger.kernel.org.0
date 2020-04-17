Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FF01AD4EC
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 05:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgDQDoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 23:44:17 -0400
Received: from mail-eopbgr60060.outbound.protection.outlook.com ([40.107.6.60]:51041
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725843AbgDQDoQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 23:44:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/Z1Xkpbo3fTkoZtpiuZTSVjy5BGxp7eOzLPUcpU73EuaUIsYDQWGOsNA++U6T9h0EnZ+3GDSGhqEcf53BOtk5ZpPa+cIW0FeresRWWxhSFGjog9fAjAg+w7gOVV9xevP/8daIxGXM8euvqiPhv0/D7EqzLGOpsJVRPbqBDljLksxvEMVDbqu64pWQgixJcmX3d7H6PLmT8QOMHk26fzWfcn0+MbgUSIMMHoDUoFZpwAChHZl3lWL4B41Nb6N4nBrfXU509aOfYQzWTtLKcTYTWbzzzuCQn/AhxC/rWUMWDbhNsh63idjun6e8CrykQsiqX33FM6MJmJ503CXQ0hew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVK5cTl4/1tYIpsf7nhH+h9xnoGZBUVBHyj9TK9dFcY=;
 b=chFf4//4m6zQEgT1kprBpBt7FOalAuvi9v/6ofMb8w08Xu3gZ4fTGFZiWe4enFkLraBvalB9EBRTzMlJ6OPPjz9T3CZ5bCyMO5rspeAuH2ij39Z1yfsIvfFhp4wnF2dF4MSTaWKN2lBTyT+lnm5L9NX47P5YnkmaO55mhn5YSnWC++N1VUXiYxWvAvoo2araJLj5jwntEuHripA7QmXLNOKeiBzbmq0RYxRt2KfXz5i8Sa+uilRoXyw8Gf2ZczAPldwrKq+qvkCxTyw+OS0k/cddU1hznNl265OK15PysuWIggpyXvTXBKjCS6WjzNy8KTHg6Zy+GuCZkJpxTSVHCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVK5cTl4/1tYIpsf7nhH+h9xnoGZBUVBHyj9TK9dFcY=;
 b=VXVza/TJR5iNlYnaaxTQfE7ydY1FvACjQAvXvaLmQkTK20MS7WDZjxHgD4pheLeUFRq0YuUUBtGtlPPig3x7ZKhiydRDlqE7ulRiWqtVJL4AsV9wDIMay6pHkiwg8cGQ+0TOM+ghQXBEOtr5QxYK07dhPAaG/oIGff+9wXz2qaM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6320.eurprd05.prod.outlook.com (2603:10a6:803:f5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.20; Fri, 17 Apr
 2020 03:44:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.030; Fri, 17 Apr 2020
 03:44:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "xianfengting221@163.com" <xianfengting221@163.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "cai@lca.pw" <cai@lca.pw>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "lsahlber@redhat.com" <lsahlber@redhat.com>,
        "kw@linux.com" <kw@linux.com>,
        "xiubli@redhat.com" <xiubli@redhat.com>,
        "airlied@redhat.com" <airlied@redhat.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wqu@suse.com" <wqu@suse.com>,
        "chris@chris-wilson.co.uk" <chris@chris-wilson.co.uk>,
        "yamada.masahiro@socionext.com" <yamada.masahiro@socionext.com>,
        "stfrench@microsoft.com" <stfrench@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] net/mlx5: add the missing space character
Thread-Topic: [PATCH v2] net/mlx5: add the missing space character
Thread-Index: AQHWCXBS9ROcHN2SK0+YUleKNIIPWqhvqOGAgAw/QICAANnkAA==
Date:   Fri, 17 Apr 2020 03:44:10 +0000
Message-ID: <a77ddcfad6bfd68b9d69e0d5a18cf5d66692d270.camel@mellanox.com>
References: <20200403042659.9167-1-xianfengting221@163.com>
         <14df0ecf093bb2df4efaf9e6f5220ea2bf863f53.camel@mellanox.com>
         <fae7a094-62e8-d797-a89b-23faf0eb374e@163.com>
In-Reply-To: <fae7a094-62e8-d797-a89b-23faf0eb374e@163.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8ac2988c-3df6-42b6-595d-08d7e2819752
x-ms-traffictypediagnostic: VI1PR05MB6320:|VI1PR05MB6320:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6320237E87C8986214487C85BED90@VI1PR05MB6320.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:873;
x-forefront-prvs: 0376ECF4DD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(86362001)(8676002)(6506007)(6512007)(4326008)(2616005)(26005)(53546011)(186003)(7416002)(2906002)(64756008)(6486002)(66946007)(478600001)(66556008)(81156014)(316002)(76116006)(66446008)(5660300002)(54906003)(66476007)(8936002)(71200400001)(966005)(36756003)(110136005)(91956017);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DwkWpGwqTctD892Dj7b+YbE7UnuDRbpmed1IIHPH4amhbLB9z0ylQVb0BTb8wVlTuX0sSLvpsnjDvh/43HrKp8ak+dgzYCc/008jJa5hGx5dPGr9DbWXmDX6xNDf3etdVcuWVpxsyspOHAPyEJM6eTNk9lN22MDpTQLqTmYVcD2taIh0HJoUoCHBcxpF9YyVl0377dMKohnIpPoTssOTnGMg8RDk4rOGoebdUADO0irFsz3qY06bticMgPjr7jUjDldqd6+/TTi4S3UXLQKf+Ts7yef5G+0+5o2QL78IAjzm+e929wdLRrCRHNpMcePIM4cI/IleSQa07jBdM635xQ5s3nDONtLsUpGyw88Xu/tJe2HbCYLcqLQK2E9uISh0MjLiPuk9o58hUyUD25Kbov+8liSrnqcldS76WxGtKX1/IORwRCcJK6w+5umIv5DMDr1eQLOwndDAgE14orzNtjOo+CCvlE0JmRTEm6uRrAOzYuWlOAoxWLVQjRa3FRn1QQzPViBRpXTvJ8FyST/hGg==
x-ms-exchange-antispam-messagedata: QEehV83TyQDWrPPjgHzO3MNHxRexyiJ8cN9+9JAYSB54Jau8OQ+BGOPCrpMxVNIukSTofqJ115AgQGC8VDzt2zEUss+B2RyBbws9PR17Me4/zSUeEm+OsrVqK2RuTr64y7yChX++CU9vCYTaY/ZfXw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <3F37045E54A9BF4EA95688D4A903F82E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac2988c-3df6-42b6-595d-08d7e2819752
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2020 03:44:10.7692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2M3/7VgXSPwwkgCxvavEgvYR3vcKh8IiVBk3UiOAPCmFNMTII8/c/NvhrNavvWqJl5U36ThsG54Zs3ZbH9aUNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6320
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA0LTE2IGF0IDIyOjQ0ICswODAwLCBIdSBIYW93ZW4gd3JvdGU6DQo+IE9u
IDIwMjAvNC85IDM6NDIgQU0sIFNhZWVkIE1haGFtZWVkIHdyb3RlOg0KPiA+IE9uIEZyaSwgMjAy
MC0wNC0wMyBhdCAxMjoyNiArMDgwMCwgSHUgSGFvd2VuIHdyb3RlOg0KPiA+ID4gQ29tbWl0IDkx
YjU2ZDg0NjJhOSAoIm5ldC9tbHg1OiBpbXByb3ZlIHNvbWUgY29tbWVudHMiKSBkaWQgbm90DQo+
ID4gPiBhZGQNCj4gPiA+IHRoYXQgbWlzc2luZyBzcGFjZSBjaGFyYWN0ZXIgYW5kIHRoaXMgY29t
bWl0IGlzIHVzZWQgdG8gZml4IGl0DQo+ID4gPiB1cC4NCj4gPiA+IA0KPiA+ID4gRml4ZXM6IDkx
YjU2ZDg0NjJhOSAoIm5ldC9tbHg1OiBpbXByb3ZlIHNvbWUgY29tbWVudHMiKQ0KPiA+ID4gDQo+
ID4gUGxlYXNlIHJlLXNwaW4gYW5kIHN1Ym1pdCB0byBuZXQtbmV4dCBvbmNlIG5ldC1uZXh0IHJl
LW9wZW5zLA0KPiA+IGF2b2lkIHJlZmVyZW5jaW5nIHRoZSBhYm92ZSBjb21taXQgc2luY2UgdGhp
cyBwYXRjaCBpcyBhIHN0YW5kDQo+ID4gYWxvbmUNCj4gPiBhbmQgaGFzIG5vdGhpbmcgdG8gZG8g
d2l0aCB0aGF0IHBhdGNoLi4ganVzdCBoYXZlIGEgc3RhbmQgYWxvbmUNCj4gPiBjb21taXQNCj4g
PiBtZXNzYWdlIGV4cGxhaW5pbmcgdGhlIHNwYWNlIGZpeC4NCj4gDQo+IFNvcnJ5IGZvciBteSBs
YXRlIHJlcGx5LiBCZWNhdXNlIEknbSBhIGtlcm5lbCBuZXdiaWUsIEkga25vdyBub3RoaW5nDQo+
IGFib3V0IHRoZSBiYXNpYyBtZXRob2RzIGFuZCBtYW5uZXJzIGluIHRoZSBrZXJuZWwgZGV2ZWxv
cG1lbnQuIFRoYW5rcw0KPiBhIGxvdCBmb3IgeW91ciBwYXRpZW5jZSBvbiBteSBtaXN0YWtlLCBw
b2ludGluZyBpdCBvdXQgYW5kIGZpeGluZyBpdA0KPiB1cC4NCj4gDQo+IEJ0dywgZGlkIG5ldC1u
ZXh0IHJlLW9wZW4gYW5kIGRpZCBteSBjaGFuZ2VzIGdldCBpbnRvIHRoZSBtYWlubGluZT8NCj4g
DQo+IA0KDQpOb3JtYWxseSBuZXQtbmV4dCBjbG9zZXMgb25jZSBtZXJnZSB3aW5kb3cgaXMgb3Bl
biBhdCB0aGUgZW5kIG9mDQpyYzcvcmM4IGtlcm5lbCBjeWNsZS4NCg0KYW5kIHJlb3BlbnMgb24g
dGhlIHdlZWsgb2YgdGhlIGtlcm5lbCByZWxlYXNlLCBhZnRlciB0aGUgbWVyZ2Ugd2luZG93DQpp
cyBjbG9zZWQgKDIgd2Vla3MgYWZ0ZXIgcmM3LzggaXMgY2xvc2VkKS4NCg0KeW91IGNhbiB1c2Ug
dGhpcyBsaW5rLg0KaHR0cDovL3ZnZXIua2VybmVsLm9yZy9+ZGF2ZW0vbmV0LW5leHQuaHRtbA0K
DQpPciBqdXN0IG1vbml0b3IgbmV0ZGV2IG1haWxpbmcgbGlzdCBmb3IgYW4gZW1haWwgYW5ub3Vu
Y2VtZW50IGZyb20NCkRhdmlkIE1pbGxlci4NCg0KVGhhbmtzIGFuZCB3ZWxjb21lIHRvIHRoZSBu
ZXRkZXYgZmFtaWx5Lg0KDQoNCiANCg0K
