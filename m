Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7372F4F1F4E
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 00:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236709AbiDDWsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 18:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240628AbiDDWqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 18:46:30 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED3E5AA67;
        Mon,  4 Apr 2022 14:55:22 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id v13so2928069ilg.5;
        Mon, 04 Apr 2022 14:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MGHTtDX6Dn8FxsGu2/jMikf14N8mURPGBmGwlctUzt0=;
        b=OF1euDStie9qAsoOaA/kS0+wtdJKUg8FgP3vmd+dmXlTZmoGhuABUWPs5FvjsOuLJN
         W5cqk2l2Zpw7DW3OacsrWrZbjYxQGFMZPIFyvQlqWFlLRTEJFdRe0c4/gvQhDHctVxSd
         /mRhfqAJVJG7Y/7n6l/n90sAQjGxIggOy/Q5/sz6jD8hq/8XG4NJ/3lQi5OJJamXDL/c
         dqJSCRtPktF3eW8H4qFsY2DQUwMKuIdlbMm9KWA0NmUdQbhG3iZUy6IONMiA6kAQuKf/
         JVxRJ8zkVng8PBmWegw+7rxrJvXwpYT60hd8x2ElpDFJgMAApVkmNCQz/zXaTI/h18NK
         hxiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MGHTtDX6Dn8FxsGu2/jMikf14N8mURPGBmGwlctUzt0=;
        b=ExoNUUuahUXRtet/4tIsa1tnLBxewdmuNVcC+n0z6P+zDwZJPIAbwzIOINczci2UHW
         L8lu9AgZbeYG/kImV4m9PKFwPhFI/Ad8GuHOH/e5sc2QmQ9wsnlF0u8cu08xJuq3Pnef
         Xt87/IMpRgRncEInuW7gyT6CyoLtnug7Q/hx0Ao7juwRZ5c+s57lrY3Gdgu9z4UlNCMC
         ujR1+Ng+4yJ+WO4roSWkbci0soz24Jyd2fx/W0nlOFJv+ByNuxT9Gs7p41Ql5HRUK2BP
         0eONq1/izF5faN4zUoM/Y8bPLmWE609TqRMlRZGFWd5dsBx6mae7xHwh6Y+RfJEk++bH
         5fYA==
X-Gm-Message-State: AOAM532I4CnB66JhS+Jv3Hhro0F5cMzaln9dL7RM3ApQLFUJN+eu/b+F
        bvTPs/HsN1OwbJ3RW78PjZfAh1ekhcDwbglccFNhgiyb
X-Google-Smtp-Source: ABdhPJw/Y6iwuk78hhYJUGjozekhPimRZwy3XkHl+nuouobh4zRACZG0Z/FnvqUavzgcRSh7T/ujhR6LqpA7mdOOmrs=
X-Received: by 2002:a05:6e02:1562:b0:2ca:50f1:72f3 with SMTP id
 k2-20020a056e02156200b002ca50f172f3mr161231ilu.71.1649109321393; Mon, 04 Apr
 2022 14:55:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220331154555.422506-1-milan@mdaverde.com> <20220331154555.422506-3-milan@mdaverde.com>
 <4612c72e-0256-0c99-c2b1-92e93a4c4416@isovalent.com>
In-Reply-To: <4612c72e-0256-0c99-c2b1-92e93a4c4416@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 4 Apr 2022 14:55:10 -0700
Message-ID: <CAEf4BzYErAJ9OZeD4tnvdnHzWY4Y_JhBE+xSKHfS_3tuKYcrmA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpf/bpftool: add missing link types
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Milan Landaverde <milan@mdaverde.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

On Fri, Apr 1, 2022 at 9:05 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2022-03-31 11:45 UTC-0400 ~ Milan Landaverde <milan@mdaverde.com>
> > Will display the link type names in bpftool link show output
> >
> > Signed-off-by: Milan Landaverde <milan@mdaverde.com>
> > ---
> >  tools/bpf/bpftool/link.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
> > index 97dec81950e5..9392ef390828 100644
> > --- a/tools/bpf/bpftool/link.c
> > +++ b/tools/bpf/bpftool/link.c
> > @@ -20,6 +20,8 @@ static const char * const link_type_name[] = {
> >       [BPF_LINK_TYPE_CGROUP]                  = "cgroup",
> >       [BPF_LINK_TYPE_ITER]                    = "iter",
> >       [BPF_LINK_TYPE_NETNS]                   = "netns",
> > +     [BPF_LINK_TYPE_XDP]                             = "xdp",

fixed indentation here and added KPROBE_MULTI while applying

> > +     [BPF_LINK_TYPE_PERF_EVENT]              = "perf_event",
>
> Since this goes into bpf-next, we should add BPF_LINK_TYPE_KPROBE_MULTI
> as well.
>
> Quentin
