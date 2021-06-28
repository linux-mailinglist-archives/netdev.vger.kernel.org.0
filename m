Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DA63B5E60
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 14:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhF1MvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 08:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbhF1MvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 08:51:05 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30EDC061574;
        Mon, 28 Jun 2021 05:48:38 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bu12so29878896ejb.0;
        Mon, 28 Jun 2021 05:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NPhqsvNIof7wCDk0v6mRn0i9DTXUk2KH9LJ6omkVnw8=;
        b=XfpoPH/o6now8GJy5K4IFDLCf3samF3Lny2YtRW9BX4osNfdac0RacNYj8Sp++bubv
         grrtn0LvR8gOEC4YGHoIq7r2ng4wVWuZqZJDcM25Wx20Ztb3Aowsl7sLo627W3pJcIUl
         mY7/1XzgmadeXZoGmZMqipkHrCAe02VjaIya5GzbJp5JXc9NuYfUY1CSpFF85pAxwniY
         17gAdPzUjv/dcetj4n0dlV8kwM8sqWxhulP5KWPRcQWN3CdGq8k5VMDYYarV5N0hLqP9
         UVZ8jtlIORtuuU3puui6JDKK7xJx1ImZE5q/hO+FfowCwtayN8dL8Ab52uxzcPoVEBxz
         EIiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NPhqsvNIof7wCDk0v6mRn0i9DTXUk2KH9LJ6omkVnw8=;
        b=bTBojPD+rRq/Z22n4e6ep1s2//Ktfpv3zi+R3aGRFPq1o45sV0wiB+rHwVH6AfDymr
         I86qNFGsPjdsWLuNt/Pd5UyC4S+yaNWD1EmVBdLLk8+dPNJcyRO+GNoGZPLEIK+vsOP+
         SNOZM4ccT6D55xw9rTnO6zm1BTb/0FW99XKbdSivvRJhLUXyJuRPNrlsQMOfEf2YfTnY
         ibFC0rwZyMJm/5TjPb3qQm6SzsZYCXIJhYud62kzcUYc/H43sjPhJoW77BJBv34/2hYx
         e3lSiq8fZhOIaolADD7kQ6ysnrC5YHdhmDwFDryp4q1hqLFALQYfRaNd118qojKk+dZ9
         uLrw==
X-Gm-Message-State: AOAM532EW+UvhwiEyrAIaYLf0ZBtqZdTtGX8z8JfVhd2LPwdPDs5vBlK
        p5I6eJ+mNnK6bMsnpOch5PWSEnQoCR4=
X-Google-Smtp-Source: ABdhPJxLfYjUfeSENFz0wM2VzYsQ/ssbwmU2WGfDz7Ry5IMNbmnystKo9pZoaR8zvE9DerEM9oXXNA==
X-Received: by 2002:a17:906:8a72:: with SMTP id hy18mr23577505ejc.393.1624884517425;
        Mon, 28 Jun 2021 05:48:37 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id p23sm9426745edt.71.2021.06.28.05.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 05:48:37 -0700 (PDT)
Date:   Mon, 28 Jun 2021 15:48:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] net: Provide switchdev driver for NXP's More Than IP
 L2 switch
Message-ID: <20210628124835.zbuija3hwsnh2zmd@skbuf>
References: <YNH7vS9FgvEhz2fZ@lunn.ch>
 <20210623133704.334a84df@ktm>
 <YNOTKl7ZKk8vhcMR@lunn.ch>
 <20210624125304.36636a44@ktm>
 <YNSJyf5vN4YuTUGb@lunn.ch>
 <20210624163542.5b6d87ee@ktm>
 <YNSuvJsD0HSSshOJ@lunn.ch>
 <20210625115935.132922ff@ktm>
 <YNXq1bp7XH8jRyx0@lunn.ch>
 <20210628140526.7417fbf2@ktm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628140526.7417fbf2@ktm>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 02:05:26PM +0200, Lukasz Majewski wrote:
> Hi Andrew,
>
> > > I do believe that I can just extend the L2 switch driver (fec_mtip.c
> > > file to be precise) to provide full blown L2 switch functionality
> > > without touching the legacy FEC more than in this patch set.
> > >
> > > Would you consider applying this patch series then?
> >
> > What is most important is the ABI. If something is merged now, we need
> > to ensure it does not block later refactoring to a clean new
> > driver. The DT binding is considered ABI. So the DT binding needs to
> > be like a traditional switchdev driver. Florian already pointed out,
> > you can use a binding very similar to DSA. ti,cpsw-switch.yaml is
> > another good example.
>
> The best I could get would be:
>
> &eth_switch {
> 	compatible = "imx,mtip-l2switch";
> 	reg = <0x800f8000 0x400>, <0x800fC000 0x4000>;
>
> 	interrupts = <100>;
> 	status = "okay";
>
> 	ethernet-ports {
> 		port1@1 {
> 			reg = <1>;
> 			label = "eth0";
> 			phys = <&mac0 0>;
> 		};
>
> 		port2@2 {
> 			reg = <2>;
> 			label = "eth1";
> 			phys = <&mac1 1>;
> 		};
> 	};
> };
>
> Which would abuse the "phys" properties usages - as 'mac[01]' are
> referring to ethernet controllers.
>
> On TI SoCs (e.g. am33xx-l4.dtsi) phys refer to some separate driver
> responsible for PHY management. On NXP this is integrated with FEC
> driver itself.

If we were really honest, the binding would need to be called

port@0 {
	puppet = <&mac0>;
};

port@1 {
	puppet = <&mac1>;
};

which speaks for itself as to why accepting "puppet master" drivers is
not really very compelling. I concur with the recommendation given by
Andrew and Florian to refactor FEC as a multi-port single driver.

> >
> > So before considering merging your changes, i would like to see a
> > usable binding.
> >
> > I also don't remember seeing support for STP. Without that, your
> > network has broadcast storm problems when there are loops. So i would
> > like to see the code needed to put ports into blocking, listening,
> > learning, and forwarding states.
> >
> > 	  Andrew

I cannot stress enough how important it is for us to see STP support and
consequently the ndo_start_xmit procedure for switch ports.
Let me see if I understand correctly. When the switch is enabled, eth0
sends packets towards both physical switch ports, and eth1 sends packets
towards none, but eth0 handles the link state of switch port 0, and eth1
handles the link state of switch port 1?
