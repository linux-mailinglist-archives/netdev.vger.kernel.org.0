Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF3E3E85D5
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 00:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbhHJWBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 18:01:20 -0400
Received: from mga04.intel.com ([192.55.52.120]:21999 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231372AbhHJWBS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 18:01:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="213148798"
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="213148798"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 15:00:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="672133674"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 10 Aug 2021 15:00:55 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 10 Aug 2021 15:00:53 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 10 Aug 2021 15:00:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 10 Aug 2021 15:00:52 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 10 Aug 2021 15:00:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=csOhrOoEwdSjGlaEZTydNp+X3eOC+uRLZAtlaq+Czk9UCwh+pQ8bCSV44jO3PptAZQdQDzZTNmNraRIirfNlc/FZlev4lH2uOPpHxAodC2EmS3Sln3nq25knrrCS862FPPiNl8aE3lKgX7cQmuCzvCMG6qyqqj6xDPjU/BcNnvb3FVNbHU0sm8kIjeL0DD67U1bcAD8R8W6lUSd9/6Yn762C5Wdhd2WBWkopbzykeN7FRvsMC1eG/8uAWI1yklSopRLAH0z1d7tViQDTEvgdxi6jbvqgJxzt53ulKgiFMaj3Hv534rIqsq3lDq8/jAPLr7iiP4zun2zfFgduLU4wwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9b7qNbdu7dB2uuQu0ST1yF0pd7MWVqOg7ud9OSk7G4=;
 b=jU47vlGLvX2AhbLTR5Y3Ncm3/sWcjro1MWhLglWHLLpQO1bgAZEW4mRRr8Z06pG1ef34Q9sff0xrMOxj6M+H76EpCNtXui9MxjSghXQ20VF6TERkgMz4fx7bjFftIlqyZC4mQYwsKNQNXbSNTibjhfj5kLaO4fRHI8Zfp2aoFnS70HJNDw/Jfy0UM7yPg/aURmkvA02vCYjWefGdMQQ22BHVInNaPZoUGES3bg5FmubbftwH5uYFhKmDqwFW5v75ilSJRBwZrNC4bXZzzZzA6ZzM+BMl5FwHdULVGKnEscmC89vbE0jiD67If+cRF/PykAahA+ywjBlVk+Y/it2bVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9b7qNbdu7dB2uuQu0ST1yF0pd7MWVqOg7ud9OSk7G4=;
 b=MBynWZu2EPlf6qohqlBb5xombAuMVh9cZODsCeJxGW6Ctrjz9iQthF+afzhED+g3zNT2pzoml+2AtRm2c8rfgUcSL9DGnhLy89WRuqQID/n55wDFHCRxH6WIwhHjHx/nY844UhEa40zjtl7oA16Au2Pob4EKwE/aHKqvujULXkw=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB4833.namprd11.prod.outlook.com (2603:10b6:303:99::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 22:00:52 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960%3]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 22:00:52 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Ido Schimmel <idosch@idosch.org>, Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
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
Thread-Index: AQHXjQh2iw3UgViIbkGUQrHAheSIDKtrO5cAgAEcgYCAAGu3AIAAAh0AgABxmACAABTCAA==
Date:   Tue, 10 Aug 2021 22:00:51 +0000
Message-ID: <71a5bd72-2154-a796-37b7-f39afdf2e34d@intel.com>
References: <20210809102152.719961-1-idosch@idosch.org>
 <20210809102152.719961-2-idosch@idosch.org> <YRE7kNndxlGQr+Hw@lunn.ch>
 <YRIqOZrrjS0HOppg@shredder> <YRKElHYChti9EeHo@lunn.ch>
 <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRLlpCutXmthqtOg@shredder>
In-Reply-To: <YRLlpCutXmthqtOg@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e72955e2-0695-4611-076f-08d95c4a51ed
x-ms-traffictypediagnostic: CO1PR11MB4833:
x-microsoft-antispam-prvs: <CO1PR11MB483385A880DDDAB4B730DCECD6F79@CO1PR11MB4833.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 48I4gM2cRhCaHc5uxdRCrZrY2DcyjGgQ/rfWC9UmZmag3BxMO6bQNAO/nD10f5Z9Ru4KYNuNbX3r1kueC75SNpRPAHaL0gPXbOkV4CrIX/NthsDhkm5S/zIXNdAA0/eRZy3jQWMH0fGLDtXC87/k97l0PZk62fLyK5VMtQMucIiRMr3hQ1wg+TAcvIKJEE5ejzC/W+BgYc5BXWOohdi+BuzSwm81I8blycsgfkghdAT7P7L/lr9NrcpBE5BCuxAOEZ5ulVKtYRJuL5RUd8QAr02HShbn9zV2dwpme2UkIP5Qt6R3wGmd+hmgzSWZoXePPA1INj7Pqapd8SiVORs4QxH/E1lNHmfu/FnNFHmOEUIqWbH66Y2o3Ppk9UExQdBUpRBSJo/3utenlK+aek3Ef+11eZ56XBWjUIWcicZocWaYCQ7VIOtuVZS/2WoKeprzH7AmnF4rzEib8E1MMnLpUoZIAz2WI+Tj8jUzQSptxZ84QWyE6irefy+i5qdezVFy+FiFkw6n/yYTl2otAlxKXipOkxFqZjLIKRhOG3SeqLo5yN7bt1O8g0cBy4Sa2oBZY+KPS7X4MEbY5A0o1KZ6iAS1Q+MmvUKiTEKDiINHGGilLJQcqgSsOP93xCXs6HXrg9wm1quShGM/27jgP8W1WWN3joNQF6AOH3ooWMrmvUivsQi0DZQDotiaT5NGZl4eO9gpSmrJfd+OPjt6RuCnHb7HKh5bFQKUPuLN/0jAkXQstphkG7x3/alBFViaf38ynPvWMDuKHgOsAexckqfIgPIlVxEcnI9aq/au/mFcZwD/B2vxJF77hoSpp6omP4uh+Y/QedsArB0fkrsREHGSnltSrpodwnNqngmZ2bHNdrPS1ar9JY2g0VwihM/4dfZh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(38100700002)(83380400001)(316002)(8936002)(8676002)(122000001)(54906003)(110136005)(6486002)(66556008)(91956017)(66476007)(64756008)(66446008)(38070700005)(6512007)(66946007)(76116006)(2616005)(186003)(36756003)(86362001)(31696002)(966005)(2906002)(478600001)(71200400001)(31686004)(7416002)(53546011)(4326008)(6506007)(5660300002)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1ZyYnZkeHNhOTJmOWVQTTRkS2xrS0lHTXc0SU5yaW5OdGZWVk43UVllUndE?=
 =?utf-8?B?UXB5TWpGNTY1MWxyZXUyaVQ0cGh0TGM4cStTbUpLeGRjd2dJNWl6NHlRU2d6?=
 =?utf-8?B?Q3lmS3hQL08yU09IeDlyalJmb2FYSFlDc3BEL0diM1pScmN1TlVGczJDd1Fh?=
 =?utf-8?B?NWQ4c2xQblBtd213eENBdURYRW90MHNWRE9EWE1ja0IzNThTQ1E2RjF6MElw?=
 =?utf-8?B?S3d6eDI1TDJ4bkZYdGNwbjJJVmMyVi9CSGJVOFliTm1YZDJkUkVha0huTTZ5?=
 =?utf-8?B?Y2dmVWNjd2pGM0hZVVVGVjZQYVRGNHdQbElId2xYOFpXV3pLZlFNbDRqRmpj?=
 =?utf-8?B?RGUxRDB0TjZIZWUxeHg3RzhZTU95R2xwOTJFbWE2MmJnNTFFV3BMTEg2bFo1?=
 =?utf-8?B?Qk16WmxPcmVnVHJ4S3BRcFRQRkxRQ1haYk4rK0gvV1ZIMGhveWVwdVZhQ08x?=
 =?utf-8?B?Y3JqNThTRTZ1ZmxybGxVUXd2TERPT3dHZG9EaFNMcDJ0b2ZRUTNCM3g3a0Fy?=
 =?utf-8?B?NmwxSzI1dGhqb2dmeTVwdlJFQVEwRUpkaXBrOXFGbnkyNFZZMkZzNC8valA0?=
 =?utf-8?B?Ty9Hb3Y2b256WS95OXJHZ1dTVUEzM1g4ZkE3N3ZGTW5teGpudVM5QVdXUVFt?=
 =?utf-8?B?SGh2cFc0V1lWZmgvb05CcnB1b3MySnFZc05zODJFZXdDREx4SEhQMlNLTDl5?=
 =?utf-8?B?MVNEVnZVeUJSTStyVXRQNlp6RFZKZnUzT0dPaS8va2xtemsxTCtUcEdJc043?=
 =?utf-8?B?U09SM2JxV0QvRktvdytuT2ZuQkgxZzgwa2xNV3lRM3lPQVRkWmt2YUEzMEtx?=
 =?utf-8?B?SE9ZeVYyYldaZW9QSTIyVVRRdGN4SU51TThKVFpOZXYrVk5ySDFnRHlwdTRh?=
 =?utf-8?B?RzBPejVlemwvcjlXT0pod09xWWF2a09HZlliQ0xLT21RY2xSY1Q4VkVMY1g0?=
 =?utf-8?B?bXVXcTEyb016aTVSenhZY3k5ZjRSTjZWQm1zK2haOHU2UlduV2hUQjUydGpx?=
 =?utf-8?B?Z3dkNTdrcjRGSmVaeVlHSFczOHZkVlRGOFQxTWw5MEFaMjVUNThCZ091eWJJ?=
 =?utf-8?B?TUVvUXlaczVXeGxNNGF4NjlEZzVHZmgvZzBPYnZXSEgwbk5DaWw5dWE4L3U5?=
 =?utf-8?B?dXhIeEwrTDdOa2Z3N3dRblNVbmhpU28xcjkxR3JPcWMrYitSa1VaQzNST1pV?=
 =?utf-8?B?aWpUblFQWDQva1kvZUxWZ296MXZpSk1kUDVqS3VkczZHVE5WdHJBcEZiWnlQ?=
 =?utf-8?B?aXVodlZ3VHBpT1hPTDRFbWljbVpDU283T3c5N1BURmNLaTZpZjlWYWV2OGwv?=
 =?utf-8?B?YU40OStHQ3l2MHV2NHdZOEZpOW5qRXRpQmtPazQ1Vlh0NnlTTzFGOC9GTHh6?=
 =?utf-8?B?Q0QwOVNIeVh6aS9Jc3BPRlBGMjZkd25POGVPVk1HZW0xdFpwdzI2d2ovN3Bl?=
 =?utf-8?B?ejNLSXZPa3l5NEFTM1BxaWR0MnV3UFBiOVNaVkVhT0NuY1hWcjlySk5ScnNE?=
 =?utf-8?B?R0lyK0VNS3ErRXFCK1dFVlZGU1pqVGxyTDlXUDBwaXlBZmVkMWM3L2U1UUpk?=
 =?utf-8?B?ZFZxYUwza3FJcGpFdUZSY2RVcHhKR0ZhcEdnajl6a21NdUhZcWdzdzhqYXJ0?=
 =?utf-8?B?QlpZTXdiYndkT2pMbUYyK2hjQ2k4SDh1WjF6bmVSODZQUVB0MkJ3UUprVWJp?=
 =?utf-8?B?eHVHaFlMNzBuQ3pPdnNIS3ZBdjhGb1RWamxpSkozTElxZWRRUXg2RnR4Um4y?=
 =?utf-8?Q?1C5FPlCJw+m3kJAXn8=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB6D0CBA54DDC64EADCE8B130127DACD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e72955e2-0695-4611-076f-08d95c4a51ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 22:00:51.9458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 68jsx7qi2WvaIY0/p0chLX3n8R6E6slBdwRQkGjipJvk42vH9IRT6Thrf5/eEBwfuMIw6c5ZDM3NpO7XJV8aq52SDhqk5glNjjdiA+Z6SYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4833
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8xMC8yMDIxIDE6NDYgUE0sIElkbyBTY2hpbW1lbCB3cm90ZToNCj4gT24gVHVlLCBBdWcg
MTAsIDIwMjEgYXQgMDY6NTk6NTRBTSAtMDcwMCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+PiBP
biBUdWUsIDEwIEF1ZyAyMDIxIDE1OjUyOjIwICswMjAwIEFuZHJldyBMdW5uIHdyb3RlOg0KPj4+
PiBUaGUgdHJhbnNpdGlvbiBmcm9tIGxvdyBwb3dlciB0byBoaWdoIHBvd2VyIGNhbiB0YWtlIGEg
ZmV3IHNlY29uZHMgd2l0aA0KPj4+PiBRU0ZQL1FTRlAtREQgYW5kIGl0J3MgbGlrZWx5IHRvIG9u
bHkgZ2V0IGxvbmdlciB3aXRoIGZ1dHVyZSAvIG1vcmUNCj4+Pj4gY29tcGxleCBtb2R1bGVzLiBU
aGVyZWZvcmUsIHRvIHJlZHVjZSBsaW5rLXVwIHRpbWUsIHRoZSBmaXJtd2FyZQ0KPj4+PiBhdXRv
bWF0aWNhbGx5IHRyYW5zaXRpb25zIG1vZHVsZXMgdG8gaGlnaCBwb3dlciBtb2RlLg0KPj4+Pg0K
Pj4+PiBUaGVyZSBpcyBvYnZpb3VzbHkgYSB0cmFkZS1vZmYgaGVyZSBiZXR3ZWVuIHBvd2VyIGNv
bnN1bXB0aW9uIGFuZA0KPj4+PiBsaW5rLXVwIHRpbWUuIE15IHVuZGVyc3RhbmRpbmcgaXMgdGhh
dCBNZWxsYW5veCBpcyBub3QgdGhlIG9ubHkgdmVuZG9yDQo+Pj4+IGZhdm9yaW5nIHNob3J0ZXIg
bGluay11cCB0aW1lcyBhcyB1c2VycyBoYXZlIHRoZSBhYmlsaXR5IHRvIGNvbnRyb2wgdGhlDQo+
Pj4+IGxvdyBwb3dlciBtb2RlIG9mIHRoZSBtb2R1bGVzIGluIG90aGVyIGltcGxlbWVudGF0aW9u
cy4NCj4+Pj4NCj4+Pj4gUmVnYXJkaW5nICJ3aHkgZG8gd2UgbmVlZCB1c2VyIHNwYWNlIGludm9s
dmVkPyIsIGJ5IGRlZmF1bHQsIGl0IGRvZXMgbm90DQo+Pj4+IG5lZWQgdG8gYmUgaW52b2x2ZWQg
KHRoZSBzeXN0ZW0gd29ya3Mgd2l0aG91dCB0aGlzIEFQSSksIGJ1dCBpZiBpdCB3YW50cw0KPj4+
PiB0byByZWR1Y2UgdGhlIHBvd2VyIGNvbnN1bXB0aW9uIGJ5IHNldHRpbmcgdW51c2VkIG1vZHVs
ZXMgdG8gbG93IHBvd2VyDQo+Pj4+IG1vZGUsIHRoZW4gaXQgd2lsbCBuZWVkIHRvIHVzZSB0aGlz
IEFQSS4gIA0KPj4+DQo+Pj4gTy5LLiBUaGFua3MgZm9yIHRoZSBiZXR0ZXIgZXhwbGFuYXRpb24u
IFNvbWUgb2YgdGhpcyBzaG91bGQgZ28gaW50bw0KPj4+IHRoZSBjb21taXQgbWVzc2FnZS4NCj4+
Pg0KPj4+IEkgc3VnZ2VzdCBpdCBnZXRzIGEgZGlmZmVyZW50IG5hbWUgYW5kIHNlbWFudGljcywg
dG8gYXZvaWQNCj4+PiBjb25mdXNpb24uIEkgdGhpbmsgd2Ugc2hvdWxkIGNvbnNpZGVyIHRoaXMg
dGhlIGRlZmF1bHQgcG93ZXIgbW9kZSBmb3INCj4+PiB3aGVuIHRoZSBsaW5rIGlzIGFkbWluaXN0
cmF0aXZlbHkgZG93biwgcmF0aGVyIHRoYW4gZGlyZWN0IGNvbnRyb2wNCj4+PiBvdmVyIHRoZSBt
b2R1bGVzIHBvd2VyIG1vZGUuIFRoZSBkcml2ZXIgc2hvdWxkIHRyYW5zaXRpb24gdGhlIG1vZHVs
ZQ0KPj4+IHRvIHRoaXMgc2V0dGluZyBvbiBsaW5rIGRvd24sIGJlIGl0IGhpZ2ggcG93ZXIgb3Ig
bG93IHBvd2VyLiBUaGF0DQo+Pj4gc2F2ZXMgYSBsb3Qgb2YgY29tcGxleGl0eSwgc2luY2UgaSBh
c3N1bWUgeW91IGN1cnJlbnRseSBuZWVkIGEgdWRldg0KPj4+IHNjcmlwdCBvciBzb21ldGhpbmcg
d2hpY2ggc2V0cyBpdCB0byBsb3cgcG93ZXIgbW9kZSBvbiBsaW5rIGRvd24sDQo+Pj4gd2hlcmUg
YXMgeW91IGNhbiBhdm9pZCB0aGlzIGJlIGNvbmZpZ3VyaW5nIHRoZSBkZWZhdWx0IGFuZCBsZXQg
dGhlDQo+Pj4gZHJpdmVyIGRvIGl0Lg0KPj4NCj4+IEdvb2QgcG9pbnQuIEFuZCBhY3R1YWxseSBO
SUNzIGhhdmUgc2ltaWxhciBrbm9icywgZXhwb3NlZCB2aWEgZXRodG9vbA0KPj4gcHJpdiBmbGFn
cyB0b2RheS4gSW50ZWwgTklDcyBmb3IgZXhhbXBsZS4gTWF5YmUgd2Ugc2hvdWxkIGNyZWF0ZSBh
DQo+PiAicmVhbGx5IHBvd2VyIHRoZSBwb3J0IGRvd24gcG9saWN5IiBBUEk/DQo+IA0KPiBTZWUg
YmVsb3cgYWJvdXQgSW50ZWwuIEknbSBub3Qgc3VyZSBpdCdzIHRoZSBzYW1lIHRoaW5nLi4uDQo+
IA0KPiBJJ20gYWdhaW5zdCBhZGRpbmcgYSB2YWd1ZSAicmVhbGx5IHBvd2VyIHRoZSBwb3J0IGRv
d24gcG9saWN5IiBBUEkuIFRoZQ0KPiBBUEkgcHJvcG9zZWQgaW4gdGhlIHBhdGNoIGlzIHdlbGwt
ZGVmaW5lZCwgaXRzIGltcGxlbWVudGF0aW9uIGlzDQo+IGRvY3VtZW50ZWQgaW4gc3RhbmRhcmRz
LCBpdHMgaW1wbGljYXRpb25zIGFyZSBjbGVhciBhbmQgd2Ugb2ZmZXIgQVBJcw0KPiB0aGF0IGdp
dmUgdXNlciBzcGFjZSBmdWxsIG9ic2VydmFiaWxpdHkgaW50byBpdHMgb3BlcmF0aW9uLg0KPiAN
Cj4gQSB2YWd1ZSBBUEkgbWVhbnMgdGhhdCBpdCBpcyBnb2luZyB0byBiZSBhYnVzZWQgYW5kIHVz
ZXIgc3BhY2Ugd2lsbCBnZXQNCj4gZGlmZmVyZW50IHJlc3VsdHMgb3ZlciBkaWZmZXJlbnQgaW1w
bGVtZW50YXRpb25zLiBBZnRlciByZWFkaW5nIHRoZQ0KPiAqY29tbWl0IG1lc3NhZ2VzKiBhYm91
dCB0aGUgcHJpdmF0ZSBmbGFncywgSSdtIG5vdCBzdXJlIHdoYXQgdGhlIGZsYWdzDQo+IHJlYWxs
eSBkbywgd2hhdCBpcyB0aGVpciB0cnVlIG1vdGl2YXRpb24sIGltcGxpY2F0aW9ucyBvciBob3cg
ZG8gSSBnZXQNCj4gb2JzZXJ2YWJpbGl0eSBpbnRvIHRoZWlyIG9wZXJhdGlvbi4gSSdtIG5vdCB0
b28gaG9wZWZ1bCBhYm91dCB0aGUgdXNlcg0KPiBkb2N1bWVudGF0aW9uLg0KPiANCj4gQWxzbywg
bGlrZSBJIG1lbnRpb25lZCBpbiB0aGUgY292ZXIgbGV0dGVyLCBnaXZlbiB0aGUgY29tcGxleGl0
eSBvZg0KPiB0aGVzZSBtb2R1bGVzIGFuZCBhcyB0aGV5IGJlY29tZSBtb3JlIGNvbW1vbiwgaXQg
aXMgbGlrZWx5IHRoYXQgd2Ugd2lsbA0KPiBuZWVkIHRvIGV4dGVuZCB0aGUgQVBJIHRvIGNvbnRy
b2wgbW9yZSBwYXJhbWV0ZXJzIGFuZCBleHBvc2UgbW9yZQ0KPiBkaWFnbm9zdGljIGluZm9ybWF0
aW9uLiBJIHdvdWxkIHJlYWxseSBsaWtlIHRvIGtlZXAgaXQgY2xlYW4gYW5kDQo+IGNvbnRhaW5l
ZCBpbiAnRVRIVE9PTF9NU0dfTU9EVUxFXyonIG1lc3NhZ2VzIGFuZCBub3Qgc3ByZWFkIGl0IG92
ZXINCj4gZGlmZmVyZW50IEFQSXMuDQo+IA0KPj4NCj4+IEpha2UgZG8geW91IGtub3cgd2hhdCB0
aGUgdXNlIGNhc2VzIGZvciBJbnRlbCBhcmU/IEFyZSB0aGV5IFNGUCwgTUFDLA0KPj4gb3IgTkMt
U0kgcmVsYXRlZD8NCj4gDQo+IEkgd2VudCB0aHJvdWdoIGFsbCB0aGUgSW50ZWwgZHJpdmVycyB0
aGF0IGltcGxlbWVudCB0aGVzZSBvcGVyYXRpb25zIGFuZA0KPiBJIGJlbGlldmUgeW91IGFyZSB0
YWxraW5nIGFib3V0IHRoZXNlIGNvbW1pdHM6DQo+IA0KPiBodHRwczovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lz9pZD1j
Mzg4MGJkMTU5ZDQzMWQwNmI2ODdiMGI1YWIyMmUyNGU2ZWYwMDcwDQo+IGh0dHBzOi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC9jb21t
aXQvP2lkPWQ1ZWM5ZTJjZTQxYWMxOThkZTJlZTE4ZTBlNTI5YjdlYmJjNjc0MDgNCj4gaHR0cHM6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXgu
Z2l0L2NvbW1pdC8/aWQ9YWI0YWI3M2ZjMWVjNmRlYzU0OGZhMzZjNWUzODNlZjVmYWE3YjRjMQ0K
PiANCj4gVGhlcmUgaXNuJ3QgdG9vIG11Y2ggaW5mb3JtYXRpb24gYWJvdXQgdGhlIG1vdGl2YXRp
b24sIGJ1dCBtYXliZSBpdCBoYXMNCj4gc29tZXRoaW5nIHRvIGRvIHdpdGggbXVsdGktaG9zdCBj
b250cm9sbGVycyB3aGVyZSB5b3Ugd2FudCB0byBwcmV2ZW50DQo+IG9uZSBob3N0IGZyb20gdGFr
aW5nIHRoZSBwaHlzaWNhbCBsaW5rIGRvd24gZm9yIGFsbCB0aGUgb3RoZXIgaG9zdHMNCj4gc2hh
cmluZyBpdD8gSSByZW1lbWJlciBzdWNoIGlzc3VlcyB3aXRoIG1seDUuDQo+IA0KDQpPaywgSSBm
b3VuZCBzb21lIG1vcmUgaW5mb3JtYXRpb24gaGVyZS4gVGhlIHByaW1hcnkgbW90aXZhdGlvbiBv
ZiB0aGUNCmNoYW5nZXMgaW4gdGhlIGk0MGUgYW5kIGljZSBkcml2ZXJzIGlzIGZyb20gY3VzdG9t
ZXIgcmVxdWVzdHMgYXNraW5nIHRvDQpoYXZlIHRoZSBsaW5rIGdvIGRvd24gd2hlbiB0aGUgcG9y
dCBpcyBhZG1pbmlzdHJhdGl2ZWx5IGRpc2FibGVkLiBUaGlzDQppcyBiZWNhdXNlIGlmIHRoZSBs
aW5rIGlzIGRvd24gdGhlbiB0aGUgc3dpdGNoIG9uIHRoZSBvdGhlciBzaWRlIHdpbGwNCnNlZSB0
aGUgcG9ydCBub3QgaGF2aW5nIGxpbmsgYW5kIHdpbGwgc3RvcCB0cnlpbmcgdG8gc2VuZCB0cmFm
ZmljIHRvIGl0Lg0KDQpBcyBmYXIgYXMgSSBjYW4gdGVsbCwgdGhlIHJlYXNvbiBpdHMgYSBmbGFn
IGlzIGJlY2F1c2Ugc29tZSB1c2VycyB3YW50ZWQNCnRoZSBiZWhhdmlvciB0aGUgb3RoZXIgd2F5
Lg0KDQpJJ20gbm90IHN1cmUgaXQncyByZWFsbHkgcmVsYXRlZCB0byB0aGUgYmVoYXZpb3IgaGVy
ZS4NCg0KRm9yIHdoYXQgaXQncyB3b3J0aCwgSSdtIGluIGZhdm9yIG9mIGNvbnRhaW5pbmcgdGhp
bmdzIGxpa2UgdGhpcyBpbnRvDQpldGh0b29sIGFzIHdlbGwuDQoNClRoYW5rcywNCkpha2UNCg==
