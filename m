Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE6B54F6AF
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 13:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381109AbiFQL2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 07:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380502AbiFQL2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 07:28:01 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F35659A;
        Fri, 17 Jun 2022 04:27:58 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id g25so8168677ejh.9;
        Fri, 17 Jun 2022 04:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+xDLkTUrpIGE4sdGGpQ0KY6HGXBhkSTOiPmSfBkAp5k=;
        b=TCuRdB8VNcvWdnfJqBpCQQEjN8N9CIUOHyN8ThmgD7De0DKDCpReBrE4+LKP9ZVflZ
         RYxg1fvr3G4Ss8FgXvg1Rh8JPxSw39CkpeKAOeefcpCcT2emXZnoZz/s+PCQhqPzUO4K
         tgunpJTO30yDyp2Cs1KG4kTOcXZDFfD6W+G2EnBkhlbZH5IeEK7HBLuKI5d3YTVTa4zv
         9p+dCX976pXpMlTP8WShtJFfCaeivhMH3ljSq3uRVUehyj/8LWmMh1c/fWco0YN4985i
         nRiEYdIVBN3owBHtx7ea8aC7y96CjXCyw90f99CLLGWVoou9HCLUMJuJmxt4DASQsfoO
         cMfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+xDLkTUrpIGE4sdGGpQ0KY6HGXBhkSTOiPmSfBkAp5k=;
        b=OjoZ5hAiLbKcuFf7PuBXk1PBFebQccgQ4QjsGSd74zryVQAPZVfSlt20K8qPQa5uO4
         rubswdN2/84h+KAA+OR6yEwv/Jteb9nGIvH/bfFoxHE61LNBSlW0C5TwjxyByv3mzajw
         HpQYG6jee7qGgzqftdbLDfEhvJVtdYr03IQrYnzlKYfcWkAPjTx8CqOy83TIPxWZ8CCL
         DSR3wKRzA9FnYK4inSQp5sBgAGGeHSbQLIRi52/5JohkL+I9NuEon6Fk3NrTcXysLC8y
         LlBMFLz0CrTaTfJJuSaiaBf3CWcxDBZRq2wna1b7JAtl6N1KzsIYzq7KTtxH4VRZddVM
         jUVQ==
X-Gm-Message-State: AJIora9IFRLJcbxh2n7SZjt0PFSaYTkXGJ33wmqAzcuqbawJbjVHKJ2m
        kpdtirfOhbgj0m1ZSC1LK79HrF5s9Y8=
X-Google-Smtp-Source: AGRyM1sVMoDeVGIVOiBygy8ZNHe4NgUk2yZVZz8h6NeBnaTDM0Ve2cZvsAZ5uuhI60r31L8B2x4u+w==
X-Received: by 2002:a17:907:9805:b0:710:858f:ae0d with SMTP id ji5-20020a170907980500b00710858fae0dmr8651090ejc.360.1655465276533;
        Fri, 17 Jun 2022 04:27:56 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id 18-20020a170906211200b006fea43db5c1sm2072128ejt.21.2022.06.17.04.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 04:27:56 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 17 Jun 2022 13:27:54 +0200
To:     "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf v2 0/2] rethook: Reject getting a rethook if RCU is
 not watching
Message-ID: <YqxlOuz8xur5xqYf@krava>
References: <165461825202.280167.12903689442217921817.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165461825202.280167.12903689442217921817.stgit@devnote2>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 08, 2022 at 01:10:52AM +0900, Masami Hiramatsu (Google) wrote:
> Hi,
> 
> Here is the 2nd version of the patches to reject rethook if RCU is
> not watching. The 1st version is here;
> 
> https://lore.kernel.org/all/165189881197.175864.14757002789194211860.stgit@devnote2/
> 
> This is actually related to the idle function tracing issue
> reported by Jiri on LKML (*)
> 
> (*) https://lore.kernel.org/bpf/20220515203653.4039075-1-jolsa@kernel.org/
> 
> Jiri reported that fprobe (and rethook) based kprobe-multi bpf
> trace kicks "suspicious RCU usage" warning. This is because the
> RCU operation is used in the kprobe-multi handler. However, I
> also found that the similar issue exists in the rethook because
> the rethook uses RCU operation.
> 
> I added a new patch [1/2] to test this issue by fprobe_example.ko.
> (with this patch, it can avoid using printk() which also involves
> the RCU operation.)
> 
>  ------
>  # insmod fprobe_example.ko symbol=arch_cpu_idle use_trace=1 stackdump=0 
>  fprobe_init: Planted fprobe at arch_cpu_idle
>  # rmmod fprobe_example.ko 
>  
>  =============================
>  WARNING: suspicious RCU usage
>  5.18.0-rc5-00019-gcae4ec21e87a-dirty #30 Not tainted
>  -----------------------------
>  include/trace/events/lock.h:37 suspicious rcu_dereference_check() usage!
>  
>  other info that might help us debug this:
>  
>  rcu_scheduler_active = 2, debug_locks = 1
>  
>  
>  RCU used illegally from extended quiescent state!
>  no locks held by swapper/0/0.
>  
>  stack backtrace:
>  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.18.0-rc5-00019-gcae4ec21e87a-dirty #30
>  ------
>  
> After applying [2/2] fix (which avoid initializing rethook on
> function entry if !rcu_watching()), this warning was gone.
> 
>  ------
>  # insmod fprobe_example.ko symbol=arch_cpu_idle use_trace=1 stackdump=0
>  fprobe_init: Planted fprobe at arch_cpu_idle
>  # rmmod fprobe_example.ko 
>  fprobe_exit: fprobe at arch_cpu_idle unregistered. 225 times hit, 230 times missed
>  ------
> 
> Note that you can test this program until the arch_cpu_idle()
> is marked as noinstr. After that, the function can not be
> traced.
> 
> Thank you,
> 
> ---
> 
> Masami Hiramatsu (Google) (2):
>       fprobe: samples: Add use_trace option and show hit/missed counter
>       rethook: Reject getting a rethook if RCU is not watching

LGTM

Acked-by: Jiri Olsa <jolsa@kernel.org>

jirka

> 
> 
>  kernel/trace/rethook.c          |    9 +++++++++
>  samples/fprobe/fprobe_example.c |   21 +++++++++++++++++----
>  2 files changed, 26 insertions(+), 4 deletions(-)
> 
> --
> Signature
