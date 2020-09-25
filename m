Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01CA278F83
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 19:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgIYRWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 13:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727201AbgIYRW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 13:22:29 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA34DC0613CE;
        Fri, 25 Sep 2020 10:22:29 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id b142so2506254ybg.9;
        Fri, 25 Sep 2020 10:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fkHwkwrR8LHf10ihDr8q7A+EtKI+7D0WDlCZIRPejls=;
        b=Q6POFWnQrM3pjGa5iuVtsCNUv05abHsCpJ1aQGjG8WV+49bhL5JDN+GBZyhQKofxM9
         IIoEQeXRbqohfuYKE/cB7bY+C3LDbJEOCDgHOTg2+qCkbdvIMEDMQ0337RvGIbLkWkxX
         ldjjOySTfH74fpJl1oMsg6KQB3WLKSLqD/b/uwikPlHf5wFDvkp7VbKN1sMK1cZLG2+V
         Ot2Y2VM9crBEU6OLgwr3Lhk/EMcb9Z1mVCUD0Sqn3PapOp0K9EOCyDW1SKNFK7PwLs1A
         TkxGHQwdE2uki0Y+/8Aj/evr1DG2x4fzuI/VKCJuTdjW0yKODpSOiqS16AljK8rzUYPJ
         X2IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fkHwkwrR8LHf10ihDr8q7A+EtKI+7D0WDlCZIRPejls=;
        b=A1v8BB4KCB16cxTCThjkMFm/yBaDGHMQRj36iet4QAU1XA6AA3eZF5/ipXg496/K4Y
         U0QguZsahp0sRihYR7eLBbPZo22lSQzhCgCZXiGwzIOCsCkKgdCc4WR6hgO3IhBC3dh4
         KDSGh+98SCOm1b6DgUHRnOthirgkO5wLl6apZ7POUr2D9z/ejuuyfXgDD/eTeJsoCneE
         lE9lBwUynDpQTeN4ebrs+K9PesC9XH5Aw617xoaYio9eFeubXdkwrk6mEEiwNT+jjx3P
         bgsLPKyD9YwHGQ+9JsgaARYhuqS1U+kCbk5OKAGBhGYlU9tzAh8/i2ZWUNr569nqKCUk
         dw+A==
X-Gm-Message-State: AOAM530oJdg+yTw2BiQprE+aE6/vVMrDiJwGiqIgEOoh2ZWYuRldME6h
        siMGpOvhunhi23lmfb/THmMEF+n+hdMO0AlYKS4=
X-Google-Smtp-Source: ABdhPJyZaZcVbkLDVxUF3/i6OiF8LVIlGcw8+B6lWF0M6+6B6avTAIsb0hIHHY2IwrYHhpmxAtQHq363V30tE6SY0aE=
X-Received: by 2002:a25:2687:: with SMTP id m129mr274999ybm.425.1601054549004;
 Fri, 25 Sep 2020 10:22:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200924230209.2561658-1-songliubraving@fb.com> <20200924230209.2561658-3-songliubraving@fb.com>
In-Reply-To: <20200924230209.2561658-3-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 25 Sep 2020 10:22:17 -0700
Message-ID: <CAEf4Bzar5REBEtGVYdGzy2sBmPd62gdJKx6CJoxfW46ROZP3Ow@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 2/3] libbpf: support test run of raw
 tracepoint programs
To:     Song Liu <songliubraving@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 4:03 PM Song Liu <songliubraving@fb.com> wrote:
>
> Add bpf_prog_test_run_opts() with support of new fields in bpf_attr.test,
> namely, flags and cpu. Also extend _opts operations to support outputs via
> opts.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---

Looks nice!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/bpf.c             | 31 +++++++++++++++++++++++++++++++
>  tools/lib/bpf/bpf.h             | 26 ++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.map        |  1 +
>  tools/lib/bpf/libbpf_internal.h |  5 +++++
>  4 files changed, 63 insertions(+)

[...]
