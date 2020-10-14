Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C19128E9DB
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 03:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388102AbgJOBUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 21:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388016AbgJOBTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 21:19:38 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43325C05BD3B
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 15:51:21 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id 77so1321115lfl.2
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 15:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r6oBIo6NMPMfLWaK5KgxYK4Ufg4k2ubTwgmyCFt3P0g=;
        b=NGV+3tygGODZy3py0l471EDO3cAhaCKm/0oH+GnoAnl8uVT08bj08gcxgVjtxWV8Tq
         Bed7WTMDPptLmWYRwNNDJfe+ozsotmCMfsUYGxxJdsub/va6psKbBlDpWECbhy12PwLh
         i1CkPu58C5kDeyvD9pLBgOx+0mzgUNJvq+gN4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r6oBIo6NMPMfLWaK5KgxYK4Ufg4k2ubTwgmyCFt3P0g=;
        b=SoFSHCLFqwXvK1fwkTOYaMwjUPOIB66b9eClzHN4uQiLwEMm+CrtJVWQUuuJ80n1oM
         taTSI6w4qujVaz1MCwMA+PYneYrHUncv+ZPDtV+Xuiub/C1we8zxvXgCcNO/M5WLgIfd
         kiFoyAYGp8J663ArSKuizSIe8FvUBjsEvR/mnMrMXUIWIfJqBIHT9FSA37d9yWIbmCff
         gTOrSR7551a183ECOCF7KXA3P3UXFuPc5ntHsroZ850bCEpvoiH0P5tGyNqEX5Yg16xS
         qxle1XcTAnEwC1Qv5eS0WcYXrW6+YFtiUdDArNiEfAsuhKb3fDxkBLEU/KLX2QoQnZMa
         yhAQ==
X-Gm-Message-State: AOAM532Ps0XeFWSDNH+/ca9yAovsGpVGoHwuKE/A835+ewtxPE26NOIL
        mJicuytUM4fAgiEaOJilWs6l18X15yca6A==
X-Google-Smtp-Source: ABdhPJwldV7lyNUEoWiJpFDqUdgGqUXKnwIOiYlf/vo7g+sHcUIsqZYuIAtLCe6xbR6r1FJf89a7bw==
X-Received: by 2002:ac2:434b:: with SMTP id o11mr97253lfl.576.1602715879335;
        Wed, 14 Oct 2020 15:51:19 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id a13sm432069ljm.40.2020.10.14.15.51.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 15:51:17 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id x16so1161488ljh.2
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 15:51:17 -0700 (PDT)
X-Received: by 2002:a2e:8815:: with SMTP id x21mr156315ljh.312.1602715877030;
 Wed, 14 Oct 2020 15:51:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200724012512.GK2786714@ZenIV.linux.org.uk> <20200724012546.302155-1-viro@ZenIV.linux.org.uk>
 <20200724012546.302155-20-viro@ZenIV.linux.org.uk> <20201014222650.GA390346@zx2c4.com>
In-Reply-To: <20201014222650.GA390346@zx2c4.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 14 Oct 2020 15:51:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgTrpV=mT_EZF1BbWxqezrFJRJcaDtuM58qXMXk9=iaZA@mail.gmail.com>
Message-ID: <CAHk-=wgTrpV=mT_EZF1BbWxqezrFJRJcaDtuM58qXMXk9=iaZA@mail.gmail.com>
Subject: Re: [PATCH v2 20/20] ppc: propagate the calling conventions change
 down to csum_partial_copy_generic()
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 3:27 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> This patch is causing crashes in WireGuard's CI over at
> https://www.wireguard.com/build-status/ . Apparently sending a simple
> network packet winds up triggering refcount_t's warn-on-saturate code. I

Ouch.

The C parts look fairly straightforward, and I don't see how they
could cause that odd refcount issue.

So I assume it's the low-level asm code conversion that is buggy. And
it's apparently the 32-bit conversion, since your ppc64 status looks
fine.

I think it's this instruction:

        addi    r1,r1,16

that should be removed from the function exit, because Al removed the

-       stwu    r1,-16(r1)

on function entry.

So I think you end up with a corrupt stack pointer and basically
random behavior.

Mind trying that? (This is obviously all in
arch/powerpc/lib/checksum_32.S, the csum_partial_copy_generic()
function).

               Linus
