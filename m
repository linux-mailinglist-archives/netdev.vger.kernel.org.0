Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2692CEA6D
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 10:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbgLDJCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 04:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgLDJCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 04:02:39 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0996C061A52;
        Fri,  4 Dec 2020 01:01:58 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id y10so1286121plr.10;
        Fri, 04 Dec 2020 01:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qJuEMpFeakpm8CLh9OTsyBj5JDMbjjrQXYjCXTp57Ts=;
        b=V8zGIoeRaecT0z8WXoS/TBaUMP88C+DOu5ESr7bKkfQEhzRVWSfK2b8B85E48On5pa
         fLOl/C321OUEutrCAJnhqrEAKeARejAc91B2Hw/Vd24ZS+qkgkhvvmM2myZWiY4xMjUY
         pqr+a5aGBzUD+ClMdT6LoDwPahXOYEBr8uQCxewxgbP+4A1S1IRvi0RQybwNoQRRMtke
         OiObrtnoZ1cU3A7sMhFqyO2XxMt6ITOekgaQUsrM8uE8fhQaK1BLW7GaaTknjDknlX3i
         +yBzH07SEYL6LR+bFhy4+fAWLCt6ldF6S7bwoMAbDMr/U/okzOKtFxoxNb2uS2yU54R/
         hkHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qJuEMpFeakpm8CLh9OTsyBj5JDMbjjrQXYjCXTp57Ts=;
        b=h8Ta2llakgJoUT6Wabr4zBxZgqo3kFRbrziFTks8r8SNw5fO0peLkUwtBfllxPfRK9
         HkCm/2ZgVu2fHKWj1DdG+HEgBx6/BBu5HpAKvz1gyfko6Ca9y4P8O1ksFDKiAAgXaRAF
         jSqSS/RUDeAu9EtD8uJXBtVu/+wnloBXEzdzBPnnVQg49SlGZyHxhDZiztni7NMM5BG8
         ROdNJ5g6voC7W04u8QsoTFf6ScxTlG8BGyEqYzPDFtxX9NRNAgl38vqcym51uK0adt0s
         dr8+bPsatozElHmOlAocuklH3aCqcScZfum5hsFldT9MUmCTq6cb1dbxQ8ZBaX6jgFFp
         F/Kg==
X-Gm-Message-State: AOAM533LHhlvha20hHImkQpoD1K6djVPjAT5XuJb5XTRecEF1iw3soWp
        t4IWqeFfeWBV9sXo5IuhHCGqZTW9e3l/8Z1QkLs=
X-Google-Smtp-Source: ABdhPJymOI5g3U7qVxiizeZ5s8Vuq6qmqImYaTJGpA2MTNfQYf28aMcDLxSUFzSz87Vaystx535lX9o40oX0jQbWC84=
X-Received: by 2002:a17:90a:8b8b:: with SMTP id z11mr3202614pjn.117.1607072518441;
 Fri, 04 Dec 2020 01:01:58 -0800 (PST)
MIME-Version: 1.0
References: <1607071819-34127-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1607071819-34127-1-git-send-email-zhangchangzhong@huawei.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 4 Dec 2020 10:01:47 +0100
Message-ID: <CAJ8uoz0LCkR+zHKSto9JyTqeybRXqF1SbH_B6cBHu9n5r-UXKA@mail.gmail.com>
Subject: Re: [PATCH net] xsk: Fix error return code in __xp_assign_dev()
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 4, 2020 at 9:49 AM Zhang Changzhong
<zhangchangzhong@huawei.com> wrote:
>
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
>
> Fixes: 921b68692abb ("xsk: Enable sharing of dma mappings")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  net/xdp/xsk_buff_pool.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index 9287edd..d5adeee 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -175,6 +175,7 @@ static int __xp_assign_dev(struct xsk_buff_pool *pool,
>
>         if (!pool->dma_pages) {
>                 WARN(1, "Driver did not DMA map zero-copy buffers");
> +               err = -EINVAL;

Good catch! My intention here by not setting err is that it should
fall back to copy mode, which it does. The problem is that the
force_zc flag is disregarded when err is not set (see exit code below)
and your patch fixes that. If force_zc is set, we should exit out with
an error, not fall back. Could you please write about this in your
cover letter and send a v2?

BTW, what is the "Hulk Robot" that is in your Reported-by tag?

Thank you: Magnus

err_unreg_xsk:
        xp_disable_drv_zc(pool);
err_unreg_pool:
        if (!force_zc)
                err = 0; /* fallback to copy mode */
        if (err)
                xsk_clear_pool_at_qid(netdev, queue_id);
        return err;

>                 goto err_unreg_xsk;
>         }
>         pool->umem->zc = true;
> --
> 2.9.5
>
