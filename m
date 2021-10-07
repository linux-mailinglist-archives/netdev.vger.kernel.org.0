Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EA5424B2C
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 02:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbhJGAhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 20:37:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231358AbhJGAhe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 20:37:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BF77611C1;
        Thu,  7 Oct 2021 00:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633566941;
        bh=6cKDMnHiLO4iAlDzkZZoktd8oMzqhPhdRTw0v6NjFwc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KKx4mtqRMht++/IQtu8ao9cXBSAQsqu8vvlKZ1vY1zcaHgyF2N5aVNyVRd/ltjVra
         YV5UFkWXiQkU8RtY5Noou/3HcvSWeVRiwplD800t9ogN/XEVKM28TUFMoqrF8cc5n1
         Sh5dJc6cWwVO18ibz0/3aFBfvWrDFY+EU+/UbQ7iFDZWlzIYm3wTkC0xxUQooChvWl
         U389g6/M562d7HMS1yMHVFusANpcnkBce3HfruJgKB58TauZO0I3SaNDDafpDMNssj
         jYeUATwrppyDYjaimA9jTLBDh3i3ct2L4BCCCZ3cGQ4WrSascjXURl1xjY3R3F1HEa
         ankbDnw4c/xtQ==
Received: by mail-lf1-f45.google.com with SMTP id t9so17193476lfd.1;
        Wed, 06 Oct 2021 17:35:41 -0700 (PDT)
X-Gm-Message-State: AOAM530oZRcM04en6pE187gWxjCdcwQtUpj0+KZUywkrH4LBLSIWSgQ0
        AzbSJ6VY9ssx+5ry5AbT1MHRU0iUmPu3TgSLu7U=
X-Google-Smtp-Source: ABdhPJyPrVWI8onknipduPSCYODCboyal+0pNNcwYCHvxW5jsRNF2NwqzUNJrUnR36BtpmmQgQTBBFE6rdqHI6TLb+8=
X-Received: by 2002:a05:6512:3046:: with SMTP id b6mr1154520lfb.650.1633566939334;
 Wed, 06 Oct 2021 17:35:39 -0700 (PDT)
MIME-Version: 1.0
References: <20211006203135.2566248-1-songliubraving@fb.com> <CAEf4BzYs=dumqCAYp-kGFwVnQdt5eT6Yq17XQ83i9vHxE0Rmwg@mail.gmail.com>
In-Reply-To: <CAEf4BzYs=dumqCAYp-kGFwVnQdt5eT6Yq17XQ83i9vHxE0Rmwg@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 6 Oct 2021 17:35:28 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7HPTn_3=TXcAfBHY9c-GZkcAd=zFZb5M13oTZJkEwAPw@mail.gmail.com>
Message-ID: <CAPhsuW7HPTn_3=TXcAfBHY9c-GZkcAd=zFZb5M13oTZJkEwAPw@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: skip get_branch_snapshot in vm
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 6, 2021 at 2:36 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Oct 6, 2021 at 1:31 PM Song Liu <songliubraving@fb.com> wrote:
> >
> > VMs running on latest kernel support LBR. However, bpf_get_branch_snapshot
> > couldn't stop the LBR before too many entries are flushed. Skip the test
> > for VMs before we find a proper fix for VMs.
> >
> > Read the "flags" line from /proc/cpuinfo, if it contains "hypervisor",
> > skip test get_branch_snapshot.
> >
> > Fixes: 025bd7c753aa (selftests/bpf: Add test for bpf_get_branch_snapshot)
>
> missing quotes?

Aha, I copied this line from e31eec77e4ab90dcec7d2da93415f839098dc287. Will fix.

>
> > Signed-off-by: Song Liu <songliubraving@fb.com>
> > ---
> >  .../bpf/prog_tests/get_branch_snapshot.c      | 32 +++++++++++++++++++
> >  1 file changed, 32 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c b/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
> > index 67e86f8d86775..bf9d47a859449 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
> > @@ -6,6 +6,30 @@
> >  static int *pfd_array;
> >  static int cpu_cnt;
> >
> > +static bool is_hypervisor(void)
> > +{
> > +       char *line = NULL;
> > +       bool ret = false;
> > +       size_t len;
> > +       FILE *fp;
> > +
> > +       fp = fopen("/proc/cpuinfo", "r");
> > +       if (!fp)
> > +               return false;
> > +
> > +       while (getline(&line, &len, fp) != -1) {
> > +               if (strstr(line, "flags") == line) {
>
> strncmp() would be more explicit. That's what you are trying to do
> (prefix match), right?

right... let me fix it in v2.

>
> > +                       if (strstr(line, "hypervisor") != NULL)
> > +                               ret = true;
> > +                       break;
> > +               }
> > +       }
> > +
> > +       free(line);
> > +       fclose(fp);
> > +       return ret;
> > +}
> > +
> >  static int create_perf_events(void)
> >  {
> >         struct perf_event_attr attr = {0};
> > @@ -54,6 +78,14 @@ void test_get_branch_snapshot(void)
> >         struct get_branch_snapshot *skel = NULL;
> >         int err;
> >
> > +       if (is_hypervisor()) {
> > +               /* As of today, LBR in hypervisor cannot be stopped before
> > +                * too many entries are flushed. Skip the test for now in
> > +                * hypervisor until we optimize the LBR in hypervisor.
> > +                */
> > +               test__skip();
> > +               return;
> > +       }
> >         if (create_perf_events()) {
> >                 test__skip();  /* system doesn't support LBR */
> >                 goto cleanup;
> > --
> > 2.30.2
> >
