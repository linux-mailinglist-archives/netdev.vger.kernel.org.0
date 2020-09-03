Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6FA25C9A4
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 21:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgICTpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 15:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgICTpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 15:45:08 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9ACFC061244;
        Thu,  3 Sep 2020 12:45:08 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mw10so1966139pjb.2;
        Thu, 03 Sep 2020 12:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n7mJSWhkBJhBXShSLzoJkI/HuFZrSq7ogCejn+AkwO0=;
        b=H5+G2OK3Ta7MLW6rjCK4kdGQKfMDbbE3ABp251/mX8Zxxto2N98DG2klkLkxdi9p7v
         /3PQ7iLBwTeeB8uWm4hVvAv6CenlZM2zWNBlemyFXDZtDos/WIhCqIfIDf/tQMYV/5tZ
         v59PIp/8KaXH0EO9JBS2bT0pcS/lo3NMLLGB5Bu970WfllR88sooqv0a8W+XzE8PCf9U
         S5Av7swRlY4aIW0kYYcmX6giNLn8/umerQHm3zuA5fL2k8Sbt0vMsyW5lW2cJpoRdcsf
         yE4pfMCnVsZP5qvHOPwmiTiB026Oz+ABSua0hu++H2TAnUrkC8hMaNQJxPNvpdMgrEuG
         9GVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n7mJSWhkBJhBXShSLzoJkI/HuFZrSq7ogCejn+AkwO0=;
        b=qjiC+tWTxjQiHrXLrE2GOGk250B+wX2+tTKi7E5dB6CLzL6USigdaMRs161YI20Ny7
         /B4/XLgrTSVKiX3jhvTZm4dTz420x4O/y1m4I9TDMMdg/hD32roJNd5XEncrIkkp4tHt
         Ng0E1HaL2jSN58idPAfB2kGn3CsouGZlYeoQ/f2PQFMRXN6R0hxousKF1bRiqEo6KWos
         kiviTjlyeNl3dftc9PpI0FheL5O37yFh7hL/A+qM2ww72Jaz0zga713u/LxPUf0ECE9u
         VFbtWqrxcPkov5Lky+knWmTEdM3Pk/6MAxKXKiYOAYjf6RZ6wEwXjoLOLyg+MJtMKMik
         XGMw==
X-Gm-Message-State: AOAM530iD2arydL9AN+vMU0BNMhmwzmwJbMoMxGUpkgkSjTKZwN35uFH
        zoEI+V2sfNIuokDYVYk1EM4=
X-Google-Smtp-Source: ABdhPJyAiSobhOZbaKITM3bJRQfJhzq3v5ZzaGC9p2NwGzx6LKuZpKE676uIARfMkQ72k04QPA+Lpg==
X-Received: by 2002:a17:90b:30cd:: with SMTP id hi13mr4817477pjb.82.1599162307576;
        Thu, 03 Sep 2020 12:45:07 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:7ac4])
        by smtp.gmail.com with ESMTPSA id v17sm3960294pfn.24.2020.09.03.12.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 12:45:06 -0700 (PDT)
Date:   Thu, 3 Sep 2020 12:45:04 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com
Subject: Re: [PATCH v7 bpf-next 5/7] bpf: limit caller's stack depth 256 for
 subprogs with tailcalls
Message-ID: <20200903194504.yhx6wpz6wayxb6mg@ast-mbp.dhcp.thefacebook.com>
References: <20200902200815.3924-1-maciej.fijalkowski@intel.com>
 <20200902200815.3924-6-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902200815.3924-6-maciej.fijalkowski@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 02, 2020 at 10:08:13PM +0200, Maciej Fijalkowski wrote:
> Protect against potential stack overflow that might happen when bpf2bpf
> calls get combined with tailcalls. Limit the caller's stack depth for
> such case down to 256 so that the worst case scenario would result in 8k
> stack size (32 which is tailcall limit * 256 = 8k).
> 
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  include/linux/bpf_verifier.h |  1 +
>  kernel/bpf/verifier.c        | 28 ++++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index 53c7bd568c5d..5026b75db972 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -358,6 +358,7 @@ struct bpf_subprog_info {
>  	u32 start; /* insn idx of function entry point */
>  	u32 linfo_idx; /* The idx to the main_prog->aux->linfo */
>  	u16 stack_depth; /* max. stack depth used by this function */
> +	bool has_tail_call;
>  };
>  
>  /* single container for all structs
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 8f9e95f5f73f..b12527d87edb 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -1490,6 +1490,8 @@ static int check_subprogs(struct bpf_verifier_env *env)
>  	for (i = 0; i < insn_cnt; i++) {
>  		u8 code = insn[i].code;
>  
> +		if (insn[i].imm == BPF_FUNC_tail_call)
> +			subprog[cur_subprog].has_tail_call = true;

It will randomly match on other opcodes.
This check probably should be moved few lines down after BPF_JMP && BPF_CALL &&
insn->src_reg != BPF_PSEUDO_CALL.

Another option would be to move it to check_helper_call(), since it
already matches on:
if (func_id == BPF_FUNC_tail_call) {
                err = check_reference_leak(env);
but adding find_subprog() there to mark seems less efficient than
doing it during check_subprogs().

>  		if (BPF_CLASS(code) != BPF_JMP && BPF_CLASS(code) != BPF_JMP32)
>  			goto next;
>  		if (BPF_OP(code) == BPF_EXIT || BPF_OP(code) == BPF_CALL)
