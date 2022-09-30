Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096DD5F0EA9
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 17:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbiI3PRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 11:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbiI3PRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 11:17:01 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2FC15C1D4
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 08:17:01 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-3560e81aa1dso24976687b3.2
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 08:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=x0T34YQp6eWgwpasWGkv6SsSV+iKPteW//4vxljElfI=;
        b=CgcNAIjbmW2Gf5JQ1Env1OJisj18TJwwEaEBwIrPOdbhUIk57B6Fn23kfTtBEXdbJy
         HBBfl5P1rTI3TV9pi3VHJiSa/k9R8u0vJkSTv0CtpHdf8SomJI8/8ZqKfH+G7Xl6Ugkq
         2CmRLaMjjGcN7l2NUt7FRDPe4DNnx72tc7AxOuYQFgwidzonpi2UlFRkwLnxAVqrQ/TD
         0IDE5h++TLpL5D8EG2iQ7dt/7uXkpNLGLSvIzO10FYqpzP9buNnhDgAlP0G1ISnmFPmS
         B3kezWp9LTFFz/gzfUfQunQaW1IZaLub9dtElkVLZPS6sJnmx2JEAbfuPUgh2eiUIaVu
         1qmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=x0T34YQp6eWgwpasWGkv6SsSV+iKPteW//4vxljElfI=;
        b=fr/qDMoKHvcO8NTXZbNBf5YMrflJtSc0E0HXwrITLh/O9CBGTbG2K7QwMXw/upehQi
         oID/m46yjUN3iue3shxXH7I/UTGZYJpnT7Q0t3ArN+AdgTW5I8r3D8Fi90P7K26L/rx3
         WtC7sW7AXNdHQgMUWJxJwP+J9Hc8Ik5rdOoGbo4w4mGmbqrb1Fnji3foJeLBSUjDOoTn
         xEYbhbvKCUXHYth5QlSvA2h1M9f6cTfvNtufLlBppODB3SyShVho9/NksIo4ceP6wL7P
         LClCl36kmDJWhahz8PzUuZXLDrnktek2QJ5HD84HT2Ml7WEze+qB0zuczPnL6scEYh3z
         B1qg==
X-Gm-Message-State: ACrzQf34zDs4tOXlLEOe9yxivkKf7hiICixGGJ8LvIDOKYkWTn+jaBwt
        jykmVRUZke3e/YzRXRq1RE305XlxAnnh6Mg91DK74A==
X-Google-Smtp-Source: AMsMyM5oHJJ9VUIcOQ4aFnd7zn70v4TE9fsOF/b7T1ApAtgFKOK3cmXHCLUJJMDrW4TmX1jsCgyCkLiIJqYJOVwWo+E=
X-Received: by 2002:a0d:d508:0:b0:352:43a6:7ddc with SMTP id
 x8-20020a0dd508000000b0035243a67ddcmr8924486ywd.55.1664551020040; Fri, 30 Sep
 2022 08:17:00 -0700 (PDT)
MIME-Version: 1.0
References: <5099dc39-c6d9-115a-855b-6aa98d17eb4b@collabora.com> <8dff3e46-6dac-af6a-1a3b-e6a8b93fdc60@collabora.com>
In-Reply-To: <8dff3e46-6dac-af6a-1a3b-e6a8b93fdc60@collabora.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 30 Sep 2022 08:16:48 -0700
Message-ID: <CANn89iLOdgExV3ydkg0r2iNwavSp5Zu9hskf34TTqmCZQCfUdA@mail.gmail.com>
Subject: Re: [RFC] EADDRINUSE from bind() on application restart after killing
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc:     "open list:NETWORKING [TCP]" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Gofman <pgofman@codeweavers.com>
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

On Fri, Sep 30, 2022 at 6:24 AM Muhammad Usama Anjum
<usama.anjum@collabora.com> wrote:
>
> Hi Eric,
>
> RFC 1337 describes the TIME-WAIT Assassination Hazards in TCP. Because
> of this hazard we have 60 seconds timeout in TIME_WAIT state if
> connection isn't closed properly. From RFC 1337:
> > The TIME-WAIT delay allows all old duplicate segments time
> enough to die in the Internet before the connection is reopened.
>
> As on localhost there is virtually no delay. I think the TIME-WAIT delay
> must be zero for localhost connections. I'm no expert here. On localhost
> there is no delay. So why should we wait for 60 seconds to mitigate a
> hazard which isn't there?

Because we do not specialize TCP stack for loopback.

It is easy to force delays even for loopback (tc qdisc add dev lo root
netem ...)

You can avoid TCP complexity (cpu costs) over loopback using AF_UNIX instead.

TIME_WAIT sockets are optional.
If you do not like them, simply set /proc/sys/net/ipv4/tcp_max_tw_buckets to 0 ?

>
> Zapping the sockets in TIME_WAIT and FIN_WAIT_2 does removes them. But
> zap is required from privileged (CAP_NET_ADMIN) process. We are having
> hard time finding a privileged process to do this.

Really, we are not going to add kludges in TCP stacks because of this reason.

>
> Thanks,
> Usama
>
>
> On 5/24/22 1:18 PM, Muhammad Usama Anjum wrote:
> > Hello,
> >
> > We have a set of processes which talk with each other through a local
> > TCP socket. If the process(es) are killed (through SIGKILL) and
> > restarted at once, the bind() fails with EADDRINUSE error. This error
> > only appears if application is restarted at once without waiting for 60
> > seconds or more. It seems that there is some timeout of 60 seconds for
> > which the previous TCP connection remains alive waiting to get closed
> > completely. In that duration if we try to connect again, we get the error.
> >
> > We are able to avoid this error by adding SO_REUSEADDR attribute to the
> > socket in a hack. But this hack cannot be added to the application
> > process as we don't own it.
> >
> > I've looked at the TCP connection states after killing processes in
> > different ways. The TCP connection ends up in 2 different states with
> > timeouts:
> >
> > (1) Timeout associated with FIN_WAIT_1 state which is set through
> > `tcp_fin_timeout` in procfs (60 seconds by default)
> >
> > (2) Timeout associated with TIME_WAIT state which cannot be changed. It
> > seems like this timeout has come from RFC 1337.
> >
> > The timeout in (1) can be changed. Timeout in (2) cannot be changed. It
> > also doesn't seem feasible to change the timeout of TIME_WAIT state as
> > the RFC mentions several hazards. But we are talking about a local TCP
> > connection where maybe those hazards aren't applicable directly? Is it
> > possible to change timeout for TIME_WAIT state for only local
> > connections without any hazards?
> >
> > We have tested a hack where we replace timeout of TIME_WAIT state from a
> > value in procfs for local connections. This solves our problem and
> > application starts to work without any modifications to it.
> >
> > The question is that what can be the best possible solution here? Any
> > thoughts will be very helpful.
> >
> > Regards,
> >
>
> --
> Muhammad Usama Anjum
