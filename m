Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D7B39EA3B
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 01:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhFGXjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 19:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhFGXjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 19:39:22 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A60C061574;
        Mon,  7 Jun 2021 16:37:16 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id b9so27464780ybg.10;
        Mon, 07 Jun 2021 16:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wDdBxhsWoyGD8+dCvOGyz44V08BvBdHhD/YCsfgxqDQ=;
        b=X7Q/4cjVwu96qWVeIuwzF4Oif+C9CaN4CCCb60odQ4kMUqAK0dOJOkugN3bzwWX5ZV
         iZlaLDdK7GMokgPWJqLNkVRDrCeJ3rSelpECysf/7H4RUdw2U3dFXXbWKwsCu7F0GBVM
         Ay9fLdvAHNmlJye6Egy7RBRATf2CTYU0U9LOoJW4KaIAB+88B3UX9mXuAAPVEXmuz147
         EwIcvYN0vzxMdrlRBfdZU40eFVjOQ3U8yelYU3g7QWPASqA1eoi+QlUYARurlt/lnmZe
         M2OJlwtlrQpU9tYcrr9oNT3n8DtwpNLDCFDT5XlCSiQp8iF0SWdJHIHH3dRczoT+LzfA
         CRAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wDdBxhsWoyGD8+dCvOGyz44V08BvBdHhD/YCsfgxqDQ=;
        b=S+7AnVnmZ/dK16NX2xLRUB+86tVWo9biwoBJvwHFpzQB10lW1W1Ldl04/AVu4ghewP
         VGIuAm5COws7Wzg6/0+lgwktNjGUpy+x79esvLaA7KXVkYZlyt1A7b5Ls3PHgYpm/ugh
         qpjbL3Zw+Zy3YNp9wU1lBJVK2ev3rK3C2uDs5mUsEGytGsby6Pl4ve/eZIQLL8p6Htd8
         anZNy3WAiNAJA01y+96bMvCB36z99C5UbYtGkbvUIcVsU7DvsG+poOfx1dxbKJqRFl/M
         iAH4KT1HNCfVlgndVFtc3ofmGafPZqFlP10RC3Bgqcq4nn9qAiYxgIT+s84US4AcZbiI
         zEFQ==
X-Gm-Message-State: AOAM5307Lf8U1MIILZrnBi6AAvULmxGYgoP1smg2g5Ta0F1OBKyWEeqc
        NXZl++FHoSPU9LQS5+in3NY6l6mOrR+PYLDSwp4=
X-Google-Smtp-Source: ABdhPJxj/F2W0+8UhMEzaBcf4chDw/x7NN921C4WdAgvFaMMjnklf0CJZkQD2dyWwMFx/DrepY59g8Owplu2Axp5rPM=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr25734389ybg.459.1623109035322;
 Mon, 07 Jun 2021 16:37:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210604063116.234316-1-memxor@gmail.com> <20210604063116.234316-7-memxor@gmail.com>
 <20210604180157.2ne6loi6yi2pvikg@ast-mbp.dhcp.thefacebook.com> <20210605045138.7kbnag6e4zjithjm@apollo>
In-Reply-To: <20210605045138.7kbnag6e4zjithjm@apollo>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Jun 2021 16:37:04 -0700
Message-ID: <CAEf4BzZ3Kt0iw1mOjuLL2m0gnrrj0u7znSuacJm3rjv=zZ27eQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 6/7] libbpf: add bpf_link based TC-BPF
 management API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 4, 2021 at 9:52 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> On Fri, Jun 04, 2021 at 11:31:57PM IST, Alexei Starovoitov wrote:
> > On Fri, Jun 04, 2021 at 12:01:15PM +0530, Kumar Kartikeya Dwivedi wrote:
> > > +/* TC bpf_link related API */
> > > +struct bpf_tc_hook;
> > > +
> > > +struct bpf_tc_link_opts {
> > > +   size_t sz;
> > > +   __u32 handle;
> > > +   __u32 priority;
> > > +   __u32 gen_flags;
> > > +   size_t :0;
> > > +};
> >
> > Did you think of a way to share struct bpf_tc_opts with above?
> > Or use bpf_tc_link_opts inside bpf_tc_opts?
>
> A couple of fields in bpf_tc_opts aren't really relevant here (prog_fd, prog_id)
> and will always be unused, so I thought it would be cleaner to give this its own
> opts struct. It still reuses the hook abstraction that was added, though.

Overall probably it will be less confusing to have one _opts struct
across both APIs, even if some of the fields are not used. Just
enforce that they are always NULL (and document in a comment that for
bpf_link-based API it's not expected).

>
> > Some other way?
> > gen_flags here and flags there are the same?
>
> No, it was an oversight that I missed adding gen_flags there, I'll send a patch
> separately with some other assorted things. It's used when offloading to HW.
>
> We don't really support any other flags (e.g. BPF_TC_F_REPLACE) for this.
>
> --
> Kartikeya
