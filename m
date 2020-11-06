Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7502AA0F9
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 00:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgKFXZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 18:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbgKFXZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 18:25:48 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02466C0613D2
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 15:25:46 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id y7so2824161pfq.11
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 15:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t49Uj56W+rkBFWbXc8EIUZI8P2qyJdCmrkeESNJo37k=;
        b=kRaxAGDoYIbKFnS8WRSV3cm99v/TilSAJfBqHjzxZmqFHbEsLzkzyzj7X/s0BQhbr+
         l2XwCCXWCRlR0ddiM563blEHGyGnJkQStMQ0gYtmhLKjY8zKUf0hjEJklu8nS7cK7AAj
         AjfR1b/Cz9UIlt2/v8Vv/ZLdsatc+M4rz3tFjA/En8x0+2EvYpph9mGX+OxS1+iei7bY
         m6Zaz5+8W7J2VVcBs9wm6gfGLyq95N+j32I4uNwf/1DTVvCKGtvsPAUy/mESF9j/TMlf
         pbvMwxgxymXxnUC0pC2epJmgAUlPj4xOeyHbiZfe0W0pOc9q1ZMFT2w4Mi5JDmRb+kd4
         RjGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t49Uj56W+rkBFWbXc8EIUZI8P2qyJdCmrkeESNJo37k=;
        b=SlbzuEkCS2B9GQzHFj+67ZqE0ajknLdISjyE1/YCxDTRLwBcXPOsppbRuw9cNH0UhR
         EeR3ujBtwseGvX6gVIzLdf2L3QFth/KP5yzXc5P7/DCdEc0KBPw+VJgsJrXi0taG7vou
         hE2YiN4iNMuqkRwu9ifBi1Dz9GZ+iJR7WdS0DWWzRSp9DL9k2PjBQQN8kCLdbCN0fHLZ
         9jFgDDY6TJ28IdUJ1tOjKYO4fG5AL7QxZKxdbPIt8o6pQMP3wwtdUUMH+yT40uGt5IWL
         VBY7s09YYuqwJ0M1emxvYDHCZhBZy4xNwKKvtUTIZLaUM1byUKlJHqAUH57+8huRKGW3
         P1/Q==
X-Gm-Message-State: AOAM53192GJBTNDnCJxUld9n2RJvWXJefGM60csfjogQrPn4cBEz3bxi
        9aeaUp+qWMD9H+TeeI4ZQE4dxw==
X-Google-Smtp-Source: ABdhPJyDt7ziyRq5YmjNNtmJtSQPmeQPIXjp4Pa4UewTKU2XTFtyAAzPHuBjDx6UNUeIS+UWguxj4g==
X-Received: by 2002:a17:90b:a05:: with SMTP id gg5mr1914882pjb.214.1604705146479;
        Fri, 06 Nov 2020 15:25:46 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id i13sm2140894pfo.139.2020.11.06.15.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 15:25:46 -0800 (PST)
Date:   Fri, 6 Nov 2020 15:25:37 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Hangbin Liu <haliu@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201106152537.53737086@hermes.local>
In-Reply-To: <CAADnVQ+S7fusZ6RgXBKJL7aCtt3jpNmCnCkcXd0fLayu+Rw_6Q@mail.gmail.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
        <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
        <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
        <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
        <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
        <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com>
        <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
        <20201104021730.GK2408@dhcp-12-153.nay.redhat.com>
        <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
        <bb04a01a-8a96-7a6a-c77e-28ee63983d9a@solarflare.com>
        <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
        <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com>
        <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
        <20201106094425.5cc49609@redhat.com>
        <CAEf4Bzb2fuZ+Mxq21HEUKcOEba=rYZHc+1FTQD98=MPxwj8R3g@mail.gmail.com>
        <CAADnVQ+S7fusZ6RgXBKJL7aCtt3jpNmCnCkcXd0fLayu+Rw_6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Nov 2020 13:04:16 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Fri, Nov 6, 2020 at 12:58 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Nov 6, 2020 at 12:44 AM Jiri Benc <jbenc@redhat.com> wrote:  
> > >
> > > On Thu, 5 Nov 2020 12:19:00 -0800, Andrii Nakryiko wrote:  
> > > > I'll just quote myself here for your convenience.  
> > >
> > > Sorry, I missed your original email for some reason.
> > >  
> > > >   Submodule is a way that I know of to make this better for end users.
> > > >   If there are other ways to pull this off with shared library use, I'm
> > > >   all for it, it will save the security angle that distros are arguing
> > > >   for. E.g., if distributions will always have the latest libbpf
> > > >   available almost as soon as it's cut upstream *and* new iproute2
> > > >   versions enforce the latest libbpf when they are packaged/released,
> > > >   then this might work equivalently for end users. If Linux distros
> > > >   would be willing to do this faithfully and promptly, I have no
> > > >   objections whatsoever. Because all that matters is BPF end user
> > > >   experience, as Daniel explained above.  
> > >
> > > That's basically what we already do, for both Fedora and RHEL.
> > >
> > > Of course, it follows the distro release cycle, i.e. no version
> > > upgrades - or very limited ones - during lifetime of a particular
> > > release. But that would not be different if libbpf was bundled in
> > > individual projects.  
> >
> > Alright. Hopefully this would be sufficient in practice.  
> 
> I think bumping the minimal version of libbpf with every iproute2 release
> is necessary as well.
> Today iproute2-next should require 0.2.0. The cycle after it should be 0.3.0
> and so on.
> This way at least some correlation between iproute2 and libbpf will be
> established.
> Otherwise it's a mess of versions and functionality from user point of view.

As long as iproute2 6.0 and libbpf 0.11.0 continues to work on older kernel
(like oldest living LTS 4.19 in 2023?); then it is fine. 

Just don't want libbpf to cause visible breakage for users.
