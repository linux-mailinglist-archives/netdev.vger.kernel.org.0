Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4AD0D2644
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387574AbfJJJ0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 05:26:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48506 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbfJJJ0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 05:26:54 -0400
Received: from [193.96.224.244] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iIUif-0005xu-US; Thu, 10 Oct 2019 09:26:50 +0000
Date:   Thu, 10 Oct 2019 11:26:48 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] bpf: switch to new usercopy helpers
Message-ID: <20191010092647.cpxh7neqgabq36gt@wittgenstein>
References: <20191009160907.10981-1-christian.brauner@ubuntu.com>
 <CAADnVQJxUwD3u+tK1xsU2thpRWiAbERGx8mMoXKOCfNZrETMuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQJxUwD3u+tK1xsU2thpRWiAbERGx8mMoXKOCfNZrETMuw@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 04:06:18PM -0700, Alexei Starovoitov wrote:
> On Wed, Oct 9, 2019 at 9:09 AM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > Hey everyone,
> >
> > In v5.4-rc2 we added two new helpers check_zeroed_user() and
> > copy_struct_from_user() including selftests (cf. [1]). It is a generic
> > interface designed to copy a struct from userspace. The helpers will be
> > especially useful for structs versioned by size of which we have quite a
> > few.
> >
> > The most obvious benefit is that this helper lets us get rid of
> > duplicate code. We've already switched over sched_setattr(), perf_event_open(),
> > and clone3(). More importantly it will also help to ensure that users
> > implementing versioning-by-size end up with the same core semantics.
> >
> > This point is especially crucial since we have at least one case where
> > versioning-by-size is used but with slighly different semantics:
> > sched_setattr(), perf_event_open(), and clone3() all do do similar
> > checks to copy_struct_from_user() while rt_sigprocmask(2) always rejects
> > differently-sized struct arguments.
> >
> > This little series switches over bpf codepaths that have hand-rolled
> > implementations of these helpers.
> 
> check_zeroed_user() is not in bpf-next.
> we will let this set sit in patchworks for some time until bpf-next
> is merged back into net-next and we fast forward it.
> Then we can apply it (assuming no conflicts).

Sounds good to me. Just ping me when you need me to resend rebase onto
bpf-next.

Christian
