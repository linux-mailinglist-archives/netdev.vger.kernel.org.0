Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC4D416C7A
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 09:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244310AbhIXHFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 03:05:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:2623 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244300AbhIXHFr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 03:05:47 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10116"; a="223659920"
X-IronPort-AV: E=Sophos;i="5.85,319,1624345200"; 
   d="scan'208";a="223659920"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2021 00:04:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,319,1624345200"; 
   d="scan'208";a="559061803"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 24 Sep 2021 00:04:13 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 24 Sep 2021 00:04:13 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 24 Sep 2021 00:04:13 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 24 Sep 2021 00:04:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fv8YSuPiznIbtfkw2oswbpdOidzZfLSGdkGTv1SkXl8TPMNI/gnphmxESQfGtyUE4vbdIW5bezLARKTqPN6a2+5rFbA4F6zbaVtNDOVIG8MgMqpyr49fg7FYizgaouvFil0F7BcCLvhNOXph/0KatTToi77XJX/g8iCd1HN/SrpKI8kqW7zstlLDy+8ei6s6DF2x9GS/bSmOAwi+4L4CI1A496eAsud0pYy2DAXBCVIAi6fpCk/Pjp7ZaQsCjvNndGcJR1QZcnTUxv6ybh1omMaNKJus82DZC8sjVTKvCFrrY1dExw7VCFyrvGn0dhuzCksHLYoRj3IPZG0yClmrJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=RUcO9/dEsMal8TQ59HWzNg4A5LwX9zChkG34j+H8H1U=;
 b=WB3ioV5qb1X+qMkOIg2MG9X7/+fP7Ab8vwM9k4oqYPuXXrWtdelwjSm1/ro28Fb6PkEYumzzCfxjeUiH/mWvmvjqaQ3EW9C3tbBwTGxpwcRyVyqV9Wkd+bRUtx3Dg0q2XBq09uXb+GndWzzFYib6b43/PJSKPSvaaAblfSArreFM3R7297MXSM9xpcDM+yS2loy+VUrUCShCOt52RdUeXQM191mL4lsty3C8XTxH5TblajheKd0eATU658qQdnUD+6Jl79VYIIbiM2PGFyK8IRf3VeLBwWsJcYJJ3wDQjqaUzJA/lUxcSVpuX6NfxAIi0SgOWiq3K7tvj21+WyDpFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RUcO9/dEsMal8TQ59HWzNg4A5LwX9zChkG34j+H8H1U=;
 b=W14r5qpFC2VUHcyTGXWgz6A/zioqn1Lm2LEULi1Zwlwy2Cg+eQYotO1FyDYrJ/IMmb28bTrVci1ZcvS0wagmzKTeldy0MsYJcKDv/cBrkp44vy8BplFaARp9Y8CyioTawzbLipILNvbc4V5FbJDl9MF0SgH+sAJwXnNn7k03bpg=
Received: from DM6PR11MB3371.namprd11.prod.outlook.com (2603:10b6:5:e::22) by
 DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.13; Fri, 24 Sep 2021 07:04:11 +0000
Received: from DM6PR11MB3371.namprd11.prod.outlook.com
 ([fe80::ade9:932c:827d:895]) by DM6PR11MB3371.namprd11.prod.outlook.com
 ([fe80::ade9:932c:827d:895%5]) with mapi id 15.20.4544.018; Fri, 24 Sep 2021
 07:04:11 +0000
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
Thread-Index: AQHXmsiBRJTk/bztnkiJewAWaKSBqquMjXAAgAGS54CAFFexAIAAD6UAgADBxBCAAONggIAAyeVAgAQ1+oCAA4C90IACMyIAgAMGGwCAAQgvgA==
Date:   Fri, 24 Sep 2021 07:04:11 +0000
Message-ID: <DM6PR11MB33714CF524A9F210152A9221E6A49@DM6PR11MB3371.namprd11.prod.outlook.com>
References: <20210826221916.127243-1-pwaskiewicz@jumptrading.com>
         <50c21a769633c8efa07f49fc8b20fdfb544cf3c5.camel@intel.com>
         <20210831205831.GA115243@chidv-pwl1.w2k.jumptrading.com>
         <MW4PR14MB4796AE05A868B47FE4F6E12AA1D99@MW4PR14MB4796.namprd14.prod.outlook.com>
 <bebb58f34ed68025e95f8bc060af58a24333374b.camel@intel.com>
 <DM6PR11MB3371A3D1F314F3B8541FAF03E6DA9@DM6PR11MB3371.namprd11.prod.outlook.com>
 <MW4PR14MB47960CC778789EEE8E8A54EDA1DA9@MW4PR14MB4796.namprd14.prod.outlook.com>
 <DM6PR11MB3371B4431AD7C46672C7E439E6DB9@DM6PR11MB3371.namprd11.prod.outlook.com>
 <MW4PR14MB4796F279908B7E4D11622C66A1DE9@MW4PR14MB4796.namprd14.prod.outlook.com>
 <DM6PR11MB3371A285032A583A73BA62E0E6A09@DM6PR11MB3371.namprd11.prod.outlook.com>
 <MW4PR14MB47967810D43031FF8C4C2265A1A19@MW4PR14MB4796.namprd14.prod.outlook.com>
 <MW4PR14MB479687DDEC1EB0C4AA5F5CF1A1A39@MW4PR14MB4796.namprd14.prod.outlook.com>
In-Reply-To: <MW4PR14MB479687DDEC1EB0C4AA5F5CF1A1A39@MW4PR14MB4796.namprd14.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: cd199f81-756b-47fa-5ae0-08d97f2982dc
x-ms-traffictypediagnostic: DM6PR11MB4657:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4657ECF6F71B29C37994A04BE6A49@DM6PR11MB4657.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NjVkMDIswaW/PpNfUw/OtiFPCa9dmm6N1KzJM1SaH1BpqEq7zfnoO87TxKRATi7FgcPHh+XyEZHKPC/5sRcXwgQska/OOy7+9eGMZ59EHGkVbfuKxmjyP6Z9VVf7tvPLb3iiT9jo/JZ6xwTeQ/7tA40O2TyKF27WLDeS83luit1Dud01upErcSYg7T5rrlLpEPQ59TEKDJ/gsE7LoCwgi7djjap9DDyT5V4b85oDJSA/Dm4qYaoRV1zLth5RD86w20HkBi5S3sLnLCH08Mllm0+54bFsHC4K6npx6PsQizovr/KaEjxuGgbxmOVfGh81NnMJ5qdidUQr9ZycHyrrlHQ1Qe1iVkthRzx7wMAxnS0d/GkwPxyq2DJDn/3Ag+5OjcubvBO09o09vkV+U9zSxhYUJu2hl/VWmGiStwyzPTKVPswiTIK1orWy1EiezjDKSnSL6g9viHrJZZjQF9cX4ZcijnJZZ9GKeko/YJO8ZL5UJI3Emaf2RSju7ej0SYI94reUtXRT2bivHctlrCcxUj5HOnxI1KdIge7gzcC0dmd7cXSJWh6WfmhG7sSawY2/x0B5+t/aS02s5lh7T63LmvO2iZxe8y1ghRwuXgc4y6IzMolg6I/Eee9BjtvzdiLLSpKcpTAtd3jZtTh0VBZ7J4cexyPL4bjX2gajSDWEbShch7t1OcEURL2Kua10y6Ufaooc7ZiIglROc0UDE4g8bQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3371.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(9686003)(107886003)(66946007)(66446008)(122000001)(7696005)(55016002)(110136005)(71200400001)(8676002)(6506007)(38070700005)(86362001)(8936002)(53546011)(66556008)(64756008)(66476007)(52536014)(4326008)(508600001)(186003)(33656002)(26005)(76116006)(5660300002)(6636002)(316002)(83380400001)(54906003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ek9FSVN2T2lFWGVlcDlncGJySko2T2tvZy9SOWZ2YUxtbHQ5eGM5NE5SRmc1?=
 =?utf-8?B?Y21tVXdTVFRTaGo4aFpQcnZwNTVSTldmMm1UTFozbWVXdGxGNFUwdTlveHBw?=
 =?utf-8?B?OEZtZ21VV084TmdNbDlLWWxzTVlTVm1ZaDl5bnBtRnpEQys4ZGhlbldWRGVI?=
 =?utf-8?B?cmZobmQyVi9ZTnhpbXhJdysyWXYzeEVkaG1yTk9mR29LbVpLdGFjQy9uSXlF?=
 =?utf-8?B?MDhWZTg5V2RLMjBycTFrNVFmZ3B3dWcrbTN6RjhsWU11bW9nOHk5REhuRWxx?=
 =?utf-8?B?ZnJGTHluUDVzZStHcm1tTzJCM3l6b282V2JOcVFua2xlakdTMXdYYkpRZkVT?=
 =?utf-8?B?cVhJTzBsZkdlZFVzekx5NmZxSXEyQVcvdS81Q3E1NmZEVHVLY0tEUENzV3pq?=
 =?utf-8?B?TWRKK0dyTzVEKysrR0JxZDk0MFJhL0czQXNRU0xWTERCUko1ZmJiVHptWHVh?=
 =?utf-8?B?YTM0UURUY204elhMaXVWa0JxZlA5UlhNK0N2U0RSeFlRUHJOZHJFcU90VmRy?=
 =?utf-8?B?WUt1L1drb0JUcFE1OHE1aEk3L0M4S2o2Mk5wUlJWWXhwdjZ3bXZZbWtHSjVP?=
 =?utf-8?B?M09wNjJKVjFFclplZ1JWMUxEc2ZSNEFTaWFYaGxKOEQ1bjN5NHNDMW1GODI2?=
 =?utf-8?B?VFJrNTVYNldwYXpVL240VXI5cTVkckRuazIwbm1OSHhZVVZoZ3ZLV2RJZ2hL?=
 =?utf-8?B?ajU2dGNZNE94d2x4bVgyYjRDRU96RnNGck9MbjdXZ0wzSXhUSGhOMDI4REFH?=
 =?utf-8?B?ODc0bjFwNUM1Qjh0UHo4QW5WZEdTTEJTR1Y4RGk5bVQxWGt6MHNkaHZIZXFr?=
 =?utf-8?B?Q2w5c01IS2RzRWdyR3Y3TjRWWDUzVmRRc2IyS0N5NmxHSytNRDN2b2ZobHNW?=
 =?utf-8?B?SWI1QmFuSGJRZmVQSUxzMFhhSlYrY2lUMlp5VlpISzB1cmFTQzlCeVhTVlB3?=
 =?utf-8?B?eVl1N2RxMW1TVS9OV1Irbk8zdFl1RUdMTGlKZ0tlTFVlcVBRMkUxZ2owWGRS?=
 =?utf-8?B?bnRFZG92Y3NxVHduallOT1k1bFlJVG1NVVpmcHhRQWNFZEpCRm53dmplL3VW?=
 =?utf-8?B?SVNEMEpCYjJhS3pIWWpOVmtsSDB6K0tjVkFHcHpWdjV5SVpTY1MrcmhDVXpS?=
 =?utf-8?B?dVcrVUhvNFZIYWRKeEE1bjRIQ09oSHQydVdUdU85ZXpyZVN6SVJscTV5NWV4?=
 =?utf-8?B?N0hFWllMeXFpWEFpZVBnRUVuS0xXMVZlSSswL2R6Vis4dnM3V3did24xYUZz?=
 =?utf-8?B?WjdzR0MyODZIZWNZSkVJZ1VOTmZwajlHYmgvR3dXekRIYUZ0NHdVV0JnOGtH?=
 =?utf-8?B?SzJ5QWYxWWZvck5rTGNMRzA5V1FLTzFyNFQ1ZkM4U0duWXdpVmRPOWlXK2tw?=
 =?utf-8?B?UlRxeDRRNzlWM2dWRjBBVHlESEI3MUxKb1lsTVFKR1RZQ3crZUNyUGlzRm5K?=
 =?utf-8?B?OEE0Y2N5R1ZXdUkzYmpjYitEcjNwV05tWFQ4TDVPN2UvNzY4Sm5WWVpYUkc0?=
 =?utf-8?B?SmxjOEEwOWdmcDdpV2tFYXFqT2svMmVrTE5MZENxLzdvaEpEalAzVEJuampX?=
 =?utf-8?B?d2EwZGMrTHdwYlJaOFRuZVVQWHZ1UzZkbDV0NGFMTWpLbGdpbmI4UERLZkZh?=
 =?utf-8?B?UXBNa2Nxck5waVRaVHRLeTVMai9HT2UvZ2NGeG9mdDlWTHhRa1hZZ2p1Ni9q?=
 =?utf-8?B?WkRpODdUTTRLWENNRXREaTArbHhOK3grYjg4akM2QzQ3MndpK0hqanZCaGdY?=
 =?utf-8?Q?RkgTjol9x+HfATeyp0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3371.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd199f81-756b-47fa-5ae0-08d97f2982dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2021 07:04:11.4152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I5rLndAQhf+NbTZo3DIi6kKRhKwZs/ckr+dzEzvS9115GyIOwQI9JJYqcrs6hAwgMe0+1YQMEJgdYQJRD9PRAs/Bjd0mytWcUfl0a8cOjf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4657
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gUEosDQoNClNvcnJ5IGZvciB0aGUgbGF0ZSByZXNwb25zZS4gSSBhbSBhcHBseWluZyB5
b3VyIHN1Z2dlc3Rpb25zIHRvIHRoZSBwYXRjaC4gVGhlIHVwZGF0ZWQgdmVyc2lvbiB3aWxsIGJl
IG9uIElXTCBpbiBhIG1vbWVudC4NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBG
cm9tOiBQSiBXYXNraWV3aWN6IDxwd2Fza2lld2ljekBqdW1wdHJhZGluZy5jb20+DQo+IFNlbnQ6
IFRodXJzZGF5LCBTZXB0ZW1iZXIgMjMsIDIwMjEgNToxNyBQTQ0KPiBUbzogRHppZWR6aXVjaCwg
U3lsd2VzdGVyWCA8c3lsd2VzdGVyeC5kemllZHppdWNoQGludGVsLmNvbT47IE5ndXllbiwNCj4g
QW50aG9ueSBMIDxhbnRob255Lmwubmd1eWVuQGludGVsLmNvbT4NCj4gQ2M6IGRhdmVtQGRhdmVt
bG9mdC5uZXQ7IHBqd2Fza2lld2ljekBnbWFpbC5jb207IEZpamFsa293c2tpLCBNYWNpZWoNCj4g
PG1hY2llai5maWphbGtvd3NraUBpbnRlbC5jb20+OyBMb2t0aW9ub3YsIEFsZWtzYW5kcg0KPiA8
YWxla3NhbmRyLmxva3Rpb25vdkBpbnRlbC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBC
cmFuZGVidXJnLCBKZXNzZQ0KPiA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+OyBpbnRlbC13
aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZzsNCj4gTWFjaG5pa293c2tpLCBNYWNpZWogPG1hY2ll
ai5tYWNobmlrb3dza2lAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSRTogW1BBVENIIDEvMV0gaTQw
ZTogQXZvaWQgZG91YmxlIElSUSBmcmVlIG9uIGVycm9yIHBhdGggaW4gcHJvYmUoKQ0KPiANCj4g
PiA+IEhlbGxvIFBKLA0KPiA+DQo+ID4gSGVsbG8sDQo+IA0KPiBIaSBUb255IGFuZCBTeWx3ZXN0
ZXIsDQo+IA0KPiBBbnkgdXBkYXRlcy9jb21tZW50cyBvbiBteSByZXBseSBmcm9tIGEgZmV3IGRh
eXMgYWdvIG9uIHRoaXM/DQo+IA0KPiAtUEoNCj4gDQo+ID4gPg0KPiA+ID4gPiBzdGF0aWMgdm9p
ZCBpNDBlX2ZyZWVfbWlzY192ZWN0b3Ioc3RydWN0IGk0MGVfcGYgKnBmKSB7DQo+ID4gPiA+ICAg
ICAgICAgLyogRGlzYWJsZSBJQ1IgMCAqLw0KPiA+ID4gPiAgICAgICAgIHdyMzIoJnBmLT5odywg
STQwRV9QRklOVF9JQ1IwX0VOQSwgMCk7DQo+ID4gPiA+ICAgICAgICAgaTQwZV9mbHVzaCgmcGYt
Pmh3KTsNCj4gPiA+ID4NCj4gPiA+ID4gV291bGQgeW91IHN0aWxsIHdhbnQgdG8gZG8gdGhhdCBi
bGluZGx5IGlmIHRoZSB2ZWN0b3Igd2Fzbid0DQo+ID4gPiA+IGFsbG9jYXRlZCBpbiB0aGUgZmly
c3QgcGxhY2U/ICBTZWVtcyBleGNlc3NpdmUsIGJ1dCBpdCdkIGJlDQo+ID4gPiA+IGhhcm1sZXNz
LiAgU2VlbXMgbGlrZSBub3QgY2FsbGluZyB0aGlzIGZ1bmN0aW9uIGFsdG9nZXRoZXIgd291bGQN
Cj4gPiA+ID4gYmUgY2xlYW5lciBhbmQgZ2VuZXJhdGUgbGVzcyBNTUlPIGFjdGl2aXR5IGlmIHRo
ZSBNSVNDIHZlY3Rvcg0KPiA+ID4gPiB3YXNuJ3QgYWxsb2NhdGVkIGF0IGFsbCBhbmQNCj4gPiA+
IHdlJ3JlIGZhbGxpbmcgb3V0IG9mIGFuIGVycm9yIHBhdGguLi4NCj4gPiA+ID4NCj4gPiA+ID4g
SSBhbSByZWFsbHkgYXQgYSBsb3NzIGhlcmUuICBUaGlzIGlzIGNsZWFybHkgYnJva2VuLiAgV2Ug
aGF2ZSBhbiBPb3BzLg0KPiA+ID4gPiBXZSBnZXQgdGhlc2Ugb2NjYXNpb25hbGx5IG9uIGJvb3Qs
IGFuZCBpdCdzIHJlYWxseSBhbm5veWluZyB0bw0KPiA+ID4gPiBkZWFsIHdpdGggb24gcHJvZHVj
dGlvbiBtYWNoaW5lcy4gIFdoYXQgaXMgdGhlIGRlZmluaXRpb24gb2YNCj4gPiA+ID4gInNvb24i
IGhlcmUgZm9yIHRoaXMgbmV3IHBhdGNoIHRvIHNob3cgdXA/ICBNeSBkaXN0cm8gdmVuZG9yIHdv
dWxkDQo+ID4gPiA+IGxvdmUgdG8gcHVsbCBzb21lIHNvcnQgb2YgZml4IGluIHNvIHdlIGNhbiBn
ZXQgaXQgaW50byBvdXIgYnVpbGQNCj4gPiA+ID4gaW1hZ2VzLCBhbmQgc3RvcCBoYXZpbmcgdGhp
cyBwcm9ibGVtLiAgTXkgcGF0Y2ggZml4ZXMgdGhlDQo+ID4gPiA+IGltbWVkaWF0ZSBwcm9ibGVt
LiAgSWYgeW91IGRvbid0IGxpa2UgdGhlIHBhdGNoICh3aGljaCBpdCBhcHBlYXJzDQo+ID4gPiA+
IHlvdSBkb24ndDsgdGhhdCdzIGZpbmUpLCB0aGVuIHN0YWxsaW5nIG9yIHNheWluZyBhIGRpZmZl
cmVudCBmaXgNCj4gPiA+ID4gaXMgY29taW5nICJzb29uIiBpcyByZWFsbHkgbm90IGEgZ3JlYXQg
c3VwcG9ydCBtb2RlbC4gIFRoaXMgd291bGQNCj4gPiA+ID4gYmUgZ3JlYXQgdG8gbWVyZ2UsIGFu
ZCB0aGVuIGlmIHlvdSB3YW50IHRvIG1ha2UgaXQgImJldHRlciIgb24NCj4gPiA+ID4geW91ciBz
Y2hlZHVsZSwgaXQncyBvcGVuIHNvdXJjZSwgYW5kIHlvdSBjYW4gc3VibWl0IGEgcGF0Y2guICBP
cg0KPiA+ID4gPiBJJ2xsIGJlIGhhcHB5IHRvIHJlc3BpbiB0aGUgcGF0Y2gsIGJ1dCBzdGlsbCBj
YWxsaW5nDQo+ID4gPiA+IGZyZWVfbWlzY192ZWN0b3IoKSBpbiBhbiBlcnJvciBwYXRoIHdoZW4g
dGhlIE1JU0MgdmVjdG9yIHdhcw0KPiA+ID4gbmV2ZXIgYWxsb2NhdGVkIHNlZW1zIGxpa2UgYSBi
YWQgZGVzaWduIGRlY2lzaW9uIHRvIG1lLg0KPiA+ID4gPg0KPiA+ID4gPiAtUEoNCj4gPiA+DQo+
ID4gPiBJIHRvdGFsbHkgYWdyZWUgdGhhdCB3ZSBzaG91bGRu4oCZdCBjYWxsIGZyZWVfbWlzY192
ZWN0b3IgaWYgbWlzYw0KPiA+ID4gdmVjdG9yIHdhc24ndCBhbGxvY2F0ZWQgeWV0IGJ1dCB0byBt
ZSB0aGlzIGlzIG5vdCB3aGF0IHlvdXIgcGF0Y2ggaXMgZG9pbmcuDQo+ID4gPiBmcmVlX21pc2Nf
dmVjdG9yKCkgaXMgY2FsbGVkIGluIGNsZWFyX2ludGVycnVwdF9zY2hlbWUgbm90DQo+ID4gPiBy
ZXNldF9pbnRlcnJ1cHRfY2FwYWJpbGl0eSgpLiBJbiB5b3VyIHBhdGNoIGNsZWFyX2ludGVycnVw
dF9zY2hlbWUoKQ0KPiA+ID4gd2lsbCBzdGlsbCBiZSBjYWxsZWQgd2hlbiBwZiBzd2l0Y2ggc2V0
dXAgZmFpbHMgaW4gaTQwZV9wcm9iZSgpIGFuZA0KPiA+ID4gaXQgd2lsbCBzdGlsbCBjYWxsIGZy
ZWVfbWlzY192ZWN0b3Igb24gdW5hbGxvY2F0ZWQgbWlzYyBJUlEuIE90aGVyDQo+ID4gPiBwcm9w
ZXIgd2F5IHRvIGZpeCB0aGlzIHdvdWxkIGJlIG1vdmluZyBmcmVlX21pc2NfdmVjdG9yKCkgb3V0
IG9mDQo+ID4gPiBjbGVhcl9pbnRlcnJ1cHRfc2NoZW1lKCkgYW5kIGNhbGxpbmcgaXQgc2VwYXJh
dGVseSB3aGVuIG1pc2MgdmVjdG9yDQo+ID4gPiB3YXMgcmVhbGx5IGFsbG9jYXRlZC4gQXMgZm9y
IHRoZSBodyByZWdpc3RlciBiZWluZyB3cml0dGVuIGluIG91cg0KPiA+ID4gcGF0Y2ggYXMgeW91
IHNhaWQgaXQncyBoYXJtbGVzcy4gVGhlIHBhdGNoIHdlJ3ZlIHByZXBhcmVkIHNob3VsZCBiZQ0K
PiA+ID4gb24gaXdsDQo+ID4gdG9kYXkuDQo+ID4gPg0KPiA+DQo+ID4gT2ssIEkgc2VlIHRoZSBw
YXRjaCBvbiBJV0wuLi4ubGV0J3MgZGlzY3Vzcy4uLi4NCj4gPg0KPiA+IEp1c3QgYWJvdmUsIEkg
cG9pbnRlZCBvdXQgdGhhdCBpZiB0aGUgTUlTQyB2ZWN0b3IgaGFzbid0IGJlZW4NCj4gPiBhbGxv
Y2F0ZWQgYXQgYWxsLCB0aGVuIHdlIGRvbid0IHdhbnQgdG8gY2FsbCBmcmVlX21pc2NfdmVjdG9y
KCkgYXQNCj4gPiBhbGwuICBUaGF0IHdvdWxkIGFsc28gbWVhbiB0aGUgc3VnZ2VzdGlvbiB0byBj
aGVjayB0aGUgYXRvbWljIHN0YXRlDQo+ID4gYml0IHRvIGF2b2lkIHRoZSBhY3R1YWwgZnJlZSB3
b3VsZA0KPiA+ICpzdGlsbCogaGF2ZSB0aGUgY29kZSBjYWxsIGZyZWVfbWlzY192ZWN0b3IoKSwg
YW5kIG9ubHkgc2tpcCB0aGUNCj4gPiBhY3R1YWwgZnJlZSAoYWZ0ZXIgZG9pbmcgYW4gdW5uZWNl
c3NhcnkgTU1JTyB3cml0ZSBhbmQgdGhlbiByZWFkIHRvDQo+ID4gZmx1c2gpLiAgSSBwb2ludGVk
IG91dCB0aGF0IHdvdWxkbid0IGJlIGlkZWFsLCBhbmQgeW91LCBqdXN0IGFib3ZlLA0KPiA+IGFn
cmVlZC4gIFlldCwgdGhlIGZpeCB5b3UgZ3V5cyBzdWJtaXR0ZWQgdG8gSVdMIGRvZXMgZXhhY3Rs
eSB0aGF0LiAgU28NCj4gPiBhcmUgd2UganVzdCBzYXlpbmcgdGhpbmdzIHRvIGJ1cnkgdGhpcyB0
aHJlYWQgYW5kIGhvcGUgaXQgZ29lcyBhd2F5LCBvciBqdXN0DQo+IHdpbGxmdWxseSBub3QgZG9p
bmcgd2hhdCB3ZSBhZ3JlZWQgb24/DQo+ID4gSXQncyBwcmV0dHkgZGlzaGVhcnRlbmluZyB0byBj
b25zaWRlciBmZWVkYmFjaywgYWdyZWUgdG8gaXQsIHRoZW4NCj4gPiBjb21wbGV0ZWx5IGlnbm9y
ZSBpdC4gIFRoYXQncyBub3QgaG93IG9wZW4gc291cmNlIHdvcmtzLi4uDQo+ID4NCj4gPiBBbHNv
LCByZWdhcmRsZXNzIGhvdyB5b3UgZ3V5cyB3YW50IHRoZSBjb2RlIHRvIHdvcmssIGl0J3MgdXN1
YWxseSBnb29kDQo+ID4gZm9ybSB0byBpbmNsdWRlIGEgIlJlcG9ydGVkLWJ5OiIgaW4gYSBwYXRj
aCBpZiB5b3UncmUgZGVjaWRpbmcgbm90IHRvDQo+ID4gdGFrZSBhIHByb3Bvc2VkIHBhdGNoLiAg
SXQncyBldmVuIGJldHRlciBmb3JtIHRvIGluY2x1ZGUgdGhlIE9vcHMgdGhhdA0KPiA+IHdhcyBy
ZXBvcnRlZCBpbiB0aGUgZmlyc3QgcGF0Y2gsIHNpbmNlIHRoYXQgbWFrZXMgdGhpbmdzIGxpa2UN
Cj4gPiAke1NFQVJDSF9FTkdJTkV9IHdvcmsgZm9yIHBlb3BsZSBydW5uaW5nIGludG8gdGhlIHNh
bWUgaXNzdWUgaGF2ZSBhDQo+ID4gY2hhbmNlIHRvIGZpbmQgYSBzb2x1dGlvbi4gIE5vdCBkb2lu
ZyBlaXRoZXIgb2YgdGhlc2Ugd2hlbiBzb21lb25lDQo+ID4gZWxzZSBoYXMgZG9uZSB3b3JrIHRv
IGlkZW50aWZ5IGFuIGlzc3VlLCB0ZXN0IGEgZml4LCBhbmQgcHJvcG9zZSBpdCwNCj4gPiBpcyBu
b3QgYSBnb29kIHdheSB0byBhdHRyYWN0IG1vcmUgcGVvcGxlIHRvIHdvcmsgb24gdGhpcyBkcml2
ZXIgaW4gdGhlIGZ1dHVyZS4NCj4gPg0KPiA+IElmIHdlIHdhbnRlZCB0byBkbyBzb21ldGhpbmcg
d2hlcmUgZnJlZV9taXNjX3ZlY3RvcigpIGlzbid0IGNhbGxlZCBpZg0KPiA+IHRoZSBzdGF0ZSBm
bGFnIGlzbid0IHNldCwgdGhlbiB3aHkgbm90IHNvbWV0aGluZyBsaWtlIHRoaXMsIHdoaWNoDQo+
ID4gd291bGQga2VlcCBpbiB0aGUgc3Bpcml0IG9mIHdoYXQgd2UgYWdyZWVkIG9uIGFib3ZlOg0K
PiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQw
ZV9tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV9tYWlu
LmMNCj4gPiBpbmRleCAxZDFmNTI3NTZhOTMuLmE0MDE5M2JjYzdiNyAxMDA2NDQNCj4gPiAtLS0g
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfbWFpbi5jDQo+ID4gKysrIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX21haW4uYw0KPiA+IEBAIC00ODY4
LDcgKzQ4NjgsOSBAQCBzdGF0aWMgdm9pZCBpNDBlX2NsZWFyX2ludGVycnVwdF9zY2hlbWUoc3Ry
dWN0DQo+ID4gaTQwZV9wZiAqcGYpICB7DQo+ID4gICAgICAgICBpbnQgaTsNCj4gPg0KPiA+IC0g
ICAgICAgaTQwZV9mcmVlX21pc2NfdmVjdG9yKHBmKTsNCj4gPiArICAgICAgIC8qIE9ubHkgYXR0
ZW1wdCB0byBmcmVlIHRoZSBtaXNjIHZlY3RvciBpZiBpdCdzIGFscmVhZHkgYWxsb2NhdGVkICov
DQo+ID4gKyAgICAgICBpZiAodGVzdF9iaXQoX19JNDBFX01JU0NfSVJRX1JFUVVFU1RFRCwgcGYt
PnN0YXRlKSkNCj4gPiArICAgICAgICAgICAgICAgaTQwZV9mcmVlX21pc2NfdmVjdG9yKHBmKTsN
Cj4gPg0KPiA+ICAgICAgICAgaTQwZV9wdXRfbHVtcChwZi0+aXJxX3BpbGUsIHBmLT5pd2FycF9i
YXNlX3ZlY3RvciwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgSTQwRV9JV0FSUF9JUlFfUElM
RV9JRCk7DQo+ID4NCj4gPiAtUEoNCj4gDQo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
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
