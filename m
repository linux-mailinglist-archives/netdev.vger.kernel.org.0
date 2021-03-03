Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3ECF32C40A
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381226AbhCDAKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843085AbhCCKZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 05:25:40 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EB8C08EE14
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 02:20:40 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id y12so15003290ljj.12
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 02:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6ZzZe7TdfnaQkJ2BQSiLi0sfapl5wblvBplr2CPmG9Y=;
        b=v4EFL5/5F0w0BU1IHEDrOcZpU6vfDxDtpwdoZSPKptbim5t51FovvKdDP5x7vZEptG
         yLgJwoTmRenkjMg8xGakzSedbD7a0PhbrVW1PB+0VEfDupSe4vsX6JasQ88mgBLUqCED
         JPGdq5odKCHbGWlQfh02EOUYHy/y8MBk/wkMY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6ZzZe7TdfnaQkJ2BQSiLi0sfapl5wblvBplr2CPmG9Y=;
        b=YGqFxRHYuW7rvuiWja3IgMb3KZ4kPVvWsiu+wvm53DXI4VsxgqiTkqzU0Sx27mSGk3
         nK0xXLDhiysFgB0GWV3NBNVBzK27qYQ+CJBaBxWyZoFXfuemrVC/K7N8B/mQzx2g8ucF
         an9NL4wZuhXKPlbw6PB/aPX5pLGQwLmrSF9bzLW1SnuZCoDvDlMRPF2GzCGIZit2Gt1y
         y7hpIyJdwJ69eetXT5Y7L7/FHns3Q/mSvN7DKBUicwWaRQLSnmGpGypFABorS8PQepIs
         Y9w3IWdl1f1JmGop4lzorAuQMUTcuDWq5/gr7OK3zodkLjmBViAm35BgYBCj0puwMMa6
         sTRg==
X-Gm-Message-State: AOAM530qHLl253Vww7f1/6FMrv5yBazLIJ7iP6j0cf9Qni/qe6VmCSak
        /JglXB6XNFAOYmOflIdI4u1Ck1hhSj4BxQmgziVcnA==
X-Google-Smtp-Source: ABdhPJw/uUxlUG2+FPowYgOmfK6n59mDvGvavLiin745XVUWwncbWfl3RTFwgilCdcB+7lsHNSpn+sYm5l2b29qj2gM=
X-Received: by 2002:a2e:b172:: with SMTP id a18mr2770249ljm.223.1614766839387;
 Wed, 03 Mar 2021 02:20:39 -0800 (PST)
MIME-Version: 1.0
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
 <20210302023743.24123-10-xiyou.wangcong@gmail.com> <CACAyw9-wmN-pGYPkk4Ey_bazoycWAn+1-ewccTKeo-ebpHqyPA@mail.gmail.com>
 <CAM_iQpX3qqpKyOW2ohYo0e-5GO_wpoBBqv1BnrLLRsufMwO2rg@mail.gmail.com>
In-Reply-To: <CAM_iQpX3qqpKyOW2ohYo0e-5GO_wpoBBqv1BnrLLRsufMwO2rg@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 3 Mar 2021 10:20:28 +0000
Message-ID: <CACAyw98WfDE5HKP8NDHa5V2JzzXUyuWHnfnXNRUgxGvktZ5VBA@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 9/9] selftests/bpf: add a test case for udp sockmap
To:     Cong Wang <xiyou.wangcong@gmail.com>
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

On Tue, 2 Mar 2021 at 18:05, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, Mar 2, 2021 at 8:32 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > On Tue, 2 Mar 2021 at 02:38, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > Add a test case to ensure redirection between two UDP sockets work.
> >
> > I basically don't understand how splicing works, but watching from the
> > sidelines makes me think it'd be good to have more thorough tests.
> > tools/testing/selftests/bpf/test_sockmap.c has quite elaborate tests
> > for the TCP part, it'd be nice to get similar tests going for UDP. For
>
> Sure, TCP supports more than just BPF_SK_SKB_VERDICT, hence
> why it must have more tests than UDP. ;)
>
> > example:
> >
> > * sendfile?
> > * sendmmsg
>
> Does UDP support any of these? I don't think so, at least not in my
> patchset.

I have no idea, thanks for checking :)

>
> > * Something Jakub mentioned: what happens when a connected, spliced
> > socket is disconnected via connect(AF_UNSPEC)? Seems like we don't
> > hook sk_prot->disconnect anywhere.
>
> But we hook ->unhash(), right?

I wasn't aware that ->disconnect calls unhash, thanks!

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
