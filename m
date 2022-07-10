Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D51C56CFD1
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 17:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiGJPi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 11:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiGJPiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 11:38:54 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3785626F5
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 08:38:53 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id c15so3717375ljr.0
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 08:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4InbvFypZX6TmIbBp6levT/VKpWVJCxkgia4Yfn1yWU=;
        b=r74VLAZ//WKA5rgX28jJ8k9zfNT1Y6zrKsGOS9zGMgSkq8WYQOfUfCec7RuXCSQOPm
         /g4mjm/7kdnglWLDp2JgO2hIhByRa8Haisq5ns3JBO+veBI38f/wKJ/dToUPcAR9k3JY
         hPVAXuq3rRBjvcJ+Efb3SeuG9yNAfUStaN2ME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4InbvFypZX6TmIbBp6levT/VKpWVJCxkgia4Yfn1yWU=;
        b=zLNSStKxDmfpVNCWEgOEiSzzKua/6dGCFvBAFE8FLZt+8Ww4uEZrPwiuPVJDoLtyxU
         B/KAYPl+3Z+ciJTcBV2CSPPh5kb1x2l1pdMOthHc/oYFV2mErgt0cL4Rygl8oKHIDY4B
         7lGpXNjDTtdA5GFRHv7nd0ZJKU1VB9Wc7VFC2UVl6CAK+QmRjXafSILd3Tbdn10dn9hy
         hczgm36Pim5bf/mes0VlGtZHe8iH/+zu7dNwuaTjr1N2DJZW0nGe0Bd7P0Y57NOuWmhO
         DM+72NxBfD+UYUb/4Rk/0Ztx+OPcaCLTwdp9IKTlAKehpu9bqut8kbkCqO8Yv9gp/j7k
         bvnw==
X-Gm-Message-State: AJIora+UhJLXmetmlrXyWAN4aetwqvaePJuec0viEaw8TxqadBVGh0jE
        8172b4qko50Pq4xDKlRHnhOHvghpvXve859izx81Fw==
X-Google-Smtp-Source: AGRyM1vzAjNt9Gs4XXh0+aJbjy7FGZiws66c9r99HhobblyVxG1cQA9cChLx+/sP50bdhhC4cB5mpKnmZ3USXNCcLVw=
X-Received: by 2002:a2e:6e0c:0:b0:255:98fb:cb45 with SMTP id
 j12-20020a2e6e0c000000b0025598fbcb45mr7502614ljc.55.1657467531473; Sun, 10
 Jul 2022 08:38:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220703101430.1306048-1-mkl@pengutronix.de> <20220703101430.1306048-9-mkl@pengutronix.de>
In-Reply-To: <20220703101430.1306048-9-mkl@pengutronix.de>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Sun, 10 Jul 2022 17:38:40 +0200
Message-ID: <CABGWkvpcHhicFGs96+czuTeVuxbXoKXx_XPvQPGt98GEvqr6aw@mail.gmail.com>
Subject: Re: [PATCH net-next 08/15] can: slcan: use CAN network device driver API
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Jeroen Hofstee <jhofstee@victronenergy.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Sun, Jul 3, 2022 at 12:26 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> From: Dario Binacchi <dario.binacchi@amarulasolutions.com>
>
> As suggested by commit [1], now the driver uses the functions and the
> data structures provided by the CAN network device driver interface.
>
> Currently the driver doesn't implement a way to set bitrate for SLCAN
> based devices via ip tool, so you'll have to do this by slcand or
> slcan_attach invocation through the -sX parameter:
>
> - slcan_attach -f -s6 -o /dev/ttyACM0
> - slcand -f -s8 -o /dev/ttyUSB0
>
> where -s6 in will set adapter's bitrate to 500 Kbit/s and -s8 to
> 1Mbit/s.
> See the table below for further CAN bitrates:
> - s0 ->   10 Kbit/s
> - s1 ->   20 Kbit/s
> - s2 ->   50 Kbit/s
> - s3 ->  100 Kbit/s
> - s4 ->  125 Kbit/s
> - s5 ->  250 Kbit/s
> - s6 ->  500 Kbit/s
> - s7 ->  800 Kbit/s
> - s8 -> 1000 Kbit/s
>
> In doing so, the struct can_priv::bittiming.bitrate of the driver is not
> set and since the open_candev() checks that the bitrate has been set, it
> must be a non-zero value, the bitrate is set to a fake value (-1U)
> before it is called.
>
> Using the rtnl_lock()/rtnl_unlock() functions has become a bit more
> tricky as the register_candev() function indirectly calls rtnl_lock()
> via register_netdev(). To avoid a deadlock it is therefore necessary to
> call rtnl_unlock() before calling register_candev(). The same goes for
> the unregister_candev() function.
>
> [1] commit 39549eef3587f ("can: CAN Network device driver and Netlink interface")
>
> Link: https://lore.kernel.org/all/20220628163137.413025-6-dario.binacchi@amarulasolutions.com
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> Tested-by: Jeroen Hofstee <jhofstee@victronenergy.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  drivers/net/can/Kconfig | 40 ++++++++++----------
>  drivers/net/can/slcan.c | 82 ++++++++++++++++++++---------------------
>  2 files changed, 60 insertions(+), 62 deletions(-)
>
> diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
> index 4078d0775572..3048ad77edb3 100644
> --- a/drivers/net/can/Kconfig
> +++ b/drivers/net/can/Kconfig
> @@ -49,26 +49,6 @@ config CAN_VXCAN
>           This driver can also be built as a module.  If so, the module
>           will be called vxcan.
>
> -config CAN_SLCAN
> -       tristate "Serial / USB serial CAN Adaptors (slcan)"
> -       depends on TTY
> -       help
> -         CAN driver for several 'low cost' CAN interfaces that are attached
> -         via serial lines or via USB-to-serial adapters using the LAWICEL
> -         ASCII protocol. The driver implements the tty linediscipline N_SLCAN.
> -
> -         As only the sending and receiving of CAN frames is implemented, this
> -         driver should work with the (serial/USB) CAN hardware from:
> -         www.canusb.com / www.can232.com / www.mictronics.de / www.canhack.de
> -
> -         Userspace tools to attach the SLCAN line discipline (slcan_attach,
> -         slcand) can be found in the can-utils at the linux-can project, see
> -         https://github.com/linux-can/can-utils for details.
> -
> -         The slcan driver supports up to 10 CAN netdevices by default which
> -         can be changed by the 'maxdev=xx' module option. This driver can
> -         also be built as a module. If so, the module will be called slcan.
> -
>  config CAN_NETLINK
>         bool "CAN device drivers with Netlink support"
>         default y
> @@ -172,6 +152,26 @@ config CAN_KVASER_PCIEFD
>             Kvaser Mini PCI Express HS v2
>             Kvaser Mini PCI Express 2xHS v2
>
> +config CAN_SLCAN
> +       tristate "Serial / USB serial CAN Adaptors (slcan)"
> +       depends on TTY
> +       help
> +         CAN driver for several 'low cost' CAN interfaces that are attached
> +         via serial lines or via USB-to-serial adapters using the LAWICEL
> +         ASCII protocol. The driver implements the tty linediscipline N_SLCAN.
> +
> +         As only the sending and receiving of CAN frames is implemented, this
> +         driver should work with the (serial/USB) CAN hardware from:
> +         www.canusb.com / www.can232.com / www.mictronics.de / www.canhack.de
> +
> +         Userspace tools to attach the SLCAN line discipline (slcan_attach,
> +         slcand) can be found in the can-utils at the linux-can project, see
> +         https://github.com/linux-can/can-utils for details.
> +
> +         The slcan driver supports up to 10 CAN netdevices by default which
> +         can be changed by the 'maxdev=xx' module option. This driver can
> +         also be built as a module. If so, the module will be called slcan.
> +
>  config CAN_SUN4I
>         tristate "Allwinner A10 CAN controller"
>         depends on MACH_SUN4I || MACH_SUN7I || COMPILE_TEST
> diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
> index c39580b142e0..bf84698f1a81 100644
> --- a/drivers/net/can/slcan.c
> +++ b/drivers/net/can/slcan.c
> @@ -56,7 +56,6 @@
>  #include <linux/can.h>
>  #include <linux/can/dev.h>
>  #include <linux/can/skb.h>
> -#include <linux/can/can-ml.h>
>
>  MODULE_ALIAS_LDISC(N_SLCAN);
>  MODULE_DESCRIPTION("serial line CAN interface");
> @@ -79,6 +78,7 @@ MODULE_PARM_DESC(maxdev, "Maximum number of slcan interfaces");
>  #define SLC_EFF_ID_LEN 8
>
>  struct slcan {
> +       struct can_priv         can;
>         int                     magic;
>
>         /* Various fields. */
> @@ -394,6 +394,8 @@ static int slc_close(struct net_device *dev)
>                 clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
>         }
>         netif_stop_queue(dev);
> +       close_candev(dev);
> +       sl->can.state = CAN_STATE_STOPPED;
>         sl->rcount   = 0;
>         sl->xleft    = 0;
>         spin_unlock_bh(&sl->lock);

Maybe better to move the spin_unlock_bh() before calling close_candev()?

Thanks and regards,
Dario

> @@ -405,20 +407,34 @@ static int slc_close(struct net_device *dev)
>  static int slc_open(struct net_device *dev)
>  {
>         struct slcan *sl = netdev_priv(dev);
> +       int err;
>
>         if (sl->tty == NULL)
>                 return -ENODEV;
>
> +       /* The baud rate is not set with the command
> +        * `ip link set <iface> type can bitrate <baud>' and therefore
> +        * can.bittiming.bitrate is CAN_BITRATE_UNSET (0), causing
> +        * open_candev() to fail. So let's set to a fake value.
> +        */
> +       sl->can.bittiming.bitrate = CAN_BITRATE_UNKNOWN;
> +       err = open_candev(dev);
> +       if (err) {
> +               netdev_err(dev, "failed to open can device\n");
> +               return err;
> +       }
> +
> +       sl->can.state = CAN_STATE_ERROR_ACTIVE;
>         sl->flags &= BIT(SLF_INUSE);
>         netif_start_queue(dev);
>         return 0;
>  }
>
> -/* Hook the destructor so we can free slcan devs at the right point in time */
> -static void slc_free_netdev(struct net_device *dev)
> +static void slc_dealloc(struct slcan *sl)
>  {
> -       int i = dev->base_addr;
> +       int i = sl->dev->base_addr;
>
> +       free_candev(sl->dev);
>         slcan_devs[i] = NULL;
>  }
>
> @@ -434,24 +450,6 @@ static const struct net_device_ops slc_netdev_ops = {
>         .ndo_change_mtu         = slcan_change_mtu,
>  };
>
> -static void slc_setup(struct net_device *dev)
> -{
> -       dev->netdev_ops         = &slc_netdev_ops;
> -       dev->needs_free_netdev  = true;
> -       dev->priv_destructor    = slc_free_netdev;
> -
> -       dev->hard_header_len    = 0;
> -       dev->addr_len           = 0;
> -       dev->tx_queue_len       = 10;
> -
> -       dev->mtu                = CAN_MTU;
> -       dev->type               = ARPHRD_CAN;
> -
> -       /* New-style flags. */
> -       dev->flags              = IFF_NOARP;
> -       dev->features           = NETIF_F_HW_CSUM;
> -}
> -
>  /******************************************
>    Routines looking at TTY side.
>   ******************************************/
> @@ -514,11 +512,8 @@ static void slc_sync(void)
>  static struct slcan *slc_alloc(void)
>  {
>         int i;
> -       char name[IFNAMSIZ];
>         struct net_device *dev = NULL;
> -       struct can_ml_priv *can_ml;
>         struct slcan       *sl;
> -       int size;
>
>         for (i = 0; i < maxdev; i++) {
>                 dev = slcan_devs[i];
> @@ -531,16 +526,14 @@ static struct slcan *slc_alloc(void)
>         if (i >= maxdev)
>                 return NULL;
>
> -       sprintf(name, "slcan%d", i);
> -       size = ALIGN(sizeof(*sl), NETDEV_ALIGN) + sizeof(struct can_ml_priv);
> -       dev = alloc_netdev(size, name, NET_NAME_UNKNOWN, slc_setup);
> +       dev = alloc_candev(sizeof(*sl), 1);
>         if (!dev)
>                 return NULL;
>
> +       snprintf(dev->name, sizeof(dev->name), "slcan%d", i);
> +       dev->netdev_ops = &slc_netdev_ops;
>         dev->base_addr  = i;
>         sl = netdev_priv(dev);
> -       can_ml = (void *)sl + ALIGN(sizeof(*sl), NETDEV_ALIGN);
> -       can_set_ml_priv(dev, can_ml);
>
>         /* Initialize channel control data */
>         sl->magic = SLCAN_MAGIC;
> @@ -605,26 +598,28 @@ static int slcan_open(struct tty_struct *tty)
>
>                 set_bit(SLF_INUSE, &sl->flags);
>
> -               err = register_netdevice(sl->dev);
> -               if (err)
> +               rtnl_unlock();
> +               err = register_candev(sl->dev);
> +               if (err) {
> +                       pr_err("slcan: can't register candev\n");
>                         goto err_free_chan;
> +               }
> +       } else {
> +               rtnl_unlock();
>         }
>
> -       /* Done.  We have linked the TTY line to a channel. */
> -       rtnl_unlock();
>         tty->receive_room = 65536;      /* We don't flow control */
>
>         /* TTY layer expects 0 on success */
>         return 0;
>
>  err_free_chan:
> +       rtnl_lock();
>         sl->tty = NULL;
>         tty->disc_data = NULL;
>         clear_bit(SLF_INUSE, &sl->flags);
> -       slc_free_netdev(sl->dev);
> -       /* do not call free_netdev before rtnl_unlock */
> +       slc_dealloc(sl);
>         rtnl_unlock();
> -       free_netdev(sl->dev);
>         return err;
>
>  err_exit:
> @@ -658,9 +653,11 @@ static void slcan_close(struct tty_struct *tty)
>         synchronize_rcu();
>         flush_work(&sl->tx_work);
>
> -       /* Flush network side */
> -       unregister_netdev(sl->dev);
> -       /* This will complete via sl_free_netdev */
> +       slc_close(sl->dev);
> +       unregister_candev(sl->dev);
> +       rtnl_lock();
> +       slc_dealloc(sl);
> +       rtnl_unlock();
>  }
>
>  static void slcan_hangup(struct tty_struct *tty)
> @@ -768,14 +765,15 @@ static void __exit slcan_exit(void)
>                 dev = slcan_devs[i];
>                 if (!dev)
>                         continue;
> -               slcan_devs[i] = NULL;
>
>                 sl = netdev_priv(dev);
>                 if (sl->tty) {
>                         netdev_err(dev, "tty discipline still running\n");
>                 }
>
> -               unregister_netdev(dev);
> +               slc_close(dev);
> +               unregister_candev(dev);
> +               slc_dealloc(sl);
>         }
>
>         kfree(slcan_devs);
> --
> 2.35.1
>
>


-- 

Dario Binacchi

Embedded Linux Developer

dario.binacchi@amarulasolutions.com

__________________________________


Amarula Solutions SRL

Via Le Canevare 30, 31100 Treviso, Veneto, IT

T. +39 042 243 5310
info@amarulasolutions.com

www.amarulasolutions.com
