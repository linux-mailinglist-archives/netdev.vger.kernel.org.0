Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7744582F0
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 11:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237965AbhKUKfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 05:35:23 -0500
Received: from mga18.intel.com ([134.134.136.126]:45799 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233977AbhKUKfW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 05:35:22 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10174"; a="221536142"
X-IronPort-AV: E=Sophos;i="5.87,252,1631602800"; 
   d="scan'208";a="221536142"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2021 02:32:18 -0800
X-IronPort-AV: E=Sophos;i="5.87,252,1631602800"; 
   d="scan'208";a="508550472"
Received: from krausnex-mobl.ger.corp.intel.com (HELO [10.13.8.200]) ([10.13.8.200])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2021 02:32:15 -0800
Subject: Re: [Intel-wired-lan] [PATCH net-next 1/2] igc: AF_XDP zero-copy
 metadata adjust breaks SKBs on XDP_PASS
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, bjorn@kernel.org,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, magnus.karlsson@intel.com
References: <163700856423.565980.10162564921347693758.stgit@firesoul>
 <163700858579.565980.15265721798644582439.stgit@firesoul>
From:   "Kraus, NechamaX" <nechamax.kraus@linux.intel.com>
Message-ID: <3e47fd8d-b725-8a52-d1ff-363a7194061c@linux.intel.com>
Date:   Sun, 21 Nov 2021 12:32:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <163700858579.565980.15265721798644582439.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/2021 22:36, Jesper Dangaard Brouer wrote:
> Driver already implicitly supports XDP metadata access in AF_XDP
> zero-copy mode, as xsk_buff_pool's xp_alloc() naturally set xdp_buff
> data_meta equal data.
> 
> This works fine for XDP and AF_XDP, but if a BPF-prog adjust via
> bpf_xdp_adjust_meta() and choose to call XDP_PASS, then igc function
> igc_construct_skb_zc() will construct an invalid SKB packet. The
> function correctly include the xdp->data_meta area in the memcpy, but
> forgot to pull header to take metasize into account.
> 
> Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_main.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>


