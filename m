Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A0428E9E6
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 03:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731882AbgJOBUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 21:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387916AbgJOBTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 21:19:37 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AC3C051104
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 15:53:20 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id h6so1313400lfj.3
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 15:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9u2mhHcY3pY9y0h1f1D8mjxBc1UDKO7lgh+0IH/jA4Y=;
        b=E/v5G5HV93+1W4ZpS/VEGR4XVjhJ1Cziliaq421Y1vNYDKnUMeDn1lSbhTCyjPD4qn
         Ycb0GIFY8dVLWimGD6jGpxITZrHhe7xQpjsbikl7AnWc4mhoCouYfkP7/f4PH+VA3clz
         Cv+uRw1kdI5CfME+yVKJXQCOBYRkOHRUVhiFE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9u2mhHcY3pY9y0h1f1D8mjxBc1UDKO7lgh+0IH/jA4Y=;
        b=M3mRxcS6O1nFolmyWQX+hZgnZJRWJDGRmYTnGg+48R2p1nGm2E6Bk7YHLg1PZCAfRV
         grnFoIK1RJiR24+8Gpc0DHsoUYzal/eETVjhUZ5gYJXkxu8uh1odYQxE+6512T37J9Hd
         kT7ospec/qwlgnaac4TucMSky+3uzMbmoyE28VIgLxIsYUKPsEgjNa3i6tRPOGtVa7ID
         QaIb3LUjDjw6KvbCHMJNVwCsacvogV9XH8ueSyoif/dTKvxIybxaRdSULEw0drJKd/kc
         idRSqP+/zNbmwMfsF1PIyuVPwp9DG5Ivr27NC57TeZcc7d094USNcH1J6ODOM4yxTf1x
         MDpg==
X-Gm-Message-State: AOAM530GuJWGETXFd0G17+cttYe7PHqt6WlNWBUHFM1+dBCSar6MCais
        58F76LwKu/8kYILbWAA8acEU0fuuiGzPDQ==
X-Google-Smtp-Source: ABdhPJy0lWA5YPAuwdsN501ko9Z6CfNIXIviSBlHsPf1gboKL5akpgf66cMb/AHX+wIJmFtQyKjhmQ==
X-Received: by 2002:a05:6512:20a:: with SMTP id a10mr95486lfo.128.1602715998363;
        Wed, 14 Oct 2020 15:53:18 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id 196sm258999lfg.209.2020.10.14.15.53.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 15:53:17 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id d24so1278865lfa.8
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 15:53:17 -0700 (PDT)
X-Received: by 2002:a19:4815:: with SMTP id v21mr94354lfa.603.1602715996898;
 Wed, 14 Oct 2020 15:53:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200724012512.GK2786714@ZenIV.linux.org.uk> <20200724012546.302155-1-viro@ZenIV.linux.org.uk>
 <20200724012546.302155-20-viro@ZenIV.linux.org.uk> <20201014222650.GA390346@zx2c4.com>
 <CAHk-=wgTrpV=mT_EZF1BbWxqezrFJRJcaDtuM58qXMXk9=iaZA@mail.gmail.com>
In-Reply-To: <CAHk-=wgTrpV=mT_EZF1BbWxqezrFJRJcaDtuM58qXMXk9=iaZA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 14 Oct 2020 15:53:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj_rmS+kQvC9DccZy=UiUFJVFG9=fQajtfSCSP1h0Rofw@mail.gmail.com>
Message-ID: <CAHk-=wj_rmS+kQvC9DccZy=UiUFJVFG9=fQajtfSCSP1h0Rofw@mail.gmail.com>
Subject: Re: [PATCH v2 20/20] ppc: propagate the calling conventions change
 down to csum_partial_copy_generic()
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000abfabd05b1a965d0"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000abfabd05b1a965d0
Content-Type: text/plain; charset="UTF-8"

On Wed, Oct 14, 2020 at 3:51 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I think it's this instruction:
>
>         addi    r1,r1,16
>
> that should be removed from the function exit, because Al removed the
>
> -       stwu    r1,-16(r1)
>
> on function entry.
>
> So I think you end up with a corrupt stack pointer and basically
> random behavior.
>
> Mind trying that? (This is obviously all in
> arch/powerpc/lib/checksum_32.S, the csum_partial_copy_generic()
> function).

Patch attached to make it easier to test.

NOTE! This is ENTIRELY untested. My ppc asm is so rusty that I might
be barking entirely up the wrong tree, and I just made things much
worse.

                 Linus

--000000000000abfabd05b1a965d0
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
Content-ID: <f_kg9zpmo10>
X-Attachment-Id: f_kg9zpmo10

IGFyY2gvcG93ZXJwYy9saWIvY2hlY2tzdW1fMzIuUyB8IDEgLQogMSBmaWxlIGNoYW5nZWQsIDEg
ZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMvbGliL2NoZWNrc3VtXzMyLlMg
Yi9hcmNoL3Bvd2VycGMvbGliL2NoZWNrc3VtXzMyLlMKaW5kZXggZWM1Y2QyZGVkZTM1Li4yN2Q5
MDcwNjE3ZGYgMTAwNjQ0Ci0tLSBhL2FyY2gvcG93ZXJwYy9saWIvY2hlY2tzdW1fMzIuUworKysg
Yi9hcmNoL3Bvd2VycGMvbGliL2NoZWNrc3VtXzMyLlMKQEAgLTIzNiw3ICsyMzYsNiBAQCBfR0xP
QkFMKGNzdW1fcGFydGlhbF9jb3B5X2dlbmVyaWMpCiAJc2x3aQlyMCxyMCw4CiAJYWRkZQlyMTIs
cjEyLHIwCiA2NjoJYWRkemUJcjMscjEyCi0JYWRkaQlyMSxyMSwxNgogCWJlcWxyKwljcjcKIAly
bHdpbm0JcjMscjMsOCwwLDMxCS8qIG9kZCBkZXN0aW5hdGlvbiBhZGRyZXNzOiByb3RhdGUgb25l
IGJ5dGUgKi8KIAlibHIK
--000000000000abfabd05b1a965d0--
