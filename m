Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16DB974336
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 04:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387830AbfGYCXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 22:23:00 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46930 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728732AbfGYCXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 22:23:00 -0400
Received: by mail-qk1-f195.google.com with SMTP id r4so35260537qkm.13
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 19:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=NKYTsuIimoJRcwCLBpynwSIwok8mraTqdraw0y1obf8=;
        b=MdHx9ZPzbYhL0ouFUzLeF2yRAtTrBWJvT/u0BMydH/akV9UY4GKWXtCSNLdhj1rVFW
         E/zz6IPlumSR1cW5p3ZNysBMiB9XzwQEP3WzbdJrTu0X/hZ+xfmIbA29oGAij7pjvytl
         Ew0g66T4GWhp+97HTiWmhV7Km1ytRwtPCqw9CSmeNTJGRiaH+SDIF72/OljH+8/6Dx5Z
         kzTE9U0uMVFy4n8WZRRgX+/n07dyLREC1FeTyA7jVFe6DS77hpGkFOC+MqDRacQTRLpI
         LfgAId5q88qWXVFp40TE6XpEcZ92aQr3+VzFepeBw9/Y2PbZW53ADfsEIoc2XefAfiIp
         A27g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NKYTsuIimoJRcwCLBpynwSIwok8mraTqdraw0y1obf8=;
        b=QULRheQB4kSqTXr8ULHDR3r+73t95CkiDus2QH6oup4yedNMrFcFsFQFVj1xvV2ntS
         HqWfsslwDzlOkzbmZ/HdVP+Bc/LOfNKVpZk5XCQUa787bbUSHSYFiSV7rPMwGqPVVvG8
         cXSnKmAtxrAa2qSsFkVTzaqwxe+KaYAzs3bj3/AHyzv3mLLCIh+WLz3dUOD+1/AJ8bjJ
         VbxbQ4PtdilMyBtSlZpphwNlR8cfYW3j/jFaqtrWlSWBsBM5zN9YJtT4ktF9XBfetDxV
         99V95jT2J5W/AE+qARoupf2Bu8MwTjjQ9Wr/pKt0x3ggyxbHpr8ey/72RBJh/P0GCJWl
         LPag==
X-Gm-Message-State: APjAAAXj54f832jAIe1tqXWu8kW5I4ge+zuLrNedos955Nyzo4TbWM+S
        617Gy3x3ObAtJjg7mj89lNzM3g==
X-Google-Smtp-Source: APXvYqxjL/fCzteDppzrYfEW+BuLdEmA/I0+uz9x6p9C28tZS1OlLbuGzoLy/TuCMMy/3k5ubgOHqQ==
X-Received: by 2002:ae9:e84b:: with SMTP id a72mr58546912qkg.355.1564021378597;
        Wed, 24 Jul 2019 19:22:58 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s8sm20178154qkg.64.2019.07.24.19.22.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 19:22:58 -0700 (PDT)
Date:   Wed, 24 Jul 2019 19:22:53 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Kevin Laatz <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v3 03/11] xsk: add support to allow unaligned
 chunk placement
Message-ID: <20190724192253.00ac07bd@cakuba.netronome.com>
In-Reply-To: <20190724051043.14348-4-kevin.laatz@intel.com>
References: <20190716030637.5634-1-kevin.laatz@intel.com>
        <20190724051043.14348-1-kevin.laatz@intel.com>
        <20190724051043.14348-4-kevin.laatz@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Jul 2019 05:10:35 +0000, Kevin Laatz wrote:
> Currently, addresses are chunk size aligned. This means, we are very
> restricted in terms of where we can place chunk within the umem. For
> example, if we have a chunk size of 2k, then our chunks can only be placed
> at 0,2k,4k,6k,8k... and so on (ie. every 2k starting from 0).
> 
> This patch introduces the ability to use unaligned chunks. With these
> changes, we are no longer bound to having to place chunks at a 2k (or
> whatever your chunk size is) interval. Since we are no longer dealing with
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
>  net/xdp/xsk.c               | 86 ++++++++++++++++++++++++++++++-------
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

IIRC accesses to xdp_umem_page case a lot of cache misses, so having
this structure grow from 16 to 24B is a little unfortunate :(
Can we try to steal lower bits of addr or dma? Or perhaps not pre
compute this info at all?

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
> @@ -144,6 +146,15 @@ static inline void xsk_umem_fq_reuse(struct xdp_umem *umem, u64 addr)
>  
>  	rq->handles[rq->length++] = addr;
>  }
> +
> +static inline u64 xsk_umem_handle_offset(struct xdp_umem *umem, u64 handle,
> +					 u64 offset)
> +{
> +	if (umem->flags & XDP_UMEM_UNALIGNED_CHUNKS)
> +		return handle |= (offset << XSK_UNALIGNED_BUF_OFFSET_SHIFT);
> +	else
> +		return handle += offset;
> +}
>  #else
>  static inline int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>  {
> @@ -241,6 +252,12 @@ static inline void xsk_umem_fq_reuse(struct xdp_umem *umem, u64 addr)
>  {
>  }
>  
> +static inline u64 xsk_umem_handle_offset(struct xdp_umem *umem, u64 handle,
> +					 u64 offset)
> +{
> +	return NULL;

	return 0?

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
> @@ -299,6 +299,7 @@ static int xdp_umem_account_pages(struct xdp_umem *umem)
>  
>  static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>  {
> +	bool unaligned_chunks = mr->flags & XDP_UMEM_UNALIGNED_CHUNKS;
>  	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
>  	unsigned int chunks, chunks_per_page;
>  	u64 addr = mr->addr, size = mr->len;
> @@ -314,7 +315,10 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>  		return -EINVAL;
>  	}
>  
> -	if (!is_power_of_2(chunk_size))
> +	if (mr->flags & ~(XDP_UMEM_UNALIGNED_CHUNKS))

parens unnecessary, consider adding a define for known flags.

> +		return -EINVAL;
> +
> +	if (!unaligned_chunks && !is_power_of_2(chunk_size))
>  		return -EINVAL;
>  
>  	if (!PAGE_ALIGNED(addr)) {
> @@ -331,9 +335,11 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
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
> @@ -342,13 +348,15 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>  		return -EINVAL;
>  
>  	umem->address = (unsigned long)addr;
> -	umem->chunk_mask = ~((u64)chunk_size - 1);
> +	umem->chunk_mask = unaligned_chunks ? XSK_UNALIGNED_BUF_ADDR_MASK
> +					    : ~((u64)chunk_size - 1);
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
> +/* If a buffer crosses a page boundary, we need to do 2 memcpy's, one for
> + * each page. This is only required in copy mode.
> + */
> +static void __xsk_rcv_memcpy(struct xdp_umem *umem, u64 addr, void *from_buf,
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

Why handle this case gracefully? Real XSK use is the zero copy mode,
having extra code to make copy mode more permissive seems a little
counter productive IMHO.

>  static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
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
> @@ -78,9 +99,13 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
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
> @@ -127,6 +152,7 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>  	u32 len = xdp->data_end - xdp->data;
>  	void *buffer;
>  	u64 addr;
> +	u64 offset = xs->umem->headroom;

reverse xmas tree, please

>  	int err;
>  
>  	spin_lock_bh(&xs->rx_lock);

