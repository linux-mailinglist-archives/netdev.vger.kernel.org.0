Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C62916C2F7
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730559AbgBYN5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:57:38 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37008 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730387AbgBYN5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:57:37 -0500
Received: by mail-ed1-f66.google.com with SMTP id t7so16338368edr.4
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 05:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dtKTDfpqSapmTpD0qVUWkLKwtjyj+4R+f9K8CWQTmrQ=;
        b=igOggpu6SKpNPYq1OrYvUb/VlD6dx+X/ou4D7/K/9u5Kn2WQ9sn/nZAEjZc7OsTksd
         k9ed3YS/o3k0CahM1VTnL1aymVy6y2oiXOD3avXxXvzSfEGiPmlGrmgskPDivV7T/CDF
         Z7zCJxpgTbtnbzxFavAnfSEXEb3fXYQGv2+FoCu92ODzeqUJ0OOn2EkASAj5Q5TMwc7c
         iFPQJ6Thw97X+Yg4X052xySBILsZn2zberoexCWaiWKq0iWCyCKvrjv6LevMXihyMJjU
         nfQwzyvsERqecfxD6mjKVY4gj8Yn3t+8gu3S9vJmBONBrCTxRAzU2rm6uS3iMdCOsVFA
         KLmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dtKTDfpqSapmTpD0qVUWkLKwtjyj+4R+f9K8CWQTmrQ=;
        b=qJrEz3itXcI798hjpLltkN6b8f4V1zlfYXprmBvNEAN4jAgyMp6mp4tspg/DmFfn4E
         OT7dDbBY4qwgd8eZqnoZk2gJXAgrJkNBbn4BwR/lXJNMj5weEILlJauky89hT8zdKg4k
         lOIHAL/CC5dQJS/puy/qz9GsnTyyAROX7OkSPVwPVBpsjpP9bPPOeh9yoKoqUbX+Zski
         aVtaL3oqw6UkrBltahSKfF4Zuho7cVKfgwygbpcPPyRd5YOkGIpKPy6n1EBTvCHdr4A4
         fabMdf9twZ3a78zaA9Wd+MRjlu9lh4+t/WvB2ubD5UPYHaI9rJQzBhsrQiqjSlWVe5zP
         W8kA==
X-Gm-Message-State: APjAAAVspaPJw66ZpBdGF/L4YHeP2Egn7Et86iVhCRWZZ6GFd32Qjiu5
        F6sVQw23re7nOYutBIq/zmZnXzmqgMv9GBz/vqQ=
X-Google-Smtp-Source: APXvYqxO5S01tEUs1tCO+tf8gR4uq2ecP1mTYooMdGuf0szkRZpxKSUHENb1xXeiIsXwmyOrBgoGcFvTzqBEaVuON9U=
X-Received: by 2002:aa7:d145:: with SMTP id r5mr52284571edo.337.1582639055994;
 Tue, 25 Feb 2020 05:57:35 -0800 (PST)
MIME-Version: 1.0
References: <20200224213458.32451-1-olteanv@gmail.com> <20200225130223.kb7jg7u2kgjjrlpo@lx-anielsen.microsemi.net>
 <CA+h21hp41WXXTLZ0L2rwT5b1gMeL5YFBpNpCZMh7d9eWZpmaqw@mail.gmail.com> <20200225133728.GE9749@lunn.ch>
In-Reply-To: <20200225133728.GE9749@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 25 Feb 2020 15:57:24 +0200
Message-ID: <CA+h21hqG_BpjzZJ=ak7hQxX-FFLHLvRQM+yUmD1Wjbk0ST4f=A@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 0/2] Allow unknown unicast traffic to CPU for
 Felix DSA
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, 25 Feb 2020 at 15:37, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Secondly, even traffic that the CPU _intends_ to terminate remains
> > "unknown" from the switch's perspective, due to the
> > no-learning-from-injected-traffic issue. So that traffic is still
> > going to be flooded, potentially to unwanted ports as well.
>
> Hi Vladimir
>
> Can you add an entry to its table to solve this? Make it known
> traffic. Hook into dsa_slave_set_rx_mode() and
> dsa_slave_set_mac_address()?
>
>         Andrew

What about bridging a felix port with a "foreign interface" and
passing traffic to a DMAC that is not even on this board (a host
connected to the foreign interface)?
There are so many cases that the Ocelot approach will not work for,
and even adapting that to DSA is going to be tricky for the
implementation. Consider that even a Linux bridge may have a MAC
address that differs from the addresses of its slave devices. Do we
add code in DSA to learn the bridge's address too? Do we add code to
forget it when the last port leaves the bridge? Is it even sufficient?

Regards,
-Vladimir
