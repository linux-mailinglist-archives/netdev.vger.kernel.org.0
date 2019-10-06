Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 413DBCCDB7
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 03:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfJFBYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 21:24:23 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:32850 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbfJFBYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 21:24:22 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so6263389pfl.0;
        Sat, 05 Oct 2019 18:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GP1jZ0/ZpDTCrDHKY0Qf+ZjmJomNMuLdiTBOuMV4ANw=;
        b=mWGwsk+eb3rWLBc4UY66YuKF31+KlEE3eRDInsQlEA8w7SaGavoPDfvnef8AyTOXfi
         SHn1GOwxPQ5CH0PdZDl0Fi2hJvAhLc2ER9l/v93VqXH0p/aNP5vlz7Eya2Dtz9Ap8ebO
         0cEWI0RqXEg7/ApcyejuuxrqX6hPOAyUTAEo4YkH0L7WIpkIBZafcydHCjoFUtpuMuhp
         mP6XQeoahZR0FVyO3z4ibOMPIVubZfC2K3NFK9gm52WwYcnIaK7jTmiLNB9nEHnk9NnU
         LvjDpfHaUJXs+FG66TL6M2HdWgVetaXxI7bHSU0JmFtpwMrhONIE3ClKeVnl5IIJQaGf
         DBJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GP1jZ0/ZpDTCrDHKY0Qf+ZjmJomNMuLdiTBOuMV4ANw=;
        b=S0bKO0vHeB/XtQ5jOYGv4396vF3soMV/fG21uz9ubUQZjoDxYysKEbzgYc9GqRrkb0
         dVdZZQ1UptUOuYC0G//8MNcO8THr7WFpiiBu/7mTEhXjeYPwrsAsV3UqTmUPLixmZiFS
         q3A1xH2i502dohfr6u0jeOLSSQb3WhrgudApXDrc7NmwKKrCtNU+3EPhHCrGheFtmGqp
         K207W1abCHftMyb0wJLlWbZRW31CAEErTo8nrpr60FkDGmgQ1FwPiPZOWrDJzfdM5tRB
         iV/yUuihMIvX64IsD6bLfzyaCiS3Uc35gZUFCISN9+kfqhMfEBxWa/FIpewSCu81xdvK
         sNfg==
X-Gm-Message-State: APjAAAUHmQSgJuPEsqwITnZsHP7XzVAislH4OdeAvxnSu68w68NxhrAt
        sq+q0Ft1QpMop+W8UYjLYeg=
X-Google-Smtp-Source: APXvYqyL+gUyMDr1TvTLsOE1gTDHAZzbh+CAv2acj5rF9u/KXEDDJDvp0kkw4GARgpfbc/gYeaHGnQ==
X-Received: by 2002:a17:90a:b704:: with SMTP id l4mr26237806pjr.132.1570325061591;
        Sat, 05 Oct 2019 18:24:21 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::7b19])
        by smtp.gmail.com with ESMTPSA id e192sm12077190pfh.83.2019.10.05.18.24.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Oct 2019 18:24:20 -0700 (PDT)
Date:   Sat, 5 Oct 2019 18:24:18 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 2/4] libbpf: add bpf_object__open_{file,mem}
 w/ extensible opts
Message-ID: <20191006012416.5lq4xhhmdtgcoemc@ast-mbp>
References: <20191004224037.1625049-1-andriin@fb.com>
 <20191004224037.1625049-3-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004224037.1625049-3-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 03:40:35PM -0700, Andrii Nakryiko wrote:
> Add new set of bpf_object__open APIs using new approach to optional
> parameters extensibility allowing simpler ABI compatibility approach.
> 
> This patch demonstrates an approach to implementing libbpf APIs that
> makes it easy to extend existing APIs with extra optional parameters in
> such a way, that ABI compatibility is preserved without having to do
> symbol versioning and generating lots of boilerplate code to handle it.
> To facilitate succinct code for working with options, add OPTS_VALID,
> OPTS_HAS, and OPTS_GET macros that hide all the NULL, size, and zero
> checks.
> 
> Additionally, newly added libbpf APIs are encouraged to follow similar
> pattern of having all mandatory parameters as formal function parameters
> and always have optional (NULL-able) xxx_opts struct, which should
> always have real struct size as a first field and the rest would be
> optional parameters added over time, which tune the behavior of existing
> API, if specified by user.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
...
> +/* Helper macro to declare and initialize libbpf options struct
> + *
> + * This dance with uninitialized declaration, followed by memset to zero,
> + * followed by assignment using compound literal syntax is done to preserve
> + * ability to use a nice struct field initialization syntax and **hopefully**
> + * have all the padding bytes initialized to zero. It's not guaranteed though,
> + * when copying literal, that compiler won't copy garbage in literal's padding
> + * bytes, but that's the best way I've found and it seems to work in practice.
> + */
> +#define LIBBPF_OPTS(TYPE, NAME, ...)					    \
> +	struct TYPE NAME;						    \
> +	memset(&NAME, 0, sizeof(struct TYPE));				    \
> +	NAME = (struct TYPE) {						    \
> +		.sz = sizeof(struct TYPE),				    \
> +		__VA_ARGS__						    \
> +	}
> +
> +struct bpf_object_open_opts {
> +	/* size of this struct, for forward/backward compatiblity */
> +	size_t sz;
> +	/* object name override, if provided:
> +	 * - for object open from file, this will override setting object
> +	 *   name from file path's base name;
> +	 * - for object open from memory buffer, this will specify an object
> +	 *   name and will override default "<addr>-<buf-size>" name;
> +	 */
> +	const char *object_name;
> +	/* parse map definitions non-strictly, allowing extra attributes/data */
> +	bool relaxed_maps;
> +};
> +#define bpf_object_open_opts__last_field relaxed_maps

LIBBPF_OPTS macro doesn't inspire confidence, but despite the ugliness
it is strictly better than what libbpf is using internally to interface
into kernel via similar bpf_attr api.
So I think it's an improvement.
Should this macro be used inside libbpf as well?
May be rename it too to show that it's not libbpf specific?

Anyhow all that can be done in follow up.

Applied. Thanks

