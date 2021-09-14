Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD53840AEAC
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 15:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhINNOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbhINNOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 09:14:20 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BEAC061760
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 06:13:02 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id p15so23772936ljn.3
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 06:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NRH5G0xXSheM4KFHL/0CadAvXEQNosSqXw5u1GX1W2s=;
        b=dN0n2M1qB8hCTyJH6ylB+8fWRS0arm93hgpRr/M4sYd6qHwILhDpDcEK172XiWEW2J
         OKnY18cvUMmf8C4bBZMPI400jkW7UWO4fgbrMw8kDPeTPK8odCWayaf6knEg2zEA8+rU
         BPiv0u9zeCCa91DHuS4qbrNDrJGb98KfoDsh8rITtbEK9trHy9L06BFV1TtDuYtQ0emR
         hLjwyHdxlKr9qwQZtOW/ZUAkvdzEh0Q9h7cvLKnnGnJ9MnYU5i4uh6AzDqJ2cIWC8mSf
         mpsIr1gqfg2//O5EGdrr7Ih7k7UrJSa67JRRDl1Hn7VfwUmd+bH9ftfDEnYwQTFW82ek
         jpkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NRH5G0xXSheM4KFHL/0CadAvXEQNosSqXw5u1GX1W2s=;
        b=yAq+DjZXx7PqU8WTY0qz/vyqzXKowDxdL3TnhFU4MGzPguYI1knmRlQ5RilRMqjSkg
         jO7X2fv1HQpOwU+PRlLZnu3v2nNxF7USRGlFVR438LY3U+5JeeTYVTnXMUzOOkAdxjSA
         KiPuWxm0mM0mJ84Ro8sOwk0dZMnOnxnk/KBQx4yKr3Xb2P8F6IF8MV0e5Ct2T6FEBM17
         8j77Wv84zYk0vwVXUnZDbEq009NepJ9TPUx+NzN0YroU7lztiMKxgzL8Cs0Go2qnDn+K
         SDNHlGkKrYzmWBoVHVuufxawXIXG8F87LXwBTgIjrmpO8pCZBx4txa97svrAncvd2PN1
         6gYw==
X-Gm-Message-State: AOAM5322x409pD4JK4/mep6Df4OXzl2IftLt6HwZ4vEsc4Ox+awJaXDT
        BVhd+iKk6kLGvkmmnuoYoXLzFOHylYwlUnFu0rnb5w==
X-Google-Smtp-Source: ABdhPJyywNB9EcC/NpX2Q+I2/OXr57WGXIKDXOUlhTnNWo3Q9XEwMexrfq2qJLd83c2ov4tcf4JCAgCrc9xBhfdig8I=
X-Received: by 2002:a05:651c:1124:: with SMTP id e4mr15226610ljo.261.1631625180906;
 Tue, 14 Sep 2021 06:13:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210913144300.1265143-1-linus.walleij@linaro.org>
 <20210913144300.1265143-6-linus.walleij@linaro.org> <20210913153425.pgm2zs4vgtnzzyps@skbuf>
 <CACRpkdYUp2m8LXfngi05O=ro5-8vicpkNJa=PUGzc4KDBsuMyA@mail.gmail.com> <20210914062933.1087740-1-dqfext@gmail.com>
In-Reply-To: <20210914062933.1087740-1-dqfext@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 14 Sep 2021 15:12:49 +0200
Message-ID: <CACRpkdYTZob+dYuYEdHtBQC8K6z1zV5SnB2Xc62XFPJnK-XiXg@mail.gmail.com>
Subject: Re: [PATCH net-next 5/8] net: dsa: rtl8366: Disable "4K" VLANs
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 8:29 AM DENG Qingfang <dqfext@gmail.com> wrote:

> > Yeah it is pretty weird. What happens now is that this is a regression
> > when using OpenWrt userspace as it sets up the VLANs like this,
>
> Were you running net-next kernel?

Yep just the userspace is from OpenWrt, the kernel is latest mainline.

> The DSA core already adds the CPU port to VLAN members for you.
> In file net/dsa/slave.c, function dsa_slave_vlan_add:

Hmmmmm I will look into this. Put in some debug prints etc.
Certainly the callbacks to the driver for doing this aren't getting
called even with v5.15-rc1 AFAICT.

Yours,
Linus Walleij
