Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384DC63ED73
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiLAKSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbiLAKR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:17:56 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5781929F;
        Thu,  1 Dec 2022 02:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669889868; x=1701425868;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0XXZDGqM0jvX7Zzjo5UJhHVS2vPL+/0sWB1pNdzLneo=;
  b=O1ErAP5PQ5BB8oswWEuQThK65IDMiPYqxWC9Opz9BJ7/TfCbJBshii98
   9bMZ6ZEElfGf5eDsPmkXepDJYUHgJQPT6GEFa4DW9G/qBm3BJYnoJcjNM
   cG4+EleHm4d4/RfjKFedxX7eno4KckRInixdmqIiogz5oWpBDqaabisaT
   dn7PQ9/hS90CduFwGZGH39o0cdPrMR6bu49HY3VDO5O1rFfrDfSx2Y7IX
   4uJCZB8hTJnQ3+EY/Xic7Te+3dXHo73XO5cCtXUHiFGmiM+p6UucLm/vF
   3kYoWeHDi+QTzWsoVt/HfmKz4Bv9voEE6mNsDhd8+f8Psr4mmD5OpC7Cw
   A==;
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="186034975"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Dec 2022 03:17:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 1 Dec 2022 03:17:39 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 1 Dec 2022 03:17:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIobXdG4PfYTZgqfkpjm8Ih3qETtIqYbYNHgghIvUlq5pXAaq5+8aRjIXowsR3IVfmM9f+WQuOWuwW5cFoOUZ0DplCoTy0dLqfgN8jt15TbukV3oSnd54ZXlLQEcZ95+DAXRPuYE/9qmx0n30BX5fa3RJmCIjczp6FDHvhV4UZJoUoMfYqIrlNmY9icyMfIXe+aTd89dvMcI6fgbUy3fTk11EVoym0c5UgVfrAIof4m7BZsqVo/XNGtDYvKUPgEJxzR+Mh0fFNadYbUvsiqX8bkfas3lef90CaMFwLH0JzUmB7uBecAhYmoQGamS6GS18qXOWeRfnykkrU7+iKrKJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0XXZDGqM0jvX7Zzjo5UJhHVS2vPL+/0sWB1pNdzLneo=;
 b=V2K907zUCCqEAU2Eckx59YI2gnST8yFAp7f1oxbTnK8K7A+N+zUC2/lazB6dKVre5W6NArCUlpT76b+1hpAgCBRh6D2EQL2Y4bQme6FUegP/iIh/WZUV1nzYbSAsOdKRj4PDjcqEf1C1iOQPPFrbOLGQC9t7oK7mODNMhXa40nMudqumR01FMAyEIlxG4vn6u67ucHcP2H9IYOM5RisYYtAnARlk+oyoPDFL+GPVbsXCEdP/PBmUNYhSoXQN7CS09/DFeFCsQ3tpJ1w9nhhnuiY8bRZiK7lvrx787tdtk3xYunXcX9VZITJHzMv9Y/wPZ6sVj4qGlm8eKg3ywF/Htg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0XXZDGqM0jvX7Zzjo5UJhHVS2vPL+/0sWB1pNdzLneo=;
 b=tWpUzM4WYCfTzdN7vyuUJrdwTwMjnoifnYuhJmm5onjpQDI4j41pi1zwXsAuMCErvihm+ORG79oPbiprKImD4tDrDjqgemXx6JbRFi8GlriqntBjq5qRr4Qsut8WY3jp+Nq18wpYjolFXXRCsMZk9torsIMzzzk5ieHgdJsIsto=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 MN2PR11MB4710.namprd11.prod.outlook.com (2603:10b6:208:262::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 10:17:36 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 10:17:36 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <ceggers@arri.de>,
        <Tristram.Ha@microchip.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [Patch net-next v1 02/12] net: dsa: microchip: ptp: Initial
 hardware time stamping support
Thread-Topic: [Patch net-next v1 02/12] net: dsa: microchip: ptp: Initial
 hardware time stamping support
Thread-Index: AQHZAxTePqOJ5uCMbEmr3ypDxG/mcK5YNKYdgAChcIA=
Date:   Thu, 1 Dec 2022 10:17:35 +0000
Message-ID: <5256a00349978d3622f8111d52bebd2c252bfc28.camel@microchip.com>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
         <20221128103227.23171-1-arun.ramadoss@microchip.com>
         <20221128103227.23171-3-arun.ramadoss@microchip.com>
         <20221128103227.23171-3-arun.ramadoss@microchip.com>
         <20221201003924.rxtratph4ezu65dm@skbuf>
In-Reply-To: <20221201003924.rxtratph4ezu65dm@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|MN2PR11MB4710:EE_
x-ms-office365-filtering-correlation-id: 8181a3fb-3cc1-4206-b11a-08dad385448d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l0n9QQwoVcEkKPLEnfJktBV7476jXA01bPIDz7ljFv9P48q+t6QAlMr2p+591Iw3A0Z9qOjj5dtoD5nbi14lkO5JKLU0h8WZQ8+0IAJeiWB3z0GAuYBWSMcY+It4sMBpJgi+XH+M3s4QQZki1SsssshF8tlbIbj88z0o9TVy0W0NldhoKTQJ9IVu3Of7UPi6d9JYj8eMfjobrwbIet+6B78P9ROw7NTCtVKQKMc4ZJWiK69+2zKxLk5qt+yEWL/XGojPVb1riSKMRBxFQyj/ADHFhz2cWOswJX/qxOKWaeBs3ae/4v6wl6IrUyLSa/Bf3U9ZPwwGCtt6X0Z6mO3ux0A4EJnDj++oqtX60hmoiDqyBYkaeR9+uM1oqr4ayBAkU1ZsyuNnTrMxnhWZy7limB8eOz2XEX7wcd3H7gvuAgfoyf0zVEeAkzncQTPmfhETuwi2XG8ohLwFC24SPcy5ADfFMePD8UZEim7H1xVf8UHhUafoJpS5qLnALVzOm7NcEXSjx9bBOj9+rOcSgd7wI273586cLPQH2rFSzoEyPzKfnbPFyQOrm0bj/ozZC9xFsk/f1Q/OKUzO7eix6MLmPKrJClC4h17Am6faiYRxiJjm5qxBsAQZe1gqxQdm89rSRUo3c4jk0HfOAr0jaiIAxRe+Q6ql3OtFTyUfz6e3KRHuggVZ9Y+5ACmnnzNMd6FF/sSIq89Bx70PS4J+GEaPhhPkd975Qasso4lfkBiLz2w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(366004)(376002)(136003)(451199015)(2906002)(83380400001)(38070700005)(2616005)(7416002)(41300700001)(5660300002)(36756003)(8936002)(186003)(86362001)(38100700002)(122000001)(316002)(6916009)(54906003)(26005)(6512007)(6506007)(478600001)(6486002)(4326008)(71200400001)(8676002)(64756008)(91956017)(66946007)(66476007)(66556008)(76116006)(66446008)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OXc1R0wyeDkxblNMTXl5TTdXbU1sRTRlcFpzR29PWW1JTWhtWkpNY0k2UHgy?=
 =?utf-8?B?NXVsd0tIajZ6M0NRK09tQ3Zab2oyK1NxTkdLMXZLaC9od3NxWHp1L1RNZDBl?=
 =?utf-8?B?WFFqdHNtcTZaL05qVjUzZUlTWFlySzVLL2dhR1FHb0dsZEtGZ1JKNkFlSDlT?=
 =?utf-8?B?QnlXY2w2QlJRWEFRdkhwdzRQaHl5bE1haTJTOXg2SGltL0xvYkRuc3NXSGhG?=
 =?utf-8?B?MWRFc2J6bUpKRUZWczFPZ3p5Vzg1UUVpZVdTOFEyRWRIS2N5aU5mMEo4U0gx?=
 =?utf-8?B?Yk5LSFFuRjlIUWU5MFpuQnNWbDFGT0Z3dDNoSmVJbHFQa2plUjNMRnFyZldl?=
 =?utf-8?B?Z1RJVUIvaG9QUWs4ZGhLOFV6d2xWcXBvTFI2NnR2Qm41bWwxNHlkcUR0ek9y?=
 =?utf-8?B?NGJOWDkwblc5YnhDQzAzY1hseHY5Z1RndTNPUE5pR3Rmck52U0VXNHp6OGJ1?=
 =?utf-8?B?N1RIcGdsa2NnQzdCUU52NU1XZERJSDhXSUxRd0ZxUFFua1lrSUEzb3Z6NVR1?=
 =?utf-8?B?MGdUbUtlMkN5eHJhckpocEk1ZzdHOXhmZ29JUUU4bk1uNzlFSDNNZ1hNK3lt?=
 =?utf-8?B?N1dsZTBpT1B6N3FNT2s5NWRoSFNobzFnUGZrTS9FTDloZy9mY2k4ai9SQzFU?=
 =?utf-8?B?ZG5tcjlybGcraGpEOWFyc1FXemxnRllodG5CNHlqYXg3UXVMVTNFUUd5RnZs?=
 =?utf-8?B?eGxScUdzT1hEYTFzQjA1L1VUUkxzQmdJK0ZkSm92VlhPNnA1Rzh3dXNUL3dk?=
 =?utf-8?B?NmZST0hjV1NoT2dtOWllMzFSdUEyNlo5ZFpKdFVORytsQXh5bGhVS1JCL2w3?=
 =?utf-8?B?ZEtwdW8wRDBvUEZRdU5tRzNxZE5WYlV3RDJCZUxCVGsxcE5EV0Qwbm5VZnds?=
 =?utf-8?B?YXVKVXk0ZVJJTnBJQWZ3Rm5KeXRNM1ZPNGtoZWZEYkU2empnR3JhMVhWeWRU?=
 =?utf-8?B?UEhzMlkzWmN6Mm01SnB1clF1azI3WmlHeFlVYTRvdHdmNm1HOHN0YmE5SGxL?=
 =?utf-8?B?VzFOR0tJaVJuWU5WdFc4dnZNQ0g4WG5ZNGJUZFgxa2RHdHVpYURpUVhyWE1z?=
 =?utf-8?B?bERhenJrd0xoaEJsb1VheWVIL2w5VHpaSEtRdW93YnFEUUYwRytXNE1mdU5u?=
 =?utf-8?B?L21QblByM3QxK0lUK1VvSFhqMDlWUHRqODNvWk1MZnpnOUJHUlg0TVlKU3pv?=
 =?utf-8?B?dHBiS2o5aXRTZXQ0UmJPWlNLdDZxZzMyT0RLNWVKT3d1QVlaV1dOOStwTHdU?=
 =?utf-8?B?enArTWgxdmFQUUpEcDhvbzRTT2ZrKzUvZklCYUpWVTJyQnB3ckgyYXU5c0U5?=
 =?utf-8?B?MmZYRzRnTkNYT0pZWEJ0UUo3WmZrZGNUNUxXa1VhVFZtZVNXN1pubmtTeS9D?=
 =?utf-8?B?YXFrdWhxeWgzZFZsWE13bVBaV3NTVEdweUEyendkenhyZ09iWVB3VmQ0SDR2?=
 =?utf-8?B?Ylc1R1NlNnRRaWRoRW9yWm9TWldJNjBIV05FUDN3a0F1N0M2S3phNGo0NnBr?=
 =?utf-8?B?U2NOTEwxamQ0K2wxanZEQUdJSDVic0JsWkdQM0EyWTJ6NkxFSE9oamdXN3Br?=
 =?utf-8?B?dlVINHhNT0ZENngvMDd2QUtpekpsYWJrSHJvd0VvcE9sY215SURZODdrUXRJ?=
 =?utf-8?B?dFZiTVJodmFNczg3d29CeDFVRmREaDhNYjdoRkZMOFZZaXplN0hVMjRMajVB?=
 =?utf-8?B?V0xBTDRXTFBIaGVhNk9DTkRHVU5ZRjY0bWQ4TEtJZTNhNW43bnRSSFcxeDRv?=
 =?utf-8?B?dC9vRWNQcGNwWnZJby9UNjQwUGw1MDBjZkhCYVlQaGw3VXl1ZkJ2Uyt6OFVD?=
 =?utf-8?B?a2t6aDVaK3NFeHpQTUxwOHF3UHlCOW5zOEpzeUVtUXFoR2tZT3hCNENyVHcx?=
 =?utf-8?B?WUFBOFZ0SkxmWURHUkNHQjlqMXB6WmxjeGRQQU44MUFvNXNGb25HdVAwTDNr?=
 =?utf-8?B?SmQ2WUxMeFJzampvc2dIZDNEZGtKMDVXTWdLNnM4Q1R3cUttVno2ZEVYb09x?=
 =?utf-8?B?aDhUa2RnM3p1bFJYemZOSXBvT1VoZktLK2FJT0tWQ2VmZFVBVDlqUlBrNm5I?=
 =?utf-8?B?b3pNcG9wU2VxYTRuR0s2SlJwZVR2dUhEOWlzV0VNTWNPRlFtZ2M1MUV4emwy?=
 =?utf-8?B?NldFQlFITDlNVTQ1YUlvZGwrcVEvdEw1RVFyQzFVUG9tUG45WjBOcEt2WEZv?=
 =?utf-8?Q?XaH+pBGv5yPieXLpS2oDnA0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <56421065E6229E45845E550AD234CE9E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8181a3fb-3cc1-4206-b11a-08dad385448d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2022 10:17:36.0281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DAxquboUp9MKF6T1ti8354s2S+IRWk1KYSuXCJmSA9FcWb9dIACfFcD+jJeyOJkjB8T3VH2uR4UolZ6oJUe8qf27pDp4Q8VbM3f7eDfmZmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4710
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNCk9uIFRodSwgMjAyMi0xMi0wMSBhdCAwMjozOSArMDIwMCwgVmxhZGlt
aXIgT2x0ZWFuIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9y
IG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUN
Cj4gDQo+IE9uIE1vbiwgTm92IDI4LCAyMDIyIGF0IDA0OjAyOjE3UE0gKzA1MzAsIEFydW4gUmFt
YWRvc3Mgd3JvdGU6DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAv
a3N6X2NvbW1vbi5oDQo+ID4gYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24u
aA0KPiA+IGluZGV4IDVhNmJmZDQyYzZmOS4uY2QyMGYzOWE1NjVmIDEwMDY0NA0KPiA+IC0tLSBh
L2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oDQo+ID4gKysrIGIvZHJpdmVy
cy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmgNCj4gPiBAQCAtMTAzLDYgKzEwMywxMCBA
QCBzdHJ1Y3Qga3N6X3BvcnQgew0KPiA+ICAgICAgIHN0cnVjdCBrc3pfZGV2aWNlICprc3pfZGV2
Ow0KPiA+ICAgICAgIHN0cnVjdCBrc3pfaXJxIHBpcnE7DQo+ID4gICAgICAgdTggbnVtOw0KPiA+
ICsjaWYgSVNfRU5BQkxFRChDT05GSUdfTkVUX0RTQV9NSUNST0NISVBfS1NaX1BUUCkNCj4gPiAr
ICAgICB1OCBod3RzX3R4X2VuOw0KPiANCj4gVmFyaWFibGUgbmFtZWQgImVuIiAoZW5hYmxlKSB3
aGljaCB0YWtlcyB0aGUgdmFsdWVzIDAgb3IgMj8gTm90IGdvb2QuDQo+IEFsc28sIHdoeSBpcyB0
aGUgdHlwZSBub3QgZW51bSBod3RzdGFtcF90eF90eXBlcywgYnV0IHU4PyBDYW4ndCB5b3UNCj4g
bmFtZQ0KPiB0aGlzICJlbnVtIGh3dHN0YW1wX3R4X3R5cGVzIHR4X3R5cGUiPw0KPiANCj4gPiAr
ICAgICBib29sIGh3dHNfcnhfZW47DQo+ID4gKyNlbmRpZg0KPiA+ICB9Ow0KDQpJIHdpbGwgcmVu
YW1lIHZhcmlhYmxlLg0KDQo+ID4gDQo+ID4gIHN0cnVjdCBrc3pfZGV2aWNlIHsNCj4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfcHRwLmMNCj4gPiBiL2RyaXZl
cnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X3B0cC5jDQo+ID4gaW5kZXggYzczNzYzNWNhMjY2Li5h
NDE0MThjNmFkZjYgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9r
c3pfcHRwLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9wdHAuYw0K
PiA+IEBAIC0zNiwxNSArMzYsODggQEAgaW50IGtzel9nZXRfdHNfaW5mbyhzdHJ1Y3QgZHNhX3N3
aXRjaCAqZHMsIGludA0KPiA+IHBvcnQsIHN0cnVjdCBldGh0b29sX3RzX2luZm8gKnRzKQ0KPiA+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBTT0ZfVElNRVNUQU1QSU5HX1JYX0hBUkRXQVJF
IHwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgU09GX1RJTUVTVEFNUElOR19SQVdf
SEFSRFdBUkU7DQo+ID4gDQo+ID4gLSAgICAgdHMtPnR4X3R5cGVzID0gQklUKEhXVFNUQU1QX1RY
X09GRik7DQo+ID4gKyAgICAgdHMtPnR4X3R5cGVzID0gQklUKEhXVFNUQU1QX1RYX09GRikgfA0K
PiA+IEJJVChIV1RTVEFNUF9UWF9PTkVTVEVQX1AyUCk7DQo+ID4gDQo+ID4gLSAgICAgdHMtPnJ4
X2ZpbHRlcnMgPSBCSVQoSFdUU1RBTVBfRklMVEVSX05PTkUpOw0KPiA+ICsgICAgIHRzLT5yeF9m
aWx0ZXJzID0gQklUKEhXVFNUQU1QX0ZJTFRFUl9OT05FKSB8DQo+ID4gQklUKEhXVFNUQU1QX0ZJ
TFRFUl9BTEwpOw0KPiA+IA0KPiA+ICAgICAgIHRzLT5waGNfaW5kZXggPSBwdHBfY2xvY2tfaW5k
ZXgocHRwX2RhdGEtPmNsb2NrKTsNCj4gPiANCj4gPiAgICAgICByZXR1cm4gMDsNCj4gPiAgfQ0K
PiA+IA0KPiA+ICtpbnQga3N6X2h3dHN0YW1wX2dldChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGlu
dCBwb3J0LCBzdHJ1Y3QgaWZyZXENCj4gPiAqaWZyKQ0KPiA+ICt7DQo+ID4gKyAgICAgc3RydWN0
IGtzel9kZXZpY2UgKmRldiA9IGRzLT5wcml2Ow0KPiA+ICsgICAgIHN0cnVjdCBod3RzdGFtcF9j
b25maWcgY29uZmlnOw0KPiA+ICsNCj4gPiArICAgICBjb25maWcuZmxhZ3MgPSAwOw0KPiA+ICsN
Cj4gPiArICAgICBjb25maWcudHhfdHlwZSA9IGRldi0+cG9ydHNbcG9ydF0uaHd0c190eF9lbjsN
Cj4gPiArDQo+ID4gKyAgICAgaWYgKGRldi0+cG9ydHNbcG9ydF0uaHd0c19yeF9lbikNCj4gPiAr
ICAgICAgICAgICAgIGNvbmZpZy5yeF9maWx0ZXIgPSBIV1RTVEFNUF9GSUxURVJfQUxMOw0KPiA+
ICsgICAgIGVsc2UNCj4gPiArICAgICAgICAgICAgIGNvbmZpZy5yeF9maWx0ZXIgPSBIV1RTVEFN
UF9GSUxURVJfTk9ORTsNCj4gPiArDQo+ID4gKyAgICAgcmV0dXJuIGNvcHlfdG9fdXNlcihpZnIt
Pmlmcl9kYXRhLCAmY29uZmlnLCBzaXplb2YoY29uZmlnKSkgPw0KPiA+ICsgICAgICAgICAgICAg
LUVGQVVMVCA6IDA7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyBpbnQga3N6X3NldF9od3Rz
dGFtcF9jb25maWcoc3RydWN0IGtzel9kZXZpY2UgKmRldiwgaW50DQo+ID4gcG9ydCwNCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgaHd0c3RhbXBfY29uZmlnICpj
b25maWcpDQo+ID4gK3sNCj4gPiArICAgICBzdHJ1Y3Qga3N6X3BvcnQgKnBydCA9ICZkZXYtPnBv
cnRzW3BvcnRdOw0KPiA+ICsNCj4gPiArICAgICBpZiAoY29uZmlnLT5mbGFncykNCj4gPiArICAg
ICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0KPiA+ICsNCj4gPiArICAgICBzd2l0Y2ggKGNvbmZp
Zy0+dHhfdHlwZSkgew0KPiA+ICsgICAgIGNhc2UgSFdUU1RBTVBfVFhfT0ZGOg0KPiA+ICsgICAg
IGNhc2UgSFdUU1RBTVBfVFhfT05FU1RFUF9QMlA6DQo+ID4gKyAgICAgICAgICAgICBwcnQtPmh3
dHNfdHhfZW4gPSBjb25maWctPnR4X3R5cGU7DQo+ID4gKyAgICAgICAgICAgICBicmVhazsNCj4g
PiArICAgICBkZWZhdWx0Og0KPiA+ICsgICAgICAgICAgICAgcmV0dXJuIC1FUkFOR0U7DQo+ID4g
KyAgICAgfQ0KPiA+ICsNCj4gPiArICAgICBzd2l0Y2ggKGNvbmZpZy0+cnhfZmlsdGVyKSB7DQo+
ID4gKyAgICAgY2FzZSBIV1RTVEFNUF9GSUxURVJfTk9ORToNCj4gPiArICAgICAgICAgICAgIHBy
dC0+aHd0c19yeF9lbiA9IGZhbHNlOw0KPiA+ICsgICAgICAgICAgICAgYnJlYWs7DQo+ID4gKyAg
ICAgZGVmYXVsdDoNCj4gPiArICAgICAgICAgICAgIHBydC0+aHd0c19yeF9lbiA9IHRydWU7DQo+
ID4gKyAgICAgICAgICAgICBicmVhazsNCj4gPiArICAgICB9DQo+ID4gKw0KPiA+ICsgICAgIHJl
dHVybiAwOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtpbnQga3N6X2h3dHN0YW1wX3NldChzdHJ1Y3Qg
ZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0LCBzdHJ1Y3QgaWZyZXENCj4gPiAqaWZyKQ0KPiA+ICt7
DQo+ID4gKyAgICAgc3RydWN0IGtzel9kZXZpY2UgKmRldiA9IGRzLT5wcml2Ow0KPiA+ICsgICAg
IHN0cnVjdCBrc3pfcHRwX2RhdGEgKnB0cF9kYXRhOw0KPiA+ICsgICAgIHN0cnVjdCBod3RzdGFt
cF9jb25maWcgY29uZmlnOw0KPiA+ICsgICAgIGludCByZXQ7DQo+ID4gKw0KPiA+ICsgICAgIHB0
cF9kYXRhID0gJmRldi0+cHRwX2RhdGE7DQo+ID4gKw0KPiA+ICsgICAgIG11dGV4X2xvY2soJnB0
cF9kYXRhLT5sb2NrKTsNCj4gDQo+IEknbSBub3Qgc3VyZSB0aGF0IHRoaXMgbXV0ZXggc2VydmVz
IGFueSBwdXJwb3NlIGF0IGFsbD8NCj4gDQo+IE9uZSBjb3VsZCBoYXZlIGFyZ3VlZCB0aGF0IGNv
bmN1cnJlbnQgY2FsbHMgdG8ga3N6X2h3dHN0YW1wX2dldCgpDQo+IHNob3VsZG4ndCBiZSBhYmxl
IHRvIHNlZSBpbmNvaGVyZW50IHZhbHVlcyBvZiBwcnQtPmh3dHNfdHhfZW4gYW5kIG9mDQo+IHBy
dC0+aHd0c19yeF9lbi4NCj4gDQo+IEJ1dCBrc3pfaHd0c3RhbXBfZ2V0KCkgZG9lc24ndCBhY3F1
aXJlIHRoaXMgbXV0ZXgsIHNvIHRoYXQgaXMgbm90DQo+IHRydWUsDQo+IHRoaXMgaXNuJ3Qgd2h5
IHRoZSBtdXRleCBpcyBhY3F1aXJlZCBoZXJlLiBJIGRvbid0IGtub3cgd2h5IGl0IGlzLg0KDQpN
dXRleCBpcyBub3QgbmVlZGVkLiBJIHdpbGwgcmVtb3ZlIGl0Lg0KDQo+IA0KPiA+ICsNCj4gPiAr
ICAgICByZXQgPSBjb3B5X2Zyb21fdXNlcigmY29uZmlnLCBpZnItPmlmcl9kYXRhLCBzaXplb2Yo
Y29uZmlnKSk7DQo+ID4gKyAgICAgaWYgKHJldCkNCj4gPiArICAgICAgICAgICAgIGdvdG8gZXJy
b3JfcmV0dXJuOw0KPiA+ICsNCj4gPiArICAgICByZXQgPSBrc3pfc2V0X2h3dHN0YW1wX2NvbmZp
ZyhkZXYsIHBvcnQsICZjb25maWcpOw0KPiA+ICsgICAgIGlmIChyZXQpDQo+ID4gKyAgICAgICAg
ICAgICBnb3RvIGVycm9yX3JldHVybjsNCj4gPiArDQo+ID4gKyAgICAgcmV0ID0gY29weV90b191
c2VyKGlmci0+aWZyX2RhdGEsICZjb25maWcsIHNpemVvZihjb25maWcpKTsNCj4gPiArDQo+ID4g
K2Vycm9yX3JldHVybjoNCj4gPiArICAgICBtdXRleF91bmxvY2soJnB0cF9kYXRhLT5sb2NrKTsN
Cj4gPiArICAgICByZXR1cm4gcmV0Ow0KPiA+ICt9DQo=
