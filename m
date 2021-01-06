Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78612EB93E
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 06:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbhAFFOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 00:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbhAFFOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 00:14:00 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCBAC06134C;
        Tue,  5 Jan 2021 21:13:20 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id k78so1706073ybf.12;
        Tue, 05 Jan 2021 21:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JQUlyOnlBcqYVUIlvxW8hwy4E/pavn1J3HXdQXV8Lvk=;
        b=kbCCrZh5c1ImbAS9tD2b2hnbNIl79xI9+GPpSaJSu/1oVSwOOL8eUSODIIMiULfL4l
         ww7L5M4Marpbq3VDD4RB92aQxmssOHyQkqXLxGAYvef7EMutxLQ6BAQbbeoOapLm4XJH
         Y1hFrxdFOTlJn3d183K2x8+2w/SPg9957Z5ELM184TEONtUp3tPcoSJ1i4cYmZHv7F7s
         lL0lF2t5xt5EgrCyOa6zhwxZPNJygW4Y3e01Ec6K3QZEUsUaOAAdwMZ8sE3u9Xqw4tOK
         1ME0k/rhic0I2Jn/cZc1LBxeif3d22rXlNyjdmvQtYK3klzh2CVyzAHVT3GkxAFwcGeN
         Sq6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JQUlyOnlBcqYVUIlvxW8hwy4E/pavn1J3HXdQXV8Lvk=;
        b=IxNSq3p3H28X+XR76p+OD/CIOkY+d/h6dcx1RN6NeHRFKLxy7WOQH4PFABFjb6pCTe
         0SOOtxzRqmAZ140i7Wx32DAk0Vi0rUEWuUbD8FyDJOmqny6mQnJ3wIDmv9OcGBrk63sR
         BM6+zRZrX7F9NLWf+gDX1IPqbdRW2o84qQc2emXrh9KJFr0UQzeHw3dIX5PpRZUq5EMF
         C/ndlN4/3GS5RTlK9YVWQWzcSuJ0ToHf35pNxMfSCiidr7HzPxlT6tugY5gjVOHXTZSA
         PuZ9Z8rKFjWu45SryaL3VD8ZDIsmzEfqwS5i0/oZrai50fZYZW+HIdbzHIShjyPnHMJZ
         4SZg==
X-Gm-Message-State: AOAM532xu12ie9nFBzLKjCEEC4TFy6jzBsbEBCibeOJshrpChe5Ga0hp
        9hddtPOtkHnbFogk5vz1KL2aSpxksQKvmJTIUcg=
X-Google-Smtp-Source: ABdhPJzEnM3j1CwWqlvOkESK7lgjMYEeCUo7dcExofmmXMZcidTlqrM0G156QbrO8/A5wD9X7Hd9UOoo40L7aAWkOoc=
X-Received: by 2002:a25:818e:: with SMTP id p14mr3703964ybk.425.1609909999694;
 Tue, 05 Jan 2021 21:13:19 -0800 (PST)
MIME-Version: 1.0
References: <cover.1609855479.git.sean@mess.org> <67ffe6998af5cf88bdda6eaa1e6b085db1e093ed.1609855479.git.sean@mess.org>
In-Reply-To: <67ffe6998af5cf88bdda6eaa1e6b085db1e093ed.1609855479.git.sean@mess.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Jan 2021 21:13:09 -0800
Message-ID: <CAEf4BzZ_KLOiqR1jdcekui5uWTFjO9mt8+7UG8DKbUEdq0SHVQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] bpftool: add support for ints larger than 128 bits
To:     Sean Young <sean@mess.org>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        linux-doc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 6:45 AM Sean Young <sean@mess.org> wrote:
>
> clang supports arbitrary length ints using the _ExtInt extension. This
> can be useful to hold very large values, e.g. 256 bit or 512 bit types.
>
> This requires the _ExtInt extension enabled in clang, which is under
> review.
>
> Link: https://clang.llvm.org/docs/LanguageExtensions.html#extended-integer-types
> Link: https://reviews.llvm.org/D93103
>
> Signed-off-by: Sean Young <sean@mess.org>
> ---

all the same comments as in patch #1

>  tools/bpf/bpftool/btf_dumper.c | 40 ++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>
> diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
> index 0e9310727281..8b5318ec5c26 100644
> --- a/tools/bpf/bpftool/btf_dumper.c
> +++ b/tools/bpf/bpftool/btf_dumper.c
> @@ -271,6 +271,41 @@ static void btf_int128_print(json_writer_t *jw, const void *data,
>         }
>  }

[...]
