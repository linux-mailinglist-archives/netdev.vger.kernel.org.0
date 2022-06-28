Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F93F55C74C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343792AbiF1CsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 22:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245503AbiF1Crg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 22:47:36 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29F112D17;
        Mon, 27 Jun 2022 19:43:29 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id cw10so22897853ejb.3;
        Mon, 27 Jun 2022 19:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OZuKffCTIAUl6ESOaqpRyQY7ami98Cm7o5wD6Kgrcn0=;
        b=gQMNlJmNEWffg9q4u1rDhYC0rDT3XU87Yd+9ffJSMnvyL7f8fbLQurAvJTgL3u8ecz
         /TJ79WdIVyiGW11CO0Q6tNie34bJ3uLorJIAHkn5YM1ECaXU9cNMJzsO4jKSQKyIbgrn
         +4YtMRPomOJ92X5k4jz4NgvqwjkhyhLSCRxMFOxFV7r3Ump0+DUk3qz5glncGITdCnY8
         Jlg0RlhTskjMFFlu1gwqEIt4gDyq28FdxoMLp/zL6H/tWJs1jZWJBdpQXR/mbNg1EXwC
         +HJ4Eori1KydQmGBMBKAHLJqp/3QwWQp+d8Oq3kOQJXoq3WNHsWqW2AOkSwCmf9sm7TQ
         glMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OZuKffCTIAUl6ESOaqpRyQY7ami98Cm7o5wD6Kgrcn0=;
        b=2fj5NkIh8YK9HeIwP5Lf7Wodlf6bVh8urGwNV5s+Xo3EZut0f4V7v0ndnAcmbaqySR
         4w9DpLgZ7Fd3O77Cl1ImjRE7ivJDxvrfQH3/BKLD/4TxR7X2lEYl9pAxTJ2HcK+FwvNO
         olRUroSqL2VOA+Cnr4bu4sL76B4Gc+m7xKiP7B51YilHaO4/iVM6AlYo+RvRKA4f+i16
         kfn9p75SN+m4iPi2W24fzikP9LaBglLo3a/O66nL8jBRl3ADSHtM8i/4x6yEAb1+aUyd
         oGfyB+hwBDJexTCf/RCfpsIbqQvkc+L73AqmpZfhzqHMKdDr3R2QQVvcJ0OvIbL5KsZQ
         1ktw==
X-Gm-Message-State: AJIora/XHhFhm7gQbkJ2C3bxraDF1t2x+/jkk6F/xpv8GD3f33deM6Li
        yYhUe2006WXSrPz8dRdx+yOt9MhVX4aK/MCj6+w=
X-Google-Smtp-Source: AGRyM1tR8OgjOXKpQXnwpcuL+e1uNWBu9bl5mlmU2QvZ5sHF3++SkAxcOZIJI4wfB0SvJiXs2O6fFiqFgfcACWP2/j8=
X-Received: by 2002:a17:907:6284:b0:726:6f64:c7f4 with SMTP id
 nd4-20020a170907628400b007266f64c7f4mr13746466ejc.8.1656384208388; Mon, 27
 Jun 2022 19:43:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220626031301.60390-1-nashuiliang@gmail.com> <CAEf4BzbnEFqdEZTNRWf8vJ8hExpKkg_rwgoQE-cyyU7fDafxZw@mail.gmail.com>
 <CACueBy5zdsVz-CVhtY0ekKDbrmF3ra6YSBuPWQK_qxSb6dXsxA@mail.gmail.com> <CAEf4BzZK7WNFfwHo3dV=0_BTKVUVPXKAAtGoS6MKgzWGz1GzkQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZK7WNFfwHo3dV=0_BTKVUVPXKAAtGoS6MKgzWGz1GzkQ@mail.gmail.com>
From:   Chuang W <nashuiliang@gmail.com>
Date:   Tue, 28 Jun 2022 10:43:17 +0800
Message-ID: <CACueBy6u_KL_CQdNwRs452x4eP-UnDs2JLqmD0U=pAU2i1zHCQ@mail.gmail.com>
Subject: Re: [PATCH v3] libbpf: Cleanup the legacy kprobe_event on failed add/attach_event()
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

Ok.

Thanks,

On Tue, Jun 28, 2022 at 10:35 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jun 27, 2022 at 6:51 PM Chuang W <nashuiliang@gmail.com> wrote:
> >
> > Hi Andrii,
> >
> > On Tue, Jun 28, 2022 at 5:27 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Sat, Jun 25, 2022 at 8:13 PM Chuang W <nashuiliang@gmail.com> wrote:
> > > >
> > > > Before the 0bc11ed5ab60 commit ("kprobes: Allow kprobes coexist with
> > > > livepatch"), in a scenario where livepatch and kprobe coexist on the
> > > > same function entry, the creation of kprobe_event using
> > > > add_kprobe_event_legacy() will be successful, at the same time as a
> > > > trace event (e.g. /debugfs/tracing/events/kprobe/XXX) will exist, but
> > > > perf_event_open() will return an error because both livepatch and kprobe
> > > > use FTRACE_OPS_FL_IPMODIFY. As follows:
> > > >
> > > > 1) add a livepatch
> > > >
> > > > $ insmod livepatch-XXX.ko
> > > >
> > > > 2) add a kprobe using tracefs API (i.e. add_kprobe_event_legacy)
> > > >
> > > > $ echo 'p:mykprobe XXX' > /sys/kernel/debug/tracing/kprobe_events
> > > >
> > > > 3) enable this kprobe (i.e. sys_perf_event_open)
> > > >
> > > > This will return an error, -EBUSY.
> > > >
> > > > On Andrii Nakryiko's comment, few error paths in
> > > > bpf_program__attach_kprobe_opts() which should need to call
> > > > remove_kprobe_event_legacy().
> > > >
> > > > With this patch, whenever an error is returned after
> > > > add_kprobe_event_legacy() or bpf_program__attach_perf_event_opts(), this
> > > > ensures that the created kprobe_event is cleaned.
> > > >
> > > > Signed-off-by: Chuang W <nashuiliang@gmail.com>
> > >
> > > Is this your full name? Signed-off-by is required to have a full name
> > > of a person, please update if it's not
> > >
> > > > Signed-off-by: Jingren Zhou <zhoujingren@didiglobal.com>
> > > > ---
> > > > V2->v3:
> > > > - add detail commits
> > > > - call remove_kprobe_event_legacy() on failed bpf_program__attach_perf_event_opts()
> > > >
> > > >  tools/lib/bpf/libbpf.c | 15 ++++++++++++---
> > > >  1 file changed, 12 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > index 49e359cd34df..038b0cb3313f 100644
> > > > --- a/tools/lib/bpf/libbpf.c
> > > > +++ b/tools/lib/bpf/libbpf.c
> > > > @@ -10811,10 +10811,11 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
> > > >         }
> > > >         type = determine_kprobe_perf_type_legacy(probe_name, retprobe);
> > > >         if (type < 0) {
> > > > +               err = type;
> > > >                 pr_warn("failed to determine legacy kprobe event id for '%s+0x%zx': %s\n",
> > > >                         kfunc_name, offset,
> > > > -                       libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
> > > > -               return type;
> > > > +                       libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > > > +               goto clear_kprobe_event;
> > > >         }
> > > >         attr.size = sizeof(attr);
> > > >         attr.config = type;
> > > > @@ -10828,9 +10829,14 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
> > > >                 err = -errno;
> > > >                 pr_warn("legacy kprobe perf_event_open() failed: %s\n",
> > > >                         libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> > > > -               return err;
> > > > +               goto clear_kprobe_event;
> > > >         }
> > > >         return pfd;
> > > > +
> > > > +clear_kprobe_event:
> > > > +       /* Clear the newly added legacy kprobe_event */
> > > > +       remove_kprobe_event_legacy(probe_name, retprobe);
> > > > +       return err;
> > > >  }
> > > >
> > >
> > > this part looks good
> > >
> > >
> > > >  struct bpf_link *
> > > > @@ -10899,6 +10905,9 @@ bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
> > > >
> > > >         return link;
> > > >  err_out:
> > > > +       /* Clear the newly added legacy kprobe_event */
> > > > +       if (legacy)
> > > > +               remove_kprobe_event_legacy(legacy_probe, retprobe);
> > >
> > > this one will call remove_kprobe_event_legacy() even if we failed to
> > > create that kprobe_event in the first place. So let's maybe add
> > >
> > > err_clean_legacy:
> > >     if (legacy)
> > >          remove_kprobe_event_legacy(legacy_probe, retprobe);
> > >
> > > before err_out: and goto there if we fail to attach (but not if we
> > > fail to create pfd)?
> > >
> >
> > Nice, I will modify it.
> >
> > >
> > > Also, looking through libbpf code, I realized that we have exactly the
> > > same problem for uprobes, so please add same fixed to
> > > perf_event_uprobe_open_legacy and attach_uprobe_opts. Thanks!
> > >
> >
> > Oh, yes. I also noticed this problem for uprobes, I was planning to
> > submit a patch for uprobes.
> > Do you think I should submit another patch for uprobes or combine
> > kprobes and uprobes into one?
> >
>
> two separate patches make more sense, but send them as a patch series?
>
> > Thanks,
> > >
> > >
> > > >         free(legacy_probe);
> > > >         return libbpf_err_ptr(err);
> > > >  }
> > > > --
> > > > 2.34.1
> > > >
