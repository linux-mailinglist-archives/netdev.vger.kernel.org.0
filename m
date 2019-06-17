Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 622664922A
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 23:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfFQVO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 17:14:56 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34254 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfFQVO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 17:14:56 -0400
Received: by mail-pl1-f194.google.com with SMTP id i2so4677958plt.1
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 14:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=77Y4YaolfbJc51OiQS7jlCK/dkrVeZ3ZEsMtCUk881o=;
        b=cGi0ptqdqr7nMInLcBDpkkzpn9s1PXv/vq3/A+/NjKNqaCHicp8LxAEsjvp8FyMUSW
         010y2Jtk4OvXiH5Cat6jtA549GZeMQGyyx7GmfX/mVoIZQ4ZpIideK75VT6bDVDMkoLM
         yxOv6W6kphERridyXuo8kSL8MNPACVNxvhYEWK8gjSrybsyrtSK7GHcB2tAkwbX4JmQj
         JXxf9MwGlodFNFVSgp0PPO8aAkhVDeHuv7SFrEZ2tAUq9uZ2tGgrwYGYwHFhaAR01iE6
         Ky/I60CBYdDE6ikwTAOKk/xvKFnjYVWmSGc99niTZ+KQAYlAQigi5wzjL1DyyExADe+k
         eblA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=77Y4YaolfbJc51OiQS7jlCK/dkrVeZ3ZEsMtCUk881o=;
        b=UMVcWooO52IEBxVmdUiBcJQMXyuE6cuXQ/ViZR9kJeRzX6whv/9tZegt+/8teWC89c
         f/B2gmtl2l7qlWGOkdB1/JOSTw2WXJLFYJV5ax+GW66Dm73Io0BgtlY16AX9Hz66n9ag
         8MTtzHKaG67EmLPVmB1KriqzX0Aj/DtxPW6x1RrXUr6QsMz/mRjZR80M1i2RdAI+8N0H
         hyIar3CgAD84SWc2d5RcFvACteVgDo+0NSRCwWBP7FwDrZcMZlYxeT483/YrIt7QdUbO
         1qLncEAkRhQXUo0Ec1+B4iJmNTdUv8v5vX7mlm0r1ipZTYb/oehL/MvI6IBrDJAyTqVs
         N2rQ==
X-Gm-Message-State: APjAAAXeo+Atdv0szeBJGR/Niu2YSTz8bg9ueZozzFv07c/CJObZSCNV
        /K/j0z/LFQ0+Sn5XmKZCL4l9mg==
X-Google-Smtp-Source: APXvYqyOl/TWjxSoWJqDOvtb/N0KpdbnSZzuoGZsB4mbpMjLP25cQcQl8gZcwHVuL/JuyT0hqAKf3Q==
X-Received: by 2002:a17:902:9a84:: with SMTP id w4mr8338998plp.160.1560805679727;
        Mon, 17 Jun 2019 14:07:59 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id c129sm14759479pfa.106.2019.06.17.14.07.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 14:07:58 -0700 (PDT)
Date:   Mon, 17 Jun 2019 14:07:57 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 8/8] selftests/bpf: switch tests to BTF-defined
 map definitions
Message-ID: <20190617210757.GH9636@mini-arch>
References: <20190611044747.44839-1-andriin@fb.com>
 <20190611044747.44839-9-andriin@fb.com>
 <20190614232329.GF9636@mini-arch>
 <CAEf4BzZ5itJ+toa-3Bm3yNxP=CyvNm=CZ5Dg+=nhU=p4CSu=+g@mail.gmail.com>
 <20190615000104.GG9636@mini-arch>
 <CAEf4BzbV-W1KsuN3AuPas_3dG7MVwZO6RsqohS2uvnEf49M67w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbV-W1KsuN3AuPas_3dG7MVwZO6RsqohS2uvnEf49M67w@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/17, Andrii Nakryiko wrote:
> On Fri, Jun 14, 2019 at 5:01 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 06/14, Andrii Nakryiko wrote:
> > > On Fri, Jun 14, 2019 at 4:23 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > > >
> > > > On 06/10, Andrii Nakryiko wrote:
> > > > > Switch test map definition to new BTF-defined format.
> > > > Reiterating my concerns on non-RFC version:
> > > >
> > > > Pretty please, let's not convert everything at once. Let's start
> > > > with stuff that explicitly depends on BTF (spinlocks?).
> > >
> > > How about this approach. I can split last commit into two. One
> > > converting all the stuff that needs BTF (spinlocks, etc). Another part
> > > - everything else. If it's so important for your use case, you'll be
> > > able to just back out my last commit. Or we just don't land last
> > > commit.
> > I can always rollback or do not backport internally; the issue is that
> > it would be much harder to backport any future fixes/extensions to
> > those tests. So splitting in two and not landing the last one is
> > preferable ;-)
> 
> So I just posted v2 and I split all the test conversions into three parts:
> 1. tests that already rely on BTF
> 2. tests w/ custom key/value types
> 3. all the reset
> 
> I think we should definitely apply #1. I think #2 would be nice. And
> we can probably hold off on #3. I'll let Alexei or Daniel decide, but
> it shouldn't be hard for them to do that.
Awesome, thanks!

> > > > One good argument (aside from the one that we'd like to be able to
> > > > run tests internally without BTF for a while): libbpf doesn't
> > > > have any tests as far as I'm aware. If we don't have 'legacy' maps in the
> > > > selftests, libbpf may bit rot.
> > >
> > > I left few legacy maps exactly for that reason. See progs/test_btf_*.c.
> > Damn it, you've destroyed my only good argument.
> 
> Heh :)
> 
> >
> > > > (Andrii, feel free to ignore, since we've already discussed that)
> > > >
> > > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > > ---
> > >
> > >
> > > <snip>
