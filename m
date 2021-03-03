Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAED32C49B
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446596AbhCDAPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235407AbhCCSVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 13:21:49 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0F1C061756;
        Wed,  3 Mar 2021 10:21:00 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id p5so14512171plo.4;
        Wed, 03 Mar 2021 10:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4y/QfsQkpSYAAw3hafZnj/vlVNmoohVbhAhRflF0msE=;
        b=Y2vi2+SsRGMrGqyRdtJVXtgo81th8sHAP2XUVa58pJ2xSSbnqcmNIQNWFikWe620hb
         pqi/YZibfco/l8UQQqGmCdlUQzj2zlRp+0GQBaL0swQPAPjTZteVxOCprJqTHMGZzaxA
         SrR1rOMbsgJFpgu+z4F6LKZJ4PZXhvAQyB2g1ugj/0M+wF4I2JK8N7tNNr0AruIQ6ImR
         UAl7NctZ5Di/ahbaC+5mDlqboIBFB2DRZWUu9cq/5fSgqA0RDh5uO+vdWhs/96QIhOR0
         se/VcXFunnVZw8/Nr36671XyEOz9ZvM3v+kWKe7P4S/ouoScJ3dFGHjWM5Daz4P9u5lw
         bqyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4y/QfsQkpSYAAw3hafZnj/vlVNmoohVbhAhRflF0msE=;
        b=HuWWmRCcSL+O8wz9GUd4pwuKmOELe3vfUvNW5jMFJ93thd8oyW0IuraJXxWTjfPNNJ
         Yfhd5JVbcV7AWVSMWz2Xx8QP9WqcFV4789qQmciZx3FXrQBVi1CpRQpBTaEooIYnXn8f
         MmfXLdw9VjpZUdJjXlhN6pMVfPLyQeGobSzFUlZCEINMlL+1VOE/7KgbXQVRZoQRM44z
         opKwowGqh2pU9XY0o0aQL5T20QAOK4Ng5wMH4Yd1uUJmhT3W5MTal2pPpMT/Ha0MGrLr
         3gWXdhL/2e90k0mEOPWcfqlT99K+7GotorxXZhUBkjo4NtlsTU955gDdsA4ak2X2Leag
         q5yQ==
X-Gm-Message-State: AOAM531723M1SrlwNea0Eeiut2mMGo79B0a0VpRIbvBbpRCanR/YV5Zy
        mviN0rMxPzzAnT/y9ocF0S89N3Md7YiBjeKOrNF+72zoHydzVw==
X-Google-Smtp-Source: ABdhPJwt7MsDgz3wz0vGvxGbaLE8IMd0EM9FVlHiqhcqXYfye8y0P6MXLs+oU/wiiRdwPqL2ETl7jHLHhRwoYy5ipr8=
X-Received: by 2002:a17:902:f781:b029:e4:419b:e891 with SMTP id
 q1-20020a170902f781b02900e4419be891mr464680pln.10.1614795660095; Wed, 03 Mar
 2021 10:21:00 -0800 (PST)
MIME-Version: 1.0
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
 <20210302023743.24123-3-xiyou.wangcong@gmail.com> <CACAyw9-SjsNn4_J1KDXuFh1nd9Hr-Mo+=7S-kVtooJwdi1fodQ@mail.gmail.com>
 <CAM_iQpXqE9qJ=+zKA6H1Rq=KKgm8LZ=p=ZtvrrH+hfSrTg+zxw@mail.gmail.com> <CACAyw99BweMk-82f270=Vb=jDuec0q0N-6E8Rr8enaOGuZEDNQ@mail.gmail.com>
In-Reply-To: <CACAyw99BweMk-82f270=Vb=jDuec0q0N-6E8Rr8enaOGuZEDNQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 3 Mar 2021 10:20:48 -0800
Message-ID: <CAM_iQpWHTvFPifcPL-x64fWqY5k8yP9vu6Bnp8D-HdpUp6vs6g@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/9] sock: introduce sk_prot->update_proto()
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 3, 2021 at 1:35 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Tue, 2 Mar 2021 at 18:23, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > > if the function returned a struct proto * like it does at the moment.
> > > That way we keep sk->sk_prot manipulation confined to the sockmap code
> > > and don't have to copy paste it into every proto.
> >
> > Well, TCP seems too special to do this, as it could call tcp_update_ulp()
> > to update the proto.
>
> I had a quick look, tcp_bpf_update_proto is the only caller of tcp_update_ulp,
> which in turn is the only caller of icsk_ulp_ops->update, which in turn is only
> implemented as tls_update in tls_main.c. Turns out that tls_update
> has another one of these calls:
>
> } else {
>     /* Pairs with lockless read in sk_clone_lock(). */
>     WRITE_ONCE(sk->sk_prot, p);
>     sk->sk_write_space = write_space;
> }
>
> Maybe it looks familiar? :o) I think it would be a worthwhile change.

Yeah, I am not surprised we can change tcp_update_ulp() too, but
why should I bother kTLS when I do not have to? What you suggest
could at most save us a bit of code size, not a big gain. So, I'd keep
its return value as it is, unless you see any other benefits.

BTW, I will rename it to 'psock_update_sk_prot', please let me know
if you have any better names.

Thanks.
