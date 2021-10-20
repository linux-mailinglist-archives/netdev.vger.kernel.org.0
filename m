Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA904353AD
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 21:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhJTTTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 15:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbhJTTTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 15:19:19 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87787C06161C;
        Wed, 20 Oct 2021 12:17:04 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id m14so3775496pfc.9;
        Wed, 20 Oct 2021 12:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HcIYWiFCVQnue2KbFMMttiWPrmdLbrKcP2fuUFsedaQ=;
        b=ckED8qmUsT2470Vm4BYrbdxap2AjOZUWs2nc9DhnpQOx8CLgzs6G3/X6Qi/UfO4iDm
         pNTvE4RPIiQWY7HwP2Q5saFr55uI5IakFmNLCfgwvo6zsasmgXZym+hGM+s/EO0jG0Ae
         yaTuiPLzR11x3mFGQBO30YU3W35OswLvOiKt4hTeEqE0Q5ZR+irzWB5eJk7J6cHkiRMo
         UjHsL2VF1Ql/HSaBT5pw5hkHRrLG+2Lu1IUO3iYuFSWAaZrcL4XKQYAPgaVFxyuFDk+L
         drzvasozKMX8TXUOkHMQO8zyJEzV3PxdAHAEp6jkbV36hNJhj/FhNKKauyFA8VyysYWw
         K10A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HcIYWiFCVQnue2KbFMMttiWPrmdLbrKcP2fuUFsedaQ=;
        b=k4yGaZtoChziREi8mVoKgPxbLD5K+CO3yaMpjqCR/Zind/TgFGYnR1pjmnDSDShqOc
         NVIESGW1S+GK2asy8IAW0AzQ7fENOaGSOESPW1EFBqYrL2THcv/YNM3gbZOH1BXmQG+g
         I7X8Ej1/8k77iaY5IZ/FF884CTV2xK/2NaiikdiQmip46O2Sszp6sd3JaG1nbstSGEFE
         wmcnrhObazyWYsCq8DNb4cddquxants16nOqoc/50gCVZ9ACHhddVKWXet0iE5aOBxSc
         0j75LYI1T0m74jt1AUrES9LLgoO39yXJynFzwvkGLwPZiEk1g17//RWtnKlaK3rRpd65
         Phyg==
X-Gm-Message-State: AOAM533ZOAU3R8meS8wKujceR4Dj+EZ0iQVDUeNvxYO2klukEzSJ7iMN
        7eDr0F0OYG7Q0Hhzsh6z7dk=
X-Google-Smtp-Source: ABdhPJyM6BwPxbcbw53plX885f/l6SlC1Ra54vTHg8PP4LZ+h2JZGGPTCAXf+NCPLFV0MoLLz3OWTw==
X-Received: by 2002:a05:6a00:2410:b0:409:5fbd:cb40 with SMTP id z16-20020a056a00241000b004095fbdcb40mr1203946pfh.8.1634757424078;
        Wed, 20 Oct 2021 12:17:04 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id p5sm3556289pfb.95.2021.10.20.12.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 12:17:03 -0700 (PDT)
Date:   Thu, 21 Oct 2021 00:47:01 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH bpf-next 07/10] bpf: Add helpers to query conntrack info
Message-ID: <20211020191701.kp3mwirgva2j3fly@apollo.localdomain>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
 <20211019144655.3483197-8-maximmi@nvidia.com>
 <20211020035622.lgrxnrwfeak2e75a@apollo.localdomain>
 <91d47467-93b2-7856-2150-61f75b1aaac4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91d47467-93b2-7856-2150-61f75b1aaac4@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 06:48:25PM IST, Maxim Mikityanskiy wrote:
> On 2021-10-20 06:56, Kumar Kartikeya Dwivedi wrote:
> > On Tue, Oct 19, 2021 at 08:16:52PM IST, Maxim Mikityanskiy wrote:
> > > The new helpers (bpf_ct_lookup_tcp and bpf_ct_lookup_udp) allow to query
> > > connection tracking information of TCP and UDP connections based on
> > > source and destination IP address and port. The helper returns a pointer
> > > to struct nf_conn (if the conntrack entry was found), which needs to be
> > > released with bpf_ct_release.
> > >
> > > Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> > > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> >
> > The last discussion on this [0] suggested that stable BPF helpers for conntrack
> > were not desired, hence the recent series [1] to extend kfunc support to modules
> > and base the conntrack work on top of it, which I'm working on now (supporting
> > both CT lookup and insert).
>
> If you have conntrack lookup, I can base my solution on top of yours. As it
> supports modules, it's even better. What is the current status of your work?
> When do you plan to submit a series? Please add me to Cc when you do.
>

Great, I'll post the lookup stuff separately next week, and Cc you.

Thanks!

> Thanks for reviewing!
>
> > [0]: https://lore.kernel.org/bpf/CAADnVQJTJzxzig=1vvAUMXELUoOwm2vXq0ahP4mfhBWGsCm9QA@mail.gmail.com
> > [1]: https://lore.kernel.org/bpf/CAADnVQKDPG+U-NwoAeNSU5Ef9ZYhhGcgL4wBkFoP-E9h8-XZhw@mail.gmail.com
> >
> > --
> > Kartikeya
> >
>

--
Kartikeya
