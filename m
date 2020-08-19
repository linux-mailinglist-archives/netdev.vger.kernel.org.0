Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB37249275
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgHSBhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgHSBhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 21:37:07 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23344C061389;
        Tue, 18 Aug 2020 18:37:07 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d188so10855570pfd.2;
        Tue, 18 Aug 2020 18:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rTy6HFqlxocYasXQ/q0NDy2ayNYu7hnpMHqjSN3l5hk=;
        b=V5PruPQVi7l6N8wdwlONTCnDsUkLp9FiHTtcykZG6XHisFfwRG/ywmhxbDqYH9bpHv
         BcgpAtbNMg2DsbXmTwbs5tu2KIPAW4l07lS2q5ywMhV2i5NqwiTiSwOTdNRIIBukwwqH
         mdSVjbNemoa4ViORZeRgJKcN6US2T+RNuf/AnNd8ZpnI6xoums9vhw83DI0rA/Y1ZDaL
         XNS8xqF03ogktZwbJJ+htSdecsjl+DNC11yTys5GByy75gsFhJiUfTMLtLhXwT0A13jO
         5uHP9mwHmKb7xGsFFbo9sVYHKt2xZokb1uN72W79CQb8Me4kMWCWz8t1v64gzAJLIuGy
         owDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rTy6HFqlxocYasXQ/q0NDy2ayNYu7hnpMHqjSN3l5hk=;
        b=KksmuKqDJjXeHJbBrkfVJMnroP/eLfrpSd4oRQmFStuGYYHFVhfK3SzMT1mjQKdNpx
         dCekK5sbxzd3r87ehksnuM0Hg/gEnsLrRCFNgjmLAH+Dc+wvccjgwxU6tQi3YezaYJ+8
         WSvFYNAqkS0rceT8hfsBmI8oGnTOmh1E7/2PBDX/eVmNAlPz+LS3zII0ZK0FPXiTE/zB
         EYz8K4/BSMn8Nr6CJ1SFMVZNMUwUqQtpJEv4qL24wYDP1tVGUhZSx24oVotGvR3oBmID
         MUIfnlG2LpWx4h6ZdiK+PLB2d+KBxkHY3TrtYKSUV/mcwL1EB8B8NGpDKsaLgiiZsseE
         6zvw==
X-Gm-Message-State: AOAM53081b1ButwtnCw1yD+JiaxGGLtVC5WhkfDL64SoKEfC4U51vZId
        PL5Fw+wX+hpLkSFxcfGDKmL4fqSCSr0=
X-Google-Smtp-Source: ABdhPJzauZPtzaZRaMEPGLwPBsT3Vqy8zbtX0togxL4EW2r7gUVcsY3HmXYnb+fPzM3dpDs7JqNKQw==
X-Received: by 2002:a65:66c4:: with SMTP id c4mr15815180pgw.442.1597801026581;
        Tue, 18 Aug 2020 18:37:06 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:20fd])
        by smtp.gmail.com with ESMTPSA id 5sm26716805pfw.25.2020.08.18.18.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 18:37:05 -0700 (PDT)
Date:   Tue, 18 Aug 2020 18:37:03 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/9] Add support for type-based and enum
 value-based CO-RE relocations
Message-ID: <20200819013703.cgbty6b6ufp7wuqm@ast-mbp.dhcp.thefacebook.com>
References: <20200818223921.2911963-1-andriin@fb.com>
 <20200819012146.okpmhcqcffoe43sw@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbpJ4M0X2XPEadXPzPM+2cOPf-9QDMp=2qz3VvY+bbqsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbpJ4M0X2XPEadXPzPM+2cOPf-9QDMp=2qz3VvY+bbqsg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 06:31:51PM -0700, Andrii Nakryiko wrote:
> On Tue, Aug 18, 2020 at 6:21 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Aug 18, 2020 at 03:39:12PM -0700, Andrii Nakryiko wrote:
> > > This patch set adds libbpf support to two new classes of CO-RE relocations:
> > > type-based (TYPE_EXISTS/TYPE_SIZE/TYPE_ID_LOCAL/TYPE_ID_TARGET) and enum
> > > value-vased (ENUMVAL_EXISTS/ENUMVAL_VALUE):
> > >
> > > LLVM patches adding these relocation in Clang:
> > >   - __builtin_btf_type_id() ([0], [1], [2]);
> > >   - __builtin_preserve_type_info(), __builtin_preserve_enum_value() ([3], [4]).
> >
> > I've applied patches 1-4, since they're somewhat indepedent of new features in 5+.
> > What should be the process to land the rest?
> > Land llvm first and add to bpf/README.rst that certain llvm commmits are necessary
> > to build the tests?
> 
> Clang patches landed about two weeks ago, so they are already in Clang
> nightly builds. libbpf CI should work fine as it uses clang-12 nightly
> builds.
> 
> 
> > But CI will start failing. We can wait for that to be fixed,
> > but I wonder is there way to detect new clang __builtins automatically in
> > selftests and skip them if clang is too old?
> 
> There is a way to detect built-ins availability (__has_builtin macro,
> [0]) from C code. If we want to do it from Makefile, though, we'd need
> to do feature detection similar to how we did reallocarray and
> libbpf-elf-mmap detection I just removed in the other patch set :).
> Then we'll also need to somehow blacklist tests. Maintaining that
> would be a pain, honestly. So far selftests/bpf assumed the latest
> Clang, though, so do you think we should change that, or you were
> worried that patches hadn't landed yet?

I was hoping that libbpf.h can have builtins unconditionally, but selftests can
do feature detection automatically and mark them as 'skip'.
People have been forever complaining about constant need to upgrade clang.
In this case I think the feature is not fundamental enough (unlike the first
set of builtins) to force adoption of new clang.
If/when we start using these new builtins beyond selftests
that would be a different story.
