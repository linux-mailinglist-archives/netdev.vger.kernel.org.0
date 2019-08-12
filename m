Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D778A1FA
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 17:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbfHLPJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 11:09:53 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35344 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbfHLPJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 11:09:53 -0400
Received: by mail-lj1-f195.google.com with SMTP id l14so8680162lje.2
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 08:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t1V8mqCBoCuSvxrNXOIb8cs51g3I5htO8SXqEzVW8X8=;
        b=n1QSWsyssZRjTp5iO7oJPWuTI2ZaJpwixEgzfyflZDttCKEF+JE8H0vovRd8fEJy5F
         l4mLA0x0c/Wl3Ri1chRWipsiac2k/g0407PeuzESEg686zlA0HQqAj3oNhQRsFeLx+Ca
         L/C1qM0Ksb5EDsrdYkywNPfHZ4T4Zn7lCUNuLr5ZVagc2KqSBZOdkTqK7XFpCNq36tnv
         xIjHOkC6kXyU/ri3rGDYAW/h/Eq+Rlkr4rqmVjleG/MmO6l4bleAXUr0Xhny40zkKT57
         549CwiLTjT2Kph2g8sUmOtjgYBgNVlSBoGsTnDQ83BVHeqIdZHkMAq9naoYfMxoBzJgY
         1WUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t1V8mqCBoCuSvxrNXOIb8cs51g3I5htO8SXqEzVW8X8=;
        b=BV1xubr+sNYYUOLi/Z/Z6p3u2WuLEq+WpJ8EEI/ZyYoQZFNwo8nhUg11RxtOsXaGlU
         jyNkunSkAM85Wm9/C4jWPFR1mbIRwUywxyhLccJEN3CFwL3nGUe3Wrty+YaMZ3tdj/bT
         DwoPXBnef4DbrsRuGeVx/kCYpIN4PB01csMYY/17wI0W3k+o5r2ZLTUfibgBbbY6rtI1
         NP/yJ5W2uFD7ceE1pmsBLacSkKfe/3CWr0pDG5K4Sndc6DQlRalbCxDITcNhR9ekiBc1
         epWb6mfHKlkhCaG6CMj6xlyrYXuV9YgeZqB10eIOm5cmZ+mzJF+P5XQ2nPoncW2lxpcv
         q2rA==
X-Gm-Message-State: APjAAAXV7EPWMvarZXGgQuTfxLW5IkdCr/oFPw7+iHr/0gxtaCpdvTXG
        ciXB8me3siZYRiEDDMu4HsxXlBznpOBtylZT+hCMRIc7cQc=
X-Google-Smtp-Source: APXvYqzZpoyvhmC+QB37WE13tQdqAWo1VGdA91KCXsz3B1pcZkpZeWArAHP4cRIYpkm3PmWGOaB9p0kbOy5ElWiOxqU=
X-Received: by 2002:a2e:5dc6:: with SMTP id v67mr19358346lje.240.1565622590807;
 Mon, 12 Aug 2019 08:09:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190811133707.GC13294@shell.armlinux.org.uk>
In-Reply-To: <20190811133707.GC13294@shell.armlinux.org.uk>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 12 Aug 2019 12:10:21 -0300
Message-ID: <CAOMZO5BeaNysZA2CWoXb5cbz_hKFZEyb0sDmsLxRQukziXoSxw@mail.gmail.com>
Subject: Re: [BUG] fec mdio times out under system stress
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Sun, Aug 11, 2019 at 10:37 AM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> Hi Fabio,
>
> When I woke up this morning, I found that one of the Hummingboards
> had gone offline (as in, lost network link) during the night.
> Investigating, I find that the system had gone into OOM, and at
> that time, triggered an unrelated:
>
> [4111697.698776] fec 2188000.ethernet eth0: MDIO read timeout
> [4111697.712996] MII_DATA: 0x6006796d
> [4111697.729415] MII_SPEED: 0x0000001a
> [4111697.745232] IEVENT: 0x00000000
> [4111697.745242] IMASK: 0x0a8000aa
> [4111698.002233] Atheros 8035 ethernet 2188000.ethernet-1:00: PHY state change RUNNING -> HALTED
> [4111698.009882] fec 2188000.ethernet eth0: Link is Down
>
> This is on a dual-core iMX6.
>
> It looks like the read actually completed (since MII_DATA contains
> the register data) but we somehow lost the interrupt (or maybe
> received the interrupt after wait_for_completion_timeout() timed
> out.)
>
> From what I can see, the OOM events happened on CPU1, CPU1 was
> allocated the FEC interrupt, and the PHY polling that suffered the
> MDIO timeout was on CPU0.
>
> Given that IEVENT is zero, it seems that CPU1 had read serviced the
> interrupt, but it is not clear how far through processing that it
> was - it may be that fec_enet_interrupt() had been delayed by the
> OOM condition.
>
> This seems rather fragile - as the system slowing down due to OOM
> triggers the network to completely collapse by phylib taking the
> PHY offline, making the system inaccessible except through the
> console.
>
> In my case, even serial console wasn't operational (except for
> magic sysrq).  Not sure what agetty was playing at... so the only
> way I could recover any information from the system was to connect
> the HDMI and plug in a USB keyboard.
>
> Any thoughts on how FEC MDIO accesses could be made more robust?

Sorry for the delay. I am currently on vacation with limited e-mail access.

I think it is worth trying Andrew's suggestion to increase FEC_MII_TIMEOUT.

Thanks
