Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 388FB25473
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 17:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbfEUPsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 11:48:11 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:46084 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbfEUPsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 11:48:11 -0400
Received: by mail-oi1-f196.google.com with SMTP id 203so13133249oid.13
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 08:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gzspr9L6T5PD32rmyed/l1iwW4W0/PWFdz4O0Jcggp0=;
        b=YsrbMq6yJk8H4ooSqqE4k1VZf4dJgsidPK/daSASqZWoKQYcQ3g3yaUqG928XzKg8M
         ryowsw8iFrXotpjjdOojCEi/CKsx5WK4SKzSEU7luXDsNSbdoljuYe2bWx8izkiPYWNw
         j+E5BGgz/K/yNKyLXsgpIV1L1lY2ndaRZr1ys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gzspr9L6T5PD32rmyed/l1iwW4W0/PWFdz4O0Jcggp0=;
        b=RW0AHF8VGTVEkUChcuS4xzEI2L2VZ9VkbRzVfAecUPhY8Aj1uH4mJCOVWumrezftfK
         eqf0Yq1+eoee3wG60xWDOz4Jyrl25Hw1NVS7lPH6l3CskMgwLJOZkJXYvVy3Z5Fak7er
         Wj/LpCfk0hSwaObE8sihNmezmIpskmNGEeQb6XhQBcM1CPjiiqTNcZ1swLN5fzd/X+es
         q0qow9P2eJ4d4/h8pxak0LOSB9DJbseQwnycpf04DECF1wGr0MLiq2lyc7Bu1pCmRrYj
         aT/i8RH9VJXZNzQNDaPaGP12Fu+9oGFcrpUPnvy5nuB2zMAVo7HhOI0mgORUvHTzJi4e
         fA9A==
X-Gm-Message-State: APjAAAXtsC1dLsoHYoIgVtuy99skl/zxP3oT4uw42EHf1uA3NQmaaJqB
        HJsp7SQT/paa4xOu50PQwsurvgi05dKpcnjLGtFlCA==
X-Google-Smtp-Source: APXvYqynlZMKZjWWCOsHl/WgDje+zRaSbHBlfJDUjwD6PTBDPwzv/C8TxIfRItHXVqCDR06KiE+F5keg7AUDz6lkHQg=
X-Received: by 2002:aca:f0f:: with SMTP id 15mr2438283oip.78.1558453690173;
 Tue, 21 May 2019 08:48:10 -0700 (PDT)
MIME-Version: 1.0
References: <CACAyw98+qycmpQzKupquhkxbvWK4OFyDuuLMBNROnfWMZxUWeA@mail.gmail.com>
 <CADa=RyyuAOupK7LOydQiNi6tx2ELOgD+bdu+DHh3xF0dDxw_gw@mail.gmail.com>
 <CACAyw9_EGRob4VG0-G4PN9QS_xB5GoDMBB6mPXR-WcPnrFCuLg@mail.gmail.com>
 <20190516203325.uhg7c5sr45od7lzm@ast-mbp> <CAGUcTrqnrE+9BGsuc3sf_DpzsD01wP6h3PbK3-u6hk=6wM0zGg@mail.gmail.com>
In-Reply-To: <CAGUcTrqnrE+9BGsuc3sf_DpzsD01wP6h3PbK3-u6hk=6wM0zGg@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 21 May 2019 16:47:58 +0100
Message-ID: <CACAyw9-ijc1o1QOnQD=ukr-skswxe+4mDVKdX58z6AkTrEpOuA@mail.gmail.com>
Subject: Re: RFC: Fixing SK_REUSEPORT from sk_lookup_* helpers
To:     Nitin Hande <nitin.hande@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Joe Stringer <joe@isovalent.com>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 May 2019 at 00:38, Nitin Hande <nitin.hande@gmail.com> wrote:
>
> On Thu, May 16, 2019 at 2:57 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, May 16, 2019 at 09:41:34AM +0100, Lorenz Bauer wrote:
> > > On Wed, 15 May 2019 at 18:16, Joe Stringer <joe@isovalent.com> wrote:
> > > >
> > > > On Wed, May 15, 2019 at 8:11 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > > >
> > > > > In the BPF-based TPROXY session with Joe Stringer [1], I mentioned
> > > > > that the sk_lookup_* helpers currently return inconsistent results if
> > > > > SK_REUSEPORT programs are in play.
> > > > >
> > > > > SK_REUSEPORT programs are a hook point in inet_lookup. They get access
> > > > > to the full packet
> > > > > that triggered the look up. To support this, inet_lookup gained a new
> > > > > skb argument to provide such context. If skb is NULL, the SK_REUSEPORT
> > > > > program is skipped and instead the socket is selected by its hash.
> > > > >
> > > > > The first problem is that not all callers to inet_lookup from BPF have
> > > > > an skb, e.g. XDP. This means that a look up from XDP gives an
> > > > > incorrect result. For now that is not a huge problem. However, once we
> > > > > get sk_assign as proposed by Joe, we can end up circumventing
> > > > > SK_REUSEPORT.
> > > >
> > > > To clarify a bit, the reason this is a problem is that a
> > > > straightforward implementation may just consider passing the skb
> > > > context into the sk_lookup_*() and through to the inet_lookup() so
> > > > that it would run the SK_REUSEPORT BPF program for socket selection on
> > > > the skb when the packet-path BPF program performs the socket lookup.
> > > > However, as this paragraph describes, the skb context is not always
> > > > available.
> > > >
> > > > > At the conference, someone suggested using a similar approach to the
> > > > > work done on the flow dissector by Stanislav: create a dedicated
> > > > > context sk_reuseport which can either take an skb or a plain pointer.
> > > > > Patch up load_bytes to deal with both. Pass the context to
> > > > > inet_lookup.
> > > > >
> > > > > This is when we hit the second problem: using the skb or XDP context
> > > > > directly is incorrect, because it assumes that the relevant protocol
> > > > > headers are at the start of the buffer. In our use case, the correct
> > > > > headers are at an offset since we're inspecting encapsulated packets.
> > > > >
> > > > > The best solution I've come up with is to steal 17 bits from the flags
> > > > > argument to sk_lookup_*, 1 bit for BPF_F_HEADERS_AT_OFFSET, 16bit for
> > > > > the offset itself.
> > > >
> > > > FYI there's also the upper 32 bits of the netns_id parameter, another
> > > > option would be to steal 16 bits from there.
> > >
> > > Or len, which is only 16 bits realistically. The offset doesn't really fit into
> > > either of them very well, using flags seemed the cleanest to me.
> > > Is there some best practice around this?
> > >
> > > >
> > > > > Thoughts?
> > > >
> > > > Internally with skbs, we use `skb_pull()` to manage header offsets,
> > > > could we do something similar with `bpf_xdp_adjust_head()` prior to
> > > > the call to `bpf_sk_lookup_*()`?
> > >
> > > That would only work if it retained the contents of the skipped
> > > buffer, and if there
> > > was a way to undo the adjustment later. We're doing the sk_lookup to
> > > decide whether to
> > > accept or forward the packet, so at the point of the call we might still need
> > > that data. Is that feasible with skb / XDP ctx?
> >
> > While discussing the solution for reuseport I propose to use
> > progs/test_select_reuseport_kern.c as an example of realistic program.
> > It reads tcp/udp header directly via ctx->data or via bpf_skb_load_bytes()
> > including payload after the header.
> > It also uses bpf_skb_load_bytes_relative() to fetch IP.
> > I think if we're fixing the sk_lookup from XDP the above program
> > would need to work.
> >
> > And I think we can make it work by adding new requirement that
> > 'struct bpf_sock_tuple *' argument to bpf_sk_lookup_* must be
> > a pointer to the packet and not a pointer to bpf program stack.
> > Then helper can construct a fake skb and assign
> > fake_skb->data = &bpf_sock_tuple_arg.sport
> > It can check that struct bpf_sock_tuple * pointer is within 100-ish bytes
> > from xdp->data and within xdp->data_end
> > This way the reuseport program's assumption that ctx->data points to tcp/udp
> > will be preserved and it can access it all including payload.
> >
> > This approach doesn't need to mess with xdp_adjust_head and adjust uapi to pass length.
> > Existing progs/test_sk_lookup_kern.c will magically start working with XDP
> > even when reuseport prog is attached.
> > Thoughts?
>
> I like this approach. A fake_skb approach will normalize the bpf_sk_lookup_*()
> API peering into the kernel API between TC and XDP invocation. Just one question
> that comes, I remember one of the comments I received during my XDP commit
> was the stateless nature of XDP services and providing a fake_skb may bring
> some potential side-effects to the desire of statelessness. Is that
> still a possibility?
> How do we guard against it?

To follow up on this, I'm also not sure how to tackle a "fake skb". If
I remember this
came up during the flow dissector series, and wasn't met with
enthusiasm. Granted,
replacing the skb argument to the lookup functions seems even harder, so maybe
this is the lesser evil?

>
> Thanks
> Nitin
>
> >



-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
