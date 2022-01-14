Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0B548E269
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 03:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236067AbiANCJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 21:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiANCJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 21:09:49 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0F3C061574;
        Thu, 13 Jan 2022 18:09:48 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id c6so3579284plh.6;
        Thu, 13 Jan 2022 18:09:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XpJbac53fRpSunCAh1w84QujJ1RBhEaDKayiX5UID/w=;
        b=LyYkVONhDx4r6c1AwSyDkBCogwgYo7jfSC5GXFv/PH7IvzWMxRg9D/xfBBDgfbFGzX
         DHkEyRMacTi9Vv+VBYvU+48XOCWMAa1DMfwHVAP1fj8HDqWdHytxY51QwZIHv6K9gf9L
         62sZJdW2csKqcfZPx2s6uX/rmSbYBAOonjCc1u2Y5xzLorpeRTDt5yXuA6FdbCVcw0RD
         NvxXVe6vEiFEBbVUGLOZKzRWIlY4YKFZVEJczljl+hmMDrisag7FQuhy5fojzYFCbqR8
         waeHteYMIOq2Kn0ndhuQWGF2G7nCH5B5vvp3vYmjkhnfkC3ASJcEXuHxDn48Yn2jlD6q
         jFQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XpJbac53fRpSunCAh1w84QujJ1RBhEaDKayiX5UID/w=;
        b=Wpn2D+aY9u9KMuDEswX7hJr3MFq/f3ISf/Cuw8G/0VeOALaNg/5tAxwgNuTRRigXYL
         1uV1nnMMSbVnmL9EBR6GCBclrq0gpYXdyTyLLXXb2Kjed/Nf/BVjVAU6C04ABGJf0ovy
         FKeEq0a1pQx+nT0HAzgcVGcD7DXEDZZG7DJn6k7J0j3m2wQg1Y1ETMop+vLzxz4FPp22
         TEWfVvDC1zC+tEofJXPmLoDJjFVNdQQKkEn0/dhtB0U9FUmKPUo7BUZitduGSGxhkq9V
         rz5CqQLmQqyDMdAzHKvFec2NJdeRK42IPHXbkJUNXIUSod5tQc2RQ7rn+SHC/6QgYSPA
         PKOw==
X-Gm-Message-State: AOAM533zt7hQiLIEUg6+q9Li9/3HXlV6unawXYh/A2GC5mAfQX0oEyNC
        WJWrYMsZKRuBJpdK+W54C1aLrfeIbyjVNW9l0a4PlIz8TeQ=
X-Google-Smtp-Source: ABdhPJww454elzu3ylVj2V6Fuz3l2o0RkPpE0EJjdIGmKiqeoRcnSWi6aa4Ckx3RMKyybtvsfB0hAYAmvV+FuGh7cv8=
X-Received: by 2002:a17:902:ec82:b0:14a:30bd:94bf with SMTP id
 x2-20020a170902ec8200b0014a30bd94bfmr7483680plg.78.1642126188143; Thu, 13 Jan
 2022 18:09:48 -0800 (PST)
MIME-Version: 1.0
References: <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
 <CAADnVQLGxjvOO3Ae3mGTWTyd0aHnACxYoF8daNi+z56NQyYQug@mail.gmail.com>
 <CAEf4BzZ4c1VwPf9oBRRdN7jdBWrk4pg=mw_50LMjLr99Mb0yfw@mail.gmail.com>
 <CAADnVQ+BiMy4TZNocfFSvazh-QTFwMD-3uQ9LLiku7ePLDn=MQ@mail.gmail.com>
 <CAC1LvL0CeTw+YKjO6r0f68Ly3tK4qhDyjV0ak82e0PpHURVQOw@mail.gmail.com>
 <Yd82J8vxSAR9tvQt@lore-desk> <8735lshapk.fsf@toke.dk> <47a3863b-080c-3ac2-ff2d-466b74d82c1c@redhat.com>
 <Yd/9SPHAPH3CpSnN@lore-desk> <CAADnVQJaB8mmnD1Z4jxva0CqA2D0aQDmXggMEQPX2MRLZvoLzA@mail.gmail.com>
 <YeC8sOAeZjpc4j8+@lore-desk>
In-Reply-To: <YeC8sOAeZjpc4j8+@lore-desk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 13 Jan 2022 18:09:36 -0800
Message-ID: <CAADnVQ+=0k1YBbkMmSKSBtkmiG8VCYZ5oKGjPPr4s9c53QF-mQ@mail.gmail.com>
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb programs
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Zvi Effron <zeffron@riotgames.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        john fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 3:58 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >
> > Btw "xdp_cpumap" should be cleaned up.
> > xdp_cpumap is an attach type. It's not prog type.
> > Probably it should be "xdp/cpumap" to align with "cgroup/bind[46]" ?
>
> so for xdp "mb" or xdp "frags" it will be xdp/cpumap.mb (xdp/devmap.mb) or
> xdp/cpumap.frags (xdp/devmap.frags), right?

xdp.frags/cpumap
xdp.frags/devmap

The current de-facto standard for SEC("") in libbpf:
prog_type.prog_flags/attach_place

"attach_place" is either function_name for fentry/, tp/, lsm/, etc.
or attach_type/hook/target for cgroup/bind4, cgroup_skb/egress.

lsm.s/socket_bind -> prog_type = LSM, flags = SLEEPABLE
lsm/socket_bind -> prog_type = LSM, non sleepable.
