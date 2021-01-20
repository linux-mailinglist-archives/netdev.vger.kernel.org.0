Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292042FC575
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 01:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbhATANR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 19:13:17 -0500
Received: from mga14.intel.com ([192.55.52.115]:15154 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728420AbhATANK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 19:13:10 -0500
IronPort-SDR: amxob/6Bj99WgRWRh4k/F8OATEa3LyMc61XQtGpyFkd37VSrFeJnomWxnhu9ZQsVlxg4KJFcUx
 ZbcsPipfXwtA==
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="178239181"
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="178239181"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 16:12:28 -0800
IronPort-SDR: 8Qce7ofI5ZWfzHIJBykpCMQGG5PQCDQc9dihvM+Gk1Dm/La8GeTBmwXOyTpOzgIyqdS5DNHMnZ
 jdsUyOIUs2Cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="353962376"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 19 Jan 2021 16:12:28 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 19 Jan 2021 16:12:28 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 19 Jan 2021 16:12:28 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 19 Jan 2021 16:12:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONG+Cdbq+wDztMsvmymOPCfFQ0m2vbvqxvcofVE7nJN6cUyRIj7bawMLeD4lACbLLbtd3juQrlpz0T5pJIcSQI30RXY5JMWcxcxyNukqILN4R7eNrYuHBNshbRFz+A8mdAmSFTYxZmD6NBtubfzd4uhHjm/xmhVwesJswrbJht+F5v1BiC647z8dT7TqeY9KLHdygwyGec62AglSngRili6WhlEBE1HXYgDyHX1nlPWqxcuKjnQ7pyaS04lHaUMpviTFCqN5jPaW9ITHOOC7cj9DOaXL4wv0CfRtsJvzR52s05qqv6Sc6XMjOQRuwel53JbS+73kEXKMRLa/rvCBUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=re4EE3pn1Frt4aQ0k2unqqtbuUoH8eY+kNoK3zxDul4=;
 b=Rstir3fKjYr1RVIQCYenMYYbhBUTGSs/V0naUn7jvKB6RU6zSPpoUykd4EwSHuuUzTafyFc8NdsYb3od3w3kjpQaQaH3XKgZaDb67qEv8vhPvNZx+gt81u2mHbJ3NFfn53Z7qUJsGiM8qnebo7anGO0714nxPydK2VzwTE+sriDQyhbQZevn9aRLXIvCENUQ7hugrT0IgsE7KxFCfwKqSVuzP98Nozsr2IE91ZOdQ5izldZS0J/0RXU0RkJMrJbhB4g48F3hv7T4znyUgO0xOUX/z7kB8svw0lE6bhjZz6cr8t9+SgrfIKkQQ9pA+2spnFv9Ym2hfoR7vL5qLrrEpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=re4EE3pn1Frt4aQ0k2unqqtbuUoH8eY+kNoK3zxDul4=;
 b=bg80a33TEu1SXaFGNclqO/hrlPVeuFnd7dL+uZ2mZwzSYlPe6+hgDWNGvMXyb9N6KBumLziU4s9gq4rWl0d5sBimSDIZo0haMnC8fLr2EockTbnuLB9l/GqGKRqTtWBYQqTki54t9llR8xPGnYuhh/Z5DmC1t8NW4wbefn5QvQQ=
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by MWHPR1101MB2255.namprd11.prod.outlook.com (2603:10b6:301:5b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Wed, 20 Jan
 2021 00:12:26 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::851c:df49:9853:26af]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::851c:df49:9853:26af%8]) with mapi id 15.20.3763.014; Wed, 20 Jan 2021
 00:12:26 +0000
From:   "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "Brelinski, TonyX" <tonyx.brelinski@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Creeley, Brett" <brett.creeley@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] ice: Improve MSI-X vector enablement
 fallback logic
Thread-Topic: [PATCH net-next 1/1] ice: Improve MSI-X vector enablement
 fallback logic
Thread-Index: AQHW6hko29AaKvr6HE2iTtaOFm6DP6on2oMAgAfQUoA=
Date:   Wed, 20 Jan 2021 00:12:26 +0000
Message-ID: <7272d1b6e6c447989cae07e7519422ab80518ca1.camel@intel.com>
References: <20210113234226.3638426-1-anthony.l.nguyen@intel.com>
         <20210114164252.74c1cf18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114164252.74c1cf18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.139.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a5b1e34-e42b-4f5a-7283-08d8bcd811be
x-ms-traffictypediagnostic: MWHPR1101MB2255:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2255D40661AC925916C416AE90A20@MWHPR1101MB2255.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VecjnEqVlkZK9iJPFFovrI+gvRgSIZsJIy5nBt2jlXFVuO/i7V+pzxIE9wovOMxwIjNO0GyGzLZ9EZHQ4ROfSHoHOnFe8rpUuV75ZD1wwCoCJ72PH3nG+8GvfbrlltrvjKXpZ+Z+r2pR3w8BCL0lBloEelM7GjNABpcwCqd+2UWE5069SksRt3nmoMEg2LSrDsqNWepmYMuWiWV5WmivAAix1YWYsyGTavkWLqMMdAhwxHA5IuUSw76byQ2o/uLjJyQkRAIsSnHTcKa1vCQxvkQTWe20hwOuJwaG2+Qe8eMpvIAfMVw8pyxawJvVKo6SgdMN7SDpiOn3XkbJCMnVKnmVvW04aT+0ZG16TmXq1UAgw9FRSqGfnEVxMqnnd6zDMg7ohcW7/2wdgmIrp0AQHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(6512007)(64756008)(2616005)(6486002)(66476007)(66556008)(26005)(66946007)(66446008)(316002)(54906003)(186003)(76116006)(8676002)(478600001)(2906002)(8936002)(110136005)(6506007)(4326008)(86362001)(71200400001)(6636002)(83380400001)(5660300002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MU45MkF2VlBpRXlWQTFwcDZDb1pEa2U0RHRMQUFBWjh6cjY0OVBrTFdHaDU5?=
 =?utf-8?B?UlIycHV6V2E3S3ZrMVZOcitZY2NKd1h1cjluK2xHaDVzOUptd1htTFJwNnor?=
 =?utf-8?B?OGhKNFRhWTlSZUJBOThtT1JFenNPa0lnb2xpZUlDWWdkMldEUW9vQVNRUnV5?=
 =?utf-8?B?aDNKam81aEJLWXFLMEVXOXB3RG1Kb3FzaVppY3JheHpxVUVheEtpWkJ3b0Nw?=
 =?utf-8?B?cFp2dS9yanJFK2x0OWdzK1hRY2E4eVpFcFBvNi95bEdTOFphYTJpczl0ZnlN?=
 =?utf-8?B?MFFTZkhGRHR0SG4vODB1U1Zia0lENWk5OXgzSHlFNnV3WHlKMGp3UGRqdDRq?=
 =?utf-8?B?Y3ZDTmJjMUh3NjhWaTk4Mk01L09UaWE4Y0pZeFBRMTRIamNIOWxGeXhXZDNF?=
 =?utf-8?B?TGQ5Y3ZaYVZoRWhJZHRKSFZDZDd5TFc2b25MY3FXaFlYaG16Z0RSY2s1UmJt?=
 =?utf-8?B?bytTYU51ZFBrQmdha1JNTEZBaHBudWhCOUUreFMyOElXL1Y3OXkwRUJtd0ZG?=
 =?utf-8?B?d2pJTlhSaVgvSEdVanh4NHdKT3JXWHhTeGhoTm0yMmVoM1dWVHVGQWp2K2Vi?=
 =?utf-8?B?Vm14SUhDcHRHRnRhZHJ6ZFdrdWdjbFFVcjBIdXVoNS9sSlpTMWovNFQ0cTVI?=
 =?utf-8?B?dU9CY3FyWThMY2tnblJKeENFbTU5d21oTUt2cm1wdWZlT2RXcUhkcVJkNGtF?=
 =?utf-8?B?UzloNDRTYzRGN1pzY1BKZjRHSFJOM1l5SVFQSjJoeDVLQWZHVnR4cmVWMFJF?=
 =?utf-8?B?MFhqSERFTktDS0lKcGh3Mnptd0hCSHpWcWI1ZHRQa0s0dGdJTjB2SVF3Nk1h?=
 =?utf-8?B?eVZmUng0SFRVRlRSY2ZXaERxbmZUNnFGZy9EMys5VGVYWUwxaHBDS3NPSStu?=
 =?utf-8?B?anFuL0IrbmFRRVFaYXhmb09RR09CaUFPc2dZV0prNE1UYW5MdHp2UjkrckxI?=
 =?utf-8?B?d25aU05rNmZkRjhNRFJVUkE3TTMxSmF0WGFPUVJKcDY4ZDJSSlZJY2hYWS84?=
 =?utf-8?B?ZmIySVRkTjg4SmVvRmg2d2pTRi9Rb0hLeW1OTHY5Ti9GcjNqWVFiSXVIM1hN?=
 =?utf-8?B?VGd2YWZ5WTVVWE8yNTh6N092amxmT1pENCtkWjUvaU9sdTJMOGwrTjE2eUVt?=
 =?utf-8?B?UHVXN1JSWGh2cmtxU0hOYjZjRmxsY1RRakgrQ0pzd1FqWEpoTStiYjdMcTN0?=
 =?utf-8?B?dWh6MnBMdHE3aFFudzN0WjFzcWo1WUV5aWJLOTJ6UmxKbGxBcW1iRHpMWUNU?=
 =?utf-8?B?ckVKZHJ5a0FLZUhleHZiaVI1N2pEMW9weFplT2pUZDQ2QzVxZ1hKSlhCNzJD?=
 =?utf-8?Q?1Jj1JRsDKZ89tZlsuXtq8G2HCzTqLhlh/0?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E063C6296566B44835101E6A3F372AB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a5b1e34-e42b-4f5a-7283-08d8bcd811be
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2021 00:12:26.8192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JlDSsxmiKjOsuC/etiakAzKYxfqufh0Uc8IkoXSAButwQdmmlPi0GyYMDCbw7TacXEFNAuXgY+PfsZoqQ6bv3LO1WDY/0bjpqXvED1SoDzdSk+t2QunCaaEOT5iubO2v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2255
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTAxLTE0IGF0IDE2OjQyIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAxMyBKYW4gMjAyMSAxNTo0MjoyNiAtMDgwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiBGcm9tOiBCcmV0dCBDcmVlbGV5IDxicmV0dC5jcmVlbGV5QGludGVsLmNvbT4NCj4gPiAN
Cj4gPiBUaGUgY3VycmVudCBNU0ktWCBlbmFibGVtZW50IGxvZ2ljIGVpdGhlciB0cmllcyB0byBl
bmFibGUgYmVzdC1jYXNlDQo+ID4gTVNJLVggdmVjdG9ycyBhbmQgaWYgdGhhdCBmYWlscyB3ZSBv
bmx5IHN1cHBvcnQgYSBiYXJlLW1pbmltdW0gc2V0Lg0KPiA+IFRoaXMgaXMgbm90IHZlcnkgZmxl
eGlibGUgYW5kIHRoZSBjdXJyZW50IGxvZ2ljIGlzIGJyb2tlbiB3aGVuDQo+ID4gYWN0dWFsbHkN
Cj4gPiBhbGxvY2F0aW5nIGFuZCByZXNlcnZpbmcgTVNJLVggaW4gdGhlIGRyaXZlci4gRml4IHRo
aXMgYnkgaW1wcm92aW5nDQo+ID4gdGhlDQo+ID4gZmFsbC1iYWNrIGxvZ2ljIGFuZCBmaXhpbmcg
dGhlIGFsbG9jYXRpb24vcmVzZXJ2YXRpb24gb2YgTVNJLVggd2hlbg0KPiA+IHRoZQ0KPiA+IGJl
c3QtY2FzZSBNU0ktWCB2ZWN0b3JzIGFyZSBub3QgcmVjZWl2ZWQgZnJvbSB0aGUgT1MuDQo+ID4g
DQo+ID4gVGhlIG5ldyBmYWxsLWJhY2sgbG9naWMgaXMgZGVzY3JpYmVkIGJlbG93IHdpdGggZWFj
aCBbI10gYmVpbmcgYW4NCj4gPiBhdHRlbXB0IGF0IGVuYWJsaW5nIGEgY2VydGFpbiBudW1iZXIg
b2YgTVNJLVguIElmIGFueSBvZiB0aGUgc3RlcHMNCj4gPiBzdWNjZWVkLCB0aGVuIHJldHVybiB0
aGUgbnVtYmVyIG9mIE1TSS1YIGVuYWJsZWQgZnJvbQ0KPiA+IGljZV9lbmFfbXNpeF9yYW5nZSgp
LiBJZiBhbnkgb2YgdGhlIGF0dGVtcHRzIGZhaWwsIHRoZW4gZ290byB0aGUNCj4gPiBuZXh0DQo+
ID4gc3RlcC4NCj4gPiANCj4gPiBBdHRlbXB0IFswXTogRW5hYmxlIHRoZSBiZXN0LWNhc2Ugc2Nl
bmFyaW8gTVNJLVggdmVjdG9ycy4NCj4gPiANCj4gPiBBdHRlbXB0IFsxXTogRW5hYmxlIE1TSS1Y
IHZlY3RvcnMgd2l0aCB0aGUgbnVtYmVyIG9mIHBmLQ0KPiA+ID5udW1fbGFuX21zaXgNCj4gPiBy
ZWR1Y2VkIGJ5IGEgZmFjdG9yIG9mIDIgZnJvbSB0aGUgcHJldmlvdXMgYXR0ZW1wdCAoaS5lLg0K
PiA+IG51bV9vbmxpbmVfY3B1cygpIC8gMikuDQo+ID4gDQo+ID4gQXR0ZW1wdCBbMl06IFNhbWUg
YXMgYXR0ZW1wdCBbMV0sIGV4Y2VwdCByZWR1Y2UgYnkgYSBmYWN0b3Igb2YgNC4NCj4gPiANCj4g
PiBBdHRlbXB0IFszXTogRW5hYmxlIHRoZSBiYXJlLW1pbmltdW0gTVNJLVggdmVjdG9ycy4NCj4g
PiANCj4gPiBBbHNvLCBpZiB0aGUgYWRqdXN0ZWRfYmFzZV9tc2l4IGV2ZXIgaGl0cyB0aGUgbWlu
aW11bSByZXF1aXJlZCBmb3INCj4gPiBMQU4sDQo+ID4gdGhlbiBqdXN0IHNldCB0aGUgbmVlZGVk
IE1TSS1YIGZvciB0aGF0IGZlYXR1cmUgdG8gdGhlIG1pbmltdW0NCj4gPiAoc2ltaWxhciB0byBh
dHRlbXB0IFszXSkuDQo+IA0KPiBJIGRvbid0IHJlYWxseSBnZXQgd2h5IHlvdSBzd2l0Y2ggdG8g
dGhpcyBtYW51YWwgImV4cG9uZW50aWFsIGJhY2stDQo+IG9mZiINCj4gcmF0aGVyIHRoYW4gY29u
dGludWluZyB0byB1c2UgcGNpX2VuYWJsZV9tc2l4X3JhbmdlKCksIGJ1dCBmaXhpbmcgdGhlDQo+
IGNhcHBpbmcgdG8gSUNFX01JTl9MQU5fVkVDUy4NCg0KQXMgcGVyIHRoZSBjdXJyZW50IGxvZ2lj
LCBpZiB0aGUgZHJpdmVyIGRvZXMgbm90IGdldCB0aGUgbnVtYmVyIG9mIE1TSS0NClggdmVjdG9y
cyBpdCBuZWVkcywgaXQgd2lsbCBpbW1lZGlhdGVseSBkcm9wIHRvICJEbyBJIGhhdmUgYXQgbGVh
c3QgdHdvDQooSUNFX01JTl9MQU5fVkVDUykgTVNJLVggdmVjdG9ycz8iLiBJZiB5ZXMsIHRoZSBk
cml2ZXIgd2lsbCBlbmFibGUgYQ0Kc2luZ2xlIFR4L1J4IHRyYWZmaWMgcXVldWUgcGFpciwgYm91
bmQgdG8gb25lIG9mIHRoZSB0d28gTVNJLVggdmVjdG9ycy4NCg0KVGhpcyBpcyBhIGJpdCBvZiBh
biBhbGwtb3Itbm90aGluZyB0eXBlIGFwcHJvYWNoLiBUaGVyZSdzIGEgbWlkLWdyb3VuZA0KdGhh
dCBjYW4gYWxsb3cgbW9yZSBxdWV1ZXMgdG8gYmUgZW5hYmxlZCAoZXguIGRyaXZlciBhc2tlZCBm
b3IgMzAwDQp2ZWN0b3JzLCBidXQgZ290IDY4IHZlY3RvcnMsIHNvIGVuYWJsZWQgNjQgZGF0YSBx
dWV1ZXMpIGFuZCB0aGlzIHBhdGNoDQppbXBsZW1lbnRzIHRoZSBtaWQtZ3JvdW5kIGxvZ2ljLiAN
Cg0KVGhpcyBtaWQtZ3JvdW5kIGxvZ2ljIGNhbiBhbHNvIGJlIGltcGxlbWVudGVkIGJhc2VkIG9u
IHRoZSByZXR1cm4gdmFsdWUNCm9mIHBjaV9lbmFibGVfbXNpeF9yYW5nZSgpIGJ1dCBJTUhPIHRo
ZSBpbXBsZW1lbnRhdGlvbiBpbiB0aGlzIHBhdGNoDQp1c2luZyBwY2lfZW5hYmxlX21zaXhfZXhh
Y3QgaXMgYmV0dGVyIGJlY2F1c2UgaXQncyBhbHdheXMgb25seQ0KZW5hYmxpbmcvcmVzZXJ2aW5n
IGFzIG1hbnkgTVNJLVggdmVjdG9ycyBhcyByZXF1aXJlZCwgbm90IG1vcmUsIG5vdA0KbGVzcy4N
Cg0KPiANCj4gPiBUbyBmaXggdGhlIGFsbG9jYXRpb24vcmVzZXJ2YXRpb24gb2YgTVNJLVgsIHRo
ZSBQRiBWU0kgbmVlZHMgdG8NCj4gPiB0YWtlDQo+ID4gaW50byBhY2NvdW50IHRoZSBwZi0+bnVt
X2xhbl9tc2l4IGF2YWlsYWJsZSBhbmQgb25seSBhbGxvY2F0ZSB1cCB0bw0KPiA+IHRoYXQNCj4g
PiBtYW55IE1TSS1YIHZlY3RvcnMuIFRvIGRvIHRoaXMsIGxpbWl0IHRoZSBudW1iZXIgb2YgVHgg
YW5kIFJ4DQo+ID4gcXVldWVzDQo+ID4gYmFzZWQgb24gcGYtPm51bV9sYW5fbXNpeC4gVGhpcyBp
cyBkb25lIGJlY2F1c2Ugd2UgZG9uJ3Qgd2FudCBtb3JlDQo+ID4gdGhhbg0KPiA+IDEgVHgvUngg
cXVldWUgcGVyIGludGVycnVwdCBkdWUgdG8gcGVyZm9ybWFuY2UgY29uY2VybnMuIEFsc28sDQo+
ID4gbGltaXQgdGhlDQo+ID4gbnVtYmVyIG9mIE1TSS1YIGJhc2VkIG9uIHBmLT5udW1fbGFuX21z
aXggYXZhaWxhYmxlLg0KPiA+IA0KPiA+IEFsc28sIHByZXZlbnQgdXNlcnMgZnJvbSBlbmFibGlu
ZyBtb3JlIGNvbWJpbmVkIHF1ZXVlcyB0aGFuIHRoZXJlDQo+ID4gYXJlDQo+ID4gTVNJLVggYXZh
aWxhYmxlIHZpYSBldGh0b29sLg0KPiANCj4gUmlnaHQsIHRoaXMgcGFydCBzb3VuZHMgbGlrZSBh
IGZpeCwgYW5kIHNob3VsZCBiZSBhIHNlcGFyYXRlIHBhdGNoDQo+IGFnYWluc3QgbmV0LCBub3Qg
bmV0LW5leHQuDQoNCkFDSy4gV2Ugd2lsbCBkbyBhIGRpZmZlcmVudCBwYXRjaCBmb3IgdGhpcy4N
Cg0KPiANCj4gPiBGaXhlczogMTUyYjk3OGExZjkwICgiaWNlOiBSZXdvcmsgaWNlX2VuYV9tc2l4
X3JhbmdlIikNCj4gPiBTaWduZWQtb2ZmLWJ5OiBCcmV0dCBDcmVlbGV5IDxicmV0dC5jcmVlbGV5
QGludGVsLmNvbT4NCj4gPiBUZXN0ZWQtYnk6IFRvbnkgQnJlbGluc2tpIDx0b255eC5icmVsaW5z
a2lAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFRvbnkgTmd1eWVuIDxhbnRob255Lmwu
bmd1eWVuQGludGVsLmNvbT4NCg==
