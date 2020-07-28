Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E269A2313DB
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgG1U2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbgG1U2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 16:28:01 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E171C061794;
        Tue, 28 Jul 2020 13:28:01 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id l6so20044017qkc.6;
        Tue, 28 Jul 2020 13:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0kiHcllcYBrWocTjnOskFUd212TEwgooiUYMMHKg7NA=;
        b=sAyBBxH4DALIwXLqpF4Pa85hrr+qKXP8NgGaomAI6teKskv8JikS27ZmjztVBCo48w
         4aQoEzVMk8moXJlbO+Vpr3rrgrK+Ysm/jA5JO8eBH3+L3hgn+yKycjnGR5+4OYdz8oJc
         4NGiLnsZAZ4NFKrJeAvkUGBjxaGQ2/YuTmWMxGB/dmXos0+FaB35jERo1XfjNxA7Pn0U
         TGStPNdu4WoRP9a4o/Nc52ZtaUhuPpDBOT+7A0fGyn/2plzvlOQUlaCuE0c+A/aqmqvA
         oZwGd+gAO72ZG6gxhGKYLg6ZrcfpEKdSvZLBrZtW/ZNLqyD6nTtIO/rz7LhvjESJuQ03
         7NTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0kiHcllcYBrWocTjnOskFUd212TEwgooiUYMMHKg7NA=;
        b=FVw29Dyi1jszYXvezgufv3cZMsT1q6SXrfItfBe1nwC5lA9h/Czb1ridtMlHkPvK/l
         TRBuaRWfkec0naeb7g5zOGXLS7e24UnnpYo/IlIPiTvueXw9+TVy1DCYSkiaQzGfZRhR
         khgHiR5YzC1vdwWc0UhuAuZSodZBfoD1KRrrnzulGAotZLUe4TFzSuKsQp20KvDwWqSI
         VqQ5MBa+GKl6VJFHy/Gu1XCh/BidO/aoso8u/0yuPhkWrmjMvK/bccK9Vi9wYQRQTEdE
         2QTKIXV0MLpaQibWRPSdxtIblSI3ZXTQWGJd61oQLkZBrkhftSM1c3SgzYNYCRqiSgey
         V/tA==
X-Gm-Message-State: AOAM530b1CY0I+Vz+vYyBrIxwvfoSszEWuSEYXorjivfwY0cRWaJfz4i
        Kcql2PViR6A8Aeabu8dXG0fqqZz8MMmU5HMPbwc=
X-Google-Smtp-Source: ABdhPJx3BPzOhKJR/u5zpVwbgG/d4Hw1aHrSC7L9yvPorSXLPHK9haR4micIoQVWc0dEfq5D5UJKLg3+Hb3SeOpgTnk=
X-Received: by 2002:a05:620a:4c:: with SMTP id t12mr4258493qkt.449.1595968080578;
 Tue, 28 Jul 2020 13:28:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200722211223.1055107-1-jolsa@kernel.org> <20200722211223.1055107-2-jolsa@kernel.org>
In-Reply-To: <20200722211223.1055107-2-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 13:27:49 -0700
Message-ID: <CAEf4Bzba08D8-zPBq3RpsG3fcRt8Q31VKd-_fV2LuJVwHGaY=w@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 01/13] selftests/bpf: Fix resolve_btfids test
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

On Wed, Jul 22, 2020 at 2:13 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The linux/btf_ids.h header is now using CONFIG_DEBUG_INFO_BTF
> config, so we need to have it defined when it's available.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

sure, why not

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/prog_tests/resolve_btfids.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> index 3b127cab4864..101785b49f7e 100644
> --- a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> +++ b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> @@ -1,5 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>
> +#include "autoconf.h"
>  #include <linux/err.h>
>  #include <string.h>
>  #include <bpf/btf.h>
> --
> 2.25.4
>
