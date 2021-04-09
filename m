Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B028935A5CA
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbhDISaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:30:17 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:46354 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234049AbhDISaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 14:30:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1617992995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+0ncOBO/c3z/itUcQbIukquu48IT8Tw/ndnvlNHEQCg=;
        b=aP9fj+/h2K5ZpZ8OnsJeRAafDSYLpCLm3/GejqKWJEvB9yCha76Bm+SU8WVOVUIHX7eWL6
        9uaRTNU0mUiuC83skiTjml3Avf5UbTbfjzwNjbu/7ee7IyNFAHtyTrytITKM8q4PePgJtC
        zQT6iGGSInvTiN5O79453bXnNgFQldQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id dd1322ec (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 9 Apr 2021 18:29:54 +0000 (UTC)
Received: by mail-yb1-f172.google.com with SMTP id l14so1359280ybf.11;
        Fri, 09 Apr 2021 11:29:54 -0700 (PDT)
X-Gm-Message-State: AOAM53346EVS2Xg+ZJpOONO2fty80ud005TedT2zuZBvvdmRcbeYDxoZ
        gsh8rUXIB/0RVoVfQl71NwlioEItHtDFgSK2x6o=
X-Google-Smtp-Source: ABdhPJwVlAC/OHfEbxz18A0jkExt+gitOZduoT8tqKMkmGX4UEV1IuXXcMQi1Lk2zWVBXtmlDsJGVlKJ6ZVei275dUI=
X-Received: by 2002:a25:ad0f:: with SMTP id y15mr17625771ybi.306.1617992994050;
 Fri, 09 Apr 2021 11:29:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
 <YG4gO15Q2CzTwlO7@quark.localdomain> <20210408010640.GH2900@Leo-laptop-t470s>
 <20210408115808.GJ2900@Leo-laptop-t470s> <YG8dJpEEWP3PxUIm@sol.localdomain>
 <20210409021121.GK2900@Leo-laptop-t470s> <7c2b6eff291b2d326e96c3a5f9cd70aa4ef92df3.camel@chronox.de>
 <20210409080804.GO2900@Leo-laptop-t470s>
In-Reply-To: <20210409080804.GO2900@Leo-laptop-t470s>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 9 Apr 2021 12:29:42 -0600
X-Gmail-Original-Message-ID: <CAHmME9o53wa-_Rpk41Wd34O81o34ndpuej0xz9tThvqiHVeiSQ@mail.gmail.com>
Message-ID: <CAHmME9o53wa-_Rpk41Wd34O81o34ndpuej0xz9tThvqiHVeiSQ@mail.gmail.com>
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 9, 2021 at 2:08 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> After offline discussion with Herbert, here is
> what he said:
>
> """
> This is not a problem in RHEL8 because the Crypto API RNG replaces /dev/random
> in FIPS mode.
> """

So far as I can see, this isn't the case in the kernel sources I'm
reading? Maybe you're doing some userspace hack with CUSE? But at
least get_random_bytes doesn't behave this way...
