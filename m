Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E91AF3C3
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 02:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfIKApR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 20:45:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:12732 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbfIKApQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 20:45:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 17:45:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,491,1559545200"; 
   d="scan'208";a="189515975"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga006.jf.intel.com with ESMTP; 10 Sep 2019 17:45:15 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 10 Sep 2019 17:45:14 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 10 Sep 2019 17:45:14 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 10 Sep 2019 17:45:14 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.59) by
 edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 10 Sep 2019 17:45:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QeWyxjprS8r6NvcK7eVwmue0ykncsIkJQsi4fXQqDTmy/zl0wUpVY4HQQSghRqXshrj7U5iAugeGeAZrbmSiLirywniRokyI8XysD68+XE/7iVIB0nZB5nRNauHHMpdbXXYoFzH2a0YWh5LxdY9BKj6wlfqhCnd7ESra+bnqAyynKDXhx31w6u6+/svqGfANsXyf0RGAL0yaoCzmEfXHh0zIIzBC/Fz+D4Fev2w7jI/Cy6EbpkSQYXpCrtSRdE3OiEfOorZiOkSTRbfkw5IiJXIjRxb3pxqqFyGi/EzoxqKRQPcP7L34nKUp3mND/dks316vvmyvH1iSFQb39aGK3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yr0jp9+0qEQu1oPAumtg6pYp/7sy8oEekdMyJ4Y1KD4=;
 b=eDgA6ys1Ftm6Yn2aWX0fosRv00I2u8pIwx3lsd6ycjFSmFbk2BiAbTlczfZdsKU7hpPmmP4T0YweqDhk/EpdUXaVDrtp97ScFmoZDIYfN5L1ftYWMDbynLNNQ03Vf9fUjWy/0UnmRbPBsZotr5aHJXZFm+IDR2DpnMvDcGxXHMXIkkqBpLBtlXNhCKaY+rLm2EJwynauh5d2PmNyseeeWrzJe1XILRo7AHS7nyxrbFxuLxCMQsXLnRhZ18NLABpCr9FCbpQTZ3LFP5OxB6pK97PaWcNK7SK9xJ7LAAsDvrkh0VjMg8xnRxMdQ/rpJsJiyToBmQgRgTgL9PE7hSBGOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yr0jp9+0qEQu1oPAumtg6pYp/7sy8oEekdMyJ4Y1KD4=;
 b=Pj53TA4gL6SH9ZvAl/B905dDyR8EMLst5yDGawjYWv4HOXNPWIrruOxtPj4SOXwyhRd2ex2R7arKXdPtF70UxVTS2w72vHZs6FlfT5GP/PcjhpVhfkuV6q03sSA/95RMy6FHRb4JFELNXOAE/GVUsFyV3pVLOkP8FOtUe51/Mus=
Received: from BN6PR11MB0050.namprd11.prod.outlook.com (10.161.155.32) by
 BN6PR11MB1601.namprd11.prod.outlook.com (10.172.23.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Wed, 11 Sep 2019 00:45:12 +0000
Received: from BN6PR11MB0050.namprd11.prod.outlook.com
 ([fe80::a4e9:cc41:8ded:4c03]) by BN6PR11MB0050.namprd11.prod.outlook.com
 ([fe80::a4e9:cc41:8ded:4c03%3]) with mapi id 15.20.2241.018; Wed, 11 Sep 2019
 00:45:12 +0000
From:   "Gomes, Vinicius" <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "Patel, Vedang" <vedang.patel@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "kurt.kanzenbach@linutronix.de" <kurt.kanzenbach@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v1 net-next 00/15] tc-taprio offload for SJA1105 DSA
Thread-Topic: [PATCH v1 net-next 00/15] tc-taprio offload for SJA1105 DSA
Thread-Index: AQHVYasgWcMUawWtzkqtxe8Xm/RqoqcgRJKAgAPFHTCAABsLgIABanoQ
Date:   Wed, 11 Sep 2019 00:45:11 +0000
Message-ID: <BN6PR11MB0050D9E694A143CBBAA24E2986B10@BN6PR11MB0050.namprd11.prod.outlook.com>
References: <20190902162544.24613-1-olteanv@gmail.com>
 <20190907.155549.1880685136488421385.davem@davemloft.net>
 <BN6PR11MB00500FA0D6B5D39E794B44BB86B70@BN6PR11MB0050.namprd11.prod.outlook.com>
 <CA+h21hoQ-DaFGzALVmGo2mDJancUp5Fndc=o0f4LfD_9yaNi0g@mail.gmail.com>
In-Reply-To: <CA+h21hoQ-DaFGzALVmGo2mDJancUp5Fndc=o0f4LfD_9yaNi0g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzEzYjYyYjUtNmVmZi00ODU3LTgwZTgtMTVkNGRiMWMwYmQwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiM3NGTzdDQURIY1wvM2JcLzU3M1JqbjVNdGVaU09RTG9GRW1JWU56TzhmdlVvejRUYVdNZXljTzllWFZCQ3VSZUl0In0=
x-ctpclassification: CTP_NT
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vinicius.gomes@intel.com; 
x-originating-ip: [134.134.136.220]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1bd11364-21ec-4bfe-f553-08d736514dea
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB1601;
x-ms-traffictypediagnostic: BN6PR11MB1601:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB160169345A278462F143115186B10@BN6PR11MB1601.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39850400004)(396003)(376002)(366004)(189003)(199004)(53936002)(66066001)(6506007)(76176011)(102836004)(186003)(33656002)(229853002)(7696005)(81156014)(486006)(86362001)(11346002)(446003)(26005)(476003)(8676002)(52536014)(81166006)(7736002)(8936002)(2906002)(9686003)(66446008)(74316002)(305945005)(7416002)(3846002)(6116002)(66556008)(66476007)(54906003)(316002)(6916009)(478600001)(55016002)(1411001)(64756008)(6246003)(25786009)(99286004)(14454004)(256004)(71190400001)(71200400001)(66946007)(4326008)(6436002)(5660300002)(76116006);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR11MB1601;H:BN6PR11MB0050.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WiTYnXa467OSHNNqJ0YNNMH/Q4lv1sfWd+LCH7RaGKG0yfG7VSmqZUUSVmAXNfedCGBgvBJlehJ64a/u8fp4ft5tX7ZAdhNATFLweRq9x2Qx6GpTeyKd+920I9Ft30h69bghPAUvR3F/Aifnv9WzMTK7tDD08M4jSblwNX2GUDJg9z1zFDW63h0885fZEPYdDgv7uLqjTTBIVK/PoqHvoY9eFlspaAS17HOoNkca2b1xOU3QV8r4+K5V/NuYpi9B5zezYgoA1oNDO65syYRgfwHruhZ08vzVGev0EKsdGBcprmX6ZlFys8Hi0GI3ICgjBls7HfbH/VUVjjGexz0WKXUgcOlNMQ30YFKhETuS/7wmhpx/nyLL1wAwUvGhEuBlrwobQB1CypaUnJNr80L+QPqdLxsi7cxtc/BTG5+A860=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd11364-21ec-4bfe-f553-08d736514dea
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 00:45:11.8942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ylWllCfr3v7TYPmRUqJzhuojKoyFFdwzc06lLCF+aIsLKs7YJwABZ0KSPJlfe9D9BLs76gLP0zXRagZceIJGlLv+LHitLQeuHLANGDn2FxE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1601
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNClsuLi5dDQoNCj4gDQo+IEknbGwgbWFrZSBzdXJlIHRoaXMgc3VidGxl
dHkgaXMgbW9yZSBjbGVhcmx5IGZvcm11bGF0ZWQgaW4gdGhlIG5leHQgdmVyc2lvbiBvZiB0aGUN
Cj4gcGF0Y2guDQo+IA0KDQpBY2suDQoNCj4gQWN0dWFsbHkgbGV0IG1lIGFzayB5b3UgYSBmZXcg
cXVlc3Rpb25zIGFzIHdlbGw6DQo+IA0KPiAtIEknbSB0cnlpbmcgdG8gdW5kZXJzdGFuZCB3aGF0
IGlzIHRoZSBjb3JyZWN0IHVzZSBvZiB0aGUgdGMtbXFwcmlvICJxdWV1ZXMiDQo+IGFyZ3VtZW50
LiBJJ3ZlIG9ubHkgdGVzdGVkIGl0IHdpdGggIjFAMCAxQDEgMUAyIDFAMyAxQDQgMUA1DQo+IDFA
NiAxQDciLCB3aGljaCBJIGJlbGlldmUgaXMgZXF1aXZhbGVudCB0byBub3Qgc3BlY2lmeWluZyBp
dCBhdCBhbGw/IEkgYmVsaWV2ZSBpdA0KPiBzaG91bGQgYmUgaW50ZXJwcmV0ZWQgYXM6ICJhbGxv
Y2F0ZSB0aGlzIG1hbnkgbmV0ZGV2IHF1ZXVlcyBmb3IgZWFjaCB0cmFmZmljDQo+IGNsYXNzIiwg
d2hlcmUgInRyYWZmaWMgY2xhc3MiIG1lYW5zIGEgZ3JvdXAgb2YgcXVldWVzIGhhdmluZyB0aGUg
c2FtZSBwcmlvcml0eQ0KPiAoZXF1YWwgdG8gdGhlIHRyYWZmaWMgY2xhc3MncyBudW1iZXIpLCBi
dXQgZW5nYWdlZCBpbiBhIHN0cmljdCBwcmlvcml0eSBzY2hlbWUgd2l0aA0KPiBvdGhlciBncm91
cHMgb2YgcXVldWVzICh0cmFmZmljIGNsYXNzZXMpLiBSaWdodD8NCg0KU3BlY2lmeWluZyB0aGUg
InF1ZXVlcyIgaXMgbWFuZGF0b3J5LCBJSVJDLiBZZWFoLCB5b3VyIHJlYWRpbmcgb2YgdGhvc2Ug
YXJndW1lbnRzDQpmb3IgeW91IGV4YW1wbGUgbWF0Y2hlcyBtaW5lLg0KDQpTbyB5b3UgbWVhbiwg
dGhhdCB5b3Ugb25seSB0ZXN0ZWQgc2l0dWF0aW9ucyB3aGVuIG9ubHkgb25lIHF1ZXVlIGlzICJv
cGVuIiBhdCBhIHRpbWU/DQpJIHRoaW5rIHRoaXMgaXMgYW5vdGhlciBnb29kIHRoaW5nIHRvIHRl
c3QuDQoNCj4gDQo+IC0gRFNBIGNhbiBvbmx5IGZvcm1hbGx5IHN1cHBvcnQgbXVsdGktcXVldWUs
IGJlY2F1c2UgaXRzIGNvbm5lY3Rpb24gdG8gdGhlIExpbnV4DQo+IGhvc3QgaXMgdGhyb3VnaCBh
biBFdGhlcm5ldCBNQUMgKEZJRk8pLiBFdmVuIGlmIHRoZSBEU0EgbWFzdGVyIG5ldGRldmljZSBt
YXkNCj4gYmUgbXVsdGktcXVldWUsIGFsbG9jYXRpbmcgYW5kIHNlcGFyYXRpbmcgdGhvc2UgcXVl
dWVzIGZvciBlYWNoIGZyb250LXBhbmVsDQo+IHN3aXRjaCBwb3J0IGlzIGEgdGFzayBiZXN0IGxl
ZnQgdG8gdGhlIHVzZXIvYWRtaW5pc3RyYXRvci4gVGhpcyBtZWFucyB0aGF0IERTQQ0KPiBzaG91
bGQgcmVqZWN0IGFsbCBvdGhlciAicXVldWVzIiBtYXBwaW5ncyBleGNlcHQgdGhlIHRyaXZpYWwg
b25lIEkgcG9pbnRlZCB0bw0KPiBhYm92ZT8NCj4gDQo+IC0gSSdtIGxvb2tpbmcgYXQgdGhlICJ0
Y19tYXNrX3RvX3F1ZXVlX21hc2siIGZ1bmN0aW9uIHRoYXQgSSdtIGNhcnJ5aW5nIGFsb25nDQo+
IGZyb20geW91ciBpbml0aWFsIG9mZmxvYWQgUkZDLiBBcmUgeW91IHN1cmUgdGhpcyBpcyB0aGUg
cmlnaHQgYXBwcm9hY2g/IEkgZG9uJ3QgZmVlbA0KPiBhIG5lZWQgdG8gdHJhbnNsYXRlIGZyb20g
dHJhZmZpYyBjbGFzcyB0byBuZXRkZXYgcXVldWVzLCBjb25zaWRlcmluZyB0aGF0IGluIHRoZQ0K
PiBnZW5lcmFsIGNhc2UsIGEgdHJhZmZpYyBjbGFzcyBpcyBhIGdyb3VwIG9mIHF1ZXVlcywgYW5k
IDgwMi4xUWJ2IGRvZXNuJ3QgcmVhbGx5DQo+IHNwZWNpZnkgdGhhdCB5b3UgY2FuIGdhdGUgaW5k
aXZpZHVhbCBxdWV1ZXMgZnJvbSBhIHRyYWZmaWMgY2xhc3MuIEluIHRoZSBzb2Z0d2FyZQ0KPiBp
bXBsZW1lbnRhdGlvbiB5b3UgYXJlIG9ubHkgbG9va2luZyBhdCBuZXRkZXZfZ2V0X3ByaW9fdGNf
bWFwLCB3aGljaCBpcyBub3QNCj4gZXF1aXZhbGVudCBhcyBmYXIgYXMgbXkgdW5kZXJzdGFuZGlu
ZyBnb2VzLCBidXQgc2FuZXIuDQo+IEFjdHVhbGx5IDgwMi4xUS0yMDE4IGRvZXMgbm90IHJlYWxs
eSBjbGFyaWZ5IHRoaXMgZWl0aGVyLiBJdCBsb29rcyB0byBtZSBsaWtlIHRoZXkNCj4gdXNlIHRo
ZSB0ZXJtICJxdWV1ZSIgYW5kICJ0cmFmZmljIGNsYXNzIiBpbnRlcmNoYW5nZWFibHkuDQo+IFNl
ZSB0d28gZXhhbXBsZXMgYmVsb3cgKGVtcGhhc2lzIG1pbmUpOg0KDQpJIHNwZW50IHF1aXRlIGEg
bG9uZyB0aW1lIHRoaW5raW5nIGFib3V0IHRoaXMsIHN0aWxsIG5vdCBzdXJlIHRoYXQgSSBnb3Qg
aXQgcmlnaHQuIExldCBtZSBiZWdpbg0Kd2l0aCB0aGUgb2JqZWN0aXZlIGZvciB0aGF0ICJ0cmFu
c2xhdGlvbiIuIFNjaGVkdWxlZCB0cmFmZmljIG9ubHkgbWFrZXMgc2Vuc2Ugd2hlbg0KdGhlIHdo
b2xlIG5ldHdvcmsgc2hhcmVzIHRoZSBzYW1lIHNjaGVkdWxlLCBzbywgSSB3YW50ZWQgYSB3YXkg
c28gSSBtaW5pbWl6ZSB0aGUNCmFtb3VudCBvZiBpbmZvcm1hdGlvbiBvZiBlYWNoIHNjaGVkdWxl
IHRoYXQncyBjb250cm9sbGVyIGRlcGVuZGVudCwgTGludXggYWxyZWFkeSANCmRvZXMgbW9zdCBv
ZiBpdCB3aXRoIHRoZSBzZXBhcmF0aW9uIG9mIHRyYWZmaWMgY2xhc3NlcyBhbmQgcXVldWVzICh5
b3UgYXJlIHJpZ2h0IHRoYXQgDQo4MDIuMVEgaXMgY29uZnVzaW5nIG9uIHRoaXMpLCB0aGUgaWRl
YSBpcyB0aGF0IHRoZSBvbmx5IHRoaW5nIHRoYXQgbmVlZHMgdG8gY2hhbmdlIGZyb20gDQpvbmUg
bm9kZSB0byBhbm90aGVyIGluIHRoZSBuZXR3b3JrIGlzIHRoZSAicXVldWVzIiBwYXJhbWV0ZXIu
IEJlY2F1c2UgZWFjaCBub2RlIG1pZ2h0IA0KaGF2ZSBkaWZmZXJlbnQgbnVtYmVyIG9mIHF1ZXVl
cywgb3IgYXNzaWduIGRpZmZlcmVudCBwcmlvcml0aWVzIHRvIGRpZmZlcmVudCBxdWV1ZXMuICAN
Cg0KU28sIHRoYXQncyB0aGUgaWRlYSBvZiBkb2luZyB0aGF0IGludGVybWVkaWF0ZSAidHJhbnNm
b3JtYXRpb24iIHN0ZXA6IHRhcHJpbyBrbm93cyBhYm91dA0KdHJhZmZpYyBjbGFzc2VzIGFuZCBI
VyBxdWV1ZXMsIGJ1dCB0aGUgZHJpdmVyIG9ubHkga25vd3MgYWJvdXQgSFcgcXVldWVzLiBBbmQg
dW5sZXNzIEkgbWFkZQ0KYSBtaXN0YWtlLCB0Y19tYXNrX3RvX3F1ZXVlX21hc2soKSBzaG91bGQg
YmUgZXF1aXZhbGVudCB0bzogIA0KDQpuZXRkZXZfZ2V0X3ByaW9fdGNfbWFwKCkgKyBzY2Fubmlu
ZyB0aGUgZ2F0ZW1hc2sgZm9yIEJJVCh0YykuDQoNCihUaGlua2luZyBtb3JlIGFib3V0IHRoaXMs
IEkgYW0gaGF2aW5nIGEgZmV3IGlkZWFzIGFib3V0IHdheXMgdG8gc2ltcGxpZnkgc29mdHdhcmUg
bW9kZSA6LSkNCg0KPiANCj4gUS4yIFVzaW5nIGdhdGUgb3BlcmF0aW9ucyB0byBjcmVhdGUgcHJv
dGVjdGVkIHdpbmRvd3MgVGhlIGVuaGFuY2VtZW50cyBmb3INCj4gc2NoZWR1bGVkIHRyYWZmaWMg
ZGVzY3JpYmVkIGluIDguNi44LjQgYWxsb3cgdHJhbnNtaXNzaW9uIHRvIGJlIHN3aXRjaGVkIG9u
IGFuZA0KPiBvZmYgb24gYSB0aW1lZCBiYXNpcyBmb3IgZWFjaCBfdHJhZmZpYyBjbGFzc18gdGhh
dCBpcyBpbXBsZW1lbnRlZCBvbiBhIHBvcnQuIFRoaXMNCj4gc3dpdGNoaW5nIGlzIGFjaGlldmVk
IGJ5IG1lYW5zIG9mIGluZGl2aWR1YWwgb24vb2ZmIHRyYW5zbWlzc2lvbiBnYXRlcw0KPiBhc3Nv
Y2lhdGVkIHdpdGggZWFjaCBfdHJhZmZpYyBjbGFzc18gYW5kIGEgbGlzdCBvZiBnYXRlIG9wZXJh
dGlvbnMgdGhhdCBjb250cm9sIHRoZQ0KPiBnYXRlczsgYW4gaW5kaXZpZHVhbCBTZXRHYXRlU3Rh
dGVzIG9wZXJhdGlvbiBoYXMgYSB0aW1lIGRlbGF5IHBhcmFtZXRlciB0aGF0DQo+IGluZGljYXRl
cyB0aGUgZGVsYXkgYWZ0ZXIgdGhlIGdhdGUgb3BlcmF0aW9uIGlzIGV4ZWN1dGVkIHVudGlsIHRo
ZSBuZXh0IG9wZXJhdGlvbg0KPiBpcyB0byBvY2N1ciwgYW5kIGEgR2F0ZVN0YXRlIHBhcmFtZXRl
ciB0aGF0IGRlZmluZXMgYSB2ZWN0b3Igb2YgdXAgdG8gZWlnaHQgc3RhdGUNCj4gdmFsdWVzIChv
cGVuIG9yDQo+IGNsb3NlZCkgdGhhdCBpcyB0byBiZSBhcHBsaWVkIHRvIGVhY2ggZ2F0ZSB3aGVu
IHRoZSBvcGVyYXRpb24gaXMgZXhlY3V0ZWQuIFRoZQ0KPiBnYXRlIG9wZXJhdGlvbnMgYWxsb3cg
YW55IGNvbWJpbmF0aW9uIG9mIG9wZW4vY2xvc2VkIHN0YXRlcyB0byBiZSBkZWZpbmVkLCBhbmQN
Cj4gdGhlIG1lY2hhbmlzbSBtYWtlcyBubyBhc3N1bXB0aW9ucyBhYm91dCB3aGljaCBfdHJhZmZp
YyBjbGFzc2VzXyBhcmUgYmVpbmcNCj4g4oCccHJvdGVjdGVk4oCdIGFuZCB3aGljaCBhcmUg4oCc
dW5wcm90ZWN0ZWTigJ07IGFueSBzdWNoIGFzc3VtcHRpb25zIGFyZSBsZWZ0IHRvIHRoZQ0KPiBk
ZXNpZ25lciBvZiB0aGUgc2VxdWVuY2Ugb2YgZ2F0ZSBvcGVyYXRpb25zLg0KPiANCj4gVGFibGUg
OC034oCUR2F0ZSBvcGVyYXRpb25zDQo+IFRoZSBHYXRlU3RhdGUgcGFyYW1ldGVyIGluZGljYXRl
cyBhIHZhbHVlLCBvcGVuIG9yIGNsb3NlZCwgZm9yIGVhY2ggb2YgdGhlDQo+IFBvcnTigJlzIF9x
dWV1ZXNfLg0KPiANCj4gLSBXaGF0IGhhcHBlbnMgd2l0aCB0aGUgImNsb2NraWQiIGFyZ3VtZW50
IG5vdyB0aGF0IGhhcmR3YXJlIG9mZmxvYWQgaXMNCj4gcG9zc2libGU/IERvIHdlIGFsbG93ICIv
ZGV2L3B0cDAiIHRvIGJlIHNwZWNpZmllZCBhcyBpbnB1dD8NCj4gQWN0dWFsbHkgdGhpcyBxdWVz
dGlvbiBpcyByZWxldmFudCB0byB5b3VyIHR4dGltZS1hc3Npc3QgbW9kZSBhcyB3ZWxsOg0KPiBk
b2Vzbid0IGl0IGFzc3VtZSB0aGF0IHRoZXJlIGlzIGFuIGltcGxpY2l0IHBoYzJzeXMgaW5zdGFu
Y2UgcnVubmluZyB0byBrZWVwIHRoZQ0KPiBzeXN0ZW0gdGltZSBpbiBzeW5jIHdpdGggdGhlIFBI
Qz8NCg0KVGhhdCdzIGEgdmVyeSBpbnRlcmVzdGluZyBxdWVzdGlvbi4gSSB0aGluaywgZm9yIG5v
dywgYWxsb3dpbmcgc3BlY2lmeWluZyAvZGV2L3B0cCogY2xvY2tzDQp3b24ndCB3b3JrICJhbHdh
eXMiOiBpZiB0aGUgZHJpdmVyIG9yIHNvbWV0aGluZyBuZWVkcyB0byBhZGQgYSB0aW1lciB0byBi
ZSBhYmxlIHRvIHJ1biANCnRoZSBzY2hlZHVsZSwgaXQgd29uJ3QgYmUgYWJsZSB0byB1c2UgL2Rl
di9wdHAqIGNsb2NrcyAoaHJ0aW1lcnMgYW5kIHB0cCBjbG9ja3MgZG9u4oCZdCBtaXgpLg0KQnV0
IGZvciAiZnVsbCIgb2ZmbG9hZHMsIGl0IHNob3VsZCB3b3JrLg0KDQpTbywgeW91IGFyZSByaWdo
dCwgdGFwcmlvIGFuZCB0eHRpbWUtYXNzaXN0ZWQgKGFuZCBFVEYpIHJlcXVpcmUgdGhlIHN5c3Rl
bSBjbG9jayBhbmQgcGhjIA0KY2xvY2sgdG8gYmUgc3luY2hyb25pemVkLCB2aWEgc29tZXRoaW5n
IGxpa2UgcGhjMnN5cy4NCg0KSG9wZSBJIGdvdCBhbGwgeW91ciBxdWVzdGlvbnMuDQoNCkNoZWVy
cywNCi0tDQpWaW5pY2l1cw0KDQo=
