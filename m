Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0100FC2F0D
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 10:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbfJAImU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 04:42:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57166 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727659AbfJAImT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 04:42:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569919338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a8AWULPNBM5xtQu7TWGb1bj/ti/j5sBJfVkWEi3Rd3Y=;
        b=aOQuY7iu1kT2qh2Xnd0dafQigJtyaPMkP6TVJzC+xTsD4F9N5VFWhJ+D/63TXc6Wdl9BAA
        wJVSD6zmBTqvH60fIIRDO+dA3rqVqdbcQN+vIORg6R3EMvuftFXU/qDU1AyFMh+MqAnoLs
        gymjKUnzMCy7qGuVEt+Q0WmFtj3a4PU=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-yrdbpAotN9ipViEVNTj08Q-1; Tue, 01 Oct 2019 04:42:16 -0400
Received: by mail-lf1-f72.google.com with SMTP id y27so2606456lfg.21
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 01:42:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=TuBvw2mrfFOTeGw74SrYWhsZAQSjB9GnUTEtXc5MODI=;
        b=lZdu7fiJg107pzQfmU3R+eRSgY2SjjE7XtUTmKKqMUNaVjmn4a86gWu1NAPojc0lbS
         Pbw5LFwJc4izO+j4ub/XcUe0+BO0c4/j0cHsYHnAfsymIElfWmH8Mz5pkHRSFYpJ1/+N
         uzFWirYq5iaQHEtEzEnTLkG2W39V+GgIUK05FFZmmr7ip3DL+/gAeE7KqHYXht34VC/0
         Xlz2JmH1kqa5zUx7QxgNPQbpooZpX42JKfRcnt2H2mdd48M8Iin9Q8Spyb4qljXZS7Gr
         CPu2fS6E1PBe1Cbd+b7kj8VjZ60AkmEXDTFqo1/NbyDCQo9veNLOC0b+0cA9x5EBpcGK
         TbWQ==
X-Gm-Message-State: APjAAAVu1TG+fyOP2M0YKCbtVbJnHxCSag7W6YvsNzv5wnHDtDaPDmm3
        AolfzABjL/JbAhIbckNTVOGGtI7LJT8fa/eI7XJ+/EIgDm4Hm0LWV858gyGAGnrcNmfoy13IhOk
        smEMGsm56uqjPW5Zd
X-Received: by 2002:a19:98e:: with SMTP id 136mr14527940lfj.156.1569919334398;
        Tue, 01 Oct 2019 01:42:14 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyKrVuPVSgX4a/MGkl8g9g2PDDJ3Tdwznl48zEdEjQLVt8Zj37XSYapNlmxWf0vKrVuD6C9Dw==
X-Received: by 2002:a19:98e:: with SMTP id 136mr14527930lfj.156.1569919334230;
        Tue, 01 Oct 2019 01:42:14 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id b10sm3945539lji.48.2019.10.01.01.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 01:42:13 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 79D6618063D; Tue,  1 Oct 2019 10:42:12 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net,
        kpsingh@chromium.org
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [RFC][PATCH bpf-next] libbpf: add bpf_object__open_{file,mem} w/ sized opts
In-Reply-To: <20190930164239.3697916-1-andriin@fb.com>
References: <20190930164239.3697916-1-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 01 Oct 2019 10:42:11 +0200
Message-ID: <871rvwx3fg.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: yrdbpAotN9ipViEVNTj08Q-1
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
> OPTS_HAS, and OPTS_GET macros that hide all the NULL and size checks.
>
> Additionally, newly added libbpf APIs are encouraged to follow similar
> pattern of having all mandatory parameters as formal function parameters
> and always have optional (NULL-able) xxx_opts struct, which should
> always have real struct size as a first field and the rest would be
> optional parameters added over time, which tune the behavior of existing
> API, if specified by user.

I think this is a reasonable idea. It does require some care when adding
new options, though. They have to be truly optional. I.e., I could
imagine that we will have cases where the behaviour might need to be
different if a program doesn't understand a particular option (I am
working on such a case in the kernel ATM). You could conceivably use the
OPTS_HAS() macro to test for this case in the code, but that breaks if a
program is recompiled with no functional change: then it would *appear*
to "understand" that option, but not react properly to it.

In other words, this should only be used for truly optional bits (like
flags) where the default corresponds to unchanged behaviour relative to
when the option was added.

A few comments on the syntax below...


> +static struct bpf_object *
> +__bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
> +=09=09       struct bpf_object_open_opts *opts, bool enforce_kver)

I realise this is an internal function, but why does it have a
non-optional parameter *after* the opts?

>  =09char tmp_name[64];
> +=09const char *name;
> =20
> -=09/* param validation */
> -=09if (!obj_buf || obj_buf_sz <=3D 0)
> -=09=09return NULL;
> +=09if (!OPTS_VALID(opts) || !obj_buf || obj_buf_sz =3D=3D 0)
> +=09=09return ERR_PTR(-EINVAL);
> =20
> +=09name =3D OPTS_GET(opts, object_name, NULL);
>  =09if (!name) {
>  =09=09snprintf(tmp_name, sizeof(tmp_name), "%lx-%lx",
>  =09=09=09 (unsigned long)obj_buf,
>  =09=09=09 (unsigned long)obj_buf_sz);
>  =09=09name =3D tmp_name;
>  =09}
> +
>  =09pr_debug("loading object '%s' from buffer\n", name);
> =20
> -=09return __bpf_object__open(name, obj_buf, obj_buf_sz, true, true);
> +=09return __bpf_object__open(name, obj_buf, obj_buf_sz, enforce_kver, 0)=
;
> +}
> +
> +struct bpf_object *
> +bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
> +=09=09     struct bpf_object_open_opts *opts)
> +{
> +=09return __bpf_object__open_mem(obj_buf, obj_buf_sz, opts, false);
> +}
> +
> +struct bpf_object *
> +bpf_object__open_buffer(const void *obj_buf, size_t obj_buf_sz, const ch=
ar *name)
> +{
> +=09struct bpf_object_open_opts opts =3D {
> +=09=09.sz =3D sizeof(struct bpf_object_open_opts),
> +=09=09.object_name =3D name,
> +=09};

I think this usage with the "size in struct" model is really awkward.
Could we define a macro to help hide it? E.g.,

#define BPF_OPTS_TYPE(type) struct bpf_ ## type ## _opts
#define DECLARE_BPF_OPTS(var, type) BPF_OPTS_TYPE(type) var =3D { .sz =3D s=
izeof(BPF_OPTS_TYPE(type)); }

Then the usage code could be:

DECLARE_BPF_OPTS(opts, object_open);
opts.object_name =3D name;

Still not ideal, but at least it's less boiler plate for the caller, and
people will be less likely to mess up by forgetting to add the size.

-Toke

