Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71ED956200D
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 18:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236184AbiF3QPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 12:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbiF3QPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 12:15:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269A52CDD4;
        Thu, 30 Jun 2022 09:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656605701; x=1688141701;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=38wpP472NNqEHvzarPWdx/e/5E1BwQAh+f43cU302xc=;
  b=bu2QFzSiOkbrhWmPJd+1OCtOG7Dlhm12Lpra6wZiZzvTrDWX0ZH2zxUA
   ywYFcR/6BO8VJxZRQ43dpSaB/zG7QP9uu+660JMuE1hnHpexFoW+zrfiX
   cXs3tTYaIM1wlrFeE0whlT9zGCywhuzeT3cUaSSGCn7uG9UbnYhTkUEM2
   5O1wUwDu3Iwm6aJCHvyXBLoMzklb2znHscVacDOYO6Bv2B8wnPH3Qd2em
   geaZzLQ5uY2rmTtn2Kfm4DSk/omoXbNJRWWEwgh+qucLmjkJx0Ny6nNQe
   +x1NjHQyVSnuelYwPwq+/5teZwZ+6G9dXcKUo34OS9/j/qhqDHEYT7PHb
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="165864983"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 09:15:00 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 09:14:58 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Thu, 30 Jun 2022 09:14:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tw30Gfj3fMb9Bz60ToJWALVccln/6eCbgg/+cwCtQ9UzrciUJjVaX46A04roZIqqVVuCSPCDLZaHHLZm7Iiiu+NHvoKPkyTIHSSswGRyQFyX0ySOYY9DrsHYkV+I6vjZab3J13Vy/FpIOP8on4cSyCPMImsuLm/RoxKmnCa3mg2OMJEL5J0WPLkJA+Mpw44GPIDE7mcIXVyvM4MuGINs9yWGfjuhiuWISvW2OIFGe8QRkC05NYDuURWDSltGIkF7f9pJDOs45+atpvnoB0KQ3nVIWQwRD/RQH7Qvl1PxCBPNpqi5pyAy9BELVFacLR8R1AzU6c/h9N1oTwkYx7HvUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38wpP472NNqEHvzarPWdx/e/5E1BwQAh+f43cU302xc=;
 b=PmQ3VtFYUi0Dx+y972eNGS9y6dByJJogFNyVene7Hj7J7qHim/ywa4H3qKUws+ueR3hlUm0peoBiUpRmV00MKB7b42W+21SgX2WIpzoG/VrMUPRC2HphW2RQC5l7VKFJaOL68hI39ioVbiDZTcdA2q+EqDlI9hhrryIHdHLAKI7vUYrpgs7QdZtI94VPTQ+lD8JBXhXqo76iOIIanOFByT0MPm/3KPAEBGiG4ghkiUgebgylZmCoQKle6dSOwXG5Uy/C3lxSgCMLjYLyVlmXMdy/mbTWgedCRMasVt1tINJGkYUSORWGydWeqeKhlOzO8xmPUbgH3IMZ09zVs6Jlyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38wpP472NNqEHvzarPWdx/e/5E1BwQAh+f43cU302xc=;
 b=aAZmOzt1fqd4Vsxsm116G1yafr6AUdwENgh9gGReaknM+wQAmB+SbDN+R9RJErkI63H+qGa/mhTAyC63QRQMD7cLH+gPbscLzzY3cp1BcXDHxiFrpKCrYwoqUwJJvMJCDTT1Y9+9TB3uSgPgYMgkUoToTz3TA/SclICpl6PEXag=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by SA0PR11MB4669.namprd11.prod.outlook.com (2603:10b6:806:99::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 16:14:44 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa%4]) with mapi id 15.20.5373.022; Thu, 30 Jun 2022
 16:14:44 +0000
From:   <Conor.Dooley@microchip.com>
To:     <kuba@kernel.org>, <Conor.Dooley@microchip.com>
CC:     <mturquette@baylibre.com>, <sboyd@kernel.org>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <palmer@dabbelt.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <p.zabel@pengutronix.de>,
        <Daire.McNamara@microchip.com>, <paul.walmsley@sifive.com>,
        <aou@eecs.berkeley.edu>, <linux-clk@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH v1 06/14] net: macb: add polarfire soc reset support
Thread-Topic: [PATCH v1 06/14] net: macb: add polarfire soc reset support
Thread-Index: AQHYjFieX6Ai7Q3lb0SEXd+X8fuVXK1oHNwAgAADdwA=
Date:   Thu, 30 Jun 2022 16:14:44 +0000
Message-ID: <33819f26-58c6-8c2d-e74d-a6c1497bb5f6@microchip.com>
References: <20220630080532.323731-1-conor.dooley@microchip.com>
 <20220630080532.323731-7-conor.dooley@microchip.com>
 <20220630090220.7ee5c7a7@kernel.org>
In-Reply-To: <20220630090220.7ee5c7a7@kernel.org>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d68a3db-566e-4057-ba2d-08da5ab3a551
x-ms-traffictypediagnostic: SA0PR11MB4669:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dd77Vaj1aPNlVoMKJn+CJL7iBTxmnys10MPzkelVE5H6LRzUz3yS4dkcIYshIXp2wwvYzH9wp9gQv6x6Lw68Z8SNHAsO7CjO55SmMjNOg/Ln1I8V+MZmhLlxurNcLGTvQ3xA5qI8jSVvJv1F9j5l+u+GIzl+Q/eHh3Hd5U0uSFsMzw9/b/UVQ4EyK+i7f/A73BCirBB+zKRO5N3z/7ckHID9towcB3KI3JAjMn6uKmUgh0wbbg3v2jlQaSMvSmWJlvSTq5PDSu7RxoFg3oAfxwaqHJo5k/4RsHdrQPpn+uIIGbqP2HuIt2uTa6Ow5aKA/DxSp32gUIv9He86ndbEJEObec02VFzgj2zPZFSMqpyJcwZJlOGze3p6dUF6avO+8AJfe0ISsfj85AztHGgTP4LdYs+3kahwoJsJH8+tD+3ulA2TRH6IQgEYlCAvMBVPyqlG8J3zUY8NC3nT73wUJxDwLylE0lqTujARjPL3DtxLO9KxxcBYYWPm6CNc4d0X6fUZ6mIK5U2UZtT/byVI5qT+VdIxaX5n+KvBxIOi/jZIuzuKwSVwBw+fQIYOd84yuowzwWQzWw0iPTPEHPmcx2woEGhmvccX25upkYVuC8v/Ef7DJ3xICJrp4IRcSU3HoJGWrVWNFw6DS/hyame6b/3FNhByKEkM1RTA9IY0RnaczV6zhlx0Qg4+EHwRvHhrhFSToSmk8AjBB8iVg21vEqC5SsEdt8XPgsbFTDOs2dvv5/BeN/nOwT+If7RBJXkWjL4hafIqk6zsXf3bwUweuHBBhq+uDTYOptEy8Gd/R0X3zmm5/5b5Fwab17FL+ywc/8vevyY2DkRqfSYauTS+i3ulpCCFHWKqB7umciSpcO1x7kt7pK7P68uOMxazYWvZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(366004)(396003)(346002)(136003)(31686004)(38100700002)(36756003)(316002)(66946007)(4744005)(7416002)(8936002)(64756008)(38070700005)(110136005)(122000001)(91956017)(66476007)(76116006)(66556008)(66446008)(8676002)(4326008)(71200400001)(54906003)(186003)(478600001)(53546011)(6506007)(2906002)(26005)(41300700001)(6512007)(2616005)(86362001)(6486002)(31696002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3RuZkVGVUV2OTg5UkNQL09TbnE2RDFuSDNrZXVjb1FzbWtpMG5FQ2kxRzd1?=
 =?utf-8?B?SjVTT1lRNXpPVlR6N3o0L28yZlRxMGl5TS9nSS93UHhTZjVDQ3U3NmlTLzJC?=
 =?utf-8?B?YjlFclp5QnBTbGQzNmJTUlV4VEJOcUtIRG0yMkhRWUdZZDNwbmJlNmRjK1Zw?=
 =?utf-8?B?YWEzR2d0VWNveXBOR1d2V01KQ0tvMUFGREJqN2JoSkxCRGoxUmlXTXc0bGQ4?=
 =?utf-8?B?VFFQYVROMnREVGNjTDlhOWhpeURQSkdQaGtCZ21iUFlKK0Jldk1CQ3lIUEEy?=
 =?utf-8?B?Z3dOMldFeHFnVE11VnlTZFV5NVJqb2hIdnJmNXJaU1NWU2xFM0RkZVJFY0Zt?=
 =?utf-8?B?SklZTzY3TFZWc1dQWVRucWJ6VFp0K1lQYzRWbDRpRU80QkQ2T2Zsc1Qzc3U3?=
 =?utf-8?B?blEvZnpyQ0c4Z0FsRTJOYkVjOGlVMHhkaGZrTlprR3Z0MkYyc0xyNklvcmRk?=
 =?utf-8?B?UU5aZU5vTFlCQk4xU01mV2JucUZTblN3dVFGZXVUMjlNWWFjbEpBTFVVWUl3?=
 =?utf-8?B?TWFSNVB5OWdJR1MwQ1VOZnN0ZzVtWVhkc1FVSC9HMlNWNDdlanp6YldvdFpn?=
 =?utf-8?B?U3ZUWDY4UERaUS9YYlZRbWlKREJIVXZOZm1QTHQ2WWE5ODdnK1dnQ3BwZWdX?=
 =?utf-8?B?UkRqMWpYc1p5SkcwWm9nQzZyeXNvQVk5ZDNRdU9PVWxDYnQzV2g2S0xMVko4?=
 =?utf-8?B?Q3pacVVucytSTEFjTFQrS1dWT1p3dDJMOXQyYzdVUmJUcU1RM3lNdjhkWURk?=
 =?utf-8?B?WTQ5Yndwb3hoR0hzZjVDVXhVcnlKRVZPVzZMTFRYcWZ1Wnd1cHorR1hMZHNj?=
 =?utf-8?B?MTMvNGloNW5GeFFvNWtxbmxVWWpqcG9LUkMwL3dJbUxIN2E0SjNNNTZzblhE?=
 =?utf-8?B?NTZjdmNhbWZhcFFleGdtcDVGdUJiSFk5MlFJNURyeEJwWFF1UE0rV2o1c2g0?=
 =?utf-8?B?M1I0OEN3TldFeHdMbHlvdHZCcElsUFZ3OVVkWmpCVTRRUFYwbEhNNk5rQ0RP?=
 =?utf-8?B?MGtoR1lmZGJLTjNVUG96d3QrWHhxTFVHMTI5dHRvKzU0TUdzQ3lVOCtmY2VL?=
 =?utf-8?B?OWxOa01XRkFCYUd5aW5UVU5vL2pzOE5OcTloM2llcGl0aEhiS21tSjI3ajhV?=
 =?utf-8?B?U3VUYmNRMVNxSm5NcFI1SkFzYlQwRDNnWmkzbUJDVjZpaVh2UUIrYWNERFR3?=
 =?utf-8?B?RnBhRDJpUkx0NEo1WTRnWWlvc0NFTjEvL3BkdEFHM3g4eWZ2RkR5M0UwYXZ3?=
 =?utf-8?B?TnlESXRyN2Z4bnN2UjdVRmRVT09lTVNjemJnYUVGU0N4QzJtdklialNQeFFN?=
 =?utf-8?B?SzZ4QWJZTFB1T2RJN2MrRUplMjM0ZDdDVXdIcDZDOEVXZ2oySmVVZk1ZV1Fq?=
 =?utf-8?B?ZC9vWCtMU2Y4VFhyc0ZzVW5ReVV6SS9JS0dCODZoVUxTY3JKcEJZcUFkdHR1?=
 =?utf-8?B?eDRHbkdXUmNsOFllOWFoWHd2SlMxa08xRTErSTlyTVBYcnhoNjlDRk5jMWVL?=
 =?utf-8?B?c2swUW5paUFScDNCZHkzazlYUHlKdFBMZ093TFdCSXI4TVBYbmVkNVZ0SzV4?=
 =?utf-8?B?NGdKa3Yrb0FWKzdFWWdwUG9BVkNpa1hnRUJjZGhFZjhBaGFTMEdkQk9NaHdW?=
 =?utf-8?B?NnVtUjZjMVhHd1pmSFlpRyt4MGVmYnloTlRkWFZ3U25pSitPMXB5Qkk5UmZ3?=
 =?utf-8?B?VGt6NDdROE5vbUljbTI5QjZTc3BITHRYMEpVcVYybFZ3SGU3WFRUYnRIVVpu?=
 =?utf-8?B?TFRVc1RIbW9CUEYwS0NlUGVwS1ZIZnlNTUVjRlROQ0hyK24zVnVoUktXemJ4?=
 =?utf-8?B?dlZEQnpQWXZpdDRNUnhRTUhDb1FrUEVTSlFUanB4Mi9ZNGxmb0N5TVZjdFdr?=
 =?utf-8?B?bGpzNnhBak9BVGk3TkVoNGw4TTVoQU15bU9nVXpiRlhXbjk3V0kxd2s4Y1ZR?=
 =?utf-8?B?TXozMDY2SHQvek1vMUZNTFVuVDNWU3JhYTBqSlJoNzBUemlmd0QxK0M3ai9q?=
 =?utf-8?B?MXV5SlZCTjR0NTNKQkJyQUtEWFM0MUp2cEJTdG13YW1ZUWVWOThkUU9Od0Uv?=
 =?utf-8?B?Y0RlbEtrd3BHT0lOVGo5UjRSempndjZMTlJPSWdNbkRFNEc3R2t5dUNpM3I4?=
 =?utf-8?B?U0VrMXpyWmtRV1R5Lyt5ejc5b1IwYVo2aUhJOTJVRTlGUFZjYzdNZmIybWdz?=
 =?utf-8?B?R1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71DD8E1837453E49A2A7D24B28DD5EBB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d68a3db-566e-4057-ba2d-08da5ab3a551
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2022 16:14:44.5120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V+vHbw39xrTe7kPdLVcOTczBp5YuzoWJNUxT5VhcsJhQIVTgSGWf/cbDbKU7uuDdbCD6YluLPq01vwkJEq+Kt4lc6mwMtfPpheDohKwz2fs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4669
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMzAvMDYvMjAyMiAxNzowMiwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIFRodSwgMzAg
SnVuIDIwMjIgMDk6MDU6MjUgKzAxMDAgQ29ub3IgRG9vbGV5IHdyb3RlOg0KPj4gVG8gZGF0ZSwg
dGhlIE1pY3JvY2hpcCBQb2xhckZpcmUgU29DIChNUEZTKSBoYXMgYmVlbiB1c2luZyB0aGUNCj4+
IGNkbnMsbWFjYiBjb21wYXRpYmxlLCBob3dldmVyIHRoZSBnZW5lcmljIGRldmljZSBkb2VzIG5v
dCBoYXZlIHJlc2V0DQo+PiBzdXBwb3J0LiBBZGQgYSBuZXcgY29tcGF0aWJsZSAmIC5kYXRhIGZv
ciBNUEZTIHRvIGhvb2sgaW50byB0aGUgcmVzZXQNCj4+IGZ1bmN0aW9uYWxpdHkgYWRkZWQgZm9y
IHp5bnFtcCBzdXBwb3J0IChhbmQgbWFrZSB0aGUgenlucW1wIGluaXQNCj4+IGZ1bmN0aW9uIGdl
bmVyaWMgaW4gdGhlIHByb2Nlc3MpLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IENvbm9yIERvb2xl
eSA8Y29ub3IuZG9vbGV5QG1pY3JvY2hpcC5jb20+DQo+IA0KPiBQbGVhc2UgcmVwb3N0IDIgYW5k
IDYgc2VwYXJhdGVseSB3aXRoIFtQQVRDSCBuZXQtbmV4dF0gaW4gdGhlIHN1YmplY3QuDQoNCkF5
ZQ0K
