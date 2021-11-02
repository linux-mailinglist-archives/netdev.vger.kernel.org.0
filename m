Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A78442566
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhKBCBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 22:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhKBCBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 22:01:21 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAB7C061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 18:58:47 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w1so16549147edd.10
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 18:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9cUMma5cR/MsGOgp4rjPk+nm035wfIaBl1frtYaNkZc=;
        b=llEfmuM4nRR1QKJB6nIurCXTaLafEC/hX3gb+jgv1J39nMUhjPPOqR2Tyju1poRhP4
         9m3n78nJZ+ox/w/SaBxqVS/0mso4quP+l/TCCh0ULFQ02aJOyIPLoPLlt4Vz5As1b/PK
         I8+npEpBJePt+eSS0D8rsa4PCp7cK4ZQfulZVpMpw+Y6SDkGn2LHrUW/EMejIJlKiLxo
         UICI8V7lXd0nPnMqsPy/gGotxukmlok1fcCFO/+YHUVIvU/aA1mOQwm7HpW39L3I5PM5
         NT1LOTP1Svzr2SVhEb16G3TGDNsoitd847MhePq7uwMF1Ijs71QJOLMMpTQSSnLgxXkA
         iF0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9cUMma5cR/MsGOgp4rjPk+nm035wfIaBl1frtYaNkZc=;
        b=66caqR8Mdmfcc2LEnGDZrC7QejCW5HKXmhVnMbgStWmWqEufbKrStmbx/aDBVJTsBR
         HL9UUgVINp/S7MRpUfLRCTt7/RPJeHW3lGMI7V6P6Y/ENiZdcC2syVuY8SaXMHI5/zNY
         ddT0FXZuaBwOutIkzJQR8RgZKZENThgTQKQgMNbU/DsjoJDLNMG4n+BT/Qeks+eH6rm8
         U7twaKgKCoOKSzTMdSCvg1njk/gn/AKu1yr73vwPqDar5lEFwHT06AV+G55EvNMyTsNZ
         VmjcM3ZN30NOFtumdk9YBuKqWHl0hfkpaYdXWFX4TDZ4jZyhv+9KoUxeJYMV+DFTbHw1
         G4rQ==
X-Gm-Message-State: AOAM533NPkRjDC5NQY1odOWU9HSnbZPJdnhtyZmX1Is5OJdwgrfhclXf
        tHeMJ6CD8B/Vnba48eYU/60UlNG/a8yYeO2viMmmMzUzXQjs3g==
X-Google-Smtp-Source: ABdhPJyXVld1VN7kHjkFO8ELsA5LQXrD+37NRZOOltUIw8NdZp8MmdD50+cL81UPOZ+DYrYRupT8NPb/LHLV9qMzTkg=
X-Received: by 2002:a17:907:96a3:: with SMTP id hd35mr40299413ejc.222.1635818325575;
 Mon, 01 Nov 2021 18:58:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211029015431.32516-1-xiangxia.m.yue@gmail.com> <9deda78a-a9a2-6b0b-634d-07c5b77282a8@iogearbox.net>
In-Reply-To: <9deda78a-a9a2-6b0b-634d-07c5b77282a8@iogearbox.net>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 2 Nov 2021 09:58:09 +0800
Message-ID: <CAMDZJNWOvRgaWE38WfBOmKuWyaysNB6OYaQNQeLNNJPw1AVDWQ@mail.gmail.com>
Subject: Re: [PATCH] net: core: set skb useful vars in __bpf_tx_skb
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 2, 2021 at 5:46 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 10/29/21 3:54 AM, xiangxia.m.yue@gmail.com wrote:
> [...]
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 4bace37a6a44..2dbff0944768 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -2107,9 +2107,19 @@ static inline int __bpf_tx_skb(struct net_device *dev, struct sk_buff *skb)
> >               return -ENETDOWN;
> >       }
> >
> > -     skb->dev = dev;
> > +     /* The target netdevice (e.g. ifb) may use the:
> > +      * - skb_iif
> > +      * - redirected
> > +      * - from_ingress
> > +      */
> > +     skb->skb_iif = skb->dev->ifindex;
>
> This doesn't look right to me to set it unconditionally in tx path, isn't ifb_ri_tasklet()
> setting skb->skb_iif in this case (or __netif_receive_skb_core() in main rx path)?
Hi
the act_mirred set the skb->skb_iif, redirected and from_ingress. and
__netif_receive_skb_core also set skb->skb_iif.
so we can use the act_mirred to ifb in ingress or egress path.
For ingress, when we use the bpf_redirct to ifb, we should set
redirected, and from_ingress.
For egress, when we use the bpf_redirct to ifb, we should skb_iif ,
set redirected, and from_ingress.

> Also, I would suggest to add a proper BPF selftest which outlines the issue you're solving
> in here.
Ok, thanks.
> > +#ifdef CONFIG_NET_CLS_ACT
> > +     skb_set_redirected(skb, skb->tc_at_ingress);
> > +#else
> >       skb->tstamp = 0;
> > +#endif
> >
> > +     skb->dev = dev;
> >       dev_xmit_recursion_inc();
> >       ret = dev_queue_xmit(skb);
> >       dev_xmit_recursion_dec();
> >
>


-- 
Best regards, Tonghao
