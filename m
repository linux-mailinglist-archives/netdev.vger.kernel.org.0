Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767E340CC0F
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 19:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhIOR6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 13:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhIOR6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 13:58:45 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055E5C061574;
        Wed, 15 Sep 2021 10:57:25 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id c13-20020a17090a558d00b00198e6497a4fso5523045pji.4;
        Wed, 15 Sep 2021 10:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RhNO4Hh8YN7nveIqF7PvF38X2xfoOsb3tYUTkAJ52us=;
        b=DIvcBD68mh9E9wn8NWRbjHgOeHXC7inS8t1JU3pQcub7dGVrq74d9FF4NSIlebK6lM
         HbQ8o5YQws1z/rHSKPo5gejouh87o8HCSin/zZaBJNU/aUxgxR0aBlmvUdQsu/FGAnTw
         uha9TD3jS7ZJ0GWywq9LrmMoMQvchotFIgzUR8D+I8mX2OKwqyAD0gUfTTZSsnosHdlD
         aWN2Je5w6sYqhM5vXtWTKC1OZMwm9GOfOgba23ulVixjwPiDCdQRt6LmHn9N6yVinX1i
         XnrrGyPF/1gp2UZV/UmFjFYPMtkjVCa08cr6MZPPIHCROYnQzV2g7gSWcFHlKxUoMvrY
         R3lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RhNO4Hh8YN7nveIqF7PvF38X2xfoOsb3tYUTkAJ52us=;
        b=BL2k4pIxYsnkAjZSNMvepayJipGQhBESLT+3JVxHC12PoTuCdYJ/4bY/3fnvPse46r
         MuUWUIE4P84sEqI7zW3SBVU+ACUMgRLHstVpU24Ouynm630ni31K9a+w5Ae6XgBgzaom
         Kj6KFoo8s++pCpv3dz7I9Mc+ebhsNxMgeKYcrjCBTXp7qp+RvBI6a7Yu0nV6iCe/xrpB
         o662vbrhpBwonGAHEgTWNsier1XjcJa+L/PwgSyeXh78U6ly2FEO5BHmD8Z8o/ibfkhU
         rrvpQnTPT6rlYaMDuRfSgFcOzUk4KG2QOt3swjnPcUQCbn3AxdMwpXCZ0QosKGwBw42R
         LUEQ==
X-Gm-Message-State: AOAM532ttKYvXCFaupthjLRxAnfAF2m27alAcGfsvwblfRzdNmWhArDO
        zzNSK0v2+CEwD2CeaCLFq8M=
X-Google-Smtp-Source: ABdhPJzbtLHMjm7E5sN328ADkme9j/jCGbouquutnCOHpRAiifu0H6R52qXnT1PFWXNQx8XJE6hg7g==
X-Received: by 2002:a17:90a:5504:: with SMTP id b4mr1132530pji.70.1631728645237;
        Wed, 15 Sep 2021 10:57:25 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id d3sm612031pga.7.2021.09.15.10.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 10:57:24 -0700 (PDT)
Date:   Wed, 15 Sep 2021 23:27:22 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 06/10] bpf: Bump MAX_BPF_STACK size to 768
 bytes
Message-ID: <20210915175722.viwvzg4ilpumqxid@apollo.localdomain>
References: <20210915050943.679062-1-memxor@gmail.com>
 <20210915050943.679062-7-memxor@gmail.com>
 <20210915163353.ysltf6edghj75koq@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915163353.ysltf6edghj75koq@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 10:03:53PM IST, Alexei Starovoitov wrote:
> On Wed, Sep 15, 2021 at 10:39:39AM +0530, Kumar Kartikeya Dwivedi wrote:
> > Increase the maximum stack size accessible to BPF program to 768 bytes.
> > This is done so that gen_loader can use 94 additional fds for kfunc BTFs
> > that it passes in to fd_array from the remaining space available for the
> > loader_stack struct to expand.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  include/linux/filter.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > index 4a93c12543ee..b214189ece62 100644
> > --- a/include/linux/filter.h
> > +++ b/include/linux/filter.h
> > @@ -82,8 +82,8 @@ struct ctl_table_header;
> >   */
> >  #define BPF_SYM_ELF_TYPE	't'
> >
> > -/* BPF program can access up to 512 bytes of stack space. */
> > -#define MAX_BPF_STACK	512
> > +/* BPF program can access up to 768 bytes of stack space. */
> > +#define MAX_BPF_STACK	768
>
> Yikes.
> I guess you meant as RFC, right? You didn't really propose
> to increase prog stack size just for that, right?
>

Yes, and right, it's ugly :/.

> In the later patch:
> +/* MAX_BPF_STACK is 768 bytes, so (64 + 32 + 94 (MAX_KFUNC_DESCS) + 2) * 4 */
>  #define MAX_USED_MAPS 64
>  #define MAX_USED_PROGS 32
>
> @@ -31,6 +33,8 @@ struct loader_stack {
>         __u32 btf_fd;
>         __u32 map_fd[MAX_USED_MAPS];
>         __u32 prog_fd[MAX_USED_PROGS];
> +       /* Update insn->off store when reordering kfunc_btf_fd */
> +       __u32 kfunc_btf_fd[MAX_KFUNC_DESCS];
>         __u32 inner_map_fd;
> };
>
> There are few other ways to do that.
> For example:
> A: rename map_fd[] into fds[] and store both map and btf FDs in there.
> B: move map and btf FDs into data instead of stack.

Both are great suggestions, I thought about A but not B, but it will be better
(even though it requires more changes, we can do full 256 BTF fds using B).
Thanks!

--
Kartikeya
