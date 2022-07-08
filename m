Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4A556C2C4
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239601AbiGHWbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 18:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238977AbiGHWbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 18:31:07 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EF713B462;
        Fri,  8 Jul 2022 15:31:06 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id dn9so34614724ejc.7;
        Fri, 08 Jul 2022 15:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vtYNlUjFPBorTja/ZZdAiqkuVJixHxyN2XSNBOycbUI=;
        b=DM5Hj2oOBlL+l9CByJUKOaJ1vh4HJDKbEohe9/mUhrJgEyABIdmO+clfDNX8z4r0VE
         nO3YJTw4Dj43d+Ay0VD9VuWxZn3DTEQTUbM/kbJ4S7meIbQXRsDrq4PSBKwlvTLCj8f9
         tD8hIcQzA2JxTza2YBdsVregDQcn+tgrrmRuWeGW3NN7zkdUaRumuuPDsb2LiQ4IEpL2
         yOB9FFMy/0wpprM4LnpZ15p3wwuLPUGpmHLxXl+xf4tVLMXyDpm0lFf8gM4V5edxrtIH
         dT5HHV32Z9hMD4BpMZAoV+EXhfLeV/u5UTsBdsa2+Mhyg4FmR8s2R/IH4LJzCBGxetst
         aOjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vtYNlUjFPBorTja/ZZdAiqkuVJixHxyN2XSNBOycbUI=;
        b=2pkBIjiTDRMMB3g1QnJ8GbohCKVvdGipWFX8BajFFa1xn+cDdkOlQ/Hy8sz+zI1S8F
         mF4Tj6E56EXa23pp81oKNoAI+8wj6WVRl6XPnK+CSN/+hnTdU3B0YugSsDjiJ1HdqpSx
         jdKOE2bpFqSz2Do//GVGybBelByVh/ABj6wqZ0mMbIW/EDhHZA6LVvxy6lFsmrtaaVti
         YziRUD7LcTS+taTSl9zidjiCqb8VCi8vKWIyExUjRBk6X5f0ECxgLhHq1Z+pVR1wi062
         KxjHzDefCP3U6zsKaMtxHcbE0ZvA+niiCnfD6hXZ5F/U9wC+rwhz0/Ab7R+uu5cOO0WH
         s3VQ==
X-Gm-Message-State: AJIora/6k9UjF2P0Gfeb6bAUz6iUTHEo5542x0DCVqostOO7IRKn7WsX
        ZjZsiBruBC+2p7Or7isfD9rrp49dajIMBy27apw=
X-Google-Smtp-Source: AGRyM1vFnuzeNUeQJq3npYMM5/i0JV31krsyjIvnTW8wNxdmDm4x2jiY80Prv2hmg2FGbtZg7UXyubeeDzGWGUamxDg=
X-Received: by 2002:a17:906:a3ca:b0:726:2bd2:87bc with SMTP id
 ca10-20020a170906a3ca00b007262bd287bcmr5799290ejb.226.1657319464980; Fri, 08
 Jul 2022 15:31:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220530092815.1112406-1-pulehui@huawei.com> <20220530092815.1112406-5-pulehui@huawei.com>
 <a31efed5-a436-49c9-4126-902303df9766@iogearbox.net> <CAEf4BzacrRNDDYFR_4GH40+wxff=hCiyxymig6N+NVrM537AAA@mail.gmail.com>
 <38a59b80-f64a-0913-73e4-29e4ee4149c5@huawei.com>
In-Reply-To: <38a59b80-f64a-0913-73e4-29e4ee4149c5@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Jul 2022 15:30:53 -0700
Message-ID: <CAEf4BzaDQ+cPh8pLGqg-GSM+ryZz3vvDtUy=o2u19KM0CTrewg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 4/6] libbpf: Unify memory address casting
 operation style
To:     Pu Lehui <pulehui@huawei.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        linux-riscv@lists.infradead.org,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
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

On Thu, Jul 7, 2022 at 5:23 AM Pu Lehui <pulehui@huawei.com> wrote:
>
>
>
> On 2022/6/4 5:03, Andrii Nakryiko wrote:
> > On Mon, May 30, 2022 at 2:03 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>
> >> On 5/30/22 11:28 AM, Pu Lehui wrote:
> >>> The members of bpf_prog_info, which are line_info, jited_line_info,
> >>> jited_ksyms and jited_func_lens, store u64 address pointed to the
> >>> corresponding memory regions. Memory addresses are conceptually
> >>> unsigned, (unsigned long) casting makes more sense, so let's make
> >>> a change for conceptual uniformity.
> >>>
> >>> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> >>> ---
> >>>    tools/lib/bpf/bpf_prog_linfo.c | 9 +++++----
> >>>    1 file changed, 5 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/tools/lib/bpf/bpf_prog_linfo.c b/tools/lib/bpf/bpf_prog_linfo.c
> >>> index 5c503096ef43..7beb060d0671 100644
> >>> --- a/tools/lib/bpf/bpf_prog_linfo.c
> >>> +++ b/tools/lib/bpf/bpf_prog_linfo.c
> >>> @@ -127,7 +127,8 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
> >>>        prog_linfo->raw_linfo = malloc(data_sz);
> >>>        if (!prog_linfo->raw_linfo)
> >>>                goto err_free;
> >>> -     memcpy(prog_linfo->raw_linfo, (void *)(long)info->line_info, data_sz);
> >>> +     memcpy(prog_linfo->raw_linfo, (void *)(unsigned long)info->line_info,
> >>> +            data_sz);
> >>
> >> Took in patch 1-3, lgtm, thanks! My question around the cleanups in patch 4-6 ...
> >> there are various other such cases e.g. in libbpf, perhaps makes sense to clean all
> >> of them up at once and not just the 4 locations in here.
> >
> > if (void *)(long) pattern is wrong, then I guess the best replacement
> > should be (void *)(uintptr_t) ?
> >
>
> I also think that (void *)(uintptr_t) would be the best replacement. I
> applied the changes to kernel/bpf and samples/bpf, and it worked fine.
> But in selftests/bpf, the following similar error occur at compile time:
>
> progs/test_cls_redirect.c:504:11: error: cast to 'uint8_t *' (aka
> 'unsigned char *') from smaller integer type 'uintptr_t' (aka 'unsigned
> int') [-Werror,-Wint-to-pointer-cast]
>         .head = (uint8_t *)(uintptr_t)skb->data,

this is BPF-side code so using system's uintptr_t definition won't
work correctly here. Just do (unsigned long) instead?

>
> I take clang to compile with the front and back end separation, like
> samples/bpf, and it works. It seems that the all-in-one clang has
> problems handling the uintptr_t.
>
> >>
> >> Thanks,
> >> Daniel
> > .
> >
