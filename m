Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5053D57FC64
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 11:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbiGYJ1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 05:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiGYJ1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 05:27:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 177EC14092
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 02:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658741252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1QVqQ+wSo/PH7nffVgYDKhPQVUQyQA66yhZRbwATq3k=;
        b=MFQQNqQR4emWSPYQ1/zikIBsWbP1lTW51a/7091bpOE+Fg92qX95BckX4L2eNgy3X9bDAG
        PFEOSnPFZTT5G4HtQuLQMSTHekMqN5ra1oMAhqTnWLpF8AkjSo9rsp3FPyywo8eg5tKT9j
        WIGGhvSP8Q2HIuH/HCs51RmKSFc1bxs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-fb8431ylMo-6xzubwJD8BA-1; Mon, 25 Jul 2022 05:27:27 -0400
X-MC-Unique: fb8431ylMo-6xzubwJD8BA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A9E43801F51;
        Mon, 25 Jul 2022 09:27:27 +0000 (UTC)
Received: from samus.usersys.redhat.com (unknown [10.43.17.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8315618EB5;
        Mon, 25 Jul 2022 09:27:25 +0000 (UTC)
Date:   Mon, 25 Jul 2022 11:27:23 +0200
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf-next 1/4] bpf: add BPF_F_DESTRUCTIVE flag for
 BPF_PROG_LOAD
Message-ID: <Yt5h+4pSwbfmdKDu@samus.usersys.redhat.com>
Mail-Followup-To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>, Jiri Olsa <olsajiri@gmail.com>,
        Song Liu <song@kernel.org>
References: <20220720114652.3020467-1-asavkov@redhat.com>
 <20220720114652.3020467-2-asavkov@redhat.com>
 <CAADnVQ+mt1iEsXUGBeL-dgXRoRwPxoz+G=aRcZTkhx2AA10R-A@mail.gmail.com>
 <YtolJfvSGjSSwbc3@sparkplug.usersys.redhat.com>
 <CAADnVQLyCc7reM1By+TYBaNGh1SBpVqyNyT+WJXOooCqX_w2GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQLyCc7reM1By+TYBaNGh1SBpVqyNyT+WJXOooCqX_w2GA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 09:32:51PM -0700, Alexei Starovoitov wrote:
> On Thu, Jul 21, 2022 at 9:18 PM Artem Savkov <asavkov@redhat.com> wrote:
> >
> > On Thu, Jul 21, 2022 at 07:02:07AM -0700, Alexei Starovoitov wrote:
> > > On Wed, Jul 20, 2022 at 4:47 AM Artem Savkov <asavkov@redhat.com> wrote:
> > > >
> > > > +/* If BPF_F_DESTRUCTIVE is used in BPF_PROG_LOAD command, the loaded program
> > > > + * will be able to perform destructive operations such as calling bpf_panic()
> > > > + * helper.
> > > > + */
> > > > +#define BPF_F_DESTRUCTIVE      (1U << 6)
> > >
> > > I don't understand what value this flag provides.
> > >
> > > bpf prog won't be using kexec accidentally.
> > > Requiring user space to also pass this flag seems pointless.
> >
> > bpf program likely won't. But I think it is not uncommon for people to
> > run bpftrace scripts they fetched off the internet to run them without
> > fully reading the code. So the idea was to provide intermediate tools
> > like that with a common way to confirm user's intent without
> > implementing their own guards around dangerous calls.
> > If that is not a good enough of a reason to add the flag I can drop it.
> 
> The intent makes sense, but bpftrace will set the flag silently.
> Since bpftrace compiles the prog it knows what helpers are being
> called, so it will have to pass that extra flag automatically anyway.
> You can argue that bpftrace needs to require a mandatory cmdline flag
> from users to run such scripts, but even if you convince the bpftrace
> community to do that everybody else might just ignore that request.
> Any tool (even libbpf) can scan the insns and provide flags.
> 
> Long ago we added the 'kern_version' field to the prog_load command.
> The intent was to tie bpf prog with kernel version.
> Soon enough people started querying the kernel and put that
> version in there ignoring SEC("version") that bpf prog had.
> It took years to clean that up.
> BPF_F_DESTRUCTIVE flag looks similar to me.
> Good intent, but unlikely to achieve the goal.

Good point, I only thought of those who would like to use this, not the
ones who would try to work around it.

> Do you have other ideas to achieve the goal:
> 'cannot run destructive prog by accident' ?
> 
> If we had an UI it would be a question 'are you sure? please type: yes'.
> 
> I hate to propose the following, since it will delay your patch
> for a long time, but maybe we should only allow signed bpf programs
> to be destructive?

Anything I can think of is likely to be as easily defeated as the flag,
requirement for destructive programs to be signed is not. So I like the
idea. However I think that if bpf program signature checking is disabled
on the system then destructive programs should be able to run with just
CAP_SYS_BOOT. So maybe we can treat everything as this case until we
have the ability to sign bpf programs?

-- 
 Artem

