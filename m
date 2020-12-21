Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E1A2E0109
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 20:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgLUTcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 14:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgLUTcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 14:32:21 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26024C0613D3;
        Mon, 21 Dec 2020 11:31:41 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id x203so2452139ooa.9;
        Mon, 21 Dec 2020 11:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=22WfrYqwVdHV4R9eUfnFdyTLajoJ14FZuqG4/EZXiBg=;
        b=hEivyO3LAqfRO7APVQNvlx80TFpDZAMkK9Tfh8FYVr3fN0r/Zk+/pTNRHJNqfX1Ct0
         udvsyN91BPHDXD/1xV5fOmoQXDojvukiY7WDXkv2hJYxTCCluvIQXhBE1aRpleBk3uzE
         VDbqoOyZB2Bv4dBgzgCt/hA/p+6aplEP1Vo+7xlN4cBMRUVlau+dGJhlfiEgpKRtA4cS
         XUymUTFtgedYJDbbbYFoXaK4w8RWfQzQvhN6FHjkuebPSQdWz9/VN9yv7CXEJPuznwlC
         0nFe7HJ2BD6vznil1FyQlsC2LNB3nbdHlxiuKWBJEDXu2cuSDqA0xLGqvjuHxU4sXU0Y
         bQqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=22WfrYqwVdHV4R9eUfnFdyTLajoJ14FZuqG4/EZXiBg=;
        b=lO8VC15vmbcSW9Z4vcRP7rllmQ89nxo63vVwGskLwjQhS+gNJ3Ii4KJ3WgVbVKeyx1
         RbbMfxnPz68zQVbwR0ZeopaS60fSF9g74s9fTDa1n3zpyYxLtBA72Ry7H3nT2+myn/Ug
         IFNDAcsu/94x100gxXrYHZZcRMlWKgvFP8+MXrN0U+r7GGdUEY8/e5ebHW03Hubfq8Gu
         ZATLhmk9bz4hkO1ahlcYPmIG0KQPjwk6t+z8dClpSrPJa7UvCFrR1WPF7CKK+Qc0kenI
         PdNmQvqIDQT6KvgFDSwBBArpsSdC5wwhffGVjgtV2qd6b4T2pXrFY72WMj4jTyjvri09
         8aPQ==
X-Gm-Message-State: AOAM532UmqYebJBlmmmdua0VnaOWBmHzlj7sYMaZWkuCOPGYU4S0mMpJ
        UvJ8EG/K+NpBNxMGTqj/Y4bw0DaYcZqQFmYE5Z53y4gM
X-Google-Smtp-Source: ABdhPJxcWxnUc+rwQRDI3Z0RTTF/LyrVAt5D2vgqWNNDeUaVA4VaKDcfByXRkjUfG6dWy5TDydUbKo8m1BZtu1WNZkM=
X-Received: by 2002:a5b:949:: with SMTP id x9mr22811402ybq.33.1608558687798;
 Mon, 21 Dec 2020 05:51:27 -0800 (PST)
MIME-Version: 1.0
References: <20201128193335.219395-1-masahiroy@kernel.org> <20201212161831.GA28098@roeck-us.net>
 <CANiq72=e9Csgpcu3MdLGB77dL_QBn6PpqoG215YUHZLNCUGP0w@mail.gmail.com>
 <8f645b94-80e5-529c-7b6a-d9b8d8c9685e@roeck-us.net> <CANiq72kML=UmMLyKcorYwOhp2oqjfz7_+JN=EmPp05AapHbFSg@mail.gmail.com>
 <X9YwXZvjSWANm4wR@kroah.com> <CANiq72=UzRTkh6bcNSjE-kSgBJYX12+zQUYphZ1GcY-7kNxaLA@mail.gmail.com>
 <CAK7LNARXa1CQSFJjcqN7Y_8dZ1CSGqjoeox3oGAS_3=4QrHs9g@mail.gmail.com> <55261f67-deb5-4089-5548-62bc091016ec@roeck-us.net>
In-Reply-To: <55261f67-deb5-4089-5548-62bc091016ec@roeck-us.net>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Mon, 21 Dec 2020 14:51:17 +0100
Message-ID: <CANiq72mQ=5JpMh1OZfJo6dypF0KHSUp9Umd_5qwATxEMgO5OmQ@mail.gmail.com>
Subject: Re: [PATCH v3] Compiler Attributes: remove CONFIG_ENABLE_MUST_CHECK
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Shuah Khan <shuah@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 11:02 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 12/20/20 10:18 PM, Masahiro Yamada wrote:
> With a change like this, I'd have expected that there is a coccinelle
> script or similar to ensure that claims made in the commit message
> are true.

It is only a warning -- the compiler already tells us what is wrong.

Cheers,
Miguel
