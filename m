Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 549B49A340
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394183AbfHVWsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:48:33 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41714 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394107AbfHVWsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 18:48:32 -0400
Received: by mail-pf1-f194.google.com with SMTP id 196so4959197pfz.8;
        Thu, 22 Aug 2019 15:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PDYWQC26G85uFe21HzXIGcCDB8NArXzZKACQ42fhc6M=;
        b=uUOWA6zAPGTpTgg7Rd+TF1com3hB4gUJbLb0PdvIYzSKualdXoorLvEq3WlQNBBvRh
         tLmz1Esv2pFsO+zfFCoX0U3iiN+xkjnhQK7qoqAOyfy60isuw9jrvQ3q8+geXaxb/0e4
         GCFHlPjDJCmOAoeA7UltlKSac08qxPW8+rrPlbrLQZeMGLWCB0jG84YFamK3jlhHw8Nv
         7PYYRiTqERnpSaFA+YmsanbTCcDSeI+2cnQYAbeKNGFq2UlWI3kTXfj2SF5ye7CQE4ZR
         WWyxLzpq/3/VI7Z7E8PwLvd6GpobsyTmchpIV3DL59TUcM9B0/GOAKJYpCTvJNmO26Ra
         CKbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PDYWQC26G85uFe21HzXIGcCDB8NArXzZKACQ42fhc6M=;
        b=aWzELuSPgnFO39WoxQcqRI2bOijRX/EgbLbtIGXfq92gicC8FfYcUOQmPn+CoOGZcd
         qn423ICBJNk8mWxuEy8WZVSK/+yL0w1FzdInMeBBd/OQEJw/5etvCYxdP0KZqY/fb8N3
         CVNQ1GYW5T7iQmBPhse4GBdYSizJP21VTizkpIFljd9AtEZZZh8DPz8pU3Zm/PPpYfNQ
         cKAtxAkrgkrkR6+W+eDPUqp0DYZZ6hZ2ohyXzEpt96sdBA/7/Kkivlt5NInwhUhvTVCP
         ni1ViUdDrBIZ2uA/m7pmULi4600Z721LcDLxKTaMoMgh9w393SSZGkMM0vRvyeHFbXHA
         YdBQ==
X-Gm-Message-State: APjAAAXv19Ma2Kap5NfZQGBhxQsoH00DwHPjo31652TGcqGwg7BkfZQJ
        wjXstA1MXyyRucQ/4uXu7Vg=
X-Google-Smtp-Source: APXvYqxXNgjLeBOln1rezZFZ3HnShQ7NStPlJbWY0YLcdouSeNXoATOnRBJrJQWHbNz/HamJHeV/CQ==
X-Received: by 2002:aa7:9516:: with SMTP id b22mr1723747pfp.106.1566514112000;
        Thu, 22 Aug 2019 15:48:32 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::1070])
        by smtp.gmail.com with ESMTPSA id e24sm278952pgk.21.2019.08.22.15.48.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 15:48:31 -0700 (PDT)
Date:   Thu, 22 Aug 2019 15:48:29 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Chenbo Feng <chenbofeng.kernel@gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Message-ID: <20190822224826.xbovlykhpk4p4ww4@ast-mbp.dhcp.thefacebook.com>
References: <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
 <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
 <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp>
 <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <98fee747-795a-ff10-fa98-10ddb5afcc03@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98fee747-795a-ff10-fa98-10ddb5afcc03@iogearbox.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 04:17:43PM +0200, Daniel Borkmann wrote:
> 
> > > Hence unprivileged bpf is actually something that can be deprecated.
> 
> There is actually a publicly known use-case on unprivileged bpf wrt
> socket filters, see the SO_ATTACH_BPF on sockets section as an example:
> 
>   https://blog.cloudflare.com/cloudflare-architecture-and-how-bpf-eats-the-world/
> 
> If I'd have to take a good guess, I'd think it's major use-case is in
> SO_ATTACH_REUSEPORT_EBPF in the wild, I don't think the sysctl can be
> outright flipped or deprecated w/o breaking existing applications unless
> it's cleanly modeled into some sort of customizable CAP_BPF* type policy
> (more below) where this would be the lowest common denominator.

The cloudflare use case is the perfect example that a lot of program types
are used together.
Do people use SO_ATTACH_BPF ? Of course.
All program types are used by somebody. Before accepting them we had long
conversations with authors to understand that the use cases are real.
Some progs are probably used less than others by now.
Like cls_bpf without exts_integrated is probably not used at all.
We still have to support it, of course.
That cloudflare example demonstrates that kernel.unprivileged_bpf_disabled=1
is a reality. Companies that care about security already switched it on.
Different bits in cloudflare setup need different level of capabilities.
Some (like SO_ATTACH_BPF) need unpriv. Another need CAP_NET_ADMIN.
But common demoninator for them all is still CAP_SYS_ADMIN.
And that's why the system as a whole is not as safe as it could have
been with CAP_BPF. The system needs root in many places.
Folks going out of the way to reduce that SYS_ADMIN to something less.
The example with systemd and NET_ADMIN is just one of them.

