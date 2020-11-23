Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34DF2C0169
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 09:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgKWI2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 03:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgKWI2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 03:28:41 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B0FC0613CF;
        Mon, 23 Nov 2020 00:28:41 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id t21so13580647pgl.3;
        Mon, 23 Nov 2020 00:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Njy3zuk5oeU7r7tRmmONRylt9qADdTD1wjwMoTTxmiE=;
        b=kM2GGbPsWHhZSVIhzWDU4uTSC52duarIb+8MPDoHV+6SMVFCM5s8DGc/UDdE64xqOy
         qNLfq9mtTh8ovniLVJsGyxGpbuZ9qoZsc+tL1Wi2q3TWb6tNB9PDGaCJ+PgdQm0+eQIN
         dhw87EsouEh0PJ96Sz2q7boiL3+0VsHb8k6tKfVl8jsERWrKrYn9B7FmS8MGmRhIqbXW
         IgL00J11Ku7ET6lcQH6tkZjx1HCnuWV3EMIIXPpDTUIcBalsc7aLhHfH7dog8QbSjBr6
         Zu5nBBM+fEYzhlGiBfsGiEttPc/le+ThIGYs8kS7hqYugW9bbH5mjGXiU0SGAq0e+/OG
         EVHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Njy3zuk5oeU7r7tRmmONRylt9qADdTD1wjwMoTTxmiE=;
        b=ZSqfYv8lRTEXTmvb1RE83d36e0gLS9XCv7dTxgB0polSd2X713w/syhONTsgRXOKwO
         WBhdzoFMbTSLI9+hZVwiCV1LVNcxq7oSJrglR8KtPWUmZNOSNZmvSxZk7uwlcRZ+BUIc
         l8gotmNws5aJYwQ6/akHsp9ptEOUe3Y0pkFuUijVmBR36zLM4Cxi8EtPd0iqIfIzM1gt
         iZFwkK3jofyEiwjqHzu5i/vdfIsUKo1Uum4Mw3h268MIcbsX2BiltMcIFW5ynmjwYSf2
         fS744kW0pTs6bufHfL4JQhrmkHKfqnlGZxgAkLJbXtsu11MvJmeJJhlwJn+oZRkVTdUM
         6qOA==
X-Gm-Message-State: AOAM530I18O/aLz2R1vgbUY27phdGget5sf/UkvVCEJBm8k/7ltNRknZ
        9u4uigygED6mWv4CFnZkZeIhRcFTNjNgqRejT0SrBIM/6V9lyqXJ
X-Google-Smtp-Source: ABdhPJzjU+W1EaE18AyJtjqCcLROkhR+9QKrwgMbw15NyFIuvcNOQex6joleRnPu8we5tx+GeCyuonuMNwpXzubzBec=
X-Received: by 2002:a17:90a:4687:: with SMTP id z7mr22933345pjf.168.1606120121064;
 Mon, 23 Nov 2020 00:28:41 -0800 (PST)
MIME-Version: 1.0
References: <20201120151443.105903-1-marekx.majtyka@intel.com>
In-Reply-To: <20201120151443.105903-1-marekx.majtyka@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 23 Nov 2020 09:28:29 +0100
Message-ID: <CAJ8uoz2p4tZVGDjSn5WW3hWne0+4HWvAg8Z0JvkVA5z+hygVNw@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: fix incorrect netdev reference count
To:     Marek Majtyka <alardam@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Marek Majtyka <marekx.majtyka@intel.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 4:17 PM <alardam@gmail.com> wrote:
>
> From: Marek Majtyka <marekx.majtyka@intel.com>
>
> Fix incorrect netdev reference count in xsk_bind operation. Incorrect
> reference count of the device appears when a user calls bind with the
> XDP_ZEROCOPY flag on an interface which does not support zero-copy.
> In such a case, an error is returned but the reference count is not
> decreased. This change fixes the fault, by decreasing the reference count
> in case of such an error.
>
> The problem being corrected appeared in '162c820ed896' for the first time,
> and the code was moved to new file location over the time with commit
> 'c2d3d6a47462'. This specific patch applies to all version starting
> from 'c2d3d6a47462'. The same solution should be applied but on different
> file (net/xdp/xdp_umem.c) and function (xdp_umem_assign_dev) for versions
> from '162c820ed896' to 'c2d3d6a47462' excluded.
>
> Fixes: 162c820ed896 ("xdp: hold device for umem regardless of zero- ...")
> Signed-off-by: Marek Majtyka <marekx.majtyka@intel.com>
> ---
>  net/xdp/xsk_buff_pool.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index 8a3bf4e1318e..46d09bfb1923 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -185,8 +185,10 @@ static int __xp_assign_dev(struct xsk_buff_pool *pool,
>  err_unreg_pool:
>         if (!force_zc)
>                 err = 0; /* fallback to copy mode */
> -       if (err)
> +       if (err) {
>                 xsk_clear_pool_at_qid(netdev, queue_id);
> +               dev_put(netdev);
> +       }
>         return err;
>  }

Thank you Marek for spotting and fixing this!

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> --
> 2.27.0
>
