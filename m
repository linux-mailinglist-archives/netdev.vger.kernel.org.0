Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66262FAE4F
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 11:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfKMKQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 05:16:25 -0500
Received: from mail-eopbgr70073.outbound.protection.outlook.com ([40.107.7.73]:51725
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726107AbfKMKQZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 05:16:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSMJ+RLpPXSXpX/5Zj5gkwmXUwvX2V8i877m5rAeOKEhomIy0uusMOKng8PYf6uf5CaRia6HyLQIk2rdAhN6Fvqq3QaYfmvNQfRX2lNTWPSTosb3SU2hEqmNvoovPUiROSEZO6JHt6stns+syhbCDV0pbbnlgctlA+adIg6lxOU2JPsWYCptOxkTtPng7si8QC4MXFZNVb6VyYOBRwhooNgnIPZsnCAfb1gqQ7dlzKeB2Sg8sJnIwL4v9WZJMNVJEP1BDjAlKlSwGKOGXcELhLtSOkhR+6dyjE7UB182x5bl90V/Frh4s4v9mGjT7NZktqxgujTkBdqb2MlXRFFCwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3FkX+Y4x02PaUIa3ZTbafP4Utm+kKULq8eb9RZ6qP6M=;
 b=Jhz7Pn5KDcdEZWY7VK/ru4l2IzQoaAb7xujc1B9Od4XV3EvBnPeXB59FPaABowJl4rrnNEXgzCsaFHE5c5xou4RliABcqzad+nh5UrEjt/pTvZtPWeyy6C6ukBtDv1zIOChzGXhwOE+i00jeKRbnlcF0U9UeHVltrWJxPy1sX+ebaJNBwpEIXPr0Dx3n/OxE8Fon4fxSNinJlSE6Lga7cS3VAdNwx/sboviPwvby0rxGoYtm39qRN9Jj0h6jeIOsdxOxVTok3OY2PIowfzUMk/VmwuKJzYyBZUQskZdafNDE/3NAvK0DQHArb37oUrb5Jn52rjASRFsYN7KTbYqsSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3FkX+Y4x02PaUIa3ZTbafP4Utm+kKULq8eb9RZ6qP6M=;
 b=RNkV9pw1wHe0s3lsdMshd55hH/lxo/+w+qDmMq5aJos7xmuxr9jpQTSGuaGM3e6yxtVl4T85fEzHgodGzLoBX2eP/TuxD+gSlHW/t1IbJrc0Ud2LQrdaPTduSfUEq3pJKfJmTI8HTbMGx8JLaiDwbfX6OulbcjPB85wf4258UK4=
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com (52.135.161.31) by
 AM6PR05MB4407.eurprd05.prod.outlook.com (52.135.167.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 13 Nov 2019 10:16:21 +0000
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::8435:9f63:f8da:650e]) by AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::8435:9f63:f8da:650e%7]) with mapi id 15.20.2430.027; Wed, 13 Nov 2019
 10:16:21 +0000
From:   Roi Dayan <roid@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>
Subject: Re: [PATCH iproute2 0/5] fix json output for tos and ttl
Thread-Topic: [PATCH iproute2 0/5] fix json output for tos and ttl
Thread-Index: AQHVmgsZswiyZ/n/O0yuuiRCjL1ds6eI4rAA
Date:   Wed, 13 Nov 2019 10:16:21 +0000
Message-ID: <9b9d7c05-ff0b-7adb-5c9e-09fad441714e@mellanox.com>
References: <20191113101245.182025-1-roid@mellanox.com>
In-Reply-To: <20191113101245.182025-1-roid@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
x-clientproxiedby: AM3PR04CA0130.eurprd04.prod.outlook.com (2603:10a6:207::14)
 To AM6PR05MB4198.eurprd05.prod.outlook.com (2603:10a6:209:40::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e80caf01-1817-42b1-ad25-08d7682287dd
x-ms-traffictypediagnostic: AM6PR05MB4407:|AM6PR05MB4407:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB440730763B39D3EDB3C87386B5760@AM6PR05MB4407.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(199004)(189003)(7736002)(25786009)(26005)(6506007)(102836004)(53546011)(386003)(6436002)(6486002)(305945005)(76176011)(52116002)(6512007)(5640700003)(2616005)(476003)(6246003)(486006)(107886003)(4326008)(66476007)(11346002)(446003)(5660300002)(478600001)(66446008)(66556008)(64756008)(4744005)(186003)(14454004)(31686004)(4001150100001)(86362001)(3846002)(6116002)(66946007)(31696002)(2501003)(229853002)(8936002)(81156014)(81166006)(1730700003)(8676002)(6916009)(2351001)(71200400001)(58126008)(66066001)(65956001)(65806001)(256004)(54906003)(36756003)(71190400001)(2906002)(316002)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4407;H:AM6PR05MB4198.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WNxyp1Dzoro3EjulqeWX1PzbGKw+31mL1a4ctZxhS/9lkMdI/HH2MEUt0uxa2zmPF1Jp9axkD/z5iTioNtU1L2bNlwz4lBQEbEgrkUrTJdahxGlxlEkr9Mmtg9kBV/uRJyfhKiWubcQI5LTByc/6B76F7JSNZo8ndUd83WlilJ2bezSFU7j0pw7TTbfOTIh06DaiLf6I70z3v1asZRPR2wwdr8BNtJe+uNSNanstKuLxsum/mbCu8bOYaAQCTem6c3IOFB+fJgN2hhngmahSrEs3x1G3DNQkcB9qR+pwUNMJhRFQXN1lVccWFzJPbRzLsmWAfHUryFm3xBEyC+z8ZkQMDg/xj/dZcS9FYlJ0VFi+42WAKwWYey++styvs312xSW+ttUdasra2qE+PK3YYO3SYAgOhuaERH6S8G7LTZVb4PgNxbQLgoxdYyoLzrzM
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC29407FF9B1494D9280995569523058@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e80caf01-1817-42b1-ad25-08d7682287dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 10:16:21.5532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wYWniZyf7wvKyP+pi/yG6Fb8FmzZeda7+yLP68+l50fQeK07jhAgSEjXp9FP1l96iMpP1lvsfId8PLTzz8Ix4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4407
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIwMTktMTEtMTMgMTI6MTIgUE0sIFJvaSBEYXlhbiB3cm90ZToNCj4gSGksDQo+IA0K
PiBUaGlzIHNlcmllcyBpcyBmaXhpbmcgb3V0cHV0IGZvciB0b3MgYW5kIHR0bCBpbiBqc29uIGZv
cm1hdC4NCg0KYWxzbyBmaXhpbmcgb3V0cHV0IGZvciBjdF96b25lIGFuZCBjdF9tYXJrLg0KZm9y
Z290IHRvIG1lbnRpb24gaXQgaGVyZS4NCg0KPiANCj4gVGhhbmtzLA0KPiBSb2kNCj4gDQo+IEVs
aSBCcml0c3RlaW4gKDUpOg0KPiAgIHRjX3V0aWw6IGludHJvZHVjZSBhIGZ1bmN0aW9uIHRvIHBy
aW50IEpTT04vbm9uLUpTT04gbWFza2VkIG51bWJlcnMNCj4gICB0Y191dGlsOiBhZGQgYW4gb3B0
aW9uIHRvIHByaW50IG1hc2tlZCBudW1iZXJzIHdpdGgvd2l0aG91dCBhIG5ld2xpbmUNCj4gICB0
YzogZmxvd2VyOiBmaXggbmV3bGluZSBwcmludHMgZm9yIGN0LW1hcmsgYW5kIGN0LXpvbmUNCj4g
ICB0Y191dGlsOiBmaXggSlNPTiBwcmludHMgZm9yIGN0LW1hcmsgYW5kIGN0LXpvbmUNCj4gICB0
YzogZmxvd2VyOiBmaXggb3V0cHV0IGZvciBpcCB0b3MgYW5kIHR0bA0KPiANCj4gIHRjL2ZfZmxv
d2VyLmMgfCAxOSArKystLS0tLS0tLS0tLQ0KPiAgdGMvbV9jdC5jICAgICB8ICA0ICstLQ0KPiAg
dGMvdGNfdXRpbC5jICB8IDgwICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICB0Yy90Y191dGlsLmggIHwgIDYgKysrLS0NCj4gIDQg
ZmlsZXMgY2hhbmdlZCwgNjEgaW5zZXJ0aW9ucygrKSwgNDggZGVsZXRpb25zKC0pDQo+IA0K
