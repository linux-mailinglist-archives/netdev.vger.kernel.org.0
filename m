Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3E4EA3BF
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 20:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfJ3TDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 15:03:45 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40773 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfJ3TDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 15:03:45 -0400
Received: by mail-pf1-f195.google.com with SMTP id r4so2221283pfl.7;
        Wed, 30 Oct 2019 12:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZNOGSfXr8+zRM3gw1fL95YFSKLrvQki0gAx0cCCVmnw=;
        b=K7p2Q0z+EPicIlEOu4mRy+aFK7lPM3qKqoyibHjvwi0Z9ghwJEN/YEHh9dAWqMN4H1
         5Gkum1Ig8hPyo+s0pydbsTxT74WHAdJjO18gj4y/B5XXwi7L4xKo51zFCNqpmJYPLxv6
         A4MICxj/kT9lu1vFzrBandY56jjxwXm8pDmSAbCKM/VFaGscfPOniWbLzFLl8uBvlqoi
         RJ+GXmbewQhhEwYSIkkRpwPxWcMD2E76OmH52D2oWq0mm7xg+gxjpk7glib4v3lR223Z
         NrDb4kHtpMK+Yp8M/1DtTGJoqx/TtMc7RQLUKVoRtRyPI/ftU13B/pyV1JgihayRZTjb
         L4qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZNOGSfXr8+zRM3gw1fL95YFSKLrvQki0gAx0cCCVmnw=;
        b=nzJr1b7NPSSEF+Xr5fny88ou1EM1TAenP0J0EJ1sutDIJsVNqpGb5GnBlZjfs6u58K
         +/gFer/Ko9bqS+2aoC/4q7Pj1j3mH1MHHtlYKVAtArR6lJnO1t59kmW8gdXaZT7kRvB6
         jmwB9L1B9cFPVvEPUM9XOAw7r330/Fj0r0zbX3Ei7XAb96hbEn7OcCmO4ieh1lh0REFZ
         tkdCI6CyiKeAhf5TavNyWMQeM2G0OBJse708aXgeSi9igdwVEn3HBPeYg1ul0GAK3yE8
         Yx6Fwyy5EaQmC5KzGFd285It6nacjZb4I1qmKP8uvyb2286XZsK6COjyUyeCnpyfe7+a
         GQYg==
X-Gm-Message-State: APjAAAV/GWTc+LtlgTjKiTbsGgIiRQZ/EJDIjyBanxGC1vvbfr54MwF/
        2+f9jt9v1Q5PnbVcXoxXw0ccsiZ0
X-Google-Smtp-Source: APXvYqwl5VpbxI+r1KoXrqGAugu6jPGfjRFB+TajhSLOkyTHFgkjVVsoIgEqAsPp5zGpWfGmeokA9A==
X-Received: by 2002:a62:53:: with SMTP id 80mr988273pfa.192.1572462224545;
        Wed, 30 Oct 2019 12:03:44 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id y1sm716981pfq.138.2019.10.30.12.03.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2019 12:03:43 -0700 (PDT)
Subject: Re: [PATCH] sctp: set ooo_okay properly for Transmit Packet Steering
To:     Wally Zhao <wallyzhao@gmail.com>, vyasevich@gmail.com,
        nhorman@tuxdriver.com, marcelo.leitner@gmail.com,
        davem@davemloft.net, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     wally.zhao@nokia-sbell.com
References: <1572451637-14085-1-git-send-email-wallyzhao@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c2d0890f-8900-6838-69c4-6b72b2e58062@gmail.com>
Date:   Wed, 30 Oct 2019 12:03:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1572451637-14085-1-git-send-email-wallyzhao@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/30/19 9:07 AM, Wally Zhao wrote:
> Unlike tcp_transmit_skb,
> sctp_packet_transmit does not set ooo_okay explicitly,
> causing unwanted Tx queue switching when multiqueue is in use;
> Tx queue switching may cause out-of-order packets.
> Change sctp_packet_transmit to allow Tx queue switching only for
> the first in flight packet, to avoid unwanted Tx queue switching.
> 

While the patch seems fine, the changelog is quite confusing.

When skb->ooo_olay is 0 (which is the default for freshly allocated skbs),
the core networking stack will stick to whatever TX queue was chosen
at the time the dst_entry was attached to the (connected) socket.

This means no reorder can happen at all by default.

By setting ooo_okay carefully (as you did in your patch), you allow
core networking stack to _switch_ to another TX queue based on
current CPU  (XPS selection)

So even without your fix, SCTP should not experience out-of-order packets.

> Signed-off-by: Wally Zhao <wallyzhao@gmail.com>
> ---
>  net/sctp/output.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index dbda7e7..5ff75cc 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -626,6 +626,10 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
>  	/* neighbour should be confirmed on successful transmission or
>  	 * positive error
>  	 */
> +
> +	/* allow switch tx queue only for the first in flight pkt */
> +	head->ooo_okay = asoc->outqueue.outstanding_bytes == 0;
> +
>  	if (tp->af_specific->sctp_xmit(head, tp) >= 0 &&
>  	    tp->dst_pending_confirm)
>  		tp->dst_pending_confirm = 0;
> 
