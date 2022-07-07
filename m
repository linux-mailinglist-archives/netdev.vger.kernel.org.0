Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B162C56AAE9
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 20:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236096AbiGGSgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 14:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235876AbiGGSgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 14:36:31 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2456BC2
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 11:36:30 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2ef5380669cso178590137b3.9
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 11:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BF9Ehrqmqwiz/UrcKcS0L4NTo9GZL+bOvT6TqkmWqQM=;
        b=tb78a9qaXnOSPeZkQcyyD2qL2ELQmx8XXelsLSi50pbCOTEZzjvYlZY+dcoc9evhqa
         V61AStNiH6OD6Efruct1Gocd6ls3sYIO7ROL8xIFN7yHwNVvy4ihMvEf5EgstQKt2ZS9
         ocT7vVhz0FCl9LXCaviOcuqwRb+8amN+DvMoz9Lt7DI/1VFZALXrkaYr42vCFbxdasXf
         KWIZCh8ciYhomFlJomjN32hLc6R0yQ+oPGp/ZCUiAxRQckK2LP1hDoFOK8cHFOTMkVWD
         xsasU1y0HOdMkM2T1iANsaW2k7reC0W9N0bupp7BgvWWgZtxlXTO3J3AAcw9i4A7oOTM
         EZMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BF9Ehrqmqwiz/UrcKcS0L4NTo9GZL+bOvT6TqkmWqQM=;
        b=EJYD0ZjZmsd+tNCLhiUNSqimm+BbQotWw5vX3iLCx43WJG/zScI78uMKHINuURV4UI
         xOx7Yb7nqzHjL3HtvZsq2SBVjybGrPEygZpu8AlcPef17Vc/S/wWxh2q2iKktJ+7eIZH
         7p7g6ovkfbVnkdQiIv3etrK12syEpnaGabFH0LSXGa/FHICjj8XJ5Ek1AJIowzGKDwZ+
         Q7Lz/mYmoqJc4trIOzmgisG3b0aSwM7VQzRSqSyGScXqhYwbeqhSjqE/r9wuVPgoB1fi
         GYUgyP/mIKsvdMoRJxns7V/8SxQPPY+cgFYxPbWiSwpm5ilybbLbGb2RNIvRoyI7eV5p
         ovcA==
X-Gm-Message-State: AJIora/yYEtOJamE+2teyViMrit+vZHE6dT7c/5/zc6YoqRYvO4VbarG
        i8Ryk+3HNL2fydTFGrd97BxGV+0f4qQ/JbAq9Evoyg==
X-Google-Smtp-Source: AGRyM1tvPAS4rzsHJXr4lPYjvNrlT2DRnE4AVoMJp8xgQgeQEugCFqqO07pK9nrmCASgPmwYoRCaAMDK8DrHmzi8aPA=
X-Received: by 2002:a81:4994:0:b0:31c:d036:d0b1 with SMTP id
 w142-20020a814994000000b0031cd036d0b1mr17247785ywa.255.1657218989053; Thu, 07
 Jul 2022 11:36:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220707123900.945305-1-edumazet@google.com> <165721801302.2116.12763817658962623961.git-patchwork-notify@kernel.org>
 <CAADnVQLoMzN8icCenQh7OHNRHAHMhQhujQYwSXH3Kmw6sAGOGA@mail.gmail.com>
In-Reply-To: <CAADnVQLoMzN8icCenQh7OHNRHAHMhQhujQYwSXH3Kmw6sAGOGA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 7 Jul 2022 20:36:17 +0200
Message-ID: <CANn89iLarMJeMUivaPnYHUh3MYjEZ91USq0ncGbLFp1JNjEiaA@mail.gmail.com>
Subject: Re: [PATCH] bpf: make sure mac_header was set before using it
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        syzkaller <syzkaller@googlegroups.com>
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

On Thu, Jul 7, 2022 at 8:31 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jul 7, 2022 at 11:20 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
> >
> > Hello:
> >
> > This patch was applied to bpf/bpf.git (master)
>
> Are we sure it's bpf tree material?
> The fixes tag points to net-next tree.

Fix is generic and should not harm bpf tree, or any tree if that matters.

Sorry for not adding the net-next tag in the [PATCH].

>
> > by Daniel Borkmann <daniel@iogearbox.net>:
> >
> > On Thu,  7 Jul 2022 12:39:00 +0000 you wrote:
> > > Classic BPF has a way to load bytes starting from the mac header.
> > >
> > > Some skbs do not have a mac header, and skb_mac_header()
> > > in this case is returning a pointer that 65535 bytes after
> > > skb->head.
> > >
> > > Existing range check in bpf_internal_load_pointer_neg_helper()
> > > was properly kicking and no illegal access was happening.
> > >
> > > [...]
> >
> > Here is the summary with links:
> >   - bpf: make sure mac_header was set before using it
> >     https://git.kernel.org/bpf/bpf/c/0326195f523a
> >
> > You are awesome, thank you!
> > --
> > Deet-doot-dot, I am a bot.
> > https://korg.docs.kernel.org/patchwork/pwbot.html
> >
> >
