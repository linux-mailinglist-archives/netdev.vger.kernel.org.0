Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A26B124737
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 13:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfLRMsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 07:48:40 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33432 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfLRMsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 07:48:39 -0500
Received: by mail-qk1-f196.google.com with SMTP id d71so1795239qkc.0;
        Wed, 18 Dec 2019 04:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=n1ddPvWwZm6fl8YSuEA/PShI4foiGmEjqc7a4+cXB80=;
        b=Saxg/P0nkIl0ZAd0OgTknPPTmM3hShr8c4rufo9VP2oFG0WxPQ7/eT8W09gMAW3MMW
         8KiiGLDDjs/A8LqjTP/QMgD4vAtZBJybXtSDopoOUiJOsiqEN/sx4a8hD47CzZoKUk9T
         2CktMd6pAFQmSo7+DuE+zNilC25RfVli79aXVw7IFm0IvyDB08x6KIOxARpOtc0aPzCU
         vXCBv6SnT8VkXXXOmK1GCKBs5Nqefrpj0K4c4mixPl5O2LhZZCUXzk5SfHjIDz1bQNuC
         NNZR4IMkqTXwQH1OPYxxZ2xxZWshgg8o5caUl6oH5CRnYEoVW95O45LZOYJL2Bj7Zbak
         U1uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=n1ddPvWwZm6fl8YSuEA/PShI4foiGmEjqc7a4+cXB80=;
        b=qhuUKWWtoybm+HgMs98ye/i5WtUwRkBW87MPogtVPwNL15RAXnsxGH6FJsCPK98Mcb
         mFfuyZhmgVlkbwoetTF6CrRtWfV0CDP8G4o5gWKZ+kd5wOEXriHcgipB14zu7MLUtfmh
         uUFsFwfpAbvTh3OxSSamk7BpIDXQJsfjsM6P56JI4DXu6kAZQ5CrQJCMN7HUwFS115yE
         3eMo41dHLPXqi3h+4GQG2rPTx100vMEnY0GQDDzdfIKm43jQKqY7LaNyrTMKR5JrB97g
         yLW32oZpOtnRnlNCyaovJ5ufaEdUu7NDBvqZoP10AsXt/NM3jUWLSADRp/66AJu3tz9x
         Gi8g==
X-Gm-Message-State: APjAAAUjjDsBucCD4xqFhVKrRTM1f4Uhra4CBB8aUlfwv3JS8n43O4Rg
        NYmXiTmhnl0uJQf9QbLnpEJ8Hk59rKBelkcq38I=
X-Google-Smtp-Source: APXvYqyy5VFbba2QIkL+LtF89hqhNcIlgOk35us8mHRXmnIit67/Jhx5rXTQOaZQAFg/Nuzxv+EhSHvMclLUef6PBfo=
X-Received: by 2002:a05:620a:a5c:: with SMTP id j28mr2251759qka.218.1576673318525;
 Wed, 18 Dec 2019 04:48:38 -0800 (PST)
MIME-Version: 1.0
References: <20191218105400.2895-1-bjorn.topel@gmail.com> <20191218121132.4023f4f1@carbon>
 <CAJ+HfNgKsPN7V9r=N=hDoVb23-nk3q=y+Nv4jB3koPw0+4Zw9A@mail.gmail.com>
 <20191218130346.1a346606@carbon> <CAJ+HfNi+hAKY+yyW=p+xzbc=0AGu4DcmyTBGmnJFBjQnC7Nb4Q@mail.gmail.com>
 <20191218134001.319349bc@carbon>
In-Reply-To: <20191218134001.319349bc@carbon>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 18 Dec 2019 13:48:27 +0100
Message-ID: <CAJ+HfNh_GyhCr+yLHG_0UU_=6bsBqbjDqoMNTxU40SvZ=MvJJw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/8] Simplify xdp_do_redirect_map()/xdp_do_flush_map()
 and XDP maps
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Dec 2019 at 13:40, Jesper Dangaard Brouer <brouer@redhat.com> wr=
ote:
>
> On Wed, 18 Dec 2019 13:18:10 +0100
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
>
> > On Wed, 18 Dec 2019 at 13:04, Jesper Dangaard Brouer <brouer@redhat.com=
> wrote:
> > >
> > > On Wed, 18 Dec 2019 12:39:53 +0100
> > > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
> > >
> > > > On Wed, 18 Dec 2019 at 12:11, Jesper Dangaard Brouer <brouer@redhat=
.com> wrote:
> > > > >
> > > > > On Wed, 18 Dec 2019 11:53:52 +0100
> > > > > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
> > > > >
> > > > > >   $ sudo ./xdp_redirect_cpu --dev enp134s0f0 --cpu 22 xdp_cpu_m=
ap0
> > > > > >
> > > > > >   Running XDP/eBPF prog_name:xdp_cpu_map5_lb_hash_ip_pairs
> > > > > >   XDP-cpumap      CPU:to  pps            drop-pps    extra-info
> > > > > >   XDP-RX          20      7723038        0           0
> > > > > >   XDP-RX          total   7723038        0
> > > > > >   cpumap_kthread  total   0              0           0
> > > > > >   redirect_err    total   0              0
> > > > > >   xdp_exception   total   0              0
> > > > >
> > > > > Hmm... I'm missing some counters on the kthread side.
> > > > >
> > > >
> > > > Oh? Any ideas why? I just ran the upstream sample straight off.
> > >
> > > Looks like it happened in commit: bbaf6029c49c ("samples/bpf: Convert
> > > XDP samples to libbpf usage") (Cc Maciej).
> > >
> > > The old bpf_load.c will auto attach the tracepoints... for and libbpf
> > > you have to be explicit about it.
> > >
> > > Can I ask you to also run a test with --stress-mode for
> > > ./xdp_redirect_cpu, to flush out any potential RCU race-conditions
> > > (don't provide output, this is just a robustness test).
> > >
> >
> > Sure! Other than that, does the command line above make sense? I'm
> > blasting UDP packets to core 20, and the idea was to re-route them to
> > 22.
>
> Yes, and I love that you are using CPUMAP xdp_redirect_cpu as a test.
>
> Explaining what is doing on (so you can say if this is what you wanted
> to test):
>

I wanted to see whether one could receive (Rx + bpf_redirect_map)
more with the change. I figured out that at least bpf_redirect_map was
correctly executed, and that the numbers went up. :-P

> The "XDP-RX" number is the raw XDP redirect number, but the remote CPU,
> where the network stack is started, cannot operate at 7.7Mpps.  Which the
> lacking tracepoint numbers should have shown. You still can observe
> results via nstat, e.g.:
>
>  # nstat -n && sleep 1 && nstat
>
> On the remote CPU 22, the SKB will be constructed, and likely dropped
> due overloading network stack and due to not having an UDP listen port.
>
> I sometimes use:
>  # iptables -t raw -I PREROUTING -p udp --dport 9 -j DROP
> To drop the UDP packets in a earlier and consistent stage.
>
> The CPUMAP have carefully been designed to avoid that a "producer" can
> be slowed down by memory operations done by the "consumer", this is
> mostly achieved via ptr_ring and careful bulking (cache-lines).  As
> your driver i40e doesn't have 'page_pool', then you are not affected by
> the return channel.
>
> Funny test/details: i40e uses a refcnt recycle scheme, based off the
> size of the RX-ring, thus it is affected by a longer outstanding queue.
> The CPUMAP have an intermediate queue, that will be full in this
> overload setting.  Try to increase or decrease the parameter --qsize
> (remember to place it as first argument), and see if this was the
> limiting factor for your XDP-RX number.
>

Thanks for the elaborate description!

(Maybe it's time for samples/bpf manpages? ;-))


Bj=C3=B6rn
