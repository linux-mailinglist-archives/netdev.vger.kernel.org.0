Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658602CDD49
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbgLCSXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgLCSXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 13:23:01 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227ECC061A4E;
        Thu,  3 Dec 2020 10:22:21 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id j205so4122876lfj.6;
        Thu, 03 Dec 2020 10:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oK4UspCxPt4rZenc9BNNj8jOpIMjTnwtWvokvuaxYP4=;
        b=VegaAbCIDmhi0fTfzZ0zRU8+o3iHuLVT9V/ajgHTwldE+BP3nGp1lcWU6npJs02Btl
         VxXjkVrotEt3cJrsJO8yICmngy4FSHh3pu/7kH2eqHkgS3UILTw7fy9wtxXvapHW8VGB
         SxgMIZAUCJwzIzjuhDSCDie6GdPDc0GKUKMRs+cgSDzUkWoMlK/uG5hE+DSCdBd91Ne0
         aVvTpZa1LBariJUuZGxfBe3tcQlgvyQbLzkoY8eD5d7ffeZYhCRqAFAE5rmLmlSvs4gi
         XsFdDKjqulT20DukaK0PG9ZruFUmmV+NM/XqzlvDLbENMlXt2kbefwD4e7AaPO8vqW8n
         G+aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oK4UspCxPt4rZenc9BNNj8jOpIMjTnwtWvokvuaxYP4=;
        b=Xga6RssRGJqo1KHUn7cIgzXbKfEFYQJUVXK8iCa6s8p5gBNWBWEavjZ0zykN4Rxfwn
         FOYgKFdKrbL2vsvisj0k5yO+2T/Gc6glLCA6TowXGmxHrTaIee/I51BhvZt4IRygzi7z
         jQyi0ADHMdyFNd4LZ37sS77XHIIqIyXvP8sAbdehXR/EUeWLjMPO/xK8/E17zRUJ96yR
         i6yd54lKwdgih1GeRAyuTrB9pyA6+qYJi3mOa9rfE8EtXINM6oOWRB+eOcCdktQZhlw1
         lzQWxOKiEx6ECWM5MQLrXn6yrdY6eCbHyWrQxvlKJ5bz1xhZdSTmOIjAi4hqwysSUai3
         c7qQ==
X-Gm-Message-State: AOAM532MvJnm5n3E82Rd4d4FyLq6o/MpoXhp+HilKP8K3xjrgHVhF94p
        qjY8ftZLFbHHGeb2PGrhKJ+qhS0giqTLpJzhCmu2s20O
X-Google-Smtp-Source: ABdhPJxFh4ZK/tzg6Y33zHSo2fG+08nIkpOn8YG84VRfna7M9R14MkJ27DLQYOyv3/hnFS1RyrdJV/znGQUtKCjJLoQ=
X-Received: by 2002:a19:8048:: with SMTP id b69mr1744736lfd.263.1607019739583;
 Thu, 03 Dec 2020 10:22:19 -0800 (PST)
MIME-Version: 1.0
References: <20201201194438.37402-1-xiyou.wangcong@gmail.com>
 <20201202171032.029b1cd8@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAM_iQpWfv59MoEJES1O=FhA4YsrB2nNGGaKzDmqcmXQXzc8gow@mail.gmail.com> <CAADnVQK74XFuK6ybYeqdw1qNt2ZDi-HbrgMxeem46Uh-76sX7Q@mail.gmail.com>
In-Reply-To: <CAADnVQK74XFuK6ybYeqdw1qNt2ZDi-HbrgMxeem46Uh-76sX7Q@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 3 Dec 2020 10:22:07 -0800
Message-ID: <CAADnVQ+tRAKn4KR_k9eU-fG3iQhivzwn6d2BDGnX_44MTBrkJg@mail.gmail.com>
Subject: Re: [Patch net] lwt: disable BH too in run_lwt_bpf()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Dongdong Wang <wangdongdong@bytedance.com>,
        Thomas Graf <tgraf@suug.ch>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 2, 2020 at 5:50 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Dec 2, 2020 at 5:32 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Wed, Dec 2, 2020 at 5:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Tue,  1 Dec 2020 11:44:38 -0800 Cong Wang wrote:
> > > > From: Dongdong Wang <wangdongdong@bytedance.com>
> > > >
> > > > The per-cpu bpf_redirect_info is shared among all skb_do_redirect()
> > > > and BPF redirect helpers. Callers on RX path are all in BH context,
> > > > disabling preemption is not sufficient to prevent BH interruption.
> > > >
> > > > In production, we observed strange packet drops because of the race
> > > > condition between LWT xmit and TC ingress, and we verified this issue
> > > > is fixed after we disable BH.
> > > >
> > > > Although this bug was technically introduced from the beginning, that
> > > > is commit 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure"),
> > > > at that time call_rcu() had to be call_rcu_bh() to match the RCU context.
> > > > So this patch may not work well before RCU flavor consolidation has been
> > > > completed around v5.0.
> > > >
> > > > Update the comments above the code too, as call_rcu() is now BH friendly.
> > > >
> > > > Cc: Thomas Graf <tgraf@suug.ch>
> > > > Cc: bpf@vger.kernel.org
> > > > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > > > Signed-off-by: Dongdong Wang <wangdongdong@bytedance.com>
> > > > ---
> > > >  net/core/lwt_bpf.c | 8 ++++----
> > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
> > > > index 7d3438215f32..4f3cb7c15ddf 100644
> > > > --- a/net/core/lwt_bpf.c
> > > > +++ b/net/core/lwt_bpf.c
> > > > @@ -39,12 +39,11 @@ static int run_lwt_bpf(struct sk_buff *skb, struct bpf_lwt_prog *lwt,
> > > >  {
> > > >       int ret;
> > > >
> > > > -     /* Preempt disable is needed to protect per-cpu redirect_info between
> > > > -      * BPF prog and skb_do_redirect(). The call_rcu in bpf_prog_put() and
> > > > -      * access to maps strictly require a rcu_read_lock() for protection,
> > > > -      * mixing with BH RCU lock doesn't work.
> > > > +     /* Preempt disable and BH disable are needed to protect per-cpu
> > > > +      * redirect_info between BPF prog and skb_do_redirect().
> > > >        */
> > > >       preempt_disable();
> > > > +     local_bh_disable();
> > >
> > > Why not remove the preempt_disable()? Disabling BH must also disable
> > > preemption AFAIK.
> >
> > It seems RT kernel still needs preempt disable:
>
> No. It's the opposite. When we did RT+bpf changes we missed this function.
> It should be migrate_disable here instead of preempt_disable.
> I don't know what local_bh_disable() maps to in RT.
> Since it's used in many other places it's fine to use it here to
> prevent this race.

I guess my previous comment could be misinterpreted.
Cong,
please respin with changing preempt_disable to migrate_disable
and adding local_bh_disable.
