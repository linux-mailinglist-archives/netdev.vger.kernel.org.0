Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C316461FBC
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 19:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379390AbhK2TBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 14:01:41 -0500
Received: from mga18.intel.com ([134.134.136.126]:29739 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231258AbhK2S7k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 13:59:40 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="222933810"
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="222933810"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 10:46:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="540099351"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga001.jf.intel.com with ESMTP; 29 Nov 2021 10:46:05 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 10:46:05 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 10:46:04 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 29 Nov 2021 10:46:04 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 29 Nov 2021 10:44:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FOBwr715bUMqFHUNjqunBKfkRS1FP1yGAzsApixwlUnCStSM1Tn2UTqLBjQUR8kHPue5rZKTbrbF+DSR5QI9oMQoPx7k8rKmfNdy/GRXZtb3cYtKFrTNrgbBppwyxFatqdZXRi0O/nCLah+vnbl9wbIRQGmA0IZHWEVNX2WO6pszSONlkMdrCdRsFFXcwEtkuNo/s0kA+8FeCb0CCJZqxwBjfW5JJB2Aq8QPg0sUYsBjDK+MHdpfLmNFQYy360pHpfrrQIytJImXIatHqfq90spP30F91eA4L55aaUSYLgYlhRkogaEsEPVrMlk+v4DTtI0Zga6UOqvAcTq6weJBPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vl6WoxZjxY6GcUGnD/1DncWkd1aFZxBytzJOxH6LsTk=;
 b=k9pg+5Spacr7NlvnLn85ZonNPg7UhAALVoI+pRjXBW9k8HaiC6pUUVYoTxb9og2XGzyuumbcRyqVrzx5qG/p9uLnJ+ju8VxCeWCCvqchmOXjAp6zeefZmMUczZC8pLCi0e+vJGp5ZiDc4t4EhWPyU7lQD4LoWLQX87iz87kTxpvfV7Q+d5k1pROFGtG5RW8kWkIWR60uk682jchKWVMw5LQFrIYNeoeg28e7MDw/UtaUmbn0WRiiCVwqCXlkUv4cfrBHwi47UgQCwFqYSGEi5azRRtQND1VRlYssgCmwkr2MeWm+KCWWXAY5vCxwCxQc8VEEjc46bWMFZpYkQsyGMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vl6WoxZjxY6GcUGnD/1DncWkd1aFZxBytzJOxH6LsTk=;
 b=VdsVA66kKYgNQyE4Ppbb2SuNBnQ1x8vAak4qiRRS+mAMUOmVqHWJAl4kHXohdbKiJu/cx4yfKvzUcCzAtfJPcO6ZBisVg9+UZvoT9Cfe5S63JXE7vAZSax9rRdzO18XJKE+Q5VeHhV+NNNlsu/ihxpPP6S0faHI3anb+EzIpUd4=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB4859.namprd11.prod.outlook.com (2603:10b6:806:f8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 18:44:46 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a5ee:3fab:456b:86d8]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a5ee:3fab:456b:86d8%7]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 18:44:46 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "sassmann@redhat.com" <sassmann@redhat.com>
CC:     "Williams, Mitch A" <mitch.a.williams@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 05/12] iavf: don't be so alarming
Thread-Topic: [PATCH net-next 05/12] iavf: don't be so alarming
Thread-Index: AQHX4VdJALO9YY56f0qq6TnWZuvWwawTzVKAgAcSC4A=
Date:   Mon, 29 Nov 2021 18:44:46 +0000
Message-ID: <68b91ed0b3cb2c22ccec97d168890d56d91c1db0.camel@intel.com>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
         <20211124171652.831184-6-anthony.l.nguyen@intel.com>
         <20211125064515.wjoe4evnqdfy62c7@x230>
In-Reply-To: <20211125064515.wjoe4evnqdfy62c7@x230>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4ff3700-51d5-4d7d-e236-08d9b368511d
x-ms-traffictypediagnostic: SA2PR11MB4859:
x-microsoft-antispam-prvs: <SA2PR11MB4859D94BBC232449B5FCF89EC6669@SA2PR11MB4859.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jGhK34sWGN9eW7lOg8qcJwNOGXn+RKJ9Ha5c7H3P3lH75meusOwhTK4NF+5i/FVfoahuon+bIB/FUFhI663KlSjJ8NBMlWbzfxxciBjoWMtWSHYITRb1iaNdOmd+CIGplOs/BlXDGJB/oG+THH5J+LSyToYsVWpFRFA3uym/ET1pQNsmSxa8scSW8S6A4JvI4+zcjsje8DBdkZ++D2k4zd9nbLtCZVya924leEHPsywoQ/Git4LuvX7+Lf5B8e4TTSr3/yTJwmUqTdJshnUJYd7ypoUSZnJfrPu5VF4pyd3FRNfmjAWQjsfqnIWM2uOLj3BcwKrtG/lEkXoMO4buwrwdeiJiuVYn5gcjsp95ZChY7JVadTIvHtg+kxOYphKyDvJJtCMpTMsanoRudAZ8kzzAVIh9K8N/lkncN6Z6ys+WMilXByA5Qs4uRP429ETECCXXFtS68ZB2MR3xaIDI86Icz6uq4U+pTRlflD76FRSc0twxG2/+CxjWtKiBDzC4M3E1EpCSzw8/IJUWQ1MwSEAFvOJ/TXfuE+FBP+MMag5ZDVAUptJNrgsTBBfkJHgq0YJrd+b2T6OcCC4/V79Kwg+B3eKY+2pj6kqDZn4tyLlMfG4CjaSxevHMTRdZ+Ox1309glvRgWFVKPi4q9sBXowQA4OQB50IHBEO0OM2SgOzDChzfQih7dg2cnB1nPE2inztGk+48OR46eSVMbbqlBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(5660300002)(82960400001)(66476007)(64756008)(83380400001)(26005)(66946007)(66446008)(2616005)(66556008)(53546011)(91956017)(76116006)(6512007)(6916009)(8676002)(54906003)(36756003)(6486002)(4326008)(8936002)(38070700005)(71200400001)(122000001)(508600001)(86362001)(186003)(6506007)(4001150100001)(38100700002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEtGczlJMU5sMWV2K3YycFNUajFOYVk0WTJwbFB3aC95NTVRV1ljd1V4akVN?=
 =?utf-8?B?cnQyTW5IbCt0Mk1sNFI0NTF0RXZPbTdqa2w5MlJtVGRNeGR1dENMK2RYZ1hH?=
 =?utf-8?B?eXgva1hac2x5a1pxSVhLUVJJWEtLR0Y5SFZyZWppUVNacnRlYmtwM0gxT0pZ?=
 =?utf-8?B?UDZGNG9qU2hzcUhUZm13U3NMdUxJeXlQUThDRjZpK1dnUU4xS2YxKzd1OTh0?=
 =?utf-8?B?STBxM2VjR2NiVlV0N0xSWmw0UHRHUExVKzZ3R2tpK01LNUUvSFQ4bjZaOVpT?=
 =?utf-8?B?RUdWMUtaOE9EN3RNb21vaXZoUWxLMElpM0tDMnpVckZHR2hJR2JuM1VGSUxQ?=
 =?utf-8?B?elByajExRlp2UmViOXg3UXN0QjhjVVg1eE1Qc2hiT25JZWl1WVNOVUpRcjkx?=
 =?utf-8?B?THV4VW9COEhUSUM1aVpmOCszcXZhMGR0dWFuTlRaazJudDRScUdEQm5ycEU5?=
 =?utf-8?B?cEJ2U1ArRkQ4cTZPZmI4Zys1OTduTlArWlg4bXFSWTI5bVpuWGltaEF1aE5k?=
 =?utf-8?B?MHNYWGZVdGNudFVPUTExVktsVmFLV25DNlVoeXhjZWZYRmZrZ29NZkFmUlhz?=
 =?utf-8?B?MldBQk9zWmk0R0g3SElDNTYzQkNycEQ1QUQrLzJCb28veWRxZXhNUnFFeTJ6?=
 =?utf-8?B?R3VDK2lmTnJacUhERU1OMWFQNUZuTmhBdDc0UjYzS29jT2haS3RUeDZ1djRz?=
 =?utf-8?B?R0hUblNtZVgvcVJyU0pCZThublRSNDBuQWY1dkxTdDV4T0pGdjltS1NnWkVt?=
 =?utf-8?B?OUlzS0lrZGtUL3JkdkZpTjUzNzhMeVpZdDllUmRHU3hVWGkwVXpMV1AxVDVY?=
 =?utf-8?B?dHZ1Qk11R0dGZTRLT3hnYXA5K3J3SG1qREpsSEMzQ21RTjAxMVhKWFNLNERB?=
 =?utf-8?B?aC9OMmR3eW9JbXZWMXRTYnpMb1pVM0JXRVRWTVVPK2xMdmVwc0NkcFFUbkxj?=
 =?utf-8?B?WCt2MU15NHNlWk84ajVFYTRtcnd5bzFzdEJRQzVOaGRkamY4aGlYdVoyT0NB?=
 =?utf-8?B?MkFPdnk3a1g3UThyNEdROXU0azFjTEZpVlA0RWUvSjlnV0tyOUF4dUhHMzZY?=
 =?utf-8?B?R3RLK0RLY296MU01aTBrUmkrNDBsMzgreUpUbWF4djRRRjZLY0E1MHZiVGtT?=
 =?utf-8?B?d2tUUHpMS21QcE9lNUk4WVY3R2dnYnhoSUJMZ1lvUy9UVG8vOCsreTl2VXBv?=
 =?utf-8?B?ZGx5YTBOY3ZFVTRrK05vOGdXbEI1LzU1bWZRV2tsc3ZZbGJRcFFwcVpwMEpI?=
 =?utf-8?B?ei9YUUJ1WDBNbzlITnc5VmhUUTlDOVl1NlZMN0l1bGRNS3NCQWNpQlpNUDEr?=
 =?utf-8?B?eXViVHN2Z2JYZEo2ejhzZ08rODA5TzBtRDA1NDhjaCtnRDJXeFRWN2R0NWo4?=
 =?utf-8?B?SVNzWnFQbHBaNU1CWG1xeEZ0S0lsa1g3Vi9LR1oyVW5OUTZQNERiYkhMcDFC?=
 =?utf-8?B?MHlxRVZ0aWFtWnhHMWZXWjBEMjdPeEMzWk5rcFlkeUptM290a1RucXNLWXdD?=
 =?utf-8?B?OTVzSVZXckZOYngwOVFIY29Bdm1ncDRCdkxTRFJjN1k4V2JMeFFnaEZTN1V1?=
 =?utf-8?B?Y3Q5NDBuY3RVRW9Hb1I5ZmNZVTFjN0RVVzJZbFBKZ3hNWU9SNE1oRFpFMTFZ?=
 =?utf-8?B?MitnL0JlVVg4eHJhbU4vY2ZhNEVLTUJnemY3eXEyTjBkR1FZRko4VUkvdmNy?=
 =?utf-8?B?WlBuODB3WVc1R1Awd1I2RTFSeG9KWWF2RXFVVTVKVVM1WUNJZ2toWUtPZ3BC?=
 =?utf-8?B?b1hHNkVSalFHNFRFekM0ekNvdDRnM0NyRmpRTVJoWkhUYVpMY042dzVMWExa?=
 =?utf-8?B?N1pzdGZXa1AxOHJoRG13dnc2b0VqUEFvbHZkSDRjQXFjVVFUUFJ3VGk2VnlH?=
 =?utf-8?B?Vy9VZzdHMVJFaEM5SVI3OEd6YllKQjNXK1g3eUJJM2F3eGhVeGhVelptaHEw?=
 =?utf-8?B?QkJuVVp1NEwwcGRVOFJmSlBRdjdtbWxrSFZDeG1sbEFhOURNSm14NGc2OU1T?=
 =?utf-8?B?Ujl2dnYwOEVXTmRncmEvNm1lY09jdnpMWTlJaVpGNHlSY3d5QWZrSGNGemF3?=
 =?utf-8?B?Tzk5N05VTzB5T0pMVkEzTDFTZkk5OUkyNzJzLzViRmlmQVp4MTBkbFF2eHFP?=
 =?utf-8?B?UUVNbVFybEp2Tk5MMnFjVHpNVWdCd0Z5bnE4akp6L2ZRU2FQUnlZcmJTTVVm?=
 =?utf-8?B?OGg3VXViSFVzOS9la3B2dk5XazBwRXpleGZzM2FUVGJ0amRvdDM1bkVZeTQr?=
 =?utf-8?Q?hGJ7y4/llr8zVmD+6GGjC1EWPy1oN+GmMG/5wTPWqA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E45A7549760CD449537990245BB10C5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ff3700-51d5-4d7d-e236-08d9b368511d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 18:44:46.7570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4gvFEisbHWsKJWQ7wc6SivWZL2N68+HXTUPt3C1m/zQeQGhTvPLO3rI4IOkEX1QTU45o4zUSqoU/IR2I3AGZyWNH3mUMw4VnxJJnOHzpn2I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4859
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTExLTI1IGF0IDA3OjQ1ICswMTAwLCBTdGVmYW4gQXNzbWFubiB3cm90ZToN
Cj4gT24gMjAyMS0xMS0yNCAwOToxNiwgVG9ueSBOZ3V5ZW4gd3JvdGU6DQo+ID4gRnJvbTogTWl0
Y2ggV2lsbGlhbXMgPG1pdGNoLmEud2lsbGlhbXNAaW50ZWwuY29tPg0KPiA+IA0KPiA+IFJlZHVj
ZSB0aGUgbG9nIGxldmVsIG9mIGEgY291cGxlIG9mIG1lc3NhZ2VzLiBUaGVzZSBjYW4gYXBwZWFy
DQo+ID4gZHVyaW5nIG5vcm1hbA0KPiA+IHJlc2V0IGFuZCBybW1vZCBwcm9jZXNzaW5nLCBhbmQg
dGhlIGRyaXZlciByZWNvdmVycyBqdXN0IGZpbmUuDQo+ID4gRGVidWcNCj4gPiBsZXZlbCBpcyBm
aW5lIGZvciB0aGVzZS4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBNaXRjaCBXaWxsaWFtcyA8
bWl0Y2guYS53aWxsaWFtc0BpbnRlbC5jb20+DQo+ID4gVGVzdGVkLWJ5OiBHZW9yZ2UgS3VydXZp
bmFrdW5uZWwgPGdlb3JnZS5rdXJ1dmluYWt1bm5lbEBpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9m
Zi1ieTogVG9ueSBOZ3V5ZW4gPGFudGhvbnkubC5uZ3V5ZW5AaW50ZWwuY29tPg0KPiA+IC0tLQ0K
PiA+IMKgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWF2Zi9pYXZmX21haW4uY8KgwqDCoMKg
IHwgMiArLQ0KPiA+IMKgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWF2Zi9pYXZmX3ZpcnRj
aG5sLmMgfCA0ICsrLS0NCj4gPiDCoDIgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAz
IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9pYXZmL2lhdmZfbWFpbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRl
bC9pYXZmL2lhdmZfbWFpbi5jDQo+ID4gaW5kZXggY2MxYjNjYWE1MTM2Li5iYjJlOTFjYjljZDQg
MTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWF2Zi9pYXZmX21h
aW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lhdmYvaWF2Zl9tYWlu
LmMNCj4gPiBAQCAtMzQwNSw3ICszNDA1LDcgQEAgc3RhdGljIGludCBpYXZmX2Nsb3NlKHN0cnVj
dCBuZXRfZGV2aWNlDQo+ID4gKm5ldGRldikNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGFkYXB0ZXItPnN0
YXRlID09IF9fSUFWRl9ET1dOLA0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbXNlY3NfdG9famlmZmllcyg1
MDApKTsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKCFzdGF0dXMpDQo+ID4gLcKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoG5ldGRldl93YXJuKG5ldGRldiwgIkRldmljZSByZXNvdXJjZXMg
bm90IHlldA0KPiA+IHJlbGVhc2VkXG4iKTsNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgbmV0ZGV2X2RiZyhuZXRkZXYsICJEZXZpY2UgcmVzb3VyY2VzIG5vdCB5ZXQNCj4gPiBy
ZWxlYXNlZFxuIik7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiAwOw0KPiANCj4gVGhpcyBt
ZXNzYWdlIGluIHBhcnRpY3VsYXIgaGFzIGJlZW4gYSBnb29kIGluZGljYXRvciBmb3Igc29tZQ0K
PiBpcnJlZ3VsYXINCj4gYmVoYXZpb3VyIGluIFZGIHJlc2V0LiBJJ2QgcmF0aGVyIGtlZXAgaXQg
dGhlIHdheSBpdCBpcyBvciBjaGFuZ2UgaXQNCj4gbmV0ZGV2X2luZm8oKS4NCg0KSSdsbCBkcm9w
IHRoaXMgZnJvbSB0aGUgc2VyaWVzIHRoZW4gdG8ga2VlcCBpdCBhcyBpcy4NCg0KVGhhbmtzLA0K
VG9ueQ0K
