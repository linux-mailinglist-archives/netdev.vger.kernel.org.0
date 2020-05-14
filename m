Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A261D4151
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgENWsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 18:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728229AbgENWsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 18:48:32 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5F2C061A0C;
        Thu, 14 May 2020 15:48:32 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id a136so645955qkg.6;
        Thu, 14 May 2020 15:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JcsgzMTtQYQwNRZlt0cIGL6xslZItlWI6YtepVKLLxk=;
        b=YFXV9rnKX7fgtDb+QpvZjonNlS4d9K/gk4KG5dc8VKf3TC6tWxXSM1A13Fx7hEp1IZ
         Dr4es8Y+o2Wv0N53ioc/6pj/ST/fZv1082SMTm5tfGjO4trvA8uHxFTSXkcjQodtq9KI
         Su8NNU4BZ4bfHIrtkOC0vjrb1tcRoP0KPN2d8OEMLL0uJmUTvJMUEabs5ADR0Ck9L2VS
         cNZvhADqHdsq1t2Sb2iHtNedkywVON4mjPaMLmWWyodgHjuVV6165PJxdYkqamYDMhOD
         X+HsoJ7iWwnUA7xHyhPBXzL/dAWqYkwNbXmrfjqCEaQn+U6EyK8znpOSTzWjE580H0g/
         f1TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JcsgzMTtQYQwNRZlt0cIGL6xslZItlWI6YtepVKLLxk=;
        b=Tcy6QtxJpaG3fx1AfLYZB2Gu0RngcZqinGGm34qvFvR51xNSvoy5LsVR9RbMxulQLP
         sq01/d1keZ8l8W0jtkR0XjQS3feDqcv1SPgkasLDOnhMBvvf9EChOiJCi+tTyXLfHuvh
         qtyXZpEpVIhIk8GzGOx/2dnapj1VPttsoqnri+J44fskTQ5ksNjuBIOT155rYbBtx6Eq
         wrkPUlECepS9K0acdirk0IhYyY6Z1/LTA53rzAc+xahKduPBofCU/dM5L8Rt5VXElwWJ
         qavxDW16xaW61VhRlHfg2BvzFYXsrw4bi8uSdrsXn0bnqL/FYFqXYFRSiRaYU6c8AFkl
         D7CQ==
X-Gm-Message-State: AOAM533uZOxq++cV4QS1neyCYwkoUTWImV5j6ifWoZtzaaGivDPksqH8
        9GQ9iWK4PsVVFf6xSfEFmrboIQFGT4cmI9Onw/g=
X-Google-Smtp-Source: ABdhPJwQomwiIqi1243ipLJ0CuayYWRY8uGhUGIj67WJZrq/V0x6YIvfKwwCBUCw85HqRcmEl+Cn/wAL8ShPmzN4+xs=
X-Received: by 2002:a05:620a:2049:: with SMTP id d9mr692473qka.449.1589496511609;
 Thu, 14 May 2020 15:48:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200506132946.2164578-1-jolsa@kernel.org> <20200506132946.2164578-9-jolsa@kernel.org>
In-Reply-To: <20200506132946.2164578-9-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 May 2020 15:48:20 -0700
Message-ID: <CAEf4Bzbn_m8HUmvkBwK9t3-CkO+gz4SvAvMsO7aUQ49v3skh=w@mail.gmail.com>
Subject: Re: [PATCH 8/9] selftests/bpf: Add test for d_path helper
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 6:32 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding test for d_path helper which is pretty much
> copied from Wenbo Zhang's test for bpf_get_fd_path,
> which never made it in.
>
> I've failed so far to compile the test with <linux/fs.h>
> kernel header, so for now adding 'struct file' with f_path
> member that has same offset as kernel's file object.
>

Switch to using vmlinux.h? It would also be nice to use skeletons
instead of bpf_object__xxx API.

> Original-patch-by: Wenbo Zhang <ethercflow@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../testing/selftests/bpf/prog_tests/d_path.c | 196 ++++++++++++++++++
>  .../testing/selftests/bpf/progs/test_d_path.c |  71 +++++++
>  2 files changed, 267 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/d_path.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_d_path.c
>

[...]
