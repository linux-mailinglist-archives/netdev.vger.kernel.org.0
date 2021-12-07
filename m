Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0893746B98B
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 11:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbhLGKzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 05:55:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:62901 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235401AbhLGKzh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 05:55:37 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="235066328"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="235066328"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 02:52:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="461214664"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 02:52:06 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 02:52:06 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 7 Dec 2021 02:52:06 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 7 Dec 2021 02:52:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ox0IQf3iQjhj7eq6qcqxaT0w3/jZMvSgwMXUPYO4cyvVZ7uAnylSM2ENYhMdlWatexNDPK88c6udg8+i2uMjV+T9fVewTzSJLTwNpI2TpX0oGQfIRBWAkSCNL3EsmkJFx/1Z+RmGJOgkN0wywEtUSpELF2seLG/8aM8EAx68lan7vww2fba683lE3hGHV/gTzSonddovdrffbPX0rdkyJZaMDZroSni6cGoaowWO0dGJJIrZ2I1tdhQvxKoR904FKFEgOQYfct37asP+LGlimKf/8AEYP3VMVbGYCaPXMhRg+QQkYgthtjgONo4kunJSciTCF9xjKfdQhU6RAYCiaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dLdGY8FiPzXLYSUlFyqj5KcMMSJgfmuWO9q9cPVc2Xg=;
 b=UaxWwx1qfMy3NPXwdIQ46IWhVX385sCj1RowXplosXZZHvcAisP9R1snGm27PMIxYxzHc0Rfuxp9NuOirgD/WNDvnq/7Op9Q9Y7jn89BlZaAfIyGaNNmTm/Y4xsVlnIO8zL0nCzEUoht9NBCRk6I0HCZ/5sjOPY4T7ti+Yf9E33Requ6XIvLwue6W16X0rTzur2VU+phtjloNnpUhT9DpbYthuktHYlIWHd44h6rAxdCHpUCBKL8PymgdqG+AsUjyRnQTc8UvReSmCJlAcMd0oo4g0BCaatZCFBFUu8V7QPBLwnjNhQDgW47RE1Vm0jNGuWAhy7cPg4mBQWetgGVAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dLdGY8FiPzXLYSUlFyqj5KcMMSJgfmuWO9q9cPVc2Xg=;
 b=H90exlTJeW0lPBavOOpphCgyNZgFbsJ0TnaWB+glSeJPtxyOEuxcMNSm6KkD/mxrs3kCoXclUiKXX+H0ekb4joZwXtNEKDb2mII15e0TMD006pFiFYr4UZy8kg9QOMXQTPmFr0UytAufnoyVS/7kW4e5gscfh554UsWv+P0PVxo=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BY5PR11MB4021.namprd11.prod.outlook.com (2603:10b6:a03:191::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Tue, 7 Dec
 2021 10:52:04 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::f0a6:e61:94db:53b3]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::f0a6:e61:94db:53b3%7]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 10:52:04 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "arnd@kernel.org" <arnd@kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "stf_xl@wp.pl" <stf_xl@wp.pl>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Beker, Ayala" <ayala.beker@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH 1/3] iwlwifi: fix LED dependencies
Thread-Topic: [PATCH 1/3] iwlwifi: fix LED dependencies
Thread-Index: AQHX6TXUAVA3Di08x0ieNNMHdmaMJawm1BIAgAAAZ4CAAAlGAIAAAMMA
Date:   Tue, 7 Dec 2021 10:52:03 +0000
Message-ID: <38b5bff4e24db266537bb8e3161d87c603c020f2.camel@intel.com>
References: <20211204173848.873293-1-arnd@kernel.org>
         <c9acebcef9504ac6889de25d528c3ea0c590b1c1.camel@sipsolutions.net>
         <fd1f5c0f0a9a6b3f59ed0d03e963f87bf745705f.camel@sipsolutions.net>
         <dc7d43b96cd1a40654bb2da009ea515b8ded40c3.camel@sipsolutions.net>
In-Reply-To: <dc7d43b96cd1a40654bb2da009ea515b8ded40c3.camel@sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63bf2c3d-8ae1-4569-5341-08d9b96f9ae3
x-ms-traffictypediagnostic: BY5PR11MB4021:EE_
x-microsoft-antispam-prvs: <BY5PR11MB402134198A4E3106EEE394A0906E9@BY5PR11MB4021.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: frwnL1TRxCbvbtG9Pyf+MNXlmFudG09Vf2dpdhbOfbpDN+NM1nEun38atEEDZOT7Ohu4I9pydAGHPifzI9Y9Azagy0q3SF0BwTeJgYzZFgei6MJvaaPihmUdMnF2fS/IWL65C1esTbgPjlEHDg+WzV+7DpfU4vCeuwsQpTrXNuXT7Xj55t9JxdW7QEyaUVFUxdwPAww5SiWWqkZRZjMxegvaUlsd9wdhoig4VVYGdMA20NXP3gKnN0nB84YpCP8OVzcPPgS7M1zgG5u4E9+s69pKLIJ8AE3E33wdZksRejtf4HSJkjtK2kLNmZbY+3hjckohz87vZ15w+ImysNunSKrfkoCtQqf9UaLDBUTEexxZOXVcFZ5EdKr48WziWUwIER9MEMO0i4gQERDYp+yj9BZduWsaejyDrrluhMFYe8MRtv38z4xcIu13lBnraQVSwtdxZZ67BfH2Ri2maiT3tzJr6J53yT2BEy48OVf09aN7Owqzvir/WWOv1Dnvy3iPSECu1l494eEtMOLDcbOmhDMux9z/U70H24P6KHX5GiD4vZ8rTTCmGv3/X3bMIbreNKDSpsnA6Sg6RVUkd2WGjvqdUndxMH7TFtKW96W0aaiRv9g3cy+fEWTbzGw45+OwGEw3yOT0bV06rALsqDQcFyhc8pArGGlIccPBmLkiFEWNkZgg0GpRdzSF/pqYFyBYifxE/jczDvr/BTo4g1hITQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(8676002)(7416002)(38070700005)(26005)(54906003)(122000001)(110136005)(186003)(82960400001)(38100700002)(316002)(6512007)(66476007)(4326008)(76116006)(36756003)(508600001)(8936002)(4744005)(66446008)(86362001)(66556008)(64756008)(91956017)(2906002)(2616005)(66946007)(6486002)(71200400001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGIyay9neXVEdFEzNUdxc05NMm5zODR5NGRjNE5UQkMwaXRiTWVhTnpxbmFE?=
 =?utf-8?B?SldqWlZHSFIvd2VFTGRyL3I3N05OQUo4d0FTWFVtUHJ4dzNOT3l2SFQ1dEJk?=
 =?utf-8?B?WlJOTFFWc2REelRISmVocGZDdWRIQm5WUTFCdTMxbEwvOXhDTk8ybnovUHJo?=
 =?utf-8?B?RWdHcXgyVGFtTlBXUVRPbzVqaGtwSjVIRkxMdHhDM0hCQlFrVGlHT2ZtREhS?=
 =?utf-8?B?NVo2bGRsMXpnQWNFSGk1c3dRZmNCRXJOZGxmWHpyV0svWlU0KzhUSU8vbEI0?=
 =?utf-8?B?Sjc0K1RXd2pLZmJvZGVHWGRuVTRTOWNlOXNRdmgwaTVGc0pHVHp1aERpbllL?=
 =?utf-8?B?RzloRjhBeE9Tc0VWSFQ2SHVVQWE1U2NrU0llNkZRenJvUXhJQnpkVzIzeWlo?=
 =?utf-8?B?YlZIRVZ6eGZvY2wzbVJLTndHNmNmZlA1WGFQNXAyVFhCMkdKc3JBdG5abWJx?=
 =?utf-8?B?QTNuZWg1TEJIMXBhYzk0ZHk2MEtFcTFpU2pzTGxzNjJMRmRqZy9QdU1uekx3?=
 =?utf-8?B?a0Y5dm0vaEMvN1hxc0VtTGtBcGVMOUZJMDIvRnBxSmJpY2ZqQThFRTd3UWhz?=
 =?utf-8?B?amlua2VlSk8rKzdTV2RnQy9XanYxVGFjcVZHMTU4VWRJa0lnM0Y4RFBxMlU0?=
 =?utf-8?B?Szg1S3hYUVZ0RnFNenhINExWZTFRbnQwNnl2VjFPZG5jV3U4UEluUXBJRGpT?=
 =?utf-8?B?R0c5L1hTRWtxektYcUxDblBoV25JV0Jic0F2NUFzSE8rczZteHNMdFdiOENU?=
 =?utf-8?B?NTQvUkV0SnRHcDAvcCszV2gyUC9wSXY0c1NkNjNwditud3FRUnhxdFk4RFVB?=
 =?utf-8?B?eCtkV0cxdzdhSlhOK2pGWWk1Zk1VeUE4cG9MN0dEM0RRVkVja092NlJQaXJh?=
 =?utf-8?B?ckZHdXdqc1l1eElveGI2SkdyR3NDNDM1TFQrbVhUM0gyWkhPbDR5WDczTGEz?=
 =?utf-8?B?enZrRnRMTmwvejA3bVdHRkxHdEVzcjdSTFp4U2VEQTNHMnhjanV0YmFnSmZh?=
 =?utf-8?B?K1NwNVJyMktYaEFoeng5ZmpLM3hRTG01TmR3R3FBL0tZOWhlY0pmYVJuc1RY?=
 =?utf-8?B?eGRFcXpIdDZkK2plRTVTWXpjUUlxSGovclBId0VSbkFBYUp1MXJybEtXWnR4?=
 =?utf-8?B?M292YXgxUWRHWThRdUNyRkk1cGJjU1NMbWVoUngwZGk0L2R0RlRoS3pvTG9z?=
 =?utf-8?B?Q2l3Z3hLY1lZYlgrS3l3dG9SNFVWclNnNlAxM3NzTFdDYmh2MXJIVVdMeC9o?=
 =?utf-8?B?NFYxRUtja0c0R01yaVpoQTlOZEJOWGEyb2lEOGRUZVVmNjF2bThKcklwTUd4?=
 =?utf-8?B?YUpiRzR0ZThoMDV1ZEhKV2g2WVJyRTI4cDZING5ITEVOYVJUQVlrVG9NQlA3?=
 =?utf-8?B?Tmk1UG9FSEY5MTZYNjBZUTI2K1BXdm9lUkVaVi9LaEFWK00yYU9PWHF6Nm12?=
 =?utf-8?B?MkpqOHhHNkJqc2phU3lDblg0M1JFSkxrZktHOXBhdW5RNWUwRURVeHlIN3M1?=
 =?utf-8?B?ZG1MUjd3YlVPN2V3ZEJUV2RMVmJlS0dQa25ia0dKTzc5bENtNmJDQzJjYWx0?=
 =?utf-8?B?TUIwU2VXdzVxejh2Tm1GWVdjR3YrelBmTi9LUFVpNzRxWU9sVjZmakU2aGp0?=
 =?utf-8?B?SzlOMkxwVm16YjRIRFp1Zmo0U05mRnZhUVNmcndXdnNEQjZyU3F1czRqS2di?=
 =?utf-8?B?eHlJTkhPMUhBeENvVEliMzhxSVY4bVcxM3hwcE9GUHBiODR0Y3NGbThHNTM2?=
 =?utf-8?B?K1RnSlUxd3JUYTdWZjJWTWN0T3ZYK2NObytYZ2UvV29qTWNwLy8wSUNvaGJK?=
 =?utf-8?B?TUtQL2NBa2FVeHpYWGZvNzhNV2tDSWxHc2EvaDVjcFNuVCt6WGtab0JxR2M4?=
 =?utf-8?B?eVg4UHhybk9rZGlOYXFDZUdpaGtZR0lsU1hEWTY0TUYvQ0JXeE1lbGRYSVVo?=
 =?utf-8?B?L1FSa0xRRWFHZmRkMEU0aDlpeDJvSkZxbC95Y0dkYXdCWmlzNkpSeWtHV3p4?=
 =?utf-8?B?Q0lweEtzV1ZiaDZUZktEMUxIZlBWaHRlcHpDUmJvNmpUMFYwdGpkVjVqVnNn?=
 =?utf-8?B?dzBOSGpRVWEyUllTVDJJdGlVSmRjYXM4a1dTNGwybVJ3WWR2cDZBWDd1aDJr?=
 =?utf-8?B?SlFMenVwNWJNZ2dSMEhVSVRXOWtMK1U3TE1nMVpzVDlsWnQvcnNGNTRkbWtI?=
 =?utf-8?B?endkU2xrUGY3Z1NTMnhTZkg5NVgyZTk1bjVDZzBudTRLak1nK0V0d25rUitZ?=
 =?utf-8?Q?omoeRsP94PmC9df3s+ybxeS59GI6e/RRCZXJa/BnDY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <455CDB45EC7CC3439666EB0FBFA66E8A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63bf2c3d-8ae1-4569-5341-08d9b96f9ae3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 10:52:03.9534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ipcQFx2Dy9wPH9BcavuHOz4KjL8hNbTbEAR9LILZisUTpX+hNNeJbL2f50Pxcu4RTDNykz9lnGU5w8i0p2EThY2B+0XIztmducv9Hlmr3RU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4021
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTEyLTA3IGF0IDExOjQ5ICswMTAwLCBKb2hhbm5lcyBCZXJnIHdyb3RlOg0K
PiBPbiBUdWUsIDIwMjEtMTItMDcgYXQgMTE6MTYgKzAxMDAsIEpvaGFubmVzIEJlcmcgd3JvdGU6
DQo+ID4gT24gVHVlLCAyMDIxLTEyLTA3IGF0IDExOjE0ICswMTAwLCBKb2hhbm5lcyBCZXJnIHdy
b3RlOg0KPiA+ID4gT24gU2F0LCAyMDIxLTEyLTA0IGF0IDE4OjM4ICswMTAwLCBBcm5kIEJlcmdt
YW5uIHdyb3RlOg0KPiA+ID4gPiAgDQo+ID4gPiA+ICBjb25maWcgSVdMV0lGSV9MRURTDQo+ID4g
PiA+ICAJYm9vbA0KPiA+ID4gPiAtCWRlcGVuZHMgb24gTEVEU19DTEFTUz15IHx8IExFRFNfQ0xB
U1M9SVdMV0lGSQ0KPiA+ID4gPiArCWRlcGVuZHMgb24gTEVEU19DTEFTUz15IHx8IExFRFNfQ0xB
U1M9TUFDODAyMTENCj4gPiA+ID4gDQo+ID4gPiANCj4gPiA+IEhtLiBDYW4gd2UgcmVhbGx5IG5v
dCBoYXZlIHRoaXMgaWYgTEVEU19DTEFTUz1uPw0KPiA+ID4gDQo+ID4gDQo+ID4gV2VsbCwgdW1t
LiBUaGF0IHdvdWxkbid0IG1ha2Ugc2Vuc2UgZm9yIElXTFdJRklfTEVEUywgc29ycnkuDQo+ID4g
DQo+ID4gTWlnaHQgYmUgc2ltcGxlciB0byBleHByZXNzIHRoaXMgYXMgImRlcGVuZHMgb24gTUFD
ODAyMTFfTEVEUyIgd2hpY2ggaGFzDQo+ID4gdGhlIHNhbWUgY29uZGl0aW9uLCBhbmQgaXQgZmVl
bHMgbGlrZSB0aGF0IG1ha2VzIG1vcmUgc2Vuc2UgdGhhbg0KPiA+IHJlZmVyZW5jaW5nIE1BQzgw
MjExIGhlcmU/DQo+ID4gDQo+IA0KPiBIbSwgbWF5YmUgbm90LiBTb3JyeSBmb3IgdGhlIG1vbm9s
b2d1ZSBoZXJlIC0gYnV0IE1BQzgwMjExX0xFRFMgaXMgdXNlcg0KPiBzZWxlY3RhYmxlLCBhbmQg
c28gSSBndWVzcyB0aGF0J3MgYSBkaWZmZXJlbnQgdGhpbmcuDQoNClRoYW5rcyBmb3IgY2hlY2tp
bmcgdGhpcywgSm9oYW5uZXMhDQoNClNvLCBpZiB5b3UgdGhpbmsgd2UgY2FuIHRha2UgQXJuZCdz
IHBhdGNoLCBLYWxsZSBoYXMgbXkgYWNrOg0KDQpBY2tlZC1ieTogTHVjYSBDb2VsaG8gPGx1Y2lh
bm8uY29lbGhvQGludGVsLmNvbT4NCg0KDQotLQ0KQ2hlZXJzLA0KTHVjYS4NCg==
