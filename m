Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 792C27CBF2
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 20:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbfGaS0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 14:26:42 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46792 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfGaS0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 14:26:42 -0400
Received: by mail-pf1-f193.google.com with SMTP id c3so9197275pfa.13;
        Wed, 31 Jul 2019 11:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=gXFTZDZYh/lSmKVmhvKdGRFWTUDqCdiSs/uTEkViV5Q=;
        b=R3xzSA/5pwySc9yVdiB8925NpKw/nRRvZ16m897cP6Q8NrgZExMcmcnwBtvHx5+59A
         H3vMp9kys4CmTTowPb2wloMfiVMk1dMfbZZrRxDnldIbUSWMAcO+5J/KDgTnCzQrGwge
         XyECovq+Pq10XntCUeLU5G8SJ+pw36bzznLiBIoCRX1BO+ph7FgiQjwcV/djYuV/0kU7
         am/gSAyCachclFeUbQrEa7l6lgvflOig/MuXtqjZM1aRoxpVju0pUrsT4TQVH0EQo6xO
         bvuiK9CbiCnv1oAmrs/k1bWOSy+1X9rs0vDmr6Vc5jWK07XV8PQSoRBHhqEAXf1jYumh
         zJHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=gXFTZDZYh/lSmKVmhvKdGRFWTUDqCdiSs/uTEkViV5Q=;
        b=llavfEuymbYyTVmyjYBmrdryXtsMcwO+V4nBsmRtSop/GEwwH5TMsXQFJZxNXDNFMt
         F5slFMzWp+mTw3EIa8B7RTd8KQ0PM98MTruc4SEN+WAPMnaU1NwRlgALhAYMQgEgKYcr
         OF4vpkkaLwjfibw0FxO+Y7ZQMrTfHrOwMJAaptmuP02xGJBVgfww6wemINZVqvaZPI8B
         YlHrhnBOrr8j2HyDmxAHeJDFtqDinL80tR0t9oOr9Momj9OnpNEDV0mJGgGEHn7j7Wo5
         gtL9yHw5nlpiyDMVOYqKqT6HRSIx5xOW8pNr6kaZ/VAV1gvcGuxhhj9TL8EgpL9pg9jB
         nLWw==
X-Gm-Message-State: APjAAAWCuMllk/dQ4xKpAICAcN65lamFjRY6g1OdlSN88L/EGHW07/hN
        FIUDMjSoYTjd9hY8mOyadsE=
X-Google-Smtp-Source: APXvYqztLKuPfMIY2v0mu9mgwt9015tFQ3xt6+jTlYeeWpMtx7iYXxzjOfmXKVkIFFTpwCIHyEfnUw==
X-Received: by 2002:a17:90a:1d8:: with SMTP id 24mr4353044pjd.70.1564597601115;
        Wed, 31 Jul 2019 11:26:41 -0700 (PDT)
Received: from [172.26.116.133] ([2620:10d:c090:180::1:768c])
        by smtp.gmail.com with ESMTPSA id 195sm111860815pfu.75.2019.07.31.11.26.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 11:26:40 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Kevin Laatz" <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v4 09/11] samples/bpf: add buffer recycling for
 unaligned chunks to xdpsock
Date:   Wed, 31 Jul 2019 11:26:39 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <AB07E875-FFAE-4F5F-8A8C-EA38CE9D4580@gmail.com>
In-Reply-To: <20190730085400.10376-10-kevin.laatz@intel.com>
References: <20190724051043.14348-1-kevin.laatz@intel.com>
 <20190730085400.10376-1-kevin.laatz@intel.com>
 <20190730085400.10376-10-kevin.laatz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30 Jul 2019, at 1:53, Kevin Laatz wrote:

> This patch adds buffer recycling support for unaligned buffers. Since 
> we
> don't mask the addr to 2k at umem_reg in unaligned mode, we need to 
> make
> sure we give back the correct (original) addr to the fill queue. We 
> achieve
> this using the new descriptor format and associated masks. The new 
> format
> uses the upper 16-bits for the offset and the lower 48-bits for the 
> addr.
> Since we have a field for the offset, we no longer need to modify the
> actual address. As such, all we have to do to get back the original 
> address
> is mask for the lower 48 bits (i.e. strip the offset and we get the 
> address
> on it's own).
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
> Signed-off-by: Bruce Richardson <bruce.richardson@intel.com>
>
> ---
> v2:
>   - Removed unused defines
>   - Fix buffer recycling for unaligned case
>   - Remove --buf-size (--frame-size merged before this)
>   - Modifications to use the new descriptor format for buffer 
> recycling
> ---
>  samples/bpf/xdpsock_user.c | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
>
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index 756b00eb1afe..62b2059cd0e3 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -475,6 +475,7 @@ static void kick_tx(struct xsk_socket_info *xsk)
>
>  static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
>  {
> +	struct xsk_umem_info *umem = xsk->umem;
>  	u32 idx_cq = 0, idx_fq = 0;
>  	unsigned int rcvd;
>  	size_t ndescs;
> @@ -487,22 +488,21 @@ static inline void complete_tx_l2fwd(struct 
> xsk_socket_info *xsk)
>  		xsk->outstanding_tx;
>
>  	/* re-add completed Tx buffers */
> -	rcvd = xsk_ring_cons__peek(&xsk->umem->cq, ndescs, &idx_cq);
> +	rcvd = xsk_ring_cons__peek(&umem->cq, ndescs, &idx_cq);
>  	if (rcvd > 0) {
>  		unsigned int i;
>  		int ret;
>
> -		ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
> +		ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
>  		while (ret != rcvd) {
>  			if (ret < 0)
>  				exit_with_error(-ret);
> -			ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd,
> -						     &idx_fq);
> +			ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
>  		}
> +
>  		for (i = 0; i < rcvd; i++)
> -			*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) =
> -				*xsk_ring_cons__comp_addr(&xsk->umem->cq,
> -							  idx_cq++);
> +			*xsk_ring_prod__fill_addr(&umem->fq, idx_fq++) =
> +				*xsk_ring_cons__comp_addr(&umem->cq, idx_cq++);
>
>  		xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
>  		xsk_ring_cons__release(&xsk->umem->cq, rcvd);
> @@ -549,7 +549,11 @@ static void rx_drop(struct xsk_socket_info *xsk)
>  	for (i = 0; i < rcvd; i++) {
>  		u64 addr = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx)->addr;
>  		u32 len = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx++)->len;
> -		char *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
> +		u64 offset = addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
> +
> +		addr &= XSK_UNALIGNED_BUF_ADDR_MASK;
> +		char *pkt = xsk_umem__get_data(xsk->umem->buffer,
> +				addr + offset);

The mask constants should not be part of the api - this should be
hidden behind an accessor.

Something like:
   u64 addr = xsk_umem__get_addr(xsk->umem, handle);




>  		hex_dump(pkt, len, addr);
>  		*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) = addr;
> @@ -655,7 +659,9 @@ static void l2fwd(struct xsk_socket_info *xsk)
>  							  idx_rx)->addr;
>  			u32 len = xsk_ring_cons__rx_desc(&xsk->rx,
>  							 idx_rx++)->len;
> -			char *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
> +			u64 offset = addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
> +			char *pkt = xsk_umem__get_data(xsk->umem->buffer,
> +				(addr & XSK_UNALIGNED_BUF_ADDR_MASK) + offset);
>
>  			swap_mac_addresses(pkt);
>
> -- 
> 2.17.1
