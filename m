Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06D5345D1B
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 12:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhCWLjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 07:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhCWLjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 07:39:05 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F085C061574;
        Tue, 23 Mar 2021 04:39:04 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id o19so23041088edc.3;
        Tue, 23 Mar 2021 04:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jZEbmfttLy3hxtdAr+dWinOsJlVvQOo8eMPCthQyYx8=;
        b=WLK+Gfk+uqjZb1BEdRruN14Mhyc0QKcVwyQyzUOv/jzxtBCFlZ5s7S59TcIozAaUZ5
         KTmE1wTnynzi1EMEBE66v04xOxmgUeXULmKosmIUOc2BYYDFa/pJTwUmJ660GcaFMc1G
         1Xh+h3O5y0Gyw3uNhJPiWwyKlmeIimElNR1kturX8bDc/SWRnBpd0RbK8vGoodBIk65D
         xoVGvEgsgqhdjPItnlELZqmm6bis0sFKr6l2akq4SDzF4k+MyUxjTE4jUjdx0VGr4XYz
         E0QTg3L7BUkQhYZnTQ0PPCaENXQP+6R4Z2s5dxu5LRaZhRfbEGzaILUDJPdyryJ07Xom
         rYFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jZEbmfttLy3hxtdAr+dWinOsJlVvQOo8eMPCthQyYx8=;
        b=qqW2lyJS+BL8fQ+cCDM7xPGdlrfK0t/MHiQAV8JJKYqfmqpq07uL7YhVzcQf251bzS
         jj1sA9s7UAjaEkpRW2IwCAlHD5JaG1XkoJaXZB/+fWp7V/FHKw9bahllhF/dC9vzNUd2
         /aiIEmAseOqUb5gipIYVukhUOXJYOjvS20SZgaypNkZDcgEKAuaifVQeba4OzZk0+xKg
         5bJf9EBrD5N0vtRZT9cJt8Xy+dQguaU2yn1lMp1Y8o8UlTD5P7PRN5QjviK2c84JwBvV
         bv1k1BS9DvPbz6ZroxIcpzlMNbLMTHgsb50akDX7xazsHf2L2eoDk5TNAcEgAknlfsay
         pmyQ==
X-Gm-Message-State: AOAM533l+QdIX8YEHY3BX17FX4gjYD/Yd603cB5E43KmvSQ/BJva6z3A
        oBQZTnb4/fsaIMqKdEfYme0=
X-Google-Smtp-Source: ABdhPJyvM8sZ2HxxLnaSFbl3FSA0OWpEveX5TatAnyoxtllLUvh8hWpLlu2JtxEFkYmmpLDifqBfEw==
X-Received: by 2002:a05:6402:430c:: with SMTP id m12mr4298114edc.138.1616499542819;
        Tue, 23 Mar 2021 04:39:02 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id br13sm10875159ejb.87.2021.03.23.04.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 04:39:02 -0700 (PDT)
Date:   Tue, 23 Mar 2021 13:39:00 +0200
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
Message-ID: <20210323113900.g3c2mg5z4elamyz3@skbuf>
References: <1616050402-37023-1-git-send-email-linyunsheng@huawei.com>
 <1616404156-11772-1-git-send-email-linyunsheng@huawei.com>
 <20210322200033.uphemtsunfqsvjej@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322200033.uphemtsunfqsvjej@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 10:00:33PM +0200, Vladimir Oltean wrote:
> Hi Yunsheng,
> 
> On Mon, Mar 22, 2021 at 05:09:16PM +0800, Yunsheng Lin wrote:
> > Currently pfifo_fast has both TCQ_F_CAN_BYPASS and TCQ_F_NOLOCK
> > flag set, but queue discipline by-pass does not work for lockless
> > qdisc because skb is always enqueued to qdisc even when the qdisc
> > is empty, see __dev_xmit_skb().
> > 
> > This patch calls sch_direct_xmit() to transmit the skb directly
> > to the driver for empty lockless qdisc too, which aviod enqueuing
> > and dequeuing operation. qdisc->empty is set to false whenever a
> > skb is enqueued, see pfifo_fast_enqueue(), and is set to true when
> > skb dequeuing return NULL, see pfifo_fast_dequeue().
> > 
> > There is a data race between enqueue/dequeue and qdisc->empty
> > setting, qdisc->empty is only used as a hint, so we need to call
> > sch_may_need_requeuing() to see if the queue is really empty and if
> > there is requeued skb, which has higher priority than the current
> > skb.
> > 
> > The performance for ip_forward test increases about 10% with this
> > patch.
> > 
> > Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> > ---
> > Hi, Vladimir and Ahmad
> > 	Please give it a test to see if there is any out of order
> > packet for this patch, which has removed the priv->lock added in
> > RFC v2.
> > 
> > There is a data race as below:
> > 
> >       CPU1                                   CPU2
> > qdisc_run_begin(q)                            .
> >         .                                q->enqueue()
> > sch_may_need_requeuing()                      .
> >     return true                               .
> >         .                                     .
> >         .                                     .
> >     q->enqueue()                              .
> > 
> > When above happen, the skb enqueued by CPU1 is dequeued after the
> > skb enqueued by CPU2 because sch_may_need_requeuing() return true.
> > If there is not qdisc bypass, the CPU1 has better chance to queue
> > the skb quicker than CPU2.
> > 
> > This patch does not take care of the above data race, because I
> > view this as similar as below:
> > 
> > Even at the same time CPU1 and CPU2 write the skb to two socket
> > which both heading to the same qdisc, there is no guarantee that
> > which skb will hit the qdisc first, becuase there is a lot of
> > factor like interrupt/softirq/cache miss/scheduling afffecting
> > that.
> > 
> > So I hope the above data race will not cause problem for Vladimir
> > and Ahmad.
> > ---
> 
> Preliminary results on my test setup look fine, but please allow me to
> run the canfdtest overnight, since as you say, races are still
> theoretically possible.

I haven't found any issues during the overnight test and until now.

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com> # flexcan
