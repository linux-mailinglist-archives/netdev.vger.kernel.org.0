Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAC352D656
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239904AbiESOnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239911AbiESOnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:43:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4914D02A7
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 07:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652971401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=50jb+lr+8bzs9LBIgH+1tS3BRiRPfRl1oUUzkOAyhsQ=;
        b=ilLrZyFcENY94kKatLHTylWzhq1ERH8vBVCSI9moECYpE/lJsq9E30gnOq9L2OXNeK5QE8
        mdkNYpR4CuWFIiBWO9NHjgPVY5+yj7Iud5W12Rg60yR4Tm/8stIbsSgt3sbp20chKRsCqE
        E68yr7Gaix/cpOS/ywuh0lsvizfT/T8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-R9QJfxKaOXWEcSiAtGftmA-1; Thu, 19 May 2022 10:43:17 -0400
X-MC-Unique: R9QJfxKaOXWEcSiAtGftmA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C3F080A0AD;
        Thu, 19 May 2022 14:43:16 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 437942166B25;
        Thu, 19 May 2022 14:43:12 +0000 (UTC)
Date:   Thu, 19 May 2022 16:43:09 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 4/4] bpf_trace: pass array of u64 values in
 kprobe_multi.addrs
Message-ID: <20220519144309.GB22773@asgard.redhat.com>
References: <cover.1652772731.git.esyr@redhat.com>
 <6ef675aeeea442fa8fc168cd1cb4e4e474f65a3f.1652772731.git.esyr@redhat.com>
 <CAEf4BzYNa0F21ydMLvmeGZWzvO_o5Fh0Af0zwWGNxMh6emQTSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYNa0F21ydMLvmeGZWzvO_o5Fh0Af0zwWGNxMh6emQTSg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 04:50:58PM -0700, Andrii Nakryiko wrote:
> On Tue, May 17, 2022 at 12:37 AM Eugene Syromiatnikov <esyr@redhat.com> wrote:
> >
> > With the interface as defined, it is impossible to pass 64-bit kernel
> > addresses from a 32-bit userspace process in BPF_LINK_TYPE_KPROBE_MULTI,
> > which severly limits the useability of the interface, change the ABI
> > to accept an array of u64 values instead of (kernel? user?) longs.
> > Interestingly, the rest of the libbpf infrastructure uses 64-bit values
> > for kallsyms addresses already, so this patch also eliminates
> > the sym_addr cast in tools/lib/bpf/libbpf.c:resolve_kprobe_multi_cb().
> >
> > Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
> > Fixes: 5117c26e877352bc ("libbpf: Add bpf_link_create support for multi kprobes")
> > Fixes: ddc6b04989eb0993 ("libbpf: Add bpf_program__attach_kprobe_multi_opts function")
> > Fixes: f7a11eeccb111854 ("selftests/bpf: Add kprobe_multi attach test")
> > Fixes: 9271a0c7ae7a9147 ("selftests/bpf: Add attach test for bpf_program__attach_kprobe_multi_opts")
> > Fixes: 2c6401c966ae1fbe ("selftests/bpf: Add kprobe_multi bpf_cookie test")
> > Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> > ---
> >  kernel/trace/bpf_trace.c                           | 25 ++++++++++++++++++----
> 
> kernel changes should go into a separate patch

Sure, they can be split, the only reason they are this way is to keep
API/ABI in sync between the kernel code and the user space one.

> (and seems like they
> logically fit together with patch #3, no?)

Patch #3 doesn't change the API/ABI, it only fixes the implementation
in terms of compat handling (and it is more straightforward),
that is why I decided to have it separately. The compat handling
of addrs, on the other hand, can't be fixed without the ABI change.

> >  tools/lib/bpf/bpf.h                                |  2 +-
> >  tools/lib/bpf/libbpf.c                             |  8 +++----
> >  tools/lib/bpf/libbpf.h                             |  2 +-
> >  .../testing/selftests/bpf/prog_tests/bpf_cookie.c  |  2 +-
> >  .../selftests/bpf/prog_tests/kprobe_multi_test.c   |  8 +++----
> >  6 files changed, 32 insertions(+), 15 deletions(-)
> >
> 
> [...]
> 

