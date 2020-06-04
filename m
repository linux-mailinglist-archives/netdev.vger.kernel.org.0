Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38171EDA26
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 02:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgFDAun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 20:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729323AbgFDAul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 20:50:41 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B64C03E96D;
        Wed,  3 Jun 2020 17:50:40 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id c11so5136287ljn.2;
        Wed, 03 Jun 2020 17:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MPLZOT/4bCsndxaWJtW6FhRuUjguIqCFp5N2dwDtYQ8=;
        b=jjo5yXOjBc6ExBZ0xU0p0U1vrAbDQBGzKMjBMieodOVuBzHGTF9DfthYYNAfEr4O8H
         rweetJbTqqdkWZQ2Mh+tJNCGkpf/fkl1rkUJQ8mQL3qjchZnqA0v3AMF1MBb2R/OeUUh
         DuErOylpGthQHIdGEr+3RVWllhk+DcvmzUIeBDjSdh5bWQzbscb+Y3ruNHUM8Dkq3sMo
         nn/nsSopZsp2D2DmmTBE1rVlfsSS3jD71ToiAPKVqzTq2U2pcrz+IKipSkRRITVVt4/Q
         y9VjEOyTc4mzSfqGsdsgNMIeHMEoqdZSRH5tVyANTF0vpIJUjGxVhNnyKfbEjw81HuWV
         wblw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MPLZOT/4bCsndxaWJtW6FhRuUjguIqCFp5N2dwDtYQ8=;
        b=DjrXUPzYidLMPzRrNYY3MRYwE6HysA13H+i/iQYGe++QAbl3O0F3TeWlaBdPoNrSV2
         UOTXG2uSvLAwJS1KonX2g7e2EJt88go15TGiVzxnQVjrA0VT7dtqPhsLcsy7EXq6/hNj
         QidZcrDEhcsBItYcTakBJvsogqfsz4RtyT+BAYH4dpY0gdOTEW4ytXPA+VPVsVrqG/uU
         zN0wnVp/XIydwGK9Qt8Uo4C3MXK/Qz+CigzHR32NxF073z07SpXrAxM6I5mhkPEX79Cz
         ih2/mNMxuDbz+wRYjm8KKcI/m5dxHj4oKdsux94wTkmj9AJBAx2BSFX14kjp7n6xoXrW
         vF1w==
X-Gm-Message-State: AOAM532LQHV2W6GDrVYuQ/ovBK7xqJ+lxmhCHTSdq4wBA3D1EqjCJCU7
        EVrWiNdgVB5CbYnb99MhzmxiysXyfYsOZ9uEbbrl0Poyl4o=
X-Google-Smtp-Source: ABdhPJziTNSuHWTzq2vssLq+q8Fk3g0gJzv6ZAQGOSjz3d+G2JKB1FM3MjsolLLYpNir2cIK2vJaKIQ5Hqvq0FlOkQ0=
X-Received: by 2002:a05:651c:11c7:: with SMTP id z7mr899332ljo.29.1591231838573;
 Wed, 03 Jun 2020 17:50:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200603233203.1695403-1-keescook@chromium.org> <20200603233203.1695403-11-keescook@chromium.org>
In-Reply-To: <20200603233203.1695403-11-keescook@chromium.org>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Thu, 4 Jun 2020 02:50:27 +0200
Message-ID: <CANiq72nJhZZ7Bc+VQpPrDjey0iD9TspbtodtGpKaZNz8NCaHww@mail.gmail.com>
Subject: Re: [PATCH 10/10] compiler: Remove uninitialized_var() macro
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-spi@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kees,

On Thu, Jun 4, 2020 at 1:32 AM Kees Cook <keescook@chromium.org> wrote:
>
> Using uninitialized_var() is dangerous as it papers over real bugs[1]
> (or can in the future), and suppresses unrelated compiler warnings
> (e.g. "unused variable"). If the compiler thinks it is uninitialized,
> either simply initialize the variable or make compiler changes.
>
> As recommended[2] by[3] Linus[4], remove the macro.
>
> [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
> [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
> [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
> [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

+1, one less trick split between `compiler*` files.

Reviewed-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

Cheers,
Miguel
