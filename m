Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAB61CB712
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 20:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgEHSZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 14:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726948AbgEHSZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 14:25:03 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0287C061A0C;
        Fri,  8 May 2020 11:25:03 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id 19so2725085ioz.10;
        Fri, 08 May 2020 11:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B+INd7V6WsPV69b0ltqt1ElbcHXHjVKgLGixyO4x2go=;
        b=YfvDGx8Js8tFGh/cGMssuCcsVybqcvDkXUJ80OI0sPMDqi9oUmQy8s+5Hk7mEYREzk
         oUdWoYQ2MVgrY7KKgQDAoHl1bjDsjPri1vdXNnuYWdt/LnAV+cs6qlona80+xw+EtC/o
         7nl9MaQrRC7vLiCOu6ZxfEpUFO0+IY/ZfiL2lopOrSQtSj22ueQD+feKyF0jmh84g1gx
         VGMmmbL0BkyBcfwY++vL/jQTJJw4QQgWYbbGsdwXOzP4U2nbj5dcrSrB+bomn8fizQvp
         AbY1bY4dOmJQaXNzkjfbRHTDO2TfGHLFo46ne70blTqIEzwwxBVVS6xNpz+6NToAI2bJ
         uXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B+INd7V6WsPV69b0ltqt1ElbcHXHjVKgLGixyO4x2go=;
        b=fDbhXbu4wj9NnbxzJ/ZHsrMpQaoaI+vEgSo9hdAXTob11DewSjG2e/daM6qSCKs6gC
         1CWdMDJfYr8nhzYq0gU5Q2w8WYTh9naHtYcp68pRrRC+myit2iODxJhzVeK9NgEUojJ9
         ydct/psiLjiOw0XF+XJ3felzfu1lareixGNhnSQTXDmZXFmPqvfWxx/UIbBIHPki4NMA
         MtCxUA7DTPjw4IH+47q74apuyupRx+ApLDDgAVJ2cvJ5Cuv0FckuL2HXCesc/9Y9SPgN
         AVpjTi4GpABePNcOkeEGsLc6ZYl/4ct7DvPJNnqSibnsYpVeYex9F0GBWuLHAKWWIzJM
         NMlQ==
X-Gm-Message-State: AGi0PuYMroIOafSbQbLGoAOZoKCEG5Rc8cXj1MI/sOlQu320bIKwZwDv
        +/zL2z3KGBw3IVnTF/Q7COn8eyGJsZ1O/h4RtN4=
X-Google-Smtp-Source: APiQypItjtAGonjwJzliqFhiqvF5OlQYJUW8/wCQGbhSqrrvvoYtmiQU/zK4p0Aq73lcEaVkH+IlqMTP8wtjcI7iEqM=
X-Received: by 2002:a05:6638:103b:: with SMTP id n27mr1859885jan.40.1588962303039;
 Fri, 08 May 2020 11:25:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200507053915.1542140-1-yhs@fb.com> <20200507053918.1542509-1-yhs@fb.com>
In-Reply-To: <20200507053918.1542509-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 11:24:52 -0700
Message-ID: <CAEf4BzaV6u1eTta4h4+mftQCQVOGPf0Q++B8tZxho+Uq3M1=mA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 03/21] bpf: support bpf tracing/iter programs
 for BPF_LINK_CREATE
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 10:41 PM Yonghong Song <yhs@fb.com> wrote:
>
> Given a bpf program, the step to create an anonymous bpf iterator is:
>   - create a bpf_iter_link, which combines bpf program and the target.
>     In the future, there could be more information recorded in the link.
>     A link_fd will be returned to the user space.
>   - create an anonymous bpf iterator with the given link_fd.
>
> The bpf_iter_link can be pinned to bpffs mount file system to
> create a file based bpf iterator as well.
>
> The benefit to use of bpf_iter_link:
>   - using bpf link simplifies design and implementation as bpf link
>     is used for other tracing bpf programs.
>   - for file based bpf iterator, bpf_iter_link provides a standard
>     way to replace underlying bpf programs.
>   - for both anonymous and free based iterators, bpf link query
>     capability can be leveraged.
>
> The patch added support of tracing/iter programs for BPF_LINK_CREATE.
> A new link type BPF_LINK_TYPE_ITER is added to facilitate link
> querying. Currently, only prog_id is needed, so there is no
> additional in-kernel show_fdinfo() and fill_link_info() hook
> is needed for BPF_LINK_TYPE_ITER link.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

still looks good, but I realized show_fdinfo and fill_link_info is
missing, see request for a follow-up below :)


>  include/linux/bpf.h            |  1 +
>  include/linux/bpf_types.h      |  1 +
>  include/uapi/linux/bpf.h       |  1 +
>  kernel/bpf/bpf_iter.c          | 62 ++++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c           | 14 ++++++++
>  tools/include/uapi/linux/bpf.h |  1 +
>  6 files changed, 80 insertions(+)
>

[...]

> +static const struct bpf_link_ops bpf_iter_link_lops = {
> +       .release = bpf_iter_link_release,
> +       .dealloc = bpf_iter_link_dealloc,
> +};

Link infra supports .show_fdinfo and .fill_link_info methods, there is
no need to block on this, but it would be great to implement them from
BPF_LINK_TYPE_ITER as well in the same release as a follow-up. Thanks!


[...]
