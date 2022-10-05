Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F755F5298
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 12:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiJEK3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 06:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiJEK3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 06:29:50 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4531C104
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 03:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664965789; x=1696501789;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PJwZlOTaOcegffjmoklo+cjrShLN2kpQHyveGM9kxag=;
  b=jyuZRVNV5y2fXI0pE8s1ReWyIkUdtN2RfH3i2/5KgFX8pXDUyAbz0mn0
   AWmbI99j7EJ1OggNqeppAlswJjQIww9qqW5/mfDBBH7qwIFqydo/BTgP/
   8INxJD4OTwzxaVyxQpiISDyNCuQHbOwxPCytAUnkV7L2nfN5ArjWiNVfK
   uCBGDGbI6oaYscvVi4ymrrhSC0KR+xS3P0feP8v6ZUArQXxeKj5jYHQ4E
   jYC70qi+9cb58WzE0QU4RwsxB/JRuinhXHp/M9MvvHSOpE2NcAuq7dHWq
   VYwtP+3Br+T7oLiEWFHgPmlCaUSX2s+jx3s2+qHvqvxUPLRKCGgGaY+F4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="282842732"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="scan'208";a="282842732"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 03:29:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="624269848"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="scan'208";a="624269848"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 05 Oct 2022 03:29:33 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 5 Oct 2022 03:29:33 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 5 Oct 2022 03:29:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 5 Oct 2022 03:29:32 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 5 Oct 2022 03:29:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYoP4wTq/dRl+bp7F7QAKQ0NzM21OiRcEXDutFWzKLr01VWxDiqA6uBs9bZVgcdE3pt3lywXrUvz/UMiEvb/xD3/Ui8K6Tf/5SsplKK0iJFf0CZu1TP3OVK01MmO9qhrtiD5Jtj5KH4wRm7mDgffGiLT9djQSe1kpSJM0ZFs3lwuI5qZyol1MoMfru5QIlRPPzAJYevuqxF6QVqNWbnqoLPprm/d++feys566puDHkD1/qKKi1teSZb5fz0GC5+4xnEjgPIYZBZhqwE1L3QUFQA8JShRv7UhO1mYJfGDrQ51zaWLvZ4iwoYXjwWK+ELZEb5a9p1rWeYCYI92+wofrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m4VBh8GW0kP10LUzc2lBzbUMMd0mIKbUuZPMry+diIs=;
 b=UBGzpKKV27Kpnn/ZfP7TNuZae317Bi4XgsLYoVHzg1U8Tk5VVDa+zEzrwDUJVYZEcVUI3y/NIgJ5JEhwgKQ+M3Wki5T0xu6bG2oNM1CdQNx8r74jhOYB9WRwX5lL9aFQrvlY9RC3jj00PNfgeHiFBaEi8npXSwkeHIPW/CU1g8qAucv/5AyKIUd/zSX9P9xDECJo5LDt2tL91SqRPexQi96wrxWdYvxhYvYGv2hw8u/eFCpDILiM6n5/kkUeB52VeNLvr2AzKC1d5V2ryHl4eHMkAJveH3OcCIG9yXEqM6OAOgPeQa4t29V2kiiPU0Cn6Tmxcua2VMN5BKTg094FPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 BL1PR11MB5448.namprd11.prod.outlook.com (2603:10b6:208:319::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.28; Wed, 5 Oct 2022 10:29:30 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::6ae9:91fd:f3e0:7923]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::6ae9:91fd:f3e0:7923%4]) with mapi id 15.20.5676.028; Wed, 5 Oct 2022
 10:29:30 +0000
Date:   Wed, 5 Oct 2022 12:29:24 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Joe Damato <jdamato@fastly.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <kuba@kernel.org>, <davem@davemloft.net>,
        <anthony.l.nguyen@intel.com>, <jesse.brandeburg@intel.com>
Subject: Re: [next-queue 1/3] i40e: Store the irq number in i40e_q_vector
Message-ID: <Yz1chBm4F8vJPkl2@boxer>
References: <1664958703-4224-1-git-send-email-jdamato@fastly.com>
 <1664958703-4224-2-git-send-email-jdamato@fastly.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1664958703-4224-2-git-send-email-jdamato@fastly.com>
X-ClientProxiedBy: FR0P281CA0138.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::7) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|BL1PR11MB5448:EE_
X-MS-Office365-Filtering-Correlation-Id: 28c129b9-e4a2-4544-f5f1-08daa6bc7cc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 78OLRQSpDoIMHVc3N0XSv23Ug+qkt3USfyu/zDf0+536t13q+K5ihKreckVs3rzCOLaXCnQTW3OZpOcsYtUihGsaSvmnj6vDX0/5FXiopeioa2DUxOxgRxPLcvYEtaQ7kqTFZJzZLvK3XEGUXxXg2JJBYUTzEPIXO9PS8u/hXwTwz/VVoRjWyxsbd85JKpM/NDxuDiRyJC6rVv29T/D5RSeSnijBPkoCvqqC23mtjcYgvp3Zo3yurY8MsYSfysInpFxO0TXORWVFxhD5fpfeWzfXHP5jJM8qi+Z/FPzYr9HBDZ21kb6crXr07MvtUAymNq2ThmJ2GR7g7sOq4m2vzqaRKMIq3laoKyqIGPppviFagy8F+J8kiUl+AYPA0oTSDmzLcqZhtbcIa7v38FnkVetAK24R3rHkVijU4Iu7mV6mcwid0KWnbmCq3/Kqtjq9HZryemLK1agpCnXVB9YpyRDFMaA0TAdg3HAij21/isMfcNttoq2bPA05Q45YJQKZVN9mt5BDa7RWm/X7luF1xRUiw5vnitLsRZQ7yk+taLQKqTb6P87VRtbKByKUgccjgNqjB3Ovn7m8dkMMBToGsM1HcxaY+n5b9xA5Hovu+LG6P7DYODItFrd5JvSP8JJz7LJYTCgWqs7G69mPG8/JKz7Mn/lzLUiNLw1Tbvat7T7Xf2dcZNM4XdnKOHG+2fInFFFwFHdddFS+tLR368A3tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(376002)(39860400002)(136003)(346002)(396003)(451199015)(83380400001)(86362001)(38100700002)(186003)(82960400001)(41300700001)(5660300002)(8936002)(316002)(8676002)(6916009)(66476007)(66946007)(66556008)(4326008)(6512007)(107886003)(6666004)(26005)(44832011)(478600001)(2906002)(6506007)(9686003)(6486002)(33716001)(66899015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e+aQAm9aRbRh7CXvrMjtjHJToFUL8V19qwMdWeTbWlTNvmC5fgihnmTJcC6P?=
 =?us-ascii?Q?K939MBWp6RxUyWZmANHybvOm58O7sCDVaHT8Fvl+1yfuIGGyyOjQf6y4Ruk+?=
 =?us-ascii?Q?jG1gFS7Q5wHJTXNxXIX9tcO1P1sehm12YDP5kDONQCQw9Uku3eV5Oo7UZX51?=
 =?us-ascii?Q?EM8Ga2t/zCnvflcBZk0T6Rbrx+4xrRrPIKcuElnoXVppgaXoggQy0kGKU9Zy?=
 =?us-ascii?Q?7Z/RNO4jSzwRJZVUEsa7dsD9MsS0SEC4Kl6uoiPc5Lf8r8upFzOJNiCpZMVu?=
 =?us-ascii?Q?mbsPYeSEOgnaeM6KHlJLW2D30wCXQKbVr+hU9Nori8TDVHdvXIkQK222+hCr?=
 =?us-ascii?Q?bg5Z++9tz2pB9DPhgh+65ZDYyD+aXwFKZur3Z39cMIsarPTxWjX4XtMbE0yc?=
 =?us-ascii?Q?BtPEh1njsoWqd2P/Zb0AjqZ9aYKivjJiprS6n2xYJqU3yZ1K4HaqpnAynuaU?=
 =?us-ascii?Q?C+TWsj8TvHidCnLJerCBvjBIYl/JJxckc78X8b+1LazKdzotwgAGNV7MeKSa?=
 =?us-ascii?Q?LsN+VlzpBBGER+VyGq15bzK+vrTZQ8qH8rTu5wx3Nef09PLTPYPN9m5LWdod?=
 =?us-ascii?Q?eTWogvdi7+gT+EnlIS1UnyZx/9f0c7slMmeGkZiMIpM56/a7QSNFXKBikaPY?=
 =?us-ascii?Q?bk80XMjsELSt4/K7gwpk+2ep6BFLwPEl0sekXH17kcfXCZLsYKElXR5c/OWE?=
 =?us-ascii?Q?LX9Ebyp6b6z8bmbl6CfoPTF3bYhQeeUaTzDo7cbXWYbYKwWwn859vHE/SzVR?=
 =?us-ascii?Q?TdKXVFOwV06DBq1npFHIaHE+UmlG13CQ1Bu+Ap/awRdDnJw0L3pzDrMXNyGS?=
 =?us-ascii?Q?I4VT5tRnhmNRR7sy3EqemmfFh+i/B296zK8liQZNbYGDI/HPQL41/5MZy1it?=
 =?us-ascii?Q?ClUTixHsNrKDHUF+PcQJjHi6BXE/5KlezrwHIB5M6p7vMR2NwREYo7tPoxfN?=
 =?us-ascii?Q?B3C7yd2uLF2PjGYzvDI0q+eZ23+bJ5ZLBiVOpRJTauU7ZRDN0PzHR+pQly1G?=
 =?us-ascii?Q?sZdCaoFWIBwp2Hd0eYxIdnx2ZHzK0fphYgW5DgUS8Tc9nMHbFiWWwdvMrtMZ?=
 =?us-ascii?Q?c/b+61YbbESc8Mo4Kkrsu8dA/XoDqqgf6S12dznU0XytblVGsXARSAhWMH2p?=
 =?us-ascii?Q?1UQ6yg38aY4nIvGGdOPENisyd5RYhbok2Kw6UuqchxRUiNL+wRHYOQkmditR?=
 =?us-ascii?Q?BO4l6KeCVY4i3HUzNbyal/kvFS6IYHxLAz4EsVRpG9nMu8HESf8PkAGuD2KF?=
 =?us-ascii?Q?gqTQxvKtV5s3ciGZ0/78QasOWY0bbk9a0LLoWnJGYxNNOygTpmz459D59XjF?=
 =?us-ascii?Q?jkeNZxGlKAfS0CffJcN0yPdIs73hUNn9lLysIpvYKWGM/i/ZOTGsi9x1g81T?=
 =?us-ascii?Q?2qztxYF/1C0iNz5pXyQZPPiMkQoCR20OptglpUpXFJhwg5xRq1duwNMtjS1R?=
 =?us-ascii?Q?BstsNec1PLBP/3ZaIuixdNElB7avBD3WENZR/TsNRjUztpEAETIr1VAzgi+5?=
 =?us-ascii?Q?IN/3qjf4rRyEVGVQhOoXljkbXNF00O8LYnnCdArjqSM1S/ELhjkXmvmQqaV8?=
 =?us-ascii?Q?AznWeK0Cs6Aap27OZIVzqGeF9Wok1uslUdDRtsyWXLjkrXf0QsHwcxmKpzGO?=
 =?us-ascii?Q?UQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 28c129b9-e4a2-4544-f5f1-08daa6bc7cc4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 10:29:30.4472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6F55FHXAIketSrRMgblbkKVGVqU5fR3q/BouNphft2uV01Tb3C8rkW3XDcKsCroyO/Z2jWOosoQPf7hwNIbojzfI9CxA4hcbSSXGT3BMfLY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5448
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 01:31:41AM -0700, Joe Damato wrote:
> Make it easy to figure out the IRQ number for a particular i40e_q_vector by
> storing the assigned IRQ in the structure itself.
> 
> Signed-off-by: Joe Damato <jdamato@fastly.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e.h      | 1 +
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
> index 9926c4e..8e1f395 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e.h
> @@ -992,6 +992,7 @@ struct i40e_q_vector {
>  	struct rcu_head rcu;	/* to avoid race with update stats on free */
>  	char name[I40E_INT_NAME_STR_LEN];
>  	bool arm_wb_state;
> +	int irq_num;		/* IRQ assigned to this q_vector */

This struct looks like a mess in terms of members order. Can you check
with pahole how your patch affects the layout of it? Maybe while at it you
could pack it in a better way?

>  } ____cacheline_internodealigned_in_smp;
>  
>  /* lan device */
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index 6b7535a..6efe130 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -4123,6 +4123,7 @@ static int i40e_vsi_request_irq_msix(struct i40e_vsi *vsi, char *basename)
>  		}
>  
>  		/* register for affinity change notifications */
> +		q_vector->irq_num = irq_num;
>  		q_vector->affinity_notify.notify = i40e_irq_affinity_notify;
>  		q_vector->affinity_notify.release = i40e_irq_affinity_release;
>  		irq_set_affinity_notifier(irq_num, &q_vector->affinity_notify);
> -- 
> 2.7.4
> 
