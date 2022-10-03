Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF92E5F28DA
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 08:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiJCG4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 02:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiJCG4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 02:56:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EBDA1B6
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 23:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664780190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8ZBicwUKsvtaRkaZY3oUqaPDULjldiOgTy47Jjj1bT4=;
        b=RObIm19SY/cYBNgrS28as/iZO1tEfvVdTte7u7Y0Pn7MxVOllcxkbEAfoQqGmGEgL70gF9
        RcaYbtXWkn6zWQgp3OOzSku46hmgSneWvgoUP3BkdVoUU08DAznHhf2b5K9nIdLvMvukOT
        LNlvs0DiNjpFvCmz8LhMhuBLRlksKME=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-7Gjv7yeBOTuEh7uYyEfOEg-1; Mon, 03 Oct 2022 02:56:27 -0400
X-MC-Unique: 7Gjv7yeBOTuEh7uYyEfOEg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2404F3C025C3;
        Mon,  3 Oct 2022 06:56:27 +0000 (UTC)
Received: from samus.usersys.redhat.com (unknown [10.43.17.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DBB452166B26;
        Mon,  3 Oct 2022 06:56:25 +0000 (UTC)
Date:   Mon, 3 Oct 2022 08:56:24 +0200
From:   Artem Savkov <asavkov@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbenc@redhat.com
Subject: Re: [PATCH bpf-next] selftests/bpf: make libbpf_probe_prog_types
 testcase aware of kernel configuration
Message-ID: <YzqHmHRjxAc4Nndc@samus.usersys.redhat.com>
Mail-Followup-To: Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbenc@redhat.com
References: <20220930110900.75492-1-asavkov@redhat.com>
 <CAEf4BzZpkgXi9Y6x-_-6mDDW12GvTj0Y_e7cpQMqF3dtiBBhpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAEf4BzZpkgXi9Y6x-_-6mDDW12GvTj0Y_e7cpQMqF3dtiBBhpA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 04:06:41PM -0700, Andrii Nakryiko wrote:
> On Fri, Sep 30, 2022 at 4:09 AM Artem Savkov <asavkov@redhat.com> wrote:
> >
> > At the moment libbpf_probe_prog_types test iterates over all available
> > BPF_PROG_TYPE regardless of kernel configuration which can exclude some
> > of those. Unfortunately there is no direct way to tell which types are
> > available, but we can look at struct bpf_ctx_onvert to tell which ones
> > are available.
> >
> > Signed-off-by: Artem Savkov <asavkov@redhat.com>
> > ---
> 
> Many selftests assume correct kernel configuration which is encoded in
> config and config.<arch> files. So it seems fair to assume that all
> defined program types are available on kernel-under-test.

Ok. Wasn't sure if this is the assumption being made.

> If someone is running selftests under custom more minimal kernel they
> can use denylist to ignore specific prog type subtests?

Thanks for the suggestion. Denylist is a bit too broad in this case as
it means we'll be disabling the whole libbpf_probe_prog_types test while
only a single type is a problem. Looks like we'll have to live with a
downstream-only patch in this case.

-- 
 Artem

