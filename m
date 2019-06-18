Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4904E49DF7
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 12:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfFRKDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 06:03:13 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37527 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbfFRKDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 06:03:11 -0400
Received: by mail-io1-f67.google.com with SMTP id e5so28458932iok.4
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 03:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nJWZTkerYqxZ8gox46rKtBpw5zXrYUkGFpFgduRzBEM=;
        b=Ia2sw0NT56vt9MAhKYJr79OAixoaXcvg6diSg0meFCUnwWd/eCu8gUH7+O4ae+rgf1
         cdq41wz+PlzpG2b9JAvj481SrxZqhHTebNXphQ96w0Ela7iHjuELF5OWTaWxa7MKS+a9
         RsNdIeLuOsSBghpWBf6nxFrsR5gMUMxB/IRtUWLbVOwAR+4nkvTFYPaWkS+N9BfjkHSi
         wrZY0MV4ZO9JGi/TWadOXa5eI6LcGpIMtp9pNs7VKCUj93tMppy/N9ImARlkHkr5jqzp
         TQIQ/86hcvWog/4DiaZjEPWCxOyY8K+vD5kQrhEkHoCbQB5APcbYf5zN1Rx14sHx0Qtv
         K1fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nJWZTkerYqxZ8gox46rKtBpw5zXrYUkGFpFgduRzBEM=;
        b=K3TLkvdXEDZxQzmi8oxZd+NkfmnSWmTAAtxpEyYVr4lIEJH3Lt+3PCVBVaiQ/vlVF/
         91mMrvMUU1BhVJgHdBxPFXc8J2ao77h/JHUKDhw0qJsabh+j50pNvyy/YLlouVU87Ecu
         MDb29vVREIKpZ5htdNSVMS9s/owiZeQTOOQXPzpZTSf9OwW/YlyNDg1yI53BUHAnJTqu
         671SkSP9suAogoob2aSnxxA0Qrr3UHC+kr7d+X72Mzibq6c5m/HFHvzjCi5U5DgwdPx0
         yNr82UkrPwUThvcnUClphuN2t29maXoSu/CmDCscoCncayvapbswodPZSDHNf0gSgxrs
         ZC1A==
X-Gm-Message-State: APjAAAXFLmrRLqmBoKR0yuiZKwdisejI6d0fYjr7p5r+25XqkSgVKIT3
        vAyApgyzZBbS9HpY4uWx8LJiU568hSTm31cvzVqqOA==
X-Google-Smtp-Source: APXvYqyC/Ng32ZvFlhOwyn4z6NWnGD8Z+TDbznbemfj3+nPbVGf9H4m+90QigvpO9vzeq2jl13PBsRtecex4kvAUspw=
X-Received: by 2002:a02:ce37:: with SMTP id v23mr2244603jar.2.1560852191037;
 Tue, 18 Jun 2019 03:03:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190618093207.13436-1-ard.biesheuvel@linaro.org>
 <20190618093207.13436-2-ard.biesheuvel@linaro.org> <CANn89iJuTq36KMf1madQH08g6K0a-Uj-PDH80ao9zuEw+WNcZg@mail.gmail.com>
 <CAKv+Gu894bEEzpKNDTaNiiNJTFoUTYQuFjBBm-ezdkrzW5fyNQ@mail.gmail.com> <CANn89i+X7YQ6DueDQAusA+1S5Kmo75OwzO+eYRZe_nR8=YWjuQ@mail.gmail.com>
In-Reply-To: <CANn89i+X7YQ6DueDQAusA+1S5Kmo75OwzO+eYRZe_nR8=YWjuQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 18 Jun 2019 12:02:59 +0200
Message-ID: <CAKv+Gu9sjaCix_MkKHd=2tfGgaxehTrEw_mzAoOOFbkT4xxCVQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: fastopen: make key handling more robust against
 future changes
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Christoph Paasch <cpaasch@apple.com>,
        David Laight <David.Laight@aculab.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jun 2019 at 11:53, Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Jun 18, 2019 at 2:41 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > On Tue, 18 Jun 2019 at 11:39, Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Tue, Jun 18, 2019 at 2:32 AM Ard Biesheuvel
> > > <ard.biesheuvel@linaro.org> wrote:
> > > >
> > > > Some changes to the TCP fastopen code to make it more robust
> > > > against future changes in the choice of key/cookie size, etc.
> > > >
> > > > - Instead of keeping the SipHash key in an untyped u8[] buffer
> > > >   and casting it to the right type upon use, use the correct
> > > >   siphash_key_t type directly. This ensures that the key will
> > > >   appear at the correct alignment if we ever change the way
> > > >   these data structures are allocated. (Currently, they are
> > > >   only allocated via kmalloc so they always appear at the
> > > >   correct alignment)
> > > >
> > > > - Use DIV_ROUND_UP when sizing the u64[] array to hold the
> > > >   cookie, so it is always of sufficient size, even when
> > > >   TCP_FASTOPEN_COOKIE_MAX is no longer a multiple of 8.
> > > >
> > > > - Add a key length check to tcp_fastopen_reset_cipher(). No
> > > >   callers exist currently that fail this check (they all pass
> > > >   compile constant values that equal TCP_FASTOPEN_KEY_LENGTH),
> > > >   but future changes might create problems, e.g., by leaving part
> > > >   of the key uninitialized, or overflowing the key buffers.
> > > >
> > > > Note that none of these are functional changes wrt the current
> > > > state of the code.
> > > >
> > > ...
> > >
> > > > -       memcpy(ctx->key[0], primary_key, len);
> > > > +       if (unlikely(len != TCP_FASTOPEN_KEY_LENGTH)) {
> > > > +               pr_err("TCP: TFO key length %u invalid\n", len);
> > > > +               err = -EINVAL;
> > > > +               goto out;
> > > > +       }
> > >
> > >
> > > Why a pr_err() is there ?
> > >
> > > Can unpriv users flood the syslog ?
> >
> > They can if they could do so before: there was a call to
> > crypto_cipher_setkey() in the original pre-SipHash code which would
> > also result in a pr_err() on an invalid key length. That call got
> > removed along with the AES cipher handling, and this basically
> > reinstates it, as suggested by EricB.
>
> This tcp_fastopen_reset_cipher() function is internal to TCP stack, all callers
> always pass the correct length.
>
> We could add checks all over the place, and end up having a TCP stack
> full of defensive
> checks and 10,000 additional lines of code :/
>
> I would prefer not reinstating this.

Fair enough.
