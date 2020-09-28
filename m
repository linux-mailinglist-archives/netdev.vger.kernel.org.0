Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A1727B1C1
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 18:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgI1QYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 12:24:02 -0400
Received: from mga07.intel.com ([134.134.136.100]:26412 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgI1QYC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 12:24:02 -0400
IronPort-SDR: RFZbZbgiF3sTYJg1qIgl7/52IRj5a39pxMWngSOk5APua+5OBGI/QN4DxHnq734pUu2+RroxRd
 q/ye8z2h4aow==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="226169886"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="226169886"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 09:23:59 -0700
IronPort-SDR: apMngVCKeRo1eJ6y2LYngDdnVuPPMyQ0RuumSM9lPRrRDjhP0IcuhWoxR++V7c4+YyDJMoNEZ8
 sorrchqKC53g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="350781235"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 28 Sep 2020 09:23:59 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 28 Sep 2020 09:23:58 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 28 Sep 2020 09:23:58 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 28 Sep 2020 09:23:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/XhqqVPuc4zwXxZ27Ke4m72teu8ivm72E1WJaOCNjEE35/+zwUk6b2Yr76jNlCw8EyDjwISxDPsOsDm1t2Lx+GQYW7AGlZXVW6YHuf7dw6+NdSbEydU6sEEIchsOIpt3/A+GQ8KT8Euafv4m1rUf7e83Gr0NDmF/j6bX0BBnphKLdSIOw3488bBjeqLxik4W9cTrhJmJ87RHJg+Ek0jjzJevzKi5G6QhWjGfxBjVRV4SjGi5s7SeyAm7rnm9+o3IIhaI02qSitBpapEdI2B7j5vum9+znya7NF6ZnKY1RfYpyv27RY40IxlOYKpa/htH0L81S7+/jBFCh8XqT+i7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwvJt2be8/NagoJmFB5ffEiiowx5lLzZEy9L78FXzgQ=;
 b=b+Y+dU7V6tgWNxeFmQO46Oq0R7xO+8ChI3blb299B21CvmlAGoyO8//ECVv6I0+fxcpK5ebN020Io48u6xnEWm8FHbjYIscRW9SJjBBUWUS/cCp1xatcPQKKPlCnGiLvnc7LwJg9alvIrfeBbym2kJfRS5T9tMrF3U9RJTiONuLIBbahdgCijwg02hFogzAbS7hAkl0t60/FMKR+vHRUsKPH53oGYICQruPVoq08DebNw2jO0lwNKW9YM+HLba5aZ09j0evnO0zEfRtNRgBEAvozfcmiQOKFdjB+8x8bimaZvx1rLxqMbu+nHjsQ11SYRLHDZWUbB1d73z0eO7hfZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TwvJt2be8/NagoJmFB5ffEiiowx5lLzZEy9L78FXzgQ=;
 b=N+fYYOlRFeGksPDG0pDRT1LYWN1YkIUruZFeVC1jFL2velQDBmCgRq77HQ8VnrkbvLMc77pUYKo/yYLpaQ206i5Yn1XvOXiE8B2qv3hzhUalcvPvV3maEWl4jHtKE+XfCHtzdHMyEm6ykri0nom5unlCV1mP9yRXp0BeyC8aMTY=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA0PR11MB4558.namprd11.prod.outlook.com (2603:10b6:806:9e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Mon, 28 Sep
 2020 16:23:54 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acc4:9465:7e88:506e]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acc4:9465:7e88:506e%7]) with mapi id 15.20.3412.026; Mon, 28 Sep 2020
 16:23:54 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 00/10] udp_tunnel: convert Intel drivers with
 shared tables
Thread-Topic: [PATCH net-next v2 00/10] udp_tunnel: convert Intel drivers with
 shared tables
Thread-Index: AQHWk5/zdYFc5q2+80OcibtpwuEjB6l+QEKA
Date:   Mon, 28 Sep 2020 16:23:54 +0000
Message-ID: <b7faced6b7152e307789359c3a76bfd8d4a679ec.camel@intel.com>
References: <20200926005649.3285089-1-kuba@kernel.org>
In-Reply-To: <20200926005649.3285089-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5e07901-e5e9-440b-4509-08d863cae4f7
x-ms-traffictypediagnostic: SA0PR11MB4558:
x-microsoft-antispam-prvs: <SA0PR11MB455865074E31978337E3AD90C6350@SA0PR11MB4558.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vupzm/tU0LSEchnYnjakyPe4ugZ8F92NMF0FPFJMZGihYv2wCUbbtv4XZtn9XobrjBJh2lGc69et0bmXU0R0dIC712gXKG8DXWBMzSt4K71+c9vIKY7GhxSNmb9IjXFCXVG4WVhbQJUbjJ4WtSFDz8+wmUFu4F0TNGMi5JPtxb43FjT3G1Sk4yEQbr9MsWR/77gOqQgCcCyHZGSe/rQyf14uvvFI64p/sTjGwfvufspD1PufditQZb7v277aZgwgKsjjw4GwI8qysN/tzdN5fMICZM/xt28myFUZzJ3o6URfN451upY5Byc33wedFgx2uCDoQeDO7i3Xlb0r5hMiZ3VgV7tUfQhrNy/MAf1c4/emcQ+sE+VBwdFe0XBNs8xR6kpWC9FZNV4S363lB4LsC3Uw8CFHgObWOBY2fpOY5oM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(316002)(66446008)(66556008)(64756008)(8676002)(2616005)(66476007)(6486002)(6506007)(186003)(5660300002)(4744005)(76116006)(91956017)(71200400001)(26005)(110136005)(8936002)(86362001)(478600001)(83380400001)(2906002)(4326008)(66946007)(36756003)(6512007)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: t2u5wOrtkqulGx/NyilksNB2hcInh1tb8412YPNitXU25CefHZdtJ6ZDHmWA7jKlN03vHG3U4ReH0aSXMUf802IYhuNImnki2C6ONlCgTJckHbA6ZXqeXHCDc44MA5c6xP3PHOaLKNrYhhQsuh0LGiAzOx7B45JXtVPZFZ28yzCqQe69hJhC5YnPYwdv+xCFPAGe4l1MVsWPi6Ls7d2/0QtRK2Hze6twFDiEJLl5C7HktLonDdEfzmjLkfSgKvhGKsRJ0Ruqf6/8jKKTK7K2bKQeW2xFkRmXuIDEwqGQkzxtPC8TgOoEbSI3bIFYkf7V46LeVSXarCvOgEP8NLCfahP4ktiHn0Zcl7CSHyKiWnPKKNK78XhJCBxStiVNOJNGtDMUItRJdc4rg6jhjG9BM12lEMYumnZSiCuGpM3oIpLgTODz5dv773HMSAfspBW9x/ff8jh4deKSijCGyxswZvTQ8/T+SBR9RUZzRU0f5LrQpq0S8DQkQpPQtXTmpmz9mgkKygx5D7SLwvtDSnzOLeKf+sdb1IG8hDY02kd3bDF9K//znFO0Cmrvm0mwp/NGf7YCJtugxGjM2SDDJvfolXJrf2qx7UW0zlDx4DO59/AnodOVD1cV36UC/qZ0lEBSNhDemz2eERBO74/Ds3YvLA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <2295ADFE1B222D4A8E5D4E8AC2A9EA58@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5e07901-e5e9-440b-4509-08d863cae4f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2020 16:23:54.6860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J+/0RwXywNMglPojntxWNvPlYvsWLNwAuom8vv0IbJcaVfseYlxj2h8DXeZfqaYnYYzM29YnoAeB8/iyQZ0iIc8MaLG5J4cHL04XjrD84M0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4558
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA5LTI1IGF0IDE3OjU2IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gVGhpcyBzZXQgY29udmVydHMgSW50ZWwgZHJpdmVycyB3aGljaCBoYXZlIHRoZSBhYmlsaXR5
IHRvIHNwYXduDQo+IG11bHRpcGxlIG5ldGRldnMsIGJ1dCBoYXZlIG9ubHkgb25lIFVEUCB0dW5u
ZWwgcG9ydCB0YWJsZS4NCj4gDQo+IEFwcHJvcHJpYXRlIHN1cHBvcnQgaXMgYWRkZWQgdG8gdGhl
IGNvcmUgaW5mcmEgaW4gcGF0Y2ggMSwNCj4gZm9sbG93ZWQgYnkgbmV0ZGV2c2ltIHN1cHBvcnQg
YW5kIGEgc2VsZnRlc3QuDQo+IA0KPiBUaGUgdGFibGUgc2hhcmluZyB3b3JrcyBieSBjb3JlIGF0
dGFjaGluZyB0aGUgc2FtZSB0YWJsZQ0KPiBzdHJ1Y3R1cmUgdG8gYWxsIGRldmljZXMgc2hhcmlu
ZyB0aGUgdGFibGUuIFRoaXMgbWVhbnMgdGhlDQo+IHJlZmVyZW5jZSBjb3VudCBoYXMgdG8gYWNj
b21tb2RhdGUgcG90ZW50aWFsbHkgbGFyZ2UgdmFsdWVzLg0KPiANCj4gT25jZSBjb3JlIGlzIHJl
YWR5IGk0MGUgYW5kIGljZSBhcmUgY29udmVydGVkLiBUaGVzZSBhcmUNCj4gY29tcGxleCBkcml2
ZXJzLCBidXQgd2UgZ290IGEgdGVzdGVkLWJ5IGZyb20gQWFyb24sIHNvIHdlDQo+IHNob3VsZCBi
ZSBnb29kIDopDQo+IA0KSGkgRGF2ZSwNCg0KU2luY2Ugd2UndmUgZmluaXNoZWQgb3VyIHRlc3Rp
bmcgYW5kIHJldmlld3MsIGRvIHlvdSB3YW50IHRvIHB1bGwgdGhpcw0Kc2VyaWVzIG9yIHdvdWxk
IHlvdSBsaWtlIG1lIHRvIHJlLXNlbmQgaXQgYXMgYSBwdWxsIHJlcXVlc3Qgbm93IHRoYXQNCnRo
ZSBlbWFpbCBpc3N1ZSBpcyBmaXhlZD8NCg0KVGhhbmtzLA0KVG9ueQ0K
