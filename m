Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85A1620FA0
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 22:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbfEPUdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 16:33:31 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:44283 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbfEPUdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 16:33:31 -0400
Received: by mail-pg1-f179.google.com with SMTP id z16so2102253pgv.11;
        Thu, 16 May 2019 13:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZheUGwXBNVLqlL//FsUplo6XwqwZRJY+3Dp+4i44uSM=;
        b=ctrN9JyIetnM5gr5rJzwThYzDNSLMgbeEZAJlyHb+vypjnqTdLhPk21arwiW9lkwpo
         XAyuPNKlXiqwR4NeKjsrofg5w23UXZKebrnwxMSCqKYorhs2cT5JniMFaFFT644pyhLJ
         sX7eCrGNGwZNzmiahP3KCsGIix+GnJNPw6xexb3wsFyWDhAFEJfm1WKpkhnobmpTkL6m
         m0arjMML81PJ+QJ1d7ub0LFj/0TvzsIVCsalQEGg348+ZRAILmr7iFihKNtojeju+/eS
         C7+pU4BoQNW25pBRMyGtj1h97Xr12BXU4gj5gqR1E8LMtWEfY5xB8NyLdCuHAAKGS5yg
         FFkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZheUGwXBNVLqlL//FsUplo6XwqwZRJY+3Dp+4i44uSM=;
        b=Noq3dHIkwEbrrg1HPiX9o8UknWmjmDmMDTMcgYcmlByGovuFCj2e1CIEq147cCQDUa
         uGLen/k3/UkudXXSm2TCz0QiUIO8jTGdbFYH60LCPyf3LRiWsn/7JEiYpqiwlliqIXC8
         +BenLju/waZqCE8kjFF4JEHhsQuyJJasWVljDZVGoPPuBZZ0A1UjrV3aCcYMANzaHeXy
         Wvudym/+862eBkvoWTUyV8LQrCV1aw1IzE9n/fsxw8KIskMoQdn5UGj1VSEtSN5j+iIg
         I6C2ZzuKpIV23Sqa5mdqmn9Kct6u9BG59bzX0ez2V43zVXDYKoSKBC79LSlKrifXy1aS
         eXTg==
X-Gm-Message-State: APjAAAVBUU7Sfl9Lj1NepXSgTU33gEqVg6fdiLQE2rhuvEr8RqdaYcUb
        Zo/X3rWVf9FH6UMl1psNK78=
X-Google-Smtp-Source: APXvYqxSDzdZbR0Sk7+BW+Xb4pKVOsys5qz62dyKEeXjmz+CT8c5b/uj/3Py3QMTUNwiVMHgaVE/3Q==
X-Received: by 2002:a63:88c7:: with SMTP id l190mr52545336pgd.244.1558038809883;
        Thu, 16 May 2019 13:33:29 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::1:4894])
        by smtp.gmail.com with ESMTPSA id 194sm2970534pgd.33.2019.05.16.13.33.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 13:33:29 -0700 (PDT)
Date:   Thu, 16 May 2019 13:33:27 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Joe Stringer <joe@isovalent.com>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        kafai@fb.com, daniel@iogearbox.net, edumazet@google.com
Subject: Re: RFC: Fixing SK_REUSEPORT from sk_lookup_* helpers
Message-ID: <20190516203325.uhg7c5sr45od7lzm@ast-mbp>
References: <CACAyw98+qycmpQzKupquhkxbvWK4OFyDuuLMBNROnfWMZxUWeA@mail.gmail.com>
 <CADa=RyyuAOupK7LOydQiNi6tx2ELOgD+bdu+DHh3xF0dDxw_gw@mail.gmail.com>
 <CACAyw9_EGRob4VG0-G4PN9QS_xB5GoDMBB6mPXR-WcPnrFCuLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw9_EGRob4VG0-G4PN9QS_xB5GoDMBB6mPXR-WcPnrFCuLg@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 09:41:34AM +0100, Lorenz Bauer wrote:
> On Wed, 15 May 2019 at 18:16, Joe Stringer <joe@isovalent.com> wrote:
> >
> > On Wed, May 15, 2019 at 8:11 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > >
> > > In the BPF-based TPROXY session with Joe Stringer [1], I mentioned
> > > that the sk_lookup_* helpers currently return inconsistent results if
> > > SK_REUSEPORT programs are in play.
> > >
> > > SK_REUSEPORT programs are a hook point in inet_lookup. They get access
> > > to the full packet
> > > that triggered the look up. To support this, inet_lookup gained a new
> > > skb argument to provide such context. If skb is NULL, the SK_REUSEPORT
> > > program is skipped and instead the socket is selected by its hash.
> > >
> > > The first problem is that not all callers to inet_lookup from BPF have
> > > an skb, e.g. XDP. This means that a look up from XDP gives an
> > > incorrect result. For now that is not a huge problem. However, once we
> > > get sk_assign as proposed by Joe, we can end up circumventing
> > > SK_REUSEPORT.
> >
> > To clarify a bit, the reason this is a problem is that a
> > straightforward implementation may just consider passing the skb
> > context into the sk_lookup_*() and through to the inet_lookup() so
> > that it would run the SK_REUSEPORT BPF program for socket selection on
> > the skb when the packet-path BPF program performs the socket lookup.
> > However, as this paragraph describes, the skb context is not always
> > available.
> >
> > > At the conference, someone suggested using a similar approach to the
> > > work done on the flow dissector by Stanislav: create a dedicated
> > > context sk_reuseport which can either take an skb or a plain pointer.
> > > Patch up load_bytes to deal with both. Pass the context to
> > > inet_lookup.
> > >
> > > This is when we hit the second problem: using the skb or XDP context
> > > directly is incorrect, because it assumes that the relevant protocol
> > > headers are at the start of the buffer. In our use case, the correct
> > > headers are at an offset since we're inspecting encapsulated packets.
> > >
> > > The best solution I've come up with is to steal 17 bits from the flags
> > > argument to sk_lookup_*, 1 bit for BPF_F_HEADERS_AT_OFFSET, 16bit for
> > > the offset itself.
> >
> > FYI there's also the upper 32 bits of the netns_id parameter, another
> > option would be to steal 16 bits from there.
> 
> Or len, which is only 16 bits realistically. The offset doesn't really fit into
> either of them very well, using flags seemed the cleanest to me.
> Is there some best practice around this?
> 
> >
> > > Thoughts?
> >
> > Internally with skbs, we use `skb_pull()` to manage header offsets,
> > could we do something similar with `bpf_xdp_adjust_head()` prior to
> > the call to `bpf_sk_lookup_*()`?
> 
> That would only work if it retained the contents of the skipped
> buffer, and if there
> was a way to undo the adjustment later. We're doing the sk_lookup to
> decide whether to
> accept or forward the packet, so at the point of the call we might still need
> that data. Is that feasible with skb / XDP ctx?

While discussing the solution for reuseport I propose to use
progs/test_select_reuseport_kern.c as an example of realistic program.
It reads tcp/udp header directly via ctx->data or via bpf_skb_load_bytes()
including payload after the header.
It also uses bpf_skb_load_bytes_relative() to fetch IP.
I think if we're fixing the sk_lookup from XDP the above program
would need to work.

And I think we can make it work by adding new requirement that
'struct bpf_sock_tuple *' argument to bpf_sk_lookup_* must be
a pointer to the packet and not a pointer to bpf program stack.
Then helper can construct a fake skb and assign
fake_skb->data = &bpf_sock_tuple_arg.sport
It can check that struct bpf_sock_tuple * pointer is within 100-ish bytes
from xdp->data and within xdp->data_end
This way the reuseport program's assumption that ctx->data points to tcp/udp
will be preserved and it can access it all including payload.

This approach doesn't need to mess with xdp_adjust_head and adjust uapi to pass length.
Existing progs/test_sk_lookup_kern.c will magically start working with XDP
even when reuseport prog is attached.
Thoughts?

