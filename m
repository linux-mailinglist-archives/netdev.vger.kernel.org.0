Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECA0369AE4
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 21:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232378AbhDWT22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 15:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbhDWT20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 15:28:26 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD0DC06174A
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 12:27:48 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id x12so54687181ejc.1
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 12:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GGmswUWs0RhjLm11KvpLJnLg6G3DSRO1QkIM1fXbk7s=;
        b=02tLZjLeYkxGPB2kXMhpJATnGAtGmYPsmzTboVgl/LmG2WbReuSJpJrPlxJd90ALKR
         97sPdAcYuV4/oaDQXmOwIgdjD3nkc+vwW8/gPUaZkaeqTEC94+s9E0R4OCZ0ig8W1+nl
         nqyN38L7dwd2RMuWYF5cioO9XPfvVR8M4cdSiNRh2SX+d3OdOTrXdAsX8ksUKHDvZ72w
         waDXwP7pSE48qNSKfm0IAeh4BaI4PqR+hSTGCwLYYApnxxeImRsdoFWDHwFXJVBi+Q3C
         zRKDs+BLZ0nrlPvvpF+sufIB8MBeGS7GtuL2Al6hW3uvcCJLJ1xC0gcUtMBvVM0hyzO2
         HqhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GGmswUWs0RhjLm11KvpLJnLg6G3DSRO1QkIM1fXbk7s=;
        b=ljpG0ouTAIvQLn8VCnddYJazQo3i3LlZQhKGQtesO83apc7Vipz59kzO+/nIL9Yc0z
         zRw9JLuseSd2n3zysVX795E75zCuiJI8ZJa5BAYwso282iRjgaRMmg1X9iBFYfMS8ocV
         LnEwvHIqSNTlBmEBb6XbyUYyn1JQn24Hey/4PiICgQKmew5KNMOrERnznY/lG6OJi+iB
         6Ood3rUXhIvnd1cDe3GmQ4RPp7aH5plq8iyQcxA29p1z+YTEBNNc4Sj+5lH0izqT0XY2
         1+mkkJN2patqRiTA+cVbix9+dk27L9qsTcIwYGid5aypkGiD81di1+0bIgHevAyDGDBf
         RdSA==
X-Gm-Message-State: AOAM531hpWtrRxYt7Ob0vuKCrij+QFahZ/+dRYg504x7QaGFG4VC1zi9
        RXboMl0emuRkJUCp05m2/vOYDnb6zVWL0NXKgcWR
X-Google-Smtp-Source: ABdhPJxFunO8u/UyY8hB3Vbeq+g3Smp6PbgP4kttDr+81dktNKM4DKLyCDErbfUfCB/j8VqV43lTQ0UFMkx/w+QTI+E=
X-Received: by 2002:a17:906:f283:: with SMTP id gu3mr5825341ejb.91.1619206066758;
 Fri, 23 Apr 2021 12:27:46 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000307cc205bbbf31d3@google.com> <29f03460-c0ba-07a0-ef98-9597ef157797@oracle.com>
In-Reply-To: <29f03460-c0ba-07a0-ef98-9597ef157797@oracle.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 23 Apr 2021 15:27:35 -0400
Message-ID: <CAHC9VhSKtS7syw51S8=KOFNu-NSyV5vw+uyr50KexBKW_QAP_w@mail.gmail.com>
Subject: Re: WARNING in netlbl_cipsov4_add
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     syzbot <syzbot+cdd51ee2e6b0b2e18c0d@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 6:47 AM Vegard Nossum <vegard.nossum@oracle.com> wr=
ote:
> Hi Paul,
>
> This syzbot report reproduces in mainline for me and it looks like
> you're the author/maintainer of this code, so I'm just adding some info
> to hopefully aid the preparation of a fix:

Hi Vegard,

Yes, you've come to the right place, thank you for your help in
tracking this down.  Some comments and initial thoughts below ...

> On 2021-02-20 08:05, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:

...

> Running strace on the reproducer says:
>
> socket(PF_NETLINK, SOCK_RAW, NETLINK_GENERIC) =3D 3
> socket(PF_NETLINK, SOCK_RAW, NETLINK_GENERIC) =3D 4
> sendto(4,
> "(\0\0\0\20\0\5\0\0\0\0\0\0\0\0\0\3\0\0\0\21\0\2\0NLBL_CIPSOv4\0\0\0\0",
> 40, 0, {sa_family=3DAF_NETLINK, pid=3D0, groups=3D00000000}, 12) =3D 40
> recvfrom(4,
> "\234\0\0\0\20\0\0\0\0\0\0\0\f\r\0\0\1\2\0\0\21\0\2\0NLBL_CIPSOv4\0\0\0\0=
\6\0\1\0\24\0\0\0\10\0\3\0\3\0\0\0\10\0\4\0\0\0\0\0\10\0\5\0\f\0\0\0T\0\6\0=
\24\0\1\0\10\0\1\0\1\0\0\0\10\0\2\0\v\0\0\0\24\0\2\0\10\0\1\0\2\0\0\0\10\0\=
2\0\v\0\0\0\24\0\3\0\10\0\1\0\3\0\0\0\10\0\2\0\n\0\0\0\24\0\4\0\10\0\1\0\4\=
0\0\0\10\0\2\0\f\0\0\0",
> 4096, 0, NULL, NULL) =3D 156
> recvfrom(4,
> "$\0\0\0\2\0\0\0\0\0\0\0\f\r\0\0\0\0\0\0(\0\0\0\20\0\5\0\0\0\0\0\0\0\0\0"=
,
> 4096, 0, NULL, NULL) =3D 36
> sendmsg(3, {msg_name(0)=3DNULL,
> msg_iov(1)=3D[{"T\0\0\0\24\0\1\0\0\0\0\0\0\0\0\0\1\0\0\0,\0\10\200\34\0\7=
\200\10\0\5\0\3608)
> \10\0\6\0\0\0\0\0\10\0\6\0\0\0\0\0\f\0\7\200\10\0\5\0\0\0\0\0\4\0\4\200\1=
0\0\1\0\0\0\0\0\10\0\2\0\1\0\0\0",
> 84}], msg_controllen=3D0, msg_flags=3D0}, 0) =3D 84
>
> We're ending up in netlbl_cipsov4_add() with CIPSO_V4_MAP_TRANS, so it
> calls netlbl_cipsov4_add_std() where this is the problematic allocation:
>
> doi_def->map.std->lvl.local =3D kcalloc(doi_def->map.std->lvl.local_size,
>                                        sizeof(u32),
>                                        GFP_KERNEL);
>
> It looks like there is already a check on the max size:
>
> if (nla_get_u32(nla_b) >
>      CIPSO_V4_MAX_LOC_LVLS)
>          goto add_std_failure;
> if (nla_get_u32(nla_b) >=3D
>      doi_def->map.std->lvl.local_size)
>       doi_def->map.std->lvl.local_size =3D
>               nla_get_u32(nla_b) + 1;
>
> However, the limit is quite generous:
>
> #define CIPSO_V4_INV_LVL              0x80000000
> #define CIPSO_V4_MAX_LOC_LVLS         (CIPSO_V4_INV_LVL - 1)
>
> so maybe a fix would just lower this to something that agrees with the
> page allocator?

Hmm, I agree that from a practical point of view the limit does seem
high.  The issue is that I'm not sure we have an easy way to determine
an appropriate local limit considering that it is determined by the
LSM and in some cases it is determined by the LSM's loaded policy.  On
the plus side you need privilege to get this far in the code so the
impact is minimized, although we still should look into catching this
prior to the WARN_ON_ONCE() in __alloc_pages_nodemask().  If nothing
else it allows the fuzzers to keep making progress and not die here.

We could drop CIPSO_V4_MAX_LOC_LVLS to an arbitrary value, or better
yet make it a sysctl (or similar), but that doesn't feel right and I'd
prefer to not create another runtime config knob if we don't have to
do so.  Is there a safe/stable way to ask the allocator what size is
*too* big?  That might be a better solution as we could catch it in
the CIPSO code and return an error before calling kmalloc.  I'm not a
mm expert, but looking through include/linux/slab.h I wonder if we
could just compare the allocation size with KMALLOC_SHIFT_MAX?  Or is
that still too big?

> At first glance it may appear like there is a similar issue with
> doi_def->map.std->lvl.cipso_size, but that one looks restricted to a
> saner limit of CIPSO_V4_MAX_REM_LVLS =3D=3D 255. It's probably better to
> double check both in case I read this wrong.

This one is a bit easier, that limit is defined by the CIPSO protocol
and we really shouldn't change that.

FWIW, I would expect that we would have a similar issue with the
CIPSO_V4_MAX_LOC_CATS check in the same function.  My initial thinking
is that we can solve it in the same manner as the
CIPSO_V4_MAX_LOC_LVLS fix.

--=20
paul moore
www.paul-moore.com
