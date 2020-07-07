Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715FF21648E
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 05:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgGGD3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 23:29:23 -0400
Received: from mail-am6eur05on2059.outbound.protection.outlook.com ([40.107.22.59]:25659
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727963AbgGGD3X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 23:29:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DzTrApKcsbsmv2jL9svTnbI+fehi3xYxR+mU7LWj7bXS8pKxIFMYzIFyH4WgkyyF9KDqFUHcUPdyD+mdwL0g1qogT5gazPYMjP5n2ShTsDdRqxz6kaqcE4fUrX05xVyfLLL+82GtutkJLjytPKX21v8BVV4gmBQXQ8fGZG4f+VZjnuHdgcQT2RPby2FwvNcmeCweExQ2ZidC6Fq+AJdJrpLf4fAqS/9J4JH6q5+vXdAG4ExELiibrzErO7snbd5sN7/03SUbfjMFggnbMQVbSNhVBqV2Mqy+KkueLj9kUZ1lPcZm/pbVw/pHo6Ii8XE42w7FEYYdPSzQN2ReSGKGpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UuJsvtOjk5uUG3dP5J1S3E3bPXv5N2u7SzB1oZmgYrc=;
 b=fBaZdkY227WlkaYW2Agy5QmQWvqqHB5/htbNd6NMp5JdFCecWUG8xWqzFTHC7uamdWWGjcJAMpgPZ2f7tuKGBoZYfIsauRd3xzvX6QH/xVjORAG5yJe0qYSmhRUoZlvSiUbyehH1LmKoj3MGRNVVKeMgTRocTc9OV2ujhdRJkvV4gREF11SSPa7gjzT/9kMq0mckO9TPZSWld3+PSFI1X7RWu+jMe2RufRjY8qLqLnRAGuBwhX9SLdGEXduir+1Rn0fCEWm3K5RbhX0pCJkYuz2klehoPPrXHrEgAigpQqVrsWge7S0NvZdlfEJvEHufbuasZtA6/Pmz2CLn+9xRRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UuJsvtOjk5uUG3dP5J1S3E3bPXv5N2u7SzB1oZmgYrc=;
 b=SHWhEMmCd9j44tPjrKqhznJ12REUzqXNp/BG8H+eHtBZT2D0gJUoePBzO0YAMCxgrGdeezbUYDuK22pxEQSlMj4wioMafEohO7+YKZqYBA/iYUdJSBoNp5z76fYYlYd1eTChvM5R26falS9UdM9kPPQK6ZWwe2D7gS7mO+6zcwM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4512.eurprd05.prod.outlook.com (2603:10a6:803:44::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Tue, 7 Jul
 2020 03:29:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 03:29:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        Ron Diskin <rondi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net 02/11] net/mlx5e: Fix multicast counter not up-to-date in
 "ip -s"
Thread-Topic: [net 02/11] net/mlx5e: Fix multicast counter not up-to-date in
 "ip -s"
Thread-Index: AQHWUL8B0dTQ7515okubmzIlcDj/s6j1FnWAgAAg54CAAAsHgIAAHreAgADE1wCABNMaAIAABLQAgABi+oCAAASjgIAAFrqA
Date:   Tue, 7 Jul 2020 03:29:18 +0000
Message-ID: <c1b6c9e627d83d47aaa43e44154b340e65880344.camel@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
         <20200702221923.650779-3-saeedm@mellanox.com>
         <20200702184757.7d3b1216@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <3b7c4d436e55787fff3d8d045478dd4c08ba1d19.camel@mellanox.com>
         <20200702212511.1fcbbb26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <763ba5f0a5ae07f4da736572f1a3e183420efcd0.camel@mellanox.com>
         <20200703105938.2b7b0b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <a8ef2aece592d352dd6bd978db2d430ce55826ed.camel@mellanox.com>
         <20200706125704.465b3a0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <f5ddd73d9fc5ccdf340de0c6c335888de51d98de.camel@mellanox.com>
         <20200706190755.688f6fa7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200706190755.688f6fa7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bbdc39bf-ad64-484b-d97f-08d82225eec3
x-ms-traffictypediagnostic: VI1PR05MB4512:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4512A5B72F08F0D042439562BE660@VI1PR05MB4512.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0457F11EAF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Oe49Gczco6oyL32S+s6ehbxtehxnoLw3PJUSQZswdCGYW6U+mgvKO8fNO2aq4qMntgayUp6VvDOh6K4MRGJ98401J4TNB3InkiechfSATkI92AKNZ7d3rvqZwb7tptAAogKv1MlFnZ/1fHcywuq0S8vSZl3w6+ZZzoNocXl4P8x93WY6+1QSYnIcbCArUqQFIBVkbwukSlLFyeiAazOT4JOeJj9hE+BpfeaihLzxJSU0duLtVzfcZk9JOqHPhaesGK8frHOTzq5efWt/n1bDRF40JWOOpwE/ARVxuN/kN6471niybbkKgz06fdDfPxj3Y6I6UsUlckcwkC2CNe9zHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(346002)(396003)(39860400002)(26005)(6506007)(71200400001)(6512007)(36756003)(4326008)(2906002)(8676002)(86362001)(66446008)(64756008)(66556008)(66476007)(186003)(8936002)(478600001)(316002)(6916009)(83380400001)(2616005)(6486002)(76116006)(66946007)(54906003)(5660300002)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: NQzAFrDUoRSGWN2tld1pQYQh5LVz6NYXLyJ8Fmlo3kqAx9li3RiRuL87lWnWyEKQbbYhrV8Nbr5tGfgNXtPeN+rGdRdfdyyF1/lS5ZxdYo4m4zP290IVjkDT3TWxMOEXcR65zgI2RgvgOjdlUzY6NwgOL/+FCcueQRC1r7zeP9cdTYBFrW9GJFkaTnYDJn1F6hgsqPuMPntX7cTmbnxk7LHVWJFwKNlVKJMWIhd0YRdLbNf9OpIedZgOPqLNca/caaOUwl5iBux7n5uM1gR2E8m4v7BmqUfz1CvYOyFvGTEOC4U2l0EM5qbJ5AlIX3DiTa63YNQ9SrkXy5lDpls5kVLTALDW71/3TjQmKDivTvZDBpDNz8o/czdPHSiyVeygg1wMbHqwyCJbVy0oIZ6pYQ9Kx6sNZc7BAQY5le1S/EBraklreq4vcnI6AeLllPQLWXEnKsN1PvYN4N9cAXOHD/wF9ovVC13KBKkLStQYOEQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <12BEAAE82DE2634B89FF7045F582B33A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbdc39bf-ad64-484b-d97f-08d82225eec3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2020 03:29:18.7122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: guBucTZvdHsbvNCdyJZbehHIvv2s2JeUpBiG6epnsJ2JIRqfnSryFrC/jHqTT4OKw0IK+2QOIXYJ5+wcwevh8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA3LTA2IGF0IDE5OjA3IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCA3IEp1bCAyMDIwIDAxOjUxOjIxICswMDAwIFNhZWVkIE1haGFtZWVkIHdyb3Rl
Og0KPiA+ID4gQWxzbyBsb29rcyBsaWtlIHlvdSByZXBvcnQgdGhlIHRvdGFsIG51bWJlciBvZiBt
Y2FzdCBwYWNrZXRzIGluDQo+ID4gPiBldGh0b29sDQo+ID4gPiAtUywgd2hpY2ggc2hvdWxkIGJl
IGlkZW50aWNhbCB0byBpcCAtcz8gSWYgc28gcGxlYXNlIHJlbW92ZQ0KPiA+ID4gdGhhdC4gIA0K
PiA+IA0KPiA+IHdoeSA/IGl0IGlzIG9rIHRvIHJlcG9ydCB0aGUgc2FtZSBjb3VudGVyIGJvdGgg
aW4gZWh0dG9vbCBhbmQNCj4gPiBuZXRkZXYNCj4gPiBzdGF0cy4NCj4gDQo+IEkgZG9uJ3QgdGhp
bmsgaXQgaXMsIFN0ZXBoZW4gYW5kIEkgaGF2ZSBiZWVuIHRyeWluZyB0byBjYXRjaCB0aGlzIGlu
DQo+IHJldmlldyBmb3IgYSB3aGlsZSBub3cuIEl0J3MgYW4gZW50aXJlbHkgdW5uZWNlc3Nhcnkg
Y29kZQ0KPiBkdXBsaWNhdGlvbi4NCg0KQ29kZSBkdXBsaWNhdGlvbiBzaG91bGRuJ3QgYmUgYSBm
YWN0b3IuIEZvciBleGFtcGxlLCBpbiBtbHg1IHdlIGhhdmUgYQ0KZ2VuZXJpYyBtZWNoYW5pc20g
dG8gZGVmaW5lIGFuZCByZXBvcnQgc3RhdHMsIGZvciB0aGUgbmV0ZGV2IHN0YXRzIHRvDQpiZSBy
ZXBvcnRlZCBpbiBldGh0b29vbCBhbGwgd2UgbmVlZCB0byBkbyBpcyBkZWZpbmUgdGhlIHJlcHJl
c2VudGluZw0Kc3RyaW5nIGFuZCBzdG9yZSB0aG9zZSBjb3VudGVycyBpbiB0aGUgU1cgc3RhdHMg
c3RydWN0Lg0KDQo+IFdlIHNob3VsZCBzdGVlciB0b3dhcmRzIHByb3BlciBBUElzIGZpcnN0IGlm
IHRob3NlIGV4aXN0Lg0KPiANCj4gVXNpbmcgZXRodG9vbCAtUyBzdGF0cyBnZXRzIHZlcnkgbWVz
c3kgdmVyeSBxdWlja2x5IGluIHByb2R1Y3Rpb24uDQoNCkkgYWdyZWUgb24gZXRodG9vbCBnZXR0
aW5nIG1lc3N5IHZlcnkgcXVpY2tseSwgYnV0IGkgZGlzYWdyZWUgb24gbm90DQpyZXBvcnRpbmcg
bmV0ZGV2IHN0YXRzLCBJIGRvbid0IHRoaW5rIHRoZSA0IG5ldGRldiBzdGF0cyBhcmUgdGhlIHJl
YXNvbg0KZm9yIG1lc3N5IGV0aHRvb2wuDQoNCkV0aHRvb2wgLVMgaXMgbWVhbnQgZm9yIHZlcmJv
c2l0eSBhbmQgZGVidWcsIGFuZCBpdCBpcyBmdWxsIG9mDQpkcml2ZXIvSFcgc3BlY2lmaWMgY291
bnRlcnMsIGhvdyBhcmUgeW91IHBsYW5pbmcgdG8gYXVkaXQgYWxsIG9mIHRob3NlDQo/DQoNCldl
IGhhZCBhbiBpZGVhIGluIHRoZSBwYXN0IHRvIGFsbG93IHVzZXJzIHRvIGNob29zZSB3aGF0IHN0
YXRzIGdyb3Vwcw0KdG8gcmVwb3J0IHRvIGV0aHRvb2wsIHdlIGNhbiBmb2xsb3cgdXAgb24gdGhp
cyBpZiB0aGlzIGlzIHNvbWV0aGluZw0Kb3RoZXIgZHJpdmVycyBtaWdodCBiZSBpbnRlcmVzdGVk
IGluLg0KDQpleGFtcGxlOiANCg0KZXRodG9vbCAtUyBldGgwIC0tZ3JvdXBzIFhEUCxTVyxQRVJf
UVVFVUUsUENJLFBPUlQsRFJJVkVSX1NQRUNJRklDDQpXaGVyZSBub24gRFJJVkVSX1NQRUNJRkMg
Z3JvdXBzIGFyZSBzdGFuZGFyZGl6ZSBzdGF0cyBvYmplY3RzLi4gDQoNCi1TYWVlZC4NCg0K
