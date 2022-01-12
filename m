Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503C448C49A
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 14:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353423AbiALNQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 08:16:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37648 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241124AbiALNQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 08:16:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 956EBB81DFF;
        Wed, 12 Jan 2022 13:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12826C36AEF;
        Wed, 12 Jan 2022 13:16:43 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="FDlbmO1b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1641993401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+ERN5rRsPm0rpLZ8AUFAgKWDNZpuOr1YxLTNsM2DPHs=;
        b=FDlbmO1b2/VLSTE1GNuo7C38PFeDkNXxNThTVIYZF0zv/Ap1ViVU8MNih5dLfvQrgmxnBp
        wG9I8IvOdyWPi4IDm6T4Or/04g2EJYv5AgYi3lsavPmOFMX4BRfUS8DkVauubwoIcZ3zBM
        B2GAs+Jh9A0ZCxB4oSEnVhKE+Td9Iu0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f283f56e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 12 Jan 2022 13:16:41 +0000 (UTC)
Received: by mail-yb1-f170.google.com with SMTP id d7so6264444ybo.5;
        Wed, 12 Jan 2022 05:16:40 -0800 (PST)
X-Gm-Message-State: AOAM533kPNdRKU8huwF4Kv2AbR+Wey2wkNIxwgUEJBHZZNQhBBaVODhE
        8MJP5Y3e/C0G8t24CYjJyMquHKiQOKGGy1VZrR8=
X-Google-Smtp-Source: ABdhPJyOtRheGa3Nv5mPsxCc30bLc7gtenqAvHgaogN7DEA3AXXEPV/CTk5I92jjUNifY5K090QgZZp4Vh/SZ8imjew=
X-Received: by 2002:a25:854f:: with SMTP id f15mr12274112ybn.121.1641993399315;
 Wed, 12 Jan 2022 05:16:39 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9qbnYmhvsuarButi6s=58=FPiti0Z-QnGMJ=OsMzy1eOg@mail.gmail.com>
 <20220111134934.324663-1-Jason@zx2c4.com> <20220111134934.324663-2-Jason@zx2c4.com>
 <CAMuHMdWOheM0WsHNTA2dS=wJA8kXEYx6G78bnZ51T1X8HWdzNg@mail.gmail.com>
In-Reply-To: <CAMuHMdWOheM0WsHNTA2dS=wJA8kXEYx6G78bnZ51T1X8HWdzNg@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 12 Jan 2022 14:16:28 +0100
X-Gmail-Original-Message-ID: <CAHmME9q1Fm+m7JsGQWYY4qLApdaiqWHz-OYRE4qWjN1uA+HL9Q@mail.gmail.com>
Message-ID: <CAHmME9q1Fm+m7JsGQWYY4qLApdaiqWHz-OYRE4qWjN1uA+HL9Q@mail.gmail.com>
Subject: Re: [PATCH crypto 1/2] lib/crypto: blake2s-generic: reduce code size
 on small systems
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

Thanks for testing this. However, I've *abandoned* this patch, due to
unacceptable performance hits, and figuring out that we can accomplish
basically the same thing without as large of a hit by modifying the
obsolete sha1 implementation.

Herbert - please do not apply this patch. Instead, later versions of
this patchset (e.g. v3 [1] and potentially later if it comes to that)
are what should be applied.

Jason

[1] https://lore.kernel.org/linux-crypto/20220111220506.742067-1-Jason@zx2c4.com/
