Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F1730558E
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S316958AbhAZXMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:12:49 -0500
Received: from mga06.intel.com ([134.134.136.31]:25279 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727000AbhAZVeB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 16:34:01 -0500
IronPort-SDR: iTzyPgBu7H+i9Vg1WHh9B1wAB7mbpEz/nit4T7AXQH+yUUQVkF8gIVOf9zkRwzSEiQbtuNkZy7
 IVM+JfyU5UpA==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="241504696"
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="241504696"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 13:33:16 -0800
IronPort-SDR: qTahF30TWBNaaKENofM3d8Yk87sUl/MNF7XqE5erlwI9eH/ORDeRiTrVNbJvX2qF9pvnrRwPoB
 +9u7D8Ikb4DA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="402882693"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga004.fm.intel.com with ESMTP; 26 Jan 2021 13:33:16 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 26 Jan 2021 13:33:15 -0800
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 26 Jan 2021 13:33:15 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 26 Jan 2021 13:33:15 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.59) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 26 Jan 2021 13:33:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9VzMlG7R+8dcitQrQ4TKArTXTLfuNtrH1aK1vOprG0ZgDGPNRoeliQZAphs0rrSDcE0ZrVhzt0MXjdgY4fT0S1d4uRXUCTVxqBF59I6Mk1GAKtGA7L3p/YJLsvEXADprwwwW/mT8tOCnYxL6gQp3lwzzwwCFXCN/AdIgCYLZdj8w7wJCiAe04olbt11EUM57X3edvzCcbc0jIeb3yZ4WpLuDBoJckRcE1OhBk9WPRpaqHbtNVrcQLKTW9Mn9Fq7NgltUhrDDfUKbh1Ewlh84BzHIe/uYQZQTK5RNLAQoRKE5dUbwq/L8TL9x+5LDZTxirwMBuxxh1VAlg2OOlB70A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjtRPmtPC/QGZXq45h5PhYJaZrWK+v83x3/+/4co/IY=;
 b=m8znRa/uHNDyW7IkT0dZ/vn1SMVQsU80GEK7DcoxnSF2cuK7JE9Dn1umg/mi2/FEHgsHnu1Rxtuh65KxiF7ahJCdX4PlLQ/34UQraktIzUXirCKsgOna0PqQ+H9h/xCPx78bGyN0bajYHRCr7N2+aeuEznfYp8ZXrTjT8qzqlvYM3aHRzZ6Jv8rBP/e85er15XpiKK/rvWanWlphClALHQnuJ8OxnuIBkMQgDjsrSQcY3ywxJjaVv8yjHGhlsQL8LaLADHp4wTniZcAHg6/Gd3GnSp6MF9vfhfqcHGC8LcuLoX6jcne9E3svA0/Yhy0gm88PY7kEh7oZq8WyGeBReQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjtRPmtPC/QGZXq45h5PhYJaZrWK+v83x3/+/4co/IY=;
 b=c+psCnoL9lO6CASKVxFQRH5tS8ubVPuDUAJ7vRvhGqUGMZbUO1dwmJDVCAY1t6UClsR+o06EiguAqr6dGzeZmKMjzddMRwbpVJ+7UfZF1XZqFsYC0i7pYozUyuQRzX+tX9nbLQdOM3RQoFjqyPftrASVXG1CxSUGv2G9tyWdVrw=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB2926.namprd11.prod.outlook.com (2603:10b6:805:ce::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.17; Tue, 26 Jan
 2021 21:33:12 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::fc53:e004:bade:6bc6]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::fc53:e004:bade:6bc6%6]) with mapi id 15.20.3784.017; Tue, 26 Jan 2021
 21:33:12 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Raczynski, Piotr" <piotr.raczynski@intel.com>
Subject: Re: [PATCH net 4/7] ice: use correct xdp_ring with XDP_TX action
Thread-Topic: [PATCH net 4/7] ice: use correct xdp_ring with XDP_TX action
Thread-Index: AQHW8RpOQZCVmeFd8Em7tvODHjqbB6o2JmuAgARNEYA=
Date:   Tue, 26 Jan 2021 21:33:12 +0000
Message-ID: <b94616ccb26b669154cca29021294dec06eecc9f.camel@intel.com>
References: <20210122235734.447240-1-anthony.l.nguyen@intel.com>
         <20210122235734.447240-5-anthony.l.nguyen@intel.com>
         <20210123195219.55f6d4e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210123195219.55f6d4e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6fc83ff-42ec-47c5-a293-08d8c241fbe6
x-ms-traffictypediagnostic: SN6PR11MB2926:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB29268B2F08AD2BEABCDCE29FC6BC9@SN6PR11MB2926.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5UQSumT/E7pV1YvWWurpJSPOfRW5mbj3hh1o7FS7j5c/pg+mGi20bzDTjsSo4jtDDV189fuPJg3tfOT5ssIrQHwKeEyz2dCsDIR2nJoCvtmSts5fEkZjOWZnA1xlJLD2LBKXaOmIf+SJhgcLvihdlw3Ncd7dWr7PDwi73osI6d2+8bj9w6rpD6v7TAPtr1licn9HPKweoF1Jvn7KCGXOuSDTlhu4nlhtoV2pnKIucHTWiPDxQ2i6zAhifDHoRqRT6u62MVNfJFrKFcGYMj09MV1e6B/0EVlMsX5c6oXuH/t+ZINkDG8eFbW8dhBM2IOHB//KvFXzgvZtgaz33Ey9TbOu8+YohQUcwUuckeoJGHoDQG8rOSswEJd/9Q+hPTUf/wEG4fefts5HnE3Nh8CJisYQ7ua9Dpz2Zn8xWunPRSdwgZoaBbf9tNLi7fYjnDhgBbUHIJQFa03jsaHYbBvbrLRYUvb93+TGiBs4NIgCefRnF5V4WHcHMnUX5EXJGfOVN3/EmNrHdTYMaJNOzGGnlXbUlr+7NvadVprv57dNlc5jyf3N1cDHxiSAdBZFUWNS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(366004)(39860400002)(83380400001)(26005)(8676002)(36756003)(76116006)(66946007)(54906003)(2906002)(86362001)(91956017)(6506007)(6512007)(66446008)(2616005)(107886003)(71200400001)(4326008)(8936002)(5660300002)(186003)(316002)(6916009)(6486002)(66476007)(66556008)(478600001)(64756008)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MlBhNk45TFphR3pPdFlXUjdONmc1eGhqbHhLR0dXNVhyeG5saWtxTDlYdlJU?=
 =?utf-8?B?M2VMbFFoYzJlZGdqbWh4K2hnNHF4WHFscFBIbVQ0UHkrRTU4NW5oR1R0Z2gx?=
 =?utf-8?B?ZFg5UGsyWm8vcE9PZW4zTjBraEQ5aXAveUNLNDRjalF5WXZTUm44anRJRUZh?=
 =?utf-8?B?K2xnd1BEOEw4TnpJL3lTRlc1ZlNKdmpGbm9Pb2ZzTk43WGZyM1Vzd01kLzBi?=
 =?utf-8?B?aWE0NC96NEJvSXFkSmJHOEpKVlkzdDlkSElRQkdKKy9wMkhLQzZYYjJUVHJp?=
 =?utf-8?B?TzJGUGszZzhVa0Z5UXdwZHMrNzNTUDJtRUtJOEJYRGRqNk5uNVlPckV6VVBt?=
 =?utf-8?B?VFpwbldqSmxQTkkwejVwVVdZRkx3Z0t3VVIwZ2F2YkU2MU5XQlpVOGxBSnFz?=
 =?utf-8?B?aW9OMEFWWDVFM0dNRHN2WnM1a0RKMk1JRzlEMkpaaVJMWEEwWlduQlA1RS9m?=
 =?utf-8?B?RTRzWUFHK1dhNDBpVFdZTGFKajZEL0lpTFhWRml6WFdLNFNWUnZ2ZTczVS85?=
 =?utf-8?B?cTJvWXZFWnp3emVJVUVOQXNhSFYzRDl2Yzd0eGZvN1ZQNy9FWENQU3RvZGJK?=
 =?utf-8?B?SkZya2tYSUN2KzBuaExyQXo2N0k0R3FQNitIc3pBeUNvR1pReVZLMU1sM2dB?=
 =?utf-8?B?MVk1bzFkVUMvRDNWeThuTjdzMzFnTHF2Q09JOWtzTXFUN1RzbnFGVVhiQnRJ?=
 =?utf-8?B?czN0YTgxUGRldG1vL2dsSHkrSjhaV0JjMWNNa2I3MWNBbXJpbzlNTWp2UWlo?=
 =?utf-8?B?Y0EyejgyWU1lYVNrZ1VVczVIVHBUMVNaaDgvaGJCSjlwRVlHVWZGY0pUdWRs?=
 =?utf-8?B?VFdkTHI4U3NmZGNZTmVaa212cDZTUkt2aWxTbHdITDFwaVZXQVFSK1ZUUzNV?=
 =?utf-8?B?RnRqcUhEd2tWWHFaM1pMVTY3OC91TlpVQlZ3S2ZSVW1BM29YS1J4RGNid1FZ?=
 =?utf-8?B?RUd6MmpsQUF2TW5oSzRuRGR3RlpzbG94TWhOeVlDZU9uZThMZTVzWHBZVlM2?=
 =?utf-8?B?Z28zRC8vM3Z1LzBxT2w3R0pwN1lVS0p5b0VnN2xPWi9UNHFBdEc3ZUJKTnpD?=
 =?utf-8?B?K0pwNkwwbGxHcDRHUk9nMWxmT0xzTGVsSW5Va1d3R2lrUlZxYkJqbTdCbWh1?=
 =?utf-8?B?YWxqUEF1VWN4NGtqQUJrZnJLUDBSWVJadmhvNURiREhzL1JkNjlYWFhGZWJM?=
 =?utf-8?B?OXhYMVJOMjdkNW8rdFFEYmJGWEFQRWo0QVUyZ3NGM3hiaVZnRjA5M25hTG1Y?=
 =?utf-8?B?VUJMeUxyNGFPRGN6MVBWam5DYVZiTUpxTFo3ZXc0NmFkRGh6MklEcFoycU5N?=
 =?utf-8?B?V0lNakRtRnorSFhmN25oaVlvYktBeDNhbm9KaER3S3Q2WS9NYWw2YTBiVDZP?=
 =?utf-8?B?Tmg2QjloT0dpWVdOOHRCb2EvOWU3Nm1XK2o5cHpVbkxESWQvSWVZemZCUUZH?=
 =?utf-8?B?Y0kzQkhhZzRLd2p6aXBBVDVUaWl5R0QvRk5PS2d3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <272E5F70CD932444BEBA66ADA02BC77B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6fc83ff-42ec-47c5-a293-08d8c241fbe6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 21:33:12.6524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W0trbfxWjStwZoxc6GnLAdl6n13Y24Sv3t/CwNIWRHD7UOstYQeKaMp7yh686ReuY2NY8SqPoCGW+o50FKIYpfuC+WlvXuhXDpP9Cv1DlK4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2926
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIxLTAxLTIzIGF0IDE5OjUyIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCAyMiBKYW4gMjAyMSAxNTo1NzozMSAtMDgwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiBGcm9tOiBQaW90ciBSYWN6eW5za2kgPHBpb3RyLnJhY3p5bnNraUBpbnRlbC5jb20+DQo+
ID4gDQo+ID4gWERQIHF1ZXVlIG51bWJlciBmb3IgWERQX1RYIGFjdGlvbiBpcyB1c2VkIGluY29u
c2lzdGVudGx5DQo+ID4gYW5kIG1heSByZXN1bHQgd2l0aCBubyBwYWNrZXRzIHRyYW5zbWl0dGVk
LiBGaXggcXVldWUgbnVtYmVyDQo+ID4gdXNlZCBieSB0aGUgZHJpdmVyIHdoZW4gZG9pbmcgWERQ
X1RYLCBpLmUuIHVzZSByZWNlaXZlIHF1ZXVlDQo+ID4gbnVtYmVyIGFzIGluIGljZV9maW5hbGl6
ZV94ZHBfcnguDQo+ID4gDQo+ID4gQWxzbywgdXNpbmcgc21wX3Byb2Nlc3Nvcl9pZCgpIGlzIHdy
b25nIGhlcmUgYW5kIHdvbid0DQo+ID4gd29yayB3aXRoIGxlc3MgcXVldWVzLg0KPiA+IA0KPiA+
IEZpeGVzOiBlZmMyMjE0YjYwNDcgKCJpY2U6IEFkZCBzdXBwb3J0IGZvciBYRFAiKQ0KPiA+IFNp
Z25lZC1vZmYtYnk6IFBpb3RyIFJhY3p5bnNraSA8cGlvdHIucmFjenluc2tpQGludGVsLmNvbT4N
Cj4gPiBUZXN0ZWQtYnk6IEdlb3JnZSBLdXJ1dmluYWt1bm5lbCA8Z2VvcmdlLmt1cnV2aW5ha3Vu
bmVsQGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBUb255IE5ndXllbiA8YW50aG9ueS5s
Lm5ndXllbkBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2lu
dGVsL2ljZS9pY2VfdHhyeC5jIHwgMiArLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV90eHJ4LmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2ljZS9pY2VfdHhyeC5jDQo+ID4gaW5kZXggYjZmYTgzYzYxOWRkLi43OTQ2YTkwYjJk
YTcgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV90
eHJ4LmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3R4cngu
Yw0KPiA+IEBAIC01NDYsNyArNTQ2LDcgQEAgaWNlX3J1bl94ZHAoc3RydWN0IGljZV9yaW5nICpy
eF9yaW5nLCBzdHJ1Y3QNCj4gPiB4ZHBfYnVmZiAqeGRwLA0KPiA+ICAJY2FzZSBYRFBfUEFTUzoN
Cj4gPiAgCQlicmVhazsNCj4gPiAgCWNhc2UgWERQX1RYOg0KPiA+IC0JCXhkcF9yaW5nID0gcnhf
cmluZy0+dnNpLT54ZHBfcmluZ3Nbc21wX3Byb2Nlc3Nvcl9pZCgpXTsNCj4gPiArCQl4ZHBfcmlu
ZyA9IHJ4X3JpbmctPnZzaS0+eGRwX3JpbmdzW3J4X3JpbmctPnFfaW5kZXhdOw0KPiANCj4gQnV0
IHRoZW4gd2hhdCBwcm90ZWN0cyB5b3UgZnJvbSBvbmUgQ1BVIHRyeWluZyB0byB1c2UgdGhlIHR4
IHJpbmcNCj4gZnJvbQ0KPiBYRFBfVFggYW5kIGFub3RoZXIgZnJvbSBpY2VfeGRwX3htaXQoKSA/
DQo+IA0KPiBBbHNvIHdoeSBkb2VzIHRoaXMgY29kZSBub3QgY2hlY2sgcXVldWVfaW5kZXggPCB2
c2ktPm51bV94ZHBfdHhxDQo+IGxpa2UgaWNlX3hkcF94bWl0KCkgZG9lcz8NCg0KSGkgSmFrdWIN
Cg0KSSdtIHN0aWxsIHdhaXRpbmcgZm9yIGluZm9ybWF0aW9uIGZyb20gdGhlIGF1dGhvci4gSSdt
IGdvaW5nIHRvIGRyb3ANCnRoaXMgcGF0Y2ggZnJvbSB0aGUgc2VyaWVzIGFuZCByZXN1Ym1pdC4N
Cg0KPiBMZXQgbWUgQ0MgeW91ciBsb2NhbCBYRFAgZXhwZXJ0cyB3aG9zZSB0YWdzIEknbSBzdXJw
cmlzZWQgbm90IHRvIHNlZQ0KPiBvbg0KPiB0aGlzIHBhdGNoLg0KDQpJJ2xsIGFkZCB0aGVtIHRv
IHRoZSBYRFAgcGF0Y2hlcyBpbiB0aGUgZnV0dXJlLg0KDQoNClRoYW5rcywNClRvbnkNCg==
