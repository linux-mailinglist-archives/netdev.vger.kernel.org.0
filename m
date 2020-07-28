Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FFA230226
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgG1F4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgG1F4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 01:56:33 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D093C061794;
        Mon, 27 Jul 2020 22:56:33 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id h7so17632213qkk.7;
        Mon, 27 Jul 2020 22:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I1D29EvPhH9GH6nvHnSp01YykbMFZQx9+YLWCGyLdqw=;
        b=L/biUkUnaM/TOxASLMEbQgs/ELj7a1YXI+5e94wJViaZY/0F173yiL15XqaQmGhW/D
         6KJKfDxe14HwLmHwXVGIlvfhUxSxOECBgX3J8mYi7hN/4b5k6Fl+IVN/Vh8ZOUrZbgrR
         tUxTdb9byycAhcl8HMrBmqScsI3yYEymTJVvwVZLYVVw1K4NOMV99uthoWdWJCQNrrYV
         56e/gEhboHqN9XU3P5qO0+VqqtdwWDmLUeVI0xu038Aqw3fXkVy5DRvfiF9Pl1m3H20n
         rSleFuaTAn6B/BxkJ9jp5CKRz7k1fDPrYtYEEjWwdBuTDkNngpvq0uRyV7r3+YgMjNaD
         FBDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I1D29EvPhH9GH6nvHnSp01YykbMFZQx9+YLWCGyLdqw=;
        b=cFSdtVXjjYCJnI8KFZn8b2y8NpKUyWUUzgWK/7FFcdZMLucAnFVB30NdgvSDVMwPgU
         NT6mFlNbB6i7Js3K6aSrNnq1qiQ58nkV416hFQ8hmoPnTCQ6VQmjPB4442io9E9OtsoM
         xnCqzl46tAugpl6xtj7VPj8V78XixbxfDLnoVrkizp7BcBdlc5qqCPdFdEpsh7AWXxw9
         xSyL21DbUZ52w/zkt28Zj/3pSyNrKY2d7KP28xzSS4jNF1eT8C73AbUFPATkoglvK4nb
         rUQ9GASMEqqdLdALLX8EA9MV68wHo+ROzuZKIL0B0k7uqQhqHTsqRyQd6VwXrVucWq6R
         c/+w==
X-Gm-Message-State: AOAM531P1WXq+ekIZARFPU5G1RcgUP/zeT1pBe5lutICSL/S7DXR/aez
        eq61m4tVHLoDd0Qfrz00gAghOjvDUnYebbRUTzw=
X-Google-Smtp-Source: ABdhPJyxJsAVfWZ7KT+s97ciuNAGC7ogtKQRI/2uSbtuntQjk7VHX9MPgyXI3o7pmyItzv+1bB4uFwl5r9bUy9CcKjo=
X-Received: by 2002:a37:afc3:: with SMTP id y186mr7209799qke.36.1595915792506;
 Mon, 27 Jul 2020 22:56:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-23-guro@fb.com>
In-Reply-To: <20200727184506.2279656-23-guro@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Jul 2020 22:56:21 -0700
Message-ID: <CAEf4Bzbi56xvvT9sEQbMYN6Pa-Gqk-FJTyw+LYZGbwUs-S98TA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 22/35] bpf: eliminate rlimit-based memory
 accounting for bpf ringbuffer
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:21 PM Roman Gushchin <guro@fb.com> wrote:
>
> Do not use rlimit-based memory accounting for bpf ringbuffer.
> It has been replaced with the memcg-based memory accounting.
>
> bpf_ringbuf_alloc() can't return anything except ERR_PTR(-ENOMEM)
> and a valid pointer, so to simplify the code make it return NULL
> in the first case. This allows to drop a couple of lines in
> ringbuf_map_alloc() and also makes it look similar to other memory
> allocating function like kmalloc().
>
> Signed-off-by: Roman Gushchin <guro@fb.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/ringbuf.c | 24 ++++--------------------
>  1 file changed, 4 insertions(+), 20 deletions(-)
>

[...]
