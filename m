Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E733011E3
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 02:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbhAWBOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 20:14:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:14755 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbhAWBOM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 20:14:12 -0500
IronPort-SDR: bWHEbSYd8rQEuV4/Z3VqcLDMu91rPcti0eaZN+YXKXb4p55DE8YNQTS9jr+1IzWPS2EoKK62t4
 wueqQ+WvdbLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="176024292"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="176024292"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 17:13:30 -0800
IronPort-SDR: sR7/jIw+vlIkdPdY1Nn/tmUM5LRXuQaUUdIhFgsV3siwYdxZKsRaK7v6WoxaaTiFyo40jZELY5
 FeYfxjo3ETcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="404438202"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga002.fm.intel.com with ESMTP; 22 Jan 2021 17:13:29 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 22 Jan 2021 17:13:28 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 22 Jan 2021 17:13:28 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 22 Jan 2021 17:13:28 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 22 Jan 2021 17:13:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjB8uoP1QFJUqpG3jrpg+BZ4QRcDdhXxiL+xwu7V6Ofyf6/irVB81hOUZY5fL0lcqF4FbqPtc/xk1/PSsdJK1PTpAorXWyVjeKMiqPX6vaXBvFGzAVX9R03fRwPrmEPg32M2iZ47VpFP0dKi63G/I49KQmeU5kuEYi6VrQwK5r7KyzFdFlT3lruPpwd3+oCYEUkmJr71QyGYvvJPJc3DfIV3Bjs/hHPoW2pGC/xnonFQFskS4lrmuLpSe5fggubCYF2AFiYjXnC/EsHFLSnrCQL/i9onezjozPI+Rsq55P4enzlr1BlxVod/WUPMLDzfv93UWqC3NHlDG5bRxTeDHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpFYQnDvK58NkHpxnNSu8/EzL8iIcFgb9ZuNWcuuAjI=;
 b=DJWOXLb1g10eyGE5cVVD7b9p7c+u/t9fWG9FRm/Kq7+/hFmEHik6+w/QSU0aAQvizydaDgK47k5bz93aa2au8dS9FT/VHGWUncXkLrX06AD15bclq2FbUGI7LzZR+N85DqNg+GLMYHp6T25wm3536QnS+97UhpZda3KH0dRU01HDjByUkrlunRDhATWEo3/r/tm/LIjYwrXUycx6EGbHx/YNiznChBXyrthlhRuK1y6n9MYz24ugNZMXrK/PxrxbtmQrfUAQRpv0vJsLJpwpYsmeHNx/E0i1xTP3pMOOxbkNL9yl16lQNSIQVYwotsO6g7r8AAh+EXIibqotG/SYdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpFYQnDvK58NkHpxnNSu8/EzL8iIcFgb9ZuNWcuuAjI=;
 b=g2FMHHhs4tK4fGPXS1gzDcc4i1ul6sG7+4inBWwHiCvOWy4hMd/eFTDOiPuj1Nv93qoDwnnlAJTmU0isuggs0y+K4G0ouOneDPCSlEf+oKo3cUlZXKJe4a5XQkywgE+s3bgv1bEE5JY3SNT6Ldb3cHwb7tL696UawwBUP7iL9+Q=
Received: from CO1PR11MB5105.namprd11.prod.outlook.com (2603:10b6:303:9f::7)
 by CO1PR11MB5105.namprd11.prod.outlook.com (2603:10b6:303:9f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Sat, 23 Jan
 2021 01:13:25 +0000
Received: from CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::fc66:dd19:b156:7090]) by CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::fc66:dd19:b156:7090%6]) with mapi id 15.20.3784.015; Sat, 23 Jan 2021
 01:13:25 +0000
From:   "Brelinski, TonyX" <tonyx.brelinski@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v3 net-next 05/11] ice: move skb pointer
 from rx_buf to rx_ring
Thread-Topic: [Intel-wired-lan] [PATCH v3 net-next 05/11] ice: move skb
 pointer from rx_buf to rx_ring
Thread-Index: AQHW7a3iHhGDuNXe10C9kH8nHLPME6o0bkRA
Date:   Sat, 23 Jan 2021 01:13:25 +0000
Message-ID: <CO1PR11MB51051BEF0A7237F13BB58575FABF9@CO1PR11MB5105.namprd11.prod.outlook.com>
References: <20210118151318.12324-1-maciej.fijalkowski@intel.com>
 <20210118151318.12324-6-maciej.fijalkowski@intel.com>
In-Reply-To: <20210118151318.12324-6-maciej.fijalkowski@intel.com>
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
x-ms-office365-filtering-correlation-id: 1fb22e3d-724a-41a0-e79a-08d8bf3c1599
x-ms-traffictypediagnostic: CO1PR11MB5105:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB51054014FE91C90639B52809FABF9@CO1PR11MB5105.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8oleYLcLAJMKPMc9U6xQjlXmWKqaCTF7cNWBM3Ri77lB+XWyAmrdfITSBzR+bQJXLmf2ivyRk3vzh7Hgohhv6jD6mFX7qVyMcBAu7TW5NlFlUPgN0OrfUvN18rBrHT6IuNbAbWjy4BeD6peYMA3Up5zsk0xNSRX+/03PNXdhlOwNRRI8fmcAINcieaRvPQWaApbYDvTgAyeYFntAKChMPp8aLcWZ6s7uVuCDVPq7GnsqKjMdMNhITAiV49OPBtQ36kccJDDqXuT62mLU+IXfs8NPGtggoQpGpDkEyECyfYGuZ3UhawClMzVKQy0fphgoe4Uui94qUCPdNfZEwfPRTIA7Ojk8tcXbwXA+u18DLHOCPn2Nrc/Xvb7qRLOT32bv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(64756008)(66476007)(5660300002)(66556008)(316002)(107886003)(2906002)(76116006)(66946007)(54906003)(66446008)(83380400001)(71200400001)(26005)(7696005)(53546011)(86362001)(478600001)(8676002)(9686003)(186003)(8936002)(55016002)(4744005)(6506007)(110136005)(52536014)(33656002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Mk4yRzdvWlpCMWwrODR3UHlFYXpwSW5VRjQ2VGs5c2pCMlF2QnEwSlRsTmhV?=
 =?utf-8?B?MU8yZGgra2wxSE9Ka3ZhVTV3WmEweEFTTjVjTGJPVll3QUhVTnlia21aYm9m?=
 =?utf-8?B?Z244NUFYaEdvaDVqclhBbFBYdGdrelNuMStkMXM3ektEdFRwdGNmbUVML3Ni?=
 =?utf-8?B?RU1DdmlsclZDYVBDQThFREtNN2lEaU9GT0x2MlZRY0pDWVBJQ1BacldMTWRI?=
 =?utf-8?B?YWszTmtBa0g1Y0paUmFQeVhkWW5FV3NZQVJiaUUvdlNhUExVWEhPaEYyQmlE?=
 =?utf-8?B?ZUZEbldqL0pTWnhPYUE2djlwSFNwTFQ5S3pYaXU1S1V5TTlxMWxNaUZxdnY1?=
 =?utf-8?B?M0VpOUx1VmlRaGVaSzA2TnJuaTdHdXVXU0NHN3dWbkNqQ3NWS2JxcWdadkdv?=
 =?utf-8?B?UmcrODgrNm9scHJVQ0xQYVBySWlyQWljY1p2YkxVVjZuR0NEN3hFRFRtd0Vk?=
 =?utf-8?B?ZXA3WXN5UDBMM0Y5dlZiSDY3VnFaT0V1bmlhd3pFQlV2VUp2Y2ZDRDVHMXdw?=
 =?utf-8?B?VnpoZ25yVTFDNVRZQ1FyTFRSOVJURW1tdldwV3VvZVNlTHcxVFREUUtiSDZu?=
 =?utf-8?B?SVJEd1RiQjJYZjhsMTZOcWNjTHNkTFJ6UEw0emNhazk5eUpwUG5DQ2I3Q1NI?=
 =?utf-8?B?NE9jeUVUQUozaWN4ZE42dG5iN3V4WG1TQlJwbS9qWUFSQW1sSnlhYWY1YkJl?=
 =?utf-8?B?NEk1elFjWUtVdWpsbHQ5RitBdjFESVZxbC9zR3ZPb0w4eE1YNTFqUysycVdl?=
 =?utf-8?B?eE9sSWtQZ1NWMWxydDJLT29ka0Q5aUZ1Vkk3QUNnK2tkRERNaUdSV09KT3Na?=
 =?utf-8?B?SzVhbkFnMnNZaEFqMUtmWXhvZ0JGUHl4UitnV0o2UlVObnZkM2VKVkN2RUtK?=
 =?utf-8?B?TFVjN1oxVkdlczJ1a09XN0pOQXVyak5XV2s2NEVQRDRIVkJHTFJxVEl3Sklj?=
 =?utf-8?B?WWVRWGpkZ1lNaGlJeDRFRThHQk1YTUo4TVErekNUZWFYYUptb0VzNWRVOUdz?=
 =?utf-8?B?UEJUbTMzaVZaUkRHcVlsQ2p5YlNEM1ZiWE8rc3R5YXpPak5ZOUxVckM4WFdI?=
 =?utf-8?B?UjhkaWJQUTRxV05FV2p3bnFGanJYYmpWaDFIOXhIc3IrTXVYSm1xNkVYaExa?=
 =?utf-8?B?WSs4T2IyQlhKajZHZUR6ZFU2c0NVNkFoTTFibXpveENnMUZlM0lZOVUrR3V1?=
 =?utf-8?B?SDZ6V0tqeUJSb0p4ZEtpNzNuWjUyREFxKy9QUGFENmlTek82YXRWazlpaFNQ?=
 =?utf-8?B?MW1XWU52N1RTaEFuV2Y1VlVuTnB0SmZTRmlIcUxoZHpoODRBYzZnemszWSt1?=
 =?utf-8?Q?q/hISut3ghS1Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fb22e3d-724a-41a0-e79a-08d8bf3c1599
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2021 01:13:25.2663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tvhHivZ53/Dx8cJFjWxxIiRZQNkzEOZzQXsj+IprGqicdpO/g4lEutpUU/K/uYAIKgYNoeWkKaUcUYsmxPaGho7UgbAFqUHPqv7d4gsNmc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5105
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
bGFuXSBbUEFUQ0ggdjMgbmV0LW5leHQgMDUvMTFdIGljZTogbW92ZSBza2IgcG9pbnRlciBmcm9t
IHJ4X2J1ZiB0byByeF9yaW5nDQoNClNpbWlsYXIgdGhpbmcgaGFzIGJlZW4gZG9uZSBpbiBpNDBl
LCBhcyB0aGVyZSBpcyBubyByZWFsIG5lZWQgZm9yIGhhdmluZyB0aGUgc2tfYnVmZiBwb2ludGVy
IGluIGVhY2ggcnhfYnVmLiBOb24tZW9wIGZyYW1lcyBjYW4gYmUgc2ltcGx5IGhhbmRsZWQgb24g
dGhhdCBwb2ludGVyIG1vdmVkIHVwd2FyZHMgdG8gcnhfcmluZy4NCg0KUmV2aWV3ZWQtYnk6IEJq
w7ZybiBUw7ZwZWwgPGJqb3JuLnRvcGVsQGludGVsLmNvbT4NClNpZ25lZC1vZmYtYnk6IE1hY2ll
aiBGaWphbGtvd3NraSA8bWFjaWVqLmZpamFsa293c2tpQGludGVsLmNvbT4NCi0tLQ0KIGRyaXZl
cnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfdHhyeC5jIHwgMzAgKysrKysrKysrKy0tLS0t
LS0tLS0tLS0gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfdHhyeC5oIHwgIDIg
Ky0NCiAyIGZpbGVzIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDE4IGRlbGV0aW9ucygtKQ0K
DQpUZXN0ZWQtYnk6IFRvbnkgQnJlbGluc2tpIDx0b255eC5icmVsaW5za2lAaW50ZWwuY29tPiBB
IENvbnRpbmdlbnQgV29ya2VyIGF0IEludGVsDQoNCg0K
