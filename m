Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28CD26E2DA
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgIQRsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgIQRrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:47:51 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33FAC06174A;
        Thu, 17 Sep 2020 10:47:42 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id md22so3135864pjb.0;
        Thu, 17 Sep 2020 10:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zvTQuLhevp37w7yfIsEU+r4hqA1hR5pcgpJm3L1z8/w=;
        b=gltpvHHTrIv0uo4znq1dMDMf0xQtZhkZR1MnxRB6KcxfOj9f07jQ+TqX4tqkpeqbmn
         Qg1wm/K6xK72NXq0soulNVL4HRu5oqvShEyqxnhfNQbWLb+PpjJo7NvhmY+29sC8UqOO
         T1fbgNLQHZAeldqHIS1guLeuNqjVYtE51Qb70J9/YFlyaKuTFbpKR+btMETRFufRYaZS
         1EbvxLfSEiu/2lW12RPUDMgrBataq7CAS9d6UvCU1HydReEGAd7j7ypeteuTptCNmMaK
         hZ1w3jXHSzISRWfjm/ho/yCG+MzqbHtrss0hRNBVGYW+1Syn8K0A1Gntzolzjpxo2m8o
         Mkiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zvTQuLhevp37w7yfIsEU+r4hqA1hR5pcgpJm3L1z8/w=;
        b=OxVZ9o6esZdYtwoSvAHFHmI5ic6JL897To7E+ayumQqiWHYtYUu3KK/f976V6VXR8L
         l0AVXyDpcgHcLtuk1BHwjKlPBzt93AUxxKtuvnGotReoJlM0lXCCpZl7tUtQydO2Ip2j
         iU2WKurKEqmqAwrdYA9xvqw31NNgNAFt6/n1tpdde2ejBKrCVsV+UNEBCEt2zMu6PU0X
         qPXh7UxeExlhFn1JtYcGMV1lDDRoHcyeN6feW8noXBdvmACgc5aekCtSAUquZil9E+an
         10nXrdhvmPuOjb/OU8cMMoXB0luJffrc8ixOyhuNosz/ApnRv/Pi3sugBdB/AhKtGfjG
         fiuQ==
X-Gm-Message-State: AOAM532mD9wsR+VzuLZ0iQcQYLzNek55RXccxeS7Qs/qsnnHhQeuzZjP
        kANWPxn/zYFEYwq09WiHD88=
X-Google-Smtp-Source: ABdhPJw0/VxVRqP9HWaijLykqzPAJ47yc4fpsrx/cpHeUcalf8rAVaGrTkR9KjfuLPXaOc2Ahsd/vg==
X-Received: by 2002:a17:902:d88c:b029:d1:e5ec:5ef5 with SMTP id b12-20020a170902d88cb02900d1e5ec5ef5mr11981837plz.43.1600364861985;
        Thu, 17 Sep 2020 10:47:41 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:ee50])
        by smtp.gmail.com with ESMTPSA id a74sm267621pfa.16.2020.09.17.10.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 10:47:41 -0700 (PDT)
Date:   Thu, 17 Sep 2020 10:47:39 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf] bpf: Use hlist_add_head_rcu when linking to
 sk_storage
Message-ID: <20200917174739.wbwiayb66aemydc5@ast-mbp.dhcp.thefacebook.com>
References: <20200916200925.1803161-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916200925.1803161-1-kafai@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 01:09:25PM -0700, Martin KaFai Lau wrote:
> The sk_storage->list will be traversed by rcu reader in parallel.
> Thus, hlist_add_head_rcu() is needed in __selem_link_sk().  This
> patch fixes it.
> 
> This part of the code has recently been refactored in bpf-next.
> A separate fix will be provided for the bpf-next tree.
> 
> Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  net/core/bpf_sk_storage.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> index b988f48153a4..d4d2a56e9d4a 100644
> --- a/net/core/bpf_sk_storage.c
> +++ b/net/core/bpf_sk_storage.c
> @@ -219,7 +219,7 @@ static void __selem_link_sk(struct bpf_sk_storage *sk_storage,
>  			    struct bpf_sk_storage_elem *selem)
>  {
>  	RCU_INIT_POINTER(selem->sk_storage, sk_storage);
> -	hlist_add_head(&selem->snode, &sk_storage->list);
> +	hlist_add_head_rcu(&selem->snode, &sk_storage->list);
>  }

Applying the same, yet very different from git point of view, patch to
bpf and bpf-next trees will create a ton of confusion for everyone.
I prefer to take this fix (in bpf-next form) into bpf-next only and apply
this fix (in bpf form) to 5.9 and stable after the merge window.
The code has been around since April 2019 and it wasn't hit in prod,
so I don't think there is urgency.
Agree?
