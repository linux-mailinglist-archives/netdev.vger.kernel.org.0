Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21DD4447BEB
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 09:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238056AbhKHIiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 03:38:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:14712 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238047AbhKHIiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 03:38:21 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10161"; a="229649894"
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="229649894"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 00:35:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="451388741"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga006.jf.intel.com with ESMTP; 08 Nov 2021 00:35:22 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 8 Nov 2021 00:35:21 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 8 Nov 2021 00:35:21 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 8 Nov 2021 00:35:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XP85PkSB3IF673fbzTPjrWMA5jrEAaZ3YYLeOYi+OA20/waPgwq8d87fb216OeKJS/G0ymTE8mBejU6VFW5ALB9W+mPVuHh0ztgC2zx+vRxJJ+OQh3s+8ZJAuA72v3lsAPlUHfY6d8+ZcSk+ZcACC9tvxIN5yzl3sBb81bwbCy6H7K7WtnZqQ9nco7MpTOSGvt3nPAwYysCoLKfCyNRMGw/xEMB467JAkLtA0LfWf4LZr3/ws5Kc6mhGYIw4ALK02ngSppS3P8LrbJJ5jyUKg9+SaXF3i8krH1rT7ByWUXjRljYRlYdCMbz2mmtEVyy3A8KWE5fb+hyAPrQY7QtcdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=57P0G9+yjBCYMMhdfHpRpggeucnCKw2tg2tf9AJ54W0=;
 b=leTvFk+MHy18JmOuvymGdCEwijwgYipuz9PTB4M7D2+8eqpZUZYNrObpQ9z5ICuBK5yvHWPSTYQ6VDK026qLCkdKek5eOzw2ZRlOXToIHEyQ6enaInCpdGGJKHiu0lTUOqDB078T+9UJhaUXLI+dWJtrhllrQXzYGITU0NP1UzAZelAYOR56ap6EwfKUPAHKDxVLekhjxQHMal436geLY+AfvfXeKoTsCeWavlUn7cxrKeh9fSb8cTXCrYBOA4SM+qtfb3t0lQHzrolPyNIvbjZkf6gcNRhOTgcT9xOxI2HFSCP/HFaXaUZxOE7R12TDkvnTqxCLsHzd4tGWMVKLFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57P0G9+yjBCYMMhdfHpRpggeucnCKw2tg2tf9AJ54W0=;
 b=H2pbv+QtxO+kvtYqMQWkmnAeEyLHipVeF26wzRAM05AUGuNuRuJpUL6znm8X3oFhSgm+9TZZ0lZQHAfBB7eslmdCmO8Tp7xjsbf9Q8yvsla305Q9R4YU2uOaUkxp9HqDszqemGXplb9jA2LRKofHTi0MIAvhFOGWcheUw4ck6xs=
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by MWHPR11MB1566.namprd11.prod.outlook.com (2603:10b6:301:10::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Mon, 8 Nov
 2021 08:35:17 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::b137:7318:a259:699e]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::b137:7318:a259:699e%9]) with mapi id 15.20.4649.019; Mon, 8 Nov 2021
 08:35:17 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
 interfaces
Thread-Topic: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
 interfaces
Thread-Index: AQHX0oli6labJUcox0OLXoT9uSo8Gqv4HN8AgAEw1JA=
Date:   Mon, 8 Nov 2021 08:35:17 +0000
Message-ID: <MW5PR11MB58120F585A5CF1BCA1E7E958EA919@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211105205331.2024623-1-maciej.machnikowski@intel.com>
 <20211105205331.2024623-7-maciej.machnikowski@intel.com>
 <YYfd7DCFFtj/x+zQ@shredder>
In-Reply-To: <YYfd7DCFFtj/x+zQ@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1e00a73-9474-4b94-888f-08d9a292b16e
x-ms-traffictypediagnostic: MWHPR11MB1566:
x-microsoft-antispam-prvs: <MWHPR11MB15662C1B20B541E07D3C1B90EA919@MWHPR11MB1566.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ASwBan7fmS8KQx4BBqioSseokdA1tme3dlVpfv8EY/nLKl6vANWTuaDbPjCtTwC/PhLHuGnE5/yifylNWm+nQCsc2n+tE4/ukO0UrrOSVAOvW2ygkc0B1OiZGzA8RyF/xcOuvLsNWEvNmH0DC3T1D0nTo23/7A085HMoanIICpUm7XZ53TZBO4CZA/16T9XI/M2nFbSNneFviQqfGmE6QyE+TYLuqn9s7yUqDEOcu3Pn61w6uQ/orXaermFv59FwIc6Hfoe6fVaoTzp1VWsE0xADo6WZNvC0Rwz1v4oCMWe+hMB5WXzpe1mpFeHZ3qSeXxIB6XDMujglEdcJFgHI8nW6RDOtGBIM0mXBHspva1GL0bPlbkgLUtRtche72cvsK20zgIlCjmkKGY+SG7mvEhXXeyAV/UQJXmMGK6WQrIKKMgvmDQJ32TI8jB7A6waCQSwbecRaW+yMIYpzxpFgyv9RbljOpwiYc0f/W7YhLyekXBldj94/97R+zfdZZAP998FJ2IW/6nUDDjkwt4ljvD6Sfv+WSb9iTtvhMiLbp4eSDBvNhvZbZPyy6Bdgzjw7zpCjk3J4pa8Bn4IWaP4vM9y0nbzN0DW4TR5TJs/bgculy55p2J7QQdNLweSBNk7PWK1r3wQegC6gbE8mWjxhcYY6FQN7wNkBOIPCE79vwuAEeJpsq6UAHPBw//NlEe+LC5SFbII4r3C/aYVmEHYUyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(26005)(122000001)(38070700005)(8676002)(76116006)(83380400001)(66556008)(66476007)(6506007)(66446008)(64756008)(66946007)(508600001)(38100700002)(6916009)(82960400001)(4326008)(55016002)(5660300002)(7696005)(71200400001)(53546011)(2906002)(9686003)(33656002)(8936002)(86362001)(54906003)(316002)(52536014)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ajBPK1hkbTJwa2F3eW5pL0FCNEI2RmwwV3VCVUNhaHQwUTdQTG1kYTJpTkJt?=
 =?utf-8?B?OUprUTFTRitmVzc4Z2hxWjcwZWpKcEp4ZmN4L0ZCU2ExWnNEaU5BVmthcktK?=
 =?utf-8?B?ajVMWmtrZGdtZGR4azc3QUovdEZlVTIwWjg4TlU1aXpnbENKVXprM3pWTWx6?=
 =?utf-8?B?NTRtb0p2TzRYV2RMdlQ3bzFBN29YWk9RdzhoZDA3bjZGYWgvWlFic2k0K21V?=
 =?utf-8?B?eWliTjByeHFTeHUwQXZVRVlRUk0vYWt1U050emV6MUgzeUJnMmpjOHZ5UjZR?=
 =?utf-8?B?b1kydDNoMlRPbG9tWW5ZakMvL2RxTGhNNFZveEQ2YXhhbElaYmZQZGpaQTA2?=
 =?utf-8?B?dzI4WUlnWmM5R1pzSFNWaUppeDk1SUoxQlR6bWJKS2VNSzE3TERJMjF6dzRs?=
 =?utf-8?B?VXhsN2c2bG15RzBlbHp2VGFkV3R3b1pJNEdNU1AwVk9JNUJYcjBjL0tJeWFj?=
 =?utf-8?B?Vno0em93a2VneDZ1QmRCUTFMbEpIeXBhemdtRXBjTExwYk5jb21kV2Jxckt3?=
 =?utf-8?B?aVdUUGMvcCtpREFoalQrRGpXcjVjZ3pPR3cvOHJPOTlFWWc4UytvblF2dzZs?=
 =?utf-8?B?di8wT3NzanRIMUI1MU9RdlZhaWpRZjRTQTZkK1VsUWM4RzVKaFFML2NSMFVh?=
 =?utf-8?B?WkEyMU5JL1VycmQxNVBQMGtGN29xNzBPbWJCb0ZKYzlWTlVDRHB6UndIdVU0?=
 =?utf-8?B?cWZBVGdMTG5LS2xxbDhmS252cmN2bzZITWhML2s4d2V5c0hjdWFIZGFlY2w3?=
 =?utf-8?B?V24wMVNvdGVrNXJMd1BaOVE3NCtseG9lREl0anlQZzlSRFBQZGg1ZVhNZG1O?=
 =?utf-8?B?aXV3dS9BdThDMy91a1ZVb1hLc2pNZTRnaDBCM3RudE51VGpwTUZ1RXR5Wm1F?=
 =?utf-8?B?V1VPbXZYSloxVVpValZ6ZUMydFRRcTB4QWk3STJSM0VNK0ZqYkdXTzNIbG5D?=
 =?utf-8?B?bEpQT2h6RThITDV0bFBENkc3cVhUUW94eVZQQldFMmRPNEFiRm9vS0lLQko3?=
 =?utf-8?B?VjB1S3hEV2ZaYlhMTU5IcU5OTm1td1A0dlo2ZDc4dDB1Q3loUzYwenkrcmJm?=
 =?utf-8?B?WmVCdkNSUFpyNFlEbHZaZGJKRHl2YzFMMi8vYmhlZ1NuaVNhNGN6ajM1ak1T?=
 =?utf-8?B?bGgxNk1xZG85c2dxbm8ySGUxVmp6NmtRU3Y4NG00NjcxMjhqRGFNVmIwdnhZ?=
 =?utf-8?B?Mm5FdHNSUll0b05XMC9OYk54WXdWa05mbW9jU09lQnBWc2VMYnpvT0JFUEhT?=
 =?utf-8?B?MHJzaVVaRjdEVU1WZHdjbzZaWW5udmM4dkMycm9va1JEZkRtMWZnYWtpMFFX?=
 =?utf-8?B?SWljY05qaTFvWDdzZVBDaTFNcDNBWDZFNG55c0JtQW1UYTJLRER4b1hHTEc2?=
 =?utf-8?B?WE9kZjMyYURGNEFPZko1WEhqZDVtK1A4azFxL1RjRVQxQVNmc1FJUHBYZklh?=
 =?utf-8?B?cTBEUjVYK0k2QzZwNTZkcFlqVGZMaEZtV05SRVNsVHRFSE52NnhXZklObVpC?=
 =?utf-8?B?M1h6YjhRWlhzNHUvUTkwY3Fvb2xFUmhjTzZnQWRyVUNIM1dmVmh6ME5hNXZE?=
 =?utf-8?B?TkhDV1p1TE81am9uOEp0d1AwNkFoYWJDcVArZFFiVU1jL2hDQ0xIQklTN0Rh?=
 =?utf-8?B?bnBPUmJ1NlNzQko1ZWlsR3E5SndBU2ZSVjNhVUpRYTBwbUZXMnVmbU1abTQy?=
 =?utf-8?B?bkEvY0pZY3F1STBRUnpCSGlaU25IOG5HSkFKTURERloxM1ozN2cwZWlpcFhB?=
 =?utf-8?B?UTFBL3d1Nk5wSzluNmJXcWFJdFg2RDRLc1d5NXZ6b2taODMvSzA2dzZYcXJ3?=
 =?utf-8?B?WStCMlBCdVo1UlQxbWlkeU5UZlZGbXRIbGF1aE15dzhDYmFRS2ZRWUh0VWxj?=
 =?utf-8?B?RE56MFhtTWl4RWJ6QUxWNjEzOEdYcEppNGlndXlpUUgrZDUySmxaTG5ESnFN?=
 =?utf-8?B?TlRPRzRMa1VxNHZFejBabVh2NTdXQUJObXF4Z2tVT1MreHV1RFRjSHhHUUgw?=
 =?utf-8?B?M3R1YWFyMVlwTUxMeUN0aGZDcTNwQmJSekt2UDR6SDhTaDhGVWcxNFVsZFdR?=
 =?utf-8?B?S1B0Z3FwREtLUU5NcEN1c2hRRFY2RXE5WWxNVmV0cXNiK1QwR21vZlgwd09L?=
 =?utf-8?B?MFlJQVI3bFc4T1d3STNIaE5GOHVXT3NwK1MrL1pteTMzSlJadnVmRjZ2V3FK?=
 =?utf-8?B?RGo4dk0zSVJIdkhzaU9VekJMZG5JelNtRmFoNWlnd2gzWVpScU1Kdk1jdndx?=
 =?utf-8?B?b3BPUUppbnlrcVBqVWg5QVQ3ZFB3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1e00a73-9474-4b94-888f-08d9a292b16e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 08:35:17.3719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xbw9q8JQRES5PRfC+3cpsxyrqabWsZ5JNrIoxfihrdBIz7DL03lPtPMU1KTsBjXSLZCsEa58f6es03tQQaUO5yHuZ3NrPK0owUHaRoYGC7A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1566
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBJZG8gU2NoaW1tZWwgPGlkb3Nj
aEBpZG9zY2gub3JnPg0KPiBTZW50OiBTdW5kYXksIE5vdmVtYmVyIDcsIDIwMjEgMzowOSBQTQ0K
PiBUbzogTWFjaG5pa293c2tpLCBNYWNpZWogPG1hY2llai5tYWNobmlrb3dza2lAaW50ZWwuY29t
Pg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyIG5ldC1uZXh0IDYvNl0gZG9jczogbmV0OiBBZGQg
ZGVzY3JpcHRpb24gb2YgU3luY0UNCj4gaW50ZXJmYWNlcw0KPiANCj4gT24gRnJpLCBOb3YgMDUs
IDIwMjEgYXQgMDk6NTM6MzFQTSArMDEwMCwgTWFjaWVqIE1hY2huaWtvd3NraSB3cm90ZToNCj4g
PiArSW50ZXJmYWNlDQo+ID4gKz09PT09PT09PQ0KPiA+ICsNCj4gPiArVGhlIGZvbGxvd2luZyBS
VE5MIG1lc3NhZ2VzIGFyZSB1c2VkIHRvIHJlYWQvY29uZmlndXJlIFN5bmNFIHJlY292ZXJlZA0K
PiA+ICtjbG9ja3MuDQo+ID4gKw0KPiA+ICtSVE1fR0VUUkNMS1JBTkdFDQo+ID4gKy0tLS0tLS0t
LS0tLS0tLS0tDQo+ID4gK1JlYWRzIHRoZSBhbGxvd2VkIHBpbiBpbmRleCByYW5nZSBmb3IgdGhl
IHJlY292ZXJlZCBjbG9jayBvdXRwdXRzLg0KPiA+ICtUaGlzIGNhbiBiZSBhbGlnbmVkIHRvIFBI
WSBvdXRwdXRzIG9yIHRvIEVFQyBpbnB1dHMsIHdoaWNoZXZlciBpcw0KPiA+ICtiZXR0ZXIgZm9y
IGEgZ2l2ZW4gYXBwbGljYXRpb24uDQo+IA0KPiBDYW4geW91IGV4cGxhaW4gdGhlIGRpZmZlcmVu
Y2UgYmV0d2VlbiBQSFkgb3V0cHV0cyBhbmQgRUVDIGlucHV0cz8gSXQgaXMNCj4gbm8gY2xlYXIg
dG8gbWUgZnJvbSB0aGUgZGlhZ3JhbS4NCg0KUEhZIGlzIHRoZSBzb3VyY2Ugb2YgZnJlcXVlbmN5
IGZvciB0aGUgRUVDLCBzbyBQSFkgcHJvZHVjZXMgdGhlIHJlZmVyZW5jZQ0KQW5kIEVFQyBzeW5j
aHJvbml6ZXMgdG8gaXQuDQoNCkJvdGggUEhZIG91dHB1dHMgYW5kIEVFQyBpbnB1dHMgYXJlIGNv
bmZpZ3VyYWJsZS4gUEhZIG91dHB1dHMgdXN1YWxseSBhcmUNCmNvbmZpZ3VyZWQgdXNpbmcgUEhZ
IHJlZ2lzdGVycywgYW5kIEVFQyBpbnB1dHMgaW4gdGhlIERQTEwgcmVmZXJlbmNlcw0KYmxvY2sN
CiANCj4gSG93IHdvdWxkIHRoZSBkaWFncmFtIGxvb2sgaW4gYSBtdWx0aS1wb3J0IGFkYXB0ZXIg
d2hlcmUgeW91IGhhdmUgYQ0KPiBzaW5nbGUgRUVDPw0KDQpUaGF0IGRlcGVuZHMuIEl0IGNhbiBi
ZSBlaXRoZXIgYSBtdWx0aXBvcnQgUEhZIC0gaW4gdGhpcyBjYXNlIGl0IHdpbGwgbG9vaw0KZXhh
Y3RseSBsaWtlIHRoZSBvbmUgSSBkcmF3bi4gSW4gY2FzZSB3ZSBoYXZlIG11bHRpcGxlIFBIWXMg
dGhlaXIgcmVjb3ZlcmVkDQpjbG9jayBvdXRwdXRzIHdpbGwgZ28gdG8gZGlmZmVyZW50IHJlY292
ZXJlZCBjbG9jayBpbnB1dHMgYW5kIGVhY2ggUEhZDQpUWCBjbG9jayBpbnB1dHMgd2lsbCBiZSBk
cml2ZW4gZnJvbSBkaWZmZXJlbnQgRUVDJ3Mgc3luY2hyb25pemVkIG91dHB1dHMNCm9yIGZyb20g
YSBzaW5nbGUgb25lIHRocm91Z2ggIGNsb2NrIGZhbiBvdXQuDQoNCj4gPiArV2lsbCBjYWxsIHRo
ZSBuZG9fZ2V0X3JjbGtfcmFuZ2UgZnVuY3Rpb24gdG8gcmVhZCB0aGUgYWxsb3dlZCByYW5nZQ0K
PiA+ICtvZiBvdXRwdXQgcGluIGluZGV4ZXMuDQo+ID4gK1dpbGwgY2FsbCBuZG9fZ2V0X3JjbGtf
cmFuZ2UgdG8gZGV0ZXJtaW5lIHRoZSBhbGxvd2VkIHJlY292ZXJlZCBjbG9jaw0KPiA+ICtyYW5n
ZSBhbmQgcmV0dXJuIHRoZW0gaW4gdGhlIElGTEFfUkNMS19SQU5HRV9NSU5fUElOIGFuZCB0aGUN
Cj4gPiArSUZMQV9SQ0xLX1JBTkdFX01BWF9QSU4gYXR0cmlidXRlcw0KPiANCj4gVGhlIGZpcnN0
IHNlbnRlbmNlIHNlZW1zIHRvIGJlIHJlZHVuZGFudA0KPiANCj4gPiArDQo+ID4gK1JUTV9HRVRS
Q0xLU1RBVEUNCj4gPiArLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiArUmVhZCB0aGUgc3RhdGUgb2Yg
cmVjb3ZlcmVkIHBpbnMgdGhhdCBvdXRwdXQgcmVjb3ZlcmVkIGNsb2NrIGZyb20NCj4gPiArYSBn
aXZlbiBwb3J0LiBUaGUgbWVzc2FnZSB3aWxsIGNvbnRhaW4gdGhlIG51bWJlciBvZiBhc3NpZ25l
ZCBjbG9ja3MNCj4gPiArKElGTEFfUkNMS19TVEFURV9DT1VOVCkgYW5kIGFuIE4gcGluIGluZGV4
ZXMgaW4NCj4gSUZMQV9SQ0xLX1NUQVRFX09VVF9JRFgNCj4gPiArVG8gc3VwcG9ydCBtdWx0aXBs
ZSByZWNvdmVyZWQgY2xvY2sgb3V0cHV0cyBmcm9tIHRoZSBzYW1lIHBvcnQsIHRoaXMNCj4gbWVz
c2FnZQ0KPiA+ICt3aWxsIHJldHVybiB0aGUgSUZMQV9SQ0xLX1NUQVRFX0NPVU5UIGF0dHJpYnV0
ZSBjb250YWluaW5nIHRoZSBudW1iZXINCj4gb2YNCj4gPiArYWN0aXZlIHJlY292ZXJlZCBjbG9j
ayBvdXRwdXRzIChOKSBhbmQgTiBJRkxBX1JDTEtfU1RBVEVfT1VUX0lEWA0KPiBhdHRyaWJ1dGVz
DQo+ID4gK2xpc3RpbmcgdGhlIGFjdGl2ZSBvdXRwdXQgaW5kZXhlcy4NCj4gPiArVGhpcyBtZXNz
YWdlIHdpbGwgY2FsbCB0aGUgbmRvX2dldF9yY2xrX3JhbmdlIHRvIGRldGVybWluZSB0aGUgYWxs
b3dlZA0KPiA+ICtyZWNvdmVyZWQgY2xvY2sgaW5kZXhlcyBhbmQgdGhlbiB3aWxsIGxvb3AgdGhy
b3VnaCB0aGVtLCBjYWxsaW5nDQo+ID4gK3RoZSBuZG9fZ2V0X3JjbGtfc3RhdGUgZm9yIGVhY2gg
b2YgdGhlbS4NCj4gDQo+IFdoeSBkbyB5b3UgbmVlZCBib3RoIFJUTV9HRVRSQ0xLUkFOR0UgYW5k
IFJUTV9HRVRSQ0xLU1RBVEU/IElzbid0DQo+IFJUTV9HRVRSQ0xLU1RBVEUgZW5vdWdoPyBJbnN0
ZWFkIG9mIHNraXBwaW5nIG92ZXIgImRpc2FibGVkIiBwaW5zIGluIHRoZQ0KPiByYW5nZSBJRkxB
X1JDTEtfUkFOR0VfTUlOX1BJTi4uSUZMQV9SQ0xLX1JBTkdFX01BWF9QSU4sIGp1c3QNCj4gcmVw
b3J0IHRoZQ0KPiBzdGF0ZSAoZW5hYmxlZCAvIGRpc2FibGUpIGZvciBhbGwNCg0KR3JlYXQgaWRl
YSEgV2lsbCBpbXBsZW1lbnQgaXQuDQogDQo+ID4gKw0KPiA+ICtSVE1fU0VUUkNMS1NUQVRFDQo+
ID4gKy0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gK1NldHMgdGhlIHJlZGlyZWN0aW9uIG9mIHRoZSBy
ZWNvdmVyZWQgY2xvY2sgZm9yIGEgZ2l2ZW4gcGluLiBUaGlzIG1lc3NhZ2UNCj4gPiArZXhwZWN0
cyBvbmUgYXR0cmlidXRlOg0KPiA+ICtzdHJ1Y3QgaWZfc2V0X3JjbGtfbXNnIHsNCj4gPiArCV9f
dTMyIGlmaW5kZXg7IC8qIGludGVyZmFjZSBpbmRleCAqLw0KPiA+ICsJX191MzIgb3V0X2lkeDsg
Lyogb3V0cHV0IGluZGV4IChmcm9tIGEgdmFsaWQgcmFuZ2UpDQo+ID4gKwlfX3UzMiBmbGFnczsg
LyogY29uZmlndXJhdGlvbiBmbGFncyAqLw0KPiA+ICt9Ow0KPiA+ICsNCj4gPiArU3VwcG9ydGVk
IGZsYWdzIGFyZToNCj4gPiArU0VUX1JDTEtfRkxBR1NfRU5BIC0gaWYgc2V0IGluIGZsYWdzIC0g
dGhlIGdpdmVuIG91dHB1dCB3aWxsIGJlIGVuYWJsZWQsDQo+ID4gKwkJICAgICBpZiBjbGVhciAt
IHRoZSBvdXRwdXQgd2lsbCBiZSBkaXNhYmxlZC4NCj4gDQo+IEluIHRoZSBkaWFncmFtIHlvdSBo
YXZlIHR3byByZWNvdmVyZWQgY2xvY2sgb3V0cHV0cyBnb2luZyBpbnRvIHRoZSBFRUMuDQo+IEFj
Y29yZGluZyB0byB3aGljaCB0aGUgRUVDIGlzIHN5bmNocm9uaXplZD8NCg0KVGhhdCB3aWxsIGRl
cGVuZCBvbiB0aGUgZnV0dXJlIERQTEwgY29uZmlndXJhdGlvbi4gRm9yIG5vdyBpdCdsbCBiZSBi
YXNlZA0Kb24gdGhlIERQTEwncyBhdXRvIHNlbGVjdCBhYmlsaXR5IGFuZCBpdHMgZGVmYXVsdCBj
b25maWd1cmF0aW9uLg0KIA0KPiBIb3cgZG9lcyB1c2VyIHNwYWNlIGtub3cgd2hpY2ggcGlucyB0
byBlbmFibGU/DQoNClRoYXQncyB3aHkgdGhlIFJUTV9HRVRSQ0xLUkFOR0Ugd2FzIGludmVudGVk
IGJ1dCBJIGxpa2UgdGhlIHN1Z2dlc3Rpb24NCnlvdSBtYWRlIGFib3ZlIHNvIHdpbGwgcmV3b3Jr
IHRoZSBjb2RlIHRvIHJlbW92ZSB0aGUgcmFuZ2Ugb25lIGFuZA0KanVzdCByZXR1cm4gdGhlIGlu
ZGV4ZXMgd2l0aCBlbmFibGUvZGlzYWJsZSBiaXQgZm9yIGVhY2ggb2YgdGhlbS4gSW4gdGhpcw0K
Y2FzZSB5b3VzZXJzcGFjZSB3aWxsIGp1c3Qgc2VuZCB0aGUgUlRNX0dFVFJDTEtTVEFURSB0byBs
ZWFybiB3aGF0DQpjYW4gYmUgZW5hYmxlZC4NCg0KPiA+ICsNCj4gPiArUlRNX0dFVEVFQ1NUQVRF
DQo+ID4gKy0tLS0tLS0tLS0tLS0tLS0NCj4gPiArUmVhZHMgdGhlIHN0YXRlIG9mIHRoZSBFRUMg
b3IgZXF1aXZhbGVudCBwaHlzaWNhbCBjbG9jayBzeW5jaHJvbml6ZXIuDQo+ID4gK1RoaXMgbWVz
c2FnZSByZXR1cm5zIHRoZSBmb2xsb3dpbmcgYXR0cmlidXRlczoNCj4gPiArSUZMQV9FRUNfU1RB
VEUgLSBjdXJyZW50IHN0YXRlIG9mIHRoZSBFRUMgb3IgZXF1aXZhbGVudCBjbG9jayBnZW5lcmF0
b3IuDQo+ID4gKwkJIFRoZSBzdGF0ZXMgcmV0dXJuZWQgaW4gdGhpcyBhdHRyaWJ1dGUgYXJlIGFs
aWduZWQgdG8gdGhlDQo+ID4gKwkJIElUVS1UIEcuNzgxIGFuZCBhcmU6DQo+ID4gKwkJICBJRl9F
RUNfU1RBVEVfSU5WQUxJRCAtIHN0YXRlIGlzIG5vdCB2YWxpZA0KPiA+ICsJCSAgSUZfRUVDX1NU
QVRFX0ZSRUVSVU4gLSBjbG9jayBpcyBmcmVlLXJ1bm5pbmcNCj4gPiArCQkgIElGX0VFQ19TVEFU
RV9MT0NLRUQgLSBjbG9jayBpcyBsb2NrZWQgdG8gdGhlIHJlZmVyZW5jZSwNCj4gPiArCQkgICAg
ICAgICAgICAgICAgICAgICAgICBidXQgdGhlIGhvbGRvdmVyIG1lbW9yeSBpcyBub3QgdmFsaWQN
Cj4gPiArCQkgIElGX0VFQ19TVEFURV9MT0NLRURfSE9fQUNRIC0gY2xvY2sgaXMgbG9ja2VkIHRv
IHRoZQ0KPiByZWZlcmVuY2UNCj4gPiArCQkgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
YW5kIGhvbGRvdmVyIG1lbW9yeSBpcyB2YWxpZA0KPiA+ICsJCSAgSUZfRUVDX1NUQVRFX0hPTERP
VkVSIC0gY2xvY2sgaXMgaW4gaG9sZG92ZXIgbW9kZQ0KPiA+ICtTdGF0ZSBpcyByZWFkIGZyb20g
dGhlIG5ldGRldiBjYWxsaW5nIHRoZToNCj4gPiAraW50ICgqbmRvX2dldF9lZWNfc3RhdGUpKHN0
cnVjdCBuZXRfZGV2aWNlICpkZXYsIGVudW0gaWZfZWVjX3N0YXRlDQo+ICpzdGF0ZSwNCj4gPiAr
CQkJIHUzMiAqc3JjX2lkeCwgc3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrKTsNCj4gPiAr
DQo+ID4gK0lGTEFfRUVDX1NSQ19JRFggLSBvcHRpb25hbCBhdHRyaWJ1dGUgcmV0dXJuaW5nIHRo
ZSBpbmRleCBvZiB0aGUNCj4gcmVmZXJlbmNlIHRoYXQNCj4gPiArCQkgICBpcyB1c2VkIGZvciB0
aGUgY3VycmVudCBJRkxBX0VFQ19TVEFURSwgaS5lLiwgdGhlIGluZGV4IG9mDQo+ID4gKwkJICAg
dGhlIHBpbiB0aGF0IHRoZSBFRUMgaXMgbG9ja2VkIHRvLg0KPiA+ICsNCj4gPiArV2lsbCBiZSBy
ZXR1cm5lZCBvbmx5IGlmIHRoZSBuZG9fZ2V0X2VlY19zcmMgaXMgaW1wbGVtZW50ZWQuDQo+ID4g
XCBObyBuZXdsaW5lIGF0IGVuZCBvZiBmaWxlDQo+ID4gLS0NCj4gPiAyLjI2LjMNCj4gPg0K
