Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AADB2186A6A
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 12:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730889AbgCPLyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 07:54:33 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35042 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730845AbgCPLyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 07:54:33 -0400
Received: by mail-wm1-f66.google.com with SMTP id m3so17690826wmi.0
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 04:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YoqxlxRoyaSC6sJA8xOZEDltFxdNmTdNldjtgcprq6U=;
        b=yfkRo2f6OHfidU5R8GrlPTAd3CrowkUfEHHU759Ga6SZ77QOIQuqke0AmMe7KH/HfP
         vVty8iLMb9emEDdE+OX3WCecSwaLChMGlSMGgmJ+EQQh4Or3wQvQFqUEYMylE53fhOfs
         fb+mvmfJVyoo8vBSAwkt5NUNDgQUl2u8fwtAfbzeNSTX2tR8XF2UyxVf4ly72+viXt3H
         ZUJ/Y4+hSHJ8JFG1ul02Y7vpORvYB/ojkijYLElm7vdT4JbnX3Ys+FiPtcPcyOujVd7+
         tydZOauEjh49NF+bN4/Pprzkom72Qlc2Y1TIs4yDPV4ZCorMBAQeayRY/3ghQz9nD2fv
         EoUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YoqxlxRoyaSC6sJA8xOZEDltFxdNmTdNldjtgcprq6U=;
        b=b16K2z982pbxFk0kC7JGJoURCLNpRu9oKuP6e8af2Ldw1xQey7nkeVW1AZU9Ez4ESj
         Nf4ruUwmdVG42AP10xJA2NJb/dHjCiqxH/tTX1/KF8RBy7R2diYNgQn6SPZ2ptBGeSFi
         e1grg7bAy+XPRNekSmQqBEwodwx6fV4EECi1smgvzujzMmNmephnw5TotQNf9apjfpmT
         Q8lLz82LOTFEt/lkpd3uGUWsYLJ+gPtY1PEJ3ovt1RXL7mo+n820W3pLEo8adyD06XCC
         COT913SEjq4LToJAM0ISVgykO2PsYuVcSprAHiNQW9dW7DPjZl3aezOfhxHcVXVm0ir0
         V/fw==
X-Gm-Message-State: ANhLgQ1UPx0RHQpxaSrCfsDnV2OC+hT1PeTWK3+K/YdzXtEpBg8cB7o1
        hBOp+P1zzdveNI4aP0YgtEXPEzKUqUI=
X-Google-Smtp-Source: ADFU+vtn4uUCivvgWVvmRAOgQoaHooHPFQyAQNtgjM6CNXRs5pw2yu8+5ML0hGkyG/P/QV2FEqtvnQ==
X-Received: by 2002:a7b:cf33:: with SMTP id m19mr18849290wmg.168.1584359669782;
        Mon, 16 Mar 2020 04:54:29 -0700 (PDT)
Received: from [192.168.1.10] ([194.35.118.24])
        by smtp.gmail.com with ESMTPSA id c4sm29930147wml.7.2020.03.16.04.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 04:54:29 -0700 (PDT)
Subject: Re: [PATCH bpf-next 4/4] bpftool: Add struct_ops support
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20200316005559.2952646-1-kafai@fb.com>
 <20200316005624.2954179-1-kafai@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <da2d5a6c-3023-bb27-7c45-96224c8f4334@isovalent.com>
Date:   Mon, 16 Mar 2020 11:54:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200316005624.2954179-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-03-15 17:56 UTC-0700 ~ Martin KaFai Lau <kafai@fb.com>
> This patch adds struct_ops support to the bpftool.

[...]

> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  .../Documentation/bpftool-struct_ops.rst      | 106 ++++
>  tools/bpf/bpftool/bash-completion/bpftool     |  28 +
>  tools/bpf/bpftool/main.c                      |   3 +-
>  tools/bpf/bpftool/main.h                      |   1 +
>  tools/bpf/bpftool/struct_ops.c                | 595 ++++++++++++++++++
>  5 files changed, 732 insertions(+), 1 deletion(-)
>  create mode 100644 tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
>  create mode 100644 tools/bpf/bpftool/struct_ops.c
> 
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst b/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
> new file mode 100644
> index 000000000000..27aae5bc632e
> --- /dev/null
> +++ b/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
> @@ -0,0 +1,106 @@
> +==================
> +bpftool-struct_ops
> +==================
> +-------------------------------------------------------------------------------
> +tool to register/unregister/introspect BPF struct_ops
> +-------------------------------------------------------------------------------
> +
> +:Manual section: 8
> +
> +SYNOPSIS
> +========
> +
> +	**bpftool** [*OPTIONS*] **struct_ops** *COMMAND*
> +
> +	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] }
> +
> +	*COMMANDS* :=
> +	{ **show** | **list** | **dump** | **register** | **unregister** | **help** }
> +
> +STRUCT_OPS COMMANDS
> +===================
> +
> +|	**bpftool** **struct_ops { show | list }** [*STRUCT_OPS_MAP*]
> +|	**bpftool** **struct_ops dump** [*STRUCT_OPS_MAP*]
> +|	**bpftool** **struct_ops register** *OBJ*
> +|	**bpftool** **struct_ops unregister** *STRUCT_OPS_MAP*
> +|	**bpftool** **struct_ops help**
> +|
> +|	*STRUCT_OPS_MAP* := { **id** *STRUCT_OPS_MAP_ID* | **name** *STRUCT_OPS_MAP_NAME* }
> +|	*OBJ* := /a/file/of/bpf_struct_ops.o
> +
> +
> +DESCRIPTION
> +===========
> +	**bpftool struct_ops { show | list }** [*STRUCT_OPS_MAP*]
> +		  Show brief information about the struct_ops in the system.
> +		  If *STRUCT_OPS_MAP* is specified, it shows information only
> +		  for the given struct_ops.  Otherwise, it lists all struct_ops
> +		  currently exists in the system.

Typo: s/exists/existing/

> +
> +		  Output will start with struct_ops map ID, followed by its map
> +		  name and its struct_ops's kernel type.
> +
> +	**bpftool struct_ops dump** [*STRUCT_OPS_MAP*]
> +		  Dump details information about the struct_ops in the system.
> +		  If *STRUCT_OPS_MAP* is specified, it dumps information only
> +		  for the given struct_ops.  Otherwise, it dumps all struct_ops
> +		  currently exists in the system.

Same here.

> +
> +	**bpftool struct_ops register** *OBJ*
> +		  Register bpf struct_ops from *OBJ*.  All struct_ops under
> +		  the ELF section ".struct_ops" will be registered to
> +		  its kernel subsystem.
> +
> +	**bpftool struct_ops unregister**  *STRUCT_OPS_MAP*
> +		  Unregister the *STRUCT_OPS_MAP* from the kernel subsystem.
> +
> +	**bpftool struct_ops help**
> +		  Print short help message.
> +
> +OPTIONS
> +=======
> +	-h, --help
> +		  Print short generic help message (similar to **bpftool help**).
> +
> +	-V, --version
> +		  Print version number (similar to **bpftool version**).
> +
> +	-j, --json
> +		  Generate JSON output. For commands that cannot produce JSON, this
> +		  option has no effect.
> +
> +	-p, --pretty
> +		  Generate human-readable JSON output. Implies **-j**.
> +
> +	-d, --debug
> +		  Print all logs available, even debug-level information. This
> +		  includes logs from libbpf as well as from the verifier, when
> +		  attempting to load programs.
> +
> +EXAMPLES
> +========
> +**# bpftool struct_ops show**
> +
> +::
> +
> +    100: dctcp           tcp_congestion_ops
> +    105: cubic           tcp_congestion_ops
> +
> +**# bpftool struct_ops unregister id 105**
> +
> +::
> +
> +   Unregistered tcp_congestion_ops cubic id 105
> +
> +**# bpftool struct_ops register bpf_cubic.o**
> +
> +::
> +
> +   Registered tcp_congestion_ops cubic id 110
> +
> +
> +SEE ALSO
> +========
> +	**bpftool-map**\ (8)
> +	**bpftool-prog**\ (8)

Other man pages link to all available bpftool-* pages. If you do not
want to do that, could you at least link to bpf(2) and bpftool(8) please?

[...]

> diff --git a/tools/bpf/bpftool/struct_ops.c b/tools/bpf/bpftool/struct_ops.c
> new file mode 100644
> index 000000000000..ba145e3d0d5d
> --- /dev/null
> +++ b/tools/bpf/bpftool/struct_ops.c
> @@ -0,0 +1,595 @@
> +// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +/* Copyright (C) 2020 Facebook */
> +
> +#include <unistd.h>
> +#include <stdio.h>
> +#include <errno.h>
> +
> +#include <linux/err.h>

Nit: line break here, please

> +#include <bpf/libbpf.h>
> +#include <bpf/bpf.h>
> +#include <bpf/btf.h>

Nit again: Could you please have the includes in each block ordered
alphabetically?

> +
> +#include "json_writer.h"
> +#include "main.h"
> +
> +#define STRUCT_OPS_VALUE_PREFIX "bpf_struct_ops_"
> +

[...]

> +static struct bpf_map_info *map_info_alloc(__u32 *alloc_len)
> +{
> +	struct bpf_map_info *info;
> +
> +	if (get_map_info_type_id() < 0)
> +		return NULL;
> +
> +	info = calloc(1, map_info_alloc_len);
> +	if (!info)
> +		p_err("mem alloc failed");
> +	else
> +		*alloc_len = map_info_alloc_len;
> +
> +	return info;
> +}
> +
> +/* It iterates all struct_ops maps of the system.
> + * It returns the fd in "*res_fd" and map_info in "*info".
> + * In the very first iteration, info->id should be 0.
> + * An optional map "*name" filter can be specified.
> + * The filter can be made more flexibile in the future.

Typo: flexible

> + * e.g. filter by kernel-struct-ops-name, regex-name, glob-name, ...etc.
> + *
> + * Return value:
> + *     1: A struct_ops map found.  It is returned in "*res_fd" and "*info".
> + *	  The caller can continue to call get_next in the future.
> + *     0: No struct_ops map is returned.
> + *        All struct_ops map has been found.
> + *    -1: Error and the caller should abort the iteration.
> + */
> +static int get_next_struct_ops_map(const char *name, int *res_fd,
> +				   struct bpf_map_info *info, __u32 info_len)
> +{
> +	__u32 id = info->id;
> +	int err, fd;
> +
> +	while (true) {
> +		err = bpf_map_get_next_id(id, &id);
> +		if (err) {
> +			if (errno == ENOENT)
> +				return 0;
> +			p_err("can't get next map %s", strerror(errno));

Nit: Add a colon before "%s"?

> +			return -1;
> +		}
> +
> +		fd = bpf_map_get_fd_by_id(id);
> +		if (fd < 0) {
> +			if (errno == ENOENT)
> +				continue;
> +			p_err("can't get map by id (%u): %s",
> +			      id, strerror(errno));
> +			return -1;
> +		}
> +
> +		err = bpf_obj_get_info_by_fd(fd, info, &info_len);
> +		if (err) {
> +			p_err("can't get map info: %s", strerror(errno));
> +			close(fd);
> +			return -1;
> +		}
> +
> +		if (info->type == BPF_MAP_TYPE_STRUCT_OPS &&
> +		    (!name || !strcmp(name, info->name))) {
> +			*res_fd = fd;
> +			return 1;
> +		}
> +		close(fd);
> +	}
> +}

[...]

> +static int do_unregister(int argc, char **argv)
> +{
> +	const char *search_type, *search_term;
> +	struct res res;
> +
> +	if (argc != 2)
> +		usage();

Or you could reuse the macros in main.h, for more consistency with other
subcommands:

	if (!REQ_ARGS(2))
		return -1;

> +
> +	search_type = argv[0];
> +	search_term = argv[1];

	search_type = GET_ARG();
	search_term = GET_ARG();

> +
> +	res = do_work_on_struct_ops(search_type, search_term,
> +				    __do_unregister, NULL, NULL);
> +
> +	return cmd_retval(&res, true);
> +}
> +
> +static int do_register(int argc, char **argv)
> +{
> +	const struct bpf_map_def *def;
> +	struct bpf_map_info info = {};
> +	__u32 info_len = sizeof(info);
> +	int nr_errs = 0, nr_maps = 0;
> +	struct bpf_object *obj;
> +	struct bpf_link *link;
> +	struct bpf_map *map;
> +	const char *file;
> +
> +	if (argc != 1)
> +		usage();

(Same remark here.)

> +
> +	file = argv[0];
> +
> +	obj = bpf_object__open(file);
> +	if (IS_ERR_OR_NULL(obj))
> +		return -1;

[...]
