Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF02913B02
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 17:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfEDPlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 11:41:45 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38576 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfEDPlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 11:41:45 -0400
Received: by mail-pf1-f193.google.com with SMTP id 10so4439975pfo.5
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 08:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4JTroL5aiXg8j1IiFFXKAKN/RbWuX8j4w1HscxigDBM=;
        b=PDDY1yh9pmMCaJQSACa92apF8+PMcanMAk9tM9kxIaIdcdSe1lMz0Vyi+WZokMMV9x
         3xfP6xigvx5XUFOUrPZ1dU4fU+/ZOkP6tDmXxOaDlqjXw6ayDqc3AzDdhBCq/6CjYzcx
         24uV2ijimqbM8wrMLT4gc/w3NNx2xJzRVpDUtzR0tl17Hm/PH3YYQxPbl2A/GC1X9/jt
         iWxk/u4m1MbJyTW8z34C10p5ryf49OY2w4Q14TEGUzbp9RBWBAK8csEj/aVgSf7gI/vm
         8WYmnfH+Wx/0KPpWuUIENI0lX+vYDtazV5WDMIu8AfFnEMaxaMm4TyOIotgHYwORsCCO
         1QZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4JTroL5aiXg8j1IiFFXKAKN/RbWuX8j4w1HscxigDBM=;
        b=MyIqeZ7gMkmYVugxSc9s/2FweFcSSwr7G1IHSTCeCbWFnu1sfUfi42/gq4GiSavcKi
         LmBUm1L2EMqbpwsDSraElJoSIhWGC6tZZfLNCmwUaRei9ZOgVhQcHCS4IDwl6h6oChWC
         Jz7AH93/QUSfvM+snSlENwSwJIJ7hWs8F4/3HyoTc73nL7uqibCnEobmua/9NAIZ23fy
         IHWkrrBXUPf3kRSzSoS8AqGACGQrTsJrmOha87tp59R76eo+i3f/TjBiuaNiCOq6S+Ix
         inABk3C56qnlTr2mVMsJ02dzf+90Rz4sy1vEQRjxnS/oZJA1R1YmrirKLSmW5dqgTRnZ
         8XCQ==
X-Gm-Message-State: APjAAAXcxrtDm5EL8rGUNK2fOyLTAVjXn9OVfNwVnR3H7aj7MEE/YCnb
        3qJpLfln9CZ79e0yyckfD3E=
X-Google-Smtp-Source: APXvYqyF1zfKONZAtqDcZ412avpegbsvDHH8l6nLPgpRDh/eFgE/+F2Xcr3Cx72Z/wgO9iXHYgRBWA==
X-Received: by 2002:a65:430a:: with SMTP id j10mr19672418pgq.143.1556984504375;
        Sat, 04 May 2019 08:41:44 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id k63sm7967099pfb.108.2019.05.04.08.41.42
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 08:41:42 -0700 (PDT)
Subject: Re: [Patch net-next] sch_htb: redefine htb qdisc overlimits
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>
References: <20190502180610.10369-1-xiyou.wangcong@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4d2d89b1-f52b-a978-75a5-39522e3eef05@gmail.com>
Date:   Sat, 4 May 2019 11:41:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502180610.10369-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/2/19 2:06 PM, Cong Wang wrote:
> In commit 3c75f6ee139d ("net_sched: sch_htb: add per class overlimits counter")
> we added an overlimits counter for each HTB class which could
> properly reflect how many times we use up all the bandwidth
> on each class. However, the overlimits counter in HTB qdisc
> does not, it is way bigger than the sum of each HTB class.
> In fact, this qdisc overlimits counter increases when we have
> no skb to dequeue, which happens more often than we run out of
> bandwidth.
> 
> It makes more sense to make this qdisc overlimits counter just
> be a sum of each HTB class, in case people still get confused.
> 
> I have verified this patch with one single HTB class, where HTB
> qdisc counters now always match HTB class counters as expected.
> 
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/sched/sch_htb.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
> index d27d9bc9d010..cece0d455985 100644
> --- a/net/sched/sch_htb.c
> +++ b/net/sched/sch_htb.c
> @@ -177,6 +177,7 @@ struct htb_sched {
>  	int			row_mask[TC_HTB_MAXDEPTH];
>  
>  	struct htb_level	hlevel[TC_HTB_MAXDEPTH];
> +	u32			overlimits;
>  };


Hi Cong, your patch makes sense, but I am not sure about the location of this field,
as this might need another cache line miss.

Maybe instead reduce 'long            direct_pkts;'  to 'u32 direct_pkts;' since we only export
direct_pkts as 32bit quantity in the struct tc_htb_glob.

Then move the 'u32 overlimits;' right after direct_pkts to fill the new hole.

Thanks !

