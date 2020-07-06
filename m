Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0542A215240
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 07:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgGFFk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 01:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbgGFFk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 01:40:29 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A12C061794;
        Sun,  5 Jul 2020 22:40:29 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id v6so24392789iob.4;
        Sun, 05 Jul 2020 22:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3sBadRV7FFtFvYs75qslugpz7Oyujs0hv8LXW+77v68=;
        b=uRYZhSZJ13+CNC2XFKVKruTQ/BZz390wUvNAzm5zyT0VSuXmqzENCGYj5KjBe2aHEv
         PXBIIRgjDXJjuIab5cFWZCjelD/kHsYOniAepCT3wWkyv+PQCccKlZqHww1ikqlFoHlC
         /sj36qC3LZz/KJALxwKVt9EeiYAdg9DFHxh1Jmj1fzZBOtIZf42ToKVrzCDU0XFqux5M
         vG+glKJLKfhNscARLY+zOZkdo7l5bC3VhPNlu2MHoP8SJDdA5/SnhWYw98aw2EIzreiN
         Fh6E0Hk0YkZWoWnOnaabJg4PY1TutzYec1QR/7GlT3IuhWsGppkMn5oxXi02Z2o3YCnn
         xPFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3sBadRV7FFtFvYs75qslugpz7Oyujs0hv8LXW+77v68=;
        b=qhXEvy2luaJH6RY04iPAzU+qtEB+T2MvHlr9UR4U52NTjVCgAkSa3TgzJ8ULF8+wDd
         FhUp6wrcETvn9DqUSQrmZlAMpg90ZOYwxIzTYpAmYQWbTEF3kdHRpCKkG+ud0FmsWYuk
         t1jMJAu9mdd7+V1uavhv3/zwHl07o/FVXJbfDu9issOQkL3DzIfermQFGa44mAFMIYFR
         sK7+pEiM39t9AyR0Ff5gWnYTMwTlREFSrvnYsepbAKx6j3lOpQwkatNqubVRy4+W7MIq
         s/q4qS0spzREilyTfUAvbrfKL5edAVapjshIoWozCQrBa3RtD4sQplIdEIpij7T2o5M6
         VDeg==
X-Gm-Message-State: AOAM5330DLfFgYZGjVtMJb0poGLWvtlNUlgEnHBSRtEbv5x0omLHUkFO
        B4k2AfORBcFeDwb5seqHt+R1oLQtwPChZRgFFGlNHCW/
X-Google-Smtp-Source: ABdhPJz/+RVTdWmd5r5KJu7Of7dDt/ath/o+DCbUw40LALWdyp/OMjAYJOmlHjuRVjw6ggeeL///zp147GWcDfVEBts=
X-Received: by 2002:a05:6602:1225:: with SMTP id z5mr24075647iot.64.1594014028358;
 Sun, 05 Jul 2020 22:40:28 -0700 (PDT)
MIME-Version: 1.0
References: <1593959312-6135-1-git-send-email-wenxu@ucloud.cn> <1593959312-6135-2-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1593959312-6135-2-git-send-email-wenxu@ucloud.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 5 Jul 2020 22:40:17 -0700
Message-ID: <CAM_iQpWmM8bJ5up47gt06VpoSrP6YVd=RZO2HTD0quXtQkRyxg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] netfilter: nf_defrag_ipv4: Add
 nf_ct_frag_gather support
To:     wenxu <wenxu@ucloud.cn>
Cc:     David Miller <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 5, 2020 at 7:34 AM <wenxu@ucloud.cn> wrote:
> +static int nf_ct_frag_reinit(struct ipq *qp)
> +{
> +       unsigned int sum_truesize = 0;
> +
> +       if (!mod_timer(&qp->q.timer, jiffies + qp->q.fqdir->timeout)) {
> +               refcount_inc(&qp->q.refcnt);
> +               return -ETIMEDOUT;
> +       }
> +
> +       sum_truesize = inet_frag_rbtree_purge(&qp->q.rb_fragments);
> +       sub_frag_mem_limit(qp->q.fqdir, sum_truesize);
> +
> +       qp->q.flags = 0;
> +       qp->q.len = 0;
> +       qp->q.meat = 0;
> +       qp->q.rb_fragments = RB_ROOT;
> +       qp->q.fragments_tail = NULL;
> +       qp->q.last_run_head = NULL;
> +       qp->iif = 0;
> +       qp->ecn = 0;
> +
> +       return 0;
> +}
> +
> +static struct ipq *ip_find(struct net *net, struct iphdr *iph,
> +                          u32 user, int vif)
> +{
> +       struct frag_v4_compare_key key = {
> +               .saddr = iph->saddr,
> +               .daddr = iph->daddr,
> +               .user = user,
> +               .vif = vif,
> +               .id = iph->id,
> +               .protocol = iph->protocol,
> +       };
> +       struct inet_frag_queue *q;
> +
> +       q = inet_frag_find(net->ipv4.fqdir, &key);
> +       if (!q)
> +               return NULL;
> +
> +       return container_of(q, struct ipq, q);
> +}


Please avoid copy-n-paste code by finding a proper way
to reuse them.

Thanks.
