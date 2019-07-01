Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8633D5BA45
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 13:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbfGALCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 07:02:12 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35665 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbfGALCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 07:02:11 -0400
Received: by mail-ot1-f68.google.com with SMTP id j19so13058049otq.2
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 04:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5ziw3NZDe/SVYJHPvGSUD2a1mfhcSTJZPcCCzgvap1w=;
        b=RVzf55bT8FFvAeqku3WH60JOAFbDwUDdMnd3NT+rIHelQrm6IY4ts8s3gx53ZkVTog
         zLahawhOBSxqmiNaTLgG9JnaH6SWl65RXvjw9OTfgqlTJZMTtotQs6zEfFuJMt/kebtg
         GgdVUdYPrXsR9uf4ZGxOYM3zv7P0wubGbHDTxgspQcEn8wQoXt89IUIjeSvDxzBgAApL
         OZ8B11MW4JV5YNq1EHrqJPdTSQ7ZVOxdOFDw8n13fxQBx33bVpUhfSmJh4nVx8K9jiY1
         TC2/4F8tFQL5T2Q7moue/9XbvXysA/NOtoXPeJda2cD3amxHPijF/bAP9j54+w6exOT3
         eDCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5ziw3NZDe/SVYJHPvGSUD2a1mfhcSTJZPcCCzgvap1w=;
        b=L1t5VOb0yo5vg1Kvu8g7A46+vSkjssgsxIzAlXDmHlQapDu2S44Ryz7Rt/xIL86/Dh
         z6C438s1oB4b5of8d3RoYbdU/We6yy+bM3Gc4kQExkLbMFIxOiUUPgAYbaB8wGdfawzK
         BATZiAe5++iD4V1csh1O7AkUlo0QWsSmEQTe6wXCf5vglGufbHHkEynEmQ4kvkm+e99K
         K8elsGDOL+q4ZqtPf81WUdmFFkcvp+jOYBGBsIO5X54TjQimiFQeyn62KL6rDTOK9jIB
         ZpfFsEzK4fs1/H7Fx5Zkqng8EIoZ4l5CeL4O5EYGrvTa2tvdWoYgCM7/r1dPhPURq5Mg
         yR9w==
X-Gm-Message-State: APjAAAW/iNfiASoPKXlEg+vAmpe51IsMLpXiJbHMSjGKNUMaadv1bnUo
        tFX4w0YiNzc70lBglzhd529rUoWmSWHVINbTwGt1bKzFZak=
X-Google-Smtp-Source: APXvYqxg4kWiJcklvFg6RdRI4Blb8jgjULbVvtyFTyVaMe6m5+DvEO2k9cGt5kCWXzDXbRq5GFLmCx1atZMCdqWdVK0=
X-Received: by 2002:a9d:77c2:: with SMTP id w2mr1063706otl.192.1561978931173;
 Mon, 01 Jul 2019 04:02:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190628221555.3009654-1-jonathan.lemon@gmail.com> <20190628221555.3009654-2-jonathan.lemon@gmail.com>
In-Reply-To: <20190628221555.3009654-2-jonathan.lemon@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 1 Jul 2019 13:02:00 +0200
Message-ID: <CAJ8uoz2BeqbMrfJqg+du+zzMdQAp2kbLpkGqzLoQL1_6EOUx5w@mail.gmail.com>
Subject: Re: [PATCH 1/3 bpf-next] net: add convert_to_xdp_frame_keep_zc function
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        jeffrey.t.kirsher@intel.com, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 29, 2019 at 12:19 AM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> Add a function which converts a ZC xdp_buff to a an xdp_frame, while

nit: "a an" -> "an"

> keeping the zc backing storage.  This will be used to support TX of
> received AF_XDP frames.
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  include/net/xdp.h | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 40c6d3398458..abe5f47ff0a5 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -82,6 +82,7 @@ struct xdp_frame {
>          */
>         struct xdp_mem_info mem;
>         struct net_device *dev_rx; /* used by cpumap */
> +       unsigned long handle;
>  };
>
>  /* Clear kernel pointers in xdp_frame */
> @@ -95,15 +96,12 @@ struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
>
>  /* Convert xdp_buff to xdp_frame */
>  static inline
> -struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
> +struct xdp_frame *__convert_to_xdp_frame(struct xdp_buff *xdp)
>  {
>         struct xdp_frame *xdp_frame;
>         int metasize;
>         int headroom;
>
> -       if (xdp->rxq->mem.type == MEM_TYPE_ZERO_COPY)
> -               return xdp_convert_zc_to_xdp_frame(xdp);
> -
>         /* Assure headroom is available for storing info */
>         headroom = xdp->data - xdp->data_hard_start;
>         metasize = xdp->data - xdp->data_meta;
> @@ -125,6 +123,20 @@ struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
>         return xdp_frame;
>  }
>
> +static inline
> +struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
> +{
> +       if (xdp->rxq->mem.type == MEM_TYPE_ZERO_COPY)
> +               return xdp_convert_zc_to_xdp_frame(xdp);
> +       return __convert_to_xdp_frame(xdp);
> +}
> +
> +static inline
> +struct xdp_frame *convert_to_xdp_frame_keep_zc(struct xdp_buff *xdp)
> +{
> +       return __convert_to_xdp_frame(xdp);
> +}
> +
>  void xdp_return_frame(struct xdp_frame *xdpf);
>  void xdp_return_frame_rx_napi(struct xdp_frame *xdpf);
>  void xdp_return_buff(struct xdp_buff *xdp);
> --
> 2.17.1
>
