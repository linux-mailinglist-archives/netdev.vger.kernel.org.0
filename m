Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A326319CF55
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 06:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730698AbgDCEdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 00:33:18 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44653 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729030AbgDCEdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 00:33:17 -0400
Received: by mail-oi1-f194.google.com with SMTP id v134so4997263oie.11
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 21:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NFbbO1CCxyYgiqTYCSsHsbHaWcx6MLUyyIL8CeOFtdk=;
        b=sCflR+e7fa9806HW26ismMn18t7bzMB83ZaS2Q5HfhoKfMFblRBW3i4Xxk3oYFQOsO
         LiwbAmFmZyZS5/bt+Yk7iokN5Fv6e874RFNgFI7BxGvU52nfVyt60ICvTElwu4UNzGkO
         hBO2J44kb/y0ls3vF4SMjzfC+5Cgbcvp2c+wWgHVQnh/2NwZ1zN60yhg+Wp8/vDWjoYD
         9xDsiuWwjV5fh+Z2kjuFhSohxX/lkFSvd6iQ1YeIWC4W8b30qsCvlAjOdN5UDdUb5HYk
         HHTTzwSISWcVa9jjHuWM0QMMd2g+Eg5zR8HYQOQgDxSEhPeXfTsOp290Fdd8hQ33a6JT
         WNuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NFbbO1CCxyYgiqTYCSsHsbHaWcx6MLUyyIL8CeOFtdk=;
        b=nEWxK3D6gd/3XQsuC1CVjqI67XdCX8XZXFTVdfgodpnxvGX3cnit8Fv0unYMT/3dkG
         4CMy4m3gdUtrCmiStNmraGMEAU+AT5lGhotMykbHtkE1kgIqwmQeWsKJtNcFJLri2Ga7
         MFfz+33Adv9bbpJjcLcNXzV3pRIbqkEQO7iHwbXYa3FqLaorIWjo4SM9XTQCTuVHUBjU
         y3aGs7tNXxYLc+noNka4a3rxOWdGTR5RKNKXlyUz289/jaPbLre3/105/adI2jpxO/0I
         cTXs+Cq5DuVKbcVpHOfh/KqveTDN4lE0L8cqPRyspXs1KrN/1nBn41kky3Tp6rnqG7oZ
         HtsQ==
X-Gm-Message-State: AGi0PuY0pDK0b7SIs9OQkl2Yf76/np8IxrXM2/SNGtOwx1QRMKXKyWIm
        +SBub9nXk0qWpf9m8Z/QmztxfMNhhjvOqtuz58U=
X-Google-Smtp-Source: APiQypK7ppfBXbuM3yS+0sqrPvKsOQRkSk9t1Q2+f4vQWhcR+33SYyFuZ8EhmCdp4KxwRZ/cCJ5ap1mwl2AIM2J0E0M=
X-Received: by 2002:aca:4b56:: with SMTP id y83mr1820479oia.142.1585888396771;
 Thu, 02 Apr 2020 21:33:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200402152336.538433-1-leon@kernel.org> <20200402155723.534147ac@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200402155723.534147ac@kicinski-fedora-PC1C0HJN>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 2 Apr 2020 21:33:05 -0700
Message-ID: <CAM_iQpVRyCpyBWabEyYLGx69ZY1+exrV+cU034vrmodeubkqaA@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: Don't print dump stack in event of
 transmission timeout
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@mellanox.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Itay Aveksis <itayav@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 2, 2020 at 3:57 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu,  2 Apr 2020 18:23:36 +0300 Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > In event of transmission timeout, the drivers are given an opportunity
> > to recover and continue to work after some in-house cleanups.
> >
> > Such event can be caused by HW bugs, wrong congestion configurations
> > and many more other scenarios. In such case, users are interested to
> > get a simple  "NETDEV WATCHDOG ... " print, which points to the relevant
> > netdevice in trouble.
> >
> > The dump stack printed later was added in the commit b4192bbd85d2
> > ("net: Add a WARN_ON_ONCE() to the transmit timeout function") to give
> > extra information, like list of the modules and which driver is involved.
> >
> > While the latter is already printed in "NETDEV WATCHDOG ... ", the list
> > of modules rarely needed and can be collected later.
> >
> > So let's remove the WARN_ONCE() and make dmesg look more user-friendly in
> > large cluster setups.
>
> I'm of two minds about this. As much as printing a stack dump here is
> not that useful indeed, it's certainly a good way of getting user's
> attention. TX queue time outs should never happen, and there's a bunch
> of log crawlers out there looking for kernel warnings.

Rasdaemon is also able to capture this via trace_net_dev_xmit_timeout()
and send it to ABRT too. So, I don't think this is a big problem.

[...]
> > diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
> > index 6c9595f1048a..c12530fe8b21 100644
> > --- a/net/sched/sch_generic.c
> > +++ b/net/sched/sch_generic.c
> > @@ -439,8 +439,9 @@ static void dev_watchdog(struct timer_list *t)
> >
> >                       if (some_queue_timedout) {
> >                               trace_net_dev_xmit_timeout(dev, i);
> > -                             WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit queue %u timed out\n",
> > -                                    dev->name, netdev_drivername(dev), i);
> > +                             pr_info_once("NETDEV WATCHDOG: %s (%s): transmit queue %u timed out\n",
>
> I'd say pr_err_once(). Or dev_err_once().

Or pr_warn().

Thanks.
