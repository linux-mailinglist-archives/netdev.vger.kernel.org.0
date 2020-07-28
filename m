Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FB72313F4
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgG1Uat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728430AbgG1Uas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 16:30:48 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485CBC061794;
        Tue, 28 Jul 2020 13:30:48 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b79so20035710qkg.9;
        Tue, 28 Jul 2020 13:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3gjVEnrQoMkwUcxkwM0L6P9FWfUnyl3GeWItEYMqGT4=;
        b=bRMzyaCgDABaDcL/KLuV3kDoU2VjZH3oLGTUOKcDMEGEWbwKz0ZFVVzkafh7CwdRDa
         ZBtgB+x32AcVQieNNBRZE95FK1MzYvTpZ3dc411HbzT9dHJu9r8/Ir5y/e0v1rU1Kwqs
         /perA7LrlecUQWQbfGblSt4wpxfDfvS6IIioFWNKbKztSnBdHig0hlLZVFZKGCp9eCEM
         NrBXzyaRUB6zlMj0PfrCTxNvMFvab81ZS0CRWioufGtUC3jIusd+1KBmmyGXRjJJgltU
         N5pnHxBhvd8+Nw23Li5sjiR1ZpIXYt2mGSE+UrzTwQQK9GYkt/lDeTsecTy9toHH6XX2
         +Ryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3gjVEnrQoMkwUcxkwM0L6P9FWfUnyl3GeWItEYMqGT4=;
        b=MN09dIP8EXcPPLFVvtli2Sa4mpY2Zyq++5J7QFwJxXZUisCyipgmlSPEWqE414Vc0U
         JOG6wqkxKFU+SshbrAzSojXXWLXZ5C+SviaKIHJbJVc4Rfar+4Qye8U7OlVHWm3th7cG
         9VAnDxEU8qm8Gno3hyt+aqD997hFM8L3Q/BE1u19klGiM4MqZDGnoeu4kEik1jJrnxSy
         zHm/OBeuxh2L9imDfuqGALDVxJu8D7DGrdUspeDO4bjuh9uJ7NfdP492MZ+FSAfUbCIC
         h9bhuBYKdfrorweVBwv8ctTNxa2VvsWN8LVKXMbRGbaC6z66wszOeUdr4rHnNgGGPOPP
         fn5A==
X-Gm-Message-State: AOAM530vdM7VNKNY/+ZXe/hyZvGzQYcvyLU+x33iKFtlFom19M+WYRyw
        S5V1wXMxxe30cKJu/Ddr6SDzKRXcyZRdUv/dqGI=
X-Google-Smtp-Source: ABdhPJyevqDjVMuOpOJL2MaYaMzcJ7F0T5b4YexCR6L/j+G5p0rrTJHoqMFLG4bvK7K/QMKsVF3RXM9T6Z+EWUTATJM=
X-Received: by 2002:a37:a655:: with SMTP id p82mr29380390qke.92.1595968247527;
 Tue, 28 Jul 2020 13:30:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200722211223.1055107-1-jolsa@kernel.org> <20200722211223.1055107-5-jolsa@kernel.org>
In-Reply-To: <20200722211223.1055107-5-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 13:30:36 -0700
Message-ID: <CAEf4Bzb6tmYSdhixa63A0XNw02YSUd3pAJF2=BxY9UPt9XuBfw@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 04/13] bpf: Add elem_id pointer as argument to __btf_resolve_size
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

On Wed, Jul 22, 2020 at 2:13 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> If the resolved type is array, make btf_resolve_size return also
> ID of the elem type. It will be needed in following changes.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

it starts to feel like __btf_resolve_size does a bit too much, but
it's pretty contained, so I suppose it's ok

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/btf.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>

[...]
