Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F14521112
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 01:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfEPXie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 19:38:34 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37637 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfEPXid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 19:38:33 -0400
Received: by mail-lj1-f196.google.com with SMTP id h19so4656194ljj.4;
        Thu, 16 May 2019 16:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GUuOEz8juDhOu95jUkjd8QJYFBh95YYaplr9Vdt6ZIM=;
        b=lmWel7zW6gqNP5GswizjIQkzodJ3rNjuaqA41HGNaml08R7YlShSH+9s13TkX6nwzM
         nNv+wLrFxXAg2FAeEFk+hzTxYKJQsL7MVUPq37+DSQz4P0VKISxQlhtc9XsxLsuifiL3
         emozHvVVi5Y/zkKrVFMcrpsbHFnNItSBIZJbUSAmkxTyCIKhM65rC6wqwYtJnsDC1gW9
         gvYCHncY2Ohfa+vRn7wSkerVKnasnM2XJQlhQOFX+xDM53pbUeBBiuFVpQMMbtyQ+k5T
         mUdaM7CQRtxSSqJabARA833/8rl+GbI5sgA3exoi6hJ0yJ0WRWTdV5LIUIjt/F9TAGJQ
         68Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GUuOEz8juDhOu95jUkjd8QJYFBh95YYaplr9Vdt6ZIM=;
        b=tE0glVkidsNu1TE9/OHX6v6LpcAG0Im71jB8Y7ZuPBB2LgCypI3/VptUC2UhxYJ+EA
         z6tMp0bzVp08F777YuJaXJXNtiOcFtWG/TVTeAmTkX4wyLQccq4PpE4yC6rFX3wUc9nx
         /arRUHimMIGmfcQTaWECVO/jDkZerPqXZJ6sOUbcXaaMRFyEd3LEkIMwT91qUps4b7RS
         G2HURC/DRZXB2rMFIN6xFcmgJNb0Gg15bB87pAbHnDD6HbCnGrgw5PDeOdPWhVwQTBVy
         43dnYjoAlyzV4Pihn3szB5MoAWh5Vux4gDHV5zRokcbIbQ1Mt86bg/n6h87VRCAHj87T
         5VNQ==
X-Gm-Message-State: APjAAAXG0TJujIV6X10MCJTPtumf+KXxcmBjVVbByMY2kw7jJzPmr726
        6jF5EkTtRGJK5cC21iQ8ObcGkieBmBjY+X30wvY=
X-Google-Smtp-Source: APXvYqxXmMlh2iVNRCs5zzUm5/yAw1ErxUwNDVzUAz1u2VaNAyrA5KXmcpksiOdFCT+uKAmCPUZ3hLQ+VJqY34yImA4=
X-Received: by 2002:a05:651c:1056:: with SMTP id x22mr5576609ljm.45.1558049910731;
 Thu, 16 May 2019 16:38:30 -0700 (PDT)
MIME-Version: 1.0
References: <CACAyw98+qycmpQzKupquhkxbvWK4OFyDuuLMBNROnfWMZxUWeA@mail.gmail.com>
 <CADa=RyyuAOupK7LOydQiNi6tx2ELOgD+bdu+DHh3xF0dDxw_gw@mail.gmail.com>
 <CACAyw9_EGRob4VG0-G4PN9QS_xB5GoDMBB6mPXR-WcPnrFCuLg@mail.gmail.com> <20190516203325.uhg7c5sr45od7lzm@ast-mbp>
In-Reply-To: <20190516203325.uhg7c5sr45od7lzm@ast-mbp>
From:   Nitin Hande <nitin.hande@gmail.com>
Date:   Thu, 16 May 2019 16:38:19 -0700
Message-ID: <CAGUcTrqnrE+9BGsuc3sf_DpzsD01wP6h3PbK3-u6hk=6wM0zGg@mail.gmail.com>
Subject: Re: RFC: Fixing SK_REUSEPORT from sk_lookup_* helpers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Joe Stringer <joe@isovalent.com>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, edumazet@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 2:57 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, May 16, 2019 at 09:41:34AM +0100, Lorenz Bauer wrote:
> > On Wed, 15 May 2019 at 18:16, Joe Stringer <joe@isovalent.com> wrote:
> > >
> > > On Wed, May 15, 2019 at 8:11 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > >
> > > > In the BPF-based TPROXY session with Joe Stringer [1], I mentioned
> > > > that the sk_lookup_* helpers currently return inconsistent results if
> > > > SK_REUSEPORT programs are in play.
> > > >
> > > > SK_REUSEPORT programs are a hook point in inet_lookup. They get access
> > > > to the full packet
> > > > that triggered the look up. To support this, inet_lookup gained a new
> > > > skb argument to provide such context. If skb is NULL, the SK_REUSEPORT
> > > > program is skipped and instead the socket is selected by its hash.
> > > >
> > > > The first problem is that not all callers to inet_lookup from BPF have
> > > > an skb, e.g. XDP. This means that a look up from XDP gives an
> > > > incorrect result. For now that is not a huge problem. However, once we
> > > > get sk_assign as proposed by Joe, we can end up circumventing
> > > > SK_REUSEPORT.
> > >
> > > To clarify a bit, the reason this is a problem is that a
> > > straightforward implementation may just consider passing the skb
> > > context into the sk_lookup_*() and through to the inet_lookup() so
> > > that it would run the SK_REUSEPORT BPF program for socket selection on
> > > the skb when the packet-path BPF program performs the socket lookup.
> > > However, as this paragraph describes, the skb context is not always
> > > available.
> > >
> > > > At the conference, someone suggested using a similar approach to the
> > > > work done on the flow dissector by Stanislav: create a dedicated
> > > > context sk_reuseport which can either take an skb or a plain pointer.
> > > > Patch up load_bytes to deal with both. Pass the context to
> > > > inet_lookup.
> > > >
> > > > This is when we hit the second problem: using the skb or XDP context
> > > > directly is incorrect, because it assumes that the relevant protocol
> > > > headers are at the start of the buffer. In our use case, the correct
> > > > headers are at an offset since we're inspecting encapsulated packets.
> > > >
> > > > The best solution I've come up with is to steal 17 bits from the flags
> > > > argument to sk_lookup_*, 1 bit for BPF_F_HEADERS_AT_OFFSET, 16bit for
> > > > the offset itself.
> > >
> > > FYI there's also the upper 32 bits of the netns_id parameter, another
> > > option would be to steal 16 bits from there.
> >
> > Or len, which is only 16 bits realistically. The offset doesn't really fit into
> > either of them very well, using flags seemed the cleanest to me.
> > Is there some best practice around this?
> >
> > >
> > > > Thoughts?
> > >
> > > Internally with skbs, we use `skb_pull()` to manage header offsets,
> > > could we do something similar with `bpf_xdp_adjust_head()` prior to
> > > the call to `bpf_sk_lookup_*()`?
> >
> > That would only work if it retained the contents of the skipped
> > buffer, and if there
> > was a way to undo the adjustment later. We're doing the sk_lookup to
> > decide whether to
> > accept or forward the packet, so at the point of the call we might still need
> > that data. Is that feasible with skb / XDP ctx?
>
> While discussing the solution for reuseport I propose to use
> progs/test_select_reuseport_kern.c as an example of realistic program.
> It reads tcp/udp header directly via ctx->data or via bpf_skb_load_bytes()
> including payload after the header.
> It also uses bpf_skb_load_bytes_relative() to fetch IP.
> I think if we're fixing the sk_lookup from XDP the above program
> would need to work.
>
> And I think we can make it work by adding new requirement that
> 'struct bpf_sock_tuple *' argument to bpf_sk_lookup_* must be
> a pointer to the packet and not a pointer to bpf program stack.
> Then helper can construct a fake skb and assign
> fake_skb->data = &bpf_sock_tuple_arg.sport
> It can check that struct bpf_sock_tuple * pointer is within 100-ish bytes
> from xdp->data and within xdp->data_end
> This way the reuseport program's assumption that ctx->data points to tcp/udp
> will be preserved and it can access it all including payload.
>
> This approach doesn't need to mess with xdp_adjust_head and adjust uapi to pass length.
> Existing progs/test_sk_lookup_kern.c will magically start working with XDP
> even when reuseport prog is attached.
> Thoughts?

I like this approach. A fake_skb approach will normalize the bpf_sk_lookup_*()
API peering into the kernel API between TC and XDP invocation. Just one question
that comes, I remember one of the comments I received during my XDP commit
was the stateless nature of XDP services and providing a fake_skb may bring
some potential side-effects to the desire of statelessness. Is that
still a possibility?
How do we guard against it?

Thanks
Nitin

>
