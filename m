Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7583082BD
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhA2Ay4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhA2Ayx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 19:54:53 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DAFC061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 16:54:12 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id c1so5623213qtc.1
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 16:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netflix.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KO9cyGUN/VAmiWfEXbjNMDmR2Ez9fjBoN5WHJiTrZq8=;
        b=r7IODK/W50P7Rv+5vZG1BLCtM8ucZTfKrDz37euGQDCL6iI8+911Nx+79p3f1B7e2a
         /r/dEm5H5v7eZQ7RDAzf93NL4JuNhRCs/NZgznyL3DfmSttU0rToelhnSoqp0vJeytk8
         zBDtu7s4JQKX3j2o90WZ5ZKQq2x85xQo++9mo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KO9cyGUN/VAmiWfEXbjNMDmR2Ez9fjBoN5WHJiTrZq8=;
        b=JqDQT56hurY0qK2T4ZzSGAXMwFu6Thpa2q/9RnFBAJD4Jq5qZd4WeLUj+nw6Sq1RPi
         XjHqrz9oOqMcuUf7/P8oj9Y/5Vb4XMoNGjo+Ny2cyNpS7FnfhmLUZIQoECT0vDvtmQ5V
         TO6rpyJY+oUUMM2H4tYjjNmiPUBwaf0lMr+Gv7hv1EjaRaQE9fMUbZEuQMXy/bCRKUgn
         QQROHZvWx59oUmJhU2dUkdnHJmfu4GTHoiGrL14GxyH0VCZaDnrvGhmzBXSj+7Qrac2L
         EcB3EF8mxabMJxFDadm8XQr2v65QK58d7f0eH2I4S9d1bkGYPI+ByfQRpzhhl1y5fAyj
         Qytw==
X-Gm-Message-State: AOAM533BJcYSST9UuzF7gi6BM6Vof7oRKUC0EZqftSyg0N7WhCaNaSDr
        +8DkQiCildZtk+jMuDxXz56pofZk0i3LldoyPpfyHA==
X-Google-Smtp-Source: ABdhPJz1Moyzxs/7IQ/XxGZkkAJGYxlMiaxkNq2McF6z39UNOP1+BlbM0mOT0zdfph8RRvUFBnfZhSCkNyQbGGlfF9U=
X-Received: by 2002:ac8:5156:: with SMTP id h22mr2304274qtn.176.1611881651861;
 Thu, 28 Jan 2021 16:54:11 -0800 (PST)
MIME-Version: 1.0
References: <20210129001210.344438-1-hari@netflix.com> <CAADnVQJE+nVoCsCxQDdy9SgdMRhrWePzRF__vrZSN2-wBFc+0g@mail.gmail.com>
In-Reply-To: <CAADnVQJE+nVoCsCxQDdy9SgdMRhrWePzRF__vrZSN2-wBFc+0g@mail.gmail.com>
From:   Brendan Gregg <bgregg@netflix.com>
Date:   Fri, 29 Jan 2021 11:53:45 +1100
Message-ID: <CAJN39oiqwj-mFim_L=TrxRKjJqMezHpH5u+_fQAyaXq6D1AZcg@mail.gmail.com>
Subject: Re: [PATCH] net: tracepoint: exposing sk_family in all tcp:tracepoints
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Hariharan Ananthakrishnan <hari@netflix.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 11:16 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jan 28, 2021 at 4:12 PM Hariharan Ananthakrishnan
> <hari@netflix.com> wrote:
> >
> > Similar to sock:inet_sock_set_state tracepoint, expose sk_family to
> > distinguish AF_INET and AF_INET6 families.
> >
> > The following tcp tracepoints are updated:
> > tcp:tcp_destroy_sock
> > tcp:tcp_rcv_space_adjust
> > tcp:tcp_retransmit_skb
> > tcp:tcp_send_reset
> > tcp:tcp_receive_reset
> > tcp:tcp_retransmit_synack
> > tcp:tcp_probe
> >
> > Signed-off-by: Hariharan Ananthakrishnan <hari@netflix.com>
> > Signed-off-by: Brendan Gregg <bgregg@netflix.com>
> > ---
> >  include/trace/events/tcp.h | 20 ++++++++++++++++----
> >  1 file changed, 16 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
> > index cf97f6339acb..a319d2f86cd9 100644
> > --- a/include/trace/events/tcp.h
> > +++ b/include/trace/events/tcp.h
> > @@ -59,6 +59,7 @@ DECLARE_EVENT_CLASS(tcp_event_sk_skb,
> >                 __field(int, state)
> >                 __field(__u16, sport)
> >                 __field(__u16, dport)
> > +               __field(__u16, family)
> >                 __array(__u8, saddr, 4)
> >                 __array(__u8, daddr, 4)
> >                 __array(__u8, saddr_v6, 16)
>
> raw tracepoint can access all sk and skb fields already.
> Why do you need this?


We (Netflix) can dig it out using raw tracepoints and BTF (once it's
rolled out) but this was about fixing the existing tracepoints so they
were more useful.

I think tracepoints and their arguments suit a class of
non-kernel-hacker users: SREs, operators, sysadmins, etc. People who
run and tweak bpftrace one-liners.

Brendan

-- 
Brendan Gregg, Senior Performance Architect, Netflix
