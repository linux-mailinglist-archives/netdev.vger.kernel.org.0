Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D06564EBE
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 09:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbiGDHbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 03:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbiGDHbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 03:31:36 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8937641;
        Mon,  4 Jul 2022 00:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656919894; x=1688455894;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zbAUD6fadqclYFuRXrCbTtQTkre6yZHPQRpd0VGAmnU=;
  b=R3YAtVLsOuqmYeUfi3Xa2YE1LeXk5rSLRV9eEUHd71sUG91EoNTtqaAP
   uJlFIEPFPVM27tp7iC/V9CygF8yzHPtYyVGaJ8XZ5kcHA1dFKBebi2sLl
   B4ua4sZjpk3guWoR2eFKdsMKqzH/g2RTBJdP9xGBYV/eEDdL48FolXgzj
   nRbvYl+VAbvYaFaexdNCMya9X4VX/350VQEo2Omiop0/eQWIHOsys8iQE
   U7pEZsXuDCs3r4ojnKEsL18ufjdzfsal6HSe4kE2oGNIlyipjycTvzTSF
   Rx4zNudMLZgy2zp0LqX3gVXttC5+4aKSE7Tcd6wRuPDZKzSsnmfk8Uw/c
   g==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="163168047"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jul 2022 00:31:33 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 4 Jul 2022 00:31:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Mon, 4 Jul 2022 00:31:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yz6mNTTxhcnbLIiF0VXpCbE7FH4hU56Uac2ELZQhXiQipp/QnzTqHJ7kwxywk80ireV7KaK00N0eV1HWKy9DaRlnip6T2a/xQBNPm/FtWL+/eolSG7hGnWvuSEuxJmkdsZkxuzqWlwZNTdmbVo+efmkAr9kHqh2poC7Pg4+z/TBxDaxhO/v3TYM4COkN//EL2jfS0wQSApxGwxH473D254eqxdTRlm8MJLrjVv6YJIGdCBlfcPYaiERKV55EHxHlou0mtIuEJyZqlgpB+27JnsMMxT0lCGj3EZRuVYZu015wkWhZfh0IhSENZoQmNyWsXr9YNdpOK/ZAelAxia1gHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zbAUD6fadqclYFuRXrCbTtQTkre6yZHPQRpd0VGAmnU=;
 b=SCTG9To+kYk5x1/+TtDW2KT/wsd1w9FlRwbbMFJTDeuzS9G9v7DwpY3R9ZNO6VSvIcELs9kWAcSGqRmxNJSzIpZEP7uDqJ8nyNdgYl4/yeNmXby3WepGDsZpO+z7kL5SscnjSXfrqKaJQcIHM6SHgdxEZtTvYsceyYLsEXt+buF19Wbb5uVh8nVmwrSZsfOfds4RWFl4HuZWhPEB70UkfvTuctpWzDhUSbc6C+eQfSwrq3adpyHWB9/HbhIKQyY3BtTcCUtW7H3S8L6suj1hP2U0Sx6TpLboqK4QzlTdEpC3JZoP1Ly5gtLLN+rly7L0MC7KSZfjFh4tILQ0INyNWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zbAUD6fadqclYFuRXrCbTtQTkre6yZHPQRpd0VGAmnU=;
 b=NnoqbMMeHcr+GfxRHfmVWjo9EFPhFMrUnUy+QK3vkCovARGlu1xV6V3bJ1Cp3o4kMJYodE+TY2BSPfQievZadRNC2W/0S1FndG4Hck73WyvdMdKWrHcDJYbVk3kb152Kib43/SnEg3FxOKFXPYGPg9Oj+hYBYaiFxjm+ANcORYA=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by BN9PR11MB5308.namprd11.prod.outlook.com (2603:10b6:408:119::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 07:31:27 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa%4]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 07:31:27 +0000
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
Thread-Index: AQHYjRgQ3x7EmTGw/U+0JO50iJROM61pI3YAgAACHICAAhLLAIAClvEAgAAGpwA=
Date:   Mon, 4 Jul 2022 07:31:27 +0000
Message-ID: <ac368e4c-9846-af79-d342-98b10a2735a5@microchip.com>
References: <20220701065831.632785-1-conor.dooley@microchip.com>
 <20220701065831.632785-3-conor.dooley@microchip.com>
 <25230de4-4923-94b3-dcdb-e08efb733850@microchip.com>
 <0d52afa2-6065-25c5-2010-46aaa0129b59@microchip.com>
 <06936f06-88d5-e3e2-dc23-9d4a87c0bf5e@microchip.com>
 <7306d7c3-fab1-e645-e996-c1f281979fe1@microchip.com>
In-Reply-To: <7306d7c3-fab1-e645-e996-c1f281979fe1@microchip.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 345d8ad4-a591-4713-54f3-08da5d8f34db
x-ms-traffictypediagnostic: BN9PR11MB5308:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 92ODzphHjOJg/QSj15dcyvdrHfqqTSyHhQYJ46mCnFcxRtqxSA7904DeMYvz/VTXV/P4Hz+iLXrhFlFINI7TY7ZjrSW+uC9QkBSuoNXWZaT5vfxe3DbSjz+ibiiwM+WZFDo9lMBMvIBHOXMR/GC/b3EZO/HcYsKM4WRUCOgx64Xb6AsAU8fuoU8y3do8URbOBqErkVRMy0Hrc/y/ZtzAUgR7Dq9tu/PbZfQ4tSlAsne2NIev2Lv8B7bTlTMeUipznFpA+EBA8pved6adbL//hN2aG1dZUtC6G0G/uRAqFMOC8MwcgbhJ8WuqYrtriQtH1ecVsgLwkUP6CDnjQXY4lIR4y4RPKgwUgT0BXEiDTQWjTUA+hcS8FKzOt0WYsHiHKG+vqt6AWNdXDqf5+UfGT16EU9iHhrGkBUiKTMUIujtbaHorTyY6odLELi+zWensgCWKhynjwr/DsTu+GmhQsThYNFbEtCQuaqQK7E8F/vCIOFnpTovQBtasiFtbHX2LBNCJ95bg3DoO20I6Cx2sTek4VKtqbX68K1Pn7WlUM9nJHyAD6XVmLI26y2x0UJkWZOVJl04qwz1U6BvzhHiW9Brz0+wulrjn/rhnZu1m/xmFSlIqJotj3WaQBros+nSfxtHO4BFuNJEyZz1DTnMRWnRu6rCMyt0MGqyXJXgFnFrTDdtO/Kc9sxbNuSFlHxpwA25PfTZn0sB1TQqduE95cUPeBSnX7DHuMgbWzXg4l2YqP0zYvRQQknofeDVjtUyBblayu1WdgbxaufN0AieKtRPO/mExMQsjEAbPVt6zJA3ivHMZku2nULlgZFdKWd+TK4aE+eCT+8ydc9gQJICAnkB5PabXafYbgMmedL6NHhviWeX9I/8EK1eEclNfFFbd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(136003)(396003)(346002)(39860400002)(7416002)(6486002)(8936002)(478600001)(53546011)(6506007)(5660300002)(31696002)(6512007)(26005)(2906002)(41300700001)(86362001)(122000001)(38100700002)(2616005)(186003)(38070700005)(83380400001)(54906003)(91956017)(6636002)(4326008)(71200400001)(36756003)(64756008)(66476007)(76116006)(8676002)(66556008)(110136005)(66446008)(316002)(31686004)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDNDL3FLUU9pKzR6U3V4SE9IL29IZnk0T0hOUFIxTlh5VVNNRCtiMjNHSktm?=
 =?utf-8?B?VnhQaFMxMUE4a2FqTTBPWGgraThUWmp2enBFdmVsNU5VOE5NMDcyQjNFem1L?=
 =?utf-8?B?WWZ2RDRZNXJ0cVRkd2JwbkhnYURjSnBreFcwTHJQNStYcDJIQWY5ZXRiSXhk?=
 =?utf-8?B?OUswcXRzaWF1ei9DK2I1eU5oaTNvWDlPZ2tacTdJRnJCSkFiQWxvVEk1am9p?=
 =?utf-8?B?Q1l3U1IwbmREcks3WWVaVTNHUXVuZVFET1owdEhCTGRlYVNXM0tQUE5GZTUx?=
 =?utf-8?B?a0VMcXR4Z0hTdE00OUF1bGZnRGlaUGRWU2ZVZEk3eGM4ZkgrWTFZcVE3akor?=
 =?utf-8?B?KzcxdFJBK0hHNUswdUlWcGY1V1NQK2cyRVozZ0E2UzlqUVpDdUJxNzZGTXNj?=
 =?utf-8?B?VWxsaG9IbmFacERWVExZUk92UkNmb3BiaStYS0t0ci95Z1RZcEV0MjZoREVS?=
 =?utf-8?B?Y2x4ejIwakRQWENPUFQzb3ZRaUJwRzVEKzlwdEM4c1NDQ1FWWG1kamt3WnE4?=
 =?utf-8?B?L2tOdzVBcWorVjMzeFh4WjhHRUR4VUpna3NJb2QrajZvVUhFMGV0THlrK3U4?=
 =?utf-8?B?SndHYjh0ajFISVZNV0VDMWh1QWQ3c1VQL2lhdkFyMDFRTVYwS2pBaHlrOXR0?=
 =?utf-8?B?L0xZTVAzMW0ySkIvTEZGMm5DTFFVQXQ5U1FJdStpNU9rMVpSQmpsRmx4THlB?=
 =?utf-8?B?SDRDdjh6NmVXbWd1WnMzQ1drb0JCcXJoTVI2b1dyV1Y3Q2EwWlJBekFJWUxQ?=
 =?utf-8?B?TXdsQlhEL2NtaFpnMS9nQ1dML08xZlVpdlBzN1N3SytjMUdGVUNjaEY4UnBG?=
 =?utf-8?B?UC9XRVdCTEhnbjhWemJXbGV2WXdZRVFIeFdjbngxZjUvdFNvRE9kMGFiNXJZ?=
 =?utf-8?B?cjF3TTV0ajQvelNhbnQ1Q1JZakNValFXQnlYMDNmZmlZT09WcUZ4bDBTb1kz?=
 =?utf-8?B?NWQ2L05YNnFDeEd0Q0lwNDgxeERCS2JGRk0xNkM5bktjNHBEbTloV1ZEN1JQ?=
 =?utf-8?B?eHU5cUlDdW82TTlha2NpZThFanZ4UzA2aHRmZFltcXFlSEtzYVAwbTA1bWdW?=
 =?utf-8?B?S2NMb2tGd085QVd1V2tXUFRMZVhRQ2lLNEIvbkRSM3dGWlM5ZXVOK292K0Q1?=
 =?utf-8?B?OS8wUi91dFVhVitlcVFOT2YySXFCazc1VTc1K0o3Szg5aEk5elk3TFhyc2pu?=
 =?utf-8?B?QWRQYVczSnM3VHNGQ1l0Nm9teERkQ3IvTVdsTFpOTW5zS1d4SVV4ZmVJa1Y1?=
 =?utf-8?B?OStvUGhMNUoxRlBoR0UyZysxQXNOVlRhbUlRRWFERitMRlJ2UHk3cExtOFhi?=
 =?utf-8?B?Z25lS2tISXI2d2R3UFFNODVNQ0x2LytTM2NyYzBJT01ZS2p1MUM4U3RicjVR?=
 =?utf-8?B?QVM4YWFLT3VIK2lPaDVpYVJocktWczYxdjZ6VTRjeEt2K2g4bzhUdlBURnMz?=
 =?utf-8?B?bW9WaTJyaXd5TWVkVGx5NlJzTWFla200UllVYjRGZHREbmpEd0wrL1VZUzcx?=
 =?utf-8?B?cnZYL2NndHJUa3BnV3BObjlZaHE1MVkreGNHdWRFWHU3WU9uTy9jdG9LOS9X?=
 =?utf-8?B?Rk1QOVJBeGtBMEtJanFlb1FlRHJmN04vU1o5MkUzK3RidjdweklSODZNRWxy?=
 =?utf-8?B?cW9RZkgxenp4aGUrMCtvdEtCMVlob1ZodUVhell0a3ZMcTFDelBvUFFVRTFX?=
 =?utf-8?B?QzlEZXJ5ZkdoaTJRbjhqQ3BpY0xQSXlZUjVDakFtWitIaWZKc0RvUEozZEdh?=
 =?utf-8?B?MlVkemZnU3MyUWpyTGo2OU9aQlNjU3pBQXZ1d2NHSzRObzlHWHNsbmsyUmdR?=
 =?utf-8?B?VmJIYWtvUHExd1I4STJpVE9wNXRoOU1NUnpmcmdWUG5tc0hjV1FhYmphQXFQ?=
 =?utf-8?B?NUYxMmVlMlhnK3J0UUk1R3ZwVStDRlBzOXk5cThTQmE0ZE9jZGY1UFA0YjhD?=
 =?utf-8?B?L1RCcDBPZUxEcjEyWmsxK0QzREVxMGNjblBicGtRVWdxbjdBdDYyMmsvYVRM?=
 =?utf-8?B?Z2U4N1ZEQUljb1hVZHRYVE4wRkowNU9nZkExSytJb09kRUt2OWhtM3BjTkZr?=
 =?utf-8?B?ck1hWEZHYVk1OEVybEFOQTMrc0lkTHhzTEpCZzRnMEVBU2MvekEwcHBSR25D?=
 =?utf-8?Q?gkbz1E+KywBrwqPpbtvTGuEKe?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ADAA3591323DE44C8A15EDDD8193B9FD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 345d8ad4-a591-4713-54f3-08da5d8f34db
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 07:31:27.4530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gAhO5wsJ30xNNRxAmxJWBQd6GJ+3qXAlkDxPLPBnY/T6qvl0YcAvXqBtbP207uNS2skjG0FMWVn3vIOaXz6sY4cJndz6m76lqHBLlKYjLh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5308
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDQvMDcvMjAyMiAwODowNywgQ2xhdWRpdSBCZXpuZWEgLSBNMTgwNjMgd3JvdGU6DQo+IE9u
IDAyLjA3LjIwMjIgMTg6MzQsIENvbm9yIERvb2xleSAtIE01MjY5MSB3cm90ZToNCj4+IE9uIDAx
LzA3LzIwMjIgMDg6NTUsIENvbm9yIERvb2xleSB3cm90ZToNCj4+PiBPbiAwMS8wNy8yMDIyIDA4
OjQ3LCBDbGF1ZGl1IEJlem5lYSAtIE0xODA2MyB3cm90ZToNCj4+Pj4gT24gMDEuMDcuMjAyMiAw
OTo1OCwgQ29ub3IgRG9vbGV5IHdyb3RlOg0KPj4+Pj4gVG8gZGF0ZSwgdGhlIE1pY3JvY2hpcCBQ
b2xhckZpcmUgU29DIChNUEZTKSBoYXMgYmVlbiB1c2luZyB0aGUNCj4+Pj4+IGNkbnMsbWFjYiBj
b21wYXRpYmxlLCBob3dldmVyIHRoZSBnZW5lcmljIGRldmljZSBkb2VzIG5vdCBoYXZlIHJlc2V0
DQo+Pj4+PiBzdXBwb3J0LiBBZGQgYSBuZXcgY29tcGF0aWJsZSAmIC5kYXRhIGZvciBNUEZTIHRv
IGhvb2sgaW50byB0aGUgcmVzZXQNCj4+Pj4+IGZ1bmN0aW9uYWxpdHkgYWRkZWQgZm9yIHp5bnFt
cCBzdXBwb3J0IChhbmQgbWFrZSB0aGUgenlucW1wIGluaXQNCj4+Pj4+IGZ1bmN0aW9uIGdlbmVy
aWMgaW4gdGhlIHByb2Nlc3MpLg0KPj4+Pj4NCj4+Pj4+IFNpZ25lZC1vZmYtYnk6IENvbm9yIERv
b2xleSA8Y29ub3IuZG9vbGV5QG1pY3JvY2hpcC5jb20+DQo+Pj4+PiAtLS0NCj4+Pj4+ICDCoCBk
cml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jIHwgMjUgKysrKysrKysrKysr
KysrKystLS0tLS0tDQo+Pj4+PiAgwqAgMSBmaWxlIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyks
IDcgZGVsZXRpb25zKC0pDQo+Pj4+Pg0KPj4+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNl
L21hY2JfbWFpbi5jDQo+Pj4+PiBpbmRleCBkODkwOThmNGVkZTguLjMyNWYwNDYzZmQ0MiAxMDA2
NDQNCj4+Pj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMN
Cj4+Pj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4+
Pj4+IEBAIC00Njg5LDMzICs0Njg5LDMyIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbWFjYl9jb25m
aWcgbnA0X2NvbmZpZyA9IHsNCj4+Pj4+ICDCoMKgwqDCoMKgIC51c3JpbyA9ICZtYWNiX2RlZmF1
bHRfdXNyaW8sDQo+Pj4+PiAgwqAgfTsNCj4+Pj4+ICDCoCAtc3RhdGljIGludCB6eW5xbXBfaW5p
dChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPj4NCj4+IEkgbm90aWNlZCB0aGF0IHRo
aXMgZnVuY3Rpb24gaXMgb2RkbHkgcGxhY2VkIHdpdGhpbiB0aGUgbWFjYl9jb25maWcNCj4+IHN0
cnVjdHMgZGVmaW5pdGlvbnMuIFNpbmNlIEkgYW0gYWxyZWFkeSBtb2RpZnlpbmcgaXQsIHdvdWxk
IHlvdSBsaWtlDQo+PiBtZSB0byBtb3ZlIGl0IGFib3ZlIHRoZW0gdG8gd2hlcmUgdGhlIGZ1NTQw
IGluaXQgZnVuY3Rpb25zIGFyZT8NCj4gDQo+IFRoYXQgd291bGQgYmUgZ29vZCwgdGhhbmtzIQ0K
DQpDb29sLCBJJ2xsIHJlc3BpbiB3aXRoIGV4dHJhIHBhdGNoZXMgZm9yIHRoZSBjbGVhbnVwLg0K
VGhhbmtzIGZvciB0aGUgcmV2aWV3IENsYXVkaXUgOikNCg0KDQo=
