Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2394C334BBE
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 23:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbhCJWnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 17:43:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26332 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233498AbhCJWmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 17:42:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615416174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zZUIxQMuHfM2ZGFCSPdMxrKfMjQr1/7Fk1M57+SSlMY=;
        b=Vt5jVhxZibXnaYh/q2KS5nSXFpiQmIiEDEzrojaDEuF+Ebme5tbY+8Sp8MTHQxMwSK+qg6
        rlsL6Fr+SBX4ChDsy+N2rB15IT5heCvP2ZfQgtJpqnMbQ+FMnPWzCkly8dOllAfqlTbMVL
        BB+wuQsW+l61d+0TZTX2wnLh7FK95T0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-kJGkAKZbO4q5nzZz_s0F4Q-1; Wed, 10 Mar 2021 17:42:51 -0500
X-MC-Unique: kJGkAKZbO4q5nzZz_s0F4Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 409C21084C97;
        Wed, 10 Mar 2021 22:42:48 +0000 (UTC)
Received: from krava (unknown [10.40.195.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A45B50D0D;
        Wed, 10 Mar 2021 22:42:44 +0000 (UTC)
Date:   Wed, 10 Mar 2021 23:42:43 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Viktor =?iso-8859-1?Q?J=E4gersk=FCpper?= 
        <viktor_jaegerskuepper@freenet.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] tools/resolve_btfids: Build libbpf and
 libsubcmd in separate directories
Message-ID: <YElLY7Ht7NNTmoWB@krava>
References: <20210205124020.683286-1-jolsa@kernel.org>
 <20210205124020.683286-2-jolsa@kernel.org>
 <5a48579b-9aff-72a5-7b25-accb40c4dd52@freenet.de>
 <CAEf4BzYYG=3ZEu70CV0t0+T583082=FcytCv=jg2b83QaqyQRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzYYG=3ZEu70CV0t0+T583082=FcytCv=jg2b83QaqyQRA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 11:27:19AM -0800, Andrii Nakryiko wrote:
> On Wed, Mar 10, 2021 at 9:35 AM Viktor Jägersküpper
> <viktor_jaegerskuepper@freenet.de> wrote:
> >
> > Hi,
> >
> > > Setting up separate build directories for libbpf and libpsubcmd,
> > > so it's separated from other objects and we don't get them mixed
> > > in the future.
> > >
> > > It also simplifies cleaning, which is now simple rm -rf.
> > >
> > > Also there's no need for FEATURE-DUMP.libbpf and bpf_helper_defs.h
> > > files in .gitignore anymore.
> > >
> > > Acked-by: Song Liu <songliubraving@fb.com>
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> >
> > when I invoke 'git status' on the master branch of my local git repository
> > (cloned from stable/linux.git), which I have used to compile several kernels,
> > it lists two untracked files:
> >
> >         tools/bpf/resolve_btfids/FEATURE-DUMP.libbpf
> >         tools/bpf/resolve_btfids/bpf_helper_defs.h
> >
> > 'git status' doesn't complain about these files with v5.11, and I can't get rid
> > of them by 'make clean' with v5.11 or v5.12-rc1/rc2. So I used 'git bisect' and
> > found that this is caused by commit fc6b48f692f89cc48bfb7fd1aa65454dfe9b2d77,
> > which links to this thread.
> >
> > Looking at the diff it's obvious because of the change in the .gitignore file,
> > but I don't know why these files are there and I have never touched anything in
> > the 'tools' directory.
> >
> > Can I savely delete the files? Do I even have to delete them before I compile
> > v5.12-rcX?
> 
> yes, those were auto-generated files. You can safely remove them.

hm, I answered this email, but for some reason I can't see it on
lore.. FWIW, trying once more ;-)


hi,
yes, you can delete them, this patch moved libbpf and libsubcmd
into their own build directories, so those 2 files stayed there
from your last build without the patch

jirka

