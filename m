Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4543F55EE
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 04:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhHXCp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 22:45:56 -0400
Received: from mga06.intel.com ([134.134.136.31]:46903 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233796AbhHXCpu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 22:45:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="278233484"
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="278233484"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 19:45:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="683713481"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 23 Aug 2021 19:45:02 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 23 Aug 2021 19:45:02 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 23 Aug 2021 19:45:01 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 23 Aug 2021 19:45:01 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 23 Aug 2021 19:45:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQo9rzwz6FHk8/G751ttLr/IUSiSXcS0Bz6OyEatseviQoO2qOyvlA+cainlHiRRzVMU/JlP5BDkxeph29La/BdGGeD5FiZgQPuJ8Gl6TC34onGmliqBdAe31bLwWOmhl6P/Eh4anCKDx33n5Y3ZrxVnbWNwIQLz95nCwexvAZ2uaa7yoP/1gTi8FYcOZly5XLqQp81C/QAjIH5/qOe0PZJWplmlbqetYWMAwrKy7z5j0JYg/9CdbEO/PyZEIC6X4zcZECganm7f8Jjlid90qIWUrHnFj0biIXTZTrNuAmahq+pnSHSVpOwTZtA6OIUa7XMqyRJHVEqTLeuzmoIpeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KT8d/RohumGPc5mVaZ3XI1h5KQbU2Mk2bhD/fYxSH8A=;
 b=iPZt6mw3JuGzQ5BPwRS9GAgp05Na8MQRAR6/1uKoUk3UPx/wiPuPt6PYYfq8GvY0DwAwSKzoPEA2w038LoHO3taP8VGt1CGLeggvCy3Yjf92+32S/9eZ1T6Cctdi8admOV9X54uHmfvQDQDUctfKJT/xgIzr4SAquqvL7AkznnIrzVBkpVtwIIuQ7bFWAanqOfWQu7l17WqsOLnS2lF8La3IqTpkS7EwzIpBK7zqZsp2f2+6/Cesu2ZOnlrokKtD7Kna18WGrb4gcV2XOoNadZGSVk+Wv2iKR7OuwUZ0eQCQo4+Ncp/OPJtk6qhioSrDtnTOZVLDHJrUoLNjHg9ckA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KT8d/RohumGPc5mVaZ3XI1h5KQbU2Mk2bhD/fYxSH8A=;
 b=CpdJhtQxNi5YRYxxEQOXE0zAoKVbKHm3BHo+UNcQxKTVybsi0sb125Uia2IDJnsHRMtq3VtAuHAoCloSqxZWKHR62Tw25b+hLmo1GWZd1k1UMSsXvBhfVx47DDP6i6NgjK2p8Mq4BGvhIzBCfAV04/rqutdnIY88so1Zq4C0u6E=
Received: from BYAPR11MB3224.namprd11.prod.outlook.com (2603:10b6:a03:77::24)
 by SJ0PR11MB4864.namprd11.prod.outlook.com (2603:10b6:a03:2d4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 02:45:00 +0000
Received: from BYAPR11MB3224.namprd11.prod.outlook.com
 ([fe80::98b:d3a5:6818:3194]) by BYAPR11MB3224.namprd11.prod.outlook.com
 ([fe80::98b:d3a5:6818:3194%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 02:45:00 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "acelan.kao@canonical.com" <acelan.kao@canonical.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC:     "alobakin@pm.me" <alobakin@pm.me>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ap420073@gmail.com" <ap420073@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "weiwan@google.com" <weiwan@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
Subject: Re: [RESEND][PATCH] net: called rtnl_unlock() before runpm resumes
 devices
Thread-Topic: [RESEND][PATCH] net: called rtnl_unlock() before runpm resumes
 devices
Thread-Index: AQHXjM6gGebuC6fVrkG9XQpA69mWu6tqq6YAgAFRBICAAFahgIAUMHcAgAGHuIA=
Date:   Tue, 24 Aug 2021 02:45:00 +0000
Message-ID: <8cdb60df0f4376996b7b71523309170fd4a48f48.camel@intel.com>
References: <20210809032809.1224002-1-acelan.kao@canonical.com>
         <YRDCcDZGVkCdNF34@unreal>
         <CAFv23Qn=c_EZNPxu90s0n-HB6_vQCqaUG34YAq7-T6Np+10ZUA@mail.gmail.com>
         <YRIl0WKm+n8EZjlk@unreal>
         <CAFv23Q=Ue3kupfvMm2AnGP9iHXkpjpsCzzD36Ohd=SAGC=rzNg@mail.gmail.com>
In-Reply-To: <CAFv23Q=Ue3kupfvMm2AnGP9iHXkpjpsCzzD36Ohd=SAGC=rzNg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a5010f3-70b4-4692-bc38-08d966a92abc
x-ms-traffictypediagnostic: SJ0PR11MB4864:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB4864EDD5F7DF496D8949CBF8C6C59@SJ0PR11MB4864.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sTs3ysSds4b3G3w6rKx3lT+9iMWclpQHzuJ9vimu7PdtorOPmV03G2k0SJriB/x8OZqEpJLvtt6Xkf0CfpbU1IAJIcvK1RBZLZ8Pb2Eyo/vOvOk8bk64nFZOaxRz3XmJV+lpETF7S0JVCI5Z8leiAMeYAIBTYHJ7oyN+9bkG/86ry7i0cXkGIiVi82BbetcyubsLBOwbic/V3WRfZ7NwlNyToMOJkCcsU6OxkF8uJkqQxIQo4iYQNS6sPYtT2/CbpVgYFWUgLcnnq7Xdudt/yulFiSE/DWUsHDoz3L3pkXIrDfLzYrgbCJro2Kn3jg9kArYMg1Rca7upkKyVGOr/acoo+Od/Y2ZCKXqxYBtnL3aNjcKZhHC+8W/rZvoAfY4l0/zaJC66qMZqH9ljAQFgC8CkMg/cESPDvYzDGPZOOCikehEf60JyXw1belbUMLK46xogeAP2dcIzdQO9m8h61H1NxdTOfn6vhyHO4opS4UCT6S2VefqKdIclRwBd9EbRXAssL4pbd5i0U82gZ2XGPfKkN+yOJzFQQ0SaCeKqFz2kCQzn+JDQTcHCcDiFYUk++VSuQ0VE2QVzRi+vNFy/Nwb2N/X0Y0ltV75g7pVr4V47f5KsssE5aYJQq+NojyFBWcEdVWshT8dy5WTc9XTHq7i0s6MgO0cyEdFX5PZQdz2nYofz7wbr9RLiHiLc3XlZiVmQYhkurE2nZ84nYEsGWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3224.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(366004)(376002)(396003)(7416002)(6486002)(2616005)(6506007)(186003)(54906003)(38100700002)(36756003)(83380400001)(478600001)(122000001)(71200400001)(38070700005)(6512007)(8936002)(66946007)(107886003)(66476007)(66446008)(66556008)(64756008)(76116006)(110136005)(6636002)(86362001)(8676002)(4326008)(316002)(2906002)(26005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Yks2SDJOL0dHMnk4SlU2eGp1YXloNGY0aHhlOVpSeXBVZmhWN0REL3k5ZXBN?=
 =?utf-8?B?UWcwRVJPczNrdXduQ2EzMUlIdVhIMVozVEdhcWo4VlpCQTN2N09MRzlSUWpD?=
 =?utf-8?B?WlM1WVRrcXNUTEd1N1p3dndHaDFWVWpjeVdjMDZEUUYzTmtUK29CLy9WdnZI?=
 =?utf-8?B?dzFNcTNxd3lNcTh3T2JnV05ZeW5ueGpGYjFPeFdBZ0tUbFJjK05wMUE0YStM?=
 =?utf-8?B?NENoUDNDL0RaOHRYSGRyMUN0d0lRY2NkL3VyTFlHWFZNZ1pRY2RpVTZKV1lE?=
 =?utf-8?B?WlIwZVYwc2JML2hnTC9rdWFNb3ZCN21pbkRKUFpvQUJ5czBNWndwSzJndTk2?=
 =?utf-8?B?TXpXY3g2UGNuQTgveW41MEl6M1dDRU8wdy9OQWlGcWxjQmJSOFdXQUhYd0gr?=
 =?utf-8?B?aEhhUXFpNHlNYUtYWWtLNVVxalE0ZmJ2UlRrc1FIR1cxSkg2QTdId3VqWmV4?=
 =?utf-8?B?d1BSVmJDZWlRcWc1NW41Y2NrM1c3Ri9PaHIvRmR1S1VRTlBFTFZBSG9GWkxQ?=
 =?utf-8?B?QXdYdkVtR2hFY1FPYzJlRzZ6amxXajRHYlVJYTdLOVByeENUblJvUnlvaWxB?=
 =?utf-8?B?Tm5QQ0h1ci94cEt6NkFpWEFjU0lhM25uT0RHU1pkOUhlV2hpTm9EMm12WmtU?=
 =?utf-8?B?NEZYL2FFNExuZDcvakdDZzhqVWJkSnZpM0lUV2NiajhxbkJYTU40M0RDdWFi?=
 =?utf-8?B?MnY5YUVtZzNCbCtxMzlLVXl2WjRGaEM3UkU2WTQycW1NRXVZTGcrYnl1L2Ur?=
 =?utf-8?B?VnJHRmw2S2hHdjZGYmp0M1RITUx6TnU5RVNyd3JOcW9jUndKZnFMZ2dDS0wr?=
 =?utf-8?B?ZVJGaEtpMmdiTEJwYThPRldVT2MyckZVVEZJQVZ4MzVGSWxTYkJGSWdINEw0?=
 =?utf-8?B?UFRrbTU4NHF6dXJYbVk1Y2NrZWFZcUM2QlF6OWl3TXRqOUdFYVdHTExrcEsy?=
 =?utf-8?B?a2RIZDZBNkNSa0RNbE0zR2JRMFBKRWRMOG1Sb2g4TUhzWm5UdE1lanhQYkZp?=
 =?utf-8?B?Y0p2Yk8rV1B5N1gyV1dEN2xsVmNZR0VCUlFzbzhmSnpENHhnbVc5UU9aelJk?=
 =?utf-8?B?WDArNGg0Y2FvUE0vS2owQlEzaEtqb0g4MEtCMnZkK05odDJrMXJockt3c3Z0?=
 =?utf-8?B?eE16U1hPVTFHVWRDSEJGNDRZYy93Z0lUQVNnajdIamxCNHRUZWxBRUpGaFkv?=
 =?utf-8?B?cUNGOEpRbnljbitNeEMvekEzeEhwNk9lblJNNU1nZ1dNdDlGS2R1d040OHRH?=
 =?utf-8?B?L0dib29NS2JFemUxR2huZnI1RFh4cGtHd3YxZjVrcWsrZmFuYXVOZmNhZUxI?=
 =?utf-8?B?ckZ3Q3p5dWd1YXdOSFp0S3Zkell5SituLytRdkY5OGQ3RlBnODdwb3RWQWx1?=
 =?utf-8?B?QjJrbjliY2d2cERDSGFaWHJHMGpJY252THBoQWtPd2FxcitLTzRyQlJrK01v?=
 =?utf-8?B?dURsWE5LQVNmZ3hwY3pmOEM2U05icTdjVnJUWUpsTTNGU3BzUjFUNWs3N1BL?=
 =?utf-8?B?eWUyWG1sM1dXNlVBTUllSXJRUVdocUxCNkJsZ0orWGdYSTNDekZCMmNlQXVZ?=
 =?utf-8?B?Wmdvd2ZDQmxyWkdIMlp1WVJ0NGZieGg1QVF4RURlaHhHZ3JnTmpoQUg4N1V5?=
 =?utf-8?B?cEUxb3lRUjF2UGVJYWluaFVEZWJ6MlVsRzNZVGlMTDZmQXpNbTg1THRtQ0x4?=
 =?utf-8?B?NlZ3WTlIc3BzKzFDclJycTJ4MStRVU53b3F0MEtwcy9takVmOG5iaG10VStD?=
 =?utf-8?Q?9CumNSK5m51V3bjVG44umUueyo2Y29QrDkReVFV?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <93942B1D4A228745A5A3286C5791A37B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3224.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a5010f3-70b4-4692-bc38-08d966a92abc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2021 02:45:00.0714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S77MfHczqmCyOWtSTR4XM1e+9QoDtWY6MeOipYsWM0puVdbVTF315lPk1UuctfXh09BR9plNNpDqmXkMrz1o7lcbx03JW1Of3yQoKI9Y05Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4864
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTA4LTIzIGF0IDExOjI2ICswODAwLCBBY2VMYW4gS2FvIHdyb3RlOg0KPiBM
ZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVsLm9yZz4g5pa8IDIwMjHlubQ45pyIMTDml6Ug6YCx
5LqMIOS4i+WNiDM6MDjlr6vpgZPvvJoNCj4gPiBPbiBUdWUsIEF1ZyAxMCwgMjAyMSBhdCAwOTo1
Nzo1N0FNICswODAwLCBBY2VMYW4gS2FvIHdyb3RlOg0KPiA+ID4gTGVvbiBSb21hbm92c2t5IDxs
ZW9uQGtlcm5lbC5vcmc+IOaWvCAyMDIx5bm0OOaciDnml6Ug6YCx5LiAIOS4i+WNiDE6NTHlr6vp
gZPvvJoNCj4gPiA+ID4gT24gTW9uLCBBdWcgMDksIDIwMjEgYXQgMTE6Mjg6MDlBTSArMDgwMCwg
QWNlTGFuIEthbyB3cm90ZToNCj4gPiA+ID4gPiBGcm9tOiAiQ2hpYS1MaW4gS2FvIChBY2VMYW4p
IiA8YWNlbGFuLmthb0BjYW5vbmljYWwuY29tPg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFRoZSBy
dG5sX2xvY2soKSBoYXMgYmVlbiBjYWxsZWQgaW4gcnRuZXRsaW5rX3Jjdl9tc2coKSwgYW5kDQo+
ID4gPiA+ID4gdGhlbiBpbg0KPiA+ID4gPiA+IF9fZGV2X29wZW4oKSBpdCBjYWxscyBwbV9ydW50
aW1lX3Jlc3VtZSgpIHRvIHJlc3VtZSBkZXZpY2VzLA0KPiA+ID4gPiA+IGFuZCBpbg0KPiA+ID4g
PiA+IHNvbWUgZGV2aWNlcycgcmVzdW1lIGZ1bmN0aW9uKGlnYl9yZXN1bSxpZ2NfcmVzdW1lKSB0
aGV5DQo+ID4gPiA+ID4gY2FsbHMgcnRubF9sb2NrKCkNCj4gPiA+ID4gPiBhZ2Fpbi4gVGhhdCBs
ZWFkcyB0byBhIHJlY3Vyc2l2ZSBsb2NrLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEl0IHNob3Vs
ZCBsZWF2ZSB0aGUgZGV2aWNlcycgcmVzdW1lIGZ1bmN0aW9uIHRvIGRlY2lkZSBpZg0KPiA+ID4g
PiA+IHRoZXkgbmVlZCB0bw0KPiA+ID4gPiA+IGNhbGwgcnRubF9sb2NrKCkvcnRubF91bmxvY2so
KSwNCj4gPiA+ID4gDQo+ID4gPiA+IFdoeT8gSXQgZG9lc24ndCBzb3VuZCByaWdodCB0aGF0IGRy
aXZlcnMgaW50ZXJuYWxseSBkZWNpZGUgaWYNCj4gPiA+ID4gdG8gdGFrZSBvcg0KPiA+ID4gPiBy
ZWxlYXNlIHNvbWUgZXh0ZXJuYWwgdG8gdGhlbSBsb2NrIHdpdGhvdXQgc2VlaW5nIGZ1bGwgcGlj
dHVyZS4NCj4gPiA+IEZyb20gd2hhdCBJIG9ic2VydmVkLCB0aGlzIGlzIHRoZSBvbmx5IGNhbGxp
bmcgcGF0aCB0aGF0IGFjcXVpcmVkDQo+ID4gPiBydG5sX2xvY2soKSBiZWZvcmUgY2FsbGluZyBk
cml2ZXJzJyByZXN1bWUgZnVuY3Rpb24uDQo+ID4gPiBTbywgaXQgZW5jb3VudGVycyByZWN1cnNp
dmUgbG9jayB3aGlsZSBkcml2ZXIgaXMgZ29pbmcgdG8gY2FsDQo+ID4gPiBydG5sX2xvY2soKSBh
Z2Fpbi4NCj4gPiANCj4gPiBJIGNsZWFybHkgc2VlIHRoZSBwcm9ibGVtLCBidXQgZG9uJ3QgYWdy
ZWUgd2l0aCBhIHNvbHV0aW9uLg0KPiA+IA0KPiA+ID4gPiBNb3N0IG9mIHRoZSB0aW1lLCBkZXZp
Y2UgZHJpdmVyIGF1dGhvcnMgZG8gaXQgd3JvbmcuIEkgYWZyYWlkDQo+ID4gPiA+IHRoYXQgaWdz
DQo+ID4gPiA+IGlzIG9uZSBvZiBzdWNoIGRyaXZlcnMgdGhhdCBkaWQgaXQgd3JvbmcuDQo+ID4g
PiBUaGUgaXNzdWVzIGNvdWxkIGJlIGlmIHdlIHJlbW92ZSBydG5sX2xvY2sgaW4gZGV2aWNlIGRy
aXZlcnMsDQo+ID4gPiB0aGVuIGluDQo+ID4gPiBvdGhlciBjYWxsaW5nIHBhdGgsIGl0IHdvbid0
IGJlIHByb3RlY3RlZCBieSB0aGUgcnRubCBsb2NrLA0KPiA+ID4gYW5kIG1heWJlIHdlIHNob3Vs
ZG4ndCBjYWxsIHBtX3J1bnRpbWVfcmVzdW1lKCkgaGVyZSh3aXRoaW4gcnRubA0KPiA+ID4gbG9j
ayksIGZvciBkZXZpY2UgZHJpdmVycyBkb24ndCBrbm93IGlmIHRoZXkgYXJlIHByb3RlY3RlZCBi
eSB0aGUNCj4gPiA+IHJ0bmwNCj4gPiA+IGxvY2sgd2hpbGUgdGhlaXIgcmVzdW1lKCkgZ290IGNh
bGxlZC4NCj4gPiANCj4gPiBUaGlzIGlzIGV4YWN0bHkgdGhlIHByb2JsZW0sIGV2ZXJ5IGRyaXZl
ciBndWVzc2VzIGlmIHJ0bmxfbG9jayBpcw0KPiA+IG5lZWRlZA0KPiA+IG9yIG5vdCBpbiBzcGVj
aWZpYyBwYXRoLiBJdCBpcyB3cm9uZyBieSBkZXNpZ24uIFlvdSBzaG91bGQgZW5zdXJlDQo+ID4g
dGhhdA0KPiA+IGFsbCBwYXRocyB0aGF0IGFyZSB0cmlnZ2VyZWQgdGhyb3VnaCBydG5sIHNob3Vs
ZCBob2xkIHJ0bmxfbG9jay4NCj4gSGkgSmVzc2UsIFRvbnksDQo+IA0KPiBBcyB5b3UgYXJlIHRo
ZSBJbnRlbCBFdGhlcm5ldCBkcml2ZXJzJyBtYWludGFpbmVycywgZG8geW91IGhhdmUgYW55DQo+
IGlkZWEgYWJvdXQgdGhpcz8NCj4gV2UgY2FuIHJlcHJvZHVjZSB0aGlzIGlzc3VlIG9uIHRoZSBt
YWNoaW5lIHdpdGggUENJIEV0aGVybmV0IGNhcmQNCj4gdXNpbmcgaWdiIG9yIGlnYyBkcml2ZXIu
DQoNCkFkZGluZyBBbGVrcyBhbmQgU2FzaGEgZm9yIHRoZWlyIGlucHV0IGFzIHRoZXkgYXJlIHRo
ZSBsZWFkcyBmb3IgdGhlDQp0d28gZHJpdmVycy4NCg0KPiA+IFlvdSBkcm9wcGVkIHJ0bmxfbG9j
aygpIHdpdGhvdXQgYW55IHByb3RlY3Rpb24sIGl0IGlzIDEwMCUgYnVnLg0KPiA+IA0KPiA+IFRo
YW5rcw0KPiA+IA0KPiA+ID4gPiBUaGFua3MNCj4gPiA+ID4gDQo+ID4gPiA+ID4gc28gY2FsbCBy
dG5sX3VubG9jaygpIGJlZm9yZSBjYWxsaW5nIHBtX3J1bnRpbWVfcmVzdW1lKCkgYW5kDQo+ID4g
PiA+ID4gdGhlbiBjYWxsDQo+ID4gPiA+ID4gcnRubF9sb2NrKCkgYWZ0ZXIgaXQgaW4gX19kZXZf
b3BlbigpLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFsgIDk2Ny43MjM1NzddIElORk86IHRhc2sg
aXA6NjAyNCBibG9ja2VkIGZvciBtb3JlIHRoYW4gMTIwDQo+ID4gPiA+ID4gc2Vjb25kcy4NCj4g
PiA+ID4gPiBbICA5NjcuNzIzNTg4XSAgICAgICBOb3QgdGFpbnRlZCA1LjEyLjAtcmMzKyAjMQ0K
PiA+ID4gPiA+IFsgIDk2Ny43MjM1OTJdICJlY2hvIDAgPg0KPiA+ID4gPiA+IC9wcm9jL3N5cy9r
ZXJuZWwvaHVuZ190YXNrX3RpbWVvdXRfc2VjcyIgZGlzYWJsZXMgdGhpcw0KPiA+ID4gPiA+IG1l
c3NhZ2UuDQo+ID4gPiA+ID4gWyAgOTY3LjcyMzU5NF0gdGFzazppcCAgICAgICAgICAgICAgc3Rh
dGU6RCBzdGFjazogICAgMCBwaWQ6DQo+ID4gPiA+ID4gNjAyNCBwcGlkOiAgNTk1NyBmbGFnczow
eDAwMDA0MDAwDQo+ID4gPiA+ID4gWyAgOTY3LjcyMzYwM10gQ2FsbCBUcmFjZToNCj4gPiA+ID4g
PiBbICA5NjcuNzIzNjEwXSAgX19zY2hlZHVsZSsweDJkZS8weDg5MA0KPiA+ID4gPiA+IFsgIDk2
Ny43MjM2MjNdICBzY2hlZHVsZSsweDRmLzB4YzANCj4gPiA+ID4gPiBbICA5NjcuNzIzNjI5XSAg
c2NoZWR1bGVfcHJlZW1wdF9kaXNhYmxlZCsweGUvMHgxMA0KPiA+ID4gPiA+IFsgIDk2Ny43MjM2
MzZdICBfX211dGV4X2xvY2suaXNyYS4wKzB4MTkwLzB4NTEwDQo+ID4gPiA+ID4gWyAgOTY3Ljcy
MzY0NF0gIF9fbXV0ZXhfbG9ja19zbG93cGF0aCsweDEzLzB4MjANCj4gPiA+ID4gPiBbICA5Njcu
NzIzNjUxXSAgbXV0ZXhfbG9jaysweDMyLzB4NDANCj4gPiA+ID4gPiBbICA5NjcuNzIzNjU3XSAg
cnRubF9sb2NrKzB4MTUvMHgyMA0KPiA+ID4gPiA+IFsgIDk2Ny43MjM2NjVdICBpZ2JfcmVzdW1l
KzB4ZWUvMHgxZDAgW2lnYl0NCj4gPiA+ID4gPiBbICA5NjcuNzIzNjg3XSAgPyBwY2lfcG1fZGVm
YXVsdF9yZXN1bWUrMHgzMC8weDMwDQo+ID4gPiA+ID4gWyAgOTY3LjcyMzY5Nl0gIGlnYl9ydW50
aW1lX3Jlc3VtZSsweGUvMHgxMCBbaWdiXQ0KPiA+ID4gPiA+IFsgIDk2Ny43MjM3MTNdICBwY2lf
cG1fcnVudGltZV9yZXN1bWUrMHg3NC8weDkwDQo+ID4gPiA+ID4gWyAgOTY3LjcyMzcxOF0gIF9f
cnBtX2NhbGxiYWNrKzB4NTMvMHgxYzANCj4gPiA+ID4gPiBbICA5NjcuNzIzNzI1XSAgcnBtX2Nh
bGxiYWNrKzB4NTcvMHg4MA0KPiA+ID4gPiA+IFsgIDk2Ny43MjM3MzBdICA/IHBjaV9wbV9kZWZh
dWx0X3Jlc3VtZSsweDMwLzB4MzANCj4gPiA+ID4gPiBbICA5NjcuNzIzNzM1XSAgcnBtX3Jlc3Vt
ZSsweDU0Ny8weDc2MA0KPiA+ID4gPiA+IFsgIDk2Ny43MjM3NDBdICBfX3BtX3J1bnRpbWVfcmVz
dW1lKzB4NTIvMHg4MA0KPiA+ID4gPiA+IFsgIDk2Ny43MjM3NDVdICBfX2Rldl9vcGVuKzB4NTYv
MHgxNjANCj4gPiA+ID4gPiBbICA5NjcuNzIzNzUzXSAgPyBfcmF3X3NwaW5fdW5sb2NrX2JoKzB4
MWUvMHgyMA0KPiA+ID4gPiA+IFsgIDk2Ny43MjM3NThdICBfX2Rldl9jaGFuZ2VfZmxhZ3MrMHgx
ODgvMHgxZTANCj4gPiA+ID4gPiBbICA5NjcuNzIzNzY2XSAgZGV2X2NoYW5nZV9mbGFncysweDI2
LzB4NjANCj4gPiA+ID4gPiBbICA5NjcuNzIzNzczXSAgZG9fc2V0bGluaysweDcyMy8weDEwYjAN
Cj4gPiA+ID4gPiBbICA5NjcuNzIzNzgyXSAgPyBfX25sYV92YWxpZGF0ZV9wYXJzZSsweDViLzB4
YjgwDQo+ID4gPiA+ID4gWyAgOTY3LjcyMzc5Ml0gIF9fcnRubF9uZXdsaW5rKzB4NTk0LzB4YTAw
DQo+ID4gPiA+ID4gWyAgOTY3LjcyMzgwMF0gID8gbmxhX3B1dF9pZmFsaWFzKzB4MzgvMHhhMA0K
PiA+ID4gPiA+IFsgIDk2Ny43MjM4MDddICA/IF9fbmxhX3Jlc2VydmUrMHg0MS8weDUwDQo+ID4g
PiA+ID4gWyAgOTY3LjcyMzgxM10gID8gX19ubGFfcmVzZXJ2ZSsweDQxLzB4NTANCj4gPiA+ID4g
PiBbICA5NjcuNzIzODE4XSAgPyBfX2ttYWxsb2Nfbm9kZV90cmFja19jYWxsZXIrMHg0OWIvMHg0
ZDANCj4gPiA+ID4gPiBbICA5NjcuNzIzODI0XSAgPyBwc2tiX2V4cGFuZF9oZWFkKzB4NzUvMHgz
MTANCj4gPiA+ID4gPiBbICA5NjcuNzIzODMwXSAgPyBubGFfcmVzZXJ2ZSsweDI4LzB4MzANCj4g
PiA+ID4gPiBbICA5NjcuNzIzODM1XSAgPyBza2JfZnJlZV9oZWFkKzB4MjUvMHgzMA0KPiA+ID4g
PiA+IFsgIDk2Ny43MjM4NDNdICA/IHNlY3VyaXR5X3NvY2tfcmN2X3NrYisweDJmLzB4NTANCj4g
PiA+ID4gPiBbICA5NjcuNzIzODUwXSAgPyBuZXRsaW5rX2RlbGl2ZXJfdGFwKzB4M2QvMHgyMTAN
Cj4gPiA+ID4gPiBbICA5NjcuNzIzODU5XSAgPyBza19maWx0ZXJfdHJpbV9jYXArMHhjMS8weDIz
MA0KPiA+ID4gPiA+IFsgIDk2Ny43MjM4NjNdICA/IHNrYl9xdWV1ZV90YWlsKzB4NDMvMHg1MA0K
PiA+ID4gPiA+IFsgIDk2Ny43MjM4NzBdICA/IHNvY2tfZGVmX3JlYWRhYmxlKzB4NGIvMHg4MA0K
PiA+ID4gPiA+IFsgIDk2Ny43MjM4NzZdICA/IF9fbmV0bGlua19zZW5kc2tiKzB4NDIvMHg1MA0K
PiA+ID4gPiA+IFsgIDk2Ny43MjM4ODhdICA/IHNlY3VyaXR5X2NhcGFibGUrMHgzZC8weDYwDQo+
ID4gPiA+ID4gWyAgOTY3LjcyMzg5NF0gID8gX19jb25kX3Jlc2NoZWQrMHgxOS8weDMwDQo+ID4g
PiA+ID4gWyAgOTY3LjcyMzkwMF0gID8ga21lbV9jYWNoZV9hbGxvY190cmFjZSsweDM5MC8weDQ0
MA0KPiA+ID4gPiA+IFsgIDk2Ny43MjM5MDZdICBydG5sX25ld2xpbmsrMHg0OS8weDcwDQo+ID4g
PiA+ID4gWyAgOTY3LjcyMzkxM10gIHJ0bmV0bGlua19yY3ZfbXNnKzB4MTNjLzB4MzcwDQo+ID4g
PiA+ID4gWyAgOTY3LjcyMzkyMF0gID8gX2NvcHlfdG9faXRlcisweGEwLzB4NDYwDQo+ID4gPiA+
ID4gWyAgOTY3LjcyMzkyN10gID8gcnRubF9jYWxjaXQuaXNyYS4wKzB4MTMwLzB4MTMwDQo+ID4g
PiA+ID4gWyAgOTY3LjcyMzkzNF0gIG5ldGxpbmtfcmN2X3NrYisweDU1LzB4MTAwDQo+ID4gPiA+
ID4gWyAgOTY3LjcyMzkzOV0gIHJ0bmV0bGlua19yY3YrMHgxNS8weDIwDQo+ID4gPiA+ID4gWyAg
OTY3LjcyMzk0NF0gIG5ldGxpbmtfdW5pY2FzdCsweDFhOC8weDI1MA0KPiA+ID4gPiA+IFsgIDk2
Ny43MjM5NDldICBuZXRsaW5rX3NlbmRtc2crMHgyMzMvMHg0NjANCj4gPiA+ID4gPiBbICA5Njcu
NzIzOTU0XSAgc29ja19zZW5kbXNnKzB4NjUvMHg3MA0KPiA+ID4gPiA+IFsgIDk2Ny43MjM5NThd
ICBfX19fc3lzX3NlbmRtc2crMHgyMTgvMHgyOTANCj4gPiA+ID4gPiBbICA5NjcuNzIzOTYxXSAg
PyBjb3B5X21zZ2hkcl9mcm9tX3VzZXIrMHg1Yy8weDkwDQo+ID4gPiA+ID4gWyAgOTY3LjcyMzk2
Nl0gID8NCj4gPiA+ID4gPiBscnVfY2FjaGVfYWRkX2luYWN0aXZlX29yX3VuZXZpY3RhYmxlKzB4
MjcvMHhiMA0KPiA+ID4gPiA+IFsgIDk2Ny43MjM5NzRdICBfX19zeXNfc2VuZG1zZysweDgxLzB4
YzANCj4gPiA+ID4gPiBbICA5NjcuNzIzOTgwXSAgPyBfX21vZF9tZW1jZ19scnV2ZWNfc3RhdGUr
MHgyMi8weGUwDQo+ID4gPiA+ID4gWyAgOTY3LjcyMzk4N10gID8ga21lbV9jYWNoZV9mcmVlKzB4
MjQ0LzB4NDIwDQo+ID4gPiA+ID4gWyAgOTY3LjcyMzk5MV0gID8gZGVudHJ5X2ZyZWUrMHgzNy8w
eDcwDQo+ID4gPiA+ID4gWyAgOTY3LjcyMzk5Nl0gID8gbW50cHV0X25vX2V4cGlyZSsweDRjLzB4
MjYwDQo+ID4gPiA+ID4gWyAgOTY3LjcyNDAwMV0gID8gX19jb25kX3Jlc2NoZWQrMHgxOS8weDMw
DQo+ID4gPiA+ID4gWyAgOTY3LjcyNDAwN10gID8gc2VjdXJpdHlfZmlsZV9mcmVlKzB4NTQvMHg2
MA0KPiA+ID4gPiA+IFsgIDk2Ny43MjQwMTNdICA/IGNhbGxfcmN1KzB4YTQvMHgyNTANCj4gPiA+
ID4gPiBbICA5NjcuNzI0MDIxXSAgX19zeXNfc2VuZG1zZysweDYyLzB4YjANCj4gPiA+ID4gPiBb
ICA5NjcuNzI0MDI2XSAgPyBleGl0X3RvX3VzZXJfbW9kZV9wcmVwYXJlKzB4M2QvMHgxYTANCj4g
PiA+ID4gPiBbICA5NjcuNzI0MDMyXSAgX194NjRfc3lzX3NlbmRtc2crMHgxZi8weDMwDQo+ID4g
PiA+ID4gWyAgOTY3LjcyNDAzN10gIGRvX3N5c2NhbGxfNjQrMHgzOC8weDkwDQo+ID4gPiA+ID4g
WyAgOTY3LjcyNDA0NF0gIGVudHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdmcmFtZSsweDQ0LzB4YWUN
Cj4gPiA+ID4gPiANCj4gPiA+ID4gPiBGaXhlczogYmQ4NjkyNDVhM2RjICgibmV0OiBjb3JlOiB0
cnkgdG8gcnVudGltZS1yZXN1bWUNCj4gPiA+ID4gPiBkZXRhY2hlZCBkZXZpY2UgaW4gX19kZXZf
b3BlbiIpDQo+ID4gPiA+ID4gU2lnbmVkLW9mZi1ieTogQ2hpYS1MaW4gS2FvIChBY2VMYW4pIDwN
Cj4gPiA+ID4gPiBhY2VsYW4ua2FvQGNhbm9uaWNhbC5jb20+DQo+ID4gPiA+ID4gLS0tDQo+ID4g
PiA+ID4gIG5ldC9jb3JlL2Rldi5jIHwgNSArKysrLQ0KPiA+ID4gPiA+ICAxIGZpbGUgY2hhbmdl
ZCwgNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
ZGlmZiAtLWdpdCBhL25ldC9jb3JlL2Rldi5jIGIvbmV0L2NvcmUvZGV2LmMNCj4gPiA+ID4gPiBp
bmRleCA4ZjFhNDdhZDY3ODEuLmRkNDNhMjk0MTlmZCAxMDA2NDQNCj4gPiA+ID4gPiAtLS0gYS9u
ZXQvY29yZS9kZXYuYw0KPiA+ID4gPiA+ICsrKyBiL25ldC9jb3JlL2Rldi5jDQo+ID4gPiA+ID4g
QEAgLTE1ODUsOCArMTU4NSwxMSBAQCBzdGF0aWMgaW50IF9fZGV2X29wZW4oc3RydWN0DQo+ID4g
PiA+ID4gbmV0X2RldmljZSAqZGV2LCBzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2spDQo+
ID4gPiA+ID4gDQo+ID4gPiA+ID4gICAgICAgaWYgKCFuZXRpZl9kZXZpY2VfcHJlc2VudChkZXYp
KSB7DQo+ID4gPiA+ID4gICAgICAgICAgICAgICAvKiBtYXkgYmUgZGV0YWNoZWQgYmVjYXVzZSBw
YXJlbnQgaXMgcnVudGltZS0NCj4gPiA+ID4gPiBzdXNwZW5kZWQgKi8NCj4gPiA+ID4gPiAtICAg
ICAgICAgICAgIGlmIChkZXYtPmRldi5wYXJlbnQpDQo+ID4gPiA+ID4gKyAgICAgICAgICAgICBp
ZiAoZGV2LT5kZXYucGFyZW50KSB7DQo+ID4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgIHJ0
bmxfdW5sb2NrKCk7DQo+ID4gPiA+ID4gICAgICAgICAgICAgICAgICAgICAgIHBtX3J1bnRpbWVf
cmVzdW1lKGRldi0+ZGV2LnBhcmVudCk7DQo+ID4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAg
IHJ0bmxfbG9jaygpOw0KPiA+ID4gPiA+ICsgICAgICAgICAgICAgfQ0KPiA+ID4gPiA+ICAgICAg
ICAgICAgICAgaWYgKCFuZXRpZl9kZXZpY2VfcHJlc2VudChkZXYpKQ0KPiA+ID4gPiA+ICAgICAg
ICAgICAgICAgICAgICAgICByZXR1cm4gLUVOT0RFVjsNCj4gPiA+ID4gPiAgICAgICB9DQo+ID4g
PiA+ID4gLS0NCj4gPiA+ID4gPiAyLjI1LjENCj4gPiA+ID4gPiANCg==
