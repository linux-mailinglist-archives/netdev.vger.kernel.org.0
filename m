Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7E233B2C4
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 13:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhCOMaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 08:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhCOM3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 08:29:37 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3BFC061574;
        Mon, 15 Mar 2021 05:29:37 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y6so17037344eds.1;
        Mon, 15 Mar 2021 05:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bmo3FJ8csak/QnMLR8JXQoCMntdn2N3SzK9/Z2lT2ms=;
        b=r5jYthIq3Bj6AREUlJAs6Y70biyD/OB18aTicA83x3+QaOpN2Jtu9EftxeQrocIUGp
         0v4u6IgEDvbI94OEGmEe0ovmLck7pJpoP42tnxbDI7o7BMhVA+jOUlJge6hSTv//fGUo
         /3QL2ohP6AT4/XLkiLCa7ZBdMg1A2UJVTi0Gqxl43dpeSQZ7LUNuiJH8CwrXszndPZ/E
         uqlxAM+cKCZsvPf/MHosBCwP2tWzcSwVFy4WSKitva9tubTl2dZEPGvQCRylM7wAljKr
         C+F3+pOlR9o54mCC5vAYo8Qe3JfWLtSQJBG620GhSDf1X4xy21JnHt6I30zRokM7C0ht
         gU1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bmo3FJ8csak/QnMLR8JXQoCMntdn2N3SzK9/Z2lT2ms=;
        b=cZCA8pTzS2SV4R5DLGexfpbZIV/dJ8MGOBEbLzn9gSCq3pc1wAScro7TgLWQVJXuzD
         T/4OW/rKzeOGE0f12o7VEzvbYDPKTpDtlBI95jZl+YibjmqCWEnzcvwuvM1GymuEXe7o
         cP+nG1SfjSfT9BwYM1LaFkxRajZgz5PR4quxJM8mW0y49I8JP7lquAPUis6/2eecUItn
         HTnaFtv1hm8HLmxVPrT2TEKoQGKhFy+vYwtkGgI9+ALdPJvLTZ0sEtaYHrGFMZvZSrK6
         QUlqDXnuUnyZGF0wpx9dwvzFrAnA/fvcDBeAaKDuPqw6XmtRm/PogTb4gakgyuhns+jz
         N4iw==
X-Gm-Message-State: AOAM530dHjk+sB3E3KNHOqC2CKZPaBNRRrDtQitCxgT6jKqFOzMG7yj3
        HJmWMRxJ767M8Q42R4hwC8s=
X-Google-Smtp-Source: ABdhPJyjpnW7syWZkacQhfcXWmmJqvng2FK/I3UK1wdkCO+9ycRiapR8J7XafMHb4satgxjWRZAaZA==
X-Received: by 2002:a05:6402:10c9:: with SMTP id p9mr29884574edu.268.1615811376306;
        Mon, 15 Mar 2021 05:29:36 -0700 (PDT)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id e18sm7097706eji.111.2021.03.15.05.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 05:29:36 -0700 (PDT)
Date:   Mon, 15 Mar 2021 14:29:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andriin@fb.com, edumazet@google.com,
        weiwan@google.com, cong.wang@bytedance.com, ap420073@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@openeuler.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org
Subject: Re: [RFC v2] net: sched: implement TCQ_F_CAN_BYPASS for lockless
 qdisc
Message-ID: <20210315122934.kano66d67uqmrr4t@skbuf>
References: <1615603667-22568-1-git-send-email-linyunsheng@huawei.com>
 <1615777818-13969-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615777818-13969-1-git-send-email-linyunsheng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 11:10:18AM +0800, Yunsheng Lin wrote:
> Currently pfifo_fast has both TCQ_F_CAN_BYPASS and TCQ_F_NOLOCK
> flag set, but queue discipline by-pass does not work for lockless
> qdisc because skb is always enqueued to qdisc even when the qdisc
> is empty, see __dev_xmit_skb().
> 
> This patch calls sch_direct_xmit() to transmit the skb directly
> to the driver for empty lockless qdisc too, which aviod enqueuing
> and dequeuing operation. qdisc->empty is set to false whenever a
> skb is enqueued, see pfifo_fast_enqueue(), and is set to true when
> skb dequeuing return NULL, see pfifo_fast_dequeue(), a spinlock is
> added to avoid the race between enqueue/dequeue and qdisc->empty
> setting.
> 
> If there is requeued skb in q->gso_skb, and qdisc->empty is true,
> do not allow bypassing requeued skb. enqueuing and dequeuing in
> q->gso_skb is always protected by qdisc->seqlock, so is the access
> of q->gso_skb by skb_queue_empty();
> 
> Also, qdisc is scheduled at the end of qdisc_run_end() when q->empty
> is false to avoid packet stuck problem.
> 
> The performance for ip_forward test increases about 10% with this
> patch.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> RFC V2: fix requeued skb out of order and data race problem.
> ---

This is great. Looks like requeued skbs bypassing the qdisc were indeed
the problem. I ran my stress test for 4:30 hours (7.7 million CAN frames)
and all were received in the same order as canfdtest enqueued them in
the socket.

I'll let the test run some more, just thought I'd let you know that
things are looking good so far. I'll leave you a Tested-by when you
submit the final version of the patch as non-RFC.
