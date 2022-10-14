Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECF45FF24F
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 18:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiJNQfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 12:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbiJNQfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 12:35:04 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6E32BB10
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 09:35:01 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 81so6230552ybf.7
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 09:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LHCsWtaFEYAi93gOnkOLAsNfgraMkc8s0asScvbJ6cY=;
        b=C9Xd3zIORVSXFdAzIfAjQxokqqmcpA4caJnK2HJJZM3HVwxdIfGBi15HlgMSQzMKzH
         nxLLdLV2wOIdV/pALDzUfNXG/BM0IYANItQ8UBnkdRopt0dgV3bO36X7LMnp+Km2eiy8
         DwaUgUGN9ioMJKhUO+xf9kg7L1cydmVdqJSG3MfaFT8CMUJ3ugASFivmTX44H2TNpx9U
         6bQ8vxSLLOI/7iA36DNIM1XK5wTsu3tPpbntYTNVZvO+vnBecBpSzr0YWOI1t59X9em6
         pK1ud7AgwOSB5SKRtrjIjd3UM0+SHYvglmqRQEejS8wgsIMZ0fJ1u+J5tGW0T8MfPX0s
         1AGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LHCsWtaFEYAi93gOnkOLAsNfgraMkc8s0asScvbJ6cY=;
        b=IfEaE3bbmvoUB58l0rX/WYuzf3VA1W4c24+Ti98psFUpEyEK7wa5fa1jJXKm0hEIS7
         YqJA9PVx8HFrhZniILBG5RysWDylc3Alo27RaAL13akp5iFBtV/g3RpPPCPJDU2LjcnE
         6uHuQTcu0/hWLK9D5V9bt6Ryn/b9BQjkBK5zX6zoC8Au25eHxom24HAx2Xjv3Lzg4bJr
         08UM5oe8IRaNwx9aAEngRKvy8DnbFMAyQE0Ew/fJNCcH2O9SEdW8WkP4SudTM195cKb0
         TcsikCJwc1jd05/26xpVGoVPzRc4j1x7fRI2xt2UIIHg3FIhipbMqOaS4p/xRtxfD8K+
         CHiQ==
X-Gm-Message-State: ACrzQf3j4gAXvlLF1NKF1q7Qouqj2owrCAk2cFY7v8PSOVA7ZFCSwdMs
        Yg29TKso1eRjkjgWMRss9C+gpSUVKSodxnxhnQLjJg==
X-Google-Smtp-Source: AMsMyM7T75EL2OfdJ/PvsOxdk8p14j39bi0DheYXm3SysdaBgvQc0xvGclO2ikTHHKMF4dMXECJXtmNAFnmuHg6tH1Y=
X-Received: by 2002:a05:6902:563:b0:6be:5f26:b9b7 with SMTP id
 a3-20020a056902056300b006be5f26b9b7mr5519304ybt.36.1665765300585; Fri, 14 Oct
 2022 09:35:00 -0700 (PDT)
MIME-Version: 1.0
References: <5099dc39-c6d9-115a-855b-6aa98d17eb4b@collabora.com>
 <8dff3e46-6dac-af6a-1a3b-e6a8b93fdc60@collabora.com> <CANn89iLOdgExV3ydkg0r2iNwavSp5Zu9hskf34TTqmCZQCfUdA@mail.gmail.com>
 <5db967de-ea7e-9f35-cd74-d4cca2fcb9ee@codeweavers.com> <CANn89iJTNUCDLptS_rV4JUDcEH8JNXvOTx4xgzvaDHG6eodtXg@mail.gmail.com>
 <81b0e6c9-6c13-aecd-1e0e-6417eb89285f@codeweavers.com>
In-Reply-To: <81b0e6c9-6c13-aecd-1e0e-6417eb89285f@codeweavers.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 14 Oct 2022 09:34:47 -0700
Message-ID: <CANn89iKD=ceuLnhK-zpk3QerpS-FUb_wb_HevkpvsVqGJ_T4NQ@mail.gmail.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 9:31 AM Paul Gofman <pgofman@codeweavers.com> wrote:
>
> Hello Eric,
>
>      that message was not mine.
>
>      Speaking from the Wine side, we cannot workaround that with
> SO_REUSEADDR. First of all, it is under app control and we can't
> voluntary tweak app's socket settings. Then, app might be intentionally
> not using SO_REUSEADDR to prevent port reuse which of course may be
> harmful (more harmful than failure to restart for another minute). What
> is broken with the application which doesn't want to use SO_REUSEADDR
> and wants to disallow port reuse while it binds to it which reuse will
> surely break it?
>
>      But my present question about the listening socket being not
> reusable while closed due to linked accepeted socket was not related to
> Wine at all. I am not sure how one can fix that in the application if
> they don't really want other applications or another copy of the same
> one to be able to reuse the port they currently bind to? I believe the
> issue with listen socket been not available happens rather often for
> native services and they all have to workaround that. While not related
> here, I also encountered some out-of-tree hacks to tweak the TIME_WAIT
> timeout to tackle this very problem for some cloud custom kernels.
>
>      My question is if the behaviour of blocking listen socket port
> while the accepted port (which, as I understand, does not have any
> direct relation to listen port anymore from TCP standpoint) is still in
> TIME_ or other wait is stipulated by TCP requirements which I am
> missing? Or, if not, maybe that can be changed?
>

Please raise these questions at IETF, this is where major TCP changes
need to be approved.

There are multiple ways to avoid TIME_WAIT, if you really need to.


> Thanks,
>      Paul.
>
>
> On 10/14/22 11:20, Eric Dumazet wrote:
> > On Fri, Oct 14, 2022 at 8:52 AM Paul Gofman <pgofman@codeweavers.com> wrote:
> >> Hello Eric,
> >>
> >> our problem is actually not with the accept socket / port for which
> >> those timeouts apply, we don't care for that temporary port number. The
> >> problem is that the listen port (to which apps bind explicitly) is also
> >> busy until the accept socket waits through all the necessary timeouts
> >> and is fully closed. From my reading of TCP specs I don't understand why
> >> it should be this way. The TCP hazards stipulating those timeouts seem
> >> to apply to accept (connection) socket / port only. Shouldn't listen
> >> socket's port (the only one we care about) be available for bind
> >> immediately after the app stops listening on it (either due to closing
> >> the listen socket or process force kill), or maybe have some other
> >> timeouts not related to connected accept socket / port hazards? Or am I
> >> missing something why it should be the way it is done now?
> >>
> >
> > To quote your initial message :
> >
> > <quote>
> > We are able to avoid this error by adding SO_REUSEADDR attribute to the
> > socket in a hack. But this hack cannot be added to the application
> > process as we don't own it.
> > </quote>
> >
> > Essentially you are complaining of the linux kernel being unable to
> > run a buggy application.
> >
> > We are not going to change the linux kernel because you can not
> > fix/recompile an application.
> >
> > Note that you could use LD_PRELOAD, or maybe eBPF to automatically
> > turn SO_REUSEADDR before bind()
> >
> >
> >> Thanks,
> >>       Paul.
> >>
> >>
> >> On 9/30/22 10:16, Eric Dumazet wrote:
> >>> On Fri, Sep 30, 2022 at 6:24 AM Muhammad Usama Anjum
> >>> <usama.anjum@collabora.com> wrote:
> >>>> Hi Eric,
> >>>>
> >>>> RFC 1337 describes the TIME-WAIT Assassination Hazards in TCP. Because
> >>>> of this hazard we have 60 seconds timeout in TIME_WAIT state if
> >>>> connection isn't closed properly. From RFC 1337:
> >>>>> The TIME-WAIT delay allows all old duplicate segments time
> >>>> enough to die in the Internet before the connection is reopened.
> >>>>
> >>>> As on localhost there is virtually no delay. I think the TIME-WAIT delay
> >>>> must be zero for localhost connections. I'm no expert here. On localhost
> >>>> there is no delay. So why should we wait for 60 seconds to mitigate a
> >>>> hazard which isn't there?
> >>> Because we do not specialize TCP stack for loopback.
> >>>
> >>> It is easy to force delays even for loopback (tc qdisc add dev lo root
> >>> netem ...)
> >>>
> >>> You can avoid TCP complexity (cpu costs) over loopback using AF_UNIX instead.
> >>>
> >>> TIME_WAIT sockets are optional.
> >>> If you do not like them, simply set /proc/sys/net/ipv4/tcp_max_tw_buckets to 0 ?
> >>>
> >>>> Zapping the sockets in TIME_WAIT and FIN_WAIT_2 does removes them. But
> >>>> zap is required from privileged (CAP_NET_ADMIN) process. We are having
> >>>> hard time finding a privileged process to do this.
> >>> Really, we are not going to add kludges in TCP stacks because of this reason.
> >>>
> >>>> Thanks,
> >>>> Usama
> >>>>
> >>>>
> >>>> On 5/24/22 1:18 PM, Muhammad Usama Anjum wrote:
> >>>>> Hello,
> >>>>>
> >>>>> We have a set of processes which talk with each other through a local
> >>>>> TCP socket. If the process(es) are killed (through SIGKILL) and
> >>>>> restarted at once, the bind() fails with EADDRINUSE error. This error
> >>>>> only appears if application is restarted at once without waiting for 60
> >>>>> seconds or more. It seems that there is some timeout of 60 seconds for
> >>>>> which the previous TCP connection remains alive waiting to get closed
> >>>>> completely. In that duration if we try to connect again, we get the error.
> >>>>>
> >>>>> We are able to avoid this error by adding SO_REUSEADDR attribute to the
> >>>>> socket in a hack. But this hack cannot be added to the application
> >>>>> process as we don't own it.
> >>>>>
> >>>>> I've looked at the TCP connection states after killing processes in
> >>>>> different ways. The TCP connection ends up in 2 different states with
> >>>>> timeouts:
> >>>>>
> >>>>> (1) Timeout associated with FIN_WAIT_1 state which is set through
> >>>>> `tcp_fin_timeout` in procfs (60 seconds by default)
> >>>>>
> >>>>> (2) Timeout associated with TIME_WAIT state which cannot be changed. It
> >>>>> seems like this timeout has come from RFC 1337.
> >>>>>
> >>>>> The timeout in (1) can be changed. Timeout in (2) cannot be changed. It
> >>>>> also doesn't seem feasible to change the timeout of TIME_WAIT state as
> >>>>> the RFC mentions several hazards. But we are talking about a local TCP
> >>>>> connection where maybe those hazards aren't applicable directly? Is it
> >>>>> possible to change timeout for TIME_WAIT state for only local
> >>>>> connections without any hazards?
> >>>>>
> >>>>> We have tested a hack where we replace timeout of TIME_WAIT state from a
> >>>>> value in procfs for local connections. This solves our problem and
> >>>>> application starts to work without any modifications to it.
> >>>>>
> >>>>> The question is that what can be the best possible solution here? Any
> >>>>> thoughts will be very helpful.
> >>>>>
> >>>>> Regards,
> >>>>>
> >>>> --
> >>>> Muhammad Usama Anjum
> >>
>
