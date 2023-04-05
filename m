Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1FF6D7FC6
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 16:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238260AbjDEOk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 10:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238117AbjDEOk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 10:40:56 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FFF2D7D;
        Wed,  5 Apr 2023 07:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680705653; x=1712241653;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rV0ZxcsZkdKXOM4cbgCZWHtfbIHsLZEslpRJwaERk7A=;
  b=b/jKedaxbuEqPFf7L0CgDqg9zmfgCCQIvWD/8A0rpiAss4mDygR3i0c/
   xYr2/k/YqGvDxGm1RXlhNWLHGw1u0OE1Dny0OdHfAVDfHaT05uZ4pFF7G
   IpbTcKhdTfT3zIItHkA2X5qsFokA0lf7at1487WOUM342ZA+mql9zrilv
   uxFAMl+b0P08OjtVmp06kmclfZA3a+bQ8JDdVCV+GAzn+sKy212FXv80k
   tD0dU47mAu8+sOPFbTabX5tPAirwE/tSAaNwezyqagWS3vpI6KZDVQkN3
   ORN5eVsvlyto1BNiuy5M3yi+DjZehJ0/NdcbKtUYStkaXJL/dcQIRf57K
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="322127200"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="322127200"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 07:40:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="686772550"
X-IronPort-AV: E=Sophos;i="5.98,321,1673942400"; 
   d="scan'208";a="686772550"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 05 Apr 2023 07:40:52 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 07:40:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 07:40:51 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 07:40:51 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 07:40:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+0MUUK82ym0JsdO3VD51xhQYwncyR35b8LOfvpiePMojzwsieMpuFoQ+YK6FF1+eIuyP3PFtMvqeYupgD9NOItOBMvPm8TzA7wZkjr5cemsRKoqZrU3BYbkSmSbmOIJUb1YucntzJ5dxjjvm7A8owfYgGYwuhUP/z/F6kXCmguQDW+cIw3yZrmMrX5zByjcDZetZvh+mYu7BOb/VRuAe5OcjFuwAV8pzOHnFJRVSpRWKJJUmKTDSMf5Xbdrvh0XdjCT+0YwoKYs3hxQF+BeWOJsLWIlYtQkBpUbzbqJucUw3G5J82Lf9HvCUeCEsyRlUoHZzGxLDiIEBAvM7a5HZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hBE9UVH/t8xtRE+M4aSLMarsBAIYToLU+qqihP2528k=;
 b=g81PSLwnN6aCRkkRGBq/mKNfaIJe8TKJ+gEGZZ+Lfki0gbrItvu7DBEovepsU1usWvjFX1O+nvvtIpRSH4k6V0w1eHpyxlfOrVg/GwgjKrCHS40gD7JoeHOz2qILy/7FjSYR5KqOG35zGzyVmcQq/rYgYOzSxJrZJJ7iFHGkyx8iNFFIyv3AFixgUKSt1Q2pWRw9YR4dEx1lsF7/2TeSAIF66SfVLCIS5We+3KhVI/UvuM/8ec2ViLLHcqMX/NcApq5SfR2uy9rEFwUrKZ1gx8OQZXBbnkwGM9htcVU1YVRJonqs/2PH1GbXzUNKFStvnZCSeuLWVkQNZOxfZXvzvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DM6PR11MB4642.namprd11.prod.outlook.com (2603:10b6:5:2a2::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.35; Wed, 5 Apr 2023 14:40:47 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6254.033; Wed, 5 Apr 2023
 14:40:47 +0000
Date:   Wed, 5 Apr 2023 16:40:33 +0200
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
Subject: Re: [PATCH net v3] ixgbe: Panic during XDP_TX with > 64 CPUs
Message-ID: <ZC2IYWgTUFCnlKc9@boxer>
References: <20230308220756.587317-1-jjh@daedalian.us>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230308220756.587317-1-jjh@daedalian.us>
X-ClientProxiedBy: DB6PR07CA0096.eurprd07.prod.outlook.com
 (2603:10a6:6:2b::34) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DM6PR11MB4642:EE_
X-MS-Office365-Filtering-Correlation-Id: 23860a01-a2b2-4ef9-8f34-08db35e3be77
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LmZvtGYiNHpV+HzI+FtX9sDUXG9lnxAlCXNZ8eEAgFDqHQwh2WcKO3h8XbIXLudyP8CiCNbUxvRefnb7qmDAajz/KBobO+OV8pBZpfOPMeOHKYj2ffL15lhYw3p6bSNUP0uvA2z3pjJHeZ/T2U2Lg748VD0ihCmseJY+A4mBjFOba6eqI3ktYA0uzkq26jGZOe0k5VCHoYKCbVgczFp2Xfu5N5G3DhsS3NWEVHvZgbhmxRQyXnGeNzraHPTrSGjOKapwfKc0LgA8YG7uweIIBOrLAPrGCHDAH93xSBlag6uDFK7ybHrM6JyXSMfd1nInlIRuwNHFA8IezZ3czPraSxNnUdbHEN+K/KvBhzYhRJuY0BsQIvGflX6s5wuMd8UIkhSEMMp8FjYObskaNzWREY0r8YddNicGNB2TMOZmtMtLg34CKH2fVGxjf4p+AGrvGaOQoiwOhXqMlVvkWAJtg8bNK1aAGU576Kwm86lMbEOuc/55s9vcOWpr3T7GDrz5Tg0qt3rrIPlrSt50hKCRasOWmEaLa27xYCXmojOw0/hEQY71G+EvEQ0CTJUdyW+lSHrad35MWbaK6CbS+IviaOzyiWagPuncdLGIzZp6KkLkekCfIECx7EVAE/ojU1Zr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(39860400002)(366004)(376002)(136003)(396003)(451199021)(83380400001)(6486002)(478600001)(6666004)(316002)(186003)(26005)(54906003)(6506007)(9686003)(6512007)(4326008)(33716001)(7416002)(2906002)(5660300002)(44832011)(38100700002)(66556008)(66476007)(8676002)(6916009)(82960400001)(41300700001)(86362001)(66946007)(8936002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aD2o26c/MJiAFf9okQr6gjr7TbtX10kgn/QPf2+Scg2ayLq4RV/Yrse5cbYo?=
 =?us-ascii?Q?5yu0XTM3K21VIHNvCGUNJHFkF5liiBXTBEyRE5ZzftNb8kPh8CaaypinB+YZ?=
 =?us-ascii?Q?lKhIyUxjEQ6+vcNLiolj5+R0THH2I2gTC1uAFJSKCdeKbMzrROa4soyrxJlh?=
 =?us-ascii?Q?j9uocnLAb4EA3It+O7LawZrtfr2VUdh0TKkaRrDUehfCEN3JfMB/fskVpB75?=
 =?us-ascii?Q?AmPmrmNn9sa6jxdruRtGv1LEa2F3mPNp4zr44Fxa5uIoIw/hlAuyAfFIzywq?=
 =?us-ascii?Q?wPDZjcma5ulTHCwji6GvJ3s8I6B6RDlIQMedXLdRaBGnfPeAKk64nGEqK1Pq?=
 =?us-ascii?Q?Zx6r2oxjb63yzr81imiFzLoyvkQLwXhBhYvTHcnBAc44lJfb90z4St6VHnoj?=
 =?us-ascii?Q?RbBb9lgFEu4gTF8m//HqgHtwcxwxXcvWNFmzADxK2p4ErCrmUS3r97Uly5aZ?=
 =?us-ascii?Q?NTM2BcQSW+2t+TTfvewUjEmhK3DAyQkAbUGHmmSL3/aVjZKBTjljBfuk8H2Z?=
 =?us-ascii?Q?+tsGy5rEPWqM+kwUZzMOLnb//NNU6d3u646MkSlMQXC9eyWUgZ2BLo4lq2VP?=
 =?us-ascii?Q?pXRNAQzVEq7yMytFAU8lEjUDK01qRFKx0zhquo07Kd2bwG6ZzHZjwF9eY5H/?=
 =?us-ascii?Q?1t3oXBoIpzlZe2A6VxN425r82iehKsnJXkk/6i2lD5qhvxzeBaUMw1cDovyY?=
 =?us-ascii?Q?0cWJFN0KqbG27zg2jH4eCDDEZozF+p5KhrX01Neg2dmNbs7564KBqzYVQrR9?=
 =?us-ascii?Q?ue6986LcPagPzzdUm3T4hcNShzNyUteAonp8DAYG383FoL70ViFiO2wAacgg?=
 =?us-ascii?Q?S5Gmxx1uEf/8cfFQXavUo5ytkeJ13DtJ8wdbL9qiYXS5FRomQwWE1E80ssIo?=
 =?us-ascii?Q?oBsq6ZdATHLeotTKuCnAgZ+O5lEywX8PSSDKIjeNx2uuVvndvJgew4kLKi0f?=
 =?us-ascii?Q?aN0CbiPceINqZdisGzvwAT4+sU5LNlJ4oxDaWbNLkSkj/4oy/HgppOcSLnpi?=
 =?us-ascii?Q?Qys2HguohUxUKmZpkA8daZA5rdLbGJfzi4eIL9sCk68ut75pF523d2QVV9ss?=
 =?us-ascii?Q?DgU5oCs62I5qtQJz0F5hFY/Vb2ZBAf+imuUo2Tk8ccDwvn3DmUVR7qr3JaRq?=
 =?us-ascii?Q?1rmOYCNZqU3YdOHP9J7DbZciFhk0hBPYa/GoFQHP8fgKwGdN/xBrTLIiIN6O?=
 =?us-ascii?Q?nRCX5s9MFcC9zC82Jv0WAE8JrJ/l37FsH++iPrZVM8eoh4mJSFCs9+iU61uE?=
 =?us-ascii?Q?5Njxt4otLwlsD7gswRGU+YKo7vpn9CyZfjSWnpf20+/YFtGS3Y20X9V0C5ES?=
 =?us-ascii?Q?x8l84BirLTs/3q7DdtUsuvP0pZo08IT6JQbx3Ht8AXBvdi+VTztH7usFL88j?=
 =?us-ascii?Q?FzbyzmkF0c16YCejaIxZitIfy2o0N1t2BY3Ql+zoEefPCI0LnMkKttcIV5qx?=
 =?us-ascii?Q?zPTrCpH+/zTWsrFloh8iue4eUiz1x3dgKvN/9XDnvLk5Vd8BG/rrNDgDgNLu?=
 =?us-ascii?Q?fp3JtYaD9HbEEb9L717bbyhc/2jJ/kvZBfLf5AzOX2W6Jhu/EJfw2QaK04Yf?=
 =?us-ascii?Q?MYpTroUE5mMAtnA8jcScOa+9oGmCLk0fcWoU2BupLVEt9N55X5L80Ad1NAFh?=
 =?us-ascii?Q?Sw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 23860a01-a2b2-4ef9-8f34-08db35e3be77
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 14:40:47.5037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E+hsyuogyTOeilJV3hnmjqyrEfOwkGiXIyjNbKEAOL5gUAQgJN9jbtUPQ/xKI/3TNWQT+wAgDXXfCagsA8TVuE4eszR/0GG/7d5efDtd4pg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4642
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 02:07:57PM -0800, John Hickey wrote:
> In commit 'ixgbe: let the xdpdrv work with more than 64 cpus'
> (4fe815850bdc), support was added to allow XDP programs to run on systems
> with more than 64 CPUs by locking the XDP TX rings and indexing them
> using cpu % 64 (IXGBE_MAX_XDP_QS).
> 
> Upon trying this out patch via the Intel 5.18.6 out of tree driver
> on a system with more than 64 cores, the kernel paniced with an
> array-index-out-of-bounds at the return in ixgbe_determine_xdp_ring in
> ixgbe.h, which means ixgbe_determine_xdp_q_idx was just returning the
> cpu instead of cpu % IXGBE_MAX_XDP_QS.  An example splat:

i am assuming that in-tree driver is also affected so the info about OOT
driver is irrelevant here :)

> 
>  ==========================================================================
>  UBSAN: array-index-out-of-bounds in
>  /var/lib/dkms/ixgbe/5.18.6+focal-1/build/src/ixgbe.h:1147:26
>  index 65 is out of range for type 'ixgbe_ring *[64]'
>  ==========================================================================
>  BUG: kernel NULL pointer dereference, address: 0000000000000058
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 0 P4D 0
>  Oops: 0000 [#1] SMP NOPTI
>  CPU: 65 PID: 408 Comm: ksoftirqd/65
>  Tainted: G          IOE     5.15.0-48-generic #54~20.04.1-Ubuntu
>  Hardware name: Dell Inc. PowerEdge R640/0W23H8, BIOS 2.5.4 01/13/2020
>  RIP: 0010:ixgbe_xmit_xdp_ring+0x1b/0x1c0 [ixgbe]
>  Code: 3b 52 d4 cf e9 42 f2 ff ff 66 0f 1f 44 00 00 0f 1f 44 00 00 55 b9
>  00 00 00 00 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 <44> 0f b7
>  47 58 0f b7 47 5a 0f b7 57 54 44 0f b7 76 08 66 41 39 c0
>  RSP: 0018:ffffbc3fcd88fcb0 EFLAGS: 00010282
>  RAX: ffff92a253260980 RBX: ffffbc3fe68b00a0 RCX: 0000000000000000
>  RDX: ffff928b5f659000 RSI: ffff928b5f659000 RDI: 0000000000000000
>  RBP: ffffbc3fcd88fce0 R08: ffff92b9dfc20580 R09: 0000000000000001
>  R10: 3d3d3d3d3d3d3d3d R11: 3d3d3d3d3d3d3d3d R12: 0000000000000000
>  R13: ffff928b2f0fa8c0 R14: ffff928b9be20050 R15: 000000000000003c
>  FS:  0000000000000000(0000) GS:ffff92b9dfc00000(0000)
>  knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000058 CR3: 000000011dd6a002 CR4: 00000000007706e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  PKRU: 55555554
>  Call Trace:
>   <TASK>
>   ixgbe_poll+0x103e/0x1280 [ixgbe]
>   ? sched_clock_cpu+0x12/0xe0
>   __napi_poll+0x30/0x160
>   net_rx_action+0x11c/0x270
>   __do_softirq+0xda/0x2ee
>   run_ksoftirqd+0x2f/0x50
>   smpboot_thread_fn+0xb7/0x150
>   ? sort_range+0x30/0x30
>   kthread+0x127/0x150
>   ? set_kthread_struct+0x50/0x50
>   ret_from_fork+0x1f/0x30
>   </TASK>
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
> in ixgbe_setup_xdp.  We weren't counting references.  The
> ixgbe_xdp_locking_key only protects code in the XDP_TX path, which is
> not run when an XDP program is loaded.  The other condition for setting
> it on is the number of CPUs, which I assume is static.

From technical POV i think the contents here are fine. Maybe we could even
move this check to probe path because as you said this is static. I saw
that others had some wording/style comments, so if you decide to fix it
and push a v4, then you can add:

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> Fixes: 4fe815850bdc ("ixgbe: let the xdpdrv work with more than 64 cpus")
> Signed-off-by: John Hickey <jjh@daedalian.us>
> ---
> v1 -> v2:
> 	Added Fixes and net tag.  No code changes.
> v2 -> v3:
> 	Added splat.  Slight clarification as to why ixgbe_xdp_locking_key
> 	is not turned off.  Based on feedback from Maciej Fijalkowski.
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
>  
>  	old_prog = xchg(&adapter->xdp_prog, prog);
>  	need_reset = (!!prog != !!old_prog);
> -- 
> 2.37.2
> 
