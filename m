Return-Path: <netdev+bounces-6958-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DAE17190AE
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 04:48:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D2EC281689
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 02:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01CE01C31;
	Thu,  1 Jun 2023 02:48:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68411108
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 02:48:09 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B59101;
	Wed, 31 May 2023 19:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685587688; x=1717123688;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tTJ1vvZADbL8vUVkExWcnitnFYjIscYcfqdFABJhLdM=;
  b=epapZFmjYn6sNqcIZEE09w5a/MsZZRWS3T7nEitxGPt/qOj3fa49Lm3+
   /WCWuKGf2flF/KwXKEgXE7eEBnECgRf4lEBMtI01W+7P9hHpiZL9fXm5i
   esd+hcLyjl5IvuHrzYqjnk7b8dlmdDnS/ePIEWMPUeCNcPH0jsq/I9P8C
   NI3MumFHrCU2qo6Lv8uaceIQQWWb3oyjX/hHJ6KH4cKhsUmLUREAfzeV+
   EAqjusUrcInXnHSc60kjxLndfpMUc8mBL4TaEot7AJ0Ckg8JIqVfUIQIw
   GJR88ey/VYkL+kogJllGaskVxIdBvXfMvn9gm8ENUJnQDEVMVynwkvNT5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="441790594"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="441790594"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 19:48:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="881442782"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="881442782"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 31 May 2023 19:48:07 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 19:48:06 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 31 May 2023 19:48:06 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 31 May 2023 19:48:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxAHBX7GIVAunhZg4RkCCT3XD7RrlMfunFICuVFduMYJOMPnbA8a6UzdPOnDJ8VeYJV1P91XWc/0rKM6sKT8EK9kkVYvQaN8Ytl742jNQm1ZVrLsNToh16uUsHAnuyQWp8gAQoy4O/gNZHl6lK2C1oulgmuLdrJuFgLJ5fFlv7hIKVG/bs/gnGQJZZjtIDQspiwhv47Dwp7bNmPj+zFKIBhWJGemuZ2gMSQ9XgfBkLjMXIM3nF+6gViMAardRtE+S7al0nVuzcnI4UVPbHZ+eoRYNA7bWgJZN+QNuEihkYOWlqtE6+1h+EYUmL25FLCzXeTkKsxfjD0m4oAu8udaQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5J8Q2KiQ547USiBfKGXTxWDzgoZ6pnGsod8ikWnEWeg=;
 b=CqofTOlQITI30d+wLhtrbHBN3rj51z36U4qRUwV18AqAG8+2E1meH/3mG3zuTkiQTc8SzeBBsIuEHyRaRWw41Fa8E3TA/Bpqvy6gz/wnku5MRA3QcTXdEMA8Ce1hJhDOijofjSSwT05vEMVslkp9nbHvZxln+FZDC8M4AwTvo0aI+dNx6NsbQpDVy/BdQJqJZ6JpoXMZb+NfTDjixRRK1GpMkxRI+LmzhFwbSf7Rg5xV9YbhdJ33COZLYxpBmRBrCN/CFcAdDRRk/dbfQRCMuVlCvzr/agr6u/MEUBgveqxs3f8n22HjRNgY6H+Cm+d5mmANeguGrIzAI092h9Jw/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by MW4PR11MB7056.namprd11.prod.outlook.com (2603:10b6:303:21a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Thu, 1 Jun
 2023 02:48:04 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%6]) with mapi id 15.20.6433.022; Thu, 1 Jun 2023
 02:48:04 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Shakeel Butt <shakeelb@google.com>, "Sang, Oliver" <oliver.sang@intel.com>
CC: "Yin, Fengwei" <fengwei.yin@intel.com>, "Tang, Feng"
	<feng.tang@intel.com>, Eric Dumazet <edumazet@google.com>, Linux MM
	<linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"kuba@kernel.org" <kuba@kernel.org>, "Brandeburg, Jesse"
	<jesse.brandeburg@intel.com>, "Srinivas, Suresh" <suresh.srinivas@intel.com>,
	"Chen, Tim C" <tim.c.chen@intel.com>, "You, Lizhen" <lizhen.you@intel.com>,
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "Li, Philip" <philip.li@intel.com>, "Liu, Yujie"
	<yujie.liu@intel.com>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Topic: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Thread-Index: AQHZgVHu7/SNtT9IvkyNelU1xcwWA69RtOMAgAAGxOCAAAwNMIAAEO+AgAAwgdCAAA4vgIAAB2YAgAEwMBCAABKHgIAAKNbwgAAVVACAABAwAIAAMNEAgABhfVCAAGbfEIAADugAgAATvZCAAM4SAIAAWFPwgAANFgCAAB1pgIAAB41ggADEcICAA9Lr8IAACR4AgAAk3qCAAOD6gIAApqKAgAJEjYCAFYB+AIAAuC4AgAB1rLA=
Date: Thu, 1 Jun 2023 02:48:04 +0000
Message-ID: <CH3PR11MB73454186CA28AE6ACCEA9674FC499@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com>
 <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com>
 <CH3PR11MB7345E9EAC5917338F1C357C0FC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod6txDQ9kOHrNFL64XiKxmbVHqMtWNiptUdGt9UuhQVLOQ@mail.gmail.com>
 <ZGMYz+08I62u+Yeu@xsang-OptiPlex-9020>
 <20230517162447.dztfzmx3hhetfs2q@google.com>
 <ZHcJUF4f9VcnyGVt@xsang-OptiPlex-9020>
 <20230531194520.qhvibyyaqg7vwi6s@google.com>
In-Reply-To: <20230531194520.qhvibyyaqg7vwi6s@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|MW4PR11MB7056:EE_
x-ms-office365-filtering-correlation-id: 9fd368a7-2d00-46f0-5f3f-08db624a9f83
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qgT8E4Z182ACZNP5/YGDERr4OJ4Vpu96zc0+vSaNbkQSy3p7q+yGHQshIOCcLv/gS/lyWBcEQN1sb3ZeVlx6vZeYczOlXnSShc2U/kODql/05i23pMnHnvYdhDNnjezuomAPIpEpZhajdO/XT9759bGbQc1GlVM2zAwHI8AVHyWDl3PPgyaCwtEdnWpf3oDtaBKjC0QqRLFhnGF0WrF5sO8nrIQKXOAbITlgIBKQkqbndRHblQnG6nbUJb7duUvbHjeoXVVbrkJ4xOPli2m5EZEsgW+0lTIJFcIXINY1DGxITs68dEO+p9mZaRwvf8ZR1sYid4GBALqyR2ldve8vN8NkEmVArVJizKald6KlcF4IUiAgOhbYVjhyMhsaOzcud/yZZBMjSOordXgk3AzjzYMiqFt8i1JAlMat6pzqu2EGz4EQD5bQHZBeCtcNTcqsQum08/GzZH8yzOomN0nmGyZShFANPm/AZzYja1cyZ9hZjI4pblDn0N/uc4xuRyv18a1oH/EcWowI8+/K/bBsGCVl7ULYXkDOE5KusoLZHi2bJWbkYnxBmq25GObuiV/FwRXs5+wcnlFkVBxAYX7kipzHBqrdQkJ4aoZfBlr93lsydEknmllqToJvQDf0GSXm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199021)(38100700002)(83380400001)(122000001)(86362001)(4326008)(6636002)(478600001)(76116006)(64756008)(66946007)(66446008)(66476007)(66556008)(2906002)(54906003)(110136005)(186003)(7696005)(53546011)(9686003)(6506007)(71200400001)(316002)(107886003)(82960400001)(52536014)(26005)(5660300002)(55016003)(8676002)(38070700005)(8936002)(33656002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3ErN1QNBX2fSRoypM/8sfmpk4UJH3GBAH0eFjdRqcF9lEZjQiVNyhwNvW94U?=
 =?us-ascii?Q?8IPvWKXNFlHhZL5c7xbZhDvqErnN0MZCvIjR+VZavzDDC+FRlaIFdtjmmV40?=
 =?us-ascii?Q?h1Zf9WYP9uqY8ZhnbpqQjejfq/HursInLKuRlmXPyLMsX31KU+M5f1YbTEm0?=
 =?us-ascii?Q?tg4jDdvOEGdKA9uRltO763S/oUPQc/6U4rXZzTdRZ8V7eaHe1PxwaFn4ek9G?=
 =?us-ascii?Q?sxmHMPf0kWHpLjVz/6kGHdw75mrwJmN38LmLBj0Y7MwscI57rH0+7miIXpro?=
 =?us-ascii?Q?iqXIlutd6IvW72Sn/H/+1N4U/ykUFTkR3cPo5rupn8uUjI2ISICMrdOzUndw?=
 =?us-ascii?Q?qlCQznP36Aid3Y+qw1NxIZPx4JhPT2n4L4zID4eG7TAiPLK04OkNspZ1zKF1?=
 =?us-ascii?Q?3cRzPDzVY6MGh3qW4f9gbwy42KueSaGk24/fsaom/s/YR474SKOOcZS+GhC5?=
 =?us-ascii?Q?5e4w6eDd1cnQHW/q22nTXmm1x8stoUU7eO6Wd25s/fyxB2CjXoSaWOlbdusB?=
 =?us-ascii?Q?Nke7uoy4xln+NNGQq71nF6ATxcyRzihFNidRrwc93k1+LtSXB5W73K2Kk9Te?=
 =?us-ascii?Q?p7We1gmGb6Dr8U/7h3Aj05mkjJg6fLnrXxAsVcbDQ6hRLVw7e92kPBl7Y5RZ?=
 =?us-ascii?Q?GmPt6lFMgwGJzWYU5YCpCERT8hZL8HX8nx1S82qHLUioBLL7CNmxDcGD821C?=
 =?us-ascii?Q?5VbjK53yigOtXOxmlF0/o2e1K03kOf5KhPSZBMJI+DIAGOxm6vQxyNGjY0Z/?=
 =?us-ascii?Q?yRJfifS9jns7jrYTkLrzr7trU+qqd5Fhj8JtD/68jz/ojc8O6vo3NebnEhnd?=
 =?us-ascii?Q?eUI+LUpZtHMUmyiHBzxzZ73/VoaWx9P99h+0SobT1XMJVTYNLsjcnS8SD7T4?=
 =?us-ascii?Q?8uhKK827f6EX3AqEl6KQJVXEGSuM+c5MDzpabf2C/PfRPbR14e8stMsy2UrA?=
 =?us-ascii?Q?/jUkwGsS7GlVqUYN30rasLYEqD4mHkW3YMk8hXDFeoeyc+3QNPgw5fCGPXGF?=
 =?us-ascii?Q?Q3ZwPJGPV7A8KpWIRnp+4FZ3djc7GFMqRhoVrt+EtKB69zmBMQNGW40VDG/T?=
 =?us-ascii?Q?rc3W2UfLgTTd6y3lcg9K/TyGWuNpnr2qBrMqWw4StIQLFnyzbyjnjSAFqBKv?=
 =?us-ascii?Q?KLnMPUYbz3O6syUGasRntmYBYYPkBDXEiqXd3Gn7I2LJjk3YJkHFY5MQxBu3?=
 =?us-ascii?Q?kG+fMh6YOgbW5GjFivfBrMmmWgAfLvM51LWJo4OiaL2jTvVFUY8dU8IW2Yan?=
 =?us-ascii?Q?AM9YIWTAKRVQELl9UeHzZH9rOa5tLyUspvsj87GFtromnPQAtma2veCIF/ZD?=
 =?us-ascii?Q?WhrSZEt2RTQGx3otU1qx+hgSoIOfQCdpM1O65jqsmV2CL+HzFgraiBSBW9TV?=
 =?us-ascii?Q?TjuH9ATN0nUQuDJH4iPCWFsf7ddh8GKYJc3ZVSpNq4VRBr13EfsPpDK3UMZo?=
 =?us-ascii?Q?P8lVRImLVkfPhnpZcfdSnrPGR3A2Rp3nzGOb7dPnbzIHwwvK2Fs5jLoTPwR+?=
 =?us-ascii?Q?v7U9GsOxpY6vXTha6uWcgcxxbYoW2nCrWL5AwJNjD5TzGWAM4hezwTHDtV3n?=
 =?us-ascii?Q?4V3IGytbTmptTuHYumtwIYoOLqMDocpp1WM4vGlG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB7345.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fd368a7-2d00-46f0-5f3f-08db624a9f83
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 02:48:04.5798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +5VmIaswvHnY7lpH0Lfu0sdPmCrMp/QomP0K41MiQGW5dMp1/XjY4ahTgaj59J/uEx+ZlTHMcmwaYe11Gc8hTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7056
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Shakeel Butt <shakeelb@google.com>
> Sent: Thursday, June 1, 2023 3:45 AM
> To: Sang, Oliver <oliver.sang@intel.com>
> Cc: Zhang, Cathy <cathy.zhang@intel.com>; Yin, Fengwei
> <fengwei.yin@intel.com>; Tang, Feng <feng.tang@intel.com>; Eric Dumazet
> <edumazet@google.com>; Linux MM <linux-mm@kvack.org>; Cgroups
> <cgroups@vger.kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> davem@davemloft.net; kuba@kernel.org; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Srinivas, Suresh
> <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> netdev@vger.kernel.org; Li, Philip <philip.li@intel.com>; Liu, Yujie
> <yujie.liu@intel.com>
> Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a pro=
per
> size
>=20
> Hi Oliver,
>=20
> On Wed, May 31, 2023 at 04:46:08PM +0800, Oliver Sang wrote:
> [...]
> >
> > we applied below patch upon v6.4-rc2, so far, we didn't spot out
> > performance impacts of it to other tests.
> >
> > but we found -7.6% regression of netperf.Throughput_Mbps
> >
>=20
> Thanks, this is what I was looking for. I will dig deeper and decide how =
to
> proceed (i.e. improve this patch or work on long term approach).

Hi Shakeel,
If I understand correctly, I think the long-term goal you mentioned is to
implement a per-memcg per-cpu cache or a percpu_counter solution, right?
A per-memcg per-cpu cache solution can avoid the uncharge overhead and
reduce charge overhead, while the percpu_counter solution can help avoid
the charge overhead ultimately. It seems both are necessary and complex.

The above is from memory side, regarding to our original proposal that is t=
o
tune the reclaim threshold from network side, Eric and you worry about that
it might re-introduce the OOM issue. I see the following two interfaces in
network stack, which indicate the memory usage status, so is it possible to
tune the reclaim threshold to smaller when enter memory pressure and set
it to 64K when leave memory pressure? How do you think?
        void                    (*enter_memory_pressure)(struct sock *sk);
        void                    (*leave_memory_pressure)(struct sock *sk);


