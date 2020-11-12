Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2602B0DBB
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgKLTSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:18:46 -0500
Received: from mga03.intel.com ([134.134.136.65]:5728 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgKLTSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 14:18:46 -0500
IronPort-SDR: D6vdWf59TFEabbudDQJZjXqZPkwATnkpKby1Fxc4u+P3ryAWqDJvPRtJjP3fJRzipBqOE4Vrk4
 FGLCcl+2leZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9803"; a="170472654"
X-IronPort-AV: E=Sophos;i="5.77,472,1596524400"; 
   d="scan'208";a="170472654"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2020 11:18:44 -0800
IronPort-SDR: vDp/Twyx+ktnE6UQcJEZ67kKo4Snz6rwXeaK5rtCWY1dSQEJ82PXC0AyptG8tmE+sO8KCuHgAw
 c4qnQGwV80Dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,472,1596524400"; 
   d="scan'208";a="530787364"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga006.fm.intel.com with ESMTP; 12 Nov 2020 11:18:43 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 12 Nov 2020 11:18:43 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 12 Nov 2020 11:18:43 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 12 Nov 2020 11:18:43 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 12 Nov 2020 11:18:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FmlwrgooDrNEN5Ul+c0Gj3gdC4u5bHZmxSvK+r7/iT/4ky+szq/YuVUOjscwkqFIkfFtmCT2negvX9c+JhgNN/QczsRMKyymJ0V+uaIoAZhEbLydRkApO+aneHwDxV9d4VbFtocNMma/L4oOB1alqkSE056C7/mlKKgM3wZB9vQyMtsCwUntz2wyKqOXEVtzZerrkCP76najSMQSQuPBzEcelNcS9seqltdk1qgl7v3o51iv0x5hBMd57nIOgqJ5yn0Yx1Cz6+YS3convyS7PM3X9efhPbh0vqP0vlSIlbAn0IPF0DT68KVj9E5gMWzOkgSTysRNZ3Xz9joiIWpY+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hWVQHOIoxxHA7bT+9CnEpssQsp2Wmz+RcDT23sqslRY=;
 b=iQE4qaS4Yv9+KajWeVRT3bm/QlB/tivxzeUoVtev1CDQOAbRuj22QKWEfftGAOJWhRg1DFqDfHN98sFTaZ6sNzITY6kvTsuBwySbuYfrz6rUuNmODM19v1cMbSZrBRmiuwiwW4UNZavppx16fvme+I0dsyAJuPrZvLh5K8A5gWh+fyV5m3iCd40EnaxIuQQeafx9xJDb8RHiG8PhSPvi9K4hcR/5OVhBu9kVdMFy3oSqZ/zWqE8zWkXt5E0Sy7a8FJNY4xYp6xPTk/eQST4EaVECzlUctV2hv1pzIG53ZLB53yrUam+J2ZqimVP6CTVAkBVqao3nzhuVXKe+0se9ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hWVQHOIoxxHA7bT+9CnEpssQsp2Wmz+RcDT23sqslRY=;
 b=JR8g8TO+H3cEtLCq3A0/eRWN8NvM4/wHq2lkyj322tf/6bRnrruZDxPcQmpj7OatfILwo1zC6CAMhPvDF4yFEWulLI0XgqT2yzxc0/rf8ilmbsOaJ1W3yWmvit3LHPlNBAHLKRIKC33skN3qWUwMvG34M3jSw/1A9jJt+SI+oUg=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB2670.namprd11.prod.outlook.com (2603:10b6:805:61::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.22; Thu, 12 Nov
 2020 19:18:40 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::c5ab:6fa3:709e:c335]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::c5ab:6fa3:709e:c335%6]) with mapi id 15.20.3541.025; Thu, 12 Nov 2020
 19:18:40 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: Re: [net 0/4][pull request] Intel Wired LAN Driver Updates 2020-11-10
Thread-Topic: [net 0/4][pull request] Intel Wired LAN Driver Updates
 2020-11-10
Thread-Index: AQHWt8CCs5/7yfTgpke+kX+WNfPxc6nEucOAgAAn/IA=
Date:   Thu, 12 Nov 2020 19:18:40 +0000
Message-ID: <fa507a687f5f843bc54b76a3931f9190dc473ec6.camel@intel.com>
References: <20201111001955.533210-1-anthony.l.nguyen@intel.com>
         <20201112085533.0d8c55d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112085533.0d8c55d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0e21f86-aac0-4e88-fac9-08d8873fc3a1
x-ms-traffictypediagnostic: SN6PR11MB2670:
x-microsoft-antispam-prvs: <SN6PR11MB267071329EA4D366BB21E76DC6E70@SN6PR11MB2670.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C92Pmyio/MZ75FI+ZAD1syROkijOrLK+pUWedyj1u8aqZtQvcfUR5rD/prASXyLrkMOKdeb/W5Mtnfl0dHrgc6Ysd+Y0PYsEFfE5nTLmK8wBz3eMlTOtBNbBMRoKVfAe/1pP4rIYTEOyYMMyp8mJU5LDiVsdNqDJjaWGOm5fm2p/JsK/mZhQ/wO3vtq6zKY2bHfv3MWHoFfDU8Wz3JzwEvibVQd7SOr8eJBMe35aWIsh/j6rSE2UQLXB82s/uWItmwFRc3LG+mOXV6J3NBPrbm+WJZ9x5JzmxQloboN5UrxdGCFoacnkg40rYTpTy0IcOtUMYdWPfbl6Y0BAJnwoKFMMWiIz5k/2SSAVAPmviFzjqZVGu5TeGoACl35uhWXw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(366004)(346002)(66476007)(76116006)(66556008)(4326008)(83380400001)(66446008)(6916009)(2906002)(8936002)(8676002)(15650500001)(86362001)(36756003)(6506007)(4001150100001)(6486002)(91956017)(64756008)(478600001)(71200400001)(5660300002)(316002)(4744005)(2616005)(26005)(6512007)(186003)(66946007)(54906003)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Bf43YiNRn9lHrSX+/3dx2p1rx/P+cZ5pGNiTV57unyc6DgG5vOPsxebPhF/4qjR7DWmGeQXcgHhQaKqT0uZoAlt/eR3LBV/kQUZfsGc0YrTfUp4HWN2h61ZIoGlxntrPz7VGXghE2Vep1WJxYD7LMmmM1e4B7Szl2+1PNDetpzruSOyzyfbPp3fN/Qxi5Mtjn0Y7sqStfe8xUK+DhEgKef8SjMsqjCx2HBK+HXozzfNbi8iwzX+gXkmTwDJiL2dSD2fkJCF2bQqBkpxTspssa0ymR0bh8VzaAr3DHF+PFiq4o41SVEiIUMVH7QNi7AkvSPX00gCMJpRc2Sk2d7wQC85n/rpWYTji+Q0985vgWnlv4d2s1JiJcWZQmfb81JZ3Y2rUI5QPYrqXOEbWSS/doPU5dpPCBXcs1Xd81Q6pzk3rtNYHFniMZg/dxc0zziW502u9tqbwppYLeA8gSOodiTxY5TsAAIZLSP8BJ0SBWTTf1GygAHMevyI6nySnAfh90gffsGpUQtxugkz8ItH4JaU4X0M9Uzwlj+AwaWcpfYLGbTefT175D/+enw39FyqyzjtNXUqHfeRa8sBTmPDr/jJDCIwxt7gRTxz8WdfQDHLEZl0lfyi9TtRTUSdEHtp4bdQB76V0p6ZoL5nW7ow0hTrP4UPW+rr3fKESbJ35JalLikPsH7j2GhnkaVkwq1Bq416qrf+ekSqAm65TzZ0j2g6jj6rzirGWLmZX2vDMHw7a/uqAAT6Z3TZW6pz33AZt7kPimX6myhlGKB18/gJ+3dN0t3KL4HZFQnVwkpN3NIcrBgtUfqKtmcI5BcBrLvqYZ4U0ojWOctzc1v6NI8v7R4jen1g8SFnSlI+gWLczFYU/UxIh0KU4kd8WUjOFnaYVnUTmKd73F16H8sC+OwrBAg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <09F5B81643AC084E846B4B28DCE68D42@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0e21f86-aac0-4e88-fac9-08d8873fc3a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2020 19:18:40.7287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SN7zduitR7P6ORZeoUp6+APygAjWHvDmLfHL7aS0+8Y18cDwJU6oEoyl2O5+qc/2/gP9fW3l/7gAo+pNSsij5ABip57VmQfR2PAYQORVY8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2670
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTExLTEyIGF0IDA4OjU1IC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAxMCBOb3YgMjAyMCAxNjoxOTo1MSAtMDgwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiBUaGlzIHNlcmllcyBjb250YWlucyB1cGRhdGVzIHRvIGk0MGUgYW5kIGlnYyBkcml2ZXJz
IGFuZCB0aGUNCj4gPiBNQUlOVEFJTkVSUw0KPiA+IGZpbGUuDQo+ID4gDQo+ID4gU2xhd29taXIg
Zml4ZXMgdXBkYXRpbmcgVkYgTUFDIGFkZHJlc3NlcyB0byBmaXggdmFyaW91cyBpc3N1ZXMNCj4g
PiByZWxhdGVkDQo+ID4gdG8gcmVwb3J0aW5nIGFuZCBzZXR0aW5nIG9mIHRoZXNlIGFkZHJlc3Nl
cyBmb3IgaTQwZS4NCj4gPiANCj4gPiBEYW4gQ2FycGVudGVyIGZpeGVzIGEgcG9zc2libGUgdXNl
ZCBiZWZvcmUgYmVpbmcgaW5pdGlhbGl6ZWQgaXNzdWUNCj4gPiBmb3INCj4gPiBpNDBlLg0KPiA+
IA0KPiA+IFZpbmljaXVzIGZpeGVzIHJlcG9ydGluZyBvZiBuZXRkZXYgc3RhdHMgZm9yIGlnYy4N
Cj4gPiANCj4gPiBUb255IHVwZGF0ZXMgcmVwb3NpdG9yaWVzIGZvciBJbnRlbCBFdGhlcm5ldCBE
cml2ZXJzLg0KPiANCj4gUHVsbGVkLCB0aGFua3MhDQo+IA0KPiBQbGVhc2UgZG91YmxlIGNoZWNr
IHRoZSB1c2Ugb2YgdGhlIHNwaW4gbG9jayBpbiBwYXRjaCAzLiBTdGF0cyBhcmUNCj4gdXBkYXRl
ZCBpbiBhbiBhdG9taWMgY29udGV4dCB3aGVuIHJlYWQgZnJvbSAvcHJvYywgeW91IHByb2JhYmx5
IG5lZWQgDQo+IHRvIGNvbnZlcnQgdGhhdCBzcGluIGxvY2sgdG8gX2JoLg0KDQpUaGFua3MgSmFr
dWIuIEknbGwgbG9vayBpbnRvIGl0Lg0K
