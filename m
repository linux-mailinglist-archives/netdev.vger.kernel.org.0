Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981EF3899F1
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 01:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhESXhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 19:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhESXhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 19:37:43 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8326C061574;
        Wed, 19 May 2021 16:36:22 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id lx17-20020a17090b4b11b029015f3b32b8dbso2630848pjb.0;
        Wed, 19 May 2021 16:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3yEfjY9MJ8K/vO05lVtPVMVr2Xa3KL3Rhs/sakLXU4E=;
        b=cqY9Zi2H/abRKZWNJYODAnpRVR9T4ZA0iZg3fYWMMCdZW0A0SPHV2xl02crukP7aWJ
         0Sib9+sMgSgjKUSJfcmCoyn88F6u7M+UgWyIbcuffDwsUcKr4vaLqzuk3DqxnREPtDc3
         ktlAp+QovLQgVyyiecsoGoC8lSydHOP1R52OJLJ3ChsXRfg5kmi8LTZS5tgwE4dnoAYN
         k0yvW+VXh98NUVuWk0ZhCP5B3HqnRT/tPa5Kpzy/rpCn5WldsNf29/kGGidWXKfPldk4
         0fEM9JKg/i0yHqrmlFUmsZms5rY97cYJ50d++9r697Bowb6ib3O1jPxefBIbL4jya3fW
         2AnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3yEfjY9MJ8K/vO05lVtPVMVr2Xa3KL3Rhs/sakLXU4E=;
        b=n9CAkPZSgRWf/GNWPTpBXpX3G28+UHC49DNxrx3qzGqK7ecZ0/TGwrDuS2SuoN+DAL
         yyfFVgPqlOVRugvTuOzRZxid5h9WFOCNw+BRCA+Srk7+wAH14zIwGLHsvmoPDyNIAP6M
         rquuCFl1PDNXB7roehXDxDaoOuFKeOesskgjTaAWo5xXB/Q3bhLA0FgGB21D/TdgSw7g
         vERdaGe8v6VCNsMHfCe/m+/OEWDxs5hIDAzYpJxJVBIcc9T6MD2a14AvxLfxNSk0iTOu
         DPiv5qhcCTTdYPCLrL8GyZ4bj2Z+Tjl1Qf2xoDMEG7syCuLFEEL87xCatNxgb5kHYiaz
         r3zw==
X-Gm-Message-State: AOAM532G5MkE3dLaEysSdiq/3SV23tZNanbN/dHU8pHQyUw/q5UaCQaU
        7ntDX01t52MxGv1eMXgG6OtHmd9TSb6Ln62wRyY=
X-Google-Smtp-Source: ABdhPJzT7P2aLGz5PKANTt8yCogoA7LfGFy7vVxwy4T9EpODEq39mN5t/2nkUsH0FN7Ou7p4KoPEnxQiKIwMaGKmAA4=
X-Received: by 2002:a17:90a:c38c:: with SMTP id h12mr1918548pjt.145.1621467382362;
 Wed, 19 May 2021 16:36:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210519204132.107247-1-xiyou.wangcong@gmail.com> <60a5896ca080d_2aaa720821@john-XPS-13-9370.notmuch>
In-Reply-To: <60a5896ca080d_2aaa720821@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 19 May 2021 16:36:11 -0700
Message-ID: <CAM_iQpUC6ZOiH=ifUe1+cdXtTgiBMwPVLSsWB9zwBA7gWh8mgA@mail.gmail.com>
Subject: Re: [Patch bpf] selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 2:56 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > We use non-blocking sockets for testing sockmap redirections,
> > and got some random EAGAIN errors from UDP tests.
> >
> > There is no guarantee the packet would be immediately available
> > to receive as soon as it is sent out, even on the local host.
> > For UDP, this is especially true because it does not lock the
> > sock during BH (unlike the TCP path). This is probably why we
> > only saw this error in UDP cases.
> >
> > No matter how hard we try to make the queue empty check accurate,
> > it is always possible for recvmsg() to beat ->sk_data_ready().
> > Therefore, we should just retry in case of EAGAIN.
> >
> > Fixes: d6378af615275 ("selftests/bpf: Add a test case for udp sockmap")
> > Reported-by: Jiang Wang <jiang.wang@bytedance.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  tools/testing/selftests/bpf/prog_tests/sockmap_listen.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > index 648d9ae898d2..b1ed182c4720 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > @@ -1686,9 +1686,13 @@ static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
> >       if (pass != 1)
> >               FAIL("%s: want pass count 1, have %d", log_prefix, pass);
> >
> > +again:
> >       n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
> > -     if (n < 0)
> > +     if (n < 0) {
> > +             if (errno == EAGAIN)
> > +                     goto again;
> >               FAIL_ERRNO("%s: read", log_prefix);
>
> Needs a counter and abort logic we don't want to loop forever in the
> case the packet is lost.

It should not be lost because selftests must be self-contained,
if the selftests could not even predict whether its own packet is
lost or not, we would have a much bigger trouble than just this
infinite loop.

Thanks.
