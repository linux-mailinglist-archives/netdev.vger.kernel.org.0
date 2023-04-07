Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5146DB10B
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjDGQ6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjDGQ6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:58:41 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEE86A74
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 09:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680886720; x=1712422720;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JY0rb/6TkxvyEWETSnpSauPsq8aZjq3Vdc3o4V+9TVM=;
  b=ePxEXST66MWJmSj25G1/kPOmT9IAB2cF2FtngEPWG3ipbkwp+i2ecH3f
   LTNXLICtrWdoRn31qM1sQtKm9gN1LwRiZXrmp3Fr/kUpm7ep23Fep9kp7
   4eXWw8iZ/ScTCOux/9rPtiCsH24Oe2DKPWiKy5zlWOBrMWfCLYRYu1Ilt
   9Z34EXGY1QdTJq12gZVsfeut527PusgAP7m3adZhdH7LFoTVnsHc08Gsz
   4CDpOp5wqXc7YmWcrry6E5zClnoJvf7gwIJEwlh5KJlfifbj9ixCnqRKh
   oGq0R8IxKEWW24GO01t4IphC/X8k2BIdak/V8BWctnd55IbjTAo2et21b
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="323398001"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="323398001"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 09:58:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="681083181"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="681083181"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 07 Apr 2023 09:58:39 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 09:58:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 7 Apr 2023 09:58:38 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 7 Apr 2023 09:58:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g10K9N3mgds9vpsCwx3ZK5g9AbDGk9vcBigRfRjfviilANw3XrcZCFLapx+XwlssELFfYtAbEKv5xRI2Kl5nbbcB5RRzhfM8gl7Ox/9yJoUqP3H6Tzw0nZByEarb9cEoVzlYMb4Z6cd1Z6IqjKo8xgphfiOSlzVPTOmHNTQjKG4Iv4GIe6dnhIGCJPA9MWVCYjvBoT4hUG13waLP/l1wY53QRywhX1IiH7GEVzHec7gr1JbgJyB3NYg6R8p2GDoyAMwUmmGFgH8iWPx+TjRtKxHVLpzdQ8KgrY/Sb6n4h6o8jhSYdJSoWI/DDv8UU3R1++wJ8x9xgs0TrJXiOkTrjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AKPnTtZ60fPWlRGH8UQ8JMtIF/CFnoVqJftRlK79waw=;
 b=dsSTOjqUBD2wP/cE4/PjVVmoduEuKmvqNpNsDsAHL+YRuQzczCBJ5+IoT4qvAuE2LbGI8fNzCdLQ3/S8UEFwmsiV8i7ARS+lxnt7fIh3hqtQThER4jKBjy1RBMbq3aAiIzSCjAmUh4by6Dy7gB4L859MFU/p4xwPe9en5xmot7kF5VZwtMSotnWQRkbdOmnwt8vJObzUmasHA4HNe8zcRxCMPVQo0Dr/ZFuaybna1pG65c62qm6xscUGbHFeC5oXSHMzF/Nd9+L4nv0yHMciT+bkTSre8qcZkzs9f4dGFuQGB2qhyIR2z7qMEUasDRoTp9yCqKxUsfVO57mabACp2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 BL1PR11MB5462.namprd11.prod.outlook.com (2603:10b6:208:31e::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.34; Fri, 7 Apr 2023 16:58:36 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6277.031; Fri, 7 Apr 2023
 16:58:36 +0000
Date:   Fri, 7 Apr 2023 18:58:24 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     "Mekala, SunithaX D" <sunithax.d.mekala@intel.com>
CC:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [Intel-wired-lan] [PATCH net v2] ice: clear number of qs when
 rings are free
Message-ID: <ZDBLsBhGN74K6Nns@boxer>
References: <20230320112347.117363-1-michal.swiatkowski@linux.intel.com>
 <20230320115117.GK36557@unreal>
 <ZBh0wpx9kOU1LTDI@localhost.localdomain>
 <CO1PR11MB50282B593D48A928AE1B11B0A0969@CO1PR11MB5028.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CO1PR11MB50282B593D48A928AE1B11B0A0969@CO1PR11MB5028.namprd11.prod.outlook.com>
X-ClientProxiedBy: FR3P281CA0070.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::22) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|BL1PR11MB5462:EE_
X-MS-Office365-Filtering-Correlation-Id: 12a9d7fc-3e78-4445-58c9-08db378953bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BC1hos2AbvYrZTpmmrgK5UXHxluN0gw9jMGzDYgAKMhnwsgFbzO3XdQ9m+4889WX7hGkf++PK6MW1hXEI2hFOO/0I8utF8nJ8ZqsmFee/7H8fjl4/Qwm69zZxz3QukGkC6xDeKOhERHaokRHhDPAQIYgACz/HxFxIU4KR4flSaCLtDO0VHS/RlxdJj8jLL0aVZz1pRaveHod0eME+CSgue++ntVRWP3CdPPhpZcnKGXfOFVXnUxtv6lTl2m+7m193rmLtxunrOCp3vwS5xAGTPhcjFKJ1lH/MpXUNiR7g5Jxg7sXEPuy0DEeUzYOftZtyzkNqpVpGmp/ivjqXtHAa6b7e07G6J9WzmBapPrp/i+3VH54l5AXoLz8KjpdfBo49YRAfFXjvxw50oHQ0haPdqH3eVayTQ/K286TVQRS1cYU4op5QzYSTVwMltua8ZSLRI/uAApJvOxgo12yl0jfQ6vozq2NVMpPeKWZfdhLamsFKopSIIvC6lxcrZYBY+FZjxdpUXjrIWrZfWOqilwAaA/pir8t0Odd6ySoZ/Vg6kE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199021)(54906003)(6636002)(66556008)(8676002)(66946007)(66476007)(4326008)(316002)(966005)(8936002)(41300700001)(6862004)(5660300002)(44832011)(6486002)(2906002)(9686003)(6666004)(83380400001)(6512007)(53546011)(6506007)(26005)(186003)(478600001)(82960400001)(38100700002)(33716001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?svFAqfzyNbp9RBRdcG4LgTzkX5DC+kxg0c12nfp/Q/ZjwG3zftoKBnsnJTr3?=
 =?us-ascii?Q?9duCC3cdQ6omTPT9ayYEQ/+fcSeoa+Jr2/Rxx9nG2n36HfTwsDA2W6rT2HZN?=
 =?us-ascii?Q?Jj6ACzCrx2MhWhtjXhL8eWUXBQalVVjQqov/IR8d5DxaMlKcVTpwNf9Lh5nG?=
 =?us-ascii?Q?hGJoWjUDEKYSuaJde6U0tQmYT7wFneeo4JjMQigtRs0XA3UD3DYNPYNLoDxY?=
 =?us-ascii?Q?WIOvUkhOHLE7ezPS8Ht+kXGRWuSQxUe11arWGstembYT1Ex5GNG4vwW2y+O4?=
 =?us-ascii?Q?k47T/Ic3YbbQ1jzknWZJ6SsznJ2WxG3suV69BpeWChG1FHcySynBZ8Tb/fn3?=
 =?us-ascii?Q?Z6ejJln2O+2PCAA3kfRTFtnQpcQ6PaWGmpBTrZG688me6B6paxI+ockhyCMa?=
 =?us-ascii?Q?PftUwZ36v6L/4vpX1eV03a3JttJljlY14MiW0DWhRcdhRMw3xAS0dMQhrF0C?=
 =?us-ascii?Q?wazN3G5mO6LwrVTIPejEnM04kdiySiS/iSq2muxEsWQlriASaLkH0yG+XBsd?=
 =?us-ascii?Q?7/T1LCXkkIJXvpO2MI2/ztRvXbAtdDuCSEf2UAK7BngbNm9wGyP3Ns2mX+Vi?=
 =?us-ascii?Q?VTvV7kZtGk+rb0gLwTSI5W8Kqn4B7Ro9RN0qiXwshD4oMbZqpXS0PCUtUC+E?=
 =?us-ascii?Q?9YlyySo+BK0gfCudfG7z/+rwNNDTl6OZbc/Dl8LADVj9lHpFyFr6/ITdPzPa?=
 =?us-ascii?Q?b4uET1fcTj7XSVos4nGqOnA7LU0qOhKJjMCFSjcGEdUDr6BO+uzkbjHF4rzk?=
 =?us-ascii?Q?L4TUkkwrW/hLoa/F1y5C2xCAxTM8AdJSR99M8oaKdvvwHUNTXKbisBhS2uvy?=
 =?us-ascii?Q?TzvAVtJZOsWmBWqrOWgtoU3AseNc9e2ZhIFiNGWdagEoxwHnktoCpJwvd3Am?=
 =?us-ascii?Q?tjcwvChHDv+CR2oudQRfIbJnL60x4DNYYuIYoFBcgbeXiakCOvM7aNgTvvLz?=
 =?us-ascii?Q?2/YMoDu8rw6kIKbU6lanUwyrvdpnbQvFkDhBw/bimOCg2HH/hb0X7cJEoyNc?=
 =?us-ascii?Q?z/z3D8lkbiVaAncqCigUn7CDlBz/7qccThYL/g4FZTKThrxirvDU2GL8vP+z?=
 =?us-ascii?Q?hOhIQ4mX0cF3ThGOktUWnvqD+TptMOPmtsU//ylKaJ28pIML6qV+yNXp21DY?=
 =?us-ascii?Q?FrQnvJBgTo1t0lwKv6Oj3KXcdzU412geRt2r7F4x7RWO1B/aKrUYPcjxaEXa?=
 =?us-ascii?Q?3PNPwMleSKroghzvthVa6ZXFyZgieifsGkFB96LP42ZAwzNWKytawcxdqkmu?=
 =?us-ascii?Q?u3zZfHxFGHB3g2QB96wY+3zF/+XMGtPr0dVx1RhBW9VWj+VXVmwcuWznQ6Or?=
 =?us-ascii?Q?ITob6W783VBC8ya++mMlwmmJxYpTgsIyFsBFYCwOYl54Pbl2qLNpdRY1V5V/?=
 =?us-ascii?Q?G5+TaYJvXpfipdEpxL7StQADK6E1I3hzt+GJnr+U9wPAYXqQMK6GtlU6RJuS?=
 =?us-ascii?Q?i/bErDUlvjMdCQiJ/mVd2kssouIz0KGSDd4B8e8Wu7oeUEMAoIok5Ipd/mi2?=
 =?us-ascii?Q?DTGCp+CKh2xecsx7F2pao9SayurHNj2lkIF4Pd5WJQ2FzyNjlWUKn+MtlYwm?=
 =?us-ascii?Q?bUdrKE8l90FrGKNkE+yL6Bsy4nx0RBnf2vrQZx6tytUFjd0jmrJVSvlhtLeY?=
 =?us-ascii?Q?0A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 12a9d7fc-3e78-4445-58c9-08db378953bf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 16:58:35.9839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iERq1+NvmV0y//pOxWei6Z+O1ZlAcTDP0W4PVo0wMQ4CcgRBVyiotAcdRMAW6es8uh3lR9mjjHg56qXbAGEdS53oeFM1jUJ7XrYxTaMPEFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5462
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 04:12:49PM +0000, Mekala, SunithaX D wrote:
> Still observing system hung
> Test 1: Upon PF reset
> 	Applied reproducer.patch in kernel, followed by below commands
> 	echo 1 > /sys/module/ice/parameters/ice_reproduce_panic

what is that?

> 	echo 1 > /sys/class/net/<ice_pf>/device/reset
> 	System did not hang but the PF interface went down with dmesg to reload driver
> 	On unloading driver, system hangs with no response.
> 2. On changing queues 
> 	Applied reproducer.patch in kernel, followed by below commands
> 	echo 1 > /sys/module/ice/parameters/ice_reproduce_panic
> 	ethtool -L $pf rx 1 tx 1
> 	System stops responding

this is not enough info for us. You should be able to catch the splat
(like below was included in commit message).

I might be missing something, but to me zeroing num_rxq is not enough. In
the rebuild path ice_vsi_set_num_qs() will re-init that *before* calling
ice_vsi_alloc_arrays(), so if workqueue is still running there is a small
time frame where driver will be in state of non-zero num_rxq without rx
ring array being allocated. Only reset path cancels ptp->work.

> >
> > -----Original Message-----
> > From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of Michal Swiatkowski
> > Sent: Monday, March 20, 2023 7:59 AM
> > To: Leon Romanovsky <leon@kernel.org>
> > Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org
> > Subject: Re: [Intel-wired-lan] [PATCH net v2] ice: clear number of qs when rings are free
> >
> > On Mon, Mar 20, 2023 at 01:51:17PM +0200, Leon Romanovsky wrote:
> > > On Mon, Mar 20, 2023 at 12:23:47PM +0100, Michal Swiatkowski wrote:
> > > > In case rebuild fails not clearing this field can lead to call trace.
> > > >
> > > > [  +0.009792] BUG: kernel NULL pointer dereference, address: 
> > > > 0000000000000000 [  +0.000009] #PF: supervisor read access in kernel 
> > > > mode [  +0.000006] #PF: error_code(0x0000) - not-present page [  
> > > > +0.000005] PGD 0 P4D 0 [  +0.000009] Oops: 0000 [#1] PREEMPT SMP PTI
> > > > [  +0.000009] CPU: 45 PID: 77867 Comm: ice-ptp-0000:60 Kdump: loaded Tainted: G S         OE      6.2.0-rc6+ #110
> > > > [  +0.000010] Hardware name: Dell Inc. PowerEdge R740/0JMK61, BIOS 
> > > > 2.11.2 004/21/2021 [  +0.000005] RIP: 
> > > > 0010:ice_ptp_update_cached_phctime+0xb0/0x130 [ice] [  +0.000145] 
> > > > Code: fa 7e 55 48 8b 93 48 01 00 00 48 8b 0c fa 48 85 c9 74 e1 8b 51 
> > > > 68 85 d2 75 da 66 83 b9 86 04 00 00 00 74 d0 31 d2 48 8b 71 20 <48> 
> > > > 8b 34 d6 48 85 f6 74 07 48 89 86 d8 00 00 00 0f b7 b1 86 04 00 [  
> > > > +0.000008] RSP: 0018:ffffa036cf7c7ea8 EFLAGS: 00010246 [  +0.000008] 
> > > > RAX: 174ab1a8ab400f43 RBX: ffff937cda2c01a0 RCX: ffff937cdca9b028 [  
> > > > +0.000005] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 
> > > > 0000000000000000 [  +0.000005] RBP: ffffa036cf7c7eb8 R08: 
> > > > 0000000000000000 R09: 0000000000000000 [  +0.000005] R10: 
> > > > 0000000000000080 R11: 0000000000000001 R12: ffff937cdc971f40 [  
> > > > +0.000006] R13: ffff937cdc971f44 R14: 0000000000000001 R15: 
> > > > ffffffffc13f3210 [  +0.000005] FS:  0000000000000000(0000) 
> > > > GS:ffff93826f980000(0000) knlGS:0000000000000000 [  +0.000006] CS:  
> > > > 0010 DS: 0000 ES: 0000 CR0: 0000000080050033 [  +0.000006] CR2:
> > > > 0000000000000000 CR3: 00000004b7310002 CR4: 00000000007726e0 [
> > > > +0.000006] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > > > 0000000000000000 [  +0.000004] DR3: 0000000000000000 DR6:
> > > > 00000000fffe0ff0 DR7: 0000000000000400 [  +0.000005] PKRU:
> > > > 55555554 [  +0.000004] Call Trace:
> > > > [  +0.000004]  <TASK>
> > > > [  +0.000007]  ice_ptp_periodic_work+0x2a/0x60 [ice] [  +0.000126]  
> > > > kthread_worker_fn+0xa6/0x250 [  +0.000014]  ? 
> > > > __pfx_kthread_worker_fn+0x10/0x10 [  +0.000010]  kthread+0xfc/0x130 
> > > > [  +0.000009]  ? __pfx_kthread+0x10/0x10 [  +0.000010]  
> > > > ret_from_fork+0x29/0x50
> > > >
> > > > ice_ptp_update_cached_phctime() is calling ice_for_each_rxq macro, 
> > > > in case of rebuild fail the rx_ring is NULL and there is NULL 
> > > > pointer dereference.
> > > >
> > >>  Also for future safety it is better to clear the size values for tx 
> > > > and rx ring when they are cleared.
> > > >
> > > > Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller 
> > > > functions")
> > > > Reported-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
> > > > Signed-off-by: Michal Swiatkowski 
> > > > <michal.swiatkowski@linux.intel.com>
> > > > ---
> > > > v1 --> v2:
> > >  > * change subject to net and add fixes tag
> > > > ---
> > > > drivers/net/ethernet/intel/ice/ice_lib.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> 
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
