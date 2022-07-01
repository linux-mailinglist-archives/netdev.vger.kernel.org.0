Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B817562D68
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 10:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235710AbiGAIHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 04:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235373AbiGAIHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 04:07:15 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86246F363;
        Fri,  1 Jul 2022 01:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656662832; x=1688198832;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zOI0hF6jiCoJPa8wvz2zsnOuHnT1bX214NE/v3OPwQA=;
  b=QRW+qsnLvtRvqjOtd5byxfjyri40CNZaC10bpbT0QWTlK3ZrRbEWe7bg
   okZLNuiRKyC+HKHzEF325cF7VhRWeeMsbmoQElamT5IdNDzCHThVL4L2a
   pOp2e5lvEpF4TyGsSTLQC6tTiUvySTCL2BF49uqDJxPR15BW9l01J2ayP
   /7VK66cUSxnzbbRBaMKbTMxYz50Ygn8LMB9aHetiLnPTX57lKnE4tZm9G
   4Avt2KqqLoFpwnoL3sXsA2gA3afwZ9muyxPXtHuus59s0qH4BpDY4L5V2
   +bCXYv3g3HwYvco7CUuc3qr33LP2J2N07QZzolbRZ0fhGN21NDXLxMqOv
   g==;
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="170381602"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2022 01:07:01 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Jul 2022 01:07:01 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 1 Jul 2022 01:07:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIt/I8yj/OeFD+Gcf9lSDdMoQ1uRJ2XlmjrbFqKVlruhtl6egBgpWceCyokAEK2/oWYsx/ZhwimgQ/JI7bbJIvyx+c3QnjSkFV6EfRUjoYjDfRCkkZ2PzI1AGsSpw+cNpXEbLozTjKSHCgLfi7kK+KdTdQOjx8u5e1lNU84HTwvTddhyN2fJFTPFcHqA3DnWjTVbbpGcYTZN8IW+hdcUj+nIzZ0ISfJOBvFy01mRQXh4mcqytx/EkI5YEbpQCUJlbFWMpSCI+UkgM4qcUnK23PJG+qBzx3kevvXoNoA/bjZJOm5o2geZBt4u4AsobyRtB+OY4lOCQPE+/Y1CPrucxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zOI0hF6jiCoJPa8wvz2zsnOuHnT1bX214NE/v3OPwQA=;
 b=knmlCRmx+3TZ5nbc/bBc7SEhofhSoHKenXNIyXKWCiBDwZoHXArBdSM7ldklLXJwF0Af9X/7WTijTSLQS7Y2KvZOi2kOIs6pYtG6oOOx+R7CGhyIuMC9+vQVndTPTDUGg753KjY6qLmosbhZGazR7qIdfz39x2pOQGXeRuS0xypi1F5W8lLlPP8lgO4plslz6UkWaunBkIWWYvcwkOIn624G9g3gSoWwuvcxuqrwFrPWm3MpiURjOp5w9nDaK7JHBvEmZgn/qYbGgDtJsr2cknZXR+1MQW4+K/N8SGaTzr/la7IuypbJmp/aZgxlEgCTWLewTKXuRO4cvwB33+5o1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOI0hF6jiCoJPa8wvz2zsnOuHnT1bX214NE/v3OPwQA=;
 b=Dl/cGxQAmMFtYFPWcNiAbwcJ8Nzoo12iuiAaIEwjHocXF8i6DIFaU5nL9k8z7qsMKudAruFq113u8tRc+8Q1VpaWRSwpMeg6cBYt+0vv6XNhV0Fwy96S6MJyfQc2KixxR6pY12ek+sEID1ut71HmIHRSlRO7ZHBmOAkPoypk7RA=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by BN7PR11MB2724.namprd11.prod.outlook.com (2603:10b6:406:b3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Fri, 1 Jul
 2022 08:06:55 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa%4]) with mapi id 15.20.5395.015; Fri, 1 Jul 2022
 08:06:55 +0000
From:   <Conor.Dooley@microchip.com>
To:     <Claudiu.Beznea@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <Nicolas.Ferre@microchip.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [net-next PATCH RESEND 2/2] net: macb: add polarfire soc reset
 support
Thread-Topic: [net-next PATCH RESEND 2/2] net: macb: add polarfire soc reset
 support
Thread-Index: AQHYjRgQ3x7EmTGw/U+0JO50iJROM61pI3YAgAACHICAAANIAA==
Date:   Fri, 1 Jul 2022 08:06:55 +0000
Message-ID: <3f0b6e98-e400-bfa0-9527-c188c086b588@microchip.com>
References: <20220701065831.632785-1-conor.dooley@microchip.com>
 <20220701065831.632785-3-conor.dooley@microchip.com>
 <25230de4-4923-94b3-dcdb-e08efb733850@microchip.com>
 <0d52afa2-6065-25c5-2010-46aaa0129b59@microchip.com>
In-Reply-To: <0d52afa2-6065-25c5-2010-46aaa0129b59@microchip.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e6e7e102-33a9-45ab-2f56-08da5b38aa04
x-ms-traffictypediagnostic: BN7PR11MB2724:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VBilvYNU7i5cCjamihtLyP1EhdlNkiiWKS7cTvA+aUkZT9HSKM1+8JrUUJhYpf3d1IN7AveKtK5HoB6tJyKi28g7qcrIrDGeYP1DvaVo0V0saZmecvvh0qQk2VxnmGj02VxQu30qveqOqbB7VCqq3O8QkQd8jTQivEK6AxORyA6G8YBT6w67kk+QVktVHTFLhHQgfNIZfG+IkeRhXD/4lOLbiHW8SgJlNxvDlRfKo6xGNUIwgraTiAvDNOWcL5zNsfVDgjA+fvZMq3ugKc005v+txL3cWuTJdrC8ueuqS6efWgBA33YYTsUMmBl7XENJwOJh8XA7ZxjUCLLP6WFfzZItONdFvSSW5VnEt4XNyIU1Ge7kl4HBFxVqMb/SMTxW48nRqUbB5khDQnRHhhQZJ/aW1zdxpxFdekSN7pJZLSE5xtdhSs7AFhXgNitsmJJZMzB2ld0g+K3cLEwCDWnej04uh/kIGZWTnYQ274y1SE6ObeScs4XuQDyO0M3yEI7ZBt7ojCHyTToaIzx168e8TuXw5Bp+fKT5lIJcsGe+VQkPpssmJapVhvA/HlPMh8qwEucbiqMhihOheWfGG0WU9NicouiWNLYrioRZX6IY8zEL/+RIEGlxfHE1ltVLC7FOu9yFcxWl4xKAwfbfErAi5uf/9R8uXNQy9UMzPct9QXLVafrJbIk0uV/mWRIuAYFFFe3L4sFS4HYhQk/95ob661GHc4eOlRwMFCo/JLXUs/HrcBC4Uv+zdJAqd0+P6JwOvYUtPY0Jn4y/4MJP8A4oSvzn4KQdSt1lRwqhkrxfHPyg3yquffDKp7y6rVcKFicKzZ7MW6NZA6ZAt5jpLxPelJaquRY1051e65xi8AWOmt2oZXpp1tjgQ319o923hxEg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(366004)(136003)(376002)(346002)(6636002)(2616005)(86362001)(31696002)(316002)(54906003)(8936002)(91956017)(26005)(4326008)(66556008)(66476007)(64756008)(66446008)(8676002)(76116006)(66946007)(38100700002)(6506007)(41300700001)(110136005)(6512007)(53546011)(38070700005)(71200400001)(6486002)(478600001)(122000001)(2906002)(83380400001)(31686004)(7416002)(5660300002)(186003)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXFJZE1qNWNmejhBZVJFTWVpVnJ5Z1lQbXh1UnY3RXZkZVl0N0ZCdkdzVVhl?=
 =?utf-8?B?NjdyYXBBMk9iODczSitPYnB5aTBGK3dpQlZVTnpTV041MnFOVVhaZjdOaUY3?=
 =?utf-8?B?L1N3amRHOE5UYjF3UWM3UEVHMDV0WlVEdWNoRjA5Y3VUNzRCYmhMc3lMYkZW?=
 =?utf-8?B?NG96YnVicGxJMWtRb2s5eG5wckc2a29seEJmUm0xQVRYL2ZFakI1M0FQb05s?=
 =?utf-8?B?b0ZQVlpDYVpGdzlMZ2JvdnpGbFZxWE05QkU5WE56UU5LbWMvNlJ2NWFLKzZE?=
 =?utf-8?B?NEZYL21VMWRTUGlvc2JrZnRtVjdxR1VZWnhlZURvZkhkYW5UYm9QcjlnbDdS?=
 =?utf-8?B?eWVZWkdRWnBqZjVsdnBDSW03SUVDRXFHN0Ftc2hLd0xod3k1T0hjekozRUNM?=
 =?utf-8?B?c3krcG9tYktxSkhzWGZCNUt0NDRNaUtpMXJYMjdGWGlZOHNuSmpZYzlDd2o5?=
 =?utf-8?B?dUZhR3BDRmQ5QlFlNTQzSTB6Yjc1eGl0T0tLYUFONEl6SFRGRy90ZDVKOXQw?=
 =?utf-8?B?aWo1aHVwOWI3OVFOQVNZdmpSU2w3cjRTSFdqL3pZQ1NHbm9wRVIrY2xQcHZi?=
 =?utf-8?B?SVBCeDVBK0JmaW5qeHd6YTN4b21FTHg4MzAwSGk2ZTI3cTJFM0FjbythMXBo?=
 =?utf-8?B?b3VDTkpGazVTZW9zMEEvL0F6ZkVVclE4MXpZVE94ZWVLQjQwOGZVTVZZNGhY?=
 =?utf-8?B?Ym1SVWswYlMyUEsxdXpEQ0RIeGN4SE10cnduS0tNQ0dObWZSQXY5VGtGdEwz?=
 =?utf-8?B?NHF5b3NPSHhYL2JjQ1paQUU4Ym9FbnR4clE0U2ZUbDlpUmVoOHc2V0JMbVky?=
 =?utf-8?B?bGtOcUpQVTN4QWh2azdtV1pTR2tDbUxtUnllZTBGellaNlFnaEJPUVI3aXZZ?=
 =?utf-8?B?dVdoak5TdU1nZktIaWU5emEvL2M1ckp2S2lSUUVGU1RSRG9DV0dhazM1UjFZ?=
 =?utf-8?B?ajBidXNJMjVYeGxzanZtS0ZFK20wY09MQ0I3ZUNIeUtacGFmdTVNdHQ3WEVI?=
 =?utf-8?B?WmdpM2ZpRVNxbklza1E3ajRtSFRRQlJLMUIzOW8xbnZUMTQyck02TEJ2d1pk?=
 =?utf-8?B?Nk1yb2dBNkl3QU9PM1o2NE1RMlVRaVcyQWhPbVNIdWFodnA1V3NENFJNd1Fp?=
 =?utf-8?B?UTdqTU9TWnBsdHNCdHh4aUpzTWpzZUovbHdQM3pMRTdQTVhlN214NzhseFN0?=
 =?utf-8?B?aE1TU2o2M2tQU1BqSlpwci8zVVNVWG5LOUVQSFFaMU40NEhDWi9DNkdOK0hj?=
 =?utf-8?B?OVpoSWN3aWExVUFCWE5uRmt4amJSdk82aWg5WmtNcUx0VjZWbmpHbFNJVXg1?=
 =?utf-8?B?U2pwSDRYOVlDWk0rdmNWYW1WeitFTm9vUmZDSEdsTnhGY01TTThHb3FEdVBy?=
 =?utf-8?B?c2VCNjdpTWJGQUQ3NzVJTDdJZjNXdENsNEdaeVoxTHJqVC9RS0wzNERlTDIw?=
 =?utf-8?B?Nit6dzNacEx5NjZHS25lVndlR2xPWHJKdytjdnRzUi9COHpZeVRMNXEwRSt2?=
 =?utf-8?B?bkRZMnpnTFI2WnJKSjVvU2t2cGRaS3crL0Q5K0tkeWFFSU90dVFvdzUvNHNj?=
 =?utf-8?B?bDlaRDFRV0MzNElsOEtYL2pVeEw4YXpGdHFDd3U4dk84dXZFb3plT2hPT0Q2?=
 =?utf-8?B?elNVYmJQek1ZL3p4azlYR1NwWFNPRlNOVXZZdWZlbFBsSDdqbzJBUlJNbzVt?=
 =?utf-8?B?SXgrRzdRWDBLVFR1UThNNThjQ2dncE4wUytPZ2d3N014TzQwbXRGRSsyekh2?=
 =?utf-8?B?eW54RXB5VnNQcFk2aUpOeGUwMVdZUG9NZEdZeDdWU1NlbmhRWHg0VHlXTVA1?=
 =?utf-8?B?czlkU2lyRUtVakRUYlplR1JBYURoUUFJNkJoMVllZlEyeEVJRDVPZ0phTFp6?=
 =?utf-8?B?TUpraEgxaWpQRHo3YnQvNnZXYkM1SmlPOEMzU1l6NWxFNFpTTGJpOWVzVmVD?=
 =?utf-8?B?ekpkRjM1WUttbmxXTHRIcW90RENDZ3FyamVkMmIrRTdPR081djI0Sms5ZTFl?=
 =?utf-8?B?dENwVjlTYURtRk0wbk1oeWIrMis1VDFPZU4zQzlRVEI3ZVVaZnVYRmRidGFu?=
 =?utf-8?B?Sytxa3c3bU9zajMxa3RMOUg1THdNbEU2dVJJVEdxcE83Y2pIU1pqNU9IRmJp?=
 =?utf-8?Q?25lIp0HY1KOpCEJtxu9G4rHJg?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9187F8476E3DE6418309C1D063B581F3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6e7e102-33a9-45ab-2f56-08da5b38aa04
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 08:06:55.4887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VXtylfdTksyHQkGlpdFhlnAZsmnlF3ZmVoyRvkec/JWhpUD+JY8ntVMWHp+at3wcHz7MKdlFj0OolzLCwyJkKhSNYAbbKnslUlq0rkVFs5M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2724
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDEvMDcvMjAyMiAwODo1NSwgQ29ub3IgRG9vbGV5IHdyb3RlOg0KPiBPbiAwMS8wNy8yMDIy
IDA4OjQ3LCBDbGF1ZGl1IEJlem5lYSAtIE0xODA2MyB3cm90ZToNCj4+IE9uIDAxLjA3LjIwMjIg
MDk6NTgsIENvbm9yIERvb2xleSB3cm90ZToNCj4+PiBUbyBkYXRlLCB0aGUgTWljcm9jaGlwIFBv
bGFyRmlyZSBTb0MgKE1QRlMpIGhhcyBiZWVuIHVzaW5nIHRoZQ0KPj4+IGNkbnMsbWFjYiBjb21w
YXRpYmxlLCBob3dldmVyIHRoZSBnZW5lcmljIGRldmljZSBkb2VzIG5vdCBoYXZlIHJlc2V0DQo+
Pj4gc3VwcG9ydC4gQWRkIGEgbmV3IGNvbXBhdGlibGUgJiAuZGF0YSBmb3IgTVBGUyB0byBob29r
IGludG8gdGhlIHJlc2V0DQo+Pj4gZnVuY3Rpb25hbGl0eSBhZGRlZCBmb3IgenlucW1wIHN1cHBv
cnQgKGFuZCBtYWtlIHRoZSB6eW5xbXAgaW5pdA0KPj4+IGZ1bmN0aW9uIGdlbmVyaWMgaW4gdGhl
IHByb2Nlc3MpLg0KPj4+DQo+Pj4gU2lnbmVkLW9mZi1ieTogQ29ub3IgRG9vbGV5IDxjb25vci5k
b29sZXlAbWljcm9jaGlwLmNvbT4NCj4+PiAtLS0NCj4+PiDCoCBkcml2ZXJzL25ldC9ldGhlcm5l
dC9jYWRlbmNlL21hY2JfbWFpbi5jIHwgMjUgKysrKysrKysrKysrKysrKystLS0tLS0tDQo+Pj4g
wqAgMSBmaWxlIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQo+Pj4N
Cj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4u
YyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4+PiBpbmRleCBk
ODkwOThmNGVkZTguLjMyNWYwNDYzZmQ0MiAxMDA2NDQNCj4+PiAtLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPj4+IEBAIC00Njg5LDMzICs0Njg5LDMyIEBAIHN0YXRp
YyBjb25zdCBzdHJ1Y3QgbWFjYl9jb25maWcgbnA0X2NvbmZpZyA9IHsNCj4+PiDCoMKgwqDCoMKg
IC51c3JpbyA9ICZtYWNiX2RlZmF1bHRfdXNyaW8sDQo+Pj4gwqAgfTsNCj4+PiAtc3RhdGljIGlu
dCB6eW5xbXBfaW5pdChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPj4+ICtzdGF0aWMg
aW50IGluaXRfcmVzZXRfb3B0aW9uYWwoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4+
DQo+PiBJdCBkb2Vzbid0IHNvdW5kIGxpa2UgYSBnb29kIG5hbWUgZm9yIHRoaXMgZnVuY3Rpb24g
YnV0IEkgZG9uJ3QgaGF2ZQ0KPj4gc29tZXRoaW5nIGJldHRlciB0byBwcm9wb3NlLg0KPiANCj4g
SXQncyBiZXR0ZXIgdGhhbiB6eW5xbXBfaW5pdCwgYnV0IHllYWguLi4NCj4gDQo+Pg0KPj4+IMKg
IHsNCj4+PiDCoMKgwqDCoMKgIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYgPSBwbGF0Zm9ybV9nZXRf
ZHJ2ZGF0YShwZGV2KTsNCj4+PiDCoMKgwqDCoMKgIHN0cnVjdCBtYWNiICpicCA9IG5ldGRldl9w
cml2KGRldik7DQo+Pj4gwqDCoMKgwqDCoCBpbnQgcmV0Ow0KPj4+IMKgwqDCoMKgwqAgaWYgKGJw
LT5waHlfaW50ZXJmYWNlID09IFBIWV9JTlRFUkZBQ0VfTU9ERV9TR01JSSkgew0KPj4+IC3CoMKg
wqDCoMKgwqDCoCAvKiBFbnN1cmUgUFMtR1RSIFBIWSBkZXZpY2UgdXNlZCBpbiBTR01JSSBtb2Rl
IGlzIHJlYWR5ICovDQo+Pj4gK8KgwqDCoMKgwqDCoMKgIC8qIEVuc3VyZSBQSFkgZGV2aWNlIHVz
ZWQgaW4gU0dNSUkgbW9kZSBpcyByZWFkeSAqLw0KPj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBicC0+
c2dtaWlfcGh5ID0gZGV2bV9waHlfb3B0aW9uYWxfZ2V0KCZwZGV2LT5kZXYsIE5VTEwpOw0KPj4+
IMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoSVNfRVJSKGJwLT5zZ21paV9waHkpKSB7DQo+Pj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0ID0gUFRSX0VSUihicC0+c2dtaWlfcGh5KTsNCj4+
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkZXZfZXJyX3Byb2JlKCZwZGV2LT5kZXYsIHJl
dCwNCj4+PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJmYWls
ZWQgdG8gZ2V0IFBTLUdUUiBQSFlcbiIpOw0KPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgImZhaWxlZCB0byBnZXQgU0dNSUkgUEhZXG4iKTsNCj4+PiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0Ow0KPj4+IMKgwqDCoMKgwqDCoMKgwqDC
oCB9DQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IHBoeV9pbml0KGJwLT5zZ21paV9waHkp
Ow0KPj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAocmV0KSB7DQo+Pj4gLcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgZGV2X2VycigmcGRldi0+ZGV2LCAiZmFpbGVkIHRvIGluaXQgUFMtR1RSIFBIWTog
JWRcbiIsDQo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZGV2X2VycigmcGRldi0+ZGV2LCAi
ZmFpbGVkIHRvIGluaXQgU0dNSUkgUEhZOiAlZFxuIiwNCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHJldCk7DQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0
dXJuIHJldDsNCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgfQ0KPj4+IMKgwqDCoMKgwqAgfQ0KPj4+
IC3CoMKgwqAgLyogRnVsbHkgcmVzZXQgR0VNIGNvbnRyb2xsZXIgYXQgaGFyZHdhcmUgbGV2ZWwg
dXNpbmcgenlucW1wLXJlc2V0IGRyaXZlciwNCj4+PiAtwqDCoMKgwqAgKiBpZiBtYXBwZWQgaW4g
ZGV2aWNlIHRyZWUuDQo+Pj4gK8KgwqDCoCAvKiBGdWxseSByZXNldCBjb250cm9sbGVyIGF0IGhh
cmR3YXJlIGxldmVsIGlmIG1hcHBlZCBpbiBkZXZpY2UgdHJlZQ0KPj4+IMKgwqDCoMKgwqDCoCAq
Lw0KPj4NCj4+IFRoZSBuZXcgY29tbWVudCBjYW4gZml0IG9uIGEgc2luZ2xlIGxpbmUuDQo+Pg0K
Pj4+IMKgwqDCoMKgwqAgcmV0ID0gZGV2aWNlX3Jlc2V0X29wdGlvbmFsKCZwZGV2LT5kZXYpOw0K
Pj4+IMKgwqDCoMKgwqAgaWYgKHJldCkgew0KPj4+IEBAIC00NzM3LDcgKzQ3MzYsNyBAQCBzdGF0
aWMgY29uc3Qgc3RydWN0IG1hY2JfY29uZmlnIHp5bnFtcF9jb25maWcgPSB7DQo+Pj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgTUFDQl9DQVBTX0dFTV9IQVNfUFRQIHwgTUFDQl9DQVBTX0JE
X1JEX1BSRUZFVENILA0KPj4+IMKgwqDCoMKgwqAgLmRtYV9idXJzdF9sZW5ndGggPSAxNiwNCj4+
PiDCoMKgwqDCoMKgIC5jbGtfaW5pdCA9IG1hY2JfY2xrX2luaXQsDQo+Pj4gLcKgwqDCoCAuaW5p
dCA9IHp5bnFtcF9pbml0LA0KPj4+ICvCoMKgwqAgLmluaXQgPSBpbml0X3Jlc2V0X29wdGlvbmFs
LA0KPj4+IMKgwqDCoMKgwqAgLmp1bWJvX21heF9sZW4gPSAxMDI0MCwNCj4+PiDCoMKgwqDCoMKg
IC51c3JpbyA9ICZtYWNiX2RlZmF1bHRfdXNyaW8sDQo+Pj4gwqAgfTsNCj4+PiBAQCAtNDc1MSw2
ICs0NzUwLDE3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbWFjYl9jb25maWcgenlucV9jb25maWcg
PSB7DQo+Pj4gwqDCoMKgwqDCoCAudXNyaW8gPSAmbWFjYl9kZWZhdWx0X3VzcmlvLA0KPj4+IMKg
IH07DQo+Pj4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgbWFjYl9jb25maWcgbXBmc19jb25maWcgPSB7
DQo+Pj4gK8KgwqDCoCAuY2FwcyA9IE1BQ0JfQ0FQU19HSUdBQklUX01PREVfQVZBSUxBQkxFIHwN
Cj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBNQUNCX0NBUFNfSlVNQk8gfA0KPj4+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIE1BQ0JfQ0FQU19HRU1fSEFTX1BUUCwNCj4+DQo+PiBFeGNlcHQg
Zm9yIHp5bnFtcCBhbmQgZGVmYXVsdF9nZW1fY29uZmlnIHRoZSByZXN0IG9mIHRoZSBjYXBhYmls
aXRpZXMgZm9yDQo+PiBvdGhlciBTb0NzIGFyZSBhbGlnbmVkIHNvbWV0aGluZyBsaWtlIHRoaXM6
DQo+Pg0KPj4gK8KgwqDCoCAuY2FwcyA9IE1BQ0JfQ0FQU19HSUdBQklUX01PREVfQVZBSUxBQkxF
IHwNCj4+ICvCoMKgwqDCoMKgwqDCoCBNQUNCX0NBUFNfSlVNQk8gfA0KPj4gK8KgwqDCoMKgwqDC
oMKgIE1BQ0JfQ0FQU19HRU1fSEFTX1BUUCwNCj4+DQo+PiBUbyBtZSBpdCBsb29rcyBiZXR0ZXIg
dG8gaGF2ZSB5b3UgY2FwcyBhbGlnbmVkIHRoaXMgd2F5Lg0KPiANCj4gWWVhaCwgSSBwaWNrZWQg
dGhhdCBiL2MgSSBjb3BpZWQgc3RyYWlnaHQgZnJvbSB0aGUgZGVmYXVsdCBjb25maWcuDQo+IEkg
aGF2ZSBubyBwcmVmZXJlbmNlLCBidXQgaWYgeW91J3JlIG5vdCBhIGZhbiBvZiB0aGUgZGVmYXVs
dC4uLg0Kcy9kZWZhdWx0Li4uL2RlZmF1bHQgSSBjYW4gbWFrZSB0aGVtIGFsbCBtYXRjaC4uLg0K
DQo=
