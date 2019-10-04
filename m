Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248BDCB48C
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 08:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388321AbfJDGiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 02:38:18 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23678 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387864AbfJDGiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 02:38:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570171097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e2vQy4nCiKJtPP2YUeyLGNlBXDwMdQo8pJX2YFwX0IM=;
        b=a+ItIDqiTvIjWasj6aEamCPruij2qpL00g2+k2K2iF6CRhb+RiYAKFiSr44PVmXVxni7HG
        nSfiP/u6fPwTrDi80/ic3imSLYctEQqaT1vblGUFTVPdwknNt3cUjM0i/Qanepn+BKrZ2g
        2r1ALTgget36VdSf6U1Imf9PFF1D8zo=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-G6VrFlhvNB2frLWhw4UQZA-1; Fri, 04 Oct 2019 02:38:13 -0400
Received: by mail-lj1-f198.google.com with SMTP id v24so1453721ljh.23
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 23:38:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=zerJ5a4bqZ6C2r8FC8tJikvRyWEeCzjBczh0mC/7AFg=;
        b=rctKY0J5P7cniaNGZDQNeBlyG7ixnFcgIPxsOd4a+NmZ/HMWJkm+OQg8av8zgJ1Q5q
         ydXv2P67KLjTvw1ZfVv04JjD1ptKwxYH6Wz7kAbuc6SQxrk8NJbgaNjw25FpPyJagiao
         Z1+MGVaVz/ZrqDXshK9T63wRrLEBOsgh2AIBDk/tv9gWbSlIUQu0smPA7mGXGgJKkjZU
         YelChm14X0npVm/Q1iz8axwZ4GJkix+Bn3SPV7OtwdLn57keSieipSFg6PaSo9KRBWy7
         kfkGrp03bBT+Y0wf6g6PTuY4bxtlB66Aw6zcMFeg+bQiykjn16lt58QeLKzdntgf66a4
         WeYQ==
X-Gm-Message-State: APjAAAUaLIh2YANIzg3N9/O7vmbK63oq3xbln63EL8MCDXqMf0bR1qm3
        9Qj+eiqr8ETD7rh3qG+kp1c6lDGu49pfqjpITRda4i2XwfzyFmbT7hU9KoL6aHUQcyK/+u7PcAb
        IlhqMNjQqoy0Nj4Ce
X-Received: by 2002:a2e:7611:: with SMTP id r17mr3698370ljc.133.1570171091517;
        Thu, 03 Oct 2019 23:38:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwEX2q87AKMLDQvOqCaRenXaH/M92WsTcEpetLiwcWYfwtfHNpX5BZTfewnq2ByXX527GH7bg==
X-Received: by 2002:a2e:7611:: with SMTP id r17mr3698356ljc.133.1570171091294;
        Thu, 03 Oct 2019 23:38:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id c69sm1072603ljf.32.2019.10.03.23.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 23:38:10 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 72C1718063D; Fri,  4 Oct 2019 08:38:09 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v2 bpf-next 2/3] libbpf: add bpf_object__open_{file,mem} w/ extensible opts
In-Reply-To: <20191004053235.2710592-3-andriin@fb.com>
References: <20191004053235.2710592-1-andriin@fb.com> <20191004053235.2710592-3-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 04 Oct 2019 08:38:09 +0200
Message-ID: <87bluxow1a.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: G6VrFlhvNB2frLWhw4UQZA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

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
> ---
>  tools/lib/bpf/libbpf.c          | 51 ++++++++++++++++++++++++++++-----
>  tools/lib/bpf/libbpf.h          | 36 +++++++++++++++++++++--
>  tools/lib/bpf/libbpf.map        |  3 ++
>  tools/lib/bpf/libbpf_internal.h | 32 +++++++++++++++++++++
>  4 files changed, 112 insertions(+), 10 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 056769ce4fd0..503fba903e99 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3620,16 +3620,33 @@ struct bpf_object *bpf_object__open(const char *p=
ath)
>  =09return bpf_object__open_xattr(&attr);
>  }
> =20
> -struct bpf_object *bpf_object__open_buffer(void *obj_buf,
> -=09=09=09=09=09   size_t obj_buf_sz,
> -=09=09=09=09=09   const char *name)
> +struct bpf_object *
> +bpf_object__open_file(const char *path, struct bpf_object_open_opts *opt=
s)
> +{
> +=09if (!OPTS_VALID(opts, bpf_object_open_opts))
> +=09=09return ERR_PTR(-EINVAL);
> +=09if (!path)
> +=09=09return ERR_PTR(-EINVAL);
> +
> +=09pr_debug("loading %s\n", path);
> +
> +=09return __bpf_object__open(path, NULL, 0, 0);
> +}

This is not doing anything with opts...

[...]

> +struct bpf_object_open_opts {
> +=09/* size of this struct, for forward/backward compatiblity */
> +=09size_t sz;
> +=09/* object name override, if provided:
> +=09 * - for object open from file, this will override setting object
> +=09 *   name from file path's base name;

... but this says it should be, no?

-Toke

