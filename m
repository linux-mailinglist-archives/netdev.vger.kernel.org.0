Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99016BC375
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 02:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjCPBsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 21:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPBsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 21:48:24 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEED5222DF;
        Wed, 15 Mar 2023 18:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678931301; x=1710467301;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=sSx5NLG1J/FX90Md+UI0nZ6trrgL1G5RiqiBxBcAEkk=;
  b=E6TvuNcRxs6q7fMGchUgiqHrqU7ZcJD/z3FdUrgXLPyeWT3bcxqtx62H
   5UtZTppInPk29dSGk7XVOzAsV3Mo/fPq26SsZNHXP308uuCXz8/+/SB3L
   8P0dDExkVr1uALFtQB43AmGWpKuCuovj10YSM5ByKcSDemnki2RZWJGLb
   ez5JWluIOL4XoiOB//StXAYuXZcQy7ztU3hQ3WtgVsgMLE2G7j8boRWzx
   NCaYP4PSvvFxJ34P9UqD4jFKhEQI754woax5YhOlvi8A6oK5TSk8Inx9D
   mh1/NTlf2Z1frLcWD335DRwoi0bHh9q0257qvdnpS3e73jZzpiixUbo3F
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="365550639"
X-IronPort-AV: E=Sophos;i="5.98,264,1673942400"; 
   d="scan'208";a="365550639"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 18:48:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="853818046"
X-IronPort-AV: E=Sophos;i="5.98,264,1673942400"; 
   d="scan'208";a="853818046"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 15 Mar 2023 18:48:20 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 18:48:20 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 18:48:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 18:48:19 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 18:48:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gxdls/th9m5Eq2NUS3OQQAyWBdtGXQGy4AOJA5py448kzrG0WTp33Zbby3WDmCOYtlY9e3oJYaBinCi3QI3DmmPVkuWVZIUgJVu3rQrv8N2S+wXsfRZ+SdOI95h+CfIRr5oCepwOr5ELbtUU/1Tm8tTGTkC09kr3Pa3LDQzN33RLLpNbv4yrDFFnEpcFD5M36E8Wj4aS6cKcrtxzRqipRy2125nMG/Om/dluNn+qSPUv2zb7TK1WDWipCu9ZkyuSpwX9P5jdLdbjYz3dJTeKnebk/cHA2zJDqfAzWm8F3DH2SafaYepCuSkk3GtQvz2VO3xTcC2LYNf4cBAq7yF/hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NGaEX0R6eXYlJn7tbGMJdMNuG8U+kv5CqMz1RZzmUeI=;
 b=C610vbJ8i61vW4mlCL2IV+H9aioEH/z/aRVMnY/TgF5mqTpaT+sXbe3LP+pAFabU8ym5mVVQVWgMnE7856dYETQDqLN83go+el6XJHWwhF0ediDLyQmsrkY7U81MQis9HZuwphAwV82lL6r2EHzdYKEVqMBUdAMIbeUvBNPYZ7mUuZIU0sOYvY1OyNMAXOgqFudrrxmKnSxLlbjHahFVKBiUQ94bYkAYk6MikapBF6VF50lSNh+Br6j8Cq6srWwtjPTLwJC4UgaQE8kMLSRv9slbOw9LtUTW6iEcoibpJEjlN8cWd4Rg4HvX94N7nrwAMejhPR/SbRcmRttz1KtvPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
 by MN6PR11MB8146.namprd11.prod.outlook.com (2603:10b6:208:470::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.22; Thu, 16 Mar
 2023 01:48:17 +0000
Received: from BL0PR11MB2995.namprd11.prod.outlook.com
 ([fe80::93fd:14c:bf9f:6d03]) by BL0PR11MB2995.namprd11.prod.outlook.com
 ([fe80::93fd:14c:bf9f:6d03%7]) with mapi id 15.20.6178.025; Thu, 16 Mar 2023
 01:48:17 +0000
Date:   Thu, 16 Mar 2023 09:48:05 +0800
From:   Philip Li <philip.li@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Nathan Chancellor <nathan@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        kernel test robot <lkp@intel.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>,
        <oe-kbuild-all@lists.linux.dev>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v6 1/1] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
Message-ID: <ZBJ1VV7cfASY4tW5@rli9-mobl>
References: <20230314181824.56881-1-andriy.shevchenko@linux.intel.com>
 <202303150831.vgyKe8FD-lkp@intel.com>
 <ZBH7G+1RwX4VAKcz@smile.fi.intel.com>
 <20230315195154.GA1636193@dev-arch.thelio-3990X>
 <20230315141538.5a9f574c@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230315141538.5a9f574c@kernel.org>
X-ClientProxiedBy: SG2PR04CA0157.apcprd04.prod.outlook.com (2603:1096:4::19)
 To BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB2995:EE_|MN6PR11MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cd086f5-87b8-4bc1-69f1-08db25c08373
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VHV/QLXKiVDCaaCaS2wYjzgH3dX9LGvAZXg2E/rq0re6uhu4F8wugFw6VKeFasGT2aMAuLVouPUpdjDMIo+fZU6krHZC09TzlHmYZwgpRc2MZOIpoy3OhvbBWNUM1DY/ow+PIKsMd5+JUZN5ChLuN0T1Dr6k2dC/UaR6X8cMrB+EdQd+Jx+Gwm9fxjJMBVOObfX/lgQT2C86gpMuUb0wJJfNahHMgBZdOoBPbSNalavXYVDaRwTihIxRRxEjg6BDBeG8dFl6RcvuRNCTSp4x7KWnvZQiNozBW2IiTYngqUmsH6gyKgoXEqJV1ZTM/K1wdrdEU+cMrydS7x/7yohbZy1AMWc+XlWdvHyIzWMi+fssW+0owl7X1O8yziXqHO3fq4/AhajQWwaMl6Q2UyTtnIoWue6u5IrMvEx+J5aM+9ThDb8+nw3kMqRcpupmH6N+euoTZpwrO/yuf428VdpLjFja76LtNtnPDCmrNmtPJ+Pw64hD1V5f58r1bdd67Vdo7MOOnkdsEkHlBwd3QW69wKOV4uQHjDaFm89bWWWuOlVRYo48MLHPLjE4nkWK8LxBd1r+jb33Ne20zBH7bt2sbgTdHQbZD+oSoyFCJJGBqNFXr98YDf/jm6HhXZoWXqOH7+gFW3n5GeH7jz06y7hie6Z03RpXrZ8GFqnqUj1yj8J75DJfFD/XM07ScJzUfo+s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2995.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39860400002)(376002)(346002)(366004)(396003)(136003)(451199018)(83380400001)(4326008)(66556008)(66476007)(66946007)(33716001)(38100700002)(82960400001)(316002)(44832011)(41300700001)(6916009)(8676002)(6486002)(186003)(26005)(54906003)(6506007)(9686003)(6512007)(8936002)(5660300002)(7416002)(478600001)(6666004)(2906002)(86362001)(26583001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B60Cj59hFDWWn5hbcOrMLrq64/NEZAniDzoH2DycZRRLxEckGXoQRarNDwiM?=
 =?us-ascii?Q?ECUmcmFUI+l84SXEV6wKmbV3Dw5x9Vku6oOWFrNLleS7eFjEm/swuVWOq5wL?=
 =?us-ascii?Q?CdUv7XG6HazCfPqc3C4sI9FleRUo1uk7dy3VpFFaWuB6LqMjcqWSJqgsl24a?=
 =?us-ascii?Q?sR7l2t1DESRbHhi086IjrY7uOaqq7tlEB2B3aW3Vp+ahfont94eVcWWugpNd?=
 =?us-ascii?Q?XL2LM7A48V+Pt1y7Vll+oluJEqIy8ITceoOYOXgDEDRAtv3FTxvc8eJ2mwaR?=
 =?us-ascii?Q?axSYEFdxcqYqNC+rkYs40eQqT/HgTQKNRYbl9F1QZ4NWSjTBnumxBOqazfic?=
 =?us-ascii?Q?Dfla2P/J3tSDL1fkBVb9qQFaWLbvNR5tfqNOl43F0niE375QbcYL724RNa0s?=
 =?us-ascii?Q?4WK5Kv2+IOIw5cjlHdPfRxP/33SDaFQOOdooYkJpLPBSpzCGueC3yjpkr9mO?=
 =?us-ascii?Q?NupAn4eeQZNh9iPUdrsmBKP0V0ruWldnuWNKQoeyj6IEdC4H8fMW8CSGgOkZ?=
 =?us-ascii?Q?Ake+kcz+4SXABa+rJca4qh4uReCkW9edsqVa8fegdO8gKmQkmSatEdt+IXaN?=
 =?us-ascii?Q?nonzCoTWqkGaAzBedP73711HPaJzCJF7wzaVu251sLTxe0GQmRhkZh6zs32K?=
 =?us-ascii?Q?BXAxHt22AIFQK3KgPx232CttPmwp2pZBHm4WBLlEKKPMwuC9CSOcC0G7kzO6?=
 =?us-ascii?Q?7/wx/6Q2TGlZ+VLuugvfzMjfj/fGQmM+LLtH8SIF+5XyJ1qZLUkxSYkbkizk?=
 =?us-ascii?Q?Lo7PzrTz2PurS/aMaPetHx5E8Z/Hf28a4SSBcFEIIGYfsDM6lPzF3iGnV7Wv?=
 =?us-ascii?Q?mJ0g25fDG6sbgoHzNAsxTvgyzP/sTVO8h8w/SXjcgVl2pSongpFFNnCeWEOk?=
 =?us-ascii?Q?1lwARoVw6H+0IoqSIvxz6QpOBSWjfjzn0Q8Mj7MDe5KVm9VHojlmes9j1TA1?=
 =?us-ascii?Q?1ozdq1Eg47XyKGdYWh7ztq/Jvb8hdHTkxh4BRkeKgHfy88DW0iwgtav+qZez?=
 =?us-ascii?Q?mluh/QglcZFVGx/W8BlQ2YpYtSUi/YAYo4KFGa7oGnezmoeUP7HtY0ovnDx2?=
 =?us-ascii?Q?001oXxIq0GMsgXmUMaoN10rWcqUy1uXFJzFjtRrkVfjJXSN9P0jvGzI4sREt?=
 =?us-ascii?Q?7usnztgOga27DnVDVTwOViYmsTUKaIWQffK00aOGPywe7oixcDSMlG4/zvWg?=
 =?us-ascii?Q?P110l9pcHzf673xYhda/o6/HUwgBzJU7sPWnHem+zsSfrmWkG+7tWpgclTSf?=
 =?us-ascii?Q?Gv03dxoFII9+ihIBtJd/QkV6kNueqciZpQrpIQV44OVE45+h94O2XO8GIP3x?=
 =?us-ascii?Q?all9DU4josL0KxgyLKJlh72hsmhyns3lP6KnZKFrFJNv8XzVe5PelolLjCcE?=
 =?us-ascii?Q?UD7xHRtNO//YuFqv8onzHPuU1nx2T6I2ka5Drn2yLUlKNhXN6iIaNSB8ihBt?=
 =?us-ascii?Q?86ZS6dtxnvkLk140nsMvKbSWyMP7JADOmJAYTuaTNTTrxrjKnpZprTMT4V5x?=
 =?us-ascii?Q?Gas2NBmKRwOi/15QZhhez6esBC6eb2x61XDKhDl0P+QmqWCLu0wQY3zXDqvO?=
 =?us-ascii?Q?I8wJezxmRwpHWj7RhilDDXSXpBXm/vJKoklg7DutvdhPRy8R8GpUNbIoI/pC?=
 =?us-ascii?Q?OA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cd086f5-87b8-4bc1-69f1-08db25c08373
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB2995.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 01:48:17.6447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pu/bNBkkV46eXyIL1HzWWsjXWp9arBJH+ReInimlFiTZKvchxzY94V3bhPPPnWlJZt7bjs0vDgzmBICrIC1fzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8146
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 02:15:38PM -0700, Jakub Kicinski wrote:
> On Wed, 15 Mar 2023 12:51:54 -0700 Nathan Chancellor wrote:
> > If you modify the GitHub link above the 'git remote' command above from
> > 'commit' to 'commits', you can see that your patch was applied on top of
> > mainline commit 5b7c4cabbb65 ("Merge tag 'net-next-6.3' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next"), which
> > was before the pull that moved led_init_default_state_get() into
> > include/linux/leds.h, commit e4bc15889506 ("Merge tag 'leds-next-6.3' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/lee/leds"). Not sure why
> > that was the base that was chosen but it explains the error.
> 
> Because they still haven't moved to using the main branch of netdev
> trees, they try to pull master :| I'll email them directly, I think
> they don't see the in-reply messages.

Sorry for missing the early information, we didn't notice it and still
apply to the wrong branch. We will resolve this asap to use main branch
instead.

Thanks

> 
