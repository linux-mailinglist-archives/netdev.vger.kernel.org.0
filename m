Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1731E2DCBD5
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 06:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgLQFHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 00:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgLQFHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 00:07:35 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EC0C061794;
        Wed, 16 Dec 2020 21:06:55 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id p18so7923779pgm.11;
        Wed, 16 Dec 2020 21:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a7OiJrsklst7aG4Q3TdBEgbeMJcuTcoKllnjNyFS4uI=;
        b=gB8Mgko12WNtUqNOb0XN6bwaat5VGZW8/SsYjD5BEa8HugV+CKEXT++7ORe0izxou+
         GzcAHO05mpev/zhEX7vUelAt70DnhnPQXBtzX/gWwHLyaNFUGpB7OKnjnUZjOS0QJrId
         f06+AgqUAtusTWzQ55grIs8DKVwDJ7hsrgA/6Qud/pYab9hp5JR65xBLsz7dKhQdk41S
         ahOswwbZi3uTUjXCMdd2/XwoPvB9PL6SFOODTUMhjbkLrrEN38uMGg47SWWWcA1hkbiO
         yHUxr787VsJnz+sp7BO9zMaSQgKimsOsH7nXuCwrd/zQer/jMRyzvN5NPWGcpzAWbgzB
         WE/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a7OiJrsklst7aG4Q3TdBEgbeMJcuTcoKllnjNyFS4uI=;
        b=CEzZfemGl8CUkmIRyEVkAvzVLitSHHxrRl7xvYls7UkUxv1i0vZyY5mFRcdSMoiiic
         tv5igtWOLIpG8nPs1kBh0DtcHs3hPUoTfRYY7irTunEgNoeMxVA7oPa0ljhVDWOftgOl
         svHkmqDqyRlzico5Gi2YR8LuNk4mzBdaYl6USC6oa59GA8eP4Q55w3x076/4Ah2aOzBQ
         UshybTbNaBPzthDBsdVQ7kn6VS/iSwY2S67y+MPIEF6RBwKM5VgPq+Ezg1L0LfPf5DY3
         Jyb5xjMo8t3qUnxvMe60nudz+DrTbSkcsYsd2Qg2WHME14z0dK2LqdDUTK6urPg94RSo
         hkCQ==
X-Gm-Message-State: AOAM5320XDZ74FcEXVRL02wPV/COyd/nwbefaEZQQzFMHt17EDUs0zJg
        Ka3bbpm3SprQjUoy/Wm1rUKFQgZmALSDO/Uv1Cw=
X-Google-Smtp-Source: ABdhPJyC02nMnCsWO2h5mc0EPYtwk+v3eXk41+nJeppMTe3M2+qlSW6mOh8XsatUBpeDfFs13rtZVvOwQ5PAmUkVr08=
X-Received: by 2002:a62:808d:0:b029:19e:b084:d5b0 with SMTP id
 j135-20020a62808d0000b029019eb084d5b0mr24806204pfd.80.1608181614613; Wed, 16
 Dec 2020 21:06:54 -0800 (PST)
MIME-Version: 1.0
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
 <20201214201118.148126-3-xiyou.wangcong@gmail.com> <CAEf4BzZa15kMT+xEO9ZBmS-1=E85+k02zeddx+a_N_9+MOLhkQ@mail.gmail.com>
 <CAM_iQpVR_owLgZp1tYJyfWco-s4ov_ytL6iisg3NmtyPBdbO2Q@mail.gmail.com>
 <CAEf4BzbyHHDrECCEjrSC3A5X39qb_WZaU_3_qNONP+vHAcUzuQ@mail.gmail.com>
 <1de72112-d2b8-24c5-de29-0d3dfd361f16@iogearbox.net> <CAM_iQpVedtfLLbMroGCJuuRVrBPoVFgsLkQenTrwKD8uRft2wQ@mail.gmail.com>
 <20201216011422.phgv4o3jgsrg33ob@ast-mbp> <CAM_iQpVJLg5yCF=2w3ZpBBiR3pR4FWSNjz7FvJGqx0R+BomWDw@mail.gmail.com>
 <CAADnVQL70bVdms6_D_ep1L2v-OcgXu-9KTtLULQdfCMftLhENQ@mail.gmail.com>
In-Reply-To: <CAADnVQL70bVdms6_D_ep1L2v-OcgXu-9KTtLULQdfCMftLhENQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 16 Dec 2020 21:06:43 -0800
Message-ID: <CAM_iQpU4ULPqo60o7CuZqqqdrybkqNd5GNufep57UhBpmMGuPg@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/5] bpf: introduce timeout map
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 6:35 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Dec 15, 2020 at 6:10 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > Sure, people also implement CT on native hash map too and timeout
> > with user-space timers. ;)
>
> exactly. what's wrong with that?
> Perfectly fine way to do CT.

Seriously? When we have 8 millions of entries in a hash map, it is
definitely seriously wrong to purge entries one by one from user-space.

In case you don't believe me, take a look at what cilium CT GC does,
which is precisely expires entries one by one in user-space:

https://github.com/cilium/cilium/blob/0f57292c0037ee23ba1ca2f9abb113f36a664645/pkg/bpf/map_linux.go#L728
https://github.com/cilium/cilium/blob/master/pkg/maps/ctmap/ctmap.go#L398

and of course what people complained:

https://github.com/cilium/cilium/issues/5048

>
> > > Anything extra can be added on top from user space
> > > which can easily copy with 1 sec granularity.
> >
> > The problem is never about granularity, it is about how efficient we can
> > GC. User-space has to scan the whole table one by one, while the kernel
> > can just do this behind the scene with a much lower overhead.
> >
> > Let's say we arm a timer for each entry in user-space, it requires a syscall
> > and locking buckets each time for each entry. Kernel could do it without
> > any additional syscall and batching. Like I said above, we could have
> > millions of entries, so the overhead would be big in this scenario.
>
> and the user space can pick any other implementation instead
> of trivial entry by entry gc with timer.

Unless they don't have to, right? With timeout implementation in kernel,
user space does not need to invent any wheel.


>
> > > Say the kernel does GC and deletes htab entries.
> > > How user space will know that it's gone? There would need to be
> >
> > By a lookup.
> >
> > > an event sent to user space when entry is being deleted by the kernel.
> > > But then such event will be racy. Instead when timers and expirations
> > > are done by user space everything is in sync.
> >
> > Why there has to be an event?
>
> because when any production worthy implementation moves
> past the prototype stage there is something that user space needs to keep
> as well. Sometimes the bpf map in the kernel is alone.
> But a lot of times there is a user space mirror of the map in c++ or golang
> with the same key where user space keeps extra data.

So... what event does LRU map send when it deletes a different entry
when the map is full?

Thanks.
