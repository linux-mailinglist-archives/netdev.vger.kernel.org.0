Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB40836C5DE
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 14:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236075AbhD0MNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 08:13:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:43256 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235410AbhD0MNY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 08:13:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DBDD8B18F;
        Tue, 27 Apr 2021 12:12:39 +0000 (UTC)
Date:   Tue, 27 Apr 2021 14:12:37 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>, linux-kernel@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
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
Message-ID: <20210427121237.GK6564@kitsune.suse.cz>
References: <20210423130530.GA6564@kitsune.suse.cz>
 <316e86f9-35cc-36b0-1594-00a09631c736@fb.com>
 <20210423175528.GF6564@kitsune.suse.cz>
 <20210425111545.GL15381@kitsune.suse.cz>
 <20210426113215.GM15381@kitsune.suse.cz>
 <20210426121220.GN15381@kitsune.suse.cz>
 <20210426121401.GO15381@kitsune.suse.cz>
 <49f84147-bf32-dc59-48e0-f89241cf6264@fb.com>
 <YIbkR6z6mxdNSzGO@krava>
 <YIcRlHQWWKbOlcXr@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YIcRlHQWWKbOlcXr@krava>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 09:16:36PM +0200, Jiri Olsa wrote:
> On Mon, Apr 26, 2021 at 06:03:19PM +0200, Jiri Olsa wrote:
> > On Mon, Apr 26, 2021 at 08:41:49AM -0700, Yonghong Song wrote:
> > > 
> > > 
> > > On 4/26/21 5:14 AM, Michal Suchánek wrote:
> > > > On Mon, Apr 26, 2021 at 02:12:20PM +0200, Michal Suchánek wrote:
> > > > > On Mon, Apr 26, 2021 at 01:32:15PM +0200, Michal Suchánek wrote:
> > > > > > On Sun, Apr 25, 2021 at 01:15:45PM +0200, Michal Suchánek wrote:
> > > > > > > On Fri, Apr 23, 2021 at 07:55:28PM +0200, Michal Suchánek wrote:
> > > > > > > > On Fri, Apr 23, 2021 at 07:41:29AM -0700, Yonghong Song wrote:
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > On 4/23/21 6:05 AM, Michal Suchánek wrote:
> > > > > > > > > > Hello,
> > > > > > > > > > 
> > > > > > > > > > I see this build error in linux-next (config attached).
> > > > > > > > > > 
> > > > > > > > > > [ 4939s]   LD      vmlinux
> > > > > > > > > > [ 4959s]   BTFIDS  vmlinux
> > > > > > > > > > [ 4959s] FAILED unresolved symbol cubictcp_state
> > > > > > > > > > [ 4960s] make[1]: ***
> > > > > > > > > > [/home/abuild/rpmbuild/BUILD/kernel-vanilla-5.12~rc8.next.20210422/linux-5.12-rc8-next-20210422/Makefile:1277:
> > > > > > > > > > vmlinux] Error 255
> > > > > > > > > > [ 4960s] make: *** [../Makefile:222: __sub-make] Error 2
> > 
> > this one was reported by Jesper and was fixed by upgrading pahole
> > that contains the new function generation fixes (v1.19)
> > 
> > > > > > > > > 
> > > > > > > > > Looks like you have DYNAMIC_FTRACE config option enabled already.
> > > > > > > > > Could you try a later version of pahole?
> > > > > > > > 
> > > > > > > > Is this requireent new?
> > > > > > > > 
> > > > > > > > I have pahole 1.20, and master does build without problems.
> > > > > > > > 
> > > > > > > > If newer version is needed can a check be added?
> > > > > > > 
> > > > > > > With dwarves 1.21 some architectures are fixed and some report other
> > > > > > > missing symbol. Definitely an improvenent.
> > > > > > > 
> > > > > > > I see some new type support was added so it makes sense if that type is
> > > > > > > used the new dwarves are needed.
> > > > > > 
> > > > > > Ok, here is the current failure with dwarves 1.21 on 5.12:
> > > > > > 
> > > > > > [ 2548s]   LD      vmlinux
> > > > > > [ 2557s]   BTFIDS  vmlinux
> > > > > > [ 2557s] FAILED unresolved symbol vfs_truncate
> > > > > > [ 2558s] make[1]: ***
> > > > > > [/home/abuild/rpmbuild/BUILD/kernel-kvmsmall-5.12.0/linux-5.12/Makefile:1213:
> > > > > > vmlinux] Error 255
> > > 
> > > This is PPC64, from attached config:
> > >   CONFIG_PPC64=y
> > > I don't have environment to cross-compile for PPC64.
> > > Jiri, could you take a look? Thanks!
> > 
> > looks like vfs_truncate did not get into BTF data,
> > I'll try to reproduce
> 
> I can't reproduce the problem, in both cross build and native ppc,
> but the .config attached does not see complete, could you pelase
> resend?

I can't reproduce outside of the build service either. There is probably
some other tool missing that is commonly available and there is no check
for it.

Thanks

Michal
