Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD552E339C
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 03:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgL1C1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 21:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgL1C1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 21:27:37 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B929C061794
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 18:26:57 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id x16so12534403ejj.7
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 18:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B6kmz0aat0MAasSMAWamIgJHL8ZuTZ8pyC+dFQfH2SY=;
        b=q3kVSV8adbt9IDlMkPAqcrVw4t5hMX7VJpYlR+6hQYUzzvwKtIBAdQIJcaoCvDxnKB
         U9YxV3VXlGO5vD/zfsyApGm9jAzNiqjc8O2937dChSAcuZmunJXSvILqj+3ufW/nALl8
         vk7hvlW90KU0qyQiv9LBEFn2qgi9Y4q0HTgEmbSC1HO8zH4lqAkWHOTj47a/WdIxKmSf
         ou/xN6zKt6cdOzhyRKX/3iqcT66xYc1TtF4H6rOc1jE66CV4UbDzUQzJJgKrW2vll16F
         JN9LfIvTIdhLHY4xx1uzRxShIycB2AWwIL7nnUbatAENZfthLWhPb0PgKZvi8SQH05wn
         pJ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B6kmz0aat0MAasSMAWamIgJHL8ZuTZ8pyC+dFQfH2SY=;
        b=J00e86vRwSVTuYNCIIdmg4k8Ubnhra6a6AntUYpXed856NQzOzAw0/E6eGHSINERlN
         6KAflB95ivDEpxfQQJbvNMsnW/FEoI3jWSzqAZll0SAZE+Ap3956nBc0fl8StYDX7Ff8
         4nPc9ZWZAosto5uDNkBuGUpiONkib8kxSYFJADgJykgMwHMhCYaZmEW9iYaWFXNKzkae
         /ZgoUFdsx80FENa2OZkma0UwxHm2eKlKfKM3dwsWxr+P52NaXMhJxhV/FPYNfWpjD8x/
         Gj8NDDC4N9qZ0LUJdP4Uk7UpaERC4xBlzHAXgBNhHJwmb0F2KU6oN/e4OmmvXA9VWjrQ
         7Peg==
X-Gm-Message-State: AOAM530tFFCnC1Q1AacCXei571zBNpHocqLTi9TWbHgHEAsbTLsdDHc5
        wTiTNdtIoRWpJWwp7WA7+a7IMmkzexGqamC1i+M=
X-Google-Smtp-Source: ABdhPJw0/JOaUt/Y+lmQEnGytJjeUiipAj2z3ZpjRPoyJRv664ThWdWyGgH0xYfLxUcEGWr8cwBhGYj5jAptIR9Zc9g=
X-Received: by 2002:a17:906:b217:: with SMTP id p23mr947138ejz.461.1609122415557;
 Sun, 27 Dec 2020 18:26:55 -0800 (PST)
MIME-Version: 1.0
References: <20201226171308.4226-1-ap420073@gmail.com> <20201227163331.GB27369@linux.home>
In-Reply-To: <20201227163331.GB27369@linux.home>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Mon, 28 Dec 2020 11:26:44 +0900
Message-ID: <CAMArcTVQmwrbeT=LNsNhSP4Cykz-ZchbpS4RQJpo=J_F8Pv-aQ@mail.gmail.com>
Subject: Re: [PATCH net 2/2] bareudp: Fix use of incorrect min_headroom size
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Dec 2020 at 01:33, Guillaume Nault <gnault@redhat.com> wrote:
>

Hi Guillaume,
Thank you for the review!

> On Sat, Dec 26, 2020 at 05:13:08PM +0000, Taehee Yoo wrote:
> > In the bareudp6_xmit_skb(), it calculates min_headroom.
> > At that point, it uses struct iphdr, but it's not correct.
> > So panic could occur.
> > The struct ipv6hdr should be used.
> >
> > Test commands:
> >     ip netns add A
> >     ip netns add B
> >     ip link add veth0 type veth peer name veth1
> >     ip link set veth0 netns A
>
> Missing "ip link set veth1 netns B", so the reproducer unfortunately
> doesn't work.
>

Sorry, This is my mistake.

> BTW, you can also simplify the script by creating the veth devices
> directly in the right netns:
>   ip link add name veth0 netns A type veth peer name veth1 netns B
>

Thanks, It's really useful to me :)

> Apart from that,
> Acked-by: Guillaume Nault <gnault@redhat.com>
>
> And thanks a lot for the reproducers!

Thank you so much for the review,
I will send a v2 patch, which will fix a reproducer script.
