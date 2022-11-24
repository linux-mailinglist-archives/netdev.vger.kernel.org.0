Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17CF637C77
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiKXPFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiKXPFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:05:35 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975DDDDFB8;
        Thu, 24 Nov 2022 07:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669302331; x=1700838331;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4LSZgY+1sHzL28oxsekdrqvBocnLw11yAZVuJiOsKn8=;
  b=Dbd2cj/kYDThmlRlzZZVIZITQ15Ht0gyvfklgre8PFYIOBHyw5UJEiNy
   c1KTK02iQ+H/I4q4vjuJ5m8EdfHlB5MOwbcJM+5ghey426KV7UqcL8mk5
   TaD/6h8oadOU/5cQEG+1advVIwNeJtKhH3hURbaQmeUlDLFqgbYbe53lp
   8fWyz+9P3DTMpCT5L59zMf8m8nUEH1/2b/sH4fuI7D3DMogt2zpdZL89W
   OsN3bwDsl4QrHrgHn6TxcxZ8JbHHj/8X9KPzBT4J1zzGjceY/H5SWqAw1
   kP9jKxRl0jycy/7yn7UBlnw6tN5ZhG6Zv/F9Kfm/qFZ5We31z7aBM8qXa
   w==;
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="185048570"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Nov 2022 08:05:30 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 24 Nov 2022 08:05:30 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Thu, 24 Nov 2022 08:05:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gg686foG4j84llaAUhdyqpoTGYQhjcV6J8aLVO7rak+i+uNXEUZYn5qkD8mmDCTFlp1IZMAiv3ordy/jcPNSbLY/kkzHjlZjLPrau2Zo9JhUJ6gL40v2WJbs4VW6v0m/emcGOAcb6c9EFrd7QlqStiuzCb4fkDrq6U/ZYby1j5jnjRBZeEjTaWJ7FsA2JTviQeLer7O4QLOaMFgs/YuORVhDWyWbz8bXYOwOHNGQ6Gg9B/8Ujw7iQqo/eVMlkfdnpi9tKsTrMk9CgHsIUxaUJ85ogpkRa0DS//8tYKJPwgYp29zhIZ8t0/2gRrUdYw3M5rAWJjRL25Hs6+yAnyFtjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4LSZgY+1sHzL28oxsekdrqvBocnLw11yAZVuJiOsKn8=;
 b=K1UkfVjqJHKXbRvc/0y3Rt4gBVUeFlqjapVkKv6kwr14EV83Rj0D/ZN/xoipnxUKvFXr9KtBdRiIPYTefhYhZcPB7O58byVVXgzZcEt1j/uOFPdW3NWqmlWoePfZfil/lnxusWiWYSi36C4HNT2IO04f60xebKyhAnDPO1EvBzLhFwqTC9podjUg9cJHcULsGUsR7nzXAEZ+k6yZotsU8UnhUhbnjuvT0i/9VTGq/zFcKfS9U61nX890w++g8/+BVyeq/t5EcIjdhNLuFtm4oaYI1FOM3TdRxxfUEI10OuLFcJAnOmKGyT8chjzhLp9Fqk1QwHL/kNIMD/ilIhhdPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4LSZgY+1sHzL28oxsekdrqvBocnLw11yAZVuJiOsKn8=;
 b=SbZGV3H6eW3pFOXZfUBrW3rMyMrl3JT4Nz7QMDXJoeaEBbggbw1f/BqfyOm/ODEVfQJAn0aRycdBdcaqfmYINE20p5PeW97psxLEacdoCy4quWKYL6AFneb9jTmgMLRrp2T/FUCaR2fuQsAIi3L/uEoeJLJZm0ipQhvWMf7cOMg=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 PH0PR11MB5030.namprd11.prod.outlook.com (2603:10b6:510:41::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.17; Thu, 24 Nov 2022 15:05:28 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.018; Thu, 24 Nov 2022
 15:05:27 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <o.rempel@pengutronix.de>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v6 6/6] net: dsa: microchip: ksz8: move all DSA
 configurations to one location
Thread-Topic: [PATCH net-next v6 6/6] net: dsa: microchip: ksz8: move all DSA
 configurations to one location
Thread-Index: AQHY/+3FigeduKl0pEWlWfqldCou765OLIIA
Date:   Thu, 24 Nov 2022 15:05:27 +0000
Message-ID: <e270aedb761cad689ee969285ac07578848e2ae5.camel@microchip.com>
References: <20221124101458.3353902-1-o.rempel@pengutronix.de>
         <20221124101458.3353902-7-o.rempel@pengutronix.de>
In-Reply-To: <20221124101458.3353902-7-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|PH0PR11MB5030:EE_
x-ms-office365-filtering-correlation-id: f67fdb50-75a2-473a-8a4b-08dace2d525f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H3kfn0zdXuvyxHuSzfpoClDhWo+6yUtUklM2zYO5ALrBrpJy2nd44GQ2Ji6y7BYH1tuABKcyg9Rj5h0w3USigGscu7R2WqqpOStj6wWTCjc5CGjYiTq0umo7Pi6s0WXaVEbFj7bh9G5h03AeFgYLXrpSRknHy77gbhUxr2w7dKM4iZm8zaCu1HgNpmdv2T2J41fGuz0vktBAIo9oRROJT2j1bngd6GVWfmutTh2b1gyNHDOo/TtYpqWo+T3XFJcu8qNdL32dg+tRrUQ+94K2ZFLVsVY7SEjoFpq8psF9/NNyK1NMSK62zuntu/GvFCzOD9xUeyrIfAdZbh8AtSnPWDkP5RYdmifmFyJFcIec0Hcqt9CyCNdjTL9sR9GxakzudCGzZ2ZkcgfUEZ2W9zBpiPng+3VejouuEqIo3Czr+Nx7fgkCSHt7aDcGOqsz6v95Zy9/bXjM7127mekPg1f5wN7InmZteprDVxS8RDr6VMJ1D15Xk8t0qxcmLba+J4TGJ1y38RRVL/c9qxqnZLwN+OVEmRJF8i0BeZ4pGQOMpNFY8fO4bLZskyhthQf8ptJJ7bvAdixGsIXL+rtxmgzP2mMwUqJAqssBWhkjqWQSkEeAGq6xHkxASeGjq8XyAAlBAMZ389uSeYC0eEeGcUPeKiwVdWrrIrPVNr5B8PkxTZYSeYwfQqe1trmBSVltY6h5dgD9JK31+vKHdHfZKu4TGS1WtXsf4ITNO2f+ag8GlI4kJNbtNYo7O85xEKLOUH2J
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(396003)(39860400002)(366004)(136003)(451199015)(921005)(4001150100001)(5660300002)(7416002)(2906002)(8936002)(6512007)(38070700005)(6506007)(122000001)(38100700002)(316002)(71200400001)(54906003)(110136005)(36756003)(4326008)(66476007)(64756008)(66556008)(66446008)(8676002)(86362001)(41300700001)(6486002)(83380400001)(76116006)(91956017)(186003)(66946007)(478600001)(2616005)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZlprdUJTMGQxNUswM1BRazRzTDhEZndDNEdZVldrOUlHdVZycnpTc2hKaHdu?=
 =?utf-8?B?VWZPeHlma29uc2UzLzMvTmF0L1VZRVZucGNPZGRBRXo0TkpTK3NsYTBCb2Yy?=
 =?utf-8?B?ZG9QdVNMNWp1RUIveUcrVXJWUTlkWXBBaFA3Skp3cHZBcTU0dFdqQm9aYXVY?=
 =?utf-8?B?c3ZkR2t2NWpzWFdhZnFWZGs0bjhPcSt2enBMZllVQVpIVEUxSmlJSUdmd2kz?=
 =?utf-8?B?WVRFS3hadGZOTlYxenJwS1FsWnMxL215R0lrZUdsSUg2SXc5SVN0Q3ZLS0tj?=
 =?utf-8?B?SGVLbk1Tbm5xWEVtY0ZPUEd2Mzl6bE1OSGw3K3UyVFpUMEhpeWVnZmd2WDUv?=
 =?utf-8?B?TWlOb2xBUkF3a05zOHMxY215OTNGNmRReVVxTE9TdzV0ZjU4dWpSK1liMEp3?=
 =?utf-8?B?ZGNWK3lMbFBLN2xTOW56WGFrY2FSZkFUMTNYWkpnR1hjWDhPQnhoSU1DVXdv?=
 =?utf-8?B?eVlDKzJBZmpuMmpvWS80dHlwak1xMnpiUlFua1FMSjJ4N0pEbWI4eUdNOTl3?=
 =?utf-8?B?d2trL2dsSitpaHJRZkFweDNjVXFGWUdPUmtTTHZEZUt2WXdGdjNDRHhpbG9p?=
 =?utf-8?B?TzJzbGEybXJKWmNwZ0RMeExmQ2laWm5EY2JiUGYxUmZBc3VPejAwOEhQdUk5?=
 =?utf-8?B?dTZNbGNNT2RDOForY2FVUDRVTUtaMUU5Vlgrc0MzdzRHbjBoZTJtZnNsbHUw?=
 =?utf-8?B?RW1JclFNejluTzJxK1pFTW4wdDRTQlhxVk4rUUZQUjNXWDAzNUt6OFRhUnE1?=
 =?utf-8?B?UkdzU1BFMUQ5UDFWUFdGNktvVENBNlp0azdrczNQdElhNkZaT1lqSXFIRE1y?=
 =?utf-8?B?czduNlpjZmhtam5xb1BUbDZtcDFJMDRTbzhIOTYxTTBRQU9BcFM0RnJqOUdl?=
 =?utf-8?B?TDk3N3dGc0JuVnRUb042ZmxXd0UvdmF6bUhzdnBPNnRvWE0rRDRQYUxnd3FR?=
 =?utf-8?B?TnpOSXBkekhqSTVha2s2dU9yUHkxQWlIOURIeGtsWTZFSUJJYmdvTUJwaDhi?=
 =?utf-8?B?REozN01pVFhwSWU2dkNHT0RaSHpVdDYvY0s5UW5DNDlOdkdtVDNNZzBPUEhG?=
 =?utf-8?B?dTR5SllYV3lObndiZ1Nvbm45b1NaejB5bDhNbXAreFQvNC9QdWViSDRvVGgr?=
 =?utf-8?B?ZFVHaWFMNW9OOXRrUmVSelNnUjlCN0FaNmp0YTBpaU4xMk1pQlJvK1B4SFVa?=
 =?utf-8?B?ZW1mdWxRMUpYNW91Y3NoZVBjTGRaencyVzRJV2lqNjNjSTBpR1UrRStMQk9B?=
 =?utf-8?B?QW0waDQ1YjN0UmMzY251M09GbHJUbDBwZmNyVTNrNG5ZWHdTbXJmd09xOWFE?=
 =?utf-8?B?aERDY1JYTFJWR2JYUDRKVUN4aGpzWkh3ejlZR09RaXR5cC9hZ0VaSjFsNVha?=
 =?utf-8?B?UUViaUpOUE5YZk55aStMeSt1eFRrYi9MTlU1NVVna0JEYis0eklTUHo5TEtO?=
 =?utf-8?B?VTQ3UlI2TTUvMEJ5RERqNVphVENWREFtVnFzMzZmMmZ2aHovaklvYm4zWTB6?=
 =?utf-8?B?S1RZZmtMZ1pwY1k1MU5vcDZhd2JNTUwyQnozK1hybUorOHRhZmhJSDY5UGQ0?=
 =?utf-8?B?VnEwemkzUSsxQng1dms5YTdOcWQzZ0Qzc0tjbEYxL0Z4WmNPcWlad2VTRVhV?=
 =?utf-8?B?cjdOK3BLNnBmdjgzeUh4b09wdlY5RFdXeDhZSUxUSFU4RjFla0h4SUVwQ1pR?=
 =?utf-8?B?NDFDZ25qeVpQaVhCR29QMm1YU3RqRUUzU3VlajJyYVRqcE5KcVoyMjBJRW9K?=
 =?utf-8?B?OUtLa0FITGoycU1EanhNM3ZILzZoUjJlN3BJaWVDeXI4M2J6Rk5OSXlORmNy?=
 =?utf-8?B?M3pScG5WajRUTUJId1dmbDVNUFpQOGUvRkpYMitnRzAvUTN3MVJOeE1CODRl?=
 =?utf-8?B?elcrdVh0dlJ2MlV2bkwza3BTSmZJK0N5ZkU4RUEyNGs2UUh0ZTM0d2c5STho?=
 =?utf-8?B?Y0dKbVdXQnhnS0F6S2kvM3l4MjdyeEg0VUZndk1vNC9RRXA5VzZjanBaVjAw?=
 =?utf-8?B?a3lqOUtBS0w3UFVzRHljMUx0SEJGam1MdzJOYjJFWVRIN2QzM09TSE5ZaTkv?=
 =?utf-8?B?b2s4WWpTVTBvbHJRa3VEaU9lZGxLUUFMVm5FSFZkWkRZMmR6emVqcW9WWTdE?=
 =?utf-8?B?TDYzakRzTi9XYVZlM2ltRFJqYzRVdFYzdnc1cjVQdFlNWDhJRUNYMEJFZm1Q?=
 =?utf-8?B?TjVQdG5NNFhwZERSY1VleSt5aW1udUN0ejNPR0xQK2xlOE56YVI1Q210YjVD?=
 =?utf-8?Q?luWpiQFUr/xD+SjN4p6IailmbK70OCGpxMYdQDGRkA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <80498BE5EC4F7145B2EF134251AC35F3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f67fdb50-75a2-473a-8a4b-08dace2d525f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 15:05:27.6877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w46RFepGtMvui88mzbX7xojien2k4qxmzyQ9qQ9VhnDlKBAaWAjoCVTv5It5gto4e5EC6iXVg/aFtHF1Shl/dpV01OZV87bbCTGGiFkE25g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5030
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCk9uIFRodSwgMjAyMi0xMS0yNCBhdCAxMToxNCArMDEwMCwgT2xla3NpaiBS
ZW1wZWwgd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiAN
Cj4gVG8gbWFrZSB0aGUgY29kZSBtb3JlIGNvbXBhcmFibGUgdG8gS1NaOTQ3NyBjb2RlLCBtb3Zl
IERTQQ0KPiBjb25maWd1cmF0aW9ucyB0byB0aGUgc2FtZSBsb2NhdGlvbi4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IE9sZWtzaWogUmVtcGVsIDxvLnJlbXBlbEBwZW5ndXRyb25peC5kZT4NCj4gLS0t
DQo+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTUuYyB8IDIwICsrKysrKysrKyst
LS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4
Nzk1LmMNCj4gYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTUuYw0KPiBpbmRleCAw
NjBlNDFiOWI2ZWYuLjAwM2IwYWMyODU0YyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNh
L21pY3JvY2hpcC9rc3o4Nzk1LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9r
c3o4Nzk1LmMNCj4gQEAgLTEzNTksNiArMTM1OSwxNiBAQCBpbnQga3N6OF9zZXR1cChzdHJ1Y3Qg
ZHNhX3N3aXRjaCAqZHMpDQo+IA0KPiAgICAgICAgIGRzLT5tdHVfZW5mb3JjZW1lbnRfaW5ncmVz
cyA9IHRydWU7DQo+IA0KPiArICAgICAgIC8qIFdlIHJlbHkgb24gc29mdHdhcmUgdW50YWdnaW5n
IG9uIHRoZSBDUFUgcG9ydCwgc28gdGhhdCB3ZQ0KPiArICAgICAgICAqIGNhbiBzdXBwb3J0IGJv
dGggdGFnZ2VkIGFuZCB1bnRhZ2dlZCBWTEFOcw0KPiArICAgICAgICAqLw0KPiArICAgICAgIGRz
LT51bnRhZ19icmlkZ2VfcHZpZCA9IHRydWU7DQo+ICsNCj4gKyAgICAgICAvKiBWTEFOIGZpbHRl
cmluZyBpcyBwYXJ0bHkgY29udHJvbGxlZCBieSB0aGUgZ2xvYmFsIFZMQU4NCj4gKyAgICAgICAg
KiBFbmFibGUgZmxhZw0KPiArICAgICAgICAqLw0KPiArICAgICAgIGRzLT52bGFuX2ZpbHRlcmlu
Z19pc19nbG9iYWwgPSB0cnVlOw0KPiArDQo+ICAgICAgICAga3N6X2NmZyhkZXYsIFNfUkVQTEFD
RV9WSURfQ1RSTCwgU1dfRkxPV19DVFJMLCB0cnVlKTsNCj4gDQo+ICAgICAgICAgLyogRW5hYmxl
IGF1dG9tYXRpYyBmYXN0IGFnaW5nIHdoZW4gbGluayBjaGFuZ2VkIGRldGVjdGVkLiAqLw0KPiBA
QCAtMTQxOCwxNiArMTQyOCw2IEBAIGludCBrc3o4X3N3aXRjaF9pbml0KHN0cnVjdCBrc3pfZGV2
aWNlICpkZXYpDQo+ICAgICAgICAgZGV2LT5waHlfcG9ydF9jbnQgPSBkZXYtPmluZm8tPnBvcnRf
Y250IC0gMTsNCj4gICAgICAgICBkZXYtPnBvcnRfbWFzayA9IChCSVQoZGV2LT5waHlfcG9ydF9j
bnQpIC0gMSkgfCBkZXYtPmluZm8tDQo+ID5jcHVfcG9ydHM7DQoNClNpbmNlIHlvdSBtb3ZlZCBk
c2EgcmVsYXRlZCBpdGVtcyB0byBrc3o4X3NldHVwLCByZW1haW5pbmcgaXRlbXMgaW4NCmtzejhf
c3dpdGNoX2luaXQgYXJlDQotIGRldi0+Y3B1X3BvcnQgLSBVc2VkIGluIGtzel9zZXR1cCBidXQg
Y2FsbGVkIGFmdGVyIHRoZSBpbmRpdmlkdWFsDQpzd2l0Y2ggc2V0dXAgZnVuY3Rpb24uIFdlIGNh
biBtb3ZlIGl0IGtzejhfc2V0dXAuDQotIGRldi0+cGh5X3BvcnRfY250IC0gVXNlZCBpbiBrc3o4
X3ZsYW5fZmlsdGVyaW5nIGFuZA0Ka3N6OF9jb25maWdfY3B1cG9ydC4gV2UgY2FuIG1vdmUuDQot
IGRldi0+cG9ydF9tYXNrIC0gdXNlZCBpbiBrc3pfc3dpdGNoX3JlZ2lzdGVyLiBTbyB3ZSBjYW5u
b3QgbW92ZS4NCg0KVG8gbWFrZSB0aGUga3N6OF9zd2l0Y2hfaW5pdCBhbmQga3N6OTQ3N19zd2l0
Y2hfaW5pdCBmdW5jdGlvbiBzaW1pbGFyLA0Kd2UgY2FuIG1vdmUgZGV2LT5jcHVfcG9ydCBhbmQg
ZGV2LT5waHlfcG9ydF9jbnQgZnJvbSBrc3o4X3N3aXRjaF9pbml0DQp0byBrc3o4X3NldHVwDQoN
Cj4gDQo+IC0gICAgICAgLyogV2UgcmVseSBvbiBzb2Z0d2FyZSB1bnRhZ2dpbmcgb24gdGhlIENQ
VSBwb3J0LCBzbyB0aGF0IHdlDQo+IC0gICAgICAgICogY2FuIHN1cHBvcnQgYm90aCB0YWdnZWQg
YW5kIHVudGFnZ2VkIFZMQU5zDQo+IC0gICAgICAgICovDQo+IC0gICAgICAgZGV2LT5kcy0+dW50
YWdfYnJpZGdlX3B2aWQgPSB0cnVlOw0KPiAtDQo+IC0gICAgICAgLyogVkxBTiBmaWx0ZXJpbmcg
aXMgcGFydGx5IGNvbnRyb2xsZWQgYnkgdGhlIGdsb2JhbCBWTEFODQo+IC0gICAgICAgICogRW5h
YmxlIGZsYWcNCj4gLSAgICAgICAgKi8NCj4gLSAgICAgICBkZXYtPmRzLT52bGFuX2ZpbHRlcmlu
Z19pc19nbG9iYWwgPSB0cnVlOw0KPiAtDQo+ICAgICAgICAgcmV0dXJuIDA7DQo+ICB9DQo+IA0K
PiAtLQ0KPiAyLjMwLjINCj4gDQo=
