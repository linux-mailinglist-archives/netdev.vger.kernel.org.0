Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9133A336AB5
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 04:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCKDap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 22:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhCKDaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 22:30:15 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D9EC061574;
        Wed, 10 Mar 2021 19:30:03 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id p186so20260403ybg.2;
        Wed, 10 Mar 2021 19:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=877bemNFLjAoo8xqG5euoiL1YYZfVjc2/dpYZOJTzXk=;
        b=pMbMS0WbKzJochM7MKmx3DLGAm2bx1GFbmAYyvtoICMBnnk0HunT0BkG5ZckZMJPgy
         rrkXV0bc2el3jg8KpnVEy21v8OOng6qeWpLIqzodMHKSK6O8ZaEA1dVWLmQN7UbBmd1T
         RxlVtHhCoBfsm2D848bHgkAAsftJJpC+SauTh06ANHudc6F8BoMteF3Wfa9ol2xMtL+0
         HI0Wns/lpeDDWZWrlRWFLp4/vOP2W3XIqw6BMa/sMjz4w09Ij45mn9vNkEgHUOmmKNFy
         kqM1rYQXXiCrWtyQEpv+hxkUxrfTKZazAkuV3W/ea/kBS4fHPBN8dR0TzWCGCDZGEfWQ
         RJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=877bemNFLjAoo8xqG5euoiL1YYZfVjc2/dpYZOJTzXk=;
        b=WbuprLEc3xPDyrJw1ZlwlblpbDv6cnFhN5u+kO61xT9j9xQTquOBT8s4BJm9V4gHoy
         WN2s1mx7HRycdRz5x1GqC1fQMc7iSTJqI5GVcJUezIO/NyIY+0+dZEeknN4QdgYqcrJf
         s22ktLh/ym4iLLV/ewo2YjObLxxAuOIjZXXkLklO6U0AlQbILeQR6J7CYI44N0xgaEVY
         8afsUB9yxC5NPyDF7myrTG2NphF8WYkq0G4zfey0puVgbnBIv6BR8Mt5fJOjChaoy5Ks
         1dtGfEVo/45qxXibbDSmYUdEsDbY+/VbhSqxVtDF++8QzMeY2lHD4ZVEwxhrFIXuuZHk
         WBrg==
X-Gm-Message-State: AOAM532ewxY4D1JLcrB6JPMb6mrdtNeRbFDaadqQ3NgEjr/5v4O7YIID
        36+ch6OskSPmJrdGC4f4WM1zyVw0ImwDOVLXfnw=
X-Google-Smtp-Source: ABdhPJzy0OTKCOgwlOOvU/eRmCJDaE0OlNsVA2o5g9gtfUOPqfMXYleUdyUUElmo6vvOnEbKSHwFbyaAeF1QDQEBFFk=
X-Received: by 2002:a25:d94:: with SMTP id 142mr8256354ybn.230.1615433403060;
 Wed, 10 Mar 2021 19:30:03 -0800 (PST)
MIME-Version: 1.0
References: <20210310040431.916483-1-andrii@kernel.org> <20210310040431.916483-6-andrii@kernel.org>
 <20210311023417.vhwe4avhvri7gcr5@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210311023417.vhwe4avhvri7gcr5@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Mar 2021 19:29:52 -0800
Message-ID: <CAEf4BzY6RobSBMwLKFyJF-QoxwdJNZxoUStm=qViwy3eqtfUHw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 05/10] libbpf: add BPF static linker APIs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 6:34 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Mar 09, 2021 at 08:04:26PM -0800, Andrii Nakryiko wrote:
> > +
> > +     struct btf *strtab_btf; /* we use struct btf to manage strings */
> ...
> > +     str_off = btf__add_str(linker->strtab_btf, sec->sec_name);
> > +     sec->shdr->sh_name = str_off;
>
> That bit took me an hour to grok.
> That single line comment above is far far from obvious.

Heh, I guess I've been working with BTF, ELF and pahole for too long
to notice that it's so non-obvious. pahole wraps `struct btf` in a
similar fashion for deduplicated string management.

> What the logic is relying on is that string section in BTF format
> has the same zero terminated set of strings as ELF's .strtab section.
> There is no BTF anywhere here in this 'strtab_btf'.
> The naming choice made it double hard.

Right. strtab_strs would probably be a slightly better choice.

> My understanding that you're using that instead of renaming btf_add_mem()
> into something generic to rely on string hashmap for string dedup?

It's not about renaming btf_add_mem(). btf_add_mem() just implements
memory re-allocation (with exponential increase). But here we want to
not add a new string if it's already present. So it's much more
complicated logic than btf_add_mem().

>
> The commit log in patch 2 that introduces btf_raw_strs() sort of talks about
> this code puzzle, but I would never guessed that's what you meant based
> on patch 2 alone.
>
> Did you consider some renaming/generalizing of string management to
> avoid btf__add_str() through out the patch 5?
> The "btf_" prefix makes things challenging to read.
> Especially when patch 6 is using btf__add_str() to add to real BTF.

Right. I guess we can extract the "set of strings" data structure out
of `struct btf` into libbpf-internal data structure. Then use it from
struct btf and separately (and directly) from struct bpf_linker. I'll
see what that would involve in terms of refactoring.

>
> Mainly pointing it out for others who might be looking at the patches.

That's a good point, I should have probably at least mentioned that
bit more explicitly.
