Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45FCD233C03
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730771AbgG3XSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:18:20 -0400
Received: from mail-db8eur05on2060.outbound.protection.outlook.com ([40.107.20.60]:11105
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730236AbgG3XSR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 19:18:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXbvpHjapWs1d0OvAXimOUBzrgQDEx9gjdot6BUUX3jBtpCL3JvG7Y0fw/aFxy5S4JGo1Z8d4fsgrjnB//hgHteWyxramZhENB+8oeVrb9RNJCaI36/eGFGtzt8c2FbAXQp2ekwNRutVAQLAXvuuajsWX8H4gFGHWOnWZvP0g0CsoNS8L4ewzDjxHDOXfONSrBspt4LhdlyEZA2hY6Do1BkOAe1eQDTLTlRz1oB3PwQVP/ZAXQR2LZKN6ewc2lT8Rz3uKyPoBp3GugwNxPCzXO0m3HWqqfrVF1YuGY4gwPn/F6vio1uMrpRi7q8KpMiLF52nviP3ygks/PiQcOQ6BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXcI7RZu+CQyym1BYLVmSEokEYMwlhVpgMWZ9KvjSik=;
 b=T6rLOV8xhEpDeaB1q5CbxKDwTj1TRfRwpJuw3Ws4QJeQixYJwCqLAZY4vw5TDRPLaTccE3GQ5fGoI6uLvUhmASl0QPsnALLn/ikddZjmyf2TdzfmU4jvqMqIZ19J+VQuBe6Uth/NThy63AviEF6AxIuXDvvIcoZzCiCsmP5KaZOy41YrhcMDmUeyXBMK0u05X4gMgJRkjh9u/UWXlfJ9vxPWfh8wvitnxpV79/1kb/bQCMSHeOs1XC/t9CFW+oqSo4aS4iggNdG5MUHL+LvIQanT1NaZ/oSZpDbCxT7P800XrLBoD9NhnqtF6wUXrJMLztxZfiUqUpl4/ngjbCFlsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXcI7RZu+CQyym1BYLVmSEokEYMwlhVpgMWZ9KvjSik=;
 b=tgOGjQsPA7JeRslNntXhQi/d7udwxrleZgdXZzfrhHtyR1Jmv/vTqrgMWP6rul98jqGhjTCVudm85pDRemtq2oDWv+buuJFu+bbIlGublhvprwijuoHsMyO00upCT1pf6fFJfi7wXzt72/ooTFEaEtg0ewVfhl2Km4mO0skfX6s=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3517.eurprd05.prod.outlook.com (2603:10a6:802:20::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Thu, 30 Jul
 2020 23:18:12 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Thu, 30 Jul 2020
 23:18:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "songliubraving@fb.com" <songliubraving@fb.com>,
        "hawk@kernel.org" <hawk@kernel.org>, "kafai@fb.com" <kafai@fb.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "xiongx18@fudan.edu.cn" <xiongx18@fudan.edu.cn>,
        "yhs@fb.com" <yhs@fb.com>, "andriin@fb.com" <andriin@fb.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
CC:     "xiyuyang19@fudan.edu.cn" <xiyuyang19@fudan.edu.cn>,
        "tanxin.ctf@gmail.com" <tanxin.ctf@gmail.com>,
        "yuanxzhang@fudan.edu.cn" <yuanxzhang@fudan.edu.cn>
Subject: Re: [PATCH v2] net/mlx5e: fix bpf_prog reference count leaks in
 mlx5e_alloc_rq
Thread-Topic: [PATCH v2] net/mlx5e: fix bpf_prog reference count leaks in
 mlx5e_alloc_rq
Thread-Index: AQHWZlxtuTAQ1g3moE6AlXkzFrMjXakgwqSA
Date:   Thu, 30 Jul 2020 23:18:10 +0000
Message-ID: <913f7fe1d895bc5b80b42e92304d086c6a550193.camel@mellanox.com>
References: <20200730102941.5536-1-xiongx18@fudan.edu.cn>
In-Reply-To: <20200730102941.5536-1-xiongx18@fudan.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.4 (3.36.4-1.fc32) 
authentication-results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ec237e2b-087a-480c-c257-08d834ded42d
x-ms-traffictypediagnostic: VI1PR05MB3517:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3517550AEF7672B59B2624D0BE710@VI1PR05MB3517.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cTRnINQby9zk7+uMY/ApB1PRR26yJ31fb8gc0QkufIXYxvzsAG/p2lIGbkEtwPtMg+IjZ5crMbuixmZma34aIYlFOgj7UrTN97lbP86uztzR0V3nh4bY/f3dy9FukkAshY0GZzo1+RkRWmm8g4Tt/Cb4R99cPTNwdADf6nRtGSN9CJSn3PrRfihGTP1K7zar3ywynTfCIQr7L8AOqoJxRgBfEpCODmgx/9e8mL+dzPpP1Lb1gQDXKJ2i4XpzKPlOWrCxJLFZ7OHM9sSjvQ5scMoDOog5sT6lvVOE1vI3J0Nr+0dmtWY/LncWa2FCE4dnxGZ1c0UozIpK6w6QS0lKO8fsKUhXqBmMl7alxz8/pTj+vcwECgEa+VYNJnToAL19
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(366004)(5660300002)(4326008)(110136005)(6486002)(316002)(8936002)(6512007)(6506007)(6636002)(26005)(186003)(478600001)(54906003)(8676002)(71200400001)(86362001)(4744005)(91956017)(64756008)(76116006)(66476007)(2906002)(36756003)(66446008)(66556008)(2616005)(7416002)(66946007)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: WPlSDd9VC9wZ2hZWEgZT8ram61oXb7Ie621kGJCL/yhi+GQ8cinQPCovgIgSQ4BXSnamacwULOS/ZOYYym5O16/eZ++DPODrp0BAvAMXpzyJfMU9VmtUqtePQUwg+/SJWp3QempoipCIN4YQXihiWSo9bbtmExN6kjSexR/ErdgmGT6YIWIoXAD/ZRhuTMP1AfyhEwQp2k8kVavp3CVw657FQgCwMfdm2iCkv+Xlc474ikdSRLuiFXRl/RQsgrJJpp2ftQnwTEO4E8jkw4ETmz4DOGNW5nGyyBBFNlVMVbYpyy+ySVpYUgtXkw/LTbUYoXC8/awEx2uCQCCkCqdlyoVaulIaoMfbIbysuxv5J4CdINE1ychScElm1CncyYDAdVF1XPCHacVfP+oAhLnUxhyr8qMwUesTq6NV2i7QSSZRXnEPKa9OBpg+vwlS8nIz0pb+94eKw+hsj0emmYCvA9oB5Ys3jtmPHTOQ8rmbZrQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <60823BD76E9F244EAD3C285D40895CC9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec237e2b-087a-480c-c257-08d834ded42d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 23:18:11.7921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6dm4iwH39JF0kkUE8l7KzEXEzGmJ9lWKg4XucliqpWNTDO02rvatrouekc9xKUnbWaDs6IJAOzhY/zRPuXgnWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3517
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA3LTMwIGF0IDE4OjI5ICswODAwLCBYaW4gWGlvbmcgd3JvdGU6DQo+IFRo
ZSBmdW5jdGlvbiBpbnZva2VzIGJwZl9wcm9nX2luYygpLCB3aGljaCBpbmNyZWFzZXMgdGhlIHJl
ZmVyZW5jZQ0KPiBjb3VudCBvZiBhIGJwZl9wcm9nIG9iamVjdCAicnEtPnhkcF9wcm9nIiBpZiB0
aGUgb2JqZWN0IGlzbid0IE5VTEwuDQo+IA0KPiBUaGUgcmVmY291bnQgbGVhayBpc3N1ZXMgdGFr
ZSBwbGFjZSBpbiB0d28gZXJyb3IgaGFuZGxpbmcgcGF0aHMuIFdoZW4NCj4gZWl0aGVyIG1seDVf
d3FfbGxfY3JlYXRlKCkgb3IgbWx4NV93cV9jeWNfY3JlYXRlKCkgZmFpbHMsIHRoZQ0KPiBmdW5j
dGlvbg0KPiBzaW1wbHkgcmV0dXJucyB0aGUgZXJyb3IgY29kZSBhbmQgZm9yZ2V0cyB0byBkcm9w
IHRoZSByZWZlcmVuY2UgY291bnQNCj4gaW5jcmVhc2VkIGVhcmxpZXIsIGNhdXNpbmcgYSByZWZl
cmVuY2UgY291bnQgbGVhayBvZiAicnEtPnhkcF9wcm9nIi4NCj4gDQo+IEZpeCB0aGlzIGlzc3Vl
IGJ5IGp1bXBpbmcgdG8gdGhlIGVycm9yIGhhbmRsaW5nIHBhdGgNCj4gZXJyX3JxX3dxX2Rlc3Ry
b3kNCj4gd2hpbGUgZWl0aGVyIGZ1bmN0aW9uIGZhaWxzLg0KPiANCj4gRml4ZXM6IDQyMmQ0YzQw
MWVkZCAoIm5ldC9tbHg1ZTogUlgsIFNwbGl0IFdRIG9iamVjdHMgZm9yIGRpZmZlcmVudA0KPiBS
UQ0KPiB0eXBlcyIpDQo+IA0KDQpQbGVhc2UgZG9uJ3QgYnJlYWsgdGhlIGxpbmUgb2YgdGhlIGZp
eGVzIHRhZy4NCkkgd2lsbCBmaXggdGhpcyB1cC4NCg0KPiBTaWduZWQtb2ZmLWJ5OiBYaW4gWGlv
bmcgPHhpb25neDE4QGZ1ZGFuLmVkdS5jbj4NCj4gU2lnbmVkLW9mZi1ieTogWGl5dSBZYW5nIDx4
aXl1eWFuZzE5QGZ1ZGFuLmVkdS5jbj4NCj4gU2lnbmVkLW9mZi1ieTogWGluIFRhbiA8dGFueGlu
LmN0ZkBnbWFpbC5jb20+DQo+IC0tLQ0KPiB2MSAtPiB2MjoNCj4gLSBBbWVuZGVkIHBhcnRzIG9m
IHdvcmRpbmcgdG8gYmUgYmV0dGVyIHVuZGVyc3Rvb2QNCj4gLSBBZGRlZCBGaXhlcyB0YWcNCj4g
LS0tDQoNCkFwcGxpZWQgdG8gbmV0LW1seDUsIFRoYW5rcyAhDQoNCg==
