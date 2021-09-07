Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7365402ACF
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 16:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244548AbhIGOcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 10:32:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41322 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242395AbhIGOcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 10:32:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631025074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uA4pSqrqstQYPVgBB0JtPz/anbOpQPKgzLlTCSlvo7Q=;
        b=S1cNHnxafVtFRUOMjzuqWynxVmFbf8ighK7XvqbD2+9NeDgzmru8TX/19H50gekzwYkyuC
        MVPCzdVFMmorsvpkTpp12Mrz9loyj818Ndcu6E2gqMAciokH9xSjxAdjSR1JLDN1VNqKw+
        yBF/7gBNzLmrNFkgkj/PGrDkf3AKFHo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-bLlEoCgXNwyDJP9OnHzPZA-1; Tue, 07 Sep 2021 10:31:13 -0400
X-MC-Unique: bLlEoCgXNwyDJP9OnHzPZA-1
Received: by mail-wm1-f72.google.com with SMTP id w25-20020a1cf6190000b0290252505ddd56so3472426wmc.3
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 07:31:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uA4pSqrqstQYPVgBB0JtPz/anbOpQPKgzLlTCSlvo7Q=;
        b=iUr6I5LYukemNYIsqnC1GMY0c6jPlheLS55txrQBD9CuITLvj5Uj3Ffcaft40FWsBF
         LEutxpCTo8pYnbzuL76YAc7HLc0fvK1sfuICTBhkn1zrRByB7/+Qk3kkMZhDqf4tDGo6
         +P6IrqvGhbimEChzxkLPhn3+idd/s5+kulpZOGU7T8cKbuUPvuLw95ZR3bMWhn4WsUKe
         +w2l4JISI77WtIhEujL1wtX+GDNIsYMQ/lkdgjTH3nH6U3derjwZQQ5kNCiYF6MIjNcR
         /xoZ4D5Zat3A3gYZ1a4/sCffEq8xGNVbwobNowOzeiZRle84g29gKxhVsZuPQgw3TXax
         iEKg==
X-Gm-Message-State: AOAM531XN99hNAUL0+Qz5VscUc69/Mg0MTGSJLYNHjXJGJFuDsMEZSPz
        /AQESDZI4q2nxK2A/ILb7vzoDeRnEaO1WnV/GE9MEPMm96v9YOio4XMnoErcmQ2UdmZE1BDBsD7
        GbQ9xptF6wiXtc7BZ
X-Received: by 2002:a5d:5263:: with SMTP id l3mr8952917wrc.159.1631025072273;
        Tue, 07 Sep 2021 07:31:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOY6IFSr5/7mKBTYk7FmcCsa2+tokcP9hg7YhN4k3eQ3Iyfe+Q4KjwxxkWoD1W090KkDuW4w==
X-Received: by 2002:a5d:5263:: with SMTP id l3mr8952868wrc.159.1631025072042;
        Tue, 07 Sep 2021 07:31:12 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id d7sm10031844wrf.3.2021.09.07.07.31.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 07:31:11 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v13 bpf-next 02/18] xdp: introduce flags field in
 xdp_buff/xdp_frame
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <cover.1631007211.git.lorenzo@kernel.org>
 <980ad3161b9a312510c9fff76fa74e675b8f9bf3.1631007211.git.lorenzo@kernel.org>
Message-ID: <52c78ca8-a053-2128-05a0-3aff6f84abd1@redhat.com>
Date:   Tue, 7 Sep 2021 16:31:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <980ad3161b9a312510c9fff76fa74e675b8f9bf3.1631007211.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Minor changes requested below)

On 07/09/2021 14.35, Lorenzo Bianconi wrote:
> Introduce flags field in xdp_frame and xdp_buffer data structures
> to define additional buffer features. At the moment the only
> supported buffer feature is multi-buffer bit (mb). Multi-buffer bit
> is used to specify if this is a linear buffer (mb = 0) or a multi-buffer
> frame (mb = 1). In the latter case the driver is expected to initialize
> the skb_shared_info structure at the end of the first buffer to link
> together subsequent buffers belonging to the same frame.
> 
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>   include/net/xdp.h | 29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index ad5b02dcb6f4..ed5ea784fd45 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -66,6 +66,10 @@ struct xdp_txq_info {
>   	struct net_device *dev;
>   };
>   
> +enum xdp_buff_flags {
> +	XDP_FLAGS_MULTI_BUFF	= BIT(0), /* non-linear xdp buff */
> +};
> +
>   struct xdp_buff {
>   	void *data;
>   	void *data_end;
> @@ -74,13 +78,30 @@ struct xdp_buff {
>   	struct xdp_rxq_info *rxq;
>   	struct xdp_txq_info *txq;
>   	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
> +	u16 flags; /* supported values defined in xdp_flags */
                                                   ^^^^^^^^^
Variable/enum is named "xdp_buff_flags", but comment says "xdp_flags".

I think we should change flags to use u32, because xdp_buff already 
contain 4 byte padding. (pahole output provided as help below)

>   };
>   
> +static __always_inline bool xdp_buff_is_mb(struct xdp_buff *xdp)
> +{
> +	return !!(xdp->flags & XDP_FLAGS_MULTI_BUFF);
> +}
> +
> +static __always_inline void xdp_buff_set_mb(struct xdp_buff *xdp)
> +{
> +	xdp->flags |= XDP_FLAGS_MULTI_BUFF;
> +}
> +
> +static __always_inline void xdp_buff_clear_mb(struct xdp_buff *xdp)
> +{
> +	xdp->flags &= ~XDP_FLAGS_MULTI_BUFF;
> +}
> +
>   static __always_inline void
>   xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
>   {
>   	xdp->frame_sz = frame_sz;
>   	xdp->rxq = rxq;
> +	xdp->flags = 0;
>   }
>   
>   static __always_inline void
> @@ -122,8 +143,14 @@ struct xdp_frame {
>   	 */
>   	struct xdp_mem_info mem;
>   	struct net_device *dev_rx; /* used by cpumap */
> +	u16 flags; /* supported values defined in xdp_flags */
                                                   ^^^^^^^^^
Variable/enum is named "xdp_buff_flags", but comment says "xdp_flags".

Here (for xdp_frame) I also think we should change flags to u32, because 
adding this u16 cause extra padding anyhow. (pahole output provided as 
help below).


>   };
>   
> +static __always_inline bool xdp_frame_is_mb(struct xdp_frame *frame)
> +{
> +	return !!(frame->flags & XDP_FLAGS_MULTI_BUFF);
> +}
> +
>   #define XDP_BULK_QUEUE_SIZE	16
>   struct xdp_frame_bulk {
>   	int count;
> @@ -180,6 +207,7 @@ void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
>   	xdp->data_end = frame->data + frame->len;
>   	xdp->data_meta = frame->data - frame->metasize;
>   	xdp->frame_sz = frame->frame_sz;
> +	xdp->flags = frame->flags;
>   }
>   
>   static inline
> @@ -206,6 +234,7 @@ int xdp_update_frame_from_buff(struct xdp_buff *xdp,
>   	xdp_frame->headroom = headroom - sizeof(*xdp_frame);
>   	xdp_frame->metasize = metasize;
>   	xdp_frame->frame_sz = xdp->frame_sz;
> +	xdp_frame->flags = xdp->flags;
>   
>   	return 0;
>   }
> 



Details below... no need to read any further

Investigating struct xdp_frame with pahole:

$ pahole -C xdp_frame net/core/xdp.o
struct xdp_frame {
	void *                     data;             /*     0     8 */
	u16                        len;              /*     8     2 */
	u16                        headroom;         /*    10     2 */
	u32                        metasize:8;       /*    12: 0  4 */
	u32                        frame_sz:24;      /*    12: 8  4 */
	struct xdp_mem_info        mem;              /*    16     8 */
	struct net_device *        dev_rx;           /*    24     8 */

	/* size: 32, cachelines: 1, members: 7 */
	/* last cacheline: 32 bytes */
};


  pahole -C xdp_frame net/core/xdp.o
struct xdp_frame {
	void *                     data;             /*     0     8 */
	u16                        len;              /*     8     2 */
	u16                        headroom;         /*    10     2 */
	u32                        metasize:8;       /*    12: 0  4 */
	u32                        frame_sz:24;      /*    12: 8  4 */
	struct xdp_mem_info        mem;              /*    16     8 */
	struct net_device *        dev_rx;           /*    24     8 */
	u16                        flags;            /*    32     2 */

	/* size: 40, cachelines: 1, members: 8 */
	/* padding: 6 */
	/* last cacheline: 40 bytes */
};


$ pahole -C xdp_frame net/core/xdp.o
struct xdp_frame {
	void *                     data;             /*     0     8 */
	u16                        len;              /*     8     2 */
	u16                        headroom;         /*    10     2 */
	u32                        metasize:8;       /*    12: 0  4 */
	u32                        frame_sz:24;      /*    12: 8  4 */
	struct xdp_mem_info        mem;              /*    16     8 */
	struct net_device *        dev_rx;           /*    24     8 */
	u32                        flags;            /*    32     4 */

	/* size: 40, cachelines: 1, members: 8 */
	/* padding: 4 */
	/* last cacheline: 40 bytes */
};


Details for struct xdp_buff, it already contains 4 bytes padding.

$ pahole -C xdp_buff net/core/xdp.o
struct xdp_buff {
	void *                     data;             /*     0     8 */
	void *                     data_end;         /*     8     8 */
	void *                     data_meta;        /*    16     8 */
	void *                     data_hard_start;  /*    24     8 */
	struct xdp_rxq_info *      rxq;              /*    32     8 */
	struct xdp_txq_info *      txq;              /*    40     8 */
	u32                        frame_sz;         /*    48     4 */
	u16                        flags;            /*    52     2 */

	/* size: 56, cachelines: 1, members: 8 */
	/* padding: 2 */
	/* last cacheline: 56 bytes */
};

