Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3922CCBE1
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 02:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbgLCBv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 20:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgLCBv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 20:51:27 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329DFC061A4E;
        Wed,  2 Dec 2020 17:50:47 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id a9so405251lfh.2;
        Wed, 02 Dec 2020 17:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ctfBFQGQdbyGPKLrHCF1O72IncKLnWAmPeG02j1LxY=;
        b=VleZ4CJrnZ6wSrw+kl8kXqRGS4UZOX45iFD6tELjGbxuEQ3VLdXvWCptvbQ3YSiGOu
         iNgS93eM2f1m3OVayqREizIOvqOYIInbTrGLn3I7JrhnrYHee+1Y9WBDc7LuVyTkK16A
         ENY6F4NaBtUprKudsbzgIP2XVUIj5Q0bAZ9nCemigRL3Z071cegIZ7rv22HMuI0dCjG2
         lsyuvzOVQ7W7VPfykkhhyeTnIxD5Kq/VR47JlG86IaetDNT7dqabfGSYCWViNZiweasw
         McbDXK1ly6XjA92FZGuk+cP0F5l1+eTtT1aM1QIaNC9RyE6AWr2oP1DV8dIMvkhgZ9gY
         hHJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ctfBFQGQdbyGPKLrHCF1O72IncKLnWAmPeG02j1LxY=;
        b=E5OS08Ggacmypy4VGdU8cYnY/Nu920uoZ2ofgWJRCvD5SgMeXOdT/y/f7NuWfmy2iL
         JyTTwkvczpAACZZ+CpAdXoDorPhg+J7wwRJyQbWd/+hybrl5kAJWk2AdbqEG/UfOgsdc
         xMTmUlpERLYEahx9B7QSsqiZM42MFNIigxtB6StYezXkx4TJAgnYwRTD4lOoX1cqKhiy
         7sLTX0+OyhH0U8c7QRCd4GreuBnOk4vXOFD+NiDKb34Y9i5d4dX91Hla8Fb+sZ7eLCLq
         K1jtfrqhBitBTdZ72wZ6BRRyrYxk8Rj0Mgfx+cjZsNk2saWVD24JhT2Kw6lNQ2EuAkKq
         AZVA==
X-Gm-Message-State: AOAM531NbsJeo+Cf8unatQFMNFoZ8ttF3cvmVs9QyIjIxIUWUljg1JGT
        /KECT9fJefIdQMlniX3F1izfxXNiSTl7UJ+DY58=
X-Google-Smtp-Source: ABdhPJyEFsLs1vwkaM4TA1AtHHlSNgFOxah9qwVsg4TRqd75wXcvAsBUgfBkJ75kC4fDA0FVcIERCUL0vd5y8ho8bpY=
X-Received: by 2002:a05:6512:3384:: with SMTP id h4mr340698lfg.554.1606960245691;
 Wed, 02 Dec 2020 17:50:45 -0800 (PST)
MIME-Version: 1.0
References: <20201201194438.37402-1-xiyou.wangcong@gmail.com>
 <20201202171032.029b1cd8@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com> <CAM_iQpWfv59MoEJES1O=FhA4YsrB2nNGGaKzDmqcmXQXzc8gow@mail.gmail.com>
In-Reply-To: <CAM_iQpWfv59MoEJES1O=FhA4YsrB2nNGGaKzDmqcmXQXzc8gow@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 2 Dec 2020 17:50:34 -0800
Message-ID: <CAADnVQK74XFuK6ybYeqdw1qNt2ZDi-HbrgMxeem46Uh-76sX7Q@mail.gmail.com>
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

On Wed, Dec 2, 2020 at 5:32 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Wed, Dec 2, 2020 at 5:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue,  1 Dec 2020 11:44:38 -0800 Cong Wang wrote:
> > > From: Dongdong Wang <wangdongdong@bytedance.com>
> > >
> > > The per-cpu bpf_redirect_info is shared among all skb_do_redirect()
> > > and BPF redirect helpers. Callers on RX path are all in BH context,
> > > disabling preemption is not sufficient to prevent BH interruption.
> > >
> > > In production, we observed strange packet drops because of the race
> > > condition between LWT xmit and TC ingress, and we verified this issue
> > > is fixed after we disable BH.
> > >
> > > Although this bug was technically introduced from the beginning, that
> > > is commit 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure"),
> > > at that time call_rcu() had to be call_rcu_bh() to match the RCU context.
> > > So this patch may not work well before RCU flavor consolidation has been
> > > completed around v5.0.
> > >
> > > Update the comments above the code too, as call_rcu() is now BH friendly.
> > >
> > > Cc: Thomas Graf <tgraf@suug.ch>
> > > Cc: bpf@vger.kernel.org
> > > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > > Signed-off-by: Dongdong Wang <wangdongdong@bytedance.com>
> > > ---
> > >  net/core/lwt_bpf.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
> > > index 7d3438215f32..4f3cb7c15ddf 100644
> > > --- a/net/core/lwt_bpf.c
> > > +++ b/net/core/lwt_bpf.c
> > > @@ -39,12 +39,11 @@ static int run_lwt_bpf(struct sk_buff *skb, struct bpf_lwt_prog *lwt,
> > >  {
> > >       int ret;
> > >
> > > -     /* Preempt disable is needed to protect per-cpu redirect_info between
> > > -      * BPF prog and skb_do_redirect(). The call_rcu in bpf_prog_put() and
> > > -      * access to maps strictly require a rcu_read_lock() for protection,
> > > -      * mixing with BH RCU lock doesn't work.
> > > +     /* Preempt disable and BH disable are needed to protect per-cpu
> > > +      * redirect_info between BPF prog and skb_do_redirect().
> > >        */
> > >       preempt_disable();
> > > +     local_bh_disable();
> >
> > Why not remove the preempt_disable()? Disabling BH must also disable
> > preemption AFAIK.
>
> It seems RT kernel still needs preempt disable:

No. It's the opposite. When we did RT+bpf changes we missed this function.
It should be migrate_disable here instead of preempt_disable.
I don't know what local_bh_disable() maps to in RT.
Since it's used in many other places it's fine to use it here to
prevent this race.
