Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271AB2EB380
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730746AbhAETb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729891AbhAETb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 14:31:28 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C66C061793;
        Tue,  5 Jan 2021 11:30:48 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id j13so232036pjz.3;
        Tue, 05 Jan 2021 11:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F88oCXSqS5Vbl5G2XzWl1J2aBVDAgNwp3y6EJL4c05c=;
        b=DftTVuQ6grwuykSF84GnB11LZ2zF7PqajsCoVCL2p3FXEger7h87zDeAffIQzKYSll
         MBW6lw9uzIKnsmmFmAZjh/ygoFsq/17FXTU2RcB5o3zCe61jx8sEjyai68UVlzy/U/6x
         4Y2x/6obgGj/3Oz0uEcF4ukGQVbmV6PQsBGkcX+JaBjQFacAAeX8HqP5HbVRXsiRgmb5
         +5KDCwX8RR1UpQRvwdEL5wQ/MGMrF0+5r7AQFnrM1aGDT1wPLKFw1gXixURrF7y5iYp1
         Ba/FO+/UcEyrArkV4ptByZ+W/d33yRJvs4vj0rr280SYe2pQ7Ur87PYlPf7dp5e99aNp
         bmpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F88oCXSqS5Vbl5G2XzWl1J2aBVDAgNwp3y6EJL4c05c=;
        b=ATQqQQhRVG6bCEr9YQ3+CFkakZYX5+2Ga0tBYFnrcbZGhletDO0DnIpk6ATEl29XXm
         YQiERkQpfFZR1OFaDFxWWRUuBQA8f2HIbDgMb8sOkZpqRIxDuMHB5xSMc7wJA15kGPWT
         sYI0xXHGkMcEm/iDqhrYYYsgyDXBiX5EmrLH3ntt1y4cEYHXRR5OskOZEOrmUNk/XD5g
         ttCu8MVbEYhHnBAjwQD4EG0swbFndOF6tT2L4L9jkP2NR3h1v9ZzT4iCHMbxv0433sPR
         m1yp1UIV9Yn6e77dTo5/q61F5Q+RJTCM5OtGw9WC5buZ8gM84QlS4yhCviZEyK98kcpS
         DYsQ==
X-Gm-Message-State: AOAM531b6390/YKz95X1EZf2Ne1vTpwYixqIcaNSpfry+IwTcP7i4Z2T
        W6WdbzYo4TxP+OpwsyR44/Y=
X-Google-Smtp-Source: ABdhPJyQO3F8uHZPi+sc8C3Ab+VJ46CSdR/2+DxSZqyJNA7TyaNVzzsNeLF2gaMRl7AHrKHbE3kAsw==
X-Received: by 2002:a17:90a:9483:: with SMTP id s3mr682131pjo.61.1609875048228;
        Tue, 05 Jan 2021 11:30:48 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:5456])
        by smtp.gmail.com with ESMTPSA id p16sm11181pju.47.2021.01.05.11.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 11:30:47 -0800 (PST)
Date:   Tue, 5 Jan 2021 11:30:45 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yuri Benditovich <yuri.benditovich@daynix.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, yan@daynix.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [RFC PATCH 3/7] tun: allow use of BPF_PROG_TYPE_SCHED_CLS
 program type
Message-ID: <20210105193045.g3q6n3dsl6idthbe@ast-mbp>
References: <20210105122416.16492-1-yuri.benditovich@daynix.com>
 <20210105122416.16492-4-yuri.benditovich@daynix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105122416.16492-4-yuri.benditovich@daynix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 02:24:12PM +0200, Yuri Benditovich wrote:
> This program type can set skb hash value. It will be useful
> when the tun will support hash reporting feature if virtio-net.
> 
> Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
> ---
>  drivers/net/tun.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 7959b5c2d11f..455f7afc1f36 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -2981,6 +2981,8 @@ static int tun_set_ebpf(struct tun_struct *tun, struct tun_prog __rcu **prog_p,
>  		prog = NULL;
>  	} else {
>  		prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SOCKET_FILTER);
> +		if (IS_ERR(prog))
> +			prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SCHED_CLS);

Patches 1 and 2 are missing for me, so I couldn't review properly,
but this diff looks odd.
It allows sched_cls prog type to attach to tun.
That means everything that sched_cls progs can do will be done from tun hook?
sched_cls assumes l2 and can modify the packet.
I think crashes are inevitable.
