Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4193177223
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 10:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbgCCJPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 04:15:25 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:35496 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbgCCJPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 04:15:25 -0500
Received: by mail-ua1-f67.google.com with SMTP id y23so856216ual.2
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 01:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LneAT+FmOx1Es58srzrFn5NXWCoaZSg9GZ1bHCf2Y68=;
        b=dVfO7CkV6SqoYajMXh5yVSuj7JlukzOHi28q8fViXQ6B4SxXj+W+b8Om/hWvo7mc2v
         DF+j6PfqZIi2li/TLo6uczR99yPOMhdyh+cOvLKVwjJvvOvnNMAaryH7IUeSOvrzX+tt
         5FkndW3yP8E7CDjEpW2k+ehe31M0NDz4oP2IM+1aLygDQxPgWKjysighBP4WqrnQ2GWJ
         aVUrnpaS4CpE2wq3XjKZ4CcZGnLfT0Xs+w/RX4uXBiZGZKOOUrplktcF8YWBMUdrJ6V0
         ujitsCj2386gFDc04bJcz/WHwmKLAiJ43xuj/twO+vuOF3Kf2WODIs04Im/OxUWssFpN
         37kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LneAT+FmOx1Es58srzrFn5NXWCoaZSg9GZ1bHCf2Y68=;
        b=blMj1r9uAJUMV98yJosNMYEH98l5UT6sOsY+iseqoWvzl97R8HGl2fxxaYvJ6xQlY8
         qiv+/lANw6WKDtIfPHJ5xW4G/DGndTQ9GpXmBOsZQP1r8uhnEHpTq0JYxFAftLuRWkOQ
         ZfOWGPXWKRB91dc5FE0n9V7RpeHevgavkA9BWIbHqS5vP4PEu69f4ovU1AP2i+U+DH9K
         t1+JuW6QlYz6t+qTM77RVl5BkkKWSljqUnU9Z7g2I1OTYiOfjQK90Es1inIgvZXBmUez
         nZMOkyoc5Op4en3XcMyA0FFBKNUyg72h0wKcDjq7wKR1gj++Cd6RQ99u6oMgsZEu2Vp+
         hR1g==
X-Gm-Message-State: ANhLgQ1kYSNV2xhBcHQwCfRiG22NgolyLytHEy74BOzCpl2e2Y22pmQZ
        RRFrIjv6/KQRWk7wOyMOuVpzjUbsQ8LIyuH+0WDAABfi
X-Google-Smtp-Source: ADFU+vs2fA1iMfT5C/BG0ldGWe2b6eA6gjAegHE8VRGMdMnkCgh30WfTBtzVNv+m3F9/S3UKyDvYCjQOx+X63rJLoDo=
X-Received: by 2002:ab0:24d2:: with SMTP id k18mr2310450uan.104.1583226923544;
 Tue, 03 Mar 2020 01:15:23 -0800 (PST)
MIME-Version: 1.0
References: <20200228.120150.302053489768447737.davem@davemloft.net>
 <1583131910-29260-1-git-send-email-kyk.segfault@gmail.com>
 <CABGOaVRdsw=4nqBMR0h8JPEiunOEpHR+02H=HRbgt_TxhVviiA@mail.gmail.com> <945f6cafc86b4f1bb18fa40e60d5c113@AcuMS.aculab.com>
In-Reply-To: <945f6cafc86b4f1bb18fa40e60d5c113@AcuMS.aculab.com>
From:   Yadu Kishore <kyk.segfault@gmail.com>
Date:   Tue, 3 Mar 2020 14:45:12 +0530
Message-ID: <CABGOaVQMq-AxwQOJ5DdDY6yLBOXqBg6G7qC_MdOYj_z4y-QQiw@mail.gmail.com>
Subject: Re: [PATCH v2] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
To:     David Laight <David.Laight@aculab.com>
Cc:     David Miller <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Thanks for the response.

> I was writing a reply about how 'horrid' the asm in csum_partial_copy_generic is.
> (My guess is no better than 3 clocks for 16 bytes - and a 'rep movs' copy
> could be a lot faster.)
> However the big difference in the times for do_csum().
>
> The fastest loop I can find for a non-copying checksum is:
> Which is twice as fast as the one in csum-partial_64.c for
> most cpu types (especially pre-Haswell ones).

The perf data I presented was collected on an arm64 platform (hikey960) where
the do_csum implementation that is called is not in assembly but in C
(lib/checksum.c)

Thanks,
Yadu Kishore

On Mon, Mar 2, 2020 at 8:49 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Yadu Kishore
> > Sent: 02 March 2020 08:43
> >
> > On Mon, Mar 2, 2020 at 12:22 PM Yadu Kishore <kyk.segfault@gmail.com> wrote:
> > >
> > > > > Can you contrast this against a run with your changes? The thought is
> > > > > that the majority of this cost is due to the memory loads and stores, not
> > > > > the arithmetic ops to compute the checksum. When enabling checksum
> > > > > offload, the same stalls will occur, but will simply be attributed to
> > > > > memcpy instead of to do_csum.
> > >
> > > > Agreed.
> > >
> > > Below is the data from perf with and without the patch for the same
> > > TCP Tx iperf run: (network driver has NETIF_F_HW_CSUM enabled)
> > >
> > A small correction to the data I sent earlier:
> >
> > Without patch :-
> >  ============
> > [Function = %cpu cycles]
> > skb_mac_gso_segment = 0.05
> > inet_gso_segment = 0.26
> > tcp4_gso_segment = 0.05
> > tcp_gso_segment = 0.17
> > skb_segment = 0.55
> > skb_copy_and_csum_bits = 0.60
> > do_csum = 7.43
> > memcpy = 3.81
> > __alloc_skb = 0.93
> > ==================
> > SUM = 13.85
> >
> > With patch :-
> > ============
> > [Function = %cpu cycles]
> > skb_mac_gso_segment = 0.05
> > inet_gso_segment = 0.34
> > tcp4_gso_segment = 0.06
> > tcp_gso_segment = 0.26
> > skb_segment = 0.55
> > ** skb_copy_bits = 0.62 **  <-- corrected
> > do_csum = 0.04
> > memcpy = 4.29
> > __alloc_skb = 0.73
> > ==================
> > ** SUM = 6.94 ** <-- corrected
>
> I was writing a reply about how 'horrid' the asm in csum_partial_copy_generic is.
> (My guess is no better than 3 clocks for 16 bytes - and a 'rep movs' copy
> could be a lot faster.)
> However the big difference in the times for do_csum().
>
> The fastest loop I can find for a non-copying checksum is:
> +       /*
> +        * Align the byte count to a multiple of 16 then
> +        * add 64 bit words to alternating registers.
> +        * Finally reduce to 64 bits.
> +        */
> +       asm(    "       bt    $4, %[len]\n"
> +               "       jnc   10f\n"
> +               "       add   (%[buff], %[len]), %[sum_0]\n"
> +               "       adc   8(%[buff], %[len]), %[sum_1]\n"
> +               "       lea   16(%[len]), %[len]\n"
> +               "10:    jecxz 20f\n"
> +               "       adc   (%[buff], %[len]), %[sum_0]\n"
> +               "       adc   8(%[buff], %[len]), %[sum_1]\n"
> +               "       lea   32(%[len]), %[len_tmp]\n"
> +               "       adc   16(%[buff], %[len]), %[sum_0]\n"
> +               "       adc   24(%[buff], %[len]), %[sum_1]\n"
> +               "       mov   %[len_tmp], %[len]\n"
> +               "       jmp   10b\n"
> +               "20:    adc   %[sum_0], %[sum]\n"
> +               "       adc   %[sum_1], %[sum]\n"
> +               "       adc   $0, %[sum]\n"
> +           : [sum] "+&r" (sum), [sum_0] "+&r" (sum_0), [sum_1] "+&r" (sum_1),
> +               [len] "+&c" (len), [len_tmp] "=&r" (len_tmp)
> +           : [buff] "r" (buff)
> +           : "memory" );
>
> (I need to resubmit that patch)
>
> Which is twice as fast as the one in csum-partial_64.c for
> most cpu types (especially pre-Haswell ones).
>
> IIRC that does 7 bytes/clock on my ivy bridge and
> one 8 bytes/clock on Haswell.
> Nothing prior to sandy bridge can beat adding 32bit words
> to a 64bit register!
> The faffing with 'len_tmp' made a marginal difference.
>
> You can't go faster than 1 read/clock without using ad[oc]x.
> The loop above does work (both carry and overflow are preserved)
> but it needs further unrolling (and more edge code) and only
> runs on a few cpu.
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
