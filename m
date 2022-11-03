Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC04617935
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 09:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiKCIz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 04:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiKCIz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 04:55:28 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE672C763;
        Thu,  3 Nov 2022 01:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667465727; x=1699001727;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UtPlzBMI02sVMdCBDuLW/IosBPeBQEUxAGnlDpgJjEM=;
  b=pPN6GroMDEtpTfaJqj7zhPFbZaiY3AFw0N1aBAFFzTX36B4K1AcKmOvD
   Tg93fRkmp/UsDRv9V7xvAhtFy4oYJh5UT8uOC4IMslYYfVat7DePNrORB
   PnIBUxqWV0MViVp5IZOzxRfttFqnC0w86lxXTkKuLG8tFMLGRb2mFfgeN
   DYxxw2BrjKQNb8bBk+amEJpZVncOLXrQ5g4zftrSYsmaswB4jikf6jcty
   Licok/aOgPfdHaEMCBdDIHcNmdLW9frc1/69Y8KsfgnMjVd9Svg/PEhvB
   x6HLdTi2Ld4qAGS62PAi244lvb5uKjJUur2G4C5bombm70NhigqcJr6fn
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="198213008"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Nov 2022 01:55:26 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 3 Nov 2022 01:55:23 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Thu, 3 Nov 2022 01:55:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4EMTWHKISwDYk/XYAQnINWyR4V8mhGB/b0IrzKYOMU3FwjAkwc3arXRYMPdkMh6KHsxcMPuaplZV0oz82bCit40n9mHbMgpkkcV3OasNaBPoZ3MQs4jVIwfd9dOgXAP3NzI5iZRwOfN3Jn3mo8vctnx8iEd6wjWAu+lK8vDfllTbF00AkaEqVWPTjagMIowUGuXioA6C3RcySUn1wgO2OqACzEOXTX7jyadNl9FXjGd9TD98RT93FJBCml3/iHJBr6zgd7BxOJpMIUbGSKySCTObwogr37OU/cLwZ0p1B369b/YvHdCXNhxz4lw+rAmOcYcO7Y7jbs2p9DFmq6KSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UtPlzBMI02sVMdCBDuLW/IosBPeBQEUxAGnlDpgJjEM=;
 b=aIU4DmqBmNbaxNppG/nKkOcQ0PEws/qO/7c3+tpwy97/XPaCBPhRPqqmSoIv9h56bPkm0g7v+LiK39FSyDiasoZa4wVpHTA4hK+18FzC830Js1oLiFwkuZz3iEtKrFY7nAe8bnZjOsajQenY7/Z2/xVHx4pQRkDYef0Gft8EoQjg5bSXXeJb3IAFflSiIEAinovVByIMt0fS1BmG5h7gdhLEU918JliO14iurgflEhvUIkHjaaH62SXbseR6tpnbkWPFeM25Pq93j+VMVcqvxGu2CX1Kpat0x5nCSmMLGUUoCQRVQAYGFZSGO3RiLxOxq/gc38c0sFTiJOAw4aiOWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UtPlzBMI02sVMdCBDuLW/IosBPeBQEUxAGnlDpgJjEM=;
 b=PZ4kDKYiNPp1GjMhjgbmqXxXvh14hcjTZ5/erltq1CeEeGhr+sxQAzruNztRb/ElOhmW05NBvDNdEOtvdjeIYMRalxg246P87H/z1Ti+TnbYLBffeBTWCm6SsERAcxMiPdscH7LXU47cR8Y0L0zfuOvnjCMA69rVZBVitAOIBuE=
Received: from MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9)
 by MW3PR11MB4618.namprd11.prod.outlook.com (2603:10b6:303:5f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 08:55:19 +0000
Received: from MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::4340:6f79:9fb5:ca2a]) by MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::4340:6f79:9fb5:ca2a%9]) with mapi id 15.20.5769.019; Thu, 3 Nov 2022
 08:55:19 +0000
From:   <Rakesh.Sankaranarayanan@microchip.com>
To:     <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <vivien.didelot@gmail.com>, <Woojung.Huh@microchip.com>,
        <linux-kernel@vger.kernel.org>, <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <edumazet@google.com>, <pabeni@redhat.com>
Subject: Re: [PATCH net-next 6/6] net: dsa: microchip: add dev_err_probe in
 probe functions
Thread-Topic: [PATCH net-next 6/6] net: dsa: microchip: add dev_err_probe in
 probe functions
Thread-Index: AQHY7nGqA0jB5ykm6U6Mx2kVeIzKMq4skgaAgABUh4A=
Date:   Thu, 3 Nov 2022 08:55:18 +0000
Message-ID: <426d6221df095b82391ecf868868ffc756162fc1.camel@microchip.com>
References: <20221102041058.128779-1-rakesh.sankaranarayanan@microchip.com>
         <20221102041058.128779-7-rakesh.sankaranarayanan@microchip.com>
         <20221102205047.10867032@kernel.org>
In-Reply-To: <20221102205047.10867032@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB6088:EE_|MW3PR11MB4618:EE_
x-ms-office365-filtering-correlation-id: 67d32556-c363-4082-8ac2-08dabd79223d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gaBoOoSJAia175Z0gLo6RVPPJjiOfVUfwCM+SU2NiXNO3uiQE5QVDOFFV2EHeITRykwYKX4WVnZ2XNaxgYy/84cewv1F6aiFH9/zPkjICgwqTj+2YqtWgvPu1fjbQRfdG2pRuRqmRSdYO8GUxwUz0Zcw1rWOXWeBF7BZx/cDoFGMgWH4VAE1J8KxvVfG7D77i4vU7proSrbu/DzWcU+uZ+b1Iufa3wjvBQDf7xQoOo7a/D+G92QIXKR75SE22vrFdG1IzLWDx7/uY8itNLvfoH6HgYCPLBckQa16z8uwtRP7vLhPMsFMp83JZYMSulhSwjVr078TFETFvtu2CC3BJUghdckNgiO1JNa1VMEGGgYzFux0d0+r2ZzJL98O6Wu5XZD+lrRBXx9XyeMk9q6tOsT0FKKjZuTsDN5/L1FDIob0+BocPcXIt81/HT4WO82z/6LEFoygXSTFLcIdA7Sup43Ly63Pp+qRKO3eWj+Q/VERwda4ZhMhy2vW20XUvZ+QwrXh1avnDS+o4LdDqvhNIJ3hDcPp1J96NOd7gLqMG/BrldrZQP8uzWjUCPMaOZvEP4Q49krUuhmjoqpP43DgvilTDDbHIaAqmqdbJ5v7Pg2csDHT9sX2zcCk7i5c/9XqFXc7OYZrdAK9SiYykZFtxJazOyfG31YW0pVpnLxihAbEyFwKZUs1p4OoYmHzkvHssvbVWn+ingYfnP16oUxvIKNVGP/kPaJfLX4OrAmGgFRMCZd10jK/Ife91FD7cGYjmC1R+c1KZmEfUl3X6UZXTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6088.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(376002)(346002)(136003)(451199015)(66476007)(91956017)(66446008)(66946007)(8676002)(64756008)(76116006)(66556008)(4326008)(316002)(71200400001)(6916009)(41300700001)(38100700002)(122000001)(2906002)(4744005)(8936002)(6486002)(7416002)(54906003)(6506007)(5660300002)(86362001)(26005)(186003)(6512007)(478600001)(2616005)(38070700005)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2tZL3ZKd0hZUGpUK3F3eHFHS0hyeHNpQXZoZFNROStCY2R3aS9kQWduZVhX?=
 =?utf-8?B?RVNqVDhrVytnMGtlQlN6TjRoRXJRK25nVTBRbGlJNXFNVHN2Wk9GdkozUnFM?=
 =?utf-8?B?L0Q0WE41UEl2Y1g4VFcxVzdCV3p4d014TGhUclNnK0daTE1HeTlXZnJxa01F?=
 =?utf-8?B?RitYMWV0dHZEV3BtY2xOUTBhU2lVZ3JTNlZWTTdWQUMvQi9GZDlxTUtNclNZ?=
 =?utf-8?B?VUxzMFQ1SXZ2a0NaL0kyUlU5Q3ZIZmMxMTVGb3hRTmZ6cG1FUzZSWTVmYXpx?=
 =?utf-8?B?MklRUTZlUlZwTFVWREZlQWdRRXNKdnF2MldOUW9pMmlLdkNoN2c0SnpBZEM0?=
 =?utf-8?B?bDdKZGMxVXFlWjlWaUk0VWsySWhQTkdQZkE3MFdjS2JhbThYTmt2WEtCS3FN?=
 =?utf-8?B?cHo1Y1JMZmFkcTJ2QkVqREQ4VllPMkYremh3ZEVKK3JDRzdlcElZSDBBQlcv?=
 =?utf-8?B?N1prRE9yZkVqUkd4VzhnT0J3UmtIUTlVRnMxWE5sM0hpOWVYajd2Qzg1L1Ay?=
 =?utf-8?B?QWhSSnlYQ1diL1FzeFVOUk9PRzNHdVBWaHVaQ0FlQ1FjeDhYR3VsbyszOE41?=
 =?utf-8?B?L3dLTmxQTTErb1B6QnB6YUdQRE55cjBPK3MzMmhuKzNhcjRUZjJFSVB2K1ZT?=
 =?utf-8?B?bDRoTEM2UVYzcnNwYUU4c2hwQloreWdzc1lCa1pJVEJ5bjNJR2g1azdBUDBU?=
 =?utf-8?B?WUdIaDZ1S1ByMXg5U3A5NENCMXAzc0I0ZDZpZ2lJcm1QRkQ5QkRxaFR6UFJw?=
 =?utf-8?B?eFB5R3NudlM5MzZ2WTNYZTNFZjc5SlFrTlFDMmtuR1I5SG5yQVNnZXZCVFZV?=
 =?utf-8?B?b01qV2VVcDNxVlNzaUJYdGhQbTlHQmtOYmxNdXN2SXpmNFN0ZTlxU1V4OFpI?=
 =?utf-8?B?VWgxWndmbDhsTmRTZHF1YzVGQ1FuRW9IcGo0L3hRV3prSmpiNFgzaXR5RDVF?=
 =?utf-8?B?YmNrQkM0T0xkYmhoenNZUGxMSW9XM01ydFV0dVYrSGs4YUcxZzUySW9KcWxM?=
 =?utf-8?B?ViszTjZJeGxQOUJNOGVQV3BoU1BKK0FjeDBldHdDb1cwRHdiM3pWOG5JWmtt?=
 =?utf-8?B?S1JrZllBSWFFMEw3d1I3N2VFR2RsWVhIRklZRm9FY1hMTW1weW5EQVBMdEZ1?=
 =?utf-8?B?ZVJwZWRnWEpIL1EwMWJocHcxQklqUDh2dyt5aG95OUZ6dVVsNVZHNHdLZDVN?=
 =?utf-8?B?MkpyY3g5eXBVaXcyZUtid1NuVHBDdEZ0VUVPMkd5cXJCaTM5ZU9idFJPeFV6?=
 =?utf-8?B?clV5V1FoOHpJb00wWTdZeW11TzJiemYxemQvcFZDd0NNUXN2aDU0aWtlQVdn?=
 =?utf-8?B?blp5akY2bXlubmhJQTdJMklDa3FvRFE1L0VUS3Q5eGxQb2hvakwxVDI0WTN1?=
 =?utf-8?B?c0JaQ1lRVktkbHlBeEs5d0R2VjNLd2daRUVCZ08wdHV3RU92ZEJGVFBVY2ww?=
 =?utf-8?B?cDNvMUFXS1N4YkE3Q2ZCYlNsR0gwTTdOOGtoVG1kOW9IVHhtVVRWZkFiTy9S?=
 =?utf-8?B?alNJWEVOT3NUTCtMdWZPejhnTDdSL21MbGhqTURvb0c0ZFdzdkgwdmloVkNU?=
 =?utf-8?B?L3B0L1NxTTUxdmRUdEZoWFh0a2Y3WCtXNGFqQjl6ZjRnMGN5RkZCSUZ6R2Nh?=
 =?utf-8?B?SE45YzczYllCUjNVQnRDcDBhWVp2M1FPTm9KRlNCOWtwQUMzdG8rVkYzYmcz?=
 =?utf-8?B?VTVrb3RvSjAxWklKTy83ZC81RXhUbmt3VVMxRHg4bWNJdE10VVFxTFIvZVk1?=
 =?utf-8?B?YmVjeVQ4blZlcGp2ZEphbWNZalAwRHc0d3QvMHdqK05NRVI3VFJGMmdCME9B?=
 =?utf-8?B?azh2U3pHUzRGa0xCTHhkWTBiQnBtMXRNa3Q4d2pzWkN6T1dyOVUreHlhdDBU?=
 =?utf-8?B?bzc0N0Zva2pKQWt4WnZKNU5nS0tUNlJwZW10aVlyS2NSa1hCT0lqWWVWMlJV?=
 =?utf-8?B?R0V3ZzJ4bG1lRkxON3BVZmRGYUJOcHh3d2JTMHp0dHFGT29BOW9mN3NUUllr?=
 =?utf-8?B?UzM3R1dzbHJ3S1RhMWVjMDRLeTVrSnVGdUV3amtOQUNUTTE5aWZhSlk1OWVu?=
 =?utf-8?B?bG1FL0JhT1NCVFNpVWJvT2tFUmxLaU9vUVZjd0p4UktmbmlJaHhlTWdHRmVl?=
 =?utf-8?B?WkNSVk95UUdlcnRKMEdkL21QdXhSek9IbGFtUk96MFRYcWFMTUVwdHFqY25K?=
 =?utf-8?Q?Ru2Wb8kQn+j/J9H4KTNzvL/oRIjOJ/xVa9d7JJOqJsIN?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <270DD19880E93C48968F2C5C0474D136@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6088.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d32556-c363-4082-8ac2-08dabd79223d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 08:55:18.9341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wDS3jhdh2WOEJBrSuTbWfh+48Y6SKOwzAkKeFlMiYpQyX8F6EzpsnvQJ/DhI2GSErJ5U+Mz7FWxCMaOph3VjXqKBKzFIyzlA32elK5Y+aVHVeg9ocONPO4JPfgltMI2i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4618
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTExLTAyIGF0IDIwOjUwIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToK
PiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMg
dW5sZXNzIHlvdQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQo+IAo+IE9uIFdlZCwgMiBOb3Yg
MjAyMiAwOTo0MDo1OCArMDUzMCBSYWtlc2ggU2Fua2FyYW5hcmF5YW5hbiB3cm90ZToKPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBkZXZfZXJyX3By
b2JlKCZtZGlvZGV2LT5kZXYsCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBQVFJfRVJS
KGRldi0+cmVnbWFwW2ldKQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgIkZhaWxlZCB0
byBpbml0aWFsaXplCj4gPiByZWdtYXAlaVxuIiwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgCj4gPiBrc3o4ODYzX3JlZ21hcF9jb25maWdbaV0udmFsX2JpdHMpOwo+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgfQo+IAo+IERvZXMgbm90IGJ1aWxkLgoKSGkgSmFrdWIsCgpSZWFs
bHkgc29ycnkgdGhhdCwgdGhpcyBmaWxlIHNraXBwZWQgZHVyaW5nIG15IGJ1aWxkIGR1ZSB0byBj
b25maWcKaXNzdWVzIG9uIGJ1aWxkcm9vdCwgYW5kIG15IGJ1aWxkIGRpZG4ndCByZXBvcnRlZCB0
aGUgZXJyb3IuIFJlYWxpc2VkCnRoaXMgZXJyb3IgYWZ0ZXIgc3VibWlzc2lvbiBhbmQgZ2V0dGlu
ZyBzdGF0dXMgb24gcGF0Y2h3b3JrLgoKSSB1bmRlcnN0b29kIHRoZSBtaXN0YWtlIGFuZCB3aWxs
IG1ha2UgcmVzb2x1dGlvbiBpbiB2MiB2ZXJzaW9uIG9mCnNlcmllcy4KClRoYW5rcywKUmFrZXNo
IFMK
