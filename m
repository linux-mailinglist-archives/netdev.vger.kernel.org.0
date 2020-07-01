Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419C2210375
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 07:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgGAFxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 01:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgGAFxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 01:53:04 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B44C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 22:53:04 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id y2so23714013ioy.3
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 22:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CW/owM5JTExC7wxldr6NFLfK3S+Cxc7DiaoO9y7bp4s=;
        b=sEQ6dK5O5MixzjZthEkQtiF1oio/FzZkPoheoyrtVzzGe+/hN6xRMNQc6GBufy9skp
         2iLYptyPiddUs3+6EW6Ru0kFWzzomiaF5ZzKi5gTH0GAe5li+VGuCwGeFp+gYzLJ4vlD
         KuvrNz80vKagQ54rR1U6srSgKhhZt+jriPfPH83gOdVZNBbqjlZQ/I9K9/dGWeYKYGeb
         kxVm5651jNToy2raPqY9M8+LJOgMhQzQwoiAOw61VmGOVwt4ACbDGHWoqBi8HqpCxAPE
         aKxkKOWb7fZcH5K+YKWnuon36VxRwnGQKpmLmAulXI+rUinmlUZYi2aFf1ec4RPBU4zi
         aRmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CW/owM5JTExC7wxldr6NFLfK3S+Cxc7DiaoO9y7bp4s=;
        b=kLjfM6cGDjssCjoxlZ+gWyCBYXAOC1oPALv7eNCSzoUZCECWGT+Yo1Iw1VN4/y3Y/V
         8c9LcGB1nln+hpd9IVQJEEtc8886XowXagN1r9fbcyS8VifDM6heKjTGgVfiFEyEZLgL
         T7X9pDyfdS6PlYNyfLife+D1nWQ14h0fWR5vwOVA0Ldtgt5kgnxBkwHeoWuMgxKTW9IW
         97pUwT8cXqY3P8diwxhW5nCTUSJwAamvtNZnivovw+kKS+vjglKVsDzj1hharj73P/mg
         1HfCXnMzXmxUoGycBUizGbmm0BLqngxO7sNDN51jGosK6vCW83JEI0qzbsffext/Ew9/
         Ln7w==
X-Gm-Message-State: AOAM533FWWAE4pDEfUPf1jY9CZZzm+zJJwr7D6bgVG9jAd6TuLsAlR4J
        /6sX8ygqbEDa6n0wmiryD6w5y4+k1VmXqVWLRCZuOn5NyBI=
X-Google-Smtp-Source: ABdhPJyumqQVL38EGnI9Xe2oNLNvMDHz2HnWYKRVdapp6oG8eQjCmFs+JRHGhE9VnoviQj+w06X5iMIjLXyKjQtFSi0=
X-Received: by 2002:a02:5d49:: with SMTP id w70mr27374377jaa.16.1593582783678;
 Tue, 30 Jun 2020 22:53:03 -0700 (PDT)
MIME-Version: 1.0
References: <1593485646-14989-1-git-send-email-wenxu@ucloud.cn>
 <CAM_iQpVFN3f8OCy-zWWV+ZmKomdn8Cm3dFtbux0figRCDsU9tw@mail.gmail.com> <10af044d-c51b-9b85-04b9-ea97a3c3ebdb@ucloud.cn>
In-Reply-To: <10af044d-c51b-9b85-04b9-ea97a3c3ebdb@ucloud.cn>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 30 Jun 2020 22:52:52 -0700
Message-ID: <CAM_iQpWmyAd3UOk+6+J8aYw3_P=ZWhCPpoYNUyFdj4FCPuuLoA@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: act_mirred: fix fragment the packet after
 defrag in act_ct
To:     wenxu <wenxu@ucloud.cn>
Cc:     Paul Blakey <paulb@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 7:36 PM wenxu <wenxu@ucloud.cn> wrote:
>
>
> On 7/1/2020 3:02 AM, Cong Wang wrote:
> > On Mon, Jun 29, 2020 at 7:55 PM <wenxu@ucloud.cn> wrote:
> >> From: wenxu <wenxu@ucloud.cn>
> >>
> >> The fragment packets do defrag in act_ct module. The reassembled packet
> >> over the mtu in the act_mirred. This big packet should be fragmented
> >> to send out.
> > This is too brief. Why act_mirred should handle the burden introduced by
> > act_ct? And why is this 158-line change targeting -net not -net-next?
>
> Hi Cong,
>
> In the act_ct the fragment packets will defrag to a big packet and do conntrack things.
>
> But in the latter filter mirred action, the big packet normally send over the mtu of outgoing device.
>
> So in the act_mirred send the packet should fragment.

Why act_mirred? Not, for a quick example, a new action called act_defrag?
I understand you happen to use the combination of act_ct and act_mirred,
but that is not the reason we should make act_mirred specifically work
for your case.

>
> I think this is a bugfix in the net branch the act_ct handle with fragment will always fail.

act_mirred is just to mirror or redirect packets, if they are too big
to deliver,
it is not act_mirred's fault.

And more importantly, why don't you put all these important information in
your changelog?

THanks.
