Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC74924CE52
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgHUG5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgHUG5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 02:57:23 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3022C061385;
        Thu, 20 Aug 2020 23:57:22 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id p14so797506wmg.1;
        Thu, 20 Aug 2020 23:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WQbGwBfdWXsvcQzcjVztT8AVf5cOUGQA7jlczn2Olyw=;
        b=gV+R8BU8PO3KdU3PmAaMIIpnWeNYAkmMzFZNyREALN972DhMEaN7RtCzbS6ULbYid1
         v0lPAUEjJdDp8mkBkquU/1OZbxWP6vP7uAS7hvTAJNBGcEzXBkaP0eOrxbknXUipZbyG
         dtp4GvDql2IMTmPstK5HTt7sAWQrWQRMeSJIYi9uSkDP2YqAH3vWTLCuR0hRrtRTbctO
         NCXnsqdGLtS6mR3BfMcvDBbHMIhuJ4GfefD7h3ymNoFNQg5pBE5/IL7Bv0JqLYk/k47W
         Z5kYpL0yiMjEIVfMdAENIaGimqzMNL0oBze5/1PUnRMywtEy6k4c/9KUZRWWpDfjmbmE
         jhSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WQbGwBfdWXsvcQzcjVztT8AVf5cOUGQA7jlczn2Olyw=;
        b=DQhr8AnqnjCX8A60/LfaCpya8faF8pM5gR1Mrp20bcMoACsjcrVUMmNjvZSTxLYlNI
         xfEkTkhnc5BgYni4GdFLfZIVHDnIHGD//kc/eHyajPTncEakkd+gtn+DFKXU99pykV99
         tuh6VWXziQ7Qhz23Ks8OrMNyWNEHtRhXtW7HDGdFxKsf6VJ3aUrbrOYrVzwqOEfbd9wg
         xnHNjASJGj4p0di/t8cZMdkVwy2wSR4VHSruou13XFiS7HTHqSJz+RueOjc3B21senJE
         s7ggrHGOUxFNE39wuJzwvXlD/fpxcYBvbQMGWN96EwPW2HzSLazEuGqA48pvH+aWWDli
         9K0Q==
X-Gm-Message-State: AOAM530F3nX9TWj76PLHBO2vN/iSb+AQfE1pHDT2+NGD0f6vACZE9+t2
        NVEHOOe5KxYMGY8W6/IbgNDPB3gpwJH/Pp0fmy0=
X-Google-Smtp-Source: ABdhPJz/ANNy9QL95DCXGYJycO1D2lszuBpJUNDWhaUd3aS014D4OEHzKuvf9BMw+7Jvj+tsbr//61LpHADxejCOWSY=
X-Received: by 2002:a1c:e302:: with SMTP id a2mr2298185wmh.110.1597993041374;
 Thu, 20 Aug 2020 23:57:21 -0700 (PDT)
MIME-Version: 1.0
References: <b3da88b999373d2518ac52a9e1d0fcb935109ea8.1597906119.git.lucien.xin@gmail.com>
 <661ff148-627d-3b1f-f450-015dafefd137@gmail.com>
In-Reply-To: <661ff148-627d-3b1f-f450-015dafefd137@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 21 Aug 2020 15:10:04 +0800
Message-ID: <CADvbK_eej9URRLMrN=nLTAdcmaHJAmT+69-Ghk7i8JLcSmzENg@mail.gmail.com>
Subject: Re: [PATCH net] sctp: not disable bh in the whole sctp_get_port_local()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 9:13 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 8/19/20 11:48 PM, Xin Long wrote:
> > With disabling bh in the whole sctp_get_port_local(), when
> > snum == 0 and too many ports have been used, the do-while
> > loop will take the cpu for a long time and cause cpu stuck:
> >
> >   [ ] watchdog: BUG: soft lockup - CPU#11 stuck for 22s!
> >   [ ] RIP: 0010:native_queued_spin_lock_slowpath+0x4de/0x940
> >   [ ] Call Trace:
> >   [ ]  _raw_spin_lock+0xc1/0xd0
> >   [ ]  sctp_get_port_local+0x527/0x650 [sctp]
> >   [ ]  sctp_do_bind+0x208/0x5e0 [sctp]
> >   [ ]  sctp_autobind+0x165/0x1e0 [sctp]
> >   [ ]  sctp_connect_new_asoc+0x355/0x480 [sctp]
> >   [ ]  __sctp_connect+0x360/0xb10 [sctp]
> >
> > There's no need to disable bh in the whole function of
> > sctp_get_port_local. So fix this cpu stuck by removing
> > local_bh_disable() called at the beginning, and using
> > spin_lock_bh() instead.
> >
> > The same thing was actually done for inet_csk_get_port() in
> > Commit ea8add2b1903 ("tcp/dccp: better use of ephemeral
> > ports in bind()").
> >
> > Thanks to Marcelo for pointing the buggy code out.
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Reported-by: Ying Xu <yinxu@redhat.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
>
>
> Any reason you chose to not use a cond_resched() then ?
>
> Clearly this function needs to yield, not only BH, but to other threads.
>
Right, it explains why the cpu stuck is gone, but sctp_get_port_local()
still use the cpu quite a lot:


Thanks, will post v2.
