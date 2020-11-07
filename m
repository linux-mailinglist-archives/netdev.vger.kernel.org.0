Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEF32AA1DC
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 01:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgKGAlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 19:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbgKGAlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 19:41:52 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4754C0613D2
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 16:41:51 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id j5so1484038plk.7
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 16:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dviNMRAIXAmDCudz1B80N0S417MTOYQ9xF9puJHuKCk=;
        b=1pqiTv9D/1LsG0ehNOsFDhvZene1KLet1sBcx+n+Yjq4jNH0ZqAW4GmC6+kq8y+3xp
         H2NP6j5TxjveRA4HqLhEqT15xQaqDXWYIfAD2EadfahD9aZJr+EA5iBNQc3nlbofl0V+
         ld/+UldBrxDD484iFxN1aTaMoySgm7KE+4ArQ5FcEp5kaMJuTOWd9Ga+7Le26dczDxfJ
         3/UlIB6NJZFRy/jsHtBUE9hCpcGSvBbi/Bxd48Pd9NMLPErftNaOdBZjacsjwEb1Eynp
         2Me/+u4SjSgdMsp/IoKTQfvHAAJj87Cnqahx3TMM6w9DfAueEs9+ruUsMbqd96DxvAVE
         3+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dviNMRAIXAmDCudz1B80N0S417MTOYQ9xF9puJHuKCk=;
        b=OQyYX2JBYdn2QyhzKbJ68a2QhrraHv/C/OAxQRP3HjDTGw3nHqH9hFEXINPeAzXGa0
         83TzMOhFX3WIqoTwcn1lHdxDuILMSJRaHxAl63/ng3WwzGKw+a29n5iOlR7/Eke1N0yk
         wIlCXsFu+uCI09Nq/UQ9SFItGFnZpTowifp9bRSn9eoRIfSlhQpEJzvHvdDQ7iNYmAsZ
         pmTSwJHmi1KX2pU+TTHPPMhFzbIPF9HlZdDDT9Lszco63WLD3+gdvQLKMVAK/fCP289/
         hobbZ74RVXP1xUhH9DveW8Aq1gomGzP4GVXYCk6QX368I5l5v9xB9cOj1R9U1Hk7BHWt
         Wy5w==
X-Gm-Message-State: AOAM53104BZB1SIfd+j+/ynNdiRVdAvFcjN7EIV9SU2XhX+Hu+5WZ1tm
        ++jjvC35soUYblf1eaBvteL0RQ==
X-Google-Smtp-Source: ABdhPJztFWMfsDNP5LgInpExKtVCm/PT9P0+9t/+Z5tvVU+cZ5V8Pfj3uqoCu8LjJw4Kn22vdvcHEw==
X-Received: by 2002:a17:902:7e47:b029:d6:c9f2:d50 with SMTP id a7-20020a1709027e47b02900d6c9f20d50mr3503094pln.81.1604709711369;
        Fri, 06 Nov 2020 16:41:51 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t12sm3515439pfq.79.2020.11.06.16.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 16:41:51 -0800 (PST)
Date:   Fri, 6 Nov 2020 16:41:42 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
Message-ID: <20201106164142.6d0955f9@hermes.local>
In-Reply-To: <CAEf4BzY6iqkJZOnPNwVp3Q+UYu=XA7CKo83aD60RvcAapWb0eQ@mail.gmail.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
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
        <20201106152537.53737086@hermes.local>
        <CAEf4BzY6iqkJZOnPNwVp3Q+UYu=XA7CKo83aD60RvcAapWb0eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Nov 2020 15:30:38 -0800
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Fri, Nov 6, 2020 at 3:25 PM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> >
> > On Fri, 6 Nov 2020 13:04:16 -0800
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >  
> > > On Fri, Nov 6, 2020 at 12:58 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:  
> > > >
> > > > On Fri, Nov 6, 2020 at 12:44 AM Jiri Benc <jbenc@redhat.com> wrote:  
> > > > >
> > > > > On Thu, 5 Nov 2020 12:19:00 -0800, Andrii Nakryiko wrote:  
> > > > > > I'll just quote myself here for your convenience.  
> > > > >
> > > > > Sorry, I missed your original email for some reason.
> > > > >  
> > > > > >   Submodule is a way that I know of to make this better for end users.
> > > > > >   If there are other ways to pull this off with shared library use, I'm
> > > > > >   all for it, it will save the security angle that distros are arguing
> > > > > >   for. E.g., if distributions will always have the latest libbpf
> > > > > >   available almost as soon as it's cut upstream *and* new iproute2
> > > > > >   versions enforce the latest libbpf when they are packaged/released,
> > > > > >   then this might work equivalently for end users. If Linux distros
> > > > > >   would be willing to do this faithfully and promptly, I have no
> > > > > >   objections whatsoever. Because all that matters is BPF end user
> > > > > >   experience, as Daniel explained above.  
> > > > >
> > > > > That's basically what we already do, for both Fedora and RHEL.
> > > > >
> > > > > Of course, it follows the distro release cycle, i.e. no version
> > > > > upgrades - or very limited ones - during lifetime of a particular
> > > > > release. But that would not be different if libbpf was bundled in
> > > > > individual projects.  
> > > >
> > > > Alright. Hopefully this would be sufficient in practice.  
> > >
> > > I think bumping the minimal version of libbpf with every iproute2 release
> > > is necessary as well.
> > > Today iproute2-next should require 0.2.0. The cycle after it should be 0.3.0
> > > and so on.
> > > This way at least some correlation between iproute2 and libbpf will be
> > > established.
> > > Otherwise it's a mess of versions and functionality from user point of view.  
> >
> > As long as iproute2 6.0 and libbpf 0.11.0 continues to work on older kernel
> > (like oldest living LTS 4.19 in 2023?); then it is fine.
> >
> > Just don't want libbpf to cause visible breakage for users.  
> 
> libbpf CI validates a bunch of selftests on 4.9 kernel, see [0]. It
> should work on even older ones. Not all BPF programs would load and be
> verified successfully, but libbpf itself should work regardless.
> 
>   [0] https://travis-ci.com/github/libbpf/libbpf/jobs/429362146

Look at the dates in my note, are you willing to promise that compatibility
in future versions.

