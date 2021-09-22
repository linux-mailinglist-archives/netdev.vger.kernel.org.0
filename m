Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9095541412C
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 07:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbhIVFSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 01:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbhIVFSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 01:18:47 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B50C061574
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 22:17:17 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id i23so3177927wrb.2
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 22:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nZ6P5cxoG/lqjYqBHnA+r4ZbZAlV1S/dG0TgvhUQbQg=;
        b=Ej3Z9bCWFQHPf5IPPZDQbc6r1mVtmk/jgxBsLeHhpM1G4luwbGmX3C7X2/gaJmMAxi
         5Xa2Q700tzaaLGL3NkyFdcPAen/TNjuguRPaV00+PfbfomEGBWfGGGeNKOeCybLBSH35
         +8M3HdB/h0fu1stxTQ+woFpcJn/1ucKm9KSrATiuJRTYtqntwHto+XgiuiYnULDPwPTR
         wTOfjeo7lMdentovEPmyleaFhwcVBgPfnudVNWfr2hmHKXBmO3Tgb7kzyPdw/t5sOvYb
         p4ex2FJLxS7hktn1rbPk7Rp3mYKiqLVCaTA/MuSwb9P1AshIZJLMpBT8iJzdeGOXGLXA
         9Vog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nZ6P5cxoG/lqjYqBHnA+r4ZbZAlV1S/dG0TgvhUQbQg=;
        b=I6glkLKzPudVxoNt88lpeZDB27B0vlFjCcJxO5SeSR7HzDNVo0UHWeryCrdUU3Z36O
         k280kO1XS4114txwVRREgWKJt2AfmMw2ecXO2BSCevjLYlTG65yUFYDW2FRig9bx6unh
         sVr2rjAFbjRDRU8eGsyTR8eyk1yNHnsrOfbwjzMG6NxzVoxP3W+d8iZndc/iWFjgASk2
         Ytsl1EhHn3HH5epk+O9Iamx8L4VdnBLkzIZkkwk1/ZBuHBpAV1DLnrmGMWMPCUV5LnIr
         dAmnnLMesGaot1xyVmnuCX+TIGdLP2iNCHXKQ0ZqXjMwHQxu/2k4q/zWqBaAc30P619o
         QutA==
X-Gm-Message-State: AOAM533SdtCLW8kihnkS0YMLwBYI/vlwRcetJTPKwaH78PixabjdhZtn
        zTqkFQttbetpuRc9+yeZ5ne1w61kDtd9TNvLfD8=
X-Google-Smtp-Source: ABdhPJwMB2YnH2vLkzX5MC/hvfe9lV9boc2b0m5OAg5584AKudTQBVDXhqVjDW64LBv1ZNyCv78OfdGt0UppSGSm7Mc=
X-Received: by 2002:a1c:4486:: with SMTP id r128mr8490850wma.8.1632287836478;
 Tue, 21 Sep 2021 22:17:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1632133123.git.lucien.xin@gmail.com> <13c7b29126171310739195264d5e619b62d27f92.1632133123.git.lucien.xin@gmail.com>
 <CAM_iQpW53DGw5bXNXot4kV3qSHf5wgD33AFU3=zz0b69mJwNkw@mail.gmail.com>
 <CADvbK_dSw=H-pVK26tMwpdfkjd3dKGcCrATaRvXqzRwJFoKoyg@mail.gmail.com> <CAM_iQpULkRxRjMBWKn+7V51PZXLWW17iQBLr1N5vdJmFVZtJ4A@mail.gmail.com>
In-Reply-To: <CAM_iQpULkRxRjMBWKn+7V51PZXLWW17iQBLr1N5vdJmFVZtJ4A@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 22 Sep 2021 13:17:05 +0800
Message-ID: <CADvbK_dFyVdt3dU57_8=6eYH+bz3_M81=V4B_5sNd+kpXbnUHA@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net: sched: drop ct for the packets toward
 ingress only in act_mirred
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 11:43 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, Sep 21, 2021 at 12:02 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Tue, Sep 21, 2021 at 2:31 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Mon, Sep 20, 2021 at 7:12 AM Xin Long <lucien.xin@gmail.com> wrote:
> > > >
> > > > nf_reset_ct() called in tcf_mirred_act() is supposed to drop ct for
> > > > those packets that are mirred or redirected to only ingress, not
> > > > ingress and egress.
> > >
> > > Any reason behind this? I think we at least need to reset it when
> > > redirecting from ingress to egress as well? That is, when changing
> > > directions?
> > For the reason why ct should be reset, it's said in
> > d09c548dbf3b ("net: sched: act_mirred: Reset ct info when mirror").
> > The user case is OVS HWOL using TC to do NAT and then redirecting
> > the NATed skb back to the ingress of one local dev, it's ingress only, this
> > patch is more like to minimize the side effect of d09c548dbf3b IF there is.
>
> What is the side effect here? Or what is wrong with resetting CT on
> egress side?
>
> >
> > Not sure if it's too much to do for that from ingress to egress.
> > What I was thinking is this should happen on rx path(ingress), like it
> > does in internal_dev_recv() in the OVS kernel module. But IF there is
> > any user case needing doing this for ingress to egress, I would add it.
>
> If that is the case, then this patch is completely unnecessary. So
> instead of going back and forth, please elaborate on why resetting
> CT for egress is a problem here.
What I'm afraid is: after resetting CT for the packets redirected to egress,
the tc rules on the next dev egress that may need these CT will break.

I can't give a use case right now, and just don't want to introduce extra
change for which we don't see a use. If you think that's safe, I'm fine
to do these resets when the direction is changed.
