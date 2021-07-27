Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE533D6C49
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 05:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbhG0CZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 22:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbhG0CZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 22:25:19 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BE5C061760
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 20:05:46 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id w10so8615238qtj.3
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 20:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dO+/VjmDNm/jvNfgL8TZqjssguu0SYylw+ZFTbhKfUs=;
        b=hnkvf5PtgJ9iT3a75HtWTd32Ux85xeReIjr1eqyhAUwnpNaIFXm1jBHhcDvmynqtTi
         sYQeIoLfecuTZLCwmwYxdVm4a5MsEjOupgr6gULzNbHmrV0l/jRkb9VhKVuFu3Y23K48
         9EFDJ390fmOpkGTHhx32407CxLrCiDw+FALzHCokwXvcM0f6uRI3THTP8Ti885wqkRc4
         NhJOruzjSNOJk4Wjse+i2eE+qZ9+BrmwfHCdjfNwC12EC8cYafJLWEKwzFrWnNMrT08f
         aI1UCA7r5iRMCpjlBB9Aq3Rao8A5vaxCmYDllXBbAbCCZvIM8ik4WiepRr4Ldi26LPYi
         HqDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dO+/VjmDNm/jvNfgL8TZqjssguu0SYylw+ZFTbhKfUs=;
        b=BrOdh6GMdwH7ldfbjKDf/RqgWCwvQEn46L8/Hj2dC1RokhGgPaStkHTEyl+RNBL+Js
         Wwbu0ZlgqmLqvwI35No7P0kQAgmG1SY+7mZYPlSvYqKslh0JErryqB5GKVhV8/5V3Kw2
         F5RTEpcx0PkXz8Qk5yMRakhMt2J2B8YeTQmDpINaBveGTB0Eg1p/0POkDo3+orwiZdtI
         jXOJk/3mutgD85KOerK6nCercls93OO4JQ4+VsPaTWmK3wwhUbFgas1DtZ7p3GJx5sCF
         ofCH/hFMOZtWhRMOthhWQPU9IcQVd3aefhWW9wZMV9WEXTBfBIx0r7nUmmLSVJNyYgcr
         Pnpg==
X-Gm-Message-State: AOAM5331mr1JJbvD3JTEV+IyIdj6O1OgjWwXJwm23+nS+MtnIpSHH/gt
        C0B6KErCzmbs1eyj0mqu9oQ26M9p6mGOsNNJFg3+cQ==
X-Google-Smtp-Source: ABdhPJyqE+hRQ9fnFW4vz9Q25MAPeJV8jIhJFgt89SzOiIJR5zM75fLPLlgNJ/T6xtaAyhnD2RdftD0e4cX11xcrtA8=
X-Received: by 2002:ac8:7773:: with SMTP id h19mr17385217qtu.184.1627355145337;
 Mon, 26 Jul 2021 20:05:45 -0700 (PDT)
MIME-Version: 1.0
References: <01383a8751e97ef826ef2adf93bfde3a08195a43.1626693859.git.cdleonard@gmail.com>
 <e2215577-2dc5-9669-20b8-91c7700fa987@gmail.com>
In-Reply-To: <e2215577-2dc5-9669-20b8-91c7700fa987@gmail.com>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Mon, 26 Jul 2021 20:05:34 -0700
Message-ID: <CA+HUmGhtPHbT=aBLS_Ny_t802s3RWaE+tupd4T8U9x50eW3JXg@mail.gmail.com>
Subject: Re: [RFC] tcp: Initial support for RFC5925 auth option
To:     David Ahern <dsahern@gmail.com>
Cc:     Leonard Crestez <cdleonard@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        open list <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Salam Noureddine <noureddine@arista.com>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <dima@arista.com>,
        Francesco Ruggeri <fruggeri@arista.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leonard,

thanks for taking on this task!

> I'm especially interested in feedback regarding ABI and testing.

I noticed that the TCP connection identifier is not part of the
representation of the MKT (tcp_authopt_key_info).
This could cause some issues if, for example 2 MKTs with different
<remote IP, remote TCP port> in the TCP connection identifier but same
KeyID (recv_id) are installed on a socket. In that case
tcp_authopt_inbound_key_lookup() may not pick the correct MKT for the
connection. Matching incoming segments only based on recv_id may not
comply with the RFC.
I think there may be other cases where TCP connection identifiers may
be needed to resolve conflicts, but I have to look at your patch in
more detail.

It would be helpful if you could split your patch into smaller
incremental chunks.

Francesco

On Mon, Jul 26, 2021 at 6:07 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 7/19/21 5:24 AM, Leonard Crestez wrote:
> > I'm especially interested in feedback regarding ABI and testing.
>
> Please add tests -- both positive and negative -- to
> tools/testing/selftests/net/fcnal-test.sh. That script already covers
> the MD5 permutations. You can add the uapi support needed to nettest.c
