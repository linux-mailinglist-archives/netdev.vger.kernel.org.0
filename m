Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C51366247
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 00:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbhDTWtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 18:49:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:29045 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234240AbhDTWtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 18:49:09 -0400
IronPort-SDR: dtFsizd3Zl3659MWFVHq78r/DaHBo1T9ojnodewFf+11M5OK8YIJ8qwxBaMDC/EYhU/YDfeLJC
 RvxQmJz610ag==
X-IronPort-AV: E=McAfee;i="6200,9189,9960"; a="182736888"
X-IronPort-AV: E=Sophos;i="5.82,238,1613462400"; 
   d="scan'208";a="182736888"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 15:48:36 -0700
IronPort-SDR: 6fYhIG1hCLT2TWpmWXXNOlFVQK+234kGHYTHWvzDDsZhPhdw01dn/qijD3LPVKDlrpbfa7kfaP
 IicIvVCCxsZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,238,1613462400"; 
   d="scan'208";a="391292255"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 20 Apr 2021 15:48:36 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 20 Apr 2021 15:48:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 20 Apr 2021 15:48:32 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 20 Apr 2021 15:48:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdEgp6kL7V9RtxTynwnncTR/utVPE71sbt+PYGDwWNYX8kkE7SYtFvfJeU794Y9OSROesqzC6f8BFbQBTJwmGGyUemAprUtBcZJcvCJJqV7A0x7TYGxuoSdY4e8tBe80MzG6FjH7qlZGlGGOrjTIIEf/IG9/QF7Hy7VHFsuZFvwIftXhl7mg8oaW7aDv+kUZpzLJ1qyuj+tFJnC7b3P91fILbNacfbPxesnDcTqhtCcGNQ2JUGPW9uCD2aJ82qwF7UHYeyL3PjIM5wD+yKjGOCyk9w8EB6jCAlUSt8WhCUvcwtZJslUnqdscxsVyKbjOqLVxZVimQbLyuKgxtfj0Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8mdvAtb6oOlv8oWSoKcS+qmXG2smb5ODJVvJzxHyB8=;
 b=g233RXQqKRs87pYeDHW3ZooIIXicqiA3h2DaTErxXtQpd7WYcbi8/09q+UYgR0tjIHjdpeN2qYV4/e9xZa3hb+SAO4m9x/t6E/+MHM7jMvWZKOuRk/xAu+ndCdQ25SQnKRLZTMKIgAZ9Ahvq3DQ8vBubVEOGm4IdpAmX+uZ8muUjyf4cEpFvLUboSo4cshbbco8k117cNdONGoPTHM/nhYfROSuu/GZMQbefqX1vj9+GTn7H/vG1D+4fmIA2p1tPSubYMviUJGflzecs7eD79ncKUWvOfhAzxe7URLW1smkVGYKOVZ6LtuSjEGH2ET2xVjZrp9D3bucQmao3bt/LNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8mdvAtb6oOlv8oWSoKcS+qmXG2smb5ODJVvJzxHyB8=;
 b=Ah/xB5nXltJHN9gxoHrzJUcyRZnEkKqZ3Zj15S0KpbAky9FSYodY/GzPbN4uRwkMwYDtS/vHaPE/cEuA52ku2U05ZfsecVce6AhoB8cP7Oyp2Bcv9pXwtaHhF0JD6hLEMMd6FKK7fGJTPSEffu3BT6snm6C2N+4g/yYTarJgXdk=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB4844.namprd11.prod.outlook.com (2603:10b6:806:f9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Tue, 20 Apr
 2021 22:48:29 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c%6]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 22:48:29 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "liwei.song@windriver.com" <liwei.song@windriver.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ice: set the value of global config lock timeout longer
Thread-Topic: [PATCH] ice: set the value of global config lock timeout longer
Thread-Index: AQHXNP7PFMlVALdkmU2CbzZRHsc87Kq+BJEA
Date:   Tue, 20 Apr 2021 22:48:29 +0000
Message-ID: <7d85412de58342e4469efdfdc6196925ce770993.camel@intel.com>
References: <20210419093106.6487-1-liwei.song@windriver.com>
In-Reply-To: <20210419093106.6487-1-liwei.song@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37451901-c149-4d67-8a9f-08d9044e6abc
x-ms-traffictypediagnostic: SA2PR11MB4844:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB484426DE3A9530824A504DE3C6489@SA2PR11MB4844.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7W4LjlWg3bR2ou+j9Jd49KZnUMXyaIM/pdJ3zkL8amjqPedqoo5c6tFkFLJ8ErY6JmodXuCSp+W4UB+pgXrhJNJGy4exmcyvgLCZdmbERBToS2Id0QkXlMHcQSTum8EALJpxby/U9DtGd/lmUqqakYiEgRWmelVGzRM36xeVHriqgElt826LPTPJuzghgdNcKSia8oOFlNy5CJ19JbG7QM7ijhnZ1WCVaANMbQgv1sTOF1I9/iLfb/R+P4YZLHUA4oXGBvOjUraRVQpsHDiIbzfWkMhJNePDk1kmUKSPr+UFfuUy/2EedUGPinwzkld2kDgDHNnpiD91NTjnHa+u2y3pDApAUtAFaEqN8NoyZGOg5wjPw1URcfy7DHgYoxACQDDnl3EEtcpAlmeroOB3zmtguTN4B8ioHN/QaetQcnY8C+Up32ify+NTn+Ec9sIreijysKZTwDUz8JFxj3ZzYgpBZ3rzfx1N1A9xrUXMMzBnQ81xtoDpiXSUTj9gFzY9KApJWsXQN1XzsG3NPInPKgctP4u2UEp/X2NZaOIxHih893GI52jUbCCvLt/ouFNrabwf3HAEc0zNElBiLuernXqGayiS2pEslAljYiPsGzzvWS7SQsluYWyJI1bErFiToAujJk28iLuWKgRvgWx6slMHvuYYspvHSz7Ns2xYISG2O4lOnNqkyvGp9sUMdyEU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(136003)(376002)(366004)(396003)(8676002)(66556008)(6636002)(8936002)(66446008)(83380400001)(110136005)(2906002)(5660300002)(71200400001)(36756003)(76116006)(4326008)(66476007)(26005)(54906003)(6486002)(64756008)(186003)(91956017)(66946007)(478600001)(38100700002)(122000001)(6506007)(316002)(86362001)(2616005)(6512007)(99106002)(148743002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cmdKeFBtM1VMUldnTFZROUVwRjcrNFQzQXRWZUNLdzVpYSsxc1JxSVZ5NWJO?=
 =?utf-8?B?RzJBYkE5MmNINFNNMmdrbi9UQnpLQlZkdnUzSzlFWFdvaG9TNjJZTG1pdHp1?=
 =?utf-8?B?QjFzSGpsd2dVRll2M1NwdlcvSmFxS0Q0TEhWYlpKUFNnUlgvSSs2MzVqTGhV?=
 =?utf-8?B?Rk9QKzVYa3E1ZVFyOTIzMklrRjZUMWpxZzNyZ2JYcFRPNkd3djIyYXQveXNn?=
 =?utf-8?B?SjB5M0hGWnlJWFdUSFZVQ21WRlhVN3FHY1dmczFhQlJQbHcxbVBWUkhOOWdv?=
 =?utf-8?B?RGI2ZUhtNHoyTDRhNXRGdHBob2swOGpLRlB3d0YvL3BtTEVxTlpDaGI3MVlo?=
 =?utf-8?B?NWZyNVBVbnRrWHRLODl1RSs3UE5Nb2diSFpRWlIrdkxSTmRVU3VtSko5eWFu?=
 =?utf-8?B?OEN1a3FLTzRIbnBrc25CeGJCc1NNbU9yTFV5cktUTHFKK2ZBT3BIQ1kwSmdo?=
 =?utf-8?B?amhVRS9Hak8wUWhkT01NaTJuRnllM1Z4RmhqNmNQbVNVYnh0RWMvVStrRzZ4?=
 =?utf-8?B?WFBqcnJUZndSL2dYTDVoWWdDK3F3c2JpWXpVUTE4NEFHUGEvdlZtQ2NGcFkx?=
 =?utf-8?B?bDJkRHdCSzJVV08xRWxBV1BtczFrSzg4b3c2N2lOQ2VCcmZGbEhCb2xyM0FP?=
 =?utf-8?B?aVd0TnVFTUo0Nm1QVUEvM2lBWXZWY1BYTW9Ga0R6TjhDZnZ1Y0F2VEUxYXdO?=
 =?utf-8?B?MDlzSkptQ1Y3R0ZWQklVSHZERGlpYVovNDhtMlVLd05GRXNtcHM0L1JrL1JS?=
 =?utf-8?B?RXBIQmptbzhXb0NBSm5WKzhEN2VCRXhlK1Rvam9DYkROWUtBaVVqL2l2aVpX?=
 =?utf-8?B?M1hyUnc1NUNRZFhJYjYreUdYbVVxcjBQY3lyNWRVQTRmU2JYSmorS2NnZHZN?=
 =?utf-8?B?d2tyY0VLL3M4Vlo5a3drRUEzUndQREZiUWFmMG5HUk1NcXFyZU1xbm1pSEhP?=
 =?utf-8?B?eW50dE5QL3R4VFJHbGtpUzVBZERuWkMvVkpsT3dHSW5uYklaVXB0Q0VVVzdp?=
 =?utf-8?B?Zm1vcVhqWlpXbVd6UDJsQXczek1PT0tmZUVnQXZPejVWSTNXV2xsTlJUS2hW?=
 =?utf-8?B?K1NzTk1OY3hqdmY1RzgxN3ZvM1hyRmd4NUtsRU5Xc3VoMmNJYm9NL1ZDSEdP?=
 =?utf-8?B?TWtQNHVlc3hMN0dEUHdmTXdLMkRiZkY1Z0xwV2ZWaFY2THR6NzQyNVJSVm51?=
 =?utf-8?B?QkVjZHVxaXVTRG1QajZVR21kV2JRWnJXOXRqRFZyWlVKQUtNaUMxaEo2bXN1?=
 =?utf-8?B?N25rQU5kVm9rSHhTbW40UmIxb2ZmaDFtUWk3eC9kUmlIRUZpSEQyRDZsdis3?=
 =?utf-8?B?ZG9EU09LMzgvb3dYbWJ5bkJIVmdBamlBOWp0blo1NXVlQ3o4UEQvcXNvK0ZS?=
 =?utf-8?B?UWlHR20wSWVHWVRXNGsyMUVhWkN6SHdpVVEra3p0NVpnV21RQ29JR3Zwamc3?=
 =?utf-8?B?WnEzOUptN3hBS1NmUm9OODZhaURDak0vMkY2R1czS3ZidDVueE5mVExCRWp4?=
 =?utf-8?B?Z1NyelNLSDU0dkZKYzBZTXRVTnNrUFRrb3V0WW1LNlJEdkhtUkg3b0ZxL3Zt?=
 =?utf-8?B?V3Ntemh4cFpWSG5naFczV1VuV0o5Yks1VXJJSDFLdVRMZWRVZFhucldKdWM1?=
 =?utf-8?B?U0tLMnRsR24rUkFDSzd3bG5xZWRwbWpQakxXSWZyYTA5N1pXeGNlNGJhZTB6?=
 =?utf-8?B?aGc0M3lZa200cEFGTzljNllKOUpYeEh0VUJ4eGFPbzhXVGNETjlJSnZpcU5D?=
 =?utf-8?B?QWFhMVU3bG9EMit5enkvTVQwY1hsQk9CblFnTHFaUXF4ZjI2bUUxL2FYL0hI?=
 =?utf-8?B?Zyt3dFlwb0VoTWRWVVV6QT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <25BE68EA9848824398FBBA46A9B43822@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37451901-c149-4d67-8a9f-08d9044e6abc
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 22:48:29.3707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OBOGLSEt2b5/8HwFAIjkfUM9rTAtSgRNr+DKXEYReSN6p6I7HXRgWw9og0TWwvctYYEOmgB7BEPUArOtdY3kTis0vHO0DU55+s2FhtEObAg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4844
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTA0LTE5IGF0IDE3OjMxICswODAwLCBMaXdlaSBTb25nIHdyb3RlOg0KPiBJ
dCBtYXkgbmVlZCBob2xkIEdsb2JhbCBDb25maWcgTG9jayBhIGxvbmdlciB0aW1lIHdoZW4gZG93
bmxvYWQgRERQDQo+IHBhY2thZ2UgZmlsZSwgZXh0ZW5kIHRoZSB0aW1lb3V0IHZhbHVlIHRvIDUw
MDBtcyB0byBlbnN1cmUgdGhhdA0KPiBkb3dubG9hZCBjYW4gYmUgZmluaXNoZWQgYmVmb3JlIG90
aGVyIEFRIGNvbW1hbmQgZ290IHRpbWUgdG8gcnVuLA0KPiB0aGlzIHdpbGwgZml4IHRoZSBpc3N1
ZSBiZWxvdyB3aGVuIHByb2JlIHRoZSBkZXZpY2UsIDUwMDBtcyBpcyBhIHRlc3QNCj4gdmFsdWUg
dGhhdCB3b3JrIHdpdGggYm90aCBCYWNrcGxhbmUgYW5kIEJyZWFrb3V0Q2FibGUgTlZNIGltYWdl
Og0KPiANCj4gaWNlIDAwMDA6ZjQ6MDAuMDogVlNJIDEyIGZhaWxlZCBsYW4gcXVldWUgY29uZmln
LCBlcnJvciBJQ0VfRVJSX0NGRw0KPiBpY2UgMDAwMDpmNDowMC4wOiBGYWlsZWQgdG8gZGVsZXRl
IFZTSSAxMiBpbiBGVyAtIGVycm9yOg0KPiBJQ0VfRVJSX0FRX1RJTUVPVVQNCj4gaWNlIDAwMDA6
ZjQ6MDAuMDogcHJvYmUgZmFpbGVkIGR1ZSB0byBzZXR1cCBQRiBzd2l0Y2g6IC0xMg0KPiBpY2U6
IHByb2JlIG9mIDAwMDA6ZjQ6MDAuMCBmYWlsZWQgd2l0aCBlcnJvciAtMTINCg0KSGkgTGl3ZWks
DQoNCldlIGhhdmVuJ3QgZW5jb3VudGVyZWQgdGhpcyBpc3N1ZSBiZWZvcmUuIENhbiB5b3UgcHJv
dmlkZSBzb21lIG1vcmUNCmluZm8gb24geW91ciBzZXR1cCBvciBob3cgeW91J3JlIGNvbWluZyBh
Y3Jvc3MgdGhpcyBpc3N1ZT8NCg0KUGVyaGFwcywgbHNwY2kgb3V0cHV0IGFuZCBzb21lIG1vcmUg
b2YgdGhlIGRtZXNnIGxvZz8gV2UnZCBsaWtlIHRvIHRyeQ0KdG8gcmVwcm9kdWNlIHRoaXMgc28g
d2UgY2FuIGludmVzaXRnYXRlIGl0IGZ1cnRoZXIuDQoNClRoYW5rcywNClRvbnkNCg0KPiBTaWdu
ZWQtb2ZmLWJ5OiBMaXdlaSBTb25nIDxsaXdlaS5zb25nQHdpbmRyaXZlci5jb20+DQo+IC0tLQ0K
PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV90eXBlLmggfCAyICstDQo+ICAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3R5cGUuaA0KPiBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfdHlwZS5oDQo+IGluZGV4IDI2NjAzNmI3
YTQ5YS4uOGE5MGM0N2UzMzdkIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9p
bnRlbC9pY2UvaWNlX3R5cGUuaA0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9p
Y2UvaWNlX3R5cGUuaA0KPiBAQCAtNjMsNyArNjMsNyBAQCBlbnVtIGljZV9hcV9yZXNfaWRzIHsN
Cj4gIC8qIEZXIHVwZGF0ZSB0aW1lb3V0IGRlZmluaXRpb25zIGFyZSBpbiBtaWxsaXNlY29uZHMg
Ki8NCj4gICNkZWZpbmUgSUNFX05WTV9USU1FT1VUCQkJMTgwMDAwDQo+ICAjZGVmaW5lIElDRV9D
SEFOR0VfTE9DS19USU1FT1VUCQkxMDAwDQo+IC0jZGVmaW5lIElDRV9HTE9CQUxfQ0ZHX0xPQ0tf
VElNRU9VVAkzMDAwDQo+ICsjZGVmaW5lIElDRV9HTE9CQUxfQ0ZHX0xPQ0tfVElNRU9VVAk1MDAw
DQo+ICANCj4gIGVudW0gaWNlX2FxX3Jlc19hY2Nlc3NfdHlwZSB7DQo+ICAJSUNFX1JFU19SRUFE
ID0gMSwNCg==
