Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C6A63CE7D
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 05:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbiK3ExV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 23:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiK3ExQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 23:53:16 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A58F2A952;
        Tue, 29 Nov 2022 20:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669783995; x=1701319995;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0g2VBBHGDjFMu+VuwcH00FbLcCelj5/uDh/Fp9GOWU8=;
  b=R91lTdR9H+LXWthGPWEC3Y6I88FsgVKhMGsrRePzcuadka0/znfldrXA
   zWNfCkTNjf6dbKkAaznfe1kkVtj1Tqr7haBC2TylZa+NatyPVQuHYX/x7
   XFaJiv8g8FhwTJTqxyuxm3/1NIPZkpy8etHl/Mt2+bBEOJR9eUBO1wUph
   bn0plAjNBLLl+/CU49+4Xli0DS8relKQFZm/Ga2Tkwwj8QBX5wrL+UjJw
   jlsjMNUOKctPgTNff3SUGTvuhCvY5PoriMnuGnEDiO8syQ0aCmOjbpQh5
   N9mlLAm6t0Vjrc+yljksBywJeqFojsHhJ4URUuqtm5YCflKfhXCioET5m
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,205,1665471600"; 
   d="scan'208";a="191075684"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Nov 2022 21:53:15 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 29 Nov 2022 21:53:14 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 29 Nov 2022 21:53:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RoDwGEOENx6enm0+QeOEUdm4xaQCC35LC3hfVz7CxGwbQwDQwXwQc+Jscj/GbDgWa+XaE9B2t2pMAx2D/HyGhd0ATLfSIAoaGBLz8E0rtBAInBxr3NDrJkQljJbloj/vMAjVz3iO0Vtpy5u1xk+KUx1j9phblH1xGmCiirZndw4JOIsmNWYNQtVIH7lQBW4+N+kzRHbT/GOgrDwxm5AbdI4ilO+HmbRh7+JgQIK+4X4wRgmkEzPhh3ibd55GtkIWHuGfqH9UimNUikHHbujHiz/1Zys6uFnmU/gEw9/wKGBfna8sXhDqQIF96vl3ZBC+HoXQrUYaJdBacZghYGUd0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0g2VBBHGDjFMu+VuwcH00FbLcCelj5/uDh/Fp9GOWU8=;
 b=TbJduI6u4KJ8ucSD2vLwmOQzayGBp5xXzeEj7BvY+HEPeFO4UKUU6uK5fgzdf1SETLOIoFr65D7+FDA2WbHaX2NT40B1AAZHaERpxLKANowFTWUaBzWvu91bkhlsb1HVYUyYj8d+lMl3oCEAMwstqf5U1LOihTwm6EkUO5ViE9j4wTF6apzLvr1cakLLhIcYXn5lAUhQi3I2mhUm7SbBlMniYGDIi2dyePujhkXkxrCoXQGVuRVSni3mmEGx4VA/w8to8CisD6AvG6dX/YP9urmscBg/aT0WwahdAS95hhKpgZ5RvCxB+dSbpPL75J/FBcCY8Ib8LNw94YW59MoOzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0g2VBBHGDjFMu+VuwcH00FbLcCelj5/uDh/Fp9GOWU8=;
 b=kWUzrVT+MDSEZTGPP0R8T1eMhvI9I6AXXePrTPx3OoUvj5YqlDhZ3ZZ0pgy1tYL9lwu4/twb3BHa2sMY/c6nExcQmGQ5P+5V27TPUmU9Ovv4/cBICqtqTRN+pctM5v2+k5T/MdOkGHrXOxSnb9Jjugxr5JnLO1mqQvoQqCscm30=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 PH0PR11MB4774.namprd11.prod.outlook.com (2603:10b6:510:40::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Wed, 30 Nov 2022 04:53:13 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 04:53:12 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <pavan.chebbi@broadcom.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <olteanv@gmail.com>, <linux@armlinux.org.uk>, <ceggers@arri.de>,
        <Tristram.Ha@microchip.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [Patch net-next v1 01/12] net: dsa: microchip: ptp: add the posix
 clock support
Thread-Topic: [Patch net-next v1 01/12] net: dsa: microchip: ptp: add the
 posix clock support
Thread-Index: AQHZAxTYWXj56xDlbku6lHt9xaEY865UaxeAgAJ+CwA=
Date:   Wed, 30 Nov 2022 04:53:12 +0000
Message-ID: <48f0d7891b480b2242eff6343719880df3d17c8c.camel@microchip.com>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
         <20221128103227.23171-2-arun.ramadoss@microchip.com>
         <CALs4sv19Efi0oKVqRqRFtF2SCr6Phejh4RFvuRN1UCkdvcKJeg@mail.gmail.com>
In-Reply-To: <CALs4sv19Efi0oKVqRqRFtF2SCr6Phejh4RFvuRN1UCkdvcKJeg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|PH0PR11MB4774:EE_
x-ms-office365-filtering-correlation-id: 83190ece-ccef-43e4-a962-08dad28ec926
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1ukVvm4oKb7ddW3JV4pYQJLAcWJP5bk/OPJwSVrjHG5WcWydSaMi2me6qdbTKaNS6JHRUEwKZLt4rGfxsCyHiwugwyVb5Zlh+gNGFss1UthaaD639E8KgSgoafKs0m2eBt9WRDemlak6U8v9pRYPmHAjfJ49fO5tR/qo9w4Qb4pbCDVEYp1b9oE/EvxG3L0rnq/JWWxjZCciR4NrPdeTpBMRdwlSC0pAtAyRUEXW+hjbEwfsJDnjHGDUIwiCT+XPs9R2wKY5FuEHXFs0JiRmNvQk4EBScapoe6mGfRwVs4uOWvacAHDOypgU9jjQqOUOpUN0bfQWrHIHWXnxaIdokycVp/0qW8EM4kZhIls67o2jMRucDn5ONT1F3TM37pwIiO1pBCPdPJULVVppqDGko7t2USN6MwlG6lUtLIkjtFMpzMi52r1zk9nJZYHR85e6axxWExum3A2oa4SwD+264t8RocmFn140u04rSO7gzcOYK1C0sw54Pmb+VGl2od47JTqpjZt191H5cARyAhDZX6CmuYmIlKqyEDzAZ7c3T2k70RzwfNw8zGat5A8EtdiMGIdvZcjy7cJiK/48IUaC3dpwwxFJHzWDHgibYlcP91USEbKhjyLbfuLiw9PAlRtAj8Wy7//fqCSRbEcP/Tnk7/rxMEI71br24mqCqLQvKzr3OyWMSafGB6qu5+JacEAXf5yFYpHGk3Pt/TrbQDhKI5ta8e38YSIUpemfqfAVRA0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199015)(5660300002)(7416002)(6916009)(54906003)(2616005)(26005)(6512007)(41300700001)(66946007)(91956017)(76116006)(66556008)(4326008)(8676002)(64756008)(66446008)(66476007)(122000001)(36756003)(38100700002)(8936002)(2906002)(38070700005)(4001150100001)(186003)(71200400001)(86362001)(316002)(6506007)(6486002)(53546011)(83380400001)(478600001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MXFveEpKOG9ZMDR1Ymc0dytpeWpPSGlHdjQxbURnOUJXVjhQaHpNNnFXTjZ3?=
 =?utf-8?B?YU11NC96eFNmbEdRN2RLNllaZEJwekxFcGQ4TlRHbU95dDdUcStOQ0ZldERJ?=
 =?utf-8?B?cVE4K29jdVlxQjBwV2ROU0FHNkJOVWszRmNvOHpDa09aeW16QXJTVU5OQ1Bi?=
 =?utf-8?B?M0hWK21WV2ptWlllNVFpR25sS2g4WG5IN0dKYmlsZG91MS82UVZncFdUVnc3?=
 =?utf-8?B?WG5ydjNOMExuU1ZEakU1V3RZQlNoOExxOHpZelZDaXVxaUoyUVROakZqb21M?=
 =?utf-8?B?bkNSU3h0SkM3NlluUjcxZWc3dkg5Q3YyZnlYZDRBaE9wRzdZamU4VUhDcjg2?=
 =?utf-8?B?Sy8wNGZxSXFBQzJVZ0crQXl2Umt6SFZTeTBFTk4xWGJJODJxY0VmbUQ5eVM0?=
 =?utf-8?B?aW55Ui9CQVR3YzdnellRTDhRMkd0MUtXZzBtVFg0c3V4RnJXNlpZMldCeGQ2?=
 =?utf-8?B?NW82Vy9QZkFGUEZzWlIzdU5sRVE4RXJUV3lHMjZWSWdFYmdXaUdVaXU0aTRi?=
 =?utf-8?B?TVVaSFpJd1FOSnUxL1I2U2Job2l2TUJaOU1RaVphOUdBOXhPbXYyMy82QXBQ?=
 =?utf-8?B?emZCNkQ0NGp4ZlYzNXZ3NzByOFhERUx6T2Uyd0RVZ3FjdnFuQ2k2cFlmdTh0?=
 =?utf-8?B?N29kb01kSWtRV1hGbk5OeUkwM3FaUWFPNDZBR014Q0kvRi9MK3FSd3FVVU9j?=
 =?utf-8?B?NUs0SlJQMGRTNDFFV3JLTHdRMzRpTUhRY1Y4VDcyRGQ1VGNINUljK3oyWHB2?=
 =?utf-8?B?S0VBeWtPUWhoTURNZjZZMWE3c2x1alJoQ0pZeUwzc0Nla29LNXlZQUVPS1hF?=
 =?utf-8?B?VDlKT1dBN24rbTdsakx2RWR6dk9ESVc1NldoYXNSc012T2ZxTGxWREJvc2pK?=
 =?utf-8?B?SW8vOXgzTDI1dGgxMEFWOHZ0SFBKbUhSS3lGdEsyMEFKOFVCVGNYRUtYNXlS?=
 =?utf-8?B?M1loTndrWGZVVGE1d2dzRzliWFNKU2JZbERTUmErME5TU0NVZjI3N29oRDZt?=
 =?utf-8?B?L0ZkbGhuWkpJZ0NzN041bDBGLzY1Zi9HNTZ2LzRMcVA3VEZpVmExYVJPMjBN?=
 =?utf-8?B?K1hLSXNCa0NFQlllT3Y0Y01vNnAyVzJ3ejQ3TGd2aDNpc1N0OXNRSVNmamln?=
 =?utf-8?B?ZkF3eGRLejllL21XbVZtQk1uT0pMS1pTblkyUkJIenc1K3g0WFRWTHRuWW93?=
 =?utf-8?B?S3ZZd2JkT0VuNWpKQ3B0Mmw0anJKODVWYXVDQ29oSjZCZE8zUjJkTEVZcDVJ?=
 =?utf-8?B?bk50WGQxdjZLK2YyR05iY1hMRGhlWWZpSE1pYzBQYVpobUptQTR3Ukxib0x4?=
 =?utf-8?B?azVqeTNOU1FNNXlOcGhScDNDdEpuVXliSWQzQ0FJUFI1d0pETzQxK1ZuUUp3?=
 =?utf-8?B?eHJKemZHeUhwUTNzVlgwaG94V2tDOUVySDZ6M0ZWQWFET3NSUXFpaUJ2MUVk?=
 =?utf-8?B?Q2k5cmRJRGtOMzdtV01ydGFYMHIwN05lUHhVRXZRWHFTZktlbm44R01DZGxt?=
 =?utf-8?B?RnlPQjRYWW4xNE9oWnlPSEdjaUpYQklLU2U5UWgxKzBEUTlORk9mVFN6ZHlY?=
 =?utf-8?B?UU12MkhTMHZjTHFlZkQzVktMOWJXcHBBOG5ueUZmaThWa1crMFNkNzM5MHlM?=
 =?utf-8?B?MkdhZkw0RGVjSHZUTzk5aWU0UEdEbVVybUhqSnN0U3ZEQTVkenV3RlQ0M0t6?=
 =?utf-8?B?cmRSZTZDTTJYVUNnMGtmUVZreUNTK3c1YjdDK0trNlZNNm5BM1V3OEpqRk81?=
 =?utf-8?B?Y3h1by9mZXBId1MxRFZSWVpTbEkzY0NTVm4zOENVQlNVa0gvVFBzdUd3OXNT?=
 =?utf-8?B?S1ZtSlp1ckc2cjBDTjF5NXgzYnd6YjN5bElhVDZxR3NGdVhIM3pMYUpQTHRQ?=
 =?utf-8?B?bk9xK3U2TE1EUzN4WEkwZzRIbDlKR2Q4VXU3ZExZVkVLNnNoT1pTS3VXaU5N?=
 =?utf-8?B?Tkg5L2lTZnp6Nlc2OC9ROHpLZWxDdWNkeEJHM0JRZnFGTU5BeGRjUXphb3pu?=
 =?utf-8?B?VGJLSWwzYnFxSktsN1FJM0RDeWx6cGR2a2YySURDcEtWOEtoS1J2WXJHNDZQ?=
 =?utf-8?B?ZmR0MzhRZmJ4dW11QVJacWFVcE9YOEJvVkt4akR0WVRLMGt4OUlNMzBLUDJD?=
 =?utf-8?B?YnB2a05ScFNvSDJCWVpvd00yb0U1UlBJQ3QzR2xrWTRldXhaVk44cndGaXA3?=
 =?utf-8?Q?BXzL7sJZZuy5Br0rPhYrI34=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <671175CA1D2E594D9FE838C815898B05@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83190ece-ccef-43e4-a962-08dad28ec926
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 04:53:12.7977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghEnFR5T8tqWmXvtB8lTTponbpu6O9j/OztUy1bzqxBm8VkXvER6Xz3AQRr1Zs3m0z04Nim0c2Orz7t98gheJZ6gGtiy1nDL9rKF7WcgSFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4774
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGF2YW4sDQoNCk9uIE1vbiwgMjAyMi0xMS0yOCBhdCAyMDoxOSArMDUzMCwgUGF2YW4gQ2hl
YmJpIHdyb3RlOg0KPiBPbiBNb24sIE5vdiAyOCwgMjAyMiBhdCA0OjAzIFBNIEFydW4gUmFtYWRv
c3MNCj4gPGFydW4ucmFtYWRvc3NAbWljcm9jaGlwLmNvbT4gd3JvdGU6DQo+IA0KPiA+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9wdHBfcmVnLmgNCj4gPiBiL2Ry
aXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X3B0cF9yZWcuaA0KPiA+IG5ldyBmaWxlIG1vZGUg
MTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMDAwMDAwLi5lNTc4YTAwMDZlY2YNCj4gPiAtLS0gL2Rl
di9udWxsDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfcHRwX3JlZy5o
DQo+ID4gQEAgLTAsMCArMSw1NyBAQA0KPiA+ICsvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjog
R1BMLTIuMCAqLw0KPiA+ICsvKiBNaWNyb2NoaXAgS1NaIFBUUCByZWdpc3RlciBkZWZpbml0aW9u
cw0KPiA+ICsgKiBDb3B5cmlnaHQgKEMpIDIwMjIgTWljcm9jaGlwIFRlY2hub2xvZ3kgSW5jLg0K
PiA+ICsgKi8NCj4gPiArDQo+ID4gKyNpZm5kZWYgX19LU1pfUFRQX1JFR1NfSA0KPiA+ICsjZGVm
aW5lIF9fS1NaX1BUUF9SRUdTX0gNCj4gPiArDQo+ID4gKy8qIDUgLSBQVFAgQ2xvY2sgKi8NCj4g
PiArI2RlZmluZSBSRUdfUFRQX0NMS19DVFJMICAgICAgICAgICAgICAgMHgwNTAwDQo+ID4gKw0K
PiA+ICsjZGVmaW5lIFBUUF9TVEVQX0FESiAgICAgICAgICAgICAgICAgICBCSVQoNikNCj4gPiAr
I2RlZmluZSBQVFBfU1RFUF9ESVIgICAgICAgICAgICAgICAgICAgQklUKDUpDQo+ID4gKyNkZWZp
bmUgUFRQX1JFQURfVElNRSAgICAgICAgICAgICAgICAgIEJJVCg0KQ0KPiA+ICsjZGVmaW5lIFBU
UF9MT0FEX1RJTUUgICAgICAgICAgICAgICAgICBCSVQoMykNCj4gDQo+IFBUUF9XUklURV9USU1F
IHNvdW5kcyBtb3JlIGludHVpdGl2ZSB0aGFuIFBUUF9MT0FEX1RJTUU/DQoNClRvIGhhdmUgc2lt
aWxhciBuYW1pbmcgY29udmVudGlvbiBiZXR3ZWVuIGNvZGUgYW5kIERhdGFzaGVldCBpdCBpcw0K
bmFtZWQgYXMgTG9hZCB0aW1lLg0KDQo+IEFsc28gSSBzZWUgdGhhdCBhbGwgdGhlICNkZWZpbmVz
IGFyZSBpbnRyb2R1Y2VkIGluIHRoaXMgcGF0Y2gsIHNvbWUNCj4gb2YNCj4gd2hpY2ggYXJlIHVz
ZWQgbGF0ZXIuIEl0IGlzIGEgZ29vZCBpZGVhIHRvIGludHJvZHVjZSB0aGUgI2RlZmluZXMgaW4N
Cj4gdGhlIHNhbWUgcGF0Y2hlcyB3aGVyZSB0aGV5IGFyZSBiZWluZyB1c2VkIGZvciB0aGUgZmly
c3QgdGltZS4NCj4gSSB3aWxsIGJlIGxvb2tpbmcgYXQgdGhlIGVudGlyZSBzZXJpZXMgYnV0IGFt
IHJlc3BvbmRpbmcgdG8gdGhpcyBub3cuDQoNClRoZSBwYXRjaGVzIGFyZSBzcGxpdHRlZCBpbnRv
IG11bHRpcGxlIHNtYWxsZXIgcGF0Y2hlcyBmb3IgcmV2aWV3LiBJDQptaXNzZWQgdG8gbW92ZSBo
ZWFkZXIgZmlsZSBkZWZpbmVzIHRvIGFwcHJvcHJpYXRlIHBhdGNoZXMuIFN1cmUgSSB3aWxsDQpt
b3ZlIGl0Lg0KDQo+IA0KPiA+ICsjZGVmaW5lIFBUUF9DTEtfQURKX0VOQUJMRSAgICAgICAgICAg
ICBCSVQoMikNCj4gPiArI2RlZmluZSBQVFBfQ0xLX0VOQUJMRSAgICAgICAgICAgICAgICAgQklU
KDEpDQo+ID4gKyNkZWZpbmUgUFRQX0NMS19SRVNFVCAgICAgICAgICAgICAgICAgIEJJVCgwKQ0K
PiA+ICsNCj4gPiArI2RlZmluZSBSRUdfUFRQX1JUQ19TVUJfTkFOT1NFQ19fMiAgICAgMHgwNTAy
DQo+ID4gKw0KPiA+ICsjZGVmaW5lIFBUUF9SVENfU1VCX05BTk9TRUNfTSAgICAgICAgICAweDAw
MDcNCj4gPiArI2RlZmluZSBQVFBfUlRDXzBOUyAgICAgICAgICAgICAgICAgICAgMHgwMA0KPiA+
ICsNCj4gPiArI2RlZmluZSBSRUdfUFRQX1JUQ19OQU5PU0VDICAgICAgICAgICAgMHgwNTA0DQo+
ID4gKyNkZWZpbmUgUkVHX1BUUF9SVENfTkFOT1NFQ19IICAgICAgICAgIDB4MDUwNA0KPiA+ICsj
ZGVmaW5lIFJFR19QVFBfUlRDX05BTk9TRUNfTCAgICAgICAgICAweDA1MDYNCj4gPiArDQo+ID4g
KyNkZWZpbmUgUkVHX1BUUF9SVENfU0VDICAgICAgICAgICAgICAgICAgICAgICAgMHgwNTA4DQo+
ID4gKyNkZWZpbmUgUkVHX1BUUF9SVENfU0VDX0ggICAgICAgICAgICAgIDB4MDUwOA0KPiA+ICsj
ZGVmaW5lIFJFR19QVFBfUlRDX1NFQ19MICAgICAgICAgICAgICAweDA1MEENCj4gPiArDQo+ID4g
DQo+ID4gDQo+ID4gKyNlbmRpZg0KPiA+IC0tDQo+ID4gMi4zNi4xDQo+ID4gDQo=
