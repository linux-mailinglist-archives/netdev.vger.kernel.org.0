Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B792A8A06
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 23:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732046AbgKEWl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 17:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKEWlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 17:41:25 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9BBC0613CF;
        Thu,  5 Nov 2020 14:41:23 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id g15so2310284ybq.6;
        Thu, 05 Nov 2020 14:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IBg+B0rdAMqhMwTgaI8LziA2jYJLHwjFSBV29scAohA=;
        b=rUrahyxuN6kfjFp229eJ/LTfObTNtvtTIHiIWb7au6TG74Whyq9VUBDlxK9GC654eo
         mP824ODmongdaZg1WVqDncjRalMWCAc/VN2rVP0PL35P6F4RZLOOTvWygja8wsrqI2CL
         QCqv5PXTWmBuycuQrA8TtJeflkjwOVfSz0sZme1S4OeS3VAhY80FeyjJxJM3S1udAzHM
         cyZKyruU2zKR9/M3dFSUejIZQI1kfXjVCGrgGm3AzksdAzJiORDJJsrZ+qzYUej1vbax
         5rtncLCiVrwOJqDk0gP0zddgHQpDk2IcRC844mAOvlOuVbuY5Fm/ABhwqOuOw/vYAhWb
         qc/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IBg+B0rdAMqhMwTgaI8LziA2jYJLHwjFSBV29scAohA=;
        b=WhB0Zfxy2zZxzuJZOiEyXx2/ICxLeUUIYyXri9BVSiuNj7pPQhfx7+H+i/DncUGCms
         h2enOOHdv15mJjWPOJ/xGjI0AOdFUviFxL5908A4nqYtzZYQa+x9dzD5uBR7RE+jxWGp
         D1eVP5XVdqWWqZzbW+/4NJYKgkE42qz4Jc/G6F23/I6cBsvic6iRHDG6+hniMIPSKFRk
         WP/YTrgQ5VjPtrlKlYTdkklg2ZWeIzkrFMn7gVXe6KujFvd3pRjv3FtKTKEDd6/fy+Le
         Qon19Oqtp+bDllXUsdj7OOD0T6r1bV+HqpmWhbfoGF+EDAsyOEvag3ncF97MLrOUEHgt
         zrEg==
X-Gm-Message-State: AOAM533dmVrh3OXklE0oq4AC1AQSe1LzysV4Z882Dw0X2gChN/bhCCE1
        6XLEjkXnm3XBNiCLgONcCjdUof0SBdih2rTJs0RiOSplUEUmYA==
X-Google-Smtp-Source: ABdhPJwtPxU64n9y4j0lyNA0hiiUGXVvYBD9vOWJ7De2/xeDWk5IiKwPrufiTv3Bd7JhIboXkvewPF9jjOCSlfiF3/k=
X-Received: by 2002:a05:6902:72e:: with SMTP id l14mr6266826ybt.230.1604616083224;
 Thu, 05 Nov 2020 14:41:23 -0800 (PST)
MIME-Version: 1.0
References: <20200423195850.1259827-1-andriin@fb.com> <20201105170202.5bb47fef@redhat.com>
 <CAEf4Bzb7r-9TEAnQC3gwiwX52JJJuoRd_ZHrkGviiuFKvy8qJg@mail.gmail.com> <20201105135338.316e1677@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201105135338.316e1677@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 5 Nov 2020 14:41:12 -0800
Message-ID: <CAEf4BzZgXO1Uv49cGQ6PMoe6gXiF8obJr9uKBTeE2MzzHEr=PA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next] bpf: make verifier log more relevant by default
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Benc <jbenc@redhat.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 1:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 5 Nov 2020 13:22:12 -0800 Andrii Nakryiko wrote:
> > On Thu, Nov 5, 2020 at 8:02 AM Jiri Benc <jbenc@redhat.com> wrote:
> > > On Thu, 23 Apr 2020 12:58:50 -0700, Andrii Nakryiko wrote:
> > > > To make BPF verifier verbose log more releavant and easier to use to debug
> > > > verification failures, "pop" parts of log that were successfully verified.
> > > > This has effect of leaving only verifier logs that correspond to code branches
> > > > that lead to verification failure, which in practice should result in much
> > > > shorter and more relevant verifier log dumps. This behavior is made the
> > > > default behavior and can be overriden to do exhaustive logging by specifying
> > > > BPF_LOG_LEVEL2 log level.
> > >
> > > This patch broke the test_offload.py selftest:
> > >
> > > [...]
> > > Test TC offloads work...
> > > FAIL: Missing or incorrect message from netdevsim in verifier log
> > > [...]
> > >
> > > The selftest expects to receive "[netdevsim] Hello from netdevsim!" in
> > > the log (coming from nsim_bpf_verify_insn) but that part of the log is
> > > cleared by bpf_vlog_reset added by this patch.
> >
> > Should we just drop check_verifier_log() checks?
>
> Drivers only print error messages when something goes wrong, so the
> messages are high priority. IIUC this change was just supposed to
> decrease verbosity, right?

Seems like check_verifier_log() in test_offline.py is only called for
successful cases. This patch truncates parts of the verifier log that
correspond to successfully validated code paths, so that in case if
verification fails, only relevant parts are left. So for completely
successful verification the log will be almost empty, with only final
stats available.
