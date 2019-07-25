Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEA975B2C
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 01:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbfGYXSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 19:18:36 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34073 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfGYXSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 19:18:36 -0400
Received: by mail-pg1-f196.google.com with SMTP id n9so17551545pgc.1;
        Thu, 25 Jul 2019 16:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IbFXwZkABlf37LF+Hf0tlPcipVRNp79b8gIXMfljA9U=;
        b=EMd2jgNbtYKYHRGfjO4og69RMNIDyqX6TPDBqkx7jJoQZ2YFwnX276goZf9+WeqkNj
         vsYnwmQYLM35Hd4nmGT+KRBTbWatpsG4vVNMiCsJ0v0D0CETGrvqyhecKeKRlxCQWp7D
         VgaiyhGf2Ty89SrZV5DN61mhBLUakCIcOMoqXo+sjW4t88kOHnG5Do+8RrraG02OXGme
         1lb7Wvzg3r7C824dhVtFDF6VnkA1UF6ITNBqF6GkX+l6irw57A+QRmoxvxhER6uoU7NI
         kUmioOr+8OQay7Jwm4ub8ctFNotXjrS9GVDaYclvbN2DPAjcdPHjZKXnRjOuWk0ZBdNo
         vldQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IbFXwZkABlf37LF+Hf0tlPcipVRNp79b8gIXMfljA9U=;
        b=Tul+fXU5Jlcf9HxBTI9zRgj9e2E58c3AHn+Ppk2jjGPYGLlVAUotVblYVxEtZO3+7z
         W4ldLgO0fQXf8ThlwGZ8s2IkXX1j+NUppRr2yQHm8O6PYinQw21147Cakyvx0RPBbaeu
         WdxzE8jvOkgPYj0vlDcK7aLjLYqpxl62l3EuRhkG0u+Gu0Bn0aVK77UV0N5Q7INAyLjC
         2HRVet7KekGP2TJO5fmhYEhYr/AFdBnUejqurllqJ0yeNhMYe7xF/So5gus/j09d6u4g
         rVPfUa3+D7mrr3p5xQd0mTiqgya5rBjdNaNKxfDpT7tZBs/RAX5Osga3wYstdivBi6Lb
         DlAg==
X-Gm-Message-State: APjAAAXN9b6sMog+G7y+3C83L0sXeuiHysz5tZRY2b9R/gsCFKHKLL8y
        RYXxOa9269t10xY27/dGbvaLuXJM
X-Google-Smtp-Source: APXvYqxoQajtLhKwpK9ASl8AKALeU3nyt4ifXBmsYGXWr3FQB2oMY0PpgKYTECWyNFGzo42VfhIGtg==
X-Received: by 2002:a62:15c3:: with SMTP id 186mr19747913pfv.141.1564096714906;
        Thu, 25 Jul 2019 16:18:34 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::1:85f9])
        by smtp.gmail.com with ESMTPSA id g18sm89382082pgm.9.2019.07.25.16.18.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 16:18:34 -0700 (PDT)
Date:   Thu, 25 Jul 2019 16:18:32 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, yhs@fb.com, andrii.nakryiko@gmail.com,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next 02/10] libbpf: implement BPF CO-RE offset
 relocation algorithm
Message-ID: <20190725231831.7v7mswluomcymy2l@ast-mbp>
References: <20190724192742.1419254-1-andriin@fb.com>
 <20190724192742.1419254-3-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724192742.1419254-3-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 12:27:34PM -0700, Andrii Nakryiko wrote:
> This patch implements the core logic for BPF CO-RE offsets relocations.
> All the details are described in code comments.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c | 866 ++++++++++++++++++++++++++++++++++++++++-
>  tools/lib/bpf/libbpf.h |   1 +
>  2 files changed, 861 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 8741c39adb1c..86d87bf10d46 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -38,6 +38,7 @@
>  #include <sys/stat.h>
>  #include <sys/types.h>
>  #include <sys/vfs.h>
> +#include <sys/utsname.h>
>  #include <tools/libc_compat.h>
>  #include <libelf.h>
>  #include <gelf.h>
> @@ -47,6 +48,7 @@
>  #include "btf.h"
>  #include "str_error.h"
>  #include "libbpf_internal.h"
> +#include "hashmap.h"
>  
>  #ifndef EM_BPF
>  #define EM_BPF 247
> @@ -1013,16 +1015,22 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
>  }
>  
>  static const struct btf_type *skip_mods_and_typedefs(const struct btf *btf,
> -						     __u32 id)
> +						     __u32 id,
> +						     __u32 *res_id)

I think it would be more readable to format it like:
static const struct btf_type *
skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id)

> +	} else if (class == BPF_ST && BPF_MODE(insn->code) == BPF_MEM) {
> +		if (insn->imm != orig_off)
> +			return -EINVAL;
> +		insn->imm = new_off;
> +		pr_debug("prog '%s': patched insn #%d (ST | MEM) imm %d -> %d\n",
> +			 bpf_program__title(prog, false),
> +			 insn_idx, orig_off, new_off);

I'm pretty sure llvm was not capable of emitting BPF_ST insn.
When did that change?

> +/* 
> + * CO-RE relocate single instruction.
> + *
> + * The outline and important points of the algorithm:
> + * 1. For given local type, find corresponding candidate target types.
> + *    Candidate type is a type with the same "essential" name, ignoring
> + *    everything after last triple underscore (___). E.g., `sample`,
> + *    `sample___flavor_one`, `sample___flavor_another_one`, are all candidates
> + *    for each other. Names with triple underscore are referred to as
> + *    "flavors" and are useful, among other things, to allow to
> + *    specify/support incompatible variations of the same kernel struct, which
> + *    might differ between different kernel versions and/or build
> + *    configurations.

"flavors" is a convention of bpftool btf2c converter, right?
May be mention it here with pointer to the code?

> +	pr_debug("prog '%s': relo #%d: insn_off=%d, [%d] (%s) + %s\n",
> +		 prog_name, relo_idx, relo->insn_off,
> +		 local_id, local_name, spec_str);
> +
> +	err = bpf_core_spec_parse(local_btf, local_id, spec_str, &local_spec);
> +	if (err) {
> +		pr_warning("prog '%s': relo #%d: parsing [%d] (%s) + %s failed: %d\n",
> +			   prog_name, relo_idx, local_id, local_name, spec_str,
> +			   err);
> +		return -EINVAL;
> +	}
> +	pr_debug("prog '%s': relo #%d: [%d] (%s) + %s is off %u, len %d, raw_len %d\n",
> +		 prog_name, relo_idx, local_id, local_name, spec_str,
> +		 local_spec.offset, local_spec.len, local_spec.raw_len);

one warn and two debug that print more or less the same info seems like overkill.

> +	for (i = 0, j = 0; i < cand_ids->len; i++) {
> +		cand_id = cand_ids->data[j];
> +		cand_type = btf__type_by_id(targ_btf, cand_id);
> +		cand_name = btf__name_by_offset(targ_btf, cand_type->name_off);
> +
> +		err = bpf_core_spec_match(&local_spec, targ_btf,
> +					  cand_id, &cand_spec);
> +		if (err < 0) {
> +			pr_warning("prog '%s': relo #%d: failed to match spec [%d] (%s) + %s to candidate #%d [%d] (%s): %d\n",
> +				   prog_name, relo_idx, local_id, local_name,
> +				   spec_str, i, cand_id, cand_name, err);
> +			return err;
> +		}
> +		if (err == 0) {
> +			pr_debug("prog '%s': relo #%d: candidate #%d [%d] (%s) doesn't match spec\n",
> +				 prog_name, relo_idx, i, cand_id, cand_name);
> +			continue;
> +		}
> +
> +		pr_debug("prog '%s': relo #%d: candidate #%d ([%d] %s) is off %u, len %d, raw_len %d\n",
> +			 prog_name, relo_idx, i, cand_id, cand_name,
> +			 cand_spec.offset, cand_spec.len, cand_spec.raw_len);

have the same feeling about 3 printfs above.

