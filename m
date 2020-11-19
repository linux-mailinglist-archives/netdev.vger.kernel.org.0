Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D2E2B892F
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKSA5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:57:25 -0500
Received: from mga06.intel.com ([134.134.136.31]:44265 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbgKSA5Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 19:57:24 -0500
IronPort-SDR: SEZwy0ekkf857qufLsL1vorDxrLZkhPATktrHDmylWcm1Vqe3w1guLMfgYKyqJ2Yt7HLN9fbW7
 BLK9Toa8nPSA==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="232823878"
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="232823878"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 16:57:23 -0800
IronPort-SDR: CB/2qaePgxxmbxrPmisOV5/Z0jtojEgfxqensZqUZt7ko3vu+70H3FDrXmUkaSrPPx6iQoS+gc
 YVcysgxoF4/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="357202597"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga008.jf.intel.com with ESMTP; 18 Nov 2020 16:57:23 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 18 Nov 2020 16:57:23 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 18 Nov 2020 16:57:23 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.54) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 18 Nov 2020 16:57:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efbe8187DKqblSJv+/O+A2tmo5tVVqmlDIWBckpNg4B5tFBPFdIX451zl2MbTYgX423Ks3j5LJSA+oZoWVHkHoKQNjSM1HiDddvuTy/JC/9Rvp36NDDhPUqs2C41e/QyK1soVt5e2+9a0rqhpQ3fbP/XmUKpFzCbD1GPiQDVAV5Pqy4KTdV+0+fYBZx37jbfvCvGVohuTtz9mB9a11nyna3vERWjSUaRXXaobJk3ronuJXFBfwdEFOe6UzTknL8Ac59Yoe1iaQFRDtqmRUiL/lSLXOCEm+b8Ab+Nh7QLPD2GWuq71pXaJtGTJfwxCWfob6Njy9VzzuUi5+PkisF9/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ErZbmnfl0gXY7ung2hPLjLBwwa6k122QZveaz4jxe9w=;
 b=j4NeV9Sl5dk4330BkC4upf2zR19Uzy41AdnpaxWDuaYyqNIibeQH4imaCUczwH3w4lkbTi5hpA/Vn6pRpsmAxOpHQgeYE92LlOIZ7vT3PMQjNluYXkuIWKbTprTmO6rOckBDn5O2VwgHonywDXq0uzdtlM0Vr0MjKFGmdCwZk2BeSUOtCmMYVcCPkfIRUYT0TLpj2ot7JSpcqAsQ0fzrSnvN1q+zQ2hxUozZmYuPZqZq/qmHcjED3qMwsiNI5GuR8JpAnXB89Be2Xk2oE85RBwVOq2qI4pusvpwbCXLoNmyYPohx9aUl5MWju0BHEFDzPisHaV/SKb06ohdvLw74gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ErZbmnfl0gXY7ung2hPLjLBwwa6k122QZveaz4jxe9w=;
 b=uhRBxYqye+hcea/+8lyr7LPi/O3wk4AJpodsvpXZqIyqPoUO3g5W6XoJCfJ+31xhnPl134IZQ21f8ihxJ+kMclyydQK824S4rLOCmLg6h0g8hItHEvnNDIkaE/oBicdM4MwsqrA0QDDrhGttH2ac1eCVGpMJvHssx3ILu9F62M0=
Received: from MWHPR1101MB2207.namprd11.prod.outlook.com (2603:10b6:301:58::7)
 by MWHPR11MB1453.namprd11.prod.outlook.com (2603:10b6:301:c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Thu, 19 Nov
 2020 00:57:17 +0000
Received: from MWHPR1101MB2207.namprd11.prod.outlook.com
 ([fe80::f15b:19a7:98ba:8b02]) by MWHPR1101MB2207.namprd11.prod.outlook.com
 ([fe80::f15b:19a7:98ba:8b02%8]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 00:57:17 +0000
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Guedes, Andre" <andre.guedes@intel.com>
Subject: Re: Hardware time stamping support for AF_XDP applications
Thread-Topic: Hardware time stamping support for AF_XDP applications
Thread-Index: AQHWt7MCSEaDlO58DE6scAsur7MQZanCBAaAgAAGAoCAAttmAIABeY0AgAhPdwA=
Date:   Thu, 19 Nov 2020 00:57:17 +0000
Message-ID: <B51B5C91-D388-4BF4-97B2-0A4AF5B365A4@intel.com>
References: <7299CEB5-9777-4FE4-8DEE-32EF61F6DA29@intel.com>
 <6af7754d5bcba7a7f7d92dc43e1f4206ce470c79.camel@kernel.org>
 <65418F25-1795-4FF7-AB04-8DE78F0C8BF5@intel.com>
 <14da7d0820e3e185dcb65e010d16c818ad030e33.camel@kernel.org>
 <16DFFD9A-3973-4526-BF20-FD41E9BFBC25@intel.com>
In-Reply-To: <16DFFD9A-3973-4526-BF20-FD41E9BFBC25@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.96.95.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68379b5f-af60-4e41-8e69-08d88c260fb6
x-ms-traffictypediagnostic: MWHPR11MB1453:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB14536D0F4A8BF8FABE1D183F92E00@MWHPR11MB1453.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LSN2g4gpzS8PhXH7GwztsBOZksu8NIFTYTVDADnj8d8AJlakfqsLJ0el2NRvjY3FGVOtoNeWBGnAVIG+qT/s6sxgl7T+dRYwRdReBdq6sr4LN45AzY7n35/vNCYr9KmzavQsTMsxSqD+KoEDBBkPdBqP7pD/+Ye/1m3ij0T9DaTkdtNSlWhQtHjcNvbRdu6pgxp2gVL/l0D2sh9NNBp0T/DsJZi7P35TSixQjhMXU9CEjtlxeezsLKpEuiy/KuTYJ7ytf99ErNBeCWJFZDb6Z2xezK+Ow+lR7aOPZoFtkYN0lK9wvcjb46kbq+zvjK9uPYB4IQ1WMeKshbdMQHdtZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(6916009)(478600001)(36756003)(86362001)(6512007)(2906002)(107886003)(4001150100001)(5660300002)(4326008)(6486002)(71200400001)(91956017)(83380400001)(53546011)(6506007)(2616005)(8936002)(33656002)(316002)(66946007)(26005)(186003)(76116006)(66446008)(66476007)(54906003)(64756008)(66556008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 9SvinUwu9E255mirZjfCSBTL/8nYs+d1qv80YYwWHXrJOEiDBMTVQkBKQx57SA/uvVQpaEqPLLTVKYqprgfnGlaa1lWdmZ/SUhqq9kMb3xgCj9xIArq0yyECEtlD08XLS76ikdCsbkMptVp5KR6SbpF9W8/G04B9Ia8YmelJLVg3DG3Qesn6XmcIjo+AlTvzWtzN0q2hG16Zedq0WGvXRwiH+xUGk4hoOerCMkHpwKltXN6IHRID34idAbEYytPE1cobLygj6bMEJR+d5BhfgUWMFXr78FvFQq/sy5grrZ0xMIpv2DaDOMtNriC8wE6OGSKdGj07TvIhuJBqtgPARg2W/x9Po+5RIZ2gR3fpT8UCqQTy4pgNLHF86IGBGIoCitgT3SLJqmHyD8Qd9xgz1abvEHMy/dakHcTL8hEy36Q5bfwyRg6/lLIPu+9P9WHUsWqdAA/X7YAQw/7mKy/GfodGZe8GhEuQyOtr6s+c2J9p0xvHnqOrUvbdpzbq6ajZw2pwh+r7JsnbcniWY/3Z3PG8MlFhU2JCkWF0sU+vFmsN2p/tZ8EwpctddTGH/ZQCol5rGNGz5INl6ALX964bC/VNz1Gl5oGb0PyQDVjLBBsPmEhW7lx18AoDrN5pBb1HcnZrsuJYPD0cKCED44AOWQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC92EA74FDC0C04BB0648A4A9B9A5799@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68379b5f-af60-4e41-8e69-08d88c260fb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 00:57:17.1883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HGa5klvOMmDO5y+mBdp9Fmkrx4vfVwZbHif+fZviAzrXshNYEwUrg6at4zTqq/OTRgZx0InXkib9mTCOB8d8cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1453
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2FlZWQsDQoNCj4gT24gTm92IDEzLCAyMDIwLCBhdCAxMDowMiBBTSwgUGF0ZWwsIFZlZGFu
ZyA8dmVkYW5nLnBhdGVsQGludGVsLmNvbT4gd3JvdGU6DQo+IA0KPiBIaSBTYWVlZCwNCj4gDQo+
PiBPbiBOb3YgMTIsIDIwMjAsIGF0IDExOjMxIEFNLCBTYWVlZCBNYWhhbWVlZCA8c2FlZWRAa2Vy
bmVsLm9yZz4gd3JvdGU6DQo+PiANCj4+IE9uIFR1ZSwgMjAyMC0xMS0xMCBhdCAyMzo1MyArMDAw
MCwgUGF0ZWwsIFZlZGFuZyB3cm90ZToNCj4+Pj4gV2l0aCBCVEYgZm9ybWF0dGVkIG1ldGFkYXRh
IGl0IGlzIHVwIHRvIHRoZSBkcml2ZXIgdG8gYWR2ZXJ0aXNlDQo+Pj4+IHdoYXRldmVyIGl0IGNh
bi93YW50IDopDQo+Pj4+IHNvIHllcy4NCj4+PiANCj4+PiBJIGhhdmUgYSB2ZXJ5IGJhc2ljIHF1
ZXN0aW9uIGhlcmUuIEZyb20gd2hhdCBJIHVuZGVyc3RhbmQgYWJvdXQgQlRGLA0KPj4+IEkgY2Fu
IGdlbmVyYXRlIGEgaGVhZGVyIGZpbGUgKHVzaW5nIGJwZnRvb2w/KSBjb250YWluaW5nIHRoZSBC
VEYgZGF0YQ0KPj4+IGZvcm1hdCBwcm92aWRlZCBieSB0aGUgZHJpdmVyLiBJZiBzbywgaG93IGNh
biBJIGRlc2lnbiBhbiBhcHBsaWNhdGlvbg0KPj4+IHdoaWNoIGNhbiB3b3JrIHdpdGggbXVsdGlw
bGUgTklDcyBkcml2ZXJzIHdpdGhvdXQgcmVjb21waWxhdGlvbj8gSSBhbQ0KPj4+IGd1ZXNzaW5n
IHRoZXJlIGlzIHNvbWUgc29ydCBvZiDigJxtYXN0ZXIgbGlzdOKAnSBvZiBIVyBoaW50cyB0aGUg
ZHJpdmVycw0KPj4+IHdpbGwgYWdyZWUgdXBvbj8NCj4+IA0KPj4gSGkgUGF0ZWwsIGFzIEplc3Bl
ciBtZW50aW9uZWQsIHNvbWUgaGludHMgd2lsbCBiZSB3ZWxsIGRlZmluZWQgaW4gQlRGDQo+PiBm
b3JtYXQsIGJ5IG5hbWUsIHNpemUgYW5kIHR5cGUsIGUuZy46DQo+PiANCj4+ICB1MzIgaGFzaDMy
Ow0KPj4gIHUxNiB2bGFuX3RjaTsNCj4+ICB1NjQgdGltZXN0YW1wOw0KPj4gDQo+PiBldGMuLiAN
Cj4+IA0KPj4gaWYgdGhlIGRyaXZlciByZXBvcnRzIG9ubHkgd2VsbCBrbm93biBoaW50cywgYSBw
cm9ncmFtIGNvbXBpbGVkIHdpdGgNCj4+IHRoZXNlIGNhbiB3b3JrIGluIHRoZW9yeSBvbiBhbnkg
TklDIHRoYXQgc3VwcG9ydHMgdGhlbS4gdGhlIEJQRiBwcm9ncmFtDQo+PiBsb2FkZXIvdmVyaWZp
ZXIgaW4gdGhlIGtlcm5lbCBjYW4gY2hlY2sgY29tcGF0aWJpbGl0eSBiZWZvcmUgbG9hZGluZyBh
DQo+PiBwcm9ncmFtIG9uIGEgTklDLg0KPj4gDQo+PiBub3cgdGhlIHF1ZXN0aW9uIHJlbWFpbnMs
IFdoYXQgaWYgZGlmZmVyZW50IE5JQ3MvRHJpdmVycyByZS1hcnJhbmdlDQo+PiB0aG9zZSBmaWVs
ZHMgZGlmZmVyZW50bHk/IA0KPj4gdGhpcyBhbHNvIGNhbiBiZSBzb2x2ZWQgYnkgdGhlIEJQRiBY
RFAgcHJvZ3JhbSBsb2FkZXIgaW4gdGhlIGtlcm5lbCBhdA0KPj4gcnVuZyB0aW1lLCBpdCBjYW4g
cmUtYXJyYW5nZSB0aGUgbWV0YSBkYXRhIG9mZnNldHMgYWNjb3JkaW5nIHRvIHRoZQ0KPj4gY3Vy
cmVudCBOSUMgZGlyZWN0bHkgaW4gdGhlIGJ5dGUgY29kZSwgYnV0IHRoaXMgaXMgZ29pbmcgdG8g
YmUgYSBmdXR1cmUNCj4+IHdvcmsuDQo+PiANCj4gVGhhbmtzIGZvciBtb3JlIGluZm8hDQo+IA0K
PiBJIGhhdmUgcHVsbGVkIGluIHlvdXIgY2hhbmdlcyBhbmQgc3RhcnRlZCBtb2RpZnlpbmcgdGhl
IGlnYyBkcml2ZXIuIEkgd2lsbCByZXBvcnQgYmFjayBvbiBob3cgaXQgZ29lcy4NCj4gDQpJIHdh
cyBhYmxlIHRvIGFkZCBzdXBwb3J0IGZvciBpZ2MgYW5kIG5vdyBJIGhhdmUgYSBmZXcgbW9yZSBv
cGVucyBhYm91dCB0aGUgZmVhdHVyZTogDQotIGkyMjUgY29udGFpbnMgbXVsdGlwbGUgUEhDIGNs
b2NrcyB3aGljaCBjYW4gcmVwb3J0IHRpbWVzdGFtcHMgZm9yIGEgcGFja2V0LiBTbywgYWxvbmcg
d2l0aCB0aGUgdGltZXN0YW1wLCB3ZSBhbHNvIG5lZWQgdG8gcmV0dXJuIGNsb2NrIGlkIHdoaWNo
IHdhcyB1c2VkIHRvIHRpbWVzdGFtcCB0aGUgcGFja2V0LiBJIHdhcyB3b25kZXJpbmcgaWYgdGhl
cmUgYXJlIG90aGVyIE5JQ3Mgd2hpY2ggaGF2ZSBzaW1pbGFyIGZ1bmN0aW9uYWxpdGllcyBzbyB0
aGF0IHdlIGNhbiBhbGlnbiBvbiB0aGUgaW50ZXJmYWNlIHVzZWQgdG8gcHJlc2VudCB0aGUgdGlt
ZXN0YW1wIHRvIEFGX1hEUCBzb2NrZXRzLiANCi0gSSBhbSBhbHNvIHBsYW5uaW5nIHRvIGFkZCBj
YXBhYmlsaXR5IHRvIHNldCB0aW1lc3RhbXAgdXNpbmcgQUZfWERQIHNvY2tldC4gSSBhbSBqdXN0
IHBsYW5uaW5nIHRvIGFkZCBhbm90aGVyIHNvY2tldCBvcHRpb24gKGxpa2Ugd2hhdCBpcyBkb25l
IGluIEFGX1BBQ0tFVCkuIExldCBtZSBrbm93IGlmIHRoZXJlIGFyZSBvdGhlciBpZGVhcy4NCi0g
RnJvbSB3aGF0IEkgdW5kZXJzdGFuZCBtZXRhZGF0YSBzaXplIHdpbGwgYmUgYWNjb3VudGVkIGZv
ciBpbiB0aGUgWERQX1BBQ0tFVF9IRUFEUk9PTS4gSXMgdGhhdCBjb3JyZWN0PyBJZiBzbywgd2hh
dCB3aWxsIGhhcHBlbiBpbiB0aGUgc2NlbmFyaW8gd2hlbiB0aGUgbWV0YWRhdGEgZXhjZWVkcyB0
aGUgYW1vdW50IG9mIHNwYWNlIGF2YWlsYWJsZSAoWERQX1BBQ0tFVF9IRUFEUk9PTSAtIHNpemVv
ZihzdHJ1Y3QgeGRwX2ZyYW1lKSk/DQotIEZyb20gbG9va2luZyBhdCB0aGUgY29kZSwgaXQgbG9v
a3MgbGlrZSBCVEYgbWV0YWRhdGEgd2lsbCBiZSBlbmFibGVkIGF0IE5JQyBsZXZlbC4gU28sIGFs
bCBBRl9YRFAgc29ja2V0cyB3aWxsIHJlY2VpdmUgbWV0YWRhdGEgd2hldGhlciB0aGV5IHdhbnQg
aXQgb3Igbm90LiBEbyB3ZSBuZWVkIGEga25vYiBmb3IgQUZfWERQIHNvY2tldHMgdG8gZW5hYmxl
IG1ldGFkYXRhPyBJIHRoaW5rIGFwcGxpY2F0aW9ucyB3aGljaCBleHBlY3QgbGFyZ2VyIGZyYW1l
IHNpemUgd2lsbCBub3Qgd2FudCBtZXRhZGF0YSBpbiBvcmRlciB0byBzYXZlIHNwYWNlLg0KDQpU
aGFua3MsDQpWZWRhbmcNCj4gVGhhbmtzLA0KPiBWZWRhbmcNCg0K
