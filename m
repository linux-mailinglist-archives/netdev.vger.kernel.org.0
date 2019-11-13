Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD24FAE2C
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 11:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfKMKMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 05:12:08 -0500
Received: from mail-eopbgr130052.outbound.protection.outlook.com ([40.107.13.52]:21476
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726389AbfKMKMH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 05:12:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTmOlhYq8XKrrDGOdoobSaTVbzD/sk1bvQUxsXOR9EtnaCv1ZKZrlqI3N3K4XVtyjWslJbdFKZKNisbn9xh0pDlCA+PiboJlab5JmuQV5vi02lGwFrqNje6A5OOAiQmFnnbFhTFD364Ce7DuK8Kf6GKXI7W9jik003UqXXsJmlmIJka8UczAn4urZpspIEYv8jKxSjWrzrWc4w4le5m2LDqlSensn2lNExJRaKfonsAfvUTWhHaEaYJtzIDYjwgoer/6NBz9KuqexgHz9nGTNtW46vfSIrh7qANadu/djnDR2SHF9itaN0sXztdzE7MXk/ipbSGsocHCcMHlXLlLnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MA3ZSU7fuZmWEpyA6UpN2D9hyZDNkEvrH5KnrHSqU1o=;
 b=m7QoMWFdkbKWKnGwmnwHGFmHeiZGT3YPGJv7m7TLbc3nwJMqkHJaPBl38SeLUMLlcnUhxRkQBvLQIgIzVVhhieUIZpndU6JqFJRqMszsuRCFyh64bqXmuCxgxzm0tjZ67ZQiMxqZfwLCm5s+BNKo/CIgJzG+tstUnKSbigRvnP4dPVQqhKl3DRtvXelVsNpvkelYokKKDIXZQ0lSN6o/ey5e+4GAoVNrvOFCDxv02f8dRQ08RcSItytZQ/w1RLtRX+MYk7Oe7CuMQeOU5wtaf5EgS7xX3Va1kjuFnaP6/dFRaufVTMKjsoz4d2flb1v5pp1ZmUnRiuWmR3e9XIyKTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MA3ZSU7fuZmWEpyA6UpN2D9hyZDNkEvrH5KnrHSqU1o=;
 b=nqqA5XNrCUomP+Z32p23MNpjlZOMTD8+FJQVXMhgcGDtSk3uvirux2iRwniZ4EzvfiQO9DgHSMp5BSUq/pFPHR6MxzBWm/jBvWo34SDq9YUMNOogFsHz9arDkC4DSUVnaeujjwMyGfcs+gew3nP7X/WAMk8WSjca78BZi2HVeLQ=
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com (52.135.161.31) by
 AM6PR05MB5588.eurprd05.prod.outlook.com (20.177.118.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Wed, 13 Nov 2019 10:12:04 +0000
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::8435:9f63:f8da:650e]) by AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::8435:9f63:f8da:650e%7]) with mapi id 15.20.2430.027; Wed, 13 Nov 2019
 10:12:03 +0000
From:   Roi Dayan <roid@mellanox.com>
To:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>
Subject: Re: [PATCH iproute2-next 0/8] flower match support for masked ports
Thread-Topic: [PATCH iproute2-next 0/8] flower match support for masked ports
Thread-Index: AQHVmWjZ7rCBy79pO0ySMtRawFRdgqeH81QAgADvbIA=
Date:   Wed, 13 Nov 2019 10:12:03 +0000
Message-ID: <dbf574d1-4803-efbc-3670-33f9ddf9b5f4@mellanox.com>
References: <20191112145154.145289-1-roid@mellanox.com>
 <2dca1929-15a6-d7ff-c8b1-c2605bed6b2c@gmail.com>
In-Reply-To: <2dca1929-15a6-d7ff-c8b1-c2605bed6b2c@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
x-clientproxiedby: AM3PR05CA0086.eurprd05.prod.outlook.com
 (2603:10a6:207:1::12) To AM6PR05MB4198.eurprd05.prod.outlook.com
 (2603:10a6:209:40::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a103ce25-1ab5-4990-a05b-08d76821ee38
x-ms-traffictypediagnostic: AM6PR05MB5588:|AM6PR05MB5588:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB55886C5D4A1140750A951F1BB5760@AM6PR05MB5588.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(199004)(189003)(6116002)(476003)(11346002)(4326008)(58126008)(26005)(316002)(4744005)(6246003)(4001150100001)(3846002)(31696002)(478600001)(386003)(99286004)(102836004)(7736002)(6506007)(14454004)(446003)(52116002)(8936002)(2616005)(486006)(25786009)(31686004)(53546011)(305945005)(36756003)(66946007)(229853002)(54906003)(186003)(86362001)(8676002)(256004)(6486002)(71190400001)(2906002)(6436002)(71200400001)(107886003)(6512007)(76176011)(110136005)(5660300002)(65806001)(2501003)(65956001)(81166006)(81156014)(66476007)(66556008)(64756008)(66446008)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5588;H:AM6PR05MB4198.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QDDP23JqJ0kB0UT2o+nDb4e4ZoyMviK2qJJceio6Otcjq4Cb8x1vzRxD70KR2c/s9GS50VitIBFF7WHApsMALk3WTunlgIQZeN3WRobHX1FzkYSMBXRu2x/v06MB8GZInAmODMDNgKsYbJZ+JV8sc3V6GnnmHFvKZq2tBVrQtSM5Q4nxMAhpytWqgjhQALehWawo1O2ky4Ty0DknG422z3zRY2WZml49KR0Li4N2+TackSbdomiAcETgmNvrze+bXDaL/pNvrJRzPho0yCNzh7l85mr6ZSH6O+ZJY/vPSLTmvjEVo2Dfda2sQtYmiYm3GwM9UStnFkoAy3q2yOuG7N+Y+MnPWtioB2V0D2dIDjqeXMk3CVEOxz7VFdg+fAt+cnBdqzmR/1PkEeg9JG2LMk4EXH4ESxZh7GJdbgNb4sProSN/xhy1ECDJ3AbiqxDF
Content-Type: text/plain; charset="utf-8"
Content-ID: <29A883D6880E53468A65AC972022DA41@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a103ce25-1ab5-4990-a05b-08d76821ee38
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 10:12:03.8690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b1G5eSQP4hZNvI2dbpSHYBAEta7sdlfYvsHLZQfq19qMSyDS1mhc6aMkR4EuyHmcIvwXhtc0wbrCWxh6b2zzrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5588
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIwMTktMTEtMTIgOTo1NSBQTSwgRGF2aWQgQWhlcm4gd3JvdGU6DQo+IE9uIDExLzEy
LzE5IDc6NTEgQU0sIFJvaSBEYXlhbiB3cm90ZToNCj4+IEhpLA0KPj4NCj4+IFRoaXMgc2VyaWVz
IGlzIGZvciBhZGRpbmcgc3VwcG9ydCBmb3IgZmxvd2VyIG1hdGNoIG9uIG1hc2tlZA0KPj4gc3Jj
L2RzdCBwb3J0cy4NCj4+DQo+PiBGaXJzdCBjb21taXRzIGFyZSBwcmVwYXJhdGlvbnMgYW5kIGZp
eGluZyB0b3MgYW5kIHR0bCBvdXRwdXQuDQo+PiBMYXN0IDMgY29tbWl0cyBhZGQgc3VwcG9ydCBm
b3IgbWFza2VkIHNyYy9kc3QgcG9ydC4NCj4gDQo+IFNlZW1zIGxpa2UgdGhlIGJ1ZyBmaXhlcyBw
YXRjaGVzIHNob3VsZCBnbyB0byBtYXN0ZXIuDQo+IA0KPiBTZW5kIHRob3NlIHNlcGFyYXRlbHks
IG9uY2UgY29tbWl0dGVkIEkgY2FuIG1lcmdlIG1hc3RlciB0byBuZXh0IGFuZA0KPiB0aGVuIHlv
dSBjYW4gcmUtc2VuZCB0aGUgcmVtYWluaW5nIHBhdGNoZXMuDQo+IA0KDQpvayB0aGFua3MNCg0K
