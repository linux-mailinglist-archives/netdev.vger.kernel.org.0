Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2BA357D6E
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 09:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhDHHhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 03:37:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32953 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229517AbhDHHhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 03:37:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617867420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SVnxZGgW9Qxm2H1d4NzfReZMQBZ6OMN/TWyOftpZfrI=;
        b=Rg+xnXqQEX1NdE3dqHkKpPpb2qoxEzGU+/EBhk1lwnDw3sDYKqiihRZ7MIQG/RqG4G0vz6
        7fTHgkJ4poCUCid15bZAf0BSy7BD8r4eNAyG83OnnHnaGkhqaVlH1vma9Xl0+mAAlilj06
        gXSf19I/C3XXlH5zInemcwJG5ISr2po=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-F09wmPQYNiCmWm0oXvXBiQ-1; Thu, 08 Apr 2021 03:36:58 -0400
X-MC-Unique: F09wmPQYNiCmWm0oXvXBiQ-1
Received: by mail-yb1-f198.google.com with SMTP id i2so1336255ybl.21
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 00:36:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SVnxZGgW9Qxm2H1d4NzfReZMQBZ6OMN/TWyOftpZfrI=;
        b=CRh9gNIEC2Tux1kMjKdEgOSISey01ipxkYUPQcEG4yDpTf8mNMP2UbZ3Hr/6zhyDUo
         ENmROM4eJsI80l2Sa1YZ06OBpp7xuBMHATjk/2qVLYwg+VUs4w4XlArl4y6I1EIm1kp4
         /pSydagH4aGEKtwc2jkVzGLo0Z7X4uJgNSt/kzPGtyNJZ7rtHnCzgwzoqi14X3kF2tCq
         zKVzVSyqhzeVND8ILYIIKQOxdwPY2m32oDKyuNGNKvc3HOcDBU7pzT43t5E7CZGlhF72
         BXVwaH1UUk6XNF58SrYrPe+v5J1cDYHVE+iJpz2v9Zh8q00Wro1I00htySFBj9k9aswa
         5KWg==
X-Gm-Message-State: AOAM532FsKSG8PkUZVjaXJhuIo7QGZq4vELvtTC8ESYnaHeDDNdraSwn
        CnVtKdU1d+tybMn5i4whExNgHCv918VcqrbU6TbdZXg6asAqrbq901qijhrSS7grxNk/kUv2B7P
        zVW/yWyqnObW+X9ipCJlWvfvgBYGPa8OR
X-Received: by 2002:a5b:8c9:: with SMTP id w9mr10259910ybq.289.1617867418314;
        Thu, 08 Apr 2021 00:36:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyk1DLKIzXwiqHwH4GxtDWZM43edW9uuwjBBqA2y9GHE2IfNOz7vaODTT3FsioURaRTBFHXsrK/F9LuEcIcDE=
X-Received: by 2002:a5b:8c9:: with SMTP id w9mr10259896ybq.289.1617867418074;
 Thu, 08 Apr 2021 00:36:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
 <CAHmME9p40M5oHDZXnFDXfO4-JuJ7bUB5BnsccGV1pksguz73sg@mail.gmail.com> <20210408065231.GI2900@Leo-laptop-t470s>
In-Reply-To: <20210408065231.GI2900@Leo-laptop-t470s>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Thu, 8 Apr 2021 09:36:44 +0200
Message-ID: <CAFqZXNuk6wqTb+m4ttyU_4UN5TjqSdvUiOJ=peztUUiyY+ReJQ@mail.gmail.com>
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 8, 2021 at 8:52 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> On Wed, Apr 07, 2021 at 03:15:51PM -0600, Jason A. Donenfeld wrote:
> > Hi Hangbin,
> >
> > On Wed, Apr 7, 2021 at 5:39 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> > >
> > > As the cryptos(BLAKE2S, Curve25519, CHACHA20POLY1305) in WireGuard are not
> > > FIPS certified, the WireGuard module should be disabled in FIPS mode.
> >
> > I'm not sure this makes so much sense to do _in wireguard_. If you
> > feel like the FIPS-allergic part is actually blake, 25519, chacha, and
> > poly1305, then wouldn't it make most sense to disable _those_ modules
> > instead? And then the various things that rely on those (such as
> > wireguard, but maybe there are other things too, like
> > security/keys/big_key.c) would be naturally disabled transitively?
>
> Hi Jason,
>
> I'm not familiar with the crypto code. From wg_noise_init() it looks the init
> part is in header file. So I just disabled wireguard directly.
>
> For disabling the modules. Hi Ondrej, do you know if there is any FIPS policy
> in crypto part? There seems no handler when load not allowed crypto modules
> in FIPS mode.

If I understand your question correctly, yes, there is a mechanism
that disables not-FIPS-approved algorithms/drivers in FIPS mode (not
kernel modules themselves, AFAIK). So if any part of the kernel tries
to use e.g. chacha20 via the Crypto API (the bits in crypto/...), it
will fail. I'm not sure about the direct library interface (the bits
in lib/crypto/...) though... That's relatively new and I haven't been
following the upstream development in this area that closely for some
time now...

>
> BTW, I also has a question, apart from the different RFC standard, what's the
> relation/difference between crypto/chacha20poly1305.c and lib/crypto/chacha20poly1305.c?
>
> Thanks
> Hangbin
>

-- 
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

