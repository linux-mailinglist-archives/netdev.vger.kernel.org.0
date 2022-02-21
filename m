Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFEF24BEBF5
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 21:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbiBUUiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 15:38:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233815AbiBUUit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 15:38:49 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30096.outbound.protection.outlook.com [40.107.3.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C21237D4;
        Mon, 21 Feb 2022 12:38:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJoSVfRo2emOMNWUVTmVcdaMJEhA96d285odw5eU3IGfh8blxImFbxrxZGq/Qxo2htK3GYKlAmIeZGR5LKrMQMtTiJXarseqP2LlCPpPDQpMItVJAby6nMUAR4yUFIayLUozn2ivB+LmlJOsKM1r6fTiU/Of7o0HjSh+Fbpp2Cdu8z9wlEmA8TAhZm3apIgdsBlp8xzXVF30cqJI6C0sjNxZEjl6vB+aO4AfNsvqjdQZN6Zgq133V1XcxG6qPXMNV+nn3wJvvEktFoGMnVa0NId0dBW6RHcYTCCS7RRbRrU+FLWr9a7NTW1xPnI/GFlzuTWxKnsv9bAYcjOPSYvCkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RwldqLRlurvrtZ5k9O898zyd624lqwQVWHBUyIgtWtQ=;
 b=fky/HjGG5/dp2RK5FJSwsMUGYJ9QdjAxD0CCRa5IDxfET5iYYJG8k4RbNPAc4Hx2m6izCWH4q/jy5j/2PCuUJps87JfT9xjKoGsY1Y4Qj+zf+x7GBQo/Btgz/49stPz6QTaSTykQZM7zOTkor5kAddwH/x3hJyFSKb1OpZyedtKIs8CnQJTo92yVajY5aEc95XXeAOLRvaXRPAKOd0jW9EayFafnOWs7tpbN9DbFdJm8C4rHIy6kfGAJfDTEc6ZjDZfIo3OfB5EjD2ifMesgG7ZtF0MoT2DR7SfyM7I2G5Xw+D9DZstj1T/OWecFVH+J+MBMNqqn5hU7bDLj8aSldA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwldqLRlurvrtZ5k9O898zyd624lqwQVWHBUyIgtWtQ=;
 b=LJ1zbtfOqIM8qfQWBL8Z6O5DthLapOtkjrfR1JROgTqhXwS1AureFVGMrQxmvYjG6Cn2BoFY/0CuoQ8o5LTWAfdazpiraLkhTfY2AIq6CZu0zI5AhPUcNYIOveRtbyTgUwMM+4EFjNjuHfxcMGPgIh/L4YGiG2WrJK+PNA6dw8w=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB7PR03MB3690.eurprd03.prod.outlook.com (2603:10a6:5:4::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.18; Mon, 21 Feb 2022 20:38:21 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e%5]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 20:38:21 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: fix panic when removing unoffloaded port
 from bridge
Thread-Topic: [PATCH net] net: dsa: fix panic when removing unoffloaded port
 from bridge
Thread-Index: AQHYJ2Bg+WFHM6elXECD88o1NfHeLA==
Date:   Mon, 21 Feb 2022 20:38:21 +0000
Message-ID: <87ilt8hs5e.fsf@bang-olufsen.dk>
References: <20220221201931.296500-1-alvin@pqrs.dk>
        <20220221202637.he5hm6fbqhuayisv@skbuf>
In-Reply-To: <20220221202637.he5hm6fbqhuayisv@skbuf> (Vladimir Oltean's
        message of "Mon, 21 Feb 2022 22:26:37 +0200")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05bd61e7-c799-41d3-0052-08d9f57a19e0
x-ms-traffictypediagnostic: DB7PR03MB3690:EE_
x-microsoft-antispam-prvs: <DB7PR03MB369067874F8557483D4772AD833A9@DB7PR03MB3690.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SlhQaYcX8cxbbiOovF/7m/9eMwzdOw/yNVsWmSRpFWZfnUC0lZEmm5ZQlaTLxv+6aWm2twbPXFATMB776i92HIcNSlMDNwF0J60gWIwVe4063w09rW3QkG1FVeQVaAvUpORZ0oTS+nioT/UdM5KmYt8vKfMbJuXHivoz0BAQ+U8l3YG9YX7pFcXvyXw03ZZ04SN7go9h1eAOYw1Jgn1jYq571CVrRJ2RTn9zFWLb5+qhMGUDlCGuQZebbXemSqgLUv5SqQ23KZ2v9jvmFkxCYZ/7FaFgDtShvl8IEI3c9ekNyEF/Hj/f6FtJBVEt1nc4Rd4jUjM3hFANbNnZmbDLgr05BdGgiXtQPOVlpTVI63owLqUbnDZU04i8WADoFPIbBMEqDdhBREcRtqfMZsPUBwyXP1XJ3Ndn2pnM5j4H77Rdk0+EdfqJ+w7Ll7KnovA57nyPI6wy7UJDYIb4T7s7T3z/p8GXsYGbJNmFzepj6VqkUJBuJ33glNnnM+bBRZnjl6Myl6wo+Izm3bfLG8oHIJ8rPJW6ZFLiLDA6LrZlPLvk6KE8vXvp6g+YYAQDmbX6zI0AJq/KAseIBq9p/bzFhU7QKoT7h6GIGtKcXSZ9j5VVfh314LlLrAqcSDvczkjzFFaCzTT/LrQ9L3x8lawyj7MQ5mfpLhfslBu/12aRwUyUlJl2tnHMhKL4riskW+Vlyd6b0+olShnDpndsKznBtg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(8976002)(6506007)(66556008)(36756003)(71200400001)(6512007)(54906003)(66946007)(508600001)(8676002)(91956017)(66446008)(76116006)(64756008)(8936002)(85202003)(26005)(4326008)(2616005)(66574015)(83380400001)(85182001)(6486002)(66476007)(316002)(86362001)(5660300002)(38100700002)(38070700005)(2906002)(186003)(7416002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTZFdis5UWZNaHpmRzJiVmpEYVE4WC92UjVXWkEwOFNldGRZYzhRQ0tyUTVQ?=
 =?utf-8?B?MDNCM1ozR3ZueTFVSDNTK290RmZEbGlXMGh2RzBqYXJpdTZmS1RTVVhZa3hh?=
 =?utf-8?B?Z0gxMlhwWEhzT0hHcVhXUjlXZGo4NGUzdjhmVGNCZFNzODJNU1hRazk5Unc0?=
 =?utf-8?B?d1JYa1MwYS94dEhwVnh6RHFyVUNHdnZkUkp0cXNrYmRvNitKNTVXaUV1b2px?=
 =?utf-8?B?TG5rNEhLaHdNMU5zR0NQSExQS2xxNDlsMC9BbGlEems5K2ZUY1lRTTFKOHBR?=
 =?utf-8?B?U1h0b1N1Z21OR1d4RllJeTdyVHZST09CUGFGVmtZRXZFbldPN1d1OGd0NDlV?=
 =?utf-8?B?TmowYngrQXNJY3dBWFhmb3FzMjNscnhnMFVlREh2QVBDek12NEM5WkUyb3NV?=
 =?utf-8?B?TENoWkRrMmkwbHArTXNBZXNReVZwblJYa0picEFFUlo1bm5nSTNzUWJCVlZD?=
 =?utf-8?B?SEFTUUt4LytjUnNSRm8vRUVXcFRZU3N3Qm11NEJUZTJqVU16Wm1tczg5NjNQ?=
 =?utf-8?B?NEtRTUE1ZXJ2MGU3TVpNOE1vYUVHNVlTZFNJRkVBMHcyWG9mT3JMMmdUbVlV?=
 =?utf-8?B?WkdLYXdqckJ2YjhPV0VkZlU2bFVvZ2taYll6ZW9vQjloOVVVc0gyemw2cFhx?=
 =?utf-8?B?bTRURFBmeWVUWStPMG42dWxwc1I5QU5iMU9mT01DWW8reG5UZERkanN5Tk5F?=
 =?utf-8?B?MnduVThUd2JRcTJDdGx2U0ZjK2VzWEFXR3JSNjVzSlpuWHljWWwzUnVyTGRv?=
 =?utf-8?B?b3k2SnZnYy9vOWtYN0FwZ3dzaEFxNXo3SVdKVzBCbys1UENQN01OZ2JxcEJ2?=
 =?utf-8?B?Y2hab2o0QjlJYlRmdEQ0UDJoZUxVckVOdmpBUmMrQjM5SDJuNHpYWDBXdExG?=
 =?utf-8?B?MkY2K2NsQVVLY3J2UXFuY0Jxd3J5YkF1QVA5cUJOa1JVYkZ2cmF3RjhJZXFn?=
 =?utf-8?B?UzhwTVpUNVZhREpMY2ZiQ2JxNXAxTWFVS0w1ZStoWm95Z29BRmJqU2RjVkN2?=
 =?utf-8?B?VTNnczNSck1LaW5RYW4xVE1NN0psaWdiUGh5UFBISkVJMUgxdHJ5WlIwcll5?=
 =?utf-8?B?SmV2enlWcmVpanhWblJDcXdMMldmWktybXpiQVNXczlEcTRMSVFlTndSc1RU?=
 =?utf-8?B?c2c3VVh3UjBoVnI1RkhWd0Zaa2dRS2o1NE16UWRvb1BOUkRNSkZlZGlJYUgz?=
 =?utf-8?B?cnhiUXlMWnYvVDJ2OHA5SlNMMkFINzlvdkwwVTBHay9qTW4yMGI4TVhFZ0xJ?=
 =?utf-8?B?NnpxWTFQa3RYQzkxc2doREtnVUhZbnNiWHBWQ3NVVmFQb2xUdU5DSTFxTFBR?=
 =?utf-8?B?RS9YZVYyaXFQU2kxVkNBNmdIRWVWaURBQ09aSW1CbjQyaytPQ2VZcEk1bmRu?=
 =?utf-8?B?eEJFYWk2RFNrREIrN2l1Z1RybDB2eUhTS2lKN1VMcnZtZFJKZDl6SmxBVFdl?=
 =?utf-8?B?aG95dFY5SXJEeFNOM3NUZWFlc1JWTytmdzVJUjk1YlJRSkdLRzlLTllLVlM1?=
 =?utf-8?B?emJqaDFXTEFqU0FJRmFLTXRLdmovSURJc3BrV2Urbitzbll0VzhDOTRncnh1?=
 =?utf-8?B?d0hGbFdxTk43Z3BTWHpXZUpEZWowUzhMMk9qdldodUs5UVhYL2tONFFvWTV1?=
 =?utf-8?B?cUZPR0J3ekpvazgxaHBVS0FDMnZXd1NrWEZOZ1VFd2VKM2g4eElIRnVhREov?=
 =?utf-8?B?SjZZeWpwZHhSTVhVeTREc2ZCcTVaanMraHRwTklvemlvKzhLU2R6NTVERmo4?=
 =?utf-8?B?dU9QMFFVRVp4QnV6cGVNQTFKNDZHajdYWWJLMERLQkdTajB6eHMrZFY0Tm5w?=
 =?utf-8?B?d3lQTmk4WERNVFYvWXF0M3ozNU5ua2J0U2wvS1Z5d25IemhlaUVJdldyRW55?=
 =?utf-8?B?NzhiYmpYeXQ5bHlsN1JVUHJURGFvbFljNk53d0VtWkdzZlpnem5GTVhiNGht?=
 =?utf-8?B?OXd0OExCa3hoc3ByQnFuOVJZSUFRdDdiM0UvYUZsaW1JWnRlcXFrQ1VYazgx?=
 =?utf-8?B?T3FsamRoWTNMdmFNRkdzejUxNFNuS1VlVUV0Rnd6aFFibnRsWkpNSFhIWGQv?=
 =?utf-8?B?cUVPSCtNOTgxUHc1V1o0T3VpMW1rdHdNOHpXMHVGaFlOeUVNSjA2U093TWdj?=
 =?utf-8?B?TjJIN3RhandreGlndjB4M1pBWEdhc2owdEM3YXlQc2lrY2l4NTdKdWZVL3NW?=
 =?utf-8?Q?W1jBpxiI8lYiSU52Mlbcasc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EBB4FFEC7E00F3449E9DD1B25FE3ABA3@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05bd61e7-c799-41d3-0052-08d9f57a19e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2022 20:38:21.8092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XnX3eh1/V+JNPQbpQLpAwwiSLfdK0LnODTy8zRRXQaVazJEjQbtGlNi8e6HiahiLSDOXChVtL4a4AJfOvfvTrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3690
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VmxhZGltaXIgT2x0ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT4gd3JpdGVzOg0KDQo+IE9uIE1vbiwg
RmViIDIxLCAyMDIyIGF0IDA5OjE5OjMxUE0gKzAxMDAsIEFsdmluIMWgaXByYWdhIHdyb3RlOg0K
Pj4gRnJvbTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1vbHVmc2VuLmRrPg0KPj4gDQo+PiBJ
ZiBhIGJyaWRnZWQgcG9ydCBpcyBub3Qgb2ZmbG9hZGVkIHRvIHRoZSBoYXJkd2FyZSAtIGVpdGhl
ciBiZWNhdXNlIHRoZQ0KPj4gdW5kZXJseWluZyBkcml2ZXIgZG9lcyBub3QgaW1wbGVtZW50IHRo
ZSBwb3J0X2JyaWRnZV97am9pbixsZWF2ZX0gb3BzLA0KPj4gb3IgYmVjYXVzZSB0aGUgb3BlcmF0
aW9uIGZhaWxlZCAtIHRoZW4gaXRzIGRwLT5icmlkZ2UgcG9pbnRlciB3aWxsIGJlDQo+PiBOVUxM
IHdoZW4gZHNhX3BvcnRfYnJpZGdlX2xlYXZlKCkgaXMgY2FsbGVkLiBBdm9pZCBkZXJlZmVybmNp
bmcgTlVMTC4NCj4+IA0KPj4gVGhpcyBmaXhlcyB0aGUgZm9sbG93aW5nIHNwbGF0IHdoZW4gcmVt
b3ZpbmcgYSBwb3J0IGZyb20gYSBicmlkZ2U6DQo+PiANCj4+ICBVbmFibGUgdG8gaGFuZGxlIGtl
cm5lbCBhY2Nlc3MgdG8gdXNlciBtZW1vcnkgb3V0c2lkZSB1YWNjZXNzIHJvdXRpbmVzIGF0IHZp
cnR1YWwgYWRkcmVzcyAwMDAwMDAwMDAwMDAwMDAwDQo+PiAgSW50ZXJuYWwgZXJyb3I6IE9vcHM6
IDk2MDAwMDA0IFsjMV0gUFJFRU1QVF9SVCBTTVANCj4+ICBDUFU6IDMgUElEOiAxMTE5IENvbW06
IGJyY3RsIFRhaW50ZWQ6IEcgICAgICAgICAgIE8gICAgICA1LjE3LjAtcmM0LXJ0NCAjMQ0KPj4g
IENhbGwgdHJhY2U6DQo+PiAgIGRzYV9wb3J0X2JyaWRnZV9sZWF2ZSsweDhjLzB4MWU0DQo+PiAg
IGRzYV9zbGF2ZV9jaGFuZ2V1cHBlcisweDQwLzB4MTcwDQo+PiAgIGRzYV9zbGF2ZV9uZXRkZXZp
Y2VfZXZlbnQrMHg0OTQvMHg0ZDQNCj4+ICAgbm90aWZpZXJfY2FsbF9jaGFpbisweDgwLzB4ZTAN
Cj4+ICAgcmF3X25vdGlmaWVyX2NhbGxfY2hhaW4rMHgxYy8weDI0DQo+PiAgIGNhbGxfbmV0ZGV2
aWNlX25vdGlmaWVyc19pbmZvKzB4NWMvMHhhYw0KPj4gICBfX25ldGRldl91cHBlcl9kZXZfdW5s
aW5rKzB4YTQvMHgyMDANCj4+ICAgbmV0ZGV2X3VwcGVyX2Rldl91bmxpbmsrMHgzOC8weDYwDQo+
PiAgIGRlbF9uYnArMHgxYjAvMHgzMDANCj4+ICAgYnJfZGVsX2lmKzB4MzgvMHgxMTQNCj4+ICAg
YWRkX2RlbF9pZisweDYwLzB4YTANCj4+ICAgYnJfaW9jdGxfc3R1YisweDEyOC8weDJkYw0KPj4g
ICBicl9pb2N0bF9jYWxsKzB4NjgvMHhiMA0KPj4gICBkZXZfaWZzaW9jKzB4MzkwLzB4NTU0DQo+
PiAgIGRldl9pb2N0bCsweDEyOC8weDQwMA0KPj4gICBzb2NrX2RvX2lvY3RsKzB4YjQvMHhmNA0K
Pj4gICBzb2NrX2lvY3RsKzB4MTJjLzB4NGUwDQo+PiAgIF9fYXJtNjRfc3lzX2lvY3RsKzB4YTgv
MHhmMA0KPj4gICBpbnZva2Vfc3lzY2FsbCsweDRjLzB4MTEwDQo+PiAgIGVsMF9zdmNfY29tbW9u
LmNvbnN0cHJvcC4wKzB4NDgvMHhmMA0KPj4gICBkb19lbDBfc3ZjKzB4MjgvMHg4NA0KPj4gICBl
bDBfc3ZjKzB4MWMvMHg1MA0KPj4gICBlbDB0XzY0X3N5bmNfaGFuZGxlcisweGE4LzB4YjANCj4+
ICAgZWwwdF82NF9zeW5jKzB4MTdjLzB4MTgwDQo+PiAgQ29kZTogZjk0MDJmMDAgZjAwMDIyNjEg
Zjk0MDEzMDIgOTEzY2MwMjEgKGE5NDAxNDA0KQ0KPj4gIC0tLVsgZW5kIHRyYWNlIDAwMDAwMDAw
MDAwMDAwMDAgXS0tLQ0KPj4gDQo+PiBGaXhlczogZDNlZWQwZTU3ZDVkICgibmV0OiBkc2E6IGtl
ZXAgdGhlIGJyaWRnZV9kZXYgYW5kIGJyaWRnZV9udW0gYXMgcGFydCBvZiB0aGUgc2FtZSBzdHJ1
Y3R1cmUiKQ0KPj4gU2lnbmVkLW9mZi1ieTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1vbHVm
c2VuLmRrPg0KPj4gLS0tDQo+DQo+IFNvcnJ5LCBJIHRob3VnaHQgdGhhdCB0aGUgY2FsbGVyIG9m
IGRzYV9wb3J0X2JyaWRnZV9sZWF2ZSgpIHdvdWxkIGNoZWNrDQo+IHRoaXMsIGJ1dCBjbGVhcmx5
IHRoYXQgaXMgbm90IHRoZSBjYXNlLg0KPg0KPiBJIHNlZSB0aGF0IHRoZXJlJ3MgYSBzaW1pbGFy
IE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBpbiBzb21lIHBhdGNoZXMgSQ0KPiBzZW50IHRvZGF5
LCBzbyBJJ2QgYmV0dGVyIGZpeCB0aGF0IHRvbyBiZWZvcmUgdGhleSBnZXQgYWNjZXB0ZWQuDQo+
DQo+PiAgbmV0L2RzYS9wb3J0LmMgfCA5ICsrKysrKysrLQ0KPj4gIDEgZmlsZSBjaGFuZ2VkLCA4
IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4+IA0KPj4gZGlmZiAtLWdpdCBhL25ldC9k
c2EvcG9ydC5jIGIvbmV0L2RzYS9wb3J0LmMNCj4+IGluZGV4IGVlZjRhOThmMjYyOC4uZmM3YTIz
MzY1M2EwIDEwMDY0NA0KPj4gLS0tIGEvbmV0L2RzYS9wb3J0LmMNCj4+ICsrKyBiL25ldC9kc2Ev
cG9ydC5jDQo+PiBAQCAtMzk1LDEwICszOTUsMTcgQEAgdm9pZCBkc2FfcG9ydF9icmlkZ2VfbGVh
dmUoc3RydWN0IGRzYV9wb3J0ICpkcCwgc3RydWN0IG5ldF9kZXZpY2UgKmJyKQ0KPj4gIAkJLnRy
ZWVfaW5kZXggPSBkcC0+ZHMtPmRzdC0+aW5kZXgsDQo+PiAgCQkuc3dfaW5kZXggPSBkcC0+ZHMt
PmluZGV4LA0KPj4gIAkJLnBvcnQgPSBkcC0+aW5kZXgsDQo+PiAtCQkuYnJpZGdlID0gKmRwLT5i
cmlkZ2UsDQo+PiAgCX07DQo+PiAgCWludCBlcnI7DQo+PiAgDQo+PiArCS8qIElmIHRoZSBwb3J0
IGNvdWxkIG5vdCBiZSBvZmZsb2FkZWQgdG8gYmVnaW4gd2l0aCwgdGhlbg0KPj4gKwkgKiB0aGVy
ZSBpcyBub3RoaW5nIHRvIGRvLg0KPj4gKwkgKi8NCj4+ICsJaWYgKCFkcC0+YnJpZGdlKQ0KPj4g
KwkJcmV0dXJuOw0KPj4gKw0KPj4gKwlpbmZvLmJyaWRnZSA9ICpkcC0+YnJpZGdlLA0KPg0KPiBC
eSB0aGUgd2F5LCBkb2VzIHRoaXMgcGF0Y2ggY29tcGlsZSwgd2l0aCB0aGUgY29tbWEgYW5kIG5v
dCB0aGUNCj4gc2VtaWNvbG9uLCBsaWtlIHRoYXQ/DQoNCllpa2VzLCBzb3JyeSBhYm91dCB0aGF0
LiBTZW50IGEgY29ycmVjdGVkIHYyIG5vdy4NCg0KSXQgZG9lcyBhY3R1YWxseSBjb21waWxlIHRo
b3VnaC4NCg0KS2luZCByZWdhcmRzLA0KQWx2aW4=
