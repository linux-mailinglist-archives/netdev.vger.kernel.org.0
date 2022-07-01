Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEE25637B9
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 18:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbiGAQWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 12:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiGAQWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 12:22:16 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5BF3CA40;
        Fri,  1 Jul 2022 09:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656692534; x=1688228534;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kKYsXffn6HfynDK8LPkLfFJ0rS311cQXK0svujjUjwI=;
  b=hoib0NTad4h9N5jG7rZp8Zrt1KUfQ9fkg8WDAYm43djGypO4K5jQoQNm
   LlfoMs9HxkM5u877V/H08oO0zugl+pyasURXKDNNElu2+eCV7w51tR3+c
   guw+Uuu1P8Wf5YAyN9OSogMxbpFs5KPJHdo8FL+YVZnkqpOmfimmk8nSx
   tcE7g43GdliDjzTHK/H4P2XZhPwUkVCsQ/MGJBZx9ZQfoI9RLYL36WsCA
   KQgU+92tRkqGmMd3Ik0IXkUhn1UeG458xsZFm4YK49tp0AhsQ2VVy01mv
   FAHizKK/iWhWJ5595W6Xjr8g6pcl48B9Mth+lF/xJmRX2XN6Qfmw549j8
   w==;
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="166036782"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2022 09:21:00 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Jul 2022 09:20:57 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Fri, 1 Jul 2022 09:20:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fuB0wlBp8s0LOaPjx1sH+gtDR1KK5kh7kq2v96rcmd6A+6WZMmAssY9ZAg267GCCuuEcJqsBFR2bYIDRMDd0mXu22mvAhSEDcQTBoKxaoVVckl6tjF/H5iasmTlDbPTaIQGyuu6b6SQ5JsLXYeJ+2FRUdhPUu6Xc+GZjYHBqNrpaLRHgqqzY7FvdbmlDDb6AWdHEuoM2fP4G662GOxvmggLHU1HyfH1DkwK223kvnrM2i/MZx4APPinDgxSjs8OfInGg3X07TJKJ/AyRe0p0ldfcj/JJQeDwVtCcnb7nk0e0lKn65y61CJSE7EnxlI34Tz1okJOQ0mvnqoNE0+0PJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKYsXffn6HfynDK8LPkLfFJ0rS311cQXK0svujjUjwI=;
 b=ab5rpifQye2VqRB6Z/4ws+csl4kzPMkFAx+yZruqz1H9Oyc/9AoefTeUa/OkRElpmpnsGKUsg6sXokNZywxq/XgPHpjm3Wev+kcxhT2/PCEZuXJy9n452EQWk/k4aDpkYNIlwu7brk1sQApc5Af6JNiDPA126EkM8vnnoYO5wKLaTHO6fH4vaBJaoa9bWklirT+Vnh207mRcOO42amSN6wsryAHrv/uNOKd9ZOIiwbxlwG8IQPH/jsc+TYkONamAjHU3wiUJftI3R2Ll00xm5B6HmGa8ZNYy0kkG1QBc/Rw3NINZQhSV2Sk3taftUvyiJhSOW0Kt5/YVIpK5Okf5Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKYsXffn6HfynDK8LPkLfFJ0rS311cQXK0svujjUjwI=;
 b=e33vmbfHLsA+PbrgtaH64E4cDjRgQUgbCq/2JpZT60S4csKfB3TEmm/ecviG1b7kfkx7k+COIsoS8TIsCU0UlY1aR3hQevMWZsSpnArPB3GSK8lTwcJ2HAe23VsTmo8IDbhvaXiV0JN6MmkaGfHdZcuNdU0StZvqmlZxQyT42PM=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by CO1PR11MB4929.namprd11.prod.outlook.com (2603:10b6:303:6d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Fri, 1 Jul
 2022 16:20:52 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa%4]) with mapi id 15.20.5395.015; Fri, 1 Jul 2022
 16:20:52 +0000
From:   <Conor.Dooley@microchip.com>
To:     <p.zabel@pengutronix.de>, <mturquette@baylibre.com>,
        <sboyd@kernel.org>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <palmer@dabbelt.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <Daire.McNamara@microchip.com>
CC:     <paul.walmsley@sifive.com>, <aou@eecs.berkeley.edu>,
        <linux-clk@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH v1 04/14] reset: add polarfire soc reset support
Thread-Topic: [PATCH v1 04/14] reset: add polarfire soc reset support
Thread-Index: AQHYjFiLUdivMuF33kSysKGuotnsQq1nqk8AgAB3kwCAAZJ8gA==
Date:   Fri, 1 Jul 2022 16:20:52 +0000
Message-ID: <df782fe9-4c2d-5df7-f3ba-78eae6f0cfbd@microchip.com>
References: <20220630080532.323731-1-conor.dooley@microchip.com>
 <20220630080532.323731-5-conor.dooley@microchip.com>
 <813a3b51f82a11a86bd3af2c3299c344e08e8963.camel@pengutronix.de>
 <eed577e2-b416-dfea-a830-2c037e34ac64@microchip.com>
In-Reply-To: <eed577e2-b416-dfea-a830-2c037e34ac64@microchip.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0bbd6ec8-29bd-4a3f-483f-08da5b7daacc
x-ms-traffictypediagnostic: CO1PR11MB4929:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p3VpKVYFwoGw2wewbtk9dnWNd1DMcNpKxHZc5Z+XlS+ZS7Kvar6yGPFMqfrvxzDPbBpo+fSiVT323QXl3kVSJHYiAvBH7ALzzWWYpny6/Fm6gZhJ3JHojvEKxEaV/ERiUgLoI2xV3qeIC1YF0Gvopo1DbkGNMoXE4d3kFJyKCuhP4K6Sb2wRqIG9oAIv21Q99x8eo3yrLWXHAy7LvGeHOhbIUZLi9QaBrnHjPdVXgU56UayrW5921e+yCoBOWaV/Pr9ukbdwpCK6Y/OAkssN4/M5C+We3t9iyRj703TcHu+PACjIp1QKbHYnJZNevcmrwF0oq2BAbH6uAckjCOWTJ0ftfHCt3J19YZSoORAwcrAucIxrqjT4hATykfpwXdrCHPasMX+5JojKRv6L5EwGXPkzEG/Wp+/D6vmuRAPVMKFxMVPwRc2UeQFBg+RSQ9NxBAJpegxtLY68rnekcSRol93HkJE4sxVEULNsoI1+V9d2MDgtji+WyUiXekzEoxeQetSOF12qwS9rW1W/sYZDw4J5v7MizKTteDP1FYT+iRGMpPympKk/sqx8N0gOB7CPPrpKWAMQjQjUcI9OcqLJYPE9oMsfqihTrzHc1Myrt7ThrdE9EWg8ncjHLHD9aT/eq6fmz+UV6DSey8KI66vtHy0SKVwuChuxjOe3N3bbIKXlh/FAhhUrtgrCLE8qptUMBSV661/gzn4T8ypeAhqOHf5USUEVsvzJYx2aTWsyxzPLAd8Z+4WldgxYArNfb3sWaxmrbOPwL2/TejQskJ0eTLGDBQW/MBxvtt40TQUTVKldyDxgzgGyLzm9bQWJqUt226o7O9w0Eszd+39Je2EF1GQMaVlEwWR7x7mzB+y9Cir1qH23mCsUP3cb8eHH2yV8xyoHA0rEC4SMrOnIzRqUNw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(376002)(346002)(366004)(396003)(66446008)(83380400001)(921005)(31696002)(478600001)(86362001)(36756003)(66946007)(38070700005)(38100700002)(122000001)(71200400001)(6636002)(110136005)(186003)(2616005)(53546011)(5660300002)(41300700001)(54906003)(6506007)(26005)(6486002)(6512007)(2906002)(7416002)(8936002)(76116006)(66476007)(316002)(8676002)(91956017)(64756008)(4326008)(31686004)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFE4c201VG1JR2VSaERRUWxyOFVleWVwRFdCd2tiOUc0aGRCOUp1eWFZSTJU?=
 =?utf-8?B?V0ZqQmZpRjRiU1NqMFRpTEZYTHliSmQvOHVIdy9HWjBFeG5OVC91amVnWVI5?=
 =?utf-8?B?cEdJa2RVZWNOM05TQ0xWVlNmOUdKVWVRR2djcTFXQmhUSTVCTkNHbXhGajlu?=
 =?utf-8?B?RTNjQ3FwWFpNVjd1aU0xZzJKcnovWC9YL2lQMWZuZzNGZ1pjcVoydVFJUmZw?=
 =?utf-8?B?MTlxOExtY3phR1d4UTdaWFVBQWhqblZWQXVtems3NlhNS0ZMUmU4R0RWNUgr?=
 =?utf-8?B?T041YXFMN09KbUhUZFBSMUo0MVVpd3JDb0lrN3FMdnd4MXpyRnkvT0VGZzNv?=
 =?utf-8?B?YzFlQnJJMnoxR3ZrTEtCeVk3ZlpLUGw1TENzTFp0Q1JQVXhiYkFjcTZybk5L?=
 =?utf-8?B?NHpJYmhQbGQ5S08vOCthQlh6Z3k4QVU4UzlIdmRNdmtBOUNzL1lNc1hvM3Yw?=
 =?utf-8?B?TW9rUXdrT2dCY2JoZ3hYMHhub1pna0U0NjFGL0k5emp4ZThSYkR1a0czMklO?=
 =?utf-8?B?OHc1bWlUcTl2Q3pTak9hWm84WGNBcW1naVI4WEROVWhXdC8rcDBpQ09Gcm54?=
 =?utf-8?B?QVFiVjM1OFFXeUZFZ0dMcHZZN2k5Q3NQWlRKTnU4dVNqNnQ2MzhBbktvMlMy?=
 =?utf-8?B?R3dJc1lNekpYcWNyeVgxQkQ5TWpHdHh4UHRjMHVLL29IdC9FVnNQdVltNFdP?=
 =?utf-8?B?TTNRdWZEemdSVmQ4UEkvUHYzYlRwUnNGRnhNVm4yTVpPcjVnQWJSQWVmbW1s?=
 =?utf-8?B?dERwZ1VVNlc2NzBRT3Q3anI0WGYxT3QySFpCMzJpN3QzenlLRXUzRjlLM25Y?=
 =?utf-8?B?Y0xvNUxvQ2UwQjdtbUp3VTJEaXEyYzFrTDdSZDg4L3VxdkQ2V1kyazY3RzU2?=
 =?utf-8?B?Q3l2YWdRZGNxTU1OMHRISzJaMHRGWVl2R1ZnbWRjMXR0SlFlN2Z0QjlSeTll?=
 =?utf-8?B?YUdYMWVKaHIveURyV2ZKbE8wTFYyZkovRVFtakkzQUtaTUtRV1Q3N1B5QlVj?=
 =?utf-8?B?NXk0STRSQ3p4QjhHK1E0eDl2czREaTEyV05sRy9qNERSNlpzcXlMWGtpVzB2?=
 =?utf-8?B?Q0cvRkdqUitxQzlHK2d1cXcyWlVoTWZBaTJqOWVSTk1Yajc3TVZyOXVVSjFm?=
 =?utf-8?B?UUVaMTRqTUF3MG1mdm9GQnpyMkJlNitkM0NmMnkwTkVmTVJlMVRnWmFqYU9Z?=
 =?utf-8?B?R2hjd2V6TkFvajVCbnZhT05TdlVzS0JNaFFBMmRnK0VaalNtbHlPcmxlMjNW?=
 =?utf-8?B?SWVrVkFMamg4bW8rODJGNXhxb0M3Q3YzeEhNcVVZZCtpeDZ3d1RJYzIwL0R1?=
 =?utf-8?B?ci9WWmhuOHRseVJZTTFia0p4eGl6TkJXbWFpRWtoUXY5d1FXM0FWUUhUYVZj?=
 =?utf-8?B?OTJiS2x1WnJNWnJsQzV3NS8va0ZGR3hnSFIyZHJWU3A3eStmdm1xTWVzSXcx?=
 =?utf-8?B?cHFZdk40dXZMNXBxVFlXbXk2N2s1WEloVUovMmg1SjJuMHRQOWI4eGRKM1Bj?=
 =?utf-8?B?emJ4dklveUVsK1c0K0s3MVpqdlFGRElWYnFMVTlaRjBSYlRwemR1M1UyWU13?=
 =?utf-8?B?TGt6MTNBdVVUVnBGV3JuYWpKS21IbU5sUWlYYXl2N0ZKc0NsTUtBUGc5U2hU?=
 =?utf-8?B?dGFHRitzMGhma1hwYVdpQ2QyVjBYMHNVYzRMUzFSQnM5MzBnNitrTmg5RThq?=
 =?utf-8?B?aWhkUnRib0Rlc2RrclRoM1pFdTAyMWNoQnhiT0k5TCtpQi9VQ29pdGFBZUxq?=
 =?utf-8?B?dWRDbk9hOHlCMlZhK21rUE1VN0dNdGFOR1AyRnFTZGtrZXh2ZzV6QUZSWS9Z?=
 =?utf-8?B?QnNmUUNLdTd1SFMxNlVUUjhYcXhtOWIxN0lNbU1ibGJvbzBUOVNwQ2xVbndk?=
 =?utf-8?B?YUFzN2RENmM2MDhsZjU1UVh4eWdObjc0WkNGenFPNS9mWE1DTjhxaWwvV0M2?=
 =?utf-8?B?THRlZU4wYzFoUUVrRlhxMS80ZXFRSm4rajlhM1UxR085aEdTbTh3aGQ0OUtw?=
 =?utf-8?B?aC9qSVc2eE5ralJZdmVNM1R4SXpWNlM1dGZBVTcvWURIcW5zZ0ZDQXVENWVu?=
 =?utf-8?B?eTJic3FKZGY0Um5oNHY3bEhoWGNMU3NjSUdjVTdzYW5PeEs3eU9nS0FEMTAx?=
 =?utf-8?B?UURraGhnNU9YdWZJd3FHc0dSRVVBTFNjWGVMendJUFdZMnRHQlBKRThBaGlF?=
 =?utf-8?B?Unc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE42C0446F923F409B9F277F9F03179C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bbd6ec8-29bd-4a3f-483f-08da5b7daacc
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 16:20:52.0276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cHT+kuu3EHWS+4v17BnYsl3C+SGdvurPCVWC6ziy2vZzJvARKOBlUW2VUWPCC9ZS49fcFSIWs8cX3H96lKDr47k+d9AYZuPCfpDObygtxDc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4929
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMzAvMDYvMjAyMiAxNzoyMCwgQ29ub3IgRG9vbGV5IC0gTTUyNjkxIHdyb3RlOg0KPiBPbiAz
MC8wNi8yMDIyIDEwOjEyLCBQaGlsaXBwIFphYmVsIHdyb3RlOg0KPiANCj4gKFRoaXMgY2FtZSB0
byBtZSBvZGRseSBxdW90ZWQsIHNvIEkgaGF2ZSBmaXhlZCBpdCBteXNlbGYpDQo+IA0KPj4+IEVY
VEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxl
c3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPj4+DQo+Pj4gSGkgQ29ub3IsDQo+Pj4N
Cj4+PiBPbiBEbywgMjAyMi0wNi0zMCBhdCAwOTowNSArMDEwMCwgQ29ub3IgRG9vbGV5IHdyb3Rl
Og0KPj4+IEFkZCBzdXBwb3J0IGZvciB0aGUgcmVzZXRzIG9uIE1pY3JvY2hpcCdzIFBvbGFyRmly
ZSBTb0MgKE1QRlMpLg0KPj4+IFJlc2V0IGNvbnRyb2wgaXMgYSBzaW5nbGUgcmVnaXN0ZXIsIHdl
ZGdlZCBpbiBiZXR3ZWVuIHJlZ2lzdGVycyBmb3INCj4+PiBjbG9jayBjb250cm9sLiBUbyBmaXQg
d2l0aCBleGlzdGVkIERUIGV0YywgdGhlIHJlc2V0IGNvbnRyb2xsZXIgaXMNCj4+Pg0KPj4gZXhp
c3RpbmcgICAgICAgICAgICAgICAgICAgICBeDQo+Pj4NCj4+PiBjcmVhdGVkIHVzaW5nIHRoZSBh
dXggZGV2aWNlIGZyYW1ld29yayAmIHNldCB1cCBpbiB0aGUgY2xvY2sgZHJpdmVyLg0KPj4+DQo+
Pj4gU2lnbmVkLW9mZi1ieTogQ29ub3IgRG9vbGV5IDxjb25vci5kb29sZXlAbWljcm9jaGlwLmNv
bT4NCj4+PiAtLS0NCj4+PiAgZHJpdmVycy9yZXNldC9LY29uZmlnICAgICAgfCAgIDkgKysrDQo+
Pj4gIGRyaXZlcnMvcmVzZXQvTWFrZWZpbGUgICAgIHwgICAyICstDQo+Pj4gIGRyaXZlcnMvcmVz
ZXQvcmVzZXQtbXBmcy5jIHwgMTQ1ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysNCj4+PiAgMyBmaWxlcyBjaGFuZ2VkLCAxNTUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQ0KPj4+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9yZXNldC9yZXNldC1tcGZzLmMNCj4+
Pg0KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Jlc2V0L0tjb25maWcgYi9kcml2ZXJzL3Jlc2V0
L0tjb25maWcNCj4+PiBpbmRleCA5M2M4ZDA3ZWUzMjguLmVkZjQ4OTUxZjc2MyAxMDA2NDQNCj4+
PiAtLS0gYS9kcml2ZXJzL3Jlc2V0L0tjb25maWcNCj4+PiArKysgYi9kcml2ZXJzL3Jlc2V0L0tj
b25maWcNCj4+PiBAQCAtMTIyLDYgKzEyMiwxNSBAQCBjb25maWcgUkVTRVRfTUNIUF9TUEFSWDUN
Cj4+PiAgICAgICAgIGhlbHANCj4+PiAgICAgICAgICAgVGhpcyBkcml2ZXIgc3VwcG9ydHMgc3dp
dGNoIGNvcmUgcmVzZXQgZm9yIHRoZSBNaWNyb2NoaXAgU3Bhcng1IFNvQy4NCj4+Pg0KPj4+DQo+
Pj4gK2NvbmZpZyBSRVNFVF9QT0xBUkZJUkVfU09DDQo+Pj4gKyAgICAgICBib29sICJNaWNyb2No
aXAgUG9sYXJGaXJlIFNvQyAoTVBGUykgUmVzZXQgRHJpdmVyIg0KPj4+ICsgICAgICAgZGVwZW5k
cyBvbiBBVVhJTElBUllfQlVTICYmIE1DSFBfQ0xLX01QRlMNCj4+PiArICAgICAgIGRlZmF1bHQg
TUNIUF9DTEtfTVBGUw0KPj4+ICsgICAgICAgaGVscA0KPj4+ICsgICAgICAgICBUaGlzIGRyaXZl
ciBzdXBwb3J0cyBwZXJpcGhlcmFsIHJlc2V0IGZvciB0aGUgTWljcm9jaGlwIFBvbGFyRmlyZSBT
b0MNCj4+PiArDQo+Pj4gKyAgICAgICAgIENPTkZJR19SRVNFVF9NUEZTDQo+Pj4NCj4+IFRoaXMg
ZG9lc24ndCBsb29rIGludGVudGlvbmFsLg0KPiANCj4gQ29ycmVjdC4gSSBmaXhlZCBpdCB3aGVu
IHJlYmFzaW5nIG9uIC1uZXh0IGFuZCBmb3Jnb3QgdG8gcmUtZml4IGl0DQo+IHdoZW4gSSBoYWQg
dG8gcmVzZXQgYmFjayB0byAtcmMyLi4uDQo+IA0KPj4+DQo+Pj4gKw0KPj4+ICBjb25maWcgUkVT
RVRfTUVTT04NCj4+PiAgICAgICAgIHRyaXN0YXRlICJNZXNvbiBSZXNldCBEcml2ZXIiDQo+Pj4g
ICAgICAgICBkZXBlbmRzIG9uIEFSQ0hfTUVTT04gfHwgQ09NUElMRV9URVNUDQo+Pj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvcmVzZXQvTWFrZWZpbGUgYi9kcml2ZXJzL3Jlc2V0L01ha2VmaWxlDQo+
Pj4gaW5kZXggYTgwYTljNDAwOGE3Li41ZmFjM2E3NTM4NTggMTAwNjQ0DQo+Pj4gLS0tIGEvZHJp
dmVycy9yZXNldC9NYWtlZmlsZQ0KPj4+ICsrKyBiL2RyaXZlcnMvcmVzZXQvTWFrZWZpbGUNCj4+
PiBAQCAtMTcsNiArMTcsNyBAQCBvYmotJChDT05GSUdfUkVTRVRfSzIxMCkgKz0gcmVzZXQtazIx
MC5vDQo+Pj4gIG9iai0kKENPTkZJR19SRVNFVF9MQU5USVEpICs9IHJlc2V0LWxhbnRpcS5vDQo+
Pj4gIG9iai0kKENPTkZJR19SRVNFVF9MUEMxOFhYKSArPSByZXNldC1scGMxOHh4Lm8NCj4+PiAg
b2JqLSQoQ09ORklHX1JFU0VUX01DSFBfU1BBUlg1KSArPSByZXNldC1taWNyb2NoaXAtc3Bhcng1
Lm8NCj4+PiArb2JqLSQoQ09ORklHX1JFU0VUX1BPTEFSRklSRV9TT0MpICs9IHJlc2V0LW1wZnMu
bw0KPj4+ICBvYmotJChDT05GSUdfUkVTRVRfTUVTT04pICs9IHJlc2V0LW1lc29uLm8NCj4+PiAg
b2JqLSQoQ09ORklHX1JFU0VUX01FU09OX0FVRElPX0FSQikgKz0gcmVzZXQtbWVzb24tYXVkaW8t
YXJiLm8NCj4+PiAgb2JqLSQoQ09ORklHX1JFU0VUX05QQ00pICs9IHJlc2V0LW5wY20ubw0KPj4+
IEBAIC0zOCw0ICszOSwzIEBAIG9iai0kKENPTkZJR19SRVNFVF9VTklQSElFUikgKz0gcmVzZXQt
dW5pcGhpZXIubw0KPj4+ICBvYmotJChDT05GSUdfUkVTRVRfVU5JUEhJRVJfR0xVRSkgKz0gcmVz
ZXQtdW5pcGhpZXItZ2x1ZS5vDQo+Pj4gIG9iai0kKENPTkZJR19SRVNFVF9aWU5RKSArPSByZXNl
dC16eW5xLm8NCj4+PiAgb2JqLSQoQ09ORklHX0FSQ0hfWllOUU1QKSArPSByZXNldC16eW5xbXAu
bw0KPj4+IC0NCj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9yZXNldC9yZXNldC1tcGZzLmMgYi9k
cml2ZXJzL3Jlc2V0L3Jlc2V0LW1wZnMuYw0KPj4+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+Pj4g
aW5kZXggMDAwMDAwMDAwMDAwLi40OWM0N2EzZTZjNzANCj4+PiAtLS0gL2Rldi9udWxsDQo+Pj4g
KysrIGIvZHJpdmVycy9yZXNldC9yZXNldC1tcGZzLmMNCj4+PiBAQCAtMCwwICsxLDE0NSBAQA0K
Pj4+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5DQo+Pj4gKy8qDQo+
Pj4gKyAqIFBvbGFyRmlyZSBTb0MgKE1QRlMpIFBlcmlwaGVyYWwgQ2xvY2sgUmVzZXQgQ29udHJv
bGxlcg0KPj4+ICsgKg0KPj4+ICsgKiBBdXRob3I6IENvbm9yIERvb2xleSA8Y29ub3IuZG9vbGV5
QG1pY3JvY2hpcC5jb20+DQo+Pj4gKyAqIENvcHlyaWdodCAoYykgMjAyMiBNaWNyb2NoaXAgVGVj
aG5vbG9neSBJbmMuIGFuZCBpdHMgc3Vic2lkaWFyaWVzLg0KPj4+ICsgKg0KPj4+ICsgKi8NCj4+
PiArI2luY2x1ZGUgPGxpbnV4L2F1eGlsaWFyeV9idXMuaD4NCj4+PiArI2luY2x1ZGUgPGxpbnV4
L2RlbGF5Lmg+DQo+Pj4gKyNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCj4+PiArI2luY2x1ZGUg
PGxpbnV4L3BsYXRmb3JtX2RldmljZS5oPg0KPj4+ICsjaW5jbHVkZSA8bGludXgvcmVzZXQtY29u
dHJvbGxlci5oPg0KPj4+ICsjaW5jbHVkZSA8ZHQtYmluZGluZ3MvY2xvY2svbWljcm9jaGlwLG1w
ZnMtY2xvY2suaD4NCj4+PiArI2luY2x1ZGUgPHNvYy9taWNyb2NoaXAvbXBmcy5oPg0KPj4+ICsN
Cj4+PiArLyoNCj4+PiArICogVGhlIEVOVk0gcmVzZXQgaXMgdGhlIGxvd2VzdCBiaXQgaW4gdGhl
IHJlZ2lzdGVyICYgSSBhbSB1c2luZyB0aGUgQ0xLX0ZPTw0KPj4+ICsgKiBkZWZpbmVzIGluIHRo
ZSBkdCB0byBtYWtlIHRoaW5ncyBlYXNpZXIgdG8gY29uZmlndXJlIC0gc28gdGhpcyBpcyBhY2Nv
dW50aW5nDQo+Pj4gKyAqIGZvciB0aGUgb2Zmc2V0IG9mIDMgdGhlcmUuDQo+Pj4gKyAqLw0KPj4+
ICsjZGVmaW5lIE1QRlNfUEVSSVBIX09GRlNFVCAgICAgQ0xLX0VOVk0NCj4+PiArI2RlZmluZSBN
UEZTX05VTV9SRVNFVFMgICAgICAgICAgICAgICAgMzB1DQo+Pj4gKyNkZWZpbmUgTVBGU19TTEVF
UF9NSU5fVVMgICAgICAxMDANCj4+PiArI2RlZmluZSBNUEZTX1NMRUVQX01BWF9VUyAgICAgIDIw
MA0KPj4+ICsNCj4+PiArLyoNCj4+PiArICogUGVyaXBoZXJhbCBjbG9jayByZXNldHMNCj4+PiAr
ICovDQo+Pj4gKw0KPj4+ICtzdGF0aWMgaW50IG1wZnNfYXNzZXJ0KHN0cnVjdCByZXNldF9jb250
cm9sbGVyX2RldiAqcmNkZXYsIHVuc2lnbmVkIGxvbmcgaWQpDQo+Pj4gK3sNCj4+PiArICAgICAg
IHUzMiByZWc7DQo+Pj4gKw0KPj4+ICsgICAgICAgcmVnID0gbXBmc19yZXNldF9yZWFkKHJjZGV2
LT5kZXYpOw0KPj4+ICsgICAgICAgcmVnIHw9ICgxdSA8PCBpZCk7DQo+Pj4gKyAgICAgICBtcGZz
X3Jlc2V0X3dyaXRlKHJjZGV2LT5kZXYsIHJlZyk7DQo+Pg0KPj4gVGhpcyBpcyBtaXNzaW5nIGEg
c3BpbmxvY2sgdG8gcHJvdGVjdCBhZ2FpbnN0IGNvbmN1cnJlbnQgcmVhZC1tb2RpZnktDQo+PiB3
cml0ZXMuDQo+Pj4NCj4+PiArDQo+Pj4gKyAgICAgICByZXR1cm4gMDsNCj4+PiArfQ0KPj4+ICsN
Cj4+PiArc3RhdGljIGludCBtcGZzX2RlYXNzZXJ0KHN0cnVjdCByZXNldF9jb250cm9sbGVyX2Rl
diAqcmNkZXYsIHVuc2lnbmVkIGxvbmcgaWQpDQo+Pj4gK3sNCj4+PiArICAgICAgIHUzMiByZWcs
IHZhbDsNCj4+PiArDQo+Pj4gKyAgICAgICByZWcgPSBtcGZzX3Jlc2V0X3JlYWQocmNkZXYtPmRl
dik7DQo+Pj4gKyAgICAgICB2YWwgPSByZWcgJiB+KDF1IDw8IGlkKTsNCj4+DQo+PiBZb3UgY291
bGQgdXNlIEJJVChpZCkgaW5zdGVhZCBvZiAoMXUgPDwgaWQpLg0KPj4NCj4+PiArICAgICAgIG1w
ZnNfcmVzZXRfd3JpdGUocmNkZXYtPmRldiwgdmFsKTsNCj4+PiArDQo+Pj4gKyAgICAgICByZXR1
cm4gMDsNCj4+PiArfQ0KPj4+ICsNCj4+PiArc3RhdGljIGludCBtcGZzX3N0YXR1cyhzdHJ1Y3Qg
cmVzZXRfY29udHJvbGxlcl9kZXYgKnJjZGV2LCB1bnNpZ25lZCBsb25nIGlkKQ0KPj4+ICt7DQo+
Pj4gKyAgICAgICB1MzIgcmVnID0gbXBmc19yZXNldF9yZWFkKHJjZGV2LT5kZXYpOw0KPj4+ICsN
Cj4+PiArICAgICAgIHJldHVybiAocmVnICYgKDF1IDw8IGlkKSk7DQo+Pg0KPj4gU2lkZSBub3Rl
LCB0aGlzIHdvcmtzIGJlY2F1c2UgTVBGU19OVU1fUkVTRVRTIG1ha2VzIHN1cmUgdGhlIHNpZ24g
Yml0DQo+PiBpcyBuZXZlciBoaXQuDQo+IA0KPiBJIGNhbiBhZGQgYSBjb21tZW50IHRvIHRoYXQg
ZWZmZWN0IGlmIHlvdSB3YW50Pw0KDQpJJ20gZ29pbmcgdG8gcmVzcGluIHdpdGggdGhlIHR3byBu
ZXQgcGF0Y2hlcyByZW1vdmVkLg0KSSdsbCBvcGVyYXRlIG9uIHRoZSBhc3N1bXB0aW9uIG9mIGFk
ZGluZyBhIGNvbW1lbnQgaGVyZS4uLg0KDQo+IA0KPj4+DQo+Pj4gK30NCj4+PiArDQo+Pj4gK3N0
YXRpYyBpbnQgbXBmc19yZXNldChzdHJ1Y3QgcmVzZXRfY29udHJvbGxlcl9kZXYgKnJjZGV2LCB1
bnNpZ25lZCBsb25nIGlkKQ0KPj4+ICt7DQo+Pj4gKyAgICAgICBtcGZzX2Fzc2VydChyY2Rldiwg
aWQpOw0KPj4+ICsNCj4+PiArICAgICAgIHVzbGVlcF9yYW5nZShNUEZTX1NMRUVQX01JTl9VUywg
TVBGU19TTEVFUF9NQVhfVVMpOw0KPj4+ICsNCj4+PiArICAgICAgIG1wZnNfZGVhc3NlcnQocmNk
ZXYsIGlkKTsNCj4+PiArDQo+Pj4gKyAgICAgICByZXR1cm4gMDsNCj4+PiArfQ0KPj4+ICsNCj4+
PiArc3RhdGljIGNvbnN0IHN0cnVjdCByZXNldF9jb250cm9sX29wcyBtcGZzX3Jlc2V0X29wcyA9
IHsNCj4+PiArICAgICAgIC5yZXNldCA9IG1wZnNfcmVzZXQsDQo+Pj4gKyAgICAgICAuYXNzZXJ0
ID0gbXBmc19hc3NlcnQsDQo+Pj4gKyAgICAgICAuZGVhc3NlcnQgPSBtcGZzX2RlYXNzZXJ0LA0K
Pj4+ICsgICAgICAgLnN0YXR1cyA9IG1wZnNfc3RhdHVzLA0KPj4+ICt9Ow0KPj4+ICsNCj4+PiAr
c3RhdGljIGludCBtcGZzX3Jlc2V0X3hsYXRlKHN0cnVjdCByZXNldF9jb250cm9sbGVyX2RldiAq
cmNkZXYsDQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IHN0cnVjdCBvZl9w
aGFuZGxlX2FyZ3MgKnJlc2V0X3NwZWMpDQo+Pj4gK3sNCj4+PiArICAgICAgIHVuc2lnbmVkIGlu
dCBpbmRleCA9IHJlc2V0X3NwZWMtPmFyZ3NbMF07DQo+Pj4gKw0KPj4+ICsgICAgICAgLyoNCj4+
PiArICAgICAgICAqIENMS19SRVNFUlZFRCBkb2VzIG5vdCBtYXAgdG8gYSBjbG9jaywgYnV0IGl0
IGRvZXMgbWFwIHRvIGEgcmVzZXQsDQo+Pj4gKyAgICAgICAgKiBzbyBpdCBoYXMgdG8gYmUgYWNj
b3VudGVkIGZvciBoZXJlLiBJdCBpcyB0aGUgcmVzZXQgZm9yIHRoZSBmYWJyaWMsDQo+Pj4gKyAg
ICAgICAgKiBzbyBpZiB0aGlzIHJlc2V0IGdldHMgY2FsbGVkIC0gZG8gbm90IHJlc2V0IGl0Lg0K
Pj4+ICsgICAgICAgICovDQo+Pj4gKyAgICAgICBpZiAoaW5kZXggPT0gQ0xLX1JFU0VSVkVEKSB7
DQo+Pj4gKyAgICAgICAgICAgICAgIGRldl9lcnIocmNkZXYtPmRldiwgIlJlc2V0dGluZyB0aGUg
ZmFicmljIGlzIG5vdCBzdXBwb3J0ZWRcbiIpOw0KPj4+ICsgICAgICAgICAgICAgICByZXR1cm4g
LUVJTlZBTDsNCj4+PiArICAgICAgIH0NCj4+PiArDQo+Pj4gKyAgICAgICBpZiAoaW5kZXggPCBN
UEZTX1BFUklQSF9PRkZTRVQgfHwgaW5kZXggPj0gKE1QRlNfUEVSSVBIX09GRlNFVCArIHJjZGV2
LT5ucl9yZXNldHMpKSB7DQo+Pj4gKyAgICAgICAgICAgICAgIGRldl9lcnIocmNkZXYtPmRldiwg
IkludmFsaWQgcmVzZXQgaW5kZXggJXVcbiIsIHJlc2V0X3NwZWMtPmFyZ3NbMF0pOw0KPj4NCj4+
IHMvcmVzZXRfc3BlYy0+YXJnc1swXS9pbmRleC8NCj4+DQo+Pj4gKyAgICAgICAgICAgICAgIHJl
dHVybiAtRUlOVkFMOw0KPj4+ICsgICAgICAgfQ0KPj4+ICsNCj4+PiArICAgICAgIHJldHVybiBp
bmRleCAtIE1QRlNfUEVSSVBIX09GRlNFVDsNCj4+PiArfQ0KPj4+ICsNCj4+PiArc3RhdGljIGlu
dCBtcGZzX3Jlc2V0X3Byb2JlKHN0cnVjdCBhdXhpbGlhcnlfZGV2aWNlICphZGV2LA0KPj4+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zdCBzdHJ1Y3QgYXV4aWxpYXJ5X2RldmljZV9p
ZCAqaWQpDQo+Pj4gK3sNCj4+PiArICAgICAgIHN0cnVjdCBkZXZpY2UgKmRldiA9ICZhZGV2LT5k
ZXY7DQo+Pj4gKyAgICAgICBzdHJ1Y3QgcmVzZXRfY29udHJvbGxlcl9kZXYgKnJjZGV2Ow0KPj4+
ICsgICAgICAgaW50IHJldDsNCj4+PiArDQo+Pj4gKyAgICAgICByY2RldiA9IGRldm1fa3phbGxv
YyhkZXYsIHNpemVvZigqcmNkZXYpLCBHRlBfS0VSTkVMKTsNCj4+PiArICAgICAgIGlmICghcmNk
ZXYpDQo+Pj4gKyAgICAgICAgICAgICAgIHJldHVybiAtRU5PTUVNOw0KPj4+ICsNCj4+PiArICAg
ICAgIHJjZGV2LT5kZXYgPSBkZXY7DQo+Pj4gKyAgICAgICByY2Rldi0+ZGV2LT5wYXJlbnQgPSBh
ZGV2LT5kZXYucGFyZW50Ow0KPj4+DQo+Pj4gcy9hZGV2LT5kZXYuL2Rldi0+Lw0KPj4+DQo+Pj4g
KyAgICAgICByY2Rldi0+b3BzID0gJm1wZnNfcmVzZXRfb3BzOw0KPj4+ICsgICAgICAgcmNkZXYt
Pm9mX25vZGUgPSBhZGV2LT5kZXYucGFyZW50LT5vZl9ub2RlOw0KPj4+DQo+Pj4gcy9hZGV2LT5k
ZXYuL2Rldi0+Lw0KPj4+DQo+Pj4gKyAgICAgICByY2Rldi0+b2ZfcmVzZXRfbl9jZWxscyA9IDE7
DQo+Pj4gKyAgICAgICByY2Rldi0+b2ZfeGxhdGUgPSBtcGZzX3Jlc2V0X3hsYXRlOw0KPj4+ICsg
ICAgICAgcmNkZXYtPm5yX3Jlc2V0cyA9IE1QRlNfTlVNX1JFU0VUUzsNCj4+PiArDQo+Pj4gKyAg
ICAgICByZXQgPSBkZXZtX3Jlc2V0X2NvbnRyb2xsZXJfcmVnaXN0ZXIoZGV2LCByY2Rldik7DQo+
Pj4gKyAgICAgICBpZiAoIXJldCkNCj4+PiArICAgICAgICAgICAgICAgZGV2X2luZm8oZGV2LCAi
UmVnaXN0ZXJlZCBNUEZTIHJlc2V0IGNvbnRyb2xsZXJcbiIpOw0KPj4NCj4+IElzIHRoaXMgcmVh
bGx5IHVzZWZ1bCBpbmZvcm1hdGlvbiBmb3IgbW9zdCB1c2Vycz8NCj4gDQo+IFByb2JhYmx5IG5v
dCwgYnV0IGl0IGlzIHVzZWZ1bCBmb3IgbXkgQ0kgaGFoYS4NCj4gSWYgeW91IGRvbid0IGxpa2Ug
aXQsIEkgd2lsbCByZW1vdmUgaXQuDQoNCi4uLmFuZCByZW1vdmFsIGhlcmUuDQpUaGFua3MgZm9y
IHlvdXIgcmV2aWV3IFBoaWxpcHAgOikNCkNvbm9yLg0KDQo+IA0KPj4NCj4+PiArDQo+Pj4gKyAg
ICAgICByZXR1cm4gcmV0Ow0KPj4+ICt9DQo+Pj4gKw0KPj4+ICtzdGF0aWMgY29uc3Qgc3RydWN0
IGF1eGlsaWFyeV9kZXZpY2VfaWQgbXBmc19yZXNldF9pZHNbXSA9IHsNCj4+PiArICAgICAgIHsN
Cj4+PiArICAgICAgICAgICAgICAgLm5hbWUgPSAiY2xrX21wZnMucmVzZXQtbXBmcyIsDQo+Pj4g
KyAgICAgICB9LA0KPj4+ICsgICAgICAgeyB9DQo+Pj4gK307DQo+Pj4gK01PRFVMRV9ERVZJQ0Vf
VEFCTEUoYXV4aWxpYXJ5LCBtcGZzX3Jlc2V0X2lkcyk7DQo+Pj4gKw0KPj4+ICtzdGF0aWMgc3Ry
dWN0IGF1eGlsaWFyeV9kcml2ZXIgbXBmc19yZXNldF9kcml2ZXIgPSB7DQo+Pj4gKyAgICAgICAu
cHJvYmUgICAgICAgICAgPSBtcGZzX3Jlc2V0X3Byb2JlLA0KPj4+ICsgICAgICAgLmlkX3RhYmxl
ICAgICAgID0gbXBmc19yZXNldF9pZHMsDQo+Pj4gK307DQo+Pj4gKw0KPj4+ICttb2R1bGVfYXV4
aWxpYXJ5X2RyaXZlcihtcGZzX3Jlc2V0X2RyaXZlcik7DQo+Pj4gKw0KPj4+ICtNT0RVTEVfREVT
Q1JJUFRJT04oIk1pY3JvY2hpcCBQb2xhckZpcmUgU29DIFJlc2V0IERyaXZlciIpOw0KPj4+ICtN
T0RVTEVfQVVUSE9SKCJDb25vciBEb29sZXkgPGNvbm9yLmRvb2xleUBtaWNyb2NoaXAuY29tPiIp
Ow0KPj4+ICtNT0RVTEVfTElDRU5TRSgiR1BMIik7DQo+Pj4gK01PRFVMRV9JTVBPUlRfTlMoTUNI
UF9DTEtfTVBGUyk7DQo+Pj4NCj4+IHJlZ2FyZHMNCj4+IFBoaWxpcHANCg0K
