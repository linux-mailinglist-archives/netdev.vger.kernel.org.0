Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4104192A2
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 12:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhI0K7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 06:59:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:42255 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233848AbhI0K6x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 06:58:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10119"; a="211701203"
X-IronPort-AV: E=Sophos;i="5.85,326,1624345200"; 
   d="scan'208";a="211701203"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 03:57:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,326,1624345200"; 
   d="scan'208";a="456215212"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 27 Sep 2021 03:57:15 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 27 Sep 2021 03:57:14 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 27 Sep 2021 03:57:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 27 Sep 2021 03:57:14 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 27 Sep 2021 03:56:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIrbsuoUwrbfROInGvGQfV8RR8yYh4iPDYhEoYk8hlFvDW8CYzrWJlY6/6ZTA58LLDJ92kVPhEqSxuj4Z1NiZwzMGOgyeFJ4bZmmtvMledzpa0fvJHZQJPL1A9Kv9riP4N1y6724yj9C0Rp915KQqe0gb9h8defBPVZCsppnLoFMUY8En06UidxKsz0jiI9QeQlwbDLJZk73s0T3sydotlNStwcgjYTufmnmshb5ur6pNA2oz/8SUh/HK1+lpjU/DWjQGU3sy+2vAy+29SacnrBpVKr/lXDwoQYbJ/FWeTNnc8ECk4EwbSwRYzrvsaCzYSpS1x+qv+owhSKjSg0nSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=FMzio8NQ1KU9x+jRBfaGgGKwN8VQ0OPwMi0/SGK8Q/8=;
 b=mWRlLxg35DhmghCDmmks9KuSnIb7tuwjSIBxZtG12dt9UIG8COkuoU7EQB25JkyMEoiDhHwj2WJWbj72lENHSO5L7tei8oFEhyxMWxukbJBU3V0zKpzvnXcX4zrTRuLeob+Gu2xqqjKeC0nJqR5eokYqF0ZSGO479zAEK2uFHrfpyfCHO1SC3QqxTcwLuq8gdH5ee0QWVa6BhqFDoU/L2HnedS5z9/QWPncn9//eMx1q73BkhxSXTIN0eZuNAdSFTwQ1KDUN0rKUJhJSCTJnqkfaEhldHX5PsfDc6vgBGbfuANIKnLLseOnzZFcEseBLo8uxdkiz4pfVeywf2MHT5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FMzio8NQ1KU9x+jRBfaGgGKwN8VQ0OPwMi0/SGK8Q/8=;
 b=m0vkE0Svve8gRdgHDGhGRddhcPXazHDuEItUdA1XT03ZPXccZU3xlAds04IQmgZAhc5bkgq6qVf2f/XJ/aru9XSVQYjUE5hpq9W9dTDgAvW9bsNys4IstP8q4qJLmH4UrCDM0YNPsWN62ucQ8ACckit+YXDsG3dLg6Ypug2XSBg=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (20.177.184.142) by
 BYAPR11MB2695.namprd11.prod.outlook.com (52.135.224.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.14; Mon, 27 Sep 2021 10:56:50 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::582c:29ff:d42b:ac52]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::582c:29ff:d42b:ac52%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 10:56:50 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "vladimir.zapolskiy@linaro.org" <vladimir.zapolskiy@linaro.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "felash@gmail.com" <felash@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3] iwlwifi: pcie: add configuration of a Wi-Fi adapter on
 Dell XPS 15
Thread-Topic: [PATCH v3] iwlwifi: pcie: add configuration of a Wi-Fi adapter
 on Dell XPS 15
Thread-Index: AQHXsT7P+1nMqJX27kueWNPRcUpJS6u3ukCA
Date:   Mon, 27 Sep 2021 10:56:50 +0000
Message-ID: <eb29d1f95a51ae34153517538d47b945816884c9.camel@intel.com>
References: <20210924122154.2376577-1-vladimir.zapolskiy@linaro.org>
In-Reply-To: <20210924122154.2376577-1-vladimir.zapolskiy@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.3-1 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9cd600d5-b06b-4597-8047-08d981a5824b
x-ms-traffictypediagnostic: BYAPR11MB2695:
x-microsoft-antispam-prvs: <BYAPR11MB2695091BF3F39220DBD686EE90A79@BYAPR11MB2695.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NMPOYpCtPr4Zytd41W3Olf7aw630BcmPdA4aYCAr5q/CUZai2Onw47EBo0wRuSMI5FADaKCwEaaR/L+FdkqVoLUHJ19w4eqUMFnnXG6+T4kJ7AOQBVgNlHq1SN9Ae0fEak+t9KOrcvMVrt9jFzyYpqs8iohD5TXcDrxaoKjQp3oKUlxxJnDEj4XF3Y2e+NGIs1jXn3HCN8N/9nB8ocDzlEZb5uNcqVGUhNaedyFkmTbvoG7ZT5/ChiQEWK1CMmaCaqaNMncAVOTlrq/MEd9ffRL7qbV4pF29TNBBpRGTA+OaMO9ddthFHGkqibD6n8UEuDyGgcpAB4pHMmjecSVw0Vw5YxEel6t2Kik5EUIW9FiTh9F4fT4qc259yWZU4ZcYUCeUedkACVFzZ82Jn+LwmoHvpqzrlLDfNGfuybhhQkC9d68y8ADoiKFUABGArPG7//DLJIuc+4VdDCK69MX6KNJa7I1pBDI179FtlgOP2kJqOExvJ9SOcL54mGovQpZwKI41hv2n/WCoJiv+fVcmKyDrKQCMw2J6HBIpqrin+YFZ9ClXgu2QXIzro5GSjTINhE3+281bwc7QW8zbGGhB8JvXjxpdFXP3Y5W+b3ciIvuCdJxR578KQNuLVjZP1jptMEYr4igCTNMmSOEpj4XE1zB+6v4W/91gTdLYggQgTArsm0nEUehWS31W790d+hRjMPpjGr9f1K7mtt37/5Te5HKJcoFKtGF6433rGzJpyMzslg7MrHuQLx33aMAtfXuPIXkjagE0qHrYuSvh5cthYHCoYq/zdEBwMJnGbunm6T0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(66446008)(186003)(8936002)(66476007)(6512007)(66556008)(2616005)(83380400001)(64756008)(26005)(86362001)(38070700005)(2906002)(508600001)(8676002)(110136005)(38100700002)(66946007)(6486002)(76116006)(36756003)(316002)(6506007)(4326008)(966005)(91956017)(5660300002)(54906003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXNHU0RWaEVJN0pnTEo3NExHOC9DQ0dXYTlrUkVDNEtEY3praWw3MjEvWEs2?=
 =?utf-8?B?SDlNS2hBV3k2Z3Vocy83RWxYY2FTYk5nR2paM01SZ3pJTy9FL1BKdXJZYUlZ?=
 =?utf-8?B?RWRHd0tFTC9LejFsd242QWVjQkhETHFrZTBJRkU1ZmJFTGZsQnFOUEhZZy8x?=
 =?utf-8?B?T2Y0RVZ3MUt4TEhneTN4UytsMERCb0c5WEhpcjRoRUtHaml2VFR6K2Y4Nmsr?=
 =?utf-8?B?VGZSN3F4SVlKWmF2RndVOHA2a3VzRUc3bzRnakZQMm9iK2RsL0N3OXJJRmpj?=
 =?utf-8?B?SmlidlZaK3Ywb0FoaDRtaWdWalBXN1RxMjVMTmxiTm9EMG1WblkvWlpvTHEy?=
 =?utf-8?B?OGdSektwMnlldlQrWXBhQ0xEYkJmN3RqZVdQS3ozOFZDTERFeHdnWVlRU0ND?=
 =?utf-8?B?L21RSU5zVkFCd2UxZTVTZCt2Slg4aUhFY2dvTFZKbmxnZTNiU2Y1MXRrU1U2?=
 =?utf-8?B?cUI2Vy8yR2h0SmJ1WjRsRVEvTXlFNEVXQTVGZ3g1TmNOY3hPQ04zR3JxNVJQ?=
 =?utf-8?B?ZHdBSmJ6Y0RWUGpoR1hWVTE2clc0VzV5SDVuUDYzL0QxZCtPazFvYnVDZERE?=
 =?utf-8?B?SWgzR3ZvbGpidWwzNHBoL25hQVc0TEhmeEM0cERIQ1hWUEJiTnY2QjRwZjZj?=
 =?utf-8?B?K2FkYko0QzJlOFVxR2lhYnlpWFRkV1hRT3hCeDdkRGp3VnZWRmNITFYxdzd4?=
 =?utf-8?B?M3JHUnNqUEkyUkk4V0lqZllFb202elUrMVkzalBYcTUyakRaT09GeW1mR1ls?=
 =?utf-8?B?YWx3UzhKY21nOGxYSUVFV3RjUEk1ank3RVMrT2JrdVgzWEVIT1hYcUlEZTJQ?=
 =?utf-8?B?SGdhd3NxTWdpREZ4WDF0UWNlZUcva2piR0JmaG1xRi9JOW5ka2JjWDBZbGY3?=
 =?utf-8?B?YU5Nb0FzcUpaLzVFalM1cldPUXR0Rit4bzdwNEVpMEgzTHJ5RDhCbzIzYjVx?=
 =?utf-8?B?RTJXYzdYR0syM3dXRGpUWDRYYXZMQnJjVWN5bDBqVWN2UjVnUTlyN0x5QktM?=
 =?utf-8?B?bmxNV1NMS1VMbUhZRWowd051amNyb1g4clNzVmF3OHlJTnplUVA3YkJlM1F5?=
 =?utf-8?B?cU5CRjBPMUJ4TndLU1l1MjdxN3BDZy9RRnhOSEUzclYwUyt3R1hVL0N2SFVB?=
 =?utf-8?B?eU40aC9VWlI3Mkw3MVJyNnUzcDc5N0lHV0o2WlJiNmRXKzFjSWpkSlExYnlH?=
 =?utf-8?B?S0xieVkwa3paKzFrdE5sVnlmb2lnVWNIVDdtSWJ1azYzdkRiTmNFVU1ML29B?=
 =?utf-8?B?SlRNQ1NZd0F4UmRiRWlrQ3ljVWxCVTZFTkFKQ09yUldxTzJMZVo5TDFQZzhl?=
 =?utf-8?B?Q3lYejJwZk8ySGdMbEY5aVFxcDdwZ1dpZklQWmdBRVBWWkw1aGNkd2lEOEZp?=
 =?utf-8?B?STY4dVp3YnVnTHFaWEFKTHQvMWpxSDZmZWMrQTZVQjRpUzEyZDQwMFd4clhj?=
 =?utf-8?B?clhqVU53WWszQWw2ZEttMStTT3VWNVM3bXFsdWFCOS9vNFBwc3UxbVdBMnY0?=
 =?utf-8?B?TnczZ1RVOVZtbjZSbkVFUDJjMG9xOWpJOGp2bjRXZUhNOWhibXU5TzVidG11?=
 =?utf-8?B?RkFXZTRUMXNoMHk2SHd3VlgvZERTaFhsekROY2thQ1FuY0RXY05MUWRrNCtZ?=
 =?utf-8?B?YkFWTDA2OWtId1pMNDVjYkFWa2ZzUlFHRnNWOFUzN3NuNUVDaHJ2VitndmE1?=
 =?utf-8?B?TXdDK2VmaEQrU0tweW1ZRmp1OW10eWhqcUZOdjZRMnhWK3hiS3NkdGRFZEcv?=
 =?utf-8?B?enQ1anNCZkx2M2pSVENPSjRBeHAvZmNKUFk5bnFCSkNCNU1YQ3pmM1JLbC8w?=
 =?utf-8?B?N04xbkluNGZnTC9HL215QT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A43C834A645A8443A29381F5193950BB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cd600d5-b06b-4597-8047-08d981a5824b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2021 10:56:50.3469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t10cbuW7M5aO/bv3KtwuiN1KPYXFhYZ1awlyQ/ZpH+A4NJMkqydv0Vl29wtdUuYSuCMQC8T0cFtpnbybt2ma0VXwDROtm5N3DbyKCdsDNck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2695
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTA5LTI0IGF0IDE1OjIxICswMzAwLCBWbGFkaW1pciBaYXBvbHNraXkgd3Jv
dGU6DQo+IFRoZXJlIGlzIGEgS2lsbGVyIEFYMTY1MCAyeDIgV2ktRmkgNiBhbmQgQmx1ZXRvb3Ro
IDUuMSB3aXJlbGVzcyBhZGFwdGVyDQo+IGZvdW5kIG9uIERlbGwgWFBTIDE1ICg5NTEwKSBsYXB0
b3AsIGl0cyBjb25maWd1cmF0aW9uIHdhcyBwcmVzZW50IG9uDQo+IExpbnV4IHY1LjcsIGhvd2V2
ZXIgYWNjaWRlbnRhbGx5IGl0IGhhcyBiZWVuIHJlbW92ZWQgZnJvbSB0aGUgbGlzdCBvZg0KPiBz
dXBwb3J0ZWQgZGV2aWNlcywgbGV0J3MgYWRkIGl0IGJhY2suDQo+IA0KPiBUaGUgcHJvYmxlbSBp
cyBtYW5pZmVzdGVkIG9uIGRyaXZlciBpbml0aWFsaXphdGlvbjoNCj4gDQo+IMKgwqBJbnRlbChS
KSBXaXJlbGVzcyBXaUZpIGRyaXZlciBmb3IgTGludXgNCj4gwqDCoGl3bHdpZmkgMDAwMDowMDox
NC4zOiBlbmFibGluZyBkZXZpY2UgKDAwMDAgLT4gMDAwMikNCj4gwqDCoGl3bHdpZmk6IE5vIGNv
bmZpZyBmb3VuZCBmb3IgUENJIGRldiA0M2YwLzE2NTEsIHJldj0weDM1NCwgcmZpZD0weDEwYTEw
MA0KPiDCoMKgaXdsd2lmaTogcHJvYmUgb2YgMDAwMDowMDoxNC4zIGZhaWxlZCB3aXRoIGVycm9y
IC0yMg0KPiANCj4gQnVnOiBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dp
P2lkPTIxMzkzOQ0KPiBGaXhlczogM2Y5MTBhMjU4MzliICgiaXdsd2lmaTogcGNpZTogY29udmVy
dCBhbGwgQVgxMDEgZGV2aWNlcyB0byB0aGUgZGV2aWNlIHRhYmxlcyIpDQo+IENjOiBKdWxpZW4g
V2Fqc2JlcmcgPGZlbGFzaEBnbWFpbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFZsYWRpbWlyIFph
cG9sc2tpeSA8dmxhZGltaXIuemFwb2xza2l5QGxpbmFyby5vcmc+DQo+IC0tLQ0KPiBDaGFuZ2Vz
IGZyb20gdjIgdG8gdjM6DQo+ICogc3BlY2lmaWVkIG5hbWVzIHRvIHRoZSBhZGRlZCB3aXJlbGVz
cyBhZGFwdGVycy4NCj4gDQo+IENoYW5nZXMgZnJvbSB2MSB0byB2MjoNCj4gKiBtb3ZlZCB0aGUg
YWRkZWQgbGluZXMgaW4gYSB3YXkgdG8gcHJlc2VydmUgYSBudW1lcmljYWwgb3JkZXIgYnkgZGV2
aWQuDQo+IA0KPiDCoGRyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvcGNpZS9kcnYu
YyB8IDIgKysNCj4gwqAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9wY2llL2Rydi5jIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9wY2llL2Rydi5jDQo+IGluZGV4IDYx
YjI3OTdhMzRhOC4uZTM5OTZmZjk5YmFkIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9pbnRlbC9pd2x3aWZpL3BjaWUvZHJ2LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvaW50ZWwvaXdsd2lmaS9wY2llL2Rydi5jDQo+IEBAIC01NDcsNiArNTQ3LDggQEAgc3RhdGlj
IGNvbnN0IHN0cnVjdCBpd2xfZGV2X2luZm8gaXdsX2Rldl9pbmZvX3RhYmxlW10gPSB7DQo+IMKg
CUlXTF9ERVZfSU5GTygweDQzRjAsIDB4MDA3NCwgaXdsX2F4MjAxX2NmZ19xdV9ociwgTlVMTCks
DQo+IMKgCUlXTF9ERVZfSU5GTygweDQzRjAsIDB4MDA3OCwgaXdsX2F4MjAxX2NmZ19xdV9ociwg
TlVMTCksDQo+IMKgCUlXTF9ERVZfSU5GTygweDQzRjAsIDB4MDA3QywgaXdsX2F4MjAxX2NmZ19x
dV9ociwgTlVMTCksDQo+ICsJSVdMX0RFVl9JTkZPKDB4NDNGMCwgMHgxNjUxLCBraWxsZXIxNjUw
c18yYXhfY2ZnX3F1X2IwX2hyX2IwLCBpd2xfYXgyMDFfa2lsbGVyXzE2NTBzX25hbWUpLA0KPiAr
CUlXTF9ERVZfSU5GTygweDQzRjAsIDB4MTY1Miwga2lsbGVyMTY1MGlfMmF4X2NmZ19xdV9iMF9o
cl9iMCwgaXdsX2F4MjAxX2tpbGxlcl8xNjUwaV9uYW1lKSwNCj4gwqAJSVdMX0RFVl9JTkZPKDB4
NDNGMCwgMHgyMDc0LCBpd2xfYXgyMDFfY2ZnX3F1X2hyLCBOVUxMKSwNCj4gwqAJSVdMX0RFVl9J
TkZPKDB4NDNGMCwgMHg0MDcwLCBpd2xfYXgyMDFfY2ZnX3F1X2hyLCBOVUxMKSwNCj4gwqAJSVdM
X0RFVl9JTkZPKDB4QTBGMCwgMHgwMDcwLCBpd2xfYXgyMDFfY2ZnX3F1X2hyLCBOVUxMKSwNCg0K
QWNrZWQtYnk6IEx1Y2EgQ29lbGhvIDxsdWNhQGNvZWxoby5maT4NCg0KS2FsbGUsIEknbGwgYXNz
aWduIHRoaXMgdG8geW91IGFuZCB5b3UgY2FuIHRha2UgaXQgbm93LiAgVGhhbmtzISA6KQ0KDQot
LQ0KQ2hlZXJzLA0KTHVjYS4NCg==
