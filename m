Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A336B6B8F1
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 11:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfGQJJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 05:09:08 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35662 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfGQJJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 05:09:08 -0400
Received: by mail-qk1-f196.google.com with SMTP id r21so16910312qke.2
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 02:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aG2CHW+kcT8fYp6zyhNxkRG44CByJ+PkKI4bP1KAC9Q=;
        b=nEvtiM0vEuknajfYSP7dcELsVINeap3xQb80ItNFWmTQ3ClsCqLcjuGYyOepDDh4Rx
         G0isqu3Bw+Idu+fBO9Gvam1Nv9+nFHYK5R5KHG2OJnIlBVDC19yFhdCVctMLeLetpDCw
         KXQQcSx+pExznuUyHCiDCX0DhOYF/l441nxSs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aG2CHW+kcT8fYp6zyhNxkRG44CByJ+PkKI4bP1KAC9Q=;
        b=LQxDLarZsYtAzvch3Hk+RUC4pQdwjNaxzz7LmYs4sT2xYsulM1dt9Cx5qNwYkrSsKo
         SrqyEiFsrVyJz/BdBfotDukb0aXXMLVxCEcgSXG4JzbtHQJFpmhFhsYIpmPJViUPAzsc
         zIeQCWrFWkIbvdIZqEQlLh9DUhdCMfA+MKAA9lO5zixY8Md010zn/X9ZWWLRKJpD4Ok+
         iCtukGwnAwFJ4FyFQ0FeZIdsveSDptXQAJBxlZPc9Q8+d7h3zF3jk5vtVm81/+/JDYiO
         QBAmbEHS1rimNnx8O5+4fDMTTzbHInSpdHc3djXFIEv9l4UmDa+1i1FpGZRE/BQ/Sxd5
         R78Q==
X-Gm-Message-State: APjAAAU7Yn+HZ0AyNZDz6wF8QAg2IF0peTaSNvUvX0XuFHspcW4f4Pui
        u5a/hzFHYHZehHvQrw/xmBIXNCpAkM7J94+cIWPYKA==
X-Google-Smtp-Source: APXvYqyYMX7ZcIhcrJE0YLQzSb9aZvbzL7jL3v6TDB4+HCxHDVrqSEfOXxyqIFXGF5L+4se8Yl65GK/5x9aq9V58xes=
X-Received: by 2002:a05:620a:136d:: with SMTP id d13mr25324854qkl.22.1563354547147;
 Wed, 17 Jul 2019 02:09:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAJPywTL5aKYB40FsAFYFEuhErhgQpYZP5Q_ipMG9pDxqipcEDg@mail.gmail.com>
 <CAPkQJpRJadEqxOcdb_U5Tz6NPE3h3FzootQt3r2GgPP0aYsVvA@mail.gmail.com>
In-Reply-To: <CAPkQJpRJadEqxOcdb_U5Tz6NPE3h3FzootQt3r2GgPP0aYsVvA@mail.gmail.com>
From:   Marek Majkowski <marek@cloudflare.com>
Date:   Wed, 17 Jul 2019 11:08:55 +0200
Message-ID: <CAJPywTL1MwQWoznv3xGLdjbAUL-LK6pZh1YETg4y8HODK5-zQw@mail.gmail.com>
Subject: Re: OOM triggered by SCTP
To:     malc <mlashley@gmail.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, Linux SCTP <linux-sctp@vger.kernel.org>,
        netdev@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Malc, thanks taking a look.

I'm able to trigger the problem on non-SMP virtme with 4GiB ram, but
I'm not able to trigger it on my SMP host with 16GiB.

The slab info from dmesg (on 4GiB run):
Unreclaimable slab info:
SCTPv6                 31068KB      31068KB
sctp_chunk             24321KB      24990KB
sctp_bind_bucket         972KB        972KB
skbuff_head_cache      28484KB      29051KB
kmalloc-8k                82KB        148KB
kmalloc-4k             81897KB      82943KB
kmalloc-2k               314KB        382KB
kmalloc-1k             27446KB      29547KB
kmalloc-512            30312KB      30915KB

The biggest issue is that the OOM is often unrecoverable:

---[ end Kernel panic - not syncing: System is deadlocked on memory ]---
Out of memory and no killable processes...
Kernel panic - not syncing: System is deadlocked on memory

I noticed sctp_mem toggle. Would tweaking it change anything?
net.sctp.sctp_mem =3D 80976    107969    161952
net.sctp.sctp_rmem =3D 4096    865500    3455008
net.sctp.sctp_wmem =3D 4096    16384    3455008

For the record, stuffing "shutdown(sd, SHUT_RDWR)" before the "close"
doesn't solve the problem.

Marek

On Wed, Jul 17, 2019 at 1:59 AM malc <mlashley@gmail.com> wrote:
>
> On Tue, Jul 16, 2019 at 10:49 PM Marek Majkowski <marek@cloudflare.com> w=
rote:
> >
> > Morning,
> >
> > My poor man's fuzzer found something interesting in SCTP. It seems
> > like creating large number of SCTP sockets + some magic dance, upsets
> > a memory subsystem related to SCTP. The sequence:
> >
> >  - create SCTP socket
> >  - call setsockopts (SCTP_EVENTS)
> >  - call bind(::1, port)
> >  - call sendmsg(long buffer, MSG_CONFIRM, ::1, port)
> >  - close SCTP socket
> >  - repeat couple thousand times
> >
> > Full code:
> > https://gist.github.com/majek/bd083dae769804d39134ce01f4f802bb#file-tes=
t_sctp-c
> >
> > I'm running it on virtme the simplest way:
> > $ virtme-run --show-boot-console --rw --pwd --kimg bzImage --memory
> > 512M --script-sh ./test_sctp
> >
> > Originally I was running it inside net namespace, and just having a
> > localhost interface is sufficient to trigger the problem.
> >
> > Kernel is 5.2.1 (with KASAN and such, but that shouldn't be a factor).
> > In some tests I saw a message that might indicate something funny
> > hitting neighbor table:
> >
> > neighbour: ndisc_cache: neighbor table overflow!
> >
> > I'm not addr-decoding the stack trace, since it seems unrelated to the
> > root cause.
> >
> > Cheers,
> >     Marek
>
> I _think_ this is an 'expected' peculiarity of SCTP on loopback - you
> test_sctp.c ends up creating actual associations to itself on the same
> socket (you can test safely by reducing the port range (say
> 30000-32000) and setting the for-loop-clause to 'run < 1')
> You'll see a bunch of associations established like the following
> (note that I(kernel) was dropping packets for this capture - even with
> /only/ 2000 sockets used...)
>
> $ tshark -r sctp.pcap -Y 'sctp.assoc_index=3D=3D4'
>   21 0.000409127          ::1 =E2=86=92 ::1           SCTP INIT
>   22 0.000436281          ::1 =E2=86=92 ::1           SCTP INIT_ACK
>   23 0.000442106          ::1 =E2=86=92 ::1           SCTP COOKIE_ECHO
>   24 0.000463007          ::1 =E2=86=92 ::1           SCTP COOKIE_ACK DAT=
A
> (Message Fragment)
>                                               presumably your close()
> happens here and we enter SHUTDOWN-PENDING, where we wait for pending
> data to be acknowledged, I'm not convinced that we shouldn't be
> SACK'ing the data from the 'peer' at this point - but for whatever
> reason, we aren't.
>                                               We then run thru
> path-max-retrans, and finally ABORT (the abort indication also shows
> the PMR-exceeded indication in the 'Cause Information')
>   25 0.000476083          ::1 =E2=86=92 ::1           SCTP SACK
> 13619 3.017788109          ::1 =E2=86=92 ::1           SCTP DATA (retrans=
mission)
> 14022 3.222690889          ::1 =E2=86=92 ::1           SCTP SACK
> 18922 21.938217449          ::1 =E2=86=92 ::1           SCTP SACK
> 33476 69.831029904          ::1 =E2=86=92 ::1           SCTP HEARTBEAT
> 33561 69.831310796          ::1 =E2=86=92 ::1           SCTP HEARTBEAT_AC=
K
> 40816 94.102667600          ::1 =E2=86=92 ::1           SCTP SACK
> 40910 95.942741287          ::1 =E2=86=92 ::1           SCTP DATA (retran=
smission)
> 41039 96.152023010          ::1 =E2=86=92 ::1           SCTP SACK
> 41100 100.182685237          ::1 =E2=86=92 ::1           SCTP SACK
> 41212 108.230746764          ::1 =E2=86=92 ::1           SCTP DATA (retra=
nsmission)
> 41345 108.439061392          ::1 =E2=86=92 ::1           SCTP SACK
> 41407 116.422688507          ::1 =E2=86=92 ::1           SCTP HEARTBEAT
> 41413 116.423183124          ::1 =E2=86=92 ::1           SCTP HEARTBEAT_A=
CK
> 41494 124.823749255          ::1 =E2=86=92 ::1           SCTP SACK
> 41576 126.663648718          ::1 =E2=86=92 ::1           SCTP ABORT
>
> With your entire 512M - you'd only have about 16KB for each of these
> 31K associations tops, I suspect that having a 64KB pending data chunk
> (fragmented ULP msg) for each association for >=3D 90s is what is
> exhausting memory here - although I'm sure Neil or Michael will be
> along to correct me ;-)
>
> What's interesting - as you reduce the payload size - we end up
> bundling DATA from the 'initiator' side (in COOKIE ECHO) - and
> everything works as expected... (the SACK here is for the bundled DATA
> chunks TSN.
>
> mlashley@duality /tmp $ tshark -r /tmp/sctp_index4_10K.pcap
>    1 0.000000000          ::1 =E2=86=92 ::1          SCTP INIT
>    2 0.000014491          ::1 =E2=86=92 ::1          SCTP INIT_ACK
>    3 0.000024190          ::1 =E2=86=92 ::1          SCTP COOKIE_ECHO DAT=
A
>    4 0.000034833          ::1 =E2=86=92 ::1          SCTP COOKIE_ACK
>    5 0.000040646          ::1 =E2=86=92 ::1          SCTP SACK
>    6 0.000050287          ::1 =E2=86=92 ::1          SCTP ABORT
>
> In short - the SCTP associations /can/ persist after user-space calls
> close() whilst there is outstanding data (for path.max.retrans *
> rto-with-doubling[due to T3-rtx expiry])
>
> (My tests on 5.2.0 as it is what I had to hand...)
>
> Cheers,
> malc.
