Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D58596B77
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 10:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbiHQIem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 04:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiHQIek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 04:34:40 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2131.outbound.protection.outlook.com [40.107.22.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809C6543D5;
        Wed, 17 Aug 2022 01:34:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YBVXMcQx3nDX/WxEbZYrt59NoSkL2GNZRrXIcK3FX7ADOLtzbe+sZMd5j81SGxANxXZErMxxfX3VMIsgYJk8c3ORHO5WfvFIfUbcVMSX6w5QDktCV1KEDk9+EjV+J4giniTtJ3m2aYYkyWQgwHx/2nV70AxbwhDT1OZYUtO/XzBNEMsiHQjhdp1vCEgpsNTqll7+4pQZH82vGmW1pEjYWXUHMcYFDJjInXztDY4DwiUmxe+ski3cahLNJAniq4wxQ/cs/uIyFBjJHY4BeMycsdEFNo2n7Ej/egv0WynW8yp0qLoydSxEsJu/q2dQrI6jAI/ue0yDqHtidbPGE9qTRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CRpP9A7WkTA44ZfZMSDCtUxR+5BZ7uMqXZDba1S8AaI=;
 b=A7yOyp+qISogM9qYPYHg0G+nic/8U5ArL3ZGp/o69pijVSF1PLiOxWkP5zyg752qSkfVNi8flT5P51htKjcnDhoHLJRekQUwQL2boP36d3v+jl6ubQKSKzIOduBnUVWJcQUOgjEQTV52z/9VvkNgVhPED2T8FGYXfavkHWKABX3R9LjrSlQU1P4nE4fV9cJdu3JpxorKu2d6RI7ck7ceRGLjyko6/kdkr4wOqE05S8BOygKzcT70FfLs3LYip99jDWS1MRLLXgFkI9pLKovqurnNqY1xIDxu2DpYPjeLAb2vkk/n/85s7rBgJYe2JSUTsGmTiqFfYbnyVCg7U6GOlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRpP9A7WkTA44ZfZMSDCtUxR+5BZ7uMqXZDba1S8AaI=;
 b=HRaXoxLMdh/TmGH17SILw4tWsWqGOd1WSGGH6HSiHz/FyhLj1AtF5tRGSffdY+UHKEnfZoIaolTkl0a4WCFyaMxYeNzE0fCuNwvr56bvqHKlVsdvKAj/IpiM7JZiEUN/nT6bffuq4tPChRcR/qVWqr9vQYAj5ZcvMHHq4yi0c9Q=
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com (2603:10a6:803:75::30)
 by AM0PR03MB4916.eurprd03.prod.outlook.com (2603:10a6:208:10a::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Wed, 17 Aug
 2022 08:34:34 +0000
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::3965:8efc:7af6:756e]) by VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::3965:8efc:7af6:756e%7]) with mapi id 15.20.5482.016; Wed, 17 Aug 2022
 08:34:32 +0000
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
Thread-Index: AQHYrHzFRe0HAvutf0m8wUpKE1fIQ62yz18A
Date:   Wed, 17 Aug 2022 08:34:32 +0000
Message-ID: <20220817083432.wgkhhtihtv7wdwoq@bang-olufsen.dk>
References: <20220722115632.620681-2-alvin@pqrs.dk>
 <166011047689.24475.5790257380580454361.kvalo@kernel.org>
In-Reply-To: <166011047689.24475.5790257380580454361.kvalo@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be11f3b6-e56c-40a5-84cc-08da802b4f45
x-ms-traffictypediagnostic: AM0PR03MB4916:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qE1WtOnxvp1vDCih3H15sQYk0DvjDYyb5wD7D32aSo0n5JX/Liu9r0pO+wOaxogPmL7a0KRhH1oEcg5JrpLeic2tKxZQghl8WbOFlKqIhZSEmG9QQNHZewzZb9KMEisviwU/FF0U0QS8vlIlXkEtKTwO6ZKrRIb1EUbAG+CoOojabGus4BsVThhdYK4RmxexQW2mSBblHUA7E8Fztw6nxVNAr2PmN3zPj+Q2n4WMfV5fjh4RLjJvtDH78iaGK/1Dd5O3cVBWnDVL3Vhg55Lo0JJd3wdM7+YbHO1oWvZ9V2bcLjNcdzvl5KDZpQWMoJBrCcfg8al4/JUjk3ZK53FrWjvjTrVqNJ/S8hCkUC4vHxImNIDyUVSKRBq99BupH1QN+ob11aLfHNLSwko5Inwfh338CqHdECWufbXCPRDn9r6B/5lCDaKBo9hhHlJuC/fF0u4wIlnnpSX1W8MFX0h7+0AlbfBNVZ9i8GXv482bKMpyatL44whv8YAeh7+n+SI/mclhXN0Fas9etUY86Tx0SBDQhRErq/1pPqls1+FlhfsoJ57GRlUtGBN/oyDHXhwzCAbgON/iiLZgSrszYFaRGJn2VW9jGGe/iKLfG0K3fb3Gs/jTaYXUZuvEWzBpieUJG7c/GVZ7UdPu57Ox79r/cqRBCF/cQ71xSIe5TNe7+mQYSiC4rmNEh/xuokj4FI3Ebkwp2YJKDBA6bdZZuSZG4jeOo2vY13arF+xqUU0EwW47NJZfFWKdot83FcD1OoNmpnBF2W0Y1/u3nh/8e6YBSkswQ7sy4HfMyrYicJxXbgxVPL3CHah5bfsIf7U4PDkh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB3950.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(6512007)(2906002)(2616005)(85182001)(1076003)(85202003)(7416002)(478600001)(5660300002)(41300700001)(6506007)(186003)(36756003)(26005)(8936002)(8976002)(66574015)(38070700005)(83380400001)(76116006)(91956017)(38100700002)(86362001)(6916009)(122000001)(66556008)(64756008)(4326008)(8676002)(66946007)(66476007)(316002)(54906003)(6486002)(66446008)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUgrUVMzbVpZUWFvbXVTYzBhNkR5ZG1xZjNqNDZEd20rTHVUZzQ1UWZMN2Rm?=
 =?utf-8?B?ZlRZZG53QWNZK2REbHZFNmRxK1F1bzRwTldHTUJGWGtGNm85NWxPQWFDUGJp?=
 =?utf-8?B?aHZyTUpRQndWNmwvazdFdU14Yy9US1phdE9XVnlxQWdvTkFvZkxlUjdqUVQ0?=
 =?utf-8?B?ZFc2OVVsakgyY21nWFB0QWJvc1E4eGwwaXA2Vnd3Wmo3YVJyZ2E2QTRnd2NS?=
 =?utf-8?B?Qm8wVjZRdStxVnZqclRzKzQyL2YzUndSY3Z4SFhwSFdhdTVQS1JWMFhUbGhL?=
 =?utf-8?B?WUxWZlUrV04zd1p1c2gwZ20rN1NHMldtanNmWHN3cmEzZ2w1OFJPbTVNbkZN?=
 =?utf-8?B?K0hYdXNvbkRraWtFaWZBVHhLcUtxOFhIT05WSVlHZnJJdU1sVStKUEdGN0xR?=
 =?utf-8?B?b21JelBzTUlZSjJrT2RnYitveSsreXlDelAwN3NuYnQ2OTRsUitMNFhZd000?=
 =?utf-8?B?TEdWZWxQcy9xWHpmWDFzNnNzYXBvS2kwWWptc3VhUnBYa3YzNEVzcnl6WkFD?=
 =?utf-8?B?aXhiTDFsbXRHSUdHeC9zTEJkMFFGQ3VYc01HWE9WZFpzbjNLa3B0blpjWFdZ?=
 =?utf-8?B?dUxnLytTVE1SNzJyK1FCWHo3KytaTzlxOFJjdE56MWptZHYzMnFmSk9IL1pH?=
 =?utf-8?B?NHJ2NFFPcEczaThGbHdaVU8xN0dpWkFhZmVEUHJjRDFpeUgyR081cWVJL3Z2?=
 =?utf-8?B?S21KNGxmNHBjOGxQVHlqUDd0blh2bytoVFdockpkTjVaeGZWVDlMQTlqR21t?=
 =?utf-8?B?eTVaWnhrT2JTVUZyQ1ArZ0NIY3NUSWdDaWFjTXI5dEFPZ25DSzR1T3Bxbk1Q?=
 =?utf-8?B?aW84UGJCSk5uSjJmWTV0VkFwV1NXOG5xaFZzakhEWExMc2kwOTN2NEdiOHRm?=
 =?utf-8?B?U3NFQkx5OFdJeVJNS0V4N0VQVEhsQmRqTXNvUHk4ZXNuYUFYVHowZGlzOGRx?=
 =?utf-8?B?NWJkWTQ5a1FJVDBaNWdHVTZWMEo1UDJpTHM4N09YeW1kMFJNTkFSdnVyR3Fj?=
 =?utf-8?B?NzJMWU8yQyt5MGd5Zm1iWmdTbm5kWTNNTW9tTWJKMDQwR1NVakY4TU8zUUYr?=
 =?utf-8?B?alhNaXIxRE1ydlRhT1JINitGT0RrNldNaFBpVWErNmRqamJza25DNmdBcXJr?=
 =?utf-8?B?YUN0MlZDUjdpRmtRelc2RndCWDNRdzhDRWMwR3hsUjRQYVpDWnVXdEVxQzUy?=
 =?utf-8?B?ZmwzaXFlUkM3SUszUFowcmVSQmFieWIyM1hMOXhhOU1JZGFDUnIvTGhMUm1C?=
 =?utf-8?B?dUVKWVFuYmIrT1dzK2xGSXpxcVJlM3BSd1R4a25UaDBuRExhRTJxckhtYitk?=
 =?utf-8?B?eEN3RlpzWHdFb0kzaUo2b1lpbnBzRVJNR2pXRnJCVXFrUkVGMXYvaWU2WDdw?=
 =?utf-8?B?ZDNSNEMrNlEzOHdTYzl1czdNdWNZZzR2MFR4ZlB6cm51d0RnM2w4SFdqdGRt?=
 =?utf-8?B?Y2hDdlFuVjJuR1QxRWVJbXBJQ2N1Yktva3BsRnpNMFlXQWg2cGVNZ2xac25K?=
 =?utf-8?B?eld0b0JleTVsUVNmeW96S3NJM0Fuc0ExVHBGeng0WXJnbllPRlk0S0tYWm5C?=
 =?utf-8?B?SThTR2VMc2NLT2xvK21pVEVZbnFQMFlUZGNRZk96d1BpTk5US2JpRkVOaHBI?=
 =?utf-8?B?Yjd6MnZlKzU3TDFVVkFIemNkNUFIcWhjakttQWJaVXkrRTF1RWtBTHdRaTdl?=
 =?utf-8?B?emo4anNuc3hYdjcyU1lyNzAwUkpUdFBEM3F0UDd6c0VFcEtvTVBTTkJLUnNv?=
 =?utf-8?B?VTREdjhMV2NraG5za2ZUeGc3QkxubDBhZFhkb2drQkI5S2gxd3NOZ2NLb2Z1?=
 =?utf-8?B?Ly9URmUyWjIzRStXVmdpVFNwQWJlellkbXlGc2dLdG0yRVdlc2tubTB5dFZT?=
 =?utf-8?B?eGtaczg3QXNBYThHT1ZDSlNBTWxoUGdFcHhnOW1NSHJKWkVid2YzeS9FZVNJ?=
 =?utf-8?B?dDlPdnRaRnE4TEh3Q29la2ZkQWNaODFKZmlDSjVqN3l3MnFJWEpWbjdkS1Mr?=
 =?utf-8?B?L3ZrQzBrdTNiUEVuWFNUMVlXNXgramtyenpRazJpZHVYY0VkZGhiYmdUdlhP?=
 =?utf-8?B?TEVTM3pLS0tsS2UyREJuK1NQSVhkVk40SzIwdDdsOUoxYkdnclIyUERDNTA4?=
 =?utf-8?B?K1YrUmhITmJqQjUxMm84SVFsY1VCNStIQW9JVVROcjJNVm0xdVpNWktCdEZQ?=
 =?utf-8?B?c3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <79F04E08967CD349B3A43E56AF11C27E@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB3950.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be11f3b6-e56c-40a5-84cc-08da802b4f45
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 08:34:32.7939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X1hM/2xjnIGOec1ZtEF9lJ830IuCJugFAzjawuz23zzSTJj6aX3By5GlW8l9gbXxyIXEknJ8lK/A7IBBoJ7isA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB4916
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgS2FsbGUsDQoNCk9uIFdlZCwgQXVnIDEwLCAyMDIyIGF0IDA1OjQ4OjAxQU0gKzAwMDAsIEth
bGxlIFZhbG8gd3JvdGU6DQo+IEFsdmluIMWgaXByYWdhIDxhbHZpbkBwcXJzLmRrPiB3cm90ZToN
Cj4gDQo+ID4gRnJvbTogV3JpZ2h0IEZlbmcgPHdyaWdodC5mZW5nQGN5cHJlc3MuY29tPg0KPiA+
IA0KPiA+IFRoZSByYWNlIGNvbmRpdGlvbiBpbiBicmNtZl9tc2didWZfdHhmbG93IGFuZCBicmNt
Zl9tc2didWZfZGVsZXRlX2Zsb3dyaW5nDQo+ID4gbWFrZXMgdHhfbXNnaGRyIHdyaXRpbmcgYWZ0
ZXIgYnJjbWZfbXNnYnVmX3JlbW92ZV9mbG93cmluZy4gSG9zdA0KPiA+IGRyaXZlciBzaG91bGQg
ZGVsZXRlIGZsb3dyaW5nIGFmdGVyIHR4ZmxvdyBjb21wbGV0ZSBhbmQgYWxsIHR4c3RhdHVzIGJh
Y2ssDQo+ID4gb3IgcGVuZF84MDIxeF9jbnQgd2lsbCBuZXZlciBiZSB6ZXJvIGFuZCBjYXVzZSBl
dmVyeSBjb25uZWN0aW9uIDk1MA0KPiA+IG1pbGxpc2Vjb25kcyhNQVhfV0FJVF9GT1JfODAyMVhf
VFgpIGRlbGF5Lg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFdyaWdodCBGZW5nIDx3cmlnaHQu
ZmVuZ0BjeXByZXNzLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBDaGktaHNpZW4gTGluIDxjaGkt
aHNpZW4ubGluQGN5cHJlc3MuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEFobWFkIEZhdG91bSA8
YS5mYXRvdW1AcGVuZ3V0cm9uaXguZGU+DQo+ID4gU2lnbmVkLW9mZi1ieTogQWx2aW4gxaBpcHJh
Z2EgPGFsc2lAYmFuZy1vbHVmc2VuLmRrPg0KPiANCj4gNSBwYXRjaGVzIGFwcGxpZWQgdG8gd2ly
ZWxlc3MtbmV4dC5naXQsIHRoYW5rcy4NCj4gDQo+IDBmYTI0MTk2ZTQyNSB3aWZpOiBicmNtZm1h
YzogZml4IGNvbnRpbnVvdXMgODAyLjF4IHR4IHBlbmRpbmcgdGltZW91dCBlcnJvcg0KPiAwOWJl
NzU0NmE2MDIgd2lmaTogYnJjbWZtYWM6IGZpeCBzY2hlZHVsaW5nIHdoaWxlIGF0b21pYyBpc3N1
ZSB3aGVuIGRlbGV0aW5nIGZsb3dyaW5nDQo+IGFhNjY2YjY4ZTczZiB3aWZpOiBicmNtZm1hYzog
Zml4IGludmFsaWQgYWRkcmVzcyBhY2Nlc3Mgd2hlbiBlbmFibGluZyBTQ0FOIGxvZyBsZXZlbA0K
PiA1NjA2YWVhYWQwMWUgd2lmaTogYnJjbWZtYWM6IEZpeCB0byBhZGQgYnJjbWZfY2xlYXJfYXNz
b2NfaWVzIHdoZW4gcm1tb2QNCj4gMmVlZTNkYjc4NGEwIHdpZmk6IGJyY21mbWFjOiBGaXggdG8g
YWRkIHNrYiBmcmVlIGZvciBUSU0gdXBkYXRlIGluZm8gd2hlbiB0eCBpcyBjb21wbGV0ZWQNCg0K
VGhhbmtzLiBEbyB5b3UgbWluZCBlbGFib3JhdGluZyBvbiB3aHkgdGhlIDZ0aCBwYXRjaDoNCg0K
ICAgIGJyY21mbWFjOiBVcGRhdGUgU1NJRCBvZiBoaWRkZW4gQVAgd2hpbGUgaW5mb3JtaW5nIGl0
cyBic3MgdG8gY2ZnODAyMTEgbGF5ZXINCg0Kd2FzIG5vdCBhcHBsaWVkPw0KDQpLaW5kIHJlZ2Fy
ZHMsDQpBbHZpbg==
