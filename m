Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E807C3A01C6
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbhFHS4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 14:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236419AbhFHSyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 14:54:11 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C5AC061145;
        Tue,  8 Jun 2021 11:49:08 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id u7so11178516plq.4;
        Tue, 08 Jun 2021 11:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wL6KSwo0TwWeM3oDNEJHVYbpsiCDr8Co8+WhySeHKfg=;
        b=FDEmou5ruDlz3H9qbrSR+MWOOgzpv/UHNnV9es24BzpMrVdIqoiYXItjNM+9eHqNBJ
         OSJCOxJiSKy4lvxauFwNDbNYEyHA+PmzN4ebrjOfTJOOEci3hjhL2bDQTv7EC4oHbDyF
         ESBXnombma1DAfc3MO+2K0vXaE8lcdjaZlv8YwDzGbXFKO2idY5x0GPkA5rO7G3vJniy
         2cWnK7SJNMeQpovLVVGh2VpcxAq88CRoOLuAsGJN8EBzvVr/7Y5yz7x/LL9aOuY3LRjX
         XDM5LPAUh/AGblSMghYCmaeq2Zngw8qyHJsi1ehZuedB6cGrpfIxAcYLGHe8k7jO+Q87
         y0rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wL6KSwo0TwWeM3oDNEJHVYbpsiCDr8Co8+WhySeHKfg=;
        b=M6kHBJtK+aR0ElEgEOG8TrgfUQN/wp6a5abKZ0y/o4zV1025HNNyKQH+P8spJ/9tGB
         HiYFHCz/vJcNAdgBqZsOtxbMH2hHlhKbSZLdxp6HmskVDMGaMkjnPFUyPJ6fmoURXU0Y
         DNebK+xWlfjiP95dx0OUeaxLeE4Z3PWGTwqrz6n91YE2NvB1Tf9Iol4lrGJhzguEPhJO
         nP8u/6XbpNoA6hw6Hh7iOiT2H1sNrX4GMZ7uIBRCHGqSjzL7Zf9zAFlIAl2SrYWs8VrZ
         VEX1HRSbTrF4L9dfVlxqDd0kwU5lw1SSrg5tdIDdkobBSO06sJ8l6kVYSpLvsMkAw5M4
         v+1w==
X-Gm-Message-State: AOAM531pYQ13bQEDumbc1uG3DqnC6gGl9NWleZSKnskHjv6LkVI5/Pfz
        erFJ/1l9ElLjxj1Wi1lIq3o=
X-Google-Smtp-Source: ABdhPJwokHQva/lAebPiaJ11reZnpju3tMKp4zSxvTaq2jLbUBIoB/bMWyY+a9ICly8AxWULCjIU6w==
X-Received: by 2002:a17:902:6501:b029:ef:8518:a25a with SMTP id b1-20020a1709026501b02900ef8518a25amr1108048plk.64.1623178148174;
        Tue, 08 Jun 2021 11:49:08 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:336e])
        by smtp.gmail.com with ESMTPSA id y6sm15776988pjf.40.2021.06.08.11.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 11:49:07 -0700 (PDT)
Date:   Tue, 8 Jun 2021 11:49:03 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH 13/19] bpf: Add support to link multi func tracing program
Message-ID: <20210608184903.rgnv65jimekqugol@ast-mbp.dhcp.thefacebook.com>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-14-jolsa@kernel.org>
 <CAADnVQJV+0SjqUrTw+3Y02tFedcAaPKJS-W8sQHw5YT4XUW0hQ@mail.gmail.com>
 <YL+0HLQ9oSrNM7ip@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YL+0HLQ9oSrNM7ip@krava>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 08:17:00PM +0200, Jiri Olsa wrote:
> On Tue, Jun 08, 2021 at 08:42:32AM -0700, Alexei Starovoitov wrote:
> > On Sat, Jun 5, 2021 at 4:11 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Adding support to attach multiple functions to tracing program
> > > by using the link_create/link_update interface.
> > >
> > > Adding multi_btf_ids/multi_btf_ids_cnt pair to link_create struct
> > > API, that define array of functions btf ids that will be attached
> > > to prog_fd.
> > >
> > > The prog_fd needs to be multi prog tracing program (BPF_F_MULTI_FUNC).
> > >
> > > The new link_create interface creates new BPF_LINK_TYPE_TRACING_MULTI
> > > link type, which creates separate bpf_trampoline and registers it
> > > as direct function for all specified btf ids.
> > >
> > > The new bpf_trampoline is out of scope (bpf_trampoline_lookup) of
> > > standard trampolines, so all registered functions need to be free
> > > of direct functions, otherwise the link fails.
> > 
> > Overall the api makes sense to me.
> > The restriction of multi vs non-multi is too severe though.
> > The multi trampoline can serve normal fentry/fexit too.
> 
> so multi trampoline gets called from all the registered functions,
> so there would need to be filter for specific ip before calling the
> standard program.. single cmp/jnz might not be that bad, I'll check

You mean reusing the same multi trampoline for all IPs and regenerating
it with a bunch of cmp/jnz checks? There should be a better way to scale.
Maybe clone multi trampoline instead?
IPs[1-10] will point to multi.
IP[11] will point to a clone of multi that serves multi prog and
fentry/fexit progs specific for that IP.
