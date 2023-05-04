Return-Path: <netdev+bounces-269-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E2F6F6997
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 13:12:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5A031C210B8
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 11:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28554FBF3;
	Thu,  4 May 2023 11:12:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141ED10EC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 11:12:13 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B89C2D6D
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 04:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683198732; x=1714734732;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=idgNtiWPghKCRMCDWkvS4utXgTImSFRfXLdxPjGBpZQ=;
  b=GFoib3EDFKda1tOvQ06zgSMzx+EdFFoNLnJe2LDr4LomvbG54J2p2wxG
   u0jxm9piKPmx5Cfew5JUa6KjR+vqC22AqAUEekoY1aAuzDPL2kpcxxTDh
   3FtXYEp1zJ8PxZpzsJv/xzqRU6s+i7UkFEQNwbMikO9P4AxzE2nDmBQyh
   rXZm0qGtJBEjYng8WMgJz4bV1sK5e8VSfTUDF6gJYVw8HT6BDFRnDoto5
   xTAK5h3Qnno1R30BVl4jmBRnYblRoQ/Bxy7wm7OtKcTnK9xSr4/8RhNtW
   9RIjqEBCFeCLdLJqiMbkulkakhKcnkiDe2fBZgO/AVEx77QJ859IZnmqM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="338050031"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="338050031"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 04:12:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="808666094"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="808666094"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 04 May 2023 04:12:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 4 May 2023 04:12:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 4 May 2023 04:12:10 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 4 May 2023 04:12:10 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 4 May 2023 04:12:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=igjx0dYcnaeTz11tP4b1bezJ7N0DICOturCJ3pYDv8P1xoNQxN/GlL6kNEHf5dNad/Mpjd36kzcuJbs7XE8U/kVNKfm2Vm0h5dsKSrQtN37t4Knh/twXi+3gkfC2LYyCZQYn9SnlegbYuRa6o3eUc52BTBC3T61hEsoi4n0Kf2kxQo8s72/NyUwVUnz+SAlYkA7tIoSypWjsG9YISVDvtDmw79eXBbxwmB8teDK3MJuOnt0Z26D2z59VXu5vIPSN+TqfA3r2Mxn84AZCzrvbpk1iLgFo96wryC7mb3ie43MAMEx5+IwroQk7qTwL7wAmJBci/IwGyHrqknPZaC1AQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=idgNtiWPghKCRMCDWkvS4utXgTImSFRfXLdxPjGBpZQ=;
 b=MDNmsMfgfO4Tq8KM5iRm2d98IZpPgLwXbmxtiQoOhNpnTTY8hK3lDi15v2j38tz9mjQ2EmRaRud8eDXV0A0avA6PGFMoUuEoF3DEDZhZHoyPjxEZQEwy+VX7l3joXdmmtAYMxBPFtV6J7O3wJO2n71wxK8L/GJk5XkirzPph2Ubb16yq9p7HlyRHxDWDBHFbOJenMvpUtDcTGb2Tidvs7C0N30fteejTrNoAu4QtCTgmB2s8pLVHGl1JsZEZKyEXfw4VuftCFsnf7/ggkoRx3oIOWkFpGnjJTPNwj6nnjBXHm1hwoRX1EJeADzaTVXXXB26qX9uV5Gq4SMOkkvB/Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5611.namprd11.prod.outlook.com (2603:10b6:510:ed::9)
 by MW4PR11MB7055.namprd11.prod.outlook.com (2603:10b6:303:22b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 11:12:07 +0000
Received: from PH0PR11MB5611.namprd11.prod.outlook.com
 ([fe80::b74b:9743:5e32:116a]) by PH0PR11MB5611.namprd11.prod.outlook.com
 ([fe80::b74b:9743:5e32:116a%7]) with mapi id 15.20.6363.026; Thu, 4 May 2023
 11:12:07 +0000
From: "Staikov, Andrii" <andrii.staikov@intel.com>
To: Paolo Abeni <pabeni@redhat.com>, Richard Cochran
	<richardcochran@gmail.com>, Leon Romanovsky <leon@kernel.org>
CC: "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>,
	"edumazet@google.com" <edumazet@google.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "Mekala, SunithaX D" <sunithax.d.mekala@intel.com>
Subject: RE: [PATCH net 1/1] i40e: fix PTP pins verification
Thread-Topic: [PATCH net 1/1] i40e: fix PTP pins verification
Thread-Index: AQHZd5he3uXqDn664U+DL+Q3lxCa3K89L1QAgABuPQCAAVgnAIALDX3A
Date: Thu, 4 May 2023 11:12:07 +0000
Message-ID: <PH0PR11MB561175B08D0E299FD1A0C127856D9@PH0PR11MB5611.namprd11.prod.outlook.com>
References: <20230425170406.2522523-1-anthony.l.nguyen@intel.com>
	 <20230426071812.GK27649@unreal> <ZEksrgKGRAS0zbgO@hoboy.vegasvil.org>
 <f525d5b887888f6c00633d4187836da0fb31f2cf.camel@redhat.com>
In-Reply-To: <f525d5b887888f6c00633d4187836da0fb31f2cf.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5611:EE_|MW4PR11MB7055:EE_
x-ms-office365-filtering-correlation-id: 830c299d-712a-449d-c5f8-08db4c906611
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tSoGKjA6Drn131szsnDlnM2fH36wrgkt0T+N4lQAbzaLB3a2DfyrZroJYCrzVpCkNd/FgXlWU5wxglEs1M41QhVNvZV6y38QbBJGPl3yL/sxfVpLK6MNaNs4/jLQ5FpkII3TFxh6F3UTQEGMPCt1uiI9ufepBp1yScL/nyUyza4LiGXvmx/ZmNuEbuB/A7SWAFFsKayFb7ux2KfBhG7FdIBjnxxubF2okBnIrKNtCNkVMyARAgR4WLrwrg1Neq5+ma2b4PlcH2N5Xa4IxKFgA6luMfu/5sFIee5WzHOz2DcNFZ6npjRaLSgP/Gb6X11sOJEKZsoHqEec5QBf6uPZ2KElKkH/EblHM1mHe28JYlgpUhBmtNNCa2As99FJmHaWYiABqkmKpHmfoQdUXS7RHzzfYE6IQLhVfkNQoBLHfunyyiwuZFinFIuw5BW/v3NTQyqU4nRHRDKtJD7jnZ8Sj3Df9ksDMFlJJuMnCTLbMZQGCWeODWF77mt8B92rv5fMwDsccw9zf/OOTwkXheAbc4Rj6sAdvtBwy8qKE942qARSngZ8bifdR/qtEajhomfwHWs49YRtTA8UrKQ2tBMNzUVTdzPm7ZKD7V11NP43YUEpVA0KUAMkDjDo0quu5tgH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5611.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(346002)(39860400002)(396003)(136003)(451199021)(41300700001)(38070700005)(15650500001)(6506007)(9686003)(26005)(478600001)(71200400001)(4326008)(55016003)(86362001)(7696005)(33656002)(66556008)(66476007)(66446008)(64756008)(66946007)(76116006)(38100700002)(52536014)(107886003)(316002)(186003)(54906003)(110136005)(5660300002)(83380400001)(2906002)(82960400001)(122000001)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mm1rY2NHdGZJM2sxYjhsTmNwdkJZSmU1VEtPWGR1L0tYZU5SVDJ3R2pmNVcy?=
 =?utf-8?B?TnNueHhyVy80UFVSZDNRQzNvSmNXbFNxSHFQNHpnNEs0SlM3NmNWaTJqQ2xu?=
 =?utf-8?B?clFjNXNIejlUd205RXZiSGhCUHhZcmVsWk5ZZjhZL2I3MUJMellkM29mWGJQ?=
 =?utf-8?B?NnNjSFNLRVN5eVJRL1dtemU3ckd1cEM1OGxTZFdzWGlvVFVIMndNclVFUXJM?=
 =?utf-8?B?cU5ycGRQSVhtVjdTaitpdDdiOVhJclZtRUh3VzBIejJVb1ZRckYzVy8zSWNm?=
 =?utf-8?B?dDc2N1o2NjFGeUZxbW41UHp0K21YdUROdTNMSzUzZnlXNk8zSWt0Q0tFaWxx?=
 =?utf-8?B?azBoNXhXWGZHT1JyVS9Rc2hGUUNpZmJYYlZOaWh6K2NmNUNYdDc0eDVvM1lL?=
 =?utf-8?B?R2ovdjhUWUpSRmJ3ZkZwQURCaWwwZlIrb3NMZ1lGUjlMUzdEcTZqMFpHNVoy?=
 =?utf-8?B?SXVzNGVKQm1LY3NsMXlNeGt3a3J3c2N0TStLZUwzeFhKR2N3ZkJuTDBZSnU0?=
 =?utf-8?B?UThxcGJZRjBGUjBNWFJrL2tVOXZRRGFZK0lIOUNaeUtqS0NoNlkzTEp0cnFh?=
 =?utf-8?B?K1dIYldSQ25OcXRzRTBJWlVzVDVWaHdwVWl4bFFkVXhwMEF4NFpQS2JmZSt1?=
 =?utf-8?B?a2Z4Zi9RUWprMlV0RXpJb2xlTEh1NlFHYW9HWnFoRGpnTlZTNVgzUFoyRENh?=
 =?utf-8?B?d1ppMkxTWFVmcjdQRXY5YWsvYTFZN2VYWExsa0x4aTRQblZSNzZYM3VjdkJ5?=
 =?utf-8?B?QkRwY1lRZng4K2tCUUlMSlFzaE44anhPT0VzNVI0WWR6SFlVYkRYU3BDeUFi?=
 =?utf-8?B?TnNZWmFqL2hGS2pwNXNudmlEelU4V1U1YXVkcG9xdGxobENSbldwNE15dHRa?=
 =?utf-8?B?NW5LUjdNejhseEtnUmp4V3AwN1llK3hMQ2QrUU5vU25pbjd0WTg1VDA3K1Ey?=
 =?utf-8?B?ZGNucVA4d1hyOXZEUm1qNmkySlMyOFFhakNOcCtMOFJ5MXEwbE9QaHU1SDQr?=
 =?utf-8?B?UFptSEVUTVJ5MC9nRFBuL1lrSGxOUFp4OXdQZm5GVzV5TmFsSTBMNWUxUkFW?=
 =?utf-8?B?RXYzRHZ1MDJ4QklXYm0va3dHajZ2ZFF2dGZ3SGhKTWVlbXJLOUprK0hWMkJy?=
 =?utf-8?B?RTNHUXYyRW8vQnRxcG9TWVh4L1lVNS9WSFN2akFYNWFJekE1ZzR0VkxWVU5y?=
 =?utf-8?B?UlU4MElWMCtPdTAzR2Q3MEIyVjhQZGZzaTE0S09vTUtvL1RyUjFyM1NzU3ly?=
 =?utf-8?B?QlZ0V3N5Z3duUUhHSzNVeXNBNkZZZmp3bTFHSjUwUU10eDE3QkpFTzlkOTNl?=
 =?utf-8?B?eVhoSElnWlFFVkkrNUd0M25pSnFFWnVWaXJ6VmF5bXpRMkhQeEplTzd2S1g1?=
 =?utf-8?B?VVIzckQ2NXN1dnR6SHdubVVOYjJpZFNiTWxmTWN3VUJJS1V3WUNYaFVJaHgy?=
 =?utf-8?B?RjVjZ1dsbUo5b2UwZit0b1Z1b3NBTkVYd1A0UmxJMnhuK09OaXVBOVhHay9i?=
 =?utf-8?B?aEhBK2RqSGhBSW83TEI3RFJaTVdPc0k2NFZjTVRSdno5ZkJHV1pMSVE3T1ZX?=
 =?utf-8?B?OStHczM4YXJ2ZjBsdklwVTh5bktmK2V3L3JSWVBFNU1abzZjdmIvZGhWeURv?=
 =?utf-8?B?T2NiT2lWVjl6ZG9EV0plL3YxMUY5RE1SNGU5dHdZbUZhamhTM2VuNSt6VitZ?=
 =?utf-8?B?RzFWTXhxVGpDR2tvN1oyUE4yNlV6c3BhcE1KM1lXOXNqYWpBYVNZVmhtWUkv?=
 =?utf-8?B?RndXQ2Y1eThqZ1ZHNGxQbWFwQ1Z2RExxa0J3SUhYVlZVbXBNSE0rZko4elR3?=
 =?utf-8?B?NjhHTEdpczhTNDFpVzdmVHNHbjhZeE90L2lxQ2lUVEJiTmVpM2lqU1F3R0NI?=
 =?utf-8?B?bFVqdGhiaEM2Zm1KRDNHUU0ybk13MmUxdWUxaGJNYlV1bWVBaFdFcldtalNx?=
 =?utf-8?B?MzlKOTJlamcydExtcnZxK3Bna1dZb0k2N0dQc2lteVlCSlFGMFRBTm5jMmRt?=
 =?utf-8?B?UzAxSHN4c01aZ241S0hIMU9ueSt2cVRGekxzaDdhdVlLWnJOMVVJN3ZLV1R5?=
 =?utf-8?B?RUVMK2dzNzA0SDZheGp3NHFZamFka09idjNlQ0YyV3RxNTFOOG5nOW9FY3hU?=
 =?utf-8?Q?ZU5zrPNMtJ3vdZBb7inPdeR+h?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5611.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 830c299d-712a-449d-c5f8-08db4c906611
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2023 11:12:07.4450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pRF/9io1xlzrSKjnXWbTYiieOdk4MiI1QNkmzkDbrIN0qeoKrGblEAdPST0SOzmC2yj3xs1/CtUhUHLjb9lwPNLW1iOev1BSssa2Z8EVLds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7055
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQpIZWxsbyENCg0KPiA+IE9uIFdlZCwgQXByIDI2LCAyMDIzIGF0IDEwOjE4OjEyQU0gKzAzMDAs
IExlb24gUm9tYW5vdnNreSB3cm90ZToNCj4gPiA+IE9uIFR1ZSwgQXByIDI1LCAyMDIzIGF0IDEw
OjA0OjA2QU0gLTA3MDAsIFRvbnkgTmd1eWVuIHdyb3RlOg0KPiA+ID4gPiBGcm9tOiBBbmRyaWkg
U3RhaWtvdiBhbmRyaWkuc3RhaWtvdkBpbnRlbC5jb20NCj4gPiA+ID4gDQo+ID4gPiA+IEZpeCBQ
VFAgcGlucyB2ZXJpZmljYXRpb24gbm90IHRvIGNvbnRhaW4gdGFpbnRlZCBhcmd1bWVudHMuIEFz
IGEgbmV3IFBUUA0KPiA+ID4gPiBwaW5zIGNvbmZpZ3VyYXRpb24gaXMgcHJvdmlkZWQgYnkgYSB1
c2VyLCBpdCBtYXkgY29udGFpbiB0YWludGVkDQo+ID4gPiA+IGFyZ3VtZW50cyB0aGF0IGFyZSBv
dXQgb2YgYm91bmRzIGZvciB0aGUgbGlzdCBvZiBwb3NzaWJsZSB2YWx1ZXMgdGhhdCBjYW4NCj4g
PiA+ID4gbGVhZCB0byBhIHBvdGVudGlhbCBzZWN1cml0eSB0aHJlYXQuIENoYW5nZSBwaW4ncyBz
dGF0ZSBuYW1lIGZyb20gJ2ludmFsaWQnDQo+ID4gPiA+IHRvICdlbXB0eScgZm9yIG1vcmUgY2xh
cmlmaWNhdGlvbi4NCj4gPiA+IA0KPiA+ID4gQW5kIHdoeSBpc24ndCB0aGlzIGhhbmRsZWQgaW4g
dXBwZXIgbGF5ZXIgd2hpY2ggcmVzcG9uc2libGUgdG8gZ2V0DQo+ID4gPiB1c2VyIGlucHV0Pw0K
PiA+IA0KPiA+IEl0IGlzLg0KPiA+IA0KPiA+IGxvbmcgcHRwX2lvY3RsKHN0cnVjdCBwb3NpeF9j
bG9jayAqcGMsIHVuc2lnbmVkIGludCBjbWQsIHVuc2lnbmVkIGxvbmcgYXJnKQ0KPiA+IHsNCj4g
PiAgICAgICAgICAuLi4NCj4gPiANCj4gPiAgICAgICAgICBzd2l0Y2ggKGNtZCkgew0KPiA+IA0K
PiA+ICAgICAgICAgIGNhc2UgUFRQX1BJTl9TRVRGVU5DOg0KPiA+ICAgICAgICAgIGNhc2UgUFRQ
X1BJTl9TRVRGVU5DMjoNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGNvcHlfZnJv
bV91c2VyKCZwZCwgKHZvaWQgX191c2VyICopYXJnLCBzaXplb2YocGQpKSkgew0KPiA+ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZXJyID0gLUVGQVVMVDsNCj4gPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICAgICAg
ICAgICAgICAgICAgICAgICAgICB9DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgIC4uLg0K
PiA+IA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICBwaW5faW5kZXggPSBwZC5pbmRleDsN
Cj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHBpbl9pbmRleCA+PSBvcHMtPm5fcGlu
cykgew0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZXJyID0g
LUVJTlZBTDsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJy
ZWFrOw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICB9DQo+ID4gDQo+ID4gICAgICAgICAg
ICAgICAgICAgICAgICAgIC4uLg0KPiA+ICAgICAgICAgIH0NCj4gPiAgICAgICAgICAuLi4NCj4g
PiB9DQoNCkFjdHVhbGx5LCB0aGUgcHJvdmlkZWQgY29kZSBzbmlwcGV0IA0KaWYgKHBpbl9pbmRl
eCA+PSBvcHMtPm5fcGlucykgew0KICAgICAgICAgICAgICAgIGVyciA9IC1FSU5WQUw7DQogICAg
ICAgICAgICAgICAgYnJlYWs7DQp9DQpzaG93cyB0aGF0IHRoZSBjaGVjayBoYXBwZW5zIG9ubHkg
dG8gdGhlIG51bWJlciBvZiBwaW5zLCBidXQgbm90IHRoZWlyIHZhbHVlLg0KDQpUaGUgbGlzdCBv
ZiB0aGUgcG9zc2libGUgdmFsdWVzIGlzIGRlZmluZWQgaW4gdGhlIGk0MGVfcHRwX2dwaW9fcGlu
X3N0YXRlIGVudW06DQplbnVtIGk0MGVfcHRwX2dwaW9fcGluX3N0YXRlIHsNCiAgICAgICAgICAg
ICAgICBlbmQgPSAtMiwNCiAgICAgICAgICAgICAgICBpbnZhbGlkLA0KICAgICAgICAgICAgICAg
IG9mZiwNCiAgICAgICAgICAgICAgICBpbl9BLA0KICAgICAgICAgICAgICAgIGluX0IsDQogICAg
ICAgICAgICAgICAgb3V0X0EsDQogICAgICAgICAgICAgICAgb3V0X0IsDQp9Ow0KDQpEZXNwaXRl
IGhhdmluZyB0aGUgJ2ludmFsaWQnIHZhbHVlICh3aGljaCBJIGFsc28gY29uc2lkZXIgbm90IHRo
ZSBiZXN0IG5hbWluZyBhcyBpbiBmYWN0IGl0IG1lYW5zIGFuIGVtcHR5IHZhbHVlKSwgYWxsIHRo
ZSB2YWx1ZXMgYmVsbG93IHRoZSAnaW52YWxpZCcgYW5kIGFib3ZlIHRoZSAnb3V0X0InIGFyZSBp
bnZhbGlkLCBhbmQgc2luY2UgdGhleSBhcmUgcHJvdmlkZWQgYnkgYSB1c2VyLCBub3RoaW5nIGd1
YXJhbnRlZXMgdGhlbSB0byBiZSBpbiByYW5nZSBvZiB2YWxpZCB2YWx1ZXMuIEkgZG9uJ3Qgc2Vl
IHN1Y2ggY2hlY2sgYW5kIHN1Z2dlc3QgYWRkaW5nIGl0IGhlcmUuDQpCZXNpZGVzIHRoYXQgSSBz
dWdnZXN0IGNoYW5naW5nIG5hbWluZyBvZiAnaW52YWxpZCcgc3RhdGUgdG8gJ2VtcHR5JyBhcyB0
aGlzIGlzIGp1c3QgbXVjaCBsb2dpY2FsIHRvIG1lIGFzIGluIGZhY3QgdGhpcyBpcyB3aGF0IGl0
IGlzLiANCg0KPiANCj4gR2l2ZW4gdGhlIGFib3ZlLCBJIGRvbid0IHNlZSB3aHkvaG93IHRoaXMg
cGF0Y2ggaXMgbmVjZXNzYXJ5PyBAVG9ueSwNCj4gQEFuZHJpaTogY291bGQgeW91IHBsZWFzZSBn
aXZlIGEgYmV0dGVyL2xvbmdlciBkZXNjcmlwdGlvbiBvZiB0aGUgaXNzdWUNCj4gYWRkcmVzc2Vk
IGhlcmU/DQo+IA0KPiBUaGFua3MhDQo+IA0KPiBQYW9sbw0KDQpSZWdhcmRzLA0KU3RhaWtvdiBB
bmRyaWkNCg==

