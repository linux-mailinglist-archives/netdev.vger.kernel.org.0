Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F93E2BBB2A
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 01:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgKUAmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 19:42:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:36780 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbgKUAmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 19:42:38 -0500
IronPort-SDR: dv9p7exVXztm4tZK+FsVpJRZJir1ypCfJZY/YikK81uZpQUM1b2wXY99eD6yUlKIKkyZc5QdyT
 Sz85+VRtHqtg==
X-IronPort-AV: E=McAfee;i="6000,8403,9811"; a="158603737"
X-IronPort-AV: E=Sophos;i="5.78,357,1599548400"; 
   d="scan'208";a="158603737"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2020 16:42:37 -0800
IronPort-SDR: c26v+cpb69pYsYCM0DXpUnmJrsQ6xNVPmV5+CkpxrioT9wyKhxdfGi7xAvDjAy6L8/F8K84Rm5
 vUwhS3S/mGtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,357,1599548400"; 
   d="scan'208";a="342225061"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga002.jf.intel.com with ESMTP; 20 Nov 2020 16:42:37 -0800
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 20 Nov 2020 16:42:37 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 20 Nov 2020 16:42:37 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 20 Nov 2020 16:42:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EG8ed6991Iw3NS6B/GJ3kwCsadWCayFFFHc85Dd55j0t5zOVM0XM6cbCojY1fRobl2hi+GfMGnYoSlhtKdUa0Sjr/eBw1coU/p8C3igFX5gbT5iwviXEgCoHAjpbVRFJzce2QA6kR3XQW2LGK/VCYk6e9Wx6wC/eXsQ8Tt8SEM1g/4IcE1QifMfblLQAwP7dmor+YLtBs+vjUnDyz3yk/n6sTLQQ71VVs7n8yILsBwWNzjMNyBvIUyrFFjLtR3C5tMsI13p2xVIhTXSuIOqFi8trltOEaTSnFKT6y1pEEdTi9eCkEHTED2+xro+QY6EwzMtFkzE7PiyEJ9Ejxjqjqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ru6jOaVzbZLcAhX+dgWoaVfO919H8zE659xaQ+sHFE0=;
 b=JM/722n4/7wqHjEtUEiZ5urnjaZeoUYGt1mk7lhoYBHkkrjmUaei8eXfgCYkPaYU+3zGkh54gjH83D7iEWHYRI29/e7gHVZ788aXIh3K4Y7ChSSUbCXQBTjHPIxaSt7j3YBjuiVwk1EKeDYjhftbDZYNV/AEcWZjvSoPd5yevIv+5U4mZ0OAHfw/jsrSCH5GVBcPen08fuvwo8AIR2jmvAneBYhoJpA3YSnIpV7EtxLPNHnYns/SoztyyDDHzcJo8wrj65tWZLtr7ViNxWtcWcOyQA7pb9faxqzVz59hiAM5dXF4E1nNDPvBCH0bsf1eDsKYjUg6pu4c0qbM2Pm1Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ru6jOaVzbZLcAhX+dgWoaVfO919H8zE659xaQ+sHFE0=;
 b=h8ICHT2I3NG0GTFCn5QMrwS9vEctBhhHIkTC35wyaUU0d2PM242iRz/kCSXSM9b9TTP1kWLnrBAWSZ4iqQ4A8Id2AtNJ89Ux+97Uz5TiXeHO2Vi5RzPkzLdH61YTHhTNi8Q6xfWzugF/v+ixuEmsR+KWnIxxaPFG0GLIYgQDD9A=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3471.namprd11.prod.outlook.com (2603:10b6:805:c1::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Sat, 21 Nov
 2020 00:42:36 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::5c92:dd20:ec58:76da]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::5c92:dd20:ec58:76da%6]) with mapi id 15.20.3589.024; Sat, 21 Nov 2020
 00:42:36 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>
CC:     "Cao, Chinh T" <chinh.t.cao@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Behera, BrijeshX" <brijeshx.behera@intel.com>,
        "Valiquette, Real" <real.valiquette@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next v3 05/15] ice: create flow profile
Thread-Topic: [net-next v3 05/15] ice: create flow profile
Thread-Index: AQHWugZDQ0KUjLzWCEaF3FhqdKPwsqnGvQ6AgAsNTYA=
Date:   Sat, 21 Nov 2020 00:42:35 +0000
Message-ID: <fd0fc6f95f4c107d1aed18bf58239fda91879b26.camel@intel.com>
References: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
         <20201113214429.2131951-6-anthony.l.nguyen@intel.com>
         <CAKgT0UeQ5q2M-uiR0-1G=30syPiO8S5OFHvDuN1XtQg5700hCg@mail.gmail.com>
In-Reply-To: <CAKgT0UeQ5q2M-uiR0-1G=30syPiO8S5OFHvDuN1XtQg5700hCg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66a597f3-8184-401f-f729-08d88db65749
x-ms-traffictypediagnostic: SN6PR11MB3471:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3471AB27D001B32165C1351FC6FE0@SN6PR11MB3471.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oL1VIqLZcrlptKO0b/vaJ4nonWmmij1lOZRX60zb/uKKePztLk31AICNy2AzT2rOi/w+PQPsRcOJpJZvZhpcMoHJuwzIb9TQaFI9+qnogw0MandyrnFwN0Q+bImM6C9Bp7TwO/YDWqk6HTrQ00eMeWn0+uNWWr72d/4gl4vT2l63GfQ0K37XgM0H411VcQf82UhCEu8gqRbpSKepqR5bacH9vy297NsNr2MojclncPLMcdc1DZN6K/VD5uUJI+n3ZpxAfrpmLt6cSG0YBrW6KwpI/w2BVCOkfEAFM/G3u6hSEusBdpLDY5NDd6IFMRggnOWiSxYXXaS5tIRcbEngg8LOroRUsdfaaihrhvdJR2DyXp39WdYCCXHZU1LUWH7/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(64756008)(2906002)(66946007)(8676002)(66476007)(26005)(316002)(5660300002)(83380400001)(4001150100001)(186003)(54906003)(6506007)(53546011)(2616005)(66446008)(91956017)(36756003)(66556008)(6916009)(8936002)(6486002)(86362001)(6512007)(4326008)(76116006)(478600001)(71200400001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: gjjBwZ0zngr3ixogHoUFnCjvD7YgnN5ZxEmGVZu8AacdPy3Ijc8fnyffUFuIwrzsncUU8lxW1ZpcbN6kMOf0NEuOEoIWgXiMwuz1XjINGKQP5umgdXBGtnqpRXrjAGnTe35fvWRRT3Z8tnC7XPlsCVJDSz0b/rwmTi2da8YIkRSHkUkJdVpXWcGPpWfv29aUtD74tXDqGFsb63/uKEL+YzE1iYa4NXHf9ERaFbqZ4eVBxszXliJ/VAHzJfKW9oLXBleHRtkoUtSd/57F4GGTJ0Ah10mBTotLzxaCIbCjdzh4TAAXrUPgIW42CvNJmgQwzfh/TnZk1W6PpGQqoX7Ybl7Yjc8yfYXPDQMD+lBvHUpxMmcEaTSmlA9fkVeBfVLc3vVDeLeO79fMLNd7+G240PXpiBJJ0tR2Oo+ptHGDopD0hOoac4qRdm5PrYwkjoI7gLarvUUdKFqZyf9VRHUnzuDGRGdmliLdQdjzGdrcAdixp0L630g2t7LkrHhFFZxtCC+JmRcxCWrvvgiafx6aBqND8Kv4dGp/vt9pJtUhn/jUO7OK1AnpyCWb6iRJ4LX8+ih/WUpf/44wRPHBIXfxfWSgIUzEcarMhE92fphGQfv9RoPAo+mYNtOC/W/mweR7UXRxxR/28nqkcxTfT2tbHMSe7kzg4cnJHejCHWpa6QeghQKMgyRH0B9ykQVw0cFR5pL7so45EY2YFM09NE0qP4cz32jkWMZoQiBV3HYMmCoJoY6MppFhf5LnfxREAhZz6YksWQhGfhS1JusbEkB4GhvcQ3eMOf/nZtPCPdoAH4WKX6YXwg8tAu1ji0nS4n1tStrWgvOgi/CoHBDNI9ThRhP04hgYe3CH3isZLJsFdL8BfaeRXtL0o0AknrdYzTKXFgQaBuTKyyMlcdF+RccGoQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <37BAD05EE4A9EA4EB464D4BCB9402451@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66a597f3-8184-401f-f729-08d88db65749
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2020 00:42:35.9805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D7IwJh9f9bob0ZEd6Nl2fwaiioehlAa/U9hE+MIGjBl+dQ4+ldAPBj+JteFdHJjfRkDEZj0rubjD/JGzhf6Bg6wLX1Ts9/mRVF5lvLJGmCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3471
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTExLTEzIGF0IDE1OjU2IC0wODAwLCBBbGV4YW5kZXIgRHV5Y2sgd3JvdGU6
DQo+IE9uIEZyaSwgTm92IDEzLCAyMDIwIGF0IDE6NDYgUE0gVG9ueSBOZ3V5ZW4gPA0KPiBhbnRo
b255Lmwubmd1eWVuQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gRnJvbTogUmVhbCBWYWxp
cXVldHRlIDxyZWFsLnZhbGlxdWV0dGVAaW50ZWwuY29tPg0KPiA+IA0KPiA+IEltcGxlbWVudCB0
aGUgaW5pdGlhbCBzdGVwcyBmb3IgY3JlYXRpbmcgYW4gQUNMIGZpbHRlciB0byBzdXBwb3J0DQo+
ID4gbnR1cGxlDQo+ID4gbWFza3MuIENyZWF0ZSBhIGZsb3cgcHJvZmlsZSBiYXNlZCBvbiBhIGdp
dmVuIG1hc2sgcnVsZSBhbmQgcHJvZ3JhbQ0KPiA+IGl0IHRvDQo+ID4gdGhlIGhhcmR3YXJlLiBU
aG91Z2ggdGhlIHByb2ZpbGUgaXMgd3JpdHRlbiB0byBoYXJkd2FyZSwgbm8gYWN0aW9ucw0KPiA+
IGFyZQ0KPiA+IGFzc29jaWF0ZWQgd2l0aCB0aGUgcHJvZmlsZSB5ZXQuDQo+ID4gDQo+ID4gQ28t
ZGV2ZWxvcGVkLWJ5OiBDaGluaCBDYW8gPGNoaW5oLnQuY2FvQGludGVsLmNvbT4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBDaGluaCBDYW8gPGNoaW5oLnQuY2FvQGludGVsLmNvbT4NCj4gPiBTaWduZWQt
b2ZmLWJ5OiBSZWFsIFZhbGlxdWV0dGUgPHJlYWwudmFsaXF1ZXR0ZUBpbnRlbC5jb20+DQo+ID4g
Q28tZGV2ZWxvcGVkLWJ5OiBUb255IE5ndXllbiA8YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+
DQo+ID4gU2lnbmVkLW9mZi1ieTogVG9ueSBOZ3V5ZW4gPGFudGhvbnkubC5uZ3V5ZW5AaW50ZWwu
Y29tPg0KPiA+IFRlc3RlZC1ieTogQnJpamVzaCBCZWhlcmEgPGJyaWplc2h4LmJlaGVyYUBpbnRl
bC5jb20+DQo+IA0KPiBTbyBJIHNlZSB0d28gYmlnIGlzc3VlcyB3aXRoIHRoZSBwYXRjaC4NCj4g
DQo+IEZpcnN0IGl0IGxvb2tzIGxpa2UgdGhlcmUgaXMgYW4gYW50aS1wYXR0ZXJuIG9mIGRlZmVu
c2l2ZSBOVUxMDQo+IHBvaW50ZXINCj4gY2hlY2tzIHRocm91Z2hvdXQuIFRob3NlIGNhbiBwcm9i
YWJseSBhbGwgZ28gc2luY2UgYWxsIG9mIHRoZSBjYWxsZXJzDQo+IGVpdGhlciB1c2UgdGhlIHBv
aW50ZXIsIG9yIHZlcmlmeSBpdCBpcyBub24tTlVMTCBiZWZvcmUgY2FsbGluZyB0aGUNCj4gZnVu
Y3Rpb24gaW4gcXVlc3Rpb24uDQoNCkknbSByZW1vdmluZyB0aG9zZSBjaGVja3MgdGhhdCB5b3Ug
cG9pbnRlZCBvdXQgYW5kIHNvbWUgb3RoZXJzIGFzIHdlbGwuDQoNCj4gDQo+IEluIGFkZGl0aW9u
IHRoZSBtYXNrIGhhbmRsaW5nIGRvZW5zJ3QgbG9vayByaWdodCB0byBtZS4gSXQgaXMgY2FsbGlu
Zw0KPiBvdXQgYSBwYXJ0aWFsIG1hc2sgYXMgYmVpbmcgdGhlIG9ubHkgdGltZSB5b3UgbmVlZCBh
biBBQ0wgYW5kIEkgd291bGQNCj4gdGhpbmsgaXQgaXMgYW55IHRpbWUgeW91IGRvbid0IGhhdmUg
YSBmdWxsIG1hc2sgZm9yIGFsbA0KPiBwb3J0cy9hZGRyZXNzZXMgc2luY2UgYSBmbG93IGRpcmVj
dG9yIHJ1bGUgbm9ybWFsbHkgcHVsbHMgaW4gdGhlIGZ1bGwNCj4gNCB0dXBsZSBiYXNlZCBvbiBp
Y2VfbnR1cGxlX3NldF9pbnB1dF9zZXQoKSAuDQoNCkNvbW1lbnRlZCBiZWxvdyBhcyB3ZWxsLg0K
DQo8c25pcD4NCg0KPiA+ICsvKioNCj4gPiArICogaWNlX2lzX2FjbF9maWx0ZXIgLSBDaGVja3Mg
aWYgaXQncyBhIEZEIG9yIEFDTCBmaWx0ZXINCj4gPiArICogQGZzcDogcG9pbnRlciB0byBldGh0
b29sIFJ4IGZsb3cgc3BlY2lmaWNhdGlvbg0KPiA+ICsgKg0KPiA+ICsgKiBJZiBhbnkgZmllbGQg
b2YgdGhlIHByb3ZpZGVkIGZpbHRlciBpcyB1c2luZyBhIHBhcnRpYWwgbWFzaw0KPiA+IHRoZW4g
dGhpcyBpcw0KPiA+ICsgKiBhbiBBQ0wgZmlsdGVyLg0KPiA+ICsgKg0KPiANCj4gSSdtIG5vdCBz
dXJlIHRoaXMgbG9naWMgaXMgY29ycmVjdC4gQ2FuIHRoZSBmbG93IGRpcmVjdG9yIHJ1bGVzDQo+
IGhhbmRsZQ0KPiBhIGZpZWxkIHRoYXQgaXMgcmVtb3ZlZD8gTGFzdCBJIGtuZXcgaXQgY291bGRu
J3QuIElmIHRoYXQgaXMgdGhlIGNhc2UNCj4geW91IHNob3VsZCBiZSB1c2luZyBBQ0wgZm9yIGFu
eSBjYXNlIGluIHdoaWNoIGEgZnVsbCBtYXNrIGlzIG5vdA0KPiBwcm92aWRlZC4gU28gaW4geW91
ciB0ZXN0cyBiZWxvdyB5b3UgY291bGQgcHJvYmFibHkgZHJvcCB0aGUgY2hlY2sNCj4gZm9yDQo+
IHplcm8gYXMgSSBkb24ndCB0aGluayB0aGF0IGlzIGEgdmFsaWQgY2FzZSBpbiB3aGljaCBmbG93
IGRpcmVjdG9yDQo+IHdvdWxkIHdvcmsuDQo+IA0KDQpJJ20gbm90IHN1cmUgd2hhdCB5b3UgbWVh
bnQgYnkgYSBmaWVsZCB0aGF0IGlzIHJlbW92ZWQsIGJ1dCBGbG93DQpEaXJlY3RvciBjYW4gaGFu
ZGxlIHJlZHVjZWQgaW5wdXQgc2V0cy4gRmxvdyBEaXJlY3RvciBpcyBhYmxlIHRvIGhhbmRsZQ0K
MCBtYXNrLCBmdWxsIG1hc2ssIGFuZCBsZXNzIHRoYW4gNCB0dXBsZXMuIEFDTCBpcyBuZWVkZWQv
dXNlZCBvbmx5IHdoZW4NCmEgcGFydGlhbCBtYXNrIHJ1bGUgaXMgcmVxdWVzdGVkLg0KDQoNCj4g
PiArICogUmV0dXJucyB0cnVlIGlmIEFDTCBmaWx0ZXIgb3RoZXJ3aXNlIGZhbHNlLg0KPiA+ICsg
Ki8NCj4gPiArc3RhdGljIGJvb2wgaWNlX2lzX2FjbF9maWx0ZXIoc3RydWN0IGV0aHRvb2xfcnhf
Zmxvd19zcGVjICpmc3ApDQo+ID4gK3sNCj4gPiArICAgICAgIHN0cnVjdCBldGh0b29sX3RjcGlw
NF9zcGVjICp0Y3BfaXA0X3NwZWM7DQo+ID4gKyAgICAgICBzdHJ1Y3QgZXRodG9vbF91c3JpcDRf
c3BlYyAqdXNyX2lwNF9zcGVjOw0KPiA+ICsNCj4gPiArICAgICAgIHN3aXRjaCAoZnNwLT5mbG93
X3R5cGUgJiB+RkxPV19FWFQpIHsNCj4gPiArICAgICAgIGNhc2UgVENQX1Y0X0ZMT1c6DQo+ID4g
KyAgICAgICBjYXNlIFVEUF9WNF9GTE9XOg0KPiA+ICsgICAgICAgY2FzZSBTQ1RQX1Y0X0ZMT1c6
DQo+ID4gKyAgICAgICAgICAgICAgIHRjcF9pcDRfc3BlYyA9ICZmc3AtPm1fdS50Y3BfaXA0X3Nw
ZWM7DQo+ID4gKw0KPiA+ICsgICAgICAgICAgICAgICAvKiBJUCBzb3VyY2UgYWRkcmVzcyAqLw0K
PiA+ICsgICAgICAgICAgICAgICBpZiAodGNwX2lwNF9zcGVjLT5pcDRzcmMgJiYNCj4gPiArICAg
ICAgICAgICAgICAgICAgIHRjcF9pcDRfc3BlYy0+aXA0c3JjICE9IGh0b25sKDB4RkZGRkZGRkYp
KQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiB0cnVlOw0KPiA+ICsNCj4gPiAr
ICAgICAgICAgICAgICAgLyogSVAgZGVzdGluYXRpb24gYWRkcmVzcyAqLw0KPiA+ICsgICAgICAg
ICAgICAgICBpZiAodGNwX2lwNF9zcGVjLT5pcDRkc3QgJiYNCj4gPiArICAgICAgICAgICAgICAg
ICAgIHRjcF9pcDRfc3BlYy0+aXA0ZHN0ICE9IGh0b25sKDB4RkZGRkZGRkYpKQ0KPiA+ICsgICAg
ICAgICAgICAgICAgICAgICAgIHJldHVybiB0cnVlOw0KPiA+ICsNCj4gDQo+IEluc3RlYWQgb2Yg
dGVzdGluZyB0aGlzIHVwIGhlcmUgeW91IGNvdWxkIGp1c3Qgc2tpcCB0aGUgYnJlYWsgYW5kDQo+
IGZhbGwNCj4gdGhyb3VnaCBzaW5jZSB0aGUgc291cmNlIGFuZCBkZXN0aW5hdGlvbiBJUCBhZGRy
ZXNzZXMgb2NjdXB5IHRoZSBzYW1lDQo+IHNwb3RzIG9uIHVzcl9pcDRfc3BlYyBhbmQgdGNwX2lw
NF9zcGVjLiBZb3UgY291bGQgcHJvYmFibHkgYWxzbyBqdXN0DQo+IHVzZSB0Y3BfaXA0X3NwZWMg
Zm9yIHRoZSBlbnRpcmUgdGVzdC4NCg0KV2lsbCBtYWtlIHRoaXMgY2hhbmdlLg0KDQpUaGFua3Ms
DQpUb255DQo=
