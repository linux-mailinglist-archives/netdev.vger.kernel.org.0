Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D599339973D
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 02:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhFCAyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 20:54:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:61010 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229625AbhFCAya (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 20:54:30 -0400
IronPort-SDR: 1WUnx2EExDLCepIZ0BfVwo2fRw/qNa2berjkpnrhCACJqL1redC2wjOFBX0FmDWCXXGr2wADZJ
 XgzOKDpzf8rg==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="225229062"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="225229062"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 17:52:43 -0700
IronPort-SDR: tzGDY/ofGM3+nVzNZUGTIqxjdCSGMwqSrZ1Q3VYerQxUJ8qoKWWEIG33ZuGZMYy/AKa1c4DPmN
 1fuG75yNbJ5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="550503548"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga001.fm.intel.com with ESMTP; 02 Jun 2021 17:52:42 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 17:52:42 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 17:52:42 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 2 Jun 2021 17:52:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 2 Jun 2021 17:52:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yf6kuAp9svexceF0b5o45Oui4AYKBXtxlZgTzXHhpAASKPxy/oHEkln+KuWzER3PsddRRvLqrDsg217EJ3hC3zQzW3spVvHIouIPynNERoRGqTMWXvl3rdhPXLEJ/a3c7GwIPZ7zwEg2LsCRuBKv5TuxCvN+CZc/KT9WCArKnUfNG4lmrbQR6nimsnmP+T4CYUYlIFv4q2BMTRj/rMy8Gtcre0MGGRMd68xqMUiKnGyh7yoMajtLJgLchgqSLqgbfeGE40/kjnIm8iq3cKbh7Pb36/e7Mr/XzlTXicvBLBLs/OMyRGySRqWVycFY5tNq+uwSY9dZPdbG4QwqDzXFKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUWNKMGUrRW3Z32T/sBDLWxw5aV13cb+GMBxIQE5IfU=;
 b=THUSl80YcxRFBURdojuP23pn2TusIWqGduV7hTAAHr83mElldWdd7z9WfukUZitfHA5C1+2in9cT2n1qMBj5Aig6ckQzrnCPXMbrTbmZT4QHlAnUhodpvmOZzJPe2AscMAjf6YXV/sCkFQrxm3W9vWkISrvp3AweRnbz/K69igtPrH/HmGBGgrxV9Hl9Uqf4Up3FU/aZb8oUJ13Cx+/kX76LsOk5eUM8ilY9XwpmPivncRli2EfK2sOD9f0ceBVnoat8oQcwiAylK70Nx67MxP8ioBjtxRYwYYzzpBCVqU6CAxsb+zA4M4msFZWvq3xIv8dLJ4PHYJ8D3MhpaNtAQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUWNKMGUrRW3Z32T/sBDLWxw5aV13cb+GMBxIQE5IfU=;
 b=vSsBOslWDUrWU3eJxUEWmRb010Ut2s3YGZZkYpLKQk0KunXme3xOCophKBuqyNW9MeHP3ywj/g5Zp5KKS/Z3IguNRs2mkUeaKss3Jm1jzzxUmqUOKxQr/rpybo1nJiCzS7Yc+dsCHlyu/tBWZS9xSKRmo6J18pikSoQUV6+EKN4=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3230.namprd11.prod.outlook.com (2603:10b6:805:b8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Thu, 3 Jun
 2021 00:52:38 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c%6]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 00:52:38 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "bjorn@kernel.org" <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH intel-next 2/2] ice: introduce XDP Tx fallback path
Thread-Topic: [PATCH intel-next 2/2] ice: introduce XDP Tx fallback path
Thread-Index: AQHXVtvAzRtQQAIMi0WXDpOmdI5xNqsBeH6A
Date:   Thu, 3 Jun 2021 00:52:38 +0000
Message-ID: <39b84a66bae09568cd1f95802395af3e2df8fdb1.camel@intel.com>
References: <20210601113236.42651-1-maciej.fijalkowski@intel.com>
         <20210601113236.42651-3-maciej.fijalkowski@intel.com>
In-Reply-To: <20210601113236.42651-3-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ffb50578-babf-4205-da94-08d92629e28c
x-ms-traffictypediagnostic: SN6PR11MB3230:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3230C998A8C5895721105876C63C9@SN6PR11MB3230.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q0fZgjC1jA05R1gkc3E2a2Hdyl2tAUKMpas9boX25KOCAsfBXqDyazR2h6dGVq/PaG+db0wLFVhlRHbD6orqfG9S8AI11LVFixmRBCwiOhgkzdXoDK9gWkZSWsTYK011uEGdns2pGax7iq0a/etnBzw7kyJGQ5m7QXjw9jFb/qAkdQLCRJbuuSVSa5VhSN+Q6ELdOI3LiYDgvXSF+K2bP7cBxMGGyZUwuLtF/V1C291uzmII5icB5AbOsy3hPsmKoGGry2jmbZejyo07Pur4snwDLl1/Rtb7/9ZGWCqjY2jiwmS8TE/I0+BujHxU4Gvk5uDHb226i1Gp7AYQChgMZFUq90BvgcludwIsId7Bs56CJy1B62DMTEX1dhWKca1E0kx2FkmzdQ30eqUlV15XAJHORYoldh1mtyEj7wQBZ9y/+zXNjEHJv8M/e9ah1IdZ7YY/t4Qxhl7hbuOY5bvxUpXBIj6hUBWQXmlZlGTWLVhPmHPLVKYAKFzRPjgnJF9Ha7NBh20Gs4S3gxY7cYOgzOdUtmvPKNCPKXhoQ7aYNqkcfUnO2SdEyPBNyuWZ/DCLtAUhRt4EnvBoejMUtct9ta0TQHF24ldBdeHbwouhIwC0qDd4R156yS9gWZuS1phdfGoK+0tX8aVZ27baVpayNkhBYTqnsaFZ+Y5ThX3GNA0M7LP/tH7P/nzcCcjjtnELzqkDuLzTxr5PF0fiILN/iw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(346002)(39860400002)(186003)(26005)(76116006)(2906002)(2616005)(6506007)(478600001)(64756008)(91956017)(966005)(66476007)(66446008)(66556008)(66946007)(316002)(83380400001)(54906003)(110136005)(4326008)(6486002)(122000001)(71200400001)(5660300002)(8936002)(8676002)(36756003)(86362001)(6512007)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TjZGYkhKV0JHNTFPd1VVanQxdGRLVlJJSE9Ud1VLd3dRNEl4VE5GaHJRNXVL?=
 =?utf-8?B?dHFKV0ZRR1RKVWFydGp5M2NVNlBjQzZSK3BpS0JHVDNOUUp4NUhpWWNUWTgr?=
 =?utf-8?B?NzByVW5kSVI2WXRneHhnWWt6Y3VDY21nQ25zN2VLeGY0d2JmUXgvcFgyenpL?=
 =?utf-8?B?dUhrNlcyTWttQjkxZG85RVNXVjl4VThLcnVYYm5FZ3p0VnpLMStjVDJhM3M0?=
 =?utf-8?B?Z3R6WlBPdW1kZHdBVzZIQVVoMU9ud1hpR1F6MHZQUzIrZENIV0h3WERYUURV?=
 =?utf-8?B?MG9ES096dm5ndGs2VTh2RTFGZEMxUldmOUF0OTg2L0Z3RDI5ZEJSRGdTZEZN?=
 =?utf-8?B?ZGRnN1l1eXo3dFNNbWhmQ0N0aEtyaEVWakVYN0FDOUZ0VXE2MUszL2pUZTlJ?=
 =?utf-8?B?dGFNSU91K0Z0RTJUSlRuOVNYOUdVZFFrRGNiK1BvYjlqeTBJWFhqVHpsNWJq?=
 =?utf-8?B?ZElUOWZ6Q2daNjRHbHVSbjZ6NkZpMWlPbEJ6WmR1a0NwVFVHOGhTZWh1V1BK?=
 =?utf-8?B?QmFoZ01ldjNjMTV1cFYvS0xVTGY2ZHgvRVErMDErbkZNajBSZU95RUpKM3dZ?=
 =?utf-8?B?YTdOWjNRaG41RlR6UFFWWSsyWCswYmJVcTJnQk10STEzMEJVUmVyZUJRbnZw?=
 =?utf-8?B?QkFQeXJpWUc0ak1OaXNtMGtiSC8yaHNielVadmdPaHpxMHNPeWRTUG53eGFB?=
 =?utf-8?B?QVMvaW43N2VsVkRDWU1pZ25ZbzZUUmgwcTZ1V2dXNFlqV3U4MXZRcmx6eHIx?=
 =?utf-8?B?OXY1b0FTczRCaEV2WHFsVEJ0eUNwdVRYZEZCajkxZlk2NVRlV09zSFk3M1ZX?=
 =?utf-8?B?WnVzTVJSQ2p1WTFuU2Z5UitDVWFmd2xYVUs3SWtEWGhkR3VyTGRtcmZRVlFV?=
 =?utf-8?B?bUU5QnB6TTVxNDlobmxISU1zWG4xUlA0RHdsbVpZWHJOc2pLYXRjZDAxN2lW?=
 =?utf-8?B?UDc4MkpOamwxWk5yTE9ESGM2cVBQeTJhQWVxYU8yY3h6aFR6dGVSUldRaXNx?=
 =?utf-8?B?dTZvc045QVFlc1puUzI5ZzlhYUhON2ZNM2lBcEE5bzVweWRibU1lQW1FS21S?=
 =?utf-8?B?Y0F1WXBTZFhHOUFhZ2xUUHdPUFZPdzV3K2NjNzFCNXQwMUlXZ3BRa213MWJk?=
 =?utf-8?B?aUE3ZUczVWRyM0phbmEwWVBqMHZhY1c3YTdodUYyMzlYQklRczRWNGI4U2c5?=
 =?utf-8?B?WWRsM3Y3TTZxMThIWjBGQ1g3a0ZWeEN2bS93N0VqR1V1S1BtdTNmZnZZN3Qv?=
 =?utf-8?B?dEJNYU9FR1JFcEU1eHdhcFhZbjgweVZpVUg5T0dTSFF3QndSZ1B5cUVnbXRk?=
 =?utf-8?B?MzBzbDV0S0tFZ1UwZjBDK0w1dGFPdlBlK09FdFltdk5nN2g4bW5lTXErUklP?=
 =?utf-8?B?SEdjRGJzcytJVERrZkNDa01rWGZ2S3A3a01DVFFGbjdtRFlVME9GemVrR2VT?=
 =?utf-8?B?SVY0WU0yUmxwRitwN1FuL2tDalprK2FnTW42aEdLY3dqWG9VeVFnQzlnMjhB?=
 =?utf-8?B?N3AwNk1sdnR3U2VNR2RrMjFGL1lndWhpc0xPeHVtbDQ3QTRaSDRMZng5K2p0?=
 =?utf-8?B?UENrR0t1cDV0ZnJzUnlwM21aTHVWa3FGV2Y5am5JVGxaL3JaaDlzZkNQYUd3?=
 =?utf-8?B?Vm00RU9yQngzVC9YSy9xT2xya24zaS85cHNYNWkyV2hoY0tyVGNXcC9LTngx?=
 =?utf-8?B?WCtncUFacW9pQm50Y1poRW9OQ28rY0VxMWpNOFFVNFF0bmNpWi9yWm9rbVJ3?=
 =?utf-8?Q?/kGubau2eW9kwXurimieq8B9HpR2EjVeV1WPO8f?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <49C88B288A6F2A44AE9C0690F30B4FA0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffb50578-babf-4205-da94-08d92629e28c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 00:52:38.4842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MJuyFDQ+E/HDcUOShfpGy8cmSbAmODKrO+6fBjcbtP/Ma7yPaXZ77FG5xGr7UXoaSqSP9GM5KfkOE/koMgl1ysN+lW3zNwngAmSoUurY0f4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3230
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTA2LTAxIGF0IDEzOjMyICswMjAwLCBNYWNpZWogRmlqYWxrb3dza2kgd3Jv
dGU6DQo+IFVuZGVyIHJhcmUgY2lyY3Vtc3RhbmNlcyB0aGVyZSBtaWdodCBiZSBhIHNpdHVhdGlv
biB3aGVyZSBhDQo+IHJlcXVpcmVtZW50DQo+IG9mIGhhdmluZyBhIFhEUCBUeCBxdWV1ZSBwZXIg
Y29yZSBjb3VsZCBub3QgYmUgZnVsZmlsbGVkIGFuZCBzb21lIG9mDQo+IHRoZQ0KPiBUeCByZXNv
dXJjZXMgd291bGQgaGF2ZSB0byBiZSBzaGFyZWQgYmV0d2VlbiBjb3Jlcy4gVGhpcyB5aWVsZHMg
YQ0KPiBuZWVkDQo+IGZvciBwbGFjaW5nIGFjY2Vzc2VzIHRvIHhkcF9yaW5ncyBhcnJheSBvbnRv
IGNyaXRpY2FsIHNlY3Rpb24NCj4gcHJvdGVjdGVkDQo+IGJ5IHNwaW5sb2NrLg0KPiANCj4gRGVz
aWduIG9mIGhhbmRsaW5nIHN1Y2ggc2NlbmFyaW8gaXMgdG8gYXQgZmlyc3QgZmluZCBvdXQgaG93
IG1hbnkNCj4gcXVldWVzDQo+IGFyZSB0aGVyZSB0aGF0IFhEUCBjb3VsZCB1c2UuIEFueSBudW1i
ZXIgdGhhdCBpcyBub3QgbGVzcyB0aGFuIHRoZQ0KPiBoYWxmDQo+IG9mIGEgY291bnQgb2YgY29y
ZXMgb2YgcGxhdGZvcm0gaXMgYWxsb3dlZC4gWERQIHF1ZXVlIGNvdW50IDwgY3B1DQo+IGNvdW50
DQo+IGlzIHNpZ25hbGxlZCB2aWEgbmV3IFZTSSBzdGF0ZSBJQ0VfVlNJX1hEUF9GQUxMQkFDSyB3
aGljaCBjYXJyaWVzIHRoZQ0KPiBpbmZvcm1hdGlvbiBmdXJ0aGVyIGRvd24gdG8gUnggcmluZ3Mg
d2hlcmUgbmV3IElDRV9UWF9YRFBfTE9DS0VEIGlzDQo+IHNldA0KPiBiYXNlZCBvbiB0aGUgbWVu
dGlvbmVkIFZTSSBzdGF0ZS4gVGhpcyByaW5nIGZsYWcgaW5kaWNhdGVzIHRoYXQNCj4gbG9ja2lu
Zw0KPiB2YXJpYW50cyBmb3IgZ2V0dGluZy9wdXR0aW5nIHhkcF9yaW5nIG5lZWQgdG8gYmUgdXNl
ZCBpbiBmYXN0IHBhdGguDQo+IA0KPiBGb3IgWERQX1JFRElSRUNUIHRoZSBpbXBhY3Qgb24gc3Rh
bmRhcmQgY2FzZSAob25lIFhEUCByaW5nIHBlciBDUFUpDQo+IGNhbg0KPiBiZSByZWR1Y2VkIGEg
Yml0IGJ5IHByb3ZpZGluZyBhIHNlcGFyYXRlIG5kb194ZHBfeG1pdCBhbmQgc3dhcCBpdCBhdA0K
PiBjb25maWd1cmF0aW9uIHRpbWUuIEhvd2V2ZXIsIGR1ZSB0byB0aGUgZmFjdCB0aGF0IG5ldF9k
ZXZpY2Vfb3BzDQo+IHN0cnVjdA0KPiBpcyBhIGNvbnN0LCBpdCBpcyBub3QgcG9zc2libGUgdG8g
cmVwbGFjZSBhIHNpbmdsZSBuZG8sIHNvIGZvciB0aGUNCj4gbG9ja2luZyB2YXJpYW50IG9mIG5k
b194ZHBfeG1pdCwgd2hvbGUgbmV0X2RldmljZV9vcHMgbmVlZHMgdG8gYmUNCj4gcmVwbGF5ZWQu
DQo+IA0KPiBJdCBoYXMgYW4gaW1wYWN0IG9uIHBlcmZvcm1hbmNlICgxLTIgJSkgb2YgYSBub24t
ZmFsbGJhY2sgcGF0aCBhcw0KPiBicmFuY2hlcyBhcmUgaW50cm9kdWNlZC4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IE1hY2llaiBGaWphbGtvd3NraSA8bWFjaWVqLmZpamFsa293c2tpQGludGVsLmNv
bT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlLmggICAgICAg
ICAgfCAzNyArKysrKysrKysNCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2Vf
YmFzZS5jICAgICB8ICA1ICsrDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNl
X2xpYi5jICAgICAgfCAgNCArLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2lj
ZV9tYWluLmMgICAgIHwgNzYNCj4gKysrKysrKysrKysrKysrKysrLQ0KPiAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV90eHJ4LmMgICAgIHwgNjIgKysrKysrKysrKysrKystDQo+
ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3R4cnguaCAgICAgfCAgMiArDQo+
ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3R4cnhfbGliLmMgfCAxMyArKyst
DQo+ICA3IGZpbGVzIGNoYW5nZWQsIDE5MSBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0K
DQpUaGlzIGlzbid0IGFwcGx5aW5nIHRvIG5leHQtcXVldWUvZGV2LXF1ZXVlLiBJIGJlbGlldmUg
aXQncyBiZWN1YXNlIHRoZQ0KYnJhbmNoIGhhcyB0aGUgc29vbiB0byBiZSBzZW50IHRyYWNpbmcg
cGF0Y2ggZnJvbSBNYWdudXMgWzFdLg0KDQpUaGFua3MsDQpUb255DQoNClsxXSBodHRwczovL3Bh
dGNod29yay5vemxhYnMub3JnL3Byb2plY3QvaW50ZWwtd2lyZWQtDQpsYW4vcGF0Y2gvMjAyMTA1
MTAwOTM4NTQuMzE2NTItMy1tYWdudXMua2FybHNzb25AZ21haWwuY29tLw0K
