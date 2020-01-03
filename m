Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B2012F8F7
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 14:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgACNw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 08:52:59 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:33251 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727508AbgACNw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 08:52:58 -0500
Received: by mail-yw1-f68.google.com with SMTP id 192so18542327ywy.0
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 05:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0VQyaOEbZ/XK7+LS41bQS52/+VCzyBpD21AdC+QwmlQ=;
        b=LApVdFMdqSVRa/HLeaAn2YKt1iGPaD8YOPvoFTkPT4mWB7hgL1VsbXWGOyMkB53lok
         Zq+St+mTQjKwf38LxM8FblUHwsZ32wCDIx2URt6julsccvyNnevoIrS8R1eAjEACsdLX
         ++Xwjcso63y5XLTl6AjLEpxbc0KOyC5K3A6W4kgBvRp+08+gBskhBVXaWSheapB1Bxvd
         b8F1YaatwMsezDzconw53ecbhbZACVLyX3BbZFkjqY+jLHP+1nvsH5t5zU656NfV/5wi
         KtRUn/1ROJQBT69QsJCeRvCyiUwMUm7CPRDyNYNVeYd5lyuds2z4coPg0z2t0cEaLvY9
         4p1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0VQyaOEbZ/XK7+LS41bQS52/+VCzyBpD21AdC+QwmlQ=;
        b=bpxHcbqcQYzdQZZTAXNE6y26q4Sq4Yd3VWMhjbJwedJMbPgCBRAD34C6/5d4ZLaInp
         S06ZdSKlzuskKo/ekx83nvUcOBy7NdkiQBYFciEsoZa2buE3pXvZnmvjRdWtRHBSe09g
         uQZTDfEv8BKXYpzISmRDcJPTBeCC1TzQzvJSZts3zZdwWP0tddorSXaJh/JgGFhXLyfC
         epiKQ4Y6KKkGz4GEUBvFlOTlj0bhiiA3lDhuhZ5ZAlg2Wmm3Kd2/qq/Na30qG63YR33n
         R6GwWRNzyVikM10zSDs5P+kPiux9Q8BFjTgB1iU9SU5qxtG4zECY04u3eNYXZzN/kkuo
         GPTA==
X-Gm-Message-State: APjAAAUenZkFEBPflDYhR7zIhxyyg7vTYlw3N+W+uAo/sECnctNgNu57
        MsEHnpVLo8sFdKAQtrG4jnhynTKJOH0lt7u1h4GzsxocfXky5g==
X-Google-Smtp-Source: APXvYqwVyVa5ZbgOr2vDP9vMq4bDWn9mft21kfu0LcQVyH4QLmxLiVh/hu28dtjGlTOIZygkNrECtTEWjnaGEogB+C8=
X-Received: by 2002:a81:3845:: with SMTP id f66mr69249006ywa.220.1578059577107;
 Fri, 03 Jan 2020 05:52:57 -0800 (PST)
MIME-Version: 1.0
References: <0GtwbnKBeenJLjYDiEqWz1RxHrIwx7PSbAxVS-oif8zDKbB97dg5TwYLUmWww8xIFQ3u4mOIcRvA27LqGYmSiF68CjFnubwPqDJyAO9FlQA=@protonmail.com>
 <CANn89iLiDnDfoeuEE-AsbG_bsU5Ojt9VQcZ53FmEOStT9_fj6A@mail.gmail.com> <5gI82sir9U2gaHqvZgEXtxtdFJnbS_9geSflUCqgXjNKjtQfHmBWsfqaNuauMKKpefp5yrcgF7rs7O65ZBGFXL8mLFODpfc_bmB2ZBUgyQM=@protonmail.com>
In-Reply-To: <5gI82sir9U2gaHqvZgEXtxtdFJnbS_9geSflUCqgXjNKjtQfHmBWsfqaNuauMKKpefp5yrcgF7rs7O65ZBGFXL8mLFODpfc_bmB2ZBUgyQM=@protonmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 3 Jan 2020 05:52:45 -0800
Message-ID: <CANn89i+zxbXv2O4C8B+AW5BNbTsQtn6RP7BRx7UQYfRcbWTsTw@mail.gmail.com>
Subject: Re: [PATCH] tcp: Fix tcp_max_syn_backlog limit on connection requests
To:     Ttttabcd <ttttabcd@protonmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 3, 2020 at 5:19 AM Ttttabcd <ttttabcd@protonmail.com> wrote:
>
> However, I think that backward compatibility should not be too serious because sysctl_max_syn_backlog is only enabled when syn_cookies is turned off.
>

Yes, but not your new code :

       max_syn_backlog = min_t(u32, net->ipv4.sysctl_max_syn_backlog,
                             sk->sk_max_ack_backlog);


> If sysctl_max_syn_backlog is set small, there is no difference between the original code and the new code.

There is a difference though....

Set sysctl_max_syn_backlog to 1, and start a reasonable test (not a synflood)

As soon as one SYN_RECV request socket is inserted in the hash, other
SYN packets will generate a syncookie, even if the backlog of the
listener is 100,000

I think the intent of the code is to allow a heavy duty server to use
a huge backlog (say 1,000,000) to avoid syncookies if it has enough
RAM.

In this mode, people never had to tweak sysctl_max_syn_backlog.

>
> Only in the BUG scenarios I mentioned in the patch, the system behavior will change, but these are corrections that have no impact on users.
>
> It's just that the part of the request retention queue will not be mistakenly occupied, and earlier use of syn cookies instead of filling up the backlog.
