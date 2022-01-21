Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3619C496503
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 19:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382091AbiAUS1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 13:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351874AbiAUS1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 13:27:15 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9167DC06173B;
        Fri, 21 Jan 2022 10:27:15 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id o10so8406700ilh.0;
        Fri, 21 Jan 2022 10:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wk47tWfVpu4tPH1u/nA8kVWfirTrN3kejGmQo3n2nag=;
        b=Y90+uDdkWttI2ZM+u04Em5astlm0ZwZWhSGSH6N8B6dDJaAzo/ZqdBhUq7r7yDORwi
         kVnMcfdUDaaIYbDSv7ObmhNkWhdzB1SjlfATv/9M9Udb/Q9EtstT2JyHMMMP878ZGdtS
         ZtkfIICb+SVAZXrrTYMPG5Af2x2xpDyAdyJezrstIVydjxkYWlldANkqCwU2/PdCP3St
         Z56GN1v+uC0D2hwF+TvJ1dEr3Y+MYSzlN0XAheYkcKCfL5zOBxHKsPhdZC0ZWWuxTZgY
         +uYDmbr7oAFSlh5WAsTxjYYYTgfEfzrXJTxhkILQazAqdOr1TD+/LycDFjF0+yPorFri
         MYVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wk47tWfVpu4tPH1u/nA8kVWfirTrN3kejGmQo3n2nag=;
        b=GQyYoVdECTwBILOpJEeRHJic1ooRk7dAwo574+xcvv8gqD1jCBErAosQcAJ7ivH4iE
         jphEjJeU31KqsJfVQJOhg9Vw/gdvX23qPYtPFn3ovKsUdkcU7vzzrNKQw1X6oRLG2L+J
         ud987AQ5Led3tNONcGtL4Jevqo1D3TI+OP7PIjzV6CvcFnryx/g9ZjrUGDB0JSWcEbx9
         T4NXQLROQ4NguVS74snR/u0tBgpPGm2184myoRB398wfzIxcezXxPU2ONeWdHRYEoDG+
         aYL4NfeiqglYYCsMW92yRY1iPhuXXDkdygkXct/zWpcjwQBJZBeI3/fXm3qC6xvUwnTk
         curw==
X-Gm-Message-State: AOAM5331kx/pBqZe9CdYyZloGKO1tCGGLdg5JiXovm6Ldp4iLKzIbLrA
        uIUuWlGk20jTAHKPifPYM/rj1H0xqed15OBWZX4=
X-Google-Smtp-Source: ABdhPJyfCrDd7dOOhrd3ZSI1xP4OQN3Aj0NW4ICbWOQzNYvBD7Ht7/LIOe52X2zUS74TnnHLhAnecJmYE+7bDrZDxS8=
X-Received: by 2002:a05:6e02:1749:: with SMTP id y9mr2720376ill.252.1642789635012;
 Fri, 21 Jan 2022 10:27:15 -0800 (PST)
MIME-Version: 1.0
References: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com>
 <CAADnVQJMsVw_oD7BWoMhG7hNdqLcFFzTwSAhnJLCh0vEBMHZbQ@mail.gmail.com>
 <CAEf4Bza8m33juRRXa1ozg44txMALr4A_QOJYp5Nw70HiWRryfA@mail.gmail.com> <CAADnVQL0nq_jHY7Js3FN2bFBy4eo-7=4cfurkt5xQmU_yJGCvA@mail.gmail.com>
In-Reply-To: <CAADnVQL0nq_jHY7Js3FN2bFBy4eo-7=4cfurkt5xQmU_yJGCvA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Jan 2022 10:27:04 -0800
Message-ID: <CAEf4BzYPncQpbjbyh9XA4qdMqerWtcfgaMEiQYmdXcby+wUnXQ@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/3] libbpf: name-based u[ret]probe attach
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 10:20 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jan 21, 2022 at 10:15 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Jan 20, 2022 at 5:44 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Thu, Jan 20, 2022 at 3:43 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> > > >
> > > > This patch series is a refinement of the RFC patchset [1], focusing
> > > > on support for attach by name for uprobes and uretprobes.  Still
> > > > marked RFC as there are unresolved questions.
> > > >
> > > > Currently attach for such probes is done by determining the offset
> > > > manually, so the aim is to try and mimic the simplicity of kprobe
> > > > attach, making use of uprobe opts to specify a name string.
> > > >
> > > > uprobe attach is done by specifying a binary path, a pid (where
> > > > 0 means "this process" and -1 means "all processes") and an
> > > > offset.  Here a 'func_name' option is added to 'struct uprobe_opts'
> > > > and that name is searched for in symbol tables.  If the binary
> > > > is a program, relative offset calcuation must be done to the
> > > > symbol address as described in [2].
> > >
> > > I think the pid discussion here and in the patches only causes
> > > confusion. I think it's best to remove pid from the api.
> >
> > It's already part of the uprobe API in libbpf
> > (bpf_program__attach_uprobe), but nothing really changes there.
> > API-wise Alan just added an optional func_name option. I think it
> > makes sense overall.
>
> Technically it can be deprecated.
> So "it's already part of api" isn't really an excuse to keep
> confusing the users.

... but I don't find it confusing and no one really ever complained?..
So it doesn't seem like we need to remove this.
