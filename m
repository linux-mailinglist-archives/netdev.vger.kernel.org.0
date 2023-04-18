Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E576E6D1E
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 21:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbjDRTu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 15:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjDRTu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 15:50:27 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2093.outbound.protection.outlook.com [40.107.220.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F0F83FA;
        Tue, 18 Apr 2023 12:50:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kk7IXQj1KGcWL/jb12it2PXyhwhKc5+C+8lEA3qPBh5XtZzFNCOyOh0ayAZrNBcxIc4QWrKQqEv5Oz+BBQh+sPDalX9qKy5dGMgvP/kYbmXgy8v9uo1koC5NnETGSAi6fZ7DT2A6+sGJFy1tqGFZ3JO9zupzDS23O8GjNIsRcQgEl3RUoQxcG4RWBKWYWpt4sOkE8UmYwgElLv3jBTaSMUDlYCgE6YywUZn2adgZmHuc1XG4A7+4Y8IM1bfpOXUvVGxR8DMGCve0IohJtf1QVRGvruXN6nl9gQq224RD89T/yS+fjNJEROgjVJNOmndna8AW0OoKR6VZzsvdnRMACg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zbb/iBhL6+xPgF7qw7UUcD8jyZ5RvuCMmCfXqj0d4Bw=;
 b=UcSLjwuhfAk7CpA4B5zj40qc8DUer6xXcuvC6TVlmsu4d5sKurX5G1/tSoR1Oc78NQSN/tU664lMi0xiCCaCZ3//2m7FpbffqZ6bHN/oVLfVAYtUwiYIa4wU9weWt9tebWSr/cgOk9RVzAbqR1zFydAfIe0QL9kNxNFcnUOHwMO8HgmlwHo+WioEXLk0oo2Kj4TvLbzWPegfVheUnBgQEF34HyquBpJh/rZvkWQV10XPx3MiOMDBAwkXe3LkHwgjEi5bbeVyvpko/TFMaJkS2/2yYfjjsotlXoR/xWRrX3F7zIEVWNnjVI+VKGmyyx2I9vMmNE8+c7DIVJ68LSegUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zbb/iBhL6+xPgF7qw7UUcD8jyZ5RvuCMmCfXqj0d4Bw=;
 b=Mq4ZGNNu5591YjR59cl4QO1HJ95ZEN5+E6uDSPWkXsRTsvCL44spte0mCRgg2aEGJKXLduTW9VX9lujugGLcfbfNDq3Le5i96zak+vSJHlzV+6xOnOETfG/cdUxin3R17/90MKsPMfYqPAy/p+KEgDroJLEnuhg7b0vxOAn1GxA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5999.namprd13.prod.outlook.com (2603:10b6:510:16e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 19:50:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 19:50:16 +0000
Date:   Tue, 18 Apr 2023 21:50:09 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Ding Hui <dinghui@sangfor.com.cn>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        keescook@chromium.org, grzegorzx.szczurek@intel.com,
        mateusz.palczewski@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
Subject: Re: [RESEND PATCH net 1/2] iavf: Fix use-after-free in free_netdev
Message-ID: <ZD70cUCsxoN0BTNK@corigine.com>
References: <20230417074016.3920-1-dinghui@sangfor.com.cn>
 <20230417074016.3920-2-dinghui@sangfor.com.cn>
 <ZD70DKC3+K6gngTh@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD70DKC3+K6gngTh@corigine.com>
X-ClientProxiedBy: AM4P190CA0022.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5999:EE_
X-MS-Office365-Filtering-Correlation-Id: 54af5f99-bc42-4063-9bc8-08db404621fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h89Q2yaSSVeDvUvJqeuvITfYetK70ZBlWPXCzalmYNfQRshagbsEJ9iGfOOaYl2FUb0VaVghrcACHXtiJNOQkoV2/mhFO3Qc92q0nzWk8wXN+d4yOFDTL5mIYG96AEcEeeZPMooQWKST2w7cx7d5abiiuY8nLw+S+8xtZT8qGOXb0k41aRLeYVQ8E59IcyC+/bv3F+F8VE46slZ6Bwg6sxDcBFfZlNpzx+wr6lLXOMbj0pHt5K8YynY0B/XwNT+52n4tJVPAXd8ENKqwuFrfoZEJklNLx3OFOv0WMER+uO2hOZErywGkfWIbPEAVY/A4U6nfmGtz4383QDq9vZv+JP90nHktA8M/2xTkz4Fse3Zl5pIu7DuXPLPUJ/2uzmH9hvRPeA8xJD0P/l84G9O7bYhvJ21BVw5qknUAJTEKfXl1TYGi22fGW6l7EsRq4knYtObO7Xg25a3bJA9hpGFLSvF6Fs+DvgZeG1q54+ibOBfmDfXHkDtMWo6DcxuGd894s/XD2ie6uktFZjU/ibvPaNfUkX0leY+EsCppKQVSHhB711hvW/wUDog4baAkxJar7cX94lwpIGs3rM6hfGndQEhgQoj3rchw1i63/O5ZAME=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(39840400004)(396003)(346002)(451199021)(66476007)(478600001)(6666004)(38100700002)(8936002)(8676002)(316002)(41300700001)(6916009)(4326008)(66556008)(66946007)(186003)(2906002)(84970400001)(6512007)(36756003)(83380400001)(6506007)(86362001)(2616005)(5660300002)(6486002)(44832011)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UpC7/1lzcE5tfJgw7bXoA3grdgcYiBs7qLj4lPsREY/RX/Bg7mIEcRZ1Oa1p?=
 =?us-ascii?Q?LF6hoXvx/dABhRllahNAAV23eZaZuT2sAkdsmVw9mTQ808Gp3RvK/nRMnM7L?=
 =?us-ascii?Q?W8xCf0rbA1pBYLvJuqS3eiUUOvx+JnIw5O5AnbWeRo4w2e5eueUKRvw2XX2u?=
 =?us-ascii?Q?gl36qVrXG7M77eIW9ivnDwpqrQlJeWh7UvaixuivPT2w9ARfghQQDupVhojH?=
 =?us-ascii?Q?LW8XDsDsxyKtwsEd0LVy+K1RBpp9rygzzFORMhoyVlA2i9LGNPhCZ8npkz1e?=
 =?us-ascii?Q?xFT4Hz5grJyMDn0MGqFrIogyab/4U1gufO/VoJRRT9fPl9BqalIC4PAAmgML?=
 =?us-ascii?Q?H1XNmoTmx000UtxBB5+tyLPZnompdIEaOBR63iz3SMDN9l6Gsj7tGkklXvOu?=
 =?us-ascii?Q?tOj5DN9Y2Ij2RP4OTdK10HAQVkmARnqOtylZIrRybP6MhOsRIlfrFo72PVOS?=
 =?us-ascii?Q?bYLleBhxRWLjgPvvXtinlWTAzqtT2sxYHFM+K0esPvMP+irOKbN7qf0Y2p1M?=
 =?us-ascii?Q?Bt+9LP3kaQs/NipKZ5BxpYLcjYX1DPFJz+pVymc9wFJL2oNWXxsUqJzvkR02?=
 =?us-ascii?Q?YJqucFCU5wyWrG3E43s52GCy9QHU8g1Tm9gXdemXL6Sd+CQaK5qvx9AwTQYG?=
 =?us-ascii?Q?+tzON4v7gh6jItB3b9Jfrx0ddbSLKT+B3xVnbkt2gZgtzHYwWWd60Nt/MDUN?=
 =?us-ascii?Q?aTBKTVyEMGgDRFa4ZUscbgF3uxOKhUhIUwdes6v9io5Gn8v6MgHQ3UTqQc2o?=
 =?us-ascii?Q?crB6XdR8XVJAZONHEhwQ4GFCjL4eMZZjife4tK6HhMTvEF/HeSAtIhuJMzoz?=
 =?us-ascii?Q?jWaEzvwvTG9ck3ltcRxuiFgM5xjKdgFg/4xJ9AqMDJNWduuPVewx8jFe0Jlx?=
 =?us-ascii?Q?Z4+WVM9HJTRj4jVcu21Cir/YvLrkNY+GYPDEX8Tn1o+1RI9xcN7BcZK8DfrC?=
 =?us-ascii?Q?k/KVDjGcBZIAt0oS9NCeYFNRVfj3E2iZL4xa3E+8oTA4NGPCDutySt0XFFWB?=
 =?us-ascii?Q?ReZqXajE/n7t6X6OtiVwmz5w+WlBU1Qu2vVHTjpIRrcRO9/WmqOe4LPzj1Tg?=
 =?us-ascii?Q?A+p+NWO+KHBWZtGIAxfOXp3pXJxv3ot6RFcZpLmJR/7iJvRZ4V2k8BS85xPc?=
 =?us-ascii?Q?okvk2Af6f//cMjVjOicNf0dnvEB9ywjsHARym+Qa4rlitA2GZy2OkyKHBRve?=
 =?us-ascii?Q?SgX9bBgNekS97y2fpGHSXA/neefcoHZae96ivjR3md+U5TEtbmOx65NzIl5D?=
 =?us-ascii?Q?EDdtmVK8JqGY/XF2MjTUe7pOexPRjQuWcps8dsvCqK8uLIzD99o7SJLRSYuc?=
 =?us-ascii?Q?Tmd7aiitbNvVcHNwAkzyqnQwWmae1689zgq6R07YPnPtCjzbEvbbDAfGQREb?=
 =?us-ascii?Q?nq8239mOsBnjhaY2EKgy9E4nsH+FfC3kH2/YYMyyL+H66FEtq26Mt+vfSjOR?=
 =?us-ascii?Q?MnlmixPCSPl9ZfZNGkuU4sn+0YC0X8xF9Twg7s5wmg4oXHkGWc508COkf6E6?=
 =?us-ascii?Q?8LPeScH4hWg8m/ikUeD1pV378k3oXPC3aHoDTEdeJ0/qSikI/dRXJ/WJGiLj?=
 =?us-ascii?Q?tOYbCNAOLcDcPBwfx9wJtb+lhewg6sfaHFR+biD6/xiUdX25r+nsS/5aoL2M?=
 =?us-ascii?Q?Ru7G2N7zCd4Bk5DO5q+BYlozAvhKhfeqlLzUE9UBAwhENGv2ghJtg+8i2PMH?=
 =?us-ascii?Q?0GtpUg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54af5f99-bc42-4063-9bc8-08db404621fb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 19:50:16.8302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d3+bgns7h4MjJe11Fz16WsyGKj0t/p/lsIkGyHg5Gy+mco8sBMi2LRa4Fk8Ma8nX59CT9BZKAh7cO6HtS2Eopj/mCVIO5XrXT6rhc8xtUNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5999
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 09:48:38PM +0200, Simon Horman wrote:
> Hi Ding Hui,
> 
> On Mon, Apr 17, 2023 at 03:40:15PM +0800, Ding Hui wrote:
> > We do netif_napi_add() for all allocated q_vectors[], but potentially
> > do netif_napi_del() for part of them, then kfree q_vectors and lefted
> 
> nit: lefted -> leave
> 
> > invalid pointers at dev->napi_list.
> > 
> > If num_active_queues is changed to less than allocated q_vectors[] by
> > unexpected, when iavf_remove, we might see UAF in free_netdev like this:
> > 
> > [ 4093.900222] ==================================================================
> > [ 4093.900230] BUG: KASAN: use-after-free in free_netdev+0x308/0x390
> > [ 4093.900232] Read of size 8 at addr ffff88b4dc145640 by task test-iavf-1.sh/6699
> > [ 4093.900233]
> > [ 4093.900236] CPU: 10 PID: 6699 Comm: test-iavf-1.sh Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
> > [ 4093.900238] Hardware name: Powerleader PR2008AL/H12DSi-N6, BIOS 2.0 04/09/2021
> > [ 4093.900239] Call Trace:
> > [ 4093.900244]  dump_stack+0x71/0xab
> > [ 4093.900249]  print_address_description+0x6b/0x290
> > [ 4093.900251]  ? free_netdev+0x308/0x390
> > [ 4093.900252]  kasan_report+0x14a/0x2b0
> > [ 4093.900254]  free_netdev+0x308/0x390
> > [ 4093.900261]  iavf_remove+0x825/0xd20 [iavf]
> > [ 4093.900265]  pci_device_remove+0xa8/0x1f0
> > [ 4093.900268]  device_release_driver_internal+0x1c6/0x460
> > [ 4093.900271]  pci_stop_bus_device+0x101/0x150
> > [ 4093.900273]  pci_stop_and_remove_bus_device+0xe/0x20
> > [ 4093.900275]  pci_iov_remove_virtfn+0x187/0x420
> > [ 4093.900277]  ? pci_iov_add_virtfn+0xe10/0xe10
> > [ 4093.900278]  ? pci_get_subsys+0x90/0x90
> > [ 4093.900280]  sriov_disable+0xed/0x3e0
> > [ 4093.900282]  ? bus_find_device+0x12d/0x1a0
> > [ 4093.900290]  i40e_free_vfs+0x754/0x1210 [i40e]
> > [ 4093.900298]  ? i40e_reset_all_vfs+0x880/0x880 [i40e]
> > [ 4093.900299]  ? pci_get_device+0x7c/0x90
> > [ 4093.900300]  ? pci_get_subsys+0x90/0x90
> > [ 4093.900306]  ? pci_vfs_assigned.part.7+0x144/0x210
> > [ 4093.900309]  ? __mutex_lock_slowpath+0x10/0x10
> > [ 4093.900315]  i40e_pci_sriov_configure+0x1fa/0x2e0 [i40e]
> > [ 4093.900318]  sriov_numvfs_store+0x214/0x290
> > [ 4093.900320]  ? sriov_totalvfs_show+0x30/0x30
> > [ 4093.900321]  ? __mutex_lock_slowpath+0x10/0x10
> > [ 4093.900323]  ? __check_object_size+0x15a/0x350
> > [ 4093.900326]  kernfs_fop_write+0x280/0x3f0
> > [ 4093.900329]  vfs_write+0x145/0x440
> > [ 4093.900330]  ksys_write+0xab/0x160
> > [ 4093.900332]  ? __ia32_sys_read+0xb0/0xb0
> > [ 4093.900334]  ? fput_many+0x1a/0x120
> > [ 4093.900335]  ? filp_close+0xf0/0x130
> > [ 4093.900338]  do_syscall_64+0xa0/0x370
> > [ 4093.900339]  ? page_fault+0x8/0x30
> > [ 4093.900341]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> > [ 4093.900357] RIP: 0033:0x7f16ad4d22c0
> > [ 4093.900359] Code: 73 01 c3 48 8b 0d d8 cb 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 24 2d 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 fe dd 01 00 48 89 04 24
> > [ 4093.900360] RSP: 002b:00007ffd6491b7f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> > [ 4093.900362] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f16ad4d22c0
> > [ 4093.900363] RDX: 0000000000000002 RSI: 0000000001a41408 RDI: 0000000000000001
> > [ 4093.900364] RBP: 0000000001a41408 R08: 00007f16ad7a1780 R09: 00007f16ae1f2700
> > [ 4093.900364] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
> > [ 4093.900365] R13: 0000000000000001 R14: 00007f16ad7a0620 R15: 0000000000000001
> > [ 4093.900367]
> > [ 4093.900368] Allocated by task 820:
> > [ 4093.900371]  kasan_kmalloc+0xa6/0xd0
> > [ 4093.900373]  __kmalloc+0xfb/0x200
> > [ 4093.900376]  iavf_init_interrupt_scheme+0x63b/0x1320 [iavf]
> > [ 4093.900380]  iavf_watchdog_task+0x3d51/0x52c0 [iavf]
> > [ 4093.900382]  process_one_work+0x56a/0x11f0
> > [ 4093.900383]  worker_thread+0x8f/0xf40
> > [ 4093.900384]  kthread+0x2a0/0x390
> > [ 4093.900385]  ret_from_fork+0x1f/0x40
> > [ 4093.900387]  0xffffffffffffffff
> > [ 4093.900387]
> > [ 4093.900388] Freed by task 6699:
> > [ 4093.900390]  __kasan_slab_free+0x137/0x190
> > [ 4093.900391]  kfree+0x8b/0x1b0
> > [ 4093.900394]  iavf_free_q_vectors+0x11d/0x1a0 [iavf]
> > [ 4093.900397]  iavf_remove+0x35a/0xd20 [iavf]
> > [ 4093.900399]  pci_device_remove+0xa8/0x1f0
> > [ 4093.900400]  device_release_driver_internal+0x1c6/0x460
> > [ 4093.900401]  pci_stop_bus_device+0x101/0x150
> > [ 4093.900402]  pci_stop_and_remove_bus_device+0xe/0x20
> > [ 4093.900403]  pci_iov_remove_virtfn+0x187/0x420
> > [ 4093.900404]  sriov_disable+0xed/0x3e0
> > [ 4093.900409]  i40e_free_vfs+0x754/0x1210 [i40e]
> > [ 4093.900415]  i40e_pci_sriov_configure+0x1fa/0x2e0 [i40e]
> > [ 4093.900416]  sriov_numvfs_store+0x214/0x290
> > [ 4093.900417]  kernfs_fop_write+0x280/0x3f0
> > [ 4093.900418]  vfs_write+0x145/0x440
> > [ 4093.900419]  ksys_write+0xab/0x160
> > [ 4093.900420]  do_syscall_64+0xa0/0x370
> > [ 4093.900421]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> > [ 4093.900422]  0xffffffffffffffff
> > [ 4093.900422]
> > [ 4093.900424] The buggy address belongs to the object at ffff88b4dc144200
> >                 which belongs to the cache kmalloc-8k of size 8192
> > [ 4093.900425] The buggy address is located 5184 bytes inside of
> >                 8192-byte region [ffff88b4dc144200, ffff88b4dc146200)
> > [ 4093.900425] The buggy address belongs to the page:
> > [ 4093.900427] page:ffffea00d3705000 refcount:1 mapcount:0 mapping:ffff88bf04415c80 index:0x0 compound_mapcount: 0
> > [ 4093.900430] flags: 0x10000000008100(slab|head)
> > [ 4093.900433] raw: 0010000000008100 dead000000000100 dead000000000200 ffff88bf04415c80
> > [ 4093.900434] raw: 0000000000000000 0000000000030003 00000001ffffffff 0000000000000000
> > [ 4093.900434] page dumped because: kasan: bad access detected
> > [ 4093.900435]
> > [ 4093.900435] Memory state around the buggy address:
> > [ 4093.900436]  ffff88b4dc145500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > [ 4093.900437]  ffff88b4dc145580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > [ 4093.900438] >ffff88b4dc145600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > [ 4093.900438]                                            ^
> > [ 4093.900439]  ffff88b4dc145680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > [ 4093.900440]  ffff88b4dc145700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > [ 4093.900440] ==================================================================
> > 
> > Fix it by letting netif_napi_del() match to netif_napi_add().
> > 
> > Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> > Cc: Donglin Peng <pengdonglin@sangfor.com.cn>
> > CC: Huang Cun <huangcun@sangfor.com.cn>

Oops, the comment below was meant for
- [RESEND PATCH net 1/2] iavf: Fix use-after-free in free_netdev

> as this is a fix it probably should have a fixes tag.
> I wonder if it should be:
> 
> Fixes: cc0529271f23 ("i40evf: don't use more queues than CPUs")
> 
> Code change looks good to me.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
