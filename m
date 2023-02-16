Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF646993E5
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 13:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjBPMI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 07:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjBPMIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 07:08:24 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5516E55E45;
        Thu, 16 Feb 2023 04:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676549303; x=1708085303;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=GNHKLltTOTvcwKtiXNkTXQymyV0/0kUxC5QxeT6N9aQ=;
  b=DlpKDbBOtnb1Q+ENZmRHhk6FszrDC+HLflRHWBuZkETX0975MpcCxT10
   NsB+PGj3vlDCtMokqdNMNg/runYr7iE5MOXHK2T8p84A8B3SRWvxEbo7H
   S+B0zm+7u7RZlp4TA6hl2+PVs09bg3rfIU2vsDqQnj94B0ajC5HA7P4mS
   TsMVY/+Oyq90hZEXnbNf0INUg9oa0+KX7HvwZxTheHLJ1KajJ6n6lpAof
   /YbNJgTIYIqszbuyfqG/X0RVzcyXqiOKq09FGtdao9DUG9JC8tN5C8g1M
   VNB8aju3+/I7w6OAAwV53FdWiZ/IessUZLGX0xc9yOoiigv281QKcWW1l
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="394125155"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="394125155"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 04:07:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="670105810"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="670105810"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 16 Feb 2023 04:07:26 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 04:07:26 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 04:07:13 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 04:07:13 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 04:07:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Txt3p1oRXCYq9n8PpHMAhw3ZQv9OvQMzMEou8Xfe9RI+reEfN1pmfFVdW5Q+1Nsw84psB05hyjfm8E4vVJaAAYhlfrB+fiNu8tCD7Gpd6oszZ6L39wkNA73O7277LxWjH7YXXFGWZDn+NQlJcUIKl88OcW4Pc/L/H2a6Gm2daymPdQdAdKsUPvQ1V5yO+XREaP4BfUpPJleFj3k1vob0l5bMgMFCkaY0Zgv3alcdtJ2T2idt2nY31Nu6AyY/w/CENhclO3HKbYV7S77DV18u13uo8kdLCs3qVuvyO71GCOUiUg5BHyK0t17ot8lQ29tDUV6qww1B0Mms6msA8zHGZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QE5OXP64CoHhENYOttrWBg9ipbFNsTrbpaSX5ubaujI=;
 b=oVhT7WovP6as8Vc7KHr6AuX/qL4s2Zea7I8hBcJlwDHGfbdMyLhVc9Y8iMdhwznkE9tPiKfNatZFAB93/gKtSHpGBuAGDvpYrXLyhTq1drEylu2s7322YwfuTA4VHf93cHc8irDpS9eavSrhF2IYrusIuDtOB96S4icB1mKT6dpP07X3TJT026oJNEVXgTMCAb1QBgXNHPzAbalnhPTQK8pADvH6T/UAntDIA/zEcVPJihuu0B2vITTJLgjHcPNUf+X7xMYG4wNxkJRope/8LhPZQ4+MkNAc7R/5FRxI/H/DMcj9FlD5tlkSfb41ic3AHkteDsnXkVBZgjR6prSk4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH7PR11MB7720.namprd11.prod.outlook.com (2603:10b6:510:2b3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 12:07:09 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Thu, 16 Feb 2023
 12:07:09 +0000
Date:   Thu, 16 Feb 2023 13:06:56 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: Re: [PATCH intel-next v3 8/8] i40e: add support for XDP multi-buffer
 Rx
Message-ID: <Y+4cYNvEYKOb8Kzp@boxer>
References: <20230214123018.54386-1-tirthendu.sarkar@intel.com>
 <20230214123018.54386-9-tirthendu.sarkar@intel.com>
 <Y+u+aUJJ2EQYEdJB@boxer>
 <CY4PR1101MB2360B76C18FDEECAFE3169EE90A39@CY4PR1101MB2360.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CY4PR1101MB2360B76C18FDEECAFE3169EE90A39@CY4PR1101MB2360.namprd11.prod.outlook.com>
X-ClientProxiedBy: LO4P123CA0525.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::8) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH7PR11MB7720:EE_
X-MS-Office365-Filtering-Correlation-Id: 242e772a-e6eb-4c43-32e6-08db10165443
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IDm+pvWnzJ2m8fKfoxCPBacdJMBG6VheqJSrSToyaht7Z+snUpxyEYAlSnU5uroKbOUZGTG/8bL0TmCBiKHsvNBFnUq4BLC2adPMptscdtTfrcsEBON6zoyzhuZnZ2MUrkwjpytRCbfY0aKPklgYh9WwM1wvZVSdUwmz+Z6EKYGKSaNswpqA0WHCPMvmZ1vt4B85zENMcsIVGV6qIkWBXZygJ10doZtCODPVkYcOxOy54DgwvWLDgyWye1A7Du6F2ve8hgXpZKpWIESP0hirwlRRUwf2zx5XaHp1ARq7Ju5x0k62ZAIyjNdEwJjhQxKthsRPbAAzde7i0B7osmxJ5SUeZD7rfBrmj/KDn52FKErOumJDWM9pqK7EntqheAYM4/OmqaW+1DeXFbLLvEi9K2GfO/PT+72gdsgRo1/d/S6u62K8EgrChJxmpETP8fn3yGf0CJL9r8VVozTF+DNFqIjCVnfgZgR5KNR92uV8XVJ0S9fwv8S/9lFCAg8+RtJ2+bwgXNriprlDnKEYsYK/YW/0Ps96rzSq2t3fU7XWLXOBPFyCkXZLONdVt0cJYVVFamtZscsumLju+ZahrpQ5ZYOA13M+BDB3oiOGohKiU35lTYRwbSldJydo//nSVhZVRJHUeiXFR5QrHio2PgVvs4mA2IFCZ7NQDXQVZ8/aeULQJLORP7XXP95YqxxrSiwrO1s+xulz2gkvbsEvf6Ow2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39860400002)(366004)(346002)(376002)(136003)(396003)(451199018)(2906002)(107886003)(44832011)(41300700001)(6486002)(6862004)(186003)(6666004)(478600001)(316002)(8936002)(9686003)(33716001)(6506007)(6512007)(86362001)(5660300002)(4326008)(66946007)(66476007)(83380400001)(66556008)(26005)(82960400001)(38100700002)(8676002)(6636002)(54906003)(83323001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?baNgHYJfGFoK8uX6FBkTQ4EVfL+eK5KoJmo0J+1DkcQhPNU5MMjSiuMbhqeq?=
 =?us-ascii?Q?mJML8TtrAmbG3L+A5mEvo8Fuems04xPGntAHyUTByTe0+5wJRPl6kkgQg5Jr?=
 =?us-ascii?Q?XF1tSg5ppzcMncg67E2WeHZ7CXz8bVsCChJBdU2quiYSm1+qQDroR3Sk0zk9?=
 =?us-ascii?Q?ZpiN0ryWPP4JiSmLcmkmg1UaWElek9PVp/aZWb1tBkKYsfrZuVyjuNxfGuwI?=
 =?us-ascii?Q?PYjpITz3/v9i+wDmbr7RvL/oiK5WakesxwANZtvebWfJekiJiGMaIDlIlaxq?=
 =?us-ascii?Q?QamhYe4kbe0tAX6U2Mfe+AkrPJECoPPbvJuAzspodMCbXUOO7rWO0I9JFtiL?=
 =?us-ascii?Q?as5hKfhBeMPjvWAeqW5r99qeXzZm9epsty7uDcsyIfMj/G1nSPDKJcrlo13a?=
 =?us-ascii?Q?+vsacDhd9VfGESRdsVtipUj62tBXCmgvoWbIbf76wqFs/Oa/AyBuCJ9qUKjT?=
 =?us-ascii?Q?+cIkzlSrDI7BqHag3rHrPPIG0EdvVlGtxAlS0kgyezsJcpRLQnB5kf3BacB1?=
 =?us-ascii?Q?Z/V6ISo/9xk3jyrXGPVul4HnL01yu2CckqZ1fwYYt+GqL51TrAw2OiWIsHRb?=
 =?us-ascii?Q?7KBNqeETlMBxPYUwXECt4ZKZpRsz1F7rl/7R1FgiplcalycoQH8wgIGZOGUR?=
 =?us-ascii?Q?p8mEg2jGvWosw/iSb9XMIc6KYg2fsMj2GrGG6P7q5yikiQQUkaUWhA0QORnY?=
 =?us-ascii?Q?7qwhjR0Z+pm2F1/l4WkVhjWTbrptDPSJZ0Jv1SLezXlkLmGyfjV0mYy2uW8i?=
 =?us-ascii?Q?UX38zA9LTEzCFxchyVaDec3DAJVwYghkgMyLP+H18bHkx0p/km87ad7dLWeA?=
 =?us-ascii?Q?bAkXqis1dH4JYcrUioD2L9g0LqEEK/hIH7OViQZX5R7bJwRql5AoLNIfmLQU?=
 =?us-ascii?Q?PbfYn4H5NL1BcciHH97xBrZKzviqjcrZfYXT/SLmiLKvIuaSd61BZ4dQZlLj?=
 =?us-ascii?Q?wlKQMolkm9MrpQ8havE+kDX4UHtjYUDVBeJm+L+HUIiFMY/cDOmWhBAfxzdi?=
 =?us-ascii?Q?3pCG84rejVMmr/LcnXyhZ8LQuW0w7Y1UC4OidWWX4fzp3mSrAsf5pTQ3+9fB?=
 =?us-ascii?Q?Fm5XXKpkWXSUQQy/xr3JRSZyw41eGt3gnvUN5tIfIUWGyqIhC/l5xFcvTkWI?=
 =?us-ascii?Q?r5/vXL1TEbTKjm9ek5atObQ3ndaecpHPx/LMlC5JnTlrxrUQ2M0qz+HduNck?=
 =?us-ascii?Q?0y1Xld8BM9xCE0ClpRdC1R2R1lS2Jq9VdCojbr5FNu6eDLBFlKNQ8JhJtIVN?=
 =?us-ascii?Q?sfsqB26hVO2vY4Koj6CYZXW4fQysEK8pBb7XxBN+Lnyy5evAN7Cnmi5UYCsx?=
 =?us-ascii?Q?rf+1h/XB5bTBoP8EIhI3mpo3PuCc2/doDLURldc5Q7JqNh5VpMHgvkuZhmoG?=
 =?us-ascii?Q?9zU5H90moUBOkkikiTsOSAQnBg+YKI0zDOL5IdkHDu56JfexQ7VtbAs7Ju0f?=
 =?us-ascii?Q?wvtb2K0vFS7YFNAG6wi37Y76TvtEvpYsS3DA5fbzUoEP9YMwcr5GeKKhkiPA?=
 =?us-ascii?Q?/HdJ42CBtaCid1eojt40Yz5LgAJ++wpnt39hL8m93B8k+pOaJ4kvIB49pCge?=
 =?us-ascii?Q?1ibvlDloBRUjb9kTS3SJgC87zivja3Vrh2DdYZF40Zob9WoW29iKaLNKRK4S?=
 =?us-ascii?Q?lZzbgPg/gI0BtfV2kajFriY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 242e772a-e6eb-4c43-32e6-08db10165443
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 12:07:09.3633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SCJwRvgYFN6kV6a27gU3udLO1NpGScjE3fNWJMQk2vY9rLsuzj05nooK4dJIKk8Gv+f6oeTa5uzF/oJscznX9Bfj0tJ71Iu9f4dy2D18LMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7720
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 05:37:47AM +0100, Sarkar, Tirthendu wrote:
> > -----Original Message-----
> > From: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> 
> [...]
> > > Previously i40e_alloc_rx_buffers() was called for every 32 cleaned
> > > buffers. For multi-buffers this may not be optimal as there may be more
> > > cleaned buffers in each i40e_clean_rx_irq() call. So this is now called
> > > when at least half of the ring size has been cleaned.
> > 
> > Please align this patch with xdp_features update
> >
> 
> ACK
>  
> > >
> > > Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> > > ---
> > >  drivers/net/ethernet/intel/i40e/i40e_main.c |   4 +-
> > >  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 314 +++++++++++++-------
> > >  drivers/net/ethernet/intel/i40e/i40e_txrx.h |   8 -
> > >  3 files changed, 209 insertions(+), 117 deletions(-)
> > >
> > 
> > (...)
> > 
> > >  }
> > >
> > > +/**
> > > + * i40e_add_xdp_frag: Add a frag to xdp_buff
> > > + * @xdp: xdp_buff pointing to the data
> > > + * @nr_frags: return number of buffers for the packet
> > > + * @rx_buffer: rx_buffer holding data of the current frag
> > > + * @size: size of data of current frag
> > > + */
> > > +static int i40e_add_xdp_frag(struct xdp_buff *xdp, u32 *nr_frags,
> > > +			     struct i40e_rx_buffer *rx_buffer, u32 size)
> > > +{
> > > +	struct skb_shared_info *sinfo =
> > xdp_get_shared_info_from_buff(xdp);
> > > +
> > > +	if (!xdp_buff_has_frags(xdp)) {
> > > +		sinfo->nr_frags = 0;
> > > +		sinfo->xdp_frags_size = 0;
> > > +		xdp_buff_set_frags_flag(xdp);
> > > +	} else if (unlikely(sinfo->nr_frags >= MAX_SKB_FRAGS)) {
> > > +		/* Overflowing packet: All frags need to be dropped */
> > > +		return  -ENOMEM;
> > 
> > nit: double space
> > 
> 
> ACK
> 
> [...]
> > > +		xdp_res = i40e_run_xdp(rx_ring, xdp, xdp_prog);
> > > +
> > >  		if (xdp_res) {
> > > -			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
> > > -				xdp_xmit |= xdp_res;
> > > +			xdp_xmit |= xdp_res & (I40E_XDP_TX |
> > I40E_XDP_REDIR);
> > 
> > what was wrong with having above included in the
> > 
> > 	} else if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
> > 
> > branch?
> > 
> 
> For multi-buffer packets, only the first 'if' branch will be executed. We need to set
> xdp_xmit for both single and multi-buffer packets.

maybe pass xdp_xmit to i40e_process_rx_buffs and use it for buf_flip
initialization? also you trimmed the code, but in there please don't
define on-stack variables smaller than u32 (u16 next)

> 
> [...]
> > > diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> > b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> > > index e86abc25bb5e..14ad074639ab 100644
> > > --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> > > +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> > > @@ -393,14 +393,6 @@ struct i40e_ring {
> > >
> > >  	struct rcu_head rcu;		/* to avoid race on free */
> > >  	u16 next_to_alloc;
> > > -	struct sk_buff *skb;		/* When i40e_clean_rx_ring_irq()
> > must
> > > -					 * return before it sees the EOP for
> > > -					 * the current packet, we save that
> > skb
> > > -					 * here and resume receiving this
> > > -					 * packet the next time
> > > -					 * i40e_clean_rx_ring_irq() is called
> > > -					 * for this ring.
> > > -					 */
> > 
> > this comment was valuable to me back when i was getting started with i40e,
> > so maybe we could have something equivalent around xdp_buff now?
> > 
> 
> We have a similar comment for xdp_buff in patch #7 where it was introduced.

ah i jumped straight into the #8, sorry.

> 
> > >
> > >  	struct i40e_channel *ch;
> > >  	u16 rx_offset;
> > > --
> > > 2.34.1
> > >
