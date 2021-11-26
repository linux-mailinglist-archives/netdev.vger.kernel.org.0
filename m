Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E38645F2AB
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhKZROv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhKZRMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 12:12:50 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9543FC06175F
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 08:44:24 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gt5so7533397pjb.1
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 08:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TcgTSE2azu/7mVjnggRn/bV+t1nYxobd9cSmZndqVwo=;
        b=F9uy8KZ2Chna+3YfWZfq9KZPvmtjt6eh6c6i2DnF2UkVm8T3/gcqUFCXn3OZJNAp9b
         Q7xslmP6Skw9lcPcdWTev1he/6gsTY4nWuDpWhFehB6Ethh5kKxnH4Ay5zhgRl01zHp/
         CVFy16Nreamwp9nfgVwKYFV8h/FMnMnqjwDMBPCMXnshY3QxDcb5FBp+gU+yFeFfcrbS
         EauGvE7MCttaOopUoSXKLxHbxQDwR/0zkzcKKOAEwqvO1aXwJODO+Cu4hen351UBW1ji
         5At28GkhClSK8DK3eQtZGGKuVOsPbqHQFYalFkebDu3n8SG65BFAvXe1pOcPJITO14s4
         A9BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TcgTSE2azu/7mVjnggRn/bV+t1nYxobd9cSmZndqVwo=;
        b=TiNSzFhqK6IUdz0j5pHqb59e1KBqit7E4Cb+L+hPNRsdlJpj8haA738ODpVVIkpdXC
         w8KilkPB5CV/PQT/WM2tQNjSrnbDiP5xvHtmCsU8xyK3v+GpWiO2JctEkV291+8i7Unr
         ffQ/BmcNeBB30c/rHC0UgdAPjdktFYMrnjI7uFYoDXQrW0BfHzz+k+x5KM7dAX3ACi2r
         FIFQmrabCwHs71yBsdznRJw8rjjcyQjuDJ9ekYFa1FkgrONjzSyQs+b5yB5sTyR1+Jih
         o09Rt9u8l/Nqay1Ja5h1A8aemHnp1C8kJQvhLpCeFLmxfyD3wPgeGOtubmX1Thitiw1D
         2Y1Q==
X-Gm-Message-State: AOAM532zygFLz0tbRTmA6k5YBk13quWeHzMZVGG0+LcIJHqHVp5Z5K8K
        y15JkuxBezZV7xypDDhu3b8=
X-Google-Smtp-Source: ABdhPJwa1ekmU/Pe23Tut+MmjQ5j7a2w3wegjnATVyLwYypxrH47WN7p9A6lIQZoqQw9KerRZVHfKw==
X-Received: by 2002:a17:902:8f97:b0:143:88c2:e2d5 with SMTP id z23-20020a1709028f9700b0014388c2e2d5mr40025254plo.70.1637945064145;
        Fri, 26 Nov 2021 08:44:24 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id u6sm7628233pfg.157.2021.11.26.08.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 08:44:23 -0800 (PST)
Date:   Fri, 26 Nov 2021 08:44:21 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Po Liu <po.liu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: Re: [PATCH net-next 0/4] Fix broken PTP over IP on Ocelot switches
Message-ID: <20211126164421.GC27081@hoboy.vegasvil.org>
References: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 01:21:14AM +0200, Vladimir Oltean wrote:
> Po Liu reported recently that timestamping PTP over IPv4 is broken using
> the felix driver on NXP LS1028A. This has been known for a while, of
> course, since it has always been broken. The reason is because IP PTP
> packets are currently treated as unknown IP multicast, which is not
> flooded to the CPU port in the ocelot driver design, so packets don't
> reach the ptp4l program.
> 
> The series solves the problem by installing packet traps per port when
> the timestamping ioctl is called, depending on the RX filter selected
> (L2, L4 or both).
> 
> Vladimir Oltean (4):
>   net: mscc: ocelot: don't downgrade timestamping RX filters in
>     SIOCSHWTSTAMP
>   net: mscc: ocelot: create a function that replaces an existing VCAP
>     filter
>   net: ptp: add a definition for the UDP port for IEEE 1588 general
>     messages
>   net: mscc: ocelot: set up traps for PTP packets

For the series:

Acked-by: Richard Cochran <richardcochran@gmail.com>
