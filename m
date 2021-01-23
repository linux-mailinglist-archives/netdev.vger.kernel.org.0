Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC273011F3
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 02:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbhAWBRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 20:17:51 -0500
Received: from mga17.intel.com ([192.55.52.151]:10991 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbhAWBRc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 20:17:32 -0500
IronPort-SDR: DbFnzLy55d0ENZhtJIfZOuefsczDxpLE1bHxJDhlm/ql8YFzzm7KYZltoOaSMTRFrvln2cadIJ
 S4LxvbEzkTNQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="159309253"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="159309253"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 17:16:48 -0800
IronPort-SDR: nDaIpVV9s4Gpy2yzBXtHePPJAotJVIxQjnM8fcSpdhgPk3cZHwvkmznBzaDxDwnJAZZ0xs29Ly
 DCk7AwMaSMuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="503255270"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 22 Jan 2021 17:16:47 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 22 Jan 2021 17:16:47 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 22 Jan 2021 17:16:47 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 22 Jan 2021 17:16:46 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 22 Jan 2021 17:16:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PSwSrJfCO2qZaxbG3UM2NqBYVPajV1M5yvJtFzY5MzHladUDZJiioRjlvfdIdxpk5QqMpVefAhI6tk39OY0IpxkTYqbsXUgy52N9IlwhjXHzmavpkoezirBhV8PDdr6ppOFtlfNx3hnztwK5GE3oFYM183uanFPChCd/ixxy5fDbvPTbsjDkTGUEgLb91NfQ4cDAaKF+m9b9m10OrF543HYTF4KEG1s7e3S+JkaTQdYk5wPhB2WQJUmPMSiUSVpozsH/joGOr+z2lE5IdcgHqM6I6fVEdQzjHwtn3zHOZBxwsf3dAPbZejkrICmteg7AjKAmYcfzAlJGyUKD9TkfqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGD/SoiDf0Wbx0BpqIgJb1D26EVf8k8gjpqTRR+Fl+E=;
 b=SMA+KhANoOlzvjjFKQjKqwXoy4yYPC2NuP5+MGtzVasqOigPgha6SPVB+O/rWDMdj56BXYl5nm2eRlyQziiHV2zo+rP954I5YJpP6ldQSHMPKW4RJyFYrf89p+BSluGto/sGgk49/kqV+4pE+hg6nqrevoEhMgCDBUgrKcEE1Fy4ySSvQvG15AHyes3jYgOlBVSTaO3thPmeXaydXwi/2ypekNjvbdKZ51JBLaAP3uGXIRDJxh66SnDmbiCFb/3q13pzTPn3JxvUl6RBTIKcMbpkmf/RIORvRnqtPtxtrEwTw+oeB/DknU9nNP+Q5RZUpKOLF5IWfCo0c5AwSy2rSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGD/SoiDf0Wbx0BpqIgJb1D26EVf8k8gjpqTRR+Fl+E=;
 b=aDyVc6f2hYrVH7f84E5neuPeuLheV/MdnfiqRpz3z9R6b+RZ/1EwRt80vF1MFOS44NuNvxl8jGxuC5DgvPWik1DO9CL2F+Knlo5mjTKJky4Ik1Or+UfmI2MvOj26kNwSycGumRY1tFzjADDgGfzpeSDQ1eTKyUwH3+pc7zxDtgY=
Received: from CO1PR11MB5105.namprd11.prod.outlook.com (2603:10b6:303:9f::7)
 by CO1PR11MB5105.namprd11.prod.outlook.com (2603:10b6:303:9f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Sat, 23 Jan
 2021 01:16:43 +0000
Received: from CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::fc66:dd19:b156:7090]) by CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::fc66:dd19:b156:7090%6]) with mapi id 15.20.3784.015; Sat, 23 Jan 2021
 01:16:43 +0000
From:   "Brelinski, TonyX" <tonyx.brelinski@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v3 net-next 10/11] ice: store the result
 of ice_rx_offset() onto ice_ring
Thread-Topic: [Intel-wired-lan] [PATCH v3 net-next 10/11] ice: store the
 result of ice_rx_offset() onto ice_ring
Thread-Index: AQHW7a3nKUko5NEv60KuJs+S3g0UlKo0by9g
Date:   Sat, 23 Jan 2021 01:16:42 +0000
Message-ID: <CO1PR11MB51056372C125FC21F669DE4AFABF9@CO1PR11MB5105.namprd11.prod.outlook.com>
References: <20210118151318.12324-1-maciej.fijalkowski@intel.com>
 <20210118151318.12324-11-maciej.fijalkowski@intel.com>
In-Reply-To: <20210118151318.12324-11-maciej.fijalkowski@intel.com>
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
x-ms-office365-filtering-correlation-id: 0f9b3c42-47db-4558-02fd-08d8bf3c8b68
x-ms-traffictypediagnostic: CO1PR11MB5105:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB5105ED29785080789BA15737FABF9@CO1PR11MB5105.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:619;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qUq7OPO6iK0ZTybkFKXd3GzXpo5IeHsU2Bj/EEsaEEQhCrhjwtqTfJsZBZdO9RRoxNCdd5jv29kg9M3XYWMVMpbXksgGVB1KLBjsaLL58j6mI1lDJVO3PgLatvSREVuj63I+Y7t261YFc1GSARfQTZ3QtiNjXv6HlOnipos//BYWQIGPQHtKpPIE60LYgTzgcGrjD5iIczUgD3HX35mBTiaKGYUM470HFNTnEu2P+OOmHK8mQeKnBVY2gXVGvYLa9M/mq956aeGaBoWLwr+oJOPjfTKPmwo63f5vTEzn9SJjLQD0U1s7ndBNPkdWiS/OjTLNqHEiXxgNpS6WS2BAb4tpAJZ2zGQeHk2oU1FgbNtVTLJJZ8CeOe7h339Vtum7x6IWuHGlBegYeSpJw6JyeA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(64756008)(66476007)(5660300002)(66556008)(316002)(107886003)(2906002)(76116006)(66946007)(54906003)(66446008)(83380400001)(71200400001)(26005)(7696005)(53546011)(86362001)(478600001)(8676002)(9686003)(186003)(8936002)(55016002)(6506007)(110136005)(52536014)(33656002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?R0o0QnZmNi80WEpyMHhZZVVKWHdHRnlSSzFrS3h1MjBwcDZSV2xiUVAyQlpJ?=
 =?utf-8?B?M2JaQnBJemwyRmJ5TDFlUTJhNlNwV1hTSUtyVFkyQUNLV3B3NmwwcWE5SDkx?=
 =?utf-8?B?d2M1S3Z6b3dEZUFla0VzNFg3SzdidG5abC9rNHFDbnVucVlNMEpscDhsU2JE?=
 =?utf-8?B?RC8rRlNpcnpHVlhobHhNcmhEMjAzWXRBcWNVczJEQmMzcW41TnZBQklid2pT?=
 =?utf-8?B?NHdJWTJkOWRuMEZXa2tIdktUMFBxdXZsemJDb3NhbzI1Ykk5eDB5NEo4Z1Er?=
 =?utf-8?B?ZUVIanlZZzBETGFtYjBjK0FrNUo3TzJJMHF0MmV2UlBadktUOTEzNXpHcXNC?=
 =?utf-8?B?MDAzUkwveHk5U3lRL1hDZlJrcjdmUGoza1JIeXkyRllSaDVZSEJodXl6WFN4?=
 =?utf-8?B?NGxRZFhlK2ZHTnltbmt4TmtJd1pPek5WRGorNngvTFFUUGNZZCtoTnYyK0RE?=
 =?utf-8?B?Qml0eTRHVWJBdU55cjArek1mc3luN0N3OUdNclNiQzF4WmNzTUlublNEUXc1?=
 =?utf-8?B?YzZycTZUellpQzZzWlI4Q3ZnemRRakhRQjZDcnNlVGdPUnQyY0x0ZlM4MDlP?=
 =?utf-8?B?Y0daMEw0bGUvRnI0WkhIclRmbFJBa0RiNnVMTEZxcHlQMTZicEdXWU1ublVv?=
 =?utf-8?B?OTFnZmpZYkxJUi9JaGMwdFNOdlBZamdoTHFXTHlUMmxkMHA4ak1MMVQvVnNI?=
 =?utf-8?B?MUt5MkYvZmtCTEE5MnJaSEI3eGdxd3NDVnZLUkhZMUtIMVRBZ004VDlOV3VH?=
 =?utf-8?B?NXBNNmJuVUhOTXE5dWEyaTBsaytJU2dYRFF1OW1BSXczdzU1bmZ5WTFsR0N4?=
 =?utf-8?B?QndESWc4K1RuUXYxUTFQdG8xQ1c4UXRJajdTTGh6WGk5ZXFsTHJQT0hueUlI?=
 =?utf-8?B?MGNSd1JTRnRqSXBoV0R0cjJ4Q0FKVkcvaEZXOWdoT3BwVGJmQ0JjeDNyTDhM?=
 =?utf-8?B?b1FGWEdWUkRHUnJCUVo0bXlYR1RraUZOaHdBODY0MWp5LzhYa2Q3MkJMRDBH?=
 =?utf-8?B?N1JCNWRiMWdkZXhqcmUrQmFTQmZpbzhUMndjdFNGWVZvQU5GaE1qOFhWNU9Y?=
 =?utf-8?B?VXBkbGFMVlM3QUlHUG5SWTRReU53NGZBU1BXcEloSm5RcFN1YVV3RURaU0tq?=
 =?utf-8?B?dGRSbis0czJRUEs5UCtDMlQ0aVpTdXFZNWVIVWhBa1VJemhDQW1QZDBsRlNn?=
 =?utf-8?B?a0w4dHR3cTh3RTdrQjRDRUV0c0JCOWNGWW1IZHlxalFrbW5QdlB6azdtQ25h?=
 =?utf-8?B?MjVRYXViY2tPQ2h4dHdGbE9OMXdrN2Y2WWhTeE5kUTVKUEY5Tk9ibi9hUzJI?=
 =?utf-8?Q?7JKxeK+e0WQuM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f9b3c42-47db-4558-02fd-08d8bf3c8b68
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2021 01:16:42.9274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MRGuXCm8aUbpd71I24BH/lSOVj8480hMUOYvu2ABX0T/Dlp4VfPoflmKdkYs+IgUDSUJWPSatONFHamEKrYvSv8QKP3FNtAIepaCek6VHCc=
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
bGFuXSBbUEFUQ0ggdjMgbmV0LW5leHQgMTAvMTFdIGljZTogc3RvcmUgdGhlIHJlc3VsdCBvZiBp
Y2Vfcnhfb2Zmc2V0KCkgb250byBpY2VfcmluZw0KDQpPdXRwdXQgb2YgaWNlX3J4X29mZnNldCgp
IGlzIGJhc2VkIG9uIGV0aHRvb2wncyBwcml2IGZsYWcgc2V0dGluZywgd2hpY2ggd2hlbiBjaGFu
Z2VkLCBjYXVzZXMgUEYgcmVzZXQgKGRpc2FibGVzIG5hcGksIGZyZWVzIGlycXMsIGxvYWRzIGRp
ZmZlcmVudCBSeCBtZW0gbW9kZWwsIGV0Yy4pLiBUaGlzIG1lYW5zIHRoYXQgd2l0aGluIG5hcGkg
aXRzIHJlc3VsdCBpcyBjb25zdGFudCBhbmQgdGhlcmUgaXMgbm8gcmVhc29uIHRvIGNhbGwgaXQg
cGVyIGVhY2ggcHJvY2Vzc2VkIGZyYW1lLg0KDQpBZGQgbmV3ICdyeF9vZmZzZXQnIGZpZWxkIHRv
IGljZV9yaW5nIHRoYXQgaXMgbWVhbnQgdG8gaG9sZCB0aGUNCmljZV9yeF9vZmZzZXQoKSByZXN1
bHQgYW5kIHVzZSBpdCB3aXRoaW4gaWNlX2NsZWFuX3J4X2lycSgpLg0KRnVydGhlcm1vcmUsIHVz
ZSBpdCB3aXRoaW4gaWNlX2FsbG9jX21hcHBlZF9wYWdlKCkuDQoNClJldmlld2VkLWJ5OiBCasO2
cm4gVMO2cGVsIDxiam9ybi50b3BlbEBpbnRlbC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBNYWNpZWog
RmlqYWxrb3dza2kgPG1hY2llai5maWphbGtvd3NraUBpbnRlbC5jb20+DQotLS0NCiBkcml2ZXJz
L25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3R4cnguYyB8IDQzICsrKysrKysrKysrKy0tLS0t
LS0tLS0tICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3R4cnguaCB8ICAxICsN
CiAyIGZpbGVzIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKyksIDIxIGRlbGV0aW9ucygtKQ0KDQpU
ZXN0ZWQtYnk6IFRvbnkgQnJlbGluc2tpIDx0b255eC5icmVsaW5za2lAaW50ZWwuY29tPiBBIENv
bnRpbmdlbnQgV29ya2VyIGF0IEludGVsDQoNCg0K
