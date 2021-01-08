Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44502EF0C8
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 11:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbhAHKkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 05:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbhAHKkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 05:40:03 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6A1C0612F5
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 02:38:51 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id i18so9314454ioa.1
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 02:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ujXBAxK5O29Cl25/PjMn53d/2EdarcwXgxZBP6ltQtE=;
        b=vwKgxTY2zg2KIYXB4GZSxlp9cVvZXdpMpyy39Qd6OVRdtN3xrEFuuIZaVC9NQX/Naf
         eYtqEHFYQytjYs0V0/tuO27oE5DOQcTEucUS5TFSYF3fW+RM/rNMm1OMmIyogUZ/NZPQ
         9fx1bZQxManXWl9VHI5beHmHjNu3EJuAxUFxCJjPDHxn1hop+CG1XG9zhVRB6M0uPFzY
         qgTW5WRVajk1C3En944536Z9ldNex9eRig7wxAHYjVmmzvS/RTqHkLMsTvx5oI2CxpD2
         lBGSsYDEJV0T2S6SmX2CK/ZdW+/u2kcC8WA9M9I+PYieLivQ0WsFVsl6b1FE7udIwPrL
         cmjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ujXBAxK5O29Cl25/PjMn53d/2EdarcwXgxZBP6ltQtE=;
        b=GdqJSVNp2NqOhz0h3n+nmd2Rf7/W0pH0W60zxsekrKeUm3CHbKFO/t4ysHMUTxyMlz
         UL6gCVo1EG+7kJG7SprwSMjQVajLl8AU1LG4lFRsR4lBfhmThJwpULd9b9emXLsfCP/i
         Exz/c5TyAdwc1+ZFmxAq4p1vI+jsprx7TC8at4fOlnkjeLSK13OutSHg33tuMPqw6YEt
         iN+2a8fRpPOpmx8GzAjS2tuB/WCLoDAuCtt0eB2FgINIvu069V+81OWSIzoswRokNG3N
         d8DocB2UlmAAKnsjuiyFLIOF7auZNWo5jTZSUF9Qr9f8mrrIJoQtj13t1gii8adZq6hw
         +BXQ==
X-Gm-Message-State: AOAM532Yk5InPOscvtNwYo4KxlW0YBcqvOtUaJdaLLnZ0RHfRkdtvYM2
        LFlfV8fXNbf8cavTtTcUDibx7iWFCBMtWm9wBd1VJw==
X-Google-Smtp-Source: ABdhPJyIdleXGa+a5aHQaWChMdZZc2iOpBtAE/zFl7RakV+QN66X8mSFH1vDiBoqL6s3m3YSCk8TO0/1Ph6Iwj8LdL8=
X-Received: by 2002:a02:7f41:: with SMTP id r62mr2815728jac.17.1610102330392;
 Fri, 08 Jan 2021 02:38:50 -0800 (PST)
MIME-Version: 1.0
References: <20210108002005.3429956-1-olteanv@gmail.com> <20210108002005.3429956-9-olteanv@gmail.com>
 <CANn89iJNTgXsRv0Wgp4V=TUws-d4Mc4FwR4kUBy+r8+UxWC06Q@mail.gmail.com> <20210108103135.pxtsivlpf5xkmt5w@skbuf>
In-Reply-To: <20210108103135.pxtsivlpf5xkmt5w@skbuf>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 8 Jan 2021 11:38:38 +0100
Message-ID: <CANn89i+Wir=Di8yo+KPOWSTuaGMYLT7QpX=eKruL3kn-iuxP1Q@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 08/18] net: make dev_get_stats return void
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 11:31 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Fri, Jan 08, 2021 at 11:14:50AM +0100, Eric Dumazet wrote:
> > On Fri, Jan 8, 2021 at 1:20 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > After commit 28172739f0a2 ("net: fix 64 bit counters on 32 bit arches"),
> > > dev_get_stats got an additional argument for storage of statistics. At
> > > this point, dev_get_stats could return either the passed "storage"
> > > argument, or the output of .ndo_get_stats64.
> > >
> > > Then commit caf586e5f23c ("net: add a core netdev->rx_dropped counter")
> > > came, and the output of .ndo_get_stats64 (still returning a pointer to
> > > struct rtnl_link_stats64) started being ignored.
> > >
> > > Then came commit bc1f44709cf2 ("net: make ndo_get_stats64 a void
> > > function") which made .ndo_get_stats64 stop returning anything.
> > >
> > > So now, dev_get_stats always reports the "storage" pointer received as
> > > argument. This is useless. Some drivers are dealing with unnecessary
> > > complexity due to this, so refactor them to ignore the return value
> > > completely.
> > >
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > ---
> > >
> >
> > This seems like a lot of code churn.
>
> Not sure there's something I can do to avoid that.
>
> > Ultimately we need this function to return an error code, so why keep
> > this patch with a void return ?
> >
> > Please squash your patches a bit, to avoid having 18 patches to review.
>
> Because the "make dev_get_stats return void" patch changes the callers
> to poke through their stack-supplied struct rtnl_link_stats64 instead of
> through the returned pointer. So all changes within this patch are of
> the same type: replace a pointer dereference with a plain structure
> field access. Whereas the "allow ndo_get_stats64 to return an int error
> code" touches a completely unrelated portion: the ndo_get_stats64
> callback. Again, that patch does one thing and one thing only. Then
> there's the error checking, which is split in 3 patches:
> - Special cases with non-trivial work to do: FCoE, OVS
> - Propagation of errors from dev_get_stats
> - Termination of errors from dev_get_stats
>
> So you would like me to squash what exactly? I know there's a lot of
> patches, but if I go ahead and combine them, it'll be even more
> difficult to review, due to the mix of types of changes being applied.
>
> > Additionally I would suggest a __must_check attribute on
> > dev_get_stats() to make sure we converted all callers.
>
> Ok, but that will mean even more patches (since the error checking is
> done in 3 stages, the __must_check must be put at the end). And remember,
> the inflation of this series from 12 to 18 patches came from your
> suggestion to propagate the errors now.

I did not suggest adding more patches. where have you seen this exactly ?

>
> > I can not convince myself that after your patches, bonding does the
> > right thing...
>
> Why?

Because of this ?

+
+       /* Recurse with no locks taken */
+       for (i = 0; i < num_slaves; i++)
+               dev_get_stats(slaves[i], &dev_stats[i]);

Look, it seems you rely on us testing your patches, and spending more
time on review than you .

Please sit back, and test a bit more before sending a new series.

I think I will not spend more time on this, because it is obvious to
me that you consider that I _have_ to accept whatever solution you
came up,
because you think it is the optimal one.
