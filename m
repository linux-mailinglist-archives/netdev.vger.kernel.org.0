Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A30B635504
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 10:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237220AbiKWJNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 04:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237196AbiKWJNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 04:13:54 -0500
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F4387A76;
        Wed, 23 Nov 2022 01:13:53 -0800 (PST)
Received: by mail-pf1-f174.google.com with SMTP id b29so16754935pfp.13;
        Wed, 23 Nov 2022 01:13:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=srlt3bFZ6MegHyi5woaD55H1HX/2p/E5mzMQRE78ubI=;
        b=mCOaP5A/twvoIWOM5puvcLpXNa8xGnl0XMQLJoDaW7vOX5vJm/zOvs2M36bPSLf5wA
         o5Vo6uu6UcLAmAUwY9wldYCNxfNE4qgG+fRAk08kCim8c4CE0vOqkJihmS5dgOqrxHQR
         1INhVMBsHcHvcLnW0ZWlRnobqf0kYIQomqwHC7jxw/b0v2okk2T/0m7O72nYtA9Y6LQ7
         ps87QH0cA6NbU3hoSYOy0j9Sw5GMAD1hYjF4lwj0FaZesz1BNI9Yjt4aOdepms4xBojm
         lsl+2Rz3XMQjyh8LZ6NHdjmim+84bw859okK8GSGme3Mhv7ohkVpjO5sLc/PIV/7DwvX
         zN5A==
X-Gm-Message-State: ANoB5pmeCpVH95dTHHORtg46MS0XK3D0Kxux6EFccfWwzwnW4BRD/W/m
        TC9KVeNzBRnQh9BUdyVf6U1Lv/qwzQuiM0zjsE5lT61sqOVlHw==
X-Google-Smtp-Source: AA0mqf6QcMoZUHVOXKOq7hmkMSMne2of/jIYq+ZRoWhH4Ple3ls0lT37Jo65bmF4tS5WSNRvBdMk6kxBtbk0gZCrA6Q=
X-Received: by 2002:a63:1955:0:b0:477:50ed:6415 with SMTP id
 21-20020a631955000000b0047750ed6415mr15313204pgz.535.1669194832632; Wed, 23
 Nov 2022 01:13:52 -0800 (PST)
MIME-Version: 1.0
References: <20221123074214.21538-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20221123074214.21538-1-lukas.bulwahn@gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 23 Nov 2022 18:13:41 +0900
Message-ID: <CAMZ6RqLmgLMpkfrv1cM=8HhScTGoL6noozwGx36hYQmb1EKPQw@mail.gmail.com>
Subject: Re: [PATCH] can: etas_es58x: repair conditional for a verbose debug message
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lukas,

Thank you for reporting this bug.

On Wed. 23 Nov. 2022 at 16:45, Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
> The definition of VERBOSE_DEBUG for detailled debugging is set simply by
                                      ^^^^^^^^^
detailed

> adding "#define VERBOSE_DEBUG" in the source code. It is not a kernel
> configuration that is prefixed by CONFIG.

ACK.
I initially used #ifdef VERBOSE_DEBUG but then inadvertently replaced
it by IS_ENABLED(CONFIG_VERBOSE_DEBUG) instead of
defined(VERBOSE_DEBUG).

> As the netdev_vdbg() macro is already defined conditional on
> defined(VERBOSE_DEBUG), there is really no need to duplicate the check
> before calling netdev_vdbg().

NACK.

There is a need. net_ratelimit() will continue to emit those messages:

  net_ratelimit: xxxx callbacks suppressed

The goal of this check is to guard net_ratelimit(), not to guard netdev_vdbg().

> Repair the conditional for a verbose debug message.
>

If you want to send a v2, please also add the fix tag:
Fixes: commit 8537257874e9 ("can: etas_es58x: add core support for
ETAS ES58X CAN USB interfaces")

> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
>  drivers/net/can/usb/etas_es58x/es58x_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
> index 25f863b4f5f0..2708909fb851 100644
> --- a/drivers/net/can/usb/etas_es58x/es58x_core.c
> +++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
> @@ -989,7 +989,7 @@ int es58x_rx_cmd_ret_u32(struct net_device *netdev,
>                         break;
>
>                 case ES58X_RET_TYPE_TX_MSG:
> -                       if (IS_ENABLED(CONFIG_VERBOSE_DEBUG) && net_ratelimit())
> +                       if (net_ratelimit())
>                                 netdev_vdbg(netdev, "%s: OK\n", ret_desc);
>                         break;
>
> --
> 2.17.1
>
