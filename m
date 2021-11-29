Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D01460C25
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 02:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348181AbhK2BW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 20:22:59 -0500
Received: from mga06.intel.com ([134.134.136.31]:42010 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232518AbhK2BU6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Nov 2021 20:20:58 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10181"; a="296685861"
X-IronPort-AV: E=Sophos;i="5.87,271,1631602800"; 
   d="scan'208";a="296685861"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2021 17:17:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,272,1631602800"; 
   d="scan'208";a="511459783"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga008.jf.intel.com with ESMTP; 28 Nov 2021 17:17:41 -0800
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 28 Nov 2021 17:17:40 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 28 Nov 2021 17:17:40 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Sun, 28 Nov 2021 17:17:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXMQNnqSueHibVGInUySbML15M8UpHvRFzCZcsI/vOn+9iWBTyGqHsSM/l0k5vHlrsrnFODgLefxctI8QTdV8ABgdd3W7RXRshrIO0T1bcRDvGtMi/M1kksVEDCDHziFwXGf6ANkhLyoawaX7MKHnN0KAMF4HzmXbkltkDo1eBD8EKhUZUf0aVe8odUvFt4BzN/M2YmdlNkjOjwsLnfn9qIKoSDgwbgK/VT9w5Bur+pC1ZbpQBRizgITsWWexWyGJtyz6Li4IGJzRjRf3mUMcSz1bnOLZh3BukSBuFeyvoF9I+minYaIS3Rz/kx1knvRUg06eAA998aQlz9O7/Q00Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8bzesADSJKT2iWrIYy1t/XeL8Fr4IjKTNJsQYP1ejuM=;
 b=N6kO99zNjFoAr7aSYK+p0PlK4U+AXQuX2xF73vSCOuuCQS73IRYaGFDLgCcWdp8sfuZ8xQCaMFm+bYfwCAhOtIftxpA4BiNh6visgf4C0eO1B+LqMzylLov+yHyvkG3AieF9MOlkQKxHjN3OAXuf7B9Q5i6fI5sKO6qGW73GFM3oqgvRTXigOZB7Fxof2XJkCcs8klwlLZWna80Fw/INUF9mYRyPb1oIiukEXBzdelEY2PYXRX/FXpS1LyOUFovtCRzAZVaysdDUUgFVCijNeiUEejvdmZRh3AhzWOKh2wAVZk6R11dXK3LgSdl09S+E+EF32GBdAhWdiuiAIs12zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8bzesADSJKT2iWrIYy1t/XeL8Fr4IjKTNJsQYP1ejuM=;
 b=EyeJ2qRbZo456hVzfct9SUjIIUJv/nqNQ1kxh/KdOKNvvfV84C6iWqMqxJZjGS5xy+a0thr9UFTfp+wdTW1ZJP1i96Yv0bptRP3Zyv0HacxZvEB8mNiYn+IPH2XDSJy/o18TtOel6+QCsbJqqL8eNwYcIMnANCmRNKI7BDtBGRs=
Received: from DM6PR11MB2780.namprd11.prod.outlook.com (2603:10b6:5:c8::19) by
 DM6PR11MB3001.namprd11.prod.outlook.com (2603:10b6:5:6e::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.27; Mon, 29 Nov 2021 01:17:39 +0000
Received: from DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::64ad:1bc9:2539:3165]) by DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::64ad:1bc9:2539:3165%7]) with mapi id 15.20.4734.023; Mon, 29 Nov 2021
 01:17:39 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "brouer@redhat.com" <brouer@redhat.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Jonathan Lemon" <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Subject: RE: [PATCH bpf-next 4/4] samples/bpf: xdpsock: add time-out for
 cleaning Tx
Thread-Topic: [PATCH bpf-next 4/4] samples/bpf: xdpsock: add time-out for
 cleaning Tx
Thread-Index: AQHX4RSkHhP1XGzjyEK8ljdRfYznu6wXJcAAgAKVPZA=
Date:   Mon, 29 Nov 2021 01:17:39 +0000
Message-ID: <DM6PR11MB27809F465A151FEAEC701DC2CA669@DM6PR11MB2780.namprd11.prod.outlook.com>
References: <20211124091821.3916046-1-boon.leong.ong@intel.com>
 <20211124091821.3916046-5-boon.leong.ong@intel.com>
 <80cf7ceb-b28a-0f8d-14f8-4b31eb06d6b2@redhat.com>
In-Reply-To: <80cf7ceb-b28a-0f8d-14f8-4b31eb06d6b2@redhat.com>
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
x-ms-office365-filtering-correlation-id: 66988a74-90f5-4b28-6cea-08d9b2d60941
x-ms-traffictypediagnostic: DM6PR11MB3001:
x-microsoft-antispam-prvs: <DM6PR11MB30014A3A84E9F5895F968FC7CA669@DM6PR11MB3001.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zJjs6MOabLIeCqoAisyGoVVG9BLFBey+xfTB5UMWOsmO3MVe1r6cD8wgTpoopr1qi1q77sm4QaMtKA/rNH38Gq1xdxoaf6ecTT4XtP5J9ciUZC0Sz3BKnR7jpqyUU18WbqmpvaFl1LmBYDOwniQtd2h7ChSh6Kirj0Vq3tZ/3EvU/zAXABa/EwHlAKFN1KvaVtoPBQ8QG6IU3Yk3sIZss/oUU58e04lQ6Q0ps8XXHUEjmPis//TTWLeTAiEvpHYPN1XSYYMZTvrwE+D51hNfSGDpQDtH20uJuA8qz4dzwFA4fWdXmK1t04C5IPv1GpBO4Bf2LUFgX31QkK9izfuKLZOfUNm4uw8Qg8Blu2fM5JOs3Hap5SpYH+e311tMHmJXdw3f7Y83VUi+Uhd8jOwPZemnLSkoSAGAdlYF5nrKz/bVIBx2tYPkzkDu85wrM7V/0CMx1UdofwgQbJwsXxCjGeIf6dCEyLNj++lmDKTLQp3o1hyLX53j7Xg7oYMl/6HdG2RYs/vqsEWgfFMvwBda9ewVSqPvw1XjxXk2zB6EPsbr5iPJKO2NBnLU8oJCriBPKRmZpNnnIshUmdV195X+9Exj0E4SWzj/hPvP+IVUK5A4rS+rLy6Z/7JxUfy4HDpmWVmOI2tIfolEVz3yfU9mFZ7ZHHg9d7cgubLatSMW6LhKlCzMrLMOexJTZZfOsqw38hYKkLCAj2eX7skXiZHxMsRUjsEYLymtdmw4RKSkJZM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(508600001)(6506007)(33656002)(38100700002)(316002)(38070700005)(2906002)(7696005)(8936002)(7416002)(54906003)(110136005)(82960400001)(66446008)(66946007)(66476007)(64756008)(66556008)(122000001)(55016003)(4744005)(9686003)(5660300002)(8676002)(76116006)(71200400001)(52536014)(86362001)(4326008)(186003)(309714004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWFpaW5oSHBtT1VidDlCcFZGb1N5OTlHbnBLV2o5dG41amV0YUdqaEhGM056?=
 =?utf-8?B?NlhiTllUeVBOWlR2dmpEdzlyUU1xWTRKcWNJeXljb2h0aGxxbXFPaDhFUlNK?=
 =?utf-8?B?aVdxNStRcVU1REJjWWwzNkZJMGpnMHNYQmJqeVJkSmExVzI3WVV3OFR0TUY3?=
 =?utf-8?B?SThMNmZNQVJMWjEzOHV5UE9mQ0x5c2FZbzJZZUdGUXY0YUs1UUxpV2tuWnVT?=
 =?utf-8?B?S2pVSUQvUndpWGFZcWtnWVlJN1NoRjJweFZPQVZYdUNXUDVReHV2ZjVwZ0ZI?=
 =?utf-8?B?RURocUU3MUk3TWIwUTd3a3RDUEM4ajlXbVk3TWlhcWtQT2ozOVVrT24vM2pl?=
 =?utf-8?B?Z1V3dWo4MGxSY210dndjUmtxY0RMcUZVYW9oUEcvVTJkaUY0Q0N5bkh2eW96?=
 =?utf-8?B?bmRyVFU5Q1pOdGJ1ellOWnhQdnh6ZWJ1Q04wZWxrUlJ1Q09RQnl3Rmp1S0sx?=
 =?utf-8?B?NXBPYldRakpsMkJLWkRLSmxrOGtIVGZLMHU2L0JSSGRFMVMyVnFCd3I0OWM4?=
 =?utf-8?B?dm94blF3TEZNTm5IUXo1ZWNDSXkxcE5DZGgrZHZHMlRWTGJldlA2VHliNVJs?=
 =?utf-8?B?cC92QTRMbzIzRmVqR1ZWd3kra1VOV0YyVHJpNGdPWTVVK3lFRTB5czdhMjNV?=
 =?utf-8?B?cHd6NXBPaFJ3N0ZhUGk0UGJLODhZT1FMQ1ZnM1Z2WG1JeDRSNm8rQXdRWDkz?=
 =?utf-8?B?K01wVm5tMlFWdjJIQzRkNk11YThObjFNdFVESDlDQkM2RWdVSU9FWjZuOTZL?=
 =?utf-8?B?cjZkdU5mU2o3RjlTaktMTHpReVd3Q05CcEg4RUUyazdPRGVlSUJzdTQzNWIw?=
 =?utf-8?B?Y3lxenRtUzZXSWJtc3BqODNQeU9NbndUQkdjM0t1M1B6MDNWQy9jU3ZnRklN?=
 =?utf-8?B?QWhRK0VEb0tDVnBMQ2YwVGJRM3dRM0FKbUdxK3gveVMzV2t6ZlRrQVNnOHpp?=
 =?utf-8?B?NUVzTFlFZlA2UmVKK2JaTlFvSHpkckZDV0dOUUVlb21TSVc1clk3eGdBRkZw?=
 =?utf-8?B?RW04VUFIZE1tUWdheW13MDRIbXprdHZmbjRDN1h6b0pGL3k1dTk2Q0lkeU8x?=
 =?utf-8?B?eTNTQTRnSzdNZ1YyOG0yQ3lrM0RTK2xpdUZ6aDI0Q3hMZVdCanZ1R0tVWGpC?=
 =?utf-8?B?aG5wVFZHWmRGcG9EVXdwckkyVzBpZ2o4bEl1YzBuODZabzhBdkU4c0tFSjAz?=
 =?utf-8?B?SWFXdXZlQXFMODBUNWdYSnZBOE1TTWpvd1pHTWNuakxrcUJKelpIaEsrN1B1?=
 =?utf-8?B?RGM4VXJIdVNDTlJWOGZGK20rV2Fqekw5NStWajZFZ1k3UjJUREs1WW5KSWVT?=
 =?utf-8?B?UjZRUWxPZ3dHUXB4dUhScWcvYm4vSzV0aGRnRi83STVyVlFNK0NKdlFDTVIw?=
 =?utf-8?B?NjlITW1wUTdxbGFuT3htdWI2TkFVbjZnaVFRbUdpakRJY0djMmVXdFNEZDR2?=
 =?utf-8?B?czd2Yk1MMUEwR05IeFlsUjFodExhTVFpdWxFRWYyU3pvdEprbjhDejROenZL?=
 =?utf-8?B?cjRUbUhveGhBNFd2R096OVRTWlpWeFJJUHR3N01RS1N3SW1od3c4Zm5PQWJ5?=
 =?utf-8?B?TVYxUzRhNlExaWxWQWNrRjRWRGdRU3ZVeHk5aWN2QTRvdTkzaG9jVStTcjkr?=
 =?utf-8?B?bmJIN3k4NTNndW1xSXNFU3ZxZnpSSGNtUFA0VitpRFA4ZTU4VFQ4ZWJiT2li?=
 =?utf-8?B?RmFtQmd4ZURzWk5mbGZ6bWNVVko0VUwydWlrK0hGS0ZNQ1RtcUxBeGFsemZi?=
 =?utf-8?B?ai9RakFIOXJTenkzRmdjK09aWlRrQndBdUp5a1kxcU4wS1NzWCtLQkhldURm?=
 =?utf-8?B?TkI0dERLaFZHcUI5dVNxVXZlZG5jY1M5N1RRSDJvUXZpcXpJQUV3WHF5UERE?=
 =?utf-8?B?YkFaNUlYcHBVeXlnSmNZRStOaUpyclFEOWpNVTFTd3BBelFtMEQwbEp4cUpX?=
 =?utf-8?B?NmlreStsQVNnZjA3Zm1XMWlpb3BqVjRJbzg4aStCdUE4NFhDTllWOW5JSmVO?=
 =?utf-8?B?V1kwdk8vRDIvN2V2MHpDWjh5SlYyLzFvcXhBYTlKbER3OEs2OTdINGxKOFZt?=
 =?utf-8?B?Ym9xTm1zYzVOSjlrTmNjVzJUbnF5YmJXbC9yaUxtV3RNdHRpOEh3OHhEY20w?=
 =?utf-8?B?QVhhWjlWdDIvOHZDOXhJbHpWSlJxZVNaS1BjQ1pSUm4yWlREWjdVS2tJRXBP?=
 =?utf-8?B?RVFMc0tEeHY5ZUpIWVBmVnFES25pWUZ4OVU5Y0JDY1Erd2xZcWZ3a2sxQjQ2?=
 =?utf-8?B?OHRwem41Tm15aGowLzF2c2JWTFRnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66988a74-90f5-4b28-6cea-08d9b2d60941
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 01:17:39.6914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D6wii6z5CFfTi+Esiw8/RQim0mlqOHI0DjRfAbCElgjaasNeHizl/60eH0mYoNhSVnh+gr4F/GBYZHKgJpKUxhPcwZTWzC1PVFm/jSdqcm4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3001
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pj4gICBzdGF0aWMgdm9pZCBjb21wbGV0ZV90eF9vbmx5X2FsbCh2b2lkKQ0KPj4gICB7DQo+PiAr
CXUzMiByZXRyaWVzID0gMzsNCj4+ICAgCWJvb2wgcGVuZGluZzsNCj4+ICAgCWludCBpOw0KPj4N
Cj4+IEBAIC0xNDIxLDcgKzE0MjIsOCBAQCBzdGF0aWMgdm9pZCBjb21wbGV0ZV90eF9vbmx5X2Fs
bCh2b2lkKQ0KPj4gICAJCQkJcGVuZGluZyA9ICEheHNrc1tpXS0+b3V0c3RhbmRpbmdfdHg7DQo+
PiAgIAkJCX0NCj4+ICAgCQl9DQo+PiAtCX0gd2hpbGUgKHBlbmRpbmcpOw0KPj4gKwkJc2xlZXAo
b3B0X2ludGVydmFsKTsNCj4NCj5XaHkvaG93IGlzIHRoaXMgY29ubmVjdGVkIHdpdGggdGhlICdv
cHRfaW50ZXJ2YWwnID8NCj4NCj4oV2hpY2ggaXMgdXNlZCBieSB0aGUgcHRodHJlYWQgJ3BvbGxl
cicgZHVtcGluZyBzdGF0cykNCj4NClRoZSBvcmlnaW5hbCB0aG91Z2h0IHdhcyB0byB1c2UgdGhl
IHBvbGxlciBpbnRlcnZhbCBzaW5jZQ0KaXQgaXMgd2hhdCB1c2VyIHdvdWxkIGV4cGVyaWVuY2Ug
ZnJvbSB0ZXJtaW5hbC4gSW4gbmV4dCByZXYsDQpJIHBsYW4gdG8gbWFrZSBpdCBjb25maWd1cmFi
bGUgd2l0aCBzZWNvbmQgZ3JhbnVsYXJpdHkgYXMNCnN1Z2dlc3RlZCBieSBTb25nIExpdS4NCg0K
VGhhbmtzDQo=
