Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39BAB341049
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 23:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbhCRWUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 18:20:35 -0400
Received: from mga06.intel.com ([134.134.136.31]:4583 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230368AbhCRWUa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 18:20:30 -0400
IronPort-SDR: H5OaUkwe0mRk6ollQlZshqW4bQb4SjELPPI/h3awXbuRTTO7f7uNn2yznVvSPjoL+eTQpRpzkW
 Feo5CLiiTyig==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="251134504"
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="251134504"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 15:20:29 -0700
IronPort-SDR: Fb7OliFbgD1EQI4WaJi27DBKHOoEXn127kk+q1ZrvC72svp88DKZVDgZXJlwrmavj9U6w8sMpe
 CcA9hhUFqQyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="606357843"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 18 Mar 2021 15:20:29 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 18 Mar 2021 15:20:29 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 18 Mar 2021 15:20:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 18 Mar 2021 15:20:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=btBjIllYIc4gfFniULJQJfq8w33D078VzDPGMPd4ggP4XIyWemmIkvctwrtzcXLXWaDZLjZJ+AewWuy0F8epxnTg7BnE9bjX1LEwLpTLKYgPhDfK3CIu33nxsueDc0CPUumBtiKbvXCYpTqJwTvG3CQrdVLP/tkU/6EFaVcTlh0sJ6dsTrwbFYJ+uf2Bk+k0LuaAZ+8Lpi9x66hdlJUB2m8xhtT/LBD4gy2DIBlePiQP2yxjGewDpLzbwcWc4hpZ4mcWFx/fhLKkKKO/7N1xJAah95LJ4XlYrVVMtq8fQWWBwhpFr88XfyBxppSlETlt2t68JKuHAy9XNLJwHj76Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7C5QftOyo5iqas1nQ+7UwPiRVxgTaQIO86PI14YHxKY=;
 b=IYIvqIK2Nyaa+Y5sjCsNXdGDMTQZ8Q2t1n31X5j4GNb9oQFjh9lGZqRCSwdM95MiEJ6Xu2UWrtEL2tyot3YTab85wgvDkIojQCTARNWcUGTMKyElePfBRD6BQ6OJnXuyLW1wXZrgMvUr0wH7mLx66KYz3nqT6yyyQnizae+pqdutiwbB+fzS4x28UvLRTvMR3jcvOw+q/dXMVxNsmyp1vwX3do5EbErzJkR0f5NKcixsfOlM6D3NJR9qzuLlgAP4ajO2loywKbYTopyXLwhNABNs5nlHeG2L+LXo/p2erLBW34EqhoFrUComkZf63WZyjMMtacRrCb0kE/zB63wmsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7C5QftOyo5iqas1nQ+7UwPiRVxgTaQIO86PI14YHxKY=;
 b=THx61/5s85CCx6frVO3LEgP3TjQj24uSQO48XQT6EO6qdzjTMfXYhoAAHsqyq5k/MkS1v6KgjpKgXDhn4O+Dx5u5lILz0ZfeKuRW/z18sAT/ysT7nItmMZ+Dv6JeZhy2EPueXoYcQ2zsViWR32N/J0AyTQh0MqVhxrMhX7DqH2k=
Received: from CO1PR11MB4835.namprd11.prod.outlook.com (2603:10b6:303:9e::22)
 by MWHPR1101MB2096.namprd11.prod.outlook.com (2603:10b6:301:58::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Thu, 18 Mar
 2021 22:20:25 +0000
Received: from CO1PR11MB4835.namprd11.prod.outlook.com
 ([fe80::ed6e:8db3:5164:91e5]) by CO1PR11MB4835.namprd11.prod.outlook.com
 ([fe80::ed6e:8db3:5164:91e5%4]) with mapi id 15.20.3955.018; Thu, 18 Mar 2021
 22:20:25 +0000
From:   "Creeley, Brett" <brett.creeley@intel.com>
To:     "yongxin.liu@windriver.com" <yongxin.liu@windriver.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "andrewx.bowers@intel.com" <andrewx.bowers@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] ice: fix memory leak of aRFS after resuming from
 suspend
Thread-Topic: [PATCH net] ice: fix memory leak of aRFS after resuming from
 suspend
Thread-Index: AQHXG89Ix1ZFoWAMGUe4XtUE8m2uAqqKUDIA
Date:   Thu, 18 Mar 2021 22:20:25 +0000
Message-ID: <5c5c7e89492526a7faffec9b03306ceefab86a3c.camel@intel.com>
References: <20210318081507.36287-1-yongxin.liu@windriver.com>
In-Reply-To: <20210318081507.36287-1-yongxin.liu@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.207]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 129a990b-fa6c-4d66-ff4b-08d8ea5c0754
x-ms-traffictypediagnostic: MWHPR1101MB2096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB20968BDFFFB282758BE3E74BF5699@MWHPR1101MB2096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9YWlTLGyfw8BKqa8lJVjPG4FjVCcfFy/+J4mu/25k1AlepMFCo/eGYEwaHnJCG0yinQkXUTh2rtq/pgkQfGNMrJ2XL3Ngl0Nw0cCwd3BrDXufmpvPvir9ShQPPUDEcjOL1Vc+GEBInKzKcMm4ccAhUU86R25yZTXWfoDALAftJN1fnjNan9/o/NQ4+wIPEBM3DGSOVSpT+w2GkC1XfK/Z+pPmCKyUlcI8J0FVwNI7O66YNHY1pFYuzuJ/n5GUYQRLtTT7Epyvw3+e4uvV3G5Np9eKvSgllD51NIVO1J+oGEMr2drRWmimnkbf99dzjUh3OD2nsEvNHbKr+dR6r8nTGBnABCnsNu9AMWqUnwwVuVTL2mtPOwroBmiJjw8+m0y+W72f/ak4xqXLvIRVoApCbiZwbG59JgzTKQVm6MbiNij4v/Sd4zvn9Ex6wh3W9OJoLngEdJcbAoCmMJq0KIhPWr8wvVGMHnnSmBDNu050oxTf5aDNZSboetlKpCkDCN9xpIVpF0LK6dDx4gSZ0FySDsf5LKB7MGM7P2HIYuHNcyctx0+4jEr/mOJbaD3xAFqXpIaNpBNp6V1pS5PZtZX4xK7kPJVi48XD7fX2scvLLy6Rp4dA4x/5deojmiR15sr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4835.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(346002)(136003)(366004)(38100700001)(8676002)(6512007)(91956017)(66946007)(186003)(4326008)(26005)(76116006)(6506007)(6636002)(71200400001)(110136005)(6486002)(86362001)(2906002)(36756003)(316002)(5660300002)(478600001)(15650500001)(64756008)(2616005)(83380400001)(66556008)(66446008)(66476007)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TzBDUzBoUk51MVoySWMrWnVMZGlacDh3YzNBWU5mRDgxVCt3YXYvdURING5k?=
 =?utf-8?B?RUhSYU10T3hXSjg3ZURzdWZCOFM1SzdhMEEvb1ZqbGltWk5EVm16cUR3a28w?=
 =?utf-8?B?WnorQklJQ2xsYThocXA4bVo5WXFPaFNjTDJ2R01CenlYNVBndnN5VDQrczdz?=
 =?utf-8?B?Q0EwY0ZFQnpBeENrU2dYbXE4aW1NK3ZLdmpJbkQ0eDZCQVJrZ0lqdVd1WGFT?=
 =?utf-8?B?SnBSMXdscHBPMWlKSnFlMFovYmZWZktTazRNY3pKVTBiODc2eVV3cXlCMFEy?=
 =?utf-8?B?bWZYREVGc0x1YURYbWFZRFE4dnpEREE0VEpjQW1JaE4yVVJOWUIvUmMzSVpj?=
 =?utf-8?B?bWpzVVJvNk4xeDdPcGEzTXlpclBKaWdGSzFSbzEvVzNSaThwUTFHdDgrRVZD?=
 =?utf-8?B?d0lQeU5UdFUvS0h4eHJaNS9zL3VpRlRIZmpuRm1jMVU0NTl3S25tWVlMek1V?=
 =?utf-8?B?RHFOVE4vRytZcVQ1ci8zUURtajIxeG5ZUTlEZXBabFU0WVJlaXU0S0hBa2hT?=
 =?utf-8?B?V2lyMHFlS1EwdVc1SmVmQkZaWTc4WjNIR01XY1liZUd4YzVrRW1Xdmtjd29G?=
 =?utf-8?B?KzhtaFZSMXMwWGVUZUVybGJqK0Zaa1BkSGxBVlB0UXVBWjR4dnRuV3hNZXZs?=
 =?utf-8?B?Z0VENzdYMyt0QWpyVGZnSS9LTjBTWWpaL1pOVTJTajBvMDdkNDUwdG1TUHVQ?=
 =?utf-8?B?RnR6REdaSkd5SER5azliV1hKb3NjN3Y0Vk0yODM1Mkx6b1B5a2kyeXBnL3BW?=
 =?utf-8?B?MFd0UGtZQkdYaUhvQXk5Zml3L1JSVVhEa1YwVjRSUkxQS3RjSXM1SURBSWJT?=
 =?utf-8?B?K3d4dThxRTJpaFcxcWRvY3RXYTlZcWN6TkFXSXRXMm92a3RXbHpjaEtGbU8y?=
 =?utf-8?B?S3BFRURZUXFDU3MyUkU5bXplMWZWQzE5VXQ1YW1UQUVOTTNwWXBBVVNnMGkw?=
 =?utf-8?B?VHk1TGF6SGFGZy9Oc250K2gyemVKeERjQ2g4MkZYbCtPRStFbGk1L01HUFRu?=
 =?utf-8?B?OElqNjRHbmhVZlRvbXg3aFozekI1OC9ya0s2L0RNUklmSS94RUFUZWR6VzR6?=
 =?utf-8?B?WHVwZmd2SWF6WDBnTTlqU1IyUEtYYnZSbGx1ZU5uRENTMklVQlhNQWRpUVRO?=
 =?utf-8?B?Rmxpbjg1SnpTSzIzeFFrTkVrT2NpRGcyUEI4QTlRd3JXNTV4cTM0ZlNlSy9T?=
 =?utf-8?B?cUZGYU4zSnZ4UHBKVXNPaXRQblNaOUF2OXUxWklzRU5XVDNZMk4yQzNtRTQ0?=
 =?utf-8?B?RkJnQlhzNmtYSm9QL3luMUtDYURXUnV2T1MrS2NjS0RnWUpxYno4L1NIYldj?=
 =?utf-8?B?MnBSNW5KS3NzT0JIaVVCZXJsU1VHYk5OU2VOZThpZkVRNTQzU3ZwY1c5TmlP?=
 =?utf-8?B?ZWxMaFZ5WnY5czJqbm1BSzVWVEwwcjRYS2RMSUpiRkVzRk5hSmhldDRqYi8y?=
 =?utf-8?B?YmxWN2VYR3A4ZkhIK2dRcWRoOXU4a0YvU3VuTnI3QW03OVNoMDIybTN4L0NY?=
 =?utf-8?B?RFdzejk3aHlaVHdnaEM0TUtDMWc2bjNQN3RYeUh2bG5kTTB2Q3IxVGRZSytj?=
 =?utf-8?B?MFo0dFNaeThZdzh1QVMybUYzSGV4NkxIYVlKZkJjVlZPdm5OcWNJODdVRmhs?=
 =?utf-8?B?RHQwUnFRRWhYZFUwV01NMCtCckhSTFl5ZC9STU5hdi84SHdYTEtXeEFlSi9s?=
 =?utf-8?B?dDZ4aktBUUxDcTVHMzliTnpuWklDQzlrYW1BZzVFcGJoc2lKdnZ2RTZlODhI?=
 =?utf-8?B?OEdNV2piTkNsQjkvSTI3VXRYcHlCZmRxcE1kNEhRZm5NU25ORU0vWEduTERN?=
 =?utf-8?B?NUdLOHVTdUhjY3hNblRMZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F77FB403BDF58F419374F0C306042D72@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4835.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 129a990b-fa6c-4d66-ff4b-08d8ea5c0754
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2021 22:20:25.3110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VLuU5x4cwwaHTFfkdYGVCT/00i7HFsL5ENKq1WaVbl/ZkYcVag1aeGMGos1u1UKcyUF+LcRbD2jldlJpb4dEbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2096
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTAzLTE4IGF0IDE2OjE1ICswODAwLCBZb25neGluIExpdSB3cm90ZToNCj4g
SW4gaWNlX3N1c3BlbmQoKSwgaWNlX2NsZWFyX2ludGVycnVwdF9zY2hlbWUoKSBpcyBjYWxsZWQs
IGFuZCB0aGVuDQo+IGlycV9mcmVlX2Rlc2NzKCkgd2lsbCBiZSBldmVudHVhbGx5IGNhbGxlZCB0
byBmcmVlIGlycSBhbmQgaXRzDQo+IGRlc2NyaXB0b3IuDQo+IA0KPiBJbiBpY2VfcmVzdW1lKCks
IGljZV9pbml0X2ludGVycnVwdF9zY2hlbWUoKSBpcyBjYWxsZWQgdG8gYWxsb2NhdGUNCj4gbmV3
IGlycXMuDQo+IEhvd2V2ZXIsIGluIGljZV9yZWJ1aWxkX2FyZnMoKSwgc3RydWN0IGlycV9nbHVl
IGFuZCBzdHJ1Y3QgY3B1X3JtYXANCj4gbWF5YmUNCj4gY2Fubm90IGJlIGZyZWVkLCBpZiB0aGUg
aXJxcyB0aGF0IHJlbGVhc2VkIGluIGljZV9zdXNwZW5kKCkgd2VyZQ0KPiByZWFzc2lnbmVkDQo+
IHRvIG90aGVyIGRldmljZXMsIHdoaWNoIG1ha2VzIGlycSBkZXNjcmlwdG9yJ3MgYWZmaW5pdHlf
bm90aWZ5IGxvc3QuDQo+IA0KPiBTbyBtb3ZlIGljZV9yZW1vdmVfYXJmcygpIGJlZm9yZSBpY2Vf
Y2xlYXJfaW50ZXJydXB0X3NjaGVtZSgpLCB3aGljaA0KPiBjYW4NCj4gbWFrZSBzdXJlIGFsbCBp
cnFfZ2x1ZSBhbmQgY3B1X3JtYXAgY2FuIGJlIGNvcnJlY3RseSByZWxlYXNlZCBiZWZvcmUNCj4g
Y29ycmVzcG9uZGluZyBpcnEgYW5kIGRlc2NyaXB0b3IgYXJlIHJlbGVhc2VkLg0KPiANCj4gRml4
IHRoZSBmb2xsb3dpbmcgbWVtZW9yeSBsZWFrLg0KDQpzL21lbWVvcnkvbWVtb3J5DQoNCjxzbmlw
Pg0KDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2Fy
ZnMuYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfYXJmcy5jDQo+IGlu
ZGV4IDY1NjBhY2Q3NmM5NC4uYzc0OGQwYTVjN2Q0IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2FyZnMuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9pbnRlbC9pY2UvaWNlX2FyZnMuYw0KPiBAQCAtNjU0LDcgKzY1NCw2IEBAIHZvaWQgaWNl
X3JlYnVpbGRfYXJmcyhzdHJ1Y3QgaWNlX3BmICpwZikNCj4gIAlpZiAoIXBmX3ZzaSkNCj4gIAkJ
cmV0dXJuOw0KPiAgDQo+IC0JaWNlX3JlbW92ZV9hcmZzKHBmKTsNCg0KVGhpcyBzaG91bGQgbm90
IGJlIHJlbW92ZWQuIFJlbW92aW5nIHRoaXMgd291bGQgYnJlYWsgdGhlDQpyZXNldCBmbG93cyBv
dXRzaWRlIG9mIHRoZSBzdXNwZW5kL3JlbW92ZSBjYXNlLg0KDQo+ICAJaWYgKGljZV9zZXRfY3B1
X3J4X3JtYXAocGZfdnNpKSkgew0KPiAgCQlkZXZfZXJyKGljZV9wZl90b19kZXYocGYpLCAiRmFp
bGVkIHRvIHJlYnVpbGQgYVJGU1xuIik7DQo+ICAJCXJldHVybjsNCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfbWFpbi5jDQo+IGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9tYWluLmMNCj4gaW5kZXggMmMyM2M4ZjQ2OGE1Li5kYmE5
MDFiZjJiOWIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9p
Y2VfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfbWFp
bi5jDQo+IEBAIC00NTY4LDYgKzQ1NjgsOSBAQCBzdGF0aWMgaW50IF9fbWF5YmVfdW51c2VkIGlj
ZV9zdXNwZW5kKHN0cnVjdA0KPiBkZXZpY2UgKmRldikNCj4gIAkJCWNvbnRpbnVlOw0KPiAgCQlp
Y2VfdnNpX2ZyZWVfcV92ZWN0b3JzKHBmLT52c2lbdl0pOw0KPiAgCX0NCj4gKwlpZiAodGVzdF9i
aXQoSUNFX0ZMQUdfRkRfRU5BLCBwZi0+ZmxhZ3MpKSB7DQo+ICsJCWljZV9yZW1vdmVfYXJmcyhw
Zik7DQo+ICsJfQ0KDQpCcmFjZXMgYXJlbid0IG5lZWRlZCBhcm91bmQgYSBzaW5nbGUgaWYgc3Rh
dGVtZW50IGxpa2UgdGhpcy4NCg0KQWxzbywgSSBkb24ndCB0aGluayB0aGlzIGlzIHRoZSByaWdo
dCBzb2x1dGlvbi4gSSB0aGluayBhIGJldHRlcg0KYXBwcm9hY2ggd291bGQgYmUgdG8gY2FsbCBp
Y2VfZnJlZV9yeF9jcHVfbWFwKCkgaGVyZS4gV2l0aCB0aGlzLA0KaXQgc2VlbXMgbGlrZSBubyBv
dGhlciBjaGFuZ2VzIGFyZSBuZWNlc3NhcnkuIEl0IGFsc28gaXNuJ3QNCm5lY2Vzc2FyeSB0byBj
aGVjayB0aGUgSUNFX0ZMQUdfRkRfRU5BIGJpdCB3aXRoIHRoaXMgY2hhbmdlLg0KDQo+ICAJaWNl
X2NsZWFyX2ludGVycnVwdF9zY2hlbWUocGYpOw0KPiAgDQo+ICAJcGNpX3NhdmVfc3RhdGUocGRl
dik7DQo=
