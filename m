Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319A149C01D
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 01:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbiAZA13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 19:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiAZA13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 19:27:29 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B00C06161C
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 16:27:29 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id k17so11391545ybk.6
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 16:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=20Qfij14DgiaHmLZ6ARgGEry2aMOw85C49UED2yFNeM=;
        b=nrt8p5QDeZOkIPebj/YTqegtEr1gbb+l7d5/i0LQLFzyPD9dAiZuNrNMf0Laj/tUv5
         gGtUJuRY0x4CqfsiGTKLq4msMFENjvtJKKUotwundyCLj1HONdtnjDMRqoc+klQFVE09
         Fpo63i6Mgh5Siuo03E/HUJ4faLiQV/FWQNbu4PPYpyS/IiP2oQ9gM29xsls1jxwrUayq
         NzW10ONsk+DUjYNKd0GRsL/CsJ1H/CnqpYALeUeqsQru2SNrb7CY/uSG2Oe7MbHjdBNy
         JkEUiZ17stfTXOYiXBdLGP6FJfa6+oCt/+5EwYg0Dn+XgKBkUyZNhAmtFA9q0eLBtmsw
         SRvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=20Qfij14DgiaHmLZ6ARgGEry2aMOw85C49UED2yFNeM=;
        b=G4BrthBdbl23P8Ah2VLW1dxJf2FWCM0CvDB5yeS6HSGI0oAcxIErMV2wYd3GgWGu81
         D92n9bYvhg+/UlInmUf/KBAb8RXr4m92cuIfjVzP8OZ+aEI/DM5kfw/399sgX/ffGg4r
         TF0BSBtmlar9ycnoWVHQnHOMf6RwEeQabz1uebT/Qp7oQBbttO9u0/F4XDJc3jXEbea/
         ow4sV0wpC6SpftGS+5ZLizh7F1IjvY6onwcjcv/H5TbNYeVNDBxV7BNmCvd4QuiB/uUb
         eyKX5hUogZXOdt/0emLNV1K1wHuJtGepS1KKXCzesLbRhGjBonBWPZXOyKApw3+C1vAB
         GaDg==
X-Gm-Message-State: AOAM5328qTPJqoVKOfuf08I8EcIFKvMyUFFp6Z7h0e/sl1b1pe+7oli/
        RsgN3VKfAJLXsh6nEKgjb1T6IpC+aCYNIkXZaEgTqFf2OgILPg==
X-Google-Smtp-Source: ABdhPJxuiFZFTKTsjhytcVlgmGz/i9VpH/eRtXCHXfiRRNzGM1baFy+KFJmFd1HJzCR7fYTAh8pKh5SJJptgXCDUJms=
X-Received: by 2002:a25:b683:: with SMTP id s3mr32997436ybj.293.1643156848032;
 Tue, 25 Jan 2022 16:27:28 -0800 (PST)
MIME-Version: 1.0
References: <20220125024511.27480-1-dsahern@kernel.org> <CANn89i+b0phX3zfX7rwCHLzEYR6Y9JGXxRYa92M8PE9kbtg8Mg@mail.gmail.com>
 <6a53c204-9bc1-7fe9-07bc-6f3b7a006bce@gmail.com> <CANn89i+Nn7ce8=r07b00Acq9acmX9Lm6rTOx6L59REqaV2v68g@mail.gmail.com>
 <621185c7-be06-12a8-fe75-f544b392fb06@gmail.com>
In-Reply-To: <621185c7-be06-12a8-fe75-f544b392fb06@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 25 Jan 2022 16:27:16 -0800
Message-ID: <CANn89iLYJ2hnnm6krEKpk=n=Xx15mtc=GQVk=MGASCMZ1BSLBw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Adjust sk_gso_max_size once when set
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 3:49 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/25/22 10:20 AM, Eric Dumazet wrote:
> >> The git history does not explain why MAX_TCP_HEADER is used to lower
> >> sk_gso_max_size. Do you recall the history on it?
> >
> > Simply that max IP datagram size is 64K
> >
> > And TCP is sizing its payload size there (eg in  tcp_tso_autosize()),
> > when skb only contains payload.
> >
> > Headers are added later in various xmit layers.
> >
> > MAX_TCP_HEADER is chosen to avoid re-allocs of skb->head in typical workload.
>
> From what I can tell skb->head is allocated based on MAX_TCP_HEADER, and
> payload is added as frags for TSO.

Sure, but at the end, ip packet length field is 16bit wide, so
sizeof(network+tcp headers) + tcp_payload <= 65535

-> tcp_payload =< 65535 - sizeof(headers)

-> tcp_payload_max_per_skb = 65536 - ( MAX_TCP_HEADER + 1)

(This would not include Ethernet header)

>
> I was just curious because I noticed a few MTUs (I only looked multiples
> of 100 from 1500 to 9000) can get an extra segment in a TSO packet and
> stay under the 64kB limit if that offset had better information of the
> actual header size needed (if any beyond network + tcp).

TCP does not care about the extra sub-mss bytes that _could_ be added
to a TSO packet

So if I have 4K MTU (4096 bytes of payload), max TSO size would be 15*4k = 60K

Application writing 60*1024+100 bytes in one sendmsg() would send one
TSO packet of 15 segments, plus one extra tiny skb with 100 bytes of
payload.

I have played in the past trying to cover this case, but adding tests
in the fast path gave no noticeable difference for common workloads.
