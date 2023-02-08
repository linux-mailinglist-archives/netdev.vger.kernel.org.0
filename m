Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF99968F7B0
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 20:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbjBHTC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 14:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbjBHTCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 14:02:18 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549DF5649B;
        Wed,  8 Feb 2023 11:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675882935; x=1707418935;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pIcQh6KY+f5HqTLgI5ytZZ/N9UaBx342y2tXajZrV7U=;
  b=JfyE8c9PByBWcPX+TeFQl/JdIOhMVNETkzmsXSWsWV6cUye7fX2NQctm
   40x42lGK5POe/bcNQJt7PElH7YAOOsGIo9HMoyl7G1OcyO7NcR1YX9U06
   GYLT/zl+m/nnaYsyaxDjVIDnukgrX0ohRjBJ9ZzHovVGxET+E/DmZksBo
   AVDQQuQJEFRsO4gDxvQDCP4fgjNbQFfHEfbBRaBEBCQHoHSY3f7ZPVZhz
   5+rz6NfMFdoOrhzYKF+dLzsuHfAnu2oAD816GvqHRYYOruwnpXKTekHTm
   0reEvYM31EY5VNX9oYdgxf4TeWgf12mpekoBDLqUJTNG2eh1CJnoDCeuF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="317900615"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="317900615"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 11:02:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="756140711"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="756140711"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Feb 2023 11:02:14 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 11:02:14 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 8 Feb 2023 11:02:14 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 8 Feb 2023 11:02:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6kdD9JSEhNzTwmYljsqBVlgvkcxo5ss/1GmXREG+ktcFGQkyVU8Z74t+6CF9H5+qfVVsTll714UGxoa5pAgv44JhH55w3E1FF4sxHgDaB7BaCACCjk+eLYcUGhl6ENt9WbSt3zvqEUMoh5BjUEWUqrumJRJWeKQxNjj/e62in0yorK0t1PUvhckrmr5q6yogpcUNAe6j6ad9cx2AGugOXAyz9yOvzF2fuzSJ/iPCW0JBJPTEWLqshlG+qEIYR3JCpJolWeSkzy0t7N+B7D0n/SlkdyFql1GYqq6VMonT5ny/5KpuWaCRy+1O1HCcWrrhi99oP+HiMjT3yM1gFb6gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n3V8IoiSb4UuCa5beCMtwcwJOM6u3YvNfD0WY0zuFYY=;
 b=GIlx1KLT+bmOnF/2I+i6YEw6RCRhvzLwjd+mhzJR5O4+Qjbn3hobawV9Pfx6J3EhlLmmjJSptl/OxRAWSJAcK+ELtdYRtVX/xRZ18H1VhF2VxhAx5QYI6GaZxuoff8IHcmXNCbzZAF9Y2bslQAegR16yqtoGJWgf2/8hu/Phy7PF7wQA7o0WgRYVOYPay/QWtuA8VKSX21m6MQQSJ5T5cJBS4UUuLulvKD6iHDbdVUInPdSooqqECE1IA+VVr5lN+H8c6fMLJ1f9y4nE7U9aGlTw+Bc1mQKvadTNWnSebKWhSFaYE81WfB1UT10PHBaEXbQGU8bxvPnFgVLy1odSrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SA1PR11MB6687.namprd11.prod.outlook.com (2603:10b6:806:25a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 19:02:12 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Wed, 8 Feb 2023
 19:02:12 +0000
Date:   Wed, 8 Feb 2023 20:02:03 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Alexander H Duyck <alexander.duyck@gmail.com>
CC:     Jason Xing <kerneljasonxing@gmail.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <alexandr.lobakin@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH net v4 1/3] ixgbe: allow to increase MTU to 3K with XDP
 enabled
Message-ID: <Y+Pxq10w/4e1HT+4@boxer>
References: <20230208024333.10465-1-kerneljasonxing@gmail.com>
 <2bfcd7d92a6971416f58d9aac6e74840d5ae240a.camel@gmail.com>
 <Y+PNjcrSxKc0vD3s@boxer>
 <6ded592b01ba223bce241d6ff3073246cb5dd18b.camel@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6ded592b01ba223bce241d6ff3073246cb5dd18b.camel@gmail.com>
X-ClientProxiedBy: LO4P123CA0380.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::7) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SA1PR11MB6687:EE_
X-MS-Office365-Filtering-Correlation-Id: 115de4f5-e89a-4623-099d-08db0a06fbdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ajAQ5ozDb1WhFeLnaFwEPu6d4a9RFgy3pe+tB2Q8f30jCIo1V8RiMCeA+jd5wGqyXjqxIhuUAMYKp4CwABMbR7ut4rXKr/8EN4wkDcTn02Lk7R6U64uw6AYSdJeBX7MvlhMJn3nQ0Bde/fQhJ6twQx6EBJt9z8K91kKbRrszhabpIU5dVjVMuyTmqXVK0RTMkUimN8FTGMzZVYKsMc7Y1kSDnopAid3ObFPXtsSPSr1LjeZGGqTgr9uLTUWo/qZJZtXjFHOyLpAe5obU/U+drZeCw90mWVM1D5rMbw5tDVnnw+KKOVwm11v3lNQwzsaf0eWcwh7+zxu0LUBPBI/Rmqtgc8vNz5fSHq2mvF20bY3J91Un4f9kq3k7N/FY8GTZQjNcHHRtEzyl6hWnhEytXtU4pzg8RzmyxgScVPy41VZaxGIL+c9Z7l/7YkUAxejasDsqO/GIFsDCUVidyXGYZ+vlBeuIcNtDJNy5EHi3Olcdqt2uYypncOgXSBYgoB63hZgmcGkFfwwBAH3+JlbfCXuIgj12KcpdISHgCLyryhQ9lKNTr/T+qQEcUPM5t2GkmLj4GV1rxVNuDuqFP9pYMuDbltKlyQJdYvFZx7PHNMPWdSs3tJiiblXubQyOkrN0vzoBGXoLSV0FhaspaF1fcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39860400002)(366004)(346002)(376002)(136003)(396003)(451199018)(82960400001)(478600001)(6486002)(2906002)(9686003)(6512007)(186003)(26005)(6666004)(8936002)(6506007)(41300700001)(66946007)(6916009)(66476007)(66556008)(8676002)(4326008)(44832011)(7416002)(316002)(54906003)(5660300002)(38100700002)(33716001)(86362001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nWv2N9eelMXHx5iblN7Vpd2m8QRUZLu5i2eGpjCfOvX9znQaPv/VPO43iGfA?=
 =?us-ascii?Q?0ljO0MVANZLUA78ixTJmUgc5BoIhZjRNDu9LGzGgnkxH+LwG63FmMpckxdaU?=
 =?us-ascii?Q?DOPdjcykLyx5z9DtmN5ngcDsqsPBVz8bmrEJQGI1l3wcM3rJhwy2WHssAr5L?=
 =?us-ascii?Q?OI7jTqMQBmJk5XR0FOyboWfKhbctR5wXyoy0+ykIJu9VoEloeVYmkObCUYh1?=
 =?us-ascii?Q?r9rscDM9sIs3UJgrMpfSFafkWo4wu7JAEhmY/lwHyISbnY8aeQd6cVIZ/iea?=
 =?us-ascii?Q?0U6GFY1R8nlhjz44AWLYl+5NVysO/dHSkxco9JEUUtIvRs+of2HKOTfksS6J?=
 =?us-ascii?Q?PjjEwQenNbhBoY1nwjwyUs6QOh2PFR8H3NsqDeEjYYeDdH3GmzRMdWV+P8bC?=
 =?us-ascii?Q?+zXguf0kHIpQ1lTFXUSy0RI9LNnyEvrWsbPRHGp5kGQcBohMoSY28bgwDgfs?=
 =?us-ascii?Q?O/SOhbwmDusL4JVt/F0LabCl0xY5/0xHGW/e0cTfwlaiv9Py0sebjbIOBZbo?=
 =?us-ascii?Q?9GwTKOG6yH3z/DcLFzbyiCsGc5s+lv/a1tnGEMAwS1RO9m2lV6oSvwJpPXVs?=
 =?us-ascii?Q?QoViBZlrvuZQEsLnMOECd4pr7MndP0XQsujSoo4H9DjofGDFShyirfI8zYzv?=
 =?us-ascii?Q?+0OZY8PTRPZVNsniWN2FdIhUTzUPiHXjyuMMcUnZoND82eaMjELtd3FVQpMh?=
 =?us-ascii?Q?Ks2T+w+/m2XgeVlijgMPVlpYA9Z3yedQi9lHDR8kWJOwkTh4znV0HpM65LYy?=
 =?us-ascii?Q?MeZO8ZIix8khxFFV/87WsyhxyPKcfJJKi+LEtvVVBmUIuYdDPga3UKkTZH55?=
 =?us-ascii?Q?1XfdwCYgwbqgrPaEnC9z+xNLhaYjK/opbIGF4Lv/MYPi6b65P3EjAAinL7nN?=
 =?us-ascii?Q?orfWA+drelw4Ckl0UbQpQXDyeRFV9XLu5mJ5+uljsCYHx4oPjYn5zp15dX6+?=
 =?us-ascii?Q?OxnV1JOyibWClC6tuMQsfUjBO9RzNcQzYlSDSoiMUql1u0L21wLGZCyGamm4?=
 =?us-ascii?Q?0QiUDAsoRGlIr05Etf01vQoHS6GR1sk2wW4hesE8dzf6BLgOfmcfgNk+Rsh0?=
 =?us-ascii?Q?imSYVCujbNG+msg7K0wzWrtdLxgsppJjSJhU95sqk2FaM5X3n62QQ3Tyz5A3?=
 =?us-ascii?Q?D3zclYtdlBs5wjHQ5GjCdHEQBpqa7EoEVfJL8kZIJAwgQC1LZvEun1b1YNgP?=
 =?us-ascii?Q?XUVpSa9gvLC+23M5OVRCESEnQNblIzkQSlZY8gNGHELz3efZfCzzIpZa8kv2?=
 =?us-ascii?Q?QVHHko07WStad07e1/w/E3rsCRUw3Uw0gZHl4SRG8qBVwqRbxSvoKEM/oZaA?=
 =?us-ascii?Q?SmnVhnYkC/vgYzK1XA51S0DNz2bKFw2l6m2IUR5m2yLttvN0aEj7WcJiyU4K?=
 =?us-ascii?Q?5PAYF93JXz5+1lBYMfemf5wgNH1V+NE+k/Lx8jwp2lDNymWXEwP6bnd4lUoi?=
 =?us-ascii?Q?oKpg0y1Asw9A7bCvkvPTcPxg9WnaFqmVIkFxfYxEZyaAo4sf8xtsFrm+Yg8f?=
 =?us-ascii?Q?iKTroOrXvU+GrHVAsXEZ9rPANerEeBCJ9mybP57A1b/rWxaec6RfhJsOuE1Z?=
 =?us-ascii?Q?scjbYT7bxH0kSiLBTaEOl/0pQC+Fq/JO7CHtiEoC2VQDz2Q6UcTwjYrGI9g9?=
 =?us-ascii?Q?i6AEanSJbIArZ9Gy6TqRDwA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 115de4f5-e89a-4623-099d-08db0a06fbdb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 19:02:12.0198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bez7fzn4pbM+zKg7iR6rnHiyerWpWcZIJbPBKM7zAHZhh5RYEZS7BwrdjbRLv7+U7FP0/8DhqT2JPqLc63Jz9wo7dOT9/S7XIaA74kZfbE8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6687
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

On Wed, Feb 08, 2023 at 10:57:22AM -0800, Alexander H Duyck wrote:
> On Wed, 2023-02-08 at 17:27 +0100, Maciej Fijalkowski wrote:
> > On Wed, Feb 08, 2023 at 07:37:57AM -0800, Alexander H Duyck wrote:
> > > On Wed, 2023-02-08 at 10:43 +0800, Jason Xing wrote:
> > > > From: Jason Xing <kernelxing@tencent.com>
> > > > 
> > > > Recently I encountered one case where I cannot increase the MTU size
> > > > directly from 1500 to a much bigger value with XDP enabled if the
> > > > server is equipped with IXGBE card, which happened on thousands of
> > > > servers in production environment. After appling the current patch,
> > > > we can set the maximum MTU size to 3K.
> > > > 
> > > > This patch follows the behavior of changing MTU as i40e/ice does.
> > > > 
> > > > Referrences:
> > > > [1] commit 23b44513c3e6 ("ice: allow 3k MTU for XDP")
> > > > [2] commit 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
> > > > 
> > > > Fixes: fabf1bce103a ("ixgbe: Prevent unsupported configurations with XDP")
> > > > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > > 
> > > This is based on the broken premise that w/ XDP we are using a 4K page.
> > > The ixgbe driver isn't using page pool and is therefore running on
> > > different limitations. The ixgbe driver is only using 2K slices of the
> > > 4K page. In addition that is reduced to 1.5K to allow for headroom and
> > > the shared info in the buffer.
> > > 
> > > Currently the only way a 3K buffer would work is if FCoE is enabled and
> > > in that case the driver is using order 1 pages and still using the
> > > split buffer approach.
> > 
> > Hey Alex, interesting, we based this on the following logic from
> > ixgbe_set_rx_buffer_len() I guess:
> > 
> > #if (PAGE_SIZE < 8192)
> > 		if (adapter->flags2 & IXGBE_FLAG2_RSC_ENABLED)
> > 			set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
> > 
> > 		if (IXGBE_2K_TOO_SMALL_WITH_PADDING ||
> > 		    (max_frame > (ETH_FRAME_LEN + ETH_FCS_LEN)))
> > 			set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
> > #endif
> > 
> > so we assumed that ixgbe is no different than i40e/ice in these terms, but
> > we ignored whole overhead of LRO/RSC that ixgbe carries.
> 
> If XDP is already enabled the LRO/RSC cannot be enabled. I think that
> is already disabled if we have XDP enabled.
> 
> > I am not actively working with ixgbe but I know that you were the main dev
> > of it, so without premature dive into the datasheet and codebase, are you
> > really sure that 3k mtu for XDP is a no go?
> 
> I think I mixed up fm10k and ixgbe, either that or I was thinking of
> the legacy setup. They all kind of blur together as I had worked on
> pretty much all the Intel drivers up to i40e the last time I was
> updating them for all the Rx path stuff. :)
> 
> So if I am reading things right the issue is that if XDP is enabled you
> cannot set a 3K MTU, but if you set the 3K MTU first then you can
> enable XDP after the fact right?

Yes and vice versa - when XDP is on then you should be able to work with
3k mtus.

> 
> Looking it over again after re-reading the code this looks good to me.
> 
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

Awesome :)

> 
> 
> 
> 
> 
