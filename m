Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9993F2200
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 22:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbhHSVAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 17:00:33 -0400
Received: from mga14.intel.com ([192.55.52.115]:5487 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230031AbhHSVAa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 17:00:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10081"; a="216378267"
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="216378267"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 13:59:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="424756168"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga003.jf.intel.com with ESMTP; 19 Aug 2021 13:59:53 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 19 Aug 2021 13:59:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 19 Aug 2021 13:59:52 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 19 Aug 2021 13:59:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xf3MdwkNKlFsGly062kDNM32pnIe8Fh2xurk8Mxbdy5ngSNpD5Dy1T+dovRygSi0Ns2UEqaJcVcPQ41l1+Anri+q7Q+IybffX3CEZ5dYLCuPb/XQP29cKd1G68H5zW2NOr7Hc7WgrrplRwlVc9t3zm491AzEMRdr5NhkCi5zsoc50788N7tdKMuMs5Sd+BHHf+3s1Dr6TdPoiiQO1CH6RzkS1B5aDpEG14TWzrfqkImrlpXJzLm9z2SfyPnufCGtvsOcaBZRaoPvchm2XdinlI3Z5HcKPMhOi9ZQZ0bZs/eVkWAso3eEVpe11Ef2PldVJUh8hCuIwCDeD8JvM5kDMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MjHvOh/HHUd2K6jPEuUwl2opM6Xm3+R+IJW2mWcsJLM=;
 b=iK0LB+Ob8xwUf7/E+HFhvF1/n6h7rEGXtACA8Yh8PZlfnDUGxAkBBcPGqH73K2X7uJi08QNPE3lctXY8wgY1jeAqjwOWwfG5q5LzDyt4A+skAIFSAJ7Dm9BH+dOH5QcCd2zX+bhng4KfQzt9AdjDFGNdT9SwEukXcaouIRZYv5LQsCfjLeepANrykVhsj3LF70D7hqlQAGWCS19AlynAYorR/mmZEy7vK87A7mOe4xuIkfHlL0cJhPXUtiyxURamftGOUJImgmnaQojIIV3cRMrdpGCa0IWRNA2lDU5XDS08tvKaryqV6OmC4b5rUS8AzqNOmlMY/xOsKO2+G2Z5Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MjHvOh/HHUd2K6jPEuUwl2opM6Xm3+R+IJW2mWcsJLM=;
 b=yUgt+ZQ86SB+E8CAb61BD1hU2nDb9S9YqJdmEg2YVCxkUJ0ASEcIt4RXAvpzBPbHAREYdvANWfxiBPDo1VExqxANjDwyTqFosZGiXmcczO07XSM0N/UVe5bm3UDXWdKknkZSKQsV92R0b9OQa8r5YeggglrvgELJdX0ZbxxA++c=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB4778.namprd11.prod.outlook.com (2603:10b6:806:119::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Thu, 19 Aug
 2021 20:59:51 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4e0:837:41ee:5b42]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4e0:837:41ee:5b42%6]) with mapi id 15.20.4415.024; Thu, 19 Aug 2021
 20:59:51 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/1] ice: do not abort devlink info if PBA can't be
 found
Thread-Topic: [PATCH net 1/1] ice: do not abort devlink info if PBA can't be
 found
Thread-Index: AQHXlFiQLc3zz6VckEKu4fGRhUEBpKt7DMKAgABF3oA=
Date:   Thu, 19 Aug 2021 20:59:51 +0000
Message-ID: <92eb67e6578ccc3f0f3b88a58e72da0383d3e5b0.camel@intel.com>
References: <20210818174659.4140256-1-anthony.l.nguyen@intel.com>
         <20210819095325.5694e925@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210819095325.5694e925@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ef20a42-2187-4f28-3f9d-08d96354499c
x-ms-traffictypediagnostic: SA2PR11MB4778:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB4778A1463666332E35443E26C6C09@SA2PR11MB4778.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B9axz2YPsY+bh+TggvgHLRqVqGgJsMiP8fYlidesFvJ+o3MXNaaFY7pcubJtYpp15AEgWZW8qsb/jMHkLvo1ngK6xz6UsQBaAsH9l58NOg5CemQJTQ6T7+VqsSCRbWOc6B57NEE/8prTm8cCYtG13lysLYfJpffps8SWIIQovTSxUnZly1HFizpaTUmGnENbenLlmjXCBR/7RFSmDvYadGfQYkKqNULSjc1yE0B4mzGyQHiTJud8J4KJYuDq0O++icEFVVNT4ADWEw1yllBNh2VkGS/p2WMrtL+eE2aWh4wKEUnVuJyXSrMUMixrdwM8izacP7XdjHCLTmFgCAPYO1ucJCWDKCkncxciwCenTAutp7yyCAH6bRsogwPpjySbJzkmZKzQ+V68ECbyW+ATmBi+TEsp2UEY5QMYGZfV/97Czk9jqhIxY+V/5Hvh97dZlhLZUt/yMkccC9DvLOGxXWRyDuEZhwvDXNeLp8C0Qvm4IU/7mp+5l5KONMMCS/DpYPqK1+7XQ4lgdPxYWSQEOohxsvplclz72ywXgoxVH4y6HWnRW4cPWO1lmdUv3fmkUtypO8f+gS8Mg4HQXWutZXc/rGnHhQjNuAUJInkrJbUrucsQhJqGmo5XxabHwwIVxYgHOMMuEy86mJuWWI5YWuMADicWea5r5LsmRfSZgF1Ks3PqA1FVVSBzhl5BDjXmegfOR7x8BQi+ufSqDPrRvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(2616005)(91956017)(86362001)(8936002)(4326008)(38070700005)(122000001)(36756003)(66946007)(186003)(6486002)(26005)(38100700002)(508600001)(6506007)(4744005)(6916009)(6512007)(316002)(66446008)(64756008)(8676002)(2906002)(66476007)(76116006)(66556008)(5660300002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q04vWlRMOVo2Q1Q4SnlwZ0pHdjl2TysyRTQ2OGRZVnJrN25tcnBPeUdwSm44?=
 =?utf-8?B?bmRZMFRqL3ZUNFRpeDVPMld2VnN0OFowbk1EV0JUc3VDbFBpOUpPNEFLR3ND?=
 =?utf-8?B?RGZFU0N0RXVpM3dSU3YrdWowd25yWldPbW92QmI1WGd4S0YxeEdURTg1bk00?=
 =?utf-8?B?YlMrQ1JIT1dFV0hKN1k1alNHL3RxRnZRYkNYbHBJdjQ5dzJDWHhNRlVIU3No?=
 =?utf-8?B?UlBYNTBIUyt2Z0l4OFJkNzdWVVVrS2kyaGRGSm9aL1prS0dPSFpxMHhqaTBM?=
 =?utf-8?B?MHVVbS9ZckMwSURwakVSNmJHaWZRZ3llYzNzeHRBazFtZC92alRMTVJGZW5K?=
 =?utf-8?B?eGdVQkszSzdwMU1tOUpjMGl2Nm5uOFpYaVdCU0N3Q24zeGhrTlFSRFlWNzI2?=
 =?utf-8?B?VCt5QStJbDN2ZSswb3ArT2RwVHdmODZWOXFISWVvT0d3UW5OT09ZWWtkMTNM?=
 =?utf-8?B?QkN1NkVuR3BVaGNGUzhKMFRGSW5oajN0NGhWYVBZYW9zRCsxbzNqQjgrcWNm?=
 =?utf-8?B?ZWlBZy8wa0tvaXRKREVLL09yWWYwUmJvTnhQUWJ6U2ZOM1d3a3ExTHI3Rzh3?=
 =?utf-8?B?VUtKZXAyLzN0dU1tREZCZW9SbGtSUzM4SkpNYmczR3NxNUJ1UlVEcG9VNG9h?=
 =?utf-8?B?ZDd0TDMwd21hMW92REhWeVM3ajNsL2Z3OTd4aS92ZUxaNHJkRmIydkZsUjB1?=
 =?utf-8?B?cGZrdThmbmdGOTZxL204dkZ6UkVTN2tPRzJ2MlQrWFpiTUg4ckVxTlF6Nngy?=
 =?utf-8?B?aDZWc2ljSkgvbENqQzhtdnlyMFdUUTNtajhUMkEwSUlRT3FDcGdqbjg1QSt1?=
 =?utf-8?B?NXdZV01oWjh6eXNQN2VyOTBMYUlZWE1GQ1RHdTRZUXFUQk9EQnd5QXVhcHpJ?=
 =?utf-8?B?b3hsQ0EyaEFaek14VWw5bFFZR2xic2dYV0JQNEVqQ2VCcnRmWFM3bS8rbFhB?=
 =?utf-8?B?TTNTUUJhTEtyRU42bFR3Qnk1cnhrZ0crL1FISFpaalNUaTJaVVVCVlZ4SkRP?=
 =?utf-8?B?TTRkNVljRjE4TWFhM0VOVXo0L25ldzc0TmhmakFTdDNYUGRrVXFvS1YxZ1dD?=
 =?utf-8?B?SjJteUpUMGVSMlRieVZYZUJ5d0MxTFpadmhwNklkMGE3endkeEFBc2NCV05i?=
 =?utf-8?B?RE85U3BJTSs0Wmxub1dUWjRjckZUaVZ3QlNVZis5YWFqOUE0U0Y3bjU0KzdS?=
 =?utf-8?B?VzBlQjY3U0YvdjRRQjB5ZWlXQU9pK2xmdUh0bGJ2eEFiZHNNUEF3OGtaMG9s?=
 =?utf-8?B?TnpscTdBZkZ0ZzVsS1FqZWRlaXAvWGRQek1MOGZJa0dTUTBDUWI2anVPTjla?=
 =?utf-8?B?LzNKU0NqVnk3NkhLMmdJTDJtYXIvVzBIWGszb3ZTNHlPdkhKMi92Qy9HMG9t?=
 =?utf-8?B?b2xYeHVGMkdDQjNHaGtzMzNBdm5qUWQ1NENRQkVyQ1hya0szdDRiZ0RDNThT?=
 =?utf-8?B?QzZ6QTdGUTZ2eHNqdjdKL1FnclpDd2J6ODRubTBrOEZHb1Z1RUtpZytYeG5q?=
 =?utf-8?B?NTczamFWV0t1OWpRTVpCVEg4dzVpMW1uR0ZGS0NBTEtnUVR6UVdXVFpwM3No?=
 =?utf-8?B?V0dzNmhNNHVQQlpFMDNKUDE5REVQVG8yeEt6M3dHRGdNWjJ6UXNYVjZ4MzVy?=
 =?utf-8?B?cEJLUU9SQ2Y1ZGRkbkRhVWRVcTJWMlFlK0liYkFsTy9JbFowTkZ3Vmd2aTlC?=
 =?utf-8?B?bml3UFg4M1NXK1RnK1JQT3B4d0M3dS9HZ0EzTjVRWS9wWHB0eUxOd2NwQWlm?=
 =?utf-8?Q?FGj8Hw0QBo4RTQlUcyUHY+hZ90E+32XzyGZeMlk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86F2AE174308034D9B8B326E8B9DB411@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef20a42-2187-4f28-3f9d-08d96354499c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 20:59:51.2425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S/jEu1eZs39KTD+j1RaVwqTjhQO4qpGUT4UqZI9SVxr+l1fFtThRksY/+26vOX8Csn9O1XYNcp2tAATKNp5en0wy1o4sl9oNqI9SHSI0UBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4778
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTA4LTE5IGF0IDA5OjUzIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAxOCBBdWcgMjAyMSAxMDo0Njo1OSAtMDcwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiBGcm9tOiBKYWNvYiBLZWxsZXIgPGphY29iLmUua2VsbGVyQGludGVsLmNvbT4NCj4gPiAN
Cj4gPiBUaGUgZGV2bGluayBkZXYgaW5mbyBjb21tYW5kIHJlcG9ydHMgdmVyc2lvbiBpbmZvcm1h
dGlvbiBhYm91dCB0aGUNCj4gPiBkZXZpY2UgYW5kIGZpcm13YXJlIHJ1bm5pbmcgb24gdGhlIGJv
YXJkLiBUaGlzIGluY2x1ZGVzIHRoZQ0KPiA+ICJib2FyZC5pZCINCj4gPiBmaWVsZCB3aGljaCBp
cyBzdXBwb3NlZCB0byByZXByZXNlbnQgYW4gaWRlbnRpZmllciBvZiB0aGUgYm9hcmQNCj4gPiBk
ZXNpZ24uDQo+ID4gVGhlIGljZSBkcml2ZXIgdXNlcyB0aGUgUHJvZHVjdCBCb2FyZCBBc3NlbWJs
eSBpZGVudGlmaWVyIGZvciB0aGlzLg0KPiANCj4gU2luY2UgSSdtIG5pdCBwaWNraW5nIEkgd291
bGQgbm90IHVzZSBQQkEgaW4gdGhlIHN1YmplY3QgJ2NhdXNlIHRvDQo+IG1vc3QNCj4gZGV2cyB0
aGlzIG1lYW5zIHBlbmRpbmcgYml0IGFycmF5Lg0KDQpXaWxsIHNwbGl0IHRoaXMgdXAgYW5kIG1v
dmUgYXdheSBmcm9tIHVzaW5nIFBCQS4NCg0KVGhhbmtzLA0KVG9ueQ0K
