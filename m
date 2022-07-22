Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1F657DF40
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbiGVJpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 05:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236651AbiGVJpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:45:32 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3160019C35;
        Fri, 22 Jul 2022 02:40:27 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id l24so3236306ion.13;
        Fri, 22 Jul 2022 02:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2ZhwYm25g5CUkNBLcvv47aLz+4/ztjZyFmhgjwxgSH8=;
        b=hbC65ZHTAQWOQsXUQifcWGbtkJsuRLl7DcB59re3ce8fQNNydIKrAY2SkSNesa11RL
         taLpvGsCF4iN67ExVmdhdbCS2gcvN9ggatTq/Nupj5b9+nCCQQwnBsf8KovjNusjtS9m
         ZGxwNKEMmykyKODe39zhzs0ldXjcZKeRdbQ4ACMPw/usPYPZXVhmGIhEP/2IUAqoKzCd
         18wQtYNALRMJ70ij9CRKUbeu5IQ3RrENPwZ6dsBiAHZaXyqgoLkASTDtPCmmZFHE+/Ou
         i496RXeW1IuZqVPsTdKyXmhyNMiZSn+wo9O5fzMLDHmaE0YKasXBjHNhS4tXEtNDdNfx
         jJDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2ZhwYm25g5CUkNBLcvv47aLz+4/ztjZyFmhgjwxgSH8=;
        b=1HyGU3taZ2+jsw5BqttFTVoA2viPPiuXfT7kP1L5b3PKDrF0aUF8QpANvPNDqXGNqc
         LjZsrpzdWQKWuG7R0FoMhQYnXNN3qqLB11JKxmUrmyC3L58ZKpQcVq3Qhhuey2+jF+1v
         ZE4x7MjLNnlw3WdFtuvsZ2QKmM1tRTi4QAd0h/cRJGyLb7yEXpI+ie397uUlUOPTLjed
         Tnj4tnLPBSKDwaZJbExB6LP2raRQM5MxL+PukoDvlHXzeRFW7OYwu7qQayVvRjW4hJs5
         dAgMhg+Roe6RE1qpXqHLUjyG+/1H/pa/F+zLDjFaZ/Orgjo3JYxW7GCOgH3+uXxhts2Q
         tD0w==
X-Gm-Message-State: AJIora8eoxWdZQ6IP8AoR/uXT1xR00K+0AhwKMR579+OhJzKTQpId6Vg
        lCs9w9aVqR5knfM536APAyilJxOmidFTf1xgH82DYrP46ds=
X-Google-Smtp-Source: AGRyM1vp2xc7CkDZF0d5lMKrF+CNrmT/HYLDQYfKsnTmOqamAvk7zjl4QRP/pGgVTLbNo5OQL3QcbS6dA6wi/1ltvfs=
X-Received: by 2002:a02:c4c3:0:b0:33f:4fb4:834b with SMTP id
 h3-20020a02c4c3000000b0033f4fb4834bmr1157685jaj.231.1658482826547; Fri, 22
 Jul 2022 02:40:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220721134245.2450-1-memxor@gmail.com> <20220721134245.2450-8-memxor@gmail.com>
 <YtpnmI1oPOQRv3j3@salvia>
In-Reply-To: <YtpnmI1oPOQRv3j3@salvia>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Fri, 22 Jul 2022 11:39:49 +0200
Message-ID: <CAP01T75r6OQffvq8u3e4Srj6c1vsN_NP0PohWikYPUbdp1nDXQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 07/13] net: netfilter: Add kfuncs to allocate
 and insert CT
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     bpf@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jul 2022 at 11:02, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hi,
>
> On Thu, Jul 21, 2022 at 03:42:39PM +0200, Kumar Kartikeya Dwivedi wrote:
> > diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
> > index 37866c8386e2..83a60c684e6c 100644
> > --- a/include/net/netfilter/nf_conntrack_core.h
> > +++ b/include/net/netfilter/nf_conntrack_core.h
> > @@ -84,4 +84,19 @@ void nf_conntrack_lock(spinlock_t *lock);
> >
> >  extern spinlock_t nf_conntrack_expect_lock;
> >
> > +/* ctnetlink code shared by both ctnetlink and nf_conntrack_bpf */
> > +
> > +#if (IS_BUILTIN(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) || \
> > +    (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES) || \
> > +    IS_ENABLED(CONFIG_NF_CT_NETLINK))
>
> There must be a better way to do this without ifdef pollution?
>
> Could you fix this?

I can just remove the ifdefs completely. The first part of the ifdef
is the correct way to detect BPF support for nf_conntrack, the second
is for ct netlink. These are the only two users. But it's not a lot of
code, so until it grows too much we can compile it unconditionally.

Or do you have anything else in mind (like defining a macro for the
bpf one and making the ifdef look less ugly)?
