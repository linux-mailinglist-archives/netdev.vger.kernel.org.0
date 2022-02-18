Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9704BAFBD
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 03:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiBRCdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 21:33:50 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbiBRCdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 21:33:49 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3357F2D5F3F;
        Thu, 17 Feb 2022 18:33:33 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id p15so11597465ejc.7;
        Thu, 17 Feb 2022 18:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=syBde1rKfM2kggh83qK4r1mfs+ViTeKt0eus0av4hLc=;
        b=F/Ox4UQM+dq/yuhBQm3Njd09m+KaG3hccZBL9ZGvAQfMcoX3DHH+boUPmLwbdJhj2r
         B0QXp/vJEXep/Dr3NNWZes3zY86SrW5BXHx44Ro7cWCkSw1GZc6D811UnAfzhzA8kMH5
         UXqPZBdSf8KIIpVItAW9IyQUwZQxLOz9qfuEUQrjfrLx/HDlIYYqDgP6TGUJhHK9faPx
         1U3bWFXmM+GNdsyzEpAyCA/rSnVa6wGkXPSLt3gyjsHs8rC145/qcSsYCvpabEvqZTVU
         6av3oQlZlEBjGLy+JnJWgp6GFo3Rk06ve3wrc2fSnqumrDMIQIPRIKC1GWtK5htxvO5j
         UfvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=syBde1rKfM2kggh83qK4r1mfs+ViTeKt0eus0av4hLc=;
        b=mg4OY9aps48AIV74GR8sPcAnmx0k7iETx/m979NTB4EjtRjUee6Bx8ot6iNdqQpaUn
         OTampvFV53ntHavJSb0zecU643CBQOgz9GPEBO2XU+ThW3Nbr9DJAUxMidZygfLkWIy6
         LaY9KzvggGvYfDHWMWr8lRRVH5jQtMGPKHjOVuvGrQf/Xk1gBoMvZfd8IwvI8dixqIBA
         KnW1aWXesCJZU+Z8gkwi/zCC2zNnoreu0P0xG/Qhj1NhxkS9D+zG0ZaBKiY8BONQ7J3Q
         vkBjdbZbziY29u0eHLu9BjQfuKDX326ZImnOMpezHV0YCezJUN4xI6h0m9WV1eqIl8qA
         EaSw==
X-Gm-Message-State: AOAM533dthB3cdQ/Hhv4TA+G1tJq9G9UeLYhgGopYJZN4pa98rPDVEbi
        F+HXM+Hx/fxemg4oovusSt+5FSxSzmBRz4MI/WY=
X-Google-Smtp-Source: ABdhPJwP43Y1+738Ym26VXGsA4rIITq8mmzkFqmBSQFS2dk/VQNhgJHZXEd/Onb6/d8eWPnOhmN/zpngNI9qdOJ35no=
X-Received: by 2002:a17:907:369:b0:6cf:d106:acae with SMTP id
 rs9-20020a170907036900b006cfd106acaemr4642917ejb.456.1645151611672; Thu, 17
 Feb 2022 18:33:31 -0800 (PST)
MIME-Version: 1.0
References: <20220216035426.2233808-1-imagedong@tencent.com>
 <20220216035426.2233808-2-imagedong@tencent.com> <20220216075821.219b911f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220216115004.5e9dc2b6@gandalf.local.home>
In-Reply-To: <20220216115004.5e9dc2b6@gandalf.local.home>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 18 Feb 2022 10:28:18 +0800
Message-ID: <CADxym3YEdO8zGhUsd7S=kh+nfCsTYbK1guOYYbMSdswubNZQaw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/9] net: tcp: introduce tcp_drop_reason()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>,
        Willem de Bruijn <willemb@google.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        flyingpeng@tencent.com
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

On Thu, Feb 17, 2022 at 12:50 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 16 Feb 2022 07:58:21 -0800
> Jakub Kicinski <kuba@kernel.org> wrote:
>
> > On Wed, 16 Feb 2022 11:54:18 +0800 menglong8.dong@gmail.com wrote:
> > > +static inline void tcp_drop(struct sock *sk, struct sk_buff *skb)
> > > +{
> > > +   tcp_drop_reason(sk, skb, SKB_DROP_REASON_NOT_SPECIFIED);
> > >  }
> >
> > Please make this non-inline. The compiler will inline it anyway, and
> > if it's a static inline compiler will not warn us that it should be
> > removed once all callers are gone.
>
> I guess that's no longer true for C files.
>
>   https://lore.kernel.org/all/202202132037.4aN017dU-lkp@intel.com/
>

Ok, seems we can keep this inline still.

> -- Steve
