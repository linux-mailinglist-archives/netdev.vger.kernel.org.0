Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A2B444CFB
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 02:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhKDB0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 21:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbhKDB0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 21:26:40 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFE2C061203
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 18:24:02 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z20so15582320edc.13
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 18:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X15Y/s0z/iDOGcfZKU5T28WFF418j5KMeU5FMCpk6ok=;
        b=Adw3Cd8IXZ7G+YF8piA4g8ioZDYe38YRbzlOVIv6sr8oPvYuptGpLZVfU7zOrB4y9Z
         yuzYAUVjibJFp0Mnbe4srCUuBzk+yqWe5rL/ETC0cLMhCM8ULvP8dC3I30UBFuOz5r9k
         foLHlCtqG8cR4hz0nIgXUnHRwOD0zeO9pOTfCZjjgz62fOZ6Qlryb6gKw6Ht+6Io7vfA
         Q7h1cZNVAkNy5TzoVb+HYznRvVTJBFEBQNjMC72JBLNg/uQbgon32dC/H+wkR3GFENqb
         UW+Re2bVwOsA7E0bNn5BOqedMtEIui6FIwVvI1lEa/EtktlEcZYtkNZahiD0NC0GFEh0
         RzfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X15Y/s0z/iDOGcfZKU5T28WFF418j5KMeU5FMCpk6ok=;
        b=S9hA0ZUFW+HU8hUU2qDB244Affzd0EkBizpM3m9S/jqx75M3mkCX5KT4nkMpdtt/VH
         iRaui9MCXB8oj7yw6QmePQFE6rCMB5LYSG4xipjU99FFZts4WL7JsEV4hb5O4INJ/GJh
         FoqKKUnwAD9e7aPQGX85MfJfVBiejvxcZINEFjJmDFwA7XEGUCrd+oTXHkdoHWQfhsS/
         BsznGp9ueZ7nyxnzcK/JPG5/ArYRhgOHHqKV/yg7RXlO3+yJQ7fhWusgKjrK6sP806Vv
         BhfaUibsoa1zRPptcPLxekIntYnlaDk+c1eWqZyCBQMrzOAZ/ALOSivdFqc7K4pUKwsj
         jy2w==
X-Gm-Message-State: AOAM532WhQI7aRHqDWk5uhcKQkL8UMRn7aXBXh0gLTOG6LQVBEl7T5S9
        Sn4+AjHECc41ujOVf/43bv3jlxHfN5ngKKxLSzU=
X-Google-Smtp-Source: ABdhPJyvVVr0uc5zMpEk01eQ8qPmEos40yTZcWoocW2kCpZcgKQv28/x1v4WcTiDLFC3gapFEgFi6Ei0BdTIAswuLmU=
X-Received: by 2002:a17:907:3f19:: with SMTP id hq25mr24928178ejc.225.1635989041283;
 Wed, 03 Nov 2021 18:24:01 -0700 (PDT)
MIME-Version: 1.0
References: <20211103143208.41282-1-xiangxia.m.yue@gmail.com>
 <CA+FuTSftumQMYg8fcCW3C-A0CKZC=6GYDrR3UXjaS1gNJx=5TA@mail.gmail.com> <b0c3fa7e-2e00-b4fd-d31a-54e7173be12a@iogearbox.net>
In-Reply-To: <b0c3fa7e-2e00-b4fd-d31a-54e7173be12a@iogearbox.net>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 4 Nov 2021 09:23:25 +0800
Message-ID: <CAMDZJNW7-hq6eJpfhnwbrgOm7vdr46_iM5D2TzikTHtV6DS1uw@mail.gmail.com>
Subject: Re: [PATCH v2] net: sched: check tc_skip_classify as far as possible
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 3, 2021 at 10:59 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 11/3/21 3:47 PM, Willem de Bruijn wrote:
> > On Wed, Nov 3, 2021 at 10:32 AM <xiangxia.m.yue@gmail.com> wrote:
> >>
> >> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >>
> >> We look up and then check tc_skip_classify flag in net
> >> sched layer, even though skb don't want to be classified.
> >> That case may consume a lot of cpu cycles.
> >>
> >> Install the rules as below:
> >> $ for id in $(seq 1 100); do
> >> $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
> >> $ done
> >>
> >> netperf:
> >> $ taskset -c 1 netperf -t TCP_RR -H ip -- -r 32,32
> >> $ taskset -c 1 netperf -t TCP_STREAM -H ip -- -m 32
> >>
> >> Before: 10662.33 tps, 108.95 Mbit/s
> >> After:  12434.48 tps, 145.89 Mbit/s
> >>
> >> For TCP_RR, there are 16.6% improvement, TCP_STREAM 33.9%.
> >>
> >> Cc: Willem de Bruijn <willemb@google.com>
> >> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> >> Cc: Jakub Kicinski <kuba@kernel.org>
> >> Cc: Daniel Borkmann <daniel@iogearbox.net>
> >> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >> ---
> >> v2: don't delete skb_skip_tc_classify in act_api
> >> ---
> >>   net/core/dev.c | 3 +++
> >>   1 file changed, 3 insertions(+)
> >>
> >> diff --git a/net/core/dev.c b/net/core/dev.c
> >> index edeb811c454e..fc29a429e9ad 100644
> >> --- a/net/core/dev.c
> >> +++ b/net/core/dev.c
> >> @@ -3940,6 +3940,9 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
> >>          if (!miniq)
> >>                  return skb;
> >>
> >> +       if (skb_skip_tc_classify(skb))
> >> +               return skb;
> >> +
> >
> > This bit and test exist to make sure that packets redirected through
> > the ifb device are redirected only once.
> >
> > I was afraid that on second loop, this will also short-circuit other
> > unrelated tc classifiers and actions that should take place.
> >
> > The name and the variable comment make clear that the intention is
> > indeed to bypass all classification.
> >
> > However, the current implementation acts at tcf_action_exec. So it
> > does not stop processing by fused classifier-action objects, notably tc_bpf.
> >
> > So I agree both that this seems to follow the original intent, but also
> > has the chance to break existing production configurations.
>
> Agree, I share your concern.
I got it, thanks Daniel, Willem.
One question, If users use the bpf_redirect, instead of tc-mirred, to
redirect the packets to ifb in egress.
If there is not a test with *skb_skip_tc_classify, the packets will
loop and be dropped, right ? but we hope the packets sent out the
linux box.


-- 
Best regards, Tonghao
