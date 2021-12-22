Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F6847CABE
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 02:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235558AbhLVBYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 20:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238426AbhLVBYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 20:24:32 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5002FC061574
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 17:24:32 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id m21so3367072edc.0
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 17:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eYUjgiSwuGwyuz93jTI/EKospf4M6z971yUaeoAQd/Q=;
        b=lgz5EQbI0vb4fXKQowZGWE102/AUe3ZX8AE1incRi7YiRfR9XzOcklbLJGJjwtjO+T
         HWjdvwHr2GlPYqwaRYGMgpw9Yjbbd1lxrj5bv6zMh4y1bhqhlJiHCkF5P+e7duYRQxIK
         eS4QgqCrXdK8oy4yX48fnoyAQ1k1z3DjedyyGO7X5SHW0jLQMQhJORWZvuVFQ62ExOry
         w4MF0+ECVLtQyp6Km3iQZCeBNHf5TIIKjBOcOY+WDTq6wJWrZgaVrxzsVK+Tr7HiSOtF
         2DryrZA1bG4WZZwuMEK66lln7GtDtl0HotuczqY+l8nIIrPerncsMufpWobdSsLJtrXK
         40Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eYUjgiSwuGwyuz93jTI/EKospf4M6z971yUaeoAQd/Q=;
        b=cdqrkJMfOPMFVOK6gutJb4DflNFDgP3JL7xPrWb0H/y8kM5iSQ1O9+RGaY8jy4hqW8
         pnNunTG+NEQU7GGH1xVx37XmdoVBods4QkOxUrPqslTq4kKsruz3KPKmXxylu0xMvL3K
         W6gcbfjTQK0uWKgjpOEewUPSq567Lpr4u3m+J6CcRe+IIB2yC488pD3FvEbqY4KUNMF1
         J2LFYHxNOmSWBOoexoT4OoMD7GSUddzA2plgPJbzw616A7KtCdutcfXBvqFyZ3myYbSm
         8lXuByySgHZn8yoF1pfYVYwBKjYJYrP9EcgxMt0rVdXnC2cp7/qdmYqIJpd3RqHayEj7
         3sAw==
X-Gm-Message-State: AOAM5304mYmMd7Fa9naK8MOOf9+8Lv3HVoneCCTlGFUSxoDZw6u/TBS+
        Xl8vkTTzhil8bWvFcXhkCpAVI1XX1AlG6OYva0o=
X-Google-Smtp-Source: ABdhPJyKaKLHpR5/MDBTTeVsFjMdIMDYcrbRqcPz0cFg77UBa3qqECghVIHdAu4KL6U3j7rYbiqU4WgKYUNiWAShNEs=
X-Received: by 2002:a17:907:2da6:: with SMTP id gt38mr695889ejc.61.1640136270962;
 Tue, 21 Dec 2021 17:24:30 -0800 (PST)
MIME-Version: 1.0
References: <20211220123839.54664-1-xiangxia.m.yue@gmail.com>
 <20211220123839.54664-3-xiangxia.m.yue@gmail.com> <CAM_iQpXfZq--ZCUQvggtqE7bEpZFRVcLTqN_R5kLiZj4Y75VAA@mail.gmail.com>
In-Reply-To: <CAM_iQpXfZq--ZCUQvggtqE7bEpZFRVcLTqN_R5kLiZj4Y75VAA@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 22 Dec 2021 09:23:54 +0800
Message-ID: <CAMDZJNVNKP1cgHJKUtPwWUdPR5cZ=v8+t9X6AgHw9FPLi4CmYg@mail.gmail.com>
Subject: Re: [net-next v5 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 1:57 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Dec 20, 2021 at 4:39 AM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > This patch allows user to select queue_mapping, range
> > from A to B. And user can use skbhash, cgroup classid
> > and cpuid to select Tx queues. Then we can load balance
> > packets from A to B queue. The range is an unsigned 16bit
> > value in decimal format.
> >
> > $ tc filter ... action skbedit queue_mapping skbhash A B
> >
> > "skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit")
> > is enhanced with flags:
> > * SKBEDIT_F_TXQ_SKBHASH
> > * SKBEDIT_F_TXQ_CLASSID
> > * SKBEDIT_F_TXQ_CPUID
>
> Once again, you are enforcing policies in kernel, which is not good.
> Kernel should just set whatever you give to it, not selecting policies
> like a menu.
I agree that, but for tc/net-sched layer, there are a lot of
networking policies, for example , cls_A, act_B, sch_C.
> Any reason why you can't obtain these values in user-space?
Did you mean that we add this flags to iproute2 tools? This patch for
iproute2, is not post. If the kerenl patches are accepted, I will send
them.


-- 
Best regards, Tonghao
