Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4D533F6C8
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 18:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhCQR2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 13:28:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:35433 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229814AbhCQR1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 13:27:44 -0400
IronPort-SDR: XoefiBwKG9pmJYIpk5cSzHrGPNVnlGb6xExoCcH4XIZE4K8zpOGgexIVS22CZGEUFm2T+sm/eM
 2XhaZCKniBNA==
X-IronPort-AV: E=McAfee;i="6000,8403,9926"; a="189603743"
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="189603743"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 10:27:43 -0700
IronPort-SDR: o6mkpN5lYIkPifs/AvqLZfKn5UL7o1h+TAiN8dJZXVlJs/z6x3fL9iORAbOKxL88eizeyQO9Jl
 AeAUgYC/RbUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="602314323"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 17 Mar 2021 10:27:43 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 17 Mar 2021 10:27:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 17 Mar 2021 10:27:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 17 Mar 2021 10:27:42 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 17 Mar 2021 10:27:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMKNVkfuxuQnCU6gpydKBTmhDRkchGoXiY+9oI9VPtAi3aDP8nb4pyreUrCXFuKhypgOBBVoeCk+WqQcuMqRq2NPJbg7Yum5Am4OtwAdxf8V6jbdMQIUxTOPOIqsn1kO5uX7iVqcv/i6gjGRwWqDnlm+ad1yy6qmC6Mdu2jZwhmnDKyTpbm0cWefTW2HPtu5JUjHQg7PYAW/xjWj3AgfVFpWbJ40nCh2Crvkh6+iMN0cRmevj64kiUv2PUbNVUDrv2cXGDBK7cHVxtqh3cIHOGtlkKucnE5m46yxLn5vNRvdOgJ5COd+vYXYvgBKGliH2EnTsei84HBXigQp+wegLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zEFGyjRmwigEUFMKDrWAmteLaCkqTzGdwKMWQ+p7U3U=;
 b=g/+DHY/dU+Ga3J0q5rGPV+kPBP40Z/lQO4niy7/CkzlCnWu0Q36Cf25PzkrPd5/O4+7L2W8TwDS7jisDxCE2cjzwNLR36hzinLYnv6J3Oqyzn62oXqJh0mPfC+6Iv5Oir2xN6r1kQAiYCRiF5UH6oin0/c/0QgbQtTqDFrt5rqdHlaOHc/Jkrf8HTYg1QnWp7BYlpRppN8qdsYr2ewpV8HaaQQqPRa36AJgpZszqQtsC18TAKDy5aU266eIfxjAQfjwmwafuEP1ut7iCGWG7uJx+v7pxZNjZ6jml6YJITPNgdPDuZSrD0PqWWIhvHdVqEmcKZaZVU3J6IWTyQglqOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zEFGyjRmwigEUFMKDrWAmteLaCkqTzGdwKMWQ+p7U3U=;
 b=P7qXNdGBfNH4V+VG1iKL1Ln7xzwLF7AwGybbhgLhh2nZN1GnJFRQRMifL90f7bTFkHJ16CFVGVQ8H/GeYW0+M9AgENXokZicJ5kWfLpY+uWHgRbCBHjgxG3o4UI0q8gQYXpdl4eAG519sTyZYrxSWzzUACKsoLmgg9URb190r1M=
Received: from DM6PR11MB3113.namprd11.prod.outlook.com (2603:10b6:5:69::19) by
 DM6PR11MB4706.namprd11.prod.outlook.com (2603:10b6:5:2a5::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18; Wed, 17 Mar 2021 17:27:40 +0000
Received: from DM6PR11MB3113.namprd11.prod.outlook.com
 ([fe80::d914:33fa:d174:7c52]) by DM6PR11MB3113.namprd11.prod.outlook.com
 ([fe80::d914:33fa:d174:7c52%6]) with mapi id 15.20.3955.018; Wed, 17 Mar 2021
 17:27:40 +0000
From:   "Laba, SlawomirX" <slawomirx.laba@intel.com>
To:     Stefan Assmann <sassmann@kpanic.de>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Yang, Lihong" <lihong.yang@intel.com>,
        "Nunley, Nicholas D" <nicholas.d.nunley@intel.com>
Subject: RE: [PATCH] iavf: fix locking of critical sections
Thread-Topic: [PATCH] iavf: fix locking of critical sections
Thread-Index: AQHXGkt2qKjHb8Aif0ag/sNf79F0m6qG2x+AgAADegCAADLUgIAAGgIAgACkIoCAAKAvcA==
Date:   Wed, 17 Mar 2021 17:27:38 +0000
Message-ID: <DM6PR11MB3113AB6CE1D93EF28B3A7345876A9@DM6PR11MB3113.namprd11.prod.outlook.com>
References: <20210316100141.53551-1-sassmann@kpanic.de>
 <20210316101443.56b87cf6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <44b3f5f0-93f8-29e2-ab21-5fd7cc14c755@kpanic.de>
 <20210316132905.5d0f90dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210316150210.00007249@intel.com>
 <3a4078fe-0be5-745c-91a3-ed83d4dc372f@kpanic.de>
In-Reply-To: <3a4078fe-0be5-745c-91a3-ed83d4dc372f@kpanic.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kpanic.de; dkim=none (message not signed)
 header.d=none;kpanic.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.191.220.83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a56363e-a16f-4dfb-4053-08d8e969f756
x-ms-traffictypediagnostic: DM6PR11MB4706:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4706F4F4789AAF404425EF98876A9@DM6PR11MB4706.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6szj9rW4/Jyh71wbMPdhLjcjQ4csx19LJWOIXbQBtlLuax2zOybjbkmzns5otaDfgepRIz+ItKhNocIFeE8q0zo3e0FvHh01e9CN15QO8OxDKtrh5j/2LcBZSfhanjIrV5oPlaB6u0ynaqEU4qXAepLuUSjJoyK87lGOhK5+6FgeuVLfuw9D1286/dLW5+fr6SZqIY1gEljWmhpFbocmw1o1uww5PEWVto3d+32DDLEb+2bMwp+XFdeZyYQKRxw3pbIyx6uTffKV164wAc7abAdXK0medUvUGk4Xyb39FXH7s0szC2rdJsxzqcW0j1J7yjKMMt0ObeMuAbNXOIvAw7bxfRD+DZ2Fkeif9xkjNzE9/B8Xaf4uh7o/P4gxYZrOQ5gfemsEXQghLXs7GpbcTd1P3/vIRjDV5I3VIS7SZryxV4OhtQqfnq41vpTy0yLd9A4FVsfPDHKBmjbfqrV/FjyewReS6Fu2mXMrcGe1NgI4MqscnoTc1Q837sMdJTyYGVk8oLK321wqcx5M0x0Bc5n6wQRDFP0xFk32bVylngfJHQL6OnflFlTqIYupmt2e
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3113.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(396003)(366004)(376002)(26005)(5660300002)(83380400001)(6506007)(53546011)(71200400001)(52536014)(186003)(7696005)(86362001)(107886003)(66556008)(76116006)(64756008)(8936002)(66946007)(54906003)(55016002)(2906002)(66446008)(9686003)(66476007)(33656002)(4326008)(110136005)(8676002)(316002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UFExTkFtTjA3QWxTSjM3VFVyUEpmelV4UlpLamFpdFRuQ1puTzB1czJpRjVL?=
 =?utf-8?B?ZVVWSHZUQ05kT1pBN21hbzZyWVIxamluVHJUdUNHa2l0MmVSeE9JdDIzM01X?=
 =?utf-8?B?SVFLcjh6SXVvbG40UzhrSjVzN1NsSk5GN3hRQWlFYXdQQjQwMytib1ovMVB3?=
 =?utf-8?B?UElDRmVOVzBLVDBCVWx3TnFqZWI3TVd3N3dsbFA1bXdYbTNLVXFtc2FpcENx?=
 =?utf-8?B?VyttQ0pEVWJlZTZUcWFjWWpaeFNaOFYzTHZWL2V2YjIwUU9NUEtzWjVEYmY0?=
 =?utf-8?B?QkhOOEUzQkJOeVVDRWh1Z2tXREtiTjVzYzB6K0VBRzdaWllCY1pzSktsSjNz?=
 =?utf-8?B?dnRIK3VVckdUbEJYMnpmWi9TRjliYnVzU3VtM0ViTTBkd3RZdTdNdUxSVUtG?=
 =?utf-8?B?VE01RE1qWHRmeW01K2h0ZU93RS9xT1ZKQlFodk8zREVWVys5a2cxM1preGsv?=
 =?utf-8?B?aS9ib0JrVTBLUW1NS3Z1VzB0SW5qOEdzeElqMnRQTzZaUTBSTE1JVkxZVUZI?=
 =?utf-8?B?U3VaVWJqVXRQem1sZW9BdFpIQW9SQmxxd2J2MDlXQ1d2SlNtYmF0S3VxZzkr?=
 =?utf-8?B?L09jTFZzWVJWSkVIQktwODd2MzRoSVZSWG9abytLZ1MxK2k4S1hWQlloSTVl?=
 =?utf-8?B?OVJqOFF1VFRvSnI4QU5nZWZHamNzcHJHS1o0Rlg2REJmaldSRXVyY01sR3BG?=
 =?utf-8?B?ZkpnbW1WYi9hazRVeVUwcGdZTE51dC9Cc28zZzdxbENOMEt0blYrcTh5R0Yx?=
 =?utf-8?B?Z1RuLzdLTFNwc003eHJRaG1xbDBPSUU3aE1uTU9UcFZORktUdjNNdHpwUjFu?=
 =?utf-8?B?QUl3NXZFWWxuKzRjZi9aVzA3aUxvVWJkMFB0Q0ZRcXk2QVZOQ3h1VUNQakxQ?=
 =?utf-8?B?ZitZZENwRXMwMlJKM1NURFY0U2hOV1M1OHk5eG9sZnd3WXZ1RTI5UzdxM3pW?=
 =?utf-8?B?eW1rWWh5c3lNODlHSTBUZE11L0YxcHF6OWYrblNSdnY5NDczc2dCNitOSFJu?=
 =?utf-8?B?Q0wxaHptTmZFVHMwck1ZbFNTVmR0RjlYRGRtVXFiamlyaWJlc0h4d0ZUTXh0?=
 =?utf-8?B?S24ybno3cmtxQXVZQWpnTEJaZkpBWVgwdWY0amJ2VGN4blROZ0VRZHhFV2Rj?=
 =?utf-8?B?U3lORHpubzFUT3Y1MlpPQlBWTnE5ek5EdEk5U2M4aVhHeUl4SW9zaHpRL3l4?=
 =?utf-8?B?REkzVjcxZkRpWGppeXliSnFrbERGa1J1d0s4ZzNQUnkrMThHcFNld3Bzdzhw?=
 =?utf-8?B?b0U3ZGRUZGRIaVZIS0xSZ29ZdVlleW1rekZ0OXZjSE1vdDRBeG1aSlQ4aHZa?=
 =?utf-8?B?bFdrb1hQSzRTTHgwZVZwWW92RE1rUmVZWlFOZ2F5U2RPMlppWXFPaHJKSHdz?=
 =?utf-8?B?RXRuRzd5Mjl4bUwzbTI5cnFhSUFTN1lzbkt6a3d1S3VNQTNMVXhwZmtrZko4?=
 =?utf-8?B?SStBZlVuMGF5dEpTem4xdVZlNk9UY2p1ZTN4NXR1MUNvait2Wms4TXAyMEZL?=
 =?utf-8?B?N1hsUHJnRUZPREFXeGdPblF1TWRmcll4czYwOFlsZ21lU0FqRGxxSmtpcE9L?=
 =?utf-8?B?ZnhEWXl1Q0FlaGNaTlp3SkhMSmp1dFMwZDR0bG1WZjFKSFJCVWZra2xtNENE?=
 =?utf-8?B?eUZRQlFwaTBNWnVSUjI2ck1WcitHWTRoOXZxWStwQmlNcURyY2YxT2FNNjU2?=
 =?utf-8?B?dmt5ckYrbFVydHlEV1hGSnFEWElDZ3JvNERFV0J6cWNDeVpKbHQwWFEyNDlh?=
 =?utf-8?Q?t2LhdAURW6sBh2ysiwhFUEo871qGOUduYH2BdMl?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3113.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a56363e-a16f-4dfb-4053-08d8e969f756
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 17:27:40.2038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4x7hdMreH3q0S/kdPocLanKy025rLmk97OkKy4+zuQfM/7wezpmn50525xxHf3/DKS4IR7wupDcq0mlmz80CXuaM0TxKEDmeKz6n3GY8+is=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4706
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2Ugd2VyZSBkaXNjdXNzaW5nIGludHJvZHVjaW5nIG11dGV4ZXMgaW4gdGhvc2UgY3JpdGljYWwg
c3BvdHMgZm9yIGEgbG9uZyB0aW1lIG5vdyAoaW4gbXkgdGVhbSkuDQpTdGVmYW4sIGlmIHlvdSBm
aW5kIHRpbWUsIHlvdSBhcmUgbW9zdCB3ZWxjb21lIHRvIG9mZmVyIHlvdXIgc29sdXRpb24gd2l0
aCBtdXRleGVzLg0KDQpTbGF3ZWsNCg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJv
bTogU3RlZmFuIEFzc21hbm4gPHNhc3NtYW5uQGtwYW5pYy5kZT4gDQpTZW50OiBXZWRuZXNkYXks
IE1hcmNoIDE3LCAyMDIxIDg6NTAgQU0NClRvOiBCcmFuZGVidXJnLCBKZXNzZSA8amVzc2UuYnJh
bmRlYnVyZ0BpbnRlbC5jb20+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KQ2M6
IGludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
OyBOZ3V5ZW4sIEFudGhvbnkgTCA8YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+OyBZYW5nLCBM
aWhvbmcgPGxpaG9uZy55YW5nQGludGVsLmNvbT47IExhYmEsIFNsYXdvbWlyWCA8c2xhd29taXJ4
LmxhYmFAaW50ZWwuY29tPjsgTnVubGV5LCBOaWNob2xhcyBEIDxuaWNob2xhcy5kLm51bmxleUBp
bnRlbC5jb20+DQpTdWJqZWN0OiBSZTogW1BBVENIXSBpYXZmOiBmaXggbG9ja2luZyBvZiBjcml0
aWNhbCBzZWN0aW9ucw0KDQpPbiAxNi4wMy4yMSAyMzowMiwgSmVzc2UgQnJhbmRlYnVyZyB3cm90
ZToNCj4gSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+Pj4+IEkgcGVyc29uYWxseSB0aGluayB0aGF0
IHRoZSBvdmVydXNlIG9mIGZsYWdzIGluIEludGVsIGRyaXZlcnMgDQo+Pj4+IGJyaW5ncyBub3Ro
aW5nIGJ1dCB0cm91YmxlLiBBdCB3aGljaCBwb2ludCBkb2VzIGl0IG1ha2Ugc2Vuc2UgdG8gDQo+
Pj4+IGp1c3QgYWRkIGEgbG9jayAvIHNlbWFwaG9yZSBoZXJlIHJhdGhlciB0aGFuIG9wZW4gY29k
ZSBhbGwgdGhpcyANCj4+Pj4gd2l0aCBubyBjbGVhciBzZW1hbnRpY3M/IE5vIGNvZGUgc2VlbXMg
dG8ganVzdCB0ZXN0IHRoZSANCj4+Pj4gX19JQVZGX0lOX0NSSVRJQ0FMX1RBU0sgZmxhZywgYWxs
IHRoZSB1c2VzIGxvb2sgbGlrZSBwb29yIG1hbidzIA0KPj4+PiBsb2NraW5nIGF0IGEgcXVpY2sg
Z3JlcC4gV2hhdCBhbSBJIG1pc3Npbmc/DQo+Pj4NCj4+PiBJIGFncmVlIHdpdGggeW91IHRoYXQg
dGhlIGxvY2tpbmcgY291bGQgYmUgZG9uZSB3aXRoIG90aGVyIGxvY2tpbmcgDQo+Pj4gbWVjaGFu
aXNtcyBqdXN0IGFzIGdvb2QuIEkgZGlkbid0IGludmVudCB0aGUgY3VycmVudCBtZXRob2Qgc28g
SSdsbCANCj4+PiBsZXQgSW50ZWwgY29tbWVudCBvbiB0aGF0IHBhcnQsIGJ1dCBJJ2QgbGlrZSB0
byBwb2ludCBvdXQgdGhhdCB3aGF0IA0KPj4+IEknbSBtYWtpbmcgdXNlIG9mIGlzIGZpeGluZyB3
aGF0IGlzIGN1cnJlbnRseSBpbiB0aGUgZHJpdmVyLg0KPj4NCj4+IFJpZ2h0LCBJIHNob3VsZCBo
YXZlIG1hZGUgaXQgY2xlYXIgdGhhdCBJIGRvbid0IGJsYW1lIHlvdSBmb3IgdGhlIA0KPj4gY3Vy
cmVudCBzdGF0ZSBvZiB0aGluZ3MuIFdvdWxkIHlvdSBtaW5kIHNlbmRpbmcgYSBwYXRjaCBvbiB0
b3Agb2YgDQo+PiB0aGlzIG9uZSB0byBkbyBhIGNvbnZlcnNpb24gdG8gYSBzZW1hcGhvcmU/DQoN
ClN1cmUsIEknbSBoYXBweSB0byBoZWxwIHdvcmtpbmcgb24gdGhlIGNvbnZlcnNpb24gb25jZSB0
aGUgY3VycmVudCBpc3N1ZSBpcyByZXNvbHZlZC4NCg0KPj4gSW50ZWwgZm9sa3MgYW55IG9waW5p
b25zPw0KPiANCj4gSSBrbm93IFNsYXdvbWlyIGhhcyBiZWVuIHdvcmtpbmcgY2xvc2VseSB3aXRo
IFN0ZWZhbiBvbiBmaWd1cmluZyBvdXQgDQo+IHRoZSByaWdodCB3YXlzIHRvIGZpeCB0aGlzIGNv
ZGUuICBIb3BlZnVsbHkgaGUgY2FuIHNwZWFrIGZvciBoaW1zZWxmLCANCj4gYnV0IEkga25vdyBo
ZSdzIG9uIEV1cm9wZSB0aW1lLg0KPiANCj4gQXMgZm9yIGNvbnZlcnNpb24gdG8gbXV0ZXhlcyBJ
J20gYSBiaWcgZmFuLCBhbmQgYXMgbG9uZyBhcyB3ZSBkb24ndCANCj4gaGF2ZSB0b28gbWFueSBj
b2xsaXNpb25zIHdpdGggdGhlIFJUTkwgbG9jayBJIHRoaW5rIGl0J3MgYSByZWFzb25hYmxlIA0K
PiBpbXByb3ZlbWVudCB0byBkbywgYW5kIGlmIFN0ZWZhbiBkb2Vzbid0IHdhbnQgdG8gd29yayBv
biBpdCwgd2UgY2FuIA0KPiBsb29rIGludG8gd2hldGhlciBTbGF3b21pciBvciBoaXMgdGVhbSBj
YW4uDQoNCkknZCBhcHByZWNpYXRlIHRvIGJlIGludm9sdmVkLg0KVGhhbmtzIQ0KDQogIFN0ZWZh
bg0K
