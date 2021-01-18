Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDDF2FA9CC
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 20:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437185AbhARTML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 14:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437010AbhARTLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 14:11:01 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505A0C061573;
        Mon, 18 Jan 2021 11:10:21 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id md11so10154883pjb.0;
        Mon, 18 Jan 2021 11:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fIoE9ZSaYkpJGi0GT5QkJHuOj+rXTG6tlaDVABvyvH4=;
        b=GOxOSdjccLxaxH11f7DKPAiMK55ZGi6KaQJfolquimpTjT8qJIB7Aw2zuA0D0nJimo
         TjgNqvboJRn/nQLnoUVbnwG0t4p+gRjZHeBnlEgXSLmd13u8YlrFvMMQ1Ptlh1v39m6k
         QOtby3fg2Ga4yGbYyDk6LnC6+LQMhofUNYRlygM77aB/59jfy2AKYDHncHtZ/SvKjXVt
         2IbupZPLjT94prnLSFkXr8DMenmpB/jIDwbHfvxYuDM+wjzslz55aiKv7MXgm8Pky9im
         nLcv5CgtzymL0VGzghLVnwnfB5rdeyq9vST715jc84/Xc/l7dxmf1Pq1NCaQmMgSrW34
         4glw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fIoE9ZSaYkpJGi0GT5QkJHuOj+rXTG6tlaDVABvyvH4=;
        b=MtX5V/uUVYMLRe/E66NQcdX+551j1wBD08Psd6bU/0wmeBeCP+OMwCtnVgzJQkZCKP
         YdsQwqHpPCELvwohrbualSkR9I28A3vuvR+H4R7g2EXYe4+Pq9JIZSgt+UdVuFcLYMfc
         ldkDgHVi/o8lbf+de0hPUnkUHXfeVlRxDon3W+7KmdA6FzQHn8dzgCLQzlQBHXaIsxCh
         XbFKwm7bFh9dKembPR1iB155/rCLDl1V4h7SOxzn6MuNGKg2UNvCUIBUXic+fS6Z2ZaT
         NOKkb8O0nLDFz5NBo3SUx31UtRQosU5d9TDGXBSMyIT1Yu00kRx6CCU5Q+wmbk+TT5BR
         8V7A==
X-Gm-Message-State: AOAM531uL46TZ1kMkpWoXHTSxWxj2wBHS7U7KxaqrBRqWxww9FkGYjPu
        yCehewMKnbRjR5EyFaVSODsJpg7hoDT7TIIG9PMyhnQ9TWA=
X-Google-Smtp-Source: ABdhPJyJBq0XC4fI/KJeSddzO2kPFjXGg1RVheQiyZciHPF7tKpuRFBZ2x4dLWp1pfsfW9cxsX2qEzgpgkEIFEJdmPk=
X-Received: by 2002:a17:902:8642:b029:de:2bf1:b061 with SMTP id
 y2-20020a1709028642b02900de2bf1b061mr903082plt.10.1610997020542; Mon, 18 Jan
 2021 11:10:20 -0800 (PST)
MIME-Version: 1.0
References: <20210117042224.17839-1-xiyou.wangcong@gmail.com> <20210117042224.17839-2-xiyou.wangcong@gmail.com>
In-Reply-To: <20210117042224.17839-2-xiyou.wangcong@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 18 Jan 2021 11:10:09 -0800
Message-ID: <CAM_iQpXha9ZGyszHUR3qs21p+awGtrioEmxba7XOYkpm8dsXGw@mail.gmail.com>
Subject: Re: [Patch bpf-next v4 1/3] bpf: introduce timeout hash map
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 8:22 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> +static void htab_gc(struct work_struct *work)
> +{
> +       struct htab_elem *e, *tmp;
> +       struct llist_node *lhead;
> +       struct bpf_htab *htab;
> +       int i, count;
> +
> +       htab = container_of(work, struct bpf_htab, gc_work.work);
> +       lhead = llist_del_all(&htab->gc_list);
> +
> +       llist_for_each_entry_safe(e, tmp, lhead, gc_node) {
> +               unsigned long flags;
> +               struct bucket *b;
> +               u32 hash;
> +
> +               hash = e->hash;
> +               b = __select_bucket(htab, hash);
> +               if (htab_lock_bucket(htab, b, hash, &flags))
> +                       continue;
> +               hlist_nulls_del_rcu(&e->hash_node);
> +               atomic_set(&e->pending, 0);
> +               free_htab_elem(htab, e);
> +               htab_unlock_bucket(htab, b, hash, flags);
> +
> +               cond_resched();
> +       }
> +
> +       for (count = 0, i = 0; i < htab->n_buckets; i++) {

I just realized a followup fix is not folded into this patch, I
actually added a timestamp check here to avoid scanning the whole
table more frequently than once per second. It is clearly my mistake
to miss it when formatting this patchset.

I will send v5 after waiting for other feedback.

Thanks!
