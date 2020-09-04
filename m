Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF23B25DF79
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 18:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgIDQNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 12:13:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:20859 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbgIDQNR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 12:13:17 -0400
IronPort-SDR: x86rRHdIYvvnkB2/EWz0kLVe7NanQrJaIs/p7RuSZsNheUt189wr3fG/UGlgZcpAN0DZoZZZ8S
 wH5XUtbwU57Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9734"; a="155277262"
X-IronPort-AV: E=Sophos;i="5.76,390,1592895600"; 
   d="scan'208";a="155277262"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 09:13:15 -0700
IronPort-SDR: /9d1kKYYvZtbVLOmytsIbnjlm320SsmBMO5PRuKwo8oJiwX9jtJ2WabAu3Z4/G8EqasU1koTaw
 dobysyTpiSFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,390,1592895600"; 
   d="scan'208";a="315892740"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga002.jf.intel.com with ESMTP; 04 Sep 2020 09:13:14 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 4 Sep 2020 09:13:14 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 4 Sep 2020 09:13:14 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.57) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 4 Sep 2020 09:13:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrUxiQ4YKbzwfDYGrozYGgK0EWNzuyDGvS8Kf8wHaU5PfBJNh5yD8Iwv+wm7aj+plwCW6FXNA4c+pQJaaV5Y19d0V+e228qoW08KH8so8UK8tWuXsRYFEdTG4eZXTmD/1SxZMOVm6MkgzFklLU2H7vnDBf+uuppyweOVcIPiJyu2Z1W4FVsA53XkspWPkcJo1ovqwSTMri6WaZc5J7GnFkdZ6hDI4j8NglzmDSUPgt3nr/4tzmbN3WDen/HKipFAHcyDxes4W+EKHp/KuB4P+1kXPAc7iQIEq+/oscuzRSNW8jYnw5Qm1TarxMkNW/hcWhAh3Hzi/W/XiMgcjGEjBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HI7Qr4EupUQShpnZ5k2PxVCWY/w/djukOttBGqYSVc8=;
 b=EmrU99+prOdM6tDD9HBR7uvt4t499PNzZ3K9cd6Ol+uO2uiCRMyjRQdGjRZI/UlIv3ueMJkT6H0s1YrjMvyRZXkl30+uCuVOHUDSrQ+byZOR/QQnvAKdIT5Y3lvq9upoh8LPxsMPyIZweGuUverX70xRLke4/UjxdOh4F3Nl6h2SkVtIyJYHYOwbpVqf1XzT/VuFqNxreme7iHwyqzkPIMZvpySdh6TUi+K1h2/KLawwKt2T/oHI1dpMww7rFIxdfWwHnyD/dKBsC8AEBg6E6yQIFzZcAr5u1ZWtNOmVG18+0YzD2lB7cn9aCNLQmNSG8jlETkIHRZ596+lIXyOgmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HI7Qr4EupUQShpnZ5k2PxVCWY/w/djukOttBGqYSVc8=;
 b=A0FsnDv7BukBRJzkFmmbBfdcXYD1Qwtigo7CdqKKw5qDiQjNRYP0eoRFKquFTHwL1INmw8i1KHZbi7dgwHl0Y/t5X6B917SX4oRBQiC2ME7DQwYyZ2UaEFMZ5SZVG9UIi+n3dPue3Mh5GXIUdamcCkVGLpyuLm1m9RyAUku9le0=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB2670.namprd11.prod.outlook.com (2603:10b6:805:61::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Fri, 4 Sep
 2020 16:12:48 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7147:6b91:afe3:1579]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7147:6b91:afe3:1579%3]) with mapi id 15.20.3348.016; Fri, 4 Sep 2020
 16:12:48 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net-next v1 0/7] udp_tunnel: convert Intel drivers with
 shared tables
Thread-Topic: [PATCH net-next v1 0/7] udp_tunnel: convert Intel drivers with
 shared tables
Thread-Index: AQHWX8dIqfLMKTfuhkiHDJfcuSiXjqkUHOeAgAF8+QCAQji1AIABGlGA
Date:   Fri, 4 Sep 2020 16:12:48 +0000
Message-ID: <072865141ce38105a12f47051585dc8deca2b3e0.camel@intel.com>
References: <20200722012716.2814777-1-kuba@kernel.org>
         <1af4aea7869bdb9f3991536b6449521b214ed103.camel@intel.com>
         <bfa03cf8613ada508774a2e6e89b9b01bfd968dd.camel@intel.com>
         <20200903162220.061570d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200903162220.061570d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68552d88-8c16-4dc2-d070-08d850ed5ddc
x-ms-traffictypediagnostic: SN6PR11MB2670:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB267061224A7BF6A95FDA96DAC62D0@SN6PR11MB2670.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mpIhh5LCnh367sDX4I/rrnYhkkmyvFYfpQOy2IBvb3DLom48Y8+7PZmEbRGxeOVq12Yp+YJK9lEVW4KtQoIDEtRNIa8p0PUwIxJFYp2y/QQCYMK5Rpo1SvU8mcDMbbcM97QJTtGjNBRBQ9jhrEe1FcXCr0gmkVutAmxiu2/qtGq1BIyOi6TL3iJZKJi+Dc2x9RlDtV5+/HG6NlYJVXf0MFgpVBBrvHroFFed6v0xX4E0PNdGRPhc+ePI4Ik4KK19FMpKfMMA5m1XgmUPDAgxNTKiuHh3RXUb8GO0UFVPV+hx77+INmd3SiF1tS+pU4FK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(8676002)(5660300002)(54906003)(186003)(316002)(8936002)(6486002)(478600001)(6916009)(36756003)(71200400001)(83380400001)(4326008)(6512007)(2906002)(66476007)(66946007)(76116006)(2616005)(66556008)(86362001)(66446008)(64756008)(91956017)(6506007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: aO8i3NM64gBtbB1hnnx1jfimqfiia5Gh2tp6oeG9UCvqIkzEcbDN4wSZIL8dF4OlPTOJSJqWgUr/G1BK+JvY+sE+kkfgZT6uRaWR2VsGYPPfwfkhYiAE/QSxav/RJ21IKbw+w9Xj4ALMf+RSop30BkzOq8kX9umZc+xHTZIRzm8zdeEFz/fSOwd/ZlR7SJZOGWtvS48e1QWTFMQ8WHc5W1fMYMAmi+e7zx5v2p2b8R13tdHvTy/7Gq2VDufJMKzO5wAPph0sHEg3HkkeShmnAF5BQ3os/FRN7POXaWSArgbJr8Xkm1iikg15NJvDErkQnT7/dPRVKKSfndzZ+6hBFIlcmKdoeIxH4ApoJ9BIrhWELtaDBqeXUfZakZZZtOg7t9/rO0V7uUBmFJzB09PNFKIFpd7kbXRJoAVL7nYLLoFobKF11j2fBIG5egjgMrso+JIm91mtWLZzXhkbNeEgVhP4qlCY+ShPGVlCQYzfkr63fgG1mSpwsaCOlQXD4+yP5wUG7Rg1JPsTILKqD/Nmv4EM6G6rqhmsghFlVQ4FMsZyCzQphZdUgK9w784N+a7wqTTRwhALZIgd88cCpBsghLMsHcwd41uTBQ+uy14WmBLTKsjUwqPsePldkDsQllRh9qQpTn/cMIlnf5Lp6m9xSQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <5465B1625216164C94C15E8B808448D9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68552d88-8c16-4dc2-d070-08d850ed5ddc
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2020 16:12:48.4029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j0Hh73HzjL0KkdRSR4DXCzc5+abikcxnRVkJl0LPIJfBlWQHYBXlYicXv5mvHmZfjeoC5dgfuP6NzSxIAJdUHv43Ma4kmjZbVfHW3lP2MQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2670
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA5LTAzIGF0IDE2OjIyIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAyMyBKdWwgMjAyMCAyMDowNjoxNSArMDAwMCBOZ3V5ZW4sIEFudGhvbnkgTCB3
cm90ZToNCj4gPiBPbiBXZWQsIDIwMjAtMDctMjIgYXQgMTQ6MjIgLTA3MDAsIFRvbnkgTmd1eWVu
IHdyb3RlOg0KPiA+ID4gT24gVHVlLCAyMDIwLTA3LTIxIGF0IDE4OjI3IC0wNzAwLCBKYWt1YiBL
aWNpbnNraSB3cm90ZTogIA0KPiA+ID4gPiBUaGlzIHNldCBjb252ZXJ0cyBJbnRlbCBkcml2ZXJz
IHdoaWNoIGhhdmUgdGhlIGFiaWxpdHkgdG8gc3Bhd24NCj4gPiA+ID4gbXVsdGlwbGUgbmV0ZGV2
cywgYnV0IGhhdmUgb25seSBvbmUgVURQIHR1bm5lbCBwb3J0IHRhYmxlLg0KPiA+ID4gPiANCj4g
PiA+ID4gQXBwcm9wcmlhdGUgc3VwcG9ydCBpcyBhZGRlZCB0byB0aGUgY29yZSBpbmZyYSBpbiBw
YXRjaCAxLA0KPiA+ID4gPiBmb2xsb3dlZCBieSBuZXRkZXZzaW0gc3VwcG9ydCBhbmQgYSBzZWxm
dGVzdC4NCj4gPiA+ID4gDQo+ID4gPiA+IFRoZSB0YWJsZSBzaGFyaW5nIHdvcmtzIGJ5IGNvcmUg
YXR0YWNoaW5nIHRoZSBzYW1lIHRhYmxlDQo+ID4gPiA+IHN0cnVjdHVyZSB0byBhbGwgZGV2aWNl
cyBzaGFyaW5nIHRoZSB0YWJsZS4gVGhpcyBtZWFucyB0aGUNCj4gPiA+ID4gcmVmZXJlbmNlIGNv
dW50IGhhcyB0byBhY2NvbW1vZGF0ZSBwb3RlbnRpYWxseSBsYXJnZSB2YWx1ZXMuDQo+ID4gPiA+
IA0KPiA+ID4gPiBPbmNlIGNvcmUgaXMgcmVhZHkgaTQwZSBhbmQgaWNlIGFyZSBjb252ZXJ0ZWQu
IFRoZXNlIGFyZQ0KPiA+ID4gPiBjb21wbGV4IGRyaXZlcnMsIGFuZCBJIGRvbid0IGhhdmUgSFcg
dG8gdGVzdCBzbyBwbGVhc2UNCj4gPiA+ID4gcmV2aWV3Li4gIA0KPiA+ID4gDQo+ID4gPiBJJ20g
cmVxdWVzdGluZyBvdXIgZGV2ZWxvcGVycyB0byB0YWtlIGEgbG9vayBvdmVyIGFuZCB2YWxpZGF0
aW9uDQo+ID4gPiB0bw0KPiA+ID4gdGVzdCB0aGUgaWNlIGFuZCBpNDBlIHBhdGNoZXMuIEkgd2ls
bCByZXBvcnQgYmFjayB3aGVuIEkgZ2V0DQo+ID4gPiByZXN1bHRzLiAgDQo+ID4gDQo+ID4gV291
bGQgeW91IG1pbmQgaWYgSSBwaWNrIHRoZXNlIHBhdGNoZXMgdXAgaW50byBKZWZmJ3MgdHJlZT8g
SXQgd2lsbA0KPiA+IG1ha2UgaXQgZWFzaWVyIHRvIHRlc3QgdGhhdCB3YXkuDQo+IA0KPiBJdCdz
IGJlZW4gYSBtb250aC4gQW55IEVUQSBvbiB0aGVzZT8NCg0KU29ycnkgZm9yIHRha2luZyBzbyBs
b25nLiBMZXQgbWUgY2hlY2sgb24gdGhlIHN0YXR1cyBhbmQgZ2V0IGJhY2sgdG8NCnlvdS4NCg0K
VGhhbmtzLA0KVG9ueQ0K
