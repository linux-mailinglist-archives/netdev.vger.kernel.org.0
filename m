Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496952B9F97
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgKTBHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:07:02 -0500
Received: from mga06.intel.com ([134.134.136.31]:36464 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgKTBHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 20:07:02 -0500
IronPort-SDR: aBCOnZ0MSJkuBbwISUfZoh+TIskhZhzd1UbxbzFKqicXJ/5yP35eV8bclF7PRFXxLvw/husB7k
 ZG2GagTrAN2w==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="233012418"
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="233012418"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 17:07:00 -0800
IronPort-SDR: w/OuGx7GEZ379iivIdB3ucrO4WpX/ErAd/5+yf1MV/u2qzuXVbLCThdNKoPHTdnTQoT13qhk3n
 IZbn7USr9tTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="431413365"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 19 Nov 2020 17:07:00 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 19 Nov 2020 17:07:00 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 19 Nov 2020 17:06:59 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 19 Nov 2020 17:06:59 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 19 Nov 2020 17:06:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJWjjJkWSteSF1Fz7NIgL4t845yoKFiB/BhZ30ckqMSEbABLbJXvi71WpG4vvoey7ewvkZc5gZM0vEGui/R7mdDLAFsCEWJPQ7K5OGuD8AD1z4WvtORQa9Ab3qVtKEAtBAsC6HCQ+G4bSdp+LM8f+sWp2jReGzuLnJvbRVCa9150V826N9Eb2D8MSuoI08IcNkD/ZwapD4tqOTrpGEp1SMIsqcnDPUw/E1N3wJjvoSsPOa6R2yCa8qo6kX6ZQwWvPhs3/RotbMoe1TcQmmOFe29aUU1etwrSoWjHdGhdO3I9UhCXB2/8+B3e8+bmzf8F5ZF+IAGN2rpbUoX0PWSiBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pYIUT9B4PKAPlacermO8UzAKrO+rDEOi+229/1OhEI=;
 b=Rjz0Gt5cn8YklvbURve0ra6kizcgJYFQjJl0b47f0mlt3YIs/uJ1LHrUqyBfv7um31jdu2cLEWTrUCnrVxwnR05rcwtZTlKLCay0nuOzDUS9n7j+ZDxYh35hZxus4Z9SdSgfMO+E8xFu9P7DBYOWEVQ1OOBZM0h+FxItMWt6ozh5l9TrZ9ELPqmxN8ECC7gbrurF1GjNZ3Cs/tWqCoCSXfl85dPoFAJ8qLBjMp5sUWoCk5HDLlOhFde6o0XdF0Sf66c9Fg8JRgaFJzKPbRG72Q4Wdp8rpGzAboKRTov2dkpOuQ9dqkj0NESYml7gDsa0V4fsN7WtFpLRipdCZqZ2JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pYIUT9B4PKAPlacermO8UzAKrO+rDEOi+229/1OhEI=;
 b=etipfrl/hUGgolp7P2CMq4sbcPAP7CzFcUV6mxdC67wWSZ9VoUIThFIe9f7BMd6ymhV8dBvTNolqJvxnBZd0e8CVG5Ot00YO3exL+Yc+ZYf8pSfKJlADpS8fUKx5IiRq5Pbt0XNgZ09uvlA02zZ46Lucc+xnkf3181Wr16B50G4=
Received: from MWHPR1101MB2207.namprd11.prod.outlook.com (2603:10b6:301:58::7)
 by CO1PR11MB4819.namprd11.prod.outlook.com (2603:10b6:303:91::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Fri, 20 Nov
 2020 01:06:53 +0000
Received: from MWHPR1101MB2207.namprd11.prod.outlook.com
 ([fe80::f15b:19a7:98ba:8b02]) by MWHPR1101MB2207.namprd11.prod.outlook.com
 ([fe80::f15b:19a7:98ba:8b02%8]) with mapi id 15.20.3589.022; Fri, 20 Nov 2020
 01:06:53 +0000
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Guedes, Andre" <andre.guedes@intel.com>
Subject: Re: Hardware time stamping support for AF_XDP applications
Thread-Topic: Hardware time stamping support for AF_XDP applications
Thread-Index: AQHWt7MCSEaDlO58DE6scAsur7MQZanCBAaAgAAGAoCAAttmAIABeY0AgAhPdwCAAZUFgA==
Date:   Fri, 20 Nov 2020 01:06:53 +0000
Message-ID: <75C650F1-1383-47AD-96CA-B39990BA0AB3@intel.com>
References: <7299CEB5-9777-4FE4-8DEE-32EF61F6DA29@intel.com>
 <6af7754d5bcba7a7f7d92dc43e1f4206ce470c79.camel@kernel.org>
 <65418F25-1795-4FF7-AB04-8DE78F0C8BF5@intel.com>
 <14da7d0820e3e185dcb65e010d16c818ad030e33.camel@kernel.org>
 <16DFFD9A-3973-4526-BF20-FD41E9BFBC25@intel.com>
 <B51B5C91-D388-4BF4-97B2-0A4AF5B365A4@intel.com>
In-Reply-To: <B51B5C91-D388-4BF4-97B2-0A4AF5B365A4@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.96.95.157]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2defe8fd-c2d3-4ffe-f0d5-08d88cf091ad
x-ms-traffictypediagnostic: CO1PR11MB4819:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB4819AB9F2FE053CCC2EEE86592FF0@CO1PR11MB4819.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a0viSxyN1H0tsyneXs3Qxpf54Yg3sG9TNOuTGDsqv6jjpTwjm6B1A3IeUW6DANcxA/Go2JaDy9TtXyPr7vUNj+FHo7PQRtrP105Jvuubmqn8olfJ/HQ0Q+mJbZ8LYhA4BMMAVBUNVDHrKmC5wnXXouRCzYuNsGmF5e2QhItbutBQkaYxMPexL4MB4UZlvS6FIh3PummDwlkvu1jJy/BDFPMOtMVypds722LXkltAYJQr4h2DCn4B15grko3UMuT55Tr7sNSl6kKT0ATgS1DgMzBek6Fxyq7sD0B9K4wVzl9SbGD1rL6a5vk1nQeOp71OIVvCbjT7BBRW3OsHpOry2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(8936002)(66446008)(64756008)(66946007)(8676002)(76116006)(66476007)(66556008)(186003)(2906002)(6486002)(4001150100001)(86362001)(54906003)(33656002)(2616005)(83380400001)(478600001)(316002)(36756003)(53546011)(26005)(5660300002)(6512007)(71200400001)(4326008)(6506007)(107886003)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: oenvBI0lpNNudzkNn1Glw2+R320y0aa5nVhZKfJmi0O3rpPnxggudAdCUUY1NYloe2T1qvfl1SLrFq1wZ0fsH02Kmm5JJ3sllk7V4+Eui9XEykliwozhKIvVPhOfnF+1no8u0Yr5vVtL9/9HvaI907QGu2JlxuOoyPzYkNidpsbYov/C/7ZoXnf+8RvDai3Oo3ptcRZaKRIlLOnSczwGJlGrGC0vIyurKpVhvy/w9vMtIo9lit8/WMBj3j/mjynWTdPPtSOyZdUxLidLp6IFJq7+0rwnI1Nqv7/eKwREnZQOVhMjo3Vkq5DfX8AHCDKtZRO7OWMVC5e4mR/pDnciM3jcJhzKwyi7GG7xDQL9IP8Q0+JLM1QuNDEt1togZipizLzVfDhnVfNRtdUNBYRyUDQwqF6otXVK8+vO0+8Xy36kWDIxubK8blOdIcxK08y5izr3WiO1oFCYwoh1suJscwLhZQUA+caTsF5JB3FYOuQm6VNZWeCIpuAMncSC5MuqteJFR4fV0RYg7lxBkBxMJd0705h8deaNSVxUNbY3+0FxdpaHixoyQDqhRxkLW7hkWrBTzzSw5esYsXrUMaupg5vPiFE+9XqhiXTuq6tJRLlu3T2lwXqXeAfK+B3IMHv90Lyf3PqQT4kwNZG315KhkQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF3C99D82E947B43950B417C8C5615DD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2defe8fd-c2d3-4ffe-f0d5-08d88cf091ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2020 01:06:53.5821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WHs0ekz3hNKd4Htnrp3rJrhSGlJHyi00bWyCNFyAYxNGbCpsTLNseqkuUzzMoV8OWlwibY6Y4ZzT9BZiXz+3jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4819
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTm92IDE4LCAyMDIwLCBhdCA0OjU3IFBNLCBQYXRlbCwgVmVkYW5nIDx2ZWRhbmcu
cGF0ZWxAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+IEhpIFNhZWVkLA0KPiANCj4+IE9uIE5vdiAx
MywgMjAyMCwgYXQgMTA6MDIgQU0sIFBhdGVsLCBWZWRhbmcgPHZlZGFuZy5wYXRlbEBpbnRlbC5j
b20+IHdyb3RlOg0KPj4gDQo+PiBIaSBTYWVlZCwNCj4+IA0KPj4+IE9uIE5vdiAxMiwgMjAyMCwg
YXQgMTE6MzEgQU0sIFNhZWVkIE1haGFtZWVkIDxzYWVlZEBrZXJuZWwub3JnPiB3cm90ZToNCj4+
PiANCj4+PiBPbiBUdWUsIDIwMjAtMTEtMTAgYXQgMjM6NTMgKzAwMDAsIFBhdGVsLCBWZWRhbmcg
d3JvdGU6DQo+Pj4+PiBXaXRoIEJURiBmb3JtYXR0ZWQgbWV0YWRhdGEgaXQgaXMgdXAgdG8gdGhl
IGRyaXZlciB0byBhZHZlcnRpc2UNCj4+Pj4+IHdoYXRldmVyIGl0IGNhbi93YW50IDopDQo+Pj4+
PiBzbyB5ZXMuDQo+Pj4+IA0KPj4+PiBJIGhhdmUgYSB2ZXJ5IGJhc2ljIHF1ZXN0aW9uIGhlcmUu
IEZyb20gd2hhdCBJIHVuZGVyc3RhbmQgYWJvdXQgQlRGLA0KPj4+PiBJIGNhbiBnZW5lcmF0ZSBh
IGhlYWRlciBmaWxlICh1c2luZyBicGZ0b29sPykgY29udGFpbmluZyB0aGUgQlRGIGRhdGENCj4+
Pj4gZm9ybWF0IHByb3ZpZGVkIGJ5IHRoZSBkcml2ZXIuIElmIHNvLCBob3cgY2FuIEkgZGVzaWdu
IGFuIGFwcGxpY2F0aW9uDQo+Pj4+IHdoaWNoIGNhbiB3b3JrIHdpdGggbXVsdGlwbGUgTklDcyBk
cml2ZXJzIHdpdGhvdXQgcmVjb21waWxhdGlvbj8gSSBhbQ0KPj4+PiBndWVzc2luZyB0aGVyZSBp
cyBzb21lIHNvcnQgb2Yg4oCcbWFzdGVyIGxpc3TigJ0gb2YgSFcgaGludHMgdGhlIGRyaXZlcnMN
Cj4+Pj4gd2lsbCBhZ3JlZSB1cG9uPw0KPj4+IA0KPj4+IEhpIFBhdGVsLCBhcyBKZXNwZXIgbWVu
dGlvbmVkLCBzb21lIGhpbnRzIHdpbGwgYmUgd2VsbCBkZWZpbmVkIGluIEJURg0KPj4+IGZvcm1h
dCwgYnkgbmFtZSwgc2l6ZSBhbmQgdHlwZSwgZS5nLjoNCj4+PiANCj4+PiB1MzIgaGFzaDMyOw0K
Pj4+IHUxNiB2bGFuX3RjaTsNCj4+PiB1NjQgdGltZXN0YW1wOw0KPj4+IA0KPj4+IGV0Yy4uIA0K
Pj4+IA0KPj4+IGlmIHRoZSBkcml2ZXIgcmVwb3J0cyBvbmx5IHdlbGwga25vd24gaGludHMsIGEg
cHJvZ3JhbSBjb21waWxlZCB3aXRoDQo+Pj4gdGhlc2UgY2FuIHdvcmsgaW4gdGhlb3J5IG9uIGFu
eSBOSUMgdGhhdCBzdXBwb3J0cyB0aGVtLiB0aGUgQlBGIHByb2dyYW0NCj4+PiBsb2FkZXIvdmVy
aWZpZXIgaW4gdGhlIGtlcm5lbCBjYW4gY2hlY2sgY29tcGF0aWJpbGl0eSBiZWZvcmUgbG9hZGlu
ZyBhDQo+Pj4gcHJvZ3JhbSBvbiBhIE5JQy4NCj4+PiANCj4+PiBub3cgdGhlIHF1ZXN0aW9uIHJl
bWFpbnMsIFdoYXQgaWYgZGlmZmVyZW50IE5JQ3MvRHJpdmVycyByZS1hcnJhbmdlDQo+Pj4gdGhv
c2UgZmllbGRzIGRpZmZlcmVudGx5PyANCj4+PiB0aGlzIGFsc28gY2FuIGJlIHNvbHZlZCBieSB0
aGUgQlBGIFhEUCBwcm9ncmFtIGxvYWRlciBpbiB0aGUga2VybmVsIGF0DQo+Pj4gcnVuZyB0aW1l
LCBpdCBjYW4gcmUtYXJyYW5nZSB0aGUgbWV0YSBkYXRhIG9mZnNldHMgYWNjb3JkaW5nIHRvIHRo
ZQ0KPj4+IGN1cnJlbnQgTklDIGRpcmVjdGx5IGluIHRoZSBieXRlIGNvZGUsIGJ1dCB0aGlzIGlz
IGdvaW5nIHRvIGJlIGEgZnV0dXJlDQo+Pj4gd29yay4NCj4+PiANCj4+IFRoYW5rcyBmb3IgbW9y
ZSBpbmZvIQ0KPj4gDQo+PiBJIGhhdmUgcHVsbGVkIGluIHlvdXIgY2hhbmdlcyBhbmQgc3RhcnRl
ZCBtb2RpZnlpbmcgdGhlIGlnYyBkcml2ZXIuIEkgd2lsbCByZXBvcnQgYmFjayBvbiBob3cgaXQg
Z29lcy4NCj4+IA0KPiBJIHdhcyBhYmxlIHRvIGFkZCBzdXBwb3J0IGZvciBpZ2MgYW5kIG5vdyBJ
IGhhdmUgYSBmZXcgbW9yZSBvcGVucyBhYm91dCB0aGUgZmVhdHVyZTogDQo+IC0gaTIyNSBjb250
YWlucyBtdWx0aXBsZSBQSEMgY2xvY2tzIHdoaWNoIGNhbiByZXBvcnQgdGltZXN0YW1wcyBmb3Ig
YSBwYWNrZXQuIFNvLCBhbG9uZyB3aXRoIHRoZSB0aW1lc3RhbXAsIHdlIGFsc28gbmVlZCB0byBy
ZXR1cm4gY2xvY2sgaWQgd2hpY2ggd2FzIHVzZWQgdG8gdGltZXN0YW1wIHRoZSBwYWNrZXQuIEkg
d2FzIHdvbmRlcmluZyBpZiB0aGVyZSBhcmUgb3RoZXIgTklDcyB3aGljaCBoYXZlIHNpbWlsYXIg
ZnVuY3Rpb25hbGl0aWVzIHNvIHRoYXQgd2UgY2FuIGFsaWduIG9uIHRoZSBpbnRlcmZhY2UgdXNl
ZCB0byBwcmVzZW50IHRoZSB0aW1lc3RhbXAgdG8gQUZfWERQIHNvY2tldHMuIA0KPiAtIEkgYW0g
YWxzbyBwbGFubmluZyB0byBhZGQgY2FwYWJpbGl0eSB0byBzZXQgdGltZXN0YW1wIHVzaW5nIEFG
X1hEUCBzb2NrZXQuIEkgYW0ganVzdCBwbGFubmluZyB0byBhZGQgYW5vdGhlciBzb2NrZXQgb3B0
aW9uIChsaWtlIHdoYXQgaXMgZG9uZSBpbiBBRl9QQUNLRVQpLiBMZXQgbWUga25vdyBpZiB0aGVy
ZSBhcmUgb3RoZXIgaWRlYXMuDQpMb29raW5nIGEgYml0IG1vcmUgaW50byB0aGUgY29kZSwgdGhl
IG9ubHkgdGhpbmsgd2hpY2ggaXMgcmVxdWlyZWQgdG8gZW5hYmxlIHRpbWVzdGFtcGluZyB0byBp
c3N1ZSBpb2N0bCgpIGNhbGwgdG8gdGhlIGRyaXZlciB3aGljaCBpcyBhbHJlYWR5IGltcGxlbWVu
dGVkIGZvciBpMjI1LiBTbywgdGhlcmUgaXMgbm8gY2hhbmdlIHJlcXVpcmVkIGluIHRoZSBYRFAg
aW5mcmFzdHJ1Y3R1cmUgZm9yIHRoaXMuDQo+IC0gRnJvbSB3aGF0IEkgdW5kZXJzdGFuZCBtZXRh
ZGF0YSBzaXplIHdpbGwgYmUgYWNjb3VudGVkIGZvciBpbiB0aGUgWERQX1BBQ0tFVF9IRUFEUk9P
TS4gSXMgdGhhdCBjb3JyZWN0PyBJZiBzbywgd2hhdCB3aWxsIGhhcHBlbiBpbiB0aGUgc2NlbmFy
aW8gd2hlbiB0aGUgbWV0YWRhdGEgZXhjZWVkcyB0aGUgYW1vdW50IG9mIHNwYWNlIGF2YWlsYWJs
ZSAoWERQX1BBQ0tFVF9IRUFEUk9PTSAtIHNpemVvZihzdHJ1Y3QgeGRwX2ZyYW1lKSk/DQo+IC0g
RnJvbSBsb29raW5nIGF0IHRoZSBjb2RlLCBpdCBsb29rcyBsaWtlIEJURiBtZXRhZGF0YSB3aWxs
IGJlIGVuYWJsZWQgYXQgTklDIGxldmVsLiBTbywgYWxsIEFGX1hEUCBzb2NrZXRzIHdpbGwgcmVj
ZWl2ZSBtZXRhZGF0YSB3aGV0aGVyIHRoZXkgd2FudCBpdCBvciBub3QuIERvIHdlIG5lZWQgYSBr
bm9iIGZvciBBRl9YRFAgc29ja2V0cyB0byBlbmFibGUgbWV0YWRhdGE/IEkgdGhpbmsgYXBwbGlj
YXRpb25zIHdoaWNoIGV4cGVjdCBsYXJnZXIgZnJhbWUgc2l6ZSB3aWxsIG5vdCB3YW50IG1ldGFk
YXRhIGluIG9yZGVyIHRvIHNhdmUgc3BhY2UuDQo+IA0KPiBUaGFua3MsDQo+IFZlZGFuZw0KPj4g
VGhhbmtzLA0KPj4gVmVkYW5nDQoNCg==
