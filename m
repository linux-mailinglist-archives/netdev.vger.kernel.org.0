Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3598C3FFC68
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 10:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348501AbhICI4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 04:56:33 -0400
Received: from mga12.intel.com ([192.55.52.136]:15342 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348434AbhICI4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 04:56:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="198914678"
X-IronPort-AV: E=Sophos;i="5.85,264,1624345200"; 
   d="scan'208";a="198914678"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2021 01:55:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,264,1624345200"; 
   d="scan'208";a="689560438"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 03 Sep 2021 01:55:30 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 3 Sep 2021 01:55:30 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 3 Sep 2021 01:55:30 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Fri, 3 Sep 2021 01:55:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khG82zp0JPFP3T4z9YfPvDVAADBSNAmYaGxEq7YPmM9dfODkuo7jnMtz55XG+HNSCcHQqCtT+fraT0jZ4N8DzUwHTSmjsQSNoU9QXI4j5DGkaxq/RAcBoAgylFoJE9HH1lU3gnk8JSvuTHbkYnhDHhPe9OOv4dr5RYjU33mw500mnUhrQ3wtkOU8XIPDLQV6fMNk4VPsBdFhGSK84mh3QOlZWk20Z40+5IlUZIYLOR38M32jR1B2PHNCyNdvvn9Mjk5K1CvrM1D1LkJqmABWpPH2ZJ89PBPUiwDaXF/2HnHEsAhCIlHf236OLUFXYlkQ6cWUGP46Etg12ItuID0KPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpNZLLfpvlwczUKxoVPONHxCcYYGUNd38u199SPPZcw=;
 b=P83JIErwhChC4rAuleAlfDWwSegRKEOYMN3y+7e9YCaH7PTe4YIfaBNRXMzPHjCcIp0/b7/yifcGbEiPYbAU2yB/m7qrxKB0gUlz7zndOsVjjevMYKeSuQ/DuWL8Ss7cmiVyg3ENTSsCXPDn3IE1G/VCYzU1sgqs/93kga127oCV8QgeJulbd+lH9ZnJqlPtWhwsLdM5QF6XeERBhkR+emd+yN3SoaNJ6X9tcMWx4KovSf2AbhLoiBmbgtVnyhr2OPODHMiqBPs9nsNFdCRJdoZoyn6+3XiZGdBIMH4HxL2ps/xzuFULoxvuZ9fJUD+4ovrXm3mJNAXtWGl9mOIhCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpNZLLfpvlwczUKxoVPONHxCcYYGUNd38u199SPPZcw=;
 b=WASW5zV4bCMEs8a1CsftT2/tAR4tZScqMMJcfpWRPG0CVWO+0xNqK9D1eX2Dn57U7Mh2orsGvvZhw4P3BkWIZCVt7e6K+hSlNmXds8aUoroNvUm8hF8W4QrcZPf7XQM0bOwbFlKad45UrqoYdZDrYU7q4Chl0ZBOw0b0gs0EzXE=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BYAPR11MB3431.namprd11.prod.outlook.com (2603:10b6:a03:8d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Fri, 3 Sep
 2021 08:55:28 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::bc8c:80c0:1c01:94bf]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::bc8c:80c0:1c01:94bf%7]) with mapi id 15.20.4478.020; Fri, 3 Sep 2021
 08:55:27 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "drorx.moshe@intel.com" <drorx.moshe@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH] iwlwifi: pnvm: Fix a memory leak in
 'iwl_pnvm_get_from_fs()'
Thread-Topic: [PATCH] iwlwifi: pnvm: Fix a memory leak in
 'iwl_pnvm_get_from_fs()'
Thread-Index: AQHXoDuMqjEmSTfSWUq5za3SL/kFfquR+F2AgAAKCoA=
Date:   Fri, 3 Sep 2021 08:55:27 +0000
Message-ID: <ecb513984c95f69c4fb773591d873d795f344174.camel@intel.com>
References: <1b5d80f54c1dbf85710fd285243932943b498fe7.1630614969.git.christophe.jaillet@wanadoo.fr>
         <20210903081929.GB1957@kadam>
In-Reply-To: <20210903081929.GB1957@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.3-1 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35592aab-e5d0-401e-4123-08d96eb8939d
x-ms-traffictypediagnostic: BYAPR11MB3431:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB343172A69CBFCF64D38D82B790CF9@BYAPR11MB3431.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YFLreBrMqJLRsy6Jt3AMGfS2f2NP6aeS2RT6XtGBLOq8joAbSTIqkFaZr81E2nVWjatIiH/CG/S0PndQXCHGuCJAEHMvI61T9rKo8YyYqyywrJNWDjOMH1hcJml6berzPBS4XOD/pZPGfUdliJcCxSj4qxwosN/biqqf9fbo5PZii43SXgTycCdBqq5bb++9tZXtvftRx6wpEnV/o+EfbQhZ2fl3kgdZJEjR5IUff6OuR217Klmc6psH3QAfohF22H60+OO/1x4LwUpvRFYdxcnZhoU890depgpeDdLRApDuLxNNzH0ic2+Q2b1tND2t7kZjrKYiApgXFKMTDGBOKChFiKv70CWirWubRngBvA5oAoZhQGJzxh/hUNvRvthNDuYVR7bRH5vS4zCnIoArOgpzlLXP8rJyGYURFXqBj7mILO7FrcBMcoJTxkLyogJD0HoHRcOE2zsYZvfFlUKqjstJF2vuLGB3XZnzBt3J4UIL7ruapkMip9gpPxkUZAfj5xGFyalJFAHaG7Ua8PPeay95xEucURy+IrknIe0OwkVB1PJtIRanfE8NJP8XYyLxcjwihe66+Ay9r4RGAoGrw3VC0EqyYb4r2N6x+/P+k0rlxOsEsycjdgfmaOLohfDdHYugcWrUbK9TIAGHOc0so0LDo7OC88Nck70kiGK4ppZ7ybgKdnL1yoQYcA9tW02nE177DMqE4dqFjR6OPN62jg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(8676002)(8936002)(122000001)(6512007)(83380400001)(86362001)(66476007)(26005)(110136005)(6486002)(478600001)(316002)(186003)(66946007)(4744005)(91956017)(2906002)(76116006)(38070700005)(4326008)(36756003)(66446008)(2616005)(38100700002)(7416002)(64756008)(71200400001)(54906003)(66556008)(6506007)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?blFLVTR1UHBUK2tDV04yeG5SMkNERnVMOU96ZjFSaDFxcXZ2azNTaStEakp5?=
 =?utf-8?B?dnIvc3hEdGpuZysvMkZSKytwYVFDaDVqdVM1M1Q3MDdCa3R6aU14NHkzUENv?=
 =?utf-8?B?QjFxNSt0L3ZWTC9qVnNYM1ExcERtRGlGMEE4R2pkNlA3elBPZmZnMVBsekgx?=
 =?utf-8?B?emFMM0VkVnQ2c1UybHNCK21rQjc3c2VhaHM2Z1k4eVBnc1VZYnB5M3NZV3hD?=
 =?utf-8?B?eXNDbWIrZGdsQVYxM1haYWp0cVpKayt1NXd4T1Z5d0ZwOEUzL0s3THloSTdt?=
 =?utf-8?B?ZGJSQXM1MU9sU0k4WTE0cDExYjdOMGVwdWhrK0FweVBBclhFakovR2xtSUFU?=
 =?utf-8?B?WGt0MjhZV1Y1K2pPM3ZwUFpUMUllaENHbC96MFd4ajYxTVBmVTJ2aWhrNVNI?=
 =?utf-8?B?dXg4emVJR1I0dXEvY1JNNnJaSG10Q1did2Y3UzMwNStuYXNaazR4QzEyajRl?=
 =?utf-8?B?TlpmeEc0RjZiSjlsODRQdkJ2dTJxaTJNN3hHS2RJa3dBbkdOWEoxWHZHYVdR?=
 =?utf-8?B?cTYzRVZXMStoTFhENkxjQVcxdTZJVS94N3ZkQXNncVpVcHZnSzk1ZCtvdGtj?=
 =?utf-8?B?dlE4SDJCZzJ2RjVkNDBLOFRKd29COUtsaFVRY0t4bnpQdVc3NjRDU212WUNP?=
 =?utf-8?B?ZkZpcmxJcnlKVjlJNkJ5a1Y1cU0zYWtNTFFiZ0U0Q29tcGV0dTkrRk9BZ0N2?=
 =?utf-8?B?N1dkRGxvcDMwbzc5Y01nVXppR08rSXpsbHROTjZwUllUTTJ6dzFBR2tmT3ZK?=
 =?utf-8?B?Z2Y4VVhiUXpyL3lVTWFOVFpHZU41RTdYN2RGM05EZFA0N082ZHF6ZHlLQkx1?=
 =?utf-8?B?UmhwMUdUampidkxodFhraHhmMjVxaWFKamxMM3g1OHNPNGdScjV4VkhBcmFW?=
 =?utf-8?B?ek9SVEtLK0M5Q3M2MFIyMXdKTzZ1S09PRCt4cEJ5a1cyM1ZaNTlDOWJlYjZS?=
 =?utf-8?B?RWtpYTdxbVFLdGN3ZWdXQTI4Z1BTZS9LOVBlVWppSk1YK2JaT1hBUG5NVk9i?=
 =?utf-8?B?RkRsT0g2bWRnZllpelFIYWE1NVFpZXQ3dVlTS3F1NWYrc2xyd2p2WWRYOE93?=
 =?utf-8?B?K1FMZjkwS3A3cXc4Z1ZuUkNiVDJzZWNScTgvR3FNeTFNUmhTU3NmUmc5cUJi?=
 =?utf-8?B?eWo1YlpsSEJ4Rm1INzJMYUNUeExDd2V1VGFtdi8rRjRWeXprV2dyL1pNb0Jy?=
 =?utf-8?B?NmRmSi9QRHZvZzNlMGIySHNublJWK0hpdXNHbWF4UE1sTHVxZFlQSUdLZnFx?=
 =?utf-8?B?MEtnZm9zS2dpeVhBT0EyLzZiZVBySTFWaUdZQ0o5Y3c0OVZveFJpaDBtRklk?=
 =?utf-8?B?eEM4K01JMlcwU0VZNzcyUGg2bDlzbjBvNGkyTTRwN0wveFJEbGNWMWJDTkNr?=
 =?utf-8?B?SFhIdm5lelhGK1VTT1c3N3VNV3VQR01yVXFDN0xCZ01mUGZoVzVVYmRVOW1N?=
 =?utf-8?B?Z01TTENUdXRBM3IxekNxVmM2VDBXOHdjelJNM1ZQZ3RVODYyQ2hxam1rOFhG?=
 =?utf-8?B?eUlaaHNaWUNCWW1SYTNGTnI3a3dXYy9CQ2daWUk0eHpLa2t2TW10MCs5R1lO?=
 =?utf-8?B?NE1HdmN4cW1DZnhHZEovZmpuUG56K1U0UmdwY3VOWGlrMUgvVGhyaFVzblNq?=
 =?utf-8?B?RExmT3IrbHRaK0U4RXJhT3NBUVl1dE9EbUZqNk5ZNjBibnZEMHpSVUtHQUJD?=
 =?utf-8?B?NGtURXd0dU5XcmFtcytrdElpQmNSczYwTUNVdEZKRG12Umh6YmJ6MXZtcURU?=
 =?utf-8?B?TVcxZXFINTdDbDN0ZHhqZ2lNdVIxMVhFbzJCQ0Q4V050OG5MYzdwSkpmdGIx?=
 =?utf-8?B?S0JQS0E0MndVbVUvZGxKdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A4CF4FBDB5B6747B5B77721A7C3B2DD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35592aab-e5d0-401e-4123-08d96eb8939d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2021 08:55:27.4722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MDe/jd5YJ5QR3tWGfFOULhF0VawD6vZLlrodRrVqjHO6tlYNOO/Gu+vcaF5Er22It3KjnwBlUUzKR3zAwjgYi+ubMXBcwcUIjdyEhUfyP7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3431
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTA5LTAzIGF0IDExOjE5ICswMzAwLCBEYW4gQ2FycGVudGVyIHdyb3RlOg0K
PiBPbiBUaHUsIFNlcCAwMiwgMjAyMSBhdCAxMDozODoxMVBNICswMjAwLCBDaHJpc3RvcGhlIEpB
SUxMRVQgd3JvdGU6DQo+ID4gQSBmaXJtd2FyZSBpcyByZXF1ZXN0ZWQgYnV0IG5ldmVyIHJlbGVh
c2VkIGluIHRoaXMgZnVuY3Rpb24uIFRoaXMgbGVhZHMgdG8NCj4gPiBhIG1lbW9yeSBsZWFrIGlu
IHRoZSBub3JtYWwgZXhlY3V0aW9uIHBhdGguDQo+ID4gDQo+ID4gQWRkIHRoZSBtaXNzaW5nICdy
ZWxlYXNlX2Zpcm13YXJlKCknIGNhbGwuDQo+ID4gQWxzbyBpbnRyb2R1Y2UgYSB0ZW1wIHZhcmlh
YmxlIChuZXdfbGVuKSBpbiBvcmRlciB0byBrZWVwIHRoZSB2YWx1ZSBvZg0KPiA+ICdwbnZtLT5z
aXplJyBhZnRlciB0aGUgZmlybXdhcmUgaGFzIGJlZW4gcmVsZWFzZWQuDQo+ID4gDQo+ID4gRml4
ZXM6IGNkZGExOGZiYmVmYSAoIml3bHdpZmk6IHBudm06IG1vdmUgZmlsZSBsb2FkaW5nIGNvZGUg
dG8gYSBzZXBhcmF0ZSBmdW5jdGlvbiIpDQo+ID4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoZSBK
QUlMTEVUIDxjaHJpc3RvcGhlLmphaWxsZXRAd2FuYWRvby5mcj4NCj4gDQo+IFJldmlld2VkLWJ5
OiBEYW4gQ2FycGVudGVyIDxkYW4uY2FycGVudGVyQG9yYWNsZS5jb20+DQoNCkFja2VkLWJ5OiBM
dWNhIENvZWxobyA8bHVjYUBjb2VsaG8uZmk+DQoNCkthbGxlLCBjYW4geW91IHBsZWFzZSBxdWV1
ZSB0aGlzIGZvciB2NS4xNT8gSSdsbCBhc3NpZ24gaXQgdG8geW91LiANClRoYW5rcyEgDQoNCi0t
DQpDaGVlcnMsDQpMdWNhLg0K
