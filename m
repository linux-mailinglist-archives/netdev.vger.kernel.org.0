Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D23200A3F
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732695AbgFSNeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:34:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49894 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728851AbgFSNeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 09:34:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592573652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bZ7nBz2nj1ENxTdDWGMIRru7l/EDwMR0YyKxALcYo6Y=;
        b=FDz3dSXrX5fzN6doZXQkEUbf61WTgqJJ0WnBvvoi7AR9qLbHtsV58xIyaEwbn/jKwN4eNN
        X5lYf0lBx0LZlHD/hTtFupYybhwx9UlgBmSdonwABnmYMdBKVWUoz4ihAlmlvvmnKYkLAb
        +qlV9BJpDveSTqhf4OLmnz4GMlYUwPY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-irk7YSOMOLCFYFFPxWJjYQ-1; Fri, 19 Jun 2020 09:34:07 -0400
X-MC-Unique: irk7YSOMOLCFYFFPxWJjYQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF9E0835B40;
        Fri, 19 Jun 2020 13:34:04 +0000 (UTC)
Received: from krava (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9E950BE81;
        Fri, 19 Jun 2020 13:34:01 +0000 (UTC)
Date:   Fri, 19 Jun 2020 15:34:00 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 11/11] selftests/bpf: Add test for d_path helper
Message-ID: <20200619133400.GL2465907@krava>
References: <20200616100512.2168860-1-jolsa@kernel.org>
 <20200616100512.2168860-12-jolsa@kernel.org>
 <CAEf4BzZmNFUBdSzCLiiQ-anQRmnzd-E1qa0wVdXHu0pYV_-=Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZmNFUBdSzCLiiQ-anQRmnzd-E1qa0wVdXHu0pYV_-=Nw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 09:44:23PM -0700, Andrii Nakryiko wrote:
> On Tue, Jun 16, 2020 at 3:07 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding test for d_path helper which is pretty much
> > copied from Wenbo Zhang's test for bpf_get_fd_path,
> > which never made it in.
> >
> > I've failed so far to compile the test with <linux/fs.h>
> > kernel header, so for now adding 'struct file' with f_path
> > member that has same offset as kernel's file object.
> >
> > Original-patch-by: Wenbo Zhang <ethercflow@gmail.com>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  .../testing/selftests/bpf/prog_tests/d_path.c | 153 ++++++++++++++++++
> >  .../testing/selftests/bpf/progs/test_d_path.c |  55 +++++++
> >  2 files changed, 208 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/d_path.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_d_path.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/d_path.c b/tools/testing/selftests/bpf/prog_tests/d_path.c
> > new file mode 100644
> > index 000000000000..e2b7dfeb506f
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/d_path.c
> > @@ -0,0 +1,153 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#define _GNU_SOURCE
> > +#include <test_progs.h>
> > +#include <sys/stat.h>
> > +#include <linux/sched.h>
> > +#include <sys/syscall.h>
> > +
> > +#define MAX_PATH_LEN           128
> > +#define MAX_FILES              7
> > +#define MAX_EVENT_NUM          16
> > +
> > +struct d_path_test_data {
> > +       pid_t pid;
> > +       __u32 cnt_stat;
> > +       __u32 cnt_close;
> > +       char paths_stat[MAX_EVENT_NUM][MAX_PATH_LEN];
> > +       char paths_close[MAX_EVENT_NUM][MAX_PATH_LEN];
> > +};
> 
> with skeleton there is no point in defining this container struct, and
> especially duplicating it between BPF code and user-space code. Just
> declare all those fields as global variables and access them from
> skeleton directly.

ok, will check

> 
> [...]
> 
> > diff --git a/tools/testing/selftests/bpf/progs/test_d_path.c b/tools/testing/selftests/bpf/progs/test_d_path.c
> > new file mode 100644
> > index 000000000000..1b478c00ee7a
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_d_path.c
> > @@ -0,0 +1,55 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include "vmlinux.h"
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_tracing.h>
> > +
> > +#define MAX_PATH_LEN           128
> > +#define MAX_EVENT_NUM          16
> > +
> > +static struct d_path_test_data {
> > +       pid_t pid;
> > +       __u32 cnt_stat;
> > +       __u32 cnt_close;
> > +       char paths_stat[MAX_EVENT_NUM][MAX_PATH_LEN];
> > +       char paths_close[MAX_EVENT_NUM][MAX_PATH_LEN];
> > +} data;
> > +
> > +struct path;
> > +struct kstat;
> 
> both structs are in vmlinux.h, you shouldn't need this.

leftover from earlier version, will remove

thanks,
jirka

