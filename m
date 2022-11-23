Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4A3635339
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 09:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236702AbiKWIuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 03:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236697AbiKWIuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 03:50:08 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1331E9164;
        Wed, 23 Nov 2022 00:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669193397; x=1700729397;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=v7xH58T7CdbPwLUNNbp9MegWkPbX2tVlasD2gJZQik4=;
  b=BTSWHBGuvGJ7ZKNFaymnFHv71vUiGfC+3oTelTraAMYu43qjipWnpvPI
   FEQyx0nnAK59skbNgrLWetolrKcb3R4+Gc26EI18j0kqkL1YG6o8Ou/wZ
   CJ90kIjZxcOiUltsTjikWq3wOMBHJULxVDFFGn02d7zTnBCtPQoFddfIn
   L6yfeuCvoAfY9L5wo+NgUXNAMe8ljFfaL4vokQ5uRD5bzP9mtySBgoAh0
   us7S4Ri82G9D4iCM35VQPlTfBPTN6R7e5/qItlfs5zu7hwBVDaR3mRHWQ
   Uha6Z06AYXILV9oOXyOvz9k3zdzCkriaFJbJ0cClF7k23Y2La7yDXQexF
   w==;
X-IronPort-AV: E=Sophos;i="5.96,186,1665471600"; 
   d="scan'208";a="124736842"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2022 01:49:56 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 23 Nov 2022 01:49:52 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Wed, 23 Nov 2022 01:49:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGGDZuX9F5oEcBbKQrI0kkBJzQfGSLXLxTglNQsJEFUlJrxQriBDlN+gkGzGPTkkGREfT4v4Ae5SrmrlZzi9clpusc4ZwcTWwsEdP+3LfmCTFA7U4xsdQ9rvnkmAbCVAu8Pm5ERS8oavSARyamw++j2X5O+B6UkfvTJwB4A0QawmYXrRTSE9sDSMX1vfpNJE9f6Rkv7kWOUBTtDZwz0i704TZPgvF5tGZyPrRoXaE7drCdjlkQ103sA8y8BENBNmFtHrXRxmOnQEDQiWvzf6mxewZdXr2LYXOjUcxbvow6+AwmyP+dhYwP8Tbt65ODElsSJJWaOkUSWT71zJsDOdoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7xH58T7CdbPwLUNNbp9MegWkPbX2tVlasD2gJZQik4=;
 b=EUvQWjFQYeM+J9QjTJv6dtiOaMn4mYkiWtZtM03B/QxS1p+1xPLK18VRbwgi1Iu4ozNtmo/c3yY3VBotMAFsgJVozdTh17hluuhBhh59MNEojq+jQDW73ZbgFZr6F09V4dfSxWu2tT3u2++1wuuThVG0hLzjJ6rS8NplS9ZjRwZVLGsSSKZpNfBZI1GWSPYjHOlJdwyi1xMvYCDGEHeM+RvyDqHVX3OROuaqqxhEH2Ll24cwd7YqUSlmjbnCdlFqhQMWDOKb5pfQAThsS6yXB193vl57yoZPj8I8kcUK00V2Z7GjgwP5xbZw1on3t1ExPQdWnHsLHWbmvcOG8nyocg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7xH58T7CdbPwLUNNbp9MegWkPbX2tVlasD2gJZQik4=;
 b=TM0TcUiZt8kVvli4i3p5mUPA1T3cZNxE2dWn17IAQ33RNZjer88Y6TS0uxVf4kGnPr6eEBLOjyIkQLO+4mV8wV8D2mQASnOuZNACcw2BQ+iurrHhKVkq0ZDCw4d2SF2RtVNvWxQHRnQJouq7hVqOpEQUGyWOAPG8l+xQQmuqtsE=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 PH0PR11MB5160.namprd11.prod.outlook.com (2603:10b6:510:3e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.17; Wed, 23 Nov 2022 08:49:49 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 08:49:49 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC Patch net-next v2 7/8] net: dsa: microchip: add the
 transmission tstamp logic
Thread-Topic: [RFC Patch net-next v2 7/8] net: dsa: microchip: add the
 transmission tstamp logic
Thread-Index: AQHY/cADTW60bSzqDEmwpBF1J/V0xa5J+/2AgAI5mAA=
Date:   Wed, 23 Nov 2022 08:49:49 +0000
Message-ID: <fc1ee2c782ed22fd882f013637f42ca00fdb0d34.camel@microchip.com>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
         <20221121154150.9573-8-arun.ramadoss@microchip.com>
         <20221121225109.5j5g5yubqgzukloh@skbuf>
In-Reply-To: <20221121225109.5j5g5yubqgzukloh@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|PH0PR11MB5160:EE_
x-ms-office365-filtering-correlation-id: b11d2471-ae84-4f76-84c3-08dacd2fae12
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l7myIqt5CFpvfX6oEBFmU0jvRSLx8zaVeVp5rQN9eZF4A09eO/NVH3tYoRclkPTgJ0FuzVMiw7DOkS3UiOUP3N0Oh8tWdTPq8vvYr0GGIlSnstjmWWf8AFFb8HJ9UPI2yGUZisGGtE7fATAQbS6ws1tqJi7FoCTT+jJ7Umodupo1xd335N8yKnrHoqHgMK6/LD8vz4lXAQ/Frpx/7nuVT01jFBc/rI51w7f7/H1d1/6nNXuI90svVtC6363O58wL1Hi+dZmhnWn6j0TP2hoTAWQAXRDQkOaX0ZP7wHeJCMPz7d8haxofVXY2ibQhFJlBRFH5WC0wrGQbqatYsU1UNyM5yjr5ABFhcKEahH8WJfEQc+wD/I/R0JsvZZ4ZeumaYBl9gYVDnsBkYI3pdIAbOBiptzurnU8eaWdmSX00cOcNPRNmYv35EGHavgEZPfs135Dw3m9o7EPLX+Bi/cLNcPm7Dlwvo/q3inT0uXX+NprMwih1LoWP21CK8KNYy3vWo7aiZtlGKv8zDHAtcEfKqd5K09qXxch/6Ps285hZVjdzwS0PxT2yEuRWCmOtlr4p7yxK7YgMQeT/qkgAtgeUHO5GxW5MXwjDk2LEsd1H7iBZKvKNSbBkomqPaim+OQzuebyYUElHCryBcidXXriZedug6TeAwyENpQDllTx2/ghSNf03EiP8uvDCMUgxtp+xgxYDlfzXFuJ/Q/iWPDrXmvGNZftqptxBZBRp/Qps4Do=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(366004)(396003)(39860400002)(376002)(451199015)(6916009)(54906003)(7416002)(38070700005)(5660300002)(316002)(8936002)(2616005)(76116006)(91956017)(86362001)(186003)(64756008)(66476007)(66556008)(66446008)(8676002)(66946007)(478600001)(4326008)(6486002)(26005)(6512007)(71200400001)(6506007)(41300700001)(38100700002)(83380400001)(122000001)(4001150100001)(2906002)(36756003)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Nk94UTF6U2x1MmNaK3FoODVxdTR6SDQ5WlpaWE5Eaml1aElHRHNlUWtaU2R2?=
 =?utf-8?B?MjNtbC80eVdvNHF1alQ5TWpwWTNaSlJ4OUtDTkQwZHcyUVE5VC8wazVvcmN3?=
 =?utf-8?B?THhGTEovT1ZnRXltdHY0YzliMVFGUGJ0QnMyY1h1OFB3aHd4UHNtMlNqS3Bu?=
 =?utf-8?B?Um96dFdBSmlvT2JncXo1bFJWaU9hM0F3WHVUcDJNYkNwYlNycGcxYWdNSVIz?=
 =?utf-8?B?K3JPejBlM0pScFpPZithR091elBVRnZQZEYycm5SM2JGcFRrcTd0S3dEbldr?=
 =?utf-8?B?UWhBcmVtaGc5ZmVQR1pXeGR5VS94cm9HL08xQWhEZTdJc3NGMm10UFBjaGVW?=
 =?utf-8?B?cCt3bnFzMHdDTFF0K1R6SlhjRG52VjdZWDAwQlRJUnRIT05HNktRYk0wVWRY?=
 =?utf-8?B?WUtISnJFY211ZjhGeldWM1BFSU5iaGw1OUlsVEhjMVltVzN4UkpRMnV5SXgv?=
 =?utf-8?B?bGs3aXdCbjkrV1o1Z1lUbEZiWTk5NDQzb0hSVGUwOXdkb3JmandydnBUaEUy?=
 =?utf-8?B?Z3NmbVovUGhjSEhTMTBvNTMzdkd6anEyOHhRRjZrbTR3QWFMaDFEYmVjaVoy?=
 =?utf-8?B?YTI4Yk9kYS9IU3BIVzVQdmFDK25KNGZmVUFrMS9QdGMvSGJhM3p4dEp4ODda?=
 =?utf-8?B?YjVjMkUxMXRteXBjSG9KWjF1TUh6R0p3OFdXb2FLdXhLR2F6Q0tSVExScjk4?=
 =?utf-8?B?SkwwQ3FuVVE2Zld5S21LUEc2TDBISzkvNEh2d2lMZm5CZ0lsSTE5OThweG4z?=
 =?utf-8?B?bGtZcW0wNXUwcUNFaXFTRSt5U2dTVkVHanlUQ1pNRFhTRnJQV1hSaktFeHAr?=
 =?utf-8?B?OTUxRENTYktFVG1RaWxVM3I5aTQwOURrQUVaMm1pUTkvZjVhMjVybHBLcHJm?=
 =?utf-8?B?U2J4cXRnVVlGY1FNYTVpd211VmZUN2ZGN09zajRPMGppUEY4KzcvRkJHaVFK?=
 =?utf-8?B?bFpWbU8xaUdaN09ncWFwTjZobzhnL1o5enlsRTc3KzdYRXNLTUVDREdyRXJQ?=
 =?utf-8?B?cEdwbVV5bUhwbjdOZXNWdjkrTmlEbTI0aTlLd212VHkyRkJ1cFpnbjJicm1V?=
 =?utf-8?B?aTFDQ3JzSEIvUHMyNmE1WVlZSlIrcTZrNlEvdXJMeU5QRysybzRZQW5JSVFV?=
 =?utf-8?B?OVM3aFo1a3Q2T1NYRHNQOUNKMUFyY1l4akZBVlhERnQzb2o4YzRROXlraDJF?=
 =?utf-8?B?Vkh4akZvOXp3Rnp4SmlVWUlwVFpDaFJpcDdiRWthMEN3a1VQSkVSSldkVW5W?=
 =?utf-8?B?bzRFV1M3V092c2FsbVlCaEFMdXR1VThpNE1NL0w1amRDRDhNd0RjbVNVck51?=
 =?utf-8?B?endwR3pEZlNicDg2N0Y3UXpHczBzK2piN2RLWEpmZ2xaTXIvd0c1UnBzUFcz?=
 =?utf-8?B?VWlVeGM5R2J1VkNEVWpOVmhlcUlURFhnS2dXYUhyQkpUNXNObDFnc1FJa3J0?=
 =?utf-8?B?YnZsV0lLaEErUGROYnFWZ0tqNG0zMlBDb1l4K0c4VWtFa1dCNkd4TWVGVXo3?=
 =?utf-8?B?bllZTC91MEJuN2lSN3dlWVpxSTZ0MFBKK3RtWFRTVVZaNUxsMTFYU1M5SEgz?=
 =?utf-8?B?YTFqYlJnNXR2c0xKOG1taCtrcTloSzg5Wko3bmZ5NDRwVy9jSmJ0ek5Hd2I3?=
 =?utf-8?B?SDgvcjJkelhVMXcxa0NtTVI3UjNzbE1UWHM2NENZdGR0MHMxdnh5UWJzaVBF?=
 =?utf-8?B?bW5RZTV6V3JKcCtvek42QWU0NVBicUJYcUh1OEYraDZLYVpiQmJLMnZRU1dw?=
 =?utf-8?B?RW50RjdmUlRDYjdpa3J1RkxKaXkvMmxWSWljNFV0Q1Q5Q2xKenpyRTFRQVIw?=
 =?utf-8?B?MzR6T0hMK3ZXRTdmTVBHTStaa0JGSTQ0Y2tmOTF5VXczcGlTKy9PYXZLaHRR?=
 =?utf-8?B?SVdmQkdxY3gwZ2NRWVE4Ykh1byt0eVlocWR5N2haamZrcng3YmVTandRdXkr?=
 =?utf-8?B?S0NsOXdOWUhPcjRZdkdxNjFieVp5VEEyQU45TklzeTJVZGpqcE9QaWdtRXQy?=
 =?utf-8?B?YThjS2MzMDgvdnVNdVpRRytEMVFWeWp1V2wzeDZvSFZxMUtvZ3QvREREYzhl?=
 =?utf-8?B?RjByL1g0eG9PcUtMTDU0dU82NmViWGVNSS9iT0pWYmJybkxFRlI3WGhkZG1T?=
 =?utf-8?B?UEw4emsxaFcvaFFMUFp5Yzd1RC8vWTNvZlFiczRXcjRkK2lHbG1HNVZ2Ym40?=
 =?utf-8?Q?baFvSdmm47osWj713iYBb+c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F11575F156E5F74589D6043710A123AD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b11d2471-ae84-4f76-84c3-08dacd2fae12
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 08:49:49.3640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AKgrhAnAc7zp+sQ+ydhRzGLC6BXn0mRu1zcsWfGzY19MvRNtgQwlLCPXYlzm32lD5KpV+3pWFOTHNdpi3iJkPUI7COX3V5PY+EFhmv50Ui4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5160
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQpUaGFua3MgZm9yIHRoZSBkZXRhaWxlZCBleHBsYW5hdGlvbiBvZiByYWNl
IGNvbmRpdGlvbi4NCg0KT24gVHVlLCAyMDIyLTExLTIyIGF0IDAwOjUxICswMjAwLCBWbGFkaW1p
ciBPbHRlYW4gd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0K
PiANCj4gSGkgQXJ1biwNCj4gDQo+IE9uIE1vbiwgTm92IDIxLCAyMDIyIGF0IDA5OjExOjQ5UE0g
KzA1MzAsIEFydW4gUmFtYWRvc3Mgd3JvdGU6DQo+ID4gVGhpcyBwYXRjaCBhZGRzIHRoZSByb3V0
aW5lcyBmb3IgdHJhbnNtaXNzaW9uIG9mIHB0cCBwYWNrZXRzLiBXaGVuDQo+ID4gdGhlDQo+ID4g
cHRwIHBhY2tldHMoc3luYywgcGRlbGF5X3JlcSwgcGRlbGF5X3JzcCkgdG8gYmUgdHJhbnNtaXR0
ZWQsIHRoZQ0KPiA+IHNrYiBpcw0KPiA+IGNvcGllZCB0byBnbG9iYWwgc2tiIHRocm91Z2ggcG9y
dF90eHRzdGFtcCBpb2N0bC4NCj4gPiBBZnRlciB0aGUgcGFja2V0IGlzIHRyYW5zbWl0dGVkLCBJ
U1IgaXMgdHJpZ2dlcmVkLiBUaGUgdGltZSBhdA0KPiA+IHdoaWNoDQo+ID4gcGFja2V0IHRyYW5z
bWl0dGVkIGlzIHJlY29yZGVkIHRvIHNlcGFyYXRlIHJlZ2lzdGVyIGF2YWlsYWJsZSBmb3INCj4g
PiBlYWNoDQo+ID4gbWVzc2FnZS4gVGhpcyB2YWx1ZSBpcyByZWNvbnN0cnVjdGVkIHRvIGFic29s
dXRlIHRpbWUgYW5kIHBvc3RlZCB0bw0KPiA+IHRoZQ0KPiA+IHVzZXIgYXBwbGljYXRpb24gdGhy
b3VnaCBza2IgY29tcGxldGUuDQo+IA0KPiAic2tiIGNvbXBsZXRlIiBpcyBub3QgYSB0aGluZy4g
InNvY2tldCBlcnJvciBxdWV1ZSIgaXMuDQoNCkkgd2lsbCB1cGRhdGUgYXMgc29ja2V0IGVycm9y
IHF1ZXVlLg0KDQo+IA0KPiA+IA0KPiA+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNh
L21pY3JvY2hpcC9rc3o5NDc3X3B0cC5jDQo+IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9r
c3o5NDc3X3B0cC5jDQo+IGluZGV4IGM2NDY2ODljYjcxZS4uYmMzZjAyODM4NTlhIDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzdfcHRwLmMNCj4gKysrIGIv
ZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3X3B0cC5jDQo+IEBAIC0xMTA2LDYgKzEx
MDYsMTEgQEAgaXJxcmV0dXJuX3Qga3N6OTQ3N19wdHBfcG9ydF9pbnRlcnJ1cHQoc3RydWN0DQo+
IGtzel9kZXZpY2UgKmRldiwgaW50IHBvcnQpDQo+ICAgICAgICAgaWYgKHJldCkNCj4gICAgICAg
ICAgICAgICAgIHJldHVybiBJUlFfTk9ORTsNCj4gDQo+ICsgICAgICAgLyogQ2xlYXIgaW50ZXJy
dXB0KHMpIChXMUMpICovDQo+ICsgICAgICAgcmV0ID0ga3N6X3dyaXRlMTYoZGV2LCBhZGRyLCBk
YXRhKTsNCj4gKyAgICAgICBpZiAocmV0KQ0KPiArICAgICAgICAgICAgICAgcmV0dXJuIElSUV9O
T05FOw0KPiArDQo+ICAgICAgICAgaWYgKGRhdGEgJiBQVFBfUE9SVF9YREVMQVlfUkVRX0lOVCkg
ew0KPiAgICAgICAgICAgICAgICAgLyogVGltZXN0YW1wIGZvciBQZGVsYXlfUmVxIC8gRGVsYXlf
UmVxICovDQo+ICAgICAgICAgICAgICAgICBzdHJ1Y3Qga3N6X2RldmljZV9wdHBfc2hhcmVkICpw
dHBfc2hhcmVkID0gJmRldi0NCj4gPnB0cF9zaGFyZWQ7DQo+IEBAIC0xMTI4LDExICsxMTMzLDYg
QEAgaXJxcmV0dXJuX3Qga3N6OTQ3N19wdHBfcG9ydF9pbnRlcnJ1cHQoc3RydWN0DQo+IGtzel9k
ZXZpY2UgKmRldiwgaW50IHBvcnQpDQo+ICAgICAgICAgICAgICAgICBjb21wbGV0ZSgmcHJ0LT50
c3RhbXBfY29tcGxldGlvbik7DQo+ICAgICAgICAgfQ0KPiANCj4gLSAgICAgICAvKiBDbGVhciBp
bnRlcnJ1cHQocykgKFcxQykgKi8NCj4gLSAgICAgICByZXQgPSBrc3pfd3JpdGUxNihkZXYsIGFk
ZHIsIGRhdGEpOw0KPiAtICAgICAgIGlmIChyZXQpDQo+IC0gICAgICAgICAgICAgICByZXR1cm4g
SVJRX05PTkU7DQo+IC0NCj4gICAgICAgICByZXR1cm4gSVJRX0hBTkRMRUQ7DQo+ICB9DQo+IA0K
PiANCj4gQWJvdXQgdGhlIG9ubHkgZGlmZmVyZW5jZSBzZWVtcyB0byBiZSB0aGF0IEFDSy1pbmcg
dGhlIGludGVycnVwdCBpcw0KPiBkb25lDQo+IGF0IHRoZSBlbmQgb2Yga3N6X3B0cF9pcnFfdGhy
ZWFkX2ZuKCksIHdoaWxlIGNvbXBsZXRlKCZwb3J0LQ0KPiA+dHN0YW1wX21zZ19jb21wKQ0KPiBp
cyBjYWxsZWQgZnJvbSBrc3pfcHRwX21zZ190aHJlYWRfZm4oKSAtIHdoaWNoIGlzIGNhbGxlZCBi
eQ0KPiBoYW5kbGVfbmVzdGVkX2lycSgpDQo+IElJVUMuDQoNCkkgd2lsbCBjbGVhciB0aGUgaW50
ZXJydXB0cyBiZWZvcmUgY2FsbGluZyB0aGUgaGFuZGxlX25lc3RlZF9pcnEoKS4NCg0KPiANCj4g
PiANCj4gPiArLyoNCg==
