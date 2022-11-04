Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A784761A4D3
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 23:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiKDWtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 18:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiKDWt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 18:49:28 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B1A862FC;
        Fri,  4 Nov 2022 15:43:57 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id k2so16881409ejr.2;
        Fri, 04 Nov 2022 15:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Rz+uJhq6MzU/GpngjVCSms293gxGW6YlyI6hslqJJXY=;
        b=TTSC1PYsIl4wNygBOjEUlZux3jycvLQZX0WHn6DVKJn/Bn+ZesGrvgIXyj+0/ouW/k
         h+wn0Cygd7/4L02ScnxFa3Jb67ww5ZmXvVAMflPFlv7nTf5Whhb66Ykyk7IWxFQSVQmO
         GROHmfOl0tHjh3wYbOE0M8nW/ZaDmzNzm3sDGSvq/8y0aBb5LT8XGwUHsBJwX3fKoLKF
         y/f+vkNDtMPsLJDISf0UkF9MSxgt3+Fffs7FX0xox4CNCxREk9/WX5bT1RMDmQifKkIe
         ckFoAW0z2iUajI+YynPu9iCasmv6pxkObEVy1j/jGQBUeN1ECw3xa0SosZZBwDnp3poT
         ia/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rz+uJhq6MzU/GpngjVCSms293gxGW6YlyI6hslqJJXY=;
        b=lnGH4UG//S7a6y73TYU7TViqjf+L51CLjFcKfqZnW9YaTo0SqQOpwy+QmEb/dEvhLm
         x7Ul0flXIbnWy2Woxqr3CUsCo+BPhJWPNVYh+G2Kjz5qorfChDVBq1zujXdjoCTIt5UO
         nxcTarTjiCKOlc38xskTgPpmFQxi9n8WkJyjkJTGuPiU4njPcqhZ813HRtI+gRa5pIji
         KWCxkxuN04iBxcJF8btzekHbTomdYanhqh5ZLzdh45BswUEKad2N5e0O8m8BK8VmjP0z
         OcbaLSCfl1sxFoJqNVf+DJ9YGqcKBV4kI2a3jFDtmdC0W1qq8u4Qj9Yp+KVdJKcNhF28
         rO+Q==
X-Gm-Message-State: ACrzQf0nqN21VDQXXBT04ztsH+hha1XxKI1o3IOF0arZvumvQCHWdGY3
        GY82H3vBNyMdLNxCNH+W6zlo7Y8Y6DINMYzb3EU=
X-Google-Smtp-Source: AMsMyM6m1JxGLOo6osuiEcTeO/CWp+a/VY4LBfYEMkKC6S8wslZ+0LSSDVoSUCw6MkSfeqGk5g8o1QthY79rE/UmA4k=
X-Received: by 2002:a17:907:8a24:b0:795:bb7d:643b with SMTP id
 sc36-20020a1709078a2400b00795bb7d643bmr37412552ejc.115.1667601836086; Fri, 04
 Nov 2022 15:43:56 -0700 (PDT)
MIME-Version: 1.0
References: <20221103092118.248600-1-yangjihong1@huawei.com>
 <20221103092118.248600-3-yangjihong1@huawei.com> <Y2OknBtLgqTHSrvy@shell.armlinux.org.uk>
 <CAADnVQ+gX8Xc57K2hSG5ZNfU1RtKBFgEp2yOWq08X68bWjMqsg@mail.gmail.com>
In-Reply-To: <CAADnVQ+gX8Xc57K2hSG5ZNfU1RtKBFgEp2yOWq08X68bWjMqsg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Nov 2022 15:43:44 -0700
Message-ID: <CAEf4BzaJMfCXf_uUgyuWBddyd3qrV7SgpVy-hicuOn87FigMSg@mail.gmail.com>
Subject: Re: [PATCH bpf RESEND 2/4] bpf: Remove size check for sk in
 bpf_skb_is_valid_access for 32-bit architecture
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Yang Jihong <yangjihong1@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shubham Bansal <illusionist.neo@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Delyan Kratunov <delyank@fb.com>,
        Artem Savkov <asavkov@redhat.com>, bpf <bpf@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 3, 2022 at 11:15 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Nov 3, 2022 at 4:23 AM Russell King (Oracle)
> <linux@armlinux.org.uk> wrote:
> >
> > On Thu, Nov 03, 2022 at 05:21:16PM +0800, Yang Jihong wrote:
> > > The error code -EACCES is returned when bpf prog is tested in 32-bit environment,
> > > This is because bpf_object__relocate modifies the instruction to change memory
> > > size to 4 bytes, as shown in the following messages:
> > >
> > > libbpf: prog 'kfunc_call_test1': relo #2: matching candidate #0 <byte_off> [18342] struct __sk_buff.sk (0:30:0 @ offset 168)
> > > libbpf: prog 'kfunc_call_test1': relo #2: patched insn #1 (LDX/ST/STX) off 168 -> 168
> > > libbpf: prog 'kfunc_call_test1': relo #2: patched insn #1 (LDX/ST/STX) mem_sz 8 -> 4
> > >
> > > As a result, the bpf_skb_is_valid_access check fails. For 32-bit architecture,
> > > unnecessary checks need to be deleted.
> >
> > Isn't the purpose of this check to ensure that the entire pointer is
> > written, and BPF can't write half of it?
> >
> >
> > >       case offsetof(struct __sk_buff, sk):
> > > -             if (type == BPF_WRITE || size != sizeof(__u64))
> > > -                     return false;
> >
> > Wouldn't "(size != sizeof(struct bpf_sock *) && size != sizeof(__u64))"
> > be more appropriate here, so 32-bit can only write the 32-bit pointer
> > or the full 64-bit value, and 64-bit can only write the 64-bit pointer?
> > Or is there a reason not to? bpf folk?
>
> You're correct. The patch is completely wrong.
> The bug is elsewhere.

So I looked at this a bit (and replied to the old version of this
patch). What happens in the kernel is that we expect 64-bit load but
rewrite it to 32-bit load on 32-bit architectures (because we just use
sizeof(struct sk_buff, sk) which is 4 bytes on 32-bit arch.

The problem here is that libbpf adjusts such pointer accesses from
8-byte read to 4-byte reads for preserve_access_index (because libbpf
sees that pointer is really 4 byte long), which is what we actually
want in the general case. Here the assumption was made before CO-RE
that __sk_buff is a stable (and fake) UAPI and the correct BPF program
will access sk as a 64-bit pointer because BPF-side pointers always
appear as 64-bit.

But from a correctness standpoint I think it should be fine to enable
both 32- and 64-bit loads for such pointers in __sk_buff for 32-bit
host arch. This will work well with CO-RE and will be correctly
rewritten to 32-bit or 64-bit accesses, depending on host
architecture.

We should still reject 32-bit load on 64-bit host arch, though.
