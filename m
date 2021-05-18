Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF260386E7D
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 02:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345174AbhERAu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 20:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345165AbhERAuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 20:50:54 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CE0C061573;
        Mon, 17 May 2021 17:49:37 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t11so4620212pjm.0;
        Mon, 17 May 2021 17:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KH84QVoxsXQraCnrDp+zrzvkTxvsgpiKrsXZqfq/Xz4=;
        b=KxVvzeOuRabT9C0NU6Lj//HMl4gIJgKyl56J5LIEDbtHQB7HZHfUNURxtFy/ciT7Z3
         D4dgXhhFfmOWKeJGRAY4eElY+oNO3lOrsHXMrMRUkaTuERuuUNbS04rmVirWX8pWEJsK
         E/UhcI0QiQEVWNAb/HQHmG1O0WIHwssfnokcnI5isRrYDFqF5yFphUEKSGu1MoftSQFB
         ns2cICOBt0qp0sIenFO6xW5AcoL690QQZV88Vw37xQNsLxEM65BAMEPGLyZY+1MQVRJ3
         wkHvniBTdSG5B1+ZODRwNl+xoxLnpnt1x0py80k9i7swCUMDpEjDawIpbjMUVISEk+9o
         0spg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KH84QVoxsXQraCnrDp+zrzvkTxvsgpiKrsXZqfq/Xz4=;
        b=L1tQnD9plhLLH7e69DRNKfuQthbjBBR4r7p0q0uyLY8tJnbuKneWULQZFjblqd2L3m
         gO/rdPPmmqbLqL//OQrTCohjJOdmbopLhZ0gSk/8fdjen2Ooi1lOy8fQX3rf8laCacWY
         8kuQ19gblvLEnpl/RAUX5d0CDwGZKTjvNXhAIilonHbbyudpJniN2mbNHeBhsdh/Nuzg
         uMkkgfUGNLCIkTdice/JSCK6HQ1KuGdKppMFXWxDmclkvIyDVPfbpag3XyAxgEPyOlFB
         lozds5EZzmACiQzDtF4ZqeycSnI6DZAAZBl9e9NvoIpEp9bJOcMRzFUmRCjWgkHxqzs7
         OpqA==
X-Gm-Message-State: AOAM531tEXRqFe5ArOH34Q5wSOYq4D5iOdmOGf+2dO4+FVDbW68efea2
        VqEKriyWVV/8m+jb/w5fd2SXvXNwiF1kEpjD9hw=
X-Google-Smtp-Source: ABdhPJwWvoEgJOE4GgT3wa3staV8IWm+iqdKu7eWqalD/1Y98ngy1UeFpylkhuNX/GV4CY4PdSN6Bc4wsXAIRZqf+oc=
X-Received: by 2002:a17:902:a60a:b029:f0:ad94:70bf with SMTP id
 u10-20020a170902a60ab02900f0ad9470bfmr1434578plq.31.1621298976622; Mon, 17
 May 2021 17:49:36 -0700 (PDT)
MIME-Version: 1.0
References: <1620959218-17250-1-git-send-email-linyunsheng@huawei.com>
 <1620959218-17250-2-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpXWgYQxf8Ba-D4JQJMPUaR9MBfQFTLFCHWJMVq9PcUWRg@mail.gmail.com>
 <20210514163923.53f39888@kicinski-fedora-PC1C0HJN> <CAM_iQpXZNASp7+kA=OoCVbXuReAtOzHnqMn8kFUVfi9_qWe_kw@mail.gmail.com>
 <20210514171759.5572c8f0@kicinski-fedora-PC1C0HJN> <def859b3-b6ea-7338-38eb-3f18ec3d60c2@huawei.com>
In-Reply-To: <def859b3-b6ea-7338-38eb-3f18ec3d60c2@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 17 May 2021 17:49:25 -0700
Message-ID: <CAM_iQpWSvbTzhj5+OFDaiMA+ARthRDb4iNrK37gzVYa3caGC+A@mail.gmail.com>
Subject: Re: [PATCH net v8 1/3] net: sched: fix packet stuck problem for
 lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        bpf <bpf@vger.kernel.org>, Jonas Bonn <jonas.bonn@netrounds.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        Josh Hunt <johunt@akamai.com>, Jike Song <albcamus@gmail.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, atenart@kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Hillf Danton <hdanton@sina.com>, jgross@suse.com,
        JKosina@suse.com, Michal Kubecek <mkubecek@suse.cz>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 7:25 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/5/15 8:17, Jakub Kicinski wrote:
> > On Fri, 14 May 2021 16:57:29 -0700 Cong Wang wrote:
> >> On Fri, May 14, 2021 at 4:39 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >>>
> >>> On Fri, 14 May 2021 16:36:16 -0700 Cong Wang wrote:
> >>  [...]
> >>>>
> >>>> We have test_and_clear_bit() which is atomic, test_bit()+clear_bit()
> >>>> is not.
> >>>
> >>> It doesn't have to be atomic, right? I asked to split the test because
> >>> test_and_clear is a locked op on x86, test by itself is not.
> >>
> >> It depends on whether you expect the code under the true condition
> >> to run once or multiple times, something like:
> >>
> >> if (test_bit()) {
> >>   clear_bit();
> >>   // this code may run multiple times
> >> }
> >>
> >> With the atomic test_and_clear_bit(), it only runs once:
> >>
> >> if (test_and_clear_bit()) {
> >>   // this code runs once
> >> }
>
> I am not sure if the above really matter when the test and clear
> does not need to be atomic.
>
> In order for the above to happens, the MISSED has to set between
> test and clear, right?

Nope, see the following:

// MISSED bit is already set
CPU0                            CPU1
if (test_bit(MISSED) ( //true
                                if (test_bit(MISSED)) { // also true
        clear_bit(MISSED);
        do_something();
                                        clear_bit(MISSED);
                                        do_something();
                                }
}

Now do_something() is called twice instead of once. This may or may
not be a problem, hence I asked this question.

>
> >>
> >> This is why __netif_schedule() uses test_and_set_bit() instead of
> >> test_bit()+set_bit().
>
> I think test_and_set_bit() is needed in __netif_schedule() mainly
> because STATE_SCHED is also used to indicate if the qdisc is in
> sd->output_queue, so it has to be atomic.

If you replace the "do_something()" above with __netif_reschedule(),
this is exactly my point. An entry can not be inserted twice into a
list, hence it should never be called twice like above.

Thanks.
