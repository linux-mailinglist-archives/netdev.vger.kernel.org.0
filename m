Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC83721E396
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 01:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgGMXZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 19:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgGMXZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 19:25:49 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26775C061755;
        Mon, 13 Jul 2020 16:25:49 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id b9so6204466plx.6;
        Mon, 13 Jul 2020 16:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5xn0OqUp0O7nqCbMsuOb1oZ0701cRSWUCiC9nyOTwII=;
        b=UBvbEld41mizD/D/AJ+KTIef/uEsz/YkQP4SYjpDx7bmoWJ6EWIn7cFA7MCJa3fTwE
         n+7EzC7krYOznuUeqtbeHLrKKQmfiNCcOy8nF3nLFqdHTW7zcqKZA7YgtcA4ITeDsjU5
         nlyghQM7YlK2wfK2K3NYZFAcPOxYVDqUUqGZlYQGemuf5SquNIu6IXJUzv8rJwxMbO7K
         BTciXx+uNBqULZ6zszCxhkCY7blW0SgFgOEzDBnltf08qtueTgAju1edbSIW5ecU573G
         9HTkPqXQ8rxRj9jSOXNILsdgpLkkrS9I0vXVFFdr4C28T06Xvu+MNZNGpQnXz9bRxnO9
         C9TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5xn0OqUp0O7nqCbMsuOb1oZ0701cRSWUCiC9nyOTwII=;
        b=VXXHGiQ3jUhy6oIc+RdbHJeKvOlblhPvgI1ZQ8cZsYB6MrT8fwguM+WPq32AIs9Bdi
         4juztXM+ydJsKyy48XhJsHqJsPBTTlwj+rWg1y1itRaQIZLmAj5wiSqltFwbqHFpcJrm
         bbRZJEs3fxQF04wuEm4tvSkLpzBjy7Em5/TmcoaQcEA9/cTwYAiwKuhLwt1s1PF13YGy
         PjHOOi6PsSa4u5PD1HPSov+y1gJmTyicOM6TmT9cheAVKSR6Dkx6r76vVv1NJgUN3vE/
         PoH5CkY0ZVWRFJi3Sa0HHaU2EhxeJDFcH74m34113fwWcJ4Wkg3LUIFWgEzyG1sYuLdI
         t+Cw==
X-Gm-Message-State: AOAM5338MakH7DCIErGvrifI0TMktZbjWPeRYu6AETNg8YXF7YDcHKXe
        vAVq8P0fR2UPw9oKS9h9bxU=
X-Google-Smtp-Source: ABdhPJwJ3c+RZ8cMsxWgLkViW6FhYWni3N6qXg/qFUlk5cpI/nGgIKPmhditqIA2eYZ9HtjtubOmSw==
X-Received: by 2002:a17:90a:d809:: with SMTP id a9mr1740942pjv.40.1594682748579;
        Mon, 13 Jul 2020 16:25:48 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1ca])
        by smtp.gmail.com with ESMTPSA id s194sm14294118pgs.24.2020.07.13.16.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 16:25:47 -0700 (PDT)
Date:   Mon, 13 Jul 2020 16:25:45 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next 03/13] bpf: support readonly buffer in verifier
Message-ID: <20200713232545.mmocpqgqpiapcdvg@ast-mbp.dhcp.thefacebook.com>
References: <20200713161739.3076283-1-yhs@fb.com>
 <20200713161742.3076597-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713161742.3076597-1-yhs@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 09:17:42AM -0700, Yonghong Song wrote:
> Two new readonly buffer PTR_TO_RDONLY_BUF or
> PTR_TO_RDONLY_BUF_OR_NULL register states
> are introduced. These new register states will be used
> by later bpf map element iterator.
> 
> New register states share some similarity to
> PTR_TO_TP_BUFFER as it will calculate accessed buffer
> size during verification time. The accessed buffer
> size will be later compared to other metrics during
> later attach/link_create time.
> 
> Two differences between PTR_TO_TP_BUFFER and
> PTR_TO_RDONLY_BUF[_OR_NULL].
> PTR_TO_TP_BUFFER is for write only
> and PTR_TO_RDONLY_BUF[_OR_NULL] is for read only.
> In addition, a rdonly_buf_seq_id is also added to the
> register state since it is possible for the same program
> there could be two PTR_TO_RDONLY_BUF[_OR_NULL] ctx arguments.
> For example, for bpf later map element iterator,
> both key and value may be PTR_TO_TP_BUFFER_OR_NULL.
> 
> Similar to reg_state PTR_TO_BTF_ID_OR_NULL in bpf
> iterator programs, PTR_TO_RDONLY_BUF_OR_NULL reg_type and
> its rdonly_buf_seq_id can be set at
> prog->aux->bpf_ctx_arg_aux, and bpf verifier will
> retrieve the values during btf_ctx_access().
> Later bpf map element iterator implementation
> will show how such information will be assigned
> during target registeration time.
...
>  struct bpf_ctx_arg_aux {
>  	u32 offset;
>  	enum bpf_reg_type reg_type;
> +	u32 rdonly_buf_seq_id;
>  };
>  
> +#define BPF_MAX_RDONLY_BUF	2
> +
>  struct bpf_prog_aux {
>  	atomic64_t refcnt;
>  	u32 used_map_cnt;
> @@ -693,6 +699,7 @@ struct bpf_prog_aux {
>  	u32 attach_btf_id; /* in-kernel BTF type id to attach to */
>  	u32 ctx_arg_info_size;
>  	const struct bpf_ctx_arg_aux *ctx_arg_info;
> +	u32 max_rdonly_access[BPF_MAX_RDONLY_BUF];

I think PTR_TO_RDONLY_BUF approach is too limiting.
I think the map value should probably be writable from the beginning,
but I don't see how this RDONLY_BUF support can be naturally extended.
Also key and value can be large, so just load/store is going to be
limiting pretty quickly. People would want to use helpers to access
key/value areas. I think any existing helper that accepts ARG_PTR_TO_MEM
should be usable with data from this key/value.
PTR_TO_TP_BUFFER was a quick hack for tiny scratch area.
Here I think the verifier should be smart from the start.

The next patch populates bpf_ctx_arg_aux with hardcoded 0 and 1.
imo that's too hacky. Helper definitions shouldn't be in business
of poking into such verifier internals.
