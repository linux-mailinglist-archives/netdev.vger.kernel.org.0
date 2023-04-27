Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB0B6F0720
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 16:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243926AbjD0OT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 10:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjD0OT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 10:19:27 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE3210DD
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 07:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682605166; x=1714141166;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=e9eX8ERWNGWPLTmnaA6x4p0BaW0T7MUKFmvZjy53yFg=;
  b=gqP713AJQrEzlUf5Drnb/qhmfGCh2npvabDm528m3Wxt6Akm5PCO6lYH
   2eMrFreZrrhpS94JlzZOuPava1cKRxgZSeCXyvtGeAnppTy34uBp2h7Q2
   hUAHJENOFLqmtBD2uAjC2uPxs1m51Q6+VwY9vV42VlDMCdN766S3C+54L
   5oFfo6EiF1nFZBfmUoT6bKtDWZS1r01pDYffPTnMIvhyIv7rhHafQkYZ6
   q/iLTTJBY2zSeaZNtYtnHiaYc0muCLbCrCOy5ut/EMct1p7bMPBEXsJeg
   k3HC6b6Sgla5w06jCYBpztJmYJLJydRkxwfWcdSiHAZJvqg3BWD9xSmzP
   g==;
X-IronPort-AV: E=Sophos;i="5.99,230,1677567600"; 
   d="scan'208";a="211478932"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Apr 2023 07:19:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 27 Apr 2023 07:19:25 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 27 Apr 2023 07:19:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ca3GvNcfWGlofDcpX+0shNve2Q7kVBu5IdKa0JLBhTG91EldTTabyj9agrpoVkJs7BhbD2Juf1x+xpXz5cGspIIi6cTww4cKjh0wTYIis6KH2q8yTJr6IsJ4+o2xkPlIiZBaasjatfsmX1qzRWUhoMeQMdq00re/khHgkSlZucgsGPccnncM5Y2u/ZZmLvqrNU2N9Q0gEU4F02Z8C+NIfS7PEcm+M1rCUyos7aCmUdjNhdybWsFKDjWfPuRqys/1SfZe5Xy1BbDgIGibCemQyCmAnmgbScYFnW5lNZjYsgbBkhYDAyzUssBYiEXJACMLOQLAyPdUXGyc1MIChsdlyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e9eX8ERWNGWPLTmnaA6x4p0BaW0T7MUKFmvZjy53yFg=;
 b=dnHXo7tf+blGfH9Kfs1TFASXbiwA405S2CX3VuiWlYSI1cGBSMS2h0BEZpRPLOArKEZaolZR/oYA5/bhD8Wrds7+yV1A1Q7SAjGpCe8CHp+IB3BCeNLvpToTMCnl8uORvvXcgtnykMycVfiWlQAs2JwxBa/pcjRT03jsehod2un3klmAxaY5uMoGovjvdGSyqr58/5lqGT4J1DctmoDsvrCe36/yv+xmluxftT4udo2S1JOe13anXA+K4On7OigebRVcGzmSkF0vaz2Xc5HTdPoiptLtONBjUEnTtiYm0p1oDcsWHCtoQr7q0V0bXTxnwSuZ+Rk5ecicb+0I6Mo78g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e9eX8ERWNGWPLTmnaA6x4p0BaW0T7MUKFmvZjy53yFg=;
 b=Bl7BPafEgfklkjLQQcA963K1LvoNMlJPCdAvNTdZ3FMVojyKr+NvwPZzZ3kSjjkgenBJVsErH5HA0HoSRacTMxVH4acE0vXgm2spgJSMknRZRlmZR2YxnKeGvrHCBJFaHXVGOUgRsX8FrVTpvJeAU0cHMAt04gsLA2NNV4aPjBI=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 DM6PR11MB4723.namprd11.prod.outlook.com (2603:10b6:5:2a0::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.34; Thu, 27 Apr 2023 14:19:24 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::1c94:f1ec:9898:11df]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::1c94:f1ec:9898:11df%5]) with mapi id 15.20.6340.021; Thu, 27 Apr 2023
 14:19:24 +0000
From:   <Parthiban.Veerasooran@microchip.com>
To:     <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <Jan.Huber@microchip.com>, <Thorsten.Kummermehr@microchip.com>,
        <ramon.nordin.rodriguez@ferroamp.se>
Subject: Re: [PATCH net-next 2/2] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Thread-Topic: [PATCH net-next 2/2] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Thread-Index: AQHZeDS4+uhGlxLTVEmm8UA24iRXs68+IlEAgAEUDYA=
Date:   Thu, 27 Apr 2023 14:19:24 +0000
Message-ID: <85f657bf-e2c6-0ad3-bac0-b87904697644@microchip.com>
References: <20230426114655.93672-1-Parthiban.Veerasooran@microchip.com>
 <20230426114655.93672-3-Parthiban.Veerasooran@microchip.com>
 <c9d06cfe-8834-4ffa-81a8-097c883cc960@lunn.ch>
In-Reply-To: <c9d06cfe-8834-4ffa-81a8-097c883cc960@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|DM6PR11MB4723:EE_
x-ms-office365-filtering-correlation-id: f8bc2281-bc2c-4e2a-5932-08db472a66ca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YcUBpdqcmtrotjcqqDsuka4y+KSkam1E2IyTN2WlyPU5HRWwDlWBGSfXjl9oIszXMkTHyZ4f3tlofMWKJNkCDdIxTiu7QU6T14J1oS+CleSCNgM7CmlOPl6vg6nOXFU3ikObpXv/BXTNTf41Ev9ZTmcePiMQtFxglhSfUoE8y4z90DfV2KP92giLYEZI1QOlmyocNoqUY19KD283Xw+BINVmGDXUEHwXmnODt/PClDzhf4KOLZiY7GmJbLC66MY1/rmwnAuYehb04DeNRtaqdIWrA7npN4l74R5kantmpO2kKrMuXkHiwFHDgLodPwQLyrOFHEL4AdOHNNpOpZqa4b47mcsCw17qpew0UxgXKAOvBXK/MNYXHyUlp1ovI1rcR7Hk2OeKnzj3SYHSVLclNvVqB9yJnLLjkATZKCD+N1tt7iCQZudtd+jQT/cUSysJ3YwjbMNwwN9U1iPk0rveagAiqDBz2sI9179+D+5V2YbmKgm0BnCXfOta3lfcJw6xdZ71RXGcNjv4pSvIfrEoXodde9LfWBkQzsSMkOXAmcb11L+coK7HVL2+Bdqy69M9g3R2ExoBmxY5mRgg3l+nKKCR1fV4Kc66VFYGJw0hbL2eEkeqY4clwxjmI+BJjxMsJFXOvdkxr17EkcKt2YtWWo2zrOPcXZooZ3KuU1hzAx3v39vHihWZwlSkmVyKR4/8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(39860400002)(346002)(396003)(451199021)(2616005)(6512007)(6506007)(478600001)(26005)(53546011)(83380400001)(31686004)(122000001)(41300700001)(5660300002)(38070700005)(316002)(186003)(38100700002)(2906002)(91956017)(66556008)(64756008)(6916009)(4326008)(66946007)(66446008)(66476007)(76116006)(71200400001)(6486002)(36756003)(86362001)(31696002)(54906003)(8936002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEdGUkt0T2Y3eFUydzZqR0YyWmFqK0tBa1RuZ2tqSlEzVjFYd2gxc0dlYjNr?=
 =?utf-8?B?Sm02OEhOdkN0SFVMNEJTR3NIR0VNUEIxb0c2a0JMTkczTEZoU3Q1eHdtKzBR?=
 =?utf-8?B?S0xUVTFZK3RzdHRLRnVTcnpxT0VmanFxRnUwbjhBUzNNekg4SFMyYlk4dGUy?=
 =?utf-8?B?TFhiNTdLeGpud0ZSWHozZUN0bDhUZytDZW54amdOdzFDYlpCejVvb2N4bmNO?=
 =?utf-8?B?NkJjaFY0cEM2WXI2V3lmTXViU2MyVWF1cnZCRm1USEFGWlFCWE10Q1RHZ0lH?=
 =?utf-8?B?NG5UY1R6VEZ6aU5zVXZNamZwVWdGSlc1YTk3cW1FKzFMR3o4Qy9HNXowUE1x?=
 =?utf-8?B?MDNZMHBwWUt4TVA4T2w1eVd1TVVRYmIxbDROTEVxbE55WDNTM2tHekphMnZM?=
 =?utf-8?B?QWoyM1puYWFCQ0J0ZVBzTEorcEVLaEpqL2svTHF5Q2d3TiswMmh4clp5YVhX?=
 =?utf-8?B?ZVR5MjNlM1A2YjNoaFFHN2ppM1dwdnVieHRsNVR3U05INktGRE4zcEFuWktN?=
 =?utf-8?B?cWRDV2x4Qlppa0kva3pzUSsrSHJjZlpqMjkrY3pLcnVCS0ZUUjkvcExGNFVI?=
 =?utf-8?B?YkkyNTFTbE9lZ0NpUFhUODh0dE1pRjFhRVM0dURQUWJGeUVKTEF5R0JBWHl1?=
 =?utf-8?B?aWpMWDRXQ1ZUQUxVUW0zUzVTa01BMXZEcjBqcllKdkxBaUx6N1dGME9Rbktn?=
 =?utf-8?B?TXlOMmRWd1h0RXdUU2RzMzVtTnZaN1NJYlpxdGhiYkxETzB2MVZXdWt3amJ0?=
 =?utf-8?B?Yy8veUxSeFgrazByTUxwYTRvV1EydEdLRFk3ZW80TGd1VmpQVkhtQnpNTllM?=
 =?utf-8?B?aXNyeitrRWNIK3o0Y0k0SDNQWEpTT1liYXpKeEczeldra1g5ZXRaMDlldG83?=
 =?utf-8?B?a3lDcVFoUGpQUVd6eDZvbGoyTlRMTmVsNEZMdTBUaUtFZ1dYMXk5T2lndzFQ?=
 =?utf-8?B?R0tCSjBGU1hBdUtXM3BNMGRvWVZJN2JsZ1E3QW9WYUNrZ2ZieGFiZ3dYaXJk?=
 =?utf-8?B?UkloYW5ndnR2OHZpR0tXRUFLYXUzTXZsd1ZsU1kwQ0FjVC9ycllVL1JRSVVN?=
 =?utf-8?B?MzBmQU5iNDVYbXp1R0ZLRUhHa09objk5MUtsL2hQTXA5SjZnYWJuMVpSUnIx?=
 =?utf-8?B?VVpqRUM3OHRoRFNwcStuTzkrVUxuYUZHbDdnc1lJMFhGU0tPaEtIQlBqalk1?=
 =?utf-8?B?NWc3elhXT0tCdzc2d3BZVWdrMnpJaU0zVzBjK0hIdGIyRy9YbXUydnUxVDJF?=
 =?utf-8?B?MmNFQ1pmVzNsb0JjVDh3MjlZbnVPWDhHQVFRREorcHg1UzZxY2ZXQmNUdWF1?=
 =?utf-8?B?Vm1OWFhKRUg2dHFqRjRFV1NWazZ5bFZzeEozR2xUdzdTMTR5RTRyVTBOc1Nw?=
 =?utf-8?B?U3B5UmZIVGsxVDlhcStRVzZlWis2OTNKUDVxc2Y5U3NySml5ZE5RL1JGVmJa?=
 =?utf-8?B?am42eXU2N0t6ZlFkemZ3a09YQUZ1YW0vMXVHSEJwK25GbUI5NTJwSFV5Y2lV?=
 =?utf-8?B?M0c2WkgwU0VqVkZYUDRwZlRtR2J2YmxZaGtLWkVKU0FBdjcveUNDYlVHajlH?=
 =?utf-8?B?bURMQnJiM2FibzEycjd5NmttaWI5ZzZFbnNOMlk2b1lXZHVuWVRDTThKOG5F?=
 =?utf-8?B?Z3NDQWZXcFpweWZqN2szNTRRS08rN3dkM1dqV0VZUXRPVFZhTkpaclRBMnBC?=
 =?utf-8?B?SFlaaTRRTXNmQlViRGk0ODRsVXcyQm5GSTROOFMxNEVhWlJKeS9NR3VZR01T?=
 =?utf-8?B?bTVzNEpiYVB2K09JRWxhSE1NSmpjUFAxTnY4OVM5UGZWQWFEdTRRajhtUTlQ?=
 =?utf-8?B?aDhuUnowdUl1MUhJU0FBZTdZUG5WQ0tUUnFPYWc3Zmx1TC9wWXkzY24raXdl?=
 =?utf-8?B?Q1NIZW5MaEp1YUVSY2ZsYnRBUFBkQnZlN2h0MHNReU9lMXp0R1ZtbUFPa09N?=
 =?utf-8?B?Q080akFtVjFJWFlvV012c2toei81T1E2T0JUc0RLdlNlZzNQRmVlbXJkbGk4?=
 =?utf-8?B?d1kwNHhQNkYvUktSRWtMVDcyRTlMWjZ1U05PMzkrNm9wUWpxTDg3MWptb1B6?=
 =?utf-8?B?TUdxK0N1REE5MlAvSnhRck9PNW41bkZFbEZua09jNXUyb3ZTTVJaQm8zUjdW?=
 =?utf-8?B?M00zZ1RpVTVmRUoyaStBb2JRakc1NGJoMXQ5YXA0c3hscHhYajVMMXc1eS9U?=
 =?utf-8?B?eXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F93A6837C7E02948A656D15006EB4A3C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8bc2281-bc2c-4e2a-5932-08db472a66ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2023 14:19:24.1493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X4kJ8y9sA4MoSeA+OCyk6yFRk+W14HESBadXJ4eEawqRYmLPBRQOX576jLU0dgXBZDvuexU/BeIfUqtYjPY008RSKZvzaKircfVNyRUc4l2roPIn8Bz+YVByMWaiIGil
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4723
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjcvMDQvMjMgMzoyMiBhbSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cg
dGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4+IC0jZGVmaW5lIExBTjg2N1hfUkVHX0lSUV8xX0NU
TCAweDAwMUMNCj4+IC0jZGVmaW5lIExBTjg2N1hfUkVHX0lSUV8yX0NUTCAweDAwMUQNCj4+ICsj
ZGVmaW5lIExBTjg2WFhfUkVHX0lSUV8xX0NUTCAweDAwMUMNCj4+ICsjZGVmaW5lIExBTjg2WFhf
UkVHX0lSUV8yX0NUTCAweDAwMUQNCj4gDQo+IFRoaXMgcGF0Y2ggaXMgcHJldHR5IGJpZy4gUGxl
YXNlIHNwbGl0IHRvIExBTjg2N1ggdG8gTEFOODZYWCByZW5hbWUNCj4gb3V0LCB0byBtYWtlIHRo
ZSBwYXRjaGVzIHNtYWxsZXIgYW5kIGVhc2llciB0byByZXZpZXdTdXJlLCB3aWxsIGRvIGl0IGlu
IHRoZSBuZXh0IHZlcnNpb24uDQo+IA0KPj4gK3N0YXRpYyBpbnQgbGFuODY1eF9yZXZiMF9wbGNh
X3NldF9jZmcoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldiwNCj4+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGNvbnN0IHN0cnVjdCBwaHlfcGxjYV9jZmcgKnBsY2FfY2ZnKQ0K
Pj4gK3sNCj4+ICsgICAgIGludCByZXQ7DQo+PiArDQo+PiArICAgICByZXQgPSBnZW5waHlfYzQ1
X3BsY2Ffc2V0X2NmZyhwaHlkZXYsIHBsY2FfY2ZnKTsNCj4+ICsgICAgIGlmIChyZXQpDQo+PiAr
ICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+PiArDQo+PiArICAgICAvKiBEaXNhYmxlIHRoZSBj
b2xsaXNpb24gZGV0ZWN0aW9uIHdoZW4gUExDQSBpcyBlbmFibGVkIGFuZCBlbmFibGUNCj4+ICsg
ICAgICAqIGNvbGxpc2lvbiBkZXRlY3Rpb24gd2hlbiBDU01BL0NEIG1vZGUgaXMgZW5hYmxlZC4N
Cj4+ICsgICAgICAqLw0KPj4gKyAgICAgaWYgKHBsY2FfY2ZnLT5lbmFibGVkKQ0KPj4gKyAgICAg
ICAgICAgICByZXR1cm4gcGh5X3dyaXRlX21tZChwaHlkZXYsIE1ESU9fTU1EX1ZFTkQyLCAweDAw
ODcsIDB4MDAwMCk7DQo+PiArICAgICBlbHNlDQo+PiArICAgICAgICAgICAgIHJldHVybiBwaHlf
d3JpdGVfbW1kKHBoeWRldiwgTURJT19NTURfVkVORDIsIDB4MDA4NywgMHgwMDgzKTsNCj4+ICt9
DQo+PiArDQo+IA0KPiBUaGlzIGNvdWxkIGJlIGluIGEgcGF0Y2ggb2YgaXRzIG93biwgd2l0aCBh
IGdvb2QgY29tbWl0IG1lc3NhZ2UNCj4gZXhwbGFpbmluZyB3aHkgaXQgaXMgbmVlZGVkLg0KU3Vy
ZSwgYXMgUmFtb24gYXNrZWQgaW4gaGlzIHJldmlldyBjb21tZW50IHRoaXMgaXMgYWxzbyBuZWVk
ZWQgZm9yIA0KbGFuODY3eCByZXYuYjEgYXMgd2VsbC4gU28gd2lsbCBtYWtlIGl0IGFzIGEgc2Vw
YXJhdGUgcGF0Y2ggYmVmb3JlIA0KbGFuODY1eCByZXYuYjAgcGF0Y2guDQo+IA0KPiBPbmNlIHlv
dSByZXBsYWNlIHRoZSBtYWdpYyBudW1iZXJzIHdpdGggI2RlZmluZXMsIHRoZSBjb21tZW50IGJl
Y29tZXMNCj4gcG9pbnRsZXNzLiBCdXQgd2hhdCBpcyBtaXNzaW5nIGlzIHRoZSBhbnN3ZXIgdG8g
dGhlIHF1ZXN0aW9uIFdoeT8NCkFzIEkgY29tbWVudGVkIGluIHByZXZpb3VzIGVtYWlsIHRvIFJh
bW9uLCBJIGFtIGluIGNvbnRhY3Qgd2l0aCBkZXNpZ24gDQp0ZWFtIGZvciB0aGUgY2xhcmlmaWNh
dGlvbiB0aGF0IHdoeSBpdCBpcyBub3QgZG9jdW1lbnRlZC4gV2lsbCBnZXQgbW9yZSANCmluZm8g
c29vbi4NCj4gDQo+ICAgICAgICAgICAgIEFuZHJldw0KPiANCg0K
