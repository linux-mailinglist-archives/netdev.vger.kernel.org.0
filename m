Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1801614DF90
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 18:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbgA3RCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 12:02:22 -0500
Received: from mail-yw1-f44.google.com ([209.85.161.44]:45762 "EHLO
        mail-yw1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727193AbgA3RCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 12:02:21 -0500
Received: by mail-yw1-f44.google.com with SMTP id a125so2295555ywe.12
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 09:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GWyw2294XdMAvsthTlcx13XjSW4J/Y/cJveTRnfDmRs=;
        b=K94PvBPMaoFOmbLn+LR29NEndRELbCTzCdiuSGcC3rB0u0GiPIs+BZtubd6awuEI38
         H4ed5a0tCrr2QKR5WhL/mxXv2gR03TUMWiaMt23D5j6XeuVXoqACNGvCPh49Y1P2jfdM
         CtCwy4TrPvSonNdA0bFihQpIPBVNJ/WtfzphGNeHTVO5IFfOSNpZsqq2RF9KUb7VXNwQ
         GNzy8+xNksndYdW0sRruQQlLmeGbmXl64n0vR69XH4K+LkmL56xZNzOwjUvvMs3ZsTVK
         pTCOHho5QwrhDrVnwi4RE6KAc+eU5l3/1ZmPiA+Wwontvc3Ft0YHNzHzMzvS7QUdaf5Z
         MtCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GWyw2294XdMAvsthTlcx13XjSW4J/Y/cJveTRnfDmRs=;
        b=NUTzU4cZW+3p5Y+3vD1GvIg6QDp/dXY7II0+7l6maIyxwZLYs6ZBiAhzNoR0zLekG2
         oEubAT/5dr6WmmODa9Dxqg0a+x9xHQPBsw96iXlMoHBjmZ+7eGZy1frJCSASDOSpSoq8
         vIls3VSBj4TRjR6WfNzKocopOKVb+mm/1upEAv6nOE4L/YmR961yZdkRvmygnbSO6cFS
         8sjoBfD25RSvGmQ4bIzzG5VvT2gRkmS3E2p0BaxotpkpteyXJjKhFxW1JSppH4A2m/LB
         7y/qdCGcvdBTnAMwl0zfxsVUhwY9TJllDa1e+sFebRfuamJ01dkslWNFl1I4MIVtsjHW
         buQg==
X-Gm-Message-State: APjAAAU0iA5KAb+8FGhOF/RQ95F3T57N4JUVHgHVP/3caR6oeXOLjzTH
        klRGZcuT/tMajXng6GCfkR8dbC4i1kEhy2RU765qqQ==
X-Google-Smtp-Source: APXvYqyTjdHogLaV/3tWd/Kd2UXYv0Awbm0eMTiU1lyEzQFA73rkgoTS511rXtpynkwnHbysBe+KZRyxowbmk8x9Jno=
X-Received: by 2002:a81:3a06:: with SMTP id h6mr4135966ywa.170.1580403740040;
 Thu, 30 Jan 2020 09:02:20 -0800 (PST)
MIME-Version: 1.0
References: <CANn89iJOK9UMQspgikPWb-NA6vmo+wQPB5q7hnWpHDSxYrUSnA@mail.gmail.com>
 <20200130124121.24587-1-sjpark@amazon.com>
In-Reply-To: <20200130124121.24587-1-sjpark@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 30 Jan 2020 09:02:08 -0800
Message-ID: <CANn89iKDn2XhrnLo2rLf7HGXanEuokprqJ_mb0iPqXEnARc9tw@mail.gmail.com>
Subject: Re: Re: Latency spikes occurs from frequent socket connections
To:     sjpark@amazon.com
Cc:     David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        andriin@fb.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        aams@amazon.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        dola@amazon.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 4:41 AM <sjpark@amazon.com> wrote:
>
> On Wed, 29 Jan 2020 09:52:43 -0800 Eric Dumazet <edumazet@google.com> wrote:
>
> > On Wed, Jan 29, 2020 at 9:14 AM <sjpark@amazon.com> wrote:
> > >
> > > Hello,
> > >
> > >
> > > We found races in the kernel code that incur latency spikes.  We thus would
> > > like to share our investigations and hear your opinions.
> > >
> > >
> > > Problem Reproduce
> > > =================
> > >
> > > You can reproduce the problem by compiling and running source code of
> > > 'server.c' and 'client.c', which I pasted at the end of this mail, as below:
> > >
> > >     $ gcc -o client client.c
> > >     $ gcc -o server server.c
> > >     $ ./server &
> > >     $ ./client
> > >     ...
> > >     port: 45150, lat: 1005320, avg: 229, nr: 1070811
> > >     ...
> > >
> >
> > Thanks for the repro !
>
> My pleasure :)
>
> >
> [...]
> > > Experimental Fix
> > > ----------------
> > >
> > > We confirmed this is the case by logging and some experiments.  Further,
> > > because the process of RST/ACK packet would stuck in front of the critical
> > > section while the ACK is being processed inside the critical section in most
> > > case, we add one more check of the RST/ACK inside the critical section.  In
> > > detail, it's as below:
> > >
> > >     --- a/net/ipv4/tcp_ipv4.c
> > >     +++ b/net/ipv4/tcp_ipv4.c
> > >     @@ -1912,6 +1912,29 @@ int tcp_v4_rcv(struct sk_buff *skb)
> > >             tcp_segs_in(tcp_sk(sk), skb);
> > >             ret = 0;
> > >             if (!sock_owned_by_user(sk)) {
> > >     +               // While waiting for the socket lock, the sk may have
> > >     +               // transitioned to FIN_WAIT2/TIME_WAIT so lookup the
> > >     +               // twsk and if one is found reprocess the skb
> > >     +               if (unlikely(sk->sk_state == TCP_CLOSE && !th->syn
> > >     +                       && (th->fin || th->rst))) {
> > >     +                       struct sock *sk2 = __inet_lookup_established(
> > >     +                               net, &tcp_hashinfo,
> > >     +                               iph->saddr, th->source,
> > >     +                               iph->daddr, ntohs(th->dest),
> > >     +                               inet_iif(skb), sdif);
> > >     +                       if (sk2) {
> > >     +                               if (sk2 == sk) {
> > >     +                                       sock_put(sk2);
> > >     +                               } else {
> > >     +                                       bh_unlock_sock(sk);
> > >     +                                       tcp_v4_restore_cb(skb);
> > >     +                                       if (refcounted) sock_put(sk);
> > >     +                                       sk = sk2;
> > >     +                                       refcounted = true;
> > >     +                                       goto process;
> > >     +                               }
> > >     +                       }
> > >     +               }
> >
> >
> > Here are my comments
> >
> >
> > 1) This fixes IPv4 side only, so it can not be a proper fix.
> >
> > 2) TCP is best effort. You can retry the lookup in ehash tables as
> > many times you want, a race can always happen after your last lookup.
> >
> >   Normal TCP flows going through a real NIC wont hit this race, since
> > all packets for a given 4-tuple are handled by one cpu (RSS affinity)
> >
> > Basically, the race here is that 2 packets for the same flow are
> > handled by two cpus.
> > Who wins the race is random, we can not enforce a particular order.
>
> Thank you for the comments!  I personally agree with your opinions.
>
> >
> > I would rather try to fix the issue more generically, without adding
> > extra lookups as you did, since they might appear
> > to reduce the race, but not completely fix it.
> >
> > For example, the fact that the client side ignores the RST and
> > retransmits a SYN after one second might be something that should be
> > fixed.
>
> I also agree with this direction.  It seems detecting this situation and
> adjusting the return value of tcp_timeout_init() to a value much lower than the
> one second would be a straightforward solution.  For a test, I modified the
> function to return 1 (4ms for CONFIG_HZ=250) and confirmed the reproducer be
> silent.  My following question is, how we can detect this situation in kernel?
> However, I'm unsure how we can distinguish this specific case from other cases,
> as everything is working as normal according to the TCP protocol.
>
> Also, it seems the value is made to be adjustable from the user space using the
> bpf callback, BPF_SOCK_OPS_TIMEOUT_INIT:
>
>     BPF_SOCK_OPS_TIMEOUT_INIT,  /* Should return SYN-RTO value to use or
>                                  * -1 if default value should be used
>                                  */
>
> Thus, it sounds like you are suggesting to do the detection and adjustment from
> user space.  Am I understanding your point?  If not, please let me know.
>

No, I was suggesting to implement a mitigation in the kernel :

When in SYN_SENT state, receiving an suspicious ACK should not
simply trigger a RST.

There are multiple ways maybe to address the issue.

1) Abort the SYN_SENT state and let user space receive an error to its
connect() immediately.

2) Instead of a RST, allow the first SYN retransmit to happen immediately
(This is kind of a challenge SYN. Kernel already implements challenge acks)

3) After RST is sent (to hopefully clear the state of the remote),
schedule a SYN rtx in a few ms,
instead of ~ one second.


> >
> >
> >
> > 11:57:14.436259 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq
> > 2560603644, win 65495, options [mss 65495,sackOK,TS val 953760623 ecr
> > 0,nop,wscale 7], length 0
> > 11:57:14.436266 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [.], ack 5,
> > win 512, options [nop,nop,TS val 953760623 ecr 953759375], length 0
> > 11:57:14.436271 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [R], seq
> > 2541101298, win 0, length 0
> > 11:57:15.464613 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq
> > 2560603644, win 65495, options [mss 65495,sackOK,TS val 953761652 ecr
> > 0,nop,wscale 7], length 0
> >
> >
> >
> >                     skb_to_free = sk->sk_rx_skb_cache;
> > >                     sk->sk_rx_skb_cache = NULL;
> > >                     ret = tcp_v4_do_rcv(sk, skb);
> > >
> > > We applied this change to the kernel and confirmed that the latency spikes
> > > disappeared with the reproduce program.
> > >
> > >
> > > More Races
> > > ----------
> > >
> > > Further, the man who found the code path and made the fix found another race
> > > resulted from the commit ec94c2696f0b ("tcp/dccp: avoid one atomic operation
> > > for timewait hashdance").  He believes the 'refcount_set()' should be done
> > > before the 'spin_lock()', as it allows others to see the packet in the list but
> > > ignore as the reference count is zero.  This race seems much rare than the
> > > above one and thus we have no reproducible test for this, yet.
> >
> > Again, TCP is best effort, seeing the refcount being 0 or not is
> > absolutely fine.
> >
> > The cpu reading the refcnt can always be faster than the cpu setting
> > the refcount to non zero value, no matter how hard you try.
> >
> > The rules are more like : we need to ensure all fields have
> > stable/updated values before allowing other cpus to get the object.
> > Therefore, writing a non zero refcount should happen last.
>
> I personally agree on this, either.
>
>
> Thanks,
> SeongJae Park
>
> >
> > Thanks.
> [...]
