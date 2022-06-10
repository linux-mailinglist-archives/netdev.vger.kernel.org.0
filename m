Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB698546BD1
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349921AbiFJRpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347144AbiFJRpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:45:10 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60097.outbound.protection.outlook.com [40.107.6.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6325537B;
        Fri, 10 Jun 2022 10:45:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1ws/SeezREd3+ZW/jeKawaDNx12Cw9RSarFZFnGMmUGlPELlwOVwDrWlpCtl+llodM3wGjWENvq5/4xBRUta9tqmx7Rt53rnF2iB2SnYyuwq1RkaltpAd21gHxEoS6aV0SsHPTyYMNki2goVIsSpco3FqdvdxIdeH4eLIvMpzNXOCrOKZmNxI7z9Sff3UPCcRdOsw4Ncak9cfKRX0UA8HK/8SAw8aRDVCG5VC3Jtyx/QHPNQEqEkdUk/LVwjiwefvezhBzMzbl3R2j0EJZ8OISodWDjLFIGd3F7egsR2HtoqDDzfpClAuWBsxH0g/glBqBWnL9Yt0v+gRLGJ2f13A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oGtY12bL5/mXwxFMhlOsotRkYejScr5G77Qr2jA0Lx8=;
 b=EstuixAXeYQJLgQwT9yMxfPCufh1xVALx30BygClIHVqyHg8uY09NWaH+E4EDPOfknkJodFJGeyKX5zAwF+8zwTV564nlyfvUri5xFMIVq5HKX/Y9xd86HhqwszwT03ypMUU9rY8L/ZSO7vjGheRGgoCBAnOgHQy/KW55eE6AL8WfWsT4H8qpf0MaaGoHuG+deo/obGZu04z9WQSlWpbMS/1zoJOFHDk6I74O69h56yuXqK3lJRH043j5aawWIZNeTBFsuV+ZQTvVT1usosqjpJPoe5Qq9ZNC1FjrG3Qvq+nFa0RIwtv6tOIowYwZmkRNdruKaWNA6PRa0ulUyH4pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oGtY12bL5/mXwxFMhlOsotRkYejScr5G77Qr2jA0Lx8=;
 b=OFZCo1hZifCqZL4Ahhecq2YWP119Wq0anDF+ynF7l3nz3DASHBsc89ei3U2gWRpb+U/iWwssN51OZuR1/P5q9KPKy+/doH70Bv5BTWENAVsnDfcFfmGt9H2VS0l5d0CDSugxO7WSykFGglX1CksEga/qYBsyqpC0Rr1GtfZhHHo=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM0PR03MB3521.eurprd03.prod.outlook.com (2603:10a6:208:46::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 10 Jun
 2022 17:45:05 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111%7]) with mapi id 15.20.5332.014; Fri, 10 Jun 2022
 17:45:05 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        "hauke@hauke-m.de" <hauke@hauke-m.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 5/5] net: dsa: realtek: rtl8365mb: handle PHY
 interface modes correctly
Thread-Topic: [PATCH net-next v2 5/5] net: dsa: realtek: rtl8365mb: handle PHY
 interface modes correctly
Thread-Index: AQHYfOBBJM0ci4mwDkO9rhhoQbOYsa1I1sOAgAATHgA=
Date:   Fri, 10 Jun 2022 17:45:05 +0000
Message-ID: <20220610174504.myd3z5vcs6ldhbei@bang-olufsen.dk>
References: <20220610153829.446516-1-alvin@pqrs.dk>
 <20220610153829.446516-6-alvin@pqrs.dk>
 <YqNzF7KbSI9h0tSQ@shell.armlinux.org.uk>
In-Reply-To: <YqNzF7KbSI9h0tSQ@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af7d7877-7cea-4e25-1f72-08da4b08f40e
x-ms-traffictypediagnostic: AM0PR03MB3521:EE_
x-microsoft-antispam-prvs: <AM0PR03MB35214089AFE2F6AF7568C9B583A69@AM0PR03MB3521.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8InPu/Ea5FU3t2vo3jfgGGSbCrvPeMiIUzXAuC4DcpZxTg8PrsRkykfleKxpBJEDKqLXMmqMSFUOlwJze8Sr54aE9YIKyRmvN8UY8GWIJ3cchmuRox/VnL7jYjazghoiC8Z8kKya83BIJlh4dkSNicEWYsSx9+wVDuW1KZIl7q1FabaoqkNBsVGyxe8zQDtsYumqSxHwZU0WkjTtCSfjCZc/C8hzCns3Y07KhKQ/Q9tb+gJftyROEYYL7dy8BhWP1wKAImwmA8ufoYPlPxTDFdNhnaWLk4EgL4MW99nvk2tu6FgEXYHZyAY6wrQBCLYFtjELBznUCNI8Fnec9NYjJ77Du2ivy8rbdwsNyoxBq+MYcVy8u2PAfQgS2zhb2MVEofrEM3kodTvAs0UheJLFbekA5ZmysGjx2cl3WsM7oD7XTvfZwEguBH/tyAmSD2y1K/J1EahIE/5niXmKWvhku9zoSxyxH6Xux6vA/1R3X+0lSQwbTPqiPaOebVj6OWr9J7gNQFdPw6JknV6pC5dLk2t3WglYECS5yfpW/eiQsOBOAImIxbKDHZnf3JfGsGkHcs3OhBx5X+c+G0DwcDd7GgDgqVMsqBDqvdU4R17aQQNgOVcOhLVzsYfp3IR/ZRExkEeUSGUrYgjqXJmGm8JhjJdI8z4vb5j4VA/h1SkjYF4imB13VOlh5tJVfpz24WJIVsKPu6ENTE0ySc1ntVEygA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(85182001)(2906002)(6486002)(6512007)(508600001)(85202003)(26005)(38070700005)(36756003)(316002)(6916009)(122000001)(54906003)(8676002)(6506007)(7416002)(91956017)(66556008)(76116006)(2616005)(64756008)(71200400001)(5660300002)(66446008)(66476007)(4326008)(66946007)(1076003)(8936002)(8976002)(186003)(38100700002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NjlKWWZ4MCtzSXc0S01YdHFzWTJJK2xjM3VXazYrTWxLQUcrcEZpRUpmZGNG?=
 =?utf-8?B?WkFsSFd6M1VUcU94OFh3SkxtTVJRaE9QQ0EzRG15Y3NtZHlhM0ZTU01VTFBR?=
 =?utf-8?B?c1V6V2RkMmI4VUJncDhVbWl1dFRyUGdvQnVMcnJDSEIrS2dVWGF0a2FXZlYz?=
 =?utf-8?B?VUhLQVd0TTRIQytrclZLTjFyMEJKTDFYbzVEdGk5V2ZNRC9QNFdjcmtyYTN5?=
 =?utf-8?B?M0VkZVlSM29mT0EvVE9ReWFhcnJWeTQrN29xY0xNYTRTOHdnRHNSZmdDQzFF?=
 =?utf-8?B?eXlkR3grSElPN1lHd3ROYXVoTnhhc09iRjlrUTJSTEJpM2FFTGw1bk0zSU0y?=
 =?utf-8?B?OHNCQWlOaGVaY3N0Z3pUZDJOa0JmMmhiNThHZ2xvMEpFK0dsZFJ5TXI2cE9h?=
 =?utf-8?B?SVJ5RWR3MHhNejRYWU1KNVM3K2IweEhMcnNZRWE2RlRtWlQwc2F2UmpDWEhw?=
 =?utf-8?B?SEJmb3I2MmppMXZuZE1NOXMyajNndENOenlqZnBjaVF5NnMrQXNWUzRqL3pu?=
 =?utf-8?B?d3RLbmQvdEZabUsyWmZIaElzZWFBYUJlSkErQ1dNWXlWVjMwZ0liNDV6VTBW?=
 =?utf-8?B?SXZVdzNlMTZoekY1Yk00elpDSzRkbGpuemZlSFZuTUpicUN6K2NuZ1g3VmYx?=
 =?utf-8?B?RzRwQmh4NTUvejBVYjhtYTNHNjJLKzgwN3BTT05yTUJQajJseTFBWStMUExR?=
 =?utf-8?B?emNYL0E5bjNzbXUvV3V5TDNCR1pCK0JXUU5XNEtyQmk0dUc1a1lFdzcxUEpZ?=
 =?utf-8?B?SVMzaS95M2FUTGZzejZIREtLeHdPbmtQcXJSZTNNa29CaVV5dThHOGJWY1RC?=
 =?utf-8?B?NXlqZ1BUMEl1U01YMVQxUVdBSW9nT1Q2ZnZISnBVZkVZbDg1RGo3c0UxYzNE?=
 =?utf-8?B?bFRkWDU3eGVCV1o5SnZyd01WSUlndCtydzlEUjFZbkJlSXplQnNwbE10U05u?=
 =?utf-8?B?VDdsRUhDbHRVSWNOUmIvcnMzdDBmeFlCdUdnRE9BQTdmNmV3aHY3V0Ftelcv?=
 =?utf-8?B?bFFZeFlsZ29iRzBSYk9IajR6eC90eWlrTkFYVVZJeVhNZlhqdlVlcnl0UHh5?=
 =?utf-8?B?UnhKWFlvL1hoeTVZYW5oRFJMRVlzSXU3a016SFpUQWdUM2xLOSt3SHU5R3JP?=
 =?utf-8?B?UURNUEhINXExUGl5cTVWa0RKcTJmby9abGVCQUhKcGIyTFhHYTJmZm5FUU5i?=
 =?utf-8?B?cVJjUzlqUEE1elE2bS9KbUQreERNOEgwbkI0OHRJWVZ6VFpkWlRiWU96UCty?=
 =?utf-8?B?ckVvdkhxRkJBcUxPUmlHMUdBekhwR1RiYTJ5R1lrSlUrUXlLUEZpUGhONEhL?=
 =?utf-8?B?WmNtb3hkOUlNTUFCZU1GUUdUOUNRZkNkbGExaFlhQXR5SHMvWk1VT1RMdGRk?=
 =?utf-8?B?WEdkanhGS28xNnlVVEFRNkRaSFI3OGtBeWdmU3A4U2JrcFU3UGVDMHVNYUtt?=
 =?utf-8?B?ODlKMG1wK29XbGsxZnI3WEdRTC9lYzZncU1QLzMrRm1LTVh4RlpBMDBDVHI2?=
 =?utf-8?B?REQ3USt6aFQramZEbHpwNWRIVmszZ3hZMVVRZ0lCNTRYMzVPRzFlY01PL3Nl?=
 =?utf-8?B?S0NxV05hOE1hUnc3NDBSMkY2K0YvVkZEb2hJOExZcmliY2NXdXRqbU9acm9L?=
 =?utf-8?B?TmVNN1pLY214QkJodEhHVEhiNTZvVndKT05sNU83dFJCYS95eXJaVW0yS09D?=
 =?utf-8?B?di9hWTFncS8vZ0k1MGhSTGVFODVZbWtYRHkrWExlU3pXRGRQUyt0YVV1VCtv?=
 =?utf-8?B?MVgxM1pJSmFuU21wZm1VWUdibks4ajNjc0J6V2ZVR2h0aW4rNVg5RmZENGZQ?=
 =?utf-8?B?NWZGRHdFejhHb0RKblRDQjlHV05ySmpFWVRqWVJDQW0wekp6czh3bXE5OHJB?=
 =?utf-8?B?SHVQMGJOdVlLN1VxVmEvQngzc3dobzFqaUdoRWpuUk5Lck8wT2h3K2NoKy9R?=
 =?utf-8?B?aGNNekNWbTRySlBkNzNIb2JiRVRnR2xaNjNKTmdTTnFHZmlmb045eUQ4RTl1?=
 =?utf-8?B?alIxcmlrcDBHN1M5OTFTV1djNGJhT1RGTFdGZXNFNTBsOXJqY09hYW9nWHc4?=
 =?utf-8?B?QUdqQXVQUll2bTFjaUFFOWJpb2o1dklvNjRxd3lYanFRYWJiOElRU0ZJN1Mx?=
 =?utf-8?B?bzgxbGpIcUh4ZGRINW5DV0ZiV3hhMkx5emhqbTZpVS9hckpPbTNKV2d6bmxj?=
 =?utf-8?B?aUpMWmxyaU9PQXFNUW81Z05mV0RERi9TT0NNQ3ZQNkxLWG5nbERBSDhMOU5x?=
 =?utf-8?B?cnB3NzFoYitCZUJyTC9PQzhsNks2K0k2N2hXbER4WG11T3JiOG8xQ0RQVHFu?=
 =?utf-8?B?Y1kxZUdFQ2VLQ0JTWUxzbTdQMzFjOENGTGE5d1ZRenorOEdMRTNHdmZIdzAx?=
 =?utf-8?Q?QRzI6e2rnRwbcUhw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <48AFDDD61011394E923FD1621AB2743C@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af7d7877-7cea-4e25-1f72-08da4b08f40e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2022 17:45:05.2578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wVNhypu7EXX9RhOlwWqTon4VhYDsaNmu0u5lxOJsL5Zicx8I3AQj2NAkRD/0UJpPzu0lqx2Qvala+gouY/e9Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB3521
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCBKdW4gMTAsIDIwMjIgYXQgMDU6MzY6MzlQTSArMDEwMCwgUnVzc2VsbCBLaW5nIChP
cmFjbGUpIHdyb3RlOg0KPiBPbiBGcmksIEp1biAxMCwgMjAyMiBhdCAwNTozODoyOVBNICswMjAw
LCBBbHZpbiDilLzDoWlwcmFnYSB3cm90ZToNCj4gPiBGaW5hbGx5LCBydGw4MzY1bWJfcGh5bGlu
a19nZXRfY2FwcygpIGlzIGZpeGVkIHVwIHRvIHJldHVybiBzdXBwb3J0ZWQNCj4gPiBjYXBhYmls
aXRpZXMgYmFzZWQgb24gdGhlIGV4dGVybmFsIGludGVyZmFjZSBwcm9wZXJ0aWVzIGRlc2NyaWJl
ZCBhYm92ZS4NCj4gPiBUaGlzIGFsbG93cyBmb3IgcG9ydHMgd2l0aCBhbiBleHRlcm5hbCBpbnRl
cmZhY2UgdG8gYmUgdHJlYXRlZCBhcyBEU0ENCj4gPiB1c2VyIHBvcnRzLCBhbmQgZm9yIHBvcnRz
IHdpdGggYW4gaW50ZXJuYWwgUEhZIHRvIGJlIHRyZWF0ZWQgYXMgRFNBIENQVQ0KPiA+IHBvcnRz
Lg0KPiANCj4gSSd2ZSBuZWVkZWQgdG8gcmVhZCB0aGF0IGEgZmV3IHRpbWVzLi4uIGFuZCBJJ20g
c3RpbGwgbm90IHN1cmUuIFlvdSBzZWVtDQo+IHRvIGJlIHNheWluZyB0aGF0Og0KPiAtIHBvcnRz
IHdpdGggYW4gaW50ZXJuYWwgUEhZICh3aGljaCBwcmVzdW1hYmx5IHByb3ZpZGUgYmFzZVQgY29u
bmVjdGlvbnM/KQ0KPiAgIGFyZSB1c2VkIGFzIERTQSBDUFUgcG9ydHMuDQoNCldpdGggdGhpcyBj
aGFuZ2UgdGhleSBub3cgX2Nhbl8gYmUgdXNlZCBhcyBDUFUgcG9ydHMuIEluIHByYWN0aWNlIEkg
dGhpbmsgbW9zdA0KYXBwbGljYXRpb24gd291bGQgdXNlIHBvcnRzIHdpdGggaW50ZXJuYWwgUEhZ
IGFzIERTQSB1c2VyIHBvcnRzLiBCdXQgdGhlDQpoYXJkd2FyZSBjYW4gdHJlYXQgYW55IHBvcnQg
YXMgYSBDUFUgcG9ydCwgYW5kIGFzIFZsYWRpbWlyIHBvaW50ZWQgb3V0IGluIHRoZQ0KdGhyZWFk
IEkgYWRkZWQgaW4gdGhlIExpbms6LCB0aGUgcHJldmlvdXMgdGVzdCAoZHNhX2lzX3VzZXJfcG9y
dCgpKSB3YXMNCnNwdXJpb3VzLg0KDQo+IC0gcG9ydHMgd2l0aCBhbiBleHRlcm5hbCBpbnRlcmZh
Y2Ugc3VwcG9ydGluZyBhIHJhbmdlIG9mIFJHTUlJLCBTR01JSSBhbmQNCj4gICBIU0dNSUkgaW50
ZXJmYWNlIG1vZGVzIGFyZSBEU0EgdXNlciBwb3J0cy4NCg0KU2FtZSBhcyBhYm92ZTogcHJldmlv
dXNseSB0aGV5IGNvdWxkIG5vdCBiZSBjb25maWd1cmVkIGFzIERTQSB1c2VyIHBvcnRzLiBOb3cN
CnRoZXkgY2FuIGJlLiBUaGUgdXRpbGl0eSBpcyB1cCBmb3IgZGViYXRlLCBidXQgYXQgbGVhc3Qg
dGhlIGNvZGUgaXMgY29ycmVjdC4NCg0KPiANCj4gV2l0aCBNYXJ2ZWxsIHN3aXRjaGVzLCBpdCdz
IHRoZSBvdGhlciB3YXkgYXJvdW5kIC0gdGhlIHBvcnRzIHdpdGggYW4NCj4gaW50ZXJuYWwgUEhZ
IGFyZSBub3JtYWxseSBEU0EgdXNlciBwb3J0cy4gT3RoZXIgcG9ydHMgY2FuIGJlIGEgdXNlciwN
Cj4gaW50ZXItc3dpdGNoIG9yIENQVSBwb3J0Lg0KPiANCj4gU28sIEknbSBzbGlnaHRseSBjb25m
dXNlZCBieSB5b3VyIGRlc2NyaXB0aW9uLg0KDQpBZnRlciByZWFkaW5nIHRoZSBhYm92ZSwgcGxl
YXNlIGxldCBtZSBrbm93IGlmIHlvdSBhcmUgc3RpbGwgY29uZnVzZWQuDQoNCktpbmQgcmVnYXJk
cywNCkFsdmlu
