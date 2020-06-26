Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE0E20B054
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgFZLTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgFZLTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:19:55 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0EFC08C5C1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 04:19:55 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id d15so6599939edm.10
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 04:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tcuqb+40GjcvWQUjlLW9PfxK8FAJRzdad19A2ONWma8=;
        b=uQXzfTHBreW61VQv2l32YoBgvHCdW+OY4FoxT5vQpXQRus+SAm381t3NlBzq4xj49W
         DpZeiKZht1DwnN0V+WaRXKQYrpHv4mgFWGDWK8ERGNaIoWABJxNGscznGcUMZ0UNd7hu
         N054g9ppGrdZISkNRzwlZH07CggeYwWpZ8xzz2+q0h7dovE64iDZpIG5EcpaNKrB5SmD
         +tRCBc1EeH8XeuxxT6i5cruPTgLS6ilbH/3qyKZiKKXbsoT5itqfsmBW8LcuFNqQNcpS
         q4D16HPc8kH/+HZxMpE10cExv1qBtfrWyXcaB2Y/8cM1fRlXCzNppodJFYiQIkz6e8Y1
         ngFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tcuqb+40GjcvWQUjlLW9PfxK8FAJRzdad19A2ONWma8=;
        b=HqSFGu4Hgd9hQTA1DZzgM/hJSu9xuehd8kS8AGvXQh9/M1RimL7pT0osVQwggRtQXh
         2b52kLv4WUdMBx9xIaPLfrkUSeM9WfKSpG9NlqGl+RuEt+0+odhFpELCDYweK+Opeb3N
         7rmT9EISoQVkbW1R/eP7UIKeZw/eP8xHLGWJqWeMV1slHHJmS4+QIQE3NiICRIoCRcV5
         1uUhTllr6a8s6dBVQ5G1rbmejDoh87cEnZ0ntI64sMFNoK06Rky12sQ51RVIGVvLKkXd
         SZ7IlZPAMwxy/Oq9zNADpdD3FyO57rvMX1tAtb7HEq7rmil+IvINZQ3afY2bhb2DXNgp
         OVIQ==
X-Gm-Message-State: AOAM532PHn7FVrvyloPD5X5IbNaT21g8WdYXk8s5z3828vPyY6u36QFU
        LV9FlMkfnqK1I7kUJLA5CGNaaML99jOPkRQp0thPmF9N
X-Google-Smtp-Source: ABdhPJyuzq1d2yxQjO9XW4Y/xUxVAM4lhSo5HkuPsySo0C6gbRgZWmNJfdP3iT9mXv4Essw6UaKueyJ9e8xsbRRT7mI=
X-Received: by 2002:a05:6402:16db:: with SMTP id r27mr2866720edx.139.1593170393734;
 Fri, 26 Jun 2020 04:19:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200625152331.3784018-1-olteanv@gmail.com> <20200625152331.3784018-6-olteanv@gmail.com>
 <20200625165349.GI1551@shell.armlinux.org.uk> <CA+h21hqn0P6mVJd1o=P1qwmVw-E56-FbY0gkfq9KurkRuJ5_hQ@mail.gmail.com>
 <20200626110828.GO1551@shell.armlinux.org.uk>
In-Reply-To: <20200626110828.GO1551@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 26 Jun 2020 14:19:42 +0300
Message-ID: <CA+h21hoDVQfeVZJaSJ1BymVcATgJq5zoHo2_K7JnG2V22RKe5A@mail.gmail.com>
Subject: Re: [PATCH net-next 5/7] net: dsa: felix: delete .phylink_mac_an_restart
 code
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jun 2020 at 14:08, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>

[snip]

>
> So, I ask again, what practical use and benefit does restarting the
> configuration exchange on a SGMII or USXGMII link have?  Give me a real
> life use case where there's a problem with a link that this can solve.
>

You are pushing the discussion in an area that to me is pretty
insignificant, and where I did _not_ want to go. I said:

> This is
> probably OK, I can't come up with a situation where it might be useful for the
> MAC PCS to clear its cache of link state and ask for a new tx_config_reg. So
> remove this code.

I was going to remove this code in the first place, it's just that you
didn't like the justification in the initial commit message. Fine. So
I asked you if this new commit message is OK. You said:

> This is going over the top

So let's cut this short: we agree about everything now, hardware
behavior and software behavior. Could you edit my commit message in a
way that you agree with, and paste it here so that I could include it
in v2?

Thanks,
-Vladimir
