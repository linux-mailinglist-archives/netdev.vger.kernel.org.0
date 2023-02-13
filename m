Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F045A694E47
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 18:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbjBMRnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 12:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjBMRni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 12:43:38 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993711CF60;
        Mon, 13 Feb 2023 09:43:36 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id bj54so2101944vkb.12;
        Mon, 13 Feb 2023 09:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9482UVrO1xOex3fDG9vOfHJvbLYfZSOVxzqODqZLrhM=;
        b=pB2tn5tHtfdCBMJjYMpCnJdlfezc6ccapdYO+jtaejPe3lAp31vt7hDCh/K1Qmk+an
         iT+5ExitRyh2ov/ygn+EM2zyfFsJOrlA0tdr04jXPHVVGKG3L0T/SZoNY8SBtnGHXe+B
         F/iAH2FmUy7ZlvOTvTc3+n9Bc2tNwmAiuypafTYDtfBnlg08SaTzS3elt8Xq0fPrGZ83
         nGa8MLNwHr7g5pG5KKnkp6VHc/sDxyUNCeo52VFtfey7pB0o6d69Hhk4O3/FvOOzF3YT
         hHUSIun+9lxMk+VcHUR/MXqlrzU31901zhjtB6kVCrFFk3TwbOKoqoteKAzeUDH09+IO
         H20w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9482UVrO1xOex3fDG9vOfHJvbLYfZSOVxzqODqZLrhM=;
        b=gwr4b6ZIRYrNX73VlVfcZIRjeYVZJwOYuIHunETzsp/SN8t42/ewfjejVj8L5FsOMk
         UFqOA/oEKZJbi0qUR0VOu8m2eOXbBj8iCvXhbBg3UpKiGZ46RNxcTDZOjJI8R7mVHSfQ
         FDRBhtBztLUAFHlhaP3S9yxaiGxsPD/yjPBL8zuolDB/swBQDeWH3VPsHNA86RTArcMw
         9yOMgTfu+PB7lxKGZQZN+CVz0TI/s26BbmgYTGielifefwp/6ibyPqIfbmLDRGqc7LhJ
         Y3fujni2ftKzA9u05dJIqi5HhM9GYnv1MOx+0sUPNiA8MIhKjfzP5EGzURdDFhS5AIRk
         O35w==
X-Gm-Message-State: AO0yUKVSj9NJPaqHfLxhkJfk4Ipy5VFnkyR1QqeLy3GBrwf/ubnmq5UQ
        dT7VJfc8d9tKVtMkXbHzJCvGhldph4K6D4UtI/2zNoLd
X-Google-Smtp-Source: AK7set9naPVyKCrqkGR7F/qNK9P9Tk3CooQcQ6h1dj4d/zgb+ama5O2Sbg2TvqL3Nq/Ktr1Ruv/ioL+LSUFZ1zV47KU=
X-Received: by 2002:a1f:3883:0:b0:401:58fe:533 with SMTP id
 f125-20020a1f3883000000b0040158fe0533mr968170vka.25.1676310215561; Mon, 13
 Feb 2023 09:43:35 -0800 (PST)
MIME-Version: 1.0
References: <20211120112738.45980-1-laoar.shao@gmail.com> <20211120112738.45980-8-laoar.shao@gmail.com>
 <Y+QaZtz55LIirsUO@google.com> <CAADnVQ+nf8MmRWP+naWwZEKBFOYr7QkZugETgAVfjKcEVxmOtg@mail.gmail.com>
 <CANDhNCo_=Q3pWc7h=ruGyHdRVGpsMKRY=C2AtZgLDwtGzRz8Kw@mail.gmail.com>
 <20230208212858.477cd05e@gandalf.local.home> <20230208213343.40ee15a5@gandalf.local.home>
 <20230211140011.4f15a633@gandalf.local.home> <CALOAHbAnFHAiMH4QDgS6xN16B31qfhG8tfQ+iioCr9pw3sP=bw@mail.gmail.com>
 <20230211224455.0a4b2914@gandalf.local.home>
In-Reply-To: <20230211224455.0a4b2914@gandalf.local.home>
From:   Namhyung Kim <namhyung@gmail.com>
Date:   Mon, 13 Feb 2023 09:43:23 -0800
Message-ID: <CAM9d7chx+azdxfNVVtaC_8eM2a57aBFa3hjh0TvjFt-6Xc7r7w@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded 16
 with TASK_COMM_LEN
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>,
        John Stultz <jstultz@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Qais Yousef <qyousef@google.com>,
        Daniele Di Proietto <ddiproietto@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steve,

On Sat, Feb 11, 2023 at 8:07 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Sun, 12 Feb 2023 11:38:52 +0800
> Yafang Shao <laoar.shao@gmail.com> wrote:
>
> > > Actually, there are cases that this needs to be a number, as b3bc8547d3be6
> > > ("tracing: Have TRACE_DEFINE_ENUM affect trace event types as well") made
> > > it update fields as well as the printk fmt.
> > >
> >
> > It seems that TRACE_DEFINE_ENUM(TASK_COMM_LEN) in the trace events
> > header files would be a better fix.
>
> NACK! I much prefer the proper fix that adds the length.

Can we just have both enum and macro at the same time?
I guess the enum would fill the BTF and the macro would provide
backward compatibility.

Thanks,
Namhyung
