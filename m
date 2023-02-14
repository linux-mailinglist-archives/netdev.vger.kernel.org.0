Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683D1696E0E
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 20:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbjBNTnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 14:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbjBNTnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 14:43:00 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F7D1E1ED
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 11:42:59 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-52f1b1d08c2so96597477b3.5
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 11:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HJ3qac3IIkdwtEh/MAuFFB1oT6iSgvamin2dR2nxH2A=;
        b=qu4gXVZJQU5/f6j+wbSRHqED+GdKE83h6YD46dto2BUTFIeZcoFPPNPcIYAB7SBKEF
         HRySRvv1D7RpsLvfXTRRJjj0TRUiTc/pH7NrMSSmILZXfmUKgGit/JAbecIXWAVWvmlO
         /UFQggRqH2xIiInPpQeL7S1dZHBNdNnCYJcVXMPlKAhGGCzbEtkSonLFYVHnej4LsPR5
         UPHgmu0vM0vhGKsq96H8JG3mR64eZAJVJNK6E9nx5XhFK1SPsDOU9YYNhcxgJQ8kb/vv
         lta4uIxRlwPPhOGpl/e74EEs+ssQWDuCdA1h7pxTxWrkkWloqxbfuJez4KlQM5WbgzX4
         nymA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HJ3qac3IIkdwtEh/MAuFFB1oT6iSgvamin2dR2nxH2A=;
        b=sQooD8RXDvuy3oVa7SSKVWygTPSoQ99cachBLy6OWNAuEqL7KsIv75exJY0iDyW1MT
         t+0NhAJrHaGTTmU4z6e1BoVavQKcfyamJG22aMLJQ8luQ/6KVKJhjAE8J7Y1R/3i93BQ
         GHi0PIT35sm40RAMAWu/LFjckMZnkz85xUVzPHHvE6TIfEGU397KCcyVMCnnIsTBAP5p
         XLJNHmN6jaU/J3ML77ZS+9cPXwb1Z88AgerZ+6oKw9dQlQcml0YamP8KUuHEylxvfITo
         /FmLNBHavPX8vuoz0Av/H6i8bMaFio+XK7VChev8P4jJSPoTc8CpIe/12LT7EBHoWVWw
         igNg==
X-Gm-Message-State: AO0yUKUn6GomHP+/+btVtitGqYqQzeN2kvk3UI4H2Tb8zP+wRwhFtcT2
        FfdeQFxHagZyr1iUdFnTlWfD3haX5kZ+M1Gf+P6ADYOMfmCPFbAB
X-Google-Smtp-Source: AK7set+f77ku3xTe6Sc15sNjU4CfUxqLY83X1VP5DiQHeWs/Ewx1eKqALn9GY6kxXooskYw4IfDWlJlfVysogpA+6sI=
X-Received: by 2002:a81:c252:0:b0:4b2:fa7c:8836 with SMTP id
 t18-20020a81c252000000b004b2fa7c8836mr405580ywg.195.1676403778036; Tue, 14
 Feb 2023 11:42:58 -0800 (PST)
MIME-Version: 1.0
References: <CABEBQimj8Jk659Xb+gNgW_dVub+euLwM6XGrPvkrPaEb=9GH+A@mail.gmail.com>
 <20230214192257.47149-1-kuniyu@amazon.com>
In-Reply-To: <20230214192257.47149-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 14 Feb 2023 20:42:46 +0100
Message-ID: <CANn89iK5BZvsn_u9WLUxTORH=Qu0hXVOdKOOHEMjqhhKMfrYpw@mail.gmail.com>
Subject: Re: BUG: using __this_cpu_add() in preemptible in tcp_make_synack()
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     fhofmann@cloudflare.com, davem@davemloft.net, dsahern@kernel.org,
        fred@cloudflare.com, kernel-team@cloudflare.com, kuba@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 8:23 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Frank Hofmann <fhofmann@cloudflare.com>
> Date:   Tue, 14 Feb 2023 17:14:24 +0000
> > Hi Eric,
> >
> > On Mon, Jan 23, 2023 at 3:49 PM 'Eric Dumazet' via
> > kernel-team+notifications <kernel-team@cloudflare.com> wrote:
> > >
> > > > On 1/18/23 11:07 AM, Eric Dumazet wrote:
> > > [ ... ]
> > > > > Thanks for the report
> > > > >
> > > > > I guess this part has been missed in commit 0a375c822497ed6a
> > > > >
> > > > > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > > > > index 71d01cf3c13eb4bd3d314ef140568d2ffd6a499e..ba839e441450f195012a8d77cb9e5ed956962d2f
> > > > > 100644
> > > > > --- a/net/ipv4/tcp_output.c
> > > > > +++ b/net/ipv4/tcp_output.c
> > > > > @@ -3605,7 +3605,7 @@ struct sk_buff *tcp_make_synack(const struct
> > > > > sock *sk, struct dst_entry *dst,
> > [ ... ]
> >
> > we're still seeing this with a preempt-enabled kernel, in
> > tcp_check_req() though, like:
> >
> > BUG: using __this_cpu_add() in preemptible [00000000] code: nginx-ssl/186233
> > caller is tcp_check_req+0x49a/0x660
> > CPU: 58 PID: 186233 Comm: nginx-ssl Kdump: loaded Tainted: G
> > O       6.1.8-cloudflare-2023.1.16 #1
> > Hardware name: ...
> > Call Trace:
> >  <TASK>
> >  dump_stack_lvl+0x34/0x48
> >  check_preemption_disabled+0xdd/0xe0
> >  tcp_check_req+0x49a/0x660
> >  tcp_rcv_state_process+0xa3/0x1020
> >  ? tcp_sendmsg_locked+0x2a4/0xc50
> >  tcp_v4_do_rcv+0xc6/0x280
> >  __release_sock+0xb4/0xc0
> >  release_sock+0x2b/0x90
> >  tcp_sendmsg+0x33/0x40
> >  sock_sendmsg+0x5b/0x70
> >  sock_write_iter+0x97/0x100
> >  vfs_write+0x330/0x3d0
> >  ksys_write+0xab/0xe0
> >  ? syscall_trace_enter.constprop.0+0x164/0x170
> >  do_syscall_64+0x3b/0x90
> >  entry_SYSCALL_64_after_hwframe+0x4b/0xb5
> >
> > There's a notable number of "__"-marked stats updates in
> > tcp_check_req(); I can't claim to understand the code well enough if
> > all would have to be changed.
> > The occurence is infrequent (we see about two a week).
>
> How about converting __SNMP_XXX() only if the kernel is preemptible
> like this ?  Then we can keep the optimised code for other config.
>
> untested & incomplete patch:
>

I would prefer not to.

Let me work on a proper fix.
