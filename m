Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B5640FE69
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 19:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241558AbhIQRQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 13:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232742AbhIQRQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 13:16:43 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A151C061574
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 10:15:21 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id p4so19627610qki.3
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 10:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=31egVMi24lDCbHI3jFMIkOXoiTXKDonx8R+d3mlekEo=;
        b=Sn8kQwXNPPtiWG9B1L9+6PjSSZUNmC6js1psKOUHWNcEfq18Toda5YbBqKyT7xHN09
         Mb8Suauob5buttvKHblSJ9LIwPBLMINj4E1lNd6xJtjAKGWv3Io4N0jVIVMuZrN8e6l1
         26f0L6vpE+wGdqEc8fQiIqddLCk8y9BVu3/V1wmJIjEg9ULWROyLzkYOp4yA+28oL9an
         pxuiyM/eV+bFZaKK8QZv/4yzOKytNUOoL1DKA+cnzC5vdoYk7o7yfdnnUZFXmMdd96IF
         MGbk84H1o6TpLSIGhGeE3CJ9eav6gADNavFW4yEtCxWHz9uO/aph/8EVLIHNmmwmXN4r
         KqOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=31egVMi24lDCbHI3jFMIkOXoiTXKDonx8R+d3mlekEo=;
        b=P0u0WA/NfwdoXmxrPRfPLywf1Y0fE7jDgeEo5Aa7a6tcZa0D2f4nV5+m5stTL+STcn
         YfAOOiNPmFdIdBQEUJmWMiTZeZ6iY6IZ/RjfgQV9RnVKheQ+nFoNol20R+v+H9a6z7ll
         MwmLqQw5TO0Z4jyO8BFsbW1RoYr1FOSmAHH4F39/julrF+Gllu/+BFMxkQAQsP9oMtm5
         i12Me+JQBK266xFqpmsmBegT+2etChfa7mqJwsB758kQiT4TpLWF6hEyBZ2xf267nr46
         xRnaFFfXT4sZnfRxpLLMnZAyeLp9oOROFNXi/pxPbz6l0o3/A5uYwEzmT4ZPUp8EBCfF
         +Puw==
X-Gm-Message-State: AOAM531Mjujuo1Xlgw23ay1MeUtm3Dmw1SYwOa5keKCGimMd5io+inrB
        OdNAgpFEGwdK9lS1tKyAHgU47F8NSsu55Ux5Em7cqA==
X-Google-Smtp-Source: ABdhPJwp3wXCoSJNtPctZeW3Dp/LYB2c9U1aSTCyvZZr/msVyK8FduVRnIbyIRdj43sqgMe8v9yzgLDLH8UAsz7bUH4=
X-Received: by 2002:a25:b28a:: with SMTP id k10mr15863396ybj.398.1631898920023;
 Fri, 17 Sep 2021 10:15:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210914121114.28559-1-linyunsheng@huawei.com>
 <20210914121114.28559-4-linyunsheng@huawei.com> <CAKgT0Ud7NXpHghiPeGzRg=83jYAP1Dx75z3ZE0qV8mT0zNMDhA@mail.gmail.com>
 <9467ec14-af34-bba4-1ece-6f5ea199ec97@huawei.com> <YUHtf+lI8ktBdjsQ@apalos.home>
 <0337e2f6-5428-2c75-71a5-6db31c60650a@redhat.com> <fef7d148-95d6-4893-8924-1071ed43ff1b@huawei.com>
In-Reply-To: <fef7d148-95d6-4893-8924-1071ed43ff1b@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 17 Sep 2021 10:15:08 -0700
Message-ID: <CANn89iLWo_03b=9WYi1401gFCLXnNrjeFJJaZXJkh0E2Bw-yYQ@mail.gmail.com>
Subject: Re: [Linuxarm] Re: [PATCH net-next v2 3/3] skbuff: keep track of pp
 page when __skb_frag_ref() is called
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Marco Elver <elver@google.com>, memxor@gmail.com,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 7:05 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:

> As memtioned before, Tx recycling is based on page_pool instance per socket.
> it shares the page_pool instance with rx.
>
> Anyway, based on feedback from edumazet and dsahern, I am still trying to
> see if the page pool is meaningful for tx.
>

It is not for generic linux TCP stack, but perhaps for benchmarks.

Unless you dedicate one TX/RX pair per TCP socket ?

Most high performance TCP flows are using zerocopy, I am really not
sure why we would
need to 'optimize' the path that is wasting cpu cycles doing
user->kernel copies anyway,
at the cost of insane complexity.
