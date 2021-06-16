Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6245A3AA757
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 01:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbhFPXU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 19:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234476AbhFPXU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 19:20:27 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9457C061574;
        Wed, 16 Jun 2021 16:18:20 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id c14so5444092ybk.3;
        Wed, 16 Jun 2021 16:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IjPZycaBxgq5vO65AfgtqkV7cRF6YSSfceLCcOugeoI=;
        b=SDT98NwoiapsXDfIB3M3AxGQWpJjhvzOjlyp61uazOimeZXpOZfc/0p8HUjLKMqZxS
         RjzUuvza847L0LdU9Gvz3ocjHVVUZdtZHEc3t219I+ey0G4fzlqgqx3ChUuZ5CgWr7Ck
         tAsDnOnOp6CLwZykDgneC2OsXdWbPiUthJ6/GhN1+ELQO5l35CxuvFT9hcdcY7KPJCi8
         GGf5zsLKsNNolGkUVoitcJFgE/PMETosMDqLSjwwDKautQxW3vKlKeCBNy68J8XDa0lf
         ljtKhpUDVmKUWq+0bFuLcnM4KScmV3Cemsu7DOEayTbDgBIVx5LMhWxBy/zykSKtWv5V
         D3Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IjPZycaBxgq5vO65AfgtqkV7cRF6YSSfceLCcOugeoI=;
        b=gen7aVb3fY/RIXZ0JwHFd+taO/xVO9tDipmGQ7hEvO0mHOLILEVoCGsiBjp5QRyA5P
         jMoyQxXOMXba7tZ66KXe/DiD/QkFeuXv2NUqVeh2bz1XFEvwdh454C/HmwzwfK8l6Ebu
         /2qcgweyWGqcxYpdQg2TubEiEwxZq/mQNsaWQauZc3J52baTAhkflrbFPXGW6+V/3Xw6
         zAwzpEGBx6cqMAdEq0qHs0bZ28CE0eu0s0c92LQmqWND+ak3dbNMDc2crKtxwIfw1V9O
         31mMw9Wdc7Mvn1YMPJ4Npa7NG5E/FSIxhe5Uj1KgddE2OEaAXHd7XlxO3oYpFDj+Oq5X
         3RuA==
X-Gm-Message-State: AOAM532V2OKynMJlBGIC1IKSzSchq4eRzAMZSiqmpdHu9W/LfIPYtVeJ
        +UqR+dobapSx4DJ65DfJv9msTj8UBH/c5NEqNQo=
X-Google-Smtp-Source: ABdhPJxV17d2g8AIQQA990WRsq5Z1Q9r9vlrTSjfMQajjqtmD4QX/YLZ+3SRgIbY89taO47Xkqmmf/VT7AkID2A15cU=
X-Received: by 2002:a25:df82:: with SMTP id w124mr1970165ybg.425.1623885499929;
 Wed, 16 Jun 2021 16:18:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210616170231.2194285-1-memxor@gmail.com>
In-Reply-To: <20210616170231.2194285-1-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Jun 2021 16:18:08 -0700
Message-ID: <CAEf4BzZTgMHVd2kEQ5vakgNSJYFB7uiY0j_NBGdG_xzmjKQTAA@mail.gmail.com>
Subject: Re: [PATCH v2] libbpf: add request buffer type for netlink messages
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 10:04 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> Coverity complains about OOB writes to nlmsghdr. There is no OOB as we
> write to the trailing buffer, but static analyzers and compilers may
> rightfully be confused as the nlmsghdr pointer has subobject provenance
> (and hence subobject bounds).
>
> Remedy this by using an explicit request structure, but we also need to
> start the buffer in case of ifinfomsg without any padding. The alignment
> on netlink wire protocol is 4 byte boundary, so we just insert explicit

struct ifinfomsg has unsigned field in it, which makes it
automatically 4-byte aligned because the struct is not packed. Do we
really need that _pad[4] thing?.. Even if we do, I'm still not sure
how it helps with alignment... If anything, explicit
__attribute__((aligned(4))) would be better.

> 4 byte buffer to avoid compilers throwing off on read and write from/to
> padding.
>
> Also switch nh_tail (renamed to req_tail) to cast req * to char * so

it probably should use (void *) everywhere, instead of (char *), but I
see that existing code is using char * exclusively, so it's probably
for another patch

> that it can be understood as arithmetic on pointer to the representation
> array (hence having same bound as request structure), which should
> further appease analyzers.
>
> As a bonus, callers don't have to pass sizeof(req) all the time now, as
> size is implicitly obtained using the pointer. While at it, also reduce
> the size of attribute buffer to 128 bytes (132 for ifinfomsg using
> functions due to the need to align buffer after it).

Sorry if it's a stupid question, but why it's safe to reduce the
buffer size from 128 to 256?

>
> Summary of problem:
>   Even though C standard allows interconveritility of pointer to first

s/interconveritility/interconvertibility/ ?

>   member and pointer to struct, for the purposes of alias analysis it
>   would still consider the first as having pointer value "pointer to T"
>   where T is type of first member hence having subobject bounds,
>   allowing analyzers within reason to complain when object is accessed
>   beyond the size of pointed to object.
>
>   The only exception to this rule may be when a char * is formed to a
>   member subobject. It is not possible for the compiler to be able to
>   tell the intent of the programmer that it is a pointer to member
>   object or the underlying representation array of the containing
>   object, so such diagnosis is supressed.

typo: suppressed

>
> Fixes: 715c5ce454a6 ("libbpf: Add low level TC-BPF management API")
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
> Changelog:
> v1 -> v2:
>  * Add short summary instead of links about the underlying issue (Daniel)
> ---
>  tools/lib/bpf/netlink.c | 107 +++++++++++++++-------------------------
>  tools/lib/bpf/nlattr.h  |  37 +++++++++-----
>  2 files changed, 65 insertions(+), 79 deletions(-)
>

[...]
