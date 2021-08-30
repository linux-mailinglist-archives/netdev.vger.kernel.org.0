Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA8F3FBDA3
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 22:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbhH3Uxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 16:53:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:42484 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229923AbhH3Uxk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 16:53:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="218359635"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="218359635"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2021 13:52:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="540726517"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga002.fm.intel.com with ESMTP; 30 Aug 2021 13:52:45 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 30 Aug 2021 13:52:45 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 30 Aug 2021 13:52:45 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 30 Aug 2021 13:52:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TgdpenCrsU1dkzZMDgGOmHk0PA4wXsMGMwoGifWS7oN8D30HYamFhMQGKdqLTDagBV2MrFmhkJEshjS9vyhNKZHz1jMeXAnJVteWDaxiriNfpxQE9l3JUwqBGn2NbFs/9lwhMWRi6BdOPnX7EQIizZ+GM9umUmKgOSWj5TTFuKTBidy/zNop/+VdIrSUNw/u2vTGDkKvwYyartZBebYeKUIMTuXSiOKTluEaZZB00p2vHWcPGhcZ5nyIk3QqIOvgnyCA5xlDxoVEQ9T+uH0LlP3Piu7UZGOjNSWE7wxqW8JdQ0xC2xEiF3FYAh7e1DRmj8jLXBt9KbEZQvyqUE/F6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FgWQM3zfAOrYkBPKxy2a+yWCHk4Z1tbdCONyp90wHZ4=;
 b=ASYbt3MO3DsaNfuwPs4BdSmS2oEcRMG7+0o9lVVoX3s9tVxK6/P1IvI+z7Qcj1LTYRZ5z974CjPg4q7T1RQhdgHePH0AkMvuCy6kZL/+PU/JJ8gca8GnI3FtgBQkJie+xYF/V7r6eJJDmMfEuaWzb8Y/ju1dtzsPNMBtWmCMXNg43+iEd7tPEW7lQZaoTYcUZNfk09sqG9wmg4+scSbRFvC/nNRzQ9DKL4iMAqCeLuzoImQwHsoFMUASXMU9BlVe2Zvj66D8IbMdm3Ecjjcx2Nd62GMSy75AxEa3gKqZq7cUvRVql6UF7IKGDirc3zFlJmyQ2O56pn8IyXVKZyMCzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FgWQM3zfAOrYkBPKxy2a+yWCHk4Z1tbdCONyp90wHZ4=;
 b=bs4Dyeq8XbQIzpewPaUNQMMgcmmgr2FcsGaqOhNwa2idcMH/MEdZJYANfyv3ZSMut3UjnFk3ltndJOP0LWVi7wajXdO7IdanJS1E4RDspm2Per/G4uFvjr3sieuIHkZ8r6+B6gEeJBiGrxUT2+PM51G8qY7ntMeb6fGnUv+paiU=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA0PR11MB4606.namprd11.prod.outlook.com (2603:10b6:806:71::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Mon, 30 Aug
 2021 20:52:41 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4e0:837:41ee:5b42]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4e0:837:41ee:5b42%6]) with mapi id 15.20.4457.024; Mon, 30 Aug 2021
 20:52:41 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "pwaskiewicz@jumptrading.com" <pwaskiewicz@jumptrading.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "pjwaskiewicz@gmail.com" <pjwaskiewicz@gmail.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Dziedziuch, SylwesterX" <sylwesterx.dziedziuch@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Thread-Topic: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Thread-Index: AQHXmsiBRJTk/bztnkiJewAWaKSBqquMjXAA
Date:   Mon, 30 Aug 2021 20:52:41 +0000
Message-ID: <50c21a769633c8efa07f49fc8b20fdfb544cf3c5.camel@intel.com>
References: <20210826221916.127243-1-pwaskiewicz@jumptrading.com>
In-Reply-To: <20210826221916.127243-1-pwaskiewicz@jumptrading.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: jumptrading.com; dkim=none (message not signed)
 header.d=none;jumptrading.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff6288fd-1182-4a99-d0e5-08d96bf81be5
x-ms-traffictypediagnostic: SA0PR11MB4606:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB46065CF62B762430515D52A0C6CB9@SA0PR11MB4606.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GSHulywIfX8xngMVv8Knh3nIfHieWLQbI3AbFmohh2MVeMfTyAGQv5O9KdaJtJO2B0pZG4z4GdQrfOpBOreo45vHLfVYgewjGzkrGrrj0JNvCftWVcNn5TIc51Q2p1W8/rFMlkH3SKkqi6bzGZpwoslqHxSFeBH/yoMwUIhrednNG93e89ukJ8YEDRkOyDYGzj64IhPx0z3o3Ki8fBBV9dhR9NL7/ILewyguCevo9AbLYiuMUTzq9w0++WmYlSdElrpqTpiiG4n9k5tpXz0dhi/t7iInulN3yea9+P5nGGuCyLRiFi41+5I20zQm7M+ussit+fqSXn4YphZtR821ldRT/XuSYJUR3+/NqTa67+7diS1w/gQ0Xp6hjS2Xx0knhiE6ThkMoaLesOEh7wcMr9zoEoVblPTzPpIuKuO+4RXlczq58NvTnAd62gpxED9HIwjiKfUXbMGbzHAs4iqMwCPvE9NXQOFY4sBH79bS0qNII04ED08j2CLD5o5hsNMkDDteiDTO78sBKaFnRQlYn3nTL9KdLEdejAIjqJjr6VbcgCmLWR11D07SkLXyCFPugKFbQFwlx6Ga4wiUsier+M1ZOOHhlLt03tZ2RIdkznBM0xSHY4H99R5X/itmkJVZPM9Ypf/ssovAJXknHaH+LoPkRJWK0xEKgs3hr60Fc4sYmyXDpcTMl3BNJ5mHHohS0fL/QBmj4blWMG6PkWKezw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(5660300002)(26005)(91956017)(76116006)(186003)(2906002)(6506007)(8676002)(6512007)(54906003)(2616005)(478600001)(86362001)(83380400001)(66476007)(64756008)(8936002)(4326008)(316002)(66946007)(110136005)(66446008)(66556008)(71200400001)(122000001)(38100700002)(6486002)(36756003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0xrWWhDSms3dEtNQVJhNVVjK3JBT3dqTXlwdU9RbGg0RmxSYmpNYTBqTW81?=
 =?utf-8?B?enJCaGx5dE5IUXYyMjJHOUhrN3Q3UVkwdGdsM05lUmhVZGhIdWZqanI5Tjh4?=
 =?utf-8?B?L3NRb3UrN014N2xGWEh5SkN3UTlRSUpDWU5qaFhWRmtJVXhONXhjcmFxNWt1?=
 =?utf-8?B?YWZMeVpDTHRpYXdudWNUd3RSQXFwOTJObFI1ZjFaQVhlWHppYXlpZzJyekVz?=
 =?utf-8?B?SWFFaWdsMnRKMWx2K2VMcGVQekt2V0dsUU00azRlaHNkZ01UUy9XMDBndGdB?=
 =?utf-8?B?eWRvaHVVNll2NHJuenIxVGdCSnJMeEJCUGdwVUxxV2s4MUkvcVpqMytaV1Bt?=
 =?utf-8?B?SzJtY1V3UzVMc2xCMHFxdEU3RXNaYW5ZRzVTQWdoVnA0Y1Y4ZHlVaFFPQWox?=
 =?utf-8?B?MWlJMVlZNFNtMG5BUGxZWGxwV3VTVE55N3l5UmVLUlhQaEpDVm9nN1ltdGxW?=
 =?utf-8?B?NC9SSGlMT1VpeUZEM2RtbXJRTHN5ckFOZVIvMURqbFlpTHVIRE1Bckk5cDdG?=
 =?utf-8?B?dlFXb0RGeUJpWW9MREREdlRKcGhKVGxrczVxY0QzUlNOU2kzc3JoVDEwL21E?=
 =?utf-8?B?UGVIZXl6V1Frc2MrbmplL1UyOStoSk9WQVZvOFNOMEd3eTU5NytsL0d3Q0VP?=
 =?utf-8?B?ZmZHeXZPYVJLTkMxVjZ6MnI4U0g2bUFXYlAxOFI0OHo4SVloaFZxeEZab3Bk?=
 =?utf-8?B?SkFybi8vYTJ5VEZCeUNYanJFSXBja2RENW9lT29NZXhmZFpQUXhidWo2clV1?=
 =?utf-8?B?TjdtZ1hqQ0dLTExFNUpqRHAvS3dnY2htalU1QmZrRVhGVHErY1pXZFhmME1l?=
 =?utf-8?B?R2drTUQ3bkw1bzZDSk5YODRtWWdxNzBmeWQ1Q2ZRWUVGSkx3blIvV0IwZ2pu?=
 =?utf-8?B?RTRHZTJTeGtGUnd5L21STE9ybXQ1MmJkajViWFhtcWhNWkdjNnZ3QnZzbXd0?=
 =?utf-8?B?SXl6dm85azVqYjZqSXpMellsbFFWTnBtVytDNFBYNzVFMlBiL3J4OFBqL1ho?=
 =?utf-8?B?cU5EN09qM2tDeGRNc21menJzemdxT01yaDRnMmV3akt0ZnQyaDBsZFBNejBT?=
 =?utf-8?B?VHppSkZsdjE4amlaWVdoWmtBT0Y5aXZCdUNDYUVQMW82VzM0U2FBcm4vVjRY?=
 =?utf-8?B?b1NUYWNNT3FvdmN5VTU2aUFIY3Erb0FnNGYxSXE4SzQzTkMvYmpVdGsrSGtC?=
 =?utf-8?B?Wm8yM0crRUExSDZaWHZVa2plYm90UU40YjR5a0ZlSXE0Rk1hOGlYbXJaYzlK?=
 =?utf-8?B?Ykw2MkxlS2hHTjFBVzYrU00zWDFKeTJZOUxGM01GZkZDSjdmQWtCdWFrYWZm?=
 =?utf-8?B?NHZubTcvNFpzRnhTQkV2aTJEYzNHdEpkVFlEY0NsN0wrVVRqYXNGc0tQVUNT?=
 =?utf-8?B?RDBCRnhHNEplVVFDcC9VSG1KTXVCcEtDY25LaU5Wdi9WRnUxRWFETm1ld1ZD?=
 =?utf-8?B?U0VFN3ltMXFIRzNjdDhKWFZYYUNQZU50c2tKekEyTDBkTmFFZC84czh0M3pE?=
 =?utf-8?B?eFAxMzhwQVc5QWZuVVR4dlY2VmdMdEhaa0RlZ0o1RVpnVzkydGRDMUJVb05o?=
 =?utf-8?B?MzJtc0puRUE0OUpDTmN3RlllWVp1U1lwbWcyVjkzTVR0U3Bld0RTS0h2alFZ?=
 =?utf-8?B?SENPdHZKWCtWTXB0ZkpOQmZGME93bDk5TFE3dlVaZm1admFUdkRhYmx3WjBv?=
 =?utf-8?B?Ri9TbmUxNE01YTFXNGhvME1velFZeU1QOEp6UHY2TThESFlsOU96aG54SjJT?=
 =?utf-8?B?Zklha3F2WFNJT2I4akliOTllVTk2cS8yanloazhYR1AvRmFFMU42bFRXSGp5?=
 =?utf-8?B?NXlDRGRMSmxxQ2taelFZZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9345ED72E93A904BA7B0467E511AA89E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff6288fd-1182-4a99-d0e5-08d96bf81be5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2021 20:52:41.3343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zcRa32/zWzSf05HI028Q/r52rxHybAyRBR1jkLVhfOr1H/Y7Yf/TZg6qP8yyMrqP2JJsCGQPJzFyZkKAiAERvAkEoHCzMvfeWxR/ud/VkaY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4606
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTA4LTI2IGF0IDE3OjE5IC0wNTAwLCBQSiBXYXNraWV3aWN6IHdyb3RlOg0K
PiBUaGlzIGZpeGVzIGFuIGVycm9yIHBhdGggY29uZGl0aW9uIHdoZW4gcHJvYmUoKSBmYWlscyBk
dWUgdG8gdGhlDQo+IGRlZmF1bHQgVlNJIG5vdCBiZWluZyBhdmFpbGFibGUgb3Igb25saW5lIHll
dCBpbiB0aGUgZmlybXdhcmUuIElmDQo+IHRoYXQgaGFwcGVucywgdGhlIHByZXZpb3VzIHRlYXJk
b3duIHBhdGggd291bGQgY2xlYXIgdGhlIGludGVycnVwdA0KPiBzY2hlbWUsIHdoaWNoIGFsc28g
ZnJlZWQgdGhlIElSUXMgd2l0aCB0aGUgT1MuIFRoZW4gdGhlIGVycm9yIHBhdGgNCj4gZm9yIHRo
ZSBzd2l0Y2ggc2V0dXAgKHByZS1WU0kpIHdvdWxkIGF0dGVtcHQgdG8gZnJlZSB0aGUgT1MgSVJR
cw0KPiBhcyB3ZWxsLg0KDQpIaSBQSiwNCg0KVGhlc2UgY29tbWVudHMgYXJlIGZyb20gdGhlIGk0
MGUgdGVhbS4NCg0KWWVzIGluIGNhc2Ugd2UgZmFpbCBhbmQgZ28gdG8gZXJyX3ZzaXMgbGFiZWwg
aW4gaTQwZV9wcm9iZSgpIHdlIHdpbGwNCmNhbGwgaTQwZV9yZXNldF9pbnRlcnJ1cHRfY2FwYWJp
bGl0eSB0d2ljZSBidXQgdGhpcyBpcyBub3QgYSBwcm9ibGVtLg0KVGhpcyBpcyBiZWNhdXNlIHBj
aV9kaXNhYmxlX21zaS9wY2lfZGlzYWJsZV9tc2l4IHdpbGwgYmUgY2FsbGVkIG9ubHkgaWYNCmFw
cHJvcHJpYXRlIGZsYWdzIGFyZSBzZXQgb24gUEYgYW5kIGlmIHRoaXMgZnVuY3Rpb24gaXMgY2Fs
bGVkIG9uZXMgaXQNCndpbGwgY2xlYXIgdGhvc2UgZmxhZ3MuIFNvIGV2ZW4gaWYgd2UgY2FsbA0K
aTQwZV9yZXNldF9pbnRlcnJ1cHRfY2FwYWJpbGl0eSB0d2ljZSB3ZSB3aWxsIG5vdCBkaXNhYmxl
IG1zaSB2ZWN0b3JzDQp0d2ljZS4NCg0KVGhlIGlzc3VlIGhlcmUgaXMgZGlmZmVyZW50IGhvd2V2
ZXIuIEl0IGlzIGZhaWxpbmcgaW4gZnJlZV9pcnEgYmVjYXVzZQ0Kd2UgYXJlIHRyeWluZyB0byBm
cmVlIGFscmVhZHkgZnJlZSB2ZWN0b3IuIFRoaXMgaXMgYmVjYXVzZSBzZXR1cCBvZg0KbWlzYyBp
cnEgdmVjdG9ycyBpbiBpNDBlX3Byb2JlIGlzIGRvbmUgYWZ0ZXIgaTQwZV9zZXR1cF9wZl9zd2l0
Y2guIElmDQppNDBlX3NldHVwX3BmX3N3aXRjaCBmYWlscyB0aGVuIHdlIHdpbGwganVtcCB0byBl
cnJfdnNpcyBhbmQgY2FsbA0KaTQwZV9jbGVhcl9pbnRlcnJ1cHRfc2NoZW1lIHdoaWNoIHdpbGwg
dHJ5IHRvIGZyZWUgdGhvc2UgbWlzYyBpcnENCnZlY3RvcnMgd2hpY2ggd2VyZSBub3QgeWV0IGFs
bG9jYXRlZC4gV2Ugc2hvdWxkIGhhdmUgdGhlIHByb3BlciBmaXggZm9yDQp0aGlzIHJlYWR5IHNv
b24uDQoNCg==
