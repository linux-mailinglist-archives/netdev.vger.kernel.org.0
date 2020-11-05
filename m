Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEA02A7769
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 07:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731348AbgKEGQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 01:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730651AbgKEGQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 01:16:36 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF29C0613CF;
        Wed,  4 Nov 2020 22:16:35 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id p2so403603ilg.1;
        Wed, 04 Nov 2020 22:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=70dE/wpl4FzIgvQrYHQ8OcOV3M/28K+eR6Zx4+UKA64=;
        b=le4957vUTTZSx++bjwpKPRZ9qOitvxxPnaLhhUZZkyyS2ZumTaKWst6ORYVNcBHtVh
         QjK+zf08FMNgAGAqyNy/yiCIYSupuz6GQIZreath+k66e6MTkisYen6ohF1YOTJVynPs
         fJ6QNxi7LpdCUyAurffJ7Yklfexc9nugpFaHvEHQ5d3p+Bm8NvJCGzfizooc2J53sqMJ
         TCCHnqcsFT3TswUvpmOxaRc9w6hJKyRnuX9RcSFLcpDRTHKZgw+e9Z+KJsvcjZO5vo0h
         gNaklXeOJVM+u6EGYmgOvgUF+7P62B8EuQvbvWFAsfIUgbGzNZkgWqblrKzZ2bTWpo+3
         b3+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=70dE/wpl4FzIgvQrYHQ8OcOV3M/28K+eR6Zx4+UKA64=;
        b=L5cUj0/Wu7G4ySFm2QO95k0iwGeETnxmILfvuSeJm4ULEzW/jTWRmBwRivpsZB7cE/
         oGunBlaDOd5ELht8XApiHqERffvRFm0+N+HSnOpeVGt3VtwdVhFJnsLcEl1he2VsWmXd
         IECtid7fw7LWqSUk/+07FmnbcaLc3DNE9wlHofzqNAIj19ZFcPNMSrDvSMbOxiEYwucl
         PSzA0Qav+4V/9fSWaQ9DssnGtBxAiv7Dh1wXmsGVpFvlR+JLnqvAU/BYs1WIUoq9ToLi
         SQbPYRDfrwb6Jg8W+SA68ktUoYXVofNGW8FSGGokz17xhFflKyzf+lp0zXSjKxriQu22
         Yviw==
X-Gm-Message-State: AOAM530H3gD3nkZ9pcUHUB2L5xqhqnbNYiankONyE1+l8ghaorJytHLA
        nmA2m+PlG23bCXJDeJiPTP7o82+To3TqP9cRvV8hscYmtlY=
X-Google-Smtp-Source: ABdhPJz7I2FFIEhBYerSfJpUJRIduUpW2o5dx3rbWzBSV7V+8Z6CcIyTFxqmoGooijVtrghxHOjk8XC6m2jpn91RmiU=
X-Received: by 2002:a92:ba14:: with SMTP id o20mr816503ili.268.1604556994456;
 Wed, 04 Nov 2020 22:16:34 -0800 (PST)
MIME-Version: 1.0
References: <1599562954-87257-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpX0_mz+McZdzZ7HFTjBihOKz5E6i4qJQSoFbZ=SZkVh=Q@mail.gmail.com>
 <830f85b5-ef29-c68e-c982-de20ac880bd9@huawei.com> <CAM_iQpU_tbRNO=Lznz_d6YjXmenYhowEfBoOiJgEmo9x8bEevw@mail.gmail.com>
 <1f8ebcde-f5ff-43df-960e-3661706e8d04@huawei.com> <CAM_iQpUm91x8Q0G=CXE7S43DKryABkyMTa4mz_oEfEOTFS7BgQ@mail.gmail.com>
 <db770012-f22c-dff4-5311-bf4d17cd08e3@huawei.com> <CAM_iQpUBytX3qim3rXLkwjdX3DSKeF8YhyX6o=Jwr-R9Onb-HA@mail.gmail.com>
 <5472023c-b50b-0cb3-4cb6-7bbea42d3612@huawei.com> <CAM_iQpVGm_Mz-yYUhhvn+p8H7mXHWHAuBNfyNj-251eY3Vr9iA@mail.gmail.com>
In-Reply-To: <CAM_iQpVGm_Mz-yYUhhvn+p8H7mXHWHAuBNfyNj-251eY3Vr9iA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 4 Nov 2020 22:16:23 -0800
Message-ID: <CAM_iQpXZHPSW9j+DaUDZdqm+wGrmy4nLL8gPEm7g3XndPn90+Q@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@huawei.com,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 10:04 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Nov 2, 2020 at 11:24 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> > >> From my understanding, we can do anything about the old qdisc (including
> > >> destorying the old qdisc) after some_qdisc_is_busy() return false.
> > >
> > > But the current code does the reset _before_ some_qdisc_is_busy(). ;)
> >
> > If lock is taken when doing reset, it does not matter if the reset is
> > before some_qdisc_is_busy(), right?
>
> Why not? How about the following scenario?
>
> CPU0:                   CPU1:
> dev_reset_queue()
>                         net_tx_action()
>                          -> sch_direct_xmit()
>                            -> dev_requeue_skb()
> some_qdisc_is_busy()
> // waiting for TX action on CPU1
> // now some packets are requeued

Never mind, the skb_bad_txq is also cleared by dev_reset_queue().
TX action after resetting should get NULL.

Thanks.
