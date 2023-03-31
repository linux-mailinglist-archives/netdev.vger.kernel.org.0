Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 823636D1E06
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 12:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbjCaK1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 06:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjCaK1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 06:27:07 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90ED7DF;
        Fri, 31 Mar 2023 03:25:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680258347; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=DkbY0MIngkFri3nmc6FTcYGJ2hIweOH4YfeTKehqP2kDb90KKe+NMTCv7sJxLxzO33
    PwwaQDuA6CnVorJ96vABDmczHHM0kRBRjh9oIrUHqjLyotEhV5d2qmSUAF4Zal5wK1I0
    xkF7DJW0a5A3eHrIkR48R1WuPDMw7h3zsn0ZaWnUZQnVdtNyNQcCyCNucDhC2o5yUW89
    CAAA2QEcpWrbQdRpGmT06NuwtA6rK5DO6qwKTpYz7DDUXaaL5PKnp03j9RTx3HVkr0GH
    4C6a65gSCogXmGA/yNS6VFEIRS+vJrT1DLsOxSl/JcJ6dKiJComRJJlMiy3BR+xPMm6q
    380w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1680258347;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ie7nEnDqrpX6AV+Xt73tHJAXSoodyFERzmVZ4ewINGc=;
    b=LEUPM3JR0W59V9wRwa8N8PgnU8oKBmVpHqUxZOp6PyloOP+zn8JAe9HE3HSF0Ak7YV
    cSh+yaDlGGg6cjRaFLIj/MSHgtvch3oXqOo1Ud/Jg/kpo8dBbRpyWgEe51X8BggS65DA
    l93gE2s0t6oZQ9KLviBpr8DYdWb/Y6d/v+3RfJheSn6JzGjZAK55fTpPTmsoBUrFMtKj
    sFpHrGi8bWIqfpny7NlZSFE9Plh2Jewk+Hk9QeAqzZlTkZ2/sa3KWyWCDwvQ7uDnfELp
    HuozT4gHQhx5ZoJGC0TRzIK+Gfbu+TdmMqEIvdcmpoerDTKQfz0+/KqQGRzjKq7WvxFj
    eeHw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1680258347;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ie7nEnDqrpX6AV+Xt73tHJAXSoodyFERzmVZ4ewINGc=;
    b=Yd3E3fdpM9TfkyV1rOiTDubwyn2IuvkuuSUgxVfZEmiZJLAHNN5LLNS6JcCm9oidZg
    pEbkWMOOz0DNJSj2DABF5SUg+VZwXUfVGqYhvNuUloc5ty7MuX9ZjsV7KktEqB0IFIfU
    RR7Y4ENz75tmCGWBLzG/kD0whJjBNwKksrALgO6MQgKwsi+4w3xMV6E2qh0Sysgvy2P3
    EKZrHsvkHkRYxQfy+CQwLGnDVuixWXyZz7e/UajVoT96b6vmS5+zbm3So5LmcLeMC+Yk
    0m4Qmb7J/JPbGBl2yK7kkCwrDk8d9/dOC6mknJNCIkTawSfw8AmzZslGm6trr7MOFgHT
    vkow==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusl129OHEdFq0USEbDUQnQ=="
Received: from [IPV6:2a00:6020:4a8e:5000::923]
    by smtp.strato.de (RZmta 49.3.1 AUTH)
    with ESMTPSA id n9397fz2VAPlij3
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 31 Mar 2023 12:25:47 +0200 (CEST)
Message-ID: <675932fa-f0df-ad53-d517-ee5854c9245e@hartkopp.net>
Date:   Fri, 31 Mar 2023 12:25:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: WARNING in isotp_tx_timer_handler and WARNING in print_tainted
To:     Hillf Danton <hdanton@sina.com>,
        "Dae R. Jeong" <threeearcat@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-can <linux-can@vger.kernel.org>
References: <ZB/93xJxq/BUqAgG@dragonet>
 <31c4a218-ee1b-4b64-59b6-ba5ef6ecce3c@hartkopp.net>
 <ZCAytf0CpfAhjUSe@dragonet> <20230327014843.2431-1-hdanton@sina.com>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20230327014843.2431-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey all,

looking at the code simplification from Hillf I reworked some of the 
cmpxchg() code and removed the old_state mechanism.

I posted a RFC patch here:

https://lore.kernel.org/linux-can/20230331102114.15164-1-socketcan@hartkopp.net/

Please comment on the patch whether you think if this could be an 
improvement.

Many thanks,
Oliver

On 27.03.23 03:48, Hillf Danton wrote:
> On Sun, 26 Mar 2023 18:17:17 +0200 Oliver Hartkopp <socketcan@hartkopp.net>
>> On 26.03.23 13:55, Dae R. Jeong wrote:
>>>
>>> If I think correctly, this will make cmpxchg() work, and prevent the
>>> problematic concurrent execution. Could you please check the patch
>>> below?
>>
>> Hm, interesting idea.
>>
>> But in which state will so->tx.state be here:
>>
>> /* wait for complete transmission of current pdu */
>> err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
>> if (err)
>> 	goto err_out;
>>
>>
>> Should we better set the tx.state in the error case?
>>
>> if (err) {
>> 	so->tx.state = ISOTP_IDLE;
>> 	goto err_out;
>> }
>>
>> Best regards,
>> Oliver
> 
> Another 2c only if cmpxchg is preferred.
> 
> +++ b/net/can/isotp.c
> @@ -932,19 +932,24 @@ static int isotp_sendmsg(struct socket *
>   		return -EADDRNOTAVAIL;
>   
>   	/* we do not support multiple buffers - for now */
> -	if (cmpxchg(&so->tx.state, ISOTP_IDLE, ISOTP_SENDING) != ISOTP_IDLE ||
> -	    wq_has_sleeper(&so->wait)) {
> -		if (msg->msg_flags & MSG_DONTWAIT) {
> -			err = -EAGAIN;
> -			goto err_out;
> -		}
> -
> +	if (wq_has_sleeper(&so->wait)) {
> +		if (msg->msg_flags & MSG_DONTWAIT)
> +			return -EAGAIN;
>   		/* wait for complete transmission of current pdu */
>   		err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
>   		if (err)
> -			goto err_out;
> +			return err;
> +	}
>   
> -		so->tx.state = ISOTP_SENDING;
> +again:
> +	old_state = cmpxchg(&so->tx.state, ISOTP_IDLE, ISOTP_SENDING);
> +	if (old_state != ISOTP_IDLE) {
> +		if (msg->msg_flags & MSG_DONTWAIT)
> +			return -EAGAIN;
> +		err = wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
> +		if (err)
> +			return err;
> +		goto again;
>   	}
>   
>   	if (!size || size > MAX_MSG_LENGTH) {
