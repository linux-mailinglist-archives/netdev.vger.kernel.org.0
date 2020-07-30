Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9131F233932
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbgG3TnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgG3TnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:43:23 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0089AC061574;
        Thu, 30 Jul 2020 12:43:22 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id 2so15034685ybr.13;
        Thu, 30 Jul 2020 12:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UjeWPXwiWV8GnGLuFHc4HfFTrfL6j+JmPS3U9PJwGY0=;
        b=pKaKPTqxbXmTPvl91+eIqhnKIjIViOm6NxVU65WSSu+ZLYSo/dOrRv9oxS0N2dXHgO
         TGuYYt74gJ9S9JlLqLzt744ORZFN/KYOind9ey05srYHys2uvYL7ZVMeCr406sv/B1y3
         k10poCgKt/kUnryeEWdvzGcXZavPMDDhymqU3aJV/BTU0yZMM43axJKV3kOi5hmzncgE
         k31hm4RDuRgb7WMtacwDOxhbf+WcMvi41fi1ncHcdxqG9V8A1Yan+W8XAgFRbMo789cv
         AHIF01rdgbWG8RfunuZL0cERCcoBZ2IbDMoixOrIBFb1QVfkPcbGaXUuwaSjEo4+ou58
         cfyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UjeWPXwiWV8GnGLuFHc4HfFTrfL6j+JmPS3U9PJwGY0=;
        b=heu+7kn8PhuXIZ34J03+LuFrJafl5Lq5f3HOWFH3GMhnb5qiyW/b933XBMcOXjf9Hp
         wikklvWa/vxgwqxDtPmY2+mEnD1JiAVTqMUKuYNv0VUf4L9aG4T+ZFVOWbcVT8gQoBsy
         b0w9JcmQYMlTCev14N5eoRYMmYEw1zR6T4gnjF9sLpydgPv6cAiF9NxkF+XEGNGq49nm
         rn1y7Cq6qgwYO4lfwCOrYMdzincSxLOfR4kpKoZIWZc++S8m2P2anu+R0E70OwHZSoak
         WT1TyGpM909R+YSpAGdx1MTWbVH5YAam5cHaDipoBFmox5dPz69UtXPfs1VHgwgtcNwc
         iZOA==
X-Gm-Message-State: AOAM533+M60NCH7Z3NLUCZImtq/gaQr9cK5e7gOJFU11989rTBt2spsr
        vuitvqZVhCfjJGDM2z76A4kyboJPQKjQ0UbN/ss=
X-Google-Smtp-Source: ABdhPJxcmHuR6KUJESSkQAQoK31s7b3Ae03w6dwVHZrdexcgMQ/sDM8YU4D4P5BAi7OB2PlSitiKa81d3W2hX7IkpSA=
X-Received: by 2002:a25:9c44:: with SMTP id x4mr727506ybo.510.1596138202288;
 Thu, 30 Jul 2020 12:43:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200717103536.397595-1-jakub@cloudflare.com> <20200717103536.397595-16-jakub@cloudflare.com>
 <CAEf4BzZHf7838t88Ed3Gzp32UFMq2o2zryL3=hjAL4mELzUC+w@mail.gmail.com>
 <87lfj2wvf4.fsf@cloudflare.com> <87ft99w3lk.fsf@cloudflare.com>
In-Reply-To: <87ft99w3lk.fsf@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 30 Jul 2020 12:43:11 -0700
Message-ID: <CAEf4BzbUEWp+TBjRXaL2XN8GwKYMJPO+PpRJ0uqgh2kOXKvBzg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 15/15] selftests/bpf: Tests for BPF_SK_LOOKUP
 attach point
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 6:10 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Wed, Jul 29, 2020 at 10:57 AM CEST, Jakub Sitnicki wrote:
> > On Tue, Jul 28, 2020 at 10:13 PM CEST, Andrii Nakryiko wrote:
> >
> > [...]
> >
> >> We are getting this failure in Travis CI when syncing libbpf [0]:
> >>
> >> ```
> >> ip: either "local" is duplicate, or "nodad" is garbage
> >>
> >> switch_netns:PASS:unshare 0 nsec
> >>
> >> switch_netns:FAIL:system failed
> >>
> >> (/home/travis/build/libbpf/libbpf/travis-ci/vmtest/bpf-next/tools/testing/selftests/bpf/prog_tests/sk_lookup.c:1310:
> >> errno: No such file or directory) system(ip -6 addr add dev lo
> >> fd00::1/128 nodad)
> >>
> >> #73 sk_lookup:FAIL
> >> ```
> >>
> >>
> >> Can you please help fix it so that it works in a Travis CI environment
> >> as well? For now I disabled sk_lookup selftests altogether. You can
> >> try to repro it locally by forking https://github.com/libbpf/libbpf
> >> and enabling Travis CI for your account. See [1] for the PR that
> >> disabled sk_lookup.
>
> [...]
>
> Once this fix-up finds its way to bpf-next, we will be able to re-enable
> sk_loookup tests:
>
>   https://lore.kernel.org/bpf/20200730125325.1869363-1-jakub@cloudflare.com/
>
> And I now know that I need to test shell commands against BusyBox 'ip'
> command implementation, that libbpf project uses in CI env.


Thanks! I still see some (other) failures, it might be that our
environment is not full enough or something (you also mentioned some
other fix to Daniel, that might help as well, dunno). But your fix is
good nevertheless.
