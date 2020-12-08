Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CBA2D35BF
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 23:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730450AbgLHWCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 17:02:11 -0500
Received: from mga05.intel.com ([192.55.52.43]:16337 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729844AbgLHWCK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 17:02:10 -0500
IronPort-SDR: 1CyU6g0/KaV652ytEQFo29dFQNMNU5F46NnjyXFq2AuHCM0aFa4qO8SAhGs/Ej5RWyktFHflKc
 kuS8rMrr0LfQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9829"; a="258686333"
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="258686333"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2020 14:01:29 -0800
IronPort-SDR: 5h6be+5WPj1QK8qrPiFv8BNvGmqB59qe6Ic5tyUlzCOBIzRvsFF5Y38Y5hkBlFScT+7qwYYdC8
 HHi2v2n1+BNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="540394010"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga006.fm.intel.com with ESMTP; 08 Dec 2020 14:01:29 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 8 Dec 2020 14:01:29 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 8 Dec 2020 14:01:29 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.58) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 8 Dec 2020 14:01:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFbDfNh0NinkNcX6RUc25p8OL3UBeZQ45Z6ncmLAy0b6IIepqBcU4+8gbNEvyLqvtvddZ77f1xY6BbqyAjc4xkV/hZrrywoWblY0Ap7xhaTU8ofyYg8VerU5zb2I5Z64j6xfhPMKtqaf79mpLJGynNjh5dTueaF37Fl7s4yizcXK7+AhiNawlirANLMh0pLFZGuL88zhOXqSpucPDLXLQkbxKwlwQm9pAqGjN3xGZqQFKD2UkVB43JHAShdUg4pldoSnplue9gla80JHOYdMFB5mAYGIguu3+AJcIRCChr4AHtF2IIJ6IrNnNBH7IkLJv0aWs0IvDc0PFFMJPfr/jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUH/vMsqtaT1TE8JK3AiX8QCc6ClDJly9RVdvepH8ds=;
 b=h5C6BBNtMb4JXuj8bJ7jqWFc9w+uzb8bOnuygCXzGVyOSS9xairiqdY2oRsOxUDpPQtauyLILF726wKwbbnTjnwYnUwjMCQ7OowYL9gloJvE9wVWArrQ+eOs/NAb1tENHgi0pd65ncmARjebgJ3eoOUHXZim5ylJAafpL5BBLqfEYwRixTBlAIDU73wXevdDBwrThh72FcUt2MF2CQQdJt3CIbMARMRRFkKhFcNsrbffXBPcRf6l90UE6wH2oUw62ANJ2QKGaeOeC1EBeltyvn4aOPbfs+VXMPHmohNtGdWDkRwWmQn8QuxUeyi9SI1lCwJAXHWqdqK8uZj6n23Qqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUH/vMsqtaT1TE8JK3AiX8QCc6ClDJly9RVdvepH8ds=;
 b=tPFNXa1PXM4sqFjqLo0re/tMBYbhRkj+rlzgN6+uC7nCCFkJAReLV1riLm2LZ+a4IR7PXVokKxrejYOy8BKfX7HrjnT7l7QBtLZIp8LzeKQrkjCKxoGEfOCDENNL3+N0ldAGRtGlaV/mPjX6d8kOa37rKeJ68f8lAQkHtFo2Gyk=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA0PR11MB4557.namprd11.prod.outlook.com (2603:10b6:806:96::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Tue, 8 Dec
 2020 22:01:25 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::5c92:dd20:ec58:76da]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::5c92:dd20:ec58:76da%6]) with mapi id 15.20.3632.024; Tue, 8 Dec 2020
 22:01:25 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>
CC:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Cao, Chinh T" <chinh.t.cao@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Valiquette, Real" <real.valiquette@intel.com>,
        "Behera, BrijeshX" <brijeshx.behera@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [net-next v3 05/15] ice: create flow profile
Thread-Topic: [net-next v3 05/15] ice: create flow profile
Thread-Index: AQHWugZDQ0KUjLzWCEaF3FhqdKPwsqnGvQ6AgAsNTYCAABK5gIAEjaeAgAAeq4CAFwldAIAAIdmAgAAyrQA=
Date:   Tue, 8 Dec 2020 22:01:25 +0000
Message-ID: <15a6887213b9ba894b113bb8aee834b992e0958a.camel@intel.com>
References: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
         <20201113214429.2131951-6-anthony.l.nguyen@intel.com>
         <CAKgT0UeQ5q2M-uiR0-1G=30syPiO8S5OFHvDuN1XtQg5700hCg@mail.gmail.com>
         <fd0fc6f95f4c107d1aed18bf58239fda91879b26.camel@intel.com>
         <CAKgT0Uewo+Rr19EVf9br9zBPsyOUANGMSQ0kqNVAzOJ8cjWMdw@mail.gmail.com>
         <20201123152137.00003075@intel.com>
         <CAKgT0UcoYrfONNVrRcTydahgH8zqk=ans+w0RcdqugzRdodsWQ@mail.gmail.com>
         <4bd4d1e76cd74319ab54aa5ff63a1e3979c62887.camel@intel.com>
         <CAKgT0Uf+Q_dcx5Jj99XFVwf=AxbAWAD_r9PUAsbOCXdR46cMig@mail.gmail.com>
In-Reply-To: <CAKgT0Uf+Q_dcx5Jj99XFVwf=AxbAWAD_r9PUAsbOCXdR46cMig@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55b6835e-534b-4d55-81a7-08d89bc4ce73
x-ms-traffictypediagnostic: SA0PR11MB4557:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB455724C58724486711A8D8B1C6CD0@SA0PR11MB4557.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tMVAn7feBan5NeQfCKKT3PTPDB7cXP/NbJOrYlOGtvT6y2B+eeIb4AYhik3K8Ikj6y5Sl4qjqMx3m8mYNu8LoJMvzHehVa1GffHtrDaWs5nvwYCbX2X86Mh60txSsmeYRKGdg7qA4U0FV4nbo72aAeHJxzawv0a1Hq59WIzhTIjs16GCuPvMAzhUjnFRiQV70w+hbDN9N/VwalbhEdiXd3Apk0HbsGlGeblQExuj5HexIZapXPAoOW0w2r+8cL7lhtjojsA6g++SzDKWYX4ispqnPC58Dv+1Tqhw4WV+dzsfvgfYRU4TjD0EFzW7RQ91kdF4RwALif2j5IXmujiAAXm7cjmCrd4nvjtGul91Do1rq/TsYAayk1h4I+SPFzIv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(2616005)(64756008)(4326008)(8936002)(508600001)(54906003)(2906002)(4001150100001)(66556008)(6916009)(83380400001)(5660300002)(6512007)(71200400001)(66946007)(26005)(91956017)(6486002)(8676002)(86362001)(6506007)(186003)(66446008)(36756003)(53546011)(66476007)(76116006)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bllQQStlVThaZTBtTndmK0FsYnV6Si9xc0xGSWV6Y3B0TS9RQ3J3ZEJMNUdu?=
 =?utf-8?B?NkFXV0Rsb092RFdqbXFxNk5tUUplYnRpVTNGYkpBWWF0cmhmaERTWDZTSmVB?=
 =?utf-8?B?dDRuYTlZNndRWVkvbGwwWTZPR2FNRFh5c1ZBOCtrTEZqUEdXTG9lb0RFZmRv?=
 =?utf-8?B?T1hXbEExc3NmU2I1Z3cydzBEWDU5ZGFJcHV5WnI3OEcvbjdldEZNamJCRThY?=
 =?utf-8?B?Zm81N2RTZEpXaVdvY3pkbE9xWmx0akVmWXJnQnR5dU5DU0pzTTRKcXl2d0o0?=
 =?utf-8?B?T2pIMkNVNW8wVUtxWDVCcFJQNVNtVUgwb2JjOWdZVkVGTGZOZW53K0l4cTZO?=
 =?utf-8?B?MWpOUUNyaEd0YmI3aExscjdwdjJPMzlyR0pBaFJiRFpqMU5UcmxSTG45cWRa?=
 =?utf-8?B?Q205dndjNXBtUjlWK3Z6eTRtUnRwNDVxaTNEdWJZWDI4aEoycjdsVVJGTkEr?=
 =?utf-8?B?OEE4TjZabkJpblo4UGU1L0Q0T25kMFVPQVJDNVBuREoveFlJUXNCdTJsdXJr?=
 =?utf-8?B?eER1YUJxYklFSXNQOGxUdm9oc3ZZNlh1SUNzSXRtRUJOL1JHQlRiUU1HQzFt?=
 =?utf-8?B?VVJJRnpBRjg5WklueGk2Nk4zMVBQWS8vTGQ2SnU3RFloYXpPb3pydVhER2NY?=
 =?utf-8?B?WlZTNFlvR1ltNkZ4TU5hT0Vyc3lBZjZ3REhqOG1obHF1ZW96V0lhR1RadTg4?=
 =?utf-8?B?MURTMjZOaU9uTTFKdkVlNFNGRkxIbmhkc1J6K2lla3FKNzNLVlVyajgwQTBu?=
 =?utf-8?B?WlhPeGloNzdOQyt1NHR0ZnVKbCtTMVowTGhhNHBWYW9OaXJxNkRHMG0vTjZ0?=
 =?utf-8?B?dS81a2hnYnY3VGhrMkMvMUU1eGZrNTU3WTRIOTlsMWFvSm1xcnhoemh0S2d1?=
 =?utf-8?B?aVUzY1VOMHRuSE9qT25ZR0wxNTRCRzd2M05RWW5mNThmOXVpMitibVExUjNI?=
 =?utf-8?B?azJDYVlINDJwZjJ3ZncxMXlNdFJRSWl3MWRrVkhwekRYU0ZDWVM0TXNxTDdM?=
 =?utf-8?B?S0VjeXdwU0JjUE0xanFBMUNMUXpweHlKb2F0V1N3SGF5VEZ0YmpZTHEwbEUy?=
 =?utf-8?B?bk12cWJIQTErbVZtMnV1aTV5bFpQYTZtZk9jQkc0Sy8vWXB4RG5Rck9qTGlI?=
 =?utf-8?B?MFVacDJ6YlJPc2w1VHVZNVBhY3BQYmt1VEkxU3NxUTlweHRBWkZkNURaY1FU?=
 =?utf-8?B?TnNzUmM3UFlIbTg5aWxGT2VTQlpVM3ZnaENQQXJFcG5qVUpHaG1TcGZhNWc0?=
 =?utf-8?B?QmRDTmtIeThHU1hSd0hHQXNodHZrOUtjd2tLWW5rcDM4aDB6bU1hTFZQZ2ox?=
 =?utf-8?Q?zZwtVDM84h+Q4uIIYss49Srgx68caH+2ZY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EEE24CBA4F94334BB0DA25E78BC26C22@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55b6835e-534b-4d55-81a7-08d89bc4ce73
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 22:01:25.1007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GGAdHdfc2YXZa7i5GqT+FtHb9o2AKCtf/TMLQnmPWx9du8jwHwTX4UE4tnp9Xz76+GmPgI3geFMukHqYOGKHeH0fQrPYhmx4ctGHKHx1gWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4557
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTEyLTA4IGF0IDExOjAwIC0wODAwLCBBbGV4YW5kZXIgRHV5Y2sgd3JvdGU6
DQo+IE9uIFR1ZSwgRGVjIDgsIDIwMjAgYXQgODo1OCBBTSBOZ3V5ZW4sIEFudGhvbnkgTA0KPiA8
YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIE1vbiwgMjAy
MC0xMS0yMyBhdCAxNzoxMSAtMDgwMCwgQWxleGFuZGVyIER1eWNrIHdyb3RlOg0KPiA+ID4gT24g
TW9uLCBOb3YgMjMsIDIwMjAgYXQgMzoyMSBQTSBKZXNzZSBCcmFuZGVidXJnDQo+ID4gPiA8amVz
c2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+IHdyb3RlOg0KPiA+ID4gPiANCj4gPiA+ID4gQWxleGFu
ZGVyIER1eWNrIHdyb3RlOg0KPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gSSdtIG5vdCBzdXJlIHRo
aXMgbG9naWMgaXMgY29ycmVjdC4gQ2FuIHRoZSBmbG93IGRpcmVjdG9yDQo+ID4gPiA+ID4gPiA+
IHJ1bGVzDQo+ID4gPiA+ID4gPiA+IGhhbmRsZQ0KPiA+ID4gPiA+ID4gPiBhIGZpZWxkIHRoYXQg
aXMgcmVtb3ZlZD8gTGFzdCBJIGtuZXcgaXQgY291bGRuJ3QuIElmIHRoYXQNCj4gPiA+ID4gPiA+
ID4gaXMNCj4gPiA+ID4gPiA+ID4gdGhlIGNhc2UNCj4gPiA+ID4gPiA+ID4geW91IHNob3VsZCBi
ZSB1c2luZyBBQ0wgZm9yIGFueSBjYXNlIGluIHdoaWNoIGEgZnVsbCBtYXNrDQo+ID4gPiA+ID4g
PiA+IGlzDQo+ID4gPiA+ID4gPiA+IG5vdA0KPiA+ID4gPiA+ID4gPiBwcm92aWRlZC4gU28gaW4g
eW91ciB0ZXN0cyBiZWxvdyB5b3UgY291bGQgcHJvYmFibHkgZHJvcA0KPiA+ID4gPiA+ID4gPiB0
aGUNCj4gPiA+ID4gPiA+ID4gY2hlY2sNCj4gPiA+ID4gPiA+ID4gZm9yDQo+ID4gPiA+ID4gPiA+
IHplcm8gYXMgSSBkb24ndCB0aGluayB0aGF0IGlzIGEgdmFsaWQgY2FzZSBpbiB3aGljaCBmbG93
DQo+ID4gPiA+ID4gPiA+IGRpcmVjdG9yDQo+ID4gPiA+ID4gPiA+IHdvdWxkIHdvcmsuDQo+ID4g
PiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBJJ20gbm90IHN1cmUgd2hhdCB5
b3UgbWVhbnQgYnkgYSBmaWVsZCB0aGF0IGlzIHJlbW92ZWQsIGJ1dA0KPiA+ID4gPiA+ID4gRmxv
dw0KPiA+ID4gPiA+ID4gRGlyZWN0b3IgY2FuIGhhbmRsZSByZWR1Y2VkIGlucHV0IHNldHMuIEZs
b3cgRGlyZWN0b3IgaXMNCj4gPiA+ID4gPiA+IGFibGUNCj4gPiA+ID4gPiA+IHRvIGhhbmRsZQ0K
PiA+ID4gPiA+ID4gMCBtYXNrLCBmdWxsIG1hc2ssIGFuZCBsZXNzIHRoYW4gNCB0dXBsZXMuIEFD
TCBpcw0KPiA+ID4gPiA+ID4gbmVlZGVkL3VzZWQNCj4gPiA+ID4gPiA+IG9ubHkgd2hlbg0KPiA+
ID4gPiA+ID4gYSBwYXJ0aWFsIG1hc2sgcnVsZSBpcyByZXF1ZXN0ZWQuDQo+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gU28gaGlzdG9yaWNhbGx5IHNwZWFraW5nIHdpdGggZmxvdyBkaXJlY3RvciB5b3Ug
YXJlIG9ubHkNCj4gPiA+ID4gPiBhbGxvd2VkDQo+ID4gPiA+ID4gb25lDQo+ID4gPiA+ID4gbWFz
ayBiZWNhdXNlIGl0IGRldGVybWluZXMgdGhlIGlucHV0cyB1c2VkIHRvIGdlbmVyYXRlIHRoZQ0K
PiA+ID4gPiA+IGhhc2gNCj4gPiA+ID4gPiB0aGF0DQo+ID4gPiA+ID4gaWRlbnRpZmllcyB0aGUg
Zmxvdy4gU28geW91IGFyZSBvbmx5IGFsbG93ZWQgb25lIG1hc2sgZm9yIGFsbA0KPiA+ID4gPiA+
IGZsb3dzDQo+ID4gPiA+ID4gYmVjYXVzZSBjaGFuZ2luZyB0aG9zZSBpbnB1dHMgd291bGQgYnJl
YWsgdGhlIGhhc2ggbWFwcGluZy4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBOb3JtYWxseSB0aGlz
IGVuZHMgdXAgbWVhbmluZyB0aGF0IHlvdSBoYXZlIHRvIGRvIGxpa2Ugd2hhdA0KPiA+ID4gPiA+
IHdlDQo+ID4gPiA+ID4gZGlkIGluDQo+ID4gPiA+ID4gaXhnYmUgYW5kIGRpc2FibGUgQVRSIGFu
ZCBvbmx5IGFsbG93IG9uZSBtYXNrIGZvciBhbGwgaW5wdXRzLg0KPiA+ID4gPiA+IEkNCj4gPiA+
ID4gPiBiZWxpZXZlIGZvciBpNDBlIHRoZXkgcmVxdWlyZWQgdGhhdCB5b3UgYWx3YXlzIHVzZSBh
IGZ1bGwgNA0KPiA+ID4gPiA+IHR1cGxlLiBJDQo+ID4gPiA+ID4gZGlkbid0IHNlZSBzb21ldGhp
bmcgbGlrZSB0aGF0IGhlcmUuIEFzIHN1Y2ggeW91IG1heSB3YW50IHRvDQo+ID4gPiA+ID4gZG91
YmxlDQo+ID4gPiA+ID4gY2hlY2sgdGhhdCB5b3UgY2FuIGhhdmUgYSBtaXggb2YgZmxvdyBkaXJl
Y3RvciBydWxlcyB0aGF0IGFyZQ0KPiA+ID4gPiA+IHVzaW5nIDENCj4gPiA+ID4gPiB0dXBsZSwg
MiB0dXBsZXMsIDMgdHVwbGVzLCBhbmQgNCB0dXBsZXMgYXMgbGFzdCBJIGtuZXcgeW91DQo+ID4g
PiA+ID4gY291bGRuJ3QuDQo+ID4gPiA+ID4gQmFzaWNhbGx5IGlmIHlvdSBoYWQgZmllbGRzIGlu
Y2x1ZGVkIHRoZXkgaGFkIHRvIGJlIGluY2x1ZGVkDQo+ID4gPiA+ID4gZm9yDQo+ID4gPiA+ID4g
YWxsDQo+ID4gPiA+ID4gdGhlIHJ1bGVzIG9uIHRoZSBwb3J0IG9yIGRldmljZSBkZXBlbmRpbmcg
b24gaG93IHRoZSB0YWJsZXMNCj4gPiA+ID4gPiBhcmUNCj4gPiA+ID4gPiBzZXQNCj4gPiA+ID4g
PiB1cC4NCj4gPiA+ID4gDQo+ID4gPiA+IFRoZSBpY2UgZHJpdmVyIGhhcmR3YXJlIGlzIHF1aXRl
IGEgYml0IG1vcmUgY2FwYWJsZSB0aGFuIHRoZQ0KPiA+ID4gPiBpeGdiZQ0KPiA+ID4gPiBvcg0K
PiA+ID4gPiBpNDBlIGhhcmR3YXJlLCBhbmQgdXNlcyBhIGxpbWl0ZWQgc2V0IG9mIEFDTCBydWxl
cyB0byBzdXBwb3J0DQo+ID4gPiA+IGRpZmZlcmVudA0KPiA+ID4gPiBzZXRzIG9mIG1hc2tzLiBX
ZSBoYXZlIHNvbWUgbGltaXRzIG9uIHRoZSBudW1iZXIgb2YgbWFza3MgYW5kDQo+ID4gPiA+IHRo
ZQ0KPiA+ID4gPiBudW1iZXIgb2YgZmllbGRzIHRoYXQgd2UgY2FuIHNpbXVsdGFuZW91c2x5IHN1
cHBvcnQsIGJ1dCBJDQo+ID4gPiA+IHRoaW5rDQo+ID4gPiA+IHRoYXQgaXMgcHJldHR5IG5vcm1h
bCBmb3IgbGltaXRlZCBoYXJkd2FyZSByZXNvdXJjZXMuDQo+ID4gPiA+IA0KPiA+ID4gPiBMZXQn
cyBqdXN0IHNheSB0aGF0IGlmIHRoZSBjb2RlIGRvZXNuJ3Qgd29yayBvbiBhbiBFODEwIGNhcmQN
Cj4gPiA+ID4gdGhlbg0KPiA+ID4gPiB3ZQ0KPiA+ID4gPiBtZXNzZWQgdXAgYW5kIHdlJ2xsIGhh
dmUgdG8gZml4IGl0LiA6LSkNCj4gPiA+ID4gDQo+ID4gPiA+IFRoYW5rcyBmb3IgdGhlIHJldmll
dyEgSG9wZSB0aGlzIGhlbHBzLi4uDQo+ID4gPiANCj4gPiA+IEkgZ2F0aGVyIGFsbCB0aGF0LiBU
aGUgaXNzdWUgd2FzIHRoZSBjb2RlIGluIGljZV9pc19hY2xfZmlsdGVyKCkuDQo+ID4gPiBCYXNp
Y2FsbHkgaWYgd2Ugc3RhcnQgZHJvcHBpbmcgZmllbGRzIGl0IHdpbGwgbm90IHRyaWdnZXIgdGhl
DQo+ID4gPiBydWxlIHRvDQo+ID4gPiBiZSBjb25zaWRlcmVkIGFuIEFDTCBydWxlIGlmIHRoZSBm
aWVsZCBpcyBjb21wbGV0ZWx5IGRyb3BwZWQuDQo+ID4gPiANCj4gPiA+IFNvIGZvciBleGFtcGxl
IEkgY291bGQgZGVmaW5lIDQgcnVsZXMsIG9uZSB0aGF0IGlnbm9yZXMgdGhlIElQdjQNCj4gPiA+
IHNvdXJjZSwgb25lIHRoYXQgaWdub3JlcyB0aGUgSVB2NCBkZXN0aW5hdGlvbiwgb25lIHRoYXQg
aWdub3Jlcw0KPiA+ID4gdGhlDQo+ID4gPiBUQ1Agc291cmNlIHBvcnQsIGFuZCBvbmUgdGhhdCBp
Z25vcmVzIHRoZSBUQ1AgZGVzdGluYXRpb24gcG9ydC4NCj4gPiANCj4gPiBXZSBoYXZlIHRoZSBs
aW1pdGF0aW9uIHRoYXQgeW91IGNhbiB1c2Ugb25lIGlucHV0IHNldCBhdCBhIHRpbWUgc28NCj4g
PiBhbnkNCj4gPiBvZiB0aGVzZSBydWxlcyBjb3VsZCBiZSBjcmVhdGVkIGJ1dCB0aGV5IGNvdWxk
bid0IGV4aXN0DQo+ID4gY29uY3VycmVudGx5Lg0KPiANCj4gTm8sIEkgZ2V0IHRoYXQuIFRoZSBx
dWVzdGlvbiBJIGhhdmUgaXMgd2hhdCBoYXBwZW5zIGlmIHlvdSB0cnkgdG8NCj4gaW5wdXQgYSBz
ZWNvbmQgaW5wdXQgc2V0LiBXaXRoIGl4Z2JlIHdlIHRyaWdnZXJlZCBhbiBlcnJvciBmb3IgdHJ5
aW5nDQo+IHRvIGNoYW5nZSBpbnB1dCBzZXRzLiBJJ20gd29uZGVyaW5nIGlmIHlvdSB0cmlnZ2Vy
IGFuIGVycm9yIG9uIGFkZGluZw0KPiBhIGRpZmZlcmVudCBpbnB1dCBzZXQgb3IgaWYgeW91IGp1
c3QgaW52YWxpZGF0ZSB0aGUgZXhpc3RpbmcgcnVsZXMuDQo+IA0KPiA+ID4gV2l0aA0KPiA+ID4g
dGhlIGN1cnJlbnQgY29kZSBhbGwgNCBvZiB0aG9zZSBydWxlcyB3b3VsZCBiZSBjb25zaWRlcmVk
IHRvIGJlDQo+ID4gPiBub24tQUNMIHJ1bGVzIGJlY2F1c2UgdGhlIG1hc2sgaXMgMCBhbmQgbm90
IHBhcnRpYWwuDQo+ID4gDQo+ID4gQ29ycmVjdC4gSSBkaWQgdGhpcyB0byB0ZXN0IEZsb3cgRGly
ZWN0b3I6DQo+ID4gDQo+ID4gJ2V0aHRvb2wgLU4gZW5zODAxZjAgZmxvdy10eXBlIHRjcDQgc3Jj
LWlwIDE5Mi4xNjguMC4xMCBkc3QtaXANCj4gPiAxOTIuMTY4LjAuMjAgc3JjLXBvcnQgODUwMCBh
Y3Rpb24gMTAnIGFuZCBzZW50IHRyYWZmaWMgbWF0Y2hpbmcNCj4gPiB0aGlzLg0KPiA+IFRyYWZm
aWMgY29ycmVjdGx5IHdlbnQgdG8gcXVldWUgMTAuDQo+IA0KPiBTbyBhIGJldHRlciBxdWVzdGlv
biBoZXJlIGlzIHdoYXQgaGFwcGVucyBpZiB5b3UgZG8gYSBydWxlIHdpdGgNCj4gc3JjLXBvcnQg
ODUwMCwgYW5kIGEgc2Vjb25kIHJ1bGUgd2l0aCBkc3QtcG9ydCA4NTAwPyBEb2VzIHRoZSBzZWNv
bmQNCj4gcnVsZSBmYWlsIG9yIGRvZXMgaXQgaW52YWxpZGF0ZSB0aGUgZmlyc3QuIElmIGl0IGlu
dmFsaWRhdGVzIHRoZQ0KPiBmaXJzdA0KPiB0aGVuIHRoYXQgd291bGQgYmUgYSBidWcuDQoNClRo
ZSBzZWNvbmQgcnVsZSBmYWlscyBhbmQgYSBtZXNzYWdlIGlzIG91dHB1dCB0byBkbWVzZy4NCg0K
ZXRodG9vbCAtTiBlbnM4MDFmMCBmbG93LXR5cGUgdGNwNCBzcmMtaXAgMTkyLjE2OC4wLjEwIGRz
dC1pcA0KMTkyLjE2OC4wLjIwIGRzdC1wb3J0IDg1MDAgYWN0aW9uIDEwDQpybWdyOiBDYW5ub3Qg
aW5zZXJ0IFJYIGNsYXNzIHJ1bGU6IE9wZXJhdGlvbiBub3Qgc3VwcG9ydGVkDQoNCmRtZXNnOg0K
aWNlIDAwMDA6ODE6MDAuMDogRmFpbGVkIHRvIGFkZCBmaWx0ZXIuICBGbG93IGRpcmVjdG9yIGZp
bHRlcnMgb24gZWFjaA0KcG9ydCBtdXN0IGhhdmUgdGhlIHNhbWUgaW5wdXQgc2V0Lg0KDQo+ID4g
PiBJZiBJIGRvIHRoZSBzYW1lDQo+ID4gPiB0aGluZyBhbmQgaWdub3JlIGFsbCBidXQgb25lIGJp
dCB0aGVuIHRoZXkgYXJlIGFsbCBBQ0wgcnVsZXMuDQo+ID4gDQo+ID4gQWxzbyBjb3JyZWN0LiBJ
IGRpZCBhcyBmb2xsb3dzOg0KPiA+IA0KPiA+ICdldGh0b29sIC1OIGVuczgwMWYwIGZsb3ctdHlw
ZSB0Y3A0IHNyYy1pcCAxOTIuMTY4LjAuMTAgZHN0LWlwDQo+ID4gMTkyLjE2OC4wLjIwIHNyYy1w
b3J0IDkwMDAgbSAweDEgYWN0aW9uIDE1Jw0KPiA+IA0KPiA+IFNlbmRpbmcgdHJhZmZpYyB0byBw
b3J0IDkwMDAgYW5kIDkwMDAxLCB0cmFmZmljIHdlbnQgdG8gcXVldWUgMTUNCj4gPiBTZW5kaW5n
IHRyYWZmaWMgdG8gcG9ydCA4MDAwIGFuZCA5MDAwMiwgdHJhZmZpYyB3ZW50IHRvIG90aGVyDQo+
ID4gcXVldWVzDQo+IA0KPiBUaGUgdGVzdCBoZXJlIGlzIHRvIHNldC11cCB0d28gcnVsZXMgYW5k
IHZlcmlmeSBlYWNoIG9mIHRoZW0gYW5kIG9uZQ0KPiBjYXNlIHRoYXQgZmFpbHMgYm90aC4gU2Ft
ZSB0aGluZyBmb3IgdGhlIHRlc3QgYWJvdmUuIEJhc2ljYWxseSB3ZQ0KPiBzaG91bGQgYmUgYWJs
ZSB0byBwcm9ncmFtIG11bHRpcGxlIEFDTCBydWxlcyB3aXRoIGRpZmZlcmVudCBtYXNrcyBhbmQN
Cj4gdGhhdCBzaG91bGRuJ3QgYmUgYW4gaXNzdWUgdXAgdG8gc29tZSBsaW1pdCBJIHdvdWxkIGlt
YWdpbmUuIFNhbWUNCj4gdGhpbmcgZm9yIGZsb3cgZGlyZWN0b3IgcnVsZXMuIEFmdGVyIHRoZSBm
aXJzdCB5b3Ugc2hvdWxkIG5vdCBiZSBhYmxlDQo+IHRvIHByb3ZpZGUgYSBmbG93IGRpcmVjdG9y
IHJ1bGUgd2l0aCBhIGRpZmZlcmVudCBpbnB1dCBtYXNrLg0KDQpJIGRpZCB0aGlzOg0KDQpldGh0
b29sIC1OIGVuczgwMWYwIGZsb3ctdHlwZSB0Y3A0IHNyYy1pcCAxOTIuMTY4LjAuMTAgZHN0LWlw
DQoxOTIuMTY4LjAuMjAgc3JjLXBvcnQgOTAwMCBtIDB4MSBhY3Rpb24gMTUNCmV0aHRvb2wgLU4g
ZW5zODAxZjAgZmxvdy10eXBlIHRjcDQgc3JjLWlwIDE5Mi4xNjguMC4xMCBkc3QtaXANCjE5Mi4x
NjguMC4yMCBzcmMtcG9ydCA4MDAwIG0gMHgyIGFjdGlvbiAyMA0KDQpTZW5kaW5nIHRyYWZmaWMg
dG8gcG9ydCA5MDAwIGFuZCA5MDAxIGdvZXMgdG8gcXVldWUgMTUNClNlbmRpbmcgdHJhZmZpYyB0
byBwb3J0IDgwMDAgYW5kIDgwMDIgZ29lcyB0byBxdWV1ZSAyMA0KU2VuZGluZyB0cmFmZmljIHRv
IHBvcnQgODAwMSBhbmQgODUwMCBnb2VzIHRvIG5laXRoZXIgb2YgdGhlIHF1ZXVlcw0KDQpUaGFu
a3MsDQpUb255DQoNCg==
