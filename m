Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC4D535104
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 16:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347755AbiEZOtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 10:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243362AbiEZOtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 10:49:40 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E3812AE4;
        Thu, 26 May 2022 07:49:36 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id f9so3561275ejc.0;
        Thu, 26 May 2022 07:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zls+MzWfNPZtlXrrhoUFcg/vRk2lvR8P63hFWQr6QVQ=;
        b=VN7XyPmcnf+r0c9uFfso0TaP5OfKEcmXy7GyTZfhd0/K/m4YGQQybFCZdWUeQuvrmK
         z7AiaUvxEbiCvOqLvf42ZUorbp0AbsWGuQcl8vJK6ZE2t5O166B0PyKU/3ACPrVGlD7Y
         3Q+WhPMC6zgre4S6rMKdeW6MTClNoFRUjXXhjtp4OWsQpkgs/VLdcfHmy0PdMO/dWxHf
         oFP6gSNbVSOwXuC45vmwcaBhcB6BhQnbkMh64RtCuUxeDTAUdqkEYoz/hcSs2U1Xojaa
         skwAJRhwpfDt6xDbPdA/FjKWGcbRaHQZlZDq0i38toEqVu3xlQlT++pUYOwiJfd+iKcc
         bFdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zls+MzWfNPZtlXrrhoUFcg/vRk2lvR8P63hFWQr6QVQ=;
        b=VrGqqjRnVoIdylojwLpfhDFjuo6jngA9vAUctQHSZ7WuEOlxF4SC9p/fIwWdxnIaiw
         /4zrSXRksvjPYziek6hTe+ycODX1L2wtC/VtTNNjBAnLNRTrPWD67YW/cA5WmTDfTDTL
         rxt6UISruFoF2jM27NoS228dIX+hPDmk5mP+1LxNEPhyBT6KKcLad/BHNaQH9PTt/ea1
         Rgd/QXFx/QdbIidEGuCq2AKQ/bvl8TUTy2oXGYixZ4HP3EhJN9TZsuvdlYU2ijwdvrcy
         hOb4wSbF4WqET22j+pupNZ42W9Ui5UMEg4DKU5+lk5Ryz/vaIpxzJGFcJXfWQT6+HFCw
         UCmQ==
X-Gm-Message-State: AOAM532OFxTWdFIJngwlrgLzdhoynO/27fo9e6TZ3t7/SnxANm3m0dOh
        8xg9wjZjAblQImLAjIV/fTYgSjpMlKwcgI7z
X-Google-Smtp-Source: ABdhPJyD9f+4ZFEI6jZ541jsLof3Q2dlfauTm/zR+AYc1PlDValxLFKK422K5ikxEdwl32XWGT36Ng==
X-Received: by 2002:a17:907:da3:b0:6fe:f08b:776 with SMTP id go35-20020a1709070da300b006fef08b0776mr17607635ejc.558.1653576575332;
        Thu, 26 May 2022 07:49:35 -0700 (PDT)
Received: from krava (net-93-65-242-160.cust.vodafonedsl.it. [93.65.242.160])
        by smtp.gmail.com with ESMTPSA id b23-20020a1709065e5700b006fe9ba21333sm567992eju.113.2022.05.26.07.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 07:49:34 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Thu, 26 May 2022 16:49:26 +0200
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH] rethook: Reject getting a rethook if RCU is not watching
Message-ID: <Yo+TWcfpyHy55Il5@krava>
References: <165189881197.175864.14757002789194211860.stgit@devnote2>
 <20220524192301.0c2ab08a@gandalf.local.home>
 <20220526232530.cb7d0aed0c60625ef093a735@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526232530.cb7d0aed0c60625ef093a735@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 11:25:30PM +0900, Masami Hiramatsu wrote:
> On Tue, 24 May 2022 19:23:01 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Sat,  7 May 2022 13:46:52 +0900
> > Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > 
> > Is this expected to go through the BPF tree?
> > 
> 
> Yes, since rethook (fprobe) is currently used only from eBPF.
> Jiri, can you check this is good for your test case?

sure I'll test it.. can't see the original email,
perhaps I wasn't cc-ed.. but I'll find it

is this also related to tracing 'idle' functions,
as discussed in here?
  https://lore.kernel.org/bpf/20220515203653.4039075-1-jolsa@kernel.org/

because that's the one I can reproduce.. but I can
certainly try that with your change as well

jirka

> 
> Thank you,
> 
> 
> > -- Steve
> > 
> > 
> > > Since the rethook_recycle() will involve the call_rcu() for reclaiming
> > > the rethook_instance, the rethook must be set up at the RCU available
> > > context (non idle). This rethook_recycle() in the rethook trampoline
> > > handler is inevitable, thus the RCU available check must be done before
> > > setting the rethook trampoline.
> > > 
> > > This adds a rcu_is_watching() check in the rethook_try_get() so that
> > > it will return NULL if it is called when !rcu_is_watching().
> > > 
> > > Fixes: 54ecbe6f1ed5 ("rethook: Add a generic return hook")
> > > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> > > ---
> > >  kernel/trace/rethook.c |    9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > > 
> > > diff --git a/kernel/trace/rethook.c b/kernel/trace/rethook.c
> > > index b56833700d23..c69d82273ce7 100644
> > > --- a/kernel/trace/rethook.c
> > > +++ b/kernel/trace/rethook.c
> > > @@ -154,6 +154,15 @@ struct rethook_node *rethook_try_get(struct rethook *rh)
> > >  	if (unlikely(!handler))
> > >  		return NULL;
> > >  
> > > +	/*
> > > +	 * This expects the caller will set up a rethook on a function entry.
> > > +	 * When the function returns, the rethook will eventually be reclaimed
> > > +	 * or released in the rethook_recycle() with call_rcu().
> > > +	 * This means the caller must be run in the RCU-availabe context.
> > > +	 */
> > > +	if (unlikely(!rcu_is_watching()))
> > > +		return NULL;
> > > +
> > >  	fn = freelist_try_get(&rh->pool);
> > >  	if (!fn)
> > >  		return NULL;
> > 
> 
> 
> -- 
> Masami Hiramatsu (Google) <mhiramat@kernel.org>
