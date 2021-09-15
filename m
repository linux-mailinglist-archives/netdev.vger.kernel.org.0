Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E694F40C311
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 11:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237026AbhIOJzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 05:55:21 -0400
Received: from mga06.intel.com ([134.134.136.31]:8786 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232046AbhIOJzR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 05:55:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10107"; a="283272900"
X-IronPort-AV: E=Sophos;i="5.85,295,1624345200"; 
   d="scan'208";a="283272900"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2021 02:53:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,295,1624345200"; 
   d="scan'208";a="544772594"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Sep 2021 02:53:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 15 Sep 2021 02:53:57 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 15 Sep 2021 02:53:57 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 15 Sep 2021 02:53:57 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 15 Sep 2021 02:53:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MgmAcXkz0s0oSPAA4JNSChQZpwyPnF73xQMGTJ5S/1pxy8Nd/cB1qmRxjJj0hRPupoiQzS3hbAScmM1vhWar+UAUZFAPEBR+PSZy0GxjpluLPsHwTJ9iFGVPZh3KQ1qtv5WQkQPRtkOgpBGxKTo/2/7d37a7FT5Hox4Byanz6A23Ja1zU9tqNPnxw2TBrGxYgZJBTSuV7D+1HtWeywL0ENwq/n6vpBBQS+2pZGd715p2N82ttv01NIXBn3F+N2XAkfsPPEE3jW7b05L9O/F7lPl0mUGMe2QxRFpINTZgFmXj9Qec2/fse5/f1Q27VMRZeD5TCrJhGxuunDn8K+NX+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=0SD3RRgyhLMt5WtHyE28tdaN9EZzai3d+Mj8NtyXdrk=;
 b=T6IzcAgOT5ZOsno7IlFjQChEcncwoGEunAAu8whM9+MtU3tVTU7H+aVffzSKg0golk/6kLhc/5sp2an2nfNQdZUgluriixeJpCZH4BEQE9IwrjbxsvxvBXt7DvMgSZR1NmC9RLGqdmvy1QEXYOVfSfoSvzJsIhx/ferwWJTKJfNJKbgL6IuLe1OkGpV+pGj8+7F5595FeW8+JAEJtkcAwGCjiGr9XPn29erdJJFajG7d0Gdd3hkRRoUFUsRVpiJlHaNG5zU/0plwGuEpASksNeQD3aSo5LLNHQ9DGaEZV8LnLJ5x7VhUa1qQMzsZNlKIqVBUivNwY0FgPfotj7ZnHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SD3RRgyhLMt5WtHyE28tdaN9EZzai3d+Mj8NtyXdrk=;
 b=n2SOT0xxtcmcuPUwtsWB5v40a2hNLIvv3S4mD3LVKWSwJCsYQz0CK22sCFrrRa3dHDK6ZZfgSVIiEkLrYmlEAN7bVXlD2IU3w90+36ujEVIUYz5hUKvpQibRO+vI47MicCJh8bnqi/xEtDlA8+taRyM+k8GBfOLuvj+czCs68VA=
Received: from DM6PR11MB3371.namprd11.prod.outlook.com (2603:10b6:5:e::22) by
 DM6PR11MB3835.namprd11.prod.outlook.com (2603:10b6:5:139::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.17; Wed, 15 Sep 2021 09:53:55 +0000
Received: from DM6PR11MB3371.namprd11.prod.outlook.com
 ([fe80::ade9:932c:827d:895]) by DM6PR11MB3371.namprd11.prod.outlook.com
 ([fe80::ade9:932c:827d:895%5]) with mapi id 15.20.4500.018; Wed, 15 Sep 2021
 09:53:55 +0000
From:   "Dziedziuch, SylwesterX" <sylwesterx.dziedziuch@intel.com>
To:     PJ Waskiewicz <pwaskiewicz@jumptrading.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pjwaskiewicz@gmail.com" <pjwaskiewicz@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Subject: RE: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Thread-Topic: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Thread-Index: AQHXmsiBRJTk/bztnkiJewAWaKSBqquMjXAAgAGS54CAFFexAIAAD6UAgADBxBCAAONggIAAyeVA
Date:   Wed, 15 Sep 2021 09:53:54 +0000
Message-ID: <DM6PR11MB3371B4431AD7C46672C7E439E6DB9@DM6PR11MB3371.namprd11.prod.outlook.com>
References: <20210826221916.127243-1-pwaskiewicz@jumptrading.com>
         <50c21a769633c8efa07f49fc8b20fdfb544cf3c5.camel@intel.com>
         <20210831205831.GA115243@chidv-pwl1.w2k.jumptrading.com>
         <MW4PR14MB4796AE05A868B47FE4F6E12AA1D99@MW4PR14MB4796.namprd14.prod.outlook.com>
 <bebb58f34ed68025e95f8bc060af58a24333374b.camel@intel.com>
 <DM6PR11MB3371A3D1F314F3B8541FAF03E6DA9@DM6PR11MB3371.namprd11.prod.outlook.com>
 <MW4PR14MB47960CC778789EEE8E8A54EDA1DA9@MW4PR14MB4796.namprd14.prod.outlook.com>
In-Reply-To: <MW4PR14MB47960CC778789EEE8E8A54EDA1DA9@MW4PR14MB4796.namprd14.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: jumptrading.com; dkim=none (message not signed)
 header.d=none;jumptrading.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27796055-0225-49dd-bd3d-08d9782ebb1d
x-ms-traffictypediagnostic: DM6PR11MB3835:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB38352799BD566A7B474CD682E6DB9@DM6PR11MB3835.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vWPBut4Sqp1CV5C0vrhC8XM9xdfW+f69WBlPc8LIT/kHeAAxFDWYXNZP6+iq54m6VKST77ssKdl6u9XJb0U5NoLqyVCZy0CGe5OWFvfxDRDJfenqey3HpChC849Udu+fiR3X/cVgjhL33WYcGGC4yrLu9pY2X9IpVaZhkQukofWK2Wx/TLxH6dvt5d0xkB1u5CHegQuqZor+RfLK+DSd6YvbdinZyyPndxrwc7PxeKe6FMPwpZR6+DKAMQCjXV4LnCZVfDLlv7aII/l61k3q6Tm2Kd4zadUf30YYZdldEncdX0iXQUpw+n64EHJAQ5IwzedkVIXP2oI4ztIJa7Yas2xQ4lC2xb+22W6QOKW57Ev+kEe7zZUUY8x+w6jb6IjIB2LPWXsvy1m++PXyDB4Z3HHCCxIlqdKZfME42QjtOiTowHfO++u1IaB5CosIRUMos8GfDiHOYEmwn3plKiSpiPfe9Jhgu1MMggD+EpL+z1BXIm5vQOpkJ1WAhcGsWAxvjWgvjCZFww6eZ8qUN7RW7O1PLZiIT/fO0ocx8Xa15M0JDx6Q28mA+nsMRXFWczmHYRFPxaWKz9edkFUC/UApWeJT2HI2HPG29TPwORIJc1K3wzp2foC1jKSmV9PTrlQt6pKOU5k6/aYg9vW077USEfk+l0K5kB4AZlmKUq6e5uEcZcNYJuGpNRIqSi9cFfyPr5lsmNQg0U58i+6xoYSi5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3371.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(71200400001)(8676002)(64756008)(76116006)(86362001)(52536014)(7696005)(33656002)(38100700002)(107886003)(66946007)(66446008)(5660300002)(6636002)(66556008)(316002)(54906003)(110136005)(53546011)(26005)(6506007)(8936002)(66476007)(478600001)(122000001)(55016002)(9686003)(4326008)(186003)(2906002)(83380400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0I2NDhmd1JzTUVJTi9LekxUK1huTzhxK1Vqa2hVMFFzc1J5d2QvZTFXR1Bz?=
 =?utf-8?B?dGVkUGhPR05qQXF0UUlaVk1XTlV5cmZiK2c5ZjAyOVdlN2hPa0d0V2YrR3Ns?=
 =?utf-8?B?eEpwNWczR1lpR3lXdnJiV2xRT0Z5NjFTckFjdHJYeVprNThKcFZ4UWV5V3ZP?=
 =?utf-8?B?ekllN1FjaXB2aEFpWFFjc2VPdTZnVHdnbzRhMW5rVDVGNGxmVWQwemVYMG91?=
 =?utf-8?B?am56eGtaOUZ6WkNxOU5sZktsN0NDdDQydy9vS2Q0QVhKejlOZzYzT096UVJN?=
 =?utf-8?B?RXBHNm40RGxrSkFrTkVFbkVvTGtzUEd6VFAyQjdkMi8yRXFjeGN6Ui9RN2R0?=
 =?utf-8?B?ZDNOZ1JWOFVFRWZrOFdDWHVoaFplTnRMZFpwZStieDl0Mk9ybkZwN1lDNjcv?=
 =?utf-8?B?MnYveFBXVFdjVkRJNGZlZi9aam5OZENLc256azRwRXZjbDBZMVFuZkN1M21a?=
 =?utf-8?B?WVQ5M2V6OEpwK2pOalFyaDJqY2R4QytRSFFwU25wWmc1WkdoRGFackNlaWlU?=
 =?utf-8?B?N3BqV0h2T29TS2hxbFBQWHFEQXhtTDJtRTMxR1dtYWpkLzlnUzNpTVY4ckRl?=
 =?utf-8?B?NmUyU1FqdloyZEM1Uzdnd2lNMmZnbEc1SFI0dHhJVHBGbkZkNVhWTy9lV1lo?=
 =?utf-8?B?OG5lYzk0NDVjTFdXc3dYRHBHb0NEb0ZYSDl3U0haellCZkF5aXRyZ2VRM0d0?=
 =?utf-8?B?aGVIUXBWenFFWjJuM1JTM1hhRk9sUElsczdrbjRaOFAycXh3M2g3elhnaUx1?=
 =?utf-8?B?TjlTZm5TTk9vNmhZZkw0RWNEMjRpYWpIckE3VUFtZzV6VlVxWnN1TWxua2Qx?=
 =?utf-8?B?RlZoZ0JNMnJtbCtzQThZSU9XOUlIVEVLUGhFaHlyZ2xyd3UrdzdiM1hvZzA4?=
 =?utf-8?B?TldVSVAvS1BFZWkra0czejhuc1JKeUwwTjFTdUtqeFlmWWZNNVlnTDFJQjh4?=
 =?utf-8?B?RGMxcjN0SEoxWUN6WHV0RXF6QjlwVHNRcmxSa2dQQ0VCNGZsWW1sOUtJbkFZ?=
 =?utf-8?B?WkRaSmRNNWxyR3kwL084TDRZSHd3b1hYdCtQWFVldTdadXFtMkUrK1dnNkZF?=
 =?utf-8?B?N21qbkxTN21RaC9nM3JOK0JUdHZDb3QvelcvNmQ5eTBOdXprdEhjQkx1WldW?=
 =?utf-8?B?RWhQWWY0Zm55NVJyVlN0dDhQbmNpeFdReVFUL0ZuVVorSm5rQitNalJwejla?=
 =?utf-8?B?RVAyS296Nktialk3ckRBK1g3TWZ5Tnc5TElrN3RUV2htWlJTTzlTY2ZzSFRZ?=
 =?utf-8?B?WHZIMjdTdTdLdFlQM2N5Z3BBRFBYY2Y5WFBFOHdqR2QwejQ0MTRmMUdJdlds?=
 =?utf-8?B?SmxSN1ZrUFV4YkEzbnVhZXIyanYweGtCQWdqdUlWZDFScTlqK0lhdVF1VWd1?=
 =?utf-8?B?ZkIvQ1NvQUdLei9VTkczajJ3bm9oVkpJQ2g2bDcrUWVmZTJ2Z2kzdFlUV0sy?=
 =?utf-8?B?cU8wNnNCbm56RVpacHMyYUw5SUk2UG9kb20xOWMyek5VazBSMmkxRDJTZnZN?=
 =?utf-8?B?c1BzZjN4cmxYWEVEeEdZWldTVFBmOUZpeG1SQ1pCSUdPVnlyVFFTTStPd01j?=
 =?utf-8?B?eCs0VERMMER0QWE2bUZOWFdnREZYYk1YV0xnQmdOTVN1OG9VOTNZUVdHZHAy?=
 =?utf-8?B?YlEwYXhyS3h4NjRVeDRDMWJueDUxY0hNZWZwTldCNU5vWi90WUs3K2V4bWFp?=
 =?utf-8?B?QWpVVGNHeUJLam03RFJPRkxHc01SMzR5NmtlY2xPZFh6UWtxUExQTmdqMUtD?=
 =?utf-8?Q?wCv9v6D1RwuIDEnByo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3371.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27796055-0225-49dd-bd3d-08d9782ebb1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2021 09:53:54.3018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NndBTbGmxmXHP+/D1AXax6z/boK0rFTKK+ih6/7jVF2Hq0Md5yFnQqc11o20uHjaD/7eyIlTaDPq1lpgDQ0XTSW9fHSLoPnGWzAq6rhcPMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3835
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gUEoNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQSiBXYXNr
aWV3aWN6IDxwd2Fza2lld2ljekBqdW1wdHJhZGluZy5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIFNl
cHRlbWJlciAxNCwgMjAyMSAxMTo0MSBQTQ0KPiBUbzogRHppZWR6aXVjaCwgU3lsd2VzdGVyWCA8
c3lsd2VzdGVyeC5kemllZHppdWNoQGludGVsLmNvbT47IE5ndXllbiwNCj4gQW50aG9ueSBMIDxh
bnRob255Lmwubmd1eWVuQGludGVsLmNvbT4NCj4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IHBq
d2Fza2lld2ljekBnbWFpbC5jb207IEZpamFsa293c2tpLCBNYWNpZWoNCj4gPG1hY2llai5maWph
bGtvd3NraUBpbnRlbC5jb20+OyBMb2t0aW9ub3YsIEFsZWtzYW5kcg0KPiA8YWxla3NhbmRyLmxv
a3Rpb25vdkBpbnRlbC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBCcmFuZGVidXJnLCBK
ZXNzZQ0KPiA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+OyBpbnRlbC13aXJlZC1sYW5AbGlz
dHMub3N1b3NsLm9yZzsNCj4gTWFjaG5pa293c2tpLCBNYWNpZWogPG1hY2llai5tYWNobmlrb3dz
a2lAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSRTogW1BBVENIIDEvMV0gaTQwZTogQXZvaWQgZG91
YmxlIElSUSBmcmVlIG9uIGVycm9yIHBhdGggaW4gcHJvYmUoKQ0KPiANCj4gSGkgU3lsd2VzdGVy
LA0KPiANCj4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+IEZyb206IER6aWVkeml1
Y2gsIFN5bHdlc3RlclggPHN5bHdlc3RlcnguZHppZWR6aXVjaEBpbnRlbC5jb20+DQo+ID4gU2Vu
dDogVHVlc2RheSwgU2VwdGVtYmVyIDE0LCAyMDIxIDE6MjQgQU0NCj4gPiBUbzogTmd1eWVuLCBB
bnRob255IEwgPGFudGhvbnkubC5uZ3V5ZW5AaW50ZWwuY29tPjsgUEogV2Fza2lld2ljeg0KPiA+
IDxwd2Fza2lld2ljekBqdW1wdHJhZGluZy5jb20+DQo+ID4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5u
ZXQ7IHBqd2Fza2lld2ljekBnbWFpbC5jb207IEZpamFsa293c2tpLCBNYWNpZWoNCj4gPiA8bWFj
aWVqLmZpamFsa293c2tpQGludGVsLmNvbT47IExva3Rpb25vdiwgQWxla3NhbmRyDQo+ID4gPGFs
ZWtzYW5kci5sb2t0aW9ub3ZAaW50ZWwuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgQnJh
bmRlYnVyZywNCj4gPiBKZXNzZSA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+OyBpbnRlbC13
aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZw0KPiA+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggMS8xXSBp
NDBlOiBBdm9pZCBkb3VibGUgSVJRIGZyZWUgb24gZXJyb3IgcGF0aCBpbg0KPiA+IHByb2JlKCkN
Cj4gPg0KPiANCj4gW3NuaXBdDQo+IA0KPiA+ID4gPiBJdCdzIGJlZW4gMiB3ZWVrcyBzaW5jZSBJ
IHJlcGxpZWQuICBBbnkgdXBkYXRlIG9uIHRoaXM/ICBNYWNpZWoNCj4gPiA+ID4gaGFkIGFscmVh
ZHkgcmV2aWV3ZWQgdGhlIHBhdGNoLCBzbyBob3Bpbmcgd2UgY2FuIGp1c3QgbW92ZSBhbG9uZw0K
PiA+ID4gPiB3aXRoIGl0LCBvciBnZXQgc29tZXRoaW5nIGVsc2Ugb3V0IHNvb24/DQo+ID4gPiA+
DQo+ID4gPiA+IEknZCByZWFsbHkgbGlrZSB0aGlzIHRvIG5vdCBqdXN0IGZhbGwgaW50byBhIHZv
aWQgd2FpdGluZyBmb3IgYQ0KPiA+ID4gPiBkaWZmZXJlbnQgcGF0Y2ggd2hlbiB0aGlzIGZpeGVz
IHRoZSBpc3N1ZS4NCj4gPiA+DQo+ID4gPiBIaSBQSiwNCj4gPiA+DQo+ID4gPiBJIGhhdmVuJ3Qg
c2VlbiBhIHJlY2VudCB1cGRhdGUgb24gdGhpcy4gSSdtIGFza2luZyBmb3IgYW4gdXBkYXRlLg0K
PiA+ID4gT3RoZXJ3aXNlLCBBbGV4IGFuZCBTeWx3ZXN0ZXIgYXJlIG9uIHRoaXMgdGhyZWFkOyBw
ZXJoYXBzIHRoZXkgaGF2ZQ0KPiA+ID4gc29tZSBpbmZvLg0KPiA+ID4NCj4gPiA+IFRoYW5rcywN
Cj4gPiA+IFRvbnkNCj4gPiA+DQo+ID4NCj4gPiBIZWxsbywNCj4gPg0KPiA+IFRoZSBkcml2ZXIg
ZG9lcyBub3QgYmxpbmRseSB0cnkgdG8gZnJlZSBNU0ktWCB2ZWN0b3IgdHdpY2UgaGVyZS4gVGhp
cw0KPiA+IGlzIGd1YXJkZWQgYnkgSTQwRV9GTEFHX01TSVhfRU5BQkxFRCBhbmQgSTQwRV9GTEFH
X01TSV9FTkFCTEVEDQo+IGZsYWdzLg0KPiA+IE9ubHkgaWYgdGhvc2UgZmxhZ3MgYXJlIHNldCB3
ZSB3aWxsIHRyeSB0byBmcmVlIE1TSS9NU0ktWCB2ZWN0b3JzIGluDQo+ID4gaTQwZV9yZXNldF9p
bnRlcnJ1cHRfY2FwYWJpbGl0eSgpLiBBZGRpdGlvbmFsbHkNCj4gPiBpNDBlX3Jlc2V0X2ludGVy
cnVwdF9jYXBhYmlsaXR5KCkgY2xlYXJzIHRob3NlIGZsYWdzIGV2ZXJ5IHRpbWUgaXQgaXMNCj4g
PiBjYWxsZWQgc28gZXZlbiBpZiB3ZSBjYWxsIGl0IHR3aWNlIGluIGEgcm93IHRoZSBkcml2ZXIg
d2lsbCBub3QgZnJlZQ0KPiA+IHRoZSB2ZWN0b3JzIHR3aWNlLiBJIHJlYWxseSBjYW4ndCBzZWUg
aG93IHRoaXMgcGF0Y2ggaXMgZml4aW5nDQo+ID4gYW55dGhpbmcgYXMgdGhlIGlzc3VlIGhlcmUg
aXMgbm90IHdpdGggTVNJIHZlY3RvcnMgYnV0IHdpdGggbWlzYyBJUlENCj4gPiB2ZWN0b3JzLiBX
ZSBoYXZlIGEgcHJvcGVyIHBhdGNoIGZvciB0aGlzIHJlYWR5IGluIE9PVCBhbmQgd2Ugd2lsbA0K
PiA+IHVwc3RyZWFtIGl0IHNvb24uIFRoZSBwcm9ibGVtIGhlcmUgaXMgdGhhdCBpbg0KPiA+IGk0
MGVfY2xlYXJfaW50ZXJydXB0X3NjaGVtZSgpIGRyaXZlciBjYWxscyBpNDBlX2ZyZWVfbWlzY192
ZWN0b3IoKSBidXQNCj4gPiBpbiBjYXNlIFZTSSBzZXR1cCBmYWlscyBtaXNjIHZlY3RvciBpcyBu
b3QgYWxsb2NhdGVkIHlldCBhbmQgd2UgZ2V0IGENCj4gPiBjYWxsIHRyYWNlIGluIGZyZWVfaXJx
IHRoYXQgd2UgYXJlIHRyeWluZyB0byBmcmVlIElSUSB0aGF0IGhhcyBub3QgYmVlbg0KPiBhbGxv
Y2F0ZWQgeWV0Lg0KPiANCj4gVGhhdCdzIGZpbmUuICBJIGRvIHNlZSB0aGUgZ3VhcmRzIGZvciB0
aGUgcXVldWUgdmVjdG9ycy4gIEkgc2F3IHRoZW0gYmVmb3JlLiAgVGhlDQo+IHBvaW50IGlzIGk0
MGVfY2xlYXJfaW50ZXJydXB0X3NjaGVtZSgpIHRyaWVzIHRvIGZyZWUgdGhlIE1JU0MgdmVjdG9y
IHdpdGhvdXQNCj4gZ3VhcmQsIG9yIHdpdGhvdXQgYW55IGNoZWNrIGlmIGl0IHdhcyBhbGxvY2F0
ZWQgYmVmb3JlLiAgSW4gdGhlIGVycm9yIHBhdGgsIGl0IHRyaWVzDQo+IHRvIGZyZWUgaXQuICBX
ZSBnZXQgYW4gb29wcyBmb3IgYSBkb3VibGUtZnJlZSBvZiBhbiBJUlEgKGFsc28gcmVhZDogZnJl
ZSBhbg0KPiB1bmFsbG9jYXRlZCBpbnRlcnJ1cHQpLg0KPiANCj4gSSBrbm93IGhvdyB0aGlzIGNv
ZGUgd29ya3MuICBJIHdyb3RlIHRoZSBvcmlnaW5hbCByZXNldC9jbGVhciBpbnRlcnJ1cHQgc2No
ZW1lDQo+IGZ1bmN0aW9ucyBpbiBpeGdiZSwgYW5kIHBvcnRlZCB0aGVtIHRvIGk0MGUgd2hlbiBJ
IHdyb3RlIHRoZSBpbml0aWFsIGRyaXZlci4gIFdlDQo+IGhpdCBhIHByb2JsZW0gaW4gcHJvZHVj
dGlvbiwgYW5kIEknbSB0cnlpbmcgdG8gcGF0Y2ggaXQgd2hlcmUgd2UgZG9uJ3QgbmVlZCB0bw0K
PiBjYWxsIGNsZWFyX2ludGVycnVwdF9zY2hlbWUoKSBpZiB3ZSBmYWlsIHRvIGJyaW5nIHRoZSBt
YWluIFZTSSBvbmxpbmUgZHVyaW5nDQo+IHByb2JlLiAgSSBkb24ndCBzZWUgd2h5IHRoaXMgbmVl
ZHMgdG8gYmUgYSBzZW1hbnRpYyBkaXNjdXNzaW9uIG92ZXIgaG93IHRoZQ0KPiB2ZWN0b3JzIGFy
ZSBmcmVlZC4gIFdlIGhhdmUgYSB2YWxpZCBvb3BzLCBzdGlsbCBoYXZlIGl0IHVwc3RyZWFtLg0K
PiANCj4gSSd2ZSBhbHNvIGNoZWNrZWQgdGhlIE9PVCBkcml2ZXIgb24gU291cmNlRm9yZ2UgcmVs
ZWFzZWQgaW4gSnVseS4gIEl0IGhhcyB0aGUNCj4gc2FtZSBwcm9ibGVtOg0KPiANCj4gc3RhdGlj
IHZvaWQgaTQwZV9jbGVhcl9pbnRlcnJ1cHRfc2NoZW1lKHN0cnVjdCBpNDBlX3BmICpwZikgew0K
PiAgICAgICAgIGludCBpOw0KPiANCj4gICAgICAgICBpNDBlX2ZyZWVfbWlzY192ZWN0b3IocGYp
Ow0KPiANCj4gICAgICAgICBpNDBlX3B1dF9sdW1wKHBmLT5pcnFfcGlsZSwgcGYtPml3YXJwX2Jh
c2VfdmVjdG9yLA0KPiAgICAgICAgICAgICAgICAgICAgICAgSTQwRV9JV0FSUF9JUlFfUElMRV9J
RCk7IFsuLi5dDQo+IA0KPiBJJ3ZlIGFsc28gYmVlbiB0b2xkIGJ5IHNvbWUgZnJpZW5kcyB0aGF0
IG5vIGZpeCBleGlzdHMgaW4gaW50ZXJuYWwgZ2l0IGVpdGhlci4gIFNvDQo+IHBsZWFzZSwgZWl0
aGVyIHByb3Bvc2UgYSBmaXgsIGFzayBtZSB0byBjaGFuZ2UgdGhlIHBhdGNoLCBvciBtZXJnZSBp
dC4gIEknZCByZWFsbHkNCj4gbGlrZSB0byBoYXZlIG91ciBPUyB2ZW5kb3IgYmUgYWJsZSB0byBw
aWNrIHVwIHRoaXMgZml4IGFzYXAgb25jZSBpdCBoaXRzIGFuDQo+IHVwc3RyZWFtIHRyZWUuDQo+
IA0KPiBDaGVlcnMsDQo+IC1QSiBXYXNraWV3aWN6DQo+IA0KDQpZb3UgYXJlIHJpZ2h0IHRoZSBw
cm9ibGVtIGlzIHdpdGggbWlzYyBJUlEgdmVjdG9yIGJ1dCBhcyBmYXIgYXMgSSBjYW4gc2VlIHRo
aXMgcGF0Y2ggb25seSBtb3ZlcyBpNDBlX3Jlc2V0X2ludGVycnVwdF9jYXBhYmlsaXR5KCkgb3V0
c2lkZSBvZiBpNDBlX2NsZWFyX2ludGVycnVwdF9zY2hlbWUoKS4gSXQgZG9lcyBub3QgZml4IHRo
ZSBwcm9ibGVtIG9mIGk0MGVfZnJlZV9taXNjX3ZlY3RvcigpIG9uIHVuYWxsb2NhdGVkIHZlY3Rv
ciBpbiBlcnJvciBwYXRoLiBXZSBoYXZlIGEgcHJvcGVyIGZpeCBmb3IgdGhpcyB0aGF0IGFkZHMg
YWRkaXRpb25hbCBjaGVjayBmb3IgX19JNDBFX01JU0NfSVJRX1JFUVVFU1RFRCBiaXQgdG8gaTQw
ZV9mcmVlX21pc2NfdmVjdG9yKCk6DQoNCglpZiAocGYtPmZsYWdzICYgSTQwRV9GTEFHX01TSVhf
RU5BQkxFRCAmJiBwZi0+bXNpeF9lbnRyaWVzICYmDQoJICAgIHRlc3RfYml0KF9fSTQwRV9NSVND
X0lSUV9SRVFVRVNURUQsIHBmLT5zdGF0ZSkpIHsNCg0KVGhpcyBiaXQgaXMgc2V0IG9ubHkgaWYg
bWlzYyB2ZWN0b3Igd2FzIHByb3Blcmx5IGFsbG9jYXRlZC4gVGhlIHBhdGNoIHdpbGwgYmUgb24g
aW50ZWwtd2lyZWQgc29vbi4NCg0KPiA+IFJlZ2FyZHMNCj4gPiBTeWx3ZXN0ZXIgRHppZWR6aXVj
aA0KPiA+DQo+ID4gPiA+IC1QSg0KPiA+ID4gPg0KPiA+ID4gPiBfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXw0KPiA+ID4gPg0KPiA+ID4gPiBOb3RlOiBUaGlzIGVtYWlsIGlzIGZvciB0
aGUgY29uZmlkZW50aWFsIHVzZSBvZiB0aGUgbmFtZWQNCj4gPiA+ID4gYWRkcmVzc2VlKHMpIG9u
bHkgYW5kIG1heSBjb250YWluIHByb3ByaWV0YXJ5LCBjb25maWRlbnRpYWwsIG9yDQo+ID4gPiA+
IHByaXZpbGVnZWQgaW5mb3JtYXRpb24gYW5kL29yIHBlcnNvbmFsIGRhdGEuIElmIHlvdSBhcmUg
bm90IHRoZQ0KPiA+ID4gPiBpbnRlbmRlZCByZWNpcGllbnQsIHlvdSBhcmUgaGVyZWJ5IG5vdGlm
aWVkIHRoYXQgYW55IHJldmlldywNCj4gPiA+ID4gZGlzc2VtaW5hdGlvbiwgb3IgY29weWluZyBv
ZiB0aGlzIGVtYWlsIGlzIHN0cmljdGx5IHByb2hpYml0ZWQsDQo+ID4gPiA+IGFuZCByZXF1ZXN0
ZWQgdG8gbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkgYW5kIGRlc3Ryb3kgdGhpcw0KPiA+
ID4gPiBlbWFpbCBhbmQgYW55IGF0dGFjaG1lbnRzLiBFbWFpbCB0cmFuc21pc3Npb24gY2Fubm90
IGJlIGd1YXJhbnRlZWQNCj4gPiA+ID4gdG8gYmUgc2VjdXJlIG9yIGVycm9yLWZyZWUuIFRoZSBD
b21wYW55LCB0aGVyZWZvcmUsIGRvZXMgbm90IG1ha2UNCj4gPiA+ID4gYW55IGd1YXJhbnRlZXMg
YXMgdG8gdGhlIGNvbXBsZXRlbmVzcyBvciBhY2N1cmFjeSBvZiB0aGlzIGVtYWlsIG9yDQo+ID4g
PiA+IGFueQ0KPiA+IGF0dGFjaG1lbnRzLg0KPiA+ID4gPiBUaGlzIGVtYWlsIGlzIGZvciBpbmZv
cm1hdGlvbmFsIHB1cnBvc2VzIG9ubHkgYW5kIGRvZXMgbm90DQo+ID4gPiA+IGNvbnN0aXR1dGUg
YSByZWNvbW1lbmRhdGlvbiwgb2ZmZXIsIHJlcXVlc3QsIG9yIHNvbGljaXRhdGlvbiBvZg0KPiA+
ID4gPiBhbnkga2luZCB0byBidXksIHNlbGwsIHN1YnNjcmliZSwgcmVkZWVtLCBvciBwZXJmb3Jt
IGFueSB0eXBlIG9mDQo+ID4gPiA+IHRyYW5zYWN0aW9uIG9mIGEgZmluYW5jaWFsIHByb2R1Y3Qu
IFBlcnNvbmFsIGRhdGEsIGFzIGRlZmluZWQgYnkNCj4gPiA+ID4gYXBwbGljYWJsZSBkYXRhIHBy
b3RlY3Rpb24gYW5kIHByaXZhY3kgbGF3cywgY29udGFpbmVkIGluIHRoaXMNCj4gPiA+ID4gZW1h
aWwgbWF5IGJlIHByb2Nlc3NlZCBieSB0aGUgQ29tcGFueSwgYW5kIGFueSBvZiBpdHMgYWZmaWxp
YXRlZA0KPiA+ID4gPiBvciByZWxhdGVkIGNvbXBhbmllcywgZm9yIGxlZ2FsLCBjb21wbGlhbmNl
LCBhbmQvb3INCj4gPiA+ID4gYnVzaW5lc3MtcmVsYXRlZCBwdXJwb3Nlcy4gWW91IG1heSBoYXZl
IHJpZ2h0cyByZWdhcmRpbmcgeW91cg0KPiA+ID4gPiBwZXJzb25hbCBkYXRhOyBmb3IgaW5mb3Jt
YXRpb24gb24gZXhlcmNpc2luZyB0aGVzZSByaWdodHMgb3IgdGhlDQo+ID4gPiA+IENvbXBhbnni
gJlzIHRyZWF0bWVudCBvZiBwZXJzb25hbCBkYXRhLCBwbGVhc2UgZW1haWwNCj4gZGF0YXJlcXVl
c3RzQGp1bXB0cmFkaW5nLmNvbS4NCj4gDQo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fDQo+IA0KPiBOb3RlOiBUaGlzIGVtYWlsIGlzIGZvciB0aGUgY29uZmlkZW50aWFsIHVzZSBv
ZiB0aGUgbmFtZWQgYWRkcmVzc2VlKHMpIG9ubHkgYW5kDQo+IG1heSBjb250YWluIHByb3ByaWV0
YXJ5LCBjb25maWRlbnRpYWwsIG9yIHByaXZpbGVnZWQgaW5mb3JtYXRpb24gYW5kL29yDQo+IHBl
cnNvbmFsIGRhdGEuIElmIHlvdSBhcmUgbm90IHRoZSBpbnRlbmRlZCByZWNpcGllbnQsIHlvdSBh
cmUgaGVyZWJ5IG5vdGlmaWVkDQo+IHRoYXQgYW55IHJldmlldywgZGlzc2VtaW5hdGlvbiwgb3Ig
Y29weWluZyBvZiB0aGlzIGVtYWlsIGlzIHN0cmljdGx5IHByb2hpYml0ZWQsDQo+IGFuZCByZXF1
ZXN0ZWQgdG8gbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkgYW5kIGRlc3Ryb3kgdGhpcyBl
bWFpbCBhbmQNCj4gYW55IGF0dGFjaG1lbnRzLiBFbWFpbCB0cmFuc21pc3Npb24gY2Fubm90IGJl
IGd1YXJhbnRlZWQgdG8gYmUgc2VjdXJlIG9yDQo+IGVycm9yLWZyZWUuIFRoZSBDb21wYW55LCB0
aGVyZWZvcmUsIGRvZXMgbm90IG1ha2UgYW55IGd1YXJhbnRlZXMgYXMgdG8gdGhlDQo+IGNvbXBs
ZXRlbmVzcyBvciBhY2N1cmFjeSBvZiB0aGlzIGVtYWlsIG9yIGFueSBhdHRhY2htZW50cy4gVGhp
cyBlbWFpbCBpcyBmb3INCj4gaW5mb3JtYXRpb25hbCBwdXJwb3NlcyBvbmx5IGFuZCBkb2VzIG5v
dCBjb25zdGl0dXRlIGEgcmVjb21tZW5kYXRpb24sIG9mZmVyLA0KPiByZXF1ZXN0LCBvciBzb2xp
Y2l0YXRpb24gb2YgYW55IGtpbmQgdG8gYnV5LCBzZWxsLCBzdWJzY3JpYmUsIHJlZGVlbSwgb3Ig
cGVyZm9ybQ0KPiBhbnkgdHlwZSBvZiB0cmFuc2FjdGlvbiBvZiBhIGZpbmFuY2lhbCBwcm9kdWN0
LiBQZXJzb25hbCBkYXRhLCBhcyBkZWZpbmVkIGJ5DQo+IGFwcGxpY2FibGUgZGF0YSBwcm90ZWN0
aW9uIGFuZCBwcml2YWN5IGxhd3MsIGNvbnRhaW5lZCBpbiB0aGlzIGVtYWlsIG1heSBiZQ0KPiBw
cm9jZXNzZWQgYnkgdGhlIENvbXBhbnksIGFuZCBhbnkgb2YgaXRzIGFmZmlsaWF0ZWQgb3IgcmVs
YXRlZCBjb21wYW5pZXMsIGZvcg0KPiBsZWdhbCwgY29tcGxpYW5jZSwgYW5kL29yIGJ1c2luZXNz
LXJlbGF0ZWQgcHVycG9zZXMuIFlvdSBtYXkgaGF2ZSByaWdodHMNCj4gcmVnYXJkaW5nIHlvdXIg
cGVyc29uYWwgZGF0YTsgZm9yIGluZm9ybWF0aW9uIG9uIGV4ZXJjaXNpbmcgdGhlc2UgcmlnaHRz
IG9yIHRoZQ0KPiBDb21wYW554oCZcyB0cmVhdG1lbnQgb2YgcGVyc29uYWwgZGF0YSwgcGxlYXNl
IGVtYWlsDQo+IGRhdGFyZXF1ZXN0c0BqdW1wdHJhZGluZy5jb20uDQo=
