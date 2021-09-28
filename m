Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360BF41BA15
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 00:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243066AbhI1WTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 18:19:31 -0400
Received: from mga18.intel.com ([134.134.136.126]:26913 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242626AbhI1WT2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 18:19:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="211899690"
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="211899690"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 15:17:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="708086985"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga005.fm.intel.com with ESMTP; 28 Sep 2021 15:17:47 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 28 Sep 2021 15:17:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 28 Sep 2021 15:17:47 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 28 Sep 2021 15:17:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ChKvXY8qJyKQe2KLTTTUNVvHd5AHSjmQKQsBqk6tXhyy7zGJUpQdZwD6LOsgHD+n1vBTCJBFqU2mxj8r3cPgBmCMx4tRtmwJJLnkOmZVhaW38rnUDsDCLD8OwYVaIXwTu9Wu90C3h42CtQFHoj8De7aHXsit/DIpUEtpwWdNnLUGmGtvI0KxEy3g9yxoNTlCwq6/sMzxOZklzKlqjKOyL3xVJb/d8J6MT2RWiQznACkEJuobI9NwiAlu18pvXYgEevGfYeoI1mQlQ0WnFUEVmlZrHxNgEu++5XJpnQ6OGfpWyr6awtvt6MXLdiAFtakpBWAuNdqieRO0QJrdkMztfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rHNzzcq5EegSO25e45fpPsFVPf8jF1rzhsio/hBLupQ=;
 b=MyHGCNZDWJgjjJj4NNYkjpXREoKsfd6aZPtjzOL7V8KzALoyE9HRRhJXRB8CMp8WkTM8XgxftiulUXLUJncuTnMvaYo5hy8tlvzbSO3jVVFsl8jgUoZrSoew3DF+Ng3q3gwPFQCxuH+VFqHObU3QvhloSGwDHBBaf6fYqcvTfyBe3FrdSJx1XHJwI4KhxdVklCRfPM/3f5sMuB6RvHUYBEoRxN2b2u2rtnl1baROjCBbVByvW3Mb5NM7P2nw4HNeEe4KGQ9Vn62DGTmc4Er5JgrPfjR0wte9RkkKEepUATBh8uumJjlS/Aljw0VZd4fmtcrn2hX32pMBui3X5Zye3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHNzzcq5EegSO25e45fpPsFVPf8jF1rzhsio/hBLupQ=;
 b=wXcc49dIkXR85CVNLe4HQsPKPK1jv9WDRXGv0rzfrZLjWK3Sol/6vm6OL3r83lw44hlURQzI3+ZHE5wPSH6sEFsJ8O1PnnK3Jn9SUxxsOFdQ2CdZU9nzUJ3M+eG18i7KZC1ZV/drh633LfDChW8juLINW6jZFdCLR9A3TwAIoNM=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB4778.namprd11.prod.outlook.com (2603:10b6:806:119::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 22:17:43 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d0d5:c84e:41b8:a9e4]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d0d5:c84e:41b8:a9e4%3]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 22:17:43 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kerneljasonxing@gmail.com" <kerneljasonxing@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kafai@fb.com" <kafai@fb.com>, "hawk@kernel.org" <hawk@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>, "yhs@fb.com" <yhs@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
CC:     lkp <lkp@intel.com>,
        "xingwanli@kuaishou.com" <xingwanli@kuaishou.com>,
        "lishujin@kuaishou.com" <lishujin@kuaishou.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7] ixgbe: let the xdpdrv work with more than 64 cpus
Thread-Topic: [PATCH v7] ixgbe: let the xdpdrv work with more than 64 cpus
Thread-Index: AQHXqsYBB7K5pIpN6UGmH8YehheZr6u6GO8A
Date:   Tue, 28 Sep 2021 22:17:43 +0000
Message-ID: <a1ea0abaadc59bdbc6504a64bae594b059c26cdf.camel@intel.com>
References: <20210901101206.50274-1-kerneljasonxing@gmail.com>
         <CAL+tcoCOnCpxLXLyAxb+BgumQBpo2PPqSQXY=Xvs-8R48Om=cw@mail.gmail.com>
In-Reply-To: <CAL+tcoCOnCpxLXLyAxb+BgumQBpo2PPqSQXY=Xvs-8R48Om=cw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e782ac5-7f03-4d63-4af7-08d982cdcae6
x-ms-traffictypediagnostic: SA2PR11MB4778:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB47785CCAC7941DACCC4459D4C6A89@SA2PR11MB4778.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mX9GrezKUCI4cjNZ10PK0biYGW1rMqJXP3xQyXT8Y0BVxZu6GoPR796sE+Lci+Ok3KUUP2tDl/kQQ+Yl22y3X8AG2hM3he2YFfEs0Q73uDBDTrg8Vrm5o6JKLi8gZ44B0Ft65cyqcweN6O7rEIMbF2mMGmPR+JH4/wweQSNt9bccHV/qIVor23nHVGmmvgVcyMPVZN2Pc2PRXrKRpbwpJuEm0lETBg1Sa5Q2q8sKvL30do70wJx5LlwEPV6jDGid09E3GVvSMbwnS0k+tjCr6t2IyQDs8zHvdqyPJWNJZzAQgh9ViZr0i01aNuCFpkT43axQWlikyjkq4GglWdJX0XPH4KrrhglfynLyp3wb635jSDWeGEAljjtG74xc+/YKlnLeSaV4fjkjXRZpQYs5nkKrlvxfL62m/erztHilJArl3p8uI0JIF+kfGWhde2f3jiLoYDxe5Gih8PMHl3P0EkNrEcGu6jGCQLPH8j+z5kaQDVQcwkK3GBbZUrzztIOoSufbRZBDe8qIj0WM0RBIhrvh1B20uwMqWJRQX61+iRXQnIFe8eEG0MDrMUAvOHGMC99KIcBIYMF2lDKQ8n6bhNKrsir4HEoSawzvUfisVrpl94bp7ecYntPnny3J1GJgpHz00YrDwuZFNvnrqTXLgWGX/pNaof8FtMmrZ1xFRa89WJWPrzPGKHFR0Yzu9kMGUscqAuCtlPxrV1DOom3uw11Vh8dweYP0ryal/f+rdPk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(38100700002)(54906003)(8676002)(36756003)(2906002)(122000001)(86362001)(38070700005)(186003)(26005)(508600001)(5660300002)(8936002)(316002)(71200400001)(2616005)(7416002)(66476007)(66446008)(64756008)(66556008)(53546011)(921005)(4326008)(6506007)(76116006)(6512007)(6486002)(83380400001)(91956017)(66946007)(40753002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SHd2NWd2SHRJT3VEWVNZdDIwZmo1amFnQUJVYWN2eVc2RmNHb0s1YSszRUY2?=
 =?utf-8?B?bGJoaEJLOWdhOVd4bjlkODM4ZWlXNkxaclkzZUhpZUpsc2VJbE9LaGltVmty?=
 =?utf-8?B?eW1lRkJ4b3pSMlBIRXJqdG5GWFQvaVRwaXQyM2ZhWjdGNVRRQWRqMkRyKzJU?=
 =?utf-8?B?ejJkQ3cyYnkrUUxEMWcyUGwzQ3NnMXVoN2dEaHFjR0toRCtVZHZ5dWhZRHho?=
 =?utf-8?B?bWswUFZvN3g2b0V0STNMRWllaHM0WUdneDZCOFNoWTV5R2RXbDFBeXJtTCtG?=
 =?utf-8?B?WitycEdNdUhmQ1ZENldZd1g0MndzcnZiOFpHcDE3aEk4eTJUMzVteDNtWVpV?=
 =?utf-8?B?aVFZVHZVTG1kRWl2RHdKUHhuRkdzdXNzUnJBSmtpd2xGMU1uem1zaG9oUTNI?=
 =?utf-8?B?dWhJd2R6UEJlQWZpRGFCWFZXTDVNMksxNjM4eE0vb05DUHdFNlJWUmpxejdY?=
 =?utf-8?B?MHVvNi85TzJXOVljVUlxZEcxaFNDSXd1R3p3VEd2S0N3aFFMT2s0T1VJRlhV?=
 =?utf-8?B?NVpzVFNJZ05ocXZqcnJIMnB4SDkxR0hBNUszd2NUVWxXNjdiR3dzbXBvcGp2?=
 =?utf-8?B?bjJJTjBrV0ZqZHhvVlptTDFDeVlieE5OS1d2UHE3MUJwMEdTWDNiYnFLcXZF?=
 =?utf-8?B?YWNNcHZrVUhWTit3MFYyVFBnWmtycUtLYk1KV3p5ZWN6SWhKdkNDc1VJNmto?=
 =?utf-8?B?N3dVdThnMTZuNnorMFlGN2t2RWdDVjBYNkdxL29nNjFtejFXMzZOUGJjeFVl?=
 =?utf-8?B?SnZXVDlINHlhcjY2SVlBQXRITVd2UGZGUng2MElDeGVrYXo3ZkFLSlVxWSt3?=
 =?utf-8?B?YmRoVDNTN0k0Qzk0cWZxOWZxL2N2SlVKMkJsd2ozMStwWWNlT284cGZIQXpv?=
 =?utf-8?B?d3FlUlhraFN4dFN2ZU94aHY1a1Z2QU90TTdsZDZIKzY4d1B6aGtLcWdHR242?=
 =?utf-8?B?U1FwRkxrM1pSSkJRNHVKM1JpMFZkSTFQWnBGcU04akJZS1FUcTlPQVE3ZjFw?=
 =?utf-8?B?VzRBYVV6alBTTVdLbGt2SE96SlJIRzRiZnJETFFwVnRic2hPOG5aekQ0UWM1?=
 =?utf-8?B?RVh3N3diS3cxUzg3aHp5MDVPNjJNUVBzVWxnVU5GenBlSEF0VnQwR3JEUDhM?=
 =?utf-8?B?c1pHcDhLY0NYWHVaMkpQZGY0L1pxR2twVHBTMVNnMGpaWVRRNm4vaEFuSTkw?=
 =?utf-8?B?QWtaQjdGZjZDZnlOUHRzeG5zUWNieEtVRkJJbWdtZ2FpZDE1SzNNNm12ZkJI?=
 =?utf-8?B?bzUvSlpkMlAvdkpIRGtiZmlseXRaUE5FY3hqcVlkcXowaWI0Z2syNTQxSVBR?=
 =?utf-8?B?VmhubktObUVtQjdMWVluS09RVTRpTHJqQ2F5TmpDK3VuY0ZHNnVsM1FHOGo4?=
 =?utf-8?B?NmFhaVkvMmtZcVB0ZkoyVUtwalFmWmd3WFdUaUtmTGp2VFVVVG4va3R1OHdx?=
 =?utf-8?B?UEtLYjRYVGlZZGtuaTZabWg3cGkxajh6eVN6REZIdG1GeS9YQ0VicHQ3Rzda?=
 =?utf-8?B?RUpPVll2YWpUK1ViZTUwZHNmdVdNaTk4Qm1NZTVLbU5oQ2cwWms1T0Zmak9U?=
 =?utf-8?B?YW43eDVPanVoQlU4dkRpN0NLendWWi9Nd3dqNTZteFUzQVNSNStRRGN3bVVh?=
 =?utf-8?B?Zk9oQlFVZFR6T20zY1VKd1EvSEdSRHpoSTRGVFdqSnJnMUhjbVYwNlJ3ME53?=
 =?utf-8?B?NE04ajE0cS9SUWxyKzIrYnd0NmVZczBPZHRobkk3Y0grUGZad3BIeGk3bDRl?=
 =?utf-8?Q?OZB0oe6XaQmq+fPIBYQlk2ODStercMz9gXD4se1?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <018942165E8363409C35B3C4B4BC709A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e782ac5-7f03-4d63-4af7-08d982cdcae6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 22:17:43.2253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TApKAE9KwWU9zAGl0V/6I+ltwqoqb8uA29HuHWTOF9Eek1VFSUjWG45DhzvVFZDmOZ5wM9b0brR2cDTlUUc+MlTolJ0HIbjNG0r8cALL6TA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4778
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTA5LTE2IGF0IDE0OjQxICswODAwLCBKYXNvbiBYaW5nIHdyb3RlOg0KPiBI
ZWxsbyBndXlzLA0KPiANCj4gYW55IHN1Z2dlc3Rpb25zIG9yIGNvbW1lbnRzIG9uIHRoaXMgdjcg
cGF0Y2g/DQo+IA0KPiBUaGFua3MsDQo+IEphc29uDQo+IA0KPiBPbiBXZWQsIFNlcCAxLCAyMDIx
IGF0IDY6MTIgUE0gPGtlcm5lbGphc29ueGluZ0BnbWFpbC5jb20+IHdyb3RlOg0KPiA+IEZyb206
IEphc29uIFhpbmcgPHhpbmd3YW5saUBrdWFpc2hvdS5jb20+DQo+ID4gDQo+ID4gT3JpZ2luYWxs
eSwgaXhnYmUgZHJpdmVyIGRvZXNuJ3QgYWxsb3cgdGhlIG1vdW50aW5nIG9mIHhkcGRydiBpZg0K
PiA+IHRoZQ0KPiA+IHNlcnZlciBpcyBlcXVpcHBlZCB3aXRoIG1vcmUgdGhhbiA2NCBjcHVzIG9u
bGluZS4gU28gaXQgdHVybnMgb3V0DQo+ID4gdGhhdA0KPiA+IHRoZSBsb2FkaW5nIG9mIHhkcGRy
diBjYXVzZXMgdGhlICJOT01FTSIgZmFpbHVyZS4NCj4gPiANCj4gPiBBY3R1YWxseSwgd2UgY2Fu
IGFkanVzdCB0aGUgYWxnb3JpdGhtIGFuZCB0aGVuIG1ha2UgaXQgd29yayB0aHJvdWdoDQo+ID4g
bWFwcGluZyB0aGUgY3VycmVudCBjcHUgdG8gc29tZSB4ZHAgcmluZyB3aXRoIHRoZSBwcm90ZWN0
IG9mDQo+ID4gQHR4X2xvY2suDQo+ID4gDQo+ID4gSGVyZSdyZSBzb21lIG51bWJlcnMgYmVmb3Jl
L2FmdGVyIGFwcGx5aW5nIHRoaXMgcGF0Y2ggd2l0aCB4ZHAtDQo+ID4gZXhhbXBsZQ0KPiA+IGxv
YWRlZCBvbiB0aGUgZXRoMFg6DQo+ID4gDQo+ID4gQXMgY2xpZW50ICh0eCBwYXRoKToNCj4gPiAg
ICAgICAgICAgICAgICAgICAgICBCZWZvcmUgICAgQWZ0ZXINCj4gPiBUQ1BfU1RSRUFNIHNlbmQt
NjQgICA3MzQuMTQgICAgNzE0LjIwDQo+ID4gVENQX1NUUkVBTSBzZW5kLTEyOCAgMTQwMS45MSAg
IDEzOTUuMDUNCj4gPiBUQ1BfU1RSRUFNIHNlbmQtNTEyICA1MzExLjY3ICAgNTI5Mi44NA0KPiA+
IFRDUF9TVFJFQU0gc2VuZC0xayAgIDkyNzcuNDAgICA5MzU2LjIyIChub3Qgc3RhYmxlKQ0KPiA+
IFRDUF9SUiAgICAgc2VuZC0xICAgIDIyNTU5Ljc1ICAyMTg0NC4yMg0KPiA+IFRDUF9SUiAgICAg
c2VuZC0xMjggIDIzMTY5LjU0ICAyMjcyNS4xMw0KPiA+IFRDUF9SUiAgICAgc2VuZC01MTIgIDIx
NjcwLjkxICAyMTQxMi41Ng0KPiA+IA0KPiA+IEFzIHNlcnZlciAocnggcGF0aCk6DQo+ID4gICAg
ICAgICAgICAgICAgICAgICAgQmVmb3JlICAgIEFmdGVyDQo+ID4gVENQX1NUUkVBTSBzZW5kLTY0
ICAgMTQxNi40OSAgIDEzODMuMTINCj4gPiBUQ1BfU1RSRUFNIHNlbmQtMTI4ICAzMTQxLjQ5ICAg
MzA1NS41MA0KPiA+IFRDUF9TVFJFQU0gc2VuZC01MTIgIDk0ODguNzMgICA5NDg3LjQ0DQo+ID4g
VENQX1NUUkVBTSBzZW5kLTFrICAgOTQ5MS4xNyAgIDkzNTYuMjIgKG5vdCBzdGFibGUpDQo+ID4g
VENQX1JSICAgICBzZW5kLTEgICAgMjM2MTcuNzQgIDIzNjAxLjYwDQo+ID4gLi4uDQo+ID4gDQo+
ID4gTm90aWNlOiB0aGUgVENQX1JSIG1vZGUgaXMgdW5zdGFibGUgYXMgdGhlIG9mZmljaWFsIGRv
Y3VtZW50DQo+ID4gZXhwbGFpbmVzLg0KPiA+IA0KPiA+IEkgdGVzdGVkIG1hbnkgdGltZXMgd2l0
aCBkaWZmZXJlbnQgcGFyYW1ldGVycyBjb21iaW5lZCB0aHJvdWdoDQo+ID4gbmV0cGVyZi4NCj4g
PiBUaG91Z2ggdGhlIHJlc3VsdCBpcyBub3QgdGhhdCBhY2N1cmF0ZSwgSSBjYW5ub3Qgc2VlIG11
Y2ggaW5mbHVlbmNlDQo+ID4gb24NCj4gPiB0aGlzIHBhdGNoLiBUaGUgc3RhdGljIGtleSBpcyBw
bGFjZXMgb24gdGhlIGhvdCBwYXRoLCBidXQgaXQNCj4gPiBhY3R1YWxseQ0KPiA+IHNob3VsZG4n
dCBjYXVzZSBhIGh1Z2UgcmVncmVzc2lvbiB0aGVvcmV0aWNhbGx5Lg0KPiA+IA0KPiA+IEZpeGVz
OiAzM2ZkYzgyZjA4ICgiaXhnYmU6IGFkZCBzdXBwb3J0IGZvciBYRFBfVFggYWN0aW9uIikNCg0K
SGkgSmFzb24sDQoNClRoZSBwYXRjaCBkb2Vzbid0IGhhdmUgYW4gZXhwbGljaXQgdGFyZ2V0IG9m
IG5ldCBvciBuZXQtbmV4dC4gSSBhc3N1bWUNCnNpbmNlIHlvdSBwdXQgYSBGaXhlcyB0YWcgeW91
J3JlIHdhbnRpbmcgaXQgdG8gZ28gdGhyb3VnaCBuZXQsIGhvd2V2ZXIsDQp0aGlzIHNlZW1zIG1v
cmUgbGlrZSBhbiBpbXByb3ZlbWVudCB0aGF0IHNob3VsZCBnbyB0aHJvdWdoIG5ldC1uZXh0Lg0K
UGxlYXNlIGxldCBtZSBrbm93IGlmIHlvdSBkaXNhZ3JlZSwgb3RoZXJ3aXNlIEkgd2lsbCBzZW5k
IHRvIG5ldC1uZXh0Lg0KDQpUaGFua3MsDQpUb255DQoNCj4gPiBSZXBvcnRlZC1ieToga2VybmVs
IHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+DQo+ID4gQ28tZGV2ZWxvcGVkLWJ5OiBTaHVqaW4g
TGkgPGxpc2h1amluQGt1YWlzaG91LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTaHVqaW4gTGkg
PGxpc2h1amluQGt1YWlzaG91LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBKYXNvbiBYaW5nIDx4
aW5nd2FubGlAa3VhaXNob3UuY29tPg0KPiANCg==
