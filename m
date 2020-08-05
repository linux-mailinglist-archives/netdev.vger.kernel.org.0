Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0070723C60B
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 08:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgHEGgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 02:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbgHEGgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 02:36:05 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB080C06174A;
        Tue,  4 Aug 2020 23:36:04 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id 2so23240457ybr.13;
        Tue, 04 Aug 2020 23:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZTpkqBsHDSfHev3rtRvjzecIk5USD4wv9n4waqLaeZs=;
        b=pAYIKJ6eRcSl3U4PsUYOWhQRUbkSUijrJpxieWGbkrBLDtCH0nhFjnrZJaIoMa7nas
         wwcaxSSOkrA4poLJVJwN2Shaw4kEmc80Sw2yftzpRBwt+kaH4d/JywVpiChihwYH9HWO
         bENGwfuk31Sq/GhGSbQWifzBADXHtMiBXagUyDttykzaO9KcFsnkun+8VCIegrbRjVSG
         dEa3H2xe1CqbiAZIOSkUdsUo+iugFJy4zpAUwLf103jdmS7JLSqyPyfll358xH9KalSt
         1kGIKMILcreRdsvitZfTVMm/tKwVIfZ8jZTxqwLG9UsQUJ7D9v14QGWGdlEgyIKwGzdc
         qpEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZTpkqBsHDSfHev3rtRvjzecIk5USD4wv9n4waqLaeZs=;
        b=L/akPYUBsBD+kSASAWq80RMCy3NQVEGxGwVsz4TVh5kBbnYidZs3kGwq0dWtPWuIFj
         YC9xyYiyuu8N+xO2E8vVbuZghe9JboE1JAFyg/x3HchTyBmGH4AwzhT7IIA9P4yKcjme
         /X5PjRNDzCr0pF/248l1HG24PxGFFriX02CcjKe3xzkAgVa8UagXpxEAMNuNCthubUd4
         BMDaGGh3M6uS7hDy7we+kaGusVj8pL0dBJG3zSVbNvRUJqvQWQBcuEPk5RBTmAwoFeUq
         2dWyVj4sn/0dXOgO2dWhs6HzOQjhC9ZgZNbX096f+Hpy3X3uIvBQsCV6PEyfmaNu5soO
         92Qw==
X-Gm-Message-State: AOAM5321aNN+2GitGSdH0r9oWfBsmr+nl6QH48uK+8mDuff/rsNKpbEy
        2j+/hAs5aO6ZJsrM0Ar3FaY+Z+7oJWWm3viFYGw=
X-Google-Smtp-Source: ABdhPJznvW9kDYu70DSVBNaZgMAqCfBuqMsEbVMR+ymC5JDdKdQQ7cPBlnyBsibgSPm9SjsR5dC3zuSV8Asl5SZIC3E=
X-Received: by 2002:a25:824a:: with SMTP id d10mr2651488ybn.260.1596609364223;
 Tue, 04 Aug 2020 23:36:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200801170322.75218-1-jolsa@kernel.org> <20200801170322.75218-11-jolsa@kernel.org>
In-Reply-To: <20200801170322.75218-11-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Aug 2020 23:35:53 -0700
Message-ID: <CAEf4BzY5b8GhoovkKZgT4YSUUW=GPZBU0Qjg4eqeHNjoPHCMTw@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 10/14] bpf: Add d_path helper
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 1, 2020 at 10:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding d_path helper function that returns full path for
> given 'struct path' object, which needs to be the kernel
> BTF 'path' object. The path is returned in buffer provided
> 'buf' of size 'sz' and is zero terminated.
>
>   bpf_d_path(&file->f_path, buf, size);
>
> The helper calls directly d_path function, so there's only
> limited set of function it can be called from. Adding just
> very modest set for the start.
>
> Updating also bpf.h tools uapi header and adding 'path' to
> bpf_helpers_doc.py script.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/uapi/linux/bpf.h       | 13 +++++++++
>  kernel/trace/bpf_trace.c       | 48 ++++++++++++++++++++++++++++++++++
>  scripts/bpf_helpers_doc.py     |  2 ++
>  tools/include/uapi/linux/bpf.h | 13 +++++++++
>  4 files changed, 76 insertions(+)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index eb5e0c38eb2c..a356ea1357bf 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3389,6 +3389,18 @@ union bpf_attr {
>   *             A non-negative value equal to or less than *size* on success,
>   *             or a negative error in case of failure.
>   *
> + * int bpf_d_path(struct path *path, char *buf, u32 sz)

nit: probably would be good to do `const struct path *` here, even if
we don't do const-ification properly in all helpers.

> + *     Description
> + *             Return full path for given 'struct path' object, which
> + *             needs to be the kernel BTF 'path' object. The path is
> + *             returned in buffer provided 'buf' of size 'sz' and

typo: in the provided buffer 'buf' of size ... ?

> + *             is zero terminated.
> + *
> + *     Return
> + *             On success, the strictly positive length of the string,
> + *             including the trailing NUL character. On error, a negative
> + *             value.
> + *
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -3533,6 +3545,7 @@ union bpf_attr {
>         FN(skc_to_tcp_request_sock),    \
>         FN(skc_to_udp6_sock),           \
>         FN(get_task_stack),             \
> +       FN(d_path),                     \
>         /* */
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index cb91ef902cc4..02a76e246545 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1098,6 +1098,52 @@ static const struct bpf_func_proto bpf_send_signal_thread_proto = {
>         .arg1_type      = ARG_ANYTHING,
>  };
>
> +BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
> +{
> +       int len;
> +       char *p;
> +
> +       if (!sz)
> +               return -ENAMETOOLONG;

if we are modeling this after bpf_probe_read_str(), sz == 0 returns
success and just does nothing. I don't think anyone will ever handle
or expect this error. I'd just return 0.


> +
> +       p = d_path(path, buf, sz);
> +       if (IS_ERR(p)) {
> +               len = PTR_ERR(p);
> +       } else {
> +               len = buf + sz - p;
> +               memmove(buf, p, len);
> +       }
> +
> +       return len;
> +}
> +

[...]
