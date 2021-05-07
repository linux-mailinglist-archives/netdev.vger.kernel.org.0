Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C90A375EAF
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 04:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbhEGCHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 22:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbhEGCHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 22:07:45 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67330C061574;
        Thu,  6 May 2021 19:06:45 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id c3so10606096lfs.7;
        Thu, 06 May 2021 19:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RusZqf2ICrM5fo1RSYd7Qden8l8w86x5qFZgmckN64E=;
        b=D3bvz8i81tQkrtuQ+d1bkqIKoTdXAZWYYo6Jfm6wspflRIADJqkHwK3Tng54nv8L8j
         kIUQ4Gd1GX0Mm3MGVRY/Cv0CqOQ2b/SwKrjuqKQ2ZLb42V5VpGDH8k9zdxW5F8jvJyfa
         oLTIlByZ21h77IN3GiYOi8DRoH5svGBcNiKp/hCtXMH1J7nhMihzdzDioSOcRJ0RARol
         OVt144Jx1rzUTkCU0vW3daSLf0owrtC0yAdtvCT57MQoOyn7OYD0UppOnItgNU2aQ3lA
         twFeOWFtx02nENFd16Y5AUuwOe/mWTYJiHeGA8pGRIoA8ogpgcLuy5gafsmAh3Y1WSVg
         /i3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RusZqf2ICrM5fo1RSYd7Qden8l8w86x5qFZgmckN64E=;
        b=dzuxIb/VclAj0yuogmf83ZBHjsGXgzGOAb+4ttOOxilWONS43VClxKPlgYsfkFF4u5
         2k/Yu3C2OHTXpIbSRL0NbPiM6/TIB6teAXptwnX/A8a4nHCnKs4fcTAzotN3wNKZCrLE
         8aUXNhEITHqlpU/dCNAhzO8NQ+pbyDARoePv7bF4fWaElOBEkXUBQHJx6YNSnqNT3StM
         UepwSojD7kTtujo8O8Wpcc7nDmFR9LqB5GpMpAMf7aqiPl/P9ydH/TeUOhXRt4oxeCDq
         Wb8tR2aCGLb/mPI1PBRtb67qXvduxNg65AoBuGRenGLjXTenPEc4QBtz8D91M65H4Acz
         1TRw==
X-Gm-Message-State: AOAM532XhTld0J+XddjiBblcuDXrtcRo36oLpmTsO/aFgzmROe1slAJq
        ZfheZ+YJVDtHfYxUr+U+ZMlfcRx7lLRh1XFfvk4=
X-Google-Smtp-Source: ABdhPJy6fE0F0maDDYRJg2QRG950fLRhaA0QiW7C6vG6nsHx3tC0UfW9AmOOCNLGEB8W9gmuKKolcqYX/UZkgFF0HoM=
X-Received: by 2002:a05:6512:c04:: with SMTP id z4mr4820989lfu.167.1620353203882;
 Thu, 06 May 2021 19:06:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
 <20201103053244.khibmr66p7lhv7ge@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-eQSPru0nm8+Xo3r6C0pJGq+5r8mzM8BL2dgNn2c9mt2Q@mail.gmail.com>
 <CAADnVQKuoZDB-Xga5STHdGSxvSP=B6jQ40kLdpL1u+J98bv65A@mail.gmail.com>
 <CAOWid-czZphRz6Y-H3OcObKCH=bLLC3=bOZaSB-6YBE56+Qzrg@mail.gmail.com>
 <20201103210418.q7hddyl7rvdplike@ast-mbp.dhcp.thefacebook.com>
 <CAOWid-djQ_NRfCbOTnZQ-A8Pr7jMP7KuZEJDSsvzWkdw7qc=yA@mail.gmail.com>
 <20201103232805.6uq4zg3gdvw2iiki@ast-mbp.dhcp.thefacebook.com>
 <YBgU9Vu0BGV8kCxD@phenom.ffwll.local> <CAOWid-eXMqcNpjFxbcuUDU7Y-CCYJRNT_9mzqFYm1jeCPdADGQ@mail.gmail.com>
 <YBqEbHyIjUjgk+es@phenom.ffwll.local> <CAOWid-c4Nk717xUah19B=z=2DtztbtU=_4=fQdfhqpfNJYN2gw@mail.gmail.com>
 <CAKMK7uFEhyJChERFQ_DYFU4UCA2Ox4wTkds3+GeyURH5xNMTCA@mail.gmail.com>
In-Reply-To: <CAKMK7uFEhyJChERFQ_DYFU4UCA2Ox4wTkds3+GeyURH5xNMTCA@mail.gmail.com>
From:   Kenny Ho <y2kenny@gmail.com>
Date:   Thu, 6 May 2021 22:06:32 -0400
Message-ID: <CAOWid-fL0=OM2XiOH+NFgn_e2L4Yx8sXA-+HicUb9bzhP0t8Bw@mail.gmail.com>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Dave Airlie <airlied@gmail.com>, Kenny Ho <Kenny.Ho@amd.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Brian Welty <brian.welty@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the late reply (I have been working on other stuff.)

On Fri, Feb 5, 2021 at 8:49 AM Daniel Vetter <daniel@ffwll.ch> wrote:
>
> So I agree that on one side CU mask can be used for low-level quality
> of service guarantees (like the CLOS cache stuff on intel cpus as an
> example), and that's going to be rather hw specific no matter what.
>
> But my understanding of AMD's plans here is that CU mask is the only
> thing you'll have to partition gpu usage in a multi-tenant environment
> - whether that's cloud or also whether that's containing apps to make
> sure the compositor can still draw the desktop (except for fullscreen
> ofc) doesn't really matter I think.
This is not correct.  Even in the original cgroup proposal, it
supports both mask and count as a way to define unit(s) of sub-device.
For AMD, we already have SRIOV that supports GPU partitioning in a
time-sliced-of-a-whole-GPU fashion.

Kenny
