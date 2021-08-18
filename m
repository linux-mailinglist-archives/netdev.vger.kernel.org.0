Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671813EFD16
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238626AbhHRGtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238619AbhHRGtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:49:16 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF94C0613D9
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:48:42 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id q2so1241847pgt.6
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ydwImPka+33pK3zFh/3ZRhWUJUFUKLKTzYRKuwQUsxw=;
        b=cGjVLJJdziTcmvJ27JU5rTQ8yCeDMcn5cVnyGLyKhLTIfFt1+UogEWL2TR600L0YNa
         2ooQ2QARhAFf0vpH9wd2/xNtxYtH/TARe4IIayGOo1ZKruM4m488v+jeFjPTdR1DQCVO
         +vukV7cOhOLhxKJWKPtV2YOFJB/OfXWuW9pwQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ydwImPka+33pK3zFh/3ZRhWUJUFUKLKTzYRKuwQUsxw=;
        b=FbnczLNwbi/YK8xBO6opHzR8uvMAlPF2+tJ+n8qux82ka6JitYfN82nfx3mV73QqPB
         jjkD8GNA5mleSkLUW46cj+2htOYICpUrI9LaLYZwkswAU3vDY9p3TPytSBaCc3OGs87g
         waCJFwXtxOHtVYqgU7scKQWWZDEnmDrY5guBDotEjIQO0CK0x4OwR28MDYCoTey5dWke
         m8u6mP1yS0YjvqtnDZ3qRkgzEbNhZUhXpxaqnR1P/OHxBCq6wYH5QssKzWL9L3OBB98l
         6U3Fok9A7SSqPyP7qXyANX8I5PYVp3kxgOZMU9gD9lhZAqpE73Bpt5mWJAfWwHxuaKVu
         lLNw==
X-Gm-Message-State: AOAM532I5LgTcDZ7Kx6PAvzmx7IYkvJWzoJTjci51FJgP7HuZd6FubbL
        gdDIa/7+SeOzKKuxAB3+aDEQ4Q==
X-Google-Smtp-Source: ABdhPJzRpcjoH3bs6liJdFrWxeTvcoqJK6VQgSUO0sZF2MvCC+Ej5U0n0/HIJjlFa325ZCnA9guB0w==
X-Received: by 2002:a62:878a:0:b029:3e0:7810:ec36 with SMTP id i132-20020a62878a0000b02903e07810ec36mr7701759pfe.4.1629269321704;
        Tue, 17 Aug 2021 23:48:41 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d5sm4039400pju.28.2021.08.17.23.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:48:41 -0700 (PDT)
Date:   Tue, 17 Aug 2021 23:48:40 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] can: etas_es58x: Replace 0-element raw_msg array
Message-ID: <202108172320.1540EC10C@keescook>
References: <20210818034010.800652-1-keescook@chromium.org>
 <CAMZ6RqK4Rn4d-1CZsg9vJiAMHhxN6fgcqukdHpGwXoGTyNVr_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZ6RqK4Rn4d-1CZsg9vJiAMHhxN6fgcqukdHpGwXoGTyNVr_Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 02:13:51PM +0900, Vincent MAILHOL wrote:
> On Wed. 18 Aug 2021 at 12:40, Kees Cook <keescook@chromium.org> wrote:
> > While raw_msg isn't a fixed size, it does have a maximum size. Adjust the
> > struct to represent this and avoid the following warning when building
> > with -Wzero-length-bounds:
> >
> > drivers/net/can/usb/etas_es58x/es58x_fd.c: In function 'es58x_fd_tx_can_msg':
> > drivers/net/can/usb/etas_es58x/es58x_fd.c:360:35: warning: array subscript 65535 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[]'} [-Wzero-length-bounds]
> >   360 |  tx_can_msg = (typeof(tx_can_msg))&es58x_fd_urb_cmd->raw_msg[msg_len];
> >       |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > In file included from drivers/net/can/usb/etas_es58x/es58x_core.h:22,
> >                  from drivers/net/can/usb/etas_es58x/es58x_fd.c:17:
> > drivers/net/can/usb/etas_es58x/es58x_fd.h:231:6: note: while referencing 'raw_msg'
> >   231 |   u8 raw_msg[0];
> >       |      ^~~~~~~
> >
> > Cc: Wolfgang Grandegger <wg@grandegger.com>
> > Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
> > Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > Cc: linux-can@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  drivers/net/can/usb/etas_es58x/es581_4.h  | 2 +-
> >  drivers/net/can/usb/etas_es58x/es58x_fd.h | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/can/usb/etas_es58x/es581_4.h b/drivers/net/can/usb/etas_es58x/es581_4.h
> > index 4bc60a6df697..af38c4938859 100644
> > --- a/drivers/net/can/usb/etas_es58x/es581_4.h
> > +++ b/drivers/net/can/usb/etas_es58x/es581_4.h
> > @@ -192,7 +192,7 @@ struct es581_4_urb_cmd {
> >                 struct es581_4_rx_cmd_ret rx_cmd_ret;
> >                 __le64 timestamp;
> >                 u8 rx_cmd_ret_u8;
> > -               u8 raw_msg[0];
> > +               u8 raw_msg[USHRT_MAX];
> >         } __packed;
> >
> >         __le16 reserved_for_crc16_do_not_use;
> > diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.h b/drivers/net/can/usb/etas_es58x/es58x_fd.h
> > index ee18a87e40c0..e0319b8358ef 100644
> > --- a/drivers/net/can/usb/etas_es58x/es58x_fd.h
> > +++ b/drivers/net/can/usb/etas_es58x/es58x_fd.h
> > @@ -228,7 +228,7 @@ struct es58x_fd_urb_cmd {
> >                 struct es58x_fd_tx_ack_msg tx_ack_msg;
> >                 __le64 timestamp;
> >                 __le32 rx_cmd_ret_le32;
> > -               u8 raw_msg[0];
> > +               u8 raw_msg[USHRT_MAX];
> >         } __packed;
> >
> >         __le16 reserved_for_crc16_do_not_use;
> > --
> > 2.30.2
> 
> raw_msg is part of a union so its maximum size is implicitly the
> biggest size of the other member of that union:

Yup, understood. See below...

> 
> | struct es58x_fd_urb_cmd {
> |     __le16 SOF;
> |    u8 cmd_type;
> |    u8 cmd_id;
> |    u8 channel_idx;
> |    __le16 msg_len;
> |
> |    union {
> |        struct es58x_fd_tx_conf_msg tx_conf_msg;
> |        u8 tx_can_msg_buf[ES58X_FD_TX_BULK_MAX * ES58X_FD_CANFD_TX_LEN];
> |        u8 rx_can_msg_buf[ES58X_FD_RX_BULK_MAX * ES58X_FD_CANFD_RX_LEN];
> |        struct es58x_fd_echo_msg echo_msg[ES58X_FD_ECHO_BULK_MAX];
> |        struct es58x_fd_rx_event_msg rx_event_msg;
> |        struct es58x_fd_tx_ack_msg tx_ack_msg;
> |        __le64 timestamp;
> |        __le32 rx_cmd_ret_le32;
> |        u8 raw_msg[0];
> |    } __packed;
> |
> |    __le16 reserved_for_crc16_do_not_use;
> | } __packed;
> 
> ram_msg can then be used to manipulate the other fields at the byte level.
> I am sorry but I fail to understand why this is an issue.

The issue is with using a 0-element array (these are being removed from
the kernel[1] so we can add -Warray-bounds). Normally in this situation I
would replace the 0-element array with a flexible array, but this
case is unusual in several ways:

- There is a trailing struct member (reserved_for_crc16_do_not_use),
  which is never accessed (good), and documented as "please never access
  this".

- struct es58x_fd_urb_cmd is statically allocated (it is written into
  from the URB handler).

- The message lengths coming from the USB device are stored in a u16,
  which looked like it was possible to overflow the buffer.

In taking a closer look, I see that the URB command length is checked,
and the in-data length is checked as well, so the overflow concern
appears to be addressed.

> Also, the proposed fix drastically increases the size of the structure.

Indeed. I will send a v2, now that I see that the overflow concern isn't
an issue.

Thanks!

-Kees

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays

-- 
Kees Cook
