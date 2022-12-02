Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27469640382
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 10:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbiLBJkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 04:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbiLBJk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 04:40:29 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BCBB2740;
        Fri,  2 Dec 2022 01:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669974025; x=1701510025;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=F2ZEsX2IgOjQm5X96i4tzKKvVIwOIpBBRn+gpDSqg2M=;
  b=mFKxeH1Qmx70KjuzjDjxbD5NP3Vc2AX3VQ9tua+jE74lO7Bey7Mzz4sD
   QXC5TikngjoWxT4CSmuuHVVPWGjPlIn/3sw1Bxa3kiAWh9IAP+kzOuEfL
   FJdXOuuXBP6492ne7Mfyui9qw6OKCPc6WimOEzboqX3ZIh/mje3N+HYR6
   HU0PaBkwtZd28NNbS/skCMKWTjYtR8uGmPgSgUmDx8K81+vmDqpLZuhbW
   EyKAEBGtuoSLYtATAvsGxHbZ4gv4iYGjSSS8NljyDh1WyUwO6fGJIaaa+
   9llAddA0WNRBznTW6mEeLpB9kof4M3F8JWXiyPQ0Nur1IhYr+jEQbyDLw
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="186223945"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Dec 2022 02:40:24 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Dec 2022 02:40:21 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Fri, 2 Dec 2022 02:40:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+lpylOXw3EsJWlNCD5rAYLESU07D5Fv/KjPv2o7OLPiLWQVQB5z8breErUQBQtQNCl33+uL8dCw0QpS1vHvciCNh2+ErPjrDiAv9b86MIM16Kxeny83Cf8Ym0jICk08o4p8Nl/q7Vme6GZ3WBXlcedD6I2h7Ee24dwZypQ/UrTOqhBd0YJaDm6dGMOp1+MWsD2orP9dlJBuR6QCvgmmY4RgFr/LLoMK0f5g07gGXngxJz9AU6dWpbe//vZ96vyKEd/3sUGWoLZ4LdNCNiy3jgLlAD4whBiir0pc2ttpXgu126R+0NcGkRifsAp/E3RCF2uyn3isQ1ZRxGpOJuEbcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2ZEsX2IgOjQm5X96i4tzKKvVIwOIpBBRn+gpDSqg2M=;
 b=PMAy/atrW+Mt2nlx8ln3SEF8wVwcGl6CVzWAzl1K5G/3vGjxNOSUNltowbWq8yjt6W9cIjuGDBWlBAKSd0fhN0TUpVCsaPSZFVSf5hLiOZNiMhuR1Y/vy0Qj5xf8U6+s0s0UzobFou9CivfNq/hkUPCoNWS3Kk7LOD4+e0k2uy2twMDdIJM0SfsdMHwAmlLgB8bNJA7oRk/EaT0Rh+rOsMnxtkTVHz8ruf00Uhug39M5CCCihu4/rSZYOaqdpUAN8i2Cd4RD6L8gIh/4/5BalBQNl7hxYgHO9/Zl7Jw1g1NvLTj89djQhaxIZCjaiCvRFH4hvYO9IZSbX7P4o4LxWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2ZEsX2IgOjQm5X96i4tzKKvVIwOIpBBRn+gpDSqg2M=;
 b=hPAeMvNX8mC4PyvQQijoe91vm77yGKj6KtIJfi+NZbnDL3iCaUKTr+OvjRpGF50oUVZof6CniDYnogela6QtygifN5Pjdj0gNICcB8DkdA+Fwbr3bv6XW43SlXs2JMQAHvth8NfQxwyVlXrIzY/F2TDFqouEdJBKxbzDAj8Eq9A=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 PH8PR11MB6707.namprd11.prod.outlook.com (2603:10b6:510:1c6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 09:40:17 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 09:40:17 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <ceggers@arri.de>,
        <Tristram.Ha@microchip.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [Patch net-next v1 04/12] net: dsa: microchip: ptp: Manipulating
 absolute time using ptp hw clock
Thread-Topic: [Patch net-next v1 04/12] net: dsa: microchip: ptp: Manipulating
 absolute time using ptp hw clock
Thread-Index: AQHZAxTwqsoem8TmskSr7lmTVTJtba5YO9a8gAIiKgA=
Date:   Fri, 2 Dec 2022 09:40:17 +0000
Message-ID: <2d36cc5c34a995f680177a52e4659ad07a31ab8f.camel@microchip.com>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
         <20221128103227.23171-1-arun.ramadoss@microchip.com>
         <20221128103227.23171-5-arun.ramadoss@microchip.com>
         <20221128103227.23171-5-arun.ramadoss@microchip.com>
         <20221201010457.ig6jtrp326xj6ux6@skbuf>
In-Reply-To: <20221201010457.ig6jtrp326xj6ux6@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|PH8PR11MB6707:EE_
x-ms-office365-filtering-correlation-id: 7ea99064-5a02-453d-3fed-08dad44938c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vjseDShlHdRG9aoTzN1oDm2lxnYhjHyMfAFGopasgE+H3GRnxj0xGeQgicb4HC3d/7VUAPZQrrw/5EZ0JWr+Wway5BSqPzycmMbPAojUDNtb+99zlWeFOJUx2sApoSXaBAVK9Y57FMBB40QDW41s4SaHkjtmUhqiBDWYDSTiiRh6sdLWhJz7QF7tBeAFH8ksw8BmsR4hMv3tE/6uyrjAZ23+WGWWlagk95iMnYPvbF1nwYgAvniTn1xjksAF53PNxUMl0JRE4qDC/Q/87fFQHLkSvCoHH1YzFHIRpQPFfyKfrWkEoR0VwGy49ACS6beFDB7Bk2E1czsLI9uI0nwX+oEEB4kvRNeIA0cxChPruT2ohB4IVNJunvFCGhxrEvYgrtkSbAR5rD2lvoEUhPNpk8bmeV/G04/K5dUDtAUvA4Y+hRfREiBFnKvhAAqSfr+rpMgrmRQS4sOYFJFdJW4HBkhp7RJfk80zVLn+0jtc1936Gk1hAY7XVG7pTxAr0gOYxM4oq8VdGU9aQ56zK4Xg9tRyeNYw+cwWy49vSD1XjiXd4TAroXq5VKM+eglS6XcGVuF4Irg8UyGFzhKVpHMxkWEoXzCdmku+mq7uY6mmnQAuBMhs6hSk8gpEP5htNHJHM6/qE7K/ZqftQuvR9BVIqlVWrY1uHglybZXXhYc/SU6srRMbL/dbqRCRtKzG7c9Qznv1AoZmx558+aOe2y6qowEWyyooVtIqzS+PR7/PugE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(396003)(346002)(366004)(451199015)(26005)(36756003)(478600001)(6512007)(91956017)(71200400001)(8676002)(76116006)(66476007)(66946007)(2616005)(4326008)(6916009)(6486002)(66556008)(38070700005)(186003)(64756008)(6506007)(5660300002)(7416002)(66446008)(86362001)(41300700001)(122000001)(2906002)(8936002)(83380400001)(38100700002)(316002)(54906003)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VjRsWm9ZcVcwV0pOQ213SzZrUk8ya2xiYkY2TFF5SW5mN250eWhVeGMyaW5J?=
 =?utf-8?B?cU9PZWtFZExsMXhlVEVHVnlOUUY0bGFCTVpjYVpPQVFobGtVY1BJRFUrekZi?=
 =?utf-8?B?UlRrUTJPZHBicU9oWlI1dWFBN0k0WEZpR0NtMHY1WFU2S2I4K1pmNzdFT0dt?=
 =?utf-8?B?T0JXZlJFQXcycEp4YTQ0ajZEWi9MOUtQS1hOMklBd21oWFowcTBDRkt6RU1C?=
 =?utf-8?B?K3l4eDgyNnJyS3EwMnQxdkdRREMxWHFMVVUxcGtXSzVCMmlOYzIwcmFidzJO?=
 =?utf-8?B?THlPZVp2WFI2U25XV1I3ay9jdEljZlE0MWI3MWJKV2pLU0Zib1dIRDJ5VkVk?=
 =?utf-8?B?MmJ2bDREbFoya2lvdlQyVjQxYWg3KzNLK3BjNmFxM2UzdUlaT3pxNTFlTVlM?=
 =?utf-8?B?TWxqS0pTT0lQRVdSR1FZUnB0Tk1reGV6V0dNTHB2Sjl5OERFZVRhRWs0Sjc0?=
 =?utf-8?B?RTQvUVVQeVI2U052YnNXeHlBU2M1YmtlZERvZFhKd1JmeXk0aDR5NWd1NkJ5?=
 =?utf-8?B?ZmdEalFNcldOMWRTbks2Rk9jM29LeWVFaVpIRHF5UTR4b0REdzNUVTlIYUlh?=
 =?utf-8?B?bXdYd1BicHRmQWRVWllNM2ZCQXowNjZmYmRjWGJmaUJzcWNIQ2U4WTlrVnB6?=
 =?utf-8?B?a1F5UzlSVFRlSXc3RElHcUFLYlZ5TzBzOUs5OVF1M3pQVWJFOHZPT25BWXY2?=
 =?utf-8?B?aEc1aytod285bVlBRnBzd2czYVRDeEZVWDFMMjR2T1FMQkJ4N2hINHBzb01I?=
 =?utf-8?B?eXk1cE5xQkxHZlZpckJNc2ZHZGs3cGNBb2NpV3dwZk9iZVB1SmR2UU1CNlZ5?=
 =?utf-8?B?TDFlL3krc28wb0NkRlZTTUpEVExUVm1uaFBTbHZqQUR4S0pyMDNCaXJTNlV4?=
 =?utf-8?B?bENTcUxvdXpTWmowQnFYdDdBbHhrcjQwRlYwOUdQZ2hFNDNLQVlVbkxjbTBu?=
 =?utf-8?B?VGlzaWsxd2RQQTlEalpvMVREcGtrOWhXN2g5R2c4cWpORG91Q2tMUk11V0ha?=
 =?utf-8?B?TzZrY0lQYlA5eW9VYWFVQnk2NW1laFJHUjlXaEt0M0hmWEZFZXFTUFBMVzE1?=
 =?utf-8?B?cENlM2ZHTzJqay9LSGU5b0RHbC9pblRFYVFVMHRJRTN6Qzdva3NLellET05F?=
 =?utf-8?B?YStXS29qMHJFWFErZ1FMZTZKc25CUVV4R0REQmR2b2pOakFWbWdXZGdKTjlV?=
 =?utf-8?B?RVBYWGYxRVhhQzRvMFE1eVROcUlMc0ZSZ1lya09qckxJcHlyZGdnb216N2RX?=
 =?utf-8?B?MGl5L2xZMGJYQzZVbDVoeGFMQkFIcDBBVVoxWmN0Y2VUVEZsZnQ1bTlwT3Qr?=
 =?utf-8?B?VHo1cEdLVDEvWTY3NW5wSVdjNS9FVTMyRHU5bmVYNklSSXlsY1N2eFdhU1pO?=
 =?utf-8?B?TWRVd2xPK1NjQWZnczIwUzV3eloyUFRBaExOazhRbGxWUkdrOE5iWGh4NnFt?=
 =?utf-8?B?V0hUdWdJU1EydklsK3BQV1ovNFdjLzRVeHZuQnpER2x5elZycGdoSW1LRDFX?=
 =?utf-8?B?QlBQeEdZK2E2QjZ0bTBEcDZLd0RtanJBTERabnJuNklscUI3eHVodVpJNHYy?=
 =?utf-8?B?V1I2dW9wRUhxOHpOSk1TQkxvbXl6UG9LaTNRZFp3ZWViZ1VYa3JLTG1ZSEUx?=
 =?utf-8?B?bkt1d0Z4WXNxV0ZwTVVWODE2VWF4b0IzRTJXSTVtMEk3L21YNGFvWjNSb2E5?=
 =?utf-8?B?ZU05OG14eTZVYUxTdHRjZmVOaWJCZWlUdExtcHBaOWJwbVFGRWIvenhYZHFq?=
 =?utf-8?B?c1h2eEE3UXBDaDlSYnNUb0ltbGtqZkFWbGFpYU55Vit4MlY2dzZCTERnampS?=
 =?utf-8?B?Y2JRYjR6M2dkNkVrdjVReVc5TTFLTEtVaWtPOWpIQ1lBZzJiYVdDS0hkWmpw?=
 =?utf-8?B?WVBQR2h5UFRTMzdXSTNxcWcvaXI1Y3JGVU9NN1NVTkd6L2JvVndXWW5HZkxF?=
 =?utf-8?B?MFBHeDMwR2prOThiTEdEc3NNRHRmM2VZQmJ0c1cwd0U0Z2pBQ2JrZ0lYQ0JD?=
 =?utf-8?B?bGtrdjNmUmpWSjhWam5IbG1Eb0k2eUczeGZmQ3FUU2tTeXZObVRWOHNrbEI5?=
 =?utf-8?B?L1RHVG1sZDBubjZtM09IeWlMRkdibVZKcVo2aEVJb1ZXbFhrL1owSGZ1dERs?=
 =?utf-8?B?dzQ0aXFUMUxZQlZGZGtrOFd1N3hPaDZHY0F4WUduc0p3U3JFV3hOSmZDbk53?=
 =?utf-8?Q?3TE2FmOlKeqjNwTOlt5n740=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <69CB95F47ED69C4D9EA6C9AF952A7D5E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ea99064-5a02-453d-3fed-08dad44938c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 09:40:17.6292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CcXuGeho1cr7Ww3kP84adRfO3+SlRfOoE5Z/QZkKD89tSvY6y6vqtSBNwbgHFxnygNmRiQuvgBJv7zTkTzU2ScaqvpIjXvRGIDTV2mTauc4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6707
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQpUaGFua3MgZm9yIHRoZSByZXZpZXcgY29tbWVudC4NCg0KT24gVGh1LCAy
MDIyLTEyLTAxIGF0IDAzOjA0ICswMjAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6DQo+IEVYVEVS
TkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3Mg
eW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gTW9uLCBOb3YgMjgsIDIw
MjIgYXQgMDQ6MDI6MTlQTSArMDUzMCwgQXJ1biBSYW1hZG9zcyB3cm90ZToNCj4gPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfcHRwLmMNCj4gPiBiL2RyaXZlcnMv
bmV0L2RzYS9taWNyb2NoaXAva3N6X3B0cC5jDQo+ID4gaW5kZXggMTg0YWE1N2E4NDg5Li40MTU1
MjJlZjRjZTkgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pf
cHRwLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9wdHAuYw0KPiA+
IEBAIC0yMDAsNiArMjA5LDEyIEBAIHN0YXRpYyBpbnQga3N6X3B0cF9zZXR0aW1lKHN0cnVjdA0K
PiA+IHB0cF9jbG9ja19pbmZvICpwdHAsDQo+ID4gICAgICAgICAgICAgICBnb3RvIGVycm9yX3Jl
dHVybjsNCj4gPiANCj4gPiAgICAgICByZXQgPSBrc3pfcm13MTYoZGV2LCBSRUdfUFRQX0NMS19D
VFJMLCBQVFBfTE9BRF9USU1FLA0KPiA+IFBUUF9MT0FEX1RJTUUpOw0KPiA+ICsgICAgIGlmIChy
ZXQpDQo+ID4gKyAgICAgICAgICAgICBnb3RvIGVycm9yX3JldHVybjsNCj4gPiArDQo+ID4gKyAg
ICAgc3Bpbl9sb2NrX2JoKCZwdHBfZGF0YS0+Y2xvY2tfbG9jayk7DQo+IA0KPiBXaHkgZGlzYWJs
ZSBib3R0b20gaGFsdmVzPyBXaGVyZSBpcyB0aGUgYm90dG9tIGhhbGYgdGhhdCB0aGlzIHJhY2Vz
DQo+IHdpdGg/DQoNClRoZSBpbnRlcnJ1cHRzIGFyZSBhZGRlZCBpbiB0aGUgZm9sbG93aW5nIHBh
dGNoZXMgaW4gdGhlIHNlcmllcy4gRHVyaW5nDQp0aGUgZGVmZXJyZWQgcGFja2V0IHRpbWVzdGFt
cGluZywgcGFydGlhbCB0aW1lc3RhbXBzIGFyZSByZWNvbnN0cnVjdGVkDQp0byBhYnNvbHV0ZSB0
aW1lIHVzaW5nIHRoZSBwdHBfZGF0YS0+Y2xvY2tfdGltZSBpbiB0aGUgYm90dG9tIGhhbHZlcy4N
ClNvIHdlIG5lZWQgdGhpcyBzcGluX2xvY2tfYmguDQoNCj4gDQo+ID4gKyAgICAgcHRwX2RhdGEt
PmNsb2NrX3RpbWUgPSAqdHM7DQo+ID4gKyAgICAgc3Bpbl91bmxvY2tfYmgoJnB0cF9kYXRhLT5j
bG9ja19sb2NrKTsNCj4gPiANCj4gPiAgZXJyb3JfcmV0dXJuOg0KPiA+ICAgICAgIG11dGV4X3Vu
bG9jaygmcHRwX2RhdGEtPmxvY2spOw0KPiA+ICB9DQo+ID4gDQo+ID4gKy8qICBGdW5jdGlvbiBp
cyBwb2ludGVyIHRvIHRoZSBkb19hdXhfd29yayBpbiB0aGUgcHRwX2Nsb2NrDQo+ID4gY2FwYWJp
bGl0eSAqLw0KPiA+ICtzdGF0aWMgbG9uZyBrc3pfcHRwX2RvX2F1eF93b3JrKHN0cnVjdCBwdHBf
Y2xvY2tfaW5mbyAqcHRwKQ0KPiA+ICt7DQo+ID4gKyAgICAgc3RydWN0IGtzel9wdHBfZGF0YSAq
cHRwX2RhdGEgPSBwdHBfY2Fwc190b19kYXRhKHB0cCk7DQo+ID4gKyAgICAgc3RydWN0IGtzel9k
ZXZpY2UgKmRldiA9IHB0cF9kYXRhX3RvX2tzel9kZXYocHRwX2RhdGEpOw0KPiA+ICsgICAgIHN0
cnVjdCB0aW1lc3BlYzY0IHRzOw0KPiA+ICsNCj4gPiArICAgICBtdXRleF9sb2NrKCZwdHBfZGF0
YS0+bG9jayk7DQo+ID4gKyAgICAgX2tzel9wdHBfZ2V0dGltZShkZXYsICZ0cyk7DQo+ID4gKyAg
ICAgbXV0ZXhfdW5sb2NrKCZwdHBfZGF0YS0+bG9jayk7DQo+IA0KPiBXaHkgZG9uJ3QgeW91IGNh
bGwga3N6X3B0cF9nZXR0aW1lKHB0cCwgJnRzKSBkaXJlY3RseT8NCg0KSSB3aWxsIHVzZSBrc3pf
cHRwX2dldHRpbWUgZGlyZWN0bHkuDQoNCj4gDQo+ID4gKw0KPiA+ICsgICAgIHNwaW5fbG9ja19i
aCgmcHRwX2RhdGEtPmNsb2NrX2xvY2spOw0KPiA+ICsgICAgIHB0cF9kYXRhLT5jbG9ja190aW1l
ID0gdHM7DQo+ID4gKyAgICAgc3Bpbl91bmxvY2tfYmgoJnB0cF9kYXRhLT5jbG9ja19sb2NrKTsN
Cj4gPiArDQo+ID4gKyAgICAgcmV0dXJuIEhaOyAgLyogcmVzY2hlZHVsZSBpbiAxIHNlY29uZCAq
Lw0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0aWMgaW50IGtzel9wdHBfc3RhcnRfY2xvY2soc3Ry
dWN0IGtzel9kZXZpY2UgKmRldikNCj4gPiAgew0KPiA+IC0gICAgIHJldHVybiBrc3pfcm13MTYo
ZGV2LCBSRUdfUFRQX0NMS19DVFJMLCBQVFBfQ0xLX0VOQUJMRSwNCj4gPiBQVFBfQ0xLX0VOQUJM
RSk7DQo+ID4gKyAgICAgc3RydWN0IGtzel9wdHBfZGF0YSAqcHRwX2RhdGEgPSAmZGV2LT5wdHBf
ZGF0YTsNCj4gPiArICAgICBpbnQgcmV0Ow0KPiA+ICsNCj4gPiArICAgICByZXQgPSBrc3pfcm13
MTYoZGV2LCBSRUdfUFRQX0NMS19DVFJMLCBQVFBfQ0xLX0VOQUJMRSwNCj4gPiBQVFBfQ0xLX0VO
QUJMRSk7DQo+ID4gKyAgICAgaWYgKHJldCkNCj4gPiArICAgICAgICAgICAgIHJldHVybiByZXQ7
DQo+ID4gKw0KPiA+ICsgICAgIHNwaW5fbG9ja19iaCgmcHRwX2RhdGEtPmNsb2NrX2xvY2spOw0K
PiA+ICsgICAgIHB0cF9kYXRhLT5jbG9ja190aW1lLnR2X3NlYyA9IDA7DQo+ID4gKyAgICAgcHRw
X2RhdGEtPmNsb2NrX3RpbWUudHZfbnNlYyA9IDA7DQo+ID4gKyAgICAgc3Bpbl91bmxvY2tfYmgo
JnB0cF9kYXRhLT5jbG9ja19sb2NrKTsNCj4gDQo+IERvZXMga3N6X3B0cF9zdGFydF9jbG9jaygp
IHJhY2Ugd2l0aCBhbnl0aGluZz8gVGhlIFBUUCBjbG9jayBoYXMgbm90DQo+IGV2ZW4gYmVlbiBy
ZWdpc3RlcmVkIGJ5IHRoZSB0aW1lIHRoaXMgaGFzIGJlZW4gY2FsbGVkLiBUaGlzIGlzDQo+IGxp
dGVyYWxseQ0KPiBhbiBleGFtcGxlIG9mIHRoZSAic3Bpbl9sb2NrX2luaXQoKTsgc3Bpbl9sb2Nr
KCk7IiBhbnRpcGF0dGVybi4NCg0KWWVzLCB0aGlzIGZ1bmN0aW9uIGlzIGNhbGxlZCBiZWZvcmUg
UFRQIGNsb2NrIHJlZ2lzdGVyYXRpb24uIEkgd2lsbA0KcmVtb3ZlIHRoZSBzcGluX2xvY2sgZm9y
IGhlcmUuDQoNCj4gDQo+ID4gKw0KPiA+ICsgICAgIHJldHVybiAwOw0KPiA+ICB9DQo=
