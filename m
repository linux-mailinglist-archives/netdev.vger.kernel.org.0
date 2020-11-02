Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932EA2A2B8A
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 14:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgKBNbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 08:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgKBNbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 08:31:44 -0500
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDFEC061A04
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 05:31:44 -0800 (PST)
Received: by mail-vs1-xe43.google.com with SMTP id b3so7445944vsc.5
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 05:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U8agdBgymaEuQDP5CePwH7o+MQ0CrnDO0kIt0FoZX9U=;
        b=gz1wKr8No58IaMrtktJTYpMZ1V0LmOioVNr2UDxGIX6Zp1aJjvfnXm41EVsgWzltsr
         w1lBW0aZo8MYa4rOSOdUaZ3RJnrnpETuMA7lUXGV67CJBEnUzLLdiYbPFLmWOpGAEbcv
         T/3kbER0b3Mxjmk0AkAYOiyLJA4NBuH1JrP5Y85b9g/ZvaLS8NU138gdmZugsbkY920z
         /7k7QE0fzJaU4zU7pOrc+6J0uhg3EHLa9MjcQfhvf5iewrmWr6TC0N2egBCadKJ9OfUz
         Wc2ub0TbJCtm9KKXEU1Ke7CKtlh7NeDsEBQvd1h20VUwXH9b3ItyxGAMxpHNxxd97Rhy
         q1jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U8agdBgymaEuQDP5CePwH7o+MQ0CrnDO0kIt0FoZX9U=;
        b=cXat0S1hyACQt4iip/p2IZtmKUq3MWkN7dPzNsH970bklq4WsiGgzx6fg6I5KW60x9
         rZ1OdY+de0I7PMExKwEnHl13XlGBafYwl8UtpaKiPG33dIlUNTH9fYXajfeHi10OeFom
         prxWi4dfoJ1EO/cCU8QUKZvEXA71LUV8GBHQuypC+NPAx5iavgB5xG8nhOPwToD0rY8d
         A7e/lYJSa4D0crkBZ+tZyoJEjnTbtm9wiDyG2y10ndEolkk2PhHJYJYscPhS8l7vhx7l
         hfosSKRpzixv+i3RqBq57UmAhO3Olb3sqrwdEdIWm2fopjbgu3e66jujXRb9miM5AXeg
         c7xQ==
X-Gm-Message-State: AOAM532HAvkc0UqKCAQQ+f3K0NMWeXlGgY0EHuzqbW1Dq5U6gfQlsXYg
        t9MGb6Qp4GdCXE6lVvhEZM5gXPRx4SA=
X-Google-Smtp-Source: ABdhPJxASqhPXu4iemY76Ila5zaeq8pJi/gCDPIan3S19JjNjieHf8WbS8ElZvxvfga15VZm8t9Gmg==
X-Received: by 2002:a67:dd94:: with SMTP id i20mr7983815vsk.0.1604323902037;
        Mon, 02 Nov 2020 05:31:42 -0800 (PST)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com. [209.85.217.53])
        by smtp.gmail.com with ESMTPSA id u203sm1798234vkb.34.2020.11.02.05.31.40
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 05:31:40 -0800 (PST)
Received: by mail-vs1-f53.google.com with SMTP id z123so2721440vsb.0
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 05:31:40 -0800 (PST)
X-Received: by 2002:a67:c981:: with SMTP id y1mr13617880vsk.14.1604323899999;
 Mon, 02 Nov 2020 05:31:39 -0800 (PST)
MIME-Version: 1.0
References: <20201102050649.2188434-1-george.cherian@marvell.com> <20201102050649.2188434-2-george.cherian@marvell.com>
In-Reply-To: <20201102050649.2188434-2-george.cherian@marvell.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 2 Nov 2020 08:31:03 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdXOmzSX3Y__hEa=gk4nqFQDur7m9VsDJJ_cYPp2Asi_g@mail.gmail.com>
Message-ID: <CA+FuTSdXOmzSX3Y__hEa=gk4nqFQDur7m9VsDJJ_cYPp2Asi_g@mail.gmail.com>
Subject: Re: [net-next PATCH 1/3] octeontx2-af: Add devlink suppoort to af driver
To:     George Cherian <george.cherian@marvell.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, masahiroy@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 12:07 AM George Cherian
<george.cherian@marvell.com> wrote:
>
> Add devlink support to AF driver. Basic devlink support is added.
> Currently info_get is the only supported devlink ops.
>
> devlink ouptput looks like this
>  # devlink dev
>  pci/0002:01:00.0
>  # devlink dev info
>  pci/0002:01:00.0:
>   driver octeontx2-af
>   versions:
>       fixed:
>         mbox version: 9
>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Jerin Jacob <jerinj@marvell.com>
> Signed-off-by: George Cherian <george.cherian@marvell.com>

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> index 5ac9bb12415f..c112b299635d 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> @@ -12,7 +12,10 @@
>  #define RVU_H
>
>  #include <linux/pci.h>
> +#include <net/devlink.h>
> +
>  #include "rvu_struct.h"
> +#include "rvu_devlink.h"
>  #include "common.h"
>  #include "mbox.h"
>
> @@ -372,10 +375,10 @@ struct rvu {
>         struct npc_kpu_profile_adapter kpu;
>
>         struct ptp              *ptp;
> -

accidentally removed this line?

>  #ifdef CONFIG_DEBUG_FS
>         struct rvu_debugfs      rvu_dbg;
>  #endif
> +       struct rvu_devlink      *rvu_dl;
>  };


> +int rvu_register_dl(struct rvu *rvu)
> +{
> +       struct rvu_devlink *rvu_dl;
> +       struct devlink *dl;
> +       int err;
> +
> +       rvu_dl = kzalloc(sizeof(*rvu_dl), GFP_KERNEL);
> +       if (!rvu_dl)
> +               return -ENOMEM;
> +
> +       dl = devlink_alloc(&rvu_devlink_ops, sizeof(struct rvu_devlink));
> +       if (!dl) {
> +               dev_warn(rvu->dev, "devlink_alloc failed\n");
> +               return -ENOMEM;

rvu_dl not freed on error.

This happens a couple of times in these patches

Is the intermediate struct needed, or could you embed the fields
directly into rvu and use container_of to get from devlink to struct
rvu? Even if needed, perhaps easier to embed the struct into rvu
rather than a pointer.

> +       }
> +
> +       err = devlink_register(dl, rvu->dev);
> +       if (err) {
> +               dev_err(rvu->dev, "devlink register failed with error %d\n", err);
> +               devlink_free(dl);
> +               return err;
> +       }
> +
> +       rvu_dl->dl = dl;
> +       rvu_dl->rvu = rvu;
> +       rvu->rvu_dl = rvu_dl;
> +       return 0;
> +}
> +
> +void rvu_unregister_dl(struct rvu *rvu)
> +{
> +       struct rvu_devlink *rvu_dl = rvu->rvu_dl;
> +       struct devlink *dl = rvu_dl->dl;
> +
> +       if (!dl)
> +               return;
> +
> +       devlink_unregister(dl);
> +       devlink_free(dl);

here too
