Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9D82C7031
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 18:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732583AbgK1EhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 23:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731889AbgK1Ee7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 23:34:59 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82DFC0613D1;
        Fri, 27 Nov 2020 20:34:58 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id x24so6164660pfn.6;
        Fri, 27 Nov 2020 20:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Oz3P6Bv01WMGgJrlQ1Jw9ujpaP6+pticwUV9K58yqjY=;
        b=J6okCzp4hUpHZJ186CFTgeWSiK1YvwD2YbXrvdLbUNinTz8bTumrtLkXhqhXncBD/u
         +EM0s9yzENGVXnskf54Sufspn4LHQURdvOI2eq+fyEvu8YprsBN1nzo5rBV34/kEfrRr
         8RORIj/vA/U1IA5WXH0NKQfDknT/Mx7n4bFrbXst9kFve1l3oxTCtgNeuacAK3FYuzOI
         4edCltvv7RnR+8LvyCOc/mmdyyNCGrBvDPYbf05Dg4nJmfuOp9gSAcaUJKlJ9X87Udez
         Pzt9VhOTrgDh4mfg8jJkl4PuJDs6ZdeVBVt3+f7wKX9iyG64ORX5JPmMOpRvwNZd0Yt4
         w4Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Oz3P6Bv01WMGgJrlQ1Jw9ujpaP6+pticwUV9K58yqjY=;
        b=ctYv8PE4IJsclYyRAYRgq2rtzqiXxauTtK9JxDNrG8BcR/bFRSjU0KAH+a3tgL8axm
         5PWlTOqSKt3REYa51SLia0+awMkl8eU3APVLyOC3PmWLHgFzgZGR6SNgfxq5LcEuTUT3
         c4UtNf1BzHFpCuxOgBY5jOR2egEQwPH0Ix1M5lFHQDzpDfi5nkI/49jSbkmX618XogFa
         QzJTYW97iLhLkTMVqG6Q+h/n4fpPSCWSqDJFw51iXJ7xfIqZtGTgnBpWZEvAFRBmqWxy
         mgmnIKgtzfx00GkeNwgr1fFPBQ89wfs2zIDwU9WRuw+4JHUJm9pxA/reiA6DcT9FJ70J
         26TQ==
X-Gm-Message-State: AOAM531jzjuFKiERpHuroRARu8i8YAfxTs3jIa35lGIR7SUUB3cGIPGi
        69hGiiTN+t8/6sG2zxs4soE=
X-Google-Smtp-Source: ABdhPJy4QlBHTCzbZtvgcfWDfLIsNGiyIKLPMQfy2IYap8lT9sZ8DGje0DBAxVnQSJFSrzEzcfaTiw==
X-Received: by 2002:a17:90b:891:: with SMTP id bj17mr13651734pjb.59.1606538097778;
        Fri, 27 Nov 2020 20:34:57 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ev12sm2754038pjb.22.2020.11.27.20.34.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2020 20:34:57 -0800 (PST)
To:     Lukasz Majewski <lukma@denx.de>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>, stefan.agner@toradex.com,
        krzk@kernel.org, Shawn Guo <shawnguo@kernel.org>
References: <20201125232459.378-1-lukma@denx.de>
 <20201126123027.ocsykutucnhpmqbt@skbuf> <20201127003549.3753d64a@jawa>
 <20201127192931.4arbxkttmpfcqpz5@skbuf> <20201128013310.38ecf9c7@jawa>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC 0/4] net: l2switch: Provide support for L2 switch on i.MX28
 SoC
Message-ID: <61fc64a6-a02b-3806-49fa-a916c6d9581a@gmail.com>
Date:   Fri, 27 Nov 2020 20:34:55 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201128013310.38ecf9c7@jawa>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/27/2020 4:33 PM, Lukasz Majewski wrote:
>> So why use DSA at all? What benefit does it bring you? Why not do the
>> entire switch configuration from within FEC, or a separate driver very
>> closely related to it?
> 
> Mine rationale to use DSA and FEC:
> - Make as little changes to FEC as possible

Which is entirely possible if you stick to Vladimir suggestions of
exporting services for the MTIP switch driver.

> 
> - Provide separate driver to allow programming FDB, MDB, VLAN setup.
>   This seems straightforward as MTIP has separate memory region (from
>   FEC) for switch configuration, statistics, learning, static table
>   programming. What is even more bizarre FEC and MTIP have the same 8
>   registers (with different base address and +4 offset :-) ) as
>   interface to handle DMA0 transfers.

OK, not sure how that is relevant here? The register organization should
never ever dictate how to pick a particular subsystem.

> 
> - According to MTIP description from NXP documentation, there is a
>   separate register for frame forwarding, so it _shall_ also fit into
>   DSA.

And yet it does not, Vladimir went into great length into explaining
what makes the MTIP + dual FEC different here and why it does not
qualify for DSA. Basically any time you have DMA + integrated switch
tightly coupled you have what we have coined a "pure switchdev" wrapper.

> 
> 
> For me it would be enough to have:
> 
> - lan{12} - so I could enable/disable it on demand (control when switch
>   ports are passing or not packets).
> 
> - Use standard net tools (like bridge) to setup FDB/MDB, vlan 
> 
> - Read statistics from MTIP ports (all of them)
> 
> - I can use lan1 (bridged or not) to send data outside. It would be
>   also correct to use eth0.

You know you can do that without having DSA, right? Look at mlxsw, look
at rocker. You can call multiple times register_netdevice() with custom
network devices that behave differently whether HW bridging offload is
offered or not, whether the switch is declared in Device Tree or not.

> 
> I'm for the most pragmatic (and simple) solution, which fulfill above
> requirements.

The most pragmatic solution is to implement switchdev operations to
offer HW bridging offload, VLAN programming, FDB/MDB programming.

It seems to me that you are trying to look for a framework to avoid
doing a bit of middle layer work between switchdev and the FEC driver
and that is not setting you for success.
-- 
Florian
