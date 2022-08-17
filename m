Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575ED596CFB
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 12:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbiHQKox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 06:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiHQKou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 06:44:50 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2109.outbound.protection.outlook.com [40.107.105.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961BA63F32;
        Wed, 17 Aug 2022 03:44:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B1Aj1jHEED+z1ZWU6oyH6x7VsedxLYDpxRFmeakgOeWDslv0BMo2Qd6TTNCSHV0Vu+DHvoasITmRC7SvKWQ7FVDtfiXrQhL3fdZtzM47sdVo93lTENHkfJQzxTEO+fUBBAsGUa/xgZXjA4/jNOLx8/pO0c8gkwzN9D9+P1lwzoaQ/khH4+c+tzT/woxEawCR7HytQeaYYG0G7Yg1tG38xJUZCcezZM63vdpe6wNSZA7/vI6WnC3zaOTgF5cWZV70kEYpMpob57UFtiU9oBqj/eJgdqIuojp/PC6fVw9msymUkvDuX2PC/u1AKQeOydBBvfGn9+eIpTjPX+5TKcRuxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=049QALEGnj3+HkCipPz3qgG0i5hg/RiwkwJWjG3RLwI=;
 b=F+zWt5Bsz63JOGpqQkDhnfJtFXKpYg+dXTqUamLRT5YNUUDQPLHFPVgLeZVuYCfQYztaLIz/OGD9Vc38UTd3UOu4LluaRj0ipVRRADDAHooCxQd74Zymm11Ol9koal6XRSZpm6DvC7I6QO5w2zRRUuTAYGls573i+kKpsoWaZqcAB1Kq64hmfPUmFPZ8IUq8/PkLgWjMh9OuH2vstorOpjfG4VGOxuPrlTGR+nHAcIpq7IrKGl3J3Wl+tPKqv2Ka4yCcn1CDlwhGEP1/iunNf2bNGjvHhbKlnx7tYy5sehQQqTNgsPTurrZpMlw8S/mDmsIvocf3QVD0IALd8v//gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=049QALEGnj3+HkCipPz3qgG0i5hg/RiwkwJWjG3RLwI=;
 b=tPrSEmRw3T+2DfiqVHvX4lU7Kg1Jzpp5q5le+1K8lrxEEBFTGYSOIO7Fp0RSz07PnowH1JinMa2im6u8KHv/+VIx1eCreQtyIqBZaUedLbRL2YgdA+R+HOsEXOpNCxboYOf6GMzwShFVb5QLxM6FF+/PeRkVFqEnZxOgSMwttEE=
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com (2603:10a6:803:75::30)
 by PA4PR03MB7071.eurprd03.prod.outlook.com (2603:10a6:102:ed::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Wed, 17 Aug
 2022 10:44:45 +0000
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::3965:8efc:7af6:756e]) by VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::3965:8efc:7af6:756e%7]) with mapi id 15.20.5482.016; Wed, 17 Aug 2022
 10:44:45 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Kalle Valo <kvalo@kernel.org>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wright Feng <wright.feng@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [1/6] wifi: brcmfmac: fix continuous 802.1x tx pending timeout
 error
Thread-Topic: [1/6] wifi: brcmfmac: fix continuous 802.1x tx pending timeout
 error
Thread-Index: AQHYrHzFRe0HAvutf0m8wUpKE1fIQ62yz18AgAAjnMmAAADFgA==
Date:   Wed, 17 Aug 2022 10:44:45 +0000
Message-ID: <20220817104445.ji75o6ibduz2ndjk@bang-olufsen.dk>
References: <20220722115632.620681-2-alvin@pqrs.dk>
 <166011047689.24475.5790257380580454361.kvalo@kernel.org>
 <20220817083432.wgkhhtihtv7wdwoq@bang-olufsen.dk> <871qtfm9sk.fsf@kernel.org>
In-Reply-To: <871qtfm9sk.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8e0b14f-d8f7-4f62-502d-08da803d8036
x-ms-traffictypediagnostic: PA4PR03MB7071:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: twx6Bc6kaD6OdcsvMRgzE4bKqxIHwJ+6rHMGPuwAh/yNHTI8kxCmsyBPdH7AbcFSWZsmXrYDxqG3YI6TfJe6YlzxB0CeW4guWPwn7HtotuHjIaPEbGK8DQDd1VEA2s5gpaxAOcA4qsLo2Sajkj+q7Nvh5tn5N+cxi7phNfkRPt3EpwarsGHUpT0S1je4injfDg1latWOUAlt9PCxAqh8wloLxNK4j5F68cy6J6lcywkgavWzThv19lJoG34p6HHOwd9EbQSaEo/8WmodFix+Gc8P4xJabM7D5xrUmMxMNfrOTNIuZKeb5Qa+TDiG9+40vb8ZYbArWhcR2yrMLzkhiQZKb4AYdJ8wk22MZgp7zPylsweZL5EC/0JWyizghhVtTHLZv5KruAO8IkIHrtgmhqgVYdmH5lGo/Pce3fWpQz2BuqA5YM/GglqR5ykDoiQdq9WoIa7j7n9wpY6ytUA6csv6+YbcdPn6Ud0nYvdsrK4+d/SAi0wHV+GWdgYIXLs9AEFYA4dxBoKo2/iaHs/JorQedO1I5cFFYxl2ZKQJHgLcQ12pdslxpwIwkB9Npxb7H3W4p3fRx24gxFc2I6dkhP44WGkRu9LOiDezXb+9bBdzF0RjI38hVVYnAzt8A4JVldCeGx+YxRzmH3MusyvMi/7ChmQKCZUSvJZAs7VKTMhvQATY/zKeI0xiaS//ngclru04y3lqslxz8iEZqb0MMTdPPpLhCJxh9ck7mgCf8rgAbDFNbCUY2/HwA2yNRzOvHCAsuSDT9tU6f5NoL/mMZK5Jeuhs2oSGejiwT9oqwgii4Dj7sLgrZok4nL4aYR61
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB3950.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(39850400004)(136003)(346002)(376002)(38070700005)(38100700002)(64756008)(8676002)(4326008)(91956017)(66446008)(66946007)(66556008)(66476007)(76116006)(36756003)(85202003)(85182001)(54906003)(6916009)(122000001)(86362001)(66574015)(1076003)(26005)(83380400001)(6512007)(478600001)(71200400001)(6506007)(41300700001)(6486002)(316002)(186003)(2906002)(5660300002)(2616005)(7416002)(8976002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RnZwMU83cTNOcjlSMzNwWWc1ZWliOGVvbkpmV1lHMVhtV3ZZdlpIUVI5Vy94?=
 =?utf-8?B?R29heTA1Q2FLZlRYc2NoMWpybmQ1dHZxZXVZNmlqV2ZSSzAxaXdwK1ZMMGVz?=
 =?utf-8?B?SnIzMVJFOUxHSzN5YzNzaXAxdEdCK1dvRGtrWklrZjNBYnFDMmF2NWdPYWo1?=
 =?utf-8?B?MTNPVkxNVlpuZHpxK2NJeWZBQTBrd3RRamNVWWNwVGFLOXY1SlQ0LzlNRUpH?=
 =?utf-8?B?M1g0MWxWNUsyNUVXdm9ZRlVNVUFDSjJiWGlLcHRnVkx1T29OR0tML3RDdllm?=
 =?utf-8?B?eGRaKzZ0MEJheStBakNRVEZTZE9BUFRsamc3TGorMHBrWXExQ1lVd2VXTjhj?=
 =?utf-8?B?NG5rYWYxSkRic2pEbjllWnNZSUF5Rks5MHBRcGFGK2U2YXZlMFliYzB1TVkz?=
 =?utf-8?B?K3hSMkZYblVod3NmbUNqWGRJSWtzc2N6S1FHalpvZUJTWVNyV2pVSjlnNmo3?=
 =?utf-8?B?YXhORGdqTjBLNjkvUnRxZy92UzVNUlRsNmw5S2NmaGpkOXkwZkIyNzVZQ2dU?=
 =?utf-8?B?ZjZsVVY1dTUrVGtiZ3FCRWcrYnVZL1BrNWoxY1dyelZDbXp5TXZjRjRwQ3dy?=
 =?utf-8?B?MWs2eVNJMlhVWlZHOG5rWVJvbmc3RDFvZEZKcWtwdUVxUUQ4b3VYWUd1L2d5?=
 =?utf-8?B?UEY4aXRPcUZRT0lJRzM1WWtrVHU2cjV2S0ZoQitKTkViaDRXaDFQSmJzU1BF?=
 =?utf-8?B?MjdTNTRDaTJEa0U1UGcwQ3doZC83Q3BzelVLbG9WaXZud2R0VHpVL0tGZklT?=
 =?utf-8?B?Mll2UGJ0VnUrbDByVThGWmZZby8wMjNyVTI3RENwSkJtYmdoWS9GNW9lcWMw?=
 =?utf-8?B?UTc1UXdmMHl1b1dCTzRsUGU2d1RGMUVjWTRYbm82eHJyVVREYjhLU3dDbHJG?=
 =?utf-8?B?U3pSOTBlVmFtV2I1RFROcGEwWEhLd0NsV1FlVFBObVVUQ2tkNU9ZZDZ3aUtt?=
 =?utf-8?B?c3FTNTVhNm5UUjdCWFN6Z2ZHcWJDYXErZkE4Y2FFWGZoamJxQjZYZUw5NmRL?=
 =?utf-8?B?dmtYYk9LQkFEeVVYR3JqOW5iNTJweUFBZmZrWkxvcjRoNHpHaDM1NmZpWE8v?=
 =?utf-8?B?ZGp4UElsNTFkN1JXbWtQcGtDYVp2RVB1S0labVZRSnh6di91TVNVajVEa1I5?=
 =?utf-8?B?K2ZSUnF5NnhOaDF1YzU0SVRibTgwNXJzVmk4TTU1M0dnVi9seFZoWTRvTi92?=
 =?utf-8?B?ZksrNW12RlAwZ1VTK3ZWRytSWHllYkFLWVJESmY0dmRrSjd6UW5hMkd2V2Q2?=
 =?utf-8?B?Q3NOTks3M0NEWnZieW03RGEvZXl0SzJjNkpZSHRrSlBIaXZJb3hyc1MvaHp0?=
 =?utf-8?B?d3E1Z0dycEVOMnFuY3R4b3dxbVJqWnk1T0pUbFhXUmpONTN2amdxUEFKdnJi?=
 =?utf-8?B?a0NmNnNIQS8vMjdPcmxqYk5JdURCblJ3Y252RENod2xFRXlnVkJjVnhEOFVI?=
 =?utf-8?B?U3d6QlFQM01hc2d6SUdLOHFTRDY1R1VuR0haaUkrVm9rSHhFQzZiT1YrSy9t?=
 =?utf-8?B?TFN4a2xTL3M5WkZpSDBDckcvMXU5cDVBNHp6d0MzZklHdzNsSVZ0ejRsbjc0?=
 =?utf-8?B?NE5qR3R5RUFEanU5VHViNk9od1lmZVlwdEhLTHI1UHN1aUM5aXJIb0ZHZ0pa?=
 =?utf-8?B?dm5JNTZlQ2NmSkVJQnNiYU1BbndPZ1ZBb2xiWiswb3l0NWpqUmZJR0s0Sk9i?=
 =?utf-8?B?d3FIbVlUSWZWWkxmbUJzVzFBQ1VNVDRwWjgyN3d6aGt2c0Ezd0VoNk9wc3Nw?=
 =?utf-8?B?SGlQV2g3Y3RDZzZtWHBFM3lsdFVOTkdSbk9Qc3ViVTdrTEtHdm1WaFBPTVZR?=
 =?utf-8?B?OVcyRWFHT0lyRmhrWk52Tis3eGUwdFlORTRLVW5FSUtGRW1WR1BZbkpkWFZu?=
 =?utf-8?B?dFBIcTFaOHQvQlkvSlBBbU9IbjhOUmVxemwxei9BN3NCU1F1SHRQNnhtMGlT?=
 =?utf-8?B?OWNNTFM0WmhoVDR4cG9sZEVQd3VVYW9BUkpNT2VZcmtBNnpSSUl4VWRuVTRL?=
 =?utf-8?B?bVN5UTNiVU5EWHpPV2hxYXdvbTgyR3RkSEE2b0ZFZE1HUjFnd0Vqc2dnWU1E?=
 =?utf-8?B?OEtzaWdaQkZ0MHQ1REtXVnQ2RWpVYzFqQWgzMElZVkh5YkttaFMwWnZUK3Yr?=
 =?utf-8?B?eXF0akdUZHlDM1Z0dm9CaDhuenJtVWhRcXg2dEJpN0V5UmlkSXJSSlBUWi8w?=
 =?utf-8?B?M2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9F5DCD3CD78754C93690EC14A29BA2A@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB3950.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8e0b14f-d8f7-4f62-502d-08da803d8036
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 10:44:45.8281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AOqOYPkPvbgb7JGlJo8xJcpghkGe3AzPQYCcTk+IIn5QE76jkQ0ZDV+m5hCO7LuSvmn5C4ihqLja9B1IA+Rlfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7071
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBBdWcgMTcsIDIwMjIgYXQgMDE6NDE6NDdQTSArMDMwMCwgS2FsbGUgVmFsbyB3cm90
ZToNCj4gQWx2aW4gxaBpcHJhZ2EgPEFMU0lAYmFuZy1vbHVmc2VuLmRrPiB3cml0ZXM6DQo+IA0K
PiA+IEhpIEthbGxlLA0KPiA+DQo+ID4gT24gV2VkLCBBdWcgMTAsIDIwMjIgYXQgMDU6NDg6MDFB
TSArMDAwMCwgS2FsbGUgVmFsbyB3cm90ZToNCj4gPj4gQWx2aW4gxaBpcHJhZ2EgPGFsdmluQHBx
cnMuZGs+IHdyb3RlOg0KPiA+PiANCj4gPj4gPiBGcm9tOiBXcmlnaHQgRmVuZyA8d3JpZ2h0LmZl
bmdAY3lwcmVzcy5jb20+DQo+ID4+ID4gDQo+ID4+ID4gVGhlIHJhY2UgY29uZGl0aW9uIGluIGJy
Y21mX21zZ2J1Zl90eGZsb3cgYW5kIGJyY21mX21zZ2J1Zl9kZWxldGVfZmxvd3JpbmcNCj4gPj4g
PiBtYWtlcyB0eF9tc2doZHIgd3JpdGluZyBhZnRlciBicmNtZl9tc2didWZfcmVtb3ZlX2Zsb3dy
aW5nLiBIb3N0DQo+ID4+ID4gZHJpdmVyIHNob3VsZCBkZWxldGUgZmxvd3JpbmcgYWZ0ZXIgdHhm
bG93IGNvbXBsZXRlIGFuZCBhbGwgdHhzdGF0dXMgYmFjaywNCj4gPj4gPiBvciBwZW5kXzgwMjF4
X2NudCB3aWxsIG5ldmVyIGJlIHplcm8gYW5kIGNhdXNlIGV2ZXJ5IGNvbm5lY3Rpb24gOTUwDQo+
ID4+ID4gbWlsbGlzZWNvbmRzKE1BWF9XQUlUX0ZPUl84MDIxWF9UWCkgZGVsYXkuDQo+ID4+ID4g
DQo+ID4+ID4gU2lnbmVkLW9mZi1ieTogV3JpZ2h0IEZlbmcgPHdyaWdodC5mZW5nQGN5cHJlc3Mu
Y29tPg0KPiA+PiA+IFNpZ25lZC1vZmYtYnk6IENoaS1oc2llbiBMaW4gPGNoaS1oc2llbi5saW5A
Y3lwcmVzcy5jb20+DQo+ID4+ID4gU2lnbmVkLW9mZi1ieTogQWhtYWQgRmF0b3VtIDxhLmZhdG91
bUBwZW5ndXRyb25peC5kZT4NCj4gPj4gPiBTaWduZWQtb2ZmLWJ5OiBBbHZpbiDFoGlwcmFnYSA8
YWxzaUBiYW5nLW9sdWZzZW4uZGs+DQo+ID4+IA0KPiA+PiA1IHBhdGNoZXMgYXBwbGllZCB0byB3
aXJlbGVzcy1uZXh0LmdpdCwgdGhhbmtzLg0KPiA+PiANCj4gPj4gMGZhMjQxOTZlNDI1IHdpZmk6
IGJyY21mbWFjOiBmaXggY29udGludW91cyA4MDIuMXggdHggcGVuZGluZyB0aW1lb3V0IGVycm9y
DQo+ID4+IDA5YmU3NTQ2YTYwMiB3aWZpOiBicmNtZm1hYzogZml4IHNjaGVkdWxpbmcgd2hpbGUg
YXRvbWljIGlzc3VlIHdoZW4NCj4gPj4gZGVsZXRpbmcgZmxvd3JpbmcNCj4gPj4gYWE2NjZiNjhl
NzNmIHdpZmk6IGJyY21mbWFjOiBmaXggaW52YWxpZCBhZGRyZXNzIGFjY2VzcyB3aGVuIGVuYWJs
aW5nIFNDQU4gbG9nIGxldmVsDQo+ID4+IDU2MDZhZWFhZDAxZSB3aWZpOiBicmNtZm1hYzogRml4
IHRvIGFkZCBicmNtZl9jbGVhcl9hc3NvY19pZXMgd2hlbiBybW1vZA0KPiA+PiAyZWVlM2RiNzg0
YTAgd2lmaTogYnJjbWZtYWM6IEZpeCB0byBhZGQgc2tiIGZyZWUgZm9yIFRJTSB1cGRhdGUgaW5m
bw0KPiA+PiB3aGVuIHR4IGlzIGNvbXBsZXRlZA0KPiA+DQo+ID4gVGhhbmtzLiBEbyB5b3UgbWlu
ZCBlbGFib3JhdGluZyBvbiB3aHkgdGhlIDZ0aCBwYXRjaDoNCj4gPg0KPiA+ICAgICBicmNtZm1h
YzogVXBkYXRlIFNTSUQgb2YgaGlkZGVuIEFQIHdoaWxlIGluZm9ybWluZyBpdHMgYnNzIHRvIGNm
ZzgwMjExIGxheWVyDQo+ID4NCj4gPiB3YXMgbm90IGFwcGxpZWQ/DQo+IA0KPiBCZWNhdXNlIG9m
IG1pc21hdGNoIGJldHdlZW4gRnJvbSBhbmQgcy1vLWIuIEkgd2lsbCBsb29rIGF0IHRoYXQgaW4N
Cj4gZGV0YWlsIGFmdGVyIG15IHZhY2F0aW9uLg0KDQpPSywgdGhhbmtzLiBGWUkgU3llZCBoYXMg
bGVmdCBJbmZpbmVvbiAtIG5vdCBzdXJlIHdoYXQgaGlzIG5ldyBlbWFpbCBpcy4uLg==
