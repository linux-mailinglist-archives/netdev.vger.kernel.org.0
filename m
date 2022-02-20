Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FBD4BCB74
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 02:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbiBTBNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 20:13:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiBTBNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 20:13:52 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35323A185;
        Sat, 19 Feb 2022 17:13:31 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id d3so7431027ilr.10;
        Sat, 19 Feb 2022 17:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MHmeZaIgkSm3ycZ7IymMzdu/DGYdydfC+srKFRrUzGw=;
        b=eX5cX5upyd+aBVEMTwur3X0kB35IYsUH24FDRYt06449k/MSLDQogHJeJCOoA7CBPV
         MvlKP9aNBOtcS+qTpNBUNABSvTSngdSwH2UF+3YAfAY6DYQXN5j6zaUNyowRIJQIRxIt
         A/yc2e7I1EbVoE4fzz/NjYtr3HlDoUX/QMNt9wFcLYVfggs2LhoAqFCgh02jw3QLps2z
         QsvN+AU/k/zPcSRYU49q8wrDK0rqGNN8si4T2feRsGuLIGnY/+QB7xeA66wYx3AdJIf5
         P6NO+3n8Cripgd1UMc1A7+S8sWCsEiSkOdIqX+kmULE6eA7HNwxGNGvPMiO7Mdktruau
         3wWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MHmeZaIgkSm3ycZ7IymMzdu/DGYdydfC+srKFRrUzGw=;
        b=HRIxpbgmjClU8E8h9GWwBk1gzJoK8S22tw+QtNhzebb1J9VnnNFLTXoPRlMKwBNfDZ
         xKV/BX9ejfnmHs/Ri6lrla9CYm43/M5POhgu9Jey4zVYLCnPx1QBmi9olhPzEb66gXuG
         +7WK4k6dGf/+sGCKvyLJGWQChRAuFoo13Wa8doiS02nMhRUSTKuH10FOgcoo2RFY2HEX
         b0PYmRqY1NtBts2vMILTaROxzZDYees4F8ModeZqYY4gKv/Uad+cmFilBm041kfBRjtv
         UVkTU3DKjI4Bu1H3O6Td76+ewLwZksNrn62U5Yzk0HjcwNsu36LQDJEcWopDyM2rnqTo
         lGEA==
X-Gm-Message-State: AOAM533SCpQPNJwiep6AhPZxdk7nbCEvbU8VmgrvEZQtxCJJkkwJwDhX
        8F5u8z9sBHXNZpCyEYUjIn/qf4Y2lb4n+v60Oz3a0pQoQCs=
X-Google-Smtp-Source: ABdhPJyXGu8XOEJsmn7Sj+TXQMH/Gy/gWFWNPTm5dCy8cTMzuH1MZlt/jjNq9G8gwrl+cvJdPqJFocoocb1ASFAz7Us=
X-Received: by 2002:a05:6e02:1a88:b0:2be:a472:90d9 with SMTP id
 k8-20020a056e021a8800b002bea47290d9mr10779088ilv.239.1645319611219; Sat, 19
 Feb 2022 17:13:31 -0800 (PST)
MIME-Version: 1.0
References: <20220218222017.czshdolesamkqv4j@apollo.legion> <878ru7qp98.fsf@oc8242746057.ibm.com>
In-Reply-To: <878ru7qp98.fsf@oc8242746057.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 19 Feb 2022 17:13:20 -0800
Message-ID: <CAEf4BzZMYP0qL=OanY5fv3CPghG5AciY5j2RnVrnjcJ0cF5eUA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 00/10] Introduce unstable CT lookup helpers
To:     Alexander Egorenkov <egorenar@linux.ibm.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexander.Egorenkov@ibm.com, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Florian Westphal <fw@strlen.de>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        john fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Networking <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Song Liu <songliubraving@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 11:39 PM Alexander Egorenkov
<egorenar@linux.ibm.com> wrote:
>
>
> Hi Kartikeya,
>
> sorry if i wasn't clear in my first message but just to be sure
> we have no misunderstandings :)
>
> .BTF sections work on s390x with linux-next and nf_conntrack as well if
> the corresponding .BTF section is a part of the kernel module itself.
> I tested it myself by building a linux-next kernel and testing it with a
> KVM guest, i'm able to load nf_conntrack and it works.
>
> In contrast, in the case where the corresponding .BTF section is separate
> from the kernel module nf_conntrack, it fails with the message i
> provided in the first email.
>
> Therefore, my question is, does BTF for kernel modules work if the
> corresponding BTF section is NOT a part of the kernel module but instead
> is stored within the corresponding debuginfo file
> /usr/lib/debug/lib/modules/*/kernel/net/netfilter/nf_conntrack.ko.debug ?

No, it doesn't. .BTF has to be part of the module's .ko ELF file.
DWARF can be stripped out, it's only needed for generating BTF during
the build process.

It actually would be great to have an option to generate BTF without
leaving any DWARF, but that's a separate topic.

>
> Thanks
> Regards
> Alex
>
>
>
