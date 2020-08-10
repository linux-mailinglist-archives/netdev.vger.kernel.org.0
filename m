Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B2F240C4D
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 19:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgHJRps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 13:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgHJRpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 13:45:47 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28A9C061756
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 10:45:46 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id d2so5187640lfj.1
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 10:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HMDnYYwGdq+30SGu5JCkNhz46jOb7L2DmJQKoF6R49s=;
        b=eEYr7uGHSEifXQBm79KDX69OssyWfkIy3k6sDuDCM/bOL8jKMI3Ut9RfUn9tHd7JBG
         Os0d5QgT7WAQuRj3fuzwn2pxqP/1AY4wAM4sfEbpbz0OiVyfzfQoRatMjy9IUNN7vTJm
         SwimVTc1sKwHIfDxml8qruPzWplzSjyM0cVAQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HMDnYYwGdq+30SGu5JCkNhz46jOb7L2DmJQKoF6R49s=;
        b=MFwszwbinGXDXfm79UAo/vI66ldqqn+aAEAWYek1DxI2HLB+tYtG5EG2i2wXGmxfza
         Ww5/UnZYRnFIwFPo+borbdh1w72Xbg4Flmj88h8/qjSZ0+ksms/kQCpzr8Aof04QNHxM
         +nsAqhA3kVPlS25MiNayiQ4+1n6d0MmagtOW4u3kZCjpDw01VD/b8z+t7vaYOG3AWKxY
         wF+JtiZ3AEXH+VycNuy8Sc5TXJW+aBnO5QoyCH6UJpA+D0Hb0qHaICA3qRb/OYCgiCyr
         R8DoLAE806rSiHhQjPDM5u8uAMf4nhOTs1tGJdeHFcCx8kPjiMjUEXyCQZhQ7nyCmKAe
         kC4Q==
X-Gm-Message-State: AOAM5320hOcp62UnKCppLxkkbHvy55tCtGXCRXV8pAnPnYpmebk2tz/g
        LTXRoKhI5v6bQX4dtDPsUMFuJ4VaZZM=
X-Google-Smtp-Source: ABdhPJxyAED4UHOIgcRUCK5iGs1guVooD3lyg70SWgMrLuArOqeocwdcGvnXAuCMlEtRzHl7IIeFog==
X-Received: by 2002:a19:c519:: with SMTP id w25mr1144026lfe.24.1597081544801;
        Mon, 10 Aug 2020 10:45:44 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id a9sm9338375ljb.57.2020.08.10.10.45.42
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 10:45:43 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id b30so5176186lfj.12
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 10:45:42 -0700 (PDT)
X-Received: by 2002:ac2:46d0:: with SMTP id p16mr1152503lfo.142.1597081542480;
 Mon, 10 Aug 2020 10:45:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200808152628.GA27941@SDF.ORG> <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu> <20200809170639.GB25124@SDF.ORG>
 <20200809173302.GA8027@1wt.eu> <20200809183017.GC25124@SDF.ORG>
 <20200810114700.GB8474@1wt.eu> <CAHk-=wihkv1EtqcKcMS2kUQB86WRykQhknOnH08OcBH0Cz3Jtg@mail.gmail.com>
 <20200810165859.GD9060@1wt.eu>
In-Reply-To: <20200810165859.GD9060@1wt.eu>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 10 Aug 2020 10:45:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiSbHyA3zpkNVf9G8uHDJ=JF12iUjMRH5h65DQf8VXDtg@mail.gmail.com>
Message-ID: <CAHk-=wiSbHyA3zpkNVf9G8uHDJ=JF12iUjMRH5h65DQf8VXDtg@mail.gmail.com>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
To:     Willy Tarreau <w@1wt.eu>
Cc:     George Spelvin <lkml@sdf.org>, Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Marc Plumb <lkml.mplumb@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 9:59 AM Willy Tarreau <w@1wt.eu> wrote:
>
> I took what we were already using in add_interrupt_randomness() since
> I considered that if it was acceptable there, it probably was elsewhere.

Once you've taken an interrupt, you're doing IO anyway, and the
interrupt costs will dominate anything you do.

But the prandom_u32() interface is potentially done many times per
interrupt. For all I know it's done inside fairly critical locks etc
too.

So I don't think one usage translates to another very well.

              Linus
