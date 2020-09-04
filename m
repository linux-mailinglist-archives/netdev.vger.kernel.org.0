Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93CF125E203
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 21:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgIDTie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 15:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgIDTid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 15:38:33 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BE5C061244;
        Fri,  4 Sep 2020 12:38:33 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mm21so3674034pjb.4;
        Fri, 04 Sep 2020 12:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=srMe0q/dUf+fYtOAIii05KtFKJa3HxZ/IRTBqWOl530=;
        b=D5hsv+de3TVfbtbwqqcjV4Lb2xlQWcVNneufRvf1NhguLk3BsJvx+fzhhQ6UNi9oxA
         uwP8pfla6yynZOI/O+B0aecnXMy160b0DiPTOu8flcFdOMWUvnPV2P+pL6C4yDFI2mNt
         Gh88XnBxTV2rEyHm4egtqBXJEclBNrQ+cQTOoq5+FpmXoaEqVZ/xMfJtvzCLPL83La0N
         q52/eLk9OFhbxWrJJdjgG3633AX1EsLxVz0LHZ+yJsRM+3BLzp1afwd0Zgn3pK27PtZD
         TW0H5uA/Gbe3cC8R8WG1J5+bqy7Xb/dm5GCcGYKnj76vrGWZZ2307NwQspOfU2/G714f
         FDWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=srMe0q/dUf+fYtOAIii05KtFKJa3HxZ/IRTBqWOl530=;
        b=O8EC/bi8PRzLZIb5E3d101NHzCK2fuxZfT5dGCMZo1lFrTa9xk6FOLN4nl0i0ClThQ
         DkImjM+Kji87e8V8bVoIY4adgHLAZXsbfyJ+2IgF5HTyq0TUINWw9TfsaLSPSH5c1Hvt
         Ne20FfvBaEcxeeLm2z3Kxa0kAs3bm1T0hzBV25AMtShHCqFyCoXNW8bG/8uB1gOHWOk0
         U/Ud/qMjKUPPHjnq7aFVODei2q2QW2W4gWgPXFU/4G0Y6hU+GR0ziqUsFjhGs1YXTqp3
         Ck74gJHZdmExICI7zRaQ8fWcOwEc4BlfcnQE8l76BMWRGAITj1XFjiGahCuyqbp+OEOe
         xcxw==
X-Gm-Message-State: AOAM530fEB0GOkbbl4XA4riUaic+vDNIdU6lnH0DeIUkCgeGxOZMJ9IS
        fylFcrU4jf7BhIqZ2M+H1X0p3nq8doVlt5SUvy4=
X-Google-Smtp-Source: ABdhPJxd15WUtvEkm9IpcVUeCRtsuTT5I55S9qVkF+h4gfa25UwheuY1WRrjQ0Hik5cEaFOlI1fxa0RAtfWWrOZcGLI=
X-Received: by 2002:a17:902:ea86:: with SMTP id x6mr10086698plb.131.1599248312463;
 Fri, 04 Sep 2020 12:38:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200904165222.18444-1-vadym.kochan@plvision.eu> <20200904165222.18444-5-vadym.kochan@plvision.eu>
In-Reply-To: <20200904165222.18444-5-vadym.kochan@plvision.eu>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 4 Sep 2020 22:38:15 +0300
Message-ID: <CAHp75VdowNYwS76QEq6YqyvD84y61jTLACLLWoBDF3K27g45tA@mail.gmail.com>
Subject: Re: [PATCH net-next v7 4/6] net: marvell: prestera: Add ethtool
 interface support
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 4, 2020 at 7:52 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
>
> The ethtool API provides support for the configuration of the following
> features: speed and duplex, auto-negotiation, MDI-x, forward error
> correction, port media type. The API also provides information about the
> port status, hardware and software statistic. The following limitation
> exists:
>
>     - port media type should be configured before speed setting
>     - ethtool -m option is not supported
>     - ethtool -p option is not supported
>     - ethtool -r option is supported for RJ45 port only
>     - the following combination of parameters is not supported:
>
>           ethtool -s sw1pX port XX autoneg on
>
>     - forward error correction feature is supported only on SFP ports, 10G
>       speed
>
>     - auto-negotiation and MDI-x features are not supported on
>       Copper-to-Fiber SFP module

...

> +#include <linux/kernel.h>
> +#include <linux/netdevice.h>
> +#include <linux/ethtool.h>

Sorted?

...

> +       if (new_mode < PRESTERA_LINK_MODE_MAX)
> +               err = prestera_hw_port_link_mode_set(port, new_mode);
> +       else
> +               err = -EINVAL;
> +

> +       if (!err) {
> +               port->caps.type = type;
> +               port->autoneg = false;
> +       }
> +
> +       return err;

Traditional pattern?

if (err)
 return err;
...
return 0;

...

> +       ecmd->base.speed = !err ? speed : SPEED_UNKNOWN;

Why not err : SPEED_... : speed; ?

...

> +static int
> +prestera_ethtool_get_link_ksettings(struct net_device *dev,

One line?

> +                                   struct ethtool_link_ksettings *ecmd)

...

> +       err = prestera_hw_port_link_mode_get(port, &curr_mode);
> +       if (err || curr_mode >= PRESTERA_LINK_MODE_MAX)
> +               return -EINVAL;

Why shadowing error code?

...

> +/*
> + * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
> + *
> + */

One line.

...

> +#include <linux/netdevice.h>

Is this being used?

> +#include <linux/ethtool.h>
> +
> +extern const struct ethtool_ops prestera_ethtool_ops;

...

> +enum {
> +       PRESTERA_FC_NONE,
> +       PRESTERA_FC_SYMMETRIC,
> +       PRESTERA_FC_ASYMMETRIC,
> +       PRESTERA_FC_SYMM_ASYMM

Comma?

> +};

...

> +       struct prestera_msg_port_attr_req req = {
> +               .attr = PRESTERA_CMD_PORT_ATTR_REMOTE_CAPABILITY,
> +               .port = port->hw_id,
> +               .dev = port->dev_id

Comma?

> +       };

...

> +       err = prestera_cmd_ret(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_GET,
> +                              &req.cmd, sizeof(req), &resp.ret, sizeof(resp));
> +       if (err)
> +               return err;
> +
> +       *link_mode_bitmap = resp.param.cap.link_mode;
> +
> +       return err;

return 0;

I think I have talked that any of the given comments applies to *all*
similar code pieces!

This file is full of repetitions of the above.

...

> +static u8 prestera_hw_mdix_to_eth(u8 mode)
> +{
> +       switch (mode) {
> +       case PRESTERA_PORT_TP_MDI:
> +               return ETH_TP_MDI;
> +       case PRESTERA_PORT_TP_MDIX:
> +               return ETH_TP_MDI_X;
> +       case PRESTERA_PORT_TP_AUTO:
> +               return ETH_TP_MDI_AUTO;
> +       }
> +
> +       return ETH_TP_MDI_INVALID;

default.
Also I have a deja vu about such.

> +}
> +
> +static u8 prestera_hw_mdix_from_eth(u8 mode)
> +{
> +       switch (mode) {
> +       case ETH_TP_MDI:
> +               return PRESTERA_PORT_TP_MDI;
> +       case ETH_TP_MDI_X:
> +               return PRESTERA_PORT_TP_MDIX;
> +       case ETH_TP_MDI_AUTO:
> +               return PRESTERA_PORT_TP_AUTO;
> +       }
> +
> +       return PRESTERA_PORT_TP_NA;
> +}

Ditto.

...

> +enum {
> +       PRESTERA_PORT_DUPLEX_HALF,
> +       PRESTERA_PORT_DUPLEX_FULL

Comma ?

> +};

-- 
With Best Regards,
Andy Shevchenko
