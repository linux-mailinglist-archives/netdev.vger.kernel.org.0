Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2EF12A86E
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 16:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfLYPd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 10:33:58 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42431 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbfLYPd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 10:33:57 -0500
Received: by mail-ed1-f65.google.com with SMTP id e10so20152364edv.9;
        Wed, 25 Dec 2019 07:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IQuzNAwmqgU7RYVLn7PTMJDVE0GkXT3f08VIotAoPf8=;
        b=maKl18YnhUUwUWP34Z6+xmQFT4wWqYgGuloO+Qfp31P46l/mqFeex62X+uUYBEm0Mo
         wHj3kE01FUyhYyaKwLfvVZBK8cP6LSV8H3m9C75Y+/eBEBqhwN35q+fuW6zQXhvoCPz1
         un7GRiTmnZJewA/yQSAPonkVILnYGbWjaMWGyjMuFGqB05+ChJQDdKb5TUmJg5o3+4l7
         s1jsnQi+RIp07ucvGziUVeq590FbZ9CBblMiBlAOQCaQyvQkCU3j3VYy3DBt0ItJ7WR+
         w1r1odrANJYueogE9h94yCZ6/I8A4sPpuVMZjdCT24qSZWDPU0Y4wYQK+cm5w7H5eSkS
         xjVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IQuzNAwmqgU7RYVLn7PTMJDVE0GkXT3f08VIotAoPf8=;
        b=sD3TOFJ/0Ef4ZORkiF6m+GbGL1+7IHSWpluCDL/eRF34Ce4p9YB1igUMdj9iH0VaaP
         Q+PUtU0eljRqZ6H6xaStgsAStngJ/sa0iMoLqkCnfrg7nQpFeva4dzWGv2EpSRcJfKVL
         lp3lVyp6J+g4Gkji5XXbIXdz7XKJfi0F1Ypm1OP+azP/kCxnzkrvHuFxa4Oxg2Dt0T2q
         IqrvWhGjeTOgqraTR6YCd8k0dVQvK6y2rjLKK8CW0S6KtDYk+uvpNKL7U5BsrebwkhaA
         yW9JArm1gaDeB1E/G0Tcif9ArBrDV4l4/R1mE//vaE+U7Vyef3cVOKAevyun2NfX1L+U
         5Khg==
X-Gm-Message-State: APjAAAUTgeuff8eLEUZyhf8EAj0i0RTpLn91wdCjjgjz9DZb7dn5N7D/
        vQv9OEsM1/9p7ZqFeIwXGeVJMOfP5z7N7Jj4XHc=
X-Google-Smtp-Source: APXvYqycWgQrP2PDwcVEuoLkCCTA3pbXwZSoDU21360+ihalDIq0VLY6VnQxJCDFoH/GxYuVOPQ1BtRm6wr/QHLgmWM=
X-Received: by 2002:a50:fb96:: with SMTP id e22mr44962782edq.18.1577288035378;
 Wed, 25 Dec 2019 07:33:55 -0800 (PST)
MIME-Version: 1.0
References: <20191225005655.1502037-1-martin.blumenstingl@googlemail.com>
 <20191225005655.1502037-2-martin.blumenstingl@googlemail.com> <20191225150845.GA16671@lunn.ch>
In-Reply-To: <20191225150845.GA16671@lunn.ch>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 25 Dec 2019 16:33:44 +0100
Message-ID: <CAFBinCA4X1e5_5nBiHmNiB40uJyr9Nm1b2VkF9NqM+wb7-1xmw@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: stmmac: dwmac-meson8b: Fix the RGMII TX delay on
 Meson8b/8m2 SoCs
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        davem@davemloft.net, khilman@baylibre.com,
        linus.luessing@c0d3.blue, balbes-150@yandex.ru,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ingrassia@epigenesys.com, jbrunet@baylibre.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

thank you as always for taking a close look at my patches :-)

On Wed, Dec 25, 2019 at 4:08 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Dec 25, 2019 at 01:56:53AM +0100, Martin Blumenstingl wrote:
> > GXBB and newer SoCs use the fixed FCLK_DIV2 (1GHz) clock as input for
> > the m250_sel clock. Meson8b and Meson8m2 use MPLL2 instead, whose rate
> > can be adjusted at runtime.
> >
> > So far we have been running MPLL2 with ~250MHz (and the internal
> > m250_div with value 1), which worked enough that we could transfer data
> > with an TX delay of 4ns. Unfortunately there is high packet loss with
> > an RGMII PHY when transferring data (receiving data works fine though).
> > Odroid-C1's u-boot is running with a TX delay of only 2ns as well as
> > the internal m250_div set to 2 - no lost (TX) packets can be observed
> > with that setting in u-boot.
> >
> > Manual testing has shown that the TX packet loss goes away when using
> > the following settings in Linux:
> > - MPLL2 clock set to ~500MHz
> > - m250_div set to 2
> > - TX delay set to 2ns
>
> Hi Martin
>
> The delay will depend on the PHY, the value of phy-mode, and the PCB
> layout.
>
> https://ethernetfmc.com/rgmii-interface-timing-considerations/
>
> RGMII requires a delay of 2ns between the data and the clock
> signal. There are at least three ways this can happen.
>
> 1) The MAC adds the delay
>
> 2) The PCB adds the delay by making the clock line longer than the
> data line.
>
> 3) The PHY adds the delay.
>
> In linux you configure this using the phy-mode in DT.
>
>       # RX and TX delays are added by the MAC when required
>       - rgmii
>
>       # RGMII with internal RX and TX delays provided by the PHY,
>       # the MAC should not add the RX or TX delays in this case
>       - rgmii-id
>
>       # RGMII with internal RX delay provided by the PHY, the MAC
>       # should not add an RX delay in this case
>       - rgmii-rxid
>
>       # RGMII with internal TX delay provided by the PHY, the MAC
>       # should not add an TX delay in this case
>       - rgmii-txid
>
> So ideally, you want the MAC to add no delay at all, and then use the
> correct phy-mode so the PHY adds the correct delay. This gives you the
> most flexibility in terms of PHY and PCB design. This does however
> require that the PHY implements the delay, which not all do.
these boards (with RGMII PHY) that I am aware of are using an RTL8211F
PHY which implements a 2ns PHY TX delay
however, the 3.10 vendor kernel also supports Micrel RGMII (and RMII)
PHYs where I don't know if they implement a (configurable) TX delay.

> Looking at patches 2 and 3, the phy-mode is set to rgmii. What you
> might actually need to do is set this to rgmii-txid, or maybe
> rgmii-id, once you have the MAC not inserting any delay.
please let us split this discussion:
1) I believe that this patch is still correct and required whenever
the MAC *has to* generate the TX delay (one use-case could be the
Micrel PHYs I mentioned above)
2) the correct phy-mode and where the TX delay is being generated. I
have tried "rgmii-txid" on my own Odroid-C1 and it's working fine
there. however, it's the only board with RGMII PHY that I have from
this generation of SoCs (and other testers are typically rare for this
platform, because it's an older SoC). so my idea was to use the same
settings as the 3.10 vendor kernel because these seem to be the "known
working" ones.

what do you think about 2)? my main concern is that this *could* break
Ethernet on other people's boards.
on the other hand I have no idea how likely that actually is.


Martin
