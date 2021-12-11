Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB84471416
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 14:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhLKN7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 08:59:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:63214 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229819AbhLKN7c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Dec 2021 08:59:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639231172; x=1670767172;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7RzduVg5yuQDZXjUsqJG9fdNjJ0S11aqRjrLj+L3Ykw=;
  b=XYILrXcKSJlTUgjJrhrG62rVD4rYFxutcdnnedHJMfVYvRKehBexQTZG
   mLNxEDXvnoMnDMs8ROmLeAPXUTXVwkQYd7QRtcN2HXfSo8FPCyKqbrMk+
   LsWO90lq56z7PSqsL4zEdboHeYgTlUbz1FKcLuCRm+qKwv56bpw6oMF1D
   VDjkpUhpgv7TfGKK2q4htpPPZXWIxduecszeLCutR8imuZFhuPC/Aj0Lt
   SddR165se4Ty6l8wzPin4GpUp+N9UGbQhh7UPpI1DMkkGQBxD8Wsjypzl
   NfxWBErqdSHlR5xbDrpzU7T+fFoGnA4VSgqwoBWWBz72RS91BA/Ag6GbB
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="236053979"
X-IronPort-AV: E=Sophos;i="5.88,198,1635231600"; 
   d="scan'208";a="236053979"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2021 05:59:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,198,1635231600"; 
   d="scan'208";a="565762268"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 11 Dec 2021 05:59:31 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 11 Dec 2021 05:59:31 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sat, 11 Dec 2021 05:59:31 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sat, 11 Dec 2021 05:59:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEQDsHH35jh2vhFQL6A00zGt+NGqae8upS3wIv1OD+4JsTFUwmc2fhqiMigd8MwAEqvSaPAPT3+ypzAmaF7qJQVXkpvpW8ZWu88fIxwWaSfdOXaFTXTLT6HZIqVreNGeIYHT97o4lgwWxEQOjKyAq2/ddGINvprQSoD8lUWG5MvBsMRT+QvhMkwYaXhHiBSoPMan6jYEQwhCtd1bci3c6WI5cu3lT4H49S7/b1c5q3EY5hW5XBlAOASvkjmSdkX2IVgJBnk1kFfAVh9xXlTVN1++76etJlJPjva22smX+p2gJ0vlp9PSRsy8fhdQD5xBRHKQYA6imAhBtQR6RlYbnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7RzduVg5yuQDZXjUsqJG9fdNjJ0S11aqRjrLj+L3Ykw=;
 b=XjdgzLgyxH7Mp+4dgdT7ZaT93P9Zq4wUu0S1gD5TijziODBeDccW8ro1+AwBjkaSvzKRazxGq7wCti9Zi952VnaNfNaF0LVtv35tFAnYWZHOyYR1G1u8iOPIMIy00TbTJa8HGF1JPYHQN+AO+LW0svGnHjcukZ5LA2t96wktX3hljGoKMDY++rTYpbXkzeAKLsO6Ofbq5wSH9YdhOIudNcFkjk19EO2qrUJnxix9ECrJ0uY/EiU4wnJtQ/xyPP2QDA1NYFlwemX4JkQB2ELjR4nSiJGpQ0BgpCZm20Uz0hoIpy732sSwKYqcJODeiHkSbYns5sZ6pvXx92ubGhm14Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RzduVg5yuQDZXjUsqJG9fdNjJ0S11aqRjrLj+L3Ykw=;
 b=PebesAlJ0F9esO49rJWRISB+VIbnzkSBwmKMy19snW+LNIMgFg3qNwFmDwDqXCSLDpz1FeMY9buYy+vswtaBJGOgWPRJ97hULLp41oPWQkx0uuTcUbBt29kaObnTTL7Qg40tZIJRppx5ObiV382wbITlj8p87GV0RFzS7fZiwFQ=
Received: from DM6PR11MB2780.namprd11.prod.outlook.com (2603:10b6:5:c8::19) by
 DM6PR11MB4219.namprd11.prod.outlook.com (2603:10b6:5:14e::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.14; Sat, 11 Dec 2021 13:59:29 +0000
Received: from DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::e08d:fd5a:f208:566d]) by DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::e08d:fd5a:f208:566d%4]) with mapi id 15.20.4755.026; Sat, 11 Dec 2021
 13:59:29 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Jose Abreu" <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "Kanzenbach, Kurt" <kurt.kanzenbach@linutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net-next 1/2] net: stmmac: fix tc flower deletion for VLAN
 priority Rx steering
Thread-Topic: [PATCH net-next 1/2] net: stmmac: fix tc flower deletion for
 VLAN priority Rx steering
Thread-Index: AQHX7RBbS77e6pkAekizP9E4vauzMqwr7DsAgAFmvbA=
Date:   Sat, 11 Dec 2021 13:59:29 +0000
Message-ID: <DM6PR11MB2780874495EC43159600767BCA729@DM6PR11MB2780.namprd11.prod.outlook.com>
References: <20211209151631.138326-1-boon.leong.ong@intel.com>
 <20211209151631.138326-2-boon.leong.ong@intel.com>
 <e8d3e33d-a89b-bdcf-431d-6759e7b45393@oss.nxp.com>
In-Reply-To: <e8d3e33d-a89b-bdcf-431d-6759e7b45393@oss.nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.200.16
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a65da38-9471-457b-3fbb-08d9bcae7341
x-ms-traffictypediagnostic: DM6PR11MB4219:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB421960635F300C6970AE7021CA729@DM6PR11MB4219.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1EflvUEqVtiag6FgLU+cnrVzKI+7744cLOPuzQ5o8OUKPmiWPyDSHcuYas/LGFxOF+06/cVUYEmU1kynWDWWM2Ko2EOsN9pVrH4178JtNghf0jrTYV25BbBUTo3/subCatRCMQqWSEoNfebpM2II8Zb/aHO/0ZjI8XGwfGN86AskSDYCLheyW/W3EZJdVfcrhV9elIRSMyahnUeYwhgQzcUEBLakIljwcJcFrsPMLZn3Jum7KnctTwx+WO0MsGRw6PLIwqFWCQ7yU3Rvvs+QwPQh2vjA02wxKS84cD3KxF2XIcVkgrUPrnuzq2hqN1OSsubeYkIRpt2tDO+Ew7Y5iHch4Hg/gB7sdEp4VfUtwdhxpGgCfTd6PaIC4dSOIhe9uFkXsq1sT52icHtd8H4HuLi3zYeq8fbfg/xbsb2hFAz9pWmkhgnHsPdzVqHiBUKEdeuYXs08jh9YR2O0kkQTgI0tYFuPqQgxa+ORyzy7tNZCqQKwb0xoWZXBzaR+2JXKyfu1qtHMCcLXzs+FCFKWtm7T/DFrEfp1uUQsZ4r4g6J/egBhG7WfYbZjnDzt2UCPoB71thTMmKqHfh4IibQve+v2qRGLEgTNEInGNITiUB52aT4h4loyZFyE7yRQTWBc7s2/FexmiwjTwemylnDq5pRuP29sOovz3cxHKS/tQPGBqiPsXMHqP+kaDHQWLsZCPxWTRA9fDyEHmQd7YGuhrO+E+DhzWDsYDslqZULe5YMn1UUD1w5yldu5dy6YI2Q9svDmHCOzHsC0TK+pTcjDVv+O9QRwWGHdSX9CWSNidBcUZznBan5P//XREAjueoF4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(7696005)(83380400001)(71200400001)(82960400001)(122000001)(6506007)(921005)(38100700002)(55016003)(33656002)(5660300002)(4744005)(26005)(54906003)(64756008)(66476007)(66446008)(86362001)(66556008)(66946007)(76116006)(316002)(52536014)(4326008)(110136005)(508600001)(8936002)(7416002)(966005)(38070700005)(8676002)(2906002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NkRBaVUwQTlycHZTMW14M2dQRDZxUkVnVlgxNWhlWWpKUnd1Z3Y2ZEEwbnVI?=
 =?utf-8?B?SkJxNko5a0pkaUNSSFhnNXBadWNXSStnTnM4d0U2b1lpQ0JsQmVLVVZPWldI?=
 =?utf-8?B?N2N4VEpJL29vdHRxVGwraUdSOUNNa2tqK2t2UFJ1Q29rSVVKNkFtYXF4elRO?=
 =?utf-8?B?RlpqV3JGQzk1NzQ2czhlUWFTMU1CM0JhelRxMVV0aUVzcEFKYWU0T2lCc0Vz?=
 =?utf-8?B?TFV3NFoyZU1obFFlZ25aM0FPQ3BzV09aN2p5T05RZDVIMUxkLzVxL1R4bVVv?=
 =?utf-8?B?ajI0WmRnY2xsd3BFTG9iUGRnYmQwenVKYk5DTVNGQmkzeGI0dTErNzRPUGJN?=
 =?utf-8?B?N3FkTU9xUVB1cW1uTDlESG9HZEwvS29iamVZWFBsQTExQTkxdkdZNzFWV3R5?=
 =?utf-8?B?ZDF0MUNTbU9RaWNwVkMxazZUejdLSWpQK25wWHdWbnYxYlZKMHA3M2NoWDNF?=
 =?utf-8?B?VDE1U21jVW9MU09xT1pOU3REenBLRytDS3hCMEpFbmNRVGtRUmh0dGxsOU5C?=
 =?utf-8?B?L1k5RExPZUhDanNIQnl1Yy9va0s3OHUyMUJuOVpJOXk4VmJQbnV0WVdKeTRW?=
 =?utf-8?B?STFYVGl4Y0FBZWFDcHdQNWpSNUw0Y0xFUU9JMEFXb3hFQzlvY2lUbHFuMlB3?=
 =?utf-8?B?MGcvbGNSdU51VG8vbGU0T1NUUEZSZUp4UmVsYjF4dVF1VUMyZzN5N21WVjZU?=
 =?utf-8?B?QVZEcnZBRjAxUzAzSVdpcXpCNWJiMlVDNXNtMTZqYjliUC9MSnEvTDJ1c1hm?=
 =?utf-8?B?REVhUnlKVFJpeS9VUUoxek5ITWRKTUVIaVJickx2Z1RTWDFOVFVvSHpFdkgv?=
 =?utf-8?B?TUtiTUYvRjBWYUlTWGdVZ2NITjhLM0pCYVd3UjRuUWEyZmZqVCtKZ1dmR0tP?=
 =?utf-8?B?SXYyY2tRTVpTakpPUHlHQlAvcUoxVXBFUGVpbTYwWHJmc3Zrc0RWY1NtTFJn?=
 =?utf-8?B?RGVZL3RTbzlhc25hVi9NaVR6cm1vc2h5SlhXN1loM1hiL0V3RVYrSWRIQ01o?=
 =?utf-8?B?dnZNcEpIQXB2a1EzdS9taDRoNXN1ZWdFRW40NURVenlUVm5oRmhTWDB5Q0RI?=
 =?utf-8?B?K0NYYkJWcmpXWGtKZzlTNXgrVDhwTEdBWGZxV2p0dHhBNmowRWExVnJwZSti?=
 =?utf-8?B?aU5Pb3dDVTNLc0x0eFZ4TDZFWWNJd1ZsSlgyTC9zYUsyTml1cXJYYU55N0gv?=
 =?utf-8?B?S21wVVNGcFM3c1dOWVBqMzVVRnozYVJVRHYyaEJKZU9FSzRhcjlJWUZRVlFG?=
 =?utf-8?B?NkJwaDFtUjYwSVpQdkZKb044a3RFWHhOQitvU0N4SGVXRDM4K093SEMzWHQ5?=
 =?utf-8?B?TW1ROEpMVGxwZFp0M3hFaUNoUTA5UW12OHdiVFIvMmJyNm1nclkyOTZHc0Qz?=
 =?utf-8?B?YjdzVjdJaTN0blhDalhIS2hRcjdPMzBCTnhSb2h6UHFFWEZEOVcvelE2bTR2?=
 =?utf-8?B?YnBsYWpwMmpML0RMb25acjhreWFHRC80R0hKMEthUHZXOUI5VmlZem5OQUlJ?=
 =?utf-8?B?ZDFZWmhkWWIrSmNXaXNwc2Z0MjRvdmJKV28rM1BZSm1UV05mYlBheTRtYzdH?=
 =?utf-8?B?bHZDeTA0U1cxaFJwT0xXemszb0R2RFVFZWJYUVlXbDFKaVJMV3RudFhMNTQr?=
 =?utf-8?B?blN0NGc5QUlpYUdBd1IrQXQxcWdXdVh0bXRMODNJYmNWcGJQNmdNNi9qSDF0?=
 =?utf-8?B?U29UclZJOTlvdG1iaytQTmRvSkJTWUdZUU9ma2dsWWpuVzhWWlpmdjlpdjlH?=
 =?utf-8?B?ZGxLZ1hqc3kxWkhiYUhWSEdPU3o0UEtaTGM3TnBQK284emVGdkJ0MVk2TGM0?=
 =?utf-8?B?M1doTjBoRUU0UW5pNmVLN2w1c0JDQ0dhcW9HeVgvL1J3WGVuVTB6Q3NncFhC?=
 =?utf-8?B?V2JsRnV6d0ZWcXZkQjBGbitNZE8yU2ZJOWlnWC81V2JBSDRXUDgvMExoMTNN?=
 =?utf-8?B?ZkpEbklvVDJrNThlRklNUVdLM0tSdGVKL3lwS2Nad2RLTEJqSnkvYUR3NnRM?=
 =?utf-8?B?dXB2TE1yTjJiaFFOcGpBYVVBME11dFphYUc0Vzc3U0xLK1NvY29yRlVoOU43?=
 =?utf-8?B?RjVnVVpiS2d4dk41cDVtRTNDbDNhdDdkL1Z0NnJwMU95MEhGU1hsV3FtUFU4?=
 =?utf-8?B?cXlDSE1hZ0dzSDU3UGQ2eGlMQ3RFWDNxWEpDNXhFUENrN3llZSs3dDVaakQ0?=
 =?utf-8?B?SzZ3R0JaUXVpcDEyVElROVFzMjVIdzFJVVFJVWg1OTNvTVNPaVpEUlZ0cEIr?=
 =?utf-8?B?K2tBTFVHbEthcUJWalIwam1VQWpBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a65da38-9471-457b-3fbb-08d9bcae7341
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2021 13:59:29.3310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xr1EOJMdcZqhloJ1tHc7cx/Wbj3UdZ6vfHaXaftLC5UCxewnhSZ6gtF1K2jY8E4hRpzdXlnW9MD9+QQwnQBrKNwsYXroJmmMxe+5OXNpQDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4219
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pkkgd2FzIGFib3V0IHRvIHBvc3QgYSB2ZXJ5IHNpbWlsYXIgZml4IGZvciB0aGF0IHNhbWUgcHJv
YmxlbSAoZXhjZXB0IEkNCj53YXMgYWRkaW5nIHN1cHBvcnQgZm9yIG90aGVyIHBhY2tldCBzdGVl
cmluZyB0eXBlcykuLi4NCj5JIGNhbiBjb25maXJtIHlvdXIgcGF0Y2ggd29ya3MuIA0KDQpUaGFu
a3MgZm9yIHRlc3RpbmcgaXQuIA0KDQo+Tm90ZSB0aGF0IGEgc2ltcGxlciB3YXkgdG8gcmVwcm9k
dWNlIGlzDQo+c2ltcGx5IHRvIGFkZCBhIGZpbHRlciwgdGhlbiByZW1vdmUgYWxsIHRoZSBmaWx0
ZXJzLCBlLmcuOg0KPiQgSUZERVZOQU1FPWV0aDANCj4kIHRjIHFkaXNjIGFkZCBkZXYgJElGREVW
TkFNRSBpbmdyZXNzDQo+JCB0YyBxZGlzYyBhZGQgZGV2ICRJRkRFVk5BTUUgcm9vdCBtcXByaW8g
bnVtX3RjIDggXA0KPiAgICBtYXAgMCAxIDIgMyA0IDUgNiA3IDAgMCAwIDAgMCAwIDAgMCBcDQo+
ICAgIHF1ZXVlcyAxQDAgMUAxIDFAMiAxQDMgMUA0IDFANSAxQDYgMUA3IGh3IDANCj4kIHRjIGZp
bHRlciBhZGQgZGV2ICRJRkRFVk5BTUUgcGFyZW50IGZmZmY6IHByb3RvY29sIDgwMi4xUSBcDQo+
ICAgIGZsb3dlciB2bGFuX3ByaW8gMCBod190YyAwDQo+JCB0YyBmaWx0ZXIgZGVsIGRldiAkSUZE
RVZOQU1FIGluZ3Jlc3MNCiANClllcywgeW91IGFyZSByaWdodCBhYm92ZS4gSSB3aWxsIHJlc2Vu
ZCB2MiBmb3IgdGhpcyBwYXRjaA0KdG8gZml4IHRoZSBjb21tZW50IGdpdmVuIGJ5IFNlYmFzdGlh
biBvbiAibmV0IiBwYXRjaCB2ZXJzaW9uDQpoZXJlOiBodHRwczovL3BhdGNod29yay5rZXJuZWwu
b3JnL3Byb2plY3QvbmV0ZGV2YnBmL3BhdGNoLzIwMjExMjA5MTMwMzM1LjgxMTE0LTEtYm9vbi5s
ZW9uZy5vbmdAaW50ZWwuY29tLw0K
