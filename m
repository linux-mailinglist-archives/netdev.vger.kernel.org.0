Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E135FF228
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 18:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJNQU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 12:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiJNQUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 12:20:25 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E496B4A81F
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 09:20:18 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 126so6187609ybw.3
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 09:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uY0IG2r/onj1LsXaA41TR23rc52PyWUrwqi3tyqEPkY=;
        b=YZBQRYJLpJQSbtbM6pXh9wRl9esR6TWT70JjnO3uSRGQksb7cbLP3bNp3C6vhDWNS0
         Jq+xUb5p5aU4B48WPqqgjjTz5HsB7SY++fTvIhJz9GOxTryYmK2BaH4hSHGAGmjgscO0
         aOHqKLQIXUygS5vGlQhmqb+7uPmdsLwD8a7FNuZZ01+tYoOlvkOCcDFC3dPRMi0hIP9X
         klbzPbRlCxAAbONOuN+J2gYjTcO9QANQyGs4IDia4D5MHUnFpbaiRddmslMdW5rRUztk
         D3nJ3ZWTmK9xdx6+uCt53zK0dY/OVRtjD+6WczC2rrPc9xYAnv4QqlxJf9GYEqN6JFNP
         BonA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uY0IG2r/onj1LsXaA41TR23rc52PyWUrwqi3tyqEPkY=;
        b=RNiTqmZ/nEIyrOVUvAzPL/Dd0kW8x3NBp/CC9FKd2gSyRpKvI65aDeSy3EVv3roJWB
         iy5oyPu52aoqjYSpu6hmEFPXYVMF+uztqhosGXh6r4LL2R8YMEcxMQiusCnMHSdFlhIQ
         SGSJ7LeqtjypobBGhVmVDXEsNifrZaocl0IyAt90tg8Fy8UpyI5/W4HlOWaqlvQetAKS
         kcLPgbInUJSNxr/bxvikez4ofRkb7lpQr2E8iOof/t9LRRQsDWqOwaCqp3qzrwVjJ/3d
         EkneGOPdlgAwI1yMzxZ2VMSTOfHmMIm/AYaszyIueT3dJjZcyNq3ir+TwxaKWlPrEIe2
         YQmw==
X-Gm-Message-State: ACrzQf1h3ocyNWvv1UeBYmiH3q8KEjGoPRjgC8Q2BmSXtT0Y3QjlRaz5
        qXsb7hkhjyL1EdAYWu6DEqjESSHeEpT0Ddbrj8NX2w==
X-Google-Smtp-Source: AMsMyM5tSIBZmpnwsUpIM0Ii/QRfqpXzilyZZLcpVPKgs/pRDP/i/3uxQ5KVVmvty7JPqg1mXgkKMDWK8kFQ2x7zaTQ=
X-Received: by 2002:a25:3187:0:b0:6c1:822b:eab1 with SMTP id
 x129-20020a253187000000b006c1822beab1mr4948047ybx.427.1665764417429; Fri, 14
 Oct 2022 09:20:17 -0700 (PDT)
MIME-Version: 1.0
References: <5099dc39-c6d9-115a-855b-6aa98d17eb4b@collabora.com>
 <8dff3e46-6dac-af6a-1a3b-e6a8b93fdc60@collabora.com> <CANn89iLOdgExV3ydkg0r2iNwavSp5Zu9hskf34TTqmCZQCfUdA@mail.gmail.com>
 <5db967de-ea7e-9f35-cd74-d4cca2fcb9ee@codeweavers.com>
In-Reply-To: <5db967de-ea7e-9f35-cd74-d4cca2fcb9ee@codeweavers.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 14 Oct 2022 09:20:04 -0700
Message-ID: <CANn89iJTNUCDLptS_rV4JUDcEH8JNXvOTx4xgzvaDHG6eodtXg@mail.gmail.com>
Subject: Re: [RFC] EADDRINUSE from bind() on application restart after killing
To:     Paul Gofman <pgofman@codeweavers.com>
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        "open list:NETWORKING [TCP]" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
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

On Fri, Oct 14, 2022 at 8:52 AM Paul Gofman <pgofman@codeweavers.com> wrote:
>
> Hello Eric,
>
> our problem is actually not with the accept socket / port for which
> those timeouts apply, we don't care for that temporary port number. The
> problem is that the listen port (to which apps bind explicitly) is also
> busy until the accept socket waits through all the necessary timeouts
> and is fully closed. From my reading of TCP specs I don't understand why
> it should be this way. The TCP hazards stipulating those timeouts seem
> to apply to accept (connection) socket / port only. Shouldn't listen
> socket's port (the only one we care about) be available for bind
> immediately after the app stops listening on it (either due to closing
> the listen socket or process force kill), or maybe have some other
> timeouts not related to connected accept socket / port hazards? Or am I
> missing something why it should be the way it is done now?
>


To quote your initial message :

<quote>
We are able to avoid this error by adding SO_REUSEADDR attribute to the
socket in a hack. But this hack cannot be added to the application
process as we don't own it.
</quote>

Essentially you are complaining of the linux kernel being unable to
run a buggy application.

We are not going to change the linux kernel because you can not
fix/recompile an application.

Note that you could use LD_PRELOAD, or maybe eBPF to automatically
turn SO_REUSEADDR before bind()


> Thanks,
>      Paul.
>
>
> On 9/30/22 10:16, Eric Dumazet wrote:
> > On Fri, Sep 30, 2022 at 6:24 AM Muhammad Usama Anjum
> > <usama.anjum@collabora.com> wrote:
> >> Hi Eric,
> >>
> >> RFC 1337 describes the TIME-WAIT Assassination Hazards in TCP. Because
> >> of this hazard we have 60 seconds timeout in TIME_WAIT state if
> >> connection isn't closed properly. From RFC 1337:
> >>> The TIME-WAIT delay allows all old duplicate segments time
> >> enough to die in the Internet before the connection is reopened.
> >>
> >> As on localhost there is virtually no delay. I think the TIME-WAIT delay
> >> must be zero for localhost connections. I'm no expert here. On localhost
> >> there is no delay. So why should we wait for 60 seconds to mitigate a
> >> hazard which isn't there?
> > Because we do not specialize TCP stack for loopback.
> >
> > It is easy to force delays even for loopback (tc qdisc add dev lo root
> > netem ...)
> >
> > You can avoid TCP complexity (cpu costs) over loopback using AF_UNIX instead.
> >
> > TIME_WAIT sockets are optional.
> > If you do not like them, simply set /proc/sys/net/ipv4/tcp_max_tw_buckets to 0 ?
> >
> >> Zapping the sockets in TIME_WAIT and FIN_WAIT_2 does removes them. But
> >> zap is required from privileged (CAP_NET_ADMIN) process. We are having
> >> hard time finding a privileged process to do this.
> > Really, we are not going to add kludges in TCP stacks because of this reason.
> >
> >> Thanks,
> >> Usama
> >>
> >>
> >> On 5/24/22 1:18 PM, Muhammad Usama Anjum wrote:
> >>> Hello,
> >>>
> >>> We have a set of processes which talk with each other through a local
> >>> TCP socket. If the process(es) are killed (through SIGKILL) and
> >>> restarted at once, the bind() fails with EADDRINUSE error. This error
> >>> only appears if application is restarted at once without waiting for 60
> >>> seconds or more. It seems that there is some timeout of 60 seconds for
> >>> which the previous TCP connection remains alive waiting to get closed
> >>> completely. In that duration if we try to connect again, we get the error.
> >>>
> >>> We are able to avoid this error by adding SO_REUSEADDR attribute to the
> >>> socket in a hack. But this hack cannot be added to the application
> >>> process as we don't own it.
> >>>
> >>> I've looked at the TCP connection states after killing processes in
> >>> different ways. The TCP connection ends up in 2 different states with
> >>> timeouts:
> >>>
> >>> (1) Timeout associated with FIN_WAIT_1 state which is set through
> >>> `tcp_fin_timeout` in procfs (60 seconds by default)
> >>>
> >>> (2) Timeout associated with TIME_WAIT state which cannot be changed. It
> >>> seems like this timeout has come from RFC 1337.
> >>>
> >>> The timeout in (1) can be changed. Timeout in (2) cannot be changed. It
> >>> also doesn't seem feasible to change the timeout of TIME_WAIT state as
> >>> the RFC mentions several hazards. But we are talking about a local TCP
> >>> connection where maybe those hazards aren't applicable directly? Is it
> >>> possible to change timeout for TIME_WAIT state for only local
> >>> connections without any hazards?
> >>>
> >>> We have tested a hack where we replace timeout of TIME_WAIT state from a
> >>> value in procfs for local connections. This solves our problem and
> >>> application starts to work without any modifications to it.
> >>>
> >>> The question is that what can be the best possible solution here? Any
> >>> thoughts will be very helpful.
> >>>
> >>> Regards,
> >>>
> >> --
> >> Muhammad Usama Anjum
>
>
