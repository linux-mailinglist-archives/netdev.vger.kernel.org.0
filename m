Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9346C2F6FA5
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 01:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731309AbhAOAmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 19:42:32 -0500
Received: from mail-yb1-f177.google.com ([209.85.219.177]:36772 "EHLO
        mail-yb1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbhAOAma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 19:42:30 -0500
Received: by mail-yb1-f177.google.com with SMTP id y4so3531995ybn.3;
        Thu, 14 Jan 2021 16:42:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=in/PoV9Y6aZvEX8rdX7+E7Ge1c1+lOF6Vs5MxD+pNY4=;
        b=L80LZjEnRvoNf4AbhIw+60iteOQ2TwsKn7zpBhltMgtmlAxvPSIQvGWV0i6FyMKSFu
         qG/CHH7yvWRTT/SsyuOD3RH27PPrbM2MczPWgZWJsc5VG8KUMGLH2e+bKVFcX9X+fuvn
         5Stel+X4HBM8H5Yx/+z9L1Z93crGEaZ2/G6Q2SyzAp+4D4QZp81DitjnmFDdiBwzQnIC
         OEhVi3cSPtQ/AzKeBmL1nrEj//HbRao5zm6zsY10oztJcyp57w5mipp7wU67Y+mlpSY3
         yTGI+tTwvML0o0zaBOip7ejDpK8MOKpYxKgxQQuwQMmSqrGSw317ktWdaG3oqw2KhF+E
         5t5Q==
X-Gm-Message-State: AOAM5339To0HrEe8VdTxKUZ9/tpM0A54zf4ikZystZZ5rq+/iZnIxnc+
        PIc2CsnQhynwlpTeQhKlk2ZJ/Qc/XiwV2Px/UWI=
X-Google-Smtp-Source: ABdhPJwaT1dpOLP1pHmIBcbG+At+8IcbxjLaFn6bt52tLAEJ33mvlQwm7DeiAn1s+3Ck+PX3ZDr9JdAckuQpcTGDLMg=
X-Received: by 2002:a25:76c3:: with SMTP id r186mr16243206ybc.226.1610671308694;
 Thu, 14 Jan 2021 16:41:48 -0800 (PST)
MIME-Version: 1.0
References: <20210112130538.14912-1-mailhol.vincent@wanadoo.fr>
 <20210112130538.14912-2-mailhol.vincent@wanadoo.fr> <981eb251-1573-5852-4b16-2e207eb3c4da@hartkopp.net>
In-Reply-To: <981eb251-1573-5852-4b16-2e207eb3c4da@hartkopp.net>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 15 Jan 2021 09:41:37 +0900
Message-ID: <CAMZ6RqKeGVsF+CcqoAWC7JXEo2oLTS5E5B3Jk4oeiF9XWEC3Sw@mail.gmail.com>
Subject: Re: [PATCH v10 1/1] can: usb: etas_es58X: add support for ETAS ES58X
 CAN USB interfaces
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jimmy Assarsson <extja@kvaser.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "open list : NETWORKING DRIVERS" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri. 15 Jan 2021 at 02:23, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
>
> Hi Vincent,
>
> On 12.01.21 14:05, Vincent Mailhol wrote:
> > This driver supports the ES581.4, ES582.1 and ES584.1 interfaces from
> > ETAS GmbH (https://www.etas.com/en/products/es58x.php).
>
> (..)
>
> > diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.c b/drivers/net/can/usb/etas_es58x/es58x_fd.c
> > new file mode 100644
> > index 000000000000..6b9534f23c96
> > --- /dev/null
> > +++ b/drivers/net/can/usb/etas_es58x/es58x_fd.c
>
> (..)
>
> > +static void es58x_fd_print_bittiming(struct net_device *netdev,
> > +                                  struct es58x_fd_bittiming
> > +                                  *es58x_fd_bittiming, char *type)
> > +{
> > +     netdev_vdbg(netdev, "bitrate %s    = %d\n", type,
> > +                 le32_to_cpu(es58x_fd_bittiming->bitrate));
> > +     netdev_vdbg(netdev, "tseg1 %s      = %d\n", type,
> > +                 le16_to_cpu(es58x_fd_bittiming->tseg1));
> > +     netdev_vdbg(netdev, "tseg2 %s      = %d\n", type,
> > +                 le16_to_cpu(es58x_fd_bittiming->tseg2));
> > +     netdev_vdbg(netdev, "brp %s        = %d\n", type,
> > +                 le16_to_cpu(es58x_fd_bittiming->brp));
> > +     netdev_vdbg(netdev, "sjw %s        = %d\n", type,
> > +                 le16_to_cpu(es58x_fd_bittiming->sjw));
> > +}
>
> What is the reason for this code?
>
> These values can be retrieved with the 'ip' tool and are probably
> interesting for development - but not in the final code.

First thing, I used netdev_vdbg() (verbose debug). That macro
will only produce code if VERBOSE_DEBUG is defined. Normal users
will not see those. So yes, this is mostly for development.

Also, just realised that netdev_vdbg() is barely used
anywhere (only three files use it:
https://elixir.bootlin.com/linux/v5.11-rc3/C/ident/netdev_vdbg).

I guess that I will remove it :)

> > +
> > +static void es58x_fd_print_conf(struct net_device *netdev,
> > +                             struct es58x_fd_tx_conf_msg *tx_conf_msg)
> > +{
> > +     es58x_fd_print_bittiming(netdev, &tx_conf_msg->nominal_bittiming,
> > +                              "nominal");
> > +     netdev_vdbg(netdev, "samples_per_bit    = %d\n",
> > +                 tx_conf_msg->samples_per_bit);
> > +     netdev_vdbg(netdev, "sync_edge          = %d\n",
> > +                 tx_conf_msg->sync_edge);
> > +     netdev_vdbg(netdev, "physical_layer     = %d\n",
> > +                 tx_conf_msg->physical_layer);
> > +     netdev_vdbg(netdev, "self_reception     = %d\n",
> > +                 tx_conf_msg->self_reception_mode);
> > +     netdev_vdbg(netdev, "ctrlmode           = %d\n", tx_conf_msg->ctrlmode);
> > +     netdev_vdbg(netdev, "canfd_enabled      = %d\n",
> > +                 tx_conf_msg->canfd_enabled);
> > +     if (tx_conf_msg->canfd_enabled) {
> > +             es58x_fd_print_bittiming(netdev,
> > +                                      &tx_conf_msg->data_bittiming, "data");
> > +             netdev_vdbg(netdev,
> > +                         "Transmitter Delay Compensation        = %d\n",
> > +                         tx_conf_msg->tdc);
> > +             netdev_vdbg(netdev,
> > +                         "Transmitter Delay Compensation Offset = %d\n",
> > +                         le16_to_cpu(tx_conf_msg->tdco));
> > +             netdev_vdbg(netdev,
> > +                         "Transmitter Delay Compensation Filter = %d\n",
> > +                         le16_to_cpu(tx_conf_msg->tdcf));
> > +     }
> > +}
>
> Same here.
>
> Either the information can be retrieved with the 'ip' tool OR the are
> not necessary as set to some reasonable default anyway

Ack, will remove.

> OR we should
> implement the functionality in the general CAN driver infrastructure.

Would make sense to me to add the tdco (Transmitter Delay
Compensation Offset). Ref: ISO 11898-1 section
11.3.3 "Transmitter delay compensation"

I would just like your opinion on one topic: the tdco is specific
to CAN FD. If we add it, we have two choices:
  1. put it in struct can_bittiming: that will mean that we will
     have an unused field for classical CAN (field bittiming of
     struct can_priv).
  2. put it in struct can_priv (but outside of struct
     can_bittiming): no unused field but less pretty.

I think that 1/ is best.


Yours sincerely,
Vincent
