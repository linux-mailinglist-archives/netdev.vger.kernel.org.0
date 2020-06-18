Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F112F1FE95C
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 05:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgFRDSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 23:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgFRDSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 23:18:05 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60247C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 20:18:05 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t8so4400739ilm.7
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 20:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yVggTVlT3HBnFymkJ/7nI8JfFhGKprB2WbB6UDdrpW8=;
        b=j1TT8CQYek7/AaGzdZFm73hZLBeEfJIVA2PitWlgQr9SI43PCm+eN8QWtB0bwJ4Fqc
         1UJLk7o5IsCTMCQjILE3SwVGjHzh499Rik3lsEQT56uTDD0N0dwZfNC4RlRt8QHfvgGp
         w2gaqh4SKY5cZ26e284b9Fte8uRzMFpriMcMXr8MyLu43WmPbJvghKspRRwcLFWJoYTZ
         Hav5RpcUIR/d/f4EbmV9nste0kcFJuDdHMXXNAuT2djcFJvA1tDv1HG2JyR6KReesE5E
         pDf5XqroGM5XiUGh1vdJU5gGjQkXZ7Dvt73W1n1hfS5fR97mn4GIFXLIwPuh7Xagu4L0
         x9LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yVggTVlT3HBnFymkJ/7nI8JfFhGKprB2WbB6UDdrpW8=;
        b=PLlfi5Ir/N6Qxigf7ibYjMQzMI63ye2Aj5kXNlJmveIJ2tiqhgShoHMJDDQIiGmnE2
         d3I9E3SkE2zsmTTo8GsogsWY7Z7NPgTVyPv+DtvVwXnjqDSkKYm60IPKDsQ04g2jq09+
         Swf3WpYdwVKEbEyfe8+h0orQouNLpXI14zbYH1RyMm6qKvUXgXC53sRqvry8znzulntD
         OAlpwn61OTa0ehwzLlZ8GZXWPsy+fmlniglq/dVrvKQtVGtDLLeX31xwTADNEE/TXvB0
         6aStBX2rI7uINSRN4Ywbc+8XorCuoB+Ewf3JwDwxU3v5hsNc+QD5OeS+4bZyxDaIExGu
         qHXw==
X-Gm-Message-State: AOAM533BS4cszt2U1dj0988Fi2o6qqMaGdmfCRMWuIE+dNH9FA20tacH
        uSJyQ+qABJaz+Iu2JdkSe/TWPRJQ8A9V7mX9Rj4=
X-Google-Smtp-Source: ABdhPJzIYwRIuZYcE/55z07ViAZcSpapijCOm/hmAHPCSwbz7LIqoN6+kgoHwzDO1yHPH0OkHaHkW33Dzc1vVLJ6fck=
X-Received: by 2002:a92:84d8:: with SMTP id y85mr2123433ilk.241.1592450284504;
 Wed, 17 Jun 2020 20:18:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200602205456.2392024-1-linus.walleij@linaro.org>
 <20200603135244.GA869823@lunn.ch> <CACRpkdbu4O_6SvgTU3A5mYVrAn-VWpr9=0LD+M+LduuqVnjsnA@mail.gmail.com>
 <20200604005407.GA977471@lunn.ch> <CACRpkdZvf4qnhQK=dqF4Shv0Q0nkVqTFcZS_5Zg8PrO+iCjxoQ@mail.gmail.com>
 <CA+h21hqNq6Xk5bMBsB884GZdH9h4pALr7nkn8yG+a16cXqfJsg@mail.gmail.com> <CACRpkda9kJUFwx-ASQfO-ThhgbV2fmT_tqT8zH0W_Jm23ZTVMg@mail.gmail.com>
In-Reply-To: <CACRpkda9kJUFwx-ASQfO-ThhgbV2fmT_tqT8zH0W_Jm23ZTVMg@mail.gmail.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Thu, 18 Jun 2020 11:17:54 +0800
Message-ID: <CALW65jYDiLc177cdoUgUUwC_JnW3vMo8ECBth2CooiznmY_UVg@mail.gmail.com>
Subject: Re: [net-next PATCH 1/5] net: dsa: tag_rtl4_a: Implement Realtek 4
 byte A tag
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On Wed, Jun 17, 2020 at 4:06 PM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> On Thu, Jun 4, 2020 at 1:23 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> > In the code you pointed to, there is a potentially relevant comment:
> >
> > 1532//CPU tag: Realtek Ethertype==0x8899(2 bytes)+protocol==0x9(4
> > MSB)+priority(2 bits)+reserved(4 bits)+portmask(6 LSB)
> >
> > https://svn.dd-wrt.com/browser/src/linux/universal/linux-3.2/drivers/net/ethernet/raeth/rb/rtl_multicast_snooping.c#L1527
> > https://svn.dd-wrt.com/browser/src/linux/universal/linux-3.2/drivers/net/ethernet/raeth/rb/rtl_multicast_snooping.c#L5224
> >
> > This strongly indicates to me that the insertion tag is the same as
> > the extraction tag.
>
> This code is a problem because it is Realtek-development style.
> This style seems to be that the hardware people write the drivers
> using copy/paste from the previous ASIC and ship is as soon as
> possible. Keep this in mind.
>
> The above tag is using protocol 9 and is actually even documented
> in a PDF I have for RTL8306. The problem is that the RTL8366RB
> (I suspect also RTL8366S) uses protocol "a" (as in hex 10).
> Which is of course necessarily different.
>
> I have *really* tried to figure out how the bits in protocol a works
> when transmissing from the CPU port to any switch port.
>
> When nothing else worked, I just tried all bit combinations with
> 0xannp where a is protocol and p is port. I looped through all
> values several times trying to get a response from ping.

Have you looped through the whole 32-bit field?

>
> So this is really how far I can get right now, even with brute
> force.
>
> > It is completely opaque to me why in patch "[net-next PATCH 2/5] net:
> > dsa: rtl8366rb: Support the CPU DSA tag" you are _disabling_ the
> > injection of these tags via RTL8368RB_CPU_INSTAG. I think it's natural
> > that the switch drops these packets when CPU tag insertion is
> > disabled.
>
> This is another Realtek-ism where they managed to invert the
> meaning of a bit.
>
> Bit 15 in register 0x0061 (RTL8368RB_CPU_CTRL_REG) can
> be set to 1 and then the special (custom) CPU tag 0x8899
> protocol a will be DISABLED. This value Realtek calls
> "RTL8368RB_CPU_INSTAG" which makes you think that
> the tag will be inserted, it is named "instag" right? But that
> is not how it works.
>
> That bit needs to be set to 0 to insert the tag and 1 to disable
> insertion of the tag.
>
> For this reason the patch also renames this bit to
> RTL8368RB_CPU_NO_TAG which is more to the point.
>
> Yours,
> Linus Walleij
