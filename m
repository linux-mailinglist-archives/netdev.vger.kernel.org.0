Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52174016EC
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 09:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240123AbhIFHWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 03:22:33 -0400
Received: from mga18.intel.com ([134.134.136.126]:18735 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240063AbhIFHWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 03:22:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10098"; a="207024393"
X-IronPort-AV: E=Sophos;i="5.85,271,1624345200"; 
   d="scan'208";a="207024393"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2021 00:21:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,271,1624345200"; 
   d="scan'208";a="463852083"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga007.fm.intel.com with ESMTP; 06 Sep 2021 00:21:26 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 6 Sep 2021 00:21:25 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 6 Sep 2021 00:21:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 6 Sep 2021 00:21:25 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 6 Sep 2021 00:21:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKdpdfuWZZhptZ8Bz1omAdzanXhfGIStJgNtAbre6l12Z6Hyijd+bsDuOOxCwrVK/q0eWsCmP2Qq8pUqBKgtg3kO0tuVTAnIlhqp2IIojFi869CjCP5VKM2Bj/+fwTz4zi9ZM6W/i49/3UA4pKuyoeeXTyb7v7nNOQml3GP9zBlEOv4HNY5CDOa005ulJn30Ra59f3e8SleENl2t1JA5low1Ap6TWyru0f4DO0sQCsjKKWgK0Zk6j6Q5LVkIxtVKE19Rhf2lhF5IghnCoFbTnlGJewNt4z/HLhcXA03y2K3MSUwWGOJr2MJGsGK+f6QoqK20UIz7My9heyzp3j8T+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ozYPNajhj0X25oS1OmGNDz/1IGwakDd5RVmj6Rjuxaw=;
 b=TBCrB4hFC3d8778ZgSn1lV8BIIm8rf9eaopAq3B3vDFdsZAkoLVF4FQXUxeSCa4gkmwQdcCE6IqxKIZgMU/zXChazouHh6ve3tS/F50EyfZOtBJ9j9VGib2OQizyvY8S6reXQoJ+rdhmHVu9/+6mX1cCJexA1n3n2lIFJtgz+JmKui1BYo7E8qnK9f5sZ0O2721+Iq1l0pT2kSW4kUk7oHmwOxhzyVEYGojJzcUaCfw1tN/x6e1vq7IhKZltXFS4CJosrnNcbqyrmrEWKDg+WpqvkWRKFlHf3Lkz9pz9Lzx0lFiDglnLOV3s82vtJwAnIcbmciEljjhY3dZHqxxEbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozYPNajhj0X25oS1OmGNDz/1IGwakDd5RVmj6Rjuxaw=;
 b=Wd7hTam+NtlBjkC2EknJq/f0MV8d71JfOa5ESjyCiyExzqDP9kgveCACjyrU+z/KNbM5JXwoYJvPPUSkrVxgTekEmYSTAaqUI1iwaFskzUmszkO48w1NlACMR30MZxacGNs0nxTvvzKCxgngb+G0eLHXx7g1bWWDggIivBU1V/g=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BY5PR11MB4385.namprd11.prod.outlook.com (2603:10b6:a03:1c0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Mon, 6 Sep
 2021 07:21:22 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::bc8c:80c0:1c01:94bf]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::bc8c:80c0:1c01:94bf%7]) with mapi id 15.20.4478.025; Mon, 6 Sep 2021
 07:21:22 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>, lkp <lkp@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH -net] wireless: iwlwifi: fix printk format warnings in
 uefi.c
Thread-Topic: [PATCH -net] wireless: iwlwifi: fix printk format warnings in
 uefi.c
Thread-Index: AQHXljGgnZr+60A2AUarFyZfwXdGwKuV5isAgADNBoA=
Date:   Mon, 6 Sep 2021 07:21:22 +0000
Message-ID: <044a1185a6273747fe906367a6d3d25d5ceff9f2.camel@intel.com>
References: <20210821020901.25901-1-rdunlap@infradead.org>
         <e5ccd622-e876-d4e8-5f2b-e1d183799026@infradead.org>
In-Reply-To: <e5ccd622-e876-d4e8-5f2b-e1d183799026@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.3-1 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c1391af-f668-4365-b88b-08d97106ee01
x-ms-traffictypediagnostic: BY5PR11MB4385:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB43853CB2EB676F03E1A5D31590D29@BY5PR11MB4385.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jm5wruuwhlBg31q1MU9OSmiopC6e1VAnSb7Xlqab01o5Gu8DDgg2jVnybgxIXJPYzvekjfikYphYvp6hV6YdR/HJmU+i5uDgY+SKw4XdeT/A6vF4A/7mIIR6PJeAt0WDDP/m2XhvsF6mDURucof/OrjoQoatBsfaFymbHh6ifsBYZa8IQd3SrdHEi30P8Avcfxxyb0FJ3sA/Q8RKa85X2czPkfm18rZ4Mpbk52ZUX+VcPZ8g8+K400Bn8AYrit4X9OeFqM7JzRgqy/SVH6TVJRUd+/Z64IgagzvoLGHefRRh7r/JiPQkTqiwecvvwuSXINLFvCF3yZidfe3/IpNYa5sxQhhGyKnv8TUtnBsJALllnVlxXtngqsDMB+5bhDJoEYruNE58TGUlxwkY+wwM8aoeJLGpEzceofkanubFepn1Yip4hkeCHkyH+1El2ZOA4vIxpFlOTfPa5Q4eVGb99sF+Xqd3uB1cLt5+WYjW6AFXZX0d8zCnPIQrDzckPWYfYPivIxJ03EUxWlg7TBnVKyM5/F++HMbBlk3//FAvwB7z9JW5xktboBTTP3LOf/8uUVsm2FZBziRWKtEKxIkFgJv6n9TjVNVouskl3fp3baP57xMwT0p2rBOx8x3PAH1EomfWjTQHhrujGDy8G8z59yBxABGn0dBLs/K0dM/vg72i7QXvcxRndf7pZ/AFUeNd+EWTZ9RzTEyfZPM63MdB9wLTMNVS6X/el94/LbPgi+rVbSlnLc06wuNB5gyoHJqQHvpBGx/W7yjGjBbxD3HwXe6ABsFry9k1CbnSukckWSk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(4326008)(2906002)(316002)(36756003)(8936002)(86362001)(71200400001)(110136005)(38100700002)(122000001)(6512007)(478600001)(6486002)(54906003)(83380400001)(8676002)(76116006)(2616005)(53546011)(26005)(6506007)(64756008)(91956017)(66446008)(66476007)(186003)(5660300002)(38070700005)(66946007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3NwOG1zaHNFUGV2ZUJJb0doMmMydDdOSTBONkFoVEpiZGpnM21xcCt4a0h5?=
 =?utf-8?B?UG9hcUF3cENoVFFkNk15d1pyNXVORmthbWF6S3dnWUw2ZEpmeEQ0bU02am5u?=
 =?utf-8?B?YXUrcHN1R2liNDdIeTRreTdqbU9uSlBZeVFucWVNVk5DQzZWUTlSbW9MLzRx?=
 =?utf-8?B?L3JpcU5vZy80SS84R2NBRU1aNm1DSENQVkV1anAwV2tnM3RKVXd3NkxBaXdv?=
 =?utf-8?B?aHNHbnc0bXovQ2RiQ2E4ODh2NXZPR0RheTIyWlA4SWlmallOKy9SN1YrdDBH?=
 =?utf-8?B?NGVKNWlObkFGNkpuMzhVeXlTWFF4UVNCV2J5enhtdjhTdE84YVBlQlFKTzh3?=
 =?utf-8?B?QjM2Sm1yTU1uVkdjZ1FPYzVTeittVk9UVlJSVjdpeDFBMnFvZGxaY3ZGTmVz?=
 =?utf-8?B?N2t5L1FLcHpwWHZPSnFnLzJPZEZSNndrVFl6cE00K3Z4RThOZFIrR1JEdkNN?=
 =?utf-8?B?ZjNiZGpJbWFST2dPbFNhQ1I2KzRlbG5saUFQQ3lpU2FOdE5qc1MxT25nODN1?=
 =?utf-8?B?d0FKZHd5dmhvTjQvL1RlUkhZNHdMclRZWG1tRGNweHRrS1BEcW9ua08rZ015?=
 =?utf-8?B?SXZtUzVSMENoREdQV2YxdjYxMVc5NzBlTzlkMjdVNWRLRGY3ZytxRlAzR3Bs?=
 =?utf-8?B?eHgzZ2VaNW1ISFNrMU1LQ1hkZHlPb1JId3JhbzBWNnlYUHpUMFY3K1dmL20y?=
 =?utf-8?B?SHJVYXdhWVRkekFnWVFzOWJ4enoxdEZwOGh3ZnJ1a0NFczVKNzhOMG5UU0pK?=
 =?utf-8?B?bDROUW16UUFuZFc4c0I2alVhQ0RFWGhaMnhLQ1dzeWE0Y29rNThEdVo2cEtw?=
 =?utf-8?B?ME1zajNST0VSRkhyTE9PT05vby9ka1h3cWJmZUxsRDdMR3EySjE2QjIzUTFW?=
 =?utf-8?B?djloUUMrMlBNWEJIbFhSWUpjbEJ3Rlp0VWlzbitybXVuSGlhM29CR3JvbE9X?=
 =?utf-8?B?RkpYYXZlV1JScVM1WmVFNkRmK1N1RVk2ckRneEc3bUtLdHIvRGNDZ3FzUU1J?=
 =?utf-8?B?UjlPY2R3QW4vbTRLbWFjaUZpaEh3UnMzUnlwMllwRWZVSFdVQVp6aXc1c3RU?=
 =?utf-8?B?VjQwenNiK21jMTV2aGJYNFNkeS9abTJkREw5R1h2LzBvUkR1clo3cDd6Y1d3?=
 =?utf-8?B?bGxwMEh1ZGFJRlJobWNOd2tGcFd3YXlSQXFCYUVvM0Npc1UzNTl4MGdjMS9D?=
 =?utf-8?B?bW1mMDRjTVJ2MU9qQStEZVgyY1ZPb3FuVVhhZkltZUFncHRYVldqWjFwUnJX?=
 =?utf-8?B?SnpoMEVkbFJoN0diUXowZ2xrQ0RCTUdCS3NTcDdXeW56OTQwSFY5emZRQy9Q?=
 =?utf-8?B?YW01ZU55cjI0R1ZkR3lzdXUxOFo1bGZnSTM0L2hFeDZwUEdMOGYyeGd4dXBu?=
 =?utf-8?B?QmczaG1DdXV0YUpmcDdYMk1WeWdJL3hmTk83aktBVmVSNWQxV0Roek1XWjhz?=
 =?utf-8?B?VldMVzJVOVFlOU1EbE91UUYvNHRlaHFyci9tTkQyMG5WUGxQMlJDbEFtcVla?=
 =?utf-8?B?OVdURzU3K1RaS1Izb3N4QWpLQnVsenZNRjVLUXpZcmlNd2hPS0tNcGgvMVBK?=
 =?utf-8?B?bDNFT2FvbDgwWHdXaU1icWcvZk5CUnhsMzJadEZxaWVCR1RvMi9nT2dNQlNZ?=
 =?utf-8?B?R29KYU1vdDlzTThNc3FpMmJKbGsyZUJYWllZY25lY0Ztck12cFd1cGNLdy9W?=
 =?utf-8?B?UnBDNlJ4VGZ6ZzlkVlhvYTFSSEJsVWU0WXEwTzd0Y01QYXpKOTBsS2VBUXQ2?=
 =?utf-8?Q?UnYDyzx2UbdHO07C/gMARAG6zPRjPLhVcIw0MgU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A14A5EA671E0AF49988A41485453BC7B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c1391af-f668-4365-b88b-08d97106ee01
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2021 07:21:22.5598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Agen5+YM4Q7rRT/dfMxH6d+qSNOXywILJCoWoAx6s+cFfGu7lHjD/tJC/2Lpvq/vSmH267s5yBrMs4qjiKU4LcJmsSRjeY+IkIVY0/lRpJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4385
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIxLTA5LTA1IGF0IDEyOjA3IC0wNzAwLCBSYW5keSBEdW5sYXAgd3JvdGU6DQo+
IE9uIDgvMjAvMjEgNzowOSBQTSwgUmFuZHkgRHVubGFwIHdyb3RlOg0KPiA+IFRoZSBrZXJuZWwg
dGVzdCByb2JvdCByZXBvcnRzIHByaW50ayBmb3JtYXQgd2FybmluZ3MgaW4gdWVmaS5jLCBzbw0K
PiA+IGNvcnJlY3QgdGhlbS4NCj4gPiANCj4gPiAuLi9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRl
bC9pd2x3aWZpL2Z3L3VlZmkuYzogSW4gZnVuY3Rpb24gJ2l3bF91ZWZpX2dldF9wbnZtJzoNCj4g
PiAuLi9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL2Z3L3VlZmkuYzo1MjozMDog
d2FybmluZzogZm9ybWF0ICclemQnIGV4cGVjdHMgYXJndW1lbnQgb2YgdHlwZSAnc2lnbmVkIHNp
emVfdCcsIGJ1dCBhcmd1bWVudCA3IGhhcyB0eXBlICdsb25nIHVuc2lnbmVkIGludCcgWy1XZm9y
bWF0PV0NCj4gPiDCoMKgwqDCoDUyIHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiUE5W
TSBVRUZJIHZhcmlhYmxlIG5vdCBmb3VuZCAlZCAobGVuICV6ZClcbiIsDQo+ID4gwqDCoMKgwqDC
oMKgwqB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+DQo+ID4gwqDCoMKgwqA1MyB8ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgZXJyLCBwYWNrYWdlX3NpemUpOw0KPiA+IMKgwqDCoMKgwqDCoMKgfCAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfn5+fn5+fn5+fn5+DQo+ID4gwqDCoMKg
wqDCoMKgwqB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8DQo+ID4gwqDCoMKg
wqDCoMKgwqB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsb25nIHVuc2lnbmVk
IGludA0KPiA+IC4uL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvZncvdWVmaS5j
OjU5OjI5OiB3YXJuaW5nOiBmb3JtYXQgJyV6ZCcgZXhwZWN0cyBhcmd1bWVudCBvZiB0eXBlICdz
aWduZWQgc2l6ZV90JywgYnV0IGFyZ3VtZW50IDYgaGFzIHR5cGUgJ2xvbmcgdW5zaWduZWQgaW50
JyBbLVdmb3JtYXQ9XQ0KPiA+IMKgwqDCoMKgNTkgfCAgICAgICAgIElXTF9ERUJVR19GVyh0cmFu
cywgIlJlYWQgUE5WTSBmcm9tIFVFRkkgd2l0aCBzaXplICV6ZFxuIiwgcGFja2FnZV9zaXplKTsN
Cj4gPiDCoMKgwqDCoMKgwqDCoHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4gIH5+fn5+fn5+fn5+fg0KPiA+IMKgwqDCoMKg
wqDCoMKgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgfA0KPiA+IMKgwqDCoMKgwqDCoMKgfCAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbG9uZyB1
bnNpZ25lZCBpbnQNCj4gPiANCj4gPiBGaXhlczogODRjM2M5OTUyYWZiICgiaXdsd2lmaTogbW92
ZSBVRUZJIGNvZGUgdG8gYSBzZXBhcmF0ZSBmaWxlIikNCj4gPiBTaWduZWQtb2ZmLWJ5OiBSYW5k
eSBEdW5sYXAgPHJkdW5sYXBAaW5mcmFkZWFkLm9yZz4NCj4gPiBSZXBvcnRlZC1ieToga2VybmVs
IHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+DQo+ID4gQ2M6IEthbGxlIFZhbG8gPGt2YWxvQGNv
ZGVhdXJvcmEub3JnPg0KPiA+IENjOiBMdWNhIENvZWxobyA8bHVjaWFuby5jb2VsaG9AaW50ZWwu
Y29tPg0KPiA+IENjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmcNCj4gPiBDYzogIkRh
dmlkIFMuIE1pbGxlciIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQo+ID4gQ2M6IEpha3ViIEtpY2lu
c2tpIDxrdWJhQGtlcm5lbC5vcmc+DQo+ID4gLS0tDQo+ID4gwqDCoGRyaXZlcnMvbmV0L3dpcmVs
ZXNzL2ludGVsL2l3bHdpZmkvZncvdWVmaS5jIHwgICAgNCArKy0tDQo+ID4gwqDCoDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4gDQo+ID4gLS0tIGxp
bnV4LW5leHQtMjAyMTA4MjAub3JpZy9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZp
L2Z3L3VlZmkuYw0KPiA+ICsrKyBsaW51eC1uZXh0LTIwMjEwODIwL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2ludGVsL2l3bHdpZmkvZncvdWVmaS5jDQo+ID4gQEAgLTQ5LDE0ICs0OSwxNCBAQCB2b2lk
ICppd2xfdWVmaV9nZXRfcG52bShzdHJ1Y3QgaXdsX3RyYW5zDQo+ID4gwqDCoAllcnIgPSBlZml2
YXJfZW50cnlfZ2V0KHBudm1fZWZpdmFyLCBOVUxMLCAmcGFja2FnZV9zaXplLCBkYXRhKTsNCj4g
PiDCoMKgCWlmIChlcnIpIHsNCj4gPiDCoMKgCQlJV0xfREVCVUdfRlcodHJhbnMsDQo+ID4gLQkJ
CSAgICAgIlBOVk0gVUVGSSB2YXJpYWJsZSBub3QgZm91bmQgJWQgKGxlbiAlemQpXG4iLA0KPiA+
ICsJCQkgICAgICJQTlZNIFVFRkkgdmFyaWFibGUgbm90IGZvdW5kICVkIChsZW4gJWx1KVxuIiwN
Cj4gPiDCoMKgCQkJICAgICBlcnIsIHBhY2thZ2Vfc2l6ZSk7DQo+ID4gwqDCoAkJa2ZyZWUoZGF0
YSk7DQo+ID4gwqDCoAkJZGF0YSA9IEVSUl9QVFIoZXJyKTsNCj4gPiDCoMKgCQlnb3RvIG91dDsN
Cj4gPiDCoMKgCX0NCj4gPiDCoMKgDQo+ID4gDQo+ID4gLQlJV0xfREVCVUdfRlcodHJhbnMsICJS
ZWFkIFBOVk0gZnJvbSBVRUZJIHdpdGggc2l6ZSAlemRcbiIsIHBhY2thZ2Vfc2l6ZSk7DQo+ID4g
KwlJV0xfREVCVUdfRlcodHJhbnMsICJSZWFkIFBOVk0gZnJvbSBVRUZJIHdpdGggc2l6ZSAlbHVc
biIsIHBhY2thZ2Vfc2l6ZSk7DQo+ID4gwqDCoAkqbGVuID0gcGFja2FnZV9zaXplOw0KPiA+IMKg
wqANCj4gPiANCj4gPiDCoMKgb3V0Og0KPiA+IA0KPiANCj4gSG0sIG5vIG9uZSBoYXMgY29tbWVu
dGVkIG9uIHRoaXMgYW5kIHRoZSByb2JvdCBpcyBzdGlsbCByZXBvcnRpbmcgaXQgYXMNCj4gYnVp
bGQgd2FybmluZ3MuDQo+IERvIEkgbmVlZCB0byByZXNlbmQgaXQ/DQoNCk5vIG5lZWQgdG8gcmVz
ZW5kLiAgS2FsbGUsIGNhbiB5b3UgdGFrZSB0aGlzIGRpcmVjdGx5IHRvIHdpcmVsZXNzLQ0KZHJp
dmVycz8gSSBoYXZlIGFzc2lnbmVkIGl0IHRvIHlvdSBpbiBwYXRjaHdvcmsuDQoNCi0tDQpDaGVl
cnMsDQpMdWNhLg0K
