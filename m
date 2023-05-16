Return-Path: <netdev+bounces-2996-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 274CA704EC9
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 15:07:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4FDA2815F4
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:07:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A2C127706;
	Tue, 16 May 2023 13:07:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5873234CD9;
	Tue, 16 May 2023 13:07:48 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED48BD;
	Tue, 16 May 2023 06:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684242465; x=1715778465;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=cFEFEnuBDmrX+Zpg2/SxG8x5E7bm0xwPFys9KjeweqE=;
  b=k/m8+5Oe9Ogfo/9X8/yl0B9rdQaneq94Z9ymPNnNmtGEE3DLRS2nKaVW
   FP4B0ZmThKbcckA737sdla+2vIbPmgJevE2RAqRTzrWZp0EgLfLXogft6
   0IUagB4LeekSlUVO8b/CVmKcgB+Uu4vIKz+qNRiCbwrKJJTP08hihPUYY
   WnPUwMWkPH8ckjQkMNJiTOmmiQdHyQ8z/bp6uJhBFkuKRpeRNL7QPV/WU
   XLnxUVPOhufRPOkTWTWUaFKavV4025GZwkFv/mS/oAnme6ezwR+GqBVIQ
   3hYSpEU6umPN3O4GsV49U1P1++YGvUsBNs58tX739gVQPSzi5YDXY/Ly0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="353752375"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="353752375"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 06:07:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="771038403"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="771038403"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 16 May 2023 06:06:34 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 06:06:33 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 06:06:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 06:06:33 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 06:06:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=en7EoO6GqqwIlVzj8vMyBPo1YNfNfAm0QevfoQ2n2v1fjXU4kqh7a12796a+Sf4pV1ZvvssMcKx4eYhhT8Sw12hlDN4ZHNU5DQL+ycyyRe91JysAwNiRlP6kuj2/FQXp2GMG0Jw9kcD0oUXxwfI5g/9oEhuWP49gfCJsXmdzIo8jH2e7ZfQjK45tc9AToYMImO6kI39btsIoOFVHb03kxpyIUFIVWQ9Ppgv5OKIABd/dKzvh6WCRN9dnYPXvOkszp7Ucw11P1E6Z2LgCkAmdhP7UtlmbfdAw/q+fNPDtO98EvimKvPKAG2xVfoF0yKn2YGGuC1rkUJ6kV5A3GRIJ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZvHquaWQsHZZTwXaOZzf1hFapvWGTq+IH2z5h/Twnak=;
 b=QC9D/rYT9qIYUQMrrQsxvNieV8MEfJKzNRttW9eoMtmVPjaZUvrfkb11V49uOzO0rTtVbl46n2071LzYvLFaiBPVqSvmHGd36H8uFzGzJcVAdqutCnnujUZTbED0bAY9aFyTSvpgLUWZlB+m/cTDI7NAMcaGt2bmjBF34bYWnbyiFXTWwpqFdjr5TIMOAlmGegappU3gLqQFixf5CDCwmQdlHUa7dyTwv34nKshzoZrIxyFPHaY+KDMr7uaFOmYuRWssVu6mJFAYf23p/BM/BtwLc7OxZamY8Px/A0iPacVpUlD5YlzJji09j1JA5VsNzPosHm6y5HN1zTPboyxmEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SA0PR11MB4717.namprd11.prod.outlook.com (2603:10b6:806:9f::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.30; Tue, 16 May 2023 13:06:31 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 13:06:31 +0000
Date: Tue, 16 May 2023 15:06:21 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Magnus Karlsson <magnus.karlsson@gmail.com>
CC: <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
	<daniel@iogearbox.net>, <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
	<yhs@fb.com>, <andrii@kernel.org>, <martin.lau@linux.dev>, <song@kernel.org>,
	<john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
	<haoluo@google.com>, <jolsa@kernel.org>, <tirthendu.sarkar@intel.com>
Subject: Re: [PATCH bpf-next v2 07/10] selftests/xsx: test for huge pages
 only once
Message-ID: <ZGN/zTd74uV2xQwl@boxer>
References: <20230516103109.3066-1-magnus.karlsson@gmail.com>
 <20230516103109.3066-8-magnus.karlsson@gmail.com>
 <ZGN98qXSvzggA1Yu@boxer>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZGN98qXSvzggA1Yu@boxer>
X-ClientProxiedBy: FR3P281CA0101.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::10) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SA0PR11MB4717:EE_
X-MS-Office365-Filtering-Correlation-Id: 97c4258e-3846-4cdd-55c0-08db560e5ddf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SlXs5u4tDjnbrf+ye0XQQxqyK/MD+w4dVm8JO0tWK+Kq1hHi/MS6zOFEygs1GY08gmJOQ+rXwhHIsoGAcIaFCsrBIJ0X0gI3ENNu5XAPYhPH61/Gl1i3rN53DXR66/ejl6Y65IZACASiqvuIy7AOjhGM43Ym+MXmw/ctzSEhNqlxccFJJZ0IVPD2UY694ePtfZDZVJf9h6l9s+Ye5WgS3in4ckXmUL9pdRyyfVG4E8ydTTAc2TJfVfss2BsbtClgYxPDt31j9dZWNutO/+mliQG9PacnKU4XRWaNuNP6agcXq5+dbaQJFE+993Jstb8eFi5F4HiY3cVAhhwzhqbZyf3TG5mdfLIfnYlb474yAJgxTPRQ5zVGZIaNhGFTNgvOiHEQLLnfZO7eONuEPbuhG+Ae1hnaxzynP8k5lYE+ALlv8Qg3+E32VpJwrecfEKVFQgnkNjXVQB01pgTLd4V2rgvypGytda3DS+4NJ86cK8liC3zpv7jLpaGAfXHmBNG0nKWne6msrnYiu5Njm0+DPXRVwkyGaxmazXzBziD6Ot0F8HApWQ2JZjBrKTbLiIjjD+6QFfNILsik3NA43+mopoGw4IJ0uokjqewy3F6ySHQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(39860400002)(376002)(366004)(136003)(451199021)(6916009)(4326008)(6666004)(8676002)(82960400001)(66476007)(66556008)(316002)(41300700001)(478600001)(66946007)(8936002)(38100700002)(6506007)(186003)(107886003)(9686003)(6512007)(2906002)(26005)(83380400001)(33716001)(86362001)(44832011)(5660300002)(6486002)(7416002)(14583001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bRWA1wVXAu6tyi9dLYELVvab0YUeMLGVZz6g1udf+p2/hUkZrYoknzAC3YRh?=
 =?us-ascii?Q?5Ha8AdsuCJeUxyeU7IVLHTa8T0indIHS5inxHrXuzXE5ORGPol0nHLvPUy5m?=
 =?us-ascii?Q?IvPbwVXP9oMshbYut+pSxmn7NbHO1mRiazd2rB0FGD7BrmoALlynhXekrWZ0?=
 =?us-ascii?Q?RAHAdVOBwLftXyJrMRNp6R1hA3CpTfZ1tSjUmatNiMDFA1YqZKvpfRzfQQfk?=
 =?us-ascii?Q?38JHveK6FlDAedQwy5nldzpSlKF5i9Fvaj/3YfuQK7qSIwO+8Y9UeAwcdMWb?=
 =?us-ascii?Q?Z6uubfx2dbFcM7pNfaXqieUSnsPLLu8kRgkJwhdirK3JX4esARVylJJRgH8a?=
 =?us-ascii?Q?rlDEyHit0emtZ/Im1hFB8BPwzRZ3YXOyCn1NomiSnzhiOMa/TZkQIQO/PVLg?=
 =?us-ascii?Q?nYQwnGTVidvia0XrlRncLD22B8zdXK3So5P2TtN8at0S2/fJESQqzHnwAFpw?=
 =?us-ascii?Q?L7e6wgINXXpywUoFewSrIRV8H4dxglEk5VTOGzdhGkQWSvJnrDZC5wA0/bkc?=
 =?us-ascii?Q?YiXuQyuhI+l4xZizr0AsnxgpJ1HY6kIgvLGmnwy2v2PXOlUbOHL1r8ZxthkW?=
 =?us-ascii?Q?iTajjqJMTwZg3Yqh+czYHS24MMf+PkEdjBxgeDJrAOs/jAfmWjU+eey9GWYu?=
 =?us-ascii?Q?yRPlpP3bQGwMUiBRu3u01cXzo8Uoj6bW7NN+VnQD9m0/LbTR+SoaNuhALBsJ?=
 =?us-ascii?Q?jtAMo8ubhZAwuVvd3e+/U9JI2VCKEeaqUMmqXuuAP6Jnf937kwBNZPZVdR27?=
 =?us-ascii?Q?qvFxQbJ0hz4DURALfLkVPZGCdbVZ/6B5zptpGUsdZ6cgf7KlYyEz/rDrNGJL?=
 =?us-ascii?Q?gTlTU+h8MDcu/cTmZaCIiod0/3aTi7sNDiarJh5fvbSJaaDVYgWAdA6tpjfz?=
 =?us-ascii?Q?1eo4e3KikUnBWi/ntBlISNz9L8MLfUBThKtHjp3M5oNqYdUvljL0KEoWhRmq?=
 =?us-ascii?Q?nwZJec0IWWQ8lO2TqYquLdNW7gktJmp6HSD9GoVW1h9adVBiuQQQVlNjApPP?=
 =?us-ascii?Q?JrvyrjzrU4lcnSN3oF6+Z3Sl2waX3F8gQg9DqXWsoCi617I2WRLYpZvLpOIw?=
 =?us-ascii?Q?m3ncsAg4dyXVTCMkacFC0FYUaqsPZrv0/kFU33m+UV9NQ/YA/MrN4YtT7IC8?=
 =?us-ascii?Q?s9fAr9Hwe6nkEqtGXtcuejG7RJSfVT6rubvAN1zScAQ1QV6rx0odbrFt7A5F?=
 =?us-ascii?Q?VPfVDTdtcoybkLOGYIKxzJ+mgsX1bCcY8uOSLvKZu+q59gPiXXYjplUgV8QY?=
 =?us-ascii?Q?v+GUWs9qk8bUB04y5q2pSU6dwKSVstAgLxdW6eLWmXh/8c3CP3mRkok63UuJ?=
 =?us-ascii?Q?Z7HyO/4WhYt23sQZjVj5HkxijQqAd/1dWyigaRdOsoPvd+BxF4z7FPWHjmLZ?=
 =?us-ascii?Q?QNAUkr5oddWaGtryeTkP/piql4iv3MITHvryd1YlErSi9ciTAQOUVWET1kDe?=
 =?us-ascii?Q?R8FA7m9H+3GlJJH4LU8hmElOMC8is43NNpeSNpH8/eMUwM2BPOW60mT1bwfg?=
 =?us-ascii?Q?7TaZDxyfTPu50XoAXvhPyxbfTQLXoB4Aaf3yitKJC4B59vLg09HOA9FJhg/V?=
 =?us-ascii?Q?r5nuiPt5KqltCz7FBz+w/AdP27DEGXgtDiBGPRDf+++MVehrph3ZgeAKvROP?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97c4258e-3846-4cdd-55c0-08db560e5ddf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 13:06:30.9237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pp9mbZgTmsEjmxTxzj42ir5Z3EgRB0zryjyRAkCVD12JKRthumWz+uj9az51x2UYuckGfkBEcye+L5C0XBy9L1t2rOp9xqk6GzyIfIqEIgI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4717
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 02:58:26PM +0200, Maciej Fijalkowski wrote:
> On Tue, May 16, 2023 at 12:31:06PM +0200, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> > 
> > Test for hugepages only once at the beginning of the execution of the
> > whole test suite, instead of before each test that needs huge
> > pages. These are the tests that use unaligned mode. As more unaligned
> > tests will be added, so the current system just does not scale.
> > 
> > With this change, there are now three possible outcomes of a test run:
> > fail, pass, or skip. To simplify the handling of this, the function
> > testapp_validate_traffic() now returns this value to the main loop. As
> > this function is used by nearly all tests, it meant a small change to
> > most of them.
> 
> I don't get the need for that change. Why couldn't we just store the
> retval to test_spec and then check it in run_pkt_test() just like we check
> test->fail currently? Am i missing something?

also typo in subject - s/xsx/xsk

> 
> > 
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  tools/testing/selftests/bpf/xskxceiver.c | 186 +++++++++++------------
> >  tools/testing/selftests/bpf/xskxceiver.h |   2 +
> >  2 files changed, 94 insertions(+), 94 deletions(-)
> > 

