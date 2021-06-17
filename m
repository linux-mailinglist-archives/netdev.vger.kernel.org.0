Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567263AB630
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 16:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhFQOmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 10:42:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:55836 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhFQOmS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 10:42:18 -0400
IronPort-SDR: M9aUIVHYFmzf0PYHb2LhXprt+KEuLqM4+i7V+L22Gyb9XkNPEUFoO4D+HUawM8cRNJEQOz3C7Q
 Jm/EUI1wPv4A==
X-IronPort-AV: E=McAfee;i="6200,9189,10017"; a="203357191"
X-IronPort-AV: E=Sophos;i="5.83,280,1616482800"; 
   d="scan'208";a="203357191"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 07:40:10 -0700
IronPort-SDR: 0BWeczipJ3y7UjxuNx5OONRZnXW8HCaqGql4dzKCqDGD/+Dysis33ZWJ/8GvnzbQugdEGdIcIz
 LeKeLkr6TBJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,280,1616482800"; 
   d="scan'208";a="472432271"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga004.fm.intel.com with ESMTP; 17 Jun 2021 07:40:09 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 17 Jun 2021 07:40:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 17 Jun 2021 07:40:08 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Thu, 17 Jun 2021 07:40:08 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 17 Jun 2021 07:40:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khpNndsqaV9Ej8sVMR/yqKN5dnGPwKIhlz8CyiYNdYyNxyaRRCNSxmSmI0vMeY3CrAEjjrwmX+UlstHBl68gZce3m4TOV0zAR+jnR0JXaJA4w/AWQCDqRsaFo2QaAKYxrrwEvRpgjVt7pho8ud9aRAsd5SKEr8QBQDs2i4tR38uvCjMcChDd8g2BVAWJE6SjVz13LXoGrA+dbZ2001IJVy9V5eEBSa7ZNtY2Ql8sIq0a9FUJzzCpQhFmHE9gKFbks6U2CkiVzPwBN7KVrtJQgxk7O4jaJafR7Pyic3P0cMAPY3nSTO/if2DRA/lELSdDswHL7b4DRDPWbYKzkFwdZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jO66h3EFYzV/gN1QiUBSZkfl6gZjdA4cPk4zbfcIDQk=;
 b=GhSiuPS9sH2LNkmiq7ONjVaadIL3jELPcVeCS+AcsHhf+TrD0ATTgP8NXJrPNzeYuoeqqDtmf7wR9UNkA4wKnqOgWfjgH5YudNcDMNX14ZOaUvXSBPqU9o5WYz0Q93Z396APkvsUS3xyBuv/hCRfx0o+3fqS8vq6OYSSyqUZM43Sic39ampahZuTfvHcCUlQpkii8DvIJy8kVXnVHaNV4/RlDDpVFLyd5I4BNIAuOrhHMFTl8E4Ztapnc9NJ3zUsXdmJjGOZSgaGccq+lptnfjadIorK5gWvRsfcO5p5t4VC0fegRtMYVxTNevxIFmgNYXUdds6c2WtimBBH8hXRqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jO66h3EFYzV/gN1QiUBSZkfl6gZjdA4cPk4zbfcIDQk=;
 b=hEEgpH2Hw/bhEPX8z/g1P6hKizOnnEGrl9QJYz9pbyuAuhdcUT2Br5w0l1ddOI2AJOeX7sWn1vHuKmjtRPj7IC+Eef3T8DvSm1D09ZikfS58mbunOGd+8tp8n7m1IRwizvB4YW7Kw4dXw5UbbQAjgZEnwspyNSWwCTcj2fpVpjU=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB2589.namprd11.prod.outlook.com (2603:10b6:805:53::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Thu, 17 Jun
 2021 14:40:06 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::15ab:e6bc:fd6e:2a1]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::15ab:e6bc:fd6e:2a1%5]) with mapi id 15.20.4242.021; Thu, 17 Jun 2021
 14:40:06 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>
CC:     "hawk@kernel.org" <hawk@kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "krzysztof.kazimierczak@intel.com" <krzysztof.kazimierczak@intel.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "maximmi@nvidia.com" <maximmi@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net] xdp, net: fix for construct skb by xdp inside xsk zc
 rx
Thread-Topic: [PATCH net] xdp, net: fix for construct skb by xdp inside xsk zc
 rx
Thread-Index: AQHXYZfOvzh/jyT6d0a7qBgkeeL6G6sYMOkAgAATGYCAAAbngA==
Date:   Thu, 17 Jun 2021 14:40:05 +0000
Message-ID: <7d2c9a96d7f1a77b6eea9cdbbee8dea56b1f287a.camel@intel.com>
References: <1623939489.313177-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1623939489.313177-1-xuanzhuo@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 980a15a2-416f-4401-edb2-08d9319dcca5
x-ms-traffictypediagnostic: SN6PR11MB2589:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB25894888049935D9415FD948C60E9@SN6PR11MB2589.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 03TBE1gHjtvsDSKufF+EdmY3KgGjaMYWylNgEKS7cCA1Atg7oTBNsr47aCnzqv4fnfSsx3rmpekdPvZZajpi919/tQ+ObslAwvFIiX/7YCFXQurih4fMMcKMiy5fE88WI8n4sTag7WhaGYkp4xYiAFmzE1b5Y8mjJr071WkPeg6Jk5iOrP01Z2MC+S1luWH4N4vJX9/WpHtvPZ6DHTLCTwn3H78x4gfER2zbVRsgtlef0PXb6jQlGwbGQTkCnKY3vpODFdQFnVsFo8Udzl0RKiyv6Yt94WFK/Vw5w9g3kdGPwT2dbyc0aO5LfY/Fczo3KjKV/FBqde6HpFSmvbGCseXrnYRoig8BUtpxvJnGGHRzWkahQnNMg3uJjiTlrFW2vZ55r6jqKVJ41SahxF6TNz4pMmk6kMAjDOKS6l2z6S+j65DN4w5BwqmNSqiIhDvvj2FuTbZkhG+dPkOcGZbv8WmdJn90k/jmGxNebMoXhfHpvsSgP32+BgslLM9mqbHbJhYZZX/xp8wWSRwF+g04LTlyunOfR7Nb2rVfIKAgBiPqraiPenGqgw1gNIpo36MVGKNKjRjWf3U6+sQqN0bbt0oakjg8r7TesZM39ThToxV1LbWMD0ijrfFB7R4lBkU89rt1HOMoI3mGVVMH/iDyRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(136003)(376002)(396003)(54906003)(5660300002)(186003)(478600001)(91956017)(316002)(38100700002)(122000001)(26005)(66946007)(66476007)(66556008)(64756008)(66446008)(110136005)(76116006)(8676002)(7416002)(8936002)(6506007)(6512007)(6486002)(2906002)(2616005)(4326008)(86362001)(71200400001)(36756003)(83380400001)(83323001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2FPSGZwRU9iZFlnaTFsUVhVSnQvQmwxUzF5R1A2KzJ4L0xneDczK01OdzJi?=
 =?utf-8?B?SnB2Y3NWZE14MmxHQkdiaUZpRDN1WFprQVk1ei9TVk9sNVIxaHRzN1FIVW1t?=
 =?utf-8?B?RVVRWFkrajBOV3BPdWNZQk5FS2tRdGJhckZRNDBib1RuUGQrcXM3UUhiU2JD?=
 =?utf-8?B?anRJVFFaZEh5MTdFK1hVZ1NOY0p6eVBRVEc4eElBOEdpbE1iL3l2UUdDeGVI?=
 =?utf-8?B?UllDODVmem5YcnJpY1ZDbmdIdmFKTGMyZWRuRytVL280N3I0NkVKblNxalky?=
 =?utf-8?B?aFdaU21zR3lzbEZBbXJjcDE0b3oreFFodnYvVmVOSmwvR20yNGkzc0phcm9B?=
 =?utf-8?B?UEVYVStFQ1dQZ0R4NHptNk5rd05RLzU2elVEamQ3NEJ1YkNVMTk1QzFqejZE?=
 =?utf-8?B?TDJvMTM4ZUh1bmVtenR0ZkVCeE1idHVJRllvWnhnY21QZ2tHTWRLSDkwV2tN?=
 =?utf-8?B?cWorRU1mNWQ3V2RmUkRBdGRlM0RhU2hBeTg5YTJ1cXFyTEJxOG5HZXRhSU1v?=
 =?utf-8?B?NWVwTjBRZDhEWTVEekUzN1doWlZCT3BLMEhranNib21DZExFWHpVQW83ODVE?=
 =?utf-8?B?QWN0SWJKYUNKWDJCS0E5M3B3OEZSZGxId2xTYTlSd3ovUzhkV1Z4Skk3dEFR?=
 =?utf-8?B?VCtHbWtHY1VrM2xMN29maHdDV0w3VnkvUUxMM2VZVVZ1MEJpbzRvSnNzRDg1?=
 =?utf-8?B?TGwvRUM0TTVtUlloS3ZobFhTL1dTNW81Y3R6SkhzNVExaDFhQm85QXFBZmZ1?=
 =?utf-8?B?L05adGpyYmlsT1I5RDFIaUpSUUxpWUpmWVVYU1FldG5MRy9uZUt0RmZ5L2pK?=
 =?utf-8?B?Y1BJSFFYcWxqOCtSY0xRNCtNUWh5YVdVY2JGc3BxeWt2Q2R6ZUY5ZXRUcXQw?=
 =?utf-8?B?Z0w4bTN3MGlGYjFiRkpNOU13YnRnMmY4Z1Z5MTNwNnJXLzZJbURBTUNmczVQ?=
 =?utf-8?B?K0gxSHZCV3lxdzl5RTlzcG9DeFc3RUt3cHE5amVlUjh5MEp3d0EwbStMOUov?=
 =?utf-8?B?TkZaK3UwaWtUdnJwOE0yajQ4VjlDWDVsanlkTlVkbkt5Mis2TTd0TUpXcnR5?=
 =?utf-8?B?bVlaeG9idVp1MXhYc1ZUVWtiYXgxTHRITDdTWkRMOVBnNXRreEJ4RFg3NW5Q?=
 =?utf-8?B?YTJoSzdQZnFrVTJ6WmJSKzA3RjB1RW80NGhDMVpLQ1pVMnNya3RRQlFwQ0pS?=
 =?utf-8?B?UisvQmxkdXlVUk9ZOUcycUlSKzcwUU9VSmRyQUtUdEMrSFdQRVB6ZXphdWRC?=
 =?utf-8?B?bU1pY2F6bDFmclc2TVpINkY5emJvQXN2MHhNWGZLNnVzNE1kTXdrL0xVT1B0?=
 =?utf-8?B?YVFVWFZkMDFCdUJ6Q2oxN3RnZThFbnJkLzBBWVJBT0w1OStWT3JtUTdrTk5i?=
 =?utf-8?B?OFVza3UvQVM4SVB1V0VJMzA3dkhudjhFR2I0YWx6SUE4MithaWZqdjhYbWcy?=
 =?utf-8?B?RzNXUDVsMXp3Uk1HclR1dnNId3FFcTcrcVBVRnI5NEc3R0Z4NUU3UlFKeG1y?=
 =?utf-8?B?VkYzbS8vUU9mR1FXK3F3NWtkTkMyUVh4QjJTYmxLV1RrZEo4YmNLbVlIUXZO?=
 =?utf-8?B?VERFejIxditlLy9lT2Yvb0NUYlZFR1B4aTN1OUNnVXNOcHlnM2ZRZkVlbGZQ?=
 =?utf-8?B?MmVnVUNVOXpOSVJ4TC9KRmJtMFYzQStBSjdKZVRXV2NzYlRUYlp6S1JSZFpQ?=
 =?utf-8?B?RnIrMmk5aVBRTHZKN0JiTHRQcDA3cjJHS0hoejVyVXoydU1PenNSc09QQzZx?=
 =?utf-8?B?SHllb2drY1NiRXFKejM5L0pKREo3ZUxTeEg2TEg1aUpvMkNVYUNPOHJ4eVlH?=
 =?utf-8?B?ZzJnZFBhK1BqMG5uTXhMUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A734CEC578DB164CA25C51355736BB88@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 980a15a2-416f-4401-edb2-08d9319dcca5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2021 14:40:05.9260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ObLVd/3jkdAsKiQhNuAhiBym+ERcacDcYr3J9RPYbtXL6hIkLWLDHjw8/oHxxWBTHVYx5BFunb/J96+DMe706UmxLXlLJNSSQIJ1C6K1x9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2589
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTA2LTE3IGF0IDIyOjE4ICswODAwLCBYdWFuIFpodW8gd3JvdGU6DQo+IE9u
IFRodSwgMTcgSnVuIDIwMjEgMTU6MDk6NDggKzAyMDAsIE1hY2llaiBGaWphbGtvd3NraSA8DQo+
IG1hY2llai5maWphbGtvd3NraUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IE9uIFR1ZSwgSnVuIDE1
LCAyMDIxIGF0IDExOjM3OjE5QU0gKzA4MDAsIFh1YW4gWmh1byB3cm90ZToNCj4gPiA+IFdoZW4g
ZWFjaCBkcml2ZXIgc3VwcG9ydHMgeHNrIHJ4LCBpZiB0aGUgcmVjZWl2ZWQgYnVmZiByZXR1cm5z
DQo+ID4gPiBYRFBfUEFTUw0KPiA+ID4gYWZ0ZXIgcnVuIHhkcCBwcm9nLCBpdCBtdXN0IGNvbnN0
cnVjdCBza2IgYmFzZWQgb24geGRwLiBUaGlzDQo+ID4gPiBwYXRjaA0KPiA+ID4gZXh0cmFjdHMg
dGhpcyBsb2dpYyBpbnRvIGEgcHVibGljIGZ1bmN0aW9uIHhkcF9jb25zdHJ1Y3Rfc2tiKCkuDQo+
ID4gPiANCj4gPiA+IFRoZXJlIGlzIGEgYnVnIGluIHRoZSBvcmlnaW5hbCBsb2dpYy4gV2hlbiBj
b25zdHJ1Y3Rpbmcgc2tiLCB3ZQ0KPiA+ID4gc2hvdWxkDQo+ID4gPiBjb3B5IHRoZSBtZXRhIGlu
Zm9ybWF0aW9uIHRvIHNrYiBhbmQgdGhlbiB1c2UgX19za2JfcHVsbCgpIHRvDQo+ID4gPiBjb3Jy
ZWN0DQo+ID4gPiB0aGUgZGF0YS4NCj4gPiA+IA0KPiA+ID4gRml4ZXM6IDBhNzE0MTg2ZDNjMGYg
KCJpNDBlOiBhZGQgQUZfWERQIHplcm8tY29weSBSeCBzdXBwb3J0IikNCj4gPiA+IEZpeGVzOiAy
ZDQyMzhmNTU2OTcyICgiaWNlOiBBZGQgc3VwcG9ydCBmb3IgQUZfWERQIikNCj4gPiA+IEZpeGVz
OiBiYmEyNTU2ZWZhZDY2ICgibmV0OiBzdG1tYWM6IEVuYWJsZSBSWCB2aWEgQUZfWERQIHplcm8t
DQo+ID4gPiBjb3B5IikNCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFh1YW4gWmh1byA8eHVhbnpodW9A
bGludXguYWxpYmFiYS5jb20+DQo+ID4gPiAtLS0NCj4gPiA+IA0KPiA+ID4gVGhpcyBwYXRjaCBk
ZXBlbmRzIG9uIHRoZSBwcmV2aW91cyBwYXRjaDoNCj4gPiA+ICAgICBbUEFUQ0ggbmV0XSBpeGdi
ZTogeHNrOiBmaXggZm9yIG1ldGFzaXplIHdoZW4gY29uc3RydWN0IHNrYg0KPiA+ID4gYnkgeGRw
X2J1ZmYNCj4gPiANCj4gPiBUaGF0IGRvZXNuJ3QgbWFrZSBtdWNoIHNlbnNlIGlmIHlvdSBhc2sg
bWUsIEknZCByYXRoZXIgc3F1YXNoIHRoZQ0KPiA+IHBhdGNoDQo+ID4gbWVudGlvbmVkIGFib3Zl
IHRvIHRoaXMgb25lLg0KPiANCj4gSSBzYXcgdGhhdCB0aGUgcHJldmlvdXMgcGF0Y2ggd2FzIHB1
dCBpbnRvIG5ldC1xdWV1ZSwgSSBkb24ndCBrbm93DQo+IHdoZXRoZXIgdG8NCj4gbWVyZ2UgaXQg
aW50byB0aGUgY3VycmVudCBwYXRjaCwgc28gSSBwb3N0ZWQgdGhpcyBwYXRjaCwgSSBob3BlDQo+
IHNvbWVvbmUgY2FuIHRlbGwNCj4gbWUgaG93IHRvIGRlYWwgd2l0aCB0aGlzIHNpdHVhdGlvbi4N
Cg0KVGhlIHByZXZpb3VzIHBhdGNoIHdhcyB0byB0aGUgSW50ZWwgV2lyZWQgTEFOIHRyZWUgc2lu
Y2UgaXQgd2FzIGp1c3QNCml4Z2JlIGRyaXZlci4gSSB3aWxsIGRyb3AgdGhpcyBmcm9tIEludGVs
IFdpcmVkIExBTiB0cmVlIHNpbmNlIGl0DQpoYXNuJ3QgYmVlbiBzdWJtaXR0ZWQgdG8gbmV0ZGV2
IGFuZCB3aXRoIHRoZXNlIGNoYW5nZXMgaXQgbWFrZXMgbW9yZQ0Kc2Vuc2UgYXMgYSBzaW5nbGUg
c3F1YXNoZWQgcGF0Y2guDQoNCj4gPiBBbHNvLCBJIHdhbnRlZCB0byBpbnRyb2R1Y2Ugc3VjaCBm
dW5jdGlvbiB0byB0aGUga2VybmVsIGZvciBhIGxvbmcNCj4gPiB0aW1lDQo+ID4gYnV0IEkgYWx3
YXlzIGhlYWQgaW4gdGhlIGJhY2sgb2YgbXkgaGVhZCBtbHg1J3MgQUZfWERQIFpDDQo+ID4gaW1w
bGVtZW50YXRpb24NCj4gPiB3aGljaCBJJ20gbm90IHN1cmUgaWYgaXQgY2FuIGFkanVzdCB0byBz
b21ldGhpbmcgbGlrZSBJbnRlbCBkcml2ZXJzDQo+ID4gYXJlDQo+ID4gZG9pbmcuDQo+IA0KPiBJ
IGhhdmUgdGhpcyBxdWVzdGlvbiB0b28uDQo+IA0KPiBUaGFua3MNCj4gDQo+ID4gTWF4aW0/IDop
DQo+ID4gDQo+ID4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX3hzay5j
ICAgIHwgMTYgKy0tLS0tLS0tLQ0KPiA+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lj
ZS9pY2VfeHNrLmMgICAgICB8IDEyICstLS0tLS0tDQo+ID4gPiAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvaXhnYmUvaXhnYmVfeHNrLmMgIHwgMTQgKy0tLS0tLS0tDQo+ID4gPiAgLi4uL25l
dC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jIHwgMjMgKy0tLS0tLS0tLS0N
Cj4gPiA+IC0tLQ0KPiA+ID4gIGluY2x1ZGUvbmV0L3hkcC5oICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB8IDMwDQo+ID4gPiArKysrKysrKysrKysrKysrKysrDQo+ID4gPiAgNSBmaWxlcyBj
aGFuZ2VkLCAzNCBpbnNlcnRpb25zKCspLCA2MSBkZWxldGlvbnMoLSkNCj4gPiA+IA0KPiA+ID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV94c2suYw0K
PiA+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfeHNrLmMNCj4gPiA+
IGluZGV4IDY4ZjE3N2E4NjQwMy4uODFiMGY0NGVlZGRhIDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX3hzay5jDQo+ID4gPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfeHNrLmMNCj4gPiA+IEBAIC0yNDYsMjMg
KzI0Niw5IEBAIGJvb2wgaTQwZV9hbGxvY19yeF9idWZmZXJzX3pjKHN0cnVjdA0KPiA+ID4gaTQw
ZV9yaW5nICpyeF9yaW5nLCB1MTYgY291bnQpDQo+ID4gPiAgc3RhdGljIHN0cnVjdCBza19idWZm
ICppNDBlX2NvbnN0cnVjdF9za2JfemMoc3RydWN0IGk0MGVfcmluZw0KPiA+ID4gKnJ4X3Jpbmcs
DQo+ID4gPiAgCQkJCQkgICAgIHN0cnVjdCB4ZHBfYnVmZiAqeGRwKQ0KPiA+ID4gIHsNCj4gPiA+
IC0JdW5zaWduZWQgaW50IG1ldGFzaXplID0geGRwLT5kYXRhIC0geGRwLT5kYXRhX21ldGE7DQo+
ID4gPiAtCXVuc2lnbmVkIGludCBkYXRhc2l6ZSA9IHhkcC0+ZGF0YV9lbmQgLSB4ZHAtPmRhdGE7
DQo+ID4gPiAgCXN0cnVjdCBza19idWZmICpza2I7DQo+ID4gPiANCj4gPiA+IC0JLyogYWxsb2Nh
dGUgYSBza2IgdG8gc3RvcmUgdGhlIGZyYWdzICovDQo+ID4gPiAtCXNrYiA9IF9fbmFwaV9hbGxv
Y19za2IoJnJ4X3JpbmctPnFfdmVjdG9yLT5uYXBpLA0KPiA+ID4gLQkJCSAgICAgICB4ZHAtPmRh
dGFfZW5kIC0geGRwLT5kYXRhX2hhcmRfc3RhcnQsDQo+ID4gPiAtCQkJICAgICAgIEdGUF9BVE9N
SUMgfCBfX0dGUF9OT1dBUk4pOw0KPiA+ID4gLQlpZiAodW5saWtlbHkoIXNrYikpDQo+ID4gPiAt
CQlnb3RvIG91dDsNCj4gPiA+IC0NCj4gPiA+IC0Jc2tiX3Jlc2VydmUoc2tiLCB4ZHAtPmRhdGEg
LSB4ZHAtPmRhdGFfaGFyZF9zdGFydCk7DQo+ID4gPiAtCW1lbWNweShfX3NrYl9wdXQoc2tiLCBk
YXRhc2l6ZSksIHhkcC0+ZGF0YSwgZGF0YXNpemUpOw0KPiA+ID4gLQlpZiAobWV0YXNpemUpDQo+
ID4gPiAtCQlza2JfbWV0YWRhdGFfc2V0KHNrYiwgbWV0YXNpemUpOw0KPiA+ID4gLQ0KPiA+ID4g
LW91dDoNCj4gPiA+ICsJc2tiID0geGRwX2NvbnN0cnVjdF9za2IoeGRwLCAmcnhfcmluZy0+cV92
ZWN0b3ItPm5hcGkpOw0KPiA+ID4gIAl4c2tfYnVmZl9mcmVlKHhkcCk7DQo+ID4gPiAgCXJldHVy
biBza2I7DQo+ID4gPiAgfQ0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2ljZS9pY2VfeHNrLmMNCj4gPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
aWNlL2ljZV94c2suYw0KPiA+ID4gaW5kZXggYTFmODllYTNjMmJkLi5mOTVlMWFkY2ViZGEgMTAw
NjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3hzay5j
DQo+ID4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3hzay5jDQo+
ID4gPiBAQCAtNDMwLDIyICs0MzAsMTIgQEAgc3RhdGljIHZvaWQgaWNlX2J1bXBfbnRjKHN0cnVj
dCBpY2VfcmluZw0KPiA+ID4gKnJ4X3JpbmcpDQo+ID4gPiAgc3RhdGljIHN0cnVjdCBza19idWZm
ICoNCj4gPiA+ICBpY2VfY29uc3RydWN0X3NrYl96YyhzdHJ1Y3QgaWNlX3JpbmcgKnJ4X3Jpbmcs
IHN0cnVjdCBpY2VfcnhfYnVmDQo+ID4gPiAqcnhfYnVmKQ0KPiA+ID4gIHsNCj4gPiA+IC0JdW5z
aWduZWQgaW50IG1ldGFzaXplID0gcnhfYnVmLT54ZHAtPmRhdGEgLSByeF9idWYtPnhkcC0NCj4g
PiA+ID5kYXRhX21ldGE7DQo+ID4gPiAtCXVuc2lnbmVkIGludCBkYXRhc2l6ZSA9IHJ4X2J1Zi0+
eGRwLT5kYXRhX2VuZCAtIHJ4X2J1Zi0+eGRwLQ0KPiA+ID4gPmRhdGE7DQo+ID4gPiAtCXVuc2ln
bmVkIGludCBkYXRhc2l6ZV9oYXJkID0gcnhfYnVmLT54ZHAtPmRhdGFfZW5kIC0NCj4gPiA+IC0J
CQkJICAgICByeF9idWYtPnhkcC0+ZGF0YV9oYXJkX3N0YXJ0Ow0KPiA+ID4gIAlzdHJ1Y3Qgc2tf
YnVmZiAqc2tiOw0KPiA+ID4gDQo+ID4gPiAtCXNrYiA9IF9fbmFwaV9hbGxvY19za2IoJnJ4X3Jp
bmctPnFfdmVjdG9yLT5uYXBpLCBkYXRhc2l6ZV9oYXJkLA0KPiA+ID4gLQkJCSAgICAgICBHRlBf
QVRPTUlDIHwgX19HRlBfTk9XQVJOKTsNCj4gPiA+ICsJc2tiID0geGRwX2NvbnN0cnVjdF9za2Io
cnhfYnVmLT54ZHAsICZyeF9yaW5nLT5xX3ZlY3Rvci0+bmFwaSk7DQo+ID4gPiAgCWlmICh1bmxp
a2VseSghc2tiKSkNCj4gPiA+ICAJCXJldHVybiBOVUxMOw0KPiA+ID4gDQo+ID4gPiAtCXNrYl9y
ZXNlcnZlKHNrYiwgcnhfYnVmLT54ZHAtPmRhdGEgLSByeF9idWYtPnhkcC0NCj4gPiA+ID5kYXRh
X2hhcmRfc3RhcnQpOw0KPiA+ID4gLQltZW1jcHkoX19za2JfcHV0KHNrYiwgZGF0YXNpemUpLCBy
eF9idWYtPnhkcC0+ZGF0YSwgZGF0YXNpemUpOw0KPiA+ID4gLQlpZiAobWV0YXNpemUpDQo+ID4g
PiAtCQlza2JfbWV0YWRhdGFfc2V0KHNrYiwgbWV0YXNpemUpOw0KPiA+ID4gLQ0KPiA+ID4gIAl4
c2tfYnVmZl9mcmVlKHJ4X2J1Zi0+eGRwKTsNCj4gPiA+ICAJcnhfYnVmLT54ZHAgPSBOVUxMOw0K
PiA+ID4gIAlyZXR1cm4gc2tiOw0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2l4Z2JlL2l4Z2JlX3hzay5jDQo+ID4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2l4Z2JlL2l4Z2JlX3hzay5jDQo+ID4gPiBpbmRleCBlZTg4MTA3ZmE1N2EuLjEyMzk0
NTgzMmM5NiAxMDA2NDQNCj4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4
Z2JlL2l4Z2JlX3hzay5jDQo+ID4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9p
eGdiZS9peGdiZV94c2suYw0KPiA+ID4gQEAgLTIwMywyNCArMjAzLDEyIEBAIGJvb2wgaXhnYmVf
YWxsb2NfcnhfYnVmZmVyc196YyhzdHJ1Y3QNCj4gPiA+IGl4Z2JlX3JpbmcgKnJ4X3JpbmcsIHUx
NiBjb3VudCkNCj4gPiA+ICBzdGF0aWMgc3RydWN0IHNrX2J1ZmYgKml4Z2JlX2NvbnN0cnVjdF9z
a2JfemMoc3RydWN0IGl4Z2JlX3JpbmcNCj4gPiA+ICpyeF9yaW5nLA0KPiA+ID4gIAkJCQkJICAg
ICAgc3RydWN0IGl4Z2JlX3J4X2J1ZmZlcg0KPiA+ID4gKmJpKQ0KPiA+ID4gIHsNCj4gPiA+IC0J
dW5zaWduZWQgaW50IG1ldGFzaXplID0gYmktPnhkcC0+ZGF0YSAtIGJpLT54ZHAtPmRhdGFfbWV0
YTsNCj4gPiA+IC0JdW5zaWduZWQgaW50IGRhdGFzaXplID0gYmktPnhkcC0+ZGF0YV9lbmQgLSBi
aS0+eGRwLT5kYXRhX21ldGE7DQo+ID4gPiAgCXN0cnVjdCBza19idWZmICpza2I7DQo+ID4gPiAN
Cj4gPiA+IC0JLyogYWxsb2NhdGUgYSBza2IgdG8gc3RvcmUgdGhlIGZyYWdzICovDQo+ID4gPiAt
CXNrYiA9IF9fbmFwaV9hbGxvY19za2IoJnJ4X3JpbmctPnFfdmVjdG9yLT5uYXBpLA0KPiA+ID4g
LQkJCSAgICAgICBiaS0+eGRwLT5kYXRhX2VuZCAtIGJpLT54ZHAtDQo+ID4gPiA+ZGF0YV9oYXJk
X3N0YXJ0LA0KPiA+ID4gLQkJCSAgICAgICBHRlBfQVRPTUlDIHwgX19HRlBfTk9XQVJOKTsNCj4g
PiA+ICsJc2tiID0geGRwX2NvbnN0cnVjdF9za2IoYmktPnhkcCwgJnJ4X3JpbmctPnFfdmVjdG9y
LT5uYXBpKTsNCj4gPiA+ICAJaWYgKHVubGlrZWx5KCFza2IpKQ0KPiA+ID4gIAkJcmV0dXJuIE5V
TEw7DQo+ID4gPiANCj4gPiA+IC0Jc2tiX3Jlc2VydmUoc2tiLCBiaS0+eGRwLT5kYXRhX21ldGEg
LSBiaS0+eGRwLQ0KPiA+ID4gPmRhdGFfaGFyZF9zdGFydCk7DQo+ID4gPiAtCW1lbWNweShfX3Nr
Yl9wdXQoc2tiLCBkYXRhc2l6ZSksIGJpLT54ZHAtPmRhdGFfbWV0YSwgZGF0YXNpemUpOw0KPiA+
ID4gLQlpZiAobWV0YXNpemUpIHsNCj4gPiA+IC0JCV9fc2tiX3B1bGwoc2tiLCBtZXRhc2l6ZSk7
DQo+ID4gPiAtCQlza2JfbWV0YWRhdGFfc2V0KHNrYiwgbWV0YXNpemUpOw0KPiA+ID4gLQl9DQo+
ID4gPiAtDQo+ID4gPiAgCXhza19idWZmX2ZyZWUoYmktPnhkcCk7DQo+ID4gPiAgCWJpLT54ZHAg
PSBOVUxMOw0KPiA+ID4gIAlyZXR1cm4gc2tiOw0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMNCj4gPiA+IGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYw0KPiA+ID4gaW5kZXgg
Yzg3MjAyY2JkM2Q2Li4xNDNhYzFlZGI4NzYgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jDQo+ID4gPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jDQo+ID4gPiBAQCAt
NDcyOSwyNyArNDcyOSw2IEBAIHN0YXRpYyB2b2lkIHN0bW1hY19maW5hbGl6ZV94ZHBfcngoc3Ry
dWN0DQo+ID4gPiBzdG1tYWNfcHJpdiAqcHJpdiwNCj4gPiA+ICAJCXhkcF9kb19mbHVzaCgpOw0K
PiA+ID4gIH0NCj4gPiA+IA0KPiA+ID4gLXN0YXRpYyBzdHJ1Y3Qgc2tfYnVmZiAqc3RtbWFjX2Nv
bnN0cnVjdF9za2JfemMoc3RydWN0DQo+ID4gPiBzdG1tYWNfY2hhbm5lbCAqY2gsDQo+ID4gPiAt
CQkJCQkgICAgICAgc3RydWN0IHhkcF9idWZmICp4ZHApDQo+ID4gPiAtew0KPiA+ID4gLQl1bnNp
Z25lZCBpbnQgbWV0YXNpemUgPSB4ZHAtPmRhdGEgLSB4ZHAtPmRhdGFfbWV0YTsNCj4gPiA+IC0J
dW5zaWduZWQgaW50IGRhdGFzaXplID0geGRwLT5kYXRhX2VuZCAtIHhkcC0+ZGF0YTsNCj4gPiA+
IC0Jc3RydWN0IHNrX2J1ZmYgKnNrYjsNCj4gPiA+IC0NCj4gPiA+IC0Jc2tiID0gX19uYXBpX2Fs
bG9jX3NrYigmY2gtPnJ4dHhfbmFwaSwNCj4gPiA+IC0JCQkgICAgICAgeGRwLT5kYXRhX2VuZCAt
IHhkcC0+ZGF0YV9oYXJkX3N0YXJ0LA0KPiA+ID4gLQkJCSAgICAgICBHRlBfQVRPTUlDIHwgX19H
RlBfTk9XQVJOKTsNCj4gPiA+IC0JaWYgKHVubGlrZWx5KCFza2IpKQ0KPiA+ID4gLQkJcmV0dXJu
IE5VTEw7DQo+ID4gPiAtDQo+ID4gPiAtCXNrYl9yZXNlcnZlKHNrYiwgeGRwLT5kYXRhIC0geGRw
LT5kYXRhX2hhcmRfc3RhcnQpOw0KPiA+ID4gLQltZW1jcHkoX19za2JfcHV0KHNrYiwgZGF0YXNp
emUpLCB4ZHAtPmRhdGEsIGRhdGFzaXplKTsNCj4gPiA+IC0JaWYgKG1ldGFzaXplKQ0KPiA+ID4g
LQkJc2tiX21ldGFkYXRhX3NldChza2IsIG1ldGFzaXplKTsNCj4gPiA+IC0NCj4gPiA+IC0JcmV0
dXJuIHNrYjsNCj4gPiA+IC19DQo+ID4gPiAtDQo+ID4gPiAgc3RhdGljIHZvaWQgc3RtbWFjX2Rp
c3BhdGNoX3NrYl96YyhzdHJ1Y3Qgc3RtbWFjX3ByaXYgKnByaXYsIHUzMg0KPiA+ID4gcXVldWUs
DQo+ID4gPiAgCQkJCSAgIHN0cnVjdCBkbWFfZGVzYyAqcCwgc3RydWN0IGRtYV9kZXNjDQo+ID4g
PiAqbnAsDQo+ID4gPiAgCQkJCSAgIHN0cnVjdCB4ZHBfYnVmZiAqeGRwKQ0KPiA+ID4gQEAgLTQ3
NjEsNyArNDc0MCw3IEBAIHN0YXRpYyB2b2lkIHN0bW1hY19kaXNwYXRjaF9za2JfemMoc3RydWN0
DQo+ID4gPiBzdG1tYWNfcHJpdiAqcHJpdiwgdTMyIHF1ZXVlLA0KPiA+ID4gIAlzdHJ1Y3Qgc2tf
YnVmZiAqc2tiOw0KPiA+ID4gIAl1MzIgaGFzaDsNCj4gPiA+IA0KPiA+ID4gLQlza2IgPSBzdG1t
YWNfY29uc3RydWN0X3NrYl96YyhjaCwgeGRwKTsNCj4gPiA+ICsJc2tiID0geGRwX2NvbnN0cnVj
dF9za2IoeGRwLCAmY2gtPnJ4dHhfbmFwaSk7DQo+ID4gPiAgCWlmICghc2tiKSB7DQo+ID4gPiAg
CQlwcml2LT5kZXYtPnN0YXRzLnJ4X2Ryb3BwZWQrKzsNCj4gPiA+ICAJCXJldHVybjsNCj4gPiA+
IGRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC94ZHAuaCBiL2luY2x1ZGUvbmV0L3hkcC5oDQo+ID4g
PiBpbmRleCBhNWJjMjE0YTQ5ZDkuLjU2MWUyMWVhZjcxOCAxMDA2NDQNCj4gPiA+IC0tLSBhL2lu
Y2x1ZGUvbmV0L3hkcC5oDQo+ID4gPiArKysgYi9pbmNsdWRlL25ldC94ZHAuaA0KPiA+ID4gQEAg
LTk1LDYgKzk1LDM2IEBAIHhkcF9wcmVwYXJlX2J1ZmYoc3RydWN0IHhkcF9idWZmICp4ZHAsDQo+
ID4gPiB1bnNpZ25lZCBjaGFyICpoYXJkX3N0YXJ0LA0KPiA+ID4gIAl4ZHAtPmRhdGFfbWV0YSA9
IG1ldGFfdmFsaWQgPyBkYXRhIDogZGF0YSArIDE7DQo+ID4gPiAgfQ0KPiA+ID4gDQo+ID4gPiAr
c3RhdGljIF9fYWx3YXlzX2lubGluZSBzdHJ1Y3Qgc2tfYnVmZiAqDQo+ID4gPiAreGRwX2NvbnN0
cnVjdF9za2Ioc3RydWN0IHhkcF9idWZmICp4ZHAsIHN0cnVjdCBuYXBpX3N0cnVjdA0KPiA+ID4g
Km5hcGkpDQo+ID4gPiArew0KPiA+ID4gKwl1bnNpZ25lZCBpbnQgbWV0YXNpemU7DQo+ID4gPiAr
CXVuc2lnbmVkIGludCBkYXRhc2l6ZTsNCj4gPiA+ICsJdW5zaWduZWQgaW50IGhlYWRyb29tOw0K
PiA+ID4gKwlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOw0KPiA+ID4gKwl1bnNpZ25lZCBpbnQgbGVuOw0K
PiA+ID4gKw0KPiA+ID4gKwkvKiB0aGlzIGluY2x1ZGUgbWV0YXNpemUgKi8NCj4gPiA+ICsJZGF0
YXNpemUgPSB4ZHAtPmRhdGFfZW5kICAtIHhkcC0+ZGF0YV9tZXRhOw0KPiA+ID4gKwltZXRhc2l6
ZSA9IHhkcC0+ZGF0YSAgICAgIC0geGRwLT5kYXRhX21ldGE7DQo+ID4gPiArCWhlYWRyb29tID0g
eGRwLT5kYXRhX21ldGEgLSB4ZHAtPmRhdGFfaGFyZF9zdGFydDsNCj4gPiA+ICsJbGVuICAgICAg
PSB4ZHAtPmRhdGFfZW5kICAtIHhkcC0+ZGF0YV9oYXJkX3N0YXJ0Ow0KPiA+ID4gKw0KPiA+ID4g
KwkvKiBhbGxvY2F0ZSBhIHNrYiB0byBzdG9yZSB0aGUgZnJhZ3MgKi8NCj4gPiA+ICsJc2tiID0g
X19uYXBpX2FsbG9jX3NrYihuYXBpLCBsZW4sIEdGUF9BVE9NSUMgfCBfX0dGUF9OT1dBUk4pOw0K
PiA+ID4gKwlpZiAodW5saWtlbHkoIXNrYikpDQo+ID4gPiArCQlyZXR1cm4gTlVMTDsNCj4gPiA+
ICsNCj4gPiA+ICsJc2tiX3Jlc2VydmUoc2tiLCBoZWFkcm9vbSk7DQo+ID4gPiArCW1lbWNweShf
X3NrYl9wdXQoc2tiLCBkYXRhc2l6ZSksIHhkcC0+ZGF0YV9tZXRhLCBkYXRhc2l6ZSk7DQo+ID4g
PiArCWlmIChtZXRhc2l6ZSkgew0KPiA+ID4gKwkJX19za2JfcHVsbChza2IsIG1ldGFzaXplKTsN
Cj4gPiA+ICsJCXNrYl9tZXRhZGF0YV9zZXQoc2tiLCBtZXRhc2l6ZSk7DQo+ID4gPiArCX0NCj4g
PiA+ICsNCj4gPiA+ICsJcmV0dXJuIHNrYjsNCj4gPiA+ICt9DQo+ID4gPiArDQo+ID4gPiAgLyog
UmVzZXJ2ZSBtZW1vcnkgYXJlYSBhdCBlbmQtb2YgZGF0YSBhcmVhLg0KPiA+ID4gICAqDQo+ID4g
PiAgICogVGhpcyBtYWNybyByZXNlcnZlcyB0YWlscm9vbSBpbiB0aGUgWERQIGJ1ZmZlciBieSBs
aW1pdGluZw0KPiA+ID4gdGhlDQo+ID4gPiAtLQ0KPiA+ID4gMi4zMS4wDQo+ID4gPiANCg==
