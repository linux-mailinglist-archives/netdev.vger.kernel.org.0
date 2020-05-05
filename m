Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BE61C631A
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 23:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbgEEVbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 17:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729294AbgEEVbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 17:31:03 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC9CC061A0F;
        Tue,  5 May 2020 14:31:03 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id o10so3378404qtr.6;
        Tue, 05 May 2020 14:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YooUIlaxiccVXKiDrx8umDqkzGjh29q5oZQ4NLVRE8A=;
        b=hWlcfyrxoR1rUGN/pwLfGUU27O6i8gvNiVpPqram6WRxm4l/XpjzN2tGtbEDfGrT1y
         ju9gXgccs69ZFvaQJZ8nwTLXEOUDwozTDoX3h9SOyf/20V9L+6n3YbuAzLmT99KVNfZE
         d2yPp/MohO8cKontoc0+375JsskrYchAVVlh4EmJBq0714MIaktpkkhj5lQbRWTCw4I9
         V55nKUZYH/oVfuk/DeEZAJcLGhxMQJNM1Zicpon21un3W2xRDnnEHDGGvga48zkZo/b/
         dNlZGuTha6MdlP8iC7UqvhFkDakc4o38hiiUFxu4GdXi0RnLgHuGkD2bYswv5zvr7Wl5
         5nEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YooUIlaxiccVXKiDrx8umDqkzGjh29q5oZQ4NLVRE8A=;
        b=i3TVhLURnMlcNiz8CRwIFp7Z5LWnYA95akt4Kz8Q/Vdi8ylNLxmDdFKKrdVmP5fH6V
         ehtTMq806pn8hM4vnWadEkkvc6aAho8Tm0OwafsxKwAr/VkShIsvIe00MK7FcowrMOZL
         wWWAoK5VF5ZeXx/IyfY6fNFm7VtkwHOU2KMR1K6A2kMj5Vpo02gbgfARntq/6sbjcdGa
         y/v/k/E63NdUiT8F4iCA0J61mraS7xRLJdR3ZyRZFwD/Sk9P0iE0Jw6Ml4F0TQVRuFNB
         FbGE/Y7cgPL5e+nzLWYOx/bEEr7jsjVpTCLzMWE0qgVYeFVosgGAzBEFxVaDZnL0TJ/A
         eunQ==
X-Gm-Message-State: AGi0PuZtuDiWPxMKC0SCYPUGQ0IxLXAQ49m8KxYS39KeGjkhtO4h8YDz
        5FEUkmx7KmSBxrApGiOruV2XszJ8ez93hD/0yoA=
X-Google-Smtp-Source: APiQypJ3xdop6PBqewfwEoDyzAwXzgE8QdicCqgCGiNcd8z2dTP4AgCTZ+vuPd8FIFYMYNBii6m6LhxqDr9aasNngKg=
X-Received: by 2002:ac8:468d:: with SMTP id g13mr4755736qto.59.1588714262664;
 Tue, 05 May 2020 14:31:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062549.2047531-1-yhs@fb.com>
In-Reply-To: <20200504062549.2047531-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 14:30:51 -0700
Message-ID: <CAEf4BzYxTwmxEVk6DG9GzkqHDF--VqvZWik0YJigzdrn3whcXA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 03/20] bpf: support bpf tracing/iter programs
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

On Sun, May 3, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
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
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

LGTM. See small nit about __GFP_NOWARN.

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  include/linux/bpf.h            |  1 +
>  include/linux/bpf_types.h      |  1 +
>  include/uapi/linux/bpf.h       |  1 +
>  kernel/bpf/bpf_iter.c          | 62 ++++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c           | 14 ++++++++
>  tools/include/uapi/linux/bpf.h |  1 +
>  6 files changed, 80 insertions(+)
>

[...]

> +int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> +{
> +       struct bpf_link_primer link_primer;
> +       struct bpf_iter_target_info *tinfo;
> +       struct bpf_iter_link *link;
> +       bool existed = false;
> +       u32 prog_btf_id;
> +       int err;
> +
> +       if (attr->link_create.target_fd || attr->link_create.flags)
> +               return -EINVAL;
> +
> +       prog_btf_id = prog->aux->attach_btf_id;
> +       mutex_lock(&targets_mutex);
> +       list_for_each_entry(tinfo, &targets, list) {
> +               if (tinfo->btf_id == prog_btf_id) {
> +                       existed = true;
> +                       break;
> +               }
> +       }
> +       mutex_unlock(&targets_mutex);
> +       if (!existed)
> +               return -ENOENT;
> +
> +       link = kzalloc(sizeof(*link), GFP_USER | __GFP_NOWARN);

nit: all existing link implementation don't specify __GFP_NOWARN,
wonder if bpf_iter_link should be special?

> +       if (!link)
> +               return -ENOMEM;
> +
> +       bpf_link_init(&link->link, BPF_LINK_TYPE_ITER, &bpf_iter_link_lops, prog);
> +       link->tinfo = tinfo;
> +
> +       err  = bpf_link_prime(&link->link, &link_primer);
> +       if (err) {
> +               kfree(link);
> +               return err;
> +       }
> +
> +       return bpf_link_settle(&link_primer);
> +}

[...]
