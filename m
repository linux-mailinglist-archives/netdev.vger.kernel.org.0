Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99C8349E4F
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 02:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhCZA7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhCZA7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 20:59:07 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A2EC06174A;
        Thu, 25 Mar 2021 17:59:07 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id u10so3799378ilb.0;
        Thu, 25 Mar 2021 17:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=b+QuLFs25xD/TOa7Xgr20Ia5iasnh00VI9DM563nNfg=;
        b=pM2o3OASBlmTNkEx6kMud1R7DtUMHOXOyyLOFHsqrRt3NZneijWGayO7EQc2l4v2Gm
         4AOj3dKHyR4KOkrVUWVvh5K+z9jCoIfJVzD28231VsW/33VrBx1fBwsfHT1oTSlmHoxw
         7k0bVAoOBUjP8BtULusT8ucCgD/zYzCgftnYXa4nxMuewhveop1CgBBgwJmqBA+cLUjV
         vX4qLDillk/9svDi9VmWGWw9jmpc7V+DPu+96BAGi1RHXr+biEYUds0H18qFLJ2BFXZP
         YOJFi4jcQfEY0KgrjmR+JDB9lBNFgZftVZJsueBhJjaiKpiw1WkfV6laiOLETmCQXlyA
         U9Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=b+QuLFs25xD/TOa7Xgr20Ia5iasnh00VI9DM563nNfg=;
        b=tdNbU5ZMdv7Y8JPCm0K735Z0cJNKI093gBoATy1OaGHsyPLxIBQ2+mqD4kyV0TKQA5
         8h3m5VO+0NrLIt+069+RJ8sKwSSFFDMhmwt4otUrUCfQMwUXCLyDwScFMmUg4FAnShFq
         T1pNZhLXWGZru7jDmVW8NKb6y9WSqF3CXn4hHYn5P96/roIfc2aI3xsghmufN18Ug8CA
         IXPQXErUMVhGdkGOuxXCyziFMNuSxnYbQ4aZAoFlVeaozZdLSfK4O0hUDnrNobsOweaF
         R88hSc0jn8VeBRN11iJaDjXkSaw7dmV5JUG8o2KQ1/RvJ/noGnREiPJQiAsqLFkRBkI+
         IGvA==
X-Gm-Message-State: AOAM533Cj9/S9AZI2yVWV0NkwYcOZfPy/aX5yNIfzMflLDakEQ9k7L+B
        qlfzqAtm0qzWawh5IkTVdn4=
X-Google-Smtp-Source: ABdhPJzSgt64qOWCPLJea0V8PxgNdfjb381FQg2W8IWOpNPr2y1ne3qu7YLJYKZBg8tZtEfqQCMLrg==
X-Received: by 2002:a92:c505:: with SMTP id r5mr6693217ilg.255.1616720346700;
        Thu, 25 Mar 2021 17:59:06 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id x2sm3417298ilv.36.2021.03.25.17.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 17:59:06 -0700 (PDT)
Date:   Thu, 25 Mar 2021 17:58:59 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <605d31d3782bc_938e520815@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpWzoP9SOQcMPB--jp6C_xnUVAmVtS4yMCN43kL248y4QA@mail.gmail.com>
References: <161661943080.28508.5809575518293376322.stgit@john-Precision-5820-Tower>
 <161661958954.28508.16923012330549206770.stgit@john-Precision-5820-Tower>
 <CAM_iQpVShCqWx1CYUOO9SrgWw7ztVP6j=v=W9dAd9FbChGZauQ@mail.gmail.com>
 <605bf9718f2fc_64fde2082b@john-XPS-13-9370.notmuch>
 <CAM_iQpWzoP9SOQcMPB--jp6C_xnUVAmVtS4yMCN43kL248y4QA@mail.gmail.com>
Subject: Re: [bpf PATCH 2/2] bpf, sockmap: fix incorrect fwd_alloc accounting
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Wed, Mar 24, 2021 at 7:46 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > On Wed, Mar 24, 2021 at 2:00 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > > >
> > > > Incorrect accounting fwd_alloc can result in a warning when the socket
> > > > is torn down,
> > > >
> >
> > [...]
> >
> > > > To resolve lets only account for sockets on the ingress queue that are
> > > > still associated with the current socket. On the redirect case we will
> > > > check memory limits per 6fa9201a89898, but will omit fwd_alloc accounting
> > > > until skb is actually enqueued. When the skb is sent via skb_send_sock_locked
> > > > or received with sk_psock_skb_ingress memory will be claimed on psock_other.
> >                      ^^^^^^^^^^^^^^^^^^^^
> > >
> > > You mean sk_psock_skb_ingress(), right?
> >
> > Yes.
> 
> skb_send_sock_locked() actually allocates its own skb when sending, hence
> it uses a different skb for memory accounting.
> 
> >
> > [...]
> >
> > > > @@ -880,12 +876,13 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
> > > >                 kfree_skb(skb);
> > > >                 goto out;
> > > >         }
> > > > -       skb_set_owner_r(skb, sk);
> > > >         prog = READ_ONCE(psock->progs.skb_verdict);
> > > >         if (likely(prog)) {
> > > > +               skb->sk = psock->sk;
> > >
> > > Why is skb_orphan() not needed here?
> >
> > These come from strparser which do not have skb->sk set.
> 
> Hmm, but sk_psock_verdict_recv() passes a clone too, like
> strparser, so either we need it for both, or not at all. Clones
> do not have skb->sk, so I think you can remove the one in
> sk_psock_verdict_recv() too.

Agree skb_orphan can just be removed, I was being overly
paranoid.

Thanks.
