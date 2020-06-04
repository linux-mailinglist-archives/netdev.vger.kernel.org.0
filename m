Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D84E1EE358
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 13:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgFDLXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 07:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgFDLXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 07:23:03 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C102C03E96D
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 04:23:02 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id ce8so4371986edb.8
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 04:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s41I+pF4otPkoKhqX4c6nJ9IRCbLy4ku+zVntETS7Wg=;
        b=tNk4F6eCONuZfFWYsS7Zk9UaLpmXXsfmQpB3/dg4F7MRkEQu7A3VxfcYu/V6MAwo1H
         38raiRvkN3HsjUe1vsLz3zQ0RArLzweT3iURK6102AcpBEAK55cYKyCuZustM2xxFZEO
         H5hTWmbrMe9EI1jeU1la8dM7QFQ6tmb44mTAY/L4tUkzyXKAeb5rmaAq9owb5bPYS00P
         1efYUPdU/1b3IbOusGIxCUe3cMeAhLRql65ExAgtU/jx5R74fc9Eqo6/pRNpxWfhQSGo
         Y2mR7FkDZ+HJc/y+zCjz5GMLkjGm6QKIwJHre0bmcKgS5ie86gSBwtOjd+ua+uBlLPyy
         rsMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s41I+pF4otPkoKhqX4c6nJ9IRCbLy4ku+zVntETS7Wg=;
        b=RaE94QUidmHzSgyGFU9RdA6Iqex9On5SSazXfgU1cRETPrHHcCUljHLPZYTeTFnW1g
         2EVbPXvLRjXypnxRVlAcGJyHal2OUlAwTKJkRzRip6dW2NZCeUPLd+gVsmHWU8xobdHi
         lpJCbcz3cfuqLjnjvS3FSdpYK5R709GKMC1YeqWYlGAgJAc45wjf1kV8Obz9EJCjWbOp
         6uSFNENNVaiZXO7LyY+9vEHKwpoF7pT1dbFL7Zw9XgNeL7wD4UUbBXKngM/tAEef7IhB
         8mYnJ30zazSV33Uw5MM36Ghh6grMjSF9k7bXPgTyjpBTU2do0/FOPKAnDogl9jm590Hj
         cCRQ==
X-Gm-Message-State: AOAM530A9RUuqTJckrZbfLf83JlzEz5atI9Vp2ELjmN5pkw3g+lSQOx5
        kjT35so5SHgiMe6J9eV8uDSqWhlE8O6bU3vrfwA=
X-Google-Smtp-Source: ABdhPJzQgJElkHScqS0KAHsALvrD5rdDZ2UGbhEBF1HoemPk6qmPnQ2+7xCnb94GIhqYo5TDiccYqJETIPjPfVD+FCc=
X-Received: by 2002:a05:6402:362:: with SMTP id s2mr3851321edw.337.1591269780945;
 Thu, 04 Jun 2020 04:23:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200602205456.2392024-1-linus.walleij@linaro.org>
 <20200603135244.GA869823@lunn.ch> <CACRpkdbu4O_6SvgTU3A5mYVrAn-VWpr9=0LD+M+LduuqVnjsnA@mail.gmail.com>
 <20200604005407.GA977471@lunn.ch> <CACRpkdZvf4qnhQK=dqF4Shv0Q0nkVqTFcZS_5Zg8PrO+iCjxoQ@mail.gmail.com>
In-Reply-To: <CACRpkdZvf4qnhQK=dqF4Shv0Q0nkVqTFcZS_5Zg8PrO+iCjxoQ@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 4 Jun 2020 14:22:49 +0300
Message-ID: <CA+h21hqNq6Xk5bMBsB884GZdH9h4pALr7nkn8yG+a16cXqfJsg@mail.gmail.com>
Subject: Re: [net-next PATCH 1/5] net: dsa: tag_rtl4_a: Implement Realtek 4
 byte A tag
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>, DENG Qingfang <dqfext@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

On Thu, 4 Jun 2020 at 12:17, Linus Walleij <linus.walleij@linaro.org> wrote:
>
> On Thu, Jun 4, 2020 at 2:54 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > If spanning tree is performed in the ASIC, i don't see why there would
> > be registers to control the port status. It would do it all itself,
> > and not export these controls.
> >
> > So i would not give up on spanning tree as a way to reverse engineer
> > this.
>
> Hm I guess I have to take out the textbooks and refresh my lacking
> knowledge about spanning tree :)
>
> What I have for "documentation" is the code drop inside DD Wrt:
> https://svn.dd-wrt.com//browser/src/linux/universal/linux-3.2/drivers/net/ethernet/raeth/rb
>
> The code is a bit messy and seems hacked up by Realtek, also
> at one point apparently the ASIC was closely related to  RTL8368s
> and then renamed to RTL8366RB...
>
> The code accessing the ASIC is here (under the name RTL8368s):
> https://svn.dd-wrt.com/browser/src/linux/universal/linux-3.2/drivers/net/ethernet/raeth/rb/rtl8368s_asicdrv.c
>
> I'm hacking on it but a bit stuck :/
>
> Yours,
> Linus Walleij

In the code you pointed to, there is a potentially relevant comment:

1532//CPU tag: Realtek Ethertype==0x8899(2 bytes)+protocol==0x9(4
MSB)+priority(2 bits)+reserved(4 bits)+portmask(6 LSB)

https://svn.dd-wrt.com/browser/src/linux/universal/linux-3.2/drivers/net/ethernet/raeth/rb/rtl_multicast_snooping.c#L1527
https://svn.dd-wrt.com/browser/src/linux/universal/linux-3.2/drivers/net/ethernet/raeth/rb/rtl_multicast_snooping.c#L5224

This strongly indicates to me that the insertion tag is the same as
the extraction tag.
It is completely opaque to me why in patch "[net-next PATCH 2/5] net:
dsa: rtl8366rb: Support the CPU DSA tag" you are _disabling_ the
injection of these tags via RTL8368RB_CPU_INSTAG. I think it's natural
that the switch drops these packets when CPU tag insertion is
disabled.

Thanks,
-Vladimir
