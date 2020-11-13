Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAA92B134D
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 01:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgKMAfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 19:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgKMAfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 19:35:22 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F2AC0613D4
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 16:35:05 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id w14so6113161pfd.7
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 16:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QAgM9zSxSYveUCOf/9t8xsp7ka6K5j+jjbPInpgBIqA=;
        b=NsOc7bKutoFtdS7Qt/K8dNsBrXWCzKDDLopQxrExVTiGbhMdAMW+Uz39ccazr1SVkt
         8tjLVKxpcwa509G7MoQX345tM2AHYvZ2rKUGWcpcOX5qB+RhJYYBZzfl4zdhT3X2aSEF
         YBkXslumlmow50jN3QuFQczsRscj8Uynbch6Cs8oVDCNo9l79bOu8whCT6UXzj58dlJZ
         N9WZmA2N0oLkO0ZcKiU/GYthUOM5c1507W4sPxRJ8D4uhRuI408KGOGNsmzlt2ZeETMc
         uhS/z1JoDYv6LRrfSYvn8sjJZ8nlzkKfDe7CXvLdY0zFtFlytaxeoY/mo1fXf9FaOtAG
         wlzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QAgM9zSxSYveUCOf/9t8xsp7ka6K5j+jjbPInpgBIqA=;
        b=TfMdFWbGNHlFYTlsRg/rLmlS1k8YhVuMhv8TkQIqf+uycsTRJPeJc/eqI9l4Bn/gOV
         Q3ZGDwu4yn3CMZp6XWtO8j/Yo2ef7qdWqVY2aNbKEcCIH+M0p+GeDBIEDH0fKX54Ktpz
         Il2iVLdQrcvHxGjlJw889jnnP+GmnSiCNHRj015EWaOoUbHKCEKxqGG5V4me4umI7Jay
         EOT0GVmJjAMva5XbMy1v6ZfergcylNWXKBtqBN3tU4sd4AZ+DMGNK1909sVTiqXLGrPj
         D8w4inrFykpDYFL3u0wm82v1ITJa3uuyK10GadRrX8SBaskZ9OK0pfVCugHFXbrkiDDM
         PxHg==
X-Gm-Message-State: AOAM530leVEANSI2dLhiDlVO4pxAu0caTVjVScfdXYW6Wp9fZCvZrK4U
        sBVxIsmYrLJ0kvt2ND6OaK6nkw==
X-Google-Smtp-Source: ABdhPJzluyUQ+S3aVtMeaLoqx0xjWMJHmK27cQczPs/T1e9p2y+zpaPIMk+Jvlbb4KNcK9CwuMzl2A==
X-Received: by 2002:a63:887:: with SMTP id 129mr1628022pgi.81.1605227705235;
        Thu, 12 Nov 2020 16:35:05 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id m66sm8176440pfm.54.2020.11.12.16.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 16:35:04 -0800 (PST)
Date:   Thu, 12 Nov 2020 16:04:37 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Hangbin Liu <haliu@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201112160437.64c36022@hermes.local>
In-Reply-To: <da82603a-cea9-7036-9d9a-4e1174cfa7c0@iogearbox.net>
References: <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
        <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com>
        <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
        <20201106094425.5cc49609@redhat.com>
        <CAEf4Bzb2fuZ+Mxq21HEUKcOEba=rYZHc+1FTQD98=MPxwj8R3g@mail.gmail.com>
        <CAADnVQ+S7fusZ6RgXBKJL7aCtt3jpNmCnCkcXd0fLayu+Rw_6Q@mail.gmail.com>
        <20201106152537.53737086@hermes.local>
        <45d88ca7-b22a-a117-5743-b965ccd0db35@gmail.com>
        <20201109014515.rxz3uppztndbt33k@ast-mbp>
        <14c9e6da-e764-2e2c-bbbb-bc95992ed258@gmail.com>
        <20201111004749.r37tqrhskrcxjhhx@ast-mbp>
        <874klwcg1p.fsf@toke.dk>
        <321a2728-7a43-4a48-fe97-dab45b76e6fb@iogearbox.net>
        <871rgy8aom.fsf@toke.dk>
        <da82603a-cea9-7036-9d9a-4e1174cfa7c0@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 00:20:52 +0100
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 11/12/20 11:36 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Daniel Borkmann <daniel@iogearbox.net> writes:
> >  =20
> >>> Besides, for the entire history of BPF support in iproute2 so far, the
> >>> benefit has come from all the features that libbpf has just started
> >>> automatically supporting on load (BTF, etc), so users would have
> >>> benefited from automatic library updates had it *not* been vendored i=
n. =20
> >>
> >> Not really. What you imply here is that we're living in a perfect
> >> world and that all distros follow suite and i) add libbpf dependency
> >> to their official iproute2 package, ii) upgrade iproute2 package along
> >> with new kernel releases and iii) upgrade libbpf along with it so that
> >> users are able to develop BPF programs against the feature set that
> >> the kernel offers (as intended). These are a lot of moving parts to
> >> get right, and as I pointed out earlier in the conversation, it took
> >> major distros 2 years to get their act together to officially include
> >> bpftool as a package - I'm not making this up, and this sort of pace
> >> is simply not sustainable. It's also not clear whether distros will
> >> get point iii) correct. =20
> >=20
> > I totally get that you've been frustrated with the distro adoption and
> > packaging of BPF-related tools. And rightfully so. I just don't think
> > that the answer to this is to try to work around distros, but rather to
> > work with them to get things right.
> >=20
> > I'm quite happy to take a shot at getting a cross-distro effort going in
> > this space; really, having well-supported BPF tooling ought to be in
> > everyone's interest! =20
>=20
> Thanks, yes, that is worth a push either way! There is still a long tail
> of distros that are not considered major and until they all catch up with
> points i)-iii) it might take a much longer time until this becomes really
> ubiquitous with iproute2 for users of the libbpf loader. Its that this
> frustrating user experience could be avoided altogether. iproute2 is
> shipped and run also on small / embedded devices hence it tries to have
> external dependencies reduced to a bare minimum (well, except that libmnl
> detour, but it's not a mandatory dependency). If I were a user and would
> rely on the loader for my progs to be installed I'd probably end up
> compiling my own version of iproute2 linked with libbpf to move forward
> instead of being blocked on distro to catch up, but its an additional
> hassle for shipping SW instead of just having it all pre-installed when
> built-in given it otherwise comes with the base distro already. But then
> my question is what is planned here as deprecation process for the built-=
in
> lib/bpf.c code? I presume we'll remove it eventually to move on?

Perf has a similar problem and it made it into most distributions because i=
t is
a valuable tool. Maybe there is some lessons learned that could apply here.
