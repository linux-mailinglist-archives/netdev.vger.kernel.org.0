Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DDE42C67B
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 18:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhJMQgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 12:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhJMQgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 12:36:18 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DDEC061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 09:34:15 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id s64so7782717yba.11
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 09:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DeyYbhUS+AjxGWZarbqgE2+/okvzP0KfFw8DwH8Aemo=;
        b=V2Ng7u0J94dDLnzkkFUMfvHtJ8xWZceCiQbDmDo1W+Zjo+YIIhNqXMHFyv9IqD0aLp
         qp+nh5it6O4zzedX1zmldl/I01wCCOU45/2dj5sOsC3KhRfOMYMbevq1NC98/p+W/jx4
         0nIRgvRK7U8b3YuDGwZo3Eg8xXZ55rdpZYZLXCW6gnmvbEqYRj+WKUg0oIgaxdaRVFs4
         S/s/gdRGXzbgs8tx47ZR+d0HMQwRAV0dExP6m3yR6SOPib7P9phsrwxci+qoxZ0MV+Dc
         zVEj4iT4Bw+s8RmeP3oHshl5cA3xtK8QDJ4UgXw6iUurBfR4epc1WZ3UyEfv/uQntiIL
         jarw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DeyYbhUS+AjxGWZarbqgE2+/okvzP0KfFw8DwH8Aemo=;
        b=kTYKjY+fNJxPhJvjcQfT/JF+uBGQgieGcgA1dlx+dOtsafi/q52xxSDWrSsiQHOBHN
         l/iI6/RwJPwannwp+13RCgJPX0ft4nEDXCQlgI875kRTPvhczXXWCaWbgeh6wsc0lXX5
         OfJE/Xzt2g6uJ4Q8OVdNKoFd0oTfgsUb9XZnv9lK+IX81I0VnTy1c7rKHT9cH1DUHGDj
         9wjU908BPSi7pnH49Q+dAy99+ZsxTm4iux8t/nyQH2ETTX4L+0OP181ll/GM4zfVqLUL
         dz806/fWwAa4PvWXNjxFHoGqQLlurCAZmZnTtWrSngGKLYMKR/Tj5hzENwtyO/nlcs0/
         07ew==
X-Gm-Message-State: AOAM530suFcfD4yZUXDcGaDMZIViAzP9BIhtdj8xgn0OLdJd4vpwR1Ti
        vOvkJ/uzmW8mmSlxS27bLdAViwygGwoUckydrbI=
X-Google-Smtp-Source: ABdhPJxPV3MjzO4xA58qFpGZVNbdwYaepRZHoHaMGi8hEnVvHfBvjY1JKOeARnNjUC1s3/nVJhtUoVC81wBeHaUQBPs=
X-Received: by 2002:a25:81c8:: with SMTP id n8mr347183ybm.371.1634142854293;
 Wed, 13 Oct 2021 09:34:14 -0700 (PDT)
MIME-Version: 1.0
References: <20211007175000.2334713-1-bigeasy@linutronix.de> <20211007175000.2334713-3-bigeasy@linutronix.de>
In-Reply-To: <20211007175000.2334713-3-bigeasy@linutronix.de>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 13 Oct 2021 09:34:04 -0700
Message-ID: <CAM_iQpV6GSACiROjD2jEUMXHWNbK9v+NuST5stFRNKoRHc9EXQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] gen_stats: Add instead Set the value in __gnet_stats_copy_basic().
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 7, 2021 at 10:51 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> Since day one __gnet_stats_copy_basic() always assigned the value to the
> bstats argument overwriting the previous value.
>
> Based on review there are five users of that function as of today:
> - est_fetch_counters(), ___gnet_stats_copy_basic()
>   memsets() bstats to zero, single invocation.
>
> - mq_dump(), mqprio_dump(), mqprio_dump_class_stats()
>   memsets() bstats to zero, multiple invocation but does not use the
>   function due to !qdisc_is_percpu_stats().
>
> It will probably simplify in percpu stats case if the value would be
> added and not just stored

You at least need to rename it before doing so, otherwise "copy"
would be too confusing.
