Return-Path: <netdev+bounces-8566-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5615B724936
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 18:33:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B83C281170
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 16:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5783030B7E;
	Tue,  6 Jun 2023 16:32:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4443B39238
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 16:32:17 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901A392
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686069135; x=1717605135;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=peEfvNnaTW0m31izuR6TIpLtwQh+L/tjZsmIlUp5VjA=;
  b=XeJ2gRQfjKDkD+YgLCFARvAcPXxRAyidT4ECSESj759fQQKtP5WrgU7x
   lt7hI0bblbaV6JiOLKtugfTUuS0WE1jHm7ZN71lG7G57ZrphNnp23FyIt
   MUg8zR/Ye+mwUXHRbXvfTll0AXFX64C2w3Cjhy9c1amIrAIdthsfaSxbw
   wvz7KmrtmsmRhFQp6by/aaeZcg2N2ZQVUOuP7ZuiK1ifCUjDRPn0KMdKv
   xYBWAZ8TG14enKDzD99XRIPj2vYSFp7H+MGwLCAx2Szr5Oyypzgkc7Ojs
   M64xlZAACqOFKRB1MzscmTaL5Nun+ckiSFmPzVzNBv87DYUXCTz9Qg1qq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="337088745"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="337088745"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 09:31:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="742234084"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="742234084"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 06 Jun 2023 09:31:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 09:31:53 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 09:31:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 09:31:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 09:31:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjxwSvHUOlFU7E4c7P2p2BhZU7ToVHGSWPYRY5qDgOXw+2MrHjKv9kizhyqPJWjWwSAP/R6/lWPsnYLDAwzUbxv4/bgUIx07+TyaywNU532mOx9ZpqzNAU6KZObWjqTqMigBsAqZleAdCv2Oi6YNHZyqCwHCKw1ESMON6JJH5tcX2GGGappbObgMN0Nu6ITILNGUGdPVWxMApPv7rGBDBv4dPjlOjn9FBz4bJPrh+cYmv8bLzFeOerU28tMZnMt7pxEKZkN5FDzXB7tfI+HMQefUlbStHmt/WYnMhp/GIhRO2f9uME2NyS9ftg1g0GYJzp6CIsEEormQSCh50JP/YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=peEfvNnaTW0m31izuR6TIpLtwQh+L/tjZsmIlUp5VjA=;
 b=higJIKTdr2aA6+yHXFO6oqc4sYX5kmZVcv1NGi1TFG4PRWmgL/ZO3LNvcemGaJlyG88ElEaef1K1D3NZW3bLexiIM1XMnNxNtE3S+/ebcGdFbjIJZBmGuGOMsg9ypCeZ+bUWfbZ/JTqM/mzMnU0Utegha4l6Q2NlFw6vbHvRXW7eJNADEtz2o5wvuWrQf8ZB5G7TfAP81hytdEfZeQyj9HcaoLtxLtIEyTkgGx6vP5qawWszaWbKHO/q9ckNY3DP82N53y3eI58y3CKVonvDVVVV9+7yowufDfpMXHAs4vW0TB3k2CNvaxhshEOAXMuH31zkQ9iVQPqPQdgi01/eiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by CY8PR11MB7874.namprd11.prod.outlook.com (2603:10b6:930:7c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 16:31:50 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5c8b:6d4d:5e21:f00f]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5c8b:6d4d:5e21:f00f%6]) with mapi id 15.20.6455.027; Tue, 6 Jun 2023
 16:31:50 +0000
From: "Ertman, David M" <david.m.ertman@intel.com>
To: Daniel Machon <daniel.machon@microchip.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Keller, Jacob E"
	<jacob.e.keller@intel.com>
Subject: RE: [PATCH net v2 01/10] ice: Correctly initialize queue context
 values
Thread-Topic: [PATCH net v2 01/10] ice: Correctly initialize queue context
 values
Thread-Index: AQHZmFXR7Cb8cVF780Wgoa7PLZTAXq9997fQ
Date: Tue, 6 Jun 2023 16:31:50 +0000
Message-ID: <MW5PR11MB5811309603F4AEE4C05B2640DD52A@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20230605182258.557933-1-david.m.ertman@intel.com>
 <20230605182258.557933-2-david.m.ertman@intel.com>
 <20230606090345.lhbfllkslip7zbta@DEN-LT-70577>
In-Reply-To: <20230606090345.lhbfllkslip7zbta@DEN-LT-70577>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR11MB5811:EE_|CY8PR11MB7874:EE_
x-ms-office365-filtering-correlation-id: 2c64f001-bb7b-44d6-8b8f-08db66ab877f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HXX52iDUcA84zAORO7ARkFXmISvAYaTdANMiYMlFZuiQ8mJmilL1iUrc2AcScXnGGNgLBb5fHMlf5lk6YQ+tlLxbwuurXg70HOyb+eoXI91WYqsMpTE3aZkZTV7nFTCB2gNWIUjcqxpFBQqEYB9WoQEiSrQL2AVDxFkxoXSHwwVeflAFgRGGRYu/96/tuax2IQme9+gt3nizEFucjRGOnpmoK94wN8p3xPtGvVkY7yQTHiu2yHzNA7+yNhVcfoCfeVQIxXWxBX9xuVsiWjrZj3ToQWMHqS2PlwY4SVL0qbwuIMWMeUGpm4zdWKranlJe4A4paIwqmz99rSUdpELFhaWGBgPuV/M9B87Pg3FbfzZRdDwmEf6L+I9E8WmCv4GKOjYNAw5a44rMP/jfASEDwXVHOEuJgde5mTt0M4391LQoI5I2+BP2SsBEaVzX8L3YJ3mGJ26Q9yuD6JV6wBx3iGNsqL/HTKSEjNgNbFWnTFeMBlOxMPEEyVrQUQUHzjqbjh8udS2fWyZvD8YRu6s+VAiPGRHCkL3khVnF7m/28a8mYYAGyp4pwLSPY6dAd0EG8aEbuVH9E4nlyfch6jqUmzqYxZfb6rxOXHe3oiAGB9Aw8xODlgGZXgEqJHtkWnRm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(39860400002)(136003)(366004)(451199021)(2906002)(54906003)(38070700005)(71200400001)(478600001)(33656002)(86362001)(52536014)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(55016003)(82960400001)(316002)(6916009)(66556008)(4326008)(64756008)(122000001)(66476007)(66946007)(76116006)(83380400001)(66446008)(6506007)(9686003)(26005)(53546011)(186003)(107886003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZHloVzJzT0IyZk9EcXYwK1ZnVTRhQ2tGNmZLS2dIZnZMNWxXSjJsV2NiVHdZ?=
 =?utf-8?B?ekFIeERyZlpXRW9yMWREZE1ENnJ5bkF1enJ6RnVFcU93RHB4NXJSeWUwN1gw?=
 =?utf-8?B?T3kzNGVjOEU4OE95UFlneTFZVDNIa1dMSHN1Y3FlRzFWcUdreGQ2VzhrdENF?=
 =?utf-8?B?M3pPdjFvNnZTUitvbkUvc1NQRVpqWmF6TGMzT0JHZmd2OTBwV3dpbjRGdjB0?=
 =?utf-8?B?andRRVV5M0xoanU3ZjNQcjJsUDhUbEE0MXYzNzVoY0E5SjRBN3RYa280aGYw?=
 =?utf-8?B?VHIwdFMzbmlyWU1iUEZQc1J4YTJmRlhvQmN3aE1hbjdOTmJ5K3p5QW9TRnZN?=
 =?utf-8?B?a21UVHd6T0xna3BlVVdhNy9lOUx6TGdrams5NG04QVUzZTVyUFNQMmVVYlBH?=
 =?utf-8?B?RWNzMjFzMW9Lc3F5TlFvL1hHVWVHYmx1NHp0Vzh6SENwbXFQOE5WSm5PYzdQ?=
 =?utf-8?B?RnFvL0pndEFGdnpnTGlGT0l2aGp6cnpUakJ3Z2xLNGNyNi9MbXd2c0l2aEJP?=
 =?utf-8?B?UmdxbHhnZ2xqUmJya2dTNUdlYnZOYXd4R2d4ZkpOWm12ZVp4RGt3UGFFSS9I?=
 =?utf-8?B?d0M4dkhDMlZyY3g0Uy82dUZoa0NmTlFSZnZwaUJoQlJLSmVSc0tYWUdIbmxY?=
 =?utf-8?B?Yi9aMXBFbjlCd3JQeUk3Nko4WjJzNGtZd1JyZnR4WU1BdUdYMmtXRUpJL3hF?=
 =?utf-8?B?YUdTelRXOTRuODZqcjMvZWRBTXltdGo3Yit2UUtVTDdTbWV5dmRkNTAxaHg2?=
 =?utf-8?B?OVk1SU5xS2RsL2dBb09PVmp0UW43WGtrVHRTUzNOL0JjQXJQLytwMEIwV0NV?=
 =?utf-8?B?d1c0ZVNJYXF6bStCK2ZkNVRxZExwUFVKZTlFOUZ6WWRZdUo3N0o2SFI2OW45?=
 =?utf-8?B?ZkxTRzd4aDJUajJESVZRS0xUMjU4aytHZUlhL3NQWDlzZ0dUOFBzWDV0cTRj?=
 =?utf-8?B?UzdxQkF0NHIzR0FHOStrd3N0Ym5UVlEvZlp6WlN6SFUyTm5vbXcyNmxLQTZK?=
 =?utf-8?B?YVVWd29UOTRoSXJkVlZvdUNydHlXK09CUWcwNEF0dFVnVEQxNExVQ2V4Mmhs?=
 =?utf-8?B?RXc1UnRVSng2cEFvMk03QXNDSis0Szh1NWx0ZElwa1l1WDZMYjliSVdMc2F2?=
 =?utf-8?B?aWhGWU4yRkxjWk15UkdKSjhlczVKamFEZk05L1VldHRqS09ja0ZhS1pseDRC?=
 =?utf-8?B?VjNneUo1MmtDZlllTGtSTFJadk1rRmwwc2dMOFdrampWNDJXM1VaUW1MbE92?=
 =?utf-8?B?Wlo0NU1ZNElhTDV6SXJsRE50d2ExSjJ2U2hSVzJqelFpcElWSUMyeVdJMjgz?=
 =?utf-8?B?RHZjUUE1aW1CNWkwandiTGVlQXNNSVVlc3BPdkJuR21ic2VpQytXVXpsMXNG?=
 =?utf-8?B?WXMwT3BoNkRYamhteElmSTgwN0FIYXkzaGZadHN1SGhHcmhLeEJMWUpGdm5s?=
 =?utf-8?B?UHA2Vmt3M09CS0ovRTVFRklUOUh0aFN3dHJvUlZzM1puOUo2aGNheWRsM2Na?=
 =?utf-8?B?VDAwMjFRbUJmNHFSNEpFZFYwVS9JN0o5TE44S05iUjJMbHR6SkNDTHlhRkVS?=
 =?utf-8?B?MmhBbXh2Q1BLOUNhS1pXeXJrRmtmeHAyNE83WTcxOTR4NVpxS1RPenJHMU9a?=
 =?utf-8?B?aWtuOWVaTEMvNzJvQkE0YnZ1SkhVbnErd2g3RFEvenFaWHU4ZnZSa0lSNlVw?=
 =?utf-8?B?S2JpUzNjZHduWlV0bFE0NnZ0M2QwTHF3b2Q0aHFkYTVRTUo4UjV5RVRZZXVL?=
 =?utf-8?B?dDFQcEFnV0htVSszMnZ1MXpFNDdtNlFxbXZ1L3U2WER2L1NpOGVYam9pNkpw?=
 =?utf-8?B?ZGxqYXI3YUZGeTlOekwvM013THpLZWNxZy9VRmpHcmcvT1hSQUVFQ2ZTTHll?=
 =?utf-8?B?bUhVaGFHUmk3ZkxUVE94Zk5hbzJIZUlTdVVmMWpFbEFQaFIzdmZxRy9IQ2s1?=
 =?utf-8?B?dWpsVWQwTW83dnpnS2tZYTNpMGw5Q2h4Q21BeWZhclkvODU5aEFGQ2YvWWds?=
 =?utf-8?B?Wms5Vy9FTThldmdIR3NrUWdKSy9MT1BhNkRpUEd6cmdtK2xyVWZoVE9TOHhI?=
 =?utf-8?B?TElwdFRGcktaLzNmcjlpeGxBZ0ZyWnN2aUkrMXN3Q1dDaEZpNG9qM1RicDlO?=
 =?utf-8?Q?ZtHvwE58OGmNlzsfl5xrXPtFb?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5811.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c64f001-bb7b-44d6-8b8f-08db66ab877f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 16:31:50.1570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G97hJjqC5hZMbO0YGb09DfoqLjSgUlyso49VRI6smeJRtEg6zsG5bhS6Zx7OEnLu2jHt7nN+k0d6zu+uHwbckVO96ua8XUcgYJPZrpBpvs4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7874
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYW5pZWwgTWFjaG9uIDxkYW5p
ZWwubWFjaG9uQG1pY3JvY2hpcC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIEp1bmUgNiwgMjAyMyAy
OjA0IEFNDQo+IFRvOiBFcnRtYW4sIERhdmlkIE0gPGRhdmlkLm0uZXJ0bWFuQGludGVsLmNvbT4N
Cj4gQ2M6IGludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnOyBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyBLZWxsZXIsIEphY29iIEUNCj4gPGphY29iLmUua2VsbGVyQGludGVsLmNvbT4NCj4g
U3ViamVjdDogUmU6IFtQQVRDSCBuZXQgdjIgMDEvMTBdIGljZTogQ29ycmVjdGx5IGluaXRpYWxp
emUgcXVldWUgY29udGV4dA0KPiB2YWx1ZXMNCj4gDQo+ID4gRnJvbTogSmFjb2IgS2VsbGVyIDxq
YWNvYi5lLmtlbGxlckBpbnRlbC5jb20+DQo+ID4NCj4gPiBUaGUgaWNlX2FsbG9jX2xhbl9xX2N0
eCBmdW5jdGlvbiBhbGxvY2F0ZXMgdGhlIHF1ZXVlIGNvbnRleHQgYXJyYXkgZm9yIGENCj4gPiBn
aXZlbiB0cmFmZmljIGNsYXNzLiBUaGlzIGZ1bmN0aW9uIHVzZXMgZGV2bV9rY2FsbG9jIHdoaWNo
IHdpbGwNCj4gPiB6ZXJvLWFsbG9jYXRlIHRoZSBzdHJ1Y3R1cmUuIFRodXMsIHByaW9yIHRvIGFu
eSBxdWV1ZSBiZWluZyBzZXR1cCBieQ0KPiA+IGljZV9lbmFfdnNpX3R4cSwgdGhlIHFfY3R4IHN0
cnVjdHVyZSB3aWxsIGhhdmUgYSBxX2hhbmRsZSBvZiAwIGFuZCBhIHFfdGVpZA0KPiA+IG9mIDAu
IFRoZXNlIGFyZSBwb3RlbnRpYWxseSB2YWxpZCB2YWx1ZXMuDQo+ID4NCj4gPiBNb2RpZnkgdGhl
IGljZV9hbGxvY19sYW5fcV9jdHggZnVuY3Rpb24gdG8gaW5pdGlhbGl6ZSBldmVyeSBtZW1iZXIg
b2YgdGhlDQo+ID4gcV9jdHggYXJyYXkgdG8gaGF2ZSBpbnZhbGlkIHZhbHVlcy4gTW9kaWZ5IGlj
ZV9kaXNfdnNpX3R4cSB0byBlbnN1cmUgdGhhdA0KPiA+IGl0IGFzc2lnbnMgcV90ZWlkIHRvIGFu
IGludmFsaWQgdmFsdWUgd2hlbiBpdCBhc3NpZ25zIHFfaGFuZGxlIHRvIHRoZQ0KPiA+IGludmFs
aWQgdmFsdWUgYXMgd2VsbC4NCj4gPg0KPiA+IFRoaXMgd2lsbCBhbGxvdyBvdGhlciBjb2RlIHRv
IGNoZWNrIHdoZXRoZXIgdGhlIHF1ZXVlIGNvbnRleHQgaXMgY3VycmVudGx5DQo+ID4gdmFsaWQg
YmVmb3JlIG9wZXJhdGluZyBvbiBpdC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEphY29iIEtl
bGxlciA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IERhdmUg
RXJ0bWFuIDxkYXZpZC5tLmVydG1hbkBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMv
bmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfY29tbW9uLmMgfCAgMSArDQo+ID4gIGRyaXZlcnMv
bmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2Vfc2NoZWQuYyAgfCAyMyArKysrKysrKysrKysrKysr
LS0tLS0NCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9u
cygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lj
ZS9pY2VfY29tbW9uLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2Nv
bW1vbi5jDQo+ID4gaW5kZXggYTlmMmU2YmZmODA2Li4yM2E5ZjE2OWJjNzEgMTAwNjQ0DQo+ID4g
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9jb21tb24uYw0KPiA+ICsr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfY29tbW9uLmMNCj4gPiBAQCAt
NDcwOCw2ICs0NzA4LDcgQEAgaWNlX2Rpc192c2lfdHhxKHN0cnVjdCBpY2VfcG9ydF9pbmZvICpw
aSwgdTE2DQo+IHZzaV9oYW5kbGUsIHU4IHRjLCB1OCBudW1fcXVldWVzLA0KPiA+ICAgICAgICAg
ICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICAgICAgICAgICAgICAgICBpY2VfZnJlZV9zY2hl
ZF9ub2RlKHBpLCBub2RlKTsNCj4gPiAgICAgICAgICAgICAgICAgcV9jdHgtPnFfaGFuZGxlID0g
SUNFX0lOVkFMX1FfSEFORExFOw0KPiA+ICsgICAgICAgICAgICAgICBxX2N0eC0+cV90ZWlkID0g
SUNFX0lOVkFMX1RFSUQ7DQo+ID4gICAgICAgICB9DQo+ID4gICAgICAgICBtdXRleF91bmxvY2so
JnBpLT5zY2hlZF9sb2NrKTsNCj4gPiAgICAgICAgIGtmcmVlKHFnX2xpc3QpOw0KPiA+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3NjaGVkLmMNCj4gYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3NjaGVkLmMNCj4gPiBpbmRleCA4MjRi
YWM1Y2UwMDMuLjBkYjllYjhmZDQwMiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9pbnRlbC9pY2UvaWNlX3NjaGVkLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9pY2UvaWNlX3NjaGVkLmMNCj4gPiBAQCAtNTcyLDE4ICs1NzIsMjQgQEAgaWNlX2Fs
bG9jX2xhbl9xX2N0eChzdHJ1Y3QgaWNlX2h3ICpodywgdTE2DQo+IHZzaV9oYW5kbGUsIHU4IHRj
LCB1MTYgbmV3X251bXFzKQ0KPiA+ICB7DQo+ID4gICAgICAgICBzdHJ1Y3QgaWNlX3ZzaV9jdHgg
KnZzaV9jdHg7DQo+ID4gICAgICAgICBzdHJ1Y3QgaWNlX3FfY3R4ICpxX2N0eDsNCj4gPiArICAg
ICAgIHUxNiBpZHg7DQo+ID4NCj4gPiAgICAgICAgIHZzaV9jdHggPSBpY2VfZ2V0X3ZzaV9jdHgo
aHcsIHZzaV9oYW5kbGUpOw0KPiA+ICAgICAgICAgaWYgKCF2c2lfY3R4KQ0KPiA+ICAgICAgICAg
ICAgICAgICByZXR1cm4gLUVJTlZBTDsNCj4gPiAgICAgICAgIC8qIGFsbG9jYXRlIExBTiBxdWV1
ZSBjb250ZXh0cyAqLw0KPiA+ICAgICAgICAgaWYgKCF2c2lfY3R4LT5sYW5fcV9jdHhbdGNdKSB7
DQo+ID4gLSAgICAgICAgICAgICAgIHZzaV9jdHgtPmxhbl9xX2N0eFt0Y10gPSBkZXZtX2tjYWxs
b2MoaWNlX2h3X3RvX2RldihodyksDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgbmV3X251bXFzLA0KPiA+IC0gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHNpemVvZigqcV9jdHgpLA0KPiA+
IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEdG
UF9LRVJORUwpOw0KPiA+IC0gICAgICAgICAgICAgICBpZiAoIXZzaV9jdHgtPmxhbl9xX2N0eFt0
Y10pDQo+ID4gKyAgICAgICAgICAgICAgIHFfY3R4ID0gZGV2bV9rY2FsbG9jKGljZV9od190b19k
ZXYoaHcpLCBuZXdfbnVtcXMsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHNpemVvZigqcV9jdHgpLCBHRlBfS0VSTkVMKTsNCj4gPiArICAgICAgICAgICAgICAgaWYg
KCFxX2N0eCkNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gLUVOT01FTTsNCj4g
PiArDQo+ID4gKyAgICAgICAgICAgICAgIGZvciAoaWR4ID0gMDsgaWR4IDwgbmV3X251bXFzOyBp
ZHgrKykgew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHFfY3R4W2lkeF0ucV9oYW5kbGUg
PSBJQ0VfSU5WQUxfUV9IQU5ETEU7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgcV9jdHhb
aWR4XS5xX3RlaWQgPSBJQ0VfSU5WQUxfVEVJRDsNCj4gPiArICAgICAgICAgICAgICAgfQ0KPiA+
ICsNCj4gPiArICAgICAgICAgICAgICAgdnNpX2N0eC0+bGFuX3FfY3R4W3RjXSA9IHFfY3R4Ow0K
PiA+ICAgICAgICAgICAgICAgICB2c2lfY3R4LT5udW1fbGFuX3FfZW50cmllc1t0Y10gPSBuZXdf
bnVtcXM7DQo+ID4gICAgICAgICAgICAgICAgIHJldHVybiAwOw0KPiA+ICAgICAgICAgfQ0KPiA+
IEBAIC01OTUsOSArNjAxLDE2IEBAIGljZV9hbGxvY19sYW5fcV9jdHgoc3RydWN0IGljZV9odyAq
aHcsIHUxNg0KPiB2c2lfaGFuZGxlLCB1OCB0YywgdTE2IG5ld19udW1xcykNCj4gPiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc2l6ZW9mKCpxX2N0eCksIEdGUF9LRVJORUwp
Ow0KPiA+ICAgICAgICAgICAgICAgICBpZiAoIXFfY3R4KQ0KPiA+ICAgICAgICAgICAgICAgICAg
ICAgICAgIHJldHVybiAtRU5PTUVNOw0KPiA+ICsNCj4gPiAgICAgICAgICAgICAgICAgbWVtY3B5
KHFfY3R4LCB2c2lfY3R4LT5sYW5fcV9jdHhbdGNdLA0KPiA+ICAgICAgICAgICAgICAgICAgICAg
ICAgcHJldl9udW0gKiBzaXplb2YoKnFfY3R4KSk7DQo+ID4gICAgICAgICAgICAgICAgIGRldm1f
a2ZyZWUoaWNlX2h3X3RvX2RldihodyksIHZzaV9jdHgtPmxhbl9xX2N0eFt0Y10pOw0KPiA+ICsN
Cj4gPiArICAgICAgICAgICAgICAgZm9yIChpZHggPSBwcmV2X251bTsgaWR4IDwgbmV3X251bXFz
OyBpZHgrKykgew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHFfY3R4W2lkeF0ucV9oYW5k
bGUgPSBJQ0VfSU5WQUxfUV9IQU5ETEU7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgcV9j
dHhbaWR4XS5xX3RlaWQgPSBJQ0VfSU5WQUxfVEVJRDsNCj4gPiArICAgICAgICAgICAgICAgfQ0K
PiA+ICsNCj4gPiAgICAgICAgICAgICAgICAgdnNpX2N0eC0+bGFuX3FfY3R4W3RjXSA9IHFfY3R4
Ow0KPiA+ICAgICAgICAgICAgICAgICB2c2lfY3R4LT5udW1fbGFuX3FfZW50cmllc1t0Y10gPSBu
ZXdfbnVtcXM7DQo+ID4gICAgICAgICB9DQo+ID4gLS0NCj4gPiAyLjQwLjENCj4gPg0KPiA+DQo+
IA0KPiBIaSBEYXZlLA0KPiANCj4gVGhpcyBkb2VzIG5vdCBhcHBseSB0byBteSBuZXQtbmV4dCB0
cmVlLCBidXQgSSBndWVzcyB0aGF0IGZhbGxzIHVuZGVyDQo+IHlvdXIgJ2ZhdC1maW5nZXJlZCcg
Y29tbWVudC4gSSBhbSBzdGlsbCBnb2luZyBhaGVhZCBhbmQgcmV2aWV3aW5nIHRoaXMNCj4gdmVy
c2lvbi4NCg0KVGhhbmtzIGZvciB0aGUgcmV2aWV3ISBBbmQgeWVzLCBpdCBmYWxscyB1bmRlciBm
YXQtZmluZ2VyZWQgY29tbW5ldCDimLkNCg0KPiANCj4gQXMgZm9yIHRoaXMgcGF0Y2g6DQo+IA0K
PiBSZXZpZXdlZC1ieTogRGFuaWVsIE1hY2hvbiA8ZGFuaWVsLm1hY2hvbkBtaWNyb2NoaXAuY29t
Pg0KDQo=

