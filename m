Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B6E2A4F08
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 19:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgKCSiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 13:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgKCSiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 13:38:24 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F62C0613D1;
        Tue,  3 Nov 2020 10:38:23 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id f6so15760525ybr.0;
        Tue, 03 Nov 2020 10:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jneL8MPC5rNVRFrvszgK7JhEwgVGSd4T313AsWNvH4M=;
        b=c7JaPiAa/OfN9iQzjrg2wJPLWeWr784NcIrVeFzruUIa/03XetElg1FjMFOc7jyLSL
         lIKvD1kC21hVPGmtqmgZFKnRd1oLNm09Jz2oY2KAGSTz/gbVN1ocbX14ApRyBd/gJKyj
         M0mHQTKx1pSrMJMSybQybGpLdnLVslF+oCxxEUwaEHsqVE4dUe33TTF7ufv6mzeOjHHn
         NZjqz1yrBs3m3Ii2mUMYasErkX1TkybdVnwIs5/JOmg6OLkUe2tKAyqNxhLn1tsUiNiB
         JlOsJmAseZTOK4rBvbLDc6+p8mYJyMdsT8Z6L6gT1fM5F+gS7WEvqhWw+lmATb142J82
         1fSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jneL8MPC5rNVRFrvszgK7JhEwgVGSd4T313AsWNvH4M=;
        b=YD8DyE7dcXEHZiEmm8x+M4XBvGIoiuhcxAXIJiF250fJ+f0vGN+AxHlFoulGrm2MPA
         Ksxb9lP8QNNkmr5ERI6Mak2SG4ZN9zrrZLkVNJvbAvAfea1yBZxs1dV2em5XpKQH/c/F
         zMjy2uchJEjV5PC0F5vWN4h3+qc+u4HKcRVj8bz0uCQ6wiRgHOnda4V6Pb4VKZKMBddE
         MUFN0r9M9IR10N0Pd00xIEIAkhLhln9HiU/V7FG1ZKiCOfFLYIK6QsxfP0Oh8bSEuot7
         MFX73JBwmacgynupyzm+hEjs2NhVHgi79zOxMP3Rhcq8anSVMLrTy2ykucSIJ27GRs4D
         6YTg==
X-Gm-Message-State: AOAM530aY+c3rTwBwtYNSI0dStB5ckoM4odThTXi9oLeaqCplG8CLqRe
        L4q3iAAqhiw4UAXw+ayVu0EfX4v7HGdPZ5K6bkY=
X-Google-Smtp-Source: ABdhPJyYMv7sBOFtfOghPZyQE0FkV7MkDrx6BX2kXGLE/5KxogoIbW9eoMAUV5CwcvKHLoE/1rtfkTDfgbAfHnBcQRU=
X-Received: by 2002:a25:b0d:: with SMTP id 13mr31096731ybl.347.1604428703140;
 Tue, 03 Nov 2020 10:38:23 -0800 (PST)
MIME-Version: 1.0
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
 <160417034457.2823.10600750891200038944.stgit@localhost.localdomain>
In-Reply-To: <160417034457.2823.10600750891200038944.stgit@localhost.localdomain>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 3 Nov 2020 10:38:12 -0800
Message-ID: <CAEf4BzbauAT-ujG4LQDUY3WUkwGqMZb2JL3xuwXAu2Ot3e4w6Q@mail.gmail.com>
Subject: Re: [bpf-next PATCH v2 3/5] selftests/bpf: Replace EXPECT_EQ with
 ASSERT_EQ and refactor verify_results
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>, alexanderduyck@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 11:52 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> From: Alexander Duyck <alexanderduyck@fb.com>
>
> There is already logic in test_progs.h for asserting that a value is
> expected to be another value. So instead of reinventing it we should just
> make use of ASSERT_EQ in tcpbpf_user.c. This will allow for better
> debugging and integrates much more closely with the test_progs framework.
>
> In addition we can refactor the code a bit to merge together the two
> verify functions and tie them together into a single function. Doing this
> helps to clean the code up a bit and makes it more readable as all the
> verification is now done in one function.
>
> Lastly we can relocate the verification to the end of the run_test since it
> is logically part of the test itself. With this we can drop the need for a
> return value from run_test since verification becomes the last step of the
> call and then immediately following is the tear down of the test setup.
>
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> ---
>  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |  114 ++++++++------------
>  1 file changed, 44 insertions(+), 70 deletions(-)
>

[...]

> +       rv = bpf_map_lookup_elem(map_fd, &key, &result);
> +       if (CHECK(rv, "bpf_map_lookup_elem(map_fd)", "err:%d errno:%d",
> +                 rv, errno))
> +               return;
> +
> +       /* check global map */
> +       CHECK(expected_events != result.event_map, "event_map",
> +             "unexpected event_map: actual %#" PRIx32" != expected %#" PRIx32 "\n",
> +             result.event_map, expected_events);

nit: libbpf and selftests don't use PRI modifiers approach. Just cast
to a consistent long, int, unsigned, whichever matches the needs and
use appropriate explicit % specifier.

> +
> +       ASSERT_EQ(result.bytes_received, 501, "bytes_received");
> +       ASSERT_EQ(result.bytes_acked, 1002, "bytes_acked");
> +       ASSERT_EQ(result.data_segs_in, 1, "data_segs_in");
> +       ASSERT_EQ(result.data_segs_out, 1, "data_segs_out");
> +       ASSERT_EQ(result.bad_cb_test_rv, 0x80, "bad_cb_test_rv");
> +       ASSERT_EQ(result.good_cb_test_rv, 0, "good_cb_test_rv");
> +       ASSERT_EQ(result.num_listen, 1, "num_listen");
> +

[...]
