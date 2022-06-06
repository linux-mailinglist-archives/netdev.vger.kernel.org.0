Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088FB53E90C
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239534AbiFFN5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 09:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239561AbiFFN5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 09:57:49 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70134.outbound.protection.outlook.com [40.107.7.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C14220E3;
        Mon,  6 Jun 2022 06:57:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ckdfPTcvIEFhOL/DlQibLl5NOO7O+3v14YsgpSi0YLJILhzMqE2WF4GZ0ids6Mt0lY3mjsW8SM2Qhc23jpuHegYsMcTZiHYiYJCJRjFSnoA4ADwk+ecJrGocv01BMxPqhITgmOO53F9j0qyZSP5ii3ImvvFbxN6Bmat31Qof8Dxbxpsz5+tFGpdU7f8dFd3vZMU0rsoIYz51mK7X/yAOIuNkle0pdx6Bj6+VoE+j08VM9wO48t/ZQ65XtHPS9AsCruchvrHQkzmSgYqbdGySGfNXsPb/wwiEjSsgDm77/ScMiLKZgCEjn9KtqjOhGikEYgFaNiRupa7keVGtZWrVEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/s2k0hKVIWiBzI6zQGver2jlwxIoBmhDT9pQrQOg8Q4=;
 b=STVXTyT6P/ZBkVWbzWFIgW1NVPNrq7sxk7esxlDm91G8BJBB9Vuuw6WAxStAa9+XoOZQts2lUMqlWxdVoShRaDmqevy+zTz4QmliJE1WIaMkLAB+/vvjyPkxdLdqjzrd3L86Aa8wLW4EUd+JCaISHMoZLCVdcwUblU0TXaqumxNS29EejXYBAZvykUxe20lQu2FXPohwHMb9oW7v5K9AQb5eKuCqFWisCAchjNcUbBE/AAFuayG/bONUDNiYbFUO/hFRFkQUAUCPY/7QT2NpCsGMC+1+bpm5dDAjI+tvbDcaAIa/Mza/kyJfMkSRgSUq4VI2SqiQSnul7DbQMNbn0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/s2k0hKVIWiBzI6zQGver2jlwxIoBmhDT9pQrQOg8Q4=;
 b=ZmLoHj4LtGtGdSIqkKG90OFGVAZ8Q+QGQJwXIqU3nQclByxfBnPHMwMPmgvLtOQkiVKHLNVYJDBxMm+kl+lHW+3tXIZ3maja3PirneeADb+n5RfELq30DzveO5oCxfUiB3dtRRPzzzVbFohXzXmjqUIu8f2Sok1L+fnEvWBaMXc=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM0PR03MB5683.eurprd03.prod.outlook.com (2603:10a6:208:16f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Mon, 6 Jun
 2022 13:57:45 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111%7]) with mapi id 15.20.5314.018; Mon, 6 Jun 2022
 13:57:45 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>
CC:     "luizluca@gmail.com" <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/5] net: dsa: realtek: rtl8365mb: improve
 handling of PHY modes
Thread-Topic: [PATCH net-next 0/5] net: dsa: realtek: rtl8365mb: improve
 handling of PHY modes
Thread-Index: AQHYeavJnIfQHCQvXky32f8tCzvdMq1CZ3OA
Date:   Mon, 6 Jun 2022 13:57:45 +0000
Message-ID: <20220606135745.gyrnxpu4i7jf4gt2@bang-olufsen.dk>
References: <20220606134553.2919693-1-alvin@pqrs.dk>
In-Reply-To: <20220606134553.2919693-1-alvin@pqrs.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04eb00d2-7f3a-4763-8cf9-08da47c4887d
x-ms-traffictypediagnostic: AM0PR03MB5683:EE_
x-microsoft-antispam-prvs: <AM0PR03MB5683BD5AAE85CDEFC7EA886983A29@AM0PR03MB5683.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IFB4oyxGr4HvftjGs8w+jLo+CGK/1ih/CMpoucdxYIb+8SexzLYTp6O/LCxDbOa4ttxNnLy2bs8uhgC7LNyGyIDT1fwaNOiSYey5uckyjs+W/n8d6esnPCvKb9S/eJOijKmp5bKC2FXz4bGI0k1DXTFyUw1LEagqkXUigviDozcVknxEwy/XLlh2HcAy6SxFtac7vj5q1jLG7ieG5TMKSxyRwqAcQozf1pGxpZwmlLo7HQRaQa/9egacvb2tP/NinmayqpRu854NOi8W6UCIQVtjUjdtlueF2XE79Itg8WrayapBLFb+MQDe3VrChb4RyYGfTwpBsjvLOQJA2eFegxI1mBu5oKolNWo0zvSi0XRIOkCBqjCyYifH+arxvBCeviLjSfEXT7a2v2b5xMUXgIR9Ydfh2YWwqX1tQiaCaL2F11RP4dz3kSwNQJEUTcx++c4lS6vzvbLO+JXZdaxldanFT7D7X0Ttxto8TzhML9IYaAmu1ZlDLh8CnRS+uSuCOXpVEQwaDLlSjPs0ljm0t0WVcHP9dTjwQKP8TlcpD4cJVfLRnrcf4oWNI/wuVXXKoZFX/nE6a63xw1Qvz2gzs685E63y0yZ/FTWKJKy5g6MvaSnx5WzNyRnLlFUv+Rc+Dbey/NzyvKZ934e2tf1NWy6uo6xOc6ZZyBZwSZCEZlHJtCVnpU6MYPVRmT6m+uU7GFak1P/dWxFEaLEEdO0+Gg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(76116006)(36756003)(6916009)(54906003)(7416002)(86362001)(71200400001)(85182001)(66574015)(91956017)(316002)(5660300002)(66946007)(66446008)(66476007)(64756008)(38070700005)(26005)(122000001)(6512007)(85202003)(4326008)(8976002)(1076003)(8676002)(83380400001)(2906002)(8936002)(6506007)(2616005)(508600001)(6486002)(186003)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dm5Fc0RlaTRSS3padjZqYkk3ZC9lYndCdVRuS0w0NFlRS1puVDQ3eUkzMzJi?=
 =?utf-8?B?QVljaTNQTDNPYy9mVTBROXVSOUtjQis3M3liTmJQRTBvUlF0aGxNVmt6c3Fk?=
 =?utf-8?B?eUw0YlpldXJBK1NsQkhWKzBuQVF4bWlkYXVxY0YwblJIVzEzbmZrOGhRS2pH?=
 =?utf-8?B?K3diNUdyUHM3QVNlMXpGTnQ4YnhXZzUyN0FFTGUrT25raUNwNGN4OHpHRzJ2?=
 =?utf-8?B?TFpEbVVwQVdVbG93SCsvcENQY3d6Yzl1Z0h0OGhFUVRqd0laaEtrWkRac0U5?=
 =?utf-8?B?YWx5d2V6L1ZpcVJ0ZDJOKzU0NG40b3dETmRkL1JGUllQdWNycURUY2pLa3Uv?=
 =?utf-8?B?MmpsY01STTJKbWJmb2tOemNBdExBT3o3bWhSd2tic0JCaXA5end3RGEwVnVY?=
 =?utf-8?B?RVk2Z3hRVW9mamRudWlybnhHUVNhUmh1RjRPTXNVQkd0OXVoVS9YRGFlcVlR?=
 =?utf-8?B?S21aWWR6Y2FaVFgvS1R1RkxXOGVVS0taRFpGWFZBQkpiamMxQ3Z5QlZlUHN5?=
 =?utf-8?B?MWdpWlhWb1JlWEhpbGZjUHBINVRSVHowdHZ3R0d2TW94MGs1NXRvTUxlNEhk?=
 =?utf-8?B?d3Z3ckpQck42blM3UHdaOE1JQUlRQ213SjNRWVlpNGt1L2ltMlNBa3RaVzVp?=
 =?utf-8?B?RTExdXNhNUFUVlFhUXRSQ1dKOXFTajNMNWJSakJ4WktDam1RbzBxMWx6VUdp?=
 =?utf-8?B?NWtOU1hYbFZpYkFENDhEbFVmM3RoMlFGSk83YUt3L2NxdHpoZ01Ob0tjWXMy?=
 =?utf-8?B?MTl4M2ZrWDlkdEUzdU9aclJlcVoydDg5ZEk3VU1mYVp4cHRKRmNIYkgrMVpM?=
 =?utf-8?B?ZmI2TWx6bzluZ3ZCZXRkS0dhTmZuTm80RGhxOGNvcExJVUdnY1pGWlloSUFj?=
 =?utf-8?B?dTV5NVQybmNYalh5VC9jWC9MM24yeWRZTTZPa1M2eHZYdG8zNmtWSkZyZTdP?=
 =?utf-8?B?T3ppNFhUSDBZeEJLRENrQ1dmVXVWSGZtSGFDZE1BZ05GcUhwaUdUeVpkeGdk?=
 =?utf-8?B?aXV0M1ZkOExtRTkyQjUrQ2JVYzQ2VlFsMExQZXNwQjRFNmhZR00xY0hsdldT?=
 =?utf-8?B?N2gvOGNZQXBPZ1d6S1lmWjJmUFFYTlVkZW85TWNpUDdYUnlDMk9UaDFFWFQ5?=
 =?utf-8?B?VUQvVktKb21iVDBhWHRkb2w4dkxBeWFUeFRNQlI5enVVdk5yUHJiRFBIZlRo?=
 =?utf-8?B?SVF4MmM4emVRVW1vK3Nlalk2b1hLMlFnR2hmS0RWQS9uSS9YNFpYeDdwNzNQ?=
 =?utf-8?B?ZzJJaXpQa0owaERSRmEwRkVtbnNVNFNrYTNlRDRTNDJOTGxnMDUyQkQyRHdm?=
 =?utf-8?B?WGdoNmVQOXMzRjc2WkF5OHN1M1FpUEs4OG5FOGtwSmZiR2ZRNGNFUWVuNXFJ?=
 =?utf-8?B?WFRhaWc1Z01zUHNSVkF3WnBHRGFXRlpGNVRrVFpIZm14cGw5dTZVYjI4aGZW?=
 =?utf-8?B?SUNSWTVVRndXcmIvMUhGNXpreFlDZ0lzdkd0NUw3OEplQ212dDJzNUREU0pY?=
 =?utf-8?B?VGFsczJCVHAya1RWcENuQmtoTDJUeHo4VVoxYlpyZHlxRmlVTmZDQ0ptOEZi?=
 =?utf-8?B?SEFUSUgrM2pSVy80YmlLbGFGK2pQeFIrQ001ZGtmWURJTEV1YVN4RXN3T0ta?=
 =?utf-8?B?SmdVSWRTZFRhT255REpDUit5MnhSUi9sWlhxMml4QjI1VUtoTjJEelNKejJ6?=
 =?utf-8?B?cUxLTklYYms2c0VnU2xFbmJadkh4WHhtMlA5ZzAxVWdORzR2WVJ4L29Vc1dQ?=
 =?utf-8?B?elk2UVFYclNsU0ZEVktXYnZiUGZYL0tDVGlyVWxCWXVqQm5jYW5adHREMmhy?=
 =?utf-8?B?c2tjMkRpYzJGSElsaUc2a1lMWjdKRjFQeDQ3Z1VXd1EzUVNkQ0tPSVB1SjYr?=
 =?utf-8?B?L2hyMExmdmVrcUE5Mk9WRmprR3Bkc0J2NUgwNEs2bkJpODNCanI3NmpDUk9q?=
 =?utf-8?B?UnZFcjN1V08rSGNuWFlLalhLMWlHUWMxdGZPck9mZ2JoK05tb2RyNGlubytV?=
 =?utf-8?B?OTVXTjNtRnJmdkxpUVU0Y0RWVG9yazF3S0dGZXlPL0R1SENaZFRyZXZOTVl2?=
 =?utf-8?B?cHN3UjBqbTFNOWQrd2tWRmhUTmFjamRIdWkvMUNGaWh0T1c1WGV0NE5yTDhx?=
 =?utf-8?B?R21PSzRmUWdaYVdaNUZSUWtJRGhKV1pCeVFZRDRSZ2h0MHJjdDIydEJCV1RU?=
 =?utf-8?B?d2lGbU85NGZxeTVZcHYzeEJpazh4SzhpdFFvTjdPaTM4QTkvbjZqc2tiZkVr?=
 =?utf-8?B?ckI4cUswSTJqWEExUEhMemtEWS9TeWthUnRHdGE3aURaenFzM0VJc09DMGVh?=
 =?utf-8?B?K2dOTi81S0N4ZDR5MmY0eXdUNDVkUWV4UFNkVmtvbEVhL2hUdnBRbWVPeW5B?=
 =?utf-8?Q?sC/cxwhWNE5A+aMg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A318FC5F3639F448AB1C8510DA9D745@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04eb00d2-7f3a-4763-8cf9-08da47c4887d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2022 13:57:45.4813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j+L/xwRlqrPfmdmPE3qLlcCp0TmVKNAuESjOrJ9CypjUyPtrmPbOTtDX/0NRJm61iy5fcSZXA2WnVUeOsts51A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB5683
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBKdW4gMDYsIDIwMjIgYXQgMDM6NDU6NDhQTSArMDIwMCwgQWx2aW4gxaBpcHJhZ2Eg
d3JvdGU6DQo+IEZyb206IEFsdmluIMWgaXByYWdhIDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4NCj4g
DQo+IFRoaXMgc2VyaWVzIGludHJvZHVjZXMgc29tZSBtaW5vciBjbGVhbnVwIG9mIHRoZSBkcml2
ZXIgYW5kIGltcHJvdmVzIHRoZQ0KPiBoYW5kbGluZyBvZiBQSFkgaW50ZXJmYWNlIG1vZGVzIHRv
IGJyZWFrIHRoZSBhc3N1bXB0aW9uIHRoYXQgQ1BVIHBvcnRzDQo+IGFyZSBhbHdheXMgb3ZlciBh
biBleHRlcm5hbCBpbnRlcmZhY2UsIGFuZCB0aGUgYXNzdW1wdGlvbiB0aGF0IHVzZXINCj4gcG9y
dHMgYXJlIGFsd2F5cyB1c2luZyBhbiBpbnRlcm5hbCBQSFkuDQoNClBsZWFzZSBpZ25vcmUgdGhp
cyB2ZXJzaW9uIG9mIHRoZSBzZXJpZXMsIGl0IGhhcyBhIGJ1aWxkIGlzc3VlIGR1ZSB0byBpbmNv
cnJlY3QNCnNwbGl0dGluZyBvZiBwYXRjaGVzIGJldHdlZW4gbmV0IGFuZCBuZXQtbmV4dC4NCg0K
SSB0aGluayBJIHdpbGwgcmUtc2VuZCBpdCBmb3IgbmV0IGluc3RlYWQgYXMgaXQgbWFrZXMgdGhp
bmdzIG11Y2ggZWFzaWVyIGZvcg0KZXZlcnlib2R5IGludm9sdmVkLg0KDQo+IA0KPiBBbHZpbiDF
oGlwcmFnYSAoNSk6DQo+ICAgbmV0OiBkc2E6IHJlYWx0ZWs6IHJ0bDgzNjVtYjogcmVuYW1lIG1h
Y3JvIFJUTDgzNjdSQiAtPiBSVEw4MzY3UkJfVkINCj4gICBuZXQ6IGRzYTogcmVhbHRlazogcnRs
ODM2NW1iOiByZW1vdmUgcG9ydF9tYXNrIHByaXZhdGUgZGF0YSBtZW1iZXINCj4gICBuZXQ6IGRz
YTogcmVhbHRlazogcnRsODM2NW1iOiBjb3JyZWN0IHRoZSBtYXggbnVtYmVyIG9mIHBvcnRzDQo+
ICAgbmV0OiBkc2E6IHJlYWx0ZWs6IHJ0bDgzNjVtYjogcmVtb3ZlIGxlYXJuX2xpbWl0X21heCBw
cml2YXRlIGRhdGENCj4gICAgIG1lbWJlcg0KPiAgIG5ldDogZHNhOiByZWFsdGVrOiBydGw4MzY1
bWI6IGhhbmRsZSBQSFkgaW50ZXJmYWNlIG1vZGVzIGNvcnJlY3RseQ0KPiANCj4gIGRyaXZlcnMv
bmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jIHwgMjY4ICsrKysrKysrKysrKysrKysrKysrLS0t
LS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxODkgaW5zZXJ0aW9ucygrKSwgNzkgZGVsZXRpb25z
KC0pDQo+IA0KPiAtLSANCj4gMi4zNi4wDQo+
