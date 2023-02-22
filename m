Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8F569EDA8
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 04:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbjBVDws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 22:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbjBVDwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 22:52:46 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36F231E0B;
        Tue, 21 Feb 2023 19:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1677037964; x=1708573964;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FJEbPiff8yITgdN4g2vfXi+JLKDdC24TQ8v2MjKL/8g=;
  b=UHGLi+csjPnmewCiCyW5k1EGqVXIatbNzoaSJh+dNPe9YV7FJkKMXBKG
   /PAEFDfEdi9eAWd6tlONPambswq8SaeokTTFpuRldRoK+H+LxjV6emCG0
   +nsCXaEvZd+jTv9U/U15z6mNynXah4scFGav2vpLM6zVN6yAg6POPQNHV
   VRmOKbnN91jwscNFJn02w1/Q0z1q82XLBcyV6aLRkguFFVh5ZmFhG5JsT
   boMszd0WpCvrW98Cpg4kPXr9Ve/VmEvIlPa3TUBWJgY7gKxqWKWjtXsMB
   TWAJXZJ/9nMCqaf5C0Ls2b5B+1mviwKsMNfsRiGa4zaIchFL1WY0g2jsK
   g==;
X-IronPort-AV: E=Sophos;i="5.97,317,1669100400"; 
   d="scan'208";a="201748785"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Feb 2023 20:52:43 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 20:52:42 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Tue, 21 Feb 2023 20:52:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPig6i5fjloDCptrO84Id7Bnh8Hceuekbu/2dvBH5LRQekYdGVCtVVimJgPmgG2sdkfPH7jr8Rn4s8sJsH89CPJVvphBd+2D6TyD82hEIzMu5Y4wwFxPsc9xSoYhXnffExtAJ3Yh5nqSW0CCDm/gHEn4rjmqBqgCSDXAuLgwP0dIj/fmjEXlbDw/WDXfDkuF4S2QmNKLelZ2AbvDCj8EFaw5jFk5K29yY5dRo7Flo8slHw5l6PXHMuLrbGzff7i6RT5A1YEsDrKe91XPs298KgSXAnYNuBzn7V0MyemeVfahUHPxrCJlbR5KPHx/ZBuSkS1X2yArdLsPJ2ZHuoWLLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FJEbPiff8yITgdN4g2vfXi+JLKDdC24TQ8v2MjKL/8g=;
 b=mTYXBGZBF5oigAYijkvBhoL1lefiSAWHQtKhsGZ4stqnt+BIpNlMbprVhBNYHYvbLHvMQW6yYGSch5LWP6KQ7kBmMvpSIB1zdX1c/bu0LTSRtION3QSzGMDl2HVOW+rRaQ0yDuZFOApuIzQYp/w/rRjXmCnd+5JRK3uxbDJI07ghg375Kr/LlzssvZhb4tqL3HrYoSE28rm+CUSyZS1eOBIC1gfoCkOhAQl/Xd/lVsyFUieLvS9KDsOUxUjvOLtL5twggzn6NwEUdmfznB+NWkf76Cogy1S4Ht3qjBCi5M6lqJ0bq5GtFZNxkgxk5rpfqk3ZcTaOdt8FlYs+FaIZjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FJEbPiff8yITgdN4g2vfXi+JLKDdC24TQ8v2MjKL/8g=;
 b=JFznUNmEtcE1GknI6ZdIEZCjzxtcuPRLARxXrUFhXnC+++q7focYBOW4g0lkil2PQpuLPZNFfnxNQBeAa6hE+6LnherANPCiDwYbvk/YTNkndunPWDVEtCprj9MKtxOJE80u0FfNP270vGKIkyQHDgP0fZY34GUJvKoygy8Pd8s=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DS0PR11MB7215.namprd11.prod.outlook.com (2603:10b6:8:13a::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.19; Wed, 22 Feb 2023 03:52:41 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 03:52:41 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <marex@denx.de>
CC:     <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        <olteanv@gmail.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <stable@vger.kernel.org>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [PATCH] net: dsa: microchip: Fix gigabit set and get function for
 KSZ87xx
Thread-Topic: [PATCH] net: dsa: microchip: Fix gigabit set and get function
 for KSZ87xx
Thread-Index: AQHZRmxOw0j/afOyL06CxzA8EiyKWa7aVV8A
Date:   Wed, 22 Feb 2023 03:52:40 +0000
Message-ID: <bcd388d184704507bb8b3648abc4d322b9e7e500.camel@microchip.com>
References: <20230222031738.189025-1-marex@denx.de>
In-Reply-To: <20230222031738.189025-1-marex@denx.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|DS0PR11MB7215:EE_
x-ms-office365-filtering-correlation-id: 6a357b57-db0b-4dab-322c-08db14883f07
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UV6vY8RmaDcs+m5Khuox4IIkfmDMb6YuZMNHY/zx/q+1pIcedPoooPP4yUlIQ5tCET86cCUYMLZm73rnMJtXI1mSLhD04A4EDu/KwmC49uBDKEDEitgpl219pfOGLXzumBTya4CBMR5ivolthIBGbIbcHUaDUj0PplesPPXI0VkLP6jROCI+Z2mVIp2JyRBpew6Y7ZT67DuXPvU+SNSjRuxJ8s3Tcq/91sh+LtS6/IIE7cOqlALEUiZzeWQmyaaURzQXPsWR2wrdtZGuJS0Xb64UfmJZqsQrTsEDKQ0hBZKfRpX/VwzmVby4a7LhEfXFRwPzVpvfNXNK3E+ks5XnzScRC95wbCfXfEYSgtfPiiYSQjXFhrmmddfKkGMMGgGKZY+kzVD3/8Nw2x6VfqQPvVKWfIAH0JJkGWsk+dKeDrNGVFC+6273NSeSJhj3kCUh8ZoO+/OyZi1HteFwEczExP18oMrEFxNwfyGo8AafMewzKdkFdTA+XUIM4heIlWEBI41XdzVHsf9WRkSxh/igJolimcCqtPpav8da1+8Hmg8C+UZqGutiQc/JhKIMtQYFjqppta3RguIEJP0RXIdaF75gGNNmy4l2qxPYFIYWEGSwy7oqrL+LBfld37IUUjAWxqGk4GfUnejkMoh67XcyXh7UfYYTWHO5nHnKF+a2yi3ON4iEPEw2iwwDwkgiI7Eqkk2fe8JyPo45Em3Hz4rGqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199018)(36756003)(41300700001)(76116006)(2616005)(6512007)(66476007)(66946007)(8676002)(66446008)(66556008)(8936002)(64756008)(6506007)(186003)(26005)(4326008)(86362001)(7416002)(5660300002)(83380400001)(91956017)(122000001)(478600001)(54906003)(316002)(966005)(6486002)(110136005)(71200400001)(38100700002)(2906002)(38070700005)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVdrbUNEV0tBUm5vUjhKNGFnRmxnb0hZK1R6djVlaUdFMm9UYm9aL0lxVEgx?=
 =?utf-8?B?V3h4RHMrZWFPbnVmNklLbVBFOW8zQ2VNbXFUcUhZS2dTVzNVZ3A1WjFoTDBo?=
 =?utf-8?B?aXcxUHFKd21JWWNUN1RmSUhPTC9oblpWZ0cxS0psRmltVmVZQlRHTVhoUjVC?=
 =?utf-8?B?Z252cGZIcFIyckZ4WHV3bVZSOFpIRmN4N0RSMGVRRXByVWZtdGVuM1pZUndG?=
 =?utf-8?B?WXJFOWprNG1YYXdQM0JCQk10bytCYzhUK0hBMmZGeUJneHg1UzBWZUlkRW1F?=
 =?utf-8?B?Q20rRWkveHNReFVWZWlrcldMZFNiZWg5Z1hBa0lKaUh4Ukl6QWJGUjJFWCs3?=
 =?utf-8?B?aklnbEtLZEE1ZlVEQVVwcDUvQzBLRHg4YlVJTnp2a0FtdTVYNkJHZVNHOExP?=
 =?utf-8?B?aXUvSU82L1JsbmxYN0JWZ2wxeHhkSFdRUlJROWI5VEpyb0RRVFdUZlZha2hE?=
 =?utf-8?B?bmRHeUN0aFJXcnNPT0w3NzgySGdKaCtMVUlaK2M4dS9jRFJXUWxMbWJtWkRO?=
 =?utf-8?B?YUhoKzdFTUVmVkJUQm93dG1IVmE0eWg3WDlPWFZVUEVTbFgzNkZONTNBT2JY?=
 =?utf-8?B?bjhQRVZsY0g2dkhmVjJraWErTUZUT0RUTEhNVGNWRUJBNkoxcVNPZVZDNUs0?=
 =?utf-8?B?N3lRSDRON3RzbFYzYlREMXR1djZNeXcrd3BxVTZrR2IxdEdHbytJdU45TXNT?=
 =?utf-8?B?dlN1NXZobFBXL2ZLc2RzVnlLQ01jNWFVUEgvMzlTd3JWSERBc2NZMUwxZENa?=
 =?utf-8?B?VU40MjVsMFZTT29hb0dYYk9wZnpqZUlBSG9XeHVNMDVkaTUzcnBjdUFsU1or?=
 =?utf-8?B?OHVndmpYM1c2STVjZUNnWCtmcUgvTXd5cUNsUmk4MzZnRnhLOVVIaTJTdXRM?=
 =?utf-8?B?Y0xPRWprRXQ4Wm5XTWRvOUl4RlZHQ0FIUkZGcmZOdE9hTmhaVVFLYTBrU2FS?=
 =?utf-8?B?TGEwZWo5UWx5SDFWcVc1RmtRNnR2dUZvV3hGbDhhQ3pVclVFZmMyUUFuRUto?=
 =?utf-8?B?N1VFUlBVc3RmQUhKOFBnVWJCZDZxdDc4VWdtK2crbktHSTdvM29XSU1QK2NY?=
 =?utf-8?B?blVBSksvbDBrTnZYUzFIR1kxRkxyZzRjMUZuNjdqbVFiVkV1ZjdVVG01dXU3?=
 =?utf-8?B?bnExeERDYi82MFByTDBITzJqamQ2aUVDOXpKem1RM0xkTWhzT2VDbS81NlR5?=
 =?utf-8?B?TWdPcnRyL0lwcFhEYzMvNWpUNEJCMndrL2JGUXRIdGJQbE16RlZNalZLT3V3?=
 =?utf-8?B?OERMaDhBWDZydHFOekY5NzZ5OER5aTJXOW5DTXRpYzZWMngwVXk0VGh0eUh6?=
 =?utf-8?B?VlZGNlA5SkRHSXFxeVl0ZTZCY3VQZndmNmNocmJoUWFsZmFNd2VNNzRrTjlk?=
 =?utf-8?B?NmVRYStMZnJTdGxXVk9nNmtWYzdZWXFjdDlFNk9SMDBUY0Q4V1RtQlBJV0Ft?=
 =?utf-8?B?M0haNDRGMm56OGY3NUY3RitldWxUYU52UzE5N00vcm9KWGNMMzg5NUtDQzBj?=
 =?utf-8?B?bFo0VDFlRVFNZFVMZFVnRStmYnNta2VRRkd5ZFZxakRSZWdpZmZQZmwzc05t?=
 =?utf-8?B?WnY2VUtNL1Z2NE9EaU05ZmhCTlVvbGRld2QvTVFsOVpJUXNBVHAwVHp4ejBJ?=
 =?utf-8?B?QksrTU8rTWtpWi9QS3VmMUpHV3JSYjlHWEhxQXNmd3IvMGFtYW9CUVBXUXFw?=
 =?utf-8?B?NWNEeGhxaExMa2F3TnpnRmMrSjc2SjNoUk9FU1pOekxualhnOEk0S1ZzMTMz?=
 =?utf-8?B?MjlwbWFSQnNtaHpPRGNJTkhxMTdyTGxxV0IzbTBvcWRuMXJBYUpWSWhiNkcy?=
 =?utf-8?B?djZEZWhwL1hselU4dmtYeU9CeERPTk83dHdjbFM1NnNMQjh6N2FVK2s1UDRp?=
 =?utf-8?B?VUNwMEoxUVpFMkJVUnMrYjMzbDRGMU9Gb1BDUUEwdVJmanR5VDVCU2wxNGF2?=
 =?utf-8?B?TS9Mam9pYmV6bTBoYmJpUURnd3NUVWRqcHlCUnA5ZmZrNmYrOU9sVmZ1ck96?=
 =?utf-8?B?SkprMnlHMEFVcmgvNWRuU04yUUE1bDdSNnFtVitJTkhpbjYrbVJobUhsNnpt?=
 =?utf-8?B?Wm1jamJBQWZtQUpOdFJqTjRsZ0U5SnZWaFF5a3RnNWlEMWVidnJZeDI5SUcw?=
 =?utf-8?B?RVJQclZOdTNtMzNwN3dwdnpjR01lSjEveG9Ja2ZLTTc1Rk9NWDFCdFJOY25X?=
 =?utf-8?Q?TpXcPXPmNJf4ir5WgbvkxDc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DDAF594C77F0C545A73839BB9E5CE8B4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a357b57-db0b-4dab-322c-08db14883f07
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 03:52:40.8288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u7BpoV1l34FndCSPpcLPiTCxMxJfrd+OOqEiDmqJ6j5bp1vB5jfbhr5SJ5dbEE1UDDIrHJSaqS4xzasENoZ4oPhcJemypRCly3fr2kwQCL0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7215
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyZWssDQpPbiBXZWQsIDIwMjMtMDItMjIgYXQgMDQ6MTcgKzAxMDAsIE1hcmVrIFZhc3V0
IHdyb3RlOg0KPiBQZXIgS1NaODc5NCBbMV0gZGF0YXNoZWV0IERTMDAwMDIxMzREIHBhZ2UgNTQg
VEFCTEUgNC00OiBQT1JUDQo+IFJFR0lTVEVSUywNCj4gaXQgaXMgUmVnaXN0ZXIgODYgKDB4NTYp
OiBQb3J0IDQgSW50ZXJmYWNlIENvbnRyb2wgNiB3aGljaCBjb250YWlucw0KPiB0aGUNCj4gSXNf
MUdicHMgZmllbGQuDQo+IA0KPiBDdXJyZW50bHksIHRoZSBkcml2ZXIgdXNlcyBQT1JUIHJlYWQg
ZnVuY3Rpb24gb24gcmVnaXN0ZXINCj4gUF9YTUlJX0NUUkxfMQ0KPiB0byBhY2Nlc3MgdGhlIFBf
R01JSV8xR0JJVF9NLCBpLmUuIElzXzFHYnBzLCBiaXQuIFRoZSBwcm9ibGVtIGlzLCB0aGUNCj4g
cmVnaXN0ZXIgUF9YTUlJX0NUUkxfMSBhZGRyZXNzIGlzIGFscmVhZHkgMHg1Niwgd2hpY2ggaXMg
dGhlDQo+IGNvbnZlcnRlZA0KPiBQT1JUIHJlZ2lzdGVyIGFkZHJlc3MgaW5zdGVhZCBvZiB0aGUg
b2Zmc2V0IHdpdGhpbiBQT1JUIHJlZ2lzdGVyDQo+IHNwYWNlDQo+IHRoYXQgUE9SVCByZWFkIGZ1
bmN0aW9uIGV4cGVjdHMgYW5kIGNvbnZlcnRzIGludG8gdGhlIFBPUlQgcmVnaXN0ZXINCj4gYWRk
cmVzcyBpbnRlcm5hbGx5LiBUaGUgaW5jb3JyZWN0bHkgZG91YmxlLWNvbnZlcnRlZCByZWdpc3Rl
ciBhZGRyZXNzDQo+IGJlY29tZXMgMHhhNiwgd2hpY2ggaXMgd2hhdCB0aGUgUE9SVCByZWFkIGZ1
bmN0aW9uIHVsdGltYXRlbGx5DQo+IGFjY2Vzc2VzLA0KPiBhbmQgd2hpY2ggaXMgYSBub24tZXhp
c3RlbnQgcmVnaXN0ZXIgb24gdGhlIEtTWjg3OTQvS1NaODc5NSAuDQo+IA0KPiBUaGUgY29ycmVj
dCB2YWx1ZSBmb3IgUF9YTUlJX0NUUkxfMSBpcyAweDYsIHdoaWNoIGdldHMgY29udmVydGVkIGlu
dG8NCj4gcG9ydCBhZGRyZXNzIDB4NTYsIHdoaWNoIGlzIFJlZ2lzdGVyIDg2ICgweDU2KTogUG9y
dCA0IEludGVyZmFjZQ0KPiBDb250cm9sIDYNCj4gcGVyIEtTWjg3OTQgZGF0YXNoZWV0LCBpLmUu
IHRoZSBjb3JyZWN0IHJlZ2lzdGVyIGFkZHJlc3MuDQo+IA0KPiBUbyBtYWtlIHRoaXMgd29yc2Us
IHRoZXJlIGFyZSBtdWx0aXBsZSBvdGhlciBjYWxsIHNpdGVzIHdoaWNoIHJlYWQNCj4gYW5kDQo+
IGV2ZW4gd3JpdGUgdGhlIFBfWE1JSV9DVFJMXzEgcmVnaXN0ZXIsIG9uZSBvZiB0aGVtIGlzIGtz
el9zZXRfeG1paSgpLA0KPiB3aGljaCBpcyByZXNwb25zaWJsZSBmb3IgY29uZmlndXJhdGlvbiBv
ZiBSR01JSSBkZWxheXMuIFRoZXNlIGRlbGF5cw0KPiBhcmUgaW5jb3JyZWN0bHkgY29uZmlndXJl
ZCBhbmQgYSBub24tZXhpc3RlbnQgcmVnaXN0ZXIgaXMgd3JpdHRlbg0KPiB3aXRob3V0IHRoaXMg
Y2hhbmdlLg0KPiANCj4gRml4IHRoZSBQX1hNSUlfQ1RSTF8xIHJlZ2lzdGVyIG9mZnNldCB0byBy
ZXNvbHZlIHRoZXNlIHByb2JsZW1zLg0KPiANCj4gWzFdIA0KPiBodHRwczovL3d3MS5taWNyb2No
aXAuY29tL2Rvd25sb2Fkcy9hZW1Eb2N1bWVudHMvZG9jdW1lbnRzL1VORy9Qcm9kdWN0RG9jdW1l
bnRzL0RhdGFTaGVldHMvS1NaODc5NENOWC1EYXRhLVNoZWV0LURTMDAwMDIxMzQucGRmDQo+IA0K
PiBGaXhlczogNDZmODBmYTg5ODFiICgibmV0OiBkc2E6IG1pY3JvY2hpcDogYWRkIGNvbW1vbiBn
aWdhYml0IHNldCBhbmQNCj4gZ2V0IGZ1bmN0aW9uIikNCj4gU2lnbmVkLW9mZi1ieTogTWFyZWsg
VmFzdXQgPG1hcmV4QGRlbnguZGU+DQoNClRoYW5rcyBmb3IgdGhlIGNhdGNoLiBJIG92ZXJsb29r
ZWQgdGhlIGtzel93cml0ZSB0byBrc3pfcHdyaXRlIHdoZW4NCnJlZmFjdG9yaW5nIHRoZSBjb2Rl
IGZvciBjb21tb24gS1NaIGltcGxlbWVudGF0aW9uLg0KDQpBY2tlZC1ieTogQXJ1biBSYW1hZG9z
cyA8YXJ1bi5yYW1hZG9zc0BtaWNyb2NoaXAuY29tPg0KDQoNCg==
