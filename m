Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D993437693D
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 19:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbhEGRFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 13:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhEGRFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 13:05:53 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCC3C061574;
        Fri,  7 May 2021 10:04:52 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id h4so13765696lfv.0;
        Fri, 07 May 2021 10:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=As0+QF4TLvCwMjWlGqhQacwhIi2kfiM2nw4uGB7p4N8=;
        b=XaS8GacFeLZ9LdipAnAd9lmHMU5Bram4sJAXmI5tjXjuePToDyszeoER9rBD1jP5FD
         G/iFhdBDQYXfUfAdNRXVue+92PkBxExlxzlSXIbYo5gqqtqGDsjTtDaFXVQqCrSIAbbV
         f3NeLSg8WA1QDhql50+sz3vsfJEUQNRZsEEIfJKcSV6tjmaovZZhN60fod42kmSrf9Au
         LqzSdMGedlwI88yfdk95tBQIGuo5dRYgbseIbv7i0Ndt+EbBOBQEgnzKpzHzY5BV6NYP
         WttdkufC4r8Fn7J9E+XuKfSdQBYuu8smQs6s5t4/CuGKQyuOjhmqLJa9g5rtp8UaDJrJ
         JeZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=As0+QF4TLvCwMjWlGqhQacwhIi2kfiM2nw4uGB7p4N8=;
        b=VxKWhT7hTcehdIawdjHsjksmwKHybNu+kfxLzhy2LuyuktpsYPGRxGNvzNx7obOaaG
         tjdtVd2NVS7T3L4vgbr4AasjtNJyjoy1KKUFFV49Uq1DeBqoBa4CDcnhI2yF4uhsIDyf
         Sz/1BYanamzMWYgblnJega0mgPrgg27+CK4QDkZV2PvC0r1jJRcOwHvWcW1XYwlF1RmV
         r6otACSbOElMF5GHQdT7+Vu9IDEoFZeBATuZxHuz7Pc50luTPSyFDp3mxHhMafZyxGnX
         gdQeAlPiICkF/pSo5mvwYeCv0r+agjMvs8E3V9Y+Kp8iyckdJBN/fLqTPpsViBJhlMNr
         KfhA==
X-Gm-Message-State: AOAM533xINdyl2rLs1034YX5pisnTMQt1W6zCs6HVdByYQ28tg+j9K4+
        rpRW77X4LuyA+IIUG6MUvga6MKahPfUxl7pmHcQ=
X-Google-Smtp-Source: ABdhPJyNW4Va1Nx97/p0bkdWKZm1kMh8BbHdHom7nIdyBuEQj8avc+yZs0hyZEoSNPZlzEZ4Hw9AXU9VHivTMhxw+dc=
X-Received: by 2002:a19:5508:: with SMTP id n8mr7115859lfe.542.1620407091091;
 Fri, 07 May 2021 10:04:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAOWid-c4Nk717xUah19B=z=2DtztbtU=_4=fQdfhqpfNJYN2gw@mail.gmail.com>
 <CAKMK7uFEhyJChERFQ_DYFU4UCA2Ox4wTkds3+GeyURH5xNMTCA@mail.gmail.com>
 <CAOWid-fL0=OM2XiOH+NFgn_e2L4Yx8sXA-+HicUb9bzhP0t8Bw@mail.gmail.com>
 <YJUBer3wWKSAeXe7@phenom.ffwll.local> <CAOWid-dmRsZUjF3cJ8+mx5FM9ksNQ_P9xY3jqxFiFMvN29SaLw@mail.gmail.com>
 <YJVnO+TCRW83S6w4@phenom.ffwll.local> <CADnq5_Pvtj1vb0bak_gUkv9J3+vfsMZxVKTKYeUvwQCajAWoVQ@mail.gmail.com>
 <YJVqL4c6SJc8wdkK@phenom.ffwll.local> <CADnq5_PHjiHy=Su_1VKr5ycdnXN-OuSXw0X_TeNqSj+TJs2MGA@mail.gmail.com>
 <CADnq5_OjaPw5iF_82bjNPt6v-7OcRmXmXECcN+Gdg1NcucJiHA@mail.gmail.com> <YJVwtS9XJlogZRqv@phenom.ffwll.local>
In-Reply-To: <YJVwtS9XJlogZRqv@phenom.ffwll.local>
From:   Kenny Ho <y2kenny@gmail.com>
Date:   Fri, 7 May 2021 13:04:39 -0400
Message-ID: <CAOWid-fRgjuY46KA-HBbEfhfwsWvDyhkp+iwZq=wA1h+Uix32g@mail.gmail.com>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Alex Deucher <alexdeucher@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kenny Ho <Kenny.Ho@amd.com>,
        "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
        Brian Welty <brian.welty@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Network Development <netdev@vger.kernel.org>,
        KP Singh <kpsingh@chromium.org>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 7, 2021 at 12:54 PM Daniel Vetter <daniel@ffwll.ch> wrote:
>
> SRIOV is kinda by design vendor specific. You set up the VF endpoint, it
> shows up, it's all hw+fw magic. Nothing for cgroups to manage here at all.
Right, so in theory you just use the device cgroup with the VF endpoints.

> All I meant is that for the container/cgroups world starting out with
> time-sharing feels like the best fit, least because your SRIOV designers
> also seem to think that's the best first cut for cloud-y computing.
> Whether it's virtualized or containerized is a distinction that's getting
> ever more blurry, with virtualization become a lot more dynamic and
> container runtimes als possibly using hw virtualization underneath.
I disagree.  By the same logic, the existence of CU mask would imply
it being the preferred way for sub-device control per process.

Kenny
