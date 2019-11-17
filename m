Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97458FF933
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 12:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfKQLqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 06:46:21 -0500
Received: from mail-eopbgr80073.outbound.protection.outlook.com ([40.107.8.73]:32389
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726027AbfKQLqV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Nov 2019 06:46:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pd2Exwi9JxTd0fiMJFiAKVKW3/lT/lSOFA4nV+rurg982NCFRJHyFGsG+0IIInbC4Eki2z4iRShkvoJnkVRI6E+23p5uCNdms5EC5Qbz34MipsPQdNikb0vnrRnMA0DCh4UluyJ9hvJWYhGXqPHVOhyZ0gkr9RVM7RGvzEcvBcYz9s2zexuedEqaYng9O33hFupe+pID3H0F9RvMqc3wxNaJXas2vdlt4+g6H2nmG7ftNpPXrCkwXxXJzbdyZBYYtdEXk2UuA+se7mZKrKbUKp+ftvqjAUhw2B7e8ZMbMpb3Ma6NlMPo1UGiDR0iw9hJPZbcKgwFEDSMYNwnl0HBjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=spiKmaemsn3hdih+271tFKaYRt9TRWjFXZ44Z3aDhTU=;
 b=eCaI2Kg92kkZRzM0nejyUYiOdZP6AkzhyI3SP6t/w8tT2nqicTYddvzCzqlLS3FQls7Q5za6HQ97JK9nzXiO7aPs2ufBHpmHFSOB/qGkGsLY7ATppcgVyDWimw0D75MNm666kTl7x7sju1dFO9RsfinPGmBn07drGANQHkhRW9XzsGoy0rUph/DP6HAlaGfS62YDIoNo06Gv2A9JD+A5x+v8fUIaTQ/9wBhk3Td/e5hIjvtAAZ/ZQQhJTqLfbORutFZpkEp1bjhXwYC9Q1f6EB6l36h1VEp9Htc90wuELPolvsWJkZUZ91qPh2G1ReBWy9TUQ3eeAL15B4nwqjJpmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=spiKmaemsn3hdih+271tFKaYRt9TRWjFXZ44Z3aDhTU=;
 b=sk7xDEBpy5dZE2M2oP45N9txSCne5ORk3DoEiRBSZzRfqMcME1yf8cN1yd9xXZ8oxb85DVbr5uohWUyyiYBHNBX+vRs7gcPPlo6a17Pmtqft0seob9nFpmhaqPCKy9iWBW5mKFgYiZ7QoyaAEnpMrlRIE6sTjV+0MkIz2eP+5cc=
Received: from VI1PR05MB5680.eurprd05.prod.outlook.com (20.178.124.149) by
 VI1PR05MB5421.eurprd05.prod.outlook.com (20.177.200.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Sun, 17 Nov 2019 11:46:16 +0000
Received: from VI1PR05MB5680.eurprd05.prod.outlook.com
 ([fe80::b5cf:e640:40d3:b461]) by VI1PR05MB5680.eurprd05.prod.outlook.com
 ([fe80::b5cf:e640:40d3:b461%4]) with mapi id 15.20.2451.029; Sun, 17 Nov 2019
 11:46:16 +0000
From:   Shay Drory <shayd@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Maor Gottlieb <maorg@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "lennart@poettering.net" <lennart@poettering.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Send SFP event from kernel driver to user space (UDEV)
Thread-Topic: Send SFP event from kernel driver to user space (UDEV)
Thread-Index: AQHVnTyemIrPi2KC+0KxDlDyt5FLmg==
Date:   Sun, 17 Nov 2019 11:46:15 +0000
Message-ID: <a041bba0-83d1-331f-d263-c8cbb0509220@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shayd@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 180caa74-8399-43c2-29c2-08d76b53c101
x-ms-traffictypediagnostic: VI1PR05MB5421:|VI1PR05MB5421:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5421D130E2BE0BC7E0604F64C2720@VI1PR05MB5421.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02243C58C6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(199004)(189003)(31686004)(6486002)(6436002)(99286004)(1730700003)(8676002)(81156014)(966005)(5660300002)(2501003)(81166006)(4326008)(66066001)(76116006)(6506007)(6116002)(66556008)(14454004)(3846002)(66476007)(66946007)(26005)(66446008)(316002)(8936002)(102836004)(54906003)(186003)(86362001)(7736002)(107886003)(25786009)(2351001)(31696002)(64756008)(2616005)(305945005)(6512007)(486006)(476003)(256004)(36756003)(6306002)(2906002)(71190400001)(71200400001)(5640700003)(478600001)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5421;H:VI1PR05MB5680.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3lM+haCYhFexBhpFikBlwC4q+GfSbTBuuz2PPPwYSEmu7noBJkIkDhFy0l+rGP0wIq5TSXv7v3SCg7O6buAlc6NuiQw/8a/IYdRnxu6NYVgNjGM1nI5QGFhX8Ib9YdHAPaIx/xan4m8Ns2oEASLf05hVQi1U+G0WrO1BYPpVoTFPG2+Zdx9mFQizyGk797JMPhf6JC4UqMeisIG8KCNYmYTKLFv7FE26CVi9KEuR27KBtECEBdgOBdB9UXuCWDWBdYicN5rxz140eceQyoDZWuyYvBwczDzjeTpZsXe4umHXyY/y98c391OTVg633+lT1OYugvOeV4D8OvqzDLrWQE0PkayC3ZWmbJ02t//34g0frsVCSQ57pdvjpf01Hs7xDZYFiWrnHzguk/l9FsLg9saBgrrKt/AbmkFwVmUniLvpxSPBJuHTIREnM5j0O/iU
Content-Type: text/plain; charset="utf-8"
Content-ID: <89C595B21030464499068224A0F20811@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 180caa74-8399-43c2-29c2-08d76b53c101
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2019 11:46:15.8822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LSASFW3Ird17vJ0jEJ7R2kgrT+opyeapvcIdWTnxu0Y+7sS3gQV+XazP7PAVIEohdX4sB5XwZW0kEWZo61P0Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5421
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VG9kYXksIFNGUCBpbnNlcnRlZCAvIHJlbW92YWwgZXZlbnQgaW1wYWN0cyBvbmx5IHRoZSBrZXJu
ZWwgc3BhY2UgZHJpdmVycy4NClRoZXJlIGFyZSB1c2VycyB3aG8gd2lzaGVzIHRvIGdldCBTRlAg
aW5zZXJ0IC8gcmVtb3ZhbCBpbiBhIHVkZXYtZXZlbnQNCmZvcm1hdCBmb3IgdGhlaXIgYXBwbGlj
YXRpb24gLyBkYWVtb25zIC8gbW9uaXRvcnMuDQpUaGUgbmFpdmUgd2F5IHRvIGltcGxlbWVudCB0
aGlzIGZlYXR1cmUgd291bGQgYmUgdG8gY3JlYXRlIGEgc3lzZnMgZmlsZQ0KdGhhdCByZXByZXNl
bnRzIGRldmljZSBTRlAsIHRvIGV4cG9zZSBpdCB1bmRlciB0aGUgbmV0ZGV2IHN5c2ZzLCBhbmQN
CnRvIHJhaXNlIGEgdWRldiBldmVudCBvdmVyIGl0Lg0KSG93ZXZlciwgaXQgaXMgbm90IHJlYXNv
bmFibGUgdG8gY3JlYXRlIGEgc3lzZnMgZm9yIGVhY2ggbmV0LWRldmljZS4NCkluIHRoaXMgbGV0
dGVyLCBJIHdvdWxkIGxpa2UgdG8gb2ZmZXIgYSBuZXcgbWVjaGFuaXNtIHRoYXQgd2lsbCBhZGQg
YQ0Kc3VwcG9ydCB0byBzZW5kIFNGUCBldmVudHMgZnJvbSB0aGUga2VybmVsIGRyaXZlciB0byB1
c2VyIHNwYWNlLg0KVGhpcyBzdWdnZXN0aW9uIGlzIGJ1aWx0IHVwb24gYSBuZXcgbmV0bGluayBp
bmZyYXN0cnVjdHVyZSBmb3IgZXRodG9vbA0KY3VycmVudGx5IGJlaW5nIHdyaXR0ZW4gYnkgTWlj
aGFsIEt1YmVja3doaWNoIGNhbGxlZCDigJxldGh0b29sLW5ldGxpbmvigJ1bMV0uDQpNeSBzdWdn
ZXN0aW9uIGlzIHRvIGRvIGl0IGJ5IGFkZGluZyBhIGZ1bmN0aW9uDQooZXRodG9vbF9zZnBfaW5z
dGVydGVkL3JlbW92ZWQoLi4uKSkgdG8gZXRodG9vbCBBUEksIFRoaXMgZnVuY3Rpb24gd2lsbA0K
cmFpc2UgYSBuZXRsaW5rIGV2ZW50IHRvIGJlIGNhdWdodCBpbiB1c2VyIHNwYWNlLg0KVGhlIGRl
c2lnbjoNCg0KLSBTRlAgZXZlbnQgZnJvbSBOSUMgY2F1Z2h0IGJ5IHRoZSBkcml2ZXINCi0gRHJp
dmVyIGNhbGwgZXRodG9vbF9zZnBfaW5zZXJ0ZWQvcmVtb3ZlZCgpDQotIEV0aHRvb2wgZ2VuZXJh
dGVkIG5ldGxpbmsgZXZlbnQgd2l0aCByZWxldmFudCBkYXRhDQotIFRoaXMgZXZlbnQtbWVzc2Fn
ZSB3aWxsIGJlIGhhbmRsZWQgaW4gdGhlIHVzZXItc3BhY2UgbGlicmFyeSBvZiBVREVWDQooZm9y
IHRoaXMgcHVycG9zZSB3ZSB3b3VsZCBsaWtlIHRvIGFkZCBhIG5ldGxpbmsgaW5mcmFzdHJ1Y3R1
cmUgdG8gVURFVg0KdXNlci1zcGFjZSBsaWJyYXJ5KS4NCg0KdGhlIGZsb3cgaW4gc2NoZW1lOg0K
DQpVREVWIChpbiBzeXN0ZW1kKQ0KICAgICAgICAgICAgICAgICDihpENCmV0aHRvb2xfbmV0bGlu
ayAoaW4gZXRodG9vbCkNCiAgICAgICAgICAgICAgICAg4oaRDQpkcml2ZXIgKG1seDVfY29yZSBm
b3IgZXhhbXBsZSkNCiAgICAgICAgICAgICAgICAg4oaRDQpOSUMgKFNGUCBldmVudCkNCg0KV291
bGQgbGlrZSB0byBoZWFyIHlvdXIgb3BpbmlvbiBvbiB0aGlzIHN1Z2dlc3Rpb24sIG9yIG9uIGFs
dGVybmF0aXZlDQpkZXNpZ25zLg0KDQpUaGFua3MNClNoYXkgRHJvcnkNCg0KWzFdDQpodHRwczov
L3BhdGNod29yay5vemxhYnMub3JnL3Byb2plY3QvbmV0ZGV2L2xpc3QvP3Nlcmllcz0mc3VibWl0
dGVyPTExODkyJnN0YXRlPSomcT0mYXJjaGl2ZT0mZGVsZWdhdGU9DQoNCg==
