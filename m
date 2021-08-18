Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C763F03BC
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235731AbhHRMbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:31:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52726 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234949AbhHRMbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 08:31:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629289871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DQ4O8ycMkSrrR17u6KlbZPwcNJ+ZHv0tIoID9WRfEQc=;
        b=aBM0OASN4FWs5kmHy5IMkpSgAoxMWWyyteLIK9fZKx4/gdVM4Rc/tiS5zJ7XEYCeW3MyYM
        MWwDajBDdUltL74PqhlU4ekTnnpvohqgIcMQ9Mehn0uzhNES304WoXcNU4E1DiZAIOj2fU
        A9zVnUTlL+/8NRTJ18zYLa464sOk0e0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-ob78YB8mNMaYxbWhfH75Bg-1; Wed, 18 Aug 2021 08:31:10 -0400
X-MC-Unique: ob78YB8mNMaYxbWhfH75Bg-1
Received: by mail-ej1-f70.google.com with SMTP id j10-20020a17090686cab02905b86933b59dso798912ejy.18
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 05:31:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DQ4O8ycMkSrrR17u6KlbZPwcNJ+ZHv0tIoID9WRfEQc=;
        b=K5qpzuaMpBmnt+NXOUDTyYAqxEAP9uOgqGJIIQUtHUX76xHunSWvUqWK8KBfHYBy2e
         Opyz2CibzOVfcT/SCA0uWCoyijL8u548DNJKBrDKW1GW7E5WC7iO1VGHOyukQpquddjA
         RzCsJ9/u1o6upyANW47Oyfr0/kMOfZXxHrC20XkFCXu9NlDqHh1WC3DqFxA9Mjkypkb4
         sBFxtkTYNjbtGQiyjTLlKdv6auAE+JqECE1VAEsslstYAz588fW/hrjeUGwjY/thvv37
         S6jw/K2pZ4tOMf4xUbKZS9E5qRIHkk55FC+wzzEVvmoVUn805jTyEKaH4K/AsDLMPzOL
         WUzQ==
X-Gm-Message-State: AOAM532q+IQvp81NkMm2hLx4+Kr7m5Bocn+B8VZYfuPFSfJJiS/qHSmG
        fHOziDet7yEiE4vifn7+qCRIRI3dYE9bTO0db9neL02+wcnHP9lUkefHpDt4Gpxb4aMsqwA7q6K
        oEaeeiv4nnBPPr8z7
X-Received: by 2002:a05:6402:22ab:: with SMTP id cx11mr9808609edb.240.1629289869064;
        Wed, 18 Aug 2021 05:31:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqsFem7znHCNOJTx5xHzFRptKqZokaG0VrQZSUKRLyYLSd163BMC9vjZM0Z88pwUrBo2L7cQ==
X-Received: by 2002:a05:6402:22ab:: with SMTP id cx11mr9808567edb.240.1629289868891;
        Wed, 18 Aug 2021 05:31:08 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w13sm2719164ede.24.2021.08.18.05.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 05:31:08 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A14CA180331; Wed, 18 Aug 2021 14:31:07 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v11 bpf-next 17/18] net: xdp: introduce
 bpf_xdp_adjust_data helper
In-Reply-To: <9696df8ef1cf6c931ae788f40a42b9278c87700b.1628854454.git.lorenzo@kernel.org>
References: <cover.1628854454.git.lorenzo@kernel.org>
 <9696df8ef1cf6c931ae788f40a42b9278c87700b.1628854454.git.lorenzo@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 Aug 2021 14:31:07 +0200
Message-ID: <87czqbq6ic.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

> For XDP frames split over multiple buffers, the xdp_md->data and
> xdp_md->data_end pointers will point to the start and end of the first
> fragment only. bpf_xdp_adjust_data can be used to access subsequent
> fragments by moving the data pointers. To use, an XDP program can call
> this helper with the byte offset of the packet payload that
> it wants to access; the helper will move xdp_md->data and xdp_md ->data_end
> so they point to the requested payload offset and to the end of the
> fragment containing this byte offset, and return the byte offset of the
> start of the fragment.
> To move back to the beginning of the packet, simply call the
> helper with an offset of '0'.
> Note also that the helpers that modify the packet boundaries
> (bpf_xdp_adjust_head(), bpf_xdp_adjust_tail() and
> bpf_xdp_adjust_meta()) will fail if the pointers have been
> moved; it is the responsibility of the BPF program to move them
> back before using these helpers.
>
> Suggested-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/xdp.h              |  8 +++++
>  include/uapi/linux/bpf.h       | 32 ++++++++++++++++++
>  net/bpf/test_run.c             |  8 +++++
>  net/core/filter.c              | 61 +++++++++++++++++++++++++++++++++-
>  tools/include/uapi/linux/bpf.h | 32 ++++++++++++++++++
>  5 files changed, 140 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index cdaecf8d4d61..ce4764c7cd40 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -82,6 +82,11 @@ struct xdp_buff {
>  	struct xdp_txq_info *txq;
>  	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
>  	u16 flags; /* supported values defined in xdp_flags */
> +	/* xdp multi-buff metadata used for frags iteration */
> +	struct {
> +		u16 headroom;	/* frame headroom: data - data_hard_start */
> +		u16 headlen;	/* first buffer length: data_end - data */
> +	} mb;
>  };
>  
>  static __always_inline bool xdp_buff_is_mb(struct xdp_buff *xdp)
> @@ -127,6 +132,9 @@ xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
>  	xdp->data = data;
>  	xdp->data_end = data + data_len;
>  	xdp->data_meta = meta_valid ? data : data + 1;
> +	/* mb metadata for frags iteration */
> +	xdp->mb.headroom = headroom;
> +	xdp->mb.headlen = data_len;
>  }
>  
>  /* Reserve memory area at end-of data area.
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index ddbf9ccc2f74..c20a8b7c5c7c 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4853,6 +4853,37 @@ union bpf_attr {
>   *		Get the total size of a given xdp buff (linear and paged area)
>   *	Return
>   *		The total size of a given xdp buffer.
> + *
> + * long bpf_xdp_adjust_data(struct xdp_buff *xdp_md, u32 offset)
> + *	Description
> + *		For XDP frames split over multiple buffers, the
> + *		*xdp_md*\ **->data** and*xdp_md *\ **->data_end** pointers
> + *		will point to the start and end of the first fragment only.
> + *		This helper can be used to access subsequent fragments by
> + *		moving the data pointers. To use, an XDP program can call
> + *		this helper with the byte offset of the packet payload that
> + *		it wants to access; the helper will move *xdp_md*\ **->data**
> + *		and *xdp_md *\ **->data_end** so they point to the requested
> + *		payload offset and to the end of the fragment containing this
> + *		byte offset, and return the byte offset of the start of the
> + *		fragment.

This comment is wrong now :)

-Toke

