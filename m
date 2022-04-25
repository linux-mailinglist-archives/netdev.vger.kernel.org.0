Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7234450E716
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 19:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235975AbiDYR2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 13:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243938AbiDYR16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 13:27:58 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ADF240E7D
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 10:24:53 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2f7b90e8b37so78498897b3.6
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 10:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b8rnUZQsR6lKv7KP6ASZd/XH3yP0IswA1tIX5DJlN+0=;
        b=DWWY0kuAsT6YqbGoPH/8Ei3i/vuC5wAKxVzTgcfNsNqpvYrupR5Pkce0PZ88M5b0de
         5hw9KJNY9BeCMdsAD1Qf+ijshhdKZ0UaFHRo19U508hB3iSiefe1vvjBnxXbp/0iMNrj
         rnyxIpuFTr19dgB8ymUweKKAo0kV19toKeAf9QrXChzUsiQmN0XSFlXG8ZZBlV1y8Nke
         DV+AEo4dBwLKCetVLv+UUlqaQLtKpyP+boi8yjNxlCVNOG0mdjdlLVMCqpbU3ZgCKR+w
         gpageCTvD32vubFgew7SueHAc5smyT4dw2dJFxNw4X7YpKUoxXnkMW2xCCsbozgEG3yM
         DQIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b8rnUZQsR6lKv7KP6ASZd/XH3yP0IswA1tIX5DJlN+0=;
        b=UlKIfzdlj1LKfk716LK6LoZ23rBbI0S7V8ijOig70nAJh+nrC/j6GpYmlR75a6cBqo
         uhI55Scsano9Q/DjGmJau0/35WNxQIulJOD8brzz8pN1Z9G3InzR+ImeotQ9bw00Lw2m
         lDp5p7jvRsU5tu7rXF0nVmx0Fl6Y7UhkKpcV16YWr7zl3WJ9Wpeb2YsiAtqSsySgmuyj
         usT/0EiCgUXfIDVdmXwezLQENbe6Xu1dxs+ptBCflb3sbY4oSdLpqDHPsi7UMPoXStqA
         rVXAeRTtQdcWhc4LfhPD+K25MOm2tyc3/zWbF/B2mvmCwqH/fOXl+rpEKs/ZOs1mVSkT
         Gxlg==
X-Gm-Message-State: AOAM532bP6XKjez5tgA90MUCtIpkT/zNnb112NfC03VsgOFunw4zAUD/
        vyGtEJsLPS4pfQNQLXr6gdfj5aQJo3PCoxThiusJog==
X-Google-Smtp-Source: ABdhPJwtrJ56OC+wwMjClrjGkKGJT/TLeHmPUUXfguehfbnLWE6xRpzlnl51ahG50aEJ8jHqlIiuDyOKU+fAnz+x3i4=
X-Received: by 2002:a81:a016:0:b0:2f7:cfa3:4dc3 with SMTP id
 x22-20020a81a016000000b002f7cfa34dc3mr8843576ywg.467.1650907491992; Mon, 25
 Apr 2022 10:24:51 -0700 (PDT)
MIME-Version: 1.0
References: <18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de>
 <9325d344e8a6b1a4720022697792a84e545fef62.camel@redhat.com>
 <20220423160723.GA20330@wunner.de> <20220425074146.1fa27d5f@kernel.org>
 <CAG48ez3ibQjhs9Qxb0AAKE4-UZiZ5UdXG1JWcPWHAWBoO-1fVw@mail.gmail.com>
 <20220425080057.0fc4ef66@kernel.org> <CANn89iLwvqUJHBNifLESJyBQ85qjK42sK85Fs=QV4M7HqUXmxQ@mail.gmail.com>
 <CAG48ez0nw7coDXYozaUOTThWLkHWZuKVUpMosY2hgVSSfeM4Pw@mail.gmail.com> <20220425172014.GA24181@wunner.de>
In-Reply-To: <20220425172014.GA24181@wunner.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 25 Apr 2022 10:24:40 -0700
Message-ID: <CANn89iKKJrUUmCzAue1N375TLCHZunnyNwkpJdxbk=RdeeZQwg@mail.gmail.com>
Subject: Re: [PATCH] net: linkwatch: ignore events for unregistered netdevs
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Jann Horn <jannh@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 10:20 AM Lukas Wunner <lukas@wunner.de> wrote:
>
> On Mon, Apr 25, 2022 at 05:18:51PM +0200, Jann Horn wrote:
> > Well, it's not quite a refcount. It's a count that can be incremented
> > and decremented but can't be read while the device is alive, and then
> > at some point it turns into a count that can be read and decremented
> > but can't be incremented
>
> Pardon me for being dense, but most other subsystems use the refcounting
> built into struct device (or rather, its kobject) and tear it down
> when the refcount reaches zero (e.g. pci_release_dev(), spidev_release()).
>
> What's the rationale for struct net_device rolling its own refcounting?
> Historic artifact?


Yes, probably. This was there way before new fancy mechanisms were invented.

>
>
> I think a lot of these issues would solve themselves if that was done away
> with and replaced with the generic kobject refcounting.  It's a pity that
> the tracking infrastructure is now netdev-specific and other subsystems
> cannot benefit from it.

Make sure that whatever replaces it, heavy dev_hold()/dev_put() users
do not come to a crawl.

af_packet is using this stuff.

Some users want to send millions of packets per second, without having
to bypass the kernel because it is suddenly too slow.


>
> Thanks,
>
> Lukas
