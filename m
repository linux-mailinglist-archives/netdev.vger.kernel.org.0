Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C47D3CD644
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 16:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240891AbhGSNUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 09:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237309AbhGSNUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 09:20:18 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C78CC061574;
        Mon, 19 Jul 2021 06:24:57 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id y7so26072595ljm.1;
        Mon, 19 Jul 2021 07:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WeegeVqvWY1KsOnYeA94i2R1jRKeSi2HU6pzHBia1vY=;
        b=So99eQ/gs1bn8C1NzBd8SPabyD4ZCKj3ZajS/lP0G4X4PpwXq39wRThJmMCu9a+6Up
         GKJdpcsT+LY9o2KBAc+/H30NVGNArKhSoWo0d5qoz2vmT5Qelk8eergP0GB7D3EmvZ2U
         SvO3ztIngEaoxdwriaY1qw+ILp/B6AYjsnKUBt66uwCgU5qK4SN0HQOmP20LiW+Jqem8
         H7Q6iFB2v9nDRTZC7KE3TEkkFPrulSWNiQ04SgV5a0iSlS3bJnP9FmjmM0Yf/090SIVM
         OzPAk3kwLZvY4XiJJ2taT4PB9Ki/UHqXUOmbZZ7eHVGXKxUX8LanghwlZ0u2DrH/9hfH
         LCSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WeegeVqvWY1KsOnYeA94i2R1jRKeSi2HU6pzHBia1vY=;
        b=E/aTMyMkH8xDAcoF2NoUV83NfulGpgKB6oqQ2/PY+Kq7Vb7y2j6ShHEN6xAy1kDZWJ
         hRSbqRdGRZRSnlcXDUMIQg6jFo3W2ClOP+O047fwzwJlV2cIf2C/vbhRedti4eVLcTWg
         K0h7CQSzpyYdvu1TRQfiKQyJz9n90xu4z6WvFDJbRTGg+ildY40Aqeq0zoSws7JKPz0A
         erS2TU703ip1H/uSf/hiYBKEHlVqRcjpJOYOm2TMinRVDY9niziT76BqgkttsouvTP6/
         5IP1J7g79mpItpnX82QEsFvKKDTviJpMBVnhNQLuIWsL/rj5T8ifAnYFKD8lae2k6HIF
         3Qkg==
X-Gm-Message-State: AOAM5332CHsBriAvVRdCpUYlh4ZOCKPgFbSGdjDZe0SS+CfAPxsUqHN3
        pGfi9sabbuh+FpTsfwnFWMkkl0+7M2UYwQhI2jY=
X-Google-Smtp-Source: ABdhPJwlwfIvWuyaD9SoREAILxicy9oLfT3hKqpPVpGKBmgTZ6QQfkVP8vtoihfqBXrrqF1TMtjiuW1AQG/pIkHabCA=
X-Received: by 2002:a2e:9c02:: with SMTP id s2mr22216361lji.299.1626703253806;
 Mon, 19 Jul 2021 07:00:53 -0700 (PDT)
MIME-Version: 1.0
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com> <9123bca3-23bb-1361-c48f-e468c81ad4f6@virtuozzo.com>
In-Reply-To: <9123bca3-23bb-1361-c48f-e468c81ad4f6@virtuozzo.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
Date:   Mon, 19 Jul 2021 15:00:42 +0100
Message-ID: <CAJwJo6ZgXDoXevNRte4G3Phei8WcgJ897JebWDkQDnPYrgTTQA@mail.gmail.com>
Subject: Re: [PATCH v5 02/16] memcg: enable accounting for IP address and
 routing-related objects
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Roman Gushchin <guro@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vasily,

On Mon, 19 Jul 2021 at 11:45, Vasily Averin <vvs@virtuozzo.com> wrote:
[..]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ae1f5d0..1bbf239 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -968,7 +968,7 @@ static __always_inline bool memcg_kmem_bypass(void)
>                 return false;
>
>         /* Memcg to charge can't be determined. */
> -       if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
> +       if (!in_task() || !current->mm || (current->flags & PF_KTHREAD))
>                 return true;

This seems to do two separate things in one patch.
Probably, it's better to separate them.
(I may miss how route changes are related to more generic
__alloc_pages() change)

Thanks,
           Dmitry
