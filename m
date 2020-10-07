Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400F9286A01
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgJGVWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:22:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:30058 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbgJGVWe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 17:22:34 -0400
IronPort-SDR: UKlzBnI+OPs0d+WlHifPRv9J4EjS7PhDMCRom4v+0b0ty/ovrVNWuscTm8HcLnCBHUtdDUhHuD
 go3bzSr2KnNQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="165206297"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="165206297"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 14:22:33 -0700
IronPort-SDR: ibiYoZEU5VkmSsZcpITgCMZf8H1GtqfCO8/Nr9F8rmX3gAQnn77Q/c2BOR7wYoIepO0uLCN/mE
 Is9HSJXR0UDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="297783486"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 07 Oct 2020 14:22:32 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Oct 2020 14:22:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 7 Oct 2020 14:22:32 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 7 Oct 2020 14:22:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=geJwvdkwotJqhwSppeNkYs8yiZLxv7pXywpaP/mNOrv+IeMfC7DDE9CtECrPt1bF3Q8giqWZHBNZSuIC8OdvVn22rJh6unGiA2CVPpSvmVc7mRO84Ri7KgjYF84x+ehg8FMkNKxkZxKnCBwgQyma+sHxQ7+pUAgo413FsHnmot0ynsYBOh8aY2w9qrEaVWDfftx0yxMdDxDFZZ4dCUx/AHD7o+8FPa/59hPBdGRHKEcgXZMTld4QWXYdH1vux5HuxcjTBai//SH8+WwDaZPJXyqDqEHpElkFwKPGRhf9yvAuE2CCE5Z2p5y9zC5OqOn7oisSwPb9gGAg6MTNeOPMrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hyO4vr8b8AOKXItK0Gv0NOVzSYC8x4OZDtZeTJF9TBg=;
 b=P2KNDtIiMitFrny+JqmIVba+I1Pffz9HTeC9t1SZWEfr/HxWCX/4yxP51PBdrni17fUltgXXvUr2rQbrErMwFXgEiq4IgyCKxlUXm+nuY9Hh98aWy6DKzkmuieOU37+xuWtp2ZAitYpFyOhMZHzhh9aGaa/GfqBngrltKqknYLTe0ouTb15Hwm5ocHk35oYzzktgtLqns+uhEE/mw3cKR7/IL6zuKCCu156g04sRvRdX6i1FHC9ZQiIMYLmP0tamWO4waVkdv9RwWKAbABDHRVEoZCY3KjTcXz+htbziBtsqCVDlr3li5S59QAt9oh+pnJBKo/DHx2nIm2fqo/jlfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hyO4vr8b8AOKXItK0Gv0NOVzSYC8x4OZDtZeTJF9TBg=;
 b=a7joWS7GsVrWfsqX6FA0qvw5/CtyaJWWyx+40UCRXEnd98tsQTgtT1fvbYCDFbnBJWhn2QJejClPIXW99Xc17n8WE/9BFe8PkwO//ekkzpsYbSNMpZKT6C5Hvy+mzP7lf1Gxi1+OrnBPm5S7xsfoaXesEx3e56DHM0GR3ofhSQ4=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM6PR11MB3884.namprd11.prod.outlook.com (2603:10b6:5:19b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3455.23; Wed, 7 Oct 2020 21:22:29 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a%5]) with mapi id 15.20.3433.044; Wed, 7 Oct 2020
 21:22:29 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Parav Pandit <parav@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm06cVdQZOfJAqUq6P9wAQIqk66mKKyCAgACGDICAAB03gIABoskggAAXogCAAA5GgIAABE1ggAAHfwCAAAYEwA==
Date:   Wed, 7 Oct 2020 21:22:29 +0000
Message-ID: <DM6PR11MB284147D4BC3FD081B9F0B8BBDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <c90316f5-a5a9-fe22-ec11-a30a54ff0a9d@linux.intel.com>
In-Reply-To: <c90316f5-a5a9-fe22-ec11-a30a54ff0a9d@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [50.38.47.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b0b26bd-9d6b-469e-a349-08d86b0718cf
x-ms-traffictypediagnostic: DM6PR11MB3884:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB3884D07E4A7CDB46E576D5E8DD0A0@DM6PR11MB3884.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0Dvq5u0XYqAK6ibdFlfol0PZh3EcA5VUZD8N4W1Cv9LPajfHsfS9HTS5GalQdyGIXlyn8jQIfSqpKep2p9g9OhvvsRxBfJ6p2/4Q6FQERAjziyLqvh4izvWdkgKbqydUxfZwE/d9mOc+hnix6Pyo+cpm6ZiISpb4mU+ZQoBbjkDonEGJEd6hUR0gw/yoshkM15mGW1lV0Ru2oNUr2caEvogUM8LxNDJeORAt1nakaWhoLRqO2V5D/JHUbcyrUDnEkMGQNDOKtbQek7E4qomV0DIyg9gd84dBMloJk8JnWLsGLONTvRnIvfl78sQQNNVSPFT8BTkyAiPDKB2ivDdcXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(9686003)(7416002)(4326008)(83380400001)(7696005)(6506007)(26005)(53546011)(186003)(54906003)(55016002)(316002)(110136005)(478600001)(33656002)(86362001)(5660300002)(66946007)(2906002)(52536014)(66476007)(64756008)(76116006)(66446008)(8936002)(8676002)(66556008)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: HX5r/Ser/9uxVQS8W3cpHtYXE/AbnZr4hKNmUylH4RSoqc/q9zn19oUUoPir8SpU6rfQdlZYp6pt+e/ZKMtMFxwgXxr7Au/RgXl7derc7GJ5AUFC6Wp2ok0Rw3ll/u/ijLTX3Zbt5kN/ous56t0VMUi87GnhZPtPD6HTT3FrS4UJstEwtoKbeYdAPHn1JzDIHN3tEmF6KCdntRlMhj4NMLXBdMwPhm8BUBMv48xshMoG+CIpYYfPeAwH1PBLcOCIEONOkLicJOKjE6xXo40uzJZSKJ8yw18jFRo+1C9pKVKc3vIqBVnmMmtLKtnZm89QDz08HQg5Rp1O6UByEdeVIaQnB8s/W4Ukov3c0w3YcYP3t99bBkndWRWAzvbiwqJ7H1fBaFHd3SW2cW2644oPsI7KsVNZv7j0xyiXAuIb581cSIWwJLE6mEV+TsExwwNu/2UCjLHNxrVzz0sNPF7WFvDEPf+zxi/9MFA7Ztm0nxlzIR8QMjWIdejMLcQJAvFy4k91sslG2hufUn4wrvGcKsC8j3xhRVSBiJtQ7e8oKIUvJg//TcQdI08MxiCA5Rda5/yKPghnTyXDhArAnkk4JN32y+0v7ap0napjmazLyqzldSrl7rRyfAXnWjoOxVgBdrO4vHrgdpzdgxbmubluqw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2841.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b0b26bd-9d6b-469e-a349-08d86b0718cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2020 21:22:29.6420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mVywXcBQHeqLD0laIBdHYrN9zvkJUEqCM8EOCDEn0RpFDtYd7nap5LmMRvFZknLjGn1GYnjfuIbSJpX8I9QDE9yQ6Jn0nxBXBDmk88YCaHE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3884
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQaWVycmUtTG91aXMgQm9zc2Fy
dCA8cGllcnJlLWxvdWlzLmJvc3NhcnRAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIE9jdG9iZXIgNywgMjAyMCAxOjU5IFBNDQo+IFRvOiBFcnRtYW4sIERhdmlkIE0gPGRhdmlk
Lm0uZXJ0bWFuQGludGVsLmNvbT47IFBhcmF2IFBhbmRpdA0KPiA8cGFyYXZAbnZpZGlhLmNvbT47
IExlb24gUm9tYW5vdnNreSA8bGVvbkBrZXJuZWwub3JnPg0KPiBDYzogYWxzYS1kZXZlbEBhbHNh
LXByb2plY3Qub3JnOyBwYXJhdkBtZWxsYW5veC5jb207IHRpd2FpQHN1c2UuZGU7DQo+IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7IHJhbmphbmkuc3JpZGhhcmFuQGxpbnV4LmludGVsLmNvbTsNCj4g
ZnJlZC5vaEBsaW51eC5pbnRlbC5jb207IGxpbnV4LXJkbWFAdmdlci5rZXJuZWwub3JnOw0KPiBk
bGVkZm9yZEByZWRoYXQuY29tOyBicm9vbmllQGtlcm5lbC5vcmc7IEphc29uIEd1bnRob3JwZQ0K
PiA8amdnQG52aWRpYS5jb20+OyBncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZzsga3ViYUBrZXJu
ZWwub3JnOyBXaWxsaWFtcywNCj4gRGFuIEogPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT47IFNh
bGVlbSwgU2hpcmF6DQo+IDxzaGlyYXouc2FsZWVtQGludGVsLmNvbT47IGRhdmVtQGRhdmVtbG9m
dC5uZXQ7IFBhdGlsLCBLaXJhbg0KPiA8a2lyYW4ucGF0aWxAaW50ZWwuY29tPg0KPiBTdWJqZWN0
OiBSZTogW1BBVENIIHYyIDEvNl0gQWRkIGFuY2lsbGFyeSBidXMgc3VwcG9ydA0KPiANCj4gDQo+
IA0KPiA+PiBCZWxvdyBpcyBtb3N0IHNpbXBsZSwgaW50dWl0aXZlIGFuZCBtYXRjaGluZyB3aXRo
IGNvcmUgQVBJcyBmb3IgbmFtZSBhbmQNCj4gPj4gZGVzaWduIHBhdHRlcm4gd2lzZS4NCj4gPj4g
aW5pdCgpDQo+ID4+IHsNCj4gPj4gCWVyciA9IGFuY2lsbGFyeV9kZXZpY2VfaW5pdGlhbGl6ZSgp
Ow0KPiA+PiAJaWYgKGVycikNCj4gPj4gCQlyZXR1cm4gcmV0Ow0KPiA+Pg0KPiA+PiAJZXJyID0g
YW5jaWxsYXJ5X2RldmljZV9hZGQoKTsNCj4gPj4gCWlmIChyZXQpDQo+ID4+IAkJZ290byBlcnJf
dW53aW5kOw0KPiA+Pg0KPiA+PiAJZXJyID0gc29tZV9mb28oKTsNCj4gPj4gCWlmIChlcnIpDQo+
ID4+IAkJZ290byBlcnJfZm9vOw0KPiA+PiAJcmV0dXJuIDA7DQo+ID4+DQo+ID4+IGVycl9mb286
DQo+ID4+IAlhbmNpbGxhcnlfZGV2aWNlX2RlbChhZGV2KTsNCj4gPj4gZXJyX3Vud2luZDoNCj4g
Pj4gCWFuY2lsbGFyeV9kZXZpY2VfcHV0KGFkZXYtPmRldik7DQo+ID4+IAlyZXR1cm4gZXJyOw0K
PiA+PiB9DQo+ID4+DQo+ID4+IGNsZWFudXAoKQ0KPiA+PiB7DQo+ID4+IAlhbmNpbGxhcnlfZGV2
aWNlX2RlKGFkZXYpOw0KPiA+PiAJYW5jaWxsYXJ5X2RldmljZV9wdXQoYWRldik7DQo+ID4+IAkv
KiBJdCBpcyBjb21tb24gdG8gaGF2ZSBhIG9uZSB3cmFwcGVyIGZvciB0aGlzIGFzDQo+ID4+IGFu
Y2lsbGFyeV9kZXZpY2VfdW5yZWdpc3RlcigpLg0KPiA+PiAJICogVGhpcyB3aWxsIG1hdGNoIHdp
dGggY29yZSBkZXZpY2VfdW5yZWdpc3RlcigpIHRoYXQgaGFzIHByZWNpc2UNCj4gPj4gZG9jdW1l
bnRhdGlvbi4NCj4gPj4gCSAqIGJ1dCBnaXZlbiBmYWN0IHRoYXQgaW5pdCgpIGNvZGUgbmVlZCBw
cm9wZXIgZXJyb3IgdW53aW5kaW5nLCBsaWtlDQo+ID4+IGFib3ZlLA0KPiA+PiAJICogaXQgbWFr
ZSBzZW5zZSB0byBoYXZlIHR3byBBUElzLCBhbmQgbm8gbmVlZCB0byBleHBvcnQgYW5vdGhlcg0K
PiA+PiBzeW1ib2wgZm9yIHVucmVnaXN0ZXIoKS4NCj4gPj4gCSAqIFRoaXMgcGF0dGVybiBpcyB2
ZXJ5IGVhc3kgdG8gYXVkaXQgYW5kIGNvZGUuDQo+ID4+IAkgKi8NCj4gPj4gfQ0KPiA+DQo+ID4g
SSBsaWtlIHRoaXMgZmxvdyArMQ0KPiA+DQo+ID4gQnV0IC4uLiBzaW5jZSB0aGUgaW5pdCgpIGZ1
bmN0aW9uIGlzIHBlcmZvcm1pbmcgYm90aCBkZXZpY2VfaW5pdCBhbmQNCj4gPiBkZXZpY2VfYWRk
IC0gaXQgc2hvdWxkIHByb2JhYmx5IGJlIGNhbGxlZCBhbmNpbGxhcnlfZGV2aWNlX3JlZ2lzdGVy
LA0KPiA+IGFuZCB3ZSBhcmUgYmFjayB0byBhIHNpbmdsZSBleHBvcnRlZCBBUEkgZm9yIGJvdGgg
cmVnaXN0ZXIgYW5kDQo+ID4gdW5yZWdpc3Rlci4NCj4gDQo+IEtpbmQgcmVtaW5kZXIgdGhhdCB3
ZSBpbnRyb2R1Y2VkIHRoZSB0d28gZnVuY3Rpb25zIHRvIGFsbG93IHRoZSBjYWxsZXINCj4gdG8g
a25vdyBpZiBpdCBuZWVkZWQgdG8gZnJlZSBtZW1vcnkgd2hlbiBpbml0aWFsaXplKCkgZmFpbHMs
IGFuZCBpdA0KPiBkaWRuJ3QgbmVlZCB0byBmcmVlIG1lbW9yeSB3aGVuIGFkZCgpIGZhaWxlZCBz
aW5jZSBwdXRfZGV2aWNlKCkgdGFrZXMNCj4gY2FyZSBvZiBpdC4gSWYgeW91IGhhdmUgYSBzaW5n
bGUgaW5pdCgpIGZ1bmN0aW9uIGl0J3MgaW1wb3NzaWJsZSB0byBrbm93DQo+IHdoaWNoIGJlaGF2
aW9yIHRvIHNlbGVjdCBvbiBlcnJvci4NCj4gDQo+IEkgYWxzbyBoYXZlIGEgY2FzZSB3aXRoIFNv
dW5kV2lyZSB3aGVyZSBpdCdzIG5pY2UgdG8gZmlyc3QgaW5pdGlhbGl6ZSwNCj4gdGhlbiBzZXQg
c29tZSBkYXRhIGFuZCB0aGVuIGFkZC4NCj4gDQoNClRoZSBmbG93IGFzIG91dGxpbmVkIGJ5IFBh
cmF2IGFib3ZlIGRvZXMgYW4gaW5pdGlhbGl6ZSBhcyB0aGUgZmlyc3Qgc3RlcCwNCnNvIGV2ZXJ5
IGVycm9yIHBhdGggb3V0IG9mIHRoZSBmdW5jdGlvbiBoYXMgdG8gZG8gYSBwdXRfZGV2aWNlKCks
IHNvIHlvdQ0Kd291bGQgbmV2ZXIgbmVlZCB0byBtYW51YWxseSBmcmVlIHRoZSBtZW1vcnkgaW4g
dGhlIHNldHVwIGZ1bmN0aW9uLg0KSXQgd291bGQgYmUgZnJlZWQgaW4gdGhlIHJlbGVhc2UgY2Fs
bC4NCg0KLURhdmVFDQoNCj4gPg0KPiA+IEF0IHRoYXQgcG9pbnQsIGRvIHdlIG5lZWQgd3JhcHBl
cnMgb24gdGhlIHByaW1pdGl2ZXMgaW5pdCwgYWRkLCBkZWwsDQo+ID4gYW5kIHB1dD8NCj4gPg0K
PiA+IC1EYXZlRQ0KPiA+DQo=
