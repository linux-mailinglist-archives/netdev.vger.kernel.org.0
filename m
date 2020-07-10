Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB29421AE4B
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 07:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGJFFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 01:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgGJFFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 01:05:02 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375C7C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 22:05:02 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id r12so4034503ilh.4
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 22:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9e+jZdb8aeyV4Tn7HZ3nsQ7geaTuNgk9D+66yRrZiAc=;
        b=M5T5bUTd5n8N7kqCxLZ8z4xucdECinr61PKLRps0RYvRLzl66UVzMqs79K3iWT7H2A
         mL77N+zZ9jvGOBFG2z4YGls2l/c7ovh/SI9mLDf0OFvw32SMUUj1+GL3u5Ut9po5+rm7
         URHMD1d4bsRomNetbeFeqD2waqPD52ljp8Ky2q7iv8p1FBfOGumnv5UAQE+RoGeegu/+
         rHEy+Tp24hCANPSC2RZ/Fnnp7dp9iv/HPiyWvdK53DRwd7PLqjWDoxB/bS5T8+S1a0Z7
         Uf+MHOhExwCDep4zlnZUnyu7bJsjV6V7QUknqbKpzbFZCooL4QKkhqEjQ65B3HHxy2Nn
         PYCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9e+jZdb8aeyV4Tn7HZ3nsQ7geaTuNgk9D+66yRrZiAc=;
        b=qXB8/0geJIpiRb14YhQevkCcqKUgydjCthdzxFPU+6d14lx5DsGzc/DQIIBcRM2ux9
         FNIaAusEkj/QwA/moAeZoPi/O56vrfSHegRncZY2t4gLzRq5DcJrv5/0fpZQ5g7GAPxr
         bR78yE3YAWk2AvrIzCCvOmXqKjzrE0UIxj/UuBVhi9jHBvB9aisjHNE22N7MvLRFbdCZ
         fkxguFXwBQctdy6VkZKRXQJmAYzrS40ZXg1VghGP4T3bsmYztyzvAXuy6MlG9XtUhKbL
         LgYyKqQerZtr7D2MkcXZtPugRyDdAASY97tKNb0LZIVUcu7QCDeU7cdxWlFwPFW2pwcn
         KjQA==
X-Gm-Message-State: AOAM533f/oQiQ3VqgmCVdGWtOT1Y4k3nhTO5Ia3n7kbVv/EE3Dij9QB3
        /W9LOQp+e5K6Kwnb7jIKgk+M78USy0k5zyjgcKk=
X-Google-Smtp-Source: ABdhPJyww9CwwrYQWUJ177VbnSJaAR3Sx3AhDT4n4fKC6mA2X6gjNvTgFkaiXcFcVT3f62uK+85ApSGt+GgBsJVduXw=
X-Received: by 2002:a05:6e02:128d:: with SMTP id y13mr49407581ilq.305.1594357501379;
 Thu, 09 Jul 2020 22:05:01 -0700 (PDT)
MIME-Version: 1.0
References: <28bff9d7-fa2d-5284-f6d5-e08cd792c9c6@alibaba-inc.com>
 <CAM_iQpVux85OXH-oYeH15sYTb=kEj0o7uu9ug9PeTesHzXk_gQ@mail.gmail.com>
 <5c963736-2a83-b658-2a9d-485d0876c03f@alibaba-inc.com> <CAM_iQpV5LRU-JxfLETsdNqh75wv3vWyCsxiTTgC392HvTxa9CQ@mail.gmail.com>
 <ad662f0b-c4ab-01c0-57e1-45ddd7325e66@alibaba-inc.com> <CAM_iQpUE658hhk8n9j+T5Qfm4Vj7Zfzw08EECh8CF8QW0GLW_g@mail.gmail.com>
 <00ab4144-397e-41b8-e518-ad2aacb9afd3@alibaba-inc.com>
In-Reply-To: <00ab4144-397e-41b8-e518-ad2aacb9afd3@alibaba-inc.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 9 Jul 2020 22:04:50 -0700
Message-ID: <CAM_iQpVoxDz2mrZozAKAjr=bykKO++XM3R-rgyUCb8-Edsv58g@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: sched: Lockless Token Bucket (LTB) Qdisc
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 2:07 PM YU, Xiangning
<xiangning.yu@alibaba-inc.com> wrote:
>
>
>
> On 7/8/20 1:24 PM, Cong Wang wrote:
> > On Tue, Jul 7, 2020 at 2:24 PM YU, Xiangning
> > <xiangning.yu@alibaba-inc.com> wrote:
> >>
> >> The key is to avoid classifying packets from a same flow into differen=
t classes. So we use socket priority to classify packets. It's always going=
 to be correctly classified.
> >>
> >> Not sure what do you mean by default configuration. But we create a sh=
adow class when the qdisc is created. Before any other classes are created,=
 all packets from any flow will be classified to this same shadow class, th=
ere won't be any incorrect classified packets either.
> >
> > By "default configuration" I mean no additional configuration on top
> > of qdisc creation. If you have to rely on additional TC filters to
> > do the classification, it could be problematic. Same for setting
> > skb priority, right?
> >
>
> In this patch we don't rely on other TC filters. In our use case, socket =
priority is set on a per-flow basis, not per-skb basis.

Your use case is not the default configuration I mentioned.

>
> > Also, you use a default class, this means all unclassified packets
> > share the same class, and a flow falls into this class could be still
> > out-of-order, right?
> >
>
> A flow will fall and only fall to this class. If we can keep the order wi=
thin a flow, I'm not sure why we still have this issue?

The issue here is obvious: you have to rely on either TC filters or
whatever sets skb priority to make packets in a flow in-order.

IOW, without these *additional* efforts, it is broken in terms of
out-of-order.

Thanks.
