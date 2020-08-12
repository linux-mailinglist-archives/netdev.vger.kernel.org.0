Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30AF9242FF7
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 22:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgHLUSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 16:18:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:38788 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLUSZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Aug 2020 16:18:25 -0400
IronPort-SDR: EYN//paP97GUl2i3rKhPGntvhc+IiQd7YKAfJ4bXHUetoEhZxFWWhtynXuE6lXvQnub08j+Dc+
 5eeQ2Q42FcxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9711"; a="141685232"
X-IronPort-AV: E=Sophos;i="5.76,305,1592895600"; 
   d="scan'208";a="141685232"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2020 13:18:16 -0700
IronPort-SDR: ejvwzcaCDoMquwMoFLlDclv/X2+ENETtc4TKdZ/6WDUI3XofaHBnZTbkSRNQjqciLPZiqyc55A
 eoaGNlYbROdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,305,1592895600"; 
   d="scan'208";a="308829468"
Received: from unknown (HELO fmsmsx604.amr.corp.intel.com) ([10.18.84.214])
  by orsmga002.jf.intel.com with ESMTP; 12 Aug 2020 13:18:16 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 12 Aug 2020 13:18:16 -0700
Received: from fmsmsx124.amr.corp.intel.com (10.18.125.39) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 12 Aug 2020 13:18:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx124.amr.corp.intel.com (10.18.125.39) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 12 Aug 2020 13:18:16 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 12 Aug 2020 13:18:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXMUUSGcJgjoaN0Np6FJgOtBHymx9Nqi4lYqQCNU0Ae5c4zXEiZsjRg4L/T97P3r9VYaJeSWmB+RbCsZq2ALbwTfw22e2cTRs7YB87zFzpRBjP3FeUBNyAXW2NZ7fubOFduXyCTgNEqeC6bL6xuuzstLtyCXlXQfncznK6rdI1b3YgM1ePapUnECxnsrXAYyHEcEH2H+aspVXTVpU1FxdWwQ1hkTO7Si5BDe5bp47gByyA89KAahd53EWDnXqho+m22aAAAkt6G2HMt450C7K9BEeH8hasA1SieUZMF8LWFJiMqL43hjEafjVMk2KcYbJXf6HltSUzdUfF4BZKM1UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acEakYJ9aeZXWDIqslimjcJs2GB3Cz8+hFXsvnE3S/Y=;
 b=Z/GHa909HlqTKDN66vwwWYSKhgH09DjxwCLQZDgaZSHojydTkn71Xft3SoOnYVI3PppWk6b9PsqiihQOlRCex3f2CjdtrAxYrBH41CSi26VGjUJtb+8ZwNAwyd334rnZ3EUsFRL7sTVe0yMSmZXvM1JIBSsSozl7wvltxhtDJnu3gVWnvKY2NBBTKJK1GOQjFHHx+s635IJ5AeVDKaWzK9C0b+kK6b5mpp2F4zWI7WXZLkaMH7tpmyZ1HlmNzMgOUMTQzTrdjg+VNyVXFZf5YjCilqX+pCWNdYpLk3dpZIxR0LS9dHl/X1r1sNbn8o+hMSAJ3XnI8i7k7nPcH9ibdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acEakYJ9aeZXWDIqslimjcJs2GB3Cz8+hFXsvnE3S/Y=;
 b=S9HS6OlAtJhOlcg+hoHYRunz+7/7c2gddyxwfIblVzLL2EasG/KfNl7LPi9ExKRuqLuqkyhcHxuNE6nW7XvUHpx1FW802hr4NjG+Kx0hfTTWGArlHRfankZZJnm1rQKZz41/ULPvRUNpGzcatL9Wpt00UxsFnsXJdBzvOAT24nk=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MW3PR11MB4730.namprd11.prod.outlook.com (2603:10b6:303:58::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15; Wed, 12 Aug
 2020 20:18:14 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd%9]) with mapi id 15.20.3283.015; Wed, 12 Aug 2020
 20:18:14 +0000
From:   "Ramamurthy, Harshitha" <harshitha.ramamurthy@intel.com>
To:     "songliubraving@fb.com" <songliubraving@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kafai@fb.com" <kafai@fb.com>, "yhs@fb.com" <yhs@fb.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andriin@fb.com" <andriin@fb.com>
CC:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Herbert, Tom" <tom.herbert@intel.com>
Subject: Re: [RFC PATCH bpf-next] bpf: add bpf_get_skb_hash helper function
Thread-Topic: [RFC PATCH bpf-next] bpf: add bpf_get_skb_hash helper function
Thread-Index: AQHWb0SJGqaKfRQhd0+zpgNz8FQRnKkxsx2AgAG//IA=
Date:   Wed, 12 Aug 2020 20:18:13 +0000
Message-ID: <0865cca6c7fa8ac77f4d9131aa4728cd1ef6e3b8.camel@intel.com>
References: <20200810182841.10953-1-harshitha.ramamurthy@intel.com>
         <bf183ea6-7b68-3416-2a61-9d3bbf084230@gmail.com>
In-Reply-To: <bf183ea6-7b68-3416-2a61-9d3bbf084230@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
authentication-results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc7adaf7-196a-48a6-a054-08d83efcd788
x-ms-traffictypediagnostic: MW3PR11MB4730:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4730A05D896FCA9BB995CCE185420@MW3PR11MB4730.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MMhCfSbUQZfrtgQM2pQT8ZZ0VP7FztMR+LOAnz0xlfzEmeh5h2hvMamrfXQk+o+SWJsDq59MuCy2b46ekkvOiDSDVnvHvOKqcg14uUY/PZr8ReYz68Wgx8C9CE4nYhuWmaCHg6iNXKhAylt9HH/qzQU3IcNvPWKXAFpyCtlmydIvIc6nKOj2e8bCtTqo3nk6ISJ32Q4VMmQdcTXPuwlxaQRxnK1V9sNglyo67KldrqGIBZMUptqR7Yszadxe4FxrBwPff9l8h02wDhD98zSqbTtBSh1f4UNfP0JjslU69tfOTlQtnaQ4gyQyjJ0wUH0C0mi2wwMzSdPMckcycsXp19+2LU8G4+tnyVnXAVTB9w3f+Ge1hUoZx9jASl8XtEnv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(39860400002)(346002)(136003)(7416002)(478600001)(26005)(54906003)(6512007)(316002)(8676002)(86362001)(8936002)(5660300002)(110136005)(186003)(83380400001)(2616005)(66556008)(36756003)(66446008)(66476007)(64756008)(107886003)(66946007)(76116006)(71200400001)(6506007)(53546011)(4326008)(2906002)(6486002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: sN90f2m6BFEfOAXTMft8rKTY24oC7FmhvL0KNCRbiaUI4NvXtDRpE/ICRgIiZ0AHp6KYL3l4jxROrwEuiK6QAOrE/loVG0gkSGjFCQyDGk6aZ4SYYNnn00/rmiho5XC1a18ifXNIT6+W1LY8/2UOY+I1FBsjxMOXHeoWbeK3nskhHddkZWFdyXFZVgGovWvjgX+GZ8RO0waRwJD/5xNq61A+Emfkr8QpWE567Fo8Grt7JRRNplqBa4FuS0xC3GeLeH6dwobcDuTOoBCFQKpbcHjsEpQnM/YMhJ/ZcAxyvZJaTHG01APz60ldH0brPEGyEN0SytxzZkr5Eo5QJWFl8FjJqMKXXTDc0/Mx6w0/GVrvami0gY3imklcMeSUm+FVnOBz9hOAO980C7PlL5ZE3OdpxtAw7ABA/pOV2+Cq44LZYrudr5QzngpFTPVnT5sGAdXKY4gHSQuVCqcV34rxEI5jblilDKhyqXPCXrqg/VdvDB3M872MGavIZqNEUHPBM7Q7GMqtgAYogFI3lGkUQfXJjsQLQ5Q3Glr9QYzjB/DUTK9TMZr132HRRLLe280T2a2FnoEVNchpIlOjDzaQ99RDrZcAHmyD27UaZFFDhJS4vvjdTUuA56DbUAKZ8LXB31nOJ0m8UU+vLIrwgvYzgQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D68B02B75FDAA469F59A19905FBB68B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7adaf7-196a-48a6-a054-08d83efcd788
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2020 20:18:13.9391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FA2D2UImtmGW0+7qDQUOfS1tQw7CRvWrK4Lpvo6exE5AxeTJcOKs/5O7YCIyXCvyZhJYtpjY6HKvM+qS+4RN2GB+sXpbRt4vNp5qrX1cc0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4730
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA4LTEwIGF0IDEzOjAyIC0wNjAwLCBEYXZpZCBBaGVybiB3cm90ZToNCj4g
T24gOC8xMC8yMCAxMjoyOCBQTSwgSGFyc2hpdGhhIFJhbWFtdXJ0aHkgd3JvdGU6DQo+ID4gVGhp
cyBwYXRjaCBhZGRzIGEgaGVscGVyIGZ1bmN0aW9uIGNhbGxlZCBicGZfZ2V0X3NrYl9oYXNoIHRv
DQo+ID4gY2FsY3VsYXRlDQo+ID4gdGhlIHNrYiBoYXNoIGZvciBhIHBhY2tldCBhdCB0aGUgWERQ
IGxheWVyLiBJbiB0aGUgaGVscGVyIGZ1bmN0aW9uLA0KPiANCj4gV2h5PyBpLmUuLCBleHBlY3Rl
ZCB1c2UgY2FzZT8NCj4gDQo+IFB1bGxpbmcgdGhpcyBmcm9tIGhhcmR3YXJlIHdoZW4gcG9zc2li
bGUgaXMgYmV0dGVyLiBlLmcuLCBTYWVlZCdzDQo+IGhhcmR3YXJlIGhpbnRzIHByb3Bvc2FsIGlu
Y2x1ZGVzIGl0Lg0KDQpUaGFua3MgZm9yIHRoZSByZXZpZXcgYW5kIGNvbW1lbnRzLg0KDQpTbywg
d2hlbiBwb3NzaWJsZSwgaXQgbWlnaHQgYmUgYmV0dGVyIHRvIHB1bGwgdGhlIEhXIGhhc2ggYnV0
IG5vdCBhbGwNCkhXIHByb3ZpZGVzIGl0IHNvIHRoaXMgZnVuY3Rpb24gd291bGQgYmUgdXNlZnVs
IGluIHRob3NlIGNhc2VzLiBBbHNvLA0KdGhpcyBpcyBhIHByZWN1cnNvciB0byBwb3RlbnRpYWxs
eSBjYWxsaW5nIHRoZSBpbi1rZXJuZWwgZmxvdyBkaXNzZWN0b3INCmZyb20gYSBoZWxwZXIgZnVu
Y3Rpb24uDQo+IA0KPiA+IGEgbG9jYWwgc2tiIGlzIGFsbG9jYXRlZCBhbmQgd2UgcG9wdWxhdGUg
dGhlIGZpZWxkcyBuZWVkZWQgaW4gdGhlDQo+ID4gc2tiDQo+ID4gYmVmb3JlIGNhbGxpbmcgc2ti
X2dldF9oYXNoLiBUbyBhdm9pZCBtZW1vcnkgYWxsb2NhdGlvbnMgZm9yIGVhY2gNCj4gPiBwYWNr
ZXQsDQo+ID4gd2UgYWxsb2NhdGUgYW4gc2tiIHBlciBDUFUgYW5kIHVzZSB0aGUgc2FtZSBidWZm
ZXIgZm9yIHN1YnNlcXVlbnQNCj4gPiBoYXNoDQo+ID4gY2FsY3VsYXRpb25zIG9uIHRoZSBzYW1l
IENQVS4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBIYXJzaGl0aGEgUmFtYW11cnRoeSA8aGFy
c2hpdGhhLnJhbWFtdXJ0aHlAaW50ZWwuY29tDQo+ID4gPg0KPiA+IC0tLQ0KPiA+ICBpbmNsdWRl
L3VhcGkvbGludXgvYnBmLmggICAgICAgfCAgOCArKysrKysNCj4gPiAgbmV0L2NvcmUvZmlsdGVy
LmMgICAgICAgICAgICAgIHwgNTANCj4gPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrDQo+ID4gIHRvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaCB8ICA4ICsrKysrKw0KPiA+
ICAzIGZpbGVzIGNoYW5nZWQsIDY2IGluc2VydGlvbnMoKykNCj4gPiANCj4gPiBkaWZmIC0tZ2l0
IGEvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+
ID4gaW5kZXggYjEzNGU2NzllOWRiLi4yNWFhODUwYzhhNDAgMTAwNjQ0DQo+ID4gLS0tIGEvaW5j
bHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+ID4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5o
DQo+ID4gQEAgLTMzOTQsNiArMzM5NCwxMyBAQCB1bmlvbiBicGZfYXR0ciB7DQo+ID4gICAqCQlB
IG5vbi1uZWdhdGl2ZSB2YWx1ZSBlcXVhbCB0byBvciBsZXNzIHRoYW4gKnNpemUqIG9uDQo+ID4g
c3VjY2VzcywNCj4gPiAgICoJCW9yIGEgbmVnYXRpdmUgZXJyb3IgaW4gY2FzZSBvZiBmYWlsdXJl
Lg0KPiA+ICAgKg0KPiA+ICsgKiB1MzIgYnBmX2dldF9za2JfaGFzaChzdHJ1Y3QgeGRwX2J1ZmYg
KnhkcF9tZCkNCj4gPiArICoJRGVzY3JpcHRpb24NCj4gPiArICoJCVJldHVybiB0aGUgc2tiIGhh
c2ggZm9yIHRoZSB4ZHAgY29udGV4dCBwYXNzZWQuIFRoaXMNCj4gPiBmdW5jdGlvbg0KPiA+ICsg
KgkJYWxsb2NhdGVzIGEgdGVtcG9yYXJ5IHNrYiBhbmQgcG9wdWxhdGVzIHRoZSBmaWVsZHMNCj4g
PiBuZWVkZWQuIEl0DQo+ID4gKyAqCQl0aGVuIGNhbGxzIHNrYl9nZXRfaGFzaCB0byBjYWxjdWxh
dGUgdGhlIHNrYiBoYXNoIGZvcg0KPiA+IHRoZSBwYWNrZXQuDQo+ID4gKyAqCVJldHVybg0KPiA+
ICsgKgkJVGhlIDMyLWJpdCBoYXNoLg0KPiA+ICAgKi8NCj4gPiAgI2RlZmluZSBfX0JQRl9GVU5D
X01BUFBFUihGTikJCVwNCj4gPiAgCUZOKHVuc3BlYyksCQkJXA0KPiA+IEBAIC0zNTM4LDYgKzM1
NDUsNyBAQCB1bmlvbiBicGZfYXR0ciB7DQo+ID4gIAlGTihza2NfdG9fdGNwX3JlcXVlc3Rfc29j
ayksCVwNCj4gPiAgCUZOKHNrY190b191ZHA2X3NvY2spLAkJXA0KPiA+ICAJRk4oZ2V0X3Rhc2tf
c3RhY2spLAkJXA0KPiA+ICsJRk4oZ2V0X3NrYl9oYXNoKSwJCVwNCj4gPiAgCS8qICovDQo+ID4g
IA0KPiA+ICAvKiBpbnRlZ2VyIHZhbHVlIGluICdpbW0nIGZpZWxkIG9mIEJQRl9DQUxMIGluc3Ry
dWN0aW9uIHNlbGVjdHMNCj4gPiB3aGljaCBoZWxwZXINCj4gPiBkaWZmIC0tZ2l0IGEvbmV0L2Nv
cmUvZmlsdGVyLmMgYi9uZXQvY29yZS9maWx0ZXIuYw0KPiA+IGluZGV4IDcxMjRmMGZlNjk3NC4u
OWY2YWQ3MjA5YjQ0IDEwMDY0NA0KPiA+IC0tLSBhL25ldC9jb3JlL2ZpbHRlci5jDQo+ID4gKysr
IGIvbmV0L2NvcmUvZmlsdGVyLmMNCj4gPiBAQCAtMzc2NSw2ICszNzY1LDU0IEBAIHN0YXRpYyBj
b25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8NCj4gPiBicGZfeGRwX3JlZGlyZWN0X21hcF9wcm90
byA9IHsNCj4gPiAgCS5hcmczX3R5cGUgICAgICA9IEFSR19BTllUSElORywNCj4gPiAgfTsNCj4g
PiAgDQo+ID4gK3N0YXRpYyBERUZJTkVfUEVSX0NQVShzdHJ1Y3Qgc2tfYnVmZiAqLCBoYXNoX3Nr
Yik7DQo+ID4gKw0KPiA+ICtCUEZfQ0FMTF8xKGJwZl9nZXRfc2tiX2hhc2gsIHN0cnVjdCB4ZHBf
YnVmZiAqLCB4ZHApDQo+ID4gK3sNCj4gPiArCXZvaWQgKmRhdGFfZW5kID0geGRwLT5kYXRhX2Vu
ZDsNCj4gPiArCXN0cnVjdCBldGhoZHIgKmV0aCA9IHhkcC0+ZGF0YTsNCj4gPiArCXZvaWQgKmRh
dGEgPSB4ZHAtPmRhdGE7DQo+ID4gKwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiA+ICsJc3RydWN0
IHNrX2J1ZmYgKnNrYjsNCj4gPiArCWludCBuaF9vZmYsIGxlbjsNCj4gPiArCXUzMiByZXQgPSAw
Ow0KPiA+ICsNCj4gPiArCS8qIGRpc2FibGUgaW50ZXJydXB0cyB0byBnZXQgdGhlIGNvcnJlY3Qg
c2tiIHBvaW50ZXIgKi8NCj4gPiArCWxvY2FsX2lycV9zYXZlKGZsYWdzKTsNCj4gPiArDQo+ID4g
KwlsZW4gPSBkYXRhX2VuZCAtIGRhdGE7DQo+ID4gKwlza2IgPSB0aGlzX2NwdV9yZWFkKGhhc2hf
c2tiKTsNCj4gPiArCWlmICghc2tiKSB7DQo+ID4gKwkJc2tiID0gYWxsb2Nfc2tiKGxlbiwgR0ZQ
X0FUT01JQyk7DQo+ID4gKwkJaWYgKCFza2IpDQo+ID4gKwkJCWdvdG8gb3V0Ow0KPiA+ICsJCXRo
aXNfY3B1X3dyaXRlKGhhc2hfc2tiLCBza2IpOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCW5oX29m
ZiA9IHNpemVvZigqZXRoKTsNCj4gDQo+IHZsYW5zPw0KDQpZZXMsIG5lZWQgdG8gZmFjdG9yIGZv
ciB2bGFucy4gV2lsbCBmaXggaXQuDQo+IA0KPiA+ICsJaWYgKGRhdGEgKyBuaF9vZmYgPiBkYXRh
X2VuZCkNCj4gPiArCQlnb3RvIG91dDsNCj4gPiArDQo+ID4gKwlza2ItPmRhdGEgPSBkYXRhOw0K
PiA+ICsJc2tiLT5oZWFkID0gZGF0YTsNCj4gPiArCXNrYi0+bmV0d29ya19oZWFkZXIgPSBuaF9v
ZmY7DQo+ID4gKwlza2ItPnByb3RvY29sID0gZXRoLT5oX3Byb3RvOw0KPiA+ICsJc2tiLT5sZW4g
PSBsZW47DQo+ID4gKwlza2ItPmRldiA9IHhkcC0+cnhxLT5kZXY7DQo+ID4gKw0KPiA+ICsJcmV0
ID0gc2tiX2dldF9oYXNoKHNrYik7DQo+IA0KPiBzdGF0aWMgaW5saW5lIF9fdTMyIHNrYl9nZXRf
aGFzaChzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPiB7DQo+ICAgICAgICAgaWYgKCFza2ItPmw0X2hh
c2ggJiYgIXNrYi0+c3dfaGFzaCkNCj4gICAgICAgICAgICAgICAgIF9fc2tiX2dldF9oYXNoKHNr
Yik7DQo+IA0KPiAgICAgICAgIHJldHVybiBza2ItPmhhc2g7DQo+IH0NCj4gDQo+IF9fc2tiX2dl
dF9oYXNoIC0+IF9fc2tiX3NldF9zd19oYXNoIC0+IF9fc2tiX3NldF9oYXNoIHdoaWNoIHNldHMN
Cj4gc3dfaGFzaCBhcyBhIG1pbmltdW0sIHNvIGl0IHNlZW1zIHRvIG1lIHlvdSB3aWxsIGFsd2F5
cyBiZSByZXR1cm5pbmcNCj4gdGhlDQo+IGhhc2ggb2YgdGhlIGZpcnN0IHBhY2tldCBzaW5jZSB5
b3UgZG8gbm90IGNsZWFyIHJlbGV2YW50IGZpZWxkcyBvZg0KPiB0aGUgc2tiLg0KDQp5ZXMsIHRo
YXQncyB0cnVlLiBDYWxsaW5nIHNrYl9jbGVhcl9oYXNoIGZpcnN0IHNob3VsZCBmaXggdGhpcy4g
SSB3aWxsDQp0cnkgaXQgb3V0Lg0KDQpUaGFua3MsDQpIYXJzaGl0aGEuDQo=
