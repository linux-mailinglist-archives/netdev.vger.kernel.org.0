Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC16412EEE
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 09:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhIUHDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 03:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbhIUHD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 03:03:29 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271A4C061574
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 00:02:01 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id d6so35982001wrc.11
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 00:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vn3RHd2aOZ8iaFVExrbcrdfcQGvP7FIcYl5vAUxzZSE=;
        b=ZsemtIPdi3bYvE29RP4suz5psYBOaqVFZBtBsiEhoHCVg69ena6+FZOC/MttYMOngw
         S2nGzQn8yoS4bI06SudBoyKTRgsBhL6A+utWxM1xLC9iGa0xcOKtvA7QHX3XpcXvtq5e
         Wll7JAAF4vAmzYLBOPQPfdQEi0EpIozIwUVf6E5H+vXHdCYpSUJGHdT3y0rfKmoicMpk
         x64VpwQQ4pO+8g3DUEVH3/HMu8tPkXfZlKWUajwmABZQOi72Tz3efdHAYFd+ks6r+Nh3
         btff/rp0lRo6rXK6cLKVS+OvIPYu7cfLDp3DF91jWZVgJyYs/sSL3D1YwAEnHHCb0SkQ
         owHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vn3RHd2aOZ8iaFVExrbcrdfcQGvP7FIcYl5vAUxzZSE=;
        b=nS7s4nusVUDwYU9iKOYchgf38NOmGPaClkURv3Oa9gGUsDxmruWe+HN/j3/rfPHVqh
         bt1+E25A9ARHtfgzBAZzJ3cMuiAlF68PvRcHaQisi4UvRutBZbwLfVzfCr+qAayYB5sb
         wBqysZLFCeRZvp25R4QdUvUddVorewKnSQx4wu4BAPTJIKROmbGRFZgVRU8hBt52WBIJ
         1+6KpFThvBFsI/WNHPFJliQ6YRv3ON22dSfhFgt/BFtHqk2TcA8dtXSUVtthLqNZSk2o
         QWfy9qQEIaKVREMxxGph7MFY05/NPusZ5rVxTM4pyStJcw+RizPp940OSjGO7Q6IMqWN
         gnkQ==
X-Gm-Message-State: AOAM533bMGLH0vFX3ezWOYbzzObK9tUYzNex6PbTBdL8I/pn1JNYDFZH
        HtBntC/UoAcouF/+qrUjps48idwjtcFZMgaJTtN2VIM8tpRdZw==
X-Google-Smtp-Source: ABdhPJxi7FFuqlCym4vftMNQMtrl9jHCyEoT13KqIJAecr0kh0VWMpJLAHJGSELKlqfYFog46KmlnpJtTha2Gv6FdQA=
X-Received: by 2002:a1c:f713:: with SMTP id v19mr2763864wmh.188.1632207719791;
 Tue, 21 Sep 2021 00:01:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1632133123.git.lucien.xin@gmail.com> <13c7b29126171310739195264d5e619b62d27f92.1632133123.git.lucien.xin@gmail.com>
 <CAM_iQpW53DGw5bXNXot4kV3qSHf5wgD33AFU3=zz0b69mJwNkw@mail.gmail.com>
In-Reply-To: <CAM_iQpW53DGw5bXNXot4kV3qSHf5wgD33AFU3=zz0b69mJwNkw@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 21 Sep 2021 15:01:48 +0800
Message-ID: <CADvbK_dSw=H-pVK26tMwpdfkjd3dKGcCrATaRvXqzRwJFoKoyg@mail.gmail.com>
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

On Tue, Sep 21, 2021 at 2:31 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Sep 20, 2021 at 7:12 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > nf_reset_ct() called in tcf_mirred_act() is supposed to drop ct for
> > those packets that are mirred or redirected to only ingress, not
> > ingress and egress.
>
> Any reason behind this? I think we at least need to reset it when
> redirecting from ingress to egress as well? That is, when changing
> directions?
For the reason why ct should be reset, it's said in
d09c548dbf3b ("net: sched: act_mirred: Reset ct info when mirror").
The user case is OVS HWOL using TC to do NAT and then redirecting
the NATed skb back to the ingress of one local dev, it's ingress only, this
patch is more like to minimize the side effect of d09c548dbf3b IF there is.

Not sure if it's too much to do for that from ingress to egress.
What I was thinking is this should happen on rx path(ingress), like it
does in internal_dev_recv() in the OVS kernel module. But IF there is
any user case needing doing this for ingress to egress, I would add it.

>
> Thanks.
