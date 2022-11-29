Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BC763BBA3
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbiK2IbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiK2Iae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:30:34 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C599058BDE;
        Tue, 29 Nov 2022 00:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669710590; x=1701246590;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JK7/pYUvIhcrHYM5dh1z3v1Vbsu1lH8erXCbrunl77Y=;
  b=CQGSTyJAzGT5RYRyHmkP3/ambhfrasI6KYt6LrrSqDHHWPCF9KiPrtOd
   q2VaMNU8zxYk2ASiFD7zjaiiFdtfSj3g+ivGWQYWy9fA0vvl9VEnUDORG
   XiqTMrA2v5Q+OKINuTQLHw6fsfZLVX3HBVKPrqKI4hnpxEWjB+Ocac+up
   DW2eqzSlFzlt9tKP9o4J6spQ/9VME6Jdxt++zjlGMyeSkYwBN9ad5K1SU
   TnjHkgo7jU0a9f/yp1D6Sbor81oe6kQpRVU13TTXSkwS6heovyguaq0qZ
   RNWJnOSc/MQFcyS2Q457YcVAWGgXGkOfn9NrCB8Kq10Uxpj8EKYFKoBN0
   w==;
X-IronPort-AV: E=Sophos;i="5.96,202,1665471600"; 
   d="scan'208";a="190951359"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Nov 2022 01:29:49 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 29 Nov 2022 01:29:49 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 29 Nov 2022 01:29:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S4i0Yakx+AMF5mTaKLy5ViCyKxLRlfEgR01PKkrMonlwbZmwOFaTe4xKGDXyNXPjsDXSVSjnSmQsoyri5Vlh/QyS1aEMxw7x+YJHfqlnmGjfHJP18kZfFBch4PvPd5uslIi3SQtV0YyAqoBERezqIp5ApMm7X9KSz6Jry8QuvaxgHR7JUtAGI0xDGJvdu13bcZ39zvW7U0574n3qqwZeMmtExk6zNy+DWvHW0v4D+7gbXiEZPl9aW2NF2VMEWNNIBKQUY8Ldig4aa+cChfmsjDaUxnmqYOEO5cGGgAuoheMpoDpJtuqR6C3Yz0RrDEAyJlfNVhlAfxOeTR/294TAiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JK7/pYUvIhcrHYM5dh1z3v1Vbsu1lH8erXCbrunl77Y=;
 b=cLJzRc11NS6qnBsc93sjY5YbenatLuEgnzj7pHZhpmgD1mywO1CTWOJkszJdNCwPk1EBZ97zZwCZLBla1KHMcspPcALlHPEDAAjL0t7OpxhNLR59AJthDCwgftp8Z7NO5CPRBZPIqk1NZoMz4dg4zkMjaTpqeiGDiYPgK4urJI5BbikkB2BK5B0+dzwKP561yvUBTFNatONWT3F1zYj4tKnS8ikfbFU/Hpq3z+Rn9M0NI2h0jAt9afMyE2NgFtc4CCSD2riZ/INc22Xxq41QJ6sp8SokuKp9JBMVPm3DMcfQFYSnka5rJ4LKQs9TiDnvhbWZ47Q3LqHzHNGD1rIQJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JK7/pYUvIhcrHYM5dh1z3v1Vbsu1lH8erXCbrunl77Y=;
 b=q+OGqXEEwNTPymdICQNVUfxsnWucH32nqGrvkhZ/t/vlF2ogpEShRWz+83PIEdG6k/KkbeHb7pMrWo+QubbMdbjeYjQgMgLyxRxxAbCywmcWHM5xQLQgipZRpokeDzjj5BUX6/TIkOqe0QAaLxYYVi/xZOlxUKGBV83gWn8SkAY=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SN7PR11MB6799.namprd11.prod.outlook.com (2603:10b6:806:261::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 08:29:47 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 08:29:47 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <o.rempel@pengutronix.de>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH v1 10/26] net: dsa: microchip: ksz8: refactor
 ksz8_fdb_dump()
Thread-Topic: [PATCH v1 10/26] net: dsa: microchip: ksz8: refactor
 ksz8_fdb_dump()
Thread-Index: AQHZAyEV2UdzuZfaLkabDra25OI7765VkzaA
Date:   Tue, 29 Nov 2022 08:29:47 +0000
Message-ID: <aa1e91a9df8548559f0e6cde19dc1e90619d8a1e.camel@microchip.com>
References: <20221128115958.4049431-1-o.rempel@pengutronix.de>
         <20221128115958.4049431-11-o.rempel@pengutronix.de>
In-Reply-To: <20221128115958.4049431-11-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|SN7PR11MB6799:EE_
x-ms-office365-filtering-correlation-id: ee5688d1-127d-4985-b999-08dad1e3e013
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NNweSwkqE9KLF+RS20OdBcf3lgPOYtL8KWk01oAOc0RX7Nt2l9anWTlIB4T2aSg5qyZTwHIVncqhgvmASboj/S5lcYYMZEJEmKNyEU44uY7pTLQvqJRhs8gJCj6gHReuNFGnNMVmupAtjgllJKJ0V1MUZEOxa/6qxJ6qz9Nzq98FttrGyhyjXz3EipGz1VEzOgpwhJ45uXX5cq/kZMNj/baDytUVRKpvX23TP3kgKv7KcMCea1t7+hZHmVsK7J5H8gEH+y9ee8fI7vcD+EJ2NM5DJ3wp16+PQxjdo531PUovz17yznK5khUz2ZzHuDWDopxJX4LkaB9GoGhtaSwooUL4akD/81vE2oNHBHVn+QbmAsqE58iKp0hj+coILJnf/DSGUf7plH1cGSLah8s1Y/hFk0qGdh9jOg+RxCxz9/O1gkg6hXEJhZ3fSBOOuZTDHVqkPkNh8IycAvgE/0RgO4/g+FgjLdrhCR7AnbYVf1XVIyyJ252A240ITMUlX7dKJXNaUE6ibStw4BhOi6QJ0C/WHUIXoW0wGgXEf4KsABSzN6TbLWfhcXtpf4vZvLEbMYSLhU8357ePgJfB6G1FwgYApFfgpAuzGA7BWMvKdhy4csRzfv5nl6Wd7LBz1694Q/PNmAIZgb+Ca8drZ9IKGuxOOMjKwvuQ6aTu7xm5Ch2Bo/BYLJUt2DbloxloS2q0JchwykN7nHF/O7/lIsxTaX9CgDm2sBQcMrE0pYznSexQ8OxQ0phN5MpLNYVNI4NZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199015)(186003)(2616005)(921005)(86362001)(54906003)(316002)(110136005)(6486002)(36756003)(38070700005)(38100700002)(83380400001)(122000001)(6506007)(26005)(6512007)(4001150100001)(8936002)(2906002)(7416002)(71200400001)(478600001)(41300700001)(4326008)(5660300002)(66946007)(76116006)(66556008)(66476007)(91956017)(66446008)(64756008)(8676002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dVFkcHRLQWlyK1J3NW8reGVXRzllYmduRWI5MjYxR01VU2doMWprSmFWbkpj?=
 =?utf-8?B?T1liWDBpR0x1bk1vUjRwUTVlQlJtWG1vSFA5c3pRdmhabC9Wc3dGWWtYL3NI?=
 =?utf-8?B?b1I4eUQrbHhzcW82MzZOa3crNDFqRUcxQlg2Y0QrVGpVUkoxMk1GS1R4dWJ1?=
 =?utf-8?B?YURxNkJvVnJXNDNXVjhORnFJVTliS1hDSFlBZUFwam1NMSt3SkVmWS9JeFEr?=
 =?utf-8?B?K0Q1R0kvUU1jMzRINFl0cHBTMHdjckVEMTh0c1FXMG9HL0I4bk4rTXNrejFj?=
 =?utf-8?B?T3Jjbjk3VHhIV0wxRGd6QWwreFBFaXl0ekQrOUpSVVhtYUNvQlNqRjlCVVJD?=
 =?utf-8?B?NUV4WjRFdytiUkJGT2xQOGx2Y1E2UnR5bFNLSFVUcmg1OWJ0aFErZU11R1lM?=
 =?utf-8?B?Y1JGU3o0TmxhaEs2Nk0xK3lxRm9rQXJvdlRRbExvK1d4R2NmYzdCSEZCeEV5?=
 =?utf-8?B?TUdVTHJmT3d5RURRSUFGdlBHUXJpZ1llRWExMXdNaG83aFU1SEZTbW5IbE90?=
 =?utf-8?B?YVFMcFdjaUd5ckJCOElQaTZIMmZDSi9Zd0VGcGYyaU1QT0hCZml3aEc2ODRm?=
 =?utf-8?B?OGNHelpoak9BMmNBcVVFWXY2U1pjUXYyQWh3Um1ZN25WUU55cTFuRzB6Q01T?=
 =?utf-8?B?UFl3cmg4UngvMk5PalBtdHZaRTNXZU1VSUgrTUxxVFNDcitDNWw0VUs1NC84?=
 =?utf-8?B?RmNycWZnb2lLYTVBOGtXRmMzSGhERFdQc0JtNXNranRQOFR3MzRMSXRGeVFY?=
 =?utf-8?B?ZlRrRWltRVUwUkZQV25WVDJPTUR0YjZNVGlDOVdrYS9PemdYTUtuYkp4MW9H?=
 =?utf-8?B?ZUNwSE0rcFk1OEJBQ0VZOHk1elJKbHBaOVd2bWVDUDMrNkYzcDNwNHFIeDdS?=
 =?utf-8?B?QVNEby9XWEhQOUpNZGxIZjQ2ZTdyUTdBcGZrRUpUTlZXVkxReHltWnh4NThN?=
 =?utf-8?B?elY4TjFUMkVXRVErMTc1VU5lTHFvMkNNSVQxZmZ5NHBmMkM0dzBFWExuZk5v?=
 =?utf-8?B?VXlia1lNTTZEYjZVdytuenVGK2lpQTRmSU40N1lraTJsMjJVb1ZidThjVktX?=
 =?utf-8?B?bmo3SzNzUkJiVm5TcXUzcWhRMThxZE1pSEhleFAvYzJWZ0pBNDdRWG4rbGdH?=
 =?utf-8?B?TmJKTjhuL0ZGbXF6c0M2djBEdTRhVnN2enE5WjZYQ2FHakx4NXp6U2xlOWlu?=
 =?utf-8?B?eDY4akxBTUlwZUg3NEwyazdPdXZpNnNpR3JkTXhIMktRQUhNTCtmRFoxR0tn?=
 =?utf-8?B?TkNDc2p6U0hiVEsxWUg1T2VUM2ZPNitZdjh2c2xkSUl4cDcwcEQ1dkxIVE5X?=
 =?utf-8?B?Rlk2OFcrTDBNQnJndE9sdVdGOTVIdTRWaWtuVzJvSHVzZUtsNnFONkZudC9N?=
 =?utf-8?B?T3k5RzQ1QkhiT3p2ait6dUxUcHZRRnNJWVZQMGJjaEVzK3dwN0ZLdTl2UWp6?=
 =?utf-8?B?a29JSk4vRVBvemJvU0VCdnpycEJqZnF1OEJzcUZtS0hWZjdDbjdBZGhTamJ4?=
 =?utf-8?B?OXJ4MTR0Z2ZPbnhDSjl4eHRyOWlOdDBza2t0aXhKcXRoVC9VZm1KSFNWSHZv?=
 =?utf-8?B?aHNzc2hyYWt6c3ZVREtwQlFxeFNhR0pjSlN6UUJZMzRVcTdQL2I5UGQ5Y1hX?=
 =?utf-8?B?VG1FVm8zdVU1SFdValdSTVEzaEN0N0xkMklUR1hySktPZ2M3VHR2Z1NQQ3Jq?=
 =?utf-8?B?MGhZU0VFWktZa0lldDMya1paUmg5cC9xS2tnV2U2RHpHN016Z05EcGFxalNO?=
 =?utf-8?B?OExybzFVS3ppa3ljOUtmTHFHTnZHMGJOS1lXV1NpSTdHUERwTWU4Q0N2YlpO?=
 =?utf-8?B?NXRzL2RaV1JBTWNxekYwYWl0dmI2Qkc3OGxEdTFhVlZZNlE1RGVZWWowVG56?=
 =?utf-8?B?N2tDODFLK0JCSmVsc3ZFbE9QcVFSOFVxKzE5SE85bHNzbm52UytPQmNpbHY1?=
 =?utf-8?B?VDB1emRzU1lzNS9tcFM5ZERDTkVwOGdrWmd3d2Jkbld0c2ZHZmI3dkZPZ1k5?=
 =?utf-8?B?S1M3dDF1WWxabXNsOVh0d0tLYnFLYnFBR2RMMDdsWFMrNzFkK3lreXdrK2VV?=
 =?utf-8?B?aGhNV2Z6RUxNLzI4T2VUaGRKWlNrWUZ2dEtvY3pCTWZFZEY5TzhDalFRblVm?=
 =?utf-8?B?UUtFSFNmeEVNU1k3RHRFRmw2b3I5TzUvOWVEd2dmczZZWlBXS0hoNmQ0bDFY?=
 =?utf-8?Q?s/CgKzNIjolqZ57BkRPeYBY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2549BE774E326243BE8180E5F53627E2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee5688d1-127d-4985-b999-08dad1e3e013
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 08:29:47.3204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VjTlWKBomKdxJ5dQ6X0NHDEQC5V0kPQVOFKItCQgA/538JswxpX+H1OIk4c7gj0xuNZymlKEkP2R+YiI6YvDNFmheqb9UV8clV8NosaCxLI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6799
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KT24gTW9uLCAyMDIyLTExLTI4IGF0IDEyOjU5ICswMTAwLCBPbGVrc2lq
IFJlbXBlbCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiBBZnRlciBmaXhpbmcgZGlmZmVyZW50IGJ1Z3Mgd2UgY2FuIHJlZmFjdG9yIHRoaXMgZnVu
Y3Rpb246DQo+IC0gYmUgcGFyYW5vaWQgLSByZWFkIG9ubHkgbWF4IHBvc3NpYmx5IGFtb3VudCBv
ZiBlbnRyaWVzIHN1cHBvcnRlZCBieQ0KPiAgIHRoZSBIVy4NCj4gLSBwYXNzIGVycm9yIHZhbHVl
cyByZXR1cm5lZCBieSByZWdtYXANCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE9sZWtzaWogUmVtcGVs
IDxvLnJlbXBlbEBwZW5ndXRyb25peC5kZT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9kc2EvbWlj
cm9jaGlwL2tzejg3OTUuYyAgICAgfCA0MSArKysrKysrKysrKysrKy0tLS0tLS0tLQ0KPiAtLQ0K
PiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4Nzk1X3JlZy5oIHwgIDEgKw0KPiAgMiBm
aWxlcyBjaGFuZ2VkLCAyNCBpbnNlcnRpb25zKCspLCAxOCBkZWxldGlvbnMoLSkNCj4gDQo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTUuYw0KPiBiL2RyaXZl
cnMvbmV0L2RzYS9taWNyb2NoaXAva3N6ODc5NS5jDQo+IGluZGV4IDczNmNmNGU1NDMzMy4uMzA4
YjQ2YmIyY2U1IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3
OTUuYw0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTUuYw0KPiBAQCAt
OTQ5LDI2ICs5NDksMzEgQEAgdm9pZCBrc3o4X2ZsdXNoX2R5bl9tYWNfdGFibGUoc3RydWN0IGtz
el9kZXZpY2UNCj4gKmRldiwgaW50IHBvcnQpDQo+ICBpbnQga3N6OF9mZGJfZHVtcChzdHJ1Y3Qg
a3N6X2RldmljZSAqZGV2LCBpbnQgcG9ydCwNCj4gICAgICAgICAgICAgICAgICAgZHNhX2ZkYl9k
dW1wX2NiX3QgKmNiLCB2b2lkICpkYXRhKQ0KPiAgew0KPiAtICAgICAgIGludCByZXQgPSAwOw0K
PiAtICAgICAgIHUxNiBpID0gMDsNCj4gLSAgICAgICB1MTYgZW50cmllcyA9IDA7DQo+IC0gICAg
ICAgdTggc3JjX3BvcnQ7DQo+IC0gICAgICAgdTggbWFjW0VUSF9BTEVOXTsNCj4gKyAgICAgICB1
MTYgaSwgZW50cmllcyA9IDA7DQo+ICsgICAgICAgaW50IHJldDsNCj4gDQo+IC0gICAgICAgZG8g
ew0KPiAtICAgICAgICAgICAgICAgcmV0ID0ga3N6OF9yX2R5bl9tYWNfdGFibGUoZGV2LCBpLCBt
YWMsICZzcmNfcG9ydCwNCj4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICZlbnRyaWVzKTsNCj4gLSAgICAgICAgICAgICAgIGlmICghcmV0ICYmIHBvcnQgPT0gc3Jj
X3BvcnQpIHsNCj4gLSAgICAgICAgICAgICAgICAgICAgICAgcmV0ID0gY2IobWFjLCAwLCBmYWxz
ZSwgZGF0YSk7DQo+IC0gICAgICAgICAgICAgICAgICAgICAgIGlmIChyZXQpDQo+IC0gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+IC0gICAgICAgICAgICAgICB9DQo+IC0g
ICAgICAgICAgICAgICBpKys7DQo+IC0gICAgICAgfSB3aGlsZSAoaSA8IGVudHJpZXMpOw0KPiAt
ICAgICAgIGlmIChpID49IGVudHJpZXMpDQo+IC0gICAgICAgICAgICAgICByZXQgPSAwOw0KPiAr
ICAgICAgIGZvciAoaSA9IDA7IGkgPCBLU1o4X0RZTl9NQUNfRU5UUklFUzsgaSsrKSB7DQo+ICsg
ICAgICAgICAgICAgICB1OCBtYWNbRVRIX0FMRU5dOw0KPiArICAgICAgICAgICAgICAgdTggc3Jj
X3BvcnQ7DQoNCkFueSBzcGVjaWZpYyByZWFzb24gZm9yIGRlY2xhcmluZyB2YXJpYWJsZSB3aXRo
aW4gZm9yIGxvb3AgaW5zdGVhZCBvZg0Kb3V0c2lkZS4NCg0KPiANCj4gLSAgICAgICByZXR1cm4g
cmV0Ow0KPiArICAgICAgICAgICAgICAgcmV0ID0ga3N6OF9yX2R5bl9tYWNfdGFibGUoZGV2LCBp
LCBtYWMsICZzcmNfcG9ydCwNCj4gJmVudHJpZXMpOw0KPiArICAgICAgICAgICAgICAgaWYgKHJl
dCA9PSAtRU5YSU8pDQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAwOw0KPiArICAg
ICAgICAgICAgICAgaWYgKHJldCkNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHJl
dDsNCj4gKw0KPiArICAgICAgICAgICAgICAgaWYgKGkgPj0gZW50cmllcykNCj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgcmV0dXJuIDA7DQo+ICsNCj4gKyAgICAgICAgICAgICAgIGlmIChwb3J0
ICE9IHNyY19wb3J0KQ0KPiArICAgICAgICAgICAgICAgICAgICAgICBjb250aW51ZTsNCj4gKw0K
PiArICAgICAgICAgICAgICAgcmV0ID0gY2IobWFjLCAwLCBmYWxzZSwgZGF0YSk7DQo+ICsgICAg
ICAgICAgICAgICBpZiAocmV0KQ0KPiArICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gcmV0
Ow0KPiArICAgICAgIH0NCj4gKw0KPiArICAgICAgIHJldHVybiAwOw0KPiAgfQ0KPiANCj4gIGlu
dCBrc3o4X21kYl9hZGQoc3RydWN0IGtzel9kZXZpY2UgKmRldiwgaW50IHBvcnQsDQo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTVfcmVnLmgNCj4gYi9kcml2
ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTVfcmVnLmgNCj4gaW5kZXggN2E1N2M2MDg4Zjgw
Li4wYmRjZWI1MzQxOTIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAv
a3N6ODc5NV9yZWcuaA0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTVf
cmVnLmgNCj4gQEAgLTgxMSw1ICs4MTEsNiBAQA0KPiAgI2RlZmluZSBUQUlMX1RBR19MT09LVVAg
ICAgICAgICAgICAgICAgICAgICAgICBCSVQoNykNCj4gDQo+ICAjZGVmaW5lIEZJRF9FTlRSSUVT
ICAgICAgICAgICAgICAgICAgICAxMjgNCj4gKyNkZWZpbmUgS1NaOF9EWU5fTUFDX0VOVFJJRVMg
ICAgICAgICAgIDEwMjQNCj4gDQo+ICAjZW5kaWYNCj4gLS0NCj4gMi4zMC4yDQo+IA0K
