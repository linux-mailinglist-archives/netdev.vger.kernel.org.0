Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7203337F7B6
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 14:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhEMMUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 08:20:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:48170 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233573AbhEMMUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 08:20:41 -0400
IronPort-SDR: be6whrNnpCOzDBmQzcsFl23Gacs1M0sSNd+mM4auhU91Uynt5LpZBlZn+2uKW/3GhuR/k7hkTU
 Q/Hb3vf1XKVA==
X-IronPort-AV: E=McAfee;i="6200,9189,9982"; a="196839861"
X-IronPort-AV: E=Sophos;i="5.82,296,1613462400"; 
   d="scan'208";a="196839861"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2021 05:19:28 -0700
IronPort-SDR: 9fpDYEFLkAmaXv3Si1/jvIgnlfeYvPZrXIhwi8d724g5VshEDWZNG4zg0XEVqqqL0HHUIojzwX
 Wdcem5Aj7/Dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,296,1613462400"; 
   d="scan'208";a="626011321"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga005.fm.intel.com with ESMTP; 13 May 2021 05:19:27 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 13 May 2021 05:19:27 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 13 May 2021 05:19:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 13 May 2021 05:19:27 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 13 May 2021 05:19:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oR4wilGCKkxFzsoc9882tCHlRfQc+Ybw0eEWBVVOSFUnCP6EyDLAmoo38TXlBLwpfiuBEQJsMFtG05UxFowy6vhuchrgYAP+iOHenZDcy9rQgWREPHG8FSRDnMUgXARz+LXdmTelPj0DZ4raB2wYeC5tJMHIiR6gx0g2Nx5dxzGwGI8lWM4XSS+53GfOmnohmmrMovkLUZpMpy17SqpHPWFZlSJEbBBo6zHDdGxUKTK1OPHPxULLsuPM7OV3DdmFCBf0ZZ14GoUAclB9HOkK7mUazyKkHbLVah44MHR7ukQ+aR6uQFtTOpk9DP5hJaPoNYR35pBOOnkzQOyWB8lx/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qm7qMpsReZYD39yWksCRvY2sZZyDxLPc4kmVqgAxrqw=;
 b=dQZtH9xA+ML0utW3A4sPlvwl5SgnkkhrLr6AV5GwyBnDi3p23jWJq/pMBSQRU4/rR2bUrKAJDVy+fWi93RlzDL4tkj8mAiofpIghtRxKaxn1cg9JIaf8nJz4XB2K/8pHoe/A5C9mMWEWd+qJJ5TIGbfeWaCZ5nYb0c69gI/SCKejKQaLjLA1T4bJmRRB3CpLsFIRnjMtzfjUJ+CV8D+DZqSZKwGbET9Kd7s1Q8D9W7i9kztmcCQ6jXz2EP8pXpEYzq+bXTMMWJqVcfuo4kNDlQ7yUxDxFbb4dbCuEY5oHdtdXmtFPY7QJ9wDmSCZmrUPSAh/c4LFBoBHF0/WKvyscw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qm7qMpsReZYD39yWksCRvY2sZZyDxLPc4kmVqgAxrqw=;
 b=B7I2eHeU4AL4bpGtHlsljxIvifQ6ffePTY1m6SyFk97o5wlIZPU12TEVXzD90eHMJadndH/wXekVJ9mpATAqy5WBFqj4zuDR8vIBbbdiPXGOen88kZgKHsvSqHw2lf6JSuntI5W1T4zODKEjOGv45Zq/hyhENPhR6FeEVXiJclI=
Received: from DM6PR11MB3449.namprd11.prod.outlook.com (2603:10b6:5:d::30) by
 DM6PR11MB3882.namprd11.prod.outlook.com (2603:10b6:5:4::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.28; Thu, 13 May 2021 12:19:26 +0000
Received: from DM6PR11MB3449.namprd11.prod.outlook.com
 ([fe80::7db4:29ba:85ac:838a]) by DM6PR11MB3449.namprd11.prod.outlook.com
 ([fe80::7db4:29ba:85ac:838a%7]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 12:19:26 +0000
From:   "Siwik, Grzegorz" <grzegorz.siwik@intel.com>
To:     Nick Lowe <nick.lowe@gmail.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Switzer, David" <david.switzer@intel.com>
Subject: RE: [PATCH net-next 2/6] igb: Add double-check MTA_REGISTER for i210
 and i211
Thread-Topic: [PATCH net-next 2/6] igb: Add double-check MTA_REGISTER for i210
 and i211
Thread-Index: AQHXMwElUBzyAn1eMkCctpmVMtx6t6q3pH2AgAX4TYCAH0I9gIAEnRPQ
Date:   Thu, 13 May 2021 12:19:26 +0000
Message-ID: <DM6PR11MB34493E49EE53F58A96DF4BAC84519@DM6PR11MB3449.namprd11.prod.outlook.com>
References: <20210416204500.2012073-1-anthony.l.nguyen@intel.com>
 <20210416204500.2012073-3-anthony.l.nguyen@intel.com>
 <20210416141247.7a8048ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b2850afee64efb6af2415cb3db75d4de14f3a1e2.camel@intel.com>
 <CADSoG1uYJGygF9rm+15BE4gy=RU9EBbmGv_+pzddrKLJLdV14w@mail.gmail.com>
In-Reply-To: <CADSoG1uYJGygF9rm+15BE4gy=RU9EBbmGv_+pzddrKLJLdV14w@mail.gmail.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [89.64.122.114]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e71f1b65-2e37-496c-88a6-08d91609598f
x-ms-traffictypediagnostic: DM6PR11MB3882:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB38822FB2573F596D717C076F84519@DM6PR11MB3882.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1H0hMTTf1ky2uH6fIG8i9SujDpDybsu36Y9i1BwwcBbeKcP7a9dUK6woJ9nUgfhB7ZsFBkS6lYE73HT+CnjcfZYWyh+CM14VYRJm97zh1y3Yk7rZWKtJIDaRL5BxvzDB+OBI1J3D/A3ujlChdNFeEL8ogS6mZ7moNyHYED6cWycA8g9siJb0VpchXtH67S6mNXyCm+pRLahWfdImsieEdMdmr4PJPwGapoa77BMbyVm3sXtUOtJ5u9dmGAI2E+mNldcm+NBhulbIfg81+dzQrEuFeAk9FWk1V5efY6+kGFZ3A1xHabbvw0BWT7J5W7yguTrp8SnJQPwEDiT8sFT3dkC7Hlqr0YH3K9bA3mhujXOIaAZqrTYOvTJmAUIuVN75sbFyxnqjxRjw59wRhuMiF/4MJT4Hf34s6AQ2jhyvXDJRXNe8hBTW5MQ8E8nDO8vA/6T8YCbE54wRmtEH4gyiOhtGoNQ5KP6pr01+gUgbyIGqOJqfUgcrmyX5IItR3miLf6m4XURHel1p97yn8bXVHx4A84uOGoVwSY1SXbXKYkokI/vLU0G7Jt8MYYIfFNW3ETXGQAb7Wk4VrSeYi55uwT2Gx153cLzjl0imaCNDlqfj0ZndO14sfP8tjVj3CtE18M8wVP/y28XGdKHqJ7pzJzY02lIN83jjDMkfhhZ34Pl8zimKgA07TkQOP97moS2f
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3449.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(396003)(136003)(26005)(4326008)(6636002)(52536014)(66946007)(38100700002)(76116006)(71200400001)(5660300002)(122000001)(33656002)(478600001)(316002)(9686003)(86362001)(55016002)(54906003)(2906002)(966005)(186003)(107886003)(8676002)(7696005)(83380400001)(8936002)(110136005)(66446008)(66476007)(64756008)(6506007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UjFZaUlHN0Z6WFQ5NW1mU01DdHIyZ29nekMzWG1nVTJwMGVhR2VKNDdmTG9n?=
 =?utf-8?B?UUZjWlB5QXlpUFI5Y2p4V0NrK1VyZ3Nkc0NMeG1KeTllTC96WnBXdkZSMzhB?=
 =?utf-8?B?bmEzZ1ZMdmFrMmdiNEdNNWhpUWZUTVNqTTJjVDYvaGt6VTF4ZmN1N0sveFhJ?=
 =?utf-8?B?OG5lMmRkY3NjMUVVYi9nK3AwVEZsR0pxT05TWWRud2Nrbm1XWkNTNWFCSVJ6?=
 =?utf-8?B?TWxBYmxUcDNMN1prSEM4S3ZBbWdZWXRXbkJHY1V0cFBJTWZCbTBRdHhmNzUw?=
 =?utf-8?B?cnlSWC80VmYzZlV4MGk2akxTVFFzcTRkZmJRcjVDZVRaMTd3S3BFU2Jwa2xL?=
 =?utf-8?B?VWRGWEZCU3E3OUw4SlFhMEVGUGJPdVNBVFBDOW9saHpQTTVlT0RqUmRqZHgz?=
 =?utf-8?B?UkpsdjU4OVBPYWl0cmk3NmtjN3FkZU5XUXVxVThnTVlhWm9sdVJKSFZpWmFm?=
 =?utf-8?B?VWd1a01pTmh3eHdDYU9majFvYUlyZ0pzMWtBcEtoRVIxUXBmYUk4RE5FMHgx?=
 =?utf-8?B?NStnQ1JaNHZHV25VT2RIa1Zjc1ltWS9MUzNFbDhsSUF4SXZHNjgwQTR3d1Ny?=
 =?utf-8?B?NHVhdHE5aUVLRDA0R09oTjUvR1dJenErQ29XbWlXR1pMeXNOenVtWlc1ak9o?=
 =?utf-8?B?cnJoUUh3R1B4VmFHYkQzZTlBS2gwT1RHWWNxMjFlcTc4N3QyV3d2NHlobkpB?=
 =?utf-8?B?b1gxaEllZHlrU05BUW1LcmFJZHZMdUJKR3RIRytEMjJCLzRFaDdWbStadjVH?=
 =?utf-8?B?aGM4WWc0a3pDRTlqdytOMHdRL244bmhhQUpZY3lTQUpISzR1TCtuOGx6QXkv?=
 =?utf-8?B?YTlYTldlU0pkSlNTQVdIMVplTDAwZG9yWUJ6eGd3UDIwd2xSTWpzWUNzczUr?=
 =?utf-8?B?LzR3MDRjUWd2dUc1M2tyZGNZQ3o5YkZUOHJUL3BudlZGV3J0cS81NmV4dGJS?=
 =?utf-8?B?UmI1eDFtZGR0WmhvRjd5anVvK3FGM2NzUDA4cFZYbmI5Z29ja2RZaVJDRjl3?=
 =?utf-8?B?VHprbkNSS0l1L2FBRjZ2TjFFai9ZNS9DazhVc0NpbXF5WGZzQ3d2MWRwSHAz?=
 =?utf-8?B?S1gxUmZGTGhPTWIxMjZsNWV2bGZIWWZkZnp1d2RDOG9qa3JzM09Lbi9WMktI?=
 =?utf-8?B?TXBvOHFpakJuc0xUUlNWM2wvQzNVRDBLait4Nmp0ck9mYzh2YTgrOFI2T0hZ?=
 =?utf-8?B?bUZJWExYV1ZpUiswUWc4TkNlQkN5dlVGNVB4WStoU1JvMFl3ZVVmOFo4SjVC?=
 =?utf-8?B?NlV4R09vWm9UZzZCT3paSWtiWDY3VFhIczhhbkdVU016Q2NiUlpOYVk3SFB1?=
 =?utf-8?B?cUVtMktrTzJJRmJwdTRSMUhSdnhBMFg5YkNTT0NFcUpyM3Y3MG9ZaUFGdm10?=
 =?utf-8?B?UjViR1hWb3dYb3MyQmR5ZjJRR09XMUY4QkZQZkY5VmN3Sm82dGt3SFVteVo5?=
 =?utf-8?B?elMyYVdjVC9LN1o5SlJQSWF2Y0Rzc08yTTdseGl5cVRQcFpKWmxhb1gzTXd5?=
 =?utf-8?B?VkpuK0NaSytMMTNzN1d4UGJyNVZaYmF5cE8rSjIvdXFJTnJ4NDlzM2c4RjI4?=
 =?utf-8?B?UnhHMFI0ckN0RWxDNVlhbWtRbUtrUFBCblZEZ3lUUTNoRTVrNW9nbEg3OXV2?=
 =?utf-8?B?Q2FjeGtvakJCelhia3Ara29HYXl0NWdUV1VDdlN4SEdQYTdWVnlCbjR6KzU2?=
 =?utf-8?B?Q3U4Qkc2WWQwRURzQXAxRVNnSGplc2pUYVNCWDYwOVRQOHUzYW9QNFVnc0gw?=
 =?utf-8?Q?pphY1+ys3udhoy+45w99o5VvTJ2oILOtPN6JEKw?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3449.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e71f1b65-2e37-496c-88a6-08d91609598f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2021 12:19:26.1652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9pjdSHukZU5Py25+bNSILVGa+MdzZin2q7vtJP79GBbjjLEbufcDN941Qi3hIww0JvsgvUneX7u6zFTXMmRFxkkLn+O5WU5uTNcGf4a7zdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3882
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgYWxsLA0KDQo+ID4gPiBMb29rcyBsaWtlIGEgcG90ZW50aWFsIGluZmluaXRlIGxvb3Agb24g
cGVyc2lzdGVudCBmYWlsdXJlLg0KPiA+ID4gQWxzbyB5b3UgZG9uJ3QgbmVlZCAiaXNfZmFpbGVk
IiwgeW91IGNhbiB1c2Ugd2hpbGUgKGkgPj0gMCksIG9yIA0KPiA+ID4gYXNzaWduIGkgPSBody0+
bWFjLm10YV9yZWdfY291bnQsIG9yIGNvbnNpZGVyIHVzaW5nIGEgZ290by4NCj4gPg0KPiA+IFdl
IHdpbGwgbWFrZSBhIGZvbGxvdyBvbiBwYXRjaCB0byBhZGRyZXNzIHRoZXNlIGlzc3Vlcy4NCj4g
Pg0KPiA+IFRoYW5rcywNCj4gPiBUb255DQoNCj4gVGhlIHBhdGNoIGZvciB0aGlzIHRoYXQgaGFz
IGJlZW4gcXVldWVkIGlzIGFzIGZvbGxvd3M6DQoNCisgICAgIGludCBmYWlsZWRfY250ID0gMzsN
CisgICAgIGJvb2wgaXNfZmFpbGVkOw0KKyAgICAgaW50IGk7DQorDQorICAgICBkbyB7DQorICAg
ICAgICAgIGlzX2ZhaWxlZCA9IGZhbHNlOw0KKyAgICAgICAgICBmb3IgKGkgPSBody0+bWFjLm10
YV9yZWdfY291bnQgLSAxOyBpID49IDA7IGktLSkgew0KKyAgICAgICAgICAgICAgIGlmIChhcnJh
eV9yZDMyKEUxMDAwX01UQSwgaSkgIT0gaHctPm1hYy5tdGFfc2hhZG93W2ldKSB7DQorICAgICAg
ICAgICAgICAgICAgICBpc19mYWlsZWQgPSB0cnVlOw0KKyAgICAgICAgICAgICAgICAgICAgYXJy
YXlfd3IzMihFMTAwMF9NVEEsIGksIGh3LT5tYWMubXRhX3NoYWRvd1tpXSk7DQorICAgICAgICAg
ICAgICAgICAgICB3cmZsKCk7DQorICAgICAgICAgICAgICAgfQ0KKyAgICAgICAgICB9DQorICAg
ICAgICAgIGlmIChpc19mYWlsZWQgJiYgLS1mYWlsZWRfY250IDw9IDApIHsNCisgICAgICAgICAg
ICAgICBod19kYmcoIkZhaWxlZCB0byB1cGRhdGUgTVRBX1JFR0lTVEVSLCB0b28gbWFueSByZXRy
aWVzIik7DQorICAgICAgICAgICAgICAgYnJlYWs7DQorICAgICAgICAgIH0NCisgICAgIH0gd2hp
bGUgKGlzX2ZhaWxlZCk7DQoNCj4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4
L2tlcm5lbC9naXQvdG5ndXkvbmV4dC1xdWV1ZS5naXQvY29tbWl0Lz9oPWRldi1xdWV1ZSZpZD05
ZGIzM2I1NGZiOTg1MjVlMzIzZDBkM2YxNmIwMTc3OGYxN2I5NDkzDQoNCj4gVGhpcyB3aWxsIG5v
dCByZXNldCB0aGUgY291bnRlciB3aGVuIGNoZWNraW5nIGVhY2ggcmVnaXN0ZXIgYW5kIGl0IHdp
bGwgbm90IGRlYnVnIG91dHB1dCB3aGljaCByZWdpc3RlciBmYWlsZWQsIHRoaXMgZG9lcyBub3Qg
c2VlbSBvcHRpbWFsLg0KDQo+IENvdWxkIGl0IG1ha2UgbW9yZSBzZW5zZSB0byBpbnN0ZWFkIGRv
IHNvbWV0aGluZyBsaWtlIHRoaXM/IChVbnRlc3RlZCkNCg0KSSBjYW5ub3QgYWdyZWUgZm9yIHRo
aXMgcGFydC4gSW4geW91ciBzb2x1dGlvbiB3ZSBhcmUgY2hlY2tpbmcgZXZlcnkgcmVnaXN0ZXIg
MyB0aW1lcy4gDQpFbnRpcmUgTVRBX0FSUkFZIHlvdSB3aWxsIGNoZWNrIE1UQV9SRUdfQ09VTlQq
MyB0aW1lcy4NCkluIG15IGNvZGUgdGhpcyBpcyB3b3JzdCBjYXNlIHNjZW5hcmlvIC0gaW4gYmVz
dCBzY2VuYXJpbyBJJ20gY2hlY2tpbmcgZXZlcnkgTVRBIG9ubHkgb25lIHRpbWUuDQpQbGVhc2Ug
cmVtZW1iZXIgdGhhdCBwZXJmb3JtYW5jZSBpcyBhbHNvIHJlYWxseSBpbXBvcnRhbnQNCkFsc28g
dGhlIHByb2JsZW0gaXMgdGhhdCBpMjF4IGRldmljZXMgY291bGQgbm90IGFsd2F5cyBhY2NlcHQg
TVRBX1JFR0lTVEVSIHNldHRpbmcuIE15IGNvZGUgaGFzIGJlZW4gdGVzdGVkIGFuZCB2ZXJpZmll
ZCBhcyB3b3JraW5nLg0KSW4gbXkgb3BpbmlvbiB3ZSBkb24ndCBoYXZlIHRvIGtub3cgd2hpY2gg
RTEwMDBfTVRBIHJlZ2lzdGVyIGhhcyBmYWlsZWQsIGJ1dCB3ZSBzaG91bGQga25vdyB0aGF0IHRo
ZXJlIGlzIHByb2JsZW0gd2l0aCBlbnRpcmUgTVRBX1JFR0lTVEVSLg0KV2hlbiBJIHdhcyBjaGVj
a2luZyB0aGlzIHdpdGggdGVzdCBzY3JpcHQgZm9yIG92ZXIgMTFNIGl0ZXJhdGlvbnMgdGhpcyBp
c3N1ZSBuZXZlciBoYXBwZW5lZCBtb3JlIHRoYW4gb25lIHRpbWUgaW4gcm93LiANCg0KPiArICAg
ICBpbnQgaTsNCj4gKyAgICAgaW50IGF0dGVtcHQ7DQo+ICsgICAgIGZvciAoaSA9IGh3LT5tYWMu
bXRhX3JlZ19jb3VudCAtIDE7IGkgPj0gMDsgaS0tKSB7DQo+ICsgICAgICAgICAgZm9yIChhdHRl
bXB0ID0gMzsgYXR0ZW1wdCA+PSAxOyBhdHRlbXB0LS0pIHsNCj4gKyAgICAgICAgICAgICAgIGlm
IChhcnJheV9yZDMyKEUxMDAwX01UQSwgaSkgIT0gaHctPm1hYy5tdGFfc2hhZG93W2ldKSB7DQo+
ICsgICAgICAgICAgICAgICAgICAgIGFycmF5X3dyMzIoRTEwMDBfTVRBLCBpLCBody0+bWFjLm10
YV9zaGFkb3dbaV0pOw0KPiArICAgICAgICAgICAgICAgICAgICB3cmZsKCk7DQo+ICsNCj4gKyAg
ICAgICAgICAgICAgICAgICAgaWYgKGF0dGVtcHQgPT0gMSAmJiBhcnJheV9yZDMyKEUxMDAwX01U
QSwgaSkgIT0NCj4gaHctPm1hYy5tdGFfc2hhZG93W2ldKSB7DQo+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgaHdfZGJnKCJGYWlsZWQgdG8gdXBkYXRlIE1UQV9SRUdJU1RFUiAlZCwNCj4gdG9v
IG1hbnkgcmV0cmllc1xuIiwgaSk7DQo+ICsgICAgICAgICAgICAgICAgICAgIH0NCj4gKyAgICAg
ICAgICAgICAgIH0NCj4gKyAgICAgICAgICB9DQo+ICsgICAgIH0NCg0KPiBCZXN0LA0KDQo+IE5p
Y2sNCg0KQmVzdCBSZWdhcmRzLA0KR3J6ZWdvcnoNCg==
