Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF25D2490DB
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgHRWa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgHRWaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 18:30:55 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18581C061389;
        Tue, 18 Aug 2020 15:30:55 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id y134so12262603yby.2;
        Tue, 18 Aug 2020 15:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kgq0C/mi1rtAMa9RUqxX/cugrvXT5Ypi1bh6/GsBDEI=;
        b=rupcgVE1UTwn+V7Ra9W/hJEYiTdxNw+wRJfFdYkk/IgNm77mHYfyaeTRiMsS6+u9U0
         qZQiRtyGMQWfrQVKWvz3YYzOD1GWieyjpm+6qXFaXHNW8WaYfjSDbRX6SqPoF9uQxMWc
         mUREqJdFXfWrHceOC41gzTmvUl7bwVBaLPAwjooj1x0rse+YwgnbQM6BuJ3Z769Z1XxN
         H55EIA0khD1Pki0DGbz3vLfq5/f1ONu+TRU4Xx3iMjDwG5GnYxKnTlva5vlBqr7lH0P3
         wtlRt8b9Rp0vqceSt6JXftkcmHD16cKrCdNN34sushU+NgVXzHaCs6p9xt/u3GlDzo4e
         LJHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kgq0C/mi1rtAMa9RUqxX/cugrvXT5Ypi1bh6/GsBDEI=;
        b=dMwUamI3Kj6SUKXsYmZVx1/yG1E9qHXll3p+3qXpMWT8HykHshugNmHzwuVD+jGm6t
         +XCf9M9sPYkKG5xZMHgvhqvl0crByujfDBvTlu/e47os8RVTYsrKYoWdrSncu6rHEOnF
         WOOj9w6+CDWZYdWNVKusSyUc1DI7zXyoGK666e3JSJ5BOoIZRjjpnLF1bFnA8QsrdXy0
         8K9X7ohj+QMtPXyfUOuzHyUwfRiPeQN0pw4zM1GezecyPs3lIDyJY9Wnv0vunb5UvDKv
         ZekcK4IBlemJQmbjOiU2Dd7l1rGmXJJYoheVD0uFPna0e4NfyWQii959sH97pLb2Z4A+
         Xb2g==
X-Gm-Message-State: AOAM533aKm+r4lOiriiAghZGNDV3NEohi9t92nytF/waJFCgq88njuJ+
        rFjVGX2h0Xz660R5MnRyyBRua6Dw5TkDHRJ7C/k=
X-Google-Smtp-Source: ABdhPJwAA4ytZSTsC9R33pDS61Sb1bwliVBxTNYXIUpLcjm0cm/L27mECHa2wzud/WuugnZTfenlnDJaLwGRrCJPctw=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr29004753ybe.510.1597789854350;
 Tue, 18 Aug 2020 15:30:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200818222309.2181236-1-yhs@fb.com> <20200818222312.2181675-1-yhs@fb.com>
In-Reply-To: <20200818222312.2181675-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 18 Aug 2020 15:30:43 -0700
Message-ID: <CAEf4BzbaeMSq-L6yp3P7Me3fsGOvK5ma+xsdLEL3SM_YKQncpA@mail.gmail.com>
Subject: Re: [PATCH bpf v2 3/3] bpftool: handle EAGAIN error code properly in
 pids collection
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 3:24 PM Yonghong Song <yhs@fb.com> wrote:
>
> When the error code is EAGAIN, the kernel signals the user
> space should retry the read() operation for bpf iterators.
> Let us do it.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>
