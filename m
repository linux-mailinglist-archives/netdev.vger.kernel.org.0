Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC3A252ECB8
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 14:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349651AbiETMzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 08:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236511AbiETMy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 08:54:59 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90080.outbound.protection.outlook.com [40.107.9.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EC46A054;
        Fri, 20 May 2022 05:54:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5EyMOkbdqt1x/3QQ0Ro6as29BjWosKFjHfpUktlKDcEFuiw04z+nF0JyJ0uK6xRe06axtI/7NVfX6+5oxOZpz6p/3d8zjArhg9W0EeQAz/lL0aUP0qARI0gM4PyLM/K3hSq8SJQ2+iu9z0NbKdlr/gRwdffXd0x6fqOMd++/rwZadn0dvS7fb73kElIpkPOINQgQpobgD9fpXxo7S8XO1fkvTenFmXcOEMZ0rjrxVuJzq7AlGgsiIq8vy2VlH18umNnDXUMgufsqFLvbjh6REqLJOMkr4w/F+soXF/Lg6XBYXUoxg8uYQWLGx/Wqh4MpE2Xu785WFk8DAJMFEZU7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJZQPJPvy4ZNRz+KrrSnvV4jMnBgtJT+hIAHwVZ3mOM=;
 b=RA6k/eeQ0KnyMTEpswZGRq2d5aRHtIt4PGtDxuAePp04AaGxP50+yKcy1S86JTPAJzZjuY8qoOpRFJtTZlYa+hzjy2jMLPS7aeeyyCDDrXdmrhmizAMlXJAH4jXgBcywsVp73VAbJlxSUxrzhzdlDQXlg7CqyELMTZej1LOmDwtgRvh7e74IcGp0o9nopmrn0i0vBDeIizTAL8KVQVOk6yQWhGYta4t4kAvGJtjVTopfsxUBEVzF9cd3hORz+7cy1vgZmTDV769ML6msDG8+VgUEuz+aeHZ8oao2Vn7h0ugzj6h9+Na6V92NT4VG09ARxNK5GqB3nTZzZu7upfb4Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB2919.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1d2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Fri, 20 May
 2022 12:54:56 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::ad4e:c157:e9ac:385d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::ad4e:c157:e9ac:385d%8]) with mapi id 15.20.5273.016; Fri, 20 May 2022
 12:54:56 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     =?utf-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>
CC:     Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>,
        Dan Malek <dan@embeddededge.com>,
        Joakim Tjernlund <joakim.tjernlund@lumentis.se>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: fs_enet: sync rx dma buffer before reading
Thread-Topic: [PATCH] net: fs_enet: sync rx dma buffer before reading
Thread-Index: AQHYa7YuVEP9k/Dzd0ymrSBr6A4wj60nQJAAgAB0SUyAAAVXAA==
Date:   Fri, 20 May 2022 12:54:56 +0000
Message-ID: <b11dcb32-5915-c1c8-9f0e-3cfc57b55792@csgroup.eu>
References: <20220519192443.28681-1-mans@mansr.com>
 <03f24864-9d4d-b4f9-354a-f3b271c0ae66@csgroup.eu>
 <yw1xmtfc9yaj.fsf@mansr.com>
In-Reply-To: <yw1xmtfc9yaj.fsf@mansr.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a697895-7b39-4098-1100-08da3a5ff0c7
x-ms-traffictypediagnostic: PR0P264MB2919:EE_
x-microsoft-antispam-prvs: <PR0P264MB2919CD0F7D2EEE623EC4BFFDEDD39@PR0P264MB2919.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lCG44j5uCfYEREVqfk3ejvss1wgVitHTDJaFTfR4seJGRK/HQ6JzRBQnr+4avLlJ7+AZ9Q6bAIUvLowecA2d/Ee3aJs5kEasZJIPlJ0tG6sA0GtFhmiv6awyhDpbH82MYv8NaL9PXHzBK/Jymppsmab0DE/LKzmHEHGRYUA1yFhDo2HK0fXT5V8f28ktm/cqo6C0fvaxX5IiuMraoIiOGMXAPcLjK57EX+Ajjkp2EavioOvHxevQdLdFuIzKJbnnfjpCAUZbjD2thTGPM9/9J0aVGR6EsifpLq1bOTjT235l9IyxbZT49tSVvCAIHuTQYVDyzsyr8YD/qy0OOaDWBl4seiZH0r+XQMk00pFMyB+G6QXnWdjVydVPS5rRFzSLBCH0WQxoU3KCyM0N/QgPmP2LQwbMH8BvFIsVakFfHj94cJ9tmvPklXIyofEUdRZ2w8NnZjFeGY1m3X94M/6MpPpS/y1s2h12gdYE1DZ5tLwsldNw1L4IrRh3g9LonTQJZoIH5MOMjw9Mdn/jqEUZXm1aR+Nw+/05k149S+YGskFZn2bC8zIR3lZIXpoTwBFzK8LPuoxeQ+ka4mI6491/74uhesFjhZyb7iL9PlZwVY3QFGYXwRJAXHChzXVtPt1UJzRcsIJHZIo7RZEfagZFbVbD83f2tVf27KmzKcuNROBsoCbvckP3gx/H974NY5+MUazlVyvqQCrWjesoJQ/xqJJkrBOdHjX3E/a25NkWqHYZG+qGtcaARfV+b4EXQGP6E/xaq89V+Hz8NkFene6bAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(8936002)(2616005)(64756008)(66556008)(66476007)(66446008)(38070700005)(186003)(36756003)(5660300002)(4326008)(31686004)(7416002)(44832011)(6506007)(122000001)(26005)(91956017)(8676002)(76116006)(66946007)(71200400001)(508600001)(6916009)(54906003)(316002)(2906002)(83380400001)(66574015)(6486002)(31696002)(38100700002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eG8zNmhoa0x1WGllRHIyWmx0Z0VkNHZRMXNmRU9LUG00ZHFTWUlaa2JFNXE2?=
 =?utf-8?B?YUdwbFQwbjROWlVBYlBOS0tsQlF5VUhBTHExU1lpSHpyMGh6RGI1eWwwRTM3?=
 =?utf-8?B?RmozTmZVcjBRbVpxcHlQbVduSi9oQ3ZRa2hiSzlBRG9CVkI3VUZqeDQxVDl0?=
 =?utf-8?B?Z0Z0anlLWnlrdzNVY2tKcWlBSkRyLytib2xRT00wZFFndzNtRDVHQVlWMkFq?=
 =?utf-8?B?NU9KM3VJOEdzVHhkdzJTNHBXMXdkTXBDeDlHay9jRGZLdTdIa1UwVWg5SGlV?=
 =?utf-8?B?cUNqMS85Zk9kc1B5MEFBekQvY0JONTBOUlZpUW42TUwzSjg5ZGJQaWdXMmo2?=
 =?utf-8?B?VTF0MXlNM1Jjd0VQMEMzNHc0WHR1eElCMlhuVXgxUXN2Q0tyeVBWN3NIRkRE?=
 =?utf-8?B?NUhyZ0kzNUlFVHBoNVQxbGNxSTNiTFVBWGtldFhqVXVyQWtPNEVCbHlaY2pI?=
 =?utf-8?B?QitMUGhxQjRsRkQ3aTBsWk1SOVR2WjBxdFo1VGtzeXF2c2J3Yk56WHAxOU1R?=
 =?utf-8?B?RUNtT2RGaVBlNGVaOTFTVmd0d2RPR3dFL2dNNUp5c1g3Ujk4cmp6ZmRicStl?=
 =?utf-8?B?Yit2MWR1cC9mT2g4VmpEMFgvVitqb3l4ek95Qk5KcitIckVLQ3BMMHMvdEVV?=
 =?utf-8?B?V0syZlRtMGN5MnFiTEYrWlErdFJkSFEwMFNYWkFSQWtMOFZKd1kvRG50MTMx?=
 =?utf-8?B?MU54N0hEOTR5YTZEeTRnNmkvR3JRSlZEUjFBTHBnWmlJWUp4OTk1VDdWOGQ0?=
 =?utf-8?B?Sk9ScUd3NzIxTFljSG5kZy83MnRMei9yMFkxbWhsVHNUNy9DUi9sNS9Qb2Uv?=
 =?utf-8?B?L2NNZ0txbFVQL1lpYkdHODdhUnZZaGNJMXYwN1hTb3J6MUhUS1JNYi9YS2R3?=
 =?utf-8?B?TytyYjA3QUt6blRDTnZLUTFnREFKY01uSnRwUjAvd0sycjhxbU1ZdkZQLzdW?=
 =?utf-8?B?UHFCUFpieFBFSnhOZmY3dkovc3hUdG9FT1ZBVVF3M2pmR1l5YjRPTmV4Y0RV?=
 =?utf-8?B?R3hVODRGVm55TXJPZC91K3U5TVZ6bVdicEZwOTVSSmZuSUFYTWozdnkyTFox?=
 =?utf-8?B?dkJWRTBOTjNyUTBoZzRIeE10blVtZXc2R05IaVREZ1RJenhOVWNiMmJJakpS?=
 =?utf-8?B?cG5URWhsRlI0UTJEM0RaYUQ3Vmw0N1FaaTVQeDFiYVBzWnhJMmdnOW9LOHNw?=
 =?utf-8?B?VFRVSVdmVldERWxScEFzemMyRU1JdnRPTGhNVGl2dUxzQU5FMlgwOVNraTlN?=
 =?utf-8?B?VFlLTkxtV2JCVkNEQXBLNjUyb1hDbyt3NEJUMjdOVk5PcnRnTS9LU0tyMWt5?=
 =?utf-8?B?MWUyblE3cWRKQkRrcWZYZVA0Z1pOdUYxQzA3RmllMUh3Q3NlZWRvRmpSWmhq?=
 =?utf-8?B?dko5K25ReHAyV3RIcy9OMjZLV0UvNHdaWi9DS0c4b0lhaklWa0h2OG0xeGF0?=
 =?utf-8?B?cy9mUC81UWw5eDBPMTY1ZWNtaStaQThzY21ZQm15RzlWVWNGUlJlalBHY1V0?=
 =?utf-8?B?dGNYdlpzaVlOYUw4a1h0SGZ4R2t4VHdqUVpFcStkeHdXV0tZeEtYS0RNRjB5?=
 =?utf-8?B?NHQ5d3cyQlhSOFVtaDBUNUNqcGJVeWx1SWpWOGJQeWd2ZWhYbHhwc3F5Q2VH?=
 =?utf-8?B?blRDZUFGcllxOENMdEZLeEhjcVFWTlo1VEVsbHN1NThzZUVjTHM1Snk4L1JM?=
 =?utf-8?B?RGt3RmhDUnl3VkVmeWZpK1pBVEY2bzRBQnhSVlorL0JXMDBZRkcvT3J1QTBJ?=
 =?utf-8?B?STR1VFBaNElPb0NrclVRZlFUZUl3WTg0TjNXQVUwL1FCWlY0Q2ZPbVo4Zkdq?=
 =?utf-8?B?cGZEajQ1ZURFNUxlVXBOOHdpVURoSlE5S29xNnZSbitRMnFFU24wSzRIT2lm?=
 =?utf-8?B?UjZuKzlNOVVDMnNpbkNvWVh6Zk5uRDc2SFBieVViaWtPMjVRbjBZNTBTdzU2?=
 =?utf-8?B?T1UxQk9TOC9OeE50NW9LTVpzVFV4ZzlJVEJaNmdKSEhGQk8rcmRqdkFjNWpx?=
 =?utf-8?B?MTdqVVJESk8rZDMvR3hodWwvNjc2QzlvS0g4Qk00U0lSMzdSNmNEWjdycGh0?=
 =?utf-8?B?YjFSTXo0aGFjdmw0ZjRmL2RkVE42NUNYWVl2SXVsR0JhMFJxcm9HditjWWtY?=
 =?utf-8?B?MDV5ck94ZkpmSFRYb1BDYW85dzJqSFBjbXVJQ1d6WndDNEFkc1ptc012cGJi?=
 =?utf-8?B?NjFkeS9vSFRnSE9GVnlxamJNUVhXNW9yc0tpWHorS1FXUlhDRFprM3FqYmZk?=
 =?utf-8?B?a2tiTEp4cDNCb3JTcGJRU2hTNWlpUkM0RDkwbFVqUFRIdDZweVl1QXdpY0l6?=
 =?utf-8?B?aXhwKzF2NGk2TCthMzFITll4eWdTTTBZYzc0SXE0YVJSN1V4Rk1ZbkUyRTNC?=
 =?utf-8?Q?m6sA2tmSfBtwyFjo7MtLarLVYiRWOz4xxczeH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ECC5E8EC22AED14FB08BEFCAB69B4FD9@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a697895-7b39-4098-1100-08da3a5ff0c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 12:54:56.1759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZyieiHihHvZh682R3TZC7tUSckjOPPp3pZB/LabTmmOI0pRMbsnLRHjOJ3PbXnW4nzy0awYkv25RIcd7d+R19NtTRNFa6MjEYOpN0UwpX30=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB2919
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDIwLzA1LzIwMjIgw6AgMTQ6MzUsIE3DpW5zIFJ1bGxnw6VyZCBhIMOpY3JpdMKgOg0K
PiBDaHJpc3RvcGhlIExlcm95IDxjaHJpc3RvcGhlLmxlcm95QGNzZ3JvdXAuZXU+IHdyaXRlczoN
Cj4gDQo+PiBMZSAxOS8wNS8yMDIyIMOgIDIxOjI0LCBNYW5zIFJ1bGxnYXJkIGEgw6ljcml0wqA6
DQo+Pj4gVGhlIGRtYV9zeW5jX3NpbmdsZV9mb3JfY3B1KCkgY2FsbCBtdXN0IHByZWNlZGUgcmVh
ZGluZyB0aGUgcmVjZWl2ZWQNCj4+PiBkYXRhLiBGaXggdGhpcy4NCj4+DQo+PiBTZWUgb3JpZ2lu
YWwgY29tbWl0IDA3MGUxZjAxODI3Yy4gSXQgZXhwbGljaXRlbHkgc2F5cyB0aGF0IHRoZSBjYWNo
ZQ0KPj4gbXVzdCBiZSBpbnZhbGlkYXRlIF9BRlRFUl8gdGhlIGNvcHkuDQo+Pg0KPj4gVGhlIGNh
Y2hlIGlzIGluaXRpYWx5IGludmFsaWRhdGVkIGJ5IGRtYV9tYXBfc2luZ2xlKCksIHNvIGJlZm9y
ZSB0aGUNCj4+IGNvcHkgdGhlIGNhY2hlIGlzIGFscmVhZHkgY2xlYW4uDQo+Pg0KPj4gQWZ0ZXIg
dGhlIGNvcHksIGRhdGEgaXMgaW4gdGhlIGNhY2hlLiBJbiBvcmRlciB0byBhbGxvdyByZS11c2Ug
b2YgdGhlDQo+PiBza2IsIGl0IG11c3QgYmUgcHV0IGJhY2sgaW4gdGhlIHNhbWUgY29uZGl0aW9u
IGFzIGJlZm9yZSwgaW4gZXh0ZW5zbyB0aGUNCj4+IGNhY2hlIG11c3QgYmUgaW52YWxpZGF0ZWQg
aW4gb3JkZXIgdG8gYmUgaW4gdGhlIHNhbWUgc2l0dWF0aW9uIGFzIGFmdGVyDQo+PiBkbWFfbWFw
X3NpbmdsZSgpLg0KPj4NCj4+IFNvIEkgdGhpbmsgeW91ciBjaGFuZ2UgaXMgd3JvbmcuDQo+IA0K
PiBPSywgbG9va2luZyBhdCBpdCBtb3JlIGNsb3NlbHksIHRoZSBjaGFuZ2UgaXMgYXQgbGVhc3Qg
dW5uZWNlc3Nhcnkgc2luY2UNCj4gdGhlcmUgd2lsbCBiZSBhIGNhY2hlIGludmFsaWRhdGlvbiBi
ZXR3ZWVuIGVhY2ggdXNlIG9mIHRoZSBidWZmZXIgZWl0aGVyDQo+IHdheS4gIFBsZWFzZSBkaXNy
ZWdhcmQgdGhlIHBhdGNoLiAgU29ycnkgZm9yIHRoZSBub2lzZS4NCj4gDQoNCkkgYWxzbyBsb29r
ZWQgZGVlcGVyLg0KDQpJbmRlZWQgaXQgd2FzIGltcGxlbWVudGVkIGluIGtlcm5lbCA0Ljkgb3Ig
NC44LiBBdCB0aGF0IHRpbWUgDQpkbWFfdW5tYXBfc2luZ2xlKCkgd2FzIGEgbm8tb3AsIGl0IHdh
cyBub3QgZG9pbmcgYW55IHN5bmMvaW52YWxpZGF0aW9uIA0KYXQgYWxsLCBpbnZhbGlkYXRpb24g
d2FzIGRvbmUgb25seSBhdCBtYXBwaW5nLCBzbyB3aGVuIHdlIHdlcmUgcmV1c2luZyANCnRoZSBz
a2IgaXQgd2FzIG5lY2Vzc2FyeSB0byBjbGVhbiB0aGUgY2FjaGUgX0FGVEVSXyB0aGUgY29weSBh
cyBpZiBpdCANCndhcyBhIG5ldyBtYXBwaW5nLg0KDQpUb2RheSBhIHN5bmMgaXMgZG9uZSBhdCBi
b3RoIG1hcCBhbmQgdW5tYXAsIHNvIGl0IGRvZXNuJ3QgcmVhbGx5IG1hdHRlciANCndoZXRoZXIg
d2UgZG8gdGhlIGludmFsaWRhdGlvbiBiZWZvcmUgb3IgYWZ0ZXIgdGhlIGNvcHkgd2hlbiB3ZSBy
ZS11c2UgDQp0aGUgc2tiLg0KDQpDaHJpc3RvcGhl
