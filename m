Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13095485A24
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 21:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244144AbiAEUkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 15:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244127AbiAEUkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 15:40:46 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13806C061245;
        Wed,  5 Jan 2022 12:40:46 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id q5so576638ioj.7;
        Wed, 05 Jan 2022 12:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=45SP3bqnZoHbEc/qN8LNfImZ/YeuvDvy9LOD6oQtizc=;
        b=ZVNnYwfLnJ+VojOtedXPo9wsSncszCXEGLqxeFiv0cSvYCfEuXKUZzUz24Q0rTyE5L
         liw4nrhmGy9KHAEDDvwMr7/3sQbhlM16FaWF8V/p0MCi5mT/edk4FXpX4ok/yoAjcjeO
         QVUyteWuGvf9ueQE7C+tHLFD4LMmv3NeHuR9vZLp90GDnEsvSdeM9uFMtFNUNJ7kvEUv
         J1D7ZZOA6Y8yexvtLELBDpjs9D9E8qV/pVXEUiBp09vsrEoq23/Q2GG2kb29g5XT+KSq
         pEtSyc/W6wuvYRoGomG9DWbJGbCCN599K5e0zqTsvXuiYff3w3yCcs9jIV7X6K8Slq0P
         OkQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=45SP3bqnZoHbEc/qN8LNfImZ/YeuvDvy9LOD6oQtizc=;
        b=6+nkQgs6mKT6DG1srIRacbWqnakfm7qExvhMDecxr8s+jrh+PMmHI9RVXxuI2gniOI
         Iubu9vxXmIXDhm+Lfa2wFxmF8HnsME8/lonrmlGVQ9hmpaYTb/sIUHj/czbbFDFhF6uO
         eAnu914r5Qvtq6NSM2F2YR5K1rDDNt/L72o0vfDj59eoby86q7wLCWtaVzgZ1TW27HRB
         AYEdySyiaZd9VmwyZb4l9cnvjLqLixwfojhECv7dKxB2HNALbx2/VCKblajJkd1oA5KU
         7puvCTXYkshzmgez0B4VQksuxXq+DHMjv6Qbd5JEn+/lOhRKibwPS9FkQ7gVa20AFDi1
         5PaA==
X-Gm-Message-State: AOAM531/peNXcaSw7OpXi5qsT3a7E9TwX7hiLrNHfjGMls8LQ9yn/VMW
        TI7CZseSq7sgO6VzDcM1rGe4h8cuT97pLpAMgNw=
X-Google-Smtp-Source: ABdhPJyBwku1U1w4AAxvzgmc//dVuyBdCj8HysKq+5CBS+QAK19GVbV1nnmEqFC6AlveVlq1rBKBR+7vzkwtTSCwJpI=
X-Received: by 2002:a05:6602:2d81:: with SMTP id k1mr25810715iow.112.1641415245384;
 Wed, 05 Jan 2022 12:40:45 -0800 (PST)
MIME-Version: 1.0
References: <20220104121030.138216-1-jolsa@kernel.org>
In-Reply-To: <20220104121030.138216-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Jan 2022 12:40:34 -0800
Message-ID: <CAEf4BzZK1=zdy1_ZdwWXK7Ryk+uWQeSApcpxFT9yMp4bRNanDQ@mail.gmail.com>
Subject: Re: [PATCH] bpf/selftests: Fix namespace mount setup in tc_redirect
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jussi Maki <joamaki@gmail.com>, Hangbin Liu <haliu@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 4:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> The tc_redirect umounts /sys in the new namespace, which can be
> mounted as shared and cause global umount. The lazy umount also
> takes down mounted trees under /sys like debugfs, which won't be
> available after sysfs mounts again and could cause fails in other
> tests.
>
>   # cat /proc/self/mountinfo | grep debugfs
>   34 23 0:7 / /sys/kernel/debug rw,nosuid,nodev,noexec,relatime shared:14 - debugfs debugfs rw
>   # cat /proc/self/mountinfo | grep sysfs
>   23 86 0:22 / /sys rw,nosuid,nodev,noexec,relatime shared:2 - sysfs sysfs rw
>   # mount | grep debugfs
>   debugfs on /sys/kernel/debug type debugfs (rw,nosuid,nodev,noexec,relatime)
>
>   # ./test_progs -t tc_redirect
>   #164 tc_redirect:OK
>   Summary: 1/4 PASSED, 0 SKIPPED, 0 FAILED
>
>   # mount | grep debugfs
>   # cat /proc/self/mountinfo | grep debugfs
>   # cat /proc/self/mountinfo | grep sysfs
>   25 86 0:22 / /sys rw,relatime shared:2 - sysfs sysfs rw
>
> Making the sysfs private under the new namespace so the umount won't
> trigger the global sysfs umount.

Hey Jiri,

Thanks for the fix. Did you try making tc_redirect non-serial again
(s/serial_test_tc_redirect/test_tc_redirect/) and doing parallelized
test_progs run (./test_progs -j) in a tight loop for a while? I
suspect this might have been an issue forcing us to make this test
serial in the first place, so now that it's fixed, we can make
parallel test_progs a bit faster.

>
> Cc: Jussi Maki <joamaki@gmail.com>
> Reported-by: Hangbin Liu <haliu@redhat.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/testing/selftests/bpf/prog_tests/tc_redirect.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
> index 4b18b73df10b..c2426df58e17 100644
> --- a/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
> +++ b/tools/testing/selftests/bpf/prog_tests/tc_redirect.c
> @@ -105,6 +105,13 @@ static int setns_by_fd(int nsfd)
>         if (!ASSERT_OK(err, "unshare"))
>                 return err;
>
> +       /* Make our /sys mount private, so the following umount won't
> +        * trigger the global umount in case it's shared.
> +        */
> +       err = mount("none", "/sys", NULL, MS_PRIVATE, NULL);
> +       if (!ASSERT_OK(err, "remount private /sys"))
> +               return err;
> +
>         err = umount2("/sys", MNT_DETACH);
>         if (!ASSERT_OK(err, "umount2 /sys"))
>                 return err;
> --
> 2.33.1
>
