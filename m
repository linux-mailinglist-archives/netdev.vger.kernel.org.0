Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66647460586
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 10:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357076AbhK1Jy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 04:54:28 -0500
Received: from mxout04.lancloud.ru ([45.84.86.114]:43826 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357155AbhK1Jw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 04:52:28 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru F25E320CB23A
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Message-ID: <c3af6d99-7876-a704-b132-7c0d82b7fe8e@omp.ru>
Date:   Sun, 28 Nov 2021 12:49:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH AUTOSEL 5.15 23/39] net: usb: r8152: Add MAC passthrough
 support for more Lenovo Docks
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     Aaron Ma <aaron.ma@canonical.com>,
        "David S . Miller" <davem@davemloft.net>, <kuba@kernel.org>,
        <hayeswang@realtek.com>, <tiwai@suse.de>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
 <20211126023156.441292-23-sashal@kernel.org>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
In-Reply-To: <20211126023156.441292-23-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 26.11.2021 5:31, Sasha Levin wrote:

> From: Aaron Ma <aaron.ma@canonical.com>
> 
> [ Upstream commit f77b83b5bbab53d2be339184838b19ed2c62c0a5 ]
> 
> Like ThinkaPad Thunderbolt 4 Dock, more Lenovo docks start to use the original
> Realtek USB ethernet chip ID 0bda:8153.
> 
> Lenovo Docks always use their own IDs for usb hub, even for older Docks.
> If parent hub is from Lenovo, then r8152 should try MAC passthrough.
> Verified on Lenovo TBT3 dock too.
> 
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/usb/r8152.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index f329e39100a7d..d3da350777a4d 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -9603,12 +9603,9 @@ static int rtl8152_probe(struct usb_interface *intf,
>   		netdev->hw_features &= ~NETIF_F_RXCSUM;
>   	}
>   
> -	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO) {
> -		switch (le16_to_cpu(udev->descriptor.idProduct)) {
> -		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
> -		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
> -			tp->lenovo_macpassthru = 1;
> -		}
> +	if (udev->parent &&
> +			le16_to_cpu(udev->parent->descriptor.idVendor) == VENDOR_ID_LENOVO) {
> +		tp->lenovo_macpassthru = 1;
>   	}

    {} not needed anymore, please remove 'em.

[...]

MBR, Sergey
