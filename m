Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968DC600264
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 19:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiJPR3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 13:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiJPR3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 13:29:01 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6A92DF
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 10:29:00 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id f22so6548241qto.3
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 10:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7p7Rhiz6u+qDWoNX5wKPt5gsaSQ0nnDRRjUPUOoRYns=;
        b=IP+VO4AJyiRQw19GVdWhGxIbewhAS9zr6PcjJu+xgu6VTfK7J1ryG4sZX2NGspQlSu
         /RYp9o0i/NcAxBO6N9xyDo7F/tlSSjHYwopXKukSQp8QFGgwQhCLrI5DjLDaK4NUJ1BW
         t84Wv3Z+OHIKwZPSGFZZI9AhlJQJAWlg1BU3y8JyqFh8o0bjGLxIkxMeXGvpkYeys3l6
         UpemUffpUjhzQTwzjrtD+dzQbkqbRukKV2awPMPzxi86t7XgQ04EhN7w4LebvMyUvCeG
         26olgRk6aZI5ygS2Ck9XmnV80A5BClBW90zU+mgeFDDmUEuB1qvydguPJST19ZUAXKUI
         hrcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7p7Rhiz6u+qDWoNX5wKPt5gsaSQ0nnDRRjUPUOoRYns=;
        b=PFx1dEoVbwXREPImPNBWHAZ9yrNuzK7XW1wYFEXGa/DPlPywTlZQmYtOe727ZFa12X
         cjpxZHUjpeOKARFwGnjYTVdUFCUSe+ikb1mcDBLHecWzdyvpCRjOZeeEgwe6DoSYX8F4
         tk0eekbf/aIRifAA3tbUWbACnDdTizoN11RdJ3dxxw4nvzLHC25c6MGQWM6r08ZflxjQ
         7A+K86frk5kO0NkRycExAaz4HEQ81W1bIDkAPHTFs5e9PtRk4E9CtJxRBbdqi0Y9PVuX
         wPlwZAaQuGNhD+wjKediioLQWTHBEYPYqTEtw72Trr2fu766WP/S594bSvzp4SSYCArL
         DQlQ==
X-Gm-Message-State: ACrzQf2FAVQaQ73KMc3IcU/8MDJqODSXcfi1QmuryVzRrfJyXwn89tns
        5BoVrFCUcXAcDFWBzG6cuYc=
X-Google-Smtp-Source: AMsMyM6HDz841MBCfiHyRBVuKWOUaS3VIqyK/ehK+qRtMUe/d75/a5CACmjbDtLPVp0pc/djMdDo8Q==
X-Received: by 2002:a05:622a:1983:b0:39c:d680:8197 with SMTP id u3-20020a05622a198300b0039cd6808197mr5849397qtc.7.1665941339387;
        Sun, 16 Oct 2022 10:28:59 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:be78:db2a:9fab:4eca])
        by smtp.gmail.com with ESMTPSA id j22-20020ac84416000000b0039cc64bcb53sm6003368qtn.27.2022.10.16.10.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 10:28:58 -0700 (PDT)
Date:   Sun, 16 Oct 2022 10:28:57 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        wizhao@redhat.com, netdev@vger.kernel.org, peilin.ye@bytedance.com
Subject: Re: [PATCH net] net/sched: act_mirred: use the backlog for mirred
 ingress
Message-ID: <Y0w/WWY60gqrtGLp@pop-os.localdomain>
References: <33dc43f587ec1388ba456b4915c75f02a8aae226.1663945716.git.dcaratti@redhat.com>
 <YzCZMHYmk53mQ+HK@pop-os.localdomain>
 <YzxwCy7R0MdWZuO4@dcaratti.users.ipa.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzxwCy7R0MdWZuO4@dcaratti.users.ipa.redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 04, 2022 at 07:40:27PM +0200, Davide Caratti wrote:
> hello Cong, thanks for looking at this!
> 
> On Sun, Sep 25, 2022 at 11:08:48AM -0700, Cong Wang wrote:
> > On Fri, Sep 23, 2022 at 05:11:12PM +0200, Davide Caratti wrote:
> > > William reports kernel soft-lockups on some OVS topologies when TC mirred
> > > "egress-to-ingress" action is hit by local TCP traffic. Indeed, using the
> > > mirred action in egress-to-ingress can easily produce a dmesg splat like:
> > > 
> > >  ============================================
> > >  WARNING: possible recursive locking detected
> 
> [...]
> 
> > >  6.0.0-rc4+ #511 Not tainted
> > >  --------------------------------------------
> > >  nc/1037 is trying to acquire lock:
> > >  ffff950687843cb0 (slock-AF_INET/1){+.-.}-{2:2}, at: tcp_v4_rcv+0x1023/0x1160
> > > 
> > >  but task is already holding lock:
> > >  ffff950687846cb0 (slock-AF_INET/1){+.-.}-{2:2}, at: tcp_v4_rcv+0x1023/0x1160
> 
> FTR, this is:

Yeah, Peilin actually looked deeper into this issue. Let's copy him.

> 
> 2091         sk_incoming_cpu_update(sk);
> 2092
> 2093         bh_lock_sock_nested(sk); <--- the lock reported in the splat
> 2094         tcp_segs_in(tcp_sk(sk), skb);
> 2095         ret = 0;
> 2096         if (!sock_owned_by_user(sk)) {
> 
> > BTW, have you thought about solving the above lockdep warning in TCP
> > layer?
> 
> yes, but that doesn't look like a trivial fix at all - and I doubt it's
> worth doing it just to make mirred and TCP "friends". Please note:
> on current kernel this doesn't just result in a lockdep warning: using
> iperf3 on unpatched kernels it's possible to see a real deadlock, like:

I'd say your test case is rare, because I don't think it is trivial for
a TCP socket to send packets to itself.

 
> > Which also means we can no longer know the RX path status any more,
> > right? I mean if we have filters on ingress, we can't know whether they
> > drop this packet or not, after this patch? To me, this at least breaks
> > users' expectation.
> 
> Fair point! Then maybe we don't need to change the whole TC mirred ingress:
> since the problem only affects egress to ingress, we can preserve the call
> to netif_recive_skb() on ingress->ingress, and just use the backlog in the
> egress->ingress direction _ that has been broken since the very beginning
> and got similar fixes in the past [1]. Something like:

Regarless ingress->ingress or egress->ingress, this patch breaks
users' expectation. And, actually egress->ingress is more common than
ingress->ingress, in my experience.

Thanks.
