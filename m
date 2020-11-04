Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40CF2A5CA4
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 03:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730589AbgKDCRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 21:17:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51852 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730431AbgKDCRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 21:17:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604456266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YzFdOT4sSy+gtRGqNJYIbR08zdA8+yJn9WFrFMBKz9Y=;
        b=RXn5MQ5k3taks6nrDmfoB4i9MAokio1oVF2UFwzKNlUCSiQZbaBi2w+M0M36L98Htg1pCj
        Jpvxe+zOBXjY0lqzpT2kmcNhVaOcIaDh5CZMvrZyQkEZmxaX9NWFucYfIUiDI9VlHvLds3
        9p+8mOheVjWWd82y7Ezhgaxkdwy7+yU=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-aFAugxN-P7a_qJH7l0_fHA-1; Tue, 03 Nov 2020 21:17:44 -0500
X-MC-Unique: aFAugxN-P7a_qJH7l0_fHA-1
Received: by mail-pf1-f199.google.com with SMTP id 64so13673255pfg.9
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 18:17:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YzFdOT4sSy+gtRGqNJYIbR08zdA8+yJn9WFrFMBKz9Y=;
        b=KrRJry/vC1WGr1AoKqYaFzIoWy7f7ux/q2/bgqqN1Ijwp9IIxvvl3VtgcS9RCQWyal
         u5Msbi2rkqEjmyEXGctUkm1LM6AvX7SvJaYXyUeV+v5PMCAhIsU5XHLxZe028bBoMBsf
         tppho+mP3emf/WhyTqnJ1VzYUVYH7AwcybkHIWuT+1Usugl0wMlE0i7VJAHbBBuHgG1f
         HudwiIPMYa/Sqiiz1ncTLPaurK12CY/kA+xIB/G3GMMv8a7R5nH1tfG8EpC5uNEiFMrc
         81+va3vUUmUUuULjEfoAPyBwSkdf1nbWt53OsCrk/UV3yEYPU0UQK9TNulq0D/AJe3H1
         aS1g==
X-Gm-Message-State: AOAM532cRU6SMHnpaVkMl9MQCuw/ke31f31HvMsyxyylJsfVoI60QKRk
        A9l9hWZtTTMloc2pbvRieW35tT8AIX66K92HFB7ZBtvPLNJBQ+zA3fZC23/SiGgZVo84yk1FqK3
        qSlHOQLroNdfGTxI=
X-Received: by 2002:a17:90b:f85:: with SMTP id ft5mr2258888pjb.86.1604456263725;
        Tue, 03 Nov 2020 18:17:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxs8Oa/blLWguavogwFehe51SmCSeyMC8revx+N56HvetA+wUvqzMbck15mQ3ugMhG+tEAbMg==
X-Received: by 2002:a17:90b:f85:: with SMTP id ft5mr2258869pjb.86.1604456263431;
        Tue, 03 Nov 2020 18:17:43 -0800 (PST)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n1sm275586pgl.31.2020.11.03.18.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 18:17:42 -0800 (PST)
Date:   Wed, 4 Nov 2020 10:17:30 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
 <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
 <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
 <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 02:55:54PM -0800, Alexei Starovoitov wrote:
> > The scope of bpf in iproute2 is tiny - a few tc modules (and VRF but it
> > does not need libbpf) which is a small subset of the functionality and
> > commands within the package.
> 
> When Hangbin sent this patch set I got excited that finally tc command
> will start working with the latest bpf elf files.
> Currently "tc" supports 4 year old files which caused plenty of pain to bpf users.
> I got excited, but now I've realized that this patch set will make it worse.
> The bpf support in "tc" command instead of being obviously old and obsolete
> will be sort-of working with unpredictable delay between released kernel
> and released iproute2 version. The iproute2 release that suppose to match kernel
> release will be meaningless.
> More so, the upgrade of shared libbpf.so can make older iproute2/tc to do 
> something new and unpredictable.
> The user experience will be awful. Not only the users won't know
> what to expect out of 'tc' command they won't have a way to debug it.
> All of it because iproute2 build will take system libbpf and link it
> as shared library by default.
> So I think iproute2 must not use libbpf. If I could remove bpf support
> from iproute2 I would do so as well.
> The current state of iproute2 is hurting bpf ecosystem and proposed
> libbpf+iproute2 integration will make it worse.

Hi Guys,

Please take it easy. IMHO, it always very hard to make a perfect solution.
From development side, it's easier and could get latest features by using
libbpf as submodule. But we need to take care of users, backward
compatibility, distros policy etc.

I like using iproute2 to load bpf objs. But it's not standardized and too old
to load the new BTF defined objs. I think all of us like to improve it by
using libbpf. But users and distros are slowly. Some user are still using
`ifconfig`. Distros have policies to link the shared .so, etc. We have to
compromise on something.

Our purpose is to push the user to use new features. As this patchset
does, push users to try libbpf instead of legacy code. But this need time.

Sorry if my word make you feel confused. I'm not a native speaker, but I hope
we could find a solution that all(we, users, distros) could accept instead of
break/give up.

Thanks
Hangbin

