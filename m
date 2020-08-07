Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16FD223F28D
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 20:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgHGSKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 14:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgHGSKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 14:10:39 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080C2C061756
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 11:10:39 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id z14so3176278ljm.1
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 11:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZuMZhLaLnOL/xHC8VZQJDfaqHK+dWPlzzoa/rHVDySY=;
        b=hp3wruGBgMl3qDowQy031caRIO4JiMrZVpDijEr1AkV+ZTBT55IiLiOnOOYUAfiLNJ
         vpXZ5maf7VrbTancPdYdV5CSaDlXcoWjNjxXQLcvYpo+SfeAQ6K3YqTTiDXRwPbMuBYh
         2TEW+2b62x8SXQcL767MXDD6KRoZvSOoL63RU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZuMZhLaLnOL/xHC8VZQJDfaqHK+dWPlzzoa/rHVDySY=;
        b=QLPZUisQpuja+OhVSSI+Y2Q45oj6CHtXmIrNzj34RDLAOnC9BxySqYx9ufKhazH2uf
         SxRttyaqyfkNVHJSV5wE2mduG6WaFDY+CcHt8nPycYx3W7iy8j8Ou4PvL9jS6P1QE4Kf
         5bsHmb3e2bOy/KFuVsbTFhxMAREVQgSZE0+JrnBKktsNF7XOHFOvOgsZejnkyqkOLZUo
         aFkN+EaT2vdWOEninIvmsi7LCfw+lT1OSrke2xoK81BXsILEoeoM0REuPeTBrRGD3ILl
         EjbpRHTblxSc5r4qfPVvdsS58fqlLW9chqnVbivmP9bv6WJgznuBk2aq0erNcXulIUV6
         7Lew==
X-Gm-Message-State: AOAM531XpJtIqNMEnZMt4sUsdx8kZIJwXEdNa5YrEAepc9CJ38lag5FJ
        K81NSVNxZvDgkXj49sNEQXongonbLGk=
X-Google-Smtp-Source: ABdhPJz5NER3VR8NqjCx7UvtnosUrUYNLLERxQzs25buW6wcOCaZ3qWNAIDemv2OuUss6ru9sFR+HQ==
X-Received: by 2002:a2e:a58a:: with SMTP id m10mr6497539ljp.247.1596823834697;
        Fri, 07 Aug 2020 11:10:34 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id j16sm3505460ljg.31.2020.08.07.11.10.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 11:10:33 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id k13so1460600lfo.0
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 11:10:32 -0700 (PDT)
X-Received: by 2002:ac2:58d5:: with SMTP id u21mr6821303lfo.31.1596823832127;
 Fri, 07 Aug 2020 11:10:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200807174302.GA6740@1wt.eu> <C74EC3BC-F892-416F-A95C-4ACFC96EEECE@amacapital.net>
In-Reply-To: <C74EC3BC-F892-416F-A95C-4ACFC96EEECE@amacapital.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 7 Aug 2020 11:10:16 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj4p3wCZpD2QU-d_RPTAsGiAUWHMiiVUv6N3qxx4w9f7A@mail.gmail.com>
Message-ID: <CAHk-=wj4p3wCZpD2QU-d_RPTAsGiAUWHMiiVUv6N3qxx4w9f7A@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 7, 2020 at 10:55 AM Andy Lutomirski <luto@amacapital.net> wrote=
:
>
> I think the real random.c can run plenty fast. It=E2=80=99s ChaCha20 plus=
 ludicrous overhead right now.

I doubt it.

I tried something very much like that in user space to just see how
many cycles it ended up being.

I made a "just raw ChaCha20", and it was already much too slow for
what some of the networking people claim to want.

And maybe they are asking for too much, but if they think it's too
slow, they'll not use it, and then we're back to square one.

Now, what *might* be acceptable is to not do ChaCha20, but simply do a
single double-round of it.

So after doing 10 prandom_u32() calls, you'd have done a full
ChaCha20. I didn't actually try that, but from looking at the costs
from trying the full thing, I think it might be in the right ballpark.

How does that sound to people?

                 Linus
