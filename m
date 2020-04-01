Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A34CD19A3A6
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 04:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731608AbgDACgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 22:36:52 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39277 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731556AbgDACgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 22:36:52 -0400
Received: by mail-pg1-f195.google.com with SMTP id g32so5323562pgb.6
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 19:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=scGyxoGWIsZsA3Q0ji5lT/klWKe9F4WEX2/qwbJbovM=;
        b=esUn1+jk5Rxg7TvB9L27471q7QRKqTpDoBFaJR0reTM6NijfU2gs+gBPji6sTtJeTO
         ZtZ+Ns9ClzjFwmQidRwdkgBYiv+ldWqR1E4rOiwSkya6DuRnE0MyRb30REz6vkL1M/s0
         yu17Ol8wJe4OFTica/t58A7jNaMS2bNMc/Xunr6PrNyz8LOPh7jT96beCDG0WdNCoZLG
         dp35ClUZYhGAvDoP7rcd2dafhkaGHPGEcB771g0WAorXv6rHL7etnVyZhuVMLm9y8Bdl
         9nTgRytAnh/636tYT0a9p7vNcMAVOVFOUOTmOh49ZzVl5T9QJ/nYX1NPf1QK6ANXQeJR
         MBdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=scGyxoGWIsZsA3Q0ji5lT/klWKe9F4WEX2/qwbJbovM=;
        b=L+HJcBLYjdwjS6X7MX/p4rzCBDtGO/0gZXiMSgGF5LtdaQ72fvNRrgl4PEVpLo5ArQ
         VtIl9DtY3lMenbrxsD07QNdqKPzuLb56EvRJ2xlbtb2141OW88Nh7nHYmwVmd4DKd7h5
         3GbqAKx/s9scR2g77zKWuMIzG5+71GADjDjweX4I1hT75fBBAOfN8VrVqljoYlJho14D
         Ba+EkwZpTIqASrfl2BK1qKqVYyAKF4tYjRPbsh5j7LPwHrAxNLiyfPwppQmTi7dxmiDW
         rjqgTNdBYlKMaDTsyBOmZRUbIRCDhgFUSLtbr8kuyvW8jHlW/8LhrsDENUswBv/tjR9Y
         +O7Q==
X-Gm-Message-State: ANhLgQ2SP4o9QCjqzMKW4gPd9sUZJctVE66Msl6lmOECoVTPnpySlc7M
        Ug3LRS1Ek69RPP//n6h8gZg=
X-Google-Smtp-Source: ADFU+vsNVqMGR5SIpQPugsvDKEu7hLQDo/12cHWlWfCSu3IH7k4RlNjl0J7amr2ZLv3E8nKBuAU22Q==
X-Received: by 2002:a62:520a:: with SMTP id g10mr20924161pfb.271.1585708611253;
        Tue, 31 Mar 2020 19:36:51 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id c21sm281359pgn.84.2020.03.31.19.36.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 19:36:50 -0700 (PDT)
Subject: Re: [PATCHv2 net-next] neigh: support smaller retrans_time settting
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
References: <20200331033356.29956-1-liuhangbin@gmail.com>
 <20200401020749.2608-1-liuhangbin@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <82a99a95-9a8c-48e8-133a-f249b5a25f3b@gmail.com>
Date:   Tue, 31 Mar 2020 19:36:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200401020749.2608-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/31/20 7:07 PM, Hangbin Liu wrote:
> Currently, we limited the retrans_time to be greater than HZ/2. i.e.
> setting retrans_time less than 500ms will not work. This makes the user
> unable to achieve a more accurate control for bonding arp fast failover.
> 
> Update the sanity check to HZ/100, which is 10ms, to let users have more
> ability on the retrans_time control.
> 
> v2: use HZ instead of hard code number
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/core/neighbour.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 5bf8d22a47ec..46a5611a9f3d 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1125,7 +1125,7 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
>  			neigh->nud_state     = NUD_INCOMPLETE;
>  			neigh->updated = now;
>  			next = now + max(NEIGH_VAR(neigh->parms, RETRANS_TIME),
> -					 HZ/2);
> +					 HZ/100);
>  			neigh_add_timer(neigh, next);
>  			immediate_probe = true;
>  		} else {
> 

Note that IPv6 has a different limit (HZ/10)

It would be nice to have converged values.


