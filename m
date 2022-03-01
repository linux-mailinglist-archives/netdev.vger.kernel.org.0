Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBD64C8EAE
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 16:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235260AbiCAPPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 10:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiCAPPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 10:15:37 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C5C427C4
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 07:14:56 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id z66so13117465qke.10
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 07:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=N+utyRYCNuKyU7IWkP2AJL9he7LLd2jQiK5Xa3sCqIM=;
        b=pMkLwqmyG0yMcGiVdouydBtN/0qZHBLpEkdACyTw204h15TyZEKz8Vf6iI2+BuTIRp
         yjU+0IPDwpd9KzkUxX7/X5gdqhFV8bFDWU/f562YiJGD5pxEtuw2RK8o9XZO8igzjA3Q
         Fqv6sT+PnzO1yaO3lNZkP++tjKl144Lq0VIFHCzBpEgdZeVxlq3f7Sl3w/YnLgmVsyeg
         BcKD2NEhHMekl/WegBWX81z2hxONIjeljr2hqGdL6//Shvyk1h/+FTgbV+PGLiv9ACML
         j2XpdOH0w5i35AOrprgvsPTl9IMoA+JyQmL/le/QrvfOTsArXDKUkqjGrj0JQ12ji/xL
         RiJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=N+utyRYCNuKyU7IWkP2AJL9he7LLd2jQiK5Xa3sCqIM=;
        b=Mq4U9Z5yA8bQPNDYMUih5Vtv0CgzZzupT0h3YkQOlmW/ZMI7vc16hVFFXmP7WHw2PO
         BjxoISkbJSBrGNCxw6OQ/MOlWEZcclfh27c9nSspuJPN4aUF3+5D3DJl4x/brjw2LZO7
         qXtLmOkNTacK95/KWWD2C3qJz0PNkBfYJd6EZ3GPmLC7gq5DOg3EFejx6ulqldFjS1Uy
         1/tWqrv76FtrH0TkREMO6WFPAmwVjo8QVNK08f+QTQT4bLGj37ZRHiEQ5a9ysfj9COFM
         PB3s9v150e/r4QJl7149AQvatU70TFElMMsgOlpWg9oMMVtTpk++ug87pycLf+5CMkTW
         oAIg==
X-Gm-Message-State: AOAM530HtQEpWEeAG2FdNCQhMM6UaSu+ZK+nyB8FsnrjWpG7b8pRwA3X
        bIKrkrJ5RwfZtkJ9/nBiFU88DmiTIQ6WjQ==
X-Google-Smtp-Source: ABdhPJwYqGcYfsGC7MaAqpXtAKCn/8RrSMtGpdXmkbheq/YZ5ewjgWL97obCb/PuXkfxdvnUZaXoLg==
X-Received: by 2002:a05:620a:12e5:b0:648:c747:ef42 with SMTP id f5-20020a05620a12e500b00648c747ef42mr13977429qkl.659.1646147695854;
        Tue, 01 Mar 2022 07:14:55 -0800 (PST)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id 24-20020a05620a06d800b0047bc1e91c34sm6693644qky.114.2022.03.01.07.14.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 07:14:55 -0800 (PST)
Received: by mail-yb1-f176.google.com with SMTP id b35so27735982ybi.13
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 07:14:55 -0800 (PST)
X-Received: by 2002:a05:6902:102a:b0:614:105b:33a6 with SMTP id
 x10-20020a056902102a00b00614105b33a6mr24189687ybt.457.1646147694685; Tue, 01
 Mar 2022 07:14:54 -0800 (PST)
MIME-Version: 1.0
References: <20220301144453.snstwdjy3kmpi4zf@begin> <CA+FuTSfi1aXiBr-fOQ+8XJPjCCTnqTicW2A3OUVfNHurfDL3jA@mail.gmail.com>
 <20220301150028.romzjw2b4aczl7kf@begin>
In-Reply-To: <20220301150028.romzjw2b4aczl7kf@begin>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 1 Mar 2022 10:14:18 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeZw228fsDj+YoSpu5sLaXsp+uR+N+qHrzZ4e3yMWhPKw@mail.gmail.com>
Message-ID: <CA+FuTSeZw228fsDj+YoSpu5sLaXsp+uR+N+qHrzZ4e3yMWhPKw@mail.gmail.com>
Subject: Re: [PATCH] SO_ZEROCOPY should rather return -ENOPROTOOPT
To:     Samuel Thibault <samuel.thibault@labri.fr>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        willemb@google.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
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

On Tue, Mar 1, 2022 at 10:00 AM Samuel Thibault
<samuel.thibault@labri.fr> wrote:
>
> Willem de Bruijn, le mar. 01 mars 2022 09:51:45 -0500, a ecrit:
> > On Tue, Mar 1, 2022 at 9:44 AM Samuel Thibault <samuel.thibault@labri.fr> wrote:
> > >
> > > ENOTSUPP is documented as "should never be seen by user programs", and
> > > is not exposed in <errno.h>, so applications cannot safely check against
> > > it. We should rather return the well-known -ENOPROTOOPT.
> > >
> > > Signed-off-by: Samuel Thibault <samuel.thibault@labri.fr>
> > >
> > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > index 4ff806d71921..6e5b84194d56 100644
> > > --- a/net/core/sock.c
> > > +++ b/net/core/sock.c
> > > @@ -1377,9 +1377,9 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
> > >                         if (!(sk_is_tcp(sk) ||
> > >                               (sk->sk_type == SOCK_DGRAM &&
> > >                                sk->sk_protocol == IPPROTO_UDP)))
> > > -                               ret = -ENOTSUPP;
> > > +                               ret = -ENOPROTOOPT;
> > >                 } else if (sk->sk_family != PF_RDS) {
> > > -                       ret = -ENOTSUPP;
> > > +                       ret = -ENOPROTOOPT;
> > >                 }
> > >                 if (!ret) {
> > >                         if (val < 0 || val > 1)
> >
> > That should have been a public error code. Perhaps rather EOPNOTSUPP.
> >
> > The problem with a change now is that it will confuse existing
> > applications that check for -524 (ENOTSUPP).
>
> They were not supposed to hardcord -524...
>
> Actually, they already had to check against EOPNOTSUPP to support older
> kernels, so EOPNOTSUPP is not supposed to pose a problem.

Which older kernels returned EOPNOTSUPP on SO_ZEROCOPY?

There is prior art in changing this error code when it leaks to
userspace, such as commit 2230a7ef5198 ("drop_monitor: Use correct
error code") and commit 4a5cdc604b9c ("net/tls: Fix return values to
avoid ENOTSUPP").

I certainly wrote code in the past that explicitly checks for 524
(ENOTSUPP). But do not immediately see public code that does this.
Indeed, udpgso_bench_tx checks for both these codes.

So it's probably fine. Note that there is some risk. But no more than
with those prior commits.
