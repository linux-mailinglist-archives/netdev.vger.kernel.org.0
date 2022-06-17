Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF605500F3
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 01:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347032AbiFQXqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 19:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237061AbiFQXqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 19:46:09 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9383B61627
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 16:46:04 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id a10so5996462ioe.9
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 16:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v+CtxF5jqTCvHtrkh/Tp3q/wyDmiOTtwUhSwgsvpJ3w=;
        b=YGI/OqaRkadQXXxsJnM8uGyOtjDZ6+A5GQjelvB1B3X6TwS5V3C66lWgNbx51CvUWU
         XgSrKKU9DJpc5ofYqMNNzNijwDz7Cwd7HiQ1xSTNhmQieX3/tAsb7n8oQTpgU1kOP7hR
         cHflRSYq3M56cSGCoG6//ypA+QjlZMq+AIONrdqck9QbHFG1+PBfZbEXvYZo5NeUnbSj
         g2hATSAaX/qsS7h9BFS3x3XNSS5hMAAPigWi8nUMDnL21PHTh4043HEssgBvTKaaIpeT
         QfdoAN1HGyHbpbC9hbw7N6fugvvOPBStQP9iMGtqvnOAdZsXHLT6VNM8VMy+RtkTDwGO
         LikQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v+CtxF5jqTCvHtrkh/Tp3q/wyDmiOTtwUhSwgsvpJ3w=;
        b=oMgrMm9ToWsMr3unCAaT1KvW87A8ZK/Cay8Q706eP0Tg1yfdctc6CqVqoKGdqhCVPO
         m0Mbb5YLPV5pN4YtW77/Yh2FRUs1uXk0W6HQ4iNLYhWyJtgG8ZgUJY8BPHym5JsSstNz
         xkoF9TMUCVS0c0dwePDgnrrS8oy7/m8d7VDg34hHipFH3wG3jQGGC18kE0wO0jvwb7Zz
         RhelDdWF60b9yXmeELlpnZgAgoQ3w6PnR4p6RStF6NCzTW2vdQJ1fvIluj/6GHZv+jlj
         jSRCbWOB8m8o057jP/+jFrWE7rvAeJZXrNSs10lfmJaSAdCkgLLlC/Rgfb14KfzCQd/U
         A/Qg==
X-Gm-Message-State: AJIora8fJ47xlGSWH31NFPzaBi57xqVHYm6U/uunfvvwryVUdpWZpCJf
        jCyhr6IBr/wfc6ws0pqP7faOMao6ueHGvzqudS9P3w==
X-Google-Smtp-Source: AGRyM1voqSRNK9+66QbW2UwaqOdOzzUm4CcNFzFX9HbLBxFWAOlUpdCA0GV41UPO+AKUQpFtMdRJ0et8XJJ2K7EEugI=
X-Received: by 2002:a02:90ce:0:b0:32e:e2ce:b17c with SMTP id
 c14-20020a0290ce000000b0032ee2ceb17cmr6926427jag.268.1655509563773; Fri, 17
 Jun 2022 16:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220617085435.193319-1-pbl@bestov.io> <165546541315.12170.9716012665055247467.git-patchwork-notify@kernel.org>
In-Reply-To: <165546541315.12170.9716012665055247467.git-patchwork-notify@kernel.org>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Fri, 17 Jun 2022 16:45:52 -0700
Message-ID: <CANP3RGcMqXH2+g1=40zwpzbpDORjDpyo4cVYZWS_tfVR8A_6CQ@mail.gmail.com>
Subject: Re: [PATCH v2] ipv4: ping: fix bind address validity check
To:     patchwork-bot+netdevbpf@kernel.org, stable@vger.kernel.org
Cc:     Riccardo Paolo Bestetti <pbl@bestov.io>,
        Carlos Llamas <cmllamas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel-team@android.com,
        Kernel hackers <linux-kernel@vger.kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 4:30 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
>
> Hello:
>
> This patch was applied to netdev/net.git (master)
> by David S. Miller <davem@davemloft.net>:
>
> On Fri, 17 Jun 2022 10:54:35 +0200 you wrote:
> > Commit 8ff978b8b222 ("ipv4/raw: support binding to nonlocal addresses")
> > introduced a helper function to fold duplicated validity checks of bind
> > addresses into inet_addr_valid_or_nonlocal(). However, this caused an
> > unintended regression in ping_check_bind_addr(), which previously would
> > reject binding to multicast and broadcast addresses, but now these are
> > both incorrectly allowed as reported in [1].
> >
> > [...]
>
> Here is the summary with links:
>   - [v2] ipv4: ping: fix bind address validity check
>     https://git.kernel.org/netdev/net/c/b4a028c4d031
>
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html

I believe this [
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=b4a028c4d031
] needs to end up in 5.17+ LTS (though I guess 5.17 is eol, so
probably just 5.18)
