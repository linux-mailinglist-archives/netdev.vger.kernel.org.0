Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CBD63ED21
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiLAKB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiLAKBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:01:55 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A410D1D1;
        Thu,  1 Dec 2022 02:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669888912; x=1701424912;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BL+gDRAy5fTUhfuesYTczhh7+K2KRrtW4NJzqAAdmTw=;
  b=Ye9nAJkZpnAmk8O0JXPOG3AEo6x4J4roQlmpQI0pAt3c7O0+8YElryI3
   loZlkZIwPzZbcD2k4v39xOXp3B9UQz0BojYclWdeEA5aKo49E9WbYw/MB
   6FwbU12ZXIzSQgJhwpW69FU2BhVMnO0pAH8JDUQml1QL3eHgV4VIaOp3k
   vlB3Xb45eDMYDc+vCyLcN5sCtpEJziOouCk/GkNwbSQMIcwzdWGgdyBB+
   X2nbZHU+EBN+qHYuWL58VK5RpKwuR/6lOzwMy2nFwdpajbIIh2WGIWZZU
   eIKtEUmGgNXpgB4NFfSxQh0Qp/FJ4EMi1JIcR+nEERIkb6jznM7zwNr6v
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="191269069"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Dec 2022 03:01:51 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 1 Dec 2022 03:01:50 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Thu, 1 Dec 2022 03:01:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YKB5dYEe0YBYlSbtl4n+FNnfi/k+I+VpEBixlPjB/xf3Di7pcCMmZCGzT3LUQeLBUK3k/bjH0NBW3GrGSczkjCZtt+6pHM47RWC2vQV3KyQt3kymDM4e+GH5NHtTWmccd3Q2cefKv+Ysds0zdGO6Z29fqSa2G03R/jh6Hh811qpk5N/JKDA0eHTqWP01bDlH44eqkU6+O+5XB9RqKHKuKURqeYlP3pUy0Ss35PM2TZnH88fa2temJ/k9QgHI7FEo0f7WsbLlRMTEyKepQcKVI0QhxTmCvVbqFyGG8IlnCQhf8Xa44TYvm01kfr35i6eRaIsTiTO6Wkf/pNjgvBe1PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BL+gDRAy5fTUhfuesYTczhh7+K2KRrtW4NJzqAAdmTw=;
 b=X7ZHP4ooUHJrnaldgWBxUlWret39OMcgYsSaEsBLqalsWnUZpP8JiVTlpLs2EIYdi87ovuFr+wqc/21Hj2VaI+3HuPc10rNlEFMcJCkkGIPqR+iRJZDm6r1q6LbFdlF2/HOF9iK2kRGSowcejVU+v9C/R7sF4ipwev/07nY7Is8RvAJ3zYh7bFD21epEOlRmgS8REpfO6O31pBzerLrcBYs+IuJha8c2gBaPsJqgpbnyqvAlodeivyVb9h725WlzBzZkzmCdVOerSCd/+mAdgJRGutrcqfQxeyvJl1RQCzgcMf1JlzOc9jl+HtpFmIM01djHrHY/J7punw3kVqeJEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BL+gDRAy5fTUhfuesYTczhh7+K2KRrtW4NJzqAAdmTw=;
 b=jEoc5TWEwx5fybuYsC4hRZR3qyQcFY70v+R077DAOsjpEPCEzuft9fn39Y/4AtbTyZp8aa8UmWWmgYKRveyZevB8DaAsrc9s/zrD/C/BRwE4o2KSC39uGeGBxSoFwXK+B2OI4v0KtI1XyNkmIUdYDE9vnZaOV49y5eKDubYbmrI=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM6PR11MB4705.namprd11.prod.outlook.com (2603:10b6:5:2a9::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Thu, 1 Dec 2022 10:01:48 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 10:01:48 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <ceggers@arri.de>,
        <Tristram.Ha@microchip.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [Patch net-next v1 01/12] net: dsa: microchip: ptp: add the posix
 clock support
Thread-Topic: [Patch net-next v1 01/12] net: dsa: microchip: ptp: add the
 posix clock support
Thread-Index: AQHZAxTYWXj56xDlbku6lHt9xaEY865YLpVggACjGAA=
Date:   Thu, 1 Dec 2022 10:01:48 +0000
Message-ID: <a3bb90c4780d491a7194bbf9cea775be5011c45e.camel@microchip.com>
References: <20221128103227.23171-1-arun.ramadoss@microchip.com>
         <20221128103227.23171-1-arun.ramadoss@microchip.com>
         <20221128103227.23171-2-arun.ramadoss@microchip.com>
         <20221128103227.23171-2-arun.ramadoss@microchip.com>
         <20221201001746.ha72fty32s6ckvu6@skbuf>
In-Reply-To: <20221201001746.ha72fty32s6ckvu6@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|DM6PR11MB4705:EE_
x-ms-office365-filtering-correlation-id: bef11e0e-c008-4424-2e37-08dad3830fd6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bGR5jeClh11M+UbqYwpIUC1It3CIiCo02XpIndYSn9RBchgbY7do8/9Gd9wUWeJ20lv65oFd8UjfkqAFT3n6MO5IdVdEXxGH3fKn3qWkK7tRHtZqflidzhWDxuTGAMoU7ZD8yfXSoZsV/buXNMHMs6jPXZLy3XOlxL8HDpJrtPAN1hxwMSAPrzQrwBP3/zahb0TIccXZ5xpX+va/lUy+wWATUIZB1TOMWM42rc7YYv/WUVbl/C0LfRwT+sOWHPdCNdlUIOVLl+6FBfZSAoVDUwCaqEOuAfA1UGn09g0cQZmtFrbK0uyiB/oDGbmzCKL6LkFxx1Px7ZATLDI3L3y4x7XMLJdVbv6KSHhxBkd4C83q8ma0XSou9aPA97LL2uYJ3tmYbg+FTFHx8WyauXMVY2j0pz/ReZv7odhqtMclwLnnqOmhU45rzOQx2E97/LTVqwNXSmrnWjXaoxN+ToRirR0O7UMC0wcd8chsWmBpD3SgXutj1SGlr2FTyFFFUW/Ag4hCiESInGFlT806QLBNaMx2f+N+yge97RyMh7cNGncteCsL3TeOHzabfqBCkokYbnnJHSUO0STPQ0JzOk9bpSJ9fOjb2bAPtzVMckO3QZkhK3jpORrf12qsBLT3uhI1yVVWVu4/4aoZRjH+JYiwT4ZhdQooQ1HM1VYOYqM7QjtWO8WfIbx+fVauI0wQyNbn16hdRS08gEDCk0H6o7XrMaXB4xqUzbyCOc1hkgXW4Bg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199015)(2906002)(36756003)(64756008)(54906003)(66946007)(66476007)(76116006)(7416002)(6916009)(66446008)(5660300002)(71200400001)(316002)(91956017)(8936002)(6512007)(6486002)(26005)(2616005)(6506007)(4326008)(66556008)(41300700001)(8676002)(186003)(38100700002)(122000001)(86362001)(83380400001)(478600001)(38070700005)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVg5Q1hITGFWeVNIYS9Sd3pnbmIwWWs3T2UvMjMwTjJMRUNGTlJ0dytFcG5s?=
 =?utf-8?B?NkNDN1k4L1VnN29HSStoajRsckdLUWp4T1A1TFp2SGJ2NFJYbHZ1QTdHa1RP?=
 =?utf-8?B?Rk05UzhQbE1DLzc3L2lqelE1dHdqSVF2M0VuTi81cXRvVWZrR2hUT0p1UDFN?=
 =?utf-8?B?TVlZWVk3RFMwNXRxSnphZ0c0a2tuSW5aZzZOYUtFbTZxTEpXTXVaZ1RMRWdO?=
 =?utf-8?B?SlFGeTNZenhrVUx6ekx6UkNObW9heFRMU1U4SHRGdDluM01RZm9DNFZ1NmVn?=
 =?utf-8?B?U1Q5Zk5MZXR6VW9ibno1RFBLNGZKeE5wbWxhSmZUVnJLZzBTOUdhUmJaR3Fq?=
 =?utf-8?B?MFVGbHhKaThsRGZZY1ZFSGVRRis2bVJOTTg0ODllN1Z6eFRFUEV5dGQ2NHpr?=
 =?utf-8?B?YklNOUE3ejRnOWVyWWZuL2owRXhuT0dOUjVQNnd5Y2JPYWJiZHE5UGNBVVZZ?=
 =?utf-8?B?clI0Qkl2SGZSSDgxU1NEdWN2ZldsS05RQkUvWExib1FjdnlsNWorUXJ5Zzdl?=
 =?utf-8?B?SVlUSHhoYVBtK1ZFWUVEcEtndytLWlV6bUloaFV4ZVVmanF5QStsSmdWL1RI?=
 =?utf-8?B?MmhaRDNkMWJ4UkZKVktOclNGQnJPWFpva3I0ZjA5UFY4eTBmb0NWaXIyc3hv?=
 =?utf-8?B?ZWFRVlNoTjI4TmdiVVF4UDROM3YzbW05UTlFNGlSQkprWDZYU3hJcHBYUGty?=
 =?utf-8?B?N3NsOTErNVF2dWZkaStibnJ1cHdRajJESzVqL2hmSHA1WFFHTjkyazlIRVJB?=
 =?utf-8?B?K1MyTVB5VTEyNDVSL2JzS0hHTi8wY1hkd3ZvSk5LL2JIbmlJSzhBVXd6bWtQ?=
 =?utf-8?B?aWU1MkFoZGI5Y0M0d3pkejBWeHZDb1hENUVqdDlPN3pkelhwMDNMREFYU1hP?=
 =?utf-8?B?SXNaejMzTlhYM05JMUtzUXJZaHE1cU8vWWI5ZytvcGNyZHpTSzZKWUNGcEVG?=
 =?utf-8?B?NWZNSWoyM0U3SWN1VGcramlPOU5BeDBwbDRuM3BKQytublNMcW5RMGVsakVM?=
 =?utf-8?B?ZmVxVnA3eTFUU0dvdHBsSHA5TzQxQ2VBT3VCcjg5R3laK3Z2T01rdC9WajZt?=
 =?utf-8?B?LzZZZzZGM21ac0x0dmhCYTBkaHRScFJUZEdjSDJOcUl3Nk1sR3N5ZGc3VUVv?=
 =?utf-8?B?bHFVSWdKRGFPOTl5MFBwSTFKWkJZVVNWMkx6NEt6cGkyN3dGU1hpbkloZHF1?=
 =?utf-8?B?UnJrM3Q0WVorVkppaUhZOFlMOWkxblRzWSswTTQvWVltK04vOC9sMEtwSUl4?=
 =?utf-8?B?TXVKU2JUSjhIaEVkcHhtNVg2OS9keGJyQ3l4RWJlUU9wdGorMmxwMCtqdlJR?=
 =?utf-8?B?R0ZvSXlnVU9UcW5wUXAya0RmcEsrc1lFWkF5MFcwUDFwdGJROVhxYXlqT1Z4?=
 =?utf-8?B?MmxNa2VuZkhsVVF5aUs2d2lmbWZDeGNqaW54Y2UySjhGNStLQUdWS1UvZlFB?=
 =?utf-8?B?eHliTlBwUGZsWmkyemYwQ01IbGlpcE9sYXh3d2Q1bmlaRnM5NUVnSmtoU01V?=
 =?utf-8?B?WWVSRHpRS1NHdWNtOUtabkxqQ0E1YUJQS3IxN0kzYyt0ck54VWJNbG9VNzlt?=
 =?utf-8?B?L3kwMm5iR0JUNVFJeUpDTHlqbStqL2NnUzlJZ1FCbjNVVDNuUnhGT3ZibGZS?=
 =?utf-8?B?ejRZQ2dUVFBGdk1aNlZySkRVVTc3RjN6RzNPMHZSOFNlZVpXVWhJZ3hpaG5h?=
 =?utf-8?B?U3N5UlJqOVVPa0thMUIvYzErN2J3SFdxelBxWXJPV1hTTHM4T2ZLVmVhR2Rq?=
 =?utf-8?B?RFJ2TEZaYkpSdzlVUi9PRGNBdndsYnhCVmQxNVFnV3VpTlEzTHY1Vmc4eHlT?=
 =?utf-8?B?UTVKS3kyc1h2Rko0TGExN3VzUTVjSktqcjhEcHVNTkxWbVU4Ykh6aWZVSjlM?=
 =?utf-8?B?VVlZbkZ5SWNpN2NVRy9xY21VS3QzWHc5UUZSWUV4aDhUc0pzTEpsb1pSZGxE?=
 =?utf-8?B?TXlWdnphdHd4MW1pZ2VIV0sxMkVqUGIwL29MYzBucGFVUFhhSXd6OTFBTjYv?=
 =?utf-8?B?RUE3a3lkVzk3aVNaNSt6d2JwbEdkdmNBa3cwRDNqZXdkaHJ6eG1lVnhhd0Fi?=
 =?utf-8?B?Z2lzZ0lJSU9uM0RpdGVaMnZYWWszVHRWcGdDWHhkTjZOVkp1Ykc5Z2FtWjd5?=
 =?utf-8?B?M0x5cjI0QkFFUFpDZ2c3K3NSVlJYTGVSWm85NEVrQ3k0UytkRkRYVDJkSHk5?=
 =?utf-8?Q?oSF9nNtTklESe+nskIeSJKI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <97456BFE72EF8D4DB785999E66689964@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bef11e0e-c008-4424-2e37-08dad3830fd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2022 10:01:48.5905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yHFi5ueJV3/q07khIR+6JNCQlkRPKBK38X5juQCQuJoaSovfjNQxxzhU/TREK68C62PlC+iALgn8EFJpTlfw6mSgYPI4ZkEJcJBwbsj6XEc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4705
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNCk9uIFRodSwgMjAyMi0xMi0wMSBhdCAwMjoxNyArMDIwMCwgVmxhZGlt
aXIgT2x0ZWFuIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9y
IG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUN
Cj4gDQo+IE9uIE1vbiwgTm92IDI4LCAyMDIyIGF0IDA0OjAyOjE2UE0gKzA1MzAsIEFydW4gUmFt
YWRvc3Mgd3JvdGU6DQo+ID4gRnJvbTogQ2hyaXN0aWFuIEVnZ2VycyA8Y2VnZ2Vyc0BhcnJpLmRl
Pg0KPiA+IA0KPiA+IFRoaXMgcGF0Y2ggaW1wbGVtZW50IHJvdXRpbmVzIChhZGpmaW5lLCBhZGp0
aW1lLCBnZXR0aW1lIGFuZA0KPiA+IHNldHRpbWUpDQo+ID4gZm9yIG1hbmlwdWxhdGluZyB0aGUg
Y2hpcCdzIFBUUCBjbG9jay4gSXQgcmVnaXN0ZXJzIHRoZSBwdHAgY2Fwcw0KPiA+IHRvIHBvc2l4
IGNsb2NrIHJlZ2lzdGVyLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IENocmlzdGlhbiBFZ2dl
cnMgPGNlZ2dlcnNAYXJyaS5kZT4NCj4gPiBDby1kZXZlbG9wZWQtYnk6IEFydW4gUmFtYWRvc3Mg
PGFydW4ucmFtYWRvc3NAbWljcm9jaGlwLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBBcnVuIFJh
bWFkb3NzIDxhcnVuLnJhbWFkb3NzQG1pY3JvY2hpcC5jb20+DQo+ID4gDQo+ID4gLS0tDQo+ID4g
UkZDIHYyIC0+IFBhdGNoIHYxDQo+ID4gLSBSZXBoYXJzZWQgdGhlIEtjb25maWcgaGVscCB0ZXh0
DQo+ID4gLSBSZW1vdmVkIElTX0VSUl9PUl9OVUxMIGNoZWNrIGluIHB0cF9jbG9ja191bnJlZ2lz
dGVyDQo+ID4gLSBBZGQgdGhlIGNoZWNrIGZvciBwdHBfZGF0YS0+Y2xvY2sgaW4ga3N6X3B0cF90
c19pbmZvDQo+ID4gLSBSZW5hbWVkIE1BWF9EUklGVF9DT1JSIHRvIEtTWl9NQVhfRFJJRlRfQ09S
Ug0KPiA+IC0gUmVtb3ZlZCB0aGUgY29tbWVudHMNCj4gPiAtIFZhcmlhYmxlcyBkZWNsYXJhdGlv
biBpbiByZXZlcnNlIGNocmlzdG1hcyB0cmVlDQo+ID4gLSBBZGRlZCB0aGUgcHRwX2Nsb2NrX29w
dGlvbmFsDQo+ID4gLS0tDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2No
aXAva3N6X2NvbW1vbi5oDQo+ID4gYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21t
b24uaA0KPiA+IGluZGV4IGM2NzI2Y2JkNTQ2NS4uNWE2YmZkNDJjNmY5IDEwMDY0NA0KPiA+IC0t
LSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oDQo+ID4gKysrIGIvZHJp
dmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmgNCj4gPiBAQCAtNDQ0LDYgKzQ0Nywx
OSBAQCBzdGF0aWMgaW5saW5lIGludCBrc3pfd3JpdGUzMihzdHJ1Y3QNCj4gPiBrc3pfZGV2aWNl
ICpkZXYsIHUzMiByZWcsIHUzMiB2YWx1ZSkNCj4gPiAgICAgICByZXR1cm4gcmV0Ow0KPiA+ICB9
DQo+ID4gDQo+ID4gK3N0YXRpYyBpbmxpbmUgaW50IGtzel9ybXcxNihzdHJ1Y3Qga3N6X2Rldmlj
ZSAqZGV2LCB1MzIgcmVnLCB1MTYNCj4gPiBtYXNrLA0KPiA+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgdTE2IHZhbHVlKQ0KPiA+ICt7DQo+ID4gKyAgICAgaW50IHJldDsNCj4gPiArDQo+ID4g
KyAgICAgcmV0ID0gcmVnbWFwX3VwZGF0ZV9iaXRzKGRldi0+cmVnbWFwWzFdLCByZWcsIG1hc2ss
IHZhbHVlKTsNCj4gPiArICAgICBpZiAocmV0KQ0KPiA+ICsgICAgICAgICAgICAgZGV2X2Vycihk
ZXYtPmRldiwgImNhbid0IHJtdyAxNmJpdCByZWc6IDB4JXggJXBlXG4iLA0KPiA+IHJlZywNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgRVJSX1BUUihyZXQpKTsNCj4gDQo+IElzIHRoZSBjb2xv
biBtaXNwbGFjZWQ/IFdoYXQgZG8geW91IHdhbnQgdG8gc2F5LCAiY2FuJ3Qgcm13IDE2Yml0DQo+
IHJlZzogMHgwIC1FSU8iLA0KPiBvciAiY2FuJ3Qgcm13IDE2Yml0IHJlZyAweDA6IC1FSU8iPw0K
PiANCj4gUmVtaW5kcyBtZSBvZiBhIGpva2U6DQo+ICJUaGUgaW52ZW50b3Igb2YgdGhlIE94Zm9y
ZCBjb21tYSBoYXMgZGllZC4gVHJpYnV0ZXMgaGF2ZSBiZWVuIGxlZCBieQ0KPiBKLksuIFJvd2xp
bmcsIGhpcyB3aWZlIGFuZCB0aGUgUXVlZW4gb2YgRW5nbGFuZCIuDQoNCkl0cyBhIGNvcHkgcGFz
dGUgcHJvYmxlbS4gSSByZXVzZWQgdGhlIGV4aXNpdGluZyBpbmxpbmUgZnVuY3Rpb25zIGJhc2Vk
DQpvbiBwYXRjaCAqbmV0OiBkc2E6IG1pY3JvY2hpcDogYWRkIHN1cHBvcnQgZm9yIHJlZ21hcF9h
Y2Nlc3NfdGFibGVzKi4gDQpJIHdpbGwgbW92ZSB0aGUgc2VtaWNvbG9uIGFmdGVyIDB4JXg6DQoN
Cj4gDQo+ID4gKw0KPiA+ICsgICAgIHJldHVybiByZXQ7DQo+ID4gK30NCj4gPiArDQo+ID4gIHN0
YXRpYyBpbmxpbmUgaW50IGtzel93cml0ZTY0KHN0cnVjdCBrc3pfZGV2aWNlICpkZXYsIHUzMiBy
ZWcsIHU2NA0KPiA+IHZhbHVlKQ0KPiA+ICB7DQo+ID4gICAgICAgdTMyIHZhbFsyXTsNCj4gPiAr
c3RhdGljIGludCBrc3pfcHRwX3NldHRpbWUoc3RydWN0IHB0cF9jbG9ja19pbmZvICpwdHAsDQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IHN0cnVjdCB0aW1lc3BlYzY0ICp0cykN
Cj4gPiArew0KPiA+ICsgICAgIHN0cnVjdCBrc3pfcHRwX2RhdGEgKnB0cF9kYXRhID0gcHRwX2Nh
cHNfdG9fZGF0YShwdHApOw0KPiA+ICsgICAgIHN0cnVjdCBrc3pfZGV2aWNlICpkZXYgPSBwdHBf
ZGF0YV90b19rc3pfZGV2KHB0cF9kYXRhKTsNCj4gPiArICAgICBpbnQgcmV0Ow0KPiA+ICsNCj4g
PiArICAgICBtdXRleF9sb2NrKCZwdHBfZGF0YS0+bG9jayk7DQo+ID4gKw0KPiA+ICsgICAgIC8q
IFdyaXRlIHRvIHNoYWRvdyByZWdpc3RlcnMgYW5kIExvYWQgUFRQIGNsb2NrICovDQo+ID4gKyAg
ICAgcmV0ID0ga3N6X3dyaXRlMTYoZGV2LCBSRUdfUFRQX1JUQ19TVUJfTkFOT1NFQ19fMiwNCj4g
PiBQVFBfUlRDXzBOUyk7DQo+ID4gKyAgICAgaWYgKHJldCkNCj4gPiArICAgICAgICAgICAgIGdv
dG8gZXJyb3JfcmV0dXJuOw0KPiA+ICsNCj4gPiArICAgICByZXQgPSBrc3pfd3JpdGUzMihkZXYs
IFJFR19QVFBfUlRDX05BTk9TRUMsIHRzLT50dl9uc2VjKTsNCj4gPiArICAgICBpZiAocmV0KQ0K
PiA+ICsgICAgICAgICAgICAgZ290byBlcnJvcl9yZXR1cm47DQo+ID4gKw0KPiArICAgICByZXQg
PSBrc3pfd3JpdGUzMihkZXYsIFJFR19QVFBfUlRDX1NFQywgdHMtPnR2X3NlYyk7DQo+ID4gKyAg
ICAgaWYgKHJldCkNCj4gPiArICAgICAgICAgICAgIGdvdG8gZXJyb3JfcmV0dXJuOw0KPiA+ICsN
Cj4gPiArICAgICByZXQgPSBrc3pfcm13MTYoZGV2LCBSRUdfUFRQX0NMS19DVFJMLCBQVFBfTE9B
RF9USU1FLA0KPiA+IFBUUF9MT0FEX1RJTUUpOw0KPiA+ICsNCj4gPiArZXJyb3JfcmV0dXJuOg0K
PiANCj4gSSB3b3VsZCBhdm9pZCBuYW1pbmcgbGFiZWxzIHdpdGggImVycm9yXyIsIGlmIHRoZSBz
dWNjZXNzIGNvZGUgcGF0aA0KPiBpcw0KPiBhbHNvIGdvaW5nIHRvIHJ1biB0aHJvdWdoIHRoZSBj
b2RlIHRoZXkgcG9pbnQgdG8uICJnb3RvIHVubG9jayINCj4gc291bmRzDQo+IGFib3V0IHJpZ2h0
Lg0KDQpPay4gSSB3aWxsIHJlbmFtZSB0aGUgZ290byBibG9jay4NCg0KPiANCj4gPiArICAgICBt
dXRleF91bmxvY2soJnB0cF9kYXRhLT5sb2NrKTsNCj4gPiArDQo+ID4gKyAgICAgcmV0dXJuIHJl
dDsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGNvbnN0IHN0cnVjdCBwdHBfY2xvY2tfaW5m
byBrc3pfcHRwX2NhcHMgPSB7DQo+ID4gKyAgICAgLm93bmVyICAgICAgICAgID0gVEhJU19NT0RV
TEUsDQo+ID4gKyAgICAgLm5hbWUgICAgICAgICAgID0gIk1pY3JvY2hpcCBDbG9jayIsDQo+ID4g
KyAgICAgLm1heF9hZGogICAgICAgID0gS1NaX01BWF9EUklGVF9DT1JSLA0KPiA+ICsgICAgIC5n
ZXR0aW1lNjQgICAgICA9IGtzel9wdHBfZ2V0dGltZSwNCj4gPiArICAgICAuc2V0dGltZTY0ICAg
ICAgPSBrc3pfcHRwX3NldHRpbWUsDQo+ID4gKyAgICAgLmFkamZpbmUgICAgICAgID0ga3N6X3B0
cF9hZGpmaW5lLA0KPiA+ICsgICAgIC5hZGp0aW1lICAgICAgICA9IGtzel9wdHBfYWRqdGltZSwN
Cj4gPiArfTsNCj4gDQo+IElzIGl0IGEgY29uc2Npb3VzIGRlY2lzaW9uIHRvIGhhdmUgdGhpcyBz
dHJ1Y3R1cmUgZGVjbGFyZWQgaGVyZSBpbg0KPiB0aGUNCj4gLnJvZGF0YSBzZWN0aW9uIChJIHRo
aW5rIHRoYXQncyB3aGVyZSB0aGlzIGdvZXM/KSwgd2hlbiBpdCB3aWxsIG9ubHkNCj4gYmUNCj4g
dXNlZCBhcyBhIGJsdWVwcmludCBmb3IgdGhlIGltcGxpY2l0IG1lbWNweSAoc3RydWN0IGFzc2ln
bm1lbnQpIGluDQo+IGtzel9wdHBfY2xvY2tfcmVnaXN0ZXIoKT8NCg0KVG8gcmVkdWNlIG51bWJl
ciBvZiBsaW5lIGluIHRoZSBrc3pfcHRwX2Nsb2NrX3JlZ2lzdGVyKCksIEkgbW92ZWQgdGhlDQpz
dHJ1Y3R1cmUgaW50aWFsaXphdGlvbiBvdXRzaWRlIG9mIGZ1bmN0aW9uLiBSZWZlcnJlZCBvdGhl
ciBkc2ENCmltcGxlbWVudGF0aW9uIGZvdW5kIHRoaXMgdHlwZSBpbg0KZHJpdmVycy9uZXQvZHNh
L29jZWxvdC9mZWxpeF92c2M5OTU5LmMsIGp1c3QgcmV1c2VkIGl0Lg0KSSBkaWRuJ3QgdGhvdWdo
dCBvZiAucm9kYXRhIHNlY3Rpb24gYW5kIG1lbWNweSBvdmVyaGVhZC4NCg0KSSB3aWxsIG1vdmUg
dGhpcyBpbml0aWFsaXphdGlvbiB3aXRoaW4ga3N6X3B0cF9jbG9ja19yZWdpc3Rlci4NCg0KPiAN
Cj4gSnVzdCBzYXlpbmcgdGhhdCBpdCB3b3VsZCBiZSBwb3NzaWJsZSB0byBpbml0aWFsaXplIHRo
ZSBmaWVsZHMgaW4NCj4gcHRwX2RhdGEtPmNhcHMgZXZlbiB3aXRob3V0IHJlc29ydGluZyB0byBk
ZWNsYXJpbmcgb25lIGV4dHJhDQo+IHN0cnVjdHVyZSwNCj4gd2hpY2ggY29uc3VtZXMgc3BhY2Uu
IEknbGwgbGVhdmUgeW91IGFsb25lIGlmIHlvdSBBQ0sgdGhhdCB5b3Uga25vdw0KPiB5b3VyDQo+
IGFzc2lnbm1lbnQgYmVsb3cgaXMgYSBzdHJ1Y3QgY29weSBhbmQgbm90IGEgcG9pbnRlciBhc3Np
Z25tZW50Lg0KPiANCj4gPiArDQo+ID4gK2ludCBrc3pfcHRwX2Nsb2NrX3JlZ2lzdGVyKHN0cnVj
dCBkc2Ffc3dpdGNoICpkcykNCj4gPiArew0KPiA+ICsgICAgIHN0cnVjdCBrc3pfZGV2aWNlICpk
ZXYgPSBkcy0+cHJpdjsNCj4gPiArICAgICBzdHJ1Y3Qga3N6X3B0cF9kYXRhICpwdHBfZGF0YTsN
Cj4gPiArICAgICBpbnQgcmV0Ow0KPiA+ICsNCj4gPiArICAgICBwdHBfZGF0YSA9ICZkZXYtPnB0
cF9kYXRhOw0KPiA+ICsgICAgIG11dGV4X2luaXQoJnB0cF9kYXRhLT5sb2NrKTsNCj4gPiArDQo+
ID4gKyAgICAgcHRwX2RhdGEtPmNhcHMgPSBrc3pfcHRwX2NhcHM7DQo+ID4gKw0KPiA+ICsgICAg
IHJldCA9IGtzel9wdHBfc3RhcnRfY2xvY2soZGV2KTsNCj4gPiArICAgICBpZiAocmV0KQ0KPiA+
ICsgICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4gPiArDQo+ID4gKyAgICAgcHRwX2RhdGEtPmNs
b2NrID0gcHRwX2Nsb2NrX3JlZ2lzdGVyKCZwdHBfZGF0YS0+Y2FwcywgZGV2LQ0KPiA+ID5kZXYp
Ow0KPiA+ICsgICAgIGlmIChJU19FUlJfT1JfTlVMTChwdHBfZGF0YS0+Y2xvY2spKQ0KPiA+ICsg
ICAgICAgICAgICAgcmV0dXJuIFBUUl9FUlIocHRwX2RhdGEtPmNsb2NrKTsNCj4gPiArDQo+ID4g
KyAgICAgcmV0ID0ga3N6X3JtdzE2KGRldiwgUkVHX1BUUF9NU0dfQ09ORjEsIFBUUF84MDJfMUFT
LA0KPiA+IFBUUF84MDJfMUFTKTsNCj4gPiArICAgICBpZiAocmV0KQ0KPiA+ICsgICAgICAgICAg
ICAgZ290byBlcnJvcl91bnJlZ2lzdGVyX2Nsb2NrOw0KPiANCj4gUmVnaXN0ZXJpbmcgYSBzdHJ1
Y3R1cmUgd2l0aCBhIHN1YnN5c3RlbSBnZW5lcmFsbHkgbWVhbnMgdGhhdCBpdA0KPiBiZWNvbWVz
DQo+IGltbWVkaWF0ZWx5IGFjY2Vzc2libGUgdG8gdXNlciBzcGFjZSwgYW5kIGl0cyAoUE9TSVgg
Y2xvY2spIG9wcyBhcmUNCj4gY2FsbGFibGUuDQo+IA0KPiBZb3UgaGF2ZW4ndCBleHBsYWluZWQg
d2hhdCBQVFBfODAyXzFBUyBkb2VzLCBjb25jcmV0ZWx5LCBldmVuIHRob3VnaA0KPiBJIGFza2Vk
IGZvciBhIGNvbW1lbnQgaW4gdGhlIHByZXZpb3VzIHBhdGNoIHNldC4NCg0KSSBvdmVybG9va2Vk
IHRoZSBjb21tZW50IGluIHRoZSBwcmV2aW91cyBwYXRjaCBzZXQuIENocmlzdGlhbiBhbHNvIGdh
dmUNCm9mZmxpbmUgY29tbWVudCB0aGF0LCB0aGlzIGJpdCBpcyByZXNlcnZlZCBpbiBLU1o5NTYz
IGRhdGFzaGVldC4gDQpUaGlzIGJpdCBzaG91bGQgYmUgc2V0IHdoZW5ldmVyIHdlIG9wZXJhdGUg
aW4gODAyLjFBUyhnUFRQKS4gDQpXaGVuIHRoaXMgYml0LCB0aGVuIGFsbCB0aGUgUFRQIHBhY2tl
dHMgd2lsbCBiZSBmb3J3YXJlZCB0byBob3N0IHBvcnQNCmFuZCBub25lIHRvIG90aGVyIHBvcnRz
Lg0KQWZ0ZXIgY2hhbmdpbmcgbXkgcGF0Y2ggdG8gaW5jbHVkZSAxIHN0ZXAgdGltZXN0YW1waW5n
LCBJIHRoaW5rIGl0DQpzaG91bGQgYmUgc2V0IG9ubHkgZm9yIExBTjkzN3ggMiBzdGVwIG1vZGUu
DQoNCj4gIElzIGl0IG9rYXkgZm9yIHRoZSBQVFANCj4gY2xvY2sgdG8gYmUgcmVnaXN0ZXJlZCB3
aGlsZSB0aGUgUFRQXzgwMl8xQVMgYml0IGhhc24ndCBiZWVuIHlldA0KPiB3cml0dGVuPw0KPiBU
aGUgZmlyc3QgZmV3IG9wZXJhdGlvbnMgbWlnaHQgdGFrZSBwbGFjZSB3aXRoIGl0IHN0aWxsIHVu
c2V0Lg0KPiANCj4gSSBrbm93IHdoYXQgODAyLjFBUyBpcywgSSBqdXN0IGRvbid0IGtub3cgd2hh
dCB0aGUgcmVnaXN0ZXIgZmllbGQNCj4gZG9lcy4NCg0KDQoNCj4gDQo+ID4gKw0KPiA+ICsgICAg
IHJldHVybiAwOw0KPiA+ICsNCj4gPiArZXJyb3JfdW5yZWdpc3Rlcl9jbG9jazoNCj4gPiArICAg
ICBwdHBfY2xvY2tfdW5yZWdpc3RlcihwdHBfZGF0YS0+Y2xvY2spOw0KPiA+ICsgICAgIHJldHVy
biByZXQ7DQo+ID4gK30NCg==
