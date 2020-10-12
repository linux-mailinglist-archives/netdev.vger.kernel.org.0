Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB7028BD98
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 18:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403785AbgJLQ01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 12:26:27 -0400
Received: from mga06.intel.com ([134.134.136.31]:45566 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390257AbgJLQ01 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 12:26:27 -0400
IronPort-SDR: WrflFpsJ1SeqjFDz1+juu5jlbrGMSDCSVgvGK5lpqa4bvrvRUBRQwhrHlPlfm8hgPCShjjfuiw
 UvNHo4JrWjgw==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="227410404"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="227410404"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 09:26:20 -0700
IronPort-SDR: gKj5Erm961Gx5sT2SOmqTVd6D0b/AVCP0Ve2hsBB7DuIQK/FBaIbXV5So0MarLNdiD3/BXvCIW
 5j67whFxrKVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="530032236"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga005.jf.intel.com with ESMTP; 12 Oct 2020 09:26:18 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Oct 2020 09:26:17 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Oct 2020 09:26:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 12 Oct 2020 09:26:17 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 12 Oct 2020 09:26:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BrxoJC4eXKER54QMl+0eTYFPkI/MvaY6Ua8H4OXQVtY8iDjWzpMdIpZGKVUi44R02Wl2QgrTzjVX0K48XmsbnRzhVaRB4K1FKOQqU2UKYgdDcd7Vk9xOW5/PpaOSOIDosZEHwDOjdST/P0gZXDKUdRPCd9O+UVxLUs3jTQqD3dMcxpipsDSQfGxCTZUIFkAd5pZNPa/1IidHTa5jBhR+awdqEo7Suz3+3FxyADv7g1+9wrXeYNUrRApjP7M/r7B1J+tr8TclHiiCEmdg+9lVT59kp1/jMyuS0IiHAmi4pE/DAsd9J/+kbVumOp+Sm8nsNSSSuQaBgMDPskoic7GXpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNy8oTxxVjBM7DDpKCmoCbmwb0XRPL2IQsof+ElwzL8=;
 b=N+Ub6jMGGY7PQpvWKvl718EUE+cx7dc0+t0f/AAX3q6twoHqKnEhpWVdYoI/MRbw9+D+0kXg0+1m0jyt77Nl+rHL/8oV1c2MhrVNssEqA6J0D/OP3YMtLMocAdZZGGBUyr14rvaYEM4fMZEJkBIkK/E2LkL9UuOjJSHVetE/tnVFpOBRWpy7vm0tRDJgOAVaGHnap48yI72t5rczOiD9KtlM7KvFIOtLKUoBdj12kVER7q/UlKdLpKJv8p95vzqhfTPvsvYCa+nGFhwt6cWJZBGUj185Q85EQEW7Hqk9pJjHLHB66TlzL2OlZmxeh0BtUFjg5Mt+SfUSt06n8NsaCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNy8oTxxVjBM7DDpKCmoCbmwb0XRPL2IQsof+ElwzL8=;
 b=hMJOMBIojCfA5ZsrzI2SPIVGqG2bWAFr55lkONTU4Cyj8z34Zq8aFaz6utE4qh2tSnEcxgD1ZhyXBRiynw1R0H2zR735BGstdlu/SPn8fZLFJXODvzTidvqSoY5Ebn8rIs9Cjd4hMMFGBS0OyiR7u4cZOnzVTguNta1nuKwWcZ8=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB4843.namprd11.prod.outlook.com (2603:10b6:806:fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.30; Mon, 12 Oct
 2020 16:26:16 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acc4:9465:7e88:506e]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acc4:9465:7e88:506e%7]) with mapi id 15.20.3455.030; Mon, 12 Oct 2020
 16:26:16 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "brgl@bgdev.pl" <brgl@bgdev.pl>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yongxin.liu@windriver.com" <yongxin.liu@windriver.com>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>
Subject: Re: [Intel-wired-lan] [PATCH] net: ethernet: ixgbe: don't propagate
 -ENODEV from ixgbe_mii_bus_init()
Thread-Topic: [Intel-wired-lan] [PATCH] net: ethernet: ixgbe: don't propagate
 -ENODEV from ixgbe_mii_bus_init()
Thread-Index: AQHWlWeRtduI/tDeMEOwGLDiloiyZKmT+UYAgAAxQYCAABN5gA==
Date:   Mon, 12 Oct 2020 16:26:16 +0000
Message-ID: <ec4830bd7e15fc867725a867bf088077fdab2c09.camel@intel.com>
References: <20200928071744.18253-1-brgl@bgdev.pl>
         <CAMRc=MexKweGRjF5KNg1saz7NmE+tQq=03oR3wzoMsaTcm+CAA@mail.gmail.com>
         <20201012081633.7b501cde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201012081633.7b501cde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9fbce5e8-bc48-4003-5734-08d86ecb8b15
x-ms-traffictypediagnostic: SA2PR11MB4843:
x-microsoft-antispam-prvs: <SA2PR11MB4843438C79BBE653B656BBD6C6070@SA2PR11MB4843.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hoObZvwobU5FUkAq2JZIyjHU5sGMW8QQb2wyA/hAhqXd/pAdG5yYvShOPV2/ucA6Msb2khKTQ67rlgOvv+8PrPUPiYp9yS30JddbXntcjcWOJ8WrVjU86WQyWynq3HHGJX+TQmGPNN2wNAKb9Ys5NryMt5D2pDqZmja5eqq0miJiIXb6oW/qwmjh8MPhrmnJEmZwSKv83lsjnvA9ZYiNoOK7mm1cMlE+ptfghZDwjee0b7XRsGGNZopvA2/vZR4bXtYFe2nRlKZPPswe7UYEzqzkfwnbrt62sfeWBf/cLDLNwQp7/+gEWFVpfFqtunkYk7gvjuZBJvOExZEJFgKE1bZ93NLAyQX8A87Xsxwe2BbmoCepAehtWGeO7UDXXAyD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(66446008)(64756008)(71200400001)(66556008)(6512007)(91956017)(53546011)(26005)(6486002)(76116006)(6506007)(8936002)(86362001)(66946007)(8676002)(66476007)(316002)(4001150100001)(83380400001)(186003)(5660300002)(54906003)(478600001)(110136005)(4326008)(36756003)(2906002)(2616005)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 4r8k05On+OKCiSJlPyvuN8DskZIZP84xhlciAkw9/vH4yp1h8vy1h9t9/w6GldqLV4LWSyM66ajeuX/LlbWnzjear7x3DQvNQSGOoEVdsJM/QPHIIF9z39bJgsq64ZNrUHJbVuVct0TwRjHtqnVnUc45izQbRiEnjgJPpI0/d9TYnbltYp28QeegKQr0PD5jPv6fzIoNSBfXNX60I5LfL1y+SypLaxKsoPA8Ux4WWc7BLnW5LFjqPpaz1AR3veQVL2Bp+/L72rHwvZZsHja1G9J5tXYxclyfDwRlmqsVIxjy9gu6ryf55mfgKXVakekZKmZcGyLfVd6c8VigNokU4jRRtNyuOBeYe0bTUczobHHMgcce/djpbzYETwrQwUBlpyfwn+NjqsJO8wnViHHznT+1N0KWIrLSftBvznji9swb9sQY4WVwkTvGd2DqBLGSHaFnlkJ2XbVaY6cuStINPqzmVQOTmM8LAGiFJDT9mpseDSuQbtgf+5xkzuIEyLAwMKlfSk2PS8k3qdPdLV5TYyRnoBnigeEZzo360xVj070qAw1s8OHagqISb/VLnjeVHQ5PqKKBIHamTQj8BGslfVL3LfhWukodL96d4AqfPY9odlJewN4U9GmWpSCpucGUt8nltXjWCOUctIMVheIGNA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C877D15BF7CA04A9DC69D820CE43879@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fbce5e8-bc48-4003-5734-08d86ecb8b15
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2020 16:26:16.2214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g9sEeEAI6gLr/VaU2jZOzhVbnExCuzMhE1Dohkbya5xqnX+sR1mmQb5CJ2qAQHqOfpKLiBMiwJTMZz2yfXpQ4XC9NrKix+pv/6WnLCoP3aI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4843
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTEwLTEyIGF0IDA4OjE2IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLCAxMiBPY3QgMjAyMCAxNDoyMDoxNiArMDIwMCBCYXJ0b3N6IEdvbGFzemV3c2tp
IHdyb3RlOg0KPiA+IE9uIE1vbiwgU2VwIDI4LCAyMDIwIGF0IDk6MTcgQU0gQmFydG9zeiBHb2xh
c3pld3NraSA8YnJnbEBiZ2Rldi5wbD4NCj4gPiB3cm90ZToNCj4gPiA+IA0KPiA+ID4gRnJvbTog
QmFydG9zeiBHb2xhc3pld3NraSA8YmdvbGFzemV3c2tpQGJheWxpYnJlLmNvbT4NCj4gPiA+IA0K
PiA+ID4gSXQncyBhIHZhbGlkIHVzZS1jYXNlIGZvciBpeGdiZV9taWlfYnVzX2luaXQoKSB0byBy
ZXR1cm4gLUVOT0RFVg0KPiA+ID4gLSB3ZQ0KPiA+ID4gc3RpbGwgd2FudCB0byBmaW5hbGl6ZSB0
aGUgcmVnaXN0cmF0aW9uIG9mIHRoZSBpeGdiZSBkZXZpY2UuDQo+ID4gPiBDaGVjayB0aGUNCj4g
PiA+IGVycm9yIGNvZGUgYW5kIGRvbid0IGJhaWwgb3V0IGlmIGVyciA9PSAtRU5PREVWLg0KPiA+
ID4gDQo+ID4gPiBUaGlzIGZpeGVzIGFuIGlzc3VlIG9uIEMzMDAwIGZhbWlseSBvZiBTb0NzIHdo
ZXJlIGZvdXIgaXhnYmUNCj4gPiA+IGRldmljZXMNCj4gPiA+IHNoYXJlIGEgc2luZ2xlIE1ESU8g
YnVzIGFuZCBpeGdiZV9taWlfYnVzX2luaXQoKSByZXR1cm5zIC1FTk9ERVYNCj4gPiA+IGZvcg0K
PiA+ID4gdGhyZWUgb2YgdGhlbSBidXQgd2Ugc3RpbGwgd2FudCB0byByZWdpc3RlciB0aGVtLg0K
PiA+ID4gDQo+ID4gPiBGaXhlczogMDllZjE5M2ZlZjdlICgibmV0OiBldGhlcm5ldDogaXhnYmU6
IGNoZWNrIHRoZSByZXR1cm4NCj4gPiA+IHZhbHVlIG9mIGl4Z2JlX21paV9idXNfaW5pdCgpIikN
Cj4gPiA+IFJlcG9ydGVkLWJ5OiBZb25neGluIExpdSA8eW9uZ3hpbi5saXVAd2luZHJpdmVyLmNv
bT4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEJhcnRvc3ogR29sYXN6ZXdza2kgPGJnb2xhc3pld3Nr
aUBiYXlsaWJyZS5jb20+DQo+ID4gPiAtLS0NCj4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9p
bnRlbC9peGdiZS9peGdiZV9tYWluLmMgfCAyICstDQo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDEg
aW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZS9peGdiZV9tYWluLmMNCj4gPiA+IGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jDQo+ID4gPiBpbmRleCAy
ZjhhNGNmYzVmYTEuLmQxNjIzYWYzMDEyNSAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2JlX21haW4uYw0KPiA+ID4gKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jDQo+ID4gPiBAQCAtMTEwMzIsNyAr
MTEwMzIsNyBAQCBzdGF0aWMgaW50IGl4Z2JlX3Byb2JlKHN0cnVjdCBwY2lfZGV2DQo+ID4gPiAq
cGRldiwgY29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQgKmVudCkNCj4gPiA+ICAgICAgICAgICAg
ICAgICAgICAgICAgIHRydWUpOw0KPiA+ID4gDQo+ID4gPiAgICAgICAgIGVyciA9IGl4Z2JlX21p
aV9idXNfaW5pdChodyk7DQo+ID4gPiAtICAgICAgIGlmIChlcnIpDQo+ID4gPiArICAgICAgIGlm
IChlcnIgJiYgZXJyICE9IC1FTk9ERVYpDQo+ID4gPiAgICAgICAgICAgICAgICAgZ290byBlcnJf
bmV0ZGV2Ow0KPiA+ID4gDQo+ID4gPiAgICAgICAgIHJldHVybiAwOw0KPiA+IA0KPiA+IEdlbnRs
ZSBwaW5nIGZvciB0aGlzIHBhdGNoLiBXaG8ncyBwaWNraW5nIHVwIG5ldHdvcmtpbmcgcGF0Y2hl
cyBub3cNCj4gPiB0aGF0IERhdmlkIGlzIE9vTz8gU2hvdWxkIEkgQ2Mgc29tZW9uZSBlbHNlPw0K
PiANCj4gSW50ZWwgd2VudCB0aHJvdWdoIGEgbWFpbnRhaW5lciBjaGFuZ2Ugb2YgaXRzIG93biwg
YW5kIHRoZXkgdXN1YWxseQ0KPiBwaWNrIHVwIHRoZWlyIHBhdGNoZXMgYW5kIHNlbmQgYSBQUi4N
Cj4gDQo+IFRvbnksIGRvIHlvdSB3YW50IG1lIHRvIGFwcGx5IHRoaXMgZGlyZWN0bHk/DQoNCkhp
IEpha3ViLA0KDQpJIGNhbiB0YWtlIGl0LiBUaGF0IHdheSB3ZSBjYW4gZ2V0IHNvbWUgdGVzdGlu
ZyBkb25lIG9uIGl0Lg0KDQpUaGFua3MsDQpUb255DQo=
