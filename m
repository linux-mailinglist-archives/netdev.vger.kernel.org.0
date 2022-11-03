Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C107D617B28
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 11:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbiKCK5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 06:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiKCK5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 06:57:23 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5C210FEE;
        Thu,  3 Nov 2022 03:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667473037; x=1699009037;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=e+wXfWDlIAoMfJL2BRrwhP5r9+xWX6Y6sDfQrPUM64o=;
  b=axpkJviyaAEVdYQGtw4j6jGAOOJ/fSjTTajBNJnsbnD96AEWw8NAmaHC
   YEQoa2+9ChMuxXUZM9RW5L/GY0nQaTWscw6DNio9qYg6XUiEBPZHNapMW
   Gce7F2p9wssqovzZvMfTFxhYWg5RsSSnUkbrqMukhM6rrjhF6fPfN1QxS
   UlkXUO7QlKGDOWrYsrgimkihcyPCVAvFr7thcF/NbuuRCXzdf4z2sVTrA
   jaXYGgD7LSS/d2vupe3e9gMcPn8UO4IIEBaBEGb61P1/p/lMFRNZAHNlX
   tXtVSoyL01ct5BhICRvgYTb8bBuC7r0Taf71rtCtVqaA86uN8sevYS64l
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="181759220"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Nov 2022 03:57:15 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 3 Nov 2022 03:57:14 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 3 Nov 2022 03:57:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QuHAhAo8uTwryPlx0YWV5aDdfGkhhUz5w5N48tQ5+KgN56vBr+TCe3rbdtVZzpRMG0NU9TnaOlz00hXLgrmBVcFsnbekD5kQqTs/mj+P87uDLgWV68PKQcn/9T8aLY77xVxjARw3SdvMOfwZqWW5bCRhvysSAUG/6aj29ehGi6NvyIVE6X7uz9K8I3RjSKfxtnG1Omq6FE4piUEg+s/4hmDkdH5gbGeEyhtgX05D4JMuFpUx9449Ik5fzkh54b+DB0XlKjVz/a5mDq5Da/q8q8LhL/PWaeI4jEe7Jdj5a3LfYB8MBF8WLqPcT/pEGctGd296JkR7lQltsFprCNJ5Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+wXfWDlIAoMfJL2BRrwhP5r9+xWX6Y6sDfQrPUM64o=;
 b=oXkdD91zlzq2ML64UGisMRtfM4jEjFegRKV+TGClqYQg2OQgsL0ICpU+OYy96fmFqsLZQa7KyJtWfh7IZq7kgixVFTairTWZIYzDH931//xKDBMPbveCbtJWTp7UfR4mG26LuU5GA/Hsc8ZzwohJiNSs5pYz0etmckwLPcx/sGYJ0EIDgPp1xlRyyONH6YKs/2Xm/HF8zDo88vUqYIXweMA5M3lDHIZg8Kr40SBpYsICtv5+RP26emTj17H1y/CFdiS9XHiO0TZ27A6q/gF5nO1MzBKM1MTjIeCHQ/bvlMkJo1rdXZ4neQIl1f0J8fuxgBgGaQBUEogCLhQM9kMezQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+wXfWDlIAoMfJL2BRrwhP5r9+xWX6Y6sDfQrPUM64o=;
 b=QV7KtHkqxs2ux126IEwbo2KpcTXDe7hdqsvPYGuBgMzW/N2X82M+vvty+P7jubIZQHAsAg7FDQ3Qq91BEfl90cPi2WQm2Hy4+AO23V8E6bz133MUnjEvKMk7pQlkHh+i3ht4uN/ZlxaBuQ79EU/IQi0b7uqobj9juPmLth4qJuo=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 BL3PR11MB5699.namprd11.prod.outlook.com (2603:10b6:208:33e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Thu, 3 Nov 2022 10:57:09 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::faca:fe8a:e6fa:2d7]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::faca:fe8a:e6fa:2d7%3]) with mapi id 15.20.5769.021; Thu, 3 Nov 2022
 10:57:08 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <o.rempel@pengutronix.de>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8: add MTU
 configuration support
Thread-Topic: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8: add MTU
 configuration support
Thread-Index: AQHY72SbCiN+lKAXEE+6MQXpjnQDXq4tBz0A
Date:   Thu, 3 Nov 2022 10:57:08 +0000
Message-ID: <0da58722ba9e451b984f8c10bb3bb04b2725d6a2.camel@microchip.com>
References: <20221103091302.1693161-1-o.rempel@pengutronix.de>
In-Reply-To: <20221103091302.1693161-1-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|BL3PR11MB5699:EE_
x-ms-office365-filtering-correlation-id: 8a803b3e-00bb-4469-c9f1-08dabd8a2746
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AHgPTNwZOCNsGXNtZD9woPo3DlGjxA//BKiwubb5W53m8Yr75A5dvV1mab11VWKaTYZ9qzB4xKAFqmuezAAekgmOhhHxHbGjg4HokU222Lnp/X/zXfXj5ZwaJtXVCUKMFlkOCVWndaCVc0id5cxczwhVVz9cMYdp7YPRxSwlwqhwp2pOroJFvV8hA8zwRRglXHejt+m7FVirsHwhDz5j0rA/N8CLTc8LdA/9rbYMPIPSHe9YwxE4x+rxYBFvpmIf9BsN7CYxeeoc75me5lA1jd5WTAfXnnbhpxCOK68HhZTRTPu3IemNnrpP0VEF8330OCA2BS4Tb0nW2U+54+0uyDtM7A0A34w44itKYrtw6t1TvEuVqkAnRzZUB82MTMkpyhzV0iYcTexdMaI6YIdQqIPzU3fWs5TQ1ucxd34UWTWtcROmnw6zDfx5Uy1ETSfXoo4VYKRWKdn6sLAR4vwBB7roY6pxMukktu0a2l954A5vwiXka8oJjcyeMan2+j71PBxFxy8U6cl5TORn/KT5yBzdh2h1jm692dvnQMsR5G3JL1Io9uMoTGiMYOPseUAgBVVsWUnbuPqJR/IDaRAo4K9wyjczvobajl4IxQ0lnMIgJkF/PWeeqIVklf6bWJkH77T5QMa+x4LOJDYWMI0G6lFLG6+ujfh4RFmnJqdBc1LzmyEJjHaU+5yDn0MsQtJ4K34abuahDbm7kvm8xGFGWGNotqDh9c43iZXkulX58dMINFlT6bFvUOza/trYy1HTy9wlVws+jSwQ0Ftc4v/3vAoltS1Wup9hK8qOcs3DujHh/ENowQmDI8HzdIyxZpVz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(39860400002)(366004)(376002)(396003)(451199015)(186003)(83380400001)(6506007)(6486002)(71200400001)(478600001)(6512007)(2616005)(26005)(316002)(110136005)(66476007)(4326008)(8936002)(64756008)(66446008)(66946007)(66556008)(41300700001)(8676002)(91956017)(76116006)(2906002)(7416002)(5660300002)(122000001)(54906003)(38100700002)(36756003)(921005)(38070700005)(86362001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bEl6am1GUUhYUVl5M0drK2NsT2pDdW5RWTBCK2VvYk55NkZLMFBHNVpSSDhp?=
 =?utf-8?B?NnRha3J3TE5QL3RlWjd2MGpPQ05PbjhNRENMZzRaNmExSUQySm54TmNSUXpj?=
 =?utf-8?B?Ny9vMEcyVWJTUFpJajFIZ2J3STZWYkR6bkt3TUhaL1hPZU1jeUMxWDZ6TVpQ?=
 =?utf-8?B?alJyU1JFaVpoYUlhQVR2aFUrUzIyZit0L3hGSGV4b25KOWFIcU1mL3ZQZ01L?=
 =?utf-8?B?TkpwWmx4NUgxdjd5QjZTaUVYRnNvSWViOUxXMUp3L3NkNGFHcjNNUVc4dTVw?=
 =?utf-8?B?VlNPU3J6NHBWMXBKS3I1NG9SdGh2ajMzWWUrZWJlcDJOUmdLVVF3c1RQQzR0?=
 =?utf-8?B?WkdFSGFOSFJKaEZySWd4cnZqS0s5M245c2RiQkp0TFQyZlFza0ZZa1BXdXZo?=
 =?utf-8?B?OVdIaWQ2QzRRVlN3UGxEWWJoWGJSYnZLei9YQThkU01xSnNiOE5sY2FRVkg5?=
 =?utf-8?B?bnprU1VWbDg1di85VDBGZUZaOEhheUFJQkpSNjliVFZuSmR4OW9ldFBYYnI4?=
 =?utf-8?B?b21sSFk5bnFCc0RIRjVPS0QxMERBempDNWxCMXZuOHZ3WSs4ZW8yWWpPV0Yv?=
 =?utf-8?B?RlBYVUpZUzNkb2x6b1ArVTRDTFdIY3VST1NkZ0VIUFRvNzEwRlFIbGFUQ05w?=
 =?utf-8?B?S3FIZFpLS3M0S3dVWkxiMGY2a1VRaFR5bXRTUlZtczNvL2FESUNyYytPRHdF?=
 =?utf-8?B?Zm14VTJ2eTFPcUNBV2pNbHdPQ2Y0Nk1UK0ppbUFvNm1sclljdWZsNGVlNUVs?=
 =?utf-8?B?QWRHVHVxR2dHd3MxeDZkVlA5aHZsU2xMNk1JUzNxdGtSVFd2b05SL0t3cnFn?=
 =?utf-8?B?TytadFFhZ05SL1VNVE9JNFpOa0JkMTQvYTREVWZBWU9qWWhBT2pDSEt3Wnhh?=
 =?utf-8?B?WGg1MzZkOUpEc3NUakdET3lnb1hENDhaYTJoUWNKbjNXNEVkTGpuRE92ejhC?=
 =?utf-8?B?blo2WGZ3RThWWDBYMkt1RlpkejJrWk1vdjN6UWczSUl0SUlHSm1aWVhpb1h2?=
 =?utf-8?B?dU81b1FoS20vbEo3SGlzWE42QVY3MzlDS1BDV05ScnRxZnltVHo3ak5Sc1pP?=
 =?utf-8?B?RXBJaGRadVM3VHpEZnJVd0kzdU5yaXk1NmdGUTVFUGNDOVR6Y1JnNXFKakJ1?=
 =?utf-8?B?M3hsQU1kUUV5RWVMcG90TkFnbDJielFCaHFoR0FmZDc4S1drLy9xQzNuS1dX?=
 =?utf-8?B?QXAyTmozZlJBZk1xMFJNRzFmVzZEYnp6b1M2TElwWUROd1Zsd3J0VGRjd2JH?=
 =?utf-8?B?eFYwV0gwTDVCTll4MFZOMEVJSUdMYmpzQUJsbjYyTmxkaWpEWFhscDF2L2FG?=
 =?utf-8?B?bUhVRVF6dUUwTC9aL1dZWS8wdE92Q0IyMWlVZEZhRU9CQnBGc3A0c3ExckFV?=
 =?utf-8?B?S1VMUjJyR1AvRmpWRUMyclpzTTBFbDkyNUZvUHYwZlZQbzBLaW1IS2F4cEpQ?=
 =?utf-8?B?NjZaTys4dnJpWk5YTGhodGszK3ZqNGpKZ2VsUWVzNVRlc1ZVNlFlMVN3eFVZ?=
 =?utf-8?B?YTR1ZWVLcGdNMFp5b0lYVE9UTW9vT2U0OVhRbTF5QUJlOUlFVXpmbWRhb0NN?=
 =?utf-8?B?alVxM0FSbXVxcCtoK2lGM3BWMEt4bjJRZ1FGcVJMd0R0U1E0SGF2alQzZ2xT?=
 =?utf-8?B?Y1pwYjB2L3Z1c09uRUlQTUJUWUVRK3gxdFFsSVNrblhIZUg4bXIreVBHRFI1?=
 =?utf-8?B?WUU2T2JiRVd3OFNIU0RJZlI0Qlg0TFRxd1lMKzVuYVA2V0tENWlrdDIzQUNE?=
 =?utf-8?B?MFpqUVNZaklxY0g4YUV6OENESEprRmJaQ3o4d1JyQnZvd29FY1VCaFlsME5v?=
 =?utf-8?B?RTg4dTBxVG5OVWlaWXlWRUtLWXIvaCtzRkZJMWs0MVF0NTdDUlg2aVJlb1c0?=
 =?utf-8?B?cGNiWkU4L2lRY2lEVGt6cDdUeXVYVS9mWENRS25YQUltTGtzUWlXcUZoNEhv?=
 =?utf-8?B?LzJ5MVJpU2dSenRaWkpHNW5lNTZTbERxMTBKRGF0bnU3Y3BvditHSk5WYUlx?=
 =?utf-8?B?RlNVWnNBL3IzUU9USUprT1ZwbElFekFUeGtmNE5UVThSNFNFMU9OSGkrcWhp?=
 =?utf-8?B?aTdJdWpmV2RwZzJaazZ1RGlqd1dXWU1MUmFrajBGYy9OdjRuNnY4ZDJCVFhm?=
 =?utf-8?B?R0xIK2YyajNhOXlrMFd5QmpudkRnbTc5M3VEMHFjbnkzRk1NdE9YTlVUb3Fa?=
 =?utf-8?Q?QqSumos4SaKWvngP5TG+8/M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <077DC947B9F72B4EAA80AEB2B320B873@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a803b3e-00bb-4469-c9f1-08dabd8a2746
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 10:57:08.7964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: opTM8oz0lSGT58aqIzUR0eAU2rMLHVD7BUYDBXZEvP3OH8uyVX7LVdFHZdtwfXUmb5W+AS6YxSCdRt7OYNvS4xc0T9BFVkULBjSq9WIOkWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB5699
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KT24gVGh1LCAyMDIyLTExLTAzIGF0IDEwOjEzICswMTAwLCBPbGVrc2lq
IFJlbXBlbCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiBNYWtlIE1UVSBjb25maWd1cmFibGUgb24gS1NaODd4eCBhbmQgS1NaODh4eCBzZXJpZXMg
b2Ygc3dpdGNoZXMuDQo+IA0KPiBCZWZvcmUgdGhpcyBwYXRjaCwgcHJlLWNvbmZpZ3VyZWQgYmVo
YXZpb3Igd2FzIGRpZmZlcmVudCBvbiBkaWZmZXJlbnQNCj4gc3dpdGNoIHNlcmllcywgZHVlIHRv
IG9wcG9zaXRlIG1lYW5pbmcgb2YgdGhlIHNhbWUgYml0Og0KPiAtIEtTWjg3eHg6IFJlZyA0LCBC
aXQgMSAtIGlmIDEsIG1heCBmcmFtZSBzaXplIGlzIDE1MzI7IGlmIDAgLSAxNTE0DQo+IC0gS1Na
ODh4eDogUmVnIDQsIEJpdCAxIC0gaWYgMSwgbWF4IGZyYW1lIHNpemUgaXMgMTUxNDsgaWYgMCAt
IDE1MzINCj4gDQo+IFNpbmNlIHRoZSBjb2RlIHdhcyB0ZWxsaW5nICIuLi4gU1dfTEVHQUxfUEFD
S0VUX0RJU0FCTEUsIHRydWUpIiwgSQ0KPiBhc3N1bWUsIHRoZSBpZGVhIHdhcyB0byBzZXQgbWF4
IGZyYW1lIHNpemUgdG8gMTUzMi4NCj4gDQo+IFdpdGggdGhpcyBwYXRjaCwgYnkgc2V0dGluZyBN
VFUgc2l6ZSAxNTAwLCBib3RoIHN3aXRjaCBzZXJpZXMgd2lsbCBiZQ0KPiBjb25maWd1cmVkIHRv
IHRoZSAxNTMyIGZyYW1lIGxpbWl0Lg0KPiANCj4gVGhpcyBwYXRjaCB3YXMgdGVzdGVkIG9uIEtT
Wjg4NzMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBPbGVrc2lqIFJlbXBlbCA8by5yZW1wZWxAcGVu
Z3V0cm9uaXguZGU+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4Lmgg
ICAgICAgIHwgIDIgKw0KPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4Nzk1LmMgICAg
IHwgNzQNCj4gKysrKysrKysrKysrKysrKysrKysrKysrLQ0KPiAgZHJpdmVycy9uZXQvZHNhL21p
Y3JvY2hpcC9rc3o4Nzk1X3JlZy5oIHwgIDkgKysrDQo+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9j
aGlwL2tzel9jb21tb24uYyAgfCAgMiArDQo+ICA0IGZpbGVzIGNoYW5nZWQsIDg1IGluc2VydGlv
bnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNh
L21pY3JvY2hpcC9rc3o4LmgNCj4gYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejguaA0K
PiBpbmRleCA4NTgyYjRiNjdkOTguLjAyN2I5MmY1ZmE3MyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4LmgNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL21pY3Jv
Y2hpcC9rc3o4LmgNCj4gQEAgLTU3LDUgKzU3LDcgQEAgaW50IGtzejhfcmVzZXRfc3dpdGNoKHN0
cnVjdCBrc3pfZGV2aWNlICpkZXYpOw0KPiAgaW50IGtzejhfc3dpdGNoX2RldGVjdChzdHJ1Y3Qg
a3N6X2RldmljZSAqZGV2KTsNCj4gIGludCBrc3o4X3N3aXRjaF9pbml0KHN0cnVjdCBrc3pfZGV2
aWNlICpkZXYpOw0KPiAgdm9pZCBrc3o4X3N3aXRjaF9leGl0KHN0cnVjdCBrc3pfZGV2aWNlICpk
ZXYpOw0KPiAraW50IGtzejhfY2hhbmdlX210dShzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQg
cG9ydCwgaW50IG10dSk7DQo+ICtpbnQga3N6OF9tYXhfbXR1KHN0cnVjdCBrc3pfZGV2aWNlICpk
ZXYsIGludCBwb3J0KTsNCj4gDQo+ICAjZW5kaWYNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2RzYS9taWNyb2NoaXAva3N6ODc5NS5jDQo+IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9r
c3o4Nzk1LmMNCj4gaW5kZXggYmQzYjEzM2U3MDg1Li5mZDI1MzlhYWJiMmMgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6ODc5NS5jDQo+ICsrKyBiL2RyaXZlcnMv
bmV0L2RzYS9taWNyb2NoaXAva3N6ODc5NS5jDQo+IEBAIC03Niw2ICs3Niw3OCBAQCBpbnQga3N6
OF9yZXNldF9zd2l0Y2goc3RydWN0IGtzel9kZXZpY2UgKmRldikNCj4gICAgICAgICByZXR1cm4g
MDsNCj4gIH0NCj4gDQo+ICtzdGF0aWMgaW50IGtzejg4NjNfY2hhbmdlX210dShzdHJ1Y3Qga3N6
X2RldmljZSAqZGV2LCBpbnQgcG9ydCwgaW50DQo+IG1heF9mcmFtZSkNCj4gK3sNCj4gKyAgICAg
ICB1OCBjdHJsMiA9IDA7DQo+ICsNCj4gKyAgICAgICBpZiAobWF4X2ZyYW1lIDw9IEtTWjg4NjNf
TEVHQUxfUEFDS0VUX1NJWkUpDQo+ICsgICAgICAgICAgICAgICBjdHJsMiB8PSBLU1o4ODYzX0xF
R0FMX1BBQ0tFVF9FTkFCTEU7DQo+ICsgICAgICAgZWxzZSBpZiAobWF4X2ZyYW1lID4gS1NaODg2
M19OT1JNQUxfUEFDS0VUX1NJWkUpDQo+ICsgICAgICAgICAgICAgICBjdHJsMiB8PSBLU1o4ODYz
X0hVR0VfUEFDS0VUX0VOQUJMRTsNCj4gKw0KPiArICAgICAgIHJldHVybiByZWdtYXBfdXBkYXRl
X2JpdHMoZGV2LT5yZWdtYXBbMF0sIFJFR19TV19DVFJMXzIsDQo+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBLU1o4ODYzX0xFR0FMX1BBQ0tFVF9FTkFCTEUNCj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgS1NaODg2M19IVUdFX1BBQ0tFVF9FTkFCTEUsDQo+
IGN0cmwyKTsNCj4gK30NClN1Z2dlc3Rpb246DQpyZWdtYXBfdXBkYXRlX2JpdHMsIGNhbiB5b3Ug
Y3JlYXRlIGEgbWFjcm8gbGlrZSBrc3pfcm13OCBzaW1pbGFyIHRvDQp3aGF0IHdlIGhhdmUga3N6
X3BybXc4IGluIGtzel9jb21tb24uaC4gU28gdGhhdCBpdCBjYW4gdXNlZCBhY3Jvc3MgdGhlDQpr
c3ogYW5kIGxhbjkzN3ggc3dpdGNoZXMuDQoNCj4gKw0KPiArc3RhdGljIGludCBrc3o4Nzk1X2No
YW5nZV9tdHUoc3RydWN0IGtzel9kZXZpY2UgKmRldiwgaW50IHBvcnQsIGludA0KPiBtYXhfZnJh
bWUpDQo+ICt7DQo+ICsgICAgICAgdTggY3RybDEgPSAwLCBjdHJsMiA9IDA7DQo+ICsgICAgICAg
aW50IHJldDsNCj4gKw0KPiArICAgICAgIGlmIChtYXhfZnJhbWUgPiBLU1o4ODYzX0xFR0FMX1BB
Q0tFVF9TSVpFKQ0KPiArICAgICAgICAgICAgICAgY3RybDIgfD0gU1dfTEVHQUxfUEFDS0VUX0RJ
U0FCTEU7DQo+ICsgICAgICAgZWxzZSBpZiAobWF4X2ZyYW1lID4gS1NaODg2M19OT1JNQUxfUEFD
S0VUX1NJWkUpDQo+ICsgICAgICAgICAgICAgICBjdHJsMSB8PSBTV19IVUdFX1BBQ0tFVDsNCj4g
Kw0KPiArICAgICAgIHJldCA9IHJlZ21hcF91cGRhdGVfYml0cyhkZXYtPnJlZ21hcFswXSwgUkVH
X1NXX0NUUkxfMSwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgU1dfSFVHRV9Q
QUNLRVQsIGN0cmwxKTsNCj4gKyAgICAgICBpZiAocmV0KQ0KPiArICAgICAgICAgICAgICAgcmV0
dXJuIHJldDsNCj4gKw0KPiArICAgICAgIHJldHVybiByZWdtYXBfdXBkYXRlX2JpdHMoZGV2LT5y
ZWdtYXBbMF0sIFJFR19TV19DVFJMXzIsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIFNXX0xFR0FMX1BBQ0tFVF9ESVNBQkxFLCBjdHJsMik7DQo+ICt9DQo+ICsNCj4gK2ludCBr
c3o4X2NoYW5nZV9tdHUoc3RydWN0IGtzel9kZXZpY2UgKmRldiwgaW50IHBvcnQsIGludCBtdHUp
DQo+ICt7DQo+ICsgICAgICAgdTE2IGZyYW1lX3NpemUsIG1heF9mcmFtZSA9IDA7DQo+ICsgICAg
ICAgaW50IGk7DQo+ICsNCj4gKyAgICAgICBmcmFtZV9zaXplID0gbXR1ICsgVkxBTl9FVEhfSExF
TiArIEVUSF9GQ1NfTEVOOw0KPiArDQo+ICsgICAgICAgLyogQ2FjaGUgdGhlIHBlci1wb3J0IE1U
VSBzZXR0aW5nICovDQo+ICsgICAgICAgZGV2LT5wb3J0c1twb3J0XS5tYXhfZnJhbWUgPSBmcmFt
ZV9zaXplOw0KPiArDQo+ICsgICAgICAgZm9yIChpID0gMDsgaSA8IGRldi0+aW5mby0+cG9ydF9j
bnQ7IGkrKykNCj4gKyAgICAgICAgICAgICAgIG1heF9mcmFtZSA9IG1heChtYXhfZnJhbWUsIGRl
di0+cG9ydHNbaV0ubWF4X2ZyYW1lKTsNCg0KVGhpcyBwb3J0IGNhY2hpbmcgc25pcHBldCBpcyBw
cmVzZW50IGluIGtzejk0NzdfY2hhbmdlX210dSBmdW5jdGlvbg0KYWxzby4gSXQgY2FuIGJlIG1v
dmVkIHRvIGtzel9jaGFuZ2VfbXR1IGFuZCByZW1vdmUgaXQgaW4NCmtzejk0NzdfY2hhbmdlX210
dS4gDQoNCj4gKw0KPiArICAgICAgIHN3aXRjaCAoZGV2LT5jaGlwX2lkKSB7DQo+ICsgICAgICAg
Y2FzZSBLU1o4Nzk1X0NISVBfSUQ6DQo+ICsgICAgICAgY2FzZSBLU1o4Nzk0X0NISVBfSUQ6DQo+
ICsgICAgICAgY2FzZSBLU1o4NzY1X0NISVBfSUQ6DQo+ICsgICAgICAgICAgICAgICByZXR1cm4g
a3N6ODc5NV9jaGFuZ2VfbXR1KGRldiwgcG9ydCwgbWF4X2ZyYW1lKTsNCj4gKyAgICAgICBjYXNl
IEtTWjg4MzBfQ0hJUF9JRDoNCj4gKyAgICAgICAgICAgICAgIHJldHVybiBrc3o4ODYzX2NoYW5n
ZV9tdHUoZGV2LCBwb3J0LCBtYXhfZnJhbWUpOw0KPiArICAgICAgIH0NCj4gKw0KPiArICAgICAg
IHJldHVybiAtRU9QTk9UU1VQUDsNCj4gK30NCj4gKw0KPiAraW50IGtzejhfbWF4X210dShzdHJ1
Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQgcG9ydCkNCj4gK3sNCj4gKyAgICAgICBzd2l0Y2ggKGRl
di0+Y2hpcF9pZCkgew0KPiArICAgICAgIGNhc2UgS1NaODc5NV9DSElQX0lEOg0KPiArICAgICAg
IGNhc2UgS1NaODc5NF9DSElQX0lEOg0KPiArICAgICAgIGNhc2UgS1NaODc2NV9DSElQX0lEOg0K
PiArICAgICAgICAgICAgICAgcmV0dXJuIEtTWjg3OTVfSFVHRV9QQUNLRVRfU0laRSAtIFZMQU5f
RVRIX0hMRU4gLQ0KPiBFVEhfRkNTX0xFTjsNCj4gKyAgICAgICBjYXNlIEtTWjg4MzBfQ0hJUF9J
RDoNCj4gKyAgICAgICAgICAgICAgIHJldHVybiBLU1o4ODYzX0hVR0VfUEFDS0VUX1NJWkUgLSBW
TEFOX0VUSF9ITEVOIC0NCj4gRVRIX0ZDU19MRU47DQo+ICsgICAgICAgfQ0KPiArDQo+ICsgICAg
ICAgcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiArfQ0KPiArDQoNCkludGlhbGx5IEtTWjk0NzcgaGFk
IHRoZSBtYXhfbXR1IHdoaWNoIEkgdXNlZCBmb3IgdGhlIExBTjkzN3guIFNpbmNlDQp0aGVyZSBp
cyBubyBtdWNoIHRoaW5nIHRvIGRvIGluIHRoaXMgZnVuY3Rpb24sIHdoeSBjYW4ndCB3ZSBtb3Zl
IGl0DQprc3pfY29tbW9uLmMgYW5kIGFkZCBjaGlwIGlkIGZvciBrc3o5IGFuZCBsYW45Mzd4ICYg
cmVtb3ZlDQprc3o5NDc3X21heF9tdHUuIEl0IHdpbGwgcmVkdWNlIHRoZSBtYXhfbXR1IGZ1bmN0
aW9pbiBwb2ludGVyIGluDQprc3pfZGV2X29wcy4NCg0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+IGIvZHJpdmVycy9uZXQvZHNhL21p
Y3JvY2hpcC9rc3pfY29tbW9uLmMNCj4gaW5kZXggZDYxMjE4MWIzMjI2Li40MGZkNzg5NTFiZjgg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+
ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+IEBAIC0xNzEs
NiArMTcxLDggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBrc3pfZGV2X29wcyBrc3o4X2Rldl9vcHMg
PSB7DQo+ICAgICAgICAgLnJlc2V0ID0ga3N6OF9yZXNldF9zd2l0Y2gsDQo+ICAgICAgICAgLmlu
aXQgPSBrc3o4X3N3aXRjaF9pbml0LA0KPiAgICAgICAgIC5leGl0ID0ga3N6OF9zd2l0Y2hfZXhp
dCwNCj4gKyAgICAgICAuY2hhbmdlX210dSA9IGtzejhfY2hhbmdlX210dSwNCj4gKyAgICAgICAu
bWF4X210dSA9IGtzejhfbWF4X210dSwNCj4gIH07DQo+IA0KPiAgc3RhdGljIHZvaWQga3N6OTQ3
N19waHlsaW5rX21hY19saW5rX3VwKHN0cnVjdCBrc3pfZGV2aWNlICpkZXYsIGludA0KPiBwb3J0
LA0KPiAtDQo+IDIuMzAuMg0KPiANCg==
