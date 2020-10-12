Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564F128BFCE
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 20:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388497AbgJLSez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 14:34:55 -0400
Received: from mga05.intel.com ([192.55.52.43]:19060 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729681AbgJLSey (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 14:34:54 -0400
IronPort-SDR: kqGL8GA24bndJHKePprFHCUCwOM/jHkErndUXn04C8wzYRA+fq2IlyQePE8IXYsNw26CElYP1E
 Mfj31PlmCXVw==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="250480834"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="250480834"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 11:34:53 -0700
IronPort-SDR: //DR/Vtpx6fmxmwiXVNK24cGF2SeWJFZ4r3ydyX88LCaQ6/N2JFMEppcCDq8buN/noa1GBCVQG
 LG/XhFoMsDEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="463200034"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga004.jf.intel.com with ESMTP; 12 Oct 2020 11:34:53 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Oct 2020 11:34:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 12 Oct 2020 11:34:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 12 Oct 2020 11:34:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXnfV4CdwRs58sR/qiuyuL730lXXFXG6FX77haY2GAtntsMvrSOHTVWzZGVcxta+9zF+MnWdkGcrLAs3Z6aNziXzm/QcszmHfMH7iRyHQcT+rk0W2RJUU49CEi48tgRw4cQZmgVYts/y0N3qJLruiT2NduoFhzH25kB9yBD8LjldUrHgMcblkRJm/pYHJXMJqgs9v9zy2MoG3We4fQtpguBxANUEtMrD16VX9fdWcBrPOwc2fG1np6G9VlnvXgrKL6sFffGl1PgDqEa5SE2H+P3htCpmm/F0tOzv6ELhRmLSi6PCtkghqQdAAiUDiofOIRgcixM8mWQNn2MYZfzkFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uf6nUENffppnofcZ5f/sASHzFGXvFUn/8SD/c9xq+rs=;
 b=cyj+xujGCGql5p/uCn44RHPsKvKI8PdIuF7vmnGIL06cBsZF2DuGV+DCFNb9fEI8pswy4Ux+85nELryvCe99vNFy9eqLtNjxif6MAuIZ6OTzdGQSk1VyT2sYs/N9eauPggXmS6aesPcTe7j3ylu90GDNXhApBUFelCTdMp+gt0eyoh0qcnof0Oq7KRG49oNdCd3jKVf5rtH0nHpmQCN1SygeqmxE1H0DSEYWx8J5fL9b/FcZ9jxSKMAng+f3ZhcFuL5zgXZXHYh0SNlKBVar23/PDgKtRaFI5exBzvonnbx9IcbPKoPk1uHq2Z75zbCyz3jHQoGT5jHHiMe6CvmZ6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uf6nUENffppnofcZ5f/sASHzFGXvFUn/8SD/c9xq+rs=;
 b=KSjHEgKE5fXJABDXUa+a5BrOI00QAoVTPegHCyQvOe4Rmv8RE3Z1GPsolwG/PmtLEaaHwuFJ2NMYc0LHJmG0x29xmjKJfqv3agIPzoXD0wCa2BVNBTovb7hbCN52WfVa6VtYSyGiYHiM/TfcpJvD0tu2aK6U6FvUOfShM93VPwA=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM5PR11MB2059.namprd11.prod.outlook.com (2603:10b6:3:8::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3455.23; Mon, 12 Oct 2020 18:34:50 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a%5]) with mapi id 15.20.3455.029; Mon, 12 Oct 2020
 18:34:50 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
CC:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm06cVdQZOfJAqUq6P9wAQIqk66mK1CSAgANvhACAAA4EgIABCC8AgABSpICAAASRAIAEohGg
Date:   Mon, 12 Oct 2020 18:34:50 +0000
Message-ID: <DM6PR11MB2841592688ADC7B8DD1B5896DD070@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006172317.GN1874917@unreal>
 <DM6PR11MB2841976B8E89C980CCC29AD2DD0B0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <CAPcyv4hoS7ZT_PPrXqFBzEHBKL-O4x1jHtY8x9WWesCPA=2E0g@mail.gmail.com>
 <7dbbc51c-2cbd-a7c5-69de-76f190f1d130@linux.intel.com>
 <CAPcyv4h24md531OYTVkHqzK7Nb0dJc5PHkLDSDywh8mYgrXBjg@mail.gmail.com>
 <a6eddd81-9746-aee7-3403-971c2b6286ef@linux.intel.com>
In-Reply-To: <a6eddd81-9746-aee7-3403-971c2b6286ef@linux.intel.com>
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
x-ms-office365-filtering-correlation-id: 3b2551b4-3f99-4f47-a07c-08d86edd811e
x-ms-traffictypediagnostic: DM5PR11MB2059:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB2059C632C4C4331C29E1359EDD070@DM5PR11MB2059.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KwXI583lJTpnZuKd9W7lYsgCIY8Z/EU+a80LKOx1OaRcArNHipBUJbtimeqge+4Sc3uKFMAspjbxRATnX2PzHClScujzGL7YTwUC0d1hpJNllqhM5LBTOXUIzcGqocbFQUrBau1HuDhX2QvPy+shuEvLUYALybA/UpPEqqjkRv2tQJAC45pawG/N1mv5w/ns2dR2gm3YjpWwL42i2SQUoKbeljKhNk/2u6ZpBpz1eB2RjUtHnkrZGCsSdsi8LVsrgVIkWduhFQvVdbpKz1Z7cyQdl2wN2uwUSlyLIF5tPityvhIi4h0hX7NBFeg5ckEqn0+xbsdd59FW9iFQc9KEST7/ytBgCqHqrjO1ayP2Tgc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(52536014)(8936002)(966005)(83380400001)(4326008)(86362001)(5660300002)(33656002)(7696005)(478600001)(26005)(71200400001)(9686003)(6636002)(2906002)(8676002)(186003)(110136005)(54906003)(7416002)(316002)(53546011)(6506007)(64756008)(66946007)(66446008)(76116006)(66476007)(66556008)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: wtVyzcr3kbAm4u0yngIU/luMVKlm3Beev+D865H29MMD8EoZPkJXm+wB/60q/3KfAOZsdGXL65J3w/WAWy/lxK+enC3sScmGS+D+4qnEL1lStSSP9JNwM8PK6fkCY+3STTRrV3jU6O6ztVOMS7ogEQqlRSMhyTr51UaxPnn31ngBVV5GB8A1PvLyLm/oG46aXHcfB4Iyvqb/VtPsCQcnLZfaPcL97FWGvltNgF6dzU3HqUYNm/qX7t3kuXLc1mHm3iz7C3TKfJyH4tNhbzVV6Jbqyd7NvChk52gOK31Pe9Aj+2J3QcVcTcDSJbClqAh3drorKIl/w4iujsFOPu/nODqb1mMvA9JG3zCFxpFDWj8hNktIz1I3WJUarMbc1QMOr/rdIe2H0KaoGLgLnOmrs0o4Cr3bZG7Pgztu4riSr7fWwG2ZbYBLDpks1APZ91MKYiQ015YUgEkifd3xZlQW7/iHnB+vEPS9+9S+IUZ1FiXF1yC92WVlWpsX6NEpEaKo5+/q1IBy4RvKq7dsvKvrSAiyMu9+cO3BwhLmp/347oqy+heTlC4eI6HsUqujbAz/OqUFkKGudh/T1DzOAJlVNIIr9Dz7x2ILwYZwdNG/Magn6TOGKkVjXHyuqH8l4Bg6n5vE15OZh0/U8Z8xk1uFQw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2841.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b2551b4-3f99-4f47-a07c-08d86edd811e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2020 18:34:50.4641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hmi+/l/5d+SJlPsFCHweGtz4z6+QcQHH7DJpbu5NXXTTlXGaZ1L1ykVvXNfcWAT3GajsWGzQ4+x/yOgPeONlwRjoC+wNdlSUYHGZsSvofEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB2059
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQaWVycmUtTG91aXMgQm9zc2Fy
dCA8cGllcnJlLWxvdWlzLmJvc3NhcnRAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBGcmlkYXks
IE9jdG9iZXIgOSwgMjAyMCAxMjozOSBQTQ0KPiBUbzogV2lsbGlhbXMsIERhbiBKIDxkYW4uai53
aWxsaWFtc0BpbnRlbC5jb20+DQo+IENjOiBFcnRtYW4sIERhdmlkIE0gPGRhdmlkLm0uZXJ0bWFu
QGludGVsLmNvbT47IGFsc2EtZGV2ZWxAYWxzYS0NCj4gcHJvamVjdC5vcmc7IHBhcmF2QG1lbGxh
bm94LmNvbTsgTGVvbiBSb21hbm92c2t5IDxsZW9uQGtlcm5lbC5vcmc+Ow0KPiB0aXdhaUBzdXNl
LmRlOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyByYW5qYW5pLnNyaWRoYXJhbkBsaW51eC5pbnRl
bC5jb207DQo+IGZyZWQub2hAbGludXguaW50ZWwuY29tOyBsaW51eC1yZG1hQHZnZXIua2VybmVs
Lm9yZzsNCj4gZGxlZGZvcmRAcmVkaGF0LmNvbTsgYnJvb25pZUBrZXJuZWwub3JnOyBqZ2dAbnZp
ZGlhLmNvbTsNCj4gZ3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc7IGt1YmFAa2VybmVsLm9yZzsg
U2FsZWVtLCBTaGlyYXoNCj4gPHNoaXJhei5zYWxlZW1AaW50ZWwuY29tPjsgZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldDsgUGF0aWwsIEtpcmFuDQo+IDxraXJhbi5wYXRpbEBpbnRlbC5jb20+DQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggdjIgMS82XSBBZGQgYW5jaWxsYXJ5IGJ1cyBzdXBwb3J0DQo+IA0KPiAN
Cj4gPj4+Pj4+ICsNCj4gPj4+Pj4+ICsgICBhbmNpbGRydi0+ZHJpdmVyLm93bmVyID0gb3duZXI7
DQo+ID4+Pj4+PiArICAgYW5jaWxkcnYtPmRyaXZlci5idXMgPSAmYW5jaWxsYXJ5X2J1c190eXBl
Ow0KPiA+Pj4+Pj4gKyAgIGFuY2lsZHJ2LT5kcml2ZXIucHJvYmUgPSBhbmNpbGxhcnlfcHJvYmVf
ZHJpdmVyOw0KPiA+Pj4+Pj4gKyAgIGFuY2lsZHJ2LT5kcml2ZXIucmVtb3ZlID0gYW5jaWxsYXJ5
X3JlbW92ZV9kcml2ZXI7DQo+ID4+Pj4+PiArICAgYW5jaWxkcnYtPmRyaXZlci5zaHV0ZG93biA9
IGFuY2lsbGFyeV9zaHV0ZG93bl9kcml2ZXI7DQo+ID4+Pj4+PiArDQo+ID4+Pj4+DQo+ID4+Pj4+
IEkgdGhpbmsgdGhhdCB0aGlzIHBhcnQgaXMgd3JvbmcsIHByb2JlL3JlbW92ZS9zaHV0ZG93biBm
dW5jdGlvbnMNCj4gc2hvdWxkDQo+ID4+Pj4+IGNvbWUgZnJvbSBhbmNpbGxhcnlfYnVzX3R5cGUu
DQo+ID4+Pj4NCj4gPj4+PiAgIEZyb20gY2hlY2tpbmcgb3RoZXIgdXNhZ2UgY2FzZXMsIHRoaXMg
aXMgdGhlIG1vZGVsIHRoYXQgaXMgdXNlZCBmb3INCj4gcHJvYmUsIHJlbW92ZSwNCj4gPj4+PiBh
bmQgc2h1dGRvd24gaW4gZHJpdmVycy4gIEhlcmUgaXMgdGhlIGV4YW1wbGUgZnJvbSBHcmV5YnVz
Lg0KPiA+Pj4+DQo+ID4+Pj4gaW50IGdyZXlidXNfcmVnaXN0ZXJfZHJpdmVyKHN0cnVjdCBncmV5
YnVzX2RyaXZlciAqZHJpdmVyLCBzdHJ1Y3QNCj4gbW9kdWxlICpvd25lciwNCj4gPj4+PiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zdCBjaGFyICptb2RfbmFtZSkNCj4gPj4+PiB7
DQo+ID4+Pj4gICAgICAgICAgIGludCByZXR2YWw7DQo+ID4+Pj4NCj4gPj4+PiAgICAgICAgICAg
aWYgKGdyZXlidXNfZGlzYWJsZWQoKSkNCj4gPj4+PiAgICAgICAgICAgICAgICAgICByZXR1cm4g
LUVOT0RFVjsNCj4gPj4+Pg0KPiA+Pj4+ICAgICAgICAgICBkcml2ZXItPmRyaXZlci5idXMgPSAm
Z3JleWJ1c19idXNfdHlwZTsNCj4gPj4+PiAgICAgICAgICAgZHJpdmVyLT5kcml2ZXIubmFtZSA9
IGRyaXZlci0+bmFtZTsNCj4gPj4+PiAgICAgICAgICAgZHJpdmVyLT5kcml2ZXIucHJvYmUgPSBn
cmV5YnVzX3Byb2JlOw0KPiA+Pj4+ICAgICAgICAgICBkcml2ZXItPmRyaXZlci5yZW1vdmUgPSBn
cmV5YnVzX3JlbW92ZTsNCj4gPj4+PiAgICAgICAgICAgZHJpdmVyLT5kcml2ZXIub3duZXIgPSBv
d25lcjsNCj4gPj4+PiAgICAgICAgICAgZHJpdmVyLT5kcml2ZXIubW9kX25hbWUgPSBtb2RfbmFt
ZTsNCj4gPj4+Pg0KPiA+Pj4+DQo+ID4+Pj4+IFlvdSBhcmUgb3ZlcndyaXRpbmcgcHJpdmF0ZSBk
ZXZpY2VfZHJpdmVyDQo+ID4+Pj4+IGNhbGxiYWNrcyB0aGF0IG1ha2VzIGltcG9zc2libGUgdG8g
bWFrZSBjb250YWluZXJfb2Ygb2YNCj4gYW5jaWxsYXJ5X2RyaXZlcg0KPiA+Pj4+PiB0byBjaGFp
biBvcGVyYXRpb25zLg0KPiA+Pj4+Pg0KPiA+Pj4+DQo+ID4+Pj4gSSBhbSBzb3JyeSwgeW91IGxv
c3QgbWUgaGVyZS4gIHlvdSBjYW5ub3QgcGVyZm9ybSBjb250YWluZXJfb2Ygb24gdGhlDQo+IGNh
bGxiYWNrcw0KPiA+Pj4+IGJlY2F1c2UgdGhleSBhcmUgcG9pbnRlcnMsIGJ1dCBpZiB5b3UgYXJl
IHJlZmVycmluZyB0byBnb2luZyBmcm9tDQo+IGRldmljZV9kcml2ZXINCj4gPj4+PiB0byB0aGUg
YXV4aWxpYXJ5X2RyaXZlciwgdGhhdCBpcyB3aGF0IGhhcHBlbnMgaW4gYXV4aWxpYXJ5X3Byb2Jl
X2RyaXZlcg0KPiBpbiB0aGUNCj4gPj4+PiB2ZXJ5IGJlZ2lubmluZy4NCj4gPj4+Pg0KPiA+Pj4+
IHN0YXRpYyBpbnQgYXV4aWxpYXJ5X3Byb2JlX2RyaXZlcihzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+
ID4+Pj4gMTQ1IHsNCj4gPj4+PiAxNDYgICAgICAgICBzdHJ1Y3QgYXV4aWxpYXJ5X2RyaXZlciAq
YXV4ZHJ2ID0gdG9fYXV4aWxpYXJ5X2RydihkZXYtPmRyaXZlcik7DQo+ID4+Pj4gMTQ3ICAgICAg
ICAgc3RydWN0IGF1eGlsaWFyeV9kZXZpY2UgKmF1eGRldiA9IHRvX2F1eGlsaWFyeV9kZXYoZGV2
KTsNCj4gPj4+Pg0KPiA+Pj4+IERpZCBJIG1pc3MgeW91ciBtZWFuaW5nPw0KPiA+Pj4NCj4gPj4+
IEkgdGhpbmsgeW91J3JlIG1pc3VuZGVyc3RhbmRpbmcgdGhlIGNhc2VzIHdoZW4gdGhlDQo+ID4+
PiBidXNfdHlwZS57cHJvYmUscmVtb3ZlfSBpcyB1c2VkIHZzIHRoZSBkcml2ZXIue3Byb2JlLHJl
bW92ZX0NCj4gPj4+IGNhbGxiYWNrcy4gVGhlIGJ1c190eXBlIGNhbGxiYWNrcyBhcmUgdG8gaW1w
bGVtZW50IGEgcGF0dGVybiB3aGVyZSB0aGUNCj4gPj4+ICdwcm9iZScgYW5kICdyZW1vdmUnIG1l
dGhvZCBhcmUgdHlwZWQgdG8gdGhlIGJ1cyBkZXZpY2UgdHlwZS4gRm9yDQo+ID4+PiBleGFtcGxl
ICdzdHJ1Y3QgcGNpX2RldiAqJyBpbnN0ZWFkIG9mIHJhdyAnc3RydWN0IGRldmljZSAqJy4gU2Vl
IHRoaXMNCj4gPj4+IGNvbnZlcnNpb24gb2YgZGF4IGJ1cyBhcyBhbiBleGFtcGxlIG9mIGdvaW5n
IGZyb20gcmF3ICdzdHJ1Y3QgZGV2aWNlDQo+ID4+PiAqJyB0eXBlZCBwcm9iZS9yZW1vdmUgdG8g
ZGF4LWRldmljZSB0eXBlZCBwcm9iZS9yZW1vdmU6DQo+ID4+Pg0KPiA+Pj4gaHR0cHM6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbmV4dC9saW51eC0NCj4gbmV4dC5n
aXQvY29tbWl0Lz9pZD03NTc5NzI3MzE4OWQNCj4gPj4NCj4gPj4gVGhhbmtzIERhbiBmb3IgdGhl
IHJlZmVyZW5jZSwgdmVyeSB1c2VmdWwuIFRoaXMgZG9lc24ndCBsb29rIGxpa2UgYSBhDQo+ID4+
IGJpZyBjaGFuZ2UgdG8gaW1wbGVtZW50LCBqdXN0IHdvbmRlcmluZyBhYm91dCB0aGUgYmVuZWZp
dHMgYW5kDQo+ID4+IGRyYXdiYWNrcywgaWYgYW55PyBJIGFtIGEgYml0IGNvbmZ1c2VkIGhlcmUu
DQo+ID4+DQo+ID4+IEZpcnN0LCB3YXMgdGhlIGluaXRpYWwgcGF0dGVybiB3cm9uZyBhcyBMZW9u
IGFzc2VydGVkIGl0PyBTdWNoIGNvZGUNCj4gPj4gZXhpc3RzIGluIG11bHRpcGxlIGV4YW1wbGVz
IGluIHRoZSBrZXJuZWwgYW5kIHRoZXJlJ3Mgbm90aGluZyBwcmV2ZW50aW5nDQo+ID4+IHRoZSB1
c2Ugb2YgY29udGFpbmVyX29mIHRoYXQgSSBjYW4gdGhpbmsgb2YuIFB1dCBkaWZmZXJlbnRseSwg
aWYgdGhpcw0KPiA+PiBjb2RlIHdhcyB3cm9uZyB0aGVuIHRoZXJlIGFyZSBvdGhlciBleGlzdGlu
ZyBidXNlcyB0aGF0IG5lZWQgdG8gYmUNCj4gdXBkYXRlZC4NCj4gPj4NCj4gPj4gU2Vjb25kLCB3
aGF0IGFkZGl0aW9uYWwgZnVuY3Rpb25hbGl0eSBkb2VzIHRoaXMgbW92ZSBmcm9tIGRyaXZlciB0
bw0KPiA+PiBidXNfdHlwZSBwcm92aWRlPyBUaGUgY29tbWl0IHJlZmVyZW5jZSBqdXN0IHN0YXRl
cyAnSW4gcHJlcGFyYXRpb24gZm9yDQo+ID4+IGludHJvZHVjaW5nIHNlZWQgZGV2aWNlcyB0aGUg
ZGF4LWJ1cyBjb3JlIG5lZWRzIHRvIGJlIGFibGUgdG8gaW50ZXJjZXB0DQo+ID4+IC0+cHJvYmUo
KSBhbmQgLT5yZW1vdmUoKSBvcGVyYXRpb25zIiwgYnV0IHRoYXQgZG9lc24ndCByZWFsbHkgaGVs
cCBtZQ0KPiA+PiBmaWd1cmUgb3V0IHdoYXQgJ2ludGVyY2VwdCcgbWVhbnMuIFdvdWxkIHlvdSBt
aW5kIGVsYWJvcmF0aW5nPw0KPiA+Pg0KPiA+PiBBbmQgbGFzdCwgdGhlIGV4aXN0aW5nIHByb2Jl
IGZ1bmN0aW9uIGRvZXMgY2FsbHMgZGV2X3BtX2RvbWFpbl9hdHRhY2goKToNCj4gPj4NCj4gPj4g
c3RhdGljIGludCBhbmNpbGxhcnlfcHJvYmVfZHJpdmVyKHN0cnVjdCBkZXZpY2UgKmRldikNCj4g
Pj4gew0KPiA+PiAgICAgICAgICBzdHJ1Y3QgYW5jaWxsYXJ5X2RyaXZlciAqYW5jaWxkcnYgPSB0
b19hbmNpbGxhcnlfZHJ2KGRldi0+ZHJpdmVyKTsNCj4gPj4gICAgICAgICAgc3RydWN0IGFuY2ls
bGFyeV9kZXZpY2UgKmFuY2lsZGV2ID0gdG9fYW5jaWxsYXJ5X2RldihkZXYpOw0KPiA+PiAgICAg
ICAgICBpbnQgcmV0Ow0KPiA+Pg0KPiA+PiAgICAgICAgICByZXQgPSBkZXZfcG1fZG9tYWluX2F0
dGFjaChkZXYsIHRydWUpOw0KPiA+Pg0KPiA+PiBTbyB0aGUgbmVlZCB0byBhY2Nlc3MgdGhlIHJh
dyBkZXZpY2Ugc3RpbGwgZXhpc3RzLiBJcyB0aGlzIHN0aWxsIGxlZ2l0DQo+ID4+IGlmIHRoZSBw
cm9iZSgpIGlzIG1vdmVkIHRvIHRoZSBidXNfdHlwZSBzdHJ1Y3R1cmU/DQo+ID4NCj4gPiBTdXJl
LCBvZiBjb3Vyc2UuDQo+ID4NCj4gPj4NCj4gPj4gSSBoYXZlIG5vIG9iamVjdGlvbiB0byB0aGlz
IGNoYW5nZSBpZiBpdCBwcmVzZXJ2ZXMgdGhlIHNhbWUNCj4gPj4gZnVuY3Rpb25hbGl0eSBhbmQg
cG9zc2libHkgZXh0ZW5kcyBpdCwganVzdCB3YW50ZWQgdG8gYmV0dGVyIHVuZGVyc3RhbmQNCj4g
Pj4gdGhlIHJlYXNvbnMgZm9yIHRoZSBjaGFuZ2UgYW5kIGluIHdoaWNoIGNhc2VzIHRoZSBidXMg
cHJvYmUoKSBtYWtlcw0KPiBtb3JlDQo+ID4+IHNlbnNlIHRoYW4gYSBkcml2ZXIgcHJvYmUoKS4N
Cj4gPj4NCj4gPj4gVGhhbmtzIGZvciBlbmxpZ2h0ZW5pbmcgdGhlIHJlc3Qgb2YgdXMhDQo+ID4N
Cj4gPiB0bDtkcjogVGhlIG9wcyBzZXQgYnkgdGhlIGRldmljZSBkcml2ZXIgc2hvdWxkIG5ldmVy
IGJlIG92ZXJ3cml0dGVuIGJ5DQo+ID4gdGhlIGJ1cywgdGhlIGJ1cyBjYW4gb25seSB3cmFwIHRo
ZW0gaW4gaXRzIG93biBvcHMuDQo+ID4NCj4gPiBUaGUgcmVhc29uIHRvIHVzZSB0aGUgYnVzX3R5
cGUgaXMgYmVjYXVzZSB0aGUgYnVzIHR5cGUgaXMgdGhlIG9ubHkNCj4gPiBhZ2VudCB0aGF0IGtu
b3dzIGJvdGggaG93IHRvIGNvbnZlcnQgYSByYXcgJ3N0cnVjdCBkZXZpY2UgKicgdG8gdGhlDQo+
ID4gYnVzJ3MgbmF0aXZlIHR5cGUsIGFuZCBob3cgdG8gY29udmVydCBhIHJhdyAnc3RydWN0IGRl
dmljZV9kcml2ZXIgKicNCj4gPiB0byB0aGUgYnVzJ3MgbmF0aXZlIGRyaXZlciB0eXBlLiBUaGUg
ZHJpdmVyIGNvcmUgZG9lczoNCj4gPg0KPiA+ICAgICAgICAgIGlmIChkZXYtPmJ1cy0+cHJvYmUp
IHsNCj4gPiAgICAgICAgICAgICAgICAgIHJldCA9IGRldi0+YnVzLT5wcm9iZShkZXYpOw0KPiA+
ICAgICAgICAgIH0gZWxzZSBpZiAoZHJ2LT5wcm9iZSkgew0KPiA+ICAgICAgICAgICAgICAgICAg
cmV0ID0gZHJ2LT5wcm9iZShkZXYpOw0KPiA+ICAgICAgICAgIH0NCj4gPg0KPiA+IC4uLnNvIHRo
YXQgdGhlIGJ1cyBoYXMgdGhlIGZpcnN0IHByaW9yaXR5IGZvciBwcm9iaW5nIGEgZGV2aWNlIC8N
Cj4gPiB3cmFwcGluZyB0aGUgbmF0aXZlIGRyaXZlciBvcHMuIFRoZSBidXMgLT5wcm9iZSwgaW4g
YWRkaXRpb24gdG8NCj4gPiBvcHRpb25hbGx5IHBlcmZvcm1pbmcgc29tZSBidXMgc3BlY2lmaWMg
cHJlLXdvcmssIGxldHMgdGhlIGJ1cyB1cGNhc3QNCj4gPiB0aGUgZGV2aWNlIHRvIGJ1cy1uYXRp
dmUgdHlwZS4NCj4gPg0KPiA+IFRoZSBidXMgYWxzbyBrbm93cyB0aGUgdHlwZXMgb2YgZHJpdmVy
cyB0aGF0IHdpbGwgYmUgcmVnaXN0ZXJlZCB0byBpdCwNCj4gPiBzbyB0aGUgYnVzIGNhbiB1cGNh
c3QgdGhlIGRldi0+ZHJpdmVyIHRvIHRoZSBuYXRpdmUgdHlwZS4NCj4gPg0KPiA+IFNvIHdpdGgg
YnVzX3R5cGUgYmFzZWQgZHJpdmVyIG9wcyBkcml2ZXIgYXV0aG9ycyBjYW4gZG86DQo+ID4NCj4g
PiBzdHJ1Y3QgYXV4aWxpYXJ5X2RldmljZV9kcml2ZXIgYXV4ZHJ2IHsNCj4gPiAgICAgIC5wcm9i
ZSA9IGZuKHN0cnVjdCBhdXhpbGlhcnlfZGV2aWNlICosIDxhbnkgYXV4IGJ1cyBjdXN0b20gcHJv
YmUNCj4gYXJndW1lbnRzPikNCj4gPiB9Ow0KPiA+DQo+ID4gYXV4aWxpYXJ5X2RyaXZlcl9yZWdp
c3RlcigmYXV4ZHJ2KTsgPC0tIHRoZSBjb3JlIGNvZGUgY2FuIGhpZGUgYnVzIGRldGFpbHMNCj4g
Pg0KPiA+IFdpdGhvdXQgYnVzX3R5cGUgdGhlIGRyaXZlciBhdXRob3Igd291bGQgbmVlZCB0byBk
bzoNCj4gPg0KPiA+IHN0cnVjdCBhdXhpbGlhcnlfZGV2aWNlX2RyaXZlciBhdXhkcnYgew0KPiA+
ICAgICAgLmRydiA9IHsNCj4gPiAgICAgICAgICAucHJvYmUgPSBmbihzdHJ1Y3QgZGV2aWNlICop
LCA8LS0gbm8gb3Bwb3J0dW5pdHkgZm9yIGJ1cw0KPiA+IHNwZWNpZmljIHByb2JlIGFyZ3MNCj4g
PiAgICAgICAgICAuYnVzID0gJmF1eGlsYXJ5X2J1c190eXBlLCA8LS0gdW5uZWNlc3NhcnkgZXhw
b3J0IHRvIGRldmljZSBkcml2ZXJzDQo+ID4gICAgICB9LA0KPiA+IH07DQo+ID4NCj4gPiBkcml2
ZXJfcmVnaXN0ZXIoJmF1eGRydi5kcnYpDQo+IA0KPiBUaGFua3MgRGFuLCBJIGFwcHJlY2lhdGUg
dGhlIGV4cGxhbmF0aW9uLg0KPiANCj4gSSBndWVzcyB0aGUgbWlzdW5kZXJzdGFuZGluZyBvbiBt
eSBzaWRlIHdhcyB0aGF0IGluIHByYWN0aWNlIHRoZSBkcml2ZXJzDQo+IG9ubHkgZGVjbGFyZSBh
IHByb2JlIGF0IHRoZSBhdXhpbGlhcnkgbGV2ZWw6DQo+IA0KPiBzdHJ1Y3QgYXV4aWxpYXJ5X2Rl
dmljZV9kcml2ZXIgYXV4ZHJ2IHsNCj4gICAgICAuZHJ2ID0gew0KPiAgICAgICAgICAubmFtZSA9
ICJteSBkcml2ZXIiDQo+ICAgICAgICAgIDw8PCAucHJvYmUgbm90IHNldCBoZXJlLg0KPiAgICAg
IH0NCj4gICAgICAucHJvYmUgPSAgZm4oc3RydWN0IGF1eGlsaWFyeV9kZXZpY2UgKiwgaW50IGlk
KSwNCj4gfQ0KPiANCj4gSXQgbG9va3MgaW5kZWVkIGNsZWFuZXIgd2l0aCB5b3VyIHN1Z2dlc3Rp
b24uIERhdmVFIGFuZCBJIHdlcmUgdGFsa2luZw0KPiBhYm91dCB0aGlzIG1vbWVudHMgYWdvIGFu
ZCBtYWRlIHRoZSBjaGFuZ2UsIHdpbGwgYmUgdGVzdGluZyBsYXRlciB0b2RheS4NCj4gDQo+IEFn
YWluIHRoYW5rcyBmb3IgdGhlIHdyaXRlLXVwIGFuZCBoYXZlIGEgbmljZSB3ZWVrLWVuZC4NCj4g
DQoNCkxpa2UgUGllcnJlIHNhaWQsIEkgaGF2ZSBhbHJlYWR5IGNoYW5nZWQgdGhlIHByb2JlLCBy
ZW1vdmUsIGFuZCBzaHV0ZG93biBjYWxsYmFja3MNCmludG8gdGhlIGJ1c190eXBlLg0KDQpCdXQg
aXQgc2hvdWxkIGJlIG5vdGVkIHRoYXQgeW91IGFyZSBub3Qgc3VwcG9zZWQgdG8gaGF2ZSB0aGVz
ZSBjYWxsYmFja3MgaW4gYm90aCB0aGUNCmF1eGRydi0+ZHJ2LT4qIGFuZCBpbiB0aGUgYnVzLT4q
Lg0KDQppbiBkcml2ZXJzL2Jhc2UvZHJpdmVyLmMgbGluZSAxNTggaXQgY2hlY2tzIGZvciB0aGlz
Og0KDQppZiAoKGRydi0+YnVzLT5wcm9iZSAmJiBkcnYtPnByb2JlKSB8fA0KICAgICAgICAgICAg
IChkcnYtPmJ1cy0+cmVtb3ZlICYmIGRydi0+cmVtb3ZlKSB8fA0KICAgICAgICAgICAgIChkcnYt
PmJ1cy0+c2h1dGRvd24gJiYgZHJ2LT5zaHV0ZG93bikpDQogICAgICAgICAgICAgICAgIHByX3dh
cm4oIkRyaXZlciAnJXMnIG5lZWRzIHVwZGF0aW5nIC0gcGxlYXNlIHVzZSAiDQogICAgICAgICAg
ICAgICAgICAgICAgICAgImJ1c190eXBlIG1ldGhvZHNcbiIsIGRydi0+bmFtZSk7DQoNClNvLCBj
aGFuZ2luZyB0byB0aGUgYnVzX3R5cGUgZm9yIHRoZXNlIGlzIHRoZSByaWdodCB0aGluZyB0byBk
bywgYnV0IGRyaXZlciB3cml0ZXJzIG5lZWQgdG8NCm1ha2Ugc3VyZSB0aGF0IGF1eGRydi0+ZHJ2
LT5bcHJvYmV8cmVtb3ZlfHNodXRkb3duXSBhcmUgTlVMTC4NCg0KLURhdmVFDQoNCg0KDQo=
