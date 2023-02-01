Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7561F686E63
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjBASus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjBASur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:50:47 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC8B3AB3;
        Wed,  1 Feb 2023 10:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675277445; x=1706813445;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pa4AEr3VyY/A2oV7W/waJiYb4kw8PWSZ6eDvslZ2ttE=;
  b=AY1OZ28MlR1FsF00/Ie+/6OlcTHKIq0puGn7fScnL3wL1Dt5X8HPOMHX
   TwRRdl0tetVCAjyinHninRzHkx9EKyTWkH4hiKKaYVlx8Isa3YTw0gWVZ
   1CCyVB+fOmtYLbhHncBs0NNAQc73mfDb9x6il0BCi2tfHSAt3LRDkTtVJ
   C8sx618mzqewXLhK1bMzW2+jVpNRMFvoqJ40Vmvyc88Ml/aX4Y7cX8WnX
   sTFZcap5omV/fLYpkoo3237eTi+l9s+CeHiRPBta1AtJumtyzkxVHJTzk
   n+sTTnVxkg6EA31wIfdZUiklCa8cg+Yl/7Awgk+cENveNbiNCe0k38Qvx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="392818730"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="392818730"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 10:50:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="728531844"
X-IronPort-AV: E=Sophos;i="5.97,265,1669104000"; 
   d="scan'208";a="728531844"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 01 Feb 2023 10:50:21 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 10:50:21 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 10:50:21 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 1 Feb 2023 10:50:21 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Feb 2023 10:50:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqESmp9959FbhMy56zJ9UHhtVMGgWjUt1eX4YKgtRXjXJqyHlaTJXWk5NsAyuWiqrCA4Tr1DypGPUcrRh6+r72jIu1gxx1rbv6A/vlaiWSE9dkHrB8aECPc7mekVTlAHLJPbjTPgUJ0o5bkGdkHkmpLiixflgX7gGkRjFRFd4AnAQjCGOtEXtLNwGbFgFr/kSKRnSQd0XLOaTFlhLyfF1++vHgXX037a0cpaH5ER7DVHL8t1lPIGHz7DtS7HXMPiA747C0tJU9p2xu+2xyfQ0xxpD5OKqQ1pJn2eHAC0JlZZdEdsqpdGxCte6misy7N6GyLRtqETedPPsncToEXnMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iHAoTcBZEg3KOXt+ZF26LEZN1UM+wlm4gZelG7u0SSE=;
 b=Q5tb9hQr90/pI3/7wEeesZKpN+0Mbwe2KdsBl2LkweX3mQwJujXHJlZ/EuNO67sf5fSOz0IN42UBvf3bBKmL8Jp0MaO5rm7hvVWfKrDozLTFZ1qrIwmMdkRR7y3PsZlqxUE41VRs2yBB/W7R4B+xR15nUDW9JZuzXs5HoS89ELV80U6vLs+C0XtpGyykDdGCBlpA6GoCaIBhYxgItcPMTSOkfV6nKFLbaW1ENbzq96juXbZJ2zdzR7ZPsRAYfFD6RscDKaPN5t7sd+mnQQx0Jf/+O7W3yGqNfPzRCblUIJSCQPLSs6G/Xg7MjcYq1e6mSXiIbkPCIAGt8im2G6rKHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MN0PR11MB6160.namprd11.prod.outlook.com (2603:10b6:208:3c8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Wed, 1 Feb
 2023 18:50:16 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Wed, 1 Feb 2023
 18:50:15 +0000
Date:   Wed, 1 Feb 2023 19:50:08 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Hickey <jjh@daedalian.us>
CC:     <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Shujin Li <lishujin@kuaishou.com>,
        Jason Xing <xingwanli@kuaishou.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [PATCH net v2] ixgbe: Panic during XDP_TX with > 64 CPUs
Message-ID: <Y9q0YDLVO+ndlaa8@boxer>
References: <20230131073815.181341-1-jjh@daedalian.us>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230131073815.181341-1-jjh@daedalian.us>
X-ClientProxiedBy: LO4P123CA0361.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::6) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MN0PR11MB6160:EE_
X-MS-Office365-Filtering-Correlation-Id: 62e3d168-3b2b-47c8-5aac-08db04852849
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: opyB3PCwt1KLcVv+tjK5uZphE7QBL99G9ICrhEWOKWP8yAbVve0FNGYnpCWes+ArBRwcYqiTNx4jGiF3juKhTZTBKMXTfJn1mvUhde1Ts+DlBHLpOm9ownGVCDRxVyKn5rchxE06x6yOkYvPZaU+DV35tGZKDcdlD5lsVXW6iuBVqRjn6rX0/V4/pIRA9IICR0hMLhp3PtR1T7oWWweiwFxyWi2EuTC34PHW+xuFDP3+bQ5SPMtjrX0JGgEdXJC+MJAMgicybvjOAy/WGKwt6Mjd5qkQZMe2GIT0BD6wgP9E80ucJVwyfFXAQpnmNN99/TEZXPl5lZU2NwDFjdCaArXsJjJV0ymRf69ntRjzpaLIDwAcgqSMMTP7tTIpmUXX6G7zI6JJoC37a7Aia9qIREsgvrwJwPnNHzb/Ht178pkMIjuezIlfrnWeyIocW4U+hOQVl5SwXbOLXxNLSmplkqxs+Xgy+hmAFs6MBAP/YenaGarIAFFfd1mMpCIOJQSr4K90NI9kKy/ptYxp/kF5VYG1ndZg05LvCFL4x+qQiQNuNegOeBASJwz9RBo7cD6rzCu0LiXP5/idE8g+/WlJTBRah5K4eKuqrnbgzh82t2UejCMFC+Hh+TC23GdCI1Q5dju595WE9erRDtpFiFWe/ykk+ihbMbBrd3eJsMyROWcoHyPOWPRnBnxjzxU24ZWjPeRSRpQTf+ya//cyHMGNfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(376002)(346002)(39860400002)(396003)(136003)(366004)(451199018)(83380400001)(66556008)(66476007)(8676002)(33716001)(4326008)(6916009)(8936002)(66946007)(41300700001)(86362001)(82960400001)(478600001)(2906002)(316002)(38100700002)(6666004)(6486002)(6506007)(5660300002)(44832011)(26005)(186003)(6512007)(9686003)(54906003)(7416002)(67856001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3jvsb3jY/z7cFAdL1gYW7RiB9TdIOcXE6/F0fPa7g6GlEBGoUcC8wo/Z619d?=
 =?us-ascii?Q?zZDBAUDRdgipRF7+yPl4ihPl7oUtej3tnS7EOi00FWGu5TaTeUO6AyU3VqdQ?=
 =?us-ascii?Q?sSqwiZ/OuwfcWJ14JOMj5UKVwdOBsTUsa//1zEqPcwtQHK66TxajQ//69eW1?=
 =?us-ascii?Q?vAxtpraEHdA7wkuiA/S0+iQRRL45PrJgcNd+qv151m0mqSuacy3dQ0J8d7jV?=
 =?us-ascii?Q?Th9jG1ONZtjRIWF15fwK2DZfHecYTRqnmHQfQ4Hr+aYKKjQmCwnovFlfvLgG?=
 =?us-ascii?Q?n3yI6FzqNL8fRwFjUu0KLyg46H05Zjf6HHLKK9Fbmfjbl6cCsEmFQNeRZ8W5?=
 =?us-ascii?Q?gxIfIpfuTKQoujuCEC9Zjb6/o3WsaflL7Z5WU2fOX4HYfrpKBsimPwzqGzLZ?=
 =?us-ascii?Q?WnlthTNiqNlZXUp4I7E3Faany88zTlzKqGCawIsWNtdJbNsOwFCrRf09Mntw?=
 =?us-ascii?Q?AfMaAYHt1r/BUEPkXWtrhzRDVRJoHt6UujXPgjvUQIWqxdLCD6wvifypwubJ?=
 =?us-ascii?Q?AiV7iR0jrzi2ZCDbdL1SPITfuu/jL4VBsxoPI1cS233aWMX3W9TgwXq4oTMe?=
 =?us-ascii?Q?GYTbEDEKK0PecdgDztY4aqlZCxNnqpKOCeVdu4QG+OqAFW2Z7nbHJWAPxxP0?=
 =?us-ascii?Q?Ojh07m9nyLglQtPW26ujcgOwONpgAoUexasXScO8g2Qf+5lAgdltyN5mbf9D?=
 =?us-ascii?Q?zoqNWoSDMF2zOO69qwNSqZWYgcgmTXYtqDWWET0dqMRL9dOUR1DTMbiETDez?=
 =?us-ascii?Q?ZrhMC3+a0CeX9beR7Ipe4Xkoqe+OurBwPpiio0ppE6o/+GUpHF4rkjSLP6Te?=
 =?us-ascii?Q?aNEh2Y6ilmTngIrl5P9yekdInlY9eVQIvEHQmXvXY2WiG+UQ6Dan1BR4DJHr?=
 =?us-ascii?Q?pFKdskqm4vmMrU1fi7CizT4/PaeS0bxl/k98AJCy/9dFeY841nonULxY+I9E?=
 =?us-ascii?Q?O7KwdEG5CmCZeHjYvf5g967wrIsdMubX/EdokSSPNgOim1bE0nXF33Fn9VkN?=
 =?us-ascii?Q?E+sa70zCTfsl7tIGfzIR91AU9HBXXDQZY55ORHT5AOzPqwXsVJ1zc0b+89dj?=
 =?us-ascii?Q?eUvSvjgjx9CqHGXjxaZ3H7bQFgpxfpa6oy23/Dg2/dFgmqjmRFIQ+nNCSbFt?=
 =?us-ascii?Q?98j36noSMsqZBqKRtO8KanmvACJZ/hRMWhjMoSOAQ84ccostKUaOki8OKYik?=
 =?us-ascii?Q?85+EEBi8MG1n/T4dt66ZAtN+N7It8fZnrB4nL0fRMItwD0lKTG2G0il9p6fA?=
 =?us-ascii?Q?BK61QnvxVzOAqdIJQrYtNLE5cE+bAkplllpanR1Gpwkp0HRyzwwBNYsn/jtI?=
 =?us-ascii?Q?UqIL1EisE5acekoZTIcT0k9rZgCRDreFBQ3X+Kic9H1NWnxMU2TEwJwvhzQn?=
 =?us-ascii?Q?4zoV6nRp6yOlxuW/46dmnZh42ofuynWPtp7tPtez3+ynJCvoNYIDJTYoDV3e?=
 =?us-ascii?Q?3PkNL1uhDrz+TMLf5utCIOb9cWizAVjHQ3Tx+fP1UQJDTfUr37f8YShtyG0c?=
 =?us-ascii?Q?OxAT6OnG3X83Pm23P+eza/MssaKYxvnps6zBk2EmOUk1NTJCPWLaXbGLcgrS?=
 =?us-ascii?Q?8tg8F+PHbezzp+rz7tN6Sc4outnijRDUlaDoh1DnHiduKqqHQAOTM3zln2As?=
 =?us-ascii?Q?OTEvE6eLJfZmaDxWwZ+AZGc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 62e3d168-3b2b-47c8-5aac-08db04852849
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 18:50:15.7989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rGCffO51ENve1UT1P+85e76TxdE571vJx3bYXLYvzkn8gALXr1n3QtafPTu7CItFun/r3clCFWIsWTOXUPgYlu8IOePlVJxZ+/jTDX4ZX/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6160
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 11:38:15PM -0800, John Hickey wrote:
> In commit 'ixgbe: let the xdpdrv work with more than 64 cpus'
> (4fe815850bdc), support was added to allow XDP programs to run on systems
> with more than 64 CPUs by locking the XDP TX rings and indexing them
> using cpu % 64 (IXGBE_MAX_XDP_QS).
> 
> Upon trying this out patch via the Intel 5.18.6 out of tree driver
> on a system with more than 64 cores, the kernel paniced with an
> array-index-out-of-bounds at the return in ixgbe_determine_xdp_ring in
> ixgbe.h, which means ixgbe_determine_xdp_q_idx was just returning the
> cpu instead of cpu % IXGBE_MAX_XDP_QS.

I'd like to ask you to include the splat you got in the commit message.

> 
> I think this is how it happens:
> 
> Upon loading the first XDP program on a system with more than 64 CPUs,
> ixgbe_xdp_locking_key is incremented in ixgbe_xdp_setup.  However,
> immediately after this, the rings are reconfigured by ixgbe_setup_tc.
> ixgbe_setup_tc calls ixgbe_clear_interrupt_scheme which calls
> ixgbe_free_q_vectors which calls ixgbe_free_q_vector in a loop.
> ixgbe_free_q_vector decrements ixgbe_xdp_locking_key once per call if
> it is non-zero.  Commenting out the decrement in ixgbe_free_q_vector
> stopped my system from panicing.
> 
> I suspect to make the original patch work, I would need to load an XDP
> program and then replace it in order to get ixgbe_xdp_locking_key back
> above 0 since ixgbe_setup_tc is only called when transitioning between
> XDP and non-XDP ring configurations, while ixgbe_xdp_locking_key is
> incremented every time ixgbe_xdp_setup is called.
> 
> Also, ixgbe_setup_tc can be called via ethtool --set-channels, so this
> becomes another path to decrement ixgbe_xdp_locking_key to 0 on systems
> with greater than 64 CPUs.
> 
> For this patch, I have changed static_branch_inc to static_branch_enable
> in ixgbe_setup_xdp.  We aren't counting references and I don't see any
> reason to turn it off, since all the locking appears to be in the XDP_TX
> path, which isn't run if a XDP program isn't loaded.
> 
> Fixes: 4fe815850bdc ("ixgbe: let the xdpdrv work with more than 64 cpus")
> Signed-off-by: John Hickey <jjh@daedalian.us>
> ---
> v1 -> v2:
> 	Added Fixes and net tag.  No code changes.
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  | 3 ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
>  2 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> index f8156fe4b1dc..0ee943db3dc9 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> @@ -1035,9 +1035,6 @@ static void ixgbe_free_q_vector(struct ixgbe_adapter *adapter, int v_idx)
>  	adapter->q_vector[v_idx] = NULL;
>  	__netif_napi_del(&q_vector->napi);
>  
> -	if (static_key_enabled(&ixgbe_xdp_locking_key))
> -		static_branch_dec(&ixgbe_xdp_locking_key);

Yeah calling this per each qvector is *very* unbalanced approach whereas
you bump it single time when loading xdp prog.

> -
>  	/*
>  	 * after a call to __netif_napi_del() napi may still be used and
>  	 * ixgbe_get_stats64() might access the rings on this vector,
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index ab8370c413f3..cd2fb72c67be 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -10283,7 +10283,7 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
>  	if (nr_cpu_ids > IXGBE_MAX_XDP_QS * 2)
>  		return -ENOMEM;
>  	else if (nr_cpu_ids > IXGBE_MAX_XDP_QS)
> -		static_branch_inc(&ixgbe_xdp_locking_key);
> +		static_branch_enable(&ixgbe_xdp_locking_key);

Now that you removed static_branch_dec you probably need a counter part
(static_branch_disable) at appriopriate place.

>  
>  	old_prog = xchg(&adapter->xdp_prog, prog);
>  	need_reset = (!!prog != !!old_prog);
> -- 
> 2.37.2
> 
