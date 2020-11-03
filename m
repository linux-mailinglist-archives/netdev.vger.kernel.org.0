Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501B32A4EF3
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 19:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbgKCSeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 13:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgKCSeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 13:34:13 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC4FC0613D1;
        Tue,  3 Nov 2020 10:34:13 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id a12so15671493ybg.9;
        Tue, 03 Nov 2020 10:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f5gZDG7PJd1ojE4K5U9IsMyGTaYwuZZg5TPUY7S9wyw=;
        b=aLE/md7NGzZXyeCYzLrc3GrGk7NpJrcNSUZLFZrRoGZF2MAhCxBvytkUNqTK9IXEZ9
         1Nl3UVkd7Vq130KRpBrnd9l6zAarLEUbsNnvtuso+DP/um7dhNhdRFd78/yH++gw1sWh
         BgYMIfW7dHJ1bH+da+GXhj1kbuBME76I1gmCQOgBQUNr1TeuHNmzdZz6cqwvsd0E9RIr
         HcJeURHY501S1AHG/TnuVS6WZ/e9XVHfWAHJdDpJMlD6yKJ5SBOCWEf3dg/8fC9nWu1X
         YLSIzRkwf6E+2LGhJw7H6/Wvp+qxZ/dNeKeCSwUfjWFwJm6MUkjvxY8h1wWfcZTrkCrV
         AdgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f5gZDG7PJd1ojE4K5U9IsMyGTaYwuZZg5TPUY7S9wyw=;
        b=atsZ54sD5GzM2F7lLWj8L76AripFQPwiumllx/M+5hQG1KNfKOWWcQefL0Q4RGUhDG
         ttPeBrpydYnsRuSYWT7tWQ7GkoFDfdoRGG3a3uxdPNqc7Ssg4F0oswsIpr/sqDqKpM2N
         Q/retwAQC3eQ2OullWq2jX2GTfod3xiIkiR/RDpU99tFAl8ocAfpBMPJmolExZUn7S1l
         MnqyJihPsVCmSkQPgiO07LKZ0EYHVXPeVs+rOI/xDFVovba475rl8nA5RwF6lsihE63y
         YTZL7ZJgK/YWsa6JdXemrIQpioeR0GGKLfxP13+53UqNiZtcvJeAS8yCksTLiZI848mt
         u8JA==
X-Gm-Message-State: AOAM531jfLnKua95Hzc1RTWmzQPIBZwj2tuS0mwQH0TO9BhLMRAP0DAj
        WT1VvHK07h3fpjHrYLMr9zcmU0fZEfvsgp5WKVM=
X-Google-Smtp-Source: ABdhPJzGSw2t/jV+XII12ttHjVo9klroF+FwG2mww/Jx67EFlfiZMfM7/PHwWZ9pQDCj1E6M3+fWqe/LMmesNKCbRs0=
X-Received: by 2002:a05:6902:72e:: with SMTP id l14mr1351502ybt.230.1604428453019;
 Tue, 03 Nov 2020 10:34:13 -0800 (PST)
MIME-Version: 1.0
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
 <160417033167.2823.10759249192027767614.stgit@localhost.localdomain>
In-Reply-To: <160417033167.2823.10759249192027767614.stgit@localhost.localdomain>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 3 Nov 2020 10:34:02 -0800
Message-ID: <CAEf4BzbyNVfkEe+X4ZW-vnWS_XhiD8sh059dNehGpX5eZrxaoQ@mail.gmail.com>
Subject: Re: [bpf-next PATCH v2 1/5] selftests/bpf: Move test_tcppbf_user into test_progs
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
> Recently a bug was missed due to the fact that test_tcpbpf_user is not a
> part of test_progs. In order to prevent similar issues in the future move
> the test functionality into test_progs. By doing this we can make certain
> that it is a part of standard testing and will not be overlooked.
>
> As a part of moving the functionality into test_progs it is necessary to
> integrate with the test_progs framework and to drop any redundant code.
> This patch:
> 1. Cleans up the include headers
> 2. Dropped a duplicate definition of bpf_find_map
> 3. Switched over to using test_progs specific cgroup functions
> 4. Replaced printf calls with fprintf to stderr

This is not necessary. test_progs intercept both stdout and stderr, so
you could have kept the code as is and minimize this diff further. But
it also doesn't matter all that much, so:

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> 5. Renamed main to test_tcpbpf_user
> 6. Dropped return value in favor of CHECK_FAIL to check for errors
>
> The general idea is that I wanted to keep the changes as small as possible
> while moving the file into the test_progs framework. The follow-on patches
> are meant to clean up the remaining issues such as the use of CHECK_FAIL.
>
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> ---
>  tools/testing/selftests/bpf/.gitignore             |    1
>  tools/testing/selftests/bpf/Makefile               |    3 -
>  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   63 ++++++--------------
>  3 files changed, 21 insertions(+), 46 deletions(-)
>  rename tools/testing/selftests/bpf/{test_tcpbpf_user.c => prog_tests/tcpbpf_user.c} (70%)
>

[...]
