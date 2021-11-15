Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40BDF45027A
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 11:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237641AbhKOK2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 05:28:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:7815 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237628AbhKOK1q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 05:27:46 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="233254692"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="233254692"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 02:24:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="453774980"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 15 Nov 2021 02:24:50 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 15 Nov 2021 02:24:50 -0800
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 15 Nov 2021 02:24:50 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 15 Nov 2021 02:24:50 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 15 Nov 2021 02:24:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VSrWHeE5Vphqtew9r/OoJN5isKRsCkTipr7G6wQYeNzvZwfMhyJEp1fMcepv/X7M5G3JOx9Udkp/hdH5tfu4rtFzl2R/AZXsDsbzyZ4rMeqePfufhZWMSURz8ivL6mdaRIHmQGkbHTZXTqnQfUcrqDC1dVjRDgBsJJIMDqbkkTW9f4RhiZkJlUlIfyfz9JXW4HfqlVepCJcZp6qSS1CXeIu4Su8ef1A23GviX4MkYAAhYXWDYz4hVS+10qggGyXoa6+xdHQVlzTFAHpvjF1hfWEMkOkfGk0jUnn81fLvGSzZTL0t9uziCC1TAeDmLbb0rQhntjaOofXf27KCXgv6fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0daJktQc1Uq7c6SkKYS5GS5bkY7iPGgODfU/7vfF/DU=;
 b=Fk+9RyjITCCrFNCXdjbNIJBP6XBG8ZfOmAUyJPxe3mc7ngAf9k175ZHwqB2OnO9aDVqGj/hGOkVCipxv1fBl462E6TqH3aaYIMAnfDPW8c4GoYTaQ0jkbQSTQBp57Avii3RTrj74SkY3M9q1hG1QSyVEfU37xJaMocC3S3tH8pKpQY1qfa6/Cl9ye/ME1Dwr0rb9You5AavbXPh/pW9uXYWD4gt8C9MdsQJK7Pf50Jn75TqXPygQ7pimUY4d5gXiVsq2iF6C2MpqeSI9V2lndnv83YzHkdo/M5AmxmjyJYUpVBowQ5G0ysTR8yxRpU5flN/kkCoog2p6HnXoqS3LWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0daJktQc1Uq7c6SkKYS5GS5bkY7iPGgODfU/7vfF/DU=;
 b=mwO7ZybOvl7Sh24LUIYpDwZwEUHP9tRKr+MyiiEvVwgj/Iy8LMiEVYzNvJsI2V8nkVIs9FrmS77cl2sSyOt2L270w18nVvf263PaEtQvt+xL6/bmkE/0yl4AqTbTl7TctmObarYHh19316V5d9PJoizM2Pp9/h+xfdGHur7Pbi0=
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by MW5PR11MB5858.namprd11.prod.outlook.com (2603:10b6:303:193::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Mon, 15 Nov
 2021 10:24:46 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1127:5635:26df:eca9]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1127:5635:26df:eca9%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 10:24:46 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [PATCH v3 net-next 6/6] docs: net: Add description of SyncE
 interfaces
Thread-Topic: [PATCH v3 net-next 6/6] docs: net: Add description of SyncE
 interfaces
Thread-Index: AQHX1iqaoGL4JrqyH0+WzcbffTt8mqv+RxWAgAYf5AA=
Date:   Mon, 15 Nov 2021 10:24:46 +0000
Message-ID: <MW5PR11MB5812E733ED2BB621A3249CD5EA989@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211110114448.2792314-1-maciej.machnikowski@intel.com>
 <20211110114448.2792314-7-maciej.machnikowski@intel.com>
 <87tugic17a.fsf@nvidia.com>
In-Reply-To: <87tugic17a.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1729ac33-d253-48c1-bdc7-08d9a82225c4
x-ms-traffictypediagnostic: MW5PR11MB5858:
x-microsoft-antispam-prvs: <MW5PR11MB58580802A492D64537E802C4EA989@MW5PR11MB5858.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZsP5e7cdbqYEb6mxh6w2R5VSbbIeReUVpVDYPRObB0wvaFrBOFr0ulv6AOKNeJif+j0VTdwfWvLSejaOMMZx7caclqZVnLFIqALPz9/0GlgRK0jajF1UxEI2VdkQ4F2q97uJ59N/CMnE7NXXlyAYBFMnQdPMIcfDkrQWiWNvCqwF3PkwKYZrE6hmlTAA02WxFlYsDxip1t08XqtT75LuWKaQcWooPeCfd5AclBU4NBMZkkpgqocT6uydM89YBBqym7r81JXXyplYNAZePGf6/okn7tcHhv0+2iiHftwsj1MWOc9I3ouNUXP3FlJNyHtC6fC8pYyAfxD2BdnWhAdqPyzDyNLq4n2wwHg+T2/D96Yic8x7Uv3GiAyaxZA09Jtpr2xbsNaALDy769WBbL6RbROgj+tWulbi/sTXBvFLvtqg353vNkZ5JIXE5S3d83sg6ula6bX/lj+rSKNSxB2DLHzpe3VBR+M32SLG96wKpC20BqwRVGm0N59sn2T1Lf0o21W/6zcpi5cV6WOugXEhvkAvf9+323G+glUJB07CEj5ojtNem15Q2Z6AQo6Y4yucOedmoOKzzdEF/fyoQjddjcWFXOoFm5drFf4EniaVRKTnMgWEaFOdmsPLG2LYj1lvuztDzeL+oX5tTXPsNjMMGHnQOPxKAl2KXl4RxZO29QyDJoW8KKIZkrgE//ioDv4fLzYBx+gipt6nBH9J6/QXwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7416002)(66476007)(4326008)(26005)(9686003)(316002)(186003)(66946007)(38070700005)(66556008)(66446008)(64756008)(86362001)(6506007)(76116006)(7696005)(71200400001)(33656002)(53546011)(5660300002)(83380400001)(2906002)(508600001)(8936002)(122000001)(55016002)(38100700002)(82960400001)(52536014)(8676002)(6916009)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YlBXV3JZbGxvVnN0L0YzM0ZKZjVEQkQ3VG9qbDRzMXNYNkFFN0xXc3VmYnNT?=
 =?utf-8?B?ME9CYlFVSzNBdDVZWXB2YlVONzJHcGc1ZHRoaXBIc29YU09ZTjhMcWFkVDhG?=
 =?utf-8?B?K29ESGpaUmpYZGN6LzViWHdrSllRYWlNQy9BMWk1emhGWjBRdWJhenFTM2NK?=
 =?utf-8?B?N2RWSkRvM09wbk11QnhZQ2VrNWNzYWVtSXpOUlRlVXpta0U4VUpUYVkrenJr?=
 =?utf-8?B?NWlBcWZtZ05KK0RSNHZiTDhnY2tEZHBHSFNJRnZDbWJhblFQTXhzMGZTclBN?=
 =?utf-8?B?dXY3d3NGYTYrT3VjNWVMWEplTit1MjBZcmlkWk1BZzhoWkQ4TmlnZGlxUzRq?=
 =?utf-8?B?ZmtzVkpSQmxxeUxEUGZCVW9BOHVvb05DaERSc2FmTjJGeTFlY0VINGYxNUVo?=
 =?utf-8?B?dnIwT2F5RXJCTXl1d0RmUmt0dVJySTdGTHorREJ4MjV1dkh5RWlOWURScmU2?=
 =?utf-8?B?a0NYVXNWbEJ5VDhjV2hzT1VuU3BpR29xUktMSUM0OTU4aHBwNEJrcXkraVFT?=
 =?utf-8?B?aU9SL2ZzYzBncUgvS20weFk2bE5WY0MrckdsSjV5MERWcWc2WGpiYnBaOWVv?=
 =?utf-8?B?WTY3WmxlcDU0QzBBZXFzR1I3dFV5dUIyS1dQVHJHd1M3WTRRT09zdDF4SDFM?=
 =?utf-8?B?VW9zOXI0MVRPSmpNc2QyeHpoRC9SWXJ1cXBmbkRpQnY0YXp4QTRlT1BkbXJM?=
 =?utf-8?B?eXlzNjJjZ1RNbEtaQ0srWC9IUTB1QjF1WjM3ZXJlNXpkN05rcFo1dkloenE3?=
 =?utf-8?B?dXNOV0dCUUhwWHdXbW5IU0pZMlhDUjVqWGo2bzY3WWYvSy80djVmWXNpdUhn?=
 =?utf-8?B?QlpVOGxWWGFMa2JEWGVBRHdaaFBYRElWQUlSUDhHL0I2WTZLOGdFdmNtY0RM?=
 =?utf-8?B?bWFRR1FRak1MUUVqaXJQbm5qaUMrRkJDZk9NeGlIUjRsVDgxQXkvZ3dNdDRT?=
 =?utf-8?B?SEtYVUxqOVl5WmtsS1hxWUoraG5jWmI2U1hrMEtHR0hOdU5SUEI5VzdINzdM?=
 =?utf-8?B?N0Rqb1FzdTljdG1Bd3prWHUwenRIdERkcVFqQXl6cUJadmx3SDR6cW54K1FL?=
 =?utf-8?B?VHVWY3MzWGNpMkg4NmFodldNSUs0S3hLMSszYkIzWER0TmRIT1Q0bkRlN1l3?=
 =?utf-8?B?NDl4aDZDTitJMWlwcTRTYUt0Q09YTGY4OTU5R096SHo3ZWt5Y3Y3ZlFJZ25r?=
 =?utf-8?B?bGR4VE5xYTl3d04wQkhsMytJVWFmSzMrbXVIUlpvRnNENW1XY1VjQzRHdkpu?=
 =?utf-8?B?TVljRTVmR21jUlN0cmZzU0dqMXhSUWgzMHhsUWlGZ0E1UERBSkk4RHRUM296?=
 =?utf-8?B?czB5czFCSW4yQUlwNHpJMnIyR0VkZitTRktsWXBHQlpBUkZKb2JSK01hVkVx?=
 =?utf-8?B?Wnpnd1dXV21xaFExZHdyckNrZUFnOERKYjVRemNsSmVzdHh3UVM4c1gzV01R?=
 =?utf-8?B?ejBpQkNYdExjbENYbWx2U1k3bzl2NmxFTDJkWDd3ZEpHd3NPRDJEYThQSjha?=
 =?utf-8?B?R21DeWEybDR1RWc5QUI5S1dJWjVrbitSSDdyaktOdDB4cHdwVXJtSUcvMUFs?=
 =?utf-8?B?NXcwdDVKdHZ3QnpsVmt5RmtyWFhING5uV0paU1pCK09CdngvWGgyUlZtbmww?=
 =?utf-8?B?Nk8zK0VFYWY5UU1IUUFFeGQ5dzhyU0srMi9RTjBGVGpOZlJUMlVZZ2FDRHV3?=
 =?utf-8?B?bkVEdG5RQmwxM2NneldXVHJkQnRKK3NXNUl2UnBoZ1lZNUJYc0JobVpxbzgx?=
 =?utf-8?B?bXBXQm96aUNhdUFFRHREVldwaEw4NTdjRUJwT1JZNk9aU0FBMGNBbnN1QUhi?=
 =?utf-8?B?Z2hNSTdCUkgyRjJFK1RYa29Dc1Q2ZWdKd3RzN1R6Y1Y1ZnJ5a0tCc0NtOFBw?=
 =?utf-8?B?ejdhbzBWQU5mMGd6VisvS3NQU3hXWlZaVWhIQTcwZXhDSUdTNVh6MWdaR2pn?=
 =?utf-8?B?VUV0bXk0YWF2Q1U2c2h4ZHNFOW5XMGhFRlRZU1BPTFExdGZ0RzZzWXJBR3No?=
 =?utf-8?B?aDArdzZyZld4L2JVLzgvVFl0K2xnaXAwcG1ESVNlejlrYWhhRU5PMldEY1hk?=
 =?utf-8?B?VEtoTUZiUDZDMjY0cDZkYzVEN1FUWHVaMjdYL2kzYzVpVFpuZmVNd3Fxbi94?=
 =?utf-8?B?aGxQL05sRUtoaVVjUlZSaVV3ck5uOXYwc1lpNVczc0hGZWhXS1h2UElmRkkv?=
 =?utf-8?B?TWJCQ0hyNXZGMHR5dUdKNlVCMjF1Tmp0cTRYS2xVNFdsT0hrYVBBU3BpQmtI?=
 =?utf-8?B?ZktUdFVHSVIzL016WnlOQTE3Y1pBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1729ac33-d253-48c1-bdc7-08d9a82225c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 10:24:46.4406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SKpSqvSfUMAcZ/e0a+ZYCjB+VLutWPAtheA5yqPoH7QQfrqrvfLNYsqsMcH3vfprlccRzaiy1RXFssyv2hC5zl8Boi4f2Lp+QWHEjSWyZAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5858
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQZXRyIE1hY2hhdGEgPHBldHJt
QG52aWRpYS5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBOb3ZlbWJlciAxMSwgMjAyMSAxOjQzIFBN
DQo+IFRvOiBNYWNobmlrb3dza2ksIE1hY2llaiA8bWFjaWVqLm1hY2huaWtvd3NraUBpbnRlbC5j
b20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjMgbmV0LW5leHQgNi82XSBkb2NzOiBuZXQ6IEFk
ZCBkZXNjcmlwdGlvbiBvZiBTeW5jRQ0KPiBpbnRlcmZhY2VzDQo+IA0KPiANCj4gTWFjaWVqIE1h
Y2huaWtvd3NraSA8bWFjaWVqLm1hY2huaWtvd3NraUBpbnRlbC5jb20+IHdyaXRlczoNCj4gDQo+
ID4gQWRkIERvY3VtZW50YXRpb24vbmV0d29ya2luZy9zeW5jZS5yc3QgZGVzY3JpYmluZyBuZXcg
UlROTCBtZXNzYWdlcw0KPiA+IGFuZCByZXNwZWN0aXZlIE5ETyBvcHMgc3VwcG9ydGluZyBTeW5j
RSAoU3luY2hyb25vdXMgRXRoZXJuZXQpLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogTWFjaWVq
IE1hY2huaWtvd3NraSA8bWFjaWVqLm1hY2huaWtvd3NraUBpbnRlbC5jb20+DQo+ID4gLS0tDQou
Li4NCj4gPiArUlRNX0dFVEVFQ1NUQVRFDQo+ID4gKy0tLS0tLS0tLS0tLS0tLS0NCj4gPiArUmVh
ZHMgdGhlIHN0YXRlIG9mIHRoZSBFRUMgb3IgZXF1aXZhbGVudCBwaHlzaWNhbCBjbG9jayBzeW5j
aHJvbml6ZXIuDQo+ID4gK1RoaXMgbWVzc2FnZSByZXR1cm5zIHRoZSBmb2xsb3dpbmcgYXR0cmli
dXRlczoNCj4gPiArSUZMQV9FRUNfU1RBVEUgLSBjdXJyZW50IHN0YXRlIG9mIHRoZSBFRUMgb3Ig
ZXF1aXZhbGVudCBjbG9jayBnZW5lcmF0b3IuDQo+ID4gKwkJIFRoZSBzdGF0ZXMgcmV0dXJuZWQg
aW4gdGhpcyBhdHRyaWJ1dGUgYXJlIGFsaWduZWQgdG8gdGhlDQo+ID4gKwkJIElUVS1UIEcuNzgx
IGFuZCBhcmU6DQo+ID4gKwkJICBJRl9FRUNfU1RBVEVfSU5WQUxJRCAtIHN0YXRlIGlzIG5vdCB2
YWxpZA0KPiA+ICsJCSAgSUZfRUVDX1NUQVRFX0ZSRUVSVU4gLSBjbG9jayBpcyBmcmVlLXJ1bm5p
bmcNCj4gPiArCQkgIElGX0VFQ19TVEFURV9MT0NLRUQgLSBjbG9jayBpcyBsb2NrZWQgdG8gdGhl
IHJlZmVyZW5jZSwNCj4gPiArCQkgICAgICAgICAgICAgICAgICAgICAgICBidXQgdGhlIGhvbGRv
dmVyIG1lbW9yeSBpcyBub3QgdmFsaWQNCj4gPiArCQkgIElGX0VFQ19TVEFURV9MT0NLRURfSE9f
QUNRIC0gY2xvY2sgaXMgbG9ja2VkIHRvIHRoZQ0KPiByZWZlcmVuY2UNCj4gPiArCQkgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgYW5kIGhvbGRvdmVyIG1lbW9yeSBpcyB2YWxpZA0KPiA+
ICsJCSAgSUZfRUVDX1NUQVRFX0hPTERPVkVSIC0gY2xvY2sgaXMgaW4gaG9sZG92ZXIgbW9kZQ0K
PiA+ICtTdGF0ZSBpcyByZWFkIGZyb20gdGhlIG5ldGRldiBjYWxsaW5nIHRoZToNCj4gPiAraW50
ICgqbmRvX2dldF9lZWNfc3RhdGUpKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIGVudW0gaWZfZWVj
X3N0YXRlDQo+ICpzdGF0ZSwNCj4gPiArCQkJIHUzMiAqc3JjX2lkeCwgc3RydWN0IG5ldGxpbmtf
ZXh0X2FjayAqZXh0YWNrKTsNCj4gPiArDQo+ID4gK0lGTEFfRUVDX1NSQ19JRFggLSBvcHRpb25h
bCBhdHRyaWJ1dGUgcmV0dXJuaW5nIHRoZSBpbmRleCBvZiB0aGUNCj4gcmVmZXJlbmNlDQo+ID4g
KwkJICAgdGhhdCBpcyB1c2VkIGZvciB0aGUgY3VycmVudCBJRkxBX0VFQ19TVEFURSwgaS5lLiwN
Cj4gPiArCQkgICB0aGUgaW5kZXggb2YgdGhlIHBpbiB0aGF0IHRoZSBFRUMgaXMgbG9ja2VkIHRv
Lg0KPiA+ICsNCj4gPiArV2lsbCBiZSByZXR1cm5lZCBvbmx5IGlmIHRoZSBuZG9fZ2V0X2VlY19z
cmMgaXMgaW1wbGVtZW50ZWQuDQo+ID4gXCBObyBuZXdsaW5lIGF0IGVuZCBvZiBmaWxlDQo+IA0K
PiBKdXN0IHRvIGJlIGNsZWFyLCBJIGhhdmUgbXVjaCB0aGUgc2FtZSBvYmplY3Rpb25zIHRvIHRo
aXMgVUFQSSBhcyBJIGhhZA0KPiB0byB2MjoNCj4gDQo+IC0gUlRNX0dFVEVFQ1NUQVRFIHdpbGwg
YmVjb21lIG9ic29sZXRlIGFzIHNvb24gYXMgRFBMTCBvYmplY3QgaXMgYWRkZWQuDQoNClllcyBm
b3IgbW9yZSBjb21wbGV4IGRldmljZXMgYW5kIG5vIGZvciBzaW1wbGUgb25lcw0KDQo+IC0gUmVw
b3J0aW5nIHBpbnMgdGhyb3VnaCB0aGUgbmV0ZGV2aWNlcyB0aGF0IHVzZSB0aGVtIGFsbG93cyBm
b3INCj4gICBjb25maWd1cmF0aW9ucyB0aGF0IGFyZSBsaWtlbHkgaW52YWxpZCwgbGlrZSBkaXNq
b2ludCAiZnJlcXVlbmN5DQo+ICAgYnJpZGdlcyIuDQoNCk5vdCBzdXJlIGlmIEkgdW5kZXJzdGFu
ZCB0aGF0IGNvbW1lbnQuIEluIHRhcmdldCBhcHBsaWNhdGlvbiBhIGdpdmVuDQpuZXRkZXYgd2ls
bCByZWNlaXZlIGFuIEVTTUMgbWVzc2FnZSBjb250YWluaW5nIHRoZSBxdWFsaXR5IG9mIHRoZQ0K
Y2xvY2sgdGhhdCBpdCBoYXMgb24gdGhlIHJlY2VpdmUgc2lkZS4gVGhlIHVwcGVyIGxheWVyIHNv
ZnR3YXJlIHdpbGwNCnNlZSBRTF9QUkMgb24gb25lIHBvcnQgYW5kIFFMX0VFQyBvbiBvdGhlciBh
bmQgd2lsbCBuZWVkIHRvIGVuYWJsZQ0KY2xvY2sgb3V0cHV0IGZyb20gdGhlIHBvcnQgdGhhdCBy
ZWNlaXZlZCBRTF9QUkMsIGFzIGl0J3MgdGhlIGhpZ2hlciBjbG9jaw0KY2xhc3MuIE9uY2UgdGhl
IEVFQyByZXBvcnRzIExvY2tlZCBzdGF0ZSBhbGwgb3RoZXIgcG9ydHMgdGhhdCBhcmUgdHJhY2Vh
YmxlDQp0byBhIGdpdmVuIEVFQyAoZWl0aGVyIHVzaW5nIHRoZSBEUExMIHN1YnN5c3RlbSwgb3Ig
dGhlIGNvbmZpZyBmaWxlKQ0Kd2lsbCBzdGFydCByZXBvcnRpbmcgUUxfUFJDIHRvIGRvd25zdHJl
YW0gZGV2aWNlcy4NCg0KPiAtIEl0J3Mgbm90IGNsZWFyIHdoYXQgZW5hYmxpbmcgc2V2ZXJhbCBw
aW5zIG1lYW5zLCBhbmQgaXQncyBub3QgY2xlYXINCj4gICB3aGV0aGVyIHRoaXMgZ2VuZXJpY2l0
eSBpcyBub3QgZ29pbmcgdG8gYmUgYW4gaXNzdWUgaW4gdGhlIGZ1dHVyZSB3aGVuDQo+ICAgd2Ug
a25vdyB3aGF0IGVuYWJsaW5nIG1vcmUgcGlucyBtZWFucy4NCg0KSXQgbWVhbnMgdGhhdCB0aGUg
cmVjb3ZlcmVkIGZyZXF1ZW5jeSB3aWxsIGFwcGVhciBvbiAyIG9yIG1vcmUgcGh5c2ljYWwNCnBp
bnMgb2YgdGhlIHBhY2thZ2UuDQogDQo+IC0gTm8gd2F5IGFzIGEgdXNlciB0byB0ZWxsIHdoZXRo
ZXIgdHdvIGludGVyZmFjZXMgdGhhdCByZXBvcnQgdGhlIHNhbWUNCj4gICBwaW5zIGFyZSBhY3R1
YWxseSBjb25uZWN0ZWQgdG8gdGhlIHNhbWUgRUVDLiBIb3cgbWFueSBFRUMncyBhcmUgdGhlcmUs
DQo+ICAgaW4gdGhlIHN5c3RlbSwgYW55d2F5Pw0KDQpGb3Igbm93IHdlIGNhbiBmaXggdGhhdCB3
aXRoIHRoZSBjb25maWcgZmlsZSwgZm9yIGZ1dHVyZSB3ZSB3aWxsIGJlIGFibGUgdG8NCnRyYWNl
IHRoZW0gdG8gdGhlIHNhbWUgRUVDLiBJdCdzIGxpa2UgQkMgaW4gUFRQIC0geW91IGNhbiByZWx5
IG9uIGF1dG9tYXRlZA0KbW9kZSwgYnV0IGNhbiBhbHNvIG92ZXJyaWRlIGl0IHdpdGggdGhlIGNv
bmZpZyBmaWxlLg0KDQo+IEluIHBhcnRpY3VsYXIsIEkgdGhpbmsgdGhhdCB0aGUgcHJvcG9zZWQg
VUFQSXMgc2hvdWxkIGJlbG9uZyB0byBhIERQTEwNCj4gb2JqZWN0LiBUaGF0IG9iamVjdCBtdXN0
IGtub3cgYWJvdXQgdGhlIHBpbnMsIHNvIGhhdmUgaXQgZW51bWVyYXRlIHRoZW0uDQo+IFRoYXQg
b2JqZWN0IG5lZWRzIHRvIGtub3cgYWJvdXQgd2hpY2ggcGluL3MgdG8gdHJhY2ssIHNvIGNvbmZp
Z3VyZSBpdA0KPiB0aGVyZS4gVGhhdCBvYmplY3QgaGFzIHRoZSBzdGF0ZSwgc28gaGF2ZSBpdCBy
ZXBvcnQgaXQuIFJlYWxseSwgaXQgbG9va3MNCj4gYmFzaWNhbGx5IDE6MSB2cy4gdGhlIHByb3Bv
c2VkIEFQSSwgZXhjZXB0IHRoZSBvYmplY3Qgb3ZlciB3aGljaCB0aGUNCj4gVUFQSXMgc2hvdWxk
IGJlIGRlZmluZWQgaXMgYSBEUExMLCBub3QgYSBuZXRkZXYuDQoNClJDTEsgcGluIEFQSSBkb2Vz
IG5vdCBiZWxvbmcgdG8gdGhlIERQTEwgYW5kIG5ldmVyIHdpbGwuIFRoYXQgcGFydA0Kd2lsbCBh
bHdheXMgYmVsb25nIHRvIHRoZSBuZXRkZXYuDQo=
