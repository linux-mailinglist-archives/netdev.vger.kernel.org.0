Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C129945816E
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 02:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237562AbhKUBtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 20:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237560AbhKUBtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 20:49:13 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF09C061574
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 17:46:08 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id bu18so62574505lfb.0
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 17:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eC7ekTcNVcHToA7WbyMk8TOSIabpI8giHuuCFWYBVHY=;
        b=ZLaZpQncZZfoAiI8KH3Z6X84qkK27pbn9jZmBbIsmzNChnaRDRQo0/rxwhCbcxMZln
         A/L2fC3hg5lQ74xdjhEWlSJolhWBGICGVuov/cCwGc2IebcpF/pxu6AVPEJByavl2bIu
         THIvhXCAqYYICY3jWybcDAjT8BNkrrR889btRCfUnCXJV6Sgrdh9RrDx6LTeMv7x/PQT
         yXFPCTuFi14AlPH178sBL4sNovZEnFQcEA/yodB32eY6+5Sd11BJeVAg0XvPS5xYnJar
         l56iwSUpsyARR72VnBfO5ZWoqq8P86ZZmkyQ6IKPPTdTb6eLOoRVPm5ylWem6I6R+0AV
         CpAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eC7ekTcNVcHToA7WbyMk8TOSIabpI8giHuuCFWYBVHY=;
        b=3PYJFmygJulR36e8aFW1TzUDLyMSOZwOJ5skhXX2SINIzBPX14+VMCE1W0330aoL+a
         kGXPqqcnNSdSylePswW5aavlyEYTkOKkyM0vDV4Wp6ycnV/eGJ4xT5qLzHIlphM5nYJz
         WDrfGcD+1HAKFbvXh9RXsgE+HHprGhGspNjzN7w3H6MxcB/ROhitp0Quz0ZfIaa5qbs9
         5vwJCQlcHdkwFWtHr/izvPXbnASa3Kv8/Bx8tLn0OjuDcZiS2smRo58Kf3c9TLoRwrfh
         T2+ku5czjuf8YekvWKJpKSFqhV68lc0YAFvPsSuUrCm+8dBUflPuxcy26kFdddHQBn2W
         ORFA==
X-Gm-Message-State: AOAM530bVyVOpBxsnMVvpeNiMlMVlR/8QjMsnvSLdeqAqC7Tv0Y80+4a
        GdFEbjc9bWs9VPLvSCtE2zURJVbHR970+CZn91ajAA==
X-Google-Smtp-Source: ABdhPJxfWi45CRv/695sTqDhdy6mX54xURuW0+JjIkOQYekJSB/icDp4YLBXjbdux+sf1/mczR3mZrREiZtrK5Xe6+E=
X-Received: by 2002:a05:6512:6d1:: with SMTP id u17mr46632225lff.427.1637459166469;
 Sat, 20 Nov 2021 17:46:06 -0800 (PST)
MIME-Version: 1.0
References: <20211119120521.18813-1-vincent.whitchurch@axis.com> <163742160874.26850.6419902452041932137.git-patchwork-notify@kernel.org>
In-Reply-To: <163742160874.26850.6419902452041932137.git-patchwork-notify@kernel.org>
From:   "Jiang Wang ." <jiang.wang@bytedance.com>
Date:   Sat, 20 Nov 2021 17:45:55 -0800
Message-ID: <CAP_N_Z_x9OCvGM4YyimdWLs-n90b=MHg2oVaTsNRo6DsXyQ53g@mail.gmail.com>
Subject: Re: Re: [PATCH] af_unix: fix regression in read after shutdown
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, kernel@axis.com,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the fix.

Regards,

Jiang

On Sat, Nov 20, 2021 at 7:20 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
>
> Hello:
>
> This patch was applied to netdev/net.git (master)
> by David S. Miller <davem@davemloft.net>:
>
> On Fri, 19 Nov 2021 13:05:21 +0100 you wrote:
> > On kernels before v5.15, calling read() on a unix socket after
> > shutdown(SHUT_RD) or shutdown(SHUT_RDWR) would return the data
> > previously written or EOF.  But now, while read() after
> > shutdown(SHUT_RD) still behaves the same way, read() after
> > shutdown(SHUT_RDWR) always fails with -EINVAL.
> >
> > This behaviour change was apparently inadvertently introduced as part of
> > a bug fix for a different regression caused by the commit adding sockmap
> > support to af_unix, commit 94531cfcbe79c359 ("af_unix: Add
> > unix_stream_proto for sockmap").  Those commits, for unclear reasons,
> > started setting the socket state to TCP_CLOSE on shutdown(SHUT_RDWR),
> > while this state change had previously only been done in
> > unix_release_sock().
> >
> > [...]
>
> Here is the summary with links:
>   - af_unix: fix regression in read after shutdown
>     https://git.kernel.org/netdev/net/c/f9390b249c90
>
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
>
>
