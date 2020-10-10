Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE05728A3D2
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389914AbgJJWzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731205AbgJJTxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:53:14 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39FDC0613E3;
        Sat, 10 Oct 2020 02:58:47 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id 33so11880361edq.13;
        Sat, 10 Oct 2020 02:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SeitlzLVHovjLjm98fbptQsAkFvsyB8947FeMfcf+nE=;
        b=DKGgVKSP3QSuXW5E7dmqH0yjGz0cWfWzDO85bh02XzBoRSghupAWFyIHUl7anZVJI7
         lt57yGodPiUl3bm8SxZSmnc9TXXJFc81yJxgLfNlxBDgOp8eNZ8FbsijBqFjt8dfEC9J
         u9etbhAByT9QXPia7pSoG5gzhL7ESeEfrHHy05oOUawy7QK7afGsDL5yzBDeqjTbG14e
         buK3SuKVrp1v2LWHM55/7MbvY2jn0z41epKuNOZPDsZx33a7JeJXTCkzIUq8wrLm2WB2
         JdhD+ddlJ1CebUCRjykN2yCIIMi1En+s3xP/TcnKN/MIkIufQunzC5gbysR2oWmWGZIC
         biXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SeitlzLVHovjLjm98fbptQsAkFvsyB8947FeMfcf+nE=;
        b=dWASRf6rvsWBzKfADWo7fXsFvoSb2Ftkvd6EMcgmYiE3IEKJxGmfLLRAcOIs1JE2+K
         PEsjFRbMi4lIVQI6jRggWPpVgOjIWc0xWK0cvvfQQQ2GP8WdxzASiAzFBJc+qyElGoQM
         QhrbVgsWaqxaQ7HC6BGox9kTPQOE38K/TZABfe7N+FTLQBW28LZJVAifGV5sIVvFIHI2
         b1TQ2OAtq523s7p91PH/N82jmcBlNWDQA9pKvv6avV7p2Y0qdyZ3h++1hbxwM4PM1OiT
         H/y+dN8jr+xOuqQ/SWL2C1L5Hxd0odc/5gpEKcCdceesEavhDxplJzAuzqLx+2nfP4EW
         RUvw==
X-Gm-Message-State: AOAM530V7h0iaoyilbxo0E2YMD9fUsL63P0/PJC5VxLrGLmFySMGRavR
        G3GGEco63Fnbvefjtn7Ilv+Kk9ckj7ZeNN7vPg==
X-Google-Smtp-Source: ABdhPJwEKdbtc+BVmGyUHEb3yux15x0kwE3MJTtARqdGa3MJTwe+n1g36kKA0Gj7BTvmIbEkl6XjBD8gHgUjealKiws=
X-Received: by 2002:aa7:d719:: with SMTP id t25mr3757681edq.11.1602323926187;
 Sat, 10 Oct 2020 02:58:46 -0700 (PDT)
MIME-Version: 1.0
References: <20201009160353.1529-1-danieltimlee@gmail.com> <20201009160353.1529-3-danieltimlee@gmail.com>
 <CAEf4Bzao-mCaQ4BnvoFZ_-wMSuoJ3JMJw1SAuy9bNRwy0E7qdg@mail.gmail.com>
In-Reply-To: <CAEf4Bzao-mCaQ4BnvoFZ_-wMSuoJ3JMJw1SAuy9bNRwy0E7qdg@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Sat, 10 Oct 2020 18:58:31 +0900
Message-ID: <CAEKGpzgXLbSyEuZ9x01k2vkRPFXJDTsreCqXUov7sfiL+BTE5A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] samples: bpf: Replace attach_tracepoint() to
 attach() in xdp_redirect_cpu
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 3:23 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Oct 9, 2020 at 9:04 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > From commit d7a18ea7e8b6 ("libbpf: Add generic bpf_program__attach()"),
> > for some BPF programs, it is now possible to attach BPF programs
> > with __attach() instead of explicitly calling __attach_<type>().
> >
> > This commit refactors the __attach_tracepoint() with libbpf's generic
> > __attach() method. In addition, this refactors the logic of setting
> > the map FD to simplify the code. Also, the missing removal of
> > bpf_load.o in Makefile has been fixed.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
> >  samples/bpf/Makefile                |   2 +-
> >  samples/bpf/xdp_redirect_cpu_user.c | 138 +++++++++++++---------------
> >  2 files changed, 67 insertions(+), 73 deletions(-)
> >
>
> [...]
>
> >  #define NUM_TP 5
> > +#define NUM_MAP 9
> >  struct bpf_link *tp_links[NUM_TP] = { 0 };
>
> = {}
>
> > +static int map_fds[NUM_MAP];
> >  static int tp_cnt = 0;
> >
> >  /* Exit return codes */
>
> [...]
>
> > -static struct bpf_link * attach_tp(struct bpf_object *obj,
> > -                                  const char *tp_category,
> > -                                  const char* tp_name)
> > +static int init_tracepoints(struct bpf_object *obj)
> >  {
> > +       char *tp_section = "tracepoint/";
> >         struct bpf_program *prog;
> > -       struct bpf_link *link;
> > -       char sec_name[PATH_MAX];
> > -       int len;
> > +       const char *section;
> >
> > -       len = snprintf(sec_name, PATH_MAX, "tracepoint/%s/%s",
> > -                      tp_category, tp_name);
> > -       if (len < 0)
> > -               exit(EXIT_FAIL);
> > +       bpf_object__for_each_program(prog, obj) {
> > +               section = bpf_program__section_name(prog);
> > +               if (strncmp(section, tp_section, strlen(tp_section)) != 0)
> > +                       continue;
>
> that's a convoluted and error-prone way (you can also use "tp/bla/bla"
> for tracepoint programs, for example). Use
> bpf_program__is_tracepoint() check.
>

Thanks for the review!
I think that's a much better way. I will send the next patch with applying
that method.

> >
> > -       prog = bpf_object__find_program_by_title(obj, sec_name);
> > -       if (!prog) {
> > -               fprintf(stderr, "ERR: finding progsec: %s\n", sec_name);
> > -               exit(EXIT_FAIL_BPF);
> > +               tp_links[tp_cnt] = bpf_program__attach(prog);
> > +               if (libbpf_get_error(tp_links[tp_cnt])) {
> > +                       tp_links[tp_cnt] = NULL;
> > +                       return -EINVAL;
> > +               }
> > +               tp_cnt++;
> >         }
> >
>
> [...]
