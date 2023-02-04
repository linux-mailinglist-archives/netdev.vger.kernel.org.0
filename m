Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30DD668AA7B
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 15:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbjBDOIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 09:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbjBDOIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 09:08:39 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA8F25E09
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 06:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675519716; x=1707055716;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=YjdNilJXVtn41eZ4PRZhJJtQmdv1LwoUk3nqHCS3TkQ=;
  b=cZdZYdRB3gxhbp2h1yinafh/v9TzslMhXkhHz5o2V52wU2yTcG8V/qtp
   lPcN8jIc4hvhLhd3g6Ug/LXSualTxVU+ulFEIiyy/Y4jDHwCzfhjntw5s
   h//9fWarXjmEu2mvjWPTELT5kPy9DhMMoPoKkmObtGn36KyLVDHNuqXI2
   e1UNXXvI5mWYZIdYPEl4zGRDY6burW5CSpYQjxyMCCUcH1aFsxnOltjXS
   SVQjYQt+tDpVmMfpCO3VBhIBZhLFXgauy6TWG+5/eRIz2MlXU8ccwHOr7
   UNjmMAJQUpxwHWovWqE6xmVw7PZelGWtMiKlbLnNrXlw3qnNcuUeXmtTY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="316948831"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="316948831"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2023 06:08:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="659405066"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="659405066"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 04 Feb 2023 06:08:35 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 4 Feb 2023 06:08:35 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 4 Feb 2023 06:08:34 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 4 Feb 2023 06:08:34 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 4 Feb 2023 06:08:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LC93csfVb/cgqzxRCBCYqQcpQK13ODWpV8fNgBXcjzM2m8BViRfvekYg7wuhGMMaLtoUfZo2nVynUZAVYQTCp1lg8/OAQIyx45sFn5lirJbW7nzLgF8tYAZD7iqQL/TF+yA+anEL7p1z/oUfSbxgXWvJOHZEAfg4CyEIFMKexvgZqiodwgI+9pMT0IDu1z41DUN+Lwfi4ZwSauVxCYLMXKGeiRhERwrVj9aNBMTHOcZ2qUKDVHbuLHcNIOQI2uxDo8OEHhjYeLAD0lNEvbRC8Tj/cP81AoCKIrM8DvYmfSxdxLIvltavSkdvoqV0Pdr54f8pdhj2nudQ/cWcaiSPOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ix+0gUKft0B73v9Xe0Iqv6Bxr7eKaUAJ6nnJEk8xN1o=;
 b=meLJLAw64xddVrYHv/FectAb0E4mGTPenbtts8Rpq05GB5i7jESyBrAOe3rtNY1NiKwJMkO8ReBgm17Nk/TOllrN612AkiuxISIoOsNsvl0ZdcV46/Zk5RAnSX+zWlgAcZGRSgrdDP3QFpC/WcZzSnmprQC8nuK9CBU9YgxpFjf1JiaSnpS6QtrshPagZTvpRTpGoZ8se3aOYlr7eN/FiP9iIEFc0UJZoSQyb5OFJVCtefHTkP42xDJhplpYlCbDwfNaqQwAcVqHu6BOTZOYW7zlKIDrP/aJv2RgcbjKSZhiAMqrR1lIO0CvP2OUD2Dy847PWY39+YFneXxPqOH9KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 IA1PR11MB7320.namprd11.prod.outlook.com (2603:10b6:208:424::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Sat, 4 Feb
 2023 14:08:26 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Sat, 4 Feb 2023
 14:08:25 +0000
Date:   Sat, 4 Feb 2023 15:08:10 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     William Tu <u9012063@gmail.com>
CC:     <netdev@vger.kernel.org>, <jsankararama@vmware.com>,
        <gyang@vmware.com>, <doshir@vmware.com>,
        <alexander.duyck@gmail.com>, <alexandr.lobakin@intel.com>,
        <bang@vmware.com>, Yifeng Sun <yifengs@vmware.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: Re: [RFC PATCH net-next v15] vmxnet3: Add XDP support.
Message-ID: <Y95myr/XdkvQzWcm@boxer>
References: <20230127163027.60672-1-u9012063@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230127163027.60672-1-u9012063@gmail.com>
X-ClientProxiedBy: LO4P123CA0520.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::16) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|IA1PR11MB7320:EE_
X-MS-Office365-Filtering-Correlation-Id: ff677c13-7186-497c-db36-08db06b947f2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zWzYodt3fGOL1Xtgndeuosh9IxmS9uxnaZXJRB6VkZUGKqcqpbpaXhsmBgdTVEc20VXg7rbTLdlAA5n0aoySaqp1Ak71XhLVndv08V0zSpRO7ncGPyGMGiA3YhIivDaBvj7Clgo4G1oC0gRvHTUv5Xdw/yh80hZx3W0nnA0ANfwAGL05pR5hWEfqz0uCrUb+sXJ5EaxKbEqwIqbhFIJAma9H6WPFZF34DKCd1yAllJ7p6jwEc01+YF5/g/ZDSCoIeaeG3H/h+0QyFP5D7zIOaUsC8aOcX7SmzlVLFNqw+uE3DMKZYDX+IXdOqoKubJXbvvBmHtbbbJEVAMrda+LktMsYB8b2S7SytIRtMLISKStsBCiiwghz0yT95G2p3IJWaAHv3MOASTkv7vQM2Ey08CGHpUBxhZYL47PoECykAgxM9/79RptAzx/GwbkbRRMFy48k3ApOxnd5jTrXtggNyfjVWk10Irz/SWe+YeVeJa6AaBC0quM6FBDZ/mnR/iN9fTynAYhQ36w8g7Jg1iI30JDWfC5bMm0unZwL9pQw1no3VyVmo2HbBXU6rASSn0141qifBteH1fOcTMizdcqdF7CJz4Acl3/clWR74tPPTH6mITrHdDAwvNQjNKLMB+c+Hvqzjna1TIqRH9DCMWFLVNPMwL6HpMnGJP/v8ixI2xHHIHWMC1sZjssO4xfkUw8Uv62GHDX5Vxcvf0bh7DO4JiqagxIxd6RDYA8TvpbKHvTi8VuLFuH+z84ImOa4qB2We71X6tokl2hc8B/mdYE/Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(396003)(39860400002)(346002)(366004)(376002)(451199018)(478600001)(966005)(2906002)(66946007)(4326008)(66556008)(6916009)(8676002)(66476007)(54906003)(41300700001)(316002)(82960400001)(19627235002)(9686003)(44832011)(6666004)(26005)(33716001)(186003)(5660300002)(6486002)(6506007)(30864003)(8936002)(83380400001)(86362001)(6512007)(38100700002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wb1ZSOnln4XKrD2jaCjG50qkzGIqkv+vcLNU9cF3wBIXeIZlw+0xKn2P7mAm?=
 =?us-ascii?Q?TRhpOag9Tnkc9JStjgpg/5O9EMTE3YNEuL2DytUpyp9Wz8vCC2VVPVJ5cd7K?=
 =?us-ascii?Q?EfwoesEcBmi5Iaagqd9ejtMi6dv80a9GqE2/QD8C56yNZeGspnL9sZSIVJyn?=
 =?us-ascii?Q?2K+NjnMcs3fLgbJ1wUAXW6WoiXzBe+Gn7C9xWqbSimq8likntjPaQPU7oct3?=
 =?us-ascii?Q?ot8rtoKD3ywyRJ0dgsWO3JZFpBC+ZyCBKlmPe5F7MxbDexQL4SR52lHEzwoH?=
 =?us-ascii?Q?RkGiUwgvPQSdVvrCcm1+ssVAbGxJ7o22/veq0E5Ng+7FnrkoiK/NtHZ4YnkL?=
 =?us-ascii?Q?zLdmX+uwAyy4Oauyg4JYm93pkzrZHR1IBV4szi8/Yj8zFmMwQmPCKU5NvPZ6?=
 =?us-ascii?Q?oqLEtTp1EfqDOUp2bdkxRpXDL+wDt725JQnknIQQI5MG8EgVr54ul8r25C/Z?=
 =?us-ascii?Q?At/VaFdDiciD/OqKtz0xGZKVD/mTRI0MOODPYMRzi6Mkh9eJjLV2BWHoufwA?=
 =?us-ascii?Q?Hponw07ydq+RaMI8EbeEN4yj3OtDXTPy4VBOB2Le5GIRkZA58/gVYRO1Qhgk?=
 =?us-ascii?Q?tmQ2e8W19XruslEDY8N+5x9Xb/Xuv33CT2augBw5Uuw9CNKOJ8XMtRiTidWr?=
 =?us-ascii?Q?0/bPnVJ67ym7SZAodZUFslU3sf5q7eR2RnVxKlCdAa4ihxRAnhzixwObZpmq?=
 =?us-ascii?Q?3e1EJB7REUR1ep2ss9PartI/85J4TH+7MHr2D06DdZ0ZFSLtynJVqFVZrpUR?=
 =?us-ascii?Q?f8ZfNiKUGELyQmRfpcY4zxqq+PVSQOAHI1XDqi/0MxHJ4hAgItjZB4GUlxdp?=
 =?us-ascii?Q?3w+DsMMakSNycMmRZHxJM1331OYXuzwkyDSH5InsCr1NULPwjmcaS3jJmtGU?=
 =?us-ascii?Q?SONqhVlnw3R1aec7uM11lQehdAuc8zltRr700QN3eWG04qqih/bV6ZI5Zb6/?=
 =?us-ascii?Q?CXfQi0gk7jGhrAFGI1vMbukA80ia17aXVGx/4EiZNQsYq5SRmFx3bGOpeZIz?=
 =?us-ascii?Q?D3IOug+XH6RwlM9ILR8wZwkh8T6jtpTl3wZ+Y9kvRHD5R3YX6R2aHk+KiF1v?=
 =?us-ascii?Q?759r/qfZ44FtmssoR0JzCfYTWm16CmQ18BEkrcKhqHOv4D8CNirtDlL4X/1y?=
 =?us-ascii?Q?sW5ayk8KMV2MvZ2Uqcwgdg6MQB3BFlXlhK2Cic+268uqmyQEaB0oAtip50Ai?=
 =?us-ascii?Q?x+jz6MhMhxmH9RfvUUATiavG9oiEyxRsSLAl6femAoyAHS2nvbyep6Hd5eH9?=
 =?us-ascii?Q?7LUZPydTUNLSqe89Se38fMLRr7+sAb3HGO9WPJc+ShG/8xj5G/PMf14X5zQy?=
 =?us-ascii?Q?lO4IxK4DNSH2O3pERPmBowDe6oDmhhN4dn+zqbTz7qSndME9DqdOslS8XRk6?=
 =?us-ascii?Q?VNx03sBJ35A3PEYI4y6DUPHRgtjT5xYUjInbZt55hZEjNR3t14y1UrrAoUYF?=
 =?us-ascii?Q?GRzyvjqLFxwQctyPHd5hd95iT9TULz8VleGe4CH3lpYFkwTXCP+S0ek4XlZO?=
 =?us-ascii?Q?oQn5P1mVBQLy6fgvrlj/pNsUgkoHCWc7sBPCi3msszGaM1S1Xx+9UgtOkVwx?=
 =?us-ascii?Q?I4Dkg7neGMaN4qwWgqKQExn32s91GwuanNlo8aAgCKhN96MGn3mHt9CSeetO?=
 =?us-ascii?Q?m+6tUKJibNcuGsrwvvlrA4s=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ff677c13-7186-497c-db36-08db06b947f2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 14:08:25.1683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eyv3JdyyLjZfa6dNQd+n/PlkawffAc+9lDv4RmeSz2hrElVxWjNKMcoC7tOr3JFO7e90XzkSz1okIj6xHDtr8zuoAJqCqbXsrqi6FElbPXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7320
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

On Fri, Jan 27, 2023 at 08:30:27AM -0800, William Tu wrote:
> The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.
> 
> Background:
> The vmxnet3 rx consists of three rings: ring0, ring1, and dataring.
> For r0 and r1, buffers at r0 are allocated using alloc_skb APIs and dma
> mapped to the ring's descriptor. If LRO is enabled and packet size larger
> than 3K, VMXNET3_MAX_SKB_BUF_SIZE, then r1 is used to mapped the rest of
> the buffer larger than VMXNET3_MAX_SKB_BUF_SIZE. Each buffer in r1 is
> allocated using alloc_page. So for LRO packets, the payload will be in one
> buffer from r0 and multiple from r1, for non-LRO packets, only one
> descriptor in r0 is used for packet size less than 3k.
> 
> When receiving a packet, the first descriptor will have the sop (start of
> packet) bit set, and the last descriptor will have the eop (end of packet)
> bit set. Non-LRO packets will have only one descriptor with both sop and
> eop set.
> 
> Other than r0 and r1, vmxnet3 dataring is specifically designed for
> handling packets with small size, usually 128 bytes, defined in
> VMXNET3_DEF_RXDATA_DESC_SIZE, by simply copying the packet from the backend
> driver in ESXi to the ring's memory region at front-end vmxnet3 driver, in
> order to avoid memory mapping/unmapping overhead. In summary, packet size:
>     A. < 128B: use dataring
>     B. 128B - 3K: use ring0 (VMXNET3_RX_BUF_SKB)
>     C. > 3K: use ring0 and ring1 (VMXNET3_RX_BUF_SKB + VMXNET3_RX_BUF_PAGE)
> As a result, the patch adds XDP support for packets using dataring
> and r0 (case A and B), not the large packet size when LRO is enabled.
> 
> XDP Implementation:
> When user loads and XDP prog, vmxnet3 driver checks configurations, such
> as mtu, lro, and re-allocate the rx buffer size for reserving the extra
> headroom, XDP_PACKET_HEADROOM, for XDP frame. The XDP prog will then be
> associated with every rx queue of the device. Note that when using dataring
> for small packet size, vmxnet3 (front-end driver) doesn't control the
> buffer allocation, as a result we allocate a new page and copy packet
> from the dataring to XDP frame.
> 
> The receive side of XDP is implemented for case A and B, by invoking the
> bpf program at vmxnet3_rq_rx_complete and handle its returned action.
> The vmxnet3_process_xdp(), vmxnet3_process_xdp_small() function handles
> the ring0 and dataring case separately, and decides the next journey of
> the packet afterward.
> 
> For TX, vmxnet3 has split header design. Outgoing packets are parsed
> first and protocol headers (L2/L3/L4) are copied to the backend. The
> rest of the payload are dma mapped. Since XDP_TX does not parse the
> packet protocol, the entire XDP frame is dma mapped for transmission
> and transmitted in a batch. Later on, the frame is freed and recycled
> back to the memory pool.
> 
> Performance:
> Tested using two VMs inside one ESXi vSphere 7.0 machine, using single
> core on each vmxnet3 device, sender using DPDK testpmd tx-mode attached
> to vmxnet3 device, sending 64B or 512B UDP packet.
> 
> VM1 txgen:
> $ dpdk-testpmd -l 0-3 -n 1 -- -i --nb-cores=3 \
> --forward-mode=txonly --eth-peer=0,<mac addr of vm2>
> option: add "--txonly-multi-flow"
> option: use --txpkts=512 or 64 byte
> 
> VM2 running XDP:
> $ ./samples/bpf/xdp_rxq_info -d ens160 -a <options> --skb-mode
> $ ./samples/bpf/xdp_rxq_info -d ens160 -a <options>
> options: XDP_DROP, XDP_PASS, XDP_TX
> 
> To test REDIRECT to cpu 0, use
> $ ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e drop
> 
> Single core performance comparison with skb-mode.
> 64B:      skb-mode -> native-mode
> XDP_DROP: 1.6Mpps -> 2.4Mpps
> XDP_PASS: 338Kpps -> 367Kpps
> XDP_TX:   1.1Mpps -> 2.3Mpps
> REDIRECT-drop: 1.3Mpps -> 2.3Mpps
> 
> 512B:     skb-mode -> native-mode
> XDP_DROP: 863Kpps -> 1.3Mpps
> XDP_PASS: 275Kpps -> 376Kpps
> XDP_TX:   554Kpps -> 1.2Mpps
> REDIRECT-drop: 659Kpps -> 1.2Mpps
> 
> Demo: https://youtu.be/4lm1CSCi78Q
> 
> Future work:
> - XDP frag support
> - use napi_consume_skb() instead of dev_kfree_skb_any at unmap
> 
> Signed-off-by: William Tu <u9012063@gmail.com>
> Tested-by: Yifeng Sun <yifengs@vmware.com>
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> ---
> v14 -> v15:
> feedbacks from Alexander Lobakin
> - add rcu_read_lock unlock around xdp_frame_bulk_init
> - define correct VMXNET3_XDP_MAX_MTU
> - add comment explaining tx deferred and threshold in backend driver
> - minor code refactoring and style fixes
> - fix one bug in process_xdp when !xdp_prog
> https://github.com/williamtu/net-next/compare/v14..v15

good stuff with this way of showing the diff to reviewers (y)

below some nits/questions from me. i was not following previous
reviews/revisions, sorry.

> 
> v13 -> v14:
> feedbacks from Alexander Lobakin
> - fix several new lines, unrelated changes, unlikely, RCT style,
>   coding style, etc.
> - add NET_IP_ALIGN and create VMXNET3_XDP_HEADROOM, instead of
>   using XDP_PACKET_HEADROOM
> - remove %pp_page and use %page in rx_buf_int
> - fix the %VMXNET3_XDP_MAX_MTU, mtu doesn't include eth, vlan, and fcs
> - use NL_SET instead of netdev_err when detecting LRP
> - remove two global function, vmxnet3{_xdp_headroom, xdp_enabled}
> make the vmxnet3_xdp_enabled static inline function, and remove
> vmxnet3_xdp_headroom.
> - rename the VMXNET3_XDP_MAX_MTU to VMXNET3_XDP_MAX_FRSIZE
> 
> - add Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> - add yifeng sun for testing on ESXi and XDP
> compare v13..v14
> https://github.com/williamtu/net-next/compare/v13..v14
> 
> v12 -> v13:
> - feedbacks from Guolin:
>   Instead of return -ENOTSUPP, disable the LRO in
>   netdev->features, and print err msg
> 
> v11 -> v12:
> work on feedbacks from Alexander Duyck
> - fix issues and refactor the vmxnet3_unmap_tx_buf and
>   unmap_pkt
> 
> v10 -> v11:
> work on feedbacks from Alexander Duyck
> internal feedback from Guolin and Ronak
> - fix the issue of xdp_return_frame_bulk, move to up level
>   of vmxnet3_unmap_tx_buf and some refactoring
> - refactor and simplify vmxnet3_tq_cleanup
> - disable XDP when LRO is enabled, suggested by Ronak
> ---
>  drivers/net/Kconfig                   |   1 +
>  drivers/net/vmxnet3/Makefile          |   2 +-
>  drivers/net/vmxnet3/vmxnet3_drv.c     | 224 ++++++++++++--
>  drivers/net/vmxnet3/vmxnet3_ethtool.c |  14 +
>  drivers/net/vmxnet3/vmxnet3_int.h     |  43 ++-
>  drivers/net/vmxnet3/vmxnet3_xdp.c     | 419 ++++++++++++++++++++++++++
>  drivers/net/vmxnet3/vmxnet3_xdp.h     |  49 +++
>  7 files changed, 712 insertions(+), 40 deletions(-)
>  create mode 100644 drivers/net/vmxnet3/vmxnet3_xdp.c
>  create mode 100644 drivers/net/vmxnet3/vmxnet3_xdp.h
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 9e63b8c43f3e..a4419d661bdd 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -571,6 +571,7 @@ config VMXNET3
>  	tristate "VMware VMXNET3 ethernet driver"
>  	depends on PCI && INET
>  	depends on PAGE_SIZE_LESS_THAN_64KB
> +	select PAGE_POOL
>  	help
>  	  This driver supports VMware's vmxnet3 virtual ethernet NIC.
>  	  To compile this driver as a module, choose M here: the
> diff --git a/drivers/net/vmxnet3/Makefile b/drivers/net/vmxnet3/Makefile
> index a666a88ac1ff..f82870c10205 100644
> --- a/drivers/net/vmxnet3/Makefile
> +++ b/drivers/net/vmxnet3/Makefile
> @@ -32,4 +32,4 @@
>  
>  obj-$(CONFIG_VMXNET3) += vmxnet3.o
>  
> -vmxnet3-objs := vmxnet3_drv.o vmxnet3_ethtool.o
> +vmxnet3-objs := vmxnet3_drv.o vmxnet3_ethtool.o vmxnet3_xdp.o
> diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
> index d3e7b27eb933..eb3b9688299b 100644
> --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> @@ -28,6 +28,7 @@
>  #include <net/ip6_checksum.h>
>  
>  #include "vmxnet3_int.h"
> +#include "vmxnet3_xdp.h"
>  
>  char vmxnet3_driver_name[] = "vmxnet3";
>  #define VMXNET3_DRIVER_DESC "VMware vmxnet3 virtual NIC driver"
> @@ -323,17 +324,18 @@ static u32 get_bitfield32(const __le32 *bitfield, u32 pos, u32 size)
>  
>  
>  static void
> -vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
> -		     struct pci_dev *pdev)
> +vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi, struct pci_dev *pdev)

nit: unneeded code churn

>  {
> -	if (tbi->map_type == VMXNET3_MAP_SINGLE)
> +	u32 map_type = tbi->map_type;
> +
> +	if (map_type & VMXNET3_MAP_SINGLE)
>  		dma_unmap_single(&pdev->dev, tbi->dma_addr, tbi->len,
>  				 DMA_TO_DEVICE);
> -	else if (tbi->map_type == VMXNET3_MAP_PAGE)
> +	else if (map_type & VMXNET3_MAP_PAGE)
>  		dma_unmap_page(&pdev->dev, tbi->dma_addr, tbi->len,
>  			       DMA_TO_DEVICE);
>  	else
> -		BUG_ON(tbi->map_type != VMXNET3_MAP_NONE);
> +		BUG_ON((map_type & ~VMXNET3_MAP_XDP));
>  
>  	tbi->map_type = VMXNET3_MAP_NONE; /* to help debugging */
>  }
> @@ -341,19 +343,20 @@ vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
>  

(...)

> @@ -1858,14 +2014,16 @@ static int
>  vmxnet3_rq_init(struct vmxnet3_rx_queue *rq,
>  		struct vmxnet3_adapter  *adapter)
>  {
> -	int i;
> +	int i, err;
>  
>  	/* initialize buf_info */
>  	for (i = 0; i < rq->rx_ring[0].size; i++) {
>  
> -		/* 1st buf for a pkt is skbuff */
> +		/* 1st buf for a pkt is skbuff or xdp page */
>  		if (i % adapter->rx_buf_per_pkt == 0) {
> -			rq->buf_info[0][i].buf_type = VMXNET3_RX_BUF_SKB;
> +			rq->buf_info[0][i].buf_type = vmxnet3_xdp_enabled(adapter) ?
> +						      VMXNET3_RX_BUF_XDP :
> +						      VMXNET3_RX_BUF_SKB;
>  			rq->buf_info[0][i].len = adapter->skb_buf_size;
>  		} else { /* subsequent bufs for a pkt is frag */
>  			rq->buf_info[0][i].buf_type = VMXNET3_RX_BUF_PAGE;
> @@ -1886,6 +2044,12 @@ vmxnet3_rq_init(struct vmxnet3_rx_queue *rq,
>  		rq->rx_ring[i].gen = VMXNET3_INIT_GEN;
>  		rq->rx_ring[i].isOutOfOrder = 0;
>  	}
> +
> +	err = vmxnet3_create_pp(adapter, rq,
> +				rq->rx_ring[0].size + rq->rx_ring[1].size);
> +	if (err)
> +		return err;
> +
>  	if (vmxnet3_rq_alloc_rx_buf(rq, 0, rq->rx_ring[0].size - 1,
>  				    adapter) == 0) {

Probably for completeness, if above fails then you should destroy pp
resources that got successfully allocd in vmxnet3_create_pp

>  		/* at least has 1 rx buffer for the 1st ring */
> @@ -1989,7 +2153,7 @@ vmxnet3_rq_create(struct vmxnet3_rx_queue *rq, struct vmxnet3_adapter *adapter)
>  }
>  
>  
> -static int
> +int
>  vmxnet3_rq_create_all(struct vmxnet3_adapter *adapter)
>  {
>  	int i, err = 0;
> @@ -3026,7 +3190,7 @@ vmxnet3_free_pci_resources(struct vmxnet3_adapter *adapter)
>  }
>  
>  

(...)

> diff --git a/drivers/net/vmxnet3/vmxnet3_xdp.c b/drivers/net/vmxnet3/vmxnet3_xdp.c
> new file mode 100644
> index 000000000000..c698fb6213b2
> --- /dev/null
> +++ b/drivers/net/vmxnet3/vmxnet3_xdp.c
> @@ -0,0 +1,419 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Linux driver for VMware's vmxnet3 ethernet NIC.
> + * Copyright (C) 2008-2023, VMware, Inc. All Rights Reserved.
> + * Maintained by: pv-drivers@vmware.com
> + *
> + */
> +
> +#include "vmxnet3_int.h"
> +#include "vmxnet3_xdp.h"
> +
> +static void
> +vmxnet3_xdp_exchange_program(struct vmxnet3_adapter *adapter,
> +			     struct bpf_prog *prog)
> +{
> +	rcu_assign_pointer(adapter->xdp_bpf_prog, prog);
> +}
> +
> +static int
> +vmxnet3_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf,
> +		struct netlink_ext_ack *extack)
> +{
> +	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
> +	struct bpf_prog *new_bpf_prog = bpf->prog;
> +	struct bpf_prog *old_bpf_prog;
> +	bool need_update;
> +	bool running;
> +	int err;
> +
> +	if (new_bpf_prog && netdev->mtu > VMXNET3_XDP_MAX_MTU) {
> +		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (adapter->netdev->features & NETIF_F_LRO) {
> +		NL_SET_ERR_MSG_MOD(extack, "LRO is not supported with XDP");
> +		adapter->netdev->features &= ~NETIF_F_LRO;

don't you need to reflect clearing this flag in some way?
Also what if someone tries to set it when xdp prog is loaded?

> +	}
> +
> +	old_bpf_prog = rcu_dereference(adapter->xdp_bpf_prog);
> +	if (!new_bpf_prog && !old_bpf_prog)
> +		return 0;
> +
> +	running = netif_running(netdev);
> +	need_update = !!old_bpf_prog != !!new_bpf_prog;
> +
> +	if (running && need_update)
> +		vmxnet3_quiesce_dev(adapter);
> +
> +	vmxnet3_xdp_exchange_program(adapter, new_bpf_prog);
> +	if (old_bpf_prog)
> +		bpf_prog_put(old_bpf_prog);
> +
> +	if (!running || !need_update)
> +		return 0;
> +
> +	vmxnet3_reset_dev(adapter);
> +	vmxnet3_rq_destroy_all(adapter);
> +	vmxnet3_adjust_rx_ring_size(adapter);
> +	err = vmxnet3_rq_create_all(adapter);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "failed to re-create rx queues for XDP.");
> +		return -EOPNOTSUPP;
> +	}
> +	err = vmxnet3_activate_dev(adapter);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "failed to activate device for XDP.");
> +		return -EOPNOTSUPP;
> +	}
> +	clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);
> +
> +	return 0;
> +}
> +

(...)

> +static int
> +vmxnet3_xdp_xmit_back(struct vmxnet3_adapter *adapter,
> +		      struct xdp_frame *xdpf)
> +{
> +	struct vmxnet3_tx_queue *tq;
> +	struct netdev_queue *nq;
> +	int tq_number;
> +	int err, cpu;
> +
> +	tq_number = adapter->num_tx_queues;
> +	cpu = smp_processor_id();
> +	if (likely(cpu < tq_number))
> +		tq = &adapter->tx_queue[cpu];
> +	else
> +		tq = &adapter->tx_queue[reciprocal_scale(cpu, tq_number)];
> +	if (tq->stopped)
> +		return -ENETDOWN;
> +
> +	nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
> +
> +	__netif_tx_lock(nq, cpu);
> +	err = vmxnet3_xdp_xmit_frame(adapter, xdpf, tq, false);
> +	__netif_tx_unlock(nq);
> +
> +	return err;
> +}
> +
> +/* ndo_xdp_xmit */
> +int
> +vmxnet3_xdp_xmit(struct net_device *dev,
> +		 int n, struct xdp_frame **frames, u32 flags)
> +{
> +	struct vmxnet3_adapter *adapter = netdev_priv(dev);
> +	struct vmxnet3_tx_queue *tq;
> +	struct netdev_queue *nq;
> +	int i, err, cpu;
> +	int tq_number;
> +
> +	if (unlikely(test_bit(VMXNET3_STATE_BIT_QUIESCED, &adapter->state)))
> +		return -ENETDOWN;
> +	if (unlikely(test_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state)))
> +		return -EINVAL;
> +
> +	tq_number = adapter->num_tx_queues;
> +	cpu = smp_processor_id();
> +	if (likely(cpu < tq_number))
> +		tq = &adapter->tx_queue[cpu];
> +	else
> +		tq = &adapter->tx_queue[reciprocal_scale(cpu, tq_number)];
> +	if (tq->stopped)
> +		return -ENETDOWN;
> +
> +	nq = netdev_get_tx_queue(adapter->netdev, tq->qid);

getting the txq logic is repeated in vmxnet3_xdp_xmit_back(), maybe a
helper?

> +
> +	for (i = 0; i < n; i++) {
> +		err = vmxnet3_xdp_xmit_frame(adapter, frames[i], tq, true);
> +		if (err) {
> +			tq->stats.xdp_xmit_err++;
> +			break;
> +		}
> +	}
> +	tq->stats.xdp_xmit += i;
> +
> +	return i;
> +}
> +
> +static int
> +vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, struct xdp_buff *xdp)
> +{
> +	struct xdp_frame *xdpf;
> +	struct bpf_prog *prog;
> +	struct page *page;
> +	int err;
> +	u32 act;
> +
> +	prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
> +	act = bpf_prog_run_xdp(prog, xdp);
> +	rq->stats.xdp_packets++;
> +	page = virt_to_head_page(xdp->data_hard_start);
> +
> +	switch (act) {
> +	case XDP_PASS:
> +		return act;
> +	case XDP_REDIRECT:
> +		err = xdp_do_redirect(rq->adapter->netdev, xdp, prog);
> +		if (!err)
> +			rq->stats.xdp_redirects++;
> +		else
> +			rq->stats.xdp_drops++;
> +		return act;
> +	case XDP_TX:
> +		xdpf = xdp_convert_buff_to_frame(xdp);
> +		if (unlikely(!xdpf ||
> +			     vmxnet3_xdp_xmit_back(rq->adapter, xdpf))) {
> +			rq->stats.xdp_drops++;
> +			page_pool_recycle_direct(rq->page_pool, page);
> +		} else {
> +			rq->stats.xdp_tx++;
> +		}
> +		return act;
> +	default:
> +		bpf_warn_invalid_xdp_action(rq->adapter->netdev, prog, act);
> +		fallthrough;
> +	case XDP_ABORTED:
> +		trace_xdp_exception(rq->adapter->netdev, prog, act);
> +		rq->stats.xdp_aborted++;
> +		break;
> +	case XDP_DROP:
> +		rq->stats.xdp_drops++;
> +		break;
> +	}
> +
> +	page_pool_recycle_direct(rq->page_pool, page);
> +
> +	return act;
> +}
> +
> +static struct sk_buff *
> +vmxnet3_build_skb(struct vmxnet3_rx_queue *rq, struct page *page,
> +		  const struct xdp_buff *xdp)
> +{
> +	struct sk_buff *skb;
> +
> +	skb = build_skb(page_address(page), PAGE_SIZE);
> +	if (unlikely(!skb)) {
> +		page_pool_recycle_direct(rq->page_pool, page);
> +		rq->stats.rx_buf_alloc_failure++;
> +		return NULL;
> +	}
> +
> +	/* bpf prog might change len and data position. */
> +	skb_reserve(skb, xdp->data - xdp->data_hard_start);
> +	skb_put(skb, xdp->data_end - xdp->data);
> +	skb_mark_for_recycle(skb);
> +
> +	return skb;
> +}
> +
> +/* Handle packets from DataRing. */
> +int
> +vmxnet3_process_xdp_small(struct vmxnet3_adapter *adapter,
> +			  struct vmxnet3_rx_queue *rq,
> +			  void *data, int len,
> +			  struct sk_buff **skb_xdp_pass)
> +{
> +	struct bpf_prog *xdp_prog;
> +	struct xdp_buff xdp;
> +	struct page *page;
> +	int act;
> +
> +	page = page_pool_alloc_pages(rq->page_pool, GFP_ATOMIC);
> +	if (unlikely(!page)) {
> +		rq->stats.rx_buf_alloc_failure++;
> +		return XDP_DROP;
> +	}
> +
> +	xdp_init_buff(&xdp, PAGE_SIZE, &rq->xdp_rxq);
> +	xdp_prepare_buff(&xdp, page_address(page), rq->page_pool->p.offset,
> +			 len, false);
> +	xdp_buff_clear_frags_flag(&xdp);
> +
> +	/* Must copy the data because it's at dataring. */
> +	memcpy(xdp.data, data, len);
> +
> +	rcu_read_lock();

https://lore.kernel.org/bpf/20210624160609.292325-1-toke@redhat.com/

> +	xdp_prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
> +	if (!xdp_prog) {
> +		rcu_read_unlock();
> +		page_pool_recycle_direct(rq->page_pool, page);

recycling the page that is going to be used for build_skb()?
am i missing something?

> +		act = XDP_PASS;
> +		goto out_skb;
> +	}
> +	act = vmxnet3_run_xdp(rq, &xdp);

pass the xdp_prog, no reason to deref this again inside vmxnet3_run_xdp()

> +	rcu_read_unlock();
> +
> +	if (act == XDP_PASS) {
> +out_skb:
> +		*skb_xdp_pass = vmxnet3_build_skb(rq, page, &xdp);
> +		if (!skb_xdp_pass)
> +			return XDP_DROP;
> +	}
> +
> +	/* No need to refill. */
> +	return act;
> +}
> +
> +int
> +vmxnet3_process_xdp(struct vmxnet3_adapter *adapter,
> +		    struct vmxnet3_rx_queue *rq,
> +		    struct Vmxnet3_RxCompDesc *rcd,
> +		    struct vmxnet3_rx_buf_info *rbi,
> +		    struct Vmxnet3_RxDesc *rxd,
> +		    struct sk_buff **skb_xdp_pass)
> +{
> +	struct bpf_prog *xdp_prog;
> +	dma_addr_t new_dma_addr;
> +	struct xdp_buff xdp;
> +	struct page *page;
> +	void *new_data;
> +	int act;
> +
> +	page = rbi->page;
> +	dma_sync_single_for_cpu(&adapter->pdev->dev,
> +				page_pool_get_dma_addr(page) +
> +				rq->page_pool->p.offset, rcd->len,
> +				page_pool_get_dma_dir(rq->page_pool));
> +
> +	xdp_init_buff(&xdp, rbi->len, &rq->xdp_rxq);
> +	xdp_prepare_buff(&xdp, page_address(page), rq->page_pool->p.offset,
> +			 rcd->len, false);
> +	xdp_buff_clear_frags_flag(&xdp);
> +
> +	rcu_read_lock();
> +	xdp_prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
> +	if (!xdp_prog) {
> +		rcu_read_unlock();
> +		act = XDP_PASS;
> +		goto out_skb;
> +	}
> +	act = vmxnet3_run_xdp(rq, &xdp);
> +	rcu_read_unlock();
> +
> +	if (act == XDP_PASS) {
> +out_skb:
> +		*skb_xdp_pass = vmxnet3_build_skb(rq, page, &xdp);
> +		if (!skb_xdp_pass)
> +			act = XDP_DROP;
> +	}
> +
> +	new_data = vmxnet3_pp_get_buff(rq->page_pool, &new_dma_addr,
> +				       GFP_ATOMIC);

are you refilling per each processed buf?

> +	if (!new_data) {
> +		rq->stats.rx_buf_alloc_failure++;
> +		return XDP_DROP;
> +	}
> +	rbi->page = virt_to_head_page(new_data);
> +	rbi->dma_addr = new_dma_addr;
> +	rxd->addr = cpu_to_le64(rbi->dma_addr);
> +	rxd->len = rbi->len;
> +
> +	return act;
> +}
> diff --git a/drivers/net/vmxnet3/vmxnet3_xdp.h b/drivers/net/vmxnet3/vmxnet3_xdp.h
> new file mode 100644
> index 000000000000..b847af941f5a
> --- /dev/null
> +++ b/drivers/net/vmxnet3/vmxnet3_xdp.h
> @@ -0,0 +1,49 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later
> + *
> + * Linux driver for VMware's vmxnet3 ethernet NIC.
> + * Copyright (C) 2008-2023, VMware, Inc. All Rights Reserved.
> + * Maintained by: pv-drivers@vmware.com
> + *
> + */
> +
> +#ifndef _VMXNET3_XDP_H
> +#define _VMXNET3_XDP_H
> +
> +#include <linux/filter.h>
> +#include <linux/bpf_trace.h>
> +#include <linux/netlink.h>
> +#include <net/page_pool.h>
> +#include <net/xdp.h>
> +
> +#include "vmxnet3_int.h"
> +
> +#define VMXNET3_XDP_HEADROOM	(XDP_PACKET_HEADROOM + NET_IP_ALIGN)
> +#define VMXNET3_XDP_RX_TAILROOM	SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
> +#define VMXNET3_XDP_RX_OFFSET	VMXNET3_XDP_HEADROOM
> +#define VMXNET3_XDP_MAX_FRSIZE	(PAGE_SIZE - VMXNET3_XDP_HEADROOM - \
> +				 VMXNET3_XDP_RX_TAILROOM)
> +#define VMXNET3_XDP_MAX_MTU	(VMXNET3_XDP_MAX_FRSIZE - ETH_HLEN - \
> +				 2 * VLAN_HLEN - ETH_FCS_LEN)
> +
> +int vmxnet3_xdp(struct net_device *netdev, struct netdev_bpf *bpf);
> +int vmxnet3_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
> +		     u32 flags);
> +int vmxnet3_process_xdp(struct vmxnet3_adapter *adapter,
> +			struct vmxnet3_rx_queue *rq,
> +			struct Vmxnet3_RxCompDesc *rcd,
> +			struct vmxnet3_rx_buf_info *rbi,
> +			struct Vmxnet3_RxDesc *rxd,
> +			struct sk_buff **skb_xdp_pass);
> +int vmxnet3_process_xdp_small(struct vmxnet3_adapter *adapter,
> +			      struct vmxnet3_rx_queue *rq,
> +			      void *data, int len,
> +			      struct sk_buff **skb_xdp_pass);
> +void *vmxnet3_pp_get_buff(struct page_pool *pp, dma_addr_t *dma_addr,
> +			  gfp_t gfp_mask);
> +
> +static inline bool vmxnet3_xdp_enabled(struct vmxnet3_adapter *adapter)
> +{
> +	return !!rcu_access_pointer(adapter->xdp_bpf_prog);
> +}
> +
> +#endif
> -- 
> 2.37.1 (Apple Git-137.1)
> 
