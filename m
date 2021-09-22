Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8E4414FCD
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237100AbhIVSZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237085AbhIVSZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 14:25:57 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9480BC061574;
        Wed, 22 Sep 2021 11:24:27 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so5125183pjb.2;
        Wed, 22 Sep 2021 11:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZJRpm13cdakrS6Fzw5NR01EAxv/9nnEsgvgZlcSKKX0=;
        b=S3kBYM61iPBSlu5nshOiNUGgOxddc4NP92sDJNq6JKTEoPEk4FB3BuKS6aXN6CU5jr
         OJgceaf31gs/Iv5PF1IsGm5xIuzTb9eMOvF3jHUOHidNVENAkPnmGaDC1WvBMwkL7fdK
         M8Jla9IST1adVOt9VsFJy7pdn/obqgRTW8bV7IAdoZsYWjt3srzFyeROVGybpNrIvubI
         G0Zeqklxzer9V8ALrFw52j+N4QkKrKhSMAETx6NdBqBKSKuTrWS26drTb9hBr+3BSfVR
         PUIURefY2PFyUUFvJU2VDzjlzD3OxTf3BR4SsQ3sKzi7lL/KsbyNylOVubIpX0RVo3Ma
         hJhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZJRpm13cdakrS6Fzw5NR01EAxv/9nnEsgvgZlcSKKX0=;
        b=ABTBNXs53WsTLZkkO5yVDk7tRZAlF/WtwJjyZ5fb7E+egHu61F67jy8r7kq829Fkro
         5Ys8/fozNmBQLBsRUi3chY5WO6U4gphqIPmECDvQ8uqIoaGwtQVMHF3UCo2hehry4pNg
         U+7OypFhlVjwKR0kqvAV4YhcN/kNJ1cUGfURl9DkT/Vi8iTqQ80OuSIiaQytKlQIqPnG
         iA4nXZ9PD3rgjeSjSyWYp17njbLtYagZUOn599xNFlm5GoUGmiWM93ZX7/L4dqb5tewX
         4FkPGvNUtoeLyRH6aT5evKACmQ8IUtgD32z8J26yAnrNapkyslPK+Z/IWEGM+LyRvYfj
         9SLg==
X-Gm-Message-State: AOAM532cWQpSranZ5I2cVKd7j9cAdwgrFJQpaby21aC1zYtkqYM5G6f5
        1iK3sGaiOQ0mJz0Go3IUFQXbmyzJSnb4s2yoGk0=
X-Google-Smtp-Source: ABdhPJywprkFW34mjGk6gCQTpCVTmOoU+79tHfJcwqzLi1lTwFa3OzvLmL99v/+HsfiGIBBdmfT7JCa4bB9fSS/2yTU=
X-Received: by 2002:a17:90b:1c08:: with SMTP id oc8mr488987pjb.138.1632335066962;
 Wed, 22 Sep 2021 11:24:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210920141526.3940002-1-memxor@gmail.com> <20210920141526.3940002-12-memxor@gmail.com>
 <CAEf4Bza5GxHb+=PQUOKWQ=BD3kCCEOYjDLKSdsPRZu468KAePg@mail.gmail.com>
 <20210921231320.pgmbhmh4bjgvxwvp@apollo.localdomain> <CAEf4BzaAjHNoEPFBCmPFQm_vqk_Tj0YYEF8X0ZX9RpmzeeJnhw@mail.gmail.com>
 <20210922060608.fxdaeguiako4oixb@apollo.localdomain>
In-Reply-To: <20210922060608.fxdaeguiako4oixb@apollo.localdomain>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Sep 2021 11:24:15 -0700
Message-ID: <CAADnVQJb_mwxNRBdqaE_E=05V=YVHt5wrxSMigSYRMNvv4LWZg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 11/11] bpf: selftests: Add selftests for
 module kfunc support
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 11:06 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Wed, Sep 22, 2021 at 05:33:26AM IST, Andrii Nakryiko wrote:
> > > [...]
> > > Hmm, good idea, I'd just need to fill in the BTF id dynamically at runtime,
> > > but that should be possible.
> > >
> > > Though we still need to craft distinct calls (I am trying to test the limit
> > > where insn->off is different for each case). Since we try to reuse index in both
> > > gen_loader and libbpf, just generating same call 256 times would not be enough.
> >
> > You just need to generate one instruction with offset = 257 to test
> > this. And separately one call with fd_array that has module BTF fd at
> > fd_array[256] (to check that 256 is ok). Or am I missing something?
> >
>
> That won't be enough, if I just pass insn->imm = id, insn->off = 257, it becomes
> first descriptor in kfunc_tab and kfunc_btf_tab. The total limit is 256, and
> they are kept in sorted order by based on id and off for the first, off for the
> second. So 256 different offs are needed (imm may be same actually), so that
> both fill up.

Just to test the 256 limit? I don't think it's necessary.
afaik there is no test that exercises the 64 map limit.
