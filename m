Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F933118AC
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhBFCoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:44:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:13134 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230178AbhBFCdB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 21:33:01 -0500
IronPort-SDR: N3LDlRYndDdCYla7aCTACVtULYrAfpDWtKMfBdVUUTTPHUrX23sXhLS7rB7gs80DRWouLGKEX6
 U3LHjzV3LtWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="200530792"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="200530792"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 18:32:15 -0800
IronPort-SDR: XH2dJAI49cN8KCdEB8pi4AB/6KqyimGElGI+gOL9QiIfBLAdmckyo5tBicgVH0D4oQpcSRwJKF
 dP5uJCWIJ+HA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="409480398"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga004.fm.intel.com with ESMTP; 05 Feb 2021 18:32:15 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 5 Feb 2021 18:32:14 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 5 Feb 2021 18:32:14 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 5 Feb 2021 18:32:14 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 5 Feb 2021 18:32:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XbxYliQKSqxZ1uC4YBCtPRWfziSzdc5AShMd/uH1It1j3rFdeRbAoB6jA9409wRwQrAhSEqOtZOjKW+FyJWUrtMmZ8xIFSUCGEhlFT5RbiPPyFHtR5akBVrJM1ThEkFIVRZdFFL+j6UVdKGlYehmEZUTPl2jzcKxBtxj8/hQ4Qwd1NOxFoOFSShPH9gWNa5ahlysSOuZmp3Me66lS1yPRQjsmWrtpO3B2cpKM8KNW1BQ36i7OwKw3TiPfI7Cwe4DAliJHsUEh6IdxoP5p/eijJt1gou+Ukxf5yQbX4qyplT7pkaF+eYuKhU7MZIY4rVhMTXQ+5HO0EC9IWwQ4aSRvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZck85NoPpHe50JPSXLRhVYJXaPSEu0mNrtvEr+U0fM=;
 b=ct8OvW+DyvRCOnf3vRZ4HM/PxEz2fbHQSL/fy0m31EOdifb3LBKoOtbxJ5TxMMvqDav2VOhHFDOZiIwryheXmrxQaP2cAHgWZuNQN34CQjLDZ/zQqawj7BmqIiGJQfOahQeR0XQ8GGaZ6fdzg+Ruw6NyYl9iZ36vNnNe1IuMgb88/F/lqUQtyt9fKj5BtYJSj4nKBNcAQs0n7xgl4PvVu6F4nu6A6TxETTy+N1HChFvirM5439sTsamqDGRzN3r+FZBfZuPGycw8m6g3gmG9v3pkaKNP0LEgBrIoAw5uBKiPhs2EqDpzWLuxAjrFONDhIPAU0m9TqQHLlnO8gOJzTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZck85NoPpHe50JPSXLRhVYJXaPSEu0mNrtvEr+U0fM=;
 b=ux4w6AOz5qQbp8/R7XERp/VdCvoJjUSp9oSgDfagoeI6vGuhn/OZQ4shm1i6/VC4LZGjQdVUSOWpHfR7h4aJ9BDs4KGONTJ37ZyKL38V1SLusa8EwodFcO3/Z3ocI6XgFa4xWIUVQs8nVWYWjBlXLsbbLq9jiPbhr6FsV2wixbE=
Received: from CO1PR11MB5105.namprd11.prod.outlook.com (2603:10b6:303:9f::7)
 by MWHPR11MB2046.namprd11.prod.outlook.com (2603:10b6:300:28::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.21; Sat, 6 Feb
 2021 02:32:12 +0000
Received: from CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::fc66:dd19:b156:7090]) by CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::fc66:dd19:b156:7090%6]) with mapi id 15.20.3825.025; Sat, 6 Feb 2021
 02:32:12 +0000
From:   "Brelinski, TonyX" <tonyx.brelinski@intel.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [PATCH net-next 04/15] ice: add devlink parameters to read and
 write minimum security revision
Thread-Topic: [PATCH net-next 04/15] ice: add devlink parameters to read and
 write minimum security revision
Thread-Index: AQHW9de4fnFutw8JEEyL1qk9k7ZaSKpG7iEAgABR7ACAAAmKgIABHW4AgAAtqQCAAd9UgA==
Date:   Sat, 6 Feb 2021 02:32:11 +0000
Message-ID: <CO1PR11MB510517FC3ABC05123D62721CFAB19@CO1PR11MB5105.namprd11.prod.outlook.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
 <20210129004332.3004826-5-anthony.l.nguyen@intel.com>
 <20210203124112.67a1e1ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c9bfca09-7fc1-08dc-750d-de604fb37e00@intel.com>
 <20210203180833.7188fbcf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3d552bf2-0d99-18aa-339a-5a6bd111c15e@intel.com>
 <e31a1be1-6729-b056-8226-a271a45b381d@intel.com>
In-Reply-To: <e31a1be1-6729-b056-8226-a271a45b381d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.0.76
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f81a69c5-bd19-4266-78a6-08d8ca4768cd
x-ms-traffictypediagnostic: MWHPR11MB2046:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB20464D31673D8F0CB6B20D15FAB19@MWHPR11MB2046.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1v7sV3Jv5a9dJbEZf/HGIyzgNvT5DKlqAFvLchQWsreZEVYDDUHOot1cOzDLLOzgsESNp7p8WWOolh35xhF9+I84ZdICvx9gsk6A4ZjdMB3huQ5+F5FsEOKd7OAO6D6vvgZ43V4RMACGkG/3631uChE5SmejokqD9mem53DXe4cyS4ayG2iLgyhytqMwcMcInRZp4COOKnU6RfI2VuWJb2Wc2Uca78+scumupDsB0m9Sm+2PBlsz38q9wanWMhgEJFt3cyKPNDkeAs98GB29SlhIIxWiYVjvs4YrjOAbyIirtSEPjaL5C72rggXF2zXUJvU0PlQlF6WWbJXnPHcB4hJnlZFMm66M9mdTYQbRRP3Fy6KmrLaScZsp9qTIOBu3B6Y8aqRtLzu/ttz6gHt7BXN/wLTXHw5HM6dkDwsnbmsEm7c7bBm8+uB0Uztz6Nm2n8P5hjja9w9uVqvRZKmsLKmOLOjio/25Wj+Rf9o/aMjFlnVBLdK12LnhXlsua5vme/XnFlHjWOlWupPHkHE7Ig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(136003)(396003)(39860400002)(86362001)(316002)(26005)(186003)(55016002)(52536014)(478600001)(9686003)(53546011)(7696005)(66476007)(33656002)(54906003)(83380400001)(8676002)(4326008)(64756008)(71200400001)(6506007)(15650500001)(66446008)(5660300002)(66946007)(8936002)(110136005)(76116006)(2906002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WlZ5TzcrM29OZnhaQ2NlZVdwU2UwY09wUXU5UU14STh6NmYvN1VXT2lwdmhU?=
 =?utf-8?B?VlZRbVl1WHdDU1VtcnZrVm5nZTNoaDdhQUVuc3NXYkZYNEJmcTBQSTFsWTB0?=
 =?utf-8?B?SlBjMVNtdCswV3pGTDJxZGxkdUt2UjV5VFhCcmR5SWkvZHR1WmVoT3RtSUxF?=
 =?utf-8?B?Y0lHdTdyWm5nVUNMcExDMlZsL3JNd0JOdnhaSVIwRVR5c3l4TWcycjkrQSs3?=
 =?utf-8?B?WEtYZWZuRTArWnBWVHZjUWcweFNwS0pYSHh4d0RNU0d3eFU0a0tUTmdWVkpk?=
 =?utf-8?B?dEtaa2hrb3o2dlVXa2ZsOXkreVZjMHZ1eWIxQ1hsZy9MMlQ3UmxJcWt1N2FK?=
 =?utf-8?B?SzNBbG1SeWxIR002MkRsRTJhUUdzZFdYRXZzQitwQ1cvZ1pkVVNKeUliR2Fx?=
 =?utf-8?B?ZGZZaXQ1U0NsKzhlcDRtWkFCZjVKaEsrZDR0dW9pY3c2TTY1MWJvRWErWE5s?=
 =?utf-8?B?TnY4VFNqN001MXltVVcwd1JpQlhuRnFHcmFwZ2RJT1RlbDNyamJOa1d6aWt6?=
 =?utf-8?B?SFhadFVJN09EUC9KZ1VvTnExYkhYSmtIT1hYYkphSVBkZFJHbE81c0J4L1hh?=
 =?utf-8?B?ZkJJeFp0cGIrL3hhZks0UGwzeisrYThNbDlJUFozNm15eVE3UjRYR0xRUGFy?=
 =?utf-8?B?aFBiK3djdmF4TnVYejZOdW1Gd1VsZzFNZEpLV0JkeU8xaWoyeVFKZUNDWTl4?=
 =?utf-8?B?TE5QZG02TTNHd3l6MHh4dndmdDhWdXZOVkRsekFMT2VCQVptdDdEVE5Ga1Z4?=
 =?utf-8?B?L052Um83YUhXS0VsOHc3WFZqZWhORndPVGZnc2xkbTJoWG5ySDNIVnNrcEZm?=
 =?utf-8?B?TWFEckxxUzQzaGV0c0pWamxsZlkzWSsvZlowWVFGZDMraVNqYkdJOEVRYTFN?=
 =?utf-8?B?SE1zTkdranFWSlY3UEhFNUM3OVhUSm5BWUV5VEk0YnJQeWRoNm5sWEFObERy?=
 =?utf-8?B?N0JqcTZHS3NQQktmY2NCV0t2MUdQczNNUGxMNFVwKzEzRmYwUytSV2pQbU5N?=
 =?utf-8?B?K2VhbzBNRHNTbC9GU1kweUNSdkxvaXZwNW5jNlFBTUN2MjZoZzV4YXNSdFVZ?=
 =?utf-8?B?aTRNYzJvanFWSFJxeXM5cWVndVlHeDA1M3NMWitZalFxczFMbitJRk10SHFq?=
 =?utf-8?B?d1ZNVkYyMFYrKytNczdvRjhNZkdSRUp5V0pEOEVhQ2Y3bCtJc0Y3ZGxEaVlV?=
 =?utf-8?B?aEZYSWFnMjBYNWRWYm55NjJHdVZjSU13QVdYZFZRcDNhZjhPTGV4anhldXc5?=
 =?utf-8?B?cVFWWXo4RVVpVXhRcXVGdWtiaVFGVGZCL3Y5RGlUVW9WRU1YZWZPeEhaZndG?=
 =?utf-8?B?a1FycUlHU3oxdnVWZ2xXeXJSS1MwSUx1S0JCWnpUVmVzbmh0TDQ2VUVlbHEv?=
 =?utf-8?B?ZWY2NUpCOFNOaWNmVm1kakNWcjRhLzBPU080dTNlQk52NTNTdmxpQ2RoUXlF?=
 =?utf-8?B?NytUU1k0NmlkUllUWnVBUlpNc2NidThQdS90RDZaMk9wRUloOWw0ckZhRjkr?=
 =?utf-8?B?SUF3Mlk1U2VQelNvYnR6L2VLWEVnY0NSeEtnUkhlNkxsTjRZcUQrV2RUN0Vu?=
 =?utf-8?B?Wmx1TWRxYzRCTUdDMWlNZVM4eG1tWlREZGhSTXMrcHVyVUpwNmkyUThDclYy?=
 =?utf-8?B?cStqZk1pcTZ0Vi9hMTVNT1FmTnlJT2RiMU5rTHVMSlh0dnh3djF3a3hWeGEx?=
 =?utf-8?B?aEJXMDdvVmFJSFJXaFpJeFBZcjlNVTZKM1Rtd291dDdGQWRSUk44VkxxUjA1?=
 =?utf-8?Q?5MFbC3R+Vi59dXMDKlW5ATXQ7oth5DWpX10QbId?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f81a69c5-bd19-4266-78a6-08d8ca4768cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2021 02:32:11.6567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C1RuS/IlfDICt4gR2/LJLr9b3azdjVCHLp+FTIIySpMVHDr3FynoyXgpD/2N4sxN/um+5tZLlT8vNPvYpddAJAkPl0OkP+R6/X/+gZwsqLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2046
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmFjb2IgS2VsbGVyIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+IA0KU2VudDogVGh1
cnNkYXksIEZlYnJ1YXJ5IDQsIDIwMjEgMTo1NCBQTQ0KVG86IEpha3ViIEtpY2luc2tpIDxrdWJh
QGtlcm5lbC5vcmc+DQpDYzogTmd1eWVuLCBBbnRob255IEwgPGFudGhvbnkubC5uZ3V5ZW5AaW50
ZWwuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgc2Fz
c21hbm5AcmVkaGF0LmNvbTsgQnJlbGluc2tpLCBUb255WCA8dG9ueXguYnJlbGluc2tpQGludGVs
LmNvbT4NClN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMDQvMTVdIGljZTogYWRkIGRldmxp
bmsgcGFyYW1ldGVycyB0byByZWFkIGFuZCB3cml0ZSBtaW5pbXVtIHNlY3VyaXR5IHJldmlzaW9u
DQoNCg0KDQpPbiAyLzQvMjAyMSAxMToxMCBBTSwgSmFjb2IgS2VsbGVyIHdyb3RlOg0KPiBJJ2Qg
cmF0aGVyIHNlZSB0aGUgcmlnaHQgc29sdXRpb24gZGVzaWduZWQgaGVyZSwgc28gaWYgdGhpcyBp
c24ndCB0aGUgDQo+IHJpZ2h0IGRpcmVjdGlvbiBJIHdhbnQgdG8gd29yayB3aXRoIHRoZSBsaXN0
IHRvIGZpZ3VyZSBvdXQgd2hhdCBtYWtlcyANCj4gdGhlIG1vc3Qgc2Vuc2UuIChFdmVuIGlmIHRo
YXQncyAibWluaW11bSBzZWN1cml0eSBzaG91bGQgdXBkYXRlIA0KPiBhdXRvbWF0aWNhbGx5Iiku
DQo+DQpJIHdhbnQgdG8gY2xhcmlmeSBoZXJlIGJhc2VkIG9uIGZlZWRiYWNrIEkgcmVjZWl2ZWQg
ZnJvbSBjdXN0b21lciBzdXBwb3J0IGVuZ2luZWVyczogV2UgYmVsaWV2ZSBpdCBpcyBub3QgYWNj
ZXB0YWJsZSB0byB1cGRhdGUgdGhpcyBhdXRvbWF0aWNhbGx5LCBiZWNhdXNlIG5vdCBhbGwgY3Vz
dG9tZXJzIHdhbnQgdGhhdCBiZWhhdmlvciBhbmQgd291bGQgcHJlZmVyIHRvIGhhdmUgY29udHJv
bCBvdmVyIHdoZW4gdG8gbG9jayBpbiB0aGUgbWluaW11bSBzZWN1cml0eSByZXZpc2lvbi4NCg0K
UHJldmlvdXMgcHJvZHVjdHMgaGF2ZSBiZWhhdmVkIHRoaXMgd2F5IGFuZCB3ZSBoYWQgc2lnbmlm
aWNhbnQgZmVlZGJhY2sgd2hlbiB0aGlzIG9jY3VycmVkIHRoYXQgbWFueSBvZiBvdXIgY3VzdG9t
ZXJzIHdlcmUgdW5oYXBweSBhYm91dCB0aGlzLCBldmVuIGFmdGVyIHdlIGV4cGxhaW5lZCB0aGUg
cmVhc29uaW5nLg0KDQpJIGRvIG5vdCBiZWxpZXZlIHRoYXQgd2UgY2FuIGFjY2VwdCBhbiBhdXRv
bWF0aWMvZGVmYXVsdCB1cGRhdGUgb2YgbWluaW11bSBzZWN1cml0eSByZXZpc2lvbi4NCg0KLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KSSB0ZXN0ZWQgdGhp
cyByZXZpc2lvbjoNClRlc3RlZC1ieTogVG9ueSBCcmVsaW5za2kgPHRvbnl4LmJyZWxpbnNraUBp
bnRlbC5jb20+IEEgQ29udGluZ2VudCBXb3JrZXIgYXQgSW50ZWwNCg==
