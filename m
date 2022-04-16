Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF28503636
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 13:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiDPLKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 07:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiDPLKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 07:10:01 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140098.outbound.protection.outlook.com [40.107.14.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729F6A8EC6
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 04:07:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gUNkMNZS/IEankVE30IgcpwgfWfKuTd0RAKqn+gJ1XM5lc6/ihFQWk7Awl5j7Egry+iJNc5YEOH0yE9e9Mcv3NGcJ2gR88JAWYTUvc/g0T+r8YsqSHq+cJZu6IHTnGmx7dG9xBmEw8Ii2fFF/ru1nbKbIjoa2rxjpY/n6KQozfByv7rcittPGhz0jrYRm4hYA7y5zonPqYl4RybH7t/dzkzeMgyHKdiNiX4hyFbgOeexbvraQorgVyEGQDXkQeuIlmx/BFAzkQWQ8iRpEBcEVS8XpXq+zHPy0gGB4bkzOXWE9yR5PT5BqZb/PyuLt/zF0+hD3gzn8L+wJucoVpMcjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Jf48gN1M8RUoo4bINAPVlh611KQoc8iQNwflxHat8M=;
 b=I3WMYPvB4x9JdpcDbDB8jlx8v6PGD5NMUKgkyv4i0ar7//5uI+ltB2ATOfCWzXiTqFKg4CXLrNCO6tqltTbQ2s7QVYqQUnX6yRDlUWW1T23uI46wzbjU5AZ0i6Z4SMcW3E5yrdBDDc4WhG9/DMGyojFq8Aw9jzV2KbOQRlWYj29x3UtCrjDwSfX8VPmlK69K9qqZU/v0DLeg/rPhr/XdG4yypLIOVo8LC45aHSl29GeVOrwbmFH/12q2h7/btTLIdkx7mmapXeci3uCeWJz9eHyxhZBxpbr/etrpLA6isZBmaideHU209SmYGCAVpLEg3Fmx8aSIr2AsG4JCg+a6mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Jf48gN1M8RUoo4bINAPVlh611KQoc8iQNwflxHat8M=;
 b=JmvNaOz0WVEnzxZJh3u8in7RKgD4wykwW13pxYEHvB/Y0/jPE1A6zrCUUSnAgiLrKLIOIS+mD/0Ck3GKz62x6XKWh6eF6a1wvf/boZkihonSgiP1jwu6f+0tJU9g7z23z0Z7vB/mQuYIaEeVhqWA7AIvSCcPKZEhMlassbIDNTQ=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by VI1PR0302MB2637.eurprd03.prod.outlook.com (2603:10a6:800:df::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Sat, 16 Apr
 2022 11:07:24 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82%3]) with mapi id 15.20.5164.020; Sat, 16 Apr 2022
 11:07:24 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net 2/2] net: dsa: realtek: remove realtek,rtl8367s string
Thread-Topic: [PATCH net 2/2] net: dsa: realtek: remove realtek,rtl8367s
 string
Thread-Index: AQHYUVrGcLWk0Ay/8ke6f3aeL4IEcazyYZcA
Date:   Sat, 16 Apr 2022 11:07:24 +0000
Message-ID: <20220416110724.4f33mudec5toyam2@bang-olufsen.dk>
References: <20220416062504.19005-1-luizluca@gmail.com>
 <20220416062504.19005-2-luizluca@gmail.com>
In-Reply-To: <20220416062504.19005-2-luizluca@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75d5634f-e610-47f9-d1d9-08da1f994941
x-ms-traffictypediagnostic: VI1PR0302MB2637:EE_
x-microsoft-antispam-prvs: <VI1PR0302MB2637F438914274D0D402E86F83F19@VI1PR0302MB2637.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TLVwDKo6uAe5VR8BBr+FliCI9M/XCsqZsv1/1BXASk8fbU7oaqXeVl+aa8KPRY/7RaZIozJAi+oammnldYDVpdvAMuw4zKpSGnnV0d8I+SE3C8cNFv7dMpFwF2oPbSnjc6sZObgp0b+igF59b1o5C/hJtRK5ms0kQuOXg6U4e6L2NwjMVQytGGpvtuwSOAcVSOUq9YhAC4aC1Aq1gk7aLJmDuUP2trNHpK7Ql/lpHODQ8jv5cghJ1DUyk8w+M59OZKyPsGZY8Tcfk/m0vO1A5eS6X5EMqsgdgwA1AhY47BlXLN7IG0KvT0Uz3ksOqarDG2w4FPRX4l5gP1qqALGMc6zizSpTJyXafT4tKBQ1sOtsvCVpu4c2JAjWtkGMC3DY4pPLcf9LRNKTooV6PG2EOcGupLUwpBarUxL0wpkOYUPMcFbZgFg1QbwBGD6GCTspmUkOWD+frZLi4T+elWh4f/cd03FftcWaP0fFlHuPZSXcYPaK1j9KNrrhT0LtrJQwOE3DrWjXCmyAnX+lmcF7hifMN4Tct/sBtr50ttXQRNjEZ25YH42zGtAM1+LlsmO4FvZkxYAoH4XRe9y/Y8dfvVlt0eASxJnyk90RDzxOzbjdtt38eBVire7ryKHTezwOQSTIMmytTVu+WD4H8L/5agLVJFwh8zXz6ZmFXw3mXRPhxdOJnoWlBnKCs65A21p2gfgkzYExYo9tGHkgYxVVdN7CEekJjl93kqeBrhWTvkmiVVCa+lXrVXv691ctCLsHb2GB7mYG0lNPfnVGrOMgZYseHYPIHoPZJzpN4KR4Vj4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(5660300002)(8936002)(38100700002)(7416002)(4326008)(8976002)(66946007)(966005)(38070700005)(26005)(54906003)(2616005)(6916009)(186003)(508600001)(71200400001)(6512007)(6506007)(66556008)(8676002)(66476007)(66446008)(6486002)(76116006)(64756008)(122000001)(83380400001)(91956017)(316002)(85202003)(86362001)(85182001)(2906002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b1VrM1JwQkIwODBQaTJMSHR0QVdraU9UeWVNSTBGNlBYLzErbE9sZUZIWlhx?=
 =?utf-8?B?Q0M5cEZGMSs5TXAxSTBUSG0wKzl1Y09TRWZTVEV2L2x6ajVvRFVob1llTXBX?=
 =?utf-8?B?SjFQUENZSmtFYnZVVkZPYXIxYzlJREIxb21jMFJWM2g0a25NY3A3T2ZTeHJp?=
 =?utf-8?B?Nyt0NW9HMDBhdjRLU0ZDS2IzNGJkOXJQYk45S2w5enBiZWpmbmJlbWdyK3NM?=
 =?utf-8?B?T0pCMG5YaENmQ0xZN3A4Wm50OHhCSkhVb1ZuYWk0TS9ZWXFWS3N0dHk5aTFG?=
 =?utf-8?B?ZzBGdFJ2ZGlwUkNlUTR3b3dUVVJsYm9XVC9Qam40NkVLaGgwUVdFSklJMXVE?=
 =?utf-8?B?eUtZeGpXQU02UDNMMnVCanB3aDNtWXpjOVkrU096eUsrbGUrVFdCNExTTWNK?=
 =?utf-8?B?K1Ryd0o2bWxWMmNqZEsvbitSSHllaGdzWTFjeU5tV0JWS1NxR1VTanIvYlBJ?=
 =?utf-8?B?S2paUWR1VEFkdFFVeU5TaFNQVHhpa3lTQm51TEdidTVzMTYwYVVaQ01MN1h4?=
 =?utf-8?B?QnhsWVhmRDhsK09nb0hrNnVPTi9UeEhXMktmdlZVSk9PN0ZtSWM5MjhHQVNU?=
 =?utf-8?B?VTRkNyt1eEZRTEY0THJubzJOM3p6UmVBN2pqbkxQdzFKTTlnOEZadVlLZHph?=
 =?utf-8?B?bWdPbnJpM29peldJSWFFcTc2TGdrR1AzNkFaOEt6dm1kdTlmVzkvQ1k1UTZa?=
 =?utf-8?B?S1pRNlhhaHVmdkpwZmNNY3VCQlZSSVBrQkhBVGxyTU5ZeTB3UWMyd3lPeUpL?=
 =?utf-8?B?YVZLNDhsZmVCZHd0eGF2aVpwaGdla2g1WHJDU1BOSHV2eWJHZ2xLWkx0NG5Z?=
 =?utf-8?B?T1FZVG8vUVB5T0NCRnVxUzBpUVpVVlhlSC9QaUl5T0NpK05tRFQ1MkFMN0tp?=
 =?utf-8?B?SnhDdVZrT3ZsbHFEUnNFcllDdnVCbHFzWi84aEYya1ZPeDZvd0RxRExTM3Y2?=
 =?utf-8?B?ZVJSWG1KWWRaWS9oVVNiNHcrTm5QaDBUNXJkQ0piM05vanJxc2l3TG4xQzBl?=
 =?utf-8?B?eDJGbFo0RjFkZVRJaUM5dExaWmc4UzZIQldWcjZtQ2M1d1JHUTUyMVh6SXRZ?=
 =?utf-8?B?TmdGcnZER08waGdhcFU4bXhYbEhxcnpxa3gzY296VXBFQjgrdmRxS05MM3o4?=
 =?utf-8?B?R1dZM2hjNitMVUViNHVhNlpscFFyTktmUk5QY3ZrSXVoVldKaVZoNWFzTGJU?=
 =?utf-8?B?Znc2YlBOT2JxUXAxVFAxNkR0Q0tsWmlxanhpSjdrMVE5R3l6R1pZMENvanRq?=
 =?utf-8?B?LzZ3dHp6WlNFVzVxUUkrb084aUlFZ3FWVC9ReGtJV0VmTGF6bGJKaEszenA1?=
 =?utf-8?B?Ri9xdXo2eGVlQThkZU5BblhXbHhqaDNDdytydHc0akZiblBKamgwU2RiSkNm?=
 =?utf-8?B?MVlqeWx3WjQrOTFTZ25qS0R1dVRKd2RMYW5NQzhTUitybzFmck5ub0RrVG1p?=
 =?utf-8?B?RGhZSkhNbmwrcWFhOE5HTWZYR1A5Y251UURRY2JSZTRrR2tBNnhNWHNPRFpk?=
 =?utf-8?B?S3dvaFd0ejdMWVZtd1NOWlFqS3I0ak5ZSWYwT0h1Rm41ai91ZlYxMjV5WEx6?=
 =?utf-8?B?VzNNekVocWhCOTNKTUg4K2xvV2dtc1doVHU0V0lIWDJqbTgzMEN1Tnc2Nkor?=
 =?utf-8?B?Y2Nnd0pPVjFtWHpYZXdFMHNFVGRYaHlNb2FjWi9qNnp4blNQeUNXYjh5bStr?=
 =?utf-8?B?NVBHdElzYjRWeWxFNFlMUzlxa2N4cXFidnlOcjd1TEYzSzR1NnZMUGYrZFNQ?=
 =?utf-8?B?NlpKYjRuWFJETzAvZEVTZkpFbDR1dXlSK0s5bVZHbUNRQmltMm5nbmc3anVR?=
 =?utf-8?B?Q1NKRm1OSWg1Ymh5czZPNFFTQ2tqdnZaK1BxWFJpbkt0NWdBMUNPVlVrdi8z?=
 =?utf-8?B?MlJWRnNvUCtYMUtRNGFkQU9xWmlzTnZUaUc5aVRWdUo4SE1zSEN3Rml6VG56?=
 =?utf-8?B?dC9RdnhCRWFMaDBrMWVJWm05OHRHc3ltVy9zYXpqdU5xYzdGbXhhRmNNUGQ5?=
 =?utf-8?B?YktZby8yUkNkUDdVeExDUlkrS3BZRzk0QVBqdThnUDJGMVdyMTRTT2VhSEJI?=
 =?utf-8?B?Vzh2Ni9XUnBHeHNHc1ZyWE53K3VqV3pyMzIxNlorNGRaRWp0N0tCZGdOVDlx?=
 =?utf-8?B?eWJHRk83ZzlTRUFLN1ZoYm9JZmxmR0FDNkdlSVZSVi80VTdjR00wcUJvcEVR?=
 =?utf-8?B?Mlo5bUhramlQSVlpYXNrWU5LUWRISkNWODMxQWRIOVQ2Ynlyd1BGdm9aNmcv?=
 =?utf-8?B?V09zNW1ubjBjcVdyMHV1aUg5a09LNStZTW5vQWlLMnAvMmFMR25sVnRJcUZB?=
 =?utf-8?B?MlBzeEkvTzFudDVoNGt4QUtEK3N6cVNhLzk2OWlXemlESnBGTVAzVmtxNm9X?=
 =?utf-8?Q?EVyqm2KtVBOorMIg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3FB5905813962041B2FF7F4B221B5087@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75d5634f-e610-47f9-d1d9-08da1f994941
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2022 11:07:24.5541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AusXDgc5A5vJC0aC2UYUZT6VCUFwcXtepCvZGVs71ttGaWUMkQFryGLoTTtcq4uSCmE7DfKlXuR2NN6zaFN8Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2637
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCBBcHIgMTYsIDIwMjIgYXQgMDM6MjU6MDRBTSAtMDMwMCwgTHVpeiBBbmdlbG8gRGFy
b3MgZGUgTHVjYSB3cm90ZToNCj4gVGhlcmUgaXMgbm8gbmVlZCB0byBhZGQgbmV3IGNvbXBhdGli
bGUgc3RyaW5ncyBmb3IgZWFjaCBuZXcgc3VwcG9ydGVkDQo+IGNoaXAgdmVyc2lvbi4gVGhlIGNv
bXBhdGlibGUgc3RyaW5nIGlzIHVzZWQgb25seSB0byBzZWxlY3QgdGhlIHN1YmRyaXZlcg0KPiAo
cnRsODM2NW1iLmMgb3IgcnRsODM2NnJiKS4gT25jZSBpbiB0aGUgc3ViZHJpdmVyLCBpdCB3aWxs
IGRldGVjdCB0aGUNCj4gY2hpcCBtb2RlbCBieSBpdHNlbGYsIGlnbm9yaW5nIHdoaWNoIGNvbXBh
dGlibGUgc3RyaW5nIHdhcyB1c2VkLg0KPiANCj4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvbmV0ZGV2LzIwMjIwNDE0MDE0MDU1Lm00d2Jtcjd0ZHo2aHNhM21AYmFuZy1vbHVmc2VuLmRr
Lw0KPiBTaWduZWQtb2ZmLWJ5OiBMdWl6IEFuZ2VsbyBEYXJvcyBkZSBMdWNhIDxsdWl6bHVjYUBn
bWFpbC5jb20+DQo+IC0tLQ0KDQpIaSBMdWl6LA0KDQpJIHRoaW5rIGl0J3MgZ3JlYXQgdGhhdCB5
b3UgaWRlbnRpZmllZCB0aGlzIGVhcmx5IGVub3VnaCB0byByZW1vdmUgdGhlDQpyZWR1bmRhbnQg
Y29tcGF0aWJsZSBzdHJpbmcgYmVmb3JlIGl0IGhpdHMgYW4gb2ZmaWNpYWwgcmVsZWFzZS4gTm93
IHdlDQpoYXZlIHdlbGwtZGVmaW5lZCBzZW1hbnRpY3MgcmVnYXJkaW5nIHRoZSBjb21wYXRpYmxl
IHN0cmluZ3MsIHdoaWNoIGlzDQpncmVhdCA6KQ0KDQpSZXZpZXdlZC1ieTogQWx2aW4g4pS8w6Fp
cHJhZ2EgPGFsc2lAYmFuZy1vbHVmc2VuLmRrPg0KDQo+ICBkcml2ZXJzL25ldC9kc2EvcmVhbHRl
ay9yZWFsdGVrLW1kaW8uYyB8IDEgLQ0KPiAgZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcmVhbHRl
ay1zbWkuYyAgfCA0IC0tLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgNSBkZWxldGlvbnMoLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLW1kaW8uYyBi
L2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3JlYWx0ZWstbWRpby5jDQo+IGluZGV4IDMxZTFmMTAw
ZTQ4ZS4uYzU4ZjQ5ZDU1OGQyIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRl
ay9yZWFsdGVrLW1kaW8uYw0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVr
LW1kaW8uYw0KPiBAQCAtMjY3LDcgKzI2Nyw2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgb2ZfZGV2
aWNlX2lkIHJlYWx0ZWtfbWRpb19vZl9tYXRjaFtdID0gew0KPiAgI2VuZGlmDQo+ICAjaWYgSVNf
RU5BQkxFRChDT05GSUdfTkVUX0RTQV9SRUFMVEVLX1JUTDgzNjVNQikNCj4gIAl7IC5jb21wYXRp
YmxlID0gInJlYWx0ZWsscnRsODM2NW1iIiwgLmRhdGEgPSAmcnRsODM2NW1iX3ZhcmlhbnQsIH0s
DQo+IC0JeyAuY29tcGF0aWJsZSA9ICJyZWFsdGVrLHJ0bDgzNjdzIiwgLmRhdGEgPSAmcnRsODM2
NW1iX3ZhcmlhbnQsIH0sDQo+ICAjZW5kaWYNCj4gIAl7IC8qIHNlbnRpbmVsICovIH0sDQo+ICB9
Ow0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcmVhbHRlay1zbWkuYyBi
L2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3JlYWx0ZWstc21pLmMNCj4gaW5kZXggNmNlYzU1OWM5
MGNlLi40NTk5MmY3OWVjOGQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVr
L3JlYWx0ZWstc21pLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcmVhbHRlay1z
bWkuYw0KPiBAQCAtNTUxLDEwICs1NTEsNiBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG9mX2Rldmlj
ZV9pZCByZWFsdGVrX3NtaV9vZl9tYXRjaFtdID0gew0KPiAgCQkuY29tcGF0aWJsZSA9ICJyZWFs
dGVrLHJ0bDgzNjVtYiIsDQo+ICAJCS5kYXRhID0gJnJ0bDgzNjVtYl92YXJpYW50LA0KPiAgCX0s
DQo+IC0Jew0KPiAtCQkuY29tcGF0aWJsZSA9ICJyZWFsdGVrLHJ0bDgzNjdzIiwNCj4gLQkJLmRh
dGEgPSAmcnRsODM2NW1iX3ZhcmlhbnQsDQo+IC0JfSwNCj4gICNlbmRpZg0KPiAgCXsgLyogc2Vu
dGluZWwgKi8gfSwNCj4gIH07DQo+IC0tIA0KPiAyLjM1LjENCj4=
