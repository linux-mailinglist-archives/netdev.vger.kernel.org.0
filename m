Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E075F6E6922
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 18:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbjDRQQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 12:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjDRQP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 12:15:58 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0F7AC;
        Tue, 18 Apr 2023 09:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681834556; x=1713370556;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=cgvikGuuvQ+7lZMZcvS3qXZI/dzVtEb+gZfeju29i0o=;
  b=HV0nn/Q7os6DWvURt1QWIzVx2fZ7LY1Zf5xW+0dDex+N8Pk7Y4lLCbj+
   VZeG8+iXGHsSmhe5MeVk4tIW209r2ouln5Pe+zE+BESdmrKeXf6VmDqVr
   r0njAWK5bD1IFMYtxOJZZ2r+goEZRuLuBqh443paSDaohphW8y5yzixSO
   tUCwVmSytCL8N02ywf2W2Jph7nu5Ezr8jL20JWjJrzxgbBsyDSTz4CzlQ
   49JCqOvXaZxLkiRqAeDy8uA7BGHXld6H/yLmsts+WeGph6mw2Y6YmMilo
   GkflpcLxGUFKoVp3rbEe2myFLYH5S5TGWtcQBNui9a5+HzUUOgd9uSx+T
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="410443213"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="410443213"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 09:11:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="937306900"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="937306900"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 18 Apr 2023 09:11:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 18 Apr 2023 09:11:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 18 Apr 2023 09:11:40 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 18 Apr 2023 09:11:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JH0GsqqkMjoVkfAtS9auxK2Jno5DN13hR8pSaxUFeQEIua/wzm8CywfeYMaNRXErKcNbjaKNX06qhbH/3M7WrfFgvZsS6KOtP/z7s06pZvISR92QpDNmd/O5UQ/+nqEf93MvRX50Zj58gKXVXMt1X0Di0tBArLJ1GS0HSPjAjoz+ax74pn5xF7kj/fPNwWvz8fT/7SigpX3IoziF5nba9BAc7C/PTb+2bHYB/8SjAb16SXDwmg/BKd+KGolqypY0Q4hXC844KIxO1z6XfzD/SBt++7D/9k4y2JRAEuZANpnDvUnTfWI40Vq3prk9n5T0xdbeY2QpnmcIpnviaNgMKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqClXU8ZhoCYF0noNNZ2jlfnyWjC590lsNmJNMHZPDA=;
 b=EVp+OGtDJ/jFtOpn/TVVkhxRH0wOcrUbM7E6TEI4neD2Gujzxcu/0HcF6KKTwkUDayF1RQbumVMHB/3ftQ1ug2vZSr5hqkoA80bie/+MyS2nfbufqlW71J6eCaZ9+svT9C/YqeMQ0yzYhE4suAgRV2g4xzLWyr7d5mAwtCVJW3TslfhPbqwvqCL7rHi9Gh4QrjAUTfSpnX5WN/33vQndg2B8K2yqdU1MnmdcjvsSPUJviF8lsVfBkf0718bv4i0IDCa4r24S5ABYb0E7vFNLURGrSq0VWBltOSb17bAN3MlADPzEUwmhYt5lxNlnpSs+K+G0E8HBMYzRgAvA5EIMhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 SJ0PR11MB5216.namprd11.prod.outlook.com (2603:10b6:a03:2db::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 16:11:37 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::f56d:630e:393f:1d28]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::f56d:630e:393f:1d28%3]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 16:11:37 +0000
Date:   Tue, 18 Apr 2023 18:11:28 +0200
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Ding Hui <dinghui@sangfor.com.cn>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <intel-wired-lan@lists.osuosl.org>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <keescook@chromium.org>, <grzegorzx.szczurek@intel.com>,
        <mateusz.palczewski@intel.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-hardening@vger.kernel.org>,
        "Donglin Peng" <pengdonglin@sangfor.com.cn>,
        Huang Cun <huangcun@sangfor.com.cn>
Subject: Re: [PATCH net 2/2] iavf: Fix out-of-bounds when setting channels on
 remove
Message-ID: <ZD7BMI+OjggaQmZg@localhost.localdomain>
References: <20230408140030.5769-1-dinghui@sangfor.com.cn>
 <20230408140030.5769-3-dinghui@sangfor.com.cn>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230408140030.5769-3-dinghui@sangfor.com.cn>
X-ClientProxiedBy: FR3P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::11) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|SJ0PR11MB5216:EE_
X-MS-Office365-Filtering-Correlation-Id: d6577dee-8e5b-4ba3-0abc-08db402795c3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nr/DTFK8r70h3JTlFEUgWVv7JLY/t6ZhqyYvvhFasvyYpawl2W7D0SJZpRe3JN0UP4tfLmod08Pu6d9ESZ8LZgGzz9X3vCLGxGxA6hr7xqaqBO7ZOaz0TyRYYy9d09WiA8Y6iPU4th+3IFL8FiRwPvl2zRwilmFQi2t5EJ1CnUbbg11LSP8yH0Av0DH3oQSEazcdq+9FjOkWNVtcqYHa56YPiq8sFNHJhJgk7kIucQF9bWh4tnvRmSCdDt2OQUgsX86AuK9EkDB0tU9GuwNUsXD0yzuczJrWAP53OMSj4Jkwyl+K4T5KbdBVPueFV6Jqj4/BFummZlXT32SYvHGZj3hyIghuuphC14jUddGgwYT7dEQBL3QjZKECQNazFkP54Og40wp4/E8hW5YvYnhDicxZya4RY+2PyYAtlEufcoda+nFQe6CJbdK0++ErAtnMCwxvs9xiIVDG7JRT0LBgnvt89v2IN0OcmmIC4YTnUJbLcBqs2eWCT21j4WdueikcCcV4O/GTuE6HUfPD1/OWFA11qlZEKEsW8/+QKd36XyVIh7XPqN9Pslt5GjvV7F/RQzD7LpgsWDwUON4bACTv5C4Qkb1naP7ORXM3+k5GAto=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(396003)(376002)(136003)(366004)(451199021)(44832011)(7416002)(2906002)(5660300002)(8936002)(8676002)(41300700001)(86362001)(38100700002)(478600001)(26005)(6506007)(9686003)(6512007)(54906003)(186003)(6666004)(6486002)(84970400001)(6916009)(4326008)(66476007)(66556008)(66946007)(83380400001)(82960400001)(316002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WiM81t044IMSZeI0KWHbQW9zj4OSXgf+uytBjuWj4Zcl/vSGtcfouAHZmdlE?=
 =?us-ascii?Q?rbH1hIUlbl/cQbqWu9IzYHI9SFgRt3vrNTVr86lW5czvviqNdfz5dGNOmGz0?=
 =?us-ascii?Q?WaqfZHyy+KGh0YtRxdJi6m5kvnyQphfu7qA6/YbC63LyMEXdLP8AZFIYlaGh?=
 =?us-ascii?Q?Yap9qF1v2/pSJj9ntdq7Opt6uC+8U8t3KxND+uaGMkRp7SiQOIN+SaqX3edH?=
 =?us-ascii?Q?pT6WxEJvghKfewmWZLlL6ILrENCmeQQu1rE5avulUSx2Un6p6UlweZs5FfhG?=
 =?us-ascii?Q?azPh5O90XYsSvHautdGifc0YRQKUQgbjShiLmWZVyIsAGXUQIw8dwK29Jr8i?=
 =?us-ascii?Q?fKZRur29SUrpewNpGvLiS05gpQqn1NsBO4PxRRdHU2a67gbvjdwF5aMOPNQQ?=
 =?us-ascii?Q?gyiDNGBbwYXYUrPuximZxNB1uLLhACDKvdonPZfps0AG2EdkicdjJxyd2RKQ?=
 =?us-ascii?Q?UyKWMItbhbIXKZeLuBgMXwUTUjmZTnnSBM9omy6ZG6YtuC0CNmQ4/hQR00Dx?=
 =?us-ascii?Q?yn4fm8n+jTkZ2prV7ijTti6tqS0HaDwFbKg6HXbJIHwEoiTcr1m8pzCUbHjg?=
 =?us-ascii?Q?XdQhPel33EP/wf97x5+1Njkt/hbXkQ0g2ODhzT7CO2enm92k4YqUMsq67KZr?=
 =?us-ascii?Q?IChr6Jb/W7orGgUdRlG3Lp/91P74n+cryXMb0g+IzU3PJghpyNe611Zo4DNL?=
 =?us-ascii?Q?Mf5C2nxQB5l56aTsfFkVcSkvII2zlGYkdB2cpXLLHePc1UzEQvHEutqZGUqH?=
 =?us-ascii?Q?ul6/LMqifOEOAYX9WXNZV/5bVvsQVQwJBO0XpX2nuBTKSBZbXB7vsDJSOD39?=
 =?us-ascii?Q?0TURqtxubfYRMcaJJVQXkbR+aaRM/coJoFxetPtCl4apoYHB0DXI9TG45oJi?=
 =?us-ascii?Q?rNHiaARK1hYVQFOROpCTXhocJdehMj0nB4aayT/f8joF1NHa6RQZOn4vGoum?=
 =?us-ascii?Q?ETju3qNNlH/hNdrHVNGxDV/CNJQvo/bRUWZvw/7V1BE8Gzwhs+yXd5JTy65D?=
 =?us-ascii?Q?VF8hWjPEMXXXyc96G6MYO/5wYZ3zr/EcV72ukZEYR1kfOz8k6sF234UoKVYG?=
 =?us-ascii?Q?/GqkyvFtrzPyodMI2RlCxrdhzyfVtg4h2A2Ge/C8Q9Dfa+ceRulIBoSZAGSD?=
 =?us-ascii?Q?c350UF694nCdjENFj/E48lQ5HdM+dDf6Mo5hFxh3Yi47GUsY/J39NK/grvSC?=
 =?us-ascii?Q?Z98jkH8GoYrJk5uQtYvq1pLR7a/dczrC2g6UEhKeX5TaQBd2a6bjE2XO3g0h?=
 =?us-ascii?Q?5w4LMYdRt2RTwCe0AZpvKH2uRRD9BjR7t5gfTbkFZwL2rxBzy9XAwb5FsM4c?=
 =?us-ascii?Q?oypX6OftSvOvCIuhFL9L0Kp2K06xmHDsD9a9eCcYnIunNsXw/Usg87FV30sZ?=
 =?us-ascii?Q?ThjLe8tI08ix/XNm389SN1tZQlGOyWJiHC2DtsXLSaIdLG0BBIXZW6lC939K?=
 =?us-ascii?Q?6QhiWfMetTgvgrU6/CWsugS35ZiROqpXqkgcjxASfd6hVPRud0V06+pEAvWH?=
 =?us-ascii?Q?MT6lhOsg+EKdSMXe1zqs6/iTB3pm3tlSlcaUg4LxCTwKgpPiP88na8HlDlWt?=
 =?us-ascii?Q?Zq2g1jQHlrfa+Uf3dQb/ajdL2CQ//0WWmGBXGpC6qi+l+mYjZWjqpf079SOj?=
 =?us-ascii?Q?UQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d6577dee-8e5b-4ba3-0abc-08db402795c3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 16:11:36.5432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XnQp8asevoZll6zK/3xKZBhOkiAJgzzJib5YuZiavwzrbnC1GJ7FjI0cGFQJLOXsNLQL2ON5+Bzsl+En5PMnQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5216
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 08, 2023 at 10:00:30PM +0800, Ding Hui wrote:
> If we set channels greater when iavf_remove, the waiting reset done
> will be timeout, then returned with error but changed num_active_queues
> directly, that will lead to OOB like the following logs. Because the
> num_active_queues is greater than tx/rx_rings[] allocated actually.
> 
> [ 3506.152887] iavf 0000:41:02.0: Removing device
> [ 3510.400799] ==================================================================
> [ 3510.400820] BUG: KASAN: slab-out-of-bounds in iavf_free_all_tx_resources+0x156/0x160 [iavf]
> [ 3510.400823] Read of size 8 at addr ffff88b6f9311008 by task test-iavf-1.sh/55536
> [ 3510.400823]
> [ 3510.400830] CPU: 101 PID: 55536 Comm: test-iavf-1.sh Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
> [ 3510.400832] Hardware name: Powerleader PR2008AL/H12DSi-N6, BIOS 2.0 04/09/2021
> [ 3510.400835] Call Trace:
> [ 3510.400851]  dump_stack+0x71/0xab
> [ 3510.400860]  print_address_description+0x6b/0x290
> [ 3510.400865]  ? iavf_free_all_tx_resources+0x156/0x160 [iavf]
> [ 3510.400868]  kasan_report+0x14a/0x2b0
> [ 3510.400873]  iavf_free_all_tx_resources+0x156/0x160 [iavf]
> [ 3510.400880]  iavf_remove+0x2b6/0xc70 [iavf]
> [ 3510.400884]  ? iavf_free_all_rx_resources+0x160/0x160 [iavf]
> [ 3510.400891]  ? wait_woken+0x1d0/0x1d0
> [ 3510.400895]  ? notifier_call_chain+0xc1/0x130
> [ 3510.400903]  pci_device_remove+0xa8/0x1f0
> [ 3510.400910]  device_release_driver_internal+0x1c6/0x460
> [ 3510.400916]  pci_stop_bus_device+0x101/0x150
> [ 3510.400919]  pci_stop_and_remove_bus_device+0xe/0x20
> [ 3510.400924]  pci_iov_remove_virtfn+0x187/0x420
> [ 3510.400927]  ? pci_iov_add_virtfn+0xe10/0xe10
> [ 3510.400929]  ? pci_get_subsys+0x90/0x90
> [ 3510.400932]  sriov_disable+0xed/0x3e0
> [ 3510.400936]  ? bus_find_device+0x12d/0x1a0
> [ 3510.400953]  i40e_free_vfs+0x754/0x1210 [i40e]
> [ 3510.400966]  ? i40e_reset_all_vfs+0x880/0x880 [i40e]
> [ 3510.400968]  ? pci_get_device+0x7c/0x90
> [ 3510.400970]  ? pci_get_subsys+0x90/0x90
> [ 3510.400982]  ? pci_vfs_assigned.part.7+0x144/0x210
> [ 3510.400987]  ? __mutex_lock_slowpath+0x10/0x10
> [ 3510.400996]  i40e_pci_sriov_configure+0x1fa/0x2e0 [i40e]
> [ 3510.401001]  sriov_numvfs_store+0x214/0x290
> [ 3510.401005]  ? sriov_totalvfs_show+0x30/0x30
> [ 3510.401007]  ? __mutex_lock_slowpath+0x10/0x10
> [ 3510.401011]  ? __check_object_size+0x15a/0x350
> [ 3510.401018]  kernfs_fop_write+0x280/0x3f0
> [ 3510.401022]  vfs_write+0x145/0x440
> [ 3510.401025]  ksys_write+0xab/0x160
> [ 3510.401028]  ? __ia32_sys_read+0xb0/0xb0
> [ 3510.401031]  ? fput_many+0x1a/0x120
> [ 3510.401032]  ? filp_close+0xf0/0x130
> [ 3510.401038]  do_syscall_64+0xa0/0x370
> [ 3510.401041]  ? page_fault+0x8/0x30
> [ 3510.401043]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> [ 3510.401073] RIP: 0033:0x7f3a9bb842c0
> [ 3510.401079] Code: 73 01 c3 48 8b 0d d8 cb 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 24 2d 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 fe dd 01 00 48 89 04 24
> [ 3510.401080] RSP: 002b:00007ffc05f1fe18 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> [ 3510.401083] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f3a9bb842c0
> [ 3510.401085] RDX: 0000000000000002 RSI: 0000000002327408 RDI: 0000000000000001
> [ 3510.401086] RBP: 0000000002327408 R08: 00007f3a9be53780 R09: 00007f3a9c8a4700
> [ 3510.401086] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
> [ 3510.401087] R13: 0000000000000001 R14: 00007f3a9be52620 R15: 0000000000000001
> [ 3510.401090]
> [ 3510.401093] Allocated by task 76795:
> [ 3510.401098]  kasan_kmalloc+0xa6/0xd0
> [ 3510.401099]  __kmalloc+0xfb/0x200
> [ 3510.401104]  iavf_init_interrupt_scheme+0x26f/0x1310 [iavf]
> [ 3510.401108]  iavf_watchdog_task+0x1d58/0x4050 [iavf]
> [ 3510.401114]  process_one_work+0x56a/0x11f0
> [ 3510.401115]  worker_thread+0x8f/0xf40
> [ 3510.401117]  kthread+0x2a0/0x390
> [ 3510.401119]  ret_from_fork+0x1f/0x40
> [ 3510.401122]  0xffffffffffffffff
> [ 3510.401123]
> 
> If we detected removing is in processing, we can avoid unnecessary
> waiting and return error faster.
> 
> On the other hand in timeout handling, we should keep the original
> num_active_queues and reset num_req_queues to 0.
> 
> Fixes: 4e5e6b5d9d13 ("iavf: Fix return of set the new channel count")
> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> Cc: Donglin Peng <pengdonglin@sangfor.com.cn>
> CC: Huang Cun <huangcun@sangfor.com.cn>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> index 6f171d1d85b7..d8a3c0cfedd0 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
> @@ -1857,13 +1857,15 @@ static int iavf_set_channels(struct net_device *netdev,
>  	/* wait for the reset is done */
>  	for (i = 0; i < IAVF_RESET_WAIT_COMPLETE_COUNT; i++) {
>  		msleep(IAVF_RESET_WAIT_MS);
> +		if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
> +			return -EOPNOTSUPP;
>  		if (adapter->flags & IAVF_FLAG_RESET_PENDING)
>  			continue;
>  		break;
>  	}
>  	if (i == IAVF_RESET_WAIT_COMPLETE_COUNT) {
>  		adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
> -		adapter->num_active_queues = num_req;
> +		adapter->num_req_queues = 0;
>  		return -EOPNOTSUPP;
>  	}
>  

Looks OK to me.
Just consider moving repro scripts from the cover letter to the commit
message.

Thanks,
Michal

> -- 
> 2.17.1
> 
