Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB621E37B4
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 07:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgE0FJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 01:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgE0FJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 01:09:24 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C961CC061A0F;
        Tue, 26 May 2020 22:09:22 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id n11so17766473qkn.8;
        Tue, 26 May 2020 22:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iTJZDY5H/dFxsdNEjr0CYs0oWVGjpyqAezVJ96AZYfc=;
        b=CV2ucSIXe0MdSExnbrnR5g8LCcsNtUBsRqlV7OJ81wsKo/I80iYTbnje8gCPtLzotg
         O/YpGSdI8XfPKAPb/VIKE7fe8oTuueeMQ7uKoV92WBfrYFyWnPMG4zmoqCexfLkeJRAd
         tUxqBCvupS1Oibc9N4FogsLIC8iHxjVSDb6m2q+k19yvZXY5AStxX63XSFxZB0Rparq9
         yBERo1OiS8WKvUEvXOrpVPrn7zJ9Qn64oDkfiPEpTeGPJniEF79Gyk/QiV8wnd61UihC
         mP9T8z8kzMwvuo9IMPUu2wIe9knSTIMZ60oKMD5iWKGZgbYYZ82o/5CasO2jj8s4L2MK
         dzMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iTJZDY5H/dFxsdNEjr0CYs0oWVGjpyqAezVJ96AZYfc=;
        b=sgXgyTXrGUAQD+v5hTjVxnxMI4zxFL1lGsKuv+0d4ZaUl93gKB7PWQs5enyxLcmO5D
         n/FSK13VpgC9Op8tym8d3BI+1JWLjyT9bzo+ZoyxCh5Y5/b+dIcxonfToRcWqD1DBMAW
         2/v02FPyQfbhFumPVBlURIPExNnRaibnhq2eGfcNMCoQZJeRiVvMpnmKZwrlTP0Qu7Rh
         pn1IDxc5/S/xeft0oMD4bGXCIavGfMLx7zbYP8qIhSm/oUoWRB0ZEZSGcMQc9y8Q5h78
         J7PNreaIKVY8WGHsqhXz1sV1UNbPYRIpL3E5y9YF+Ep2csvBzTii0z9bbgeis9mB6Wt7
         lIBA==
X-Gm-Message-State: AOAM532coFs+vFKmG3ZPr9ylee3ApV7nDEQQXSYDF9RxUrYHFc8kowsW
        wsuzxnhZXJocMbs1Pgs+WYE9sd3MWVEmahUIX/B6j0ovQKo=
X-Google-Smtp-Source: ABdhPJz2hDPmT8O5VsGbH8yEh55w28aOevI54yyqsu2GyAFXInQi43st7eNYjtxellJx6xBU+/QQkEMLYA8BcdzN+ys=
X-Received: by 2002:a37:a89:: with SMTP id 131mr2339534qkk.92.1590556162058;
 Tue, 26 May 2020 22:09:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200527015704.2294223-1-dxu@dxuuu.xyz>
In-Reply-To: <20200527015704.2294223-1-dxu@dxuuu.xyz>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 26 May 2020 22:09:11 -0700
Message-ID: <CAEf4BzbR+7X-boCBC-f60jugp8xWKVTeFTyUmrcv8Qy4iKsvjg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Export bpf_object__load_vmlinux_btf
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 7:09 PM Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> Right now the libbpf model encourages loading the entire object at once.
> In this model, libbpf handles loading BTF from vmlinux for us. However,
> it can be useful to selectively load certain maps and programs inside an
> object without loading everything else.

There is no way to selectively load or not load a map. All maps are
created, unless they are reusing map FD or pinned instances. See
below, I'd like to understand the use case better.

>
> In the latter model, there was perviously no way to load BTF on-demand.
> This commit exports the bpf_object__load_vmlinux_btf such that we are
> able to load BTF on demand.
>

Let's start with the real problem, not a solution. Do you have
specific use case where you need bpf_object__load_vmlinux_btf()? It
might not do anything if none of BPF programs in the object requires
BTF, because it's very much tightly coupled with loading bpf_object as
a whole model. I'd like to understand what you are after with this,
before exposing internal implementation details as an API.

> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> ---
>  tools/lib/bpf/libbpf.c   | 2 +-
>  tools/lib/bpf/libbpf.h   | 1 +
>  tools/lib/bpf/libbpf.map | 1 +
>  3 files changed, 3 insertions(+), 1 deletion(-)
>

[...]
