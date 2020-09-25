Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250FA279027
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 20:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbgIYSQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 14:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729620AbgIYSQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 14:16:36 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB64AC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 11:16:36 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id f18so3948880pfa.10
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 11:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v9iR6mHloE6gfRIECRuhgLrbJQ8VNSe9PJ0cyTqzgns=;
        b=jrrRv/+4GFPa3baxhqTT1LTI6+YFxfFCIx/zroH7WTr68qOU8KWMQhQaab2rXP423w
         bNsZi/3JrbIhEYtK5xpoJNt++EFj840MNIEBnCdtI99Nj1DfWq8GQgd/DNaACkGmtD6U
         8JbvzWVNtQJlewjagrgb2rEB/b3/j8XHu5qTnxbzcQ1FhiPWOc6KndR71uT4wUHGUWDN
         8egyPjqe/3wEpFlpS3Iv2NMvaerHs2dUzCBKu/C7+1fmezdzVpZvG5KpWE5LYYFZNfSj
         qFYDiJVKv5aotmfPmA2bkmalBNDI7v2Bh1D0kzAiXpO15+BUeIYinsgSVdzh7gYISqc4
         HPHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v9iR6mHloE6gfRIECRuhgLrbJQ8VNSe9PJ0cyTqzgns=;
        b=g9KIBrhtA1Fu4w5ZnmBWujWf9/JhTNjvd7X3CiUNpkMmehUGrilZTepYhPxISPaG+t
         l3UUtgLni/ECGGKhKoqkjzvseVGb/VqK14kSoxKJtUdmkhyoXUDp9HZ0ZmTy1/1w3qxy
         2Ve+LBiCAD9rOl+3VjH5BKDC2ob8wsQVVWV7+Y1OSytx6wwG7mnPV47Gf0DuRaT8O5px
         3z0ofcDva//OfHijKjAfhmRkvHUM9b5XbYStAcayWP97Mkkk+U8hEd+znJKCWApUVdYk
         HUaxONdZRYiHQgxAH8L35C3P1m8fPFyE1bnFKG2/FzsL8MAHNa/N+LLl4JPV7qbOq7JJ
         XaoA==
X-Gm-Message-State: AOAM531ZAdxu2mf6uelroqSGCfYZMOmCl5pjKUWbvD34KLU1/1081rfl
        dxbqbTObZ5cGpLWskJKab3h2ZQ==
X-Google-Smtp-Source: ABdhPJyvFyRVwct4kSFCuAn+Dk+wI7vPrv3U5UKXJKgEEY1xTBfLxxUhAXGfCXFrZg9c1y1Cyg/02Q==
X-Received: by 2002:a65:4c8e:: with SMTP id m14mr166142pgt.129.1601057796257;
        Fri, 25 Sep 2020 11:16:36 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n2sm2670359pja.41.2020.09.25.11.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 11:16:36 -0700 (PDT)
Date:   Fri, 25 Sep 2020 11:16:27 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Wei Wang <weiwan@google.com>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Subject: Re: [RFC PATCH net-next 0/6] implement kthread based napi poll
Message-ID: <20200925111627.047f5ed2@hermes.lan>
In-Reply-To: <CAEA6p_BBaSQJjTPicgjoDh17BxS9aFMb-o6ddqW3wDvPAMyrGQ@mail.gmail.com>
References: <20200914172453.1833883-1-weiwan@google.com>
        <CAJ8uoz30afXpbn+RXwN5BNMwrLAcW0Cn8tqP502oCLaKH0+kZg@mail.gmail.com>
        <CAEA6p_BBaSQJjTPicgjoDh17BxS9aFMb-o6ddqW3wDvPAMyrGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Sep 2020 10:15:25 -0700
Wei Wang <weiwan@google.com> wrote:

> > > In terms of performance, I ran tcp_rr tests with 1000 flows with
> > > various request/response sizes, with RFS/RPS disabled, and compared
> > > performance between softirq vs kthread. Host has 56 hyper threads and
> > > 100Gbps nic.

It would be good to similar tests on othere hardware. Not everyone has
server class hardware. There are people running web servers on untuned
servers over 10 years old; this may cause a regression there.

Not to mention the slower CPU's in embedded systems. How would this
impact OpenWrt or Android?

Another potential problem is that if you run real time (SCH_FIFO)
threads they have higher priority than kthread. So for that use
case, moving networking to kthread would break them.
