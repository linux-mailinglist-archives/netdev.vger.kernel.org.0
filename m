Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA28D1F80C4
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 05:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgFMDun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 23:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgFMDun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 23:50:43 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA708C03E96F;
        Fri, 12 Jun 2020 20:50:41 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id g12so4531369pll.10;
        Fri, 12 Jun 2020 20:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0/P1ZKzk+L/46guAFv9xRPTp6fM6GL0Bl4FlXxMzOeA=;
        b=PtwVycoOq4K2x6XW/uv7Hdv5nkelJdkJUc8siFpb+DWu+jppqQkUEeEDncoKATi9uI
         jBtf5ksSND6fehA6zG/NKZ20X9uWHcamPYN+cJbbkv9ts6anJPvO1K19gi4U4vlxwe8t
         mjf5AAMmew66rMkrPPEyqmDJqLrFjqb78OCI8yWpu0wzTAIL8Kj1Fmy6RAxtwd+XMtF5
         g5/CLLqDwJOZG5TAanA24JxkefVBAqItwnUoqTGdy33fk7JWodD/Mu4WRuXIPobszrT8
         HZEZFZGZPol3YbOr6KXbHe16IGAUjPMKSeVvHC5BLav0CAY4ifMQdjr6NSgG0g7wBFHI
         NWew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0/P1ZKzk+L/46guAFv9xRPTp6fM6GL0Bl4FlXxMzOeA=;
        b=FuiZevt6bO+TKEEoNiHVnaGtYoVUQrjtB8XAseRctFaUO2kYBYqstePxmmNxJ3itWk
         VSM8yfyQzMKJXjedXNg64EuVpjGvegfRU40egRMf4rUE2o6LB2MOJ0hpNPQmymOO0kSV
         T0u7BJWcDwarMAE7OCW0Q8n6hor2lhGcI50dYQEnRMQf9js6vSvta54vsEsbDPls2UaQ
         5obCysgmm7xhKxjpO0FV2rCfGfAxWkC/r5qM8YxmhspPuRUV44tViFAmh2jxqVrNjgJn
         2qhCkFMlell3eHXpewJLVsLvCkMhmT0Ts9GBXCiETtJwp1fOtAjHPIkgb/cMwWnWgOqV
         ythA==
X-Gm-Message-State: AOAM530hhBgs6EkT5+Go3bOlYwvsp5tyodj+QmZpymIPmzHuGqLXjHvq
        HAiDDTr/NlJzoMb27vP9qZE=
X-Google-Smtp-Source: ABdhPJz8MU/ErnveXCkuB5G1ZTMNZbwmYXdYFuZlyVTlccjJyNXcVbt1yJU5TdeAAdNgKaHN3vkUXw==
X-Received: by 2002:a17:90a:1781:: with SMTP id q1mr2023649pja.8.1592020241139;
        Fri, 12 Jun 2020 20:50:41 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:9709])
        by smtp.gmail.com with ESMTPSA id p31sm6639945pgb.46.2020.06.12.20.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 20:50:40 -0700 (PDT)
Date:   Fri, 12 Jun 2020 20:50:38 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH bpf v3 1/2] bpf: don't return EINVAL from
 {get,set}sockopt when optlen > PAGE_SIZE
Message-ID: <20200613035038.qmoxtf5mn3g3aiqe@ast-mbp>
References: <20200608182748.6998-1-sdf@google.com>
 <20200613003356.sqp6zn3lnh4qeqyl@ast-mbp.dhcp.thefacebook.com>
 <CAKH8qBuJpks_ny-8MDzzZ5axobn=35P3krVbyz2mtBBtR8Uv+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBuJpks_ny-8MDzzZ5axobn=35P3krVbyz2mtBBtR8Uv+A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 06:03:03PM -0700, Stanislav Fomichev wrote:
> On Fri, Jun 12, 2020 at 5:34 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Jun 08, 2020 at 11:27:47AM -0700, Stanislav Fomichev wrote:
> > > Attaching to these hooks can break iptables because its optval is
> > > usually quite big, or at least bigger than the current PAGE_SIZE limit.
> > > David also mentioned some SCTP options can be big (around 256k).
> > >
> > > There are two possible ways to fix it:
> > > 1. Increase the limit to match iptables max optval. There is, however,
> > >    no clear upper limit. Technically, iptables can accept up to
> > >    512M of data (not sure how practical it is though).
> > >
> > > 2. Bypass the value (don't expose to BPF) if it's too big and trigger
> > >    BPF only with level/optname so BPF can still decide whether
> > >    to allow/deny big sockopts.
> > >
> > > The initial attempt was implemented using strategy #1. Due to
> > > listed shortcomings, let's switch to strategy #2. When there is
> > > legitimate a real use-case for iptables/SCTP, we can consider increasing
> > > the PAGE_SIZE limit.
> > >
> > > v3:
> > > * don't increase the limit, bypass the argument
> > >
> > > v2:
> > > * proper comments formatting (Jakub Kicinski)
> > >
> > > Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
> > > Cc: David Laight <David.Laight@ACULAB.COM>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  kernel/bpf/cgroup.c | 18 ++++++++++++++----
> > >  1 file changed, 14 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > > index fdf7836750a3..758082853086 100644
> > > --- a/kernel/bpf/cgroup.c
> > > +++ b/kernel/bpf/cgroup.c
> > > @@ -1276,9 +1276,18 @@ static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
> > >
> > >  static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen)
> > >  {
> > > -     if (unlikely(max_optlen > PAGE_SIZE) || max_optlen < 0)
> > > +     if (unlikely(max_optlen < 0))
> > >               return -EINVAL;
> > >
> > > +     if (unlikely(max_optlen > PAGE_SIZE)) {
> > > +             /* We don't expose optvals that are greater than PAGE_SIZE
> > > +              * to the BPF program.
> > > +              */
> > > +             ctx->optval = NULL;
> > > +             ctx->optval_end = NULL;
> > > +             return 0;
> > > +     }
> >
> > It's probably ok, but makes me uneasy about verifier consequences.
> > ctx->optval is PTR_TO_PACKET and it's a valid pointer from verifier pov.
> > Do we have cases already where PTR_TO_PACKET == PTR_TO_PACKET_END ?
> > I don't think we have such tests. I guess bpf prog won't be able to read
> > anything and nothing will crash, but having PTR_TO_PACKET that is
> > actually NULL would be an odd special case to keep in mind for everyone
> > who will work on the verifier from now on.
> >
> > Also consider bpf prog that simply reads something small like 4 bytes.
> > IP_FREEBIND sockopt (like your selftest in the patch 2) will have
> > those 4 bytes, so it's natural for the prog to assume that it can read it.
> > It will have
> > p = ctx->optval;
> > if (p + 4 > ctx->optval_end)
> >  /* goto out and don't bother logging, since that never happens */
> > *(u32*)p;
> >
> > but 'clever' user space would pass long optlen and prog suddenly
> > 'not seeing' the sockopt. It didn't crash, but debugging would be
> > surprising.
> >
> > I feel it's better to copy the first 4k and let the program see it.
> Agreed with the IP_FREEBIND example wrt observability, however it's
> not clear what to do with the cropped buffer if the bpf program
> modifies it.
> 
> Consider that huge iptables setsockopts where the usespace passes
> PAGE_SIZE*10 optlen with real data and bpf prog sees only part of it.
> Now, if the bpf program modifies the buffer (say, flips some byte), we
> are back to square one. We either have to silently discard that buffer
> or reallocate/merge. My reasoning with data == NULL, is that at least
> there is a clear signal that the program can't access the data (and
> can look at optlen to see if the original buffer is indeed non-zero
> and maybe deny such requests?).
> At this point I'm really starting to think that maybe we should just
> vmalloc everything that is >PAGE_SIZE and add a sysclt to limit an
> upper bound :-/
> I'll try to think about this a bit more over the weekend.

Yeah. Tough choices.
We can also detect in the verifier whether program accessed ctx->optval
and skip alloc/copy if program didn't touch it, but I suspect in most
case the program would want to read it.
I think vmallocing what optlen said is DoS-able. It's better to
stick with single page.
Let's keep brainstorming.
