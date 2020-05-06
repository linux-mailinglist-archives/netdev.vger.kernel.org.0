Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D411C69F9
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 09:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgEFHXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 03:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728112AbgEFHXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 03:23:10 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4256FC061A0F;
        Wed,  6 May 2020 00:23:10 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u127so1315852wmg.1;
        Wed, 06 May 2020 00:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Jo47sb10nDmnr4eWrOUxvat9S6v5kjhKKPTH7Ufh/PA=;
        b=lVXyq7klPwDk8gR6mN9P6xSIIcU7SMpDqRG0fSYjUAtq4NtbPFttxX5gu74gv++dXg
         CAzWW1vYkJKDjDY6cpzYhxv2UJYzlYmsZUSJma4zzLMQoV95DAoTfDHBujz/dr9lsmWk
         tA0wl2R/nDUA1WvPO2qXB+uHFv5wWnT+G9mbq1jqOH/gZHFWvZaYsIY5XK78TwmoFuHS
         EoWjyVTc8ktU5Ui1w8+6C/ZJledB80ggpDN+KHLbkvdo0RuUIrGev1N8A29m8urd61Ox
         g10UAVSVFGbC1yKM7bL4Viei9ykRbEV5860sD+JqtNYQo6nnvDZHqdKzHj7S5vzoSoVp
         UwYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Jo47sb10nDmnr4eWrOUxvat9S6v5kjhKKPTH7Ufh/PA=;
        b=C8x1oBJHXc2AL9FjJzAT9dONQjss+TODHymWuZQpCJ/KtB2l3J9wjHVzZcMNod0Nsw
         kv3JqLTpSktQIiu4QPiA5hLkIAxWB+dq+/CqU8yEiiFEdfIyOah8Bzj0lm7ckVcl5gDA
         5tM5LlPHV+XFpteaEDJURS/2CPKyQZl8HpHEEkMBmrKfqt3eHSMHmr+u2bqKFCuzSI1G
         09WGPzfbVi2roYzVTO/xkZZOuBW/vSwAYL/o56cHl+fdYlGf5TmPx/wemV+HWU2/U6VZ
         oN6Sd5stozqMjm9yAxhQ/Uk5V61DmtT0Q4F5+Z1d+tpMOi/VK4MIH7rL5XjQeChFMVNv
         pzbg==
X-Gm-Message-State: AGi0PuZVO8JmJfMMs7mAQNFcfQ/Yq7x7XgvJyBS2o7C0SG5FET60CEIj
        P5vRJ0qtQehQodi+ziswXqcwh1hiwym1QXICv/0=
X-Google-Smtp-Source: APiQypJPTjMm5gqnlnZUXhZuNlKM/J10v2j7vv3DJ4BkYGuWRMSoGxBezHj3tKVI1y4jG3iqCAB8tMce7pNE1bybOLU=
X-Received: by 2002:a7b:c0d5:: with SMTP id s21mr2694611wmh.107.1588749788992;
 Wed, 06 May 2020 00:23:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200504113716.7930-1-bjorn.topel@gmail.com> <20200504113716.7930-5-bjorn.topel@gmail.com>
 <3a81f575-f617-4571-4771-84bc735db98e@mellanox.com>
In-Reply-To: <3a81f575-f617-4571-4771-84bc735db98e@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 6 May 2020 09:22:57 +0200
Message-ID: <CAJ+HfNiU_jktREYAmeq1rVAokT6XEqUeYiRw+HEPv4tUnZFc8w@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 04/13] xsk: introduce AF_XDP buffer
 allocation API
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 at 16:28, Maxim Mikityanskiy <maximmi@mellanox.com> wrot=
e:
>
[...]
> >
> > -     if (((d->addr + d->len) & q->chunk_mask) !=3D (d->addr & q->chunk=
_mask) ||
> > -         d->options) {
> > +static inline bool xskq_cons_is_valid_desc(struct xsk_queue *q,
> > +                                        struct xdp_desc *d,
> > +                                        struct xdp_umem *umem)
> > +{
> > +     if (!xp_validate_desc(umem->pool, d)) {
>
> I did some performance debugging and came to conclusion that this
> function call is the culprit of the TX speed degradation that I
> experience. I still don't know if it's the only reason or not, but I
> clearly see a degradation when xskq_cons_is_valid_desc is not fully
> inlined, but calls a function. E.g., I've put the code that handles the
> aligned mode into a separate function in a different file, and it caused
> the similar speed decrease.
>

Thanks for looking in to, and finding this!

I'll make sure the xp_validate_desc() call is inlined for the next
revision.

A note to myself: I need to check the performance for an LLVM build
with LTO enabled.


Cheers,
Bj=C3=B6rn
