Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FA356AAF2
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 20:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236299AbiGGSks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 14:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236199AbiGGSkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 14:40:46 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77F2255A2;
        Thu,  7 Jul 2022 11:40:45 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id u12so33906553eja.8;
        Thu, 07 Jul 2022 11:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5wgonJcM0EyOdIyq0+c4IlpH/2oqpw5MkTpKOISVOkQ=;
        b=YATRLVnfHLjaYvY/41cblf18Vx06qMoAjJgBOkboQjw8rxEaaD+EzY9p77jN19V2aK
         gUxTO4CwsX4Vi1goOA1HwZ+EEBEnJFtk7A8DGUkvTS9AUE6/Vbk9FEIMBZG/+8Xg+2R7
         SRdswc+3nCivHbKSPdZmjzrLUpRepOIl2Kd8Nccr1TuG7t7Qp2hVbd2Svp5HU7OrAfUM
         huNeJjwKG2D3eAzi9GKSKRlMPZRLfH83dWqk4nHG/8CBydqeLy+8rvUqTFEdUcalU+QJ
         0Zv+PlJfXo5ORN7fFHyN0jLKIDtyis0Pmp6BrrUTdfp1xx5Lkxq5uJ3UJoGR/vDd8ZGd
         brZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5wgonJcM0EyOdIyq0+c4IlpH/2oqpw5MkTpKOISVOkQ=;
        b=BhOHhNE/lKKoqy122UqAmfi1vKIt8/56n/1AvB5SoIVCc/6XODV335tYWI9OdBOecy
         DkUKp+v3wRwbbh82X7DShw97utRJ6W0hMoBzb2RV/1M308+NL3UTjw+C2wAuG/TJzgPM
         YJ3N8C5Z5dBylAu7UbWiLN/FLyOG/UYMQDP52MPnG93ll3o3Y19dWidtaPur3Y9A6nxa
         uKAqoNxAHDSH3RV6ee36h9+Fe+rQ2IabmLGDFAZUCW1hke7BmNCGgDcGYv0O8dV07JLQ
         MMCDKdLVkGagxpgKVH+852rHNULnauEt9Tjcyez/GkAxMv7+rnc7eaC1wSRlRzMMcEfF
         p2Lg==
X-Gm-Message-State: AJIora8g4jo9ota/f6S3BgKdHZTbhxWLJ0n9k+O1Sew6Hbz2LFNGOUdu
        jo1Mkgd8Ewurk49AgfwcgHku9u9yy1yO2eMrGFw=
X-Google-Smtp-Source: AGRyM1vNvkNKAuLfn6AbN/FVYQpYvGH0941C7ZxI196DW6rxPdWBlHne63jT3VvzaohFv4SzPvYMDEQiCHaGpulTJos=
X-Received: by 2002:a17:906:8444:b0:72a:7dda:5d71 with SMTP id
 e4-20020a170906844400b0072a7dda5d71mr35966505ejy.94.1657219244283; Thu, 07
 Jul 2022 11:40:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220707123900.945305-1-edumazet@google.com> <165721801302.2116.12763817658962623961.git-patchwork-notify@kernel.org>
 <CAADnVQLoMzN8icCenQh7OHNRHAHMhQhujQYwSXH3Kmw6sAGOGA@mail.gmail.com> <CANn89iLarMJeMUivaPnYHUh3MYjEZ91USq0ncGbLFp1JNjEiaA@mail.gmail.com>
In-Reply-To: <CANn89iLarMJeMUivaPnYHUh3MYjEZ91USq0ncGbLFp1JNjEiaA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 7 Jul 2022 11:40:33 -0700
Message-ID: <CAADnVQLC5Wj7TbMEUvuMRs1cB9FNsk3y5jBN8XwUMif6CUEXeg@mail.gmail.com>
Subject: Re: [PATCH] bpf: make sure mac_header was set before using it
To:     Eric Dumazet <edumazet@google.com>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 7, 2022 at 11:36 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Jul 7, 2022 at 8:31 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Jul 7, 2022 at 11:20 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
> > >
> > > Hello:
> > >
> > > This patch was applied to bpf/bpf.git (master)
> >
> > Are we sure it's bpf tree material?
> > The fixes tag points to net-next tree.
>
> Fix is generic and should not harm bpf tree, or any tree if that matters.

Right. Just trying to understand the urgency/severity
considering we're at rc5.

> Sorry for not adding the net-next tag in the [PATCH].
>
> >
> > > by Daniel Borkmann <daniel@iogearbox.net>:
> > >
> > > On Thu,  7 Jul 2022 12:39:00 +0000 you wrote:
> > > > Classic BPF has a way to load bytes starting from the mac header.
> > > >
> > > > Some skbs do not have a mac header, and skb_mac_header()
> > > > in this case is returning a pointer that 65535 bytes after
> > > > skb->head.
> > > >
> > > > Existing range check in bpf_internal_load_pointer_neg_helper()
> > > > was properly kicking and no illegal access was happening.
> > > >
> > > > [...]
> > >
> > > Here is the summary with links:
> > >   - bpf: make sure mac_header was set before using it
> > >     https://git.kernel.org/bpf/bpf/c/0326195f523a
> > >
> > > You are awesome, thank you!
> > > --
> > > Deet-doot-dot, I am a bot.
> > > https://korg.docs.kernel.org/patchwork/pwbot.html
> > >
> > >
