Return-Path: <netdev+bounces-4901-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C284D70F199
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 10:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74CD91C20A0B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 08:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E704C2C2;
	Wed, 24 May 2023 08:58:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625C02573;
	Wed, 24 May 2023 08:58:33 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D421A1;
	Wed, 24 May 2023 01:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684918707; x=1716454707;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fS/ZgrTFZFGfvEc8noI1edySMCOq1fD5T0Rj/yxAzxk=;
  b=mQw/ZjeGEe7DT2r3KvCWP1cdeFbbMR7WlS3+zpIB4GE9HmrLT6Z+umiq
   0UIrQS72ME+OS9RtbMeL23O93IJAILFe4KO2aLZAdcbwfDTYZ42OL2zhn
   id4TIqcMcAb5XNv79stOsl7EilpvQey6VtRFNMGGBpqFn7lQOFvdjp9WU
   6zjMs4lQ0HKTonJi9/YycwC+VZBG64Eo43NinQQ3hqeneB2r4l8tsxB7g
   RwqvZmRkHgyHBD8LzcGzOTcj4Bisiw2XhXgrZAaLJD1otqeLYM7ro+/CP
   7oK3AbmTrv6DNjy6KC/bd8I+VlEFf41M1eRnPdZNV2hACUavHrqFg4i1z
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="439858048"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="439858048"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 01:56:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="878570762"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="878570762"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 24 May 2023 01:56:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 01:56:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 01:56:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 01:56:29 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 01:56:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Id7f2oo0iwiZKG9LgApgJVaurZWFw9S9axl3D82qop4hZwhVUMTtRtimPdQFjxzL68rbdqC52D69ANO2S+d5Jd9EbWmsAS4RU8XMpbkc3kiWYETr5YnHrRbtYrkNsRjSanuXofOYY6vA8pePTverw00soqAsLa7c8rC3V+TX0eIV5f0Vld9rhuakYzswhYUIpw1QOPvQHWq7ZOdd6W+lv7lxnFQeK0DjkU1ZnOo3MRbf08qCZiBik+1WLx/MpC2y9E9ONnk9z3Y66I28rymAxnxlx04Eftn+rttyIdGCN3PrpbBkGCWWniZyT8I3Ha4mc8Np2liEvcCmfMVEOPsE0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fS/ZgrTFZFGfvEc8noI1edySMCOq1fD5T0Rj/yxAzxk=;
 b=SE8i2cqPQCsKYXkWu26aepXWF9dgi8zg78eo4trW4MLvg+uFlQLH55JsN8mKulrHkpbcM4e24sdYyHoW3jXjani1BcKeixFjbWtt1/4RiTJop79a1yV8RCn374qoHeEDI67OvX1XRXu+LmdQMyosX0VTwx73gN7BpEZC8TqS6UNzB76Z6BSMk+bW0nhHxnEiQ3F5rGLx+inU8Qv10GMsa+1WsJAixX07B9dao46UbcV22R9vyzV9F8nMGjhfP0GnELeTBVF0X2/i0mUOLbblLZGcYjoCvMEh4bJ8JxtYNp+YU5AvSAGTq6eoBhp6ss3KMs+mTGiVPEvOx6oDeARiMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN7PR11MB6655.namprd11.prod.outlook.com (2603:10b6:806:26d::20)
 by PH7PR11MB7644.namprd11.prod.outlook.com (2603:10b6:510:26a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 08:56:22 +0000
Received: from SN7PR11MB6655.namprd11.prod.outlook.com
 ([fe80::81cd:9876:771e:24fe]) by SN7PR11MB6655.namprd11.prod.outlook.com
 ([fe80::81cd:9876:771e:24fe%7]) with mapi id 15.20.6411.025; Wed, 24 May 2023
 08:56:22 +0000
From: "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Stanislav Fomichev
	<sdf@google.com>
CC: "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>, bpf
	<bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
	<daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, "Network
 Development" <netdev@vger.kernel.org>, "Karlsson, Magnus"
	<magnus.karlsson@intel.com>, =?utf-8?B?QmrDtnJuIFTDtnBlbA==?=
	<bjorn@kernel.org>
Subject: RE: [PATCH bpf-next 01/21] xsk: prepare 'options' in xdp_desc for
 multi-buffer use
Thread-Topic: [PATCH bpf-next 01/21] xsk: prepare 'options' in xdp_desc for
 multi-buffer use
Thread-Index: AQHZibNpGqTOV8Ar6ESs4tPww21Nba9gaLUAgAFubACABDyo8A==
Date: Wed, 24 May 2023 08:56:21 +0000
Message-ID: <SN7PR11MB66554BA6BE57F4CBB407B88290419@SN7PR11MB6655.namprd11.prod.outlook.com>
References: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
 <20230518180545.159100-2-maciej.fijalkowski@intel.com>
 <ZGZ66D8x5Nbp2iYO@google.com>
 <CAADnVQJN6Wt2uiNu+wbmh-MPjxnYneA5gcRXF7Jg+3siACA9aA@mail.gmail.com>
In-Reply-To: <CAADnVQJN6Wt2uiNu+wbmh-MPjxnYneA5gcRXF7Jg+3siACA9aA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR11MB6655:EE_|PH7PR11MB7644:EE_
x-ms-office365-filtering-correlation-id: 00787fe4-eee6-437e-a42e-08db5c34bf2e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pEQ28QMxeUn63iwAQ6MxMkZoyOBRRSKthXPTanOMhK8ydsN8IFcRjSNhrM+mjI8uRKk1VtutXDqV2IL3ARoGe9Yf6o2/z5Ob6oVc4UdlMtwCAkkHXPIo4NHhhPLqbX15iy44DjBtRtxYtUtLPsbgEnScbDw9xDhuNF6YqBPfLD/GUkG9w6ezCAWb2rh0hbbAA1kJG7mWTnY1TK/QdszGLmEVzN/+lqLtf2n9iMnUNZWyIaHPvw9085zzm/vub3iKNZJggTb1POmPQRRiwWiUe6ka/Ha3Voz1QPyWQn1Cd1e02WMwX0P8R+9muKLx1zmpHTnylJF2iNRJXFP+Hm4HcJZDfjrJ4R6uA3fy4HTYqBVPd1Z9MdHAKyeDZjWOwnVIvA2KCV8L2eu8Xoyc0quBw1LzlCCwyjYRGT1f8o6GBi4vjvk+1NL6Shjj5KxBpvKOa1FEjKv6xslgZq0iyaPuo7EJX+yFQKaPCxF5ZCo8o1zW/uLvXV6if2nqx3SOfR3fclsyg1Rsp1rq3ztuQrz+jyCrSTT9B5/93UvSWenl5UtTcN79MyC+cx4OUbkGBwTvd6gcldQZ3s7OO2h+IOt034668zWQUUAehkb8mBFhxUUfHqXS0Yi/i8GulEtYU3XQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB6655.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(376002)(39860400002)(346002)(451199021)(54906003)(7696005)(41300700001)(478600001)(110136005)(71200400001)(316002)(76116006)(4326008)(64756008)(66946007)(66556008)(66476007)(66446008)(86362001)(5660300002)(52536014)(38070700005)(8676002)(8936002)(38100700002)(2906002)(26005)(122000001)(82960400001)(6506007)(33656002)(55016003)(9686003)(53546011)(83380400001)(186003)(66574015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eEJwY3pua1AycnB4dWtibW8rZ09HazVCZDNNVDRWdnhucVZZeG9lZGdJQ3hO?=
 =?utf-8?B?M251T3pYUmZWa2N2SzZOSkxMRzViYUFoVUVEVktjbVBSUXloelcrSjJiaC92?=
 =?utf-8?B?R1FxV1JQalcybGlJN3ZyNDNNQnhGYStpSTA0enFlVmxaaEFFN2VLdmw5OEhk?=
 =?utf-8?B?RnZ6MmtXRldmSzlQc0I3YTBJSFpQT1d6MXR3aCs0UWNjbGcyWFZoZHFBdzNY?=
 =?utf-8?B?RDR1ekgwd1h0OE4rdVd6M1pQSlBFaGE0V3FWRnBOdjZYUnlHd0d5TkNSeTN2?=
 =?utf-8?B?UG0vaGNxbVN0WjlxSmRGckZwemlwUUwxRGFrbDJORW85WEFWOHhOVzd4WlZy?=
 =?utf-8?B?dWN1SEZkODMwZnNkcU9LWk50aDhndDdUSDdtM2NHd2FUYlpxZHRiVGxOMFJ1?=
 =?utf-8?B?ZDdkaEU3eHpTa2FxUlVtL2RxeUZtc2toazEzT2JLVk9mdFpJUnJTQ0EyU0NU?=
 =?utf-8?B?YjBSU3YxOXBxS0pPbmtqVXBnNVNEaFhHa1VlL3VmZzVzclNHMFd2aHdUYnRO?=
 =?utf-8?B?R2ZsbUpocTRFcVA0ajdBNXdQZUowTXBzQTIzamQ1Y0lnendydVc2U05nNTAr?=
 =?utf-8?B?T1ZIZWJ0MmIvZ2hEcGFGVW8rRzFPSFVBTldKY2dXRGlVUW1iUkVHNk5NMCtu?=
 =?utf-8?B?SGs5QWVObDhKWGhJcnZxVzQzbms1MjJIbE14MDhBT29RYzFXdGZZRld4cGx6?=
 =?utf-8?B?L1JKd0F4TGJoZHp3S2hRU2hScElLZTYxU1h0YmpYTWVHbXN4WmdBZUp2RW9N?=
 =?utf-8?B?emI5dVRDcWlaK2E1Q0pNczVDK2Z3WGswaXB1eTFXa3B3WnpSKzZPQ0xDL0pP?=
 =?utf-8?B?Q3Y3SEFHZmN6NDh2QVlZdDRJSWdXWURTclJYemJHVTVVSGM0aEVhNmJ1UTBG?=
 =?utf-8?B?UjZBeTFldTFlRlYyYzFMdGZuMTNxam1pd3BpTjY2bUZCdE42OEhTT3NUK3M5?=
 =?utf-8?B?aWNZRGtsZ0xzNC9JM0w3NGtEdSt6L1NsZzFUdnVBMG1NYXIwTi9jSVpENDdO?=
 =?utf-8?B?RE1LRmxzMDhXRWxuYytQNURiaTdFeHowVDRaenpTT2xBS0pyLzlxVHcrNFcy?=
 =?utf-8?B?WVZHM1I2QnBLcWhVQnpEN3lBWVNQOG5vWm10UjM2ODd6VzEyNFFlMEE3Z3Vs?=
 =?utf-8?B?dmJGeUJadzVzZVRLVC9PZ3JiWlVwSGlIcFhzaFlnU05rY0lZaTVjWVEvcUxs?=
 =?utf-8?B?MnNyRVlSOFJvT1VWUEhSN2hzUDdRamNDbVB1RmE3Zlg1VjZ1c2VwMXUwb1oz?=
 =?utf-8?B?WnJVU3BwS2E4UnhyOWFIdGJzVmo5OXE1MlBXM0hFUCtYYXhPQ1RSVDliVnQ5?=
 =?utf-8?B?NnhTMGowTFoyWmcxNHVhUFpBM0JSZG50RWtqcUc4TE02Rzl6d0tEeElyMW1U?=
 =?utf-8?B?eElDRGxRQVdYTHFrSkE5QnJLcUtGME5uYWZ2ZmlTb29ENUtJN0tuaERNVUFW?=
 =?utf-8?B?R3RwWnhXSGIzeWVJN1JUMGNsVzNRVUU5b2dDcmFSVytER1VIM1djaVVObFJu?=
 =?utf-8?B?SVAvRmJMdXIyRDhKZ0JVbjdYWW1GTGUrN2cxbHVWT295WkRJYVZ4dkpWcGJa?=
 =?utf-8?B?TmRSKytKUk9VZjNXZkxKUzU5NHU5NHhvRlZWVTdmcUZTbHd3d0tsQ3VkS1Ji?=
 =?utf-8?B?ZHB0dnBWZWpyMFhBdERqREJGQUN5RTNRaUJuTStsMjZvNjJMdkVETi8xZ1F2?=
 =?utf-8?B?TVhLeWZ5bU5aeWx6QkFsR01kdUNyeEcvMnh3ZFRGaTNmZ0Q1NHBuMUNKajRP?=
 =?utf-8?B?a3VLMytYeFp0Wnd2QmY1RWlTZVhBNkh0NVhBWWRYVjAwbE5oSDA4OTNyYWJh?=
 =?utf-8?B?aUY5c20yMjFPR2pwWi9SMGtzL0RXY1NVa3ErWVBCRUg0c2FBMzJwNGRWTFlr?=
 =?utf-8?B?bXc5MUtiYVBoSHBjZzZwS0QxRFliNzgraHl1ZUZoKzlGWWRjTS9IM3BWQXo3?=
 =?utf-8?B?T095V0I0dDdlaGVOSWhjYTB1TnQ0NGdNOGtpU0x5em0wN2pCdTZXaEtsaWk1?=
 =?utf-8?B?VDhXMG5pSm96VEkrdDEwaGxkVnRhZkNCR1RpZGk3UjJwNE96ZnM1anpzOU96?=
 =?utf-8?B?c2tpZWdWZGlZLzZPYlpQcUR4VXN1aUtwZjJDWWxzbTRRWldENEQvRGUrTTdO?=
 =?utf-8?Q?kJA4/Kl13uZKqBAZwoCCTBNDk?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB6655.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00787fe4-eee6-437e-a42e-08db5c34bf2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 08:56:21.8382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JllzZk568/YkV3owUgYWs5cpq/N4Q8FKzvIXWVtliTtVSOplLUAvl6X/D1OI+M4tjz72RWBinPWL+50ImcxtT7oT7o/lf6zjDI4H/fgEJ8o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7644
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbGV4ZWkgU3Rhcm92b2l0b3Yg
PGFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgTWF5IDE5LCAy
MDIzIDEwOjQ0IFBNDQo+IFRvOiBTdGFuaXNsYXYgRm9taWNoZXYgPHNkZkBnb29nbGUuY29tPg0K
PiBDYzogRmlqYWxrb3dza2ksIE1hY2llaiA8bWFjaWVqLmZpamFsa293c2tpQGludGVsLmNvbT47
IGJwZg0KPiA8YnBmQHZnZXIua2VybmVsLm9yZz47IEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGtl
cm5lbC5vcmc+OyBEYW5pZWwNCj4gQm9ya21hbm4gPGRhbmllbEBpb2dlYXJib3gubmV0PjsgQW5k
cmlpIE5ha3J5aWtvIDxhbmRyaWlAa2VybmVsLm9yZz47DQo+IE5ldHdvcmsgRGV2ZWxvcG1lbnQg
PG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBLYXJsc3NvbiwgTWFnbnVzDQo+IDxtYWdudXMua2Fy
bHNzb25AaW50ZWwuY29tPjsgU2Fya2FyLCBUaXJ0aGVuZHUNCj4gPHRpcnRoZW5kdS5zYXJrYXJA
aW50ZWwuY29tPjsgQmrDtnJuIFTDtnBlbCA8Ympvcm5Aa2VybmVsLm9yZz4NCj4gU3ViamVjdDog
UmU6IFtQQVRDSCBicGYtbmV4dCAwMS8yMV0geHNrOiBwcmVwYXJlICdvcHRpb25zJyBpbiB4ZHBf
ZGVzYyBmb3INCj4gbXVsdGktYnVmZmVyIHVzZQ0KPiANCj4gT24gVGh1LCBNYXkgMTgsIDIwMjMg
YXQgMTI6MjLigK9QTSBTdGFuaXNsYXYgRm9taWNoZXYgPHNkZkBnb29nbGUuY29tPg0KPiB3cm90
ZToNCj4gPg0KPiA+IE9uIDA1LzE4LCBNYWNpZWogRmlqYWxrb3dza2kgd3JvdGU6DQo+ID4gPiBG
cm9tOiBUaXJ0aGVuZHUgU2Fya2FyIDx0aXJ0aGVuZHUuc2Fya2FyQGludGVsLmNvbT4NCj4gPiA+
DQo+ID4gPiBVc2UgdGhlICdvcHRpb25zJyBmaWVsZCBpbiB4ZHBfZGVzYyBhcyBhIHBhY2tldCBj
b250aW51aXR5IG1hcmtlci4gU2luY2UNCj4gPiA+ICdvcHRpb25zJyBmaWVsZCB3YXMgdW51c2Vk
IHRpbGwgbm93IGFuZCB3YXMgZXhwZWN0ZWQgdG8gYmUgc2V0IHRvIDAsIHRoZQ0KPiA+ID4gJ2Vv
cCcgZGVzY3JpcHRvciB3aWxsIGhhdmUgaXQgc2V0IHRvIDAsIHdoaWxlIHRoZSBub24tZW9wIGRl
c2NyaXB0b3JzDQo+ID4gPiB3aWxsIGhhdmUgdG8gc2V0IGl0IHRvIDEuIFRoaXMgZW5zdXJlcyBs
ZWdhY3kgYXBwbGljYXRpb25zIGNvbnRpbnVlIHRvDQo+ID4gPiB3b3JrIHdpdGhvdXQgbmVlZGlu
ZyBhbnkgY2hhbmdlIGZvciBzaW5nbGUtYnVmZmVyIHBhY2tldHMuDQo+ID4gPg0KPiA+ID4gQWRk
IGhlbHBlciBmdW5jdGlvbnMgYW5kIGV4dGVuZCB4c2txX3Byb2RfcmVzZXJ2ZV9kZXNjKCkgdG8g
dXNlIHRoZQ0KPiA+ID4gJ29wdGlvbnMnIGZpZWxkLg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYt
Ynk6IFRpcnRoZW5kdSBTYXJrYXIgPHRpcnRoZW5kdS5zYXJrYXJAaW50ZWwuY29tPg0KPiA+ID4g
LS0tDQo+ID4gPiAgaW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5oIHwgMTYgKysrKysrKysrKysr
KysrKw0KPiA+ID4gIG5ldC94ZHAveHNrLmMgICAgICAgICAgICAgICB8ICA4ICsrKystLS0tDQo+
ID4gPiAgbmV0L3hkcC94c2tfcXVldWUuaCAgICAgICAgIHwgMTIgKysrKysrKysrLS0tDQo+ID4g
PiAgMyBmaWxlcyBjaGFuZ2VkLCAyOSBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0KPiA+
ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvaWZfeGRwLmggYi9pbmNs
dWRlL3VhcGkvbGludXgvaWZfeGRwLmgNCj4gPiA+IGluZGV4IGE3OGE4MDk2ZjRjZS4uNGFjYzNh
OTQzMGYzIDEwMDY0NA0KPiA+ID4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5oDQo+
ID4gPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvaWZfeGRwLmgNCj4gPiA+IEBAIC0xMDgsNCAr
MTA4LDIwIEBAIHN0cnVjdCB4ZHBfZGVzYyB7DQo+ID4gPg0KPiA+ID4gIC8qIFVNRU0gZGVzY3Jp
cHRvciBpcyBfX3U2NCAqLw0KPiA+ID4NCj4gPiA+ICsvKiBGbGFnIGluZGljYXRpbmcgdGhhdCB0
aGUgcGFja2V0IGNvbnRpbnVlcyB3aXRoIHRoZSBidWZmZXIgcG9pbnRlZCBvdXQNCj4gYnkgdGhl
DQo+ID4gPiArICogbmV4dCBmcmFtZSBpbiB0aGUgcmluZy4gVGhlIGVuZCBvZiB0aGUgcGFja2V0
IGlzIHNpZ25hbGxlZCBieSBzZXR0aW5nDQo+IHRoaXMNCj4gPiA+ICsgKiBiaXQgdG8gemVyby4g
Rm9yIHNpbmdsZSBidWZmZXIgcGFja2V0cywgZXZlcnkgZGVzY3JpcHRvciBoYXMgJ29wdGlvbnMn
DQo+IHNldA0KPiA+ID4gKyAqIHRvIDAgYW5kIHRoaXMgbWFpbnRhaW5zIGJhY2t3YXJkIGNvbXBh
dGliaWxpdHkuDQo+ID4gPiArICovDQo+ID4gPiArI2RlZmluZSBYRFBfUEtUX0NPTlREICgxIDw8
IDApDQo+ID4gPiArDQo+ID4gPiArLyogTWF4aW11bSBudW1iZXIgb2YgZGVzY3JpcHRvcnMgc3Vw
cG9ydGVkIGFzIGZyYWdzIGZvciBhIHBhY2tldC4gU28NCj4gdGhlIHRvdGFsDQo+ID4gPiArICog
bnVtYmVyIG9mIGRlc2NyaXB0b3JzIHN1cHBvcnRlZCBmb3IgYSBwYWNrZXQgaXMNCj4gWFNLX0RF
U0NfTUFYX0ZSQUdTICsgMS4gVGhlDQo+ID4gPiArICogbWF4IGZyYWdzIHN1cHBvcnRlZCBieSBz
a2IgaXMgMTYgZm9yIHBhZ2Ugc2l6ZXMgZ3JlYXRlciB0aGFuIDRLIGFuZCAxNw0KPiBvcg0KPiA+
DQo+ID4gVGhpcyBpcyBub3cgYSBjb25maWcgb3B0aW9uIENPTkZJR19NQVhfU0tCX0ZSQUdTLiBD
YW4gd2UgdXNlIGl0DQo+ID4gZGlyZWN0bHk/DQo+IA0KPiBBbHNvIGl0IGRvZXNuJ3QgbG9vayBy
aWdodCB0byBleHBvc2Uga2VybmVsIGludGVybmFsIGNvbmZpZyBpbiB1YXBpDQo+IGVzcGVjaWFs
bHkgc2luY2UgWFNLX0RFU0NfTUFYX0ZSQUdTIGlzIG5vdCBndWFyYW50ZWVkIHRvIGJlIDE2Lg0K
DQpPaywgd2UgaGF2ZSBjb3VwbGUgb2Ygb3B0aW9ucyBoZXJlOg0KDQpPcHRpb24gMTrCoCBXZSB3
aWxsIGRlZmluZSBYU0tfREVTQ19NQVhfRlJBR1MgdG8gMTcgbm93LiBUaGlzIHdpbGwgZW5zdXJl
IEFGX1hEUA0KIGFwcGxpY2F0aW9ucyB3aWxsIHdvcmsgb24gYW55IHN5c3RlbSB3aXRob3V0IGFu
eSBjaGFuZ2Ugc2luY2UgdGhlIE1BWF9TS0JfRlJBR1MNCiBpcyBndWFyYW50ZWVkIHRvIGJlIGF0
IGxlYXN0IDE3Lg0KDQpPcHRpb24gMjogSW5zdGVhZCBvZiBkZWZpbmluZyBhIG5ldyBtYWNybywg
d2Ugc2F5IG1heCBmcmFncyBzdXBwb3J0ZWQgaXMgc2FtZSBhcw0KIE1BWF9TS0JfRlJBR1MgYXMg
Y29uZmlndXJlZCBpbiB5b3VyIHN5c3RlbS4gU28gdXNlIDE3IG9yIGxlc3MgZnJhZ3MgaWYgeW91
IHdhbnTCoA0KIHlvdXIgYXBwIHRvIHdvcmsgZXZlcnl3aGVyZSBidXQgeW91IGNhbiBnbyBsYXJn
ZXIgaWYgeW91IGNvbnRyb2wgdGhlIHN5c3RlbS4NCg0KQW55IHN1Z2dlc3Rpb25zID8NCg0KQWxz
byBBbGV4ZWkgY291bGQgeW91IHBsZWFzZSBjbGFyaWZ5IHdoYXQgeW91IG1lYW50IGJ5ICIuLiBz
aW5jZSBYU0tfREVTQ19NQVhfRlJBR1MNCiBpcyBub3QgZ3VhcmFudGVlZCB0byBiZSAxNi4iID8N
Cg==

