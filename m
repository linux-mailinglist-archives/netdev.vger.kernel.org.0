Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46BF574506
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 08:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbiGNGVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 02:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233455AbiGNGVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 02:21:15 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A959F1EED1;
        Wed, 13 Jul 2022 23:21:14 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id ez10so1529280ejc.13;
        Wed, 13 Jul 2022 23:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pq95ND8BDQIHwxsqfPmYBdAOr2LWRGPXUOS7G88vYNI=;
        b=mc0niwUHgxn7oIC9eFaGWNcnvDu1V+as79Nu5JgwbKfVSmLi+rtAzf2GVzshoZ28kq
         9Q48QZiUjhjsCECE6In9OsDA0k926V5Gb4qKamyvRF5PdT83Od9BrFw9CnQtKppSplGv
         3XNOy2MF3ARw+5Pf0AGPJ+hz4tR0EWDknQTCcPCnBpEOa/ec1nmyyloMwjnYAsT7lXt3
         kHtxOGVr4c1Bms88ujUUsJwTKX+NokAOqAnrCOpcKoZBZnGRG508NvJezPLFGSgkGNPE
         761In9b79cciRBpogVK+fuFR6ndymTYq8zj9MMdyX0ZKnKvnH/ohDy1yVo8MMi11Yr13
         tIjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pq95ND8BDQIHwxsqfPmYBdAOr2LWRGPXUOS7G88vYNI=;
        b=jeOrTaO7DPJgYymFBY1C1wu/LlCjch2pAMYnWLYhv66o8qq8WLaS/7KVgdIMwfTtDz
         FQOs1iBHoK+3w0pPIUvUwqCl2dSrGWYTh62q6YSBw37F2LXQTy8BLbWzO5stob6rgGdS
         4elfxg8mrT1wr2z7y/LIbes3Y36QRLMzpMq9P6MBKDMI2Rvy7duaaVuX4gyOMCkiA00K
         QrexM9NFQgOGSUFdHFUpsiaKXdtwh9mHhXmu7jgwK+B17pHyGIFsJxzxFC+LDalawfeP
         DMRz6Ok1YxX5UfterPe4PFLCW68+pAO4/6t7TE5GQIwrkseo3WClIAiX0D4Y8asSpK/X
         Re4g==
X-Gm-Message-State: AJIora9FIz8AEtxh5zorLJpXwwlSfkdtluFYf4UApLlkk2zcA5UXKTbN
        ptIBPTGxjvBSAQX5CUi5EN7b5r93c9yYZSIrXXQ=
X-Google-Smtp-Source: AGRyM1thXSIGIJL+S9pfG4Jcto8eU8bl95TqWCff70xLa+xLFkC2RH9LBJ5EQL/XyoX+FpumrxKtVs2t6vyYY/7l2wc=
X-Received: by 2002:a17:906:cc0c:b0:72b:68df:8aff with SMTP id
 ml12-20020a170906cc0c00b0072b68df8affmr7264433ejb.226.1657779673195; Wed, 13
 Jul 2022 23:21:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220714015647.25074-1-xiaolinkui@kylinos.cn> <CAKH8qBuj=7HXF2xTRWqso9o56t5Tpg68C+r5PnHVnEyu129UmA@mail.gmail.com>
In-Reply-To: <CAKH8qBuj=7HXF2xTRWqso9o56t5Tpg68C+r5PnHVnEyu129UmA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 Jul 2022 23:21:01 -0700
Message-ID: <CAEf4BzY5ncGXcnFVGgdQp_wMrJ4dsgae2s95BXr4PkL2oMURnQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Return true/false (not 1/0) from
 bool functions
To:     Stanislav Fomichev <sdf@google.com>
Cc:     xiaolinkui <xiaolinkui@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Mykola Lysenko <mykolal@fb.com>,
        Shuah Khan <shuah@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, xiaolinkui@kylinos.cn,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, llvm@lists.linux.dev
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

On Wed, Jul 13, 2022 at 8:37 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Wed, Jul 13, 2022 at 6:57 PM xiaolinkui <xiaolinkui@gmail.com> wrote:
> >
> > From: Linkui Xiao <xiaolinkui@kylinos.cn>
> >
> > Return boolean values ("true" or "false") instead of 1 or 0 from bool
> > functions.  This fixes the following warnings from coccicheck:
> >
> > tools/testing/selftests/bpf/progs/test_xdp_noinline.c:407:9-10: WARNING:
> > return of 0/1 in function 'decap_v4' with return type bool
> > tools/testing/selftests/bpf/progs/test_xdp_noinline.c:389:9-10: WARNING:
> > return of 0/1 in function 'decap_v6' with return type bool
> > tools/testing/selftests/bpf/progs/test_xdp_noinline.c:290:9-10: WARNING:
> > return of 0/1 in function 'encap_v6' with return type bool
> > tools/testing/selftests/bpf/progs/test_xdp_noinline.c:264:9-10: WARNING:
> > return of 0/1 in function 'parse_tcp' with return type bool
> > tools/testing/selftests/bpf/progs/test_xdp_noinline.c:242:9-10: WARNING:
> > return of 0/1 in function 'parse_udp' with return type bool
> >
> > Generated by: scripts/coccinelle/misc/boolreturn.cocci
> >
> > Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
> Reviewed-by: Stanislav Fomichev <sdf@google.com>
>
> > Suggested-by: Stanislav Fomichev <sdf@google.com>
> That shouldn't be here :-) I didn't suggest the patch, you're
> suggesting it, I'm just suggesting to properly format it.
> Probably not worth a respin, I hope whoever gets to apply it can drop
> that line (or maybe keep it, I don't mind).

Dropped Suggested-by, applied to bpf-next.

>
> > ---
> >  .../selftests/bpf/progs/test_xdp_noinline.c   | 30 +++++++++----------
> >  1 file changed, 15 insertions(+), 15 deletions(-)
> >

[...]
