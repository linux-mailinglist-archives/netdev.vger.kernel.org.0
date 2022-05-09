Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA9C51F72D
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiEIIuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 04:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbiEIIU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 04:20:57 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on20729.outbound.protection.outlook.com [IPv6:2a01:111:f403:700c::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEE8AC059;
        Mon,  9 May 2022 01:17:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TzIrDdgzQDSDJ03TvWT/c3COeyiPvjexDsQjY6yI2pLCUYPuPO/NjGgRGhjmFCoVlVjkls5czI6qg9L5S2U3tfUgVpCMdcLzXJz/XHNkGDbZ0nIbOprXS7WdbLScdlUh/j446YoiXHUKTZTlLSj88hm3TzgAfyqMB9OqsQSXcDKDC9yk5ANAd5V2T8+zNuln9wovwtEEKcChRdaAKaiBalPqrF2SGitaO6BXGal2Ek9luMD+Sj0PW7Aho7WYdA4INN0YUqIQM2lbxAGo3hA7JhWuV5thRIy64dvjhCK4V3+EyEkK20lkXBp8+rO0ttur4YG4+DheV74HciiKwPp1Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TBtecdELE4qGRCY2eyVPDAFtYh6vGyUFvTRvGyTQVAU=;
 b=VpA+Vwm7MoFAFrKiYKn5ECSJzFNWH+pCq7WPV9QSkDuLdzDP19qrSqMtH8iu4a01eT9eHQ1QVOCm3dZkP+sUrvrCa8nzQpXCS+ou7JCRPOESDUpoj687FtAO87sX6YM33LE27xyFMcRB48t3vthA75+8Rfi2/svTNsY0NvfrDPBKjQCUqoVpZ6yun/5plOtHf8QnGWQtwhrCrMrXnnmKzdKgUMjpa+2r1HWGaU2306VzNHnJiqL9yWYV1nZJO8PfdKWDvbDOCagCE0C9QmnV7gsptQH4j2sGycLsRbWoz6SwiMo7KEbcwkMhFKGgwDUztzU0A+y/zwY+6r5o6GN1Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TBtecdELE4qGRCY2eyVPDAFtYh6vGyUFvTRvGyTQVAU=;
 b=VhfE04my+CxNgsZ5pNv7Q1C6Dpe194BN0MQBI0WQ+sehJnQaVfAAc6WrJjuLlVuXW03eL6oyTgvRiGVvK0hIv7uEFNn3qcvExs9UPydm0+2+GsnbZan0M1w9OOf4H2zoj8+qDPZGc2jnYAcXepZklpEtANKMx4Ne224yoyzmabg=
Received: from TYYPR01MB7086.jpnprd01.prod.outlook.com (2603:1096:400:de::11)
 by OSZPR01MB9634.jpnprd01.prod.outlook.com (2603:1096:604:1d3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Mon, 9 May
 2022 08:15:53 +0000
Received: from TYYPR01MB7086.jpnprd01.prod.outlook.com
 ([fe80::e180:5c8b:8ddf:7244]) by TYYPR01MB7086.jpnprd01.prod.outlook.com
 ([fe80::e180:5c8b:8ddf:7244%7]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 08:15:53 +0000
From:   Phil Edworthy <phil.edworthy@renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: RE: [PATCH 2/9] dt-bindings: net: renesas,etheravb: Document RZ/V2M
 SoC
Thread-Topic: [PATCH 2/9] dt-bindings: net: renesas,etheravb: Document RZ/V2M
 SoC
Thread-Index: AQHYX8cMTI/kB4v9YU29Dc3y/S2Pv60TvtwAgAJ3qnA=
Date:   Mon, 9 May 2022 08:15:53 +0000
Message-ID: <TYYPR01MB708652E5F2CD62096EB0C61AF5C69@TYYPR01MB7086.jpnprd01.prod.outlook.com>
References: <20220504145454.71287-1-phil.edworthy@renesas.com>
 <20220504145454.71287-3-phil.edworthy@renesas.com>
 <d0c1800f-8826-207f-35a8-90d3a62a32fe@omp.ru>
In-Reply-To: <d0c1800f-8826-207f-35a8-90d3a62a32fe@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c8daab5-96b6-4ea6-c1b5-08da3194229e
x-ms-traffictypediagnostic: OSZPR01MB9634:EE_
x-microsoft-antispam-prvs: <OSZPR01MB9634DB544ECEC0448DCAB10DF5C69@OSZPR01MB9634.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 19YptqWukW1pe9vhaDc+gobqCTLCqtHCwwDc5ovglm+hTvOGHeiOjwM4ryvnWdYNeYRZJYdrvGIo25YGEcaae/URoWbyIMN1OulA2QX1hVlqYSmiKKeWUruRJxS1r8OTbCjZwQMq8ATZ+RhUiXjYhsMCwzzwe7YVIv1aFni5Os44bpvFdOaekDxl5Igkt/x5HQQm8KdkLIyANbNXMkv+LSy9y51F1BeW1pUmXZxPpLGVrwbJLZFm0yQXQhB1IrXmLsiOdpQtqK3EEQcww5zi/lIxBgHIpSe3WoherLV4Zclp6eg1hR3M4xhymSLdAQM+mdLO37Ja9fUhf4ByBd/Lbkd3CdgERn6hehZed0jqFNNpuX4LybM09U9mAzlkidcuebS1DSm1kcICZi1bXWYCby6Sj0eiu1T8xWYXz9yIeNeo/+n/yqwLooscrED6iGCkjfqTzdyXx9J9JTGpL5T/UyI3Q6sqhdhZ6b3gNg7di8/f3vglR+9fvzD5IBRHRIfZP3rfniD+RVTpsbZHv6lXCrr+3L4fAhpSbZSFfK2Yxp2YIxlzmVrXNdlqKHZ1iOMcWn3NxhowtDnOpn7HBIrdPQWkpNgym5B+8B8fOe3f0QHXEW98xnEtAwuozZ3kk7AMBHsDCTQP1wIhqKPYvqCmZtswY33DfhAvaiEmYwMPjRJQ3C1I0JtG7cmt/83rWGzYS7lPRLLHCz5FqMOQVOHgb4+i1EJoz2f1kHK3l8fnXVTJm9mRBZHg8rhl9LEc1AGWSB+kaMmlnk7ByNA5TNZKxIaZQJiNLWvfe8J0oea3dmc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYYPR01MB7086.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(966005)(7696005)(9686003)(6506007)(316002)(26005)(66556008)(107886003)(110136005)(83380400001)(76116006)(66946007)(33656002)(66446008)(8676002)(186003)(64756008)(4326008)(66476007)(53546011)(71200400001)(54906003)(2906002)(7416002)(38100700002)(86362001)(5660300002)(38070700005)(122000001)(44832011)(55016003)(8936002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3RLa01sblMrMUdTSnRaRURFN3lkVElWRTBwNW1aRHJoTGMybGszRmd4cnRU?=
 =?utf-8?B?MCsxMkhoUW1jTjB5T0RXdy81Smh1bHBCVHh6R0FVS2NBNEpmdDdodnFDOERT?=
 =?utf-8?B?L01zc0ZNdG1Ob2I1VForQlVISUxhSFFhcGtEL1ZDSTYwZzU1eE5Sa0NMaHNC?=
 =?utf-8?B?MzdWWElMUkhMcVZFaWxjNHJJdHlmMWExVWxhOFloS3R0ZnEwMFAzWS9kai9w?=
 =?utf-8?B?K01DMFEvaUtRU1VST3lkekVQZUtUT0ppd0VONTZuc1ZzbXNndk5qTW1vNEg0?=
 =?utf-8?B?K3FucGtRU0tBK3hHR1duSlg3TFVlZEF2djBmT0ZDWDlrNkZCRUdJTFJiVU5u?=
 =?utf-8?B?VXk0KzNtZ3VqWFg5UFcwSWt4Vko0ZytkZlVyYnZYc21mMnFXNmg2OEY3cm9p?=
 =?utf-8?B?bmdxL2V0V3Bsajc4S2FiTjgvZ0dNckNzaTFxZXN2V3lucXA5ZmMwaVZmcGhh?=
 =?utf-8?B?OFJLeFhGbjM3ZVpSL01vUkt4MWxTWVlWbnFYZWk2enVxWGZ1c2s0Ymx6Ujhn?=
 =?utf-8?B?cHFnNkE0V1RublM3UnBkUktZNForTDl5cmhvTmlDck8venpOeVU1YnljNUV0?=
 =?utf-8?B?dTVRTnBYTzIzNmRpVklQQXlOVjhUc281aC8zdEZyb2VvUkhjMG93ZlB2SjQ1?=
 =?utf-8?B?SS90M2w1bDJ6TGpLMGF4cGpVVUZrRnpNTWVUem9QVzZSYjN0UndMRFJwMUx4?=
 =?utf-8?B?R3VoOHpEVUVZK2NEUmsyTGs3M2VsSTBxQmRXWDJWY0hSZG5iTzIvOCtoYWlE?=
 =?utf-8?B?eXYyTFlvN2FzSWxOc2Fzd2FReXBkSWlGOEQzdEhWSklVTC9MdUZDcVgxZUJX?=
 =?utf-8?B?M1dtSnozeHJjSDVIOU44MTJQeXZMcnkrZ2g1YStIRGtMSytEeDhCRCt6YTBm?=
 =?utf-8?B?NmVtNzZlYzlLV1JlZmwzT2RGU0lQaExvbFQzQ0p6cS9aQm1yemhJdU1GZm5x?=
 =?utf-8?B?RXVyT05zQm41UVlpcGljWTVQNDRuamhiVmVoN2tCS2N5dXpSMGQ2bnNnbzlO?=
 =?utf-8?B?dTJFZ3YrQWdHUFlFWnRBWXlMei9QWmxQbkEwcmNyZ1lLOFJqWHp2RnIybkZE?=
 =?utf-8?B?bzd5SHppbGROZlh5eVFXcXQrbEowS04zWk82UFpEM0VIQUdKazYwMlhSRUFM?=
 =?utf-8?B?K0E3dmI0OVJ3eEk4Q2NwcTFNeGRkRGQ1WHF5N2h0M0NUajRsaS9QbU5HSGIv?=
 =?utf-8?B?SWxjaTVOQkh4UEZQL1NiNCs4RjZnVUl1Z1JFczBjeDUzMmYybHRaYm94YlZr?=
 =?utf-8?B?bUpOSHBTWUdGM3F2TDcxTnpjRFE2U2NSQnEvMXBBK21hQkx2ZDFzSEFpdk4r?=
 =?utf-8?B?M3VvVUpKWFVTTXI2RHNGa21iSTFrZkphR0JQMFZaeFNXM3IzQVNmbTFKWlJJ?=
 =?utf-8?B?TFJKSWx2NWQ5Q2lwREErdU1xMDFXZWdVMzFLaGU5bHZOZFBMeXNBaERPa3BE?=
 =?utf-8?B?aWM2dVpBVFo4bE5kS2xkVUJ1bW5uS0prM2NveENsSEI5WnhBWlpOWnl0ZWh5?=
 =?utf-8?B?YXU2UjNpVmtTOC9EWG1iV0UySEppa2NnMkJkL3ZwWVlVdHRDd3pUNVlQR2lB?=
 =?utf-8?B?MHFaV3RWaWdJRVJyYjNETTdLbTNXSjI5aEIwdENMUWNJOER3NSt0Z3J6cmNO?=
 =?utf-8?B?Nkh1RWtxaVg5Z20vMVB6NFRjUFhLTTNMTG4xUURDYnRSSktDTFdNUC85VEZu?=
 =?utf-8?B?RXZJdG1TaHJLT0l1UWlQSE1aQzk3b2J1MU5TRzUwblY1RTdkNkQxdnp4SjVk?=
 =?utf-8?B?aU5sd0Y3ZzB5SzMyVzJHekVSeXFLbUZEdGRjT3JnejkzOGpVR2dGOE5yb1NE?=
 =?utf-8?B?czRCNDhGeDZlOFBvVEsyK0pKRDFYQXhFdHQzUWM3SkNSM1RVRHFFaVNpNWV1?=
 =?utf-8?B?aUx2ZnplWDByV2JaQ05yT1NoUFp1NlZIUE9nc1N6bEV2b3ZVOFhqVkRzL1pX?=
 =?utf-8?B?N0k3OWM5bHpKZjgzQUtYOC9DMTd5SElvenpHbFZFM041OXVwMklBaWpOMGV1?=
 =?utf-8?B?a0c0YmI0OEpYREFpT21haGd3OUFDWDVlVUpkWTB0aUZuMXhlNHJqV2FQRjl4?=
 =?utf-8?B?M0FMbW1VclRSN09wZCtIVEk4WWJnZzY0dnA5Qy9XT2wyUjBoU3NTYmVVWFJq?=
 =?utf-8?B?aEQ5Vy9XSWpCL1VXaW1iNC93SUpqNnVveWEzbXhGbUZkZWlmbnBmVSs2YXhh?=
 =?utf-8?B?Um9iclA3VjVDa1EwY21ic24vY0F4YlJVb3FlUEhpM2ZGYnY5L1F6eDAwZEQ5?=
 =?utf-8?B?bzVwQ2QyclZwZS9JT3ZqekZxNUMrblJrSlZyWHlCTTYwMTNhSDUyeXlHbURK?=
 =?utf-8?B?WFRLcUROK3hJbmVmQVkxRzlXcVFhcFQ4d21NQTdGVEhNdW1aK29UUlR3cFBz?=
 =?utf-8?Q?OrwOMJ2UJ4189r5M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYYPR01MB7086.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c8daab5-96b6-4ea6-c1b5-08da3194229e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 08:15:53.1472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uYnP9fHuFQ44mmwgTGrOENqrfngJmh4NqH4RqE4GU60Tf11kWAGD96IW0dtI+Oku0t5aW6mOQCZoKHyIdqoX0/zG/Jqn9vBaLTYK5X3rMvA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB9634
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQpPbiAwNyBNYXkgMjAyMiAxOToyMSBTZXJnZXkgU2h0eWx5b3Ygd3JvdGU6
DQo+IE9uIDUvNC8yMiA1OjU0IFBNLCBQaGlsIEVkd29ydGh5IHdyb3RlOg0KPiANCj4gPiBEb2N1
bWVudCB0aGUgRXRoZXJuZXQgQVZCIElQIGZvdW5kIG9uIFJaL1YyTSBTb0MuDQo+ID4gSXQgaW5j
bHVkZXMgdGhlIEV0aGVybmV0IGNvbnRyb2xsZXIgKEUtTUFDKSBhbmQgRGVkaWNhdGVkIERpcmVj
dCBtZW1vcnkNCj4gPiBhY2Nlc3MgY29udHJvbGxlciAoRE1BQykgZm9yIHRyYW5zZmVycmluZyB0
cmFuc21pdHRlZCBFdGhlcm5ldCBmcmFtZXMNCj4gPiB0byBhbmQgcmVjZWl2ZWQgRXRoZXJuZXQg
ZnJhbWVzIGZyb20gcmVzcGVjdGl2ZSBzdG9yYWdlIGFyZWFzIGluIHRoZQ0KPiA+IFVSQU0gYXQg
aGlnaCBzcGVlZC4NCj4gDQo+ICAgIEkgdGhpbmsgbm9ib2R5IGtub3dzIHdoYXQgZXhhY3RseSBV
UkFNIHN0YW5kcyBmb3IuLi4geW91IGJldHRlciBjYWxsIGl0DQo+IGp1c3QgUkFNLiA6LSkNCkdv
aW5nIHBvaW50IQ0KDQogDQo+ID4gVGhlIEFWQi1ETUFDIGlzIGNvbXBsaWFudCB3aXRoIElFRUUg
ODAyLjFCQSwgSUVFRSA4MDIuMUFTIHRpbWluZyBhbmQNCj4gPiBzeW5jaHJvbml6YXRpb24gcHJv
dG9jb2wsIElFRUUgODAyLjFRYXYgcmVhbC10aW1lIHRyYW5zZmVyLCBhbmQgdGhlDQo+ID4gSUVF
RSA4MDIuMVFhdCBzdHJlYW0gcmVzZXJ2YXRpb24gcHJvdG9jb2wuDQo+ID4NCj4gPiBSLUNhciBo
YXMgYSBwYWlyIG9mIGNvbWJpbmVkIGludGVycnVwdCBsaW5lczoNCj4gPiAgY2gyMiA9IExpbmUw
X0RpQSB8IExpbmUxX0EgfCBMaW5lMl9BDQo+ID4gIGNoMjMgPSBMaW5lMF9EaUIgfCBMaW5lMV9C
IHwgTGluZTJfQg0KPiA+IExpbmUwIGZvciBkZXNjcmlwdG9yIGludGVycnVwdHMuDQo+ID4gTGlu
ZTEgZm9yIGVycm9yIHJlbGF0ZWQgaW50ZXJydXB0cyAod2hpY2ggd2UgY2FsbCBlcnJfYSBhbmQg
ZXJyX2IpLg0KPiA+IExpbmUyIGZvciBtYW5hZ2VtZW50IGFuZCBnUFRQIHJlbGF0ZWQgaW50ZXJy
dXB0cyAobWdtdF9hIGFuZCBtZ210X2IpLg0KPiA+DQo+ID4gUlovVjJNIGhhcmR3YXJlIGhhcyBz
ZXBhcmF0ZSBpbnRlcnJ1cHQgbGluZXMgZm9yIGVhY2ggb2YgdGhlc2UsIGJ1dA0KPiA+IHdlIGtl
ZXAgdGhlICJjaDIyIiBuYW1lIGZvciBMaW5lMF9EaUEuDQo+IA0KPiAgICBOb3Qgc3VyZSBJIGFn
cmVlIGhlcmUuLi4NCk9rLCBJJ2xsIHVzZSAiZGlhIiBpbnN0ZWFkIG9mIGNoMjIsIGFuZCAibGlu
ZTMiIGluc3RlYWQgb2YgY2gyNCBvbiByei92Mm0uDQpJcyB0aGF0IG9rPw0KDQoNCj4gICAgQlRX
LCBhcmVuJ3QgdGhlIGludGVycnVwdHMgY2FsbGVkICJFdGhlcm5ldCBBQlYuY2g8bj4iIChhcyBv
biBSLUNhcg0KPiBnZW4zKQ0KPiBpbiB5b3VyIChjb21wbGV0ZT8pIG1hbnVhbD8NCk5vLCB0aGV5
IGFyZToNCnBpZl9pbnRyX2xpbmVfMF9yeF9uWzAuLjE3XSBmb3IgTGluZTBfUnhbMC4uMTddIA0K
cGlmX2ludHJfbGluZV8wX3R4X25bMC4uM10gIGZvciBMaW5lMF9UeFswLi4zXQ0KcGlmX2ludHJf
bGluZV8wX2RpYV9uICAgICAgIGZvciBMaW5lMF9EaUENCnBpZl9pbnRyX2xpbmVfMF9kaWJfbiAg
ICAgICBmb3IgTGluZTBfRGlCDQpwaWZfaW50cl9saW5lXzFfYV9uICAgICAgICAgZm9yIExpbmUx
X0ENCnBpZl9pbnRyX2xpbmVfMV9iX24gICAgICAgICBmb3IgTGluZTFfQg0KcGlmX2ludHJfbGlu
ZV8yX2FfbiAgICAgICAgIGZvciBMaW5lMl9BDQpwaWZfaW50cl9saW5lXzJfYl9uICAgICAgICAg
Zm9yIExpbmUyX0INCnBpZl9pbnRyX2xpbmVfM19uICAgICAgICAgICBmb3IgTGluZTMNCg0KVGhl
IGZ1bGwgSFcgbWFudWFsIGlzIGF2YWlsYWJsZSwgYnV0IGFuIE5EQSBpcyByZXF1aXJlZDoNCmh0
dHBzOi8vd3d3LnJlbmVzYXMuY29tL3VzL2VuL3Byb2R1Y3RzL21pY3JvY29udHJvbGxlcnMtbWlj
cm9wcm9jZXNzb3JzL3J6LWNvcnRleC1hLW1wdXMvcnp2Mm0tZHVhbC1jb3J0ZXgtYTUzLWxwZGRy
NHgzMmJpdC1haS1hY2NlbGVyYXRvci1pc3AtNGstdmlkZW8tY29kZWMtNGstY2FtZXJhLWlucHV0
LWZoZC1kaXNwbGF5LW91dHB1dCNkb2N1bWVudA0KIltOREEgUmVxdWlyZWRdIFJaL1YyTSBVc2Vy
J3MgTWFudWFsOiBIYXJkd2FyZSAoQWRkaXRpb25hbCBkb2N1bWVudCkiDQoNCg0KPiA+IFdlIGFs
c28ga2VlcCB0aGUgImNoMjQiIG5hbWUgZm9yIHRoZSBMaW5lMyAoTUFDKSBpbnRlcnJ1cHQuDQo+
ID4NCj4gPiBJdCBoYXMgMyBjbG9ja3M7IHRoZSBtYWluIEFYSSBjbG9jaywgdGhlIEFNQkEgQ0hJ
IGNsb2NrIGFuZCBhIGdQVFANCj4gDQo+ICAgIENvdWxkIHlvdSBzcGVsbCBvdXQgQ0hJIGxpa2Ug
YmVsb3c/DQpXaWxsIGRvLg0KDQoNCj4gPiByZWZlcmVuY2UgY2xvY2suDQo+ID4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBQaGlsIEVkd29ydGh5IDxwaGlsLmVkd29ydGh5QHJlbmVzYXMuY29tPg0KPiA+
IFJldmlld2VkLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+IFsu
Li5dDQoNClRoYW5rcw0KUGhpbA0K
