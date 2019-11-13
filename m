Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA0E5FB9DF
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfKMUa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:30:58 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37982 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfKMUa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:30:57 -0500
Received: by mail-wm1-f68.google.com with SMTP id z19so3496255wmk.3;
        Wed, 13 Nov 2019 12:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ARc1c4NWQIkAXUbZl2g6F4/UfLbb0UiIjA2X2CNwbfw=;
        b=DPgZkNtV9TySsLprAz9X6cfEcuJ1iWz3TZ7z/0WQsAiJ2TB6q1xgvhAzMKPUNCz8IW
         mEbcGGes20jeyJKkeBoNtNvJBZHgKBPMGcONrhxb7c6NcVMLMWKpM4nQTfKQkFy+I1AE
         mnyMsNcpMBNFIYh1SLUzfK2FPP9+DoD1o5hlHPIDn/eyu1bZiI8SZ3lHoldiOE9xiWMt
         oVlBZjDEoUsIYH4ixsgARQgYOqQLvS+a6kjGR6gG2Li8IynUyu+8Urgqkh8X7XOBO89q
         OOIeA4orxlj7IuUysG/toBtd9rIezQkXeVg6EevdVtMrsQMhGeGEUsLcwVUwhCss6Cwo
         08YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ARc1c4NWQIkAXUbZl2g6F4/UfLbb0UiIjA2X2CNwbfw=;
        b=Mwz8GW9ldRdAUXRLiEwCWn9InFSofDgviJ07rAo/fAJof8lgEagWi/gBjYy3yb8cDw
         L6dhGK57wC+QWIfMVNB+9xwe8wLa7sYdsPsp2ExDJEHlvxbZgDsJ0Du6dozxUFIMzXM9
         isvtb+LMD7K2R6x+ifPPKoB0q6g7R5H6hm4foLg6ZtjlUHbvvmViBhDC+CYx/y62mhiT
         qXv3NUI7+ViAm3a7y7BZeDFfU+xgD3cGrajm3EyhvDl3IhPhh0i54rQDTNjzYhQxWqPg
         a7Q/U6xHwVCbfMO7qf+g/Ti+PGobA2XYw1rquFxSxcnPM4ImZk5zxSplVIFOjdXhOor0
         bLyQ==
X-Gm-Message-State: APjAAAX/+34zThfA+Kn1SqieyDcOYaOm+WDwvBlSQ4Xebf0WQfCR6MVL
        7LEO2aovQBoX/36/A1pcyJI=
X-Google-Smtp-Source: APXvYqwsZMxYcPT1O5TmHUKvHDe4kDMdOAPEEEe/9ZhN5uqEYQ2xOTAh4KFPPpjTJYByeQgzjrNzuA==
X-Received: by 2002:a1c:48c4:: with SMTP id v187mr4605576wma.27.1573677055550;
        Wed, 13 Nov 2019 12:30:55 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:f8b2:b0b6:7d0e:ced4? (p200300EA8F2D7D00F8B2B0B67D0ECED4.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:f8b2:b0b6:7d0e:ced4])
        by smtp.googlemail.com with ESMTPSA id q17sm3436655wmj.12.2019.11.13.12.30.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Nov 2019 12:30:55 -0800 (PST)
Subject: Re: [PATCH] [RFC] r8169: check for valid MAC before clobbering
To:     Brian Norris <briannorris@chromium.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Chun-Hao Lin <hau@realtek.com>
References: <20191113005816.37084-1-briannorris@chromium.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <32422b2d-6cab-3ea2-aca3-3e74d68599a3@gmail.com>
Date:   Wed, 13 Nov 2019 21:30:42 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191113005816.37084-1-briannorris@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.11.2019 01:58, Brian Norris wrote:
> I have some old systems with RTL8168g Ethernet, where the BIOS (based on
> Coreboot) programs the MAC address into the MAC0 registers (at offset
> 0x0 and 0x4). The relevant Coreboot source is publicly available here:
> 
> https://review.coreboot.org/cgit/coreboot.git/tree/src/mainboard/google/jecht/lan.c?h=4.10#n139
> 
> (The BIOS is built off a much older branch, but the code is effectively
> the same.)
> 
> Note that this was apparently the recommended solution in an application
> note at the time (I have a copy, but it's not marked for redistribution
> :( ), with no mention of the method used in rtl_read_mac_address().
> 
The application note refers to RTL8105e which is quite different from
RTL8168g. For RTL8168g the BIOS has to write the MAC to the respective
GigaMAC registers, see rtl_read_mac_address for these registers.

If recompiling the BIOS isn't an option, then easiest should be to
change the MAC after boot with "ifconfig" or "ip" command.

> The result is that ever since commit 89cceb2729c7 ("r8169:add support
> more chips to get mac address from backup mac address register"), my MAC
> address changes to use an address I never intended.
> 
> Unfortunately, these commits don't really provide any documentation, and
> I'm not sure when the recommendation actually changed. So I'm sending
> this as RFC, in case I can get any tips from Realtek on how to avoid
> breaking compatibility like this.
> 
> I'll freely admit that the devices in question are currently pinned to
> an ancient kernel. We're only recently testing newer kernels on these
> devices, which brings me here.
> 
> I'll also admit that I don't have much means to test this widely, and
> I'm not sure what implicit behaviors other systems were depending on
> along the way.
> 
> Fixes: 89cceb2729c7 ("r8169:add support more chips to get mac address from backup mac address register")
> Fixes: 6e1d0b898818 ("r8169:add support for RTL8168H and RTL8107E")
> Cc: Chun-Hao Lin <hau@realtek.com>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index c4e961ea44d5..94067cf30514 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -7031,11 +7031,14 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
>  	if (!rc)
>  		goto done;
>  
> -	rtl_read_mac_address(tp, mac_addr);
> +	/* Check first to see if (e.g.) bootloader already programmed
> +	 * something.
> +	 */
> +	rtl_read_mac_from_reg(tp, mac_addr, MAC0);
>  	if (is_valid_ether_addr(mac_addr))
>  		goto done;
>  
> -	rtl_read_mac_from_reg(tp, mac_addr, MAC0);
> +	rtl_read_mac_address(tp, mac_addr);
>  	if (is_valid_ether_addr(mac_addr))
>  		goto done;
>  
> 

