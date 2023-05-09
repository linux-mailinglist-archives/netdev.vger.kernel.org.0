Return-Path: <netdev+bounces-1199-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F4DF6FC9DA
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:07:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38F2B2812FC
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AF3C17FFB;
	Tue,  9 May 2023 15:07:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3239C17FE2
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:07:51 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530AA3C3B
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683644869; x=1715180869;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Q3h09In6rsfm628YCHZo6vSAl5T3Dg3YYNgm0x2vLxA=;
  b=c5N6t3zlMTK6LJmWlFDhiwor46zUb4oySEmzaagecEIFhhPKczsw4PqJ
   W62z8IQNE+swpNfnvrcwtPvkJx7DVBQZ/eL9R4RR3bYtWNk/rQvQOr1bX
   1hkxqi2YFtnoNTJDUswPHPeCDPDmeHagB3tXVzBZlSgdsen/e3Dhn2yKp
   pFM0v0jgp4hv6Dbo8MxiFWw+KBihSY15VCbci3L8QeT0/8kXyU4eI65uE
   QuSaZuiCJEaR9LOkY1/Th3mr59pEd6fHfC1r2YrLbNHz3wk7ZxfFMpTiv
   CClev16FEluj7fqtOdfjdU4ggkcfvcHb8RYtQrO8OnA+DtCAEXCbSKSQv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="347416054"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="347416054"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 08:07:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="698937295"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="698937295"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 09 May 2023 08:07:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 08:07:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 08:07:48 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 08:07:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ccaqSi71kcu5ms6AGuZIw/Q07LDrWuYtW2kQsVD40H6ZNP5CumuQ2zaFEp+0Ead9EzxcWCHgJBRG93/tGq8yAN5fDCDo7HDCmwNSHI7F19EI80tCKL6e43/uNTuYzgyZA+Gx4gLt+AYedFxAfilf0fjKTDtmoFQfskFYd9pVYdE/nAn7aCEqUEvM68ZDyJSviXBavHwl4Jzu8JJbbEkuCl3PueN1swbSrVT9uQ9QzRXSLcttk+V5adrr/OFKJnaweezGYefaEsoS7n8OHiM5UYYndT14fXOPC6gQzE4QiXMffqJ9EqawpyMEBPj6OBY+4wAXhn3bU6lUANqcNuM2cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q3h09In6rsfm628YCHZo6vSAl5T3Dg3YYNgm0x2vLxA=;
 b=MT3+Uk9H2CYD/zVBxxO0S23597UvOQyfvPL9T6JGnhR2t03TmGPZmMu9+U+gP7wXFpZtZ0qre/vbthP7EfwExep2mr/DOUBE9YWn7nbLBY+2L5Thdp9lSibimuvU8Je3G/Acge1sQy4/WJ6oDnfF42xK+uXXLlakecEF8gE+PbtqqRX0r0z9nAoSITjUUl6LnfxySExFl19peBkKGlOtcJW2+TOExS0pOVSLdSJwTMlZ5ScQmez63Fn50XzulhFZuFzuYytkkTDRxgCU0c0PvD+Qtfq8wkEwnxEhIlTp523UhB+mrXtij5WbcXILaBWjS0S5lwvsqFWpbU61pELSDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by MW6PR11MB8392.namprd11.prod.outlook.com (2603:10b6:303:23a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Tue, 9 May
 2023 15:07:44 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 15:07:44 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Eric Dumazet <edumazet@google.com>
CC: Paolo Abeni <pabeni@redhat.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>, "Brandeburg,
 Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh"
	<suresh.srinivas@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>, "You,
 Lizhen" <lizhen.you@intel.com>, "eric.dumazet@gmail.com"
	<eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Shakeel Butt <shakeelb@google.com>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RtOMAgAAGxOCAAAwNMIAAEO+AgAAwgdA=
Date: Tue, 9 May 2023 15:07:44 +0000
Message-ID: <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
 <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
In-Reply-To: <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|MW6PR11MB8392:EE_
x-ms-office365-filtering-correlation-id: 3e0113d1-368d-4a62-d9cf-08db509f2464
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XEwLkrtOHRWVqlWG7tzL76J+7G2G9gU65oKynwbtT5uPWHObXOQOszCmy+mVmrd+Xwd9zM2qiR1urbEP7kBGgxVClyJ8mZFL23NgyggiaywDXAHf6z/nqUB2m03Jg4XvC6HcsEGNa0TKXnvIRbWaBH6CcZ/gfFdg/BM9O5OnyHysMFJ+dfNNOf9WC74qlN5YzQKjBjmvmonbZVFhaAjKBoTwLmM8UBD/BImArMsX4PNuQLdUWtADUCKiDcJ16WkLDpomCvT3f7hFSeGn+tQ8O8axKqtNVLhgyo5fne/AWPyw0CP3aeDLX3VJwpdvWPgTRyqA4Z/aFaVZ0linlorMVvLVt2aewaSWCGaZfunL71WWV7d9rxzP8MZToWFbsJDwXoR84tTeVluvQiDkwNBqiZD/TAsmnxwgEI4U4fPGfN975KgW6nwqQLV9nPHcXRODbi3KCFVal+G9CEBV6L53F5eb/inHtxrLPPpKNtFCrWrwv1HthmZuFOD/8jWf35QGg40tQzrEZOU9WULBp3UXd3ayj/hplmyQSZkKi4nZEBcttaI8Z7DZLf/914r92O0WE3rNUbnju5FriGA3OpWry5BlV8L316AHud6kXP6KpFDm9+jDAHzlzyF3DpvDfbEO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199021)(66946007)(76116006)(4326008)(66556008)(66446008)(6916009)(66476007)(64756008)(52536014)(8936002)(8676002)(5660300002)(6506007)(54906003)(26005)(53546011)(9686003)(478600001)(316002)(7696005)(41300700001)(71200400001)(2906002)(83380400001)(186003)(122000001)(82960400001)(55016003)(38070700005)(33656002)(86362001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ck1ldnBGNkoxNS9wclh2WEtrUGoyajhkc0RScDNiS3p4Z1FVYm1Pd0tkSTRL?=
 =?utf-8?B?cm4zRU5zb3ZmSHFBSGhDUzdGUVZMUDQ2ZUZVaUpzSFZWMVQzK2kxb3hWVzY3?=
 =?utf-8?B?bnlOZ2FJMkt0Zy9qbkxCWUZCVUNOTjBBRUJLUlhyT0ZmS3gxZVVjTlFQQ3R0?=
 =?utf-8?B?OTQ5YzV1Q05xNHEyNjErTW8wTm1PTEplVGpjVUpGajdKZmJ3QndNbG1jODEv?=
 =?utf-8?B?MGQ2SXFyUmZiSzlWZjVJbmNKQ3VSbnhPZjRucGhFcnd1VklES2ZNZkI1eEh2?=
 =?utf-8?B?MVRZbmlmcVltc2IwMDluOGNBQzY1YnhBdERKOHFYL2xxdTJlenJKSkdQQXhL?=
 =?utf-8?B?TktpV3lKbGdlNER0UnV1VG1ENlBHbHpxazdZL01DS2JvTGZEN044dFNIL05B?=
 =?utf-8?B?WmxtblpLa2VqUFUzY3pKNnh0UEU0T0owWk14K2FsRWE3STlWekNaOUF6Z2tn?=
 =?utf-8?B?UC9lRFJuOExkUDdxVG1xbEd3NGx1UXdjRndQeXV6WDM0cC96SkpVZmJsckJN?=
 =?utf-8?B?RUxhaTdBMENJYUhLUTFxL25TTUVOMmVIOVFudGk0c1ZRZm1OdFRHMW9iY0d6?=
 =?utf-8?B?RTMzeitLZWFRQUdGd2YxZG83ZXNOWWtweVZQaVhKazhwNkE2Nm9LNHhjbDZa?=
 =?utf-8?B?R3ZZRnFFdVNyYVJtY1FQcTUzN21heVd1dklmeDY3cTlmSUZFbGtDdTZPK1FF?=
 =?utf-8?B?RE9SdEVRdDRKWnhIeW1MVFRDYmpyR09pSy94bjRjamtjS0laS1FtdXF3MHNN?=
 =?utf-8?B?ejhxVHY4YVZBcnFOTkQrcjhCaTF1QUpkMURBTzdPNkRZR3ZwVGJKMlVQWi9p?=
 =?utf-8?B?bm5BNFNMKzFvb1BzU29DSWNlRHQvOU1wZEl3RWgvaUFvMHA2ZUVpVEZxRkpi?=
 =?utf-8?B?ai9ZblhjUkVDT0RQaWFlS3BWVGRMZ1pLSllXSjBMVVBocVNEamRIZzRtY0l0?=
 =?utf-8?B?MWtDZGxWckw3Z2JEQlJLSllubThUaklvMlZsR09ONjZlaDRDYUZtQjFISGVH?=
 =?utf-8?B?LzJXbnE2NnVQT09VTWJhb1c0djM0YkVndEY3ajNlSXVkaW9kam81TXdmK0Nk?=
 =?utf-8?B?NHBJOHcza0ZaY0JrcnQrcm5nUXorK0xiZ0dOM0toZEN3czd0TTdWT0NVbkpK?=
 =?utf-8?B?N0MrcnkrMHE3cWZ0Sm0zMUpMNjMzeDg0UFUzVmFxY0NDbWFzUktzTXpxM24y?=
 =?utf-8?B?OVN1alBmbnpUc3dRR251Y0ppdXdPUEpxV1VsTnR3aGtYYnlIaGNnaFA2dTZB?=
 =?utf-8?B?YU80TldXUUlmZ0poLzBISXM2Umhqd3JVU05DTlY0MXNkUk9ramxTZzUya0RG?=
 =?utf-8?B?Z1VmWG9VU0poa3FmWUo5RjNPNWJsb29tQnhTRGlZaDRtbG5ybXErZVpLWmlk?=
 =?utf-8?B?Z2Zva1AzenE1WHFST05JUkdjZndNbEFRZFNhS2s2NXVuRWZ6TjFQV2tTYlBm?=
 =?utf-8?B?Yk1GcTArS0pxOGJIUU81Z3VGS0Y4NElhaktZV3BiUU5vQ2NCeE91WDM5aHpo?=
 =?utf-8?B?TE5xWitFVnhjQmRPblA4b0F4a0FMSjRtbUhxdjV1TUlBVjlGRy9WUVJaQ2Q2?=
 =?utf-8?B?Vml1ZVF4ZDgxVTdPTm8yeHQ2bVRmVlZnOUYvSHJkVTVZaVo2djJzSzJ1MGIz?=
 =?utf-8?B?dXZuVFlZRjBROGE5OWI0TzlBRCt6bnRNWDdBVE5yenYvSGdlZDRXNVBuZHho?=
 =?utf-8?B?bFJ2TEEzRDhUSFhKNlliWTF0eUpWbExnOHNJSEpSbUhXMS9ZVzNrWUc5RVpU?=
 =?utf-8?B?Sm55OG5pNEFhQXM0UmdvT1pKN0h4UnhyNmNZV0NYZ0E3WmRoRHVaMXBMZm9P?=
 =?utf-8?B?UVNDVXlsdVk1NW03S2tRMDV2VHp6QnMvUk1hZmtZZ2ZyblJGNmZGMGFnNUda?=
 =?utf-8?B?eXo1NGFXRzNmVnRvZVlQNGQ5N0I2SGRNSWNtWU5qMXlyWGFDcjJHLzM4SXpx?=
 =?utf-8?B?bHhYcGhSRldrQzVlOC9hanB0QXlIUUJqOE9pdVQ0c2o3LzJSMzkrZVUzVy9F?=
 =?utf-8?B?VHdaUW9qbHVGZWVZalhwNVdJc2VQa2N2TjNvZVlZVHB1K3FVVjJXY213bDU3?=
 =?utf-8?B?Ykc3c2htZ3hwa2lYUktKVzE1SUxhYVRlNjBvaDRsNGliQVB0SG5ZRW1YbzMr?=
 =?utf-8?Q?UFrr9c9r6/iPjrvUEZkRIOvGO?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB7345.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e0113d1-368d-4a62-d9cf-08db509f2464
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 15:07:44.3427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dyFHTqbd5v0AUBrrvqrIeHXQb2tiQUKL/YJ1WX2jUoc2BF2NqfhZsZUPT8nOuHluYKUGS2IxEScFb7dPY3MyyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8392
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJpYyBEdW1hemV0IDxl
ZHVtYXpldEBnb29nbGUuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBNYXkgOSwgMjAyMyA3OjU5IFBN
DQo+IFRvOiBaaGFuZywgQ2F0aHkgPGNhdGh5LnpoYW5nQGludGVsLmNvbT4NCj4gQ2M6IFBhb2xv
IEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+IGt1YmFA
a2VybmVsLm9yZzsgQnJhbmRlYnVyZywgSmVzc2UgPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29t
PjsNCj4gU3Jpbml2YXMsIFN1cmVzaCA8c3VyZXNoLnNyaW5pdmFzQGludGVsLmNvbT47IENoZW4s
IFRpbSBDDQo+IDx0aW0uYy5jaGVuQGludGVsLmNvbT47IFlvdSwgTGl6aGVuIDxsaXpoZW4ueW91
QGludGVsLmNvbT47DQo+IGVyaWMuZHVtYXpldEBnbWFpbC5jb207IG5ldGRldkB2Z2VyLmtlcm5l
bC5vcmc7IFNoYWtlZWwgQnV0dA0KPiA8c2hha2VlbGJAZ29vZ2xlLmNvbT4NCj4gU3ViamVjdDog
UmU6IFtQQVRDSCBuZXQtbmV4dCAxLzJdIG5ldDogS2VlcCBzay0+c2tfZm9yd2FyZF9hbGxvYyBh
cyBhIHByb3Blcg0KPiBzaXplDQo+IA0KPiBPbiBUdWUsIE1heSA5LCAyMDIzIGF0IDE6MDHigK9Q
TSBaaGFuZywgQ2F0aHkgPGNhdGh5LnpoYW5nQGludGVsLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4g
Pg0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogWmhh
bmcsIENhdGh5DQo+ID4gPiBTZW50OiBUdWVzZGF5LCBNYXkgOSwgMjAyMyA2OjQwIFBNDQo+ID4g
PiBUbzogUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPjsgZWR1bWF6ZXRAZ29vZ2xlLmNv
bTsNCj4gPiA+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZw0KPiA+ID4gQ2M6
IEJyYW5kZWJ1cmcsIEplc3NlIDxqZXNzZS5icmFuZGVidXJnQGludGVsLmNvbT47IFNyaW5pdmFz
LCBTdXJlc2gNCj4gPiA+IDxzdXJlc2guc3Jpbml2YXNAaW50ZWwuY29tPjsgQ2hlbiwgVGltIEMg
PHRpbS5jLmNoZW5AaW50ZWwuY29tPjsNCj4gPiA+IFlvdSwgTGl6aGVuIDxMaXpoZW4uWW91QGlu
dGVsLmNvbT47IGVyaWMuZHVtYXpldEBnbWFpbC5jb207DQo+ID4gPiBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnDQo+ID4gPiBTdWJqZWN0OiBSRTogW1BBVENIIG5ldC1uZXh0IDEvMl0gbmV0OiBLZWVw
IHNrLT5za19mb3J3YXJkX2FsbG9jIGFzDQo+ID4gPiBhIHByb3BlciBzaXplDQo+ID4gPg0KPiA+
ID4NCj4gPiA+DQo+ID4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiA+IEZy
b206IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT4NCj4gPiA+ID4gU2VudDogVHVlc2Rh
eSwgTWF5IDksIDIwMjMgNTo1MSBQTQ0KPiA+ID4gPiBUbzogWmhhbmcsIENhdGh5IDxjYXRoeS56
aGFuZ0BpbnRlbC5jb20+OyBlZHVtYXpldEBnb29nbGUuY29tOw0KPiA+ID4gPiBkYXZlbUBkYXZl
bWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmcNCj4gPiA+ID4gQ2M6IEJyYW5kZWJ1cmcsIEplc3Nl
IDxqZXNzZS5icmFuZGVidXJnQGludGVsLmNvbT47IFNyaW5pdmFzLA0KPiA+ID4gPiBTdXJlc2gg
PHN1cmVzaC5zcmluaXZhc0BpbnRlbC5jb20+OyBDaGVuLCBUaW0gQw0KPiA+ID4gPiA8dGltLmMu
Y2hlbkBpbnRlbC5jb20+OyBZb3UsIExpemhlbiA8bGl6aGVuLnlvdUBpbnRlbC5jb20+Ow0KPiA+
ID4gPiBlcmljLmR1bWF6ZXRAZ21haWwuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+ID4g
PiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMS8yXSBuZXQ6IEtlZXAgc2stPnNrX2Zv
cndhcmRfYWxsb2MNCj4gPiA+ID4gYXMgYSBwcm9wZXIgc2l6ZQ0KPiA+ID4gPg0KPiA+ID4gPiBP
biBTdW4sIDIwMjMtMDUtMDcgYXQgMTk6MDggLTA3MDAsIENhdGh5IFpoYW5nIHdyb3RlOg0KPiA+
ID4gPiA+IEJlZm9yZSBjb21taXQgNDg5MGI2ODZmNDA4ICgibmV0OiBrZWVwIHNrLT5za19mb3J3
YXJkX2FsbG9jIGFzDQo+ID4gPiA+ID4gc21hbGwgYXMgcG9zc2libGUiKSwgZWFjaCBUQ1AgY2Fu
IGZvcndhcmQgYWxsb2NhdGUgdXAgdG8gMiBNQiBvZg0KPiA+ID4gPiA+IG1lbW9yeSBhbmQgdGNw
X21lbW9yeV9hbGxvY2F0ZWQgbWlnaHQgaGl0IHRjcCBtZW1vcnkgbGltaXRhdGlvbg0KPiBxdWl0
ZSBzb29uLg0KPiA+ID4gPiA+IFRvIHJlZHVjZSB0aGUgbWVtb3J5IHByZXNzdXJlLCB0aGF0IGNv
bW1pdCBrZWVwcw0KPiA+ID4gPiA+IHNrLT5za19mb3J3YXJkX2FsbG9jIGFzIHNtYWxsIGFzIHBv
c3NpYmxlLCB3aGljaCB3aWxsIGJlIGxlc3MNCj4gPiA+ID4gPiBzay0+dGhhbiAxDQo+ID4gPiA+
ID4gcGFnZSBzaXplIGlmIFNPX1JFU0VSVkVfTUVNIGlzIG5vdCBzcGVjaWZpZWQuDQo+ID4gPiA+
ID4NCj4gPiA+ID4gPiBIb3dldmVyLCB3aXRoIGNvbW1pdCA0ODkwYjY4NmY0MDggKCJuZXQ6IGtl
ZXANCj4gPiA+ID4gPiBzay0+c2tfZm9yd2FyZF9hbGxvYyBhcyBzbWFsbCBhcyBwb3NzaWJsZSIp
LCBtZW1jZyBjaGFyZ2UgaG90DQo+ID4gPiA+ID4gcGF0aHMgYXJlIG9ic2VydmVkIHdoaWxlIHN5
c3RlbSBpcyBzdHJlc3NlZCB3aXRoIGEgbGFyZ2UgYW1vdW50DQo+ID4gPiA+ID4gb2YgY29ubmVj
dGlvbnMuIFRoYXQgaXMgYmVjYXVzZQ0KPiA+ID4gPiA+IHNrLT5za19mb3J3YXJkX2FsbG9jIGlz
IHRvbyBzbWFsbCBhbmQgaXQncyBhbHdheXMgbGVzcyB0aGFuDQo+ID4gPiA+ID4gc2stPnRydWVz
aXplLCBuZXR3b3JrIGhhbmRsZXJzIGxpa2UgdGNwX3Jjdl9lc3RhYmxpc2hlZCgpIHNob3VsZA0K
PiA+ID4gPiA+IHNrLT5qdW1wIHRvDQo+ID4gPiA+ID4gc2xvdyBwYXRoIG1vcmUgZnJlcXVlbnRs
eSB0byBpbmNyZWFzZSBzay0+c2tfZm9yd2FyZF9hbGxvYy4gRWFjaA0KPiA+ID4gPiA+IG1lbW9y
eSBhbGxvY2F0aW9uIHdpbGwgdHJpZ2dlciBtZW1jZyBjaGFyZ2UsIHRoZW4gcGVyZiB0b3Agc2hv
d3MNCj4gPiA+ID4gPiB0aGUgZm9sbG93aW5nIGNvbnRlbnRpb24gcGF0aHMgb24gdGhlIGJ1c3kg
c3lzdGVtLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gICAgIDE2Ljc3JSAgW2tlcm5lbF0gICAgICAg
ICAgICBba10gcGFnZV9jb3VudGVyX3RyeV9jaGFyZ2UNCj4gPiA+ID4gPiAgICAgMTYuNTYlICBb
a2VybmVsXSAgICAgICAgICAgIFtrXSBwYWdlX2NvdW50ZXJfY2FuY2VsDQo+ID4gPiA+ID4gICAg
IDE1LjY1JSAgW2tlcm5lbF0gICAgICAgICAgICBba10gdHJ5X2NoYXJnZV9tZW1jZw0KPiA+ID4g
Pg0KPiA+ID4gPiBJJ20gZ3Vlc3NpbmcgeW91IGhpdCBtZW1jZyBsaW1pdHMgZnJlcXVlbnRseS4g
SSdtIHdvbmRlcmluZyBpZg0KPiA+ID4gPiBpdCdzIGp1c3QgYSBtYXR0ZXIgb2YgdHVuaW5nL3Jl
ZHVjaW5nIHRjcCBsaW1pdHMgaW4NCj4gL3Byb2Mvc3lzL25ldC9pcHY0L3RjcF9tZW0uDQo+ID4g
Pg0KPiA+ID4gSGkgUGFvbG8sDQo+ID4gPg0KPiA+ID4gRG8geW91IG1lYW4gaGl0dGluZyB0aGUg
bGltaXQgb2YgIi0tbWVtb3J5IiB3aGljaCBzZXQgd2hlbiBzdGFydA0KPiBjb250YWluZXI/DQo+
ID4gPiBJZiB0aGUgbWVtb3J5IG9wdGlvbiBpcyBub3Qgc3BlY2lmaWVkIHdoZW4gaW5pdCBhIGNv
bnRhaW5lciwgY2dyb3VwMg0KPiA+ID4gd2lsbCBjcmVhdGUgYSBtZW1jZyB3aXRob3V0IG1lbW9y
eSBsaW1pdGF0aW9uIG9uIHRoZSBzeXN0ZW0sIHJpZ2h0Pw0KPiA+ID4gV2UndmUgcnVuIHRlc3Qg
d2l0aG91dCB0aGlzIHNldHRpbmcsIGFuZCB0aGUgbWVtY2cgY2hhcmdlIGhvdCBwYXRocyBhbHNv
DQo+IGV4aXN0Lg0KPiA+ID4NCj4gPiA+IEl0IHNlZW1zIHRoYXQgL3Byb2Mvc3lzL25ldC9pcHY0
L3RjcF9bd3JdbWVtIGlzIG5vdCBhbGxvd2VkIHRvIGJlDQo+ID4gPiBjaGFuZ2VkIGJ5IGEgc2lt
cGxlIGVjaG8gd3JpdGluZywgYnV0IHJlcXVpcmVzIGEgY2hhbmdlIHRvDQo+ID4gPiAvZXRjL3N5
cy5jb25mLCBJJ20gbm90IHN1cmUgaWYgaXQgY291bGQgYmUgY2hhbmdlZCB3aXRob3V0IHN0b3Bw
aW5nDQo+ID4gPiB0aGUgcnVubmluZyBhcHBsaWNhdGlvbi4gIEFkZGl0aW9uYWxseSwgd2lsbCB0
aGlzIHR5cGUgb2YgY2hhbmdlDQo+ID4gPiBicmluZyBtb3JlIGRlZXBlciBhbmQgY29tcGxleCBp
bXBhY3Qgb2YgbmV0d29yayBzdGFjaywgY29tcGFyZWQgdG8NCj4gPiA+IHJlY2xhaW1fdGhyZXNo
b2xkIHdoaWNoIGlzIGFzc3VtZWQgdG8gbW9zdGx5IGFmZmVjdCBvZiB0aGUgbWVtb3J5DQo+ID4g
PiBhbGxvY2F0aW9uIHBhdGhzPyBDb25zaWRlcmluZyBhYm91dCB0aGlzLCBpdCdzIGRlY2lkZWQg
dG8gYWRkIHRoZQ0KPiByZWNsYWltX3RocmVzaG9sZCBkaXJlY3RseS4NCj4gPiA+DQo+ID4NCj4g
PiBCVFcsIHRoZXJlIGlzIGEgU0tfUkVDTEFJTV9USFJFU0hPTEQgaW4gc2tfbWVtX3VuY2hhcmdl
IHByZXZpb3VzbHksDQo+IHdlDQo+ID4gYWRkIGl0IGJhY2sgd2l0aCBhIHNtYWxsZXIgYnV0IHNl
bnNpYmxlIHNldHRpbmcuDQo+IA0KPiBUaGUgb25seSBzZW5zaWJsZSBzZXR0aW5nIGlzIGFzIGNs
b3NlIGFzIHBvc3NpYmxlIGZyb20gMCByZWFsbHkuDQo+IA0KPiBQZXItc29ja2V0IGNhY2hlcyBk
byBub3Qgc2NhbGUuDQo+IFN1cmUsIHRoZXkgbWFrZSBzb21lIGJlbmNobWFya3MgcmVhbGx5IGxv
b2sgbmljZS4NCg0KQmVuY2htYXJrIGFpbXMgdG8gaGVscCBnZXQgYmV0dGVyIHBlcmZvcm1hbmNl
IGluIHJlYWxpdHkgSSB0aGluayA6LSkNCg0KPiANCj4gU29tZXRoaW5nIG11c3QgYmUgd3Jvbmcg
aW4geW91ciBzZXR1cCwgYmVjYXVzZSB0aGUgb25seSBzbWFsbCBpc3N1ZSB0aGF0DQo+IHdhcyBu
b3RpY2VkIHdhcyB0aGUgbWVtY2cgb25lIHRoYXQgU2hha2VlbCBzb2x2ZWQgbGFzdCB5ZWFyLg0K
DQpBcyBtZW50aW9uZWQgaW4gY29tbWl0IGxvZywgdGhlIHRlc3QgaXMgdG8gY3JlYXRlIDggbWVt
Y2FjaGVkLW1lbXRpZXIgcGFpcnMNCm9uIHRoZSBzYW1lIGhvc3QsIHdoZW4gc2VydmVyIGFuZCBj
bGllbnQgb2YgdGhlIHNhbWUgcGFpciBjb25uZWN0IHRvIHRoZSBzYW1lDQpDUFUgc29ja2V0IGFu
ZCBzaGFyZSB0aGUgc2FtZSBDUFUgc2V0ICgyOCBDUFVzKSwgdGhlIG1lbWNnIG92ZXJoZWFkIGlz
DQpvYnZpb3VzbHkgaGlnaCBhcyBzaG93biBpbiBjb21taXQgbG9nLiBJZiB0aGV5IGFyZSBzZXQg
d2l0aCBkaWZmZXJlbnQgQ1BVIHNldCBmcm9tDQpzZXBhcmF0ZSBDUFUgc29ja2V0LCB0aGUgb3Zl
cmhlYWQgaXMgbm90IHNvIGhpZ2ggYnV0IHN0aWxsIG9ic2VydmVkLiAgSGVyZSBpcyB0aGUNCnNl
cnZlci9jbGllbnQgY29tbWFuZCBpbiBvdXIgdGVzdDoNCnNlcnZlcjoNCm1lbWNhY2hlZCAtcCAk
e3BvcnRfaX0gLXQgJHt0aHJlYWRzX2l9IC1jIDEwMjQwDQpjbGllbnQ6DQptZW10aWVyX2JlbmNo
bWFyayAtLXNlcnZlcj0ke21lbWNhY2hlZF9pZH0gLS1wb3J0PSR7cG9ydF9pfSBcDQotLXByb3Rv
Y29sPW1lbWNhY2hlX3RleHQgLS10ZXN0LXRpbWU9MjAgLS10aHJlYWRzPSR7dGhyZWFkc19pfSBc
DQotYyAxIC0tcGlwZWxpbmU9MTYgLS1yYXRpbz0xOjEwMCAtLXJ1bi1jb3VudD01DQoNClNvLCBp
cyB0aGVyZSBhbnl0aGluZyB3cm9uZyB5b3Ugc2VlPw0KDQo+IA0KPiBJZiB1bmRlciBwcmVzc3Vy
ZSwgdGhlbiBtZW1vcnkgYWxsb2NhdGlvbnMgYXJlIGdvaW5nIHRvIGJlIHNsb3cuDQo+IEhhdmlu
ZyBwZXItc29ja2V0IGNhY2hlcyBpcyBnb2luZyB0byBiZSB1bmZhaXIgdG8gc29ja2V0cyB3aXRo
IGVtcHR5IGNhY2hlcy4NCg0KWWVhaCwgaWYgdGhlIHN5c3RlbSBpcyB1bmRlciBwcmVzc3VyZSBh
bmQgZXZlbiByZWFjaGVzIHRvIE9PTSwgaXQgc2hvdWxkDQpyZWxlYXNlIG1lbW9yeSB0byBtYWtl
IHdvcmtsb2FkIGtlZXAgcnVubmluZy4gQnV0IGlmIHN5c3RlbSBpcyBub3Qgd2l0aA0KbWVtb3J5
IHByZXNzdXJlLCBiZXR0ZXIgcGVyZm9ybWFuY2Ugd2lsbCBiZSBjaGFzZWQuDQo=

