Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8F54E9F2A
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 20:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244114AbiC1SwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 14:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238632AbiC1SwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 14:52:24 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BF663BEB;
        Mon, 28 Mar 2022 11:50:43 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id b15so18024559edn.4;
        Mon, 28 Mar 2022 11:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=QBjsQzDn/Ks8dEnRIQa6PY5tXIrfsz9krS9p9ZK8/XE=;
        b=b2E/f5wjBThWD7lD8ARcB7ZQywDG7RV7OUTxgU48pkDQ505XP5H7kNUFkv7BARPn6Z
         Ajyu4z9DA9vHcLqR3QDuXeps1dE57qLvy9VIkzN03GLxs+4WeTBDJncOiTKoBKcKdHxl
         m59rmUpiaYsI+QNZCThYyKkl3ovUntoYnNYTlyUXJdq+JTN3bOO9RxODkv3R2V26HQjh
         B4Fo6XxH/HrCbb/x/GlqCGkjh2OVFC2ldMr4CVvC8QmtXGUyMCVfRn8bM39oUOPE9GGM
         o6m3V/GSqk3xJ/RXcJzI37LlbOOe3Yg0mSwnRpU2I2hX18mX6GHcgZCfUzktesl+HXtY
         pSRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=QBjsQzDn/Ks8dEnRIQa6PY5tXIrfsz9krS9p9ZK8/XE=;
        b=sGsv7M0MBVLTB1rRebkB5b/WTUwEhdrX/+HIrhC7c4EGNlwis756T3kQqBTQ/GT6hU
         BXRK5PSikIceZQGajZrrO+Dyqs3esBlaLbViQghXMjPGqCrEAOUTBsOw8+VR0Q8eoDi4
         D2iJEd3Ot7vzGB2xW7DB1nGdA/gtpOSoGnOypU7PKcg0mNG3xLb2bDAxWznLXPTyjFIQ
         GxhZMDTs0yh8Vi/hRG355FrNxOnJqKgc9zxWTdBLThgYgWi7WCfkfjRESd7+wxVP/Rew
         7D6HYdO/LefZaOxWzqCTlmvXqubZm4GU1UZaZRu8hTW74WGioH/Csv/7DNgjsGDsIiD3
         3Q7w==
X-Gm-Message-State: AOAM533xuiLfc67mie6gND4grDcPVqEyDWBDAHhJPzwQtCbRgs59uJIR
        vZHAFSE1tnFizONQyrwH8Ac=
X-Google-Smtp-Source: ABdhPJzq1e5bO0iEkX1AX4QVUpDslEL1AYpBi/MYyOZA2VT67s6cFn4fqjw6jrnEUHtYHP42rVccyA==
X-Received: by 2002:a05:6402:1293:b0:418:fe9d:99c3 with SMTP id w19-20020a056402129300b00418fe9d99c3mr18020423edv.146.1648493442141;
        Mon, 28 Mar 2022 11:50:42 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id j21-20020a170906255500b006e08c4862ccsm5339499ejb.96.2022.03.28.11.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 11:50:41 -0700 (PDT)
Date:   Mon, 28 Mar 2022 20:50:39 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH] bpftool: Fix generated code in codegen_asserts
Message-ID: <YkIDfzcUqKed7rCq@krava>
References: <20220328083703.2880079-1-jolsa@kernel.org>
 <9a040393-e478-d14d-8cfd-14dd08e09be0@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9a040393-e478-d14d-8cfd-14dd08e09be0@fb.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 28, 2022 at 08:41:18AM -0700, Yonghong Song wrote:
> 
> 
> On 3/28/22 1:37 AM, Jiri Olsa wrote:
> > Arnaldo reported perf compilation fail with:
> > 
> >    $ make -k BUILD_BPF_SKEL=1 CORESIGHT=1 PYTHON=python3
> >    ...
> >    In file included from util/bpf_counter.c:28:
> >    /tmp/build/perf//util/bpf_skel/bperf_leader.skel.h: In function ‘bperf_leader_bpf__assert’:
> >    /tmp/build/perf//util/bpf_skel/bperf_leader.skel.h:351:51: error: unused parameter ‘s’ [-Werror=unused-parameter]
> >      351 | bperf_leader_bpf__assert(struct bperf_leader_bpf *s)
> >          |                          ~~~~~~~~~~~~~~~~~~~~~~~~~^
> >    cc1: all warnings being treated as errors
> > 
> > If there's nothing to generate in the new assert function,
> > we will get unused 's' warn/error, adding 'unused' attribute to it.
> 
> If there is nothing to generate, should we avoid generating
> the assert function itself?

good point, will check

jirka

> 
> > 
> > Cc: Delyan Kratunov <delyank@fb.com>
> > Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Fixes: 08d4dba6ae77 ("bpftool: Bpf skeletons assert type sizes")
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   tools/bpf/bpftool/gen.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > index 7ba7ff55d2ea..91af2850b505 100644
> > --- a/tools/bpf/bpftool/gen.c
> > +++ b/tools/bpf/bpftool/gen.c
> > @@ -477,7 +477,7 @@ static void codegen_asserts(struct bpf_object *obj, const char *obj_name)
> >   	codegen("\
> >   		\n\
> >   		__attribute__((unused)) static void			    \n\
> > -		%1$s__assert(struct %1$s *s)				    \n\
> > +		%1$s__assert(struct %1$s *s __attribute__((unused)))	    \n\
> >   		{							    \n\
> >   		#ifdef __cplusplus					    \n\
> >   		#define _Static_assert static_assert			    \n\
