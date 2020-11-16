Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEE22B3F94
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgKPJNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727812AbgKPJNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:13:25 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0854EC0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 01:13:23 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id t9so17933022edq.8
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 01:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=b64DklvkPbJlghCpQ9o33D4Srw1SHKJxfzxD/FgwdD0=;
        b=jUJCvlVe/hM1y+Lb2TrbXSWEld4ElJHChOmjbH3XmloUiNlfkQPnoC81kynrL3dk5e
         9glLcAujNINZE5THL50H3wF7IeifGRpVxckLb1XZVdvueiRaXs0pKiXWdvS72+EnXCfz
         b4dbKIM6jdALr5LLE2z4X8t7IL59HSHub3UqeDN9yDEeHO6kanZ+4ay7uSOAkSMGd6pK
         MNZHkTIeaGdZn6bBaEV+zp37O/XeO4dEflxdg8bhSI3DVplGC/0Aw/Alihej/IxNhO17
         aIUjEJqXob77gF83WYO/lt8xQ/sb6ykfmErd+osD0g3CKZ/z9s9mB9ifOl+8Xw5T1TxZ
         hE0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=b64DklvkPbJlghCpQ9o33D4Srw1SHKJxfzxD/FgwdD0=;
        b=jqZFtG1kClfVqgBWp8+3qPSn2ANU458R/uUrqpvdyJdUIIpRN8j+ialTd4+CTQv5jA
         hiPeuDKR/Y5jk38X06BKtuEsEDh9fO2vb0k448HwOj4gmYwNf4ulflYp79S31nM/Z7g1
         N1wPysJnXxMXtZLun5N7boZ6Ep7hW7/WM/FaoJYYWjvD5WQHzkaENv5aWOZHgdq30tFw
         vf4uX/RYiAyacFhZ8mqO752THlP5k8nkDF/I51edV8qHV3RplflCmYcfib5mXz16Oa6o
         /FeAzPDhQHKCIRoY5Frb+jMZ45n/QGCPds0IYpQVV3YoRC8eSJLMnND/y1GY1Rm9zwXR
         IZRg==
X-Gm-Message-State: AOAM532g2l7f0tiNy51JJcxSqCqCtB+QCh1xZgo6I3FUvjs7tPk9tgtG
        74Y5FFiwgjN8OgUrBNiLQaMdTelqBs6WOgwcRb1SzA==
X-Google-Smtp-Source: ABdhPJzbb2CEFmZHPu02GiWFosq6pO5nK8WyF+Ii74ndpPPn+AWTh6mMqEkNn929jplJTFTFCpOa0MrY1mMrn6H/oWE=
X-Received: by 2002:a05:6402:48d:: with SMTP id k13mr14919406edv.92.1605518001742;
 Mon, 16 Nov 2020 01:13:21 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a54:380d:0:0:0:0:0 with HTTP; Mon, 16 Nov 2020 01:13:21
 -0800 (PST)
X-Originating-IP: [5.35.10.61]
In-Reply-To: <b18c1f2cfb0c9c0b409c25f4a73248e869c8ac97.1605513087.git.xuanzhuo@linux.alibaba.com>
References: <b18c1f2cfb0c9c0b409c25f4a73248e869c8ac97.1605513087.git.xuanzhuo@linux.alibaba.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Mon, 16 Nov 2020 12:13:21 +0300
Message-ID: <CAOJe8K3wz=-LC++N-Hvrturt46+AAK1cW8VYXK+VMT9y1OSzmQ@mail.gmail.com>
Subject: Re: [PATCH] xsk: add cq event
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/20, Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> When we write all cq items to tx, we have to wait for a new event based
> on poll to indicate that it is writable. But the current writability is
> triggered based on whether tx is full or not, and In fact, when tx is
> dissatisfied, the user of cq's item may not necessarily get it, because it
> may still be occupied by the network card. In this case, we need to know
> when cq is available, so this patch adds a socket option, When the user
> configures this option using setsockopt, when cq is available, a
> readable event is generated for all xsk bound to this umem.
>
> I can't find a better description of this event,
> I think it can also be 'readable', although it is indeed different from
> the 'readable' of the new data. But the overhead of xsk checking whether
> cq or rx is readable is small.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  include/net/xdp_sock.h      |  1 +
>  include/uapi/linux/if_xdp.h |  1 +
>  net/xdp/xsk.c               | 28 ++++++++++++++++++++++++++++
>  3 files changed, 30 insertions(+)
>
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index 1a9559c..faf5b1a 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -49,6 +49,7 @@ struct xdp_sock {
>  	struct xsk_buff_pool *pool;
>  	u16 queue_id;
>  	bool zc;
> +	bool cq_event;
>  	enum {
>  		XSK_READY = 0,
>  		XSK_BOUND,
> diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
> index a78a809..2dba3cb 100644
> --- a/include/uapi/linux/if_xdp.h
> +++ b/include/uapi/linux/if_xdp.h
> @@ -63,6 +63,7 @@ struct xdp_mmap_offsets {
>  #define XDP_UMEM_COMPLETION_RING	6
>  #define XDP_STATISTICS			7
>  #define XDP_OPTIONS			8
> +#define XDP_CQ_EVENT			9
>
>  struct xdp_umem_reg {
>  	__u64 addr; /* Start of packet data area */
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index cfbec39..0c53403 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -285,7 +285,16 @@ void __xsk_map_flush(void)
>
>  void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries)
>  {
> +	struct xdp_sock *xs;
> +
>  	xskq_prod_submit_n(pool->cq, nb_entries);
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(xs, &pool->xsk_tx_list, tx_list) {
> +		if (xs->cq_event)
> +			sock_def_readable(&xs->sk);
> +	}
> +	rcu_read_unlock();
>  }
>  EXPORT_SYMBOL(xsk_tx_completed);
>
> @@ -495,6 +504,9 @@ static __poll_t xsk_poll(struct file *file, struct
> socket *sock,
>  			__xsk_sendmsg(sk);
>  	}
>
> +	if (xs->cq_event && pool->cq && !xskq_prod_is_empty(pool->cq))
> +		mask |= EPOLLIN | EPOLLRDNORM;
> +
>  	if (xs->rx && !xskq_prod_is_empty(xs->rx))
>  		mask |= EPOLLIN | EPOLLRDNORM;
>  	if (xs->tx && !xskq_cons_is_full(xs->tx))
> @@ -882,6 +894,22 @@ static int xsk_setsockopt(struct socket *sock, int
> level, int optname,
>  		mutex_unlock(&xs->mutex);
>  		return err;
>  	}
> +	case XDP_CQ_EVENT:
> +	{
> +		int cq_event;
> +
> +		if (optlen < sizeof(cq_event))
> +			return -EINVAL;
> +		if (copy_from_sockptr(&cq_event, optval, sizeof(cq_event)))
> +			return -EFAULT;
> +
> +		if (cq_event)
> +			xs->cq_event = true;
> +		else
> +			xs->cq_event = false;

It's false by default, isn't it?

> +
> +		return 0;
> +	}
>  	default:
>  		break;
>  	}
> --
> 1.8.3.1
>
>
