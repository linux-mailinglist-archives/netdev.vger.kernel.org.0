Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A793532DE0D
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 00:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbhCDXwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 18:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbhCDXwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 18:52:15 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E12C061574;
        Thu,  4 Mar 2021 15:52:15 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o6so638884pjf.5;
        Thu, 04 Mar 2021 15:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fadd0zSuZzIQV4r5RKl+dMh5cMT2xl4Leib55/WlQc8=;
        b=OXbJZBA4tA1J/OvEiQr75wjBVeUF9il7FxTmAE3HXaSfIy6ma+r4ukC+fthy3iiwAr
         kUzBv1Uf61aqxvE2RIbHak6hDuu185ESXINR+1PWvESrKsocB30EpAl3WPRq+oHjaJ6r
         wjGL/vGPBFhyk7UkJnQaDi9970F9qTp6sX0COjGY1P6pVHf2uFNZwg6DYO/xkSsLtgP6
         eXQ5jY7tPBErR+lMYTziNDKIsE2GUkvBlq+yrD3dca3BYlKLS/P1eegBZ04ds3WhXBh/
         Cb2My29ps9AqhJZWZVlbH9lqpRXLYKX8unmK2J1ACPhyybGo95a3LS7s5TGdWWIsKi0Y
         lrCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fadd0zSuZzIQV4r5RKl+dMh5cMT2xl4Leib55/WlQc8=;
        b=DxeXTdEUmJqHoS7zKEUfcHHeANDoowt7zzqu4QVUssh1v9AxhW2v9uS4A+f/1HoeqT
         zQNYlBzzRYNSyT+UL6Sy8h8mXYqhhVAmHomrUlvLrwFZSi/6aRnbdEJdvBLN8MAn5UX3
         3ixDwkE8b4B7QyAeXzZqb6E0NpPeuAbufXwAr7TU2zvLkwuNtQER1DP/owTSi+JqrDld
         1HK3heWhRyo367AjYs/ZrtTZBk5BgelGVR7+qNE5So8V7p79sZa0Uz7pwXmyL4cG/pBu
         3Av+oi73i5H3VzPncbdsd/HHt96GbUBoSr7diK8rrS6guks0d6akW1rHCt6WpaFgXrch
         YgHw==
X-Gm-Message-State: AOAM533tOf76YOMpk4mVL/x+nobfckBjbn01drH5Su6JbeoBvjMMnPBi
        8bmo0Lf1M1+MpnPGpURCyAGgVG/u7/inFxUBjvc=
X-Google-Smtp-Source: ABdhPJw9yEMwMJ2qrlezXjVOvmM4W5rUiqcPI0hb6vPk06jImdx0sCi6VijyGDRaT04Uq/tuHovnI4xSkFesJoO4mUI=
X-Received: by 2002:a17:90a:ce92:: with SMTP id g18mr7280315pju.52.1614901934978;
 Thu, 04 Mar 2021 15:52:14 -0800 (PST)
MIME-Version: 1.0
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
 <20210302023743.24123-3-xiyou.wangcong@gmail.com> <CACAyw9-SjsNn4_J1KDXuFh1nd9Hr-Mo+=7S-kVtooJwdi1fodQ@mail.gmail.com>
 <CAM_iQpXqE9qJ=+zKA6H1Rq=KKgm8LZ=p=ZtvrrH+hfSrTg+zxw@mail.gmail.com>
In-Reply-To: <CAM_iQpXqE9qJ=+zKA6H1Rq=KKgm8LZ=p=ZtvrrH+hfSrTg+zxw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 4 Mar 2021 15:52:03 -0800
Message-ID: <CAM_iQpXXUv1FV8DQ85a2fs08JCfKHHt-fAWYbV0TTWmwUZ-K5Q@mail.gmail.com>
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

On Tue, Mar 2, 2021 at 10:23 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, Mar 2, 2021 at 8:22 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > On Tue, 2 Mar 2021 at 02:37, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > ...
> > >  static inline void sk_psock_restore_proto(struct sock *sk,
> > >                                           struct sk_psock *psock)
> > >  {
> > >         sk->sk_prot->unhash = psock->saved_unhash;
> >
> > Not related to your patch set, but why do an extra restore of
> > sk_prot->unhash here? At this point sk->sk_prot is one of our tcp_bpf
> > / udp_bpf protos, so overwriting that seems wrong?
>
> Good catch. It seems you are right, but I need a double check. And
> yes, it is completely unrelated to my patch, as the current code has
> the same problem.

Looking at this again. I noticed

commit 4da6a196f93b1af7612340e8c1ad8ce71e18f955
Author: John Fastabend <john.fastabend@gmail.com>
Date:   Sat Jan 11 06:11:59 2020 +0000

    bpf: Sockmap/tls, during free we may call tcp_bpf_unhash() in loop

intentionally fixed a bug in kTLS with overwriting this ->unhash.

I agree with you that it should not be updated for sockmap case,
however I don't know what to do with kTLS case, it seems the bug the
above commit fixed still exists if we just revert it.

Anyway, this should be targeted for -bpf as a bug fix, so it does not
belong to this patchset.

Thanks.
