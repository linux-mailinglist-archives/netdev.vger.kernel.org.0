Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0321E277CCC
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgIYAWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:22:49 -0400
Received: from mga07.intel.com ([134.134.136.100]:43964 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbgIYAWs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 20:22:48 -0400
IronPort-SDR: p82cw66Rg41EvbuyqXUYhWjDZS+ZuAWAa3es7c+EXI9abr/FtEjel9/W//RPUF+tFzO7/XxQCp
 zFznqKOtf4CA==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="225528628"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="225528628"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 17:22:47 -0700
IronPort-SDR: jipSuPYpSX/5lDIoEDmKykpSOGck4L2WjmCQUNOOkaMyngs9XhEjxgvczgFfiRqSznAk8sQm/D
 iFkTlNHMa5Wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="487201429"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga005.jf.intel.com with ESMTP; 24 Sep 2020 17:22:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 24 Sep 2020 17:22:22 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 24 Sep 2020 17:22:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 24 Sep 2020 17:22:21 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 24 Sep 2020 17:22:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOxXzcoSOWotTeLKUfgV6lEcX78gV7p04VFVGgFAZtm7f71KB1YU49EW3iSaWFqpCYKis7BFMt9FI17oaXp+YlDz7Yt4YpbhCM8IBHW33cnNBRR3HRKIJh9HhPj1zq7IiKnO+DPVO1cYtqTkbMyuRhLj41sgOyiYrXrRb0ZVxil6mHzaQlLveHn/H1BckADP5z+sy20h4Y1m2djVgZOFY4YFz5s2VW7tMv3XKcF8aELvXuqPXtEfAQMlFNYnPp91ISqUO1si/1iWNwI5ktGhMhvmuaIcil9ZyANZ+QkbSH5c+PF3hS5VWEJBx+q0CCkyJRbEe0e8c7cxI0HtuSMHEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEEajrS2Qv58qpbeaGWgnSsUWrbv5ywldJKq0iPW1W4=;
 b=CCiLyY6KVV+rGoT3YDGaKta1jSg45OgyNGbicT2l+lp8VwnL2A2azRb5xbviGVK9i/pQWJ/yqNIdgmGJ81CQuMkF1YdWVEh09fcQQ5p5JrKbvuOTRSxK8/WCzdpFL8s4pJF0kAFQKpbdeUzbQ3/GCin9QSVpH6SMwbahA31Lwq/FJ1UH8NR1HseoDb34rff7j1/BZ7aALBt174utNl0CuCqC+SCqueVIYWnFthTRFjxJ4GgenojDgwFVafruUGY6V0AMrXsXP+YLFvYRN8VAoXyKdKbTwv0HAd6TR7eJS/mXXAci2xk4C2Vz0nysJkInmQphiutJ/pKkFwLla9BWFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEEajrS2Qv58qpbeaGWgnSsUWrbv5ywldJKq0iPW1W4=;
 b=xCPYU7PGKv6JfQW9LYjViY0kHO54bFt/utjZ2bk/GaWsZBY5/HbwkwsnInLKFpcGlkHo6yZIagK91v7ERU5CiMglMqW21RWX5HTI4gcXd4c6pjLTus0zj6TXVdF0OZPHRJdihmCIxFIVwQz8rWCr60yjWdsLshvND72L6wvQz+0=
Received: from BY5PR11MB4354.namprd11.prod.outlook.com (2603:10b6:a03:1cb::16)
 by BY5PR11MB4308.namprd11.prod.outlook.com (2603:10b6:a03:1b9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Fri, 25 Sep
 2020 00:22:19 +0000
Received: from BY5PR11MB4354.namprd11.prod.outlook.com
 ([fe80::931:156e:279:d286]) by BY5PR11MB4354.namprd11.prod.outlook.com
 ([fe80::931:156e:279:d286%6]) with mapi id 15.20.3391.025; Fri, 25 Sep 2020
 00:22:19 +0000
From:   "Pujari, Bimmy" <bimmy.pujari@intel.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>,
        =?utf-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <maze@google.com>,
        "Nikravesh, Ashkan" <ashkan.nikravesh@intel.com>
Subject: RE: [PATCH bpf-next v3 2/2] selftests/bpf: Verifying real time helper
 function
Thread-Topic: [PATCH bpf-next v3 2/2] selftests/bpf: Verifying real time
 helper function
Thread-Index: AQHWkhoN8X8pN57RPE6KaSxgyaHNSKl4PIUAgABCIiA=
Date:   Fri, 25 Sep 2020 00:22:19 +0000
Message-ID: <BY5PR11MB4354F70B6BB0B74C1B0FEBAD86360@BY5PR11MB4354.namprd11.prod.outlook.com>
References: <20200924022557.16561-1-bimmy.pujari@intel.com>
 <20200924022557.16561-2-bimmy.pujari@intel.com>
 <CAEf4BzZ7Srd2k5a_t6JKW9_=cUQVqvxXhd+4rvbpMHKRJAQbiw@mail.gmail.com>
In-Reply-To: <CAEf4BzZ7Srd2k5a_t6JKW9_=cUQVqvxXhd+4rvbpMHKRJAQbiw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [98.33.67.35]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69e66062-82b7-4271-f758-08d860e910cc
x-ms-traffictypediagnostic: BY5PR11MB4308:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB43081FABBDFAF0876B33732C86360@BY5PR11MB4308.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N620BoSexgB5+hUEt3I+P+NXbe5xYJX8LED88Tj9LL2zH5uySdXHXi4mcaMx4o5uaiseP0rtRIEmCbc+SRbljRSuet5bl4ESFQHuGjD4UWBCCQqInAWkr3SrfPMW1Szc96iYNSyKUMlMwpfRh6/CCw5QPSs9CsPG2EcMj7aIoxVzIvs9vc8SOAQWoyeA1jJSkjge8IXBKh0cZLRLPdQtHWSSXWG96wOYEZj/Z2WoXIoGKyGA0XPwhXQLUFae26VDEMDDrPRsPB/3Euoru6Wf+GlGN78AOvBKiph0uZ98FaP41xX9v2PPgI5qQOTRX0DC5Tk6VwxQTsxCvQHspLBjjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4354.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(53546011)(26005)(86362001)(71200400001)(316002)(54906003)(7696005)(66946007)(66556008)(66476007)(2906002)(64756008)(15650500001)(66446008)(76116006)(5660300002)(33656002)(55016002)(478600001)(52536014)(4326008)(83380400001)(8936002)(6506007)(6916009)(8676002)(186003)(66574015)(9686003)(107886003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: hPX5mcTxjh1zPedWH/11x0WNMgddZchZJlwZIF6rBMvsum0zIr7VNVax/Puy+LWsAMTcB/jGfmtljG+mBqYEjU1/Px8V7ZeuTo1SD1VqpM/wElXdI71ete2aBEriv1+HQAHxySi5jXk6JVCkS1iriAskfTAv4ARNH2dxKcw0c8Z2zBwKQ8msP1lPktlP1ln6Ifa48BI0MjIyETjw9GBxIqCTE3hyXMmQQH0Oi2RDNC5stqmP5fXDPpWg1xC8kiRUylF487+Hiz/4pwp9d8t3J8rgoQD/HaF2fDiqkEaGJNisxJybsqv0rZOCNpYq3I35E0KKTeOeb+63GQx1k+DExx33GQK4IXLbpUj77TXaq3fjHqc/asE5fdHdcVQRJ3sA6bZi57WZFDrDfgOWNW/xGPbIkh14t6FUOPIEH1ZDW+wg8M9lgz1089obUxirB9wz+evH4uB5jM6AQD2J+WT5Z9UloSCL2VwAu7yzmydge7EI48UdHOnDwnhYQvA+X2K3ovegRuyfXCldtExrTdeDToPl7TaccPlN1mr1jBHCeeyFqlj/xv7LX5SDKT7/ZK3v7P/lklYe0v2XMq03GVcBjFLqvROjDWiJwCfsWejtqAmTOvBXBM+269cH6/eyRrJ1T+JFjR5nY+Wb/jrrjBJT3Q==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4354.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69e66062-82b7-4271-f758-08d860e910cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2020 00:22:19.7370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: scFCXUKd34T6AzIzTaa1NJMTHf03nHu/ElONhK4U7UKFG4AFa2EEOd9OlOIOphtzbyY1rUsR4mEhcumm4uWyuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4308
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SSBhZ3JlZSB3aXRoIHlvdS4gSSB3aWxsIHdyaXRlIGEgc2VwYXJhdGUgbmV3IHRlc3QuIEluIHRo
ZSBtZWFud2hpbGUgSSB0aGluayBpdCBzaG91bGQgYmUgb2theSB0byBwcmVwYXJlIGFuZCBzZW5k
IGp1c3Qgb25lIHBhdGNoLg0KDQpUaGFua3MNCkJpbW15DQoNCi0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQpGcm9tOiBBbmRyaWkgTmFrcnlpa28gPGFuZHJpaS5uYWtyeWlrb0BnbWFpbC5jb20+
IA0KU2VudDogVGh1cnNkYXksIFNlcHRlbWJlciAyNCwgMjAyMCAxOjIyIFBNDQpUbzogUHVqYXJp
LCBCaW1teSA8YmltbXkucHVqYXJpQGludGVsLmNvbT4NCkNjOiBicGYgPGJwZkB2Z2VyLmtlcm5l
bC5vcmc+OyBOZXR3b3JraW5nIDxuZXRkZXZAdmdlci5rZXJuZWwub3JnPjsgbWNoZWhhYkBrZXJu
ZWwub3JnOyBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFzdEBrZXJuZWwub3JnPjsgRGFuaWVsIEJvcmtt
YW5uIDxkYW5pZWxAaW9nZWFyYm94Lm5ldD47IE1hcnRpbiBMYXUgPGthZmFpQGZiLmNvbT47IE1h
Y2llaiDFu2VuY3p5a293c2tpIDxtYXplQGdvb2dsZS5jb20+OyBOaWtyYXZlc2gsIEFzaGthbiA8
YXNoa2FuLm5pa3JhdmVzaEBpbnRlbC5jb20+DQpTdWJqZWN0OiBSZTogW1BBVENIIGJwZi1uZXh0
IHYzIDIvMl0gc2VsZnRlc3RzL2JwZjogVmVyaWZ5aW5nIHJlYWwgdGltZSBoZWxwZXIgZnVuY3Rp
b24NCg0KT24gV2VkLCBTZXAgMjMsIDIwMjAgYXQgNzoyNiBQTSA8YmltbXkucHVqYXJpQGludGVs
LmNvbT4gd3JvdGU6DQo+DQo+IEZyb206IEJpbW15IFB1amFyaSA8YmltbXkucHVqYXJpQGludGVs
LmNvbT4NCj4NCj4gVGVzdCB4ZHBpbmcgbWVhc3VyZXMgUlRUIGZyb20geGRwIHVzaW5nIG1vbm90
b25pYyB0aW1lIGhlbHBlci4NCj4gRXh0ZW5kaW5nIHhkcGluZyB0ZXN0IHRvIHVzZSByZWFsIHRp
bWUgaGVscGVyIGZ1bmN0aW9uIGluIG9yZGVyIHRvIA0KPiB2ZXJpZnkgdGhpcyBoZWxwZXIgZnVu
Y3Rpb24uDQo+DQo+IFNpZ25lZC1vZmYtYnk6IEJpbW15IFB1amFyaSA8YmltbXkucHVqYXJpQGlu
dGVsLmNvbT4NCj4gLS0tDQoNClRoaXMgaXMgZXhhY3RseSB0aGUgdXNlIG9mIFJFQUxUSU1FIGNs
b2NrIHRoYXQgSSB3YXMgYXJndWluZyBhZ2FpbnN0LCBhbmQgeWV0IHlvdSBhcmUgYWN0dWFsbHkg
Y3JlYXRpbmcgYW4gZXhhbXBsZSBvZiBob3cgdG8gdXNlIGl0IGZvciBzdWNoIGNhc2UuIENMT0NL
X1JFQUxUSU1FIHNob3VsZCBub3QgYmUgdXNlZCB0byBtZWFzdXJpbmcgdGltZSBlbGFwc2VkIChu
b3Qgd2l0aGluIHRoZSBzYW1lIG1hY2hpbmUsIGF0IGxlYXN0KSwgdGhlcmUgYXJlIHN0cmljdGx5
IGJldHRlciBhbHRlcm5hdGl2ZXMuDQoNClNvIGlmIHlvdSB3YW50IHRvIHdyaXRlIGEgdGVzdCBm
b3IgYSBuZXcgaGVscGVyIChhc3N1bWluZyBldmVyeW9uZSBlbHNlIHRoaW5rcyBpdCdzIGEgZ29v
ZCBpZGVhKSwgdGhlbiBkbyBqdXN0IHRoYXQgLSB3cml0ZSBhIHNlcGFyYXRlIG1pbmltYWwgdGVz
dCB0aGF0IHRlc3RzIGp1c3QgeW91ciBuZXcgZnVuY3Rpb25hbGl0eS4gRG9uJ3QgY291cGxlIGl0
IHdpdGggYSBtYXNzaXZlIFhEUCBwcm9ncmFtLiBBbmQgYWxzbyBkb24ndCBjcmVhdGUgdW5uZWNl
c3NhcmlseSBhbG1vc3QNCjQwMCBsaW5lcyBvZiBjb2RlIGNodXJuLg0KDQo+ICAuLi4vdGVzdGlu
Zy9zZWxmdGVzdHMvYnBmL3Byb2dzL3hkcGluZ19rZXJuLmMgfCAxODMgKy0tLS0tLS0tLS0tLS0t
LS0gIA0KPiAuLi4vdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3hkcGluZ19rZXJuLmggfCAx
OTMgKysrKysrKysrKysrKysrKysrDQo+ICAuLi4vYnBmL3Byb2dzL3hkcGluZ19yZWFsdGltZV9r
ZXJuLmMgICAgICAgICAgfCAgIDQgKw0KPiAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rl
c3RfeGRwaW5nLnNoICAgIHwgIDQ0ICsrKy0NCj4gIDQgZmlsZXMgY2hhbmdlZCwgMjM1IGluc2Vy
dGlvbnMoKyksIDE4OSBkZWxldGlvbnMoLSkgIGNyZWF0ZSBtb2RlIA0KPiAxMDA2NDQgdG9vbHMv
dGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3hkcGluZ19rZXJuLmgNCj4gIGNyZWF0ZSBtb2Rl
IDEwMDY0NCANCj4gdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3hkcGluZ19yZWFs
dGltZV9rZXJuLmMNCj4NCg0KWy4uLl0NCg==
