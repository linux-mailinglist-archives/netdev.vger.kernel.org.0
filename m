Return-Path: <netdev+bounces-11036-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 165C6731333
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:08:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A71A1C20E2B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06574566D;
	Thu, 15 Jun 2023 09:08:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5863659
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 09:08:43 +0000 (UTC)
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2125.outbound.protection.outlook.com [40.107.117.125])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0962130;
	Thu, 15 Jun 2023 02:08:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RzE/OMmEu4EvLM0QLmdC+O9obh6f3bWlIuxwUCG44bhvmVxm/wDojUdCauhmn9UMQZkr5PbqMMsY611vchZLjqJ+nJLq8C3kgQSTDoXXRntppvELx0qylhFWIbKAMpSAGgGxMfZ9kfyf6a2iNAZ1TDGxpROY0pV3LdoEWz8Go23qKMHkmYVuldGmhX/D8YEF7s5EaVXDtarJ4fkaEnABAiXrWBBcngvBBXmtownrs5iu1n83nS8BP+T+z0XNvff27JkkrzxZZl/e/0PeXkl1pmA9KjfRkGYy2B1kwXGEvZPdxtm7u2vMtO4y7Bm7DDbfWkoFt+IQwS4glTaGGIpjLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WcDF4dAg75vpGUQKUExPwCDMvyfWebnPH63MlpdE8Ko=;
 b=LYlhmaDDtGFn4uolEis3FqF6ijXwH8PzhPrfBzhvmMX5Os6pAdTJV0Nk6T3FpEC2RWaDivxnBhOqb5i24HXGZS1kZV9yrVs6qpI+eMO2zpwum0WjSzrevAjGCtinXCx85So9DCsb+ISOTQKD66fn60waqUaQBoGFXyc7uLJ/CQdKtaDJIeNZrshqdnZPGQCFSrgP5B/OWP8C3w4pYQq17X/oO1+umKG+dgainHOLSPMvxczw7Qt37YoPptSxsB45w2665Nv4e4/9VIKmLR1MsiAIP5xo2HsdyiRKOgyWtyv2VfRXBcLyV/NrDNWMYjOrJy4GA6VzMxCq+i/9HxDlrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WcDF4dAg75vpGUQKUExPwCDMvyfWebnPH63MlpdE8Ko=;
 b=kAX8c4PFUOzqMfbe7vbkf0elKtjnQ2xz/pCT6gt7NZFum0k0BYaifNn7D2fiSHj2Dz8M9fr0SPY1mwv49PkaSYt/kz3RElC7yaChQDcrrnqaKcmfCXlatv0nuMYtX5/oniFvojGNovngH7tZE9bu0XBYKDgtNlvI3tPp+9g6t6SQrH9wqNYx4PLFLk34EskrteRUbVthSSDdVzeri2I+eRt7bLBjsFskRSHbHLVu2oNPLypE1VUzmOYNxU7/CX1722drykf1rVLCCJhq1Gb/Z27ujMMuCUXRRWomCBDFfMroWP1gBdiIKkxeDAOeNBDvJ+SnKCuqf+LvKUK9sdqD3A==
Received: from SG2PR06MB3743.apcprd06.prod.outlook.com (2603:1096:4:d0::18) by
 KL1PR06MB5895.apcprd06.prod.outlook.com (2603:1096:820:c9::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.44; Thu, 15 Jun 2023 09:08:30 +0000
Received: from SG2PR06MB3743.apcprd06.prod.outlook.com
 ([fe80::7dfd:a3ed:33ca:9cc8]) by SG2PR06MB3743.apcprd06.prod.outlook.com
 ([fe80::7dfd:a3ed:33ca:9cc8%6]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 09:08:30 +0000
From: =?utf-8?B?546L5piOLei9r+S7tuW6leWxguaKgOacr+mDqA==?= <machel@vivo.com>
To: Yunsheng Lin <linyunsheng@huawei.com>
CC: Sunil Goutham <sgoutham@marvell.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, opensource.kernel
	<opensource.kernel@vivo.com>
Subject:
 =?utf-8?B?5Zue5aSNOiBbUEFUQ0hdIGRyaXZlcnMvdGh1bmRlcjppbXByb3ZlLXdhcm5p?=
 =?utf-8?B?bmctbWVzc2FnZS1pbi1kZXZpY2VfZm9yX2VhY2hfY2hpbGRfbm9kZSgp?=
Thread-Topic: [PATCH]
 drivers/thunder:improve-warning-message-in-device_for_each_child_node()
Thread-Index: AQHZnfQHiyKyxIJ4cUqpS/uwhA2bU6+IsAUAgALjURA=
Date: Thu, 15 Jun 2023 09:08:30 +0000
Message-ID:
 <SG2PR06MB3743BBB0CE4EDE9C9882DB23BD5BA@SG2PR06MB3743.apcprd06.prod.outlook.com>
References: <20230613123826.558-1-machel@vivo.com>
 <4aa86edd-5526-929d-8576-9d2b6f828eb0@huawei.com>
In-Reply-To: <4aa86edd-5526-929d-8576-9d2b6f828eb0@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SG2PR06MB3743:EE_|KL1PR06MB5895:EE_
x-ms-office365-filtering-correlation-id: ea9240d9-5f1b-4fc9-5e57-08db6d801692
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 iFIOJsyq6+Jp7YQfA/3n3YlPFUGpZpAp14IiMPirUvSIhfXKHD2jbZm3DHTTn2zFPypA26cGw75JEYw5HSmrbtZuOr7LmLWyLkUfdIbxhE1BmOPCagE9HtNiyH92WGkYIfuLCfSY43cqDjg9jqZQPVT7UTuCAs4yOlhaCBsZD5qbCrvKQoZOjsgApuIpkhR5lJuvcec28rR5KUjkOddtpdmsdOzeI90WLyAmP+LPan8RRi5lIpGuEX+WwbY/yeykuvyvcd00CLTiOyfVQJaM1IXNLkTM40BaUUPKNoT1dLvkm8kFHpWrYi9QGVXP+mkA2jBigDOILxrTZTz5TLhvLrqmNk12MKdn37QdXk8vkWOwgwjGpTHBPOdWYSrnUM/NTv5AhFeBV9sJPw1eQ2dXASGqzVHVUCUoYtTf3N0XyzNL7K3uLcXe+70ykE9tYk91bf9cP0sMqB/VqPrAA/mkhKa5kn30jfniu1PgZk6nSYsSMi95j4PjnGhqfB0vU9U9x6/TSXNp9Qp3fveyviVc49DlzvGM2uZ/e1x3GM3l1zooJcm8+SALkIFSSnMLND6a5ErC+jHFsGgRt3Yg2KoJ0PoA8i6YzIqMrLLymqEW9S3yWbDA0ao+9Y/naYLfcvdF
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3743.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(451199021)(83380400001)(38100700002)(33656002)(85182001)(86362001)(122000001)(38070700005)(224303003)(55016003)(478600001)(54906003)(52536014)(4326008)(966005)(71200400001)(7696005)(8936002)(15650500001)(76116006)(2906002)(5660300002)(66476007)(66946007)(64756008)(66556008)(66446008)(6916009)(41300700001)(316002)(53546011)(186003)(107886003)(6506007)(9686003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VnB2bHhjb09YNlpmak5pWUo2ajEySGltbjJWa3NYazBUSmZ4WmgwT05waVRJ?=
 =?utf-8?B?c0xXclBKQlNjRHZSQ2xtNzUzWTFqUGhrbjVGQ2h2QXQwK0dpSzFTUWplMDdT?=
 =?utf-8?B?V0VhNWRiU0JlRTdxcnRCOW9ITTVvUUhQY0lYakpEbWJIYVJSVEJscXAyck9r?=
 =?utf-8?B?MStGc3ZscGwrbGZIdmM2SkNUdTFNb0tUTitRNnhsa0tDU0lJVkhpc0ZBbEV1?=
 =?utf-8?B?bEJBazZHaDBSdkNTZ2M1TURrc0hyREQvRW8zeEtxc2wydDJlQm9mZzV2emJC?=
 =?utf-8?B?N1VNZXJoM3hLa2FlZmVHUldZTlBNTHZkcC9UaG96SStkcFQ3c2JyYVM3b2VN?=
 =?utf-8?B?NE9HUzJsS05UMi9zWWl2ZVZleE96VitLRTMwTEQ2aVZodEYwWkthdDRDaWJo?=
 =?utf-8?B?dDBIb3VzcnZrc1Byc1g4aG1xY01nOFBZWkhqUkxRdmFsOHl6ZW1iR1hWaVdr?=
 =?utf-8?B?NzhUcW9wVk13eG5FZWZyV1ZMS3I0azlFRlZoTWxjQTF1NmU4K0pPaEk3QmdG?=
 =?utf-8?B?N3dwRFhLbzFlcGZYWGVGSGlCbGJEeEp1S05KcFZ6WjVNRzhwcE93SmpkOVd2?=
 =?utf-8?B?cG1ac3EyQVJXTGJTNncyeXVRekVxZG1EeEs5S0x4d3JyL2tpRUlJK296VUlY?=
 =?utf-8?B?MmJnMEM0QUlFUThEVUR1NFhzb2FZN0xWMXRvZTlDNm9yV2VnZytoQjdnNVBE?=
 =?utf-8?B?ZjhJRldxREFVeHhFT1RFdVJGV2hxSm1iRWxOM2thUE5LTVZhWHZYWFllVmxP?=
 =?utf-8?B?czhJbHV5bTdNRm0xMzQrcHYya0VXNk5LN2VUT3FvSmg3b281ZGlPOGdDT2hw?=
 =?utf-8?B?dGJWLzkwZHVRV2lFMnc1KzdjVmJYWHFYNmVlMjBHYjZNOEdCOGFwRG5ML1or?=
 =?utf-8?B?aTZlbVIxYzVkWnR4SFZpSHNRbitNTWpETllRQlovckx2UUdTeS94NFFmV1g4?=
 =?utf-8?B?U1N1U0ZHaVc4cXdRRlFaQUhMNCs3MHBLcHdaSlNnem1Ocmt2TERFUzRVVjBF?=
 =?utf-8?B?SDVYNEhDK0ttOU1sZlI5RGRRZ2tDMUtQSWsxM0ZaTllPR3hVVUltMXFhVTN0?=
 =?utf-8?B?M3k2VnFxc3lITWlEVmt6MTNwTjhUZ2FINTVPN3hvd2FDZkdKaHFXblM0OGdz?=
 =?utf-8?B?OEtVYjIvc0tjdGxsbVE0VVFzYkpEQlU5cExoY1BPSEFTdFUvY3IwQ3Zuckp5?=
 =?utf-8?B?WjN5TlFLd3VOc3JndEpUZnNXRUVHOUUwclFoeWRtK25zcXBPNUNLSzZDS0NE?=
 =?utf-8?B?YlNoODRDRm5CYjU4dC9taGhBcXdGNU5pL2p0SHhrVCtZeXphdHY5eitXUEpp?=
 =?utf-8?B?d0c0UzRiU0sra0x5Y2luRnRnM3FHaVNPRXZzVmFWL091azVQMFVKYjVsd0Rq?=
 =?utf-8?B?QlhCU3h0ZDNLeTMrYTk1NTdyczdMNEZXRDBuWHo0MUlYbGhNdUtUTVZ6cW5C?=
 =?utf-8?B?YjhibkZmVm1WRm1wbzZZV1Z4eUZmOUJKM2NvQnJVVHRSWVZqa0c5MVRjVitB?=
 =?utf-8?B?dllFQ0hXQnAvcHl3TDFBcFY0NzRmKzlUR3VhL1YyaVB6RVQ4OTJYL3dteGN4?=
 =?utf-8?B?R0hQK0ZNRXhWbkQ0cGRUY2h1d3RsU24zVGxXMEFuRWFYd09keUM5ZUk5VVlz?=
 =?utf-8?B?TGV2SmZwS0N0TmJiOXlNYnlJSDZsalV5a0ZIcWFIS3ZINmZoVkdDNGFHU2JY?=
 =?utf-8?B?WGNqU3NQZWtQVjZvZDdqNDF0SnBFU3JSb1QvdytUTCtwY0dEUWMwRFZLRmlU?=
 =?utf-8?B?OW1HTkwwZlJtNFZDa1pHdzI4UlhkSTg0c0NuaUdzbVlkVVUyN0NDalB6L0lx?=
 =?utf-8?B?YjhLSUk0RlQ1ZWRYeisxRnVxMXF3UkZwT1NRaVlLOURKSEZBUEFvMlREQklE?=
 =?utf-8?B?L1BRYzNoQkh3Lzd6V2dQazRiSzNGckZza1NaUzBSODcrY1NBUzZmSGhnL1M2?=
 =?utf-8?B?RGhPN2gvMFF1WkpwVWt1YlNpNFA5R1U0S0o4WHMvT0lpdzlFSFpJeUcxVm5l?=
 =?utf-8?B?ZUpGZTY4QnlPdkVlelpXbFZwM1lIM2tWanBaSVFoUzhFSlJBRTFmV3lqckNN?=
 =?utf-8?B?amZxd0tJVEpKNzg0NmxhY3dvWTBUNFVEeERtNWJpK0dkTTMvOWg0YTg3OUY0?=
 =?utf-8?Q?aOMA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3743.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea9240d9-5f1b-4fc9-5e57-08db6d801692
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 09:08:30.4372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ivEH/1GkvmWzI2/Y4YZlamIjtpmKliugqSa55d407Ps42gUPDjFM/rR9hGjp4ZeDoSrpmSZrBMER2oMXdF+wKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB5895
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

VGhhbmsgeW91LCBzb21lIGNoYW5nZXMgaW4gdGhpcyBwYXRjaCBhcmUgZm9ybWF0IGlzc3VlcyBp
biBjaGVja3BhdGNoLCB0aGUgZml4IGlzIOKAi+KAi3RvIGFkZCBmd25vZGVfaGFuZGxlX3B1dCgp
IGJlZm9yZSBicmVhaywgSSB3aWxsIHJlc3VibWl0IHRoZSBuZXcgdmVyc2lvbiBwYXRjaC4NCjop
DQoNCi0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCuWPkeS7tuS6ujogWXVuc2hlbmcgTGluIDxsaW55
dW5zaGVuZ0BodWF3ZWkuY29tPiANCuWPkemAgeaXtumXtDogMjAyM+W5tDbmnIgxM+aXpSAyMDo1
Mw0K5pS25Lu25Lq6OiDnjovmmI4t6L2v5Lu25bqV5bGC5oqA5pyv6YOoIDxtYWNoZWxAdml2by5j
b20+OyBTdW5pbCBHb3V0aGFtIDxzZ291dGhhbUBtYXJ2ZWxsLmNvbT47IERhdmlkIFMuIE1pbGxl
ciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNv
bT47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBQYW9sbyBBYmVuaSA8cGFiZW5p
QHJlZGhhdC5jb20+OyBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCuaKhOmAgTog
b3BlbnNvdXJjZS5rZXJuZWwgPG9wZW5zb3VyY2Uua2VybmVsQHZpdm8uY29tPg0K5Li76aKYOiBS
ZTogW1BBVENIXSBkcml2ZXJzL3RodW5kZXI6aW1wcm92ZS13YXJuaW5nLW1lc3NhZ2UtaW4tZGV2
aWNlX2Zvcl9lYWNoX2NoaWxkX25vZGUoKQ0KDQpbU29tZSBwZW9wbGUgd2hvIHJlY2VpdmVkIHRo
aXMgbWVzc2FnZSBkb24ndCBvZnRlbiBnZXQgZW1haWwgZnJvbSBsaW55dW5zaGVuZ0BodWF3ZWku
Y29tLiBMZWFybiB3aHkgdGhpcyBpcyBpbXBvcnRhbnQgYXQgaHR0cHM6Ly9ha2EubXMvTGVhcm5B
Ym91dFNlbmRlcklkZW50aWZpY2F0aW9uIF0NCg0KT24gMjAyMy82LzEzIDIwOjM4LCBXYW5nIE1p
bmcgd3JvdGU6DQo+IEluIGRldmljZV9mb3JfZWFjaF9jaGlsZF9ub2RlKCksIGl0IHNob3VsZCBo
YXZlIGZ3bm9kZV9oYW5kbGVfcHV0KCkgDQo+IGJlZm9yZSBicmVhayB0byBwcmV2ZW50IHN0YWxl
IGRldmljZSBub2RlIHJlZmVyZW5jZXMgZnJvbSBiZWluZyBsZWZ0IA0KPiBiZWhpbmQuDQo+DQo+
IFNpZ25lZC1vZmYtYnk6IFdhbmcgTWluZyA8bWFjaGVsQHZpdm8uY29tPg0KDQpBIEZpeGVzIHRh
ZyBzZWVtcyBuZWNlc3NhcnkgYWNjb3JkaW5nIHRvIHRoZSBjb21taXQgbG9nLCBhbmQgc2hvdWxk
IHRhcmdldCB0aGUgbmV0IGJyYW5jaCB1c2luZzoNCg0KW1BBVENIIG5ldF0gZHJpdmVycy90aHVu
ZGVyOiBpbXByb3ZlLXdhcm5pbmctbWVzc2FnZS1pbi1kZXZpY2VfZm9yX2VhY2hfY2hpbGRfbm9k
ZSgpDQoNCkFsc28gaXQgc2VlbXMgY29uZnVzaW5nIHRoZSAnaW1wcm92ZScgaW4gdGhlIHRpdGxl
IHN1Z2dlc3QgdGhhdCBpdCBpcyBub3QgYSBmaXguDQoNCj4gLS0tDQo+ICAuLi4vbmV0L2V0aGVy
bmV0L2Nhdml1bS90aHVuZGVyL3RodW5kZXJfYmd4LmMgfCAzNyANCj4gKysrKysrKysrKy0tLS0t
LS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKyksIDE3IGRlbGV0aW9ucygt
KQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2F2aXVtL3RodW5kZXIv
dGh1bmRlcl9iZ3guYyANCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYXZpdW0vdGh1bmRlci90
aHVuZGVyX2JneC5jDQo+IGluZGV4IGEzMTdmZWI4ZC4uZDM3ZWUyODcyIDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYXZpdW0vdGh1bmRlci90aHVuZGVyX2JneC5jDQo+ICsr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Nhdml1bS90aHVuZGVyL3RodW5kZXJfYmd4LmMNCj4g
QEAgLTkwLDcgKzkwLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkIGJneF9p
ZF90YWJsZVtdID0gew0KPg0KPiAgTU9EVUxFX0FVVEhPUigiQ2F2aXVtIEluYyIpOw0KPiAgTU9E
VUxFX0RFU0NSSVBUSU9OKCJDYXZpdW0gVGh1bmRlciBCR1gvTUFDIERyaXZlciIpOyANCj4gLU1P
RFVMRV9MSUNFTlNFKCJHUEwgdjIiKTsNCj4gK01PRFVMRV9MSUNFTlNFKCJHUEwiKTsNCg0KSXMg
dGhlcmUgYW55IHJlYXNvbiB5b3UgY2hhbmdpbmcgdGhlIGxpY2Vuc2UgaGVyZT8NCg0KPiAgTU9E
VUxFX1ZFUlNJT04oRFJWX1ZFUlNJT04pOw0KPiAgTU9EVUxFX0RFVklDRV9UQUJMRShwY2ksIGJn
eF9pZF90YWJsZSk7DQo+DQo+IEBAIC0xNzQsMTAgKzE3NCwxMCBAQCBzdGF0aWMgc3RydWN0IGJn
eCAqZ2V0X2JneChpbnQgbm9kZSwgaW50IA0KPiBiZ3hfaWR4KSAgfQ0KPg0KPiAgLyogUmV0dXJu
IG51bWJlciBvZiBCR1ggcHJlc2VudCBpbiBIVyAqLyAtdW5zaWduZWQgYmd4X2dldF9tYXAoaW50
IA0KPiBub2RlKQ0KPiArdW5zaWduZWQgaW50IGJneF9nZXRfbWFwKGludCBub2RlKQ0KDQpJdCBz
ZWVtcyB0byBiZSB1bnJlbGF0ZWQgY2hhbmdlIGhlcmUsIGlzIHRoZSBjaGFuZ2luZyByZWxhdGVk
IHRvIHRoZSBwcm9ibGVtIHlvdSBhcmUgZml4aW5nPw0KDQo+ICB7DQo+ICAgICAgICAgaW50IGk7
DQo+IC0gICAgICAgdW5zaWduZWQgbWFwID0gMDsNCj4gKyAgICAgICB1bnNpZ25lZCBpbnQgbWFw
ID0gMDsNCg0KU2FtZSBoZXJlLg0KDQo+DQo+ICAgICAgICAgZm9yIChpID0gMDsgaSA8IG1heF9i
Z3hfcGVyX25vZGU7IGkrKykgew0KPiAgICAgICAgICAgICAgICAgaWYgKGJneF92bmljWyhub2Rl
ICogbWF4X2JneF9wZXJfbm9kZSkgKyBpXSkgQEAgLTYwMCw5IA0KPiArNjAwLDkgQEAgc3RhdGlj
IHZvaWQgYmd4X2xtYWNfaGFuZGxlcihzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2KQ0KPiAgICAg
ICAgICAgICAgICAgbGlua19jaGFuZ2VkID0gLTE7DQo+DQo+ICAgICAgICAgaWYgKHBoeWRldi0+
bGluayAmJg0KPiAtICAgICAgICAgICAobG1hYy0+bGFzdF9kdXBsZXggIT0gcGh5ZGV2LT5kdXBs
ZXggfHwNCj4gLSAgICAgICAgICAgIGxtYWMtPmxhc3RfbGluayAhPSBwaHlkZXYtPmxpbmsgfHwN
Cj4gLSAgICAgICAgICAgIGxtYWMtPmxhc3Rfc3BlZWQgIT0gcGh5ZGV2LT5zcGVlZCkpIHsNCj4g
KyAgICAgICAgICAgICAgIChsbWFjLT5sYXN0X2R1cGxleCAhPSBwaHlkZXYtPmR1cGxleCB8fA0K
PiArICAgICAgICAgICAgICAgbG1hYy0+bGFzdF9saW5rICE9IHBoeWRldi0+bGluayB8fA0KPiAr
ICAgICAgICAgICAgICAgbG1hYy0+bGFzdF9zcGVlZCAhPSBwaHlkZXYtPnNwZWVkKSkgew0KDQpT
YW1lIGhlcmUuDQoNCj4gICAgICAgICAgICAgICAgICAgICAgICAgbGlua19jaGFuZ2VkID0gMTsN
Cj4gICAgICAgICB9DQo+DQo+IEBAIC03ODMsNyArNzgzLDcgQEAgc3RhdGljIGludCBiZ3hfbG1h
Y194YXVpX2luaXQoc3RydWN0IGJneCAqYmd4LCBzdHJ1Y3QgbG1hYyAqbG1hYykNCj4gICAgICAg
ICAgICAgICAgIGJneF9yZWdfd3JpdGUoYmd4LCBsbWFjaWQsIEJHWF9TUFVYX0JSX1BNRF9MRF9S
RVAsIDB4MDApOw0KPiAgICAgICAgICAgICAgICAgLyogdHJhaW5pbmcgZW5hYmxlICovDQo+ICAg
ICAgICAgICAgICAgICBiZ3hfcmVnX21vZGlmeShiZ3gsIGxtYWNpZCwNCj4gLSAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIEJHWF9TUFVYX0JSX1BNRF9DUlRMLCBTUFVfUE1EX0NSVExfVFJB
SU5fRU4pOw0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEJHWF9T
UFVYX0JSX1BNRF9DUlRMLCANCj4gKyBTUFVfUE1EX0NSVExfVFJBSU5fRU4pOw0KDQpTYW1lIGhl
cmUuDQpQbGVhc2UgbWFrZSBzdXJlIGl0IG9ubHkgY29udGFpbiBjaGFuZ2UgcmVsYXRlZCB0byBm
aXhpbmcgdGhlIHByb2JsZW0uDQo=

