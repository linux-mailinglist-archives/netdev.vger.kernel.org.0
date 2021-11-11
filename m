Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725F044D2DF
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 09:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhKKIKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 03:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhKKIKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 03:10:01 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22057C061766;
        Thu, 11 Nov 2021 00:07:12 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id o17so4632493qtk.1;
        Thu, 11 Nov 2021 00:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EDeOSGUw0LlQfWecZRZXqF4X35ux3tXCTyc2Up+rGNI=;
        b=RcEkazTlfZfUL0wH1hII/uaD3D7kgj8FPnn5XFkwwnVbQpyxZOjB0Wj9xUPkIzC0fV
         NJ49ih63v+pDrWSGjPEOnZrnHShOzfnwG/kQz4CdcWhSTe3ose1vmTOHOdVuPyMbVlKO
         L5tilFBkxBti+BMwwfKVAUrn6m0ImkwGdOj6a/em9D3Ld1nq3oO9dqFXW/8ritLsK24x
         Ua1/lisvfXmqdu5MBN/JREk+g4eSDNVnUTyGpmkaFc4e/90zAD82YLC+5Q4uwkkBFPaT
         TZrrvTb9Ry7uR65UFuB3ZpxoEe81W8WPEFWLL9q++Z7VVoTwX0w79h7epUYcky2iYoyK
         O1dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EDeOSGUw0LlQfWecZRZXqF4X35ux3tXCTyc2Up+rGNI=;
        b=msLZCsAUZ/ylX1H2o6IOCE+PRFWbHltwc7B/rZ8RIT+F3Z33WMVPsXyjCC9sQfqmyj
         0O0W1tCtI96J9qbRJJzKuW+5qm0v1fiwqR7jEh47hvsIdzsLreUeZoNe+9jAUGrhS4pB
         h6Bft14flpFkW5jTDBZHTl2QwVOicymxhiiNyi02KOetfsDIlykPrnoBLr1f8R6v5ma6
         ZlP5m3JOfON3AwrN08hYvaJuUkpvA8SVXdyCDavdGF2h32zVyNXK4uBVfx+0C4DjSN+i
         u1NGdDe0PhxKAjoZuQZy2mPJsPHH+mS580mMZsX8cPMK9nI6vbDqkqEYRUjNq1h7cCOc
         5kAA==
X-Gm-Message-State: AOAM532bgIUbhEKANowDp/l6XLKtls+Pc5KlT7XEIltEvZ5I6TG4bGZP
        jfO+6JV8Dw0uFq7AMOcNIawVqRsiZGFsrMZV+fQ=
X-Google-Smtp-Source: ABdhPJw29cg4DTL+3FKtZ7xvmgEC0OAgNcsfJi+wnmIysRd/Hqq+/MahXkORRzy/JFPTUK7k0fYcfwoCX9MvJQfo9zM=
X-Received: by 2002:a05:622a:1a1c:: with SMTP id f28mr5931279qtb.308.1636618031071;
 Thu, 11 Nov 2021 00:07:11 -0800 (PST)
MIME-Version: 1.0
References: <20211111015548.2892849-1-matt@codeconstruct.com.au> <20211111015548.2892849-5-matt@codeconstruct.com.au>
In-Reply-To: <20211111015548.2892849-5-matt@codeconstruct.com.au>
From:   Tali Perry <tali.perry1@gmail.com>
Date:   Thu, 11 Nov 2021 10:07:00 +0200
Message-ID: <CAHb3i=skirw-=FVBMPnmGpPOGw+xLykR-YNDQf9jpyH9s4mDqQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/6] i2c: npcm7xx: Allow 255 byte block SMBus transfers
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     Zev Weiss <zev@bewilderbeest.net>, Wolfram Sang <wsa@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Avi Fishman <avifishman70@gmail.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Linux I2C <linux-i2c@vger.kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 3:56 AM Matt Johnston <matt@codeconstruct.com.au> wrote:
>
> 255 byte support has been tested on a npcm750 board
>
> Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
> ---
>  drivers/i2c/busses/i2c-npcm7xx.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/i2c/busses/i2c-npcm7xx.c b/drivers/i2c/busses/i2c-npcm7xx.c
> index 2ad166355ec9..6d60f65add85 100644
> --- a/drivers/i2c/busses/i2c-npcm7xx.c
> +++ b/drivers/i2c/busses/i2c-npcm7xx.c
> @@ -1399,7 +1399,7 @@ static void npcm_i2c_irq_master_handler_read(struct npcm_i2c *bus)
>                 if (bus->read_block_use) {
>                         /* first byte in block protocol is the size: */
>                         data = npcm_i2c_rd_byte(bus);
> -                       data = clamp_val(data, 1, I2C_SMBUS_BLOCK_MAX);
> +                       data = clamp_val(data, 1, I2C_SMBUS_V3_BLOCK_MAX);
>                         bus->rd_size = data + block_extra_bytes_size;
>                         bus->rd_buf[bus->rd_ind++] = data;
>
> @@ -2187,6 +2187,7 @@ static u32 npcm_i2c_functionality(struct i2c_adapter *adap)
>                I2C_FUNC_SMBUS_EMUL |
>                I2C_FUNC_SMBUS_BLOCK_DATA |
>                I2C_FUNC_SMBUS_PEC |
> +              I2C_FUNC_SMBUS_V3_BLOCK |
>                I2C_FUNC_SLAVE;
>  }
>
> --
> 2.32.0
>
Thanks for the patch, Matt !

Reviewed-by: Tali Perry <tali.perry1@gmail.com>
