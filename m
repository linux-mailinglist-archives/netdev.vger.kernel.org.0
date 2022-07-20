Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC0857BDF7
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiGTSnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiGTSnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:43:31 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B668B6053B;
        Wed, 20 Jul 2022 11:43:30 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id q14so14956005iod.3;
        Wed, 20 Jul 2022 11:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F6sC7tMBDUtAsFVPIV6SMLMegSZ+oOONijeKBuLgh+U=;
        b=gTcrsY7YLW/CBUYVqmQOhPFLPf9FGyj/7z3H6aScCTSNGvrjTY7rv5TUlP7mAZ/YCs
         vgDYmR9oqV4pQ52txs18sILfw09VBrk7ZcdGObjIS1IrH9BGXX1DwIKFt6PHS9nQzjVD
         GPhXQzdwYue3zcuV1iVJudXmqG0lTEF7dzpe387+2PqgBlw8SBChRy9c4wRAQqwgxVrv
         1qqIG6VTY+4R2at1O0XPFCxjcfSOuogC8tEoADjFu51MU/zJXPCvnul/qhXp/6USOBTX
         jjPWimyj2zbKpInHAOB1b6IIuItnzx9Tvhopjm+lUtzz5m0iytdJJw/LYvogphXW4DRd
         cgPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F6sC7tMBDUtAsFVPIV6SMLMegSZ+oOONijeKBuLgh+U=;
        b=V2Plw+KSgonk3lxRyi2QnrFq0aTfppI12mAoQI+K7Pp1YiLVNFcHhxyh4juaQGXkEf
         mSAyh/uMNC/6WCj+NwRAbMyllIGpUINJDfLqPnVBPYNoBcDAsJDk1N8f7ydUvLuSittn
         DcmlR0Tsgo8ArF8D/FLhZ09luRf5lv7HlJiOYsdYnfBSJoqmq5HP/IzkCQEAfEBCaMaQ
         4brX+vEhCWvuE8LB6H57dHzv2RZaRcUj5M7n8xd7oa6zcPnFxoS/vMNQVM/6ddxodtAH
         NKw6LJJ3ZHsnf7IwSbeV05oYBN6I/wJKEHKnjll4VguMXSWXrcG6r+0oFKJ12GTo2/Dp
         Rf/A==
X-Gm-Message-State: AJIora8nJ1/RqgDDerNTCYSAiVdJACDogaZ93lidiNcHSRGIsshna//l
        C8WHyDZwLYcteMt9IsuOSRB0oL1f+b+rz45XB/Q=
X-Google-Smtp-Source: AGRyM1u6WY6OfwxwkRdscSiFzfWrQpQyj+r3TzDQuxrIoCI9zUcwTYo2kpbZSRzqvJxnljIYejNdZzWOPDd6gxQ1DsY=
X-Received: by 2002:a05:6602:395:b0:67b:d0c6:50cb with SMTP id
 f21-20020a056602039500b0067bd0c650cbmr16559106iov.110.1658342610017; Wed, 20
 Jul 2022 11:43:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220719132430.19993-1-memxor@gmail.com> <20220719132430.19993-2-memxor@gmail.com>
 <20220719183745.4ojhwpuo7ookjvvk@MacBook-Pro-3.local>
In-Reply-To: <20220719183745.4ojhwpuo7ookjvvk@MacBook-Pro-3.local>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Wed, 20 Jul 2022 20:42:54 +0200
Message-ID: <CAP01T753gZgg2501YR9rhCTCiHAf-zUe3USPqptAV43RWzJCVg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 01/13] bpf: Introduce BTF ID flags and 8-byte
 BTF set
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
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

On Tue, 19 Jul 2022 at 20:37, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jul 19, 2022 at 03:24:18PM +0200, Kumar Kartikeya Dwivedi wrote:
> >
> > +#define ____BTF_ID_FLAGS_LIST(_0, _1, _2, _3, _4, _5, N, ...) _1##_##_2##_##_3##_##_4##_##_5##__
> > +#define __BTF_ID_FLAGS_LIST(...) ____BTF_ID_FLAGS_LIST(0x0, ##__VA_ARGS__, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
> > +
> > +#define __FLAGS(prefix, ...) \
> > +     __PASTE(prefix, __BTF_ID_FLAGS_LIST(__VA_ARGS__))
> > +
> > +#define BTF_ID_FLAGS(prefix, name, ...) \
> > +     BTF_ID(prefix, name)            \
> > +     __BTF_ID(__ID(__FLAGS(__BTF_ID__flags__, ##__VA_ARGS__)))
> > +
> >  /*
> >   * The BTF_ID_LIST macro defines pure (unsorted) list
> >   * of BTF IDs, with following layout:
> > @@ -145,10 +164,53 @@ asm(                                                    \
> >  ".popsection;                                 \n");  \
> >  extern struct btf_id_set name;
> >
> > +/*
> > + * The BTF_SET8_START/END macros pair defines sorted list of
> > + * BTF IDs and their flags plus its members count, with the
> > + * following layout:
> > + *
> > + * BTF_SET8_START(list)
> > + * BTF_ID_FLAGS(type1, name1, flags...)
> > + * BTF_ID_FLAGS(type2, name2, flags...)
> > + * BTF_SET8_END(list)
> > + *
> > + * __BTF_ID__set8__list:
> > + * .zero 8
> > + * list:
> > + * __BTF_ID__type1__name1__3:
> > + * .zero 4
> > + * __BTF_ID__flags__0x0_0x0_0x0_0x0_0x0__4:
> > + * .zero 4
>
> Overall looks great,
> but why encode flags into a name?
> Why reuse ____BTF_ID for flags and complicate resolve_btfid?
> Instead of .zero 4 insert the actual flags as .word ?
>
> The usage will be slightly different.
> Instead of:
> BTF_ID_FLAGS(func, bpf_get_task_pid, KF_ACQUIRE, KF_RET_NULL)
> it will be
> BTF_ID_FLAGS(func, bpf_get_task_pid, KF_ACQUIRE | KF_RET_NULL)

Nice, I didn't know you could do complex expressions like this for asm
directives like .word, but it makes sense now. TIL. I'm not very well
versed with GNU as. I will rework this and drop the resolve_btfids
changes for flags. Thanks a lot!
