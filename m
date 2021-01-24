Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BC9301AD1
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 10:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbhAXJNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 04:13:45 -0500
Received: from mga18.intel.com ([134.134.136.126]:47191 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbhAXJNk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 04:13:40 -0500
IronPort-SDR: DUL2ijlBmqpJ6KkyT0YJuE+dBh/NM1RHBlKU2HaOf+w4XQfLbliSimq6TkkuhV23zCJd0WCRQ0
 dxWkAHXbZjMA==
X-IronPort-AV: E=McAfee;i="6000,8403,9873"; a="167284917"
X-IronPort-AV: E=Sophos;i="5.79,371,1602572400"; 
   d="scan'208";a="167284917"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2021 01:12:55 -0800
IronPort-SDR: uzRZ4xqxfP8FqiIWzH3MnaZ2cDPN/a+FMm4MkctOJujdBM9qtctBzJMrGA3kgdlrm3v/XtdgAR
 RCZuS3BUum3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,371,1602572400"; 
   d="scan'208";a="386745033"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 24 Jan 2021 01:12:53 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Sun, 24 Jan 2021 01:12:51 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 24 Jan 2021 01:12:51 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sun, 24 Jan 2021 01:12:51 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sun, 24 Jan 2021 01:12:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EetjDf2RnW3olRxYHnKbbEfpyhRIlRjqxCHFTU92y4LRFJdPkBh0F13/zb6kZES7q7BhyTUtQh5Gws7AsE2n93HFwrjdJmxnVuDEfJGnRqPCcV+ksXwxY/Ud4DfBVjnJbGqyCn4UoQLzi9qikVNbYLa0WTxGvE6/6Qr1PdFBVDwL+IWdx8S8mEaG2g/z3gRLxu6pG9VtOv+LhPdezaTNjydLbY9+sQXxY1baMy4KAFkiLpg/7PtJeOSQAXbj60F3BLvHNHR3qZoRujsZp0WP9u+sU9TFl1zX5JULwK5rthz1JESd6bydSHWskqINeb9w4Uj0eKlcRunqM0MqgHeQ4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5xnBAQGNQbirri3t+N29TESohEwG0rI4P2mRZNrU3xU=;
 b=VuFQ7v+N9xsaf6ppK+0N+qCPyHNz1wKM6wjOhSoPQZ9M9MbWu7VLOBF+85V+ukvZiKgOswvZvIVPxFcMfiRC1EQJOPDKShmqKTcll50q1nOtSXd67jnJWY2cU2OIr/JyI+OSF96FQi/v4moUCIjyXB+CWEloz9UvrjhazhxOy8DkjxyTuHuuNoAEs568PiSBc6wdO0n2X8iawnbQ+4vG7KSQEBi6KNbA94IMx6TsAV3O61HrgVo/zFpHTdUbkMNS6g2HhjGBc3FO0/S2pHJOuECns/v4Ta+dgPMIvxhRKSlOCnci/T6U7bQ+jYB0JsGmQK8bX+RytNF/pZsRfdiDcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5xnBAQGNQbirri3t+N29TESohEwG0rI4P2mRZNrU3xU=;
 b=pwHTyPvxD++vaCRGTxN8M2FgUDSWDvsnT9yXAWBT2LOjteTZ39x2kRSP1sR2axYG8KBbUMQJfNG7vw9n2TjCtP/jYD/Wdtr6rHytCQis8cg/7rLXS/prDaBI5Eu9D8guvhosY0EzYi7VA1yMVp0DyGXS7VlUlaU8MuuxRKM3sHU=
Received: from BN7PR11MB2610.namprd11.prod.outlook.com (2603:10b6:406:ab::31)
 by BN6PR1101MB2195.namprd11.prod.outlook.com (2603:10b6:405:5a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sun, 24 Jan
 2021 09:12:49 +0000
Received: from BN7PR11MB2610.namprd11.prod.outlook.com
 ([fe80::7c38:d64f:7d96:e3c]) by BN7PR11MB2610.namprd11.prod.outlook.com
 ([fe80::7c38:d64f:7d96:e3c%6]) with mapi id 15.20.3784.014; Sun, 24 Jan 2021
 09:12:49 +0000
From:   "Peer, Ilan" <ilan.peer@intel.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Hans de Goede <hdegoede@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: RE: pull-request: mac80211 2021-01-18.2
Thread-Topic: pull-request: mac80211 2021-01-18.2
Thread-Index: AQHW8c8jkBQz+k7MdUGDMkmFqxx046o1xv4AgAC3TTA=
Date:   Sun, 24 Jan 2021 09:12:48 +0000
Message-ID: <BN7PR11MB2610052E380E676ED5CCCC67E9BE9@BN7PR11MB2610.namprd11.prod.outlook.com>
References: <20210118204750.7243-1-johannes@sipsolutions.net>
         <77c606d4-a78a-1fa3-5937-b270c3d0bbd3@redhat.com>
 <b83f6cf001c4e3df97eeaed710b34fda0a08265f.camel@sipsolutions.net>
In-Reply-To: <b83f6cf001c4e3df97eeaed710b34fda0a08265f.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: sipsolutions.net; dkim=none (message not signed)
 header.d=none;sipsolutions.net; dmarc=none action=none header.from=intel.com;
x-originating-ip: [147.236.145.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00cacb9e-4e66-4d30-6e99-08d8c048389a
x-ms-traffictypediagnostic: BN6PR1101MB2195:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB2195F6DF4EF5798836AEBF59E9BE9@BN6PR1101MB2195.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: op5PYqNuzpAmw1n3dBwylLmNkoEH1Z67h9eL7AcRgX0GgN3yuN7rNDF14peo7o5462pElzr6E5e/9ZmDl3QRaNCjGUMHXB5/wIkNy5B/121yOjbcxyfy26XrGYHAIKKfpGkhWRAFM3HUL7EpaeFvCj//yoKPZigVDsAFG7lYBQmFgV5f2yiGO7c1choNcaX6bPQsxX/eurVEPp/movnoDpF4eDfql6El7cZiiUSF+9K5JnZrRoEoQ4AANoWmz46sOGysXVkP/tUuoenBVuC/9Nv/y97Ec+fPhfu5nccmhRtkaLi7WjSn8kDgjsLN/Ovs1GFr9WaBE0K6ncThRjhn5aUVU6FIeSApO4CKNpynEhmeCnhC1jMkllWGduzv9iYekaXUUdpKimbizjEQa10iU+ak29JRYjSqbGnw7KVxZMmn3R1ckfk/iHMJhm8+AJ5v+FQ87DGgJ05Xz3y9QYWLwTwwL3BinLy2sBCI089Ww2vHpDLyfQ5Y8XssO6wll8XAmPel2tEl/pvzz4rpuAK/Ol68087xEEu5UQppiN9iWLpcj8yPv0uhMVL/UDHUk0o8K5Ns6vAIwvVZnYwYtEBVGm9ENydrKYIAFIKIt2DGBgQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2610.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(186003)(2906002)(66476007)(8936002)(316002)(107886003)(53546011)(966005)(71200400001)(76116006)(66446008)(64756008)(66946007)(52536014)(33656002)(66556008)(8676002)(6506007)(26005)(54906003)(5660300002)(7696005)(55016002)(9686003)(83380400001)(478600001)(86362001)(4326008)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NW5KWExNcFh0eWZWbGNpcnpmYUtFWFRkVE5wMjlCcUdQSEZJUkdMNW5CUUhP?=
 =?utf-8?B?cmJhaDN1ZHpjS0VOYUNOYndrTTc0cThLNjRXWUNscWQ1QTNwU2tubHg3NENG?=
 =?utf-8?B?YXJhREtseTVPM1RPd2Y3cUllaUdYNjBDRGJUOHY4aE1SV1pTY2FtM3krTmdR?=
 =?utf-8?B?UFFyOTdNeUNsbU55dGtkbEJTR2IzdU0xSnB4SmpkN25SNXFyNW44NTNkUkF1?=
 =?utf-8?B?MWRiaXVTUVZPUWF2SUpCQ054bFlyRGZsL3dXTndCNXNUVi91amU3L1FUWTcz?=
 =?utf-8?B?bTd4b01KZ3Q0SDFLcSswQVR1Z2N3SllNd2ROTk4xaEhqTk8zZ0xybk5HV0Ni?=
 =?utf-8?B?c1NtSk04Z1pBOFExU0Z0Vm96YmNWZFFpbHlOZjg4SnhoV21RSTYrd3ZOWUlz?=
 =?utf-8?B?TThKMlY0WldCTmQyNWlGSVZPWEQ4ejUyd1lNRWpyYU5KVzJsV2pta3JhWGhW?=
 =?utf-8?B?T2Q1dElKcUphb0N5MFY1YVM3N1VPb0NxdkFUTHRUb3N0ZWhGVmk5VFU2dGl1?=
 =?utf-8?B?Tmg5ZVMySnhNOHlVYkU2OHl4UVVycEVuSWNaTE5xWGphOHRrZHZTam41aUc0?=
 =?utf-8?B?UmxXKzRmaHZSZktrYjQxTldLTUdrYVROVy9WNEdTSFNJVkxZTDJzRVVZZUNm?=
 =?utf-8?B?aDVaUGgwaVhvTExva0FiR0ZTNDdNcHo3dEJBRlI3Q1F1V2VHc1FqYVRqenFX?=
 =?utf-8?B?YnI0NHJmUlg2TXIzWVljNjU3K2VzWVhmUDdxOStFUnBPTlE1bnRPMkVuM2tM?=
 =?utf-8?B?RWJxWVY4V0hvalVvVHhJZE14eWFkTFdGRjQ3RWJub0hCeVdUT2hIRWljenVo?=
 =?utf-8?B?YlhWZ0tKSkp0dzkwQlFST2lOWCtJUXR0dGlTMjErQmcrOWQwT2QwWktlR1hm?=
 =?utf-8?B?VlFuRE1KS1BnREk0UDNHZmV6SDdWaXNzalNRTlM5Z2MyVVQyRU5zMjU5VUx5?=
 =?utf-8?B?MkhxMTJpWlpyWEF1Y0Q1MVZ0VFhYNitvT2g3YTdFZm1XZFFtd3NpcHdaOVZk?=
 =?utf-8?B?MzBYNWhXekFCT1NxSFo3amlmdzcwKytGZnVLMldnbzV4V0xncmhpN2FMdEor?=
 =?utf-8?B?cGQ5SFF4Vk1iaVpramZ1Q0EzVWhFOGhtUmxtbkcyeHdzaHc2Vm05QS9XcUZW?=
 =?utf-8?B?SUpJd0dnMzE0NktFRlJ5My9BZ3AyUjQyR1R6RjRlZzhqUFdaQjdNTmlrMmZT?=
 =?utf-8?B?SDdMc0M4SU5sclRRdmZ5bkxudEtwYlJwRlFjTm1keGhuS3dhV2tiT0NyNTZ6?=
 =?utf-8?B?dkhuZWNkMlA3Z3QzQnVKTXhCQXl5eWhWeU4rU2RqTVBoSVgyQytHNmhybTQv?=
 =?utf-8?Q?/NogdLAdYhnO4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2610.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00cacb9e-4e66-4d30-6e99-08d8c048389a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2021 09:12:49.1459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1LeWehRAF7yTlUNNky1t8OhjYpZR75p8flLBMs0QTd7G86xut07EYNvNAzPzIeZPY9fd5ucO7/5pPOCatolbxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2195
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2hhbm5lcyBCZXJnIDxqb2hh
bm5lc0BzaXBzb2x1dGlvbnMubmV0Pg0KPiBTZW50OiBTdW5kYXksIEphbnVhcnkgMjQsIDIwMjEg
MDA6MTYNCj4gVG86IEhhbnMgZGUgR29lZGUgPGhkZWdvZWRlQHJlZGhhdC5jb20+OyBuZXRkZXZA
dmdlci5rZXJuZWwub3JnDQo+IENjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IFBl
ZXIsIElsYW4gPGlsYW4ucGVlckBpbnRlbC5jb20+Ow0KPiBDb2VsaG8sIEx1Y2lhbm8gPGx1Y2lh
bm8uY29lbGhvQGludGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IHB1bGwtcmVxdWVzdDogbWFjODAy
MTEgMjAyMS0wMS0xOC4yDQo+IA0KPiBPbiBTYXQsIDIwMjEtMDEtMjMgYXQgMjI6MzEgKzAxMDAs
IEhhbnMgZGUgR29lZGUgd3JvdGU6DQo+ID4NCj4gPiBTbyBJJ20gYWZyYWlkIHRoYXQgSSBoYXZl
IHNvbWUgYmFkIG5ld3MgYWJvdXQgdGhpcyBwYXRjaCwgaXQgZml4ZXMgdGhlDQo+ID4gUkNVIHdh
cm5pbmcgd2hpY2ggSSByZXBvcnRlZDoNCj4gPg0KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2xpbnV4LXdpcmVsZXNzLzIwMjEwMTA0MTcwNzEzLjY2OTU2LTEtaGRlZ29lZGUNCj4gPiBAcmVk
aGF0LmNvbS8NCj4gPg0KPiA+IEJ1dCBpdCBpbnRyb2R1Y2VzIGEgZGVhZGxvY2suIFNlZToNCj4g
Pg0KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXdpcmVsZXNzL2Q4MzlhYjYyLWU0
YmMtNTZmMC1kODYxLWYxNzJiZjENCj4gPiA5YzRiM0ByZWRoYXQuY29tLw0KPiA+DQo+ID4gZm9y
IGRldGFpbHMuIE5vdGUgd2UgcmVhbGx5IHNob3VsZCBmaXggdGhpcyBuZXcgZGVhZGxvY2sgYmVm
b3JlIDUuMTENCj4gPiBpcyByZWxlYXNlZC4gVGhpcyBpcyB3b3JzZSB0aGVuIHRoZSBSQ1Ugd2Fy
bmluZyB3aGljaCB0aGlzIHBhdGNoIGZpeGVzLg0KPiANCj4gT3VjaC4gVGhhbmtzIGZvciB0aGUg
aGVhZHMtdXAuIEkgZ3Vlc3MgSSdsbCByZXZlcnQgYm90aCBwYXRjaGVzIGZvciBub3csDQo+IHVu
bGVzcyB3ZSBjYW4gcXVpY2tseSBmaWd1cmUgb3V0IGEgd2F5IHRvIGdldCBhbGwgdGhlc2UgcGF0
aHMgaW4gb3JkZXIuDQo+IA0KDQpUaGFua3MgSGFucyBhbmQgSm9oYW5uZXMgZm9yIGhhbmRsaW5n
IHRoaXMuIEknbGwgdHJ5IHRvIGNvbWUgdXAgd2l0aCBhIHNvbHV0aW9uLg0KDQpSZWdhcmRzLA0K
DQpJbGFuLg0K
