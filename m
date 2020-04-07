Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA101A0438
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 03:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgDGBQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 21:16:06 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:39133 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbgDGBQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 21:16:06 -0400
Received: by mail-qv1-f66.google.com with SMTP id v38so1080657qvf.6;
        Mon, 06 Apr 2020 18:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0ZCPZ0mrFnF08NLYBSeh3n7zB5LOqXY3876GSeecKmM=;
        b=sjVvYFLVbY4Ny2IAXojk0K1yzYtxeCDMFamVaH1mP7pA1s0XYQG7FCHt6gW8iWGgAL
         6CnrDnOMze0l62eKFiuBn7SKl2s9VnUtW9bQzJ3U0IpZe3LmPPvzgapAslSzB6ePmka0
         aSpW/o55fglMvygYM+fJtDUQMjoGEsX/WsktFRS0MNDddmBPl8sG/DvhfZG9rXG3rdV4
         ge/MW4GK/IXrmjd7WzQHWKB1FkopI3aRFVtdIwDmEVEBkM5CyCLKy2k6Fyi9Hs0xgveV
         AmI1nynSWbZRMDFGoVONTB0L6Xg4G9/jClCgyy/gFw7KTdLbsUSYUiFqcu4Md0ovUsQM
         C3+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0ZCPZ0mrFnF08NLYBSeh3n7zB5LOqXY3876GSeecKmM=;
        b=HoCrGMEERCS8BVWtup8dn+HyjX4HxaaibN05HNx5t/u71mcKTBp7qJhEkLHtQ3uNeY
         i5PDYoaUOVCpSSg9JeQ6xDXUN/Egrpprs0os3pB3AmVIHAcpkKUS+CLb2nAF15aIrD0J
         DrQEhjoIz+xuiCaCNJGJfDviNsjyUsOEx14nYiuvMzIeBc9MF8A9YJF7p0WBDmAIMOlF
         NUZ+kQXn+ujiKr44jvUs8vQc5+waijWuqie9MdDfmQMKiw7ehhh0MC/4PT2zQ2BldHRc
         P8c7DIXtcN0C03mRZgiG2PooGSLSLKqe7YU5zymb76mGmkg+E9HRpqyYBx3+UfmyUVrr
         Oljw==
X-Gm-Message-State: AGi0PuYa5VOfPdzQDuHb7pT5DF+C8gtZeHnp/Uv3CUR+x8NVBh6KU7Oh
        FFibabh7/M+7gUdrXgy9ccg=
X-Google-Smtp-Source: APiQypJQwc4ZOKGUFnwXb31oKnHjINpF8TGbxIXW/KpuaZFg0Ofm0/woXh47uGy9Zbmaks1twOU0UA==
X-Received: by 2002:a0c:a181:: with SMTP id e1mr2677712qva.19.1586222165491;
        Mon, 06 Apr 2020 18:16:05 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c091:480::84df])
        by smtp.gmail.com with ESMTPSA id 60sm15873988qtb.95.2020.04.06.18.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 18:16:04 -0700 (PDT)
Date:   Mon, 6 Apr 2020 18:16:01 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/3] bpf: Add support to check if BTF object is nested in
 another object
Message-ID: <20200407011601.526c6i6dyq6lndmf@ast-mbp.dhcp.thefacebook.com>
References: <20200401110907.2669564-1-jolsa@kernel.org>
 <20200401110907.2669564-2-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401110907.2669564-2-jolsa@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 01, 2020 at 01:09:05PM +0200, Jiri Olsa wrote:
> Adding btf_struct_address function that takes 2 BTF objects
> and offset as arguments and checks wether object A is nested
> in object B on given offset.
> 
> This function is be used when checking the helper function
> PTR_TO_BTF_ID arguments. If the argument has an offset value,
> the btf_struct_address will check if the final address is
> the expected BTF ID.
> 
> This way we can access nested BTF objects under PTR_TO_BTF_ID
> pointer type and pass them to helpers, while they still point
> to valid kernel BTF objects.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h   |  3 ++
>  kernel/bpf/btf.c      | 69 +++++++++++++++++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c | 18 +++++++++--
>  3 files changed, 88 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index fd2b2322412d..d3bad7ee60c6 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1196,6 +1196,9 @@ int btf_struct_access(struct bpf_verifier_log *log,
>  		      const struct btf_type *t, int off, int size,
>  		      enum bpf_access_type atype,
>  		      u32 *next_btf_id);
> +int btf_struct_address(struct bpf_verifier_log *log,
> +		     const struct btf_type *t,
> +		     u32 off, u32 exp_id);
>  int btf_resolve_helper_id(struct bpf_verifier_log *log,
>  			  const struct bpf_func_proto *fn, int);
>  
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index d65c6912bdaf..9aafffa57d8b 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -4002,6 +4002,75 @@ int btf_struct_access(struct bpf_verifier_log *log,
>  	return -EINVAL;
>  }
>  
> +int btf_struct_address(struct bpf_verifier_log *log,
> +		       const struct btf_type *t,
> +		       u32 off, u32 exp_id)
> +{
> +	u32 i, moff, mtrue_end, msize = 0;
> +	const struct btf_member *member;
> +	const struct btf_type *mtype;
> +	const char *tname, *mname;
> +
> +again:
> +	tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
> +	if (!btf_type_is_struct(t)) {
> +		bpf_log(log, "Type '%s' is not a struct\n", tname);
> +		return -EINVAL;
> +	}
> +
> +	if (off > t->size) {
> +		bpf_log(log, "address beyond struct %s at off %u size %u\n",
> +			tname, off, t->size);
> +		return -EACCES;
> +	}
> +
> +	for_each_member(i, t, member) {
> +		/* offset of the field in bytes */
> +		moff = btf_member_bit_offset(t, member) / 8;
> +		if (off < moff)
> +			/* won't find anything, field is already too far */
> +			break;
> +
> +		/* we found the member */
> +		if (off == moff && member->type == exp_id)
> +			return 0;
> +
> +		/* type of the field */
> +		mtype = btf_type_by_id(btf_vmlinux, member->type);
> +		mname = __btf_name_by_offset(btf_vmlinux, member->name_off);
> +
> +		mtype = btf_resolve_size(btf_vmlinux, mtype, &msize,
> +					 NULL, NULL);
> +		if (IS_ERR(mtype)) {
> +			bpf_log(log, "field %s doesn't have size\n", mname);
> +			return -EFAULT;
> +		}
> +
> +		mtrue_end = moff + msize;
> +		if (off >= mtrue_end)
> +			/* no overlap with member, keep iterating */
> +			continue;
> +
> +		/* the 'off' we're looking for is either equal to start
> +		 * of this field or inside of this struct
> +		 */
> +		if (btf_type_is_struct(mtype)) {
> +			/* our field must be inside that union or struct */
> +			t = mtype;
> +
> +			/* adjust offset we're looking for */
> +			off -= moff;
> +			goto again;
> +		}

Looks like copy-paste that should be generalized into common helper.

> +
> +		bpf_log(log, "struct %s doesn't have struct field at offset %d\n", tname, off);
> +		return -EACCES;
> +	}
> +
> +	bpf_log(log, "struct %s doesn't have field at offset %d\n", tname, off);
> +	return -EACCES;
> +}
> +
>  static int __btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn,
>  				   int arg)
>  {
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 04c6630cc18f..6eb88bef4379 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3103,6 +3103,18 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
>  	return 0;
>  }
>  
> +static void check_ptr_in_btf(struct bpf_verifier_env *env,
> +			     struct bpf_reg_state *reg,
> +			     u32 exp_id)
> +{
> +	const struct btf_type *t = btf_type_by_id(btf_vmlinux, reg->btf_id);
> +
> +	if (!btf_struct_address(&env->log, t, reg->off, exp_id)) {
> +		reg->btf_id = exp_id;
> +		reg->off = 0;

This doesn't look right.
If you simply overwrite btf_id and off in the reg it will contain wrong info
in any subsequent instruction.
Typically it would be ok, since this reg is a function argument and will be
scratched after the call, but consider:
bpf_foo(&file->f_path, &file->f_owner);
The same base register will be used to construct R1 and R2
and above re-assign will screw up R1.
