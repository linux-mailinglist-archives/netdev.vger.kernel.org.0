Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE472A2AAC
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 13:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbgKBM2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 07:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728423AbgKBM2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 07:28:16 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18ACC0617A6;
        Mon,  2 Nov 2020 04:28:15 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id gn41so1336392ejc.4;
        Mon, 02 Nov 2020 04:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r0EmSEXf/0XT40e873mQz4YprX1O3VYLukb1wmj/kec=;
        b=idjZtWV4vatTj1nTg40BZZrUZKoyrh2xih0VCjsRyQD+kqyvhjiuHzgtMckah9x32J
         1JQ43tyR/7HdM2acmEdbNRojx4Qety/TF0q5PV3OsQ1W0OU+BOI34nhRU7XMJZ/2DrFI
         7xABIONySe0YdUBkMEdtn9sTeKQKg/DR2krm+HyvPpTtWecmi9sNt7EHqlTprjuO2Ga0
         igs+b1ddS0kyCRp47mimsVet+LP/bSYKVpD2jDFlJxQsGeFPlVtT/Mw3IaSNAZJISXKk
         whJGJONiJb6g0suucDjrj/23xblMUfVIqRjg3mS3zqlzYW5gOguzqgB46EG0DHI4Kq3J
         4J0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r0EmSEXf/0XT40e873mQz4YprX1O3VYLukb1wmj/kec=;
        b=IaVxS9yoo2wRdFly6EVVQHsGHwrfP3G8/bgQevugURR34YyzuthnBh8ZxWmpLw+aDA
         C4elpIElcWVKNsShTOlVCT6u36utpXDp41frM2/fwBq3MLDduHtfcj+Cy6AeRJSO3rmy
         ysqKKMH3lVpvhnfD2UXmcKRmMcAtMuUCcmjCJQvDHOHC57BY9mJKJazIxUYqg+TZjMCp
         8+hhc7gt2IhHUZEhf280vTDqo5KHdWO8TtrcKq9eK12NvXO987Kr07G6eV5zCfyFpN0Q
         VN7vG/Dc2T6Ih54UrBEKxoImjHJCtJBxw/EA5h9xwxa+oBwbB8/ERRTJBCuQNrYVwLiF
         vbiQ==
X-Gm-Message-State: AOAM533ewUO8ug6fBrR0ea0WR84hYefCSdtKqYAJXAlPh8TpTBaaji1A
        vFU6tsW0cq1XdWBNzOzyJzw=
X-Google-Smtp-Source: ABdhPJw23VHbuAGhOxMG2Gc/6a2gOIQAOHe/f1S9hf1JWKLklZBygJPWmUQTxaX6u7SQJ0Vn4QOWMQ==
X-Received: by 2002:a17:906:b043:: with SMTP id bj3mr14724258ejb.338.1604320094629;
        Mon, 02 Nov 2020 04:28:14 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id p9sm9488174ejo.75.2020.11.02.04.28.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 04:28:13 -0800 (PST)
Date:   Mon, 2 Nov 2020 14:28:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add
 hardware time stamping support
Message-ID: <20201102122812.cwu7ptmcc7vpfmrc@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de>
 <3355013.oZEI4y40TO@n95hx1g2>
 <20201101234149.rrhrjiyt7l4orkm7@skbuf>
 <1779456.uGjeJ53Q7B@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1779456.uGjeJ53Q7B@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 11:35:00AM +0100, Christian Eggers wrote:
> Maybe my mail from October, 22 was ambiguous. I meant that despite of the
> presence of filtering, a BCMA algorithm should be about to work (as no
> Announce messages are filtered out).
> 
> Additionally I said, that switching between "master" and "slave" mode could
> not be done automatically by the driver, as the driver could at most detect
> the presence of Sync messages (indication for master mode), but would do hard
> to detect a transition to slave mode.
> 
> I see a chance that user space (ptp4l) could configure the appropriate
> "hardware filter setup" for master/slave mode.

The concept that you want from user space is hard to define.
You want ptp4l to make the driver aware of the port state, which is
something that happens at runtime and is not part of the "hardware
filter setup" as you say. Then, even if ptp4l notifies the driver of
port state, E2E BC setups would still be broken because that's how the
hardware works and no user space assistance can help with that. Also,
what abstraction do you plan using for programming the PTP port state
into the kernel.

Maybe you should optimize for what you plan to use. If you need to use
an E2E profile, maybe it would be worth the effort to find an
appropriate abstraction for this port state thing. If you only use it
for testing, then maybe it would be a good idea to keep the sysfs in
your tree.

> > Why am I mentioning this? Because the setting that's causing trouble for
> > us is 'port state of the host port OC', which in the context of what I
> > said above is nonsense. There _is_ no host port OC. There are 2 switch
> > ports which can act as individual OCs, or as a BC, or as a TC.
> But the switch has only one clock at all. I assume that the switch cannot be a
> boundary clock, only TC seems possible.

Why would a P2P BC not work? It does not require more than one clock.

> As said above, having "filter setups" for E2E/P2P and for MASTER/SLAVE would
> probably fit well for this kind of hardware.

For E2E/P2P is one thing, for master/slave is a completely different
thing.
