Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A895AC003
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 19:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiICRZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 13:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiICRZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 13:25:50 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BEA3ECDA
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 10:25:49 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id r6so3675356qtx.6
        for <netdev@vger.kernel.org>; Sat, 03 Sep 2022 10:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=5uo2VvNIqC/VuePKgb7EZNtUEulmQHaK3W6mVfr7RVQ=;
        b=exc+oYWZOUjRrmYbzETO4sWCuv0OHlDUPhNPug6cckP/2hc+KK3vEOzCF2Pz0DQKCy
         0ZJub0l67mVlg99uiJDirWCZJwKaREz6PvdfwmRHdvb+I9zS5F9jYp5VNaBUrggt9kqC
         Uw/lqVO1VUva3hqRQ5sAcxXaQlaBSRe3b+zHG5qFIKGU0zmIhQ07H94GukjLNEOK5hVP
         aLJp/FRTiTaBuJlZ4Ja660fuvFj9NuL/Ag/G5dC/Rf1bbQ0rDfOp5KzVx/C0/ggEcn07
         jcxD80riyLdsNX3aHmAKQM1XdY5z0eDqcbkC5YjEsMuvYvUOOjrYvz2gIgG03fwYQaBz
         yd1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=5uo2VvNIqC/VuePKgb7EZNtUEulmQHaK3W6mVfr7RVQ=;
        b=XXUPpw/70gA3qsi1ybZEKRsbTSCjlgrk3mWS6h2q1eRBlV923RIdrj+LclEZU/Rgqm
         kgPGW4t/MkQQXuV0OqqP57QAg7ZNrlAw3mAB4Ious6eW8S4JQcGW6Xw5W3TSLBJjSd2R
         fxAPIB/r04h4YMDxfhlIOb2ujqwUZhLD449r51xJkybzqblOI6adheyIriglReatLRoS
         KHEpQtBUKZQJXrfd0C8T9I+d6mS2R1I7m1KRfN2kaE9FZLJX/pUoMDtYluvpqTQQEGsg
         T/hpkQG+ZvkiFj1XoyX/x3jcvu1LDoJKGc1+FNVQfY6/tqzJJMZe2nZsKakf03OQSqWH
         ZvsA==
X-Gm-Message-State: ACgBeo3Y55O+iaikRWqoSR+K/SfhuedfQkQ/CXKsSsK3qycejbFxTltb
        9Oncz7zaTRbbjfm+1tAvT5pFU0G65yE=
X-Google-Smtp-Source: AA6agR5mPbTuKcqejx9YazLO+vRGumEtnsBXPEOC5I53yX5Difp3fzm0QXwYUfOi+6O/M/GEoTEvwA==
X-Received: by 2002:ac8:7d50:0:b0:344:64af:d709 with SMTP id h16-20020ac87d50000000b0034464afd709mr32477354qtb.639.1662225948154;
        Sat, 03 Sep 2022 10:25:48 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id e8-20020ac81308000000b0031d283f4c4dsm3250012qtj.60.2022.09.03.10.25.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Sep 2022 10:25:47 -0700 (PDT)
Message-ID: <a1b21de9-a379-f920-e7d1-07ac7f5a7e96@gmail.com>
Date:   Sat, 3 Sep 2022 10:25:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Print warning only once
Content-Language: en-US
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org
References: <20220830163448.8921-1-kurt@linutronix.de>
 <20220831152628.um4ktfj4upcz7zwq@skbuf> <87v8q8jjgh.fsf@kurt>
 <20220831234329.w7wnxy4u3e5i6ydl@skbuf> <87czcfzkb6.fsf@kurt>
 <20220901113912.wrwmftzrjlxsof7y@skbuf> <87r10sr3ou.fsf@kurt>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <87r10sr3ou.fsf@kurt>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/2022 6:24 AM, Kurt Kanzenbach wrote:
> On Thu Sep 01 2022, Vladimir Oltean wrote:
>> On Thu, Sep 01, 2022 at 08:21:33AM +0200, Kurt Kanzenbach wrote:
>>>> So from Florian's comment above, he was under case (b), different than yours.
>>>> I don't understand why you say that when ACS is set, "the STP frames are
>>>> truncated and the trailer tag is gone". Simply altering the ACS bit
>>>> isn't going to change the determination made by stmmac_rx(). My guess
>>>> based on the current input I have is that it would work fine for you
>>>> (but possibly not for Florian).
>>>
>>> I thought so too. However, altering the ACS Bit didn't help at all.
>>
>> This is curious. Could you dump the Length/Type Field (LT bits 18:16)
>> from the RDES3 for these packets? If ACS does not take effect, it would
>> mean the DWMAC doesn't think they're Length packets I guess? Also, does
>> the Error Summary say anything? In principle, the length of this packet
>> is greater than the EtherType/Length would say, by the size of the tail
>> tag. Not sure how that affects the RX parser.
> 
> That's the point. The RX parser seems to be affected by the tail
> tag. I'll have a look at the packets with ACS feature set.
> 
>>
>>> We could do some measurements e.g., with perf to determine whether
>>> removing the FCS logic has positive or negative effects?
>>
>> Yes, some IP forwarding of 60 byte frames at line rate gigabit or higher
>> should do the trick. Testing with MTU sized packets is probably not
>> going to show much of a difference.
> 
> Well, I don't see much of a difference. However, running iperf3 with
> small packets is nowhere near line rate of 100Mbit/s. Nevertheless, I
> like the following patch more, because it looks cleaner than adding more
> checks to the receive path. It fixes my problem. Florian's use case
> should also work.

LGTM, some suggestions below.

> 
>  From 5a54383167c624a90ba460531fccabbb87d40e51 Mon Sep 17 00:00:00 2001
> From: Kurt Kanzenbach <kurt@linutronix.de>
> Date: Fri, 2 Sep 2022 19:49:52 +0200
> Subject: [PATCH] net: stmmac: Disable automatic FCS/Pad stripping
> 
> The stmmac has the possibility to automatically strip the padding/FCS for IEEE
> 802.3 type frames. This feature is enabled conditionally. Therefore, the stmmac
> receive path has to have a determination logic whether the FCS has to be
> stripped in software or not.
> 
> In fact, for DSA this ACS feature is disabled and the determination logic
> doesn't check for it properly. For instance, when using DSA in combination with
> an older stmmac (pre version 4), the FCS is not stripped by hardware or software
> which is problematic.
> 
> So either add another check for DSA to the fast path or simply disable ACS
> feature completely. The latter approach has been chosen, because most of the
> time the FCS is stripped in software anyway and it removes conditionals from the
> receive fast path.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>   .../net/ethernet/stmicro/stmmac/dwmac100.h    |  2 +-
>   .../net/ethernet/stmicro/stmmac/dwmac1000.h   |  2 +-
>   .../ethernet/stmicro/stmmac/dwmac1000_core.c  |  9 -------
>   .../ethernet/stmicro/stmmac/dwmac100_core.c   |  8 ------
>   .../net/ethernet/stmicro/stmmac/stmmac_main.c | 26 +++----------------
>   5 files changed, 6 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac100.h b/drivers/net/ethernet/stmicro/stmmac/dwmac100.h
> index 35ab8d0bdce7..7ab791c8d355 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac100.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac100.h
> @@ -56,7 +56,7 @@
>   #define MAC_CONTROL_TE		0x00000008	/* Transmitter Enable */
>   #define MAC_CONTROL_RE		0x00000004	/* Receiver Enable */
>   
> -#define MAC_CORE_INIT (MAC_CONTROL_HBD | MAC_CONTROL_ASTP)
> +#define MAC_CORE_INIT (MAC_CONTROL_HBD)
>   
>   /* MAC FLOW CTRL defines */
>   #define MAC_FLOW_CTRL_PT_MASK	0xffff0000	/* Pause Time Mask */
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
> index 3c73453725f9..4296ddda8aaa 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
> @@ -126,7 +126,7 @@ enum inter_frame_gap {
>   #define GMAC_CONTROL_TE		0x00000008	/* Transmitter Enable */
>   #define GMAC_CONTROL_RE		0x00000004	/* Receiver Enable */
>   
> -#define GMAC_CORE_INIT (GMAC_CONTROL_JD | GMAC_CONTROL_PS | GMAC_CONTROL_ACS | \
> +#define GMAC_CORE_INIT (GMAC_CONTROL_JD | GMAC_CONTROL_PS | \
>   			GMAC_CONTROL_BE | GMAC_CONTROL_DCRS)
>   
>   /* GMAC Frame Filter defines */
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
> index fc8759f146c7..35d7c1cb1cf1 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
> @@ -15,7 +15,6 @@
>   #include <linux/crc32.h>
>   #include <linux/slab.h>
>   #include <linux/ethtool.h>
> -#include <net/dsa.h>
>   #include <asm/io.h>
>   #include "stmmac.h"
>   #include "stmmac_pcs.h"
> @@ -24,7 +23,6 @@
>   static void dwmac1000_core_init(struct mac_device_info *hw,
>   				struct net_device *dev)

You should be able to remove the net_device reference here since we do 
not use it anymore after the removal of netdev_uses_dsa() or 
de-referencing of priv.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
