Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA5A522D73
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 09:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241106AbiEKHfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 03:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbiEKHfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 03:35:41 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C255207934;
        Wed, 11 May 2022 00:35:39 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id t5so1422332edw.11;
        Wed, 11 May 2022 00:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7dkrO9tsVl8CbiOzfX55Fu1ZPdjir0mhiSXXk4Rty00=;
        b=fjjSHerPTOTX1WzzGmcbxEp0rjq8QzyJWuSgWbnz0ikOMgQm2bukHucacitVdYHbaM
         FKRl3vly/kitAQAa599AjdN0MOVDE3km5EEzXH71Heqr5wSlbuDHC8gVjcrhdxcOKio3
         iQKZKSHrsux8K78YrhLcVJ5C8bXmpHn6t4UoFMrbgQKRnldW8tb+eVXk33EDHhJr/W8p
         m0H4qD55EJWaZMi0yOc0Ue2EuuR/KtG9VjURE/PUY3P+U3Y+7jm2xjIrJkY5pB1ifqVp
         5LdIKi9H+bHrVCU23O81e81E1Q5ZeQyfH7RXO6QoiG+IybJTrLH4k+0BK58LZE4mmEFH
         uOkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7dkrO9tsVl8CbiOzfX55Fu1ZPdjir0mhiSXXk4Rty00=;
        b=Hj10w6x5lD7aqnfhyH8kV0wkd+aHwiFHJsARb26hoQOj1dqcYt8sVcQ6Pt6CGPM+oq
         zU6oPJhdnJ3WZP98NDZKqqBCoagLPObFxLa9V4HJWmt6WQWYunTv6fIta9T6iGFdZczJ
         ScSj+9e8uO5QdmRBGVYYaSsw83mgnjLWmO6yKdtJ4m2F9ymZJT05i0/YZi4b8PFLvtYF
         TvOLUBXLOuBhGr6K3J4Ay3Zsf/J2nJkvHoLnWOiEPdEzDH72eNvz+rwmygd/sHxEwQyJ
         KuS9h+tFLGEgncMI5RCU9GKFDWysMFAKdA0jXNWkl/HgFyA/2I+729FHiUnZ6Dr09A23
         c2ig==
X-Gm-Message-State: AOAM531RNM7RsPBB3l6O0b4Ellb8ea0E2IjiK0vGU9Jmvdm9P4ePIQIx
        etO/DgI/61/3c86FgLD2qKs=
X-Google-Smtp-Source: ABdhPJz0zbo2rNIyor1uJ+07k7EPc1SrvQ+4KMUpUtXT/V75JwMO3dJbJDPrHjqYMwNMVhejdWxiZQ==
X-Received: by 2002:aa7:db4c:0:b0:428:111c:b6bd with SMTP id n12-20020aa7db4c000000b00428111cb6bdmr26601684edt.318.1652254537806;
        Wed, 11 May 2022 00:35:37 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id a18-20020a170906671200b006f3ef214e6fsm595445ejp.213.2022.05.11.00.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 00:35:37 -0700 (PDT)
Date:   Wed, 11 May 2022 09:35:34 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Subject: Re: [PATCHv2 0/3] perf tools: Fix prologue generation
Message-ID: <YntnRixbfQ1HCm9T@krava>
References: <20220510074659.2557731-1-jolsa@kernel.org>
 <CAEf4BzbK9zgetgE1yKkCANTZqizUrXgamJa2X0f0XmzQUdFrCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbK9zgetgE1yKkCANTZqizUrXgamJa2X0f0XmzQUdFrCQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 04:48:55PM -0700, Andrii Nakryiko wrote:
> On Tue, May 10, 2022 at 12:47 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > hi,
> > sending change we discussed some time ago [1] to get rid of
> > some deprecated functions we use in perf prologue code.
> >
> > Despite the gloomy discussion I think the final code does
> > not look that bad ;-)
> >
> > This patchset removes following libbpf functions from perf:
> >   bpf_program__set_prep
> >   bpf_program__nth_fd
> >   struct bpf_prog_prep_result
> >
> > v2 changes:
> >   - use fallback section prog handler, so we don't need to
> >     use section prefix [Andrii]
> >   - realloc prog->insns array in bpf_program__set_insns [Andrii]
> >   - squash patch 1 from previous version with
> >     bpf_program__set_insns change [Daniel]
> >   - patch 3 already merged [Arnaldo]
> >   - added more comments
> >
> >   meanwhile.. perf/core and bpf-next diverged, so:
> >     - libbpf bpf_program__set_insns change is based on bpf-next/master
> >     - perf changes do not apply on bpf-next/master so they are based on
> >       perf/core ... however they can be merged only after we release
> >       libbpf 0.8.0 with bpf_program__set_insns change, so we don't break
> >       the dynamic linking
> >       I'm sending perf changes now just for review, I'll resend them
> >       once libbpf 0.8.0 is released
> >
> > thanks,
> > jirka
> >
> >
> > [1] https://lore.kernel.org/bpf/CAEf4BzaiBO3_617kkXZdYJ8hS8YF--ZLgapNbgeeEJ-pY0H88g@mail.gmail.com/
> > ---
> > Jiri Olsa (1):
> >       libbpf: Add bpf_program__set_insns function
> >
> 
> The first patch looks good to me. The rest I can't really review and
> test properly, so I'll leave it up to Arnaldo.
> 
> Arnaldo, how do we coordinate these patches? Should they go through
> bpf-next (after you Ack them) or you want them in your tree?
> 
> I'd like to get the bpf_program__set_insns() patch into bpf-next so
> that I can do libbpf v0.8 release, having it in a separate tree is
> extremely inconvenient. Please let me know how you think we should
> proceed?

we need to wait with perf changes after the libbpf is merged and
libbpf 0.8.0 is released.. so we don't break dynamic linking for
perf

at the moment please just take libbpf change and I'll resend the
perf change later if needed

thanks,
jirka
