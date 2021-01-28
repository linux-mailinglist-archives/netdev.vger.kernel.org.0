Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B753080B5
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 22:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbhA1VqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 16:46:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:14955 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231576AbhA1Vpt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 16:45:49 -0500
IronPort-SDR: rVAMHC5j6Kr0SMoSqGIQkml+ut1SMWNmo9LNdfcH+QACqG3zzdEiJ4EKTH8UILAmWuReh4riWo
 3K8O1kuFb6pQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="167417450"
X-IronPort-AV: E=Sophos;i="5.79,383,1602572400"; 
   d="scan'208";a="167417450"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 13:45:07 -0800
IronPort-SDR: 2PcdfOAN6lXfd7RVpdzoxkOzDFMqtXYH7XoRD1gQMjF9xmR1R1ozq7GS4RWj0UXl1v/yWF8QLJ
 6KDxfK42+LCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,383,1602572400"; 
   d="scan'208";a="409308231"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga002.fm.intel.com with ESMTP; 28 Jan 2021 13:45:06 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 28 Jan 2021 13:45:06 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 28 Jan 2021 13:45:05 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 28 Jan 2021 13:45:05 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 28 Jan 2021 13:45:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fs3zVj6gqekRLtI2PKS15baP22vLfmYLgLWunWH3BuAyIS2HjILu2S49wANUProVxkCtpZcWVASGlhwHdpRsERydsN8cG0YcxWBsSM80pzBfpjjPjx16aTk64B0z0vr29rZurWWDbyhsbnTwCmbSIA+YEDN5xN3NtyIshn/Rf837DZZwUxN8jFuViVU1ttrYOsaOOunX6y5iGU0a0wpZV+0RqFKRHUvuk3ZmfuLaS1cjHO6nCUrG+v23SF7+rf3L0s89rC+KaF40+35lgYpLuYTxZ9qLi8fNoprqCyi+WSh8ZEOAz/SkK1TeMcJRPjlFHbfXPWrKPzmJDjmruUvCYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pseyb+eDeHDuwzPeEfXj8EbAc0uCLwDPtulY8B6N5MU=;
 b=Xq4SqvSV3eGK0+LrupooCxNoOyUlHqMj9vEXSRWyxmry1lt7LtueJprI5hKG9Shr1KzaIMHxkNG0N4pLx7Wm74fMGXWs9hCd3ZGwu8hoiN55frzARKiX9YQckDZOm7ul8ehQo9zEvBN9Czbi+cz0i0MiCqSqO4X8z+3k04l8IkPO8sMmLiyHuPc8mB3cbs31klAt9hpEi+U8fAz2xonMyX3VLKg0IQZhsLQRifLePtveMnEXGtswAlnJepvfPiBa5BmkNonlXSeY6ZngX5dSK2CW4hwsRs1mZ2fb/q9dexLbtIrRsF1gr3m5o2i05f2fdJ2z8tm9tirF0K3j2c8EFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pseyb+eDeHDuwzPeEfXj8EbAc0uCLwDPtulY8B6N5MU=;
 b=FinmJUAiAXTX8vkbX1ijW5C3nYry/aL/yVRSfPXEn5heWSqKzZyqpl0TsLX606GAt42M2lSGkBfjieU0yCCnSfUz9sqL0eFJg905g45gp6toqu9IcVD1QfOoR1CnQVWymCy04zB/C9LQMcSJwjN1q4unHYFe/k/XJe6xpejaaws=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB2846.namprd11.prod.outlook.com (2603:10b6:805:5b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Thu, 28 Jan
 2021 21:45:02 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::fc53:e004:bade:6bc6]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::fc53:e004:bade:6bc6%6]) with mapi id 15.20.3784.019; Thu, 28 Jan 2021
 21:45:02 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH resend] e100: switch from 'pci_' to 'dma_' API
Thread-Topic: [PATCH resend] e100: switch from 'pci_' to 'dma_' API
Thread-Index: AQHW9bmpuW6anwN/D0+vVxQdnsKIc6o9kjWA
Date:   Thu, 28 Jan 2021 21:45:02 +0000
Message-ID: <268fcfd4dbd929948e8cdb58457ede1efa3898c6.camel@intel.com>
References: <20210128210736.749724-1-christophe.jaillet@wanadoo.fr>
In-Reply-To: <20210128210736.749724-1-christophe.jaillet@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7792ba7-1fb4-4cf1-7663-08d8c3d5f7bd
x-ms-traffictypediagnostic: SN6PR11MB2846:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB284667332461CF44DE3F7DC4C6BA9@SN6PR11MB2846.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hWAWmqFhNszJLL2LlYjbUNIzKlFRv9g6VZciTKnVat2XGb2G0C1j/PHmFC/kVukxqHTM0yU+S8BRoJUXs4+khHBaUAxlPDILAxK7J6+5yYdQMClOZxhnpDpvrDqvA6i/4y4nJVtWeFyn1mPqOA6hKByhYDAPLu0LjgjEeqHbpQ6qSap0MQxiyFaULYxtHdx5m+VQIW5JsY0++jqdME4Zk+77fNyRMNVlIJsRMVfKY+sYMO8Kh/Hbl3oq5hVAwZGBCAvg8k5RTYLKDcu+Ggu7vRQNOPXlEq8PqaU7IP+VtSUeKgTmovV1rTEozZXgza9/5ohl/tlzDhXbIs/ADcGRTt3bIWaSg9o3ZkTj1JVk5zbmCqb9JzwaC6EGCHBS0DQSEerpyHpeGpIeDmfY0awQGamBFilZR3yjw6eX+hzKR6Rrv5nIAOZxkkC5R26P/Bfh2WRfiKHph9Y3XKITV1RHyqYHdhJW5IQOX4fv66NdDKnxOMaWqRCq8JZhFAlTrOZItMSD3CQ4CyR/UfWaefvV/norHU590bKWSCTBGZLs73B9rOp0naq3k+WFt+JGaZXq7wyhfT6M6J6TyD/pO+E35Bfmo7EScA9hqmFVeQDdMSE4e+n9EQl8xTB+x74VQOpwGlKUYO3vIukEakcezJ7QUL7z5JRJ++qi+QBF1Khpkgw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66446008)(66556008)(45080400002)(498600001)(66476007)(26005)(966005)(6486002)(8676002)(64756008)(186003)(5660300002)(86362001)(76116006)(91956017)(6506007)(8936002)(2616005)(6636002)(4326008)(36756003)(71200400001)(2906002)(54906003)(83380400001)(6512007)(110136005)(99106002)(6606295002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VzNXMktTOXpNbHd6ZW0rdk10N0ZkcXVkRWhSTDNGdlZNY1JoMXBmc0VqUnEy?=
 =?utf-8?B?cXJjR3JEczljTFY3S2NkclVlM3JHK25WQ0kyUzA1dHlDVkwvWSs5VmdpSHRR?=
 =?utf-8?B?MkMrOHRPVWhkVzdaNTBYZzNzWllMaWNOcjNMRklkdU9rTStYNU4zd3k3UklU?=
 =?utf-8?B?cStncU8wZGI0bWZGcStVYVhoZEx0aWxXSEFaczUyZVRpc1VZZWVBRmhEK3lQ?=
 =?utf-8?B?R1l1UkpnVk9ibmtwSVBQaGZ6KzVYbVdLZDMzZCtQejhWRFZDNzJpU2FpM2VG?=
 =?utf-8?B?MWZSS1p3bzY2aGFBMWJlOFlsZFhHZ0dTRHFPTExRS3VzbEJsaVlNNE42YzJO?=
 =?utf-8?B?TFZ5RjBVSkZIZzA4cnZHUkcxaUFlbWozZTVSaG5UcGlMVnUrMGxCcFlIQXJK?=
 =?utf-8?B?YVU5NWVXWU1MK0xGUjVIVXNIZ2lFem9wbUxLMVJKcWdFNVhYalN6azFIMTRG?=
 =?utf-8?B?bHpzMXo2dFdSWVB5L3dpNE1xYnpKdlc5dEYrV1dDSXRyOHM2YW4wY1V5bHIx?=
 =?utf-8?B?ckJURVV6ZjZucEk3WVQzTi9PUUtOYlBDdnJWQXV5S0g5V2E1RVZteGtiWGpE?=
 =?utf-8?B?ZkRyR0JLdWRFcUpxei9HcEtsMFZydE9MMExFN0dqY3Fhb2JuY1BKWGpnbThK?=
 =?utf-8?B?NTZPK0F5SEhIeXhxSGRCU3ZRV05SWHhEM29JdWNMMVhEcGYwTW9jQ1BNaTFt?=
 =?utf-8?B?S0VtZzFOQmxNMFF1OTVoOHNMZHVGMjNETFlMRVd5Nm1DT2pSZ2ExRUJZK1d6?=
 =?utf-8?B?RE9mWlBXL0hmM1BTbGxQb1FNVHNzaGxsUHk1QjFQNzFMR1phUmVPTDRUL1Ni?=
 =?utf-8?B?VDBWYXhtUy96RW9saWR4Z1A5UlpYeVY1WERGcjB0NGFHOVhJMm5JeER6S1VW?=
 =?utf-8?B?Tytid2pnRGdLQktEUEtvWWtvNFV4MXNQZHFsQzZEcmxyWTNIS3hwOEZGUit0?=
 =?utf-8?B?aXR1V09uaVA1d3QyMmVTYmVqbmlxYjc1ejVPOVhFQVpPMC9uYTZsbVJ4VkpQ?=
 =?utf-8?B?N0FFTWFuUU0rdnRsaGN2Z2lpZXRWcjUxNitidDRjSWhiU21kbWhOMmkra3ly?=
 =?utf-8?B?TGpKbTd4NDlud3diaEErS1UvSWRhOUdBMHpMblFoUkRjU1RUdXZ0V0d6Mi96?=
 =?utf-8?B?KzE5ODhtSU9JMXpaNGNQM3haQi9xTkl5SUNHSkZ2ZkJkWUptdkpuMStRVjNO?=
 =?utf-8?B?aENyeHRGTktUR0l4SDQ0aWRTOFdWNDQ1Tm1YeVBnOVBnK29vRHBxMDA4ZCtB?=
 =?utf-8?B?RDBzd0ZrYXVQeDl0amkrTXBPMDNod3ZLVzJUWmpiQjV3NHlYcDljRGg3SUE2?=
 =?utf-8?B?MjVXS2dWb0FQTjZpOERyVWNHOUZBc0d4dEpTZk50dG5YTkk1KzRFZHljNmxW?=
 =?utf-8?B?QzFnUlBxbDNjN1BQNm51emhOTW9NSThEUVdvTmVQMDQyR1hRZnpvL3R5VjFm?=
 =?utf-8?B?OVhxSGhRMjFSU0dLbW1XczZTd3ZmRTlPbHIwbzRRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F5F8B549290B14F8647DA0630B2EACB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7792ba7-1fb4-4cf1-7663-08d8c3d5f7bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 21:45:02.3195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RdsAFwTsdk1i2esDQULCmxQh3ka5eB32/gn4+RxdL5wMvkaofnzztY5LzV86lUisIbKP7YDS6Fiuvz2IU2yuJ/3DcvSxBnwWYWjd0Xf0eBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2846
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTAxLTI4IGF0IDIyOjA3ICswMTAwLCBDaHJpc3RvcGhlIEpBSUxMRVQgd3Jv
dGU6DQo+IFRoZSB3cmFwcGVycyBpbiBpbmNsdWRlL2xpbnV4L3BjaS1kbWEtY29tcGF0Lmggc2hv
dWxkIGdvIGF3YXkuDQo+IA0KPiBUaGUgcGF0Y2ggaGFzIGJlZW4gZ2VuZXJhdGVkIHdpdGggdGhl
IGNvY2NpbmVsbGUgc2NyaXB0IGJlbG93IGFuZCBoYXMNCj4gYmVlbg0KPiBoYW5kIG1vZGlmaWVk
IHRvIHJlcGxhY2UgR0ZQXyB3aXRoIGEgY29ycmVjdCBmbGFnLg0KPiBJdCBoYXMgYmVlbiBjb21w
aWxlIHRlc3RlZC4NCj4gDQo+IFdoZW4gbWVtb3J5IGlzIGFsbG9jYXRlZCBpbiAnZTEwMF9hbGxv
YygpJywgR0ZQX0tFUk5FTCBjYW4gYmUgdXNlZA0KPiBiZWNhdXNlDQo+IGl0IGlzIG9ubHkgY2Fs
bGVkIGZyb20gdGhlIHByb2JlIGZ1bmN0aW9uIGFuZCBubyBsb2NrIGlzIGFjcXVpcmVkLg0KPiAN
Cj4gDQo+IEBADQo+IEBADQo+IC0gICAgUENJX0RNQV9CSURJUkVDVElPTkFMDQo+ICsgICAgRE1B
X0JJRElSRUNUSU9OQUwNCj4gDQo+IEBADQo+IEBADQo+IC0gICAgUENJX0RNQV9UT0RFVklDRQ0K
PiArICAgIERNQV9UT19ERVZJQ0UNCj4gDQo+IEBADQo+IEBADQo+IC0gICAgUENJX0RNQV9GUk9N
REVWSUNFDQo+ICsgICAgRE1BX0ZST01fREVWSUNFDQo+IA0KPiBAQA0KPiBAQA0KPiAtICAgIFBD
SV9ETUFfTk9ORQ0KPiArICAgIERNQV9OT05FDQo+IA0KPiBAQA0KPiBleHByZXNzaW9uIGUxLCBl
MiwgZTM7DQo+IEBADQo+IC0gICAgcGNpX2FsbG9jX2NvbnNpc3RlbnQoZTEsIGUyLCBlMykNCj4g
KyAgICBkbWFfYWxsb2NfY29oZXJlbnQoJmUxLT5kZXYsIGUyLCBlMywgR0ZQXykNCj4gDQo+IEBA
DQo+IGV4cHJlc3Npb24gZTEsIGUyLCBlMzsNCj4gQEANCj4gLSAgICBwY2lfemFsbG9jX2NvbnNp
c3RlbnQoZTEsIGUyLCBlMykNCj4gKyAgICBkbWFfYWxsb2NfY29oZXJlbnQoJmUxLT5kZXYsIGUy
LCBlMywgR0ZQXykNCj4gDQo+IEBADQo+IGV4cHJlc3Npb24gZTEsIGUyLCBlMywgZTQ7DQo+IEBA
DQo+IC0gICAgcGNpX2ZyZWVfY29uc2lzdGVudChlMSwgZTIsIGUzLCBlNCkNCj4gKyAgICBkbWFf
ZnJlZV9jb2hlcmVudCgmZTEtPmRldiwgZTIsIGUzLCBlNCkNCj4gDQo+IEBADQo+IGV4cHJlc3Np
b24gZTEsIGUyLCBlMywgZTQ7DQo+IEBADQo+IC0gICAgcGNpX21hcF9zaW5nbGUoZTEsIGUyLCBl
MywgZTQpDQo+ICsgICAgZG1hX21hcF9zaW5nbGUoJmUxLT5kZXYsIGUyLCBlMywgZTQpDQo+IA0K
PiBAQA0KPiBleHByZXNzaW9uIGUxLCBlMiwgZTMsIGU0Ow0KPiBAQA0KPiAtICAgIHBjaV91bm1h
cF9zaW5nbGUoZTEsIGUyLCBlMywgZTQpDQo+ICsgICAgZG1hX3VubWFwX3NpbmdsZSgmZTEtPmRl
diwgZTIsIGUzLCBlNCkNCj4gDQo+IEBADQo+IGV4cHJlc3Npb24gZTEsIGUyLCBlMywgZTQsIGU1
Ow0KPiBAQA0KPiAtICAgIHBjaV9tYXBfcGFnZShlMSwgZTIsIGUzLCBlNCwgZTUpDQo+ICsgICAg
ZG1hX21hcF9wYWdlKCZlMS0+ZGV2LCBlMiwgZTMsIGU0LCBlNSkNCj4gDQo+IEBADQo+IGV4cHJl
c3Npb24gZTEsIGUyLCBlMywgZTQ7DQo+IEBADQo+IC0gICAgcGNpX3VubWFwX3BhZ2UoZTEsIGUy
LCBlMywgZTQpDQo+ICsgICAgZG1hX3VubWFwX3BhZ2UoJmUxLT5kZXYsIGUyLCBlMywgZTQpDQo+
IA0KPiBAQA0KPiBleHByZXNzaW9uIGUxLCBlMiwgZTMsIGU0Ow0KPiBAQA0KPiAtICAgIHBjaV9t
YXBfc2coZTEsIGUyLCBlMywgZTQpDQo+ICsgICAgZG1hX21hcF9zZygmZTEtPmRldiwgZTIsIGUz
LCBlNCkNCj4gDQo+IEBADQo+IGV4cHJlc3Npb24gZTEsIGUyLCBlMywgZTQ7DQo+IEBADQo+IC0g
ICAgcGNpX3VubWFwX3NnKGUxLCBlMiwgZTMsIGU0KQ0KPiArICAgIGRtYV91bm1hcF9zZygmZTEt
PmRldiwgZTIsIGUzLCBlNCkNCj4gDQo+IEBADQo+IGV4cHJlc3Npb24gZTEsIGUyLCBlMywgZTQ7
DQo+IEBADQo+IC0gICAgcGNpX2RtYV9zeW5jX3NpbmdsZV9mb3JfY3B1KGUxLCBlMiwgZTMsIGU0
KQ0KPiArICAgIGRtYV9zeW5jX3NpbmdsZV9mb3JfY3B1KCZlMS0+ZGV2LCBlMiwgZTMsIGU0KQ0K
PiANCj4gQEANCj4gZXhwcmVzc2lvbiBlMSwgZTIsIGUzLCBlNDsNCj4gQEANCj4gLSAgICBwY2lf
ZG1hX3N5bmNfc2luZ2xlX2Zvcl9kZXZpY2UoZTEsIGUyLCBlMywgZTQpDQo+ICsgICAgZG1hX3N5
bmNfc2luZ2xlX2Zvcl9kZXZpY2UoJmUxLT5kZXYsIGUyLCBlMywgZTQpDQo+IA0KPiBAQA0KPiBl
eHByZXNzaW9uIGUxLCBlMiwgZTMsIGU0Ow0KPiBAQA0KPiAtICAgIHBjaV9kbWFfc3luY19zZ19m
b3JfY3B1KGUxLCBlMiwgZTMsIGU0KQ0KPiArICAgIGRtYV9zeW5jX3NnX2Zvcl9jcHUoJmUxLT5k
ZXYsIGUyLCBlMywgZTQpDQo+IA0KPiBAQA0KPiBleHByZXNzaW9uIGUxLCBlMiwgZTMsIGU0Ow0K
PiBAQA0KPiAtICAgIHBjaV9kbWFfc3luY19zZ19mb3JfZGV2aWNlKGUxLCBlMiwgZTMsIGU0KQ0K
PiArICAgIGRtYV9zeW5jX3NnX2Zvcl9kZXZpY2UoJmUxLT5kZXYsIGUyLCBlMywgZTQpDQo+IA0K
PiBAQA0KPiBleHByZXNzaW9uIGUxLCBlMjsNCj4gQEANCj4gLSAgICBwY2lfZG1hX21hcHBpbmdf
ZXJyb3IoZTEsIGUyKQ0KPiArICAgIGRtYV9tYXBwaW5nX2Vycm9yKCZlMS0+ZGV2LCBlMikNCj4g
DQo+IEBADQo+IGV4cHJlc3Npb24gZTEsIGUyOw0KPiBAQA0KPiAtICAgIHBjaV9zZXRfZG1hX21h
c2soZTEsIGUyKQ0KPiArICAgIGRtYV9zZXRfbWFzaygmZTEtPmRldiwgZTIpDQo+IA0KPiBAQA0K
PiBleHByZXNzaW9uIGUxLCBlMjsNCj4gQEANCj4gLSAgICBwY2lfc2V0X2NvbnNpc3RlbnRfZG1h
X21hc2soZTEsIGUyKQ0KPiArICAgIGRtYV9zZXRfY29oZXJlbnRfbWFzaygmZTEtPmRldiwgZTIp
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGhlIEpBSUxMRVQgPGNocmlzdG9waGUuamFp
bGxldEB3YW5hZG9vLmZyPg0KPiBUZXN0ZWQtYnk6IEFhcm9uIEJyb3duIDxhYXJvbi5mLmJyb3du
QGludGVsLmNvbT4NCj4gLS0tDQo+IElmIG5lZWRlZCwgc2VlIHBvc3QgZnJvbSBDaHJpc3RvcGgg
SGVsbHdpZyBvbiB0aGUga2VybmVsLWphbml0b3JzIE1MOg0KPiAgICBodHRwczovL21hcmMuaW5m
by8/bD1rZXJuZWwtamFuaXRvcnMmbT0xNTg3NDU2NzgzMDcxODYmdz00DQo+IA0KPiBGaXJzdCBz
ZW50IG9uIDE4IEp1bC4gMjAyMCwgc2VlOg0KPiAgICAgDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2xrbWwvMjAyMDA3MTgxMTU1NDYuMzU4MjQwLTEtY2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFk
b28uZnIvDQo+IEl0IHN0aWxsIGFwcGxpZXMgY2xlYW5seSB3aXRoIGxhdGVzdCBsaW51eC1uZXh0
DQo+IA0KPiBUZXN0ZWQgdGFnLCBzZWU6DQo+ICAgIA0KPiBodHRwczovL2xvcmUua2VybmVsLm9y
Zy9sa21sL0RNNlBSMTFNQjI4OTAwMUU1NTM4RTUzNkYwQ0I2MEExRkJDMDcwQERNNlBSMTFNQjI4
OTAubmFtcHJkMTEucHJvZC5vdXRsb29rLmNvbS8NCj4gDQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvaW50ZWwvZTEwMC5jIHwgOTIgKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0N
Cj4gLS0NCg0KTXkgYXBvbG9naWVzLCB0aGlzIHBhdGNoIHNsaXBwZWQgdGhyb3VnaCB0aGUgY3Jh
Y2tzIGZvciBtZS4gSSB3aWxsIHNlbmQNCml0IGluIG15IG5leHQgbmV0LW5leHQgMUdiRSBzZXJp
ZXMgb3IgSmFrdWIgeW91IGNhbiB0YWtlIGl0IGRpcmVjdGx5IGlmDQp5b3UnZCBsaWtlLg0KDQpU
aGFua3MsDQpUb255DQo=
