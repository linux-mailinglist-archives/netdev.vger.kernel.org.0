Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BD2393E2A
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 09:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbhE1HrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 03:47:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:22714 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230133AbhE1HrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 03:47:13 -0400
IronPort-SDR: 05inFbTxoBpjleKE28NBLghMbhfJ9nV7RjTRI4jvMiXPdGjYIAzWoQTAxd+mPqisnMpGwoqAzo
 ckUi7CI1S6aA==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="224143007"
X-IronPort-AV: E=Sophos;i="5.83,229,1616482800"; 
   d="scan'208";a="224143007"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2021 00:45:37 -0700
IronPort-SDR: HJab4bOciHF1Qi3Xe3FZlc0ypuXrO/M7aW5ZgfxvZp+Hxaj7kRjNhn+p9v4UzIe7GmfFmM8wg7
 J5tZx+7Wklhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,229,1616482800"; 
   d="scan'208";a="631707383"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga006.fm.intel.com with ESMTP; 28 May 2021 00:45:33 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 28 May 2021 00:45:33 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 28 May 2021 00:45:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 28 May 2021 00:45:32 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 28 May 2021 00:45:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M2yGaqgq6z+b9oAqcGIFEFf6I8Ey+D56dLqzmcAARYCXTOg9pYWrJ6w3zy3BHV8sum6HoTU6baXGUSib7jBXhtEx00lymQrXSy6bVYKeiTlUzdJnRIjK92tvbWf7sJefGKKiEqIz5qQylVY1WnNC3vzMY+snYj8xDExzAf9wUbAzjIQlvmF7r6d4ls/LsRReQIGGm0GD8IrObpjGdVpkraGxqn2CguVpAXs6XjEdkf4EIkJVJiHQDxRjcLWwY2i7MFgmmz8bjjkIBdjG8NnzxelymIaEK73Du1fAepmPhTV+WZ/gQ504xq/OuqO+bhMRJRueobs+CToTBQ99SR28Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NuQyUSuobUqn/YfmE+03VPwEt5crha3JSbFfHCC1Mmg=;
 b=XKyma0XdobrdrkzC9Oj6WvmGfUb+3PGTlc4dYUQowIpvkJexob06J7SMNsMw6CbssSchgRJrlCvWDKgCntAIP4GazjCm/MzHddvb0DSPVA0mYBu9SHc2l8a0nTAxI3Qhpu02s662P/lH6kgYiXA8YuLRvq3owQy2blPDm9/ByXnYv29mmd7HRn24mggoZnSn7eayX0/FRJbi/qO5RBisaOLhc0PW8ESgi2jrYP2lv2+IAE17/33ilzNClL1jdQJLhZMZYACSN6pMx2GuSvtcDi64XkwN/jPs1u4lGB+dnEtB23MCOdrP5pjXX/Un/aiL5Mvi4/EhKx3OiIp7/E+5Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NuQyUSuobUqn/YfmE+03VPwEt5crha3JSbFfHCC1Mmg=;
 b=UEkO3XnLGOEi+q5db/b/eAgXolKuZyG+rd9YyrUM0VQAYjS1OeIuS0LrhCazueYBlaQyUOC4sZGnB7KNwowwKDQ7veqTHvomqXclY2fOmFXLhuA0GKeVtg79X4WaR/pRtdXQiqCU/3MhkwXwUh6OCOB9qsH59oe9EZtiXmJkauE=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by SJ0PR11MB4944.namprd11.prod.outlook.com (2603:10b6:a03:2ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 28 May
 2021 07:45:31 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::106d:d229:f71b:b34f]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::106d:d229:f71b:b34f%4]) with mapi id 15.20.4173.024; Fri, 28 May 2021
 07:45:31 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "Joakim.Tjernlund@infinera.com" <Joakim.Tjernlund@infinera.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: iwlwifi/cfg/22000.c: kernel 5.10.x LTS only have
 IWL_22000_UCODE_API_MAX 59
Thread-Topic: iwlwifi/cfg/22000.c: kernel 5.10.x LTS only have
 IWL_22000_UCODE_API_MAX 59
Thread-Index: AQHXUy5AQawm5aX1GEG2TCkCm2KCTKr4hIAA
Date:   Fri, 28 May 2021 07:45:31 +0000
Message-ID: <bfd059d045dd9649b7c20ecac0fd9f2d0cd5df4e.camel@intel.com>
References: <PH0PR10MB4615DF38563E6512A0841162F4239@PH0PR10MB4615.namprd10.prod.outlook.com>
In-Reply-To: <PH0PR10MB4615DF38563E6512A0841162F4239@PH0PR10MB4615.namprd10.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.3-1 
authentication-results: infinera.com; dkim=none (message not signed)
 header.d=none;infinera.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [91.156.6.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 728996e6-f24d-4825-1d42-08d921ac91de
x-ms-traffictypediagnostic: SJ0PR11MB4944:
x-microsoft-antispam-prvs: <SJ0PR11MB4944F2546337C55322FDC23790229@SJ0PR11MB4944.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: skkbODSAXGvrQg2SAJD6slb1X2fF4ItdK9pTxnoF16zuNif/eTDuXs+ZlRVFSwermHgURyik2jUQSFKxozpKOLtY7avvugBDtvd9RR9PUCLBE2ov7khAoc5VvrEKgg5VUzl6tbKPbRYIf8l7P4/a/EVP4khfb3nwXIq/DY9AcFdpNZ+LFvB0GgVJHPsaeXpJEJXmI7f9fR5N4vV7VxnnK1Pu2sghQhAO42ZF3NyZUGzx3HMjgbV3pDN86rFoZcragZfLK6YT/U9Ok455M/TeytbTWnL1kxpmuTg1zqEg8h6UV4mN5lwMT1fTXh0fyniNFWWfCHKs+l8l8X9A3dMSzd105b0yJO7In20185HXTb4uBs6BCJJYbSxIXmOLzVruZEwE1Jer/PjUQm/70AvysAOa5d54dRpRklpuuEclkVY57yzhynUiED7lRwkbFkZR//OulTe38YURCihra2xCGOyxg+LqheWbTuWPLSNBfeHiN3UcmswzFIzJPZtPMkMKOT1JAwhMpY5ttz1J6Uxqm0UIfkUU1r2rw0DiKdWvI0+scWt8JMOgaAb9H1tXHyQSml7iQJBJxOopBngQgFKe1Du+lPH8lNAiIzSnez0K6pU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(396003)(136003)(376002)(186003)(6916009)(2616005)(4744005)(316002)(26005)(2906002)(6486002)(6512007)(4326008)(5660300002)(71200400001)(6506007)(66946007)(66476007)(66556008)(64756008)(66446008)(8676002)(76116006)(86362001)(122000001)(91956017)(36756003)(478600001)(83380400001)(8936002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?b3hJOTlabjVuZ3FoY2FWaWJ6Ym8wSllBSFpGR2VpKytkNVFHQ09USEIwRjJP?=
 =?utf-8?B?RFN0UVhuT1RlcWJYUHgxVmZtVWk2Q0RkUERhemxpeHViQTJBZ2FNYmdxbUhJ?=
 =?utf-8?B?TjBXVHRvSk5UVlc2MUs3dFd5VXd4bnczTkpSUkxVMzJzRDA5Y1lPSXZ5Zkp1?=
 =?utf-8?B?ejRDOWpBcDlqNk52Q1JFOXlqMXIweEMyOHZOU2Q1NnJ4WVJuN3pNbVVKdWl4?=
 =?utf-8?B?RWJzRTFwT204dzJ0bndyUlhZRjNRaFhZbFhqT3p2eVZqUVFRVzJpNzh4WUJ4?=
 =?utf-8?B?NlEvU0Q5RzR6WlJvam1xZ1FEZ2JpU2Z0dWNwUTRPbFNVWC8vdmJNYnFiejk5?=
 =?utf-8?B?WHZtbno3UnVaRWFxMFJLcXp3RjlQeVdxclgyWW5tUk8rRmhCK1FDbTJESVRj?=
 =?utf-8?B?azFibDJMRnpoWngyOWpJdGFnOVhjczNrMFI0MDA3MUxZYi9vak1yZkV0UTAr?=
 =?utf-8?B?YWg3NnVENkQranp5Zk1jSnY4TExNUGlJejdleklSem1aSEsrdFMxZFltNkts?=
 =?utf-8?B?Q1FuZmxrTWxERXlCZHhFYis0bENaWHlvNFdiT2h5aEd0S0Z4VlZBeC9wam1a?=
 =?utf-8?B?NXNHWGp4LzhsQTd1N045VWhKT0FxSDlkYkE0UG9oczE5Y2kxSStORkR2SHRG?=
 =?utf-8?B?TXJ4dFV5dzV4OVJLWGJPTWxSQnNVdldtdDJtNnZjRkgvUjJCRzNSeUlqODdF?=
 =?utf-8?B?WlRIZkJPUVFIb3BWb0laRG80Z2xtRzBGM2pLTDIvTFRub2Evdk9TTkIzQ29q?=
 =?utf-8?B?c1pHRVZBR1NZcFloSDY3ekJDTmtYTHBTaWFGY284L0pxK1lVUk9pQXJ1V0Yr?=
 =?utf-8?B?eXA5elpGWDB4UWdhSFNJR2JqdU9ValFXeGYzVlR0czhJVjg0UGtDOTZpeVdQ?=
 =?utf-8?B?Z0JaNGo4amZJQmE2VlQvd2JUOC9UWUlvNHJFKzR6blRBVHNDekp6U2lNTm01?=
 =?utf-8?B?eWNDb3IwRVZHNTQ5L0o1Z3hWRjZZZWRrY3hWenlqb1R5Q3VxUWVIQURWL2Fq?=
 =?utf-8?B?ZnFGVHJBMEM0NENTQUdaM1E5eW9lRU5zWjVOb25RVGdUQlB4Rm9uTXdodXN5?=
 =?utf-8?B?ak9zTkFhUjJVS09hVjF4dGJTaU9YMkpQVTJBYlYwSkpCVEFFZE5PZkw4NXNk?=
 =?utf-8?B?UGYzbEVBa0N1c2lCdDhLbWpXS2p4QmtqR2lPSWcwbysxYUpYTnJoMC9MaEVx?=
 =?utf-8?B?MjdGQXBpMGhicUt2RXN3SGdFa3l2TXFOemovVFdqMVVjV0pvYmRrdkM4TlJZ?=
 =?utf-8?B?QzMvUEV1WW8yeFRWZjRvYnlpV0Y2cVdSem9mc2lxOUJQS01Qb2ltbXRrcGpt?=
 =?utf-8?B?SWRPc1FqcEVMemR3dXNtSkMwNkNjS1l4cVh5Q0VINUlUWWRqTU8xOWF2b0hJ?=
 =?utf-8?B?eXZweFhXNDZlaFI2UGJnVTd3TmdEaGN0YXN4NGRHMFFpRzY1ck8zNE5RSU81?=
 =?utf-8?B?cU52d0NpSWpNQjBsS1FuVmp5eVVCTXNUVHVYUzNYYUV5YjVxMCtlN3IvL0M3?=
 =?utf-8?B?YS9HMGxOS01SdUd2VzR6ZDNGT3hhNkd4V1ZHVExOdGZBcE5BT2hxaVhnV09v?=
 =?utf-8?B?U05WUndrRVA4VUR2d1EvcUlmamNUUFRLcmx1d2xzYy93VUdOOWU5TnJzdTRw?=
 =?utf-8?B?SU1WTktaOUFndVR3dDBraDAyM3BCbGFGZzBaMDEvU2lwLzQxZFBqS3FLR3Ix?=
 =?utf-8?B?SmsranFoMXc4eEtQdzlLS2IrNGFsd2FVNTYwUXZPTW01SktkNXJuUzloKzg3?=
 =?utf-8?Q?IkcJAnjvJNArm6P7ngVSxvgScUzrRbtvL4wYsKY?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <45247E61210F2742A6CC896D7FDD0B5E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 728996e6-f24d-4825-1d42-08d921ac91de
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2021 07:45:31.4120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5vyzb0PC03soPr+EGDDIk6Ss7lgGFgCoGnSadTQncaqF0mIEazFdqoN/H1byFl/RKUXJ283YF/TidqgxEGaFjZCW3VGhWBZhsa2gZdDEopw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4944
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTA1LTI3IGF0IDE5OjI5ICswMDAwLCBKb2FraW0gVGplcm5sdW5kIHdyb3Rl
Og0KPiBJIHRoaW5rIHRoaXMgaXMgd2h5IG15IGRldmljZToNCj4gOTowMC4wIE5ldHdvcmsgY29u
dHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gRGV2aWNlIDI3MjUgKHJldiAxYSkNCj4gCVN1YnN5
c3RlbTogSW50ZWwgQ29ycG9yYXRpb24gRGV2aWNlIDAwMjANCj4gCUtlcm5lbCBkcml2ZXIgaW4g
dXNlOiBpd2x3aWZpDQo+IAlLZXJuZWwgbW9kdWxlczogaXdsd2lmaQ0KPiANCj4gaXNuJ3Qgd29y
a2luZz8gDQoNCkhhcmQgdG8gdGVsbCBqdXN0IGZyb20gdGhpcy4gIHRoZSBNQVhfNTkgQVBJIHRo
aW5nIG1lYW5zIHRoYXQgaXQgd2lsbA0KbG9vayBmb3Igc29tZXRoaW5nIGxpa2UgaXdsd2lmaS1z
by1hMC1nZi1hMC01OS51Y29kZSBpbiB0aGUNCi9saWIvZmlybXdhcmUgZGlyZWN0b3J5LiAgRG8g
eW91IGhhdmUgdGhhdCBmaWxlPw0KDQotLQ0KQ2hlZXJzLA0KTHVjYS4NCg==
