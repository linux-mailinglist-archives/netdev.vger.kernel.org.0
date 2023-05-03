Return-Path: <netdev+bounces-120-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFC6E6F53D0
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:57:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 065D22812A1
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 08:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6714747F;
	Wed,  3 May 2023 08:57:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A6BED2
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 08:57:11 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F6C40E9;
	Wed,  3 May 2023 01:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683104228; x=1714640228;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3b3YkMPtP461oMR2idwdp4T9ya2KHMLoPunHzlQav7E=;
  b=T1AehmYI0RyPYHdzIQzOwbM1ehtnEiu2H/5Qt4RjklRBreOxbpxilgKk
   8kCFBLrNNaiezhu4iFuoGDki0+G/JXXq2ab9zBLXBMkYykbZpZu8fL2es
   xZaYTzb4nfM1klqKyETVzmkPrjyJNdT+IcN/IJmOdsHGKS0Qvkv0o5yUs
   2Xbv/mghy58uE/PcONGhqy6nQQB+4t7nzzWHNtysDdVrPASsudRqavVgA
   pFnrdU21X7oOYlzkvjELR1HRubWbgC5vLfQsj8nfBjocTCIYQRZ8BvUKG
   5mAp/i1rT7eNHAy+4a2wws8nHtyp1TJLnzfqZoMaHqH9ia70pSDUVnKQ2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10698"; a="328233803"
X-IronPort-AV: E=Sophos;i="5.99,246,1677571200"; 
   d="scan'208";a="328233803"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 01:57:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10698"; a="1026425957"
X-IronPort-AV: E=Sophos;i="5.99,246,1677571200"; 
   d="scan'208";a="1026425957"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 03 May 2023 01:57:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 01:57:07 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 01:57:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 01:57:07 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 01:57:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2a+3VMi0uMclIz3bpMMPK9bmmjn26x+aqyoJnoYK1zI08PfahhnJ55nDQ4vgNpSqoaEC6QfqSyFAtcYCn7O08yOeP2OCIryr3w6WKUu9cuFmFpmw0fw6BoRivmnbkvz77/Yf3kLpQJCWW4YONC///kUk9h96zFf3zFrF2fdXQccIxGaBUBj3Q6U83esWlLeixOPBs2Rx7cvM4JYEszE7sRXG6PSBJ905zZ+0pehasPS+tOKKkqBPrSSXu6dZWv1mVCk6sAh8ZkdXvgvIC/9ny8gD3LyP/29ryuEqMRoMTrnUHdx0jM0FVAaikAIxqIDjvcLuOsQl2cOKxk501JReA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F3DfNthQngLZh6C1T/6csyZdPccdEB/F2EuKiw2HnNA=;
 b=jDJ729VkRW+kPjBprA8fXRE/qPenbz0ax2F1ARTk0Et2DCDg40cTyhM8whc7CHhVbphpslC58GBZe53bK93rw6OH6s4ZtYj18eiBxnkhpqMTaOq2/QSctrXZKZb+wpd6CdFb+SCDBATQlcS2jt73Do6CBnYXTf/mfhYJHndgCroC5CipIzBVq8MK/VUp6Ns6XyKplw+c3RNCrCTod3DRQYF+WDcuEWEuJenVs8y2k7C06TDZ+OUFJ6WXrazHR1pWCTsOC8tRF9d/IS/DukgFDbjl4GPW+p3Drp5erb/8ySl3dITsSkyDG4hz7zYObM4WOHa0j7OwIq/D63JGNoSADA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3122.namprd11.prod.outlook.com (2603:10b6:208:75::32)
 by CY8PR11MB7898.namprd11.prod.outlook.com (2603:10b6:930:7b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Wed, 3 May
 2023 08:57:05 +0000
Received: from BL0PR11MB3122.namprd11.prod.outlook.com
 ([fe80::a4e7:9fa1:19f7:6a41]) by BL0PR11MB3122.namprd11.prod.outlook.com
 ([fe80::a4e7:9fa1:19f7:6a41%7]) with mapi id 15.20.6340.026; Wed, 3 May 2023
 08:57:05 +0000
From: "Pucha, HimasekharX Reddy" <himasekharx.reddy.pucha@intel.com>
To: "Rix, Tom" <trix@redhat.com>, "Brandeburg, Jesse"
	<jesse.brandeburg@intel.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] igb: Define igb_pm_ops conditionally on
 CONFIG_PM
Thread-Topic: [Intel-wired-lan] [PATCH] igb: Define igb_pm_ops conditionally
 on CONFIG_PM
Thread-Index: AQHZehEN7celIw7m6UydX9TN+8wQDK9IRUCg
Date: Wed, 3 May 2023 08:57:05 +0000
Message-ID: <BL0PR11MB3122EBD87EC2CC05F6DB2645BD6C9@BL0PR11MB3122.namprd11.prod.outlook.com>
References: <20230428200009.2224348-1-trix@redhat.com>
In-Reply-To: <20230428200009.2224348-1-trix@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3122:EE_|CY8PR11MB7898:EE_
x-ms-office365-filtering-correlation-id: a24d188e-e699-471d-85f1-08db4bb45e84
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m6QX0y9A/eUIUweOJ9WF+210/MIcCNOpZ41fx1upPDJkY4zCGAb8yLP+HIQrZVBzapQdnMwjlfEqARPXwy80c9vAYuwNgDYQookXgPWGeiZPtPOQc3Kk8Qf1VfqCZNiFeOTZfJo5MKv9r/6PJ+4iAHV6ub9nIhoys6hrPv1DZThkseJrueNfY49WLWXhUXHkA3oXVaJOphCtlfo8YZ6W3Zjp4fWbx4T+fGKtsnDFzzmy7m+Adv7mGsiobt+GbzuaBvQ+NzyYWcJg7LFAsIzUU7PjaIZICDmEsT0jyD63SBDbx+uoKEu/Un3+zkDhJY8oS7FAWnnJ5KcL1edqlkSwtKwfR+e+lmzOIA87lKPl/lsDiqT+pii7PgCjvhCmIp2htBy9FitYmpmUtSPPfwe+FZ/6D3QWmG5HfuiZr4hDiOS/amvCoFmLllo7mRMklDfcf/VYpkDSXrlIDLtMQmGTxVZoQvLcRokNAlGZBUBu4fO/1jSUpR81RqGS5qRtDImVaeaHM5oVGeCBi15vFGfSPq/9jsFjsN3S7o69Sta/IsoT+Q0RpNl5L5OCy489Pe3g5rCxkkoFrzysX8S7eSjn+s4s4VPLVUN70U5bT9PbzKDVzbYSwH6Qf0l9Lvv+6u7vte/ZatWeTACW05bvc2sTzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3122.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199021)(55016003)(8676002)(8936002)(9686003)(26005)(6506007)(53546011)(2906002)(4744005)(83380400001)(71200400001)(76116006)(4326008)(478600001)(7696005)(41300700001)(316002)(52536014)(5660300002)(186003)(66946007)(66556008)(66476007)(66446008)(64756008)(54906003)(110136005)(38070700005)(33656002)(86362001)(38100700002)(82960400001)(921005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zMR2+IzDPl+pLDCD78MlzQBRGmLKJMZJ3IsPYLrjqrQTnFq6iTnN5ZJxUtyY?=
 =?us-ascii?Q?SWyvYAyBERwV/3OfPFvmKX92BTM0L0CvIPWgHKvEA4x/oBl3w04VHJwwyFZq?=
 =?us-ascii?Q?DQupOEScyC37AkEHUC3YNjp2HAk4V1VvOfv9PTI+c+zYztaNZMBJp5g+14p7?=
 =?us-ascii?Q?tZUPgCbpkYu9YP8v9MEw44G/zRkTsRyysxp3eoqY2WV4eFU2H/qFMblp37G1?=
 =?us-ascii?Q?IUkv9O2JDNkwKy2LvyzkZD+FrwzkOoEPxQ+8E4sBTHMqzWXHBtrzEKC2TqZ4?=
 =?us-ascii?Q?ptKyWEzu8y7UF9dW7K4bK13h5IokuBGH/809BUQPeZQCbO0myK+nyqQrXv7P?=
 =?us-ascii?Q?DQD4biO+SdLvIQDKHHBHtnWV/fJWhiek1V7m5oP/q39YmM7+7L0+cZ9Cx08e?=
 =?us-ascii?Q?pnT0dnTu0tManj9hPumXygA0aoupmGQzN7HigMVR/WfqILzjtdjk1hay2w4r?=
 =?us-ascii?Q?qT22g2qkk1KJ+HxnBY9ZyeObzNmtjsCzenkIKho4HViHp2pf71aJeNCU/O/i?=
 =?us-ascii?Q?yAt6ZzPcGTg+NOvOYQX8b8YyYvtQ1nzFrCr3dkFNaW0lcws9PD52miKqLY4j?=
 =?us-ascii?Q?R7+QTTbb0CcjRZOSZD8MVTVPLzZSHj6dIbeDzvUY5SqXFRRHg77u7g58LmLP?=
 =?us-ascii?Q?j3o3SHXr8YVsopHb9sZvtUbloJz6JGy0t2S39LeXpNbKhJmS6FtaBT8iWxjM?=
 =?us-ascii?Q?fmTnDaBf0ytaXOf7LAyHRnatyVfdYXxIHw/RMtX84eZ1KBP4hTYLMhaTXSL1?=
 =?us-ascii?Q?uTJmcqyshkXmLFVc0xi1btSF/1FmADbOY0K5BmO743msDKkXES/3D280t7vU?=
 =?us-ascii?Q?Ix1WwziWu+Dl7s+GGIeI5chRH9XHics+paDEk44f386AU0mjLquOA0UXXUgP?=
 =?us-ascii?Q?X9R0nmjsU+tlbqvM7GGruZFJ1RDohg5iOgfIRAcGdHr746L1ZZkRytAwmLpn?=
 =?us-ascii?Q?wx9p6mLghcxkaiE5qKCBSdxsT7Cdj47efcKFHvRGPV4hwud9Y2VYGXuq/2ae?=
 =?us-ascii?Q?awsvwAk9mqRnhFbZIurQzZ9QRcV+nnongxfdlMLAABbci4t+Jf9DM5+PykNR?=
 =?us-ascii?Q?zPRFrUhQNdrHzV8zecyD19YdYjQAtxpvQvKmYGjy9jWvGZrC1g35M/cSNY6w?=
 =?us-ascii?Q?yxaWF836AsAfxm/HI/odwyGn/C41JTVp+RHCGEO4qPugoeS8xd1f86aKnOV7?=
 =?us-ascii?Q?iJOiAVEKhsh0HhtEz+q1ri4klOJEfkSTU3dvb9siTTWsnPLMugoo1+MJR7F2?=
 =?us-ascii?Q?3C9thdTfawOWDQT298TIk1oFM87NpMO3WPT5TjEu+D62jNRgtHxnJs3M2Qpc?=
 =?us-ascii?Q?Q8SWQOxB1JJcKoogigxw4zY6bmADLb5ZkOrt0YeYaDSv7GWFujGOuergo/Rs?=
 =?us-ascii?Q?4prcKtYET/+ZP7V7yMytoH6Yh9aURBgmqkm5cZ1ZDGY2msNTEofkCkf058Ca?=
 =?us-ascii?Q?wg9+1K7vidclsH4Aco6gJD3C9INNc8NNUN3jAOAsYkHUrgv7MIO/2p+PYhS5?=
 =?us-ascii?Q?C9fYlR4MKz6NQgPWULu6S0hL+kmFFGrq03XXCkYD6D0jLqEPEmHBFBAnv2qc?=
 =?us-ascii?Q?f2Pvib0O1X5t7dDhRkEyX4z2F2K2Fh3Vwxg7DpusT+tdrlYLRRqGimYBW6I8?=
 =?us-ascii?Q?aw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3122.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a24d188e-e699-471d-85f1-08db4bb45e84
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 08:57:05.4388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FxhfgrtC69lWmdszCo3DxiZLXrcZaJO3g8lZNH7JJVdo/Jcf3Hb8o/dEzZA3+RN94zRmexjgj245xqIOr7YPMnTJD8hWNBY7lsxg5masha3b/cY6bc+DK3CEJbq9jK8c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7898
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of R=
ix, Tom
> Sent: Saturday, April 29, 2023 1:30 AM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L <an=
thony.l.nguyen@intel.com>; davem@davemloft.net; edumazet@google.com; kuba@k=
ernel.org; pabeni@redhat.com
> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org; linux-kerne=
l@vger.kernel.org; Rix, Tom <trix@redhat.com>
> Subject: [Intel-wired-lan] [PATCH] igb: Define igb_pm_ops conditionally o=
n CONFIG_PM
>=20
> For s390, gcc with W=3D1 reports
> drivers/net/ethernet/intel/igb/igb_main.c:186:32: error:
>  'igb_pm_ops' defined but not used [-Werror=3Dunused-const-variable=3D]
>  186 | static const struct dev_pm_ops igb_pm_ops =3D {
>          |                                ^~~~~~~~~~
>
> The only use of igb_pm_ops is conditional on CONFIG_PM.
> The definition of igb_pm_ops should also be conditional on CONFIG_PM
>=20
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
> drivers/net/ethernet/intel/igb/igb_main.c | 2 ++
> 1 file changed, 2 insertions(+)
>

Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Co=
ntingent worker at Intel)

