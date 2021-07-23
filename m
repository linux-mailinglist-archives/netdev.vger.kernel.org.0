Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57053D3D30
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 18:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhGWP2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhGWP2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 11:28:40 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43008C061757
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 09:09:13 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id s19so3096188ybc.6
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 09:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T+582SQs2z7m67xzyXd8M0+NI9e3qbNwaAnPBBiVmfE=;
        b=SOSeBvQBQ8o4J8l5yr2e9+R3kIJRyUUYEEUL/qIaohQaz/pFJr/fa9Ym2U8LMUTsoj
         wWSVzyE9pCJOLPaQQCr1+u6vbW7XoqlJJTY7eXvH+csINCickFVv3r0KA5zo23d66O/E
         e+RteiiWCY/h6jzDypyaIkv7r9r6FyA9IhTsU5N0muH+pLm0IVCJPlHztz14GN8GKj9T
         GAZLjcKT29vo9NNNeG1kixRwI857P3fvDc39IdhMPJOnAD5199cRAVbLWE/B6q/FP0RQ
         n2+iqO43/w+7U81fASjQrDrAVCRumswjI1eKc6O/i4yR81LKMbEdEBO/G/kX2MOp2TLC
         CS6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T+582SQs2z7m67xzyXd8M0+NI9e3qbNwaAnPBBiVmfE=;
        b=VKBS3OUKqDiMmpEyxAkvPNjTcPjN6aoUAyZ+tQ+WP8jR82x08OvaLS/GsLDgp1b6UC
         ETOgezOtzSdq7Hjs8F8ug6XeoUSta+fZsAjNkzDFOW+np0AUpLzfN/fUand8pO7QP+PA
         VGo9CQorZ7FT3pAnpK69YwtGz+yx6Gr3qhAslDBd5PvAjmL2JRB0wWIobo8yI3e5T6Fu
         Rl/KhfiFo4sfMat4Zvz09xa+12ff4u/R0dgnIpT2YxHiDe91dh1hguyqMrQqDi3RUjd8
         oIOlRPCZ+ywH2P2lGyoZ8H54MQkMX9csBmAXkyFyMPxLiyr4KwUbp57M0zwBUin4MgJZ
         DsSw==
X-Gm-Message-State: AOAM531JbRJYfSXJo//yD87+KU+0CITSmLtcC/di0nm8JDRUblbMci05
        b//bww9GQgtkZlTMtkx5fdCGsirca8YYt+jcZMI=
X-Google-Smtp-Source: ABdhPJxmV1qZ72UeHDCQswMa6qPTvtrKMQ3vpeqQDInZwQ0kNENcZ7ZKcamjLyDZH2XvtQyr6NFsHEUrSjBiikxhCSE=
X-Received: by 2002:a25:cdc7:: with SMTP id d190mr7055061ybf.425.1627056552598;
 Fri, 23 Jul 2021 09:09:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210705124307.201303-1-m@lambda.lt> <CAEf4Bzb_FAOMK+8J+wyvbR2etYFDU1ae=P3pwW3fzfcWctZ1Xw@mail.gmail.com>
 <df3396c3-9a4a-824d-648f-69f4da5bc78b@lambda.lt> <YPpIeppWpqFCSaqZ@Laptop-X1>
 <CAEf4Bzavevcn=p7iBSH6iXMOCXp5kCu71a1kZ7PSawW=LW5NSQ@mail.gmail.com> <YPp17yOht8W+Kaqy@Laptop-X1>
In-Reply-To: <YPp17yOht8W+Kaqy@Laptop-X1>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Jul 2021 09:09:01 -0700
Message-ID: <CAEf4BzYayFVz4SVw3RpmTd-9w01bkA58NQ_QH4S8gLDDUsVPHA@mail.gmail.com>
Subject: Re: [PATCH iproute2] libbpf: fix attach of prog with multiple sections
To:     Hangbin Liu <haliu@redhat.com>
Cc:     Martynas Pumputis <m@lambda.lt>,
        Networking <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 12:55 AM Hangbin Liu <haliu@redhat.com> wrote:
>
> On Thu, Jul 22, 2021 at 09:51:50PM -0700, Andrii Nakryiko wrote:
> > > > > This is still problematic, because one section can have multiple BPF
> > > > > programs. I.e., it's possible two define two or more XDP BPF programs
> > > > > all with SEC("xdp") and libbpf works just fine with that. I suggest
> > > > > moving users to specify the program name (i.e., C function name
> > > > > representing the BPF program). All the xdp_mycustom_suffix namings are
>
> I just propose an implementation as you suggested.
>
> > > > > a hack and will be rejected by libbpf 1.0, so it would be great to get
> > > > > a head start on fixing this early on.
> > > >
> > > > Thanks for bringing this up. Currently, there is no way to specify a
> > > > function name with "tc exec bpf" (only a section name via the "sec" arg). So
> > > > probably, we should just add another arg to specify the function name.
> > >
> > > How about add a "prog" arg to load specified program name and mark
> > > "sec" as not recommended? To keep backwards compatibility we just load the
> > > first program in the section.
> >
> > Why not error out if there is more than one program with the same
> > section name? if there is just one (and thus section name is still
> > unique) -- then proceed. It seems much less confusing, IMO.
>
> If you and others think it's OK to only support one program each section.
> I do no object.
>

I'm not sure we are on the same page. I'll try to summarize what I
understood and you guys can decide for yourself what you want to do.

So I like your idea of introducing "prog" arg that will expect BPF
program name (i.e., C function name). In that case the name is always
unique. For existing "sec" arg, for backwards compatibility, I'd keep
it working, but when "sec" is used I'd check that the match is unique
(i.e., there is only one BPF program within the specified section). If
not and there are more than one matching BPF programs, that's a hard
error, because otherwise you essentially randomly pick one BPF program
out of a few.

> Thanks
> Hangbin
>
