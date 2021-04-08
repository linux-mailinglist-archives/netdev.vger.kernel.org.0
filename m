Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A92357CCA
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 08:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhDHGw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 02:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhDHGw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 02:52:57 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068C9C061760;
        Wed,  7 Apr 2021 23:52:45 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 11so1090136pfn.9;
        Wed, 07 Apr 2021 23:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RUa2Y/X/JuFrDKhH2IyC+1UwqwEcbawiU1xeCyRoYL0=;
        b=HkG5Y12gVo2OK4ezHCYn7LcI2WHBfWMRVquQ0HfRv42kVpBVzEG7ButOJygMKjvxPX
         9YRZu8kNkcOhpox7sfaq5kn902DENXwomR6vI6P4jJAQY8/OfOlCtYMBotCnY5Q+GrU8
         oqCc8KCtOxfgTo8ruGebI8mannvtxDt1nNl3Xs7Gfa3gq66L1oDhU4bavl9IlD5J2Qln
         q8o1SV0Pz8o5Bpx0SG3g9QyE3IZcpKvQb60u/FXx/KCwTUs/hIp6hwh8xDjisT0H3jmt
         2BNsezat9OOTAxLNUt67sRoIPz3P+7dMXkN5L5FMm/leI7XYch70jB1zLwDlxt8egU20
         pKdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RUa2Y/X/JuFrDKhH2IyC+1UwqwEcbawiU1xeCyRoYL0=;
        b=uK3KW/kbUX9KouNmvSz9l9eQaq8wSj6BNlVsoLXn2Pl3cDr4EktWvQg0ybgOZKEdsm
         K41RMFo8TMz2o0AM+M/IBH7hOUYjyxAhVwrQMkVCyv7n+jl7/1q6YczrWFdpTO2U5KV1
         ABB2VkJIJ5T6mmRDVVKMbkB2P6SRvgl0ySGeoXe7JUQrcdQM+JsnBcUPSA4kfLj4D8LL
         YZDeaGp67Xx2jh3O3m1FfnfRo/3dGSJA6pO/8EtDE+IfsHJoA3VMEeCIY2Nu3r6E8YHC
         j6wcyv+MQf2WSBDfHNTsmWx0V5+YwOAogW2d1jjgEGVZiLok/sNptl0vLN+0gffeNNYw
         BC7Q==
X-Gm-Message-State: AOAM533CH5Vx0wPVXcUx/eAFEK/5uqScwxx8qOhzScEsoiOGlvLG7M6B
        t36kfUR6f2uegyZbyQoMggkP3Yo2xPKXTw==
X-Google-Smtp-Source: ABdhPJwmlKKGGVvqN0d9ugd30jB5C1MnHsEj7QDB0v2ScwNa99tmU8brneQ3g6VfOIf4oDgjPdOFLw==
X-Received: by 2002:a63:1646:: with SMTP id 6mr6943338pgw.321.1617864764614;
        Wed, 07 Apr 2021 23:52:44 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g15sm6930393pjd.2.2021.04.07.23.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 23:52:44 -0700 (PDT)
Date:   Thu, 8 Apr 2021 14:52:31 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
Message-ID: <20210408065231.GI2900@Leo-laptop-t470s>
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
 <CAHmME9p40M5oHDZXnFDXfO4-JuJ7bUB5BnsccGV1pksguz73sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9p40M5oHDZXnFDXfO4-JuJ7bUB5BnsccGV1pksguz73sg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 03:15:51PM -0600, Jason A. Donenfeld wrote:
> Hi Hangbin,
> 
> On Wed, Apr 7, 2021 at 5:39 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> >
> > As the cryptos(BLAKE2S, Curve25519, CHACHA20POLY1305) in WireGuard are not
> > FIPS certified, the WireGuard module should be disabled in FIPS mode.
> 
> I'm not sure this makes so much sense to do _in wireguard_. If you
> feel like the FIPS-allergic part is actually blake, 25519, chacha, and
> poly1305, then wouldn't it make most sense to disable _those_ modules
> instead? And then the various things that rely on those (such as
> wireguard, but maybe there are other things too, like
> security/keys/big_key.c) would be naturally disabled transitively?

Hi Jason,

I'm not familiar with the crypto code. From wg_noise_init() it looks the init
part is in header file. So I just disabled wireguard directly.

For disabling the modules. Hi Ondrej, do you know if there is any FIPS policy
in crypto part? There seems no handler when load not allowed crypto modules
in FIPS mode.

BTW, I also has a question, apart from the different RFC standard, what's the
relation/difference between crypto/chacha20poly1305.c and lib/crypto/chacha20poly1305.c?

Thanks
Hangbin
