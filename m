Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3AB417B0
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 23:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407763AbfFKV55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 17:57:57 -0400
Received: from rcdn-iport-9.cisco.com ([173.37.86.80]:62348 "EHLO
        rcdn-iport-9.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404770AbfFKV54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 17:57:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=4862; q=dns/txt; s=iport;
  t=1560290276; x=1561499876;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=X4GryEL4E8mDo97phL8mKGDV8B53OTNk4hFTe8Jf8wM=;
  b=cRO40LSqc7fqWUAd1EcyJDDCUbQooMvsCC5EIpANxnF9mH26/dq7ZrS2
   OHXgF4CXWyjy8QtuX5f/O68zOkHRGlhfRlAQ3AkYmpmcmmb/bbByz6jVI
   bDYrLDjkXE+h08K2JzRDrG4A32naTSOQ10LfG6Ad4bD0zCnFPfCXwY/lv
   o=;
IronPort-PHdr: =?us-ascii?q?9a23=3AqGXkDxXuNilXDqMo0pcTQhaKaWvV8LGuZFwc94?=
 =?us-ascii?q?YnhrRSc6+q45XlOgnF6O5wiEPSA9yJ8OpK3uzRta2oGXcN55qMqjgjSNRNTF?=
 =?us-ascii?q?dE7KdehAk8GIiAAEz/IuTtank1As1YXVNs5VmwMFNeH4D1YFiB6nA=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0ATAACLIwBd/5BdJa1mGgEBAQEBAgE?=
 =?us-ascii?q?BAQEHAgEBAQGBUwMBAQEBCwGBPSknA4E/IAQLKIQVg0cDjl6CV5czgS6BJAN?=
 =?us-ascii?q?UCQEBAQwBAS0CAQGEQAIXgmcjNgcOAQMBAQQBAQIBBG0cDIVLAQEBAxIRBA0?=
 =?us-ascii?q?MAQE3AQ8CAQgYAgImAgICMBUQAgQBDQUihGsDHQECnlACgTiIX3F+M4J5AQE?=
 =?us-ascii?q?FhQUYgg8JgQwoAYtcF4FAP4NuNT6ERBeCc4JYi1wBA4JKmwsJAoIQk0UblyK?=
 =?us-ascii?q?NFpY/AgQCBAUCDgEBBYFVATGBWHAVgyeCD4ElAQeCQ4pTcoEpj0oBAQ?=
X-IronPort-AV: E=Sophos;i="5.63,363,1557187200"; 
   d="scan'208";a="486531328"
Received: from rcdn-core-8.cisco.com ([173.37.93.144])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 11 Jun 2019 21:57:55 +0000
Received: from XCH-RCD-017.cisco.com (xch-rcd-017.cisco.com [173.37.102.27])
        by rcdn-core-8.cisco.com (8.15.2/8.15.2) with ESMTPS id x5BLvtt7006398
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 11 Jun 2019 21:57:55 GMT
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by XCH-RCD-017.cisco.com
 (173.37.102.27) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 11 Jun
 2019 16:57:55 -0500
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by xhs-rcd-002.cisco.com
 (173.37.227.247) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 11 Jun
 2019 16:57:54 -0500
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-003.cisco.com (64.101.210.230) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 11 Jun 2019 17:57:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4GryEL4E8mDo97phL8mKGDV8B53OTNk4hFTe8Jf8wM=;
 b=a5yXbFK2z1ADyq+3JuhJwobCAKEAJYoEQrCHmRR57cmoZZdmKjBLzfTH5GReo86s/76K8L8e85R+FGX0XJQEb+qSznoIhThjpkZNrqrMI/wSkUuiIHLAg6AjkQV3JHkyYEA1aJzyCvUjjgGQbFgayFR1ne9z+At7XIXVo+uJKAI=
Received: from DM6PR11MB3227.namprd11.prod.outlook.com (20.176.120.87) by
 DM6PR11MB3195.namprd11.prod.outlook.com (20.176.119.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.17; Tue, 11 Jun 2019 21:57:50 +0000
Received: from DM6PR11MB3227.namprd11.prod.outlook.com
 ([fe80::14b7:2000:43b3:ebe]) by DM6PR11MB3227.namprd11.prod.outlook.com
 ([fe80::14b7:2000:43b3:ebe%7]) with mapi id 15.20.1965.017; Tue, 11 Jun 2019
 21:57:50 +0000
From:   "Govindarajulu Varadarajan (gvaradar)" <gvaradar@cisco.com>
To:     "Christian Benvenuti (benve)" <benve@cisco.com>,
        "toshiaki.makita1@gmail.com" <toshiaki.makita1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "govind.varadar@gmail.com" <govind.varadar@gmail.com>,
        "ssuryaextr@gmail.com" <ssuryaextr@gmail.com>
Subject: Re: [PATCH RESEND net] net: handle 802.1P vlan 0 packets properly
Thread-Topic: [PATCH RESEND net] net: handle 802.1P vlan 0 packets properly
Thread-Index: AQHVH/Spv+2GNKe6oEiKofjsaIKznKaV3gWAgAEjxQA=
Date:   Tue, 11 Jun 2019 21:57:50 +0000
Message-ID: <06ef881af6480794610b5db215168bfc5000acf2.camel@cisco.com>
References: <20190610183122.4521-1-gvaradar@cisco.com>
         <13332a7b-bd3d-e546-27d1-402ed8013f41@gmail.com>
In-Reply-To: <13332a7b-bd3d-e546-27d1-402ed8013f41@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=gvaradar@cisco.com; 
x-originating-ip: [2001:420:282:1330:b892:2c46:562f:a7c7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d06c040-a01f-415b-1ec1-08d6eeb7d917
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR11MB3195;
x-ms-traffictypediagnostic: DM6PR11MB3195:
x-microsoft-antispam-prvs: <DM6PR11MB3195BE40273710FC670CCBF1D4ED0@DM6PR11MB3195.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 006546F32A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(68736007)(229853002)(305945005)(6436002)(14454004)(54906003)(76176011)(6486002)(2501003)(316002)(53546011)(6506007)(478600001)(7736002)(99286004)(2201001)(6512007)(58126008)(110136005)(8676002)(25786009)(86362001)(81166006)(81156014)(476003)(66446008)(186003)(11346002)(118296001)(102836004)(2616005)(486006)(36756003)(46003)(446003)(8936002)(4326008)(5660300002)(66946007)(66476007)(64756008)(53936002)(71190400001)(2906002)(73956011)(256004)(71200400001)(76116006)(6116002)(6246003)(66556008)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3195;H:DM6PR11MB3227.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MevuYfngLohPIuPf4Xdu3IhzLaERXy5Jv8/SGCr73+Wfa2tkaSO/Z2AvVa1t4l0KfZcDyha4s5EEoaPnevVodeo86vSWb9QoPk3qQDq2t4tG/7F+l6456GGIdGXdAFEJ3+BRv+3s/ZuI2Bv8ONGGAFib049LG5o3N+sCnwbVcCtm2gcL9AbrJeHYrQdz/e/BGZk5XWZz+lwLMlqpLGfOPH2+PCHi5Tuks7F6zdEAJcpl0dI1hqje+dxDXZ2o570RoInP8K37vUrHEh1Vh/P8X5Xyab70OnpW+tKJLwwotJCApFne329GRHKk+b/Y5erFCNA/oSv+ALTJbubbld+PIFT0AZIC8lRmHNmfOxHfdC3JiR4yvmjFQgmIyFvaUHQ0A05F/lDf2gFWRHDy5ZN+Dpkb4jVKKTQwwoNCvqpYG28=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3DD2B371A13AB440B3EC03FFC721BD72@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d06c040-a01f-415b-1ec1-08d6eeb7d917
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2019 21:57:50.7311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gvaradar@cisco.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3195
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.27, xch-rcd-017.cisco.com
X-Outbound-Node: rcdn-core-8.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QE9uIFR1ZSwgMjAxOS0wNi0xMSBhdCAxMzozNCArMDkwMCwgVG9zaGlha2kgTWFraXRhIHdyb3Rl
Og0KPiBPbiAyMDE5LzA2LzExIDM6MzEsIEdvdmluZGFyYWp1bHUgVmFyYWRhcmFqYW4gd3JvdGU6
DQo+ID4gV2hlbiBzdGFjayByZWNlaXZlcyBwa3Q6IFs4MDIuMVAgdmxhbiAwXVs4MDIuMUFEIHZs
YW4gMTAwXVtJUHY0XSwNCj4gPiB2bGFuX2RvX3JlY2VpdmUoKSByZXR1cm5zIGZhbHNlIGlmIGl0
IGRvZXMgbm90IGZpbmQgdmxhbl9kZXYuIExhdGVyDQo+ID4gX19uZXRpZl9yZWNlaXZlX3NrYl9j
b3JlKCkgZmFpbHMgdG8gZmluZCBwYWNrZXQgdHlwZSBoYW5kbGVyIGZvcg0KPiA+IHNrYi0+cHJv
dG9jb2wgODAxLjFBRCBhbmQgZHJvcHMgdGhlIHBhY2tldC4NCj4gPiANCj4gPiA4MDEuMVAgaGVh
ZGVyIHdpdGggdmxhbiBpZCAwIHNob3VsZCBiZSBoYW5kbGVkIGFzIHVudGFnZ2VkIHBhY2tldHMu
DQo+ID4gVGhpcyBwYXRjaCBmaXhlcyBpdCBieSBjaGVja2luZyBpZiB2bGFuX2lkIGlzIDAgYW5k
IHByb2Nlc3NlcyBuZXh0IHZsYW4NCj4gPiBoZWFkZXIuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1i
eTogR292aW5kYXJhanVsdSBWYXJhZGFyYWphbiA8Z3ZhcmFkYXJAY2lzY28uY29tPg0KPiA+IC0t
LQ0KPiA+ICAgbmV0LzgwMjFxL3ZsYW5fY29yZS5jIHwgMjQgKysrKysrKysrKysrKysrKysrKysr
LS0tDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwgMjEgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMo
LSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvbmV0LzgwMjFxL3ZsYW5fY29yZS5jIGIvbmV0Lzgw
MjFxL3ZsYW5fY29yZS5jDQo+ID4gaW5kZXggYTMxMzE2NWU3YTY3Li4wY2RlNTRjMDJjM2YgMTAw
NjQ0DQo+ID4gLS0tIGEvbmV0LzgwMjFxL3ZsYW5fY29yZS5jDQo+ID4gKysrIGIvbmV0LzgwMjFx
L3ZsYW5fY29yZS5jDQo+ID4gQEAgLTksMTQgKzksMzIgQEANCj4gPiAgIGJvb2wgdmxhbl9kb19y
ZWNlaXZlKHN0cnVjdCBza19idWZmICoqc2ticCkNCj4gPiAgIHsNCj4gPiAgIAlzdHJ1Y3Qgc2tf
YnVmZiAqc2tiID0gKnNrYnA7DQo+ID4gLQlfX2JlMTYgdmxhbl9wcm90byA9IHNrYi0+dmxhbl9w
cm90bzsNCj4gPiAtCXUxNiB2bGFuX2lkID0gc2tiX3ZsYW5fdGFnX2dldF9pZChza2IpOw0KPiA+
ICsJX19iZTE2IHZsYW5fcHJvdG87DQo+ID4gKwl1MTYgdmxhbl9pZDsNCj4gPiAgIAlzdHJ1Y3Qg
bmV0X2RldmljZSAqdmxhbl9kZXY7DQo+ID4gICAJc3RydWN0IHZsYW5fcGNwdV9zdGF0cyAqcnhf
c3RhdHM7DQo+ID4gICANCj4gPiArYWdhaW46DQo+ID4gKwl2bGFuX3Byb3RvID0gc2tiLT52bGFu
X3Byb3RvOwkNCj4gPiArCXZsYW5faWQgPSBza2Jfdmxhbl90YWdfZ2V0X2lkKHNrYik7DQo+ID4g
ICAJdmxhbl9kZXYgPSB2bGFuX2ZpbmRfZGV2KHNrYi0+ZGV2LCB2bGFuX3Byb3RvLCB2bGFuX2lk
KTsNCj4gPiAtCWlmICghdmxhbl9kZXYpDQo+ID4gKwlpZiAoIXZsYW5fZGV2KSB7DQo+ID4gKwkJ
LyogSW5jYXNlIG9mIDgwMi4xUCBoZWFkZXIgd2l0aCB2bGFuIGlkIDAsIGNvbnRpbnVlIGlmDQo+
ID4gKwkJICogdmxhbl9kZXYgaXMgbm90IGZvdW5kLg0KPiA+ICsJCSAqLw0KPiA+ICsJCWlmICh1
bmxpa2VseSghdmxhbl9pZCkpIHsNCj4gPiArCQkJX192bGFuX2h3YWNjZWxfY2xlYXJfdGFnKHNr
Yik7DQo+IA0KPiBMb29rcyBsaWtlIHRoaXMgY2hhbmdlcyBleGlzdGluZyBiZWhhdmlvci4gUHJp
b3JpdHktdGFnZ2VkIHBhY2tldHMgd2lsbCBiZQ0KPiB1bnRhZ2dlZA0KPiBiZWZvcmUgYnJpZGdl
LCBldGMuIEkgdGhpbmsgcHJpb3JpdHktdGFnZ2VkIHBhY2tldHMgc2hvdWxkIGJlIGZvcndhcmRl
ZCBhcw0KPiBwcmlvcml0eS10YWdnZWQNCj4gKGlmZiBicmlkZ2UgaXMgbm90IHZsYW4tYXdhcmUp
LCBub3QgdW50YWdnZWQuDQoNCk1ha2VzIHNlbnNlIHRvIG1lLiBJZiByeF9oYW5kbGVyIGlzIHJl
Z2lzdGVyZWQgdG8gdGhlIGRldmljZSwgcGt0IHNob3VsZCBiZSBzZW50DQp1bnRhZ2dlZCB0byBy
eF9oYW5kbGVyLg0KDQoNCkkgd291bGQgbGlrZSB0byBnZXQgc29tZSBjbGFyaWZpY2F0aW9uIG9u
IGZldyBtb3JlIGNhc2VzIGJlZm9yZSBJIGNoYW5nZSB0aGUNCmNvZGUuIEluIHRoZSBzZXR1cDoN
Cg0KICAgICAgICAgICAgICAgIGJyMA0KICAgICAgICAgICAgICAgICB8DQogIHZsYW4gMTAwICAg
ICAgIHwNCiAgIHwoODAyLjFBRCkgICAgfA0KICAgfCAgICAgICAgICAgICB8DQorLS0tLS0tLS0t
LS0tLS0tLS0tLS0rDQp8ICAgICAgICBldGgwICAgICAgICB8DQorLS0tLS0tLS0tLS0tLS0tLS0t
LS0rDQoNCkNhc2UgMTogWzgwMi4xUCB2bGFuMF0gW0lQXQ0KQ3VycmVudCBiZWhhdmlvdXI6IHBr
dCBpcyBzZW50IHRvIGJyMCB3aXRoIHByaW9yaXR5IHRhZy4gaS5lIHdlIHNob3VsZCBub3QgcmVt
b3ZlDQp0aGUgODAyLjFQIHRhZy4NClRoaXMgcGF0Y2g6IHJlbW92ZXMgdGhlIDgwMi4xUCB0YWcg
YW5kIGJyMCByZWNlaXZlcyB1bnRhZ2dlZCBwYWNrZXQuIFRoaXMgaXMNCndyb25nLg0KRXhwZWN0
ZWQgYmVoYXZpb3VyOiBTaG91bGQgYmUgc2FtZSBhcyBjdXJyZW50IGJlaGF2aW91ci4NCg0KQ2Fz
ZSAyOiBbODAyLjFBRCB2bGFuIDEwMF0gW0lQXQ0KQ3VycmVudCBiZWhhdmlvdXI6IHBrdCBpcyBz
ZW50IHRvIHZsYW4gMTAwIGRldmljZS4NClRoaXMgcGF0Y2g6IHNhbWUgYXMgY3VycmVudCBiZWhh
dmlvdXIuDQpFeHBlY3RlZCBiZWhhdmlvdXI6IHNhbWUgYXMgY3VycmVudCBiZWhhdmlvdXINCg0K
Q2FzZSAzOiBbODAyLjFQIHZsYW4gMF0gWzgwMi4xQUQgdmxhbiAxMDBdIFtJUF0NCkN1cnJlbnQg
YmVoYXZpb3VyOiBQa3QgaXMgc2VudCB0byBicjAgcnhfaGFuZGxlci4gVGhpcyBoYXBwZW5zIGJl
Y2F1c2UNCnZsYW5fZG9fcmVjZWl2ZSgpIHJldHVybnMgZmFsc2UgKHZsYW4gMCBkZXZpY2UgaXMg
bm90IHByZXNlbnQpLiBTdGFjayBkb2VzIG5vdCBnbw0KdGhyb3VnaCBpbm5lciBoZWFkZXJzLg0K
VGhpcyBwYXRjaDogcGt0IGlzIHNlbnQgdG8gdmxhbiAxMDAgZGV2aWNlLiBCZWNhdXNlIHZsYW5f
ZG9fcmVjZWl2ZSgpIHN0cmlwcyB2bGFuDQowIGhlYWRlciBhbmQgZmluZHMgdmxhbiAxMDAgZGV2
aWNlLg0KRXhwZWN0ZWQgYmVoYXZpb3VyOiA/DQpJTU86IFBrdCBzaG91bGQgYmUgc2VudCB0byB2
bGFuIDEwMCBkZXZpY2UgYmVjYXVzZSA4MDIuMVAgc2hvdWxkIGJlIHRyZWF0ZWQgYXMNCnByaW9y
aXR5IHRhZyBhbmQgbm90IGFzIHZsYW4gdGFnZ2VkIHBrdC4gU2luY2UgdmxhbiAxMDAgZGV2aWNl
IGlzIHByZXNlbnQsIGl0DQpzaG91bGQgYmUgc2VudCB0byB2bGFuIDEwMCBkZXZpY2UuDQoNCkNh
c2UgNDogWzgwMi4xQUQgdmxhbiAyMDBdIFs4MDIuMUFEIHZsYW4gMTAwXSBbSVBdDQpDdXJyZW50
IGJlaGF2aW91cjogUGt0IGlzIHNlbnQgdG8gYnIwIHNpbmNlIHZsYW4gMjAwIGRldmljZSBpcyBu
b3QgZm91bmQuDQpUaGlzIHBhdGNoOiBzYW1lIGFzIGN1cnJlbnQgYmVoYXZpb3VyLg0KRXhwZWN0
ZWQgYmVoYXZpb3VyOiBTYW1lIGFzIGN1cnJlbnQgYmVoYXZpb3VyLg0KDQpJcyBteSB1bmRlcnN0
YW5kaW5nIGNvcnJlY3Q/DQo=
