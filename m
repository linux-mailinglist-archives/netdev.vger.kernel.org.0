Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC3652B068
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 04:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbiERCPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 22:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234104AbiERCPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 22:15:39 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4511527F5;
        Tue, 17 May 2022 19:15:38 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id p26so1211059eds.5;
        Tue, 17 May 2022 19:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JXMeiZpRbqebPZ+WeJXkCP47PB5pNo1slb1wa7BPK2k=;
        b=mk8kGwEoLJif3jaisTdRKRB+jlaFmXApaTdep/q0RL3f4bf8Vj1yNPDdzmYnLwwT7u
         r7Js1Zi+0Bd9/xwWBJwoIcYsOPZYYIFsfRIoPIGzFCeZIuTlOIOGCLMMfnrfhXCUmctC
         eJqlZm7fOltVHkajDvwjIUoJWoEp4I85jRnYx86YHXrmi/Ew3xu/c7AYPEX0LZLjfjN6
         uOgk2ctY0FdlHMoAZJ3mYQzRTiiTMbHv7YLjaHCteAa7M3ukGuJ5hf0eTdqdwZsic+Di
         EJIQeOZgSjenh454VidOcQRB6EN1IZFJpCWFi+OF3yXAO978k87Kg6IsDbBJbYTRXcdi
         MAVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JXMeiZpRbqebPZ+WeJXkCP47PB5pNo1slb1wa7BPK2k=;
        b=DHxkATajn04ERcq+bmrCLxLldb5JIAiO5VvDn8K1Mcm3zkMRGkjMUYEP2GFAZwpmY+
         CpqXlbuG3JVE6a4PoYcz07oDER6sS/EJUm/qrE0hd8ve4j58EVxykaeldJNiwKzfKmab
         vBNS2GqOUgrl/jLyR3iIbrPL5FNybWI6bKI1v6WwksS8ewNpwbpPjuZMSzKqdewvg5Nc
         gaK2wNbkk1FjOxDsEIzU3zrq3ysvddGDDRZJf+IBAA591D3aw4Ko/uAhYOdPUY2tH0QU
         66xc96yzr1KhVgCrMlUXzdCJTgEJiEUtNjYlmYbQQbKhKM0qxKJAOFmc7u61f2FyEbYo
         tqwQ==
X-Gm-Message-State: AOAM531epalYzzbpfOOmzjUiKlRE0OkpIYp13lrBPNV4LGhKtv3jYIN/
        ovFhNtloSj84SjyQgVPx7Cfv5EszkoXbuEYUGOw=
X-Google-Smtp-Source: ABdhPJxsAIt9BR8uYZ8idf3uHt7ruusnp/3WSeEmVHtW7Zy7fJ0q3KYw6taXz+0C/GKpQXtilkfRO+boEEMzU7qe1m8=
X-Received: by 2002:a50:ccd5:0:b0:42a:64da:64c8 with SMTP id
 b21-20020a50ccd5000000b0042a64da64c8mr19994078edj.196.1652840137332; Tue, 17
 May 2022 19:15:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220517081008.294325-1-imagedong@tencent.com>
 <20220517081008.294325-2-imagedong@tencent.com> <20220517181457.04c37147@kernel.org>
In-Reply-To: <20220517181457.04c37147@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 18 May 2022 10:15:25 +0800
Message-ID: <CADxym3aqSsS2WAKyHYUXvKs45zdj-4rZu8a5QYoJUf5u+fpWkA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/9] net: skb: introduce __DEFINE_SKB_DROP_REASON()
 to simply the code
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        Martin Lau <kafai@fb.com>, Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
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

On Wed, May 18, 2022 at 9:15 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 17 May 2022 16:10:00 +0800 menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > It is annoying to add new skb drop reasons to 'enum skb_drop_reason'
> > and TRACE_SKB_DROP_REASON in trace/event/skb.h, and it's easy to forget
> > to add the new reasons we added to TRACE_SKB_DROP_REASON.
> >
> > TRACE_SKB_DROP_REASON is used to convert drop reason of type number
> > to string. For now, the string we passed to user space is exactly the
> > same as the name in 'enum skb_drop_reason' with a 'SKB_DROP_REASON_'
> > prefix. So why not make them togather by define a macro?
> >
> > Therefore, introduce __DEFINE_SKB_DROP_REASON() and use it for 'enum
> > skb_drop_reason' definition and string converting.
> >
> > Now, what should we with the document for the reasons? How about follow
> > __BPF_FUNC_MAPPER() and make these document togather?
>
> Hi, I know BPF does this but I really find the definition-by-macro
> counter productive :(
>
> kdoc will no longer work right because the parser will not see
> the real values. cscope and other code indexers will struggle
> to find definitions.
>

Yeah, I found this problem too. My autocomplete in vscode never helps
me anymore after I use this macro.

> Did you investigate using auto-generation? Kernel already generates
> a handful of headers. Maybe with a little script we could convert
> the enum into the string thing at build time?
>

Oh, I forgot about auto-generation, it seems it's a better choice.
I'll try to use auto-generation.

> Also let's use this opportunity to move the enum to a standalone
> header, it's getting huge.
>
> Probably worth keeping this rework separate from the TCP patches.
> Up to you which one you'd like to get done first.

Ok, I'll make the enum in a standalone header in the separated
series.

Thans!
Menglong Dong
