Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAFA1D742C
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 11:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgERJij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 05:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgERJij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 05:38:39 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D29C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 02:38:38 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id x22so3904456otq.4
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 02:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zIGRhjTb39lCx4A72iyIuZ7jOReYL9wtyAhaS6hru/g=;
        b=NKtyQArODpgLU5kdnENLiwnC9FvyTOlhbdE9+iU/Rf6Kgf3VPiqbraWu8zKAk641bh
         VkKwyhPJvIsiYYRW8/5UmdSKt6y26QW1KIE1vAsEnzhnu+0TPD7F0TvuTKsMMejyml0O
         ayLnGwlM+2UnX2ha/WtHdn5W3UQ53nr2e29CI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zIGRhjTb39lCx4A72iyIuZ7jOReYL9wtyAhaS6hru/g=;
        b=T8624U4cNyObpXGlNHiOYkff7EOeA+zILdO8JNZtqotUX9UQ4LMrVxBnn68cPZfDCj
         URORaRYkDPli43emKLQMHsoIr6mf+xCdlniIXxrRFboh61KeumkH6C4dfsxwvrIJvFab
         EpJuV6zQXfTW+tH+Jlatk2YoQCz3dYp4cJvlX0sb8i3GAveuZ9I89Qi/ZjBnWwOuP9R8
         QgHtySYk3IcHQL9x1YSXOXzVuZE7eHGqdHpxPbPECEWHgtKOt9FpY8VgoIIBhu07MAhO
         1bZamGb/mhQPAtRSMIyK0DPXexz78BY885X8WaL6EExgXpv5/JjCDvwQppdvAUi6+zgS
         CmHg==
X-Gm-Message-State: AOAM530Vcodd4HTtID+2TN5+EKicY+S9Q3sehCxzEVJhlGLRCnsTOPVB
        gzWrUeJ/NWHU4qNNZWDskXP2q1KHc+i18bDUvzz5xg==
X-Google-Smtp-Source: ABdhPJzIWE9KOvU1lS/Gwle1VvW3iwpbDf31uwAV466RgU/k1kJP/HUuM5bw3dWyEbbhqkxprsjFa97dfylBtq4h51g=
X-Received: by 2002:a9d:70c1:: with SMTP id w1mr11335331otj.132.1589794717514;
 Mon, 18 May 2020 02:38:37 -0700 (PDT)
MIME-Version: 1.0
References: <CACAyw9_4Uzh0GqAR16BfEHQ0ZWHKGUKacOQwwhwsfhdCTMtsNQ@mail.gmail.com>
 <b93b4ad2-0cf0-81e0-b2b0-664248b3630f@gmail.com> <CACAyw9-95He2yq0qoxuWFy3wqQt1kAtAQcRw2UTrqse2hUq1tA@mail.gmail.com>
 <5cca7bce-0052-d854-5ead-b09d43cb9eb9@gmail.com> <CACAyw9-TEDHdcjykuQZ8P0Q6QngEZU0z7PXgqtZRQq4Jh1_ojw@mail.gmail.com>
 <b212a92c-7684-8c47-1b63-75762c326a24@gmail.com>
In-Reply-To: <b212a92c-7684-8c47-1b63-75762c326a24@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 18 May 2020 10:38:26 +0100
Message-ID: <CACAyw9_cGqTs5JW2QyqnTm-M3khieMa7XwD3vqNiXWxRepmqMg@mail.gmail.com>
Subject: Re: "Forwarding" from TC classifier
To:     David Ahern <dsahern@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Martynas Pumputis <m@lambda.lt>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 May 2020 at 15:24, David Ahern <dsahern@gmail.com> wrote:
>
> On 5/15/20 3:59 AM, Lorenz Bauer wrote:
> >
> > Yes, but that doesn't play well with changing the source address to
> > the local machine's, since the upper part of the stack will drop the
> > packet due to accept_local=0.
>
> Can you defer the source address swap to the Tx path? Let the packet go
> up the stack and do the fib lookup again as an skb. neighbor entry does
> not exist, so the packet is stashed, neighbor resolution done, once
> resolved the packet goes out. tc program on the egress device can flip
> the source address, and then subsequent packets take the XDP fast path.

Hm, that's an interesting idea! I guess this means I have to mark the packet
somehow, to make sure I can identify it on the TX path. Plus, in theory
the packet could exit via any interface, so I'd have to attach classifiers to
a bunch of places if I want to be on the safe side.

Upside: this seems doable in current kernels. Downside: seems more fragile
than I'd like.

Thanks for the thought, I'll play around with it :)

>
> If the next host is on the same LAN I believe the stack will want to
> generate an ICMP redirect, but that can be squashed.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
