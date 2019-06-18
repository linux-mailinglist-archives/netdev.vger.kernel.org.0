Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28FB84ACD9
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 23:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731010AbfFRVGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 17:06:48 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45992 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730653AbfFRVGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 17:06:48 -0400
Received: by mail-qk1-f196.google.com with SMTP id s22so9533227qkj.12;
        Tue, 18 Jun 2019 14:06:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PhQShykXloliKPMckMupDfwZ8pnrhdgE2i1x2GgfEmI=;
        b=ukYtKO2nfsZfAhueJCu8NbbqpXKNV9imjzRX1HUortW+t4FD/FJfJfeITZ+1twwwMg
         CI2wrEqy7Tv8NSh6F4EHTfafRnZRLBn5pVzJ+gcrfUNj67UVHaZ3WJIZHCu/K8939Ljo
         5BZtqE7tx/uXsAuwxDTT6zVHQgbAj9HjZjB4SOG/R/NIZws5VlUqUH9J/WAXJEsLRroA
         dKatXBmMA4gYt5raPpWpjxrvRYR1gtqcfbNAdCOrza8z6NfwqXITHwTHTM9LhPONR2Wk
         3OSzjSHvQpFO0EQR+hcnpTxX60v5YOC6zkQFFKvVKpCfoRu2zkOAB7ye+dTklVHrj/RC
         wl3A==
X-Gm-Message-State: APjAAAUV8A7HskDg77MLPUGecQnpUyN54i+hN1lCfX6hcx8TII1r7rpY
        7jum8HwifWtM9SsZPmZPni0O96vaooHfRDK9lz8=
X-Google-Smtp-Source: APXvYqyldOckhcLwc1fQrwZ7LnDDOLS2W9t7zPz5YSzYHLSMEwkWyDge/ONSs2cFdXB+lyGj7IX6kT1wQZim1MIdYpE=
X-Received: by 2002:ae9:e608:: with SMTP id z8mr87456546qkf.182.1560892007052;
 Tue, 18 Jun 2019 14:06:47 -0700 (PDT)
MIME-Version: 1.0
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
 <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
 <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
 <fc0d08912bc10ad089eb74034726308375279130.camel@redhat.com>
 <36bca57c999f611353fd9741c55bb2a7@codeaurora.org> <153fafb91267147cf22e2bf102dd822933ec823a.camel@redhat.com>
 <CAK8P3a2Y+tcL1-V57dtypWHndNT3eDJdcKj29c_v+k8o1HHQig@mail.gmail.com>
 <f4249aa5f5acdd90275eda35aa16f3cfb29d29be.camel@redhat.com>
 <CAK8P3a2nzZKtshYfomOOSYkqx5HdU15Wr9b+3va0B1euNhFOAg@mail.gmail.com>
 <dbb32f185d2c3a654083ee0a7188379e1f88d899.camel@sipsolutions.net>
 <d533b708-c97a-710d-1138-3ae79107f209@linaro.org> <abdfc6b3a9981bcdef40f85f5442a425ce109010.camel@sipsolutions.net>
 <CAK8P3a3ksrFTo2+dLB+doLeY+kPP7rYxv2O7BwvjYgK2cwCTuQ@mail.gmail.com>
 <97cbfb3723607c95d78e25785262ae7b0acdb11c.camel@sipsolutions.net>
 <CAK8P3a29+JKbDdS9ikhgaKa-AJ1qd1sDMTAfzivGh5wN4VL88A@mail.gmail.com> <54a5acb6cf26ebc6447f8ebcbdcb8e0eed693ab3.camel@sipsolutions.net>
In-Reply-To: <54a5acb6cf26ebc6447f8ebcbdcb8e0eed693ab3.camel@sipsolutions.net>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 18 Jun 2019 23:06:29 +0200
Message-ID: <CAK8P3a3r95gXMdq7s9GF=37v6t4kR+-2iyC6bnmUDVuM+bn80Q@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Alex Elder <elder@linaro.org>, Dan Williams <dcbw@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        abhishek.esse@gmail.com, Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        syadagir@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 10:39 PM Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2019-06-18 at 22:33 +0200, Arnd Bergmann wrote:

> It seems to me though that this is far more complex than what I'm
> proposing? What I'm proposing there doesn't even need any userspace
> involvement, as long as all the pieces are in the different sub-drivers,
> they'd fall out automatically.
>
> And realistically, the wwan_device falls out anyway at some point, the
> only question is if we really make one specific driver be the "owner" of
> it. I'm suggesting that we don't, and just make its lifetime depend on
> the links to parts it has (unless something like IPA actually wants to
> be an owner).

My feeling so far is that having the wwan_device be owned by a device
gives a nicer abstraction model that is also simpler for the common
case. A device driver like ipa would end up with a probe() function
that does does wwan_device_alloc/wwan_device_register, corresponding
to alloc_etherdev/register_netdev, and then communicates through
callbacks.

I agree the compound device case would get more complex by
shoehorning it into this model, but that can be a valid tradeoff
if it's the exceptional case rather than the common one.

      Arnd
