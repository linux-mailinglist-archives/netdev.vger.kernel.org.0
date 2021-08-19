Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6365B3F0F02
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 02:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235191AbhHSACt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 20:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234986AbhHSACr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 20:02:47 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961AFC0613CF
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 17:02:12 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id x4so4101535pgh.1
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 17:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=No/CqcYi/ja+9aQOR285LDlQZpZG4tmFE2Pn19n6my4=;
        b=GCsLDCnT1IGo2ICI8aIFEl7kCwiCIR1K3yHJzTlpK+e6S2iHvTa9PDNboC80JdoO84
         7qA4G0tlNAdBMtSHQBeyX6n/AuWMsudOz5uq/iTGlMH10Q9h4POgQqR/tjXC7Id59AgS
         W54I+QF851939R6t+NKPj0fi0SIIiz3PspBiE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=No/CqcYi/ja+9aQOR285LDlQZpZG4tmFE2Pn19n6my4=;
        b=P51/y2fgScViED4/2uC4l0hUWyZuX1Ie8vU6+SSGVnYy2pwFrTq/Bucnl8jB1LZCMe
         y5HBFnf8WIMGZHziIu+3iJ3WD1neRnKkanTG/azAUGC+g7IqtBFVI5p0ZUPDfRFEtM8f
         tUL5vPnMP0Os4htcg4+CBuAGx0Gs54d3gfMou0FLvjGczw+E0FHBXpLaCu4uhlbJWX0g
         IQBejuz44omuWQJp2UvzBIbGcVOJ3LhWPrrTO/ZJ2nVeW6Fm7sJLSPt0X0Udl/qOmKzN
         W6IDo6ibseTzIp83Vkmnpn4oCqiybTlM5QaJaeHBwMaLOkVRlvfoLfWo8ii/WqO3Fcd5
         Rt1Q==
X-Gm-Message-State: AOAM5323sLORcofbGT2v3KzZ+/E+dsK0D0vVSNaOfo5LdgilyCJD+W4y
        T79umldLwi0jypZbH5NpqCcwVVNhvCwVyw==
X-Google-Smtp-Source: ABdhPJx7IuiG55H+hxSJMh1slQNmZgtLecHPm4aA6V8X2OmyKoMMc+5FXWn7b7rsYHq/dPyvgsoalg==
X-Received: by 2002:a62:ea0f:0:b029:319:8eef:5ff1 with SMTP id t15-20020a62ea0f0000b02903198eef5ff1mr11907946pfh.74.1629331332031;
        Wed, 18 Aug 2021 17:02:12 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w9sm872502pja.16.2021.08.18.17.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 17:02:11 -0700 (PDT)
Date:   Wed, 18 Aug 2021 17:02:10 -0700
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
Message-ID: <202108181659.3DE5E5451@keescook>
References: <20210818034010.800652-1-keescook@chromium.org>
 <CAMZ6RqK4Rn4d-1CZsg9vJiAMHhxN6fgcqukdHpGwXoGTyNVr_Q@mail.gmail.com>
 <202108172320.1540EC10C@keescook>
 <CAMZ6RqLecbytJFQDC35n7YiqBbrB3--POofnXFeH77Zi2xzqWA@mail.gmail.com>
 <202108180159.5C1CEE70F@keescook>
 <CAMZ6RqK=Q3mvV5gyPVhBsFxE+JPANHNrgFqs=bvTgkbXjwT4Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZ6RqK=Q3mvV5gyPVhBsFxE+JPANHNrgFqs=bvTgkbXjwT4Eg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 06:33:39PM +0900, Vincent MAILHOL wrote:
> On Wed. 18 Aug 2021 at 18:03, Kees Cook <keescook@chromium.org> wrote:
> > On Wed, Aug 18, 2021 at 04:55:20PM +0900, Vincent MAILHOL wrote:
> > > At the end, the only goal of raw_msg[] is to have a tag pointing
> > > to the beginning of the union. It would be virtually identical to
> > > something like:
> > > |    u8 raw_msg[];
> > > |    union {
> > > |        /* ... */
> > > |    } __packed ;
> > >
> > > I had a look at your work and especially at your struct_group() macro.
> > > Do you think it would make sense to introduce a union_group()?
> > >
> > > Result would look like:
> > >
> > > |    union_group_attr(urb_msg, __packed, /* raw_msg renamed to urb_msg */
> > > |        struct es58x_fd_tx_conf_msg tx_conf_msg;
> > > |        u8 tx_can_msg_buf[ES58X_FD_TX_BULK_MAX * ES58X_FD_CANFD_TX_LEN];
> > > |        u8 rx_can_msg_buf[ES58X_FD_RX_BULK_MAX * ES58X_FD_CANFD_RX_LEN];
> > > |        struct es58x_fd_echo_msg echo_msg[ES58X_FD_ECHO_BULK_MAX];
> > > |        struct es58x_fd_rx_event_msg rx_event_msg;
> > > |        struct es58x_fd_tx_ack_msg tx_ack_msg;
> > > |        __le64 timestamp;
> > > |        __le32 rx_cmd_ret_le32;
> > > |    );
> > >
> > > And I can then use urb_msg in place of the old raw_msg (might
> > > need a bit of rework here and there but I can take care of it).
> > >
> > > This is the most pretty way I can think of to remove this zero length array.
> > > Keeping the raw_msg[] but with another size seems odd to me.
> > >
> > > Or maybe I would be the only one using this feature in the full
> > > tree? In that case, maybe it would make sense to keep the
> > > union_group_attr() macro local to the etas_es58x driver?
> >
> > I actually ended up with something close to this idea, but more
> > generalized for other cases in the kernel. There was a sane way to
> > include a "real" flexible array in a union (or alone in a struct), so
> > I've proposed this flex_array() helper:
> > https://lore.kernel.org/lkml/20210818081118.1667663-2-keescook@chromium.org/
> >
> > and then it's just a drop-in replacement for all the places that need
> > this fixed, including etas_es58x:
> > https://lore.kernel.org/lkml/20210818081118.1667663-3-keescook@chromium.org/#Z30drivers:net:can:usb:etas_es58x:es581_4.h
> >
> > Hopefully this will work out; I think it's as clean as we can get for
> > now. :)
> 
> The __flex_array itself is a nasty hack :D

Indeed. ;)

> but the rest is clean.

Thanks!

> Is this compliant to the C standard? Well, I guess that as long
> as both GCC and LLVM supports it, it is safe to add it to the
> kernel.

The kernel already uses a bunch of compiler extensions, none of which
were legal under the C standard to begin with. :) So, really, this is
about normalizing what we're already doing and finding a single hack
that helps the code base for readability and robustness.

> I like the final result. I will do a bit more testing and give my
> acknowledgement if everything goes well.

Great; thank you!

-- 
Kees Cook
