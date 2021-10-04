Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4518D4219E9
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 00:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbhJDWYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 18:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbhJDWYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 18:24:18 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD578C061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 15:22:28 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id x27so77264008lfa.9
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 15:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UTKBg0/EgAoA9qad8oSCGM5WnKoKTIVzL+aoRDc+Y8w=;
        b=dnI0sl0oIkctdfiXX8z6XoNf8vwcAlu6AWid7dEs/5ulmf9b6tX9Vux9hubL1dTRVo
         +MQ0Z9IWVea47ImH+zfxH5FtHqTba6MzVWPYEI4LMk7SE8VnJPtYdJdO4ZRFzRLOhxbQ
         CDaOOVMOtRLH5KgDUfx+sdKWeT884Vt7NaZz40UR3hDqQ/GpaR3/h8MhAyEk1xYRzN/o
         sr2IeaSj7Q68ey0xg232QuAcBLeKK1Cu4b0tTCOfElM2sCooYwCnNfIJG3z//b0fN6eE
         C9GoZL9QJ5MtPAE7bCdUhmXuGIu5G0p64HHMsf9s9bcfkLlrpPBKHv1MJ/pAuH8kEjYq
         txsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UTKBg0/EgAoA9qad8oSCGM5WnKoKTIVzL+aoRDc+Y8w=;
        b=stQzNOE8tHMSs7ZcXtNPqNb0ATZcExXFy6+m3fxaEYsN3ii2vrB5T/0ESZzuQEJwai
         CcgR23Gr18DvxyuGOD8q/AYg7YtVi58Q6q4+b3QPws/jvi8OROAq0oMhY7Ky4GUxPdQj
         eVMM2u+vuaNjqy9nHM8nWzx4hPqp1m8T2Sh+vXtN/PgXIfxdSrkErUw0st2P74n2srZW
         WbbZO0EJU4EARGwnMzQamtrfUwwWopoK0iwnU0+PPObJ+b7AAB2JczEy2BqQvy/Qo6n2
         gJl93bfY6a1DlF6+0pgVgb7ETf++xEGcqdW2qPwtcmuLx45sshwUI5O7RapGesI6Kp+e
         +LLA==
X-Gm-Message-State: AOAM5329Tx4mONvBNAHiInSnwD5DLtUyOgs9RrtV0vq6i685EPVVf133
        SfwpbJzgBGhZde2lckWGd7+ToPAoMPAyu5KVsHoX2WObBh2vUQ==
X-Google-Smtp-Source: ABdhPJx+7ObhjnBu4/zE1Zze8ocsjgo8NJ3na5O7ERdZcqGCj6J1+VZ0dY954HZEAusafc0FtKJTLxI7V306d9/ShR4=
X-Received: by 2002:ac2:5d4a:: with SMTP id w10mr16849860lfd.584.1633386147244;
 Mon, 04 Oct 2021 15:22:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210929210349.130099-1-linus.walleij@linaro.org>
 <20210929210349.130099-3-linus.walleij@linaro.org> <20210929215749.55mti6y66m4m75hj@skbuf>
 <ccc6d77c-d454-8869-2f43-05a161753ae3@bang-olufsen.dk>
In-Reply-To: <ccc6d77c-d454-8869-2f43-05a161753ae3@bang-olufsen.dk>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 5 Oct 2021 00:22:16 +0200
Message-ID: <CACRpkdY7GUN+-_d-Af8k0h2TOfiBFg=JH9WYud1-A1dLgEFjNQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4 v4] net: dsa: rtl8366rb: Support flood control
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 11:09 AM Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk> =
wrote:
> On 9/29/21 11:57 PM, Vladimir Oltean wrote:
> > On Wed, Sep 29, 2021 at 11:03:47PM +0200, Linus Walleij wrote:

> >> Now that we have implemented bridge flag handling we can easily
> >> support flood control as well so let's do it.

> >> +/* Storm registers are for flood control
> >> + *
> >> + * 02e2 and 02e3 are defined in the header for the RTL8366RB API
> >> + * but there are no usage examples. The implementation only activates
> >> + * the filter per port in the CTRL registers.
> >
> > The "filter" word bothers me a bit.
> > Are these settings applied on ingress or on egress? If you have
> > RTL8366RB_STORM_BC_CTRL =3D=3D BIT(0) | BIT(1), and a broadcast packet =
is
> > received on port 2, then
> >
> > (a) is it received or dropped?
> > (b) is it forwarded to port 0 and 1?
> > (c) is it forwarded to port 3?
>
> Linus, are you sure these STORM_... registers are the right ones to
> control flooding? The doc from Realtek[1] talks briefly about this storm
> control feature, but it seems to be related to rate limiting, not actual
> flooding behaviour.

You're probably right. I'll just drop this patch for now.

Yours,
Linus Walleij
