Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE53856C603
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 04:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiGICeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 22:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiGICeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 22:34:07 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2060.outbound.protection.outlook.com [40.92.99.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B838A140F1
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 19:34:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADzBYcblRAQW1i7dq2pBBo7HQLVFEBTQNgo2vvrgtdCHkR6dsFUPKGMLtM1N6NXpR11NeZxShTNbEXTS1zW4cmJb4qc8x9wKsFYyS+WzJ4mMCTB9445POHU8jBKK0eYknOAqoGHcNQ5HLvCbHjUXSE8QWbsDASwCEQ+AdLmyPID0YdavPwhgG7wkckD1pW3w2vu/rG3qbmMHQXga6My5xD3orujwG0bjcF/V59BUg+hXV/KLtkffy4x1aa0qhCT4RZOJfSGE2oyQiAiOIpFpUja5tEHVZCNnQY/xjXJjZRztwK/aN7AArjeQ9HOfOVsKF6QXs8PJe0EJoxvJHmiEqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1cw/ihyER41Z1CVwAM0Xh/0QMsJXszr5lRj9HzIyj/I=;
 b=KYUHcq3ma7K5cs0wHvrZIFEmbijctYYzDrHfhZaWZNMJDxOeemp3q/I8XCK7fVn10ngJc7fE/y+d/xhihiohuB/BxJrSNcbjLm+svC7fa3VEZtETOBFK478Rkl3K/slI18hRzZZnqIDQMs0xOz13KN1728+a++30uCEHyj9hL5QkzAViVOu2InRCBbuGtUn8HNbo+GfaIIQNR+QgO9QGuuvwLYNQJbu6U1qD/dmgeRZQhwvdtZ5q6MLenYqbXw090KoSFG6LartMcpiNc7+oeNj0gcML0/EUqQvcHmXyEkvG+PuMTSDZ3rr8lZO67aVkouqtj2LBWCL35jTuYYyu8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cw/ihyER41Z1CVwAM0Xh/0QMsJXszr5lRj9HzIyj/I=;
 b=oiLPvSgd19y/B6Cc+jIEELwUrPe/vtMIhNop6TL7xQK6V7S207Y2HyrZ8MafjhWbPT3/w+ykUUl4oGX5y+0OlICO5eTBmXCjyl9xHxnzIAlz7W08My5IhV9HEv2j4AZrid1gil60gL6MhtjLsuCCvS5T3Wp08DJOXK4XsFg8hzCaEo7xKlc+LTUWwlmipCGx+cuEbGono0ETVA2xI4SyxonbOe5JoaTfZUQlCsYcn6HfpYEKRg60gVcBsgzU87N9AV1d+BliPCEmFcWrt4JKnMEEzItV0dy27jMb+ZKcGvh3JgRKKxJ5svhF4hs8QTLNuDvIGJ9JI/2tPkN5EuVfcw==
Received: from OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:11a::9)
 by OSZP286MB1371.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:13c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Sat, 9 Jul
 2022 02:34:04 +0000
Received: from OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM
 ([fe80::79c7:e656:3e13:428f]) by OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM
 ([fe80::79c7:e656:3e13:428f%9]) with mapi id 15.20.5417.021; Sat, 9 Jul 2022
 02:34:04 +0000
From:   Feng Gao <gfree.wind@outlook.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Gao Feng <gfree.wind@gmail.com>
Subject: Re: [PATCH net] pktgen: Fix the inaccurate bps calculation
Thread-Topic: [PATCH net] pktgen: Fix the inaccurate bps calculation
Thread-Index: AQHYkt1npygLW/WMWkebrAfgpvRRoq10ob0AgACvIIo=
Date:   Sat, 9 Jul 2022 02:34:04 +0000
Message-ID: <OSZP286MB140443F792102C93E5D8A1D795859@OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM>
References: <OSZP286MB14047FAFB44F13D76137DFFA95829@OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM>
 <CANn89iKB_kQ=VKO39H4SDhPrE+-cF5FWD_O8qe5RmxJMZ7vwHg@mail.gmail.com>
In-Reply-To: <CANn89iKB_kQ=VKO39H4SDhPrE+-cF5FWD_O8qe5RmxJMZ7vwHg@mail.gmail.com>
Accept-Language: en-US, zh-CN
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: b08db3a6-3cc8-f48c-2f99-4aec3305d3c1
x-tmn:  [ZpjjUSrYBWzT0tlsYWI86AIdbcAM9V4a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1f6a0d5-bc5f-4dff-3ffc-08da61537d69
x-ms-traffictypediagnostic: OSZP286MB1371:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cna9ixlsHX/z0p/DDhu+vuYgihyaGOxMaw5loC5XNSD/4yBMkis1d1uL6ZRkuSewjiOSsyD3oEWjg4zQk8T3anmyt/UYw0QkvEpYfxseI6K6kwVBUR5tvwdTES5zYfgTwG6940g0+Il7TPOBANTgCM7miCrA/4rQPVtabCrWzAYGhlQCvbicD5Hk8CK6JqnF1PxcLh0OqqnU+Y5XcgZe9HikPh1VLay30sX5uMzXzSd5KrkzQEzeL0NYW5rQIQ4WLRffeVfQqhtHbd7Mu8H0ffvREI2tP4RtV7uUQz8Rdg25dMblBRDpaLgq5BYjdRWW0nqfhCGPD6PNi7X988mv0GegHmdS8q28oewqf6omNFn57ik1PlOZ+MRy0N9CiMTBtyYmE7C5bYMfGFUfRXjX1bTebcqrcuoyWJFvTghQ/0J4uNbobtAcr4S5Gwuf0nxshEXzRxuUo9OKs5RVUqxsnHyN6ww9/BTYl96VoCQbwskJ4NYOdEezzCfPQU5isP5olkUaDjpgQlfM/BIcMBlimNVzSDGjU83EF83YkVtdLE/gSXnhgbgiCmf/IBHE5cBhFsIGH/2QGjEbVvJ4+Rk0cKRb0/0u1R1GSwrsUat1bQDmksFOLamMSFW4nm4GbidExBxn1oWb2eG/rSXoWGHfsS3xAskZ7TF7P6XZ/SjxtDr2GalmTWwz7M7Ny3EA4SLyDqpoiHIv/BBqbSCrhF7uMt7sv+vd0cp+PRwSm7bCUog=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Q2hGdkxFSnd4Q2ZBMFAyeENHbTZmOEdvRzJJc2Rkd3J4VVBXVEQwQkpZMm9k?=
 =?gb2312?B?blpTS1Y2eFNWVnlUY3B3bU85NmlrN1lobms2SlY3NWluNDB1MFZtUytLcGJS?=
 =?gb2312?B?TDlVejA0N2N4Y1A5QXJxRkdSRU5tcUpWTW40UzlHemZpQnI2bG5XazVlemhj?=
 =?gb2312?B?R001NjZKVExJSERPVlVXOXlPbU00Yi91dmp6MWFrT3NPUWlDY0xPdDRDTTJY?=
 =?gb2312?B?Y2hETWM2USsvZEwzQlB2d2FTWWwvNVdLcUlJOEtJUmwraEZMSVFoMmhmVTNa?=
 =?gb2312?B?ZXhvdVR2TGd2bnA3a3JEeXJ5NjRIeDErRWRQck9vaGpzMmthNnEyU0dtSm16?=
 =?gb2312?B?TmxaQ0pFL1JhbEZhL0ZCNmF1MysvSlZ3SE9wR2srZWFGWkc1WmJXQWZlSG1U?=
 =?gb2312?B?TG40UWZRblh0VFBKQWFBSUdRVTUvYmlJNlJSSHdHSmRNM1FWSHdRTFhUQlls?=
 =?gb2312?B?dEZOdHRYUHdBODFqaG8rbkZTWFdSVTNEbEtsWTRGN1BDcVF0VVBQTTJneDZa?=
 =?gb2312?B?dTJIUm5xcjFPZyt4NisrRnhzb2plNmNNZnZwcDBzMWp0dU9sTENMcFI1T0JX?=
 =?gb2312?B?NjU4TWZTamx5UlpFbld3TUNmQ1dZYVBJRVFicWJXOWx3b3pxa1p1U2p3U2hz?=
 =?gb2312?B?YkhnSHorMjFxSVFldGZZSmZtdUlxNEtBZ2Z4N1hxSkZVa1lDTXdvalZkazNZ?=
 =?gb2312?B?dEVUeXVXdW9MVXRMWDFBOXlXUlpIZkQvWFRWZFlaKzJESzlUZGhZUklMb3Bu?=
 =?gb2312?B?K0NneHk2aFRsY2ZqZlF0S05zdXRLVFNmVjY0Q2VBb3VhZGk0bGVnYmplZDR1?=
 =?gb2312?B?SHovbFpLUHNacTZVSUxySnkrSFNaRUw1ODRocU9iS0VUczh2SGZ2WExpRG5B?=
 =?gb2312?B?bUZkc2Y3Z0t1QzB5TGhpVjMwYWJrYlYzTTErZEV2TXUzaTlwUnJmNXBlOVdl?=
 =?gb2312?B?aHJjZmE1d2dTYXFhSmZid3VlcWVQTm12eE9yYVVMZ3FFT01aSVU5bjYxZSs1?=
 =?gb2312?B?d3ZIcTBHUCtMbWdFb0tzQmNjTDdXWFBrZkVob2RyRFdRYzlhVUNzemJZR294?=
 =?gb2312?B?dk04RjNEaytBRGVUT3ZOZjgwODR5RytuYzJtWUx5NndTa3ZsNkZHaDNQb3Na?=
 =?gb2312?B?Mkc2b3Y5eGY1RG5DUXo5R0QwL3hkNnY3eFQzREM2eGUyNVEyaks2Si81YytR?=
 =?gb2312?B?bnZiK0ZZcTc5U3hsMXN5OUpHUlI3Z1JaSm5PRGppUFV2cElVSEQwWGFabXRH?=
 =?gb2312?B?eXBXckRsWHlqUjdRZGdoczJqSUJyYVM1cno4a2x5cml0dGFUNk5UaVd5MGp2?=
 =?gb2312?B?cUR2QWlTekVjcXRWc0liRUdOb2xlekUvakJOMkVoUFFqTUR5TzMraGpNZEpL?=
 =?gb2312?B?K01XNzFtcnhGcXlwRGw4emliZnR1Y21PSlRqeHo5NWw1dklKNjdob3JRTVNr?=
 =?gb2312?B?eHQrUXFzK1dudEZCTmcyY3NiOTJqN3pxSHo3eTFTWDNjaXNIL3VhUk5lZ21i?=
 =?gb2312?B?OHpzcG5kNktrbm0yWlZQV0swOUtzNzdHdjhJT1ZHQWJ3UE1NbWFJWnV1TGgz?=
 =?gb2312?B?eDZVRlJWT1pJLzVCTUltbmFWcmgxVEd3dklhVUVWS1hoWFVMNjZVT0wzSXVU?=
 =?gb2312?B?T0tybCsweDk1QUVhVTJreUF2NnBzdTU1RGE1aDF5Z1hkcEpRYzM5R2g3RlRH?=
 =?gb2312?B?OUJEUStIRkdEYno5eHdPZTV3VzZ2WEV4QW1qN0RtWXI5KzRBRksyQVNBPT0=?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: a1f6a0d5-bc5f-4dff-3ffc-08da61537d69
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2022 02:34:04.0107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZP286MB1371
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIEVyaWMuIE5vdyBJIGdldCB0aGUga2IgaXMgMTAwMCBiLCBhbmQgdGhlIGtpYiBpcyAx
MDI0IGIuCgpBY3R1YWxseSBJIGZpbmQgdGhlIHJlc3VsdCBvZiBwa3RnZW4gaXMgbW9yZSB0aGFu
IHRoZSBuaWMncyBwaHlzaWNhbCByYXRlIGR1cmluZyBteSB0ZXN0cy4gVGhlbiBJIG1hZGUgYSBm
ZXcgY2hhbmdlcyB0byBtYWtlIGl0IGNvbnNpc3RlbnQgd2l0aCByZWFsIHRyYWZmaWMuCgpUaGlz
IHBhdGNoIGlzIG9uZSB0cml2aWFsIG9mIHRob3NlIGNoYW5nZXMuIEl0IHNlZW1zIHRoaXMgb25l
IGlzbid0IHJpZ2h0Ckkgd2lsbCByZWZpbmUgb3RoZXIgY2hhbmdlcywgYW5kIGNvbW1pdCBhbm90
aGVyIHBhdGNoLiAKClRoYW5rIHlvdSBhZ2Fpbi4KCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KVG86IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4KRnJv
bSA6IGdmcmVlLndpbmRAb3V0bG9vay5jb20KY2M6IERhdmlkIE1pbGxlcjsgSmFrdWIgS2ljaW5z
a2k7IFBhb2xvIEFiZW5pOyBuZXRkZXY7IEdhbyBGZW5nCnN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0
XSBwa3RnZW46IEZpeCB0aGUgaW5hY2N1cmF0ZSBicHMgY2FsY3VsYXRpb24KCk9uIEZyaSwgSnVs
IDgsIDIwMjIgYXQgNToxNCBQTSA8Z2ZyZWUud2luZEBvdXRsb29rLmNvbT4gd3JvdGU6Cj4KPiBG
cm9tOiBHYW8gRmVuZyA8Z2ZyZWUud2luZEBnbWFpbC5jb20+Cj4KPiBUaGUgcHJpb3IgY29kZXMg
dXNlIDEwMDAwMDAgYXMgZGl2aXNvciB0byBjb252ZXJ0IHRvIHRoZSBNYnBzLiBCdXQgaXQgaXNu
J3QKPiBhY2N1cmF0ZSwgYmVjYXVzZSB0aGUgTklDIHVzZXMgMTAyNCoxMDI0IGZyb20gYnBzIHRv
IE1icHMuIFRoZSByZXN1bHQgb2YKPiB0aGUgY29kZXMgaXMgMS4wNSB0aW1lcyBhcyB0aGUgcmVh
bCB2YWx1ZSwgZXZlbiBpdCBtYXkgY2F1c2UgdGhlIHJlc3VsdCBpcwo+IG1vcmUgdGhhbiB0aGUg
bmljJ3MgcGh5c2ljYWwgcmF0ZS4KCgoxTWJpdCA9IDEsMDAwLDAwMCBiaXRzIHBlciBzZWNvbmQu
CgpodHRwczovL25hbTEyLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0
cHMlM0ElMkYlMkZlbi53aWtpcGVkaWEub3JnJTJGd2lraSUyRk1lZ2FiaXQmYW1wO2RhdGE9MDUl
N0MwMSU3QyU3Qzc5MWQ2ZDE4MTNlZDRhOGMxNzIwMDhkYTYwZmFlNWU0JTdDODRkZjllN2ZlOWY2
NDBhZmI0MzVhYWFhYWFhYWFhYWElN0MxJTdDMCU3QzYzNzkyODkyODAwNDM1MDM4NSU3Q1Vua25v
d24lN0NUV0ZwYkdac2IzZDhleUpXSWpvaU1DNHdMakF3TURBaUxDSlFJam9pVjJsdU16SWlMQ0pC
VGlJNklrMWhhV3dpTENKWFZDSTZNbjAlM0QlN0MzMDAwJTdDJTdDJTdDJmFtcDtzZGF0YT1OUGJZ
V3hDZkdpaHE1UkNmS0lIT0h0M29VcG9samMySmswdVNwcm5qRUY4JTNEJmFtcDtyZXNlcnZlZD0w
CgpDdXJyZW50IGNvZGUgaXMgcmlnaHQgSU1PLgoKPgo+IFNpZ25lZC1vZmYtYnk6IEdhbyBGZW5n
IDxnZnJlZS53aW5kQGdtYWlsLmNvbT4KPiAtLS0KPiAgbmV0L2NvcmUvcGt0Z2VuLmMgfCAyICst
Cj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQo+Cj4gZGlm
ZiAtLWdpdCBhL25ldC9jb3JlL3BrdGdlbi5jIGIvbmV0L2NvcmUvcGt0Z2VuLmMKPiBpbmRleCA4
NGI2MmNkN2JjNTcuLmU1Y2QzZGE2MzAzNSAxMDA2NDQKPiAtLS0gYS9uZXQvY29yZS9wa3RnZW4u
Ywo+ICsrKyBiL25ldC9jb3JlL3BrdGdlbi5jCj4gQEAgLTMzMDUsNyArMzMwNSw3IEBAIHN0YXRp
YyB2b2lkIHNob3dfcmVzdWx0cyhzdHJ1Y3QgcGt0Z2VuX2RldiAqcGt0X2RldiwgaW50IG5yX2Zy
YWdzKQo+ICAgICAgICAgfQo+Cj4gICAgICAgICBtYnBzID0gYnBzOwo+IC0gICAgICAgZG9fZGl2
KG1icHMsIDEwMDAwMDApOwo+ICsgICAgICAgZG9fZGl2KG1icHMsIDEwMjQgKiAxMDI0KTsKPiAg
ICAgICAgIHAgKz0gc3ByaW50ZihwLCAiICAlbGx1cHBzICVsbHVNYi9zZWMgKCVsbHVicHMpIGVy
cm9yczogJWxsdSIsCj4gICAgICAgICAgICAgICAgICAgICAgKHVuc2lnbmVkIGxvbmcgbG9uZylw
cHMsCj4gICAgICAgICAgICAgICAgICAgICAgKHVuc2lnbmVkIGxvbmcgbG9uZyltYnBzLAo+IC0t
Cj4gMi4yMC4xCj4K
