Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB2AA605C4
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 14:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfGEMNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 08:13:01 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33226 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfGEMNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 08:13:01 -0400
Received: by mail-io1-f65.google.com with SMTP id z3so3727777iog.0
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 05:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZjSi1phh9bs9cO7L1xnR1XrPIATfNuDiH5azONYl06E=;
        b=paysDx96hoCWePm5oMMcsaQJqv9GUq2HdAxau0cn7Ksk6cmgX/E/PlM5wdfq5dRaA0
         ZqfcyHQ2vyGLupa/17Bi628ZopXct62bX+iu86AaaOSDWPB/eCU7I4pgc0pcEAFbZsme
         9MaeRHSIqr4CSKAdIBG0a1ARSdeKfhKCMgejPLo7sfBYsywQ+OlqtkK3IbyRCI6hrcX1
         cQTHU7JFEA2LX6BzxxnD00D2n6KC6CuXMACz8oPaLF9i5f6vQAww+HkeYI/SosdEfErW
         Vv0CMPvxnRXwC8pMxyNZBRGISsqrOM2cgnoMEU8AQld0WjodU460hcpGJVlGx3fL+AR+
         QaFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZjSi1phh9bs9cO7L1xnR1XrPIATfNuDiH5azONYl06E=;
        b=fVsj6JW2vamD6cMivFlaHdoyk6VGNdsRAoE+3ReEkgcsUdkkXdQPbmfzWPmeVvSS2N
         g6ZIXGQ14suOPkSLiQkidixbGJ8YG/BS1L2usvwmITgXrQPoQAjTlJFw1nyRp32IbyjI
         NqkRGtjl58gZEH3yiRYT3YqLGx9411+nePzMrPvPWEzh8FIrS3+v409iYchkaRgDnE+6
         ewrC91Na+4E+gqcS7f1JQTltonjcpNg2owlQn6/fih2qL4bjqaaUS+59i/ovKNGmRihB
         dtrX/X60bzJWCEAkhBWoYD6ENF2yfWf/sEr/8TFzo1UDTylMk2e82gnJ/WKlyFXARaC4
         +bpQ==
X-Gm-Message-State: APjAAAUu5FjayOppzm4Gq6CmmZK+nk0mlchESS8AFCMaQbV51Ldkmiga
        IQRs2HqU1AzBBT8waE/MHu3BrKa5LjG90U5X2jDGNw==
X-Google-Smtp-Source: APXvYqz7ZT1v+Nqu10I2/ufgDaj6I6GvF4VP462R+l2op+FhKm5UWHNcYFV/bqFT/3p6G+nQ9qnf4pMo9wkiq6tiTNg=
X-Received: by 2002:a02:c7c9:: with SMTP id s9mr4012381jao.82.1562328780417;
 Fri, 05 Jul 2019 05:13:00 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000004c2416058c594b30@google.com> <24282.1562074644@warthog.procyon.org.uk>
In-Reply-To: <24282.1562074644@warthog.procyon.org.uk>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 5 Jul 2019 14:12:48 +0200
Message-ID: <CACT4Y+YjdV8CqX5=PzKsHnLsJOzsydqiq3igYDm_=nSdmFo2YQ@mail.gmail.com>
Subject: Re: kernel BUG at net/rxrpc/local_object.c:LINE!
To:     David Howells <dhowells@redhat.com>
Cc:     syzbot <syzbot+1e0edc4b8b7494c28450@syzkaller.appspotmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

,On Tue, Jul 2, 2019 at 3:37 PM David Howells <dhowells@redhat.com> wrote:
>
> syzbot <syzbot+1e0edc4b8b7494c28450@syzkaller.appspotmail.com> wrote:
>
> I *think* the reproducer boils down to the attached, but I can't get syzkaller
> to work and the attached sample does not cause the oops to occur.  Can you try
> it in your environment?
>
> > The bug was bisected to:
> >
> > commit 46894a13599a977ac35411b536fb3e0b2feefa95
> > Author: David Howells <dhowells@redhat.com>
> > Date:   Thu Oct 4 08:32:28 2018 +0000
> >
> >     rxrpc: Use IPv4 addresses throught the IPv6
>
> This might not be the correct bisection point.  If you look at the attached
> sample, you're mixing AF_INET and AF_INET6.  If you try AF_INET throughout,
> that might get a different point.  On the other hand, since you've bound the
> socket, the AF_INET6 passed to socket() should be ignored.
>
> David
> ---
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> #include <sys/socket.h>
> #include <arpa/inet.h>
> #include <linux/rxrpc.h>
>
> static const unsigned char inet4_addr[4] = {
>         0xe0, 0x00, 0x00, 0x01
> };
>
> int main(void)
> {
>         struct sockaddr_rxrpc srx;
>         int fd;
>
>         memset(&srx, 0, sizeof(srx));
>         srx.srx_family                  = AF_RXRPC;
>         srx.srx_service                 = 0;
>         srx.transport_type              = AF_INET;
>         srx.transport_len               = sizeof(srx.transport.sin);
>         srx.transport.sin.sin_family    = AF_INET;
>         srx.transport.sin.sin_port      = htons(0x4e21);
>         memcpy(&srx.transport.sin.sin_addr, inet4_addr, 4);
>
>         fd = socket(AF_RXRPC, SOCK_DGRAM, AF_INET6);
>         if (fd == -1) {
>                 perror("socket");
>                 exit(1);
>         }
>
>         if (bind(fd, (struct sockaddr *)&srx, sizeof(srx)) == -1) {
>                 perror("bind");
>                 exit(1);
>         }
>
>         sleep(20);
>
>         // Whilst sleeping, hit with:
>         // echo -e '\0\0\0\0\0\0\0\0' | ncat -4u --send-only 224.0.0.1 20001
>
>         return 0;
> }

Hi David,

I can't re-reproduce it locally in qemu either. Though, syzbot managed
to re-reproduce it reliably during bisection (maybe there is some
difference in hardware and as the result the injected ethernet packet
would need some different values). Let's try to ask it again to make
sure:
#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
master

Re bisection, I don't know if there are some more subtle things as
play (you are in the better position to judge that), but bisection log
looks good, it tracked the target crash throughout and wasn't
distracted by any unrelated bugs, etc. So I don't see any obvious
reasons to not trust it.
