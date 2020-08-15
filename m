Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B4A24536D
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbgHOWBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728785AbgHOVv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:51:26 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41D7C0F26D4
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 10:34:39 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id s189so13789257iod.2
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 10:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VH1Ri4JGjhsiWG8X+mB5brK1yxgqFNRYLVP4BwOaWeE=;
        b=bUVQKaoY+PnEYI0v3RKOL6YlXkZxLh3cVa5v4L66f+acJaZ+fiYn5uz2A3HL43a07Y
         orCp63/RKdaZSgHx1HtkNmGauL2Grw/CPNroAKTPDrqe7/5CCyOZUZqxONq1VcUJK43f
         N18X0z8qqCOvhfkgoR6pjOLC6jTNTfKxFh1P9PAdZUta4ShTJx5wT2zoKkoMWTOT4aDd
         sb36E1xKhozbGS9YU6TQ7eELXbBGhljXk6VZnI+PZ99eXqa3ja7mQXY7croB8uNv4XYY
         5z2Eny7IjuPLOpjaeqxNs1sjsEvGcFASh4gextihmVD6EXtST/KvmsCfL7w2AkS5/5id
         XIgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VH1Ri4JGjhsiWG8X+mB5brK1yxgqFNRYLVP4BwOaWeE=;
        b=kK7BP6xIsW1B7iePhBQUYXLxeE/BL5kyMDYJLl/Qv7Cp0fhh1tLuoroXr2Ni6803Xu
         i0hm5zV5k2uGkN5CyZAEV+60btALJkYvF0bePrVUpJSFd/ct94gdqj4SyikSM+STtPHG
         OuUUk7SRAycJ/K8/AGP2+fLHQqjpJqm/emNvZZfhclG3b6akuW4YxJBAuru+BjqYiMfZ
         MnF4xBpYyBUuktiroY+JMJFsgt0pyoeFVRH/4xKo0KNFYCry3/wRIAjOSTjLIJ49k59E
         Ljt+7AY50IFxg2EuBE1fCsEh09LEqIXEVNFy58G5ASOmtQ6CiXMEPvb0F7oU8buBM0Y4
         TJFw==
X-Gm-Message-State: AOAM530ETgQJqtie9y+T5LNIewrL5HZY9Yx5l3XDc0eAv48d6sC9RIR2
        aOxmC/8JgOvyiv56dvyh658sgaG5pHMPI1rsAiTAiA==
X-Google-Smtp-Source: ABdhPJxaNMiMshi/g1cOzGiamJ+SH590Et6TR3BtyCWpCjzimvKz8MpCQ+nFpp7BU87rtvzUNeL6xudm9CcAF+Vm8vQ=
X-Received: by 2002:a05:6602:24d8:: with SMTP id h24mr6427356ioe.145.1597512877709;
 Sat, 15 Aug 2020 10:34:37 -0700 (PDT)
MIME-Version: 1.0
References: <e6f779c3-9af0-5200-013b-f4da94c2ae38@gmail.com>
In-Reply-To: <e6f779c3-9af0-5200-013b-f4da94c2ae38@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 15 Aug 2020 10:34:26 -0700
Message-ID: <CANn89i+iHPssBAkaucdZukV=XxdoVWoYDm4LGEO+E49sXmDi9Q@mail.gmail.com>
Subject: Re: Alternate location for skb_shared_info other than the tail?
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Justin Chen <justin.chen@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 15, 2020 at 9:57 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> Hi all,
>
> We have an Ethernet controller that is capable of putting several
> Ethernet frames within a single 4KB buffer provided by Linux. The
> rationale for this design is to maximize the DRAM efficiency, especially
> for LPDDR4/5 architectures where the cost to keep a page open is higher
> than say DDR3/4.
>
> We have a programmable alignment which allows us to make sure that we
> can align the start of the Ethernet frames on a cache line boundary (and
> also add the 2 byte stuffing to further align the IP header). What we do
> not have however is a programmable tail room to space out the Ethernet
> frames between one another. Worst case, if the end aligns on a 64b
> boundary, the next frame would start on the adjacent byte, leaving no
> space in between.
>
> We were initially thinking about using build_skb() (and variants) and
> point the data argument to the location within that 4KB buffer, however
> this causes a problem that we have the skb_shared_info structure at the
> end of the Ethernet frame, and that area can be overwritten by the
> hardware. Right now we allocate a new sk_buff and copy from the offset
> within the 4KB buffer. The CPU is fast enough and this warms up the data
> cache that this is not a performance problem, but we would prefer to do
> without the copy to limit the amount of allocations in NAPI context.
>
> What is further complicating is that by the time we process one Ethernet
> frame within the 4KB data buffer, we do not necessarily know whether
> another one will come, and what space we would have between the two. If
> we do know, though, we could see if we have enough room for the
> skb_shared_info and at least avoid copying that sk_buff, but this would
> not be such a big win.
>
> We are unfortunately a bit late to fix that hardware design limitation,
> and we did not catch the requirement for putting skb_shared_info at the
> end until too late :/
>
> In premise skb_shared_info could reside somewhere other than at the
> tail, and the entire network stack uses the skb_shinfo() to access the
> area (there are no concerns about "wild" accesses to skb_shared_info),
> so if we could find a way to encode within the sk_buff that an alternate
> location is to be used, we could get our cookie. There are some parts of
> the stack that do however assume that we need to allocate the header
> part plus the sbk_shared_info structure, those assumptions may be harder
> to break.
>
> Do you have any suggestions on how we could specify an alternate
> location for skb_shared_info or any other suggestions on how to avoid
> copies?

It seems you do _not_ want to use build_skb(), but instead allocate a
standard skb
with enough room in skb->head to pull the headers.

build_skb was fine for MTU=1500 and using 2KB pre-allocated buffers,
because we could use the
2048-1536 = 512 bytes as a placeholder for shared_info.

But for non conventional MTU or buffer splitting (as in your case),
there is no point for using this.
