Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53ACB50E16
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfFXObz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:31:55 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38991 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbfFXObz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:31:55 -0400
Received: by mail-qt1-f195.google.com with SMTP id i34so14657822qta.6;
        Mon, 24 Jun 2019 07:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sVtypU4GWHEacgVvfmmVLLLgLvOwlxf2kDRa2VvrYBQ=;
        b=ZVruZtP96IoLEkNyypwJqhTSgJ6YnuOHFrX917RuTgSB57y9Q+pb1Uo2N/xpOxs7yf
         fCUbZtCzTwf6UwVYA+kqaa9lMHw6eBqNlVJpZsX9wGszIKtWjSGa6WujG3vnk6p4djmt
         dmnx9xuSAi8VLsEeqJnm7d96wLqCl6KNRtdDstJpau1rTrLq4LMDAifwfKXBDhrui3+K
         4ZLq+TVJmU/jxX/HTkZDOczUFbYrzAuATdCVdQg01Sq86fctikKBKMtAcN5JgkS8FZOv
         byTTY2WSbIl62DYlaeZIpS5JxvVRsmCAmJYU2LorEr0mjkWZUVeul1Mp1ifV838MNoe2
         yGgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sVtypU4GWHEacgVvfmmVLLLgLvOwlxf2kDRa2VvrYBQ=;
        b=Zkp532TDObgikhSmLNSwgso9hLwHfsgADgfBqg7CpotW6emsnPpp0f/zVVxSLTkivZ
         C/DfFTHGiT4PJODWmDFTqXcCFScWEYfWqeBd2Z7kUFyHygIg24TQhH6HOwftdVk/iKbc
         4IVNzB9tcqCafNXOAGH4mfn6gc+s4G8/IKGrUHAT473D8NL5Wkraj/kWzpoFCLqkQ9aD
         9DP6z6vnm0iDq8yI8umfRty8lZ5fmhO8gUsCArPFwEVnvqbJQOYkDifIjhyrnmNXHX+d
         udIfa0VPvG4LI0IArTLh8Se6cm7+iCahx0xIHCZ0JKBws+h8KskDkBIqXvRbn5FTKKic
         QCcw==
X-Gm-Message-State: APjAAAWIIqO8czp8IHa4IxlkbIafiScyuwwU8V188hcBY0fNZJOEHFLG
        m37Y2Q6cNskC9pqP3D18NBPpapqA2wmBnm8YX0Y=
X-Google-Smtp-Source: APXvYqwAW3w08f3oZ69dGFCTKo1OTjPVYf5ev9zdr256/Xqvra9e0ccYdfVo8LB42FI5PzP+fHj+Ry92VjocaRUuC5E=
X-Received: by 2002:ac8:4442:: with SMTP id m2mr50657396qtn.107.1561386713971;
 Mon, 24 Jun 2019 07:31:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190620090958.2135-1-kevin.laatz@intel.com> <20190620090958.2135-4-kevin.laatz@intel.com>
In-Reply-To: <20190620090958.2135-4-kevin.laatz@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 24 Jun 2019 16:31:42 +0200
Message-ID: <CAJ+HfNgkJJZhbUbK-DU70tNMRjT62WVO5_asCiX28zGQkHhmsg@mail.gmail.com>
Subject: Re: [PATCH 03/11] xdp: add offset param to zero_copy_allocator
To:     Kevin Laatz <kevin.laatz@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Bruce Richardson <bruce.richardson@intel.com>,
        ciara.loftus@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 at 19:25, Kevin Laatz <kevin.laatz@intel.com> wrote:
>
> This patch adds an offset parameter for zero_copy_allocator.
>
> This change is required for the unaligned chunk mode which will come late=
r
> in this patch set. The offset parameter is required for calculating the
> original handle in unaligned mode since we can't easily mask back to it
> like in the aligned case.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>


> ---
>  include/net/xdp.h |  3 ++-
>  net/core/xdp.c    | 11 ++++++-----
>  2 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 0f25b3675c5c..ea801fd2bf98 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -53,7 +53,8 @@ struct xdp_mem_info {
>  struct page_pool;
>
>  struct zero_copy_allocator {
> -       void (*free)(struct zero_copy_allocator *zca, unsigned long handl=
e);
> +       void (*free)(struct zero_copy_allocator *zca, unsigned long handl=
e,
> +                       off_t off);
>  };
>
>  struct xdp_rxq_info {
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 4b2b194f4f1f..a77a7162d213 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -322,7 +322,7 @@ EXPORT_SYMBOL_GPL(xdp_rxq_info_reg_mem_model);
>   * of xdp_frames/pages in those cases.
>   */
>  static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi=
_direct,
> -                        unsigned long handle)
> +                        unsigned long handle, off_t off)
>  {
>         struct xdp_mem_allocator *xa;
>         struct page *page;
> @@ -353,7 +353,7 @@ static void __xdp_return(void *data, struct xdp_mem_i=
nfo *mem, bool napi_direct,
>                 rcu_read_lock();
>                 /* mem->id is valid, checked in xdp_rxq_info_reg_mem_mode=
l() */
>                 xa =3D rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_=
params);
> -               xa->zc_alloc->free(xa->zc_alloc, handle);
> +               xa->zc_alloc->free(xa->zc_alloc, handle, off);
>                 rcu_read_unlock();
>         default:
>                 /* Not possible, checked in xdp_rxq_info_reg_mem_model() =
*/
> @@ -363,19 +363,20 @@ static void __xdp_return(void *data, struct xdp_mem=
_info *mem, bool napi_direct,
>
>  void xdp_return_frame(struct xdp_frame *xdpf)
>  {
> -       __xdp_return(xdpf->data, &xdpf->mem, false, 0);
> +       __xdp_return(xdpf->data, &xdpf->mem, false, 0, 0);
>  }
>  EXPORT_SYMBOL_GPL(xdp_return_frame);
>
>  void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
>  {
> -       __xdp_return(xdpf->data, &xdpf->mem, true, 0);
> +       __xdp_return(xdpf->data, &xdpf->mem, true, 0, 0);
>  }
>  EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
>
>  void xdp_return_buff(struct xdp_buff *xdp)
>  {
> -       __xdp_return(xdp->data, &xdp->rxq->mem, true, xdp->handle);
> +       __xdp_return(xdp->data, &xdp->rxq->mem, true, xdp->handle,
> +                       xdp->data - xdp->data_hard_start);
>  }
>  EXPORT_SYMBOL_GPL(xdp_return_buff);
>
> --
> 2.17.1
>
