Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFDE11DD74
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 06:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfLMFLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 00:11:08 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33448 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfLMFLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 00:11:07 -0500
Received: by mail-pj1-f67.google.com with SMTP id r67so697363pjb.0;
        Thu, 12 Dec 2019 21:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F2fqREv70Teeeov0KGudyLpVFva1MaF/r6WkUf6nkAU=;
        b=WY6XvDL4uWPKw/PYq+LpsJ5B7IdmT67QNT0RPgA0BVFmBuNpph8ZDI1eE2as6ztYYg
         s+gOX/yKO2EfskiwJTuNUksU+5AEKTWVv2RUHOVUOUF2m9kBZ6w8WOt+uVMpRE1OA1mb
         jWvlM6m503lzXOsfzVks7xAloDPbz+s11uqYwcqa4LLr9Xu9wAjBGarHeRf1w4iz63N5
         rVg6ZHuWsU3qz2vmMXNPMHmghUigOaOMyYnCKIohywWJVC+QuAWrULbXTiZlqnGr0Efe
         o1XfOQ36fY+1Yd3bJP677ElyPLAzW8a6f+imH8WtfBP6e0TIQ3WvsKg0PJoMbQdRIxJO
         SRHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F2fqREv70Teeeov0KGudyLpVFva1MaF/r6WkUf6nkAU=;
        b=It6TEOjSfU+OrJnR23pg32UCSo2u4+0b5xi+/ox1122ylymg4DOj0h2g59Kn4Pl59O
         L590x4Xshd6fwsGMsu4Wh7Bq1Phpo2z/7txfc4YrMvvj/orvGeMEEicJLbl/9e0MiKVx
         8sig6h/uuXar4Ih/L6ro8sDVdd+/Dswwn2RvG04VXKahleIH68pXJnSCCdsPR3C2hI64
         jVIOSqKh2PVURY7oDOIukjy8T0Z1zsBv0gqMFcIpGqI5L2tE68KqVeH6hQOC8Nmar1yT
         RSHBtD6YeALi5gbQ7mfotobvrJc92gV4hlyAgGUtUQZb6xPtXHd+zz+5ZTlTchj9U+hZ
         41Mw==
X-Gm-Message-State: APjAAAWnW/lB5BdiTzeAzD5S6q11K8Lyh09lTehv7rCGdm4LmwveZ1qR
        VHXdvFQBkah6ocMCd5VM4kQ=
X-Google-Smtp-Source: APXvYqxDCzodASPgOl/9TFLXh2xEO5YRDfc86b0gI2lx2ZGcR/nhEAum/vmp7y4CTYqWKcNba+5oew==
X-Received: by 2002:a17:902:6bc3:: with SMTP id m3mr13499091plt.185.1576213866958;
        Thu, 12 Dec 2019 21:11:06 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:180::c195])
        by smtp.gmail.com with ESMTPSA id d4sm7738459pjz.12.2019.12.12.21.11.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2019 21:11:05 -0800 (PST)
Date:   Thu, 12 Dec 2019 21:11:04 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 1/3] libbpf: support libbpf-provided extern
 variables
Message-ID: <20191213050739.xt4wnofdwf66gcrw@ast-mbp>
References: <20191211065002.2074074-1-andriin@fb.com>
 <20191211065002.2074074-2-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211065002.2074074-2-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 10:50:00PM -0800, Andrii Nakryiko wrote:
> +static int set_ext_value_tri(struct extern_desc *ext, void *ext_val,
> +			     char value)
> +{
> +	switch (ext->type) {
> +	case EXT_BOOL:
> +		if (value == 'm') {
> +			pr_warn("extern %s=%c should be tristate or char\n",
> +				ext->name, value);
> +			return -EINVAL;
> +		}
> +		*(bool *)ext_val = value == 'y' ? true : false;

may be check for strict y/n ?

> +		break;
> +	case EXT_TRISTATE:
> +		if (value == 'y')
> +			*(enum libbpf_tristate *)ext_val = TRI_YES;
> +		else if (value == 'm')
> +			*(enum libbpf_tristate *)ext_val = TRI_MODULE;
> +		else /* value == 'n' */
> +			*(enum libbpf_tristate *)ext_val = TRI_NO;

same here ?

> +		break;
> +	case EXT_CHAR:
> +		*(char *)ext_val = value;
> +		break;
> +	case EXT_UNKNOWN:
> +	case EXT_INT:
> +	case EXT_CHAR_ARR:

why enumerate them when there is a default ?

> +static int set_ext_value_str(struct extern_desc *ext, void *ext_val,
> +			     const char *value)
> +{
> +	size_t len;
> +
> +	if (ext->type != EXT_CHAR_ARR) {
> +		pr_warn("extern %s=%s should char array\n", ext->name, value);
> +		return -EINVAL;
> +	}
> +
> +	len = strlen(value);
> +	if (value[len - 1] != '"') {
> +		pr_warn("extern '%s': invalid string config '%s'\n",
> +			ext->name, value);
> +		return -EINVAL;
> +	}
> +
> +	/* strip quotes */
> +	len -= 2;
> +	if (len + 1 > ext->sz) {
> +		pr_warn("extern '%s': too long string config %s (%zu bytes), up to %d expected\n",
> +			ext->name, value, len + 1, ext->sz);
> +		return -EINVAL;

may be print warning and truncate instead of hard error?

> +static bool is_ext_value_in_range(const struct extern_desc *ext, __u64 v)
> +{
> +	int bit_sz = ext->sz * 8;
> +
> +	if (ext->sz == 8)
> +		return true;
> +
> +	if (ext->is_signed)
> +		return v + (1ULL << (bit_sz - 1)) < (1ULL << bit_sz);
> +	else
> +		return (v >> bit_sz) == 0;

a comment would be helpful.

> +		ext_val = data + ext->data_off;
> +		value = sep + 1;
> +
> +		switch (*value) {
> +		case 'y': case 'n': case 'm':

I don't think config.gz has 'n', but it's good to have it here.

> -			} else if (strcmp(name, ".data") == 0) {
> +			} else if (strcmp(name, DATA_SEC) == 0) {
>  				obj->efile.data = data;
>  				obj->efile.data_shndx = idx;
> -			} else if (strcmp(name, ".rodata") == 0) {
> +			} else if (strcmp(name, RODATA_SEC) == 0) {

such cleanup changes should be in separate patch.

> +		if (strcmp(ext->name, "LINUX_KERNEL_VERSION") == 0) {
> +			void *ext_val = data + ext->data_off;
> +			__u32 kver = get_kernel_version();
> +
> +			if (!kver) {
> +				pr_warn("failed to get kernel version\n");
> +				return -EINVAL;
> +			}
> +			err = set_ext_value_num(ext, ext_val, kver);

I think it should work when kern_ver is not 'int'.
Could you add a test for u64 ?
Or it will fail on big endian?

