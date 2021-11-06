Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F066446C1C
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 03:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbhKFCxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 22:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbhKFCx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 22:53:29 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207C7C061570;
        Fri,  5 Nov 2021 19:50:49 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id g125so17513497oif.9;
        Fri, 05 Nov 2021 19:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dZtYE3HC/eYc7zgbZB9IjEe7G001W/xCeXsiw8SwQcg=;
        b=ezmw88IEXL+cmCKKYXGRzYlA9Z6Ceea3oTnejVH3MOZubcgyBH3Lsw9dXjCBZjCxs+
         iDm5LF7u43bbvuwRidGOSlLISIiKgUGD4MdvNooHxd/AqlDYvaf3ukX3tDafT/rbW6Dz
         sFMBi5ozG1ISHJvHSs9oFag4y268QfrNJENWM4R0JFkqRqq22U7hZ6haDSyo3m4fkGK7
         +k2UgRoexPeIeOFhNMcLtuXrp38VUsQfjuh/imOilc2UbnX13Cg2up4gWScrzdsSnPfQ
         NXOKijNc9uH/ene9/Rx8NNV+tYeNNT35GTFXKPo8DhffBz+nGUDnt9NivhvDW6RUAem9
         hjCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dZtYE3HC/eYc7zgbZB9IjEe7G001W/xCeXsiw8SwQcg=;
        b=w4xePMKpGLAJYQ5otpUg8uVMbV0kv59ss1BihrQMV5wAmodI6+VqGz85s9v1ky3iMf
         Qi6TaTgyU3M1kobk+u9MpzHg36w0nEANYScHqcGeAH44qcGVB3XBxj7gCB287asbbGJy
         rfesFKDVEhXl5o0B0zrqK3ioQ+cGUw6VFkxwOnkV3wxLMrV/ItFz/8B4BVh0PobZjGOo
         BZ4veIM/FVD8Ms4Cu/BiVLNrl3ielrLr3RmfyUJS3ioCKxuo4gGCwIsknGCiijXC8w5n
         zG5IBLgf3BLYT3AEKuF8aM0fZvlRjMLZvYM42a1bp1YQdNJmj6itc2TNZQZm6rRIOZ/3
         F4Fw==
X-Gm-Message-State: AOAM5323SdVLHWp+fDVV6T/e8Uxte1EJIq8ONzNCxs6qfU6XjOz/ysUC
        F0nM8sBwP5myfoCdd4v+zXg=
X-Google-Smtp-Source: ABdhPJx+YyZ2z1i6SjIG8i1NJbtgm+G/sBCfNKy9mOk6nv4LcPNs23N/Za4M/46oiAhAtxuTmFyfEQ==
X-Received: by 2002:a54:4e97:: with SMTP id c23mr24848590oiy.153.1636167048433;
        Fri, 05 Nov 2021 19:50:48 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:a892:6224:ce6d:2f10? ([2600:1700:dfe0:49f0:a892:6224:ce6d:2f10])
        by smtp.gmail.com with ESMTPSA id d13sm3112786otc.2.2021.11.05.19.50.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 19:50:48 -0700 (PDT)
Message-ID: <4f4e28f9-8d1e-f2e9-aa0c-37b2c4cd8e8a@gmail.com>
Date:   Fri, 5 Nov 2021 19:50:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH 6/7] net: dsa: b53: Add logic for TX timestamping
Content-Language: en-US
To:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-7-martin.kaistra@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211104133204.19757-7-martin.kaistra@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/2021 6:32 AM, Martin Kaistra wrote:
> In order to get the switch to generate a timestamp for a transmitted
> packet, we need to set the TS bit in the BRCM tag. The switch will then
> create a status frame, which gets send back to the cpu.
> In b53_port_txtstamp() we put the skb into a waiting position.
> 
> When a status frame is received, we extract the timestamp and put the time
> according to our timecounter into the waiting skb. When
> TX_TSTAMP_TIMEOUT is reached and we have no means to correctly get back
> a full timestamp, we cancel the process.
> 
> As the status frame doesn't contain a reference to the original packet,
> only one packet with timestamp request can be sent at a time.
> 
> Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
> ---

[snip]

> +static long b53_hwtstamp_work(struct ptp_clock_info *ptp)
> +{
> +	struct b53_device *dev =
> +		container_of(ptp, struct b53_device, ptp_clock_info);
> +	struct dsa_switch *ds = dev->ds;
> +	int i;
> +
> +	for (i = 0; i < ds->num_ports; i++) {
> +		struct b53_port_hwtstamp *ps;
> +
> +		if (!dsa_is_user_port(ds, i))
> +			continue;

Can you also check on !dsa_port_is_unused()?

[snip]

>   #endif
> diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
> index 85dc47c22008..53cd0345df1b 100644
> --- a/net/dsa/tag_brcm.c
> +++ b/net/dsa/tag_brcm.c
> @@ -8,6 +8,7 @@
>   #include <linux/dsa/brcm.h>
>   #include <linux/etherdevice.h>
>   #include <linux/list.h>
> +#include <linux/ptp_classify.h>
>   #include <linux/slab.h>
>   #include <linux/dsa/b53.h>
>   
> @@ -85,9 +86,14 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
>   					unsigned int offset)
>   {
>   	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	struct b53_device *b53_dev = dp->ds->priv;
> +	unsigned int type = ptp_classify_raw(skb);
>   	u16 queue = skb_get_queue_mapping(skb);
> +	struct b53_port_hwtstamp *ps;
>   	u8 *brcm_tag;
>   
> +	ps = &b53_dev->ports[dp->index].port_hwtstamp;

The dsa_port structure as a priv member which would be well suited to 
store &b53_dev->ports[dp->index].port_hwtstamp and avoid traversing 
multiple layers of objects here. You don't need to need b53_device at 
all, and even if you did, you could easily add a back pointer to it in 
port_hwstamp.

This applies below as well in brcm_tag_rcv_ll

[snip]

> +
>   /* Frames with this tag have one of these two layouts:
>    * -----------------------------------
>    * | MAC DA | MAC SA | 4b tag | Type | DSA_TAG_PROTO_BRCM
> @@ -143,6 +181,9 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
>   				       unsigned int offset,
>   				       int *tag_len)
>   {
> +	struct b53_port_hwtstamp *ps;
> +	struct b53_device *b53_dev;
> +	struct dsa_port *dp;
>   	int source_port;
>   	u8 *brcm_tag;
>   	u32 tstamp;
> @@ -174,6 +215,16 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
>   	if (!skb->dev)
>   		return NULL;
>   
> +	/* Check whether this is a status frame */
> +	if (*tag_len == 8 && brcm_tag[3] & 0x20) {

Can we have an unlikely() here, because this is unlikely to happen 
except for switches that do support PTP, and we only have 53128 so far.

Also a define for this 0x20 would be nice, it is the timestamp bit for 
the packet.
-- 
Florian
