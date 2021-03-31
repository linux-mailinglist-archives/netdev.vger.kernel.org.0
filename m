Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9F434FBEE
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbhCaIwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:52:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:64089 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234375AbhCaIwB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 04:52:01 -0400
IronPort-SDR: NV2LGWcqNqvhy2jF1T2oUZVtcRt1ARlB639QlHS5dOSgUHs4OnVu8qrQrQH05dpt2peOKkScGi
 faZaNpskKzUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="179082754"
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="179082754"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 01:52:00 -0700
IronPort-SDR: uuI0AUHjTzzjSO0NTvn7wOofetEFpGAGYTK8ZtHxTJl5DGkQuTqaeRWvithk8uHeQ/6wGQQ9gf
 KctLXYK7fofQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="384329769"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga007.fm.intel.com with ESMTP; 31 Mar 2021 01:52:00 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 31 Mar 2021 01:51:59 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 31 Mar 2021 01:51:59 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 31 Mar 2021 01:51:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQ2LNZB9cTKN2lfa1yGfl3B/UcQjkmChnMKe0sheadulNQ4IsJf2KhSuUmX/Asys0FG3gVne1sGNj/Hp4HtQNJrd2phvS68lCVQCapXdGa2a15PL8Y3MW97aj/0qRUtPJ+kYt6ODiZLV7ZaDzDJcHnGc+fZL8m6DsoRxEAGQ/UKiIPkvujCEcutzhfaF8I1p4u4XSshhd5L/l583MtWOasPfuc/1JtcaBw9HspKf9DGuRDG6Z8lT4rcRE3gKx5mkEM4uu1cwbMnYWixJy/bNGdXkizljQTOkR/nOVk1qiEUEklGI9obHWyfcRwO8Mmsm1CqmMnmTLb4RDTxOGmwPNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y07+bwqJCkpnfn/1NgCQKgyFg1W2WC/OLwasn4ZeNZI=;
 b=gtk+GY9r9v3W3cu3mAeNxi5Dk/gwv/MUhqYgskOkDplLw5NYWM+ffL97M7eO6YN0xnP5/zfB/Ogs3zukJbWrE430HsJtGu59+AEOTUiLB8iVqn+fQpaPbvTeHeQ+3UqkggghW20bcL5krExc1IkZAh2B8Ns80gmfR9ZrKMv3aXisBNuDR/jkKEkXl2Mo9J9jVT2V8PINHcmelPEu062OKKWR+rO0Q3UQKWC7g6KxuXfG7wzXoAdejs3tm1bU7iUcu3XiGLRzaXJKAzmaZJ6doXjgMbVhK8a3TDoe/hJtkn2gtZ4s2rhW4YQ24K8IkwkIIyj+8wDx1gwpOp5/x/904w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y07+bwqJCkpnfn/1NgCQKgyFg1W2WC/OLwasn4ZeNZI=;
 b=cygkQnf+71+SSulnQ5j50H/0RuZbp1gsQL3uzqQjixFZlWdmU2BB/zR2eGGPmjZCdvs/Jp5yA+YrZLehM4TCI8cJ1le6xAs8u3Q4DsZtMBGnGvy20n8lqX8PZ9w8iWF5cvgh6KqVSToG4d2atCvsb2/wRpaxBCnkFGT9jKNMYJk=
Received: from BYAPR11MB2870.namprd11.prod.outlook.com (2603:10b6:a02:cb::12)
 by BYAPR11MB3511.namprd11.prod.outlook.com (2603:10b6:a03:84::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 31 Mar
 2021 08:51:57 +0000
Received: from BYAPR11MB2870.namprd11.prod.outlook.com
 ([fe80::4156:a987:2665:c608]) by BYAPR11MB2870.namprd11.prod.outlook.com
 ([fe80::4156:a987:2665:c608%5]) with mapi id 15.20.3977.033; Wed, 31 Mar 2021
 08:51:57 +0000
From:   "Wong, Vee Khee" <vee.khee.wong@intel.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
Subject: RE: [PATCH net-next] sit: proper dev_{hold|put} in ndo_[un]init
 methods
Thread-Topic: [PATCH net-next] sit: proper dev_{hold|put} in ndo_[un]init
 methods
Thread-Index: AQHXJfLlYnfPSEPG/UKDClJFH/PWf6qdyZDQ
Date:   Wed, 31 Mar 2021 08:51:57 +0000
Message-ID: <BYAPR11MB287086509523539BEE534208AB7C9@BYAPR11MB2870.namprd11.prod.outlook.com>
References: <BYAPR11MB2870B0910C71BDDFD328B339AB7C9@BYAPR11MB2870.namprd11.prod.outlook.com>
 <CANn89iLnzN6n--tF_7_d0Y1tD6sv3Yx=3H+U_iYbeC21=-r92w@mail.gmail.com>
In-Reply-To: <CANn89iLnzN6n--tF_7_d0Y1tD6sv3Yx=3H+U_iYbeC21=-r92w@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [218.111.199.186]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b71df7a1-355e-44c0-5492-08d8f4223df7
x-ms-traffictypediagnostic: BYAPR11MB3511:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB35110AB49FEC81741F98BAC3AB7C9@BYAPR11MB3511.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hEluJTLLgBm/jIZTGOqQeuMANjaLt0/K7pFeSjXsxLXRaT+hfVwVB/iRFu2NZoJU03LBnKQjsNmLifWTrLDGMeQ+3rhlfGP75+983yUp5ATE/FouP7oju6pFZvkSZTelaAOyItEQZGQDJ/tiMZQr9D2CDR8ro4E5sXWOxbg1uU7txCJ6mFkUeDBTepmuHihuvgzy+qBJ11pp3lT13+idcwvVmmgpD6teR0gMvGZrXlFLxb1PSmdRGh1eLcC4FoHrbyNWRZ3vXK0/mBKCgFW3L2HV34iNkT6vrF4h5v11UO+vtII8z+XUd619hjBR059XgGG7pQm0erbY90D00TyjP3k6jQVJA+loyBWS9qFj4JmeIrjsY+pnnNzZ0EHZNEWm3BD6eHACHyaoybNic+8KE3TCSz4oVfJJxscAEufP/dIeTBchdgnd65XnJNfdWeQkic+tuyJJFVF8AB20WXuIBFScPhdA3nkoUfILwyHN/0b8vcj3exTRDECSe0UpwK0GUa36qBc4CjGggEFFE8V1lJ/9e57l2eW/qys6egAk+pNury9x09FaIR42P2FVN+rUbZmRLvB2jniEKRgDNbfqE5t3+COt9DGuZHG9yqpcjVxRuDia8IqpF8Wd43zo63Tfv0a5vpOTJ1gdH7WpBUKh1UrARtUpFNFinWMwmm+C8nn6b+W0wcQHtZZJVrdeK/6j0KNl8b5Al4TiITfvhe3kGUHcU2C79LR2zqR84OUcNbw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2870.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(376002)(396003)(136003)(5660300002)(53546011)(33656002)(8936002)(86362001)(4326008)(6506007)(478600001)(71200400001)(107886003)(8676002)(966005)(66946007)(76116006)(66476007)(66556008)(64756008)(66446008)(186003)(38100700001)(54906003)(2906002)(55016002)(83380400001)(6916009)(9686003)(26005)(316002)(7696005)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Z1lWdGtGbG1teW9HUjI1QmxrZnhmZUZmNVNiaTIrSUt2RGRWenBCOVlPcFlK?=
 =?utf-8?B?QStQMGRUV2VONFlmV3hLNU14SGtKbDM1Tkd4YVdta3RtUVZLY2xvcHg4SGtr?=
 =?utf-8?B?Tlo2ZW9MZ3RSTVVIUmtQL0NHdVE4Qndwc2RMbWxpZFZyc0RiaXJ0N0RFMCtz?=
 =?utf-8?B?MzFOb1hoMEJDRGhQRGc1TWVLTy8yM2hrVGc4cDdwSzc3NjdoUGNCY2VxWDZY?=
 =?utf-8?B?MkNSK0F6NFBwZGNEcEhINzhnZisvUm5MWHFsVGFnbEZTeTRkT2ZyR3VrTDBO?=
 =?utf-8?B?YkFOOUJXRVNMQ2R5RjN2RHA1U3diZklXNnRlMTRRa2xlV0E5djZPWG16VFBj?=
 =?utf-8?B?anVXdEt5OUVwRng2WTdUcFdTdFlQL1l3WnFkbDduWWFTL201ZUZGRkVEWEFy?=
 =?utf-8?B?NzZ1bTAybm8vS2xxa3ZDN3pwenVMaGpCUmZRdGo0RnVPam8rK3BRMmJjczE2?=
 =?utf-8?B?RXJ4aTA3ZUttbG1WckwzNGd1bjVKc0xYMG1laDFiL0JacUtnY1VRQWFnM1Jt?=
 =?utf-8?B?NkJGQ0x4dS9aRXlLa2VOc0l6QVJIbHhweUN5ZEdJekNjMTJvNFMzZWIvSmhI?=
 =?utf-8?B?YnN5bVdVQWZCQzJkeXRIcWliNUM3NVpGcnVob1pjTlpkUGhlYnJaVmdtdEla?=
 =?utf-8?B?bGRXaUUrZENiRTM0VXRncFRDWWhWdjR1c1BmRkxzZjk0ZW1wVTZPQnF2L3Nh?=
 =?utf-8?B?bXJ6RE9TTjdIOFM3bjNGNTczLzg5UmlpeHEyWjJnMXVxdW1kUHNUWW5mYWd3?=
 =?utf-8?B?QkVQRVRybFE5OVZpTml2ZEVOQmUxUHhYbzBobkNBSnV2S1o1U3hFY01Sb2lD?=
 =?utf-8?B?dk9zaG5obVR1U0RNN2luQW0zQm9BaWlEV2RuTEU1Y253b09kTU03Vmg0NGxj?=
 =?utf-8?B?MlNtTEc3QUpRZjErQXlWVDVDYkhqR21SZm8xOVI2MzhUV1Y0K0xwY29RRXFm?=
 =?utf-8?B?a1o5QkhRNlZkckdmT3pLUGtCRklwOGk5T3dvT1pvSVpZSzdSYUNvOGJxYmZX?=
 =?utf-8?B?SHhlV2pWNDFtcG1mY3VNd1N2OWNHSEp0YTI2S2RDNWVqeWdIb1JNM3VERUhU?=
 =?utf-8?B?WWlhaHplTnFCWmc1SE9oeGt4TThHamMwTzFObS9tbDFKMXpQQkNYcnFET1F4?=
 =?utf-8?B?b1VlS2NzSWhFTG5nL1k1eVpQa3EyY3hPcGxxaHMvWVZaVTEyNlE0dTdUeVQ4?=
 =?utf-8?B?blhYMWJ6SjB4S1VRbmhVT3YwL1RWK09VQlVpcEwrSEFqWm5yNGQyeVBpb05t?=
 =?utf-8?B?cVlySDRScmVEQ3RFaE9GYVpWSnY1UDgxa3pEUnVJTWxmRmw4Z0I4NFN6L3Ji?=
 =?utf-8?B?ZFlXczAyYjNkTko3Lytpajk2YVR6aHFucGwxYWMzY2FHeVhvSW9ZdlAyWVJ3?=
 =?utf-8?B?TENkM3hLTzJMWnRoVXAya3hBckw1QVl4TFF6NEVtMDVSL01adVhNUU9nK2Rs?=
 =?utf-8?B?dTVDcVhVUnJQcFlTcUJzNloxcng3azdaZXFZekxtZmJWWmh3aU5USnJLd2Zw?=
 =?utf-8?B?WWg1OGNNZnpoRGRYNGZZZGpyU1M1MzBya0pKeFVReVVhRXRhbXdqTy9XRlo1?=
 =?utf-8?B?cURZMDE2dzJiVFVQRWFaQzUxUjNNMWxGK2ZvSEgzdDlRWFNweVZacVliZS96?=
 =?utf-8?B?bVFnZ0JteTJiSmRPdEZPaWFzb0h5RmpaUmF3b2NORG5lWlNQUkJ5OXZxbWdC?=
 =?utf-8?B?aTRJeVlrcGRVRkQ5WHBhaWxNZXhUM1VIQ2NiQVdEYTFRUE1zSW56WlQvQkFo?=
 =?utf-8?Q?ElbwyoFggREQQpN3Z5IDOc/sRkJC5EHSEEvhn0I?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2870.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b71df7a1-355e-44c0-5492-08d8f4223df7
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 08:51:57.7420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MKk3Coq/uXcb1m212/fjTN+9LtF8wRxi+3zv8Wlc/dilJyE5iRjPBHRZ7mOEfIuBp+z54wUX2VB9TiUFS6hOJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3511
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBNYXIgMzEsIDIwMjEgYXQgMTM6NTgsIEVyaWMgRHVtYXpldCB3cm90ZToNCj4gDQo+
IE9uIFdlZCwgTWFyIDMxLCAyMDIxIGF0IDI6MDEgQU0gV29uZywgVmVlIEtoZWUNCj4gPHZlZS5r
aGVlLndvbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+IEhpIGFsbCwNCj4gPg0KPiA+DQo+
ID4NCj4gPiBUaGlzIHBhdGNoIGludHJvZHVjZWQgdGhlIGZvbGxvd2luZyBtYXNzaXZlIHdhcm5p
bmdzIHByaW50b3V0cyBvbiBhDQo+ID4NCj4gPiBJbnRlbCB4ODYgQWxkZXJsYWtlIHBsYXRmb3Jt
IHdpdGggU1RNTUFDIE1BQyBhbmQgTWFydmVsbCA4OEUyMTEwIFBIWS4NCj4gPg0KPiA+DQo+ID4N
Cj4gPiBbICAxNDkuNjc0MjMyXSB1bnJlZ2lzdGVyX25ldGRldmljZTogd2FpdGluZyBmb3Igc2l0
MCB0byBiZWNvbWUgZnJlZS4NCj4gVXNhZ2UgY291bnQgPSAyDQo+ID4NCj4gPiBbICAxNTkuOTMw
MzEwXSB1bnJlZ2lzdGVyX25ldGRldmljZTogd2FpdGluZyBmb3Igc2l0MCB0byBiZWNvbWUgZnJl
ZS4NCj4gVXNhZ2UgY291bnQgPSAyDQo+ID4NCj4gPiBbICAxNzAuMTg2MjA1XSB1bnJlZ2lzdGVy
X25ldGRldmljZTogd2FpdGluZyBmb3Igc2l0MCB0byBiZWNvbWUgZnJlZS4NCj4gVXNhZ2UgY291
bnQgPSAyDQo+ID4NCj4gPiBbICAxODAuNDM0MzExXSB1bnJlZ2lzdGVyX25ldGRldmljZTogd2Fp
dGluZyBmb3Igc2l0MCB0byBiZWNvbWUgZnJlZS4NCj4gVXNhZ2UgY291bnQgPSAyDQo+ID4NCj4g
PiBbICAxOTAuNjgyMzA5XSB1bnJlZ2lzdGVyX25ldGRldmljZTogd2FpdGluZyBmb3Igc2l0MCB0
byBiZWNvbWUgZnJlZS4NCj4gVXNhZ2UgY291bnQgPSAyDQo+ID4NCj4gPiBbICAyMDAuNjkwMTc2
XSB1bnJlZ2lzdGVyX25ldGRldmljZTogd2FpdGluZyBmb3Igc2l0MCB0byBiZWNvbWUgZnJlZS4N
Cj4gVXNhZ2UgY291bnQgPSAyDQo+ID4NCj4gPiBbICAyMTAuOTM4MzEwXSB1bnJlZ2lzdGVyX25l
dGRldmljZTogd2FpdGluZyBmb3Igc2l0MCB0byBiZWNvbWUgZnJlZS4NCj4gVXNhZ2UgY291bnQg
PSAyDQo+ID4NCj4gPiBbICAyMjEuMTg2MzExXSB1bnJlZ2lzdGVyX25ldGRldmljZTogd2FpdGlu
ZyBmb3Igc2l0MCB0byBiZWNvbWUgZnJlZS4NCj4gVXNhZ2UgY291bnQgPSAyDQo+ID4NCj4gPiBb
ICAyMzEuNDQyMzExXSB1bnJlZ2lzdGVyX25ldGRldmljZTogd2FpdGluZyBmb3Igc2l0MCB0byBi
ZWNvbWUgZnJlZS4NCj4gVXNhZ2UgY291bnQgPSAyDQo+ID4NCj4gPiBbICAyNDEuNjkwMTg2XSB1
bnJlZ2lzdGVyX25ldGRldmljZTogd2FpdGluZyBmb3Igc2l0MCB0byBiZWNvbWUgZnJlZS4NCj4g
VXNhZ2UgY291bnQgPSAyDQo+ID4NCj4gPiBbICAyNTEuNjk4Mjg4XSB1bnJlZ2lzdGVyX25ldGRl
dmljZTogd2FpdGluZyBmb3Igc2l0MCB0byBiZWNvbWUgZnJlZS4NCj4gVXNhZ2UgY291bnQgPSAy
DQo+ID4NCj4gPiBbICAyNjEuOTQ2MzExXSB1bnJlZ2lzdGVyX25ldGRldmljZTogd2FpdGluZyBm
b3Igc2l0MCB0byBiZWNvbWUgZnJlZS4NCj4gVXNhZ2UgY291bnQgPSAyDQo+ID4NCj4gPiBbICAy
NzIuMTk0MTgxXSB1bnJlZ2lzdGVyX25ldGRldmljZTogd2FpdGluZyBmb3Igc2l0MCB0byBiZWNv
bWUgZnJlZS4NCj4gVXNhZ2UgY291bnQgPSAyDQo+ID4NCj4gPiBbICAyODIuNDQyMzExXSB1bnJl
Z2lzdGVyX25ldGRldmljZTogd2FpdGluZyBmb3Igc2l0MCB0byBiZWNvbWUgZnJlZS4NCj4gVXNh
Z2UgY291bnQgPSAyDQo+ID4NCj4gPiBbICAyOTIuNjkwMzEwXSB1bnJlZ2lzdGVyX25ldGRldmlj
ZTogd2FpdGluZyBmb3Igc2l0MCB0byBiZWNvbWUgZnJlZS4NCj4gVXNhZ2UgY291bnQgPSAyDQo+
ID4NCj4gPiBbICAzMDIuOTM4MzEzXSB1bnJlZ2lzdGVyX25ldGRldmljZTogd2FpdGluZyBmb3Ig
c2l0MCB0byBiZWNvbWUgZnJlZS4NCj4gVXNhZ2UgY291bnQgPSAyDQo+ID4NCj4gPiBbICAzMTMu
MTg2MjU1XSB1bnJlZ2lzdGVyX25ldGRldmljZTogd2FpdGluZyBmb3Igc2l0MCB0byBiZWNvbWUg
ZnJlZS4NCj4gVXNhZ2UgY291bnQgPSAyDQo+ID4NCj4gPiBbICAzMjMuNDQyMzI5XSB1bnJlZ2lz
dGVyX25ldGRldmljZTogd2FpdGluZyBmb3Igc2l0MCB0byBiZWNvbWUgZnJlZS4NCj4gVXNhZ2Ug
Y291bnQgPSAyDQo+ID4NCj4gPiBbICAzMzMuNjk4MzA5XSB1bnJlZ2lzdGVyX25ldGRldmljZTog
d2FpdGluZyBmb3Igc2l0MCB0byBiZWNvbWUgZnJlZS4NCj4gVXNhZ2UgY291bnQgPSAyDQo+ID4N
Cj4gPiBbICAzNDMuOTQ2MzEwXSB1bnJlZ2lzdGVyX25ldGRldmljZTogd2FpdGluZyBmb3Igc2l0
MCB0byBiZWNvbWUgZnJlZS4NCj4gVXNhZ2UgY291bnQgPSAyDQo+ID4NCj4gPiBbICAzNTQuMjAy
MTY2XSB1bnJlZ2lzdGVyX25ldGRldmljZTogd2FpdGluZyBmb3Igc2l0MCB0byBiZWNvbWUgZnJl
ZS4NCj4gVXNhZ2UgY291bnQgPSAyDQo+ID4NCj4gPiBbICAzNjQuNDUwMTkwXSB1bnJlZ2lzdGVy
X25ldGRldmljZTogd2FpdGluZyBmb3Igc2l0MCB0byBiZWNvbWUgZnJlZS4NCj4gVXNhZ2UgY291
bnQgPSAyDQo+ID4NCj4gPiBbICAzNzQuNzA2MzE0XSB1bnJlZ2lzdGVyX25ldGRldmljZTogd2Fp
dGluZyBmb3Igc2l0MCB0byBiZWNvbWUgZnJlZS4NCj4gVXNhZ2UgY291bnQgPSAyDQo+ID4NCj4g
Pg0KPiA+DQo+ID4gSXMgdGhpcyBhbiBleHBlY3RlZCBiZWhhdmlvcj8NCj4gPg0KPiA+DQo+ID4N
Cj4gPiBUaGFua3MsDQo+ID4NCj4gPiBWSw0KPiANCj4gU2FtZSBhbnN3ZXIgdGhhbiB0aGUgb3Ro
ZXIgdGhyZWFkIDoNCj4gDQo+IE5vcGUsIEkgYWxyZWFkeSBoYXZlIGEgZml4LCBidXQgaXQgZGVw
ZW5kcyBvbiBhIHBlbmRpbmcgcGF0Y2guDQo+IA0KPiBodHRwczovL3BhdGNod29yay5rZXJuZWwu
b3JnL3Byb2plY3QvbmV0ZGV2YnBmL3BhdGNoLzIwMjEwMzMwMDY0NTUxLjU0DQo+IDU5NjQtMS1l
cmljLmR1bWF6ZXRAZ21haWwuY29tLw0KPiANCj4gKEkgbmVlZCB0aGUgcGF0Y2ggYmVpbmcgbWVy
Z2VkIHRvIGFkZCBhIGNvcnJlc3BvbmRpbmcgRml4ZXM6IHRhZykNCj4gDQo+IFlvdSBjYW4gdHJ5
IHRoZSBhdHRhY2hlZCBwYXRjaCA6DQoNClRoYW5rcywgSSBhcHBsaWVkIHRoZSB0d28gcGF0Y2hl
cyB5b3UgbWVudGlvbmVkIGFuZA0Kbm8gbG9uZ2VyIHNlZWluZyB0aGUgd2FybmluZ3MuDQoNCg0K
