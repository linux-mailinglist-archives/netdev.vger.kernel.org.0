Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6EC5F619B
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 09:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiJFH1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 03:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiJFH1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 03:27:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164367F111
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 00:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665041228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rBenCr/sddYb9hESJpfA+ABk7j5KAPKQpHD+BrNJZy8=;
        b=NngqyOiSOaoo0esoT1zmlW3bwbAWvSr9XIe1lhomWmsCyrQs5AUF5mcjCQMQgKKbaOS1xO
        l9LJfS/do3KAodVmCHKXLj+8GoRpjS+InC0VlXl8lNQOpKqptoI94OKcUudG6gzYkElu9n
        QOLLT4bYvrLNv4n6eO/8vCnRsHIt3iA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-wYbxRUKcMDGrqZYky-yHUw-1; Thu, 06 Oct 2022 03:27:05 -0400
X-MC-Unique: wYbxRUKcMDGrqZYky-yHUw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9AC7862FDC;
        Thu,  6 Oct 2022 07:27:04 +0000 (UTC)
Received: from samus.usersys.redhat.com (unknown [10.43.17.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A936239DB3;
        Thu,  6 Oct 2022 07:27:03 +0000 (UTC)
Date:   Thu, 6 Oct 2022 09:27:01 +0200
From:   Artem Savkov <asavkov@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbenc@redhat.com
Subject: Re: [PATCH bpf-next] selftests/bpf: make libbpf_probe_prog_types
 testcase aware of kernel configuration
Message-ID: <Yz6DRTvnblwUR7dV@samus.usersys.redhat.com>
Mail-Followup-To: Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbenc@redhat.com
References: <20220930110900.75492-1-asavkov@redhat.com>
 <CAEf4BzZpkgXi9Y6x-_-6mDDW12GvTj0Y_e7cpQMqF3dtiBBhpA@mail.gmail.com>
 <YzqHmHRjxAc4Nndc@samus.usersys.redhat.com>
 <CAEf4BzZaGvXM7Vquc=SEM3-cD=s_gfX1jadm4TsGxHnsLG4daw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAEf4BzZaGvXM7Vquc=SEM3-cD=s_gfX1jadm4TsGxHnsLG4daw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 05:03:18PM -0700, Andrii Nakryiko wrote:
> On Sun, Oct 2, 2022 at 11:56 PM Artem Savkov <asavkov@redhat.com> wrote:
> >
> > On Fri, Sep 30, 2022 at 04:06:41PM -0700, Andrii Nakryiko wrote:
> > > On Fri, Sep 30, 2022 at 4:09 AM Artem Savkov <asavkov@redhat.com> wrote:
> > > >
> > > > At the moment libbpf_probe_prog_types test iterates over all available
> > > > BPF_PROG_TYPE regardless of kernel configuration which can exclude some
> > > > of those. Unfortunately there is no direct way to tell which types are
> > > > available, but we can look at struct bpf_ctx_onvert to tell which ones
> > > > are available.
> > > >
> > > > Signed-off-by: Artem Savkov <asavkov@redhat.com>
> > > > ---
> > >
> > > Many selftests assume correct kernel configuration which is encoded in
> > > config and config.<arch> files. So it seems fair to assume that all
> > > defined program types are available on kernel-under-test.
> >
> > Ok. Wasn't sure if this is the assumption being made.
> >
> > > If someone is running selftests under custom more minimal kernel they
> > > can use denylist to ignore specific prog type subtests?
> >
> > Thanks for the suggestion. Denylist is a bit too broad in this case as
> > it means we'll be disabling the whole libbpf_probe_prog_types test while
> > only a single type is a problem. Looks like we'll have to live with a
> > downstream-only patch in this case.
> 
> Allow/deny lists allow to specify subtests as well, so you can have
> very granular control. E.g.,
> 
> [vmuser@archvm bpf]$ sudo ./test_progs -a 'libbpf_probe_prog_types/*SK*'
> Failed to load bpf_testmod.ko into the kernel: -22
> WARNING! Selftests relying on bpf_testmod.ko will be skipped.
> #96/8    libbpf_probe_prog_types/BPF_PROG_TYPE_CGROUP_SKB:OK
> #96/14   libbpf_probe_prog_types/BPF_PROG_TYPE_SK_SKB:OK
> #96/16   libbpf_probe_prog_types/BPF_PROG_TYPE_SK_MSG:OK
> #96/21   libbpf_probe_prog_types/BPF_PROG_TYPE_SK_REUSEPORT:OK
> #96/30   libbpf_probe_prog_types/BPF_PROG_TYPE_SK_LOOKUP:OK
> #96      libbpf_probe_prog_types:OK
> Summary: 1/5 PASSED, 0 SKIPPED, 0 FAILED
> 
> 
> As you can see each program type is a subtest, so you can pick and
> choose which ones to run.

Right, didn't know it can do that. Thanks for the pointer.

-- 
 Artem

