Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5ED9179A5B
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgCDUpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:45:12 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33308 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728539AbgCDUpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 15:45:11 -0500
Received: by mail-pg1-f196.google.com with SMTP id m5so1566558pgg.0;
        Wed, 04 Mar 2020 12:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=D+6bADF9Hs3thiy/zF3dJiw+mXIemuhVfQAZ47vOfdw=;
        b=hVstzxWyybGWz3WDoicEzPPMPrCa+mGEjhaYpFktChUieQ45zs4wFGJ7rQ9IleJhcj
         aFYMxc1K26Uj7uNazViF+0rwxn+rw9kNBzQ0joxM1HqGxIbj0MG+Jp5OyZ9mAS5+WUDc
         6siW9Nv8QpV/UzHZc3VIJqZdO2YJ2N6mPxJxNIh9Xg9MsXA3dZyLsaNBCQhy2mhfnzkN
         2GkyWSuVUAxf8MzeYRvNf1aIhQRQ9g9nJlJHveZOeNniFuqe/TM7wA82LGfdopWpyPUb
         kVjqn4d2Ep6svuDDDJlfK1IJ0ug3k0umTdjWXzwfluKCdJKzcYKL1j+6yIdwfzp/F8X8
         ljlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=D+6bADF9Hs3thiy/zF3dJiw+mXIemuhVfQAZ47vOfdw=;
        b=Bnl7/cK+Tuzti7cb+o3E4SRwjvEFTe940RWmEFUJiQ8wwxMal0SCT8++21gmoSuU4R
         2CmZHJb/gtzi0tatXaVB+Kv+YwchTEwMvUnXnG3tfHBvUA7ooDCXIgtd2aIpdDKQJ76Y
         LfHU1cM6ODToqaLUfMLrdEjsYBTiMZwFD1Sa/bfCtC/++FXgMemx89a0+rlqwfFPUuhB
         je6KOn7dsEZuWi/0YC9f7YbcYh3Ocs5xOAr6BCmtUoG7JCNPScFCfKQSwrzFebKTyYSN
         vvYI/GvdRZUhgG5DgjWqKyBJWoJtQbhskiw3EzRzOipmUwANlWc1U4qKs6n3NdrJhWK0
         yqZg==
X-Gm-Message-State: ANhLgQ3FbQS9RgvxitEJmdLiVvmcNxmhP6ouqwT2arQqH4J2i2OukSak
        Eq/ylLpxK3o8OmgMNQQjGwA=
X-Google-Smtp-Source: ADFU+vtTZWcPvzYtIL3k1XY/66/vyaU4dGoiQ6+JuXEayICU35mEp5m11MwwCi/z571xyToObmGyww==
X-Received: by 2002:aa7:87d4:: with SMTP id i20mr4658708pfo.22.1583354710419;
        Wed, 04 Mar 2020 12:45:10 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::4:c694])
        by smtp.gmail.com with ESMTPSA id m18sm19981017pff.7.2020.03.04.12.45.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Mar 2020 12:45:09 -0800 (PST)
Date:   Wed, 4 Mar 2020 12:45:07 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel
 abstraction
Message-ID: <20200304204506.wli3enu5w25b35h7@ast-mbp>
References: <094a8c0f-d781-d2a2-d4cd-721b20d75edd@iogearbox.net>
 <e9a4351a-4cf9-120a-1ae1-94a707a6217f@fb.com>
 <8083c916-ac2c-8ce0-2286-4ea40578c47f@iogearbox.net>
 <CAEf4BzbokCJN33Nw_kg82sO=xppXnKWEncGTWCTB9vGCmLB6pw@mail.gmail.com>
 <87pndt4268.fsf@toke.dk>
 <ab2f98f6-c712-d8a2-1fd3-b39abbaa9f64@iogearbox.net>
 <ccbc1e49-45c1-858b-1ad5-ee503e0497f2@fb.com>
 <87k1413whq.fsf@toke.dk>
 <20200304043643.nqd2kzvabkrzlolh@ast-mbp>
 <20200304114000.56888dac@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304114000.56888dac@kicinski-fedora-PC1C0HJN>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 11:41:58AM -0800, Jakub Kicinski wrote:
> On Tue, 3 Mar 2020 20:36:45 -0800 Alexei Starovoitov wrote:
> > > > libxdp can choose to pin it in some libxdp specific location, so other
> > > > libxdp-enabled applications can find it in the same location, detach,
> > > > replace, modify, but random app that wants to hack an xdp prog won't
> > > > be able to mess with it.  
> > > 
> > > What if that "random app" comes first, and keeps holding on to the link
> > > fd? Then the admin essentially has to start killing processes until they
> > > find the one that has the device locked, no?  
> > 
> > Of course not. We have to provide an api to make it easy to discover
> > what process holds that link and where it's pinned.
> 
> That API to discover ownership would be useful but it's on the BPF side.

it's on bpf side because it's bpf specific.

> We have netlink notifications in networking world. The application
> which doesn't want its program replaced should simply listen to the
> netlink notifications and act if something goes wrong.

instead of locking the bike let's setup a camera and monitor the bike
when somebody steals it.
and then what? chase the thief and bring the bike back?

> > But if we go with notifier approach none of it is an issue.
> 
> Sorry, what's the notifier approach? You mean netdev notifier chain 
> or something new?

that's tbd.

> > Whether target obj is held or notifier is used everything I said before still
> > stands. "random app" that uses netlink after libdispatcher got its link FD will
> > not be able to mess with carefully orchestrated setup done by libdispatcher.
> > 
> > Also either approach will guarantee that infamous message:
> > "unregister_netdevice: waiting for %s to become free. Usage count"
> > users will never see.
> >
> > > And what about the case where the link fd is pinned on a bpffs that is
> > > no longer available? I.e., if a netdevice with an XDP program moves
> > > namespaces and no longer has access to the original bpffs, that XDP
> > > program would essentially become immutable?  
> > 
> > 'immutable' will not be possible.
> > I'm not clear to me how bpffs is going to disappear. What do you mean
> > exactly?
> > 
> > > > We didn't come up with these design choices overnight. It came from
> > > > hard lessons learned while deploying xdp, tc and cgroup in production.
> > > > Legacy apis will not be deprecated, of course.  
> 
> This sounds like a version of devm_* helpers for configuration.
> Why are current user space APIs insufficient? 

current xdp, tc, cgroup apis don't have the concept of the link
and owner of that link.

> Surely all of this can 
> be done from user space.

with a camera for theft monitoring. that will work well.

> And we will need a centralized daemon for XDP
> dispatch, so why is it not a part of a daemon?

current design of libdispatcher doesn't need the deamon.
