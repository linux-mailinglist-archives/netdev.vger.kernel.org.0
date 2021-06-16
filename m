Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41EE3AA7C4
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 01:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbhFPX53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 19:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhFPX53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 19:57:29 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21A1C061574;
        Wed, 16 Jun 2021 16:55:21 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d62so1533519pfd.3;
        Wed, 16 Jun 2021 16:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BYLH5NSOEjhPQlUl+Vzmbtv2wlt8Io26g6BkI1Bxjrg=;
        b=Z/B+UzO/k3PiRqkIA2uet62yovpTStsRh1v96aKuGVT5S49r2J341TUFtPNm+iJ89U
         664fJILeQ3r4A43KQEbAylRWF0JVY4ZT7v9CT+VRUt8y8xlUyQ6EIwZ/SGYXXAQrGyLg
         y4BBR506NRZUvXarm7fm7nFdxmnodXsPXxb9pc4qzv6YNFbDcnrzrw4PXJx+y7ooi1oZ
         XQnJmSLfeX5N/NyY+4sRbxO8BTfH/UNLCfxb95ku0+3OglMrR91mEtP5oRhsrAstnh8t
         QFDKVnzSabHSUXA17XH5S94roudFv5gsYx/O3CUKFMdhyhYIFnDZie4n3FG5q9brtdvs
         ELQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BYLH5NSOEjhPQlUl+Vzmbtv2wlt8Io26g6BkI1Bxjrg=;
        b=hytcU7ufKPK3E6NIm4GpKAvy0eYplHgpLbw4jj17eKxIWd4X03qaLuigIbteNcrAbi
         hyOq8SsgKjfYS8a7iWcq5V068UX9BxZXiFtivmL9sYKv/4Dt3W0r+aq6IhJuwmHhgCV1
         +nA++QNPdw5dEMWVfPa/gR2chofFOUSZsgNILLznU/I8NODcGfpi8KFIGy1jQXJJCh7p
         pG9zl5qor0KMHkcS7Joz/kdfd0Vavarvq6U2Vn2aDEaP4A4eO+KVW0uVhSldYwrRDfUf
         JairIi/DVIv+OFNQmVEBUSkAeSrhC7gHqftfjYj6TinSknEnVCvZuCCoN9GeatiwPYyQ
         2Xfw==
X-Gm-Message-State: AOAM5307Y2odNBb5XGrY46jXwycvEg37bvg1EgWsAc6WXXdcQQ09JME/
        9rMv7ykRVw31eRyjByvbUMw=
X-Google-Smtp-Source: ABdhPJyxYdMF/Rlw54j7sHL8H7vQQTDXQ0icZQzsdQKSQS+65woevZGx/SkICyzb2t+mnNq4pOfIYw==
X-Received: by 2002:a63:db01:: with SMTP id e1mr2213081pgg.38.1623887721254;
        Wed, 16 Jun 2021 16:55:21 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:39d5:aefe:1e71:33ef:30fb])
        by smtp.gmail.com with ESMTPSA id j9sm3003773pjy.25.2021.06.16.16.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 16:55:21 -0700 (PDT)
Date:   Thu, 17 Jun 2021 05:23:55 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] libbpf: add request buffer type for netlink messages
Message-ID: <20210616235351.ay3vj6gk36bpatgy@apollo>
References: <20210616170231.2194285-1-memxor@gmail.com>
 <CAEf4BzZTgMHVd2kEQ5vakgNSJYFB7uiY0j_NBGdG_xzmjKQTAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZTgMHVd2kEQ5vakgNSJYFB7uiY0j_NBGdG_xzmjKQTAA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 04:48:08AM IST, Andrii Nakryiko wrote:
> On Wed, Jun 16, 2021 at 10:04 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > Coverity complains about OOB writes to nlmsghdr. There is no OOB as we
> > write to the trailing buffer, but static analyzers and compilers may
> > rightfully be confused as the nlmsghdr pointer has subobject provenance
> > (and hence subobject bounds).
> >
> > Remedy this by using an explicit request structure, but we also need to
> > start the buffer in case of ifinfomsg without any padding. The alignment
> > on netlink wire protocol is 4 byte boundary, so we just insert explicit
>
> struct ifinfomsg has unsigned field in it, which makes it
> automatically 4-byte aligned because the struct is not packed. Do we
> really need that _pad[4] thing?.. Even if we do, I'm still not sure
> how it helps with alignment... If anything, explicit
> __attribute__((aligned(4))) would be better.
>

What I meant was that reusing the same struct for both means that the trailing
buffer where attributes are added starts right after struct tcmsg/struct
ifinfomsg. Since tcmsg is 20 bytes, ifinfomsg is 16. I didn't want it to trigger
if it ends up tracking the active member of the union (or effective type). Poor
wording I guess. Everything is aligned properly, just wanted to explain why
_pad[4] is there.

> > 4 byte buffer to avoid compilers throwing off on read and write from/to
> > padding.
> >
> > Also switch nh_tail (renamed to req_tail) to cast req * to char * so
>
> it probably should use (void *) everywhere, instead of (char *), but I
> see that existing code is using char * exclusively, so it's probably
> for another patch
>

I'll fix it in the resend.

> > that it can be understood as arithmetic on pointer to the representation
> > array (hence having same bound as request structure), which should
> > further appease analyzers.
> >
> > As a bonus, callers don't have to pass sizeof(req) all the time now, as
> > size is implicitly obtained using the pointer. While at it, also reduce
> > the size of attribute buffer to 128 bytes (132 for ifinfomsg using
> > functions due to the need to align buffer after it).
>
> Sorry if it's a stupid question, but why it's safe to reduce the
> buffer size from 128 to 256?
>

We just need something big enough, we already check the size everytime we add an
attribute to make sure we don't run out of space. It was a remnant from previous
versions where a lot of attributes were added. They're pretty limited now so I
just changed to a small safe value that works fine for both.

> >
> > Summary of problem:
> >   Even though C standard allows interconveritility of pointer to first
>
> s/interconveritility/interconvertibility/ ?
>
> >   member and pointer to struct, for the purposes of alias analysis it
> >   would still consider the first as having pointer value "pointer to T"
> >   where T is type of first member hence having subobject bounds,
> >   allowing analyzers within reason to complain when object is accessed
> >   beyond the size of pointed to object.
> >
> >   The only exception to this rule may be when a char * is formed to a
> >   member subobject. It is not possible for the compiler to be able to
> >   tell the intent of the programmer that it is a pointer to member
> >   object or the underlying representation array of the containing
> >   object, so such diagnosis is supressed.
>
> typo: suppressed
>

Thanks.

> >
> > Fixes: 715c5ce454a6 ("libbpf: Add low level TC-BPF management API")
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> > Changelog:
> > v1 -> v2:
> >  * Add short summary instead of links about the underlying issue (Daniel)
> > ---
> >  tools/lib/bpf/netlink.c | 107 +++++++++++++++-------------------------
> >  tools/lib/bpf/nlattr.h  |  37 +++++++++-----
> >  2 files changed, 65 insertions(+), 79 deletions(-)
> >
>
> [...]

--
Kartikeya
