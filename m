Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E3A221F84
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 11:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgGPJOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 05:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgGPJOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 05:14:50 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C3CC061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 02:14:50 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j4so6232821wrp.10
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 02:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xPuvMltWVkKScrej512C6U/UnNPO5PMqz0Vapfuf7aE=;
        b=s0Zfz/o9mZgeg04QVdmSk7MwoKTV0InQeSD7UVveRmUBMtCNjAheiKTZztZXTcbFHJ
         +ZvbCfdPs3z5vQvYPHF9IXeN1vwIRrBUYNSJ+PeZiuDpiGxCHza6nV48Hu45/yJXpu16
         93M1c9zfd9dwCBJat/jUv/MMPzgKM5s4durd36bBq+YNEtNGsCBPsmsE5k/BmqFLp2Cz
         phjT1hbQi68zrGEUZpx68TRqY3gaIdKTUwxl77uwUwWh1oNfStU2SWg6xnU7SvuELs16
         XX9/URxK9XTX8Qaw8LRM8u3ccq1SJVbTs2gAYHBwngrpP3KannTXQ1GKq73rdwa4DIRZ
         QoxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xPuvMltWVkKScrej512C6U/UnNPO5PMqz0Vapfuf7aE=;
        b=WqQ55B75ueHvMqC788Wm3P3uK/T65Crty5VDaDcJQwYUyDDbBoPMwnijoeJ6P+qJd4
         6oPcQ2/ZGAi18XMC0R55ndgdnO/tQ7v0wRpaENY1hGvb41XBIA9ArkNfXthBdicdOP7e
         AObRv6s9W8Yi0QJHbAXwH+GMMEMfCAuQ8GFrlDx2Ds85X1HyU2d4lmxKgNu4yR9D2CZE
         gBj8KDsj8zYPekDe5//DDDbTov9DrhvL+N27LmqQn9SRB+X5yfGXYUetxzI3QbSdEYSz
         G48gMNx4MCQSib391J4m8TdtC5VQa+9q3U3bCtKtchOCEdfddY9B51Qs+A57G/E/ksUT
         JHRA==
X-Gm-Message-State: AOAM5324u2xf4yBHLraVaqlP5jUeqTWZF4S0F6SpHO+UnGi0kMDNTeNo
        AYhOO94EfatI9PfuUCnhFSiAkg==
X-Google-Smtp-Source: ABdhPJxdeG2/ePw+qMsPaJOPKou/pSqlux0G4Y45RjOJtW6ZUKTd13saJQ0pzTXHX6bxLDNMpWK4EQ==
X-Received: by 2002:a5d:6ac7:: with SMTP id u7mr4406853wrw.25.1594890888815;
        Thu, 16 Jul 2020 02:14:48 -0700 (PDT)
Received: from [192.168.1.12] ([194.35.117.14])
        by smtp.gmail.com with ESMTPSA id f9sm7999766wru.47.2020.07.16.02.14.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 02:14:48 -0700 (PDT)
Subject: Re: [PATCH bpf-next v2] bpftool: use only nftw for file tree parsing
To:     Tony Ambardar <tony.ambardar@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20200715051214.28099-1-Tony.Ambardar () gmail ! com>
 <20200716052926.10933-1-Tony.Ambardar@gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <9560214f-6505-3810-710c-2216648d5bab@isovalent.com>
Date:   Thu, 16 Jul 2020 10:14:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716052926.10933-1-Tony.Ambardar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-07-15 22:29 UTC-0700 ~ Tony Ambardar <tony.ambardar@gmail.com>
> The bpftool sources include code to walk file trees, but use multiple
> frameworks to do so: nftw and fts. While nftw conforms to POSIX/SUSv3 and
> is widely available, fts is not conformant and less common, especially on
> non-glibc systems. The inconsistent framework usage hampers maintenance
> and portability of bpftool, in particular for embedded systems.
> 
> Standardize code usage by rewriting one fts-based function to use nftw.
> Clean up related function warnings by using "const char *" arguments and
> fixing an unsafe call to dirname().
> 
> These changes help in building bpftool against musl for OpenWrt.

Could you please add a line to the log about the reason for the path
copy in open_obj_pinned()?

> 
> Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> ---
> 
> V2:
> * use _GNU_SOURCE to pull in getpagesize(), getline(), nftw() definitions
> * use "const char *" in open_obj_pinned() and open_obj_pinned_any()
> * make dirname() safely act on a string copy
> 
> ---
>  tools/bpf/bpftool/common.c | 129 +++++++++++++++++++++----------------
>  tools/bpf/bpftool/main.h   |   4 +-
>  2 files changed, 76 insertions(+), 57 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> index 29f4e7611ae8..7c2e52fc5784 100644
> --- a/tools/bpf/bpftool/common.c
> +++ b/tools/bpf/bpftool/common.c
> @@ -1,10 +1,11 @@
>  // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>  /* Copyright (C) 2017-2018 Netronome Systems, Inc. */
>  
> +#define _GNU_SOURCE
>  #include <ctype.h>
>  #include <errno.h>
>  #include <fcntl.h>
> -#include <fts.h>
> +#include <ftw.h>
>  #include <libgen.h>
>  #include <mntent.h>
>  #include <stdbool.h>
> @@ -160,24 +161,36 @@ int mount_tracefs(const char *target)
>  	return err;
>  }
>  
> -int open_obj_pinned(char *path, bool quiet)
> +int open_obj_pinned(const char *path, bool quiet)
>  {
> -	int fd;
> +	char *pname;
> +	int fd = -1;
> +
> +	pname = strdup(path);
> +	if (pname == NULL) {

Simply "if (!pname) {"

> +		if (!quiet)
> +			p_err("bpf obj get (%s): %s", path, strerror(errno));

Please update the error message, this one was for a failure on
bpf_obj_get().

> +		goto out_ret;
> +	}
> +

You're adding a second blank line here, please fix.

>  
> -	fd = bpf_obj_get(path);
> +	fd = bpf_obj_get(pname);
>  	if (fd < 0) {
>  		if (!quiet)
> -			p_err("bpf obj get (%s): %s", path,
> -			      errno == EACCES && !is_bpffs(dirname(path)) ?
> +			p_err("bpf obj get (%s): %s", pname,
> +			      errno == EACCES && !is_bpffs(dirname(pname)) ?
>  			    "directory not in bpf file system (bpffs)" :
>  			    strerror(errno));
> -		return -1;
> +		goto out_free;
>  	}
>  
> +out_free:
> +	free(pname);
> +out_ret:
>  	return fd;
>  }
>  
> -int open_obj_pinned_any(char *path, enum bpf_obj_type exp_type)
> +int open_obj_pinned_any(const char *path, enum bpf_obj_type exp_type)
>  {
>  	enum bpf_obj_type type;
>  	int fd;
> @@ -367,68 +380,74 @@ void print_hex_data_json(uint8_t *data, size_t len)
>  	jsonw_end_array(json_wtr);
>  }
>  
> -int build_pinned_obj_table(struct pinned_obj_table *tab,
> -			   enum bpf_obj_type type)
> +static struct pinned_obj_table *build_fn_table; /* params for nftw cb*/
> +static enum bpf_obj_type build_fn_type;

I would move the comments above the lines, since it applies to both of them.

> +
> +static int do_build_table_cb(const char *fpath, const struct stat *sb,
> +			    int typeflag, struct FTW *ftwbuf)

Please align the second line on the open parenthesis.

>  {
>  	struct bpf_prog_info pinned_info = {};

A few suggestions on this code, even though I realise you simply moved
some parts. We can skip zero-initialising here (" = {}") because we
memset() it below before using it anyway.

>  	struct pinned_obj *obj_node = NULL;
>  	__u32 len = sizeof(pinned_info);
> -	struct mntent *mntent = NULL;
>  	enum bpf_obj_type objtype;
> +	int fd, err = 0;
> +
> +	if (typeflag != FTW_F)
> +		goto out_ret;
> +	fd = open_obj_pinned(fpath, true);
> +	if (fd < 0)
> +		goto out_ret;
> +
> +	objtype = get_fd_type(fd);
> +	if (objtype != build_fn_type)
> +		goto out_close;
> +
> +	memset(&pinned_info, 0, sizeof(pinned_info));
> +	if (bpf_obj_get_info_by_fd(fd, &pinned_info, &len)) {
> +		p_err("can't get obj info: %s", strerror(errno));

We are simply building a table here to show the paths where objects are
pinned when listing progs/maps/etc., and I don't believe we want to
print an error in that case. And with such a message I would expect the
function to return and bpftool to stop, but again I don't believe this
is necessary here and we can just go on listing objects, even if we fail
to show their pinned paths.

> +		goto out_close;
> +	}
> +
> +	obj_node = malloc(sizeof(*obj_node));
> +	if (!obj_node) {
> +		p_err("mem alloc failed");

Same here, let's not add an error message.

> +		err = -1;
> +		goto out_close;
> +	}
> +
> +	memset(obj_node, 0, sizeof(*obj_node));

Instead of malloc() + memset(), we could simply use calloc().

> +	obj_node->id = pinned_info.id;
> +	obj_node->path = strdup(fpath);
> +	hash_add(build_fn_table->table, &obj_node->hash, obj_node->id);
> +
> +out_close:
> +	close(fd);
> +out_ret:
> +	return err;
> +}
> +
> +int build_pinned_obj_table(struct pinned_obj_table *tab,
> +			   enum bpf_obj_type type)
> +{

The end looks good.

Apart from the minor points mentioned above, the patch is good, copying
the string in open_obj_pinned() looks like the right approach. It does
compile (with no warnings) and works as intended on my machine :).

Thanks,
Quentin
