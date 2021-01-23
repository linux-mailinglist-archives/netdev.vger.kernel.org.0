Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D473011A7
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 01:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbhAWAZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 19:25:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:60021 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726375AbhAWAZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 19:25:35 -0500
IronPort-SDR: pwp4GHbtEYgfQdfMRoVcaUuVOellNAQSGhHe3pi3KEQ6LvmbVvzSvhUiQX8R5RxknddV/dDrua
 95cRq5KigqFg==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="198291696"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="198291696"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 16:24:50 -0800
IronPort-SDR: 0pwPodnLD1FnGa4Hc+tf6+iVGmQe+y6jG471+kBhdDHU4RUdB+CFCI4NZK7jdmIZVk9hKGxn2P
 XzL4Ge59mdcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="392480672"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 22 Jan 2021 16:24:49 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 22 Jan 2021 16:24:49 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 22 Jan 2021 16:24:49 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.56) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 22 Jan 2021 16:24:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GA2NTcELm6KNVyHADPxHrZ+LC7PtlP92Ykm/IFdy4lwHCpZwXM2sqfCO9QOMziw5n/h4iJzb35ZCP/aYjnnDInQtBY/OUGGR+vJ0BD6Ycd/zV5GAkK1Xjsf9Tudw/1jnMA6ur+6Es3Vr2u1cHbinHRnzXTpyijNWzYUUkx+OJ+lXF7yUMNX9GTexwHJa/66ZoL9xmJhY3jYKcdjeuSRXTE7RQvdQh9I02SORD1gVyaEXC/5UEw26jl1BYESc9+t2CzXGQznbgcH2jAtQ3tO3NLy86NZ6l38I6urDOnByYj8PYcm/HnbQ67h2//LzufRJDyxdOqCSqIzx10ymYSPqaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FHii0kGabaKzf8Twxj87aqeH3QcoGN2mmv4ATfYfHo=;
 b=GbZBYBGG2HaDy8WWf21OxcM4pslfFnxNb6TDyAFxQZx0rtajGhpufC8skVBmFKoNb6/8cfm3L3aEYC+F73SPEu+SCwLkxYKKPyI9WuMqbG+Ys5e5oLlHxtn59EQndMhFO95n6frMoIR9qlrJdD7Mb/pbGpwJi/jX3MLGJcS5R1uWDQON1Z+rX80P5ILolG2IJ2SoRFiHvibBCXLrPkx4juUBmv6CJjuGr7M81HGnTQevKhT6O6F2VANeedTuTYro5r6LFmG2TXRmmuJYVTpm2cKELzognkcI/4Wng0+HT+h2v5+UfSa5CQti1RwCPSRyaztiniwc9GB/i4frr6tx6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FHii0kGabaKzf8Twxj87aqeH3QcoGN2mmv4ATfYfHo=;
 b=VHZmfzSshU0BqLQKVxL76NOcHBKOHnhOVcur+gunUtj3KJkCB4lWncp6gKTJyXKyjB7pk0ImyaDEmJkbRsbjsruqPljEOIaQwb705ZDtPkkWGs6LHxIWk8buLF9EPFosBQoc5mOkppmNMpFAx3Zs0PLUt4E6YYbbyb+JaUxRc6w=
Received: from CO1PR11MB5105.namprd11.prod.outlook.com (2603:10b6:303:9f::7)
 by MWHPR11MB1966.namprd11.prod.outlook.com (2603:10b6:300:10f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 00:24:46 +0000
Received: from CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::fc66:dd19:b156:7090]) by CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::fc66:dd19:b156:7090%6]) with mapi id 15.20.3784.015; Sat, 23 Jan 2021
 00:24:46 +0000
From:   "Brelinski, TonyX" <tonyx.brelinski@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v3 net-next 06/11] ice: remove redundant
 checks in ice_change_mtu
Thread-Topic: [Intel-wired-lan] [PATCH v3 net-next 06/11] ice: remove
 redundant checks in ice_change_mtu
Thread-Index: AQHW7a3kfJeyfxqkIEOH+6Wp1dRIHqo0YIsQ
Date:   Sat, 23 Jan 2021 00:24:46 +0000
Message-ID: <CO1PR11MB5105166702FEA3D49B9D867BFABF9@CO1PR11MB5105.namprd11.prod.outlook.com>
References: <20210118151318.12324-1-maciej.fijalkowski@intel.com>
 <20210118151318.12324-7-maciej.fijalkowski@intel.com>
In-Reply-To: <20210118151318.12324-7-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.0.76
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [71.236.132.75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0b61304-6889-4a9c-261d-08d8bf3549e0
x-ms-traffictypediagnostic: MWHPR11MB1966:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1966B2B453D673CDBD5A1506FABF9@MWHPR11MB1966.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TpmBdbHYSpI3UZYk42bpwNJnYcXmnigxyb2ljikbbIwQ9p7Vey92o0lIybNhE5KThHfo+bfiCd4qj/x5jpK1KxqKECeN7Ce7/9l1ou9l8NI7U+5wE9cVD4qYW2cDVKqZ8KoV2R8Ng7cHvmdTho9vVJV0Jd6/Hy5QKoZq0k4oGdWt0QR1HuW+lxYb3kq/ZsP1FdMxmvKXf8kgenBn0dTNSPRvGw2iyVb8xWwhsglxIx6i2syzUvONgt0mfs3S8nGFFXBKl7wHqqWudM74SUv8kEfZAH2GMlRA+z2buDY62Lj0sfzt+E9uShjzTsjkcuVPGZ7+Hfd7PpqeA/JxOFM5io+H0EM+lL00k1Iz01f2ACUjz+aL2ZUxnmpXKpUJo2lxX6hbDZjzcVCRd/whzPw2VA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(9686003)(4744005)(5660300002)(53546011)(8676002)(110136005)(52536014)(316002)(6506007)(186003)(55016002)(26005)(7696005)(54906003)(86362001)(33656002)(8936002)(64756008)(478600001)(2906002)(4326008)(83380400001)(66574015)(66476007)(66556008)(66446008)(107886003)(66946007)(71200400001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ak5DQUx2czhySVliQURBZFdsYm9TeS8wUkNYNXBRQzNNS1VZTDRaajFZMDBS?=
 =?utf-8?B?d0twbnAxbitpR0t4Z2hkczZxcU1maEt4czNBTDZWN3F5SlZCYnB3dlhMcTlZ?=
 =?utf-8?B?WlV6bFFoQ0g4cnExcWJVVWtOVDMzTHBabjV4U2lxRXlLVC9aTlpnUDN4bTFj?=
 =?utf-8?B?WmtvWnUxM2JjWUxUa2V6dzZmR21YY0ZtMlh3UUZHOEJnS2JmRUppRW1JVlJo?=
 =?utf-8?B?ZEo5VG5oZjhyL05KcmtSNjdjcnpzK3A5bTZRMFJjUzdvc25QNEo1em1qb1Rj?=
 =?utf-8?B?VVlKOVpFcW1tcERPc1lpTXIyZlR4dWJkUnIrc0lMWUJKRllZbk40YmU1VnNE?=
 =?utf-8?B?UVdoUjl0cno0QzZvNDRlTVM1TzBoNm11MVprdS9RZFJnd2IzSlp4cVJwZmY2?=
 =?utf-8?B?TXRGSkdHaFVRV3UwaUZlT3pXcFcyVFB2M1E2QTJkLzdKQnNNbERTY05CNmVB?=
 =?utf-8?B?YU53SyswL3V4cG5CaVJyaHE1SnN0ZWwxKzc1Tm5pbzVlRDd2VEtYRDV1ZjBM?=
 =?utf-8?B?Yi9VMDFBdWZYbTJEOGdKUGJLNnJVbHl3RmZsbVcvYTZHREJKQmhhNVBaYnFU?=
 =?utf-8?B?dC9EZkFMYWsvOUhhSkdtalJ3Y0pOOFNIREtEckRYeGl2UTBlMlF5RWZCM0Uy?=
 =?utf-8?B?TWNWcjQyRU1mKzlSbGlJa3FVTjdESWl6Tml3eXdFZGcwWXlVd0lWRkhRYkJM?=
 =?utf-8?B?OG9pemNybTF1RHlFNDZKZXM1d0g0a1RCWWszaVg5c3pmZVNZeng0bG9aTFRo?=
 =?utf-8?B?VTd2WlRJTnoyQXR0a1M4SmdrcmxMUG5SOTdTR292MDN5U3hwaXk3Z1NiRDF2?=
 =?utf-8?B?SEVVRVhHWDk1Q3BHVXREME5GZnhEbTNFZDJCakdaRmFlK0FDMExDWUdZQkNG?=
 =?utf-8?B?bjdNQUh6bm1lWlBLVEdpMHJYaExnUCtoeHlobGtqdXM0RG95ZVp5OG8xSk45?=
 =?utf-8?B?V05pZ3NuV0tSQ2NoWlQ2elM3U3FyTWVYMXJDbTQzenBnS3AraUZXVnoyUGZC?=
 =?utf-8?B?c2JQenNTZE1OTHo1MnpoME5aZDRicnhqYTcxRXY3ZFFjcW5rRlNGZFBKZUNk?=
 =?utf-8?B?MGlhYjNMOE5JcDl6bjBKbnZkd2pkdmNhNzZrSW4wYkJ1aWNmZWdNeThxTlJi?=
 =?utf-8?B?L1BVUVRNREhRU0luTEUwV05MYTZ0emRJb0k3eEJOSWNHNkdMVS9PVldhZEh0?=
 =?utf-8?B?QzducHlaWGVHSEVmeGQ0RW1NK2pobllMbE52QU1QVk5mQW9Ya1MxQWltaHYx?=
 =?utf-8?B?ZXlHMnJGbjVURUlYVXlob0toeGVFdHBGdWd2dWlLV3FseW9sM3ludi9hQjBw?=
 =?utf-8?Q?9XAhG8Lv/6Elc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0b61304-6889-4a9c-261d-08d8bf3549e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2021 00:24:46.5438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: niq3EKkay1KQxH0OO5X0lU6ziIE58ZkKEcDAcPwN/GOB4U6T9Ohej5RzgfQ1GS31DyK9sJkVObqN2JObgKCaJRF2hfLHJ8ziU+UXi59tfCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1966
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSW50ZWwtd2lyZWQtbGFuIDxpbnRlbC13aXJlZC1sYW4tYm91bmNlc0Bvc3Vvc2wub3Jn
PiBPbiBCZWhhbGYgT2YgTWFjaWVqIEZpamFsa293c2tpDQpTZW50OiBNb25kYXksIEphbnVhcnkg
MTgsIDIwMjEgNzoxMyBBTQ0KVG86IGludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnDQpD
YzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsga3ViYUBrZXJuZWwub3JnOyBicGZAdmdlci5rZXJu
ZWwub3JnOyBUb3BlbCwgQmpvcm4gPGJqb3JuLnRvcGVsQGludGVsLmNvbT47IEthcmxzc29uLCBN
YWdudXMgPG1hZ251cy5rYXJsc3NvbkBpbnRlbC5jb20+DQpTdWJqZWN0OiBbSW50ZWwtd2lyZWQt
bGFuXSBbUEFUQ0ggdjMgbmV0LW5leHQgMDYvMTFdIGljZTogcmVtb3ZlIHJlZHVuZGFudCBjaGVj
a3MgaW4gaWNlX2NoYW5nZV9tdHUNCg0KZGV2X3ZhbGlkYXRlX210dSBjaGVja3MgdGhhdCBtdHUg
dmFsdWUgc3BlY2lmaWVkIGJ5IHVzZXIgaXMgbm90IGxlc3MgdGhhbiBtaW4gbXR1IGFuZCBub3Qg
Z3JlYXRlciB0aGFuIG1heCBhbGxvd2VkIG10dS4gSXQgaXMgYmVpbmcgZG9uZSBiZWZvcmUgY2Fs
bGluZyB0aGUgbmRvX2NoYW5nZV9tdHUgZXhwb3NlZCBieSBkcml2ZXIsIHNvIHJlbW92ZSB0aGVz
ZSByZWR1bmRhbnQgY2hlY2tzIGluIGljZV9jaGFuZ2VfbXR1Lg0KDQpSZXZpZXdlZC1ieTogQmrD
tnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAaW50ZWwuY29tPg0KU2lnbmVkLW9mZi1ieTogTWFjaWVq
IEZpamFsa293c2tpIDxtYWNpZWouZmlqYWxrb3dza2lAaW50ZWwuY29tPg0KLS0tDQogZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9tYWluLmMgfCA5IC0tLS0tLS0tLQ0KIDEgZmls
ZSBjaGFuZ2VkLCA5IGRlbGV0aW9ucygtKQ0KDQpUZXN0ZWQtYnk6IFRvbnkgQnJlbGluc2tpIDx0
b255eC5icmVsaW5za2lAaW50ZWwuY29tPiBBIENvbnRpbmdlbnQgV29ya2VyIGF0IEludGVsDQo=
