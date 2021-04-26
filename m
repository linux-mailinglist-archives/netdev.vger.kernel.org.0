Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6122336B667
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 18:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbhDZQES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 12:04:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20694 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233919AbhDZQEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 12:04:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619453014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F2VQNktxrJFjZNGeAQOvtUIbQ1fYV2wfq5utzj3C6Yw=;
        b=NtL0uRtp58SowZXpdiI3bPsG4ptRxq+hgqX3qAMaY4YiRMvSNJDqZ1NR2Hb2NAlmaJzHFM
        7ZTKfenSogeBOXcVG5ydf6AkjAe36LR6O8j8tz2VSQ3KMUorhEgPHeMM83HwtwX+AvtoOo
        IsY7uYYQQFaHMu+iU8fq1A5+/y8uVXc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455--dDJ8-2eNW6DkZhtWjVrlw-1; Mon, 26 Apr 2021 12:03:30 -0400
X-MC-Unique: -dDJ8-2eNW6DkZhtWjVrlw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62431814337;
        Mon, 26 Apr 2021 16:03:27 +0000 (UTC)
Received: from krava (unknown [10.40.193.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D4E95D9CD;
        Mon, 26 Apr 2021 16:03:19 +0000 (UTC)
Date:   Mon, 26 Apr 2021 18:03:19 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>,
        linux-kernel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: linux-next failing build due to missing cubictcp_state symbol
Message-ID: <YIbkR6z6mxdNSzGO@krava>
References: <20210423130530.GA6564@kitsune.suse.cz>
 <316e86f9-35cc-36b0-1594-00a09631c736@fb.com>
 <20210423175528.GF6564@kitsune.suse.cz>
 <20210425111545.GL15381@kitsune.suse.cz>
 <20210426113215.GM15381@kitsune.suse.cz>
 <20210426121220.GN15381@kitsune.suse.cz>
 <20210426121401.GO15381@kitsune.suse.cz>
 <49f84147-bf32-dc59-48e0-f89241cf6264@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49f84147-bf32-dc59-48e0-f89241cf6264@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 08:41:49AM -0700, Yonghong Song wrote:
> 
> 
> On 4/26/21 5:14 AM, Michal Suchánek wrote:
> > On Mon, Apr 26, 2021 at 02:12:20PM +0200, Michal Suchánek wrote:
> > > On Mon, Apr 26, 2021 at 01:32:15PM +0200, Michal Suchánek wrote:
> > > > On Sun, Apr 25, 2021 at 01:15:45PM +0200, Michal Suchánek wrote:
> > > > > On Fri, Apr 23, 2021 at 07:55:28PM +0200, Michal Suchánek wrote:
> > > > > > On Fri, Apr 23, 2021 at 07:41:29AM -0700, Yonghong Song wrote:
> > > > > > > 
> > > > > > > 
> > > > > > > On 4/23/21 6:05 AM, Michal Suchánek wrote:
> > > > > > > > Hello,
> > > > > > > > 
> > > > > > > > I see this build error in linux-next (config attached).
> > > > > > > > 
> > > > > > > > [ 4939s]   LD      vmlinux
> > > > > > > > [ 4959s]   BTFIDS  vmlinux
> > > > > > > > [ 4959s] FAILED unresolved symbol cubictcp_state
> > > > > > > > [ 4960s] make[1]: ***
> > > > > > > > [/home/abuild/rpmbuild/BUILD/kernel-vanilla-5.12~rc8.next.20210422/linux-5.12-rc8-next-20210422/Makefile:1277:
> > > > > > > > vmlinux] Error 255
> > > > > > > > [ 4960s] make: *** [../Makefile:222: __sub-make] Error 2

this one was reported by Jesper and was fixed by upgrading pahole
that contains the new function generation fixes (v1.19)

> > > > > > > 
> > > > > > > Looks like you have DYNAMIC_FTRACE config option enabled already.
> > > > > > > Could you try a later version of pahole?
> > > > > > 
> > > > > > Is this requireent new?
> > > > > > 
> > > > > > I have pahole 1.20, and master does build without problems.
> > > > > > 
> > > > > > If newer version is needed can a check be added?
> > > > > 
> > > > > With dwarves 1.21 some architectures are fixed and some report other
> > > > > missing symbol. Definitely an improvenent.
> > > > > 
> > > > > I see some new type support was added so it makes sense if that type is
> > > > > used the new dwarves are needed.
> > > > 
> > > > Ok, here is the current failure with dwarves 1.21 on 5.12:
> > > > 
> > > > [ 2548s]   LD      vmlinux
> > > > [ 2557s]   BTFIDS  vmlinux
> > > > [ 2557s] FAILED unresolved symbol vfs_truncate
> > > > [ 2558s] make[1]: ***
> > > > [/home/abuild/rpmbuild/BUILD/kernel-kvmsmall-5.12.0/linux-5.12/Makefile:1213:
> > > > vmlinux] Error 255
> 
> This is PPC64, from attached config:
>   CONFIG_PPC64=y
> I don't have environment to cross-compile for PPC64.
> Jiri, could you take a look? Thanks!

looks like vfs_truncate did not get into BTF data,
I'll try to reproduce

jirka

