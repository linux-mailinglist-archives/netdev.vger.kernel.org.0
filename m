Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D86189AB40
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 11:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbfHWJW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 05:22:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52796 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728247AbfHWJW5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 05:22:57 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 788C88D5BB8;
        Fri, 23 Aug 2019 09:22:56 +0000 (UTC)
Received: from krava (unknown [10.43.17.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63ADD4526;
        Fri, 23 Aug 2019 09:22:54 +0000 (UTC)
Date:   Fri, 23 Aug 2019 11:22:53 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Julia Kartseva <hex@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: libbpf distro packaging
Message-ID: <20190823092253.GA20775@krava>
References: <3FBEC3F8-5C3C-40F9-AF6E-C355D8F62722@fb.com>
 <20190813122420.GB9349@krava>
 <CAEf4BzbG29eAL7gUV+Vyrrft4u4Ss8ZBC6RMixJL_CYOTQ+F2w@mail.gmail.com>
 <FA139BA4-59E5-43C7-8E72-C7B2FC1C449E@fb.com>
 <A770810D-591E-4292-AEFA-563724B6D6CB@fb.com>
 <20190821210906.GA31031@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190821210906.GA31031@krava>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Fri, 23 Aug 2019 09:22:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 11:09:06PM +0200, Jiri Olsa wrote:
> On Tue, Aug 20, 2019 at 10:27:23PM +0000, Julia Kartseva wrote:
> > 
> > 
> > ﻿On 8/19/19, 11:08 AM, "Julia Kartseva" <hex@fb.com> wrote:
> > 
> >     On 8/13/19, 11:24 AM, "Andrii Nakryiko" <andrii.nakryiko@gmail.com> wrote:
> >     
> >         On Tue, Aug 13, 2019 at 5:26 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >         >
> >         > On Mon, Aug 12, 2019 at 07:04:12PM +0000, Julia Kartseva wrote:
> >         > > I would like to bring up libbpf publishing discussion started at [1].
> >         > > The present state of things is that libbpf is built from kernel tree, e.g. [2]
> >         > > For Debian and [3] for Fedora whereas the better way would be having a
> >         > > package built from github mirror. The advantages of the latter:
> >         > > - Consistent, ABI matching versioning across distros
> >         > > - The mirror has integration tests
> >         > > - No need in kernel tree to build a package
> >         > > - Changes can be merged directly to github w/o waiting them to be merged
> >         > > through bpf-next -> net-next -> main
> >         > > There is a PR introducing a libbpf.spec which can be used as a starting point: [4]
> >         > > Any comments regarding the spec itself can be posted there.
> >         > > In the future it may be used as a source of truth.
> >         > > Please consider switching libbpf packaging to the github mirror instead
> >         > > of the kernel tree.
> >         > > Thanks
> >         > >
> >         > > [1] https://urldefense.proofpoint.com/v2/url?u=https-3A__lists.iovisor.org_g_iovisor-2Ddev_message_1521&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=zUrDY_Sp_5PqcGtRQPNeDA&m=prYVDiu3-aH1o2PWH4ZcP7lEQRCQAcTwcWPrJrtaroQ&s=dYAc2jLhFg0wtCZ_ms2HF5bWANoHzA3UMug5TNCeBtE&e= 
> >         > > [2] https://urldefense.proofpoint.com/v2/url?u=https-3A__packages.debian.org_sid_libbpf4.19&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=zUrDY_Sp_5PqcGtRQPNeDA&m=prYVDiu3-aH1o2PWH4ZcP7lEQRCQAcTwcWPrJrtaroQ&s=lq1MpF-bt6y6ZEtFc57eT-BO_wMBx8uUBACJooWbUYk&e= 
> >         > > [3] https://urldefense.proofpoint.com/v2/url?u=http-3A__rpmfind.net_linux_RPM_fedora_devel_rawhide_x86-5F64_l_libbpf-2D5.3.0-2D0.rc2.git0.1.fc31.x86-5F64.html&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=zUrDY_Sp_5PqcGtRQPNeDA&m=prYVDiu3-aH1o2PWH4ZcP7lEQRCQAcTwcWPrJrtaroQ&s=NoolYHL57G2KhzE768iWdy6v5LD2GfJQyqPmtjy196E&e= 
> >         > > [4] https://github.com/libbpf/libbpf/pull/64
> >         >
> >         > hi,
> >         > Fedora has libbpf as kernel-tools subpackage, so I think
> >         > we'd need to create new package and deprecate the current
> >         >
> >         > but I like the ABI stability by using github .. how's actually
> >         > the sync (in both directions) with kernel sources going on?
> >         
> >         Sync is always in one direction, from kernel sources into Github repo.
> >         Right now it's triggered by a human (usually me), but we are using a
> >         script that automates entire process (see
> >         https://github.com/libbpf/libbpf/blob/master/scripts/sync-kernel.sh).
> >         It cherry-pick relevant commits from kernel, transforms them to match
> >         Github's file layout and re-applies those changes to Github repo.
> >         
> >         There is never a sync from Github back to kernel, but Github repo
> >         contains some extra stuff that's not in kernel. E.g., the script I
> >         mentioned, plus Github's Makefile is different, because it can't rely
> >         on kernel's kbuild setup.
> > 
> > Hi Jiri,
> > I'm curious if you have any comments regarding sync procedure described
> > By Andrii. Or if there is anything else you'd like us to address so Fedora
> > can be switched to libbpf built from the github mirror?
> 
> hi,
> yea, I think it's ok.. just need to check the implications
> for rhel packaging and I'll let you know

btw, the libbpf GH repo tag v0.0.4 has 0.0.3 version set in Makefile:

  VERSION = 0
  PATCHLEVEL = 0
  EXTRAVERSION = 3

current code takes version from libbpf.map so it's fine,
but would be great to start from 0.0.5 so we don't need to
bother with rpm patches.. is 0.0.5 planned soon?

thanks,
jirka
