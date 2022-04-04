Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C684F0D6B
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 03:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376861AbiDDB2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 21:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344091AbiDDB2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 21:28:34 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2C43A5E7;
        Sun,  3 Apr 2022 18:26:40 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id 9so9593655iou.5;
        Sun, 03 Apr 2022 18:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f6sIyOireO9MdPW1vWiXAO/JTVcQzxdFRdN9x9iBRuM=;
        b=fZFpwv+SMAPa8GBRUIepRjDZqnAGIFrz6md8VCB0xNJZvA2+ZQXJ2//CkueogJWJZy
         V6xSfI2NbuMxk0NtEZ2P16TsVHK69GNHtYXQ7DMZRI8+9saS5pnbsBwmwNImmZslP+dr
         MPNAMpkpzS75xdCY22xI5U8/8rq5D1aNL7FPaaKtzLZw9lt40xHiG/XjBhZqas0jybHO
         CBdreH+7KVQeYSnfNQPXSAYZg5Qnrs+Vc3JlJdCUb9T+g+5PXLEExeT01LZoBfgENiiy
         7ocTF7ebZVnz+NoTeMniDj/LWKAwvxOBnzkSuotMH39Ma4wrVLXDBRphp+gz39m4eWfM
         Gflg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f6sIyOireO9MdPW1vWiXAO/JTVcQzxdFRdN9x9iBRuM=;
        b=2Zjg6nm+rtcvGoOQtziETtdvYp3uQyma8XsDaqcLITN/rjDGkUIyAypOqWLfrmQ3BZ
         VdKsEWYbQ++zPVrVsD0mJjOsC0t8bP367go7UUsgTUSxPST399GdhmlP64ievIVkvWHe
         AJJlgNrSNcF3YmDsCzCpFYaCRASnvjwXCKe1ETLnbHJVIR1dPt32TdVzy3FAarwWy/4O
         J8ZdcRZ73J+rl8zChrtKrnRk2rsaGDaYVBB17TlGnp37feJWcUvqmJhpdVkBgWsmfYhA
         9ut0T2sk7rMLS6PtFfqsDdnHAyErNpoOWFyBnciGuKtEdPMvWO/qQCRn/69CuYMpGZMH
         qL0g==
X-Gm-Message-State: AOAM53174lPxEQdgjVDjr1RQrLwT1r62y0fOwhcIBy3sbepkG5YzdFI1
        609CYk3JR2/01/2s/Y6zhv0l5/Cm6OeWI2Yc2i8=
X-Google-Smtp-Source: ABdhPJxWL5dRlt3+QtkypDki3pY9Ot1etpqOIs4sv/InRR4PhgpA/iHvtzibFlaRlOKPKYIHeB8Ywaj3k8KOly3nExw=
X-Received: by 2002:a05:6638:1685:b0:323:9fed:890a with SMTP id
 f5-20020a056638168500b003239fed890amr10564674jat.103.1649035599532; Sun, 03
 Apr 2022 18:26:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220403144300.6707-1-laoar.shao@gmail.com> <20220403144300.6707-3-laoar.shao@gmail.com>
In-Reply-To: <20220403144300.6707-3-laoar.shao@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 3 Apr 2022 18:26:28 -0700
Message-ID: <CAEf4Bza7ZoRaHWLF=03+Z-PLTvZ3EOKZR02=UgDLDX-XXOewJg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/9] bpf: selftests: Use bpf strict all ctor
 in xdping
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Sun, Apr 3, 2022 at 7:43 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> Aoid using the deprecated RLIMIT_MEMLOCK.

typo: avoid

>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  tools/testing/selftests/bpf/xdping.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>

[...]
