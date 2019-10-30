Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBF5E9C37
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 14:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfJ3NYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 09:24:25 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:32880 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbfJ3NYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 09:24:25 -0400
Received: by mail-qt1-f193.google.com with SMTP id y39so3208840qty.0;
        Wed, 30 Oct 2019 06:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=V/wnj6oKKe1Sq8rjaWwuzZNcb4lKIJbQVb556eiBhYE=;
        b=NLGuKt964rUn6/j7+H4omNIBAjQYO0yoN/MjFMmQ46watXej8J547kVPSNuSb3hVIn
         zcgk8ODIRiVMFQwbcLoE8L1RN/2BSWpxOE+nlbf1ShU44Hb6hVgT4JTv8eH2/GENjhh3
         TJozMjddK9Gm4T2CbLx3jAsAvmPEVFTX9Jh6FbGU9ninoH/c6akKRlrxByYGSR9duPIz
         ZW3n3bo/aSE9E9mOa38k4ScA9yI4Cy2EtpdbFTKvxcvl74hlqYh1U/bewqThxhEp0Szc
         MoLOdCht8A36pTrSLpSPjEU9BSlVcrSlGtw+dRkEaTyBhEUFhAB5CFYb1muakCSpMFtm
         Xjxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=V/wnj6oKKe1Sq8rjaWwuzZNcb4lKIJbQVb556eiBhYE=;
        b=biZSs30Nh9xDe3czGRdeHP8KxGVY/1q2MILhgQrOSm2EJ9w2O0XlUzW+q7dOfNiZ6S
         q5zDxHsmXyx76lmp48hwgFpP9ZZSdIT3ivYzmwysheQCpoRx3BrpS7OKsUGi/mdbU+Em
         v30wLe18d0/Qq/13AoFIswWoP0K+UUpUADyK1vH97Gg1Nx+RYYZpjv5jx7kgTPljJY2Z
         Uqa6d877UIP67heS4BZd3cIMAUdGmbdCyh9HIrQQkRUoLCQ+/a6SrI//PEhiM9gW5CYM
         +LVxygU+BbtkIn2z44jfSeNdVVs80e+NyQBz5/TD7YHjdKIu9jfPUgvdAiBNd43gm4NW
         P2FA==
X-Gm-Message-State: APjAAAXQdEHQ+OLGbtGw5X2dA84UFUn9nqws2Ce3XA0GvZ5tKRl4zueQ
        InzxE8Ft7tfpsRsDEkCGm7sJY42sr8w=
X-Google-Smtp-Source: APXvYqxXgk9xgikfWwKGihR0Bsg0yVAuHamm2kMo5n7KP0wL+5yKZBf0Fa1JRUR8URHAgHbsXKLTZg==
X-Received: by 2002:aed:2722:: with SMTP id n31mr8776qtd.98.1572441863901;
        Wed, 30 Oct 2019 06:24:23 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.193])
        by smtp.gmail.com with ESMTPSA id g83sm6644qke.100.2019.10.30.06.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 06:24:23 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 72739C0AD9; Wed, 30 Oct 2019 10:24:20 -0300 (-03)
Date:   Wed, 30 Oct 2019 10:24:20 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Wally Zhao <wallyzhao@gmail.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wally.zhao@nokia-sbell.com
Subject: Re: [PATCH] sctp: set ooo_okay properly for Transmit Packet Steering
Message-ID: <20191030132420.GG4326@localhost.localdomain>
References: <1572451637-14085-1-git-send-email-wallyzhao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572451637-14085-1-git-send-email-wallyzhao@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 12:07:17PM -0400, Wally Zhao wrote:
> Unlike tcp_transmit_skb,
> sctp_packet_transmit does not set ooo_okay explicitly,
> causing unwanted Tx queue switching when multiqueue is in use;

It is initialized to 0 by __alloc_skb() via:
        memset(skb, 0, offsetof(struct sk_buff, tail));
and never set to 1 by anyone for SCTP.

The patch description seems off. I don't see how the unwanted Tx queue
switching can happen. IOW, it's not fixing it OOO packets, but
improving it by allowing switching on the first packet. Am I missing
something?

> Tx queue switching may cause out-of-order packets.
> Change sctp_packet_transmit to allow Tx queue switching only for
> the first in flight packet, to avoid unwanted Tx queue switching.
> 
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

Considering we are talking about NIC queues here, we would have a
better result with tp->flight_size instead. As in, we can switch
queues if, for this transport, the queue is empty.

> +
>  	if (tp->af_specific->sctp_xmit(head, tp) >= 0 &&
>  	    tp->dst_pending_confirm)
>  		tp->dst_pending_confirm = 0;
> -- 
> 1.8.3.1
> 
