Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 219D9119E95
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfLJWxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:53:24 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46605 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfLJWxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 17:53:23 -0500
Received: by mail-pg1-f194.google.com with SMTP id z124so9601219pgb.13;
        Tue, 10 Dec 2019 14:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=dUDhi+vrizCDQsGj4pc5jWU26FSBssN6Xxld2hQXfVA=;
        b=glGU9x02KRDnsK6A5AaLs4rMCnVwW3EE4N4dp/TxbNWO/ZBbszGfmMqnw7HdES9cxE
         Pja83pvNOaSNHHtCXiYZ0kaTelWQzDvI58yV/FcQCGdLfHbt28xPjw1Tebg1dyojyEzG
         hpX2QWFSCsknI6nJiriz2OLae7gZRVx8yS5xbR+2tK/sfAKzsTSroqj50MlfedJoDP3S
         GVw4VIhuNqphzVT311+/nDoVDh/8OiaaBO1hwqD/R3wSsYGOOgqnrRf8G4AuMk0TwTYZ
         Pylt7PZqspGPlBhBCS5M1yKnd1yJ818brA+OwED6jbXKfRr1jSnI5kfTjxbbY+xXRUoS
         Vs8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=dUDhi+vrizCDQsGj4pc5jWU26FSBssN6Xxld2hQXfVA=;
        b=bORDvV8CGSoCmpwvFVZsntP8lE6PaXDfs6JLkKNgD+BU1LkSY3LUX2DwRjH3hRr+iJ
         6EdjFtMbe+MjAuzZI17JGAIjna2qa4dsJww5UlXHpf8NiPSfG9uSHx5cS0MpchzD/2In
         gBwCgsnAl1an6E156dYjD+g0pd4s78Yl0iWup+IOAXQxvYOe9UzkKLQSflLRe1ZhczW8
         3TujUOBD18BkVZnNf01G97wpM2PqOetzKMFQumf/LUDBZgggPbKmYRip1dsCC8p02jmI
         6mq0UtMxaVOmeoin+lXieKRT3vBdhbTGPyFfiqjeitbHGkPamyAyoI4f8nztpdBbTLwH
         8yLw==
X-Gm-Message-State: APjAAAWanKK9Cttnvk86gJFEQCIqnrmRL6LuVYqATLqUf2JY/Cb8scF1
        AxTKY8aOjHc5F4oi8opPvig=
X-Google-Smtp-Source: APXvYqyaoXewPtk6K9LcJ2BvDJm09Y0mkTH2JS0qcJmsPhCtrlORmEXitFkhZ7Qbka6vFiST/SILVQ==
X-Received: by 2002:aa7:8658:: with SMTP id a24mr304483pfo.87.1576018402986;
        Tue, 10 Dec 2019 14:53:22 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:a25c])
        by smtp.gmail.com with ESMTPSA id e7sm70381pfe.168.2019.12.10.14.53.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Dec 2019 14:53:22 -0800 (PST)
Date:   Tue, 10 Dec 2019 14:53:21 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf v2] bpftool: Don't crash on missing jited insns or
 ksyms
Message-ID: <20191210225320.pymey5md727e4m5x@ast-mbp.dhcp.thefacebook.com>
References: <20191210181412.151226-1-toke@redhat.com>
 <20191210125457.13f7821a@cakuba.netronome.com>
 <87eexbhopo.fsf@toke.dk>
 <20191210132428.4470a7b0@cakuba.netronome.com>
 <20191210213148.kqd6xdvqjkh3zxst@ast-mbp.dhcp.thefacebook.com>
 <20191210135205.529044a4@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191210135205.529044a4@cakuba.netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 01:52:05PM -0800, Jakub Kicinski wrote:
> On Tue, 10 Dec 2019 13:31:50 -0800, Alexei Starovoitov wrote:
> > On Tue, Dec 10, 2019 at 01:24:28PM -0800, Jakub Kicinski wrote:
> > > On Tue, 10 Dec 2019 22:09:55 +0100, Toke Høiland-Jørgensen wrote:  
> > > > Jakub Kicinski <jakub.kicinski@netronome.com> writes:  
> > > > > On Tue, 10 Dec 2019 19:14:12 +0100, Toke Høiland-Jørgensen wrote:    
> > > > >> When the kptr_restrict sysctl is set, the kernel can fail to return
> > > > >> jited_ksyms or jited_prog_insns, but still have positive values in
> > > > >> nr_jited_ksyms and jited_prog_len. This causes bpftool to crash when trying
> > > > >> to dump the program because it only checks the len fields not the actual
> > > > >> pointers to the instructions and ksyms.
> > > > >> 
> > > > >> Fix this by adding the missing checks.
> > > > >> 
> > > > >> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>    
> > > > >
> > > > > Fixes: 71bb428fe2c1 ("tools: bpf: add bpftool")
> > > > >
> > > > > and
> > > > >
> > > > > Fixes: f84192ee00b7 ("tools: bpftool: resolve calls without using imm field")
> > > > >
> > > > > ?    
> > > > 
> > > > Yeah, guess so? Although I must admit it's not quite clear to me whether
> > > > bpftool gets stable backports, or if it follows the "only moving
> > > > forward" credo of libbpf?  
> > > 
> > > bpftool does not have a GH repo, and seeing strength of Alexei's
> > > arguments in the recent discussion - I don't think it will. So no
> > > reason for bpftool to be "special"  
> > 
> > bpftool always was and will be a special user of libbpf.
> 
> There we go again. Making proclamations without any justification or
> explanation.
> 
> Maybe there is a language barrier between us, but I wrote the initial
> bpftool code, so I don't see how you (who authored one patch) can say
> what it was or is. Do you mean to say what you intend to make it?

When code lands it becomes the part of the code that maintainers keep in the
best shape possible considering contributions from many parties. Original
author of the code is equal to everyone else who submits patches. The job of
the maintainer is to mediate folks who contribute the patches. Sounds like you
expected to own bpftool as a single owner. I don't think kernel is such place.
In most projects I'm aware of the OWNERS file is discouraged. The kernel is
such project. The kernel has MAINTAINERS file which lists people most
knowledgeable in the area and who's job is to keep the code in good shape,
consider long term growth, etc. Maintainers are not owners of the code.

bpftool became way more than what it was when initially landed. Just like
libbpf was implemented mainly by huawei folks and used in perf only. Now perf
is a minority and original authors are not contributing any more. I'm sure you
thought of bpftool as cli for sys_bpf only. Well thankfully it outgrew this
narrow view point. bpftool btf dump file doesn't call sys_bpf at all.
bpftool perf | net using several other kernel apis. I think it's a good growth
trajectory for bpftool. More people use it and like it.

> Upstreaming bpftool was a big mistake, but we live and we learn

ok. Not going count on your help anymore.
Since you're not interesting in helping please don't stall it either.

