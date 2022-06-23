Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B599755886C
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 21:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiFWTOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 15:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiFWTNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 15:13:51 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E14E90F91
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 11:18:34 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id h20so8236603ilj.13
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 11:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=51dCcYKeu14QwJ+SbbelFcjxRhDiELAHk8+8A4uJTfo=;
        b=m0kOEMRYsnlrJfJtzN5N5ULzilyZZeMX3vG68SBrvjrPBUSYB0V9raKw0JuYF9dXNL
         j79zt3j5MxDSlRYoDmnB0C0lp9ZLp6YS7kRqcJa4tpzxq0WJNaQcZNjW/dgSnwkYxiB1
         Uxiw4wedDcKn102mfRx3rAI6DCPi38zo1uPouN6/gwbmQTz+xlnR9Pw7BSF9zWMueHEI
         /7KiehO1k+NHvPcWESA9wlatY7jCEhsnf8lmw9+tlU+1YyJbix6JzK+a2J2+vb02zWuZ
         MWALDiVLYYYSqBXesMMy54GVVS2ttvKZRTnympUR1WTgyWvb7WD/lZLN9Sl3xAIdfr9x
         e7sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=51dCcYKeu14QwJ+SbbelFcjxRhDiELAHk8+8A4uJTfo=;
        b=cs22cclPeraL50ppYzjJMOxV3VBEhTtXykaeMIn1tejCjuxUaPCp9w7nCmQb7r1BY9
         VgZC05glfuwwLiIoTx9vOqu/3a8cmQhE7CB1yUDgXDncYZJzDKF+CXO9cQagG1ZpFJ5f
         bjKVqstR6eOnFmQKWNC6I3wcDAtQQhY0vBzLXXnlf8Q2yjGxpVU9HkegyWb25MM944Sn
         usWSVemlGhim2bMT4uSGafpRUrhty97cPSdP4//pEd8gvaKDQ6cibUDVepf5UgY5XVk5
         Ln3qZscW7kErLo7lWBgLQ+WPI4sVpKtr9wfKyPSUDfeYGhYhDrIjbuPLI9laUpovKAxM
         OVWw==
X-Gm-Message-State: AJIora+OUG5OqYtexgZwFqH+dBsgncAPsqAWTcTAeXiwjaF4scq5NQ2a
        0vTTdE2h9pscVAXuMPOKkI6onhYQre143zDQe9f/8Q==
X-Google-Smtp-Source: AGRyM1sSXmovrfX/rEw1li+ovIQDkAHOURPtBbVr8YKIZAKiy+x+aUeVh8iH/80/41PpfW1OBPmd3fWnZ0gynBKIERY=
X-Received: by 2002:a05:6e02:1647:b0:2d9:532c:d799 with SMTP id
 v7-20020a056e02164700b002d9532cd799mr2896083ilu.323.1656008313600; Thu, 23
 Jun 2022 11:18:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220617085435.193319-1-pbl@bestov.io> <165546541315.12170.9716012665055247467.git-patchwork-notify@kernel.org>
 <CANP3RGcMqXH2+g1=40zwpzbpDORjDpyo4cVYZWS_tfVR8A_6CQ@mail.gmail.com> <YrBH1MXZq2/3Z94T@kroah.com>
In-Reply-To: <YrBH1MXZq2/3Z94T@kroah.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Thu, 23 Jun 2022 11:18:21 -0700
Message-ID: <CANP3RGc8tjqk+c=+rAHNON8u=21Uu+kWveuMWZxGCNMjvqRHYg@mail.gmail.com>
Subject: Re: [PATCH v2] ipv4: ping: fix bind address validity check
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     patchwork-bot+netdevbpf@kernel.org, stable@vger.kernel.org,
        Riccardo Paolo Bestetti <pbl@bestov.io>,
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
Content-Transfer-Encoding: quoted-printable
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

On Mon, Jun 20, 2022 at 3:11 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Jun 17, 2022 at 04:45:52PM -0700, Maciej =C5=BBenczykowski wrote:
> > On Fri, Jun 17, 2022 at 4:30 AM <patchwork-bot+netdevbpf@kernel.org> wr=
ote:
> > >
> > > Hello:
> > >
> > > This patch was applied to netdev/net.git (master)
> > > by David S. Miller <davem@davemloft.net>:
> > >
> > > On Fri, 17 Jun 2022 10:54:35 +0200 you wrote:
> > > > Commit 8ff978b8b222 ("ipv4/raw: support binding to nonlocal address=
es")
> > > > introduced a helper function to fold duplicated validity checks of =
bind
> > > > addresses into inet_addr_valid_or_nonlocal(). However, this caused =
an
> > > > unintended regression in ping_check_bind_addr(), which previously w=
ould
> > > > reject binding to multicast and broadcast addresses, but now these =
are
> > > > both incorrectly allowed as reported in [1].
> > > >
> > > > [...]
> > >
> > > Here is the summary with links:
> > >   - [v2] ipv4: ping: fix bind address validity check
> > >     https://git.kernel.org/netdev/net/c/b4a028c4d031
> > >
> > > You are awesome, thank you!
> > > --
> > > Deet-doot-dot, I am a bot.
> > > https://korg.docs.kernel.org/patchwork/pwbot.html
> >
> > I believe this [
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?=
id=3Db4a028c4d031
> > ] needs to end up in 5.17+ LTS (though I guess 5.17 is eol, so
> > probably just 5.18)
>
> 5.17 is end-of-life, sorry.
>
> And this needs to hit Linus's tree first.

It now has:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/net/=
ipv4/ping.c

ipv4: ping: fix bind address validity check
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/n=
et/ipv4/ping.c?id=3Db4a028c4d031c27704ad73b1195ca69a1206941e

> thanks,
>
> greg k-h

Thanks,
Maciej
