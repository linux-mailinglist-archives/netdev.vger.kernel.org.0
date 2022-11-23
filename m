Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC28636781
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 18:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238136AbiKWRpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 12:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237931AbiKWRpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 12:45:15 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BD78CF14
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 09:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669225515; x=1700761515;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RIBVX5XkDKT4ZVI7n1PInvrdFrcdAh0U6EYhJ+X6sBE=;
  b=D/qyQYlsd5P2gsvrrdJrsuTVw8TA/1WumlXIVH5I7E5FgtGuuLyJjSTy
   fqNwK7/FVnXqmn+p6SmRpKMi4l6JGByjQly+/hv8QqcoULZTNE/NdKpoX
   eoj8EGJ8yNZ4A59YAyTpoqWoDw03iHloWk4Ep5DV1l5bIHco3SMvGXMGB
   vpNBGqZTyP8pF2QVDl9U385+IMVITEFNcOa5h4a3ltjydJALRx8AnaSW8
   6dDhU1sJ0dY4SrTEw+F/6P9FXzFB3UfNDEhfT26dkXD2Xi2YImlPRpZD+
   h9sa8J0t6HJ3DzLxppu38Ys1IX0D1DP7jmAgYqI7REbIsBqQeCxdY0BEx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="314159166"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="314159166"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 09:45:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="592596785"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="592596785"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 23 Nov 2022 09:45:14 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 09:45:13 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 09:45:13 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 09:45:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d4nsOWndt9Hto4ECBQrRJnCv7yma6s4KMgGjFUQWnXUfmeTC8pgz+clqgE14ddyji+k6/Ju5g71vLV037+gB98Ga4uPJLZGe8foqc+KY2u6F5rEbJ8k8h9z9m5yIk+GMCFWPFIcDFUW0UUXItQCrGYCtzB3Jjj56z4ojl14V6rlKjjg72OaWPufCnAw8JMZ1BscYThVkAuGqBSONsU+GQv6Z7lqXCR4ZMqnC1PjLu9TtuBUCAc3dqisS0WVGuTPpA949uXCDtEAeFUOHzJ0Yh7PE3113u6jDqulgvAQMAUDMg/wG0r8MYFGGUCeDjR3AFQUq21DdmEv+V55B4bXwCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHDOu892eaDYu75VfrjVN65iiDT5fxyaE7wEpXRMDak=;
 b=ZVDmGuSGUiH4eS4ghnr07Xk6YYVC6rtlK/MPVqt3dfbKW6r/2y13MUyfpscM72uIDOoWsuMfIPy77QIoRukkDPsZOLAz1ZKRmb3xbHz4XDi1GK79DwPrzURAVBxbyRNCtj3n8gcbFDfXk/PO9G/bIfkGmuiM38Dv6SISOrHbRfjCqja0vaeBAoEw2uxP++HKonhyNk4oup7+V3+uGpd/xITEoncsinY4o0Nik+loXdTZUddDRIbGRSDQ0h8C7Xdj0RGKWjJ91KavRL5qYTrVEhs2sklRq83udN1uq93QbSkfaTdf+UaVX5C/NFDoDLZM+cOvfc4lWt899jv27hO3ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DS7PR11MB6102.namprd11.prod.outlook.com (2603:10b6:8:85::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.9; Wed, 23 Nov 2022 17:45:11 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Wed, 23 Nov 2022
 17:45:11 +0000
Date:   Wed, 23 Nov 2022 18:44:54 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Parav Pandit <parav@nvidia.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>, Shay Drory <shayd@nvidia.com>
Subject: Re: [net 03/14] net/mlx5: SF: Fix probing active SFs during driver
 probe phase
Message-ID: <Y35cFrOguHY5uS6Y@boxer>
References: <20221122022559.89459-1-saeed@kernel.org>
 <20221122022559.89459-4-saeed@kernel.org>
 <Y3404H9uBoVqCQgb@boxer>
 <PH0PR12MB5481CCCC9A6F7649EBEAF538DC0C9@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <PH0PR12MB5481CCCC9A6F7649EBEAF538DC0C9@PH0PR12MB5481.namprd12.prod.outlook.com>
X-ClientProxiedBy: FR0P281CA0074.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::20) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DS7PR11MB6102:EE_
X-MS-Office365-Filtering-Correlation-Id: dfbb99cf-3330-4056-5c06-08dacd7a786e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dzgKevRBqBPh8S4OnrcOQZtDVa9pk8uvmhVdO2/jPPF6O9HJwMEkPGhoXFwhGge/+YiG+A1DiTmAZPeqpAYBvZR373iQsuCVF3J+/LHyL2HS+vmVP0WXD7aDSLnQ08julpJ0tAp0PgGjZDzvFfMiIVIatBZrjLM6FXwVO4k34bltoohvq8TqNXNit+fz1z8Ta7fKVUjWHhS5FbK6Ut6Ohh0OprvFDrfaWXeDF5vrybIjCymiwo+dl1noQ5I9q9R3SvscI+nVRU3LiKUwStKjQvdMSmuB1uPMZGgjP3nGPMxg7dQMAsg7YEDgRDFJ5smtSdmvjP2IF7IRQe1KXOJ/Rl2YEHiYMFsVMJ04O0deJx40Cl5UQUPZPp6MqY0cS8RgcRBKlh2qWe5TLj/59aLWV1cTMpgOymfHxwliRd4g8Fqj4eyPVCnWfh63DtwaHPeGnV/qmRTr+OaeQ+CNTQRYvOTiV3L4bRVMvhMu8Gvei7qKUmmy43PR6+RBZfrZixec32IGxw+MY89dPSMQCTRykjb60O4PMQpFMuHJOCM7ymkz8IxIx8bH1iZ9TAbCGJxlZ7pb91l8HyBlqQiaHH1EA7+8nYOE40zpdgN6bKf7LIV6rls3Xi2wU6a8z6PsMHuE0htEWeUnzgNhOM3wL3tfCqEx61kLmrGksbkgbbKaURM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(186003)(33716001)(82960400001)(6512007)(26005)(86362001)(38100700002)(6666004)(6506007)(83380400001)(8936002)(7416002)(2906002)(66556008)(478600001)(5660300002)(44832011)(41300700001)(8676002)(4326008)(9686003)(66476007)(6486002)(966005)(316002)(6916009)(54906003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?so/e1ktrJmERGu2qL1Gp+xb/LLZRYoIECv2BfEPR2SI7EwY6xXWVA7+IO9jJ?=
 =?us-ascii?Q?PuEILcmNrN7khCN77mZXLUuEPgF/Br8AP6NFhNW010Wj2d26Lbw1y+uMu310?=
 =?us-ascii?Q?dzRNKNvbMLnDrN9TMbmGcAXYe06QraFLiAZO9nQPK743YxC6/DiIh0ASpVqc?=
 =?us-ascii?Q?scBqHkjlU68H6RhvDJWkehjG3MD0FRAwtmOUdl6tcdj32jlF2aru06GSnScO?=
 =?us-ascii?Q?xxE5cZn3JqBTzwDiDNYoemJLEONHp6TBByC370HKDnIty6QajXP6HvN0S382?=
 =?us-ascii?Q?zX0ZJ6+MpIiNgXtcmIlrf8ghBxCLaSjDkWsUAEl8ggUAWYJCVaJc0BYoFEJF?=
 =?us-ascii?Q?BABLqbm25ZuP3R0zXh6gFveuz6mMi2+b0w63jPY4T9niVmgQuqzoC4uQkDRi?=
 =?us-ascii?Q?fwyjLgaIRZ+tT3kKqwEO1qpTEapIA7MLl23NKU4iDftQ+9ZLlttDt7GAZXRL?=
 =?us-ascii?Q?zh/GC9mYI2vTdIc5oaxTYoIa1mftb8LHZmdivFuzhpwodwJGf7UjdUQHux4i?=
 =?us-ascii?Q?H+FuPFBwnxg+TZDDnvGXENCwtfS1z+LVNsX5ecOGYOzAVT1W4GuH2GlwABkI?=
 =?us-ascii?Q?4XEt0GU3ieS3e18P+4dq2auiMCeM3XpBJNQsEvILGlrG596lnGbO5brm1qQi?=
 =?us-ascii?Q?Xeex6IDaQPpdgZu+cQcOJ5Wv8eiA1+iLd0bqRfgINzv02sC5LekrLftQDD/b?=
 =?us-ascii?Q?7Kt+gKqUahu+YR5zyJVL1vD2sNHESLV3YHQ6gS35GxJheUNnQLBenp+zJxzr?=
 =?us-ascii?Q?LNHxMrMu/rU9FpVIzvbJRUPyuUEJ3Xof0oLlddYMJ7xAVW5kzz/oCUV5IYKc?=
 =?us-ascii?Q?97KNBZzYhzqx1wQxE92St/hNmkYzbRIuP0GOwhTSiuONC204mgE4z+ADWy3q?=
 =?us-ascii?Q?0xyOQQSyFOvAhsDQLb7X1oOydFsf2/fCMPBWIC1L4auZ0MTUB5Zpi30FFQpa?=
 =?us-ascii?Q?94ehnoJrtNz9ck6KivphtQMlk5iXmr+RohsJdnSTqsSyFckQP/O49Ac3ajG2?=
 =?us-ascii?Q?wFkErJzOlgxUbdlP189ZuLT69dDAxcjCtZKqkHm4K4nR1iyw2QagWks7hnQg?=
 =?us-ascii?Q?W9lRmuqK2WP+UCUUi2JhOpLeJpUpS0UfSB5f/Tg2KorTrcqa7bX/gEQACfEx?=
 =?us-ascii?Q?56D1b5mEeh+gxlajrwoHYDqVIr3cLmIxZ629uwpxZGlZL4y0qeFEVql9bahM?=
 =?us-ascii?Q?zd+6l/PU4XFuhsIxbDaQ9SzXhAwrz+SrixDVny2e8RVIe4j7SQA5QWTzxuj4?=
 =?us-ascii?Q?iUyOfXQPKjHG+0ouU2Avm7D+6P/bencMwVDopZzFxxq50PKSyhzuREtK5KTO?=
 =?us-ascii?Q?TaONGJZbQyXoaibyrkZI9YcE3bxN/1K4BUUSqapM6q2dm97rHE7Qk/06kRHT?=
 =?us-ascii?Q?x9q6O5Nyen31XJFM4kTbVvPf5cY6cU9nOI23OhwzKrN/YpLaxruT/tKI/yh5?=
 =?us-ascii?Q?4QDcjfEqNjvBuCedua7Qj+HNWjOPjtu3zDkjZuqwKzum7r93CJuQECN+dWEE?=
 =?us-ascii?Q?SONv7TAeDM2DzkAcRhfuLAQ/LcX4Lg5/ZER3ZouwHE4+WEOUrAmxNy1UmQA6?=
 =?us-ascii?Q?XV5aUCr2gsyTxsn2++k1SBLZZcYkG8iNcNIX9QdBYi9w/bo7vsgxllTwauHG?=
 =?us-ascii?Q?6A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dfbb99cf-3330-4056-5c06-08dacd7a786e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 17:45:11.7967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NcVMSxqfhZ0JZVmNEmOVnPpXMfsPqExKREuK7y/sEQpSq9bg1fH6Lh89ZkOO/NDL1RjVrMw1lYHUaH7qGz+Oyiv9En5hlKGW/NztIq8lauU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6102
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 05:11:46PM +0000, Parav Pandit wrote:
> 
> 
> > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > Sent: Wednesday, November 23, 2022 9:58 AM
> > 
> > On Mon, Nov 21, 2022 at 06:25:48PM -0800, Saeed Mahameed wrote:
> > > From: Shay Drory <shayd@nvidia.com>
> > >
> > > When SF devices and SF port representors are located on different
> > > functions, unloading and reloading of SF parent driver doesn't
> > > recreate the existing SF present in the device.
> > > Fix it by querying SFs and probe active SFs during driver probe phase.
> > 
> > Maybe shed some light on how it's actually being done? Have a few words
> > that you're adding a workqueue dedicated for that etc. There is also a new
> > mutex, I was always expecting that such mechanisms get a bit of
> > explanation/justification why there is a need for its introduction.
> 
> Linux kernel has a clear coding guideline is to not explain 'how' of the code.
> It is described in section 8 of [1].

I think that you're just being picky over here

> It largely expands to commit log too as code following [1].

Who told you that it applies to commit message?

> So, commit log and comment skipped the 'how' part. :)
> 
> You likely meant to ask why workqueue is used and not 'how'.
> Having in the code comment is more useful than the commit log here.

This is your subjective opinion about the usefulness and mine was to say
that commit message could be more elaborative. Series got merged anyway
from what I see so let's cut the discussion here.

> So, Shay already explained this in the code function mlx5_sf_dev_queue_active_work() where wq is created.
> 
> Regarding mutex, there is well defined mandatory checkpatch.pl requirement to explain what does this mutex protect.

P.S. Please fix your mail client to don't go over 80 chars per line

> This is also covered in the code comment.
> 
> [1] https://www.kernel.org/doc/html/v4.10/process/coding-style.html
> 
> > 
> > Not sure if including some example reproducer in here is mandatory or not
> > (and therefore splat, if any). General feeling is that commit message could be
> > beefed up.
> > 
> > >
> > > Fixes: 90d010b8634b ("net/mlx5: SF, Add auxiliary device support")
> > > Signed-off-by: Shay Drory <shayd@nvidia.com>
> > > Reviewed-by: Parav Pandit <parav@nvidia.com>
> > > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > > ---
> > >  .../ethernet/mellanox/mlx5/core/sf/dev/dev.c  | 88
> > > +++++++++++++++++++
> > >  1 file changed, 88 insertions(+)
> > >
