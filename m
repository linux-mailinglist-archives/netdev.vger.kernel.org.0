Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B761B8372
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 05:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgDYDYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 23:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726044AbgDYDYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 23:24:14 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3DC7C09B049;
        Fri, 24 Apr 2020 20:24:13 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id ay1so4496729plb.0;
        Fri, 24 Apr 2020 20:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+WWRfuh7orlDLquuWjDA1XfaW8hyaMu/nAdtjV6yHDE=;
        b=JLIs3Bh4uHW3U/AMTC7VFILjriTdxHiuOYupAn0iehDHDeTsN5duNJObH9sOT43MZu
         vLRx22woP89ph1nqPeGwjYxt2QKmZwFiOMSIS1ZMB0irD8MTGRXDxiZ6ckGF+ud2belB
         nQK1370Wf7XcGwGrB+Lig59AyT3k2qlaVgcO4qMWEHYO3geDRyA6tIon/IDtqo2ChVwt
         eQ83Yk63lPFmy1Y47GlKamnRkeggu9jMsLn6mOkSL8HEIOBroUF9a7Y8f47Bk/6+aLTY
         KoBryaGPn7Q86xstFz+GhtzSJlF2xQeapA79siddEzfq+5GEH5k0L8dRxDnr1HlqIEmi
         izWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+WWRfuh7orlDLquuWjDA1XfaW8hyaMu/nAdtjV6yHDE=;
        b=DvGhbnz286JEB6vTfli9+S/c6/dAEIvyeI4R0CDfpU4ZIMU6wmTyzGIzopWsSsJ8ME
         xo4ri2ZdT27eToeI7PsZ8XccIjTCpCGdgUH4vHR0JXARfdFIztmdRe3ViJ81HUBkOVsN
         VqrZ/lasNDO+TkCo3T0xVhcc14BcHRxu5A8OZC2U+AbwpRbDDQOlhpvIY+fV7+09PxZO
         9a/BWKyXb+qA7EDUIFIY7VQ6SEwo8289cTzyPDuWgxI6Cmd+vaFaOLXxHh9T2F4vqawr
         XJXx30erF1vkG1wWAPRc5kSQ4xG9kJbvC1NZaKzGA/hfCafqgTOTOAMC69KMHUcIDoqN
         9GXw==
X-Gm-Message-State: AGi0Pubmq3lcuv8DDa9O7q+wkiGulGDYuIStkbbLPnyEwO/5/T2agEdT
        mOSCAK1w77mQok8tquPdVqI=
X-Google-Smtp-Source: APiQypKq4i0pK29jsd54pGTw2Q9VSTzYuEzalz8VHem8Lrq2yZj6xK1wFb/3eKyGIrSXmrCx2ekT3w==
X-Received: by 2002:a17:902:b617:: with SMTP id b23mr13199898pls.194.1587785053356;
        Fri, 24 Apr 2020 20:24:13 -0700 (PDT)
Received: from [192.168.1.18] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id u8sm5801288pjy.16.2020.04.24.20.24.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 20:24:12 -0700 (PDT)
Subject: Re: [PATCH net-next 07/33] xdp: xdp_frame add member frame_sz and
 handle in convert_to_xdp_frame
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        zorik@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
 <158757167661.1370371.5983006045491610549.stgit@firesoul>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <5c929d29-8cf8-de81-3b96-f63a9195c735@gmail.com>
Date:   Sat, 25 Apr 2020 12:24:07 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <158757167661.1370371.5983006045491610549.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/04/23 1:07, Jesper Dangaard Brouer wrote:
> Use hole in struct xdp_frame, when adding member frame_sz, which keeps
> same sizeof struct (32 bytes)
> 
> Drivers ixgbe and sfc had bug cases where the necessary/expected
> tailroom was not reserved. This can lead to some hard to catch memory
> corruption issues. Having the drivers frame_sz this can be detected when
> packet length/end via xdp->data_end exceed the xdp_data_hard_end
> pointer, which accounts for the reserved the tailroom.
> 
> When detecting this driver issue, simply fail the conversion with NULL,
> which results in feedback to driver (failing xdp_do_redirect()) causing
> driver to drop packet. Given the lack of consistent XDP stats, this can
> be hard to troubleshoot. And given this is a driver bug, we want to
> generate some more noise in form of a WARN stack dump (to ID the driver
> code that inlined convert_to_xdp_frame).
> 
> Inlining the WARN macro is problematic, because it adds an asm
> instruction (on Intel CPUs ud2) what influence instruction cache
> prefetching. Thus, introduce xdp_warn and macro XDP_WARN, to avoid this
> and at the same time make identifying the function and line of this
> inlined function easier.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   include/net/xdp.h |   14 +++++++++++++-
>   net/core/xdp.c    |    7 +++++++
>   2 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 99f4374f6214..55a885aa4e53 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -93,7 +93,8 @@ struct xdp_frame {
>   	void *data;
>   	u16 len;
>   	u16 headroom;
> -	u16 metasize;
> +	u32 metasize:8;
> +	u32 frame_sz:24;
>   	/* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
>   	 * while mem info is valid on remote CPU.
>   	 */
> @@ -108,6 +109,10 @@ static inline void xdp_scrub_frame(struct xdp_frame *frame)
>   	frame->dev_rx = NULL;
>   }
>   
> +/* Avoids inlining WARN macro in fast-path */
> +void xdp_warn(const char* msg, const char* func, const int line);
> +#define XDP_WARN(msg) xdp_warn(msg, __func__, __LINE__)

Shouldn't this have WARN_ONCE()-like mechanism?
A buggy driver may generate massive amount of dump messages...

Toshiaki Makita

> +
>   struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
>   
>   /* Convert xdp_buff to xdp_frame */
> @@ -128,6 +133,12 @@ struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
>   	if (unlikely((headroom - metasize) < sizeof(*xdp_frame)))
>   		return NULL;
>   
> +	/* Catch if driver didn't reserve tailroom for skb_shared_info */
> +	if (unlikely(xdp->data_end > xdp_data_hard_end(xdp))) {
> +		XDP_WARN("Driver BUG: missing reserved tailroom");
> +		return NULL;
> +	}
> +
>   	/* Store info in top of packet */
>   	xdp_frame = xdp->data_hard_start;
>   
> @@ -135,6 +146,7 @@ struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
>   	xdp_frame->len  = xdp->data_end - xdp->data;
>   	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
>   	xdp_frame->metasize = metasize;
> +	xdp_frame->frame_sz = xdp->frame_sz;
>   
>   	/* rxq only valid until napi_schedule ends, convert to xdp_mem_info */
>   	xdp_frame->mem = xdp->rxq->mem;
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 4c7ea85486af..4bc3026ae218 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -11,6 +11,7 @@
>   #include <linux/slab.h>
>   #include <linux/idr.h>
>   #include <linux/rhashtable.h>
> +#include <linux/bug.h>
>   #include <net/page_pool.h>
>   
>   #include <net/xdp.h>
> @@ -496,3 +497,9 @@ struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp)
>   	return xdpf;
>   }
>   EXPORT_SYMBOL_GPL(xdp_convert_zc_to_xdp_frame);
> +
> +/* Used by XDP_WARN macro, to avoid inlining WARN() in fast-path */
> +void xdp_warn(const char* msg, const char* func, const int line) {
> +	WARN(1, "XDP_WARN: %s(line:%d): %s\n", func, line, msg);
> +};
> +EXPORT_SYMBOL_GPL(xdp_warn);
> 
> 
