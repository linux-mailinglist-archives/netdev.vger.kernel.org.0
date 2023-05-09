Return-Path: <netdev+bounces-1041-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B4B56FBFAF
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:56:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F01AE1C20B10
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 06:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A95A01C04;
	Tue,  9 May 2023 06:55:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9613B53AA
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 06:55:52 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FB94C31
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 23:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683615351; x=1715151351;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2Qj84Tf0M6XmCoI3ef07NxkCX3phqpOAu9iYwq5FIHE=;
  b=gvGfL2NzBmC0DUJOzIkr7ceHoXBuB/y8l0wRtcMMu6Qt4hYsxWhS9g7k
   jt9RN7FlsGPKNQ/vCbLJZCD5xxz8nODy/1Z2PBoeOD951vgou8QFrjbPB
   sDv9oZp+X0+0Pk/Ca23AOKugLR9ktROhX5VMTcxoeAfOgv6JYYsBk2bJT
   nye9eMzhvX2gG4gAMO24NfwHGWGQx3digdLArUlA7KgrhmSbN/AsVRj4W
   WxfC5EJdlZTaCsQa157RwqK8SYgATU7QLUyKUom6udJnlfa5yUee/E7q5
   bDtX8GqmsP9r9Zfzly5LX2GBqjbGa3WYcgfHFaMbR31Ke3S3J2K2HFt/D
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="334271306"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="334271306"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 23:55:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="873053433"
X-IronPort-AV: E=Sophos;i="5.99,261,1677571200"; 
   d="scan'208";a="873053433"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 08 May 2023 23:55:48 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 23:55:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 23:55:48 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 23:55:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 23:55:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGy8FxUs7e/u6W7FRb3DfIZ31tHBJLiUongl6PleQ4uR4iUAKNy4cFsmMhyQPkeaNMrpVZT4IjO4JxnDKTD1HS+4KZrV5hlTeFYqMerofhFRtfjzGgf0suclxOE39Kt6VVzMle9DOp7YJqzaOYCfzZKka0mk99keRpYzduNDU+hc0c8TOiQLFbneQ5inVuMwnlXA+I7KGKTKlZ3gDejYutUrqliTgswRGltDFYfKmnoMAiduphNzgB4pek4Cfuyuy5U9Ji/kuKtqOymeUiDZi86oIezVoun7YhQsyscRlCeG8nwc5NMNyD+eEDNbvVUALIMt5RBKwUJHq9VP//qGjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yq7SfhiKsOv64g+Re0ji0aid+aUQ/RYH4NFu0sNT3e4=;
 b=SVvQwZk1ghXxlQ6iQ/cQy3ar5VLDSjwKx0V6SuGrEcT30sgamOk9wh1yONSC0GK32Z2G3X8rhbLj4YQ54WSj8r81FjJDzn7tZ6oJVm9PaQGN84XanP2SeRaiGTZkqxYHCDJKAZd3bUV2OAggZtpDF1k/MBuImSHeMXbEnKz2jjkaUEZUjR1TboUNjWg5otHZJPikfY9+j21dbL0OnE5QsOyxvOWuBHuvLWjtp380+5I9ESalZ8EF6lUX7cA8QnRIAkGlOQ4OLT2EDtAoogc4OGqRKXKKhuuCi8zeZVkIVLFPBAn1hKWfMCU4Ep1uZOdlFYwaR4JSpDyMhlsapgC9Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB7345.namprd11.prod.outlook.com (2603:10b6:610:14a::9)
 by MN2PR11MB4565.namprd11.prod.outlook.com (2603:10b6:208:26a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Tue, 9 May
 2023 06:55:43 +0000
Received: from CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039]) by CH3PR11MB7345.namprd11.prod.outlook.com
 ([fe80::242e:f580:7242:f039%5]) with mapi id 15.20.6363.033; Tue, 9 May 2023
 06:55:43 +0000
From: "Zhang, Cathy" <cathy.zhang@intel.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "edumazet@google.com" <edumazet@google.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "pabeni@redhat.com" <pabeni@redhat.com>, "Brandeburg,
 Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh"
	<suresh.srinivas@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>, "You,
 Lizhen" <lizhen.you@intel.com>, "eric.dumazet@gmail.com"
	<eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 2/2] net: Add sysctl_reclaim_threshold
Thread-Topic: [PATCH net-next 2/2] net: Add sysctl_reclaim_threshold
Thread-Index: AQHZgVH5thzFeGneZ0+Siv0/3mA4Uq9RMr+AgABQOXA=
Date: Tue, 9 May 2023 06:55:43 +0000
Message-ID: <CH3PR11MB734543D8CB6BBD53B84591AFFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
	<20230508020801.10702-3-cathy.zhang@intel.com>
 <20230508190515.60f090c7@kernel.org>
In-Reply-To: <20230508190515.60f090c7@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB7345:EE_|MN2PR11MB4565:EE_
x-ms-office365-filtering-correlation-id: 7157fb2d-2a32-431a-fcbc-08db505a6868
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 445N5kpuIr3x1m9G5/QzFX3mI1nytAf3jI1/Q2hj1LcPlrBxVB4yjnJtAzhgyqBPXnSMk4CC5+J7/Ju8GDmY0JbEKEDOLQWrb1pJO4DUD8LFyl8uJfh2rKCZ4doADAuVPnVK3OwNc45Knvc1UJxIKK3RRF2f0nuipper+ZxrXz6aHmHIFW0BPMIF6u+ODmXrX95Kqmv/vcjwbe/BhJfgrsdTAOeMUzg+gmfo6OQa4KCm+fA1LoAllZaPKr6cGeFSPZcGl7F0yljQi6EMKTagCEsXJP7Xbtk2WY4WfYDKw6Jw7hTLaH6fs5K2IVFR6yiGVs8gG0r2oHk1podos/+X/+IcGLHtVfatmlBneOAenOJAQqmvLAhG4z3ToxOSxpKDy9EViu1FU1ogZRuKNq+VZugRUAjYOz0zTjf5p3hAw696f12QI6VO74S28yQHYNNq6zT1iH3CSy/DyoCc7cBk0nMVVOtDjXSRJGQbb+Ad8Le7Raka/Hg4aNJv2fEcHuTpqEzjHKW2VzqHpZBZ8LGXD5MMxumWrQ6rDiwF+P9Jv9JcKXLsnD4td21rNNNkLWetSK/zZlsFZjdUowGkFl9VSuXmkco3zK79Pqxun5n5Sw3BjwNIKZ3Py4oSt9sPej0T
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB7345.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199021)(38100700002)(122000001)(86362001)(5660300002)(83380400001)(82960400001)(9686003)(38070700005)(6506007)(53546011)(186003)(26005)(54906003)(478600001)(7696005)(71200400001)(76116006)(64756008)(4326008)(66476007)(66556008)(66946007)(66446008)(316002)(6916009)(52536014)(55016003)(41300700001)(8936002)(8676002)(2906002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YjfIA90G+IT0W227bo+uAo4xHdwde/Wk+fVG+f1bCcfRJ9dRCS0cclgpZyAa?=
 =?us-ascii?Q?/488jEiHiyvGpj8d9gq5qsophpZqKydU+BU1ZpNWU7lqIxU/0/cXtPZYRQR0?=
 =?us-ascii?Q?KuHMEhN/dtnmZtsucV4fQos27KKMwoW8Nsl4LGE/revM7q1MS02lxDaJUamb?=
 =?us-ascii?Q?jE8yh6nsDVmH3UUPnzoQuvYhJ4rHGROnAkf/At8Y1m96rOj7rO2jxBEmietF?=
 =?us-ascii?Q?PVS3+/CRM59j7ns3s+b08u6G9sckjzNvrvVEYU2lPZ5ZqtBz8UNLV2WM5bk6?=
 =?us-ascii?Q?xJQXlc5PSv6yV0nlWXLEb+d1Vqt+33V2flh/JrJzJiWqGBPcIhP9TNyNsnk4?=
 =?us-ascii?Q?dcwzt/5iybdWBmGPpyOMl2zJWPRbuWaD+XvJ+xjI7A+GTGRWblrJikwH1+Ta?=
 =?us-ascii?Q?SYewxKAgxxT2sBarQn0+JrtXBNYdgb85A1KCqa3NeOhgFLqhqc9JGms7kmcf?=
 =?us-ascii?Q?/qSWi0bB0YLvhXy/0s9f48ZdzSx1w1hznSoobHt2W6HFEXXqCjfRi+2iTKMk?=
 =?us-ascii?Q?CzmEcxU3mLrkop6dBbsGTWGqb5RMBbU2Cbt8XyrizYVlW6ZjGSbIgpDH7dE1?=
 =?us-ascii?Q?745Awg5KCf4C2aL2ZanmwnKE8lJR+QETZTIKHFm2A9wQFXvINfl7RFFwPn4L?=
 =?us-ascii?Q?HhVGalXF8HUuBISwOIwnAJzXOohh0RkYZK10/mQXAIFO3gmDsiAZD3u8+lt0?=
 =?us-ascii?Q?DpLsM9rR2YM/J/hNq/Uest1fucIcBZ2H0baS1+I/HY6ns+Yi/Y0qnJ9nzpo1?=
 =?us-ascii?Q?hz/RXZkG9Lik1AUScwuiMrOnH7WEHWa1Z/7He/nwxwSpCEWzl5I7TS657CEy?=
 =?us-ascii?Q?j2XLJKBZsVmgxOHW0qOBsSi+2+7oUl5JMVmNyKcywt9nMcnrhhHCn7t9RJF3?=
 =?us-ascii?Q?c3wKS3Dllo1PizV8WvAnEeiIf2Qr6E2gtqDgTH7YfkXcwYlJEs84nXc7wDd+?=
 =?us-ascii?Q?1tVWFmsOItrXIPqP9KGoJNm7qEc9RXo/TaLys0P+Jij6GYyHQrwvOCOTtZaB?=
 =?us-ascii?Q?M/f+X6alVD/gKk5YuNSkfc3qN1+UKl1LAsJNOJCTHLsnRcjcehQNvdPC/YOg?=
 =?us-ascii?Q?T7G+oK48V5CmQvcTNdwoS6PRie4UMedFaLBR5DYCttR7J2Mzc4dm3sDSgOGa?=
 =?us-ascii?Q?LfXdTfoLH6clCqcCO5UEMdmiEo6g5dxTPA3fjN/5TJMRVkZRk2Y82pxWUrKS?=
 =?us-ascii?Q?feg2Dilos75EpuXrhMup0LuaOHpNV6C/V/peDbg6CgoOQXMt9InniRzfOK8T?=
 =?us-ascii?Q?z+PVMT2fXo3Vvo9Y9Q7S9oULdNBu21ZXC9+OQwvpXfuRNAFstGJX3C6ej9XW?=
 =?us-ascii?Q?L8y9IMrJlssqU7+nCcCbTADfL3uUpmcCY1470ZWvgqRWtyAdBxZwXAgOb76a?=
 =?us-ascii?Q?fpsrzl1R/08yrjweU4Y8NoHGWyC7wCfXM1MjDFpUp3PNyLjq9TtW7kXfuKro?=
 =?us-ascii?Q?36ZLV3wjrl3+aBlkTrRPcLRCjWCRL8j9FajYp57yq1MVYie4jttb5YJMXl1M?=
 =?us-ascii?Q?eKSwKc5gj0RoSb/TqvSe7hYbrqHjXsnwliIBVBJS4TMvP1KXj3UPV/FEqBl3?=
 =?us-ascii?Q?vWM9SulJnINIj+2V1nJYEgkfLitiQjbEtyBY2Pmt?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7157fb2d-2a32-431a-fcbc-08db505a6868
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 06:55:43.1777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zXNL8vTzb2PKz4QfdhLfbDOD0aZjsMB95TXr1sgf8YQhxKXU+W8QUihrP2Bi+eulHzDP6AsxmbMWyRfaAAtC0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4565
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, May 9, 2023 10:05 AM
> To: Zhang, Cathy <cathy.zhang@intel.com>
> Cc: edumazet@google.com; davem@davemloft.net; pabeni@redhat.com;
> Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas, Suresh
> <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next 2/2] net: Add sysctl_reclaim_threshold
>=20
> On Sun,  7 May 2023 19:08:01 -0700 Cathy Zhang wrote:
> > Add a new ABI /proc/sys/net/core/reclaim_threshold which allows to
> > change the size of reserved memory from reclaiming in sk_mem_uncharge.
> > It allows to keep sk->sk_forward_alloc as small as possible when
> > system is under memory pressure, it also allows to change it larger to
> > avoid memcg charge overhead and improve performance when system is
> not
> > under memory pressure. The original reclaim threshold for reserved
> > memory per-socket is 2MB, it's selected as the max value, while the
> > default value is 64KB which is closer to the maximum size of sk_buff.
> >
> > Issue the following command as root to change the default value:
> >
> > 	echo 16384 > /proc/sys/net/core/reclaim_threshold
>=20
> While we wait for Eric to pass judgment - FWIW to me it seems a bit
> overzealous to let users tune this. Does cgroup memory accounting or any
> other socket memory accounting let users control the batching parameters?

I notice the followings are allowed to be tuned:
/proc/sys/net/core/[rw]mem_default
/proc/sys/net/core/[rw]mem_max

