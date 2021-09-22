Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB92414026
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 05:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhIVDpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 23:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbhIVDo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 23:44:59 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD82C061574
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 20:43:30 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id g184so1248058pgc.6
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 20:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aGtGwB7DVGy14NjngglV+xOVF+SbYqdLxOcswGb86GI=;
        b=g6wXHbx419HY7UnRXoGermo5bWBHWTLU4BJ2JpovbXRvYIw69yxxEwEiBLmq9MB+jJ
         NWABxwsfuTLKvnTiPdoNBxwizQTFIBjNU2GroL0rt2NlkgqQ9ZZe/CGpXHITS2gBcapW
         9j0yX9hEFGHF0VL29dTAvTybsPptoQbXtRBls/m5CA5By3pd+MsEIJIyBhjt6wEGWk9Y
         Jj0oYSX/+BpKGzHecRm71Txbkz8SysS0Ve3EKP6yx97UNZFV9n9PhO7HA4ajQ/Ql9V/l
         kr/Zt5fnrR6yg5yMoTTm58s29lnuac0GJ6O/z/YmfY22bhqifGr2IJ2BrWYMCq8iPYJt
         BiEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aGtGwB7DVGy14NjngglV+xOVF+SbYqdLxOcswGb86GI=;
        b=0xh17MlVFo+wK33VPMFpj2+SZMiXs+i0j2lM9c3qGMle8PCOZGuAdEEvlKY9hrgYZ5
         IWPbdNQegjwxfgx7qalGedQOLTNJHeA6UkHJWhExwJolXYeOCCuCQRnyC3I6RjQUkK9V
         j/YoUZDeRr9l/hKiHLrW9tg984ZqW+9My66TaTvZUK/sbxyuCAO/jrDejJBW9LcsEXfr
         iestdLC33MI/wn+rsLLyLy/jFb8m8v0joAR7NNxZOkUKgNa8A1Z4A5ljP3SWVgRMGmaE
         plx7a8LcPjzCgPE5T/qgB+fYA69pgSEHwthpeQvWkeKZWTxBXERyOGi/FctJP3Nb/Izw
         vPoA==
X-Gm-Message-State: AOAM532QZdnRdcppvdaoJuoHELfD1Tvh6d2jueuNb8LFk9Tmv4/3L129
        hGbAeL9cLXE+S5hnLUWzd22/mMgS7KfJQ03yzjtNercb
X-Google-Smtp-Source: ABdhPJytLuBxDpzLBKRGoPpzmgfcRennJqycdlTZxtaIl9y2MrA6mT+8hD8lz9MrCEzfIFlgRo0ubP9qE8bRpejKgwk=
X-Received: by 2002:a62:645:0:b0:3f2:23bd:5fc0 with SMTP id
 66-20020a620645000000b003f223bd5fc0mr33490304pfg.35.1632282209523; Tue, 21
 Sep 2021 20:43:29 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1632133123.git.lucien.xin@gmail.com> <13c7b29126171310739195264d5e619b62d27f92.1632133123.git.lucien.xin@gmail.com>
 <CAM_iQpW53DGw5bXNXot4kV3qSHf5wgD33AFU3=zz0b69mJwNkw@mail.gmail.com> <CADvbK_dSw=H-pVK26tMwpdfkjd3dKGcCrATaRvXqzRwJFoKoyg@mail.gmail.com>
In-Reply-To: <CADvbK_dSw=H-pVK26tMwpdfkjd3dKGcCrATaRvXqzRwJFoKoyg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 21 Sep 2021 20:43:18 -0700
Message-ID: <CAM_iQpULkRxRjMBWKn+7V51PZXLWW17iQBLr1N5vdJmFVZtJ4A@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net: sched: drop ct for the packets toward
 ingress only in act_mirred
To:     Xin Long <lucien.xin@gmail.com>
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

On Tue, Sep 21, 2021 at 12:02 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Tue, Sep 21, 2021 at 2:31 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Mon, Sep 20, 2021 at 7:12 AM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > nf_reset_ct() called in tcf_mirred_act() is supposed to drop ct for
> > > those packets that are mirred or redirected to only ingress, not
> > > ingress and egress.
> >
> > Any reason behind this? I think we at least need to reset it when
> > redirecting from ingress to egress as well? That is, when changing
> > directions?
> For the reason why ct should be reset, it's said in
> d09c548dbf3b ("net: sched: act_mirred: Reset ct info when mirror").
> The user case is OVS HWOL using TC to do NAT and then redirecting
> the NATed skb back to the ingress of one local dev, it's ingress only, this
> patch is more like to minimize the side effect of d09c548dbf3b IF there is.

What is the side effect here? Or what is wrong with resetting CT on
egress side?

>
> Not sure if it's too much to do for that from ingress to egress.
> What I was thinking is this should happen on rx path(ingress), like it
> does in internal_dev_recv() in the OVS kernel module. But IF there is
> any user case needing doing this for ingress to egress, I would add it.

If that is the case, then this patch is completely unnecessary. So
instead of going back and forth, please elaborate on why resetting
CT for egress is a problem here.

Thanks.
