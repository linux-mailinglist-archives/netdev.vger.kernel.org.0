Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED81B311887
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhBFCkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:40:16 -0500
Received: from mga18.intel.com ([134.134.136.126]:65190 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231189AbhBFCfg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 21:35:36 -0500
IronPort-SDR: 41ryumv7pSKAFwfFZe+gxN3zWySLptNaD9LLR+5wwt/SzMYoqXs1Qn1N1zPXgxmdUr00Fyvi5I
 sPcozPmnlvEQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="169188982"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="169188982"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 18:34:44 -0800
IronPort-SDR: ljBeDuKa6Yr+yFaZjVcaFIbksnGgw2RYMMiReG5jUdUW3Jfl07mR/o6kuFHuzVxmIF4ndhr2LH
 KmJV2HBbFHwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="484696212"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 05 Feb 2021 18:34:44 -0800
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 5 Feb 2021 18:34:44 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 5 Feb 2021 18:34:44 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 5 Feb 2021 18:34:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RVd/WZiOW23b6cAn2xt+MofMN2HrTaTCuEWuS1edWZrODhVZyNAPI0dWDfRiZjzi+mgrrd2kmD4umTeQVa+NOqJBqpX8oEBFlK+5jYadEL3LxcRx+5L9hidEd9U9MEnFgU/qx4NtMjtjhkRGUmHaassS2xY0ckALOZrOmrKr4NgNw8FHA+uW0n70EaeuDyZeN2hCetA7Om7nMAbzjHrkoDa+G66RGUuZrkh8084perXzb/BuwJXoH64jSTbh7thAn70RlbbnHzx5PwRDMHH6Xa710+vB3v7TWvqRp97KbMum5ARSGOJqxP7Ij9dd4ey5/tNgWVF8h6xC3a9qQMYNFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u+IN4ABxKb/4Vij2jGa/WRY3xr0psceAw7g0HKhnr2g=;
 b=JEonkVfrvCKVHDuswWDJBjvfPRhfVRWrJoSExmui+s6hGq23LXca54SFoGNmlu6iSRUfzRGewgA6b7v3r/+X91zJCL8GMtDepMTLZP5n5uboPfy98gbV/6SW1u9lnp13gn11+GW+HIbUy6P/QjoN6ROOFeOu1y99Eue4XrCJAsZ+R5Zr009vtcck4z8vWUlZw4zD6RtB4ehUPQb6cc+gcXIez1bEwnEbERNHtU/CY3vyNTMeWoCnK/ElyqFQxyMuRPx5sm7mhHdNQq8Dhh0ApRVun4RKwPw7NSNA3yU8HpjZsujR5Sdre6V/K8TUpCe8HA/Z36B8qTdIPg/VJODUDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u+IN4ABxKb/4Vij2jGa/WRY3xr0psceAw7g0HKhnr2g=;
 b=HD1kLJKBi0GhGcSybxiSgTvW9Qz6KEsoG7daPIlNwIcQf9ncwEFs2KKUoV1nDcTzw7ttDHPcstEbLpD6wZCvOpNx8bj5cYEBQeHQxQtF2gdYj2l6TKR1suMokQEK0J2ADwJwkpEnYPZuhpi3wxc3BeUBIi3bXOLOMdvAWFHllHA=
Received: from CO1PR11MB5105.namprd11.prod.outlook.com (2603:10b6:303:9f::7)
 by MWHPR11MB2046.namprd11.prod.outlook.com (2603:10b6:300:28::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.21; Sat, 6 Feb
 2021 02:34:14 +0000
Received: from CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::fc66:dd19:b156:7090]) by CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::fc66:dd19:b156:7090%6]) with mapi id 15.20.3825.025; Sat, 6 Feb 2021
 02:34:14 +0000
From:   "Brelinski, TonyX" <tonyx.brelinski@intel.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [PATCH net-next 04/15] ice: add devlink parameters to read and
 write minimum security revision
Thread-Topic: [PATCH net-next 04/15] ice: add devlink parameters to read and
 write minimum security revision
Thread-Index: AQHW9de4fnFutw8JEEyL1qk9k7ZaSKpG7iEAgABR7ACAAAmKgIABHW4AgAAtqQCAAd9UgIAAAS0Q
Date:   Sat, 6 Feb 2021 02:34:14 +0000
Message-ID: <CO1PR11MB51051C734F7FDBE9FBEBB9C2FAB19@CO1PR11MB5105.namprd11.prod.outlook.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
 <20210129004332.3004826-5-anthony.l.nguyen@intel.com>
 <20210203124112.67a1e1ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c9bfca09-7fc1-08dc-750d-de604fb37e00@intel.com>
 <20210203180833.7188fbcf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3d552bf2-0d99-18aa-339a-5a6bd111c15e@intel.com>
 <e31a1be1-6729-b056-8226-a271a45b381d@intel.com>
 <CO1PR11MB510517FC3ABC05123D62721CFAB19@CO1PR11MB5105.namprd11.prod.outlook.com>
In-Reply-To: <CO1PR11MB510517FC3ABC05123D62721CFAB19@CO1PR11MB5105.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.0.76
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b47b64ab-b1ef-41b2-3aaa-08d8ca47b1ca
x-ms-traffictypediagnostic: MWHPR11MB2046:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB2046550B5D9ED5D9428A917EFAB19@MWHPR11MB2046.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bir3Lo9sFLuRmcQbUyMB2jcMWos2On4UG8v/D0vEXx7bkTEJ00srhkF3NBLDno6jRRiVCppJCUkWGxMOla+nD4Zv+JwMAT2pqCWAEJ/UgSLvRi999R2EjiXJ91o/BTq7o4VSJEs69acPI6QhBcZ68LrE92pnwiCB8cy3cFcaf5aHq50qZJtq+rd3clmjleCi1xYoPWpJXR516xBl5HWTFg0aaCO9YCVUhw7U1tfKL56fBqYaJkIUWh3fkZs2f0iFOI6icUeHCR7tOPob+MJt1u79uuyO2JwJjenSD+dtFq9c4Au6l7F9SEV1f6dnOLR23yUFXvmTbes97kvMItmniBwP5UPDrVCSNokMYwUs4N61jU8IT2vR/8txsC4WrSxcSuFoJmFeeKxD8QgrcKsv6CJlxWzABdJv4e6KmK5mVYukiKYdVpDnCL0ST2n273w5IDHGgZTNNKPIOzbzAWPzSapK6Lu4nyxN6vyaKpTHJ7cLIf37D090B6xREKr0ot4FVg7sMjwEevjnf0RiMoIE8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(346002)(376002)(136003)(64756008)(4326008)(33656002)(54906003)(66476007)(8676002)(83380400001)(110136005)(76116006)(8936002)(66556008)(2906002)(15650500001)(71200400001)(6506007)(66946007)(66446008)(5660300002)(316002)(2940100002)(86362001)(53546011)(9686003)(7696005)(186003)(26005)(55016002)(52536014)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?T0NLbUpvQTVuYjUra3NTZGk0U2pGaEhOdlU3SWdzQXJWMHpNQTB1VExWNDJC?=
 =?utf-8?B?TVlnenBDekxkd0EwU21nTk1HRVQ5cHRvQzQxT001Z0wvQ2tNNEtObEhZZUlJ?=
 =?utf-8?B?WWdoNXk4TnNpc1gzbk5PMHRYMVU4bkhGRlVpK1A0VCt3Nlc2alNrK2RIakZ1?=
 =?utf-8?B?dlU3ME11dUx6bERySnhtOWVVd25RV2Noa3BNcjMrTFNFZXBzK1FQSHVhUC92?=
 =?utf-8?B?NHh3SnFqMlUveFZWNUtyc3Y0RlpGbnQrRDkwaGJRaHFlMEM4cXhUeG1hVVRE?=
 =?utf-8?B?K1RGYXFCNnhRV1IwWHBhNEVub0VYQ2M5OGZDeEtlcVdLaFg1SFNmbHRRWk1z?=
 =?utf-8?B?VXVyWEdGUXBybjdQUEhNL3BndU5zQUxGcGhlaCtTL3NwOXVCYmwyN2JSNnRC?=
 =?utf-8?B?MFRVbVpBTkZXMVhJM0hPWGRCKzkrcWMrM1h4TTBCbU1GcWtwck4vYlExenhZ?=
 =?utf-8?B?QXdUenFLcVhvLzZISW9GVGgwN2ZCam1CM21mRzBUQWt2UnJ0K1hOdUlKV0ZP?=
 =?utf-8?B?NFN5RVU3eVg0cE5xdXFTengyS3F2bU9ZV2hkSzhNWjVXNSt1WGpaZXFaQ2JL?=
 =?utf-8?B?V3Y3cFkzZWhHeFpRYXllTFF4N3JRc0hGcThxZURGMTlId0NOVkVadHRKdjlY?=
 =?utf-8?B?VGdIOXphS1pNb0ZnRk5DQ1ZoKytJem04bkZJVUcvTWc2UzRaNTNIa0NkNTJO?=
 =?utf-8?B?TjdVWEFPZERYTlhoYTk2SGxqcVBUUTVEM3haU1Q3cGtSOVZlSWVXSnFnK2VK?=
 =?utf-8?B?cmc0YW16bVVyNFVBdkxRRVZCU3hUUS9UaWp2Z3FpK2RqTE9KbWFZUFoxZTh2?=
 =?utf-8?B?V3h0TU1vYmdTdTlHTFR2NlFLZHFFaFcyOHdzdlRIWXdlY3hkWWRCOE45eHRS?=
 =?utf-8?B?Z3kyK0pydERab3NKS2RlR2d3ZkpKNTBzR1hYOGdwZTdRUG0wSkxnNHliMnlo?=
 =?utf-8?B?N3dCWmFlazBnTDRaNzkzbXdlbjIwOHF1aUdKbFRpMXJUNCtxdjNEN3dFQVcy?=
 =?utf-8?B?NjBqMEZlNXhjNDRncHRRU056ekhRZXJXejkwdmxLNWFacVYzUTBOYmM4MkV4?=
 =?utf-8?B?NEVrWmFjaXVMQTUvbzJTZUcyRFNLNjYyQlk5T1pVOGc4UXQ3SnI2bEJZcDN6?=
 =?utf-8?B?Yk8vcW9yMFovVkF1TWptdERnNFhRR0FBNlBHOVFmZEJpeHhzODJzbk1DaStO?=
 =?utf-8?B?TFZ3YzlSUHRQUUtzRFJvbGVrWTBJNXFWUUFWSnFPYUpucU1makNRcWhPcC9R?=
 =?utf-8?B?Zmg4Wkc2MFIxN2xhMnNQU0lOVlBnM09SOXVmdVhYbVQ5eGxBRXZBcHJHTEFR?=
 =?utf-8?B?eWdGMXpadE1taVRWYlA0bTNxdFRCSFlpUjFsa2xPVTBRdC9ndzNxdGl6VHRw?=
 =?utf-8?B?Z0FZQW9JS0RKZ3A2UHp3dHFEYWZ6T25QYUhVWnlJc0JvcmYyaXJjUFhNaE1P?=
 =?utf-8?B?YkdNSEZUN1I0NlZHMGxmNVF2ZUpVWGFYQlI4L1p4TkFpZDFlNnZxMmlYZXh1?=
 =?utf-8?B?TFNlZFN4YlVFOGtKTkkrSjlpcVhsSENzOXVRMDJ5dHE4dVlkaEdDTVRKdldw?=
 =?utf-8?B?Qm9yb3krZ3BSVGFxUHFIejJySEJQQnVERG1HQkt1V0ZVaStSV0NGUHBoblpx?=
 =?utf-8?B?cm4wVGxWenE2SENaUGtLY3VydnRJWGFyclJ2bGd4aWhHWTdIVVkzMldYakxm?=
 =?utf-8?B?eWZWcWtOUElvMTNXVWhiS1RsTnpQMXRWd2RaNXBRTFp4bm96ajdPQkgwbktw?=
 =?utf-8?Q?Y/C+0rF0BvJeB5CZbh+EUWwH1UGEJjgCX79gnbW?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b47b64ab-b1ef-41b2-3aaa-08d8ca47b1ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2021 02:34:14.5442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pj4o/7WbGpFE8MVL7Z4MLT3T1miAMudbNgK07i+0tA2Hmw8ZV+5LcZybeA/NS69uoW8K+YrtjnG1dg0yGOVUow8yC1r5x+6J4f9gHNmSxXU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2046
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQnJlbGluc2tpLCBUb255WCANClNlbnQ6IEZyaWRheSwgRmVicnVhcnkgNSwgMjAyMSA2
OjMyIFBNDQpUbzogSmFjb2IgS2VsbGVyIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+OyBKYWt1
YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KQ2M6IE5ndXllbiwgQW50aG9ueSBMIDxhbnRo
b255Lmwubmd1eWVuQGludGVsLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmc7IHNhc3NtYW5uQHJlZGhhdC5jb20NClN1YmplY3Q6IFJFOiBbUEFUQ0ggbmV0
LW5leHQgMDQvMTVdIGljZTogYWRkIGRldmxpbmsgcGFyYW1ldGVycyB0byByZWFkIGFuZCB3cml0
ZSBtaW5pbXVtIHNlY3VyaXR5IHJldmlzaW9uDQoNCkZyb206IEphY29iIEtlbGxlciA8amFjb2Iu
ZS5rZWxsZXJAaW50ZWwuY29tPiANClNlbnQ6IFRodXJzZGF5LCBGZWJydWFyeSA0LCAyMDIxIDE6
NTQgUE0NClRvOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KQ2M6IE5ndXllbiwg
QW50aG9ueSBMIDxhbnRob255Lmwubmd1eWVuQGludGVsLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5u
ZXQ7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHNhc3NtYW5uQHJlZGhhdC5jb207IEJyZWxpbnNr
aSwgVG9ueVggPHRvbnl4LmJyZWxpbnNraUBpbnRlbC5jb20+DQpTdWJqZWN0OiBSZTogW1BBVENI
IG5ldC1uZXh0IDA0LzE1XSBpY2U6IGFkZCBkZXZsaW5rIHBhcmFtZXRlcnMgdG8gcmVhZCBhbmQg
d3JpdGUgbWluaW11bSBzZWN1cml0eSByZXZpc2lvbg0KDQoNCg0KT24gMi80LzIwMjEgMTE6MTAg
QU0sIEphY29iIEtlbGxlciB3cm90ZToNCj4gSSdkIHJhdGhlciBzZWUgdGhlIHJpZ2h0IHNvbHV0
aW9uIGRlc2lnbmVkIGhlcmUsIHNvIGlmIHRoaXMgaXNuJ3QgdGhlIA0KPiByaWdodCBkaXJlY3Rp
b24gSSB3YW50IHRvIHdvcmsgd2l0aCB0aGUgbGlzdCB0byBmaWd1cmUgb3V0IHdoYXQgbWFrZXMg
DQo+IHRoZSBtb3N0IHNlbnNlLiAoRXZlbiBpZiB0aGF0J3MgIm1pbmltdW0gc2VjdXJpdHkgc2hv
dWxkIHVwZGF0ZSANCj4gYXV0b21hdGljYWxseSIpLg0KPg0KSSB3YW50IHRvIGNsYXJpZnkgaGVy
ZSBiYXNlZCBvbiBmZWVkYmFjayBJIHJlY2VpdmVkIGZyb20gY3VzdG9tZXIgc3VwcG9ydCBlbmdp
bmVlcnM6IFdlIGJlbGlldmUgaXQgaXMgbm90IGFjY2VwdGFibGUgdG8gdXBkYXRlIHRoaXMgYXV0
b21hdGljYWxseSwgYmVjYXVzZSBub3QgYWxsIGN1c3RvbWVycyB3YW50IHRoYXQgYmVoYXZpb3Ig
YW5kIHdvdWxkIHByZWZlciB0byBoYXZlIGNvbnRyb2wgb3ZlciB3aGVuIHRvIGxvY2sgaW4gdGhl
IG1pbmltdW0gc2VjdXJpdHkgcmV2aXNpb24uDQoNClByZXZpb3VzIHByb2R1Y3RzIGhhdmUgYmVo
YXZlZCB0aGlzIHdheSBhbmQgd2UgaGFkIHNpZ25pZmljYW50IGZlZWRiYWNrIHdoZW4gdGhpcyBv
Y2N1cnJlZCB0aGF0IG1hbnkgb2Ygb3VyIGN1c3RvbWVycyB3ZXJlIHVuaGFwcHkgYWJvdXQgdGhp
cywgZXZlbiBhZnRlciB3ZSBleHBsYWluZWQgdGhlIHJlYXNvbmluZy4NCg0KSSBkbyBub3QgYmVs
aWV2ZSB0aGF0IHdlIGNhbiBhY2NlcHQgYW4gYXV0b21hdGljL2RlZmF1bHQgdXBkYXRlIG9mIG1p
bmltdW0gc2VjdXJpdHkgcmV2aXNpb24uDQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0NCg0KU2NyYXRjaCB0aGF0LiAgSSByZXBsaWVkIHRvIHRoZSB3cm9u
ZyBlbWFpbC4gIFNvcnJ5IGFib3V0IHRoYXQuDQo=
