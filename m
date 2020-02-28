Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D968517304A
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 06:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgB1FYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 00:24:54 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:35930 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgB1FYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 00:24:53 -0500
Received: by mail-ua1-f68.google.com with SMTP id y3so560566uae.3
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 21:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PhoQYfr9d9tfjiKHsaLUDmBBW9QZxzl/HvwC2w0Fqbc=;
        b=BZ3xH77kpVdm6tncKIEEk1TNDHUELAjeJCVHhi6lw6fn/JELlJWGkKqTX4AtIJHnif
         gCRBShOnUOuaz+L+i4dAHkvQ3MBtCtyQYGLjT9Enu1Df6gM6A+fH1aiw5zEmDmG86OvX
         u11l+S7BPHaxqCLzl/hbCaH+CR4r0sobeCfvhHuX01x0b4WL3EAXHh42Ki0DzJ5kLWYQ
         KENMwmGjunrONWmTWuETm1hqIe1oGaLYHBfv0W0WW+PUqZaFtUmLK7/JSFqFH23tleVP
         oWQVCKKGJlJH9i0wWB6KoymwNj/56+C/IuDvxKRwOD4Qt4+QhPT8tzIEat06v2lRpNaI
         RZ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PhoQYfr9d9tfjiKHsaLUDmBBW9QZxzl/HvwC2w0Fqbc=;
        b=KqZ/yqkmW2cqylCZ266WAvregWMiZyTV70hpH2ZArvda3LNlqtWACHmyfc9CJGzaGy
         6fsYCD0dWviSmZebbBVBgGrYjJ9aCC9yjrOp1bZcQpnunZlZzBM60GAH6ZYzLqIXT1+Z
         +ut+6h/Y1V2YHKz60f6m1agLWkU914GiQB+tIdml6oi692/BeWySMKfkzHNHv+tibHLR
         TRHu5FwtdFIwrX3oRwHOWeNfXLBPVGET/SVJ6MwRhE41Q2mkDca3h/GbIWNCmFanVpWm
         IBOin26/i8Rids+67XncdAzP8M5XaYE2VIk/feoNc3iynR3tsrYNilcmUpCIpV1Oicka
         6SRA==
X-Gm-Message-State: ANhLgQ0k7HPdqDxg1pxNl3AwLGwcl61AyiAINnampO9B1p7SaHWK/6n+
        IUhJnLaPGf1rVKdjurXFXn6l8VC7Uhm2rBHIUjg=
X-Google-Smtp-Source: ADFU+vs6oRP3NLlcaL2TEsB0sLem1lBaa5bHH9Ps2iK+iXiP2Vwaui9Iio/OFZgYXw0+6YFIuiXnNQCTbqcrxM9jXQs=
X-Received: by 2002:ab0:740e:: with SMTP id r14mr1293854uap.104.1582867492568;
 Thu, 27 Feb 2020 21:24:52 -0800 (PST)
MIME-Version: 1.0
References: <CA+FuTSeYGYr3Umij+Mezk9CUcaxYwqEe5sPSuXF8jPE2yMFJAw@mail.gmail.com>
 <1582262039-25359-1-git-send-email-kyk.segfault@gmail.com> <CA+FuTSe8VKTMO9CA2F-oNvZLbtfMqhyf+ZjruXbqz_WTrj-F1A@mail.gmail.com>
In-Reply-To: <CA+FuTSe8VKTMO9CA2F-oNvZLbtfMqhyf+ZjruXbqz_WTrj-F1A@mail.gmail.com>
From:   Yadu Kishore <kyk.segfault@gmail.com>
Date:   Fri, 28 Feb 2020 10:54:41 +0530
Message-ID: <CABGOaVRF9D21--aFi6VJ9MWMn0GxR-s8PssXnzbEjSneafbh5A@mail.gmail.com>
Subject: Re: [PATCH] net: Make skb_segment not to compute checksum if network
 controller supports checksumming
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Did you measure a cycle efficiency improvement? As discussed in the
> referred email thread, the kernel uses checksum_and_copy because it is
> generally not significantly more expensive than copy alone
> skb_segment already is a very complex function. New code needs to
> offer a tangible benefit.

I ran iperf TCP Tx traffic of 1000 megabytes and captured the cpu cycle
utilization using perf:
"perf record -e cycles -a iperf \
-c 192.168.2.53 -p 5002 -fm -n 1048576000 -i 2  -l 8k -w 8m"

I see the following are the top consumers of cpu cycles:

Function                                   %cpu cycles
=======                                   =========
skb_mac_gso_segment            0.02
inet_gso_segment                     0.26
tcp4_gso_segment                    0.02
tcp_gso_segment                      0.19
skb_segment                             0.52
skb_copy_and_csum_bits         0.64
do_csum                                    7.25
memcpy                                     3.71
__alloc_skb                                0.91
==========                              ====
SUM                                           13.52

The measurement was done on an arm64 hikey960 platform running android with
linux kernel ver 4.19.23.
I see that 7.25% of the cpu cycles is spent computing the checksum against the
total of 13.52% of cpu cycles.
Which means around 52.9% of the total cycles is spent doing checksum.
Hence the attempt to try to offload checksum in the case of GSO also.

> Is this not already handled by __copy_skb_header above? If ip_summed
> has to be initialized, so have csum_start and csum_offset. That call
> should have initialized all three.

Thanks, I will look into why even though __copy_skb_header is being
called, I am still
seeing skb->ip_summed set to CHECKSUM_NONE in the network driver.
