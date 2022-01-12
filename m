Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D89648C4AD
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 14:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353546AbiALNTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 08:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353532AbiALNSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 08:18:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7CDC061751;
        Wed, 12 Jan 2022 05:18:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC85D61937;
        Wed, 12 Jan 2022 13:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E525CC36AF8;
        Wed, 12 Jan 2022 13:18:49 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="d40SY2Xa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1641993526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rRXjtbrE2Eve7J58Q9IJgxX8+W28gZ0ioA+AryafyRo=;
        b=d40SY2XaCIk0dSlLUT5yjkzn3M731524Y1ppya4erUzgWWKIfM4qfTNSnK+z4My2VtBHXW
        kY3JoOps/+i3GCja/QwYYVHvShcqblBHaBFJwykbJvD7elDljSpfkdiDVO5apndncszVww
        r9uzpV3ySCfDaeWWK9lpAKJ0ZFgh8i4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 224c85a4 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 12 Jan 2022 13:18:46 +0000 (UTC)
Received: by mail-yb1-f181.google.com with SMTP id d7so6280573ybo.5;
        Wed, 12 Jan 2022 05:18:46 -0800 (PST)
X-Gm-Message-State: AOAM530eAxene4GT+qHasKW5c+BdwykkZE4SaeAHaysG9uZ0moqE1ZPi
        YwXEaoNRUSb2+7tWvaZjqzIjfF0Rtj75Kq+M8g8=
X-Google-Smtp-Source: ABdhPJyQQ3vU6dkRjERWgWVka3PYGzTNU58ke8Z1uEGxTGLJbZG9wlOxUKuZ4qw6Bp1eNeWmkh3Xxr5iM9ffSIBlHoE=
X-Received: by 2002:a5b:10:: with SMTP id a16mr12918334ybp.115.1641993525094;
 Wed, 12 Jan 2022 05:18:45 -0800 (PST)
MIME-Version: 1.0
References: <20220111181037.632969-1-Jason@zx2c4.com> <20220111220506.742067-1-Jason@zx2c4.com>
 <CAMuHMdUcJN_ZZLnx8TuhoXYV1DAKK9NsXjH2M0xAdn9JTS16wA@mail.gmail.com>
In-Reply-To: <CAMuHMdUcJN_ZZLnx8TuhoXYV1DAKK9NsXjH2M0xAdn9JTS16wA@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 12 Jan 2022 14:18:34 +0100
X-Gmail-Original-Message-ID: <CAHmME9rxdksVZkN4DF_GabsEPrSDrKbo1cVQs77B_s-e2jZ64A@mail.gmail.com>
Message-ID: <CAHmME9rxdksVZkN4DF_GabsEPrSDrKbo1cVQs77B_s-e2jZ64A@mail.gmail.com>
Subject: Re: [PATCH crypto v3 0/2] reduce code size from blake2s on m68k and
 other small platforms
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On Wed, Jan 12, 2022 at 12:00 PM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Thanks for the series!
>
> On m68k:
> add/remove: 1/4 grow/shrink: 0/1 up/down: 4/-4232 (-4228)
> Function                                     old     new   delta
> __ksymtab_blake2s256_hmac                     12       -     -12
> blake2s_init.constprop                        94       -     -94
> blake2s256_hmac                              302       -    -302
> sha1_transform                              4402     582   -3820
> Total: Before=4230537, After=4226309, chg -0.10%
>
> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Excellent, thanks for the breakdown. So this shaves off ~4k, which was
about what we were shooting for here, so I think indeed this series
accomplishes its goal of counteracting the addition of BLAKE2s.
Hopefully Herbert will apply this series for 5.17.

Jason
