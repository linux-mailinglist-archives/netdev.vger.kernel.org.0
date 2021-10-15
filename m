Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D4642FD86
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 23:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238708AbhJOViL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 17:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238695AbhJOViL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 17:38:11 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD52C061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 14:36:04 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id gn3so2576489pjb.0
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 14:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MM8qEUXivu5Vx408ObeccNA25B8u584qoW9GHWLKLoQ=;
        b=TN9KWWmRkHtH33uGXLhJTJr/lhSGvCzeqZGKy7HbVgNAph20BAWLoKkM/dYivHSEcw
         jqw2l1m7oNhYRclOoEikxjXb8183VCRmsAwVQwdMnv3VbreZpDh/WBjRqitmM2FH6/gh
         6TWTNAJYCDjEBknwHkbdCnnJf/hVHETuvgvkFo6P8z4KEt/C1ersU6fJLULDkbV9BIxq
         pbug3AlILe2Ule6hMrFBHRMEnfqrt7xbVG9xLG+Hto9fw8h0MBdcby9TTPh5gMpo5Xo/
         GDOoBc7qh2CtuEy78w/egI9QW5rUhFgG0XSpYKCyYcQxSMXRXbAsHw7eqL5f/BP9P8Y/
         xWzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MM8qEUXivu5Vx408ObeccNA25B8u584qoW9GHWLKLoQ=;
        b=wrDq5RqCa4pzwrzUJB65T2TgoA07SorHYUPecvt8zwS6TcAkZOaGSj61yX1J2Dkstk
         tRSCMprKVvQzWh2+gtPc6xJ4GHb2/F0lgeD1mi6ngYOhbfrb5yO80Ovw23cXP88D2blI
         6mzbXMXnsapqSRI5NdYCjttUa5Wi9nDGa/RAQoy4t3wXSFGw/SO4yVLHaSttTPPJJYcc
         ChfQ7yLHLMOTxBCRLstjBlGGKqgsvOkdGQ61SjOAdI8kXwtYX48vWJNC/mt0LbCCItQm
         n0Rt6Qsaw91DyLuampuWjjS9+I5Cnui5lMiQlfKFuw17mHvxRZWCufE1L2ZrabswqcBd
         WUDw==
X-Gm-Message-State: AOAM5325qDamWrSDRrXoMVyJxJl9k/JFznv0G2IErLUJ7vdDRwMDcjom
        p1DPe8yZYYhWm5HV50x7zTpWIg==
X-Google-Smtp-Source: ABdhPJy+aw61au5zIquY9j3oo7h7v4C3VjA1mCGMes/Xxh6syaqcyeBeXPGn5mw6tLGEYfb50ij8ZQ==
X-Received: by 2002:a17:90a:c58e:: with SMTP id l14mr30961486pjt.213.1634333763767;
        Fri, 15 Oct 2021 14:36:03 -0700 (PDT)
Received: from [192.168.0.14] ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id t2sm5643857pjo.4.2021.10.15.14.36.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 14:36:03 -0700 (PDT)
Message-ID: <47ac074a-bf85-a514-00a5-3749e3582099@pensando.io>
Date:   Fri, 15 Oct 2021 14:36:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [RFC net-next 1/6] ethernet: add a helper for assigning port
 addresses
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, idosch@idosch.org,
        f.fainelli@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, bjarni.jonasson@microchip.com,
        linux-arm-kernel@lists.infradead.org, qiangqing.zhang@nxp.com,
        vkochan@marvell.com, tchornyi@marvell.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com
References: <20211015193848.779420-1-kuba@kernel.org>
 <20211015193848.779420-2-kuba@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
In-Reply-To: <20211015193848.779420-2-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/21 12:38 PM, Jakub Kicinski wrote:
> We have 5 drivers which offset base MAC addr by port id.
> Create a helper for them.
>
> This helper takes care of overflows, which some drivers
> did not do, please complain if that's going to break
> anything!
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: jiri@nvidia.com
> CC: idosch@nvidia.com
> CC: lars.povlsen@microchip.com
> CC: Steen.Hegelund@microchip.com
> CC: UNGLinuxDriver@microchip.com
> CC: bjarni.jonasson@microchip.com
> CC: linux-arm-kernel@lists.infradead.org
> CC: qiangqing.zhang@nxp.com
> CC: vkochan@marvell.com
> CC: tchornyi@marvell.com
> CC: vladimir.oltean@nxp.com
> CC: claudiu.manoil@nxp.com
> CC: alexandre.belloni@bootlin.com
> CC: UNGLinuxDriver@microchip.com
> ---
>   include/linux/etherdevice.h | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)
>
> diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
> index 23681c3d3b8a..157f6c7ac9ff 100644
> --- a/include/linux/etherdevice.h
> +++ b/include/linux/etherdevice.h
> @@ -551,6 +551,27 @@ static inline unsigned long compare_ether_header(const void *a, const void *b)
>   #endif
>   }
>   
> +/**
> + * eth_hw_addr_set_port - Generate and assign Ethernet address to a port
> + * @dev: pointer to port's net_device structure
> + * @base_addr: base Ethernet address
> + * @id: offset to add to the base address
> + *
> + * Assign a MAC address to the net_device using a base address and an offset.
> + * Commonly used by switch drivers which need to compute addresses for all
> + * their ports. addr_assign_type is not changed.
> + */
> +static inline void eth_hw_addr_set_port(struct net_device *dev,
> +					const u8 *base_addr, u8 id)

To me, the words "_set_port" imply that you're going to force "id" into 
the byte, overwriting what is already there.  Since this instead is 
adding "id" to the byte, perhaps a better name would include the word 
"offset", maybe like eth_hw_addr_set_port_offset(), to better imply the 
actual operation.

Personally, I think my name suggestion is too long, but it gets my 
thought across.

sln

> +{
> +	u64 u = ether_addr_to_u64(base_addr);
> +	u8 addr[ETH_ALEN];
> +
> +	u += id;
> +	u64_to_ether_addr(u, addr);
> +	eth_hw_addr_set(dev, addr);
> +}
> +
>   /**
>    * eth_skb_pad - Pad buffer to mininum number of octets for Ethernet frame
>    * @skb: Buffer to pad

