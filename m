Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C746356B8D
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 13:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237614AbhDGLxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 07:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhDGLxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 07:53:11 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FDCC061756
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 04:52:44 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id v70so18272620qkb.8
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 04:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0x0f.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=55eowlIv9XaGPfPFjne3G8Mc95cycsZSFf0UWvAoo8Q=;
        b=HGObjUV0ojWTlUgb1FRqBgSphdDS64pPHTTSjhKGi3lNXzbIH8zcs3/WuSSOea86pV
         A13CKYUEjQzI9UskKmZyLPuepcm3n4DuDiRmgWEc8GhPyBBO1m9gRJOMdFJFI0yRMaHN
         KgqvyBSR2YRf+FMTk6w+ilRcAVwzgGcWCRQqs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=55eowlIv9XaGPfPFjne3G8Mc95cycsZSFf0UWvAoo8Q=;
        b=owHRt73y8QBH2LrPav3e/3HkekIMYMhOWnLcgoLptqvS+fhH9rL+087JneCJs/6c3w
         ao2Asndgi6AcoPaMeYWTh0y53jCLDu4BU191yFMaPHD7saLYHpqfhqBlKvJR3S9FHGPE
         dg6lBFCuwuGw9Gj2iMnIpYZCbzF6bUxGcPWBDbI+dRyxGgCYo5/X4LeKZbOqMBEWvSA+
         9rjjaMAjHm67ifPN8J2qFAKX/dGgR4GhKPkz7jLUmkj9EHXNevLfZOJCic6e+PHHXpYu
         F39QCZCpsv01oR5XvKv/OifHcP9Qb6LixlvKGU2xImkNzQZHXQYf8UhQTdHsB/t2ilzJ
         19IA==
X-Gm-Message-State: AOAM530eDGw4iecQOWj1EBgA3qeXaH01aQ3+4Z1xNnREkcx2nA9n+SNH
        KtDCKp63HdfEBat3pYbT1n3/z8rl+H39OsOFuMofrg==
X-Google-Smtp-Source: ABdhPJyjOipzONEMDRdvNH9XUQqPajnb0/9Yp7Dd63vRS547jAh352afy4V1ndxaYn9GPEj9ZlzPCnfUyLCaMflw7g0=
X-Received: by 2002:ae9:f70a:: with SMTP id s10mr2771884qkg.468.1617796364069;
 Wed, 07 Apr 2021 04:52:44 -0700 (PDT)
MIME-Version: 1.0
References: <20201209184740.16473-1-w@1wt.eu> <CAFr9PX=Ky2QuXNH09DmegFV=e-4+ChdypSsJfV8svqxP7U-cpg@mail.gmail.com>
 <20210407084207.GD22418@1wt.eu>
In-Reply-To: <20210407084207.GD22418@1wt.eu>
From:   Daniel Palmer <daniel@0x0f.com>
Date:   Wed, 7 Apr 2021 20:54:02 +0900
Message-ID: <CAFr9PXmNgWqHeZe-He0vhdGcRZtPwQa3Jrd-1vz5VBB9RixgLA@mail.gmail.com>
Subject: Re: [PATCH] Revert "macb: support the two tx descriptors on at91rm9200"
To:     Willy Tarreau <w@1wt.eu>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willy

On Wed, 7 Apr 2021 at 17:42, Willy Tarreau <w@1wt.eu> wrote:
> > There are two new status bits TBNQ and FBNQ at bits 7 and 8. I have no
> > idea what they mean.
>
> Maybe they're related to tx queue empty / tx queue full. Just guessing.
> Since all these bits tend not to be reset until written to, I got confused
> a few times trying to understand what they indicated.

In the vendor driver they have some weird logic that counts idle, bnq,
and these 6 new bits,
and if the count of set bits is bigger than 5 it's apparently OK to
setup another frame to send.
I guess it's some really optimized form of checking for the right
flags but it's over my head. :D

You have to check it's OK to send right before setting the frame
address/length otherwise you will get an overflow eventually.
So I think some of these bits are related to the state machine that is
handling popping frames out of the FIFO and the bits might change
between getting a TX complete interrupt and trying to queue another
frame. i.e. you can have a situation where there seems to be a free
slot in the irq handler but it's not actually safe to queue it when
xmit is called, and if you do an overflow happens and the TX locks up.

> > Anyhow. I'm working on a version of your patch that should work with
> > both the at91rm9200 and the MSC313E.
>
> Cool! Thanks for letting me know. If you need me to run some test, let
> me know (just don't expect too short latency these days but I definitely
> will test).

I got this working really well last night. 10+ hours with the iperf3
bidir test and it's still going. Before TX locked up within a few
seconds.
Once I've cleaned it up a bit more I'll push it to my mstar tree. I
don't think it can be mainlined yet as it's not usable without a bunch
of other bits.

Cheers,

Daniel
