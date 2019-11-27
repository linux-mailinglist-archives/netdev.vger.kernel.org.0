Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27AC510B702
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 20:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfK0Tsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 14:48:54 -0500
Received: from mail-yw1-f47.google.com ([209.85.161.47]:33215 "EHLO
        mail-yw1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbfK0Tsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 14:48:53 -0500
Received: by mail-yw1-f47.google.com with SMTP id 192so731775ywy.0
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 11:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C7mf6B1IgGIf5vyQN7hY5uSctDozwwpAw15AYVyo+Vc=;
        b=V1rGNnwtITLqT0beOJAg/q2vrY+logPoEpD8UKr85lNI6qZqxfA9cOmBAjaJbano7D
         QP93VYHUxbGz/2cGus6in9tCpm7ZcxQ8TS3yrZK6vOfq0EYUo1ln9NXgVqImkySVYgVm
         zILb+5zLvRn2pRYAUsubFAmldk1ROFRQKcCtUiESMkX2Pd/biZFvJUgx5pLDm6cOPOTX
         p2qwHiCMhIUZIo8L4qVjBYqUu/zBIuHd4naMJoR0pZcAhtbscyXOybYGnzFoeJj+Emb7
         QuaYcynZRc409NKG+W1dp8CpXhTxyoChcW93U1tu3wIju9Aoa33RdtPdsOfZAEqfth3y
         RjFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C7mf6B1IgGIf5vyQN7hY5uSctDozwwpAw15AYVyo+Vc=;
        b=VWsy81WG7Ip1xlmP0W5ydjG/vHcSjhzm0H6Pg9pQQKS4YNRfbwUsI3BOI3VY68e/gZ
         zbb+3FE1LDWbcjq+eCt9/ANesdmpi0mPmHYYbwkPRC2DZw5Mvg4KZd0FXPJ4Z11EaXhs
         m7V4ZO5chmY6ajouwFAg0tSNM5OoL16+XtPa5BufRItlLXweXAf5AafhK+4Ke/BPcshq
         kDnyfLX9G/jH2ZAMSz6d97T9EPMO2p6roedrmv0i8aL8YFGllFYK+P+q7U/aA1A/IxRg
         iT0i6GwNgAvhBjEgyG1+/UMSlK5ni6y9Kv5kK3+Awy5mmwlaz7a/UBl9pOzVH1Sk3UC2
         lfCQ==
X-Gm-Message-State: APjAAAUovRoWCHxmpDRja+7uebyOZKs43aHxlFny6QWj158ritM7HV1t
        U9NL69CSoCP6OxL2Ur24bXbxjap5
X-Google-Smtp-Source: APXvYqyDZ8XtqpjORvAkHdhLcnFKyQsSihSWK7XxCgzUBXaui47NPVu7BpzyQ+2++M89dJYYQcpLPg==
X-Received: by 2002:a81:f00f:: with SMTP id p15mr4039605ywm.353.1574884130824;
        Wed, 27 Nov 2019 11:48:50 -0800 (PST)
Received: from mail-yw1-f48.google.com (mail-yw1-f48.google.com. [209.85.161.48])
        by smtp.gmail.com with ESMTPSA id f144sm7643704ywb.85.2019.11.27.11.48.49
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 11:48:49 -0800 (PST)
Received: by mail-yw1-f48.google.com with SMTP id d80so8831088ywa.6
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 11:48:49 -0800 (PST)
X-Received: by 2002:a0d:d911:: with SMTP id b17mr4339680ywe.269.1574884128590;
 Wed, 27 Nov 2019 11:48:48 -0800 (PST)
MIME-Version: 1.0
References: <bc84e68c0980466096b0d2f6aec95747@AcuMS.aculab.com>
 <CAJPywTJYDxGQtDWLferh8ObjGp3JsvOn1om1dCiTOtY6S3qyVg@mail.gmail.com>
 <5f4028c48a1a4673bd3b38728e8ade07@AcuMS.aculab.com> <20191127164821.1c41deff@carbon>
 <5eecf41c7e124d7dbc0ab363d94b7d13@AcuMS.aculab.com>
In-Reply-To: <5eecf41c7e124d7dbc0ab363d94b7d13@AcuMS.aculab.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Nov 2019 14:48:12 -0500
X-Gmail-Original-Message-ID: <CA+FuTSe8vfEME7EO6xru=i1++OWCNRJGePLNCzta+BVv_TY3Zw@mail.gmail.com>
Message-ID: <CA+FuTSe8vfEME7EO6xru=i1++OWCNRJGePLNCzta+BVv_TY3Zw@mail.gmail.com>
Subject: Re: epoll_wait() performance
To:     David Laight <David.Laight@aculab.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Marek Majkowski <marek@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 11:04 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Jesper Dangaard Brouer
> > Sent: 27 November 2019 15:48
> > On Wed, 27 Nov 2019 10:39:44 +0000 David Laight <David.Laight@ACULAB.COM> wrote:
> >
> > > ...
> > > > > While using recvmmsg() to read multiple messages might seem a good idea, it is much
> > > > > slower than recv() when there is only one message (even recvmsg() is a lot slower).
> > > > > (I'm not sure why the code paths are so slow, I suspect it is all the copy_from_user()
> > > > > and faffing with the user iov[].)
> > > > >
> > > > > So using poll() we repoll the fd after calling recv() to find is there is a second message.
> > > > > However the second poll has a significant performance cost (but less than using recvmmsg()).
> > > >
> > > > That sounds wrong. Single recvmmsg(), even when receiving only a
> > > > single message, should be faster than two syscalls - recv() and
> > > > poll().
> > >
> > > My suspicion is the extra two copy_from_user() needed for each recvmsg are a
> > > significant overhead, most likely due to the crappy code that tries to stop
> > > the kernel buffer being overrun.
> > >
> > > I need to run the tests on a system with a 'home built' kernel to see how much
> > > difference this make (by seeing how much slower duplicating the copy makes it).
> > >
> > > The system call cost of poll() gets factored over a reasonable number of sockets.
> > > So doing poll() on a socket with no data is a lot faster that the setup for recvmsg
> > > even allowing for looking up the fd.
> > >
> > > This could be fixed by an extra flag to recvmmsg() to indicate that you only really
> > > expect one message and to call the poll() function before each subsequent receive.
> > >
> > > There is also the 'reschedule' that Eric added to the loop in recvmmsg.
> > > I don't know how much that actually costs.
> > > In this case the process is likely to be running at a RT priority and pinned to a cpu.
> > > In some cases the cpu is also reserved (at boot time) so that 'random' other code can't use it.
> > >
> > > We really do want to receive all these UDP packets in a timely manner.
> > > Although very low latency isn't itself an issue.
> > > The data is telephony audio with (typically) one packet every 20ms.
> > > The code only looks for packets every 10ms - that helps no end since, in principle,
> > > only a single poll()/epoll_wait() call (on all the sockets) is needed every 10ms.
> >
> > I have a simple udp_sink tool[1] that cycle through the different
> > receive socket system calls.  I gave it a quick spin on a F31 kernel
> > 5.3.12-300.fc31.x86_64 on a mlx5 100G interface, and I'm very surprised
> > to see a significant regression/slowdown for recvMmsg.
> >
> > $ sudo ./udp_sink --port 9 --repeat 1 --count $((10**7))
> >               run      count          ns/pkt  pps             cycles  payload
> > recvMmsg/32   run:  0 10000000        1461.41 684270.96       5261    18       demux:1
> > recvmsg       run:  0 10000000        889.82  1123824.84      3203    18       demux:1
> > read          run:  0 10000000        974.81  1025841.68      3509    18       demux:1
> > recvfrom      run:  0 10000000        1056.51 946513.44       3803    18       demux:1
> >
> > Normal recvmsg almost have double performance that recvmmsg.
> >  recvMmsg/32 = 684,270 pps
> >  recvmsg     = 1,123,824 pps
>
> Can you test recv() as well?
> I think it might be faster than read().
>
> ...
> > Found some old results (approx v4.10-rc1):
> >
> > [brouer@skylake src]$ sudo taskset -c 2 ./udp_sink --count $((10**7)) --port 9 --connect
> >  recvMmsg/32    run: 0 10000000 537.89  1859106.74      2155    21559353816
> >  recvmsg        run: 0 10000000 552.69  1809344.44      2215    22152468673
> >  read           run: 0 10000000 476.65  2097970.76      1910    19104864199
> >  recvfrom       run: 0 10000000 450.76  2218492.60      1806    18066972794
>
> That is probably nearer what I am seeing on a 4.15 Ubuntu 18.04 kernel.
> recvmmsg() and recvmsg() are similar - but both a lot slower then recv().

Indeed, surprising that recv(from) would be less efficient than recvmsg.

Are the latest numbers with CONFIG_HARDENED_USERCOPY?

I assume that the poll() after recv() is non-blocking. If using
recvmsg, that extra syscall could be avoided by implementing a cmsg
inq hint for udp sockets analogous to TCP_CM_INQ/tcp_inq_hint.

More outlandish would be to abuse the mmsghdr->msg_len field to pass
file descriptors and amortize the kernel page-table isolation cost
across sockets. Blocking semantics would be weird, for starters.
