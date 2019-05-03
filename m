Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39ADC12560
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 02:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfECANZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 20:13:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:8926 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfECANY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 20:13:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 17:13:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,423,1549958400"; 
   d="scan'208";a="140835621"
Received: from samudral-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga006.jf.intel.com with ESMTP; 02 May 2019 17:13:23 -0700
Subject: Re: [RFC bpf-next 4/7] netdevice: introduce busy-poll setsockopt for
 AF_XDP
To:     Magnus Karlsson <magnus.karlsson@intel.com>, bjorn.topel@intel.com,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        brouer@redhat.com
Cc:     bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com, maximmi@mellanox.com,
        kevin.laatz@intel.com
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
 <1556786363-28743-5-git-send-email-magnus.karlsson@intel.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <762e74a9-24d6-b6a6-da61-139056fda0e5@intel.com>
Date:   Thu, 2 May 2019 17:13:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556786363-28743-5-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/2/2019 1:39 AM, Magnus Karlsson wrote:
> This patch introduces a new setsockopt that enables busy-poll for XDP
> sockets. It is called XDP_BUSY_POLL_BATCH_SIZE and takes batch size as
> an argument. A value between 1 and NAPI_WEIGHT (64) will turn it on, 0
> will turn it off and any other value will return an error. There is
> also a corresponding getsockopt implementation.

I think this socket option should also allow specifying a timeout value 
when using blocking poll() calls.
OR can we use SO_BUSY_POLL to specify this timeout value?

> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>   include/uapi/linux/if_xdp.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
> index caed8b1..be28a78 100644
> --- a/include/uapi/linux/if_xdp.h
> +++ b/include/uapi/linux/if_xdp.h
> @@ -46,6 +46,7 @@ struct xdp_mmap_offsets {
>   #define XDP_UMEM_FILL_RING		5
>   #define XDP_UMEM_COMPLETION_RING	6
>   #define XDP_STATISTICS			7
> +#define XDP_BUSY_POLL_BATCH_SIZE	8
>   
>   struct xdp_umem_reg {
>   	__u64 addr; /* Start of packet data area */
> 
