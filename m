Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7F623F383
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 22:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgHGUFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 16:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHGUFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 16:05:32 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88298C061756;
        Fri,  7 Aug 2020 13:05:32 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id p191so1629689ybg.0;
        Fri, 07 Aug 2020 13:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q4noCA9RAAsMH4q5HZV1We0qpM7uKQjjCZuvnQKwVDo=;
        b=T3i8jdWip67Yqbp8tLov+9gK+TYCzCAZYJR4n0d8dEF6TzumKfYnaEp58l5HxDIZdo
         chhT++vj0wsmGcyY3ilaCc+SoL+aSB5wlRCPK7XQKQzzTOSz6sOrpAd/uDMwDatwcdGN
         kX4SBqGY6uixgAg9Litz802IcAC6hKNabCSiAtAv545IWmmZU3jJivFd3DmPXdRAqFpk
         eTCEfsqBZDCfX0ugH2dTh1h4ZSgTaK13lJjcjUdaXFO7rfv762If/8MzeJd/6AmLGkX+
         u4nBHhU2vFjlSfz03At/6pHatmxZJ1OySXkr68ILE202aRRY5CB2vbbRTFM3GdUi+4KT
         8B9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q4noCA9RAAsMH4q5HZV1We0qpM7uKQjjCZuvnQKwVDo=;
        b=BwcE0oT6tM1CYDAXgmQC0fE7RnkWhYJlZaZ+Deam3SJ4BpkWGlaUgO1IXfmyZM+oHv
         vdJeu4QtPJAzNbuTjsgNNWoIbAa0MDPrJ7g/u6c/rl/I/GgIZzJJTsaVLgJIE9qTQrgj
         CvQ16aJ79PAl3hA0hGaeoII08rI7W5cH+5jHksSYBJEAQP9grozAUNUKvVGf88G5lZPX
         oHXXoGhS3Dpvn+GKAi6juRab4nbXcn5mzcb8xZQAVwZKhRnsAN+zZjVoEvZEu/RTn2n3
         9jSAOKL7tD9TvYQLe7RCYsYS9afgVr4SpXuwwthfjZpT8chjL13n2tQl9nJbqvl4Ct0k
         exdQ==
X-Gm-Message-State: AOAM530YOPv4DVxSAvpCUoY75bTPs45WaAPSgNmm+ijLIM0twm0UUC1x
        WFkIS88Txlt+t4DMOZd84BsKOPK472hYlkE7tmU=
X-Google-Smtp-Source: ABdhPJxGNyH9JWuKppzTxjpUThFMGESg6zod/zlyrlIfJg/bvLQUFVG31Czx20hRqcIg4LbCdOONrbh9tWbs/QycZIY=
X-Received: by 2002:a5b:44d:: with SMTP id s13mr22998924ybp.403.1596830731869;
 Fri, 07 Aug 2020 13:05:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200807094559.571260-1-jolsa@kernel.org> <20200807094559.571260-11-jolsa@kernel.org>
In-Reply-To: <20200807094559.571260-11-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 7 Aug 2020 13:05:21 -0700
Message-ID: <CAEf4BzaQOPYO3JYyJ3HKGWHdpKC7N-oKMPmOxnke8nXbZ2va9Q@mail.gmail.com>
Subject: Re: [PATCH v10 bpf-next 10/14] bpf: Add d_path helper
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

On Fri, Aug 7, 2020 at 2:48 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding d_path helper function that returns full path for
> given 'struct path' object, which needs to be the kernel
> BTF 'path' object. The path is returned in buffer provided
> 'buf' of size 'sz' and is zero terminated.
>
>   bpf_d_path(&file->f_path, buf, size);
>
> The helper calls directly d_path function, so there's only
> limited set of function it can be called from. Adding just
> very modest set for the start.
>
> Updating also bpf.h tools uapi header and adding 'path' to
> bpf_helpers_doc.py script.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/uapi/linux/bpf.h       | 13 +++++++++
>  kernel/trace/bpf_trace.c       | 48 ++++++++++++++++++++++++++++++++++
>  scripts/bpf_helpers_doc.py     |  2 ++
>  tools/include/uapi/linux/bpf.h | 13 +++++++++
>  4 files changed, 76 insertions(+)
>

[...]
