Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08473A576B
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 11:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhFMJxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 05:53:53 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.21]:20671 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbhFMJxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 05:53:52 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1623577899; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Ek/ootHM4vaMzT2EpE+Lyl6ZgpOuEZKAGfjJDG/U/hmirvs7ywAEf7ZsNe2DtAsvUU
    azHWwrGaWrZi74ig2LpcjKrUGisKhus5Fk/wa1Dt/6rE8ekk/H4GrwFrK9MJaFvO5Wy7
    x8SzhOEMKCvJYTrZEf50c/sjuM4zj0IRT7wqas8jzS6aYOJ8JlBQv2EGdg9xKbfcMmFh
    LBiix8H4JcnkrUjESKnHpgoK0poELAzetsGdkywBq3xh2P86YYRcKVYHSeTAzpJa9XS9
    Jlp0+mpQWh9pJurlk4YpXRcDDyXYjr8PcijUa6KMU00L2YuFCUPJl8DWoGRERBtOxws2
    sWfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1623577899;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=yRn/NkknMjFNPm+iKgTuo3/Mq9bdemw03ZI+Ugm7CcM=;
    b=O3jCm9sUucyN7tP80GGtTZgg9AKOE6DCymBUAG+Y97L9iAvV7Gsu46gVa+ixVdWq+/
    ytwGZ1IxKtSwgdG/PPoyvChxZyB8yau66WCsfRcCYB3u6vQ2zvLx9PN8Dp/MPatpbgtQ
    CVFZcXK6hFg53sfSuRUGr2/ZyqfsemxVehKfUuGrGUZlbRhcobc3QBCDlkMi4kV40jmg
    Mrtqsyn2Qz4B/fdjiRXfXgg8biUQLTfyXIzacb5aU225ccebfHT9yA5Ghoy2ZJ5H/0ff
    NbipozhsE9qZhJZu5+RYVq4alWzeHfCssimoZBMNTSPhpQC9KP0DUgWN4ieP8pdp2Bzc
    h0ag==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1623577899;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=yRn/NkknMjFNPm+iKgTuo3/Mq9bdemw03ZI+Ugm7CcM=;
    b=PNl/btihdnKYgf9dGyL/cQKav3aawDtQNi+zYgcZAYifIPy5xQd6rcLSvENm9i4NP7
    y4QfyCTWjNbp2mI0bwtdD1eueBV5cDnUKXuXfi283MAgubUjjJVEwQsh9dz5Kp2LQffN
    5YwpGg1W31iu/M+YTdQ2nlFAuglVwYtV+kdG7hLoSbrquX1XLEkb3s7mINqE8xjQZOH9
    V1eeG/JNVLWM/rppX5dkFZzgcr7+AR6ypuLoqDfvq2eZCXQ4oRHDs//Ax7QBOjJAu4A5
    zPxy4HU6LnSc3ocUIKr8rXYzV57m+x2X83RwtDSXUrtyJvuSmOMz5bgq7UQu49xdxeTB
    Z9Qw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTEVR9J8xozF0="
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
    by smtp.strato.de (RZmta 47.27.2 DYNA|AUTH)
    with ESMTPSA id d075c5x5D9pcSQ1
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 13 Jun 2021 11:51:38 +0200 (CEST)
Subject: Re: [PATCH] can: bcm: fix infoleak in struct bcm_msg_head
To:     Norbert Slusarek <nslusarek@gmx.net>
Cc:     mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
References: <trinity-7c1b2e82-e34f-4885-8060-2cd7a13769ce-1623532166177@3c-app-gmx-bs52>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <f9d008bc-2416-8032-0005-35d7c6d87fc1@hartkopp.net>
Date:   Sun, 13 Jun 2021 11:51:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <trinity-7c1b2e82-e34f-4885-8060-2cd7a13769ce-1623532166177@3c-app-gmx-bs52>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12.06.21 23:09, Norbert Slusarek wrote:
> From: Norbert Slusarek <nslusarek@gmx.net>
> Date: Sat, 12 Jun 2021 22:18:54 +0200
> Subject: [PATCH] can: bcm: fix infoleak in struct bcm_msg_head
> 
> On 64-bit systems, struct bcm_msg_head has an added padding of 4 bytes between
> struct members count and ival1. Even though all struct members are initialized,
> the 4-byte hole will contain data from the kernel stack. This patch zeroes out
> struct bcm_msg_head before usage, preventing infoleaks to userspace.
> 
> Fixes: ffd980f976e7 ("[CAN]: Add broadcast manager (bcm) protocol")
> Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Thanks Norbert!

Yes, when this data structure was created in 2003 either 64 bit machines 
were far away for me and infoleaks were not a hot topic like today.

Would be interesting to check where data structures are used in the 
Linux UAPI that became an infoleak in the 32-to-64-bit compilation 
transistion.

Thanks for the heads up!

Best regards,
Oliver

> 
> ---
>   net/can/bcm.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/net/can/bcm.c b/net/can/bcm.c
> index 909b9e684e04..b03062f84fe7 100644
> --- a/net/can/bcm.c
> +++ b/net/can/bcm.c
> @@ -402,6 +402,7 @@ static enum hrtimer_restart bcm_tx_timeout_handler(struct hrtimer *hrtimer)
>                  if (!op->count && (op->flags & TX_COUNTEVT)) {
> 
>                          /* create notification to user */
> +                       memset(&msg_head, 0, sizeof(msg_head));
>                          msg_head.opcode  = TX_EXPIRED;
>                          msg_head.flags   = op->flags;
>                          msg_head.count   = op->count;
> @@ -439,6 +440,7 @@ static void bcm_rx_changed(struct bcm_op *op, struct canfd_frame *data)
>          /* this element is not throttled anymore */
>          data->flags &= (BCM_CAN_FLAGS_MASK|RX_RECV);
> 
> +       memset(&head, 0, sizeof(head));
>          head.opcode  = RX_CHANGED;
>          head.flags   = op->flags;
>          head.count   = op->count;
> @@ -560,6 +562,7 @@ static enum hrtimer_restart bcm_rx_timeout_handler(struct hrtimer *hrtimer)
>          }
> 
>          /* create notification to user */
> +       memset(&msg_head, 0, sizeof(msg_head));
>          msg_head.opcode  = RX_TIMEOUT;
>          msg_head.flags   = op->flags;
>          msg_head.count   = op->count;
> --
> 2.30.2
> 
