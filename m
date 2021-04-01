Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851F4352093
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 22:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbhDAU0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 16:26:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:6584 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234201AbhDAU0o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 16:26:44 -0400
IronPort-SDR: r2zTlgAGsxShXPccYmx/pM6zFyQQ9fmhrm2YiNbFbe+YH3ZXzvMeSSg1N7z/o3GQfOB/OHXfb0
 N7n0IFK5WQWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="191805775"
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="191805775"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 13:26:45 -0700
IronPort-SDR: Mcc8jAvol86sRRxbSP2kKcbQ0P1us3ttWKJjGH9ReAwH9wI9/IL/lk3lDqvpyH1leqEe+WC6CU
 FL3No42dHx+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="412860059"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga008.fm.intel.com with ESMTP; 01 Apr 2021 13:26:45 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 1 Apr 2021 13:26:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 1 Apr 2021 13:26:44 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 1 Apr 2021 13:26:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSrhRaRxSgVKtxf6FPkmq3dzr76jjArdVcv01jtBSWBoGOticcrIqII4KDGFNQr5+DZk0IyboMvRem6Y7MyOztzrTxV+77jaShXU7pWVnRdw1gmeAdCMTay4Z8kLgy9oOH0PfNEW2YssbBR7Z7oXoSfG/ZVmTGe4+jyb/mPDGKXWhN7I5BUEZIs9WjJzFoVXjRVxLE6pT7hIwYE1wK2QaFzNTqlu+i2HCrUnibNc80pq03Hp681tE/MtnT1K37kHFDY36QVG7qrvJPaAtjegzX10A524u8UxZv35qdSjWHExO5ZjhPYBxT2f6kZpwbxBBNVdUzChzHupK/JMDpHYTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FHeBaEKpRSuDWEqkwoEV8Gnd58+saDfEYzeLpAQX2Gw=;
 b=RSViNsqZbwtcn/yf4/RUGY5TxTP374pDCREgdyzSKx3IIzAL6ndsdXhzQWuf4DHb9XA8yEbiaF7ZMRwxWAFqoiWgIicBxj758/csXnKShqe5uixEIaUyKxpyr2UpwIIaVqVsuZQTbonFDybgsEmsOPgXxzxLQiwqFilkc/LYN1eFLDnSjcq+SpJNJi+WT8Kq4ILI9uI+e8/JC1nW5KCA55saFzJglL1CTohtpxdiNhqVzU6byBYABYausUOJ3OVQau/b88H1Ka8MLAigqkHxKqia93jx3qEmHHoAcwBVrf49I905elwfVyIIjTdVLTpev1208h+sQjhGr9R1r1xeew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FHeBaEKpRSuDWEqkwoEV8Gnd58+saDfEYzeLpAQX2Gw=;
 b=S6MxCb8iegbSqnkuv95iPqLfdJ9cj6f9rmBvK+aG8kQWtj/ChIZBgMESLQ2xzxDeKsBrAkrBkxT8s1paJ77f1y4Kpkzv7i/EjCRHYSTpHALCcOvkWbb9T7wSXteCjokBjtytH0QtjxcEhxX04SqplF1f277J0OdwPUPRPScPv1c=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB2927.namprd11.prod.outlook.com (2603:10b6:805:cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.32; Thu, 1 Apr
 2021 20:26:42 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::85b7:921c:ff53:696e]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::85b7:921c:ff53:696e%6]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 20:26:42 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Yongxin.Liu@windriver.com" <Yongxin.Liu@windriver.com>,
        "andrewx.bowers@intel.com" <andrewx.bowers@intel.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "Creeley, Brett" <brett.creeley@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH V2 net] ice: fix memory leak of aRFS after resuming from
 suspend
Thread-Topic: [PATCH V2 net] ice: fix memory leak of aRFS after resuming from
 suspend
Thread-Index: AQHXHItNzep6dM+QaEKDLxJvVxGD5KqdcgEAgAK/joA=
Date:   Thu, 1 Apr 2021 20:26:42 +0000
Message-ID: <c30428155948b44cf08aa438db8bebff67730207.camel@intel.com>
References: <20210319064038.15315-1-yongxin.liu@windriver.com>
         <PH0PR11MB5175BAF6F45C7F862CD0A33DE57C9@PH0PR11MB5175.namprd11.prod.outlook.com>
In-Reply-To: <PH0PR11MB5175BAF6F45C7F862CD0A33DE57C9@PH0PR11MB5175.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e48ebb14-188c-429e-ef66-08d8f54c7697
x-ms-traffictypediagnostic: SN6PR11MB2927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2927AE5A056BCC290E0B5D6FC67B9@SN6PR11MB2927.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vXv8nv7631qowZ099YpEiC56Rb7yEM7GPkPi85F2GqtyeLyfYtFDSIGVWiUksSb0E0AZmJ7cHQglwzcaDtJ8kIME727CWWFt2ylC57sCHRYm29y1zrMlo1SOnTjUUUq4mBHp0wM/U43iQ7A4mHgJQp1/jkkCMAgs3xdcLC+8GTPDu0J+mXsI3tvCVLbzH4y3Io1X6dMTblTxGwB3CNn3SPkDQj8pE8qKaSyzjKiDmcr85OJJwn/Ra5/8rERp62edbTt0k/cSQX9Z/tLSDQBjjGnDHhSljAow0ibWsH1rBp8BE+mArj8dRBz0FhzuYyInatlnMunm7lOn1m9eq8FNFE/NVG+SqTrhlDTGpGXTZHP4BLH3SGMJbzKvw3BYaOd6eA5mBQ7RbqBOVhyvtnB+tnSAE5fGrxDm7qWvI+20Q3xRapwaYsTTAkAralnkDy8UTkWb3pZfd/lehTcWs3HJCc263UjEYBiTrPvEGC1Q+SA6kkRUMy+NzKyld9VSJSaOinlziVC+9AJyZthYL+t8nDfUqdgRIuFn4+WA4lrM43CWLQEBHAoE9EEezbHKbKhj3dnZlmv6jehZTSpcxiiCTCWgFCHh7ncqWcSEa4gKfoDTroK1s+qZB5ZVNhK3qDO++EGzjEF1Osn1eUHNWJQGhQzyf9xoaW7uIa4yBRzmxrA1ddpX+LfVMU5H0m6AIBqJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(136003)(39860400002)(396003)(8936002)(186003)(8676002)(2616005)(66556008)(6636002)(26005)(478600001)(53546011)(36756003)(110136005)(6506007)(71200400001)(64756008)(316002)(2906002)(66446008)(86362001)(76116006)(6512007)(54906003)(6486002)(5660300002)(15650500001)(4326008)(38100700001)(83380400001)(91956017)(66476007)(66946007)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?U2RFakJQSXdzNm1XeVBzeWdLYjE2Q1FJc1Z6bDhwb0RLUzRHVWgxWWRITzh1?=
 =?utf-8?B?VWlkcDUwd0kyZ3pOSk1Da2hmWFpwVDlQbmlLT3hyWE9EQzNzdGVFM0FmbG5k?=
 =?utf-8?B?TlRvb2swUkNQbTNubzh5dmdiRmFvTFhWSUJNQTFDOTR0Mkh4bDUzcmo3bnBJ?=
 =?utf-8?B?bi80bjI1OWVIdXRJVjFQZmZBdFd2V2tVd2tqVE5mUDlraWVHeVpKZ3l5K1cr?=
 =?utf-8?B?Q1VTWGc4RFViZzhXWWx3bnFEc3dwU1Z0MmJneTM0c2lhb1RWRHJhNlc3UE53?=
 =?utf-8?B?YlM1MVcvaTVNMXhKV0hmVHpyUTdqYXRvVU51ai9ZOFN3V0ZGVXhMQTVBMk5a?=
 =?utf-8?B?UEVmb1RKeUVaRVBUUFFMOS9oL1ltZ1dNSTNmUUU3Tk0ybUlhVGFia0tSUFpN?=
 =?utf-8?B?ZzF5VnZLNGZkeEJFOUlFRUJWWW1uWHhXeXpJMjlobmlJSm1veUxwdG95b1R1?=
 =?utf-8?B?dVVnV2pOUjFIMFhDbTRhdDZkQXE0MVRjYm5hTmM3ZmdJK0c5QnVrdHdicG0v?=
 =?utf-8?B?ZUJyeFQrK0FCQ2Q0czcxaklZUUN1RlpGK2FISUdIaFl4MFhJZmV3Y0NuaXB2?=
 =?utf-8?B?ZzRrVnRkQlF0WTcwcWRFVkRTdFFjcDdGRnR1OHpLWEMyQ2MrMUYzMlgvTTdL?=
 =?utf-8?B?ZVpWZWw3Y21DWmdzVlJmKzNxdEFIY0lSQXY2dzhEeFE3NEd0OUQzTEQ1eDlx?=
 =?utf-8?B?KzZaL1MrVDJ6c0tKWVpNMm1PQWtTWmpYMXJwMkNRcWdTZThVblI3M2NLeDJn?=
 =?utf-8?B?TkI0NHpjRlVoWENBbTQ4a21YcVN5cmIyZEZkbThIQytDNHgwMDJocGk0Mjdi?=
 =?utf-8?B?bG45bFhpU0p0bGJSYUFpZnBKNXQ2Z2lrZlRrSlNNallzak1uTVhHblYxTWtT?=
 =?utf-8?B?WW5iZnZ6MTZkUjJ5VndtNlpTREMyVGJmV2tEREFWaUF2VCtXV0ZkUXBjdjNU?=
 =?utf-8?B?N25KUFplVEJPRXo1dzVGdGFxOGp0Z3RWVGhMMXJ2c2FQNzlQbzJzODRRbkta?=
 =?utf-8?B?UGlRMVNudzZ6eXYwUE9na3ZGVE9FWmhrcDFFQU5UNDJXTWV5OThmSHhXcHA1?=
 =?utf-8?B?Sy90Z3NuSm91Wm5wOXhqSW5PWE5GQW8vTHdveUthKzZXK2lxOGdQZHIreVhy?=
 =?utf-8?B?bXZtNkRidC9TNld5ZndmNkxuRVVZclYza256OFBkeW54SWU4RDl3dWorTDAz?=
 =?utf-8?B?a0ZoRkdpWkozNmFTeFE3YmhaRDZEV0dsdENLaFM1Lys3bmxCUnBkRXk4ejAy?=
 =?utf-8?B?OXRwMzBKSlVTZUc0eDJIKzJxam0zQkE2L2JjMTRqOUFNVHBaTnpRcGh5ZlJn?=
 =?utf-8?B?dE0xVEw5dnBodmVyditXelNNYVBpc3BFU3BZcFR1dTZGeUZoc2ZZN0ZPdHNB?=
 =?utf-8?B?UGk1YUJCS3lnMmlRMVhvVFdUdGVoU3doRjdtYjlKWnRrWmlBYVNNYXdRQlVn?=
 =?utf-8?B?Z2JQakhwc1BaYWMzVXRyak13ckZ0Wmdlei9iY1YxU3lmWEdBY3JJcStYTXJw?=
 =?utf-8?B?WDM0SzBlTDV5L1Uwelc0V1c1UGphK3VLSnpTazlUVzZQdjRhRnRKWGo5MGxs?=
 =?utf-8?B?SmlCWXJhQUpvYTU0S3ZwNnBaR3RRWVRkblk0UFFZbENGR0RTcit1bG5zaENY?=
 =?utf-8?B?YjFqZzA5NHZBT0VGVG9xaFVuQXdubU9sREpyenp6U0J4Zk1MV29MYVlLZzNY?=
 =?utf-8?B?YnBvMnZ2ZW5UekR6NEdJZ1Rycmx0d2l0c3VkZFRDanlSV3VCQmRSeGRueDhl?=
 =?utf-8?B?aVB3ZUkxeWplWlRwVkp6dFFDajlqaTM2cE05YlVzZlVPY1VVYVVNemFyd1lN?=
 =?utf-8?B?VDdPNjVZZytGU0l6MEJmZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A742E89368DDD8488BAA24AE0D73163F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e48ebb14-188c-429e-ef66-08d8f54c7697
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2021 20:26:42.7784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A87pjWVFM/Vvx1jq8UpYOkCGD504sMFxQNqMEUfD6mjda1t8esDO6BrDUwmK1XlMABozMttIq7ffnMtHswv7LxXfv6W/YSTYSJzkwi0m/Q0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2927
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTAzLTMxIGF0IDAyOjI4ICswMDAwLCBMaXUsIFlvbmd4aW4gd3JvdGU6DQo+
IEhlbGxvIEJyZXR0LA0KPiANCj4gQ291bGQgeW91IHBsZWFzZSBoZWxwIHRvIHJldmlldyB0aGlz
IFYyPw0KPiANCg0KSGkgWW9uZ3hpbiwNCg0KSSBoYXZlIHRoaXMgYXBwbGllZCB0byB0aGUgSW50
ZWwtd2lyZWQtbGFuIHRyZWUgdG8gZ28gdGhyb3VnaCBzb21lDQp0ZXN0aW5nLiBBbHNvLCBhZGRp
bmcgdGhlIEludGVsLXdpcmVkLWxhbiBsaXN0IGZvciByZXZpZXdzLg0KDQpUaGFua3MsDQpUb255
DQoNCj4gVGhhbmtzLA0KPiBZb25neGluDQo+IA0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0t
LS0tDQo+ID4gRnJvbTogTGl1LCBZb25neGluIDx5b25neGluLmxpdUB3aW5kcml2ZXIuY29tPg0K
PiA+IFNlbnQ6IEZyaWRheSwgTWFyY2ggMTksIDIwMjEgMTQ6NDQNCj4gPiBUbzogYnJldHQuY3Jl
ZWxleUBpbnRlbC5jb207IG1hZGh1LmNoaXR0aW1AaW50ZWwuY29tOw0KPiA+IGFudGhvbnkubC5u
Z3V5ZW5AaW50ZWwuY29tOyBhbmRyZXd4LmJvd2Vyc0BpbnRlbC5jb207DQo+ID4gamVmZnJleS50
LmtpcnNoZXJAaW50ZWwuY29tDQo+ID4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gPiBT
dWJqZWN0OiBbUEFUQ0ggVjIgbmV0XSBpY2U6IGZpeCBtZW1vcnkgbGVhayBvZiBhUkZTIGFmdGVy
IHJlc3VtaW5nDQo+ID4gZnJvbQ0KPiA+IHN1c3BlbmQNCj4gPiANCj4gPiBJbiBpY2Vfc3VzcGVu
ZCgpLCBpY2VfY2xlYXJfaW50ZXJydXB0X3NjaGVtZSgpIGlzIGNhbGxlZCwgYW5kIHRoZW4NCj4g
PiBpcnFfZnJlZV9kZXNjcygpIHdpbGwgYmUgZXZlbnR1YWxseSBjYWxsZWQgdG8gZnJlZSBpcnEg
YW5kIGl0cw0KPiA+IGRlc2NyaXB0b3IuDQo+ID4gDQo+ID4gSW4gaWNlX3Jlc3VtZSgpLCBpY2Vf
aW5pdF9pbnRlcnJ1cHRfc2NoZW1lKCkgaXMgY2FsbGVkIHRvIGFsbG9jYXRlDQo+ID4gbmV3DQo+
ID4gaXJxcy4NCj4gPiBIb3dldmVyLCBpbiBpY2VfcmVidWlsZF9hcmZzKCksIHN0cnVjdCBpcnFf
Z2x1ZSBhbmQgc3RydWN0IGNwdV9ybWFwDQo+ID4gbWF5YmUNCj4gPiBjYW5ub3QgYmUgZnJlZWQs
IGlmIHRoZSBpcnFzIHRoYXQgcmVsZWFzZWQgaW4gaWNlX3N1c3BlbmQoKSB3ZXJlDQo+ID4gcmVh
c3NpZ25lZCB0byBvdGhlciBkZXZpY2VzLCB3aGljaCBtYWtlcyBpcnEgZGVzY3JpcHRvcidzDQo+
ID4gYWZmaW5pdHlfbm90aWZ5DQo+ID4gbG9zdC4NCj4gPiANCj4gPiBTbyBjYWxsIGljZV9mcmVl
X2NwdV9yeF9ybWFwKCkgYmVmb3JlIGljZV9jbGVhcl9pbnRlcnJ1cHRfc2NoZW1lKCksDQo+ID4g
d2hpY2gNCj4gPiBjYW4gbWFrZSBzdXJlIGFsbCBpcnFfZ2x1ZSBhbmQgY3B1X3JtYXAgY2FuIGJl
IGNvcnJlY3RseSByZWxlYXNlZA0KPiA+IGJlZm9yZQ0KPiA+IGNvcnJlc3BvbmRpbmcgaXJxIGFu
ZCBkZXNjcmlwdG9yIGFyZSByZWxlYXNlZC4NCj4gPiANCj4gPiBGaXggdGhlIGZvbGxvd2luZyBt
ZW1vcnkgbGVhay4NCj4gPiANCj4gPiB1bnJlZmVyZW5jZWQgb2JqZWN0IDB4ZmZmZjk1YmQ5NTFh
ZmMwMCAoc2l6ZSA1MTIpOg0KPiA+ICAgY29tbSAia3dvcmtlci8wOjEiLCBwaWQgMTM0LCBqaWZm
aWVzIDQyOTQ2ODQyODMgKGFnZSAxMzA1MS45NThzKQ0KPiA+ICAgaGV4IGR1bXAgKGZpcnN0IDMy
IGJ5dGVzKToNCj4gPiAgICAgMTggMDAgMDAgMDAgMTggMDAgMTggMDAgNzAgZmMgMWEgOTUgYmQg
OTUgZmYNCj4gPiBmZiAgLi4uLi4uLi5wLi4uLi4uLg0KPiA+ICAgICAwMCAwMCBmZiBmZiAwMSAw
MCBmZiBmZiAwMiAwMCBmZiBmZiAwMyAwMCBmZg0KPiA+IGZmICAuLi4uLi4uLi4uLi4uLi4uDQo+
ID4gICBiYWNrdHJhY2U6DQo+ID4gICAgIFs8MDAwMDAwMDA3MmU0YjkxND5dIF9fa21hbGxvYysw
eDMzNi8weDU0MA0KPiA+ICAgICBbPDAwMDAwMDAwNTQ2NDJhODc+XSBhbGxvY19jcHVfcm1hcCsw
eDNiLzB4YjANCj4gPiAgICAgWzwwMDAwMDAwMGYyMjBkZWVjPl0gaWNlX3NldF9jcHVfcnhfcm1h
cCsweDZhLzB4MTEwIFtpY2VdDQo+ID4gICAgIFs8MDAwMDAwMDAyMzcwYTYzMj5dIGljZV9wcm9i
ZSsweDk0MS8weDExODAgW2ljZV0NCj4gPiAgICAgWzwwMDAwMDAwMGQ2OTJlZGJhPl0gbG9jYWxf
cGNpX3Byb2JlKzB4NDcvMHhhMA0KPiA+ICAgICBbPDAwMDAwMDAwNTAzOTM0ZjA+XSB3b3JrX2Zv
cl9jcHVfZm4rMHgxYS8weDMwDQo+ID4gICAgIFs8MDAwMDAwMDA1NTVhOWU0YT5dIHByb2Nlc3Nf
b25lX3dvcmsrMHgxZGQvMHg0MTANCj4gPiAgICAgWzwwMDAwMDAwMDJjNGI0MTRhPl0gd29ya2Vy
X3RocmVhZCsweDIyMS8weDNmMA0KPiA+ICAgICBbPDAwMDAwMDAwYmIyYjU1NmI+XSBrdGhyZWFk
KzB4MTRjLzB4MTcwDQo+ID4gICAgIFs8MDAwMDAwMDBhZDJjZjFjZD5dIHJldF9mcm9tX2Zvcmsr
MHgxZi8weDMwIHVucmVmZXJlbmNlZA0KPiA+IG9iamVjdA0KPiA+IDB4ZmZmZjk1YmQ4MWIwYTJh
MCAoc2l6ZSA5Nik6DQo+ID4gICBjb21tICJrd29ya2VyLzA6MSIsIHBpZCAxMzQsIGppZmZpZXMg
NDI5NDY4NDI4MyAoYWdlIDEzMDUxLjk1OHMpDQo+ID4gICBoZXggZHVtcCAoZmlyc3QgMzIgYnl0
ZXMpOg0KPiA+ICAgICAzOCAwMCAwMCAwMCAwMSAwMCAwMCAwMCBlMCBmZiBmZiBmZiAwZiAwMCAw
MA0KPiA+IDAwICA4Li4uLi4uLi4uLi4uLi4uDQo+ID4gICAgIGIwIGEyIGIwIDgxIGJkIDk1IGZm
IGZmIGIwIGEyIGIwIDgxIGJkIDk1IGZmDQo+ID4gZmYgIC4uLi4uLi4uLi4uLi4uLi4NCj4gPiAg
IGJhY2t0cmFjZToNCj4gPiAgICAgWzwwMDAwMDAwMDU4MmRkNWM1Pl0ga21lbV9jYWNoZV9hbGxv
Y190cmFjZSsweDMxZi8weDRjMA0KPiA+ICAgICBbPDAwMDAwMDAwMjY1OTg1MGQ+XSBpcnFfY3B1
X3JtYXBfYWRkKzB4MjUvMHhlMA0KPiA+ICAgICBbPDAwMDAwMDAwNDk1YTMwNTU+XSBpY2Vfc2V0
X2NwdV9yeF9ybWFwKzB4YjQvMHgxMTAgW2ljZV0NCj4gPiAgICAgWzwwMDAwMDAwMDIzNzBhNjMy
Pl0gaWNlX3Byb2JlKzB4OTQxLzB4MTE4MCBbaWNlXQ0KPiA+ICAgICBbPDAwMDAwMDAwZDY5MmVk
YmE+XSBsb2NhbF9wY2lfcHJvYmUrMHg0Ny8weGEwDQo+ID4gICAgIFs8MDAwMDAwMDA1MDM5MzRm
MD5dIHdvcmtfZm9yX2NwdV9mbisweDFhLzB4MzANCj4gPiAgICAgWzwwMDAwMDAwMDU1NWE5ZTRh
Pl0gcHJvY2Vzc19vbmVfd29yaysweDFkZC8weDQxMA0KPiA+ICAgICBbPDAwMDAwMDAwMmM0YjQx
NGE+XSB3b3JrZXJfdGhyZWFkKzB4MjIxLzB4M2YwDQo+ID4gICAgIFs8MDAwMDAwMDBiYjJiNTU2
Yj5dIGt0aHJlYWQrMHgxNGMvMHgxNzANCj4gPiAgICAgWzwwMDAwMDAwMGFkMmNmMWNkPl0gcmV0
X2Zyb21fZm9yaysweDFmLzB4MzANCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBZb25neGluIExp
dSA8eW9uZ3hpbi5saXVAd2luZHJpdmVyLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9tYWluLmMgfCAxICsNCj4gPiAgMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2ljZS9pY2VfbWFpbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRl
bC9pY2UvaWNlX21haW4uYw0KPiA+IGluZGV4IDJjMjNjOGY0NjhhNS4uOWMyZDU2N2EyNTM0IDEw
MDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfbWFpbi5j
DQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9tYWluLmMNCj4g
PiBAQCAtNDU2OCw2ICs0NTY4LDcgQEAgc3RhdGljIGludCBfX21heWJlX3VudXNlZCBpY2Vfc3Vz
cGVuZChzdHJ1Y3QNCj4gPiBkZXZpY2UNCj4gPiAqZGV2KQ0KPiA+ICAJCQljb250aW51ZTsNCj4g
PiAgCQlpY2VfdnNpX2ZyZWVfcV92ZWN0b3JzKHBmLT52c2lbdl0pOw0KPiA+ICAJfQ0KPiA+ICsJ
aWNlX2ZyZWVfY3B1X3J4X3JtYXAoaWNlX2dldF9tYWluX3ZzaShwZikpOw0KPiA+ICAJaWNlX2Ns
ZWFyX2ludGVycnVwdF9zY2hlbWUocGYpOw0KPiA+IA0KPiA+ICAJcGNpX3NhdmVfc3RhdGUocGRl
dik7DQo+ID4gLS0NCj4gPiAyLjE0LjUNCj4gDQo+IA0K
