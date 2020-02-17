Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9957B160852
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgBQCtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:49:45 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36993 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgBQCtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:49:45 -0500
Received: by mail-wr1-f68.google.com with SMTP id w15so17799203wru.4
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 18:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QbCKuQ3HWUk2tjBL4ms2S9fkU78qMXUWOgnMMNKtfqA=;
        b=BC8iPXbUVUjLotfxMGgI0rzf15pX7EZZZIpYktiRoItFNovqCq5y1XMx2ouZIh8zSU
         WcIhCsB9TSgsoRRTF7kE8iH5s9Lfibp9pfWche8yXhP8SGS6hevjysl4SlDT0Hx0wNO5
         /A0/CTgM0/0/eRn3zfTroGwPglBnBfQqe3NuqCcHQlW5eL0ogyHw/5edc6bHamKk20d7
         Q6Z2eV/pkdUmBrjXkfXjpaEIGPlWqfd94b91dK1GkF7FgZrowdjSKWhH+/nuyohKdcpZ
         MP5azqKnXM2BAa0F5/v8/tUbwngsYihHWRoGV+j+aQ+LLq2XW10pbxnGoIsu1kKsrlzi
         YSdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QbCKuQ3HWUk2tjBL4ms2S9fkU78qMXUWOgnMMNKtfqA=;
        b=c+QIvIvb6FmoUYYRypexF26rnLYhERYJbbQUu905aWyQhfJA4rkYvxt+Rj1fWGHQ17
         eLLsADTpzr/pZHauQhwbzOl7FAr//GwzvYpBgla5Ut4lV/zOMvvwwntFmgFNSJeFr69o
         pIfb/CDBeQXE3yYK8ql8MANv9KzFjB05NsT2ggzbzg9L8r24H2EjevQkvPjokOrFVrXl
         jM6LJQzp5+IpKBVDm1nrmiifwyQIDvT8lcxbkOasTiL63UgOL1nyVjglHThxHDz2MxrI
         HpqcfTCh6U67LnZzFYMVUBUJ2hsqgzv5cHd3kLrR1ZJ856hq0e1Tiz7Yg2HfE4uu20zC
         WlRQ==
X-Gm-Message-State: APjAAAXq2iGYugP5lHZ1Xkt8a6ydbjU+37QuT6FQleItH1fhtiNaRGEy
        SrOtbEWkyZoPtpTBaXGmxh5B0WYxZOdUveyxJOiC2A==
X-Google-Smtp-Source: APXvYqyb4CGujtE+7iOmYlkYkOUSWA+lEPcMiT5hg9For2xP7aoDRWM21l5+HQgr9UrviS1J0HU0+Qt3LFYTA2oWk5U=
X-Received: by 2002:a5d:6545:: with SMTP id z5mr18489870wrv.3.1581907782489;
 Sun, 16 Feb 2020 18:49:42 -0800 (PST)
MIME-Version: 1.0
References: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
 <20200128025958.43490-3-arjunroy.kdev@gmail.com> <20200212185605.d89c820903b7aa9fbbc060b2@linux-foundation.org>
In-Reply-To: <20200212185605.d89c820903b7aa9fbbc060b2@linux-foundation.org>
From:   Arjun Roy <arjunroy@google.com>
Date:   Sun, 16 Feb 2020 18:49:31 -0800
Message-ID: <CAOFY-A1o0L_D7Oyi1S=+Ng+2dK35-QHSSUQ9Ct3EA5y-DfWaXA@mail.gmail.com>
Subject: Re: [PATCH resend mm,net-next 3/3] net-zerocopy: Use
 vm_insert_pages() for tcp rcv zerocopy.
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 6:56 PM Andrew Morton <akpm@linux-foundation.org> w=
rote:
>
> On Mon, 27 Jan 2020 18:59:58 -0800 Arjun Roy <arjunroy.kdev@gmail.com> wr=
ote:
>
> > Use vm_insert_pages() for tcp receive zerocopy. Spin lock cycles
> > (as reported by perf) drop from a couple of percentage points
> > to a fraction of a percent. This results in a roughly 6% increase in
> > efficiency, measured roughly as zerocopy receive count divided by CPU
> > utilization.
> >
> > The intention of this patch-set is to reduce atomic ops for
> > tcp zerocopy receives, which normally hits the same spinlock multiple
> > times consecutively.
>
> For some reason the patch causes this:
>
> In file included from ./arch/x86/include/asm/atomic.h:5:0,
>                  from ./include/linux/atomic.h:7,
>                  from ./include/linux/crypto.h:15,
>                  from ./include/crypto/hash.h:11,
>                  from net/ipv4/tcp.c:246:
> net/ipv4/tcp.c: In function =E2=80=98do_tcp_getsockopt.isra.29=E2=80=99:
> ./include/linux/compiler.h:225:31: warning: =E2=80=98tp=E2=80=99 may be u=
sed uninitialized in this function [-Wmaybe-uninitialized]
>   case 4: *(volatile __u32 *)p =3D *(__u32 *)res; break;
>           ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~
> net/ipv4/tcp.c:1779:19: note: =E2=80=98tp=E2=80=99 was declared here
>   struct tcp_sock *tp;
>                    ^~
>
> It's a false positive.  gcc-7.2.0
>
> : out:
> :        up_read(&current->mm->mmap_sem);
> :        if (length) {
> :                WRITE_ONCE(tp->copied_seq, seq);
>
> but `length' is zero here.
>
> This suppresses it:
>
> --- a/net/ipv4/tcp.c~net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocop=
y-fix
> +++ a/net/ipv4/tcp.c
> @@ -1788,6 +1788,8 @@ static int tcp_zerocopy_receive(struct s
>
>         sock_rps_record_flow(sk);
>
> +       tp =3D tcp_sk(sk);
> +
>         down_read(&current->mm->mmap_sem);
>
>         ret =3D -EINVAL;
> @@ -1796,7 +1798,6 @@ static int tcp_zerocopy_receive(struct s
>                 goto out;
>         zc->length =3D min_t(unsigned long, zc->length, vma->vm_end - add=
ress);
>
> -       tp =3D tcp_sk(sk);
>         seq =3D tp->copied_seq;
>         inq =3D tcp_inq(sk);
>         zc->length =3D min_t(u32, zc->length, inq);
>
> and I guess it's zero-cost.
>
>
> Anyway, I'll sit on this lot for a while, hoping for a davem ack?

Actually, speaking of the ack on the networking side:

I guess this patch set is a bit weird since it requires some
non-trivial coordination between mm and net-next? Not sure what the
normal approach is in this case.

-Arjun
