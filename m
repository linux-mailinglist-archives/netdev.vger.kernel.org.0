Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7D4DD500
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 00:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393338AbfJRWjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 18:39:16 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44821 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfJRWjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 18:39:16 -0400
Received: by mail-lf1-f67.google.com with SMTP id q12so5805448lfc.11
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 15:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Tu+y8NQHPJdpH5zk4JXjcOJf2x2sdRfeWLWJG+FKhFs=;
        b=iAQIR5fnIsTR2Ts309v6YQ/kn615UlLrE03SeNj9KpK0GUbnuTu/+5dED86PZyWoDc
         dOPBuWT2q6yGKk47t7fZ8pr7muZpcTc5gJrDCtaJlNLKQ5MYaXJlKcXtktaZJrtBwooI
         uUVNuqi20TMA3Y3YhOtZz+bWL+hnEvUz8LrZZHG3yZgdwvLuV5V0so3llr3O1dWGRQe5
         ViXJK1MHCvQ17LJtZZOeBhJ+RC0GnTSzIUICkDs8lO3YG5emAUTrnWl2IQeYz8LMn0MJ
         VQ+CTaF+/RkMV/cY8ra2onYlmmEXI7y+PDLWOXTjmINTje7CEeONJZk80L/NhVFQzgfV
         ToAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Tu+y8NQHPJdpH5zk4JXjcOJf2x2sdRfeWLWJG+FKhFs=;
        b=p1fg1vwoLZMjVv+LqQ002w45Db1STHMYkwq6nddgpHV6GvIMRC4UgPBMR08qpuALeB
         VQV9yeMI6nl5gYHVQpLHm/KkATCCTIPbATaewguhkGJ2YNjeoRGkwhmmPc5CzEQD25SV
         +TnAGYTcgpDIAu/I/mXUuEAJ6VBq5lR9S/pBqThuxrymQXFah2DRNZbV862yoBcqLBHI
         m1RU/weBHYmXrtybsTiF1DoaH3nbVQAOI/fMKXT0YmXkwlFWs/Apa530kHkAtNw9Wmk/
         moObvG+fn+S5cMWLKmmXx9FEp0Y/j3p5ow8v/pTnx67ZHYQYXAECDPzw5YcnakKQIPt4
         oh3w==
X-Gm-Message-State: APjAAAWECNnfBeNLufaX81dE3LxKPSPet4ngJTH/ZTuWROBceMb2QPdZ
        L6e4qDr6eROfQGnFU0SI+hdbzA==
X-Google-Smtp-Source: APXvYqy4edffS/arTAA9zeCX329BJi3gMMUpHPH5hrbydZapeR2ditRHVTk/m4NSbykVWZSi0AkvkA==
X-Received: by 2002:ac2:5477:: with SMTP id e23mr7493688lfn.5.1571438353677;
        Fri, 18 Oct 2019 15:39:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l7sm2885363lji.46.2019.10.18.15.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 15:39:13 -0700 (PDT)
Date:   Fri, 18 Oct 2019 15:39:05 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH] bpftool: Try to read btf as raw data if elf read fails
Message-ID: <20191018153905.600d7c8a@cakuba.netronome.com>
In-Reply-To: <20191018103404.12999-1-jolsa@kernel.org>
References: <20191018103404.12999-1-jolsa@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 12:34:04 +0200, Jiri Olsa wrote:
> The bpftool interface stays the same, but now it's possible
> to run it over BTF raw data, like:
> 
>   $ bpftool btf dump file /sys/kernel/btf/vmlinux
>   libbpf: failed to get EHDR from /sys/kernel/btf/vmlinux
>   [1] INT '(anon)' size=4 bits_offset=0 nr_bits=32 encoding=(none)
>   [2] INT 'long unsigned int' size=8 bits_offset=0 nr_bits=64 encoding=(none)
>   [3] CONST '(anon)' type_id=2
> 
> I'm also adding err init to 0 because I was getting uninitialized
> warnings from gcc.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/bpf/bpftool/btf.c | 47 ++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 42 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
> index 9a9376d1d3df..100fb7e02329 100644
> --- a/tools/bpf/bpftool/btf.c
> +++ b/tools/bpf/bpftool/btf.c
> @@ -12,6 +12,9 @@
>  #include <libbpf.h>
>  #include <linux/btf.h>
>  #include <linux/hashtable.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
>  
>  #include "btf.h"
>  #include "json_writer.h"
> @@ -388,6 +391,35 @@ static int dump_btf_c(const struct btf *btf,
>  	return err;
>  }
>  
> +static struct btf *btf__parse_raw(const char *file)
> +{
> +	struct btf *btf = ERR_PTR(-EINVAL);
> +	__u8 *buf = NULL;

Please drop the inits

> +	struct stat st;
> +	FILE *f;
> +
> +	if (stat(file, &st))
> +		return btf;

And return constants here

> +	f = fopen(file, "rb");
> +	if (!f)
> +		return btf;

and here

> +	buf = malloc(st.st_size);
> +	if (!buf)
> +		goto err;

and jump to the right place here.

> +	if ((size_t) st.st_size != fread(buf, 1, st.st_size, f))
> +		goto err;
> +
> +	btf = btf__new(buf, st.st_size);
> +
> +err:

The prefix for error labels which is shared with non-error path is exit_

> +	free(buf);
> +	fclose(f);
> +	return btf;
> +}
> +
>  static int do_dump(int argc, char **argv)
>  {
>  	struct btf *btf = NULL;
> @@ -397,7 +429,7 @@ static int do_dump(int argc, char **argv)
>  	__u32 btf_id = -1;
>  	const char *src;
>  	int fd = -1;
> -	int err;
> +	int err = 0;

This change looks unnecessary.

>  	if (!REQ_ARGS(2)) {
>  		usage();
> @@ -468,10 +500,15 @@ static int do_dump(int argc, char **argv)
>  		btf = btf__parse_elf(*argv, NULL);
>  		if (IS_ERR(btf)) {
>  			err = PTR_ERR(btf);
> -			btf = NULL;
> -			p_err("failed to load BTF from %s: %s", 
> -			      *argv, strerror(err));
> -			goto done;
> +			if (err == -LIBBPF_ERRNO__FORMAT)
> +				btf = btf__parse_raw(*argv);
> +			if (IS_ERR(btf)) {
> +				btf = NULL;
> +				/* Display the original error value. */
> +				p_err("failed to load BTF from %s: %s",
> +				      *argv, strerror(err));
> +				goto done;
> +			}
>  		}
>  		NEXT_ARG();
>  	} else {

