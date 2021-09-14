Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3868040B5BE
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 19:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhINRPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 13:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhINRPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 13:15:42 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69DAC061762
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 10:14:24 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id b15so14431145ils.10
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 10:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DcOhlwQsXjrwVRfV2koHmngYFauQ5CZdeeF2QL+PcHI=;
        b=NqkITvCvDlakxX4GzgZGeY8hq1JNEZ2tmqrESQWm3pAui3+xlXw6EuSVl7PMFepL6s
         X5OxTACT4niiBM8Pts20m7FFF/nOYdg3KRhjkEAb4Hlc1F3cNm4y6kl64TVD0zTVlpeZ
         vjbg7Az1DLB2NlTk+ugdvwtBbKJas1dixTgJc2RDGYF39o5PWC1gqmdAtmzwgRor9sR1
         pPDlZ4HmQgP+MvfbA6MavPpNEa2eim2q0kAxrpCMxgWsq48USjvt8+5C6idYy0DNgfL+
         AG1czsik/KsXZJFgus/TT64RJ6X+0xSLb3tp68up/ZtCNkGIjB3VK5UdYAaLml8/8Bx/
         ahBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DcOhlwQsXjrwVRfV2koHmngYFauQ5CZdeeF2QL+PcHI=;
        b=npI+ExQ41mDYo/S2k8duSM7owvg/YTNv+vIrWTNORzCHU3rTihav1HQhI85SRO37iq
         ZBkPcu7mplkBbKK+0I/tEE58Rm1Dx8NchINJCeIaltMGQroWB1E3vf4oLTiqCghWDMVK
         eGs3gKctwo07Hdv2v850dYZdg/afmGwwSitr1jpT4s1tBESG5MdA+FTYCMdRiyeMPUm5
         85dXezHzL2iZSl/BudQS3IWGfjE9Yz45JuFk2ieHiP1xPu3tzUQIM805s0JBKsTh95La
         vO71skJxJoZKMJP2qAemNRgi4DeltY5wAgoQyDMn+1d4JCfaY/pSlDAoYQ9a0bdrjB5+
         eQQA==
X-Gm-Message-State: AOAM533iSjo3U7AtJfGL9dc8mIZydPtINXxFUVK/FFHhzGakUVgc76iq
        SAFRXjO2J+hYMXKyKrAuP2EQygeyqGVEJ/qO2+GtZQ==
X-Google-Smtp-Source: ABdhPJxhv7RXUJ/PWaU2opasINceJBzbsz+teV3HvtYyPW8Zh1yGiWJiY5XlUQsZmxizgm6FDEwDJChxnNNyjEUi4Ng=
X-Received: by 2002:a92:c542:: with SMTP id a2mr13032279ilj.191.1631639664245;
 Tue, 14 Sep 2021 10:14:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210912192805.1394305-1-vladimir.oltean@nxp.com>
 <CANr-f5wCpcPM+FbeW+x-JmZt0-WmE=b5Ys1Pa_G7p8v3nLyCcQ@mail.gmail.com>
 <20210912213855.kxoyfqdyxktax6d3@skbuf> <YT+dL1R/DTVBWQ7D@lunn.ch>
 <20210914120617.iaqaukal3riridew@skbuf> <YUCytc0+ChhcdOo+@lunn.ch>
 <20210914151525.gg2ifaqqxrmytaxm@skbuf> <CANr-f5zNnywpNxMAmNDv60otqXo2oGKiQpT2BL3VraOZftGc4w@mail.gmail.com>
 <YUDOA9SKfCliXlTx@lunn.ch>
In-Reply-To: <YUDOA9SKfCliXlTx@lunn.ch>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Tue, 14 Sep 2021 19:14:12 +0200
Message-ID: <CANr-f5yaLZnKwmsT6qpNgXCgm2wYk54f2x9ajuCzSx0as8o-Dg@mail.gmail.com>
Subject: Re: [RFC PATCH net] Revert "net: phy: Uniform PHY driver access"
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I submitted it, but Michal Simek argumented that dts files of FPGA
> > logic shall not be part of mainline. I suggested that at least one
> > reference platform for every FPGA based IP core should be allowed,
> > but he said that no one is able to test it.  So it seems that you
> > will never see any dts file which contains FPGA logic in mainline. I
> > will try to submit it again if anyone will support me?
>
> My opinion: If there is a real product out in the field using this,
> the DT for the product can be in mainline.
>
> Reference Design Kits for ASICs are well supported in mainline. So the
> question is, is an FPGA sufficiently different to an ASIC that is
> should be treated differently? Do you have an off the shelf platform
> or something custom? How easy is it to get the platform which is used
> as an RDK? Can you make a bitstream available for anybody to use?

At least in combination with the board I can see no difference between ASIC
and FPGA. Usually a FPGA bitstream targets a specific board, so the devices
within the FPGA can be treated like devices on the board.

The reference platform is based on off the shelf stuff (Xilinx ZCU104 and Avnet
AES-FMC-NETW1-G). At least I had no problem buying the boards.

Yes, I can provide a bitstream for everybody.

Gerhard
