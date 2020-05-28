Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BC91E6E63
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436846AbgE1WJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436828AbgE1WJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:09:28 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7CDC08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:09:28 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id p18so144647eds.7
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IZH8xO2bNTUfc6Ggzpl8ejhUhNMqJqxoQu8e0NmITWs=;
        b=A9RdZDs2Gov0UizhpRfuutPqAnolJ3F3GTqhyfUTHCVlM82kLMrjmy2VaOnRRSKQDY
         iwWfaq7x2dU+UzChYpRvtiXM/vbX8YXffaquQM/lkaVXmAifrB9E7v4pv8gW3RX7nYrL
         6Zt2EWH7wuwqwr230VQEP8XHZBu1QGWupLvXI25b2TO0W+IO8lV7WltDAniaYS06lMbV
         1tw7Rvku5K0OtYmMybSnaqNX/8KgKeIC70u2j59W+JFz50ZqTyJD/mxbEq3YB2cJ4jP1
         zW/L/VqsPRwiaIkuW7l54pKlVLTF6CHRPoHFU2wrEsgkdvBjLHojXd7FDfBO6jxezfEA
         ycYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IZH8xO2bNTUfc6Ggzpl8ejhUhNMqJqxoQu8e0NmITWs=;
        b=ongo0J3PHt75G6sycq8LiOq4v8Wlk5uLpcwpOj4W2dtiIXDBR4t7sp5OebgskxnuWR
         +uZDzui2NW1ds80Yi0MiXMkVL/HdPE5czfN2MhE/HUumvhro76IvTVgfWw+zzc75zhdr
         ueNwiVXoRYkTbJGQ1F3IN7H7Uu+xP594BsIaC1Yg5xNBJgbFdLlBuXU9jwEy17715VS5
         u9/4SsTEdzCiwr0qSzOM7usGUIcQBu/wtdg35UWPm3iz1H9kYAUSh2Gdz5Tfxqnu/bYR
         L5PQMoj58cNbeeoCZR5tXAnEav3sIKIy5rFzOl4+hV26ZZ3lW5Uo18/GTP/pLm+njpR7
         ei4Q==
X-Gm-Message-State: AOAM530D4KJJoo56oaTt9YMc1Et5zGJOEbMvF+yjb46bIZu0Ell+Oj5K
        fJgb0GxxLFu6mN74ipqvGe51sDj9z2if/pNDsYg=
X-Google-Smtp-Source: ABdhPJwgMyjjHIDuet/cEjdv4bTSjCh+wSSdtr/ObcU7TfneYuckwsdUAf0XLopK6o2HJvte0SmyCr+eCt9NN4R7mNc=
X-Received: by 2002:aa7:d8c2:: with SMTP id k2mr5450683eds.145.1590703767054;
 Thu, 28 May 2020 15:09:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200527234113.2491988-1-olteanv@gmail.com> <20200527234113.2491988-12-olteanv@gmail.com>
 <20200528215618.GA853774@lunn.ch>
In-Reply-To: <20200528215618.GA853774@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 29 May 2020 01:09:16 +0300
Message-ID: <CA+h21hoVQPVJiYDQV7j+d7Vt8o5rK+Z8APO2Hp85Dt8cOU7e4w@mail.gmail.com>
Subject: Re: [PATCH net-next 11/11] net: dsa: ocelot: introduce driver for
 Seville VSC9953 switch
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020 at 00:56, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Extending the Felix driver to probe a PCI as well as a platform device
> > would have introduced unnecessary complexity. The 'meat' of both drivers
> > is in drivers/net/ethernet/mscc/ocelot*.c anyway, so let's just
> > duplicate the Felix driver, s/Felix/Seville/, and define the low-level
> > bits in seville_vsc9953.c.
>
> Hi Vladimir
>
> That has resulted in a lot of duplicated code.
>
> Is there an overall family name for these switch?
>
> Could you add foo_set_ageing_time() with both felix and saville share?
>
>       Andrew

Yes, it looks like I can. I can move Felix PCI probing to
felix_vsc9959.c, Seville platform device probing to seville_vsc9953.c,
and remove seville.c.
I would not be in a position to know whether there's any larger family
name which should be used here. According to
https://media.digikey.com/pdf/Data%20Sheets/Microsemi%20PDFs/Ocelot_Family_of_Ethernet_Switches_Dec2016.pdf,
"Ocelot is a low port count, small form factor Ethernet switch family
for the Industrial IoT market". Seville would not qualify as part of
the Ocelot family (high port count, no 1588) but that doesn't mean it
can't use the Ocelot driver. As confusing as it might be for the
people at Microchip, I would tend to call anything that probes as pure
switchdev "ocelot" and anything that probes as DSA "felix", since
these were the first 2 drivers that entered mainline. Under this
working model, Seville would reuse the struct dsa_switch_ops
felix_switch_ops, while having its own low-level seville_vsc9953.c
that deals with platform integration specific stuff (probing, internal
MDIO, register map, etc), and the felix_switch_ops would call into
ocelot for the common functionalities.
What do you think?

-Vladimir
