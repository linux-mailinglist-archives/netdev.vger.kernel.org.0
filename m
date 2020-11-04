Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28442A5CF6
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 04:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730756AbgKDDLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 22:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730745AbgKDDLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 22:11:49 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9E9C061A4D;
        Tue,  3 Nov 2020 19:11:49 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 10so16122778pfp.5;
        Tue, 03 Nov 2020 19:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s2a5ca+P0v9NVAtD18ZymLfGxanpuTFUigNXZ/hD2Xs=;
        b=JLrwyNTOgRA81EIv6a5pArRyb+9+bmoQKyvXfE8WCgseawN/s1SF1V+q14JEB+ggDH
         cXbmKHxDq2amZ4EUx3BpYeFcU6dsEzhRHItqYL7SV6wf0d7B8FUN9ALz+CAw/Xw6Ez2d
         tu39rUmg8zLWUqolhUHbG32eHrPaiyGBlsJjaEIHsbYdMWb68aaxNBQyFamnXQSt+hx3
         pUMWSjpRqZdr4mOVEiEKHEMaXknb+hQ0+hWfKOV3RzXAhnaoIKmFgkK8yZmjItRgD2Q1
         kOoGf0ZADKIvk5Dy+98O0xGPlkKrF+UgQ36fyNBiwXmDn/E84Jfx3ks7vsHx1hUyoYOA
         IWcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s2a5ca+P0v9NVAtD18ZymLfGxanpuTFUigNXZ/hD2Xs=;
        b=ZUogJnswryimGRIZw2Odeian+AAepDZ5/ERuZHl+/8H7GM6uXvI3sLnllTMOlYdqtV
         TZPJELWZQCM7hjbmnsBGjUizyTYBy3I8uibDxgbH983YreQ5Gzvvv4d1gew0XW3VzGym
         q5/q5aoTH3iEcS/neyjCj8kyZRz2IZqGhFh8U6rsgdSpuEfEuOx7iLW+nPqWhGlpMQTM
         4vMiHKubAZMNYxd1LqiM4wUTrGHZMSVLv1ryp0p+LN1wW2g2FnX+luRwnVMTQLSUbDcB
         jtg2D3ojOpX897lxZ2o0B4A3nkMA+hP8dk9M4O7+jUGwVGO/60x8KPNUhJgVQEzo33Cp
         xyug==
X-Gm-Message-State: AOAM530E9Ljm7lRPOCXopHHY6Q60RA/0qiJHdXOf57kKOLrmAakc3TJ8
        /KpelC+h44dVSSiffBIrw0I=
X-Google-Smtp-Source: ABdhPJyB0vzAQwy01BreycUVh/rAferFkRFxPXRZ2XrZ6j3taEGCFOpFaI4bp35FHGsdGwV65THY1w==
X-Received: by 2002:a63:4866:: with SMTP id x38mr14302310pgk.228.1604459508868;
        Tue, 03 Nov 2020 19:11:48 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4055])
        by smtp.gmail.com with ESMTPSA id f5sm338728pgi.86.2020.11.03.19.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 19:11:48 -0800 (PST)
Date:   Tue, 3 Nov 2020 19:11:45 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Hangbin Liu <haliu@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
 <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
 <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
 <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 10:17:30AM +0800, Hangbin Liu wrote:
> On Tue, Nov 03, 2020 at 02:55:54PM -0800, Alexei Starovoitov wrote:
> > > The scope of bpf in iproute2 is tiny - a few tc modules (and VRF but it
> > > does not need libbpf) which is a small subset of the functionality and
> > > commands within the package.
> > 
> > When Hangbin sent this patch set I got excited that finally tc command
> > will start working with the latest bpf elf files.
> > Currently "tc" supports 4 year old files which caused plenty of pain to bpf users.
> > I got excited, but now I've realized that this patch set will make it worse.
> > The bpf support in "tc" command instead of being obviously old and obsolete
> > will be sort-of working with unpredictable delay between released kernel
> > and released iproute2 version. The iproute2 release that suppose to match kernel
> > release will be meaningless.
> > More so, the upgrade of shared libbpf.so can make older iproute2/tc to do 
> > something new and unpredictable.
> > The user experience will be awful. Not only the users won't know
> > what to expect out of 'tc' command they won't have a way to debug it.
> > All of it because iproute2 build will take system libbpf and link it
> > as shared library by default.
> > So I think iproute2 must not use libbpf. If I could remove bpf support
> > from iproute2 I would do so as well.
> > The current state of iproute2 is hurting bpf ecosystem and proposed
> > libbpf+iproute2 integration will make it worse.
> 
> Hi Guys,
> 
> Please take it easy. IMHO, it always very hard to make a perfect solution.
> From development side, it's easier and could get latest features by using
> libbpf as submodule. But we need to take care of users, backward
> compatibility, distros policy etc.
> 
> I like using iproute2 to load bpf objs. But it's not standardized and too old
> to load the new BTF defined objs. I think all of us like to improve it by
> using libbpf. But users and distros are slowly. Some user are still using
> `ifconfig`. Distros have policies to link the shared .so, etc. We have to
> compromise on something.
> 
> Our purpose is to push the user to use new features. As this patchset
> does, push users to try libbpf instead of legacy code. But this need time.

My problem with iproute2 picking random libbpf is unpredictability.
Such roll of dice gives no confidence to users on what is expected to work.
bpf_hello_world.o will load, but that's it.
What is going to work with this or that version of "tc" command? No one knows.
The user will do 'tc -V'. Does version mean anything from bpf loading pov?
It's not. The user will do "ldd `which tc`" and then what?
Such bpf support in "tc" is worse than the current one.
At least the current one is predictably old.

There are alternatives though.
Forking the whole iproute2 because of "tc" is pointless, of course.
My 'proposal' was a fire starter because people are too stubborn to
realize that their long term believes could be incorrect until the fire is burning.
"bpftool prog load" can load any kind of elf. It cannot operate on qdiscs
and shouldn't do qdisc manipulations, but may be we can combine them into pipe
of some sort. Like "bpftool prog load file.o | tc filter ... bpf pipe"
I think that would be better long term. It will be predictable.

When we release new version of libbpf it goes through rigorous testing.
bpftool gets a lot of test coverage as well.
iproute2 with shared libbpf will get nothing. It's the same random roll of dice.
New libbpf may or may not break iproute2. That's awful user experience.
So iproute2 has to use git submodule with particular libbpf sha.
Then libbpf release process can incorporate proper testing of libbpf
and iproute2 combination.
Or iproute2 should stay as-is with obsolete bpf support.

Few years from now the situation could be different and shared libbpf would
be the most appropriate choice. But that day is not today.
