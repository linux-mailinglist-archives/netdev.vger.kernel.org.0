Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEAC2110C8
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 18:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732361AbgGAQgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 12:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731394AbgGAQgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 12:36:54 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2397C08C5C1;
        Wed,  1 Jul 2020 09:36:53 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id b92so11264611pjc.4;
        Wed, 01 Jul 2020 09:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GgioNzSta8sSjK2l1P/5dr6v68UV138xyv8W1eB/1gY=;
        b=V58Y5n//HCW652zIm/606vN7NhzBHLyRDKhGIc/xUqQezqiMAawldBH7AbpsuNbD7L
         ieU3j0zkzxEKToD+T8zCXhgulCOB/M0Pma6lbBBBnUgcVTSz1Mv92Z/DvbRRicm3aOaT
         n6B1AtyclpiP/ZjsppnLteXfFNqA9uwK8+VgAfubP6zaU2sZxxwtXRSnLnfegE3e5aBS
         0nSpYYxh+Fq+ayrLiGOgPG9AM7MJeZ80vovNLjuwNCX6W+Bnku1CV2n0o2mu5vKLl527
         Vbe6HCxKSIh1Q8tfjBMTd5fXJHdwmsMmmoeU6NlyRyX48LRNf2UGRI78g0r7xaFvg2MX
         /Ngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GgioNzSta8sSjK2l1P/5dr6v68UV138xyv8W1eB/1gY=;
        b=dqScTTL7HyPigq9pNdPpz1IADP5aOCQjKJ2AnpMeT6lnT6goda5Ee0SrgiR/3J7EOo
         PJ8AprYt54Wk4H2ztHpig/twNWIgMhiGsZD1r0RtWLobzkZn1wjwpbTU4Pr54gQYe2ey
         wcJbQH7yhmgEIfwRCw7buRpQokxZsXGqlXXKL8wIumyLF7IVN4E7pzbHk4ADA6CIw+ES
         dj8FHDk0nl6T3ePR4OAEbXBXjxlq29MreAKvygmkp7AIK1sZ2abhM/s+WwlbTQfgLSWv
         7jTH5E/NRi6phmLf2pD6tyWXpRv9dLgMP7Fg9l0JgAn9nOOj5KA6Ta6Bg6B0i7thgO5c
         gFFQ==
X-Gm-Message-State: AOAM532vgZF7D5Wx+HE4TK3ncu2Lt1Kp/XNKjhx0dZHQykAPeE+vlkA2
        nU7VPYJa9Ba9x3EwdWCc80I=
X-Google-Smtp-Source: ABdhPJy+3zrMbkxQP0lAB9c1Mv2U7SWy+vkKt0J4REeA/Z+IDhJFrMwnA4UP8i6s+3ZYUdIV8sejyg==
X-Received: by 2002:a17:90a:1b42:: with SMTP id q60mr5761677pjq.78.1593621413431;
        Wed, 01 Jul 2020 09:36:53 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:7882])
        by smtp.gmail.com with ESMTPSA id y12sm6357791pfm.158.2020.07.01.09.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 09:36:52 -0700 (PDT)
Date:   Wed, 1 Jul 2020 09:36:50 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Anton Protopopov <a.s.protopopov@gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Strip away modifiers from BPF skeleton
 global variables
Message-ID: <20200701163650.qoxr5xgjmz5mpzgn@ast-mbp.dhcp.thefacebook.com>
References: <20200701064527.3158178-1-andriin@fb.com>
 <CAADnVQLGQB9MeOpT0vGpbwV4Ye7j1A9bJVQzF-krWQY_gNfcpA@mail.gmail.com>
 <CAEf4BzbtPBLXU9OKCxeqOKr2WkUHz3P8zO6hD-602htLr21RvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbtPBLXU9OKCxeqOKr2WkUHz3P8zO6hD-602htLr21RvQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 09:08:45AM -0700, Andrii Nakryiko wrote:
> On Wed, Jul 1, 2020 at 8:02 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Jun 30, 2020 at 11:46 PM Andrii Nakryiko <andriin@fb.com> wrote:
> > >
> > > Fix bpftool logic of stripping away const/volatile modifiers for all global
> > > variables during BPF skeleton generation. See patch #1 for details on when
> > > existing logic breaks and why it's important. Support special .strip_mods=true
> > > mode in btf_dump. Add selftests validating that everything works as expected.
> >
> > Why bother with the flag?
> 
> You mean btf_dump should do this always? That's a bit too invasive a
> change, I don't like it.
> 
> > It looks like bugfix to me.
> 
> It can be considered a bug fix for bpftool's skeleton generation, but
> it depends on non-trivial changes in libbpf, which are not bug fix per
> se, so should probably better go through bpf-next.

I'm not following.
Without tweaking opts and introducing new flag the actual fix is only
two hunks in patch 1:

@@ -1045,6 +1050,10 @@ static void btf_dump_emit_type_decl(struct btf_dump *d, __u32 id,

 	stack_start = d->decl_stack_cnt;
 	for (;;) {
+		t = btf__type_by_id(d->btf, id);
+		if (btf_is_mod(t))
+			goto skip_mod;
+
 		err = btf_dump_push_decl_stack_id(d, id);
 		if (err < 0) {
 			/*
@@ -1056,12 +1065,11 @@ static void btf_dump_emit_type_decl(struct btf_dump *d, __u32 id,
 			d->decl_stack_cnt = stack_start;
 			return;
 		}
-
+skip_mod:
 		/* VOID */
 		if (id == 0)
 			break;

-		t = btf__type_by_id(d->btf, id);

