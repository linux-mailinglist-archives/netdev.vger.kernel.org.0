Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA62C678073
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 16:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbjAWPuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 10:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbjAWPtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 10:49:51 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC5D5FE9
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 07:49:50 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id 66so15342408yba.4
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 07:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DwAmeS+rhT+2tpb2jt+rD4hm3Jw6Bq1K5vvNDECbOEE=;
        b=UID5duZbSgLVywKJezf6alNnjwHNJJSbe0lYNgsnUXSaYDH2A3Hcm3nHKmri0RmBxw
         jcSPb6i3P6Fb0eZKWzF5LgzEtOQOgHSFOryEyDKMmvyKH2hfC/UdE4PCn++1zFgFdpMN
         RqTiWoZ7y17am9C4E+emrZUUdmck+2u9LWMdzmyt3F8Q4jROgZSXIxPcuAJtM5WaW6ok
         eidtLvj9965/oNRopkH0w98NjhcXzFejOFfx+5X+hHTeLRkf/heJzP7J2mjbSyVNYjkD
         RLqMKal49L73L1WC07rNeGA2kx8Mb14dqqALIeIXzMzdvo8WL3JfYjGQdyRnpW4kjemL
         nUig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DwAmeS+rhT+2tpb2jt+rD4hm3Jw6Bq1K5vvNDECbOEE=;
        b=csLy9sQdAQ6oX0xUwFdzG9qlkU4Gq6R8wc7qhcFHhLWviCg+k+QNOc/XhSdabdy6JX
         YE1AkVAboRW4jnVlyZ6q3WoxKax14CpsJ8qN83hJX5fkB43H55txpCyQaPBYg9K2wDm1
         KtahqZrOPwyBL2lRkZlhW79iYphx5lbYkgTwaMkkz7XqkZwyfClPz0s1Wv65B62xgP2A
         0RtVBdGpm/c2VRycuTYnANVS5RRT1s2gF6d9iwWKSG55LkTQota+IkJalkiJO4tCDzwK
         L2ccS2sq0kdqpviDJDDb/OyWqzesEAZxI/C8EM1WSzsB4OKQ95qM9+fKA/XphRfv9TFS
         YubQ==
X-Gm-Message-State: AFqh2kp3+JldjOsKBAWuD0KzO5rJWQYTYZTq7qccnXdrCijM+OXCsW6/
        C9t31JXKvzsRBXPWnsnpFJhvYLNmuo/GlABshYf+bg==
X-Google-Smtp-Source: AMrXdXvUElUapunbeCtWYmrW1AO9aK41Oal4EoiIPCtlx/B5qU0PEEdHM0oxWluuvIClKqiL7m34mhB41rRPicxlpl0=
X-Received: by 2002:a25:fd4:0:b0:803:fbad:94a4 with SMTP id
 203-20020a250fd4000000b00803fbad94a4mr1061462ybp.407.1674488988971; Mon, 23
 Jan 2023 07:49:48 -0800 (PST)
MIME-Version: 1.0
References: <2d2ad1e5-8b03-0c59-4cf1-6a5cc85bbd94@cloudflare.com>
 <CANn89iJvOPH9rJ4YjRP-i99beY3g+moLnRQH2ED-CQX7QnDYpA@mail.gmail.com> <fd9d9040-1721-b882-885f-71a4aeef9454@cloudflare.com>
In-Reply-To: <fd9d9040-1721-b882-885f-71a4aeef9454@cloudflare.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 23 Jan 2023 16:49:37 +0100
Message-ID: <CANn89iLMUP8_HnmmstGHxh7iR+EqPdEAUNM7OfyDdHJFNdBu3g@mail.gmail.com>
Subject: Re: BUG: using __this_cpu_add() in preemptible in tcp_make_synack()
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com
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

On Mon, Jan 23, 2023 at 4:46 PM Frederick Lawler <fred@cloudflare.com> wrote:
>
> Hi Eric,
>
> On 1/18/23 11:07 AM, Eric Dumazet wrote:
> > On Wed, Jan 18, 2023 at 5:56 PM Frederick Lawler <fred@cloudflare.com> wrote:
> >>
> >> Hello,
> >>
> >> We've been testing Linux 6.1.4, and came across an intermittent "BUG:
> >> using __this_cpu_add() in preemptible" [1] in our services leveraging
> >> TCP_FASTOPEN and our kernel configured with:
> >>
> >> [snip]
> >
> > Thanks for the report
> >
> > I guess this part has been missed in commit 0a375c822497ed6a
> >
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > index 71d01cf3c13eb4bd3d314ef140568d2ffd6a499e..ba839e441450f195012a8d77cb9e5ed956962d2f
> > 100644
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -3605,7 +3605,7 @@ struct sk_buff *tcp_make_synack(const struct
> > sock *sk, struct dst_entry *dst,
> >          th->window = htons(min(req->rsk_rcv_wnd, 65535U));
> >          tcp_options_write(th, NULL, &opts);
> >          th->doff = (tcp_header_size >> 2);
> > -       __TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
> > +       TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
> >
> >   #ifdef CONFIG_TCP_MD5SIG
> >          /* Okay, we have all we need - do the md5 hash if needed */
>
>
> Tested-by: Frederick Lawler <fred@cloudflare.com>

Thanks for testing, I will submit the fix today.
