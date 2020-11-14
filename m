Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F692B29C2
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgKNAQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:16:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:62937 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgKNAQQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 19:16:16 -0500
IronPort-SDR: grtiK6GhA6EOkdrdtZHc18OXp1Dj80zF1jiwyElzrUes1nIlFKjuuhQsu5D5we7zVZZrUQ8bof
 bZue+fanzsUQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="157570051"
X-IronPort-AV: E=Sophos;i="5.77,477,1596524400"; 
   d="scan'208";a="157570051"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 16:15:48 -0800
IronPort-SDR: xo3tiDcU+tc+pEz6XUr5oASJmtxM7O4YU7LF1fPE5gf6IsUozNpRnUyg+T01u6I26PKBkPbai3
 kQBtKRFdRmbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,477,1596524400"; 
   d="scan'208";a="531210650"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 13 Nov 2020 16:15:48 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Nov 2020 16:15:47 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Nov 2020 16:15:47 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 13 Nov 2020 16:15:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uv3THd/YM+Y4/qcxpzpwFPwsuZ3oocBmW6x7np/UJRh/jK1FLxrR0+znzeZT5b8JSNzfc3i6/veOgj7aLIFbsRId2WV1Tt+aurY5MIb20W3s8gzgOvSn2WaWrGrlLrXDNhqhVHonZ3f8Tme3vXs02bSbXo/TAcdzS8B7ETpxeQK+mJ+s4vi3foOZnKtIIBaqgykYWHW4E2t78yObnMbYUEW8txVI7u6hAQuOwDhJZVJFDesYEGdyW6cYHhyQIle5uIi8CHAl1yBF0cXM1UuU+DKzslbpfEuPRCBlIG2zzLbYiJ2rcT91GA4C8NIUDgb6c0sceXIy7IXHJ3o2NgbTqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OCTxPHarGNIQ/c0EIvJQ0x01uu0aK+SYOab8V44sYNg=;
 b=kWZx46a6mpPc6XXWz0/e7VjQSlgbbZ+wLvJPQFu5s4dfYPh1zePlr+sWoWLig/BrddPNJoohu8TDX+mGF7CrBJ1HHV8DK4hmr/v0xys03/VZzZq6YaaO0U8JJYJbyonkygZGYpp87mW4Q85ub6sjEBTiWo63QFUD3DU0nos8RqYuVwDRbDOU9H1XiAsgmvgQ1JKKgnmy65iraOHlb2m6vc8YXPk1srYEFoou/Yv8BOi96/8m2e03SohtJzCvTJrDBvNSs67h2G81wci6w6hjDvS7AfxOWU6eb/XJIkWUZQXuZxVprS/kNA80o57olynyM3LkAPL4g0vyNY3HOxlNpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OCTxPHarGNIQ/c0EIvJQ0x01uu0aK+SYOab8V44sYNg=;
 b=NnVS2crxHDz3VxHbdBFdk/Hq1HhPJw4/Fap1MGVXey+PshNzMcmzw9poiTFWGmOfjMZovwuK/viMm2TctHrAeHeNxtAnESEBgBDMLljwO5xR1fWVvVZfzegDoXy0b/frfIBxLLUk+264d5+X09pd+I9XIffylk0uCj1MCP9aog4=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA0PR11MB4720.namprd11.prod.outlook.com (2603:10b6:806:72::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Sat, 14 Nov
 2020 00:15:46 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::c5ab:6fa3:709e:c335]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::c5ab:6fa3:709e:c335%6]) with mapi id 15.20.3541.025; Sat, 14 Nov 2020
 00:15:46 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>
CC:     "Cao, Chinh T" <chinh.t.cao@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Valiquette, Real" <real.valiquette@intel.com>,
        "davem@davemloft.neti" <davem@davemloft.neti>,
        "Bokkena, HarikumarX" <harikumarx.bokkena@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: Re: [net-next v2 03/15] ice: initialize ACL table
Thread-Topic: [net-next v2 03/15] ice: initialize ACL table
Thread-Index: AQHWugTN2PgKVq4Hz0mWIQi9/ulnP6nGrTgAgAAVVYA=
Date:   Sat, 14 Nov 2020 00:15:46 +0000
Message-ID: <2c35ef3950756f0ea04fb61246b2c9b22859d3d4.camel@intel.com>
References: <20201113213407.2131340-1-anthony.l.nguyen@intel.com>
         <20201113213407.2131340-4-anthony.l.nguyen@intel.com>
         <CAKgT0UcEd4BmyMxBmy2D2vVCWKu3Q=0iYKZ2UTdAPg0gitSiCQ@mail.gmail.com>
In-Reply-To: <CAKgT0UcEd4BmyMxBmy2D2vVCWKu3Q=0iYKZ2UTdAPg0gitSiCQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7e64cdc-71da-413a-bb71-08d888326f1d
x-ms-traffictypediagnostic: SA0PR11MB4720:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB4720BE4FD20D2091D964E806C6E50@SA0PR11MB4720.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RTRLcJweU08H1/efwrLxkmMj3mrB0jtm6ifuMExovGEp5paRAc0l+eBW3reF45Opm2/Mz77iRzb5IAaV6SZSl7Mm/iYbktWFQYeOUTIp3YzEApGPlpPoBWtap54f0b9Oi6TyqGVAxH099Y0LCLwAbQQv5QFnHJ7E6l9enqqFP+M7r5vYeazCWKxGSNV4J3lMj0XWCQqq5OdAmOxRBmQg/DM8BVISKNNk1chD6LihuHs+mfGStJt1c7KMEpoBDqACgH8yibEziEJrgmKnRUnfnadHxv01+nKlnbeu5R3hiQO1A/Njc5wL/rC+gJJt3EnZ8UneiVnvHhtU5eV+wxCGz/Z8/7zSHN6TsfRQMUBvwyTeQqdN2GqmSJcfUQ1YU3du
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(5660300002)(91956017)(66476007)(83380400001)(66556008)(54906003)(71200400001)(6916009)(66946007)(4001150100001)(64756008)(86362001)(76116006)(66446008)(6486002)(186003)(2906002)(4326008)(26005)(8676002)(8936002)(478600001)(6512007)(316002)(2616005)(53546011)(6506007)(36756003)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: AVa5HzmfoIxTmD3i13WPZrD/me7y5EAoJgLg+W7G5aQPzVYfaNfK5j3+vIktgP3W1DJ4nfKvu8PQfJQyNTGsuQ4ljvGF3lspiTsHf4DCOlSpxiaI/Jdygw8q/tO6+iu3BQFmt8bosxvKrOwbsQg6s00izExVSAxerdxZEm3XQT7CLZkSfpjbo35dZiWIzo9pJ+0JlLkiZa4FDCqyDwKdLPTvSOFxhn3v7n2Tu0hUKfnJxqKl8MmT7o+BMm1ViHAYarARkFY6HZtO2l1eToCenY1JdTfavqUcyYID9tUInp32rW7l3OOv57Gw6n382xU/K3mTBRdBXQCwuQfBSe7IXmZkFqOhP6jY2H0Z+POT7NH59K11rQWPFUE7NtDWlx/KqzLwx7K4kF9EW49DGprQMhgMfY5xXczRRhDsoU3lW0gu8m152p6ujk40VKrC7qNfJrj6mrvfQzE7Uu+tvUSfgCXqxDaZMo7rr/PG3YN7hyKdQ1D7UiEd1vySWCD3fZHhBNYZojFXBjxLoXzrVo4zCaaDbRczUwCi9pPEn497F2tSlutkgURXiJ6XrKGTXpMmRfqvDpdg5x8OZP6YCQoMdKVeUBzD7Jo7MWCCp9UtaY/MG/IWl0kaqijZTzIOU3FdzgJQGG1hwlOGBj/0TM/DFct05RwUAdy+SJtX3HCyQPpqXCskiW8jTpHwJF9ToaIc5uZJf96mM/+gEnzQVLMtr2Cw2wd8K9ys+L/PWhCWIj1fg2GobHgwBroeLaNAhfi+ArsZLbI+L73J2F/2Tu6uQloLV/LmKSUKYjRcQH2vsMLEufam/1j8cgE2r3eU3zA9R4iV7yMtHQkZhlCIn51sty6qfiWjKVkUQJj0Zj2rN434K+63qPoZjMWOH2VIKP0T806X0VDy1rMCCdpJCPE+FA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <6526846B504C3A478E322971905FD782@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e64cdc-71da-413a-bb71-08d888326f1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2020 00:15:46.6077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p2Bu2gWR4E0WJpem2PSzzpo7FFnKbQphP98B3K9f6rMULPLzMCzo5l8+/G2pIdKJ+Q3RnTwICg6BROxnbpf3eLGxjTCGLHXF7H2GmsrWXsQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4720
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTExLTEzIGF0IDE0OjU5IC0wODAwLCBBbGV4YW5kZXIgRHV5Y2sgd3JvdGU6
DQo+IE9uIEZyaSwgTm92IDEzLCAyMDIwIGF0IDE6MzYgUE0gVG9ueSBOZ3V5ZW4gPA0KPiBhbnRo
b255Lmwubmd1eWVuQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gRnJvbTogUmVhbCBWYWxp
cXVldHRlIDxyZWFsLnZhbGlxdWV0dGVAaW50ZWwuY29tPg0KPiA+IA0KPiA+IEFDTCBmaWx0ZXJp
bmcgY2FuIGJlIHV0aWxpemVkIHRvIGV4cGFuZCBzdXBwb3J0IG9mIG50dXBsZSBydWxlcyBieQ0K
PiA+IGFsbG93aW5nDQo+ID4gbWFzayB2YWx1ZXMgdG8gYmUgc3BlY2lmaWVkIGZvciByZWRpcmVj
dCB0byBxdWV1ZSBvciBkcm9wLg0KPiA+IA0KPiA+IEltcGxlbWVudCBzdXBwb3J0IGZvciBzcGVj
aWZ5aW5nIHRoZSAnbScgdmFsdWUgb2YgZXRodG9vbCBudHVwbGUNCj4gPiBjb21tYW5kDQo+ID4g
Zm9yIGN1cnJlbnRseSBzdXBwb3J0ZWQgZmllbGRzIChzcmMtaXAsIGRzdC1pcCwgc3JjLXBvcnQs
IGFuZCBkc3QtDQo+ID4gcG9ydCkuDQo+ID4gDQo+ID4gRm9yIGV4YW1wbGU6DQo+ID4gDQo+ID4g
ZXRodG9vbCAtTiBldGgwIGZsb3ctdHlwZSB0Y3A0IGRzdC1wb3J0IDg4ODAgbSAweDAwZmYgYWN0
aW9uIDEwDQo+ID4gb3INCj4gPiBldGh0b29sIC1OIGV0aDAgZmxvdy10eXBlIHRjcDQgc3JjLWlw
IDE5Mi4xNjguMC41NSBtIDAuMC4wLjI1NQ0KPiA+IGFjdGlvbiAtMQ0KPiA+IA0KPiA+IEF0IHRo
aXMgdGltZSB0aGUgZm9sbG93aW5nIGZsb3ctdHlwZXMgc3VwcG9ydCBtYXNrIHZhbHVlczogdGNw
NCwNCj4gPiB1ZHA0LA0KPiA+IHNjdHA0LCBhbmQgaXA0Lg0KPiANCj4gU28geW91IHNwZW5kIGFs
bCBvZiB0aGUgcGF0Y2ggZGVzY3JpcHRpb24gZGVzY3JpYmluZyBob3cgdGhpcyBtaWdodA0KPiBi
ZQ0KPiB1c2VkIGluIHRoZSBmdXR1cmUuIEhvd2V2ZXIgdGhlcmUgaXMgbm90aGluZyBzcGVjaWZp
YyB0byB0aGUgZXRodG9vbA0KPiBpbnRlcmZhY2UgYXMgZmFyIGFzIEkgY2FuIHRlbGwgYW55d2hl
cmUgaW4gdGhpcyBwYXRjaC4gV2l0aCB0aGlzDQo+IHBhdGNoDQo+IHRoZSBhY3R1YWwgY29tbWFu
ZCBjYWxsZWQgb3V0IGFib3ZlIGNhbm5vdCBiZSBwZXJmb3JtZWQsIGNvcnJlY3Q/DQo+IA0KPiA+
IEJlZ2luIGltcGxlbWVudGF0aW9uIG9mIEFDTCBmaWx0ZXJzIGJ5IHNldHRpbmcgdXAgc3RydWN0
dXJlcywNCj4gPiBBZG1pblENCj4gPiBjb21tYW5kcywgYW5kIGFsbG9jYXRpb24gb2YgdGhlIEFD
TCB0YWJsZSBpbiB0aGUgaGFyZHdhcmUuDQo+IA0KPiBUaGlzIHNlZW1zIHRvIGJlIHdoYXQgdGhp
cyBwYXRjaCBpcyBhY3R1YWxseSBkb2luZy4gWW91IG1heSB3YW50IHRvDQo+IHJld3JpdGUgdGhp
cyBwYXRjaCBkZXNjcmlwdGlvbiB0byBmb2N1cyBvbiB0aGlzIGFuZCBleHBsYWluIHRoYXQgeW91
DQo+IGFyZSBlbmFibGluZyBmdXR1cmUgc3VwcG9ydCBmb3IgZXRodG9vbCBudHVwbGUgbWFza3Mu
IEhvd2V2ZXIgc2F2ZQ0KPiB0aGlzIGZlYXR1cmUgZGVzY3JpcHRpb24gZm9yIHRoZSBwYXRjaCB0
aGF0IGFjdHVhbGx5IGVuYWJsZXMgdGhlDQo+IGZ1bmN0aW9uYWxpdHkuDQoNClRoYW5rcyBmb3Ig
dGhlIGZlZWRiYWNrIEFsZXguIEkgYmVsaWV2ZSB5b3UncmUgc3RpbGwgcmV2aWV3aW5nIHRoZQ0K
cGF0Y2hlcywgSSdsIGxvb2sgdGhyb3VnaCBhbmQgbWFrZSBjaGFuZ2VzIGFjY29yZGluZ2x5IG9y
IGdldCByZXNwb25zZXMNCmFzIG5lZWVkZWQuDQoNClRoYW5rcywNClRvbnkNCg==
