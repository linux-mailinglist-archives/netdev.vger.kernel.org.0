Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 670DC147992
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 09:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgAXIq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 03:46:28 -0500
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:13952
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727520AbgAXIq2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 03:46:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MeEUbpztHQauHe+73n3aibbRq391GWWPfJJ9naVUJebXG4JRJB9PNQXW+KqBBHSXT6++iq7xstdzmLQDFJaRfws+fw9mYYPlrbjIYW6ltupQ24noh0nbBHeTF2aUJRDfl1MKZWp6EOUwO2OhFJLCVMwr0sfpf2Qc+lPs+pSvC9pY222wowtxhHVVzP0Rm4xe3/mkG8g5+1HBX5t7N+P/ZdDvy9Pt44PS5UOSGraJkfGUM6FJ2JT0poG17pvPtZk5sUg1DYcQU2vCuB3g2lEqxV4ptAQfneSJ5W5DmgT8sAKYQ9Pa+Rv93k4KdeOM0xAXBovO3ibqsz83SiU4u2MiiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGpiu0jsJ1SAF/Q/L3tW3gMQOmIwFGRNDQL2GOaneEQ=;
 b=MLIo9EP29++2zi5x1aUGDIf+AiCNky5ounW84O1hjeqxjMrzLzQzBh/1g/wDd6b4x956oHT8XyBQvz8MY6CFLRPx+6BdWqIckk6Hg59qbIpr4Ph4zixaB2rX1FaDtRH4g7Y8toYKxBwHIAAWUA9Hs+6Yus5Lb7O9Ji9DPQlD9e5Ov+wBf5U6XAj8n6yndtE4F8uGwSr4w91/R+3B+2hwsjqRa9qs0gVp7aN7Qn4jDAaCUeLvYZ8eD/FDN5HA54QD6ivWrDr5Zuim4mkw/v/wwicq4lCIcfdvGDfF84f99y1rs7jbdFhMgCMBUnwW+acbMl5Zh71C1LWHtCYvjOd+5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGpiu0jsJ1SAF/Q/L3tW3gMQOmIwFGRNDQL2GOaneEQ=;
 b=dC0izRhiN9m8YQeDBcKoexbdmYw/xCFRrv/z+bvi7VPckOK6QqcvUdleVSHNvB26RINNnCtMST48cpcnx/BH6VUb0C3cYe252p5HkPnUi719VIDCqY0HtXx9vMszSgy1EVKq0aJeaYOyinMDxR+8o1jOp5SgbaMB+7Z4/zxoWvQ=
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB4999.eurprd05.prod.outlook.com (20.177.32.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Fri, 24 Jan 2020 08:46:22 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::b826:4acc:6d53:6eea]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::b826:4acc:6d53:6eea%6]) with mapi id 15.20.2644.028; Fri, 24 Jan 2020
 08:46:22 +0000
Received: from [192.168.50.105] (77.138.239.18) by PR0P264CA0055.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Fri, 24 Jan 2020 08:46:21 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next v2 01/13] net: sched: support skb chain ext in tc
 classification path
Thread-Topic: [PATCH net-next v2 01/13] net: sched: support skb chain ext in
 tc classification path
Thread-Index: AQHV0StRd72ZLaR5uUeXxUCz59wH16f2zxMAgAK0FQA=
Date:   Fri, 24 Jan 2020 08:46:22 +0000
Message-ID: <ca08ea10-cf6a-e8ed-afda-54ac301660ad@mellanox.com>
References: <1579701178-24624-1-git-send-email-paulb@mellanox.com>
 <1579701178-24624-2-git-send-email-paulb@mellanox.com>
 <20200122072916.23fc3416@cakuba>
In-Reply-To: <20200122072916.23fc3416@cakuba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0055.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::19) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [77.138.239.18]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1fb9bbec-abfb-489f-179a-08d7a0a9e389
x-ms-traffictypediagnostic: AM6PR05MB4999:|AM6PR05MB4999:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB49999CC43592D3EE5F7825E6CF0E0@AM6PR05MB4999.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(366004)(376002)(39860400002)(189003)(199004)(2616005)(956004)(478600001)(31686004)(64756008)(186003)(16526019)(31696002)(66556008)(66946007)(26005)(66476007)(4326008)(86362001)(66446008)(52116002)(53546011)(5660300002)(107886003)(54906003)(71200400001)(6486002)(81156014)(36756003)(8936002)(2906002)(16576012)(8676002)(316002)(6916009)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4999;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0SV6Z3lJXFH2jgmW1l73ZO+tzPsW6tC14oJQFdPc9+RFl/Nmg28rvyHPTtq9wgyYsghOLyLpcX9Uzz0M6IcQvT2Kk0bTwFn/gyz1C89CzG/07sfinXfT286pH8dLlo0jwiwnxFN0QAmn+iwK5We5ftqwo36DjjaDYSSqoAvCcpCZVFQ3hO8oSE4HkdM4L7K98AUgZBTyzRNpsW1ZMf2cYRWTFDLM5YAweq6ml9IQ8D17ejU+oM5h0/nnZztM6DHKVjvz+EpmQpO/q5YLyGTSExD5iuXSt9rCJJvowxr5dwpfwDD6ikPow2xU80cQVt/JvdZG0oUPiPTHYvA8uYVMV/gxDhigF64Adcdl2A4nTm+DU2YGmYg8t6SJ90uCsWHlq3ZakgAhPm/umw+lrcTVrVHPLwfOpwaW04/F7UZJBWEIIO1DU9SFHcaGkDqvYgQK
Content-Type: text/plain; charset="utf-8"
Content-ID: <D374E5E74FA90646AB5F05ADB623D50C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fb9bbec-abfb-489f-179a-08d7a0a9e389
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 08:46:22.5253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SogNR34UXnogT/ylxEJyPdKrRqTqsN3+g8n8+prCzXTeVwJ/AsNj9rtM450oW3RMleiiE8efSbvtUHcIigX+Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4999
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyMi8wMS8yMDIwIDE3OjI5LCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gT24gV2VkLCAy
MiBKYW4gMjAyMCAxNTo1Mjo0NiArMDIwMCwgUGF1bCBCbGFrZXkgd3JvdGU6DQo+PiAraW50IHRj
Zl9jbGFzc2lmeV9pbmdyZXNzKHN0cnVjdCBza19idWZmICpza2IsDQo+PiArCQkJIGNvbnN0IHN0
cnVjdCB0Y2ZfYmxvY2sgKmluZ3Jlc3NfYmxvY2ssDQo+PiArCQkJIGNvbnN0IHN0cnVjdCB0Y2Zf
cHJvdG8gKnRwLCBzdHJ1Y3QgdGNmX3Jlc3VsdCAqcmVzLA0KPj4gKwkJCSBib29sIGNvbXBhdF9t
b2RlKQ0KPj4gK3sNCj4+ICsJY29uc3Qgc3RydWN0IHRjZl9wcm90byAqb3JpZ190cCA9IHRwOw0K
Pj4gKw0KPj4gKyNpZiBJU19FTkFCTEVEKENPTkZJR19ORVRfVENfU0tCX0VYVCkNCj4+ICsJew0K
Pj4gKwkJc3RydWN0IHRjX3NrYl9leHQgKmV4dCA9IHNrYl9leHRfZmluZChza2IsIFRDX1NLQl9F
WFQpOw0KPj4gKw0KPj4gKwkJaWYgKGV4dCAmJiBleHQtPmNoYWluICYmIGluZ3Jlc3NfYmxvY2sp
IHsNCj4+ICsJCQlzdHJ1Y3QgdGNmX2NoYWluICpmY2hhaW47DQo+PiArDQo+PiArCQkJZmNoYWlu
ID0gdGNmX2NoYWluX2xvb2t1cF9yY3UoaW5ncmVzc19ibG9jaywNCj4+ICsJCQkJCQkgICAgICBl
eHQtPmNoYWluKTsNCj4+ICsJCQlpZiAoIWZjaGFpbikNCj4+ICsJCQkJcmV0dXJuIFRDX0FDVF9V
TlNQRUM7DQo+PiArDQo+PiArCQkJdHAgPSByY3VfZGVyZWZlcmVuY2VfYmgoZmNoYWluLT5maWx0
ZXJfY2hhaW4pOw0KPj4gKwkJfQ0KPiBEb2Vzbid0IHRoaXMgc2tiIGV4dCBoYXZlIHRvIGJlIHNv
bWVob3cgImNvbnN1bWVkIiBieSB0aGUgZmlyc3QgbG9va3VwPw0KPiBXaGF0IGlmIHRoZSBza2Ig
ZmluZHMgaXRzIHdheSB0byBhbiBpbmdyZXNzIG9mIGFub3RoZXIgZGV2aWNlPw0KW1Jlc2VuZGlu
ZyB0aGlzIHJlcGx5IGFnYWluLCBhcyBvcmlnaW5hbCByZXBseSB3YXMgcmVqZWN0ZWRdDQoNCkdv
b2QgcG9pbnQsIFRoaXMgYWxzbyBhcHBsaWVzIHRvIHJlY2xhc3NpZnkuDQpTaW1wbHkgY29uc3Vt
aW5nIHRoZSBza2IgZXh0ZW5zaW9uIHdpbGwgbm90IGhhbmRsZSB0aGUgdGMgbWlzcyBwYXRoIHRv
IG92cy4NCg0KSSB3aWxsIHBvc3QgYSB2MyB3aGVyZSB0aGUgc2tiIGV4dGVuc2lvbiB3aWxsIGJl
IGluaXRpYWxpemVkIHdpdGggdGhlIGxhc3QgcHJvY2Vzc2VkIGNoYWluLg0KDQo+DQo+PiArCX0N
Cj4+ICsjZW5kaWYNCj4+ICsNCj4+ICsJcmV0dXJuIHRjZl9jbGFzc2lmeShza2IsIHRwLCBvcmln
X3RwLCByZXMsIGNvbXBhdF9tb2RlKTsNCj4+ICt9DQo+PiArRVhQT1JUX1NZTUJPTCh0Y2ZfY2xh
c3NpZnlfaW5ncmVzcyk7DQo=
