Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BAD2B12F2
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgKLX7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgKLX7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 18:59:37 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74ECFC0613D4;
        Thu, 12 Nov 2020 15:59:37 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id y7so6018599pfq.11;
        Thu, 12 Nov 2020 15:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JDzw04qHC3HVb+vYiy97DsY+gSywxqNYdrSxiwIHGf0=;
        b=X7KW+XGEQY5YhB8HLrxKev6vVoziQ8KHcurF6QFEUK0QuGzkeYJ6qr46JTiJMMeuIO
         c/DPwWFs68uN7UKltQ2rOo+en/buxNPbMUHt9hc5GWUQjMcWuS9gb63nOakDBE0NP6hx
         7AkeiXlGaEX+rKCtteX036PsS8uuA3l1b9hZYdQPFhs7JwNpcO+VWnA6sNcW1LIa62EK
         Y0TUNvpkzF/kofeabWlOonib68CrBP1CVU+FUP7Xc85FgoLgUEkahx9TAL87uMrMjIo4
         2r0UGeg1z20bNOckEnIiaZ54MdNUXzjTr+7sboe00EzoSJg5WeRkL4NczHHecoYdDu3v
         TfXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JDzw04qHC3HVb+vYiy97DsY+gSywxqNYdrSxiwIHGf0=;
        b=aCIA2HU3XuV/iCCUETL39+KMLM2YSL8tgEF2+b9SAdFbihjbURDeHNXVZnzWWfIxQW
         oRxHCL099fkds3KVZxv80BJ+Gi2ngo0WerqggrIx8DFxFAwz9VBkY97g3yXFRQi4gHIi
         mJ8fls02sUNRFlHza4c93mF6SwDsiAyI1UaN0LVzfiy2NUkSmH7DwCgxCsklyPf0dBVY
         +Gmrd2W/8B/XtHcXVK8v1UcG39hc3uRpBqHI4BH9GN1frTKx5QOtlrjSmU2BjMmgmgJ0
         EAC+No7i8lv7s9WkUt1TbkM4GcdrA5XDVHyInQhT6IthYPlkTr/Ra3U4rWIwsNkKpGyU
         7CRw==
X-Gm-Message-State: AOAM533jOOvOvDuLU/WwzOS61vK79Tat28AYtDzY0pod9kTzVVh3faMh
        Z/9oaAaGuHRYciF/71Rfz/o=
X-Google-Smtp-Source: ABdhPJyWLhOzkvtZlVExW8y3GOq9GWDQYpK1fVFoetu82zrEgaIn19tqN8Tsk1udHxQzlnzflKVnUg==
X-Received: by 2002:a17:90b:88b:: with SMTP id bj11mr246103pjb.229.1605225576954;
        Thu, 12 Nov 2020 15:59:36 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:a370])
        by smtp.gmail.com with ESMTPSA id k17sm8797276pji.50.2020.11.12.15.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 15:59:36 -0800 (PST)
Date:   Thu, 12 Nov 2020 15:59:34 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Support for pointers beyond pkt_end.
Message-ID: <20201112235934.gkydiegea4nhin3x@ast-mbp>
References: <20201111031213.25109-1-alexei.starovoitov@gmail.com>
 <20201111031213.25109-2-alexei.starovoitov@gmail.com>
 <5fad89fb649af_2a612088e@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fad89fb649af_2a612088e@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 11:16:11AM -0800, John Fastabend wrote:
> Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> > 
> > This patch adds the verifier support to recognize inlined branch conditions.
> > The LLVM knows that the branch evaluates to the same value, but the verifier
> > couldn't track it. Hence causing valid programs to be rejected.
> > The potential LLVM workaround: https://reviews.llvm.org/D87428
> > can have undesired side effects, since LLVM doesn't know that
> > skb->data/data_end are being compared. LLVM has to introduce extra boolean
> > variable and use inline_asm trick to force easier for the verifier assembly.
> > 
> > Instead teach the verifier to recognize that
> > r1 = skb->data;
> > r1 += 10;
> > r2 = skb->data_end;
> > if (r1 > r2) {
> >   here r1 points beyond packet_end and
> >   subsequent
> >   if (r1 > r2) // always evaluates to "true".
> > }
> > 
> > Tested-by: Jiri Olsa <jolsa@redhat.com>
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >  include/linux/bpf_verifier.h |   2 +-
> >  kernel/bpf/verifier.c        | 129 +++++++++++++++++++++++++++++------
> >  2 files changed, 108 insertions(+), 23 deletions(-)
> > 
> 
> Thanks, we can remove another set of inline asm logic.

Awesome! Please contribute your C examples to selftests when possible.

> Acked-by: John Fastabend <john.fastabend@gmail.com>
>  
> >  	if (pred >= 0) {
> > @@ -7517,7 +7601,8 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
> >  		 */
> >  		if (!__is_pointer_value(false, dst_reg))
> >  			err = mark_chain_precision(env, insn->dst_reg);
> > -		if (BPF_SRC(insn->code) == BPF_X && !err)
> > +		if (BPF_SRC(insn->code) == BPF_X && !err &&
> > +		    !__is_pointer_value(false, src_reg))
> 
> This could have been more specific with !type_is_pkt_pointer() correct? I
> think its fine as is though.

I actually meant to use __is_pointer_value() here for two reasons:
1. to match dst_reg check just few lines above.
2. mark_chain_precision() is for scalars only. If in the future
  is_*_branch_taken() will support other kinds of pointers the more
  precise !type_is_pkt_pointer() check would need to be modified.
  That would be unnecessary code churn.

Thanks for the review!
