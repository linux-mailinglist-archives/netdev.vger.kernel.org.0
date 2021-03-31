Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A4834F95C
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 08:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbhCaG6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 02:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbhCaG62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 02:58:28 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B18C061574;
        Tue, 30 Mar 2021 23:58:27 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id j2so20089906ybj.8;
        Tue, 30 Mar 2021 23:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d0Y8mGGB6DjgCAiNywpkqHwFV0rhGv7lRh5z1AofPlM=;
        b=DZfh0/Vc6AvS2La89J/pGyAwN9RUfDiFcbBLsX+LwpzlSjryriFnOUnprkIlIoGnhb
         B8pWfg4TD6jkReyHOylJtlGuHChpqtlYxD4t4sUvd5o8CdTki/FYasBH77vUlW2XEe9N
         IX2V4vx8MykZTOub6BLyIp5ZRmtfxoQtX1Av1CmSegYTRDpP0do81E10QelywKH6jOMf
         ZBAB59PVjITCLy9XB4Y5DdgzPz6C0UHI1lfyFEWR0paR5M4DIJ/XbaDdK6/cmI9AfgO3
         zC2YwKcUL/vY0icGJa/fdj524hoiL2clq0TfuU5OdBT3oE1Lj7UCN/TQiqBy9RUSEDEH
         W5gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d0Y8mGGB6DjgCAiNywpkqHwFV0rhGv7lRh5z1AofPlM=;
        b=UxScSvt5uLJaCMPs9Or8DQdr+Ml6oROpI1fAKDDlxMAvYY91IuJfZRKBQS3SqjUV44
         I2dtMQyvcu5eC0+JJh/WixYA738IyqDHg3h7Ow9CDq1fIReRJr+kBpYea/ICFOB5Ns2z
         kc/sBDFi4FH/Kx+Pr7GGl8pfjUm8H0q+5301mwhm+HydJzPhbc7viMBQxAy40iYYJX5e
         5Yx8G3/o82dsrUHj8rlY1HbVfniah0+UjutsWzkMzog21eiYmgws2idXq8kKEEU6Xyfv
         ldm+sVCGIUAWQxpoBPevcr5uDJdC4o/+GegeTAoxkRjXsWtBVgych5VDv36hdEEf+m4Q
         u75A==
X-Gm-Message-State: AOAM530nIkTExNzzTsVQ22gFcs1wxfh5QWhNgnUeG9p2Zl1ZvHJnEjRl
        2D0nUZ4g+iHaEWDa/34IEhV73b/m0XNNYaE6lUM=
X-Google-Smtp-Source: ABdhPJzYeA5Fhdxsa9swwh7FR5tI7eMDAx+d8sb8A8qUVlYtVDdyVbvKw2rZ/Zv4ZY35tkq+EcRTUOlGm49kIPGYOeU=
X-Received: by 2002:a25:becd:: with SMTP id k13mr2603933ybm.459.1617173907341;
 Tue, 30 Mar 2021 23:58:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210328161055.257504-1-pctammela@mojatatu.com> <20210328161055.257504-2-pctammela@mojatatu.com>
In-Reply-To: <20210328161055.257504-2-pctammela@mojatatu.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Mar 2021 23:58:16 -0700
Message-ID: <CAEf4BzZ5hZ+ca-S3cBWmkEtsB4nvQhzR5EA5+Q6En0m+N8um4w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: check flags in 'bpf_ringbuf_discard()' and 'bpf_ringbuf_submit()'
To:     Pedro Tammela <pctammela@gmail.com>
Cc:     Pedro Tammela <pctammela@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 9:12 AM Pedro Tammela <pctammela@gmail.com> wrote:
>
> The current code only checks flags in 'bpf_ringbuf_output()'.
>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
>  include/uapi/linux/bpf.h       |  8 ++++----
>  kernel/bpf/ringbuf.c           | 13 +++++++++++--
>  tools/include/uapi/linux/bpf.h |  8 ++++----
>  3 files changed, 19 insertions(+), 10 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 100cb2e4c104..232b5e5dd045 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4073,7 +4073,7 @@ union bpf_attr {
>   *             Valid pointer with *size* bytes of memory available; NULL,
>   *             otherwise.
>   *
> - * void bpf_ringbuf_submit(void *data, u64 flags)
> + * int bpf_ringbuf_submit(void *data, u64 flags)
>   *     Description
>   *             Submit reserved ring buffer sample, pointed to by *data*.
>   *             If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
> @@ -4083,9 +4083,9 @@ union bpf_attr {
>   *             If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
>   *             of new data availability is sent unconditionally.
>   *     Return
> - *             Nothing. Always succeeds.

bpf_ringbuf_submit/bpf_ringbuf_commit has to alway succeed. That's an
explicit and strict rule, which BPF verifier relies on. We cannot bail
out due to unknown flags, because then ringbuf sample won't ever be
submitted and will block all the subsequent samples.

> + *             0 on success, or a negative error in case of failure.
>   *

[...]
