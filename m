Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3DF3E91F6
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 14:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhHKMyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 08:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhHKMye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 08:54:34 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99826C061765;
        Wed, 11 Aug 2021 05:54:10 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id k5-20020a05600c1c85b02902e699a4d20cso1912623wms.2;
        Wed, 11 Aug 2021 05:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3wgg2UGdWzdwbk5sq1oBBKBQ+N9B59dfNQ5CdIWO8iY=;
        b=LYnaX/Lq/q2JOLaZpHmUU3z/2o/LEr+3kzB+LxE43SeQcAWteCEzgtvKm5dIBjXW0u
         H4tyuM+ZCMZjgNlK/lYBFYyB+fvVesI1CbYv0vhnn75OgunIAw+/WP13pr0myzz6tuZi
         gUuHXj6p3zg9LL8RUd5E49xIb1GdW2JjPQDmCrNXvg4lLe1cm0kAfEWCR/EjXVLRxObr
         Tlf0qFMIJbBJpjKQYyxKprgZ6FM+nDA8REdhjTJ4BGRGoifFOEQ6gY4xmwy0pA42Ny7r
         essuoxQe0xK/xbUqFwy3HYgfkAWBS7tsG3N9XCuN+1IHfiMjcP+wdV7CoimE+7C9mTpM
         fQsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3wgg2UGdWzdwbk5sq1oBBKBQ+N9B59dfNQ5CdIWO8iY=;
        b=rTRoAYn6FW0KXFXZVXIlmEgYaCy2K5CCzUGhHpjpOLFpumzQxvTL1Lr5g5PRYnPByZ
         Gf6YdkXZkQZDx4gZlg14rXPbV7pvONVGncHODVAzVEkUs0CifV9KM1bxxWJh+81jhpKk
         BFH4UkE/DvlwR+KvG7P1W7/HUdq8qaxVImLhsfd5CBBg1JOH21xcxfuhzamkmlz6oLGk
         4IlSBgksey66tl23QCkVNd0uZg1WKivhI2gC18VGM9nxPvH/I/xUG0oAKuygS/MrGbPu
         HKtBErVgC/5WErs+LOmIGnRCSbgfBkbxv4diPTqY6ai+M/dw2Chef7UO9qlKYZkNCN1l
         8EtA==
X-Gm-Message-State: AOAM531Gl4eazdZfK25jeDw8w+fuv+UZ06g0zo7waLkLCA8JMZkdOHHi
        SiNI0vu5l9qICRiUYsRQxNk=
X-Google-Smtp-Source: ABdhPJzj3nFgLsSCGT54RwWNTKYG0fyo2AXdyYE0uH9HbzNetPVAZXNSZHYKLOGCiqXn/z2y3gOGjg==
X-Received: by 2002:a05:600c:21d7:: with SMTP id x23mr9706467wmj.10.1628686449267;
        Wed, 11 Aug 2021 05:54:09 -0700 (PDT)
Received: from [10.0.0.18] ([37.165.193.81])
        by smtp.gmail.com with ESMTPSA id c15sm27100616wrw.93.2021.08.11.05.54.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 05:54:08 -0700 (PDT)
Subject: Re: [PATCH net-next] stmmac: align RX buffers
To:     Thierry Reding <thierry.reding@gmail.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Drew Fustini <drew@beagleboard.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jon Hunter <jonathanh@nvidia.com>,
        Will Deacon <will@kernel.org>
References: <20210614022504.24458-1-mcroce@linux.microsoft.com>
 <871r71azjw.wl-maz@kernel.org> <YROmOQ+4Kqukgd6z@orome.fritz.box>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <202417ef-f8ae-895d-4d07-1f9f3d89b4a4@gmail.com>
Date:   Wed, 11 Aug 2021 14:53:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YROmOQ+4Kqukgd6z@orome.fritz.box>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/11/21 12:28 PM, Thierry Reding wrote:
> On Tue, Aug 10, 2021 at 08:07:47PM +0100, Marc Zyngier wrote:
>> Hi all,
>>
>> [adding Thierry, Jon and Will to the fun]
>>
>> On Mon, 14 Jun 2021 03:25:04 +0100,
>> Matteo Croce <mcroce@linux.microsoft.com> wrote:
>>>
>>> From: Matteo Croce <mcroce@microsoft.com>
>>>
>>> On RX an SKB is allocated and the received buffer is copied into it.
>>> But on some architectures, the memcpy() needs the source and destination
>>> buffers to have the same alignment to be efficient.
>>>
>>> This is not our case, because SKB data pointer is misaligned by two bytes
>>> to compensate the ethernet header.
>>>
>>> Align the RX buffer the same way as the SKB one, so the copy is faster.
>>> An iperf3 RX test gives a decent improvement on a RISC-V machine:
>>>
>>> before:
>>> [ ID] Interval           Transfer     Bitrate         Retr
>>> [  5]   0.00-10.00  sec   733 MBytes   615 Mbits/sec   88             sender
>>> [  5]   0.00-10.01  sec   730 MBytes   612 Mbits/sec                  receiver
>>>
>>> after:
>>> [ ID] Interval           Transfer     Bitrate         Retr
>>> [  5]   0.00-10.00  sec  1.10 GBytes   942 Mbits/sec    0             sender
>>> [  5]   0.00-10.00  sec  1.09 GBytes   940 Mbits/sec                  receiver
>>>
>>> And the memcpy() overhead during the RX drops dramatically.
>>>
>>> before:
>>> Overhead  Shared O  Symbol
>>>   43.35%  [kernel]  [k] memcpy
>>>   33.77%  [kernel]  [k] __asm_copy_to_user
>>>    3.64%  [kernel]  [k] sifive_l2_flush64_range
>>>
>>> after:
>>> Overhead  Shared O  Symbol
>>>   45.40%  [kernel]  [k] __asm_copy_to_user
>>>   28.09%  [kernel]  [k] memcpy
>>>    4.27%  [kernel]  [k] sifive_l2_flush64_range
>>>
>>> Signed-off-by: Matteo Croce <mcroce@microsoft.com>
>>
>> This patch completely breaks my Jetson TX2 system, composed of 2
>> Nvidia Denver and 4 Cortex-A57, in a very "funny" way.
>>
>> Any significant amount of traffic result in all sort of corruption
>> (ssh connections get dropped, Debian packages downloaded have the
>> wrong checksums) if any Denver core is involved in any significant way
>> (packet processing, interrupt handling). And it is all triggered by
>> this very change.
>>
>> The only way I have to make it work on a Denver core is to route the
>> interrupt to that particular core and taskset the workload to it. Any
>> other configuration involving a Denver CPU results in some sort of
>> corruption. On their own, the A57s are fine.
>>
>> This smells of memory ordering going really wrong, which this change
>> would expose. I haven't had a chance to dig into the driver yet (it
>> took me long enough to bisect it), but if someone points me at what is
>> supposed to synchronise the DMA when receiving an interrupt, I'll have
>> a look.
> 
> I recall that Jon was looking into a similar issue recently, though I
> think the failure mode was slightly different. I also vaguely recall
> that CPU frequency was impacting this to some degree (lower CPU
> frequencies would increase the chances of this happening).
> 
> Jon's currently out of office, but let me try and dig up the details
> on this.
> 
> Thierry
> 
>>
>> Thanks,
>>
>> 	M.
>>
>>> ---
>>>  drivers/net/ethernet/stmicro/stmmac/stmmac.h | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>>> index b6cd43eda7ac..04bdb3950d63 100644
>>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
>>> @@ -338,9 +338,9 @@ static inline bool stmmac_xdp_is_enabled(struct stmmac_priv *priv)
>>>  static inline unsigned int stmmac_rx_offset(struct stmmac_priv *priv)
>>>  {
>>>  	if (stmmac_xdp_is_enabled(priv))
>>> -		return XDP_PACKET_HEADROOM;
>>> +		return XDP_PACKET_HEADROOM + NET_IP_ALIGN;
>>>  
>>> -	return 0;
>>> +	return NET_SKB_PAD + NET_IP_ALIGN;
>>>  }
>>>  
>>>  void stmmac_disable_rx_queue(struct stmmac_priv *priv, u32 queue);
>>> -- 
>>> 2.31.1
>>>
>>>
>>
>> -- 
>> Without deviation from the norm, progress is not possible.

Are you sure you do not need to adjust stmmac_set_bfsize(), 
stmmac_rx_buf1_len() and stmmac_rx_buf2_len() ?

Presumably DEFAULT_BUFSIZE also want to be increased by NET_SKB_PAD

Patch for stmmac_rx_buf1_len() :

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 7b8404a21544cf29668e8a14240c3971e6bce0c3..041a74e7efca3436bfe3e17f972dd156173957a9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4508,12 +4508,12 @@ static unsigned int stmmac_rx_buf1_len(struct stmmac_priv *priv,
 
        /* First descriptor, not last descriptor and not split header */
        if (status & rx_not_ls)
-               return priv->dma_buf_sz;
+               return priv->dma_buf_sz - NET_SKB_PAD - NET_IP_ALIGN;
 
        plen = stmmac_get_rx_frame_len(priv, p, coe);
 
        /* First descriptor and last descriptor and not split header */
-       return min_t(unsigned int, priv->dma_buf_sz, plen);
+       return min_t(unsigned int, priv->dma_buf_sz - NET_SKB_PAD - NET_IP_ALIGN, plen);
 }
 
 static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,


