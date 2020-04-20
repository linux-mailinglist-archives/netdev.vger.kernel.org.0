Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730341B1893
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgDTVmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:42:36 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:42199 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgDTVmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 17:42:35 -0400
Received: from mail-qv1-f48.google.com ([209.85.219.48]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1N4R0a-1jGQs00Klq-011W89; Mon, 20 Apr 2020 23:42:34 +0200
Received: by mail-qv1-f48.google.com with SMTP id w18so5122189qvs.3;
        Mon, 20 Apr 2020 14:42:33 -0700 (PDT)
X-Gm-Message-State: AGi0PualUEhi4uUZDN0kCYhI80ZGhcHzOppoBETZ+UXxvpY79PUZofni
        7dcLGqv/cngzeajeNlMEXfu/1XogC5IJcT+UiFo=
X-Google-Smtp-Source: APiQypIgUdjRNfnUwa38offH8JKaHJxg+os0bXKNXtZGXrDeAqOxQJQNVTfvyx/OiWrFlTTAfX0HOISlTitW0n+H68k=
X-Received: by 2002:a0c:b78e:: with SMTP id l14mr17430288qve.4.1587418952858;
 Mon, 20 Apr 2020 14:42:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200416085627.1882-1-clay@daemons.net> <6fef3a00-6c18-b775-d1b4-dfd692261bd3@ti.com>
 <20200420093610.GA28162@arctic-shiba-lx> <CAK8P3a36ZxNJxUS4UzrwJiMx8UrgYPkcv4X6yYw7EC4jRBbbGQ@mail.gmail.com>
 <20200420170051.GB11862@localhost> <CAK8P3a11CqpDJzjy5QfV-ebHgRxUu8SRVTJPPmsus1O1+OL72Q@mail.gmail.com>
 <20200420211819.GA16930@localhost> <CAK8P3a18540y3zqR=mqKhj-goinN3c-FGKvAnTHnLgBxiPa4mA@mail.gmail.com>
 <20200420213406.GB20996@localhost>
In-Reply-To: <20200420213406.GB20996@localhost>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 20 Apr 2020 23:42:16 +0200
X-Gmail-Original-Message-ID: <CAK8P3a22aSbpcVK-cZ6rhnPgbYEGU3z__G9xk1EexOPZd5Hmzw@mail.gmail.com>
Message-ID: <CAK8P3a22aSbpcVK-cZ6rhnPgbYEGU3z__G9xk1EexOPZd5Hmzw@mail.gmail.com>
Subject: Re: [PATCH] net: cpts: Condition WARN_ON on PTP_1588_CLOCK
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Clay McClure <clay@daemons.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sekhar Nori <nsekhar@ti.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:cZ5YXVdXtJ6gyIwvm/1dU3QPHP54/VYuklztbc1Qxo7hO+SKfzR
 dKWV0hXxVIZqjKtpfDW3p72T8yKqVy0YeCY0vjHGNApnVNdeWzErWfFgNuFt3JaQNW5k1W6
 LaNqp347KZ3EBESkKG9xTv8chWAMyGIYm397L3X4RvVz+GxQwL5E9CGCKRombGx1A3v21+M
 Y2f+I1ks/l1j4rPDT0AjA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:JRJ/w9Kf6w0=:GnNwQ71dY6QImfY39X165e
 VjveLlOMCQqWJxX3ES/vc6CwU01B35SV++z1VeaRxrJLxyOOSHWqN8DpSruR+PJf4s0JtNw4M
 wKHryZn4JMGmmPvu8Twx0VbUawBcYJpTFLHpdYxcCLUVEqI5d+yk0OG/l8g7tyCn89irEozMO
 FPtTAlyHNfPc98ItHDkHiJENUzYT5GwHTKmOSbWK6SH94+9LAMfCIqTWrB8Z1H+e3fqKzzq33
 gUwNTuSH/BnJuMRX3zEHv6NOPESGKlBG/2MWMQ17o2jWkjOkk1F2hJ8ablMLp5Q1sguOMw237
 rrOpXxnmBe0f2ayiDOaTHa3EX1otuFBeBiO6xH81Lmdle3JB3oTuA42Y/TSaq8iK71fpW28sV
 SZdnzrrcKZ+o5vvXzi/xpg7xUIuV03vipKgumOQ1TuVJStPLUjjU7XEYMBf3rgdqNg6NUB+xy
 Bq/7xjcDEkavxh9QFACzuOekenXmjcTcJPNA61UiCUX95zc4h0GUz2xU8RhYJA6AwNhw91HTt
 d0EggmfdmPaW4nmM2MO0tXVIUzoUqyZDbLRymzqtcEkeN+YTIbzHu1CaWwSZ2VlyBR2j9nUtz
 LFSOCtlyD3+KakhR9RCuzYftKq8eSZehLmR+AoUmfoOlfKvCpPJ0Naalh9vB+5NmnHdJYddmP
 s3ftDuZIvNwmYyg3JA6HxN2t868L56jmCk2Mx7lMNPYRcjKobACNk4JVGM8MNaaTTYymS4ayO
 mHF6bO5sOeqJjKRzp6DlzDpKGLrfb3z1EZC42wccP2A+S5hDpqm7huIX9WlAuIDC1YZCJMB3d
 3nQuUDFbrlAXkLrSsGD/9chPekx0coM++k+Yxg0G8LruFp2sSw=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 11:34 PM Richard Cochran
<richardcochran@gmail.com> wrote:
>
> On Mon, Apr 20, 2020 at 11:21:20PM +0200, Arnd Bergmann wrote:
> > It's not great, but we have other interfaces like this that can return NULL for
> > success when the subsystem is disabled. The problem is when there is
> > a mismatch between the caller treating NULL as failure when it is meant to
> > be "successful lack of object returned".
>
> Yeah, that should be fixed.
>
> To be clear, do you all see a need to change the stubbed version of
> ptp_clock_register() or not?

No, if the NULL return is only meant to mean "nothing wrong, keep going
wihtout an object", that's fine with me. It does occasionally confuse driver
writers (as seen here), so it's not a great interface, but there is no general
solution to make it better.

     Arnd
