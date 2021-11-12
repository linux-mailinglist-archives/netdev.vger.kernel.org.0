Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D6444E3B7
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 10:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbhKLJVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 04:21:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:15068 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234614AbhKLJVP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 04:21:15 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="232948553"
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="232948553"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 01:18:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="546879411"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 12 Nov 2021 01:18:23 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 12 Nov 2021 01:18:23 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 12 Nov 2021 01:18:23 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 12 Nov 2021 01:18:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nogSrftG18lh4uaAZWS17bHNiIJyXu9ekwl7JAfC+MgbOHAE2by0CLjYH+lhVItFmgUV768zFzKjP3eYMlwTHu3dA/Gb5t7yNjdAOQMvGXsMq8R8q3bfj325zs+Uj7IvNeIDkUIc8R693gDhTWjOfqaa/O1EuP3UmbuthLkMysxZH1gUJqZER0PfL1Nx27df+FQHq25A1yiX1kVSsao1Y0LzAmr6B0ZqP/yF97CwjlplrFo2d+RHEvJSb37yEX1N3myjKnW8q78gqeg/EoKyNn6SiE6CT7RvrrqYXvbEhkorINDRmVhMhyWIi7dON0RA98FTydmUwF4aXdVQX2UMEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eKsSqQ58mMKPWH2H4+rsyy9NZ+VuZI1WUt9j13CPdlU=;
 b=QYIYK+BPN9WQBu/th2I/VKspmv+DCpdgUCP2RsBFsFt+hwq42iYDRAGGpLGQjrF6xB/2t4Ww6207WGk3DbFXY7fZzse08kLv4XrLukpiFZ47CgkerN1Ol6eO3igZ/yG7Z9p36Y7APyU602Zi2Gr67Vhn2He4ee8c2iQ8Q7jOBEdwqJjPScjK41PNPtSy+a3UDy02mNUEWn9v/WqBhnAeXRb8Wp76/cEe+ywss6ExHxfxKjjbsIiLbfbryMvFDSqMkrnIMfA/OJPEXz+PnYnz2pEFu2bzY6Z9geZBSEPTc3Cm0aQ5DGmsY70Os6ilJn53c4zcPzPdJ+x0CvH82YXfCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eKsSqQ58mMKPWH2H4+rsyy9NZ+VuZI1WUt9j13CPdlU=;
 b=dxwIrbAGsW1IR63DP/FUikkDAP2oQu/3bP+GJe5doFaNX6h3Q16CMLqmcGkTzCdPURGDqPT9R+1+tpr8bXBgzwelmxZltCYeMjYAb/fLMBNQXBgoidZMqb9j8PIMp/b0O02fL38aRgN0C9VTZXqbMj6AF7n5fM/kdoyTftlsOko=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BYAPR11MB2648.namprd11.prod.outlook.com (2603:10b6:a02:c7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25; Fri, 12 Nov
 2021 09:17:48 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::e559:d4e6:163c:b1ae]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::e559:d4e6:163c:b1ae%6]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 09:17:48 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "nathan@kernel.org" <nathan@kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "arnd@kernel.org" <arnd@kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     lkp <lkp@intel.com>, "Baruch, Yaara" <yaara.baruch@intel.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Gottlieb, Matti" <matti.gottlieb@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH] [v2] iwlwifi: pcie: fix constant-conversion warning
Thread-Topic: [PATCH] [v2] iwlwifi: pcie: fix constant-conversion warning
Thread-Index: AQHX1s46i2BvTzCWEECZKu6gDVSGCqv/nrIA
Date:   Fri, 12 Nov 2021 09:17:48 +0000
Message-ID: <f833039cd67516f448667a4ca525ebe31cc43329.camel@intel.com>
References: <20211111073145.2504032-1-arnd@kernel.org>
In-Reply-To: <20211111073145.2504032-1-arnd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74b6c51a-9dcf-45b2-32de-08d9a5bd4b80
x-ms-traffictypediagnostic: BYAPR11MB2648:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR11MB264847CB85847F9379C3060890959@BYAPR11MB2648.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8PTnp22Sr00RVJJCI/SmnTlBoITQ2W6L10gH8gwXtExiftfvudK0q2GHzyyfJwFJE/KqboBiPSaen9qZ6KkquMQu8XHlhmbDtqUFbIhfVCpfTM75h9M4kIwYULqv/oqSGPK6DXbkZUdpROnjODfV9IGffkzsOraV6SfMZp1CYobFcJfsbrdq6EA+CB2xV6osBEYfPZ0tXDXVKNsUg2TmNzJM0jtPxRe655XnppB8WiYzcRwxuQOXfGYLqbFQcnds3NIRkwSqRAwD4XSVp7PeqBpHm9AB+FFNHLyLzAl1nDTSZgS/vtHs4e/JyazVjKO4cSmCLrMI9zSeF2u3k33ymKnGZXzItwHiJdEep3q6Oif4h2LqBWAi68aQB0gmgKVigpqQQu62xLDli8apO9I5hGbAyCxGTKkcppGk7fZIgTC1qD6kHwnjrjRK73b88yMqPmDW3Jtoxnw6/JndxFQ9Wj0Mx9N4xnuT/9ni4oTrEdYGNOuz3oyk3Lzd7OfPBuv8GGjqWxH9/l+OL6lqAX99JN3gWNi8wBPhUrfrlAgSA/mNKYFG6amvhnfku01bKjvhuOWX8K51MFgqxHnziK6PaB/AVFYbg9+wHHjeIHZqJMOCzHlZsGWl7zQOkm5hFRr+lyhJXT3yz3hXmlZbdKeWw7NQn1h00mxhYbIh8naNStgppw+XM4n0pnIzvt41q2rzQyAf3KgAjwNkED9m65mdxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2616005)(107886003)(38100700002)(8676002)(82960400001)(6506007)(6512007)(36756003)(2906002)(4001150100001)(6486002)(86362001)(26005)(7416002)(66476007)(66556008)(64756008)(8936002)(186003)(66446008)(76116006)(91956017)(54906003)(110136005)(508600001)(38070700005)(66946007)(71200400001)(316002)(122000001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VFhlOVRhazg4ZHhUVnFZS2Q4aG44akJmbXY3OGg4YklkRmhva29SeGVLUjhO?=
 =?utf-8?B?anAyRzBYZEFlaWJoTWhTVlpqN3ZKVHI3ZXVRWFZQNmRIOXQzYUI3QzEvbkl3?=
 =?utf-8?B?VTZmZ1RrQjdtOTZYZmpMcEtEd1crc1h1cWJPbXl0V01DVlE3UVJlcWVlb2xz?=
 =?utf-8?B?M1FxQTFFa0Z3aVVQcmpIelNBYnkvd3JzbGNXMldzRFB2UDBCZ0I0Vy9Uc3hn?=
 =?utf-8?B?UGVOZ0NFVHdJWi9vaDlUSkp4VTA0QTFWa2pDUlJwVEkxREp5OG9FWDFucGdK?=
 =?utf-8?B?eUlzZUlYdlRvbjIvNWU3emQ0S0oxWHJTQjBMbm9jeXhhTElmRFNZd25KN251?=
 =?utf-8?B?SDdHb0F2UGpXVTZKUFE2dDdBbTZHekF0eTJDalZaQkMrak54RHh2WU1ySkhG?=
 =?utf-8?B?ZXZwWXR3RUVkT1VieHdIMGs3YUlpcmp1bTUvUnNZV1V2ZUdrcmxNbFE1T2lW?=
 =?utf-8?B?VkErQ0pKNWtuWHVMOGlFaHRkWFcwNTFJMFNpTFNBUEUvNEFWNTdneVFxWlVw?=
 =?utf-8?B?WWtMY3FnSnJMdytCUEZ1NElqd0hQOHRZb2U1ZWc3MlNBU1lLQ2VENU1lVGp0?=
 =?utf-8?B?cGNuZFJ3RVdFclM0RHpVdDh4Z3hBYmd1a0hzTklTa3U5ZUtUekJ3UGwrNFl2?=
 =?utf-8?B?bXhoYkxRVXBkektTS2pySkRuaWVOZWEvUEQ0aGNldldjd0xtU2xxa2JCbEhG?=
 =?utf-8?B?YjlkR0NhSko1U3ZmVDhpcnR5L3VyL0p1RldXVmVrUm5VNUlXZG9RL21UTHp2?=
 =?utf-8?B?Q0lnaHVXN1grdUxDM0pHNjAwWUZ6SURWUktmVjJ2SWJoeTMyYnc1WFBibU5U?=
 =?utf-8?B?TmIzbkJrNFFTdmVudmpVYnQxOXd2ZFVJRzRET1dORERSTnVpb2psYTFxNTZl?=
 =?utf-8?B?M241QnRHamFBWk52cmFZOE5MTVFYaEdsYTdHVmwwU0FESW9EbEJndm1UeFgy?=
 =?utf-8?B?TG5YcVRiZ1RiOW5JZ0dueGU4TFlGS1ZXMDBNdHlBU0RoTUtzVWlpNW85dDZK?=
 =?utf-8?B?WmdWZmRPUnBEK1lIOU9WZk1FaEFUOTBTRmtMcWE3YlY1UllGd1hyNnYvN3py?=
 =?utf-8?B?L0lCclY5cXRkUEFRVHA0VTFCU0JHM3RWS1VGRWJqZSszc2pqQUFhV0hzeWdV?=
 =?utf-8?B?VEhsanlmWmRYY2E2c3pIOWhhSysxWVV5STMwbkE0cjVVVDFpWnpEbXRTbVk3?=
 =?utf-8?B?VlJwcnNmREZ1SldGSUJaUFF5T3VhQVhOTEZIelduNDdVNGhuWlQyRnJRaXVX?=
 =?utf-8?B?ait2Smc4SCsyaGhYUkpOQ0tudGVlTk9wd0RnSVFNL1JEbGVueU94UXNjd2ty?=
 =?utf-8?B?b0tWR2xjR0FIMm9rRDBuNzU4cDBOR0g0SmJrSkRUbzNXS0M5WGlmbGNHOFNo?=
 =?utf-8?B?LzdIeDRMcld6eHRDSmJ4Y1h6RGJ1U1Zmb08rQk5RSHh5UERrT1drZHJ2bjJs?=
 =?utf-8?B?VnpyYkhkbElSZmtKV3I5S09POGsyZnFZclFZMk9TamxmblU5eVBuMVJBMGpx?=
 =?utf-8?B?TUtUTWMrNlV3QkpEMHRyK0VLb3lVS20rYk5IK3d2aHJUOXpHSHljTXlGWFA1?=
 =?utf-8?B?Wi8wNWMrVkxIMlZzbGI5R1hMdWdLYlBLUG5oZE50Kzh1aVVxNkpNc0Rndzl5?=
 =?utf-8?B?Rk9weTdwR25vOUxPVkN6TlUzWGl4UElnejBnT0p6cVJmaFdQRDZrTlVKcnRy?=
 =?utf-8?B?NTJ3QUJ4RmdQK3RxYVM1cVp6bW1lK2RwelJHdDZ6N1VzSmltd3V3WUdlOVBB?=
 =?utf-8?B?WU5RSjlLMUxiWXN2MmVZY2h3K0FHMEpwdU9FY2oyelBBaWx4QUVDbHNzUWxx?=
 =?utf-8?B?SWkyeGI0TzIxQmd2TThIVFE1VGlvUFVYcW1YLzRMV284dXRwMXEyVWNZZndY?=
 =?utf-8?B?NDhob0pFLzhFR0NqNXYzOWtrcVJsT05lWm8ycDl1RHZ3SUxpeEd3T3FacHNS?=
 =?utf-8?B?V1hYYXBNeHdFZzM0V0ZPcmRXalpWN0JNMWdJYktMcHlOWGd3RzJ2TGlCUjIv?=
 =?utf-8?B?R2xjRllRblloaSs5ajhWMnlWdmFVSXc4dUNzbXJMRnF3YjNvNDdXbHNwdmlP?=
 =?utf-8?B?RkdITTdPaDhZWXBYSE5xNVlXUUF2MDR5UUN4ZU9ibU5pUldac00yYlcybjVG?=
 =?utf-8?B?OUhIdzVQS2FCWGUzTjdzNmRvVlRzL0lSZysvS2pibHdvR2kzZktwbVpZT1Q1?=
 =?utf-8?B?VDVlZmZub0dkOEtINzl5dFQrRWlvcEpYd0FlSlY3SEZIb2dmN0VIK0phOXlQ?=
 =?utf-8?Q?9pjP0ifk3bmuP7OzZzbYgROiL+JkKqIqfPuIGD+TyQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <37633820F120D14A86B4B6F6D3D7E606@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74b6c51a-9dcf-45b2-32de-08d9a5bd4b80
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2021 09:17:48.1951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6v9NliYbcn2xkWG8T6UrUMuaSqcmCuhfffU9chrSaejhKNFMBmI/n/jkqO1Uis9i6YZW/DDSFvRwSEAV4JfrwV5c599vlI+m/DF18352Shw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2648
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTExLTExIGF0IDA4OjMxICswMTAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBGcm9tOiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiANCj4gY2xhbmcgcG9pbnRz
IG91dCBhIHBvdGVudGlhbCBpc3N1ZSB3aXRoIGludGVnZXIgb3ZlcmZsb3cgd2hlbg0KPiB0aGUg
aXdsX2Rldl9pbmZvX3RhYmxlW10gYXJyYXkgaXMgZW1wdHk6DQo+IA0KPiBkcml2ZXJzL25ldC93
aXJlbGVzcy9pbnRlbC9pd2x3aWZpL3BjaWUvZHJ2LmM6MTM0NDo0MjogZXJyb3I6IGltcGxpY2l0
IGNvbnZlcnNpb24gZnJvbSAndW5zaWduZWQgbG9uZycgdG8gJ2ludCcgY2hhbmdlcyB2YWx1ZSBm
cm9tIDE4NDQ2NzQ0MDczNzA5NTUxNjE1IHRvIC0xIFstV2Vycm9yLC1XY29uc3RhbnQtY29udmVy
c2lvbl0NCj4gICAgICAgICBmb3IgKGkgPSBBUlJBWV9TSVpFKGl3bF9kZXZfaW5mb190YWJsZSkg
LSAxOyBpID49IDA7IGktLSkgew0KPiAgICAgICAgICAgICAgICB+IH5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5efn4NCj4gDQo+IFRoaXMgaXMgc3RpbGwgaGFybWxlc3MsIGFzIHRoZSBs
b29wIGNvcnJlY3RseSB0ZXJtaW5hdGVzLCBidXQgYWRkaW5nDQo+IGFuIGV4dHJhIHJhbmdlIGNo
ZWNrIG1ha2VzIHRoYXQgb2J2aW91cyB0byBib3RoIHJlYWRlcnMgYW5kIHRvIHRoZQ0KPiBjb21w
aWxlci4NCj4gDQo+IEZpeGVzOiAzZjczMjA0MjhmYTQgKCJpd2x3aWZpOiBwY2llOiBzaW1wbGlm
eSBpd2xfcGNpX2ZpbmRfZGV2X2luZm8oKSIpDQo+IFJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCBy
b2JvdCA8bGtwQGludGVsLmNvbT4NCj4gQ2M6IE5pY2sgRGVzYXVsbmllcnMgPG5kZXNhdWxuaWVy
c0Bnb29nbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRi
LmRlPg0KPiAtLS0NCj4gQ2hhbmdlcyBpbiB2MjoNCj4gLSByZXBsYWNlIGludCBjYXN0IHdpdGgg
YSByYW5nZSBjaGVjaw0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdp
ZmkvcGNpZS9kcnYuYyB8IDMgKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCsp
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9w
Y2llL2Rydi5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9wY2llL2Rydi5j
DQo+IGluZGV4IGM1NzRmMDQxZjA5Ni4uZmNkYTc2MDMwMjRiIDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL3BjaWUvZHJ2LmMNCj4gKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9wY2llL2Rydi5jDQo+IEBAIC0xMzQxLDYgKzEz
NDEsOSBAQCBpd2xfcGNpX2ZpbmRfZGV2X2luZm8odTE2IGRldmljZSwgdTE2IHN1YnN5c3RlbV9k
ZXZpY2UsDQo+ICB7DQo+ICAJaW50IGk7DQo+ICANCj4gKwlpZiAoQVJSQVlfU0laRShpd2xfZGV2
X2luZm9fdGFibGUpID09IDApDQo+ICsJCXJldHVybiBOVUxMOw0KPiArDQo+ICAJZm9yIChpID0g
QVJSQVlfU0laRShpd2xfZGV2X2luZm9fdGFibGUpIC0gMTsgaSA+PSAwOyBpLS0pIHsNCj4gIAkJ
Y29uc3Qgc3RydWN0IGl3bF9kZXZfaW5mbyAqZGV2X2luZm8gPSAmaXdsX2Rldl9pbmZvX3RhYmxl
W2ldOw0KDQpUaGlzIGxvb2tzIGdvb2Qgbm93Lg0KDQpBY2tlZC1ieTogTHVjYSBDb2VsaG8gPGx1
Y2lhbm8uY29lbGhvQGludGVsLmNvbT4NCg0KS2FsbGUsIEknbGwgYXNzaWduIGl0IHRvIHlvdSBz
byB5b3UgY2FuIHRha2UgaXQgdG8gd2lyZWxlc3MtZHJpdmVycw0Kd2hlbiBpdCBvcGVucyBhZ2Fp
bi4NCg0KVGhhbmtzIQ0KDQotLQ0KQ2hlZXJzLA0KTHVjYS4NCg==
