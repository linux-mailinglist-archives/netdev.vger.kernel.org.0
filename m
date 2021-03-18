Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70C8340305
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 11:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhCRKR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 06:17:56 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:33001 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhCRKRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 06:17:50 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1616062308; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=kwcYCTFYvBcXj5tH8IQ75LJz4gWAzkJxUwqGZ7M6Z3e0iVmeuv4lNwDl3eV0pzS4MD
    8lYXrZLxXXf6Va5uC69pR4haEgNRlJ3CZKK4m4WtiZno88LzE4xnmP76SkURVx6udLU9
    LXpUDWGGuW4IFm0girOLLeZ1Gj/XKDbBjUXqGxidOEoSrZ7Pp0Sosk+n9HJCpeIdEN7N
    oxuRYHrmFiHSidWSBHT9upZpU0zdEQXDOkdYQZoNYrapm6MLuIORsEuQLXafLyXmBrvK
    +EEdSAYAXdHq9Kd8BWBLT8Vjkpx55P7K2wkaDQXdlOsN2LG0hx52ROwcoucSfYuB5nB+
    710A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1616062308;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=+4w0vi7G/vmvpMV+8OYWuvA+rqzn6qG4BCKZ9rtRS1Y=;
    b=bTOs+P3EVkbCdkaOGVRny8EXxg6RbTOJkAHTfkHgPlWw2gZZQJESaiPaqp+PPW9HpK
    J7kJVivXYe+ZTx5d0mDlTMMQkcV+m1NqdPgoY5AWzCmb2APyFlcP6JF1X8Rj3AFLDAwq
    PCpd5V+4L4U3niUTw88YGx/lYohVN3wMYOKe8Y0BrHtnJqXaozGo5aplYlDhLeXTV3vz
    oBkY+qgYY6DKRibe5QykkEvVMZerxZln6FsGgM6/fCrUfpnYJ1QOcDIVs980XoRnDddv
    uPhwm7/RPM8B5tte9tBchMTnd1ACLSzvKJwsEw/Cx1Qv6vdcxIpd1ra3sYr+mV9o+1By
    GBuA==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1616062308;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=+4w0vi7G/vmvpMV+8OYWuvA+rqzn6qG4BCKZ9rtRS1Y=;
    b=YGZzskUI3GwrDrRsLW3hk803TChqp7iciKOjtw5/+UIonlfEmC41CausPzdS5tjAj5
    9aEUuI8lPHypBljbBHJOtK471rlIyuc4zP6HwqwjsXOnUWVLg2kR0nh4pxLnReIkiNrh
    5fXYZpPTGIgKQLwAWReiM8FCVZu7ga6MO5SHcAnUfCLFRZesU3G2Lr0zwaeUJgNSI94a
    Uu0/9VkMqQnShgjvR8rfjFrOS+BgoxI8grRBsijNd+kaznaNLVUWUoYURNUXNDIayLut
    /wkrtnSqIRRKbQZqfhq7ekLbxFJZiTndc5UHPKJjMlRCe9qoKUCXKzFC09aPuih2JLPh
    TygA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTGVxiOMpjpw=="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.137]
    by smtp.strato.de (RZmta 47.21.0 DYNA|AUTH)
    with ESMTPSA id R01debx2IABl1qi
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 18 Mar 2021 11:11:47 +0100 (CET)
Subject: Re: [net 03/11] can: isotp: TX-path: ensure that CAN frame flags are
 initialized
To:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
References: <20210316082104.4027260-1-mkl@pengutronix.de>
 <20210316082104.4027260-4-mkl@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <bd9fc82e-d67b-34c8-fb74-8977b8825078@hartkopp.net>
Date:   Thu, 18 Mar 2021 11:11:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210316082104.4027260-4-mkl@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

I obviously missed these patches - but they are fine. Thanks!

After checking your patch I was going after this missing initialization 
and detected that the outgoing CAN frame skbs from isotp.c were not 
properly zero initialized - so I sent a patch for it some minutes ago:

https://lore.kernel.org/linux-can/20210318100233.1693-1-socketcan@hartkopp.net/T/#u

In fact I had

 > CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y
 > CONFIG_INIT_ON_FREE_DEFAULT_ON=y

in my local kernel config therefore I was not able to see it on my own :-/

Best,
Oliver

On 16.03.21 09:20, Marc Kleine-Budde wrote:
> The previous patch ensures that the TX flags (struct
> can_isotp_ll_options::tx_flags) are 0 for classic CAN frames or a user
> configured value for CAN-FD frames.
> 
> This patch sets the CAN frames flags unconditionally to the ISO-TP TX
> flags, so that they are initialized to a proper value. Otherwise when
> running "candump -x" on a classical CAN ISO-TP stream shows wrongly
> set "B" and "E" flags.
> 
> | $ candump any,0:0,#FFFFFFFF -extA
> | [...]
> | can0  TX B E  713   [8]  2B 0A 0B 0C 0D 0E 0F 00
> | can0  TX B E  713   [8]  2C 01 02 03 04 05 06 07
> | can0  TX B E  713   [8]  2D 08 09 0A 0B 0C 0D 0E
> | can0  TX B E  713   [8]  2E 0F 00 01 02 03 04 05
> 
> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
> Link: https://lore.kernel.org/r/20210218215434.1708249-2-mkl@pengutronix.de
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>   net/can/isotp.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/net/can/isotp.c b/net/can/isotp.c
> index e32d446c121e..430976485d95 100644
> --- a/net/can/isotp.c
> +++ b/net/can/isotp.c
> @@ -215,8 +215,7 @@ static int isotp_send_fc(struct sock *sk, int ae, u8 flowstatus)
>   	if (ae)
>   		ncf->data[0] = so->opt.ext_address;
>   
> -	if (so->ll.mtu == CANFD_MTU)
> -		ncf->flags = so->ll.tx_flags;
> +	ncf->flags = so->ll.tx_flags;
>   
>   	can_send_ret = can_send(nskb, 1);
>   	if (can_send_ret)
> @@ -790,8 +789,7 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
>   		so->tx.sn %= 16;
>   		so->tx.bs++;
>   
> -		if (so->ll.mtu == CANFD_MTU)
> -			cf->flags = so->ll.tx_flags;
> +		cf->flags = so->ll.tx_flags;
>   
>   		skb->dev = dev;
>   		can_skb_set_owner(skb, sk);
> @@ -939,8 +937,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
>   	}
>   
>   	/* send the first or only CAN frame */
> -	if (so->ll.mtu == CANFD_MTU)
> -		cf->flags = so->ll.tx_flags;
> +	cf->flags = so->ll.tx_flags;
>   
>   	skb->dev = dev;
>   	skb->sk = sk;
> 
