Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5AC80F4D
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 01:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfHDXEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 19:04:45 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36727 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfHDXEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 19:04:44 -0400
Received: by mail-io1-f67.google.com with SMTP id o9so59937497iom.3;
        Sun, 04 Aug 2019 16:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XLF1bdQejMYsSI1lp36G596c75wG4ArB4Q8eucLlyAU=;
        b=X1lrsvm1IdJ07BUfeRIka6tNdPqnWLp2dO32k4DdOCOt186Hxe/VYcRJSmTFqBlen0
         L/x6aJugs8L+6QMP/QjYu35Od+ztsMyKGZZfli9ZZmkgMJa+Z7rx4KfNDKqRITCHqStW
         HeGo46hLwSeHb1BoVJUKB6xmU63KZ5DHT6jLT6u1DRIzkoU8vkXC7JN8FQKFDHbsnDNl
         mHWwJ4hZAFP2YzZ9+T0Bf4SGbhK6PmVuZFwytf/ZyzvM12G8djrjXjOgy2rEHoLi4ne2
         8oUUrLXPrXlJdCqV7l7gkFWq4Bb+SapagU1zn1MTa4OHeR/KZS957MRB86Yli0cxGBdS
         JVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XLF1bdQejMYsSI1lp36G596c75wG4ArB4Q8eucLlyAU=;
        b=YX9MmvlKuOdrbYNNHeFZVJqbHVWJd87C7BZEHUHgaS6t1IX/4tDJ+JBxlsD2UERhc4
         Un3/OZtQQwDCTLk2XVRfLfTWp4JpJ94ntF62Guj+6Dj7Ilp7vtu4vFA9DTKP3jfLE0Sd
         UVQpEgrDeqScVN6BUzPLdwZXLIDFPhnJnvgthVtncITTGUZpDzXEFl4j/79uLEJsEP6w
         55jv4gYQLM50q/McJPwDEKQYpyMDBVr9bsWvv4pEAOxmtHL2B6Gjtc8H0SvSJOHx0TXG
         NQ/IB9U2q/FT95PB0jBXVb58ekg8clkP/SieO7t5zd9+K69EbQ0ggwBVxKUGwnjTvbf7
         uAkg==
X-Gm-Message-State: APjAAAVfGZ6IYii9kh4vLnBm99mJiG518KvRMBVmqL7pJfkqqh3oSIcZ
        4cxy3zX1b8P7ki0nLt+oqRiPO5a1XFMnOPzLp5s=
X-Google-Smtp-Source: APXvYqyscY0wdDumKVJ06CHYUi7fBwmUEAIzYw8yR/gCtad3Kq3EyzdKRkwC8Cw+S0XbXnz8RaKbReoSyx9bqaQPW74=
X-Received: by 2002:a05:6638:81:: with SMTP id v1mr23010847jao.72.1564959883226;
 Sun, 04 Aug 2019 16:04:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190803044320.5530-1-farid.m.zakaria@gmail.com>
 <20190803044320.5530-2-farid.m.zakaria@gmail.com> <CAH3MdRXTEN-Ra+61QA37hM2mkHx99K5NM7f+H6d8Em-bxvaenw@mail.gmail.com>
 <CACCo2jmcYAfY8zHJiT7NCb-Ct7Wguk9XHRc8QmZa7V3eJy0WTg@mail.gmail.com> <CACCo2j=RAua1E0d6E+tVoOG=q1sSLuZpLqx32dY4mmhYNtDzvg@mail.gmail.com>
In-Reply-To: <CACCo2j=RAua1E0d6E+tVoOG=q1sSLuZpLqx32dY4mmhYNtDzvg@mail.gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Sun, 4 Aug 2019 16:04:06 -0700
Message-ID: <CAH3MdRXxDLVC6FWDkiyb8NMLWqacBoFrFpBB7+H+UKCim5yEoA@mail.gmail.com>
Subject: Re: [PATCH 1/1] bpf: introduce new helper udp_flow_src_port
To:     Farid Zakaria <farid.m.zakaria@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 4, 2019 at 1:43 PM Farid Zakaria <farid.m.zakaria@gmail.com> wrote:
>
> * re-sending as I've sent previously as HTML ... sorry *
>
> First off, thank you for taking the time to review this patch.

You are welcome. Also, just let you know typically people do
interleaved reply instead of
top reply.

>
> It's not clear to me the backport you'd like for libbpf, I have been following
> the documentation outlined in
> https://www.kernel.org/doc/html/latest/bpf/index.html
> I will hold off on changes to this patch as you've asked for it going forward.

The document at the above link does not specify how patches are structured.
What I suggest is what people typically do here for each review and cherry-pick
in different cases. There are no functionality changes in your patch. Just
break it into three commits instead one. The cover letter is still needed.
There are more examples in here:
https://lore.kernel.org/bpf/

>
> This patch is inspired by a MPLSoUDP (https://tools.ietf.org/html/rfc7510)]
> kernel module that was ported to eBPF -- our implementation is slightly
> modified for our custom use case.
>
> The Linux kernel provides a single abstraction for the src port for
> UDP tunneling
> via udp_flow_src_port. If it's improved eBPF filters would benefit if
> the call is the same.
>
> Exposing this function to eBPF programs would maintain feature parity
> with other kernel
> tunneling implementations.

Thanks for providing the detailed information above. Such use case
information should be in the commit message to answer the question
like why we need this feature.

If I understand correctly, you try to do MPLS over UDP in bpf program,
right? Your want to the UDP source port to be the same as the one
computed by kernel? Approximation is possible but it may introduce
different behavior at routing side (ECMP) and you do not want that to happen.

Your test case only tries to modify a tcp packet source port and checks it
is indeed changed. It would be good if your test case can be a little bit
closer to your use case.

You can submit v2 of the patch set with 3 commits, more detailed
commit messages and possibly modified test cases, so we can
continue to review.

>
> Farid Zakaria
>
> Farid Zakaria
>
>
>
> On Sun, Aug 4, 2019 at 1:41 PM Farid Zakaria <farid.m.zakaria@gmail.com> wrote:
> >
> > First off, thank you for taking the time to review this patch.
> >
> > It's not clear to me the backport you'd like for libbpf, I have been following
> > the documentation outlined in https://www.kernel.org/doc/html/latest/bpf/index.html
> > I will hold off on changes to this patch as you've asked for it going forward.
> >
> > This patch is inspired by a MPLSoUDP (https://tools.ietf.org/html/rfc7510)]
> > kernel module that was ported to eBPF -- our implementation is slightly
> > modified for our custom use case.
> >
> > The Linux kernel provides a single abstraction for the src port for UDP tunneling
> > via udp_flow_src_port. If it's improved eBPF filters would benefit if the call is the same.
> >
> > Exposing this function to eBPF programs would maintain feature parity with other kernel
> > tunneling implementations.
> >
> > Cheers,
> > Farid Zakaria
> >
> >
> >
> > On Sat, Aug 3, 2019 at 11:52 PM Y Song <ys114321@gmail.com> wrote:
> >>
> >> On Sat, Aug 3, 2019 at 8:29 PM Farid Zakaria <farid.m.zakaria@gmail.com> wrote:
> >> >
> >> > Foo over UDP uses UDP encapsulation to add additional entropy
> >> > into the packets so that they get beter distribution across EMCP
> >> > routes.
> >> >
> >> > Expose udp_flow_src_port as a bpf helper so that tunnel filters
> >> > can benefit from the helper.
> >> >
> >> > Signed-off-by: Farid Zakaria <farid.m.zakaria@gmail.com>
> >> > ---
> >> >  include/uapi/linux/bpf.h                      | 21 +++++++--
> >> >  net/core/filter.c                             | 20 ++++++++
> >> >  tools/include/uapi/linux/bpf.h                | 21 +++++++--
> >> >  tools/testing/selftests/bpf/bpf_helpers.h     |  2 +
> >> >  .../bpf/prog_tests/udp_flow_src_port.c        | 28 +++++++++++
> >> >  .../bpf/progs/test_udp_flow_src_port_kern.c   | 47 +++++++++++++++++++
> >> >  6 files changed, 131 insertions(+), 8 deletions(-)
> >> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/udp_flow_src_port.c
> >> >  create mode 100644 tools/testing/selftests/bpf/progs/test_udp_flow_src_port_kern.c
> >>
> >> First, for each review, backport and sync with libbpf repo, in the future,
> >> could you break the patch to two patches?
> >>    1. kernel changes (net/core/filter.c, include/uapi/linux/bpf.h)
> >>    2. tools/include/uapi/linux/bpf.h
> >>    3. tools/testing/ changes
> >>
> >> Second, could you explain why existing __sk_buff->hash not enough?
> >> there are corner cases where if __sk_buff->hash is 0 and the kernel did some
> >> additional hashing, but maybe you can approximate in bpf program?
> >> For case, min >= max, I suppose you can get min/max port values
> >> from the user space for a particular net device and then calculate
> >> the hash in the bpf program?
> >> What I want to know if how much accuracy you will lose if you just
> >> use __sk_buff->hash and do approximation in bpf program.
> >>
> >> >
> >> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> >> > index 4393bd4b2419..90e814153dec 100644
> >> > --- a/include/uapi/linux/bpf.h
> >> > +++ b/include/uapi/linux/bpf.h
> >> > @@ -2545,9 +2545,21 @@ union bpf_attr {
> >> >   *             *th* points to the start of the TCP header, while *th_len*
> >> >   *             contains **sizeof**\ (**struct tcphdr**).
> >> >   *
> >> > - *     Return
> >> > - *             0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
> >> > - *             error otherwise.
> >> > + *  Return
> >> > + *      0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
> >> > + *      error otherwise.
> >> > + *
> >> > + * int bpf_udp_flow_src_port(struct sk_buff *skb, int min, int max, int use_eth)
> >> > + *  Description
> >> > + *      It's common to implement tunnelling inside a UDP protocol to provide
> >> > + *      additional randomness to the packet. The destination port of the UDP
> >> > + *      header indicates the inner packet type whereas the source port is used
> >> > + *      for additional entropy.
> >> > + *
> >> > + *  Return
> >> > + *      An obfuscated hash of the packet that falls within the
> >> > + *      min & max port range.
> >> > + *      If min >= max, the default port range is used
> >> >   *
> >> >   * int bpf_sysctl_get_name(struct bpf_sysctl *ctx, char *buf, size_t buf_len, u64 flags)
> >> >   *     Description
> >> > @@ -2853,7 +2865,8 @@ union bpf_attr {
> >> >         FN(sk_storage_get),             \
> >> >         FN(sk_storage_delete),          \
> >> >         FN(send_signal),                \
> >> > -       FN(tcp_gen_syncookie),
> >> > +       FN(tcp_gen_syncookie),  \
> >> > +       FN(udp_flow_src_port),
> >> >
> >> >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> >> >   * function eBPF program intends to call
> >> > diff --git a/net/core/filter.c b/net/core/filter.c
> >> > index 5a2707918629..fdf0ebb8c2c8 100644
> >> > --- a/net/core/filter.c
> >> > +++ b/net/core/filter.c
> >> > @@ -2341,6 +2341,24 @@ static const struct bpf_func_proto bpf_msg_pull_data_proto = {
> >> >         .arg4_type      = ARG_ANYTHING,
> >> >  };
> >> >
> >> > +BPF_CALL_4(bpf_udp_flow_src_port, struct sk_buff *, skb, int, min,
> >> > +          int, max, int, use_eth)
> >> > +{
> >> > +       struct net *net = dev_net(skb->dev);
> >> > +
> >> > +       return udp_flow_src_port(net, skb, min, max, use_eth);
> >> > +}
> >> > +
> >> [...]
