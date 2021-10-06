Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A744234DF
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 02:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbhJFATi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 20:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbhJFATh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 20:19:37 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22AD1C061749;
        Tue,  5 Oct 2021 17:17:46 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id oa6-20020a17090b1bc600b0019ffc4b9c51so3174856pjb.2;
        Tue, 05 Oct 2021 17:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dd25iWbMIpu6ehv9NxwDDQMShXAH+pXVH28BvCxz830=;
        b=iJ94omesvlI98Cx+V9cLIYaTPryOoi007XzCfjFa5qKXd2ewcQEi6FTEYjxviUeyaW
         djr1jV827peMhn1caA7HfnUnFvfdLz5ag5biEiEc098sEVSfmUEubMw0VWGxe7muAlhg
         qIuiO1FKgBzWEjyHH3QN9DwVynm5+SFSSB1z8NR6SpGJo6I7eL+lIXvBJkTnjPudKbQz
         eFXOciDdEzJ2wHQC/+VudyI+h0pze8wY7p4ru8J6O5fkq+ti5URtU1/KdIw4pzBw75XW
         H94efJzVQcFyc2wYCdDXxVSPa3rlZ/cb0HhsdF6j+kYNjHzjf+cmqo2bJle2pISBjf0c
         rccA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dd25iWbMIpu6ehv9NxwDDQMShXAH+pXVH28BvCxz830=;
        b=xyhFWuWRRNRNxTCD6NmIw6HPF0BZ5SGESMVhmIo+AmefAOyJZDSMR5z6J7a8TIZYKj
         JL5Mr3EiYCKhK0n7arUFYqFR25sQ2uXGQX3tvs3IKJl+JUi4ZoUUzDKpel0b/9Ea4Yo2
         6efSCk2em2Cv+NPcBrNOQLESyZAyyT87I3AVifamoXin8lOoN56dcBt+U1mmKMbZMnYd
         JbtbK1Bw9nlIPvf/hZ/DeJw2HUTZXudxP36lbKkwU4kYdYQTxAXAQ1NwDapYthJbKYue
         RInNb12PP+VW7p/CeYQ28ibza0QbOZW0OQabSZ3vThFKrmHKGOHSqMtSc5slLu3spP4o
         +EsA==
X-Gm-Message-State: AOAM532uQKNna1JvzA9cBH/T4Pn0mhMFsARQdKnQ+ZcsHrPOYw8RTp/l
        533XvKVjb0M+gKfbQonvRc9v2pqwe4QRQpfI0C8=
X-Google-Smtp-Source: ABdhPJyNPqE9x4WGWcGy4JdVi8xrMD7qtrBsZkb8MYIVzrVqsaxBFjnCGuemSltpGIbijAN+9w4ZKThBkvt2WbwLi54=
X-Received: by 2002:a17:902:b7c9:b0:13e:e094:e24c with SMTP id
 v9-20020a170902b7c900b0013ee094e24cmr6839741plz.3.1633479465540; Tue, 05 Oct
 2021 17:17:45 -0700 (PDT)
MIME-Version: 1.0
References: <20211002011757.311265-1-memxor@gmail.com>
In-Reply-To: <20211002011757.311265-1-memxor@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 5 Oct 2021 17:17:34 -0700
Message-ID: <CAADnVQKDPG+U-NwoAeNSU5Ef9ZYhhGcgL4wBkFoP-E9h8-XZhw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 0/9] Support kernel module function calls from eBPF
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 1, 2021 at 6:18 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> This set enables kernel module function calls, and also modifies verifier logic
> to permit invalid kernel function calls as long as they are pruned as part of
> dead code elimination. This is done to provide better runtime portability for
> BPF objects, which can conditionally disable parts of code that are pruned later
> by the verifier (e.g. const volatile vars, kconfig options). libbpf
> modifications are made along with kernel changes to support module function
> calls.
>
> It also converts TCP congestion control objects to use the module kfunc support
> instead of relying on IS_BUILTIN ifdef.
>
> Changelog:
> ----------
> v6 -> v7
> v6: https://lore.kernel.org/bpf/20210930062948.1843919-1-memxor@gmail.com
>
>  * Let __bpf_check_kfunc_call take kfunc_btf_id_list instead of generating
>    callbacks (Andrii)
>  * Rename it to bpf_check_mod_kfunc_call to reflect usage
>  * Remove OOM checks (Alexei)
>  * Remove resolve_btfids invocation for bpf_testmod (Andrii)
>  * Move fd_array_cnt initialization near fd_array alloc (Andrii)
>  * Rename helper to btf_find_by_name_kind and pass start_id (Andrii)
>  * memset when data is NULL in add_data (Alexei)
>  * Fix other nits

Looking good now. Applied. Thanks
