Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFC0357688
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 23:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhDGVQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 17:16:17 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:51906 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhDGVQQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 17:16:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1617830163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dj6zfa/GP5natHQ72vven1EJnbcCzU9x4NJsUOnPZtE=;
        b=VyRPD0SlVbJs11ImYPlwXdbL4cFcQURe3FwHIcOJpVr+35f/fgqgtz8Aak8NYAKwnhYrsJ
        wBECU0M1sqZAOmy+Jq4jBMPEXZyT7r0z4rbrizAckvcuPbLmL15UizM9M+T6STWquuhmad
        hmQVQz8fqQB7qShwEajZMNwrcOyNrRk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2019155d (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 7 Apr 2021 21:16:03 +0000 (UTC)
Received: by mail-yb1-f177.google.com with SMTP id j206so231860ybj.11;
        Wed, 07 Apr 2021 14:16:03 -0700 (PDT)
X-Gm-Message-State: AOAM532bl/bYKL+1l0Ra083i9J/DS9P7BU/TywOvWd7abjPAD+fvlDQ9
        wIbbLf1CWSm1x4R4WnVuwK1FY8GbizmgOx/Z9s8=
X-Google-Smtp-Source: ABdhPJw8iSs2FvWFMKNX8PsiYqcA0uCAonU22hUi9MBcV4kssZLBSRxowu3UfTrES6Fsov44cQ5P9onN+sgB3HiPNaU=
X-Received: by 2002:a05:6902:1003:: with SMTP id w3mr2674341ybt.123.1617830162611;
 Wed, 07 Apr 2021 14:16:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
In-Reply-To: <20210407113920.3735505-1-liuhangbin@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 7 Apr 2021 15:15:51 -0600
X-Gmail-Original-Message-ID: <CAHmME9p40M5oHDZXnFDXfO4-JuJ7bUB5BnsccGV1pksguz73sg@mail.gmail.com>
Message-ID: <CAHmME9p40M5oHDZXnFDXfO4-JuJ7bUB5BnsccGV1pksguz73sg@mail.gmail.com>
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hangbin,

On Wed, Apr 7, 2021 at 5:39 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> As the cryptos(BLAKE2S, Curve25519, CHACHA20POLY1305) in WireGuard are not
> FIPS certified, the WireGuard module should be disabled in FIPS mode.

I'm not sure this makes so much sense to do _in wireguard_. If you
feel like the FIPS-allergic part is actually blake, 25519, chacha, and
poly1305, then wouldn't it make most sense to disable _those_ modules
instead? And then the various things that rely on those (such as
wireguard, but maybe there are other things too, like
security/keys/big_key.c) would be naturally disabled transitively?

[As an aside, I don't think any of this fips-flag-in-the-kernel makes
much sense at all for anything, but that seems like a different
discussion, maybe?]

Jason
