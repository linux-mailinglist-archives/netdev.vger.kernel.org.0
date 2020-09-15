Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1137926A177
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 11:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgIOJD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 05:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726235AbgIOJDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 05:03:54 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147E7C061788
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 02:03:54 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id n2so3068864oij.1
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 02:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mm/1UKbWk+GC/dY9nlJifC6FZELzw5z1lKhzNUFazcM=;
        b=n6kuWT8C1/HMtu7Q1QuBoo5+mPVNL4puJTfD60HhqIIQKq5En4p/fWRY7+hBL4ltaQ
         engFmEv8UMbGiW4bfZ6PedO+0RMtm5cK3qZRJueLOXsDxRqtQNmrmUou1Lvzuiiw06pg
         p45wUI/0xjTzZdSwGcy0NJz6c12MI5NJ+nu0Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mm/1UKbWk+GC/dY9nlJifC6FZELzw5z1lKhzNUFazcM=;
        b=LncEpsDJUsqAGRqq0WloUoPR8vP/Wn/vsQ1X7BRtIpZFOg8F+LTrsUKk3QJzl6pv4l
         vuWFv+OvtdYbG8B8WTcEser1Aeg0iVmxuR6TRjwNOPk+YAw9YB1jmasfIgirm3lMrDv7
         g8pXNduTCRn3YsDYJiuHKXN8aPJKppNXexa+RVXowhiwg4X7yE0oI6CJGWZ+VAd30rhW
         sNXYMRf+EzAHEspCic/3fpcfWmshfcbvu2NKOT8boKtUc6DElwPrNa//QkwmVYMUpzL8
         ORj5tm3bFVrpsURxXwCkY0kpjeVwT0B/LWGnBhkiSX5tiHL+X4ziGJCkpdI4S2hDI2Er
         ch4g==
X-Gm-Message-State: AOAM530fBWSAWeGO569YWmh894b1zSnQonq8psHN7OQtzs4BCUHt3srR
        QzvuFxt+1IV9KSPD1U6W0Y/IIlu3FmXXHB0ibSMxsQ==
X-Google-Smtp-Source: ABdhPJzkhQtauJa2JpTzh0DAUN3R/bkuJea0/KqcGaQqZGebfz44V1XGv+jqBqMc/CO6K8MeXuG2Na3Hr2OYYoN30gU=
X-Received: by 2002:aca:3087:: with SMTP id w129mr2475218oiw.102.1600160632809;
 Tue, 15 Sep 2020 02:03:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200912045917.2992578-1-kafai@fb.com> <20200912045930.2993219-1-kafai@fb.com>
 <CACAyw9-rirpChioEaSKiYC5+fLGzL38OawcBvE8Mv+16vNApZA@mail.gmail.com> <20200914194304.4ccb6n5sdcfkzxcp@kafai-mbp>
In-Reply-To: <20200914194304.4ccb6n5sdcfkzxcp@kafai-mbp>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 15 Sep 2020 10:03:41 +0100
Message-ID: <CACAyw98xzFf-j8dy45U+90Y5FiPEvb9w7GS5UrQCnxWaZGAZUw@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 2/2] bpf: Enable bpf_skc_to_* sock casting
 helper to networking prog type
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 at 20:43, Martin KaFai Lau <kafai@fb.com> wrote:
[...]
>
> For other ARG_PTR_TO_SOCK_COMMON helpers, they are not available to
> the tracing prog type.  Hence, they are fine to accept PTR_TO_BTF_ID
> as ARG_PTR_TO_SOCK_COMMON since the only way for non tracing prog to
> get a PTR_TO_BTF_ID is from casting helpers bpf_skc_to_* and
> the NULL check on return value must be done first.  If these
> ARG_PTR_TO_* helpers were ever made available to tracing prog,
> it might be better off to have another func_proto taking
> ARG_PTR_TO_BTF_ID instead.

I think such special cases increase the maintenance burden going
forward, I'd prefer it if we had one set of rules that applies to all
program types.

> For the verifier, I think the PTR_TO_BTF_ID should only be accepted
> as ARG_TO_* for non tracing program. That means the bpf_skc_to_*
> proto has to be duplicated to take ARG_PTR_TO_SOCK_COMMON.  I think
> that may be cleaner going forward.  Then the verifier does not need
> to worry about how to deal with what btf_id can be taken as fullsock
> ARG_PTR_TO_SOCKET.  The helper taking ARG_PTR_TO_BTF_ID will decide
> where it could be called from and see how it wants to treat
> "struct sock *sk".

So basically, we allow function prototypes to be specialised according
to context type?

> For example, the sk_storage_get_btf_proto
> is taking &btf_sock_ids[BTF_SOCK_TYPE_SOCK] and is only used from
> the LSM context that is holding a fullsock.

That is a tempting simplification, but it makes future extensions of
LSM context harder. Also, how could we enforce that we only have
fullsocks in LSM? By looking at the list of helpers? I worry that this
is very brittle.

>
> The same goes for the sock_map iter, how about the map_update
> and map_lookup use a ARG_PTR_TO_BTF_ID and PTR_TO_BTF_ID instead?
> For other prog types, they can keep using ARG_PTR_TO_SOCKET and
> PTR_TO_SOCKET.

Yeah, I've thought about that approach as well. The upside is that
it's a much more limited change, and therefore I know that it is
fairly safe to do. It relies on maps being able to override the
"common" map_lookup_elem function proto, which is something we already
do for sockmap and which could use some cleaning up. So if
PTR_TO_BTF_ID aliasing with ARG_PTR_TO_SOCK_COMMON doesn't work out
I'll propose this.

The downside of specialised function protos is that we'll have to do
it for every helper, context type, etc. To me it sounds like we want
to use BTF to define context objects going forward as much as
possible, so having a general solution to unify socket helpers across
old-style and BTF contexts seems really useful to me. If we introduce
ARG_PTR_TO_SOCK_COMMON_OR_NULL we can do this in a gradual way, by
changing helpers that we want to be cross-compatible to take the new
arg type and adding a few NULL and fullsock checks here and there.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
