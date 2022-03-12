Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576A74D7111
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 22:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbiCLVpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 16:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbiCLVpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 16:45:18 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9251D8335
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 13:44:12 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id l20so20849678lfg.12
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 13:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Al6bnHgVgcqWGS7SzpEP6EcNnlitYzP4oWhkmGFLRYg=;
        b=TUNQe6vdMdyq5Mk9RcZa0WrgFWSQNBekv3itbnQYPfxEcKkulC5M9G35QESGHx3lCs
         CkiAAaqI2HmrSs4euU/9PrCa+nGQ4kj+UavhRfZqSrLFd9YMMCelxwBYrKyghkz/zT4k
         cSm+n0RWPhJ3qKq/xEsoqAW/Ef3Ix0mfhyfWA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Al6bnHgVgcqWGS7SzpEP6EcNnlitYzP4oWhkmGFLRYg=;
        b=RiCmqF1ADveAq6gOHLp7+wREMeGp6E3VRz7vZ8iO7cTPGBmT5ZwqrDH2QBDPFUUY8y
         WRyiLL5VT/YUuswHhhzexC2Yaxq4lf74KNG6roHqY6n/r8v3BGIuKG6q0UqRfyc412Oy
         ZHms+Dwf1Gb1qz115rUtP7LRw6wRWYOZeXZb4IwKNQtRSUqCitdZSKRD8NcGmKcpN1el
         SoBxkiFTravZ0MvYx/qBgm2FgrUZPX1z1pqDenTiA0rMFew7qZc6CxS5Mvk8x4T1i7Fi
         MyV3uURneB5aaKsdcfDE7JE6y8UrpitMFAi8gfXWeqhoxsHNMu47VZN1OBen7WKmG8Sh
         9YBw==
X-Gm-Message-State: AOAM533ZxI+65Acpj1yrQONb9mHO5kGH905dVLBIaeqr5GLLmGW0w4U1
        1DwqUMtf+7xFIQePrdRWCCH3YJtkeJVf6CKDKHY=
X-Google-Smtp-Source: ABdhPJwu1N1fmzHzYCPepF4CdinL8tC4BqJN0eOefdBlwg2gm5kpJtKaxBlgAnQmEqOIy8l5tR0aKQ==
X-Received: by 2002:a05:6512:525:b0:448:89d5:2e40 with SMTP id o5-20020a056512052500b0044889d52e40mr1770268lfc.249.1647121450025;
        Sat, 12 Mar 2022 13:44:10 -0800 (PST)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id m11-20020a05651202eb00b00443130ce80asm2368821lfq.138.2022.03.12.13.44.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Mar 2022 13:44:07 -0800 (PST)
Received: by mail-lf1-f54.google.com with SMTP id l20so20849554lfg.12
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 13:44:06 -0800 (PST)
X-Received: by 2002:a05:6512:b13:b0:448:90c6:dc49 with SMTP id
 w19-20020a0565120b1300b0044890c6dc49mr147974lfu.542.1647121446538; Sat, 12
 Mar 2022 13:44:06 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=wiacQM76xec=Hr7cLchVZ8Mo9VDHmXRJzJ_EX4sOsApEA@mail.gmail.com>
 <YiqPmIdZ/RGiaOei@qmqm.qmqm.pl> <CAADWXX-Pr-D3wSr5wsqTEOBSJzB9k7bSH+7hnCAj0AeL0=U4mg@mail.gmail.com>
 <Yix06B9rPaGh0dp8@qmqm.qmqm.pl>
In-Reply-To: <Yix06B9rPaGh0dp8@qmqm.qmqm.pl>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 12 Mar 2022 13:43:50 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgxtcTbBdtm9ewarth476Wr5vYYnptaWpwdHcML8-xayA@mail.gmail.com>
Message-ID: <CAHk-=wgxtcTbBdtm9ewarth476Wr5vYYnptaWpwdHcML8-xayA@mail.gmail.com>
Subject: Re: [PATCH 2/6] list: add new MACROs to make iterator invisiable
To:     =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc:     Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 12, 2022 at 2:24 AM Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.=
qmqm.pl> wrote:
>
> The source type is not needed for the macros [..]

Ahh. Yeah, as long as we don't do typedefs, it looks like we don't
need to pre-declare the member access types.

I expected that to be required, because function declarations taking
arguments need it, but that's because they create their own scope.
Just doing it in a regular struct (or in this case union) declaration
is fine.

So we would only need that post-declaration.

That said, your naming is wrong. It's not just about "self". It's any
case where the type we iterate over is declared after the type that
has the head.

So I suspect it would be a lot better to just always do it, and not do
that "self vs non-self" distinction.

              Linus
