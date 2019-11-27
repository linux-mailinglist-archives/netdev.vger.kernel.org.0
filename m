Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C552810B00A
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 14:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfK0NUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 08:20:25 -0500
Received: from mail-eopbgr50075.outbound.protection.outlook.com ([40.107.5.75]:6118
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726822AbfK0NUY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 08:20:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MssxIVYLm3M9pyEF3waIBsz3tEf/zCCZDwL5tQTiE5Mslfw0y/h89JgR+aZfclA4AT58W8hvninrDjiGwIduJ+wT08Ov0mn4ZpZp2eFvqZxg08vhSjm9fPX3FIBBxz6dpaSmF36HM+rMj64lu514tX5BJpbn8jc7qsNG1wIN0/qYgPWr+CmmFQuIi6XccxvJ5cNjH3jSbIx2R/0L2WTSBnXgCFwZmdlrHPgVpbnTAVW3BPIAkh0bXrU1NZcogDLMnrngTUcx+MILLtJ0PBc4aRIVIRceL8jOCw2w9trGYOjEbk2kRyWTPRlHojqAh2YI87K6pEWL6DAMTaHoc0LrHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=duMqsrdls/+64yw2BJzveu2H2W66M0fUmAU0TtJ3dQA=;
 b=XkQiomMWMDs5kX5Io76w61Qq6CuP1GFvjAWcvzGyUcKY+b+e+KD4xA3Zx+Xlzn3tYCPs8dByKOiKZ4wPCHLJ/Vco3+E7Y8X4WlXknMh8CqN457H5AUJHQn20DgaxVspc2u5vulEyPoQqXAQh7rZwxcab+1OgL6ymakP5mCD6o1NN8ajb03BsGxL8tI10VQp7EI26IOImGKdICJJPTLSvPxGxc05/AIxaY0LUtW3g1hEn/EesTmA6FTZK7BTW/trcO8ePm+DCWQQDYVTWPI5HbNFi6ZQDNZdQ5nh8axW89ZOYkxJGCNo+UZoeZtvMM090G/NmPDi/l8QKYpdG2mQ1mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=duMqsrdls/+64yw2BJzveu2H2W66M0fUmAU0TtJ3dQA=;
 b=pCFzm20JA/COAlVpgKh/YpTR/IChA7AEh2NAzeiCDpljD8u8Erb0H9sGB3AozuDbeZcZHdLhF1BliNmzlI3VqOd1vmQ6YoHaag4Q642/wILMG0GVhAwPFOnbt1sPLUVW3pEwupSTFmAmcnz1Xs5YLzkQhCHBTTyGHgj5D94Z4Xc=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Wed, 27 Nov 2019 13:20:17 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c%7]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 13:20:17 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     wenxu <wenxu@ucloud.cn>
CC:     "pablo@netfilter.org" <pablo@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>
Subject: Re: Question about flow table offload in mlx5e
Thread-Topic: Question about flow table offload in mlx5e
Thread-Index: AQHVoD2I/ci1XqDAS0+ihzjR81tg26eVO/4ggAAO9ACAAAbLAIAAPhcAgAAIURCAASLYAIADSReAgAMfuQCAAc3QAIAABvEAgAAPNICAAAKSgA==
Date:   Wed, 27 Nov 2019 13:20:17 +0000
Message-ID: <4ecddff0-5ba4-51f7-1544-3d76d43b6b39@mellanox.com>
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
 <057b0ab1-5ce3-61f0-a59e-1c316e414c84@mellanox.com>
In-Reply-To: <057b0ab1-5ce3-61f0-a59e-1c316e414c84@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR05CA0052.eurprd05.prod.outlook.com
 (2603:10a6:208:be::29) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3f82ed0d-950a-4f3e-93a1-08d7733c8b9b
x-ms-traffictypediagnostic: AM4PR05MB3313:|AM4PR05MB3313:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB33135AB170A44C27960AAB50CF440@AM4PR05MB3313.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(199004)(189003)(6116002)(25786009)(107886003)(186003)(2616005)(6246003)(6512007)(386003)(6436002)(6506007)(71190400001)(66446008)(66476007)(4326008)(66556008)(64756008)(53546011)(102836004)(26005)(66946007)(3846002)(446003)(6916009)(6486002)(11346002)(36756003)(5660300002)(478600001)(229853002)(81166006)(99286004)(54906003)(66066001)(14454004)(7736002)(8676002)(81156014)(8936002)(71200400001)(316002)(305945005)(2906002)(256004)(31696002)(76176011)(31686004)(86362001)(52116002)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3313;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jZM1CEFIAhtQ78nBvI+pK4G3OabvwqWielk2EB21oMQPHRAz1FUQha5SkhPkhTrxXTH6x0TeYDvvdblUibZwCJKk2T7qxzmYfPOqrE/MXTcOrKi8loayoJXh09vCJLopbbLouZuwxPNOrNWZnYylmj1hD47Y6DMB/J63wk8qO0TPGUY2YnQ4z1kMbOxNF1k9XwxnSQixnE0tMLpBwYz/0AA5O2w9bZ/iRp0Plx+rKiWRdDoUUpaGTHrl6K1QhXBfrVhlcQ6OHM0GFw9NbBw7wYlpuzh3kJ6mBGwg/uk/9U+zNUdMcZZ2TZEbXCq5EUUKvDT4yt15+o3oDoZCqMLvpG3yvXNd89kPgJ7JU//Pb08ICTvFOkIDVsF8U+ENmdHvEIcYueWQWUcIt9ZgRvHSdskFf3UATR+trWkZ7rRKMKS89K/6f+httH+b1rEGFAxg
Content-Type: text/plain; charset="utf-8"
Content-ID: <F2D039EE97092E4CBC51F82BFADDC78D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f82ed0d-950a-4f3e-93a1-08d7733c8b9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 13:20:17.7053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EBN/uyDpbHwNa5Orzt4ayXCkvmXuC2aCq9xufpsnjMwqDmeKHRCzJir3gQ/UwrX50vW/8TBK9C2IxlOGhxmzBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3313
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxMS8yNy8yMDE5IDM6MTEgUE0sIFBhdWwgQmxha2V5IHdyb3RlOg0KPiBPbiAxMS8yNy8y
MDE5IDI6MTYgUE0sIHdlbnh1IHdyb3RlOg0KPg0KPj4gU29ycnkgbWF5YmUgc29tZXRoaW5nIG1l
c3MgeW91LMKgIElnbm9yZSB3aXRoIG15IHBhdGNoZXMuDQo+Pg0KPj4NCj4+IEkgYWxzbyBkaWQg
dGhlIHRlc3QgbGlrZSB5b3Ugd2l0aCByb3V0ZSB0YyBydWxlcyB0byBmdCBjYWxsYmFjay4NCj4+
DQo+Pg0KPj4gcGxlYXNlIGFsc28gZGlkIHRoZSBmb2xsb3dpbmcgdGVzdDrCoCBtbHhfcDAgaXMg
dGhlIHBmIGFuZCBtbHhfcGYwdmYwIA0KPj4gaXMgdGhlIHZmIC4NCj4+DQo+IEFyZSB5b3XCoCBp
biBzd2l0Y2hkZXYgbW9kZSAodmlhIGRldmxpbmspIG9yIGRlZmF1bHQgbGVnYWN5IG1vZGU/DQo+
DQo+DQoNCm1seF9wZjB2ZjAgIGlzIHJlcHJlc2VudG9yIGRldmljZSBjcmVhdGVkIGFmdGVyIGVu
dHJpbmcgc3dpdGNoZGV2IG1vZGU/IGFuZCBldGgwIGluIHZtIGlzIHRoZSBiaW5kZWQgbWx4NSBW
Rj8NCg0KQ2FuIHlvdSBydW4gdGhpcyBjb21tYW5kOg0KDQpzdWRvIGdyZXAgLXJpICIiIC9zeXMv
Y2xhc3MvbmV0LyovcGh5c18qIDI+L2Rldi9udWxsDQoNCmV4YW1wbGU6DQovc3lzL2NsYXNzL25l
dC9lbnMxZjBfMC9waHlzX3BvcnRfbmFtZTpwZjB2ZjANCi9zeXMvY2xhc3MvbmV0L2VuczFmMF8w
L3BoeXNfc3dpdGNoX2lkOmI4MjhhNTAwMDMwNzhhMjQNCi9zeXMvY2xhc3MvbmV0L2VuczFmMF8x
L3BoeXNfcG9ydF9uYW1lOnBmMHZmMQ0KL3N5cy9jbGFzcy9uZXQvZW5zMWYwXzEvcGh5c19zd2l0
Y2hfaWQ6YjgyOGE1MDAwMzA3OGEyNA0KL3N5cy9jbGFzcy9uZXQvZW5zMWYwL3BoeXNfcG9ydF9u
YW1lOnAwDQovc3lzL2NsYXNzL25ldC9lbnMxZjAvcGh5c19zd2l0Y2hfaWQ6YjgyOGE1MDAwMzA3
OGEyNA0KDQphbmQNCnN1ZG8gbHMgL3N5cy9jbGFzcy9uZXQvKi9kZXZpY2UvdmlydGZuKi9uZXQN
Cg0KZXhhbXBsZToNCi9zeXMvY2xhc3MvbmV0L2VuczFmMC9kZXZpY2UvdmlydGZuMC9uZXQ6DQpl
bnMxZjINCg0KL3N5cy9jbGFzcy9uZXQvZW5zMWYwL2RldmljZS92aXJ0Zm4xL25ldDoNCmVuczFm
Mw0KDQphbmQgZXZlbg0KDQpsc3BjaSB8IGdyZXAgLWkgbWVsbGFub3ggOyBscyAtbCAvc3lzL2Ns
YXNzL25ldA0KDQoNCg0KDQoNCg0KVGhhbnNrLg0KDQoNCg==
