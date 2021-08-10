Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F4E3E8609
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 00:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234877AbhHJWYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 18:24:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:16168 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234830AbhHJWYq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 18:24:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="214733128"
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="214733128"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 15:24:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="506467876"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 10 Aug 2021 15:24:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 10 Aug 2021 15:24:22 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 10 Aug 2021 15:24:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 10 Aug 2021 15:24:21 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 10 Aug 2021 15:24:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8K4wxIER3FZXfw/nZH4SUdU4tayumxUfMPY4XbaI6VHJ2arHiVk0qcpz/+gkx4SyfwLx8SBsFM9caCquRrvNbOGDTh7Fi8PuPmxE3Qq6QA+dZqbj6S5m2MW4lFBvlwfE6OJrP0XlTvycHsRimLX0okcvmMN9wKis3PsyP/OP9Q8kQSSugI4iwLuCdDGxJlNTZpQD6wVpaqSsoqcUPu+De8tGmmzZndyZvNVqq7fV7JGVu4GgmeX920+Vs+YqkXnTyx7snVTpcZn+qA9Chhp2V14pXio+bIuhaplWQadvsoggu9L+di7SltOQkNXG9MSbTf6yKYaw28sXGWsHYOWcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKCw2E7pMjK4Yk1p5zNoxexMRXzJOqpEjAUaaOon4C8=;
 b=ImY79P4gG8BVAh1KaQIhfMwlvFAm1P/vba6VHMZXLf1gBFm6NprDKxlawdrKW0t2vUN9RVCy2HynO+sZLwQuKKER7mTuQflVzHBEOJyCH+p6xbBKkb4HFZ3+8wCQVWMgrCGO7qAkQo7+TnRnt4aNdlwDs9VI7imeC/1xaiCO+/5P/y3L8a1jD4SDpdzZMygbud4FksQveYNObYzGHMXDZ2LTf7hGMUaVHLirtgCpnJnb1EtDwRk6lW/8mhMsswEpGsxTYs3w2eD6Q4jSF+4uExGBDSDK8OSQxux/NJFg6I8RirSwlawGj3WUdotaDeZpbv+A4OvVxKENdyRPwITL4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKCw2E7pMjK4Yk1p5zNoxexMRXzJOqpEjAUaaOon4C8=;
 b=qO3GZFxVNFY5/4A8DTp1wkRqc1NI41RTYLl1AIlrIcMO0+dWxL0bGQBX4STdo3BPHcntsuybsZk4fDt0cRgeX/dih6R2k0orv91ijTZeIAjcQDqA+0Ouy+AbbuAQbJH5NPoMjbEXhEjttH9azfo0yoUIP/bYytxB1FdOfKGqmPE=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW3PR11MB4697.namprd11.prod.outlook.com (2603:10b6:303:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 22:24:21 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960%3]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 22:24:21 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "pali@kernel.org" <pali@kernel.org>,
        "vadimp@nvidia.com" <vadimp@nvidia.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Thread-Topic: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Thread-Index: AQHXjQh2iw3UgViIbkGUQrHAheSIDKtrO5cAgAEcgYCAAGu3AIAAAh0AgABxmACAABTCAIAAAaEAgAAE8AA=
Date:   Tue, 10 Aug 2021 22:24:21 +0000
Message-ID: <76a75b55-0566-fc82-829e-b8cadcc58c7b@intel.com>
References: <20210809102152.719961-1-idosch@idosch.org>
 <20210809102152.719961-2-idosch@idosch.org> <YRE7kNndxlGQr+Hw@lunn.ch>
 <YRIqOZrrjS0HOppg@shredder> <YRKElHYChti9EeHo@lunn.ch>
 <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRLlpCutXmthqtOg@shredder> <71a5bd72-2154-a796-37b7-f39afdf2e34d@intel.com>
 <20210810150636.26c17a8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210810150636.26c17a8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3533b5da-5647-486f-2a54-08d95c4d99d9
x-ms-traffictypediagnostic: MW3PR11MB4697:
x-microsoft-antispam-prvs: <MW3PR11MB46978171036C9AA6F0B8E7A1D6F79@MW3PR11MB4697.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AVuOy0fsqh2CCi/ZYuA9HLATIhJVIS1UspwUvT0k96aUXy5AKsU1/GzYwQrR0NeQ6np7rBUtmCklp1V4yf7WC589GWSRTXaWi/wSZz9nOTOP26jSXAlLufNw8LYyTw009Da1V7ig9uvq27rvPq5mSiYCDNxFePSoH1POWB972rIZfEhPK24vVP3K5hKgeJNnr2nhWHJE25t+Ke9CBqQskgKIcQimPR1ZSRYObA37Piz5hjzGfmEA6y+i/VWn2zXPIIZV6glpxiEiImMF1DxA4V+oGs+Z2x5HSZ4/MXXSoIhdKxiuFigVxeKtk2vCo/7urWpH397qTvcaESgNISy4PFw6pmRLXNA42Tez94TSUNPByBLXW3f6QxGuMsuqMMZibPbG4SGKR7/f/3DsV9ZEZEjfpPwbw64rfHH+YEdhy2rZIIcJKHyVLLLf8leDwh+WiL9dxDPMXOesjW7bppEzSaRm/TMq23nHrPR/aOOBPuDCL3Cy1GBR7Tu2vmko7JXrzwm0uFBP2zkvGnj4HHdsVjuwuqAvd3CrmhF78FDCqhOJLQxsT24t/334on9AaWS8mDjVS3tVJUs/TvMKsfoBjuhhlvPQ2tVwdGVt6gJPZ7OX38LtMkHBKjmcCe5rkgOOjRwpvaF7z47R9Ulhx8d6ouiRxVZA33yzKZgege8ztjGrF0q6DEEfUxIa3u/Xsb64jXveIYHzI9BOgKwP4zgfCVccchR64Pi/QPS13zDz1Q9EM9j13afSoTpYGcW7VD8CPyaYfD1k7kNO/Cniu0irA9OZfChF0JvHrk1RHlCzhXLe5J61UuLJNXCRZ0x7MqyB2w8u1MjWCXSj7TB9m3Tq/fX6nrk+YMwr25KfktCjrsbvp9QoxOiJGFkEyAbQZTOIyeU2QRXlau9Sk7jruW2CFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(53546011)(36756003)(26005)(186003)(86362001)(7416002)(6916009)(38100700002)(31696002)(66556008)(66446008)(64756008)(38070700005)(316002)(66476007)(6512007)(966005)(31686004)(76116006)(2906002)(91956017)(66946007)(508600001)(83380400001)(2616005)(6486002)(5660300002)(54906003)(8936002)(71200400001)(4326008)(6506007)(122000001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUdDbWhWdDV3OW5GM1VVWGtLMmE4WE4zZ0tCZk00TmZMTEI2UGNWakxiTjlQ?=
 =?utf-8?B?RmxKNkE3bUg0Z2lvVUlpYzlSVkc0RTVqQW50VVNDZHdWd2Q3Rjg0cjJvQ1dz?=
 =?utf-8?B?cloxSy9hT2tNaWxudVExR3FGSDdGSjBNYSs0djBublYzeXpwSEdqdEk0dEc1?=
 =?utf-8?B?ako3TVJtL2xMV0grUGFIU1dhL0JYTFdQODBBY3dPaUZRTTlPS1pwVCtiWkRm?=
 =?utf-8?B?NG5ETXc3TnRrTjRkS1QyZ3kvTkNCNFNGQitkV1NORmg3NXM2blhURXkxMkNF?=
 =?utf-8?B?MENaa0dJblUyVW5maDZybzFhU2pYWDhNSFByNWNNL3pGQUR2Vm9TelIzUnFJ?=
 =?utf-8?B?UDVXbzlrb0x0UjdOS0RvOWZBTC8xTDNCRGg0akJYSTlKandRNFJacDNqT3hV?=
 =?utf-8?B?Q2NBMGdCTGJXdGRkS3lmTTRzZlVOL2ZjZFhRSUdUcGRYSlRDZnN4SHFNeVh3?=
 =?utf-8?B?TVZHOStTS2dib1Y2TnJaemRXUE1IMkZ1d2tYZjNmOGQvQmpPakVzUnJ5QW5V?=
 =?utf-8?B?YVgxWW1IQmZ4alk1bi9qYUNkdVNXdUpmaEMrVFk4TUVkTlhqaFE3TnpwTHVG?=
 =?utf-8?B?ZGpxV1ZUK0ZxQ0hzcm9pZThWaGludnRRYThkVmhwRjdhRjVOaVF0enNCajl6?=
 =?utf-8?B?QkxqcWlEYVViOC9YUGxPM2VLOHhYck1yTFgzNTVUUzdIeEdVTE1HcFhTMzZr?=
 =?utf-8?B?SnhFQUtEU1ExbXRwY2doUVJBQktEM2JzQ2huM25ZOVlmQlYreTJTeGZYdDlP?=
 =?utf-8?B?SDl0VStNWTdBckpWbEN4VURYM1FnRDA2S2ZBQWw4VlJPd3BVU3o3Q0pKVnM4?=
 =?utf-8?B?dkhzWjV0Ti80Wi9vdis2alJBM1lPSXdiUFJ4YWVraG9HRHBSRDN5eGFic2dp?=
 =?utf-8?B?alRIRU1qNlpNWTEvbTlwVnUxMTJuOG1vclI3aDBzNmtEZ1lQOTlidFQxU1Fv?=
 =?utf-8?B?b3MxaWEvQjRSK2RFWDJMM3VpcW05aHI3UmZyZ2FiRFcrTEZ6MENPOEJmdVFr?=
 =?utf-8?B?dkJYRHI3NVdQaHh2Z1BxRW9IaVNORHl2YmVrclhrTHpuNmd0Q1JvS2V2b05D?=
 =?utf-8?B?THFjcGRyZTFHY0N2ZS9QYy9qZXFFU2luVFkzZ0JzN1JGdWF0aklPRTI3dXVp?=
 =?utf-8?B?eGFTdWNRUXhUa00wL1RvTlVuZTg2K1VuS091UWVBNURrdzFsek9XSHVGS2xN?=
 =?utf-8?B?Sk5Ta1VkVnN2Q3ZmOVRoWm1zZ1NkRDNhb1dhb3kzRE9tWlludTdLRHkyTXAr?=
 =?utf-8?B?ajdzZXZGV2FzOHN0UE0rRlozVFZyamprOHhRSStVV0VGbGl0K2NSQ3owazlU?=
 =?utf-8?B?RldLNm95SVFpZlU4emFDQkhxeTVUSWM0Y2tNcmNOb3BiMDF0K0c5S3phZmZn?=
 =?utf-8?B?Wnc3dEFpOEU3UlVOcWROYmlDOU44Z3ZWb2FjZ0U0SlY5M0U5Nis4MTUrYWsw?=
 =?utf-8?B?RDE3a1Z6ekJSR215dFd0NDJib25CdHUzam9GVFp5dkVncHdWWnVvbXpYM3M1?=
 =?utf-8?B?cjEvQlJjeVlEQUNFN05GbVpIOEpXeVNaelVoM0plcEsyT1pEOUQ4cG9Jb3dP?=
 =?utf-8?B?M01CZkx5RTNDKzJIVCtkL05sdStMZ0ZNVjgrRVV0RytQUHJocmkyd080bWZF?=
 =?utf-8?B?ejNkWlB5aWU0aUQvSmJ4WHNKT1R6cjRTbzIraUxGVTgrWGZJb2xGbGNBT3NH?=
 =?utf-8?B?Vk9pV2xiVlIrclRjV0VoM1VtczJ4cE1FeisvWE0vaTIvWDdPNHU5NGJmU0Vk?=
 =?utf-8?Q?7eSj4HWXv62qpwJDzA=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <623CEB2FEF6C1D499E6E4A638FAF796E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3533b5da-5647-486f-2a54-08d95c4d99d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 22:24:21.1854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EPgaLDpxuM1L8QKk5dMdarE+z+CotVGZYETmdgKw/0QuhBs6fBFhEKyA4jx8igiqMes/0XKD+gdcEsnOwHFFeEgiJHwS+3XdpJqfxNEdW3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4697
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8xMC8yMDIxIDM6MDYgUE0sIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiBPbiBUdWUsIDEw
IEF1ZyAyMDIxIDIyOjAwOjUxICswMDAwIEtlbGxlciwgSmFjb2IgRSB3cm90ZToNCj4+Pj4gSmFr
ZSBkbyB5b3Uga25vdyB3aGF0IHRoZSB1c2UgY2FzZXMgZm9yIEludGVsIGFyZT8gQXJlIHRoZXkg
U0ZQLCBNQUMsDQo+Pj4+IG9yIE5DLVNJIHJlbGF0ZWQ/ICANCj4+Pg0KPj4+IEkgd2VudCB0aHJv
dWdoIGFsbCB0aGUgSW50ZWwgZHJpdmVycyB0aGF0IGltcGxlbWVudCB0aGVzZSBvcGVyYXRpb25z
IGFuZA0KPj4+IEkgYmVsaWV2ZSB5b3UgYXJlIHRhbGtpbmcgYWJvdXQgdGhlc2UgY29tbWl0czoN
Cj4+Pg0KPj4+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0
L3RvcnZhbGRzL2xpbnV4LmdpdC9jb21taXQvP2lkPWMzODgwYmQxNTlkNDMxZDA2YjY4N2IwYjVh
YjIyZTI0ZTZlZjAwNzANCj4+PiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lz9pZD1kNWVjOWUyY2U0MWFjMTk4
ZGUyZWUxOGUwZTUyOWI3ZWJiYzY3NDA4DQo+Pj4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0L2NvbW1pdC8/aWQ9YWI0YWI3
M2ZjMWVjNmRlYzU0OGZhMzZjNWUzODNlZjVmYWE3YjRjMQ0KPj4+DQo+Pj4gVGhlcmUgaXNuJ3Qg
dG9vIG11Y2ggaW5mb3JtYXRpb24gYWJvdXQgdGhlIG1vdGl2YXRpb24sIGJ1dCBtYXliZSBpdCBo
YXMNCj4+PiBzb21ldGhpbmcgdG8gZG8gd2l0aCBtdWx0aS1ob3N0IGNvbnRyb2xsZXJzIHdoZXJl
IHlvdSB3YW50IHRvIHByZXZlbnQNCj4+PiBvbmUgaG9zdCBmcm9tIHRha2luZyB0aGUgcGh5c2lj
YWwgbGluayBkb3duIGZvciBhbGwgdGhlIG90aGVyIGhvc3RzDQo+Pj4gc2hhcmluZyBpdD8gSSBy
ZW1lbWJlciBzdWNoIGlzc3VlcyB3aXRoIG1seDUuDQo+Pj4gICANCj4+DQo+PiBPaywgSSBmb3Vu
ZCBzb21lIG1vcmUgaW5mb3JtYXRpb24gaGVyZS4gVGhlIHByaW1hcnkgbW90aXZhdGlvbiBvZiB0
aGUNCj4+IGNoYW5nZXMgaW4gdGhlIGk0MGUgYW5kIGljZSBkcml2ZXJzIGlzIGZyb20gY3VzdG9t
ZXIgcmVxdWVzdHMgYXNraW5nIHRvDQo+PiBoYXZlIHRoZSBsaW5rIGdvIGRvd24gd2hlbiB0aGUg
cG9ydCBpcyBhZG1pbmlzdHJhdGl2ZWx5IGRpc2FibGVkLiBUaGlzDQo+PiBpcyBiZWNhdXNlIGlm
IHRoZSBsaW5rIGlzIGRvd24gdGhlbiB0aGUgc3dpdGNoIG9uIHRoZSBvdGhlciBzaWRlIHdpbGwN
Cj4+IHNlZSB0aGUgcG9ydCBub3QgaGF2aW5nIGxpbmsgYW5kIHdpbGwgc3RvcCB0cnlpbmcgdG8g
c2VuZCB0cmFmZmljIHRvIGl0Lg0KPj4NCj4+IEFzIGZhciBhcyBJIGNhbiB0ZWxsLCB0aGUgcmVh
c29uIGl0cyBhIGZsYWcgaXMgYmVjYXVzZSBzb21lIHVzZXJzIHdhbnRlZA0KPj4gdGhlIGJlaGF2
aW9yIHRoZSBvdGhlciB3YXkuDQo+Pg0KPj4gSSdtIG5vdCBzdXJlIGl0J3MgcmVhbGx5IHJlbGF0
ZWQgdG8gdGhlIGJlaGF2aW9yIGhlcmUuDQo+Pg0KPj4gRm9yIHdoYXQgaXQncyB3b3J0aCwgSSdt
IGluIGZhdm9yIG9mIGNvbnRhaW5pbmcgdGhpbmdzIGxpa2UgdGhpcyBpbnRvDQo+PiBldGh0b29s
IGFzIHdlbGwuDQo+IA0KPiBJIHRoaW5rIHRoZSBxdWVzdGlvbiB3YXMgdGhlIGludmVyc2UgLSB3
aHkgbm90IGFsd2F5cyBzaHV0IGRvd24gdGhlDQo+IHBvcnQgaWYgdGhlIGludGVyZmFjZSBpcyBi
cm91Z2h0IGRvd24/DQo+IA0KDQpTbyBmYXIgdGhlIGJlc3QgSSd2ZSBmb3VuZCBhZnRlciBkaWdn
aW5nIGlzIHRoYXQgZm9yY2luZyB0b3RhbCBzaHV0ZG93bg0KY2F1c2VzIG1hbmFnZWFiaWxpdHkg
YW5kIFZGIHRyYWZmaWMgdG8gc3RvcC4gT3RoZXIgY3VzdG9tZXJzIHdhbnQgdGhpcw0KdHJhZmZp
YyB0byBjb250aW51ZSBldmVuIHdoZW4gdGhlIFBGIHBvcnQgaXMgYnJvdWdodCBkb3duLg0KDQpU
aGFua3MsDQpKYWtlDQo=
