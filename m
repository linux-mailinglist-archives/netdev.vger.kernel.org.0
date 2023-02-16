Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD6669979D
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjBPOjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjBPOjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:39:21 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC364BEB6;
        Thu, 16 Feb 2023 06:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676558359; x=1708094359;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=btBHx/yLWiclm0uxOljD8Oml0h+h7HuDc3PYcOxTJ+4=;
  b=aeicaj9HgcBfzrwztAJEQmdUfGsXMnsJOC9nViv6b5XOuB2rc9Qm1jXn
   jCjORHDT3/7LKboIeRZOC8TEa8iaNQbV4uEPq5uzFNiTvCsstNnsUyAOE
   BslENCTGpmFlpdjQ/dZxsuouyY4HLZPdo+GvVvW1L/nlHsYQ5yhfIDsn6
   M2Pu6n2YYP9Xw2/1ByhC6sU1YAXw6CM++FaeCmrrCtJvt56MQLTE9clNj
   9hpzneT9IPyDgWVoJkmbDjvmzoZYBJ4VRWJbVWV/nGrOa48e2QDjHF72T
   54YNRc3B9t0O9xhZKpL/2PQGxvoHVBzTkaRES63stllRc2DL+JZgZu3BA
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="331726661"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="331726661"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 06:39:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="999056179"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="999056179"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 16 Feb 2023 06:39:19 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 06:39:19 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 06:39:18 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 06:39:18 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 06:39:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5wwvHxs5/9yWIGaFa4gE6voLvQ/004a4l5krLul/ig4+M/X1BCyfrs0sr+MLWpj0GXLe5B+RcZfSkM1ho2Rc21b8JIvShF/TovhKXIcgT8skCY/6D9PLY4ktCUxuR4g6G058nhMPiFJINgPZxAEYw3ifhtRLqvjBglgbX0OlxQTg9lQmkJGDUoHgVz0KQ9I8qurPfVuhavcairhqQPTvVy75Cj0A9TdGXW2DPIGTXimK/4+CeXYUAzjCoXFlOF5UYvMUux8o2M0txqdC76HDuW2/kYG6Opp6cCmyblVCHusODdYBcRTYZVx/joJ+tjdrVRf001y1a8KKM7jHcccGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCTwYxaSAD9y9+0wPMCihIR3dOgaMKD/OuhoFdfAuXg=;
 b=VWYTfIsE8dcAAp4INvsTdykhHn1DNVUb6bXNpyqPpLnxEYCGsF9GJTU/5zeOB7l/xnWt9oNSZAiUELBytTk/IS2sf8KAJ7+aJBkAsRe6Z2BnsXL6PkOGIR7dGqHNoAnlNOrx98L6yVtvtorj90gxVa5CuBfcbRiiL3784utyZcfzjIlY+DYIvTYNA7hN5yA2d6Ul52Y/Qpl1hgYRYq31klDN7pw6nM3Fll9jgiBd32hjzGMDdaXAyJBUgS9/lqRnBbZOmK3piKEQJOYdHGemQuk+ePgApaz4efTWoRVE/XDrmeQ4122R4HuSki/CvjbHL3xovR4QJl7Zt7bAKsgytQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by BN9PR11MB5401.namprd11.prod.outlook.com (2603:10b6:408:11a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 14:39:15 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9%7]) with mapi id 15.20.6111.013; Thu, 16 Feb 2023
 14:39:15 +0000
Date:   Thu, 16 Feb 2023 15:20:53 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <anthony.l.nguyen@intel.com>,
        <magnus.karlsson@intel.com>
Subject: Re: [PATCH intel-net] ice: xsk: disable txq irq before flushing hw
Message-ID: <Y+47xTC/erlyKQtB@lincoln>
References: <20230216122839.6878-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230216122839.6878-1-maciej.fijalkowski@intel.com>
X-ClientProxiedBy: FR2P281CA0165.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::7) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|BN9PR11MB5401:EE_
X-MS-Office365-Filtering-Correlation-Id: a2a49e77-9ff3-49f6-8aa5-08db102b93f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LXRyFnJTfs2RK//KnygBm5aMT1b+l8aWb8sH5Hf6OOsVyW841ILKu9oz/GmExrGqD5q7gnVrTVlJeXVhkBHmffX3BqcIi99/BHwyAG6ui3YLOxHKWuQH2nVbPHU7UbfKf1gThhZzdSF3GsSkVnzztn/QoJRMEVey4kC4sif/WlaWbpKWZuRTv/Uhw2d34u/CFedqHWNEmoJGWWfn2qp1e94mbXj+yLN4o4zD7Aj+0vP2vvWqx8Z8B+8v1wM8Rd7f1h2uLezRqsykDPA4WWJtLZGfb7kJF6iFljsJCdWqBRZLG3U26HcJlR91zrYDn0kYXFYEYClrLff6A5hPuUoE5e0CvdbD8TmqxbSoCzcAacsf8pGHUp7Bs0HgP3ilmV06yyd+VWVv3jIH7T4YAiTpIdcNooqkkoFB0AfBdEgL01LoVBxlBoRioLXStXxpzjbFPBt5q+l4C/XyPNI8hpcJYaUvQ/kiWZZq1KqpX5s+hfzUlpebbvuHTY1Iesf3BtGAGGJgXvvjen1ZV6/RFv/jabTPNI+FIG3CAD9v+R6l7BCDImKp2bwRcjGnQJJNsZb7VOOvPFcq8p4zJfKScGqKGJu+yT9qGADCHNeRZ2pN8hIX88eiEccCId9fMSMFrJq5eyUzVQIwvfgiXoRkSSi1cQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(376002)(346002)(136003)(39860400002)(396003)(451199018)(6862004)(6636002)(316002)(6486002)(86362001)(478600001)(2906002)(38100700002)(82960400001)(107886003)(6666004)(6506007)(186003)(9686003)(6512007)(83380400001)(26005)(44832011)(33716001)(4326008)(66946007)(41300700001)(5660300002)(66476007)(8676002)(66556008)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lbfkj/LMET+U02lIj0CzQOyxPzp/q+oOs21F/RUSNJUtrED2JoLdC47Pny82?=
 =?us-ascii?Q?wyJeGHrroHUm7eGJxOc06ZzUg99vNxViWxoxpxCtsqBIfD57fgD7/MXRfqoc?=
 =?us-ascii?Q?tdGSmiE3BC5tiSwYBca3QfzAW5Um7PsxdLlti25yMu49CbvmUZDilpJz+Qtk?=
 =?us-ascii?Q?4c5YFYQWAIyEB0PyQrImLyzGDp73TgBTE84MjIPZI7Vm7ihI3FOmXM4dvTk4?=
 =?us-ascii?Q?fwf9yxmcAdV58+lhAAk/aSUx3U9U51EXTR15Oyw6vFGqCzwpTLQr+o8SyP8T?=
 =?us-ascii?Q?cJ2y+vhRFegSmnFCQn6tWD/Ozn8sRgtfJoMh3ymynLsl7JL644ytlBR1Y/MF?=
 =?us-ascii?Q?rpzUBf7ymDlhWT6p/Kl/EdTLcWkn+tN2qbfjYvIvpQjTG9EdyKy7B+9VDZbs?=
 =?us-ascii?Q?veI9aDtlVWmYXKG56x9sdgJaGEsZDyAcPofonxBsjxwoPWfZU5J7dPCqFdas?=
 =?us-ascii?Q?PtZycOVoTebGxcR42URjVxRv0oKGgySf42XtCjEfLTy0KhDDg+RdzgtNypD+?=
 =?us-ascii?Q?yGZijYpdd6bFLHXeQzQbVKJA6M0qgv4YDO8H1Imc05lW8yrBZK619OEyGSgY?=
 =?us-ascii?Q?2rzqClVZ8bCT98TWL2yqY6CV9xUWKZO5L278Ia/SIiZeIsLHFMJZjre/BHxn?=
 =?us-ascii?Q?A6ktrvpIbn/2gTMybG5FjY2Dipqh2wFq4Y0sCywrPKkfa4FHxYiaLuUpH7fU?=
 =?us-ascii?Q?nIQ9Y7QxGzG8WYtERacrOkSIsNjhNoBDqQ/nXGDTaxeMmlLr4oXcAW4cpDuT?=
 =?us-ascii?Q?QQdBWrp/S+5M9His4hjjbLWK4TLzR588+f/6P+MktlAWPlAhwwKl93i5EI/j?=
 =?us-ascii?Q?WxmTmlnKgGiqlFCSoFiC4QANdu4Q9tCKYq2T9TM9sDb7/vqfQtISHTMf+fHR?=
 =?us-ascii?Q?1VGkfAZhfsc/XtEP99MWDDj0PYwxoYOoKVEwm0sTX6kuZN0S4jllvDrtF65u?=
 =?us-ascii?Q?bWqCEFR4qdc0z3NLhaaTbHWT1iIKPTTSUdakMRMD1p6HmOiI0ck7t1Co7BJT?=
 =?us-ascii?Q?QHDUjU3GHeXDeiuR2hVFclCVOvjl9y4kWSsTm7d75tdfYUv41jN1vIDZhpo3?=
 =?us-ascii?Q?4Es+DIk0C53oDQY7f3QON2CR82iOnmneUue5ibbvAiMLmmMLmKYdvGA0Rdk1?=
 =?us-ascii?Q?sP8tS+ob9YqlZItxOsC4jPDcWxmp3eyVMZ9TSN97KomiLAKEGrPABqM2P+5W?=
 =?us-ascii?Q?6dUS9NMEUgzAezVvsI1GBUaKX/iZeC6AXuFipbWHT3jOEjfGZalBNdBsoxWt?=
 =?us-ascii?Q?vVLMocAYrIka4gysfLHoXVYwIrcsK3n/Y9FqH3OdVh6AY9rcidvUVxV4M8dj?=
 =?us-ascii?Q?MRwDL66VO0mHdZ6QMJUbHsN9aFL+v/jaJHf748iPRC4AJ8CUjJhi/DwENHyZ?=
 =?us-ascii?Q?NmNAJrO4A6ZtJbXHhdoHvrXTt6Du9nmF1QSinz4OGswqrvD6HGcnquQIvV4J?=
 =?us-ascii?Q?FtikesvJR5tJdzpK5t/4KSfLy0QuzuVKCdnu51cwSrdXac68AKU9cZJ47daL?=
 =?us-ascii?Q?YDzUuhAxafPGJfi7A1b18oGZH7fsi3wi2vS5r8Q1fB0eSUuX7mVRUnJgvqiN?=
 =?us-ascii?Q?O7UJ3R2nIvPlryZzatBI+ZIQtMdqoyV9C6TfOwJWUqm6ekEnxm7JtHIQtN0g?=
 =?us-ascii?Q?4A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a49e77-9ff3-49f6-8aa5-08db102b93f8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 14:39:15.6952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3uQF64Nv3gnwuH1xvl/xZec+Wqbu5VZvMilqUU1jIXqyzykngFtwDOW9W91uAJidjaVFuiThNlujk4vDqMUDnIaPDEGq0CI3gYRljPqbC3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5401
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 01:28:39PM +0100, Maciej Fijalkowski wrote:
> ice_qp_dis() intends to stop a given queue pair that is a target of xsk
> pool attach/detach. One of the steps is to disable interrupts on these
> queues. It currently is broken in a way that txq irq is turned off
> *after* HW flush which in turn takes no effect.
> 
> ice_qp_dis():
> -> ice_qvec_dis_irq()
> --> disable rxq irq
> --> flush hw
> -> ice_vsi_stop_tx_ring()
> -->disable txq irq
> 
> Below splat can be triggered by following steps:
> - start xdpsock WITHOUT loading xdp prog
> - run xdp_rxq_info with XDP_TX action on this interface
> - start traffic
> - terminate xdpsock
> 
> [  256.312485] BUG: kernel NULL pointer dereference, address: 0000000000000018
> [  256.319560] #PF: supervisor read access in kernel mode
> [  256.324775] #PF: error_code(0x0000) - not-present page
> [  256.329994] PGD 0 P4D 0
> [  256.332574] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [  256.337006] CPU: 3 PID: 32 Comm: ksoftirqd/3 Tainted: G           OE      6.2.0-rc5+ #51
> [  256.345218] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0008.031920191559 03/19/2019
> [  256.355807] RIP: 0010:ice_clean_rx_irq_zc+0x9c/0x7d0 [ice]
> [  256.361423] Code: b7 8f 8a 00 00 00 66 39 ca 0f 84 f1 04 00 00 49 8b 47 40 4c 8b 24 d0 41 0f b7 45 04 66 25 ff 3f 66 89 04 24 0f 84 85 02 00 00 <49> 8b 44 24 18 0f b7 14 24 48 05 00 01 00 00 49 89 04 24 49 89 44
> [  256.380463] RSP: 0018:ffffc900088bfd20 EFLAGS: 00010206
> [  256.385765] RAX: 000000000000003c RBX: 0000000000000035 RCX: 000000000000067f
> [  256.393012] RDX: 0000000000000775 RSI: 0000000000000000 RDI: ffff8881deb3ac80
> [  256.400256] RBP: 000000000000003c R08: ffff889847982710 R09: 0000000000010000
> [  256.407500] R10: ffffffff82c060c0 R11: 0000000000000004 R12: 0000000000000000
> [  256.414746] R13: ffff88811165eea0 R14: ffffc9000d255000 R15: ffff888119b37600
> [  256.421990] FS:  0000000000000000(0000) GS:ffff8897e0cc0000(0000) knlGS:0000000000000000
> [  256.430207] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  256.436036] CR2: 0000000000000018 CR3: 0000000005c0a006 CR4: 00000000007706e0
> [  256.443283] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  256.450527] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  256.457770] PKRU: 55555554
> [  256.460529] Call Trace:
> [  256.463015]  <TASK>
> [  256.465157]  ? ice_xmit_zc+0x6e/0x150 [ice]
> [  256.469437]  ice_napi_poll+0x46d/0x680 [ice]
> [  256.473815]  ? _raw_spin_unlock_irqrestore+0x1b/0x40
> [  256.478863]  __napi_poll+0x29/0x160
> [  256.482409]  net_rx_action+0x136/0x260
> [  256.486222]  __do_softirq+0xe8/0x2e5
> [  256.489853]  ? smpboot_thread_fn+0x2c/0x270
> [  256.494108]  run_ksoftirqd+0x2a/0x50
> [  256.497747]  smpboot_thread_fn+0x1c1/0x270
> [  256.501907]  ? __pfx_smpboot_thread_fn+0x10/0x10
> [  256.506594]  kthread+0xea/0x120
> [  256.509785]  ? __pfx_kthread+0x10/0x10
> [  256.513597]  ret_from_fork+0x29/0x50
> [  256.517238]  </TASK>
> 
> In fact, irqs were not disabled and napi managed to be scheduled and run
> while xsk_pool pointer was still valid, but SW ring of xdp_buff pointers
> was already freed.
> 
> To fix this, call ice_qvec_dis_irq() after ice_vsi_stop_tx_ring(). Also
> while at it, remove redundant ice_clean_rx_ring() call - this is handled
> in ice_qp_clean_rings().
> 
> Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")

Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
> index 917c75e530ca..6b8aeaa32d0b 100644
> --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
> @@ -184,8 +184,6 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
>  	}
>  	netif_tx_stop_queue(netdev_get_tx_queue(vsi->netdev, q_idx));
>  
> -	ice_qvec_dis_irq(vsi, rx_ring, q_vector);
> -
>  	ice_fill_txq_meta(vsi, tx_ring, &txq_meta);
>  	err = ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, 0, tx_ring, &txq_meta);
>  	if (err)
> @@ -200,10 +198,11 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
>  		if (err)
>  			return err;
>  	}
> +	ice_qvec_dis_irq(vsi, rx_ring, q_vector);
> +
>  	err = ice_vsi_ctrl_one_rx_ring(vsi, false, q_idx, true);
>  	if (err)
>  		return err;
> -	ice_clean_rx_ring(rx_ring);
>  
>  	ice_qvec_toggle_napi(vsi, q_vector, false);
>  	ice_qp_clean_rings(vsi, q_idx);
> -- 
> 2.34.1
> 
