Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACC5241421
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 02:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgHKAYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 20:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgHKAYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 20:24:11 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143BFC06174A;
        Mon, 10 Aug 2020 17:24:11 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id x10so6095047ybj.13;
        Mon, 10 Aug 2020 17:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ca9q074Qlxhxt0Jwpd7kmjuPwS3utHOAz98pmV2gWBw=;
        b=kbWoWtvqq93GLzHIaqR7TuBaSEebZpq0IjeF+lXhxObaNPwapq4KaJK1fDzSakOPMR
         O9CD3R6bHSJxkj22koO8hCQy0IVNBMCyAP8WEt5QFmVEf1K48IOKOzdsiSAj9ZD3I6kj
         YI62xvIovfi3sSbT/VU2vjKC53Xzw7iQbc5rHwM8J/4SvFYMLGCVXZoaeINO4RoMp+Bx
         4ItrZ1c7VFWhpC9d2YVdDn10KsfqRTtaJ/Tz3H1sXd8l6tGpQAWOvtAf6ls3wSnAflut
         5zgmkCtUhdC/9lGuanSjgQWXvVTHdzjpbOCOMWR+t+CIlZe1WLuMjahy0pGK9Qchh6L1
         y7vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ca9q074Qlxhxt0Jwpd7kmjuPwS3utHOAz98pmV2gWBw=;
        b=cBZy4k4Dwr5YqEb0NzAImZ/2Fp7VXMUJhA3gH+T+cs8t0CDJnkXbGDqp63D8yH7nuE
         4BQ+PuZvAZQkb1sw9gcH+cZQ8SZzPX9Z98jCj56Xw6DlHWZPtX/KBe4yMsEhWdaFtzDf
         Pi3Z+hRIh+RS9oBVOocb+eEEim1/hq8hfsIiQSb+KPTCXMClwM0ylbPrkzdFgCn7G7/N
         SxLFYRmY81r2Zo//NsnIvuyxLlbcZ+lFtZuZab5x9PdSqApz61/VSlmeSdu2FdWOH5e9
         99YCz6a4Rt0YEobKKLT8D/htOmtAw0oGsUiJuopcoR2SeLcsh1zn1phbkFjzFPVFKXsk
         j+nw==
X-Gm-Message-State: AOAM530VnXjd3Z6I9B9u7oaxqjRuTXlMts9fO4ztWND6PMaMKfFqEyGv
        TNk8r7n2nUBSJRuNxkDYm30ySw8tD9En2XlD7s0=
X-Google-Smtp-Source: ABdhPJwTfsnLFwZLuC3suF9ncPk3LSJXppF8IcN/EC0+7l4ACCVMuQCqX2CPRNWRF48JbUQWtbWJ5zlK9ptjIHSwub0=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr42541149ybq.27.1597105450335;
 Mon, 10 Aug 2020 17:24:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200807172016.150952-1-Jianlin.Lv@arm.com> <20200810153940.125508-1-Jianlin.Lv@arm.com>
In-Reply-To: <20200810153940.125508-1-Jianlin.Lv@arm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 10 Aug 2020 17:23:59 -0700
Message-ID: <CAEf4BzbYFDBXNwE-3B4vc6oZvbDbSTbwf4xgUeUpkwJ2FCQY+w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf: fix segmentation fault of test_progs
To:     Jianlin Lv <Jianlin.Lv@arm.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 8:40 AM Jianlin Lv <Jianlin.Lv@arm.com> wrote:
>
> test_progs reports the segmentation fault as below
>
> $ sudo ./test_progs -t mmap --verbose
> test_mmap:PASS:skel_open_and_load 0 nsec
> ......
> test_mmap:PASS:adv_mmap1 0 nsec
> test_mmap:PASS:adv_mmap2 0 nsec
> test_mmap:PASS:adv_mmap3 0 nsec
> test_mmap:PASS:adv_mmap4 0 nsec
> Segmentation fault
>
> This issue was triggered because mmap() and munmap() used inconsistent
> length parameters; mmap() creates a new mapping of 3*page_size, but the
> length parameter set in the subsequent re-map and munmap() functions is
> 4*page_size; this leads to the destruction of the process space.
>
> To fix this issue, first create 4 pages of anonymous mapping,then do all
> the mmap() with MAP_FIXED.
>
> Another issue is that when unmap the second page fails, the length
> parameter to delete tmp1 mappings should be 4*page_size.
>
> Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
> ---

LGTM, thanks for the fix!

Acked-by: Andrii Nakryiko <andriin@fb.com>

> v2:
> - Update commit messages
> - Create 4 pages of anonymous mapping that serve the subsequent mmap()
> ---
>  tools/testing/selftests/bpf/prog_tests/mmap.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>

[...]
