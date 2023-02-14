Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62EF696BF1
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 18:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbjBNRne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 12:43:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233142AbjBNRna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 12:43:30 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3AA2CFCF;
        Tue, 14 Feb 2023 09:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676396605; x=1707932605;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=s/32x73Gens6ou7TdCHyKRRFFzj8rPEDXxivXvNDZ6g=;
  b=NKd4KOiTgr6GVillocvimQGpmJ1vh0n1Nsb7xuRR+jGcgjoEuzKjuqWp
   yZr9maOdbtV0LmYDjv30CK3gS4fYB0dMhWzZo4wHRFuypm8TGwvWh8tFI
   7NRHPPk/k981tDZpoevA7FY2JMmwmkuZXj8Yo5ZoyXnBIsh1VM4JLYDcV
   HzerkMBLrhOYv7AogKRoWxpY42jHQAa2PkUasfhi7hJnkmk9txEQKPJi9
   8VDftIzAwuSuzPvKpXXa+hLiWXNE5hI/EAxd0Ioy//qZ58fgW1tZR5XLZ
   zyTXam8QSD1iGI+BoDly+zZWCZMEjqy/L7tv1N1TjuuDGkc6ufCbh8vbj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="417439215"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="417439215"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 09:43:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="662621620"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="662621620"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 14 Feb 2023 09:43:03 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 09:43:03 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 09:43:02 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 09:43:02 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 09:43:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpH2Y1rkyOLlFbLsln0iVjyvbyY0Fh5IRgUKASMnnVqIYaFCt0J+fn5k3mm0KhPstA1ofMGR+4ceFAESiZpX2miYfc+nxzfBpTXrilWatgkuAWPZ80FQuvoBPE9sL2AEGSxNL1AiIqtYpw8GYoCvx0ILEZz9OwKyhu/88mjhhE8bG5RL4gqpc1DfIhm5ROMy0lOVCSK/jC2pSPPszDYyQ/G27WQmAkkQew31WaI3Mi7zcsWFH032HSPDJBew0V9k/N3hDEUp0bQ2vZzNd5HYkKceTwx3u/bKsgzwMCteNezSrn/ZoQnUoZdHnxayNQH8+61k3+ADZyWtuu4KxTF7bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WmbgsEklrs17uzT+8Fg6gmqLtZa6CqX7fpSHZ1swR08=;
 b=bDD1S8VpBB2GADTTJvFP6fyCy3lkon2dhNfG8effPOWjS08wi3E/13RyhoQS0+ZATyAZ8o43kSgCy4WlmYSF36LK/I+FHF8ebGv8h9mQS0xQbN7/drhAn8/9w543s1VK7aMaJWJO8IHwyMPs3steP4lsQKyRjOO0E8jzctwHuLcnRKCG37quEH6g6L3DfJf9zWh0i5y90XDh+k/G9WXI9UuDtl8/GbAAgCQEenMSfeFX76WwWuahTzuyAbIpYn+lUHtfNH4u/lJNnx/HJu0JREIsFsRlGvRZTnEXBjOkr/inSz+91elqPCvMLMjomtXr3aD8eoFm3RL6n4nefLJz7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24; Tue, 14 Feb 2023 17:43:00 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Tue, 14 Feb 2023
 17:43:00 +0000
Date:   Tue, 14 Feb 2023 18:42:54 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Veerasenareddy Burru <vburru@marvell.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aayarekar@marvell.com>, <sedara@marvell.com>,
        <sburla@marvell.com>, <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 2/7] octeon_ep: poll for control messages
Message-ID: <Y+vIHjaUvkWXw55x@boxer>
References: <20230214051422.13705-1-vburru@marvell.com>
 <20230214051422.13705-3-vburru@marvell.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230214051422.13705-3-vburru@marvell.com>
X-ClientProxiedBy: FR0P281CA0015.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::20) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MW3PR11MB4748:EE_
X-MS-Office365-Filtering-Correlation-Id: 02fd4aae-2e8d-4517-c456-08db0eb2ea49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: saGNx6v49XnVPongL4QbQd12u13W0UOS31EL9dnWXOa9ergU2RENpguoB57ozjGLrZ/turMxR4oNVURDaPco1CjQtKpCjh3J8yejjnR/PE+HscPuYBSPRbUrmQSDI0WcPOy4GUxXqlXPHvRoVhSpOpBBxkzKEi/Uq3Ha7jnieoKCxxffdPSwIWXna452+QlfYFjTyNcnORt7YP18qrG9HmJerigrKE2HbpZuMWKgiZn0AdPPlnZyctMBTBo0WrY6RqoOsUbutO6ATGDXlQ/tVYKoHGNzbsEku60GRpszPk+kWc4yEcLzVbyMHpqeiaMwj3YADgGoPivuIZy9UFD/uj5LLLGP26pOqhKfHhuVKTi3fQE8LDYsHkafYkZsvL4CpofXeVFTfRGyDzEsGiW9/nyvP2wYIQq0fY7dJnQYYcynfkKLmCfcb1AvyFGt5nLHjejm1f/dD7WwH8/niQAxkO43dfLP5ZUMsZRmxCMeMZN7OxPp7tu0To/H1xeknFmxPtaIJI13vy6SXkxW9FaIybIoY4BjTmq8+1kYp0+ylay6Ekyv/yrEsdmwHkH6V4OWJOhOHwgRDiobhgEJki0bltNUgwDNwygcviu2OgKRtUJAzzQhzFwRsGpHlAyE13NgvZ8txC6FsR03v8FJ+uhsedb2zuGr+b879W0fY5LqHuIrHUmBWy5uvuwbKYPDgsxF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199018)(38100700002)(7416002)(8936002)(82960400001)(44832011)(41300700001)(15650500001)(66946007)(66556008)(66476007)(9686003)(186003)(83380400001)(478600001)(26005)(4326008)(6916009)(8676002)(6666004)(6512007)(6506007)(33716001)(2906002)(5660300002)(6486002)(86362001)(54906003)(316002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lMNS7d1ts1TegOSGSP2JJFQRwX5AonEafalKZoJ1x/lrEIrIE+1TlkFj41pc?=
 =?us-ascii?Q?/9jHRDm/gQX96BuTTCGrBmFOirwiJuulE8iz92xpBxGe4YNorqSZqXJu8Tot?=
 =?us-ascii?Q?j4yBYHKkr8rnK8LAMKzwGez0cm9V62tpJ29hFBmiKwjjJu3OV21ljIlyvrVk?=
 =?us-ascii?Q?sqdjlt422ECdOWpvQyzKTDQtJJLk0iDqn/z2sDHDfD2jF5GxRiwP+chqlb3a?=
 =?us-ascii?Q?T7CCis8JYqT9cesPuGfuiZ6p0xN2jpDUc/GdxOHFGY8cHN6PeDU0ucpMC9vH?=
 =?us-ascii?Q?3yKo+eQwR0q2m5prO42IFgoBORompH+He0xUmPcwghemlMNd5m5bIv/7Xkyd?=
 =?us-ascii?Q?MKk7JG6jDqUaLHwCBb/E1sV7YleDhm53cR8GWhby88DyR314quxM1pSGrZDt?=
 =?us-ascii?Q?QZTMSC2Mn3mSE31oziYAdnSYZqm/dSs7UVl9LLuH8jchMhRbi3AzUcZNVZh6?=
 =?us-ascii?Q?t3IPMzDiyAizz8k1jGQueRT7MRXFxrVyc0qLLXYfHA2Fb5Tv4XuCucfZVWLy?=
 =?us-ascii?Q?8xLfntn3GRuIuRLt8d7VlUqGmSxDZBDVsZmBdU+5fkJ+/N0cGyleu1UhGMoK?=
 =?us-ascii?Q?mbsO/T2fH6XaJPodZyD/mqzzVReQ2vEn7HgmwWllH/zoDrRY58dBJW6Sn75J?=
 =?us-ascii?Q?P25D7ftYvKzZSefjCZRnUqaVfyLZNnjJIhRHcxtGt3aiaZNX9FdhV/JLrubj?=
 =?us-ascii?Q?BCrDP3583TS1WQBT/CH+uCbNewzaSGJsOKpebrtdSVb/CnD84wLF72FMNGff?=
 =?us-ascii?Q?D2PJyNoBaxS9u0+G7P4v23vXfK6wtULXfAylDSoh+1mr2VG3CzCjXGW8X8UA?=
 =?us-ascii?Q?Q0Slr2mmS11PuRG/R3kRVdKa+hpTP+nAN2aWN5h8nDyWoTEga95GmhFyCkFO?=
 =?us-ascii?Q?2NcXBZIEYwQnI3X7syFPRAji123KBy022vTgT+GHvq0t9Bcly9/XR8JMpApx?=
 =?us-ascii?Q?dCDUY9MuXUZqKqcbiSQtXdRRhVLP6/3jql/ROw6g8oPJXgOVXjOd1lyTJyRG?=
 =?us-ascii?Q?pPjX0TqYe7OncxmcXMhlTLoKNIU2L9Yl2boRqiBdlaMDnKoOxsbvYJazhGBf?=
 =?us-ascii?Q?KJnz+FMwA+r1sENosL/GMqO0wJ6k8+j7ikzgVMngu1/6PZDHxE4NvwX4dhfK?=
 =?us-ascii?Q?7ouMkpCUvMVyddlJGnQYUbqSuFAAyF9TTJ7yFwr4PgWZVp6TLtjXELvEI9nQ?=
 =?us-ascii?Q?FF9Zaj2FOBaMbq0vB7u2U7BNnvpcouqBMAssV/Z5dMNuTOZFU9p06Ud5/quU?=
 =?us-ascii?Q?9IgZJFXXDofi46xw7HOllfmYwexyOwqtqiFRouKbxlhZrqVEckOzwXusA1ha?=
 =?us-ascii?Q?+WLuZEmDdAA/9AYz9GhpbNGo+cOf1s5pgF0BltvD1R/8lRtvW8InwaURO8A0?=
 =?us-ascii?Q?gXJwks8scaLw/uyP7PAgu6yyVGeVWfBJs495L8sVFBwAiPlgkOVj+pCScq7U?=
 =?us-ascii?Q?uTHS3ZwkHn4WMLPq5WoQ24KlUHbv2zXpvx+E6aFMfG15qSta+flatWLOsPzM?=
 =?us-ascii?Q?aOv4IN6/EFAMoflh+ZqzteBKkWirOsHkmMpKHVvg05wGeB28HPnlLBg7HEeG?=
 =?us-ascii?Q?VhpfnDuVn/WK38o2IGpmTbX39+Gf+Ad2i0CJg5xGqtdIJ0Su902VriVcc1Zx?=
 =?us-ascii?Q?RT5HNSh4wPE3GYMl23S5+Gc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 02fd4aae-2e8d-4517-c456-08db0eb2ea49
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 17:43:00.3227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OxaMS8rYujBVMKLo5RzfXisNMcXPVLeW1PshZ/vZbSBk0ROKJDs5XZQq1E4XFIGyPSFgatiACJdiYpNot7Rb1ByLTkjYynVayhaEYPBYQkE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4748
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 09:14:17PM -0800, Veerasenareddy Burru wrote:
> Poll for control messages until interrupts are enabled.
> All the interrupts are enabled in ndo_open().
> Add ability to listen for notifications from firmware before ndo_open().
> Once interrupts are enabled, this polling is disabled and all the
> messages are processed by bottom half of interrupt handler.
> 
> Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>

small two nits

> ---
> v2-> v3:
>  * resovled review comment; fixed reverse christmas tree.
> 
> v1 -> v2:
>  * removed device status oct->status, as it is not required with the
>    modified implementation in 0001-xxxx.patch
> 
>  .../marvell/octeon_ep/octep_cn9k_pf.c         | 49 +++++++++----------
>  .../ethernet/marvell/octeon_ep/octep_main.c   | 35 +++++++++++++
>  .../ethernet/marvell/octeon_ep/octep_main.h   | 11 ++++-
>  .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |  4 ++
>  4 files changed, 71 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> index 6ad88d0fe43f..f40ebac15a79 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> @@ -352,27 +352,36 @@ static void octep_setup_mbox_regs_cn93_pf(struct octep_device *oct, int q_no)
>  	mbox->mbox_read_reg = oct->mmio[0].hw_addr + CN93_SDP_R_MBOX_VF_PF_DATA(q_no);
>  }
>  
> -/* Mailbox Interrupt handler */
> -static void cn93_handle_pf_mbox_intr(struct octep_device *oct)
> +/* Process non-ioq interrupts required to keep pf interface running.
> + * OEI_RINT is needed for control mailbox
> + */
> +static int octep_poll_non_ioq_interrupts_cn93_pf(struct octep_device *oct)

return bool?

>  {
> -	u64 mbox_int_val = 0ULL, val = 0ULL, qno = 0ULL;
> +	int handled = 0;
> +	u64 reg0;
>  
> -	mbox_int_val = readq(oct->mbox[0]->mbox_int_reg);
> -	for (qno = 0; qno < OCTEP_MAX_VF; qno++) {
> -		val = readq(oct->mbox[qno]->mbox_read_reg);
> -		dev_dbg(&oct->pdev->dev,
> -			"PF MBOX READ: val:%llx from VF:%llx\n", val, qno);
> +	/* Check for OEI INTR */
> +	reg0 = octep_read_csr64(oct, CN93_SDP_EPF_OEI_RINT);
> +	if (reg0) {
> +		dev_info(&oct->pdev->dev,
> +			 "Received OEI_RINT intr: 0x%llx\n",
> +			 reg0);
> +		octep_write_csr64(oct, CN93_SDP_EPF_OEI_RINT, reg0);
> +		if (reg0 & CN93_SDP_EPF_OEI_RINT_DATA_BIT_MBOX)
> +			queue_work(octep_wq, &oct->ctrl_mbox_task);
> +
> +		handled = 1;
>  	}
>  
> -	writeq(mbox_int_val, oct->mbox[0]->mbox_int_reg);
> +	return handled;
>  }
>  
>  /* Interrupts handler for all non-queue generic interrupts. */
>  static irqreturn_t octep_non_ioq_intr_handler_cn93_pf(void *dev)
>  {
>  	struct octep_device *oct = (struct octep_device *)dev;
> -	struct pci_dev *pdev = oct->pdev;
>  	u64 reg_val = 0;
> +	struct pci_dev *pdev = oct->pdev;

why this move of var and rct breakage?

>  	int i = 0;
>  
>  	/* Check for IRERR INTR */
> @@ -434,24 +443,9 @@ static irqreturn_t octep_non_ioq_intr_handler_cn93_pf(void *dev)
>  		goto irq_handled;
>  	}
>  
> -	/* Check for MBOX INTR */
> -	reg_val = octep_read_csr64(oct, CN93_SDP_EPF_MBOX_RINT(0));
> -	if (reg_val) {
> -		dev_info(&pdev->dev,
> -			 "Received MBOX_RINT intr: 0x%llx\n", reg_val);
> -		cn93_handle_pf_mbox_intr(oct);
> +	/* Check for MBOX INTR and OEI INTR */
> +	if (octep_poll_non_ioq_interrupts_cn93_pf(oct))
>  		goto irq_handled;
> -	}
> -
> -	/* Check for OEI INTR */
> -	reg_val = octep_read_csr64(oct, CN93_SDP_EPF_OEI_RINT);
> -	if (reg_val) {
> -		dev_info(&pdev->dev,
> -			 "Received OEI_EINT intr: 0x%llx\n", reg_val);
> -		octep_write_csr64(oct, CN93_SDP_EPF_OEI_RINT, reg_val);
> -		queue_work(octep_wq, &oct->ctrl_mbox_task);
> -		goto irq_handled;
> -	}
>  
>  	/* Check for DMA INTR */
>  	reg_val = octep_read_csr64(oct, CN93_SDP_EPF_DMA_RINT);
> @@ -712,6 +706,7 @@ void octep_device_setup_cn93_pf(struct octep_device *oct)
>  
>  	oct->hw_ops.enable_interrupts = octep_enable_interrupts_cn93_pf;
>  	oct->hw_ops.disable_interrupts = octep_disable_interrupts_cn93_pf;
> +	oct->hw_ops.poll_non_ioq_interrupts = octep_poll_non_ioq_interrupts_cn93_pf;
>  
>  	oct->hw_ops.update_iq_read_idx = octep_update_iq_read_index_cn93_pf;
