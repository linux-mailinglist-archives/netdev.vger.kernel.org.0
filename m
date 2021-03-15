Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D3233C798
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 21:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbhCOUSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 16:18:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:17722 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233351AbhCOUS0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 16:18:26 -0400
IronPort-SDR: eI96baXQOFVrpCNTuZZk0wQzgv0IK77KAbKGFNluShYHmtNQFZhd22sZREkb3P5CQkuQkIH4PF
 8pvq9gZfzySg==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="189241083"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="189241083"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 13:18:25 -0700
IronPort-SDR: 1Jnuc503EqYXb8BSrDdgC3LyhqphcIktd7j59ClvfShC7ew3RVN6guNptyL+3p9gE6BxwGg9oa
 pvMaDmcHfBPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="373551522"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 15 Mar 2021 13:18:15 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 15 Mar 2021 13:18:14 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 15 Mar 2021 13:18:14 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Mon, 15 Mar 2021 13:18:14 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 15 Mar 2021 13:18:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmWvPGih9toIdcDPS6IkAnj6LGNfj5L22QnQjDvJSV9LlXm7hpUS9FmxUufA2weUZSqCipG0R3TuG3bqO6yFNmBz5Sc0kq52RGpS1/X3JnporAYAB4V3ycrPwyE0N/K/vxZKwmheeRoocS9sy68ibCf9OhokfXwsLkMb9dglGLlkpiQX8yXIHgi+cpdxfw3YYOjh3EipgohnhNvKcNj3O84HtlgnbP3gpY31dFFH/XcYortIB0uIll5BG3xv7chFGwcyuHns0jz26dV0+LCqLW2dRXf/usNJRWFZVcT9dOyfl6ikZ1cxJrNpwP2yx+/LBFqTdwo7rEae1miOQYWwkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROFjarkhkJ94hfJxVQUo6mwCwwud/gMxo5LdKUPe2kI=;
 b=UYCe+jAjhw4htMHBltwhVxADV/ZTnsKLE45aLfMrbF/q1DuVljanPEZy9MjWA6qIinFGQN6FYkVfY8bERouu6JRl1VCvlrBroBeXc3dn0p5wPYLNldMrtkLawYCNObbq9DHTC3EQwV0Moo09lsRoNPwozKoA4mfLaLA2gheTmsAbn6OyNyJEzb+CwRF3b0khCPeTqIowy+zgKtMePHRw98qKQRNMRQrvo9I5+2AEWpQQTW1akyULll+NREaumuPtSfH1epCn/k1/7wJdY/JC3P7vMAz6CbjU+ugcONPxaLEb+cvSoaL5t6JpuXm7fRmK+RriP8ITFoIYFImRMIpzlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ROFjarkhkJ94hfJxVQUo6mwCwwud/gMxo5LdKUPe2kI=;
 b=oHs4VLl3qlvHQZhcu8QY4m5W2Is+7i2GfVVwT8vtcHTAllCHQkrnzWc3t4EheDuaxqcdu9ahyLei6AFI+jkqAQexN9K/fajhcfWD+yBWad/LuD+LfmyzVTNc4n4QjSZulqwHrIps7vjp16ihdOmdNN+JCzHL86YXTIzDp6+IhbU=
Received: from BYAPR11MB3095.namprd11.prod.outlook.com (2603:10b6:a03:91::26)
 by BYAPR11MB3431.namprd11.prod.outlook.com (2603:10b6:a03:8d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Mon, 15 Mar
 2021 20:18:10 +0000
Received: from BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6]) by BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6%4]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 20:18:10 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: RE: [PATCH v10 00/20] dlb: introduce DLB device driver
Thread-Topic: [PATCH v10 00/20] dlb: introduce DLB device driver
Thread-Index: AQHW/9Zt8wdlPnXnkESxoD5/CU9Koap9GIKAgAMHmACAAN/QcIAAU8sAgARar7A=
Date:   Mon, 15 Mar 2021 20:18:10 +0000
Message-ID: <BYAPR11MB309515F449B8660043A559E5D96C9@BYAPR11MB3095.namprd11.prod.outlook.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <YEiLI8fGoa9DoCnF@kroah.com>
 <CAPcyv4gCMjoDCc2azLEc8QC5mVhdKeLibic9gj4Lm=Xwpft9ZA@mail.gmail.com>
 <BYAPR11MB30950965A223EDE5414EAE08D96F9@BYAPR11MB3095.namprd11.prod.outlook.com>
 <CAPcyv4htddEBB9ePPSheH+rO+=VJULeHzx0gc384if7qXTUHHg@mail.gmail.com>
In-Reply-To: <CAPcyv4htddEBB9ePPSheH+rO+=VJULeHzx0gc384if7qXTUHHg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [69.141.163.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45e197c0-d14b-4256-a5dd-08d8e7ef7430
x-ms-traffictypediagnostic: BYAPR11MB3431:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3431A803A97E48F3D294B032D96C9@BYAPR11MB3431.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E1nHK4XyytIVfPxW4IKJxeYjA80kX8KVHL5JM2mISOyXuBiW33iOLSBIrfWD05c9zGV6EjqfrdnU28QdYpYXPHU5XdBCvq0OXJrTjSk/U7UnCdZlNnWf1bKf9DZHjUqqy2B5C+3UcMI9kdkLgrZ1ZWxcnB3+kPd43/mxzi5sJziCJR0eVeroVnIuNF/6ATuRtAyRNWT3pmWRF95IJiNHS0VB8ci6sqRIMJbMNfqIfy55p3a775tGo882nFclreagaQoHnptFyHIach5GDYAO7mkdv79bh6ZORZZEgJ1rOg0YrWonD5bGJJKR+gMgzTky03tmk6FcKnvPDyEFlVIbcC78LkeibfJ/0WDUZWf0gYb5M/C6CwosRkjPPFh5fSoxTgjssFqEEwaiCaP+IVuGQ3Qyt3j7cTXvH5yYps6RECaU4mgnb8hm2MmkRueM+3/41L0HyVNTbva0O2JsfjyIawTcwwkAw9io1jJzRDiGb1dtkCg9vJ2u+pGWK/z2lgAuy/jKGnDw7sp3WiBzpdI3q9K/4zgMZSHEYVmI9jv2oInr2x4ZDzyIcT8ffyFUHVy5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(136003)(39860400002)(346002)(33656002)(55016002)(8676002)(2906002)(26005)(186003)(8936002)(86362001)(6862004)(83380400001)(9686003)(4326008)(76116006)(71200400001)(54906003)(66446008)(478600001)(6506007)(64756008)(316002)(66556008)(53546011)(52536014)(7696005)(66946007)(66476007)(5660300002)(6636002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?M3dCNUtFTGVjL0x0UHpVQnZZaWhuMERpYVBTcG1xNU4wU2owOXhWU2NFTUZz?=
 =?utf-8?B?VE5tRitvM21DajFOdlNzaUZ3YmJhcVNLRlVIQ3BuMU1IK0tJMkZBMTBPYlA2?=
 =?utf-8?B?Vy8zN0ptMjJDdFU4U3RKdURqbGsyUHU5RG1zenpLSkUrSHptR2lZalRTaXkv?=
 =?utf-8?B?VjVpcTRJUkNEY1QxNnJSTkhLVWc3alM2dUR6Q1JzTVF5dW9vYnpLSGk5R01i?=
 =?utf-8?B?OHo4cm03MnRuTEtiWFhpQmdhMFBjaUJEOTB3Rm5hU0l6UEJXTWV2OGwxZ0lp?=
 =?utf-8?B?R0pBWUpVbmZMZ2tjZzQrVHhyTkJiYVdPTlZlZWVldFMwbTJacU02RzhBWU1o?=
 =?utf-8?B?Q243OUVOdHRQMWt1dVVHWHFsK1Q1QWprOVhBRE02WVpPemE5RXlaVWZncE5B?=
 =?utf-8?B?eDZpa3ZROTBiUXBwdTJYL2NUdytvcnluN1ExMFNGQWVrd0hpanlkSVpTMmw5?=
 =?utf-8?B?anpidkpXakIwZmxKNUxOeDhmS2JWRU9mZ2VNeFUyaFRLUEgyWWhpOW9iZlFo?=
 =?utf-8?B?RDJreE55dU00OE13dFVBYmdlM0oxM1hQWGJwbkEyblVhOStxcmFvUldJTDJG?=
 =?utf-8?B?ZUQ5OE5jaWpRaXh4UVc4T092dzFpY3p5M1B2b21jQXNNRSthckRIbVU4T2Jy?=
 =?utf-8?B?Rm9kN2lqNm9qSUVseHg1NHZDUWtWT1JhSGFGN1p2QnZxV1h5TzdKQVBZUW4y?=
 =?utf-8?B?RXRETGY0SU9EUTI3QU9mcjlKdkFJNG9kWFZiV2VpZnkyeEIyWldGUVhjQ2Z1?=
 =?utf-8?B?dHNRU3pGbVhZYU9EaWwyU0hxcFh0cTJ3QTFrTmY0RGhMZjBuT3ZkYlFPcWJT?=
 =?utf-8?B?bzNUNW5RYzAxN2VCU1F6WWlmalZ5cmJjOW1FaUNVS2FEaVQ2TWxNR1FCYkJC?=
 =?utf-8?B?cFM0bkdycStVNHFzcWdFaFB1b1FvcExlbGV4N1diL3luTURNVE5GdmpYZ21R?=
 =?utf-8?B?dDBzOUJDMi9XS1BQZmpKNTNUcEpydWlEWnRWM1JVRGl4RnFHcDlrUVdUUTAw?=
 =?utf-8?B?TFk4OWpXelQraExndDNRWnR1S1VRdld0cW1yQ2JZSjhWUzg0eHZFNGdvOHla?=
 =?utf-8?B?RDFjdFU1eGs1VHpyR0NPUVF1MXltL3ZqTk5sMW9xYVovNzlNc3JYT1hjQTNq?=
 =?utf-8?B?eFNrNGdGK2lwWGU0S05tVDB6cys5SkN2N3dOMlNNQkNDUFNma3NwMklLY1Zo?=
 =?utf-8?B?UmpNOG1aalZ2L3lvc0lQYkZmK0dzSmo2anlLbVIrbEFxR2plYTlDeXRneVNl?=
 =?utf-8?B?WGY4ZGUxcFZYTXZMMjZZS0x0Y3c0VG9wSVptbUZlb0ZSR2p4TS9HRzl6RnJz?=
 =?utf-8?B?SGo2TVROR0pjTUtKZ3F1WEhRMGh1ZkRNZGtSdmdOaTlzR3pDTzMrdXRiVkNN?=
 =?utf-8?B?Tm44NFV3aHg2ZnJ3SkUzL1dHU3JrTC9ndmo5b1hJdDlmMTh6Z0pwWXpyM0Fi?=
 =?utf-8?B?eERsamgzdjRUVS9mcERRMXlrMllGZEMrWG96V2puSHZTUHFIYlZYS01wNVI5?=
 =?utf-8?B?SjJlSFVGV3FwWlYvU0J6cVBGQkFIeEFWbE8rWXBkMDFhTUhVL1pnemh4Z3Jz?=
 =?utf-8?B?a2h1K09WcnY1Skl2N2dKYU1SbXhydkd5MEJ2MjJ0UmxkcURCb2tYMFg1YVFH?=
 =?utf-8?B?SGlzVy9UOWNiREh1RE5PQnZmU0ZrakNUMllYNVl5NkVtQmlPYTY0b1hFS2o1?=
 =?utf-8?B?TGhoZE84K0JpemJMdWIwS3FGV0RNUnowaDJKem1iTVVVOG16NDZKMHdkQWRx?=
 =?utf-8?Q?WFwKT5ggfz4vEbFsXxOMRNWmlrDl5tRHubbTuV5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45e197c0-d14b-4256-a5dd-08d8e7ef7430
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2021 20:18:10.3951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w7krNSaUOrzPvPjK3AjkiijKWA04KjviPsXlSQTjc0REx9WiTmzg9fQcyzDQyM+BcJxAJTLld5qqwq+t2xt7EW8K9Jt1oOi8Lb8Rha2B0MI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3431
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4gT24gRnJp
LCBNYXIgMTIsIDIwMjEgYXQgMTo1NSBQTSBDaGVuLCBNaWtlIFhpbWluZyA8bWlrZS54aW1pbmcu
Y2hlbkBpbnRlbC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gV2Ugc3VwcG9ydCB1cCB0byAxNi8zMiBW
Ri9WREVWcyAoZGVwZW5kaW5nIG9uIHZlcnNpb24pIHdpdGggU1JJT1YgYW5kDQo+ID4gU0lPVi4g
Um9sZSBvZiB0aGUga2VybmVsIGRyaXZlciBpbmNsdWRlcyBWREVWIENvbXBvc2l0aW9uICh2ZGNt
DQo+ID4gbW9kdWxlKSwgZnVuY3Rpb25hbCBsZXZlbCByZXNldCwgbGl2ZSBtaWdyYXRpb24sIGVy
cm9yIGhhbmRsaW5nLCBwb3dlcg0KPiA+IG1hbmFnZW1lbnQsIGFuZCBldGMuLg0KPiANCj4gTmVl
ZCBzb21lIG1vcmUgc3BlY2lmaWNpdHkgaGVyZS4gV2hhdCBhYm91dCB0aG9zZSBmZWF0dXJlcyBy
ZXF1aXJlcyB0aGUga2VybmVsIHRvIGdldCBpbnZvbHZlZCB3aXRoIGENCj4gRExCMiBzcGVjaWZp
YyBBQkkgdG8gbWFuYWdlIHBvcnRzLCBxdWV1ZXMsIGNyZWRpdHMsIHNlcXVlbmNlIG51bWJlcnMs
IGV0Yy4uLj8NCg0KUm9sZSBvZiB0aGUgZGxiIGtlcm5lbCBkcml2ZXI6DQoNClZERVYgQ29tcG9z
aXRpb24NCkZvciBleGFtcGxlIHdyaXRpbmcgMTAyNCB0byB0aGUgVkRFVl9DUkVESVRTWzBdIHJl
Z2lzdGVyIHdpbGwgYWxsb2NhdGUgMTAyNCBjcmVkaXRzIHRvIFZERVYgMC4gSW4gdGhpcyB3YXks
IFZGcyBvciBWREVWcyBjYW4gYmUgY29tcG9zZWQgIGFzIG1pbmktdmVyc2lvbnMgb2YgdGhlIGZ1
bGwgZGV2aWNlLg0KVkRFViBjb21wb3NpdGlvbiB3aWxsIGxldmVyYWdlIHZmaW8tbWRldiB0byBj
cmVhdGUgdGhlIFZERVYgZGV2aWNlcyB3aGlsZSB0aGUgS01EIHdpbGwgaW1wbGVtZW50IHRoZSBW
RENNLg0KDQpEeW5hbWljIENvbXBvc2l0aW9uDQpTdWNoIGNvbXBvc2l0aW9uIGNhbiBiZSBkeW5h
bWljIOKAkyB0aGUgUEYvVkYgaW50ZXJmYWNlIHN1cHBvcnRzIHNjZW5hcmlvcyB3aGVyZWJ5LCBm
b3IgZXhhbXBsZSwgYW4gYXBwbGljYXRpb24gbWF5IHdpc2ggdG8gYm9vc3QgaXRzIGNyZWRpdCBh
bGxvY2F0aW9uIOKAkyBjYW4gSSBoYXZlIDEwMCBtb3JlIGNyZWRpdHM/DQoNCkZ1bmN0aW9uYWwg
TGV2ZWwgUmVzZXQNCk11Y2ggb2YgdGhlIGludGVybmFsIHN0b3JhZ2UgaXMgUkFNIGJhc2VkIGFu
ZCBub3QgcmVzZXR0YWJsZSBieSBoYXJkd2FyZSBzY2hlbWVzLiBUaGVyZSBhcmUgYWxzbyBpbnRl
cm5hbCBTUkFNICBiYXNlZCBjb250cm9sIHN0cnVjdHVyZXMgKEJDQU0pIHRoYXQgaGF2ZSB0byBi
ZSBmbHVzaGVkLiANClRoZSBwbGFubmVkIHdheSB0byBkbyB0aGlzIGlzLCByb3VnaGx5Og0KICAt
LSBLZXJuZWwgZHJpdmVyIGRpc2FibGVzIGFjY2VzcyBmcm9tIHRoZSBhc3NvY2lhdGVkIHBvcnRz
ICAodG8gcHJldmVudCBhbnkgU1cgYWNjZXNzLCB0aGUgYXBwbGljYXRpb24gc2hvdWxkIGJlIGRl
YWRzbyB0aGlzIGlzIGEgcHJlY2F1dGlvbikuDQogIC0tIEtlcm5lbCBtYXNxdWVyYWRlcyBhcyB0
aGUgYXBwbGljYXRpb24gdG8gZHJhaW4gYWxsIGRhdGEgZnJvbSBpbnRlcm5hbCBxdWV1ZXMuIEl0
IGNhbiBwb2xsIHNvbWUgaW50ZXJuYWwgY291bnRlcnMgdG8gdmVyaWZ5IGV2ZXJ5dGhpbmcgaXMg
ZnVsbHkgZHJhaW5lZC4NCiAgLS0gT25seSBhdCB0aGlzIHBvaW50IGNhbiB0aGUgcmVzb3VyY2Vz
IGFzc29jaWF0ZWQgd2l0aCB0aGUgVkRFViBiZSByZXR1cm5lZCB0byB0aGUgcG9vbCBvZiBhdmFp
bGFibGUgcmVzb3VyY2VzIGZvciBoYW5kaW5nIHRvIGFub3RoZXIgYXBwbGljYXRpb24vVkRFVi4N
Cg0KTWlncmF0aW9uDQpSZXF1aXJlbWVudCBpcyBmYWlybHkgc2ltaWxhciB0byBGTFIuIEEgVkRF
ViBoYXMgdG8gYmUgbWFudWFsbHkgZHJhaW5lZCBhbmQgcmVjb25zdGl0dXRlZCBvbiBhbm90aGVy
IHNlcnZlciwgS2VybmVsIGRyaXZlciBpcyByZXNwb25zaWJsZSBvbiBib3RoIHNpZGVzLg0KDQpF
cnJvciBIYW5kbGluZw0KRXJyb3JzIGluY2x1ZGUg4oCcQ3JlZGl0IEV4Y3Vyc2lvbnPigJ0gd2hl
cmUgYSBWREVWIGF0dGVtcHRzIHRvIHVzZSBtb3JlIG9mIHRoZSBpbnRlcm5hbCBjYXBhY2l0eSAo
Y3JlZGl0cykgdGhhbiBoYXMgYmVlbiBhbGxvY2F0ZWQuIEluIHN1Y2ggYSBjYXNlLCANCnRoZSBk
YXRhIGlzIGRyb3BwZWQgYW5kIGFuIGludGVycnVwdCBnZW5lcmF0ZWQuIEFsbCBzdWNoIGludGVy
cnVwdHMgYXJlIGRpcmVjdGVkIHRvIHRoZSBQRiBkcml2ZXIsIHdoaWNoIG1heSBzaW1wbHkgZm9y
d2FyZCB0aGVtIHRvIGEgVkYgKHZpYSB0aGUgUEYvVkYgY29tbXMgbWVjaGFuaXNtKS4NCg0KUG93
ZXIgTWFuYWdlbWVudA0KVGhlIGtlcm5lbCBkcml2ZXIga2VlcHMgdGhlIGRldmljZSBpbiBEM0hv
dCB3aGVuIG5vdCBpbiB1c2UuIFRoZSBkcml2ZXIgdHJhbnNpdGlvbnMgdGhlIGRldmljZSB0byBE
MCB3aGVuIHRoZSBmaXJzdCBkZXZpY2UgZmlsZSBpcyBvcGVuZWQgb3IgYSBWRiBvciBWREVWIGlz
IGNyZWF0ZWQsIA0KYW5kIGtlZXBzIGl0IGluIHRoYXQgc3RhdGUgdW50aWwgdGhlcmUgYXJlIG5v
IG9wZW4gZGV2aWNlIGZpbGVzLCBtZW1vcnkgbWFwcGluZ3MsIG9yIFZGcy9WREVWcy4NCg0KSW9j
dGwgaW50ZXJmYWNlDQpLZXJuZWwgZHJpdmVyIHByb3ZpZGVzIGlvY3RsIGludGVyZmFjZSBmb3Ig
dXNlciBhcHBsaWNhdGlvbnMgdG8gc2V0dXAgYW5kIGNvbmZpZ3VyZSBkbGIgZG9tYWlucywgcG9y
dHMsIHF1ZXVlcywgc2NoZWR1bGluZyB0eXBlcywgY3JlZGl0cywgDQpzZXF1ZW5jZSBudW1iZXJz
LCBhbmQgbGlua3MgYmV0d2VlbiBwb3J0cyBhbmQgcXVldWVzLiAgQXBwbGljYXRpb25zIGFsc28g
dXNlIHRoZSBpbnRlcmZhY2UgdG8gc3RhcnQsIHN0b3AgYW5kIGlucXVpcmUgdGhlIGRsYiBvcGVy
YXRpb25zLg0KDQpUaGFua3MNCk1pa2UNCg0K
