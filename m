Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F067535DC7
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 12:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350760AbiE0KEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 06:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238247AbiE0KEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 06:04:21 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CAA106A56;
        Fri, 27 May 2022 03:04:20 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ck4so7698182ejb.8;
        Fri, 27 May 2022 03:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xRSTmBtHtIY4PjpL0e2GqDS2gPDdmkS49tDAKosAVXU=;
        b=n4MLJQoBakTDPpzTh3wUO7Vs2fY2Dz89UBIBNMvNQMK9sBc9U6Mm2OZxtlwRXPx9td
         NGoCzSyGD7PKMWcjclDaCAI+OKcKDzKlFpSzVPMnq55OSw+eeo+Vpmcezc4al282Oo91
         agoFbeU+aOUxrLi8tUlpmvJX3HhE6wno8m1aC09jOgcmYIUKi2RX/nJMG26YN5hFEfY2
         XgQlDRvvBzrzdr75uF1foXhVt3/hGHzghgPOzfjGbg438sb/JQbgmJRmnucLtSFT9kLB
         AMM2vWmcNjkCUxfzsUCOjRzH7Di2oskSlMGgas3zFeAfTOIXQCcQja7rK0MD2+ekUsIu
         Kv4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=xRSTmBtHtIY4PjpL0e2GqDS2gPDdmkS49tDAKosAVXU=;
        b=QN43s0c6DPz9WMRDHOl4xO2LPVaHg73py3CYE9+PD4mbZa80A7THFPJ1cCn8Q0kZY2
         7fiF7bbVzIVKG6ZLiWC0MJciBsm3eelbMZmeAnBzYRtu/DrhJIM3ERnwPYrimA5Xrg79
         UJ5gEFX2CIGbp3FwzHsx+RmGw86gIes7UvIEhhs3tn8IOPGjj6weyY9XDihKG9cmYpte
         cdnOPMAPpr9qQcFuweC+WbPU5yAnYPcTmrkP72KXcPewY8KPLudwNyyT+l1e9cLhJW7e
         bGz2EAY60gHBvEMjNecTKAqywJguWOiGt/ura266H+AkPQDJnbnTCRmCQulnYRAw3NRF
         heyQ==
X-Gm-Message-State: AOAM533G2ONVP4GErCBBQIASMOp4kU+j+waW5qsXIIaetqTW0pmWQ25T
        ATEI80wfnxiSwiOPExfsseA=
X-Google-Smtp-Source: ABdhPJw7kA2HNU05BoAPuckfDoIpMbjctRC4Y91Ac+KMDOqTR4tMKAXEDeMLnq8bts7rF3ooofhPoA==
X-Received: by 2002:a17:906:7d83:b0:6ce:fee:9256 with SMTP id v3-20020a1709067d8300b006ce0fee9256mr38322696ejo.647.1653645858511;
        Fri, 27 May 2022 03:04:18 -0700 (PDT)
Received: from gmail.com (563BA16F.dsl.pool.telekom.hu. [86.59.161.111])
        by smtp.gmail.com with ESMTPSA id w7-20020a170906130700b006f3ef214dfesm1296659ejb.100.2022.05.27.03.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 03:04:17 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Fri, 27 May 2022 12:04:14 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org
Subject: Re: [PATCH v2] ftrace: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding
 weak function
Message-ID: <YpCiHlBjj99hALbV@gmail.com>
References: <20220525180553.419eac77@gandalf.local.home>
 <Yo7q6dwphFexGuRA@gmail.com>
 <20220526091106.1eb2287a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526091106.1eb2287a@gandalf.local.home>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 26 May 2022 04:50:17 +0200
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> 
> > > The real fix would be to fix kallsyms to not show address of weak
> > > functions as the function before it. But that would require adding code in
> > > the build to add function size to kallsyms so that it can know when the
> > > function ends instead of just using the start of the next known symbol.  
> > 
> > Yeah, so I actually have a (prototype...) objtool based kallsyms 
> > implementation in the (way too large) fast-headers tree that is both faster 
> > & allows such details in principle:
> 
> Nice.
> 
> Will this work for other architectures too?

For those which implement objtool, it certainly should: as we parse through 
each object file during the build, generating kallsyms data structures is 
relatively straightforward.

Objtool availability is a big gating condition though. :-/

[ ... and still Acked-by on -v4 too. ]

Thanks,

	Ingo
