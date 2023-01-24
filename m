Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF3D67A584
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 23:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235207AbjAXWRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 17:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbjAXWRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 17:17:16 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0EEEC50;
        Tue, 24 Jan 2023 14:17:14 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id g13so25808216lfv.7;
        Tue, 24 Jan 2023 14:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mhJX74SyXpEe21VKvtmYRp6Q7Ngr55XoXxrS6GHTUaM=;
        b=lIOkQn3uy7/I/z2v8Q85L0rLBL7SX9DrJ6x65AriCaUZU12w6lgUwTBkK9bJzvqsbV
         AGimKEMkNWeNnOND/KABFJLrBc8vXvJ3gqpf+vIRKGOA31TqNm+YVIGpsXKYPx8jgce3
         2ILeWIph/JftA1Yj53Sq1jDrCHnyp4E6ua4ibXfT3nMhNt9vW7/ouWyn3wgZiGJAPOCU
         B0LAhuEYvIUp/8lluMUpB0iSfxvIbNcR+tD+q69FIabOyc1m8n7KQnJC5Qj84AbRi3fv
         bZ+sAwmoB7z60IocecZ6Y9UWh/bV5WXO+rcK7a+EUWW3bwdpDEYgf3rbMGN11Ap1Nywv
         xEWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mhJX74SyXpEe21VKvtmYRp6Q7Ngr55XoXxrS6GHTUaM=;
        b=e3Jz8gFwQlrG0xZ9Gp9IC6nE/IZgKdy9pfV7angGzNagGYgbslIUfLPssX0t4G76cD
         9sn3rGXOzBgKL1YhLDH8tOLSmmMpynD3grXXdpKgCfapuuYj4qARGqsI3g2nhuvPXAvW
         +p28KOox72oj9jsbsLwCuYznGBhVvzRKEYWyN3CFmn1UDNophaykEvjCHlgN2MMJwKaC
         QyjEHemMePj7tXOVfIQqWLmoyBKviv6z33irNczgwwePsT/UqiSDihKTJKKv7o2xHn6I
         2o4o+BkOep8j8tGwvn5Cwi7RQ566Hv2rZT94ZPCH8lvGByWyfSnIEoCz62PAQ21p4qB8
         Xrfg==
X-Gm-Message-State: AFqh2krEwZn9JM0MbP3DGk3fKUHYwVZKs4j3GwjI7XV9N9rfZtr4l1DA
        G4Thjdz2OE95rCov/oto+4B6sFm3ecVDeEMThDo=
X-Google-Smtp-Source: AMrXdXvh8qx1S3WVzfwHHfZuCvapRPm6sYF0vH2DvRk+gdpioHeoX/MqsquNKQupOjAQ08YfWwH8Fjy+DHTSajvohcw=
X-Received: by 2002:ac2:4bd3:0:b0:4cc:789a:dac8 with SMTP id
 o19-20020ac24bd3000000b004cc789adac8mr3098851lfq.198.1674598633139; Tue, 24
 Jan 2023 14:17:13 -0800 (PST)
MIME-Version: 1.0
References: <20230124174714.2775680-1-neeraj.sanjaykale@nxp.com> <20230124174714.2775680-2-neeraj.sanjaykale@nxp.com>
In-Reply-To: <20230124174714.2775680-2-neeraj.sanjaykale@nxp.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 24 Jan 2023 14:17:01 -0800
Message-ID: <CABBYNZJ3CVO4fxN55YQ_d+Z2kvxR5H31cEG_CPxmVXfcsSGWeg@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] serdev: Add method to assert break
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, gregkh@linuxfoundation.org,
        jirislaby@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-serial@vger.kernel.org,
        amitkumar.karwar@nxp.com, rohit.fule@nxp.com, sherry.sun@nxp.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Neeraj,

On Tue, Jan 24, 2023 at 9:48 AM Neeraj Sanjay Kale
<neeraj.sanjaykale@nxp.com> wrote:
>
> Adds serdev_device_break_ctl() and an implementation for ttyport.
>
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> ---
>  drivers/tty/serdev/core.c           | 11 +++++++++++
>  drivers/tty/serdev/serdev-ttyport.c | 12 ++++++++++++
>  include/linux/serdev.h              |  6 ++++++
>  3 files changed, 29 insertions(+)
>
> diff --git a/drivers/tty/serdev/core.c b/drivers/tty/serdev/core.c
> index 0180e1e4e75d..26321ad7e71d 100644
> --- a/drivers/tty/serdev/core.c
> +++ b/drivers/tty/serdev/core.c
> @@ -405,6 +405,17 @@ int serdev_device_set_tiocm(struct serdev_device *serdev, int set, int clear)
>  }
>  EXPORT_SYMBOL_GPL(serdev_device_set_tiocm);
>
> +int serdev_device_break_ctl(struct serdev_device *serdev, int break_state)
> +{
> +       struct serdev_controller *ctrl = serdev->ctrl;
> +
> +       if (!ctrl || !ctrl->ops->break_ctl)
> +               return -ENOTSUPP;
> +
> +       return ctrl->ops->break_ctl(ctrl, break_state);
> +}
> +EXPORT_SYMBOL_GPL(serdev_device_break_ctl);
> +
>  static int serdev_drv_probe(struct device *dev)
>  {
>         const struct serdev_device_driver *sdrv = to_serdev_device_driver(dev->driver);
> diff --git a/drivers/tty/serdev/serdev-ttyport.c b/drivers/tty/serdev/serdev-ttyport.c
> index d367803e2044..847b1f71ab73 100644
> --- a/drivers/tty/serdev/serdev-ttyport.c
> +++ b/drivers/tty/serdev/serdev-ttyport.c
> @@ -247,6 +247,17 @@ static int ttyport_set_tiocm(struct serdev_controller *ctrl, unsigned int set, u
>         return tty->ops->tiocmset(tty, set, clear);
>  }
>
> +static int ttyport_break_ctl(struct serdev_controller *ctrl, unsigned int break_state)
> +{
> +       struct serport *serport = serdev_controller_get_drvdata(ctrl);
> +       struct tty_struct *tty = serport->tty;
> +
> +       if (!tty->ops->break_ctl)
> +               return -ENOTSUPP;
> +
> +       return tty->ops->break_ctl(tty, break_state);
> +}
> +
>  static const struct serdev_controller_ops ctrl_ops = {
>         .write_buf = ttyport_write_buf,
>         .write_flush = ttyport_write_flush,
> @@ -259,6 +270,7 @@ static const struct serdev_controller_ops ctrl_ops = {
>         .wait_until_sent = ttyport_wait_until_sent,
>         .get_tiocm = ttyport_get_tiocm,
>         .set_tiocm = ttyport_set_tiocm,
> +       .break_ctl = ttyport_break_ctl,
>  };
>
>  struct device *serdev_tty_port_register(struct tty_port *port,
> diff --git a/include/linux/serdev.h b/include/linux/serdev.h
> index 66f624fc618c..01b5b8f308cb 100644
> --- a/include/linux/serdev.h
> +++ b/include/linux/serdev.h
> @@ -92,6 +92,7 @@ struct serdev_controller_ops {
>         void (*wait_until_sent)(struct serdev_controller *, long);
>         int (*get_tiocm)(struct serdev_controller *);
>         int (*set_tiocm)(struct serdev_controller *, unsigned int, unsigned int);
> +       int (*break_ctl)(struct serdev_controller *, unsigned int);

Looks like these callbacks don't have any documentation, not sure if
that is because the operation itself is self explanatory, anyway I
hope someone can review this from serdev before it can be merged into
bluetooth-next.

>  };
>
>  /**
> @@ -202,6 +203,7 @@ int serdev_device_write_buf(struct serdev_device *, const unsigned char *, size_
>  void serdev_device_wait_until_sent(struct serdev_device *, long);
>  int serdev_device_get_tiocm(struct serdev_device *);
>  int serdev_device_set_tiocm(struct serdev_device *, int, int);
> +int serdev_device_break_ctl(struct serdev_device *, int);
>  void serdev_device_write_wakeup(struct serdev_device *);
>  int serdev_device_write(struct serdev_device *, const unsigned char *, size_t, long);
>  void serdev_device_write_flush(struct serdev_device *);
> @@ -255,6 +257,10 @@ static inline int serdev_device_set_tiocm(struct serdev_device *serdev, int set,
>  {
>         return -ENOTSUPP;
>  }
> +static inline int serdev_device_break_ctl(struct serdev_device *serdev, int break_state)
> +{
> +       return -ENOTSUPP;
> +}
>  static inline int serdev_device_write(struct serdev_device *sdev, const unsigned char *buf,
>                                       size_t count, unsigned long timeout)
>  {
> --
> 2.34.1
>


-- 
Luiz Augusto von Dentz
