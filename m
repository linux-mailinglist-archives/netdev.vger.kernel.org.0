Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFB6412A59
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 03:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbhIUBka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 21:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbhIUBin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:38:43 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F06AC128ED6
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 12:46:14 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id p29so71417978lfa.11
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 12:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z/4d6QJeGZCj2JNd8r06qB/o4KuGi6QEUdTRkNveq3w=;
        b=Q3LhEPOHc010gdfUc6e/0+OwWkLDILQAryxm4+BRnojSGhKUZx3i2JKpwpPFiraRMu
         E/I72DGNYfViGt4X8Hw5CpE7Nktij+mVRH+dEpKmPPQIoMBi3/lKCUfxw61t1pARyUwe
         w3uR28CSEpRp+LIB6b1M9E+jNUiv+vNeaFNjM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z/4d6QJeGZCj2JNd8r06qB/o4KuGi6QEUdTRkNveq3w=;
        b=5ej+UBB//WoHafHygOLRdDZRbHSnO00m6yqtLquU0Qm58YQ2MntVZUQom0Q3jmdWaR
         8euetrhH583M/L4DVy2BcX0NaDExgwV/HKR7xA9/V8jE1390DHk2mnxL1GcvfIKYjW5B
         +nAeTj7Rvir0u9bPCbJ9t5oRIDZVDTR7gStZJIiLp/VmKgpw/RUChiGoQhB2B0nCz1Xh
         mqHIoUKRO1OTa2MnfuRVnlinioLmuFSETWJpoiJ+uRq24Mf9Qbm+T4gNwE0s4o5CmjId
         xTGU8EsY4lNo7hxXASG/l/QiW7cghQzD62CqhBanTPub7BzCf59E5hiyV7R91QlkTEOR
         FYeg==
X-Gm-Message-State: AOAM533mPZPmjf7QP7LJPIuy+GT7HeXUyuq63H9mvZBJbZu+X4YRTMSk
        khW8/uoszTdeRuK9N9nw0ot81/Wuf+4FYMo8
X-Google-Smtp-Source: ABdhPJy/DilhiS/da//hZqBIPZByXzQ1HFnCJ8TgYItFht8aftrzz4bS303nStmhssXsxbkPN3ltQg==
X-Received: by 2002:a05:6512:3f1a:: with SMTP id y26mr21715539lfa.263.1632167171371;
        Mon, 20 Sep 2021 12:46:11 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id n7sm58979lft.309.2021.09.20.12.46.09
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 12:46:09 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id u8so20827859lff.9
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 12:46:09 -0700 (PDT)
X-Received: by 2002:a2e:3309:: with SMTP id d9mr12166105ljc.249.1632167169161;
 Mon, 20 Sep 2021 12:46:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wh-=tMO9iCA4v+WgPSd+Gbowe5kptwo+okahihnO2fAOA@mail.gmail.com>
 <202109201825.18KIPsV4026066@valdese.nms.ulrich-teichert.org>
 <CAHk-=wibRWoy4-ZkSVXUoGsUw5wKovPvRhS7r6VM+_GeBYZw1A@mail.gmail.com> <CAEdQ38HeUPDyiZhhriHqdA+Qeyrb3M=FoKWKgs0dZaEjbcpVUQ@mail.gmail.com>
In-Reply-To: <CAEdQ38HeUPDyiZhhriHqdA+Qeyrb3M=FoKWKgs0dZaEjbcpVUQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 20 Sep 2021 12:45:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj1JWZ3sCrGz16nxEj7=0O+srMg6Ah3iPTDXSPKEws_SA@mail.gmail.com>
Message-ID: <CAHk-=wj1JWZ3sCrGz16nxEj7=0O+srMg6Ah3iPTDXSPKEws_SA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Introduce and use absolute_pointer macro
To:     Matt Turner <mattst88@gmail.com>
Cc:     Ulrich Teichert <krypton@ulrich-teichert.org>,
        Michael Cree <mcree@orcon.net.nz>,
        Guenter Roeck <linux@roeck-us.net>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parisc <linux-parisc@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 11:59 AM Matt Turner <mattst88@gmail.com> wrote:
>
> In the decade plus I've been around Linux on alpha I've don't actually
> recall hearing of anyone using Linux on a Jensen system before :)

Looking around, I'm pretty sure the system I did all my initial work
on was a Jensen.

This is from the linux-.1.1.83 patch:

- * I don't have any good documentation on the EISA hardware interrupt
- * stuff: I don't know the mapping between the interrupt vector and the
- * EISA interrupt number.
- *
- * It *seems* to be 0x8X0 for EISA interrupt X, and 0x9X0 for the
- * local motherboard interrupts..
+ * The vector is 0x8X0 for EISA interrupt X, and 0x9X0 for the local
+ * motherboard interrupts.. This is for the Jensen.

So yup, my initial bringup machine was that DECpc AXP 150, aka "Jensen".

The IO subsystem on that thing was absolutely horrendous. Largely
because of the lack of byte/word accesses, so doing any PCI accesses
had to be encoded on the address bus. Nasty nasty nasty.

The original design with only 32-bit and 64-bit memory accesses really
was horribly horribly wrong, and all the arguments for it were
garbage. Even outside of IO issues, it blew up code size enormously,
but the IO side became truly horrendous.

Oh well. Water under the bridge.

I did have another alpha at some point - going from the original
150HMz EV4 to a 275MHz EV45. I forget what system that was.

               Linus
