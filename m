Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B802D4BD3C4
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 03:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343826AbiBUCeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 21:34:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244106AbiBUCeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 21:34:16 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263C83CA63;
        Sun, 20 Feb 2022 18:33:53 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id d19so3851147ioc.8;
        Sun, 20 Feb 2022 18:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sFlZh2J1pcRsdL+TAyx6kNrGw9gAayCFDDH8nYTDEsI=;
        b=XmtvZDPy1pCD1ICBjIaZAzawjFgA/47BqnLLz2kkCJCUB55v8FAMR7vl+VgsVHGigQ
         bWTADtoKEFIhbwSoWxeSKuuEI50MNBqM9cOw2vbXf0l7f5ua6yLNCGurKF8ALYmjLPs3
         olt5hdrPd/GLFfTnf1e3fuWKfo3UACTyTx1aewHNMDyJHTQRjCMP5uc+s4xE1XNhIXEM
         2/KKbd0jt9xLMsouB0XDnxZPaRJ6ld+Bqcm8waZ+vzr0Pt1iu7AhkxSvXv4t+2bATPUR
         qvaISgvhn/jnWo+68u90IkTiTf4QXnGFAjS5Sma82XPAw7KBAx+2IsJkl4JNvOJ1hQXj
         ADKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sFlZh2J1pcRsdL+TAyx6kNrGw9gAayCFDDH8nYTDEsI=;
        b=2SpwnSffqFYLnfAgUpKzQraBxJQyWzLQQrDmKitH/4yknYYQqLKMb7dxd6waDixnmH
         k9XvgzXuvKZHR6/vsYw1pOCR53/sIRiCdq/4dsONBmIoZyGfi1EoPzCfko308zrjpLn1
         zBYKVcIbs7a2gyt74oUoQuhQ5rlabL50v851fDMqyBR176l6aJUzd4bP6FGy3AxGT6cy
         SUDHGoKOH4nvc93uRynjpFnBjC1FpOckOXsb3tlVuFZVycppNQ4i/NtvJPfoAt/wWSp5
         BA1cpiVhKeltnWlVjDkKeE5bPpc2qeLUQh4Bl5Uh/EpoGgDFS6ID6C/R6oVGRr4zWwCF
         sAMw==
X-Gm-Message-State: AOAM5315lFyklL3oqJuJCi3tgq9PwCC9TRQ2EnVeoCsw4yxh0vjn0Pw6
        BC47mfpOWMFltut0841Dy3HOD8+kAETOTH6N8FE=
X-Google-Smtp-Source: ABdhPJzQpZxBpLvR+4GdXx1frCcpwG0TuF2Qmos4iqNaNguZ205NRlrkXzRwiCDFStX8nbakFghuTLOQfBTM54apsuk=
X-Received: by 2002:a02:a60c:0:b0:314:a8a0:7f55 with SMTP id
 c12-20020a02a60c000000b00314a8a07f55mr11780886jam.60.1645410832334; Sun, 20
 Feb 2022 18:33:52 -0800 (PST)
MIME-Version: 1.0
References: <20220218095612.52082-1-laoar.shao@gmail.com> <20220218095612.52082-3-laoar.shao@gmail.com>
 <CAADnVQJhGmvY1NDsy9WE6tnqYM6JCmi4iZtB7xHuWh4yC-awPw@mail.gmail.com>
 <CALOAHbCytBP4osCXSZ_7+A69NuVf6SYDWGFC62O_MkHn9Fn10Q@mail.gmail.com> <CAADnVQ+FuK2wihDy5GumBN3LVBky0r04CmS4h1JsVoS7QoH6LA@mail.gmail.com>
In-Reply-To: <CAADnVQ+FuK2wihDy5GumBN3LVBky0r04CmS4h1JsVoS7QoH6LA@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Mon, 21 Feb 2022 10:33:16 +0800
Message-ID: <CALOAHbCkBS0Tm0XG07K5339-XUNu-nXwLfTR=SG28Qkr95JczA@mail.gmail.com>
Subject: Re: [PATCH RFC 2/3] bpf: set attached cgroup name in attach_name
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
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

On Mon, Feb 21, 2022 at 4:59 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, Feb 20, 2022 at 6:17 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > On Sun, Feb 20, 2022 at 2:27 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, Feb 18, 2022 at 1:56 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> > > >
> > > > Set the cgroup path when a bpf prog is attached to a cgroup, and unset
> > > > it when the bpf prog is detached.
> > > >
> > > > Below is the result after this change,
> > > > $ cat progs.debug
> > > >   id name             attached
> > > >    5 dump_bpf_map     bpf_iter_bpf_map
> > > >    7 dump_bpf_prog    bpf_iter_bpf_prog
> > > >   17 bpf_sockmap      cgroup:/
> > > >   19 bpf_redir_proxy
> > > >
> > > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > > ---
> > > >  kernel/bpf/cgroup.c | 8 ++++++++
> > > >  1 file changed, 8 insertions(+)
> > > >
> > > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > > index 43eb3501721b..ebd87e54f2d0 100644
> > > > --- a/kernel/bpf/cgroup.c
> > > > +++ b/kernel/bpf/cgroup.c
> > > > @@ -440,6 +440,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> > > >         struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> > > >         struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
> > > >         enum cgroup_bpf_attach_type atype;
> > > > +       char cgrp_path[64] = "cgroup:";
> > > >         struct bpf_prog_list *pl;
> > > >         struct list_head *progs;
> > > >         int err;
> > > > @@ -508,6 +509,11 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> > > >         else
> > > >                 static_branch_inc(&cgroup_bpf_enabled_key[atype]);
> > > >         bpf_cgroup_storages_link(new_storage, cgrp, type);
> > > > +
> > > > +       cgroup_name(cgrp, cgrp_path + strlen("cgroup:"), 64);
> > > > +       cgrp_path[63] = '\0';
> > > > +       prog->aux->attach_name = kstrdup(cgrp_path, GFP_KERNEL);
> > > > +
> > >
> > > This is pure debug code. We cannot have it in the kernel.
> > > Not even under #ifdef.
> > >
> > > Please do such debug code on a side as your own bpf program.
> > > For example by kprobe-ing in this function and keeping the path
> > > in a bpf map or send it to user space via ringbuf.
> > > Or enable cgroup tracepoint and monitor cgroup_mkdir with full path.
> > > Record it in user space or in bpf map, etc.
> > >
> >
> > It is another possible solution to  hook the related kernel functions
> > or tracepoints, but it may be a little complicated to track all the
> > bpf attach types, for example we also want to track
> > BPF_PROG_TYPE_SK_MSG[1], BPF_PROG_TYPE_FLOW_DISSECTOR and etc.
> > While the attach_name provides us a generic way to get how the bpf
> > progs are attached, which can't be got by bpftool.
>
> bpftool can certainly print such details.
> See how it's using task_file iterator.
> It can be extended to look into cgroups and sockmap,
> and for each program print "sockmap:%d", map->id if so desired.

Thanks for the explanation. I will analyze it.

-- 
Thanks
Yafang
