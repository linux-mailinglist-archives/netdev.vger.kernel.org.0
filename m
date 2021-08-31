Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6423FC2D3
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 08:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbhHaGhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 02:37:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:32487 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232892AbhHaGhU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 02:37:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="218456529"
X-IronPort-AV: E=Sophos;i="5.84,365,1620716400"; 
   d="scan'208";a="218456529"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2021 23:36:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,365,1620716400"; 
   d="scan'208";a="509838039"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 30 Aug 2021 23:36:24 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 30 Aug 2021 23:36:22 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 30 Aug 2021 23:36:22 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 30 Aug 2021 23:36:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OoWp9YnpLzpWSj4yzVe0Lzpa8VesOzl0gm5TGjVdaw6bNoqaOSh1ayXj97OM7GofUmpKVPfO8k2BQ9KysDMga2G1M+jjRWDXUWFqCs4r3MJDWyNi0ce98w6VheH6IoCjhJXNIXqIoOnk9eB6fSvJv4ED0dvyOgtUDOU/Ww7N8VUd6F5K0xSvbNuecfnM5LncxdW6xNeRn0uSNihIWrEpWKsit0EEtnyjG9/3INcckeKiNkDYW4KagJq3DPX5cjYAw+JhacKjXoyhoGEVAZtpc8S5K7xQDVC7AExelCB/okyO0dw1BPjjUa4MhqazUZ7r2NJlOgTckBP+2gAkpDjEJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ynzJR/6IvutAC9R7IC6Xnyn19K0PJ+lRKoo92ifaLI=;
 b=Pn/KV2M7LFzGiS4/s7S1LKHPYGrM8T6k0Oxqjd8fhlAwP6fD9GX2zW1sNRSm4kQzZ1loKGT32KusIpREHZP7DZ7u2LilOooWSHEMTkoHWPD4rd5TZravo1YlwwlID8lX5OSROa9+wqpYm3T8bfhaFKKbvsgt+LmDaP6LsUsEcszXqMwRZSo7fCsVQ6bff9kht9vMZJfoSFmzydVvfYc9aZgYNCPwfhB/rG0GLGORk6e9u8iyqJR0XL6Q9bPzrIAIfMQspFkmx5upZYQgOcbXnr58ZXalFPF1FVUcPCEyK83W4YC7Qe3B4ENEmLeca2rwpjBGNrMOB2gqIogrMFjimw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ynzJR/6IvutAC9R7IC6Xnyn19K0PJ+lRKoo92ifaLI=;
 b=OvHqdfBXI8uiV6CHLDMJkbN4wVxS00XWrfdpczPsQUMn/1BusXWZEHoeMJbe5xPQzayO7FjpV3Pp9R+mj2wOY0N+WZcEOh4xo4hm4nJ5nkGicy/RmDggxvyPonLtQ5tpiWrS0cb+a/0TqvNaIdYbSI9xJYSXQ4BLaYxQTW1yc+0=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BYAPR11MB2647.namprd11.prod.outlook.com (2603:10b6:a02:be::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Tue, 31 Aug
 2021 06:36:15 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::bc8c:80c0:1c01:94bf]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::bc8c:80c0:1c01:94bf%7]) with mapi id 15.20.4478.017; Tue, 31 Aug 2021
 06:36:15 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "jmforbes@linuxtx.org" <jmforbes@linuxtx.org>
CC:     "yj99.shin@samsung.com" <yj99.shin@samsung.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Baruch, Yaara" <yaara.baruch@intel.com>,
        "ihab.zhaika@intel.com" <ihab.zhaika@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Gottlieb, Matti" <matti.gottlieb@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi Add support for ax201 in Samsung Galaxy Book
 Flex2 Alpha
Thread-Topic: [PATCH] iwlwifi Add support for ax201 in Samsung Galaxy Book
 Flex2 Alpha
Thread-Index: AQHXb5JCu++4nbn+uUSCiulktq1hDqs68YgAgC+EIYCABj1HAIANkJWbgAaVfYCACKzVgA==
Date:   Tue, 31 Aug 2021 06:36:15 +0000
Message-ID: <ddcb88a3f6614ef6138b68375a22fbba1b068ff3.camel@intel.com>
References: <20210702223155.1981510-1-jforbes@fedoraproject.org>
         <CGME20210709173244epcas1p3ea6488202595e182d45f59fcba695e0a@epcas1p3.samsung.com>
         <CAFxkdApGUeGdg4=rH=iC2SK58FO6yzbFiq3uSFMFTyZsDQ5j5w@mail.gmail.com>
         <8c55c7c9-a5ae-3b0e-8a0f-8954a8da7e7b@samsung.com>
         <94edb3c4-43a6-1031-8431-2befb0eca2bf@samsung.com>
         <87ilzyudk0.fsf@codeaurora.org>
         <CAFxkdArjsp4YxYWYZ_qW7UsNobzodKOaNJqKTHpPf5RmtT+Rww@mail.gmail.com>
In-Reply-To: <CAFxkdArjsp4YxYWYZ_qW7UsNobzodKOaNJqKTHpPf5RmtT+Rww@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.3-1 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6adc32ef-609a-4a63-f736-08d96c49a1ff
x-ms-traffictypediagnostic: BYAPR11MB2647:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2647F987AC44208D8E5C87BE90CC9@BYAPR11MB2647.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Si61PcV6Exc6RXix/qYUIT3om8+WE7amAgb/7MOx8fcLfkEtXKpfUyup8UAKkZZ1Er+tpYrbjkZ6qWtd0rwT0e/6Rn/Hla+THqpUKzZrveIpF6oDvp5PYyLXJEcOuAIYhDp2wc8p0XwQ78+3Owr6sbaIclzuxBxDUw0pQgRaHm/c1/lpc0qxJ+BPV1z8ZYh09bPbOSPUl38zl/gk3AjSfzFCjckzegMkAe4YYZPfEfhE20aObsEFgavkC7LHbGiUAg29M+0z/x7PJiZjfRiann75ASNOpQceGdef6CDvAdfRlrzo8HsQlD1kGmJ0QFGLvUtTdyE37EMFDA3lzaWZO8GXW34ETtuMJYIdccDWgjyChndNAnKd+E0LE4scIbCVzHjqyF74SNDeZUvfxCcrhrxzY5uD3c5yQhSQZWqyRE3ZVNXNbj73Kdbh8dfTcalYUM9kFnKVmskIwak5Eb04ucLDGB85zjd237vZ2y4S7lCF4Gc4ynThWhNdQ9mJJ31EytlhgVHjl2mTp3dNwxQPdcGvxKPhkmJsIyaTPFrAtcKkp3DXgZbKqs1/qiI58VKGy/vsAFUy6CmkeI9yXu6KnK3q3ET1NrADSCazcjFzGFeC6Aqpf8CtJXrkR7IuEfLCp1F415y3wLSZ6tzqP4FAtXMVNhsYE1fgiQBCDNucvqjeEabjNB19pb5iLE5PSOdYrDo23LHC2jPNk0w6yh39Qy2OGHI5MicJoXMetLwne8UrBWv7Dm8AgRdPdsKg6kOiy5z4Y4Dn0VeZFGn8mQ0AxPIrICEA/I32av8B5Te14o4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(5660300002)(6512007)(83380400001)(2906002)(8676002)(66946007)(4326008)(53546011)(64756008)(71200400001)(66476007)(966005)(6506007)(54906003)(38100700002)(6486002)(36756003)(122000001)(76116006)(8936002)(110136005)(91956017)(66556008)(186003)(86362001)(66446008)(478600001)(2616005)(316002)(26005)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aUtjcDNEUUdhQndST29kR1NoQk9RcmROMVpZc0YrOVFURStIODR5ZGZKMkxs?=
 =?utf-8?B?NngwRnRXMTE5aHBWUmpKWWV1UHZxNVVMWEFaakx2dnVIQUpnRy9OK0JiZXpp?=
 =?utf-8?B?SVFGa3BOYytIMzRsRGZWai9FZUJKT05BTDZGZHB6YjNORHNhdGVkVUFIc1I4?=
 =?utf-8?B?Mzg5VmZhVjVaRjkzY1ZMbVpkQ3FZNGJKQkVPbXdkSkZ6cXN1aWhXUDRvbkJO?=
 =?utf-8?B?Mm1GMmppbjNZU3FMbVE4NGlWUGNac2owZmJoRHpCRW9MSEtqNFBZRnlqTE1j?=
 =?utf-8?B?RmlKN1graDh3TUhPWmJodExmbnVBZ3JocC92MDc2MXJzTXQ3TWkyRWhKVkJw?=
 =?utf-8?B?L3duaENLM0x6Z2RweE9nOVJHOEpneTR5U2diTjgyRHhwTXdKUDlwdmNwZklQ?=
 =?utf-8?B?ZzRDUS9WMmQrRTJrR2tSZFpsLzNwWjJicnFOSk51Y1duNGMvQU4vZWRQRjYy?=
 =?utf-8?B?WDlyUGtUbEticmZJQUpZUVExK3Rzejd2WXhEUDdNL3ExUkM5ZVJ2ZCtYc3Fl?=
 =?utf-8?B?QlJwU0NkbWE5Z3RQNVRaN0xQUW9FWG5lUlV2djBmWWR5bllnbFRQdXphS1dI?=
 =?utf-8?B?M0dvV3E2SUtydzhLUUprYTRFUExjUGllOXdzdVEybWQ4UG9mYzVRYzI0TkVl?=
 =?utf-8?B?VFRVcHVoQ1JpYlJjdS9OTml5aEQrWGM1cGNvcUJBNjk5ZnlDeW5pSCtudWFi?=
 =?utf-8?B?MGYrSlNFMUd6Z1FJSmlDMUE0aVdZcUtZMFpCVU80VkRKQS9nZ3dhUHFZTlk3?=
 =?utf-8?B?TEZXNSsvc2RmbWd2MExxWlhUNWNyMHJNVW1Md054TjhVL1Q5aEJmQ1dCaUhz?=
 =?utf-8?B?azd2NGJwSEp3VFJPQVFWSi9XeTdUWVB6UUxySVNJRVc0cmFZYmwvYWY1VlY0?=
 =?utf-8?B?UkU4NUlrdmdLRURnYVRBdndPRXFtS2orVzZlOGtpbHBjNkhIOFpsaEdVZTNY?=
 =?utf-8?B?S2FmNy9sTkRpTnc2TFpLZndjVVY4T0kwcHZsYzBRSHFEZktxVDRSMnd0RmFK?=
 =?utf-8?B?NDZuZzB0bHRuVnZlTENCUGtqaWJ3RVQ1OEp0d0x5RUVZRC9oSEdGM0VmUkc4?=
 =?utf-8?B?cWdvdERuNmJrVFBmbSt6S2sxeDR1bVVPRDdPclp0VDJ0RXFHZWlSYy8vSHcv?=
 =?utf-8?B?Nm5Wc0hCakF2RmswMHNHbHcxdkh5djQ4dkZWd2k0NHVNbzRPY211U3pIOTdS?=
 =?utf-8?B?YjZmT1lHWXpwMzh3Q3RFc3JNTTR1NjR5anR1WVEwcTlkVW1PT2ZnalJ6QlFx?=
 =?utf-8?B?Z3BHWUgyUDNWb01oMEtQUUJ4ckR3T3dzdkE0Q2F4ckJldXF5Uk1aWkxoMnJ4?=
 =?utf-8?B?Qmpha3pHeUdyYXdLcEZDbk5RdUZUWHVkZkRxbkNodDRnWWFoNmtaRVgzOWlW?=
 =?utf-8?B?d0tpd1BTd3kzUWFpb0hoVEJKM21Bc0RnYVJQdFpVaFVsdmhIaUJUNVNCTWtp?=
 =?utf-8?B?L0VQeUx3Y0ZrTEU5Q1p2MnBJeUp2V2RFRW90WU9ZTlA0YzAvSnhrMW0vVjBP?=
 =?utf-8?B?Y1hUUitJZTU4NGlYUzF0Wk9wT0ZicUlUK1VnRUNVSUpSS2hIWjBIY0ZQZm1x?=
 =?utf-8?B?NmtYY1BnOHBRQytDVE5nSXRQM1NkZzBGUGpVSldmU0ViMEtOdTFrTHNyZDBp?=
 =?utf-8?B?ZUdiL01QbmM5b0xLRnlTRmNDYnYyU21YRjJRdW52ZHRxQlBvS1VTWklMRU9y?=
 =?utf-8?B?Z1BJbHVrTWxBNTF0Y2R4dXNLV3RzZGc4OS9Zd3JyaE1scHhhbUJWcWFrSHpo?=
 =?utf-8?Q?ZTFJUwKj/vC0Ze7q2L+gPg1R5KTRPDLuL76AVsV?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5DEC37F7B8F5C40A031340AF0F8152B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6adc32ef-609a-4a63-f736-08d96c49a1ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 06:36:15.4196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SqhzsAbc5y1JGwG3kHPynvw7vIpTE76OmXOsnuewPNT3yRzSHzqFfJ0Xyylud5SFMfoEBYqw+v4e1H5b62PLMjiQE2+urF1bHNAEb5+UaGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2647
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTA4LTI1IGF0IDEzOjA3IC0wNTAwLCBKdXN0aW4gRm9yYmVzIHdyb3RlOg0K
PiBPbiBTYXQsIEF1ZyAyMSwgMjAyMSBhdCA4OjM0IEFNIEthbGxlIFZhbG8gPGt2YWxvQGNvZGVh
dXJvcmEub3JnPiB3cm90ZToNCj4gPiANCj4gPiBKYWVob29uIENodW5nIDxqaDgwLmNodW5nQHNh
bXN1bmcuY29tPiB3cml0ZXM6DQo+ID4gDQo+ID4gPiBIaQ0KPiA+ID4gDQo+ID4gPiBPbiA4Lzkv
MjEgODowOSBBTSwgSmFlaG9vbiBDaHVuZyB3cm90ZToNCj4gPiA+ID4gSGkNCj4gPiA+ID4gDQo+
ID4gPiA+IE9uIDcvMTAvMjEgMjozMiBBTSwgSnVzdGluIEZvcmJlcyB3cm90ZToNCj4gPiA+ID4g
PiBPbiBGcmksIEp1bCAyLCAyMDIxIGF0IDU6MzIgUE0gSnVzdGluIE0uIEZvcmJlcw0KPiA+ID4g
PiA+IDxqZm9yYmVzQGZlZG9yYXByb2plY3Qub3JnPiB3cm90ZToNCj4gPiA+ID4gPiA+IA0KPiA+
ID4gPiA+ID4gVGhlIFNhbXN1bmcgR2FsYXh5IEJvb2sgRmxleDIgQWxwaGEgdXNlcyBhbiBheDIw
MSB3aXRoIHRoZSBJRCBhMGYwLzYwNzQuDQo+ID4gPiA+ID4gPiBUaGlzIHdvcmtzIGZpbmUgd2l0
aCB0aGUgZXhpc3RpbmcgZHJpdmVyIG9uY2UgaXQga25vd3MgdG8gY2xhaW0gaXQuDQo+ID4gPiA+
ID4gPiBTaW1wbGUgcGF0Y2ggdG8gYWRkIHRoZSBkZXZpY2UuDQo+ID4gPiA+ID4gPiANCj4gPiA+
ID4gPiA+IFNpZ25lZC1vZmYtYnk6IEp1c3RpbiBNLiBGb3JiZXMgPGpmb3JiZXNAZmVkb3JhcHJv
amVjdC5vcmc+DQo+ID4gPiANCj4gPiA+IElmIHRoaXMgcGF0Y2ggaXMgbWVyZ2VkLCBjYW4gdGhp
cyBwYXRjaCBiZSBhbHNvIGFwcGxpZWQgb24gc3RhYmxlIHRyZWU/DQo+ID4gDQo+ID4gTHVjYSwg
d2hhdCBzaG91bGQgd2UgZG8gd2l0aCB0aGlzIHBhdGNoPw0KPiA+IA0KPiA+IC0tDQo+ID4gaHR0
cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L2xpbnV4LXdpcmVsZXNzL2xpc3QvDQo+
ID4gDQo+ID4gaHR0cHM6Ly93aXJlbGVzcy53aWtpLmtlcm5lbC5vcmcvZW4vZGV2ZWxvcGVycy9k
b2N1bWVudGF0aW9uL3N1Ym1pdHRpbmdwYXRjaGVzDQo+IA0KPiANCj4gSXMgdGhhdCB0byBpbXBs
eSB0aGF0IHRoZXJlIGlzIGFuIGlzc3VlIHdpdGggdGhlIHN1Ym1pc3Npb24/ICBIYXBweSB0bw0K
PiBmaXggYW55IHByb2JsZW1zLCBidXQgaXQgd291bGQgbmljZSB0byBnZXQgdGhpcyBpbiBzb29u
LiAgSSBrbm93IHRoZQ0KPiA1LjE0IG1lcmdlIHdpbmRvdyB3YXMgYWxyZWFkeSBvcGVuZWQgd2hl
biBJIHNlbnQgaXQsIGJ1dCB0aGUgNS4xNSBNUg0KPiBpcyBvcGVuaW5nIHNvb24uICBIYXJkd2Fy
ZSBpcyBkZWZpbml0ZWx5IHNoaXBwaW5nIGFuZCBpbiB1c2VycyBoYW5kcy4NCg0KU29ycnkgZm9y
IHRoZSBkZWxheSBoZXJlLiAgVGhpcyBmZWxsIGJldHdlZW4gdGhlIGNyYWNrcy4NCg0KS2FsbGUg
Y2FuIHlvdSBhcHBseSB0aGlzIGRpcmVjdGx5IHRvIHlvdXIgdHJlZT8gSSdsbCBhc3NpZ24gaXQg
dG8geW91Lg0KQW5kLCBpZiBwb3NzaWJsZSwgYWRkIHRoZSBjYy1zdGFibGUgdGFnIHNvIGl0IGdl
dHMgcGlja2VkIHVwLiA6KQ0KDQpMb25nZXIgcmVhc29uaW5nOiBnZW5lcmFsbHkgd2UgZGV0ZWN0
IHRoZSBoYXJkd2FyZSBpbiBhIG1vcmUNCnByb2dyYW1tYXRpYyB3YXksIGJ5IGNoZWNraW5nIHRo
ZSB0eXBlIGZyb20gcmVnaXN0ZXJzIChhbmQgbm90IHJlbHlpbmcNCmVudGlyZWx5IG9uIHRoZSBQ
Q0kgSURzKSwgYnV0IGZvciBzb21lIHJlYXNvbiB0aGlzIHR5cGUgb2YgZGV2aWNlIGlzDQpzdGls
bCB1c2luZyB0aGUgbGVnYWN5IHdheSBvZiBtYXRjaGluZyB0aGUgZXhhY3QgUENJIElEIHRvIGEg
ZGV2aWNlDQp0eXBlLiAgVGh1cywgdGhpcyBwYXRjaCBpcyBuZWVkZWQsIGF0IGxlYXN0IGZvciBu
b3cuDQoNClRoYW5rcyENCg0KLS0NCkNoZWVycywNCkx1Y2EuDQo=
