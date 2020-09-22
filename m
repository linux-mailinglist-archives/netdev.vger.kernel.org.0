Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C04C2737D6
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 03:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbgIVBKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 21:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728824AbgIVBKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 21:10:45 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4645EC061755;
        Mon, 21 Sep 2020 18:10:45 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id fa1so685145pjb.0;
        Mon, 21 Sep 2020 18:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=piEYEPDVYTV6Frl84AUWP5zljGpF1ezI4z50SrkPnOA=;
        b=p9/TgrjchwtCQiXbkp04qoT7C3J3djolZB4sIkRQgZZHIkDktLgOMQAN7e4Hb2+Nys
         quWe+arZVuOXupV3WQRHKuQsW5cHzWxDGYg86sXc3PBIwRITrA4qsyF0+5LZMiY0cEXF
         Hhg+lbHjtelXwfEnk893K5zEQxsSljjqfxAWMvSuhaCyYFYLhhREBeKd7vpiy6yTctZ3
         j8+yvxlfKJ66o3z2vXRfw4gUclNLhio3goDD4NCY+ZPv73WE3wXFKzwwjYnc/z35wGQn
         aKsTHNrqUITlmM5yQ/rnFhFUHhMIFWpUTQ7NfLDzeQk23LmtiA1QKgJBGcam3QOsluS8
         7wsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=piEYEPDVYTV6Frl84AUWP5zljGpF1ezI4z50SrkPnOA=;
        b=b4WZah6x9WqDJYKI+j8xf8kOOj2JO8ENM0y2H6P0YXZHJmSq6LWAWPWMS/yGCoduvA
         Dyxs+rr6F8fxT8pJsAISYogXfFSVigVG40W1l2hxtOrCCt8/0ZMNGAuG+4yn3siw9KnX
         Y2hYTa42hGfn9zzjvNWhXKN6j9pzdVPoQSjHAi9ru3g8eFBdVqKGdhV3qPpo8MWbpbDU
         aRHpzWd0TE3POFddX7WMdVhTWnnH1Y2uX3Rj3HWcTMTlh8bPRbdexZ4Z4O151i0d/jM+
         8FPjbzyXAeD9nu3wcWh00QwKFNM3vAQEC6s+y/8oFKjjOkbQMmbpzBIRPAmO4SR4enwc
         fpEQ==
X-Gm-Message-State: AOAM531cGsq7gl0KWkqHY7ihjcc6SC7Mu8iXZS/kDFoqjJnVuBW0ejHt
        FrP2NubslUetgMasbQy6EUo=
X-Google-Smtp-Source: ABdhPJwuN80Ergt/E6VP1yecgI+QBxNwjNaZf/N3b+hWuGYE3oWUpEfbL788cG/CxeCuAWdrsU2PLg==
X-Received: by 2002:a17:90a:fb52:: with SMTP id iq18mr1735818pjb.162.1600737044712;
        Mon, 21 Sep 2020 18:10:44 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:b927])
        by smtp.gmail.com with ESMTPSA id u71sm13503048pfc.43.2020.09.21.18.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 18:10:43 -0700 (PDT)
Date:   Mon, 21 Sep 2020 18:10:40 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com,
        linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        acme@kernel.org
Subject: Re: [PATCH v5 bpf-next 5/6] bpf: add bpf_seq_btf_write helper
Message-ID: <20200922011040.osoccsppdljfam4g@ast-mbp.dhcp.thefacebook.com>
References: <1600436075-2961-1-git-send-email-alan.maguire@oracle.com>
 <1600436075-2961-6-git-send-email-alan.maguire@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600436075-2961-6-git-send-email-alan.maguire@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 02:34:34PM +0100, Alan Maguire wrote:
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 9b89b67..c0815f1 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3614,6 +3614,15 @@ struct bpf_stack_build_id {
>   *		The number of bytes that were written (or would have been
>   *		written if output had to be truncated due to string size),
>   *		or a negative error in cases of failure.
> + *
> + * long bpf_seq_btf_write(struct seq_file *m, struct btf_ptr *ptr, u32 ptr_size, u64 flags)
> + *	Description
> + *		Use BTF to write to seq_write a string representation of
> + *		*ptr*->ptr, using *ptr*->type name or *ptr*->type_id as per
> + *		bpf_btf_snprintf() above.  *flags* are identical to those
> + *		used for bpf_btf_snprintf.
> + *	Return
> + *		0 on success or a negative error in case of failure.
>   */
>  #define __BPF_FUNC_MAPPER(FN)		\
>  	FN(unspec),			\
> @@ -3766,6 +3775,7 @@ struct bpf_stack_build_id {
>  	FN(d_path),			\
>  	FN(copy_from_user),		\
>  	FN(btf_snprintf),		\
> +	FN(seq_btf_write),		\

bpf_btf_ prefix is a bit mouthful.

May be bpf_print_btf() and bpf_seq_print_btf() ?

> -void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
> -			struct seq_file *m)
> +int btf_type_seq_show_flags(const struct btf *btf, u32 type_id, void *obj,
> +			struct seq_file *m, u64 flags)
>  {
>  	struct btf_show sseq;
>  
>  	sseq.target = m;
>  	sseq.showfn = btf_seq_show;
> -	sseq.flags = BTF_SHOW_NONAME | BTF_SHOW_COMPACT | BTF_SHOW_ZERO |
> -		     BTF_SHOW_UNSAFE;
> +	sseq.flags = flags;

could you roll this change into patch 2?

>  
> -BPF_CALL_5(bpf_btf_snprintf, char *, str, u32, str_size, struct btf_ptr *, ptr,
> -	   u32, btf_ptr_size, u64, flags)
> +static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
> +				  u64 flags, const struct btf **btf,
> +				  s32 *btf_id)

Similarly pls introduce bpf_print_prepare() helper in the patch 3 right away.
It reads odd when something that was just introduced in the previous patch
gets refactored in the next.

The rest looks great to me.
Please address build bot issues and respin.
