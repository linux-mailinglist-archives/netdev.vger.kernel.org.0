Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F451277CF0
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgIYAd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgIYAd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 20:33:29 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6042C0613CE;
        Thu, 24 Sep 2020 17:33:28 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g29so1027240pgl.2;
        Thu, 24 Sep 2020 17:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=heSZ+vYMpgFHhWomcOAQ0pB3xOxWwgLlUEvkB5nligg=;
        b=qolVVq1IXAH2KQsr1j+mJ189ZPsIRozzGguGVAMYYXukIe7sljhxPZT+XB3Z4bB0mh
         1nMqK1+EN03THQFbpx6SY1wavqCTlq3Jd8q9ehUKXQfwrKIGfJNmPo/M7XpfoUAhe5mS
         skl1yghN9442sSafo5zZml7QG5D6QMWG4kYn5xW8TTRFrvuQjp0TRXLR2I1UNoIJpVE2
         pUCUl71FFEaJLNeCWT7X/o3URttG5Sc9kK7uclod8TPYVNywP4UpAXyKy3QaAwy9g9NY
         LwaMVHdhWQwBdhkLSUTWoThubO+wLdUH0wZ+4YgfvsmRQeu74S2CyaKZYO/4cCt/nwoD
         FF8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=heSZ+vYMpgFHhWomcOAQ0pB3xOxWwgLlUEvkB5nligg=;
        b=UiXn4GtBcrC1SWJmj5aGGrXGfpDKs7/vDwYELr59/4vjwuYFBbudwkQqE22UAwR0vr
         13zYeC1HbcQRVjr+FJFC0B2+lJK4uSrPlChgIOdswov2pmaGs8RoWnRtwGRoDfWVp6ul
         09RjRJELF0N/CJbGL98KS+8M1DeVpInZ/zYwWqGwShg3TT8qyrFrOpBQjgp9qkw7X8Sy
         J5tI+pH2cahxsJdFHM6v6eMY/hAEnQNXZYoyCyg48xloaFeElDpezeHAq1+S0fM0WZIX
         FXTR6Z2YyWkmcFfovrzxSpz0ixHkqBAIdrcv1cmAOlci7naPoqvmEub7ts+yyjBMQG0u
         g4eQ==
X-Gm-Message-State: AOAM530nhcGjOm/glfGznAi4j2NG02syU9jAtnVMWD6lwu2DrYjb4uom
        p4mIYe42dguNWTRy9aO0VQk=
X-Google-Smtp-Source: ABdhPJzAV7rIzcHLywe8VSGKzhq95U0ycxS2I81hHRVEYrbo3sKMnkRgNi8ea0dj1c2XdBuo85vX0w==
X-Received: by 2002:aa7:9986:0:b029:142:2501:39db with SMTP id k6-20020aa799860000b0290142250139dbmr1599765pfh.42.1600994008051;
        Thu, 24 Sep 2020 17:33:28 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:49ed])
        by smtp.gmail.com with ESMTPSA id z7sm594743pfj.75.2020.09.24.17.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 17:33:27 -0700 (PDT)
Date:   Thu, 24 Sep 2020 17:33:23 -0700
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
Subject: Re: [PATCH v6 bpf-next 2/6] bpf: move to generic BTF show support,
 apply it to seq files/strings
Message-ID: <20200925003323.u2s2vyyqq2uhtij7@ast-mbp.dhcp.thefacebook.com>
References: <1600883188-4831-1-git-send-email-alan.maguire@oracle.com>
 <1600883188-4831-3-git-send-email-alan.maguire@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600883188-4831-3-git-send-email-alan.maguire@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 06:46:24PM +0100, Alan Maguire wrote:
>  
> +/* Chunk size we use in safe copy of data to be shown. */
> +#define BTF_SHOW_OBJ_SAFE_SIZE		256

sizeof(struct btf_show) == 472
It's allocated on stack and called from bpf prog.
It's a leaf function, but it still worries me a bit.
I've trimmed it down to 32 and everything seems to be printing fine.
There will be more calls to copy_from_kernel_nofault(), but so what?
Is there a downside to make it that small?

Similarly state.name is 128 bytes. May be use 80 there?
I think that should be plenty still.

> + * Another problem is we want to ensure the data for display is safe to
> + * access.  To support this, the "struct obj" is used to track the data

'struct obj' doesn't exist. It's an anon field 'struct {} obj;' inside btf_show
that you're referring to, right?
Would be good to fix this comment.

> +struct btf_show {
> +	u64 flags;
> +	void *target;	/* target of show operation (seq file, buffer) */
> +	void (*showfn)(struct btf_show *show, const char *fmt, ...);

buildbot complained that this field needs to be annotated.

> +#define btf_show(show, ...)						      \
> +	do {								      \
> +		if (!show->state.depth_check)				      \
> +			show->showfn(show, __VA_ARGS__);		      \
> +	} while (0)

Does it have to be a macro? What are you gaining from macro
instead of vararg function?

> +static inline const char *__btf_show_indent(struct btf_show *show)

please remove all 'inline' from .c file.
There is no need to give such hints to the compiler.

> +#define btf_show_indent(show)						       \
> +	((show->flags & BTF_SHOW_COMPACT) ? "" : __btf_show_indent(show))
> +
> +#define btf_show_newline(show)						       \
> +	((show->flags & BTF_SHOW_COMPACT) ? "" : "\n")
> +
> +#define btf_show_delim(show)						       \
> +	(show->state.depth == 0 ? "" :					       \
> +	 ((show->flags & BTF_SHOW_COMPACT) && show->state.type &&	       \
> +	  BTF_INFO_KIND(show->state.type->info) == BTF_KIND_UNION) ? "|" : ",")
> +
> +#define btf_show_type_value(show, fmt, value)				       \
> +	do {								       \
> +		if ((value) != 0 || (show->flags & BTF_SHOW_ZERO) ||	       \
> +		    show->state.depth == 0) {				       \
> +			btf_show(show, "%s%s" fmt "%s%s",		       \
> +				 btf_show_indent(show),			       \
> +				 btf_show_name(show),			       \
> +				 value, btf_show_delim(show),		       \
> +				 btf_show_newline(show));		       \
> +			if (show->state.depth > show->state.depth_to_show)     \
> +				show->state.depth_to_show = show->state.depth; \
> +		}							       \
> +	} while (0)
> +
> +#define btf_show_type_values(show, fmt, ...)				       \
> +	do {								       \
> +		btf_show(show, "%s%s" fmt "%s%s", btf_show_indent(show),       \
> +			 btf_show_name(show),				       \
> +			 __VA_ARGS__, btf_show_delim(show),		       \
> +			 btf_show_newline(show));			       \
> +		if (show->state.depth > show->state.depth_to_show)	       \
> +			show->state.depth_to_show = show->state.depth;	       \
> +	} while (0)
> +
> +/* How much is left to copy to safe buffer after @data? */
> +#define btf_show_obj_size_left(show, data)				       \
> +	(show->obj.head + show->obj.size - data)
> +
> +/* Is object pointed to by @data of @size already copied to our safe buffer? */
> +#define btf_show_obj_is_safe(show, data, size)				       \
> +	(data >= show->obj.data &&					       \
> +	 (data + size) < (show->obj.data + BTF_SHOW_OBJ_SAFE_SIZE))
> +
> +/*
> + * If object pointed to by @data of @size falls within our safe buffer, return
> + * the equivalent pointer to the same safe data.  Assumes
> + * copy_from_kernel_nofault() has already happened and our safe buffer is
> + * populated.
> + */
> +#define __btf_show_obj_safe(show, data, size)				       \
> +	(btf_show_obj_is_safe(show, data, size) ?			       \
> +	 show->obj.safe + (data - show->obj.data) : NULL)

Similarly I don't understand the benefit of macros.
They all could have been normal functions.

> +static inline void *btf_show_obj_safe(struct btf_show *show,
> +				      const struct btf_type *t,
> +				      void *data)

drop 'inline' pls.

> +{
> +	int size_left, size;
> +	void *safe = NULL;
> +
> +	if (show->flags & BTF_SHOW_UNSAFE)
> +		return data;
> +
> +	(void) btf_resolve_size(show->btf, t, &size);

Is this ok to ignore the error?
