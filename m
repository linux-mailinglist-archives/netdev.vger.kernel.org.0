Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEEA561A5C0
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 00:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiKDXcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 19:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiKDXck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 19:32:40 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D246BCAD;
        Fri,  4 Nov 2022 16:32:39 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id q9so17171827ejd.0;
        Fri, 04 Nov 2022 16:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gPS2+UU8iwApZPhZmjyMJQFgHkJsGSiJkrP0Ew3CwIY=;
        b=BmQGcD73WnyuFV/7Pot3nedscTK62DmVc12N4FcDIvImStdkUFZDh4hZKO42rJ02Zu
         VMh/FVUD2QZzfxs2GllIlzAsqUMvC5HMksiSH2/rCUDlA9/eDNkGNzDy47YkJC6xlPAY
         SP+xoEUHZTdosyPZx3gQFj50ks3/MU8sZyD+YLONJLEAAM0rSqAdbaNeXn2CBJQYpoyi
         sZwlIOIZb7L3D0HWBtJcUxj7mPzL5HHrkb8vI5z5mAxXVKEeaMdWYYLI9kT+ZdT8feen
         3GNFHA3T42qODuwdCwkWYcgXOHnmsqof+oJCtdQKuwMGW60Ta8JFD2pm2n+3D9+1Ha0s
         1kwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gPS2+UU8iwApZPhZmjyMJQFgHkJsGSiJkrP0Ew3CwIY=;
        b=i+/HHn9sxMqkqfJit+MZ8fpxmkhgbpvGBFEp90rGNGvjB+u/wPvs38BD+8gIppZqWI
         R0iMBaDC2i3E1Fo0f36yHex2UVNqazmPz8YK7HpvNIQrMS5DxxHDf+0AWS1nRAR9HISn
         OhQK7Q+tZY49QnrFwFQDTali0YNEt5m0cbR06VE2wLUZMdGoRlnWnlnnCN12GFhclaEs
         vOwaLFw9EUmG7ynWLgy5BcawXp4EukWjEdLLs7Jwin0JrL/f0AgZu5UgC3EImE6gxAVb
         tHb/2mCXfO9BM93xROyreMOUsGOZr/KMHYDseI1FFR+eAjVMYMha7VV7E4I/JhZRUzOl
         NHPQ==
X-Gm-Message-State: ACrzQf0AI6bpoBTBTbuWuhHspZpFdPDhmOKZdrou5DZkCtDs371ZJc7v
        VzVdMyKhzmeLiESZKdUC54uPgdwlfsgKyaVuGeY=
X-Google-Smtp-Source: AMsMyM6wL9MjIdR5P3j3LJ6Nj5xyEoU2ZIqIYSsUj1+WT42blhstrelc0SJRLDa/devhSy4vZ+X2hSsoEOwzxeileEI=
X-Received: by 2002:a17:906:8a73:b0:7ae:3962:47e7 with SMTP id
 hy19-20020a1709068a7300b007ae396247e7mr4500472ejc.502.1667604758005; Fri, 04
 Nov 2022 16:32:38 -0700 (PDT)
MIME-Version: 1.0
References: <20221103083254.237646-1-yangjihong1@huawei.com>
 <20221103083254.237646-3-yangjihong1@huawei.com> <CAEf4BzY+qP1wwVddjg7_rypcUAW8iPRzSa=1O6aFG5dSLX+1Gg@mail.gmail.com>
In-Reply-To: <CAEf4BzY+qP1wwVddjg7_rypcUAW8iPRzSa=1O6aFG5dSLX+1Gg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 4 Nov 2022 16:32:26 -0700
Message-ID: <CAADnVQJW3CisB3L2nNOC0aGkPPBTHnyM-ZCXoZJc-KtNNEj+QQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] bpf: Remove size check for sk in bpf_skb_is_valid_access
 for 32-bit architecture
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Fri, Nov 4, 2022 at 2:56 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Nov 3, 2022 at 1:36 AM Yang Jihong <yangjihong1@huawei.com> wrote:
> >
> > The error code -EACCES is returned when bpf prog is tested in 32-bit environment,
> > This is because bpf_object__relocate modifies the instruction to change memory
> > size to 4 bytes, as shown in the following messages:
> >
> > libbpf: prog 'kfunc_call_test1': relo #2: matching candidate #0 <byte_off> [18342] struct __sk_buff.sk (0:30:0 @ offset 168)
> > libbpf: prog 'kfunc_call_test1': relo #2: patched insn #1 (LDX/ST/STX) off 168 -> 168
> > libbpf: prog 'kfunc_call_test1': relo #2: patched insn #1 (LDX/ST/STX) mem_sz 8 -> 4
> >
> > As a result, the bpf_skb_is_valid_access check fails. For 32-bit architecture,
> > unnecessary checks need to be deleted.
> >
> > Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
> > ---
> >  net/core/filter.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index bb0136e7a8e4..eab7ce89740c 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -8269,8 +8269,6 @@ static bool bpf_skb_is_valid_access(int off, int size, enum bpf_access_type type
> >                         return false;
> >                 break;
> >         case offsetof(struct __sk_buff, sk):
> > -               if (type == BPF_WRITE || size != sizeof(__u64))
> > -                       return false;
>
> this probably should be specific to host architecture bitness? I'd
> imagine that size = 4 should be invalid on 64-bit arches (reading half
> of the pointer is bad)

Not quite.
In __sk_buff the field 'sk' is defined as:
__bpf_md_ptr(struct bpf_sock *, sk);
so it's always 64-bit load when bpf prog reads it.
In this case CO_RE shouldn't have been applied to uapi struct __sk_buff.
