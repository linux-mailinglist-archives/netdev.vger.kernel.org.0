Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC7663FD2B
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiLBAiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiLBAiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:38:03 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D42FA65A8;
        Thu,  1 Dec 2022 16:38:02 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1441d7d40c6so4068743fac.8;
        Thu, 01 Dec 2022 16:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0kq7sv60Ypzyu24t2E6g2GlEi2J4lum3l0hXVmcupo=;
        b=nSvv/hnH7NXI42irYT5g0GNzQmZpNWkleu6qDX71obS/lnL+uJfTzGYTHMmN49QjDQ
         PAAWplD4QeFC+kBNz9TWjewruXaxbeh3OChTvtmQ1LlwJHERYqzILCaUz9od93zVkdhm
         CTwM9pgDFMuVeIvNchF8OD2SCEv+d2n4nld4mIQV2E7Q4omq73xUsq7WseaSGqlW0Rtm
         VqWhZiV1md/pKe8Hqpaqp7wHy0bGgXjdaH+K417FCdMOHmCvM3i3mMW5KMplRSo2cCfC
         SqcqOcIz2tPMjic5VWkUppczAHf59bFfL/txWdlO8VclbeMPFrb5JMqsIqmj2SdhD2jV
         G2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q0kq7sv60Ypzyu24t2E6g2GlEi2J4lum3l0hXVmcupo=;
        b=R3O35drS4scUsrjNXhKQTRQEuUNR0ln7mzz4t8FBFUPN9TevMfT1lIlKblv0U3YmCh
         zZ9ZounOVugkiJk5Q6HL2QqwrrudiKxrPBT43OHCB94R2BoZNZ6tnS7r1DFaxHrvHG53
         x4+cJF4AjLj8MIx2CGPs0jv4IJTCN9l+uJXt40X9K1UjKmYJFWOMbqu3DSQTnlYDWWuU
         YpQrdKsHjvbJPfPnaUt1q8Mgr44B9W+VXduxrC+K6FZcr6Cg/uYfU/QM3XL2W3uJjlK4
         OLimLABP35YUjBd+KxlCODjxf3wYOhXjspqeKQPNbTMmmnyy3jEieo4KEWVI7vZ9zgt8
         MiCg==
X-Gm-Message-State: ANoB5pnkPLEro5bCdYbb2LIfvnd+zcDfpNHVo+5K1vCrfIbF1WdymsOQ
        YgXAVzbR7x+3L/eZTTG1Nu5OOWMSGsRHq44wVOw=
X-Google-Smtp-Source: AA0mqf6+fEu1cga0nv4XY5pYxGnoNxOVhXZtLfTzf/+Xoa1Cg5EaYmAogryfGmzEahatKgbCBAGSYEzT7g2lY9ga2Hw=
X-Received: by 2002:a05:6870:d987:b0:143:fca2:e031 with SMTP id
 gn7-20020a056870d98700b00143fca2e031mr6271717oab.282.1669941481786; Thu, 01
 Dec 2022 16:38:01 -0800 (PST)
MIME-Version: 1.0
References: <20221123173859.473629-1-dima@arista.com> <20221123173859.473629-2-dima@arista.com>
 <Y4B17nBArWS1Iywo@hirez.programming.kicks-ass.net> <2081d2ac-b2b5-9299-7239-dc4348ec0d0a@arista.com>
 <20221201143134.6bb285d8@kernel.org> <CAJwJo6Z9sTDgOFFrpbrXT6eagtmbB5mhfudG0Osp75J4ipNSqQ@mail.gmail.com>
 <20221201153605.58c2382d@kernel.org>
In-Reply-To: <20221201153605.58c2382d@kernel.org>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
Date:   Fri, 2 Dec 2022 00:37:51 +0000
Message-ID: <CAJwJo6Y7OPRiPEgaTNOJ-NV=Eg+42vLoCkZDx0LVhOHwx5twWw@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] jump_label: Prevent key->enabled int overflow
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Dmitry Safonov <dima@arista.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Dec 2022 at 23:36, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 1 Dec 2022 23:17:11 +0000 Dmitry Safonov wrote:
> > On Thu, 1 Dec 2022 at 22:31, Jakub Kicinski <kuba@kernel.org> wrote:
> > > > I initially thought it has to go through tip trees because of the
> > > > dependence, but as you say it's just one patch.
> > > >
> > > > I was also asked by Jakub on v4 to wait for Eric's Ack/Review, so once I
> > > > get a go from him, I will send all 6 patches for inclusion into -net
> > > > tree, if that will be in time before the merge window.
> > >
> > > Looks like we're all set on the networking side (thanks Eric!!)
> >
> > Thanks!
> >
> > > Should I pull Peter's branch? Or you want to just resent a patch Peter
> > > already queued. A bit of an unusual situation..
> >
> > Either way would work for me.
> > I can send it in a couple of hours if you prefer instead of pulling the branch.
>
> I prefer to pull, seems safer in case Peter does get another patch.
>
> It's this one, right?

It is the correct one, yes.

> https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/log/?h=locking/core
>
> I'll pulled, I'll push out once the build is done.

Thank you once again,
             Dmitry
