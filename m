Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F68277D1A
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgIYAme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgIYAme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 20:42:34 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB51CC0613CE;
        Thu, 24 Sep 2020 17:42:33 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x22so1407235pfo.12;
        Thu, 24 Sep 2020 17:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+powH/NZMvQuXjnBMTSajRNp+zvL8Zx326js1nzMJMY=;
        b=pgWhZiYHP6aKFn9msBnbnfp5w3TUkGvZ1CIF7N+uRE6hYTPaFP+gLjc+myLaRL7ROj
         5WbKXasafJcu3NaLbnEvv/KMxrVVIWvOYVyNDG9bOxKp3yfEaEdc6EoG2Msk+IgcKlC7
         5foJveBhrcXk1OsKIeUFsA3oJoDKCWBFoDP8reppLd1Yxb/NJJGCW1bNo9PJ7wUjY5mf
         DdXV8M5HFxMtH1Cos/8C3EcMdIulfMKOczaEgsyH3Bw/XU5mxIa1TxGWCj7bF6yZ/ZCG
         uuiY0JM6i7aXoqBZHiugQJXm7TIM1ZX5I0tqFvFmRUa9iaB0rcEf8F2CLZBwRLrLhLOw
         oFRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+powH/NZMvQuXjnBMTSajRNp+zvL8Zx326js1nzMJMY=;
        b=uDjtRzWGLJ3PbcL/AduLQlfMJIs0uKEZ5tekgQb8e01v101kB/rheZhWmZjPvhHjYj
         ddZ4+d3FcGHtsolUBZ4o/vFileZqqcJlSeFmy95v7/KUiAuW5weEZO0VOjmQ6lx6F76g
         tRycsIlSDaFw9toNO/1n5DxhQZMC+qjog01Pjzedt22tc+Q+HcUmezAXRBegLHDBaBMO
         IifyK45yQ8Nj3tyqrdRqZj/idxjHNtYs1bJO98hqig29CmU6FDVs4GhEwiXu5dMIy8eC
         HEE3NpWYCOEHpgxlE8vZBZBl6J+/L8Sr2ySLwVhopHoJiqu1AhAqSmF5Vq/KUTAS8flp
         xcqg==
X-Gm-Message-State: AOAM533353mvD8gGc2nhyAqiXyzmZJ2iO3xWLC4iTTALjt8vyTGNoKiY
        4BC3jomm/YkKKBhYnZ+qvpM=
X-Google-Smtp-Source: ABdhPJzIQMgfdCv1Hybed7eHSxZ/ZnIzeyJ3+9YDxi6wvp8cgLMLUcO1ihhQu+hfrmiO253i2vYwoQ==
X-Received: by 2002:a17:902:7144:b029:d1:e5e7:be22 with SMTP id u4-20020a1709027144b02900d1e5e7be22mr1659323plm.85.1600994553413;
        Thu, 24 Sep 2020 17:42:33 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:49ed])
        by smtp.gmail.com with ESMTPSA id 126sm582972pfg.192.2020.09.24.17.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 17:42:32 -0700 (PDT)
Date:   Thu, 24 Sep 2020 17:42:29 -0700
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
Subject: Re: [PATCH v6 bpf-next 3/6] bpf: add bpf_snprintf_btf helper
Message-ID: <20200925004229.memxz26rt4jkzd4m@ast-mbp.dhcp.thefacebook.com>
References: <1600883188-4831-1-git-send-email-alan.maguire@oracle.com>
 <1600883188-4831-4-git-send-email-alan.maguire@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600883188-4831-4-git-send-email-alan.maguire@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 06:46:25PM +0100, Alan Maguire wrote:
> +
> +static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
> +				  u64 flags, const struct btf **btf,
> +				  s32 *btf_id)
> +{
> +	u8 btf_kind = BTF_KIND_TYPEDEF;
> +	char type_name[KSYM_NAME_LEN];
> +	const struct btf_type *t;
> +	const char *btf_type;
> +	int ret;
> +
> +	if (unlikely(flags & ~(BTF_F_ALL)))
> +		return -EINVAL;
> +
> +	if (btf_ptr_size != sizeof(struct btf_ptr))
> +		return -EINVAL;
> +
> +	*btf = bpf_get_btf_vmlinux();
> +
> +	if (IS_ERR_OR_NULL(*btf))
> +		return PTR_ERR(*btf);
> +
> +	if (ptr->type != NULL) {
> +		ret = copy_from_kernel_nofault(type_name, ptr->type,
> +					       sizeof(type_name));

nofault copy from bpf program global data... hmm...
I guess that works, but...

> +		if (ret)
> +			return ret;
> +
> +		btf_type = type_name;
> +
> +		if (strncmp(btf_type, "struct ", strlen("struct ")) == 0) {
> +			btf_kind = BTF_KIND_STRUCT;
> +			btf_type += strlen("struct ");
> +		} else if (strncmp(btf_type, "union ", strlen("union ")) == 0) {
> +			btf_kind = BTF_KIND_UNION;
> +			btf_type += strlen("union ");
> +		} else if (strncmp(btf_type, "enum ", strlen("enum ")) == 0) {
> +			btf_kind = BTF_KIND_ENUM;
> +			btf_type += strlen("enum ");
> +		}
> +
> +		if (strlen(btf_type) == 0)
> +			return -EINVAL;
> +
> +		/* Assume type specified is a typedef as there's not much
> +		 * benefit in specifying int types other than wasting time
> +		 * on BTF lookups; we optimize for the most useful path.
> +		 *
> +		 * Fall back to BTF_KIND_INT if this fails.
> +		 */
> +		*btf_id = btf_find_by_name_kind(*btf, btf_type, btf_kind);
> +		if (*btf_id < 0)
> +			*btf_id = btf_find_by_name_kind(*btf, btf_type,
> +							BTF_KIND_INT);

with all that fragility...

> +	} else if (ptr->type_id > 0)
> +		*btf_id = ptr->type_id;

since __builtin_btf_type_id() landed in llvm in February and it works
may be support type_id only?

Manually specifying type name as a string is error prone.
Plus that copy_from_kernel... which is doing copy from bpf prog.
I slept on it, but still feels unclean.
May be do type_id only for now and if we really really need string types
we can add it later after initial patches land?
