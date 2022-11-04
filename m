Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA61761A5EA
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 00:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiKDXh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 19:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiKDXhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 19:37:55 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0DD26117;
        Fri,  4 Nov 2022 16:37:54 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id f27so17112165eje.1;
        Fri, 04 Nov 2022 16:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=POnyXKH4ESKITkg2I+AemO3Wn3BRnxBoAiqSICQ80nY=;
        b=kUJEPvpQopr0fHeyPQEOvriHCtPtryaSgWOGc3rfBGqDCUWKmc+dD07ZiGA+Y+rPIL
         BqouT1gEZdcbSGz/G5nXkjGMyke0I3m/9nGqPgD0T2NnJXzY5/ewWy2J5zfwmyozyThl
         EGJAYgDm7EqKNVMeeb2O4IdVL9FAhWQfAlZjA8S3nxJE2183luM1zZxFh8SugQ/b9loO
         rwnjvS/SohDAMJi2jtFu0gjAxZOOKTOpqqJ+19qIsX8lmosOaC8tgbDBFUWriXBP24X0
         pqkcXSD067dW269bbJGobAVO3DIBjUriOjG95aoFHr29doV/QDEGmpc8nM5L2/pd+aH9
         rFmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=POnyXKH4ESKITkg2I+AemO3Wn3BRnxBoAiqSICQ80nY=;
        b=gTV+BrK2R/OVkld4VcxLXk/TmC6zT5DBgETIepXp68sxL1AxF8mTXMgc2Zqg73YiFJ
         dYUyPGJbVACqugL8qvbVDJmUAbynle5lqB+oe/USW5aDeJc4dHeWZWq1scMdx38k+zOA
         nGeZh0idrrS5+cTm1aRXWtmZxQSjEkDtID+8N+ica6AI65b8E8nP1nsKiMJjthdhtuqa
         ByhsrMJPHW5TswDDGkdBSckKqF9fB03BEWSQlLjDfJG+ThhwIdYAJEF91fyc1OKaIONy
         A6xHi3LP11KpalYOrvvM0e7CyeIvE1vRx2RWDzosqLCJL6ITUU4ASt1svb6OnAqYNaNy
         L3dw==
X-Gm-Message-State: ACrzQf0IZL6SLXHl4qWByY6RmAbcgdJZxCgI2lsOr2cFfcCLwffvdkAU
        8+2Z1E1TeqUYQ4g6tg13AyrHB9Y0IVS9YHSYh5g=
X-Google-Smtp-Source: AMsMyM4rMbt31ppiBQsNiaj+yea98lMxOJ17MivfGnmwtj8HuvlzFjPbY8K4J3x0fY5zP0o8CaMXcr8irenKr/WuKvE=
X-Received: by 2002:a17:906:1f48:b0:7ae:77d:bac with SMTP id
 d8-20020a1709061f4800b007ae077d0bacmr15655351ejk.708.1667605073005; Fri, 04
 Nov 2022 16:37:53 -0700 (PDT)
MIME-Version: 1.0
References: <20221103092118.248600-1-yangjihong1@huawei.com>
 <20221103092118.248600-3-yangjihong1@huawei.com> <Y2OknBtLgqTHSrvy@shell.armlinux.org.uk>
 <CAADnVQ+gX8Xc57K2hSG5ZNfU1RtKBFgEp2yOWq08X68bWjMqsg@mail.gmail.com> <CAEf4BzaJMfCXf_uUgyuWBddyd3qrV7SgpVy-hicuOn87FigMSg@mail.gmail.com>
In-Reply-To: <CAEf4BzaJMfCXf_uUgyuWBddyd3qrV7SgpVy-hicuOn87FigMSg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 4 Nov 2022 16:37:41 -0700
Message-ID: <CAADnVQJAp4=ouSTn2UM=N-EHvO=v2RMVN1dH8erkyMU9ZF1QCA@mail.gmail.com>
Subject: Re: [PATCH bpf RESEND 2/4] bpf: Remove size check for sk in
 bpf_skb_is_valid_access for 32-bit architecture
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Fri, Nov 4, 2022 at 3:43 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Nov 3, 2022 at 11:15 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Nov 3, 2022 at 4:23 AM Russell King (Oracle)
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Thu, Nov 03, 2022 at 05:21:16PM +0800, Yang Jihong wrote:
> > > > The error code -EACCES is returned when bpf prog is tested in 32-bit environment,
> > > > This is because bpf_object__relocate modifies the instruction to change memory
> > > > size to 4 bytes, as shown in the following messages:
> > > >
> > > > libbpf: prog 'kfunc_call_test1': relo #2: matching candidate #0 <byte_off> [18342] struct __sk_buff.sk (0:30:0 @ offset 168)
> > > > libbpf: prog 'kfunc_call_test1': relo #2: patched insn #1 (LDX/ST/STX) off 168 -> 168
> > > > libbpf: prog 'kfunc_call_test1': relo #2: patched insn #1 (LDX/ST/STX) mem_sz 8 -> 4
> > > >
> > > > As a result, the bpf_skb_is_valid_access check fails. For 32-bit architecture,
> > > > unnecessary checks need to be deleted.
> > >
> > > Isn't the purpose of this check to ensure that the entire pointer is
> > > written, and BPF can't write half of it?
> > >
> > >
> > > >       case offsetof(struct __sk_buff, sk):
> > > > -             if (type == BPF_WRITE || size != sizeof(__u64))
> > > > -                     return false;
> > >
> > > Wouldn't "(size != sizeof(struct bpf_sock *) && size != sizeof(__u64))"
> > > be more appropriate here, so 32-bit can only write the 32-bit pointer
> > > or the full 64-bit value, and 64-bit can only write the 64-bit pointer?
> > > Or is there a reason not to? bpf folk?
> >
> > You're correct. The patch is completely wrong.
> > The bug is elsewhere.
>
> So I looked at this a bit (and replied to the old version of this
> patch). What happens in the kernel is that we expect 64-bit load but
> rewrite it to 32-bit load on 32-bit architectures (because we just use
> sizeof(struct sk_buff, sk) which is 4 bytes on 32-bit arch.
>
> The problem here is that libbpf adjusts such pointer accesses from
> 8-byte read to 4-byte reads for preserve_access_index (because libbpf
> sees that pointer is really 4 byte long), which is what we actually
> want in the general case. Here the assumption was made before CO-RE
> that __sk_buff is a stable (and fake) UAPI and the correct BPF program
> will access sk as a 64-bit pointer because BPF-side pointers always
> appear as 64-bit.
>
> But from a correctness standpoint I think it should be fine to enable
> both 32- and 64-bit loads for such pointers in __sk_buff for 32-bit
> host arch. This will work well with CO-RE and will be correctly
> rewritten to 32-bit or 64-bit accesses, depending on host
> architecture.
>
> We should still reject 32-bit load on 64-bit host arch, though.

Replied in the other thread as well :)
The CO_RE screws up access here.
Since it's a load of a pointer the verifier has to see it as a 8-byte load.
When CO-RE converts it to 4 byte the verifier won't recognize it
as a pointer load anymore.
We cannot easily convert 64-bit BPF ISA into 32-bit.
It's a massive amount of work.
