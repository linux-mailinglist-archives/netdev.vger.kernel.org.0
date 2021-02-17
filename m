Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7F531DFFA
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 21:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbhBQUJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 15:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbhBQUJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 15:09:12 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479C6C061574;
        Wed, 17 Feb 2021 12:08:32 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id s17so7018167ioj.4;
        Wed, 17 Feb 2021 12:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ExD1J0nbsdRlEWTWO+RaWV0fRE0IveEnnin5I0Nhyy4=;
        b=U8PMCy1WM5nLHZT/Js8eWRG88gTHAMuwTFX82alHXQS4HAEuWxnDYepah0gY6BiCP8
         7wpHnoFAkxKzYSZLvfhTPD+svi0jx474FhffIkT6LGJHxxX3pUpmEfKGx7cI9xxGMM31
         AJjGFXLWsKf+1o+EdHgfonmb8PCJuC53/TOdmeGhTmjhOBaQsqfWy3I6Vqeov4mJJKjx
         AZLs0ClIH+9pX9wn8Bf1wmHofjdHIP57N0WndzWEVsD7E0EjOfE2jhVtmRDoVUi+tFZM
         hjyJZ7X++iAPX1o9oArVijbeJYAqJR82QrrSAo3GMX9Z6xvZGf/S3cBE9eyEr2hqWokQ
         tyAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ExD1J0nbsdRlEWTWO+RaWV0fRE0IveEnnin5I0Nhyy4=;
        b=tQ3mmWxxfmJIoUN5nBVQ+L54eyHrsiwkfHpftpX6beZI538NdI6KFog/Cxf8OzFeli
         78MEszZhvukAc5f5Ov45GZ62t/4WmY/B6dCRWuPk+GjPGCFZONz1evsEkgQpauiKxIW0
         mc+vKFJvYpWt5KNqIYqBbk6qv8vpEbn0M6qVWE40FcL6EyVwTvpuZ3hAfeJ8njN73BYC
         9zeH2zJhVKYcaTCbBepQh1qApR7ILaoQkqTFOhuY9iHVUG+tJ7yIdNGVU73nnqBUXehf
         s9rAhG4V+O2XLBQ+Qt1G79w3MJclcUS0dtbWIVEC/EObQy2awYYlpmn7d2Hfu0ESDnju
         3FcA==
X-Gm-Message-State: AOAM5330MH6a7sStuAdHrlxUJpF6X34VNMS0aoY3K4Y5Duu/I4sbepgg
        2K46HzModeefjiocS3UA0maa6oB5Xec=
X-Google-Smtp-Source: ABdhPJztnOeyOFPU17l5SzJlomiDjb9dNL2x2ImHqhTAMF/+9g/+9UGWbVxO5q5jc828bav3yjdTdQ==
X-Received: by 2002:a05:6638:2407:: with SMTP id z7mr1131100jat.110.1613592511848;
        Wed, 17 Feb 2021 12:08:31 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id b9sm1763311ilo.41.2021.02.17.12.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 12:08:31 -0800 (PST)
Date:   Wed, 17 Feb 2021 12:08:25 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, jakub@cloudflare.com
Cc:     kernel-team@cloudflare.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <602d77b91e028_aed92087d@john-XPS-13-9370.notmuch>
In-Reply-To: <20210216105713.45052-1-lmb@cloudflare.com>
References: <20210216105713.45052-1-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next 0/8] PROG_TEST_RUN support for sk_lookup programs
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> We don't have PROG_TEST_RUN support for sk_lookup programs at the
> moment. So far this hasn't been a problem, since we can run our
> tests in a separate network namespace. For benchmarking it's nice
> to have PROG_TEST_RUN, so I've gone and implemented it.
> 
> Multiple sk_lookup programs can be attached at once to the same
> netns. This can't be expressed with the current PROG_TEST_RUN
> API, so I'm proposing to extend it with an array of prog_fd.
> 
> Patches 1-2 are clean ups. Patches 3-4 add the new UAPI and
> implement PROG_TEST_RUN for sk_lookup. Patch 5 adds a new
> function to libbpf to access multi prog tests. Patches 6-8 add
> tests.
> 
> Andrii, for patch 4 I decided on the following API:
> 
>     int bpf_prog_test_run_array(__u32 *prog_fds, __u32 prog_fds_cnt,
>                                 struct bpf_test_run_opts *opts)
> 
> To be consistent with the rest of libbpf it would be better
> to take int *prog_fds, but I think then the function would have to
> convert the array to account for platforms where
> 
>     sizeof(int) != sizeof(__u32)
> 
> Please let me know what your preference is.

Seems reasonable to me. For the series,

Acked-by: John Fastabend <john.fastabend@gmail.com>
