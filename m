Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF61620599
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 02:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbiKHBHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 20:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiKHBHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 20:07:53 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF573248CA;
        Mon,  7 Nov 2022 17:07:52 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id f27so34741850eje.1;
        Mon, 07 Nov 2022 17:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Tz4DXUwB8MapeXYHJsCdHftchNNLXz8UNlurMY6/9pU=;
        b=k1lwV6cTVWO0lVK0eV6W8mfgRjranpkmcFc04FvVS2YggyrwV1MLiGfprsJYgRgyYR
         m/17SeVYABfYWCB/CRjVrQ/VgMV0+OSEjS2X0oi1VQXqBZFe5KadyqKYoUlYXMgxBZxf
         NUTWWUJoX3JOjufPoplM5bCc20m+WGl+JJz35IQJ6W+F+k+DVoRDZ8HEUX53FuCKZUyH
         4vvDbZvnb2DT4xJVkOgPr54qLjsmHZdPO6FUNIeV+LZLnR3VodZNbovX5qEwaH+c0VWU
         y6MqIHvzAeDNFtDtfA+uBTmwmgm7fhzEPusQNXR7J7xdOwAcqU2El5g69n5/xUyWLBkV
         Mn0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tz4DXUwB8MapeXYHJsCdHftchNNLXz8UNlurMY6/9pU=;
        b=Nz/mM1PIexFTmfZXv8zszoO+CvoAVb8kitQjVA1x1fyuMI2g022q+KUBmL/DirlTRK
         nLcQy6jkxri6+C/Qa8I4PraFIdMzNRTMhakyvHM3izj8Es8pICDASVw2QiMqJ488/fP2
         lpMnmaqjH2ksfuLlY49YvwogU/rAXaKf6rlMjHbZT1Vv5vn4MjwYueZozeDu2MK/Gmho
         /sDjZt7kej1TMHAtTLkbO368QnTduFAosf0PnsRydTQHpkByjQm1tUinkhBzpZI2EMQR
         hmTN8GApHh6pQ6YRam933T4kzSl5aHyS+Zb/Vl/c/N0GMcVq8LIWdY73Ix3mvFDNMY0i
         QQTQ==
X-Gm-Message-State: ACrzQf26vAs34mil03GYy0wOko9yXEf0Dg3iU/Jw4FUW2BnMGbA6VFdO
        QffXEM9D8B0F25XX3QsJJCLddoDpU4ugYszNNGM=
X-Google-Smtp-Source: AMsMyM7F/wfMIAI3Pzk6zlUhjURIiB8mQML2zO0akN3+D3xP5rRkJy5XRZoc47qAoqbfK9eQtPt/3eIZHRUKm7zf6tc=
X-Received: by 2002:a17:906:99c5:b0:73d:70c5:1a4f with SMTP id
 s5-20020a17090699c500b0073d70c51a4fmr50095400ejn.302.1667869671316; Mon, 07
 Nov 2022 17:07:51 -0800 (PST)
MIME-Version: 1.0
References: <20221103083254.237646-1-yangjihong1@huawei.com>
 <20221103083254.237646-3-yangjihong1@huawei.com> <CAEf4BzY+qP1wwVddjg7_rypcUAW8iPRzSa=1O6aFG5dSLX+1Gg@mail.gmail.com>
 <CAADnVQJW3CisB3L2nNOC0aGkPPBTHnyM-ZCXoZJc-KtNNEj+QQ@mail.gmail.com>
In-Reply-To: <CAADnVQJW3CisB3L2nNOC0aGkPPBTHnyM-ZCXoZJc-KtNNEj+QQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Nov 2022 17:07:39 -0800
Message-ID: <CAEf4Bzb+qJ-jzMkvWkBV0nXYj51P8DSbEHagT7h5ujCjCrRu8Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] bpf: Remove size check for sk in bpf_skb_is_valid_access
 for 32-bit architecture
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yang Jihong <yangjihong1@huawei.com>,
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
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Delyan Kratunov <delyank@fb.com>,
        Artem Savkov <asavkov@redhat.com>, colin.i.king@gmail.com,
        bpf <bpf@vger.kernel.org>,
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

On Fri, Nov 4, 2022 at 4:32 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Nov 4, 2022 at 2:56 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Nov 3, 2022 at 1:36 AM Yang Jihong <yangjihong1@huawei.com> wrote:
> > >
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
> > >
> > > Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
> > > ---
> > >  net/core/filter.c | 2 --
> > >  1 file changed, 2 deletions(-)
> > >
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index bb0136e7a8e4..eab7ce89740c 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -8269,8 +8269,6 @@ static bool bpf_skb_is_valid_access(int off, int size, enum bpf_access_type type
> > >                         return false;
> > >                 break;
> > >         case offsetof(struct __sk_buff, sk):
> > > -               if (type == BPF_WRITE || size != sizeof(__u64))
> > > -                       return false;
> >
> > this probably should be specific to host architecture bitness? I'd
> > imagine that size = 4 should be invalid on 64-bit arches (reading half
> > of the pointer is bad)
>
> Not quite.
> In __sk_buff the field 'sk' is defined as:
> __bpf_md_ptr(struct bpf_sock *, sk);
> so it's always 64-bit load when bpf prog reads it.
> In this case CO_RE shouldn't have been applied to uapi struct __sk_buff.

Ok, hold on. __bpf_md_ptr just creates a 8-byte sized and aligned
union. It doesn't change the pointer itself in any way:

union {
    struct bpf_sock* sk;
    __u64 :64;
};


It's a 64-bit pointer only because any pointer in the BPF target is
64-bit. But on 32-bit architectures such struct bpf_sock *sk pointer
will *actually* be 4-byte pointer (and __u64 :64 will just make
compiler add 4 bytes of padding after it, effectively), and BPF
verifier will actually generate LDX instruction of BPF_W size (4 byte
load):

        case offsetof(struct __sk_buff, sk):
                *insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, sk),
                                      si->dst_reg, si->src_reg,
                                      offsetof(struct sk_buff, sk));
                break;


BPF_FIELD_SIZEOF(struct sk_buff, sk) is 4 for 32-bit kernels.

So while you are correct that it will be 8-byte load from the BPF
side, allowing 4-byte load for such pointers should also be correct.
It's our choice, there is no fundamental limitation why this shouldn't
be the case.

Note also that we do this transformation when fentry/fexit/raw_tp_btf
programs traverse pointers in kernel structures. There pretending like
pointer to an 8-byte value is actually invalid. So libbpf adjusts such
loads to 4-byte loads for CO-RE-relocatable types, which makes it all
work transparently on 32-bit architectures. Context accesses deviate
from that, as they came earlier and we didn't have CO-RE at that time.

So what you are saying is that __sk_buff shouldn't be
CO-RE-relocatable, and yes, that would be good. But I think that's
orthogonal in this case.
