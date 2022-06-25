Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A7355A80F
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 10:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbiFYIXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 04:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbiFYIXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 04:23:14 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED91D12779;
        Sat, 25 Jun 2022 01:23:13 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id h23so9038469ejj.12;
        Sat, 25 Jun 2022 01:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=65Q8k0imOaRF9rnJ5hHPlshRRUlGLNdbW9j4sF8Q/TM=;
        b=gUrn5r9Ph5LUVGtYTQdBY1IPrbtqC4eI1AIe2Rcu36DehVXdSc9vK2mj15KJQoF0H9
         BvzWfuln4jPQOvwi1Z7V/gWK6fZ0adi9mbxrNSTyqhFexhMYLp1o39DSmzlHr+vhqwuC
         sWKaUx66LLkPgAWAMW7+jE8dhpXfIWzusfTWidKzsFHuJA5qwvXAA0Auy2qvSnayi/zO
         qaBLBQlgfFfK6heIBC6osC1iuxmD/3wCd67Camj7Xj78M3EMHbGTX0MaRKy3/DfE+rB8
         O3Xb2BiuSTAIcba9DNCKPFluZoPDwymXjZddAddpaX86fLqHKtXERZmnft4v6j9M0ML+
         dzzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=65Q8k0imOaRF9rnJ5hHPlshRRUlGLNdbW9j4sF8Q/TM=;
        b=WhDVKsgF+KlsOIkrbVfFtdRVmask9aDHkNTtwmnQ1cnGC2BKyurwZ6BEoLnV9mhVrt
         5XEx1Jb8FKZXGbh45eHbnfTGO8Q58YxV42wsTxQAcBv06NCq7Vv0ENuX0/CdPM0+kb2k
         qmVjOux6Kr83XELN8ML6GPKs1y72uXfdpoXrFL9mx8IS9CNclIuTBd2I2BuwG8dkpvjA
         NvGQusmBpt+q2xanXf60wna/NU08vWDXR3UdMKnQB/QRfz5pIc0I5KQSev123zToIIna
         DRtzdhXeqoLwiD6YdxsTptMsGj1vCsoYfxu8DlRX90E5cjBek0gWeYpwXAFw4nG8n9wP
         8ugw==
X-Gm-Message-State: AJIora+GuNp6vtN4NOu+Nu1vcpGo5hpqsKFIEZuJk3zzYvT+j5UZY6RK
        sWhbdGIPmrpOeJPztMHDLdylQY7KNLNG/0FSlekwAOKer9S42g==
X-Google-Smtp-Source: AGRyM1vkYSWMUMHcrjnAB2zpsWLfkrs1qjSoyzng3NZUT/lgWgNtuFB9Hi+RMZ/8r6iW43Fk01yMR4s2n/+cG09CES4=
X-Received: by 2002:a17:907:eab:b0:70f:599c:c730 with SMTP id
 ho43-20020a1709070eab00b0070f599cc730mr2762650ejc.362.1656145392365; Sat, 25
 Jun 2022 01:23:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220621073233.53776-1-nashuiliang@gmail.com> <CAEf4BzZmZjF62GzwQ2D7Sarhfha+Uc1g+TKPszZJ60jTMb0dbA@mail.gmail.com>
In-Reply-To: <CAEf4BzZmZjF62GzwQ2D7Sarhfha+Uc1g+TKPszZJ60jTMb0dbA@mail.gmail.com>
From:   Chuang W <nashuiliang@gmail.com>
Date:   Sat, 25 Jun 2022 16:23:01 +0800
Message-ID: <CACueBy6Ufi_jY9DcD_cTntPFxPe_6fOOqt5Ms-gg-ZcjDGE-CA@mail.gmail.com>
Subject: Re: [PATCH v2] libbpf: Cleanup the kprobe_event on failed add_kprobe_event_legacy()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jingren Zhou <zhoujingren@didiglobal.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Andrii,

Oh, yes. I verified that when bpf_program__attach_kprobe_opts() fails,
the kprobe_event did not clean up.
I will resubmit V3 soon, and fix it.

Thanks.

On Thu, Jun 23, 2022 at 12:03 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Jun 21, 2022 at 12:32 AM Chuang W <nashuiliang@gmail.com> wrote:
> >
> > Before the 0bc11ed5ab60 commit ("kprobes: Allow kprobes coexist with
> > livepatch"), in a scenario where livepatch and kprobe coexist on the
> > same function entry, the creation of kprobe_event using
> > add_kprobe_event_legacy() will be successful, at the same time as a
> > trace event (e.g. /debugfs/tracing/events/kprobe/XX) will exist, but
> > perf_event_open() will return an error because both livepatch and kprobe
> > use FTRACE_OPS_FL_IPMODIFY.
> >
> > With this patch, whenever an error is returned after
> > add_kprobe_event_legacy(), this ensures that the created kprobe_event is
> > cleaned.
> >
> > Signed-off-by: Chuang W <nashuiliang@gmail.com>
> > Signed-off-by: Jingren Zhou <zhoujingren@didiglobal.com>
> > ---
>
> This part is good, but I think there are few error paths in
> bpf_program__attach_kprobe_opts() itself that would need to call
> remove_kprobe_event_legacy() explicitly as well, no?
>
> >  tools/lib/bpf/libbpf.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 0781fae58a06..d0a36350e22a 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -10809,10 +10809,11 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
> >         }
> >         type = determine_kprobe_perf_type_legacy(probe_name, retprobe);
> >         if (type < 0) {
> > +               err = type;
> >                 pr_warn("failed to determine legacy kprobe event id for '%s+0x%zx': %s\n",
> >                         kfunc_name, offset,
> > -                       libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
> > -               return type;
> > +                       libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > +               goto clear_kprobe_event;
> >         }
> >         attr.size = sizeof(attr);
> >         attr.config = type;
> > @@ -10826,9 +10827,14 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
> >                 err = -errno;
> >                 pr_warn("legacy kprobe perf_event_open() failed: %s\n",
> >                         libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > -               return err;
> > +               goto clear_kprobe_event;
> >         }
> >         return pfd;
> > +
> > +clear_kprobe_event:
> > +       /* Clear the newly added kprobe_event */
> > +       remove_kprobe_event_legacy(probe_name, retprobe);
> > +       return err;
> >  }
> >
> >  struct bpf_link *
> > --
> > 2.34.1
> >
