Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBAA530AB2
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 10:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiEWHt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 03:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiEWHto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 03:49:44 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA5B13F2A;
        Mon, 23 May 2022 00:49:32 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id c9-20020a7bc009000000b0039750ec5774so508066wmb.5;
        Mon, 23 May 2022 00:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zu70cwOOuZ1oF/eU6+5XWmRQ1JftQs7psdHlaNbUxCs=;
        b=eYLyyMRCEU6pafvm0GgqZPVNZdkQLXjzxY3aWYPbhoRG8DqKnlCLE4CDl8IXlZ9nUD
         7zYPue6NprgtvMZzVJjhHBagIf84+hKdiDcGhOuyarLkrtDQw4ERDPbuakZBEWoPGo5V
         m8H1eDBwuK726CFpKgPJ3/KmKMkgM5x8rVsKGmrUNfWGcWw2gmSZrRZ9vfh/qQFzDNTH
         pU1nWntTTLAdN16MGRLks8PsoIr7lc9QqRKhqP+2+yw6ge2p2tRAs4bpVTpEq7hG+tLl
         tL0qHMLpuDVvKGClO9CUERnyMRMsgA9XTw0YOpIvnbuKq8Asfdzma7TlFSFPOPCrURf4
         9tOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zu70cwOOuZ1oF/eU6+5XWmRQ1JftQs7psdHlaNbUxCs=;
        b=LX6+kKlrhBXGeEnAtwSsG0dnJyc3rDYe041Oh096rp73hSS9hHjjQK69qO+Ih348Hx
         /UyDc6lbuLr6M7K61o7ISOl/ApQzY6TzMwT4/Cf4MhAavz/3swkjDHHHZH3BPZfiqbJm
         mqonVE5q7fjCRZV2EQwh9YLhLMdxd9VXkIsOcC/6lSuMb9vwzJppk+4p9HbjHjyqCSXe
         hFsKvOf9gW42L3EFxAg7nI6qwqMMakraUVCONhz2fG19QwS1C56cDg4nS5S8ZaIj6hx4
         uTUkEa1mN//iT0kiV1DPpd0/71J63TMGkfBgSWhkgV329JMTv/lKpoUrIW216HVU1GuB
         vlbw==
X-Gm-Message-State: AOAM5324mo/UkuY7IZYgreEl+p9Fsa507ljwDfJRZ/GPnt4QbMstwgk4
        vgEu3kLYTOqkN4/aVPzcEdg=
X-Google-Smtp-Source: ABdhPJzekajdFiZkeUg1N0gFXdEg5RpwBc5H3Epe0q9/kG/H7JBi4zMYk07xnnw96paRYgsoTf+K0g==
X-Received: by 2002:a05:600c:3c8b:b0:397:2db3:97a8 with SMTP id bg11-20020a05600c3c8b00b003972db397a8mr17725654wmb.132.1653292171090;
        Mon, 23 May 2022 00:49:31 -0700 (PDT)
Received: from krava (net-93-65-240-241.cust.vodafonedsl.it. [93.65.240.241])
        by smtp.gmail.com with ESMTPSA id k16-20020a05600c0b5000b00395f15d993fsm9062164wmr.5.2022.05.23.00.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 00:49:30 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 23 May 2022 09:49:26 +0200
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <olsajiri@gmail.com>,
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
Message-ID: <Yos8hq3NmBwemoJw@krava>
References: <20220510074659.2557731-1-jolsa@kernel.org>
 <CAEf4BzbK9zgetgE1yKkCANTZqizUrXgamJa2X0f0XmzQUdFrCQ@mail.gmail.com>
 <YntnRixbfQ1HCm9T@krava>
 <Ynv+7iaaAbyM38B6@kernel.org>
 <CAEf4BzaQsF31f3WuU32wDCzo6bw7eY8E9zF6Lo218jfw-VQmcA@mail.gmail.com>
 <YoTAhC+6j4JshqN8@krava>
 <YoYj6cb0aPNN/olH@krava>
 <CAEf4Bzaa60kZJbWT0xAqcDMyXBzbg98ShuizJAv7x+8_3X0ZBg@mail.gmail.com>
 <Yokk5XRxBd72fqoW@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yokk5XRxBd72fqoW@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 21, 2022 at 02:44:05PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, May 20, 2022 at 02:46:49PM -0700, Andrii Nakryiko escreveu:
> > On Thu, May 19, 2022 at 4:03 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> > > On Wed, May 18, 2022 at 11:46:44AM +0200, Jiri Olsa wrote:
> > > > On Tue, May 17, 2022 at 03:02:53PM -0700, Andrii Nakryiko wrote:
> > > > > Jiri, libbpf v0.8 is out, can you please re-send your perf patches?
> 
> > > > yep, just made new fedora package.. will resend the perf changes soon
> 
> > > fedora package is on the way, but I'll need perf/core to merge
> > > the bpf_program__set_insns change.. Arnaldo, any idea when this
> > > could happen?
> 
> > Can we land these patches through bpf-next to avoid such complicated
> > cross-tree dependencies? As I started removing libbpf APIs I also
> > noticed that perf is still using few other deprecated APIs:
> >   - bpf_map__next;
> >   - bpf_program__next;
> >   - bpf_load_program;
> >   - btf__get_from_id;

these were added just to bypass the time window when they were not
available in the package, so can be removed now (in the patch below)

>  
> > It's trivial to fix up, but doing it across few trees will delay
> > libbpf work as well.
>  
> > So let's land this through bpf-next, if Arnaldo doesn't mind?
> 
> Yeah, that should be ok, the only consideration is that I'm submitting
> this today to Linus:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/commit/?h=tmp.perf/urgent&id=0ae065a5d265bc5ada13e350015458e0c5e5c351
> 
> To address this:
> 
> https://lore.kernel.org/linux-perf-users/f0add43b-3de5-20c5-22c4-70aff4af959f@scylladb.com/

ok, we can do that via bpf-next, but of course there's a problem ;-)

perf/core already has dependency commit [1]

so either we wait for perf/core and bpf-next/master to sync or:

  - perf/core reverts [1] and
  - bpf-next/master takes [1] and the rest

I have the changes ready if you guys are ok with that

thanks,
jirka
 

[1] https://lore.kernel.org/bpf/20220422100025.1469207-4-jolsa@kernel.org/

---
Subject: [PATCH bpf-next] perf tools: Remove the weak libbpf functions

We added weak functions for some new libbpf functions because
they were not packaged at that time [1].

These functions are now available in package, so we can remove
their weak perf variants.

[1] https://lore.kernel.org/linux-perf-users/20211109140707.1689940-2-jolsa@kernel.org/

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/bpf-event.c | 51 -------------------------------------
 1 file changed, 51 deletions(-)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index 94624733af7e..025f331b3867 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -22,57 +22,6 @@
 #include "record.h"
 #include "util/synthetic-events.h"
 
-struct btf * __weak btf__load_from_kernel_by_id(__u32 id)
-{
-       struct btf *btf;
-#pragma GCC diagnostic push
-#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
-       int err = btf__get_from_id(id, &btf);
-#pragma GCC diagnostic pop
-
-       return err ? ERR_PTR(err) : btf;
-}
-
-int __weak bpf_prog_load(enum bpf_prog_type prog_type,
-			 const char *prog_name __maybe_unused,
-			 const char *license,
-			 const struct bpf_insn *insns, size_t insn_cnt,
-			 const struct bpf_prog_load_opts *opts)
-{
-#pragma GCC diagnostic push
-#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
-	return bpf_load_program(prog_type, insns, insn_cnt, license,
-				opts->kern_version, opts->log_buf, opts->log_size);
-#pragma GCC diagnostic pop
-}
-
-struct bpf_program * __weak
-bpf_object__next_program(const struct bpf_object *obj, struct bpf_program *prev)
-{
-#pragma GCC diagnostic push
-#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
-	return bpf_program__next(prev, obj);
-#pragma GCC diagnostic pop
-}
-
-struct bpf_map * __weak
-bpf_object__next_map(const struct bpf_object *obj, const struct bpf_map *prev)
-{
-#pragma GCC diagnostic push
-#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
-	return bpf_map__next(prev, obj);
-#pragma GCC diagnostic pop
-}
-
-const void * __weak
-btf__raw_data(const struct btf *btf_ro, __u32 *size)
-{
-#pragma GCC diagnostic push
-#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
-	return btf__get_raw_data(btf_ro, size);
-#pragma GCC diagnostic pop
-}
-
 static int snprintf_hex(char *buf, size_t size, unsigned char *data, size_t len)
 {
 	int ret = 0;
-- 
2.35.3

