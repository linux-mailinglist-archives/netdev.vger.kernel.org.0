Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C10A4FFC36
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbiDMRQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbiDMRQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:16:57 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02294BBA1
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:14:34 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2edbd522c21so29533927b3.13
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vwO3OGbzddlvjItZqAV0mqXb3O/PEMsPvLwPJ9/sqKU=;
        b=juce799HZCRZ/VOt5XfwSWlE6hcRFFFJshBvveO8PUrjBHpVx5KSOXZFdfw+LxSxNk
         Levx9OahKD5UvcPdnSOAXEfARo99Yp5hYAuEP1SEyj3aji7iAqQhFFe3mKQj04maUAmO
         ecyAviwSm+ovtCHW15RkIVeS2efs5wcCl98ag91uNQK4uutWVNw1ppzzS/c7/RzJ662N
         Ssx+zQnU6oEV2EDubKprrTnG6Rrg9XsD3hiIKUdhZLZ01HnZDan8pG+xE/SzA59bF7fN
         vCNSyE/xBY1gKTgZpjtbzxWsqj5VqDaY7ZsOKMx6nnDgGqH5HBbNsqFM33EmDFnzTwiS
         +lJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vwO3OGbzddlvjItZqAV0mqXb3O/PEMsPvLwPJ9/sqKU=;
        b=BZybOPvuzIkKHM3SPLm13IAkrcpymz4IBHXmOL+UTNYPVxK5MsS5tab0twyNqtt0em
         tawIV+xQr7Fg+J5ee8Jmu9YUl23IYSaND8A1d6JMNKBlj2R0bwuUHyH0y/Uuqez4gLT7
         W1foTRmJkEMaAQFRy4yzJQ3HIKi170zwT+D0EDdW880AsACb7pxAwsMdN/LvXtWQDAeT
         +g6jr9Qgs2UlelORmQR5Yi03AJ+srzDqOTOXzep9dMLDJdtCErz3F0mO1sRvlydVbHlr
         FO21YeshimMtoiIY1Ein1w4DvqBoHsvrFPaeU6eFpSK0X934b0GRu75Y3CSVXW1/i2kw
         egrQ==
X-Gm-Message-State: AOAM532bVZaMYhfE307/FDArveu7weuIZWfd57UKkbHUtnemhGmlbR1U
        rXvpEU8EKriYdoW7ZQK4D99VIkmhluQv2g6j+FIEGg==
X-Google-Smtp-Source: ABdhPJxPUIE1ZOenitkw5d5s7aq+dd1XUfK2F4KoXC+CggT686FVMRJ+L5n4dKB7nZVlPdnCiNHKptExwbKCAoszN50=
X-Received: by 2002:a81:753:0:b0:2eb:ebe9:ff4f with SMTP id
 80-20020a810753000000b002ebebe9ff4fmr19633113ywh.255.1649870073759; Wed, 13
 Apr 2022 10:14:33 -0700 (PDT)
MIME-Version: 1.0
References: <164984498582.2000115.4023190177137486137.stgit@warthog.procyon.org.uk>
In-Reply-To: <164984498582.2000115.4023190177137486137.stgit@warthog.procyon.org.uk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 13 Apr 2022 10:14:22 -0700
Message-ID: <CANn89iLEch=H9OJpwue7HVJNPxxn-TobRyoATHTrSdetwpHVXA@mail.gmail.com>
Subject: Re: [PATCH net] rxrpc: Restore removed timer deletion
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
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

On Wed, Apr 13, 2022 at 3:16 AM David Howells <dhowells@redhat.com> wrote:
>
> A recent patch[1] from Eric Dumazet flipped the order in which the
> keepalive timer and the keepalive worker were cancelled in order to fix a
> syzbot reported issue[2].  Unfortunately, this enables the mirror image bug
> whereby the timer races with rxrpc_exit_net(), restarting the worker after
> it has been cancelled:
>
>         CPU 1           CPU 2
>         =============== =====================
>                         if (rxnet->live)
>                         <INTERRUPT>
>         rxnet->live = false;
>         cancel_work_sync(&rxnet->peer_keepalive_work);
>                         rxrpc_queue_work(&rxnet->peer_keepalive_work);
>         del_timer_sync(&rxnet->peer_keepalive_timer);
>
> Fix this by restoring the removed del_timer_sync() so that we try to remove
> the timer twice.  If the timer runs again, it should see ->live == false
> and not restart the worker.
>
> Fixes: 1946014ca3b1 ("rxrpc: fix a race in rxrpc_exit_net()")
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Marc Dionne <marc.dionne@auristor.com>
> cc: linux-afs@lists.infradead.org
> Link: https://lore.kernel.org/r/20220404183439.3537837-1-eric.dumazet@gmail.com/ [1]
> Link: https://syzkaller.appspot.com/bug?extid=724378c4bb58f703b09a [2]
> ---
>
>  net/rxrpc/net_ns.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
> index f15d6942da45..cc7e30733feb 100644
> --- a/net/rxrpc/net_ns.c
> +++ b/net/rxrpc/net_ns.c
> @@ -113,7 +113,9 @@ static __net_exit void rxrpc_exit_net(struct net *net)
>         struct rxrpc_net *rxnet = rxrpc_net(net);
>
>         rxnet->live = false;
> +       del_timer_sync(&rxnet->peer_keepalive_timer);
>         cancel_work_sync(&rxnet->peer_keepalive_work);
> +       /* Remove the timer again as the worker may have restarted it. */
>         del_timer_sync(&rxnet->peer_keepalive_timer);
>         rxrpc_destroy_all_calls(rxnet);
>         rxrpc_destroy_all_connections(rxnet);
>
>

ok... so we have a timer and a work queue, both activating each other
in kind of a ping pong ?

Any particular reason not using delayed works ?

Thanks.
