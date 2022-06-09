Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD2654542F
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 20:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236715AbiFISdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 14:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbiFISdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 14:33:16 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7632732EF6;
        Thu,  9 Jun 2022 11:33:13 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id g25so27098812ljm.2;
        Thu, 09 Jun 2022 11:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=63i1MSmo29/lZiyPRVcuxToXjRzucauBbf7VDgGDw7c=;
        b=BS9YAKqCCd2cgZ+f+6knt/gJcHnUmnC8d0YmKtTD9F1mAvBr/4LG/SI26JtxYATtpE
         kCxM/G3+deeEEdyPwrcI/Lk8FX2qsaZ8ui9RN0x+d559XF1vuHRylLGX5na9YBA4dPpv
         yDre1NdgKWIlzm3VqsT/TrI6DgNSpx3uwlAymo8k6eskDU1oO9APoSOAR2hC3bdIJCtE
         63uf+uRVj/XbV8c0tNsYZwe+4nst0qlbJfPM8pqbYbOGKgLFr7u2KlgVGtpSRc8MblB0
         hjWORsGNHZxC/aurR+s+dEgmeB5ryrFS2x7r2d01MBm+X/zJ+9wFg2KQdaak/m/y+VOw
         LhQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=63i1MSmo29/lZiyPRVcuxToXjRzucauBbf7VDgGDw7c=;
        b=DQx4MCT4tkv5AMEtYUujkWltwwn8R620WHJ1YiaZfIL9NcBOKBPpIpTpuBw5WwVBOn
         zc7t9H8x36yBJZGM9ZN7skICXqHnzGfxSqCCIE62rZSmszztPF6mfjWS8tGaudMZP7v0
         zFW2cdz5VKTw2norErYCUsQo1GhArm8EFBYDcJzWHYwG8abTrIRvaFOJzXenV2aB+e5N
         wXINaohklOfQbr0EAySAMf8bTZbcK4oS3pWIxbkO63xgudIkMLodHlVVXaW+ou+pQrpq
         fi3CZU7lox8V5K02e4YR01ASRypWX6oDCsctk+VMtL6JIwdI7gDrMEBzgdIx93JyKBuE
         yYZw==
X-Gm-Message-State: AOAM533a/uo7oE8mImA/w+LYbwhzLkMai+rAIbqaSJbFP0Gd9Ooqq805
        oD0lVZjo6q/UmyVDaKOL4jxbFVb6bAZG4ktCNlk=
X-Google-Smtp-Source: ABdhPJy5Ho/4uLY7T6tCqh+921GEWGPPTNDBl5Do5LnnhkOQmiHaUc4mupwgsGSACvZZdwXJzyFpbDPPT1M3tl4sXRk=
X-Received: by 2002:a2e:bd13:0:b0:246:1ff8:6da1 with SMTP id
 n19-20020a2ebd13000000b002461ff86da1mr59663030ljq.219.1654799590704; Thu, 09
 Jun 2022 11:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220606184731.437300-1-jolsa@kernel.org> <20220606184731.437300-4-jolsa@kernel.org>
 <CAADnVQJA54Ra8+tV0e0KwSXAg93JRoiefDXWR-Lqatya5YWKpg@mail.gmail.com>
 <Yp+tTsqPOuVdjpba@krava> <CAADnVQJGoM9eqcODx2LGo-qLo0=O05gSw=iifRsWXgU0XWifAA@mail.gmail.com>
 <YqBW65t+hlWNok8e@krava> <YqBynO64am32z13X@krava> <20220608084023.4be8ffe2@gandalf.local.home>
 <CAEf4BzYkHkB60qPxGu0D=x-BidxObX95+1wjEYN8xsK7Dg_4cw@mail.gmail.com> <20220608120830.1ff5c5eb@gandalf.local.home>
In-Reply-To: <20220608120830.1ff5c5eb@gandalf.local.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Jun 2022 11:32:59 -0700
Message-ID: <CAEf4BzakYUnM3ZNgRbix=Z4bnPpzGiazAffMVh239476qH_c7A@mail.gmail.com>
Subject: Re: [PATCHv2 bpf 3/3] bpf: Force cookies array to follow symbols sorting
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
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

On Wed, Jun 8, 2022 at 9:08 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 8 Jun 2022 08:59:50 -0700
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > Would it be possible to preprocess ftrace_pages to remove such invalid
> > records (so that by the time we have to report
> > available_filter_functions there are no invalid records)? Or that data
> > is read-only when kernel is running?
>
> It's possible, but will be time consuming (slow down boot up) and racy. In
> other words, I didn't feel it was worth it.
>
> We can add it. How much of an issue is it to have these place holders for
> you? Currently, I only see it causes issues with tests. Is it really an
> issue for use cases?

I have the tool (retsnoop) that uses available_filter_functions, I'll
have to update it to ignore such entries. It's a small inconvenience,
once you know about this change, but multiply that for multiple users
that use available_filter_functions for some sort of generic tooling
doing kprobes/tracing, and it adds up. So while it's not horrible,
ideally user-visible data shouldn't have non-usable placeholders.

How much slowdown would you expect on start up? Not clear what would
be racy about this start up preprocessing, but I believe you.

So in summary, it's not the end of the world, but as a user I'd prefer
not to know about this quirk, of course :)

>
> -- Steve
