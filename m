Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B915F2F7F9A
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 16:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731623AbhAOPbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 10:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729568AbhAOPbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 10:31:23 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE807C0613D3;
        Fri, 15 Jan 2021 07:30:42 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id j20so8859367otq.5;
        Fri, 15 Jan 2021 07:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qomuYvs4xV1f9BYVRlRCjVYqvWUMJMTCkUJTNsFtmHs=;
        b=uU2RSfP3MVaj5naLpWHSwuQrQlSKgrM3a0WpzuF9QCbzhsulZosdG+dgSfaOH3DSJa
         Os51wvTdoV5uJwbu6BnyXK2AhB0zMUrzXhM8krVnGITAf0WRyCkMe8LUueJPITYdA77a
         dOvIQpAwWQa8qYcu66rb3z0waXAgGF1hWO+XMZ5dLqBowMyPdsXW72WnsULu4UdMtUM8
         cc7xPNgfLl+xrnyjfCkqO6uAm6ptVpK1pTFTtIqsxOmjsqTfp20n8XfnzOBEnDU/ocQf
         fJWdvLDPTCSe7NPkkt38MOG7L0AmzIxqQ0t5c5uYo01QdodCkj014ltoF9ykKX3ycEkG
         x6cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qomuYvs4xV1f9BYVRlRCjVYqvWUMJMTCkUJTNsFtmHs=;
        b=BYRM9oNwV/C6aGUonS04BpVX/w1wWuNYnNR2eZ/3M/EpFId5aAEkp0bw/mHn69qXGx
         C3jP7AwHB3QOzgoEfZqo2uRC2L7Z3cie3wt9Rat6pRw7jA/E8DrYM6ed0GnbyFhsN+NR
         JHmQgXvJ9U2j7xmJj7qMukrOlP723/50/ZSje1IYa8JjGIYskqjtY/Hdod9b5a53lbRj
         L8mahklsMECuCKnIQZFNV4yY1Q5n5hnVXdq5H2t5ODzGU40JESb0EXMpx5PwAEnC9egC
         apxV8KINPhb+z/MjhuYay0wIYcGBFpqp6F1/XVOy8XJeCuZ0jJa+NI8wHhzdzp7Y/F+B
         rxZg==
X-Gm-Message-State: AOAM532Sh3/ErsXl1qo95BJJmOgDoM/3XVOsSAi9A3kLGg7tKgl1hSPN
        AOXUz2FGa6KUwIZdz6I3HlxXHFTRz5wH1Gi+YUUYhZNUSQidfZg=
X-Google-Smtp-Source: ABdhPJwmg8O62V4Grbmq5DW54J1+UgOanJ9yTHZKwrJtmZ8ukmW5eqF86ba4C+nPA+BZEZn8JPuKihabHCdH2DZnT6A=
X-Received: by 2002:a05:6830:1b7b:: with SMTP id d27mr8946037ote.132.1610724642193;
 Fri, 15 Jan 2021 07:30:42 -0800 (PST)
MIME-Version: 1.0
References: <20210114195734.55313-1-george.mccollister@gmail.com>
 <20210114195734.55313-3-george.mccollister@gmail.com> <20210114224843.374dmyzvtszat6m4@skbuf>
In-Reply-To: <20210114224843.374dmyzvtszat6m4@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Fri, 15 Jan 2021 09:30:29 -0600
Message-ID: <CAFSKS=P5u8YAL=1Rww0VqdHkcf11j7R-bJ02sj6pWoxvqRm3jw@mail.gmail.com>
Subject: Re: [PATCH net-next v5 2/3] net: dsa: add Arrow SpeedChips XRS700x driver
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

On Thu, Jan 14, 2021 at 4:48 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Thu, Jan 14, 2021 at 01:57:33PM -0600, George McCollister wrote:
[snip]
>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
>
> This driver is good to go, just one small nitpick below, you can fix it
> up afterwards if you want.
>
> > +static void xrs700x_port_stp_state_set(struct dsa_switch *ds, int port,
> > +                                    u8 state)
> > +{
> > +     struct xrs700x *priv = ds->priv;
> > +     unsigned int bpdus = 1;
> > +     unsigned int val;
> > +
> > +     switch (state) {
> > +     case BR_STATE_DISABLED:
> > +             bpdus = 0;
> > +             fallthrough;
> > +     case BR_STATE_BLOCKING:
> > +     case BR_STATE_LISTENING:
> > +             val = XRS_PORT_DISABLED;
> > +             break;
> > +     case BR_STATE_LEARNING:
> > +             val = XRS_PORT_LEARNING;
> > +             break;
> > +     case BR_STATE_FORWARDING:
> > +             val = XRS_PORT_FORWARDING;
> > +             break;
> > +     default:
> > +             dev_err(ds->dev, "invalid STP state: %d\n", state);
> > +             return;
> > +     }
> > +
> > +     regmap_fields_write(priv->ps_forward, port, val);
> > +
> > +     /* Enable/disable inbound policy added by xrs700x_port_add_bpdu_ipf()
> > +      * which allows BPDU forwarding to the CPU port when the front facing
> > +      * port is in disabled/learning state.
>                       ~~~~~~~~
> You probably mean blocking. When the port is in BR_STATE_DISABLED, you
> set bpdus = 1, which makes sense.

That doesn't sound quite right, let me try to explain this differently
and you can tell me if it makes more sense. If so I'll update it, add
the reviewed-bys and post v6:

Enable/disable inbound policy added by xrs700x_port_add_bpdu_ipf()
which allows BPDU forwarding to the CPU port. The policy must be
enabled when the front facing port is in BLOCKING, LISTENING and
LEARNING BR_STATEs since the switch doesn't otherwise forward BPDUs
when the port is set to XRS_PORT_DISABLED and XRS_PORT_LEARNING.

>
> > +      */
> > +     regmap_update_bits(priv->regmap, XRS_ETH_ADDR_CFG(port, 0), 1, bpdus);
> > +
> > +     dev_dbg_ratelimited(priv->dev, "%s - port: %d, state: %u, val: 0x%x\n",
> > +                         __func__, port, state, val);
> > +}
