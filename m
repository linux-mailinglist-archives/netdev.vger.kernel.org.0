Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90EAF5A845A
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 19:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbiHaR1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 13:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbiHaR1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 13:27:01 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665F9DAA1F;
        Wed, 31 Aug 2022 10:26:24 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id y3so29830476ejc.1;
        Wed, 31 Aug 2022 10:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=EmVU6fQXplLhb5FJjrNDE6yAisAqWxYbsd3m0Nr1FHY=;
        b=iMYwS8kagrFZzGSlezaXYi9K88IIxga4XxmCx61r2FTPdpOy7wULit4WrBLyGzPhJn
         wB7FB1Mc1Fz4BKTwz2L1r6KXR0oYm7PPwTUKSoflslPqWPyuiT8i2KYMxHwE9lndS+NF
         jB+S9EoEm3OD4gt1/Yz+iSdQbuKDupvtL9Os/9p4EhKrlc95h5ZwJk4DAXOTSctkZRy6
         OEVn04kqE8fDU8XGRR/GnA4YQqhxjIB0YRHL3aEE8E+kQBdZL1kuGOAwqsmkzozpYpUN
         0AMw3smLWsCmwwYHrpnDJ0fwauxM99Rj7FGKSfA6R1YN8KPnO5Zk3Sy4eEI9qkQABnbW
         ewXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=EmVU6fQXplLhb5FJjrNDE6yAisAqWxYbsd3m0Nr1FHY=;
        b=H2QTxs6JS6tlLhxlbLc7LQHeWgAqeWI+7snbb/FvevEmNhpfJsqriYx9MonJjpgjC6
         fDGm94RKkYoLRnLNlGjhjv2ljuBVhDOkrX+A0YckOKLbNIPznOFHIsYTJhYxgRrqowwf
         bkSQA2MG2p3We/Fwbk9BGOxJjPc6kTTJRF7C7MY09EOipCtDiudiKE+htSS+WGpTk1/8
         pxRLOdZMtrDw+ybqeC8xeF2CVO2MURae0fiu3VTprEQqj+FaObynqTJzYEoeHyti/0n1
         bwi2BneOiaqfbyCgMzv3EkGeaP1F2n+aQJtKdQMm0shwJqeD28yCzhb2t/pVa3dBbVl4
         msrw==
X-Gm-Message-State: ACgBeo0QcPGEguJLUoU/0YnN5lAi9MVoysClmL3WL03gUcNIXRd1iDrR
        ZU4dwlzVD9NbH3BLL8bcStOo9OS7XoclQp/LlQQ=
X-Google-Smtp-Source: AA6agR6SEN0GxOkWKPYfLlMOkffRTV2x2CO57YYxSdEkjKnORaSKFImfBPboCxiyUYnxraxc9fKsySMMigykfkl+HcE=
X-Received: by 2002:a17:906:dc93:b0:742:133b:42c3 with SMTP id
 cs19-20020a170906dc9300b00742133b42c3mr6999566ejc.502.1661966779730; Wed, 31
 Aug 2022 10:26:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220831101617.22329-1-fw@strlen.de> <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc> <87o7w04jjb.fsf@toke.dk>
 <20220831135757.GC8153@breakpoint.cc> <87ilm84goh.fsf@toke.dk>
 <20220831152624.GA15107@breakpoint.cc> <CAADnVQJp5RJ0kZundd5ag-b3SDYir8cF4R_nVbN8Zj9Rcn0rww@mail.gmail.com>
 <20220831155341.GC15107@breakpoint.cc>
In-Reply-To: <20220831155341.GC15107@breakpoint.cc>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 31 Aug 2022 10:26:08 -0700
Message-ID: <CAADnVQJGQmu02f5B=mc1xJvVWSmk_GNZj9WAUskekykmyo8FzA@mail.gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
To:     Florian Westphal <fw@strlen.de>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
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

On Wed, Aug 31, 2022 at 8:53 AM Florian Westphal <fw@strlen.de> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > 1 and 2 have the upside that its easy to handle a 'file not found'
> > > error.
> >
> > I'm strongly against calling into bpf from the inner guts of nft.
> > Nack to all options discussed in this thread.
> > None of them make any sense.
>
> -v please.  I can just rework userspace to allow going via xt_bpf
> but its brain damaged.

Right. xt_bpf was a dead end from the start.
It's time to deprecate it and remove it.

> This helps gradually moving towards move epbf for those that
> still heavily rely on the classic forwarding path.

No one is using it.
If it was, we would have seen at least one bug report over
all these years. We've seen none.

tbh we had a fair share of wrong design decisions that look
very reasonable early on and turned out to be useless with
zero users.
BPF_PROG_TYPE_SCHED_ACT and BPF_PROG_TYPE_LWT*
are in this category.
All this code does is bit rot.
As a minimum we shouldn't step on the same rakes.
xt_ebpf would be the same dead code as xt_bpf.

> If you are open to BPF_PROG_TYPE_NETFILTER I can go that route
> as well, raw bpf program attachment via NF_HOOK and the bpf dispatcher,
> but it will take significantly longer to get there.
>
> It involves reviving
> https://lore.kernel.org/netfilter-devel/20211014121046.29329-1-fw@strlen.de/

I missed it earlier. What is the end goal ?
Optimize nft run-time with on the fly generation of bpf byte code ?
