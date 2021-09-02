Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904733FEB65
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 11:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343617AbhIBJeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 05:34:05 -0400
Received: from mga07.intel.com ([134.134.136.100]:62556 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245519AbhIBJeE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 05:34:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="282760276"
X-IronPort-AV: E=Sophos;i="5.84,371,1620716400"; 
   d="scan'208";a="282760276"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 02:33:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,371,1620716400"; 
   d="scan'208";a="510906827"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 02 Sep 2021 02:33:05 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 2 Sep 2021 02:33:04 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 2 Sep 2021 02:33:04 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 2 Sep 2021 02:33:03 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 2 Sep 2021 02:33:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6B8zJqRi7xwp76oBIeuhGh9D9ZIC/u1qemnAk8lmRy5lGVHzHXz2TORfzVobX7ZzhBeru3EVhMG8D6rQm4zrWIdNmkzYro7cAJhKOXtNFE3RqG3SaMKBnYDmlDur//QCEUJNWy4D5UeKXvhgmG/kx5Q6vhplXy1DX59BzSE1TVrrL/5rw55glRnNX7+oToynnQjGFFu5vfDrgIdzp338Zg15qPN0n7L8dIv++O7Y54ujdnQyWiRwfVf7hI5+N/wnxoXMGSD/S3aLeTBQ+1XFs9jVVo6/fNBiM/w4reI0+VRfnZ2mG7pQ0t+Y9SOvs08wwaz5d6oIdZcRK3CzbpYbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=JQs/S2s2CIutFSqEx7z6s25fCQ/J15ZZPo2c85JsyIg=;
 b=ofaFNULj+A5PBma9li7acMz1JlpkwjaYRAiTYv1xN7Jg9Ck+WBvFi9VtA6l9M5r11wbFB5ekQbW2avQqCCRszwZzX8Sv2kRU1jcIWHWQy3t3U6ri/6ISUVqtYgCdIHtK+f0ni9ZrMXoffc3aSrBi9dzg+1jPN74+M7ipgGL1XNKvp0i/9QdZSbpzskpLpjAvWeiIWLAskL8ZdBnS2dAy9KDLn1ISd+YUVzRgWE4K7314tLxhdOxK52Eg+Cjg3oawzFe79u1rGxt4httUksuh3I9uvyejNbkxCidJheGleocVvWWAYvJQ4S95lzl9kwijY/bTcbcNEtjeGvTnnkDHDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQs/S2s2CIutFSqEx7z6s25fCQ/J15ZZPo2c85JsyIg=;
 b=BY7Yz40z3UrelTQw+qNgd4jpLzMNEzJzYgPNWf17jPvOMgdutVQ2+YGa2lgvrLuXARI9pRQRZ+FTuLCz4i6nBXOQlbT9FatXvxXQSlZDE+abXjR2kHGEzR1f24BBthpYDUvMfjeWbPFdC1Yfx6jNpN6VVf3C09QMEsmcI9EPMc8=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by SJ0PR11MB5199.namprd11.prod.outlook.com (2603:10b6:a03:2dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Thu, 2 Sep
 2021 09:33:02 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::bc8c:80c0:1c01:94bf]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::bc8c:80c0:1c01:94bf%7]) with mapi id 15.20.4478.020; Thu, 2 Sep 2021
 09:33:02 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [GIT PULL] Networking for v5.15
Thread-Topic: [GIT PULL] Networking for v5.15
Thread-Index: AQHXn2PwQVUc2TbYZUqtQwO2eDttQauPk/GAgAACPgCAAOYTAA==
Date:   Thu, 2 Sep 2021 09:33:02 +0000
Message-ID: <635201a071bb6940ac9c1f381efef6abeed13f70.camel@intel.com>
References: <20210831203727.3852294-1-kuba@kernel.org>
         <CAHk-=wjB_zBwZ+WR9LOpvgjvaQn=cqryoKigod8QnZs=iYGEhA@mail.gmail.com>
         <20210901124131.0bc62578@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <4dfae09cd2ea3f5fe4b8fa5097d1e0cc8a34e848.camel@sipsolutions.net>
In-Reply-To: <4dfae09cd2ea3f5fe4b8fa5097d1e0cc8a34e848.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.3-1 
authentication-results: linux-foundation.org; dkim=none (message not signed)
 header.d=none;linux-foundation.org; dmarc=none action=none
 header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e40313a4-ec65-4a51-883a-08d96df4a8dc
x-ms-traffictypediagnostic: SJ0PR11MB5199:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB519926F4EF51C3872173EB7090CE9@SJ0PR11MB5199.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GZ1p2bYddscIDKkDyKlzniQdDTdfMVagg0VR0LbqThAloQs5G625k5gLs6n/NOjBijs6g7cFhRsfhO9TMQOkAuQrt/gS9YM5H5NlkXobLGn7JYsXu+9CWNJag5sl4YYgRzk4cGRcgZmoYNhTa9+L+VP0VpPgMVhBaepJOH9WVip9yu5dvJAT5Kr/TJq567mbFE1IgIbn9mpqdBDUMa5MJ69n5tjPJf/DvynuO0HhuOAjVi74IximSzy276ojIZFj2jp7YmADNTeCXcdXGIOGco1F/GdN9BzI+47KEGm5ndPtL0NhVkKrEZyXGMRKfTgVZUoegj6K5YJfskp2ta0Q/gGqN1Sr1nD1qSaYUhkphV5lkw8+pdXhKh+cf2P5U023C/m8XrdnXvkkqa7tLCsGhXxAMML3Y/ZhhudfJaHFR69E9xKKSQPJbeKRQANa7vpDX3p9Bo+uGCOElC6VEFEEGh9SgFSoQJXy2HS8hhYUL5eKCCilv2dX3RjZ4r8mICti8dabwIU7Hh97L/IOTTscP0hqr5XvLMqCNTKfVPftoWDM7x+cUhHDBzbwsOtx5xB4GrZZmLTDVGR6uFuybRK7jD2Ai0dliwyaMzzgqwpvFgsnarsLChFBP1iFaS+uha22a/FSlloefKmmA/WvO45T4fOonlqPq7B0/8+RblQkixeZc+dJ3aXyMkw4yw0WWqbSN6rr5i0WsULUdjw55IS15w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(122000001)(36756003)(38100700002)(8936002)(86362001)(38070700005)(8676002)(6506007)(2616005)(508600001)(54906003)(2906002)(4326008)(110136005)(26005)(6512007)(71200400001)(91956017)(186003)(5660300002)(66946007)(66446008)(6486002)(64756008)(66556008)(316002)(66476007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SlduazJrQUllZ051TkhXTzBqTG51YjdHWHBvYzVsTXNSU2xVaVpKN2RwYkJq?=
 =?utf-8?B?UVNHbnR5b2JaU2V1czkrNmhWZG4wSTNCWEtuRjB3UlhlWDRLUmkwd0UyR2RP?=
 =?utf-8?B?bEwxTmhFcHpUUlRFbU8ybG82dVhuaUdOU0JWL1BwRnBRNGN0cDQydk8vM0xJ?=
 =?utf-8?B?K2ZzaEp1QWI2RFVVckoraTlqWDM3OGpwajdMQXdwVm93SXQ2TkpycHR1VC9K?=
 =?utf-8?B?VG5wQUpObVRWeFVnSzA0Ymc0bDRIdXRFa3B5QnJDeUlaK1ErVUtLcS9tVm9m?=
 =?utf-8?B?Nm1ObW8zeWVVVC9qa01sczYwb3laWEZUNUJ0dEVHa3JPb3JjbnNPWmtVSHFN?=
 =?utf-8?B?NnhhRjZNNS8wWS9vZDNva0p2NkpXV0R4Z2k0VFh0VVNZMm9ja1lHekt1VmF1?=
 =?utf-8?B?ZDZqTjdkKzVnWUJPUlhpd0xVeU16UTNjeTNPZEpRelp0cG5yTE9zNkFFODVn?=
 =?utf-8?B?cVRpZHRwd25mQUxLS0ljcnE0U3V6VElRVEd6VkVFNE5rOUM4WmJRNzl3THhJ?=
 =?utf-8?B?N0huSWE5Uk5yUzV4b2dPUVRNdTJ6UFN3ZDhHMmFBRGJqT3I2d1IzMTdZUGFX?=
 =?utf-8?B?QmpUQWtxN0tCaXJRUStaeFpETDZ3LzFCUk1iYjg4RDBtblpjYVNQZkxTUXMx?=
 =?utf-8?B?MVhxWGx4THd3V3lLZU8yWnJ4VE5LQnUxdnhvL0x3ZzRTY3V0OTJCWDd0S3ZY?=
 =?utf-8?B?OHZVYjVjNzJldmZTamZ0SUF2Z09BS2lrZGt5ZU04Wjk0em8vWHZHWDVFY2pa?=
 =?utf-8?B?RVhlemMvZVQxZjlUWWVSTjVkc3cxYlZxL2x6cVRKelQ4cE9UNjRCTDljYU1B?=
 =?utf-8?B?MFJMK1RrMEFlK3lmR09QVXIwNlphaXk2dnZKN2M0OVZleVZ5RmkrMzFYNHZG?=
 =?utf-8?B?TE9nbDg0VFRpOVc4TWlDMEJvSGFnOEdvQVlUQS80b05NTDI4LzJ2eFFkKzR3?=
 =?utf-8?B?d0JKM1ZjclhwRzlxUUYwYi9xRzhNNlBJNWhCSzZmMTZudVJVbzh5bUNadTBQ?=
 =?utf-8?B?cTd2aGxIcUUyY2ZNUko4N0xEUC8xdmJ6Qjg3WnEzTVFNL1pWYWs1ZkVOUGFp?=
 =?utf-8?B?R3VnYmROZjdjaXFHSmFCQjZSK0QyV2xmN3NDQU4weDdNMnM5Y0FZUnY4Y3J3?=
 =?utf-8?B?WFRHSjhPdlRZK3NhdU5za3owekM2cEZxek1Ecm50aXV4YVBBNERtcVU4cGpy?=
 =?utf-8?B?NEJxaFR4MnBGYnNBNzFLb21YOEJIaXE4RnhoWUFhbURSRHp4MGNrMVBrLzJV?=
 =?utf-8?B?bmkrWlRjcDRVeURSR1JBQWFsOUZBOXVYUnJEZkFSNUFxYS9CSkJZeGNjd1Ix?=
 =?utf-8?B?aWQyU0dDMVdjbFkwVHhZbTFkMThXVDk0bUhOcGp3ZnB2OE1RZlNlUC9hWk9Z?=
 =?utf-8?B?WDl4L0hOeG5jdzlsd25NR0RWU0FaaVBGY2oxUlJZaVlidVlERHJrZm16TUFK?=
 =?utf-8?B?ckFlYVlwNjZscVdaQjYrZFMzdHJvMi9DZTI4N09OTmx0ZkNBVllmTUttaUIz?=
 =?utf-8?B?YTJ1RlhjdEJaWWszNmtGT2hRdHpReG01bXRHU1hYNll1UzgrVUxDUThPeDIr?=
 =?utf-8?B?M0MxMFVqbXg0VjZqZk11V3RMTFErcTNYV2k2blNNSk4ydTUxbHZiLzIxcGpQ?=
 =?utf-8?B?TnRQdEhlUHFYc0xtdE4xR2lxQkUveTJUbEMraFFlYndPRlJOZUNPMSs4Q3lu?=
 =?utf-8?B?K281WCtWTjgvUXA3dTBXejFqRzNkbzRrRi9uc0JFWVA5dllETUQwMWszc0ZR?=
 =?utf-8?B?QVp0N1JlTUxPUitQc0ozdENab01VS01SWWxBS08yYTRrRE5VM0NsTExEWFp6?=
 =?utf-8?B?YXVlTWtYbE80UFNaSy9Rdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <350CD16ED07BC04FBC9BBD9BDC1404A2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e40313a4-ec65-4a51-883a-08d96df4a8dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 09:33:02.1379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: khKz7s08L39JILyw96YEZ8qNoghiGZkkTGtF6ibemDhreHXKcvk4aBzCX9EOWWZ246MFF23kbstOXuN2gReg8PzJ8qIHVvvVmwmPSdhZG64=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5199
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTA5LTAxIGF0IDIxOjQ5ICswMjAwLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0K
PiBPbiBXZWQsIDIwMjEtMDktMDEgYXQgMTI6NDEgLTA3MDAsIEpha3ViIEtpY2luc2tpIHdyb3Rl
Og0KPiA+IA0KPiA+ID4gDQo+ID4gPiBUaGV5IGFsbCBzZWVtIHRvIGhhdmUgdGhhdCBzYW1lIGlz
c3VlLCBhbmQgaXQgbG9va3MgbGlrZSB0aGUgZml4IHdvdWxkDQo+ID4gPiBiZSB0byBnZXQgdGhl
IFJUTiBsb2NrIGluIGl3bF9tdm1faW5pdF9tY2MoKSwgYnV0IEkgZGlkbid0IHJlYWxseSBsb29r
DQo+ID4gPiBpbnRvIGl0IHZlcnkgbXVjaC4NCj4gPiA+IA0KPiA+ID4gVGhpcyBpcyBvbiBteSBk
ZXNrdG9wLCBhbmQgSSBhY3R1YWxseSBkb24ndCBfdXNlXyB0aGUgd2lyZWxlc3Mgb24gdGhpcw0K
PiA+ID4gbWFjaGluZS4gSSBhc3N1bWUgaXQgc3RpbGwgd29ya3MgZGVzcGl0ZSB0aGUgd2Fybmlu
Z3MsIGJ1dCB0aGV5IHNob3VsZA0KPiA+ID4gZ2V0IGZpeGVkLg0KPiA+ID4gDQo+ID4gPiBJICpk
b24ndCogc2VlIHRoZXNlIHdhcm5pbmdzIG9uIG15IGxhcHRvcCB3aGVyZSBJIGFjdHVhbGx5IHVz
ZQ0KPiA+ID4gd2lyZWxlc3MsIGJ1dCB0aGF0IG9uZSB1c2VzIGF0aDEwa19wY2ksIHNvIGl0IHNl
ZW1zIHRoaXMgaXMgcHVyZWx5IGENCj4gPiA+IGl3bHdpZmkgaXNzdWUuDQo+ID4gPiANCj4gPiA+
IEkgY2FuJ3QgYmUgdGhlIG9ubHkgb25lIHRoYXQgc2VlcyB0aGlzLiBIbW0/DQo+ID4gDQo+ID4g
TW0uIExvb2tpbmcgdGhydSB0aGUgcmVjZW50IGNvbW1pdHMgdGhlcmUgaXMgYSBzdXNwaWNpb3Vz
IHJ0bmxfdW5sb2NrKCkNCj4gPiBpbiBjb21taXQgZWIwOWFlOTNkYWJmICgiaXdsd2lmaTogbXZt
OiBsb2FkIHJlZ2RvbWFpbiBhdCBJTklUIHN0YWdlIikuDQo+IA0KPiBIdWghIFRoYXQncyBub3Qg
dGhlIHZlcnNpb24gb2YgdGhlIGNvbW1pdCBJIHJlbWVtYmVyIC0gaXQgaGFkIGFuDQo+IHJ0bmxf
bG9jaygpIGluIHRoZXJlIHRvbyAoanVzdCBiZWZvcmUgdGhlIG11dGV4X2xvY2spPyEgTG9va3Mg
bGlrZSB0aGF0DQo+IHNob3VsZCByZWFsbHkgYmUgdGhlcmUsIG5vdCBzdXJlIGhvdy93aGVyZSBp
dCBnb3QgbG9zdCBhbG9uZyB0aGUgd2F5Lg0KPiANCj4gVGhhdCB1bmJhbGFuY2VkIHJ0bmxfdW5s
b2NrKCkgbWFrZXMgbm8gc2Vuc2UgYW55d2F5LiBXb25kZXIgd2h5IGl0DQo+IGRvZXNuJ3QgY2F1
c2UgbW9yZSBhc3NlcnRpb25zL3Byb2JsZW1zIGF0IHRoYXQgcG9pbnQsIGNsZWFybHkgaXQncw0K
PiB1bmJhbGFuY2VkLiBQcmV0dHkgc3VyZSBpdCdzIG1pc3NpbmcgdGhlIHJ0bmxfbG9jaygpIGVh
cmxpZXIgaW4gdGhlDQo+IGZ1bmN0aW9uIGZvciBzb21lIHJlYXNvbi4NCj4gDQo+IEx1Y2EgYW5k
IEkgd2lsbCBsb29rIGF0IGl0IHRvbW9ycm93LCBnZXR0aW5nIGxhdGUgaGVyZSwgc29ycnkuIA0K
DQpSaWdodCwgdGhlIHJlYXNvbiBmb3IgdGhpcyB3YXMgYSByZWJhc2UgZGFtYWdlLiAgV2UgbG9z
dCB0aGUNCnJ0bmxfbG9jaygpIGNhbGwgd2hlbiBJIHJlYmFzZWQgdGhlIHBhdGNoIG9uIHRvcCBv
ZiB0aGUgdHJlZSB3aXRob3V0DQppd2xtZWkgKHdoaWNoIHRvdWNoIHRoaXMgc2FtZSBmdW5jdGlv
bikuDQoNClNvcnJ5IGZvciB0aGUgdHJvdWJsZSwgSSdsbCBzZW5kIHRoZSBmaXggaW4gYSBzZWMu
DQoNCi0tDQpDaGVlcnMsDQpMdWNhLg0K
