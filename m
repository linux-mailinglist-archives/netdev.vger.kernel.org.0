Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF43C56092C
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 20:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiF2Sbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 14:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiF2Sbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 14:31:41 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70137.outbound.protection.outlook.com [40.107.7.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC503BA44
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 11:31:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KBAYwdbH2KwKAhwg3h+bH6mRrmEkOF9fMKGZrSZWGq1nat/1odBrYRcbSkpzYCB1Fy/rqv1C7E5feuaI3kvAccVL13aW0+Rf3xw8pErlLXKdW4Rtt9LBuMHY1woc9PGmwrF5DqSBxdRPosdP8pQg23xYUdG8e95oagYCrpyIf5aYy3kdcW3kb+CSpZqNybG8L6iji0Xv1EJAzJGLsqZ3QDLuU94NwySRbdbAYmV7qgM0Inb44AUGJRQe4claSUB7PkRq26kkdyPZlKHcqHhdikUSHlxsA+HTdSdNdrcOPBvh36jJtI1OjEkJ8SjeDbC7OCtTIkQ8TULwyTp5L49BsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5kB276nLeLPt9tMSTv4yyBn2jpIXhT28z4cj4T8pss=;
 b=K7HN5v9+7k8SlZQREY2b1fKZOBTEIYgH5EIdLtOhU9QAJqD3/wzKBKxWski1BWRZdPIhHujrghh5QO462S5UhnRcxsamCt9F/3vPNjjiRzP9XARraI5Ekq6TH4cyPH26Dt10JisdX0T5oqTkyFZVqHZJTl3vU7Qvj7578WZDYgvImze/MBn9vhz/o4pcv11l393HJgtgAm5NYcdeMjcp4aZ+LEeKfNfzL9taXtXV6zXznIZssOvf0A6YXd8oHEWlEoK8WO8q70OUH03sy57v2i1KOwtRzFe//F54tnr522RxWKUskDjNG/67BE1zjXBFuSrPmOZA2Bq1LUoicAiRuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5kB276nLeLPt9tMSTv4yyBn2jpIXhT28z4cj4T8pss=;
 b=h0r/Gl8EDHOr8c/f78GAiW/tIlnvNo4dUR0MNpBjnyPfXgJQqudSlgv/lm0Qyl0oJfcuD3TZbQfwqdHVv7DDFrRHxEoQzydl4uZwWDSQVybyg6RVTOuwgxLeZZzFmi6pxrVQww3uJBroYghev376D57nDuJ4UTCfYkKq+XUdl0I=
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com (2603:10a6:803:75::30)
 by GV2PR03MB8680.eurprd03.prod.outlook.com (2603:10a6:150:78::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Wed, 29 Jun
 2022 18:31:13 +0000
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::de7:d0ed:2d93:9f78]) by VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::de7:d0ed:2d93:9f78%6]) with mapi id 15.20.5373.018; Wed, 29 Jun 2022
 18:31:12 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next RFC 0/3] net: dsa: realtek: drop custom slave MII
Thread-Topic: [PATCH net-next RFC 0/3] net: dsa: realtek: drop custom slave
 MII
Thread-Index: AQHYi2v6y8XzldS8b0+51yVWVr7FnK1ml/OAgAAZeYCAAASNAA==
Date:   Wed, 29 Jun 2022 18:31:12 +0000
Message-ID: <20220629183112.m4ve2w6svych6ull@bang-olufsen.dk>
References: <20220629035434.1891-1-luizluca@gmail.com>
 <CAJq09z44SNGFkCi_BCpQ+3DuXhKfGVsMubRYE7AezJsGGOboVA@mail.gmail.com>
 <20220629181455.boerjnqmvovmtzra@bang-olufsen.dk>
In-Reply-To: <20220629181455.boerjnqmvovmtzra@bang-olufsen.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57a6bdac-2ee3-44e7-0875-08da59fd8b88
x-ms-traffictypediagnostic: GV2PR03MB8680:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xRixysId1GqjtVUVbDgDhyU4yPewN0iyJuRGxaQhsuI+g2UDt8iiJAIZp1uU/tLePjUpwoCGkXz/5xBK3GHiMANhbzzoCGpKv2VALnTGdXRo3oYHuUfLnFeEMZ9+A5SazRh9vJsWvj3IsjpGdjkuEu3dBi+X7oO54Crhj59ExWOmv5O8Z4FSzSa1ubRE21eioUq6Ta/N7DzkdBosa3OffhYTJTsHv553bEa7s9bXjhNojmGz8C/oShAQ/GBr3N8OLpyfINegwfmM+A982utfQpPstVmpJ+cU0/OuxRikgjvUrAg14NYOIJI/M+16lY3N2awD9mqVSQVGi2+oPQzNF62AS/5EQEsyaYOD9s0fqgSBUvpM7/eFFU9MLcJyuntoWjFfocV/hS9rkByFdvhygILfD9Ozr5ZXjE+wU3mJq0Bf5fAuCKl5NZOUkHgARVIWlfNSjO8Wqc7PVatmmYPPJyysGLGByuvfi2ZQ25PsKn/XRVg4IItO95YTjjKuWrXAi7kzX8wRL0cWlZxtcMDAcRbV9eWTJbo8wIftASO0h+2dVwMU1tTwBt4mDG98oybSrOfLL9mGSz3j4nk2RIipo8OIUigLbXxyzvkLI6vOWot67Ox3HTpnJ/KHgcKIu4zfPT+OR1nZEyTMtzk10QXwrGX1LK52IgG5T1ioUdTKMmOudbCidyEYl2Kua00SL5wmQ2/4IbL4Es4iMH8gcJ9biXFVImshy88hvgabJzy8LmfrLoYsupbcMEHqCdMajDNVHDLxVJasiLR/eWj1WOefgtdchDw4siU2HUx8KW6szho=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB3950.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(376002)(366004)(39850400004)(2906002)(186003)(66476007)(8676002)(122000001)(478600001)(6486002)(71200400001)(8976002)(8936002)(7416002)(36756003)(4744005)(38070700005)(86362001)(6916009)(54906003)(316002)(85182001)(41300700001)(6512007)(26005)(66446008)(85202003)(64756008)(6506007)(66946007)(76116006)(5660300002)(91956017)(2616005)(66556008)(38100700002)(4326008)(1076003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGZYcDJYc0cxY1BiWVVZdVBYNFNYUHRBZE0xKzJKcnVJdEtqT1RwbTgxb0lC?=
 =?utf-8?B?eWo3ZFFMYmRLZERNR1BGR1FpL3Q4Mmw1ekpLbm1McldEaWhtTDhrTzUxbzVv?=
 =?utf-8?B?TDFsNitqSHZqZWlYVHVKQkdkbGI4YXVPV1NjdjdqRkRkeDBGN2JHWk1CWGFk?=
 =?utf-8?B?WVY3U3cvOUJBT0EzZVlGZ0hpLzZWbW9kd1JzZzBWTnVuaW5QMkNvaFdBb3VN?=
 =?utf-8?B?YXdkY3ZudTdqUWdBOWZPcXJsbWtZMTQ0TjFjS25sMG5qT2o5eEhuR1N6ell2?=
 =?utf-8?B?VkltM0VlSDc5SlBvVnFONGxiR3BCUEFqMnhhdU1iOGVmQ2lQMkNsQk85RHBk?=
 =?utf-8?B?djhjZTY4VEl4QytDMmFxNE42Q2t4NHRNNzVmZkpQN1R2V3BNdExqYkhTZGNs?=
 =?utf-8?B?ZDdrNmg3SzNrM0ptSlk2Q1NpNDMrc1NKeXF4eWIvam9tdXNveWltdGZXRnBj?=
 =?utf-8?B?c3M3MVpWcS9LbTRIdjdRNDJLYlhCL200b0hNWXAycktackZGK3NGVUxwVlBj?=
 =?utf-8?B?bUkxMW1Rcmh0TmlLUXZjUFRjaHluamVKNCsvUzlYcEt5TVpybUYvcUdiTmVw?=
 =?utf-8?B?QTJzaDNhYlJWeFJwU1lHT2JScG9mOTluUUd5MDIrYzlLdDZhRXB3RXVQL041?=
 =?utf-8?B?OTZsVVVUQUQvVnhXV1IwajVBdWhaNlBGdzNITFN2Z0RGRWRSclFXWGwvNkox?=
 =?utf-8?B?THBpcjJGZEQzM2FQTjZKT0hLVWI3SnBzTWJMSndRczdPZysyRHVIRlY5Q0NN?=
 =?utf-8?B?Uk54OGd6aHNuVmg1MEhUTG5YR3JrdDBoUm02dkxURHg0SzlzKzhHSUtndGNF?=
 =?utf-8?B?S0wyVUhMSzBxS3ZKdzNSVkhFR2lqcDFnNXFIVGFBdnBqMHhtT3J2MEIxV1Vj?=
 =?utf-8?B?UzBjaXE5UGdpandYTEdJTjVMVUZ2WWw4STB0SG5ncXBmR0xrd3RHazNGcS9J?=
 =?utf-8?B?Sk1lVTZEM2xwWXFTS3g2ZXdkMFNVL3BxS0VJZzYwQ0tCRnFTLzBETE9POXFj?=
 =?utf-8?B?WXBxZGd2ZkV5TTlPYXZ4aVVYMkF2KytRN0RuT2FaTlRIa0VFR1BlWE8wZmNv?=
 =?utf-8?B?b0VSdmVrbXRJU1VSVVNnak1UUVRxK2FISDlRYWNSVFQ3RHVnWXBOZjRRQ00y?=
 =?utf-8?B?c2QrUXdyc285UE5oeVplN0UyMlZybjdtbmRUYWJDWEc5U3JEVm9xSWpLSk1r?=
 =?utf-8?B?bWsrcXdCdjVRZ1IvRTRWV1Z1cVFnREhNc2pYbmQrdWRjekxNWkdvQzJrSmlm?=
 =?utf-8?B?U1daVWxHRk94SDJGSjMwMFdUSmNXcTdjbGFtV1J6Nld2M01rOWZMek1lTU1N?=
 =?utf-8?B?bjlNVlNzZTBqRllVc3Vyd20wTkZqVzdQQVVkbzFxU2Q0WkpJUWRTRnE5S05q?=
 =?utf-8?B?WUxtaU5GS2ZTWkRtRnBjT25wNnV6bnJXY2tkL1BkM3dTckRCNVlvamZvcmhz?=
 =?utf-8?B?cEFPTkI0NzBCcmVOYVU4TE1xaTdZU09Bdm5SRTU1dmFkM3JmZis5MFdwN2s0?=
 =?utf-8?B?N3VQWlMvVmtlK3UvWFJHT2VSa0ZTMUNxVm01SHlWOXQzL1dCc0FvRXNUUWQ3?=
 =?utf-8?B?UUYveUxDVXU1YkcwTEY3WmxEbzM1NnVlMW5NRlZaMGpNenJGNDUxUW9LWFc5?=
 =?utf-8?B?cEs4SjI4dnM4VDRmVnNMd3RqY0cwZGp6L0syT25IK0Q4S280WjBzTDlQU1Nj?=
 =?utf-8?B?UGRNYlduUkR5MWV2dElyU0E2RnRtRXpvOEZSVG1GUE5Fbnd3TnpGQVdKdDls?=
 =?utf-8?B?V3JNT0JSUGNjZ3A5b1RsQXpud25QUHFUSXFoS1MxUVdCdUhnL3NwdXhtNUlm?=
 =?utf-8?B?SC93aDFHOHRDTW5hTDk3L3ZPMG1LRWt5MVRCbWlRUGszSkxnOWVodWpydjQw?=
 =?utf-8?B?RXlaTGRLMzVYd3FEZ0VvT0VVZ3R2Y1p6Qyt1R1IveGdYSWZsRzAzMDQzdXgx?=
 =?utf-8?B?RENnUjVaUmx2OWV2b3F3eTZCMHMvYlQrbUlxVjZaWTNNbWJqOTBYUTNUbVNZ?=
 =?utf-8?B?U0NnNmJkU2x0ZnQ4ZG9qYVBBOU82MXkrclh3cWVjc2d4Y25WcEl2NFV0SEVz?=
 =?utf-8?B?MnRSR3c4YWlmekVTYnlKQklRMDhFMUQ1WGdKeWx2ZHZGNTlhRlFXclNvc3hW?=
 =?utf-8?B?aHh2dkNkQzlIL0tTRW9jWGRnZzFVNHpkRk5pa3R0UnJmclNhOFZBZzJTenJJ?=
 =?utf-8?B?Vnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8895AB359B47B428BE8EA4A93A6B478@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB3950.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57a6bdac-2ee3-44e7-0875-08da59fd8b88
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2022 18:31:12.8267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 63g3SuMf4xEglRur4qfksVTIZmggnjpZQRWLP7YN24cAi6Q2Y5K+9G2jXped4feI+P2YG4Ljq0/ipFteMO0XgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR03MB8680
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBKdW4gMjksIDIwMjIgYXQgMDY6MTQ6NTZQTSArMDAwMCwgQWx2aW4gxaBpcHJhZ2Eg
d3JvdGU6DQo+IElmIHlvdSB3YW50IHRvIGF2b2lkIHRoYXQgZGViYXRlLCB3aGF0IHlvdSBjb3Vs
ZCBkbyBpbnN0ZWFkIGlzIGFkZCBhDQo+IGNvbnN0IGNoYXIgKnNsYXZlX21paV9jb21wYXRpYmxl
OyBtZW1iZXIgdG8gc3RydWN0IGRzYV9zd2l0Y2gsIGFuZCB0cnkNCj4gc2VhcmNoaW5nIGluIGRz
YV9zd2l0Y2hfc2V0dXAoKSBmb3IgYSBjaGlsZCBub2RlIHdpdGggdGhhdCBjb21wYXRpYmxlIGlm
DQo+IHRoZSBsb29rdXAgb2YgYSBub2RlIG5hbWVkICJtZGlvIiBmYWlscy4gSSBkb24ndCBrbm93
IGlmIHRoaXMgd291bGQgaGVscA0KPiB5b3UgZG8gdGhlIHNhbWUgdGhpbmcgd2l0aCBvdGhlciBk
cml2ZXJzLg0KDQpGb3Jnb3QgdG8gbWFrZSBpdCBjbGVhciwgYnV0IGhlcmUgSSBtZWFudCB0aGF0
IGEgRFNBIGRyaXZlciBjb3VsZCB0aGVuDQpzZXQgZHMtPnNsYXZlX21paV9jb21wYXRpYmxlID0g
InJlYWx0ZWssc21pLW1kaW8iIGluIGl0cyBwcm9iZSBmdW5jdGlvbg0KYmVmb3JlIGNhbGxpbmcg
ZHNhX3JlZ2lzdGVyX3N3aXRjaChkcyku
