Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA89500C3E
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 13:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240661AbiDNLjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 07:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236676AbiDNLjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 07:39:47 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10139.outbound.protection.outlook.com [40.107.1.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550215005C;
        Thu, 14 Apr 2022 04:37:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrT6ZeAZE9gEBkKBmhY25irO8ieQ5BSdWV8Y8WOExK1BytjpP3+3mdtxLbcGn9WGELB4p50+QuZ3GOEUygMlUGisP7lvwPfZ1yLxN0B5r9NeLTdTXEhsiWk0dEoAlxcGVTUxNNiTYxVu2vGIpPix1hjzVmwAWRpXS/WqfIZs5Dej4NEvav+XYvO1VPt/j3orHDhTVlmGgeaV2lDaALAqP6RjxmT+uq3lkiK6edvU2RQWza9Ok2KWJ5/sR8JCClm+/4TwAVr4HeKS8bcwaaQld9GYvnKHHPFkxhpPWxd/VhTeBV5m55d2F3OyAUWzN0Pq/6gB0NIaSSTtUax2f/7LMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gmyvVaRZKhxIdJZKGLbCulSMFQEaMdr0bNE52fZRO+M=;
 b=LbGK0V8XIzmRbblRpv4zXARXy73YjH7Vc8KAy88LMxWq/DIrLfS70yTvE3AKvS16nmAl/F4NG87iEvNG/sbjzkhQvrwtwv1ZPfRzJ7mRKTPRWAtE4wQVCiUpgm6Uojn4nf8BoxuGM78IYmwbIS7zd/3gYwBGn35f7/MqR8ycUlT8Po+7kmFAUfRtquoUT4jUZdfnhCpeEKnD5FhDH1dpHPvAyKT4CboAvEI0P+KP73kQKKj0LSAxOD+eEFzPGavDDbnkJ/CMdMrzjiMs3aqXqcUxNt4uoHzqJmFToUll+UzUVyLKMKPygFI6PJaQ6oL4GsetWgFLUSfqZHTA+fnnsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmyvVaRZKhxIdJZKGLbCulSMFQEaMdr0bNE52fZRO+M=;
 b=ijF6fMlXqrAEc5HpdobT8UCW44JqHo+BJdO/sL3QvjPEbXVZ4u1oKDb0SyDyHTb4PjBMASWv30FdzUkaDbx1mbo70kjMMHWa6H7UIp0PYJ1u4ELRlRuAnQIgi+2/MIxZ8w2bdQcSNGQwEBjUrrJQSgIb+g/dgTFoAF8Om5uk1C4=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB8PR03MB5642.eurprd03.prod.outlook.com (2603:10a6:10:108::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 11:37:19 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82%3]) with mapi id 15.20.5144.030; Thu, 14 Apr 2022
 11:37:19 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tobias@waldekranz.com" <tobias@waldekranz.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for
 RTL8367RB-VB
Thread-Topic: [PATCH net-next] net: dsa: realtek: add compatible strings for
 RTL8367RB-VB
Thread-Index: AQHYTlsZ5PP7ok0nLUG60UBEzGR+wazuLqKAgAB3SYCAAA0zAIAAmCkA
Date:   Thu, 14 Apr 2022 11:37:19 +0000
Message-ID: <20220414113718.ofhgzhsmvyuxd2l2@bang-olufsen.dk>
References: <20220411210406.21404-1-luizluca@gmail.com>
 <20220412105018.gjrswtwrgjyndev4@bang-olufsen.dk>
 <CAJq09z53MZ6g=+tfwRU-N5BV5GcPSB5n0=+zj-cXOegMrq6g=A@mail.gmail.com>
 <20220414014527.gex5tlufyj4hm5di@bang-olufsen.dk>
 <CAJq09z6KSQS+oGFw5ZXRcSH5nQ3zongn4Owu0hCjO=RZZmHf+w@mail.gmail.com>
In-Reply-To: <CAJq09z6KSQS+oGFw5ZXRcSH5nQ3zongn4Owu0hCjO=RZZmHf+w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 125762de-e38f-4cc6-0fe5-08da1e0b2220
x-ms-traffictypediagnostic: DB8PR03MB5642:EE_
x-microsoft-antispam-prvs: <DB8PR03MB56429F42A45ED9EFC150F40283EF9@DB8PR03MB5642.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cHWtg0QjSdQXTQl7hpNv6GNP0YBJ5GSxSEtKR6MPVLCN8mGvKB7ISfskn982KWCvyv5aH1qHBEo0q0V0x4Hrg82spxpwuzLu9DrAHLd7O/4b55vwGr2sNDOMXcLmvKNWEz5RjH/kSetX4UhfvMEip29U3DFoxH5F6lkoglwBzrvbu8INMfmKPegQx39rQcwQ96dYxrcRHXb/z2GLUO5vczpeugtnuhWifDKViOoOYQ1eWbGVrn9eSmJHjfQFi7BZbt1/bHQtByyQYLRPofnGdY4nlVCY8f43ftWZLhNbZM9Qht48qu2fPT+CdzknGXLFpkvJIVjcsPa0dfoZuOhZv0lx4M453LeutROhleTb3ps+dwWvazLlSXobAgOXG8KaqlQivicH/ghm2G2RM3QA9wBSQ2CRoiw1toOcnyFS5Be9mCUMQzsaNsT18VZdld02lLhH/4QtKTJhBi320hnPBXz12iVKo5O806R/tEJ1hJqk7TepPrVvV8FBc48ipXEBFAYHluWUZehn5gl8r+gg0j4kIA1pgxifiQrvUUGvBJRzo1nJvZ/NkxauTEPjDF72KkgRBvZKH72s+MpgbZAEnIb7Cv7pIO1U9FVEBsa2ccRvO7DMzjQG9FZJiQqKHoi48kuQ20UN0xPAWWn1IUS6292jcb6agEFMxcYjDpJg/FSXfz0/Vd3j75oIsoddhiqE/sAustSdol4b3uE2b4vc/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(5660300002)(86362001)(85182001)(2906002)(122000001)(38100700002)(2616005)(91956017)(76116006)(36756003)(508600001)(26005)(66556008)(66476007)(1076003)(66446008)(64756008)(66946007)(4326008)(71200400001)(7416002)(6486002)(38070700005)(8976002)(8936002)(186003)(4744005)(8676002)(6916009)(6506007)(54906003)(6512007)(85202003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q1ZuMVBmTkdSbnBHcVdCNG9ENzVnMmdDS3lvWWxOYWsyUUFMTGVkQzVRRW9l?=
 =?utf-8?B?YWg3bUsyTzFYL1hydmRROUJCYXdveTFodXl3RGpVcW1lZklBNEhNY2ZIK01t?=
 =?utf-8?B?QVQ4V2gyQmNRY3pPeWYycVlUYXZSdW4xSWl3VFdlcDdYRHUwUDRsZzlWQy9m?=
 =?utf-8?B?QkFpS1FORko3SXREQysxaXJYU09uellPd0Y5cDg2SnhjK2lMRjhRZWVJNlVw?=
 =?utf-8?B?ckNPY1FYcEVXaVlZSnk3TFdRMmJVQWFxQkhBUTJJcXVxOWh4RThqekRzQ3FQ?=
 =?utf-8?B?VEpDTlVqaHZ5YnZzYWw0M3l0ZEpXQ3BPRXZNb2Fvc3d2dGkxRlYyVlI1RkZT?=
 =?utf-8?B?VjNDY0czV3J3c05kcC9MWFRZU21sSWtyTUhOaXp3My9HZTBOVzFIUXZZTmpO?=
 =?utf-8?B?amh0S0U5dTdJaGZ2WlpVTXdsZkc0WDdZT2NBZ25XY2x6b1lSZkpoZU4vK1lY?=
 =?utf-8?B?NktUcmUyWGRqUnZFWTk5QitpdUo2RWJIU3FHci93WkFPWUlNOWk0TDJ3K1N0?=
 =?utf-8?B?blhKK0prOHN3eTRHSlRhRTY2Rnh5VzBRdzh4dytYVFVsZFdVTDQ2Y0xVRU9P?=
 =?utf-8?B?K2pOdzkrNmtPaEFMV3V2Z3VYRDVzeCtScnhrMkNKbGVmQkxlU1l4U1FnWFhl?=
 =?utf-8?B?emN5dkNMVEh5YUp2TzJ2cEdmTkJ1a25TWHJLZ2VuSFo2TVNTanpZSHdlMFlH?=
 =?utf-8?B?UHFoNmYzK2tRbmRFL1JmamtQZlNKNXIydXFMS0ZEWnV1bzFNTUZIWWVWRklP?=
 =?utf-8?B?b0ZOY2ZBYVdMZXFDYWMzN1BSUjdHRW44d1FnQ0hwTlI4SnFoQzBpZlZubG9m?=
 =?utf-8?B?TkMvSEdUOTFDL0QzV00rY3pnUVRRVWF4Q2VTWVhQendJNys2aGx0ZjBseEhD?=
 =?utf-8?B?S01FYXVnSlJINHd0VkUyU2dEdSt1djZrZ05GS0VHRDZmVXFHM25BQ2NzZ1Vv?=
 =?utf-8?B?M05CenludDJoeTlzWCtZdUlUTGVqTFgzNzZGSFNaRllVVDB1STFPdVdJOGxD?=
 =?utf-8?B?REl1KzJVYklRWVE0NWtVa3c4eVprR0h2Q21LUU91RURYV29DYjNkMUZwcFc3?=
 =?utf-8?B?dFhHRWphcGhIK2Y1dlY2aktnaWVYaUtYN1JLN2FPdWZtR2JuSHNodWI5KzZm?=
 =?utf-8?B?S3RQRGc3a2xQWlNqTFNQNHFHd0hmbGNnT0pNTUNGYW1lWHRKbHhldlRBOWU2?=
 =?utf-8?B?WDdRQllIajRadHpnMkZkOUtWT0l6dlp5bU94YkVDUFhzSUlQcERwQU9zaStY?=
 =?utf-8?B?QVk0b1BFQmhMQzNoQmFWNEdTeFRHRDJZWXViTk81MC9xL3ZOQlNKSzJVRWkx?=
 =?utf-8?B?RGdxU0g5RTBmTVNUU1Y1ejV4UFF5aHI0OHJwbi9MQms2aFBnM0l6a1FKVWhw?=
 =?utf-8?B?a1piZW81UXEyNFY1YWYrS3ZGTDdGbkhnOEw0TjNBeUU2LzRtMUNTdllxSDZQ?=
 =?utf-8?B?Uk9pRDE0MS9weHFjLzlYVUJSdzdJdDgvbEFQYUtnVmY0WUxqVVVuMHdxZzJB?=
 =?utf-8?B?end4bEZxZkVqRWhTaTFuUC9NNE1tSUdNVGM0V0l2QVBxbFZzVmFWM0ExVTdE?=
 =?utf-8?B?MXRDZ2tiWkFVUjNubGpXS1Vmc2phRmhabElYdmFsWlkybjRpQ3BVaDdLTHlh?=
 =?utf-8?B?RWVETEVIMVJ0aG1PYWN2Y2I0bHpIUnkxUGhaTWlYZXByYXB5STc0VEh4Wi9T?=
 =?utf-8?B?aTNhcSt1aVh6cEhlSFFwWWZQMmFOd1NBVm5iZmd1RjZNaFpxTkthMVA0d3ZE?=
 =?utf-8?B?WjFsNkNHUFA2ZnNqa2ZwZ0p1V041N2s4WDRoMkR6dUpjVDNNQVBBMWlYNlk4?=
 =?utf-8?B?dEp4YU01RWVaWHdyNTZnelhsNFphbUE4L2hXTzhneHhjTEkrRExSQUUzU3pN?=
 =?utf-8?B?MG0rTkxDSnp4TC9ZNCsxUUtCbnhIMlVVRDRac1pIZWRTWU90aG1ldjcyU2VX?=
 =?utf-8?B?VFBrLzhrdlo4MkFFcSsxZ0NweG5NUFJZSUYzVk80aWxwN2hudGxrbHc2RmxT?=
 =?utf-8?B?V3dmYTVvZGZWcjMzMGFmazlwVllwK0FWZ0JOd3IrTjNsTHEzZ2xXZjZuNWMw?=
 =?utf-8?B?YkNuTEhuajcvVVVwQThvS0Fua3BObk1wdGFmOWlpVjlyQjJRMk1PV1o1ck9F?=
 =?utf-8?B?ckNnMTl6M3FnOSsyVzhGOTgzWEdoeUR3bnZqazFWdFU1TlNhVnhNRUFnUXZ3?=
 =?utf-8?B?TGx6VERSZUcxanFVcSsxWWtJcUZ1WnZaU0Y1Z1pVUWNXcTJzdDk4VDY3Z3ZF?=
 =?utf-8?B?NFdNblhlNmp3T2lISWt1dWZMaXlkbHBoN29qQVNxMklpOFhjMmg4Yml4Tjhu?=
 =?utf-8?B?blpwZnZYcXBaczZia1pkR0o5MjlnNEw5OUo2UmVtVXhuRm5PT1hhTWdjRTFy?=
 =?utf-8?Q?yrP0a4uAkW/D+/fs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B162850F127CD44BE0C020B2BD3FCD8@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 125762de-e38f-4cc6-0fe5-08da1e0b2220
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 11:37:19.1565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qc/Ks+vnXN4sz7Ywfn5J2iVwzA+r7AbFZglqEfqh0zwgCASc6WkN7HnP7UH6CCNyuGefNdY252kxvxTFuIkivg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB5642
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBBcHIgMTMsIDIwMjIgYXQgMTE6MzI6NDJQTSAtMDMwMCwgTHVpeiBBbmdlbG8gRGFy
b3MgZGUgTHVjYSB3cm90ZToNCj4gPiBXaGlsZSB0aGUgY29kZSBpcyBPSywgb24gc2Vjb25kIHRo
b3VnaHQgSSB0aGluayBiYXNlZCBvbiBBbmRyZXcncyBwb2ludHMgaW4gdGhlDQo+ID4gb3RoZXIg
c3VidGhyZWFkIHRoYXQgd2UgYXJlIGJldHRlciBvZmYgd2l0aG91dCB0aGlzIHBhdGNoLg0KPiAN
Cj4gSSBhZ3JlZSwgYWx0aG91Z2ggdGhlIHJ0bDgzNjVtYiBuYW1lIHdpbGwgbWFrZSBpdCBoYXJk
ZXIgZm9yIGENCj4gbmV3Y29tZXIgdG8gZmluZCB0aGUgZHJpdmVyLg0KDQpJZiBpdCBpcyBtYWRl
IGNsZWFyIGluIHRoZSBEVCBiaW5kaW5ncywgSSB0aGluayBpdCdzIGZpbmUuIElmIGl0IHdvcmtz
IGZvcg0KTWFydmVsbCBzd2l0Y2hlcywgaXQgd2lsbCB3b3JrIGZvciBSZWFsdGVrIHN3aXRjaGVz
IHRvby4NCg0KPiANCj4gSXMgaXQgdG9vIGxhdGUgdG8gZ2V0IHJpZCBvZiBhbGwgdGhvc2UgY29t
cGF0aWJsZSBzdHJpbmdzIGZyb20NCj4gZHQtYmluZGluZ3M/IEFuZCBydGw4MzY3cyBmcm9tIHRo
ZSBkcml2ZXI/DQo+IFdlIG11c3QgYWRkIGFsbCBzdXBwb3J0ZWQgZGV2aWNlcyB0byB0aGUgZG9j
IGFzIHdlbGwsIHNpbWlsYXIgdG8gbXY4OGU2MDg1Lg0KDQpZb3UgY2FuIGFsd2F5cyB0cnkhIEkn
bSBPSyB3aXRoIHRob3NlIHRoaW5ncyBpbiBwcmluY2lwbGUsIGJ1dCBvdGhlcnMgbWlnaHQNCm9i
amVjdCBkdWUgdG8gQUJJIHJlYXNvbnMuDQoNCkRvbid0IGdldCBodW5nIHVwIG9uIHRoZSB2ZXN0
aWdpYWwgInJlYWx0ZWsscnRsODM2N3MiIGNvbXBhdGlibGUgc3RyaW5nDQp0aG91Z2guLi4gd2hp
bGUgaXQncyBwcm9iYWJseSBoYXJtbGVzcyB0byByZW1vdmUgaXQsIGl0J3MgYWxzbyByZWxhdGl2
ZWx5DQpoYXJtbGVzcyB0byBsZWF2ZSBpdCB0aGVyZS4gTGludXggaXMgZnVsbCBvZiBzdWNoIGV4
YW1wbGVzLg0KDQpLaW5kIHJlZ2FyZHMsDQpBbHZpbg==
