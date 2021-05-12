Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F3337CC5F
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 19:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238147AbhELQol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 12:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244010AbhELQmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 12:42:23 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC28C056787;
        Wed, 12 May 2021 09:15:18 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id b15so6587785plh.10;
        Wed, 12 May 2021 09:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4dXRt3gBqmG1lnWDQNvq4bNc22ow7fsbIt7uW/qj3fQ=;
        b=DzrSBX4cBxQIUymkfhZIREDWeEUnkqcStbEHBIbNGyIV7ZGaeyX2QhZG/fu3oaEQnE
         pV1eSDourdYjCM4f/C2lzNYRbdfcJP6VNoyN8kPsuFKcoyAZdxWsVOsVQlPssil0QSfH
         Del2xpuUqsfGIcuutKAIuUCAFFo5nLaRlGoW+X2K7Gbcl8Fefa9GWpQzphdsez8JnDJa
         7PomwyhYsS5s72fiOuP9gKk24CLSPR29dIVFqYxZqgGUWRNh0sw3bltaKdw6GSTe0OMM
         aCCwGDxE5OYk9AGLVBZjADFzzvmyXfyJGCBPo6CaNE2UMb3taYAUS6vT0BTlRwHv796H
         n/bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4dXRt3gBqmG1lnWDQNvq4bNc22ow7fsbIt7uW/qj3fQ=;
        b=KAkYWv0itIHHwK6oCWK5WQA0RgEvswZe+4t1fw4txQPKqNmtasmPCRhlNT7SFO+ZVN
         DeGvlkhL5/rj4Ob3hrrSeFGp0USaW2nzUdk964jI5dfhe/srfrHbklaBp4GcPHQC0CGT
         NcqXBoSwj4rIzNnyM6BmgImzqs7l4Hsbt4AqNIzujKy4OzfJ+RShALcM0Etx589a8EYw
         IO5ptobynPa31tBzN7Ne5rB13EPa08BK6iLHLQtHZFqVa3D1IKiakQEvdGXUGO10E7ja
         Yf+5P0L1CmAyEOCO8cFJNAWAqVLvrzQ+0A311YhcJ/xubddQONuAWYnzf3OVuMk+36Z8
         p9ew==
X-Gm-Message-State: AOAM533KIHCoz/4iAnP73oAwgdd3VLSQwIHZXigJiDjfdTF1uP3Ljscb
        RqONvEjcn74pEtUbYGGzjRac+ZpV9E2lvjhbYaU=
X-Google-Smtp-Source: ABdhPJwnnQS1P8kn6kX2/fdWBq0IpBA8btxrtuDPjgZ07gZEHD80t4OjpyYLUqwCv+FRfAGG4eNrCOJRMpmybwWDyXU=
X-Received: by 2002:a17:90b:1d8a:: with SMTP id pf10mr11636606pjb.145.1620836117765;
 Wed, 12 May 2021 09:15:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210511113257.2094-1-rocco.yue@mediatek.com> <CAM_iQpVWSJ8BdRoLDX0MdiqmJn2dp+U9JM4mcfzRbVn4MZbzcg@mail.gmail.com>
 <1620808712.30754.62.camel@mhfsdcap03>
In-Reply-To: <1620808712.30754.62.camel@mhfsdcap03>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 12 May 2021 09:15:06 -0700
Message-ID: <CAM_iQpXbigquRvTF6nBM5732i_dPZ7YZX7egdRqtvydiiP-6vw@mail.gmail.com>
Subject: Re: [PATCH][v3] rtnetlink: add rtnl_lock debug log
To:     "Rocco.Yue" <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 1:38 AM Rocco.Yue <rocco.yue@mediatek.com> wrote:
>
> On Tue, 2021-05-11 at 10:00 -0700, Cong Wang wrote:
> > On Tue, May 11, 2021 at 4:46 AM Rocco yue <rocco.yue@mediatek.com> wrote:
> > >
> > > From: Rocco Yue <rocco.yue@mediatek.com>
> > >
> > > We often encounter system hangs caused by certain process
> > > holding rtnl_lock for a long time. Even if there is a lock
> > > detection mechanism in Linux, it is a bit troublesome and
> > > affects the system performance. We hope to add a lightweight
> > > debugging mechanism for detecting rtnl_lock.
> >
> > Any reason why this is specific to RTNL lock? To me holding
> > a mutex lock for a long time is problematic for any mutex.
> > I have seen some fs mutex being held for a long time caused
> > many hung tasks in the system.
> >
> > Thanks.
>
> Thank you for a good question.
>
> It's a problem to hold rtnl_lock for a long time, and other locks are no
> exception.

Then please try to make it generic so that other mutex locks will
benefit too.

Thanks.
