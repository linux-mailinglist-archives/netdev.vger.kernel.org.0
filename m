Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F5B48CD1B
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 21:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiALUbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 15:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbiALUbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 15:31:18 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58155C06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 12:31:18 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id z3so5886739plg.8
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 12:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xqvY3nTZUcLYBctMg7Dn7I/woQvDEHbfjh+rmN6+3V0=;
        b=fAFd1gEN3tHnuqiNbuIEK7vZc54ntMkj+4eZt15LMuINWFn6maZaqc0G+f+9nRbldj
         /9/sWxoPJYk23WYZzD7wFXD3Ov/vxYA4LwswAXiSUj/FJ8+nFpF0AnjXNn66wyvJVo58
         G19XVwDVwrOaLtM9eBYIvt8UbJwpv81rfgEjv1CrMDp4xDeWb68T63N02We08gV0ixF5
         LuzQUT4Ii3122jTzVeP5kG3HYc1Gy3cxCV2kseguROjeY4J2MIeDlUyC71ykkJlZhn8A
         oLCatEo/I1WMcw1RZK/DdDL8fYaOj7Mm6mfaCSx6/KhveT84W0yz8wvukWvL547BG2mO
         sp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xqvY3nTZUcLYBctMg7Dn7I/woQvDEHbfjh+rmN6+3V0=;
        b=Pj1+CIWyXrFhUfTp+QM0Wegl+6/hSkN8/HNyGLucSXYbYXZ8mazqSbr3KdIyhX6hu0
         fVdIvBf6jLNzJK5R6ffX/Kqcr/jJcBXV8EB19JOB6/iPpM/T/ZHNP096BRbqyUmLbY53
         dv/hi7UimkklJs3ync21ZefwmPrFP8iJf0ixHbCBs3sKBM43OMcEU4tNbZt6x3qLP9pw
         hx/p6jjycwB+CMIP5L3ePEexhalSSt7eZREEzTI5c2n281T2iy192QSs7VFm/tlMvuts
         +5pnaOX6/Uzv0J8DggK/pMtxQqTf2nJJCsE/rfvCvm2Wi6uZxK95QVJErXyWGut1cFNp
         toQg==
X-Gm-Message-State: AOAM533PFlnq5UWtRDrgUARBfvVWMUW48Eed1dykbxzxDHf3TyblHJCY
        5pic5lJj98sGVTcB7OVY6ag=
X-Google-Smtp-Source: ABdhPJxo7kXllSKMJSdwfH010nwXKDWVbSYjMtuwvKMzhIFTWAtWnwFX0NI//ji6b16JgZvG3XLuOg==
X-Received: by 2002:a05:6a00:2408:b0:4c1:e1a1:770 with SMTP id z8-20020a056a00240800b004c1e1a10770mr689965pfh.70.1642019477816;
        Wed, 12 Jan 2022 12:31:17 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k2sm466088pgh.11.2022.01.12.12.31.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 12:31:17 -0800 (PST)
Subject: Re: [PATCH net] net: mscc: ocelot: don't let phylink re-enable TX
 PAUSE on the NPI port
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
References: <20220112202127.2788856-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2662f157-fa92-8a99-473a-9ca5f7887d28@gmail.com>
Date:   Wed, 12 Jan 2022 12:31:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220112202127.2788856-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/22 12:21 PM, Vladimir Oltean wrote:
> Since commit b39648079db4 ("net: mscc: ocelot: disable flow control on
> NPI interface"), flow control should be disabled on the DSA CPU port
> when used in NPI mode.
> 
> However, the commit blamed in the Fixes: tag below broke this, because
> it allowed felix_phylink_mac_link_up() to overwrite SYS_PAUSE_CFG_PAUSE_ENA
> for the DSA CPU port.
> 
> This issue became noticeable since the device tree update from commit
> 8fcea7be5736 ("arm64: dts: ls1028a: mark internal links between Felix
> and ENETC as capable of flow control").
> 
> The solution is to check whether this is the currently configured NPI
> port from ocelot_phylink_mac_link_up(), and to not modify the statically
> disabled PAUSE frame transmission if it is.
> 
> When the port is configured for lossless mode as opposed to tail drop
> mode, but the link partner (DSA master) doesn't observe the transmitted
> PAUSE frames, the switch termination throughput is much worse, as can be
> seen below.
> 
> Before:
> 
> root@debian:~# iperf3 -c 192.168.100.2
> Connecting to host 192.168.100.2, port 5201
> [  5] local 192.168.100.1 port 37504 connected to 192.168.100.2 port 5201
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec  28.4 MBytes   238 Mbits/sec  357   22.6 KBytes
> [  5]   1.00-2.00   sec  33.6 MBytes   282 Mbits/sec  426   19.8 KBytes
> [  5]   2.00-3.00   sec  34.0 MBytes   285 Mbits/sec  343   21.2 KBytes
> [  5]   3.00-4.00   sec  32.9 MBytes   276 Mbits/sec  354   22.6 KBytes
> [  5]   4.00-5.00   sec  32.3 MBytes   271 Mbits/sec  297   18.4 KBytes
> ^C[  5]   5.00-5.06   sec  2.05 MBytes   270 Mbits/sec   45   19.8 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-5.06   sec   163 MBytes   271 Mbits/sec  1822             sender
> [  5]   0.00-5.06   sec  0.00 Bytes  0.00 bits/sec                  receiver
> 
> After:
> 
> root@debian:~# iperf3 -c 192.168.100.2
> Connecting to host 192.168.100.2, port 5201
> [  5] local 192.168.100.1 port 49470 connected to 192.168.100.2 port 5201
> [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
> [  5]   0.00-1.00   sec   112 MBytes   941 Mbits/sec  259    143 KBytes
> [  5]   1.00-2.00   sec   110 MBytes   920 Mbits/sec  329    144 KBytes
> [  5]   2.00-3.00   sec   112 MBytes   936 Mbits/sec  255    144 KBytes
> [  5]   3.00-4.00   sec   110 MBytes   927 Mbits/sec  355    105 KBytes
> [  5]   4.00-5.00   sec   110 MBytes   926 Mbits/sec  350    156 KBytes
> [  5]   5.00-6.00   sec   110 MBytes   925 Mbits/sec  305    148 KBytes
> [  5]   6.00-7.00   sec   110 MBytes   924 Mbits/sec  320    143 KBytes
> [  5]   7.00-8.00   sec   110 MBytes   925 Mbits/sec  273   97.6 KBytes
> [  5]   8.00-9.00   sec   109 MBytes   913 Mbits/sec  299    141 KBytes
> [  5]   9.00-10.00  sec   110 MBytes   922 Mbits/sec  287    146 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  1.08 GBytes   926 Mbits/sec  3032             sender
> [  5]   0.00-10.00  sec  1.08 GBytes   925 Mbits/sec                  receiver

Still quite a lot of retries, do you know where they are coming from?

> 
> Fixes: de274be32cb2 ("net: dsa: felix: set TX flow control according to the phylink_mac_link_up resolution")
> Reported-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
