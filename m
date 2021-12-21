Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62CE47BBE4
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 09:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbhLUIcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 03:32:18 -0500
Received: from mga14.intel.com ([192.55.52.115]:32870 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232572AbhLUIcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 03:32:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640075537; x=1671611537;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eSdvB2P37WCp3L0vFYloF2GJHFkx/xtDCR5mVGkomMM=;
  b=M5l2IT8CvrieTEQ/YfB+p6pxcyP0Tkgpp9MlzJJBKZb6L3/Zlhe6+tOe
   d/o8qby2wLVFX4XJMNiwFp0yKIC7F8qkwQBXndlLh9q6q14u0DfZyLZqC
   DX7/PjvND2qfg6aoXRw412mb7k3dZG3eKa2b+Y5SioP2qiFhT8oiXmPCB
   YpDPJHyT0Yx5RGLpjDstDJ/X444w2ZWc+8uugPUEN/ZSpRwfVzJMgd0N2
   UxrRlB3WPb1QUw22s7656xV96a02WNL6iubyzB3hFyD9MBrSSoDcC2Hnz
   oey0fX6b4g4vBkpdRhydbOjUD5YZdb/+NF+g9Ak8Iddssxx1r0gBAf68q
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="240575871"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="240575871"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 00:32:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="663884004"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga001.fm.intel.com with ESMTP; 21 Dec 2021 00:32:16 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 00:32:15 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 21 Dec 2021 00:32:15 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 21 Dec 2021 00:32:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aiGNsxiWbpeq0XNEjuRx2ER8dwh15tfMOZKsbkaeetNY7ezO4A1sIFCtc+t3HKV0uB8+14XqbrEUUDrcFk7r0udWIR9Stf0WjBNWYGgbhLNnYCUnILTiW9vtrMmg+8SUdPY6eCY7aJa/83JMxB+QtKPst3u/Jn23Bt27o12Aa0H3XwRXBZ/wGrGtpX9J/W5ee6k4sjYy4jNmxTcDHk2VuUeKeETQDD80m4iFCNrUpXsvkHXDqwM0rSW/GJNjBOaVfnUbm5myQbyCYCVDxOH1q5x9Ks7WUR1pmWBDNAAvUa+qBu4+VWDP9HZQe+GQtV1QmgIBiCu8vbqZUwpJZOiImw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eSdvB2P37WCp3L0vFYloF2GJHFkx/xtDCR5mVGkomMM=;
 b=Fm4T8fgYx5+u9bSQeXlq9GUfjvj0++lB/4GANJ069rzRqmn9YAOSrO0+jhHJ7nq5nwBg8QnKXxQMlXVjK+bpppJ64aKtjopLlCRS5Fvv78vcCQQ7SMONfYVxgFjCptzwd+wt5+ENldsDf5OgDLI+tRCmTFNzbXPJpL8R9oV8bE+kRSonYr/+fOyrHjueKIgNcAML6lSGQTK+Eh+fw0gkPhxdnMKKNjc+foqdHULOF98zTgcXbhUnGGtSku1jOPY0+30LPIc6ZnX5La9Qhci3gdUf9U0EB6/0uoWoCVOXQNZZzIp9QCa0KaPatOVZymCXiDGiv+mouiMBiyjuJ3RQYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB4791.namprd11.prod.outlook.com (2603:10b6:510:43::10)
 by PH0PR11MB5110.namprd11.prod.outlook.com (2603:10b6:510:3f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Tue, 21 Dec
 2021 08:32:13 +0000
Received: from PH0PR11MB4791.namprd11.prod.outlook.com
 ([fe80::85ae:4624:d7b3:1a6d]) by PH0PR11MB4791.namprd11.prod.outlook.com
 ([fe80::85ae:4624:d7b3:1a6d%3]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 08:32:13 +0000
From:   "Loftus, Ciara" <ciara.loftus@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        bpf <bpf@vger.kernel.org>
Subject: RE: [PATCH bpf] xsk: Initialise xskb free_list_node
Thread-Topic: [PATCH bpf] xsk: Initialise xskb free_list_node
Thread-Index: AQHX9bm29t2/H/tXSUiVrM4eP+W2K6w8jrIAgAAP5IA=
Date:   Tue, 21 Dec 2021 08:32:13 +0000
Message-ID: <PH0PR11MB479171AF2D4CE0B118B47A208E7C9@PH0PR11MB4791.namprd11.prod.outlook.com>
References: <20211220155250.2746-1-ciara.loftus@intel.com>
 <CAJ8uoz2-jZTqT_XkP6T2c0VAzC=QcENr2dJrE5ZivUx8Ak_6ZA@mail.gmail.com>
In-Reply-To: <CAJ8uoz2-jZTqT_XkP6T2c0VAzC=QcENr2dJrE5ZivUx8Ak_6ZA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1743905-5a52-4321-a247-08d9c45c6373
x-ms-traffictypediagnostic: PH0PR11MB5110:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <PH0PR11MB51103BE98081CF625C5270A48E7C9@PH0PR11MB5110.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: axO0xm6PT/ML4/RGKTJw37tfhf+zgmPcVTTD3JB/2mHr9hT1SjRegjBdchPsTl7q6Hu+i2HRnQEi7PJoVuAF+ngb6ap/SmZFGKZ8LaCU1ASvK+Pi2G93VGEqwDxYNIOjXypy8+zNvBg0JSgDpgq5Bc1pELBX43/QADMLiFHtZUO/W2XSCFQwiCidXN5QB2YIidVZA9ANEajuL1+TXrlOE5u0fe2yi8ioxwyjQYQ9NZUaeeKjQVN3iWeLOnB2Enxg4nP6JsTGof6aUWASAxcp48f6Ih6KYx7wuOv9ZE2AlQDnxSGB2IlF0Bpij8yIGjepVVcChQy9kYsrOAB6q10HgiVtMX7eKVZQj8UkiFFs2/GfM2XlunIp5RKFopNOqyYapDqUTLh7L4teCDyxni63LvQSF6mW0ftMqh9SAkonDql0CCuJYEbsKTdM9MPTPYfoQl8nxQ854HeIg3eI6GFlvB16U+WP9TSgI2lCduYgcy1xhiWgDLdcYaz/jIoA2Jxvp2RZtfJUnzid5JSLcHE//7QvaFBaqThyWZtQ2Q/1ZD7MsD/xLIvbTrrgE9iPIta+ULTl058VY7er3QTpTOgEXDdkvvpGYNGV0fl49X5KjUxqNPEem+R8ENm080m9mW6adda7R1SAHsApTNqkrqraTns1jqAiXmKeVA0ePNBCT0h+aP/LTTEk57ueKZhEV+TeomUvPoOZ3HRckXmrlvEZqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4791.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(64756008)(6916009)(66446008)(4326008)(122000001)(38100700002)(52536014)(76116006)(6506007)(66476007)(53546011)(66556008)(66946007)(9686003)(5660300002)(33656002)(83380400001)(38070700005)(186003)(2906002)(54906003)(86362001)(82960400001)(55016003)(316002)(8936002)(8676002)(26005)(508600001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OUkrUjRHRUREK2ZQM1RWQlRNUzdZZ3d1emh1dk15NzhLaHVYQ3N4ekpUdTAr?=
 =?utf-8?B?Z3VVMmUwTTE3ZHhnY0wxN2hUYkpmekxEcUFseTQxWDdybnJoeGt3WDljcTFS?=
 =?utf-8?B?S01MbE5kZ2NWcGxKNnQ5T25rbU5BNDJLNm1JSXRtcmtscGpwcnV6ZzdSRWdR?=
 =?utf-8?B?dFordXhTT0h6WGdIK0xpUjJKSmlhNWVIRU1FTUZicytiaUF4Z1pWMmFsKzdk?=
 =?utf-8?B?Wms3bGoydzFHQStHdEJLU1Y1bmpHMDUxQ1JXQ3Z2SWZsak1La0YxbUZnMjk5?=
 =?utf-8?B?RGRWTERFTXo3aU0xV2VKTmhjNHgrV1hSd2xaaXpaM0t4OXlPVDZMTHZoaFc3?=
 =?utf-8?B?Q1pGdEN3dnVuMitXb2Z0Z20wbEVab1p6aW9MeVV4dnBFREw5OVp1SE9WWUtQ?=
 =?utf-8?B?L3ZyOVNKWldLOWNKYUpXM0FlKzg3TmJ1b2diY1k1QzRDeHpnMUVHNnYybzdT?=
 =?utf-8?B?U2Nna01OZUU5c2t0U0YvYXNvVEtPbzc4ZkVIc1UrbWpsUFd3YlRzR0hiMFJN?=
 =?utf-8?B?a0xjUzJ2M1d2ZTZ4NUhRV0lLcUVMTWc0V2xIQlZ4OVU5VzByT3JqTUlUbjNU?=
 =?utf-8?B?QlpMazlBWXhPQXczNWViOUJKYk52WWJkVG1wOW14VWRKSHF3YUI0SG5TY0Zj?=
 =?utf-8?B?SVl3MjJXbW5sbTZDa2ovaE9XMzJkTWx6SDBjdEVldGRkdWZPWXR2N3BUclpB?=
 =?utf-8?B?aEVoWUF6S0ZlclRLc2xhT1FhL2FPdXN5aXY3TzFhNFlGbFYzSWlwWmRTdEI4?=
 =?utf-8?B?SnRhN2paaTExSnZNU2Y1anUwY3RzQndyVnkxbjY1R0V1akwzTkJia3RQejFu?=
 =?utf-8?B?WEVYdUNhM3dFbk1GU1FWMGUzd0VvUDllSzNYYjZVSm15dmpoSjBQTWtvVks5?=
 =?utf-8?B?M2lxSDBmS1ZKQmRZdDRqWTNFYWNibEdudEVCNXp3My9UbHNxdkVqdTVmOHVq?=
 =?utf-8?B?V3l3K3JUNWNWaGhmZFpnVUg5bk1BNHF5dHM5aTA5a0pwUk1EZzdPRW9mSElQ?=
 =?utf-8?B?M0JOMFF4ZHNZVlpkVzR0dCs1N3k1dGNZSjlzMkk0QjUySjltMkxpMkw4REE2?=
 =?utf-8?B?TGUxeFRFZXZEelJiaWs4WEhhU3VpTnJIcCsyeDBqSlRVVSs2eE9zdXQxaGVD?=
 =?utf-8?B?T2x5akVxZHlvRzdXcmludGFTaW5ueEdKVGxTdlNwV1ZLQ1h1Ym5lbWZPWEVX?=
 =?utf-8?B?NFBlTDQyY2pxVGRyUzltUUxLZHlSdnppUUZ2aGllTXZhamF0MmdKbjR0aGdG?=
 =?utf-8?B?STRzaCtlYnpYUWFySTh2QkQxdW43N0IxRG1VQnNJK3ltL1pyK3FtZ1FzeXdo?=
 =?utf-8?B?OG8zR0ZOTm5jZC9SYUlrbUZkcFh2RmZWL3JQc2pvdzBZQTBaTG9XTVpVZHhT?=
 =?utf-8?B?Yi9ZTXFVc2hsZUlqNGFScW9aWmhuMUpucENlZW9NbXRGT2k5amFGdTJKYTZ5?=
 =?utf-8?B?V3V1elF5TWQrL292RmJScnluamZQSU5jQi9jOFV0TFlVVjNuUjFzamE0UGtt?=
 =?utf-8?B?ckRhTk1QZVZ3WG5lSCs5Zk9BZ0xlci9NZ0IyRUZoNG10aEI3R21mVEpMRXRz?=
 =?utf-8?B?OGc4L0t1eHd0czBuaWwwUTRKODJCRXEzeXhDVlNuOCtBNE05b0EydE9lVEgy?=
 =?utf-8?B?ODB5TVAwMmVZTG44STQxVzRxeGNjNU83UHhCUUYxNGpnZnVPbC9pNEVMT2VN?=
 =?utf-8?B?ZzkvK01SaGhWTnBBNWd6Y3hsRlEvTGdUY2dnN1hIQjRFUUtZd0lsSUw0MG5K?=
 =?utf-8?B?WXFmY1dMak5qbStmYzIxaGdlUjdJbU55RE5XQ0k4cXlxN001YnhDbE85YWxw?=
 =?utf-8?B?TW5JeDVPSXgzT0EyRy9raXVQTXBhQ1ZyV3EzWlFVUUx6RFAxNkV5WVhRMkhs?=
 =?utf-8?B?TC96NFZiSzcwa2ZtZHJDczJhcXhuT3l2S1hwVjJ0N0ZmcU1RTDBxZmJ6YVdr?=
 =?utf-8?B?N0pWL1Zod2poYytWU083N3J1ZE5lS3RnRjBrTjMyUzJLQjI4Vk9TL0JUbWEr?=
 =?utf-8?B?ZFB6d0ZlbUE4SDY4Z1FZaW16MndRT1E2YWt2a3VFTFcrVmFDQ1k2M3dNT3lv?=
 =?utf-8?B?enpFd0NKVzFpTWFLVnlpVVZPdlRaa2Q1S1FlUm5jOFJKRGtPTHNyUTkwaGFR?=
 =?utf-8?B?dlhlUk5zRkZVZWVYaHZrQ24zR2VJK0RQWFI1MDdYS25ncHRQbS9RbS9mSm5w?=
 =?utf-8?B?d2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4791.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1743905-5a52-4321-a247-08d9c45c6373
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 08:32:13.2932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nm8blv7P62FW4enLqW5v7eFVgwOsOuumUWLpPdd1GJiKsmlcBmCg233Ruo9lxCnU7Qq08ICVz69OtEaC6I1JJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5110
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBNb24sIERlYyAyMCwgMjAyMSBhdCA5OjEwIFBNIENpYXJhIExvZnR1cyA8Y2lhcmEubG9m
dHVzQGludGVsLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4gPiBUaGlzIGNvbW1pdCBpbml0aWFsaXNl
cyB0aGUgeHNrYidzIGZyZWVfbGlzdF9ub2RlIHdoZW4gdGhlIHhza2IgaXMNCj4gPiBhbGxvY2F0
ZWQuIFRoaXMgcHJldmVudHMgYSBwb3RlbnRpYWwgZmFsc2UgbmVnYXRpdmUgcmV0dXJuZWQgZnJv
bSBhIGNhbGwNCj4gPiB0byBsaXN0X2VtcHR5IGZvciB0aGF0IG5vZGUsIHN1Y2ggYXMgdGhlIG9u
ZSBpbnRyb2R1Y2VkIGluIGNvbW1pdA0KPiA+IDE5OWQ5ODNiYzAxNSAoInhzazogRml4IGNyYXNo
IG9uIGRvdWJsZSBmcmVlIGluIGJ1ZmZlciBwb29sIikNCj4gPg0KPiA+IEluIG15IGVudmlyb25t
ZW50IHRoaXMgaXNzdWUgY2F1c2VkIHBhY2tldHMgdG8gbm90IGJlIHJlY2VpdmVkIGJ5DQo+ID4g
dGhlIHhkcHNvY2sgYXBwbGljYXRpb24gaWYgdGhlIHRyYWZmaWMgd2FzIHJ1bm5pbmcgcHJpb3Ig
dG8gYXBwbGljYXRpb24NCj4gPiBsYXVuY2guIFRoaXMgaGFwcGVuZWQgd2hlbiB0aGUgZmlyc3Qg
YmF0Y2ggb2YgcGFja2V0cyBmYWlsZWQgdGhlIHhza21hcA0KPiA+IGxvb2t1cCBhbmQgWERQX1BB
U1Mgd2FzIHJldHVybmVkIGZyb20gdGhlIGJwZiBwcm9ncmFtLiBUaGlzIGFjdGlvbiBpcw0KPiA+
IGhhbmRsZWQgaW4gdGhlIGk0MGUgemMgZHJpdmVyIChhbmQgb3RoZXJzKSBieSBhbGxvY2F0aW5n
IGFuIHNrYnVmZiwNCj4gPiBmcmVlaW5nIHRoZSB4ZHBfYnVmZiBhbmQgYWRkaW5nIHRoZSBhc3Nv
Y2lhdGVkIHhza2IgdG8gdGhlDQo+ID4geHNrX2J1ZmZfcG9vbCdzIGZyZWVfbGlzdCBpZiBpdCBo
YWRuJ3QgYmVlbiBhZGRlZCBhbHJlYWR5LiBXaXRob3V0IHRoaXMNCj4gPiBmaXgsIHRoZSB4c2ti
IGlzIG5vdCBhZGRlZCB0byB0aGUgZnJlZV9saXN0IGJlY2F1c2UgdGhlIGNoZWNrIHRvIGRldGVy
bWluZQ0KPiA+IGlmIGl0IHdhcyBhZGRlZCBhbHJlYWR5IHJldHVybnMgYW4gaW52YWxpZCBwb3Np
dGl2ZSByZXN1bHQuIExhdGVyLCB0aGlzDQo+ID4gY2F1c2VkIGFsbG9jYXRpb24gZXJyb3JzIGlu
IHRoZSBkcml2ZXIgYW5kIHRoZSBmYWlsdXJlIHRvIHJlY2VpdmUgcGFja2V0cy4NCj4gDQo+IFRo
YW5rIHlvdSBmb3IgdGhpcyBmaXggQ2lhcmEhIFRob3VnaCBJIGRvIHRoaW5rIHRoZSBGaXhlcyB0
YWcgc2hvdWxkDQo+IGJlIHRoZSBvbmUgYWJvdmU6IDE5OWQ5ODNiYzAxNSAoInhzazogRml4IGNy
YXNoIG9uIGRvdWJsZSBmcmVlIGluDQo+IGJ1ZmZlciBwb29sIikuIEJlZm9yZSB0aGF0IGNvbW1p
dCwgdGhlcmUgd2FzIG5vIHRlc3QgZm9yIGFuIGVtcHR5IGxpc3QNCj4gaW4gdGhlIHhwX2ZyZWUg
cGF0aC4gVGhlIGVudHJ5IHdhcyB1bmNvbmRpdGlvbmFsbHkgcHV0IG9uIHRoZSBsaXN0IGFuZA0K
PiAiaW5pdGlhbGl6ZWQiIGluIHRoYXQgd2F5LCBzbyB0aGF0IGNvZGUgd2lsbCB3b3JrIHdpdGhv
dXQgdGhpcyBwYXRjaC4NCj4gV2hhdCBkbyB5b3UgdGhpbms/DQoNCkFncmVlIC0gdGhhdCBtYWtl
cyBzZW5zZS4NCkNhbiB0aGUgZml4ZXMgdGFnIGJlIHVwZGF0ZWQgd2hlbiBwdWxsZWQgaW50byB0
aGUgdHJlZSB3aXRoOg0KRml4ZXM6IDE5OWQ5ODNiYzAxNSAoInhzazogRml4IGNyYXNoIG9uIGRv
dWJsZSBmcmVlIGluIGJ1ZmZlciBwb29sIikNCg0KSWYgSSBuZWVkIHRvIHN1Ym1pdCBhIHYyIHdp
dGggdGhlIGNoYW5nZSBwbGVhc2UgbGV0IG1lIGtub3cuDQoNClRoYW5rcywNCkNpYXJhDQoNCj4g
DQo+IEFja2VkLWJ5OiBNYWdudXMgS2FybHNzb24gPG1hZ251cy5rYXJsc3NvbkBpbnRlbC5jb20+
DQo+IA0KPiA+IEZpeGVzOiAyYjQzNDcwYWRkOGMgKCJ4c2s6IEludHJvZHVjZSBBRl9YRFAgYnVm
ZmVyIGFsbG9jYXRpb24gQVBJIikNCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IENpYXJhIExvZnR1
cyA8Y2lhcmEubG9mdHVzQGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgbmV0L3hkcC94c2tfYnVm
Zl9wb29sLmMgfCAxICsNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+ID4N
Cj4gPiBkaWZmIC0tZ2l0IGEvbmV0L3hkcC94c2tfYnVmZl9wb29sLmMgYi9uZXQveGRwL3hza19i
dWZmX3Bvb2wuYw0KPiA+IGluZGV4IGJjNGFkNDhlYTRmMC4uZmQzOWJiNjYwZWJjIDEwMDY0NA0K
PiA+IC0tLSBhL25ldC94ZHAveHNrX2J1ZmZfcG9vbC5jDQo+ID4gKysrIGIvbmV0L3hkcC94c2tf
YnVmZl9wb29sLmMNCj4gPiBAQCAtODMsNiArODMsNyBAQCBzdHJ1Y3QgeHNrX2J1ZmZfcG9vbA0K
PiAqeHBfY3JlYXRlX2FuZF9hc3NpZ25fdW1lbShzdHJ1Y3QgeGRwX3NvY2sgKnhzLA0KPiA+ICAg
ICAgICAgICAgICAgICB4c2tiID0gJnBvb2wtPmhlYWRzW2ldOw0KPiA+ICAgICAgICAgICAgICAg
ICB4c2tiLT5wb29sID0gcG9vbDsNCj4gPiAgICAgICAgICAgICAgICAgeHNrYi0+eGRwLmZyYW1l
X3N6ID0gdW1lbS0+Y2h1bmtfc2l6ZSAtIHVtZW0tPmhlYWRyb29tOw0KPiA+ICsgICAgICAgICAg
ICAgICBJTklUX0xJU1RfSEVBRCgmeHNrYi0+ZnJlZV9saXN0X25vZGUpOw0KPiA+ICAgICAgICAg
ICAgICAgICBpZiAocG9vbC0+dW5hbGlnbmVkKQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAg
IHBvb2wtPmZyZWVfaGVhZHNbaV0gPSB4c2tiOw0KPiA+ICAgICAgICAgICAgICAgICBlbHNlDQo+
ID4gLS0NCj4gPiAyLjE3LjENCj4gPg0K
