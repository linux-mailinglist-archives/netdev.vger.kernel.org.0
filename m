Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EF433A1FA
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 01:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbhCNAEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 19:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbhCNAEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 19:04:00 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3ABC061574;
        Sat, 13 Mar 2021 16:03:59 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id b16so335794eds.7;
        Sat, 13 Mar 2021 16:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+sdgvbEQGyNWXo7W7KrCvgk2Jg2tqMHsAEXb4oYjxyQ=;
        b=YUlbivLofXyFGrfW5gTFC46tc6EZhLkpDE+XUCqNktcWlMS2WwsyMqcQSS17UO4tzV
         GWx+P/GmyHQ5lrH+/KBEry6JGKQKsyoPudi/QjH+N9XGvVuvq96mHrTUFJ0+lZpaBh0M
         woBCI1Jj/KCRg2P61dQUC/X0mGkRwa5dVUZuWaNgZPwgqbc5aF4rNnCtNLOVQX/zzQzG
         skGgH4VyrqErmCnzXiVMOTXb8ezHrzMVrcyyUIVcYBHJUAco/l2mSr4BLSEM3CEL4Ko+
         8qTvJqm/GgQ6Ncp6carV58QlfwahS7ifJW21cuDt61nrKFqkpeVyeyNYK6u9sCQU4kH9
         EoEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+sdgvbEQGyNWXo7W7KrCvgk2Jg2tqMHsAEXb4oYjxyQ=;
        b=a+uPY7ewGEmv1p074zMtAXse9gUoEpQt9gmMaNJ7MneifwX4y9qzeItS4tPQk3yPFe
         CQIFAUz2L0FncnrD1U0ATO3/dYa7D+eL2E2odxMB8I0WvMMu4MKX6UXwXgIos3cUfF8X
         6+18++KOsPneoVF8nj4072sra6vNeEDJP7KGKWL2rKMlpMVj3x+qJ4sCm6nH2bX7mxXI
         8UnfWBjkVLjRoOYJyZdp/LkiuEFU0U9bpqsAWTEcDvLl7fuVgHsq1Y45ZeN0t8Js9XOX
         UQPhMx9uH9E745SuIKslP7eifTUnf8Zd4MKT00p4U8ASxM1KdA3D8XVZQGyWhUI96Lfj
         3dTg==
X-Gm-Message-State: AOAM533Clvbn8VOfESGUppP0kkKYMgVDwRfjkfdXjF896Xpi7Ni4NPB9
        fEGuDV9BcUI6bhXT9TfMfEA=
X-Google-Smtp-Source: ABdhPJyJKciEY/ldNFvc1upyj3vN5iOyIzKZuNaLsaGtc8UnQzNalHdqtL/9VQRuCzNBdbgsT9pG2Q==
X-Received: by 2002:a05:6402:32d:: with SMTP id q13mr22327202edw.17.1615680233077;
        Sat, 13 Mar 2021 16:03:53 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id q12sm4706342ejd.51.2021.03.13.16.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 16:03:52 -0800 (PST)
Date:   Sun, 14 Mar 2021 02:03:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andriin@fb.com, edumazet@google.com,
        weiwan@google.com, cong.wang@bytedance.com, ap420073@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@openeuler.org, pabeni@redhat.com
Subject: Re: [PATCH RFC] net: sched: implement TCQ_F_CAN_BYPASS for lockless
 qdisc
Message-ID: <20210314000350.2mrhvprsi77qwqdi@skbuf>
References: <1615603667-22568-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615603667-22568-1-git-send-email-linyunsheng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yunsheng,

On Sat, Mar 13, 2021 at 10:47:47AM +0800, Yunsheng Lin wrote:
> Currently pfifo_fast has both TCQ_F_CAN_BYPASS and TCQ_F_NOLOCK
> flag set, but queue discipline by-pass does not work for lockless
> qdisc because skb is always enqueued to qdisc even when the qdisc
> is empty, see __dev_xmit_skb().
> 
> This patch calles sch_direct_xmit() to transmit the skb directly
> to the driver for empty lockless qdisc too, which aviod enqueuing
> and dequeuing operation. qdisc->empty is set to false whenever a
> skb is enqueued, and is set to true when skb dequeuing return NULL,
> see pfifo_fast_dequeue().
> 
> Also, qdisc is scheduled at the end of qdisc_run_end() when q->empty
> is false to avoid packet stuck problem.
> 
> The performance for ip_forward test increases about 10% with this
> patch.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---

I can confirm the ~10% IP forwarding throughput improvement brought by
this patch, but as you might be aware, there was a previous attempt to
add qdisc bypass to pfifo_fast by Paolo Abeni:
https://lore.kernel.org/netdev/661cc33a-5f65-2769-cc1a-65791cb4b131@pengutronix.de/
It was reverted because TX reordering was observed with SocketCAN
(although, presumably it should also be seen with Ethernet and such).

In fact I have a setup with two NXP LS1028A-RDB boards (which use the
drivers/net/can/flexcan.c driver and the pfifo_fast qdisc):

 +-----------+                      +-----------+
 |           |                      |           |
 | Generator |                      |     DUT   |
 |           |--------------------->|           |
 | canfdtest |           reflector  | canfdtest |
 |           |<---------------------|           |
 |    can1   |                      |    can0   |
 |           |                      |           |
 +-----------+                      +-----------+

where reordering happens in the TX side of the DUT and is noticed in the
RX side of the generator. The test frames are classic CAN, not CAN FD.

I was able to run the canfdtest described above successfully for several
hours (10 million CAN frames) on the current net-next (HEAD at commit
34bb97512641 ("net: fddi: skfp: Mundane typo fixes throughout the file
smt.h")) with no reordering.

Then, after applying your patch, I am seeing TX reordering within a few
minutes (less than 100K frames sent), therefore this reintroduces the
bug due to which Paolo's patch was reverted.

Sadly I am not knowledgeable enough to give you any hints as to what is
going wrong, but in case you have any ideas for debug, I would be glad
to test them out on my boards.
