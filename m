Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEB121AF4F
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 08:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgGJGVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 02:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgGJGVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 02:21:20 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D67C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 23:21:20 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id a12so4863107ion.13
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 23:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4LG5Vbp9I2ObuCb9YZyqxPm/l1ffgxVOzysKjZlS20g=;
        b=qA/phX/D9V9esQm675GyAoXRRXsTmXeaNgVk3eXVHtWgYa0jGb659cBBx7y0+a/wR5
         dtHx2QubK4qAMbOrKyx9JN9R6EeKqVD0tDRfSGbiUAhhDZEdJ5RjP3akJF1aaty6S0Dl
         xGCVd9sv5NTf0I4a6IM2S9Snc2bGIt2KKR5wjp5OxPIiE1/5Y8ukD4p4XAfsuWN827YR
         ffBJPtAU4E6Zyzdsr2rx4K21HfA5qSbYhzEhcXoWe2nZSFPhd0tyTzG5csws464DyLK4
         ykTBUa80utDGKycxoay+L3ZWS+Rm3jowtFGNoe5kOics/L6dMwGZSkVpdzf+TI6NV7fO
         6fUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4LG5Vbp9I2ObuCb9YZyqxPm/l1ffgxVOzysKjZlS20g=;
        b=XFwqc0dRehiqI2ZcUbELumWCeDvuyRyYagfMGVY3eBXDYSixqT7zf0Sn1M0qCtLxo/
         ikXkOf9tcGllP4VaBx1exs/g7uLY3yu5Rzpmc7GRbxGnLclPjd/FcC5Hh1OhLbZ2VbRn
         zwMXLAiOVQiMdlo8uj6OSvL6/K/KBtnnJsUrCib2GF0wSnjEcSPS2ZufIqEAIrnKkgyB
         aH9QteRnXlbZiv/HjVvJ7THA6Tw6uiaqSyOir80tVMHOjKiTTT8/OXZnZDKqJaorfUFH
         9HGQsBSGHcrlKSYv9Z2f2UqVhfR9RG0iT7VaySh5tOEdvD0ANrsJmsQUamM5WaGgh1A7
         qahg==
X-Gm-Message-State: AOAM5309ycXJujh+gDGGVQu2JKJ5ECbVbkLlkGs0pjBQGsVfwXer/lJ6
        z+8PSc2+Nln3zUQH1H56fAttdy9xucHuUfxbRE0=
X-Google-Smtp-Source: ABdhPJyUIxH88eHo7uPS57O3+F/TnTVkpklSp0YpBo5Ghg9MfxE+JoA8HwMEzZ0FSb6K1le7rjc7EwTvyPiemm3kEms=
X-Received: by 2002:a05:6602:1225:: with SMTP id z5mr46180073iot.64.1594362080002;
 Thu, 09 Jul 2020 23:21:20 -0700 (PDT)
MIME-Version: 1.0
References: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
 <CAM_iQpVux85OXH-oYeH15sYTb=kEj0o7uu9ug9PeTesHzXk_gQ@mail.gmail.com>
 <5c963736-2a83-b658-2a9d-485d0876c03f@alibaba-inc.com> <CAM_iQpV5LRU-JxfLETsdNqh75wv3vWyCsxiTTgC392HvTxa9CQ@mail.gmail.com>
 <ad662f0b-c4ab-01c0-57e1-45ddd7325e66@alibaba-inc.com> <CAM_iQpUE658hhk8n9j+T5Qfm4Vj7Zfzw08EECh8CF8QW0GLW_g@mail.gmail.com>
 <00ab4144-397e-41b8-e518-ad2aacb9afd3@alibaba-inc.com> <CAM_iQpVoxDz2mrZozAKAjr=bykKO++XM3R-rgyUCb8-Edsv58g@mail.gmail.com>
 <CAM_iQpWAHdws4Zu=qD1g5E3tOShefQwK8Mbf9YNCiR2OvHA-Kw@mail.gmail.com> <f26ce874-dd33-5283-62ff-334c0c611d09@alibaba-inc.com>
In-Reply-To: <f26ce874-dd33-5283-62ff-334c0c611d09@alibaba-inc.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 9 Jul 2020 23:21:08 -0700
Message-ID: <CAM_iQpXjTO7T_i-9tPw_xtwc3G91GDVHF_xc=J3xN+2dU+-F_Q@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: sched: Lockless Token Bucket (LTB) Qdisc
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 11:07 PM YU, Xiangning
<xiangning.yu@alibaba-inc.com> wrote:
>
>
> On 7/9/20 10:20 PM, Cong Wang wrote:
> > On Thu, Jul 9, 2020 at 10:04 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >> IOW, without these *additional* efforts, it is broken in terms of
> >> out-of-order.
> >>
> >
> > Take a look at fq_codel, it provides a hash function for flow classification,
> > fq_codel_hash(), as default, thus its default configuration does not
> > have such issues. So, you probably want to provide such a hash
> > function too instead of a default class.
> >
> If I understand this code correctly, this socket hash value identifies a flow. Essentially it serves the same purpose as socket priority. In this patch, we use a similar classification method like htb, but without filters.

How is it any similar to HTB? HTB does not have a per-cpu queue
for each class. This is a huge difference.

>
> We could provide a hash function, but I'm a bit confused about the problem we are trying to solve.

Probably more than that, you need to ensure the packets in a same flow
are queued on the same queue.

Let say you have two packets P1 and P2 from the same flow (P1 is before P2),
you can classify them into the same class of course, but with per-cpu queues
they can be sent out in a wrong order too:

send(P1) on CPU1 -> classify() returns default class -> P1 is queued on
the CPU1 queue of default class

(Now process is migrated to CPU2)

send(P2) on CPU2 -> classify() returns default class -> P2 is queued on
the CPU2 queue of default class

P2 is dequeued on CPU2 before P1 dequeued on CPU1.

Now, out of order. :)

Hope it is clear now.

Thanks.
