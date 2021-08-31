Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E323FC02E
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 02:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239260AbhHaAoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 20:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239253AbhHaAoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 20:44:14 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8845C061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 17:43:20 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ot2-20020a17090b3b4200b0019127f8ed87so946675pjb.1
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 17:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IIhvrVf8UyyArx/9J4AZQdpUeoySx7mM1meK5VjfZ4E=;
        b=PfxSsCKJ2dT04WyRuAb0D+l8x6N+WmYvbNsnX8Swd3mSIEKrF+ec7BMJZ6PNTVt1Rx
         rQzRrIsoMMkFYKa+SrCiJrv4IjwzbB0+Tbt8gJppbreizK9t2cYKWQdm31PAbtypg75s
         b66QPj75MW/w94gj8Lc1AgfnFK5IleWsVNRaMhYU2vx3XIXwZceSVZCT05HWGnM193/R
         OiOcBr7E3b/vdoJzxBi64WWHEVjZXjmhvrZpLcVwY0KvKLmqNsxtGdFVxUk/0m5RrE4J
         2u+3LKCIPLjfNlvPoHtz395r9lXP6D0X4jSGms3yIzLLmnZwko53Ly0CGDQr+Bvwk4hF
         tETQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IIhvrVf8UyyArx/9J4AZQdpUeoySx7mM1meK5VjfZ4E=;
        b=O3Dvykpzh3UZUBkkqk+htrerfjeItfznBiuPswFcbiZZJjMxjcOKmohEVIWN07yIiF
         kyBBncY0rWjqfNkxQpUb6SQe10R62Y4eUwf4jqaj61TPgi5Yz5chub/MzeaRdLHTod6W
         XmrhBSsuAN2VL04rPCJcqA35WcV4XHicheEvYkVFdvQlRlYPY79wMRyRCXNmOMa3gkop
         M7VBqliKXuM1E1o5zL4oOwjZJJfphTEPosscFWJgKExM9Cf/BrWokzChnjakenpxxN8E
         TvI4Owd0Z/fUJ6IX1+dvKM6aqdTmxysofqjIHCIPVfxkOe0gDLLVMluZnJEw1uKu/Q6+
         V4wg==
X-Gm-Message-State: AOAM531xCBFaA2k1imBV4HEbLE+bIQX8bPr1xeCnLfa0TTCpIVAo7YfA
        L0U5vVzyGeIrhdLdl3lKV5W5q2BZuEQqnMufUVA=
X-Google-Smtp-Source: ABdhPJxouP15Uuo4RUdiLsXqKLjF2TEE/MU3VmuOn56CL/ZNfyEemzeVFJ4IBOFQqnctjV2KwdiDk+XVO95Fh/yrwyo=
X-Received: by 2002:a17:90b:710:: with SMTP id s16mr2074175pjz.56.1630370600218;
 Mon, 30 Aug 2021 17:43:20 -0700 (PDT)
MIME-Version: 1.0
References: <2fdc7b4e11c3283cd65c7cf77c81bd6687a32c20.1629844159.git.dcaratti@redhat.com>
In-Reply-To: <2fdc7b4e11c3283cd65c7cf77c81bd6687a32c20.1629844159.git.dcaratti@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 30 Aug 2021 17:43:09 -0700
Message-ID: <CAM_iQpUryQ8Q9cd9Oiv=hxAgpqfCz=j4E=c=hskbPE2+VB-ZvQ@mail.gmail.com>
Subject: Re: [PATH net] net/sched: ets: fix crash when flipping from 'strict'
 to 'quantum'
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 3:34 PM Davide Caratti <dcaratti@redhat.com> wrote:
> When the change() function decreases the value of 'nstrict', we must take
> into account that packets might be already enqueued on a class that flips
> from 'strict' to 'quantum': otherwise that class will not be added to the
> bandwidth-sharing list. Then, a call to ets_qdisc_reset() will attempt to
> do list_del(&alist) with 'alist' filled with zero, hence the NULL pointer
> dereference.

I am confused about how we end up having NULL in list head.

From your changelog, you imply it happens when we change an existing
Qdisc, but I don't see any place that could set this list head to NULL.
list_del() clearly doesn't set NULL.

But if it is a new Qdisc, Qdisc is allocated with zero's hence having NULL
as list head. However, in this case, q->nstrict should be 0 before the loop,
so I don't think your code helps at all as the for loop can't even be entered?

Thanks.
