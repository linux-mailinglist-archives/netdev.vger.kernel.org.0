Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB19287A63
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730595AbgJHQya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:54:30 -0400
Received: from mga06.intel.com ([134.134.136.31]:56778 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728945AbgJHQy2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 12:54:28 -0400
IronPort-SDR: mJ4tmdIikck7Z+zd+AN0lZyNvANuc16RlX3z4jhLsrnuaUREPL2DHM5n3a75aN/ullbyJkuYf5
 A09QfG+QUqqA==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="227017146"
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="227017146"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 09:54:26 -0700
IronPort-SDR: nwSuF7p+/wAJq96TY82llahWslr743Ii3/doEHosVuDGqFPZhbl07y8bOl8lKPUe42DMuOs1cx
 FazCTN+XQz/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="349550180"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 08 Oct 2020 09:54:25 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 8 Oct 2020 09:54:25 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 8 Oct 2020 09:54:25 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 8 Oct 2020 09:54:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdWQ6sqEweXFte43orQPSnltirOEvc+dfQPCG6/+FY1DHoGe9RvQwjrwfhYUwxdJRZ/reLTjpTCE0jJZ+cBRhRE/9rxQqx51OIR27ugxhkQp4PxrafG/xnJ8m7nD9s3MNUNLyUqEJDKWv0UNQHBZchb6vgbK+FoBGSWfDq+YHc7fN1jIjq8My6rRVHeXMHpXyRppO+Azt+uKhnENKZ0tZznBctzvtekGWaPdk8rDpw2NQdjLyHgzWBzmVLHqITMLGa5/yJ1sLqmPfzonX8KRFxAF8eXQrQYYqXCL3uU0X4xxPXF+mn+P1YT7jftZhvzPl1pFWG+8b+XeumO64jq1Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GOf/fj+5wzy7X88yB86+Rqnltecl8pCH9pGAyptUfw=;
 b=CKpc2bbZWe8MBC9V9JhAkmRo7ZcX5ncDHQBq5zt55AbEHRp+/SIh32QNOea7+b3WgcYX+PiS6DqhUCg27hf3qNJEI1pki35oR+BS0SLIhVc290/iDM3o5quGRSjYm470h4Kk/f70EJPLfDPV4uPaw2XEtIDJ66GS7y2mf7Gt6yIwvFPdW/nnP1/PQEwX3JBaFWLxBOESlksKf/JcsndmzmFZ1FledV/bz5I8Ycr+cJr+zQVhk4HnnAsiUj2JRGxGF0+IPS/3Ew92tKVJmQqkxgU8Y03a6uQyNgY8aH7iU75gJ7HezS8NLYO81L2ouiVvsPqINC8j9mkkiY26zblG0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GOf/fj+5wzy7X88yB86+Rqnltecl8pCH9pGAyptUfw=;
 b=PdMcP8+W0tsz1dvfRrkvpGsDbt4vSCHQXtjNRDuQv+HFWx6576YY4vA1rIWDCDByHpFDZfxHjRyYKroBgwlZKHpyylqJqKTJqB1BWmt4XnLyXVzTSPO8v1REvue5KOgaX95rcYJRfhh0dKmFKBXaVO6xpk3ke9pRcLlRmWLOviU=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM6PR11MB3978.namprd11.prod.outlook.com (2603:10b6:5:19a::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3455.24; Thu, 8 Oct 2020 16:54:21 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a%5]) with mapi id 15.20.3433.046; Thu, 8 Oct 2020
 16:54:21 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Parav Pandit <parav@nvidia.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
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
Thread-Index: AQHWm06cVdQZOfJAqUq6P9wAQIqk66mKKyCAgACGDICAAB03gIABoskggAAXogCAAA5GgIAABE1ggAAHfwCAAAYEwIAACBeAgAB3CoCAAMgIcA==
Date:   Thu, 8 Oct 2020 16:54:21 +0000
Message-ID: <DM6PR11MB284193A69F553272DA501C52DD0B0@DM6PR11MB2841.namprd11.prod.outlook.com>
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
 <DM6PR11MB284147D4BC3FD081B9F0B8BBDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <c88b0339-48c6-d804-6fbd-b2fc6fa826d6@linux.intel.com>
 <BY5PR12MB43222FD5959E490E331D680ADC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB43222FD5959E490E331D680ADC0B0@BY5PR12MB4322.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [50.38.47.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cba5f926-b78e-46bf-99ca-08d86baacdcb
x-ms-traffictypediagnostic: DM6PR11MB3978:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB39780C3880CCF04333F2494CDD0B0@DM6PR11MB3978.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DlYYisUH7ej6CQn6GqPOiSKcy/i/46xqIS6N5zb/VdrW4T+ae4uTzpR6BLXaOIZys1jT+ZhK8Rvsdy6n/6G1ULH9nXx/QJ1FyxQeFSnhQZYF9NZ5iuk/6WJEZQl3RQIaqY8U9s69HMvNElI449E1y42uN6nfOz8173CuJBAhefyw5nAHJQqgWGk9HF7c9SQS/HQ2uLrstUaEfuVCU+NwnSJSftsaTM7YHiNSJwvSKn10irLIOrmBCN9II2ICTiWU/1q28TQpvMFdGVArr12L/94ljLSmlJgHRMCl+ISAzPpASV+VHL/VuaZ6zIG/Lwm0JRTQ3NI1hoeFwG0ENN/YPA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(7696005)(66446008)(66946007)(64756008)(83380400001)(86362001)(316002)(33656002)(186003)(8936002)(9686003)(6506007)(76116006)(2906002)(8676002)(53546011)(5660300002)(66556008)(66476007)(26005)(55016002)(4326008)(478600001)(110136005)(71200400001)(7416002)(52536014)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: kPTiYmVaWcgpLzm3UY3BiNRfmfNCOtv/cBvVV23mSAXCPaOZKto68mpnydewqat/6g5HLrrZ0B+5YJBDtJ8fT1WyifbCn8zHGIoQ879mrRHAGEmC0snXSABYhBqa3hXouQSH+Lios/vs60Rq6aq+gZt9rocs9NEShjgj4egOLFcZFFHR2z8yn2W00U2/VFCkYNy8QM10GzJr80d0HgMMDx2gwVIYDGWhFxzByrbkRCvO97Qkjp1TO7Paci0mr6U7+VY5xDs4zWCbN3svjpj+EtgPdMoO4uVC5/eEk2zpxA0rRvYXZ8BPaysXb9E4qLX1HK8qRHQ7jBsyhTGmhzDJ8QeN/S4OOTUh80RrREmvnY2bmncdl+L6+wSPxwyrLoEVs/yxBj4vF91Z5mGyC/kM9eg6aT3RlL+oqGFMtyiT1LltPJpYr9TApijP4Zl1itoG8sj28xJv2vg5r8PnRvR2SjALuhhJIIkEw47WqXAQMwevHHNaWJNxDdio/hc4yxsQ90t40bRKAms058ECJ5jPoI4z6EontECL8B+H/A8DKodSR1yCtp7DpC8XSnMICPWYiCAjCQMxiHSDTai69/LYPVEhiM2KbMwBcojXZ6Lr8cy+QUAfTShnLfSbx2CbaFdwv1osMA0bmdwtQoDSV2oy0Q==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2841.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cba5f926-b78e-46bf-99ca-08d86baacdcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2020 16:54:21.2291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OXQ/8g2eUSeapAmG52gENbfyVWyhXgFMa+SD8xrhSx9ZHAmCnpmDtQToCwWNwcWboQqJhw08i+XpKeQWRK65PUFJw8zhmJfwF4pTClPrOqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3978
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFyYXYgUGFuZGl0IDxw
YXJhdkBudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIE9jdG9iZXIgNywgMjAyMCA5OjU2
IFBNDQo+IFRvOiBQaWVycmUtTG91aXMgQm9zc2FydCA8cGllcnJlLWxvdWlzLmJvc3NhcnRAbGlu
dXguaW50ZWwuY29tPjsgRXJ0bWFuLA0KPiBEYXZpZCBNIDxkYXZpZC5tLmVydG1hbkBpbnRlbC5j
b20+OyBMZW9uIFJvbWFub3Zza3kNCj4gPGxlb25Aa2VybmVsLm9yZz4NCj4gQ2M6IGFsc2EtZGV2
ZWxAYWxzYS1wcm9qZWN0Lm9yZzsgcGFyYXZAbWVsbGFub3guY29tOyB0aXdhaUBzdXNlLmRlOw0K
PiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyByYW5qYW5pLnNyaWRoYXJhbkBsaW51eC5pbnRlbC5j
b207DQo+IGZyZWQub2hAbGludXguaW50ZWwuY29tOyBsaW51eC1yZG1hQHZnZXIua2VybmVsLm9y
ZzsNCj4gZGxlZGZvcmRAcmVkaGF0LmNvbTsgYnJvb25pZUBrZXJuZWwub3JnOyBKYXNvbiBHdW50
aG9ycGUNCj4gPGpnZ0BudmlkaWEuY29tPjsgZ3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc7IGt1
YmFAa2VybmVsLm9yZzsgV2lsbGlhbXMsDQo+IERhbiBKIDxkYW4uai53aWxsaWFtc0BpbnRlbC5j
b20+OyBTYWxlZW0sIFNoaXJheg0KPiA8c2hpcmF6LnNhbGVlbUBpbnRlbC5jb20+OyBkYXZlbUBk
YXZlbWxvZnQubmV0OyBQYXRpbCwgS2lyYW4NCj4gPGtpcmFuLnBhdGlsQGludGVsLmNvbT4NCj4g
U3ViamVjdDogUkU6IFtQQVRDSCB2MiAxLzZdIEFkZCBhbmNpbGxhcnkgYnVzIHN1cHBvcnQNCj4g
DQo+IA0KPiANCj4gPiBGcm9tOiBQaWVycmUtTG91aXMgQm9zc2FydCA8cGllcnJlLWxvdWlzLmJv
c3NhcnRAbGludXguaW50ZWwuY29tPg0KPiA+IFNlbnQ6IFRodXJzZGF5LCBPY3RvYmVyIDgsIDIw
MjAgMzoyMCBBTQ0KPiA+DQo+ID4NCj4gPiBPbiAxMC83LzIwIDQ6MjIgUE0sIEVydG1hbiwgRGF2
aWQgTSB3cm90ZToNCj4gPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4+IEZy
b206IFBpZXJyZS1Mb3VpcyBCb3NzYXJ0IDxwaWVycmUtbG91aXMuYm9zc2FydEBsaW51eC5pbnRl
bC5jb20+DQo+ID4gPj4gU2VudDogV2VkbmVzZGF5LCBPY3RvYmVyIDcsIDIwMjAgMTo1OSBQTQ0K
PiA+ID4+IFRvOiBFcnRtYW4sIERhdmlkIE0gPGRhdmlkLm0uZXJ0bWFuQGludGVsLmNvbT47IFBh
cmF2IFBhbmRpdA0KPiA+ID4+IDxwYXJhdkBudmlkaWEuY29tPjsgTGVvbiBSb21hbm92c2t5IDxs
ZW9uQGtlcm5lbC5vcmc+DQo+ID4gPj4gQ2M6IGFsc2EtZGV2ZWxAYWxzYS1wcm9qZWN0Lm9yZzsg
cGFyYXZAbWVsbGFub3guY29tOyB0aXdhaUBzdXNlLmRlOw0KPiA+ID4+IG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmc7IHJhbmphbmkuc3JpZGhhcmFuQGxpbnV4LmludGVsLmNvbTsNCj4gPiA+PiBmcmVk
Lm9oQGxpbnV4LmludGVsLmNvbTsgbGludXgtcmRtYUB2Z2VyLmtlcm5lbC5vcmc7DQo+ID4gPj4g
ZGxlZGZvcmRAcmVkaGF0LmNvbTsgYnJvb25pZUBrZXJuZWwub3JnOyBKYXNvbiBHdW50aG9ycGUN
Cj4gPiA+PiA8amdnQG52aWRpYS5jb20+OyBncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZzsga3Vi
YUBrZXJuZWwub3JnOw0KPiA+ID4+IFdpbGxpYW1zLCBEYW4gSiA8ZGFuLmoud2lsbGlhbXNAaW50
ZWwuY29tPjsgU2FsZWVtLCBTaGlyYXoNCj4gPiA+PiA8c2hpcmF6LnNhbGVlbUBpbnRlbC5jb20+
OyBkYXZlbUBkYXZlbWxvZnQubmV0OyBQYXRpbCwgS2lyYW4NCj4gPiA+PiA8a2lyYW4ucGF0aWxA
aW50ZWwuY29tPg0KPiA+ID4+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjIgMS82XSBBZGQgYW5jaWxs
YXJ5IGJ1cyBzdXBwb3J0DQo+ID4gPj4NCj4gPiA+Pg0KPiA+ID4+DQo+ID4gPj4+PiBCZWxvdyBp
cyBtb3N0IHNpbXBsZSwgaW50dWl0aXZlIGFuZCBtYXRjaGluZyB3aXRoIGNvcmUgQVBJcyBmb3IN
Cj4gPiA+Pj4+IG5hbWUgYW5kIGRlc2lnbiBwYXR0ZXJuIHdpc2UuDQo+ID4gPj4+PiBpbml0KCkN
Cj4gPiA+Pj4+IHsNCj4gPiA+Pj4+IAllcnIgPSBhbmNpbGxhcnlfZGV2aWNlX2luaXRpYWxpemUo
KTsNCj4gPiA+Pj4+IAlpZiAoZXJyKQ0KPiA+ID4+Pj4gCQlyZXR1cm4gcmV0Ow0KPiA+ID4+Pj4N
Cj4gPiA+Pj4+IAllcnIgPSBhbmNpbGxhcnlfZGV2aWNlX2FkZCgpOw0KPiA+ID4+Pj4gCWlmIChy
ZXQpDQo+ID4gPj4+PiAJCWdvdG8gZXJyX3Vud2luZDsNCj4gPiA+Pj4+DQo+ID4gPj4+PiAJZXJy
ID0gc29tZV9mb28oKTsNCj4gPiA+Pj4+IAlpZiAoZXJyKQ0KPiA+ID4+Pj4gCQlnb3RvIGVycl9m
b287DQo+ID4gPj4+PiAJcmV0dXJuIDA7DQo+ID4gPj4+Pg0KPiA+ID4+Pj4gZXJyX2ZvbzoNCj4g
PiA+Pj4+IAlhbmNpbGxhcnlfZGV2aWNlX2RlbChhZGV2KTsNCj4gPiA+Pj4+IGVycl91bndpbmQ6
DQo+ID4gPj4+PiAJYW5jaWxsYXJ5X2RldmljZV9wdXQoYWRldi0+ZGV2KTsNCj4gPiA+Pj4+IAly
ZXR1cm4gZXJyOw0KPiA+ID4+Pj4gfQ0KPiA+ID4+Pj4NCj4gPiA+Pj4+IGNsZWFudXAoKQ0KPiA+
ID4+Pj4gew0KPiA+ID4+Pj4gCWFuY2lsbGFyeV9kZXZpY2VfZGUoYWRldik7DQo+ID4gPj4+PiAJ
YW5jaWxsYXJ5X2RldmljZV9wdXQoYWRldik7DQo+ID4gPj4+PiAJLyogSXQgaXMgY29tbW9uIHRv
IGhhdmUgYSBvbmUgd3JhcHBlciBmb3IgdGhpcyBhcw0KPiA+ID4+Pj4gYW5jaWxsYXJ5X2Rldmlj
ZV91bnJlZ2lzdGVyKCkuDQo+ID4gPj4+PiAJICogVGhpcyB3aWxsIG1hdGNoIHdpdGggY29yZSBk
ZXZpY2VfdW5yZWdpc3RlcigpIHRoYXQgaGFzIHByZWNpc2UNCj4gPiA+Pj4+IGRvY3VtZW50YXRp
b24uDQo+ID4gPj4+PiAJICogYnV0IGdpdmVuIGZhY3QgdGhhdCBpbml0KCkgY29kZSBuZWVkIHBy
b3BlciBlcnJvciB1bndpbmRpbmcsDQo+ID4gPj4+PiBsaWtlIGFib3ZlLA0KPiA+ID4+Pj4gCSAq
IGl0IG1ha2Ugc2Vuc2UgdG8gaGF2ZSB0d28gQVBJcywgYW5kIG5vIG5lZWQgdG8gZXhwb3J0IGFu
b3RoZXINCj4gPiA+Pj4+IHN5bWJvbCBmb3IgdW5yZWdpc3RlcigpLg0KPiA+ID4+Pj4gCSAqIFRo
aXMgcGF0dGVybiBpcyB2ZXJ5IGVhc3kgdG8gYXVkaXQgYW5kIGNvZGUuDQo+ID4gPj4+PiAJICov
DQo+ID4gPj4+PiB9DQo+ID4gPj4+DQo+ID4gPj4+IEkgbGlrZSB0aGlzIGZsb3cgKzENCj4gPiA+
Pj4NCj4gPiA+Pj4gQnV0IC4uLiBzaW5jZSB0aGUgaW5pdCgpIGZ1bmN0aW9uIGlzIHBlcmZvcm1p
bmcgYm90aCBkZXZpY2VfaW5pdCBhbmQNCj4gPiA+Pj4gZGV2aWNlX2FkZCAtIGl0IHNob3VsZCBw
cm9iYWJseSBiZSBjYWxsZWQgYW5jaWxsYXJ5X2RldmljZV9yZWdpc3RlciwNCj4gPiA+Pj4gYW5k
IHdlIGFyZSBiYWNrIHRvIGEgc2luZ2xlIGV4cG9ydGVkIEFQSSBmb3IgYm90aCByZWdpc3RlciBh
bmQNCj4gPiA+Pj4gdW5yZWdpc3Rlci4NCj4gPiA+Pg0KPiA+ID4+IEtpbmQgcmVtaW5kZXIgdGhh
dCB3ZSBpbnRyb2R1Y2VkIHRoZSB0d28gZnVuY3Rpb25zIHRvIGFsbG93IHRoZQ0KPiA+ID4+IGNh
bGxlciB0byBrbm93IGlmIGl0IG5lZWRlZCB0byBmcmVlIG1lbW9yeSB3aGVuIGluaXRpYWxpemUo
KSBmYWlscywNCj4gPiA+PiBhbmQgaXQgZGlkbid0IG5lZWQgdG8gZnJlZSBtZW1vcnkgd2hlbiBh
ZGQoKSBmYWlsZWQgc2luY2UNCj4gPiA+PiBwdXRfZGV2aWNlKCkgdGFrZXMgY2FyZSBvZiBpdC4g
SWYgeW91IGhhdmUgYSBzaW5nbGUgaW5pdCgpIGZ1bmN0aW9uDQo+ID4gPj4gaXQncyBpbXBvc3Np
YmxlIHRvIGtub3cgd2hpY2ggYmVoYXZpb3IgdG8gc2VsZWN0IG9uIGVycm9yLg0KPiA+ID4+DQo+
ID4gPj4gSSBhbHNvIGhhdmUgYSBjYXNlIHdpdGggU291bmRXaXJlIHdoZXJlIGl0J3MgbmljZSB0
byBmaXJzdA0KPiA+ID4+IGluaXRpYWxpemUsIHRoZW4gc2V0IHNvbWUgZGF0YSBhbmQgdGhlbiBh
ZGQuDQo+ID4gPj4NCj4gPiA+DQo+ID4gPiBUaGUgZmxvdyBhcyBvdXRsaW5lZCBieSBQYXJhdiBh
Ym92ZSBkb2VzIGFuIGluaXRpYWxpemUgYXMgdGhlIGZpcnN0DQo+ID4gPiBzdGVwLCBzbyBldmVy
eSBlcnJvciBwYXRoIG91dCBvZiB0aGUgZnVuY3Rpb24gaGFzIHRvIGRvIGENCj4gPiA+IHB1dF9k
ZXZpY2UoKSwgc28geW91IHdvdWxkIG5ldmVyIG5lZWQgdG8gbWFudWFsbHkgZnJlZSB0aGUgbWVt
b3J5IGluDQo+ID4gdGhlIHNldHVwIGZ1bmN0aW9uLg0KPiA+ID4gSXQgd291bGQgYmUgZnJlZWQg
aW4gdGhlIHJlbGVhc2UgY2FsbC4NCj4gPg0KPiA+IGVyciA9IGFuY2lsbGFyeV9kZXZpY2VfaW5p
dGlhbGl6ZSgpOw0KPiA+IGlmIChlcnIpDQo+ID4gCXJldHVybiByZXQ7DQo+ID4NCj4gPiB3aGVy
ZSBpcyB0aGUgcHV0X2RldmljZSgpIGhlcmU/IGlmIHRoZSByZWxlYXNlIGZ1bmN0aW9uIGRvZXMg
YW55IHNvcnQgb2YNCj4gPiBrZnJlZSwgdGhlbiB5b3UnZCBuZWVkIHRvIGRvIGl0IG1hbnVhbGx5
IGluIHRoaXMgY2FzZS4NCj4gU2luY2UgZGV2aWNlX2luaXRpYWxpemUoKSBmYWlsZWQsIHB1dF9k
ZXZpY2UoKSBjYW5ub3QgYmUgZG9uZSBoZXJlLg0KPiBTbyB5ZXMsIHBzZXVkbyBjb2RlIHNob3Vs
ZCBoYXZlIHNob3duLA0KPiBpZiAoZXJyKSB7DQo+IAlrZnJlZShhZGV2KTsNCj4gCXJldHVybiBl
cnI7DQo+IH0NCj4gDQo+IElmIHdlIGp1c3Qgd2FudCB0byBmb2xsb3cgcmVnaXN0ZXIoKSwgdW5y
ZWdpc3RlcigpIHBhdHRlcm4sDQo+IA0KPiBUaGFuLA0KPiANCj4gYW5jaWxsYXJfZGV2aWNlX3Jl
Z2lzdGVyKCkgc2hvdWxkIGJlLA0KPiANCj4gLyoqDQo+ICAqIGFuY2lsbGFyX2RldmljZV9yZWdp
c3RlcigpIC0gcmVnaXN0ZXIgYW4gYW5jaWxsYXJ5IGRldmljZQ0KPiAgKiBOT1RFOiBfX25ldmVy
IGRpcmVjdGx5IGZyZWUgQGFkZXYgYWZ0ZXIgY2FsbGluZyB0aGlzIGZ1bmN0aW9uLCBldmVuIGlm
IGl0DQo+IHJldHVybmVkDQo+ICAqIGFuIGVycm9yLiBBbHdheXMgdXNlIGFuY2lsbGFyeV9kZXZp
Y2VfcHV0KCkgdG8gZ2l2ZSB1cCB0aGUgcmVmZXJlbmNlDQo+IGluaXRpYWxpemVkIGJ5IHRoaXMg
ZnVuY3Rpb24uDQo+ICAqIFRoaXMgbm90ZSBtYXRjaGVzIHdpdGggdGhlIGNvcmUgYW5kIGNhbGxl
ciBrbm93cyBleGFjdGx5IHdoYXQgdG8gYmUgZG9uZS4NCj4gICovDQo+IGFuY2lsbGFyeV9kZXZp
Y2VfcmVnaXN0ZXIoKQ0KPiB7DQo+IAlkZXZpY2VfaW5pdGlhbGl6ZSgmYWRldi0+ZGV2KTsNCj4g
CWlmICghZGV2LT5wYXJlbnQgfHwgIWFkZXYtPm5hbWUpDQo+IAkJcmV0dXJuIC1FSU5WQUw7DQo+
IAlpZiAoIWRldi0+cmVsZWFzZSAmJiAhKGRldi0+dHlwZSAmJiBkZXYtPnR5cGUtPnJlbGVhc2Up
KSB7DQo+IAkJLyogY29yZSBpcyBhbHJlYWR5IGNhcGFibGUgYW5kIHRocm93cyB0aGUgd2Fybmlu
ZyB3aGVuDQo+IHJlbGVhc2UgY2FsbGJhY2sgaXMgbm90IHNldC4NCj4gCQkgKiBJdCBpcyBkb25l
IGF0IGRyaXZlcnMvYmFzZS9jb3JlLmM6MTc5OC4NCj4gCQkgKiBGb3IgTlVMTCByZWxlYXNlIGl0
IHNheXMsICJkb2VzIG5vdCBoYXZlIGEgcmVsZWFzZSgpDQo+IGZ1bmN0aW9uLCBpdCBpcyBicm9r
ZW4gYW5kIG11c3QgYmUgZml4ZWQiDQo+IAkJICovDQo+IAkJcmV0dXJuIC1FSU5WQUw7DQo+IAl9
DQpUaGF0IGNvZGUgaXMgaW4gZGV2aWNlX3JlbGVhc2UoKS4gIEJlY2F1c2Ugb2YgdGhpcyBjaGVj
ayB3ZSB3aWxsIG5ldmVyIGhpdCB0aGF0IGNvZGUuDQoNCldlIGVpdGhlciBuZWVkIHRvIGxlYXZl
IHRoZSBlcnJvciBtZXNzYWdlIGhlcmUsIG9yIGlmIHdlIGFyZSBnb2luZyB0byByZWx5IG9uIHRo
ZSBjb3JlDQp0byBmaW5kIHRoaXMgY29uZGl0aW9uIGF0IHRoZSBlbmQgb2YgdGhlIHByb2Nlc3Ms
IHRoZW4gd2UgbmVlZCB0byBjb21wbGV0ZWx5IHJlbW92ZQ0KdGhpcyBjaGVjayBmcm9tIHRoZSBy
ZWdpc3RyYXRpb24gZmxvdy4NCg0KLURhdmVFDQo=
