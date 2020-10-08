Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B928287A0C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730891AbgJHQhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgJHQhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 12:37:39 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D58C061755;
        Thu,  8 Oct 2020 09:37:38 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id i2so6475249ljg.4;
        Thu, 08 Oct 2020 09:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=giqGv4A7bo6j0XttxPzeibyDwSiBktk0geQA99ohYK4=;
        b=iM1gWibKEFP8B+LrPUiyEHAfEGS7NNqNfXMe0/pZBTTR7OflOL4t5J8P/iepj1huw7
         ljRqgIPibY4bafQSCzzQv6fDSj4HysTGqpbVmAiMJUisHIQAY9lCT6a+ZFNbPuMmvbBp
         Z9J/3Dz4HnxaHMoJ4vWqczVFMm1i8FlwIyih+4CIaw2n4GeOGPrp8c822R1emXTrUO4Y
         B7vpJMEb35ELz3N1fCHPyKUMDyggHLcKpEWWgoKq2t8jJi37ytRs0+/cWG7QkVSZlqij
         H7tum6Sr2MNy1WXmTesuKUSWljNn+2qz4snuQqlAk+Q3onVGY1q5b9OHtyzKogRQxL0u
         ccWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=giqGv4A7bo6j0XttxPzeibyDwSiBktk0geQA99ohYK4=;
        b=KS9xcEdQwhI28PejlPehsKn7G/PZmxEmYgRklsDA4Qgy7goiMThCZcWg1PKc8l2R4k
         qdyhIunaOZVOz4WwDE6YYDBPnQrzCgu5Je6MyVzx7QgQvedL2qA3HKbJ6TAz2jehbdS2
         Givl7BnvkknDHocacu0mm7IczaDqBIBtdsQsWq6L4puZoN1t598R5ngADmmiJ3opkD2L
         IRN0HUTtxt6k3LAQFa0IfLErz/fE1x888hNM423Fehze/xufe1ivnqvZSuqgyTLFeMbJ
         DJEcTJyyj28cdo+PwBipNFvurD9IBajm9u3hr1cV49z8jjzHjddXoHiH2hIAee1ueDhV
         dNPQ==
X-Gm-Message-State: AOAM530g+QXHfiAB9bhymVo3+QShrByGF2TP/5wQSZCIlJyl7Kh0PKOw
        I4vB4w+j9xbPFbL6Tmg5SQVB5OnDAjvbO9UIr9E=
X-Google-Smtp-Source: ABdhPJzo407EegFfREoSioHdQB6lxd2A5ppGli7CXvWewWDZI3UXbULi8jSKXEOIaTyEQVyjnwD8H5aw2exMKYEXeZs=
X-Received: by 2002:a2e:864c:: with SMTP id i12mr3357537ljj.396.1602175057354;
 Thu, 08 Oct 2020 09:37:37 -0700 (PDT)
MIME-Version: 1.0
References: <20201008155048.17679-1-ap420073@gmail.com> <1cbb69d83188424e99b2d2482848ae64@AcuMS.aculab.com>
 <62f6c2bd11ed8b25c1cd4462ebc6db870adc4229.camel@sipsolutions.net>
In-Reply-To: <62f6c2bd11ed8b25c1cd4462ebc6db870adc4229.camel@sipsolutions.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Fri, 9 Oct 2020 01:37:26 +0900
Message-ID: <CAMArcTUkC2MzN9MiTu_Qwouj6rFf0g0ac2uZWfSKWHTW9cR8xA@mail.gmail.com>
Subject: Re: [PATCH net 000/117] net: avoid to remove module when its debugfs
 is being used
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     David Laight <David.Laight@aculab.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nicolai Stange <nicstange@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "wil6210@qti.qualcomm.com" <wil6210@qti.qualcomm.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Oct 2020 at 01:14, Johannes Berg <johannes@sipsolutions.net> wrote:
On Thu, 2020-10-08 at 15:59 +0000, David Laight wrote:

Hi Johannes and David,
Thank you for the review!

> From: Taehee Yoo
> > Sent: 08 October 2020 16:49
> >
> > When debugfs file is opened, its module should not be removed until
> > it's closed.
> > Because debugfs internally uses the module's data.
> > So, it could access freed memory.
> >
> > In order to avoid panic, it just sets .owner to THIS_MODULE.
> > So that all modules will be held when its debugfs file is opened.
>
> Can't you fix it in common code?

> Yeah I was just wondering that too - weren't the proxy_fops even already
> intended to fix this?

I didn't try to fix this issue in the common code(debugfs).
Because I thought It's a typical pattern of panic and THIS_MODULE
can fix it clearly.
So I couldn't think there is a root reason in the common code.

> The modules _should_ be removing the debugfs files, and then the
> proxy_fops should kick in, no?

If I understand your mention correctly,
you mean that when the module is being removed, the opened file
should be closed automatically by debugfs filesystem.
Is that right?

> So where's the issue?

> johannes

Thanks a lot!
Taehee
