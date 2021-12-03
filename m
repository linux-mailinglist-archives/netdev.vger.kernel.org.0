Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC504467373
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 09:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351318AbhLCIsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 03:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351328AbhLCIsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 03:48:54 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4FAC061757
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 00:45:31 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id bu18so4968918lfb.0
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 00:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hSx51RMOJ0FTpbNjbF8SUJHv2Jt1L4wZn0byvDbwpqw=;
        b=vF1QhrGNoXlmfo+Gg/HioWHmjlt8+4x+C+M765Sk4W5C5OFYMYW9trh22FFQbyWf4D
         BbxipvLIx58URkbPDORYjR0acoTLVfsXA9C1wwy/3OHqC7b1iQv3ChbiKxv49RymEJpW
         oqJn3akpr+srYxImuI/9qcC2HAY69OolUvppbTIRKlBj56eyclKkSMHQTRWFwriYFEgS
         FCogvElrQLVWRw6cJhh2kt8dvClvQ8YFplNS5wOmVW3ut8LlULohBMcU9FuskMXhKjBy
         B6UV7mqxxT06fwVxPcy5GWKJgN013rK28rGGczvVsE1JJm0N62lcz8GdOAwWOwEcD/Gz
         InMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hSx51RMOJ0FTpbNjbF8SUJHv2Jt1L4wZn0byvDbwpqw=;
        b=N0GjhS31J86Dg4X7OFz//trLI/bBfhPxDKonzpzM68S437BKMxyEhQ0b+iWmAozwL8
         cStDZGqEMto/fvKDE/QzrdAkjekEXw2iEcDWpIq0u+FncxFp2hB3UYuiiVomD5zC6JJL
         JQIf78hAMpzRFG0Vl4SvqAWH82Yalx8afUUTCSYYxP0rHJzcnfgJYWjTEcaP+c3qr2XP
         9DXdXuwZEpDdzUN3/FUD4GXyE8/MGdBJx8+HL2ZkysjFI+tqEeaIG7c+UAmw77IlsZp+
         J60rahtjTZnpzapiI3rR4ZgKdEGdEy6kyuUO9nD/IWS1c1mPkEpdwUWzW/pJSfB6kKWu
         hVGw==
X-Gm-Message-State: AOAM531jYuSMeEMUQCcEv/0h/twfWqcUj/cCIBl+ah7Wspe9+8Zf5FgG
        8fdtJA+OtlYDur9cgSznYk34ng==
X-Google-Smtp-Source: ABdhPJxeQssufK3tURdiz+ycvGo9XOJGEiN1TZZMIhqRH1ceM8gOFosx2s1ThPMX8v8le8XBXR4Ffw==
X-Received: by 2002:a19:431b:: with SMTP id q27mr16049380lfa.562.1638521129280;
        Fri, 03 Dec 2021 00:45:29 -0800 (PST)
Received: from [10.0.6.3] (rota.kvaser.com. [195.22.86.90])
        by smtp.gmail.com with ESMTPSA id a7sm283093lfk.233.2021.12.03.00.45.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 00:45:28 -0800 (PST)
Subject: Re: [PATCH v3 2/5] can: kvaser_usb: do not increase tx statistics
 when sending error message frames
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
References: <20211128123734.1049786-1-mailhol.vincent@wanadoo.fr>
 <20211128123734.1049786-3-mailhol.vincent@wanadoo.fr>
 <82ea8723-a234-0dad-ea9f-1b5ccac0b812@kvaser.com>
 <CAMZ6RqKtn-EuSLCTAppzz0THzr7KUYBUBOTHkwhSCzrDyzSzhw@mail.gmail.com>
From:   Jimmy Assarsson <extja@kvaser.com>
Message-ID: <5aed4f5a-cc80-7ad9-2834-a31da53412a5@kvaser.com>
Date:   Fri, 3 Dec 2021 09:45:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAMZ6RqKtn-EuSLCTAppzz0THzr7KUYBUBOTHkwhSCzrDyzSzhw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-03 05:02, Vincent MAILHOL wrote:
> On Fri. 3 Dec 2021 at 08:35, Jimmy Assarsson <extja@kvaser.com> wrote:
>> On 2021-11-28 13:37, Vincent Mailhol wrote:
>>> The CAN error message frames (i.e. error skb) are an interface
>>> specific to socket CAN. The payload of the CAN error message frames
>>> does not correspond to any actual data sent on the wire. Only an error
>>> flag and a delimiter are transmitted when an error occurs (c.f. ISO
>>> 11898-1 section 10.4.4.2 "Error flag").
>>>
>>> For this reason, it makes no sense to increment the tx_packets and
>>> tx_bytes fields of struct net_device_stats when sending an error
>>> message frame because no actual payload will be transmitted on the
>>> wire.
>>>
>>> N.B. Sending error message frames is a very specific feature which, at
>>> the moment, is only supported by the Kvaser Hydra hardware. Please
>>> refer to [1] for more details on the topic.
>>>
>>> [1] https://lore.kernel.org/linux-can/CAMZ6RqK0rTNg3u3mBpZOoY51jLZ-et-J01tY6-+mWsM4meVw-A@mail.gmail.com/t/#u
>>>
>>> CC: Jimmy Assarsson <extja@kvaser.com>
>>> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>>
>> Hi Vincent!
>>
>> Thanks for the patch.
>> There are flags in the TX ACK package, which makes it possible to
>> determine if it was an error frame or not. So we don't need to get
>> the original CAN frame to determine this.
>> I suggest the following change:
> 
> This is a great suggestion. I was not a fan of getting the
> original CAN frame, this TX ACK solves the issue.
> 
>> ---
>>    .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 25 ++++++++++++-------
>>    1 file changed, 16 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
>> b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
>> index 3398da323126..01b076f04e26 100644
>> --- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
>> +++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
>> @@ -295,6 +295,7 @@ struct kvaser_cmd {
>>    #define KVASER_USB_HYDRA_CF_FLAG_OVERRUN      BIT(1)
>>    #define KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME BIT(4)
>>    #define KVASER_USB_HYDRA_CF_FLAG_EXTENDED_ID  BIT(5)
>> +#define KVASER_USB_HYDRA_CF_FLAG_TX_ACK        BIT(6)
>>    /* CAN frame flags. Used in ext_rx_can and ext_tx_can */
>>    #define KVASER_USB_HYDRA_CF_FLAG_OSM_NACK     BIT(12)
>>    #define KVASER_USB_HYDRA_CF_FLAG_ABL          BIT(13)
>> @@ -1112,7 +1113,9 @@ static void kvaser_usb_hydra_tx_acknowledge(const
>> struct kvaser_usb *dev,
>>          struct kvaser_usb_tx_urb_context *context;
>>          struct kvaser_usb_net_priv *priv;
>>          unsigned long irq_flags;
>> +       unsigned int len;
>>          bool one_shot_fail = false;
>> +       bool is_err_frame = false;
>>          u16 transid = kvaser_usb_hydra_get_cmd_transid(cmd);
>>
>>          priv = kvaser_usb_hydra_net_priv_from_cmd(dev, cmd);
>> @@ -1131,24 +1134,28 @@ static void
>> kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
>>                          kvaser_usb_hydra_one_shot_fail(priv, cmd_ext);
>>                          one_shot_fail = true;
>>                  }
>> -       }
>> -
>> -       context = &priv->tx_contexts[transid % dev->max_tx_urbs];
>> -       if (!one_shot_fail) {
>> -               struct net_device_stats *stats = &priv->netdev->stats;
>> -
>> -               stats->tx_packets++;
>> -               stats->tx_bytes += can_fd_dlc2len(context->dlc);
>> +               if (flags & KVASER_USB_HYDRA_CF_FLAG_TX_ACK &&
>> +                   flags & KVASER_USB_HYDRA_CF_FLAG_ERROR_FRAME)
>> +                        is_err_frame = true;
> 
> Nitpick, but I prefer to write:
> 
> +                is_err_frame = flags & KVASER_USB_HYDRA_CF_FLAG_TX_ACK &&
> +                               flags & KVASER_USB_HYDRA_CF_FLAG_ERROR_FRAME;
> 

Agree, I also prefer this.

>>          }
>>
>>          spin_lock_irqsave(&priv->tx_contexts_lock, irq_flags);
>>
>> -       can_get_echo_skb(priv->netdev, context->echo_index, NULL);
>> +       context = &priv->tx_contexts[transid % dev->max_tx_urbs];
>> +       len = can_get_echo_skb(priv->netdev, context->echo_index, NULL);
> 
> This line is related to the tx RTR. I will rebase this into
> "can: do not increase rx_bytes statistics for RTR frames" (patch 4/5).
> 
>> +
>>          context->echo_index = dev->max_tx_urbs;
>>          --priv->active_tx_contexts;
>>          netif_wake_queue(priv->netdev);
>>
>>          spin_unlock_irqrestore(&priv->tx_contexts_lock, irq_flags);
>> +
>> +       if (!one_shot_fail && !is_err_frame) {
>> +               struct net_device_stats *stats = &priv->netdev->stats;
>> +
>> +               stats->tx_packets++;
>> +               stats->tx_bytes += len;
>> +       }
> 
> Same here, there is no need anymore to move this block *in this
> patch*, will rebase it.

Agree.

>>    }
>>
>>    static void kvaser_usb_hydra_rx_msg_std(const struct kvaser_usb *dev,
> 
> 
> This patch ("can: kvaser_usb: do not increase tx statistics when
> sending error message frames") will become:
> 
> diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> index 3398da323126..75009d38f8e3 100644
> --- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> +++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> @@ -295,6 +295,7 @@ struct kvaser_cmd {
>   #define KVASER_USB_HYDRA_CF_FLAG_OVERRUN       BIT(1)
>   #define KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME  BIT(4)
>   #define KVASER_USB_HYDRA_CF_FLAG_EXTENDED_ID   BIT(5)
> +#define KVASER_USB_HYDRA_CF_FLAG_TX_ACK                BIT(6)
>   /* CAN frame flags. Used in ext_rx_can and ext_tx_can */
>   #define KVASER_USB_HYDRA_CF_FLAG_OSM_NACK      BIT(12)
>   #define KVASER_USB_HYDRA_CF_FLAG_ABL           BIT(13)
> @@ -1113,6 +1114,7 @@ static void
> kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
>          struct kvaser_usb_net_priv *priv;
>          unsigned long irq_flags;
>          bool one_shot_fail = false;
> +       bool is_err_frame = false;
>          u16 transid = kvaser_usb_hydra_get_cmd_transid(cmd);
> 
>          priv = kvaser_usb_hydra_net_priv_from_cmd(dev, cmd);
> @@ -1131,10 +1133,13 @@ static void
> kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
>                          kvaser_usb_hydra_one_shot_fail(priv, cmd_ext);
>                          one_shot_fail = true;
>                  }
> +
> +               is_err_frame = flags & KVASER_USB_HYDRA_CF_FLAG_TX_ACK &&
> +                              flags & KVASER_USB_HYDRA_CF_FLAG_ERROR_FRAME;
>          }
> 
>          context = &priv->tx_contexts[transid % dev->max_tx_urbs];
> -       if (!one_shot_fail) {
> +       if (!one_shot_fail && !is_err_frame) {
>                  struct net_device_stats *stats = &priv->netdev->stats;
> 
>                  stats->tx_packets++;
> 
> 
> And patch 5/5 ("can: do not increase tx_bytes
> statistics for RTR frames") becomes:
> 
> diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> index 75009d38f8e3..2cb35bd162a4 100644
> --- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> +++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> @@ -1113,6 +1113,7 @@ static void
> kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
>          struct kvaser_usb_tx_urb_context *context;
>          struct kvaser_usb_net_priv *priv;
>          unsigned long irq_flags;
> +       unsigned int len;
>          bool one_shot_fail = false;
>          bool is_err_frame = false;
>          u16 transid = kvaser_usb_hydra_get_cmd_transid(cmd);
> @@ -1139,21 +1140,23 @@ static void
> kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
>          }
> 
>          context = &priv->tx_contexts[transid % dev->max_tx_urbs];
> -       if (!one_shot_fail && !is_err_frame) {
> -               struct net_device_stats *stats = &priv->netdev->stats;
> -
> -               stats->tx_packets++;
> -               stats->tx_bytes += can_fd_dlc2len(context->dlc);
> -       }
> 
>          spin_lock_irqsave(&priv->tx_contexts_lock, irq_flags);
> 
> -       can_get_echo_skb(priv->netdev, context->echo_index, NULL);
> +       len = can_get_echo_skb(priv->netdev, context->echo_index, NULL);
>          context->echo_index = dev->max_tx_urbs;
>          --priv->active_tx_contexts;
>          netif_wake_queue(priv->netdev);
> 
>          spin_unlock_irqrestore(&priv->tx_contexts_lock, irq_flags);
> +
> +       if (!one_shot_fail && !is_err_frame) {
> +               struct net_device_stats *stats = &priv->netdev->stats;
> +
> +               stats->tx_packets++;
> +               stats->tx_bytes += len;
> +       }
>   }
> 
> Does this look good to you? If so, can I add these tags to patch 2/5?
> Co-developed-by: Jimmy Assarsson <extja@kvaser.com>
> Signed-off-by: Jimmy Assarsson <extja@kvaser.com>

Yes.

> Also, can I add your tested-by to patches 1/5, 4/5 and 5/5?
> Tested-by: Jimmy Assarsson <extja@kvaser.com>

Yes.

> Yours sincerely,
> Vincent Mailhol

Thanks!

Best regards,
jimmy
