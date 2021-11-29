Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDF1461F9F
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 19:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379896AbhK2Sy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 13:54:29 -0500
Received: from mga05.intel.com ([192.55.52.43]:30784 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380126AbhK2Sw1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 13:52:27 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10183"; a="322284635"
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="322284635"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2021 10:41:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="459268735"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 29 Nov 2021 10:41:17 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 10:41:16 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 29 Nov 2021 10:41:16 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 29 Nov 2021 10:41:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXkSRZWrfFsGBSIAGCgwYxvdjIIdrpdLFw8cL50I/GjV6Ac0Uo8F2f0Z/U6OKDTiBd+VBXxUpOBToY1GuAI2+fvbF8rsRY8JZDP7qBt2nD1tz9cN7RjUNuURNfOPLx/n/NmjypVNs+ytixKyfLiW96FXo0vHjpaCVCyOenHILKW3yA+qtIltZlHZENjmXe4Hb80k95wG22jWX2VWlc/4pzcNbmt6z+0U8Gv4ZXtHQEOO7t+7tCGnA+6cCyLN+N0ej14vnOrdu8x5ct04hyrk37jnbUBIeaI9Ih4AZozAo3EQ/zClSpcyQlAH39dhyNJXGCidJJ2tGbt80n9sbXuroA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lX3NIYk5UtqlpnGYyvBdKnEavG2Wkix47fqJgXuTP90=;
 b=jP1qIBPNoC1Pfnxd20mnmf+JluQJ8+3+X4vkMye9gjdwtJE+OZ6hR+sQ00dLsJ1kqoqF2JGmYYy0diwAZof1fOFy1Rj9vhOA74+GowwQHn+zMQKwMj8R7IK0dgBAmliBhpi248sVTwIxsT4eZKO6+kOxw3bwhhbVMPdRxwlZmNRwjNj9PcPz5wLRDp4/82UmzyrDo7PlLoyvj6FbF0PFQYOxxw2a3tKArIXOuxIfdvXt5eI4YhDSNjHYZ7PvmfY5pUHCDU3iW2ivZPDNbzgZ7YRQ0/c8UHZ9FO5gsucLzxn9tVwO83eCHCBFZ/ou/MGyB4EfJ3ozDlO7IZf8jPAyQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lX3NIYk5UtqlpnGYyvBdKnEavG2Wkix47fqJgXuTP90=;
 b=JO0zZ1Rch1h15iMqxV0V/rNnH4aXaCUarRhYACyoBxTNfoexLPYh/WchcupEQZ3DDXv5rT9gaRaRas9WOxQPcLA7t8KvQ0ie7FZwjH4Ys0AIn2rmFKflbAeiOZXWrHiggUsv2Tkg/G8ihmtn4LxFgcL47ShjqXyhXF3pT3KhfO4=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Mon, 29 Nov
 2021 18:41:15 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a5ee:3fab:456b:86d8]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a5ee:3fab:456b:86d8%7]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 18:41:15 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "Williams, Mitch A" <mitch.a.williams@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
Subject: Re: [PATCH net-next 01/12] iavf: restore MSI state on reset
Thread-Topic: [PATCH net-next 01/12] iavf: restore MSI state on reset
Thread-Index: AQHX4VdGDBxAGPdCvUCd+pkpGbTJnawTV0eAgAeHGoA=
Date:   Mon, 29 Nov 2021 18:41:14 +0000
Message-ID: <b959e63677e272ba9b970965581c6610977da7a6.camel@intel.com>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
         <20211124171652.831184-2-anthony.l.nguyen@intel.com>
         <20211124154245.3305f785@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124154245.3305f785@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 333d6759-4ad5-49c8-a7d0-08d9b367d2e7
x-ms-traffictypediagnostic: SN6PR11MB3229:
x-microsoft-antispam-prvs: <SN6PR11MB3229A36DEF6538C3938B56E6C6669@SN6PR11MB3229.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B3e/Z06A6xukBKGNF/JNhaWiiBwPaO6YoyIi6nzXVsAUTXFkm8WM1TlWysvaoRD5zJDUKCpPW7CDbCfx7XTqHUrZX6c4en0pdOaDGOTJI3QDj3MsVnubTahB6lHHWOzRknNEwafKdhOn/v774F8zVXXrjgBL6nZ7y/m2Tp5rD2wL9jO/722bOuBoVXrkmWmK38QiLvleeC68ATw+FE6tnKmK3ZnveOZvghoEydIZOEfQScw9jPVthHk3vOt1x7KYkHsUR9h/s+qLQ9sn/NHJnpoQwB89z+52YqW2PtSoZQzowMqM/JTFQQPwHuOgHqQMZ3vmLzq48XaK0+wa8bsAAZD51I2+UnRwRtdkCkQZXcCVs+Ga3QQ1FU0AqR/i9uxpLAXIVgkAKOl8ssX/xXuM6hVJSYfuJcRnUdxOKTj76akL87yPqVU63hqFXCWcyJLjtkNZoaAzKX0B8t/AD5jVi4vU79LecV7tm5eGYOeA6aeWCn/NLFpQzbQR/3ytF9j6A+wtAboQAJRBKPLdZ3pHG5crAg2AfeEOjtJbNPIK6tF461bQm+WD2nv0vz1iNT0gDfaE8pQoi0zmqjgayUDDxBPH/jdP9hI57pqObjzK+eA9q4ML2Mstg+fXVdU1La1PLnjx3fCsoCOLbYrcUp/KCQYYw1ykX4uCgG4jAXRIAiXr6WL5z3xSRhNylr99nMbbwEmh2nKsqyNRpodOgWZi4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(4744005)(82960400001)(107886003)(64756008)(4001150100001)(508600001)(186003)(4326008)(6916009)(8936002)(6506007)(38070700005)(6486002)(66446008)(91956017)(5660300002)(2616005)(54906003)(2906002)(66476007)(66556008)(66946007)(86362001)(83380400001)(316002)(122000001)(8676002)(26005)(76116006)(71200400001)(6512007)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFRFUlF2SC9BUFBjMWpKZ1Nva3I0ZmxtWjFGL2ZaRkxCYmN6RU1xWlR1ODBk?=
 =?utf-8?B?RG5vYWU3M1ZmZlRUMGYyTVBYSEtFeWhndTRGZ3lXdHVjcElIK1pQY2xyZnRR?=
 =?utf-8?B?QW5lK2l5NUxvTWJsYzl6ZXRWUDdLY0FFMlVQMlNvNEJMUGtwV0VBam9YRTFJ?=
 =?utf-8?B?QjFkaW1JUys5RTRVazNrQ1YrRlJxYlNNalNxUExocmpmeWIzNUhySVl3NE1K?=
 =?utf-8?B?eVJDemViZ0tvNkVTeE1vdmVCajBkT3hYaWpuNE1JN3lPM1h0QlNGL2hYcUxE?=
 =?utf-8?B?bWJqakhjYkdWck5aUjF1NTFkUWl3aHFwVm83Ym9wc0lUd0plMzdKOHF6ZzQ4?=
 =?utf-8?B?NXRxQXQzaHB0TmIxSG0zRld0OStZdHU5SEpsUmN5SVN3YktnS1BTZ2MrWkJK?=
 =?utf-8?B?QjNoVEVScTBNRUsvTDBVSmNjc3AycUVSVTEvWlV6Z1FzcyswcER1TlU2dXJX?=
 =?utf-8?B?ZVpjc0dCRU5hTDlHNVI0a3duOEpZNDdyN2JsbjRGTStPN0lFWm5zSnhOYUt6?=
 =?utf-8?B?cWZQcjVUOFJ2NDQ2MHl4Y0dWdHI4cUtiQnJmbW5FdWczS2tzNWNPWWdhbFBa?=
 =?utf-8?B?dFg3cWRPNU5kQUxRUjJ4dnJJbjNSV3AvZXp3dlNSRm84cXlZWUp1dSs0UXl1?=
 =?utf-8?B?bmpML2VqSm40Z0owZnZaUWhyejlKMjhUbzBwRWkxWkRLWS9ZWjN5OW9meElS?=
 =?utf-8?B?azBuaHJiTjNucEV1SXppSVY4ZG9TQURWUTBYdlFCY0dUWmJsTTdUQlpqcjRS?=
 =?utf-8?B?VXNVS3BKR2dnbFJEU0w5VitMRHdiKzdaVkErZldaNEZPbkgrV3NlcUZMRjJt?=
 =?utf-8?B?WGpzT1dialVMSHdQZ1hWNE1zeFcveTQxUjc5dk10dFBUTkNLeHVobWxFS2NM?=
 =?utf-8?B?WitsaEhhd0szcU8xNFE2RzBnNGpqc1FKSm43ODRHWmVxeDRraTk0djQ5MG94?=
 =?utf-8?B?ZzUraGlRR2FMOU1XUjdELzVpN1ozTDhHeW55TFFqRGd2aDI4dm4raVBSRm9v?=
 =?utf-8?B?S2REaWJuNkczTW5sVk9GVnU5clpaQVkrV0ZjWEtJOFkrZEVLbnBkK0sxdnYy?=
 =?utf-8?B?OEc2R1N2eWxLYzJ0d1VXaHdIS21OQ3ozckFZbUprUm1KN1ZOMktrZXVqUTVp?=
 =?utf-8?B?ZDREcFBieUFSeWtLdk5BaTJIdlR5VnpOdzlFejR5Y0dPWUlKb1oyUkxIZzV6?=
 =?utf-8?B?SmRXbVo0cmJneU52NmlxZ09JOEJEMmNCRUdCWGFWOVRIQTIyUWNDem9qQzhu?=
 =?utf-8?B?amF2ZTZHTFhtMzdHTTdsaUlDVGZqczVJQmdIWGJKazNRZE9mSGRENFFxYmdK?=
 =?utf-8?B?V0sreG9ZaEZIbi9YT0VSaFNLS0VKeUZBVWltSXlSWlBocnlPekk2cUFlNmJW?=
 =?utf-8?B?V2x0UWRISmJPQ2lZeEdMQ3Q5Z0s3cFIvRkJQWklsd2dGMzNoT05MVkVpR1pa?=
 =?utf-8?B?bnpSV3A4TFdSVUZHUDRUdzl6ay9yRXFydE9GWXByT2s2WThtcENkV0p5V0VG?=
 =?utf-8?B?bDN6SkhzKzY2bHNmckxwdVR2MTJBTFBDTVdtdnMrc0VZeUYzaVd4MGdXcmJJ?=
 =?utf-8?B?bHYvUzFmQjZCdk5obm9DYkZLWjFvWDRZSGQvcEd2YlF2V0hhN3V5bEhpYzlY?=
 =?utf-8?B?Mlc0Nk5PcmxOOUxZK1A4SmFrSDQxK0xjL3VqeEZMeVBJZmxEb3RoNG4yM3lS?=
 =?utf-8?B?V0ZGZExJdUJ4WWlIbkNzd2JyMThySVNISUY3aGpqeHBYaUFUSVBYZFIvVUZB?=
 =?utf-8?B?YWwxRVBPU01oWTdxbnIwWVdkaDRVSlJEV3VkUWJhakpZcndLYStxTjNDZE1r?=
 =?utf-8?B?Vm1DZnVGMHRncEtpeldtbDEwTnRCcEJ3bGFaVitNZ3kxQWgxVDY4QXdydUVO?=
 =?utf-8?B?N3c1Qks5V1FNa1FIV1d5TTJZaG1xSUR3aWtnVCtoNWUwQjlPbC9QdVprMmxt?=
 =?utf-8?B?ZEVtQ3M0VnRLU0RCbkNEdElCOEc1M0w2R0o3dEF0bWpkYjVkZ1ZCdjMyM1hM?=
 =?utf-8?B?SDBxNUN0WEREeWd5YUs1OFRONXMxdjZJOHpERzBHc01tOG44ZENVN2d0TFRL?=
 =?utf-8?B?U0VaYWtjaXBUcE0rOVdOTjZxa0NrQXZsMlVMaHU3SlduNFhRbHJ1TStyN3lV?=
 =?utf-8?B?b0w1MlNJaXgzcWRLNzUwZHVXZStuczYvVU1KLzZKdm1WMmptLzVDN3JGN1Va?=
 =?utf-8?B?QmxBNlRHNFl1TStuOG51WTd1S2Z3b1NReEdGaTlDS2t1MjhIcXlRUWlaejZK?=
 =?utf-8?Q?K6wdAqo+0GAg+ndetE38L2A0JGRX+7gcmobkaXIM1Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <37656BDA26D8E04496DCC98A1B6726B0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 333d6759-4ad5-49c8-a7d0-08d9b367d2e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 18:41:14.9887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hVrScp9g+iyCSA+KYtoMQeYulp68JpuE4KggcRD6QoZNuW3XXRM6NKqFSlIfyJJMPBgnCUZ5iIXGyoPTT5tbOc5nHGfmhqaRilXAxXv6W94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3229
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTExLTI0IGF0IDE1OjQyIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAyNCBOb3YgMjAyMSAwOToxNjo0MSAtMDgwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiBJZiB0aGUgUEYgZXhwZXJpZW5jZXMgYW4gRkxSLCB0aGUgVkYncyBNU0kgYW5kIE1TSS1Y
IGNvbmZpZ3VyYXRpb24NCj4gPiB3aWxsDQo+ID4gYmUgY29udmVuaWVudGx5IGFuZCBzaWxlbnRs
eSByZW1vdmVkIGluIHRoZSBwcm9jZXNzLiBXaGVuIHRoaXMNCj4gPiBoYXBwZW5zLA0KPiA+IHJl
c2V0IHJlY292ZXJ5IHdpbGwgYXBwZWFyIHRvIGNvbXBsZXRlIG5vcm1hbGx5IGJ1dCBubyB0cmFm
ZmljIHdpbGwNCj4gPiBwYXNzLiBUaGUgbmV0ZGV2IHdhdGNoZG9nIHdpbGwgaGVscGZ1bGx5IG5v
dGlmeSBldmVyeW9uZSBvZiB0aGlzDQo+ID4gaXNzdWUuDQo+ID4gDQo+ID4gVG8gcHJldmVudCBz
dWNoIHB1YmxpYyBlbWJhcnJhc3NtZW50LCByZXN0b3JlIE1TSSBjb25maWd1cmF0aW9uIGF0DQo+
ID4gZXZlcnkNCj4gPiByZXNldC4gRm9yIG5vcm1hbCByZXNldHMsIHRoaXMgd2lsbCBkbyBubyBo
YXJtLCBidXQgZm9yIFZGIHJlc2V0cw0KPiA+IHJlc3VsdGluZyBmcm9tIGEgUEYgRkxSLCB0aGlz
IHdpbGwga2VlcCB0aGUgVkYgd29ya2luZy4NCj4gDQo+IFdoeSBpcyB0aGlzIG5vdCBhIGZpeD8N
Cg0KQXMgSSdsbCBuZWVkIHRvIGRvIGEgdjIgb24gdGhpcyBzZXJpZXMsIEknbGwgZ28gYWhlYWQg
YW5kIGRyb3AgaXQgaGVyZQ0KYW5kIHNlbmQgaXQgdmlhIG5ldC4NCg0KVGhhbmtzLA0KVG9ueQ0K
DQo=
