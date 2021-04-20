Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3375D365D65
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 18:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhDTQeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 12:34:11 -0400
Received: from mga03.intel.com ([134.134.136.65]:65500 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233157AbhDTQeK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 12:34:10 -0400
IronPort-SDR: K1NslAiC7SVemC/jhesZ0E56T5tZ+mF2kwMTzCbwKi8ivW2KLCam870zFYLrJOEMJGBsDlHsNc
 YeFVZs81fdfg==
X-IronPort-AV: E=McAfee;i="6200,9189,9960"; a="195567774"
X-IronPort-AV: E=Sophos;i="5.82,237,1613462400"; 
   d="scan'208";a="195567774"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 09:33:37 -0700
IronPort-SDR: Jx2RZo3VgbU+te7KK1pgffz7vKiW6i/zGOCHFotkpiF8YqotQcVTMTJ2LSuZ+CbfsjgtiyL2wh
 Hr0NPcIzZ3LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,237,1613462400"; 
   d="scan'208";a="602542982"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga005.jf.intel.com with ESMTP; 20 Apr 2021 09:33:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 20 Apr 2021 09:33:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 20 Apr 2021 09:33:37 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 20 Apr 2021 09:33:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QY7MSwypUpvSD2tEwrtTVT6sztX82wye+PJxdiUH2EO/6KLNqxahEPdI5pjSSAXjnrD4HlCjwTDjnH3XoxMBFcd0EunyQoUtXPsvoaL6MbA3b8DjdugiZbMXKumrvNiwjX5v72XexXsPTiO7HTHt7KZOfw8CtnTe6GEZNT95eedP1hpTVFSsX70joamVikCYIIj4zh0ryYAVNxdiy6wrBw/jZHVSHQhk6fWUBab/3Z242i2AQsrIyzrKWDMkGTOWWuj6xE9pz1oz+QXSPKCRAhCWga7GXwjcl8OpSb6krVXRCUI15hZE+FwaVqr8VDozW/Eetz0BbwmlpUUYglqxvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISEsaMVdwZ5tRCaCWRhCUW26qI40I0TlgtXHc5TBb34=;
 b=T5K816DC32Ei4GjlxFr7mgAvvDLpiwZddDqI7vk2hKCy3q6Rm19eqdtH7kFhaFGoOzqon3DXqPPDqqUQCYUT4GAnEpAyJI/zMxCFUJ3bd2cmPj/elzvGymK+kK6iwSst1/fC5jtqAog1SuX4oW5rMlRIZs4/+iaiPtpPD2K1OBsm3W3/JgDEK79pRwbIALEQRJrNTZZowQSAim/7cnPZzP6FSAtfv9xwH2jgEpUI2NM6GSVRvNx6jjB6GTnbOcp5LvEoMRL7vDwTCwQ7X40i/PKKOVbp1DRRNDMSRXCOZMoiSP1NTo/G4kWlqDdpuPlQsCWGwybN+cSHTo4P+NQslg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISEsaMVdwZ5tRCaCWRhCUW26qI40I0TlgtXHc5TBb34=;
 b=LnBD7M2OumBt1JVGDVh0AMh7slDpPTRopFUCspeeZVNV6m5VDys9T3DmlcMn/Tic3Mg8PG96+fubu3C9WXnzXq+cdI/bDI6LQpQqJaU7SMkGfP0tNHR8CRu8V35GJGk7XcG+f5aSixI5t4+/cHk+BNKhbfK+Dnts0OCnHKGhsUc=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB4812.namprd11.prod.outlook.com (2603:10b6:806:f8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Tue, 20 Apr
 2021 16:33:33 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c%6]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 16:33:33 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "kurt@linutronix.de" <kurt@linutronix.de>
CC:     "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "lorenzo@kernel.org" <lorenzo@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sven.auhagen@voleatech.de" <sven.auhagen@voleatech.de>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net v2] igb: Fix XDP with PTP enabled
Thread-Topic: [PATCH net v2] igb: Fix XDP with PTP enabled
Thread-Index: AQHXNOz8Ysyd8zDcfUq68Ph4OaWuXKq9m/MA
Date:   Tue, 20 Apr 2021 16:33:33 +0000
Message-ID: <c1eed5fe05a59f86ff868580e3ae89e251f498ec.camel@intel.com>
References: <20210419072332.7246-1-kurt@linutronix.de>
In-Reply-To: <20210419072332.7246-1-kurt@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17bec134-5a80-4cad-8c43-08d9041a0a31
x-ms-traffictypediagnostic: SA2PR11MB4812:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB48122CBE68B1F1EF34E80B81C6489@SA2PR11MB4812.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sPTJtR4CbpdRxvHK7mItP/Bvi0AvEra5AxQDx4YcmnRRdKovw5WEPtnVvPW8WrawWo5UAbD4jZc0Ows5LttA7Og9q4hAlDhvL7KPMPSOLSwladB/sn4UbJvWHPQ0IjA4quVbVxzJxIB9cWRQAEgqysYcPzCBHXfr53DkwyJdqVeBk2LOB6pBkCoIAkmJLiyxsT6pIXvtJdtewa0bGeIYYYnqRHUZ7bUz38DSpab6YRJ4rQVabWhiQqMLDDXWmcT5AFEMY4en40zWpXMPQ6OF9kPiTiE7UE7hdO3yZMnOTVZojNULljdZ1FFyEcL9OIm4IwS/UjSJetXyeVM3scfrneGEXbxfD7JITgZFvOi724zKAOQ50GsXTqEfF5msZv+SUM9k5TYYVW69xU8xegA6BVmKbhYjLWnUF+wz3rxOoh0R1TDHIzYnIaOYKAJfdtqJjzxkMUBgkCZr6dcyjppFalccbE3T/tE1Fn5St4BJ/S4IGm9LG33ii4yOQircWPK0/fbNzwYVDWB7RxFhx1mj9A/5xMM1wX2F5XfYXOFzdV+rxI2ugqdGvCxaQ031aJCMPjGTBCGdvLqAzyze6Crknz6oPS/MPB2zTXSDybBHehHt+aSckxT4LdN9scUJb6ppLCdlWURakdSsDr5KChPhrw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39860400002)(346002)(136003)(83380400001)(122000001)(38100700002)(71200400001)(8936002)(8676002)(316002)(5660300002)(7416002)(66476007)(76116006)(66946007)(6512007)(64756008)(66556008)(66446008)(91956017)(36756003)(2616005)(2906002)(6506007)(4326008)(26005)(478600001)(54906003)(110136005)(6486002)(186003)(86362001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?M3Z0YlN4cmxPOFk5Z2ExYnBqUjZLZE1TMXJWNnZ5alUyczA0VS9jTW43Y25t?=
 =?utf-8?B?MEFHdEdqTHJGN0dmVVRtZDdXeXBUd1QzOWJiaFo2UENHOHkwTXd0SzIxekpT?=
 =?utf-8?B?bDlIWTJPSXBtZWNMeTZPdUVKVktRUGwwKzNLTkhtc2FwazdwU2JiWE45T0Fj?=
 =?utf-8?B?eUhuUVdIaDRReFU5MGE4Sm4wUys3aG5HZGUwOUVuQ3k1WWJGeXhwdFF6NlBR?=
 =?utf-8?B?bEtEUGtnRXZmeGVnMm5iN0hlcy9aZXZUNXRzT0hXclprbm83ZUYrSlZjeHBF?=
 =?utf-8?B?ZGpWWGh5NndrT1VsNzdsZGdpWE8wZVhtaUJSVVlhdkhrNHBqUHBOc2RSRWQ0?=
 =?utf-8?B?cE1vTXYxOTl0U1I5eGdsUEtDa0JpWmU3ZTRQNlUxRzd6Z0JHdkxZNEJVbHNN?=
 =?utf-8?B?TUUva3gva1d0MGEySmppMUtsQ01VUlBxbjY3Wm96dlBWYTVnQzI3RzhkRzlB?=
 =?utf-8?B?cXBiU0tvbjAxN3pDaFpXUTRCKzlaVWFvRllWZmhDbFhPbWhlcTliUVlWc1Zi?=
 =?utf-8?B?dXl4M2hSOEFseFdNLzRuMHJpNkxjbGFFZXNNUmVDVVRzYlNIb3ZCZkkyNSs0?=
 =?utf-8?B?alh1Y1hLVXorTThpTFRPdzlkU2RQZWtpZVVqRDd5Qy9TcGNaQmRUNVFkVVdr?=
 =?utf-8?B?MjF2U0h3Mkthck9WZHpiMlRTM2htRVkrSUhIODRiaSs3THg1MVhHSGlzRzF3?=
 =?utf-8?B?czMwVzJWenA2RWM4S04ySFhTSHc0WmQ1a0xxcTJPV3plSk1mc3BQWDk0R1lm?=
 =?utf-8?B?ZEl4cklwSzZ2REhZWTVzOFQyQ2JSRjBhN0xCYVR2Q3VVbzd3eHVjV0M2UjNo?=
 =?utf-8?B?QXB6eEZON3NZVTRIL2MxQlNoa2RiODNlN2Y2c0lHdDh4eWxrNE02L1Q2RnhV?=
 =?utf-8?B?dlZJRnY5aE9ETlpvQ2V3ajQ1T1VyTm1QMEJZY1VNaXc4cnluYUtwcWhINXh5?=
 =?utf-8?B?N1QzYTRHNG42SG42UHRIRzhwQVVVRVFiY3FsekVLTUpVUnFYMlhJTVUzeHkr?=
 =?utf-8?B?eGs3WkE3a1pMcDBYclZKVzJkaGplMHppMXlxOGlHY2VqbTBQNUpKaDN5S2gy?=
 =?utf-8?B?YXNQWkZEVHhLS1E2Y0pkSm9MQXlKUjYxZ1RFSWxOaGIxSDI0UG1QbHpvb3Fj?=
 =?utf-8?B?MDdZejFFdmgvRjJhTWxQSFg3YTFwZXBxd3FjZzRZc0x2ZW5yUWRmendkaWZB?=
 =?utf-8?B?N0pWVG53KzNMYlBYMTg3YzViTFpqbWJvSFlhcVFkL2VaL3Z0aUhoM2FEV1pQ?=
 =?utf-8?B?Tm5IbHBsdWtWZEZWeGNIbEZYQUxiRVk2VHcrbm9qUm1ZdFVnRnFENmRqeDQz?=
 =?utf-8?B?alZRUldaY3ZnOE04dFZBMGhZMkU3Qm1RLytuckxlWEROUVBwczZ0UU9UanVD?=
 =?utf-8?B?ekNEMmtVWXRxdXpJNnpQWjN1bGQxdGxmR1lubHpuUTQ2QXpGUlREbi9zbW5J?=
 =?utf-8?B?YkM2QXhwNkxNenV3MkxJaE1xSWNha1ljeEhVaEFwSllMaE5NOVhvLzVsUndR?=
 =?utf-8?B?bnRyK1hMblA0TFVtblJXalBET3NBNDlwa2FaRHAxdmdjOXM0ZlJMNU5MdGVh?=
 =?utf-8?B?bHliVCt0c0loeDQ1eGNXMWR3WHNUMEtsNDBPaHF6cTFPY0VnOWhseHdweXM2?=
 =?utf-8?B?RXYwQzJOOU5RMGx0U3ptNnRJdWc3eU1DMi9nMEtYQmpITDVLM1ZyNHhma1FH?=
 =?utf-8?B?VjNUUnRQVWdVVzFhcWJ6MldnaGFWbUhFejNZSnBkRW9sRkNMdFE2WkV2QWo5?=
 =?utf-8?B?bWJQa0NOVE9WSjJGdS9HSGp4VUZZR3JXQnhrbGFCQTFENDdobjJLbkxGaDg3?=
 =?utf-8?B?L0lnSzczTXFNbFNDTzMydz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <48FD680615ACB842BC77063769F62FBA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17bec134-5a80-4cad-8c43-08d9041a0a31
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 16:33:33.5386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5/bW1zVosYn0N0ESosbdWp7A5ooBmKU2m/FeWSH4W25cGuKjaHbbuFsofhxxNfxsOo3BJE0PPdytXmkcfPC7g+Q7HvPiE3OqfyIziXTxZm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4812
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTA0LTE5IGF0IDA5OjIzICswMjAwLCBLdXJ0IEthbnplbmJhY2ggd3JvdGU6
DQo+IFdoZW4gdXNpbmcgbmF0aXZlIFhEUCB3aXRoIHRoZSBpZ2IgZHJpdmVyLCB0aGUgWERQIGZy
YW1lIGRhdGEgZG9lc24ndA0KPiBwb2ludCB0bw0KPiB0aGUgYmVnaW5uaW5nIG9mIHRoZSBwYWNr
ZXQuIEl0J3Mgb2ZmIGJ5IDE2IGJ5dGVzLiBFdmVyeXRoaW5nIHdvcmtzDQo+IGFzIGV4cGVjdGVk
DQo+IHdpdGggWERQIHNrYiBtb2RlLg0KPiANCj4gQWN0dWFsbHkgdGhlc2UgMTYgYnl0ZXMgYXJl
IHVzZWQgdG8gc3RvcmUgdGhlIHBhY2tldCB0aW1lc3RhbXBzLg0KPiBUaGVyZWZvcmUsIHB1bGwN
Cj4gdGhlIHRpbWVzdGFtcCBiZWZvcmUgZXhlY3V0aW5nIGFueSBYRFAgb3BlcmF0aW9ucyBhbmQg
YWRqdXN0IGFsbA0KPiBvdGhlciBjb2RlDQo+IGFjY29yZGluZ2x5LiBUaGUgaWdjIGRyaXZlciBk
b2VzIGl0IGxpa2UgdGhhdCBhcyB3ZWxsLg0KPiANCj4gVGVzdGVkIHdpdGggSW50ZWwgaTIxMCBj
YXJkIGFuZCBBRl9YRFAgc29ja2V0cy4NCj4gDQo+IEZpeGVzOiA5Y2JjOTQ4YjVhMjAgKCJpZ2I6
IGFkZCBYRFAgc3VwcG9ydCIpDQo+IFNpZ25lZC1vZmYtYnk6IEt1cnQgS2FuemVuYmFjaCA8a3Vy
dEBsaW51dHJvbml4LmRlPg0KPiAtLS0NCg0KPHNuaXA+DQoNCj4gQEAgLTg2ODMsNyArODY3Niwx
MCBAQCBzdGF0aWMgaW50IGlnYl9jbGVhbl9yeF9pcnEoc3RydWN0DQo+IGlnYl9xX3ZlY3RvciAq
cV92ZWN0b3IsIGNvbnN0IGludCBidWRnZXQpDQo+ICAJd2hpbGUgKGxpa2VseSh0b3RhbF9wYWNr
ZXRzIDwgYnVkZ2V0KSkgew0KPiAgCQl1bmlvbiBlMTAwMF9hZHZfcnhfZGVzYyAqcnhfZGVzYzsN
Cj4gIAkJc3RydWN0IGlnYl9yeF9idWZmZXIgKnJ4X2J1ZmZlcjsNCj4gKwkJa3RpbWVfdCB0aW1l
c3RhbXAgPSAwOw0KPiArCQlpbnQgcGt0X29mZnNldCA9IDA7DQo+ICAJCXVuc2lnbmVkIGludCBz
aXplOw0KPiArCQl2b2lkICpwa3RidWY7DQo+ICANCj4gIAkJLyogcmV0dXJuIHNvbWUgYnVmZmVy
cyB0byBoYXJkd2FyZSwgb25lIGF0IGEgdGltZSBpcw0KPiB0b28gc2xvdyAqLw0KPiAgCQlpZiAo
Y2xlYW5lZF9jb3VudCA+PSBJR0JfUlhfQlVGRkVSX1dSSVRFKSB7DQo+IEBAIC04NzAzLDE0ICs4
Njk5LDIxIEBAIHN0YXRpYyBpbnQgaWdiX2NsZWFuX3J4X2lycShzdHJ1Y3QNCj4gaWdiX3FfdmVj
dG9yICpxX3ZlY3RvciwgY29uc3QgaW50IGJ1ZGdldCkNCj4gIAkJZG1hX3JtYigpOw0KPiAgDQo+
ICAJCXJ4X2J1ZmZlciA9IGlnYl9nZXRfcnhfYnVmZmVyKHJ4X3JpbmcsIHNpemUsDQo+ICZyeF9i
dWZfcGdjbnQpOw0KPiArCQlwa3RidWYgPSBwYWdlX2FkZHJlc3MocnhfYnVmZmVyLT5wYWdlKSAr
IHJ4X2J1ZmZlci0NCj4gPnBhZ2Vfb2Zmc2V0Ow0KPiArDQo+ICsJCS8qIHB1bGwgcnggcGFja2V0
IHRpbWVzdGFtcCBpZiBhdmFpbGFibGUgKi8NCj4gKwkJaWYgKGlnYl90ZXN0X3N0YXRlcnIocnhf
ZGVzYywgRTEwMDBfUlhEQURWX1NUQVRfVFNJUCkpDQo+IHsNCj4gKwkJCXRpbWVzdGFtcCA9IGln
Yl9wdHBfcnhfcGt0c3RhbXAocnhfcmluZy0NCj4gPnFfdmVjdG9yLA0KPiArCQkJCQkJCXBrdGJ1
Zik7DQoNClRoZSB0aW1lc3RhbXAgc2hvdWxkIGJlIGNoZWNrZWQgZm9yIGZhaWx1cmUgYW5kIG5v
dCBhZGp1c3QgdGhlc2UgdmFsdWVzDQppZiB0aGUgdGltZXN0YW1wIHdhcyBpbnZhbGlkLg0KIA0K
PiArCQkJcGt0X29mZnNldCArPSBJR0JfVFNfSERSX0xFTjsNCj4gKwkJCXNpemUgLT0gSUdCX1RT
X0hEUl9MRU47DQo+ICsJCX0NCg0K
