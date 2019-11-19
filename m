Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCF21013B2
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 06:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbfKSF0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 00:26:31 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42494 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728568AbfKSF0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 00:26:30 -0500
Received: by mail-qk1-f194.google.com with SMTP id i3so4772669qkk.9
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 21:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=podFF2nwPATgk6Vyaa+JKA//o6jLZZVDQvx/NXLG1qw=;
        b=KyWCOhP8jnpTna7LokuJ3F0YPjpGUTp7v8hiLdPCgezIrdQViDb5ELCsIgqA+PbW7V
         3hfj6V5icMIBejEYWnkhZfwtBaL9nKmrwhkhajivZ5Yy8fDRwTR7nNSViN48nzdzR4RL
         z0UjUmwB1jqafeMb0lIDHDKFQAyNgYrmApymj8vZ2y5GfYY8Ag7Fqahe3sB9XLqxmTcA
         bdjaL5FGV9B20YEyeHawFdceEettYdOYR8a1LJDxavzTYLJV+3OPThmSgCSxaKp45FfS
         oWtmlStL+Ct/bbTpMr6kEjr71Nse3C8LetBocRbMpqYjHPgmtAFxSdcNI8k8ju5qZUa2
         m35Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=podFF2nwPATgk6Vyaa+JKA//o6jLZZVDQvx/NXLG1qw=;
        b=JSBdRmCiAiALa0w1FUjjjKkYZ7LBV5dJXNQsfZ7zmTVUDL4j7B4p82prIzByMPvXzQ
         1WEkJI7KlmfPPpuTNXzNv5c8BsxtPQ83sB9nYb597NDnyUkAPfR59AYKuDr0WNinSVT5
         wjXa4YbbKWQXmJTe3W6obbuLNH9PeXtYy9ZpzmRNh+J5WSBZF0FnE7/YjSU61S8jYRs8
         xU/LALGAVUv4T+cdmNrgTOoYE7qQoXHwXn4UEGOjrm+z62YFuq6JDxRRFwhopt1LglOz
         5sFipiXnpUsC9um7wwhmHP2tZ+qrsbes/J7xZQTQQw6INYcuoHWV9zG6uHjd2SplMNQj
         esTA==
X-Gm-Message-State: APjAAAXaN1JREwOcdQfAgk1+aXLGVXNsHBltqAT7Cr71GAyAfKTzu4sx
        D+3MHP+Mfs+CCRfn/xICQdEnKUgDd0r3T/al57Y2Wg==
X-Google-Smtp-Source: APXvYqwflmyefFY6nZjcYclr6qXpeKQ0p3jimSeMmqtsPPXbdgiEFdjyKSl93F3ZmOOWiM3pqjYuyMaUYB8dyh2z1vs=
X-Received: by 2002:a37:94e:: with SMTP id 75mr27389233qkj.49.1574141188100;
 Mon, 18 Nov 2019 21:26:28 -0800 (PST)
MIME-Version: 1.0
References: <20191119014357.98465-1-brianvv@google.com> <20191119014357.98465-6-brianvv@google.com>
 <20191119042012.3wpj5porwkntpfm4@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191119042012.3wpj5porwkntpfm4@ast-mbp.dhcp.thefacebook.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Mon, 18 Nov 2019 21:26:17 -0800
Message-ID: <CAMzD94Rv2ysZuMOwMFtZqPVjnhYdx-t2N=ekZzgVNeRapd86Ow@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/9] bpf: add batch ops to all htab bpf map
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Yonghong Song <yhs@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 8:35 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Nov 18, 2019 at 05:43:53PM -0800, Brian Vazquez wrote:
> > From: Yonghong Song <yhs@fb.com>
> >
> > htab can't use generic batch support due some problematic behaviours
> > inherent to the datastructre, i.e. while iterating the bpf map  a
> > concurrent program might delete the next entry that batch was about to
> > use, in this case there's no easy solution to retrieve the next entry
> > and the issua has been discussed multiple times (see [1] and [2]).
> > The only way hmap can be traversed without the problem previously
> > exposed is by making sure that the map is traversing entire buckets.
> > This commit implements those strict requirements for hmap, the
> > implementation follows the same interaction that generic support with
> > some exceptions:
> >
> >  - If keys/values buffer are not big enough to traverse a bucket,
> >    ENOSPC will be returned.
> >  - out_batch contains the value of the next bucket in the iteration, not
> >  the next key, but this is transparent for the user since the user
> >  should never use out_batch for other than bpf batch syscalls.
> >
> > Note that only lookup and lookup_and_delete batch ops require the hmap
> > specific implementation and update/delete batch ops can be the generic
> > ones.
> >
> > [1] https://lore.kernel.org/bpf/20190724165803.87470-1-brianvv@google.com/
> > [2] https://lore.kernel.org/bpf/20190906225434.3635421-1-yhs@fb.com/
> >
> > Co-authored-by: Brian Vazquez <brianvv@google.com>
> > Signed-off-by: Brian Vazquez <brianvv@google.com>
> > Signed-off-by: Yonghong Song <yhs@fb.com>
>
> SOB order is not quite correct.
> If the patch was mainly developed by Yonghong it should have his 'From:'
> then his SOB and then your SOB.
> You can drop Co-authored-by field.
>
Thanks for clarifying, will fix in v2.

> Patch 2 was also mainly done by Yonghong or not ?
> If so it should have his 'From:' field.6504484251

Generic support was done by me, but will double check the rest of the
patches and fix them if needed.
