Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE46345066
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhCVUA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhCVUAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 16:00:37 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562BFC061574;
        Mon, 22 Mar 2021 13:00:37 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id l18so12680495edc.9;
        Mon, 22 Mar 2021 13:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kJgeZ3KJMI6EGBVI9mka8hL+bYKbeA4W1uqhZJmB1Sg=;
        b=guOGuGv2a439sFNoLo25xREFKxJf4tWlTAGfF/Cp51m+nDzN5NxmzPV/Ju6XPo4wpe
         2iXXbVFoZLKu9yuCu5rxcJyUEBbgU4v/KYH01eSKph+0XiEleK4o9LmpRMjsTXFo1+dU
         dOyVWf7qhh8oMY6cRQHAYySBY1cMFAbMb+PvyCTm+FN9Ro4aeOLyb1NQ7oghLpr60VU9
         9I3xDPqHPYcqEXRaZU4rsxXyINtonGPQV8hx9hEUIy+PAz88q/pAF7ivLjEgSF2syWIT
         AL6qGk0n3iHg7FlXAQJTbaFVsJO85W0P0Xn0QjBiw4yW6CikXIbMSOHydQ7FltGqKFyR
         IJcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kJgeZ3KJMI6EGBVI9mka8hL+bYKbeA4W1uqhZJmB1Sg=;
        b=ZfTKos9SG2+1muTYFTunNGpsViiPbJFnPUXSbYnyoVvreuLdT3XmQR7W/u+LPHxAeI
         kSuIXJByZnzLXWaAxqBnHA6Vl0DnzHyd6Lh0+QmKc0ZIJVaEtE90YKU6oKn9tuAR+RsS
         xKXCKBD8eUUmFjEDVyU+pcZf16qQBWYTdB3wPl10/jEsU2tEOx191BAReJCJvh2w8p4T
         KIAbQ/t25pCGhnstiGdlV+9pdffTOFBDGltHgTnclDRkfTDEDDGcxBErpEx+daW7aSgq
         2Y7UzgWuKeTUTdzS8B3RFP3Wsrq5BxX6dnAUdF11/vpXLjFIrQA283/IIHDWRkLIOWRC
         o45w==
X-Gm-Message-State: AOAM532oneT/mlHLOV9qgWqssexqYJqQzcyL/3pMF21b+zXU/xcBzEIt
        56W7RBzVhtye4QlWnnCF/QA=
X-Google-Smtp-Source: ABdhPJy+C7VuSJCRfrFWwPe0gMdRPDewaq2T+4NZX0BYUVH6P8iaZK2n3S/VrpKsUhN0apLvfxyaqQ==
X-Received: by 2002:a05:6402:95b:: with SMTP id h27mr1292903edz.93.1616443235936;
        Mon, 22 Mar 2021 13:00:35 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bx24sm10335188ejc.88.2021.03.22.13.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 13:00:35 -0700 (PDT)
Date:   Mon, 22 Mar 2021 22:00:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andriin@fb.com, edumazet@google.com,
        weiwan@google.com, cong.wang@bytedance.com, ap420073@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@openeuler.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        jonas.bonn@netrounds.com, pabeni@redhat.com, mzhivich@akamai.com,
        johunt@akamai.com, albcamus@gmail.com, kehuan.feng@gmail.com,
        a.fatoum@pengutronix.de
Subject: Re: [RFC v3] net: sched: implement TCQ_F_CAN_BYPASS for lockless
 qdisc
Message-ID: <20210322200033.uphemtsunfqsvjej@skbuf>
References: <1616050402-37023-1-git-send-email-linyunsheng@huawei.com>
 <1616404156-11772-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1616404156-11772-1-git-send-email-linyunsheng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yunsheng,

On Mon, Mar 22, 2021 at 05:09:16PM +0800, Yunsheng Lin wrote:
> Currently pfifo_fast has both TCQ_F_CAN_BYPASS and TCQ_F_NOLOCK
> flag set, but queue discipline by-pass does not work for lockless
> qdisc because skb is always enqueued to qdisc even when the qdisc
> is empty, see __dev_xmit_skb().
> 
> This patch calls sch_direct_xmit() to transmit the skb directly
> to the driver for empty lockless qdisc too, which aviod enqueuing
> and dequeuing operation. qdisc->empty is set to false whenever a
> skb is enqueued, see pfifo_fast_enqueue(), and is set to true when
> skb dequeuing return NULL, see pfifo_fast_dequeue().
> 
> There is a data race between enqueue/dequeue and qdisc->empty
> setting, qdisc->empty is only used as a hint, so we need to call
> sch_may_need_requeuing() to see if the queue is really empty and if
> there is requeued skb, which has higher priority than the current
> skb.
> 
> The performance for ip_forward test increases about 10% with this
> patch.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> Hi, Vladimir and Ahmad
> 	Please give it a test to see if there is any out of order
> packet for this patch, which has removed the priv->lock added in
> RFC v2.
> 
> There is a data race as below:
> 
>       CPU1                                   CPU2
> qdisc_run_begin(q)                            .
>         .                                q->enqueue()
> sch_may_need_requeuing()                      .
>     return true                               .
>         .                                     .
>         .                                     .
>     q->enqueue()                              .
> 
> When above happen, the skb enqueued by CPU1 is dequeued after the
> skb enqueued by CPU2 because sch_may_need_requeuing() return true.
> If there is not qdisc bypass, the CPU1 has better chance to queue
> the skb quicker than CPU2.
> 
> This patch does not take care of the above data race, because I
> view this as similar as below:
> 
> Even at the same time CPU1 and CPU2 write the skb to two socket
> which both heading to the same qdisc, there is no guarantee that
> which skb will hit the qdisc first, becuase there is a lot of
> factor like interrupt/softirq/cache miss/scheduling afffecting
> that.
> 
> So I hope the above data race will not cause problem for Vladimir
> and Ahmad.
> ---

Preliminary results on my test setup look fine, but please allow me to
run the canfdtest overnight, since as you say, races are still
theoretically possible.
