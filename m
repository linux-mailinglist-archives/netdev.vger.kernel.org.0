Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B31611D8BF
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 22:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731162AbfLLVqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 16:46:00 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44688 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730887AbfLLVqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 16:46:00 -0500
Received: by mail-pg1-f194.google.com with SMTP id x7so227164pgl.11
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 13:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zup1ZFvjpLsBitLXM/f/KZndih/WwXlNRrCfPRNh1DE=;
        b=OnAUAo+5L7IrdfKAwza3RWTSyDtcRlQ+A/pI9OAMffvnebc2TXmw5+G2d+wBv7HBnS
         AIkZoQ46KvORpYceLzrmoyXIwXtRVDkDUAiqD1RG5pJw6872gXyJfTdujXwIzer6Veib
         AV3i3pL4J5jCS+d2aGpgA+jqD4qUZYxgoWp97etSOPknjf4v9L44hafc4z97sLoaZ0YJ
         +hBZT5h0yhyl6zjIbU7eP8AebanKB0Zecd24v3qYgKeDcW1gufhR0Ii+T1eSBKtRPr/n
         xsrV4I0FeHL6hVWyz8+Wx8aF1WHvyM+UCRWPeZtYUSAh0nPlaJHWfn6xLUN4QqrwmYNl
         oIbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zup1ZFvjpLsBitLXM/f/KZndih/WwXlNRrCfPRNh1DE=;
        b=atXwjADlKGH9TCGI5AdklB7xKI/eNUdVEeC+j3ldkrWKZ19F0zSwbB6Q4wQlNVsd7O
         wwJjLmcOMDglLoApIzFR2k1Y/gPYRzOiHCl6DTDnQdaeAVGV2jH6VdFrwbP8OpwNGtUD
         83YDfoO7h+kIMXIc/3iXLO66qo5CNznkfajDTMpritl8OqqIhoVRIL+wUkn00u+AwKMK
         lGEILfLXeX38UAXhSV92Ck3Xyr6gwOd2HmNgRt5q6UsoqwvJU57tkMJilkeYZ/u2LIhL
         VxIPXppkaNkoX7Q9PBKsCO9/+5TObok+6ARW0Uy31BgU837OzGJ7TYSmkRxlkI441Ug+
         hPKw==
X-Gm-Message-State: APjAAAWNFgHduF/bMBQFldWahGIOKEUX4SNoaGbWG/TMKhFVC5egRYAL
        fVtSoMcHKQ0U6geqsmEFnRYHyA==
X-Google-Smtp-Source: APXvYqzpVuPBBOl0fFYwopZqMbhecvaa2TBve0aCKEkOibigelJLHLP3OA806jFISBb3XOBTK2h5yg==
X-Received: by 2002:a63:a508:: with SMTP id n8mr12684811pgf.278.1576187159678;
        Thu, 12 Dec 2019 13:45:59 -0800 (PST)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id g6sm6903979pjl.25.2019.12.12.13.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 13:45:58 -0800 (PST)
Date:   Thu, 12 Dec 2019 13:45:57 -0800
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 11/15] bpftool: add skeleton codegen command
Message-ID: <20191212214557.GO3105713@mini-arch>
References: <20191211191518.GD3105713@mini-arch>
 <CAEf4BzYofFFjSAO3O-G37qyeVHE6FACex=yermt8bF8mXksh8g@mail.gmail.com>
 <20191211200924.GE3105713@mini-arch>
 <CAEf4BzaE0Q7LnPOa90p1RX9qSbOA_8hkT=6=7peP9C88ErRumQ@mail.gmail.com>
 <20191212025735.GK3105713@mini-arch>
 <CAEf4BzY2KHK4h5e40QgGt4GzJ6c+rm-vtbyEdM41vUSqcs=txA@mail.gmail.com>
 <20191212162953.GM3105713@mini-arch>
 <CAEf4BzYJHvuFbBM-xvCCsEa+Pg-bG1tprGMbCDtsbGHdv7KspA@mail.gmail.com>
 <20191212104334.222552a1@cakuba.netronome.com>
 <20191212195415.ubnuypco536rp6mu@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212195415.ubnuypco536rp6mu@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/12, Alexei Starovoitov wrote:
> On Thu, Dec 12, 2019 at 10:43:34AM -0800, Jakub Kicinski wrote:
> One more point from Stan's email:
> 
> > You can replace "our build system" with some other project you care about,
> > like systemd. They'd have the same problem with vendoring in recent enough
> 
> we've been working with systemd folks for ~8 month to integrate libbpf into
> their build that is using meson build system and their CI that is github based.
> So we're well aware about systemd requirements for libbpf and friends.
Just curious (searching on systemd github for bpftool/libbpf doesn't
show up any code/issues): are you saying that there will be another ~8 months
to bring in bpftool or that it's already being worked on as part of
libbpf integration?

> > bpftool or waiting for every distro to do it. And all this work is
> > because you think that doing:
> >
> >        my_obj->rodata->my_var = 123;
> >
> > Is easier / more type safe than doing:
> >        int *my_var = bpf_object__rodata_lookup(obj, "my_var");
> >        *my_var = 123;
> 
> Stan, you conveniently skipped error checking. It should have been:
>     int *my_var = bpf_object__rodata_lookup(obj, "my_var");
>     if (IS_ERROR_NULL(my_var))
>         goto out_cleanup;
>      *my_var = 123;
Yeah, but you have a choice, right? You can choose to check the error
and support old programs that don't export some global var and a new
program that has it. Or you can skip the error checks and rely on null
deref crash which is sometimes an option.

(might be not relevant with the introduction of EMBED_FILE which you
seem to be using more and more; ideally, we still would like to be able to
distribute bpf.o and userspace binary separately).

> Take a look at Andrii's patch 13/15:
> 5 files changed, 149 insertions(+), 249 deletions(-)
> Those are simple selftests, yet code removal is huge. Bigger project benefits
> even more.
Excluding fentry/fexit tests (where new find_program_by_title+attach
helper and mmap might help), it looks like the majority of those gains come
from the fact that the patch in question doesn't do any error checking.
You can drop all the CHECK() stuff for existing
find_map_by_name/find_prog_by_name instead and get the same gains.

[as usual, feel free to ignore me, I don't want to keep flaming about
it, but it's hard not to reply]
