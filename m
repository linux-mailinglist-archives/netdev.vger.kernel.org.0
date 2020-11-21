Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE40D2BBB2B
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 01:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgKUAnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 19:43:24 -0500
Received: from mga07.intel.com ([134.134.136.100]:29746 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbgKUAnY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 19:43:24 -0500
IronPort-SDR: +6thAyWso02+oypOTXVt50M9HitBetJNM2aKipW5GJJJMbGiNZTSp4M8QuYQ5qz5eV2pF3XhHH
 FEw/gSwLXhGA==
X-IronPort-AV: E=McAfee;i="6000,8403,9811"; a="235707679"
X-IronPort-AV: E=Sophos;i="5.78,357,1599548400"; 
   d="scan'208";a="235707679"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2020 16:43:23 -0800
IronPort-SDR: /ONQjlWyUnLeAqG2TQlam7sQ7RV3HTRJ7fjc0Up7Yp4DWLHOzFYH3EMyIPadIMJAdyYE88ePA+
 7MHTM3YNbzZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,357,1599548400"; 
   d="scan'208";a="342225259"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga002.jf.intel.com with ESMTP; 20 Nov 2020 16:43:23 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 20 Nov 2020 16:43:22 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 20 Nov 2020 16:43:22 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 20 Nov 2020 16:43:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=miOk+uQFRLq8783LHXm4SDQBwpXGc/N8vWy1R36fJpp1XYYv1aPcIVyLQ4OvexfZh82tpkOuipx6qZKpYEM7BZFyx1YiBsmNmNjRvTkNW4BqPfxTVq7P2lrKc7kJImTEeVYhYvsnkmzU999qepjWOItXRAPmVOrYMkXEvoVnUt8wASYj99l071x0bomvKNSIiWOLvIPw4tKCpavu+l28VF2ODwfz9+j8yhfrx+p5hAjwrLBEU+dn6LdX31TuJfjy3SN0vdj2Dl2noVAomiwEjtbgDl3T+rvkMSd2LYphTOA+PP+OLSKNyRMI1kd0ZU9LSKFRLHgmh+falU4J1s9EJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zo+q5Io9eu/bauRUozsWxdkkcKriuehLXO6y0a+uP8o=;
 b=XcmZil2F6mJ50gsJzWnTlcNLcySCpBqGzIfgmVAB/gS4ztXzbsmUe/wlCXqIYAHh59ogcX15EOQmBOGT3XYHL4D0KCZ7K/tzX/0nI3Yl3w4TuA2XRBr4VTUsoOy2PZCc2T7jaVwnLXOCMrRo9NNV6aD3AVQxnOnBQtBE3eMaEQTuNUqnLWt6oz6U9UbPZgSTkCoNQQ1f64HzTxlNbVs9DnQ2Dst4HLknpbR1GfHQuihBN98MIrUWjVDo92ZRYNgzhO2ZCq+bv/vWartzD0joxem2hM/NBgZIu7SijbyyxAiiV9Dxtxet3uDIyAuE/IWJMqEt7DMzs6BQd6UjCoakMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zo+q5Io9eu/bauRUozsWxdkkcKriuehLXO6y0a+uP8o=;
 b=uz/0qHzXobj/s4CcXC980eFJX9YdCGaThnVuippR/I0rBu/ZGANvC7aJ1EY1iTRdK2khsiQu4RqRmmetmoqT5nhOUTWccsFbWHqUVC3Dc1LfXuNoihbqSxP1Y5FNxdXmwh81VGk4Rn+PxOWvt7D/mbIoubT3rPGoW/5bWvIBaF4=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3471.namprd11.prod.outlook.com (2603:10b6:805:c1::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Sat, 21 Nov
 2020 00:43:21 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::5c92:dd20:ec58:76da]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::5c92:dd20:ec58:76da%6]) with mapi id 15.20.3589.024; Sat, 21 Nov 2020
 00:43:21 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Stillwell Jr, Paul M" <paul.m.stillwell.jr@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: Re: [net-next v3 08/15] ice: don't always return an error for Get PHY
 Abilities AQ command
Thread-Topic: [net-next v3 08/15] ice: don't always return an error for Get
 PHY Abilities AQ command
Thread-Index: AQHWugZE1iBrm4pHyEadjuWdiQP1ZqnG1hCAgAr0gQA=
Date:   Sat, 21 Nov 2020 00:43:21 +0000
Message-ID: <9f91c1494edd47345bf5851d31ef19b2e77bd70d.camel@intel.com>
References: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
         <20201113214429.2131951-9-anthony.l.nguyen@intel.com>
         <CAKgT0Uedphdr1RvdB_Zw5aAH-2CuudwGK8OenrvrQ1bE0XK-pQ@mail.gmail.com>
In-Reply-To: <CAKgT0Uedphdr1RvdB_Zw5aAH-2CuudwGK8OenrvrQ1bE0XK-pQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f97e6f7f-6e17-460f-a52a-08d88db6726b
x-ms-traffictypediagnostic: SN6PR11MB3471:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3471D564340363C9223F38F0C6FE0@SN6PR11MB3471.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rtg7Tr89g+0VSA5B+LsE3mv2q09q+OaH1KTD+PqJB9aJWx2aGfxbZKMNQc6ZoDm6u3d6A7MViOP5wyzV92QpT+ZcANaeA+PunpSb8ZkaXfUWNyYz5MROXcPq54MxrDiDWnIViMTk40MpoQaivobTInntkanYp4kYGvNpDEW8xNDVf+UYMm5qQI8evOGM95AuFYhn57K4IdoUGYpsJwfNWLWPn2oc3BdoFbFCT43tB5mqr0z/Snhf+LuYDlcHylf5Xkj0jjiSz6zSKB/dr3P31e0rw6LtsKKHG/pO2RuwUXkbQJMitxsSuNorldstDe7HEYc6ECWZtXWt7CTnyI3Q6L8X6k9hqx1m88OAk1XzwRBbCDQ3YE8n7HcwHNP++Hqf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(64756008)(2906002)(66946007)(8676002)(66476007)(26005)(316002)(5660300002)(83380400001)(4001150100001)(186003)(54906003)(6506007)(53546011)(2616005)(66446008)(91956017)(36756003)(66556008)(6916009)(8936002)(6486002)(86362001)(6512007)(4326008)(76116006)(478600001)(71200400001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: w5RzeD+dOlTSo7Fy/bzrarMfxNFdadUL1ml2yA4bTZhNTdckm4IfhSd4V2XDs665q/a/sb5KQAXVeS4LnqtBcQhAIr4aC7JJipeQLJbxlNqVYOtgUXgDbOpaz4II43ztxGjVnuCCF7q2oJyC55jx1wvJ5e0asu37ERrqFWIWTAf+PGacZIZvVf7Jf7buHa9DKQ3/FIItMrNrlwawJw+gLfvF66USKdXRcePII8pJP50hOradW5Y5waLcHwGoU/FM6s52PYFk3uCSchXExsGr09R4uVB7CR+AeEqqfpINg8GOzp+cYOMFblufxZKNwSyYxt6J0HfPfZbHXEMu8LjMpWUn2N1EtHV7GU4wkX8VnZLLBfyzoNUD7YfGmEcZwEXm+F9sHDSADAKukIGR7CQ0FL+N+gXrWlVemX4aWFhivZLLB/PbHtJ1tzMIkBKsvP5p56qJya8qLdFzGn4y0VHtTc2rZTy/8RYICB7EeRlt3sLYaKIv0y3+9WjwK7LSQuRaglkyufC2UBY3vsAlYv7DCVjx/kvX7TWP0SZ7mHe89BFA+b5IapGrLjYf994PdtQkzqRMKXNatkUK4tmPhg345fEI0uZJQCG+WZFzq26FALcOejFK3MZsglsQH/+f3VxwUyjkO8TkvzJOUp+fGqMI5XNlvjoq5L+GEM6E6HpEjeGoZJDi3krzKYqODCNWR0i0/sdKo9+O/rCJUlqZqvFb3fRzB2WBYhgJT808Os8APJfralilfilaj9Gtb3qwzq55mSpUvQa24Nhrq69EJAcXUzceN4EuenyigdkBdnV4Wd2hwrcwKHa9cFI2vOobjrHlfZefZUmIKs8GF0O2JhCwvz/86YP9DYNur5nq9tDypkZBNeuXnY+NS0VI/wJYR6+4oQMzrUMDlJYujYj81LJPiQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB1E0B3E8E52B944BA53787EBF6157DB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f97e6f7f-6e17-460f-a52a-08d88db6726b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2020 00:43:21.4987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cvTJJMbRxMHuEGWJlXDtRymHr2zmKT/O7IMww8PNiQb+gAlMoo/8iRT7tkoEmlJ+dIykLiNcwsJMGmOmmY/7Q/s/4vGcE1keXxeSjdo0wcs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3471
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTExLTEzIGF0IDE3OjI1IC0wODAwLCBBbGV4YW5kZXIgRHV5Y2sgd3JvdGU6
DQo+IE9uIEZyaSwgTm92IDEzLCAyMDIwIGF0IDE6NDkgUE0gVG9ueSBOZ3V5ZW4gPA0KPiBhbnRo
b255Lmwubmd1eWVuQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gRnJvbTogUGF1bCBNIFN0
aWxsd2VsbCBKciA8cGF1bC5tLnN0aWxsd2VsbC5qckBpbnRlbC5jb20+DQo+ID4gDQo+ID4gVGhl
cmUgYXJlIHRpbWVzIHdoZW4gdGhlIGRyaXZlciBzaG91bGRuJ3QgcmV0dXJuIGFuIGVycm9yIHdo
ZW4gdGhlDQo+ID4gR2V0DQo+ID4gUEhZIGFiaWxpdGllcyBBUSBjb21tYW5kICgweDA2MDApIHJl
dHVybnMgYW4gZXJyb3IuIEluc3RlYWQgdGhlDQo+ID4gZHJpdmVyDQo+ID4gc2hvdWxkIGxvZyB0
aGF0IHRoZSBlcnJvciBvY2N1cnJlZCBhbmQgY29udGludWUgb24uIFRoaXMgYWxsb3dzIHRoZQ0K
PiA+IGRyaXZlciB0byBsb2FkIGV2ZW4gdGhvdWdoIHRoZSBBUSBjb21tYW5kIGZhaWxlZC4gVGhl
IHVzZXIgY2FuIHRoZW4NCj4gPiBsYXRlciBkZXRlcm1pbmUgdGhlIHJlYXNvbiBmb3IgdGhlIGZh
aWx1cmUgYW5kIGNvcnJlY3QgaXQuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogUGF1bCBNIFN0
aWxsd2VsbCBKciA8cGF1bC5tLnN0aWxsd2VsbC5qckBpbnRlbC5jb20+DQo+ID4gVGVzdGVkLWJ5
OiBBYXJvbiBCcm93biA8YWFyb24uZi5icm93bkBpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1i
eTogVG9ueSBOZ3V5ZW4gPGFudGhvbnkubC5uZ3V5ZW5AaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+
ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2NvbW1vbi5jIHwgMiArLQ0KPiA+
ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gPiANCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9jb21tb24u
Yw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9jb21tb24uYw0KPiA+
IGluZGV4IDdkYjVmZDk3NzM2Ny4uM2M2MDA4MDhkMGRhIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfY29tbW9uLmMNCj4gPiArKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2NvbW1vbi5jDQo+ID4gQEAgLTkyNSw3ICs5MjUs
NyBAQCBlbnVtIGljZV9zdGF0dXMgaWNlX2luaXRfaHcoc3RydWN0IGljZV9odyAqaHcpDQo+ID4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIElDRV9BUUNfUkVQT1JUX1RPUE9f
Q0FQLA0KPiA+IHBjYXBzLCBOVUxMKTsNCj4gPiAgICAgICAgIGRldm1fa2ZyZWUoaWNlX2h3X3Rv
X2RldihodyksIHBjYXBzKTsNCj4gPiAgICAgICAgIGlmIChzdGF0dXMpDQo+ID4gLSAgICAgICAg
ICAgICAgIGdvdG8gZXJyX3Vucm9sbF9zY2hlZDsNCj4gPiArICAgICAgICAgICAgICAgaWNlX2Rl
YnVnKGh3LCBJQ0VfREJHX1BIWSwgIkdldCBQSFkgY2FwYWJpbGl0aWVzDQo+ID4gZmFpbGVkLCBj
b250aW51aW5nIGFueXdheVxuIik7DQo+ID4gDQo+ID4gICAgICAgICAvKiBJbml0aWFsaXplIHBv
cnRfaW5mbyBzdHJ1Y3Qgd2l0aCBsaW5rIGluZm9ybWF0aW9uICovDQo+ID4gICAgICAgICBzdGF0
dXMgPSBpY2VfYXFfZ2V0X2xpbmtfaW5mbyhody0+cG9ydF9pbmZvLCBmYWxzZSwgTlVMTCwNCj4g
PiBOVUxMKTsNCj4gPiAtLQ0KPiA+IDIuMjYuMg0KPiA+IA0KPiANCj4gSWYgd2UgYXJlIGV4cGVj
dGluZyB0aGUgdXNlciB0byBjb3JyZWN0IHRoaW5ncyB0aGVuIHdlIHNob3VsZCBiZQ0KPiBwdXR0
aW5nIG91dCBhIHdhcm5pbmcgdmlhIGRldl93YXJuKCkgcmF0aGVyIHRoYW4gYSBkZWJ1ZyBtZXNz
YWdlLg0KPiBPdGhlcndpc2UgdGhlIHVzZXIgaXMganVzdCBnb2luZyB0byBoYXZlIHRvIGNvbWUg
YmFjayB0aHJvdWdoIGFuZA0KPiB0dXJuDQo+IG9uIGRlYnVnZ2luZyBhbmQgcmVsb2FkIHRoZSBk
cml2ZXIgaW4gb3JkZXIgdG8gZmlndXJlIG91dCB3aGF0IGlzDQo+IGdvaW5nIG9uLiBJbiBteSBt
aW5kIGl0IHNob3VsZCBnZXQgdGhlIHNhbWUgdHJlYXRtZW50IGFzIGFuIG91dGRhdGVkDQo+IE5W
TSBpbWFnZSBpbiBpY2VfYXFfdmVyX2NoZWNrKCkuDQoNCldpbGwgY2hhbmdlIHRoaXMgdG8gYSBk
ZXZfd2FybigpLg0KDQpUaGFua3MsDQpUb255DQo=
