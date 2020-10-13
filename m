Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5518C28DD13
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 11:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731154AbgJNJWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 05:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731144AbgJNJVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 05:21:52 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61609C0613B4;
        Tue, 13 Oct 2020 14:59:12 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id h6so908522ybi.11;
        Tue, 13 Oct 2020 14:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VRRma4QG3RpD3m+KVfyIAn86lByO9d2UMJBpO63DxTI=;
        b=BNC+HtRVwGwOu7By4Lr9k59i/iQgasSemzSgLKfB6hjxMPjh7dKBEpTOmc7/pj6b3W
         6Nd2pEjhvSD9+MlelhDFBidieGLIKHp0fmaxSNDTYbHoP5gGFenNKiv15cLmaqIgdDA6
         gClTXfSozfyEop/pog/t9sYW9Cb4iIdzTqCRgw04AYodY2YO1WXgW/Rey4JjTP0l/7KR
         5lrWP4b3vZ89IrUBg4ey5bfMsvRop5d4xhYv7uYeGidoVXuxH8meNnCNLwphAQqpprds
         vT77jAmdtbR6sRaMSDeCBrTKi01R6TKavgxnQ9PHvnkcCHv6f2EQvf7XY2uwlLpa7HdQ
         jXbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VRRma4QG3RpD3m+KVfyIAn86lByO9d2UMJBpO63DxTI=;
        b=oPmwMWa8lnCeKiJIHziL3Zw3zmMI3ILJHoLB0H+y/loua5UogPTinchRqB9xq3nTim
         zhSS35OxMdlaVW1JqL62nTSHdlSusTqrUrfwKy/y6b2eyzf+eFb9xp0ypnfb8K2luKnf
         HyL/RxqZlzHEmXYPHFyAJQo4/r9asGAI/Z5X58q3CEdBtIJthe/yzH5spcpaZepu6J3n
         QSWiFRDQS3GkFs2QsrKPzVpikvteaBalzZWllsLoTDhKa414rVf28QPozVinyVkPZMdn
         gtO4a7XJwDOLVpt/aPUk3yAR+ZDz3e1jTIJKSBSLi611664XAUujEHHmMghLs1GethGN
         PkjQ==
X-Gm-Message-State: AOAM531WsfjLZPonyPA+V1dNXRF976jKehHFaTZ0jNBQoy1J9SjdBgpb
        M9LQeAhkeDUa60F5xhj6bRLl7QpaXXmU2kThKb2QIIvJtpg=
X-Google-Smtp-Source: ABdhPJw7+CRp3FkUL12dvYfJIGv04RKrS1K04TJYYe6IrveNHSanyH+O0iF4G9VNil7Nfq5BH2firwTmkFUz7se4xGI=
X-Received: by 2002:a25:2687:: with SMTP id m129mr2687368ybm.425.1602626351620;
 Tue, 13 Oct 2020 14:59:11 -0700 (PDT)
MIME-Version: 1.0
References: <20201012234940.1707941-1-kafai@fb.com>
In-Reply-To: <20201012234940.1707941-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 13 Oct 2020 14:59:00 -0700
Message-ID: <CAEf4BzbFoFryfELodTeQPQdC_hR5o9rxCXwNd4y4Tu-xZyV-9A@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: selftest: Fix flaky tcp_hdr_options test when
 adding addr to lo
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 4:13 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The tcp_hdr_options test adds a "::eB9F" addr to the lo dev.
> However, this non loopback address will have a race on ipv6 dad
> which may lead to EADDRNOTAVAIL error from time to time.
>
> Even nodad is used in the iproute2 command, there is still a race in
> when the route will be added.  This will then lead to ENETUNREACH from
> time to time.
>
> To avoid the above, this patch uses the default loopback address "::1"
> to do the test.
>
> Fixes: ad2f8eb0095e ("bpf: selftests: Tcp header options")
> Reported-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Less shelling out is always good :)

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  .../bpf/prog_tests/tcp_hdr_options.c          | 26 +------------------
>  .../bpf/progs/test_misc_tcp_hdr_options.c     |  2 +-
>  2 files changed, 2 insertions(+), 26 deletions(-)
>

[...]
