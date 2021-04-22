Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5425336866E
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 20:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236659AbhDVSRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 14:17:22 -0400
Received: from mga04.intel.com ([192.55.52.120]:38895 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236287AbhDVSRS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 14:17:18 -0400
IronPort-SDR: rWX2OcPDjcVtSmI2Uj/INmv0ULQuCFFO8yi1bQ8roJTC11/9kr37kKK67Ykr0TjaKiIKx+fTCS
 NMPj/0oxwa3w==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="193826758"
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="193826758"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 11:16:26 -0700
IronPort-SDR: AjBdI6RoUT7kG180i/4lOB4kYfkNxli84EWu+E+N2FDS7DvUz+xhWJu3Ek7e/azfEX4BtvMCzK
 Zjpi+SD2LTpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="386162780"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 22 Apr 2021 11:16:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 22 Apr 2021 11:16:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 22 Apr 2021 11:16:26 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 22 Apr 2021 11:16:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LkijeaxfmN/gtpH5qFPO3SX9bK00sGo20uBqt2YFrPPGWODF6OPDPa4NMDfpiqzvvpL9HDlXy8q5iMZLrvRIkJlpE5+/CJ0DX2tnGwJ5vw+5fobzfMaRYWBQz5sjxwfG2aOGz0juqky8qWdyY6vwZvsdrxW9p6ii1WqquY47sHit9gRRaIfRD3iQ011P1ZXuCCmDI6DxpxQYplAJ/pjuWo4Ci5lJYUyN9UQekMzQkjUrvcEGnmzL8A4WzRd6hbnZBqGDW/32v7zdg+ZmzuHeogZWXF3UhTy2ci5LoiuYbQTXMfhTDO3pm16jiFt4eg5Jv9gDV0ObThAQQjhcvMepQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xWY/ZinAc8u8Dx7t6QdWSBkhSbflYODydJK6Kji+3g8=;
 b=SqNA/spqHJ2K+mYBLg8YcOehsYbRzLE2Iolru9eJxkYcEz3d4jFrQrrpUveuSA/XMTBH9Sr01mniKcacQysmCOdEzDnSBOrcGopeJQYqN3GByR47aZV9NVbYzo+/ygCQPbqfwvAJ2X0oxtkgdA/oJuU70b0gE6TN7855Zz5iRiIOHxoghuuAwisxsGx92O98XOzFwxhaJlNa74gYPdBDSbusjDdoUKjlMG8+3BWLk+JEBJZXthy7pIdqWcuwhNQ8i9tngXqKm8t1eJXEEwIRwia2LD/1+SRAMYFe3CRCQwlxzl1CvcJhpyx7WUdNBxQ8s+LhQzePE8OHAeZdzg7Z1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xWY/ZinAc8u8Dx7t6QdWSBkhSbflYODydJK6Kji+3g8=;
 b=jj7RA/9kDRBXP+3hD3h1di62oD9FvxcdF4jIUVIe15ct1VHoYTJ5ae3Vzy2xAmC+KB3RxqL9ag67LV+VC3KiZt28uCx3BBm9i9dJHlk5W6WSc3d8VBHfr5zU8rJLUoo8BvrhJy9RKEnRn+5+hRZHlo8RFEsPtUhkkSEzNTEEIl0=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB4873.namprd11.prod.outlook.com (2603:10b6:806:113::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Thu, 22 Apr
 2021 18:16:24 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c%6]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 18:16:24 +0000
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
Thread-Index: AQHXNP7PFMlVALdkmU2CbzZRHsc87Kq+BJEAgAA9yoCAApragA==
Date:   Thu, 22 Apr 2021 18:16:24 +0000
Message-ID: <8d6eb1116cac38c764fce754a9fa272ac4509bbb.camel@intel.com>
References: <20210419093106.6487-1-liwei.song@windriver.com>
         <7d85412de58342e4469efdfdc6196925ce770993.camel@intel.com>
         <fca32ba9-ad20-0994-de7c-b3bf8425a07b@windriver.com>
In-Reply-To: <fca32ba9-ad20-0994-de7c-b3bf8425a07b@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac620b0c-d3c6-488e-c058-08d905babcff
x-ms-traffictypediagnostic: SA2PR11MB4873:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB48733FCF4F3E765651BE8D52C6469@SA2PR11MB4873.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2lwQ6npwTDiW3csIyPSuiAndaCD+DgC+uI0BcEzfJMO/2wAoB3CZz+hjbmHedzunvMSL94sPTVfPLpTyHsEYYTHDhoMTWB72TctVOMBwyJzWGGlsuebKt3QRFCnMYUHHLsF6y6yzazUsd35D0daHaByDCIwYUG7NxP/fH40XDlTX9sjr2kcXKgm/X0lwFFVJmC695u29Bjd5iDLtIDou5BFWZRfqSsgAcGKHM1zcrmcs8aGN7DIbbmi2PySg9NI5L4Gqr3Vp5Xm8vxWoC5ZdXQRBXrSSGcjWtwoeZgj6lzacC5a4DBPZU4MTROivsKglvAjiQOgBpjybW2fwvhF8rsTWcrT6VNenS2GORs2O4gpObH0V2k0JZcaIQNAuvluIoSevyghTS8HnJUXJbT/L0WJJ2ODh0jPRkbkHSQhFATB+K4gnjAHDWgvdAG6CKNr6IHoqGLIYyjzsa/AjLqJ2KVn5CdXHWajK8CYsq4cqzxkpu5goW0FBGOBbwFPs8I2iuMVsl4RsJPivd0GhPX6Qafg+m/0OGA/1SQwAtYnP0hp7outI4/n/NJk4se+LGUBrR86gaZFoE7GP1UmCQcDHM+ytizZCA6OH2353B+j5Qp+GnTBnqdk8SfvTIZMigVU6+G3ymZ2jNZyqo2/G4X0gDE5teG2pHJDrXHXUrRCVJCE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(39860400002)(346002)(136003)(76116006)(91956017)(54906003)(122000001)(478600001)(110136005)(66476007)(66556008)(26005)(64756008)(36756003)(4326008)(8936002)(38100700002)(8676002)(6506007)(186003)(6636002)(53546011)(6486002)(66446008)(6512007)(316002)(83380400001)(71200400001)(5660300002)(2616005)(2906002)(86362001)(66946007)(99106002)(148743002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dDdYMlo2K1JaemM4QUR2aGpGRHBSVFBxaGxhbjMrVzA5VEhiNVJGYWhkSm1y?=
 =?utf-8?B?bmcyNUZUSnZhTHRnaEZ2a284SnVUdXp1czZzSy9PWkZ4YnFnT2haMFFNNHk1?=
 =?utf-8?B?Wks2WnZHWWlnSmxNVy91QnhYaDMvMlIzN3FFZzNrT01NTXM0bndJdUdjamJG?=
 =?utf-8?B?VDJXZWFDL1ExWVRJUitqOXFjZ1FCVVM0b28xWnBucytIb3FNWC9OZVFEV0RT?=
 =?utf-8?B?UjVhM0VpeTVLV0FMV05TTXc0cXZRblRLWUpRTjlGV0dXMjJrVmJuankyVFRS?=
 =?utf-8?B?ay9XV0h1WmpYWUc4UC9XZHAvU3Uzam5nQS9OY1QwcXpaQ3FVRDFHOW5XVEoy?=
 =?utf-8?B?bVZUb1NnUDhGWXY3Znlud21USDZnMEliT2t1K282dTIvbEFjOXZXcGhjQ1d2?=
 =?utf-8?B?RG1zcVM3aGE4Z0dvdmx1RmhOaUdOaWRlazFrSiszWGdVb2J0ckVFNmFZZW93?=
 =?utf-8?B?dlZzN2xZbVU5elh5T0d4dWRHOGVhL3d5SmpxRjA0Qno0elRHOTNDWGNiZTE1?=
 =?utf-8?B?WDNiSXYwNlo3eGFMcmc4L0NzWG1Tb2xjT1JocnJtb3Q0ZGpudkhyUEphdUhG?=
 =?utf-8?B?dXdjWElzUGJIN3BLdExjUFhsa3orR2JsNVJIM2pYejB1ZjU2UlJISWVSTHdj?=
 =?utf-8?B?Qmpvb3c0LzJOSDA3MitvWDN3SkErZmt4cXBCVXl3RS9WaE1mdU53aUI0U1Ra?=
 =?utf-8?B?bENEMXFPK0Jpbjh2akg1d244T1Bub1pOUkxvc3NRS05ndlVsUndZMUJUSzJT?=
 =?utf-8?B?cWlHRks3UXVIM28rQXBuK0dmYnFYQlNnUm5FWTl2N0M5YlNHL1hmOFVqUzhp?=
 =?utf-8?B?S3V5QU9MaWZhbGI0OURlNG9Xd1hlNHd3ZTdzYm1lZVdEU3R6eTFWU0xpMzhV?=
 =?utf-8?B?TWE0TWlIeEthVjhMZ3pQcnVBWjgremhUK2dqTWpOcVVoTWxFUUhFa0FuUXA4?=
 =?utf-8?B?RDhHTUJqRkswbExkcTRNZVZ6SVhibmZtbzI5OWtkYTVRWjBvdFc1d2pnZ0RC?=
 =?utf-8?B?ZGFIT0VWT2dhVldISzFpVUlJYmVGTzBOTnAzYWNMSWdsaFF2alJhY2JOZXhl?=
 =?utf-8?B?d2hhZFhYOENOQ1ZvbXdETkIrUXBpNlRLNkVZVkdTWERhR1V6blZWdzlhNGUy?=
 =?utf-8?B?Mnk2SDFMYXRUTzlxeFZzVURHTWE4NHJ5WWtZcXR1b3JGRkRMTnRrNTBUaDVY?=
 =?utf-8?B?bXNMdzRCeEN1VjhwbXp6TVlpbW5tL3NlK05waFZHMVllTnBpTEx5cW9GenBn?=
 =?utf-8?B?cVVyWmJsZDh5SEI3clFZNE5LcWVGMUZwZjRTY3owMjdLcWxoREl0c0RTMXgw?=
 =?utf-8?B?ajFKQTRKaVVjemluQTg4ZE85d3RPb25JcC9SQkNialE5SFdrVlBQS2Y2MHFE?=
 =?utf-8?B?Ums1M29paldnL3g4dHYxZHBwanA0Y3VUbGNSYWUrcjJTZ3RsUmlEQzFsUnE3?=
 =?utf-8?B?NHpGcSsyVjdOK3huVnNBdVpWUDJCcmhpeVVVMGFWWXIxTDBVSCtFd1JEODZw?=
 =?utf-8?B?a1dhd1YwdU90Z1BWU2YvbkY0eG04VVFLcjJFaElmaG1jcmtualVvNHBIbkpt?=
 =?utf-8?B?d3UxMkppWDE4TnNhOTNkMHJTT1F0aDFtWE85Ym0vTEI5RDVva3cwdmkyUmFj?=
 =?utf-8?B?U25ETStNMlZyQURYNTBYYTR2Q2hnN21GWHRBeVEyZ2ZqcHpYbG9VNmVFdTYx?=
 =?utf-8?B?Q0dsSFYrTk9BQUJqSldFdjFKYUhhcjNRc29hT0xyRitwWFNmRC9CTmQybnNQ?=
 =?utf-8?Q?EH9kucuLnZFzjUwIfxGc1AR48AV8dZjh27K8NOA?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <65B099918FC5FB419467785CB9213264@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac620b0c-d3c6-488e-c058-08d905babcff
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 18:16:24.1170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gq647piuMfirMabjm5R/u5zQ7BbLPGoSfGnefa9ufzj8IZMKjVy4wzf44xOBbV6ofJwH1JMjdZj0MDekaerHrZFoL+WBO7z5L0lOVdGsENg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4873
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTA0LTIxIGF0IDEwOjI5ICswODAwLCBMaXdlaSBTb25nIHdyb3RlOg0KPiAN
Cj4gT24gNC8yMS8yMSAwNjo0OCwgTmd1eWVuLCBBbnRob255IEwgd3JvdGU6DQo+ID4gT24gTW9u
LCAyMDIxLTA0LTE5IGF0IDE3OjMxICswODAwLCBMaXdlaSBTb25nIHdyb3RlOg0KPiA+ID4gSXQg
bWF5IG5lZWQgaG9sZCBHbG9iYWwgQ29uZmlnIExvY2sgYSBsb25nZXIgdGltZSB3aGVuIGRvd25s
b2FkDQo+ID4gPiBERFANCj4gPiA+IHBhY2thZ2UgZmlsZSwgZXh0ZW5kIHRoZSB0aW1lb3V0IHZh
bHVlIHRvIDUwMDBtcyB0byBlbnN1cmUgdGhhdA0KPiA+ID4gZG93bmxvYWQgY2FuIGJlIGZpbmlz
aGVkIGJlZm9yZSBvdGhlciBBUSBjb21tYW5kIGdvdCB0aW1lIHRvIHJ1biwNCj4gPiA+IHRoaXMg
d2lsbCBmaXggdGhlIGlzc3VlIGJlbG93IHdoZW4gcHJvYmUgdGhlIGRldmljZSwgNTAwMG1zIGlz
IGENCj4gPiA+IHRlc3QNCj4gPiA+IHZhbHVlIHRoYXQgd29yayB3aXRoIGJvdGggQmFja3BsYW5l
IGFuZCBCcmVha291dENhYmxlIE5WTSBpbWFnZToNCj4gPiA+IA0KPiA+ID4gaWNlIDAwMDA6ZjQ6
MDAuMDogVlNJIDEyIGZhaWxlZCBsYW4gcXVldWUgY29uZmlnLCBlcnJvcg0KPiA+ID4gSUNFX0VS
Ul9DRkcNCj4gPiA+IGljZSAwMDAwOmY0OjAwLjA6IEZhaWxlZCB0byBkZWxldGUgVlNJIDEyIGlu
IEZXIC0gZXJyb3I6DQo+ID4gPiBJQ0VfRVJSX0FRX1RJTUVPVVQNCj4gPiA+IGljZSAwMDAwOmY0
OjAwLjA6IHByb2JlIGZhaWxlZCBkdWUgdG8gc2V0dXAgUEYgc3dpdGNoOiAtMTINCj4gPiA+IGlj
ZTogcHJvYmUgb2YgMDAwMDpmNDowMC4wIGZhaWxlZCB3aXRoIGVycm9yIC0xMg0KPiA+IA0KPiA+
IEhpIExpd2VpLA0KPiA+IA0KPiA+IFdlIGhhdmVuJ3QgZW5jb3VudGVyZWQgdGhpcyBpc3N1ZSBi
ZWZvcmUuIENhbiB5b3UgcHJvdmlkZSBzb21lIG1vcmUNCj4gPiBpbmZvIG9uIHlvdXIgc2V0dXAg
b3IgaG93IHlvdSdyZSBjb21pbmcgYWNyb3NzIHRoaXMgaXNzdWU/DQo+ID4gDQo+ID4gUGVyaGFw
cywgbHNwY2kgb3V0cHV0IGFuZCBzb21lIG1vcmUgb2YgdGhlIGRtZXNnIGxvZz8gV2UnZCBsaWtl
IHRvDQo+ID4gdHJ5DQo+ID4gdG8gcmVwcm9kdWNlIHRoaXMgc28gd2UgY2FuIGludmVzaXRnYXRl
IGl0IGZ1cnRoZXIuDQo+IA0KPiBIaSBUb255LA0KPiANCj4gTXkgYm9hcmQgaXMgSWRhdmlsbGUg
SUNFLUQgcGxhdGZvcm0sIGl0IGNhbiBiZSByZXByb2R1Y2VkIHdoZW4NCj4gdGhlcmUgaXMgbm8g
UVNGUCBUcmFuc2NlaXZlciBNb2R1bGUgc2V0dXAgb24gaXQsIGl0IGlzIG5vdA0KPiBoYXBwZW5l
ZCBvbiBlYWNoICJtb2Rwcm9iZSBpY2UiLCBhYm91dCAxLzggcmF0ZSB0byBnb3QgdGhhdA0KPiBl
cnJvciBtZXNzYWdlIHdoZW4gSSBsb29wIHJ1biAibW9kcHJvYmUgLXIgaWNlICYmIG1vZHByb2Jl
IGljZSIuDQo+IHRoZSBwb3J0IHR5cGUgaXMgQmFja3BsYW5lLCBhbmQgSSBoYXZlbid0IHJlcHJv
ZHVjZQ0KPiBpdCB3aXRoIEJyZWFrb3V0IG1vZGUuIA0KDQpIaSBMaXdlaSwgDQoNClRoYW5rcyBm
b3IgdGhlIGFkZGl0aW9uYWwgaW5mb3JtYXRpb24uIEkndmUgcHJvdmlkZWQgdGhpcyB0byBvdXIN
CnZhbGlkYXRpb24gdGVhbSBhbmQgYXNrZWQgdGhleSB0cnkgdG8gcmVwcm9kdWNlIHNvIHdlIGNh
biBsb29rIGludG8gaXQgZnVydGhlci4NCg0KVGhhbmtzLA0KVG9ueQ0K
