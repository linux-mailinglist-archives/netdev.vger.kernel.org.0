Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31504D67A4
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 18:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350787AbiCKRbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 12:31:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350770AbiCKRbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 12:31:50 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A9FC9902;
        Fri, 11 Mar 2022 09:30:46 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id s11so8373677pfu.13;
        Fri, 11 Mar 2022 09:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b/8G55OzOqdOPe7ewbRDJHazDCpsX+avNi08vKU5HkA=;
        b=gzjsfC++jDmc81RlDezZ3e0OUo7nQXc/fCO1TYtfk6FGVg60b6gaM0jn/obtZY0yWM
         Of/Ccp8o5cN6cHgR1HQeULX1IYbG0MzERzGaz3NjNqPndkbqWDjpEYH3g+/vDK/fKhRD
         pER9a4QQZbIecTfzA1Ol0MDWsTPIH3WgOkIsIqUXsHmovMfaCUme35nJOg56wj3hc0GO
         gSNvverPnDJ9JEA8x+z+F3Bb0DqAwQRKkUWaCXJGq9jc7EZUqALVOJmCBHorK/hUbhXv
         J+aw+TUzEZdG8ButQ4aJ+QAwxtHULMiq7UxZMvMmEywuKSOSkkCi9Hq+ZqoFcLuEessJ
         QEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b/8G55OzOqdOPe7ewbRDJHazDCpsX+avNi08vKU5HkA=;
        b=k7BDbxqH/Kl57iKCNtipNmBfC3fTznF0ppG0+ZnF4YDJ7tKseT5G1Gr4WOMnawz9gF
         DmYTXVt+OJH+/6HVm9COkQDWS6IVbVjba7nt1RMGkMj5DIMBzUzLOGkvENJZuTtc5tPk
         TqxJIs42GGS9KVIeWWSi02Wn3B4l/VatqX88iN+H3EgEuZ2btKSx/yn3sRCO1fPELwBO
         6br7s7qIzL1jJ7ac+bWEuPHq4Ss8PE1EXhZtvxfAbjklQ1v52EVvM+FyxIHKuDmWtGTc
         O6HCSoUGZINhLeCt8z9cGx2yK42NR4+Kq2osgbd5riOt+1Oyl7q38Tp7RjzSj6vxbkNZ
         Pbug==
X-Gm-Message-State: AOAM531CcrrqtYP9PBhA8idb5ruFqsWiYQwUSgOPg1Cp7dbmtAbP8A7a
        EtmiK7Te91DVriOrB5JJmstbQarR8iSoLR8U7ZM=
X-Google-Smtp-Source: ABdhPJwtZAS4uEz31pZlqlmM9COGPd6xb6eeF9Q+qu7aBAfoh/XIpWQ8eMjuTPwyoOD0QOBtHtid81WoayDQ9kj1Vvw=
X-Received: by 2002:a63:6809:0:b0:37c:68d3:1224 with SMTP id
 d9-20020a636809000000b0037c68d31224mr9127795pgc.287.1647019846156; Fri, 11
 Mar 2022 09:30:46 -0800 (PST)
MIME-Version: 1.0
References: <20220224151145.355355-1-maximmi@nvidia.com> <20220224151145.355355-5-maximmi@nvidia.com>
 <20220227032519.2pgbfassbxbkxjsn@ast-mbp.dhcp.thefacebook.com> <DM4PR12MB51509E0F9B1D2846969A6A72DC0C9@DM4PR12MB5150.namprd12.prod.outlook.com>
In-Reply-To: <DM4PR12MB51509E0F9B1D2846969A6A72DC0C9@DM4PR12MB5150.namprd12.prod.outlook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 11 Mar 2022 09:30:35 -0800
Message-ID: <CAADnVQL-44zw3MvyuCNm6fn5K6m8hnzYmXWJbBF3aXrLKQFLVQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 4/5] bpf: Add helpers to issue and check SYN
 cookies in XDP
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 8:36 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> > -----Original Message-----
> > From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > Sent: 27 February, 2022 05:25
> >
> > On Thu, Feb 24, 2022 at 05:11:44PM +0200, Maxim Mikityanskiy wrote:
> > > @@ -7798,6 +7916,14 @@ xdp_func_proto(enum bpf_func_id func_id, const
> > struct bpf_prog *prog)
> > >             return &bpf_tcp_check_syncookie_proto;
> > >     case BPF_FUNC_tcp_gen_syncookie:
> > >             return &bpf_tcp_gen_syncookie_proto;
> > > +   case BPF_FUNC_tcp_raw_gen_syncookie_ipv4:
> > > +           return &bpf_tcp_raw_gen_syncookie_ipv4_proto;
> > > +   case BPF_FUNC_tcp_raw_gen_syncookie_ipv6:
> > > +           return &bpf_tcp_raw_gen_syncookie_ipv6_proto;
> > > +   case BPF_FUNC_tcp_raw_check_syncookie_ipv4:
> > > +           return &bpf_tcp_raw_check_syncookie_ipv4_proto;
> > > +   case BPF_FUNC_tcp_raw_check_syncookie_ipv6:
> > > +           return &bpf_tcp_raw_check_syncookie_ipv6_proto;
> > >  #endif
> >
> > I understand that the main use case for new helpers is XDP specific,
> > but why limit them to XDP?
> > The feature looks generic and applicable to skb too.
>
> That sounds like an extra feature, rather than a limitation. That's out
> of scope of what I planned to do.
>
> Besides, it sounds kind of useless to me, because the intention of the
> new helpers is to accelerate synproxy, and I doubt BPF over SKBs will
> accelerate anything. Maybe someone else has another use case for these
> helpers and SKBs - in that case I leave the opportunity to add this
> feature up to them.

This patchset will not be accepted until the feature is generalized
to both xdp and skb and tested for both.
"I dont have a use case for it" is not an excuse to narrow down the scope.
