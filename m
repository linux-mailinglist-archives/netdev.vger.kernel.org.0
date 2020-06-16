Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67A21FB5F8
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 17:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgFPPVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 11:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728809AbgFPPVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 11:21:13 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4CBC061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 08:21:13 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id dr13so21892757ejc.3
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 08:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EKtz2BiLRaNs/en12Y4ws5NFjh//UcfVP9zCkcU7gHs=;
        b=T2F05f4Mut8qMRptm/p7e9fs43JV4aM/iJWywIm0ofiAwGDxGLqtGOiChqA+rq/O3M
         hLecPN4Kq606UyZFTFwrRpohb4I7gRedjFmfk6n/4dSi3IK0KlO0yUQrJtoQJcZVGh9P
         /sxKaTrU7QTGe20E/MDcPliNU1+1HZI3+Ey4RvcBp6ej3hUV1PqpvSrS4CW/xEckQDbF
         UPNdFqZhWmfi8owcuVHDjob3R/GibofSUBcLpGbbSJImMztXTgkSpQNuJQkHQ2qSArks
         fH+bkUhvBNwOFo3F9H1YMFh/p6K3bInAHJsTNNJqO6+BZu1DtczuAjnEpGbYvV8PVAL9
         XrRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EKtz2BiLRaNs/en12Y4ws5NFjh//UcfVP9zCkcU7gHs=;
        b=ueXAl5qTWuJ9QtxUpGYHKAc+AlXdUaqJS+2XbDwq/moWildBUzoECVwivEAMRVdfOi
         rYBf66E0hNkVJQDsI56SivcTtk8aTgJe8Grqlar+JKkOcEyf3H6dGd/+koidemYTD7Vs
         QS/Nq2Hzy/N4eEklFrRUJluLDGIQ/XyAiQGADwr+0br9gP7BidhSb8rJhxXbxJwG0cpq
         W7SWXzCUp4T4OCRcCXuvvbofy7esnw6+qH8768kdshy/T5Lpqfu6LZ6NvbUChlj0ogw+
         RkR4+AmKT1hwxEPc3moqBQDMhIF9LRBXo34YutLqFTnpkjAOjqqrCnXE6Fnfeey+hYd5
         LglA==
X-Gm-Message-State: AOAM533Uk6EsAtQ8likhSi1WOHZ6sj6InrGL4AKe/IV/kk6NrPfBnu/M
        rw9WH0Z94bRP69Z68g0lVNioGYbPOYqk74kInXA=
X-Google-Smtp-Source: ABdhPJzKlwrEE1y/leUHOWa7wusyzAxQHfy/YxdohN5A+AvoY2MyZeIzrGa172HrOKW+Cstocmqxm0t18G3+oiJ2lT8=
X-Received: by 2002:a17:906:1d56:: with SMTP id o22mr3203048ejh.406.1592320871808;
 Tue, 16 Jun 2020 08:21:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1592247564.git.dcaratti@redhat.com> <4a4a840333d6ba06042b9faf7e181048d5dc2433.1592247564.git.dcaratti@redhat.com>
 <CA+h21ho1x1-N+HyFXcy+pqdWcQioFWgRs0C+1h+kn6w8zHVUwQ@mail.gmail.com>
 <fd20899c60d96695060ecb782421133829f09bc2.camel@redhat.com>
 <CA+h21hrCScMMA9cm0fhF+eLRWda403pX=t3PKRoBhkE8rrR-rw@mail.gmail.com>
 <429bc64106ac69c8291f4466ddbaa2b48b8e16c4.camel@redhat.com>
 <CA+h21hpL+7tuEX7_NCNo7NdgZ1OYqjQ03=DHuZ3aOOKh6Z4tsw@mail.gmail.com> <e9d84cd05ffb221d6a27fac2c7ea0d7d2bb212e5.camel@redhat.com>
In-Reply-To: <e9d84cd05ffb221d6a27fac2c7ea0d7d2bb212e5.camel@redhat.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 16 Jun 2020 18:21:00 +0300
Message-ID: <CA+h21hoPxCZC5vuRHN0avwXow71k_NOS6uuRQePzQO8Oq7oE7A@mail.gmail.com>
Subject: Re: [PATCH net v2 2/2] net/sched: act_gate: fix configuration of the
 periodic timer
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Po Liu <Po.Liu@nxp.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jun 2020 at 17:58, Davide Caratti <dcaratti@redhat.com> wrote:
>
> On Tue, 2020-06-16 at 17:23 +0300, Vladimir Oltean wrote:
> > > (but again, this would be a fix for 'entries' - not for 'hitimer', so I
> > > plan to work on it as a separate patch, that fits better 'net-next' rather
> > > than 'net').
> >
> > Targeting net-next would mean that the net tree would still keep
> > appending to p->entries upon action replacement, instead of just
> > replacing p->entries?
>
> well, this is the original act_gate behavior (and the bug is discovered
> today, in this thread). But if users can't wait for the proper fix (and
> equally important, for the tdc test file), I can think of sending the
> patch directly for 'net'.
>
> --
> davide
>

Well, it's up to you. Considering that your fixes here are for the 'tc
action replace' case, I guess you might as well go all the way and
make it work properly :)

Cheers,
-Vladimir
