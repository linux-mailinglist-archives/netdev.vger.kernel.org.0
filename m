Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE142FE080
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbhAUEOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732107AbhAUEKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 23:10:52 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C20C061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 20:10:11 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id b5so786274pjl.0
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 20:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nym2FNZsKI6bzdnD8xWBI+z7a4zlO5DRya94UNFOEzU=;
        b=a4YToo0F2P51G6NfbEyShr67ZdeeWDoLS0AqW6+rAyA/ep6rRn6AtvHF3Ph3wlqodk
         3LhdBG4WIujZluUBXIKif735ELcwGk+w56sCXz5gsBs9Arcka/0Ylz7ld8pKigxXZr8V
         +zRIbIWoMLoLxpRofs4+olKks9IbyBJVGGJMTcigRkbJDPoa4HbPRs7yxGWtFXmxeIXF
         DGoRQ8rd5GBN/+anuLs+BUUNLDGynQWxM/7BVnOBU4XGO0k5d/AOiCmxikURT1cOqWb9
         cn17Kd+23pwymYcRJHAe8x1RV4TwaQbDZeVw0FnjTXTPg8Lx3Y3j7YfsKo9m0oW44+zW
         tDBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nym2FNZsKI6bzdnD8xWBI+z7a4zlO5DRya94UNFOEzU=;
        b=QEZOtxp8gko5uDHPSRoQ2GmI9e/CLmjeOzRrz+ve9wpSzVNuKU2AN0c0zjGujFr+pS
         cHBur4rR1xKjOYp2W2H2tTVMzv3EuAH95L110foA953ahuAfHFvrtyfRUsshv/Um/XRz
         1zMXECLclskyrkcp7P9XMmzM8fPIFBcAXXUqvA6VSO5yWX61Bp0WtONe9QD4G7au4zUi
         bmA0zGTIT7mxydeEpPpkX8BJeEFO6h0U0WMXw5NS++1jp5TkVg4iT1C6nifieAUUchn1
         GdzRZ/s3F7ZuLHKbZ7+GE+PR7L41lC1KBC2qG4osCubxBwvCBr6KQJkFWBtan+fPXlZa
         p0JA==
X-Gm-Message-State: AOAM533EbAtL1iBQOMv60Ggz679rIze7sxprlpJO9eEpfaZNBlcfeThP
        oGpeV6jLrFTeSOgL/+NrlT8=
X-Google-Smtp-Source: ABdhPJyfL1yxxuTw34UrDS6c9i/OPSubdGni5m6E/hXGLRgct68WyAxWfgtvbaBr+IGoE+8hUfinLA==
X-Received: by 2002:a17:902:d702:b029:de:7ae2:8e6e with SMTP id w2-20020a170902d702b02900de7ae28e6emr12988300ply.42.1611202211016;
        Wed, 20 Jan 2021 20:10:11 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 3sm4059206pgk.81.2021.01.20.20.10.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 20:10:10 -0800 (PST)
Subject: Re: [PATCH v5 net-next 10/10] net: dsa: felix: perform switch setup
 for tag_8021q
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
References: <20210121023616.1696021-1-olteanv@gmail.com>
 <20210121023616.1696021-11-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bad1e172-a7b7-b578-91c6-afa34cfbfb61@gmail.com>
Date:   Wed, 20 Jan 2021 20:10:07 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210121023616.1696021-11-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/20/2021 6:36 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Unlike sja1105, the only other user of the software-defined tag_8021q.c
> tagger format, the implementation we choose for the Felix DSA switch
> driver preserves full functionality under a vlan_filtering bridge
> (i.e. IP termination works through the DSA user ports under all
> circumstances).
> 
> The tag_8021q protocol just wants:
> - Identifying the ingress switch port based on the RX VLAN ID, as seen
>   by the CPU. We achieve this by using the TCAM engines (which are also
>   used for tc-flower offload) to push the RX VLAN as a second, outer
>   tag, on egress towards the CPU port.
> - Steering traffic injected into the switch from the network stack
>   towards the correct front port based on the TX VLAN, and consuming
>   (popping) that header on the switch's egress.
> 
> A tc-flower pseudocode of the static configuration done by the driver
> would look like this:
> 
> $ tc qdisc add dev <cpu-port> clsact
> $ for eth in swp0 swp1 swp2 swp3; do \
> 	tc filter add dev <cpu-port> egress flower indev ${eth} \
> 		action vlan push id <rxvlan> protocol 802.1ad; \
> 	tc filter add dev <cpu-port> ingress protocol 802.1Q flower
> 		vlan_id <txvlan> action vlan pop \
> 		action mirred egress redirect dev ${eth}; \
> done
> 
> but of course since DSA does not register network interfaces for the CPU
> port, this configuration would be impossible for the user to do. Also,
> due to the same reason, it is impossible for the user to inadvertently
> delete these rules using tc. These rules do not collide in any way with
> tc-flower, they just consume some TCAM space, which is something we can
> live with.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Quite an interesting read.
-- 
Florian
