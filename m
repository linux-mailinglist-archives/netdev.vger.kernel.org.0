Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA8C113C14
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 08:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbfLEHAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 02:00:20 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39064 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfLEHAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 02:00:20 -0500
Received: by mail-lf1-f66.google.com with SMTP id c9so1105433lfi.6
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 23:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M4R25n+NFI6dzkagis61QtJcpRHJ07Ev/vgV9AeTqwk=;
        b=PIJ/ElYnaEo2CuNI6kc5muiwqow1o3Q508XFWb5itjF2G3HwVrenrcubyCrR/7vEpq
         HqvxGLNLzuHx6vMz+HWhVtsPPyZbGhpkiqtlpBpry/bDzvSPhqRBy6n/7BqtmUhqpiSA
         rB3/iPHEU4/3Q3+MC5szkY/PSoXzTAqTw9CBl/Bj0fhFAflPFQLS4EazZE/wy7jqSu3Y
         hOqBZCfNJ6BZnYg7QHp61BEXtjz9Wi0NPXD+yDxCTaxg71T9jz1gTsghm/bFqLdCvIn2
         w3wV1odx61tzKEbejyaiWhcsOdib1AXa8fZwY3iQw1k0MZB+ncpVCgO8o2OcwOtB0s3b
         13Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M4R25n+NFI6dzkagis61QtJcpRHJ07Ev/vgV9AeTqwk=;
        b=nVXhboU6rW3jje5txgXIl03xs9whLocGx6z09ns2sMLP01p+01yHrlyRfE8CPP3rLH
         MvVL5WDU8cHExzAzd+omMxwN8aDqZ2BQ9rtdveKj5hHkqNexEGZBXilkPTSBvbXIrLFA
         EYOS4plEy8zmbGTlZM4goctd0PVOcD/IjD1UcPV/JFW8yVRccjhkqoAmzhzA1rZLKeNx
         BKzK9nKmaIe04/Ys1jl4P9EJNLkoQTCG+i08k3/Q4zpfhQT/VnK1Y9utzX5jE6Ctph7h
         FO7rZ3fSTt8M4sT5XILZDPblJ5wziB8w/Jj17yBRg2dzpVll4SdeOOBLgBDIMytyC0TM
         VY4Q==
X-Gm-Message-State: APjAAAWYvwHvcJIgcOXldktR/v4m+/9OPGkWAcg/g8jVnXk9GFjWRmFI
        GvSUCI9ZQOgKf03zxJgMPreBSZvvJzWLfnhGYvc=
X-Google-Smtp-Source: APXvYqz3BrgT+SG6TgG65JovOHduYrJCW8ZcnXJa+7ktestrLSyvNxXu0nsS5s5KV+xAjhfLLBk7dBtbCUnSodwrBEs=
X-Received: by 2002:a19:ac08:: with SMTP id g8mr4619376lfc.112.1575529217664;
 Wed, 04 Dec 2019 23:00:17 -0800 (PST)
MIME-Version: 1.0
References: <20191130142400.3930-1-ap420073@gmail.com> <CAM_iQpXG-3XBxKxPR5s8jyZEZthaBaG73No3DOqr78aWNn1c3w@mail.gmail.com>
In-Reply-To: <CAM_iQpXG-3XBxKxPR5s8jyZEZthaBaG73No3DOqr78aWNn1c3w@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Thu, 5 Dec 2019 16:00:06 +0900
Message-ID: <CAMArcTX_ZipVe8U5Y7icj-WmmSng7apjjUUJdJAYh-HBLRhGRg@mail.gmail.com>
Subject: Re: [net PATCH] hsr: fix a NULL pointer dereference in hsr_dev_xmit()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        treeze.taeung@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Dec 2019 at 02:30, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>

Hi Cong,

> On Sat, Nov 30, 2019 at 6:24 AM Taehee Yoo <ap420073@gmail.com> wrote:
> >
> > hsr_dev_xmit() calls hsr_port_get_hsr() to find master node and that would
> > return NULL if master node is not existing in the list.
> > But hsr_dev_xmit() doesn't check return pointer so a NULL dereference
> > could occur.
> >
> > In the TX datapath, there is no rcu_read_lock() so this patch adds missing
> > rcu_read_lock() in the hsr_dev_xmit() too.
>
> Just a correction:
> The TX path _has_ RCU read lock, but it harms nothing to take it again.
>
> [...]
> >
> > Fixes: 311633b60406 ("hsr: switch ->dellink() to ->ndo_uninit()")
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>
> This fix is correct. There is no other way to workaround this RCU
> rule, checking against NULL is the only way to fix RCU reader
> races, so:
>
> Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
>
>
> Taehee, you might have to resend this with my Acked-by as David
> probably already drops it from patchwork.
>
> Thanks.

Thank you so much for your detailed reviews.

I will send a v2 patch that will not include unnecessary rcu_read_lock().

Thank you!
Taehee Yoo
