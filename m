Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8787A52E8EC
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 11:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347736AbiETJfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 05:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347727AbiETJfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 05:35:20 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49DE13F40C;
        Fri, 20 May 2022 02:35:18 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id f10so7561331pjs.3;
        Fri, 20 May 2022 02:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0c6tWWHaqv9YocEluVJeMxSaQ4ffT6xCHDnlxrPLBcE=;
        b=IvQ0zqSKhM4OPBa9NW2eBe3mL6oMzRwfVSXxibRyEnDg7sQiJOrnFMuGIUjkpXv1iG
         Fomrt61emOrTmIb11bduSCbpEE+y/l0zKOvlJ2p1EgpEY2tiFAiCjgBiDKYCl9pbsgI8
         D17DhLJjB1MxjhxyBT9Gm1EhgLhYiTK4srsjlRyVHfWcNrZcd5cG5arh7GSCqSV/X6z3
         9jReKVrkwiMg+7ubudidg5VZOUH5WVMpWkJ/5yfxEcwZOP64zVkVGkkDkFYtOyH/whj1
         jPS4I2G4sRp02+3P5Hq+1rGL+lKjRcS0BuYvw/IOIKcLpY0YoP/lDWfb/VJTTKPQsPiR
         9g8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0c6tWWHaqv9YocEluVJeMxSaQ4ffT6xCHDnlxrPLBcE=;
        b=Kl+gsTyow5Bpv+dm6815urwkdVPM1HwAm7jxoYELji/QDpCxcvopo+nhabS6FaaZvQ
         VowfBCTvt81UE6wwjRnV8HjsfcIEFXVY3hvGhaUmKv+8Lru/2XCn99pRcVVBzipJ00b8
         +1y3KRLEmAx9tqo+k3LaPPlivN4kVYkj95isoVf46BUMyLtqG0gPCZnD/pWXK1rnKMW/
         uaDqvqHr8/5htQIi0sDqGWSPUmbo7RPNXhE+l5SrXf6T1df20MXHWtu+9lD6CVPw++Ey
         vrvo/XR2HV+8yJ5gDuk0HNq+ts+h+nMrJJ8nwsz0yuks7fE1g2okIh8va6YcY2BuW1/4
         vGvw==
X-Gm-Message-State: AOAM530qx4kFoBnsKoP18uTIwYWtrgnpLguaUdCLRS8JrhnQfC8wleyi
        ayF2SJt6QuC6gsdaDSmWO9E=
X-Google-Smtp-Source: ABdhPJzrU3vBtP1CsyttQ9WneGmZMbenJWvQxGeKLrdJ3GExV5y1KWrU4fw7w7KIsA0CcCqK1vJURQ==
X-Received: by 2002:a17:90b:3ece:b0:1df:95b:18a8 with SMTP id rm14-20020a17090b3ece00b001df095b18a8mr10788682pjb.67.1653039317938;
        Fri, 20 May 2022 02:35:17 -0700 (PDT)
Received: from localhost ([103.4.221.252])
        by smtp.gmail.com with ESMTPSA id 187-20020a6215c4000000b0050dc7628146sm1351337pfv.32.2022.05.20.02.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 02:35:17 -0700 (PDT)
Date:   Fri, 20 May 2022 15:06:07 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Tejun Heo <tj@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 2/5] cgroup: bpf: add cgroup_rstat_updated()
 and cgroup_rstat_flush() kfuncs
Message-ID: <20220520093607.sadvim2igfde6x22@apollo.legion>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-3-yosryahmed@google.com>
 <YodCPWqZodr7Shnj@slm.duckdns.org>
 <CAJD7tkYDLc9irHLFROcYSg1shwCw+Stt5HTS08FW3ceQ5b8vqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkYDLc9irHLFROcYSg1shwCw+Stt5HTS08FW3ceQ5b8vqQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 02:43:03PM IST, Yosry Ahmed wrote:
> On Fri, May 20, 2022 at 12:24 AM Tejun Heo <tj@kernel.org> wrote:
> >
> > On Fri, May 20, 2022 at 01:21:30AM +0000, Yosry Ahmed wrote:
> > > Add cgroup_rstat_updated() and cgroup_rstat_flush() kfuncs to bpf
> > > tracing programs. bpf programs that make use of rstat can use these
> > > functions to inform rstat when they update stats for a cgroup, and when
> > > they need to flush the stats.
> > >
> > > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> >
> > Do patch 1 and 2 need to be separate? Also, can you explain and comment why
> > it's __weak?
>
> I will squash them in the next version.
>
> As for the declaration, I took the __weak annotation from Alexei's
> reply to the previous version. I thought it had something to do with
> how fentry progs attach to functions with BTF and all.
> When I try the same code with a static noinline declaration instead,
> fentry attachment fails to find the BTF type ID of bpf_rstat_flush.
> When I try it with just noinline (without __weak), the fentry program
> attaches, but is never invoked. I tried looking at the attach code but
> I couldn't figure out why this happens.
>

With static noinline, the compiler will optimize away the function. With global
noinline, it can still optimize away the call site, but will keep the function
definition, so attach works. Therefore __weak is needed to ensure call is still
emitted. With GCC __attribute__((noipa)) might have been more appropritate, but
LLVM doesn't support it, so __weak is the next best thing supported by both with
the same side effect.

> In retrospect, I should have given this more thought. It would be
> great if Alexei could shed some light on this.
>
> >
> > Thanks.
>
>
> >
> > --
> > tejun

--
Kartikeya
