Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFF023E52A
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 02:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgHGAcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 20:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgHGAcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 20:32:05 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23706C061575
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 17:32:04 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id y3so98674wrl.4
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 17:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hToE6KcyuWM+662KE+/RTcRe3ZU1Jp6Exk5eY0or3rg=;
        b=HARCf8EgY43LFRhwHsR6GPpScvmW2JkPlYWIfBcqGF68//9+T5o/bTBvumodSOpCdn
         RWR3x44Ta5GJ4zDhdOHT6jp1RwUGfox8aXa9vz10xAVvsvQVhX6Akbd0wGpwMDWlIzPF
         FhQy2iANTN63MRK97dlj1LLo/a1LlDX3cH48E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hToE6KcyuWM+662KE+/RTcRe3ZU1Jp6Exk5eY0or3rg=;
        b=UrX93eTytWDdDKsrEXTOzyz1XMOLbTHJeSjrCl5T86hnNVWUBTlxDLoX3K6QlgdwCq
         YxPpm+BNxGgOHV0hFUSs26SpkN3ZvgGEon4oalNMOnGQHkaJi1vtkn7ZRzafT+h1s/gW
         yiwStswMe985od2WcPwsd8zlB6neLamS8KkjNRETxVb0ube0PeDIJNBBPyC9/xanh7Hq
         RFm6vdUHBB+lOWLWAkJzEuQrfu+JJ616bqVPE8RwZ52PrdJyVixtJzrCc3I9Ep3CuVB/
         XXrQe/w1oR3ug742Kx6beUkLdZYgOilzmu/EBzgGMJFjCiF9L58gLNlDLMJpA/LwlE2A
         1cqw==
X-Gm-Message-State: AOAM5316xeBBkv/XAnGuuqf9Tn+PBo4/NEvuDymT1yBrTaCXM2TM9Ih6
        anbhfzG5vE074ow8ACpwHPJu9G1BVluhw9KFaGRD/Q==
X-Google-Smtp-Source: ABdhPJxWiAL4g/PAklK/iNNIXWYNdvyyy5CxQbu9ymTtRdus9OhEcqe3D3c1iWwX5gfRRAVLwyJAVZzrQm4X20zKwKM=
X-Received: by 2002:adf:fdce:: with SMTP id i14mr9414192wrs.273.1596760323139;
 Thu, 06 Aug 2020 17:32:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200801170322.75218-1-jolsa@kernel.org> <20200801170322.75218-11-jolsa@kernel.org>
In-Reply-To: <20200801170322.75218-11-jolsa@kernel.org>
From:   KP Singh <kpsingh@chromium.org>
Date:   Fri, 7 Aug 2020 02:31:52 +0200
Message-ID: <CACYkzJ57H391Xe20iGyHPkLWDumAcMuRu_oqV0ZzBPUOZBqNvA@mail.gmail.com>
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
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 1, 2020 at 7:04 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding d_path helper function that returns full path for

[...]

> +}
> +
> +BTF_SET_START(btf_allowlist_d_path)
> +BTF_ID(func, vfs_truncate)
> +BTF_ID(func, vfs_fallocate)
> +BTF_ID(func, dentry_open)
> +BTF_ID(func, vfs_getattr)
> +BTF_ID(func, filp_close)
> +BTF_SET_END(btf_allowlist_d_path)
> +

> +static bool bpf_d_path_allowed(const struct bpf_prog *prog)
> +{
> +       return btf_id_set_contains(&btf_allowlist_d_path, prog->aux->attach_btf_id);
> +}

Can we allow it for LSM programs too?

- KP

> +
> +BTF_ID_LIST(bpf_d_path_btf_ids)
> +BTF_ID(struct, path)
> +

[...]

>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> --
> 2.25.4
>
