Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227184443D5
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 15:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhKCOvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 10:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbhKCOu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 10:50:59 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8E6C061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 07:48:21 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id b17so4987631uas.0
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 07:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=su6lnguEq5E+QrsWTqKeX8mg6LLpccD+7Q/3Bfa5z28=;
        b=eyAT/2fHy8jQamZ48UM47zWA+zlY+LA8JLG7Mb9q8ezfhdUiOOs6Ieef4RzfxFL4Hv
         s0eSt+fwFCj+thhuWtejHd8Nr0sXlMbWSE5uPtrV8FeraZgGKfGAtBn9CJEp1wPyJw5L
         wtvM4AleFeoobtcWKZPt4y0S+hsNrc5BdJ9RoJHrzoj8BxPkHN5mUW1W0YbghFYcfbY6
         mouuw4CpDuSOGVkILvg53w0z+DaSZgt+zDNwEZzCZKXq1vOyPatSLLCeS7/NvBFzgcfG
         oJF3Pz948Kgg2PNRo8M7U3ZfGphl4Dcgt/8OUfKIvnPUgYIcqBB+CZcW37vcIk92LxCB
         D4kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=su6lnguEq5E+QrsWTqKeX8mg6LLpccD+7Q/3Bfa5z28=;
        b=xgU6CKj1sOiCRTEzG2lNiabkLPck5CYAtYXqeHutvJYJeELqKsW98ohhL454fJ3UW+
         BRb3nIHlkA5rM/BQjsNSMbW7W8xkJrPivXAHvPoeq06IoQtNsLe8LY28lsUntlcj57cX
         5drIPanfivnRSL6wSzcncv1lxzD8LJNw/HpKD13yosE8HK5xzBO8hU9WfvknUk5a1ai/
         xyEP30/MJ2Urjxpi4cwD7nruQuAmRRpDaqaSytZtaSgjnjLPb1jqFW0Inf1Dvj88P+0L
         JrQTXICZa3s/okd8wls+rf9t/iWsEwT6uB1he5AIGRFuS+TAWTKhk2PHLyStFjI6n16q
         3K8w==
X-Gm-Message-State: AOAM5331nI91jLO3e94i3eNiOSDJjPxL952IgQCxlcVuh+nTOWuT227G
        nKmIkdZwGgKMsDUsTDLrGBrSYR+IS9I=
X-Google-Smtp-Source: ABdhPJwaJ6boA9BNjiAbfOa15UYwHu4YxRCsUM/X83l8NKFCPyFC0F/slRUqHJE20m6HVAu2tmjsWg==
X-Received: by 2002:a9f:21d7:: with SMTP id 81mr23699909uac.39.1635950900356;
        Wed, 03 Nov 2021 07:48:20 -0700 (PDT)
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com. [209.85.221.174])
        by smtp.gmail.com with ESMTPSA id w4sm295688uae.20.2021.11.03.07.48.19
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 07:48:19 -0700 (PDT)
Received: by mail-vk1-f174.google.com with SMTP id h133so1405503vke.10
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 07:48:19 -0700 (PDT)
X-Received: by 2002:a05:6122:daa:: with SMTP id bc42mr50595505vkb.5.1635950899225;
 Wed, 03 Nov 2021 07:48:19 -0700 (PDT)
MIME-Version: 1.0
References: <20211103143208.41282-1-xiangxia.m.yue@gmail.com>
In-Reply-To: <20211103143208.41282-1-xiangxia.m.yue@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 3 Nov 2021 10:47:42 -0400
X-Gmail-Original-Message-ID: <CA+FuTSftumQMYg8fcCW3C-A0CKZC=6GYDrR3UXjaS1gNJx=5TA@mail.gmail.com>
Message-ID: <CA+FuTSftumQMYg8fcCW3C-A0CKZC=6GYDrR3UXjaS1gNJx=5TA@mail.gmail.com>
Subject: Re: [PATCH v2] net: sched: check tc_skip_classify as far as possible
To:     xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 3, 2021 at 10:32 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> We look up and then check tc_skip_classify flag in net
> sched layer, even though skb don't want to be classified.
> That case may consume a lot of cpu cycles.
>
> Install the rules as below:
> $ for id in $(seq 1 100); do
> $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
> $ done
>
> netperf:
> $ taskset -c 1 netperf -t TCP_RR -H ip -- -r 32,32
> $ taskset -c 1 netperf -t TCP_STREAM -H ip -- -m 32
>
> Before: 10662.33 tps, 108.95 Mbit/s
> After:  12434.48 tps, 145.89 Mbit/s
>
> For TCP_RR, there are 16.6% improvement, TCP_STREAM 33.9%.
>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
> v2: don't delete skb_skip_tc_classify in act_api
> ---
>  net/core/dev.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index edeb811c454e..fc29a429e9ad 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3940,6 +3940,9 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
>         if (!miniq)
>                 return skb;
>
> +       if (skb_skip_tc_classify(skb))
> +               return skb;
> +

This bit and test exist to make sure that packets redirected through
the ifb device are redirected only once.

I was afraid that on second loop, this will also short-circuit other
unrelated tc classifiers and actions that should take place.

The name and the variable comment make clear that the intention is
indeed to bypass all classification.

However, the current implementation acts at tcf_action_exec. So it
does not stop processing by fused classifier-action objects, notably tc_bpf.

So I agree both that this seems to follow the original intent, but also
has the chance to break existing production configurations.


>         /* qdisc_skb_cb(skb)->pkt_len was already set by the caller. */
>         qdisc_skb_cb(skb)->mru = 0;
>         qdisc_skb_cb(skb)->post_ct = false;
> --
> 2.27.0
>
