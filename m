Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D68F3AA82F
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 02:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbhFQAjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 20:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhFQAjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 20:39:22 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FFEC061574;
        Wed, 16 Jun 2021 17:37:14 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id i4so5657752ybe.2;
        Wed, 16 Jun 2021 17:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s/MftNWp7UjUY3GozYYRx7zsjlmxoB5ndUhk9sHpAG4=;
        b=rIb1bOSvrUwoCdjSZmDDF9r/Om95sIHnwFBSNW7sTCpHJ2YuFN1cpUozjGdAiEEpIQ
         hgZuZSqeHWVzgbbls+xWApwgT3FmRboCs0QFJVvztPE/fpL9t3vp+ZjpnKgBYnQR5OCb
         w8wATYbgPgcilCpGrlMXw0aLaSyxyF4gjf7p3yMoEu3tPdVz2VgCiPJz8t03cnXPIKXt
         0ABxfroyc5/xf9buEI+3Sf6ej/YOZfgCCt3bBVe0MCOM31ZZGAWHB+eWOGGYirWxNoAW
         F5GWUQAAuCN1OTACbhXhHjehVwQJ4QXILcKh1rG5DKf0hVlMZ9GwPmQQqaWShhDkZOvc
         JbQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s/MftNWp7UjUY3GozYYRx7zsjlmxoB5ndUhk9sHpAG4=;
        b=dfU6sd0yM4gTTLnx/n9PPbBKfKWmcFT5kwzjavDjJtqZEV8uE8qeRJgt6wZOhoHuBg
         uMOHCktQk27pD4sQe2+qSdYj9fBvUV6RJ1h/zH61vPqZTuAWVWMD2yTSF1r9ECEqogmc
         zAaqLNtucUzOzU5F1MdXRRkv3/ycuSz0VcILOSzjivEpTV/EeQKJvp6uzA+ODFASXMuf
         gefBp0cLPPEgq2G8y7SUHqTRu8j+4+s6Uj+bkwOPbGavxFV7iLq+k3fPRYce3v4u/Z3D
         s4V7L1MxzHKcTupCo8nN0uzBMUKXeQmpGSAXAmio4mbFudUtnpJQz8QJbY2v1OVYKyqU
         5bTw==
X-Gm-Message-State: AOAM533JJWa4DYbdGrpdbEl0E6HApBQP/KAI6OILDujCYlw3PKurl5nc
        3nmRUHPYkV+VmaKL8r8Y/etuMBWvent1AjMK80Q=
X-Google-Smtp-Source: ABdhPJyy65L0SdI3LhJvoAhhfVIaNSF80qkxhxSeCtIHd/KjECsN5gyec4/EdjyECtbjO8kQQ4ygpJOSh0juhMFqRXk=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr2267311ybg.459.1623890234145;
 Wed, 16 Jun 2021 17:37:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210616170231.2194285-1-memxor@gmail.com> <CAEf4BzZTgMHVd2kEQ5vakgNSJYFB7uiY0j_NBGdG_xzmjKQTAA@mail.gmail.com>
 <20210616235351.ay3vj6gk36bpatgy@apollo>
In-Reply-To: <20210616235351.ay3vj6gk36bpatgy@apollo>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Jun 2021 17:37:02 -0700
Message-ID: <CAEf4BzaNZvVETi7YXUB34kOu91-3OJgXS6BFyoaH1mkzJtzohQ@mail.gmail.com>
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

On Wed, Jun 16, 2021 at 4:55 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Thu, Jun 17, 2021 at 04:48:08AM IST, Andrii Nakryiko wrote:
> > On Wed, Jun 16, 2021 at 10:04 AM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > Coverity complains about OOB writes to nlmsghdr. There is no OOB as we
> > > write to the trailing buffer, but static analyzers and compilers may
> > > rightfully be confused as the nlmsghdr pointer has subobject provenance
> > > (and hence subobject bounds).
> > >
> > > Remedy this by using an explicit request structure, but we also need to
> > > start the buffer in case of ifinfomsg without any padding. The alignment
> > > on netlink wire protocol is 4 byte boundary, so we just insert explicit
> >
> > struct ifinfomsg has unsigned field in it, which makes it
> > automatically 4-byte aligned because the struct is not packed. Do we
> > really need that _pad[4] thing?.. Even if we do, I'm still not sure
> > how it helps with alignment... If anything, explicit
> > __attribute__((aligned(4))) would be better.
> >
>
> What I meant was that reusing the same struct for both means that the trailing
> buffer where attributes are added starts right after struct tcmsg/struct
> ifinfomsg. Since tcmsg is 20 bytes, ifinfomsg is 16. I didn't want it to trigger
> if it ends up tracking the active member of the union (or effective type). Poor
> wording I guess. Everything is aligned properly, just wanted to explain why
> _pad[4] is there.

How

struct libbpf_nla_req {
       struct nlmsghdr nh;
       union {
               struct {
                       struct ifinfomsg ifinfo;
                       char _pad[4];
               };
               struct tcmsg tc;
       };
       char buf[128];
};

has different memory layout from just

struct libbpf_nla_req {
       struct nlmsghdr nh;
       union {
               struct ifinfomsg ifinfo;
               struct tcmsg tc;
       };
       char buf[128];
};


That _pad[4] just adds to confusion, IMO. Just trust the language and
its handling of union?..


>
> > > 4 byte buffer to avoid compilers throwing off on read and write from/to
> > > padding.
> > >
> > > Also switch nh_tail (renamed to req_tail) to cast req * to char * so
> >
> > it probably should use (void *) everywhere, instead of (char *), but I
> > see that existing code is using char * exclusively, so it's probably
> > for another patch
> >
>
> I'll fix it in the resend.
>
> > > that it can be understood as arithmetic on pointer to the representation
> > > array (hence having same bound as request structure), which should
> > > further appease analyzers.
> > >
> > > As a bonus, callers don't have to pass sizeof(req) all the time now, as
> > > size is implicitly obtained using the pointer. While at it, also reduce
> > > the size of attribute buffer to 128 bytes (132 for ifinfomsg using
> > > functions due to the need to align buffer after it).
> >
> > Sorry if it's a stupid question, but why it's safe to reduce the
> > buffer size from 128 to 256?
> >
>
> We just need something big enough, we already check the size everytime we add an
> attribute to make sure we don't run out of space. It was a remnant from previous
> versions where a lot of attributes were added. They're pretty limited now so I
> just changed to a small safe value that works fine for both.
>
> > >
> > > Summary of problem:
> > >   Even though C standard allows interconveritility of pointer to first
> >
> > s/interconveritility/interconvertibility/ ?
> >
> > >   member and pointer to struct, for the purposes of alias analysis it
> > >   would still consider the first as having pointer value "pointer to T"
> > >   where T is type of first member hence having subobject bounds,
> > >   allowing analyzers within reason to complain when object is accessed
> > >   beyond the size of pointed to object.
> > >
> > >   The only exception to this rule may be when a char * is formed to a
> > >   member subobject. It is not possible for the compiler to be able to
> > >   tell the intent of the programmer that it is a pointer to member
> > >   object or the underlying representation array of the containing
> > >   object, so such diagnosis is supressed.
> >
> > typo: suppressed
> >
>
> Thanks.
>
> > >
> > > Fixes: 715c5ce454a6 ("libbpf: Add low level TC-BPF management API")
> > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > ---
> > > Changelog:
> > > v1 -> v2:
> > >  * Add short summary instead of links about the underlying issue (Daniel)
> > > ---
> > >  tools/lib/bpf/netlink.c | 107 +++++++++++++++-------------------------
> > >  tools/lib/bpf/nlattr.h  |  37 +++++++++-----
> > >  2 files changed, 65 insertions(+), 79 deletions(-)
> > >
> >
> > [...]
>
> --
> Kartikeya
