Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D62447E79C
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 19:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240292AbhLWSZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 13:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbhLWSZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 13:25:42 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48905C061401;
        Thu, 23 Dec 2021 10:25:42 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id x6so8099421iol.13;
        Thu, 23 Dec 2021 10:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bkeC37Zi2eQlPHWKkUOW7/K1ALXw1TSPJ+MC9brKUl8=;
        b=SPxWgUrwIb9GG0sHRFHkNVVBAVMdNIdiD/4T+D3jp9B5gFJNULSAVkm+rMOKF8REl5
         M7no5yq8esJWGMYWXcr5M83LKc5NvCLCjF4UazrX3EE7IIz5QSHYqcs9zTz6SqNrg9JF
         8uLc6KK52/C3U3fT/Phukm9Is3Pax4T2OELHaCObMXS25yJNdJVZrMqc4COyvOUzDfXg
         bOiSLqMOnQk81EGGhHP0k/8PXjheAh+eTlfuyC5ntln/Auvt8dSnE22ri2O+vB6xUM9k
         Bl1fHbpNojJF+QwF07v43OSXQsgkaCbKdtqfsVQQ0TgXSNZmj7t58fNFkQRRU1i3kMJB
         coDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bkeC37Zi2eQlPHWKkUOW7/K1ALXw1TSPJ+MC9brKUl8=;
        b=eSxIk2skNNWL69oX9dzWCGSkJCOB+YibaKQadsEvCojC+rEpK4zaNkQrnD9PdTuOmT
         wMrK+liRa5Kr3WbDqEvv4a98rzfCW/SxHZZjWaXyt6ydV5CDVwfGZ6dnNTbLGB552HYH
         lyNJQLakr/RuxspbtW5dWaKjRyr7mDdSrC+OQySFSiXK0TwHZ6MQ8rA6m8LZ28vZshDG
         z0rRRS2GH5P3G8ESa7bmvN+tJVuR3upza7byWXjd8V/fj/jwLzcr9zJtSVuWFPq+Bwf6
         u9UqdQD+MAuXaBhscPqQ0mUNgC6wBbTzdJ85dh7JKmE5arKCGrvXF1uNj0vpD7X4+IYL
         NJAQ==
X-Gm-Message-State: AOAM530Ih7TP2O24aKsURSZsqllln2r+yvJE9C3+b+Z4scGiISundjqU
        cJwblomadfPMR9v/mkHq6T4AQrvlFuGkYkdHZv4=
X-Google-Smtp-Source: ABdhPJydQ7HjaLrV0bIhS5oiL7LAoDMghpiOZ+jKHkkmdYnPIRfr6bii23LWgtte2O5I2+eOEAF/ixiNrCGHTxsfLhk=
X-Received: by 2002:a05:6602:1495:: with SMTP id a21mr1863347iow.79.1640283941692;
 Thu, 23 Dec 2021 10:25:41 -0800 (PST)
MIME-Version: 1.0
References: <20211223131736.483956-1-jolsa@kernel.org> <48c1e6bf-ee4b-bf49-ec85-2cec98ab9dcb@fb.com>
In-Reply-To: <48c1e6bf-ee4b-bf49-ec85-2cec98ab9dcb@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 23 Dec 2021 10:25:30 -0800
Message-ID: <CAEf4BzZuhmOeq95-9_-ZRM+aFZUp-FaT8m-=smktm5pwXQDZ0w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] libbpf: Do not use btf_dump__new macro for
 c++ objects
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 8:13 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 12/23/21 5:17 AM, Jiri Olsa wrote:
> > As reported in here [0], C++ compilers don't support __builtin_types_compatible_p(),
> > so at least don't screw up compilation for them and let C++ users
> > pick btf_dump__new vs btf_dump__new_deprecated explicitly.
> >
> > [0] https://github.com/libbpf/libbpf/issues/283#issuecomment-986100727
> > Fixes: 6084f5dc928f ("libbpf: Ensure btf_dump__new() and btf_dump_opts are future-proof")
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>
> Acked-by: Yonghong Song <yhs@fb.com>


Adjusted commit message a but and applied to bpf-next, thanks.
