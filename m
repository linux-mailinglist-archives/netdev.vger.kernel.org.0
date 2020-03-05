Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D756E17AAA9
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 17:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgCEQjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 11:39:13 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44325 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgCEQjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 11:39:13 -0500
Received: by mail-pg1-f196.google.com with SMTP id n24so2006532pgk.11;
        Thu, 05 Mar 2020 08:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PVSSbj49rQeRflw0glDQaTl2zgODmwsGuVhAn/Ys+D8=;
        b=c94+qd9lORVT/vk/D6dK2UA8JWFsaO6m5uoVhIXnn1Fs2o/i+HmR9eTPlYelQj6PlG
         zHGUGv5m3ij1tDqSvPPN/wKia5mvgyWIRWaJ9DVdxnkHk6qEPUl/vgHWow7/RCMootgz
         v/I5asHntWpHbzLOvKcfsdTEsiWAIpZwjaHZSFSBp7IAwKEL+q4+rgyUrc+Xf9DhfI4t
         d9kNDRehKpYZd6YynLGCEK3sgoQ3D3qsDum0h+hQAF4sFvap6kfTc7lZ3V8/iiwgNOwV
         QH4/cgwq4jKXMW1KCLMBXmm27wMAnQQOm0HAq+Zr5IRzksORPkdUNB/WZz/0nE1OsksC
         LhJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PVSSbj49rQeRflw0glDQaTl2zgODmwsGuVhAn/Ys+D8=;
        b=d0YuAKBysebsCDUQMeAZ6X2rtbemBlKMswPnWma8hf3UtcGYi6KNO26C0MifZ1eniQ
         nujKsPXUvR5Ve4hAetT3vd6YBqf0IguY71ZZzdWX0GTrPDnkZVcyJzMjq/2EJdc14jhS
         IfiEuSvO8VniqqiEtXLURBxwC7YgiopRfAxR5iN0DiaWGpb/LAZawZ2DLyVT9xRvfNru
         SqX7cSdK1vGnBdaggVyn7aVsCvD72roHjV6qiLZo61VzXDf3qFsJWU+fICA1Aew7EGJS
         j8+p1zStzpql2NoqsNVxBYAfolsG/39semRzygoldUAAq28kL0+pyt3y5kSyckxKQSXp
         uXUw==
X-Gm-Message-State: ANhLgQ2OrhKmx1I+s7IerXyqEHzXzzgZ02ueATITL7ZuYYyJa6Rw55O5
        NbBxgEAwY4X8CC27XHJVn+4=
X-Google-Smtp-Source: ADFU+vvFqdpZiTf1BxdMQYkLGo8VtHkVR1cBvYos+j+KBd55GuZmdEPPWe3h1VXGrg+lKHZ6lUOq3A==
X-Received: by 2002:a65:6843:: with SMTP id q3mr8556528pgt.269.1583426350452;
        Thu, 05 Mar 2020 08:39:10 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:f0e7])
        by smtp.gmail.com with ESMTPSA id jx10sm6809619pjb.33.2020.03.05.08.39.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Mar 2020 08:39:09 -0800 (PST)
Date:   Thu, 5 Mar 2020 08:39:07 -0800
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
Message-ID: <20200305163905.mumvxqmdotavd6t7@ast-mbp>
References: <87pndt4268.fsf@toke.dk>
 <ab2f98f6-c712-d8a2-1fd3-b39abbaa9f64@iogearbox.net>
 <ccbc1e49-45c1-858b-1ad5-ee503e0497f2@fb.com>
 <87k1413whq.fsf@toke.dk>
 <20200304043643.nqd2kzvabkrzlolh@ast-mbp>
 <20200304114000.56888dac@kicinski-fedora-PC1C0HJN>
 <20200304204506.wli3enu5w25b35h7@ast-mbp>
 <20200304132439.6abadbe3@kicinski-fedora-PC1C0HJN>
 <20200305010706.dk7zedpyj5pb5jcv@ast-mbp>
 <20200305001620.204c292e@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305001620.204c292e@cakuba.hsd1.ca.comcast.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 12:16:20AM -0800, Jakub Kicinski wrote:
> > 
> > bpf program is an object. That object has an owner or multiple owners.
> > A user process that holds a pointer to that object is a shared owner.
> > FD is such pointer. FD == std::shared_ptr<bpf_prog>.
> > Holding that pointer guarantees that <bpf_prog> will not disappear,
> > but it says nothing that the program will keep running.
> > For [ku]probe,tp,fentry,fexit there was always <bpf_link> in the kernel.
> > It wasn't that formal in the past until most recent Andrii's patches,
> > but the concept existed for long time. FD == std::shared_ptr<bpf_link>
> > connects a kernel object with <bpf_prog>. When that kernel objects emits
> > an event the <bpf_link> guarantees that <bpf_prog> will be executed.
> 
> I see so the link is sort of [owner -> prog -> target].

No. Link has two pieces: kernel object and program. It connects the two.

> > For cgroups we don't have such concept. We thought that three attach modes we
> > introduced (default, allow-override, allow-multi) will cover all use cases. But
> > in practice turned out that it only works when there is a central daemon for
> > _all_ cgroup-bpf progs in the system otherwise different processes step on each
> > other. More so there has to be a central diff-review human authority otherwise
> > teams step on each other. That's sort-of works within one org, but doesn't
> > scale.
> > 
> > To avoid making systemd a central place to coordinate attaching xdp, tc, cgroup
> > progs the kernel has to provide a mechanism for an application to connect a
> > kernel object with a prog and hold the ownership of that link so that no other
> > process in the system can break that connection. 
> 
> To me for XDP the promise that nothing breaks the connection cannot be
> made without a daemon, because without the daemon the link has to be
> available somewhere/pinned to make changes to, and therefore is no
> longer safe.

This is not true. Nothing requires pinning.
Again. FD == shared_ptr. Two applications can share that link and
coordinate the changes to dispatcher prog without a daemon and without pinning.
