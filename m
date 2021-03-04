Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0B232D9E4
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 20:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236069AbhCDTBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 14:01:41 -0500
Received: from mga06.intel.com ([134.134.136.31]:17835 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236068AbhCDTBI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 14:01:08 -0500
IronPort-SDR: ZRLhz/oDzUuEUdnTbyu3ngEsnPO3TF47Ol+EyQvlQext8SINd3a0xhV7LxNVaaX/RAFwRprWUE
 9FNkwO2IdvvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="248876334"
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="248876334"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 11:00:24 -0800
IronPort-SDR: IvvernSV/pP4iNDyDDDP75lypqoXO8obUQZNxV/Nhhvktpu47E/AR8rOVsuzsdbPOWWh6iVZUA
 xR9PuvOiXTBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="368287763"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga003.jf.intel.com with ESMTP; 04 Mar 2021 11:00:23 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 4 Mar 2021 11:00:22 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 4 Mar 2021 11:00:22 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 4 Mar 2021 11:00:22 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 4 Mar 2021 11:00:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1mAyzw0asVXbAQmLaysoPP20tjn4xLmPYU3fmIut+nNkYuzNghfRQjOQtnD3jPSP3mBos7QGBta8FSXG/63JijBcU0Yrjeza1ZNA7wLhgYJI4mf/TnG2guj+L4yDid0KEyA046cVbLvPzLa91dgXDzwwKR42YGs2nF8Zmo6RUbIMoh16+DHsYdQPsIHar34tvh5LV0bdZpvKn2GpRVuhu1RbgcuXgNObffQ2XFFIWiU0mNM7zHX/bunLTf+HitKvJNaquQpiusiYxCp6BrQvAdNRpX6oioDNR0Ud5DnjL83l3e0xF7gD774WKGmhfxab1A61wDqye03cLEPiHl6iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vR3NWF//T8MKZWQbyLOrzSDxEqC/koiud1LvT/LehE=;
 b=eNfzCL2RKKpW4tIK9pVqSHYrcfClAUdgsRyeB0OHRiyAIk4kXu8hVvsl4h6mEACrk360nq6ITHzg1mzKj/n3CkxVId0LY4Dbt6sXTsOkqZwY3MJ2QMT02FnEJwp8WMi/99SPvEPm6OAgidTlYe1yJVFEV6S+JcRvsPCvyAqd+EpDJv1rOoRINU61DRNsn25UBy7JX88YGCJsg4Chb7CfI+c2FhLB/WXfJJFFA/c7N9v68NmbDNhAtdODMtAFnN/DPEcOGhTRP4fnr7SF6FdZrulKN/yRcy7Ye4nhJaSGBuq9TlZPyydWac/NkQ+HjdP24Eo05QmPTE8ZGAIhcomoCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vR3NWF//T8MKZWQbyLOrzSDxEqC/koiud1LvT/LehE=;
 b=Gx2s/WFjdyoKPTFF4Do5MyMxrjFRkaBqw3E9Km+JiLdLVyTotCJTfveAv+dT+FS4P8GY9EXzEnc+daykPMHS7uQRYWsoE3mXory2H5/THGBnU/ZrFa4Aq1EMeXL9NTBkqFq2lPFLboxzZDslxNsQ0sCCXjSJIW9lDBL/r1YVAEo=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA0PR11MB4542.namprd11.prod.outlook.com (2603:10b6:806:9f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Thu, 4 Mar
 2021 19:00:20 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::85b7:921c:ff53:696e]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::85b7:921c:ff53:696e%6]) with mapi id 15.20.3890.028; Thu, 4 Mar 2021
 19:00:20 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yongxin.liu@windriver.com" <yongxin.liu@windriver.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>
Subject: Re: [PATCH net 1/3] net: ethernet: ixgbe: don't propagate -ENODEV
 from ixgbe_mii_bus_init()
Thread-Topic: [PATCH net 1/3] net: ethernet: ixgbe: don't propagate -ENODEV
 from ixgbe_mii_bus_init()
Thread-Index: AQHXEJKA/C8e5Hve00emt2yJSVfu5ap0LTYAgAAC3gA=
Date:   Thu, 4 Mar 2021 19:00:18 +0000
Message-ID: <2cff55826c19c9765fac85dc0d59a0c0e0d38a47.camel@intel.com>
References: <20210304010649.1858916-1-anthony.l.nguyen@intel.com>
         <20210304010649.1858916-2-anthony.l.nguyen@intel.com>
         <20210304105000.5c001707@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210304105000.5c001707@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f89ee94f-40e1-48e5-8a86-08d8df3fc257
x-ms-traffictypediagnostic: SA0PR11MB4542:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB4542D7844E8BEE6969954620C6979@SA0PR11MB4542.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z+lkBqSGZoPdZzuJJ0KR9OE6N54ZA2Nhh+pKsbnE07YybkEdNs8eUz+fVqs3Y8uPZaGTAlHlF8vIWKF0g5nU9b8bwS6li3WGeQNlI+Z63sqKJyPHj4hhKDq7bIM32ZB3cQcmOabiYM/4yobIKy9kJeuFhcCETshmn0rkoQ0IMaIfDcazxKrg4882wtb6+/hULi+504bAmeD9KSB4tqhbS5OSZtHbXGMc7268qsD7wESea2i2n7ABPa2GyiQNa9wXSUvQOh7mZie2GmCz5cpvUeb7m/ZhhHIBjqCJ4NIi9Vs8k0+HZ5FBqKgzddYCBelU8jbw+FfpcunCdNohjZvkatc2K1cgCHDn60kt0H+w6lK34vyZ7zlBno/MpnEbY49Jg2TIyxKjEs6jjy5WmGWW3n6xuH1w7ipdp02bKKfpLMjAqeR7pCfQ81Ccd7Dybz2nWv2NZf+Uri3SaaG+LuVxD/XygqALUy/fWqkbu1tXvnl21y88Znlc+3v/7d/5LL7Dtw2GhDOlor328tCSFHRyIVj1PNh3Qp+ueudiw+GpkVcay8Mvja0EyNA1e4VlzvUE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(376002)(346002)(366004)(26005)(478600001)(5660300002)(66946007)(186003)(6512007)(86362001)(6486002)(91956017)(4326008)(66476007)(6916009)(66556008)(6506007)(66446008)(76116006)(36756003)(2906002)(71200400001)(54906003)(316002)(8676002)(2616005)(8936002)(64756008)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?aG1LZ1Rub0hWbXdkOWxhUXV0K3hEOXVGc2gwUUpHdWNNdDJvOFpRQ0o5NVpK?=
 =?utf-8?B?Y3ZuV25jN1RUTmNZeTdJUEJEODdkUkNCQ0M1dHdicnMyNXNUSE1wODlCdFRo?=
 =?utf-8?B?eUxzMGJBZG40V01UOEZ3R2lsNXZvRGE5MlcrUG9ZU2o1RzI1NUxrVlhScmdE?=
 =?utf-8?B?SzROcUhRRVRERDhVL3BEd2wvV0RoTi9JVklyRlJmZnJuSVl3OTA3LzhrdGtU?=
 =?utf-8?B?TWprZnpERTJLc085UG1TSE14NUFqVlZNenZUZFNrd2tuYmo1elJZSjlzaEFL?=
 =?utf-8?B?djBTSmkwaVNDSWlPUU9tNlJoTit3bGNOR2V2dXlZdGJZSlRBTWJvZSt6TmJZ?=
 =?utf-8?B?cXpHaXVZbXc3bmx5UitNamcxd1lKclp1dmZWcmgvU2grK2xyTmdCdktSNW56?=
 =?utf-8?B?MnY2b1lMZm5yOHpCckhRVlpwS3NTRWNsVzBXV01OaVkrWjY1THJFbnEwNXE3?=
 =?utf-8?B?V0YySVBmSjA3MTJPRFlVTmc3Nlo5WUw3eGlCVThVRnhJRlhTMG9jQ1I5RlV5?=
 =?utf-8?B?TkwwSlozVTVmU1NadnNxdXA5TWxGM0x1eHFBZnl5LytaK1hyTnFxVTZ0blNM?=
 =?utf-8?B?UFBHd0liNnl1MXkyUms0TThhZ2hwQU1pQk0zMHdoak42UHo3VUd1M0s1ZjMy?=
 =?utf-8?B?NjRHaGVTK1FYK2JjZDYzMEZlZ2NWTGM4MXZ2R05MK0gzTlpQcW5XZ2txSmdJ?=
 =?utf-8?B?MzZaWDM1T2pQc2h0eDVaMUQyc3h1bTNXL2V0bHZPQTMzdUNabytTem5QYWVS?=
 =?utf-8?B?ZUN6dEUzdXpOY2J2WVVOODNyMXk4UlYrRkRNZG1YN3FwT1BqeFF1WFRWem1R?=
 =?utf-8?B?YXBHWTNLemRqemRvVkp3UC9iaTJyLzdQTWNrL25VTFcxdlNvNWRZcDlybVpO?=
 =?utf-8?B?UkJxRERmUGN0cDNaak16TlVKRUxQSyt5NEFuVkVueEtOcVJWMndMRnphZkpR?=
 =?utf-8?B?c1B4N1Z1Q0JZZUpIUXFsbWJpQ3k4bi9OU2cvekJXVnhXdlYwOFVJQ3R1aGI5?=
 =?utf-8?B?M3d0SzlXVE9mTGc5ZytwTDhMUzFwc05VTzVSS2Irc1BFR1NHNjM1ZzNVdFFU?=
 =?utf-8?B?MmZXYmU2cFdTOVFEZlF4RlZES0orUVBHTkhvWGF4aDBOYmF4ZWFjQityWHM1?=
 =?utf-8?B?UE92bWVqOUpWV2pnakhkK0NOWndESFBuQnVPTU1VWDJqb0U2T1Q2T1lUNVpF?=
 =?utf-8?B?WUE2SVdsbUJEcFNpNitaK3VKNVViTnkyUFI4eXFObGhIVjVSRlBmK1E4Vmpv?=
 =?utf-8?B?SEV1Y3kzbC9qa3lEclFtTS9uWHFKTGhuUk41SUNZMVNTQmlJbzBUSVkyMXpB?=
 =?utf-8?B?cEZuQWUzUWVVUnhLbmt4TXdDdksrVFp5QlV1elJ4YzMrOUxTZGVrSW5sQXZu?=
 =?utf-8?B?VDV4RWRqREJDVEJjRG9jME9RWTU3aG5XYVVQY0IvYnB6Nis4UkZoT2EvRkth?=
 =?utf-8?B?NnE3Vk1lOHJEbE5LUDZGYUJsbEtaQk1IZksvdzlwdmwwUGFZek8xRmtFUm91?=
 =?utf-8?B?Z2pEZ3RnOVBwNTlibFNtb25CWExXcW1MT0tLYTZvbHc5ZWQ2WkcxMDZSSktN?=
 =?utf-8?B?SmpHRG16RlZDcldTYldjWm1RaHFxL2NiY0k3UHZ1aEtzd01OU0RvbHBoNUVI?=
 =?utf-8?B?dm85ajREdzZKTUFIcnFrUWVvWGozTDdlN0NaWWpRZUNzWlp6bi9jVGk4bVlE?=
 =?utf-8?B?WUh6UGIvdEVuQitoc1RuSVBDSWRtd204WFpSdWhuR3VkWFZUeU9nSTdZbWMx?=
 =?utf-8?B?eEIwbjNDMnFvbk1HVUVPdXJ2RXpZZnFTbXdmL3VPZU9Ecm5mcEJRTXAzQjdB?=
 =?utf-8?B?U1dZV0FjTWNjS21sWlNDdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D94D38D0E21394A8F9A543928AEE19C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f89ee94f-40e1-48e5-8a86-08d8df3fc257
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2021 19:00:20.7866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: buDBCWNilqTBWJvEq6AeAhQkQ8brfxys7k4sVJ0EOFjo0k/MeWfIcQ4wt2GAnijSI7WiBx4kP3Gq1q32fwQ++0Np8+WqqSFQs7DKi+MshQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4542
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTAzLTA0IGF0IDEwOjUwIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAgMyBNYXIgMjAyMSAxNzowNjo0NyAtMDgwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiBGcm9tOiBCYXJ0b3N6IEdvbGFzemV3c2tpIDxiZ29sYXN6ZXdza2lAYmF5bGlicmUuY29t
Pg0KPiA+IA0KPiA+IEl0J3MgYSB2YWxpZCB1c2UtY2FzZSBmb3IgaXhnYmVfbWlpX2J1c19pbml0
KCkgdG8gcmV0dXJuIC1FTk9ERVYgLQ0KPiA+IHdlDQo+ID4gc3RpbGwgd2FudCB0byBmaW5hbGl6
ZSB0aGUgcmVnaXN0cmF0aW9uIG9mIHRoZSBpeGdiZSBkZXZpY2UuIENoZWNrDQo+ID4gdGhlDQo+
ID4gZXJyb3IgY29kZSBhbmQgZG9uJ3QgYmFpbCBvdXQgaWYgZXJyID09IC1FTk9ERVYuDQo+ID4g
DQo+ID4gVGhpcyBmaXhlcyBhbiBpc3N1ZSBvbiBDMzAwMCBmYW1pbHkgb2YgU29DcyB3aGVyZSBm
b3VyIGl4Z2JlDQo+ID4gZGV2aWNlcw0KPiA+IHNoYXJlIGEgc2luZ2xlIE1ESU8gYnVzIGFuZCBp
eGdiZV9taWlfYnVzX2luaXQoKSByZXR1cm5zIC1FTk9ERVYNCj4gPiBmb3INCj4gPiB0aHJlZSBv
ZiB0aGVtIGJ1dCB3ZSBzdGlsbCB3YW50IHRvIHJlZ2lzdGVyIHRoZW0uDQo+ID4gDQo+ID4gRml4
ZXM6IDA5ZWYxOTNmZWY3ZSAoIm5ldDogZXRoZXJuZXQ6IGl4Z2JlOiBjaGVjayB0aGUgcmV0dXJu
IHZhbHVlDQo+ID4gb2YgaXhnYmVfbWlpX2J1c19pbml0KCkiKQ0KPiA+IFJlcG9ydGVkLWJ5OiBZ
b25neGluIExpdSA8eW9uZ3hpbi5saXVAd2luZHJpdmVyLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBCYXJ0b3N6IEdvbGFzemV3c2tpIDxiZ29sYXN6ZXdza2lAYmF5bGlicmUuY29tPg0KPiA+IFRl
c3RlZC1ieTogVG9ueSBCcmVsaW5za2kgPHRvbnl4LmJyZWxpbnNraUBpbnRlbC5jb20+DQo+ID4g
U2lnbmVkLW9mZi1ieTogVG9ueSBOZ3V5ZW4gPGFudGhvbnkubC5uZ3V5ZW5AaW50ZWwuY29tPg0K
PiANCj4gQXJlIHlvdSBzdXJlIHRoaXMgaXMgbm90IGFscmVhZHkgZml4ZWQgdXBzdHJlYW0gYnk6
DQo+IA0KPiBiZDdmMTRkZjk0OTIgKCJpeGdiZTogZml4IHByb2Jpbmcgb2YgbXVsdGktcG9ydCBk
ZXZpY2VzIHdpdGggb25lDQo+IE1ESU8iKQ0KPiANCj4gPw0KDQpUaGF0IGxvb2tzIHRvIHNvbHZl
IHRoaXMgaXNzdWUuIEknbGwgZHJvcCB0aGlzIHBhdGNoIGFuZCByZXNlbmQgdGhlDQpzZXJpZXMu
DQoNClRoYW5rcywNClRvbnkNCg==
