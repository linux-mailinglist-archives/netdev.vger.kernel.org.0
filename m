Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA423030D7
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 01:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732706AbhAZAHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 19:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732575AbhAZAHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 19:07:37 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFEBC061574;
        Mon, 25 Jan 2021 16:06:56 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id g12so20591979ejf.8;
        Mon, 25 Jan 2021 16:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s0qDWtLwcyse6Vw+4qM2uEdaJXfCHIGfegIlcnD3nSg=;
        b=XzALX73D2ahOpMtnBeDzQZdG8emxXcoDU47wCB6L7ZrQvNSpSSNUxTqfEhYv59IDEQ
         515cfRf12SN7Kd8rZoZrCaQtDBCu90ZhHOcvT0WaVyJSotIU4kkSxgUhPcMdImkNnwqh
         Slo4NPmBV8SzdaWtme3ek/eFNq2JwodAJy+g3iHFYwz6QWVJXbxGhQE0xMu9SawdeNcz
         Jz8PQfyGztxUXQ7yvawUqtm8Y93I3q8f+EqtCY6czY1VHUx+fGfwC57Fq9wob1gCKHEy
         7MUVG1alEHQE2vTRaLZ+O8sXh/U/HF8PK4hnRZQksgU0RYKEFmAOIXtibjy1MND8aKMS
         Pc5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s0qDWtLwcyse6Vw+4qM2uEdaJXfCHIGfegIlcnD3nSg=;
        b=b2S8iYFnAW+doJXSKT77yxVojZCnRMD0iD+Cuqc98z/EZL9Iwg+nNxWVx595JPgbMX
         CaVeWHqTFy/YQNKzFtlTjYX5yWiM/ndUd6qcx501HS8wGsTqWP+kjaKMlV0/P9znnAJH
         rr0Bu760GQgJoYK3YTVCMKg2E8kROmuD6fnLO+/zSUDhwCsw78fqF6cqKcwrlPI+dqFM
         0yPnHGm1pCTfJYRs1FkoKffHxJ1PJfdD1WkRBdVbszhqZv7OmuUu1au3Gbdi8JouNoZh
         y3y3Vycq15np1adh/MfyXXSrgne3NFkKj60RbthHFFnePLPm6xAp2e+CiSK9oij3AqJj
         0FZQ==
X-Gm-Message-State: AOAM531Myi5TIhA5e7XEqm0ASTfj05kq0sU5n5c8tadLrJs+r48mSsUL
        yh/51X2CC6eyZLL2a8Yly9wNNHJ1mm3CUMMlTDY=
X-Google-Smtp-Source: ABdhPJxoPkFKN90hhXSMg3s7SqZzzhxZ+tsgeRmXet6l8yCvGGsUtV7K0xqPgQyOExb864fQKuQUFbprfNPjamSR1kQ=
X-Received: by 2002:a17:906:3f8d:: with SMTP id b13mr1804751ejj.464.1611619614733;
 Mon, 25 Jan 2021 16:06:54 -0800 (PST)
MIME-Version: 1.0
References: <20210123161812.1043345-1-horatiu.vultur@microchip.com> <20210123161812.1043345-4-horatiu.vultur@microchip.com>
In-Reply-To: <20210123161812.1043345-4-horatiu.vultur@microchip.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 25 Jan 2021 19:06:18 -0500
Message-ID: <CAF=yD-KdqagGYZwzke-tX257JbtbPwi-2p0esOV1EFX3DN_ZUg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] bridge: mrp: Extend br_mrp_switchdev to
 detect better the errors
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        ivecera@redhat.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, roopa@nvidia.com,
        nikolay@nvidia.com, Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 11:23 AM Horatiu Vultur
<horatiu.vultur@microchip.com> wrote:
>
> This patch extends the br_mrp_switchdev functions to be able to have a
> better understanding what cause the issue and if the SW needs to be used
> as a backup.
>
> There are the following cases:
> - when the code is compiled without CONFIG_NET_SWITCHDEV. In this case
>   return success so the SW can continue with the protocol. Depending on
>   the function it returns 0 or BR_MRP_SW.
> - when code is compiled with CONFIG_NET_SWITCHDEV and the driver doesn't
>   implement any MRP callbacks, then the HW can't run MRP so it just
>   returns -EOPNOTSUPP. So the SW will stop further to configure the
>   node.
> - when code is compiled with CONFIG_NET_SWITCHDEV and the driver fully
>   supports any MRP functionality then the SW doesn't need to do
>   anything.  The functions will return 0 or BR_MRP_HW.
> - when code is compiled with CONFIG_NET_SWITCHDEV and the HW can't run
>   completely the protocol but it can help the SW to run it.  For
>   example, the HW can't support completely MRM role(can't detect when it
>   stops receiving MRP Test frames) but it can redirect these frames to
>   CPU. In this case it is possible to have a SW fallback. The SW will
>   try initially to call the driver with sw_backup set to false, meaning
>   that the HW can implement completely the role. If the driver returns
>   -EOPNOTSUPP, the SW will try again with sw_backup set to false,
>   meaning that the SW will detect when it stops receiving the frames. In
>   case the driver returns 0 then the SW will continue to configure the
>   node accordingly.
>
> In this way is more clear when the SW needs to stop configuring the
> node, or when the SW is used as a backup or the HW can implement the
> functionality.
>
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>


> -int br_mrp_switchdev_set_ring_role(struct net_bridge *br,
> -                                  struct br_mrp *mrp,
> -                                  enum br_mrp_ring_role_type role)
> +enum br_mrp_hw_support
> +br_mrp_switchdev_set_ring_role(struct net_bridge *br, struct br_mrp *mrp,
> +                              enum br_mrp_ring_role_type role)
>  {
>         struct switchdev_obj_ring_role_mrp mrp_role = {
>                 .obj.orig_dev = br->dev,
>                 .obj.id = SWITCHDEV_OBJ_ID_RING_ROLE_MRP,
>                 .ring_role = role,
>                 .ring_id = mrp->ring_id,
> +               .sw_backup = false,
>         };
>         int err;
>
> +       /* If switchdev is not enabled then just run in SW */
> +       if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
> +               return BR_MRP_SW;
> +
> +       /* First try to see if HW can implement comptletly the role in HW */

typo: completely

>         if (role == BR_MRP_RING_ROLE_DISABLED)
>                 err = switchdev_port_obj_del(br->dev, &mrp_role.obj);
>         else
>                 err = switchdev_port_obj_add(br->dev, &mrp_role.obj, NULL);
>
> -       return err;
> +       /* In case of success then just return and notify the SW that doesn't
> +        * need to do anything
> +        */
> +       if (!err)
> +               return BR_MRP_HW;
> +
> +       /* There was some issue then is not possible at all to have this role so
> +        * just return failire

typo: failure

> +        */
> +       if (err != -EOPNOTSUPP)
> +               return BR_MRP_NONE;
> +
> +       /* In case the HW can't run complety in HW the protocol, we try again

typo: completely. Please proofread your comments closely. I saw at
least one typo in the commit messages too.

More in general comments that say what the code does can generally be eschewed.

> +        * and this time to allow the SW to help, but the HW needs to redirect
> +        * the frames to CPU.
> +        */
> +       mrp_role.sw_backup = true;
> +       err = switchdev_port_obj_add(br->dev, &mrp_role.obj, NULL);

This calls the same function. I did not see code that changes behavior
based on sw_backup. Will this not give the same result?

Also, this lacks the role test (add or del). Is that because if
falling back onto SW mode during add, this code does not get called at
all on delete?

> +
> +       /* In case of success then notify the SW that it needs to help with the
> +        * protocol
> +        */
> +       if (!err)
> +               return BR_MRP_SW;
> +
> +       return BR_MRP_NONE;
>  }
>
> -int br_mrp_switchdev_send_ring_test(struct net_bridge *br,
> -                                   struct br_mrp *mrp, u32 interval,
> -                                   u8 max_miss, u32 period,
> -                                   bool monitor)
> +enum br_mrp_hw_support
> +br_mrp_switchdev_send_ring_test(struct net_bridge *br, struct br_mrp *mrp,
> +                               u32 interval, u8 max_miss, u32 period,
> +                               bool monitor)
>  {
>         struct switchdev_obj_ring_test_mrp test = {
>                 .obj.orig_dev = br->dev,
> @@ -79,12 +106,29 @@ int br_mrp_switchdev_send_ring_test(struct net_bridge *br,
>         };
>         int err;
>
> +       /* If switchdev is not enabled then just run in SW */
> +       if (!IS_ENABLED(CONFIG_NET_SWITCHDEV))
> +               return BR_MRP_SW;
> +
>         if (interval == 0)
>                 err = switchdev_port_obj_del(br->dev, &test.obj);
>         else
>                 err = switchdev_port_obj_add(br->dev, &test.obj, NULL);
>
> -       return err;
> +       /* If everything succeed then the HW can send this frames, so the SW
> +        * doesn't need to generate them
> +        */
> +       if (!err)
> +               return BR_MRP_HW;
> +
> +       /* There was an error when the HW was configured so the SW return
> +        * failure
> +        */
> +       if (err != -EOPNOTSUPP)
> +               return BR_MRP_NONE;
> +
> +       /* So the HW can't generate these frames so allow the SW to do that */
> +       return BR_MRP_SW;

This is the same ternary test as above. It recurs a few times. Perhaps
it can use a helper.
