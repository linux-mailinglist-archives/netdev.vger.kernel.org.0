Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197E76A8B5A
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 23:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjCBV5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 16:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjCBV5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 16:57:03 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0D05D456;
        Thu,  2 Mar 2023 13:57:00 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-53cb9ac9470so7449077b3.10;
        Thu, 02 Mar 2023 13:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wtgiWMKGxnYS992aa36LHk2PMydjyTMSKzxMUnwYC9A=;
        b=n3hpj49uvxVbkMybt55rXLvDVwGs/T8QHSzQY4QHx6G6qD+Tmeq13sEPzms/gMlilU
         c1OHfofffJ3au0OA7QeD0DwYigJApRE+ZF90mI2SjeuCRpaanzQ3T/dDayniH2CpFDTT
         75Wbi4BOW3jA5X6fJjgl/Rm0Wezh8zVlcrvOI1iXnIDCbQrU90XGz8buxY4vL2ouTiUR
         0dlqPEDGqoeZ5L60BW9APUBJdMGpJeKNr2fUTukZ7GNKZjfLMCwVbljRZ6vPD2UEYW6U
         FPqFy7na7iOxAEhRHLgtCzKuWLbS8Co8cTTHjDaFX47UpkIj/L3eXakVJSq42NScQ0D1
         rswg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wtgiWMKGxnYS992aa36LHk2PMydjyTMSKzxMUnwYC9A=;
        b=y8B84u/j1OAPOH622obwJBUfcRpQ4rExpP8E5/cZKnum0/sOBsql1h1Qt8ocxZM7sP
         emvmKqMIaxJevHHHbB491TbCJmMC4H+tvJdekRWsdEB5Jjp2U44oU6GZsnsZxLuvK3R3
         WPr0BOySrBFVlmyMBRq2DFL1WjYd14l34gyNl0kXVKdcvBO9QbmwBARvvtASuo75zbBb
         1RJlTZFj2AcUQCDC42r6RXUdw57lndMcrp64v7kOB6OKIOcItspeE9bzv7jsQYF1deOM
         Ckw2WqL6Jdmh+U7lD5Ws7g94h+7rPXKGnkXyAwRHPiDExuBz8jeSnR4z7Xa/KicmXRZd
         ADgg==
X-Gm-Message-State: AO0yUKVBm2baeMdq7Gc5iUYK3Xan+xjN5wZE/n33KZ0gl9ETn+Gbh17i
        jwOdnBNz5qbhwFPkHXIGy/zr5MTInrY=
X-Google-Smtp-Source: AK7set9UqAxBvr5kIPdYoSJkv6cql6PZFbTEpyzaV8B/QzDmogIgt0Y/X9bt3rNdke2VlkQfyreUug==
X-Received: by 2002:a62:79d7:0:b0:5a9:b3a3:c8d8 with SMTP id u206-20020a6279d7000000b005a9b3a3c8d8mr12131302pfc.0.1677792230040;
        Thu, 02 Mar 2023 13:23:50 -0800 (PST)
Received: from MacBook-Pro-6.local ([2620:10d:c090:500::4:2c84])
        by smtp.gmail.com with ESMTPSA id 21-20020a631955000000b00502f017657dsm111782pgz.83.2023.03.02.13.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 13:23:49 -0800 (PST)
Date:   Thu, 2 Mar 2023 13:23:44 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     David Vernet <void@manifault.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v4 bpf-next 6/6] bpf: Refactor RCU enforcement in the
 verifier.
Message-ID: <20230302212344.snafoop5hytngskk@MacBook-Pro-6.local>
References: <20230301223555.84824-1-alexei.starovoitov@gmail.com>
 <20230301223555.84824-7-alexei.starovoitov@gmail.com>
 <ZAAgfwgo5GU8V28f@maniforge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAAgfwgo5GU8V28f@maniforge>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 10:05:19PM -0600, David Vernet wrote:
> >  
> > @@ -6373,7 +6382,7 @@ static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
> >  			stype = btf_type_skip_modifiers(btf, mtype->type, &id);
> >  			if (btf_type_is_struct(stype)) {
> >  				*next_btf_id = id;
> > -				*flag = tmp_flag;
> > +				*flag |= tmp_flag;
> 
> Now that this function doesn't do a full write of the variable, the
> semantics have changed such that the caller has to initialize the
> variable on behalf of bpf_struct_walk(). This makes callers such as
> btf_struct_ids_match() (line 6503) have random crud in the pointer.
> Doesn't really matter for that case because the variable isn't used
> anyways, but it seems slightly less brittle to initialize *flag to 0 at
> the beginning of the function to avoid requiring the caller to
> initialize it. Wdyt?

Good idea. Fixed.

> > +BTF_ID_FLAGS(func, bpf_cpumask_copy, KF_TRUSTED_ARGS | KF_RCU)
> > +BTF_ID_FLAGS(func, bpf_cpumask_any, KF_TRUSTED_ARGS | KF_RCU)
> > +BTF_ID_FLAGS(func, bpf_cpumask_any_and, KF_TRUSTED_ARGS | KF_RCU)
> 
> It's functionally the same, but could you please remove KF_TRUSTED_ARGS
> given that it's accepted for KF_RCU? We should ideally be removing
> KF_TRUSTED_ARGS altogether soon(ish) anyways, so might as well do it
> here.

done.

> > +		if (type_is_trusted(env, reg, off)) {
> > +			flag |= PTR_TRUSTED;
> > +		} else if (in_rcu_cs(env) && !type_may_be_null(reg->type)) {
> > +			if (type_is_rcu(env, reg, off)) {
> > +				/* ignore __rcu tag and mark it MEM_RCU */
> > +				flag |= MEM_RCU;
> > +			} else if (flag & MEM_RCU) {
> > +				/* __rcu tagged pointers can be NULL */
> > +				flag |= PTR_MAYBE_NULL;
> 
> I'm not quite understanding the distinction between manually-specified
> RCU-safe types being non-nullable, vs. __rcu pointers being nullable.
> Aren't they functionally the exact same thing, with the exception being
> that gcc doesn't support __rcu, so we've decided to instead manually
> specify them for some types that we know we need until __rcu is the
> default mechanism?  If the plan is to remove these macros once gcc
> supports __rcu, this could break some programs that are expecting the
> fields to be non-NULL, no?

BTF_TYPE_SAFE_RCU is a workaround for now.
We can make it exactly like __rcu, but it would split
the natural dereference of task->cgroups->dfl_cgrp into
two derefs with extra !=NULL check in-between which is ugly and unnecessary.

> I see why we're doing this in the interim -- task->cgroups,
> css->dfl_cgrp, task->cpus_ptr, etc can never be NULL. The problem is
> that I think those are implementation details that are separate from the
> pointers being RCU safe. This seems rather like we need a separate
> non-nullable tag, or something to that effect.

Right. It is certainly an implementation detail.
We'd need a new __not_null_mostly tag or __not_null_after_init.
(similar to __read_mostly and __ro_after_init).
Where non-null property is true when bpf get to see these structures.

The current allowlist is incomplete and far from perfect.
I suspect we'd need to add a bunch more during this release cycle.
This patch is aggressive in deprecation of old ptr_to_btf_id.
Some breakage is expected. Hence the timing to do it right now
at the beginning of the cycle.

> >  		flag &= ~PTR_TRUSTED;
> 
> Do you know what else is left for us to fix to be able to just set
> PTR_UNTRUSTED here?

All "ctx->" derefs. check_ctx_access() returns old school PTR_TO_BTF_ID.
We can probably mark all of them as trusted, but need to audit a lot of code.
I've also played with forcing helpers with ARG_PTR_TO_BTF_ID to be trusted,
but still too much selftest breakage to even look at.

The patch also has:
+                       if (BTF_INFO_KIND(mtype->info) == BTF_KIND_UNION &&
+                           btf_type_vlen(mtype) != 1)
+                               /*
+                                * walking unions yields untrusted pointers
+                                * with exception of __bpf_md_ptr and other
+                                * unions with a single member
+                                */
+                               *flag |= PTR_UNTRUSTED;
this is in particular to make skb->dev deref to return untrusted.
In this past we allowed skb->dev->ifindex to go via PTR_TO_BTF_ID and PROBE_MEM.
It's safe, but not clean. And we have no safe way to get trusted 'dev' to pass into helpers.
It's time to clean this all up as well, but it will require rearranging fields in sk_buff.
Lots of work ahead.
