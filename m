Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788CF475092
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 02:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238932AbhLOBmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 20:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234983AbhLOBmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 20:42:11 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C22C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 17:42:10 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id r25so68624221edq.7
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 17:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fQEP/C9TgUnxv2hpaIkkKQ0dv4fOViyA+4rqaBcbfEE=;
        b=qfP5Rx5z1ezeQfpA2KiZpwtLiDnJ6eeDmnwK07mPia60TiJXXR6atFUHsIn6KecI3S
         Rwr41AaCvfyPbEefaaFCfeMBTtIEJPrN4+UOeCEsyu8G73Nf02K0HakQpFB7oKnymOoS
         3HGq5PKs9RxAyG4OfuW9WHqwrAuB3Du30n2QDJATMN1ZBiwfY5DzC9qZBBrXnOo4AwmF
         5bmKTWjjFIBTYt1bOazgtrrfa2IkZBFdcz+J5V3b4+I9zuszeMEnlLghsjFbf1LS8NMn
         249vCNsrGil1vAoG5vsLQBSFa6uWqJBJbrMiv+z5U46oj5a3kR8Td+9MVt+na7FEtqB9
         0v5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fQEP/C9TgUnxv2hpaIkkKQ0dv4fOViyA+4rqaBcbfEE=;
        b=bQfFTPF87ydgWl5/Rrlzi6S0jKhfPPzu2lhfNOo+6SNS+VJ4ef2AMNvDvWfKAPU4tS
         dF/Bx1klvJEMisW4JOX4qHQdgoU1bAkFdsAr08ZLWh+rqXmBIRtHivqO+bsYcBCamQkX
         etMT0VwL1Gkl0kZd8bx3IAh8vwzPUobLfjKZMGZ3eu1Vd1it9SewY0os3KJp/1EZg1Cs
         yXOo88U191JBJ1eJ3MEBLgk53ZByfSXwfP1tnbALfGHVWG67zuOOz9NhqgemKBAfsc5R
         juZQ3jYJbAYCSHfNuakd6Qu+wM2p7lJSD0QY0Z5+lLBVY0OPhJ9xr1rK0AlxqSDf5LXO
         ogzg==
X-Gm-Message-State: AOAM530KS2hR5wr2AUwT180AqFfq58fXM4BVKubnvSjC91TmhFNr987G
        f0lKIgXQ23xI/cF8Uxn6L0fVUt+eLrLWgQ07bD4=
X-Google-Smtp-Source: ABdhPJxRYBOK3qvdOdBbTiLwTh3a11R7N2qtNhuUuKKPZkTiKCzbsSSETyJFs1RhoRY2LempWorMRkNdwl5uqvYW2OA=
X-Received: by 2002:a05:6402:16cd:: with SMTP id r13mr12299754edx.264.1639532529137;
 Tue, 14 Dec 2021 17:42:09 -0800 (PST)
MIME-Version: 1.0
References: <20211210023626.20905-1-xiangxia.m.yue@gmail.com>
 <20211210023626.20905-3-xiangxia.m.yue@gmail.com> <CAM_iQpVOuQ4C3xAo1F0pasPB5M+zUfviyYO1VkanvfYkq2CqNg@mail.gmail.com>
 <CAMDZJNUos+sb+Q1QTpDTfVDj7-RcsajcT=P6PABuzGuHCXZqHw@mail.gmail.com>
 <CAM_iQpU+JMtrObsGUwUwC8eoZ1G39Lvp7ihV2iERF5dg0FySXA@mail.gmail.com> <a21b793f-48e6-a944-8869-676fb3cd448c@mojatatu.com>
In-Reply-To: <a21b793f-48e6-a944-8869-676fb3cd448c@mojatatu.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 15 Dec 2021 09:41:33 +0800
Message-ID: <CAMDZJNUS--bhW264YLzOB=hmF-TEows-uq=X9GzkVFYs0NrdJA@mail.gmail.com>
Subject: Re: [net-next v3 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 8:13 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2021-12-13 17:53, Cong Wang wrote:
> > On Sat, Dec 11, 2021 at 6:34 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> >> We support this in skbedit firstly in production. act_bpf can do more
> >> things than this. Anyway we
> >> can support this in both act_skbedit/acc_bpf. 1/2 is changed from
> >> skip_tx_queue in skb to per-cpu var suggested-by Eric. We need another
> >> patch which can change the
> >> per-cpu var in bpf. I will post this patch later.
> >
> > The point is if act_bpf can do it, you don't need to bother skbedit at
> > all.
>
> Just a comment on this general statement:
> I know of at least one large data centre that wont allow anything
> "compiled" to be installed unless it goes through a very long vetting
> process(we are talking months).
> "Compiled" includes bpf. This is common practise in a few other places
> some extreme more than others - the reasons are typically driven by
> either some overzelous program manager or security people. Regardless
> of the reasoning, this is a real issue.
Yes, I agree with you that
> Note: None of these data centres have a long process if what is
> installed is a bash script expressing policy.
> In such a case an upstream of a feature such as this is more useful.
>
>
> cheers,
> jamal
>


-- 
Best regards, Tonghao
