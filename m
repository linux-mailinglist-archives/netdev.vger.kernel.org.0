Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4883111435F
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 16:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbfLEPRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 10:17:44 -0500
Received: from mail-eopbgr30049.outbound.protection.outlook.com ([40.107.3.49]:59776
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725909AbfLEPRm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 10:17:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y29EvO9TvD58L5HOVBoYyNuYi/OG2RnxLmUhq04RNuz9wurUEp0iU75vhc/b6rwV0GcPrKYIbV0kjQDLM2qGT928HAwat1k0a97OfaUz6eBGLjFll4eTZdPcYNGh2XkF/WQ5bwoZB5JxNMO/Vc0S4QriPUFM0kv0L2IYeyFjFGBdnsKRZn88ScCRJSPvvtiIy/c0wugDp1uqeSqDmrWp/7B+B2FP8WlSyozYwFRw2tj7PUQnldIzbYSw/Bzq9Xkpd+gU2ZYmffmWVSOvODwCFdoX9XNkGnMGbT4xYhyDlmwAZs0HbDSm1xzGH+DkSvf77H81jfGCgXSVLzKuAs/Svg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ucI83u8Lxr5pePfonrgcQpXgcqdbjuhgaNYiiuW5G8=;
 b=AKEc1XqtZ9dQhf4sMJAH9Z5da+rKcP0DV7BPSd71XrOsPRNi0t2XasIAMux/wEhqqyvbEiOu/4Ki7W+QBqv6kDZHJ+vqz/WLH95GlDwzUM+61JtnRxp5mJ3CTRotNJnNYjQ3eCw0+VusehCsJw8qdBnYC+SA/RdzwWjJu83ZAtl2K39Eok3+PsnCSWRD45qgB04QRwyRFRm2PAymqcO9/vZ0gdB/BK0FucWS/A2vjtfedwENE9OVuhBPuJ/tPTveJimxlDfWWvKI1t+YU5AoWPAa/IZKwQvpaVmaSpUTlx4DNPYlJ9GFul16o5Kjh9aWR8aD4Q4eMbHQopMGeYy7Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ucI83u8Lxr5pePfonrgcQpXgcqdbjuhgaNYiiuW5G8=;
 b=ECfITUflGAEbBckkGNj2VNW1dQL22pysoFOwzVVk+IusXw5k2me/hWP7A/AJKdtE3BdL6Bi4GO8/Y7fci8utf5/3bq+5DFCIqjERPbvrJaXi/hWTuXd4yxUac/IwY1j6f0SSRdJjXmktxgdbZoGXTePOdPzDADvDoeFSjreM+jQ=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3251.eurprd05.prod.outlook.com (10.171.187.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Thu, 5 Dec 2019 15:17:38 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c%7]) with mapi id 15.20.2516.014; Thu, 5 Dec 2019
 15:17:38 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     wenxu <wenxu@ucloud.cn>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Question about flow table offload in mlx5e
Thread-Topic: Question about flow table offload in mlx5e
Thread-Index: AQHVoD2I/ci1XqDAS0+ihzjR81tg26eVO/4ggAAO9ACAAAbLAIAAPhcAgAAIURCAASLYAIADSReAgAMfuQCAAc3QAIAABvEAgAAPNICAACQZgP//5amAgAcxiYCABXq1AA==
Date:   Thu, 5 Dec 2019 15:17:38 +0000
Message-ID: <e8fadfa2-0145-097b-9779-b5263ff3d7b7@mellanox.com>
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
 <4ecddff0-5ba4-51f7-1544-3d76d43b6b39@mellanox.com>
 <5ce27064-97ee-a36d-8f20-10a0afe739cf@ucloud.cn>
 <c06ff5a3-e099-9476-7085-1cd72a9ffc56@ucloud.cn>
In-Reply-To: <c06ff5a3-e099-9476-7085-1cd72a9ffc56@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR04CA0132.eurprd04.prod.outlook.com (2603:10a6:207::16)
 To AM4PR05MB3411.eurprd05.prod.outlook.com (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 586feb5e-ebab-4bd0-f017-08d77996439a
x-ms-traffictypediagnostic: AM4PR05MB3251:
x-microsoft-antispam-prvs: <AM4PR05MB32511C51952730D0652AC77CCF5C0@AM4PR05MB3251.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:785;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(189003)(199004)(229853002)(2906002)(5660300002)(316002)(99286004)(52116002)(186003)(76176011)(14454004)(11346002)(8936002)(6506007)(53546011)(31696002)(102836004)(81156014)(81166006)(8676002)(6512007)(26005)(86362001)(64756008)(2616005)(6916009)(14444005)(305945005)(4326008)(25786009)(36756003)(478600001)(6486002)(66476007)(31686004)(71200400001)(71190400001)(66556008)(66946007)(66446008)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3251;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: opo2D0cs+L/dXlRLQa2jC9ik5gZcY2mfF8RUs5pbrRHG8XIm0Vw0icm7yd5+RvD/8yNOpg6p8s8Rz0dNbbmmwuh64DzUqrCDxvjUYHSiP7nXD3Uwo7tGN/wREJnyf7G+pRvIW+I/X3kJ6IX54WY7Mzo+3KC+jdzDJdNt+trHEqBbIORqOs3lWpwHatJQaFvTjZ5s1S0yNntHu+S86QqcueBxa4lHvVzdpRdLvRvdNYvONtNKuzkxPqvho/f9QO2ZO+1rvJceK+rfz6GxexjXky1JTJGcJ0lYuiReVgA4Oo+voJm3asHXyGrIsSb9Bq4yTCDYZ+cbiSUS/3cYmIvwqE6y4wbzf7/gnLem4c//B+3WBRFz8Rys0IXYRPvd7ECZ6V5WVT2QUZzGhtumOc7qdEg+2Q2vcc+tO96ivD3oT7gZzXvirYepaeZ3Ss/oTRz8xVN8dTgPsKe1Gn5pukih/ZFQ3Bc1I7EhUd8MvyXUVaM/L/78YVGBQr9e60cLj0/g
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <498787CC85C16444878A985CA66AEADC@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 586feb5e-ebab-4bd0-f017-08d77996439a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 15:17:38.5985
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YH9a4tgSAm/9A/0Ab5CStDE20AKaEOnnwHogf3fGUZT5kqPj1du06Azx3WhBQEeZlsm2xx9B5jHD+6uT2bkxow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3251
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMi8yMDE5IDU6MzcgQU0sIHdlbnh1IHdyb3RlOg0KDQo+IEhpIFBhdWwsDQo+DQo+DQo+
IFNvcnJ5IGZvciB0cm91YmxlIHlvdSBhZ2Fpbi4gSSB0aGluayBpdCBpcyBhIHByb2JsZW0gaW4g
ZnQgY2FsbGJhY2suDQo+DQo+IENhbiB5b3VyIGhlbHAgbWUgZml4IGl0LiBUaHghDQo+DQo+IEkg
ZGlkIHRoZSB0ZXN0IGxpa2UgeW91IHdpdGggcm91dGUgdGMgcnVsZXMgdG8gZnQgY2FsbGJhY2su
DQo+DQo+ICMgaWZjb25maWcgbWx4X3AwIDE3Mi4xNjguMTUyLjc1LzI0IHVwDQo+ICMgaXAgbiBy
IDE3Mi4xNi4xNTIuMjQxIGxsYWRkciBmYTpmYTpmZjpmZjpmZjpmZiBkZXYgbWx4X3AwDQo+DQo+
ICMgaXAgbCBhZGQgZGV2IHR1bjEgdHlwZSBncmV0YXAgZXh0ZXJuYWwNCj4gIyB0YyBxZGlzYyBh
ZGQgZGV2IHR1bjEgaW5ncmVzcw0KPiAjIHRjIHFkaXNjIGFkZCBkZXYgbWx4X3BmMHZmMCBpbmdy
ZXNzDQo+DQo+ICMgdGMgZmlsdGVyIGFkZCBkZXYgbWx4X3BmMHZmMCBwcmVmIDIgaW5ncmVzcyAg
cHJvdG9jb2wgaXAgZmxvd2VyIHNraXBfc3cgIGFjdGlvbiB0dW5uZWxfa2V5IHNldCBkc3RfaXAg
MTcyLjE2OC4xNTIuMjQxIHNyY19pcCAwIGlkIDEwMDAgbm9jc3VtIHBpcGUgYWN0aW9uIG1pcnJl
ZCBlZ3Jlc3MgcmVkaXJlY3QgZGV2IHR1bjENCj4NCj4NCj4gSW4gVGhlIHZtOg0KPiAjIGlmY29u
ZmlnIGV0aDAgMTAuMC4wLjc1LzI0IHVwDQo+ICMgaXAgbiByIDEwLjAuMC43NyBsbGFkZHIgZmE6
ZmY6ZmY6ZmY6ZmY6ZmYgZGV2IGV0aDANCj4NCj4gIyBpcGVyZiAtYyAxMC4wLjAuNzcgLXQgMTAw
IC1pIDINCj4NCj4gVGhlIHN5biBwYWNrZXRzIGNhbiBiZSBvZmZsb2FkZWQgc3VjY2Vzc2Z1bGx5
Lg0KPg0KPiAjICMgdGMgLXMgZmlsdGVyIGxzIGRldiBtbHhfcGYwdmYwIGluZ3Jlc3MNCj4gZmls
dGVyIHByb3RvY29sIGlwIHByZWYgMiBmbG93ZXIgY2hhaW4gMA0KPiBmaWx0ZXIgcHJvdG9jb2wg
aXAgcHJlZiAyIGZsb3dlciBjaGFpbiAwIGhhbmRsZSAweDENCj4gICAgZXRoX3R5cGUgaXB2NA0K
PiAgICBza2lwX3N3DQo+ICAgIGluX2h3IGluX2h3X2NvdW50IDENCj4gCWFjdGlvbiBvcmRlciAx
OiB0dW5uZWxfa2V5ICBzZXQNCj4gCXNyY19pcCAwLjAuMC4wDQo+IAlkc3RfaXAgMTcyLjE2OC4x
NTIuMjQxDQo+IAlrZXlfaWQgMTAwMA0KPiAJbm9jc3VtIHBpcGUNCj4gCSBpbmRleCAxIHJlZiAx
IGJpbmQgMSBpbnN0YWxsZWQgMjUyIHNlYyB1c2VkIDI1MiBzZWMNCj4gCUFjdGlvbiBzdGF0aXN0
aWNzOg0KPiAJU2VudCAwIGJ5dGVzIDAgcGt0IChkcm9wcGVkIDAsIG92ZXJsaW1pdHMgMCByZXF1
ZXVlcyAwKQ0KPiAJYmFja2xvZyAwYiAwcCByZXF1ZXVlcyAwDQo+DQo+IAlhY3Rpb24gb3JkZXIg
MjogbWlycmVkIChFZ3Jlc3MgUmVkaXJlY3QgdG8gZGV2aWNlIHR1bjEpIHN0b2xlbg0KPiAgIAlp
bmRleCAxIHJlZiAxIGJpbmQgMSBpbnN0YWxsZWQgMjUyIHNlYyB1c2VkIDExMCBzZWMNCj4gICAJ
QWN0aW9uIHN0YXRpc3RpY3M6DQo+IAlTZW50IDM0MjAgYnl0ZXMgMTEgcGt0IChkcm9wcGVkIDAs
IG92ZXJsaW1pdHMgMCByZXF1ZXVlcyAwKQ0KPiAJU2VudCBzb2Z0d2FyZSAwIGJ5dGVzIDAgcGt0
DQo+IAlTZW50IGhhcmR3YXJlIDM0MjAgYnl0ZXMgMTEgcGt0DQo+IAliYWNrbG9nIDBiIDBwIHJl
cXVldWVzIDANCj4NCj4gQnV0IFRoZW4gSSBhZGQgYW5vdGhlciBkZWNhcCBmaWx0ZXIgb24gdHVu
MToNCj4NCj4gdGMgZmlsdGVyIGFkZCBkZXYgdHVuMSBwcmVmIDIgaW5ncmVzcyBwcm90b2NvbCBp
cCBmbG93ZXIgZW5jX2tleV9pZCAxMDAwIGVuY19zcmNfaXAgMTcyLjE2OC4xNTIuMjQxIGFjdGlv
biB0dW5uZWxfa2V5IHVuc2V0IHBpcGUgYWN0aW9uIG1pcnJlZCBlZ3Jlc3MgcmVkaXJlY3QgZGV2
IG1seF9wZjB2ZjANCj4NCj4gIyBpcGVyZiAtYyAxMC4wLjAuNzcgLXQgMTAwIC1pIDINCj4NCj4g
VGhlIHN5biBwYWNrZXRzIGNhbid0IGJlIG9mZmxvYWRlZC4gVGhlIHRjIGZpbHRlciBjb3VudGVy
IGlzIGFsc28gbm90IGluY3JlYXNlLg0KPg0KPg0KPiAjIHRjIC1zIGZpbHRlciBscyBkZXYgbWx4
X3BmMHZmMCBpbmdyZXNzDQo+IGZpbHRlciBwcm90b2NvbCBpcCBwcmVmIDIgZmxvd2VyIGNoYWlu
IDANCj4gZmlsdGVyIHByb3RvY29sIGlwIHByZWYgMiBmbG93ZXIgY2hhaW4gMCBoYW5kbGUgMHgx
DQo+ICAgIGV0aF90eXBlIGlwdjQNCj4gICAgc2tpcF9zdw0KPiAgICBpbl9odyBpbl9od19jb3Vu
dCAxDQo+IAlhY3Rpb24gb3JkZXIgMTogdHVubmVsX2tleSAgc2V0DQo+IAlzcmNfaXAgMC4wLjAu
MA0KPiAJZHN0X2lwIDE3Mi4xNjguMTUyLjI0MQ0KPiAJa2V5X2lkIDEwMDANCj4gCW5vY3N1bSBw
aXBlDQo+IAkgaW5kZXggMSByZWYgMSBiaW5kIDEgaW5zdGFsbGVkIDMyMCBzZWMgdXNlZCAzMjAg
c2VjDQo+IAlBY3Rpb24gc3RhdGlzdGljczoNCj4gCVNlbnQgMCBieXRlcyAwIHBrdCAoZHJvcHBl
ZCAwLCBvdmVybGltaXRzIDAgcmVxdWV1ZXMgMCkNCj4gCWJhY2tsb2cgMGIgMHAgcmVxdWV1ZXMg
MA0KPg0KPiAJYWN0aW9uIG9yZGVyIDI6IG1pcnJlZCAoRWdyZXNzIFJlZGlyZWN0IHRvIGRldmlj
ZSB0dW4xKSBzdG9sZW4NCj4gICAJaW5kZXggMSByZWYgMSBiaW5kIDEgaW5zdGFsbGVkIDMyMCBz
ZWMgdXNlZCAxNzggc2VjDQo+ICAgCUFjdGlvbiBzdGF0aXN0aWNzOg0KPiAJU2VudCAzNDIwIGJ5
dGVzIDExIHBrdCAoZHJvcHBlZCAwLCBvdmVybGltaXRzIDAgcmVxdWV1ZXMgMCkNCj4gCVNlbnQg
c29mdHdhcmUgMCBieXRlcyAwIHBrdA0KPiAJU2VudCBoYXJkd2FyZSAzNDIwIGJ5dGVzIDExIHBr
dA0KPiAJYmFja2xvZyAwYiAwcCByZXF1ZXVlcyAwDQo+DQo+ICMgdGMgLXMgZmlsdGVyIGxzIGRl
diB0dW4xIGluZ3Jlc3MNCj4gZmlsdGVyIHByb3RvY29sIGlwIHByZWYgMiBmbG93ZXIgY2hhaW4g
MA0KPiBmaWx0ZXIgcHJvdG9jb2wgaXAgcHJlZiAyIGZsb3dlciBjaGFpbiAwIGhhbmRsZSAweDEN
Cj4gICAgZXRoX3R5cGUgaXB2NA0KPiAgICBlbmNfc3JjX2lwIDE3Mi4xNjguMTUyLjI0MQ0KPiAg
ICBlbmNfa2V5X2lkIDEwMDANCj4gICAgaW5faHcgaW5faHdfY291bnQgMQ0KPiAJYWN0aW9uIG9y
ZGVyIDE6IHR1bm5lbF9rZXkgIHVuc2V0IHBpcGUNCj4gCSBpbmRleCAyIHJlZiAxIGJpbmQgMSBp
bnN0YWxsZWQgMzkxIHNlYyB1c2VkIDM5MSBzZWMNCj4gCUFjdGlvbiBzdGF0aXN0aWNzOg0KPiAJ
U2VudCAwIGJ5dGVzIDAgcGt0IChkcm9wcGVkIDAsIG92ZXJsaW1pdHMgMCByZXF1ZXVlcyAwKQ0K
PiAJYmFja2xvZyAwYiAwcCByZXF1ZXVlcyAwDQo+DQo+IAlhY3Rpb24gb3JkZXIgMjogbWlycmVk
IChFZ3Jlc3MgUmVkaXJlY3QgdG8gZGV2aWNlIG1seF9wZjB2ZjApIHN0b2xlbg0KPiAgIAlpbmRl
eCAyIHJlZiAxIGJpbmQgMSBpbnN0YWxsZWQgMzkxIHNlYyB1c2VkIDM5MSBzZWMNCj4gICAJQWN0
aW9uIHN0YXRpc3RpY3M6DQo+IAlTZW50IDAgYnl0ZXMgMCBwa3QgKGRyb3BwZWQgMCwgb3Zlcmxp
bWl0cyAwIHJlcXVldWVzIDApDQo+IAliYWNrbG9nIDBiIDBwIHJlcXVldWVzIDANCj4NCj4NCj4g
U28gdGhlcmUgbWF5YmUgc29tZSBwcm9ibGVtIGZvciBmdCBjYWxsYmFjayBzZXR1cC4gV2hlbiB0
aGVyZSBpcyBhbm90aGVyIHJldmVyc2UNCj4gZGVjYXAgcnVsZSBhZGQgaW4gdHVubmVsIGRldmlj
ZSwgVGhlIGVuY2FwIHJ1bGUgd2lsbCBub3Qgb2ZmbG9hZGVkIHRoZSBwYWNrZXRzLg0KPg0KPiBF
eHBlY3QgeW91ciBoZWxwIFRoeCENCj4NCj4NCj4gQlINCj4gd2VueHUNCj4NCj4NCj4NCj4NCj4N
Cj4NCkhpIEkgcmVwcm9kdWNlZCBpdC4NCg0KSSdsbCBmaW5kIHRoZSByZWFzb24gYW5kIGZpeCBm
b3IgaXQgYW5kIGdldCBiYWNrIHRvIHlvdSBzb29uLg0KDQpXZSBhcmUgcGxhbmluZyBvbiBleHBh
bmRpbmcgb3VyIGNoYWluIGFuZCBwcmlvIHN1cHBvcnRlZCByYW5nZSwgYW5kIGluIA0KdGhhdCB3
ZSBhbHNvIG1vdmUgdGhlIEZUIG9mZmxvYWQgY29kZSBhIGJpdC4NCg0KSWYgd2hhdCBJIHRoaW5r
IGhhcHBlbnMgaGFwcGVuZWQgaXQgd291bGQgZml4IGl0IGFueXdheS4NCg0KVGhhbmtzLg0KDQo=
