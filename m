Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8792B2A8DAA
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 04:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgKFDnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 22:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgKFDnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 22:43:45 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D97C0613CF;
        Thu,  5 Nov 2020 19:43:44 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id i186so3273144ybc.11;
        Thu, 05 Nov 2020 19:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zEUZiyNVCu2rw4LbzfPUwkyhBxOxP6YhBuH6NllKzoE=;
        b=Z7vYk5Jz7z069QaIxluzENW73T0uPxcpllwXDA+gFuFsxaXsSBYSeJdXslUerzLJ0Y
         bEy/kwoAGfoj5QYz18ETD6Voqca4RHF3xOqzuTEf8bw8gkEB6r4CvjIIe2oHie1h2vhc
         Qfj3FixnX0bZkNdmegFPSJUGCoItjPfI8G4s7gNYd1Np98gt6wO3ZaIw8rZwXEW2EGEE
         m80696A7/Oskiv3dx0H+yYY5tJfECQC+vdymQUIWIWdzmXuEksGOnUWL7jOGMAaQNN3o
         fANE58mVim8aq1cbE6xfZgmVA/fi4a8lR2M32FjsNjfSxruJMV6537etPAm1WoD51HdL
         XTag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zEUZiyNVCu2rw4LbzfPUwkyhBxOxP6YhBuH6NllKzoE=;
        b=opMFBLczvroSLjY9UfFBgRtZn3+nbNPufdHapxjlUGzIj1JlEpv/2SInbzsqeoMxfM
         lNkkpiGWekScuVG/aTTH9uWrj8Pj9FCVLr7Fyi8+SWx5mAdcuWz6kehrwC57u/bITL3k
         4N0IoYDOSZDUPk9zl6ZMhXTrtRmjolJal5KWbabD72NNsIwrrjLM/Sj8R6+CPIpMo6T1
         sOdkg+yZla8gO38rBn0j8ntfvumZzb6y0tpw4MpHgpLZOuv6v7ZbzV0dLImyVZcGXGTE
         Rd7kA2IYToyc+vuG7JUgD6dSwS5SJGCtYtLK+iC7O4BjSPeoZRa/RPF4HglKYAb+K94o
         M18Q==
X-Gm-Message-State: AOAM532cKLxRK2FKUJF6HLPGDqEed0r0t0e8aJzI13z5o33qfpHAFzAX
        plw0xU3wfUhQetzFIdOqMOf7LEk7w2IP/e0LOQ6iFhxYl54=
X-Google-Smtp-Source: ABdhPJwaxI7pPRKe6axg+5lg+HoLRhi6CSCFVvF1tLZmfKCBnZjFJfrjYUaVP/MhIlpxrm1f+0rTt48kfWK5+sypFvM=
X-Received: by 2002:a25:bdc7:: with SMTP id g7mr282234ybk.260.1604634222711;
 Thu, 05 Nov 2020 19:43:42 -0800 (PST)
MIME-Version: 1.0
References: <20201105045140.2589346-1-andrii@kernel.org> <20201105045140.2589346-3-andrii@kernel.org>
 <20201106031914.dugp23xaiwnjbv7g@ast-mbp>
In-Reply-To: <20201106031914.dugp23xaiwnjbv7g@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 5 Nov 2020 19:43:31 -0800
Message-ID: <CAEf4BzbtsaNRJ0pGFFj+yD4NFAzPp3EXp1trabqT+ic1xWajxQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/5] bpf: assign ID to vmlinux BTF and return
 extra info for BTF in GET_OBJ_INFO
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 7:19 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Nov 04, 2020 at 08:51:37PM -0800, Andrii Nakryiko wrote:
> > @@ -215,6 +215,8 @@ struct btf {
> >       struct btf *base_btf;
> >       u32 start_id; /* first type ID in this BTF (0 for base BTF) */
> >       u32 start_str_off; /* first string offset (0 for base BTF) */
> > +     char name[MODULE_NAME_LEN];
> > +     bool kernel_btf;
> >  };
> >
> >  enum verifier_phase {
> > @@ -4441,6 +4443,7 @@ struct btf *btf_parse_vmlinux(void)
> >
> >       btf->data = __start_BTF;
> >       btf->data_size = __stop_BTF - __start_BTF;
> > +     btf->kernel_btf = true;
>
> imo it's a bit weird for vmlinux's BTF to be flagged as 'kernel_btf'
> and empty name, but kernel module's BTFs will not be marked as kernel,
> but will have a name.

module's BTF also has kernel_btf = true, see patch 4; would be weird otherwise

> I think it's more natural to make vmlinux and module's BTF with kernel_btf=true flag
> and give "vmlinux" name to base kernel BTF.

Yeah, I was wondering if I should name vmlinux BTF as "vmlinux"
explicitly, for whatever reason I decided to go with an empty name.
But I think it's not a bad idea to give it an explicit "vmlinux" name.
I'll do that in the next version. Will make bpftool logic more
straightforward as well.


> If somebody creates a kernel module with "vmlinux" name we will have a conflict,
> but that name is for human pretty printing only anyway, so I think it's fine.

yep.
