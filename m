Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CC033C773
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 21:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbhCOUJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 16:09:29 -0400
Received: from mga03.intel.com ([134.134.136.65]:12123 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231893AbhCOUI7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 16:08:59 -0400
IronPort-SDR: lKP++51m1sVdnfXHXomaKdfAqI6jb1CPQADEQGojPZV/Ao9COcEabSz3hHl6Fc2i6h//HeeKmH
 01lmCmJEeX7g==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="189198671"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="189198671"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 13:08:56 -0700
IronPort-SDR: tQqiB6Ad+zGqA81t7FMOJk+x6jkEadvSp+8w+ZFH7lq6ppn39mQWOMaD703LxpGw03bBI6FRS5
 DwzwbMSAnS/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="604982558"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 15 Mar 2021 13:08:56 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 15 Mar 2021 13:08:55 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 15 Mar 2021 13:08:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Mon, 15 Mar 2021 13:08:54 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 15 Mar 2021 13:08:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOKnSLPOAuzUDBKhwfO8ZMPUxRz8MEw4QSNhvQO4gwypuDzVEiW8BknyvrWWn5z2BoVJkF5hGsSuFq3wG2e6RyXlNr0Zul+2sXjiQWFl2ltHlmld+bxc7R6OcSrMN48XIPE+QyCgqFMcbSanTKz845+f0wlLPKkgjiwtS8G7Q0L39MKJxRut3sXogrw0E/UeWEC+G/PSWAbUUkiKqUA0bwmOy+dWLO3iBUogQy+L6Y76/gtJGjUG7eJ39u914LcuNHej0CjCX3oP9xxboU5kVQveG5NmITsVxEtOEA8hw5iXOGP1VacJE2V9bIIPQjkGYmbr3Aw54HaMh2UihhhMhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GWJEVTmWOA6Vz/tryjIfkHsgneer3jMO6clOBSvQyw=;
 b=X1kRwG4IKVXuwUC3X6AOvh7URS+oJUjP4qnQG3s14yv26sprlWhlQQXojnKYxHKl+sNVjrDu4a9y3vpE/Y8YuIH9B4pq6S4lhGQpdkDUMQU8iWJWPhyIr+S/Y6qb8tDzy2U6CmL9m1jYI+F8TOWQdQzyxqLsaFVUHbqkUIgBajlKP90Q//7IQ40RSksTTqQ6EUrx2K2ylqUjI4EspEeorbJXIxHsRgyPx/ipGIZLMd9a7Vj/MSlJ8y9zDLhixeQookXDjN9yBsVdRIx+LRI4q9YLD9nGESOHR5AVe7CXJMn1VtcY+vs+0H01nd2tdcGsxyEmLX/I7I5/jYasahPXdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GWJEVTmWOA6Vz/tryjIfkHsgneer3jMO6clOBSvQyw=;
 b=ZTzAxSFS7LFKFYoX4bAUXxGogGpwrfjyiBbNXYdCB2R1vC3N48/wZaWSoM9tIfSX5KpOFeo8A06CetZpKN2KRw3UHwAEZSTKPF/Oy1juAvOpL195eyNfwF2UpNHajmUGoAQ9YSwRSBE4ixawV2/9kXqwxB9N0+9S5+EExAN9ubQ=
Received: from BYAPR11MB3095.namprd11.prod.outlook.com (2603:10b6:a03:91::26)
 by SJ0PR11MB4909.namprd11.prod.outlook.com (2603:10b6:a03:2af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Mon, 15 Mar
 2021 20:08:53 +0000
Received: from BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6]) by BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6%4]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 20:08:53 +0000
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
Thread-Index: AQHW/9Zt8wdlPnXnkESxoD5/CU9Koap9GIKAgAMHmACAAN/QcIAAU8sAgARZsFA=
Date:   Mon, 15 Mar 2021 20:08:53 +0000
Message-ID: <BYAPR11MB3095D6CC7DB2DC4E111561B1D96C9@BYAPR11MB3095.namprd11.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: ad50c51a-610b-4fff-4a8c-08d8e7ee280d
x-ms-traffictypediagnostic: SJ0PR11MB4909:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB49098A561A5EA86E201DA7DCD96C9@SJ0PR11MB4909.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ctcted7vTOS4Ua6HJfV3fhkRdP9sK+vm8M0OiMxWN2BXiv03aJtTbLgLanR8dqAvTV/EEI0SJHuGcVqD32oJEytsB7oeaf+ZbBwi9kXpgo0Vu44OUbft2ivviQC2r72h3Gc5IT7i4La0eYATCINSb8/WtD2ZiZMsWsX9lp6EUHvxfrey+tyxvT6bHdtOtLnP08a0YpmXZPJ6pU2wqKuIEKc8nOvlBPa9/uy1GCVm/VermVqKtF4+N4Tiz7dLMDfKeeedfjCyDf7g/eljZZS6hOcQhjBIA3vM0iqf3pi5WAdigk1Eb9ccpQmKY9t66ndaBVYvbHKDOveu3jD7aKLQkbCLYQeq2GQDczhwRA81ZJAYT+YC4AZihqKFiFTDJGMKumWPclw9CbjvSBGUWDqI1GY2sZ1+hJV4toEjtSdsFmx4gesOZhK10u4q/xn+3zKgYAfuR6km2QabYrZKmUyDmMLnrRyfX9KbO+WPV900y7BaMZatv9Dwd+Hi2R3c/Fz08w4irKfH61Ux2yS4mQsQwGlIvUVxKWHZW0lvmgLuaKDQ8j7GPLCX9xRBYDlbomRH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(396003)(346002)(136003)(6636002)(71200400001)(2906002)(76116006)(66946007)(4326008)(8676002)(52536014)(6862004)(54906003)(55016002)(6506007)(53546011)(64756008)(7696005)(8936002)(4744005)(33656002)(66446008)(5660300002)(9686003)(26005)(316002)(186003)(478600001)(66556008)(66476007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?OS9HS2ZKOE5hUVg5UTVZMHduU2R0RHlmV1hqUFlmUlRENGl4cmg4NXVpMFhI?=
 =?utf-8?B?elo2eWhwQ2laczNQZEZEalJGbkQvb2x1Q0FHZGptdzlwaXdkS1BuRGJjNFI1?=
 =?utf-8?B?ZytqTEovUFI5eVpNOW84dzNJSExLRnB2dkl6QzNrUXoxY2ZMbzNIaU9EUFc2?=
 =?utf-8?B?cDdnTmdCOXgwOGFxTVlXajdnNERwMTZNOENGZ2dUYytVYndsY2ppYnVzenFk?=
 =?utf-8?B?RGtaMnpvRGdCVzlYZkZGWnJpWVJRaUZPL1IrMlZpOUJRVUg4UGI3QnNtZ2dY?=
 =?utf-8?B?RW5IRmNRcWIybkJsQkt3b21sczNwdktwa1plZjI3Y21oR2ZjaHZlcXFZM25q?=
 =?utf-8?B?eC9VQm5KZWFEeHBMeUZlaDVnVU5VTXZ6bGgyb2JuVmpjdHdCdlZHRjEvZXp6?=
 =?utf-8?B?MXh4OTYrNngybUNGT1IvSmpCSXMyby91eTJSemlLYWQyVTFmRVJWclo2cUhJ?=
 =?utf-8?B?ZjZWOUhYWTExSXZ2allCSGduR0phb1BtZmYwM3U4YncyL3pDeC9LS0RHbGd1?=
 =?utf-8?B?elBxaEN5L2orVHg5R1NvbERzMWV3aElHNVlnK1dsTklrNEFiWXlJMnhYT1Q5?=
 =?utf-8?B?ZGY5aW9ld2o5TnJNMFhLMzl2UDJYVHZUdXoxZ1RWcHh0eUpZeGZEUEVacDlK?=
 =?utf-8?B?c3NZZVA4QlAxUWQwQkFjNjVPWDhpOGVYcFZ6bWF4YkpwTDc1S2JXMjRFd2pi?=
 =?utf-8?B?STdoVHlva0tCTkNRV2JUUTFBKzhoNm1wTGhrNlRxakVDQTUxMGQvVWg2VVlM?=
 =?utf-8?B?L0p3ZVNRNDRwQkQrZVlhUFVQQlMvQ0RrTGJlWmxmbWFMWklVOWIybkVwOENI?=
 =?utf-8?B?TVNlaHNNNnA2WmhpMnphUHVZVzdTLzdEcERIbnErSnlnRXFsaEhWVVFFRDVu?=
 =?utf-8?B?a3JEaS9JVmVxWDhrMFliakkvU0FoNkVBVFNLKzZsQ2FTVWw3b010UUJOYXBJ?=
 =?utf-8?B?YjZNeDV6VXZyVnB4NWt1RTM4QU8xZTI4OXRER3dLdGZyeXlRNnFHc3NTM3pK?=
 =?utf-8?B?VDhncFlGRHE0Q1lNOXBHcGRtVGNGN2YzeVZ0ejMzVTltZHE3WTFDNTAvMVl2?=
 =?utf-8?B?cEp0ZnQvQVFsanRob3IyMHZ1TEhGQkpDS2RBQXNNcTZndXRHOUl5L1kyT3RB?=
 =?utf-8?B?UlhrYVBoMUlITFJIUjFHVE9iOE1ycTBLeGw5aUozQlNxQVJqcXRncFVsTGZR?=
 =?utf-8?B?c0c1WDY5QlVOOHY4RnR0SVN4WHpFV1ZNc1pMYk9VZmFIc1VHTVNUdFg4ZzhD?=
 =?utf-8?B?K2dXZGRaV3FIYTR1UVRBYVY0SUM3NlpWZjZ2YXdSdHhBOGJoNlpkekRFS2c0?=
 =?utf-8?B?aFBRWi9lcE5CSWtBVkhqTFo5NGZnZ1J2ZUs3dmpYcjRrWjdyeXU3L0R5UHRx?=
 =?utf-8?B?UktjbzFnMjlrbmNpSlBWSnhkY1l3WmdNTHRKVStMVVlOb0NCM3ZWSStlZXRv?=
 =?utf-8?B?TXc4c0JGMk1SaVg5U2x6bVdvT0lzTlQxT05nUVNFY3hQVGUvcW9KeWlzRGlv?=
 =?utf-8?B?eml1R2tVMndyUktVa3NibmNEdHZOQjJMcG9qVHR5NmZXdHlMK1RkZm5jYW96?=
 =?utf-8?B?dEFOYkRkWEFTaXhjOGN6NS9CR0VTakxPbXFUeUJXaXhxN2k3enRXMC9KZTVZ?=
 =?utf-8?B?S3J5NUIxa1BTcFlZa212bVZqOGZPNDJFMG42TVlVazVDZ0wwVGljWktBZnJu?=
 =?utf-8?B?TFg3a09rc1h2WUtwbzZwQ1UyV2FqSmg2bEp2cWFQQmd0ZkkvYzVUMmxndHFy?=
 =?utf-8?Q?UujuzGMVpNghh7gU1zvgfxGu3CezBsyNBoirC6I?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad50c51a-610b-4fff-4a8c-08d8e7ee280d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2021 20:08:53.2228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0NIBRA8K0HDvDK6SON3a7ihZMyioutNWGjuub1XI7eXg4blZa04wW/pJwozm5TqmIeqNLatHwInUDrF69IgK6ZHXKyIxHZUPvvuXmsZ3p0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4909
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4gT24gRnJp
LCBNYXIgMTIsIDIwMjEgYXQgMTo1NSBQTSBDaGVuLCBNaWtlIFhpbWluZyA8bWlrZS54aW1pbmcu
Y2hlbkBpbnRlbC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gQXQgaXRzIGhlYXJ0IERMQiBjb25zaXN0
cyBvZiByZXNvdXJjZXMgdGhhbiBjYW4gYmUgYXNzaWduZWQgdG8NCj4gPiBWREVWcy9hcHBsaWNh
dGlvbnMgaW4gYSBmbGV4aWJsZSBtYW5uZXIsIHN1Y2ggYXMgcG9ydHMsIHF1ZXVlcywNCj4gPiBj
cmVkaXRzIHRvIHVzZSBxdWV1ZXMsIHNlcXVlbmNlIG51bWJlcnMsIGV0Yy4NCj4gDQo+IEFsbCBv
ZiB0aG9zZSBvYmplY3RzIGFyZSBtYW5hZ2VkIGluIHVzZXJzcGFjZSB0b2RheSBpbiB0aGUgdW5h
Y2NlbGVyYXRlZCBjYXNlPw0KPiANCg0KWWVzLCBpbiB0aGUgdW5hY2NlbGVyYXRlZCBjYXNlLCB0
aGUgc29mdHdhcmUgcXVldWUgbWFuYWdlciBpcyBnZW5lcmFsbHkgaW1wbGVtZW50ZWQgaW4gdGhl
IHVzZXIgc3BhY2UgKGV4Y2VwdCBmb3IgY2FzZXMgbGlrZSBwYWRhdGEpLCBzbyB0aGUgcmVzb3Vy
Y2VzIGFyZSBtYW5hZ2VkIGluIHRoZSB1c2VyIHNwYWNlIGFzIHdlbGwuDQpXaXRoIGEgaGFyZHdh
cmUgRExCIG1vZHVsZSwgdGhlc2UgcmVzb3VyY2VzIHdpbGwgYmUgbWFuYWdlZCBieSB0aGUga2Vy
bmVsIGRyaXZlciBmb3IgVkYgYW5kIFZERVYgc3VwcG9ydHMuDQoNClRoYW5rcw0KTWlrZQ0K
