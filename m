Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868B22F63A7
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 16:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbhANPEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 10:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbhANPEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 10:04:46 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AA3C061574;
        Thu, 14 Jan 2021 07:04:05 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id l207so6193011oib.4;
        Thu, 14 Jan 2021 07:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/jHFgmoPeXHiV4YcqawMp6uZQ8LlT8fRndukyjzJVg8=;
        b=JPWfB/w9V9+Kw8HoApq5LrRQoQgHRMrEuu/H+ONr2nIkngZZX63asF57yR+pcHFaCf
         OM7rfUcxJPUfQ4lZulSLhfzm6izbNWbYHYqQUCeGRhw+C+FOy/AhGUbbAJxXJ4pdAwKB
         QG6F2zh4P7nNHoH3vBxc1NFHjFAPvs8sSIbrnq9cCyME0NDJ7zlKM6JXA4634ALhZfO7
         wjEH4iziCpeBrz+fkFSDh0zbLOpGNKvvqe8pnxYA2ReK11apeFxTK6vi+l0JpAUyezf1
         fhypWlMmxVKpqhwQe+9V0JBv/eY3o585oVkA7sHXM8U2w9sPEF7Cv6ySnpQ6dqn/m4KQ
         izFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/jHFgmoPeXHiV4YcqawMp6uZQ8LlT8fRndukyjzJVg8=;
        b=RYNNvIYRHRnBt4rl040xx2+mR349sQvDRHMMmQSY5GexCKa8BQjV06YTtfLYeLEcc3
         tXSBSgHnESo4CBYemQoMemPTJo0XgDv9d6x2M2MZf7GgfXu/+3s9cQQ0QD+kJNRwm7OR
         SapJnt7MR40tXDWGdPg64nqUhUsIVjrbQeCOBPUi6jcJF4KeSrepCYwjuWuENoWGIgfW
         ESLkEq7D7u13SEPbrsmmQpaQ26cjWopntuFTZnPIWOiaNLlK0rc8JSxxxbfWZA8IgxqH
         +hHK735n6qCCBjo/aEyNh4jZknPxlP7rOSPqxBgNzxNDgSzC879nIjITQ9p+nq2y3stR
         7dQA==
X-Gm-Message-State: AOAM531loF0AVbKi4FqkkR1GPOqQJ9udkGj9ChUYRNh1XW3cfflCCdQY
        kafDidExoO+gztDWP0MUDgs7MmZgK0fP09mZ7w==
X-Google-Smtp-Source: ABdhPJzLcYo0vmSHvOURWzZZv9H7hQYf9f4KTJGzSrGmc/uN1MH7bW93Frnz3tY06HdfSl/Ubw7GfZLvn2rmdqm/zhU=
X-Received: by 2002:a05:6808:8e7:: with SMTP id d7mr2876538oic.127.1610636645135;
 Thu, 14 Jan 2021 07:04:05 -0800 (PST)
MIME-Version: 1.0
References: <20210113145922.92848-1-george.mccollister@gmail.com>
 <20210113145922.92848-2-george.mccollister@gmail.com> <20210114010519.td6q2pzy4mg6viuh@skbuf>
In-Reply-To: <20210114010519.td6q2pzy4mg6viuh@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Thu, 14 Jan 2021 09:03:53 -0600
Message-ID: <CAFSKS=PZ5_FgtOmSq=9xCgYPmqnmwjp6v7JFwx1tyBCP8ayopQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/3] dsa: add support for Arrow XRS700x tag trailer
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 7:05 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > +++ b/net/dsa/tag_xrs700x.c
> > @@ -0,0 +1,67 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/*
> > + * XRS700x tag format handling
> > + * Copyright (c) 2008-2009 Marvell Semiconductor
>
> Why does Marvell get copyright?

What Andrew said. I started with tag_trailer.c since it is quite
similar and it seemed wrong to remove the copyright.

>
> > + * Copyright (c) 2020 NovaTech LLC
> > + */
> > +
> > +#include <linux/etherdevice.h>
> > +#include <linux/list.h>
> > +#include <linux/slab.h>
>
> These 3 includes are not needed. You can probably remove them later
> though, if there is no other reason to resend.

Removed.

>
> > +#include <linux/bitops.h>
> > +
> > +#include "dsa_priv.h"
> > +
> > +static struct sk_buff *xrs700x_xmit(struct sk_buff *skb, struct net_device *dev)
> > +{
> > +     struct dsa_port *dp = dsa_slave_to_port(dev);
> > +     u8 *trailer;
> > +
> > +     trailer = skb_put(skb, 1);
> > +     trailer[0] = BIT(dp->index);
> > +
> > +     return skb;
> > +}
> > +
> > +static struct sk_buff *xrs700x_rcv(struct sk_buff *skb, struct net_device *dev,
> > +                                struct packet_type *pt)
> > +{
> > +     int source_port;
> > +     u8 *trailer;
> > +
> > +     if (skb_linearize(skb))
> > +             return NULL;
>
> We've been through this, there should be no reason to linearize an skb
> for a one-byte tail tag..

Sorry about this. You and Andrew started discussing it and I guess I
got distracted fixing the other issues. Removed. I'll retest after
making other changes to patches in the series but based on what you've
said it should be fine without it.

>
> > +
> > +     trailer = skb_tail_pointer(skb) - 1;
> > +
> > +     source_port = ffs((int)trailer[0]) - 1;
> > +
> > +     if (source_port < 0)
> > +             return NULL;
> > +
> > +     skb->dev = dsa_master_find_slave(dev, 0, source_port);
> > +     if (!skb->dev)
> > +             return NULL;
> > +
> > +     if (pskb_trim_rcsum(skb, skb->len - 1))
> > +             return NULL;
> > +
> > +     /* Frame is forwarded by hardware, don't forward in software. */
> > +     skb->offload_fwd_mark = 1;
> > +
> > +     return skb;
> > +}
