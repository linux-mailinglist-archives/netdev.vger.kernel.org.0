Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E9539483E
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 23:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhE1VUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 17:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhE1VUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 17:20:21 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC76C06174A
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 14:18:46 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id h20so7363968ejg.1
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 14:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QrEKcucLG704d1McWx+SAa29jD3ltqkT7vXWjPkO/XM=;
        b=SDeRpSqndcg0t8e7VqPoTKwPRQ1x5drB2RanooTZmmGVbM11lnJIVDPm+XIfzlrWCS
         zF/vJ0cPsL/SifhYSAPRIVPDEAXzsL/E0EI8Qd9ZQ6+DggUuKNNBRPSaP1B6ySWJ8K49
         NnCc7R/aNeKJ+5A/HYipyguyK8ZrzHdprJM8EKFUSAjxJe1WpBzoj1fLuLWWJHTXa7Ui
         7lMnaff7NUWp/G3LlQ0fc7s2JtauVT6xb3mQAPPNqyF5CApgC3O8itVqLqv3453+mnPu
         fR4VuVGAI7WiuDIdbPqF9Xqd3Dr6crN1nDItGgZ2BrOMEIN6hUrriAwsgiIwUjHHaQQE
         wJ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QrEKcucLG704d1McWx+SAa29jD3ltqkT7vXWjPkO/XM=;
        b=MhSmk+IZEqXWBx4OwmoDGMD8qE1Tm34E6VcBs+H67Al8m6sJYE6OOahrBrOzd/Rz/T
         xOBp+zTgdSAbBIrtlxEVGdVjFKO5ZMUqDJ/5VC/ptdqM1+GbQtFlgushnsae8yzjfGMK
         5fH0Q/e76rImqP9NLZn117DC69jrza/1pnobBu0bY6bSd11PfXJi7X9noVCo4S6dDFgV
         7d4eF7+qXeOYR1EYZevJmcNORzjAAHsLmws0a7tJFCoCDsVToXJdHDbANHTkzL2REL1q
         3dx9bM1KvKa/i1XUFVLVD3q4pUUAvTRB0sURpMq4HYBkGhJOZM9dSWlzsqwcF1Yna59F
         3oJQ==
X-Gm-Message-State: AOAM531WfjmAD85imeLNbs3qRL6ry/TJFvdWk4MFRC4VEhkTjFRbDtuD
        efaldZQfWQ4SgOAy2YQXmm49ClvzxzWIit609/dWsA==
X-Google-Smtp-Source: ABdhPJyo64znoTV+xWd/LTnI9+odl4K24TGpHD5leM+piBFuiTuJBPXE1qYT2qfVlZavg45fu5gk4hg2MDrhQQLTA/M=
X-Received: by 2002:a17:906:7696:: with SMTP id o22mr10560088ejm.298.1622236724822;
 Fri, 28 May 2021 14:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1622222367.git.lorenzo@kernel.org> <b5b2f560006cf5f56d67d61d5837569a0949d0aa.1622222367.git.lorenzo@kernel.org>
In-Reply-To: <b5b2f560006cf5f56d67d61d5837569a0949d0aa.1622222367.git.lorenzo@kernel.org>
From:   Tom Herbert <tom@herbertland.com>
Date:   Fri, 28 May 2021 14:18:33 -0700
Message-ID: <CALx6S34cmsFX6QwUq0sRpHok1j6ecBBJ7WC2BwjEmxok+CHjqg@mail.gmail.com>
Subject: Re: [RFC bpf-next 1/4] net: xdp: introduce flags field in xdp_buff
 and xdp_frame
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        David Ahern <dsahern@gmail.com>, magnus.karlsson@intel.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>, bjorn@kernel.org,
        =?UTF-8?Q?Maciej_Fija=C5=82kowski_=28Intel=29?= 
        <maciej.fijalkowski@intel.com>,
        john fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 10:44 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Introduce flag field in xdp_buff and xdp_frame data structure in order
> to report xdp_buffer metadata. For the moment just hw checksum hints
> are defined but flags field will be reused for xdp multi-buffer
> For the moment just CHECKSUM_UNNECESSARY is supported.
> CHECKSUM_COMPLETE will need to set csum value in metada space.
>
Lorenzo,

This isn't sufficient for the checksum-unnecessary interface, we'd
also need ability to set csum_level for cases the device validated
more than one checksum.

IMO, we shouldn't support CHECKSUM_UNNECESSARY for new uses like this.
For years now, the Linux community has been pleading with vendors to
provide CHECKSUM_COMPLETE which is far more useful and robust than
CHECSUM_UNNECESSARY, and yet some still haven't got with the program
even though we see more and more instances where CHECKSUM_UNNECESSARY
doesn't even work at all (e.g. cases with SRv6, new encaps device
doesn't understand). I believe it's time to take a stand! :-)

Tom

> Signed-off-by: David Ahern <dsahern@kernel.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/xdp.h | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 5533f0ab2afc..e81ac505752b 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -66,6 +66,13 @@ struct xdp_txq_info {
>         struct net_device *dev;
>  };
>
> +/* xdp metadata bitmask */
> +#define XDP_CSUM_MASK          GENMASK(1, 0)
> +enum xdp_flags {
> +       XDP_CSUM_UNNECESSARY    = BIT(0),
> +       XDP_CSUM_COMPLETE       = BIT(1),
> +};
> +
>  struct xdp_buff {
>         void *data;
>         void *data_end;
> @@ -74,6 +81,7 @@ struct xdp_buff {
>         struct xdp_rxq_info *rxq;
>         struct xdp_txq_info *txq;
>         u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
> +       u16 flags; /* xdp_flags */
>  };
>
>  static __always_inline void
> @@ -81,6 +89,7 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
>  {
>         xdp->frame_sz = frame_sz;
>         xdp->rxq = rxq;
> +       xdp->flags = 0;
>  }
>
>  static __always_inline void
> @@ -95,6 +104,18 @@ xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
>         xdp->data_meta = meta_valid ? data : data + 1;
>  }
>
> +static __always_inline void
> +xdp_buff_get_csum(struct xdp_buff *xdp, struct sk_buff *skb)
> +{
> +       switch (xdp->flags & XDP_CSUM_MASK) {
> +       case XDP_CSUM_UNNECESSARY:
> +               skb->ip_summed = CHECKSUM_UNNECESSARY;
> +               break;
> +       default:
> +               break;
> +       }
> +}
> +
>  /* Reserve memory area at end-of data area.
>   *
>   * This macro reserves tailroom in the XDP buffer by limiting the
> @@ -122,8 +143,21 @@ struct xdp_frame {
>          */
>         struct xdp_mem_info mem;
>         struct net_device *dev_rx; /* used by cpumap */
> +       u16 flags; /* xdp_flags */
>  };
>
> +static __always_inline void
> +xdp_frame_get_csum(struct xdp_frame *xdpf, struct sk_buff *skb)
> +{
> +       switch (xdpf->flags & XDP_CSUM_MASK) {
> +       case XDP_CSUM_UNNECESSARY:
> +               skb->ip_summed = CHECKSUM_UNNECESSARY;
> +               break;
> +       default:
> +               break;
> +       }
> +}
> +
>  #define XDP_BULK_QUEUE_SIZE    16
>  struct xdp_frame_bulk {
>         int count;
> @@ -180,6 +214,7 @@ void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
>         xdp->data_end = frame->data + frame->len;
>         xdp->data_meta = frame->data - frame->metasize;
>         xdp->frame_sz = frame->frame_sz;
> +       xdp->flags = frame->flags;
>  }
>
>  static inline
> @@ -206,6 +241,7 @@ int xdp_update_frame_from_buff(struct xdp_buff *xdp,
>         xdp_frame->headroom = headroom - sizeof(*xdp_frame);
>         xdp_frame->metasize = metasize;
>         xdp_frame->frame_sz = xdp->frame_sz;
> +       xdp_frame->flags = xdp->flags;
>
>         return 0;
>  }
> --
> 2.31.1
>
