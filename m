Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457E5276656
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 04:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgIXCWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 22:22:19 -0400
Received: from mga06.intel.com ([134.134.136.31]:3038 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbgIXCWT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 22:22:19 -0400
IronPort-SDR: pAGCHE/lm4i2sm6zV677IGgfF8fXVYb3T/iGaw0lc+fzAIQDbXuUIuNqDYOZ4VkFzwEFkdkYIl
 QIvT/zTNt9nA==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="222657708"
X-IronPort-AV: E=Sophos;i="5.77,296,1596524400"; 
   d="scan'208";a="222657708"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 19:22:16 -0700
IronPort-SDR: e5/kGKaxwAqzs4aL+J2ZFSf58apgM9jzIgPOBnZhJlSB1er6Ld/LE7qolN67JCZYOAzbQrtGHI
 UhP5K5nsKIhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,296,1596524400"; 
   d="scan'208";a="310138872"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 23 Sep 2020 19:22:16 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 23 Sep 2020 19:22:16 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 23 Sep 2020 19:22:16 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 23 Sep 2020 19:22:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YF3iDS2hy+89JNfk6edgk/uaL5+PlXCJQz2VbsPyPWdlUXC4X4KD0kDYPP5N89iRG8dIgPbH46WWCmcRLv++5BjY+Nibr8jgjapH6cRzfefJVs2llWb+q4Kxr1it7rPwDSjDJzljvd2ohLmu2UkFJrI25AGbC7Wd8IQXOkyRc8kXbmHgdhI5XTRC86JlRMQb4uBmx9Qg/8rbUCvblgAV6qPH4rqj6neXzphwS25gU3nqwFcG/X00LRT5DmsJosiLXZRDqypO7qOfylmuY6X4KhaMq1j6jCb5m/2J8TvK2giZE84F+p4O+TTYogPq79gmzI4ALurqRNzB1yeSbyBRlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RD4ivHH87BPXMAbWjIToHZxfZ8/IE6zPJDGUxYrc1ZM=;
 b=Y3NAD1moS1uDqnynafZNQJpWdQDWhDStC4gkS5U1Nsz9dYp7UVzBPwMYK+Ku3HA1FwP69JhUd+R2zCDQeYktBUELM1qlQ+JdVLGoQE9HiX5z6zR7Jdcj4taTRTMKowz2yxneIVClK+1Re70ETtoiINZ+7+FuXDFqc7U8LVgz9ktAkxGXOUUhD4CN8TTwMtdFYJOe7RJIkK25Xiw1K/aFV1270QkNW+9FDNhdFXMLjbJxA67LkpBHJxWwbBxb/LUUsVTlWi/jnrzVC2WdCKW0TOyfpN/GQWY7Hb3NQ4V6j1SrKjR4UOAr7BiQ2bGwBYrdhKby7Lp1gB+duFMtxG9pTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RD4ivHH87BPXMAbWjIToHZxfZ8/IE6zPJDGUxYrc1ZM=;
 b=Ti7mFlklcKyHMh9Wd9CATBU+Z/fbKPGoJ+9MnsD0c1k7PeM3TsWjvr9CPTX8y805Kt6ro0Irry54sd+BF6ZUHXKVEVjxQChjoacfsR1OS0tlL/HASbM0nWFtGx8u71/RuL33pzr/4VhJefoxVInXmQ7mqO/F62+DWQcs9TxdiKY=
Received: from BY5PR11MB4354.namprd11.prod.outlook.com (2603:10b6:a03:1cb::16)
 by BY5PR11MB4103.namprd11.prod.outlook.com (2603:10b6:a03:18c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Thu, 24 Sep
 2020 02:22:10 +0000
Received: from BY5PR11MB4354.namprd11.prod.outlook.com
 ([fe80::931:156e:279:d286]) by BY5PR11MB4354.namprd11.prod.outlook.com
 ([fe80::931:156e:279:d286%6]) with mapi id 15.20.3391.025; Thu, 24 Sep 2020
 02:22:10 +0000
From:   "Pujari, Bimmy" <bimmy.pujari@intel.com>
To:     David Ahern <dsahern@gmail.com>,
        =?utf-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <maze@google.com>
CC:     bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>,
        "Nikravesh, Ashkan" <ashkan.nikravesh@intel.com>
Subject: RE: [PATCH bpf-next v2 1/2] bpf: Add bpf_ktime_get_real_ns
Thread-Topic: [PATCH bpf-next v2 1/2] bpf: Add bpf_ktime_get_real_ns
Thread-Index: AQHWkgYl6JAuHVRnpkWP8yKUi3LDM6l2/YoAgAAQlgCAAABtcA==
Date:   Thu, 24 Sep 2020 02:22:10 +0000
Message-ID: <BY5PR11MB4354B38CC1542B747D7E65C686390@BY5PR11MB4354.namprd11.prod.outlook.com>
References: <20200924000326.8913-1-bimmy.pujari@intel.com>
 <CANP3RGf-rDPkf2=YoLEn=jcHyFEDcrNrQO27RdZRCoa_xi8-4Q@mail.gmail.com>
 <00f4c72b-37ee-1fbc-21f6-612bbe037036@gmail.com>
In-Reply-To: <00f4c72b-37ee-1fbc-21f6-612bbe037036@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [98.33.67.35]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e35dec96-5ace-4195-8768-08d86030a45d
x-ms-traffictypediagnostic: BY5PR11MB4103:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB4103EC879A69557C14D0BAAA86390@BY5PR11MB4103.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /5c6hvS19zc+pfbvocWqD2KBGvfvPvlIJr3LjGrO5I1m8MFN7NmdAHUfQcNv++XQHISvniLk7yHLvLZ4iHaWAg3fN8h3FHW33PhJc20oOyjAhMLgKj6+ZtKq7PDLhuJ2VJZT2+HOpcrrgu5dNwOmEiqmbk7i6LqaE959tUyRi21htfSF3KTm2MmOVOipKRMOe0zqKPlPWO4KaoGGcRlXpWe+4u1+IjHcntC8/jMz5DAGXYlaqfsqysIntWl1fcVxfio89PB6oRSiNhUaskZeRBpVGQbnDyWFS80FN1L4f6y9FCQgSI24/epU/QJ63lLGAqkxtXsomGCqRY3FEeuMlZXtcogStFBUdMD2Zzo97s6jvhHtXA0mbMd5gwoMDjtV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4354.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(5660300002)(7696005)(2906002)(316002)(52536014)(478600001)(66574015)(66446008)(107886003)(6506007)(71200400001)(66476007)(33656002)(53546011)(66556008)(8676002)(64756008)(83380400001)(66946007)(54906003)(4326008)(76116006)(86362001)(8936002)(55016002)(186003)(9686003)(26005)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: eWoUCOxpJK2UqVtN5asVAAAwGOsFSU+LV6hrC6Op8n3C+xOv7GPNY8L6p8W9ONxIaaQH9rcZpg3eSjA0PdJpp6ZNfAc1uoFmPMa8tdIx3nLa+FMzgHxvK45kycViNiurvfrJx4ihpyvXO63Drb/W8uWdm2YfV5HKoweWTRTk0nNC0n65QUZvRe0uldZYH895TEP6Pm38XayDbtNi0B1Y6f7bII+C24x1i+501UgG8ycCiBrTirQ2QrDzEBowES+eZAMDYnSkfGJ1M8qzK7dXAfr0womIbIjsmJ7Biqnx9Y5ZCTZGkv3rZjblVaqOG1IDvXqORngF8aWIYvP0O7RGe9eVwuD1f78rVTXQWxdJ8MPgu+TmpiGE4fZZv4vsv1i9KfqAlVh9yJirvpy6rbnnP5CZvifBqV3zS+9A2bHEHZNe6o2BI09ysz5jUqDheDaw+VmuwOZ+zqDWpFLLX8hIW/Y4NQGN9Lqn77OJ6f5JTlwqwmG2Eyb9Z9mClgeOBTCIrBFcxHueMdlIi9ZvfGu6xnE89Tm13yTVNnP3W8e5DHSTJdKUboyoIGrtB66pl4CObY/wJuixILM3JtgTDbwZEnOaQgNcQS9faqnc4CX63aZdGQhuSCDE8hwOkVad8DAOqcD8bhtskX520YRCcioulw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4354.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e35dec96-5ace-4195-8768-08d86030a45d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2020 02:22:10.3026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QFRUHrdx7wp+H+qBSdsO2a152g5lmhz9ejTOcA/STWXAy4WZvjr+QQpNfcolHpr2l+S2IfaNAcJFTwSVnBK5Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4103
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVy
bkBnbWFpbC5jb20+IA0KU2VudDogV2VkbmVzZGF5LCBTZXB0ZW1iZXIgMjMsIDIwMjAgNzoxOSBQ
TQ0KVG86IE1hY2llaiDFu2VuY3p5a293c2tpIDxtYXplQGdvb2dsZS5jb20+OyBQdWphcmksIEJp
bW15IDxiaW1teS5wdWphcmlAaW50ZWwuY29tPg0KQ2M6IGJwZiA8YnBmQHZnZXIua2VybmVsLm9y
Zz47IExpbnV4IE5ldERldiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IG1jaGVoYWJAa2VybmVs
Lm9yZzsgQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz47IERhbmllbCBCb3JrbWFu
biA8ZGFuaWVsQGlvZ2VhcmJveC5uZXQ+OyBNYXJ0aW4gTGF1IDxrYWZhaUBmYi5jb20+OyBOaWty
YXZlc2gsIEFzaGthbiA8YXNoa2FuLm5pa3JhdmVzaEBpbnRlbC5jb20+DQpTdWJqZWN0OiBSZTog
W1BBVENIIGJwZi1uZXh0IHYyIDEvMl0gYnBmOiBBZGQgYnBmX2t0aW1lX2dldF9yZWFsX25zDQoN
Ck9uIDkvMjMvMjAgNzoxOSBQTSwgTWFjaWVqIMW7ZW5jenlrb3dza2kgd3JvdGU6DQo+PiBkaWZm
IC0tZ2l0IGEva2VybmVsL2JwZi9oZWxwZXJzLmMgYi9rZXJuZWwvYnBmL2hlbHBlcnMuYyBpbmRl
eCANCj4+IDVjYzc0MjVlZTQ3Ni4uNzc2ZmY1OGY5NjlkIDEwMDY0NA0KPj4gLS0tIGEva2VybmVs
L2JwZi9oZWxwZXJzLmMNCj4+ICsrKyBiL2tlcm5lbC9icGYvaGVscGVycy5jDQo+PiBAQCAtMTU1
LDYgKzE1NSwxNyBAQCBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gYnBmX2t0aW1lX2dldF9u
c19wcm90byA9IHsNCj4+ICAgICAgICAgLnJldF90eXBlICAgICAgID0gUkVUX0lOVEVHRVIsDQo+
PiAgfTsNCj4+DQo+PiArQlBGX0NBTExfMChicGZfa3RpbWVfZ2V0X3JlYWxfbnMpDQo+PiArew0K
Pj4gKyAgICAgICAvKiBOTUkgc2FmZSBhY2Nlc3MgdG8gY2xvY2sgcmVhbHRpbWUgKi8NCj4+ICsg
ICAgICAgcmV0dXJuIGt0aW1lX2dldF9yZWFsX2Zhc3RfbnMoKTsgfQ0KPj4gKw0KPj4gK2NvbnN0
IHN0cnVjdCBicGZfZnVuY19wcm90byBicGZfa3RpbWVfZ2V0X3JlYWxfbnNfcHJvdG8gPSB7DQo+
PiArICAgICAgIC5mdW5jICAgICAgICAgICA9IGJwZl9rdGltZV9nZXRfcmVhbF9ucywNCj4+ICsg
ICAgICAgLmdwbF9vbmx5ICAgICAgID0gdHJ1ZSwNCj4gDQo+IGltaG8gc2hvdWxkIGJlIGZhbHNl
LCB0aGlzIGlzIG5vcm1hbGx5IGFjY2Vzc2libGUgdG8gdXNlcnNwYWNlIGNvZGUgDQo+IHZpYSBz
eXNjYWxsLCBubyByZWFzb24gd2h5IGl0IHNob3VsZCBiZSBncGwgb25seSBmb3IgYnBmDQo+IA0K
DQphZ3JlZWQsIG5vIHJlYXNvbiBmb3IgdGhlIGJwZiBob29rIHRvIGJlIGdwbF9vbmx5Lg0KDQpH
bGFkIHRvIHNlZSB0aGUgdjIgb2YgdGhpcyBwYXRjaDsgSSB3b25kZXJlZCB3aGF0IGhhcHBlbmVk
IHRvIHRoaXMgaGVscGVyLg0KQlA6IFRoYW5rcyBNYWNpZWogJiBBaGVybiBmb3IgdGFraW5nIHRp
bWUgdG8gbG9vayBhdCBpdC4gSSB3aWxsIHVwZGF0ZSB0aGUgY2hhbmdlcyBzdWdnZXN0ZWQgc2hv
cnRseS4NCg==
