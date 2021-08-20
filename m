Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403A33F27D1
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 09:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238912AbhHTHrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 03:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238776AbhHTHrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 03:47:18 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22ECCC061575;
        Fri, 20 Aug 2021 00:46:41 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id d9so6776792qty.12;
        Fri, 20 Aug 2021 00:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Kq7tK7YGhE/+PaJamAkkvlm7bSWZjJfKlm0O98NWiAo=;
        b=UUKANxUc5S8DBMv9pxXRM63MOlAsgCoVi9n6eY8tBPPQLIpUiCrB7NRuLemEdP8odc
         XhMariKAYNVZ1T2JQD9UpYuHfwh8nbRmFhqmnqtZ1u3XZM+ZIc8fEVMK3Ku0JNKlO21B
         7/PbR8pWJS671SC1NF4c6awERELgJnxkuW360=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Kq7tK7YGhE/+PaJamAkkvlm7bSWZjJfKlm0O98NWiAo=;
        b=btgIXzcKosZwWxdZAso2wTF6JlRv2r1Soxi9BZ762S7SwHM5oZCjae3hu319x4kpVT
         nXl9vUKjWMIqQpHG0QW/BXeCK+/SyqhHcTeGFtqzkNaBN1kJ661497myTTXHOo4tLJmH
         I90GqUW90dfG0rjnWOiJIgr2j5n7lnK3xW34/JWZDZwaTLcwOfEH+L6hvhsvArqCv6VV
         bn+Qo0x8My/ZOeW5+seuhCENY55yZTj6OTK11esCNez1vmfmonaQvtujXZ0B23n9oXd2
         mocWV9i1bl1HrTRp5hvel2mVou5JIBXc9rcuzPamWoJoKbHfdb5pDIZGADPvM+kb9Udq
         ANSw==
X-Gm-Message-State: AOAM531sAxD1Fj+EXlzBB1MhY8oSzurgWJZcfJJn4lU0zaCVVLICxhrs
        XE4zyhRwezsf/ynwsr+jZD9nSoH1TffxhGqf31p/hGnlQGI=
X-Google-Smtp-Source: ABdhPJwkjoD/pZdCC0HerMc8tzD0FnCSiazwQuCDvSRvo3mgfFxzcUy9DDbI5DhW0eoROwPAxBeLcqyIwdKQWjezsCc=
X-Received: by 2002:ac8:72ca:: with SMTP id o10mr16658363qtp.385.1629445600099;
 Fri, 20 Aug 2021 00:46:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210806054904.534315-1-joel@jms.id.au> <20210806054904.534315-3-joel@jms.id.au>
 <YQ0hk/lsHXUu+ykC@errol.ini.cmu.edu> <CA+96J6JxAkNd_QkVxfSdAJwWVLJTtSaDsCmVKw3KBfYySJytKA@mail.gmail.com>
In-Reply-To: <CA+96J6JxAkNd_QkVxfSdAJwWVLJTtSaDsCmVKw3KBfYySJytKA@mail.gmail.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Fri, 20 Aug 2021 07:46:27 +0000
Message-ID: <CACPK8Xds9RysihvNSJfxcL4n1-eum3v1gauh406jEfdu=S7pcw@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: Add driver for LiteX's LiteETH network interface
To:     Florent Kermarrec <florent@enjoy-digital.fr>
Cc:     "Gabriel L. Somlo" <gsomlo@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Stafford Horne <shorne@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@ozlabs.org>, David Shah <dave@ds0.me>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree <devicetree@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florent and Gabriel,

On Fri, 6 Aug 2021 at 12:27, Florent Kermarrec <florent@enjoy-digital.fr> w=
rote:
>
> Hi Gabriel, Joel,
>
> for 1), the polling mode has been useful recently with Linux-On-LiteX-Vex=
riscv to bring up the SMP version before enabling the IRQs and can probably=
 be useful in the future for similar purposes. So if it's not too complicat=
ed to maintain, this could be useful to keep it.

I would prefer to get a basic working driver for the straight forward
Linux-on-FPGA use case merged first. We can then work out what should
be done next. I would like to see hardware improvements to make it go
faster, and we can look at other features like polling if you still
need them.

>
> Le ven. 6 ao=C3=BBt 2021 =C3=A0 13:48, Gabriel L. Somlo <gsomlo@gmail.com=
> a =C3=A9crit :
>>
>> Hi Joel,
>>
>> Thanks for pushing this upstream (and for writing it to begin with)!
>>
>> Would you mind diff-ing your version of litex_liteeth.c against what
>> is currently in
>> https://github.com/litex-hub/linux/blob/litex-rebase/drivers/net/etherne=
t/litex/litex_liteeth.c ?
>>
>> Two main differences we should discuss:
>>
>>         1. there's a polling mode (added by Antony Pavlov), and if we
>>            decide *not* to keep it around, I want to ensure we do that
>>            deliberately, with an explanation as to why;

I assumed this was only for broken systems, or systems that were still
being brought up. Haven't the risc-v socs improved to the point where
they have working interrupts now?

>>
>>         2. LiteX CSRs are accessed using `litex_[read|write][8|16|32]()`
>>            as opposed to simply `[read|write][b|w|l]()`. The former set
>>            are defined in `include/linux/litex.h` and are needed to
>>            ensure correct accesses regardless of endianness, since by
>>            default LiteX registers' endianness mirrors that of the
>>            configured CPU.

I don't like that they get the parameters in the wrong order compared
to the rest of the kernel, and that they force 32-bit access no matter
the width of the access being performed. They also mean we can't use
_releaxed variants of accessors to eg. read a set of registers without
having a barrier in between.

That said, I have used the csr accessors so we can support the mor1k,
which afaict is the only litex CPU that defaults to big endian.

If you could help review the patch so we can get it merged this cycle,
then we can work on future enhancements.

Cheers,

Joel
