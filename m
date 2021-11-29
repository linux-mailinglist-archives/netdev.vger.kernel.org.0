Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C5746157B
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 13:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhK2Mvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 07:51:43 -0500
Received: from mail-vi1eur05on2102.outbound.protection.outlook.com ([40.107.21.102]:11393
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233002AbhK2Mtm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 07:49:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNm6s1Dc/c5FcP3Hag2A/mUMPJsMoMpPj8/EzVoLj3/8VHONqLV2f6zi9Z7lgpIpnfyk5l5qCONAOFDG2TaMglq/a7GGUzKfeu5Qs8tbT/DVULeZv6Rd9HmMMUwIpb1z3kbqUEv9ViuBQZZVRbzktINfTea/vush0UjcSR7zcI7r+/16QHJBlUHrcKYOWehZZTHjBj3xNk3qqrIrgKIiOkU9iHI2XSnwfQHmArQ6fr87lQgDcaTpauSyIMy7caYTJVY8qf7xo23y/pyCzUH3R7DmBeQ9kbqu/rIBEAINHejtKhFDlU+rqNqFOpT6Gr89468L8v1z9SqO43bD2Jhvmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=na8wvAqSNvqecdWJVPoxdUtBnJPPkJZslNgMYiuRq9Q=;
 b=ZMkJ0EnbrdNbNxT2b5tyB/W+Fq2uAi0h0o4Wnbo7b4+z0FCOSbr0mrt/043F2S6VZBAg0Q9U+SCAWwLhM6qONjgHhYlX0/sH9XJPCwOOfMQiAeNUDsGrKNE/Emddq6iGvbbSix21dRjrVqBRg6PwZIj/IqtzCJb8nV8xElssnyapwM5yQb+9TKxm69Y8QD5k0g2eW7Eu1glwjEYFSJU33TNXN56CmqglbZQTI7NDliKusAsVFZdqbAFF2CZZPxZkBLxd7F77Z18kiXzDwDwVLsHqxpXEKwrfLpxxq0kqer8esaflw3OhBV/LuxSO0RrT2n8WdeDD2gFiW/jMSQ/QXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=na8wvAqSNvqecdWJVPoxdUtBnJPPkJZslNgMYiuRq9Q=;
 b=YHgCvmM9f41N+76rUx9cLw3CtRaShw2U9TuBUYZGt3Zk/CBNhRcqVDonoHxeAsY2zoCW5A+rFs4znd9VWSHO7EpB45Nqhf7XplHD7RfmnxvZe2yOU0Oidn39Cs5TITOIGz28CPqbT5q097p0h7amFj/K/wlRDuMhDy3tarQCeO4=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AS8PR03MB6774.eurprd03.prod.outlook.com (2603:10a6:20b:295::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 12:46:23 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::9d54:99ff:d6f4:9c63]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::9d54:99ff:d6f4:9c63%3]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 12:46:23 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH net 3/3] net: dsa: rtl8365mb: set RGMII RX delay in steps
 of 0.3 ns
Thread-Topic: [PATCH net 3/3] net: dsa: rtl8365mb: set RGMII RX delay in steps
 of 0.3 ns
Thread-Index: AQHX4sQywchAVGwyl0ag8mfEEb5J9qwVxMaAgAABR4CABK1ZAIAABUmA
Date:   Mon, 29 Nov 2021 12:46:23 +0000
Message-ID: <8a6fd8c4-d6ea-973e-4344-773b70c46b15@bang-olufsen.dk>
References: <20211126125007.1319946-3-alvin@pqrs.dk>
 <8F46AA41-9B98-4EFA-AB2E-03990632D75C@arinc9.com>
 <46bd63ea-b153-e3ad-3cee-eb845e6b2709@bang-olufsen.dk>
 <42ec21b6-07c0-9724-35e2-b4cc2050265f@arinc9.com>
In-Reply-To: <42ec21b6-07c0-9724-35e2-b4cc2050265f@arinc9.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a43d366-3ecd-4427-f6e7-08d9b336400e
x-ms-traffictypediagnostic: AS8PR03MB6774:
x-microsoft-antispam-prvs: <AS8PR03MB6774EB019B62BB861FC9758783669@AS8PR03MB6774.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LDGsVBjOwDq5+hFBSwa6xjTccYoMcSOvfA1ur/xgQ04cx7v6Y2/PByXGSNZspCq8Dm2mbOi/gBdRmFgU8f7PvSk/qoTenzb/+3pNxauZSKlfS4FUELhx60Ks1Kpr9BCg88Jo7X5tAypDO1WmL7DYMjD+g0fKgPYmTpirRR8pE9CGlOjZLEzadExWf+fEXZtM4/IEdyU9l21y95GBNNt+dLplYdET4cSeQeD+yu8T1Mz9FW4PVOxOGoqvVIZACr8v3UTb6gNiXZrHZdOdEhTFsQ0n16HLSSj4WTUvHkRlYvDqILVRQqxFBEEXTp8UvxRoFW/qLYrRbCJnv7VAHjvKRXnfEvL2kVe7kn/Nhwvy9VmDUalL9RqIiozPkBw+6T2uPaPTc7wzuLSPeu8ThSCX2l5yA0FfdsgTb2wCYnKkcYbL4+/UHOx0Fi9qYnkPMbhJ6w2bnD1nHLlM1IiRNI0ka0Ta4rwPrZ4tTA6N6JE/3OIJA7ZjaCu7N1iKdg4+aQOQ99srtffR1YKULN/e7y7/2kGsrBVQZwpZFxt9qCQkWQukUCpEFtx0h2V77eo89WaJlsx/OStiJyPLUbE6Fk3Lad/VP/IDR4uM7qOrDC4Q4RM5l9fQrJd1ifyfbSXGZTiGcUroKGEpxcz5fDOoBEKxw7YmS9/77WOlDNTr0EbcP8e6d+57DBTRe3FZq9GC9Dxl3LqZlL7zuB6eDFf4oJ1nYDklZ3QO5g1jecih89Fk3ozWjKyjAHEpjJLRwfJJQqw7hn9LSjVggFOYEHmd71AwQQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(66946007)(2616005)(66476007)(36756003)(64756008)(31696002)(8676002)(53546011)(66574015)(6506007)(66556008)(508600001)(2906002)(54906003)(110136005)(71200400001)(83380400001)(5660300002)(316002)(38070700005)(91956017)(76116006)(8976002)(6512007)(26005)(38100700002)(122000001)(8936002)(186003)(85202003)(31686004)(86362001)(4326008)(66446008)(85182001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2ZmQ0xVamZWSEVCckxRYVlwSVVyMWo1WHpwMzVTTlZBUldtWG9WRG03eFho?=
 =?utf-8?B?Ym5XRSswNHdIVm5KU3Z2bm1rVTRRbldOTHFsUzhFVVlXOFA2UVlqUmV3WEtH?=
 =?utf-8?B?NTdMNkNpVTc4N2V1cUV5cXZWeEIxQkdWZWZQS3ZSaTdjdnc1bWRPTjBwWFNT?=
 =?utf-8?B?VXNZSzJQU2JFZ0ExTG0wUDJiY2swRlNwVzZDcUNSRVZPeVhvNGpXK1lkaG40?=
 =?utf-8?B?bWpBVFlmRHdiQnJYT05RUWo5eUZSR0dEc0tVcGRVdFV2RVZZN0RyQ0ZjdEVZ?=
 =?utf-8?B?bDJnQmhxNllHaWZ0Z3dtS1RBa2dnM1dyTENKY3lrWmFZUzVxQmRBdjdtWWx2?=
 =?utf-8?B?OWhjQzFyVWc3R1RPWFNJbmRlaEdHY1J1YTZVSnltZDhnV1IxeWZWbWY5UWM5?=
 =?utf-8?B?RkM0THFmQUd5WEpJak9MdnR6c3FxdXl3Ymt4d3dUVi9abFNLdzcyams5dkJI?=
 =?utf-8?B?T0VpbG5IVExDT0ZjK3V6WHNhS1RNL0VXdHdBbjFidmxUQVRHNkVvQkJhVlNR?=
 =?utf-8?B?RkFFTzE4b1dZTVNtbEpyQTRreWttRXQxTktmNUxhV3VQNWR6TUdVcStQRnRZ?=
 =?utf-8?B?TFh6KzZHRVVBSytVZXdWSGJOZndybXhwUXBqNHYrTllrVS9OQm94RWtFck5Z?=
 =?utf-8?B?S29JNnk5M0huZEs3ZHNidTA0VC91M1J6T0dGZ2lSM0tGOVNLV1ZEMHNmUDY2?=
 =?utf-8?B?bkhwSzRmR0puVTc4enRoUm40Z0gzZlJmUGQyU2c4TkRkNkhLbWhiYTF2Njhh?=
 =?utf-8?B?aFN0bDUydlZydGc4SkdjVERzS2NMeTNPVGFpNTNQcCtoSGpBUllaOWUwRFc4?=
 =?utf-8?B?dXM5Vmk0SGhIVXFKWVpKOE1jcEdRdGJDNHJtZmxFdGp0cWx6UmlFbHlwRHVM?=
 =?utf-8?B?Zk9YQVBjdzN4RXE3RXNOS1NZYXlNNS9KYjZDcmpmZW9NMysxZ3liL2xqOE83?=
 =?utf-8?B?c3BJaVhFekNiM3RaUGxwR0VlTW5mSmMzZmpabUQ0bFYydEtVVjhnWld5VHla?=
 =?utf-8?B?MXhyMzFadENGMGR1OWpSZFN5L3FsYUplRm45cnpwdDViVUhCZHFpckVIQUk3?=
 =?utf-8?B?T0JZOVpUVWF3bDdoWnpEOW5kYkx5VXpwbm9IeXdadVE2RkVFdlFHdFc4dmVC?=
 =?utf-8?B?K3hJZEZIcmNtVFJnZzZpZWtsRzRWUFFTd2Z2c0o4bVNEZm5VRXljSThHMTBC?=
 =?utf-8?B?QmpnV0s3RTY4VVpvZytFRGpyVkxWVVBwMjAxNW82cHl3K0tHdjE0bDdkZ1RC?=
 =?utf-8?B?bTNoUi9OUHBmUm42YkZ0cnhzbXdKbjh6bEdycWI0NlJ3SW5aak1KK28rQkdh?=
 =?utf-8?B?T1VlZUFLazhKQUxSdWNZYWxRamF3WitmMUdOS1NFdzZjODd3c2RBais0SDBM?=
 =?utf-8?B?eklJVlJlSDNiZ0FtWFg4anpIYmhMbFc2NkxoOTNzaHNJZjd3WGZiYU4raEtK?=
 =?utf-8?B?MkowSXBOdzU0K2gvWENpWUtrWDR5eUx4NDUzMHNFbUp0aTYyb0tOVVUzSWJI?=
 =?utf-8?B?Q0krSlY1WVVQam4rYkhRQk44aG5IZm0zcW43YjJpdVFJamJVQW4vZmVXQ3g1?=
 =?utf-8?B?aTUrRkNtRnRhSXhFZkllMEQwY3padFZJL3dDTHBqMjZSbndkY0xvOVpVYWo1?=
 =?utf-8?B?V0kyY0pRWDdrbk15WDd1RU5nMVFXWWlKZzYrbVV0MW1NVWdSYXVZUEhFL3U4?=
 =?utf-8?B?dWVFQUhoMENZWFRaQVpSaDVNdCs1RU9EUU80a2NTUHBjQXc5LzJvSXVXcXFp?=
 =?utf-8?B?S21DVlBISWJqZjA3azdkRXkwUTlZdlc2SzdDckQvc2JtUUd4S0ZlMkFxcHda?=
 =?utf-8?B?aXVnOEVCdHZEOHNJbysxVzRqQ2hHWTJ0bTBQeDlSS2xQVWZIVm1DMDI4bXJS?=
 =?utf-8?B?TzVhL002N0FsVUkrY0FLeWRjOTFVSTdNNnExRi9aZkx6RWtCeUw2NmpqQmN2?=
 =?utf-8?B?eHlLSzhrbElpeEZOdGZvTUxuUTBPTEJwSVgxZnFEb2ZWWlAyVkt3Nk5lb3p1?=
 =?utf-8?B?dTN6bUxZVzdZclY0TkxzZ25ad05nRFl2YjZIVTBMV3VadElpRklwM2tQeDZP?=
 =?utf-8?B?VGc2REdPRlhtblVzbWNidFdiWjhDYThOdk5qbWVtNmVyR3Bab2pHTDJONUk3?=
 =?utf-8?B?K3ZJMUY2QSthTWExblRITWU4QjMvRlAvbVFaM0h4NnRNaFVCUld0YytHZlc0?=
 =?utf-8?Q?+vbhCSt83bZCgb3b8Avlbew=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <41FBA465CF3FDE4F8E49F0B14F7B341F@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a43d366-3ecd-4427-f6e7-08d9b336400e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 12:46:23.3334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BzV+D4fdRYjNDViKJYSg4j9UknBlLE+3x97ImT2ZNSTg9eOauEWGMYqgkg+AZBJ4oG+Drb/7T351A4dvwUYUCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6774
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQXLEsW7DpywNCg0KT24gMTEvMjkvMjEgMTM6MjcsIEFyxLFuw6cgw5xOQUwgd3JvdGU6DQo+
IEhleSBBbHZpbi4NCj4gDQo+IE9uIDI2LzExLzIwMjEgMTY6MDEsIEFsdmluIMWgaXByYWdhIHdy
b3RlOg0KPj4gSGkgQXLEsW7DpywNCj4+IE9uIDExLzI2LzIxIDEzOjU3LCBBcsSxbsOnIMOcTkFM
IHdyb3RlOg0KPj4+PiBPbiAyNiBOb3YgMjAyMSwgYXQgMTU6NTAsIEFsdmluIMWgaXByYWdhIDxh
bHZpbkBwcXJzLmRrPiB3cm90ZToNCj4+Pj4NCj4+Pj4g77u/RnJvbTogQWx2aW4gxaBpcHJhZ2Eg
PGFsc2lAYmFuZy1vbHVmc2VuLmRrPg0KPj4+Pg0KPj4+PiBBIGNvbnRhY3QgYXQgUmVhbHRlayBo
YXMgY2xhcmlmaWVkIHdoYXQgZXhhY3RseSB0aGUgdW5pdHMgb2YgUkdNSUkgUlgNCj4+Pj4gZGVs
YXkgYXJlLiBUaGUgYW5zd2VyIGlzIHRoYXQgdGhlIHVuaXQgb2YgUlggZGVsYXkgaXMgImFib3V0
IDAuMyBucyIuDQo+Pj4+IFRha2UgdGhpcyBpbnRvIGFjY291bnQgd2hlbiBwYXJzaW5nIHJ4LWlu
dGVybmFsLWRlbGF5LXBzIGJ5DQo+Pj4+IGFwcHJveGltYXRpbmcgdGhlIGNsb3Nlc3Qgc3RlcCB2
YWx1ZS4gRGVsYXlzIG9mIG1vcmUgdGhhbiAyLjEgbnMgYXJlDQo+Pj4+IHJlamVjdGVkLg0KPj4+
Pg0KPj4+PiBUaGlzIG9idmlvdXNseSBjb250cmFkaWN0cyB0aGUgcHJldmlvdXMgYXNzdW1wdGlv
biBpbiB0aGUgZHJpdmVyIHRoYXQgYQ0KPj4+PiBzdGVwIHZhbHVlIG9mIDQgd2FzICJhYm91dCAy
IG5zIiwgYnV0IFJlYWx0ZWsgYWxzbyBwb2ludHMgb3V0IHRoYXQgDQo+Pj4+IGl0IGlzDQo+Pj4+
IGVhc3kgdG8gZmluZCBtb3JlIHRoYW4gb25lIFJYIGRlbGF5IHN0ZXAgdmFsdWUgd2hpY2ggbWFr
ZXMgUkdNSUkgd29yay4NCj4+Pj4NCj4+Pj4gRml4ZXM6IDRhZjI5NTBjNTBjOCAoIm5ldDogZHNh
OiByZWFsdGVrLXNtaTogYWRkIHJ0bDgzNjVtYiBzdWJkcml2ZXIgDQo+Pj4+IGZvciBSVEw4MzY1
TUItVkMiKQ0KPj4+PiBDYzogQXLEsW7DpyDDnE5BTCA8YXJpbmMudW5hbEBhcmluYzkuY29tPg0K
Pj4+PiBTaWduZWQtb2ZmLWJ5OiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZzZW4uZGs+
DQo+Pj4NCj4+PiBBY2tlZC1ieTogQXLEsW7DpyDDnE5BTCA8YXJpbmMudW5hbEBhcmluYzkuY29t
Pg0KPj4NCj4+IEkga25vdyB5b3Ugc3VibWl0dGVkIGEgZGV2aWNlIHRyZWUgdXNpbmcgdGhpcyBk
cml2ZXIgd2l0aA0KPj4gcngtaW50ZXJuYWwtZGVsYXktcHMgPSA8MjAwMD4uIFdvdWxkIHlvdSBj
YXJlIHRvIHRlc3QgeW91ciBkZXZpY2UgdHJlZQ0KPj4gd2l0aCB0aGlzIHBhdGNoIGFuZCBzZWUg
aWYgaXQgbmVlZHMgdXBkYXRpbmc/IEJlZm9yZSB0aGlzIHBhdGNoLCB0aGUNCj4+IGRyaXZlciB3
b3VsZCBjb25maWd1cmUgYSBzdGVwIHZhbHVlIG9mIDQuIEFmdGVyIHRoaXMgcGF0Y2ggaXQgd2ls
bA0KPj4gY29uZmlndXJlIGEgc3RlcCB2YWx1ZSBvZiA3Lg0KPj4NCj4+IElmIHlvdSBleHBlcmll
bmNlIHByb2JsZW1zIHRoZW4gd2Ugd2lsbCBoYXZlIHRvIHVwZGF0ZSB0aGUgZGV2aWNlIHRyZWUN
Cj4+IGFnYWluLCBhc3N1bWluZyB0aGlzIHBhdGNoIGlzIGFjY2VwdGVkLg0KPiBJIGp1c3QgdGVz
dGVkIHRoZSBkcml2ZXIgd2l0aCB0aGlzIHBhdGNoIG9uIDUuMTUuIFRoZSBzd2l0Y2ggc2VlbXMg
dG8gDQo+IHJlY2VpdmUvdHJhbnNtaXQgZnJhbWVzIHRocm91Z2ggdGhlIGNwdSBwb3J0IHdpdGgg
cngtaW50ZXJuYWwtZGVsYXktcHMgPSANCj4gPDIwMDA+IGZpbmUuDQoNCkdyZWF0LCB0aGFua3Mg
YSBsb3QgZm9yIHRlc3RpbmchDQoNCj4gDQo+IFNob3VsZCB3ZSB1cGRhdGUgdGhlIGRldmljZSB0
cmVlIHRvIHVzZSAyMTAwIHBzIGZvciByeC1pbnRlcm5hbC1kZWxheS1wcyANCj4gYW55d2F5Pw0K
DQpVbmRlciB0aGUgaG9vZCB0aGUgZHJpdmVyIHdpbGwgZG8gdGhlIHNhbWUgdGhpbmcsIHNvIGl0
J3Mgbm90IG5lY2Vzc2FyeS4NCg0KPiANCj4gQXLEsW7Dpw0KDQo=
