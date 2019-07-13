Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A32C167A30
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 14:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfGMMyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 08:54:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45810 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfGMMyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 08:54:52 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so12495540wre.12
        for <netdev@vger.kernel.org>; Sat, 13 Jul 2019 05:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=evWssCsPxWTP56bQCGPek3kuLk/9wbIysQk31Qyjk5o=;
        b=UkTIFZ9zmDO6Z5zY+plO9DbOTUXXXrXN2Ai3i9wTqFzFNTH3vlzjezfyiF1nEoZbN7
         /dRPfbEwZsDAG5reHImRFz8XdG6bWQ0eIdpIYaM8J7dt8c05LGuNpvnJWXnlLlKJvPk0
         oH0j2xHwX7ESygMZt3EZcS9YJNCPIEYyq6gpo9oyD8PHYw66WYvkzmQdstHzjEFHSjJj
         gCCLyk10RVR/ferv7Uj8pdPELtgxTRlO7rpMICfaypyzKr1HINANvtTkvMHZYdP8e3fE
         q+89JtzKCG/GPtgx6WGLBx+IXjwrip9WOENAOp8ES7FrM83VaceVCK57KcuYEBvRVB71
         ScPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=evWssCsPxWTP56bQCGPek3kuLk/9wbIysQk31Qyjk5o=;
        b=tRtyoqa7w6b7bytBzOG+NXamgcMqsd+iIU+MxE0QioaViYG6ZYiI/ACFW3TvmSADmh
         v4tvkLQOaRWI4db3a89SNpH4YYEtYKRPtIgrUoIUfr69oli9IjngckG9R6mea7NjSyCk
         supTIhxHgQHX2diDBlxvazdTOO0ONAB+Ke+PfJdGSLeBLbSZg+msovRAVJV1h3FOvWcP
         8KhgNRygPxBNp7wuy5shn1LnODOB7eIYAsnYHwxgaUw01uNYQ763jL/jYmYPYq15boxr
         x2stjP2LkXzOcZ/jx8P61HWNJVH7LkiJNLpGJhnMFTu/SuIvOKClGw0AmCJoXePG+MCX
         bpkw==
X-Gm-Message-State: APjAAAVrnLHq4PCT5XNxq86RjdqVs91bLAzMDbK0Y+jahsFvIhuSXC7E
        cZr93CCJ37MlWKsdnPs0fQ8=
X-Google-Smtp-Source: APXvYqzbovXekY+ou3k9dopC+LnY+/b94mELxT3Hq1CK3eVzHLIJjxw+bA4JYEUpLrdGUbhFJD1z3Q==
X-Received: by 2002:adf:f281:: with SMTP id k1mr17198845wro.154.1563022489832;
        Sat, 13 Jul 2019 05:54:49 -0700 (PDT)
Received: from [192.168.8.147] (134.161.185.81.rev.sfr.net. [81.185.161.134])
        by smtp.gmail.com with ESMTPSA id g19sm23054528wrb.52.2019.07.13.05.54.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 13 Jul 2019 05:54:49 -0700 (PDT)
Subject: Re: [Patch net] net_sched: unset TCQ_F_CAN_BYPASS when adding filters
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>
References: <20190712201749.28421-1-xiyou.wangcong@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8733195c-ac70-4a2a-db2f-b9bdfd05a703@gmail.com>
Date:   Sat, 13 Jul 2019 14:54:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190712201749.28421-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/19 10:17 PM, Cong Wang wrote:
> For qdisc's that support TC filters and set TCQ_F_CAN_BYPASS,
> notably fq_codel, it makes no sense to let packets bypass the TC
> filters we setup in any scenario, otherwise our packets steering
> policy could not be enforced.
> 
> This can be easily reproduced with the following script:
> 
>  ip li add dev dummy0 type dummy
>  ifconfig dummy0 up
>  tc qd add dev dummy0 root fq_codel
>  tc filter add dev dummy0 parent 8001: protocol arp basic action mirred egress redirect dev lo
>  tc filter add dev dummy0 parent 8001: protocol ip basic action mirred egress redirect dev lo
>  ping -I dummy0 192.168.112.1
> 
> Without this patch, packets are sent directly to dummy0 without
> hitting any of the filters. With this patch, packets are redirected
> to loopback as expected.
> 
> This fix is not perfect, it only unsets the flag but does not set it back
> because we have to save the information somewhere in the qdisc if we
> really want that.
> 
> Fixes: 4b549a2ef4be ("fq_codel: Fair Queue Codel AQM")
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/sched/cls_api.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 638c1bc1ea1b..5c800b0c810b 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -2152,6 +2152,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>  		tfilter_notify(net, skb, n, tp, block, q, parent, fh,
>  			       RTM_NEWTFILTER, false, rtnl_held);
>  		tfilter_put(tp, fh);
> +		q->flags &= ~TCQ_F_CAN_BYPASS;
>  	}
>  
>  errout:
> 

Strange, because sfq and fq_codel are roughly the same for TCQ_F_CAN_BYPASS handling.

Why is fq_codel_bind() not effective ?

If not effective, sfq had the same issue, so the Fixes: tag needs to be refined,
maybe to commit 23624935e0c4 net_sched: TCQ_F_CAN_BYPASS generalization

