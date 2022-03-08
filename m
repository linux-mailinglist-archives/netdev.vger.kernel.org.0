Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488A64D14FC
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 11:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345838AbiCHKoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 05:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235914AbiCHKop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 05:44:45 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EBF41303;
        Tue,  8 Mar 2022 02:43:47 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id b8so16769833pjb.4;
        Tue, 08 Mar 2022 02:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kVG0kf5foVe3hmr29o5GrRkYkCpLk23FIIa7/Ch95rM=;
        b=qkS3qbfEay2oO+bJ7agoouaRbAinfT0Kb9++JSZjVeDI7efUDPFveFdENLmqpoodpy
         sAHmO1GBYEjJjdshPGMDGwYQtzfLST3WOywx+nzQlmLIbqmkQCtMOJU2Crmsrhp9/BPy
         uzERFM0UW2fId8T1AbhKmWHZkCcGy3IL8pIpLwGJh9ezaQpJ1ajcaGQ1OfBKEY22KU7F
         DT1dE1YPA3rTmAx6//NsqmjsYgnKF+mjNaCRIAdj1atw6FfzbZ1jC/6yGbj112JkLO8S
         AxJf4xewxUf/UX1mNMxwXYJsL9BH0vVob6kA548rrvKNlozd9HG4a57x6TehGDHbkbtC
         a8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kVG0kf5foVe3hmr29o5GrRkYkCpLk23FIIa7/Ch95rM=;
        b=nQPvXLfQi8SPDw4tntu/ebpQirSUGmr0PIFmO1L8ZksENeQcrIw8pAegPyji2ow13s
         bHYRjgUneRNVCBXm7uPHqnkOERjPPKvq4j9fnJtUotKYfKU1nON80jikqf+tN5fZ0zyS
         4f4UYT20nCUmEANWFw588HOK3kCuoXkX9RAwmyOAZcw9UEc8AYc0AIs1SlGc6T2n7zrT
         gxTNMiLNA5DVK/KbOdXL7+zob7Jer/jxEZYXub9ZlM5e4jFSoGhIdlZCzv03MF7O6i2M
         V7eJ5LXKcGgOGUlwl5NZhdb8XvDJjdYAAs4ZI4HOq9csaIvulDEujsa2YewN+U4fIpsd
         kVnw==
X-Gm-Message-State: AOAM532nhM7QOJtsiCfkmNZWu/gIui7s40jxmT1uLb50dBj0ebAIa+UU
        p+oS7tNjl1dw9k9wJ7RDiQ1KnTC/QYey0/L1
X-Google-Smtp-Source: ABdhPJwRFxwTt9GHPixKsjKE5eWxu+NxvBZb3wvWFzW4iKxyKr999BOU/oqXVvwXW3t1MW36ewlAlw==
X-Received: by 2002:a17:902:e848:b0:151:e3a5:b609 with SMTP id t8-20020a170902e84800b00151e3a5b609mr11000504plg.137.1646736227405;
        Tue, 08 Mar 2022 02:43:47 -0800 (PST)
Received: from baaz ([49.36.203.74])
        by smtp.gmail.com with ESMTPSA id q22-20020a056a00085600b004f397d1f3b5sm20327837pfk.171.2022.03.08.02.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 02:43:46 -0800 (PST)
Date:   Tue, 8 Mar 2022 16:13:40 +0530
From:   Muhammad Falak R Wani <falakreyaz@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next] samples/bpf: fix broken bpf programs due to
 function inlining
Message-ID: <YiczXPnQakMwNEbX@baaz>
References: <20220306121535.156276-1-falakreyaz@gmail.com>
 <CAEf4BzYmVo9rw1Ys0ZufQFA=f7sy+dP=d9L9rmGS5L91qV1K+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYmVo9rw1Ys0ZufQFA=f7sy+dP=d9L9rmGS5L91qV1K+A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 10:11:36PM -0800, Andrii Nakryiko wrote:
> On Sun, Mar 6, 2022 at 4:15 AM Muhammad Falak R Wani
> <falakreyaz@gmail.com> wrote:
> >
> > commit: "be6bfe36db17 block: inline hot paths of blk_account_io_*()"
> > inlines the function `blk_account_io_done`. As a result we can't attach a
> > kprobe to the function anymore. Use `__blk_account_io_done` instead.
> >
> > Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> > ---
> >  samples/bpf/task_fd_query_kern.c | 2 +-
> >  samples/bpf/tracex3_kern.c       | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/samples/bpf/task_fd_query_kern.c b/samples/bpf/task_fd_query_kern.c
> > index c821294e1774..186ac0a79c0a 100644
> > --- a/samples/bpf/task_fd_query_kern.c
> > +++ b/samples/bpf/task_fd_query_kern.c
> 
> samples/bpf/task_fd_query_user.c also needs adjusting, no? Have you
> tried running those samples?
Aplologies, I ran the `tracex3` program, but missed to verify `task_fd_query`. Should I send a V2
where I modify only the `tracex3` ?
