Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9F7728D9
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 09:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfGXHKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 03:10:25 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39397 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfGXHKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 03:10:25 -0400
Received: by mail-wm1-f67.google.com with SMTP id u25so30177844wmc.4
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 00:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A/NhbNoEou/qaXtswWblH3/sXlvuGn3vtbUpB32/btY=;
        b=f0oGZ6opcBmy/9ZJyzjUKqynMq95GAs6k1mgflzbrsB3/jxitTb8DDPVqnEluJc3zp
         u5Wf7IoQj98wUYNEpmd5kmv4BD7aFN8JqlN4GFeoXUNWvomfzXSrhNasbstcImgTDlqg
         Ww9LytQJXTTbUk1jDeg7u8Ts0LyWrhSV1cKnun4ChnA9rTX+zFtp1H3JdKvjabv0zgBA
         +0MvVKvgJcs4qO/yjLAP572KxXsMjjAqgPpnDZLwE19+fITo1bhOxzeQZ18Sh36UhCXB
         glyqcDV2XUnHhw+NDsEDXAf2PeHotDf0djMBGQxMTeWHiippYP8lpycy2TjRmrH8TPuU
         lyMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A/NhbNoEou/qaXtswWblH3/sXlvuGn3vtbUpB32/btY=;
        b=jAEcssrJ9/ydJYscSwv30SvmnXqTlFWt9q+xscPTfmnTcmnkheCmMV+ESySzsTwdyI
         7rIM4f1LxMKeMtXrHw4LT7oq66sXX8E1hO45j/8vr4AQkNzPBORk3MONdL7U54att/b/
         dSu9xMcEATgyM2vbQi3KJKybCjX2jrUt3UvGubilyse+Z1xDL9czAOBIKKe1QARWSf1S
         9pB0lqumE+fBgHsmBPf2ctetTmaP/zy7nKtZx/C1FhWkrzgcfjeSv1UP4u8owiC/CcIw
         PWIyZkUt+jrOH1jJPQZlrR6Ybuqyjxl324gDHF/3/WPSFBslG6jO+Oi/jjR+1Qs6CprO
         nasQ==
X-Gm-Message-State: APjAAAX0j2fQ75ggIfjQf/t3Rx/9+f8x7SaRz2SlxoUF++9TA8sEKNqe
        CqXyuvmCr8XchJa9/1EI+ABAimJL
X-Google-Smtp-Source: APXvYqzAeFVcSPBTnMLxcphuMXaua4pVrKc9Yn3VEDcjnCCJ6cI23x0mVk2vrynFRgO3gS14G7Q6yw==
X-Received: by 2002:a1c:dc46:: with SMTP id t67mr67512146wmg.159.1563952222962;
        Wed, 24 Jul 2019 00:10:22 -0700 (PDT)
Received: from [192.168.8.147] (200.150.22.93.rev.sfr.net. [93.22.150.200])
        by smtp.gmail.com with ESMTPSA id g19sm50199368wmg.10.2019.07.24.00.10.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 00:10:22 -0700 (PDT)
Subject: Re: [PATCH net-next] dpaa2-eth: Don't use netif_receive_skb_list for
 TCP frames
To:     Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com, vladimir.oltean@nxp.com
References: <1563902923-26178-1-git-send-email-ruxandra.radulescu@nxp.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <49d021a6-46de-f37e-8097-2836d0d31930@gmail.com>
Date:   Wed, 24 Jul 2019 09:10:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1563902923-26178-1-git-send-email-ruxandra.radulescu@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/23/19 7:28 PM, Ioana Radulescu wrote:
> Using Rx skb bulking for all frames may negatively impact the
> performance in some TCP termination scenarios, as it effectively
> bypasses GRO.

>  
> -	list_add_tail(&skb->list, ch->rx_list);
> +	if (frame_is_tcp(fd, fas))
> +		napi_gro_receive(&ch->napi, skb);
> +	else
> +		list_add_tail(&skb->list, ch->rx_list);
>  
>  	return;
>  


This is really bad.

This is exactly why I suggested to add the batching capability to GRO,
instead having to change all drivers.

Edward Cree is working on this.


