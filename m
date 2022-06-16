Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5382B54EBCF
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 23:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378837AbiFPVA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 17:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378787AbiFPVAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 17:00:54 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B436007B;
        Thu, 16 Jun 2022 14:00:53 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g7so3793636eda.3;
        Thu, 16 Jun 2022 14:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9PnHnVLahiLFldPLozedmiE5cWgmYzHNZk7Z8fYNdbI=;
        b=pf+DTNRN9rHEQXYSlj7DZF3u2MserPjhDCdRZHb9CrMHuri6opM0vB70wO7GHf+mny
         PpcYMdnjulHRlQ+cYKhaz0WRm8o9h9/C8dVdnBF9GCTg0ypqLzaEEat8b16HBXECnGz2
         KYXedFs+liAU/OKwpto0ajykiBkDBfqZDUW4X1BH7BaGatw7d3ZTqXqF+jdGsg+bvJMF
         H6vh8Vn+JZ26/sSDfHYifsDliOMfzyIUfGp8t14ybC8Z1TVb4K80FgBVcCV9AqT9aEOV
         NF/DGp482cA9pv0jkr2Kzima8E7RzhVJ1B78WD7CvOCwqLBzhbbJJyPC5D7ooND9K78q
         ZT4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9PnHnVLahiLFldPLozedmiE5cWgmYzHNZk7Z8fYNdbI=;
        b=lbIkTfK59YTTc1Uf1oF7fn713hKTQJb6eBJoef/0bCgmWlLSmdFPhndVmg4Snc/gKr
         5Vd2o9k88jD3adctDtr/3kbbwSWuFjQKKaW54lGLyYh2k5n3qQJtX3pQXKgKaheHOoHh
         9wM/3L5tZpjH4TxVHTTZKtny8+atkyCglmGCTPyxPeCzGixfyk1WnVG/K+a1oFECdk3U
         VyLjRIsEjSxYqvgcrHnqVUt7uJ1xX7ElnVw1PoynF1q6hQ+oilAeHjwumQ42tm6XxIss
         AV8bvESSfBQV6DSVIeyo8pRBXjJbL1+9Otvq4MT7HfvQoSp/tlQG5Qa94xmbUKsh9Z1a
         /fOw==
X-Gm-Message-State: AJIora/0Y1KTUnk6RpfHlXO3jAPfk7cV/tBLmUs3MWnmIzyDzCS6JyLu
        ZW4GkuYsw6WaUwJlyqjcOKsJ0ndf92TlE2dSnj0=
X-Google-Smtp-Source: AGRyM1sTFo3+eTpM3qi6KGpkSVRl6TIch5Ti1q3gSKfZhOhUyWj/GLSvHcJbG2Ouoe8dybz6xNmQoHJnnyS0hpfzz48=
X-Received: by 2002:aa7:c450:0:b0:431:55c6:29f9 with SMTP id
 n16-20020aa7c450000000b0043155c629f9mr8805858edr.14.1655413251761; Thu, 16
 Jun 2022 14:00:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220603055156.2830463-1-irogers@google.com> <165428101333.23591.13242354654538988127.git-patchwork-notify@kernel.org>
 <CAP-5=fWwKkj1HtAvOXxGxcrG99gpy8v4ReW_Jh7uumbQMiJYng@mail.gmail.com>
In-Reply-To: <CAP-5=fWwKkj1HtAvOXxGxcrG99gpy8v4ReW_Jh7uumbQMiJYng@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Jun 2022 14:00:40 -0700
Message-ID: <CAEf4BzYYcnu1PHoudKnvpjPJAszgu3TFSbNe=E6vctgh9JLkTg@mail.gmail.com>
Subject: Re: [PATCH v2] libbpf: Fix is_pow_of_2
To:     Ian Rogers <irogers@google.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Yuze Chi <chiyuze@google.com>,
        open list <linux-kernel@vger.kernel.org>
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

On Tue, Jun 14, 2022 at 1:41 PM Ian Rogers <irogers@google.com> wrote:
>
> On Fri, Jun 3, 2022 at 11:30 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
> >
> > Hello:
> >
> > This patch was applied to bpf/bpf-next.git (master)
> > by Andrii Nakryiko <andrii@kernel.org>:
> >
> > On Thu,  2 Jun 2022 22:51:56 -0700 you wrote:
> > > From: Yuze Chi <chiyuze@google.com>
> > >
> > > Move the correct definition from linker.c into libbpf_internal.h.
> > >
> > > Reported-by: Yuze Chi <chiyuze@google.com>
> > > Signed-off-by: Yuze Chi <chiyuze@google.com>
> > > Signed-off-by: Ian Rogers <irogers@google.com>
> > >
> > > [...]
> >
> > Here is the summary with links:
> >   - [v2] libbpf: Fix is_pow_of_2
> >     https://git.kernel.org/bpf/bpf-next/c/f913ad6559e3
> >
> > You are awesome, thank you!
>
> Will this patch get added to 5.19?
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/lib/bpf/libbpf.c#n4948
>

I've applied it to bpf-next, so as it stands right now - no. Do you
need this for perf?

> Thanks,
> Ian
>
> > --
> > Deet-doot-dot, I am a bot.
> > https://korg.docs.kernel.org/patchwork/pwbot.html
> >
> >
