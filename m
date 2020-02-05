Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40EC715372F
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 19:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgBESD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 13:03:57 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:41708 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbgBESD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 13:03:57 -0500
Received: by mail-ot1-f66.google.com with SMTP id r27so2778090otc.8;
        Wed, 05 Feb 2020 10:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Ih9RtrHu8vyKZeW7+8zC+TiPKZDe2wMByy4RUVTScM=;
        b=iEKfi2AYJiouQ7kp8rw6kG+k5CLo0wRLc2VYQrSayux0UNtwBZua1UtoUQAowKJoFn
         8zpUZQxzHr9leLUWG2Vga0At8tOuOZR5Xu1UwmavytUKcOBMkajAyhozcd/J9z0jhT+e
         U9Y+ovDy0LzbF/gh9xlsWgPO8WLcJLLxg/Fn2goHekT0h90f1sz1WsRFA443kYTq4GjN
         wpdRM/p11funU7cUtGwQg5XbbG0cqalsWcKAYhXSvU140aRe2XX4x56UCVfLw3k2xk7a
         X+qq1onVgT5Q/M6pypEalZ+DjAERrXz9CAhR2XqSvKsgU3uQZA8oXMMqIwdlNDYfL38S
         8vew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Ih9RtrHu8vyKZeW7+8zC+TiPKZDe2wMByy4RUVTScM=;
        b=l69dl8NdYWGbfnETEsd+wvJOE+9rRwHlH0XeOBtkFr1J2kxUwRnTfqaKuAHV2io1xy
         BRjEw8eQXJDNN43K+ci61LHd3yMVRk5XHA4K8NSnn2loZfxRHTxHH38FLuAqpSdw0Eoo
         iaJQrz8JCSJURVElbTGGnYUmgvgJ6CpuG/4UCWQiZUQ8LgdzZIYjfDtMel2EEgT/wTNJ
         qgzVZ0BFj8PatJH6oP5oIrU4S+MkBC1rbJHvdtPpHijWOuA8wWFYvyjFkF2fuTKFWQII
         Trq6drRPgdsvV1TSFe+9bwWN4RJU6OyIYcE1mLec77g+Ci1x1p6hn+5Q7tkQB6fCzgg/
         IOqw==
X-Gm-Message-State: APjAAAXKUvtTrUfLSs+IV51CJL6+6fbj6L3DybZRxZNA6K9Jr9Ua1hS8
        Xm5jkrQAM2fkeyw28EUTlutWlgtxmzf13otNthH8q/a+
X-Google-Smtp-Source: APXvYqybQKNOX1bnc4wfXLCFX2pHg77AqPgQqonzSogFrNOx3kCejlWYeJCVcTIXcv8h3Dnpv+rZmJvRTbU4F44IZVI=
X-Received: by 2002:a9d:7559:: with SMTP id b25mr26032956otl.189.1580925836460;
 Wed, 05 Feb 2020 10:03:56 -0800 (PST)
MIME-Version: 1.0
References: <CAM_iQpVrckjFViizKZH+S=8GC_3T5Gm1vTAUeFkpmqJ_A66x1Q@mail.gmail.com>
 <20200205115330.7x2qgaks7racy5wj@kili.mountain>
In-Reply-To: <20200205115330.7x2qgaks7racy5wj@kili.mountain>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 5 Feb 2020 10:03:45 -0800
Message-ID: <CAM_iQpWKQ+59GfAP8RTntEM55FC7AYvZgo_hhPXNMbxCpo-c=g@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: sched: prevent a use after free
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        "V. Saicharan" <vsaicharan1998@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Sachin D. Patil" <sdp.sachin@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 5, 2020 at 3:56 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> The bug is that we call kfree_skb(skb) and then pass "skb" to
> qdisc_pkt_len(skb) on the next line, which is a use after free.
> Also Cong Wang points out that it's better to delay the actual
> frees until we drop the rtnl lock so we should use rtnl_kfree_skbs()
> instead of kfree_skb().
>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks!
