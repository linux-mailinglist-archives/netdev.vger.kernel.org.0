Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4379416E31
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 10:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244796AbhIXIul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 04:50:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:23652 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244871AbhIXIuh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 04:50:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10116"; a="211271180"
X-IronPort-AV: E=Sophos;i="5.85,319,1624345200"; 
   d="scan'208";a="211271180"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2021 01:49:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,319,1624345200"; 
   d="scan'208";a="455423251"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga002.jf.intel.com with ESMTP; 24 Sep 2021 01:49:02 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 24 Sep 2021 01:49:01 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 24 Sep 2021 01:49:01 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 24 Sep 2021 01:49:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TL7qzTUXf/NJ0J3Y2VvSLhyquLbW4uXsd+d26yMUT01pi4VDCfEy7waxQ0BQF2FmVbLO83Wh6uPfsSTSWirsOb/ZKooPANyRH94dllMMwYXa0IJZxl6k8YbC9nO2Cza6YkZJVwkGJo/WDVUeQHgJ8fCd6aE/NzjM7g/D+DerpxpaeB0IPDLntPw9Fn1gdqeNw3PeO+m0ALST9NszsZufxvqWWOTy1RpdDMvz82N8O3E5+X7L2TLqQqD1BfX/8lStlxqL2BZhrr3cGRoMe0tTW4GudKPiQvVxnEG1R3/S8oN1Ls9tK+eRMU4BMZNB+RmB+6II9oChmjbLrOxHiG7ULg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=F2Q9r5tlu0aMjdrntrs+FQHKPRMW3eZb7Wvo+GcaC+M=;
 b=Jw1UmlzZd2VD4SRjEWjQoIvUacWz56/cvruP9SFFYVmsOINl7/1gTSum699FbiTHA1aipXypewWYYL6mhsFOGOA7fFwowaPn5+TnfPSRxlvUxNkvgza5ml5nY7a4qM8hOFhkGIZ6GhoUpeskK61J1I19jexeDsmtwC4MriC45BJzHx9VGexLHqFt4gVMO/EE4HK0UhZ83IfPihNoyryJ2s3tERwGzGr+xzqEK6iMRAKAEDwTgzCMzbLEBQnZwoZOd1s7gpK8VWwvh/wQQPy2dmhJanzrZ7QkCvjDi+FPjncjO1owSMRBIjFqBLkCKfOa9RwAf2c+LNjUC6JXmAlXOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2Q9r5tlu0aMjdrntrs+FQHKPRMW3eZb7Wvo+GcaC+M=;
 b=wxVZ4Yzm34kW0+gTAIwnoE6F32pKUqo2QaDgM18nEpf4orns9lTx3rX7WMUIWNiXlKwQlejMWe1b2sMZd3B3EFxAB7kRoybuhni8op3+nDd7gGiny6y0dDq9rVivns0h+ylc+Jq7kmHonqPRCYVp+RqtSjwJTSYowsZ17kYjOzc=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BYAPR11MB2854.namprd11.prod.outlook.com (2603:10b6:a02:c9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Fri, 24 Sep
 2021 08:48:59 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::582c:29ff:d42b:ac52]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::582c:29ff:d42b:ac52%6]) with mapi id 15.20.4544.013; Fri, 24 Sep 2021
 08:48:59 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "vladimir.zapolskiy@linaro.org" <vladimir.zapolskiy@linaro.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "felash@gmail.com" <felash@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] iwlwifi: pcie: add configuration of a Wi-Fi adapter on
 Dell XPS 15
Thread-Topic: [PATCH v2] iwlwifi: pcie: add configuration of a Wi-Fi adapter
 on Dell XPS 15
Thread-Index: AQHXsIjSc3mRlFN9WkO3yXaqPJ8to6uy4PUA
Date:   Fri, 24 Sep 2021 08:48:59 +0000
Message-ID: <fcdb371094870ef2cbb599e20b4a35512efbd4d6.camel@intel.com>
References: <20210923143840.2226042-1-vladimir.zapolskiy@linaro.org>
In-Reply-To: <20210923143840.2226042-1-vladimir.zapolskiy@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.3-1 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7484b119-9eb7-405f-b733-08d97f3826f8
x-ms-traffictypediagnostic: BYAPR11MB2854:
x-microsoft-antispam-prvs: <BYAPR11MB2854592FC94199DE138A6F6090A49@BYAPR11MB2854.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9ABS4GY/zxmqKp0H5UHj/5cudq20JMLwnMqkBH5UDy77zj4Tt+civcMIvIH4FtVhuOeo0YR+w2qwto2VgvcCuOFzH0TN2bEzuzg8o5B0M+Dct4T0zy8g/EtdNbIgQVH0yub7zdRnjdNZDne6ZFBLOrcYFD/ilGuJ5oQn1RFXJI2LynEGFSpyIzXyqBdGzrGP+fr5VIeBG5g8HwOPeKxmf3BEdGykUeqK6I/6p/TY4lqr/zkSO7XX8Xji4C7K4ZySM4W7fV8q89w7tAzsZ9ukuHagFyRFZOSsBSs/r8dD6L9LwlY5wg1/GMPnDncMi1MtOX0gBETFgYD7VjSIh3FWF5SRA+WG1zRzP22C5HGqZKVgf/Wng1568VjLa+7LODUfx5Isol0mR5tnvwIiG2s93seHm6DA2HHYs1tI4v/QQstGqjzcLQocwKBjn2QPjhqQCoAixw1XIp/tHtip3IJEiUASllhhHARL4Zvc4AvCOBwPXyQ6EEvTiIsOGW5C13m+v4O9RKkNKoZQBaBsHkcHGsjDgLXrddihQcX9A9nDYZBQeeKJ36qIJAzbBqUA24LaIGNFrWHpFv4HJdMSsnRa0MdDQcUBqHOsKDgc8W+rSs3Md8Vhd2+gi4GO2wRob5C5zsTLfWMI0d6Wd//gg/AkNpl+oLPNBQgxdE9GmnPMzbU5cA1OyK658YwK+OqaC5KZ/unCuM5vDc8VYbEJKAvO9DYF3lyQMyraeDTwd74AXWNGXtorpBhozzI0K555NgL23dQCZPRFCThWLURMiqp4vnAmahv9ShHrhmI/45cQhng=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(54906003)(26005)(186003)(4326008)(38070700005)(8936002)(6506007)(8676002)(2616005)(71200400001)(6486002)(2906002)(5660300002)(91956017)(86362001)(66556008)(66946007)(316002)(64756008)(66476007)(508600001)(966005)(122000001)(110136005)(76116006)(66446008)(38100700002)(36756003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZEhiSXJsbHVMR3ZYK1RnUS93RXNSay9oQnljQlREdWxmcmhSRjFCQ2FNWmZ1?=
 =?utf-8?B?RlhRTnYwVTBqMWFqb1UvR3dCRkZ2T2F5Nm9iYVRqUno3elJiaDdzcHJUSDQ3?=
 =?utf-8?B?M0JPSGYyN2VXRUwweHpVd1BISkdVTFdJVGk3MzZaa3B3TUszaU9ETHNFNU1z?=
 =?utf-8?B?eVpsZmR3RWVCTE1IZEl6YWJaR1d2MmQrVW9RSHVGL3ZvT3haUUZadlgwSHlM?=
 =?utf-8?B?a3hDeVJhcnlwdFhwUEpabHJuTW1SeGIxVW41OWNqYWY2L3hNQXFNOHE0bTMy?=
 =?utf-8?B?bmszcXdSaFJLR2dVNEw4clJmN0tUK2ZsaXBHNXBrR2kwc1BpeFkyeTc0ZzFD?=
 =?utf-8?B?MXQ3Z1lnak5hR1hUb3dFWW5TTElqRnJZNUI1WmliZm1kZmFkeTVsbXRXWTJS?=
 =?utf-8?B?aEVTa2pha2hCQUZBRFh0cVNtd2tMUnJhZ1NNNzQ5Y1JtNS9BYmRDT0lWWHlJ?=
 =?utf-8?B?S01uOVh6VEhpV1NOcGt4amZNYk5aYk5ZQTc2dE1pN0ExQjkwaFJreWRJRXJH?=
 =?utf-8?B?UHN3ajM5ZGpBd1pmeVRhb21zNmoyMU40TTFBczJuMzkyeUtrUmw4dHZGeVhP?=
 =?utf-8?B?SUk3dUc5TCtTdUhvbytDZnhYT1JxYVBnYitKWDMxY0swUFhYSlp3NnRheTZV?=
 =?utf-8?B?ZWlYN21EZ3JYVFZmdGtCK0owZVlkT1A5Rit2SVovSTA4a21iN2ExRDFxNGd3?=
 =?utf-8?B?NGoxSHRjOXM0djJqcVVjQjh2d2xQbDVlSkhlaktmemFhTGdKcU9kRitlWnlr?=
 =?utf-8?B?bXFUcGpaWFJ0TDQ2Sjhmdmk3MUltaFhWaGErTWc3SVl4WFFXLzVwSnpCNXJ2?=
 =?utf-8?B?bG9WdmRuem9FV3ZtYWlzWTB1MnhrQzYxbXVkZW83VVVvN1ZqZ3o3T1Uveld5?=
 =?utf-8?B?M2sxZGZvbTU0anJFemxweXBmWDFBVzhoUjdJL2dRc1dWZktFUG56QXZhQ2Jn?=
 =?utf-8?B?OFBaTkpRMUYxMmIySzdzSFVpaEZIOTNBYnZlY3JQRlRvbDhVUnhRcmZDTllj?=
 =?utf-8?B?bDVUZ2hvQTRpbkJhcjVwRC9kM3NHdU5JZ25QUEtiMEE5d05lOGRhcXBEcnpj?=
 =?utf-8?B?cUVJVzBacCtEN1ltN3FsMjB2aHJZS3dYbjhUN1BsWXF6L1dDT01BQjdBR0hp?=
 =?utf-8?B?ODNTUld2WkJpZjd4NjhSMzl5N1VKN1NkWjdqUmowNEhqSlFTTEw3Z0R1YXN3?=
 =?utf-8?B?V3hWQXE5OUVIRXhTUlVoZEx2cnZyaFBCMWh6OWVySU1KZkxBZnJhU2k5M0Fi?=
 =?utf-8?B?cXpQR3p6OTNCUDh2OEl6RzZFVENheU9nU1lITFpVVyt3MHRJWEZzM0tDa1BE?=
 =?utf-8?B?MmdvaXdJL1Jad0MwRUdVbWxUWVg0U2xsTlhqWXZ6Slg5a0V6dGdTVGViY2ha?=
 =?utf-8?B?RzVLeEVoLzVSYytCdUFkNVN4RDN2cFlOeWk0c2lqZHZuaUE3dzhUK05qVkRn?=
 =?utf-8?B?RGVPZ2pMN2wyRE9ZY2ZaK3BYbys3UXdReGdoNUw2WitTZFNDcDZXSEpQcWpt?=
 =?utf-8?B?SlUxM29Telp4bCtVVEZDdHRLZm9ZRHVkTlBrOC9iZzh6MUVLa2gvQitWMENT?=
 =?utf-8?B?SHYvUHFxVEZ5OVc2MHhRdk5LM0ovd01PaE95Y1M1OThxVm1GNTJZczEvdG5k?=
 =?utf-8?B?NnhjYmhJNTYya1lvRVplZnFET295b2FWMnI1K2JSOVMvR3I2RkxUQjlJd2ho?=
 =?utf-8?B?dzM0QmkzbjJoRFM4MjZSOEVLTHgrU3hNR3YwOUhhWjNmU054RzVKbXIxaUN1?=
 =?utf-8?B?aytXbTZCb1IxUzhsUE94SFpXRDhXYnp1KzljNXBKY2JIdTBYaXBnaTluWFRM?=
 =?utf-8?B?VThRMERvTjdZcUhMSTBtUT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0DD7C82ACB0ED041AF5A708ADEDDB67A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7484b119-9eb7-405f-b733-08d97f3826f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2021 08:48:59.6886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h9nDQxLjCbSA2NShzU24c3o9X35wHN7PHjNlNKxCTg6faVzeno2a4D8HFEUZdXIzT1+N9wTEfjjQZtvxrEWicy+ghiC0UvWECvf105dvYps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2854
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTA5LTIzIGF0IDE3OjM4ICswMzAwLCBWbGFkaW1pciBaYXBvbHNraXkgd3Jv
dGU6DQo+IFRoZXJlIGlzIGEgS2lsbGVyIEFYMTY1MCAyeDIgV2ktRmkgNiBhbmQgQmx1ZXRvb3Ro
IDUuMSB3aXJlbGVzcyBhZGFwdGVyDQo+IGZvdW5kIG9uIERlbGwgWFBTIDE1ICg5NTEwKSBsYXB0
b3AsIGl0cyBjb25maWd1cmF0aW9uIHdhcyBwcmVzZW50IG9uDQo+IExpbnV4IHY1LjcsIGhvd2V2
ZXIgYWNjaWRlbnRhbGx5IGl0IGhhcyBiZWVuIHJlbW92ZWQgZnJvbSB0aGUgbGlzdCBvZg0KPiBz
dXBwb3J0ZWQgZGV2aWNlcywgbGV0J3MgYWRkIGl0IGJhY2suDQo+IA0KPiBUaGUgcHJvYmxlbSBp
cyBtYW5pZmVzdGVkIG9uIGRyaXZlciBpbml0aWFsaXphdGlvbjoNCj4gDQo+IMKgwqBJbnRlbChS
KSBXaXJlbGVzcyBXaUZpIGRyaXZlciBmb3IgTGludXgNCj4gwqDCoGl3bHdpZmkgMDAwMDowMDox
NC4zOiBlbmFibGluZyBkZXZpY2UgKDAwMDAgLT4gMDAwMikNCj4gwqDCoGl3bHdpZmk6IE5vIGNv
bmZpZyBmb3VuZCBmb3IgUENJIGRldiA0M2YwLzE2NTEsIHJldj0weDM1NCwgcmZpZD0weDEwYTEw
MA0KPiDCoMKgaXdsd2lmaTogcHJvYmUgb2YgMDAwMDowMDoxNC4zIGZhaWxlZCB3aXRoIGVycm9y
IC0yMg0KPiANCj4gQnVnOiBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dp
P2lkPTIxMzkzOQ0KPiBGaXhlczogM2Y5MTBhMjU4MzliICgiaXdsd2lmaTogcGNpZTogY29udmVy
dCBhbGwgQVgxMDEgZGV2aWNlcyB0byB0aGUgZGV2aWNlIHRhYmxlcyIpDQo+IENjOiBKdWxpZW4g
V2Fqc2JlcmcgPGZlbGFzaEBnbWFpbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFZsYWRpbWlyIFph
cG9sc2tpeSA8dmxhZGltaXIuemFwb2xza2l5QGxpbmFyby5vcmc+DQo+IC0tLQ0KPiBDaGFuZ2Vz
IGZyb20gdjEgdG8gdjI6DQo+ICogbW92ZWQgdGhlIGFkZGVkIGxpbmVzIGluIGEgd2F5IHRvIHBy
ZXNlcnZlIGEgbnVtZXJpY2FsIG9yZGVyIGJ5IGRldmlkLg0KPiANCj4gwqBkcml2ZXJzL25ldC93
aXJlbGVzcy9pbnRlbC9pd2x3aWZpL3BjaWUvZHJ2LmMgfCAyICsrDQo+IMKgMSBmaWxlIGNoYW5n
ZWQsIDIgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2ludGVsL2l3bHdpZmkvcGNpZS9kcnYuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVs
L2l3bHdpZmkvcGNpZS9kcnYuYw0KPiBpbmRleCA2MWIyNzk3YTM0YTguLjM3NDRjNWU3NjUxOSAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9wY2llL2Ry
di5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvcGNpZS9kcnYu
Yw0KPiBAQCAtNTQ3LDYgKzU0Nyw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgaXdsX2Rldl9pbmZv
IGl3bF9kZXZfaW5mb190YWJsZVtdID0gew0KPiDCoAlJV0xfREVWX0lORk8oMHg0M0YwLCAweDAw
NzQsIGl3bF9heDIwMV9jZmdfcXVfaHIsIE5VTEwpLA0KPiDCoAlJV0xfREVWX0lORk8oMHg0M0Yw
LCAweDAwNzgsIGl3bF9heDIwMV9jZmdfcXVfaHIsIE5VTEwpLA0KPiDCoAlJV0xfREVWX0lORk8o
MHg0M0YwLCAweDAwN0MsIGl3bF9heDIwMV9jZmdfcXVfaHIsIE5VTEwpLA0KPiArCUlXTF9ERVZf
SU5GTygweDQzRjAsIDB4MTY1MSwga2lsbGVyMTY1MHNfMmF4X2NmZ19xdV9iMF9ocl9iMCwgTlVM
TCksDQoNCkluc3RlYWQgb2YgTlVMTCBhdCB0aGUgZW5kLCBwbGVhc2UgdXNlIGl3bF9heDIwMV9r
aWxsZXJfMTY1MHNfbmFtZS4NCg0KPiArCUlXTF9ERVZfSU5GTygweDQzRjAsIDB4MTY1Miwga2ls
bGVyMTY1MGlfMmF4X2NmZ19xdV9iMF9ocl9iMCwgTlVMTCksDQoNCi4uLmFuZCBpd2xfYXgyMDFf
a2lsbGVyXzE2NTBpX25hbWUgaGVyZS4NCg0KDQotLQ0KQ2hlZXJzLA0KTHVjYS4NCg==
