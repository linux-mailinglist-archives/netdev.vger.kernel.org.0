Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79A39752EE
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 17:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbfGYPjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 11:39:04 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35880 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728392AbfGYPjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 11:39:04 -0400
Received: by mail-pg1-f196.google.com with SMTP id l21so23231475pgm.3;
        Thu, 25 Jul 2019 08:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=v/kxyE2A6Hzq4IW82IR6/A1CQmOHHC14Hx0JRZ6U23A=;
        b=uSBYSB3+aKRS0Fne1g4ggLCLwZjxdBSvRdJRr4xwrNpkhdHp8pTigtw573rYZXiKWM
         IU2dlNjH6VaHh7yo2RvReEMS4/M6opYS0X4uf6yNSIM5S9foXlnyhBtYDs/fmUBX28DK
         FTUGb1RiI6gLxN68o5g9MlEB/jQJ9k5EwJfNk4Jawiy5Z+5i0CdJejXUj48rslBts+RN
         wuDBxqWWbulTdVOi/xeTsK1Q/O0Sk6Z0+fvuGBSPfsb2O9Zu4ZZUPUst4d/Zh9a5JdQ3
         KZqmdRgF/PAF6ixPughktNJL0N6ZBfycV2+wEhakjn+fiaaq9v5Ev1uEGhk58HM/Yupz
         MIpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=v/kxyE2A6Hzq4IW82IR6/A1CQmOHHC14Hx0JRZ6U23A=;
        b=DmXaZM/zNWk2CW4K1JOylcPQPj0U9pCPE1gYJX3QJjAaRL7limxkJh55DwarE6cwxM
         tZyC1SvNPYS6G3Kh6h/TLRcnmQiG3SlFx4FjxnB9Sf9s4+uGNWqD/1wN4xoV5IFYAKbO
         iPCcLe1pfLbCVq4DAL/lm9BJoEYyycHyWs73Imd4yA4xJ9E6Rh/d/TUeIMAuTOCfWLHL
         pc9A+vWn2hS6eCAJVfcqB6Ad0sTuYsUpFUHuKZLS0VvPBw6is6Z+S5aYNaCZv6vMtl11
         zyGq/73Em5wcGC7HXJunoN3mmsBrUCz8pWaS7d9dnojbdhJdCAz6qGejrFp0xJHljl5z
         Zfsw==
X-Gm-Message-State: APjAAAWj0rXhUG3XHrmxgGxlLm0afRCUW/4MALLpd8LA43vPP9EIS4Zk
        YJzcDjDgaLjD6gz9/PtuGEE=
X-Google-Smtp-Source: APXvYqz1U4LT/cMm9qR3fxtSvlxosoPhEpgOHIfOICTo/YQbO7uw2KUJBMVGbkvc7e5xLL4Q12Oa+g==
X-Received: by 2002:a62:b515:: with SMTP id y21mr17620211pfe.213.1564069143337;
        Thu, 25 Jul 2019 08:39:03 -0700 (PDT)
Received: from [172.20.174.128] ([2620:10d:c090:180::1:622f])
        by smtp.gmail.com with ESMTPSA id f6sm52701201pga.50.2019.07.25.08.39.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 08:39:02 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Kevin Laatz" <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v3 03/11] xsk: add support to allow unaligned
 chunk placement
Date:   Thu, 25 Jul 2019 08:39:00 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <E0F8C5B9-A4CD-47CD-8C72-F840161D178E@gmail.com>
In-Reply-To: <20190724051043.14348-4-kevin.laatz@intel.com>
References: <20190716030637.5634-1-kevin.laatz@intel.com>
 <20190724051043.14348-1-kevin.laatz@intel.com>
 <20190724051043.14348-4-kevin.laatz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23 Jul 2019, at 22:10, Kevin Laatz wrote:

> Currently, addresses are chunk size aligned. This means, we are very
> restricted in terms of where we can place chunk within the umem. For
> example, if we have a chunk size of 2k, then our chunks can only be 
> placed
> at 0,2k,4k,6k,8k... and so on (ie. every 2k starting from 0).
>
> This patch introduces the ability to use unaligned chunks. With these
> changes, we are no longer bound to having to place chunks at a 2k (or
> whatever your chunk size is) interval. Since we are no longer dealing 
> with
> aligned chunks, they can now cross page boundaries. Checks for page
> contiguity have been added in order to keep track of which pages are
> followed by a physically contiguous page.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> Signed-off-by: Bruce Richardson <bruce.richardson@intel.com>
>
> ---
> v2:
>   - Add checks for the flags coming from userspace
>   - Fix how we get chunk_size in xsk_diag.c
>   - Add defines for masking the new descriptor format
>   - Modified the rx functions to use new descriptor format
>   - Modified the tx functions to use new descriptor format
>
> v3:
>   - Add helper function to do address/offset masking/addition
> ---
>  include/net/xdp_sock.h      | 17 ++++++++
>  include/uapi/linux/if_xdp.h |  9 ++++
>  net/xdp/xdp_umem.c          | 18 +++++---
>  net/xdp/xsk.c               | 86 
> ++++++++++++++++++++++++++++++-------
>  net/xdp/xsk_diag.c          |  2 +-
>  net/xdp/xsk_queue.h         | 68 +++++++++++++++++++++++++----
>  6 files changed, 170 insertions(+), 30 deletions(-)
>
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index 69796d264f06..738996c0f995 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -19,6 +19,7 @@ struct xsk_queue;
>  struct xdp_umem_page {
>  	void *addr;
>  	dma_addr_t dma;
> +	bool next_pg_contig;
>  };
>
>  struct xdp_umem_fq_reuse {
> @@ -48,6 +49,7 @@ struct xdp_umem {
>  	bool zc;
>  	spinlock_t xsk_list_lock;
>  	struct list_head xsk_list;
> +	u32 flags;
>  };
>
>  struct xdp_sock {
> @@ -144,6 +146,15 @@ static inline void xsk_umem_fq_reuse(struct 
> xdp_umem *umem, u64 addr)
>
>  	rq->handles[rq->length++] = addr;
>  }
> +
> +static inline u64 xsk_umem_handle_offset(struct xdp_umem *umem, u64 
> handle,
> +					 u64 offset)
> +{
> +	if (umem->flags & XDP_UMEM_UNALIGNED_CHUNKS)
> +		return handle |= (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
> +	else
> +		return handle += offset;
> +}

This should be something like 'xsk_umem_adjust_offset()', and use "+=" 
for both cases.


>  #else
>  static inline int xsk_generic_rcv(struct xdp_sock *xs, struct 
> xdp_buff *xdp)
>  {
> @@ -241,6 +252,12 @@ static inline void xsk_umem_fq_reuse(struct 
> xdp_umem *umem, u64 addr)
>  {
>  }
>
> +static inline u64 xsk_umem_handle_offset(struct xdp_umem *umem, u64 
> handle,
> +					 u64 offset)
> +{
> +	return NULL;
> +}
> +
>  #endif /* CONFIG_XDP_SOCKETS */
>
>  #endif /* _LINUX_XDP_SOCK_H */
> diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
> index faaa5ca2a117..f8dc68fcdf78 100644
> --- a/include/uapi/linux/if_xdp.h
> +++ b/include/uapi/linux/if_xdp.h
> @@ -17,6 +17,9 @@
>  #define XDP_COPY	(1 << 1) /* Force copy-mode */
>  #define XDP_ZEROCOPY	(1 << 2) /* Force zero-copy mode */
>
> +/* Flags for xsk_umem_config flags */
> +#define XDP_UMEM_UNALIGNED_CHUNKS (1 << 0)
> +
>  struct sockaddr_xdp {
>  	__u16 sxdp_family;
>  	__u16 sxdp_flags;
> @@ -53,6 +56,7 @@ struct xdp_umem_reg {
>  	__u64 len; /* Length of packet data area */
>  	__u32 chunk_size;
>  	__u32 headroom;
> +	__u32 flags;
>  };
>
>  struct xdp_statistics {
> @@ -74,6 +78,11 @@ struct xdp_options {
>  #define XDP_UMEM_PGOFF_FILL_RING	0x100000000ULL
>  #define XDP_UMEM_PGOFF_COMPLETION_RING	0x180000000ULL
>
> +/* Masks for unaligned chunks mode */
> +#define XSK_UNALIGNED_BUF_OFFSET_SHIFT 48
> +#define XSK_UNALIGNED_BUF_ADDR_MASK \
> +	((1ULL << XSK_UNALIGNED_BUF_OFFSET_SHIFT) - 1)
> +
>  /* Rx/Tx descriptor */
>  struct xdp_desc {
>  	__u64 addr;
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 83de74ca729a..952ca22103e9 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -299,6 +299,7 @@ static int xdp_umem_account_pages(struct xdp_umem 
> *umem)
>
>  static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg 
> *mr)
>  {
> +	bool unaligned_chunks = mr->flags & XDP_UMEM_UNALIGNED_CHUNKS;
>  	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
>  	unsigned int chunks, chunks_per_page;
>  	u64 addr = mr->addr, size = mr->len;
> @@ -314,7 +315,10 @@ static int xdp_umem_reg(struct xdp_umem *umem, 
> struct xdp_umem_reg *mr)
>  		return -EINVAL;
>  	}
>
> -	if (!is_power_of_2(chunk_size))
> +	if (mr->flags & ~(XDP_UMEM_UNALIGNED_CHUNKS))
> +		return -EINVAL;
> +
> +	if (!unaligned_chunks && !is_power_of_2(chunk_size))
>  		return -EINVAL;
>
>  	if (!PAGE_ALIGNED(addr)) {
> @@ -331,9 +335,11 @@ static int xdp_umem_reg(struct xdp_umem *umem, 
> struct xdp_umem_reg *mr)
>  	if (chunks == 0)
>  		return -EINVAL;
>
> -	chunks_per_page = PAGE_SIZE / chunk_size;
> -	if (chunks < chunks_per_page || chunks % chunks_per_page)
> -		return -EINVAL;
> +	if (!unaligned_chunks) {
> +		chunks_per_page = PAGE_SIZE / chunk_size;
> +		if (chunks < chunks_per_page || chunks % chunks_per_page)
> +			return -EINVAL;
> +	}
>
>  	headroom = ALIGN(headroom, 64);
>
> @@ -342,13 +348,15 @@ static int xdp_umem_reg(struct xdp_umem *umem, 
> struct xdp_umem_reg *mr)
>  		return -EINVAL;
>
>  	umem->address = (unsigned long)addr;
> -	umem->chunk_mask = ~((u64)chunk_size - 1);
> +	umem->chunk_mask = unaligned_chunks ? XSK_UNALIGNED_BUF_ADDR_MASK
> +					    : ~((u64)chunk_size - 1);

The handle needs to be cleaned (reset to base address) when removed
from the fill queue or recycle stack.  This will not provide the correct
semantics for unaligned mode.


>  	umem->size = size;
>  	umem->headroom = headroom;
>  	umem->chunk_size_nohr = chunk_size - headroom;
>  	umem->npgs = size / PAGE_SIZE;
>  	umem->pgs = NULL;
>  	umem->user = NULL;
> +	umem->flags = mr->flags;
>  	INIT_LIST_HEAD(&umem->xsk_list);
>  	spin_lock_init(&umem->xsk_list_lock);
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 59b57d708697..b3ab653091c4 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -45,7 +45,7 @@ EXPORT_SYMBOL(xsk_umem_has_addrs);
>
>  u64 *xsk_umem_peek_addr(struct xdp_umem *umem, u64 *addr)
>  {
> -	return xskq_peek_addr(umem->fq, addr);
> +	return xskq_peek_addr(umem->fq, addr, umem);
>  }
>  EXPORT_SYMBOL(xsk_umem_peek_addr);
>
> @@ -55,21 +55,42 @@ void xsk_umem_discard_addr(struct xdp_umem *umem)
>  }
>  EXPORT_SYMBOL(xsk_umem_discard_addr);
>
> +/* If a buffer crosses a page boundary, we need to do 2 memcpy's, one 
> for
> + * each page. This is only required in copy mode.
> + */
> +static void __xsk_rcv_memcpy(struct xdp_umem *umem, u64 addr, void 
> *from_buf,
> +			     u32 len, u32 metalen)
> +{
> +	void *to_buf = xdp_umem_get_data(umem, addr);
> +
> +	if (xskq_crosses_non_contig_pg(umem, addr, len + metalen)) {
> +		void *next_pg_addr = umem->pages[(addr >> PAGE_SHIFT) + 1].addr;
> +		u64 page_start = addr & (PAGE_SIZE - 1);
> +		u64 first_len = PAGE_SIZE - (addr - page_start);
> +
> +		memcpy(to_buf, from_buf, first_len + metalen);
> +		memcpy(next_pg_addr, from_buf + first_len, len - first_len);
> +
> +		return;
> +	}
> +
> +	memcpy(to_buf, from_buf, len + metalen);
> +}
> +
>  static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 
> len)
>  {
> -	void *to_buf, *from_buf;
> +	u64 offset = xs->umem->headroom;
> +	void *from_buf;
>  	u32 metalen;
>  	u64 addr;
>  	int err;
>
> -	if (!xskq_peek_addr(xs->umem->fq, &addr) ||
> +	if (!xskq_peek_addr(xs->umem->fq, &addr, xs->umem) ||
>  	    len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
>  		xs->rx_dropped++;
>  		return -ENOSPC;
>  	}
>
> -	addr += xs->umem->headroom;
> -
>  	if (unlikely(xdp_data_meta_unsupported(xdp))) {
>  		from_buf = xdp->data;
>  		metalen = 0;
> @@ -78,9 +99,13 @@ static int __xsk_rcv(struct xdp_sock *xs, struct 
> xdp_buff *xdp, u32 len)
>  		metalen = xdp->data - xdp->data_meta;
>  	}
>
> -	to_buf = xdp_umem_get_data(xs->umem, addr);
> -	memcpy(to_buf, from_buf, len + metalen);
> -	addr += metalen;
> +	__xsk_rcv_memcpy(xs->umem, addr + offset, from_buf, len, metalen);
> +
> +	offset += metalen;
> +	if (xs->umem->flags & XDP_UMEM_UNALIGNED_CHUNKS)
> +		addr |= offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT;
> +	else
> +		addr += offset;
>  	err = xskq_produce_batch_desc(xs->rx, addr, len);
>  	if (!err) {
>  		xskq_discard_addr(xs->umem->fq);
> @@ -127,6 +152,7 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct 
> xdp_buff *xdp)
>  	u32 len = xdp->data_end - xdp->data;
>  	void *buffer;
>  	u64 addr;
> +	u64 offset = xs->umem->headroom;
>  	int err;
>
>  	spin_lock_bh(&xs->rx_lock);
> @@ -136,17 +162,17 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct 
> xdp_buff *xdp)
>  		goto out_unlock;
>  	}
>
> -	if (!xskq_peek_addr(xs->umem->fq, &addr) ||
> +	if (!xskq_peek_addr(xs->umem->fq, &addr, xs->umem) ||
>  	    len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
>  		err = -ENOSPC;
>  		goto out_drop;
>  	}
>
> -	addr += xs->umem->headroom;
> -
> -	buffer = xdp_umem_get_data(xs->umem, addr);
> +	buffer = xdp_umem_get_data(xs->umem, addr + offset);
>  	memcpy(buffer, xdp->data_meta, len + metalen);
> -	addr += metalen;
> +	offset += metalen;
> +
> +	addr = xsk_umem_handle_offset(xs->umem, addr, offset);
>  	err = xskq_produce_batch_desc(xs->rx, addr, len);
>  	if (err)
>  		goto out_drop;
> @@ -190,7 +216,7 @@ bool xsk_umem_consume_tx(struct xdp_umem *umem, 
> struct xdp_desc *desc)
>
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(xs, &umem->xsk_list, list) {
> -		if (!xskq_peek_desc(xs->tx, desc))
> +		if (!xskq_peek_desc(xs->tx, desc, umem))
>  			continue;
>
>  		if (xskq_produce_addr_lazy(umem->cq, desc->addr))
> @@ -243,7 +269,7 @@ static int xsk_generic_xmit(struct sock *sk, 
> struct msghdr *m,
>  	if (xs->queue_id >= xs->dev->real_num_tx_queues)
>  		goto out;
>
> -	while (xskq_peek_desc(xs->tx, &desc)) {
> +	while (xskq_peek_desc(xs->tx, &desc, xs->umem)) {
>  		char *buffer;
>  		u64 addr;
>  		u32 len;
> @@ -262,6 +288,10 @@ static int xsk_generic_xmit(struct sock *sk, 
> struct msghdr *m,
>
>  		skb_put(skb, len);
>  		addr = desc.addr;
> +		if (xs->umem->flags & XDP_UMEM_UNALIGNED_CHUNKS)
> +			addr = (addr & XSK_UNALIGNED_BUF_ADDR_MASK) |
> +				(addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT);

This doesn't look right to me.  Shouldn't it be "(addr & mask) + (addr 
 >> shift)"?
I'd also prefer to see this type of logic in an inline/macro

> +
>  		buffer = xdp_umem_get_data(xs->umem, addr);
>  		err = skb_store_bits(skb, 0, buffer, len);
>  		if (unlikely(err) || xskq_reserve_addr(xs->umem->cq)) {
> @@ -272,7 +302,7 @@ static int xsk_generic_xmit(struct sock *sk, 
> struct msghdr *m,
>  		skb->dev = xs->dev;
>  		skb->priority = sk->sk_priority;
>  		skb->mark = sk->sk_mark;
> -		skb_shinfo(skb)->destructor_arg = (void *)(long)addr;
> +		skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
>  		skb->destructor = xsk_destruct_skb;
>
>  		err = dev_direct_xmit(skb, xs->queue_id);
> @@ -412,6 +442,28 @@ static struct socket *xsk_lookup_xsk_from_fd(int 
> fd)
>  	return sock;
>  }
>
> +/* Check if umem pages are contiguous.
> + * If zero-copy mode, use the DMA address to do the page contiguity 
> check
> + * For all other modes we use addr (kernel virtual address)
> + */
> +static void xsk_check_page_contiguity(struct xdp_umem *umem, u32 
> flags)
> +{
> +	int i;
> +
> +	if (flags & XDP_ZEROCOPY) {
> +		for (i = 0; i < umem->npgs - 1; i++)
> +			umem->pages[i].next_pg_contig =
> +					(umem->pages[i].dma + PAGE_SIZE ==
> +						umem->pages[i + 1].dma);
> +		return;
> +	}
> +
> +	for (i = 0; i < umem->npgs - 1; i++)
> +		umem->pages[i].next_pg_contig =
> +				(umem->pages[i].addr + PAGE_SIZE ==
> +					umem->pages[i + 1].addr);
> +}
> +
>  static int xsk_bind(struct socket *sock, struct sockaddr *addr, int 
> addr_len)
>  {
>  	struct sockaddr_xdp *sxdp = (struct sockaddr_xdp *)addr;
> @@ -500,6 +552,8 @@ static int xsk_bind(struct socket *sock, struct 
> sockaddr *addr, int addr_len)
>  		err = xdp_umem_assign_dev(xs->umem, dev, qid, flags);
>  		if (err)
>  			goto out_unlock;
> +
> +		xsk_check_page_contiguity(xs->umem, flags);
>  	}
>
>  	xs->dev = dev;
> diff --git a/net/xdp/xsk_diag.c b/net/xdp/xsk_diag.c
> index d5e06c8e0cbf..9986a759fe06 100644
> --- a/net/xdp/xsk_diag.c
> +++ b/net/xdp/xsk_diag.c
> @@ -56,7 +56,7 @@ static int xsk_diag_put_umem(const struct xdp_sock 
> *xs, struct sk_buff *nlskb)
>  	du.id = umem->id;
>  	du.size = umem->size;
>  	du.num_pages = umem->npgs;
> -	du.chunk_size = (__u32)(~umem->chunk_mask + 1);
> +	du.chunk_size = umem->chunk_size_nohr + umem->headroom;
>  	du.headroom = umem->headroom;
>  	du.ifindex = umem->dev ? umem->dev->ifindex : 0;
>  	du.queue_id = umem->queue_id;
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index 909c5168ed0f..0d77212367f0 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -133,6 +133,16 @@ static inline bool xskq_has_addrs(struct 
> xsk_queue *q, u32 cnt)
>
>  /* UMEM queue */
>
> +static inline bool xskq_crosses_non_contig_pg(struct xdp_umem *umem, 
> u64 addr,
> +					      u64 length)
> +{
> +	bool cross_pg = (addr & (PAGE_SIZE - 1)) + length > PAGE_SIZE;
> +	bool next_pg_contig =
> +		umem->pages[(addr >> PAGE_SHIFT) + 1].next_pg_contig;
> +
> +	return cross_pg && !next_pg_contig;
> +}
> +
>  static inline bool xskq_is_valid_addr(struct xsk_queue *q, u64 addr)
>  {
>  	if (addr >= q->size) {
> @@ -143,23 +153,50 @@ static inline bool xskq_is_valid_addr(struct 
> xsk_queue *q, u64 addr)
>  	return true;
>  }
>
> -static inline u64 *xskq_validate_addr(struct xsk_queue *q, u64 *addr)
> +static inline bool xskq_is_valid_addr_unaligned(struct xsk_queue *q, 
> u64 addr,
> +						u64 length,
> +						struct xdp_umem *umem)
> +{
> +	addr += addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
> +	addr &= XSK_UNALIGNED_BUF_ADDR_MASK;
> +	if (addr >= q->size ||
> +	    xskq_crosses_non_contig_pg(umem, addr, length)) {
> +		q->invalid_descs++;
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static inline u64 *xskq_validate_addr(struct xsk_queue *q, u64 *addr,
> +				      struct xdp_umem *umem)
>  {
>  	while (q->cons_tail != q->cons_head) {
>  		struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
>  		unsigned int idx = q->cons_tail & q->ring_mask;
>
>  		*addr = READ_ONCE(ring->desc[idx]) & q->chunk_mask> +
> +		if (umem->flags & XDP_UMEM_UNALIGNED_CHUNKS) {
> +			if (xskq_is_valid_addr_unaligned(q, *addr,
> +							 umem->chunk_size_nohr,
> +							 umem))
> +				return addr;
> +			goto out;
> +		}
> +
>  		if (xskq_is_valid_addr(q, *addr))
>  			return addr;
>
> +out:
>  		q->cons_tail++;
>  	}
>
>  	return NULL;
>  }
>
> -static inline u64 *xskq_peek_addr(struct xsk_queue *q, u64 *addr)
> +static inline u64 *xskq_peek_addr(struct xsk_queue *q, u64 *addr,
> +				  struct xdp_umem *umem)
>  {
>  	if (q->cons_tail == q->cons_head) {
>  		smp_mb(); /* D, matches A */
> @@ -170,7 +207,7 @@ static inline u64 *xskq_peek_addr(struct xsk_queue 
> *q, u64 *addr)
>  		smp_rmb();
>  	}
>
> -	return xskq_validate_addr(q, addr);
> +	return xskq_validate_addr(q, addr, umem);
>  }
>
>  static inline void xskq_discard_addr(struct xsk_queue *q)
> @@ -229,8 +266,21 @@ static inline int xskq_reserve_addr(struct 
> xsk_queue *q)
>
>  /* Rx/Tx queue */
>
> -static inline bool xskq_is_valid_desc(struct xsk_queue *q, struct 
> xdp_desc *d)
> +static inline bool xskq_is_valid_desc(struct xsk_queue *q, struct 
> xdp_desc *d,
> +				      struct xdp_umem *umem)
>  {
> +	if (umem->flags & XDP_UMEM_UNALIGNED_CHUNKS) {
> +		if (!xskq_is_valid_addr_unaligned(q, d->addr, d->len, umem))
> +			return false;
> +
> +		if (d->len > umem->chunk_size_nohr || d->options) {
> +			q->invalid_descs++;
> +			return false;
> +		}
> +
> +		return true;
> +	}
> +
>  	if (!xskq_is_valid_addr(q, d->addr))
>  		return false;
>
> @@ -244,14 +294,15 @@ static inline bool xskq_is_valid_desc(struct 
> xsk_queue *q, struct xdp_desc *d)
>  }
>
>  static inline struct xdp_desc *xskq_validate_desc(struct xsk_queue 
> *q,
> -						  struct xdp_desc *desc)
> +						  struct xdp_desc *desc,
> +						  struct xdp_umem *umem)
>  {
>  	while (q->cons_tail != q->cons_head) {
>  		struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
>  		unsigned int idx = q->cons_tail & q->ring_mask;
>
>  		*desc = READ_ONCE(ring->desc[idx]);
> -		if (xskq_is_valid_desc(q, desc))
> +		if (xskq_is_valid_desc(q, desc, umem))
>  			return desc;
>
>  		q->cons_tail++;
> @@ -261,7 +312,8 @@ static inline struct xdp_desc 
> *xskq_validate_desc(struct xsk_queue *q,
>  }
>
>  static inline struct xdp_desc *xskq_peek_desc(struct xsk_queue *q,
> -					      struct xdp_desc *desc)
> +					      struct xdp_desc *desc,
> +					      struct xdp_umem *umem)
>  {
>  	if (q->cons_tail == q->cons_head) {
>  		smp_mb(); /* D, matches A */
> @@ -272,7 +324,7 @@ static inline struct xdp_desc 
> *xskq_peek_desc(struct xsk_queue *q,
>  		smp_rmb(); /* C, matches B */
>  	}
>
> -	return xskq_validate_desc(q, desc);
> +	return xskq_validate_desc(q, desc, umem);
>  }
>
>  static inline void xskq_discard_desc(struct xsk_queue *q)
> -- 
> 2.17.1
