Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7E83FBF7B
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 01:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239062AbhH3Xge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 19:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239019AbhH3Xgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 19:36:33 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B528CC06175F;
        Mon, 30 Aug 2021 16:35:39 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id e133so15889806ybh.0;
        Mon, 30 Aug 2021 16:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OKDoD/QJcgWewLIDPnJSVzAb1whguIQ8y+ADq+LbV5o=;
        b=PgdqsoEACZQ4zkZOcXcJGsv3AWG0I3NT0tpoohhjMydl9XgLTyebqr8jjb77VaYXMV
         n4AEwRHmPXokVY4SFqLi7cnI4sive6mDjULHdeA+gcg/AOXfEYIXm0HC+8R6hS+RcTrC
         P6d1HJl9SPAXnQAWU/uRLOFFqhLd6IG5F/QRSGjWXlG4SPEgOvfALJcZ74YU5rtaSwCp
         zevUnkrrKfBQZBxtSuQ4bE4IiMAgoIxP+uEvx8f4nFK0ppxA/hPh+hiMaenGmmRiFuoF
         yRYNarDUXEU81bLkdnzHyfJ0hX/osjLEUtsgjHFUhVb/IYEq3yYFQm2d7ca0+TXfNUIL
         akkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OKDoD/QJcgWewLIDPnJSVzAb1whguIQ8y+ADq+LbV5o=;
        b=T9fkU8FOIOKwUSiEEl/hyAk3Vy9wbV3bCq+8Zw+YFSQTt5MJtIjoH5mg7e1ejn7aNi
         tUI2CS5TQ1dQgzSSJYtIJvp/VuCzNaowQ715dsSUicT6QsobkC6XUMgTcJ5J4d0AcJWm
         KTHXPGLfKzoZhXn6d1TNWdPo6tu+9XJASwthtfKtvbO0JNe3md0n4CxB0JYOPESX+i+g
         qtAWLiiTdYUyKDCFCx7aDcznMOCsl38SW3ngU5FRGgm2X/Ilp/tjoGkCeUyYLaXBfcIa
         w8v0dGsi950KH3FjsxN+GBKLLx/Z8mAocRsM+UqJ6sc+IssTleOJXc5A8L7FEsNlO4Ff
         pzzw==
X-Gm-Message-State: AOAM533gyLzXEbZqUJpaQyBDdfUYgUhxphXkjcYg5MxvYvr2ESPAg+FS
        a5ZYCZz1ZmH4VdiscGXZk8FLODwNbt0iEHK+JmM=
X-Google-Smtp-Source: ABdhPJxiq31z+O5aWt+rIvznO+n+gRYLb6CXP0HIYIsJL3yU55+eK3EuFN1Bq/341z2fajs7i9wzTvhG2ZV2EdFhRpY=
X-Received: by 2002:a25:5e8a:: with SMTP id s132mr26833403ybb.510.1630366538960;
 Mon, 30 Aug 2021 16:35:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210828052006.1313788-1-davemarchevsky@fb.com> <20210828052006.1313788-3-davemarchevsky@fb.com>
In-Reply-To: <20210828052006.1313788-3-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Aug 2021 16:35:28 -0700
Message-ID: <CAEf4BzaGgyCpVLDc5g96+hze-HXfduERQMHDev0O0Ea6NdhGdQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/7] bpf: add bpf_trace_vprintk helper
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 10:20 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> This helper is meant to be "bpf_trace_printk, but with proper vararg
> support". Follow bpf_snprintf's example and take a u64 pseudo-vararg
> array. Write to /sys/kernel/debug/tracing/trace_pipe using the same
> mechanism as bpf_trace_printk.
>
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/bpf.h       |  9 ++++++
>  kernel/bpf/core.c              |  5 ++++
>  kernel/bpf/helpers.c           |  2 ++
>  kernel/trace/bpf_trace.c       | 52 +++++++++++++++++++++++++++++++++-
>  tools/include/uapi/linux/bpf.h |  9 ++++++
>  6 files changed, 77 insertions(+), 1 deletion(-)
>

[...]
