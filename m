Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7460653F234
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 00:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbiFFWqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 18:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbiFFWqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 18:46:32 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB2E2AC5
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 15:46:31 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gc3-20020a17090b310300b001e33092c737so13808493pjb.3
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 15:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eoK4z3j+4VVgoiwHq8CGdLVxmgUiRltw8RLHmMxieoQ=;
        b=A6X6BV9S6OlUufC2bnRxhV77QZulQqXTAkY/jXL8fdPK182fdoOukMyqFtfhis3Iwa
         wEOEPHoVTgDqOsJ0eIHuDgwrOLezzpfrFaDeEJ1qtzv+hZSec58wb7rFfVD4A5TBIbbq
         zoki1JZdz0PlzQU1guP26Y4cd3XIufqTHZ4RMo1EV/WM4qNYnj3o/5/+6ElxgZpOJF7o
         gD8w3RrJooHh06XT1o6VyzMcFuGZUZj4Hofc15DIz4YxqFPhNZiXQDrJYCByRJX+LYt8
         g4JQ0VYPyMOhhrlt7Oo5vrTRl+WrcxttBWyae906ihM25T/ZS9vqC2cZCJgGl+wuEPkY
         WMRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eoK4z3j+4VVgoiwHq8CGdLVxmgUiRltw8RLHmMxieoQ=;
        b=WDEzQJn/B/29ptKhxYxHwCW/yMF0cVwp9tWmTC6C1k83v1WJWU0L45clvbz5FnFHAR
         JIbmY6Vk9iY3oq6/V0GK+h4Biu1PyW1v1uod8L1OLAct0yXmkYVgz8667tWQFGLanzEu
         AnXAth7ZVD1IPfF4v34SgvQ4e7WWOtd7by1ZRN7Sr4moIMh61daofbrxBRFABaL+Ybg0
         e3p4ZRjQ9cpF64uFSnmGI1aAUgLc689GRqxNd7qt/h2v/gVEQqhBl3MxSfWf1msFTbbH
         IaOPacmOqOnvg9AcJ4AEEEcpkLJeSC1ZGx2iUN96GCah+Zc0nUXHMkLUET00Mbk3qvdn
         YWaQ==
X-Gm-Message-State: AOAM530XAX+05+rBzZF3vV7HqIW6BmjLf++oMbXmwJjjd4jyfj3yjftN
        NGnwtP1uVJKulEP29oC7GyZ0I4qXp6wj5v9gaV92AA==
X-Google-Smtp-Source: ABdhPJygjgF+GrIBaogKrcRUSo3ekaCL1qskEHLSvtht3vmz35+ndkGGcEbLk2JqBicXN8N1kln5As7HoIqFUaHTK+o=
X-Received: by 2002:a17:90b:380b:b0:1e6:67f6:f70c with SMTP id
 mq11-20020a17090b380b00b001e667f6f70cmr31132737pjb.120.1654555590631; Mon, 06
 Jun 2022 15:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220601190218.2494963-1-sdf@google.com> <20220601190218.2494963-4-sdf@google.com>
 <20220604061154.kefsehmyrnwgxstk@kafai-mbp> <20220604082706.s3r42iwgi7ftiud7@kafai-mbp>
In-Reply-To: <20220604082706.s3r42iwgi7ftiud7@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 6 Jun 2022 15:46:18 -0700
Message-ID: <CAKH8qBs-TYyFt2d7i8JnTTEiQ5Ee37aWiwE3t+31huCDx62+cg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 03/11] bpf: per-cgroup lsm flavor
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 4, 2022 at 1:27 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Jun 03, 2022 at 11:11:58PM -0700, Martin KaFai Lau wrote:
> > > @@ -549,9 +655,15 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> > >     bpf_cgroup_storages_assign(pl->storage, storage);
> > >     cgrp->bpf.flags[atype] = saved_flags;
> > >
> > > +   if (type == BPF_LSM_CGROUP && !old_prog) {
> > hmm... I think this "!old_prog" test should not be here.
> >
> > In allow_multi, old_prog can be NULL but it still needs
> > to bump the shim_link's refcnt by calling
> > bpf_trampoline_link_cgroup_shim().
> >
> > This is a bit tricky.  Does it make sense ?
> I think I read the "!"old_prog upside-down.  I think I got the
> intention here now after reading some latter patches.
> It is to save a bpf_trampoline_link_cgroup_shim() and unlink
> for the replace case ?  I would prefer not to do this.
> It is quite confusing to read and does not save much.

Ok, let me try to drop it!


> > > +           err = bpf_trampoline_link_cgroup_shim(new_prog, &tgt_info, atype);
> > > +           if (err)
> > > +                   goto cleanup;
> > > +   }
> > > +
> > >     err = update_effective_progs(cgrp, atype);
> > >     if (err)
> > > -           goto cleanup;
> > > +           goto cleanup_trampoline;
> > >
> > >     if (old_prog)
> > Then it needs a bpf_trampoline_unlink_cgroup_shim(old_prog) here.
> >
> > >             bpf_prog_put(old_prog);
> > > @@ -560,6 +672,10 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> > >     bpf_cgroup_storages_link(new_storage, cgrp, type);
> > >     return 0;
> > >
> > > +cleanup_trampoline:
> > > +   if (type == BPF_LSM_CGROUP && !old_prog)
> > The "!old_prog" test should also be removed.
> >
> > > +           bpf_trampoline_unlink_cgroup_shim(new_prog);
> > > +
> > >  cleanup:
> > >     if (old_prog) {
> > >             pl->prog = old_prog;
