Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BB62275C4
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgGUCkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGUCkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:40:20 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA0CC061794;
        Mon, 20 Jul 2020 19:40:20 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id o18so20085596eje.7;
        Mon, 20 Jul 2020 19:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uGJfiXXxVHM7zniHW3sl0xVltZ7h7OdT0FRQ5H6GgQM=;
        b=OeoCW/0tbvMmfJG3/GXVxS0sf0NU1F3vv5ek0RwSeUB4oL3xBRF4212opG/Qca2oMt
         w/LznXXPQ/9latRxVyAN7HoUeXaNxvpuCBnCtE8R4VgfJiFrlJWGUZ3AudCWWBSFASY5
         rHitPZwk5CzwZGC9yY+cINRMFHfhNoff5Hs0bqMLp86BM3TNE6gCd0fujLU9Jp1gGqkn
         fbgcZ3ejttQ6DUlGWTOX05MbhnYkq6NEeVjuv6BJvSSMm0lLza1F8vnXHY24yVrWhuUw
         mE4fVqq6wL70udwjlBJkWv9YZBUUfIIT74p06ZRe0yu4iR7nwWtzJQYm2S7oIsa47DMh
         Anhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uGJfiXXxVHM7zniHW3sl0xVltZ7h7OdT0FRQ5H6GgQM=;
        b=GHjMlunOBJHywoda8QvnUbXzKcpxcToPi5q96IB0nS8SV/0w9n9vzOTdLuLBkJfa66
         Wx+so/SDt0UFrPX51D8RnHdX40HSdnl6kE/k6vZO4s9ue44FnSEti2xAj4QsHxi1ZuS8
         n8bgQ5tsoUDpMlL93DF5xblWvbQ3H5eghxR0Mtzi2I4CAj6rrdbmLsCHl38hninxxXoX
         76ZXWvblM4Uf1Fxl+4ZiPTOjHMLC4IbkIchoKtoGeeZKJjpz15SvX2Oa5LjhyljEa0fI
         5MhVKEix35nP+fLDc3sQBkgL5fxi5KKKVrhwepSVfiwSc8W9UIKYcgBLIIbj4vBZqYxE
         R3cw==
X-Gm-Message-State: AOAM530XQWjOFj5xGhVnLVxnH6MpDNXehwO5Bs0Rwte4hqLm1r0Q6JKr
        qlYP/tURkjHiGQun4RSN6ds=
X-Google-Smtp-Source: ABdhPJxwHHfj4AzpvPUUwMsSPbeGFb02Lr8Q1E98GpxaDKbKNy5p2S/jP2546lXFLYroLU3vdKdQBA==
X-Received: by 2002:a17:906:c41:: with SMTP id t1mr23432470ejf.18.1595299219166;
        Mon, 20 Jul 2020 19:40:19 -0700 (PDT)
Received: from ltop.local ([2a02:a03f:a7fb:e200:d978:aa6c:4528:f5b1])
        by smtp.gmail.com with ESMTPSA id y22sm15676844ejj.67.2020.07.20.19.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 19:40:18 -0700 (PDT)
Date:   Tue, 21 Jul 2020 04:40:16 +0200
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: Re: [PATCH 02/24] bpfilter: fix up a sparse annotation
Message-ID: <20200721024016.2talwdt5hjqvirr6@ltop.local>
References: <20200720124737.118617-1-hch@lst.de>
 <20200720124737.118617-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720124737.118617-3-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 02:47:15PM +0200, Christoph Hellwig wrote:
> The __user doesn't make sense when casting to an integer type.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  net/bpfilter/bpfilter_kern.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bpfilter/bpfilter_kern.c b/net/bpfilter/bpfilter_kern.c
> index 977e9dad72ca4f..713b4b3d02005d 100644
> --- a/net/bpfilter/bpfilter_kern.c
> +++ b/net/bpfilter/bpfilter_kern.c
> @@ -49,7 +49,7 @@ static int __bpfilter_process_sockopt(struct sock *sk, int optname,
>  	req.is_set = is_set;
>  	req.pid = current->pid;
>  	req.cmd = optname;
> -	req.addr = (long __force __user)optval;
> +	req.addr = (__force long)optval;

For casts to integers, even '__force' is not needed (since integers
can't be dereferenced, the concept of address-space is meaningless
for them, so it's never useful to warn when it's dropped and
'__force' is thus not needed).

-- Luc
