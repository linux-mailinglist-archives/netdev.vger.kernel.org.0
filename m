Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96100319FF7
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 14:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhBLNhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 08:37:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58120 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230228AbhBLNgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 08:36:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613136929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1jHhLaAcfBJzCxQfHqIyt8BMsidiqhhT7lJSyine56A=;
        b=cUq2utq53ifSG8/ZgOP5GIBOXDYrCbiMIIybgbxoE9zQFVdCmvq8NtiTBc8tG9kdPo0f3/
        g5iBV9S+HD5gMn4OLPtAx6zeqBOf6lNWXxKEjK0AKour1EFWIttOmjwnZ9vq85dYtcCqP0
        b+zo2JX7d+oZmZgeylsB5qoDMLnFKKk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-UuitoUt1PK-9I8akoSXVmw-1; Fri, 12 Feb 2021 08:35:25 -0500
X-MC-Unique: UuitoUt1PK-9I8akoSXVmw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 150E4835E3B;
        Fri, 12 Feb 2021 13:35:23 +0000 (UTC)
Received: from krava (unknown [10.40.193.141])
        by smtp.corp.redhat.com (Postfix) with SMTP id 90C1319CB6;
        Fri, 12 Feb 2021 13:35:19 +0000 (UTC)
Date:   Fri, 12 Feb 2021 14:35:18 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH bpf-next 4/4] kbuild: Add resolve_btfids clean to root
 clean target
Message-ID: <YCaEFgWgNArKfCkQ@krava>
References: <20210205124020.683286-1-jolsa@kernel.org>
 <20210205124020.683286-5-jolsa@kernel.org>
 <20210210174451.GA1943051@ubuntu-m3-large-x86>
 <CAEf4BzZvz4-STv3OQxyNDiFKkrFM-+GOM-yXURzoDtXiRiuT_g@mail.gmail.com>
 <20210210180215.GA2374611@ubuntu-m3-large-x86>
 <YCQmCwBSQuj+bi4q@krava>
 <CAEf4BzbwwtqerxRrNZ75WLd2aHLdnr7wUrKahfT7_6bjBgJ0xQ@mail.gmail.com>
 <YCUgUlCDGTS85MCO@krava>
 <CAK7LNAT8oTvLJ9FRsrRB5GUS2K+y2QY36Wshb9x1YE5d=ZyA5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNAT8oTvLJ9FRsrRB5GUS2K+y2QY36Wshb9x1YE5d=ZyA5g@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 12:30:45PM +0900, Masahiro Yamada wrote:

SNIP

> 
> I expected this kind of mess
> when I saw 33a57ce0a54d498275f432db04850001175dfdfa
> 
> 
> The tools/ directory is a completely different world
> governed by a different build system
> (no, not a build system, but a collection of adhoc makefile code)
> 
> 
> All the other programs used during the kernel build
> are located under scripts/, and can be built with
> a simple syntax, and cleaned up correctly.
> It is simple, clean and robust.
> 
> objtool is the first alien that opt out Kbuild,
> and this is the second one.
> 
> 
> It is scary to mix up two different things,
> which run in different working directories.

would you see any way out? apart from changing resolve_btfids
to use Kbuild.. there are some dependencies we'd need to change
as well and they are used by other tools.. probably it'd end up
with all or nothing scenario

> 
> See, this is wired up in the top Makefile
> in an ugly way, and you are struggling
> in suppressing issues, where you can never
> do it in the right way.

maybe we could move it out of top makefile into separate one,
that would handle all the related mess

jirka

