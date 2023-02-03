Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A14468928E
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbjBCIr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbjBCIr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:47:27 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3BA7E6D4;
        Fri,  3 Feb 2023 00:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675414046; x=1706950046;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=u4OSOCK0X+iPV3kwui0FMrTP3PSKbg4sMTTT06DOQ7M=;
  b=EOQslJkpBfYnALCUYdNqLEmIf9tSIxdwPzdNrCZyCQUGWxYkRcNhQr46
   yU2ICSju5Zhx3FLsHJ4/PSWFbb8FFpekezrW0W/8kvKCuPYEkE3y2e31V
   cfkbLWby3nLKERB9GBwSzSZmsQEVb8Kn1xiOdFhIIe28CfdQey3xfaApQ
   4Fcmp7sun1ytWzXudZej6XMI7sroFemlkY5NptYq6+m4+b+vjdPfZlAks
   77e8q/aUwKJe0Tm5b6tO8Kzf0DXcDi3DwKX4757/HpnCqVtYNYi0N8EFf
   oNdBeCO9QDzq0gC8aAACZcL/1YhSVY3D+gNQUJHI5hi7puCRFHKue4gn1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="329980945"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="329980945"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 00:47:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="665649667"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="665649667"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 03 Feb 2023 00:47:06 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 00:47:05 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 3 Feb 2023 00:47:05 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 3 Feb 2023 00:47:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mod2y+YNY/dwajfKKrRug5LbQLsb9FTCwAhMglhVk0EcDJdt9ChmoK1zJUVO8ugr654qxPsopBZSeWGo8mdXj92JIt+DtHc846GvPT5ElYEZWD/QJdqz8bRmJNfIPEW5JbQc2JfpJ5Aw5f/efhynnZXT1+DGfPHdjkxdK372PQhLubMpBnWFmpgAIcbtVnHpB+fVLoK94h3NfVA+UmBeMpS9vkk9Iq39T4cVc+Wx0raK5zjm1vktnqw+0rKq7kuZY6W65Mb6I8mGkkvG2ojz16ogHHvjR4tzL6vJGCCVYhqWE1aAwBHEUgLzcuepTCVSE/+y85qXzL3B2s3mdwvKYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SuajYRVL/uTLVs7J7/Z9hvZBt7dTgN25wp9+/KOyYHE=;
 b=T+0kBCOl8c4NNZHuhxepRVlAozm/b/G8xcA9247REPiq7oBd76TF1ASh8zeasuj1exbU6jj4PMT59X0yWlDwVh9gJ/GFkqBmOvxRvfJVcDrT0EOe0W0vTvsNxIJ/3UZ3WQsQEEzBKv0CLjZomrThZgdRd7+H3bxRUpa/HUd56607JY8eOHW0ckHLkx+jnB1nwlayEtXmOWvgbicLvwo2kT2dVB7Aeb86HZIQ2d1/6vlQAMzz8TkyFZwGSjoiejVD2cK/Pfar6Kq3hKIjS0SuKq+MN6Ek+yfEDCSKDZjNuHTP73dB+jdnx+TAU/hoieCpxGYNwPniVSpwHrJFiFNeMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DS0PR11MB8135.namprd11.prod.outlook.com (2603:10b6:8:155::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.38; Fri, 3 Feb 2023 08:46:56 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Fri, 3 Feb 2023
 08:46:55 +0000
Date:   Fri, 3 Feb 2023 09:46:46 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        "Kuniyuki Iwashima" <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        <virtualization@lists.linux-foundation.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH 00/33] virtio-net: support AF_XDP zero copy
Message-ID: <Y9zJ9j0GthvRSFHL@boxer>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <5fda6140fa51b4d2944f77b9e24446e4625641e2.camel@redhat.com>
 <1675395211.6279888-2-xuanzhuo@linux.alibaba.com>
 <20230203033405-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230203033405-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: LO6P123CA0044.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::20) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DS0PR11MB8135:EE_
X-MS-Office365-Filtering-Correlation-Id: 25b2b12d-3065-49ef-57d1-08db05c3342e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UlAcy7qRP7kq8hgCXYdu5YNFadQTKvBnUWwNs3VnNLta3CZ/lWAYzXXxp21BeFew/Zjk5FQAuY1/hp66y826gz5LfN8u3kLP/tuSo2N5jhWR5eW9CXpEYT8hFh/uanGGRbdKH6Br1UiZ2qTvviXf5TesDvO66TXnA6eS4yqJhi09s1YBDgJZcKNFZj49kBlSnSSeD9f2MfwRtd5MkZiY1HvEn/t/2Zj2f9G52wRAPJMGSNS3nwa+XibGpNLJ/8b8MPWEyTz3IkpaTbcalwzSBPDOC44E/Mk3cwy/aLJluWONwSfl6Re3Q8Of10SzHPxtIBx8pKXzovRzeU3V2i99HAADB9WoV45jdlMelepb4z+thRZHGO1QzbwRbgzg9I346L3XBqeYiENR1cCd19khC5bCEJmjLZ6jNmnkihV6LTvbiYMaRWOhjKToeCth2URQlDS5bARPpaSdJWkhIBcxKnAyY3x5VXaaFNgoG2FMQTWiwtbs4qZ8YgxppF4e1lCRMYPkqy7TYsCgWl526Q5Axeme7wH/bTYVNJN/rlDIsqVnMhp3VkbcGddNMM7tnNZhc8nRL3ga7dZemAwL5j9pQ0EBu45OiSlWs+EBqa/tVGheVU+5xujxGGgTBLRc7XDMGwVy0l9LfBh+LYKfI/MzXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(39860400002)(376002)(136003)(396003)(366004)(451199018)(44832011)(7416002)(2906002)(5660300002)(38100700002)(33716001)(86362001)(54906003)(82960400001)(6506007)(26005)(6512007)(478600001)(186003)(8676002)(66556008)(6486002)(316002)(66946007)(9686003)(6916009)(66476007)(83380400001)(6666004)(4326008)(41300700001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oX60qyHDPDd9POB78o17pJnkLZEJUD1yRi7OqFjbKXoi3U/a/zkg9HoE3qOy?=
 =?us-ascii?Q?75Qm65SavE/2yLg/KNIpmxHd8et/Jg/xfB5xK1SEtnla1Mp9FH7/CeXK/lbL?=
 =?us-ascii?Q?w/aOOM8pJNMmN/jlkeFVI5OglLfrElzFxFfgZY5d9l9nl5iQhxLiZqqbUdc1?=
 =?us-ascii?Q?lOjdRqOxHKKYheQ3VFzumU2dKulTZcOTVHxsPtEsVz7/uUr7p8Q0/yt9bpwn?=
 =?us-ascii?Q?eUbK+9dqtY995fucUvjnLaTumYZuCGQnxoh3L6GAfqWlE+5vQNMRFBwm9XEF?=
 =?us-ascii?Q?ICm1AtpzZtislPtV3vA35miU0sPOfYYiQkX5PzHhGjhlf2/IrbYwA90lqoc9?=
 =?us-ascii?Q?fFn95hGBb86qOWYsxNRzlWCsuCcu9ryN/sXSJhuhuQz9Gl3dOrMY0utmC3nY?=
 =?us-ascii?Q?IQay/SGNQNcDSfBybLmq/KuE3Tr+xglvdrlnqZ3TeO7RleEc8ieOX3AFTQIT?=
 =?us-ascii?Q?CH7DtJtS1Zn5XNp63xpjUOdjsV71lzhjWjWeAa9+VaPAXudU7feBHzsk9sE5?=
 =?us-ascii?Q?zuNjcpKjoM2JnPHRn1DZzs9a34bZAP4Rv14kOV3gbCeA7Xaxo3+FNnBjuge+?=
 =?us-ascii?Q?onqNjqj7mmJBzrmDCzKEt95i36S0h9BhY7px4gF5FuAcALFfsedV+Ko/sgqL?=
 =?us-ascii?Q?DrqmNibC5fGrEBQVKX3ZukJl1P4dkKwRJHpLC5w4E68Zqb+IqhXvIJVPWOIo?=
 =?us-ascii?Q?jCgNzAD4FDdAdc5L/wwChDX9h1QPbFNecAvJ9m7P43M6H+agLJW7Pt/V/ci1?=
 =?us-ascii?Q?V41XuZw1Up9fmPgJJqE06F6D1FEByvvjIgzqZeS8L8XsIUTk8SG1JZh+s4ln?=
 =?us-ascii?Q?jaWQPJKU8D5xdr/01ETmt9QXfrDdIvLIObfvx6ZJMdUTl0Ai3l3C+sGPy1yI?=
 =?us-ascii?Q?48ybswLIiT/UWSHV0Jrwp3IgTVse6v6H6Nu6yoS+sbEil2PkuOUq0SxBmtg4?=
 =?us-ascii?Q?Ac33Fxg92Ra/Vw8IdJ0jMh07AN/uEWubggvimmGor6uIALCQHijH6dto+VVW?=
 =?us-ascii?Q?Pgg38JM52WO44zkhaFUArF3hV0jHrOKY+eEPVE/gDeEQAPEYaEkRcNAsdJF1?=
 =?us-ascii?Q?hS8xcE8qxRHqCZK0qZnJwxBJOxmNYX5NZtrVM7LfWdB5482VOAFEgTsPH2zV?=
 =?us-ascii?Q?M/a9lYZ+uNxmK02iGBxpmGUj8NhkjYiwtwjUMBzwJXw9CtOD9W5Ltq3x6pAo?=
 =?us-ascii?Q?I0Ddxx2VxP88Ken5D5VsPpd1M/J8Pcs8xOM+mpiy903Zhobk0XaKRyjVaIg5?=
 =?us-ascii?Q?jiQyAKLlNBOomGTdXKY6dIhIaP6jC/7lB44cW9gpeeGnfDikuY63e2ZqKoGn?=
 =?us-ascii?Q?ckawFQEokM9mmCUrWInFj/wnAVtmJrq2UiNCAqELHFMQC1hGaZ/UVvGlM1KJ?=
 =?us-ascii?Q?PvUvJsDkaLNyazDmTsuVL4A7hHxZJhH5o/U9xzA8D4IQVkxDD1T92eO56gMw?=
 =?us-ascii?Q?AnEWtVmF9SJbnSa9EUp2u1vgHw36xSwDZfdIZ50/tT9mBzXFxqMb8wUyi9R+?=
 =?us-ascii?Q?EycAMvaops7GKJaDpEV8GStW0t2SeRw35rOP87z3FyuKrrPYWLfewV8kg4Un?=
 =?us-ascii?Q?SenYVsHdLrGo5RO0H0/r2vMaO7NWBda78araX+I7MFcsh3CGTiU0dRRg8JoO?=
 =?us-ascii?Q?LMN692u77O2RroHB/Ma40Aw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 25b2b12d-3065-49ef-57d1-08db05c3342e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 08:46:55.7157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n00YPISywULfJovWc07OGaHhSGJnVenuDVz7WdgAAqiD35+CIk0qGwdMwpeiZi1vx99vxQd11avHZOJpHdYo9UGDDsQ50epIFWTIVFSswo8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8135
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 03:37:32AM -0500, Michael S. Tsirkin wrote:
> On Fri, Feb 03, 2023 at 11:33:31AM +0800, Xuan Zhuo wrote:
> > On Thu, 02 Feb 2023 15:41:44 +0100, Paolo Abeni <pabeni@redhat.com> wrote:
> > > On Thu, 2023-02-02 at 19:00 +0800, Xuan Zhuo wrote:
> > > > XDP socket(AF_XDP) is an excellent bypass kernel network framework. The zero
> > > > copy feature of xsk (XDP socket) needs to be supported by the driver. The
> > > > performance of zero copy is very good. mlx5 and intel ixgbe already support
> > > > this feature, This patch set allows virtio-net to support xsk's zerocopy xmit
> > > > feature.
> > > >
> > > > Virtio-net did not support per-queue reset, so it was impossible to support XDP
> > > > Socket Zerocopy. At present, we have completed the work of Virtio Spec and
> > > > Kernel in Per-Queue Reset. It is time for Virtio-Net to complete the support for
> > > > the XDP Socket Zerocopy.
> > > >
> > > > Virtio-net can not increase the queue at will, so xsk shares the queue with
> > > > kernel.
> > > >
> > > > On the other hand, Virtio-Net does not support generate interrupt manually, so
> > > > when we wakeup tx xmit, we used some tips. If the CPU run by TX NAPI last time
> > > > is other CPUs, use IPI to wake up NAPI on the remote CPU. If it is also the
> > > > local CPU, then we wake up sofrirqd.
> > >
> > > Thank you for the large effort.
> > >
> > > Since this will likely need a few iterations, on next revision please
> > > do split the work in multiple chunks to help the reviewer efforts -
> > > from Documentation/process/maintainer-netdev.rst:
> > >
> > >  - don't post large series (> 15 patches), break them up
> > >
> > > In this case I guess you can split it in 1 (or even 2) pre-req series
> > > and another one for the actual xsk zero copy support.
> > 
> > 
> > OK.
> > 
> > I can split patch into multiple parts such as
> > 
> > * virtio core
> > * xsk
> > * virtio-net prepare
> > * virtio-net support xsk zerocopy
> > 
> > However, there is a problem, the virtio core part should enter the VHOST branch
> > of Michael. Then, should I post follow-up patches to which branch vhost or
> > next-next?
> > 
> > Thanks.
> 
> I personally think 33 patches is still manageable no need to split.
> Do try to be careful and track acks and changes: if someone sends an ack
> add it in the patch if you change the patch drop the acks,
> and logs this fact in the changelog in the cover letter
> so people know they need to re-review.

To me some of the patches are too granular but probably this is related to
personal taste. However, I would like to ask to check how this series
affects existing ZC enabled driver(s), since xsk core is touched.

> 
> 
> > 
> > >
> > > Thanks!
> > >
> > > Paolo
> > >
> 
