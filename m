Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511A523F36A
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 21:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgHGT50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 15:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbgHGT5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 15:57:20 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF3EC061A27
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 12:57:20 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id v12so3421089ljc.10
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 12:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LT9fXEVxD8v7QkyLZvL1Rm7ltKej7kPnvBESreG7Qak=;
        b=R8kmtmqrmhxaBq5InMpqrHoOAtLk7n/JJZ1ZzXPvCJw9u0WjEnyJnnsoogXK0t8ewh
         fRaTpoRxnQ1ruaQNFl9XYjVbJC3v8FGcOhHW98nF9P7m3Lc72yCjwF7xyy6BMahDSuCR
         y3unTDv4ZLPkpf97nZIwQmDsr/KM5bVaK8kFM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LT9fXEVxD8v7QkyLZvL1Rm7ltKej7kPnvBESreG7Qak=;
        b=MWTHMMTgrz3Ih8sIxyN+Sfb3L5ByvQex3EcJ4Mx5tZ7CQnrcqA4Aq7cAcffAw7Nokv
         XbxJBnUQA7ZxI1nmIBo8ISKZtpoA+lRZf7P/XLuhFENUnNSMbEBwe9IuG0ZaNCS4zyu/
         FDUb7fqzPbNheMaheYz3IGQTNMeArdDFirRotwhkT5+/hZoTzF8MnhNGeLIKOF5kwO55
         jSaq9iYVUQEH7NrryOiShGMwRgGafacFXLw1GXlLnuGXBBnO3BaIo/JKekBXPTz2KW0/
         Mc25Efd2yT5Sd8llLa57RyIUvn8wyhJgE/YzomXTat7Gn+Fupr01J2MIjKbFRJgGMp+Z
         Iyaw==
X-Gm-Message-State: AOAM5339bq0Htxllx1YM7a3boeH2HUDTxUjdxsu6Pu638wd/ZsZCVvBl
        87ZAl+OYupWx+EFBz/TMfq65ciAMBrGcpQ==
X-Google-Smtp-Source: ABdhPJxs4j9WOhv8E5gq3qAUzV+H3wUm6ybpdi+RVk0Q9AJDGYbi13yCMrX8X1ArNMp0EfKpBvFQKQ==
X-Received: by 2002:a05:651c:106a:: with SMTP id y10mr6970002ljm.296.1596830236016;
        Fri, 07 Aug 2020 12:57:16 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id d5sm4181591ljc.80.2020.08.07.12.57.14
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 12:57:14 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id k13so1609516lfo.0
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 12:57:14 -0700 (PDT)
X-Received: by 2002:a05:6512:241:: with SMTP id b1mr7164028lfo.125.1596830233869;
 Fri, 07 Aug 2020 12:57:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=whf+_rWROqPUMr=Do0n1ADhkEeEFL0tY+M60TJZtdrq2A@mail.gmail.com>
 <BF4C5741-7433-4E96-B856-B25B049C9E49@amacapital.net>
In-Reply-To: <BF4C5741-7433-4E96-B856-B25B049C9E49@amacapital.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 7 Aug 2020 12:56:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=whPgKZRfK_Kfo6Oo+Aek-Z_U_Dxv9Y3HuNuHb5t=jLbcA@mail.gmail.com>
Message-ID: <CAHk-=whPgKZRfK_Kfo6Oo+Aek-Z_U_Dxv9Y3HuNuHb5t=jLbcA@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Willy Tarreau <w@1wt.eu>, Marc Plumb <lkml.mplumb@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 7, 2020 at 12:33 PM Andy Lutomirski <luto@amacapital.net> wrote:
>
> No one said we have to do only one ChaCha20 block per slow path hit.

Sure, doing more might be better for amortizing the cost.

But you have to be very careful about latency spikes. I would be
*really* nervous about doing a whole page at a time, when this is
called from routines that literally expect it to be less than 50
cycles.

So I would seriously suggest you look at a much smaller buffer. Maybe
not a single block, but definitely not multiple kB either.

Maybe something like 2 cachelines might be ok, but there's a reason
the current code only works with 16 bytes (or whatever) and only does
simple operations with no looping.

That's why I think you might look at a single double-round ChaCha20
instead. Maybe do it for two blocks - by the time you wrap around,
you'll have done more than a full ChaCaa20.

That would imnsho *much* better than doing some big block, and have
huge latency spikes and flush a large portion of your L1 when they
happen. Nasty nasty behavior.

I really think the whole "we can amortize it with bigger blocks" is
complete and utter garbage. It's classic "benchmarketing" crap.

             Linus
