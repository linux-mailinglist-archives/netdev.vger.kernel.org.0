Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12104933C2
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 04:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351353AbiASDtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 22:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240579AbiASDtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 22:49:05 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5BDC061574;
        Tue, 18 Jan 2022 19:49:05 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id f24so1321423ioc.0;
        Tue, 18 Jan 2022 19:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4UkxrBWYZSHawQTKo6vwK9yH1igAtKMWj2abRvMD+YI=;
        b=T0zpgWhJrFnk0wjQLYJc5BzM1/07cFpSGt8a/3JaSPi7XrtakCXfc/98x9hmnpIqx7
         YP1PF/AP4tNbeCfoTBF2Y77I8sSKD0bw9u2WD0FIKReKM244pte/Fy0oUJ5x8hT1gzBT
         m8D0Abij5O2QgNG9vW6albgFGQaVF1YLXkYuAZT2OQaZ4us/4+ACEbg/doaOsQzhfQyH
         d8x+fqGFqeBqncfhDso7r3MGjqdakKgtkoDxyn7HGX5OcuxXSdZrU53iKY2bQ8vVFPci
         OsDS0m5AnNzP1ZUUeMewXoCP/SOXYd3rZlbp77/6qHPfvaeCQMooydKqljwS2qNVZZjd
         CMmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4UkxrBWYZSHawQTKo6vwK9yH1igAtKMWj2abRvMD+YI=;
        b=ld1puUgpNhvkCiWSZE3tSnd+X4d5nNBE3jGiFG65gs+oU5tTcWBAT2wSrFxfqyT22z
         NefCpl6OIbQocm2yoRcVdyi1ckoRT49u1bEGNqGLdwk6q+NwKP6N0gEUOWJsA3QfKvro
         44l2G7iub/xJKMvzQKnGMYA+Kkpw24+9iXUGGJR7om0GnvLUC0BykI2rHHTq7jUnWKKm
         idGT912uQpJBVCVm2Ofr85yLa2nsjfb/EduvTzfc55qj0TAuDH5lGGjvax4J/KhXRxq5
         6ca6ZNJ8DTsfdJddZTlFkAs57eOTASo6xIsVOECYaZjhkVh3EjoPFg4Ur6Nc2F6VNcVq
         hCcQ==
X-Gm-Message-State: AOAM533VyDv09hVyS+dWn0u4sspoOZGO0t/gcbIvXQ6FnUlNl3aYl4Et
        uj3tKmY4lWOheDcMXSyApVdURSTF3M+SsBkrjLM=
X-Google-Smtp-Source: ABdhPJzV6neFI7xxV3nldyPBGl6r9A9iZQoYrX6MwwBhbzp/vHpNHoDkZt8OHUGcg8fUjpAJyliTo/DWjcQ3ZduxsTc=
X-Received: by 2002:a02:ca03:: with SMTP id i3mr13198575jak.234.1642564144774;
 Tue, 18 Jan 2022 19:49:04 -0800 (PST)
MIME-Version: 1.0
References: <20220104121030.138216-1-jolsa@kernel.org> <CAEf4BzZK1=zdy1_ZdwWXK7Ryk+uWQeSApcpxFT9yMp4bRNanDQ@mail.gmail.com>
 <Ydabtmk+BmzIxKwJ@krava> <YeXCsTWsvE+a1cld@krava>
In-Reply-To: <YeXCsTWsvE+a1cld@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 18 Jan 2022 19:48:52 -0800
Message-ID: <CAEf4BzbdOsyDFzXuAgEiQnZYQWTwcXUAT+8hJAN-=KJi2t60ag@mail.gmail.com>
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

On Mon, Jan 17, 2022 at 11:25 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Jan 06, 2022 at 08:35:18AM +0100, Jiri Olsa wrote:
> > On Wed, Jan 05, 2022 at 12:40:34PM -0800, Andrii Nakryiko wrote:
> > > On Tue, Jan 4, 2022 at 4:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > The tc_redirect umounts /sys in the new namespace, which can be
> > > > mounted as shared and cause global umount. The lazy umount also
> > > > takes down mounted trees under /sys like debugfs, which won't be
> > > > available after sysfs mounts again and could cause fails in other
> > > > tests.
> > > >
> > > >   # cat /proc/self/mountinfo | grep debugfs
> > > >   34 23 0:7 / /sys/kernel/debug rw,nosuid,nodev,noexec,relatime shared:14 - debugfs debugfs rw
> > > >   # cat /proc/self/mountinfo | grep sysfs
> > > >   23 86 0:22 / /sys rw,nosuid,nodev,noexec,relatime shared:2 - sysfs sysfs rw
> > > >   # mount | grep debugfs
> > > >   debugfs on /sys/kernel/debug type debugfs (rw,nosuid,nodev,noexec,relatime)
> > > >
> > > >   # ./test_progs -t tc_redirect
> > > >   #164 tc_redirect:OK
> > > >   Summary: 1/4 PASSED, 0 SKIPPED, 0 FAILED
> > > >
> > > >   # mount | grep debugfs
> > > >   # cat /proc/self/mountinfo | grep debugfs
> > > >   # cat /proc/self/mountinfo | grep sysfs
> > > >   25 86 0:22 / /sys rw,relatime shared:2 - sysfs sysfs rw
> > > >
> > > > Making the sysfs private under the new namespace so the umount won't
> > > > trigger the global sysfs umount.
> > >
> > > Hey Jiri,
> > >
> > > Thanks for the fix. Did you try making tc_redirect non-serial again
> > > (s/serial_test_tc_redirect/test_tc_redirect/) and doing parallelized
> > > test_progs run (./test_progs -j) in a tight loop for a while? I
> > > suspect this might have been an issue forcing us to make this test
> > > serial in the first place, so now that it's fixed, we can make
> > > parallel test_progs a bit faster.
> >
> > hi,
> > right, will try
>
> so I can't reproduce the issue in the first place - that means without my
> fix and with reverted serial_test_tc_redirect change - by running parallelized
> test_progs, could you guys try it?
>

I tried it for a bunch of iterations and didn't repro it either.
Doesn't mean much as CI's environment is different, but I think it
might be worth making it parallel again and see if it reproes in CI
again.

> jirka
>
