Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3193331FE8C
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 19:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhBSSIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 13:08:15 -0500
Received: from mga12.intel.com ([192.55.52.136]:46914 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229862AbhBSSIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 13:08:01 -0500
IronPort-SDR: +4eclHd4OeMCbk4I4vU2yt/aHGXSGCFZvjtxXCu6aMllf+7RbMCIpfHlJfp48MPOWZZVTuJcdF
 /1adO1DozkHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9900"; a="163069858"
X-IronPort-AV: E=Sophos;i="5.81,189,1610438400"; 
   d="scan'208";a="163069858"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2021 10:07:19 -0800
IronPort-SDR: qpHuLT2F8GZACTy4ITn2ARvEPu5zenXSVPuYQHMtkMPHJyWQfGe7AKipET9WP9aWWBzosJ8dM4
 mAZgkUgBWI2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,189,1610438400"; 
   d="scan'208";a="363038216"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 19 Feb 2021 10:07:18 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 19 Feb 2021 10:07:18 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 19 Feb 2021 10:07:17 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 19 Feb 2021 10:07:17 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 19 Feb 2021 10:06:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W25p/6fZlQqOX/hsdQN8Yx+2mxmPzwPKcWiiNGPD0ogp5XN27Bk6mDQ7Yqa4LNK1YDpKBlgZ13CwgxBGr4ndr37EU5+/jGPVPHb8wHhOgX8t3hkQ3zs9tMmFK5UKcNaoqjSbpeUj7l1kIm/gnIca/n6fcb6ciJXMYFGAAmhBeqIXatjOXrPHwqELA3w3dvQBR2q4nX1RnS2pd5wgqZmlWdtWOSVdPjR33cIpYkdH/OzEWZ/y3Xi6UpxBU88lFP6mDdQX81PVVMfR2PsFfn4a4rwe4W3rdo61PaK6NWk5k2yiJ4IneyWQt0UjNSGqKoj6dNr4JU2zUC+PH60e6bW5yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LlWQjR2Gs3M8egEqNXSRwbHpb0pMRQq8+jkXAWMp3dQ=;
 b=B4Iot+feiE4TuoWAO49nZveIcFC7Fzxt8xLlU7K5dedd/apdDJwyhgXf/SIrHoJqUc8nyjcr4FsT9Yc7HrC4ViOk+UT3T01saOWfDgbn5lPjvNXtYdUeTeOEXNRUzH5Djnd91IyHIuWZb/54BGTR+5yReNIKPVhFnmNt+FOJnmaHplZf5PtyJI9ZTKuLNeUAvVUC6XsvGvMGpegHyfK1+bcT7DuzsJqwFy8x1AgE6nWhm8YVgT8ldsoFEnxnjhqCRE+FC6S4S8GgUIHVVNOHYYptF2wa2LwMhCQJ1GRQ4xWyfZ5Q4p6sFH3YWu80uAv/qUwDPUhv7JckVrpC09iOsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LlWQjR2Gs3M8egEqNXSRwbHpb0pMRQq8+jkXAWMp3dQ=;
 b=Sof5rLSoHmtvcsqDTXMwvAkWaebC7tWpZNmUVyGdzDTP3T0ZAAKic2OIwzrLOCEAPzpzQbBcOiEIH3HEmfKD7/M7aVcPS1aDfgGqY2jRD7ooPBoL0TNgvt5Ans6CqDDCmovC0itsMk99z1xbjI14yOodqOotS5QMgOKfqluk4jo=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3326.namprd11.prod.outlook.com (2603:10b6:805:bc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Fri, 19 Feb
 2021 18:06:46 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::85b7:921c:ff53:696e]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::85b7:921c:ff53:696e%6]) with mapi id 15.20.3846.042; Fri, 19 Feb 2021
 18:06:46 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Szczurek, GrzegorzX" <grzegorzx.szczurek@intel.com>,
        "Palczewski, Mateusz" <mateusz.palczewski@intel.com>,
        "Gawin, JaroslawX" <jaroslawx.gawin@intel.com>
Subject: Re: [PATCH net 7/8] i40e: Fix add TC filter for IPv6
Thread-Topic: [PATCH net 7/8] i40e: Fix add TC filter for IPv6
Thread-Index: AQHXBk0sSQ+zEIMkY0yr9GTf6wiFGKpfvaaAgAAJtoA=
Date:   Fri, 19 Feb 2021 18:06:46 +0000
Message-ID: <9448db9b72130c0f7c6645d17160e53b3e5d9685.camel@intel.com>
References: <20210218232504.2422834-1-anthony.l.nguyen@intel.com>
         <20210218232504.2422834-8-anthony.l.nguyen@intel.com>
         <20210219093159.4a6fc853@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210219093159.4a6fc853@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7cdc1fc-e21a-4819-0685-08d8d5011f0e
x-ms-traffictypediagnostic: SN6PR11MB3326:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3326D2EA45BE8E52951C7224C6849@SN6PR11MB3326.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qYpWeUpSaHvPt/1+XBWjR1sLHxnxjheu5++OZ5k06TdGDOUilLrutIb0Ag0D5fKrvsjNA/zNX1eS9Awt3HQVIEN3WhkXlGhnMmAE97aFKBfhDm5OsuiIq+Ba7lVh/Ei//n3Xm0kGOlRAQQTHUMYZaCn5rl+DPQRwIJsdAIY85QuXLS9/bq5r0Sm9hPV3RT6q7xEz/ghbKhi+/7ASpVE4+FQ0F8WArT8utAS6PRpIIp8zWeWNEto34/MHbw0AknHbw91oQATx1J6hENjbBD0szCUJVuItx0Eo044liPSUukh+Na8juwIDptKpnHkdbb0C15K3JbdcP2G6RQCCUrNIKkF7f/u0JPgsF3F4UdC4IJrno5Zpm/GZmDoExopFv0+KQZyFE/J+tIlVZxngRO/+vRzQ4rHCVLpZfXjTgXwHWbzrM+zghagtVZfx5vxov2PzcGxv3ZyvBZpP/R0Y9aMKzi/u7HSU3F+BR+thyz4eU5lxjDClHstKANf3IgrwEGs0Us4UVCaH4gHW54ijVTTU/wWQVKysPrUupX5FpfrkLnq2QiXPQEEa1AZs+VXyscai
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(39860400002)(136003)(186003)(66446008)(8676002)(4744005)(5660300002)(36756003)(66946007)(2906002)(316002)(91956017)(71200400001)(76116006)(66556008)(107886003)(86362001)(6916009)(8936002)(6506007)(66476007)(6486002)(64756008)(478600001)(2616005)(4326008)(26005)(54906003)(6512007)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?OTVGY1lTUmJOSnM1cGoxQXFubU5jUHVlOFFLeWNCdkhMK2R5TE9zRzB4dW5X?=
 =?utf-8?B?bFEzaDdIYk04QXRDL3BpSzE2NEd2b1crUytyNVV1aUFBaEU4OGVUZ2RlN05h?=
 =?utf-8?B?NzBlSE52TGtRZ081MWNQOG1RbnZCNzlIbXFTLzVmQisrNmQ1a1hUa1dGeHNZ?=
 =?utf-8?B?VWpFbFo0eDJxclIyN2N4T0lBeHF6R0VGdGJvSk9HWGNaKzcwZkxSUHBTQXEx?=
 =?utf-8?B?cUV0TXdJU2MvUHhnWkkzWU5OTzhtM3hTc0pJa3FjNEFFdkdleFZKU3g2clVo?=
 =?utf-8?B?NVUyRG96aTVpSHRNWElEWlhkemplMk9sd2lEaEZpUDVTZkwxUHBRMmVUbCtj?=
 =?utf-8?B?T2VJdXRiVGxDaktSTm1FZ1ZHOEJVMGxtUUNEcE42aFphZVQ0bGZ1WXpJbFJ3?=
 =?utf-8?B?aUxsOGlqd1RnQlFVOHVpWnY0aGZJcUxwZnVUUWVoeExnMjRWQVZCV1ppUzJN?=
 =?utf-8?B?WTJtcDVTZmp6MDJ0UTNDaFpoTDRGRWxGd3h6RzR3R2YwdEFlN2NYYjBCUEFH?=
 =?utf-8?B?enRZZ00wYVhxbmdTNXZPU01LYUU3TVFqd3I3VWpRTy9adU11VTU4WGVoVXlD?=
 =?utf-8?B?Y2ZHTGNxRTBwUnQ1eTJJSU1abnlPVVBPTG9mSjJVM0I2dVF6K2pQd3lyU0Fu?=
 =?utf-8?B?ZDl6cmcxV1ZkTFQxUGJPazZXNmw4SEdMYVg3YTBHYVVvc3gvaFVBRklzU0Ew?=
 =?utf-8?B?VlRDWlNiRldHNEgrMFdNYlJzUkh1N2d1MnRWeHRYRk1ubndOMW83aDBDQUZt?=
 =?utf-8?B?QVZERHVGTWhSR2dPd0IycC9rWmJZMFB2S25NOXJkbzRnLzVpK1luQnhHVWti?=
 =?utf-8?B?MWU4MnkxQWg2amM2VFBFcllkOTVLSVRsZE1xY21ld0RIQ1BXTENvajl3cnRm?=
 =?utf-8?B?S2F0Wi9HdWladnBQa1R4Y04yTmF1Y1AxeWZvdHovUUQxVWsrbXBSbHBzS0xF?=
 =?utf-8?B?OWFlZjhpWjNZcCt1TkRVMmU0clM3Uk4xcjNRbDNTdkUybnBJK1ZqTU1oSkZW?=
 =?utf-8?B?U1QwZDdZRGw2NHhpSXpTbUxJbTlpMklzWVErZklGMlhnZXlmODBWR2J0dlR1?=
 =?utf-8?B?RnprY2wzRjRaWHhPQ2o1TjBPK3V2Q1A0WS90aFU3MGNtTTlVT0JXWW5GNXVW?=
 =?utf-8?B?SDQ3cnY3bE52Z01IS0tmTmNNdmk4VG5ld3ZKdTJsMS92eGYvVERpYnExUWgz?=
 =?utf-8?B?MmZWZEtGczRIVWJQdG95Z0hoaUlYQ1RudE1oaS81aTZlVXBINGkxcmNRVmty?=
 =?utf-8?B?ZlpGdkR2L0c3bUFaUmVweGh0dng4dThmTCtYWjNudnAySVBGMzZxODUwbDI3?=
 =?utf-8?B?VEVmdzRXSFkwVXdKRnFHZ2hHN24xRG10cHdwVzhIQlVsb05JeXhjcGN0SlhY?=
 =?utf-8?B?RllRVjhSeVpPeVBpaU5MTUNSNE1VMnlQK3Z4NWl1aVI0L1Jvc2x1djdYUG5P?=
 =?utf-8?B?bmh5MmJ4c0V3QmtHT2toTXUvL3hYb3p3UzlFN3Mwb2VjMTVwV0V1RUZpNCtN?=
 =?utf-8?B?ZVdFOGFXWG1aeG1kK3lYTmRLb2x0eGJ5QTJXQXBCVk5YamVQN0htem00b1lU?=
 =?utf-8?B?OWhGREZhY0FsRjVlOXUzekxqc0ZMbWN3OWhPNkIrYUV6Zmg5alZiUnJnMmt6?=
 =?utf-8?B?QlpFcWVZSmJDeVVJYXJ5ZUI2WkdDZkFTM203OFBMZlFNSkl1T1ZDcEZQbFV3?=
 =?utf-8?B?ZzQzbCsxNnJoTlV3WlI2Z2NXbGhxYVZ6RDhQRGpaZzZERDhGMkxRQkJDVEhH?=
 =?utf-8?B?d2kvM0pRMnZ5Y1pLc3FpOHl4S2tIVW9ZUVRSa21rM3dvTnVYTWlvbXJUOUNk?=
 =?utf-8?B?eEJ1TmMvVGhYUlgvcVAvQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E026F30A363164BBBC49742F21C7199@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7cdc1fc-e21a-4819-0685-08d8d5011f0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2021 18:06:46.3952
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x7fhOAnvBI6DbUY7j/j6TQIVlrpldrHc2Kn6P0xminxEjpdtnGb8LbP3vz6ItrTgc9eCUwp9IbkAlr5cMnRZz7lKj+DFA6Wtt2To9ty9mQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3326
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTAyLTE5IGF0IDA5OjMxIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAxOCBGZWIgMjAyMSAxNToyNTowMyAtMDgwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiBGcm9tOiBNYXRldXN6IFBhbGN6ZXdza2kgPG1hdGV1c3oucGFsY3pld3NraUBpbnRlbC5j
b20+DQo+ID4gDQo+ID4gRml4IGluc3VmZmljaWVudCBkaXN0aW5jdGlvbiBiZXR3ZWVuIElQdjQg
YW5kIElQdjYgYWRkcmVzc2VzDQo+ID4gd2hlbiBjcmVhdGluZyBhIGZpbHRlci4NCj4gPiBJUHY0
IGFuZCBJUHY2IGFyZSBrZXB0IGluIHRoZSBzYW1lIG1lbW9yeSBhcmVhLiBJZiBJUHY2IGlzIGFk
ZGVkLA0KPiA+IHRoZW4gaXQncyBjYXVnaHQgYnkgSVB2NCBjaGVjaywgd2hpY2ggbGVhZHMgdG8g
ZXJyIC05NS4NCj4gPiANCj4gPiBGaXhlczogMmY0YjQxMWEzZDY3KCJpNDBlOiBFbmFibGUgY2xv
dWQgZmlsdGVycyB2aWEgdGMtZmxvd2VyIikNCj4gDQo+IFNtYWxsIGlzc3VlIHdpdGggdGhlIGZp
eGVzIHRhZyBoZXJlIC0gbWlzc2luZyBzcGFjZSBhZnRlciBoYXNoLg0KPiANCj4gRGF2ZSBzYWlk
IGhlIGNhbid0IHRha2UgYW55IHBhdGNoZXMgdW50aWwgTGludXMgZ2V0cyBwb3dlciBiYWNrIGFu
ZA0KPiBwdWxscyBzbyBzaW5jZSB3ZSdyZSB3YWl0aW5nIHBlcmhhcHMgeW91IGNvdWxkIGZpeCBh
bmQgcmVwb3N0Pw0KPiANCj4gVGhlIHBhdGNoZXMgbG9vayBnb29kIHRvIG1lLg0KDQpUaGFua3Mg
Zm9yIHRoZSByZXZpZXcgSmFrdWIuIFN1cmUsIEknbGwgZml4IGFuZCByZXBvc3QuDQoNCi0gVG9u
eQ0K
