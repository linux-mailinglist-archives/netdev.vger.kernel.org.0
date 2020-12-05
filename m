Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D592CFBC9
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 16:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgLEPjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 10:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbgLEO6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 09:58:23 -0500
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9D4C02B8F1;
        Sat,  5 Dec 2020 06:35:23 -0800 (PST)
Received: by mail-vk1-xa41.google.com with SMTP id u16so2001423vkb.1;
        Sat, 05 Dec 2020 06:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u48AAhcHUf2aSWhmDQt2AnHDGpeiRUbnTvdQldiXb8Q=;
        b=REpuVoaSR0wsKXnhLga++HW1mnG57H2gf0fduOk4jEFCreTDtg3yrRKZvist+TQCLG
         z1Xl9laRk3I4NqHSZ5khOcmFiLSmUQTqUs6fbMd56nptISbDu80+Y1/WBGIYxh5hD4Xk
         qEkEGmvVMD1exL2k4X7bieLpSeYAcGeb+a0O+YCQYI5HQ+C7/+sYdHAgzAAN6YSg6udC
         jd78PBZOWs/z0442MriSUxjIrYbZgZolP7sMji8v9rB/M+iwbzsJh7STRFmr094iu245
         aFoGe9tiAyCzxUWpszGlDSOCNphISqLMoh2hTgiX5kYOHhDVCcGL9PxuU8yKgZi60NU6
         D0Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u48AAhcHUf2aSWhmDQt2AnHDGpeiRUbnTvdQldiXb8Q=;
        b=DLFtBGIQXJIQxiZGKMGAKrAodl000Eqxuo4evUiA8AY6STRsKkhy2AiyozBkKlyR1o
         wcIBiNSwrlt6YtUHN//QVrMpitKfSM+hyz2qJq/fP+w6C6LmZtYfo6O3fcgF9OruzutW
         KTerch6B1tX2LxC7Pz9bRm3b6bUCXUh+1QlPmY0L7nZ9Z+BZW7tfwZPHPnsRw32K6rDW
         BJq0ary8NpoosMZ7jWDEnKN6dpy7PFS4YHN5O5AEwoAphEHj5vxYrxRsojdmgjCpkVO3
         UEDidkR9C313nTKsHsgnniFtd/1HmiW6F2tMdeh0TXwf/77DfwZZjZ612aNlEjosCnqJ
         p7pg==
X-Gm-Message-State: AOAM5304oJPlJZG0ARiqNjUjM1hkTihq4io/W8nar47D5xc73kjvHkfq
        Hs5OkTx5McIdfxNQTStlxSXduH+uEVyHggQa7IIUdy4YRLzyXg==
X-Google-Smtp-Source: ABdhPJzRh/o1+Jqq5XaG3oI7bli7wjwhq6ohUD0oeQSnNRrKgwIxRZd/+vwNhKtPsFoDdNySYwkuCgE7K/wR95NMJgs=
X-Received: by 2002:a1f:e7c2:: with SMTP id e185mr8413560vkh.23.1607178921860;
 Sat, 05 Dec 2020 06:35:21 -0800 (PST)
MIME-Version: 1.0
References: <20201203214645.31217-1-TheSven73@gmail.com> <20201204152456.247769b1@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201204234321.GJ2400258@lunn.ch>
In-Reply-To: <20201204234321.GJ2400258@lunn.ch>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Sat, 5 Dec 2020 09:35:10 -0500
Message-ID: <CAGngYiXYLnJUMrPqiJtRqFxF6xo01FYBvmn1Rq-wbjBDOuC-9Q@mail.gmail.com>
Subject: Re: [PATCH net v1] net: dsa: ksz8795: use correct number of physical ports
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David S Miller <davem@davemloft.net>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub, Andrew,

On Fri, Dec 4, 2020 at 6:24 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> All the port counts here are -1 compared to datasheets, so I'm assuming
> the are not supposed to include the host facing port or something?
>
> Can you describe the exact problem you're trying to solve?
>

The ksz8795 driver refuses to accept my devicetree (see below). It doesn't like
the presence of the cpu node. But I really need a cpu node, because phy-mode is
crucially important to my application: without phy-mode = "rgmii-id", the
ksz8795's ingress bit does not get set, and communication fails.

I was already suspicious of my fix: why would such an important chip property
be wrong? But changing it was very seductive: after all, the ksz8795's headline
is "Integrated 5-Port 10/100-Managed Ethernet Switch", and the driver code says
this:

        .port_cnt = 4,          /* total physical port count */

I can see now that this should be fixed more generally. The of parsing code
is using the wrong port count variable. I'll submit that shortly.

That said, when I look at this driver, I get very confused between port_cnt,
num_ports, and whether they include or exclude the cpu port. Until this gets
cleaned up, maybe the comment above can be improved, so developers don't get
too confused at least? I'll submit a patch for that too.

ethernet-switch@0 {
        compatible = "microchip,ksz8795";
        spi-max-frequency = <1000000>;
        reg = <0>;

        ports {
                #address-cells = <1>;
                #size-cells = <0>;
                port@0 {
                        reg = <0>;
                        label = "lan1";
                };
                port@1 {
                        reg = <1>;
                        label = "lan2";
                };
                port@2 {
                        reg = <2>;
                        label = "lan3";
                };
                port@3 {
                        reg = <3>;
                        label = "lan4";
                };
                port@4 {
                        /* driver errors out because
                         * reg >= dev->port_cnt (4)
                         */
                        reg = <4>;
                        label = "cpu";
                        ethernet = <&something>;
                        phy-mode = "rgmii-id";
                        fixed-link {
                                speed = <1000>;
                                full-duplex;
                        };
                };
        };
};
