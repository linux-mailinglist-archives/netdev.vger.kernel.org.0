Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1023C3D6E
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 16:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbhGKOv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 10:51:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233449AbhGKOv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 10:51:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626014920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1hrLNyDSPTRLrzMIFQFpw//UU589xbINtFOVY47zgPk=;
        b=epbziitUOCxy8fOQe/O2HIxY2nSklQ6KelHAJxD3Ia7uajWZPIfdk8xpv3nl2t8SdHDtG7
        B35trPR+2aOLtRaCUUCLG7VN3X78C3Dpo6JRqiqnN8lQjySTfzBcRujf5BnTtjHw17YW+N
        b0bgduImT3BtO6K8kWkBSAOvU3zqPW8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-4-sOAwgTNzGd7OAevSC54Q-1; Sun, 11 Jul 2021 10:48:38 -0400
X-MC-Unique: 4-sOAwgTNzGd7OAevSC54Q-1
Received: by mail-ed1-f70.google.com with SMTP id v2-20020a50c4020000b02903a6620f87feso269698edf.18
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 07:48:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1hrLNyDSPTRLrzMIFQFpw//UU589xbINtFOVY47zgPk=;
        b=IHYhF5Z1JO7bPozR2PnO6MOcQ8LJABCF62SgTpKt5fUAs7t7ZQQZpBSIU0gN9+C8IU
         8FfgOtSsKjzU0CvTMIneBUqc+y7+zOqEwN44dlI9MfrynR2Ai0CoqOa0vGWkRsycrQvv
         4dcB8LGZhiX4qpiFSTy3pzeyrNEqiGmJRBScUuztCiGq31VbHkvl5ILuf21NFg7CCgAf
         PPNEi0PZyGSQ5c1XxvkJgPL1fLnlK3pq5unno37efAU1CpUh5MLlRRBMX4AEiaweQ6Ac
         tnmANONA3mL8rlwVxCOhvJLzLtC8chgs/x39jTYydUpVUEQCEgaWXtBkHWrBxAGLHvtv
         09Wg==
X-Gm-Message-State: AOAM5311C5k9enzCf3olTND53t7uX4EekNtAhf3dohH3GKhUgNvXAwl4
        GjBPXbpiBI4myHx+2TShjIsCCkgNp9DSeWAYH8V5HFUG/ijR/c0cCiPxb8/h+UYyMpJsjZnPiY9
        ptnUT8zT+KCT2EmFv
X-Received: by 2002:a17:907:3d8a:: with SMTP id he10mr26892241ejc.16.1626014917633;
        Sun, 11 Jul 2021 07:48:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSmSpVq+gJnx+4SgyvUwJb25PC5Dc0kFgIcBKxU+iX+/E1oF1AdihZiObMH0CjfWi3wBmhGA==
X-Received: by 2002:a17:907:3d8a:: with SMTP id he10mr26892230ejc.16.1626014917466;
        Sun, 11 Jul 2021 07:48:37 -0700 (PDT)
Received: from krava ([5.171.250.127])
        by smtp.gmail.com with ESMTPSA id n18sm4019892ejl.74.2021.07.11.07.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 07:48:37 -0700 (PDT)
Date:   Sun, 11 Jul 2021 16:48:33 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCHv3 bpf-next 5/7] selftests/bpf: Add test for
 bpf_get_func_ip helper
Message-ID: <YOsEwcMRkUn5mdNr@krava>
References: <20210707214751.159713-1-jolsa@kernel.org>
 <20210707214751.159713-6-jolsa@kernel.org>
 <CAEf4BzZxDAQZ4Y5n8uCjvrEgmr51CY3AQ8y7zM_Hoh+7zqd6DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZxDAQZ4Y5n8uCjvrEgmr51CY3AQ8y7zM_Hoh+7zqd6DA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 07, 2021 at 05:12:07PM -0700, Andrii Nakryiko wrote:
> On Wed, Jul 7, 2021 at 2:54 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > Adding test for bpf_get_func_ip helper for fentry, fexit,
> > kprobe, kretprobe and fmod_ret programs.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  .../bpf/prog_tests/get_func_ip_test.c         | 42 +++++++++++++
> >  .../selftests/bpf/progs/get_func_ip_test.c    | 62 +++++++++++++++++++
> >  2 files changed, 104 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/get_func_ip_test.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/get_func_ip_test.c
> >
> 
> [...]
> 
> > +       ASSERT_OK(err, "test_run");
> > +
> > +       result = (__u64 *)skel->bss;
> > +       for (i = 0; i < sizeof(*skel->bss) / sizeof(__u64); i++) {
> > +               if (!ASSERT_EQ(result[i], 1, "fentry_result"))
> > +                       break;
> > +       }
> 
> I dislike such generic loop over results. It's super error prone and
> takes the same 5 lines of code that you'd write for explicit
> 
> ASSERT_EQ(testX_result, 1, "testX_result"); /* 5 times */

ok

> 
> > +
> > +       get_func_ip_test__detach(skel);
> 
> no need to explicitly detach, __destroy does that automatically

I see, will remove that

thanks,
jirka

> 
> > +
> > +cleanup:
> > +       get_func_ip_test__destroy(skel);
> > +}
> 
> [...]
> 

