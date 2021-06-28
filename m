Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC0E3B6964
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 21:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237196AbhF1UBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 16:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237180AbhF1UBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 16:01:12 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C22C061574;
        Mon, 28 Jun 2021 12:58:46 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id s15so27673012edt.13;
        Mon, 28 Jun 2021 12:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ci4Q5smafeUfWmX+diClg5kPOpeaGc5Nu6p9Y9QFirM=;
        b=YrKIKLBlHOg94pij0c3zzE6MZHNQ/aZCgAOIiYYyKP5cnPvphb2izFrkfYTULSXPA8
         Jq8cK9fTicyUqHKtgXyp2/WXCgRF/LX4q+CFZS2rg0+uCAQx+9m61cGlr8ZkmGLSbu1h
         Od0SudAA9PYpxzQQoBTc1L/I7hcpVNtl4QbjXs0P02FlXtrdPTqKTDu1SYq0sUCwmNAh
         mcb8aX9KdgaLpP+pVG+YNdJwT0Q+3qGDaLXmozapfVXdKKFZCaQ1k0/alWSxuHkYn0xk
         yfAagEHhs1IFzScxlltybBbClOJL4l5Ecfrb59OSceF6saVt8lyDrf6NiedogVuKnbyD
         F4bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ci4Q5smafeUfWmX+diClg5kPOpeaGc5Nu6p9Y9QFirM=;
        b=KVYVA+XRNXGgiWqfNjUiV8+XD5sEbeEuuMpnfnW8zW3x/uQayzhCW8sO1r+tdBVxYl
         IHwQb+FiMgRcbatpVzrVnHNRKalSURHsphfEgVcwugSmOeVULJ1aF2YxBwe4+QBEDpSY
         IMRMtBIY225tosPuSwPbKqdzN+AXPwvuSfczlQ97HPBH9jHhJEoeKnp6f5EXlrQSkcHt
         h90nxviIx1cUEHtIIVA4HgOr47mi7ZnO7IZczOK72czkMQ59N8/PomgGtE6e81qwRsCG
         9Byb26q6qNSjWkECk5a64l42ruCv63TGbksLY7V6VeqhphAj0fzfr/GINqZQVFs4F4rV
         pBkw==
X-Gm-Message-State: AOAM530G2QuS10LDcLzYH8pQMYHbhnygRmNJH2EWUECvSpBB/uujcDTZ
        axSNHCTzOX6qS9NvktBkS/EYxWGZ0BHTtKB5y74=
X-Google-Smtp-Source: ABdhPJwbzD0ghwtgnYjwoP9dPWVhj3sBdwvwjYUOt5HkruBSOENDNS1AwJM3SUyGc2hwb/XjJsvfgqNnystITvc+PfY=
X-Received: by 2002:a05:6402:40c4:: with SMTP id z4mr35516888edb.364.1624910324585;
 Mon, 28 Jun 2021 12:58:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1623674025.git.lorenzo@kernel.org> <8ad0d38259a678fb42245368f974f1a5cf47d68d.1623674025.git.lorenzo@kernel.org>
In-Reply-To: <8ad0d38259a678fb42245368f974f1a5cf47d68d.1623674025.git.lorenzo@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 28 Jun 2021 12:58:33 -0700
Message-ID: <CAKgT0UcwYHXosz-XuQximak63=ugb9thEc=dkUUZzDpoPCH+Qg@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 01/14] net: skbuff: add data_len field to skb_shared_info
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        lorenzo.bianconi@redhat.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 5:50 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> data_len field will be used for paged frame len for xdp_buff/xdp_frame.
> This is a preliminary patch to properly support xdp-multibuff
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/linux/skbuff.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index dbf820a50a39..332ec56c200d 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -522,7 +522,10 @@ struct skb_shared_info {
>         struct sk_buff  *frag_list;
>         struct skb_shared_hwtstamps hwtstamps;
>         unsigned int    gso_type;
> -       u32             tskey;
> +       union {
> +               u32     tskey;
> +               u32     data_len;
> +       };
>

Rather than use the tskey field why not repurpose the gso_size field?
I would think in the XDP paths that the gso fields would be unused
since LRO and HW_GRO would be incompatible with XDP anyway.
