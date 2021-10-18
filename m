Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B399C432957
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbhJRV5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhJRV5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 17:57:03 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92DAC06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 14:54:51 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so448534pjc.3
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 14:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8xH3XSAR7udht232w8mkdA/G0f8peO0K4PRCSdaMeiI=;
        b=mmESebPE5SQ5BfKdxSRAj7ZXqSKxZnG9CHzlWtWw42ajOSoNPX7gGQOJI3UygPkSkh
         lT9JZVnPzNYWQ6LX3Jy/30HhCNv6UkFrmVIgNHsi8qwFAJpkrlZQPWE+yO4Z1LFYYoiX
         kj/NLN2VUhRbQWLEwlwtO/GUMSlSbtidkyyWFyWIPRXJnqh19xrT7FJVOtCg0Ho/m+qR
         Mf8COd8n+vk2eIINwfILIFnq5GpmXgWIY51sF0yLPrp0zPNq2j7lGW5NJwyNZpLBDb11
         /3hSa8ZDgKafbiY/xMdCIveLuBNV6FztN0QwKj4XXgSQlGGlJUn47Kip+0KeFZbzLxuo
         G9iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8xH3XSAR7udht232w8mkdA/G0f8peO0K4PRCSdaMeiI=;
        b=iib38ibMs6IpoPQ+Ib0YlPjJLSIv5raGC9zfTTWWtvyaT2M2Ci812hfV8eewF/Qp8J
         8yPutppEuJpClKifbhe1ZKlUs2RJlsKj5mI9RTzcTIe0usmIl8pZT/gGsAAZ7FexSj+O
         uxUt5nk3SXxVFP9BUoL3QRWTuqHxLwUimuWCbo7lyVgLP9ESUuMStKkCUIBX2VBogWmV
         eaU6/Rlp4QiZKxgCLDNXtSCngHSA+NaHFyF5vfGY8mIGygqANJKYHIlqB4lsKUShFrFK
         lPQPSDaT557nKB493c/ugB+de6gA0bXfQHnebiWQMYcxhLzKimP66ZxFLAArHk/CxKMs
         x0sA==
X-Gm-Message-State: AOAM530rctzWRPfIqpItuY9bBSEDp/dFUgaV8Lw0qxuCA09XYwk/eajK
        UOGO71+pD75GRf+u71nvSwqelQ==
X-Google-Smtp-Source: ABdhPJzWsCWpjvse5SFvrzA6g1FIc0f/kB/7FDbDuCLAwyrsSwfJduPMui1CqEUIenRJg8ygNgULog==
X-Received: by 2002:a17:902:7616:b0:13f:354a:114f with SMTP id k22-20020a170902761600b0013f354a114fmr30554203pll.8.1634594091236;
        Mon, 18 Oct 2021 14:54:51 -0700 (PDT)
Received: from [192.168.0.14] ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id j12sm13944802pff.127.2021.10.18.14.54.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 14:54:50 -0700 (PDT)
Message-ID: <33fba14b-01cb-8644-7678-a0f12d9cf499@pensando.io>
Date:   Mon, 18 Oct 2021 14:54:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH net-next 1/6] ethernet: add a helper for assigning port
 addresses
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, f.fainelli@gmail.com
References: <20211018211007.1185777-1-kuba@kernel.org>
 <20211018211007.1185777-2-kuba@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
In-Reply-To: <20211018211007.1185777-2-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/21 2:10 PM, Jakub Kicinski wrote:
> We have 5 drivers which offset base MAC addr by port id.
> Create a helper for them.
>
> This helper takes care of overflows, which some drivers
> did not do, please complain if that's going to break
> anything!
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Shannon Nelson <snelson@pensando.io>


> --
>   - eth_hw_addr_set_port() -> eth_hw_addr_gen()
>   - id u8 -> unsigned int
> ---
>   include/linux/etherdevice.h | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)
>
> diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
> index 23681c3d3b8a..2ad71cc90b37 100644
> --- a/include/linux/etherdevice.h
> +++ b/include/linux/etherdevice.h
> @@ -551,6 +551,27 @@ static inline unsigned long compare_ether_header(const void *a, const void *b)
>   #endif
>   }
>   
> +/**
> + * eth_hw_addr_gen - Generate and assign Ethernet address to a port
> + * @dev: pointer to port's net_device structure
> + * @base_addr: base Ethernet address
> + * @id: offset to add to the base address
> + *
> + * Generate a MAC address using a base address and an offset and assign it
> + * to a net_device. Commonly used by switch drivers which need to compute
> + * addresses for all their ports. addr_assign_type is not changed.
> + */
> +static inline void eth_hw_addr_gen(struct net_device *dev, const u8 *base_addr,
> +				   unsigned int id)
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

