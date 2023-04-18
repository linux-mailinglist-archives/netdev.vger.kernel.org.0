Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7348E6E68E0
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 18:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjDRQDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 12:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjDRQDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 12:03:17 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12E5E44;
        Tue, 18 Apr 2023 09:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681833795; x=1713369795;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gKSLb2xfYv+FjF89AVtwDNgBygmfsQ2kxQI3j+sPs4U=;
  b=XTSjDaYjwvgZSFurFIeP9x23qdIO2KzxNpl0bGBoS6zON7d5fr/q3Qd4
   GVG53OLJy5ONISG/PDFjYsjVmXANusHmH0C/gq1iiG6ZmTa4y4LTaqUqw
   HWUZaZxk/lGut5UCUwV1ABC4K0HpgsTku26Owi3xLV7qq/D1sKHnbDP5q
   BgEnQYad+Qr1dr4I+DX1lEQqkMsRRM4Y1iSJuqwKAtWNGQx78LVmh+xJA
   xQYW/TfJSQIrjjCDW79gNEHoNucNH3pp+KZa4HDNJVaPvq536/v9/DJLc
   U/7xGTM0fFI6OkMgctf9uq5p4G7o2WXzyJTGRNH5fMujh5UYHUHAjuHwx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="408118878"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="408118878"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 09:03:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="723718088"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="723718088"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 18 Apr 2023 09:03:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 18 Apr 2023 09:03:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 18 Apr 2023 09:03:02 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 18 Apr 2023 09:03:02 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 18 Apr 2023 09:03:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=boKOYWKbu6godHWfsK1ms4CLnI4gU1K+LcduxkHQSEU18pbXEuXzmIHxLuN7T20WPkdYHVAB0gtNhkVbl1S1LzwJR2VtpFPpGGOXPX8HZT17GlsPycfBpcSshYDMGdobREPbWgvY4E4sjVX/eQvlVXG9Oit9IMgWQ7GUroTiJR6ANJmVQx5OxgOxhJcCUqjPu9HF83PkZAqE1GAzHrE7otI4dtDN1t7pB6RwBqXJ04nsQRtsYBOhcQ/5coindnrBBqY5ZGdLHavIIqmeeWuYWcUDaziD1DOs7D1wP8HxdXvqroV+UPB467cxsMvUtylts7G8HouP5MaX4QLwdfSxRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+nGIsS/ZFurzMHsyqbjCWm3z0W1YSj0+osQryD5IQko=;
 b=iHVpHOkZkjO29LZcgHqbPwy37uLTc3ob3HN0+s2FbY+R+ruTnVoyTdhUt+0eeeL1zRYHtRfrb6q2xIoKei4+x7jxX8KngPZb1baK4oxeWJt3H6vA0qY8RiWkTj6Gg3ltA2dugIMg3ox4O8KOxnrRc5m7Nh6hTQOXGEE5df1aRYMPy82uR/GN4vGdVchigLFtKJoeEmx80x2YHZ/zwj+hma3l83FEzMs6/8jjP6OPIeZJNCzLQie916UwQIV2QSk8CTlr3Hm2MkOrPT3vqLmgjyuDlSy+Xp314IXHUNIJdkG3x92Ak50/hYlG9zwTmbQBXFaJeEPFE5ajMBk8PRHGrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 PH8PR11MB8038.namprd11.prod.outlook.com (2603:10b6:510:25e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 16:02:53 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::f56d:630e:393f:1d28]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::f56d:630e:393f:1d28%3]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 16:02:53 +0000
Date:   Tue, 18 Apr 2023 18:02:39 +0200
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
Subject: Re: [PATCH net 1/2] iavf: Fix use-after-free in free_netdev
Message-ID: <ZD6/H9DotpfOxr1+@localhost.localdomain>
References: <20230408140030.5769-1-dinghui@sangfor.com.cn>
 <20230408140030.5769-2-dinghui@sangfor.com.cn>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230408140030.5769-2-dinghui@sangfor.com.cn>
X-ClientProxiedBy: FRYP281CA0001.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::11)
 To DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|PH8PR11MB8038:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d2521fb-f371-454e-dd96-08db40265de6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iSjcmh3BaakU6Ig0/jlDlyZpownXROIjFmuoHlAeIPVeWFLOrxoyR3CRD6yeQevZ1geJcuqhq9prqXd4YPy+J1RcyaVLrUzUNxs5jHB8qLvn2VIxH9/t1z528XmRhlurWn4BU8sWcFBfwOHXcFiKs0DdUkIHq7iXeJ0eszU3q43zv03e9St+XT9oj4B/nd6OfuDuNV4H4MXEM/x+VCa6o4dLvF3bHuZIMkIo+ZG0B8XWzUcFHSNvTgrCPtAp7Ydi6c236dGtFJKqGIEHx6/iu+Y7ueOgQKi2NdQ8qSscnWM5GeWuqgcUBljN37xvbyAyR2VzQCuQOWwKe1Sh5nlQrUjlp0hvUhcZL1aeS+Ia6xUBXlV4ZvVlSdowyI3ZN6IiLntWO1V+0buOyj2u5PlOhHHaxOZegCR2Isc7lkOJQEBi2b8/eDDeFdRd6tP8vGi2HuPTrKCU9xk9ShM0fPsckYF1e9SZzpf7LHG1kHPLk9vG2pjIcRstY72eRCKPYwUzSFxWNL5UohEbC9JlsVT9992irNc17+Sgijax4Fq67AQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(39860400002)(396003)(346002)(136003)(451199021)(9686003)(6666004)(6512007)(6506007)(26005)(186003)(86362001)(478600001)(54906003)(66946007)(316002)(66476007)(66556008)(83380400001)(6916009)(4326008)(6486002)(84970400001)(7416002)(44832011)(38100700002)(8936002)(5660300002)(8676002)(2906002)(41300700001)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?njN+IfxcR83nddzBvKy2XN8oCRwSgrN1m4FZja2m4J6FTaPQ2Uj6DpbBfLP2?=
 =?us-ascii?Q?4AvpMsMwwf9BTcLBhA51FoxbLNJymRgcj3hwTrYSpTikr5XlkSTwWRKsrJ8G?=
 =?us-ascii?Q?giSUfIrtbXt20P6l+xGaC4xK+C7nSDSqA7dz9c0jaiQwOdtUPb0hEheoYs8C?=
 =?us-ascii?Q?5zR6t9vCHkzMDzBFKZwLQUBcRSEiNEiQKhSzqvkMPpJuZHHmVlP8fhQLtj8N?=
 =?us-ascii?Q?9PNNdloUJmbaSFNFMVFNuAjib8tJBW+0qyVFl+955HQWFlEEiTQGAkHk1rli?=
 =?us-ascii?Q?y7q8ULhDFZgSLMHcT+PwrvYHdTInP1+uAiOBMGv//nTuVLKSet7REND7L83E?=
 =?us-ascii?Q?X3GPAmKXjI9UEYZWgkl+IfS0YTj9Sf1ITqiX8rgvGkYTi69Q5VhU8oqECLJt?=
 =?us-ascii?Q?5kyNK679JXtAE7VElm9kkKDxOHotJIjLow6Xqp/EGgiLj1c374qc9vK0f++G?=
 =?us-ascii?Q?XT+LwwIuWe0ccKvBJSDABjVbjsEeglxKleqSkkOad9WOib2GahadXqr3HHpt?=
 =?us-ascii?Q?z5L+zEDKLcIu8EdQYEsOBh3sHr1vt5+1P8E9NFrH1nyga1PebGxji69cfLlT?=
 =?us-ascii?Q?sxmIJcwwvj2enMfeSv2dSYc481VnkKG34/ynkL5N/qW8xnLXzZErVeM4tnXM?=
 =?us-ascii?Q?jFUC83UpTBLFFO/HC7EovqcXeXSDqE5yHklkfyDGCY9P5r1O1/qukeacCQc8?=
 =?us-ascii?Q?jm4Zfk+kyom2f1tQSQlFsQWtc69iPaBYCMfi7Ho0YpBWIXxnudlGbnZwsDvh?=
 =?us-ascii?Q?vgI8WMdEKq+WetSc3nr0N+r0zhbwLZF8YlhcuXgL+Tgz+77yIR4xwSyTC+0c?=
 =?us-ascii?Q?Q68Bz1xrJ7ecLYXfvE1+53WC0taSjNR18H9djeWZf/1zSxih7CN4kSErp+WS?=
 =?us-ascii?Q?eqYebkEMDIVbTP/Tj88yl7g0KZ3HrcbL3u5daTiy737LaIk0q6bJ1/2ZlWTc?=
 =?us-ascii?Q?qjD/SogUlUo3MzlMqU57J+bUN8EL/gIZ2XmjY2SgDlLpl2Rw8SD1YiYittDZ?=
 =?us-ascii?Q?aJLmRBLA7JR2kkj8/cZuNUP0ynITs2wUOn4hMiL/yB/wx1mOglIZ4AIAL3DC?=
 =?us-ascii?Q?YFTaVJtRX9wS7dnmL8UlF7D1dzxgAZQgPHziywdT3CQoSH+MuW3+hhcCKQ1L?=
 =?us-ascii?Q?G9juV3WjMDAiM8/DQWzw2AqYRTpbZVv+cYery4DA8veVASwj3b0vbymOgbW5?=
 =?us-ascii?Q?tD2VMuPONuCIM47ny25I1lu8ufgWH90fBul2bCkOaSLj76JmmAVLj3fIhzpY?=
 =?us-ascii?Q?kBL6gC4SoVOIbCSjmhd8zSwSoL6F5+vf7WWVcQMOiP1dWwnTX0YcDg2vUIrQ?=
 =?us-ascii?Q?EzihfNiW90rW1MppilP5SMFagvyFNDs12TO0lIAFNd/NHhzd6Hr9yOhdIVjk?=
 =?us-ascii?Q?vK+3Iixv/Qm08kverlT8zqiK7Fx8cwG3BAKBuZ9+cmZJRERmuO1w4MQsR09K?=
 =?us-ascii?Q?K+3kGlMExd8PqYNH7YLhYMJSXc7rKPUtKYgU0npsiguYKoH59RgFRZ/DmVBb?=
 =?us-ascii?Q?qHZeZXRhMP/T7Ji+In7rBOIY3LRgkGgrWEtIWmdL1cHmNmZnmLRyQgT+iNif?=
 =?us-ascii?Q?w0fVlS/bY1CTgrwk2EQbHpd5bnyioaSgmz9qfrK22Y6P717Ldqef1nc5gZUI?=
 =?us-ascii?Q?OA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d2521fb-f371-454e-dd96-08db40265de6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 16:02:53.3085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y+7W8E+gf6daUk79wSV4J61+G3ryiZHALq0NehTwLZ2hS6pYc/VcVJnQGT++T+gV0LP/My9g5Bu3fCwIayMn+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8038
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 08, 2023 at 10:00:29PM +0800, Ding Hui wrote:
> We do netif_napi_add() for all allocated q_vectors[], but potentially
> do netif_napi_del() for part of them, then kfree q_vectors and lefted
> invalid pointers at dev->napi_list.
> 
> If num_active_queues is changed to less than allocated q_vectors[] by
> by unexpected, when iavf_remove, we might see UAF in free_netdev like this:

Nitpick: the word "by" is accidentally doubled.

Also, I would recommend to add a description of reproduction steps (most
preferably a script or a command sequence) which triggers such an error
reported by KASAN.

> 
> [ 4093.900222] ==================================================================
> [ 4093.900230] BUG: KASAN: use-after-free in free_netdev+0x308/0x390
> [ 4093.900232] Read of size 8 at addr ffff88b4dc145640 by task test-iavf-1.sh/6699
> [ 4093.900233]
> [ 4093.900236] CPU: 10 PID: 6699 Comm: test-iavf-1.sh Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
> [ 4093.900238] Hardware name: Powerleader PR2008AL/H12DSi-N6, BIOS 2.0 04/09/2021
> [ 4093.900239] Call Trace:
> [ 4093.900244]  dump_stack+0x71/0xab
> [ 4093.900249]  print_address_description+0x6b/0x290
> [ 4093.900251]  ? free_netdev+0x308/0x390
> [ 4093.900252]  kasan_report+0x14a/0x2b0
> [ 4093.900254]  free_netdev+0x308/0x390
> [ 4093.900261]  iavf_remove+0x825/0xd20 [iavf]
> [ 4093.900265]  pci_device_remove+0xa8/0x1f0
> [ 4093.900268]  device_release_driver_internal+0x1c6/0x460
> [ 4093.900271]  pci_stop_bus_device+0x101/0x150
> [ 4093.900273]  pci_stop_and_remove_bus_device+0xe/0x20
> [ 4093.900275]  pci_iov_remove_virtfn+0x187/0x420
> [ 4093.900277]  ? pci_iov_add_virtfn+0xe10/0xe10
> [ 4093.900278]  ? pci_get_subsys+0x90/0x90
> [ 4093.900280]  sriov_disable+0xed/0x3e0
> [ 4093.900282]  ? bus_find_device+0x12d/0x1a0
> [ 4093.900290]  i40e_free_vfs+0x754/0x1210 [i40e]
> [ 4093.900298]  ? i40e_reset_all_vfs+0x880/0x880 [i40e]
> [ 4093.900299]  ? pci_get_device+0x7c/0x90
> [ 4093.900300]  ? pci_get_subsys+0x90/0x90
> [ 4093.900306]  ? pci_vfs_assigned.part.7+0x144/0x210
> [ 4093.900309]  ? __mutex_lock_slowpath+0x10/0x10
> [ 4093.900315]  i40e_pci_sriov_configure+0x1fa/0x2e0 [i40e]
> [ 4093.900318]  sriov_numvfs_store+0x214/0x290
> [ 4093.900320]  ? sriov_totalvfs_show+0x30/0x30
> [ 4093.900321]  ? __mutex_lock_slowpath+0x10/0x10
> [ 4093.900323]  ? __check_object_size+0x15a/0x350
> [ 4093.900326]  kernfs_fop_write+0x280/0x3f0
> [ 4093.900329]  vfs_write+0x145/0x440
> [ 4093.900330]  ksys_write+0xab/0x160
> [ 4093.900332]  ? __ia32_sys_read+0xb0/0xb0
> [ 4093.900334]  ? fput_many+0x1a/0x120
> [ 4093.900335]  ? filp_close+0xf0/0x130
> [ 4093.900338]  do_syscall_64+0xa0/0x370
> [ 4093.900339]  ? page_fault+0x8/0x30
> [ 4093.900341]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> [ 4093.900357] RIP: 0033:0x7f16ad4d22c0
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 095201e83c9d..a57e3425f960 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -1849,19 +1849,15 @@ static int iavf_alloc_q_vectors(struct iavf_adapter *adapter)
>  static void iavf_free_q_vectors(struct iavf_adapter *adapter)
>  {
>  	int q_idx, num_q_vectors;
> -	int napi_vectors;
>  
>  	if (!adapter->q_vectors)
>  		return;
>  
>  	num_q_vectors = adapter->num_msix_vectors - NONQ_VECS;
> -	napi_vectors = adapter->num_active_queues;
>  
>  	for (q_idx = 0; q_idx < num_q_vectors; q_idx++) {
>  		struct iavf_q_vector *q_vector = &adapter->q_vectors[q_idx];
> -
> -		if (q_idx < napi_vectors)
> -			netif_napi_del(&q_vector->napi);
> +		netif_napi_del(&q_vector->napi);
>  	}
>  	kfree(adapter->q_vectors);
>  	adapter->q_vectors = NULL;

The fix looks correct to me.
We actually call "netif_napi_add()" for all allocated q_vectors unconditionally
in "iavf_alloc_q_vectors()").

Thanks,
Michal

> -- 
> 2.17.1
> 
