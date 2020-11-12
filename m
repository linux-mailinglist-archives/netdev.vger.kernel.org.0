Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72DA22B0DAC
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgKLTQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbgKLTQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:16:21 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13466C0613D1;
        Thu, 12 Nov 2020 11:16:20 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id 79so6669904otc.7;
        Thu, 12 Nov 2020 11:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Sf8Isal/8dq+37wth94G89CIsHbDMtQylm/3MbKWx0I=;
        b=W8mzNPjzvea1D8c03V7HUBSO0Z//U2hCJIDb8Cy7V7r1J7ytwPexktBbgFyPQsUz4/
         tmOjfeA9Cde21B+W02oYIMaCu6S2XhgF18Hwpq1Hlu2Nb1s1UF0BeUu7hLApnUauE6kt
         umdDUKJyKCOS68a4lV5VgEwQ/qe6pkqiHijh6WTIOrolCcA4uuB/gyrbV+yke094Yw0V
         Io9BAGZREAG0bYSXdszEdaLVZRl4WoU4ScDNdAYdu8N0mRc+WbVxgt/C27nqNM0JeDJc
         7UPZUD31L/ihHReU4m6hfNgRhLGOUOZTgqHwOgc3Cx4Zz58nLY9goKx1yiv24GTEdaHM
         7LTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Sf8Isal/8dq+37wth94G89CIsHbDMtQylm/3MbKWx0I=;
        b=DGbPvJ+dTobkpKQfADcamLVc+9f4hY7cmVcFG/CrbpL//o4l40q2JZ8nXeAsSnJjMD
         EqnFHLDJbuzSamBG70RM0zfOevAsRTOsTwC6IVmiMMiiNJURO+eusOFMsThYdzHrYcXo
         3asf7qKb+5tcV/KH5LpesA9ezJtpb1CosBuBPfECt4r5CZErsvFTvDu6BExJgqfyH8aT
         19HM56wOE1LqA+8/H5ONrn5/EVGy5xQYHbdE4khv5uF4qP7+FIO4VN9pEcEdUdKScGC6
         fey8XwyO0/CiPzxDG0KnU4kI/iukNRIWcYydlycEm50jiEwx78WAk9jCx5y600en3pYv
         ToFg==
X-Gm-Message-State: AOAM531DuFF1K8+FS1vXaSRv2dmlnSN/V2EecZTWYU+w05jWmN71XvKY
        XqKqcykCAIIUwwf14tYTJUYDXYsjklP/Kw==
X-Google-Smtp-Source: ABdhPJwly/HLYmkfD1YULNV0i3SaONOp/rS9p2+tDIlXWIn2CK7QvqcgbnMve9X5Ep1pmxa7Us5W5A==
X-Received: by 2002:a05:6830:1af7:: with SMTP id c23mr504601otd.358.1605208579419;
        Thu, 12 Nov 2020 11:16:19 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z19sm1409264otm.58.2020.11.12.11.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 11:16:18 -0800 (PST)
Date:   Thu, 12 Nov 2020 11:16:11 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Message-ID: <5fad89fb649af_2a612088e@john-XPS-13-9370.notmuch>
In-Reply-To: <20201111031213.25109-2-alexei.starovoitov@gmail.com>
References: <20201111031213.25109-1-alexei.starovoitov@gmail.com>
 <20201111031213.25109-2-alexei.starovoitov@gmail.com>
Subject: RE: [PATCH v2 bpf-next 1/3] bpf: Support for pointers beyond pkt_end.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> This patch adds the verifier support to recognize inlined branch conditions.
> The LLVM knows that the branch evaluates to the same value, but the verifier
> couldn't track it. Hence causing valid programs to be rejected.
> The potential LLVM workaround: https://reviews.llvm.org/D87428
> can have undesired side effects, since LLVM doesn't know that
> skb->data/data_end are being compared. LLVM has to introduce extra boolean
> variable and use inline_asm trick to force easier for the verifier assembly.
> 
> Instead teach the verifier to recognize that
> r1 = skb->data;
> r1 += 10;
> r2 = skb->data_end;
> if (r1 > r2) {
>   here r1 points beyond packet_end and
>   subsequent
>   if (r1 > r2) // always evaluates to "true".
> }
> 
> Tested-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/bpf_verifier.h |   2 +-
>  kernel/bpf/verifier.c        | 129 +++++++++++++++++++++++++++++------
>  2 files changed, 108 insertions(+), 23 deletions(-)
> 

Thanks, we can remove another set of inline asm logic.

Acked-by: John Fastabend <john.fastabend@gmail.com>
 
>  	if (pred >= 0) {
> @@ -7517,7 +7601,8 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
>  		 */
>  		if (!__is_pointer_value(false, dst_reg))
>  			err = mark_chain_precision(env, insn->dst_reg);
> -		if (BPF_SRC(insn->code) == BPF_X && !err)
> +		if (BPF_SRC(insn->code) == BPF_X && !err &&
> +		    !__is_pointer_value(false, src_reg))

This could have been more specific with !type_is_pkt_pointer() correct? I
think its fine as is though.

>  			err = mark_chain_precision(env, insn->src_reg);
>  		if (err)
>  			return err;
> -- 
> 2.24.1
> 


