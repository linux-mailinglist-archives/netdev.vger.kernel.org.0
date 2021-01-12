Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AADE2F36B0
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 18:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404944AbhALRJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 12:09:09 -0500
Received: from mga05.intel.com ([192.55.52.43]:64997 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391323AbhALRJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 12:09:08 -0500
IronPort-SDR: P/kBWUigEDOxox1MHUCSbynzvHZp+V5bG+erWD7yEc9fAKIFlA1naj9N8dK4R+NqKjJjJpoeZC
 0gO48qkDjj+A==
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="262858990"
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="262858990"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 09:08:26 -0800
IronPort-SDR: 6v9rp26VilcGf+NC6nHqMHgLd8VE7zg7+ZZwCJvtDP0PGsTKnY6qiU/FMhf2gdu+Pdn3umanYs
 3iiKD8Q5Xb0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="424230289"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga001.jf.intel.com with ESMTP; 12 Jan 2021 09:08:26 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Jan 2021 09:08:26 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Jan 2021 09:08:25 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 12 Jan 2021 09:08:25 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 12 Jan 2021 09:08:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTmHp9EpAQ8cPpazt8PiJu36FD32N3E/kHaB48Zw6AwenciCTngg7uOhif3MV1350vJcbqnldAXmhOHGMQOx7rvHnkQSgF5Zfctot7PnOQmusJxhrac1oJSoljl4Qrzg0XY5SHEm2qj4621upNB1nrZOPwUpmnSyn25xIERaYcE0U07Tsg4CyC0hyhPIsuRGGz4g7dOwpdjXKzzXOsprrBrqyHiMHWGefWV8ekBMLtCsvJ1rAxZ6T9zj4/uGTzpZNU8FpSdEpBMuWRcK9ozH7W5y1kJYh4pdIQDUsgE7GQtUpu3zJWeHt9a43V2LDORYSsQkKwYL8eprw2ll6MVjQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bj6FFvc6lIxdtcZJ7ZnY1w8VJtGNBs05DGL6gJN905U=;
 b=QVR3v8hvVwD2+mPiF7p7N48cdx/H4vPxp8zn3ON101W8s2/cdA1Ny/3zN1XrM10gI8H4tk9hQA1apcJT5QN5d4vvPDUroOv3Yq2SOcptPjKb+9KG+OZ0NtLVjh8rn5ftiPrhKbnWbwWMfEfaYWNKcjpyl2eym4lAOPuVnWNyxykbP1tIZUoOPRlDJ7YgFO+b9imi5oFZpSsZFK6/BX0BWch1Djmi9dRq82ZfxPJr8GQpbMJErlHmjYBvLj7buVx12cquu9o/zF1awSOyiXJrXOtyS9E/VdC9aAaRAbWw+zFCmM74L+ROuwLjR5JrLF3wjsJM7ojzNxPD/HYN1od/ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bj6FFvc6lIxdtcZJ7ZnY1w8VJtGNBs05DGL6gJN905U=;
 b=DAVea+wOOOySkTDq2i42z0gUzyqc29/2ViTWH9kzsF0lBY/EMyk3UJWb+faQbibamOxJ1DDX6ITJD9C/v9r5KS0jUz/0EEqPZ+q0ItEcQqrgJok+VEoFaBhem6yTW/Miy3PB3lL1TtA9qOe5yVI0MOB324DxZJjwb8esMWomhrQ=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BY5PR11MB4135.namprd11.prod.outlook.com (2603:10b6:a03:190::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 17:08:24 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::2581:444d:50af:1701]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::2581:444d:50af:1701%4]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 17:08:23 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "tiwai@suse.de" <tiwai@suse.de>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] iwlwifi: dbg: Don't touch the tlv data
Thread-Topic: [PATCH 1/2] iwlwifi: dbg: Don't touch the tlv data
Thread-Index: AQHW6PqGpwvtGMquUE2EVmwwr5ThhaokJqGAgAASeIA=
Date:   Tue, 12 Jan 2021 17:08:22 +0000
Message-ID: <3022a89080907456096ef137ffad525fa134b081.camel@intel.com>
References: <20210112132449.22243-1-tiwai@suse.de>
         <20210112132449.22243-2-tiwai@suse.de> <87turmrw9j.fsf@codeaurora.org>
         <s5h5z42qh2w.wl-tiwai@suse.de>
In-Reply-To: <s5h5z42qh2w.wl-tiwai@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [91.156.6.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed244c93-a3a8-4efc-3c0c-08d8b71cab20
x-ms-traffictypediagnostic: BY5PR11MB4135:
x-microsoft-antispam-prvs: <BY5PR11MB41357F4DD2EFA463048D728390AA0@BY5PR11MB4135.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XYHoigni8QN9G+K4/ti7EpXXKbi/CjdWxZ1NuEPRy7xV/Ge3U51ngL95L1afj8BZ6PJ6lfWzyKyxwRNPLgE9rvDI5/2EMFwBpTuBxr8Zp4Js9nETywoYKJfSNlLFJpyAdmsOd2qKPSJkK1CEFxt01hkINlDdVk01lICmGLDTr/wXKRjCWXScjoSahSItD81Y5tr2AkzG17V4tu5mVSY3Atj4q7G6M1prBxZD3crh+lsPmE8AwuZuVhq0Yl4aSyAe6v9Eo1DNqbdio19Aiuhyc4Erd44ZJxTRTbxmeJaHRDRKhsaH5mtMcmWtuCvUay5pSFEvWKm9uxxiiwzn6YEVrVfC/fnVEdxd6uuxslKRiCwebjJeFW2qEOyTcpoYKEoyXN3QWG8gDwQCYm6olZEa0GzQktT0mVi7wph+PT9YpKn7QRv4FtSbDmvqNBCc2bUJ2G+UvihuBPRXjVDQAB4fjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(6486002)(66556008)(26005)(966005)(66476007)(54906003)(5660300002)(64756008)(8936002)(8676002)(66446008)(6512007)(110136005)(66946007)(2906002)(186003)(478600001)(86362001)(316002)(6506007)(71200400001)(91956017)(2616005)(36756003)(76116006)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?UmlYQUZDdzBTdFNxTHlFeHkxeFQ1QTcxVENqcGZMRXhsdy8vb3RTK1BpbkJk?=
 =?utf-8?B?eThCbmthd3BZbWVUdzk0NzhmdFJUMVRGMUlhcGZadnY2bnFydTJzWHB4dm5E?=
 =?utf-8?B?WGpoTkI5NXJrTkF3STRHM2NKV3RxbndsUmtxM2l4UjNPajBKb1JQRWRyMFBo?=
 =?utf-8?B?MXFURzBrTWs0UDBLM2RLRlJ0cCtvbmU0Ty82MjJuOHB5WXgwU1d3YzYwYmda?=
 =?utf-8?B?V0ZSMHovMXhMaS80cy9CTTFFWlZJSitVeHAxOVVlYWc2TVFGWDk2VnpUQi9l?=
 =?utf-8?B?ZDJXcVVOaTh5RDZncFFvdDBLNzd4OXZQL2ZVQ3JGRnJGTTJZbHh0c2hja0Rl?=
 =?utf-8?B?aWJjREg3dmN6MzNrTkNiV04vNUJmVzR2dUFDcHp2R2ZaVTNXQ0xDQTNFRnVD?=
 =?utf-8?B?WlNoNHdZWG1JV2FVbkxXbzE2RG5JQWxqOXJNUG1mT2VPdTR6bVdYaG9ialhE?=
 =?utf-8?B?VDdtNmR5NnRBdmJ1VUFyOFIxcUYwQlljNkh5SzlqcUM2TzBCZmt0NjE0ZHJn?=
 =?utf-8?B?aVZ3RE5naDRMdmdVR04rd3VBRkxFbDJ1VytweDFwajB6WGxqaFFUS2EvbmZO?=
 =?utf-8?B?OUJicmpMRmhuWlNPcWR6amczWlZhNUkvZzVsVnA4d1lRWHMybCtoY3hsYTVH?=
 =?utf-8?B?eTU3eUhoaXV3RTBJK1JBV2FmSTZzTUdPdVdPOW5XdVRBeUcwdm1taVZIeVNy?=
 =?utf-8?B?RTFUQS8zcklRb0I2SFVQbEwxenRGeng3RVQyblhuaUVwaDNrbkcraThLU3p5?=
 =?utf-8?B?MnNsbjZiY0h4UC9lc0lVTEkwQWRrVlEwSkl6OStNVklaQWxzZFVnM0JRU2h1?=
 =?utf-8?B?dHM2elMzQVZtZVJEaEp2T1NRZjhmQ2piY3lTUFNRS1gyT01pT21leUU5eVlo?=
 =?utf-8?B?TUQ5MzFVcGtadEI2bjNETFl4ZXJjTll2bTVjYnVPeFNLZ2Yyc3RuaHpEV2VQ?=
 =?utf-8?B?RVR4VUZCNFFTMXhVUWV4ek5vQzAzWVN5RThDTXZsVlhNcWtveVNQRnVIaE9T?=
 =?utf-8?B?ZVk1MGZkM1RYQ1h1WjRMSTFNSHcxT216QXJFSDlBbDZkQlVFYXVITUdPZW96?=
 =?utf-8?B?Ni9QY2ZOVDZRUVpJRm5jbTNkWEVOUWhOZDRlbXpScEdzMFkraU1pVXlOWGRq?=
 =?utf-8?B?bTdwNEg2djZNMVhqeEdtUm02T3RGc1NCb1VMcGZWVnp1Tnd6WWZxOUMrL1Q0?=
 =?utf-8?B?QzJoYjdnSkhIb0M3YldyVU5ZdzNycEJVd3pMVm5EWmxuYUh1UHdkNzJLOEht?=
 =?utf-8?B?SXVtMWZQNWdrbm12UHBvMjY5Wm1JMWVKaGNDeGVNek9tM1dNUGliZUNtbXdl?=
 =?utf-8?Q?KJ6y7wqKztFaCGRJZgdUDl1iFGVXHN4n2p?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3EDCC48A9B2C3F489D64758E18438E60@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed244c93-a3a8-4efc-3c0c-08d8b71cab20
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2021 17:08:22.9399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7WVybyQvKdxsxHaZN9tfTtsDOmbLdO2TGBeih3MI/Nbn/iaxG5snLvxLIMspHGFXQOZEMjHfDax198Siug+TeTI1PDu9PDJdmg8fKVOqmYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4135
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTAxLTEyIGF0IDE3OjAyICswMTAwLCBUYWthc2hpIEl3YWkgd3JvdGU6DQo+
IE9uIFR1ZSwgMTIgSmFuIDIwMjEgMTY6NDg6NTYgKzAxMDAsDQo+IEthbGxlIFZhbG8gd3JvdGU6
DQo+ID4gDQo+ID4gVGFrYXNoaSBJd2FpIDx0aXdhaUBzdXNlLmRlPiB3cml0ZXM6DQo+ID4gDQo+
ID4gPiBUaGUgY29tbWl0IGJhOGY2ZjRhZTI1NCAoIml3bHdpZmk6IGRiZzogYWRkIGR1bXBpbmcg
c3BlY2lhbCBkZXZpY2UNCj4gPiA+IG1lbW9yeSIpIGFkZGVkIGEgdGVybWluYXRpb24gb2YgbmFt
ZSBzdHJpbmcganVzdCB0byBiZSBzdXJlLCBhbmQgdGhpcw0KPiA+ID4gc2VlbXMgY2F1c2luZyBh
IHJlZ3Jlc3Npb24sIGEgR1BGIHRyaWdnZXJlZCBhdCBmaXJtd2FyZSBsb2FkaW5nLg0KPiA+ID4g
QmFzaWNhbGx5IHdlIHNob3VsZG4ndCBtb2RpZnkgdGhlIGZpcm13YXJlIGRhdGEgdGhhdCBtYXkg
YmUgcHJvdmlkZWQNCj4gPiA+IGFzIHJlYWQtb25seS4NCj4gPiA+IA0KPiA+ID4gVGhpcyBwYXRj
aCBkcm9wcyB0aGUgY29kZSB0aGF0IGNhdXNlZCB0aGUgcmVncmVzc2lvbiBhbmQga2VlcCB0aGUg
dGx2DQo+ID4gPiBkYXRhIGFzIGlzLg0KPiA+ID4gDQo+ID4gPiBGaXhlczogYmE4ZjZmNGFlMjU0
ICgiaXdsd2lmaTogZGJnOiBhZGQgZHVtcGluZyBzcGVjaWFsIGRldmljZSBtZW1vcnkiKQ0KPiA+
ID4gQnVnTGluazogaHR0cHM6Ly9idWd6aWxsYS5zdXNlLmNvbS9zaG93X2J1Zy5jZ2k/aWQ9MTE4
MDM0NA0KPiA+ID4gQnVnTGluazogaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVn
LmNnaT9pZD0yMTA3MzMNCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFRha2FzaGkgSXdhaSA8dGl3YWlA
c3VzZS5kZT4NCj4gPiANCj4gPiBJJ20gcGxhbm5pbmcgdG8gcXVldWUgdGhpcyB0byB2NS4xMS4g
U2hvdWxkIEkgYWRkIGNjIHN0YWJsZT8NCj4gDQo+IFllcywgaXQgaGl0cyA1LjEwLnkuDQo+IA0K
PiA+IEx1Y2EsIGNhbiBJIGhhdmUgeW91ciBhY2s/DQo+IA0KPiBJdCdkIGJlIGdyZWF0IGlmIHRo
aXMgZml4IGdvZXMgaW4gcXVpY2tseS4NCg0KVGhhbmtzIGZvciB0aGUgZml4IQ0KDQpBY2tlZC1i
eTogTHVjYSBDb2VsaG8gPGx1Y2lhbm8uY29lbGhvQGludGVsLmNvbT4NCg0KDQoNCj4gQlRXLCBJ
IHRob3VnaHQgbmV0d29yayBwZW9wbGUgZG9uJ3Qgd2FudCB0byBoYXZlIENjLXRvLXN0YWJsZSBp
biB0aGUNCj4gcGF0Y2gsIHNvIEkgZGlkbid0IHB1dCBpdCBieSBteXNlbGYuICBJcyB0aGlzIHJ1
bGUgc3RpbGwgdmFsaWQ/DQoNCkluIHRoZSB3aXJlbGVzcyBzaWRlIG9mIG5ldHdvcmssIHdlJ3Zl
IGFsd2F5cyB1c2VkIENjIHN0YWJsZSB3aGVuDQpuZWVkZWQsIGJ1dCB0aGUgRml4ZXMgdGFnIGl0
c2VsZiB3aWxsIGFsbW9zdCBhbHdheXMgdHJpZ2dlciB0aGUgc3RhYmxlDQpwZW9wbGUgdG8gdGFr
ZSBpdCBhbnl3YXkuDQoNCi0tDQpDaGVlcnMsDQpMdWNhLg0K
