Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9BC14544F
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 13:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgAVMRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 07:17:50 -0500
Received: from mail-am6eur05on2070.outbound.protection.outlook.com ([40.107.22.70]:6181
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728912AbgAVMRt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 07:17:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mL5hhSbKCexI7JnrxmDFhS4NRXtWGFjNxMOf2KLLGKKRvLoTNWiVG9GLlcfUM1QVRpcPrnp5AFQEu5FuLN7QKEbG69MfH06DAtEsxfLtP2+tpGMwp/EmeHtO3hAt1MAsVg8fMEjnKWjiCByF5zhLLFvTjj4SBcyzdHweAcg7RBnWkog4ZAybmzQU0TgNPImaJC+m5FXy0xMxC84+DI7NTuH3H7ChLOAYnCeHcflhf1CTCm6ZD8XXOdsmoPJIMo94Gn1c15QhUyoTTwZd9gvk0Z/F7aocHABImjHJNwSGm8aau06G/Fc89JnYnd9VShiISkqLMDSTR2Q7PquufoPF3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2vj3UjOeziBIbFW2Vg1CKIZoaAoHkhjMJjNQJILpYE=;
 b=kbEe6vLe5uStAMQVvDsZWgPU3W+ASwz+5Qbyo4AKR1HYa53PWOE6p1/StQrdmdu1IYUYVskfnt9SNsl/293sV1OlqiY6VGQYLgjGJpS8MKyc+snHwisDc6RZwRNSmGiiRM2e2J9jjyr7TWA7z9i72DgeHFM4Zk+P969nN0M6oruiECYWmxm95qJ/ASYMHjrRvQTv1I7KIgs24oxYQJ0P5DukoF/kW1w2TRq4nsiZFOFlAVCFSoGiJ4JqZ8s3GJSiA/J4O+tYXGv/xiYKuAAQzTc9YBsjvF03PXmhiWvAAHiQHKrV+QWbE4E0U7+CkoZ6UfdMZGUNQoDaKZEgPKcKdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2vj3UjOeziBIbFW2Vg1CKIZoaAoHkhjMJjNQJILpYE=;
 b=cIE3X/z3/j0FmSfMCr0zffQt8d4mdkCAjUs8nBxTeCW8kkeMzrIZdm74mZt1eoiPXFeYe7tOt1lgprRuKMn+dI7j3Y74sgu7L/9eoERwYV7kwCrMj7SpvfFIIIsGOxeweAT3JuJmsNucPfPXf1q4+up04Z3TYNWb1OW7iJYO5QQ=
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB4840.eurprd05.prod.outlook.com (20.177.35.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 22 Jan 2020 12:17:45 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::b826:4acc:6d53:6eea]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::b826:4acc:6d53:6eea%6]) with mapi id 15.20.2644.028; Wed, 22 Jan 2020
 12:17:45 +0000
Received: from [10.223.6.3] (193.47.165.251) by AM0PR06CA0107.eurprd06.prod.outlook.com (2603:10a6:208:fa::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.23 via Frontend Transport; Wed, 22 Jan 2020 12:17:44 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next-mlx5 02/13] net/mlx5: Add new driver lib for
 mappings unique ids to data
Thread-Topic: [PATCH net-next-mlx5 02/13] net/mlx5: Add new driver lib for
 mappings unique ids to data
Thread-Index: AQHV0HY5f8ktCg8rxEaaiY0MJTYKLqf1ej8AgAEguAA=
Date:   Wed, 22 Jan 2020 12:17:44 +0000
Message-ID: <85bf4ee7-e006-18ea-d643-8b9001066cbf@mellanox.com>
References: <1579623382-6934-1-git-send-email-paulb@mellanox.com>
 <1579623382-6934-3-git-send-email-paulb@mellanox.com>
 <20200121190420.GM51881@unreal>
In-Reply-To: <20200121190420.GM51881@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0107.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::48) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5fbdedb3-548a-4e9b-13a5-08d79f351604
x-ms-traffictypediagnostic: AM6PR05MB4840:|AM6PR05MB4840:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB48403D0300D6F989F64C5168CF0C0@AM6PR05MB4840.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(189003)(199004)(54906003)(31686004)(4326008)(2906002)(53546011)(316002)(16576012)(81156014)(86362001)(31696002)(66946007)(16526019)(81166006)(66476007)(66556008)(64756008)(71200400001)(66446008)(5660300002)(2616005)(186003)(478600001)(6916009)(36756003)(26005)(8936002)(956004)(52116002)(6486002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4840;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /eye++Gj+9QzX3Ct3ruv8AFgmOEllO4Ye/PZU9urS7kiK6lSN8BAO+jjK5CbOS822Pd8E7ILltAxGhgcISAByJsaG4ZjB2C4uYmwmf/UCjKQGtniND9MKEC2z741vVWv1qwaiAkdVDY6/RSC2ds1kK1Y0qijCMaE8cK8Xn7OmD8yCBYDgm15RpCZSUuYP0VJ/D6vGIvHaCQ3pazJBzyKSpVpUL731WooB22qOx/E0TJEZUrpBhgN74mSTK1Jvc8wQsj34c5/dbmUP/hHqDvbxOzn2LzxJkbR+o/3Z8AXv1T+dcyap1tT6JcjpvrOf32+z21v8xGOEBIOeYrOBiKa+lVM5/e6vdJRo55LgMebiOSrRixAfNoZ6G8jKk34QhlozfPVHUD70vH1RQYvmID8KaFbq3qqL3FYpLurJorW1beBf7D2c2hrtx95LmrQXxKI
Content-Type: text/plain; charset="utf-8"
Content-ID: <F99729095FDE144BA90357EFF0406804@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fbdedb3-548a-4e9b-13a5-08d79f351604
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 12:17:44.9292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Mow6QYXHQnhgJrb4ykL0fbv80EL4XWA44l73EJVwbfrzNKQKxCH3Ffb8APXUkeU1xOHnWKdrotIeyAirAdr4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4840
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzIxLzIwMjAgOTowNCBQTSwgTGVvbiBSb21hbm92c2t5IHdyb3RlOg0KPiBPbiBUdWUs
IEphbiAyMSwgMjAyMCBhdCAwNjoxNjoxMVBNICswMjAwLCBQYXVsIEJsYWtleSB3cm90ZToNCj4+
IEFkZCBhIG5ldyBpbnRlcmZhY2UgZm9yIG1hcHBpbmcgZGF0YSB0byBhIGdpdmVuIGlkIHJhbmdl
IChtYXhfaWQpLA0KPj4gYW5kIGJhY2sgYWdhaW4uIEl0IHN1cHBvcnRzIHZhcmlhYmxlIHNpemVk
IGRhdGEsIGFuZCBkaWZmZXJlbnQNCj4+IGFsbG9jYXRvcnMsIGFuZCByZWFkL3dyaXRlIGxvY2tz
Lg0KPj4NCj4+IFRoaXMgbWFwcGluZyBpbnRlcmZhY2UgYWxzbyBzdXBwb3J0cyBkZWxheWluZyB0
aGUgbWFwcGluZyByZW1vdmFsIHZpYQ0KPj4gYSB3b3JrcXVldWUuIFRoaXMgaXMgZm9yIGNhc2Vz
IHdoZXJlIHdlIG5lZWQgdGhlIG1hcHBpbmcgdG8gaGF2ZQ0KPj4gc29tZSBncmFjZSBwZXJpb2Qg
aW4gcmVnYXJkcyB0byBmaW5kaW5nIGl0IGJhY2sgYWdhaW4sIGZvciBleGFtcGxlDQo+PiBmb3Ig
cGFja2V0cyBhcnJpdmluZyBmcm9tIGhhcmR3YXJlIHRoYXQgd2VyZSBtYXJrZWQgd2l0aCBieSBh
IHJ1bGUNCj4+IHdpdGggYW4gb2xkIG1hcHBpbmcgdGhhdCBubyBsb25nZXIgZXhpc3RzLg0KPj4N
Cj4+IFdlIGFsc28gcHJvdmlkZSBhIGZpcnN0IGltcGxlbWVudGF0aW9uIG9mIHRoZSBpbnRlcmZh
Y2UgaXMgaWRyX21hcHBpbmcNCj4+IHRoYXQgdXNlcyBpZHIgZm9yIHRoZSBhbGxvY2F0b3IgYW5k
IGEgbXV0ZXggbG9jayBmb3Igd3JpdGVzDQo+PiAoYWRkL2RlbCwgYnV0IG5vdCBmb3IgZmluZCku
DQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogUGF1bCBCbGFrZXkgPHBhdWxiQG1lbGxhbm94LmNvbT4N
Cj4+IFJldmlld2VkLWJ5OiBPeiBTaGxvbW8gPG96c2hAbWVsbGFub3guY29tPg0KPj4gUmV2aWV3
ZWQtYnk6IE1hcmsgQmxvY2ggPG1hcmtiQG1lbGxhbm94LmNvbT4NCj4+IC0tLQ0KPiBJIGhhdmUg
bWFueSBpc3N1ZXMgd2l0aCB0aGlzIHBhdGNoLCBidXQgdHdvIG1haW4gYXJlOg0KPiAxLiBUaGlz
IGlzIGdlbmVyYWwgaW1wbGVtZW50YXRpb24gd2l0aG91dCBwcm9wZXIgZG9jdW1lbnRhdGlvbiBh
bmQgdGVzdA0KPiB3aGljaCBkb2Vzbid0IGJlbG9uZyB0byBkcml2ZXIgY29kZS4NCj4gMi4gSXQg
bG9va3MgdmVyeSBzaW1pbGFyIHRvIGFscmVhZHkgZXhpc3RpbmcgY29kZSwgZm9yIGV4YW1wbGUg
eGFycmF5Lg0KPg0KPiBUaGFua3MNClRoaXMgZGF0YSBzdHJ1Y3R1cmUgdXNlcyBpZHIgKGN1cnJl
bnRseSB3cmFwcGVyIGZvciB4YXJyYXkpIGJ1dCBhbHNvIGEgDQpoYXNoIHRhYmxlLCByZWZjb3Vu
dCwgYW5kDQpnZW5lcmljIGFsbG9jYXRvcnMuDQpUaGUgaGFzaHRhYmxlIGlzIHVzZWQgb24gdG9w
IG9mIHRoZSBpZHIgdG8gZmluZCBpZiBkYXRhIGFkZGVkIHRvIHRoZSANCm1hcHBpbmcgYWxyZWFk
eSBleGlzdHMsIGlmIGl0DQpkb2VzIGl0IHVwZGF0ZXMgYSByZWZjb3VudC4NCldlIGFsc28gaGF2
ZSBzb21lIHNwZWNpYWwgZGVsYXllZCByZW1vdmFsIGZvciBvdXIgdXNlIGNhc2UuDQpUaGUgYWRk
aXRpb24gdG8geGFycmF5IGlzIHRyYW5zbGF0aW9uIGZyb20gZGF0YSB0byBoYXNoIGZ1bmN0aW9u
LiBJdCBpcyANCnNvbWV0aGluZyB0aGF0IGRvZXNuJ3QgZXhpc3QNCmFuZCBuZWVkcyBleHRyYSBj
b2RlLiBJRFIgd2FzIGNob3NlbiBhcyBiZWluZyBzaW1wbGlmaWVkIGludGVyZmFjZSBvZiANCnhh
cnJheSBhbmQgaXQgaXMgZ29vZCBlbm91Z2gNCmluIG91ciBjYXNlLg0KDQpUaGUgbWx4NSBpcyBm
aXJzdCB1c2VyIG9mIHN1Y2ggbGlicmFyeSwgb25jZSB0aGUgb3RoZXIgdXNlciB3aWxsIGFycml2
ZSwgDQp3ZSB3aWxsIGJlIGhhcHB5IHRvDQpjb2xsYWJvcmF0ZSBpbiBvcmRlciB0byBtYWtlIGl0
IGdlbmVyaWMuDQo=
