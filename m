Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138B24DD6D5
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 10:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbiCRJJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 05:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiCRJJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 05:09:47 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79966F05;
        Fri, 18 Mar 2022 02:08:27 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id l1-20020a05600c4f0100b00389645443d2so4483541wmq.2;
        Fri, 18 Mar 2022 02:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H57joah6JRzSVyTYQU9KgsPj7jpKF/h05WJs7NLLPns=;
        b=U03bJzQT0bJEJexS9V+NX2I4JCuYr9aZlksheW/sF/hJzk4knck8d4PTQg/42l5M+j
         8BI94ADqtc8LYVbhYyQf4WfPjF8JeKZbV9CLpHOuumRXb47Imnpg+UlGjFqYhIZTrazR
         IQYWLCJSe66umM+bPfz0Xc1Ykzkxs2SmWHVqsXxa1dELbg8qaGU8FCnEc3SFJsBAhgMw
         K4znPLSc9pu2I33NibQYseyJyttB7ARdDJkL8tXMBNJV/EytZxCSX65ym3JCf9NGfY3y
         6vJKvTsPLrOwFmEld8bJnusWw/inq0z8v+PFQEneVo58AGh5oHPCXgJg8XcG1zOYeRDN
         8sxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H57joah6JRzSVyTYQU9KgsPj7jpKF/h05WJs7NLLPns=;
        b=GINRlbppYgmK6EITmFkOAtPjaKR+37xQjTApNladPYzqOLTpyIk9CPmgM/XHbPdFOm
         Oh6p0AaWLTz10Fsa7hfI7pNeYaUhnn3PDbk2+cx8T/2JIEB4GWIR6gZOEVFIjeeUS5fP
         iE1u6bSO704ogotRWclG/i5fDmOsGfr45VNakaE4N40Vw8zWRonBWENvKBLiTM4L5xVW
         Fsv/iMMvO2c9i/KqDhfXO2l5m7TzBuZ8Mz6XmTH/Bagak4ZaBsfGsBOxxRjtQFoN3rgc
         VlEIXl32W43xIl2Jxhx3BRxNDLDsNejoMIhPLmg3cSQqH0Cwwg2Y4vmWK0MOuBKJSddM
         cKBQ==
X-Gm-Message-State: AOAM532cFi6JindYKWD2MxK8gFxg6MOZBRryGaAN1/S6MRmGJpcIgvcT
        ewZZii4dWWuKGJlCQqFnTHY=
X-Google-Smtp-Source: ABdhPJyZpRyr27HrecJoZkWPMBKFOa8W8tfobGxLHZGSFQNbA8X4Lb6U+1YvSx4S1Ed2kH+HTiNoYQ==
X-Received: by 2002:a05:600c:1e1f:b0:38b:d7ea:99b9 with SMTP id ay31-20020a05600c1e1f00b0038bd7ea99b9mr7345798wmb.8.1647594505926;
        Fri, 18 Mar 2022 02:08:25 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id f8-20020adfb608000000b0020229d72a4esm5686171wre.38.2022.03.18.02.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 02:08:25 -0700 (PDT)
Date:   Fri, 18 Mar 2022 10:08:22 +0100
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCHv3 bpf-next 09/13] libbpf: Add
 bpf_program__attach_kprobe_multi_opts function
Message-ID: <YjRMBmmKN47G8iQ0@krava>
References: <20220316122419.933957-1-jolsa@kernel.org>
 <20220316122419.933957-10-jolsa@kernel.org>
 <CAADnVQ+tNLEtbPY+=sZSoBicdSTx1YLgZJwnNuhnBkUcr5xozQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+tNLEtbPY+=sZSoBicdSTx1YLgZJwnNuhnBkUcr5xozQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 08:53:15PM -0700, Alexei Starovoitov wrote:
> On Wed, Mar 16, 2022 at 5:26 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > +
> > +struct bpf_link *
> > +bpf_program__attach_kprobe_multi_opts(const struct bpf_program *prog,
> > +                                     const char *pattern,
> > +                                     const struct bpf_kprobe_multi_opts *opts)
> > +{
> > +       LIBBPF_OPTS(bpf_link_create_opts, lopts);
> > +       struct kprobe_multi_resolve res = {
> > +               .pattern = pattern,
> > +       };
> > +       struct bpf_link *link = NULL;
> > +       char errmsg[STRERR_BUFSIZE];
> > +       const unsigned long *addrs;
> > +       int err, link_fd, prog_fd;
> > +       const __u64 *cookies;
> > +       const char **syms;
> > +       bool retprobe;
> > +       size_t cnt;
> > +
> > +       if (!OPTS_VALID(opts, bpf_kprobe_multi_opts))
> > +               return libbpf_err_ptr(-EINVAL);
> > +
> > +       syms    = OPTS_GET(opts, syms, false);
> > +       addrs   = OPTS_GET(opts, addrs, false);
> > +       cnt     = OPTS_GET(opts, cnt, false);
> > +       cookies = OPTS_GET(opts, cookies, false);
> > +
> > +       if (!pattern && !addrs && !syms)
> > +               return libbpf_err_ptr(-EINVAL);
> > +       if (pattern && (addrs || syms || cookies || cnt))
> > +               return libbpf_err_ptr(-EINVAL);
> > +       if (!pattern && !cnt)
> > +               return libbpf_err_ptr(-EINVAL);
> > +       if (addrs && syms)
> > +               return libbpf_err_ptr(-EINVAL);
> > +
> > +       if (pattern) {
> > +               err = libbpf_kallsyms_parse(resolve_kprobe_multi_cb, &res);
> > +               if (err)
> > +                       goto error;
> > +               if (!res.cnt) {
> > +                       err = -ENOENT;
> > +                       goto error;
> > +               }
> > +               addrs = res.addrs;
> > +               cnt = res.cnt;
> > +       }
> 
> Thanks Jiri.
> Great stuff and a major milestone!
> I've applied Masami's and your patches to bpf-next.

great, thanks

> 
> But the above needs more work.
> Currently test_progs -t kprobe_multi
> takes 4 seconds on lockdep+debug kernel.
> Mainly because of the above loop.
> 
>     18.05%  test_progs       [kernel.kallsyms]   [k]
> kallsyms_expand_symbol.constprop.4
>     12.53%  test_progs       libc-2.28.so        [.] _IO_vfscanf
>      6.31%  test_progs       [kernel.kallsyms]   [k] number
>      4.66%  test_progs       [kernel.kallsyms]   [k] format_decode
>      4.65%  test_progs       [kernel.kallsyms]   [k] string_nocheck
> 
> Single test_skel_api() subtest takes almost a second.

hm, I'll check on lockdep+debug kernel.. I think this test
should be going through kallsyms just once, will check

anyway libbpf_kallsyms_parse could use ksym_get_addr, which is
now cached

> 
> A cache inside libbpf probably won't help.
> Maybe introduce a bpf iterator for kallsyms?
> 
> On the kernel side kprobe_multi_resolve_syms() looks similarly inefficient.
> I'm not sure whether it would be a bottle neck though.
> 
> Orthogonal to this issue please add a new stress test
> to selftest/bpf that attaches to a lot of functions.

ok, will add that

thanks,
jirka
