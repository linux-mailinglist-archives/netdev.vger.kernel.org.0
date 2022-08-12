Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56670591197
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 15:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238956AbiHLNed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 09:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238953AbiHLNec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 09:34:32 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8839C511
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 06:34:31 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id z7so739421qki.11
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 06:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=uJCSi0OQW9I3ISzAY75soewss9LBNsDq6w7dpLeQXwY=;
        b=nicbD3G8xzAHaIBZcfY/X4z1z0NwEKT8RowMgC71wliBRsD7mprbZ/CqKrgPraotbs
         W1UNghuSouE4o69lViS9qFNIGXLaysu65hjm7PGU/V9V6uyCGLzCBlFE3XQJpvxwT5bQ
         I7WeSHDEweR6otUcQXaCfGlOWpUJema9FPSHUbvB4CvtsJdFStIwWaT5Un/y7ckWfyK7
         gs7M9Il13c9JkdaoM2wQl3nOwvX5i7Bpg+974iYOSwi2Yie/kVn2FBV0bAhOsl8GClRC
         RWmiPR77LSCWA9k2BnSTKoDdAUeQMYZaOeoTcD2FNg8POkki6ZU4sRIXdlofC/wH5xOH
         Zbww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=uJCSi0OQW9I3ISzAY75soewss9LBNsDq6w7dpLeQXwY=;
        b=3epC/irlf8ukfZM8N2CuNWgU+YukHFxPBLYaqexx5Z6kUbHc5CyeMdc2Kqk3Fb/5zs
         QIwcUNJbJILQpHg6y4Jf1gAUdqEgBeZ8zJhh/36HJ+Ue735EUjraWrvK8Oh9rmYRSQwD
         alJQo3WP79GUpPjybUJ7u9SNv3VmnWTbv8rWMVzTrnyfqcFmaINGypbCZ+5NgBPjt7SP
         wXuAw2DsEuhijvMR087cDDZmkWjAVzyarcB5BgZyxPEI87ucLGIyqrdmBuRpbho2uUtt
         2KMrQ+I8gFwmZDhOUmtNvqlU0R/A8vAz8p/g9UGRR3Pkdid9RY6zTuUb+Dp5olgzvu38
         8D2A==
X-Gm-Message-State: ACgBeo3WUNPdDX5tMfI7o8xc+AkTqfRJLp8/JgQI7aCByj34VauGW/p7
        Lz3n3BN+UgzaqjNomMdQxpicgFTQ9vTKTEctkNBSKA==
X-Google-Smtp-Source: AA6agR49lRsp3GcyZPCehkQN4oZqTcuBFgM6O2Zv/Uhml2Xh6BvJOfE6bqNC1q2ckVCY0jqcuS11D0fph6w/exm3qSc=
X-Received: by 2002:a05:620a:25d4:b0:6ab:8b17:3724 with SMTP id
 y20-20020a05620a25d400b006ab8b173724mr2890086qko.395.1660311270199; Fri, 12
 Aug 2022 06:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220428142109.38726-2-pablo@netfilter.org> <165116521266.24173.17359123747982099697.git-patchwork-notify@kernel.org>
In-Reply-To: <165116521266.24173.17359123747982099697.git-patchwork-notify@kernel.org>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 12 Aug 2022 09:34:14 -0400
Message-ID: <CADVnQykD5NRcjmrbP9bgNaVuhpOaSiC1dxCOF03bL5nTo2HP7g@mail.gmail.com>
Subject: Re: [PATCH net 1/3] netfilter: nf_conntrack_tcp: re-init for syn
 packets only
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 1:00 PM <patchwork-bot+netdevbpf@kernel.org> wrote:
>
> Hello:
>
> This series was applied to netdev/net.git (master)
> by Pablo Neira Ayuso <pablo@netfilter.org>:
>
> On Thu, 28 Apr 2022 16:21:07 +0200 you wrote:
> > From: Florian Westphal <fw@strlen.de>
> >
> > Jaco Kroon reported tcp problems that Eric Dumazet and Neal Cardwell
> > pinpointed to nf_conntrack tcp_in_window() bug.
> >
> > tcp trace shows following sequence:
> >
> > [...]
>
> Here is the summary with links:
>   - [net,1/3] netfilter: nf_conntrack_tcp: re-init for syn packets only
>     https://git.kernel.org/netdev/net/c/c7aab4f17021
>   - [net,2/3] netfilter: conntrack: fix udp offload timeout sysctl
>     https://git.kernel.org/netdev/net/c/626873c446f7
>   - [net,3/3] netfilter: nft_socket: only do sk lookups when indev is available
>     https://git.kernel.org/netdev/net/c/743b83f15d40
>
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html

This first commit is an important bug fix for a serious bug that causes
TCP connection hangs for users of TCP fast open and nf_conntrack:

  c7aab4f17021b netfilter: nf_conntrack_tcp: re-init for syn packets only

We are continuing to get reports about the bug that this commit fixes.

It seems this fix was only backported to v5.17 stable release, and not further,
due to a cherry-pick conflict, because this fix implicitly depends on a
slightly earlier v5.17 fix in the same spot:

  82b72cb94666 netfilter: conntrack: re-init state for retransmitted syn-ack

I manually verified that the fix c7aab4f17021b can be cleanly cherry-picked
into the oldest (v4.9.325) and newest (v5.15.60) longterm release kernels as
long as we first cherry-pick that related fix that it implicitly depends on:

82b72cb94666b3dbd7152bb9f441b068af7a921b
netfilter: conntrack: re-init state for retransmitted syn-ack

c7aab4f17021b636a0ee75bcf28e06fb7c94ab48
netfilter: nf_conntrack_tcp: re-init for syn packets only

So would it be possible to backport both of those fixes with the following
cherry-picks, to all LTS stable releases?

git cherry-pick 82b72cb94666b3dbd7152bb9f441b068af7a921b
git cherry-pick c7aab4f17021b636a0ee75bcf28e06fb7c94ab48

Thanks!

Best Regards,
neal
