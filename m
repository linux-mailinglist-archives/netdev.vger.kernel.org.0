Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2DDF562E83
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 10:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbiGAIiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 04:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234882AbiGAIiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 04:38:13 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1403B311;
        Fri,  1 Jul 2022 01:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656664692; x=1688200692;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1FlkTk9KC2MmqAwVIMrstj5EuYxS7FJgr7xy7h7L4jk=;
  b=r/ml4I1c3xI+/H+dlOE3z5nlUPyMCH5FtybPrAq4aNiv7b8fixuTxkuh
   NTzNnpyL+4HXH82oQoZDeYxfi+uQdy1fyOsiwDnudWJAjP6gXYP3VGFzP
   27N8p9wSPlm1y46UgdKSG+XhE4/h57ZTeuER+ZT/kUp/jUFB5HaEdl9He
   fTXLMKBOdq2auoQbynXMCzRf+tXZvwrMN/UlsH0z/lIAFYmLZ9tl8v7fT
   YDDWdMwcj/6lHogh2Aa3WbVwtG0xaqOd0WA77NH8iTes3Q+Y4wwEdNnv5
   Is3+ufGFz4/NT+IHmCxfagvRlqnPFV4abZpDV+boRDz4NYOXAtHJqJwSu
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="170385478"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2022 01:38:11 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Jul 2022 01:38:09 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 1 Jul 2022 01:38:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hf3+bpgmFi78YBYSlD/drzAO98FbvOQ1/s0M8GcQG4IH2PRExaQ3mhqJDUBjOaNZQGQ5M2dUG/oKwPU5ytrPfCiZIkEnsSkY4mUe0X+t4Sp/H49XVs79puLLCYb53Pyp5eXBxb/0TpUj6TAuHfl6Ts/Exj/mWCaFh2hyFWzUjzkU6WomzxogJXVh/Uqgh9gYO9MpcLp25Y/5oftitnfoDbg4gZSZjDzZdtBX2UDtr3UBLMKOtUvXLShQbWamur4tB2MCHAhKKVstI6LmHPsFS1paHXpxlbp+/ZU1qNI3LBbFXJ9MEHW08fn9h2TsX8/F6397u+W2MtJaZMn2U5j0Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1FlkTk9KC2MmqAwVIMrstj5EuYxS7FJgr7xy7h7L4jk=;
 b=iooeUSZmGM4V+dmWs4W4idahdqp3xTuDzC0X9A0P9VSn0knR9qSY1G4FZxUolbo/NIRUgrg6CRuSVBsfz69bTs3AlqvNGi+g1c4YHXtzQbyKAdwte5BRdusizY6VB1oq8vpn4rFwEmovgqi3eHzK8q9Q8d5kTVpF2VDb3aq8mn0JGu1Nnb57itDpECqJVTfqu83EckFKrftkBZiV5718h5Ii8JZebYzDEgEaiC0RC4+uFsH/bnXB0JjLV20CmRGJmYgpJ9/iiMEcXw5kZvXoJ/Y1GEK5FXKF8kx7QyKvumF1pE+rOH13OmOgrbtyTmT1gSGonwd5Bnzach7lTkLl6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1FlkTk9KC2MmqAwVIMrstj5EuYxS7FJgr7xy7h7L4jk=;
 b=DihqaK4fEbT2QgK5t1tDoNr6qwuy65ugqyNpE0MhUc/2YHIZCvrggEjMsYebPYH6jgnpkl616Fqy54rhGFwq6rKUn1O6623QaR3QG0mQOz1U04lYtPummVInlMFVaC+obp1V2MSqqfXiAYRCBfmffYWI7UjGIEF4g2Kc6qtck9s=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 IA1PR11MB6491.namprd11.prod.outlook.com (2603:10b6:208:3a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Fri, 1 Jul
 2022 08:37:59 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0%6]) with mapi id 15.20.5395.014; Fri, 1 Jul 2022
 08:37:59 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <linux@armlinux.org.uk>
CC:     <olteanv@gmail.com>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <ast@kernel.org>, <bpf@vger.kernel.org>, <andrew@lunn.ch>,
        <devicetree@vger.kernel.org>, <robh+dt@kernel.org>,
        <andrii@kernel.org>, <songliubraving@fb.com>,
        <f.fainelli@gmail.com>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <kpsingh@kernel.org>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <yhs@fb.com>,
        <davem@davemloft.net>, <kafai@fb.com>
Subject: Re: [Patch net-next v14 10/13] net: dsa: microchip: lan937x: add
 phylink_get_caps support
Thread-Topic: [Patch net-next v14 10/13] net: dsa: microchip: lan937x: add
 phylink_get_caps support
Thread-Index: AQHYjGt2EVBpKmmXeEimAK9I8lVU1a1n0muAgAEx+oCAACYWAIAACGkA
Date:   Fri, 1 Jul 2022 08:37:58 +0000
Message-ID: <dc75d2c92c046629467e010d099e2c37a852c686.camel@microchip.com>
References: <20220630102041.25555-1-arun.ramadoss@microchip.com>
         <20220630102041.25555-11-arun.ramadoss@microchip.com>
         <Yr2KuQonUBo74As+@shell.armlinux.org.uk>
         <4cf0a3ba409dcb0768150c2a1a181753dddc595b.camel@microchip.com>
         <Yr6rWE38HH3dSQHV@shell.armlinux.org.uk>
In-Reply-To: <Yr6rWE38HH3dSQHV@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1766fb8d-afa4-4129-cd5f-08da5b3d00b5
x-ms-traffictypediagnostic: IA1PR11MB6491:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qmFzXoodcWwH0uW47bKNf18WUEwNm2SwkaLipwwQE+KPPiqo+WYWHrstZR82IgcPMdILSpvUAwtAcrQRY2De8nYULmAUi6gM8mOsKZLopDpJSvgYIyZ1SRqmToUQTOlbG/1ZwSK9zHd86yHEKCvg707o2plRoKYhCACjnePQ9p2PxXceDmD0oXcfaJbdovPa19CW6G+2eDbm5LBdwsPOYnR1szm0GMOGKC9Ts8razU2U+4Tp42l8jp3tXfnzM7HiLwInPyTq0HMEwTjrNoRHPLvc8iJfw8NALuhZGGaVyUlD2CCo2lhJKfVtZ5/HHC894SqYRnZ1vJe+pNo4Gu5C1sbmGLSZPoB8yboP4Lhph9xMI6rIUC7CJU1otXByLeD89jK8IYRE19dFlQe4QciTVSSe0ULQfFxFteltKBcLRZyQqU+XdrlH6YTG0ruALO7NO0DGNP/Z/FiFCa9ks44gQK/8QzTb/HIWrLpxKVi+vJTqAMDBHlqYfxMfi/GNIOUDEBH8EL1eA5bZH2oWHBwMeY+Hja/1X4RhJ5n4RDAtLBDwwselkTCaNV4wdSV9RiK7e9ZKAvKXpylOCH7ate6rRk3PLLtBoyCjjxieF5+/KKugiwyq0lBUrLXxzsYa5HSnybXeTvSSGIPLV7KIDCJvK2gYmUFe28tGq9KSPzU8LkFJM1ZBrVfQd0kfcDYTCw0Aiawi6SNhuCCPFzl+VlDS8jXChjQmMg1yFxvwMU9mXBfb0MYt1f2JN9zJPXFhgamTsQbsX/XYii+HbHkyZ+NE1jEkrCf9vobewWOb45cOusZCKPQsVqOwQe+zdp1j43EV26lH0u5STChzwBVZX1eGb7alsnW7BgaPXtib4wRG1iyxj1gwQZv7XKO5CJnDcDCt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39860400002)(376002)(136003)(396003)(66476007)(38100700002)(36756003)(4326008)(6506007)(6512007)(91956017)(71200400001)(86362001)(26005)(2906002)(122000001)(54906003)(38070700005)(6486002)(66946007)(186003)(8676002)(64756008)(83380400001)(8936002)(6916009)(5660300002)(7416002)(76116006)(478600001)(66446008)(966005)(2616005)(66556008)(41300700001)(316002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QnlLQzZPakU2VHhxM2VZRmtrNFFyMWRhak05ZHJ6ZitraXlwMXNWRmhMKzFx?=
 =?utf-8?B?SzJEUlFWenBacnA0ZTRlNlFyNkV1Mm5Ic0ZBYjBFU001NWpEVzdBYnhnUEJQ?=
 =?utf-8?B?bHkxVld2OGRIc0NXL2VuelR0SHRkeFpDY2xwRmdxb2hHVitYbVpHN2hQSlZU?=
 =?utf-8?B?S2hRWTI3QWN2T3J6WjkrWnFJdHFjUVVNVnl4VjV6N25aYkZpVE9tVjNuZU1I?=
 =?utf-8?B?c0VBVDZzUml2TEllbGtTeDhBWlpScjJYUGd5NUZvYTJGRU81ck8reEhKaHBi?=
 =?utf-8?B?STdSbE1yT1RZdnNpSTdsTEVKcnRDdTdRTzZQV0hKTDVKak5Mb1pMcVl6eVo1?=
 =?utf-8?B?em14TGFvNHdyNVRvVG9XU0RHRFBhT3RobnVRODRZbGFZZTZMYlIvaVc1MjFP?=
 =?utf-8?B?Y2NsTktqME1sOFI0L0Q4RDEzaE95bS9GRTRXa1JzM0pNMWVpaEFxSWNib1hh?=
 =?utf-8?B?U2xBS1hKRW9XSmxlTC84QWZIcVZoRjFvT1FaL2psRW4rN3FJNVJEQ3BHZFBB?=
 =?utf-8?B?M041ZWdvYkJWWFA5aGkxcFkwZTRUem1kY0lHTTF3RDJVTkNDWXdFQWxkUHk4?=
 =?utf-8?B?S3Jabk0wNjhRMWhrOUI3VVorWktzMFBIOHZUcDFmeFZEUGlUMVcyL0hDalcw?=
 =?utf-8?B?azYyTnRsU28vdm9reFFoYmJBSWgzNXAxVkE3VFJvR1dubGxyMjdQdTNIUkgz?=
 =?utf-8?B?bGVqdGgydjRWK1ZMRVRyczV5SHlNdFMrelA1UEpyMTBRTm9MUC95RVAyblky?=
 =?utf-8?B?Vzd5dzRac1NSUE00OU1vNUx5azErbFZxUXI1S0REM3IrRG5DRFZTekM1N2sr?=
 =?utf-8?B?UGdCZWJ2VC9ud003alVXZWlaMktYK2dRK1RBeUkwcVNrV0NVRUpiSlNJTnlY?=
 =?utf-8?B?YXBnSE5zVzcvdm8zb3kyNll2ckVuNEt1c0ptS21BKzNKK2dBQU10V0hWMzBl?=
 =?utf-8?B?V3ZxSUxocnFER0tpQ3JNTXFMRW9jL0g5VzhoN25hOG1XUUxYdVg5dDV6c0Zh?=
 =?utf-8?B?OVBXNTAxcTBOUzVlSlc5VUppNFJkd0tFZXhRZ1YvM2o1SDNRM0Q0VWZrcWdS?=
 =?utf-8?B?Y1VvaEVLVWNPekw2NjgzU01RMkdpRFN3R2xSQ0s3KzdpODRxVGFpVnZZRy92?=
 =?utf-8?B?TkhLSHpoNXloeXNKNnNmelJkSVExT3BsdE5XR25sSFdJYzJENUNvMmVjSnlZ?=
 =?utf-8?B?ZytYYWVxOFZQYWlVRjZEcUd4Q0EvY3VCYmgxbWppWUJPUEtuaktwSTd5MTVK?=
 =?utf-8?B?Z2ozQ0draEpGYkVJVUhjSXVnTlVibGtpMUNINjlGZFNjYitIUlVWM1hiS3ds?=
 =?utf-8?B?YkVCdFdRd0FtUThUR2gzMnpOaEM2WVN1NU5mWWI4U2ZVMDJjdEtCeEFpUC9S?=
 =?utf-8?B?NkI5eHpQWFZKQi9yUFkwT1ZjTy9OK2s4WXdSSnphNTdyUHRmRzRTY3FUTUhE?=
 =?utf-8?B?WUFlZGVZcW9HbzRRaktyeDlYVDROUU1iVzJEZldGeVNnUEphS2d1UE9RRFpP?=
 =?utf-8?B?dzZLOHF1cWllMU56V1pHSWFDeWd0VGZFYldqMzFiNjFGU2ZaOEpXd3RHNkNY?=
 =?utf-8?B?bDNoMktkdS9JV0ZnZVRER2Z0ZzVZMFJXdmtnTUR5U3dzNFU5S3pWSDkrNEQx?=
 =?utf-8?B?WDVFYk4xK1V3Umc2T1RSRWZYWGZ1NnRYdE5qbXVEdk5oVytDb2V2anlKcmlv?=
 =?utf-8?B?MCtpZXhYQ0c0WVZYTFU3NW05QkhwbmZCUWVqU0hNRERvWW9XSVBpZDVVYWt4?=
 =?utf-8?B?YnEyL0dPRTIxK0d4VWpVWVY5dUhNWlE5R3k3MjNia3h6T0VpNEVWd2VZQ3hJ?=
 =?utf-8?B?eWdBVFk2d1hKbXVoWmNqT3JMYW1ydHE2RTlkMGhTdFJPWkdXb1BncEczcEdl?=
 =?utf-8?B?ZHlpSEJDV2crRUljS3BMVFpYQ2dWMFQwRU5TSlg5QW1kMlRiRGdJelAzWGR2?=
 =?utf-8?B?QkdzTHM1eFN3Q1YwMlB2cXB5K1QrSkhHc2Q3d0M1WFd6dEVFaFdoU1BZN3Fl?=
 =?utf-8?B?WjBKd2QvM2xlcW1JQWo3V2d3RDFWSGdYNUJHcUo4dUNhUlVSQno5NVo1b2hu?=
 =?utf-8?B?RmdaZWZCaHdUUmd6NlRwazV3UGdIRm4yejNINGl6ZUFkcnNlcXR1aWhJemRR?=
 =?utf-8?B?ZXM4T1BTVWE0TTNONStCcUF5TldqNGJldWJMMitDYk9sdFBkeGxBVUcxRGJq?=
 =?utf-8?Q?KVwU1f8tS7TPFkpdnvq/VGM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B894B24DF1EC5042BD1768903581E33D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1766fb8d-afa4-4129-cd5f-08da5b3d00b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 08:37:58.8768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uoswi/nCaeYmqDU6MBi5lAO0lG+Uk7dz7bzE/kO/GDwWw/ln5KkqpXTeaVEOQetkO5WsqlmCqNFu7X5n2Q7C65GWQ3DdFzjENVC/gdePyPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6491
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTA3LTAxIGF0IDA5OjA3ICswMTAwLCBSdXNzZWxsIEtpbmcgKE9yYWNsZSkg
d3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRh
Y2htZW50cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24g
RnJpLCBKdWwgMDEsIDIwMjIgYXQgMDU6NTE6MzNBTSArMDAwMCwgQXJ1bi5SYW1hZG9zc0BtaWNy
b2NoaXAuY29tDQo+ICB3cm90ZToNCj4gPiA+ID4gK3ZvaWQgbGFuOTM3eF9waHlsaW5rX2dldF9j
YXBzKHN0cnVjdCBrc3pfZGV2aWNlICpkZXYsIGludA0KPiA+ID4gPiBwb3J0LA0KPiA+ID4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHBoeWxpbmtfY29uZmlnICpjb25maWcp
DQo+ID4gPiA+ICt7DQo+ID4gPiA+ICsgICAgIGNvbmZpZy0+bWFjX2NhcGFiaWxpdGllcyA9IE1B
Q18xMDBGRDsNCj4gPiA+ID4gKw0KPiA+ID4gPiArICAgICBpZiAoZGV2LT5pbmZvLT5zdXBwb3J0
c19yZ21paVtwb3J0XSkgew0KPiA+ID4gPiArICAgICAgICAgICAgIC8qIE1JSS9STUlJL1JHTUlJ
IHBvcnRzICovDQo+ID4gPiA+ICsgICAgICAgICAgICAgY29uZmlnLT5tYWNfY2FwYWJpbGl0aWVz
IHw9IE1BQ19BU1lNX1BBVVNFIHwNCj4gPiA+ID4gTUFDX1NZTV9QQVVTRSB8DQo+ID4gPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIE1BQ18xMDBIRCB8IE1BQ18x
MCB8DQo+ID4gPiA+IE1BQ18xMDAwRkQ7DQo+ID4gPiANCj4gPiA+IEFuZCBTR01JSSB0b28/IChX
aGljaCBzZWVtcyB0byBiZSBhIGdpdmVuIGJlY2F1c2UgZnJvbSB5b3VyIGxpc3QNCj4gPiA+IGlu
DQo+ID4gPiB0aGUNCj4gPiA+IHNlcmllcyBjb3ZlciBtZXNzYWdlLCBTR01JSSBwb3J0cyBhbHNv
IHN1cHBvcnQgUkdNSUkpLg0KPiA+IA0KPiA+IE5vLCBTR01JSSBwb3J0IGRvZXMgbm90IHN1cHBv
cnQgdGhlIFJHTUlJLiBJIGhhdmUgbWVudGlvbmVkIGluIHRoZQ0KPiA+IGNvdmVyIG1lc3NhZ2Ug
dGhhdCBMQU45MzczIGhhcyAyIFJHTUlJIGFuZCAxIFNHTUlJIHBvcnQuIE5vIG90aGVyDQo+ID4g
cGFydA0KPiA+IG51bWJlciBoYXMgU0dNSUkgcG9ydC4NCj4gDQo+IFNvIHdoZW4gdXNpbmcgU0dN
SUksIHRoZXJlJ3Mgbm8gd2F5IGZvciBwYXVzZSBmcmFtZXMgdG8gYmUgc3VwcG9ydGVkPw0KPiBJ
dCBzZWVtcyBhIGJpdCB3ZWlyZCB0aGF0IHRoZSBwYXVzZSBmcmFtZSBjYXBhYmlsaXR5IGlzIGRl
cGVuZGVudCBvbg0KPiB0aGUgaW50ZXJmYWNlIHR5cGUsIGFzIHBhdXNlIGZyYW1lcyBhcmUganVz
dCB0aGUgc2FtZSBhcyBub3JtYWwNCj4gZXRoZXJuZXQgZnJhbWVzLCBleGNlcHQgdGhleSdyZSBn
Z2VuZXJhbGx5IGVuZXJhdGVkIGFuZC9vcg0KPiBpbnRlcnByZXRlZA0KPiBieSB0aGUgTUFDLg0K
DQpBcyBwZXIgdGhlIGNvbW1lbnQsIEkgaW5mZXIgdGhhdCB5b3Ugd2FudCB0byBpbmNsdWRlIHRo
ZSBjYXBhYmlsaXR5IG9mDQpTR01JSSBwb3J0IGFzIHdlbGwuIEFzIG9mIG5vdywgd2UgaW1wbGVt
ZW50ZWQgdGhlIGRzYSBmb3IgUk1JSS9SR01JSS4NCllldCB0byBpbXBsZW1lbnQgYW5kIHRlc3Qg
dGhlIFNHTUlJIHBvcnQuIFNpbmNlIHdlIGhhdmUgbm90IHRlc3RlZCB0aGUNCnBvcnQsIHdlIGhh
dmVuJ3QgaW5jbHVkZWQgaXQuIEFzIHBlciBkYXRhc2hlZXQsIFNHTUlJIHBvcnQgc3VwcG9ydHMg
dGhlDQpmbG93IGNvbnRyb2wuDQoNCj4gDQo+IC0tDQo+IFJNSydzIFBhdGNoIHN5c3RlbTogaHR0
cHM6Ly93d3cuYXJtbGludXgub3JnLnVrL2RldmVsb3Blci9wYXRjaGVzLw0KPiBGVFRQIGlzIGhl
cmUhIDQwTWJwcyBkb3duIDEwTWJwcyB1cC4gRGVjZW50IGNvbm5lY3Rpdml0eSBhdCBsYXN0IQ0K
