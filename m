Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB644C90FF
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 17:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236084AbiCARAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 12:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbiCARAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 12:00:22 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B7AC77;
        Tue,  1 Mar 2022 08:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646153979; x=1677689979;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QSdkL8SpFj3+OqyjfAPQSvRRvmL3JAsdI6rrkjZu5Hg=;
  b=ckX51KxGld+PO2g/5ZFrE28GE7H6RoutEEmQJrHwE2OP19Qm/JQrsh81
   spvtqDpu4jqK3vS0eGgilYSxoi/vvDwv3fXtsmkNCzxJJZgkB8KBKdlDv
   dfrkJmDTG31SD3m0M3j884QgbreaDkVSUCRJ4O1dyWCDjTMC22YOOBcYe
   F4mjGQP2XDRBCdUZ0oNNgq0OkWzubaC9XlRzq0QHjmowiUqxXaZKmDmqT
   6iRiyM+ICneGbkgFzatwyTWjFWIWd2AHoOKAK2WU2xa/4vUArRttKnOMS
   NGSZi9xgjSm54sIMdFaB8pW3sTR9AbiriCKjegqFgqJ6kSGpJgjatdr76
   A==;
X-IronPort-AV: E=Sophos;i="5.90,146,1643698800"; 
   d="scan'208";a="154814020"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Mar 2022 09:59:37 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Mar 2022 09:59:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Mar 2022 09:59:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HP7BxxjRXFgZSUH7i4Mnifc4iO6RRRqLAQJ4di5cutjLLAV90GyddUEytmM45noRHQMpcDs5KuhySPX2fD49YmpWYvN9vYiHkJqEuYgLDt7voQkmfIFnvucNgotxvtmU9vhusoF0MEFUrMbR68FOg8fI0P/ra1SUv4IH9Yrmi/Tyyx78dCPlWX65mX76Vf05fJJnkjWJFZqiCntmpRcvxBkkq7nt3h71EN6AaS0HcY2H2FPeZ4EEOt/i0dZqMNMUgrtxGMaUyDX2wVjct9GEtyGmWQHmvbr+17rL5prcQ3u3SaqYUeqsX4rbwL9WR869V2HhbC8y6x4zuVZM27GeIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSdkL8SpFj3+OqyjfAPQSvRRvmL3JAsdI6rrkjZu5Hg=;
 b=HxZRd3dDCVoxH6lcWvqBSDiCgBaWHYNOUNnKo7/DX6COBIqyjQrmz8hukFzEMDihSsexL+L6a/GMCZfDh4p8zXU/ruJb5mwdasJ+C5fR40rDbJGDVel1zeMjcjvD26wo3F/rcmHRIn3sPCBKQGQ1uwcgfChxO5cOM1iK712ZxPtdZSbTIQB+SBa4EEtKn7da75WxLs86Zw62dforBPMj0eKZQc0yNs7gL/xXnssrhfx+CEYn/VKtyErLxVVmSotce02+FvqEDPhiBdX6x4TOc5YOSDWYBrTDiMz3qIUKTH4L4JOWLVa3e1BX91DnuV8coo0iCWe4GBEVmWQDf1GedA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSdkL8SpFj3+OqyjfAPQSvRRvmL3JAsdI6rrkjZu5Hg=;
 b=THm79a9xRr/hTa/J20o5N2OrFM3nW2SlNu0275VwTGnX8q9JP9eeMI3XOd1Cqp2sPLFsu75pe3Rq+RygygscBnZXKOUQ5b/0seGmK0dwmn1lFD81BkB7F9Ie+6YvDWffV6UooSd/KiPKmIPENMTc5VXDYJCGvKtc/uSfRVceM9U=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SN6PR11MB3182.namprd11.prod.outlook.com (2603:10b6:805:bf::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.24; Tue, 1 Mar 2022 16:59:34 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::29b9:feba:d632:55d7]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::29b9:feba:d632:55d7%3]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 16:59:34 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <linux@armlinux.org.uk>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        <kuba@kernel.org>
Subject: Re: [RFC PATCH net-next 4/4] net: phy: added master-slave config and
 cable diagnostics for Lan937x
Thread-Topic: [RFC PATCH net-next 4/4] net: phy: added master-slave config and
 cable diagnostics for Lan937x
Thread-Index: AQHYLK1IupV4EfcvKkmhRvuRAkW1ZqyqwhWA
Date:   Tue, 1 Mar 2022 16:59:34 +0000
Message-ID: <86f5cd5d5d694227da01709864e33c4b3fd0c1cb.camel@microchip.com>
References: <20220228140510.20883-1-arun.ramadoss@microchip.com>
         <20220228140510.20883-5-arun.ramadoss@microchip.com>
         <YhzYWXf30zcedsH1@shell.armlinux.org.uk>
In-Reply-To: <YhzYWXf30zcedsH1@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cebecdad-f4db-429b-23be-08d9fba4dcd4
x-ms-traffictypediagnostic: SN6PR11MB3182:EE_
x-microsoft-antispam-prvs: <SN6PR11MB3182C0EBE287C707F3603AC8EF029@SN6PR11MB3182.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jRETMNdOKc7C63l5jaTIpU0uIlMJfYb1D95EmaD7oxfcWmuPXU450vVH8j9N+CcuF9zMyVpx+q8/623DuJ6t+CMMsI4Q0256IE6G1rrZItBmPmDPThA1kgfl+bS3xl6ImvZB0p2/62kHyfriUvn9VTJPYv/ofi0ac9jpx+FGvpmoCrXbqalmwCXFJ1mhVRcQSbpJLX/LInySOr6Rz93KaLzaEOd+kh5SLkdVk+TAaohMd1Szm75mMf43+294IE5K+xFMS4q0a9MK6AqOC0VfIE7lUsbDreTDm8lNdYQ8D7mhjWDYocWliGoqP1LYPcEeEDqsjR7UShmlHS0IsWM7Lw0ZMp5JXGWtqSaebH6vxMV1FmkPU3SpSTUEvtC6g5RWsifaUSDH4y4tqkfefoCet+ULtW5voDxHe+SVH0Q9GzaHxhbIRBEAvg6r7dOJxsbi8aQPj7Vf3YYcd/+rabrm1q6PzlQlRPAJmRg93Cx/vA8FVnwaDAC4zshPMxXOAdIAnswUUSJTIccltliY4w8GFm86iUsnxj4KRjSl1jzCPPg/Q5LHzqYupFG5SWOe3GzcJduKQDewJDgcu4WozNC98VZz8fsvMw9iY16cTFgni7GTYzX/WQhH+k3R3maZpN7ceuVsY0mXHEeyWP98aMw07FrPAHPA7RiRnHGxdtJE40tUxtiZgTRgUjK2AqUCT7SJrGQcN9CTWISvu39my8M+K+j4xg8l5zMepo4PeP2ruSu/qq13ovf5zqvgRNpRTJNrvf4687QLsBxDvA/bfWdW8xa2BMh14BWOBjeKJOUD8+CGoYZWCeWj/kq7hArZgMHB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(966005)(6486002)(6506007)(8936002)(2616005)(38100700002)(36756003)(55236004)(508600001)(122000001)(71200400001)(83380400001)(54906003)(6916009)(86362001)(6512007)(316002)(5660300002)(38070700005)(26005)(186003)(8676002)(64756008)(66476007)(76116006)(66946007)(66446008)(66556008)(91956017)(2906002)(4326008)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUNabGFoZDZ3MHpzRyt0RXh3RHNDdUcweTNKR3RSbmRGMUQ3VHcwUEI1bk01?=
 =?utf-8?B?ZXVxQW5DaTZVUk1Ia2UwM0F3QWExMXVaYklXSFVkc1lTaUh4d05QQ1JIcThN?=
 =?utf-8?B?V3lUZnBIVkV6MjNEVk1uZEwybmRzRG14Y0N2NTE2NnNGS2xKUk4wZjhaZDNZ?=
 =?utf-8?B?MGRRMksvQjFHUWxubHJENWhxV0FST3d2OU9oYTZwZTc3MU1KbXAydE5VWmsz?=
 =?utf-8?B?OU5SQm1Bem93b2hFbWpOc0pzMkJualBCZUk5Rksrajc5RlVsRE1najdrRWNP?=
 =?utf-8?B?Yjd0MzFKaGs3MmhobWFzNXhadlFhUmdOUTdZV2Q5bmRGclBjTmwxWUpYTWky?=
 =?utf-8?B?VG1LWTZ4eEVOYzBoSFR6NlVIN0gxSG9aR1E2aVVnTEI5SlJhQjVlSU56emRw?=
 =?utf-8?B?Q0xZKzRhTEdBcUZJV1ZscmVlN0hMREttcHdBMmtCM1JYNEFvZGlqck9XU01C?=
 =?utf-8?B?M3FXZ2dKYWg5VnZjTWNDUW9VamtBUjloUVhzN2t1RlU0aVdqOTg5MVNORWl5?=
 =?utf-8?B?NFdlMDA4b0VqOElHWTBlaW9id2g0UHNOVzVpZkdnc3lTYXpkVEJ4SlZncU9H?=
 =?utf-8?B?eXRJbXZzaWI4TGJSYjdUdTE1R0dMMFhaY1RkSzVlTE45N0NpRzFyQXVKYlFU?=
 =?utf-8?B?L1l0SEZ5WFdTSUVyUzJNd2IzY3ZTZzdIUE40dU1aL3gzOENQeGtCS0VrS2Z1?=
 =?utf-8?B?d3dZR3BJajA2TEJ0cVBQNXpNTHdhQW1wU282a0p0aFB2SzdkbnM2bHRNd1FS?=
 =?utf-8?B?VlAzTWdsUnJubWl5eUh1TU42QnJGZDFsdHZvVEx6WXpqRU1pamVCMGswbExU?=
 =?utf-8?B?cDhoU0xUS1hFQzJ3cG1wUFpHMFNxU1RzZzZKWUZHZlE1N3Zkcm9STTc4cVJo?=
 =?utf-8?B?NkQ0SXl6RFk5bGU0S1lGOFpScjJxa05BYlpGVGQ0anROYllPQkFheldVL21X?=
 =?utf-8?B?T3BkMWp5WUREU3BLTkpHQVlsZlQyK3pZazFXN3F6emVFNFVqS1BZN21NdUNY?=
 =?utf-8?B?cDRlZFJpVkdIcm9DU1FQZjRMc3gwaHVJbVdSSjVJRWFTYkFNYitOYnNWOHJz?=
 =?utf-8?B?T3kxeTBmcG8wcmVUTGh5RWsrZ2RuVWZkN0lPOVczYWYzeng3SWh2ZHNVQmlF?=
 =?utf-8?B?VFErYmQ1aHdBMGwyS3p1TWZRMlN3ZFMwOFIvY0gzUVAveWxIWEFYK2o0WG9J?=
 =?utf-8?B?amZwYXdYMU1OTjV1Y2NoeXB5L3hVTmZlYkdaNzQ2REVqOGlkU3NHTGovRnFq?=
 =?utf-8?B?S012Ly9Fa2tDNGljQndqTWRPUW42TFVUandMKy9Lb2JWaXJMcm9DK3FIRVMw?=
 =?utf-8?B?V0w1NjU1SkF6ZHdoeFZjODhQWWpiYWZUdzV3bGxhR2NhYkNmY2VMbjR4ZnVW?=
 =?utf-8?B?T1dRWUdCVHNMYk5tRG1Xci9OUkNMZ2JyTFp1djI1QXkwMUxkUUhXRmZaaVBN?=
 =?utf-8?B?c0lRYjFFeGdBdGN3eUJBV0FuTDhNbkJNMUJGOW4rWFYvM08yempTdjl2bmpM?=
 =?utf-8?B?MlN4RTU4QnkrZDljRGNVRWgveFUwTjg1OVFNc0JVLzYxVGFDTDc3YVJ0andT?=
 =?utf-8?B?cnI3Y3B3T3NIcEFwWVN4bXFYT2lvTkx1ZFpoaTNFUXQ3M2ZyV2dJNFYwNmZ3?=
 =?utf-8?B?Y3p2Sk8xR00xb3hlRnVJbTAyRlR2MGtjQnlEWUFCZWc3RkZ6TmYvZUUrL3ZO?=
 =?utf-8?B?ZE80VG5DOHdCZW1YZ1RsdThrMWdISldYSmQ2emlEb1BKaHgvYXlEY0t6VUMv?=
 =?utf-8?B?VThEdnNROTB3Zms4TjcwMjkva1Jlb0V3c0cwNDdreVFaTUhJbVV3QzdmKzB6?=
 =?utf-8?B?ZVBWUklpYWp5TG8vWTNUWWlScUVGVytqMWZVR1J3WUhpM0xiOGYrN3UvNzEx?=
 =?utf-8?B?MHRJKzIzbm14RTk4RjlwQnhuNVk5MHZqYWNYbmZJSFcwNzY4bEZUdUNDSUpM?=
 =?utf-8?B?a1RVTDFpaTZqQmlaNmo4TTh1OC80SUtQdStWdFYyNjZGMGtGNGVsUU1DSWxw?=
 =?utf-8?B?M2ZJdVFiL0NRakV3M2UxVGlTNHMvLzhLRkRsd05UY0tza0g5NDM2dXVtMjdr?=
 =?utf-8?B?ZUw5YXIvdVR2QmQ0OGYxQURWSlU2MnZ6d1kwVVFXdkQwNDdzR240R2tkMjNx?=
 =?utf-8?B?N3JNNWdiRWw4RElQOWc0czUvUWxvOUtFVGpwc1l0RmNweklSQmE4eEhIMm4z?=
 =?utf-8?B?YTZTYm1LL2tSWUs1cEtDMlE2Rk4wRG9vaGtRWjJyTGc4bEJucGMzWlRqTFNx?=
 =?utf-8?Q?uhpOYWeE00nffkT9fZM7Rw2XuJKiFeRzhKVNIAwT/w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <19B078CE17F6C04AAABF2A8296E642A7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cebecdad-f4db-429b-23be-08d9fba4dcd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2022 16:59:34.6797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1mJGG/NDt4f5f++n/oDyEeg8cdbhnF5TBl4zAwJKUcX4JJfbWhrc0sWWvwdc+AoCMF/n++TxCbnLuh3FPPGE9+vveGcB2t8FdrRYEPS+b7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3182
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTAyLTI4IGF0IDE0OjEyICswMDAwLCBSdXNzZWxsIEtpbmcgKE9yYWNsZSkg
d3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRh
Y2htZW50cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24g
TW9uLCBGZWIgMjgsIDIwMjIgYXQgMDc6MzU6MTBQTSArMDUzMCwgQXJ1biBSYW1hZG9zcyB3cm90
ZToNCj4gPiBUbyBjb25maWd1cmUgdGhlIExhbjkzN3ggVDEgcGh5IGFzIG1hc3RlciBvciBzbGF2
ZSB1c2luZyB0aGUNCj4gPiBldGh0b29sIC1zDQo+ID4gPGRldj4gbWFzdGVyLXNsYXZlIDxmb3Jj
ZWQtbWFzdGVyL2ZvcmNlZC1zbGF2ZT4sIHRoZSBjb25maWdfYW5lZw0KPiA+IGFuZA0KPiA+IHJl
YWQgc3RhdHVzIGZ1bmN0aW9ucyBhcmUgYWRkZWQuIEFuZCBmb3IgdGhlIGNhYmxlLWRpYWdub3N0
aWNzLA0KPiA+IHVzZWQgdGhlDQo+ID4gbGFuODd4eCByb3V0aW5lcy4NCj4gPiANCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBQcmFzYW5uYSBWZW5nYXRlc2hhbiA8DQo+ID4gcHJhc2FubmEudmVuZ2F0ZXNo
YW5AbWljcm9jaGlwLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBBcnVuIFJhbWFkb3NzIDxhcnVu
LnJhbWFkb3NzQG1pY3JvY2hpcC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L3BoeS9t
aWNyb2NoaXBfdDEuYyB8IDc1DQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Kw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNzUgaW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9waHkvbWljcm9jaGlwX3QxLmMNCj4gPiBiL2RyaXZlcnMvbmV0
L3BoeS9taWNyb2NoaXBfdDEuYw0KPiA+IGluZGV4IDYzNGExNDIzMTgyYS4uM2EwZDRjNGZhYjBh
IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9taWNyb2NoaXBfdDEuYw0KPiA+ICsr
KyBiL2RyaXZlcnMvbmV0L3BoeS9taWNyb2NoaXBfdDEuYw0KPiA+IEBAIC04MSw2ICs4MSw5IEBA
DQo+ID4gICNkZWZpbmUgVDFfUkVHX0JBTktfU0VMICAgICAgICAgICAgICAgICAgICAgIDgNCj4g
PiAgI2RlZmluZSBUMV9SRUdfQUREUl9NQVNLICAgICAgICAgICAgIDB4RkYNCj4gPiANCj4gPiAr
I2RlZmluZSBUMV9NT0RFX1NUQVRfUkVHICAgICAgICAgICAgIDB4MTENCj4gPiArI2RlZmluZSBU
MV9MSU5LX1VQX01TSyAgICAgICAgICAgICAgICAgICAgICAgQklUKDApDQo+ID4gKw0KPiA+ICAj
ZGVmaW5lIERSSVZFUl9BVVRIT1IgICAgICAgICJOaXNhciBTYXllZCA8DQo+ID4gbmlzYXIuc2F5
ZWRAbWljcm9jaGlwLmNvbT4iDQo+ID4gICNkZWZpbmUgRFJJVkVSX0RFU0MgICJNaWNyb2NoaXAg
TEFOODdYWC9MQU45Mzd4IFQxIFBIWSBkcml2ZXIiDQo+ID4gDQo+ID4gQEAgLTQzNSw2ICs0Mzgs
MTEgQEAgc3RhdGljIGludCBsYW5fcGh5X2NvbmZpZ19pbml0KHN0cnVjdA0KPiA+IHBoeV9kZXZp
Y2UgKnBoeWRldikNCj4gPiAgICAgICBpZiAocmMgPCAwKQ0KPiA+ICAgICAgICAgICAgICAgcGh5
ZGV2X2VycihwaHlkZXYsICJmYWlsZWQgdG8gaW5pdGlhbGl6ZSBwaHlcbiIpOw0KPiA+IA0KPiA+
ICsgICAgIHBoeWRldi0+ZHVwbGV4ID0gRFVQTEVYX0ZVTEw7DQo+ID4gKyAgICAgcGh5ZGV2LT5z
cGVlZCA9IFNQRUVEXzEwMDsNCj4gPiArICAgICBwaHlkZXYtPnBhdXNlID0gMDsNCj4gPiArICAg
ICBwaHlkZXYtPmFzeW1fcGF1c2UgPSAwOw0KPiANCj4gU2hvdWxkbid0IHRoaXMgYmUgZG9uZSBp
biBsYW45Mzd4X3JlYWRfc3RhdHVzKCk/DQo+IA0KPiBIYXZlIHlvdSB0ZXN0ZWQgdGhpcyBwYXRj
aCB3aXRoIHZhcmlvdXMgaW52b2NhdGlvbnMgb2YgZXRodG9vbCAtcyA/DQo+IEUuZy4gYXV0b25l
ZyBvbiwgYXV0b25lZyBvZmYgYXQgdmFyaW91cyBmb3JjZWQgc3BlZWRzLCBib3RoIHN1aXRhYmxl
DQo+IGZvciB0aGUgUEhZIGFuZCB1bnN1aXRhYmxlPyBBcmUgYWxsIHRoZXNlIHNlbnNpYmx5IGhh
bmRsZWQ/DQo+IA0KVGhhbmtzIGZvciB0aGUgY29tbWVudC4NCg0KTEFOOTM3eCBpcyAxMDBCYXNl
VDEgUGh5IGFuZCBpdCBkb2Vzbid0IHByb3ZpZGUgb3B0aW9uIGZvciBjaGFuZ2luZw0Kc3BlZWQg
YW5kIGF1dG9uZWdvdGlhdGlvbi4gU2luY2UgaXQgaXMgZml4ZWQgYW5kIG5vdCBnb2luZyB0byBj
aGFuZ2UNCnVzaW5nIGV0aHRvb2wgLXMgY29tbWFuZCwgSSBhZGRlZCBpdCBpbiB0aGUgY29uZmln
X2luaXQgcm91dGluZS4gSSB0b29rDQp0aGUgZHJpdmVycy9uZXQvcGh5L254cC10amExMXh4IGFz
IHJlZmVyZW5jZSBpbiB3aGljaCBzcGVlZCBpcw0KaW5pdGlhbGlzZWQgaW4gY29uZmlnX2luaXQg
cm91dGluZS4gSSB0ZXN0ZWQgdGhlIHBhdGNoIHVzaW5nIHRoZQ0KZXRodG9vbCAtcyBmb3IgY2hh
bmdpbmcgdGhlIG1hc3Rlci9zbGF2ZSBjb25maWd1cmF0aW9uLiBGb3Igb3RoZXINCmNoYW5nZSBs
aWtlIHNwZWVkL2R1cGxleCBzZXR0aW5nLCBkcml2ZXIgd2lsbCBub3QgbWFrZSBjaGFuZ2UuIFdo
ZW4gSQ0KZXhlY3V0ZSBldGh0b29sIDxkZXY+LCBpdCByZXR1cm5zIHRoZSBkZWZhdWx0IHZhbHVl
IDEwME1icHMsIEZ1bGwNCmR1cGxleC4NCklmIGxhbjkzN3hfcmVhZF9zdGF0dXMoICkgaXMgdGhl
IHN1aXRhYmxlIHBsYWNlLCB0aGVuIEkgd2lsbCBtb3ZlIGl0DQp0aGVyZS4gDQoNCj4gVGhhbmtz
Lg0KPiANCj4gLS0NCj4gUk1LJ3MgUGF0Y2ggc3lzdGVtOiBodHRwczovL3d3dy5hcm1saW51eC5v
cmcudWsvZGV2ZWxvcGVyL3BhdGNoZXMvDQo+IEZUVFAgaXMgaGVyZSEgNDBNYnBzIGRvd24gMTBN
YnBzIHVwLiBEZWNlbnQgY29ubmVjdGl2aXR5IGF0IGxhc3QhDQo=
