Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C8E6F05C4
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 14:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243445AbjD0M26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 08:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243751AbjD0M2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 08:28:53 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB104C37
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 05:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682598527; x=1714134527;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=86XWfNin/P9MsmJHLWkBTDs82hk+LOpAwSp5yxK85xk=;
  b=JDwugUUn1vKi+sVRg9DWCGgDrcFF3c8fd4e1yalWkWWCfBQrQBkmSN0z
   4aVVOe8BV8CQ+akJZ4X2ZE0/9PowGOA3TFqImzD+1sg0r3cFgY59Pnz7l
   1UcSw3HDeJ5oyxwjBC8A4dNtIdQ3y9Ue7Vez/9SdAGjqQDQA3hzXoTqW5
   OmDLTQvCE7WA/De7PDh1yfxkYSt5pgl7FwlNY7IIEJUueA1sBuMFTsFI2
   N/IczpFoKojvWma+5q3gqseTjuHKkKAfd98R3KXvBKHw6iYviYLPUF3zX
   wZJKVMF0QCf8RgvEqU7rpVeC1ctPTQtp+bXtPx2qdcUD1b8G+zoiLQvlH
   w==;
X-IronPort-AV: E=Sophos;i="5.99,230,1677567600"; 
   d="scan'208";a="211447076"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Apr 2023 05:28:47 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 27 Apr 2023 05:28:46 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 27 Apr 2023 05:28:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=boCY3UgrkNXBDXMYha623jEGhBkxfUaVgK16mHk/3GLfWdp9/ozT3+XX3TgolhdTCTW+YdLUiukWw+tlzvYFvV8t8B5MfnmJTi62uta/T8TfYfzrpJ29rW0n8ES9F0OjQB7pRVx9/XJJO9xcre4W+774OYlb5Zd38fdKDyanrw9RJS012USYBK7w/5xW9wXWtegc7cVH13zyiFOtWIojf/DETUeZ++1xPI3BsCxT/zp5AthgU5NOM42aMbZmJqXqPIWcR5H8cQm7lye1c8AOZe8Xfhz9hFk70tsMEljCC44te+qG1vpqxTh9MiXg4l7GmKM26G2cqDX8GRkImn7IQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=86XWfNin/P9MsmJHLWkBTDs82hk+LOpAwSp5yxK85xk=;
 b=diK9+qODhCVS3JJcrZAOtG/YMptZHp/Z/iqu/fKNPf5p+XayjfNGREi4wcnsIfwurvHjdbfvHdBQhpP76UuB9bxdiQ3MRn9GWo8VXTYc4p9Q6AuZFcJM9QUq24AGS2N28q270EKATELWMvMUsRk6EuPhyOEbTrdhsP9Cdg/1GRHaFlzGwOfTcWwLN7ecrz7uW5EIr4sLOG9/g/NFxA0gqYrhOL9Dr6vaGb0n+3lkawswwlTBQsJStEAnDzHzKYSr8y7WOJ7VbnTqgw3nXkOuxnmAnJTBCG8iH4Ofg8TNcXHhkmMUvQUu4yCuVtdl43Xc5hJBH+CzBkv2MgFdCvu24Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=86XWfNin/P9MsmJHLWkBTDs82hk+LOpAwSp5yxK85xk=;
 b=S5PI61ToPV47+IJi8j20YfrRls1tCiuJN6EOp3AcMYUFuq9T5VvXl92q0lk4OOG0or/rrMiMJznSV7EMuJBbQ6zTWJxQxLx9yH7KPGVBBLwm97ORLksF1ILPL/RJvceGcHfYCaoX/JlFD4qRboUG5n6FkMe2Zc5QldklpS0FVsk=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 SJ0PR11MB5770.namprd11.prod.outlook.com (2603:10b6:a03:421::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.32; Thu, 27 Apr 2023 12:28:44 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::1c94:f1ec:9898:11df]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::1c94:f1ec:9898:11df%5]) with mapi id 15.20.6340.021; Thu, 27 Apr 2023
 12:28:43 +0000
From:   <Parthiban.Veerasooran@microchip.com>
To:     <andrew@lunn.ch>, <ramon.nordin.rodriguez@ferroamp.se>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <Jan.Huber@microchip.com>, <Thorsten.Kummermehr@microchip.com>
Subject: Re: [PATCH net-next 2/2] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Thread-Topic: [PATCH net-next 2/2] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Thread-Index: AQHZeDS4+uhGlxLTVEmm8UA24iRXs68+EeyAgAAN9QCAAPeQAA==
Date:   Thu, 27 Apr 2023 12:28:43 +0000
Message-ID: <25927897-ad2f-c933-795d-cc9b80e6a0c6@microchip.com>
References: <20230426114655.93672-1-Parthiban.Veerasooran@microchip.com>
 <20230426114655.93672-3-Parthiban.Veerasooran@microchip.com>
 <ZEmPT1El342j7O8I@debian> <d4649b51-b06e-42f3-88d3-e269c304d0ac@lunn.ch>
In-Reply-To: <d4649b51-b06e-42f3-88d3-e269c304d0ac@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|SJ0PR11MB5770:EE_
x-ms-office365-filtering-correlation-id: ce8c390c-ad4a-4b4a-d73a-08db471af0cd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aMFxGfNQlDsn8Pintty79V+gpvmYhzNwin8itwV5vnuQ2Sf0gYlq72jFdru0gj9JgC3fAaA7QciTSKJ1wdQoTwl/6oBnkiZLDPR+Q8pSvVrVM5XQk6sw+lMlJr5lw3V8mPrrnup+2TGIRjILbav78cot3gEfzuvtHXm91Z8yKrDQNIGeEwKDVQvSr4BVE1iPnZC8n+m8Wt4i7+h9BLMmXJTeZTX23cIcyAz5aw1UI2NudvWOJnMZEnvq3Qf8FzB1rupYUzecHE97PXHFmAzv+evi/sTNCC3I379r7ncb2O3PkVzjcPj2+bASk5IGSABGlMGWVdDPhIBFsJeo4W7tIDU2oPZiZ7hJRysP1tWgLyhQ7rcfGR3Mbt+SrAKJOtRcsGB5eTAA3eUqkuG8g0dQbP+Qvalztn/KKjrvLfTDBGxlD3qVw3mNnk7ilKvHnTr82twfC8Ex4I+BEveaTd9OVpIS9PncniTdxb5aC8RgP22+/L7dtU3v8KoEo/Zs5+iOTNb85C4SVub+sOSV3LwDT5W2R57/HOTbaaUqvvUZPJ0aWoHGqwTLd1g3IIQ9ukiXdAIFXSYcgq0el/MbdcIdDRolP0xPTqPESLgVXknE+a5hiXnNZ+u5UHD68IdAAYStuZqlaGTas+CJXMnUmdH4Inv9Hb39iQ2a3X/Z1ZAsIlg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(376002)(366004)(346002)(451199021)(966005)(107886003)(53546011)(6512007)(26005)(6506007)(38070700005)(2616005)(83380400001)(36756003)(186003)(122000001)(38100700002)(54906003)(66946007)(31696002)(76116006)(86362001)(478600001)(66476007)(66446008)(31686004)(8676002)(8936002)(91956017)(66556008)(64756008)(110136005)(71200400001)(6486002)(5660300002)(2906002)(41300700001)(4326008)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a3IwSFRwdGJTYUIweldDUlhRR2VPaFduNm8wWGRTajZUMFBRV2pDNTJkUWNP?=
 =?utf-8?B?RXNIdnkvZXQvMUlwbi9lTS9kRmZvK2lQRVRWRzJpdDZiMnpuNGlUUVo1Z3BC?=
 =?utf-8?B?Nk5LaUhBT255OTFrMTNTT1EzMWFxVlZCWlViUWVObjZIVlBpQ3RucENqNUxi?=
 =?utf-8?B?UVVzbzNvSitYWGx6cGRhNjdUKzd1QVV5MktmeW42VlZGbjVPQXluNEtWWEVx?=
 =?utf-8?B?eXM2MW5Mc1QxZUNFb3ZYU3lLNllFV3FPTGNnNktMWU5Ea0h0VnFqN1NzNVNp?=
 =?utf-8?B?REJnekNDcituMllJdkw1VGpsZW1NenBVK0g4c3BwWVEyQjB5THFDNThGRGZG?=
 =?utf-8?B?dU0yS2dNVmt0WHFDMEllS296b25LVnhSQUlCdHFVdW0yL2NvdCtmL2hUdDhW?=
 =?utf-8?B?czZ6WEF1RTlPMVBFamlFV3lvditGL1FGR3UxL1U3ZzhUYlJZWkI4WHBzbDlY?=
 =?utf-8?B?UWdSTmpEY1VzeFV4YjB6cFFrVHVxWThUZGIrWURhWUsxbDR2VjByVENKVmNr?=
 =?utf-8?B?TXB5UTRzOXF0Y2F2WlVobWhTaDdHRXBIayt5NlR2MnpTZ2U3ZGc1bUU4alJW?=
 =?utf-8?B?VWl4Vi9MYUNCeTlCQjlFR00veG0zZDhUd1I0SVh4azdqMTlwZjJEa0Rnc1Zy?=
 =?utf-8?B?ZnAweG1UMmlrSVRPOVpjNzV0aXl1N2l1Q3JDa0ZWaDVMMHhxVGlsY0pvUEdP?=
 =?utf-8?B?ekNnNFJmR1JaekN2bWhHR2YxeUd5N09GcVJNZ2YzMC9OMWxBMjFIRGQwS0hq?=
 =?utf-8?B?UjFzVnpwNUdjbE5MOURDTElwSWEwNHZyOHp3RWJrTmR0UVMvR3ZLVFBZdDNY?=
 =?utf-8?B?Ni84WDR2dGE1YkdnTUxEOG84c0JxaVRTdWVRRi9ZVFJ0c3FTcDhpM0dnUXFy?=
 =?utf-8?B?WkRLbEVFNDFEMFZsdHpzQWFCS1MvMmQ1aVR2cUNkKzNpa3o4K2JNaC9naS95?=
 =?utf-8?B?OW00UVJJVG10TlVmckhDdkdXbFlxalVkbzU1UEtBUFlFRzljRlVldzBPL001?=
 =?utf-8?B?RTlGN29tTzBkOG16Q1JzWndDeUZZbUM2OFUzVW90QjU1ckk2U1AwVWVRR0NI?=
 =?utf-8?B?OXQ1Z1NDbkNNc0JsU2Y3YmRSQmlzREh3Ny9Iek44b29sL3Fza08wNUhnVWJU?=
 =?utf-8?B?WjdXZTBTeExWQjBQeGdLdk1mY2hubm9hL09LVU5JVUp0OGVYQUEyTkU5ajRs?=
 =?utf-8?B?T3FaZHlPVHMvUFdTbDh1MUVsNm85ZW50RHVrYUN2TmR4THpIM3NWR1h5b2c4?=
 =?utf-8?B?WjVVYlRvRTZOWGxVazVjNEpHZklQR1IvRW9XUnpGWDhURW1WSUgxL2RhbUJn?=
 =?utf-8?B?NVVtN0NOQ1p1dmY1QlE0T1dPSDN6TFpXNTVKNjE0SVZOdHlRNUhscWUrNkEw?=
 =?utf-8?B?Y1RzVkcyZ1BOaXovcjhqVG9obUVOWVhjT3kvbFhxR3JwZDRsZDJsSWdJSnUz?=
 =?utf-8?B?TWVlc0MxSUVtU2VCaFgvRDRJRVM1NEdaNXpJcjVFb2puMi9BbG5BU1JNTGI1?=
 =?utf-8?B?bnZyVitiU0dlRFRyWU1ZOWRiYTJvSEthQVlxWlNTRWIyMmYveTdkZTQ2ZDNa?=
 =?utf-8?B?eE9BT1JPOURXclBKYnl6YnBTQituMXhoTTh1a3FkcTNseWRybUtoQmVJcHcx?=
 =?utf-8?B?VEFUZjRiR0V5blZSUzdZSEZDUXBhZys2SS9zNUlQNHpBTVVHeFhCQVk1UVZu?=
 =?utf-8?B?VDRyUFhxakY0NzVucitNV1A1cy9scFlWT0hwRCtZMUVQOTJkWG5mSmd4VlF6?=
 =?utf-8?B?WEFTRjkxQVlWQmhxUXdWVi9xNGNHK2QvTFhwN2lxZjhHVHo2V3V2alFnVjJW?=
 =?utf-8?B?WW5yQUZ3R3FmM0dFa3dYaDVXdlVXbklreUtrYTlHdmhUTXNMdzlTN25zelhM?=
 =?utf-8?B?UUdGZHp0YW5GYmgyNmd0amw4OXlySCtITWp1RjlhMndWNy94ZEdGZUdGUVEz?=
 =?utf-8?B?TXdiUGRua2M3bHdCcG9kRjUwb0RYaW1jN2JCWldMaFRza3ZWZElpamdTYkJa?=
 =?utf-8?B?K1JZeTE0MTNPSjFOaDRpVGk4d21ONWcrVFFvSjhPWmUvcVBnVkhrM0FUUFRD?=
 =?utf-8?B?Zk93RU13dHA3N21qSFZXMUZPZy93YzJJL1RsczRyZkFMS0JoSVQ0OWsvWTEr?=
 =?utf-8?B?TEo1bGN3N3dVb2ptaHdLZFRCMVIxY3VFNzFJb1FSMjJDMHd3Y2NqM1NIelhX?=
 =?utf-8?B?Tnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <40967C4F8528C24EB614E26BD4781418@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce8c390c-ad4a-4b4a-d73a-08db471af0cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2023 12:28:43.7546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nSck80o1GXCce5igZshMRLTLErOiPcoWMjWRbsxc+sOhRYtpPBFCBGDoK7wQ/sgw+vPdM0ABRNXl5zDJ/Zt3sweTnla4m2y+BO9eRig8LSiC8MlGpViw2VJOEYvVsRkh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5770
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpUaGFua3MgZm9yIHJldmlld2luZyB0aGUgcGF0Y2hlcy4gUGxlYXNlIHNl
ZSBteSBjb21tZW50cyBiZWxvdy4NCg0KQmVzdCBSZWdhcmRzLA0KUGFydGhpYmFuIFYNCk9uIDI3
LzA0LzIzIDM6MTMgYW0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8g
bm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93IHRoZSBj
b250ZW50IGlzIHNhZmUNCj4gDQo+Pj4gKy8qIGluZGlyZWN0IHJlYWQgcHNldWRvY29kZSBmcm9t
IEFOMTc2MA0KPj4+ICsgKiB3cml0ZV9yZWdpc3RlcigweDQsIDB4MDBEOCwgYWRkcikNCj4+PiAr
ICogd3JpdGVfcmVnaXN0ZXIoMHg0LCAweDAwREEsIDB4MikNCj4+PiArICogcmV0dXJuIChpbnQ4
KShyZWFkX3JlZ2lzdGVyKDB4NCwgMHgwMEQ5KSkNCj4+PiArICovDQo+Pg0KPj4gSSBzdWdnZXN0
IHRoaXMgY29tbWVudCBibG9jayBpcyBzbGlnaHRseSBjaGFuZ2VkIHRvDQo+Pg0KPj4gLyogUHVs
bGVkIGZyb20gQU4xNzYwIGRlc2NyaWJpbmcgJ2luZGlyZWN0IHJlYWQnDQo+PiAgICoNCj4+ICAg
KiB3cml0ZV9yZWdpc3RlcigweDQsIDB4MDBEOCwgYWRkcikNCj4+ICAgKiB3cml0ZV9yZWdpc3Rl
cigweDQsIDB4MDBEQSwgMHgyKQ0KPj4gICAqIHJldHVybiAoaW50OCkocmVhZF9yZWdpc3Rlcigw
eDQsIDB4MDBEOSkpDQo+PiAgICoNCj4+ICAgKiAweDQgcmVmZXJzIHRvIG1lbW9yeSBtYXAgc2Vs
ZWN0b3IgNCwgd2hpY2ggbWFwcyB0byBNRElPX01NRF9WRU5EMg0KPj4gICAqLw0KPj4NCj4+PiAr
c3RhdGljIGludCBsYW44NjV4X3JldmIwX2luZGlyZWN0X3JlYWQoc3RydWN0IHBoeV9kZXZpY2Ug
KnBoeWRldiwgdTE2IGFkZHIpDQo+Pj4gK3sNCj4+PiArICAgaW50IHJldDsNCj4+PiArDQo+Pj4g
KyAgIHJldCA9IHBoeV93cml0ZV9tbWQocGh5ZGV2LCBNRElPX01NRF9WRU5EMiwgMHhEOCwgYWRk
cik7DQo+Pj4gKyAgIGlmIChyZXQpDQo+Pj4gKyAgICAgICAgICAgcmV0dXJuIHJldDsNCj4+PiAr
DQo+Pj4gKyAgIHJldCA9IHBoeV93cml0ZV9tbWQocGh5ZGV2LCBNRElPX01NRF9WRU5EMiwgMHhE
QSwgMHgwMDAyKTsNCj4+PiArICAgaWYgKHJldCkNCj4+PiArICAgICAgICAgICByZXR1cm4gcmV0
Ow0KPj4+ICsNCj4+PiArICAgcmV0ID0gcGh5X3JlYWRfbW1kKHBoeWRldiwgTURJT19NTURfVkVO
RDIsIDB4RDkpOw0KPj4+ICsgICBpZiAocmV0IDwgMCkNCj4+PiArICAgICAgICAgICByZXR1cm4g
cmV0Ow0KPj4+ICsNCj4+PiArICAgcmV0dXJuIHJldDsNCj4+PiArfQ0KPiANCj4gSXQgaXMgdW5j
bGVhciB0byBtZSBob3cgMHg0IG1hcHMgdG8gTURJT19NTURfVkVORDIsIHdoaWNoIGlzIDMxLg0K
PiANCj4gV2h5IG5vdCBqdXN0IGRlc2NyaWJlIGl0IGluIHRlcm1zIG9mIE1NRCByZWFkL3dyaXRl
Pw0KVGhpcyBpcyBhbiBpbnRlcm5hbCAxMEJBU0UtVDFTIFBIWSBvZiBMQU44NjV4IE1BQy1QSFku
IExBTjg2NXggaGFzIFNQSSANCnRvIGludGVyZmFjZSB3aXRoIEhvc3QuIFRoZSBpbnRlZ3JhdGVk
IFBIWSB2ZW5kb3Igc3BlY2lmaWMgcmVnaXN0ZXJzIGFyZSANCmxvY2F0ZWQgd2l0aGluIE1lbW9y
eSBNYXAgU2VsZWN0b3IgNCAoTU1TNCkuIFRoaXMgTU1TNCB3aWxsIGJlIHVzZWQgYXMgYSANCmJh
c2UgaWYgdGhlIE1BQyBkcml2ZXIgd2FudHMgdG8gYWNjZXNzIHRoZSBpbnRlZ3JhdGVkIFBIWSB2
ZW5kb3IgDQpzcGVjaWZpYyByZWdpc3RlcnMgZGlyZWN0bHkgdGhyb3VnaCBTUEkgd2l0aG91dCBQ
SFkgZHJpdmVyLg0KDQpJcyBpdCBjbGVhcj8gb3IgZG8geW91IG5lZWQgbW9yZSBpbmZvcm1hdGlv
bj8NCj4gDQo+PiBUaGUgZnVuYyBpdHNlbGYgbWlnaHQgZ2V0IGEgYml0IG1vcmUgcmVhZGFibGUg
YnkgbmFtaW5nIHRoZSBtYWdpYyByZWdzDQo+PiBhbmQgdmFsdWUsIGJlbG93IGlzIGEgc3VnZ2Vz
dGlvbi4NCj4+DQo+PiBzdGF0aWMgaW50IGxhbjg2NXhfcmV2YjBfaW5kaXJlY3RfcmVhZChzdHJ1
Y3QgcGh5X2RldmljZSAqcGh5ZGV2LCB1MTYgYWRkcikNCj4+IHsNCj4+ICAgICAgICBpbnQgcmV0
Ow0KPj4gICAgICAgIHN0YXRpYyBjb25zdCB1MTYgZml4dXBfdzBfcmVnID0gMHgwMEQ4Ow0KPj4g
ICAgICAgIHN0YXRpYyBjb25zdCB1MTYgZml4dXBfcjBfcmVnID0gMHgwMEQ5Ow0KPj4gICAgICAg
IHN0YXRpYyBjb25zdCB1MTYgZml4dXBfdzFfdmFsID0gMHgwMDAyOw0KPj4gICAgICAgIHN0YXRp
YyBjb25zdCB1MTYgZml4dXBfdzFfcmVnID0gMHgwMERBOw0KPiANCj4gI2RlZmluZXMgd291bGQg
YmUgbm9ybWFsLCBub3QgdmFyaWFibGVzLg0KPiANCj4gQW5kIGkgZ3Vlc3MgMHgwMDAyIGlzIGFj
dHVhbGx5IEJJVCgxKS4gQW5kIGl0IHByb2JhYmx5IG1lYW5zIHNvbWV0aGluZw0KPiBsaWtlIFNU
QVJUPyAweEQ4IGlzIHNvbWUgc29ydCBvZiBhZGRyZXNzIHJlZ2lzdGVyLCBzbyBpIHdvdWxkIHB1
dCBBRERSDQo+IGluIHRoZSBuYW1lLiAweEQ5IGFwcGVhcnMgdG8gYmUgYSBjb250cm9sIHJlZ2lz
dGVyLCBzbyBDVFJMLiBBbmQgMHhEQQ0KPiBpcyBhIGRhdGEgcmVnaXN0ZXI/IFNvIHRoZXNlIGNv
dWxkIGJlIGdpdmUgbW9yZSBkZXNjcmlwdGl2ZSBuYW1lcywNCj4ganVzdCBieSBteSByZXZlcnNl
IGVuZ2luZWVyaW5nIGl0LiBXaXRoIHRoZSBhY3R1YWwgZGF0YSBzaGVldCwgaSdtDQo+IGV4cGVj
dCBzb21lYm9keSBjb3VsZCBkbyBiZXR0ZXIuDQo+IA0KPj4+ICtzdGF0aWMgaW50IGxhbjg2NXhf
cmV2YjBfY29uZmlnX2luaXQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4+PiArew0KPj4+
ICsgICBpbnQgYWRkcjsNCj4+PiArICAgaW50IHZhbHVlOw0KPj4+ICsgICBpbnQgcmV0Ow0KPj4+
ICsNCj4+PiArICAgLyogQXMgcGVyIEFOMTc2MCwgdGhlIGJlbG93IGNvbmZpZ3VyYXRpb24gYXBw
bGllcyBvbmx5IHRvIHRoZSBMQU44NjUwLzENCj4+PiArICAgICogaGFyZHdhcmUgcmV2aXNpb24g
UmV2LkIwLg0KPj4+ICsgICAgKi8NCj4+DQo+PiBJIHRoaW5rIHRoaXMgaXMgaW1wbGllZCBieSBo
YXZpbmcgaXQgdGhlIGRldmljZSBzcGVjaWZpYyBpbml0IGZ1bmMsIHlvdQ0KPj4gY2FuIHByb2Jh
Ymx5IGRyb3AgdGhpcyBjb21tZW50Lg0KPiANCj4gQSByZWZlcmVuY2UgdG8gQU4xNzYwIHNvbWV3
aGVyZSBpbiB0aGUgZHJpdmVyIHdvdWxkIGJlIGdvb2QsIHRvIGhlbHANCkRvIHlvdSBtZWFuIHRv
IGdpdmUgYSB3ZWIgbGluayB0byB0aGF0IGRvY3VtZW50IGxpa2UgYmVsb3c/DQoNCmh0dHBzOi8v
d3cxLm1pY3JvY2hpcC5jb20vZG93bmxvYWRzL2FlbURvY3VtZW50cy9kb2N1bWVudHMvQUlTL1By
b2R1Y3REb2N1bWVudHMvU3VwcG9ydGluZ0NvbGxhdGVyYWwvQU4tTEFOODY1MC0xLUNvbmZpZ3Vy
YXRpb24tNjAwMDE3NjAucGRmDQo+IHBlb3BsZSB1bmRlcnN0YW5kIHdoeSB0aGlzIG1hZ2ljIGlz
IG5lZWRlZC4gRG9lcyBBTjE3NjAgYWN0dWFsbHkNCj4gZXhwbGFpbiB0aGUgbWFnaWMsIG9yIGp1
c3Qgc2F5IHlvdSBuZWVkIHRvIGRvIHRoaXMgdG8gbWFrZSBpdCB3b3JrLCBUcnVzdCBVcyh0bSku
DQpVbmZvcnR1bmF0ZWx5IGl0IGRvZXNuJ3QgZXhwbGFpbiB3aGF0IHRob3NlIGluaXQgc2V0dGlu
Z3MgYnV0IHdlIG5lZWQgdG8gDQpkbyB0aGlzIHRvIHdvcmsgYXMgZXhwZWN0ZWQuIEFzIHlvdSBz
YWlkLCBUcnVzdCBVcy4NCj4gDQo+ICAgICAgICAgICAgICBBbmRyZXcNCg0K
