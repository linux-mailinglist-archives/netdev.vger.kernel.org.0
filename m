Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1209833DCB6
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237241AbhCPSmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbhCPSlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 14:41:40 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35B5C06174A;
        Tue, 16 Mar 2021 11:41:39 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 18so9429103pfo.6;
        Tue, 16 Mar 2021 11:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1LsuKaONtTkRfqGPcyI045IeBZRuFxo9057hwlVxGB8=;
        b=c5tx2uRwSqjf4JqGSueVbn8FxluuV5CsctUBo+txrZJm3mUNKfJm6eseAjI+hWK6HD
         Jb6BpT24VMuR/nwtPq6eYA9sX8HBsFsxcfB/XWH/oIHBCjspSOZU9/pnFeuZ+pxWwJqN
         xy8jTDRXCGawyo6AepmAK2o5mdhXYTbfEtxKdCJ4AV+oCoTrO/I8iK6ZCJwSFr4yUgsk
         1RnYJ5m0Cct/1uQkjnj+I71FoUqKXlwZdDQ9XBQsXlPN+AL0ikUPJi03V/QYX6l0lB/P
         fO6MVV9fpE9qlDNyT4q0x/TPENRRUf1Z9kWZ6qBUIQAKHL3JodSI4pe9uRFU+RZwDuqy
         gzYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1LsuKaONtTkRfqGPcyI045IeBZRuFxo9057hwlVxGB8=;
        b=tabjHpIwNUrmbYULzSeWz7tue/8Vzwes61K8V0Ab3ECnCpvAO4TNUidmXgwFGCt6kO
         wiDANbvdDIWxyJgUVc0PiwUbESIdUH/iozJ+AJ5oq65LnwYvg1mdJ18gZf1RZ7wuLN9S
         CxI4duAnw+g+bB4ZbxByTEg++fZuv+LLSy8aIcRPRwQA1PchWiNkPk040dBzeZkcKOcg
         ykZ3Z9scHBZN/Hw7X7QzbSsIN2xn5jqjl1PgdUz8mM2Z6ogyc1DZx1Yq1ZUSVzm2DGTb
         +ss56mIzzvapiTKyOA4gfETt7aJWq+7vAQn6aVhPnmcYZ+5TSQn0WehowTOnrcQb59Sv
         140g==
X-Gm-Message-State: AOAM531ss8IaAGzySE3XuobWa1f4TD3ILd0DPzzX+ZlwP29CPzgrASfn
        fC2hqsuvijkFGZI5Henl+QNONyCryceGvAvc0Cs=
X-Google-Smtp-Source: ABdhPJz1QLJiX0jVTh0D2aZJZHxm4rxojewAyFQRvPT/TQfn2DZYKWihd29lqOlLA325oH2vtfBGMThaYygRKZ6WtjM=
X-Received: by 2002:a63:1266:: with SMTP id 38mr909777pgs.266.1615920099302;
 Tue, 16 Mar 2021 11:41:39 -0700 (PDT)
MIME-Version: 1.0
References: <1615800610-34700-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1615800610-34700-1-git-send-email-linyunsheng@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 16 Mar 2021 11:41:28 -0700
Message-ID: <CAM_iQpXT+tS1NdpiF2M0hAocWJ90mxd5Wp8HoxkEhp4k9QM4hw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: sched: remove unnecessay lock protection
 for skb_bad_txq/gso_skb
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 2:29 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> Currently qdisc_lock(q) is taken before enqueuing and dequeuing
> for lockless qdisc's skb_bad_txq/gso_skb queue, qdisc->seqlock is
> also taken, which can provide the same protection as qdisc_lock(q).
>
> This patch removes the unnecessay qdisc_lock(q) protection for
> lockless qdisc' skb_bad_txq/gso_skb queue.
>
> And dev_reset_queue() takes the qdisc->seqlock for lockless qdisc
> besides taking the qdisc_lock(q) when doing the qdisc reset,
> some_qdisc_is_busy() takes both qdisc->seqlock and qdisc_lock(q)
> when checking qdisc status. It is unnecessary to take both lock
> while the fast path only take one lock, so this patch also changes
> it to only take qdisc_lock(q) for locked qdisc, and only take
> qdisc->seqlock for lockless qdisc.
>
> Since qdisc->seqlock is taken for lockless qdisc when calling
> qdisc_is_running() in some_qdisc_is_busy(), use qdisc->running
> to decide if the lockless qdisc is running.

What's the benefit here? Since qdisc->q.lock is also per-qdisc,
so there is no actual contention to take it when we already acquire
q->seqlock, right?

Also, is ->seqlock supposed to be used for protecting skb_bad_txq
etc.? From my understanding, it was introduced merely for replacing
__QDISC_STATE_RUNNING. If you want to extend it, you probably
have to rename it too.

Thanks.
