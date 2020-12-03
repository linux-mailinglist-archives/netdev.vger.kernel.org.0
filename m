Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9898C2CDC47
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 18:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgLCRWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 12:22:05 -0500
Received: from mga05.intel.com ([192.55.52.43]:30785 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbgLCRWD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 12:22:03 -0500
IronPort-SDR: p4whA1FncvnZx+ZBwfcVQzJWJ4yoR1c73itJAJmVOyZKx5OAjsHbQzwtNrNveYaZTx6lwcXSTn
 pPRPw3qYdq9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9824"; a="257945537"
X-IronPort-AV: E=Sophos;i="5.78,390,1599548400"; 
   d="scan'208";a="257945537"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2020 09:21:22 -0800
IronPort-SDR: yWAVNd6bkH0EjtU2mOQVVjH42zXMV/nbzJyttlvQKzYx3QAv4p0h/ds0ZDo7P8SHXgzs45K9in
 Y2fLQTpksshQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,390,1599548400"; 
   d="scan'208";a="538465477"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga006.fm.intel.com with ESMTP; 03 Dec 2020 09:21:22 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 3 Dec 2020 09:21:21 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 3 Dec 2020 09:21:21 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 3 Dec 2020 09:21:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwSLU+iYUry/rbX90+jJW5SxvDCqN0M1o05algithSMdJ1wdc9MoRWdPYTVoDQ1+9FKXURYM2xTJgMS3E0qLo1yhmDC93Gl2xlUAajB3Hl4tpECh3MGJVlpSQYgj0aP0qI/zwKpzw9YCq8kaLCQ4Ceq77zf2U9vlxtv4+rlr2B7ueUhadOkTa1w2ASOSD4y65yLw58g92mf9Vp/S6yzjirMDpUpSLDoD9ThUT2G/gptEqPxF/6bDrWSVop0LOIBeOknpbl4qlcNJNK2TQ2SC2ZcDpkUZe386hGIBfejVcGkMA2GC418YmjMqucVgiRT9dGPOo/TYWNH9UDjvrpTnig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3i8mva3xGhYoAgC51wnIWoksMIqVUw+Ebh4HZMtWTHo=;
 b=TZeko58Cqvb9K/EKceLYpgaH8327isCiPy+pKZfFjB1XUfz8mjIMuT33ACJLtoCT1id8c5ypLzz5gmFnn0uVEizpptp+zLwbzawTCaDzL1FWYgPfBdZIaO/3f+DmOyf5R968m53Qu9uAJnHD8gFUqLVAt1u7gb5BDjSUHB20gcyf7c/lgfsQ/OzcMOSPrQ9TEKtVNvsL+5JSwj7xXRCOrZXgXBWTooUrcLYBn9gdbuMyUbZwuGAepHiy/iayAQb76t1vhfiXfSGlIBRX5cvf758tgoclYMq1+uJ6flzLNH7NlL3zy3t1bKfZ6EPSRuXv+Ahm9fMI7lmsRgi10zMoEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3i8mva3xGhYoAgC51wnIWoksMIqVUw+Ebh4HZMtWTHo=;
 b=SrMhbUgs7vW7peaTwv2JOlfxqioPgKmzvO/sf0JujHECLcuZ2uXVb50LpESoec10xZuUCjaRC4jL2N84npiLZmeHzqFTTXYkJ7hSfp5hVtP2Dqx/2M9uYrE5u6L3BtSLLP9T6tGhYzoBaYSZUUIb72huoOBWIV7h7dBhH0sDH70=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB2797.namprd11.prod.outlook.com (2603:10b6:805:5a::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Thu, 3 Dec
 2020 17:21:17 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::5c92:dd20:ec58:76da]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::5c92:dd20:ec58:76da%6]) with mapi id 15.20.3632.017; Thu, 3 Dec 2020
 17:21:17 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "Topel, Bjorn" <bjorn.topel@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "maciejromanfijalkowski@gmail.com" <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH net-next 0/3] i40e, ice, ixgbe: optimize for XDP_REDIRECT
 in xsk path
Thread-Topic: [PATCH net-next 0/3] i40e, ice, ixgbe: optimize for XDP_REDIRECT
 in xsk path
Thread-Index: AQHWyLzrda8gF+4oGEyhe0/rpVFUX6nkRVKAgACsgQCAAK4cAA==
Date:   Thu, 3 Dec 2020 17:21:17 +0000
Message-ID: <618e35ec5aa31b92990a9224181a9011119fc98c.camel@intel.com>
References: <20201202150724.31439-1-magnus.karlsson@gmail.com>
         <20201202204041.GA30907@ranger.igk.intel.com>
         <CAJ8uoz04dFruNnDDyvgbPBZBbMqZxHS6xQJ66dnoPLFtWXv0Uw@mail.gmail.com>
In-Reply-To: <CAJ8uoz04dFruNnDDyvgbPBZBbMqZxHS6xQJ66dnoPLFtWXv0Uw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e3e0ef9-2148-40c7-749f-08d897afd847
x-ms-traffictypediagnostic: SN6PR11MB2797:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB27974A7801D8BE7C289B180AC6F20@SN6PR11MB2797.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Up1KurITX2qm4k8jhasipgpulzuWRN7zKYEUj5Ir2+o0lqxkLFLKzjHrlOqd4fVRQ2qoxRgOGDL9JklWIaG3LHBA+gnHGz+QFIaL8UommeXFqb4gCdGhO8D8VVu4GjWUnaqiU/pRJ/UM2WUPHPjrJzVRbTcCTc8Gsb6nLAY/kTDnqKzw7OQcnizYw22F2DvYZwOZwJcBpvbpFUupCVDI5TDfFWEEwApQXrzvREjWwcS+7CKUiMcjCAMApo9w1f/lsjNxSc3iQs9/l6WkQ5BR7CKvUO1BlFbOdirfwWm38V/HOMCU1Yahr8lId0QSYgoc9CKgHNAtia0Z0IfPxkeI65Mwoyfiafn/fbKnn3ZkbfO1wxmZXZA9+SqVkxknUp+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(2616005)(66476007)(66946007)(71200400001)(64756008)(66446008)(66556008)(36756003)(110136005)(83380400001)(5660300002)(6486002)(54906003)(26005)(316002)(76116006)(91956017)(186003)(478600001)(6512007)(4326008)(8936002)(2906002)(8676002)(6636002)(6506007)(86362001)(53546011)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WEZSZEFGc0prWjFYU3NVTVRKNXI0RDhjczNqT29EV1BkOFc0akVQVnhvdVJX?=
 =?utf-8?B?SDA0akhxRnRJZzF5NzJQSnNLelpBa0tNSElxVVp3N0M0MC9YQldIUnp6V09n?=
 =?utf-8?B?NWNpQndqTXkvdDNBTXJkQ1ZGT080clNWem9nUDFCb1dXei8xWDJBUHFKOE50?=
 =?utf-8?B?bkwvOTA1dGN1RWpGRnN6bTRaaVhRSDRqd2VPY3R5Z3NSOGU3UnlzTzdzd0xu?=
 =?utf-8?B?b3luRnJVUmtsTWpRR0VhYVMyeWhpVVVLdkY4SUhRZG9mTk1DQncrMUdwREdX?=
 =?utf-8?B?Z0FCUmlKVW4wWkd0UWM4T095b0thRTBKaURuRkJseXZrS2lGN2NjWmg1Mmdj?=
 =?utf-8?B?U3RDNDdlRVFYclpDODUxZlArdTAxY1B1RmRVVDNiQ0NKRGRkTld4QnllcG56?=
 =?utf-8?B?aDk0V3YzdndMTVdXb2U4eWQxV015c2s1T2pOL1hGdXRkRisweDFnU1RZZnFH?=
 =?utf-8?B?d2lvWXQzM3B3R2ZGRDJDVFA4OGVOMTBxNndERGdNOElIUjNxTk9JU1FQK0Rt?=
 =?utf-8?B?N1diTVpjc1pzRG95djgwd2d4a2JjZUorWVRuUHU2dFVQeTAzN1dQR0pnbVoz?=
 =?utf-8?B?YkZYaE93bWRFMFU5d1J6RGI1RXlJdktjak11Y2xldnpxbENxK3VMdjlPdnU4?=
 =?utf-8?B?WEtTTkIzOG42anlqRS9WYmhjUGk2YUZWTnFucS9qZ1RzM3o2QkxyUzIxRGVE?=
 =?utf-8?B?cjF2bjdPS2FFcE1oRDRTbGZyNkphdkJtRUtjaHFGSENLeHlzbURVS1lPODZX?=
 =?utf-8?B?VGNKSnFwMU9ra1EzREFmbHN1K0hKRjBMVXhVMG8yODltb2NXOGV6b1kzVGUy?=
 =?utf-8?B?aUNnc3dVZzM3QVM1bVFITHBkWWRHTnVnd2lYcm5jRVJleVdOeGZEcUJzb1Jm?=
 =?utf-8?B?eldZbzJ6NVFnaXEzOUd4MThhSVpYZ0dDYVN6WTRJY2hRN3NvOVVweGxnakJz?=
 =?utf-8?B?dkJEOGhZN0JacHlYaUdLYUpqMS9pTmprNnJPejRFV0N2ZEZGRnVGalFqM202?=
 =?utf-8?B?Q0JsVVNSTDJxNzhvc1BoYUlxckxtSEM1U0phcnFqTXVNVTJlYlh0VlFRMTRk?=
 =?utf-8?B?bGNDTHRCU3QyWkx0QXdSRE5UbXUrcU5zdU93QWxteGc2L1JHMmZmcGp0QWpu?=
 =?utf-8?B?eEJUL1kyQkQ5YTRvZE5LVStUV3FjWDRTRElsMmxtVWRDK2lSMFJQMXkrOXha?=
 =?utf-8?B?NDE1NHM1R0xleEs3cDJFZWJwVTdqKzM3b25FRTd5Znc1MnNnWXFxaXlxSzhJ?=
 =?utf-8?B?bExzQzVFTzd1SkZmZ2VsdXZNN1Y0dGtRK1FuZ1dueldmUEwyTFVHcldJNTdJ?=
 =?utf-8?Q?j9/kjDZB84TkrcQHUZU6hKLEclUOpNw3if?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF669FC06D55C14F9F352A90D6356F2A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e3e0ef9-2148-40c7-749f-08d897afd847
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 17:21:17.5898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7R7pkkOV0nyW58xGIWoZ3rgoWe9cTu3vY6fiAhIel4ot6JPODrrFTZm+PDo3SiDdMvIzNggapXTusaH5Rc2gH6bXsPPuKlT1iopC0rBaMvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2797
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTEyLTAzIGF0IDA3OjU4ICswMTAwLCBNYWdudXMgS2FybHNzb24gd3JvdGU6
DQo+IE9uIFdlZCwgRGVjIDIsIDIwMjAgYXQgOTo0OSBQTSBNYWNpZWogRmlqYWxrb3dza2kNCj4g
PG1hY2llai5maWphbGtvd3NraUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIFdlZCwg
RGVjIDAyLCAyMDIwIGF0IDA0OjA3OjIxUE0gKzAxMDAsIE1hZ251cyBLYXJsc3NvbiB3cm90ZToN
Cj4gPiA+IE9wdGltaXplIHJ1bl94ZHBfemMoKSBmb3IgdGhlIFhEUCBwcm9ncmFtIHZlcmRpY3Qg
YmVpbmcNCj4gPiA+IFhEUF9SRURJUkVDVA0KPiA+ID4gaW4gdGhlIHpzayB6ZXJvLWNvcHkgcGF0
aC4gVGhpcyBwYXRoIGlzIG9ubHkgdXNlZCB3aGVuIGhhdmluZw0KPiA+ID4gQUZfWERQDQo+ID4g
PiB6ZXJvLWNvcHkgb24gYW5kIGluIHRoYXQgY2FzZSBtb3N0IHBhY2tldHMgd2lsbCBiZSBkaXJl
Y3RlZCB0bw0KPiA+ID4gdXNlcg0KPiA+ID4gc3BhY2UuIFRoaXMgcHJvdmlkZXMgYXJvdW5kIDEw
MGsgZXh0cmEgcGFja2V0cyBpbiB0aHJvdWdocHV0IG9uDQo+ID4gPiBteQ0KPiA+ID4gc2VydmVy
IHdoZW4gcnVubmluZyBsMmZ3ZCBpbiB4ZHBzb2NrLg0KPiA+ID4gDQo+ID4gPiBUaGFua3M6IE1h
Z251cw0KPiA+IA0KPiA+IEZvciBzZXJpZXM6DQo+ID4gQWNrZWQtYnk6IE1hY2llaiBGaWphbGtv
d3NraSA8bWFjaWVqLmZpamFsa293c2tpQGludGVsLmNvbT4NCj4gPiANCj4gPiBZb3Ugb25seSBh
dGUgJ2UnIGZyb20gaTQwZSBzdWJqZWN0IGxpbmUuDQo+IA0KPiBTb3JyeSwgeW91IGFyZSByaWdo
dC4gVG9ueSwgd291bGQgeW91IHBsZWFzZSBiZSBzbyBraW5kIHRvIGFkZCB0aGlzDQo+IG1pc3Np
bmcgImUiIGluIHRoZSBjb21taXQgbWVzc2FnZSBiZWZvcmUgeW91IHNlbmQgdGhlIHB1bGwgcmVx
dWVzdD8NCj4gDQo+IFRoYW5rczogTWFnbnVzDQoNCkkgY2FuIGRvIHRoYXQuDQoNClRoYW5rcywN
ClRvbnkNCg0KPiA+ID4gDQo+ID4gPiBNYWdudXMgS2FybHNzb24gKDMpOg0KPiA+ID4gICBpNDA6
IG9wdGltaXplIGZvciBYRFBfUkVESVJFQ1QgaW4geHNrIHBhdGgNCj4gPiA+ICAgaXhnYmU6IG9w
dGltaXplIGZvciBYRFBfUkVESVJFQ1QgaW4geHNrIHBhdGgNCj4gPiA+ICAgaWNlOiBvcHRpbWl6
ZSBmb3IgWERQX1JFRElSRUNUIGluIHhzayBwYXRoDQo+ID4gPiANCj4gPiA+ICBkcml2ZXJzL25l
dC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfeHNrLmMgICB8IDExICsrKysrKystLS0tDQo+ID4g
PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV94c2suYyAgICAgfCAxMiArKysr
KysrKy0tLS0NCj4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZS9peGdiZV94
c2suYyB8IDExICsrKysrKystLS0tDQo+ID4gPiAgMyBmaWxlcyBjaGFuZ2VkLCAyMiBpbnNlcnRp
b25zKCspLCAxMiBkZWxldGlvbnMoLSkNCj4gPiA+IA0KPiA+ID4gDQo+ID4gPiBiYXNlLWNvbW1p
dDogNmI0ZjUwMzE4NmI3M2UzZGEyNGM2NzE2YzhjN2VhOTAzZTZiNzRkNA0KPiA+ID4gLS0NCj4g
PiA+IDIuMjkuMA0K
