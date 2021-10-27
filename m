Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B1843CE02
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242850AbhJ0P4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:56:30 -0400
Received: from mga12.intel.com ([192.55.52.136]:57717 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238504AbhJ0P4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 11:56:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10150"; a="210273983"
X-IronPort-AV: E=Sophos;i="5.87,187,1631602800"; 
   d="scan'208";a="210273983"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 08:52:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,187,1631602800"; 
   d="scan'208";a="447272493"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 27 Oct 2021 08:52:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 27 Oct 2021 08:52:04 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 27 Oct 2021 08:52:03 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 27 Oct 2021 08:52:03 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 27 Oct 2021 08:51:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/8ulbSAGczCZEpfN+Yn02sF1YoKCvQu07ZRWfYvDTDdYG3VuUbiigTb4p/hCQ/HFoHxkSqKHFPQtkPUdKEpdJdx36cBO0q3y9JYLvDffkw168ws5L+3ASLAm3rFfPSchqlW09EuUVQ1LK7WuV4A9dMr6m8fwVqNQ3EAz91tw+4SsBfjk4ZptPH0Vm+4cDlF6//Xvi9icNBpoTmNXLQfBYbkIYwtHRrEiIXzslCzpes36yRlkcNoQylZZBtl50RbVS9xxmmEXf/gRASYlMFLZ0EpUlJn+9yYQyK4m3KcKI4HVFNqINDr+I9CBc4oXk9UHPWV9XBsOgAngKRvGH+b+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RR+7JY3gBhjq8u8j6aL7LiBnUyJIOOz+erN7F3UI4wc=;
 b=S4vf2vzk55v1B59MMLrtU0KB5Bz18qspGWT8L51EdtHBIoWQR+9GqeRgWlzFlzmJbmDqGxRYPEudKVhAA15rRzM1Qv3huYRhHJ8uGwZ7czPb3D/RGBmkaHYyDnVqYQJ5oM5O5lmpi6BCcjcjgQi2HqczxBDQKprUIwEzIGVY0vVOR98PQk9WprkqwIMY1wUOKRWKi/9feE11ShY811363A2GigwbYcGtB3uM/EtMnsT572adOdFMoizUVED3mduyPPL18WPPYddV3JNXP9C0WuHzj9f0iovFm/8ajJN+leITRpX8coCpt6kxLejQX4t8vDz6y9pcIT0QP47dQsVUJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RR+7JY3gBhjq8u8j6aL7LiBnUyJIOOz+erN7F3UI4wc=;
 b=ur8Uc17dw8nkRmw450o782xjl/B+zPgHNI4Lx2L/W3yh/H5nYvgAiDFL9j5lvA2OFUWqsRwBS7cISr0m6uIJygxJlEhtQdRjCc/YuB8remQeN+8cjIrgdGXYYHKeWZaVRr/VLqdC+kkk/XJLAXWInJ76SRY2+Sf1RuzctFrhX0A=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB2926.namprd11.prod.outlook.com (2603:10b6:805:ce::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Wed, 27 Oct
 2021 15:51:58 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d0d5:c84e:41b8:a9e4]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::d0d5:c84e:41b8:a9e4%3]) with mapi id 15.20.4628.018; Wed, 27 Oct 2021
 15:51:58 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4][pull request] 40GbE Intel Wired LAN Driver
 Updates 2021-10-25
Thread-Topic: [PATCH net-next 0/4][pull request] 40GbE Intel Wired LAN Driver
 Updates 2021-10-25
Thread-Index: AQHXycm5B6G1XxJZ+kmwEdGEBASPVavnAR0A
Date:   Wed, 27 Oct 2021 15:51:58 +0000
Message-ID: <30be4834a75836d450995199b7675054561b1996.camel@intel.com>
References: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211025175508.1461435-1-anthony.l.nguyen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b97e65f9-d648-4967-a411-08d99961b555
x-ms-traffictypediagnostic: SN6PR11MB2926:
x-microsoft-antispam-prvs: <SN6PR11MB292689A2E997A321A6D2E015C6859@SN6PR11MB2926.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: svpNxGbj0+iWVzYUJMPb48b3AUIyNL/flCfKsjYbaWl0Vgx91ziDzqU2oLbQfBSfVto2oSINK7+UWygaMyksLR07g1y930ZxJ+N3e/IUISWXjnbFI9fsP1o5CZHz0MSK07Iy7HruEl/Um8lUkmQHLQO90W29xLB3GarluM2Hh9L9o+I/UHkQbOUn4Rl61kXxuV5KyMfTlIFJYFSurLxKFgIm/y63VfiPXR+Ri/6kp/dBXpioiz1Gnhl+zVx7V4p/HVSqYLWStPq/XEHv4vJoVxL7WNL8oaH+FujKOXZmwhjd/8f8i4K4wg7ynVR6TE0B7SjoBZ/hZOvoizz89q0UkjHVndYTGagzKSM4dgnvRyIdevkzUNENTM3ehDT566saSfOme16Vh9/mKG0TVXA6+iQ+URvkxyrNjQ1v4cz7VPhCzm1KLFj83Yty5ECGKRvvh9PQMi/V7XKz/iinNmJxIVFbh+gkIIs40fz3/XdF8EwzNmMlhZiS2pRdrP7L+7H1Ebee6U//On/A18Cx0o1umKgLZpH/hfpMhIpO9JklyAo7gjvrQls7r6PjCmNFrR6shfmY0sTDbMrZB4KdviYILw/xyWI9DNDn8GWhcBUJOgXn88qOG0tQioJbmo4Pyg5yiidxXCuc5UCRGiAg7lrCbabskCFsdR3uccH5Vg93KzgsEtolO1vnhumiuJeXgur428Ag9vsHuaNtSabETwComp21qgL11UlRuBGX/2gepKElVHCmvm5vjCjNyuQOLoUXTLyyZ9LK84Efy3EKIrVJREo9CCd49FdtanMUwYNkyW4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(6486002)(6506007)(8676002)(316002)(4326008)(82960400001)(122000001)(66446008)(508600001)(64756008)(4744005)(86362001)(4001150100001)(110136005)(91956017)(76116006)(186003)(66574015)(36756003)(83380400001)(966005)(8936002)(66476007)(2906002)(6512007)(2616005)(66946007)(26005)(71200400001)(38070700005)(5660300002)(15650500001)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QjFDS3Y0aUhNU0xqaVpmOHE0TUVXa1V6MWJJeXJMMzg5RThCMitvNC9rcERs?=
 =?utf-8?B?T09VWkorN2tYUnJXYWJ5eDNheUE4U1lsNEYrd0l4b0RCenpTREluaE1vdFo2?=
 =?utf-8?B?Z25nS3dEOFhEbUJQclYzSTBNUHprSmYwMWtNT0t5RjFPR1FleVhoU3NubU54?=
 =?utf-8?B?VlZ5K0NoOTRoUEZoRGNnd0l4bmRaUkpNSDExc0IwY0hST29pNVRXa01RbVZv?=
 =?utf-8?B?Y1liWlpucnlzOGJPeHQ1QkhaTUY5ZHNFelN2dlJmckgvNWxtYlZMQ3IzVEp2?=
 =?utf-8?B?azhjVnNUdUsxdjJyd0tYY1NBci9NdmVNUjZ5cGNSeTBmZ3B0ZHNHZjAzR1F0?=
 =?utf-8?B?OEZ3cHlOZHc5Y1AydUtqTzkvMkpsNk5oMVNnZktZVy9PYlo2TnIrTXFIZzhw?=
 =?utf-8?B?VlVaSmZZTEw5THdSYzlWeHpGdG5yUHhoU2ppVmVxVXZWWkNIK1BGVy90aklK?=
 =?utf-8?B?eUg2TXVpMWdOMk9MK1FLd2Ixci9HdWVFTkRSQTVQMXhpbk1COGJPVVJiN1M2?=
 =?utf-8?B?THhudjVyZGpBeHRrMHZnR1FJTEd3SGxGVWYzcHUrU0FpcHhhZEFsYzJTc2hB?=
 =?utf-8?B?am1mWnJOamplNWc4L0prUUJPbmZKRGZQR3c3Uk1vQzJQallIZ1JVNjd6TUUr?=
 =?utf-8?B?UkJEMW8vSFkydGZuSFlJUHVBMGZIRnR1WitrSTEzVzd6Ti9qbzcxV21jY0Vi?=
 =?utf-8?B?RTgvUms4QnQ0OTF2dXdRWGRoeGJBSHNhT2U1cVZZWUIwTEptRDRNL3IyNlFE?=
 =?utf-8?B?ODFyWFRISXhHS2NzdXJEdWlzdWpjMFpmaGo3SGNLYW13Z09GQyt2WWd4T005?=
 =?utf-8?B?MGFpdlM5cmpOVmt2Y3U3N0hDdUxpVDNuVVZWV1lORGMyQTVhdG55SGF4VUFi?=
 =?utf-8?B?VmM4a1FEc056cnZ4dStjcE5NTC81RDdnSmVWK000VDg5OTRyc0F1dkFyQytY?=
 =?utf-8?B?aXB3VlpSL21ONkk3cFNsMHo1SVhmZjlJcjJUS2tJQ1hVQ0xMWXp6cGQzYlpT?=
 =?utf-8?B?TmJSQVBmdVJGQnZEelhjNElKNHcxdSt0OGhFZEgzM2ZKcmR2ZmlUMVBHaUlB?=
 =?utf-8?B?RXlBbVhlaFJ5M0dFSDZuYkM3RENpRzJ6QU9ONllKQThWSzN4Z2pEenFJVE5O?=
 =?utf-8?B?TVlMZmgxQms3NHgwT3NGaFdLa1lwcE52U2pIZ3E2ejdKMGVJUmZ0KzF4a0pZ?=
 =?utf-8?B?VTBIMEZ5VDIrY0tBV09yUVNvTzNvekRmN1ZZcmZkbmJuR0FUc3ZCajloRERG?=
 =?utf-8?B?cC9qaGNCbVZxTDF1QkZ0bUxvR09EMWo1a2NGQ1pnMlNla1R0OHIrdW9QWElS?=
 =?utf-8?B?TnpPQUI3ZlE3VVVDcjJoZmErQlo5Vks1cWtnMExlM1UwWUdYQTJPTGppeXhR?=
 =?utf-8?B?d2pTMUVHcm9rcGd0S3FNakNPRHBZV3lqQWtXeENJUlpNOUV3Q1luTTBmOWtq?=
 =?utf-8?B?YnpyTWNUOGVRaHFycnMxbTFvZklEcFVMMzY3UEpQWDUrSEdrdG1lb0dML2po?=
 =?utf-8?B?Yjl0Q2M1aWVPSENGN2lyT1JQUFppaDlYUkwzSTY5eGd5NUV2V3p3bitjMWtM?=
 =?utf-8?B?NVZXVk00MmsvVkJPRUNWWTdtMXc3NGd5WWJhK2xxbVc2bUcwZWsyY2QzdUJ6?=
 =?utf-8?B?ODhGSzk4MnAvVmZCVG9aOHd4dG1CQUtSMU40bUdOM2Y0MldBc2dpTkpNZStK?=
 =?utf-8?B?aXcvV0d2WHpldDhJb3pSK295dkg0ZWJYS204TmxOYnFYT2pRQmNQdzdhMmhS?=
 =?utf-8?B?U01DVnNRYU15Y2VYTElFbXdnWU1qZGRyaEx5VGtnRzUyZkFJNUtPbGtZdXpj?=
 =?utf-8?B?QTgxc1NvN21pWkx2REZuYzFZTFJGZmk4djE5U1VOanpkVVNpbUxwODBTUGhR?=
 =?utf-8?B?bEtzeVpLQjZ4K2FqY0NJMTZ4K0g3d2hKa2ZKdnJaWml2aDJiVXkvOTVkUmc4?=
 =?utf-8?B?VHg3WWg0WTl1UWpCNkdBSlVOajdWQ2dHWVVpcmxwb3RYaksxdmdVNWFLQVRj?=
 =?utf-8?B?dFRaRVVDbkFtMkdJWW1RWDBpd1Nidk01cFRqemlVOHlaRVNGK1czV3I1SG5F?=
 =?utf-8?B?a0sycjZQcGtSYTN2RldYUjdUNkV1aUNtaFBiT0FvUzVZVk4yYzZDOW5jd1VS?=
 =?utf-8?B?ZmJrZ2JwWk1BTUN2NkhwYXpvNVFxVWh3eldzQnprVVFTNkVGWFlDcmRyZ0l2?=
 =?utf-8?B?S2JlODVhQWl6dWtTTWdoRGtUK3pLQXQzRmF6SDlNSXRYY29MN1NlcUFiSk5k?=
 =?utf-8?Q?XfoQ6Q94HYjsKdhznycVFKxgcNBA64c8Myj06yjax0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D173CCE1BDC8D4890ECC18A19164638@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b97e65f9-d648-4967-a411-08d99961b555
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 15:51:58.1842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xjfYAwh0nnMjFFjW2GZ5JDXBBSY8BMbjwkULCGkrIqoPLPD22kqQ7zzKH4sZkUOfNzLKzvEbH+2RF7f0fhDNhH++co0r58UCDSpgkDB4KLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2926
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTEwLTI1IGF0IDEwOjU1IC0wNzAwLCBUb255IE5ndXllbiB3cm90ZToNCj4g
VGhpcyBzZXJpZXMgY29udGFpbnMgdXBkYXRlcyB0byBpNDBlLCBpY2UsIGlnYiwgYW5kIGl4Z2Jl
dmYgZHJpdmVycy4NCj4gDQo+IENhbGViIFNhbmRlciBhZGRzIGNvbmRfcmVzY2hlZCgpIGNhbGwg
dG8geWllbGQgQ1BVLCBpZiBuZWVkZWQsIGZvcg0KPiBsb25nDQo+IGRlbGF5ZWQgYWRtaW4gcXVl
dWUgY2FsbHMgZm9yIGk0MGUuDQo+IA0KPiBZYW5nIExpIHNpbXBsaWZpZXMgcmV0dXJuIHN0YXRl
bWVudHMgb2YgYm9vbCB2YWx1ZXMgZm9yIGk0MGUgYW5kIGljZS4NCj4gDQo+IEphbiBLdW5kcsOh
dCBjb3JyZWN0cyBwcm9ibGVtcyB3aXRoIEkyQyBiaXQtYmFuZ2luZyBmb3IgaWdiLg0KPiANCj4g
Q29saW4gSWFuIEtpbmcgcmVtb3ZlcyB1bm5lZWRlZCB2YXJpYWJsZSBpbml0aWFsaXphdGlvbiBm
b3IgaXhnYmV2Zi4NCg0KSGkgRGF2ZSwgSmFrdWIsDQoNCkknbSBzZWVpbmcgdGhpcyBpbiBQYXRj
aHdvcmtzIGFzIGFjY2VwdGVkIFsxXSwgYnV0IEknbSBub3Qgc2VlaW5nIHRoZQ0KcGF0Y2hlcyBv
biB0aGUgdHJlZS4gU2hvdWxkIEkgcmVzZW5kIHRoaXMgcHVsbCByZXF1ZXN0Pw0KDQpUaGFua3Ms
DQpUb255DQoNClsxXQ0KaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L25ldGRl
dmJwZi9saXN0Lz9zZXJpZXM9NTY5ODQzJnN0YXQNCmU9Kg0KDQo=
