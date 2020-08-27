Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D897C253CEE
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 06:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgH0EvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 00:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgH0Eu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 00:50:59 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1483C0612AC;
        Wed, 26 Aug 2020 21:50:58 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id p191so2262775ybg.0;
        Wed, 26 Aug 2020 21:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XZYR7VNw5NZ2Jso3mPlMp39U2lgdgcQkzuZjsh+Wx0s=;
        b=pHUt3AAkY0mIHAET71C4ze52gzab5HXSIemi92bNPACl+RQJziqidxiUr1ptgRtzkN
         OO8Cy6i8NWrdIv9301wuoSHseBPVw1HjuppImSP5msWs+KfRCUcSD64xaen9tvajgn9o
         GGbAG+PuU5xUr4H7BXKLJ4zvQL6qjBX63cuy2uw/QCAeli7U8s9Lp+O60FwJAx5w6x9E
         8otqqXzWw/nUSY2b4R+RzqLPkUrAJqP085xcWqSEr+wBkc+xquxm0Jkt3qS2R8ug6Qx4
         lGgsfVbhdNKbxKizf/5zjY8zrSCUHNWGynkiMsBePL/hcbWh4LMROKS+lXNE1HtNfza3
         B/tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XZYR7VNw5NZ2Jso3mPlMp39U2lgdgcQkzuZjsh+Wx0s=;
        b=oOBphK/1edsgJSv3gzjke18E1y3aZNL2Lfrhu8avvS8XOfOatkf2BLXu2jxquZ9o+u
         PnxxvzjjF8qnLyGqsRQFoCgJnoMKExEzo7gBVYQlZ1bTkA3UX5Zlw/9dB3CjpYwh/pkl
         +14n4ZCkbDwCVGZLxV/vVxlx++Wf/T3Su4X5ljeNSTHwYDnIPMl8xR42zDKLHvB1dfH6
         X36r+fPTeQjp7pXZEBXEHLRm2uOZhimF/9MhP5VyrjTy0RQKuEUUMHzRfqKsrgVf8cZX
         SX1on6xYTOx0O2TZgLlNFNiSX2tASVqP5WVo3m/VEbHeuHp7NmCnzO0+4cwM66Hf5MJ1
         N2Qw==
X-Gm-Message-State: AOAM532BXQH4GA/LtE1QvG/XM3UTnVWKOCkW3XCWWDt9+MCbhCoiSt4o
        jI6z4uXR7su4rNk1ug+iEbrAQKrC+C8lhVPNoRn0CJTx
X-Google-Smtp-Source: ABdhPJzuSO+K4V+PMBFld61Dn+aVaPXsLSmlbpxfVY3OMltgSrbeN//ZQo6K/hZ+TZDeY0NO8iHUn5Tc/8V+bRkGu2Y=
X-Received: by 2002:a25:ae43:: with SMTP id g3mr26766908ybe.459.1598503857838;
 Wed, 26 Aug 2020 21:50:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200827000618.2711826-1-yhs@fb.com> <20200827000619.2711883-1-yhs@fb.com>
In-Reply-To: <20200827000619.2711883-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 26 Aug 2020 21:50:47 -0700
Message-ID: <CAEf4BzZg3D=7rkWjer49GH0_MZEf0KJH3O3tMs1gkzqMOb7t6g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] bpf: make bpf_link_info.iter similar to bpf_iter_link_info
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

On Wed, Aug 26, 2020 at 5:07 PM Yonghong Song <yhs@fb.com> wrote:
>
> bpf_link_info.iter is used by link_query to return
> bpf_iter_link_info to user space. Fields may be different
> ,e.g., map_fd vs. map_id, so we cannot reuse
> the exact structure. But make them similar, e.g.,
>   struct bpf_link_info {
>      /* common fields */
>      union {
>         struct { ... } raw_tracepoint;
>         struct { ... } tracing;
>         ...
>         struct {
>             /* common fields for iter */
>             union {
>                 struct {
>                     __u32 map_id;
>                 } map;
>                 /* other structs for other targets */
>             };
>         };
>     };
>  };
> so the structure is extensible the same way as
> bpf_iter_link_info.
>
> Fixes: 6b0a249a301e ("bpf: Implement link_query for bpf iterators")
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

I like this change, thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/uapi/linux/bpf.h       | 6 ++++--
>  tools/include/uapi/linux/bpf.h | 6 ++++--
>  2 files changed, 8 insertions(+), 4 deletions(-)
>

[...]
