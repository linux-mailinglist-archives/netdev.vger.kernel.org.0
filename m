Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F18430CCCC
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 21:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240329AbhBBUHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 15:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240395AbhBBUGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 15:06:13 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB77C061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 12:05:33 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id h6so24146188oie.5
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 12:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gw2eTzz0jnb4l2Tcl9s3jI86Fbz/O5lkdjkH6fdGJns=;
        b=OUZUuboZXGiy8rQcRmfTungE1+hP9lnqC/iuNbP/2tjtnZPBWHZXpKoet6uykgHuSp
         Zpc5teZRth50cPTT/+wuk5l12f7S1+oVuZTCNZjhkYCPgwekkgR60w1oQKY3tQhh2XFc
         J+U9uG/mBfuxQ5VQmvgxbiFPMVehMnKBynna+jL3p4On4GbRR5KePul5mOkyRjYgBJDj
         axgoIv/8rUTnzMjb3VEndN4Y6y7jCxk9CxH3M5DJ84g1llYqhCZjr79upHBEHO5p6sE1
         3+BMzb3hHdy8VAlcfqyG2s7cYbyNH6D9cp6vG4/Zik8RKYF1MxABhaX2cDQ6TW+78EqD
         azsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gw2eTzz0jnb4l2Tcl9s3jI86Fbz/O5lkdjkH6fdGJns=;
        b=g9suR8tsOtoVPxQmzwmZzQKdG0PrQExVCtre578UUH/Qa6VKF/cx32dJsfsMXgmalI
         AztJVd/oPxLya9An1RBNgnNBhItJCNSJNt8srjAhfAF1M/wkrkIvtRJgF+/J0VjohF5U
         EeOzmbS62ALWC6qodxgsl//gWzOb9mQdomfZro7/0U8lt2bl8MsC2mKsYvM3wBhcDyCM
         sZ3aKDphZgFJ6MILGFJJKy1NAI2hPf3u0X9JE8gwLAE6KI3BflM/AhhAWH9SrSxjclO8
         rTEV6/6/SrOhDeSjAZ14Cy17ORc1GyUQ5lBphcxWLrZZYj6cXiBz9AJOh5y9RkIftCcV
         O1Ag==
X-Gm-Message-State: AOAM533ZxB2Y5IeWTCCD/NjfRNxt6SuTtoMVFJwRKkFzSsOdjFcMI1Vf
        gW2cGn84z38rrdyGu5ZyPLknjj2/75eyMp4vyhAcJjQ12+nv
X-Google-Smtp-Source: ABdhPJwP0buJ2vIlz1bWVEesg+Za0GIgD9TcWSZ+55co0Sr4OpLbxvJc7x01lVbT3al2rOmgGRbdqPU/RQwOOzIk0rE=
X-Received: by 2002:a05:6808:f09:: with SMTP id m9mr4021140oiw.92.1612296332631;
 Tue, 02 Feb 2021 12:05:32 -0800 (PST)
MIME-Version: 1.0
References: <20210202191645.439-1-tobias@waldekranz.com>
In-Reply-To: <20210202191645.439-1-tobias@waldekranz.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Tue, 2 Feb 2021 14:05:20 -0600
Message-ID: <CAFSKS=OtcuJRF=8rK-3dUU0=G-k=JciLsdrhS5B9t9oWz1Y2Gw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: xrs700x: Correctly address device over I2C
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 1:17 PM Tobias Waldekranz <tobias@waldekranz.com> wrote:
[snip]
>
> George, have you used the chip in I2C mode with the code that is on
> net-next now? I was not able to get the driver to even read the ID
> register correctly.

I wrote the i2c driver before I had any hardware in hand thinking I
was going to get a board with the switch connected via i2c. When the
board arrived it turned out it was connected via mdio so I wrote that
driver as well. I looked it over quite carefully but I guess the
documentation was wrong and I had the register addresses shifted off
by one. I never ended up with hardware to test the i2c.

>
>  drivers/net/dsa/xrs700x/xrs700x_i2c.c | 31 ++++++++++++---------------
>  1 file changed, 14 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/net/dsa/xrs700x/xrs700x_i2c.c b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
> index a5f8883af829..16a46a78a037 100644
> --- a/drivers/net/dsa/xrs700x/xrs700x_i2c.c
> +++ b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
> @@ -10,33 +10,34 @@
>  #include "xrs700x.h"
>  #include "xrs700x_reg.h"
>
> +struct xrs700x_i2c_cmd {
> +       __be32 reg;
> +       __be16 val;
> +} __packed;
> +
>  static int xrs700x_i2c_reg_read(void *context, unsigned int reg,
>                                 unsigned int *val)
>  {
>         struct device *dev = context;
>         struct i2c_client *i2c = to_i2c_client(dev);
> -       unsigned char buf[4];
> +       struct xrs700x_i2c_cmd cmd;
>         int ret;
>
> -       buf[0] = reg >> 23 & 0xff;
> -       buf[1] = reg >> 15 & 0xff;
> -       buf[2] = reg >> 7 & 0xff;
> -       buf[3] = (reg & 0x7f) << 1;
> +       cmd.reg = cpu_to_be32(reg | 1);
>
> -       ret = i2c_master_send(i2c, buf, sizeof(buf));
> +       ret = i2c_master_send(i2c, (char *)&cmd.reg, sizeof(cmd.reg));
>         if (ret < 0) {
>                 dev_err(dev, "xrs i2c_master_send returned %d\n", ret);
>                 return ret;
>         }
>
> -       ret = i2c_master_recv(i2c, buf, 2);
> +       ret = i2c_master_recv(i2c, (char *)&cmd.val, sizeof(cmd.val));
>         if (ret < 0) {
>                 dev_err(dev, "xrs i2c_master_recv returned %d\n", ret);
>                 return ret;
>         }
>
> -       *val = buf[0] << 8 | buf[1];
> -
> +       *val = be16_to_cpu(cmd.val);
>         return 0;
>  }
>
> @@ -45,17 +46,13 @@ static int xrs700x_i2c_reg_write(void *context, unsigned int reg,
>  {
>         struct device *dev = context;
>         struct i2c_client *i2c = to_i2c_client(dev);
> -       unsigned char buf[6];
> +       struct xrs700x_i2c_cmd cmd;
>         int ret;
>
> -       buf[0] = reg >> 23 & 0xff;
> -       buf[1] = reg >> 15 & 0xff;
> -       buf[2] = reg >> 7 & 0xff;
> -       buf[3] = (reg & 0x7f) << 1 | 1;
> -       buf[4] = val >> 8 & 0xff;
> -       buf[5] = val & 0xff;
> +       cmd.reg = cpu_to_be32(reg);
> +       cmd.val = cpu_to_be16(val);
>
> -       ret = i2c_master_send(i2c, buf, sizeof(buf));
> +       ret = i2c_master_send(i2c, (char *)&cmd, sizeof(cmd));
>         if (ret < 0) {
>                 dev_err(dev, "xrs i2c_master_send returned %d\n", ret);
>                 return ret;
> --
> 2.17.1
>

Reviewed-by: George McCollister <george.mccollister@gmail.com>
