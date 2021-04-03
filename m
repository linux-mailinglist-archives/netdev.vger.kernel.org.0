Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0F63533B0
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 13:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbhDCLY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 07:24:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37929 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236484AbhDCLYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 07:24:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617449056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9RVGqNi4MWzOBgTnzvPf0ZLmKv8daFIj0J8GLugt1q4=;
        b=WF2Lw+3CIUJV8l/u6YFICECd5NPrVyemQCM4Yef/q3fSqRw44LCZA4E47mHzWZhJHZpk9H
        dw54bHaMtgNOfXSjIaOwSGkrteIrwxZP577StKZSeuRm/pu24tfKdz9vNSZAPxDw1NjlVo
        pTMBVYYaZikoUk2pJIF5RDECA6Mzvm8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-vOORpRjFNiq5KJOx-8K1nA-1; Sat, 03 Apr 2021 07:24:14 -0400
X-MC-Unique: vOORpRjFNiq5KJOx-8K1nA-1
Received: by mail-ed1-f70.google.com with SMTP id j18so5938095edv.6
        for <netdev@vger.kernel.org>; Sat, 03 Apr 2021 04:24:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=9RVGqNi4MWzOBgTnzvPf0ZLmKv8daFIj0J8GLugt1q4=;
        b=Op/OGr4NS0rf2l3saP7uNY0o5nvddthnBebaBRhkzdOC/e4wIGkkCHxQnKhQ5xj3mV
         0bmXAO3m8Ocn+HQHBhZIEVhxn19KWrKih0H0knzaWTH5vYFD9nQx90lRLwGdxwaOjkJe
         am+3NwyvH30GPLdPqLBLNSZYbN89EctZMbit57pUUqy/vhkRotEFn7FUoARnEtpxGUku
         V34zzAbCPs/smlvUMUzA5iUtQMRIF5hz8opFyPQyQLsrrcsQiTSA5PCJbwNsf39kGTf+
         zSQy9f+7xyPTOpI2kzCccDcnUp50oHK+A5P2BuDuokltXZ/DX8PENxTSlrIX4jc9UMph
         svKw==
X-Gm-Message-State: AOAM533XyCXwQhhFMaFjMxS0FfFe28OTKzSJeqISCsUS5Tnr7QH+ebvN
        SWu17o4rF/obotIFofpqgu49xkMxKD7gxm4pqOT/xokc0FxwOC7Irguv0OBeY8BgPqQxnfOat0E
        pOPg/WQ17mFWFmq7H
X-Received: by 2002:a05:6402:4242:: with SMTP id g2mr20310427edb.329.1617449053581;
        Sat, 03 Apr 2021 04:24:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9MY8m/cZHdqvIfBRJGYPuoJIfHN6fz7yBerZqe+1ozfead+cKwmcyf7b/a70b3dHlBDcwnQ==
X-Received: by 2002:a05:6402:4242:: with SMTP id g2mr20310413edb.329.1617449053448;
        Sat, 03 Apr 2021 04:24:13 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v22sm5340581ejj.103.2021.04.03.04.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 04:24:12 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 37A41180292; Sat,  3 Apr 2021 13:24:12 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC PATCH bpf-next 1/4] bpf: Allow trampoline re-attach
In-Reply-To: <20210328112629.339266-2-jolsa@kernel.org>
References: <20210328112629.339266-1-jolsa@kernel.org>
 <20210328112629.339266-2-jolsa@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 03 Apr 2021 13:24:12 +0200
Message-ID: <87blavd31f.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Olsa <jolsa@kernel.org> writes:

> Currently we don't allow re-attaching of trampolines. Once
> it's detached, it can't be re-attach even when the program
> is still loaded.
>
> Adding the possibility to re-attach the loaded tracing
> kernel program.

Hmm, yeah, didn't really consider this case when I added the original
disallow. But don't see why not, so (with one nit below):

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/bpf/syscall.c    | 25 +++++++++++++++++++------
>  kernel/bpf/trampoline.c |  2 +-
>  2 files changed, 20 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 9603de81811a..e14926b2e95a 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2645,14 +2645,27 @@ static int bpf_tracing_prog_attach(struct bpf_pro=
g *prog,
>  	 *   target_btf_id using the link_create API.
>  	 *
>  	 * - if tgt_prog =3D=3D NULL when this function was called using the old
> -         *   raw_tracepoint_open API, and we need a target from prog->aux
> -         *
> -         * The combination of no saved target in prog->aux, and no target
> -         * specified on load is illegal, and we reject that here.
> +	 *   raw_tracepoint_open API, and we need a target from prog->aux
> +	 *
> +	 * The combination of no saved target in prog->aux, and no target
> +	 * specified on is legal only for tracing programs re-attach, rest
> +	 * is illegal, and we reject that here.
>  	 */
>  	if (!prog->aux->dst_trampoline && !tgt_prog) {
> -		err =3D -ENOENT;
> -		goto out_unlock;
> +		/*
> +		 * Allow re-attach for tracing programs, if it's currently
> +		 * linked, bpf_trampoline_link_prog will fail.
> +		 */
> +		if (prog->type !=3D BPF_PROG_TYPE_TRACING) {
> +			err =3D -ENOENT;
> +			goto out_unlock;
> +		}
> +		if (!prog->aux->attach_btf) {
> +			err =3D -EINVAL;
> +			goto out_unlock;
> +		}

I'm wondering about the two different return codes here. Under what
circumstances will aux->attach_btf be NULL, and why is that not an
ENOENT error? :)

-Toke

