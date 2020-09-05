Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611CC25E52C
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 04:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgIEC6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 22:58:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:1457 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbgIEC6X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 22:58:23 -0400
IronPort-SDR: yYDflsW3zL5cLzJb6JvfNMuNGc1r2SA5YRf4/n6erFPw6B3izg0V43UXCyD+QNjzx23rjdgApn
 UD8/MKEmyFpg==
X-IronPort-AV: E=McAfee;i="6000,8403,9734"; a="158821683"
X-IronPort-AV: E=Sophos;i="5.76,392,1592895600"; 
   d="scan'208";a="158821683"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 19:58:21 -0700
IronPort-SDR: FN2BRFTF6N0j6I2+jZ7b7wShiHB22UXTZeDzRVSUnToRv6ZKI4L6YmtkoCQw5yxFJWsFJrzCKb
 Zc45TyhxzYog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,392,1592895600"; 
   d="scan'208";a="503190723"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga006.fm.intel.com with ESMTP; 04 Sep 2020 19:58:21 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 4 Sep 2020 19:58:21 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 4 Sep 2020 19:58:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 4 Sep 2020 19:58:20 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 4 Sep 2020 19:58:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSsNXXo2q6YzoiXx6TUBlsGJinLGrku3fbsyo4MtiCInXp2BlMgyiXy+UYvBW1WzbcxhDeDci9zr6+AAcUr6tx2hEYfrEVijDJZsj26LrmwewjomkAOh70FH321nPgarvI1yxtVC0htlKjWlFkbSRQ+8s4znB1KySLl9eSG9r+5dLzXD/EwURPJ4kplmJbnisMIpgK1PeslbOdTSveMLd40AaTdTxkfIXuoet2RWFjY5RXNqFVLUa9BsvXzVX6p9fHmoJZjrhsi9+t2YpiT415BGEw3T1fKbBB8xzm0f/WTM0B1ZwhjGM/SrQIZqx3nHnJ3uO0xXexpjuWef2xbuzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVZMlZefqF57OGB/ha9KlQAygg1mJznEm9/PgOmggVw=;
 b=IZBDcDvrYZUM6MlcI0nFWMZhhHq/eIfMC5g6lPdSx3SV/QOsK5/hKfZ/wRFAsQJg5yrcbHoOZcVJSQAlPLBTg5x27LaONs5aR2LRgXl7rGijzOE3pIldFnKQXfwGgJ0JA/7J72YxoOylkCBpI7Z2OgJ5kE3GJnZUlLHp7Hq4gnV6ok8A/70v/1URtfqY8s34clkoo9S8rLXwv9/IJ7agZ4hshtYygd1rDI7cg0fmK0/+9IpDHIVVypsRiAqtnrFaiXjqjoRMmWN5DWb/Rrk14jF4a3g2wPjXilSZlwGC8YKsL+xpWhODENsVvvVnk/OeYa1nOpAzCaGRz5euI85TIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVZMlZefqF57OGB/ha9KlQAygg1mJznEm9/PgOmggVw=;
 b=DEGRaYf0SWQO0qevDfLwTNC/qPQvc/nwePykSSbdfkHHiNeEbaUP4ypW+l6nlcy6F3CzM36atZ8LUYU7hNhAUeGLPiz4FfNRy1uxi8eb8xmOVnq/5S4+H2d6zluIkWAGe7h4t6ZnlbGeN/ywKPj1aTt8MJz25CRbM0ibvJS9bo0=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM6PR11MB4563.namprd11.prod.outlook.com (2603:10b6:5:28e::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Sat, 5 Sep 2020 02:58:18 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::25c4:e65e:4d75:f45f]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::25c4:e65e:4d75:f45f%7]) with mapi id 15.20.3326.025; Sat, 5 Sep 2020
 02:58:18 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next v2 1/3] i40e, xsk: remove HW
 descriptor prefetch in AF_XDP path
Thread-Topic: [Intel-wired-lan] [PATCH net-next v2 1/3] i40e, xsk: remove HW
 descriptor prefetch in AF_XDP path
Thread-Index: AQHWetQGi+Dzpc36MkGK0b2Me0KlCqlZavGQ
Date:   Sat, 5 Sep 2020 02:58:18 +0000
Message-ID: <DM6PR11MB2890634F51624FE7FCE50A60BC2A0@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200825113556.18342-1-bjorn.topel@gmail.com>
 <20200825113556.18342-2-bjorn.topel@gmail.com>
In-Reply-To: <20200825113556.18342-2-bjorn.topel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.215.99]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6ce82b6-f08a-4117-6475-08d851478aaf
x-ms-traffictypediagnostic: DM6PR11MB4563:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB45635BEA7A69F00B957C453BBC2A0@DM6PR11MB4563.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UzE2lEDm0AbHJtoLRJyfyAI03e/AGUeIbXpAWJeD0VGqoWZPjFOtjMNoQ9D5T9/rbAI4MS8CYTR5URPDN1WYqY5TLIvaGkAoK1TRWw5H56mNcbynd5d1mEQ0WJCdI18DNoPxvBz540nkgQSqrpsOxNr408pnBlHwt71TnKXw/UfPh1doYVUhcvuwUhmOwzkv7unxK1/oDmzbqqlEHGCCw4uUN4QB6Q8aYWFHd7Ws+/S0B8iLlIPWpcXy89hMgAjj/ez0mcZvAtW1r7zlTOVMs+428Gd7GgG4/gUPneHEv1CSjoHx8LBiqoB+w8Pwy6XB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(39860400002)(346002)(26005)(53546011)(6506007)(2906002)(66556008)(66476007)(66946007)(64756008)(76116006)(71200400001)(66446008)(33656002)(83380400001)(186003)(7696005)(86362001)(316002)(5660300002)(110136005)(54906003)(4326008)(8676002)(52536014)(478600001)(8936002)(55016002)(4744005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 9MpcGzT7imosOnVxVAHwaj2tnIGgWGmsU3m4CzWDw1Zs4lvnZx81FKVGiTy/Zg80+4ZyDejSfssDSIq5ma8ci9A1N8fdMImwbsV1cXRvYaol9rwYe5Rtocg4C1YcB3YK1OZxYVBMuxn++FTR4oS5z0GP7VXXtV6secQ7a85qUStvDvspyaIrtmMYIphX3WglYyVHFnXFrX1HceSaK1grIpQk1aA34i5RWx/tG5arRxg7eBW0mV0N5r5wGYuK4aKwJwaDgKfggU8/LcglMc0N3/lJLjPDv+D1Ie5KpAsTy3qQqmkKkwI08QYlT+RKNrYlvotPEMfcky7b9Vmmxqj6awa/8xN5MguNiw65DxWiYQORDHj34fXYnSBfdjX6UTbqC1EscEMWpb2wpW70ai2WYXb1+/GwDCkJkYDnK1G63EQRHF+ADOXbGpjpNuaH2AX36QAW1+xbEaf6APykrg6EquNPVhd8lp7CxVrYmLF9VUUqqgHABLCBgV+7fjdJoOrHlOi1Y6OPOQjwj6ymguaP1ekeDOG2wAjaZt5tkJtmj+x78wGcqoKDdirX7Yaa2pkBVzZR7Uo9kha+VTNszAet86D+xrmzEcD06j7zl5nfbKIfAlLdR7L/zh0ANxezl5Xsx3NhQe0Z16/ooUoiob5oZw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2890.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6ce82b6-f08a-4117-6475-08d851478aaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2020 02:58:18.2194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kBrijS7i3HgSrdD+DOvLXKiNLTyI7Pi5OuHl3/VIQLfE/OFq/taOp+V8J4GwE721XyBPbvIPLYcpvqbR9o/dIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4563
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBJbnRlbC13aXJlZC1sYW4gPGludGVsLXdpcmVkLWxhbi1ib3VuY2VzQG9zdW9zbC5v
cmc+IE9uIEJlaGFsZiBPZg0KPiBCasO2cm4gVMO2cGVsDQo+IFNlbnQ6IFR1ZXNkYXksIEF1Z3Vz
dCAyNSwgMjAyMCA0OjM2IEFNDQo+IFRvOiBpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9y
Zw0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgYnBmQHZnZXIua2VybmVsLm9yZzsgVG9w
ZWwsIEJqb3JuDQo+IDxiam9ybi50b3BlbEBpbnRlbC5jb20+OyBLYXJsc3NvbiwgTWFnbnVzIDxt
YWdudXMua2FybHNzb25AaW50ZWwuY29tPjsNCj4ga3ViYUBrZXJuZWwub3JnDQo+IFN1YmplY3Q6
IFtJbnRlbC13aXJlZC1sYW5dIFtQQVRDSCBuZXQtbmV4dCB2MiAxLzNdIGk0MGUsIHhzazogcmVt
b3ZlIEhXDQo+IGRlc2NyaXB0b3IgcHJlZmV0Y2ggaW4gQUZfWERQIHBhdGgNCj4gDQo+IEZyb206
IEJqw7ZybiBUw7ZwZWwgPGJqb3JuLnRvcGVsQGludGVsLmNvbT4NCj4gDQo+IFRoZSBzb2Z0d2Fy
ZSBwcmVmZXRjaGluZyBvZiBIVyBkZXNjcmlwdG9ycyBoYXMgYSBuZWdhdGl2ZSBpbXBhY3Qgb24N
Cj4gdGhlIHBlcmZvcm1hbmNlLiBUaGVyZWZvcmUsIGl0IGlzIG5vdyByZW1vdmVkLg0KPiANCj4g
UGVyZm9ybWFuY2UgZm9yIHRoZSByeF9kcm9wIGJlbmNobWFyayBpbmNyZWFzZWQgd2l0aCAyJS4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IEJqw7ZybiBUw7ZwZWwgPGJqb3JuLnRvcGVsQGludGVsLmNv
bT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfdHhyeC5j
ICAgICAgICB8IDEzICsrKysrKysrKysrKysNCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2k0MGUvaTQwZV90eHJ4X2NvbW1vbi5oIHwgMTMgLS0tLS0tLS0tLS0tLQ0KPiAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX3hzay5jICAgICAgICAgfCAxMiArKysrKysrKysr
KysNCj4gIDMgZmlsZXMgY2hhbmdlZCwgMjUgaW5zZXJ0aW9ucygrKSwgMTMgZGVsZXRpb25zKC0p
DQo+IA0KVGVzdGVkLWJ5OiBBYXJvbiBCcm93biA8YWFyb24uZi5icm93bkBpbnRlbC5jb20+DQo=
