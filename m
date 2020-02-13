Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7A7615C291
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 16:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgBMPes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 10:34:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56953 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727511AbgBMPdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 10:33:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581607985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RFvkSpm4IwLd01HTkzruRySmSPs5no9cLpZYqP7h4Y8=;
        b=TmRkcMHBClzRLkZUf8CILrLro4guakeKKayoq6Bq4pXEJWnBcznUiS7PSjv2PtDx5blck9
        E+qgQHQGlxru++MJSf3CyOugDU4eXiQQnJjQjdpJMufcLkG3l7yJkWnyvF97w0F8C9kddZ
        NTrDz69Dvkc0JK1BHow8zi/AALYBof0=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-FS36aJkGMm25-P1LwcjhiQ-1; Thu, 13 Feb 2020 10:32:04 -0500
X-MC-Unique: FS36aJkGMm25-P1LwcjhiQ-1
Received: by mail-lj1-f198.google.com with SMTP id y24so2237210ljc.19
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 07:32:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=RFvkSpm4IwLd01HTkzruRySmSPs5no9cLpZYqP7h4Y8=;
        b=fsBXKTeNZexNJWcMR4QO4AS5V+o4ympy/qVUiUiwsJT0FAkWRLIsy+AwR78jhbEM+2
         5MR/KNoEpny4I9GM/tmxKmNZWdBN1hYIUvYJDtfC1QmGK3BPIR3jJwbp3+TnsKp4xllL
         XjAsEnp80/lW2UgG+sDw50VTGdFa9VrcNSBIN0k/5sjnU8GJpSZczZtfbtHS1ha+VbRp
         lFxHIGm0AaWvN1p6AOZvYXJKdeuEiWjdDvqWcKkexXM29LfkDr7vc2Wq7N5cztwO1nye
         G8CO29Eqs7UeyDxJf2BBJ6dGlHRG8B91jxzO1xnEKm1NKNqrTQX3+62GIXrqG/1S1Nn3
         /84g==
X-Gm-Message-State: APjAAAXJO50pcdrq5VSra5UIbjSoNSYoSMstP79HV0kf0LzvWd0UfvIM
        LM4wlEbjKPb1pj/E35f20CcBu+hfuCOpCChUOg5JzfV577s12vTUl02yuWI0pJtzMsZ/NhymWOy
        jHwdNibUsGSo8nEoZ
X-Received: by 2002:a2e:7818:: with SMTP id t24mr11193081ljc.195.1581607923162;
        Thu, 13 Feb 2020 07:32:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqw0y9boF3lVrvrxVIhdVwRR6fhl5800oZPJ3Twbe8XRUDRYmViuzFOpaQTcoR3Z8ImnxC8Dfw==
X-Received: by 2002:a2e:7818:: with SMTP id t24mr11193064ljc.195.1581607922961;
        Thu, 13 Feb 2020 07:32:02 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a12sm1699198ljk.48.2020.02.13.07.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 07:32:02 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9103B180365; Thu, 13 Feb 2020 16:32:01 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Eelco Chaudron <echaudro@redhat.com>, bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com
Subject: Re: [PATCH bpf-next v2] libbpf: Add support for dynamic program attach target
In-Reply-To: <158160616195.80320.5636088335810242866.stgit@xdp-tutorial>
References: <158160616195.80320.5636088335810242866.stgit@xdp-tutorial>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 13 Feb 2020 16:32:01 +0100
Message-ID: <87h7zuh5am.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eelco Chaudron <echaudro@redhat.com> writes:

> Currently when you want to attach a trace program to a bpf program
> the section name needs to match the tracepoint/function semantics.
>
> However the addition of the bpf_program__set_attach_target() API
> allows you to specify the tracepoint/function dynamically.
>
> The call flow would look something like this:
>
>   xdp_fd = bpf_prog_get_fd_by_id(id);
>   trace_obj = bpf_object__open_file("func.o", NULL);
>   prog = bpf_object__find_program_by_title(trace_obj,
>                                            "fentry/myfunc");
>   bpf_program__set_expected_attach_type(prog, BPF_TRACE_FENTRY);
>   bpf_program__set_attach_target(prog, xdp_fd,
>                                  "xdpfilt_blk_all");
>   bpf_object__load(trace_obj)
>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Hmm, one question about the attach_prog_fd usage:

> +int bpf_program__set_attach_target(struct bpf_program *prog,
> +				   int attach_prog_fd,
> +				   const char *attach_func_name)
> +{
> +	int btf_id;
> +
> +	if (!prog || attach_prog_fd < 0 || !attach_func_name)
> +		return -EINVAL;
> +
> +	if (attach_prog_fd)
> +		btf_id = libbpf_find_prog_btf_id(attach_func_name,
> +						 attach_prog_fd);
> +	else
> +		btf_id = __find_vmlinux_btf_id(prog->obj->btf_vmlinux,
> +					       attach_func_name,
> +					       prog->expected_attach_type);

This implies that no one would end up using fd 0 as a legitimate prog
fd. This already seems to be the case for the existing code, but is that
really a safe assumption? Couldn't a caller that closes fd 0 (for
instance while forking) end up having it reused? Seems like this could
result in weird hard-to-debug bugs?

-Toke

