Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C9710AFF5
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 14:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfK0NLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 08:11:10 -0500
Received: from mail-eopbgr150050.outbound.protection.outlook.com ([40.107.15.50]:56606
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726514AbfK0NLK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 08:11:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPSTxtFNdw0AP847URNZU+Kad5YRbzt8tIfCtOHMP7lcS/mq/gy75L2Hqb9x2wTnl+FxAXXhFc/54lnCRKzexiSPEkmUg9b7Ul85O4g5y2uBe0KjPpCBgSZSIidT92AiU9Ks/hM6sb8YGQiIhqEI3YAdQ3EnSPbt0kDtynxJKefdSDJHYaEOWSCdH463N4vO+pcgoLG32q18VFTX956Ba7pQLUfJG7KGCQFnzZ4CIOW0CBJrH3ZJWejxBcnqJF6c78m8Hzx02cTJP2S78/Nw1JQApXFL11I8H/ns5b8+fWb2l/4RaPEaQKuh0/+pfU0drKk8uc3nft4F2XQOLmURHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9X5+fyoPc7pCiG3U/xL4coIOUKpsms6Uqx7TEtdiHw=;
 b=Ib7wxECbASIRUmyxqSmPPNJPL+DKMYENbBsOSRSY5go2P6+k/9vCHkPEvK2AMHKQARhgwlueAI+C7sNrk6z4AB7jzpFegxXUj2K6ibukbakJQPoTcnoZ6LkFheHpBdpKdZQ4w5C9vNe3hVicAjA8rk7C0OWoWB9uCEVz/LFlz0XllnAwexJ5gb7DmlieWKdSS6U3I3Xil7DBEJrflzTFcqScLF2kXe3B2dU2zxke9/VVYP3CvOOR9m3QK3fYKRjVVfi2aXrNmL7OGl29HqMkOmWQfWBwBvf1hFjFRzB+W980J1RKU4fxDJPEAm02W7d+vkhkLjeGhUk/UuinpFLZXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9X5+fyoPc7pCiG3U/xL4coIOUKpsms6Uqx7TEtdiHw=;
 b=Io5gcWT+UmJq5GraA7W+VRyca3R5t24MpcsrcQVSxoiO1wtXdbLlY1tOfoYyhd2WFGUu2Q5ImSmnFtjxVoKl4i/y96LdZ7I4diJAZV8aNcrvH1zPg94qr2JiKNfGmG5MHIfGGjsjsihx/2X+6xWJ6g3XFPHBG+Ktp6/0wV8sovg=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3347.eurprd05.prod.outlook.com (10.171.191.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Wed, 27 Nov 2019 13:11:05 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c%7]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 13:11:05 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     wenxu <wenxu@ucloud.cn>
CC:     "pablo@netfilter.org" <pablo@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>
Subject: Re: Question about flow table offload in mlx5e
Thread-Topic: Question about flow table offload in mlx5e
Thread-Index: AQHVoD2I/ci1XqDAS0+ihzjR81tg26eVO/4ggAAO9ACAAAbLAIAAPhcAgAAIURCAASLYAIADSReAgAMfuQCAAc3QAIAABvEAgAAPNIA=
Date:   Wed, 27 Nov 2019 13:11:05 +0000
Message-ID: <057b0ab1-5ce3-61f0-a59e-1c316e414c84@mellanox.com>
References: <1574147331-31096-1-git-send-email-wenxu@ucloud.cn>
 <20191119.163923.660983355933809356.davem@davemloft.net>
 <2a08a1aa-6aa8-c361-f825-458d234d975f@ucloud.cn>
 <AM4PR05MB3411591D31D7B22EE96BC6C3CF4E0@AM4PR05MB3411.eurprd05.prod.outlook.com>
 <f0552f13-ae5d-7082-9f68-0358d560c073@ucloud.cn>
 <VI1PR05MB34224DF57470AE3CC46F2CACCF4E0@VI1PR05MB3422.eurprd05.prod.outlook.com>
 <746ba973-3c58-31f8-42ce-db880fd1d8f4@ucloud.cn>
 <VI1PR05MB3422BEDAB38E12C26DF7C6C6CF4E0@VI1PR05MB3422.eurprd05.prod.outlook.com>
 <64285654-bc9a-c76e-5875-dc6e434dc4d4@ucloud.cn>
 <AM4PR05MB3411EE998E04B7AA9E0081F0CF4B0@AM4PR05MB3411.eurprd05.prod.outlook.com>
 <1b13e159-1030-2ea3-f69e-578041504ee6@ucloud.cn>
 <84874b42-c525-2149-539d-e7510d15f6a6@mellanox.com>
 <dc72770c-8bc3-d302-be73-f19f9bbe269f@ucloud.cn>
In-Reply-To: <dc72770c-8bc3-d302-be73-f19f9bbe269f@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR02CA0015.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::28) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e5c91789-fb3f-4e1b-3e6e-08d7733b4286
x-ms-traffictypediagnostic: AM4PR05MB3347:|AM4PR05MB3347:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB334738F6C6B4ADA39F10867CCF440@AM4PR05MB3347.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(199004)(189003)(8676002)(386003)(25786009)(6506007)(53546011)(11346002)(446003)(8936002)(54906003)(316002)(107886003)(6246003)(76176011)(81166006)(71190400001)(71200400001)(66476007)(229853002)(86362001)(81156014)(66446008)(5660300002)(102836004)(4326008)(26005)(52116002)(256004)(7736002)(6486002)(305945005)(4744005)(2906002)(2616005)(66556008)(64756008)(66946007)(99286004)(6436002)(31696002)(6916009)(6116002)(478600001)(186003)(6512007)(36756003)(66066001)(14454004)(31686004)(3846002)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3347;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ++ZkTAtLqcltF7NT9FmJ5XrDS1taTYUiBwmj9dOGN8YHnIv6OtaQDOglxGxprVnFMSimmWSUtFfi3jDd7OoTTkkR4MNYRia6IQewpXhNf2zyntJSuyRfc1WQaOCCkqiLyry3ORUpiq5UnphBZChELkZEO7HiyrTdn/wM30a3U/LDIaY5Clbee8AWKfrS9qQVfqHSKicckh/K0mHco0+WM5TIH3q2453NHvIA9tHk6vs4cDzQOzXKvI1vywuk4+pvNLTH/u8JIrCr7Dt6QU8p9gy6NAGUSw5HLuY9i0267FweD87/bt1NZta7CPC98xGUph3f01rSQM+U4w+WoIm5R4qoTmFUhQru2ETs6rOBwuhck8ptyDWsXaKhaT/rnYla11AiVhXH94NcEml5ndkf7OYdAR8Q7n4Tldnd1TJVjqmqblnuGnhquMJTn0D20MVN
Content-Type: text/plain; charset="utf-8"
Content-ID: <2F6EC8E6882FCF40B9CC67F903409726@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5c91789-fb3f-4e1b-3e6e-08d7733b4286
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 13:11:05.6061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gRPhVpKp4zu5+a1oNIYlxioUKjGz3ZkJ7i2MnUU9PPj2fxwv7bXyn7Jhimwftxx6txor1oVuyVOQ5/0QqVr9NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3347
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMjcvMjAxOSAyOjE2IFBNLCB3ZW54dSB3cm90ZToNCg0KPiBTb3JyeSBtYXliZSBzb21l
dGhpbmcgbWVzcyB5b3UswqAgSWdub3JlIHdpdGggbXkgcGF0Y2hlcy4NCj4NCj4NCj4gSSBhbHNv
IGRpZCB0aGUgdGVzdCBsaWtlIHlvdSB3aXRoIHJvdXRlIHRjIHJ1bGVzIHRvIGZ0IGNhbGxiYWNr
Lg0KPg0KPg0KPiBwbGVhc2UgYWxzbyBkaWQgdGhlIGZvbGxvd2luZyB0ZXN0OsKgIG1seF9wMCBp
cyB0aGUgcGYgYW5kIG1seF9wZjB2ZjAgaXMgdGhlIHZmIC4NCj4NCkFyZSB5b3XCoCBpbiBzd2l0
Y2hkZXYgbW9kZSAodmlhIGRldmxpbmspIG9yIGRlZmF1bHQgbGVnYWN5IG1vZGU/DQoNCg0K
