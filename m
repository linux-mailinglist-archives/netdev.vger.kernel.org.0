Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BC22EF0B3
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 11:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbhAHKcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 05:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbhAHKcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 05:32:18 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64797C0612F4
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 02:31:38 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id cm17so10718373edb.4
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 02:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aL724oZUMoq4bD2Pt6OVfbE50njFBStf86zMkR/CrKU=;
        b=KjSQ6rNfBpW6FJjywBSSJUyuyeROsfH+gnik+UGuGW7D9WTk1iCgWs0ZzRKr3qWgZy
         o3aUVUOBQr+macGYzAlkzJHadEYxR5OO7o1ehziHYnDQaYlEA4D3q7Y702EEXjmRGSxV
         TJ1iND0SI+KLBBHMLcS2wAJU17pmsQBGClxg6FhgqX5Nwf1KRpHJCe89EeP+U96hUUuJ
         9gDP1aZlFn8ZDLdcNHyXRhZ/aX1F5xCdE9VD1Y61mX54tyuyeUzC8CCmGCDeZ7dUQ03q
         0XgGBQEnT28ZQwofMlVL9Apae5UPI1I8N5caef7afVdf1aL1jfFriZikmOKCLGpVfAj7
         Gmaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aL724oZUMoq4bD2Pt6OVfbE50njFBStf86zMkR/CrKU=;
        b=Z1BHhp+oTvtnLNaqSEHVXM6i7X7JyvgZl2BHcK/dESIhocXCxBWKUvuDkaSsnUEvYo
         ThT0AoOexqqIggR4dj5nwVJkZe56n/slPDjBlOD0Se8EdCOp9UQYQIcQkWvHH7KCuH2n
         ++tgLVbGeeQ/YPX6qC6L2yacZ9ydFmDPbEX05/DRFn3AyPjenxSl1b9CEhB2ijxpouI8
         Hbs2WUc+zQkOmP8plXIPWEAyC6YJGG5owSfzr5MRmzTv65Y2uDYj7kJmlOL3xnsv+Pmk
         IVVrEQooeKTiE7fsOsjkOIXN8EY4+dB3iii2Vw5oz7cdr1Zcbuo+vpielmDqjJIIdTlN
         gOeg==
X-Gm-Message-State: AOAM530Wc4pVrl/CLNJidWRkqO7r6oIjfKGdaA/vYaoLzsSctFaRfNsk
        4UnjP9vA5TfBKO2OFZreFh8=
X-Google-Smtp-Source: ABdhPJwBNJg283OzkVR5ObKnUv5IKwhPx5mH+Rf/3JuTxbzQXbmi+aZtMdEy/j0dOCDe60JU4FWlxQ==
X-Received: by 2002:a50:9dc9:: with SMTP id l9mr4775851edk.377.1610101897094;
        Fri, 08 Jan 2021 02:31:37 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id bn21sm3405291ejb.47.2021.01.08.02.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 02:31:36 -0800 (PST)
Date:   Fri, 8 Jan 2021 12:31:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
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
Subject: Re: [PATCH v4 net-next 08/18] net: make dev_get_stats return void
Message-ID: <20210108103135.pxtsivlpf5xkmt5w@skbuf>
References: <20210108002005.3429956-1-olteanv@gmail.com>
 <20210108002005.3429956-9-olteanv@gmail.com>
 <CANn89iJNTgXsRv0Wgp4V=TUws-d4Mc4FwR4kUBy+r8+UxWC06Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJNTgXsRv0Wgp4V=TUws-d4Mc4FwR4kUBy+r8+UxWC06Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 11:14:50AM +0100, Eric Dumazet wrote:
> On Fri, Jan 8, 2021 at 1:20 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > After commit 28172739f0a2 ("net: fix 64 bit counters on 32 bit arches"),
> > dev_get_stats got an additional argument for storage of statistics. At
> > this point, dev_get_stats could return either the passed "storage"
> > argument, or the output of .ndo_get_stats64.
> >
> > Then commit caf586e5f23c ("net: add a core netdev->rx_dropped counter")
> > came, and the output of .ndo_get_stats64 (still returning a pointer to
> > struct rtnl_link_stats64) started being ignored.
> >
> > Then came commit bc1f44709cf2 ("net: make ndo_get_stats64 a void
> > function") which made .ndo_get_stats64 stop returning anything.
> >
> > So now, dev_get_stats always reports the "storage" pointer received as
> > argument. This is useless. Some drivers are dealing with unnecessary
> > complexity due to this, so refactor them to ignore the return value
> > completely.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >
> 
> This seems like a lot of code churn.

Not sure there's something I can do to avoid that.

> Ultimately we need this function to return an error code, so why keep
> this patch with a void return ?
> 
> Please squash your patches a bit, to avoid having 18 patches to review.

Because the "make dev_get_stats return void" patch changes the callers
to poke through their stack-supplied struct rtnl_link_stats64 instead of
through the returned pointer. So all changes within this patch are of
the same type: replace a pointer dereference with a plain structure
field access. Whereas the "allow ndo_get_stats64 to return an int error
code" touches a completely unrelated portion: the ndo_get_stats64
callback. Again, that patch does one thing and one thing only. Then
there's the error checking, which is split in 3 patches:
- Special cases with non-trivial work to do: FCoE, OVS
- Propagation of errors from dev_get_stats
- Termination of errors from dev_get_stats

So you would like me to squash what exactly? I know there's a lot of
patches, but if I go ahead and combine them, it'll be even more
difficult to review, due to the mix of types of changes being applied.

> Additionally I would suggest a __must_check attribute on
> dev_get_stats() to make sure we converted all callers.

Ok, but that will mean even more patches (since the error checking is
done in 3 stages, the __must_check must be put at the end). And remember,
the inflation of this series from 12 to 18 patches came from your
suggestion to propagate the errors now.

> I can not convince myself that after your patches, bonding does the
> right thing...

Why?
