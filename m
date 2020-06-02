Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC351EBFD2
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 18:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgFBQSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 12:18:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgFBQS3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 12:18:29 -0400
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1A1E20772;
        Tue,  2 Jun 2020 16:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591114709;
        bh=ArZ6umqiHSZfYPmHnJiMNZHFgrWta8wpfvveeNknTmQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bhgt+NOMmVl1Fxs6Jvvmwzj8fcvNejvcPJzWiQH/JJhhUk9mY1fdKlaPQS/ifXgvr
         CuiDGYQ8r5IykX8DTdBuL0DCNUmYY47BSuBgECS+Glr/lG45UuB5H6BU6JrxBDkka0
         KvY3TIJN/8D70ZPyvrFOUwUWSRhEUdfNFl+jUou8=
Received: by mail-lj1-f178.google.com with SMTP id u10so12086291ljj.9;
        Tue, 02 Jun 2020 09:18:28 -0700 (PDT)
X-Gm-Message-State: AOAM532sWIc70tw2/Vyzjn1+X7jN19/H7SQ257+gI+09SPa/hGhZdcWg
        cL/2+NkciUESF6GjIPbYtu1/p8n4p/NlUCCjgzY=
X-Google-Smtp-Source: ABdhPJzl+VhF4CC9ZMYjRDxd6lcRMoyH/FHhp4+Ze4y2bqt6VOrwRdH00raBrXJmVUHoSofuvnqlnQDbKwTEuDfIftQ=
X-Received: by 2002:a05:651c:1130:: with SMTP id e16mr13734243ljo.10.1591114707316;
 Tue, 02 Jun 2020 09:18:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200602050349.215037-1-andriin@fb.com>
In-Reply-To: <20200602050349.215037-1-andriin@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 2 Jun 2020 09:18:16 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5OH9paDZpG-KfYK3EkwpaQWPOcD6c0kyLQ7+ePs9Xd8g@mail.gmail.com>
Message-ID: <CAPhsuW5OH9paDZpG-KfYK3EkwpaQWPOcD6c0kyLQ7+ePs9Xd8g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix sample_cnt shared between two threads
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 10:04 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Make sample_cnt volatile to fix possible selftests failure due to compiler
> optimization preventing latest sample_cnt value to be visible to main thread.
> sample_cnt is incremented in background thread, which is then joined into main
> thread. So in terms of visibility sample_cnt update is ok. But because it's
> not volatile, compiler might make optimizations that would prevent main thread
> to see latest updated value. Fix this by marking global variable volatile.
>
> Fixes: cb1c9ddd5525 ("selftests/bpf: Add BPF ringbuf selftests")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
